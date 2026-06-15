package com.st_ones.nhepro.CVNR.web;

import com.st_ones.common.combo.service.CommonComboService;
import com.st_ones.common.util.clazz.EverDate;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.nhepro.CVNR.service.CVNR0010_Service;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

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
 * @File Name : CVNR0010_Controller.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

@Controller
@RequestMapping(value = "/nhepro/CVNR")
public class CVNR0010_Controller extends BaseController {

    @Autowired private CVNR0010_Service cvnr0010_service;
    @Autowired private CommonComboService commonComboService;

    /**
     * 화면명 : 신규업체대기현황
     * 처리내용 : 신규로 등록한 협력사를 승인하는 화면
     * 경로 : 고객사 > 기준정보 > 협력업체관리 > 신규업체대기현황
     */
    @RequestMapping(value="/CVNR0010/view")
    public String CVNR0010(EverHttpRequest req) {
        req.setAttribute("regFromDate", EverDate.addDateMonth(EverDate.getDate(), -2));
        req.setAttribute("regToDate", EverDate.addDateMonth(EverDate.getDate(), 0));

        return "/nhepro/CVNR/CVNR0010";
    }

    // 조회
    @RequestMapping(value = "/cvnr0010_doSearch")
    public void cvnr0010_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.setGridObject("grid", cvnr0010_service.cvnr0010_doSearch(req.getFormData()));
    }

    /**
     * 화면명 : 협력업체 상세
     * 처리내용 : 등록된 협력사를 수정/승인/반려 하는 화면.
     * 경로 : 고객사 > 기준정보 > 협력업체관리 > 신규업체대기현황 > 협력업체 상세 (팝업)
     * 경로 : 고객사 > 기준정보 > 협력업체관리 > 협력업체현황 > 협력업체 상세 (팝업)
     */
    @RequestMapping(value="/CVNR0011/view")
    public String CVNR0011(EverHttpRequest req) throws Exception {
    	
        Map<String, String> param = req.getFormData();
        
        String vendorCd = EverString.nullToEmptyString(req.getParameter("VENDOR_CD"));
        
        Map<String, Object> formData;
        param.put("VENDOR_CD", vendorCd);
        formData = cvnr0010_service.cvnr0011_doSearch(param);
        
        // 2021.10.01 : NICE 평가정보 링크
        long nk = Long.parseLong(EverDate.getDate()) * 677;
        req.setAttribute("nk", nk);
        
        req.setAttribute("formData", formData);
        
        return "/nhepro/CVNR/CVNR0011";
    }
    
    // 담당자정보 조회
    @RequestMapping(value = "/cvnr0011_doSearchCVUR")
    public void cvnr0011_doSearchCVUR(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.setGridObject("gridCVUR", cvnr0010_service.cvnr0011_doSearchCVUR(req.getFormData()));
    }
    
    // 특허 및 취급면허, 조회
    @RequestMapping(value = "/cvnr0011_doSearchVNSL")
    public void cvnr0011_doSearchVNSL(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.setGridObject("gridVNSL", cvnr0010_service.cvnr0011_doSearchVNSL(req.getFormData()));
    }

    // 결제정보, 조회
    @RequestMapping(value = "/cvnr0011_doSearchVNAP")
    public void cvnr0011_doSearchVNAP(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.setGridObject("gridVNAP", cvnr0010_service.cvnr0011_doSearchVNAP(req.getFormData()));
    }

    // 첨부파일, 조회
    @RequestMapping(value = "/cvnr0011_doSearchATTD")
    public void cvnr0011_doSearchATTD(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.setGridObject("gridATTD", cvnr0010_service.cvnr0011_doSearchATTD(req.getFormData()));
    }

    // 거래희망 고객사, 조회
    @RequestMapping(value = "/cvnr0011_doSearchVNCM")
    public void cvnr0011_doSearchVNCM(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.setGridObject("gridVNCM", cvnr0010_service.cvnr0011_doSearchVNCM(req.getFormData()));
    }

    // 승인
    @RequestMapping(value = "/cvnr0011_doConfirm")
    public void cvnr0011_doConfirm(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> rtnMap = cvnr0010_service.cvnr0011_doConfirm(req.getFormData());

        resp.setResponseMessage(rtnMap.get("rtnMsg"));
    }

    // 반려
    @RequestMapping(value = "/cvnr0011_doReject")
    public void cvnr0011_doReject(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> rtnMap = cvnr0010_service.cvnr0011_doReject(req.getFormData());

        resp.setResponseMessage(rtnMap.get("rtnMsg"));
    }

    /**
     * 화면명 : 협력업체현황
     * 처리내용 : 등록된 협력사정보를 조회하는 화면
     * 경로 : 고객사 > 기준정보 > 협력업체관리 > 협력업체현황
     */
    @RequestMapping(value="/CVNR0020/view")
    public String CVNR0020(EverHttpRequest req) {
//        req.setAttribute("regFromDate", EverDate.addDateMonth(EverDate.getDate(), -2));
//        req.setAttribute("regToDate", EverDate.addDateMonth(EverDate.getDate(), 0));

        return "/nhepro/CVNR/CVNR0020";
    }

    // 조회
    @RequestMapping(value = "/cvnr0020_doSearch")
    public void cvnr0020_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.setGridObject("grid", cvnr0010_service.cvnr0020_doSearch(req.getFormData()));
    }

}
