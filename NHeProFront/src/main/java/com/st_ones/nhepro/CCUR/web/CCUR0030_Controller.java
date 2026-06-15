package com.st_ones.nhepro.CCUR.web;

import com.st_ones.common.combo.service.CommonComboService;
import com.st_ones.common.file.service.FileAttachService;
import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.common.util.clazz.EverDate;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.nhepro.CCUR.service.CCUR0030_Service;
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
 * @File Name : CCUR0030_Controller.java
 * @date 2020. 03. 18.
 * @version 1.0
 */
@Controller
@RequestMapping(value = "/nhepro/CCUR")
public class CCUR0030_Controller extends BaseController {

    @Autowired private CommonComboService commonComboService;

    @Autowired private FileAttachService fileAttachService;

    @Autowired private CCUR0030_Service ccur_Service;

    /**
     * 화면명 : 사용자현황
     * 처리내용 : 로그인한 사용자 회상의 사용자들을 조회/관리하는 화면.
     * 경로 : 고객사 > 관리자 > 사용자관리 > 사용자현황
     */
    @RequestMapping(value = "/CCUR0030/view")
    public String ccur0030_view(EverHttpRequest req) throws Exception {
        req.setAttribute("fromDate", EverDate.addDateMonth(EverDate.getDate(), -12));
        req.setAttribute("toDate", EverDate.getDate());
        return "/nhepro/CCUR/CCUR0030";
    }

    @RequestMapping(value="/ccur0030_doSearch")
    public void ccur0030_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.setGridObject("grid", ccur_Service.ccur0030_doSearch(req.getFormData()));
    }

    @RequestMapping(value="/ccur0030_doUpdate")
    public void ccur0030_doUpdate(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        List<Map<String, Object>> gridDatas = req.getGridData("grid");
        String returnMsg = ccur_Service.ccur0030_doUpdate(gridDatas);

        resp.setResponseMessage(returnMsg);
    }

    @RequestMapping(value="/ccur0030_doDelete")
    public void ccur0030_doDelete(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        List<Map<String, Object>> gridDatas = req.getGridData("grid");
        String returnMsg = ccur_Service.ccur0030_doDelete(gridDatas);

        resp.setResponseMessage(returnMsg);
    }

    @RequestMapping(value = "/ccur0030_doInitPassword")
    public void ccur0030_doInitPassword(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        List<Map<String, Object>> gridDatas = req.getGridData("grid");
        String rtnMsg = ccur_Service.ccur0030_doInitPassword(gridDatas);

        resp.setResponseMessage(rtnMsg);
    }

    /**
     * 화면명 : 사용자 등록/상세 (팝업)
     * 처리내용 : 로그인한 사용자 회사의 사용자들의 상세정보를 조회, 신규 사용자를 등록하는 화면.
     * 경로 : 고객사 > 관리자 > 사용자관리 > 사용자현황 > 사용자 등록/상세 (팝업)
     */
    @RequestMapping(value = "/CCUR0031/view")
    public String ccur0031_view(EverHttpRequest req) throws Exception {

        UserInfo userInfo = UserInfoManager.getUserInfo();
        Map<String, String> formData = new HashMap<String, String>();
        Map<String, String> param = new HashMap<String, String>();

        String userId = EverString.nullToEmptyString(req.getParameter("USER_ID"));

        boolean havePermission = (EverString.nullToEmptyString(userInfo.getSuperUserFlag()).equals("1") || EverString.nullToEmptyString(userInfo.getCtrlCd()).contains("B100") || EverString.nullToEmptyString(userInfo.getCtrlCd()).contains("M100") || EverString.nullToEmptyString(userInfo.getCtrlCd()).contains("W100"));

        if(!userId.equals("")) {
            param.put("USER_ID", userId);
            formData = ccur_Service.ccur0031_doSearchInfo(param);
            if(formData != null && userInfo.getUserId().equals(EverString.nullToEmptyString(formData.get("REG_USER_ID")))) {
                havePermission = true;
            }
        }
        else {
            formData.put("COMPANY_CD", userInfo.getCompanyCd());
        }

        req.setAttribute("havePermission", havePermission);
        req.setAttribute("detailView", Boolean.parseBoolean(EverString.nullToEmptyString(req.getParameter("detailView"))));
        req.setAttribute("formData", formData);
        return "/nhepro/CCUR/CCUR0031";
    }

    @RequestMapping(value="/ccur0031_doSearchAuth")
    public void ccur0031_doSearchAuth(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> param = req.getFormData();
        param.put("BUYER_CD", param.get("COMPANY_CD"));

        resp.setGridObject("grid", ccur_Service.ccur0031_doSearchAuth(param));
    }

    @RequestMapping(value="/ccur0031_doSave")
    public void ccur0031_doSave(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> formData = req.getFormData();
        String returnMsg = ccur_Service.ccur0031_doSave(formData);

        resp.setResponseMessage(returnMsg);
    }

    @RequestMapping(value="/ccur0031_doSaveAuth")
    public void ccur0031_doSaveAuth(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> formData = req.getFormData();
        List<Map<String, Object>> gridDatas = req.getGridData("grid");
        String returnMsg = ccur_Service.ccur0031_doSaveAuth(formData, gridDatas);

        resp.setResponseMessage(returnMsg);
    }

    @RequestMapping(value="/ccur0031_doCheckUserId")
    public void ccur0031_doCheckUserId(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.setParameter("POSSIBLE_FLAG", ccur_Service.ccur0031_doCheckUserId(req.getFormData()));
    }

}