package com.st_ones.nhepro.OVNR.web;

import com.st_ones.common.combo.service.CommonComboService;
import com.st_ones.common.util.clazz.EverDate;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.nhepro.OVNR.service.OVNR0020_Service;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.HashMap;
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
 * @File Name : OVNR0020_Controller.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

@Controller
@RequestMapping(value = "/nhepro/OVNR")
public class OVNR0020_Controller extends BaseController {

    @Autowired private OVNR0020_Service ovnr0020_service;
    @Autowired private CommonComboService commonComboService;

    /**
     * 화면명 : 협력업체별 사용자현황
     * 처리내용 : 협력업체 사용자를 등록 및 수정하는 화면.
     * 경로 : 운영사 > 회원사 관리 > 협력업체 관리 > 협력업체별 사용자현황
     */
    @RequestMapping(value="/OVNR0020/view")
    public String OVNR0020(EverHttpRequest req) {
        req.setAttribute("regFromDate", EverDate.addDateMonth(EverDate.getDate(), -2));
        req.setAttribute("regToDate", EverDate.addDateMonth(EverDate.getDate(), 0));

        return "/nhepro/OVNR/OVNR0020";
    }

    // 조회
    @RequestMapping(value = "/ovnr0020_doSearch")
    public void ovnr0020_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.setGridObject("grid", ovnr0020_service.ovnr0020_doSearch(req.getFormData()));
    }

    // 삭제
    @RequestMapping(value = "/ovnr0020_doDelete")
    public void ovnr0020_doDelete(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        String rtnMsg = ovnr0020_service.ovnr0020_doDelete(req.getGridData("grid"));

        resp.setResponseMessage(rtnMsg);
    }

    /**
     * 화면명 : 협력업체별 사용자 상세
     * 처리내용 : 사용자 상세 정보 조회 및 수정(Block), 비밀번호 초기화 하는 화면.
     * 경로 : 운영사 > 회원사 관리 > 협력업체 관리 > 협력업체별 사용자현황 > 협력업체별 사용자 상세 (팝업)
     */
    @RequestMapping(value="/OVNR0021/view")
    public String OVNR0021(EverHttpRequest req) throws Exception{
        Map<String, String> param = req.getFormData();
        Map<String, Object> formData;

        String userId = EverString.nullToEmptyString(req.getParameter("USER_ID"));

        param.put("USER_ID", userId);

        formData = ovnr0020_service.ovnr0021_doSearch(param);

        req.setAttribute("vnglRoleList", commonComboService.getCodeCombo("MP055"));
        req.setAttribute("formData", formData);

        return "/nhepro/OVNR/OVNR0021";
    }

    // 저장
    @RequestMapping(value = "/ovnr0021_doSave")
    public void ovnr0021_doSave(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> rtnMap = ovnr0020_service.ovnr0021_doSave(req.getFormData());

        resp.setParameter("USER_ID", rtnMap.get("USER_ID"));
        resp.setResponseMessage(rtnMap.get("rtnMsg"));
    }

    // 삭제
    @RequestMapping(value = "/ovnr0021_doDelete")
    public void ovnr0021_doDelete(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        String rtnMsg = ovnr0020_service.ovnr0021_doDelete(req.getFormData());

        resp.setResponseMessage(rtnMsg);
    }

    // 비밀번호 초기화
    @RequestMapping(value = "/ovnr0021_doPasswordInit")
    public void ovnr0021_doPasswordInit(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> rtnMap = ovnr0020_service.ovnr0021_doPasswordInit(req.getFormData());

        resp.setParameter("USER_ID", rtnMap.get("USER_ID"));
        resp.setResponseMessage(rtnMap.get("rtnMsg"));
    }
}
