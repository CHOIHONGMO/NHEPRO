package com.st_ones.nhepro.SAPR.web;

import com.st_ones.common.combo.service.CommonComboService;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.util.clazz.EverCert;
import com.st_ones.common.util.clazz.EverDate;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.nhepro.SAPR.service.SAPR0010_Service;
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
 * @File Name : SAPR0010_Controller.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

@Controller
@RequestMapping(value = "/nhepro/SAPR")
public class SAPR0010_Controller extends BaseController {

    @Autowired private SAPR0010_Service sapr0010_service;
    @Autowired private CommonComboService commonComboService;
    @Autowired private MessageService msg;

    /**
     * 화면명 : 대금지급요청대상현황
     * 처리내용 : 고객사에 의해 납품행위가 확인된 검수요청서 및 거래명세서 대상으로 『대금지급 요청서』를 작성하는 화면
     * 경로 : 협력업체 > 발주관리 > 대금지급 > 대금지급요청대상현황
     */
    @RequestMapping(value="/SAPR0010/view")
    public String SAPR0010(EverHttpRequest req) throws Exception {
        req.setAttribute("FROM_DATE", EverDate.addDateMonth(EverDate.getDate(), -1));
        req.setAttribute("TO_DATE", EverDate.addDateMonth(EverDate.getDate(), 1));

        return "/nhepro/SAPR/SAPR0010";
    }

    // 조회
    @RequestMapping(value = "/sapr0010_doSearch")
    public void sapr0010_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.setGridObject("grid", sapr0010_service.sapr0010_doSearch(req.getFormData()));
    }

    /**
     * 화면명 : 대금지급요청서
     * 처리내용 : 선택한 검수/입고 건을 기준으로 대금청구요청서를 작성하는 화면
     * 경로 : 협력업체 > 발주관리 > 대금지급 > 대금지급요청대상현황 (sapr0010) > 대금지급요청서(팝업)
     */
    @RequestMapping(value="/SAPI0011/view")
    public String SAPI0011(EverHttpRequest req) throws Exception {
        Map<String, String> param = req.getParamDataMap();
        Map<String, Object> data = new HashMap<>();

        if (!"".equals(param.get("AP_NUM")) && param.get("AP_NUM") != null) {
            data = sapr0010_service.sapi0011_doSearchIVHD(param);
        } else {
            data = sapr0010_service.sapi0011_doSearch(param);
            
            String SUBJECT = EverString.nullToEmptyString(data.get("SUBJECT"));
            data.put("AP_REQ_SUBJECT", SUBJECT + " " + data.get("PAY_CNT") + "차 " + data.get("PAY_CNT_NM"));
        }
        
        String PAY_CNT_NM = EverString.nullToEmptyString(data.get("PAY_CNT_NM"));
        data.put("PAY_INFO", data.get("PAY_CNT") + "차 " + PAY_CNT_NM);
        
        String localServerFlag = "N";
        if(PropertiesManager.getBoolean("eversrm.system.localserver") || PropertiesManager.getBoolean("eversrm.system.developmentFlag")) {
            localServerFlag = "Y";
        }
        
        req.setAttribute("localServerFlag", localServerFlag);  
        req.setAttribute("formData", data);
        return "/nhepro/SAPR/SAPI0011";
    }

    // 품목정보, 조회
    @RequestMapping(value = "/sapi0011_doSearchIVDT")
    public void sapi0011_doSearchIVDT(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> param = req.getParamDataMap();

        resp.setGridObject("gridPODT", sapr0010_service.sapi0011_doSearchIVDT(req.getFormData(), param));
    }

    // 대금지급요청 이력, 조회
    @RequestMapping(value = "/sapi0011_doSearchIVAP")
    public void sapi0011_doSearchIVAP(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> param = req.getParamDataMap();

        resp.setGridObject("gridIVAP", sapr0010_service.sapi0011_doSearchIVAP(req.getFormData(), param));
    }

    // 저장
    @RequestMapping(value = "/sapi0011_doSave")
    public void sapi0011_doSave(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	
        Map<String, String> formData = req.getFormData();
        List<Map<String, Object>> grid = req.getGridData("gridPODT");

        formData.put("TYPE", "SAVE");
        Map<String, String> rtnMap = sapr0010_service.sapi0011_doSave(formData, grid);
        
        resp.setParameter("BUYER_CD", rtnMap.get("BUYER_CD"));
        resp.setParameter("AP_NUM", rtnMap.get("AP_NUM"));
        resp.setParameter("PY_BUYER_CD", rtnMap.get("PY_BUYER_CD"));
        resp.setParameter("PY_DEPT_CD", rtnMap.get("PY_DEPT_CD"));
        resp.setResponseMessage(rtnMap.get("rtnMsg"));
    }

    // 전자보증
    @RequestMapping(value = "/sapi0011_doSaveGuarantee")
    public void sapi0011_doSaveGuarantee(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> formData = req.getFormData();
        List<Map<String, Object>> grid = req.getGridData("gridPODT");

        formData.put("TYPE", "GUAR");

        Map<String, String> rtnMap = sapr0010_service.sapi0011_doSave(formData, grid);

        resp.setParameter("AP_NUM", rtnMap.get("AP_NUM"));
        resp.setResponseMessage(rtnMap.get("rtnMsg"));
    }

    // 전송
    @RequestMapping(value = "/sapi0011_doSend")
    public void sapi0011_doSend(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	
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

        Map<String, String> rtnMap = sapr0010_service.sapi0011_doSave(formData, grid);

        resp.setParameter("AP_NUM", rtnMap.get("AP_NUM"));
        resp.setResponseMessage(rtnMap.get("rtnMsg"));
    }

    // 삭제
    @RequestMapping(value = "/sapi0011_doDelete")
    public void sapi0011_doDelete(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        List<Map<String, Object>> grid = req.getGridData("gridPODT");

        Map<String, String> rtnMap = sapr0010_service.sapi0011_doDelete(req.getFormData(), grid);

        resp.setResponseMessage(rtnMap.get("rtnMsg"));
    }

    /**
     * 화면명 : 대급지급현황
     * 처리내용 : 대급지급요청서를 조회하여 특정 건 ( 작성중 ) 은 수정하고 고객사에 의하여 지급확정된 건은 진행상황을 조회하는 화면
     * 경로 : 협력업체 > 발주관리 > 대금지급 > 대급지급현황
     */
    @RequestMapping(value="/SAPR0020/view")
    public String SAPR0020(EverHttpRequest req) throws Exception {
        req.setAttribute("FROM_DATE", EverDate.addDateMonth(EverDate.getDate(), -1));
        req.setAttribute("TO_DATE", EverDate.addDateMonth(EverDate.getDate(), 1));

        return "/nhepro/SAPR/SAPR0020";
    }

    // 조회
    @RequestMapping(value = "/sapr0020_doSearch")
    public void sapr0020_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> param = req.getFormData();

        param.put("SEL_DATE", req.getParamDataMap().get("SEL_DATE"));

        resp.setGridObject("grid", sapr0010_service.sapr0020_doSearch(param));
    }
    
    
    /**
     * 화면명 : 결제정보(협력업체)
     * 처리내용 : 해당 협력업체가 가입 시 입력한 결제정보 팝업
     * 경로 : 협력업체 > 발주관리 > 대금지급 > 대금지급요청대상현황 (sapr0010) > 대금지급요청서(팝업) > 입급계좌(팝업)
     */
    @RequestMapping(value="/SAPR0030/view")
    public String CCDU0010(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        req.setAttribute("form", req.getParamDataMap());
        return "/nhepro/SAPR/SAPR0030";
    }
    
    @RequestMapping(value = "/sapr0030_doSearchVNAP")
    public void sapr0030_doSearchVNAP(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> param = req.getParamDataMap();

        resp.setGridObject("grid", sapr0010_service.sapr0030_doSearchVNAP(req.getFormData(), param));
    }
}
