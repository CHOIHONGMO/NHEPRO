package com.st_ones.nhepro.CBDR.web;

import com.st_ones.common.combo.service.CommonComboService;
import com.st_ones.common.file.service.FileAttachService;
import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.common.util.clazz.EverDate;
import com.st_ones.common.util.clazz.EverMath;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.common.util.service.EverDateService;
import com.st_ones.common.util.service.LargeTextService;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.nhepro.CBDR.service.CBDR0060_Service;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.*;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2014 ST-Ones CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : CBDR0060_Controller.java
 * @date 2020. 6. 23.
 * @version 1.0
 */
@Controller
@RequestMapping(value = "/nhepro/CBDR")
public class CBDR0060_Controller extends BaseController {

    @Autowired private EverDateService everDate;

    @Autowired private CommonComboService commonComboService;

    @Autowired private CBDR0060_Service cbdr_Service;

    @Autowired private FileAttachService fileAttachService;

    @Autowired private LargeTextService largeTextService;

    /**
     * 화면명 : 선정품의대기목록
     * 처리내용 : 낙찰된 협력업체에 대한 선정품의를 작성하는 화면.
     * 경로 : 고객사 > 구매관리 > 품의관리 > 선정품의대기목록
     */
    @RequestMapping(value="/CBDR0060/view")
    public String cbdr0060_view(EverHttpRequest req) throws Exception {
        req.setAttribute("fromDate", EverDate.addDateMonth(EverDate.getDate(), -1));
        req.setAttribute("toDate", EverDate.getDate());
        return "/nhepro/CBDR/CBDR0060";
    }

    @RequestMapping(value = "/cbdr0060_doSearch")
    public void cbdr0060_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.setGridObject("grid", cbdr_Service.cbdr0060_doSearch(req.getFormData()));
    }
    
    // 선정취소
    @RequestMapping(value = "/cbdr0060_doCancelSettle")
    public void cbdr0060_doCancelSettle(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        List<Map<String, Object>> gridDatas = req.getGridData("grid");

        String rtnMsg = cbdr_Service.cbdr0060_doCancelSettle(gridDatas);
        resp.setResponseMessage(rtnMsg);
    }

    @RequestMapping(value = "/cbdr0060_doPrcConfirm")
    public void cbdr0060_doPrcConfirm(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        List<Map<String, Object>> gridDatas = req.getGridData("grid");

        String rtnMsg = cbdr_Service.cbdr0060_doPrcConfirm(gridDatas);
        resp.setResponseMessage(rtnMsg);
    }

    @RequestMapping(value = "/cbdr0060_doPrcReject")
    public void cbdr0060_doPrcReject(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        List<Map<String, Object>> gridDatas = req.getGridData("grid");

        String rtnMsg = cbdr_Service.cbdr0060_doPrcReject(gridDatas);
        resp.setResponseMessage(rtnMsg);
    }

    /**
     * 화면명 : 선정품의작성
     * 처리내용 : 협력업체 선정 품의서를 작성하는 화면.
     * 경로 : 고객사 > 구매관리 > 품의관리 > 선정품의대기목 > 선정품의작성
     */
    @RequestMapping(value="/CBDI0061/view")
    public String cbdi0061_view(EverHttpRequest req) throws Exception {

        UserInfo userInfo = UserInfoManager.getUserInfo();
        boolean havePermission = false;

        Map<String, String> formData = new HashMap<String, String>();
        Map<String, String> param = new HashMap<String, String>();

        String execNum = EverString.nullToEmptyString(req.getParameter("execNum"));
        String buyerCd = EverString.nullToEmptyString(req.getParameter("buyerCd"));
        String appDocNum = EverString.nullToEmptyString(req.getParameter("appDocNum"));
        String appDocCnt = EverString.nullToEmptyString(req.getParameter("appDocCnt"));

        if(!execNum.equals("") || (!buyerCd.equals("") && !appDocNum.equals("") && !appDocCnt.equals("")))
        {
            param.put("BUYER_CD", buyerCd);
            param.put("EXEC_NUM", execNum);
            param.put("APP_DOC_NUM", appDocNum);
            param.put("APP_DOC_CNT", appDocCnt);

            // 업체선정 품의서 일반정보를 조회한다.
            formData = cbdr_Service.cbdi0061_doSearchHD(param);

            if(userInfo.getUserId().equals(formData.get("CTRL_USER_ID"))) {
                havePermission = true;
            }
        }
        else {
            havePermission = true;
            formData.put("BUYER_CD", userInfo.getCompanyCd());
            formData.put("DEPT_CD", userInfo.getDeptCd());
            formData.put("EXEC_DATE", EverDate.getDate());
            formData.put("CTRL_USER_ID", userInfo.getUserId());
            formData.put("CTRL_USER_NM", userInfo.getUserNm());
            formData.put("CUR", EverString.nullToEmptyString(req.getParameter("paramCur")));
            formData.put("VAT_TYPE", EverString.nullToEmptyString(req.getParameter("paramVatType")));
            formData.put("EXEC_SUBJECT", EverString.nullToEmptyString(req.getParameter("paramSubject")));
            formData.put("EXEC_DOIB_FLAG", "1");
        }

        havePermission = EverString.nullToEmptyString(userInfo.getSuperUserFlag()).equals("1") ? true : havePermission;

        req.setAttribute("formData", formData);
        req.setAttribute("havePermission", havePermission);
        return "/nhepro/CBDI/CBDI0061";
    }

    @RequestMapping(value = "/cbdi0061_doSearchVD")
    public void cbdi0061_doSearchVD(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> param = req.getFormData();
        param.put("paramExecWtNum", EverString.nullToEmptyString(req.getParameter("paramExecWtNum")));

        resp.setGridObject("gridV", cbdr_Service.cbdi0061_doSearchVD(param));
    }

    @RequestMapping(value = "/cbdi0061_doSearchDT")
    public void cbdi0061_doSearchDT(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> param = req.getFormData();
        param.put("paramExecWtNum", EverString.nullToEmptyString(req.getParameter("paramExecWtNum")));
        
        // 2021.03.30 추가
        String buyerCd = EverString.nullToEmptyString(param.get("SCH_BUYER_CD"));
        if( buyerCd != null && !"".equals(buyerCd) ) {
        	param.put("BUYER_CD", buyerCd);
        }
        String execNum = EverString.nullToEmptyString(param.get("SCH_EXEC_NUM"));
        if( execNum != null && !"".equals(execNum) ) {
        	param.put("EXEC_NUM", execNum);
        }
        
        resp.setGridObject("gridI", cbdr_Service.cbdi0061_doSearchDT(param));
    }

    @RequestMapping(value = "/cbdi0061_doSave")
    public void cbdi0061_doSave(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> formData = req.getFormData();

        List<Map<String, Object>> gridDatasV = req.getGridData("gridV");
        List<Map<String, Object>> gridDatasI = req.getGridData("gridI");

        Map<String, String> rtnMap = cbdr_Service.cbdi0061_doSave(formData, gridDatasV, gridDatasI);
        resp.setParameter("buyerCd", rtnMap.get("buyerCd"));
        resp.setParameter("execNum", rtnMap.get("execNum"));
        resp.setResponseMessage(rtnMap.get("rtnMsg"));
    }

    @RequestMapping(value = "/cbdi0061_doDelete")
    public void cbdi0061_doDelete(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> formData = req.getFormData();
        List<Map<String, Object>> gridI = req.getGridData("gridI");

        String rtnMsg = cbdr_Service.cbdi0061_doDelete(formData, gridI);
        resp.setResponseMessage(rtnMsg);
    }

    /**
     * 화면명 : 선정품의현황
     * 처리내용 : 작성된 품의 목록을 조회하는 화면.
     * 경로 : 고객사 > 구매관리 > 품의관리 > 선정품의현황
     */
    @RequestMapping(value="/CBDR0070/view")
    public String cbdr0070_view(EverHttpRequest req) throws Exception {
        req.setAttribute("fromDate", EverDate.addDateMonth(EverDate.getDate(), -1));
        req.setAttribute("toDate", EverDate.getDate());
        return "/nhepro/CBDR/CBDR0070";
    }

    @RequestMapping(value = "/cbdr0070_doSearch")
    public void cbdr0070_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.setGridObject("grid", cbdr_Service.cbdr0070_doSearch(req.getFormData()));
    }

}