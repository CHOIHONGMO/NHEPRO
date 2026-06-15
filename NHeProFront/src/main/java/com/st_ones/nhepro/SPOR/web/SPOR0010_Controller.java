package com.st_ones.nhepro.SPOR.web;

import com.st_ones.common.combo.service.CommonComboService;
import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.util.clazz.EverDate;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.nhepro.SPOR.service.SPOR0010_Service;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

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
 * @File Name : SPOR0010_Controller.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

@Controller
@RequestMapping(value = "/nhepro/SPOR")
public class SPOR0010_Controller extends BaseController {

    @Autowired private SPOR0010_Service spor0010_service;
    @Autowired private CommonComboService commonComboService;
    @Autowired private MessageService msg;

    /**
     * 화면명 : 발주접수현황
     * 처리내용 : 협력업체에서 발주 요청 현황을 조회하고, 접수 및 반려하는 화면
     * 경로 : 협력업체 > 발주관리 > 발주관리 > 발주접수현황
     */
    @RequestMapping(value="/SPOR0010/view")
    public String SPOR0010(EverHttpRequest req) throws Exception {
        req.setAttribute("FROM_PO_DATE", EverDate.addDateMonth(EverDate.getDate(), -1));
        req.setAttribute("TO_PO_DATE", EverDate.addDateMonth(EverDate.getDate(), 0));

        return "/nhepro/SPOR/SPOR0010";
    }

    // 조회
    @RequestMapping(value = "/spor0010_doSearch")
    public void spor0010_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.setGridObject("grid", spor0010_service.spor0010_doSearch(req.getFormData()));
    }

    // 접수
    @RequestMapping(value = "/spor0010_doSaveReceipt")
    public void spor0010_doSaveReceipt(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        List<Map<String, Object>> grid = req.getGridData("grid");

        Map<String, String> rtnMap = spor0010_service.spor0010_doSaveReceipt(req.getFormData(), grid);

        resp.setResponseMessage(rtnMap.get("rtnMsg"));
    }

    // 반려
    @RequestMapping(value = "/spor0010_doSaveReject")
    public void spor0010_doSaveReject(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        List<Map<String, Object>> grid = req.getGridData("grid");

        Map<String, String> rtnMap = spor0010_service.spor0010_doSaveReject(req.getFormData(), grid);

        resp.setResponseMessage(rtnMap.get("rtnMsg"));
    }

    /**
     * 화면명 : 발주서
     * 처리내용 : 협력업체에서 발주 요청 현황을 조회하고, 접수 및 반려하는 화면
     * 경로 : 협력업체 > 발주관리 > 발주관리 > 발주접수현황 (SPOR0010) > 발주서(팝업)
     * 경로 : 협력업체 > 발주관리 > 발주관리 > 발주진행현황 (SPOR0020) > 발주서(팝업)
     * 경로 : 협력업체 > 발주관리 > 납품관리 > 거래명세서대상조회 (SPOR0030) > 발주서(팝업)
     */
    @RequestMapping(value="/SPOR0011/view")
    public String SPOR0011(EverHttpRequest req) throws Exception {
        Map<String, String> param = req.getParamDataMap();
        Map<String, Object> data = new HashMap<>();

        if (!"".equals(param.get("PO_NUM")) && param.get("PO_NUM") != null) {
            data = spor0010_service.spor0011_doSearchPOHD(param);
        }

        req.setAttribute("formData", data);

        return "/nhepro/SPOR/SPOR0011";
    }

    // 품목정보, 조회, PODT
    @RequestMapping(value = "/spor0011_doSearchPODT")
    public void spor011_doSearchPODT(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> param = req.getParamDataMap();

        resp.setGridObject("gridMTGL", spor0010_service.spor0011_doSearchPODT(req.getFormData(), param));
    }

    // 지불정보, 조회, POPY
    @RequestMapping(value = "/spor0011_doSearchPOPY")
    public void spor0011_doSearchPOPY(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> param = req.getParamDataMap();

        resp.setGridObject("gridPOPY", spor0010_service.spor0011_doSearchPOPY(req.getFormData(), param));
    }

    /**
     * 화면명 : 발주진행현황
     * 처리내용 : 품목별 발주 진행현황을 보여주는 화면
     * 경로 : 협력업체 > 발주관리 > 발주관리 > 발주진행현황
     */
    @RequestMapping(value="/SPOR0020/view")
    public String SPOR0020(EverHttpRequest req) throws Exception {
        req.setAttribute("FROM_PO_DATE", EverDate.addDateMonth(EverDate.getDate(), -1));
        req.setAttribute("TO_PO_DATE", EverDate.addDateMonth(EverDate.getDate(), 0));

        return "/nhepro/SPOR/SPOR0020";
    }

    // 조회
    @RequestMapping(value = "/spor0020_doSearch")
    public void spor0020_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.setGridObject("grid", spor0010_service.spor0020_doSearch(req.getFormData()));
    }
}
