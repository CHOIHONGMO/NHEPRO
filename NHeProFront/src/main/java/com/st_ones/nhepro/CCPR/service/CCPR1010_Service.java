package com.st_ones.nhepro.CCPR.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.st_ones.common.docNum.service.DocNumService;
import com.st_ones.common.mail.service.EverMailService;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.sms.service.EverSmsService;
import com.st_ones.common.util.clazz.EverEncryption;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.util.clazz.AuthorityIgnore;
import com.st_ones.eversrm.eApproval.eApprovalModule.service.BAPM_Service;
import com.st_ones.nhepro.CCPR.CCPR1010_Mapper;
import com.st_ones.nhepro.CCTR.CCTI0090_Mapper;
import com.st_ones.nhepro.CCTR.service.CCTI0090_Service;

@Service(value = "CCPR1010_Service")
public class CCPR1010_Service {
	private static Logger logger = LoggerFactory.getLogger(CCTI0090_Service.class);
	
    @Autowired private CCPR1010_Mapper ccpr1010_Mapper;
    @Autowired private BAPM_Service approvalService;
    @Autowired private EverMailService everMailService;
    @Autowired private EverSmsService everSmsService;
    @Autowired private DocNumService docNumService;
    @Autowired private MessageService msg;

 	// 개인근로자 계약진행현황(CCPR1010) 조회
 	public List<Map<String, Object>> ccpr1010_doSearch(Map<String, String> param) throws Exception {
 		param.put("PROGRESS_CD", EverString.forInQuery(param.get("PROGRESS_CD"), ","));
 		param.put("SIGN_STATUS", EverString.forInQuery(param.get("SIGN_STATUS"), ","));

 		List<Map<String, Object>> gridList = ccpr1010_Mapper.ccpr1010_doSearch(param);
 		return gridList;
 	}
 	
 	// 현장명 팝업(CCPR0010) 조회
 	public List<Map<String, Object>> ccpr0010_doSearch(Map<String, String> param) throws Exception {

 		List<Map<String, Object>> gridList = ccpr1010_Mapper.ccpr0010_doSearch(param);
 		return gridList;
 	}
 	
 	// 계약체결진행현황(CCTR0100) : 개인근로자 전자서명 직접 요청하기
 	@AuthorityIgnore
 	public String ccpr1010_doRequest(List<Map<String, Object>> gridData) throws Exception {

 		String linkUrl = PropertiesManager.getString("eversrm.urls.maintain.real") + "/mobileNHPT/";
 		
 		for (Map<String, Object> rowData : gridData) {
 			
 			rowData.put("SEND_YN", "1");
 			ccpr1010_Mapper.ccpr1010_doSendYn(rowData);
 			
 			String contMngNum = (String)rowData.get("CONT_NUM");
 			String userID = (String)rowData.get("USER_ID");
 			//메일전송
 			if( EverString.isNotEmpty(String.valueOf(rowData.get("EMAIL"))) && !"null".equals(String.valueOf(rowData.get("EMAIL"))) ) {
 				try {
 					Map<String, String> mailMap = new HashMap<>();
 					mailMap.put("SUBJECT", "[전자근로계약시스템] 신규 계약 체결 검토 요청");
 					
 					String contDesc = String.valueOf(rowData.get("CONT_DESC"));
                    String content = "<BR> 안녕하십니까!" +
                            "<BR> [" + String.valueOf(rowData.get("USER_NM")) + "]님" +
                            "<BR> " +
                            "<BR> 귀하에게 새로운 계약 체결 건이 전송 되었습니다." +
                            "<BR> 회사 	 	: [" + String.valueOf(rowData.get("BUYER_NM")) + "]" +
                            "<BR> 계약번호		: [" + contMngNum + "]" +
                            "<BR> 계약명		: [" + contDesc + "]" +
                            "<BR> 계약담당자	: [" + String.valueOf(EverString.nullToEmptyString(rowData.get("DEC_CONT_USER_NM"))) + " (TEL : " + String.valueOf(EverString.nullToEmptyString(rowData.get("DEC_CONT_TEL_NUM"))) + ") ]" +
                    		"<BR> " +
                            "<BR> 전자근로계약시스템에 <a href='" + linkUrl + "' target='newP'>로그인</a> 하시어, 세부내용을 확인 후 처리 해주십시오." +
                            "<BR> " +
                            "<BR> 감사합니다.";
                    
                    mailMap.put("CONTENTS", content);
                    mailMap.put("RECV_USER_ID", String.valueOf(rowData.get("USER_ID"))); // 수신자ID : 개인근로자ID
 					mailMap.put("DIRECT_TARGET", String.valueOf(rowData.get("EMAIL")));
 					mailMap.put("DIRECT_USER_NM", String.valueOf(rowData.get("USER_NM")));
 					mailMap.put("REF_MODULE_CD", "PC");
 					mailMap.put("REF_NUM", contMngNum);
 					System.out.println("===========================================================");
 					System.out.println(content);
 					System.out.println("===========================================================");
 					everMailService.SendMail(mailMap);
 				}
 				catch (Exception ex) {
 					logger.error("개인근로자 신규 계약 체결 검토 요청 MAIL 발송 오류 : " + ex);
 				}
 			}
 			 
 			// SMS 전송
 			if( EverString.isNotEmpty(String.valueOf(rowData.get("CELL_NUM"))) && !"null".equals(String.valueOf(rowData.get("CELL_NUM"))) ) {
 				try {
 					Map<String, String> smsMap = new HashMap<String, String>();
 					
 					String content = "[전자근로계약시스템] 계약 체결 건이 전송 되었습니다. 계약서 내용 검토 바랍니다.(계약번호 : " + contMngNum + ")" +
 							"전자구매시스템에 로그인하시어, 세부내용을 확인 후 처리 해주십시오. " +
 							"(아이폰 사용자의 경우 Chrome 브라우저 사용 권장)" +
 							" 아이디 : [" + userID + "]" +
                            " 초기 비밀번호는 아이디와 동일(단, 모바일 가입자의 경우 제외) " + 
 							 linkUrl +
                            " 감사합니다.";
 								
 					smsMap.put("CONTENTS", content);
 					smsMap.put("REF_MODULE_CD", "TC");
 					smsMap.put("RECV_USER_ID", String.valueOf(rowData.get("USER_ID")));
 					smsMap.put("DIRECT_TARGET", String.valueOf(rowData.get("CELL_NUM")));
 					smsMap.put("DIRECT_USER_NM", String.valueOf(rowData.get("USER_NM")));
 					
 					// 2021.07.01 : 개인근로자 계약체결 요청 후 SMS 수수료 부과
 					rowData.put("SMS_GUBUN", "REQ");
 					Map<String, String> costInfo = ccpr1010_Mapper.costSmsInfo(rowData);
 					smsMap.put("CORP_NO", costInfo.get("CORP_NO"));			// 고객사 사업자번호
 					smsMap.put("BRC", costInfo.get("BRC"));					// 고객사 부서
 					smsMap.put("EPRO_PS_DSC", "1");							// 1  : 구매
 					smsMap.put("EPRO_WRS_DS", "52");		// epro_wrs_ds [상품코드] - 10 : RFI, 20 : 입찰, 30 : 일반입찰계약, 40 : 일반수의계약, 50 : BtoC계약, 60 : 위임계약, 70 : 문서보관, 80 : SMS, 90 : LMS, 100 : 문서생성
 	                smsMap.put("EPRO_RATE_DSC", "01");						// 01 : 최초
 					smsMap.put("APLY_DT", costInfo.get("APLY_DT"));			// 발생일 YYYYMMDD
 					smsMap.put("USER_ID", costInfo.get("USER_ID"));			// 고객사 보내는사람 ID
 					smsMap.put("CONT_TBL_ID", "STOTCCT");					// 검증 테이블
 					smsMap.put("CONT_TBL_PK", costInfo.get("CONT_TBL_PK")); // 검증 조건(협력사별 입찰번호)
 					smsMap.put("tmp", costInfo.get("CONT_TBL_PK"));			// myBatis 버그 해결을 위한 무의미한, 유니크한 값.
 					//smsMap.put("payFlag", "N");
 					smsMap.put("payFlag", "Y");
 					System.out.println("===========================================================");
 					System.out.println(content);
 					System.out.println("===========================================================");
 					everSmsService.sendSmsNhe(smsMap);
 				}
 				catch (Exception ex) {
 					logger.error("개인근로자 신규 계약 체결 검토 요청 SMS 발송 오류 : " + ex);
 				}
 			}
 		}
 		
 		return msg.getMessage("0057");
 	}
 	
 	// 계약체결진행현황(CCTR0100) : 개인근로자 게약체결중단
 	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
 	public void ccpr1010_doStop(Map<String, String> param, List<Map<String, Object>> gridData) throws Exception {

 		for (Map<String, Object> rowData : gridData) {
 			
 			//진행상태를 체크한다.
			String possibleFlag = ccpr1010_Mapper.getPossibleFlag(rowData);
			if(!EverString.nullToEmptyString(possibleFlag).equals("Y")) {
				throw new Exception(msg.getMessageByScreenId("CCPR1010", "014"));
			}
            
 			rowData.put("CONT_CLOSE_RMK", param.get("CONT_CLOSE_RMK"));
 			ccpr1010_Mapper.ccpr1010_doStop(rowData);
 			
// 			// 1. 메일 전송
// 			if( EverString.isNotEmpty(String.valueOf(rowData.get("EMAIL"))) && !"null".equals(String.valueOf(rowData.get("EMAIL"))) ) {
// 				try {
// 					Map<String, String> mailMap = new HashMap<>();
// 					mailMap.put("SUBJECT", "[전자구매시스템] 계약 체결 중단 통보");
// 					
//                    String content = "<BR> 안녕하십니까!" +
//                            "<BR> [" + String.valueOf(rowData.get("WORKER_NM")) + "]님" +
//                            "<BR> " +
//                            "<BR> 귀하와 진행 중인 계약 체결 건이 계약담당자에 의해 중단 되었습니다." +
//                            "<BR> 회사 	 	: [" + String.valueOf(rowData.get("BUYER_NM")) + "]" +
//                            "<BR> 계약번호		: [" + rowData.get("CONT_NUM") + "]" +
//                            "<BR> 계약명		: [" + rowData.get("CONT_DESC") + "]" +
//                            "<BR> 계약담당자	: [" + String.valueOf(EverString.nullToEmptyString(rowData.get("DEC_CONT_USER_NM"))) + " (TEL : " + String.valueOf(EverString.nullToEmptyString(rowData.get("DEC_CONT_TEL_NUM"))) + ") ]" +
//                            "<BR> 중단사유 	: [" + EverString.nToBr(EverString.nullToEmptyString(param.get("CONT_CLOSE_RMK"))) + ") ]" +
//                            "<BR> " +
//                            "<BR> 전자구매시스템에 <a href='" + linkUrl + "' target='newP'>로그인</a> 하시어, 세부내용을 확인 후 처리 해주십시오." +
//                            "<BR> " +
//                            "<BR> 감사합니다.";
//
//                    mailMap.put("CONTENTS", content);
//                    mailMap.put("RECV_USER_ID", String.valueOf(rowData.get("WORKER_ID"))); // 수신자ID : 개인근로자ID
//                    mailMap.put("DIRECT_TARGET", String.valueOf(rowData.get("EMAIL")));
// 					mailMap.put("DIRECT_USER_NM", String.valueOf(rowData.get("WORKER_NM")));
// 					mailMap.put("REF_MODULE_CD", "PC");
// 					mailMap.put("REF_NUM", String.valueOf(rowData.get("CONT_NUM")));
// 					
// 					everMailService.SendMail(mailMap);
// 				}
// 				catch (Exception ex) {
// 					logger.error("개인근로자 계약중단 MAIL 발송 오류 : " + ex);
// 				}
// 			}
//
// 			// SMS 전송
// 			if( EverString.isNotEmpty(String.valueOf(rowData.get("CELL_NUM"))) && !"null".equals(String.valueOf(rowData.get("CELL_NUM"))) ) {
// 				try {
// 					Map<String, String> smsMap = new HashMap<String, String>();
// 					
// 					smsMap.put("CONTENTS", "[전자구매시스템] 귀하와 진행 중인 계약 체결 건이 계약담당자에 의해 중단 되었습니다.");
//                    smsMap.put("REF_MODULE_CD", "PC");
//                    smsMap.put("RECV_USER_ID", String.valueOf(rowData.get("WORKER_ID")));
//                    smsMap.put("DIRECT_TARGET", String.valueOf(rowData.get("CELL_NUM")));
// 					smsMap.put("DIRECT_USER_NM", String.valueOf(rowData.get("WORKER_NM")));
// 					
//                    // 2021.07.01 : 개인근로자 계약중단 후 SMS 수수료 부과
// 					rowData.put("SMS_GUBUN", "RJT");
// 					Map<String, String> costInfo = ccti0090_Mapper.costSmsInfo(rowData);
// 					smsMap.put("CORP_NO", costInfo.get("CORP_NO"));			// 고객사 사업자번호
// 					smsMap.put("BRC", costInfo.get("BRC"));					// 고객사 부서
// 					smsMap.put("EPRO_PS_DSC", "1");							// 1  : 구매
// 	                smsMap.put("EPRO_RATE_DSC", "01");						// 01 : 최초
// 					smsMap.put("APLY_DT", costInfo.get("APLY_DT"));			// 발생일 YYYYMMDD
// 					smsMap.put("USER_ID", costInfo.get("USER_ID"));			// 고객사 보내는사람 ID
// 					smsMap.put("CONT_TBL_ID", "STOCPCWU");					// 검증 테이블
// 					smsMap.put("CONT_TBL_PK", costInfo.get("CONT_TBL_PK")); // 검증 조건(협력사별 입찰번호)
// 					smsMap.put("tmp", costInfo.get("CONT_TBL_PK"));			// myBatis 버그 해결을 위한 무의미한, 유니크한 값.
// 					smsMap.put("payFlag", "Y");
// 					
// 					everSmsService.sendSmsNhe(smsMap);
// 				}
// 				catch (Exception ex) {
// 					logger.error("개인근로자 계약중단 SMS 발송 오류 : " + ex);
// 				}
// 			}
 		}
 	}
}
