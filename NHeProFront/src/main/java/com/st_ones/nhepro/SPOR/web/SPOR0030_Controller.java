package com.st_ones.nhepro.SPOR.web;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.st_ones.common.combo.service.CommonComboService;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.util.clazz.EverCert;
import com.st_ones.common.util.clazz.EverConverter;
import com.st_ones.common.util.clazz.EverDate;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.nhepro.SPOR.service.SPOR0030_Service;

import org.apache.commons.lang3.StringUtils;
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
 * @File Name : SPOR0030_Controller.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

@Controller
@RequestMapping(value = "/nhepro/SPOR")
public class SPOR0030_Controller extends BaseController {

    @Autowired private SPOR0030_Service spor0030_service;
    @Autowired private CommonComboService commonComboService;
    @Autowired private MessageService msg;

    /**
     * 화면명 : 거래명세서대상조회
     * 처리내용 : 납품유형이 납품인 발주서의 품목을 대상으로 거래명세서를 작성하는 화면
     * 경로 : 협력업체 > 발주관리 > 납품관리 > 거래명세서대상조회
     */
    @RequestMapping(value="/SPOR0030/view")
    public String SPOR0030(EverHttpRequest req) throws Exception {
        req.setAttribute("FROM_DATE", EverDate.addDateMonth(EverDate.getDate(), -1));
        req.setAttribute("TO_DATE", EverDate.addDateMonth(EverDate.getDate(), 1));

        return "/nhepro/SPOR/SPOR0030";
    }

    // 조회
    @RequestMapping(value = "/spor0030_doSearch")
    public void spor0030_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> param = req.getFormData();

        param.put("SEL_DATE", req.getParamDataMap().get("SEL_DATE"));

        resp.setGridObject("grid", spor0030_service.spor0030_doSearch(param));
    }
    
    /**
     * 화면명 : 거래명세서 작성
     * 처리내용 : 선택된 품목으로 거래명세서를 작성 또는 “거래명세서 현황 (SPOR0040) 화면에서＂작성중인 거래명세서를 수정하는 화면
     * 경로 : 협력업체 > 발주관리 > 납품관리 > 거래명세서대상조회 > 거래명세서 작성 (팝업)
     */
    @RequestMapping(value="/SPOI0031/view")
    public String SPOI0031(EverHttpRequest req) throws Exception {
        Map<String, String> param = req.getParamDataMap();
        Map<String, Object> data = new HashMap<>();

        if (!"".equals(param.get("INV_NUM")) && param.get("INV_NUM") != null) {
            data = spor0030_service.spoi0031_doSearchIVHD(param);
        } else {
            data = spor0030_service.spoi0031_doSearch(param);
        }
        
        // 2021.01.26 추가 : 로컬서버여부
        String localServerFlag = "N";
        if(PropertiesManager.getBoolean("eversrm.system.localserver") || PropertiesManager.getBoolean("eversrm.system.developmentFlag")) {
            localServerFlag = "Y";
        }
        
        req.setAttribute("CUR_DATE", EverDate.getDate());
        req.setAttribute("CUR_SEND_DATE", EverDate.getDate());
        req.setAttribute("localServerFlag", localServerFlag);  
        req.setAttribute("gridSel", param.get("gridSel"));
        req.setAttribute("formData", data);

        return "/nhepro/SPOR/SPOI0031";
    }

    // 품목정보, 조회
    @RequestMapping(value = "/spoi0031_doSearchIVDT")
    public void spoi0031_doSearchIVDT(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> param = req.getParamDataMap();

        resp.setGridObject("grid", spor0030_service.spoi0031_doSearchIVDT(req.getFormData(), param));
    }

    // 품목정보, 조회
    @RequestMapping(value = "/spoi0031_doSearchPODT")
    public void spoi0031_doSearchPODT(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> param = req.getParamDataMap();

        resp.setGridObject("grid", spor0030_service.spoi0031_doSearchPODT(req.getFormData(), param));
    }

    // 부분검수요청서 작성 (SPOI0031)
    @RequestMapping(value = "/spoi0031_doSave")
    public void spoi0031_doSave(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> formData = req.getFormData();
        List<Map<String, Object>> grid = req.getGridData("grid");

        formData.put("TYPE", "SAVE");
        Map<String, String> rtnMap = spor0030_service.spoi0031_doSave(formData, grid);
        
        resp.setParameter("BUYER_CD", rtnMap.get("BUYER_CD"));
        resp.setParameter("INV_NUM", rtnMap.get("INV_NUM"));
        resp.setResponseMessage(rtnMap.get("rtnMsg"));
    }
    
    // 부분검수요청서 작성 (SPOI0031)
    @RequestMapping(value = "/spoi0031_doSend")
    public void spoi0031_doSend(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	
        String sSignData = EverString.nullToEmptyString(req.getParameter("signedData"));
        sSignData = URLDecoder.decode(sSignData, "utf-8");
        String vidRandom = EverString.nullToEmptyString(req.getParameter("vidRandom"));
        vidRandom = URLDecoder.decode(vidRandom, "utf-8");
        String idn = EverString.nullToEmptyString(req.getParameter("idn"));

        String useCard = "";
        if(PropertiesManager.getBoolean("eversrm.system.localserver") || PropertiesManager.getBoolean("eversrm.system.developmentFlag")) {
            useCard = "1";
        }
        
        // 2021.01.27 추가 : 로컬서버여부
        if( !PropertiesManager.getBoolean("eversrm.system.localserver") ) {
            Map<String, String> certMap = EverCert.doCheckCert(sSignData, vidRandom, idn, useCard);
            // 서명값 검증 실패
            if(certMap.get("certRtnCd").equals("-1")) {
                throw new Exception(certMap.get("certRtnMsg"));
            }
        }

        Map<String, String> formData = req.getFormData();
        List<Map<String, Object>> grid = req.getGridData("grid");

        formData.put("TYPE", "SEND");
        formData.put("SIGN_VALUE", sSignData);
        formData.put("SIGN_RANDOM", vidRandom);

        Map<String, String> rtnMap = spor0030_service.spoi0031_doSave(formData, grid);

        resp.setParameter("INV_NUM", rtnMap.get("INV_NUM"));
        resp.setResponseMessage(rtnMap.get("rtnMsg"));
    }

    // 삭제
    @RequestMapping(value = "/spoi0031_doDelete")
    public void spoi0031_doDelete(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> formData = req.getFormData();
        List<Map<String, Object>> grid = req.getGridData("grid");
        
        String progressCd = EverString.nullToEmptyString(formData.get("PROGRESS_CD"));
        
        if( progressCd != null && !"400".equals(progressCd) ) {
        	formData.put("TYPE", "DEL");
        	Map<String, String> rtnMap = spor0030_service.spoi0031_doDelete(formData, grid);
        	resp.setResponseMessage(rtnMap.get("rtnMsg"));
        } else {
        	Map<String, String> rtnMap = spor0030_service.spoi0031_doRejectDelete(formData, grid);
        	resp.setResponseMessage(rtnMap.get("rtnMsg"));
        }
    }
    
    @RequestMapping(value="/spoi0031_doCheckINVData")
    public void spoi0031_doCheckINVData(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> param = req.getFormData();
        
        String poNum = req.getParameter("REJECT_PO_NUM");
        param.put("PO_NUM", poNum);
        
        List<Map<String, Object>> gridData = req.getGridData("grid");
        String msg = "0";
        
        Map<String, String> formData = spor0030_service.spoi0031_doCheckINVData(param);
        String qty = EverString.nullToEmptyString(formData.get("INV_QTY"));
        System.out.println("qty ======> " + qty);
        
        // 검수요청 완료건이 있는 경우
        if( "1".equals(qty) ){
            msg = "1";
        }
        System.out.println("msg =====> " + msg);
        resp.setResponseMessage(msg);
    }

    /**
     * 화면명 : 거래명세서현황
     * 처리내용 : 작성중인 건의 수정 작성 및 작성(전송)완료된 거래명세서의 입행현황을 조회하는 화면
     * 경로 : 협력업체 > 발주관리 > 납품관리 > 거래명세서현황
     */
    @RequestMapping(value="/SPOR0040/view")
    public String SPOR0040(EverHttpRequest req) throws Exception {
        req.setAttribute("FROM_DATE", EverDate.addDateMonth(EverDate.getDate(), -1));
        req.setAttribute("TO_DATE", EverDate.addDateMonth(EverDate.getDate(), 1));

        return "/nhepro/SPOR/SPOR0040";
    }

    // 조회
    @RequestMapping(value = "/spor0040_doSearch")
    public void spor0040_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> param = req.getFormData();

        param.put("SEL_DATE", req.getParamDataMap().get("SEL_DATE"));

        resp.setGridObject("grid", spor0030_service.spor0040_doSearch(param));
    }
}
