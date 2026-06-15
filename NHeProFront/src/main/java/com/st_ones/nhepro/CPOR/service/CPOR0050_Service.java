package com.st_ones.nhepro.CPOR.service;

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
import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.common.mail.service.EverMailService;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.sms.service.EverSmsService;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.common.util.service.LargeTextService;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.eversrm.eApproval.eApprovalEnd.INV.EApprovalEndInv_Mapper;
import com.st_ones.eversrm.eApproval.eApprovalModule.service.BAPM_Service;
import com.st_ones.nhepro.CPOR.CPOR0050_Mapper;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : CPOR0050_Service.java
 * @date 2018. 01. 30.
 * @version 1.0
 */

@Service(value = "CPOR0050_Service")
public class CPOR0050_Service extends BaseService {

    @Autowired MessageService msg;
    @Autowired CPOR0050_Mapper cpor0050_mapper;
    @Autowired LargeTextService largeTextService;
    @Autowired private DocNumService docNumService;
    @Autowired private BAPM_Service approvalService;

    @Autowired private EApprovalEndInv_Mapper endInv_Mapper;
    @Autowired private EverMailService evermailservice;
    @Autowired private EverSmsService eversmsservice;
    
    Logger logger = LoggerFactory.getLogger(this.getClass());
    
    /**
     * 화면명 : 검수대기현황
     * 처리내용 : 협력업체에서 작성하여 검수요청한 현황을 조회하고 승인/반려 처리하는 화면
     * 경로 : 고객사 > 발주관리 > 검수/입고 > 검수대기현황
     */
    public List<Map<String, Object>> cpor0050_doSearch(Map<String, String> param) {

        return cpor0050_mapper.cpor0050_doSearch(param);
    }

    // 검수담당자 변경
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public Map<String, String> cpor0050_doUpdateChange(Map<String, String> formData, List<Map<String, Object>> grid) throws Exception {
        Map<String, String> rtnMap = new HashMap<>();

        for(Map<String, Object> data : grid) {
            data.put("INSPECT_USER_ID", formData.get("PIC_USER_ID"));

            cpor0050_mapper.cpor0050_doUpdateChangePOHD(data);
        }

        rtnMap.put("rtnMsg", msg.getMessageByScreenId("CPOR0050", "004"));

        return rtnMap;
    }
    
    // 전체검수(공사, 용역 등) : 사용안함
    // 협력사 검수요청서 승인
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public Map<String, String> cpor0050_doUpdateConfirm(Map<String, String> formData, List<Map<String, Object>> grid) throws Exception {
        Map<String, String> rtnMap = new HashMap<>();

        for(Map<String, Object> data : grid) {
            data.put("PROGRESS_CD", "700");
            data.put("INV_DATE", formData.get("INV_DATE"));
            
            cpor0050_mapper.cpor0050_doUpdateIVHD(data);
        }
        
        rtnMap.put("rtnMsg", msg.getMessageByScreenId("CPOR0050", "011"));
        return rtnMap;
    }
    
    // 전체검수(공사, 용역 등) : 사용안함
    // 협력사 검수요청서 반려
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public Map<String, String> cpor0050_doUpdateReject(Map<String, String> formData, List<Map<String, Object>> grid) throws Exception {
        Map<String, String> rtnMap = new HashMap<>();

        for(Map<String, Object> data : grid) {
            data.put("PROGRESS_CD", "500");
            data.put("INV_DATE", "");
            
            cpor0050_mapper.cpor0050_doUpdateIVHD(data);
            cpor0050_mapper.cpor0050_doUpdateIVGH(data);
        }

        rtnMap.put("rtnMsg", msg.getMessageByScreenId("CPOR0050", "012"));
        return rtnMap;
    }

    /**
     * 화면명 : 검수요청서
     * 처리내용 : 검수요청서의 상세내용을 조회하는 화면
     * 경로 : 고객사 > 발주관리 > 검수/입고 > 검수대기현황 > 검수요청서 (팝업)
     */
    public Map<String, Object> cpor0051_doSearchIVHD(Map<String, String> param) throws Exception {
        Map<String, Object> fParam;

        if(!"".equals(param.get("APP_DOC_NUM")) && param.get("APP_DOC_NUM") != null) {
            param.put("BUYER_CD", param.get("buyerCd"));
        }

        fParam = cpor0050_mapper.cpor0051_doSearchIVHD(param);

        fParam.put("RMK_TEXT", largeTextService.selectLargeText(EverString.nullToEmptyString(fParam.get("RMK_TEXT_NUM"))));

        return fParam;
    }

    // 품목정보, 조회
    public List<Map<String, Object>> cpor0051_doSearchIVDT(Map<String, String> formData, Map<String, String> param) throws Exception {
        Map<String, Object> fParam = new HashMap<>();

        return cpor0050_mapper.cpor0051_doSearchIVDT(formData);
    }

    // 검수요청상세, 조회
    public List<Map<String, Object>> cpor0051_doSearchIVGH(Map<String, String> formData, Map<String, String> param) throws Exception {

        return cpor0050_mapper.cpor0051_doSearchIVGH(formData);
    }

    // 지불고객사, 조회
    public List<Map<String, Object>> cpor0051_doSearchPOPC(Map<String, String> formData, Map<String, String> param) throws Exception {

        return cpor0050_mapper.cpor0051_doSearchPOPC(formData);
    }

    // 차수별 합계
    public List<Map<String, Object>> cpor0051_getPayCntSumAmt(Map<String, String> formData, Map<String, String> param) throws Exception {

        return cpor0050_mapper.cpor0051_getPayCntSumAmt(formData);
    }

    /**
     * 2021.01.20 검수요청서 반송 추가
     * @param formData
     * @param gridPOPC
     * @return
     * @throws Exception
     */
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public Map<String, String> cpor0051_doReject(Map<String, String> param) throws Exception {
		
	    Map<String, String> rtnMap = new HashMap<>();
	    
	    String deliveryType = param.get("DELIVERY_TYPE");
	    if("DI".equals(deliveryType)) {
            param.put("PROGRESS_CD", "400"); // 부분검수(납품 : 물품)
        } else {
            param.put("PROGRESS_CD", "500"); // 전체검수(검수 : 공사, 용역)
        }
        
        cpor0050_mapper.cpor0051_setInvRejectIVHD(param);
        cpor0050_mapper.cpor0051_setInvRejectIVGH(param);
        cpor0050_mapper.cpor0051_setInvRejectPODT(param); // 반송수량은 발주의 검수요청수량에서 제외함
        // 2021.06.30
        // 검수요청서 및 거래명세서 반려 SMS 발송 및 수수료 추가
        try {
	        String title = "검수요청서";
	        if("DI".equals(deliveryType)) {
	            title = "거래명세서";
	        }
	        
	        String linkUrl = PropertiesManager.getString("eversrm.urls.maintain.real") ;
	        
	        List<Map<String, String>> listMail = endInv_Mapper.getMailList(param);
	        for(Map<String, String> data : listMail) {
            	String subject = "[전자구매시스템] 협력사 [" + data.get("VENDOR_NM") + "]에서 요청한 [" + data.get("SUBJECT") + "] 관련 [" + title + "]가 반려되었습니다";
            	
            	// E-MAIL
                Map<String,String> mailMap = new HashMap<>();
                mailMap.put("SUBJECT", subject);

                String content = "<BR> 안녕하세요." +
                        "<BR> [" + data.get("VENDOR_NM") + "] " + data.get("USER_NM") + " 님." +
                        "<BR> " +
                        "<BR> 아래와 같이 협력사에서 요청하신 [" + title  + "]가 반려처리 되였습니다." +
                        "<BR> 협력사 : [" + data.get("VENDOR_NM") + "]" +
                        "<BR> 계약명 : [" + data.get("SUBJECT")   + "]" +
                        "<BR> 승인일 : [" + data.get("SIGN_DATE") + "]" +
                        "<BR> 처리결과 : [반려]" +
                        "<BR> " +
                        "<BR> 전자구매시스템에 <a href='" + linkUrl + "' target='newP'>로그인</a> 하시어, 세부내용을 확인 해주십시오." +
                        "<BR> " +
                        "<BR> 감사합니다.";
                
                mailMap.put("CONTENTS", content);
                mailMap.put("REF_MODULE_CD", "MIV02");
                mailMap.put("RECV_USER_ID", data.get("RECV_USER_ID"));
                mailMap.put("REF_NUM", data.get("INV_NUM"));
                evermailservice.SendMail(mailMap);
                
                //SMS
                Map<String,String> smsMap = new HashMap<String,String>();
                smsMap.put("CONTENTS", subject);
                smsMap.put("REF_MODULE_CD", "SIV02");
                smsMap.put("RECV_USER_ID", data.get("RECV_USER_ID"));
                
                // 검수 승인 후 검수담당자 고객사에게 SMS수수료 부과
                param.put("INSPECT_USER_ID", data.get("INSPECT_USER_ID"));
                Map<String, String> costInfo = endInv_Mapper.costSmsInfo(data);
                
                smsMap.put("CORP_NO", costInfo.get("CORP_NO"));     	// 고객사 사업자번호
                smsMap.put("BRC", costInfo.get("BRC"));            		// 고객사 부서
                smsMap.put("EPRO_PS_DSC", "1");     					// 1  : 구매
                smsMap.put("EPRO_RATE_DSC", "01");  					// 01 : 최초
                smsMap.put("APLY_DT", costInfo.get("APLY_DT"));     	// 발생일 YYYYMMDD
                smsMap.put("USER_ID", costInfo.get("USER_ID"));     	// 고객사 보내는사람 ID
                smsMap.put("CONT_TBL_ID", "STOCIVHD");              	// 검증 테이블
                smsMap.put("CONT_TBL_PK", costInfo.get("CONT_TBL_PK")); // 검증 조건
                smsMap.put("tmp", data.get("CONT_TBL_PK"));            	// 유니크한 값.
                smsMap.put("payFlag", "Y");
                
                eversmsservice.sendSmsNhe(smsMap);
	        }
        }
		catch (Exception ex) {
		    logger.error("검수(거래명세서) 요청건 반려 후 메일&문자 발송 오류 : " + ex.getMessage());
		}
        
	    rtnMap.put("rtnMsg", msg.getMessageByScreenId("CPOR0051", "019"));
	    return rtnMap;
	}

    // 결재상신
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public Map<String, String> cpor0051_doUpdateApproval(Map<String, String> formData, List<Map<String, Object>> gridPOPC) throws Exception {
    	
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
            if (preSignStatus.equals("R") || preSignStatus.equals("C") || "100".equals(formData.get("PROGRESS_CD"))) {
                appDocCnt = String.valueOf(Integer.parseInt(appDocCnt) + 1);
            }
        }
        formData.put("APP_DOC_CNT", appDocCnt);

        // 결재요청
        approvalService.doApprovalProcess(formData, formData.get("approvalFormData"), formData.get("approvalGridData"));
        cpor0050_mapper.cpor0051_doUpdateApprovalIVHD(formData);
        
        for(Map<String, Object> data : gridPOPC) {
            data.put("BUYER_CD", formData.get("BUYER_CD"));
            data.put("DEPT_CD", formData.get("DEPT_CD"));
            data.put("INV_NUM", formData.get("INV_NUM"));
            data.put("VENDOR_CD", formData.get("VENDOR_CD"));
            data.put("CUR", formData.get("CUR"));
            data.put("VAT_TYPE", formData.get("VAT_TYPE"));
            
            if(!"".equals(data.get("IVPC_GATE_CD")) && data.get("IVPC_GATE_CD") != null) {
                cpor0050_mapper.cpor0051_doUpdateIVPC(data);
            } else {
                cpor0050_mapper.cpor0051_doInsertIVPC(data);
            }
            // 2021.09.06 : 발주서의 정산담당자 변경 추가
            cpor0050_mapper.cpor0051_doUpdatePOPC(data);
        }

        rtnMap.put("rtnMsg", msg.getMessageByScreenId("CPOR0051", "013"));
        return rtnMap;
    }
    
    // 2021.11.23 추가
    // 대금지급요청서의 대금지급상태가 지급완료 이전까지 고객사 첨부파일은 변경 가능
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public Map<String, String> cpor0051_doUpdateFileInfo(Map<String, String> formData) throws Exception {
    	
        Map<String, String> rtnMap = new HashMap<>();
        cpor0050_mapper.cpor0051_doUpdateFileInfo(formData);
        
        rtnMap.put("rtnMsg", msg.getMessage("0016"));
        return rtnMap;
    }

    /**
     * 화면명 : 검수현황
     * 처리내용 : 처리한 검수현황을 조회하고 특정 검수요청서를 취소처리 하는 화면
     * 경로 : 고객사 > 발주관리 > 검수/입고 > 검수현황
     */
    public List<Map<String, Object>> cpor0060_doSearch(Map<String, String> param) {

        return cpor0050_mapper.cpor0060_doSearch(param);
    }

    // 검수취소
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public Map<String, String> cpor0060_doUpdateCancel(Map<String, String> formData, List<Map<String, Object>> grid) throws Exception {
        Map<String, String> rtnMap = new HashMap<>();

        for(Map<String, Object> data : grid) {
            data.put("PROGRESS_CD", "100");

            cpor0050_mapper.cpor0060_doUpdateCancelINVHD(data);
            cpor0050_mapper.cpor0060_doUpdateCancelIVPC(data);

            data.put("PROGRESS_CD", "7100");

            cpor0050_mapper.cpor0060_doUpdateCancelPODT(data);
        }

        rtnMap.put("rtnMsg", msg.getMessageByScreenId("CPOR0060", "003"));

        return rtnMap;
    }

}
