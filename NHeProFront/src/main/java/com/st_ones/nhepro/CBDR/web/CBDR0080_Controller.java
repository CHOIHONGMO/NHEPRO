package com.st_ones.nhepro.CBDR.web;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.st_ones.common.combo.service.CommonComboService;
import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.common.util.clazz.EverConverter;
import com.st_ones.common.util.clazz.EverDate;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.common.util.service.EverDateService;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.nhepro.CBDI.service.CBDI0010_Service;
import com.st_ones.nhepro.CBDR.service.CBDR0080_Service;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2014 ST-Ones CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : CBDR0080_Controller.java
 * @date 2020. 5. 27.
 * @version 1.0
 */

@Controller
@RequestMapping(value = "/nhepro/CBDR")
public class CBDR0080_Controller extends BaseController {

    @Autowired private EverDateService everDate;

    @Autowired private CommonComboService commonComboService;

    @Autowired private CBDR0080_Service cbdr_Service;

    @Autowired private CBDI0010_Service cbdi_Service;

    /**
     * 화면명 : 기술평가진행현황
     * 처리내용 : 평가자로 지정된 사용자가 배정된 평가건을 조회, 평가할 수 있는 화면.
     * 경로 : 고객사 > 구매관리 > 입찰관리 > 기술평가진행 > 기술평가진행현황
     */
    @RequestMapping(value="/CBDR0080/view")
    public String cbdr0080_view(EverHttpRequest req) throws Exception {
        req.setAttribute("reqFromDate", EverDate.addDateMonth(EverDate.getDate(), -1));
        req.setAttribute("reqToDate", EverDate.addDateMonth(EverDate.getDate(), 1));
        req.setAttribute("bidStatusOptions", commonComboService.getCodesAsJson("CB0071", new HashMap<String, String>()));
        return "/nhepro/CBDR/CBDR0080";
    }

    @RequestMapping(value = "/cbdr0080_doSearch")
    public void cbdr0080_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.setGridObject("grid", cbdr_Service.cbdr0080_doSearch(req.getFormData()));
    }

    /**
     * 화면명 : 기술평가등록
     * 처리내용 : 협력업체별 평가를 수행하는 화면.
     * 경로 : 고객사 > 구매관리 > 입찰관리 > 기술평가진행 > 기술평가진행현황 > 기술평가등록
     */
    @RequestMapping(value="/CBDR0081/view")
    public String cbdr0081_view(EverHttpRequest req) throws Exception {

        UserInfo userInfo = UserInfoManager.getUserInfo();
        boolean havePermission = false;
        boolean hideEvExceptFlag = false;

        Map<String, String> formData = new HashMap<String, String>();
        Map<String, String> param = new HashMap<String, String>();

        if(!EverString.nullToEmptyString(req.getParameter("BID_NUM")).equals("") && !EverString.nullToEmptyString(req.getParameter("BID_CNT")).equals(""))
        {
            param.put("BUYER_CD", EverString.nullToEmptyString(req.getParameter("BUYER_CD")));
            param.put("BID_NUM", EverString.nullToEmptyString(req.getParameter("BID_NUM")));
            param.put("BID_CNT", EverString.nullToEmptyString(req.getParameter("BID_CNT")));
            formData = cbdi_Service.cbdr0015_doSearchHD(param);

            if(userInfo.getUserId().equals(formData.get("BID_USER_ID"))) {
                havePermission = true;
            }

            if (("TD".equals(formData.get("CONT_TYPE2")) && "2353".equals(formData.get("BID_STATUS"))) ||
            	("TS".equals(formData.get("CONT_TYPE2")) && "2363".equals(formData.get("BID_STATUS"))) ||
            	("NE".equals(formData.get("CONT_TYPE2")) && "2367".equals(formData.get("BID_STATUS")))) {
            	hideEvExceptFlag = true;
            }

        }

        havePermission = EverString.nullToEmptyString(userInfo.getSuperUserFlag()).equals("1") ? true : havePermission;
        req.setAttribute("havePermission", havePermission);
        req.setAttribute("hideEvExceptFlag", hideEvExceptFlag);
        req.setAttribute("euUserIdOptions", commonComboService.getCodesAsJson("CB0072", param));
        return "/nhepro/CBDR/CBDR0081";
    }

    @RequestMapping(value = "/cbdr0081_doSearch")
    public void cbdr0081_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.setGridObject("grid", cbdr_Service.cbdr0081_doSearch(req.getFormData()));
    }

    @RequestMapping(value = "/cbdr0081_doSearchEVEI")
    public void cbdr0081_doSearchEVEI(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> rtnMap = cbdr_Service.getEiHtml(req.getFormData());

        resp.setParameter("eiHtml", rtnMap.get("eiHtml"));
        resp.setParameter("eiSqList", rtnMap.get("eiSqList"));
    }

    @RequestMapping(value = "/cbdr0081_doSaveR")
    public void cbdr0081_doSaveR(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> formData = req.getFormData();
        String jsonStr = EverString.nullToEmptyString(req.getParameter("jsonStr"));
        List<Map<String, Object>> eiLists = new ObjectMapper().readValue(jsonStr, List.class);

        String rtnMsg = cbdr_Service.cbdr0081_doSaveR(formData, eiLists);
        resp.setResponseMessage(rtnMsg);
    }

    @RequestMapping(value = "/cbdr0081_doFinishEval")
    public void cbdr0081_doFinishEval(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> formData = req.getFormData();
        List<Map<String, Object>> gridDatas = req.getGridData("grid");

        String rtnMsg = cbdr_Service.cbdr0081_doFinishEval(formData, gridDatas);
        resp.setResponseMessage(rtnMsg);
    }

    @RequestMapping(value = "/cbdr0081_doCompleteEvel")
    public void cbdr0081_doCompleteEvel(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> formData = req.getFormData();
        List<Map<String, Object>> gridDatas = req.getGridData("grid");

        String rtnMsg = cbdr_Service.cbdr0081_doCompleteEvel(formData, gridDatas);
        resp.setResponseMessage(rtnMsg);
    }

    /**
     * 화면명 : 기술평가결과현황
     * 처리내용 : 평가자로 지정된 사용자가 배정된 평가건을 조회, 평가할 수 있는 화면.
     * 경로 : 고객사 > 구매관리 > 입찰관리 > 기술평가결과 > 기술평가결과현황
     */
    @RequestMapping(value="/CBDR0090/view")
    public String cbdr0090_view(EverHttpRequest req) throws Exception {
        req.setAttribute("reqFromDate", EverDate.addDateMonth(EverDate.getDate(), -1));
        req.setAttribute("reqToDate", EverDate.getDate());
        return "/nhepro/CBDR/CBDR0090";
    }

    @RequestMapping(value = "/cbdr0090_doSearch")
    public void cbdr0090_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {

    	List<Map<String, Object>> searchList = cbdr_Service.cbdr0090_doSearch(req.getFormData());

        for (int i = 0; i < searchList.size(); i++) {
        	Map<String, Object> grid = searchList.get(i);
        	String contType2 = String.valueOf(grid.get("CONT_TYPE2"));
        	if (contType2.equals("NE")) {
            	resp.setGridCellStyle("grid", String.valueOf(i), "BID_STATUS_LOC", "color", "#0000FF");
        	} else {
            	resp.setGridCellStyle("grid", String.valueOf(i), "BID_STATUS_LOC", "color", "#000000");
        	}
        }

        resp.setGridObject("grid", searchList);
    }
    
    @RequestMapping(value = "/cbdr0090_doUserChange")
    public void cbdr0090_doUserChange(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        List<Map<String, Object>> gridDatas = req.getGridData("grid");
        Map<String, String> formData = req.getFormData();
        formData.put("CHANGE_USER_ID", EverString.nullToEmptyString(req.getParameter("CHANGE_USER_ID")));

        String rtnMsg = cbdr_Service.cbdr0090_doUserChange(formData, gridDatas);
        resp.setResponseMessage(rtnMsg);
    }

}