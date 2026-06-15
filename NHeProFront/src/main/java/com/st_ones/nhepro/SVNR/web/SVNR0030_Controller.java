package com.st_ones.nhepro.SVNR.web;

import com.st_ones.common.combo.service.CommonComboService;
import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.common.util.clazz.EverDate;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.nhepro.SVNR.service.SVNR0030_Service;
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
 * @File Name : SVNR0030_Controller.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

@Controller
@RequestMapping(value = "/nhepro/SVNR")
public class SVNR0030_Controller extends BaseController {

    @Autowired private SVNR0030_Service svnr0030_service;
    @Autowired private CommonComboService commonComboService;

    /**
     * 화면명 : 사용자현황
     * 처리내용 : 사용자를 등록 및 수정하는 화면.
     * 경로 : 협력업체 > 관리자 > 사용자관리 > 사용자현황
     */
    @RequestMapping(value="/SVNR0030/view")
    public String SVNR0030(EverHttpRequest req) {
        req.setAttribute("regFromDate", EverDate.addDateMonth(EverDate.getDate(), -2));
        req.setAttribute("regToDate", EverDate.addDateMonth(EverDate.getDate(), 0));

        return "/nhepro/SVNR/SVNR0030";
    }

    // 조회
    @RequestMapping(value = "/svnr0030_doSearch")
    public void svnr0030_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.setGridObject("grid", svnr0030_service.svnr0030_doSearch(req.getFormData()));
    }

    // 저장
    @RequestMapping(value = "/svnr0030_doSave")
    public void svnr0030_doSave(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        String rtnMsg = svnr0030_service.svnr0030_doSave(req.getGridData("grid"));

        resp.setResponseMessage(rtnMsg);
    }

    // 삭제
    @RequestMapping(value = "/svnr0030_doDelete")
    public void svnr0030_doDelete(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        String rtnMsg = svnr0030_service.svnr0030_doDelete(req.getGridData("grid"));

        resp.setResponseMessage(rtnMsg);
    }

    /**
     * 화면명 : 사용자 상세
     * 처리내용 : 사용자 상세 정보 조회 및 수정하는 화면.
     * 경로 : 협력업체 > 관리자 > 사용자관리 > 사용자현황 > 사용자 상세 (팝업)
     */
    @RequestMapping(value="/SVNR0031/view")
    public String SVNR0031(EverHttpRequest req) throws Exception{
        Map<String, String> param = req.getParamDataMap();
        Map<String, Object> formData = new HashMap<>();;

        UserInfo userInfo = UserInfoManager.getUserInfo();

        if(!"".equals(param.get("USER_ID")) && param.get("USER_ID") != null) {
            formData = svnr0030_service.svnr0031_doSearch(param);
        } else {
            formData.put("USER_ID", "");
            formData.put("COMPANY_CD", userInfo.getCompanyCd());
            formData.put("COMPANY_NM", userInfo.getCompanyNm());

        }

        req.setAttribute("formData", formData);

        return "/nhepro/SVNR/SVNR0031";
    }

    // 저장
    @RequestMapping(value = "/svnr0031_doSave")
    public void svnr0031_doSave(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> rtnMap = svnr0030_service.svnr0031_doSave(req.getFormData());

        resp.setParameter("USER_ID", rtnMap.get("USER_ID"));
        resp.setResponseMessage(rtnMap.get("rtnMsg"));
    }

    // 사용자ID 중복체크
    @RequestMapping(value = "/svnr0031_doDupChkUserId")
    public void svnr0031_doDupChkUserId(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> rtnMap = svnr0030_service.svnr0031_doDupChkUserId(req.getFormData());

        resp.setParameter("USER_ID", rtnMap.get("USER_ID"));
        resp.setParameter("DUP_CHECK_ID_YN", rtnMap.get("DUP_CHECK_ID_YN"));
        resp.setResponseMessage(rtnMap.get("rtnMsg"));
    }

}
