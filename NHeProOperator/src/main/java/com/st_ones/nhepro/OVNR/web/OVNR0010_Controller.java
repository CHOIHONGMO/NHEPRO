package com.st_ones.nhepro.OVNR.web;

import com.st_ones.common.combo.service.CommonComboService;
import com.st_ones.common.util.clazz.EverDate;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.nhepro.OVNR.service.OVNR0010_Service;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

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
 * @File Name : OVNR0010_Controller.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

@Controller
@RequestMapping(value = "/nhepro/OVNR")
public class OVNR0010_Controller extends BaseController {

    @Autowired private OVNR0010_Service ovnr0010_service;
    @Autowired private CommonComboService commonComboService;

    /**
     * 화면명 : 협력업체현황
     * 처리내용 : 등록된 협력사정보를 조회하는 화면.
     * 경로 : 운영사 > 회원사 관리 > 협력업체 관리 > 협력업체현황
     */
    @RequestMapping(value="/OVNR0010/view")
    public String OVNR0010(EverHttpRequest req) {
        req.setAttribute("regFromDate", EverDate.addDateMonth(EverDate.getDate(), -2));
        req.setAttribute("regToDate", EverDate.addDateMonth(EverDate.getDate(), 0));

        return "/nhepro/OVNR/OVNR0010";
    }

    // 조회
    @RequestMapping(value = "/ovnr0010_doSearch")
    public void ovnr0010_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.setGridObject("grid", ovnr0010_service.ovnr0010_doSearch(req.getFormData()));
    }
    
    // 협력업체 BLOCK
    @RequestMapping(value = "/ovnr0010_doBlock")
    public void ovnr0010_doBlock(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        List<Map<String, Object>> grid = req.getGridData("grid");

        Map<String, String> rtnMap = ovnr0010_service.ovnr0010_doBlock(req.getFormData(), grid);

        resp.setResponseMessage(rtnMap.get("rtnMsg"));
    }
    
    // 협력업체 BLOCK해제
    @RequestMapping(value = "/ovnr0010_doBlockRemove")
    public void ovnr0010_doBlockRemove(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        List<Map<String, Object>> grid = req.getGridData("grid");

        Map<String, String> rtnMap = ovnr0010_service.ovnr0010_doBlockRemove(req.getFormData(), grid);

        resp.setResponseMessage(rtnMap.get("rtnMsg"));
    }

    /**
     * 화면명 : 협력업체 상세
     * 처리내용 : 등록된 협력사정보를 조회하는 화면.
     * 경로 : 운영사 > 회원사 관리 > 협력업체 관리 > 협력업체현황 > 협력업체 상세 (팝업)
     */
    @RequestMapping(value="/OVNR0011/view")
    public String OVNR0011(EverHttpRequest req) throws Exception {
        Map<String, String> param = req.getFormData();
        Map<String, Object> formData;
        
        String vendorCd = EverString.nullToEmptyString(req.getParameter("VENDOR_CD"));
        
        param.put("VENDOR_CD", vendorCd);
        formData = ovnr0010_service.ovnr0011_doSearch(param);
        
        // 2021.10.06 : NICE 평가정보 링크
        long nk = Long.parseLong(EverDate.getDate()) * 677;
        req.setAttribute("nk", nk);
        
        req.setAttribute("formData", formData);

        return "/nhepro/OVNR/OVNR0011";
    }

    // 특허 및 취급면허, 조회
    @RequestMapping(value = "/ovnr0011_doSearchVNSL")
    public void ovnr0011_doSearchVNSL(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.setGridObject("gridVNSL", ovnr0010_service.ovnr0011_doSearchVNSL(req.getFormData()));
    }

    // 결제정보, 조회
    @RequestMapping(value = "/ovnr0011_doSearchVNAP")
    public void ovnr0011_doSearchVNAP(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.setGridObject("gridVNAP", ovnr0010_service.ovnr0011_doSearchVNAP(req.getFormData()));
    }

    // 첨부파일, 조회
    @RequestMapping(value = "/ovnr0011_doSearchATTD")
    public void ovnr0011_doSearchATTD(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.setGridObject("gridATTD", ovnr0010_service.ovnr0011_doSearchATTD(req.getFormData()));
    }

    // 거래희망 고객사, 조회
    @RequestMapping(value = "/ovnr0011_doSearchVNCM")
    public void ovnr0011_doSearchVNCM(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.setGridObject("gridVNCM", ovnr0010_service.ovnr0011_doSearchVNCM(req.getFormData()));
    }

}
