package com.st_ones.nhepro.SPOR.web;

import com.st_ones.common.combo.service.CommonComboService;
import com.st_ones.common.enums.system.Code;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.util.clazz.EverCert;
import com.st_ones.common.util.clazz.EverConverter;
import com.st_ones.common.util.clazz.EverDate;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.nhepro.SPOR.service.SPOR0050_Service;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import java.net.URLDecoder;
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
 * @File Name : SPOR0050_Controller.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

@Controller
@RequestMapping(value = "/nhepro/SPOR")
public class SPOR0050_Controller extends BaseController {

    @Autowired private SPOR0050_Service spor0050_service;
    @Autowired private CommonComboService commonComboService;
    @Autowired private MessageService msg;

    /**
     * 화면명 : 검수요청대상현황
     * 처리내용 : 납품유형이 검수인 발주잔액이 있는 발주서의 품목을 대상으로 “검수요청서”를 작성하는 화면
     * 경로 : 협력업체 > 발주관리 > 검수관리 > 검수요청대상현황
     */
    @RequestMapping(value="/SPOR0050/view")
    public String SPOR0030(EverHttpRequest req) throws Exception {
        req.setAttribute("FROM_DATE", EverDate.addDateMonth(EverDate.getDate(), -1));
        req.setAttribute("TO_DATE", EverDate.addDateMonth(EverDate.getDate(), 1));

        return "/nhepro/SPOR/SPOR0050";
    }

    // 조회
    @RequestMapping(value = "/spor0050_doSearch")
    public void spor0050_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> param = req.getFormData();

        param.put("SEL_DATE", req.getParamDataMap().get("SEL_DATE"));

        resp.setGridObject("grid", spor0050_service.spor0050_doSearch(param));
    }
    
    @RequestMapping(value = "/spor0050_doIvhCheck")
    public void spor0050_doIvhCheck(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        List<Map<String, Object>> gridData = req.getGridData("grid");
        
        String payCnt = spor0050_service.spor0050_doIvhCheck(gridData);
        resp.setParameter("PAY_CNT", payCnt);
        
    }

    /**
     * 화면명 : 검수요청서작성
     * 처리내용 : 선택한 발주의 기성건으로 검수요청서를 작성하는 화면
     * 경로 : 협력업체 > 발주관리 > 검수관리 > 검수요청대상현황 > 검수요청서작성 (팝업)
     */
    @RequestMapping(value="/SPOI0051/view")
    public String SPOI0051(EverHttpRequest req) throws Exception {
        Map<String, String> param = req.getParamDataMap();
        Map<String, Object> data = new HashMap<>();

        if (!"".equals(param.get("INV_NUM")) && param.get("INV_NUM") != null) {
            data = spor0050_service.spoi0051_doSearchIVHD(param);
        } else {
            data = spor0050_service.spoi0051_doSearch(param);
            
            String SUBJECT = EverString.nullToEmptyString(data.get("SUBJECT"));
            data.put("SUBJECT", SUBJECT + " " + data.get("PAY_CNT") + "차 " + data.get("PAY_CNT_NM"));
        }
        
        String localServerFlag = "N";
        if(PropertiesManager.getBoolean("eversrm.system.localserver") || PropertiesManager.getBoolean("eversrm.system.developmentFlag")) {
            localServerFlag = "Y";
        }
        
        req.setAttribute("CUR_DATE", EverDate.getDate());
        req.setAttribute("CUR_SEND_DATE", EverDate.getDate());
        req.setAttribute("localServerFlag", localServerFlag);  
        req.setAttribute("gridSel", param.get("gridSel"));
        req.setAttribute("formData", data);

        return "/nhepro/SPOR/SPOI0051";
    }

    // 품목정보, 조회
    @RequestMapping(value = "/spoi0051_doSearchIVDT")
    public void spoi0051_doSearchIVDT(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> param = req.getParamDataMap();

        resp.setGridObject("gridPODT", spor0050_service.spoi0051_doSearchIVDT(req.getFormData(), param));
    }

    // 품목정보, 조회
    @RequestMapping(value = "/spoi0051_doSearchPODT")
    public void spoi0051_doSearchPODT(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> param = req.getParamDataMap();

        resp.setGridObject("gridPODT", spor0050_service.spoi0051_doSearchPODT(req.getFormData(), param));
    }
    
    // 지불고객사, 조회
    @RequestMapping(value = "/spoi0051_doSearchPOPC")
    public void spoi0051_doSearchPOPC(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> param = req.getParamDataMap();

        resp.setGridObject("gridPOPC", spor0050_service.spoi0051_doSearchPOPC(req.getFormData(), param));
    }

    // 검수요청상세, 조회
    @RequestMapping(value = "/spoi0051_doSearchIVGH")
    public void spoi0051_doSearchIVGH(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> param = req.getParamDataMap();

        resp.setGridObject("gridIVGH", spor0050_service.spoi0051_doSearchIVGH(req.getFormData(), param));
        resp.setDataObject("CNT_SUM_AMT", spor0050_service.spoi0051_getPayCntSumAmt(req.getFormData(), param));
    }

    // 저장
    @RequestMapping(value = "/spoi0051_doSave")
    public void spoi0051_doSave(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> formData = req.getFormData();
        List<Map<String, Object>> grid = req.getGridData("gridPODT");

        formData.put("TYPE", "SAVE");
        Map<String, String> rtnMap = spor0050_service.spoi0051_doSave(formData, grid);
        
        resp.setParameter("BUYER_CD", rtnMap.get("BUYER_CD"));
        resp.setParameter("INV_NUM", rtnMap.get("INV_NUM"));
        resp.setResponseMessage(rtnMap.get("rtnMsg"));
    }

    // 검수요청서 전송
    @RequestMapping(value = "/spoi0051_doSend")
    public void spoi0051_doSend(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	
    	// 로컬 및 개발서버 여부
        String localServerFlag = EverString.nullToEmptyString(req.getParameter("localServerFlag"));
        
        String sSignData = EverString.nullToEmptyString(req.getParameter("signedData"));
        sSignData = URLDecoder.decode(sSignData, "utf-8");
        String vidRandom = EverString.nullToEmptyString(req.getParameter("vidRandom"));
        vidRandom = URLDecoder.decode(vidRandom, "utf-8");
        String idn = EverString.nullToEmptyString(req.getParameter("idn"));

        String useCard = "";
        if(PropertiesManager.getBoolean("eversrm.system.localserver") || PropertiesManager.getBoolean("eversrm.system.developmentFlag")) {
            useCard = "1";
        }

        // 운영서버에서만 서명값 검증을 진행함
        if( "N".equals(localServerFlag) ) {
            Map<String, String> certMap = EverCert.doCheckCert(sSignData, vidRandom, idn, useCard);
            // 서명값 검증 실패
            if(certMap.get("certRtnCd").equals("-1")) {
                throw new Exception(certMap.get("certRtnMsg"));
            }
        }

        Map<String, String> formData = req.getFormData();
        List<Map<String, Object>> grid = req.getGridData("gridPODT");

        formData.put("TYPE", "SEND");
        formData.put("SIGN_VALUE", sSignData);
        formData.put("SIGN_RANDOM", vidRandom);

        Map<String, String> rtnMap = spor0050_service.spoi0051_doSave(formData, grid);

        resp.setParameter("INV_NUM", rtnMap.get("INV_NUM"));
        resp.setResponseMessage(rtnMap.get("rtnMsg"));
    }

    // 삭제
    @RequestMapping(value = "/spoi0051_doDelete")
    public void spoi0051_doDelete(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	
    	Map<String, String> formData = req.getFormData();
        List<Map<String, Object>> grid = req.getGridData("gridPODT");
        
        formData.put("TYPE", "SEND");
        Map<String, String> rtnMap = spor0050_service.spoi0051_doDelete(formData, grid);

        resp.setResponseMessage(rtnMap.get("rtnMsg"));
    }

    /**
     * 화면명 : 검수요청현황
     * 처리내용 : 작성중이거나 작성완료된 거래명세서의 처리현황을 조회하는 화면
     * 경로 : 협력업체 > 발주관리 > 검수관리 > 검수요청현황
     */
    @RequestMapping(value="/SPOR0060/view")
    public String SPOR0060(EverHttpRequest req) throws Exception {
        req.setAttribute("FROM_DATE", EverDate.addDateMonth(EverDate.getDate(), -1));
        req.setAttribute("TO_DATE", EverDate.addDateMonth(EverDate.getDate(), 1));

        return "/nhepro/SPOR/SPOR0060";
    }

    // 조회
    @RequestMapping(value = "/spor0060_doSearch")
    public void spor0060_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> param = req.getFormData();

        param.put("SEL_DATE", req.getParamDataMap().get("SEL_DATE"));

        resp.setGridObject("grid", spor0050_service.spor0060_doSearch(param));
    }

}
