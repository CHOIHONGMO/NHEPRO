package com.st_ones.batch.nhebatch.service;

import java.io.File;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.st_ones.batch.nhebatch.BNH0013_Mapper;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.eversrm.eApproval.eApprovalModule.BAPM_Mapper;

/**
 *
 * @author divin
 *
 */
@Service(value = "BNH0013_Service")
public class BNH0013_Service {
	@Autowired private MessageService msg;
	@Autowired private BNH0013_Mapper bnh0013mapper;
	@Autowired private BAPM_Mapper bapm_Mapper;

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String doExecService(Map<String, String> param) throws Exception {
		
		System.err.println("==========================================BNH0013_Service===================================================");
		int failCnt = 0;
		String failString = "";
		List<Map<String, String>> fileList = bnh0013mapper.getTagrgetData(param);
		
		for(Map<String, String> data : fileList) {
			
			//실물파일존재확인
			File atchFile = new File(data.get("FILE_PATH")+"/"+data.get("FILE_NM")+"."+data.get("FILE_EXTENSION"));
			if (atchFile.exists()) {
				data.put("EPRO_WRS_DS", "70");		/* 상품코드 */	// epro_wrs_ds [상품코드] - 10 : RFI, 20 : 입찰, 30 : 일반입찰계약, 40 : 일반수의계약, 50 : BtoC계약, 60 : 위임계약, 70 : 문서보관, 80 : SMS, 90 : LMS, 100 : 문서생성
				data.put("EPRO_RATE_DSC", "01");	/* 단가코드 */	// epro_rate_dsc [단가코드] - 01 : 최초, 02 : 재입찰/재계약/재요청
				data.put("CONT_TBL_ID", "STOCATCH");/* 계약테이블ID */
				// CONT_TBL_PK : 해당 Table에 Data 존재유무를 조회해볼 수 있는 Key 값. GATE_CD || '@@' || BUYER_CD || '@@' || ... 와 같이 설정.
				data.put("tmp", ""); 				// myBatis 버그 해결을 위한 무의미한, 유니크한 값. 단, EPRO_WRS_DS = '30' 또는 '40'일 때 반드시 계약금액을 넣어야 함.
				
				bapm_Mapper.putBkCost(data);
				if( !data.get("RESULT_STR").equals("OK") ) {
					failCnt++;
					failString += data.get("UUID") + "@@" + data.get("UUID_SQ") + " : " + data.get("RESULT_STR") + "<br/>";
					
					data.put("FEE_ETC", "1");	/* 0:정상, 1:수수료처리실패, 2:실물파일없음 */					
				} else {
					data.put("FEE_ETC", "0");	/* 0:정상, 1:수수료처리실패, 2:실물파일없음 */					
				}
			} else {
				failCnt++;
				data.put("FEE_ETC", "2");	/* 0:정상, 1:수수료처리실패, 2:실물파일없음 */									
			}		
			
			bnh0013mapper.upsComplete(data);			
			
		}
				
		String returnMsg = msg.getMessage("0001");
		if( failCnt > 0 ) {
			returnMsg = "수수료부과 오류 : (" + failCnt + " 건) " + failString;
		}
		
		return returnMsg;
	}
}
