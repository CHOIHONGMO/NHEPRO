package com.st_ones.nhepro.REGISTER.service;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.st_ones.common.docNum.service.DocNumService;
import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.common.sms.service.EverSmsService;
import com.st_ones.common.util.clazz.EverConverter;
import com.st_ones.common.util.clazz.EverEncryption;
import com.st_ones.common.util.clazz.EverFile;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.nhepro.REGISTER.REG_Mapper;

/**
 * The type REG _ service.
 */
@Service(value = "REG_Service")
public class REG_Service {

    private static Logger logger = LoggerFactory.getLogger(REG_Service.class);

    @Autowired
    private REG_Mapper reg_mapper;
    @Autowired
    private DocNumService docNumService;
    @Autowired
    private EverSmsService everSmsService;

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public void doSave(Map<String, Object> param) throws Exception {

        UserInfo userInfo = UserInfoManager.getUserInfoImpl();
        List<Map<String, Object>> brAllUserList = new ArrayList<Map<String, Object>>();

        if (!"3".equals(param.get("CASE"))) {
            //공급사 신규등록시 상태값 셋팅
            param.put("PROGRESS_CD", "J");    //J  : 가입요청
            param.put("SIGN_STATUS", "T");

            String companyCd = "";
            // 협력업체
            if ("S".equals(param.get("USER_TYPE"))) {
                if(!EverString.nullToEmptyString(param.get("VENDOR_CD")).equals("")) {
                    reg_mapper.doDeleteVNCM(param);
                    reg_mapper.doDeleteVNFI(param); // 삭제여부 = 1
                    reg_mapper.doDeleteVNAP(param);
                    reg_mapper.doDeleteVNSL(param);
                    reg_mapper.doDeleteATTS(param);

                    companyCd = String.valueOf(param.get("VENDOR_CD"));
                    param.put("COMPANY_CD", param.get("VENDOR_CD"));
                } else {
                    companyCd = docNumService.getDocNumber(userInfo.getManageCd(), "VENDOR");
                    param.put("COMPANY_CD", companyCd);
                }

                // 기본정보 / 관리정보 - VNGL (MERGE UPDATE)
                reg_mapper.doInsertVNGL(param);

                //  거래희망 고객사 - VNCM (MERGE UPDATE)
                List<Map<String, Object>> buyerInfoList = EverConverter.readJsonObject(EverConverter.getJsonString(param.get("BUYER_INFO")), List.class);
                if (buyerInfoList != null && buyerInfoList.size() > 0) {
                    for (Map<String, Object> buyerInfo : buyerInfoList) {
                        buyerInfo.put("VENDOR_CD", companyCd);
                        // 수헌이사님 요청으로 부서 제외
                        buyerInfo.put("DEPT_CD", "O");
                        reg_mapper.doInsertVNCM(buyerInfo);

                        List<Map<String, Object>> brUserList = reg_mapper.getBrUserList(buyerInfo);
                        brAllUserList.addAll(brUserList);
                    }
                }

                // 협력사 회원가입일 경우에만 SMS 전송(거래희망 고객사의 직무권한 BR090(협력업체담당자) 조회)
                for (Map<String, Object> brUserInfo : brAllUserList) {
                    Map<String, String> smsMap = new HashMap<String, String>();
                    smsMap.put("CONTENTS", "[전자구매시스템] 협력사 [" + param.get("VENDOR_NM") + "]이 등록요청 하였습니다");
                    smsMap.put("REF_MODULE_CD", "SVD01");
                    smsMap.put("RECV_USER_ID", String.valueOf(brUserInfo.get("CTRL_USER_ID")));
                    
                    Map<String, String> costInfo = reg_mapper.costSmsInfo(brUserInfo);
                    smsMap.put("CORP_NO", costInfo.get("CORP_NO"));     	// 고객사 사업자번호
                    smsMap.put("BRC", costInfo.get("BRC"));            		// 고객사 부서
                    smsMap.put("EPRO_PS_DSC", "1");     					// 1  : 구매
                    smsMap.put("EPRO_RATE_DSC", "01");  					// 01 : 최초
                    smsMap.put("APLY_DT", costInfo.get("APLY_DT"));     	// 발생일 YYYYMMDD
                    smsMap.put("USER_ID", costInfo.get("USER_ID"));     	// 고객사 보내는사람 ID
                    smsMap.put("CONT_TBL_ID", "STOCVNCM");              	// 검증 테이블
                    smsMap.put("CONT_TBL_PK", costInfo.get("CONT_TBL_PK")); // 검증 조건
                    smsMap.put("tmp", costInfo.get("CONT_TBL_PK"));         // 유니크한 값.
                    smsMap.put("payFlag", "Y");
                    
                    everSmsService.sendSmsNhe(smsMap);
                }
            } // 고객사
            else {
                companyCd = docNumService.getDocNumber(userInfo.getManageCd(), "CUST");
                param.put("COMPANY_CD", companyCd);
                // 기본정보 / 관리정보 - VNGL
                reg_mapper.doInsertCUST(param);
            }
            
            // 재무정보 - VNFI (MERGE UPDATE)
            reg_mapper.doInsertVNFI(param);

            // 결재정보 - VNAP (DELETE INSERT)
            List<Map<String, Object>> payInfoList = EverConverter.readJsonObject(EverConverter.getJsonString(param.get("PAY_INFO")), List.class);
            if (payInfoList != null && payInfoList.size() > 0) {
                for (Map<String, Object> payInfo : payInfoList) {
                    payInfo.put("COMPANY_CD", companyCd);
                    reg_mapper.doInsertVNAP(payInfo);
                }
            }

            // 특허 및 면허취급 - VNSL (DELETE INSERT)
            List<Map<String, Object>> slInfoList = EverConverter.readJsonObject(EverConverter.getJsonString(param.get("SL_INFO")), List.class);
            if (slInfoList != null && slInfoList.size() > 0) {
                for (Map<String, Object> slInfo : slInfoList) {
                    slInfo.put("COMPANY_CD", companyCd);
                    reg_mapper.doInsertVNSL(slInfo);
                }
            }

            // 첨부파일 - ATTS (DELETE INSERT)
            List<Map<String, Object>> attsAttFileList = EverConverter.readJsonObject(EverConverter.getJsonString(param.get("ATTS_ATT_FILE_INFO")), List.class);
            if (attsAttFileList != null && attsAttFileList.size() > 0) {
                for (Map<String, Object> attsAttFile : attsAttFileList) {
                    attsAttFile.put("COMPANY_CD", companyCd);
                    attsAttFile.put("DOC_TYPE", "S".equals(param.get("USER_TYPE")) ? "D02" : "D01");
                    reg_mapper.doInsertATTS(attsAttFile);
                }
            }

            // 저장 완료 후 파일 이동
            doFileMovie(param);
        }

        // 사용자처음 등록 시 프로파일 등록
        if ("S".equals(param.get("USER_TYPE"))) {
            param.put("AUTH_CD", "PF0132");
        } else if ("B".equals(param.get("USER_TYPE"))) {
            param.put("AUTH_CD", "PF0131");
        }
        reg_mapper.userInsertUSAP(param);

        // 협력업체 담당자 저장
        param.put("PASSWORD", EverEncryption.getEncryptedUserPassword(String.valueOf(param.get("PPDD"))));
        param.put("PROGRESS_CD", "P");
        param.put("USE_FLAG", "1");
        // 2021.05.26 협력업체 최초 가입 사용자 등록 시 관리자 여부 1로 insert되도록 
        param.put("MNG_YN", "1");
        reg_mapper.userInsertCVUR(param);
    }

    public int userIdCheck(Map<String, String> param) throws Exception {
        return reg_mapper.userIdCheck(param);
    }

    public Map<String, String> userCompanyInfo(Map<String, String> param) {
        return reg_mapper.userCompanyInfo(param);
    }

    // 첨부파일
    public List<Map<String, Object>> doSearchATTD(Map<String, String> param) {
        return reg_mapper.doSearchATTD(param);
    }
    
    // 협력업체 회원가입 저장 완료 후 첨부파일 이동하기
    // supplier_0000 ==> VENDOR_CD_0000
    public void doFileMovie(Map<String, Object> param) throws Exception {
        String attFileNum = "";
        String vnfiAttFileNum = String.valueOf(param.get("VNFI_ATT_FILE_NUM"));	// 재무정보 파일
        String evAttFileNum   = String.valueOf(param.get("EV_ATT_FILE_NUM"));	// 관리정보 파일
        
        if( StringUtils.isNotEmpty(vnfiAttFileNum) ) {
        	attFileNum += vnfiAttFileNum + ",";
        }
        if( StringUtils.isNotEmpty(evAttFileNum) ) {
        	attFileNum += evAttFileNum + ",";
        }
        List<Map<String, Object>> attsAttFileList = EverConverter.readJsonObject(EverConverter.getJsonString(param.get("ATTS_ATT_FILE_INFO")), List.class);
        
        int i = 1;
        if (attsAttFileList != null && attsAttFileList.size() > 0) {
            for (Map<String, Object> attsAttFile : attsAttFileList) {
            	String attsAttFileNum = String.valueOf(attsAttFile.get("ATTS_ATT_FILE_NUM"));
            	if( StringUtils.isNotEmpty(attsAttFileNum) ) {
                    if (attsAttFileList.size() == i) {
                        attFileNum += attsAttFileNum;
                    } else {
                        attFileNum += attsAttFileNum + ",";
                    }
                    i++;
            	}
            }
        }
        //System.out.println(String.valueOf(param.get("COMPANY_CD")) + "의 전체 파일1 =====> " + attFileNum);
        
        if( StringUtils.isNotEmpty(attFileNum) ) {
	        String type = "";
	        String companyCd = String.valueOf(param.get("COMPANY_CD"));
	        if ("1".equals(param.get("CASE"))) {
	            type = "supplier";
	        } else if ("2".equals(param.get("CASE"))) {
	            type = "customer";
	        }
	        
	        Map<String, Object> fileMap = new HashMap<>();
	        fileMap.put("ATT_FILE_NUM", Arrays.asList(attFileNum.split(",")));
	        //System.out.println(String.valueOf(param.get("COMPANY_CD")) + "의 전체 파일2 =====> " + attFileNum);
	        
	        // 파일 조회 후 이동
	        List<Map<String, Object>> fileInfoList = reg_mapper.doFileInfo(fileMap);
	        System.out.println(String.valueOf(param.get("COMPANY_CD")) + "의 실재 파일(STOCATCH) =====> " + fileInfoList);
	        if (fileInfoList != null && fileInfoList.size() > 0) {
	            for (Map<String, Object> fileInfo : fileInfoList) {
	                String sourceFile = fileInfo.get("FILE_PATH") + "/" + fileInfo.get("FILE_NM") + "." + fileInfo.get("FILE_EXTENSION");
	                String targetFile = String.valueOf(fileInfo.get("FILE_PATH")).replace(type, companyCd) + "/" + fileInfo.get("FILE_NM") + "." + fileInfo.get("FILE_EXTENSION");
	                String dirPath = String.valueOf(fileInfo.get("FILE_PATH")).replace(type, companyCd);
	                System.out.println(String.valueOf(param.get("COMPANY_CD")) + "의 소스파일(sourceFile) =====> " + sourceFile);
	                System.out.println(String.valueOf(param.get("COMPANY_CD")) + "의 타겟파일(targetFile) =====> " + targetFile);
	                
	                if( !sourceFile.equals(targetFile) ) {
		                // 폴더 존재하는지 여부를 판단하여 생성
		                EverFile.makeDir(dirPath);
		                
		                // 파일 복사
		                EverFile.copyFile(sourceFile, targetFile);
		                
		                // 복사 된 파일 삭제
		                // EverFile.deleteFile(sourceFile);
		                
		                // 완료 후 ATCH PATH 변경
		                fileInfo.put("DIR_PATH", dirPath);
		                reg_mapper.doFileUpdate(fileInfo);
	                }
	            }
	        }
        }
    }

    public Map<String, String> doSearchVNGL(Map<String, String> param) {
        return reg_mapper.doSearchVNGL(param);
    }

    public List<Map<String, Object>> doSearchVNSL(Map<String, String> param) {
        return reg_mapper.doSearchVNSL(param);
    }

    public Map<String, String> doSearchVNFI(Map<String, String> param) {
        return reg_mapper.doSearchVNFI(param);
    }

    public List<Map<String, Object>> doSearchVNAP(Map<String, String> param) {
        return reg_mapper.doSearchVNAP(param);
    }

    public List<Map<String, Object>> doSearchVNCM(Map<String, String> param) {
        return reg_mapper.doSearchVNCM(param);
    }

    public Map<String, String> doSearchCVUR(Map<String, String> param) {
        return reg_mapper.doSearchCVUR(param);
    }

    public List<Map<String, Object>> doSearchATTS(Map<String, String> param) {
        return reg_mapper.doSearchATTS(param);
    }
}