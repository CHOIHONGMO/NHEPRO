package com.st_ones.nhepro.OCUR.web;

import com.st_ones.common.combo.service.CommonComboService;
import com.st_ones.common.file.service.FileAttachService;
import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.common.util.clazz.EverDate;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.nhepro.OCUR.service.OCUR0030_Service;
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
 * @File Name : OCUR0030_Controller.java
 * @date 2020. 03. 09.
 * @version 1.0
 */
@Controller
@RequestMapping(value = "/nhepro/OCUR")
public class OCUR0030_Controller extends BaseController {

    @Autowired private CommonComboService commonComboService;

    @Autowired private FileAttachService fileAttachService;

    @Autowired private OCUR0030_Service ocur_Service;

    /**
     * 화면명 : 고객사별 사용자현황
     * 처리내용 : 시스템에 등록된 고객사들의 사용자들을 조회/관리하는 화면.
     * 경로 : 시스템운영사 > 회원사관리 > 고객사 관리 > 고객사별 사용자현황
     */
    @RequestMapping(value = "/OCUR0030/view")
    public String ocur0030_view(EverHttpRequest req) throws Exception {
        req.setAttribute("fromDate", EverDate.addDateMonth(EverDate.getDate(), -12));
        req.setAttribute("toDate", EverDate.getDate());
        return "/nhepro/OCUR/OCUR0030";
    }

    @RequestMapping(value="/ocur0030_doSearch")
    public void ocur0030_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.setGridObject("grid", ocur_Service.ocur0030_doSearch(req.getFormData()));
    }

    @RequestMapping(value="/ocur0030_doUpdate")
    public void ocur0030_doUpdate(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        List<Map<String, Object>> gridDatas = req.getGridData("grid");
        String returnMsg = ocur_Service.ocur0030_doUpdate(gridDatas);

        resp.setResponseMessage(returnMsg);
    }

    @RequestMapping(value="/ocur0030_doDelete")
    public void ocur0030_doDelete(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        List<Map<String, Object>> gridDatas = req.getGridData("grid");
        String returnMsg = ocur_Service.ocur0030_doDelete(gridDatas);

        resp.setResponseMessage(returnMsg);
    }

    @RequestMapping(value = "/ocur0030_doInitPassword")
    public void ocur0030_doInitPassword(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        List<Map<String, Object>> gridDatas = req.getGridData("grid");
        String rtnMsg = ocur_Service.ocur0030_doInitPassword(gridDatas);

        resp.setResponseMessage(rtnMsg);
    }

    @RequestMapping(value = "/ocur0030_doResetPwd")
    public void ocur0030_doResetPwd(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        List<Map<String, Object>> gridDatas = req.getGridData("grid");
        String rtnMsg = ocur_Service.ocur0030_doResetPwd(req.getFormData());

        resp.setResponseMessage(rtnMsg);
    }

    /**
     * 화면명 : 고객사별 사용자 등록/상세 (팝업)
     * 처리내용 : 시스템에 등록된 고객사들의 사용자들의 상세정보를 조회, 신규 사용자를 등록하는 화면.
     * 경로 : 시스템운영사 > 회원사관리 > 고객사 관리 > 고객사별 사용자현황 > 고객사별 사용자 등록/상세 (팝업)
     */
    @RequestMapping(value = "/OCUR0031/view")
    public String ocur0031_view(EverHttpRequest req) throws Exception {

        UserInfo userInfo = UserInfoManager.getUserInfo();
        Map<String, String> formData = new HashMap<String, String>();
        Map<String, String> param = new HashMap<String, String>();

        String userId = EverString.nullToEmptyString(req.getParameter("USER_ID"));

        boolean havePermission = (EverString.nullToEmptyString(userInfo.getSuperUserFlag()).equals("1") || EverString.nullToEmptyString(userInfo.getCtrlCd()).contains("B100") || EverString.nullToEmptyString(userInfo.getCtrlCd()).contains("M100") || EverString.nullToEmptyString(userInfo.getCtrlCd()).contains("W100"));

        if(!userId.equals("")) {
            param.put("USER_ID", userId);
            formData = ocur_Service.ocur0031_doSearchInfo(param);
            if(userInfo.getUserId().equals(formData.get("REG_USER_ID"))) {
                havePermission = true;
            }
        }

        req.setAttribute("havePermission", havePermission);
        req.setAttribute("detailView", Boolean.parseBoolean(EverString.nullToEmptyString(req.getParameter("detailView"))));
        req.setAttribute("formData", formData);
        return "/nhepro/OCUR/OCUR0031";
    }

    @RequestMapping(value="/ocur0031_doSearchAuth")
    public void ocur0031_doSearchAuth(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> param = req.getFormData();
        param.put("BUYER_CD", param.get("COMPANY_CD"));

        resp.setGridObject("grid", ocur_Service.ocur0031_doSearchAuth(param));
    }

    @RequestMapping(value="/ocur0031_doSave")
    public void ocur0031_doSave(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> formData = req.getFormData();
        String returnMsg = ocur_Service.ocur0031_doSave(formData);

        resp.setResponseMessage(returnMsg);
    }

    @RequestMapping(value="/ocur0031_doSaveAuth")
    public void ocur0031_doSaveAuth(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> formData = req.getFormData();
        List<Map<String, Object>> gridDatas = req.getGridData("grid");
        String returnMsg = ocur_Service.ocur0031_doSaveAuth(formData, gridDatas);

        resp.setResponseMessage(returnMsg);
    }

    @RequestMapping(value="/ocur0031_doDeleteAuth")
    public void ocur0031_doDeleteAuth(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> formData = req.getFormData();
        List<Map<String, Object>> gridDatas = req.getGridData("grid");
        String returnMsg = ocur_Service.ocur0031_doDeleteAuth(formData, gridDatas);

        resp.setResponseMessage(returnMsg);
    }

    @RequestMapping(value="/ocur0031_doCheckUserId")
    public void ocur0031_doCheckUserId(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.setParameter("POSSIBLE_FLAG", ocur_Service.ocur0031_doCheckUserId(req.getFormData()));
    }

}