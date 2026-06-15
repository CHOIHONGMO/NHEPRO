package com.st_ones.batch.nhebatch.service;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.st_ones.batch.nhebatch.BNH0001_Mapper;
import com.st_ones.batch.nhebatch.InterFaceCommon;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.everf.serverside.config.PropertiesManager;

@Service(value = "bnh0001_service")
public class BNH0001_Service {

	@Autowired private MessageService msg;
	@Autowired private BNH0001_Mapper bnh0001Mapper;

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String doExecService(Map<String, String> param) throws Exception {
		
		System.err.println("==========================================BNH0001_Service===================================================");
        String targetFolder   = PropertiesManager.getString("eversrm.interface.folder.BNH0001");
        String completeFolder = PropertiesManager.getString("eversrm.interface.folder.BNH0001.complete");
        
        File dir = new File(targetFolder);
		File[] fileList = dir.listFiles(); // 타겟폴더에서 파일리스트를 가져온다.
		if(fileList == null) {
			return msg.getMessage("0001"); // 타겟 폴더가 없으면
		}
		
		boolean orgFlag = true;
		for(int k = 0; k < fileList.length; k++) {
			File file = fileList[k];
			
			// dat 파일만 처리(dat, chk 파일이 쌍으로 있어야 함)
			if (!file.isFile() || !InterFaceCommon.escapeChkFile(file)) {
				continue;
			}
			
			System.err.println("file.getName() =======================================> " + file.getName());
			if(file.getName().indexOf("BPGIS00102") > -1 || file.getName().indexOf("BPGIS60001") > -1) {// 조직정보(일반, 계열사)
				// TB_CO_ORGZ(조직-부서) 데이터 삭제
				if(orgFlag) {
					bnh0001Mapper.doDelTbCoOrgz(new HashMap());
					orgFlag = false;
				}
				
				List<Map<String,String>> list = new ArrayList<>();
				if(file.getName().indexOf("BPGIS00102") > -1) { // 조직정보(일반)
					list = InterFaceCommon.parseFile(completeFolder,file,"\\|",16,"DEPT_C,ONL_C,UP_DEPT_C,DEPT_NM,SQNO,STSC,NH_CORP_CODE,GIRO_C,CORP_NO,ADDR,ZIP,REP_TEL,CUST_TEL,FAX,DOC_DEPT_C,PROV_C");
				} else { // 조직정보(계열사)
					list = InterFaceCommon.parseFile(completeFolder,file,"\\|",17,"DEPT_C,ONL_C,UP_DEPT_C,DEPT_NM,SQNO,STSC,NH_CORP_CODE,GIRO_C,CORP_NO,ADDR,ZIP,REP_TEL,CUST_TEL,FAX,DOC_DEPT_C,PROV_C,SUB_BRC");
				}
				
				for( Map<String,String> data : list ) {
					bnh0001Mapper.doInsTbCoOrgz(data);
				}
				
				file.renameTo(new File(completeFolder + file.getName()));
				File chkFileName = new File(file.getAbsolutePath().substring(0, file.getAbsolutePath().indexOf(".")) + ".chk");
				chkFileName.renameTo(new File(completeFolder + chkFileName.getName()));
			}
			else if(file.getName().indexOf("BPGIS00202") > -1) { // 인사정보
				// TB_CO_INSA(인사-사용자) 데이터 삭제
				bnh0001Mapper.doDelTbCoInsa(new HashMap());
				
				List<Map<String,String>> listTotal = InterFaceCommon.parseFileInsa(file,"\\|",18,"USER_ID,USER_NM,DEPT_C,DEPT_NM,EMP_STSC,GNAF_DSC,EMPL_DSC,DWIN_TEL,REP_TEL,CUST_TEL,HP_NO,EMAIL,CHRG_BSN_NM,DTI_CHRG_BSN_NM,OFT_C,OFT_NM,PZC_C,PZC_NM");
				
				int totalCout = listTotal.size();
				int start = 0;
				int end   = 1500;
				int inc   = 1500;
				while(true) {
					System.err.println("startNum =======================================> " + start + ", endNum : " + end);
					List<Map<String,String>> list = new ArrayList<>(listTotal.subList(start, end));
					
					Map<String, Object> objectMap = new HashMap<String,Object>();
					objectMap.put("list", list);
					bnh0001Mapper.doInsTbCoInsa(objectMap);
					list.clear();
					
					start = end;
					if (end == totalCout) {
						break;
					}
					if(end + inc < totalCout) {
						end = end + inc;
					} else {
						end = totalCout;
					}
				}
				System.err.println("startNum ==================END=====================> " + start + ", endNum : " + end);
				
				// 인사정보 암호화(전화번호, 이메일 주소 등)
				bnh0001Mapper.doUpsTbCoInsa(new HashMap());
				
				file.renameTo(new File(completeFolder + file.getName()));
				File chkFileName = new File(file.getAbsolutePath().substring(0, file.getAbsolutePath().indexOf(".")) + ".chk");
				chkFileName.renameTo(new File(completeFolder + chkFileName.getName()));
			}
		}
		
		return msg.getMessage("0001");
	}
	
	//인터페이스 배치 한뒤 배치로그 정보 등록
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String doSaveBatchLog(Map<String, Object> logData) throws Exception {
		bnh0001Mapper.doSaveBatchLog(logData);
		return msg.getMessage("0001");
	}
}
