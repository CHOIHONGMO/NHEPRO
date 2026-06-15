package com.st_ones.nhepro.SAPR.service;

import com.st_ones.common.docNum.service.DocNumService;
import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.common.mail.service.EverMailService;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.sms.service.EverSmsService;
import com.st_ones.common.util.clazz.EverConverter;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.common.util.service.LargeTextService;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.nhepro.SAPR.SAPR0010_Mapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.text.DecimalFormat;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : SAPR0010_Service.java
 * @date 2018. 01. 30.
 * @version 1.0
 */

@Service(value = "SAPR0010_Service")
public class SAPR0010_Service extends BaseService {

    @Autowired MessageService msg;
    @Autowired SAPR0010_Mapper sapr0010_mapper;
    @Autowired LargeTextService largeTextService;
    @Autowired private DocNumService docNumService;
    @Autowired private EverMailService evermailservice;
    @Autowired private EverSmsService eversmsservice;

    /**
     * 화면명 : 대금지급요청대상현황
     * 처리내용 : 고객사에 의해 납품행위가 확인된 검수요청서 및 거래명세서 대상으로 『대금지급 요청서』를 작성하는 화면
     * 경로 : 협력업체 > 발주관리 > 대금지급 > 대금지급요청대상현황
     */
    public List<Map<String, Object>> sapr0010_doSearch(Map<String, String> param) throws Exception {
        return sapr0010_mapper.sapr0010_doSearch(param);
    }

    /**
     * 화면명 : 대금지급요청서
     * 처리내용 : 선택한 검수/입고 건을 기준으로 대금청구요청서를 작성하는 화면
     * 경로 : 협력업체 > 발주관리 > 대금지급 > 대금지급요청대상현황 (sapr0010) > 대금지급요청서(팝업)
     */
    public Map<String, Object> sapi0011_doSearch(Map<String, String> param) throws Exception {
        return sapr0010_mapper.sapi0011_doSearch(param);
    }

    public Map<String, Object> sapi0011_doSearchIVHD(Map<String, String> param) throws Exception {

        Map<String, Object> fParam = sapr0010_mapper.sapi0011_doSearchIVHD(param);

        fParam.put("RMK_TEXT", largeTextService.selectLargeText(EverString.nullToEmptyString(fParam.get("RMK_TEXT_NUM"))));
        fParam.put("GUAR_RMK_TEXT", largeTextService.selectLargeText(EverString.nullToEmptyString(fParam.get("GUAR_RMK"))));

        return fParam;
    }

    // 품목정보, 조회, PODT
    public List<Map<String, Object>> sapi0011_doSearchIVDT(Map<String, String> formData, Map<String, String> param) throws Exception {

        return sapr0010_mapper.sapi0011_doSearchIVDT(formData);
    }

    // 대금지급요청 이력, 조회
    public List<Map<String, Object>> sapi0011_doSearchIVAP(Map<String, String> formData, Map<String, String> param) throws Exception {

        return sapr0010_mapper.sapi0011_doSearchIVAP(formData);
    }

    // 저장
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public Map<String, String> sapi0011_doSave(Map<String, String> formData, List<Map<String, Object>> grid) throws Exception {
    	
        Map<String, String> rtnMap = new HashMap<>();

        String AP_NUM;
        String TYPE = formData.get("TYPE");

        formData.put("RMK_TEXT_NUM", largeTextService.saveLargeText(formData.get("RMK_TEXT_NUM"), formData.get("RMK_TEXT")));
        formData.put("GUAR_RMK", largeTextService.saveLargeText(formData.get("GUAR_RMK"), formData.get("GUAR_RMK_TEXT")));

        if("SEND".equals(TYPE)) {
            formData.put("SIGN_STATUS", "20");
        } else if("GUAR".equals(TYPE)) {
            formData.put("SIGN_STATUS", "10");
            formData.put("INSU_STATUS", "SA");
        } else {
            formData.put("SIGN_STATUS", "10");
        }

        if(!"".equals(formData.get("AP_NUM")) && formData.get("AP_NUM") != null) {
            AP_NUM = formData.get("AP_NUM");
            sapr0010_mapper.sapi0011_doUpdateIVAP(formData);
        } else {
            AP_NUM = docNumService.getDocNumber(formData.get("BUYER_CD"), "IAP");
            formData.put("AP_NUM", AP_NUM);
            sapr0010_mapper.sapi0011_doInsertIVAP(formData);
        }

        if("SEND".equals(TYPE)) {
            sapr0010_mapper.sapi0011_doUpdateSignIVAP(formData);
            for(Map<String, Object> data : grid) {
                data.put("BUYER_CD", formData.get("BUYER_CD"));
                data.put("TYPE", TYPE);
                data.put("PROGRESS_CD", "7300");
                
                sapr0010_mapper.sapi0011_doUpdatePODT(data);
                
                // 2021.02.02 제외 : 발주 이후 프로세스는 발주진행상태만 변경함
                // 2021.01.27 추가 : 구매진행상태=7300 변경
                //sapr0010_mapper.setPrProgressCd(data);
            }
            
            if(!PropertiesManager.getBoolean("eversrm.system.developmentFlag")) {
	            // 메일 및 SMS 발송
	            String linkUrl = PropertiesManager.getString("eversrm.urls.maintain.real") ;
	            List<Map<String, String>> listMail = sapr0010_mapper.getMailList(formData);
	            for(Map<String, String> data : listMail) {
	            	try {
		            	String subject = "[전자구매시스템] 협력사 [" + data.get("VENDOR_NM") + "]가 [" + data.get("SUBJECT") + "] 관련 [" + data.get("AP_REQ_SUBJECT") + "] 대금지급을 요청하였습니다";
		            	
		                //SMS
		                if("1".equals(data.get("SMS_FLAG"))) {
		                    Map<String,String> smsMap = new HashMap<String,String>();
		                    smsMap.put("CONTENTS", subject);
		                    smsMap.put("REF_MODULE_CD", "SAP01");
		                    smsMap.put("RECV_USER_ID", data.get("AP_USER_ID"));
		                    
		                    // 2021.06.30 : 협력사 대금지급 요청시 SMS 수수료 부과
							smsMap.put("CORP_NO", data.get("CORP_NO"));			// 고객사 사업자번호
							smsMap.put("BRC", data.get("BRC"));					// 고객사 부서
							smsMap.put("EPRO_PS_DSC", "1");						// 1  : 구매
		                    smsMap.put("EPRO_RATE_DSC", "01");					// 01 : 최초
							smsMap.put("APLY_DT", data.get("APLY_DT"));			// 발생일 YYYYMMDD
							smsMap.put("USER_ID", data.get("USER_ID"));			// 고객사 보내는사람 ID
							smsMap.put("CONT_TBL_ID", "STOCIVAP");				// 검증 테이블
							smsMap.put("CONT_TBL_PK", data.get("CONT_TBL_PK")); // 검증 조건(협력사별 입찰번호)
							smsMap.put("tmp", data.get("CONT_TBL_PK"));			// myBatis 버그 해결을 위한 무의미한, 유니크한 값.
							smsMap.put("payFlag", "Y");
							
		                    eversmsservice.sendSmsNhe(smsMap);
		                }
		                
		                DecimalFormat decimalformat = new DecimalFormat("###,###");
		                
		                //EMAIL
		                if("1".equals(data.get("MAIL_FLAG"))) {
		                    Map<String,String> mailMap = new HashMap<>();
		                    mailMap.put("SUBJECT", subject);
		
		                    String content = "<BR> 안녕하십니까!" +
		                            "<BR> [" + data.get("BUYER_NM") + "] [" + data.get("INSPECT_USER_NM") + "]님" +
		                            "<BR>                   " +
		                            "<BR> 아래와 같이 협력사에서 대금지급을 요청 하였습니다." +
		                            "<BR> 협력사 : [" + data.get("VENDOR_NM") + "]" +
		                            "<BR> 발주명 : [" + data.get("SUBJECT") + "]" +
		                            "<BR> 요청일 : [" + data.get("AP_REQ_DATE") + "]" +
		                            "<BR> 지급명 : [" + data.get("AP_REQ_SUBJECT") + "]" +
		                            "<BR> 지급차수 : [" + data.get("PAY_INFO") + "]" +
		                            "<BR> 요청금액 : [" + String.valueOf(decimalformat.format(data.get("PAY_AMT"))) + "원]";
		
		                    content += "<BR> " +
		                            "<BR> 전자구매시스템에 <a href='" + linkUrl + "' target='newP'>로그인</a> 하시어, 세부내용을 확인 후 승인/반려 해주십시오." +
		                            "<BR>                   " +
		                            "<BR> 감사합니다.";
		
		                    mailMap.put("CONTENTS", content);
		                    mailMap.put("REF_MODULE_CD", "MAP01");
		                    mailMap.put("RECV_USER_ID", data.get("AP_USER_ID"));
		                    mailMap.put("REF_NUM", data.get("AP_NUM"));
		                    evermailservice.SendMail(mailMap);
		                }
	         		}
	            	catch (Exception ex) {
	                    getLog().error("대금지급요청 전송 후 메일 및 SMS 발송 오류 : " + ex.getMessage(), ex);
	                }
	            }
            }
        }
        rtnMap.put("BUYER_CD", formData.get("BUYER_CD"));
        rtnMap.put("AP_NUM", AP_NUM);
        rtnMap.put("PY_BUYER_CD", formData.get("PY_BUYER_CD"));
        rtnMap.put("PY_DEPT_CD", formData.get("PY_DEPT_CD"));
        rtnMap.put("rtnMsg", msg.getMessage("0031"));
        
        return rtnMap;
    }

    // 삭제
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public Map<String, String> sapi0011_doDelete(Map<String, String> formData, List<Map<String, Object>> grid) throws Exception {
    	
        Map<String, String> rtnMap = new HashMap<>();
        sapr0010_mapper.sapi0011_doDeleteFlagIVAP(formData);

        rtnMap.put("rtnMsg", msg.getMessage("0031"));
        return rtnMap;
    }

    /**
     * 화면명 : 대급지급현황
     * 처리내용 : 대급지급요청서를 조회하여 특정 건 ( 작성중 ) 은 수정하고 고객사에 의하여 지급확정된 건은 진행상황을 조회하는 화면
     * 경로 : 협력업체 > 발주관리 > 대금지급 > 대급지급현황
     */
    public List<Map<String, Object>> sapr0020_doSearch(Map<String, String> param) throws Exception {
        return sapr0010_mapper.sapr0020_doSearch(param);
    }
    
    public List<Map<String, Object>> sapr0030_doSearchVNAP(Map<String, String> formData, Map<String, String> param) throws Exception {
        return sapr0010_mapper.sapr0030_doSearchVNAP(formData);
    }
}
