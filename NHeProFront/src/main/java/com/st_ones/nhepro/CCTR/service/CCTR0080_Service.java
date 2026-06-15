package com.st_ones.nhepro.CCTR.service;

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

import com.fasterxml.jackson.databind.ObjectMapper;
import com.st_ones.common.docNum.service.DocNumService;
import com.st_ones.common.enums.system.Code;
import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.common.mail.service.EverMailService;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.sms.service.EverSmsService;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.everf.serverside.util.EverString;
import com.st_ones.eversrm.eApproval.eApprovalModule.service.BAPM_Service;
import com.st_ones.nhepro.CCTR.CCTR0080_Mapper;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : CCTR0080_Service.java
 * @date 2020.06.10
 * @version 1.0
 * @see
 */
@Service(value = "CCTR0080_Service")
public class CCTR0080_Service extends BaseService {
	
	Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@Autowired CCTR0080_Mapper cctr0080_Mapper;
    @Autowired MessageService msg;
    @Autowired DocNumService docNumService;
    
    @Autowired private BAPM_Service bapm_Service;
    @Autowired private BAPM_Service approvalService;
    @Autowired private EverMailService everMailservice;
    @Autowired private EverSmsService everSmsService;
    
    /**
	 * 화면명 : 위임장 요청현황
	 * 처리내용 : 조회
	 * 경로 : 계약관리 > 전자계약 > 위임장요청현황
	 */
    public List<Map<String,Object>> cctr0080_doSearch(Map<String, String> formData) throws Exception{
    	Map<String, Object> formObj = new HashMap<String, Object>(formData);
        formObj.put("PROGRESS_CD_LIST", Arrays.asList(formData.get("PROGRESS_CD").split(",")));
        return cctr0080_Mapper.cctr0080_doSearch(formObj);
    }

    /**
	 * 화면명 : 위임장 요청현황
	 * 처리내용 : 취소
	 * 경로 : 계약관리 > 전자계약 > 위임장요청현황
	 */
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public void cctr0080_doCancel(List<Map<String, Object>> gridData) throws Exception {
        for (Map<String, Object> rowData : gridData) {
        	String progressCd = cctr0080_Mapper.cctr0080_checkProgressCd(rowData);
        	// 작성중 또는 전자서명 대기인 경우에만 취소 가능
        	if (EverString.isNotEmpty(progressCd) && (EverString.equals(progressCd, "T") || EverString.equals(progressCd, "W"))) {
                cctr0080_Mapper.cctr0080_doCancelDT(rowData);
        	}
        }
    }
    
    /**
	 * 화면명 : 위임장 현황
	 * 처리내용 : 조회
	 * 경로 : 계약관리 > 전자계약 > 위임장현황
	 */
    public List<Map<String,Object>> cctr0081_doSearch(Map<String, String> formData) throws Exception{
    	Map<String, Object> formObj = new HashMap<String, Object>(formData);
        formObj.put("PROGRESS_CD_LIST", Arrays.asList(formData.get("PROGRESS_CD").split(",")));
        return cctr0080_Mapper.cctr0081_doSearch(formObj);
    }
    
    /** 
	 * 화면명 : 위임장 작성정보
	 * 처리내용 : Header 조회
	 * 경로 : 계약관리 > 전자계약 > 위임장작성 > 위임장작성정보 조회
	 */
    public Map<String,String> cctr0070_doSearchHD(Map<String, String> param) throws Exception{
    	Map<String,String> map = cctr0080_Mapper.cctr0070_doSearchHD(param);
        return map;
    }
    
    /**
	 * 화면명 : 위임장 작성정보
	 * 처리내용 : Detail 조회
	 * 경로 : 계약관리 > 전자계약 > 위임장작성 > 위임장작성정보 조회
	 */
    public List<Map<String,Object>> cctr0070_doSearchDT(Map<String, String> param) throws Exception{
        return cctr0080_Mapper.cctr0070_doSearchDT(param);
    }
    
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public Map<String, String> cctr0070_doSave(Map<String, String> formData, List<Map<String, Object>> gridData) throws Exception{
    	
        UserInfo userInfo = UserInfoManager.getUserInfo();
        
        String buyerCd = StringUtils.isEmpty(formData.get("BUYER_CD"))?userInfo.getCompanyCd():formData.get("BUYER_CD");
        formData.put("BUYER_CD", buyerCd);
        // Acrobat pdf 출력 시 특수문자깨짐현상 해결
        // word,excel,한글 등과 같은 외부프로그램의 내용을 그대로 editor에 복사-붙여넣기 하면 일부 지원하지 않는 글꼴로 된 특수문자가 pdf로 생성되면서 깨짐 -> 나눔고딕 변경 처리
        String contentClob = formData.get("CONTENTS_CLOB").replaceAll("font-family:(.*?)\"", "font-family:나눔고딕\"");
        formData.put("CONTENTS_CLOB", contentClob);
        
        // Header 저장
        if( StringUtils.isEmpty(formData.get("REQ_NUM")) ) {
            formData.put("REQ_NUM", docNumService.getDocNumber(userInfo.getCompanyCd(), "EN"));
            cctr0080_Mapper.cctr0070_doInsertHD(formData);
        }
        else {
        	cctr0080_Mapper.cctr0070_doUpdateHD(formData);
        }
        
        // Detail 저장
        String reqNum     = EverString.nullToEmptyString(formData.get("REQ_NUM"));
        String progressCd = EverString.nullToEmptyString(formData.get("PROGRESS_CD"));
        
        cctr0080_Mapper.cctr0070_doDeleteDT(formData);
        for (int i = 0; i < gridData.size(); i++) {
            Map<String, Object> datum = gridData.get(i);
            datum.put("REQ_NUM", reqNum);
            datum.put("PROGRESS_CD", progressCd);
            
            cctr0080_Mapper.cctr0070_doInsertDT(datum);
        }
        
        // 2021.05.13 추가
        // 위임장 요청(PROGRESS_CD=W)일 경우 위임사에게 메일 및 SMS 발송하기
        if( "W".equals(progressCd) ) {
	        sendMailSms(formData);
        }
        
        return formData;
    }
    
    // EFORM 생성 완료 후 EFORM 번호 저장하기
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String cctr0071_doSaveEform(Map<String, String> formData) throws Exception {
        cctr0080_Mapper.cctr0071_doSaveEform(formData);
        return formData.get("UUID");
    }
    
    /**
	 * 화면명 : 위임장 작성정보
	 * 처리내용 : 작성취소
	 * 경로 : 계약관리 > 전자계약 > 위임장작성 > 위임장작성정보 조회
	 */
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public void cctr0070_doCancel(Map<String, String> formData) throws Exception {
        cctr0080_Mapper.cctr0070_doCancelHD(formData);
        cctr0080_Mapper.cctr0070_doCancelDT(formData);
    }
    
    /**
	 * 화면명 : 위임장 요청상세
	 * 처리내용 : 조회
	 * 경로 : 계약관리 > 전자계약 > 위임장요청현황
	 */
    public Map<String,String> cctr0071_doSearch(Map<String, String> param) throws Exception{
    	
    	Map<String, String> formData = cctr0080_Mapper.cctr0071_doSearch(param);
        return formData;
    }
    
    // 위임사에서 전자서명전에 위임장 결재상신
   	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
   	public Map<String, String> cctr0071_doReqSign(Map<String, String> dataForm, List<Map<String, Object>> gridData) throws Exception {
   		
   		UserInfo userInfo = UserInfoManager.getUserInfo();
   		
   		dataForm.put("SIGN_STATUS", Code.M020_P);
   		cctr0080_Mapper.doUpdateStatusOfETDT(dataForm);

   		if (EverString.isEmpty(dataForm.get("APP_DOC_NUM"))) {
   			dataForm.put("APP_DOC_NUM", docNumService.getDocNumber(userInfo.getCompanyCd(), "APPDOC"));
   		}
   		String appDocCnt = dataForm.get("APP_DOC_CNT");
   		if (EverString.isEmpty(appDocCnt) || appDocCnt.equals("0")) {
   			appDocCnt = "1";
   		} else {
   			appDocCnt = String.valueOf(Integer.parseInt(appDocCnt) + 1);
   		}
   		
   		Map<String, String> approvalHeader = new ObjectMapper().readValue(dataForm.get("approvalFormData"), Map.class);
   		dataForm.put("APP_DOC_CNT", appDocCnt);
   		dataForm.put("DOC_TYPE", "ETST");
   		dataForm.put("SUBJECT", approvalHeader.get("SUBJECT"));
   		dataForm.put("APP_DOC_CONTENTS", approvalHeader.get("DOC_CONTENTS")); // 상신의견
   		dataForm.put("SIGN_STATUS", "P");

   		String strApprovalFormData = dataForm.get("approvalFormData");
   		String strApprovalGridData = dataForm.get("approvalGridData");
   		
   		String buyerCd = dataForm.get("BUYER_CD");
   		String etBuyerCd = dataForm.get("ENTRST_COMP_CD");
   		
   		dataForm.put("BUYER_CD", etBuyerCd);
   		approvalService.doApprovalProcess(dataForm, strApprovalFormData, strApprovalGridData);
   		
   		dataForm.put("BUYER_CD", buyerCd);
   		cctr0080_Mapper.doUpdateApprovalETDT(dataForm);
   		
   		return dataForm;
   	}
   	
    /**
	 * 화면명 : 위임장 상세보기
	 * 처리내용 : 위임장 전자서명 (전자서명대기(W)인 경우에만 전자서명 가능)
	 * 경로 : 계약관리 > 전자계약 > 위임장현황 > 위임장 상세보기
	 */
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public void sctr0071_doSaveSignedData(Map<String, Object> param) throws Exception {
    	
    	String progressCd = cctr0080_Mapper.cctr0080_checkProgressCd(param);
    	if (EverString.isNotEmpty(progressCd) && EverString.equals(progressCd, "W")) {
            cctr0080_Mapper.sctr0071_doSaveSignedData(param);
            
            // 개별 법인의 위임장 전자서명 완료시 수탁사에게 사용수수료 부과.
			Map<String, String> costInfo = cctr0080_Mapper.costPayInfo(param);
			costInfo.put("EPRO_PS_DSC", "1");			// 1  : 구매, 2 : 공급
			costInfo.put("EPRO_RATE_DSC", "01");		// 01 : 최초
			costInfo.put("EPRO_WRS_DS", "60");			// epro_wrs_ds [상품코드] - 10 : RFI, 20 : 입찰, 30 : 일반입찰계약, 40 : 일반수의계약, 50 : BtoC계약, 60 : 위임계약, 70 : 문서보관, 80 : SMS, 90 : LMS, 100 : 문서생성
			costInfo.put("CONT_TBL_ID", "STOCETDT");	// 업무 Table명
			// CONT_TBL_PK : 해당 Table에 Data 존재유무를 조회해볼 수 있는 Key 값. GATE_CD || '@@' || REQ_NUM || '@@' || REQ_SEQ
			costInfo.put("tmp", "");   	           		// myBatis 버그 해결을 위한 무의미한, 유니크한 값. 단, EPRO_WRS_DS = '30' 또는 '40'일 때 반드시 계약금액을 넣어야 함.
	        
			String resultMsg = bapm_Service.putBkCost(costInfo);
	        if(!resultMsg.equals("OK")) {
	            throw new Exception(resultMsg);
	        }
    	}
    }
    
    /**
	 * 화면명 : 위임장 상세보기
	 * 처리내용 : 반려 (전자서명대기(W)인 경우에만 반려 가능)
	 * 경로 : 계약관리 > 전자계약 > 위임장현황 > 위임장 상세보기
	 */
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public void CCTR0071_doReject(Map<String, Object> param) throws Exception {
    	String progressCd = cctr0080_Mapper.cctr0080_checkProgressCd(param);
    	if (EverString.isNotEmpty(progressCd) && EverString.equals(progressCd, "W")) {
            cctr0080_Mapper.cctr0071_doReject(param);
    	}
    }
    
    /**
     * 2021.05.13 추가
     * 위임장 전송시 위임사에게 메일 전송
     * @param param
     * @throws Exception
     */
    public void sendMailSms(Map<String, String> param) throws Exception {
    	
        String linkUrl = PropertiesManager.getString("eversrm.urls.maintain.real");
        
        int sendIdx = 0;
        List<Map<String, String>> mailList = cctr0080_Mapper.getMailTargetList(param);
        for (Map<String, String> mailData : mailList) {
        	try {
	        	String subject = "[전자구매시스템] 수탁법인 [" + mailData.get("BUYER_NM") + "]에서 [" + mailData.get("SUBJECT") + "] 관련 위임장 서명을 요청하였습니다.";
	        	
	            StringBuffer content = new StringBuffer();
	            content.setLength(0);
	            content.append("<BR> 안녕하십니까!																					");
	            content.append("<BR> [" + mailData.get("RECV_COMP_NM") + " " + mailData.get("RECV_DEPT_NM") + "] 담당자 님.		");
	            content.append("<BR>																							");
	            content.append("<BR> 아래와 같이 수탁법인에서 위임장 전자서명을 요청하였습니다.													");
	            content.append("<BR> 수탁법인 : [" + mailData.get("BUYER_NM") + "]													");
	            content.append("<BR> 요청명 : [" + mailData.get("SUBJECT") + "]													");
	            content.append("<BR> 요청일자 : [" + mailData.get("REQ_DATE") + "] 												");
	            content.append("<BR> 회신희망일자 : [" + mailData.get("RCV_REQ_DATE") + "]											");
	            content.append("<BR> 요청자 : [" + mailData.get("REQ_USER_NM") + " (" + mailData.get("REQ_TEL_NUM") + ")] 			");
	            content.append("<BR>																							");
	            content.append("<BR> 전자구매시스템에 <a href=\"" + linkUrl + "\" target=\"newP\">로그인</a> 하시어, 세부내용을 확인 해주십시오.	");
	            content.append("<BR>																							");
	            content.append("<BR> 감사합니다.																					");
	            
	            Map<String, String> mailMap = new HashMap<String, String>();
	            mailMap.put("SUBJECT", subject);
	            mailMap.put("CONTENTS", content.toString());
	            mailMap.put("REF_MODULE_CD", "METST01");
	            mailMap.put("REF_NUM", String.valueOf(mailData.get("REQ_NUM")) + "@@" + String.valueOf(mailData.get("REQ_SEQ")));
	            
	            // 직접 EMAIL 전송하기
	            String recvUserNm = EverString.nullToEmptyString(mailData.get("RECV_USER_NM"));
	            String recvEmail  = EverString.nullToEmptyString(mailData.get("RECV_USER_EMAIL"));
	            if( EverString.isNotEmpty(recvUserNm) && EverString.isNotEmpty(recvEmail) ) {
		            mailMap.put("DIRECT_TARGET", recvEmail);
		            mailMap.put("DIRECT_USER_NM", recvUserNm);
	            } else {
		            mailMap.put("RECV_USER_ID", mailData.get("RECV_COMP_CD"));
	            }
	            everMailservice.SendMail(mailMap);
	            
	            // SMS 발송
	            Map<String, String> smsMap = new HashMap<String, String>();
	            smsMap.put("CONTENTS", subject);
	            smsMap.put("REF_MODULE_CD", "SETST01");
	            
	            // 직접 SMS전송하기
	            String recvCellNum = EverString.nullToEmptyString(mailData.get("RECV_USER_CELL_NUM"));
	            if( EverString.isNotEmpty(recvUserNm) && EverString.isNotEmpty(recvCellNum) ) {
	            	smsMap.put("DIRECT_TARGET", recvCellNum);
		            smsMap.put("DIRECT_USER_NM", recvUserNm);
	            } else {
	            	smsMap.put("RECV_USER_ID", mailData.get("RECV_COMP_CD"));
	            }
	            
	            Map<String, String> costInfo = cctr0080_Mapper.costSmsInfo(mailData);
	            smsMap.put("CORP_NO", costInfo.get("CORP_NO"));			// 고객사 사업자번호
				smsMap.put("BRC", costInfo.get("BRC"));					// 고객사 부서
				smsMap.put("EPRO_PS_DSC", "1");							// 1  : 구매, 2 : 공급
	            smsMap.put("EPRO_RATE_DSC", "01");						// 01 : 최초
				smsMap.put("APLY_DT", costInfo.get("APLY_DT"));			// 발생일 YYYYMMDD
				smsMap.put("USER_ID", costInfo.get("USER_ID"));			// 고객사 보내는사람 ID
				smsMap.put("CONT_TBL_ID", "STOCETDT");					// 검증 테이블
				smsMap.put("CONT_TBL_PK", costInfo.get("CONT_TBL_PK")); // 검증 조건(협력사별 입찰번호)
				smsMap.put("tmp", String.valueOf(sendIdx));				// myBatis 버그 해결을 위한 무의미한, 유니크한 값.
				smsMap.put("payFlag", "Y");
				
	            everSmsService.sendSmsNhe(smsMap);
	            
	            sendIdx++;
        	}
            catch (Exception ex) {
                getLog().error("위임장 요청 후 메일 및 SMS 발송 오류 : " + ex.getMessage(), ex);
            }
        }
    }
}
