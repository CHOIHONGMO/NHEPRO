package com.st_ones.nhepro.CCPR.service;

import java.util.ArrayList;
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
import org.springframework.web.bind.annotation.RequestMapping;

import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.common.mail.service.EverMailService;
import com.st_ones.common.sms.service.EverSmsService;
import com.st_ones.common.util.clazz.EverEncryption;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.nhepro.CCPR.CCPR0900_Mapper;
import com.st_ones.nhepro.CCTR.CCTI0090_Mapper;
import com.st_ones.nhepro.CCTR.service.CCTI0090_Service;

@Service(value = "CCPR0900_Service")
public class CCPR0900_Service {
	
	private static Logger logger = LoggerFactory.getLogger(CCTI0090_Service.class);
	
    @Autowired private CCPR0900_Mapper ccpr0900_Mapper;
    @Autowired private EverMailService everMailService;
    @Autowired private EverSmsService everSmsService;
	
 	// 개인근로자 계약진행현황(CCTR0100) 조회
 	public List<Map<String, Object>> cctr0100_doSearch(Map<String, String> param) throws Exception {
 		param.put("PROGRESS_CD", EverString.forInQuery(param.get("PROGRESS_CD"), ","));
 		param.put("SIGN_STATUS", EverString.forInQuery(param.get("SIGN_STATUS"), ","));

 		List<Map<String, Object>> gridList = ccpr0900_Mapper.ccpr0900_doSearch(param);
 		return gridList;
 	}
 	
  	// 개인근로자의 승인 및 반려
  	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
  	public void ccpr0900_doConfirm(Map<String, String> param, List<Map<String, Object>> gridData) throws Exception {
  		
  		String progressCd = param.get("PROGRESS_CD");
  		for (Map<String, Object> rowData : gridData) {
  			//1. 개인근로자 승인 및 반려
  	 		rowData.put("PROGRESS_CD", progressCd);
  			ccpr0900_Mapper.ccpr0900_doConfirm(rowData); // 개인근로자 승인 및 반려
  			
  			// 반려인 경우 개인근로자에게 메일, SMS 보내기
  			if ("R".equals(progressCd)) {
	  			//2. 개인근로자에게 메일/SMS 전송
	  	 		String linkUrl = PropertiesManager.getString("eversrm.urls.maintain.real") + "/mobileNHPT/";
	  			//2-1. 메일 전송
	 			if( EverString.isNotEmpty(String.valueOf(rowData.get("EMAIL"))) && !"null".equals(String.valueOf(rowData.get("EMAIL"))) ) {
	 				try {
	                    String content = "<BR> 안녕하십니까!" +
	                            "<BR> [" + String.valueOf(rowData.get("USER_NM")) + "]님" +
	                            "<BR> " +
	                            "<BR> 귀하께서 요청하신 개인근로자 요청이 반려되었습니다." +
	                            "<BR> " +
	                            "<BR> 전자구매시스템에 <a href='" + linkUrl + "' target='newP'>접속</a> 하시어, 다시 회원가입을 잔행해주세요." +
	                            "<BR> " +
	                            "<BR> 감사합니다.";
	                    
	 					Map<String, String> mailMap = new HashMap<>();
	 					mailMap.put("SUBJECT", "[전자구매시스템] 개인근로자 요청서 반려");
	                    mailMap.put("CONTENTS", content);
	                    mailMap.put("RECV_USER_ID", String.valueOf(rowData.get("USER_ID"))); // 수신자ID : 개인근로자ID
	                    mailMap.put("DIRECT_TARGET", String.valueOf(rowData.get("EMAIL")));
	 					mailMap.put("DIRECT_USER_NM", String.valueOf(rowData.get("USER_NM")));
	 					mailMap.put("REF_MODULE_CD", "PC");
	 					mailMap.put("REF_NUM", String.valueOf(rowData.get("USER_ID")));
	
	 					everMailService.SendMail(mailMap);
	 				}
	 				catch (Exception ex) {
	 					logger.error("개인근로자 요청반려 MAIL 발송 오류 : " + ex);
	 				}
	 			}
	
	 			//2-2. SMS 전송
	 			if( EverString.isNotEmpty(String.valueOf(rowData.get("CELL_NUM"))) && !"null".equals(String.valueOf(rowData.get("CELL_NUM"))) ) {
	 				try {
	 					Map<String, String> smsMap = new HashMap<String, String>();
	 					
	 					smsMap.put("CONTENTS", "[전자구매시스템] 귀하께서 요청하신 개인근로자 요청서가 반려되었습니다.");
	                    smsMap.put("REF_MODULE_CD", "PC");
	                    smsMap.put("RECV_USER_ID", String.valueOf(rowData.get("USER_ID")));
	                    smsMap.put("DIRECT_TARGET", String.valueOf(rowData.get("CELL_NUM")));
	 					smsMap.put("DIRECT_USER_NM", String.valueOf(rowData.get("USER_NM")));
	                    
	 					// 2021.07.01 : 개인근로자 반려 후 SMS 수수료 부과
	 					Map<String, String> costInfo = ccpr0900_Mapper.costPersonalInfo(rowData);
	 					smsMap.put("CORP_NO", costInfo.get("CORP_NO"));			// 고객사 사업자번호
	 					smsMap.put("BRC", costInfo.get("BRC"));					// 고객사 부서
	 					smsMap.put("EPRO_PS_DSC", "1");							// 1  : 구매
	 	                smsMap.put("EPRO_RATE_DSC", "01");						// 01 : 최초
	 					smsMap.put("APLY_DT", costInfo.get("APLY_DT"));			// 발생일 YYYYMMDD
	 					smsMap.put("USER_ID", costInfo.get("USER_ID"));			// 고객사 보내는사람 ID
	 					smsMap.put("CONT_TBL_ID", "STOCCVUR");					// 검증 테이블
	 					smsMap.put("CONT_TBL_PK", costInfo.get("CONT_TBL_PK")); // 검증 조건(협력사별 입찰번호)
	 					smsMap.put("tmp", costInfo.get("CONT_TBL_PK"));			// myBatis 버그 해결을 위한 무의미한, 유니크한 값.
	 					smsMap.put("payFlag", "Y");
	 					
	 					everSmsService.sendSmsNhe(smsMap);
	 				}
	 				catch (Exception ex) {
	 					logger.error("개인근로자 요청반려 SMS 발송 오류 : " + ex);
	 				}
	 			}
  			}
  		}
  	}
  	
 	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
 	public Map<String, String> ccpr0900_doSave(Map<String, String> formData, List<Map<String, Object>> gridData) throws Exception {

  		for (Map<String, Object> rowData : gridData) {
  			ccpr0900_Mapper.ccpr0900_doUpdate(rowData);
 		}

 		return formData;
 	}
 	
 	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
 	public void ccpr0900_doUpdate(List<Map<String, Object>> listTotal) throws Exception {
 		
		int totalCount = listTotal.size();
		
		for(int i = 0; i < totalCount; i++) {
			System.err.println("startNum =======================================> " + i);
			Map<String, Object> list = listTotal.get(i);
			
			String password = (String)list.get("sabun");
			if (!"".equals(EverString.nullToEmptyString(password))) {
	            list.put("PASSWORD", EverEncryption.getEncryptedUserPassword(password));
	        }
			
			int value = ccpr0900_Mapper.ccpr0900_doEmpInsert(list);
			//System.out.println("===============================================> " + value);
			
			if(value == 0) {
				ccpr0900_Mapper.ccpr0900_doEmpUpdate2(list);
				ccpr0900_Mapper.ccpr0900_doEmpUpdate(list);
			}
			else {
				list.put("REG_IP_ADDR", EverString.getClientIP());
				ccpr0900_Mapper.ccpr0900_InsertPW(list);
			}
			
			list.clear();

		}
 	}
 	

}
