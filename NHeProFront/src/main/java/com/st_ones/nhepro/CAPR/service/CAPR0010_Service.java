package com.st_ones.nhepro.CAPR.service;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.st_ones.common.docNum.service.DocNumService;
import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.common.mail.service.EverMailService;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.sms.service.EverSmsService;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.common.util.service.LargeTextService;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.eversrm.eApproval.eApprovalEnd.AP.EApprovalEndAp_Mapper;
import com.st_ones.eversrm.eApproval.eApprovalModule.service.BAPM_Service;
import com.st_ones.nhepro.CAPR.CAPR0010_Mapper;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : CAPR0010_Service.java
 * @date 2018. 01. 30.
 * @version 1.0
 */

@Service(value = "CAPR0010_Service")
public class CAPR0010_Service extends BaseService {

    @Autowired MessageService msg;
    @Autowired CAPR0010_Mapper capr0010_mapper;
    @Autowired LargeTextService largeTextService;
    @Autowired private DocNumService docNumService;
    @Autowired private BAPM_Service approvalService;
    @Autowired private EverMailService evermailservice;
    @Autowired private EverSmsService eversmsservice;
    @Autowired private EApprovalEndAp_Mapper endAp_mapper;
    
    Logger logger = LoggerFactory.getLogger(this.getClass());
    
    /**
     * 화면명 : 대금지급현황
     * 처리내용 : 대금지급요청 현황을 조회하여 심사 및 지급내역을 등록하는 화면
     * 경로 : 고객사 > 발주관리 > 대금지급 > 대금지급현황
     */
    public List<Map<String, Object>> capr0010_doSearch(Map<String, String> param) {
    	Map<String, Object> formObj = new HashMap<String, Object>(param);
    	formObj.put("SIGN_STATUS_LIST", Arrays.asList(param.get("SIGN_STATUS").split(",")));
    	
        return capr0010_mapper.capr0010_doSearch(formObj);
    }

    // 대금지급담당자 변경
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public Map<String, String> capr0010_doUpdateChange(Map<String, String> formData, List<Map<String, Object>> grid) throws Exception {
    	
        Map<String, String> rtnMap = new HashMap<>();
        for(Map<String, Object> data : grid) {
            data.put("PAY_USER_ID", formData.get("AP_USER_ID"));
            // 2021.11.17 : (STOCIVAP)대금지급 일반정보의 정산담당자 변경 추가
            capr0010_mapper.capr0010_doUpdateChangeIVAP(data);
            // (STOCIVPC) 검수요청서의 정산담당자 변경
            capr0010_mapper.capr0010_doUpdateChangeIVHD(data);
            // 2021.09.06 : (STOCPOPC) 발주서의 정산담당자 변경 추가
            capr0010_mapper.capr0010_doUpdatePOPC(data);
        }

        rtnMap.put("rtnMsg", msg.getMessageByScreenId("CAPR0010", "004"));
        return rtnMap;
    }
    
    // 2021.11.18 Multi 결재상신 기능추가
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public Map<String, String> capr0010_doUpdateApproval(Map<String, String> formData, List<Map<String, Object>> grid) throws Exception {
    	
        Map<String, String> rtnMap = new HashMap<>();
        UserInfo userInfo = UserInfoManager.getUserInfo();
        
        for(Map<String, Object> data : grid) {
        	formData.put("BUYER_CD", (String)data.get("BUYER_CD"));
        	formData.put("AP_NUM", (String)data.get("AP_NUM"));
        	formData.put("PAY_USER_ID", (String)data.get("PAY_USER_ID"));
        	formData.put("PY_AP_REQ_DATE", (String)data.get("PY_AP_REQ_DATE"));
        	formData.put("PY_AP_REQ_DATE", (String)data.get("PY_AP_REQ_DATE"));
        	
        	// 채번로직 변경. Parameter [화면에서 전달 받은 COMPANY_CD (없는 경우, ses.manageCd 또는 ses.companyCd), DOC_TYPE ]
	        if( EverString.isEmpty((String)data.get("APP_DOC_NUM")) ) {
	            formData.put("APP_DOC_NUM", docNumService.getDocNumber(userInfo.getCompanyCd(), "APPDOC"));
	        } else {
	        	formData.put("APP_DOC_NUM", (String)data.get("APP_DOC_NUM"));
	        }
	        
	        String signStatus = String.valueOf(data.get("SIGN_STATUS"));
	        String appDocCnt  = String.valueOf(data.get("APP_DOC_CNT"));
            // 이전의 SIGN_STATUS가 반려(R), 결재취소(C)이면 결재차수 = 결재차수 + 1
	        if (EverString.isEmpty(appDocCnt) || appDocCnt.equals("0") || appDocCnt.equals("null")) {
	            appDocCnt = "1";
	        } else {
	            if (signStatus.equals("R") || signStatus.equals("C") || "20".equals(String.valueOf(data.get("PROGRESS_CD")))) {
	                appDocCnt = String.valueOf(Integer.parseInt(appDocCnt) + 1);
	            }
	        }
	        formData.put("APP_DOC_CNT", appDocCnt);
	        
	        formData.put("DOC_NUM", String.valueOf(data.get("AP_NUM")));
	        formData.put("SUBJECT", String.valueOf(data.get("AP_REQ_SUBJECT")));
	        formData.put("APP_AMT", String.valueOf(data.get("PY_AMT")));
	        formData.put("SIGN_STATUS", "P");
	        
	        Map<String, String> approvalHeader = new ObjectMapper().readValue(formData.get("approvalFormData"), Map.class);
	        approvalHeader.put("DOC_NUM", String.valueOf(data.get("AP_NUM")));
	        approvalHeader.put("SUBJECT", String.valueOf(data.get("AP_REQ_SUBJECT")));
	        approvalHeader.put("APP_AMT", String.valueOf(data.get("PY_AMT")));
	        
	        ObjectMapper mapper = new ObjectMapper();
	        formData.put("approvalFormData", mapper.writeValueAsString(approvalHeader));
	        
	        // 결재상신
	        approvalService.doApprovalProcess(formData, formData.get("approvalFormData"), formData.get("approvalGridData"));
	        // 결재진행상태 변경
	        capr0010_mapper.capr0010_doUpdateApprovalIVAP(formData);
        }
        
        rtnMap.put("rtnMsg", msg.getMessageByScreenId("CAPR0011", "013"));
        return rtnMap;
    }
    
    // 발주관리 > 대금지급 > 대금지급현황 (CAPR0010) > 대금지급등록
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public Map<String, String> capr0010_doUpdatePayReg(Map<String, String> formData, List<Map<String, Object>> grid) throws Exception {
        Map<String, String> rtnMap = new HashMap<>();

        for(Map<String, Object> data : grid) {
            data.put("SIGN_STATUS", "70");
            capr0010_mapper.capr0010_doUpdatePayRegIVAP(data);
            
            rtnMap.put("BUYER_CD", EverString.nullToEmptyString(data.get("BUYER_CD")));
            rtnMap.put("PO_NUM", EverString.nullToEmptyString(data.get("PO_NUM")));
            rtnMap.put("INV_NUM", EverString.nullToEmptyString(data.get("INV_NUM")));
            rtnMap.put("PY_BUYER_CD", EverString.nullToEmptyString(data.get("PY_BUYER_CD")));
            rtnMap.put("PY_DEPT_CD", EverString.nullToEmptyString(data.get("PY_DEPT_CD")));

            List<Map<String, Object>> list = capr0010_mapper.capr0011_doSearchIVDT(rtnMap);
            for(Map<String, Object> map : list) {
                map.put("PROGRESS_CD", "8200");
                capr0010_mapper.capr0010_doUpdatePayRegPODT(map);
                
                // 2021.02.02 제외 : 발주 이후 프로세스는 발주진행상태만 변경함
                // 2021.01.27 추가 : 구매진행상태=8200(정산완료) 변경
                //capr0010_mapper.setPrProgressCd(map);
            }
        }
        
        rtnMap.put("rtnMsg", msg.getMessageByScreenId("CAPR0010", "013"));
        return rtnMap;
    }

    /**
     * 화면명 : 대금지급요청서
     * 처리내용 : 대금청구요청서 상세내역을 확인하고 내부 의사결정을 위한 품의를 진행하는 화면
     * 경로 : 고객사 > 발주관리 > 대금지급 > 대금지급현황 > 대금지급요청서 (팝업)
     */
    public Map<String, Object> capr0011_doSearchIVHD(Map<String, String> param) throws Exception {
        Map<String, Object> fParam;

        if(!"".equals(param.get("APP_DOC_NUM")) && param.get("APP_DOC_NUM") != null) {
            param.put("BUYER_CD", param.get("buyerCd"));
        }

        fParam = capr0010_mapper.capr0011_doSearchIVHD(param);

        fParam.put("RMK_TEXT", largeTextService.selectLargeText(EverString.nullToEmptyString(fParam.get("RMK_TEXT_NUM"))));

        return fParam;
    }

    // 품목정보, 조회
    public List<Map<String, Object>> capr0011_doSearchIVDT(Map<String, String> formData, Map<String, String> param) throws Exception {
        Map<String, Object> fParam = new HashMap<>();

        return capr0010_mapper.capr0011_doSearchIVDT(formData);
    }

    // 대금지급요청 이력, 조회
    public List<Map<String, Object>> capr0011_doSearchIVAP(Map<String, String> formData, Map<String, String> param) throws Exception {

        return capr0010_mapper.capr0011_doSearchIVAP(formData);
    }
    
    // 저장
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public Map<String, String> capr0011_doUpdateIVAP(Map<String, String> formData) throws Exception {
        Map<String, String> rtnMap = new HashMap<>();

        capr0010_mapper.capr0011_doUpdateIVAP(formData);

        return formData;
    }

    // 대금지급요청 반송
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public Map<String, String> capr0011_doReject(Map<String, String> formData, List<Map<String, Object>> gridPODT) throws Exception {
    	
        Map<String, String> rtnMap = new HashMap<>();
        
        // 1. 대금청구요청 반려
        capr0010_mapper.capr0011_doRejectIVAP(formData);
        
        // 2. 발주품목 상태 변경
        for(Map<String, Object> data : gridPODT) {
            if("PI".equals(formData.get("DELIVERY_TYPE"))) { // 전체검수(공사, 용역 등)
                data.put("PROGRESS_CD", "7200");
            }
            else if("DI".equals(formData.get("DELIVERY_TYPE"))) { // 부분검수(납품, 물품 등)
                data.put("PROGRESS_CD", "6200");
            }
            capr0010_mapper.capr0011_doRejectPODT(data);
        }
        
        // 3. 반송시 MAIL/SMS 발송
        // 2021.06.30 추가
        try {
            String linkUrl = PropertiesManager.getString("eversrm.urls.maintain.real") ;
            
            List<Map<String, String>> listMail = endAp_mapper.getMailList(formData);
            for(Map<String, String> data : listMail) {
            	String subject = "[전자구매시스템] 협력사 [" + data.get("VENDOR_NM") + "]에서 요청한 [" + data.get("SUBJECT") + "] 관련 [" + data.get("AP_REQ_SUBJECT") + "]의 대금지급이 [반려]되었습니다";
                
            	//EMAIL
                Map<String,String> mailMap = new HashMap<>();
                mailMap.put("SUBJECT", subject);

                String content = "<BR> 안녕하세요." +
                        "<BR> [" + data.get("VENDOR_NM") + "] " + data.get("USER_NM") + " 님" +
                        "<BR> " +
                        "<BR> 아래와 같이 협력사에서 요청하신 대금지급이 반려되였습니다." +
                        "<BR> 고객사 : [" + data.get("BUYER_NM") + "]" +
                        "<BR> 발주명 : [" + data.get("PO_NUM") + "] " + data.get("SUBJECT") +
                        "<BR> 요청일 : [" + data.get("AP_REQ_DATE") + "]" +
                        "<BR> 지급명 : [" + data.get("AP_REQ_SUBJECT") + "]" +
                        "<BR> 지급차수명 : [" + data.get("PAY_CNT_INFO") + "]" +
                        "<BR> 요청금액 : [" + data.get("AP_AMT") + "]" +
                        "<BR> 처리결과 : [반려]" +
                		"<BR> " +
                        "<BR> 전자구매시스템에 <a href='" + linkUrl + "' target='newP'>로그인</a> 하시어, 세부내용을 확인 해주십시오." +
                        "<BR> " +
                        "<BR> 감사합니다.";
                
                mailMap.put("CONTENTS", content);
                mailMap.put("REF_MODULE_CD", "MAP02");
                mailMap.put("RECV_USER_ID", data.get("RECV_USER_ID"));
                mailMap.put("REF_NUM", data.get("INV_NUM"));
                evermailservice.SendMail(mailMap);
                
                //SMS
                Map<String,String> smsMap = new HashMap<String,String>();
                smsMap.put("CONTENTS", subject);
                smsMap.put("REF_MODULE_CD", "SAP02");
                smsMap.put("RECV_USER_ID", data.get("RECV_USER_ID"));
                
                // 수수료 부과 => 대금지급 승인한 고객사(대금지급담당자 고객사)에 부과
                formData.put("AP_USER_ID", data.get("AP_USER_ID"));
                Map<String, String> costInfo = endAp_mapper.costSmsInfo(formData);
                
                smsMap.put("CORP_NO", costInfo.get("CORP_NO"));     	// 고객사 사업자번호
                smsMap.put("BRC", costInfo.get("BRC"));             	// 고객사 부서
                smsMap.put("EPRO_PS_DSC", "1");     					// 1  : 구매
                smsMap.put("EPRO_RATE_DSC", "01");  					// 01 : 최초
                smsMap.put("APLY_DT", costInfo.get("APLY_DT"));     	// 발생일 YYYYMMDD
                smsMap.put("USER_ID", costInfo.get("USER_ID"));     	// 고객사 보내는사람 ID
                smsMap.put("CONT_TBL_ID", "STOCIVAP");              	// 검증 테이블
                smsMap.put("CONT_TBL_PK", costInfo.get("CONT_TBL_PK")); // 검증 조건
                smsMap.put("tmp", data.get("RECV_USER_ID"));            // 유니크한 값.
                smsMap.put("payFlag", "Y");
                
                eversmsservice.sendSmsNhe(smsMap);
            }
        }
		catch (Exception ex) {
		    logger.error("대금지급요청 반려 후 메일&문자 발송 오류 : " + ex.getMessage());
		}
        
        rtnMap.put("rtnMsg", msg.getMessageByScreenId("CAPR0011", "015"));
        return rtnMap;
    }

    // 결재상신
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public Map<String, String> capr0011_doUpdateApproval(Map<String, String> formData) throws Exception {
        Map<String, String> rtnMap = new HashMap<>();

        UserInfo userInfo = UserInfoManager.getUserInfo();

        if (EverString.isEmpty(formData.get("APP_DOC_NUM"))) {
            // 채번로직 변경. Parameter [화면에서 전달 받은 COMPANY_CD (없는 경우, ses.manageCd 또는 ses.companyCd), DOC_TYPE ]
            formData.put("APP_DOC_NUM", docNumService.getDocNumber(userInfo.getCompanyCd(), "APPDOC"));
        }

        String preSignStatus = formData.get("PRE_SIGN_STATUS");
        String appDocCnt = formData.get("APP_DOC_CNT");

        if (EverString.isEmpty(appDocCnt) || appDocCnt.equals("0")) {
            appDocCnt = "1";
        } else {
            // 이전의 SIGN_STATUS가 반려(R), 결재취소(C)이면 결재차수 = 결재차수 + 1
            if (preSignStatus.equals("R") || preSignStatus.equals("C") || "20".equals(formData.get("PROGRESS_CD"))) {
                appDocCnt = String.valueOf(Integer.parseInt(appDocCnt) + 1);
            }
        }
        formData.put("APP_DOC_CNT", appDocCnt);

        // 결재요청
        approvalService.doApprovalProcess(formData, formData.get("approvalFormData"), formData.get("approvalGridData"));

        capr0010_mapper.capr0011_doUpdateApprovalIVAP(formData);

        rtnMap.put("rtnMsg", msg.getMessageByScreenId("CAPR0011", "013"));

        return rtnMap;
    }
    
    public void capr0011_doUpdatePdfUUID(Map<String, Object> param) {
    	capr0010_mapper.capr0011_doUpdatePdfUUID(param);
    }

}
