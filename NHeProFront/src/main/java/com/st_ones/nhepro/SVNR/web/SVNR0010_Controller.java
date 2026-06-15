package com.st_ones.nhepro.SVNR.web;

import com.st_ones.common.combo.service.CommonComboService;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.nhepro.SVNR.service.SVNR0010_Service;
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
 * @File Name : SVNR0010_Controller.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

@Controller
@RequestMapping(value = "/nhepro/SVNR")
public class SVNR0010_Controller extends BaseController {

    @Autowired private SVNR0010_Service svnr0010_service;
    @Autowired private CommonComboService commonComboService;

    /**
     * 화면명 : 회사정보
     * 처리내용 : 회사정보를 수정하는 화면.
     * 경로 : 협력회사 > 관리자 > 조직관리 > 회사정보
     */
    @RequestMapping(value="/SVNR0010/view")
    public String SVNR0010(EverHttpRequest req) throws Exception {
        Map<String, String> param = req.getFormData();
        Map<String, Object> formData;

        String vendorCd = EverString.nullToEmptyString(req.getParameter("VENDOR_CD"));

        param.put("VENDOR_CD", vendorCd);

        formData = svnr0010_service.svnr0010_doSearch(param);

        req.setAttribute("formData", formData);

        return "/nhepro/SVNR/SVNR0010";
    }

    // 특허 및 취급면허, 조회
    @RequestMapping(value = "/svnr0010_doSearchVNSL")
    public void svnr0010_doSearchVNSL(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.setGridObject("gridVNSL", svnr0010_service.svnr0010_doSearchVNSL(req.getFormData()));
    }

    // 결제정보, 조회
    @RequestMapping(value = "/svnr0010_doSearchVNAP")
    public void svnr0010_doSearchVNAP(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.setGridObject("gridVNAP", svnr0010_service.svnr0010_doSearchVNAP(req.getFormData()));
    }

    // 첨부파일, 조회
    @RequestMapping(value = "/svnr0010_doSearchATTD")
    public void svnr0010_doSearchATTD(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.setGridObject("gridATTD", svnr0010_service.svnr0010_doSearchATTD(req.getFormData()));
    }

    // 거래희망 고객사, 조회
    @RequestMapping(value = "/svnr0010_doSearchVNCM")
    public void svnr0010_doSearchVNCM(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.setGridObject("gridVNCM", svnr0010_service.svnr0010_doSearchVNCM(req.getFormData()));
    }

    // 수정
    @RequestMapping(value = "/svnr0010_doUpdate")
    public void svnr0010_doUpdate(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        List<Map<String, Object>> gridVNSL = req.getGridData("gridVNSL");
        List<Map<String, Object>> gridVNAP = req.getGridData("gridVNAP");
        List<Map<String, Object>> gridATTD = req.getGridData("gridATTD");
        List<Map<String, Object>> gridVNCM = req.getGridData("gridVNCM");

        Map<String, String> rtnMap = svnr0010_service.svnr0010_doUpdate(req.getFormData(), gridVNSL, gridVNAP, gridATTD, gridVNCM);

        resp.setParameter("VENDOR_CD", rtnMap.get("VENDOR_CD"));
        resp.setResponseMessage(rtnMap.get("rtnMsg"));
    }

    // 특허 및 취급면허 그리드, 행 삭제
    @RequestMapping(value = "/svnr0010_doDeleteVNSL")
    public void svnr0010_doDeleteVNSL(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        svnr0010_service.svnr0010_doDeleteVNSL(req.getFormData(), req.getGridData("gridVNSL"));
    }

    // 결제정보 그리드, 행 삭제
    @RequestMapping(value = "/svnr0010_doDeleteVNAP")
    public void svnr0010_doDeleteVNAP(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        svnr0010_service.svnr0010_doDeleteVNAP(req.getFormData(), req.getGridData("gridVNAP"));
    }

    // 거래희망 고객사 그리드, 행 삭제
    @RequestMapping(value = "/svnr0010_doDeleteVNCM")
    public void svnr0010_doDeleteVNCM(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        svnr0010_service.svnr0010_doDeleteVNCM(req.getFormData(), req.getGridData("gridVNCM"));
    }

    // 거래희망 고객사 그리드, 행 저장 (수정 시, 변경전 고객사 삭제)
    @RequestMapping(value = "/svnr0010_doInsertVNCM")
    public void svnr0010_doInsertVNCM(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> param = req.getFormData();

        param.put("BUYER_CD", req.getParameter("VNCM_BUYER_CD"));
        param.put("DEPT_CD", req.getParameter("VNCM_DEPT_CD"));
        param.put("DEL_BUYER_CD", req.getParameter("DEL_BUYER_CD"));
        param.put("DEL_DEPT_CD", req.getParameter("DEL_DEPT_CD"));
        param.put("REQ_REASON", req.getParameter("REQ_REASON"));
        Map<String, String> rtnMap = svnr0010_service.svnr0010_doInsertVNCM(param);
        
        resp.setResponseMessage(rtnMap.get("rtnMsg"));
    }

    // 거래희망 고객사 그리드, 재요청
    @RequestMapping(value = "/svnr0010_doUpdateReq")
    public void svnr0010_doUpdateReq(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        List<Map<String, Object>> gridVNCM = req.getGridData("gridVNCM");

        Map<String, String> rtnMap = svnr0010_service.svnr0010_doUpdateReq(req.getFormData(), gridVNCM);

        resp.setResponseMessage(rtnMap.get("rtnMsg"));
    }
}
