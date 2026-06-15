package com.st_ones.nhepro.OCUR.web;

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
import com.st_ones.nhepro.OCUR.service.OCUR0010_Service;
import org.codehaus.jackson.map.ObjectMapper;
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
 * @File Name : OCUR0010_Controller.java
 * @date 2020. 03. 09.
 * @version 1.0
 */
@Controller
@RequestMapping(value = "/nhepro/OCUR")
public class OCUR0010_Controller extends BaseController {

    private Logger logger = LoggerFactory.getLogger(BAPM_Service.class);

    @Autowired private CommonComboService commonComboService;

    @Autowired private FileAttachService fileAttachService;

    @Autowired private MessageService msg;

    @Autowired private OCUR0010_Service ocur_Service;

    /**
     * 화면명 : 고객사현황
     * 처리내용 : 시스템에 등록된 고객사들을 조회하고, 신규 고객사를 등록하는 화면.
     * 경로 : 시스템운영사 > 회원사관리 > 고객사 관리 > 고객사현황
     */
    @RequestMapping(value = "/OCUR0010/view")
    public String ocur0010_view(EverHttpRequest req) throws Exception {
        return "/nhepro/OCUR/OCUR0010";
    }

    @RequestMapping(value="/ocur0010_doSearch")
    public void ocur0010_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.setGridObject("grid", ocur_Service.ocur0010_doSearch(req.getFormData()));
    }

    /**
     * 화면명 : 고객사 상세
     * 처리내용 : 시스템에 등록된 고객사 정보를 조회/수정할 수 있는 화면
     * 경로 : 시스템운영사 > 회원사관리 > 고객사 관리 > 고객사현황 > 고객사 등록/상세 (팝업)
     */
    @RequestMapping(value = "/OCUR0011/view")
    public String ocur0011_view(EverHttpRequest req) throws Exception {

        UserInfo userInfo = UserInfoManager.getUserInfo();
        Map<String, String> formData = new HashMap<String, String>(); // 고객사 정보
        Map<String, String> param = new HashMap<String, String>();

        String custCd = EverString.nullToEmptyString(req.getParameter("CUST_CD"));

        /* ====================================== 권한 설정 ====================================== */
        boolean superUserFlag  = EverString.nullToEmptyString(userInfo.getSuperUserFlag()).equals("1");
        boolean havePermission = (EverString.nullToEmptyString(userInfo.getSuperUserFlag()).equals("1")
                               || EverString.nullToEmptyString(userInfo.getCtrlCd()).contains("B100")
                               || EverString.nullToEmptyString(userInfo.getCtrlCd()).contains("M100"));
        boolean detailView = Boolean.parseBoolean(EverString.nullToEmptyString(req.getParameter("detailView")));

        if( !custCd.equals("") ) {
            param.put("CUST_CD", custCd);
            formData = ocur_Service.ocur0011_doSearchInfo(param);
        }

        req.setAttribute("superUserFlag", superUserFlag);
        req.setAttribute("havePermission", havePermission);
        req.setAttribute("detailView", detailView);
        req.setAttribute("formData", formData);
        return "/nhepro/OCUR/OCUR0011";
    }

    @RequestMapping(value="/ocur0011_doSearchTs")
    public void ocur0011_doSearchTs(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> param = req.getFormData();
        param.put("BUYER_CD", EverString.nullToEmptyString(req.getParameter("CUST_CD")));
        param.put("MANAGE_CD", EverString.nullToEmptyString(req.getParameter("MANAGE_CD")));

        resp.setGridObject("gridTS", ocur_Service.ocur0011_doSearchTs(param));
    }

    @RequestMapping(value="/ocur0011_doSearchTB")
    public void ocur0011_doSearchTB(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> param = req.getFormData();
        param.put("IRS_NUM", EverString.nullToEmptyString(req.getParameter("IRS_NUM")));

        Map<String, String> rtnMap = ocur_Service.ocur0011_doSearchTB(param);
        String rtnStr = "";
        if(rtnMap != null) {

            if(EverString.nullToEmptyString(rtnMap.get("NC_COMP_DS_C")).equals("02")) { rtnMap.put("CORP_TYPE", "1"); }
            else if(EverString.nullToEmptyString(rtnMap.get("NC_COMP_DS_C")).equals("03")) { rtnMap.put("CORP_TYPE", "2"); }
            else if(EverString.nullToEmptyString(rtnMap.get("NC_COMP_DS_C")).equals("04")) { rtnMap.put("CORP_TYPE", "3"); }
            else if(EverString.nullToEmptyString(rtnMap.get("NC_COMP_DS_C")).equals("05") || EverString.nullToEmptyString(rtnMap.get("NC_COMP_DS_C")).equals("06")) { rtnMap.put("CORP_TYPE", "5"); }
            else if(EverString.nullToEmptyString(rtnMap.get("NC_COMP_DS_C")).equals("08")) { rtnMap.put("CORP_TYPE", "A"); }
            else if(EverString.nullToEmptyString(rtnMap.get("NC_COMP_DS_C")).equals("09")) { rtnMap.put("CORP_TYPE", "B"); }
            else if(EverString.nullToEmptyString(rtnMap.get("NC_COMP_DS_C")).equals("10")) { rtnMap.put("CORP_TYPE", "C"); }
            else if(EverString.nullToEmptyString(rtnMap.get("NC_COMP_DS_C")).equals("11")) { rtnMap.put("CORP_TYPE", "D"); }
            else { rtnMap.put("CORP_TYPE", ""); }

            rtnStr = new ObjectMapper().writeValueAsString(rtnMap);
        }
        resp.setParameter("rtnStr", rtnStr);
    }

    @RequestMapping(value = "/ocur0011_doSave")
    public void ocur0011_doSave(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> paramMap = req.getFormData();
        Map<String, Object> formData = new HashMap<String, Object>();
        formData.putAll(paramMap);
        formData.put("changeFlag", EverString.nullToEmptyString(req.getParameter("changeFlag")));
        List<Map<String, Object>> gridDatas = req.getGridData("gridTS");

        Map<String, String> rtnMap = ocur_Service.ocur0011_doSave(formData, gridDatas);

        resp.setParameter("CUST_CD", rtnMap.get("CUST_CD"));
        resp.setResponseMessage(rtnMap.get("rtnMsg"));
    }

    @RequestMapping(value = "/ocur0011_checkIrsNum")
    public void ocur0011_checkIrsNum(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.setParameter("POSSIBLE_FLAG", ocur_Service.ocur0011_checkIrsNum(req.getFormData()));
    }

    /**
     * 화면명 : 고객사별 부서현황
     * 처리내용 : 고객사별로 부서를 조회/관리하는 화면.
     * 경로 : 시스템운영사 > 회원사관리 > 고객사 관리 > 고객사별 부서현황
     */
    @RequestMapping(value = "/OCUR0020/view")
    public String ocur0020_view(EverHttpRequest req) {
        req.setAttribute("yyyymm", EverDate.getShortDateString().substring(0, 6));
        return "/nhepro/OCUR/OCUR0020";
    }

    @RequestMapping(value="/ocur0020_doSearch")
    public void ocur0020_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> param = req.getFormData();

        param.put("DEPT_TYPE", "100");
        resp.setGridObject("gridT", ocur_Service.ocur0020_doSearch(param));

        /* 2020-08-04 Level 개념을 사용하지 않아서 주석처리...
        if(!param.get("DEPT_NM").equals("")){
            param.put("DEPT_TYPE", "400");
            resp.setGridObject("gridDP", ocur_Service.ocur0020_doSearch(param));

            param.put("DEPT_TYPE", "300");
            resp.setGridObject("gridB", ocur_Service.ocur0020_doSearch(param));

            param.put("DEPT_TYPE", "200");
            param.put("STEP2", "Y");
            resp.setGridObject("gridM", ocur_Service.ocur0020_doSearch_parent(param));

            param.put("DEPT_TYPE", "100");
            param.put("STEP2", "");
            param.put("STEP1", "Y");
            resp.setGridObject("gridT", ocur_Service.ocur0020_doSearch_parent(param));
        }
        else {
            param.put("DEPT_TYPE", "100");
            resp.setGridObject("gridT", ocur_Service.ocur0020_doSearch(param));
        }
        */
    }

    @RequestMapping(value="/ocur0020_doSearchM")
    public void ocur0020_doSearchM(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> param = req.getFormData();
        param.put("PARENT_DEPT_CD", req.getParameter("PARENT_DEPT_CD"));
        param.put("DEPT_TYPE", "200");

        resp.setGridObject("gridM", ocur_Service.ocur0020_doSearch(param));
    }

    @RequestMapping(value="/ocur0020_doSearchB")
    public void ocur0020_doSearchB(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> param = req.getFormData();
        param.put("PARENT_DEPT_CD", req.getParameter("PARENT_DEPT_CD"));
        param.put("DEPT_TYPE", "300");

        resp.setGridObject("gridB", ocur_Service.ocur0020_doSearch(param));
    }

    @RequestMapping(value="/ocur0020_doSearchDP")
    public void ocur0020_doSearchDP(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> param = req.getFormData();
        param.put("PARENT_DEPT_CD", req.getParameter("PARENT_DEPT_CD"));
        param.put("DEPT_TYPE", "400");

        resp.setGridObject("gridDP", ocur_Service.ocur0020_doSearch(param));
    }

    @RequestMapping(value="/ocur0020_doSave")
    public void ocur0020_doSave(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> formData = req.getFormData();
        String radioVal = "R1"; // 2020.08.04 Level의 개념을 사용하지 않음. EverString.nullToEmptyString(req.getParameter("radioVal"));

        List<Map<String, Object>> gridList = null;
        if(radioVal.equals("R1")) { gridList = req.getGridData("gridT"); }
        else if(radioVal.equals("R2")) { gridList = req.getGridData("gridM"); }
        else if(radioVal.equals("R3")) { gridList = req.getGridData("gridB"); }
        else if(radioVal.equals("R4")) { gridList = req.getGridData("gridDP"); }

        String returnMsg = ocur_Service.ocur0020_doSave(formData, gridList);
        resp.setResponseMessage(returnMsg);
    }

    @RequestMapping(value="/ocur0020_doSearchAccount")
    public void ocur0020_doSearchAccount(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> param = req.getFormData();
        param.put("DEPT_CD", req.getParameter("DEPT_CD"));

        resp.setGridObject("gridA", ocur_Service.ocur0020_doSearchAccount(param));
    }

    @RequestMapping(value="/ocur0020_doSaveAcc")
    public void ocur0020_doSaveAcc(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> formData = req.getFormData();
        formData.put("activeDeptCd", EverString.nullToEmptyString(req.getParameter("activeDeptCd")));
        formData.put("DEL_FLAG", "0");
        List<Map<String, Object>> gridList = req.getGridData("gridA");

        String returnMsg = ocur_Service.ocur0020_doSaveAcc(formData, gridList);
        resp.setResponseMessage(returnMsg);
    }

    @RequestMapping(value="/ocur0020_doDelAcc")
    public void ocur0020_doDelAcc(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> formData = req.getFormData();
        formData.put("activeDeptCd", "");
        formData.put("DEL_FLAG", "1");
        List<Map<String, Object>> gridList = req.getGridData("gridA");

        String returnMsg = ocur_Service.ocur0020_doSaveAcc(formData, gridList);
        resp.setResponseMessage(returnMsg);
    }

    @RequestMapping(value="/ocur0020_getRelatYN")
    public void ocur0020_getRelatYN(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> param = req.getFormData();
        param.put("CUST_CD", req.getParameter("CUST_CD"));

        resp.setParameter("RELAT_YN", ocur_Service.ocur0020_getRelatYN(param));
    }

}