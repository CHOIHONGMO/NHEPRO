package com.st_ones.nhepro.CCUR.web;

import com.st_ones.common.combo.service.CommonComboService;
import com.st_ones.common.file.service.FileAttachService;
import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.util.clazz.EverDate;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.eversrm.eApproval.eApprovalModule.service.BAPM_Service;
import com.st_ones.nhepro.CCUR.service.CCUR0010_Service;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
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
 * @File Name : CCUR0010_Controller.java
 * @date 2020. 03. 18.
 * @version 1.0
 */
@Controller
@RequestMapping(value = "/nhepro/CCUR")
public class CCUR0010_Controller extends BaseController {

    private Logger logger = LoggerFactory.getLogger(BAPM_Service.class);

    @Autowired private CommonComboService commonComboService;

    @Autowired private FileAttachService fileAttachService;

    @Autowired private MessageService msg;

    @Autowired private CCUR0010_Service ccur_Service;

    /**
     * 화면명 : 회사정보
     * 처리내용 : 로그인한 사용자의 회사정보를 조회/수정할 수 있는 화면
     * 경로 : 고객사 > 관리자 > 조직관리 > 회사정보
     */
    @RequestMapping(value = "/CCUR0010/view")
    public String ccur0010_view(EverHttpRequest req) throws Exception {

        UserInfo userInfo = UserInfoManager.getUserInfo();

        /* ======================================== 권한 설정 ======================================== */
        boolean superUserFlag  = EverString.nullToEmptyString(userInfo.getSuperUserFlag()).equals("1");
        boolean havePermission = (EverString.nullToEmptyString(userInfo.getSuperUserFlag()).equals("1")
                               || EverString.nullToEmptyString(userInfo.getCtrlCd()).contains("BR100"));
        boolean detailView = Boolean.parseBoolean(EverString.nullToEmptyString(req.getParameter("detailView")));

        Map<String, String> formData = ccur_Service.ccur0010_doSearchInfo(new HashMap<String, String>()); // 회사정보

        req.setAttribute("superUserFlag", superUserFlag);
        req.setAttribute("havePermission", havePermission);
        req.setAttribute("detailView", detailView);
        req.setAttribute("formData", formData);
        return "/nhepro/CCUR/CCUR0010";
    }

    @RequestMapping(value="/ccur0010_doSearchTs")
    public void ccur0010_doSearchTs(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> param = req.getFormData();
        param.put("BUYER_CD", EverString.nullToEmptyString(req.getParameter("CUST_CD")));
        param.put("MANAGE_CD", EverString.nullToEmptyString(req.getParameter("MANAGE_CD")));

        resp.setGridObject("gridTS", ccur_Service.ccur0010_doSearchTs(param));
    }

    @RequestMapping(value = "/ccur0010_doSave")
    public void ccur0010_doSave(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> paramMap = req.getFormData();
        Map<String, Object> formData = new HashMap<String, Object>();
        formData.putAll(paramMap);
        formData.put("changeFlag", EverString.nullToEmptyString(req.getParameter("changeFlag")));
        List<Map<String, Object>> gridDatas = req.getGridData("gridTS");

        Map<String, String> rtnMap = ccur_Service.ccur0010_doSave(formData, gridDatas);

        resp.setParameter("CUST_CD", rtnMap.get("CUST_CD"));
        resp.setResponseMessage(rtnMap.get("rtnMsg"));
    }

    /**
     * 화면명 : 조직정보
     * 처리내용 : 로그인한 사용자 회사의 조직을 조회/관리하는 화면.
     * 경로 : 고객사 > 관리자 > 조직관리 > 조직정보
     */
    @RequestMapping(value = "/CCUR0020/view")
    public String ccur0020_view(EverHttpRequest req) {
        req.setAttribute("yyyymm", EverDate.getShortDateString().substring(0, 6));
        req.setAttribute("RELAT_YN", ccur_Service.ccur0020_getRelatYN(new HashMap<String, String>()));
        return "/nhepro/CCUR/CCUR0020";
    }

    @RequestMapping(value="/ccur0020_doSearch")
    public void ccur0020_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> param = req.getFormData();
        param.put("DEPT_TYPE", "100");
        resp.setGridObject("gridT", ccur_Service.ccur0020_doSearch(param));

        /* 2020.08.04 Level 개념 사용하지 않음.
        if(!param.get("DEPT_NM").equals("")){
            param.put("DEPT_TYPE", "400");
            resp.setGridObject("gridDP", ccur_Service.ccur0020_doSearch(param));

            param.put("DEPT_TYPE", "300");
            resp.setGridObject("gridB", ccur_Service.ccur0020_doSearch(param));

            param.put("DEPT_TYPE", "200");
            param.put("STEP2", "Y");
            resp.setGridObject("gridM", ccur_Service.ccur0020_doSearch_parent(param));

            param.put("DEPT_TYPE", "100");
            param.put("STEP2", "");
            param.put("STEP1", "Y");
            resp.setGridObject("gridT", ccur_Service.ccur0020_doSearch_parent(param));
        }
        else {
            param.put("DEPT_TYPE", "100");
            resp.setGridObject("gridT", ccur_Service.ccur0020_doSearch(param));
        }
        */
    }

    @RequestMapping(value="/ccur0020_doSearchM")
    public void ccur0020_doSearchM(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> param = req.getFormData();
        param.put("PARENT_DEPT_CD", req.getParameter("PARENT_DEPT_CD"));
        param.put("DEPT_TYPE", "200");

        resp.setGridObject("gridM", ccur_Service.ccur0020_doSearch(param));
    }

    @RequestMapping(value="/ccur0020_doSearchB")
    public void ccur0020_doSearchB(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> param = req.getFormData();
        param.put("PARENT_DEPT_CD", req.getParameter("PARENT_DEPT_CD"));
        param.put("DEPT_TYPE", "300");

        resp.setGridObject("gridB", ccur_Service.ccur0020_doSearch(param));
    }

    @RequestMapping(value="/ccur0020_doSearchDP")
    public void ccur0020_doSearchDP(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> param = req.getFormData();
        param.put("PARENT_DEPT_CD", req.getParameter("PARENT_DEPT_CD"));
        param.put("DEPT_TYPE", "400");

        resp.setGridObject("gridDP", ccur_Service.ccur0020_doSearch(param));
    }

    @RequestMapping(value="/ccur0020_doSave")
    public void ccur0020_doSave(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> formData = req.getFormData();
        String radioVal = EverString.nullToEmptyString(req.getParameter("radioVal"));

        List<Map<String, Object>> gridList = null;
        if(radioVal.equals("R1")) { gridList = req.getGridData("gridT"); }
        else if(radioVal.equals("R2")) { gridList = req.getGridData("gridM"); }
        else if(radioVal.equals("R3")) { gridList = req.getGridData("gridB"); }
        else if(radioVal.equals("R4")) { gridList = req.getGridData("gridDP"); }

        String returnMsg = ccur_Service.ccur0020_doSave(formData, gridList);
        resp.setResponseMessage(returnMsg);
    }

    @RequestMapping(value="/ccur0020_doSearchAccount")
    public void ccur0020_doSearchAccount(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> param = req.getFormData();
        param.put("DEPT_CD", req.getParameter("DEPT_CD"));

        resp.setGridObject("gridA", ccur_Service.ccur0020_doSearchAccount(param));
    }

    @RequestMapping(value="/ccur0020_doSaveAcc")
    public void ccur0020_doSaveAcc(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> formData = req.getFormData();
        formData.put("activeDeptCd", EverString.nullToEmptyString(req.getParameter("activeDeptCd")));
        formData.put("DEL_FLAG", "0");
        List<Map<String, Object>> gridList = req.getGridData("gridA");

        String returnMsg = ccur_Service.ccur0020_doSaveAcc(formData, gridList);
        resp.setResponseMessage(returnMsg);
    }

    @RequestMapping(value="/ccur0020_doDelAcc")
    public void ccur0020_doDelAcc(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> formData = req.getFormData();
        formData.put("activeDeptCd", "");
        formData.put("DEL_FLAG", "1");
        List<Map<String, Object>> gridList = req.getGridData("gridA");

        String returnMsg = ccur_Service.ccur0020_doSaveAcc(formData, gridList);
        resp.setResponseMessage(returnMsg);
    }

}