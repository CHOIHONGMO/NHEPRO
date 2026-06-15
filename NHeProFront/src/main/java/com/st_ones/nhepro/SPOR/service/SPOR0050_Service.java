package com.st_ones.nhepro.SPOR.service;

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
import com.st_ones.nhepro.SPOR.SPOR0050_Mapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

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
 * @File Name : SPOR0050_Service.java
 * @date 2018. 01. 30.
 * @version 1.0
 */

@Service(value = "SPOR0050_Service")
public class SPOR0050_Service extends BaseService {

    @Autowired MessageService msg;
    @Autowired SPOR0050_Mapper spor0050_mapper;
    @Autowired LargeTextService largeTextService;
    @Autowired private DocNumService docNumService;
    @Autowired private EverMailService evermailservice;
    @Autowired private EverSmsService eversmsservice;

    /**
     * 화면명 : 검수요청대상현황
     * 처리내용 : 납품유형이 검수인 발주잔액이 있는 발주서의 품목을 대상으로 “검수요청서”를 작성하는 화면
     * 경로 : 협력업체 > 발주관리 > 검수관리 > 검수요청대상현황
     */
    public List<Map<String, Object>> spor0050_doSearch(Map<String, String> param) throws Exception {
        return spor0050_mapper.spor0050_doSearch(param);
    }

    /**
     * 화면명 : 검수요청서작성
     * 처리내용 : 선택한 발주의 기성건으로 검수요청서를 작성하는 화면
     * 경로 : 협력업체 > 발주관리 > 검수관리 > 검수요청대상현황 > 검수요청서작성 (팝업)
     */
    public Map<String, Object> spoi0051_doSearch(Map<String, String> param) throws Exception {
        Map<String, Object> fParam = new HashMap<>();

        List<Map<String, Object>> list = EverConverter.readJsonObject(param.get("gridSel"), List.class);

        fParam.put("BUYER_CD", list.get(0).get("BUYER_CD"));
        fParam.put("DEPT_CD", list.get(0).get("DEPT_CD"));
        fParam.put("PO_NUM", list.get(0).get("PO_NUM"));
        fParam.put("PAY_CNT", list.get(0).get("PAY_CNT"));
        fParam.put("LIST", list);

        return spor0050_mapper.spoi0051_doSearch(fParam);
    }
    
    public String spor0050_doIvhCheck(List<Map<String, Object>> gridData) {
    	String returnStr = "";
    	
    	for (Map<String, Object> rowData : gridData) {
    		returnStr = spor0050_mapper.spor0050_doIvhCheck(rowData);
        }
    	System.out.println("returnStr====> " + returnStr);
    	if(returnStr != null) {
    		returnStr = String.valueOf(Integer.parseInt(returnStr));
    	} else {
    		returnStr = "0";
    	}
    	return returnStr;
    }
    

    public Map<String, Object> spoi0051_doSearchIVHD(Map<String, String> param) throws Exception {
        Map<String, Object> fParam;
        fParam = spor0050_mapper.spoi0051_doSearchIVHD(param);
        
        fParam.put("RMK_TEXT", largeTextService.selectLargeText(EverString.nullToEmptyString(fParam.get("RMK_TEXT_NUM"))));
        return fParam;
    }

    // 품목정보, 조회
    public List<Map<String, Object>> spoi0051_doSearchIVDT(Map<String, String> formData, Map<String, String> param) throws Exception {
    	
        Map<String, Object> fParam = new HashMap<>();
        return spor0050_mapper.spoi0051_doSearchIVDT(formData);
    }

    // 품목정보, 조회
    public List<Map<String, Object>> spoi0051_doSearchPODT(Map<String, String> formData, Map<String, String> param) throws Exception {
        Map<String, Object> fParam = new HashMap<>();

        List<Map<String, Object>> list = EverConverter.readJsonObject(param.get("gridSel"), List.class);

        fParam.put("BUYER_CD", list.get(0).get("BUYER_CD"));
        fParam.put("PO_NUM", list.get(0).get("PO_NUM"));
        fParam.put("LIST", list);

        return spor0050_mapper.spoi0051_doSearchPODT(fParam);
    }
    
    // 지불고객사, 조회
    public List<Map<String, Object>> spoi0051_doSearchPOPC(Map<String, String> formData, Map<String, String> param) throws Exception {

        return spor0050_mapper.spoi0051_doSearchPOPC(formData);
    }

    // 검수요청상세, 조회
    public List<Map<String, Object>> spoi0051_doSearchIVGH(Map<String, String> formData, Map<String, String> param) throws Exception {

        return spor0050_mapper.spoi0051_doSearchIVGH(formData);
    }

    // 차수별 합계
    public List<Map<String, Object>> spoi0051_getPayCntSumAmt(Map<String, String> formData, Map<String, String> param) throws Exception {

        return spor0050_mapper.spoi0051_getPayCntSumAmt(formData);
    }

    // 저장
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public Map<String, String> spoi0051_doSave(Map<String, String> formData, List<Map<String, Object>> grid) throws Exception {
    	
        String INV_NUM;
        String TYPE = formData.get("TYPE");

        formData.put("RMK_TEXT_NUM", largeTextService.saveLargeText(formData.get("RMK_TEXT_NUM"), formData.get("RMK_TEXT")));
        if("SEND".equals(TYPE)) {
            formData.put("PROGRESS_CD", "100");
        } else if("GUAR".equals(TYPE)) {
            formData.put("PROGRESS_CD", "50");
            formData.put("INSU_STATUS", "TT");
        } else {
            formData.put("PROGRESS_CD", "50");
        }

        if(!"".equals(formData.get("INV_NUM")) && formData.get("INV_NUM") != null) {
            INV_NUM = formData.get("INV_NUM");

            spor0050_mapper.spoi0051_doUpdateIVHD(formData);
            spor0050_mapper.spoi0051_doUpdateIVGH(formData);
            spor0050_mapper.spoi0051_doDeleteIVDT(formData);
        } else {
            INV_NUM = docNumService.getDocNumber(formData.get("BUYER_CD"), "INV");
            formData.put("INV_NUM", INV_NUM);
            formData.put("DELIVERY_TYPE", "PI");

            spor0050_mapper.spoi0051_doInsertIVHD(formData);
            spor0050_mapper.spoi0051_doInsertIVGH(formData);
        }

        for(Map<String, Object> data : grid) {
            data.put("PURCHASE_TYPE", formData.get("PURCHASE_TYPE"));
            data.put("PAY_CNT", formData.get("PAY_CNT"));
            data.put("INV_NUM", INV_NUM);
            data.put("ITEM_AMT", data.get("INV_AMT"));
            data.put("TYPE", TYPE);

            if("SEND".equals(TYPE)) {
                data.put("PROGRESS_CD", "7100");
            }

            spor0050_mapper.spoi0051_doInsertIVDT(data);
            spor0050_mapper.spoi0051_doUpdatePODT(data);
            
            // 2021.01.29 추가 : 검수이후의 진행상태는 발주진행상태에 영향을 미침(구매진행상태 변경하지 않음)
            // 2021.01.27 추가 : 구매진행상태=7100 변경
            //spor0050_mapper.setPrProgressCd(data);
        }

        if("SEND".equals(TYPE)) {
            spor0050_mapper.spoi0051_doUpdateSignIVHD(formData);
            if(!PropertiesManager.getBoolean("eversrm.system.developmentFlag")) {
	            String linkUrl = PropertiesManager.getString("eversrm.urls.maintain.real") ;
	            List<Map<String, String>> listMail = spor0050_mapper.getMailList(formData);
	
	            for(Map<String, String> data : listMail) {
	            	String subject = "[전자구매시스템] 협력사 [" + data.get("VENDOR_NM") + "]에서 [" + data.get("SUBJECT") + "] 관련 검수를 요청하였습니다";
	            	
	                //SMS
	                if("1".equals(data.get("SMS_FLAG"))) {
	                    Map<String,String> smsMap = new HashMap<String,String>();
	                    smsMap.put("CONTENTS", subject);
	                    smsMap.put("REF_MODULE_CD", "SIV01");
	                    smsMap.put("RECV_USER_ID", data.get("PIC_USER_ID"));
	                    
	                    // 2021.06.30 : 협력사 검수요청시 검수요청자 고객사에 SMS 수수료 부과
						smsMap.put("CORP_NO", data.get("CORP_NO"));			// 고객사 사업자번호
						smsMap.put("BRC", data.get("BRC"));					// 고객사 부서
						smsMap.put("EPRO_PS_DSC", "1");						// 1  : 구매
	                    smsMap.put("EPRO_RATE_DSC", "01");					// 01 : 최초
						smsMap.put("APLY_DT", data.get("APLY_DT"));			// 발생일 YYYYMMDD
						smsMap.put("USER_ID", data.get("USER_ID"));			// 고객사 보내는사람 ID
						smsMap.put("CONT_TBL_ID", "STOCIVHD");				// 검증 테이블
						smsMap.put("CONT_TBL_PK", data.get("CONT_TBL_PK")); // 검증 조건(협력사별 입찰번호)
						smsMap.put("tmp", data.get("CONT_TBL_PK"));			// myBatis 버그 해결을 위한 무의미한, 유니크한 값.
						smsMap.put("payFlag", "Y");
						
	                    eversmsservice.sendSmsNhe(smsMap);
	                }
	
	                //EMAIL
	                if("1".equals(data.get("MAIL_FLAG"))) {
	                    Map<String,String> mailMap = new HashMap<>();
	                    mailMap.put("SUBJECT", subject);
	
	                    String content = "<BR> 안녕하십니까!" +
	                            "<BR> [" + data.get("BUYER_NM") + "] [" + data.get("PIC_USER_NM") + "]님" +
	                            "<BR>                   " +
	                            "<BR> 아래와 같이 협력사에서 검수승인을 요청 하였습니다." +
	                            "<BR> 협력사 : [" + data.get("VENDOR_NM") + "]" +
	                            "<BR> 계약명 : [" + data.get("SUBJECT") + "]" +
	                            "<BR> 요청일 : [" + data.get("SEND_DATE") + "]";
	
	                    content += "<BR> " +
	                            "<BR> 전자구매시스템에 <a href='" + linkUrl + "' target='newP'>로그인</a> 하시어, 세부내용을 확인 후 승인/반려 해주십시오." +
	                            "<BR>                   " +
	                            "<BR> 감사합니다.";
	
	                    mailMap.put("CONTENTS", content);
	                    mailMap.put("REF_MODULE_CD", "MIV01");
	                    mailMap.put("RECV_USER_ID", data.get("PIC_USER_ID"));
	                    mailMap.put("REF_NUM", data.get("INV_NUM"));
	                    evermailservice.SendMail(mailMap);
	                }
	            }
            }
        }
        
        Map<String, String> rtnMap = new HashMap<>();
        rtnMap.put("BUYER_CD", formData.get("BUYER_CD"));
        rtnMap.put("INV_NUM", INV_NUM);
        
        rtnMap.put("rtnMsg", msg.getMessage("0031"));
        return rtnMap;
    }

    // 삭제
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public Map<String, String> spoi0051_doDelete(Map<String, String> formData, List<Map<String, Object>> grid) throws Exception {
        Map<String, String> rtnMap = new HashMap<>();

        spor0050_mapper.spoi0051_doDeleteFlagIVHD(formData);
        spor0050_mapper.spoi0051_doDeleteFlagIVDT(formData);
        spor0050_mapper.spoi0051_doDeleteFlagIVGH(formData);

        for(Map<String, Object> data : grid) {
            data.put("BUYER_CD", formData.get("BUYER_CD"));
            data.put("INV_QT", 0);

            spor0050_mapper.spoi0051_doUpdatePODT(data);
        }

        rtnMap.put("rtnMsg", msg.getMessage("0017"));

        return rtnMap;
    }

    /**
     * 화면명 : 검수요청현황
     * 처리내용 : 작성중이거나 작성완료된 거래명세서의 처리현황을 조회하는 화면
     * 경로 : 협력업체 > 발주관리 > 검수관리 > 검수요청현황
     */
    public List<Map<String, Object>> spor0060_doSearch(Map<String, String> param) throws Exception {
        return spor0050_mapper.spor0060_doSearch(param);
    }

}
