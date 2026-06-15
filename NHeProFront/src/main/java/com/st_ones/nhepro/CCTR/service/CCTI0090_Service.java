package com.st_ones.nhepro.CCTR.service;

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

import com.fasterxml.jackson.databind.ObjectMapper;
import com.st_ones.common.docNum.service.DocNumService;
import com.st_ones.common.enums.system.Code;
import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.common.mail.service.EverMailService;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.sms.service.EverSmsService;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.everf.serverside.util.clazz.AuthorityIgnore;
import com.st_ones.eversrm.eApproval.eApprovalModule.service.BAPM_Service;
import com.st_ones.nhepro.CCTR.CCTI0090_Mapper;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : CCTI0090_Service.java
 * @date 2020.06.10
 * @version 1.0
 * @see
 */
@Service(value = "CCTI0090_Service")
public class CCTI0090_Service extends BaseService {

	private static Logger logger = LoggerFactory.getLogger(CCTI0090_Service.class);
	
    @Autowired private CCTI0090_Mapper ccti0090_Mapper;
    @Autowired private BAPM_Service approvalService;
    @Autowired private EverMailService everMailService;
    @Autowired private EverSmsService everSmsService;
    @Autowired private DocNumService docNumService;
    @Autowired private MessageService msg;
	
    // CCTI0090 : 개인근로자 계약내용 조회
 	public Map<String, String> ccti0090_doSearch(Map<String, String> param) throws Exception {
 		return ccti0090_Mapper.ccti0090_doSearch(param);
 	}

 	// 개인근로자 조회
 	public List<Map<String, Object>> ccti0090_doSearchPCWU(Map<String, String> param) throws Exception {

 		List<Map<String, Object>> gridList = new ArrayList<Map<String, Object>>();
 		if (EverString.isNotEmpty(String.valueOf(param.get("CONT_NUM"))) && EverString.isNotEmpty(String.valueOf(param.get("CONT_CNT"))))
 		{
 			gridList = ccti0090_Mapper.cctr0110_doSearch(param);
 		}
 		return gridList;
 	}

 	public List<Map<String, Object>> ccti0090_getWorkerListForContract(List<Map<String, Object>> gridData) throws Exception {

 		List<String> userIdList = new ArrayList<>();
 		for (Map<String, Object> gridDatum : gridData) {
 			userIdList.add((String) gridDatum.get("WORKER_ID"));
 		}

 		Map<String, String> param = new HashMap<>();
 		param.put("USER_ID", EverString.forInQuery(StringUtils.join(userIdList, ","), ","));

 		return ccti0090_Mapper.ccti0090_getWorkerListForContract(param);
 	}

 	// CCTI0090 : 개인근로자 저장
 	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
 	public Map<String, String> ccti0090_doSave(Map<String, String> formData, List<Map<String, Object>> gridData) throws Exception {

 		UserInfo userInfo = UserInfoManager.getUserInfo();
 		
 		String contNum = formData.get("CONT_NUM");
 		String contCnt = formData.get("CONT_CNT");
 		if (StringUtils.isEmpty(contNum) && StringUtils.isEmpty(contCnt)) {
 			formData.put("CONT_NUM", docNumService.getDocNumber(userInfo.getCompanyCd(), "PC"));
 			formData.put("CONT_CNT", "1");
 			ccti0090_Mapper.doInsertPCCT(formData);
 		} else {
 			ccti0090_Mapper.doUpdatePCCT(formData);
 		}

 		// 개인근로자 저장
 		ccti0090_Mapper.doDeletePCWU(formData);
 		for (int i = 0; i < gridData.size(); i++) {
 			Map<String, Object> datum = gridData.get(i);
 			
 			datum.put("BUYER_CD", formData.get("BUYER_CD"));
 			datum.put("CONT_NUM", formData.get("CONT_NUM"));
 			datum.put("CONT_CNT", formData.get("CONT_CNT"));
 			datum.put("REG_DATE", formData.get("REG_DATE"));
 			ccti0090_Mapper.doInsertPCWU(datum);
 		}

 		return formData;
 	}

 	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
 	public void ccti0090_doDelete(Map<String, String> dataForm) throws Exception {
 		if (dataForm != null) {
 			String signStatus = ccti0090_Mapper.ccti0090_doCheckStatus(dataForm);

 			if( !signStatus.equals(Code.M020_T) ){
 				throw new Exception("계약서를 삭제할 수 없는 상태입니다.\n\n결재상태를 다시 확인해주세요.");
 			}

 			ccti0090_Mapper.doDeletePCWU(dataForm); // 개인근로자
 			ccti0090_Mapper.doDeletePCCT(dataForm); // 계약서폼
 		}
 	}

 	// 개인근로자 결재상신
 	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
 	public Map<String, String> ccti0090_doReqSign(Map<String, String> dataForm, List<Map<String, Object>> gridData) throws Exception {
 		
 		UserInfo userInfo = UserInfoManager.getUserInfo();
 		
 		// 임시저장으로 STOCPCCT 저장
 		Map<String, String> formData = ccti0090_doSave(dataForm, gridData);

 		formData.put("SIGN_STATUS", Code.M020_P);
 		ccti0090_Mapper.doUpdateStatusOfPCCT(formData);

 		if (EverString.isEmpty(dataForm.get("APP_DOC_NUM"))) {
 			dataForm.put("APP_DOC_NUM", docNumService.getDocNumber(userInfo.getCompanyCd(), "APPDOC"));
 		}
 		String appDocCnt = dataForm.get("APP_DOC_CNT");
 		if (EverString.isEmpty(appDocCnt) || appDocCnt.equals("0")) {
 			appDocCnt = "1";
 		} else {
 			appDocCnt = String.valueOf(Integer.parseInt(appDocCnt) + 1);
 		}
 		
 		Map<String, String> approvalHeader = new ObjectMapper().readValue(formData.get("approvalFormData"), Map.class);
 		dataForm.put("APP_DOC_CNT", appDocCnt);
 		dataForm.put("DOC_TYPE", "PCONT");
 		dataForm.put("SUBJECT", approvalHeader.get("SUBJECT"));
 		dataForm.put("APP_DOC_CONTENTS", approvalHeader.get("DOC_CONTENTS")); // 상신의견
 		dataForm.put("SIGN_STATUS", "P");

 		String strApprovalFormData = dataForm.get("approvalFormData");
 		String strApprovalGridData = dataForm.get("approvalGridData");

 		approvalService.doApprovalProcess(dataForm, strApprovalFormData, strApprovalGridData);
 		ccti0090_Mapper.doUpdateApprovalPCCT(dataForm);

 		return formData;
 	}

 	// 개인근로자 계약서상세보기(CCTR0110) 조회
 	public List<Map<String, Object>> cctr0110_doSearch(Map<String, String> param) throws Exception {

 		List<Map<String, Object>> gridList = ccti0090_Mapper.cctr0110_doSearch(param);
 		return gridList;
 	}

 	// 개인근로자 계약진행현황(CCTR0100) 조회
 	public List<Map<String, Object>> cctr0100_doSearch(Map<String, String> param) throws Exception {
 		param.put("PROGRESS_CD", EverString.forInQuery(param.get("PROGRESS_CD"), ","));
 		param.put("SIGN_STATUS", EverString.forInQuery(param.get("SIGN_STATUS"), ","));

 		List<Map<String, Object>> gridList = ccti0090_Mapper.cctr0100_doSearch(param);
 		return gridList;
 	}

 	// 계약체결진행현황(CCTR0100) : 개인근로자 전자서명 직접 요청하기
 	@AuthorityIgnore
 	public String cctr0100_doRequest(List<Map<String, Object>> gridData) throws Exception {

 		String linkUrl = PropertiesManager.getString("eversrm.urls.maintain.real") + "/mobile/";
 		
 		for (Map<String, Object> rowData : gridData) {
 			
 			rowData.put("SEND_YN", "1");
 			ccti0090_Mapper.cctr0100_doSendYn(rowData);
 			
 			String contMngNum = (String)rowData.get("CONT_NUM");
 			//메일전송
 			if( EverString.isNotEmpty(String.valueOf(rowData.get("EMAIL"))) && !"null".equals(String.valueOf(rowData.get("EMAIL"))) ) {
 				try {
 					Map<String, String> mailMap = new HashMap<>();
 					mailMap.put("SUBJECT", "[전자구매시스템] 신규 계약 체결 검토 요청");
 					
 					String contDesc = String.valueOf(rowData.get("CONT_DESC"));
                    String content = "<BR> 안녕하십니까!" +
                            "<BR> [" + String.valueOf(rowData.get("WORKER_NM")) + "]님" +
                            "<BR> " +
                            "<BR> 귀하에게 새로운 계약 체결 건이 전송 되었습니다." +
                            "<BR> 회사 	 	: [" + String.valueOf(rowData.get("BUYER_NM")) + "]" +
                            "<BR> 계약번호		: [" + contMngNum + "]" +
                            "<BR> 계약명		: [" + contDesc + "]" +
                            "<BR> 계약담당자	: [" + String.valueOf(EverString.nullToEmptyString(rowData.get("DEC_CONT_USER_NM"))) + " (TEL : " + String.valueOf(EverString.nullToEmptyString(rowData.get("DEC_CONT_TEL_NUM"))) + ") ]" +
                    		"<BR> " +
                            "<BR> 전자구매시스템에 <a href='" + linkUrl + "' target='newP'>로그인</a> 하시어, 세부내용을 확인 후 처리 해주십시오." +
                            "<BR> " +
                            "<BR> 감사합니다.";
                    
                    mailMap.put("CONTENTS", content);
                    mailMap.put("RECV_USER_ID", String.valueOf(rowData.get("WORKER_ID"))); // 수신자ID : 개인근로자ID
 					mailMap.put("DIRECT_TARGET", String.valueOf(rowData.get("EMAIL")));
 					mailMap.put("DIRECT_USER_NM", String.valueOf(rowData.get("WORKER_NM")));
 					mailMap.put("REF_MODULE_CD", "PC");
 					mailMap.put("REF_NUM", contMngNum);
 					
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
 					String content = "[전자구매시스템] 계약 체결 건이 전송 되었습니다. 계약서 내용 검토 바랍니다.(계약번호 : " + contMngNum + ")" +
 							"전자구매시스템에 로그인하시어, 세부내용을 확인 후 처리 해주십시오. " +
 							linkUrl+
                            " 감사합니다.";
 								
 					smsMap.put("CONTENTS", content);
 					smsMap.put("REF_MODULE_CD", "PC");
 					smsMap.put("RECV_USER_ID", String.valueOf(rowData.get("WORKER_ID")));
 					smsMap.put("DIRECT_TARGET", String.valueOf(rowData.get("CELL_NUM")));
 					smsMap.put("DIRECT_USER_NM", String.valueOf(rowData.get("WORKER_NM")));
 					
 					// 2021.07.01 : 개인근로자 계약체결 요청 후 SMS 수수료 부과
 					rowData.put("SMS_GUBUN", "REQ");
 					Map<String, String> costInfo = ccti0090_Mapper.costSmsInfo(rowData);
 					smsMap.put("CORP_NO", costInfo.get("CORP_NO"));			// 고객사 사업자번호
 					smsMap.put("BRC", costInfo.get("BRC"));					// 고객사 부서
 					smsMap.put("EPRO_PS_DSC", "1");							// 1  : 구매
 	                smsMap.put("EPRO_RATE_DSC", "01");						// 01 : 최초
 					smsMap.put("APLY_DT", costInfo.get("APLY_DT"));			// 발생일 YYYYMMDD
 					smsMap.put("USER_ID", costInfo.get("USER_ID"));			// 고객사 보내는사람 ID
 					smsMap.put("CONT_TBL_ID", "STOCPCWU");					// 검증 테이블
 					smsMap.put("CONT_TBL_PK", costInfo.get("CONT_TBL_PK")); // 검증 조건(협력사별 입찰번호)
 					smsMap.put("tmp", costInfo.get("CONT_TBL_PK"));			// myBatis 버그 해결을 위한 무의미한, 유니크한 값.
 					smsMap.put("payFlag", "Y");
 					
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
 	public void cctr0100_doStop(Map<String, String> param, List<Map<String, Object>> gridData) throws Exception {

 		String linkUrl = PropertiesManager.getString("eversrm.urls.maintain.real") + "/mobile/";
 		
 		for (Map<String, Object> rowData : gridData) {
 			rowData.put("STOP_RMK", param.get("CONT_CLOSE_RMK"));
 			ccti0090_Mapper.cctr0100_doStop(rowData);
 			
 			// 1. 메일 전송
 			if( EverString.isNotEmpty(String.valueOf(rowData.get("EMAIL"))) && !"null".equals(String.valueOf(rowData.get("EMAIL"))) ) {
 				try {
 					Map<String, String> mailMap = new HashMap<>();
 					mailMap.put("SUBJECT", "[전자구매시스템] 계약 체결 중단 통보");
 					
                    String content = "<BR> 안녕하십니까!" +
                            "<BR> [" + String.valueOf(rowData.get("WORKER_NM")) + "]님" +
                            "<BR> " +
                            "<BR> 귀하와 진행 중인 계약 체결 건이 계약담당자에 의해 중단 되었습니다." +
                            "<BR> 회사 	 	: [" + String.valueOf(rowData.get("BUYER_NM")) + "]" +
                            "<BR> 계약번호		: [" + rowData.get("CONT_NUM") + "]" +
                            "<BR> 계약명		: [" + rowData.get("CONT_DESC") + "]" +
                            "<BR> 계약담당자	: [" + String.valueOf(EverString.nullToEmptyString(rowData.get("DEC_CONT_USER_NM"))) + " (TEL : " + String.valueOf(EverString.nullToEmptyString(rowData.get("DEC_CONT_TEL_NUM"))) + ") ]" +
                            "<BR> 중단사유 	: [" + EverString.nToBr(EverString.nullToEmptyString(param.get("CONT_CLOSE_RMK"))) + ") ]" +
                            "<BR> " +
                            "<BR> 전자구매시스템에 <a href='" + linkUrl + "' target='newP'>로그인</a> 하시어, 세부내용을 확인 후 처리 해주십시오." +
                            "<BR> " +
                            "<BR> 감사합니다.";

                    mailMap.put("CONTENTS", content);
                    mailMap.put("RECV_USER_ID", String.valueOf(rowData.get("WORKER_ID"))); // 수신자ID : 개인근로자ID
                    mailMap.put("DIRECT_TARGET", String.valueOf(rowData.get("EMAIL")));
 					mailMap.put("DIRECT_USER_NM", String.valueOf(rowData.get("WORKER_NM")));
 					mailMap.put("REF_MODULE_CD", "PC");
 					mailMap.put("REF_NUM", String.valueOf(rowData.get("CONT_NUM")));
 					
 					everMailService.SendMail(mailMap);
 				}
 				catch (Exception ex) {
 					logger.error("개인근로자 계약중단 MAIL 발송 오류 : " + ex);
 				}
 			}

 			// SMS 전송
 			if( EverString.isNotEmpty(String.valueOf(rowData.get("CELL_NUM"))) && !"null".equals(String.valueOf(rowData.get("CELL_NUM"))) ) {
 				try {
 					Map<String, String> smsMap = new HashMap<String, String>();
 					
 					smsMap.put("CONTENTS", "[전자구매시스템] 귀하와 진행 중인 계약 체결 건이 계약담당자에 의해 중단 되었습니다.");
                    smsMap.put("REF_MODULE_CD", "PC");
                    smsMap.put("RECV_USER_ID", String.valueOf(rowData.get("WORKER_ID")));
                    smsMap.put("DIRECT_TARGET", String.valueOf(rowData.get("CELL_NUM")));
 					smsMap.put("DIRECT_USER_NM", String.valueOf(rowData.get("WORKER_NM")));
 					
                    // 2021.07.01 : 개인근로자 계약중단 후 SMS 수수료 부과
 					rowData.put("SMS_GUBUN", "RJT");
 					Map<String, String> costInfo = ccti0090_Mapper.costSmsInfo(rowData);
 					smsMap.put("CORP_NO", costInfo.get("CORP_NO"));			// 고객사 사업자번호
 					smsMap.put("BRC", costInfo.get("BRC"));					// 고객사 부서
 					smsMap.put("EPRO_PS_DSC", "1");							// 1  : 구매
 	                smsMap.put("EPRO_RATE_DSC", "01");						// 01 : 최초
 					smsMap.put("APLY_DT", costInfo.get("APLY_DT"));			// 발생일 YYYYMMDD
 					smsMap.put("USER_ID", costInfo.get("USER_ID"));			// 고객사 보내는사람 ID
 					smsMap.put("CONT_TBL_ID", "STOCPCWU");					// 검증 테이블
 					smsMap.put("CONT_TBL_PK", costInfo.get("CONT_TBL_PK")); // 검증 조건(협력사별 입찰번호)
 					smsMap.put("tmp", costInfo.get("CONT_TBL_PK"));			// myBatis 버그 해결을 위한 무의미한, 유니크한 값.
 					smsMap.put("payFlag", "Y");
 					
 					everSmsService.sendSmsNhe(smsMap);
 				}
 				catch (Exception ex) {
 					logger.error("개인근로자 계약중단 SMS 발송 오류 : " + ex);
 				}
 			}
 		}
 	}
 	
 	// 개인근로자의 계약담당자변경
 	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
 	public void cctr0100_changeContUser(Map<String, String> param, List<Map<String, Object>> gridData) throws Exception {
 		for (Map<String, Object> rowData : gridData) {
 			rowData.put("CHANGE_CONT_USER_ID", param.get("CHNG_USER_ID"));
 			ccti0090_Mapper.cctr0100_changeContUser(rowData); // 개인근로자 계약담당자 변경
 			ccti0090_Mapper.cctr0100_changeSiteUser(rowData); // 개인근로자 현장담당자 변경
 		}
 	}
 	
 	// 개인근로자현황(CCTR0120) 조회
  	public List<Map<String, Object>> cctr0120_doSearch(Map<String, String> param) throws Exception {
  		
  		List<Map<String, Object>> gridList = ccti0090_Mapper.cctr0120_doSearch(param);
  		return gridList;
  	}
  	
  	// 2021.03.02 프로세스 추가
  	// 개인근로자의 승인 및 반려
  	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
  	public void cctr0120_doConfirm(Map<String, String> param, List<Map<String, Object>> gridData) throws Exception {
  		
  		String progressCd = param.get("PROGRESS_CD");
  		for (Map<String, Object> rowData : gridData) {
  			//1. 개인근로자 승인 및 반려
  	 		rowData.put("PROGRESS_CD", progressCd);
  			ccti0090_Mapper.cctr0120_doConfirm(rowData); // 개인근로자 승인 및 반려
  			
  			// 반려인 경우 개인근로자에게 메일, SMS 보내기
  			if ("R".equals(progressCd)) {
	  			//2. 개인근로자에게 메일/SMS 전송
	  	 		String linkUrl = PropertiesManager.getString("eversrm.urls.maintain.real") + "/mobile/";
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
	 					Map<String, String> costInfo = ccti0090_Mapper.costPersonalInfo(rowData);
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

}
