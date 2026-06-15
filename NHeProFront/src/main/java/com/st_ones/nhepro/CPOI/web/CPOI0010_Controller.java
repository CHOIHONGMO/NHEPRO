package com.st_ones.nhepro.CPOI.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.st_ones.common.combo.service.CommonComboService;
import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.util.clazz.EverDate;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.nhepro.CPOI.service.CPOI0010_Service;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : CPOI0010_Controller.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

@Controller
@RequestMapping(value = "/nhepro/CPOI")
public class CPOI0010_Controller extends BaseController {

    @Autowired private CPOI0010_Service cpoi0010_service;
    @Autowired private CommonComboService commonComboService;
    @Autowired private MessageService msg;

    /**
     * 화면명 : 발주서생성
     * 처리내용 : 발주서를 작성하여 결재상신하는 화면.
     * 경로 : 고객사 > 발주관리 > 발주관리 > 수기발주생성 (수기발주)
     * 경로 : 고객사 > 발주관리 > 발주관리 > 발주대기목록 (CPOI0011) >  종가발주성성 팝업
     * 경로 : 고객사 > 발주관리 > 발주관리 > 발주현황 (CPOR0020) > 수기발주, 종가발주, 직발주, 계약발주 (뷰어, 수정)
     * 경로 : 고객사 > 발주관리 > 발주관리 > 발주진행현황 (CPOR0030) > 수기발주, 종가발주, 직발주, 계약발주 (뷰어)
     */
    @RequestMapping(value="/CPOI0010/view")
    public String CPOI0010(EverHttpRequest req) throws Exception {
        Map<String, String> param = req.getParamDataMap();
        Map<String, Object> data = new HashMap<>();

        UserInfo userInfo = UserInfoManager.getUserInfo();

        String buyerCd = req.getParameter("buyerCd");
        if( EverString.isEmpty(buyerCd) ) {
        	buyerCd    = req.getParameter("BUYER_CD");
        }
        String poNum     = req.getParameter("PO_NUM");
        String appDocNum = req.getParameter("appDocNum");
        String appDocCnt = req.getParameter("appDocCnt");
        
        if (!"".equals(param.get("PO_NUM")) && param.get("PO_NUM") != null) {
        	param.put("PO_NUM", poNum);
        	param.put("BUYER_CD", buyerCd);
            data = cpoi0010_service.cpoi0010_doSearchPOHD(param);
        }
        else if (StringUtils.isNotEmpty(appDocNum)) {
        	param.put("BUYER_CD", buyerCd);
        	param.put("APP_DOC_NUM", appDocNum);
        	param.put("APP_DOC_CNT", appDocCnt);
            data = cpoi0010_service.cpoi0010_doSearchPOHD(param);
        }
        else if(!"".equals(param.get("PR_NUM")) && param.get("PR_NUM") != null) {
            data = cpoi0010_service.cpoi0010_doSearch(param);
            data.put("PO_CREATE_TYPE", "LAST");    // LAST:종가발주, MANUAL:수기발주
        }
        else {
            data.put("PO_CREATE_TYPE", "MANUAL");   // LAST:종가발주, MANUAL:수기발주
            data.put("PO_CREATE_DATE", EverDate.getDate());
            data.put("CTRL_CD", userInfo.getCtrlCd());
            data.put("CTRL_USER_ID", userInfo.getUserId());
            data.put("CTRL_USER_NM", userInfo.getUserNm());
            data.put("BUYER_CD", userInfo.getCompanyCd());
            data.put("DEPT_CD", userInfo.getDeptCd());
            data.put("BUYER_DEPT_NM", userInfo.getCompanyNm() + " " + userInfo.getDeptNm());
        }

        if("LAST".equals(data.get("PO_CREATE_TYPE"))) {
            data.put("SCREEN_NAME", msg.getMessageByScreenId("CPOI0010", "001"));
        } else if("MANUAL".equals(data.get("PO_CREATE_TYPE"))) {
            data.put("SCREEN_NAME", msg.getMessageByScreenId("CPOI0010", "002"));
        } else if("AUTO".equals(data.get("PO_CREATE_TYPE"))) {
            data.put("SCREEN_NAME", msg.getMessageByScreenId("CPOI0010", "018"));
        } else if("DRAFT".equals(data.get("PO_CREATE_TYPE"))) {
            data.put("SCREEN_NAME", msg.getMessageByScreenId("CPOI0010", "019"));
        }

        req.setAttribute("gridSel", param.get("gridSel"));
        req.setAttribute("formData", data);

        return "/nhepro/CPOI/CPOI0010";
    }

    // 품목정보, 조회, POHB
    @RequestMapping(value = "/cpoi0010_doSearchMTGL")
    public void cpoi0010_doSearchMTGL(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> param = req.getParamDataMap();

        resp.setGridObject("gridMTGL", cpoi0010_service.cpoi0010_doSearchMTGL(req.getFormData(), param));
    }

    // 품목정보, 조회, PODT
    @RequestMapping(value = "/cpoi0010_doSearchPODT")
    public void cpoi0010_doSearchPODT(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> param = req.getParamDataMap();

        resp.setGridObject("gridMTGL", cpoi0010_service.cpoi0010_doSearchPODT(req.getFormData(), param));
    }

    // 지불정보, 조회, POPY
    @RequestMapping(value = "/cpoi0010_doSearchPOPY")
    public void cpoi0010_doSearchPOPY(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> param = req.getParamDataMap();

        resp.setGridObject("gridPOPY", cpoi0010_service.cpoi0010_doSearchPOPY(req.getFormData(), param));
    }

    // 저장
    @RequestMapping(value = "/cpoi0010_doSave")
    public void cpoi0010_doSave(EverHttpRequest req, EverHttpResponse resp) throws Exception {

    	Map<String, String> formData = req.getFormData();
    	List<Map<String, Object>> gridMTGL = req.getGridData("gridMTGL");
        List<Map<String, Object>> gridPOPY = req.getGridData("gridPOPY");
        List<Map<String, Object>> gridTEMP = req.getGridData("gridTEMP");
        String signStatus = formData.get("SIGN_STATUS");

        Map<String, String> rtnMap = cpoi0010_service.cpoi0010_doSave(req.getFormData(), gridMTGL, gridPOPY, gridTEMP, signStatus);
        
        resp.setParameter("BUYER_CD", rtnMap.get("BUYER_CD"));
        resp.setParameter("PO_NUM", rtnMap.get("PO_NUM"));
        resp.setParameter("SIGN_STATUS", signStatus);
        resp.setResponseMessage(rtnMap.get("rtnMsg"));
    }

    // 삭제
    @RequestMapping(value = "/cpoi0010_doDelete")
    public void cpoi0010_doDelete(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> rtnMap = cpoi0010_service.cpoi0010_doDelete(req.getFormData());

        resp.setResponseMessage(rtnMap.get("rtnMsg"));
    }

    /**
     * 화면명 : 발주대기목록
     * 처리내용 : 구매검토목록에서 종가발주 생성요청건들을 대상으로 조회한 후 선택하여 발주서를 생성할 수 있는 화면.
     * 경로 : 고객사 > 발주관리 > 발주관리 > 발주대기목록
     */
    @RequestMapping(value="/CPOI0011/view")
    public String CPOI0011(EverHttpRequest req) {
        UserInfo userInfo = UserInfoManager.getUserInfo();

        String ctrlCd = userInfo.getCtrlCd();

        if(ctrlCd.contains("BR030")) {
            req.setAttribute("CTRL_USER_ID", userInfo.getUserId());
            req.setAttribute("CTRL_USER_NM", userInfo.getUserNm());
            req.setAttribute("CTRL_CD", "BR030");
        } else {
            req.setAttribute("CTRL_CD", "");
        }

        req.setAttribute("FROM_REG_DATE", EverDate.addDateMonth(EverDate.getDate(), -1));
        req.setAttribute("TO_REG_DATE", EverDate.addDateMonth(EverDate.getDate(), 0));

        return "/nhepro/CPOI/CPOI0011";
    }

    // 조회
    @RequestMapping(value = "/cpoi0011_doSearch")
    public void cpoi0011_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.setGridObject("grid", cpoi0010_service.cpoi0011_doSearch(req.getFormData()));
    }

    // 종가발주취소
    @RequestMapping(value = "/cpoi0011_doClosing")
    public void cpoi0011_doClosing(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        List<Map<String, Object>> grid = req.getGridData("grid");

        Map<String, String> rtnMap = cpoi0010_service.cpoi0011_doClosing(req.getFormData(), grid);

        resp.setResponseMessage(rtnMap.get("rtnMsg"));
    }

    /**
     * 화면명 : 발주현황
     * 처리내용 : 발주 현황을 조회하여 관리를 하는 화면. (작성중인 발주서의 수정이나 발주서 종결을 할 수 있는 화면을 팝업으로 오픈한다.)
     * 경로 : 고객사 > 발주관리 > 발주관리 > 발주현황
     */
    @RequestMapping(value="/CPOR0020/view")
    public String CPOR0020(EverHttpRequest req) {
    	
        UserInfo userInfo = UserInfoManager.getUserInfo();
        boolean havePermission = false;
        
        // BR030 : 구매담당자권한, BR040 : 계약담당자
        if((userInfo.getCtrlCd()).contains("BR030") || (userInfo.getCtrlCd()).contains("BR040")) {
        	havePermission = true;
        }
        // BR900 : 관리자직무(업무담당자 변경가능 직무)
        String ManagerCd = EverString.nullToEmptyString(PropertiesManager.getString("eversrm.customer.admin.ManagerCd"));
        if((userInfo.getCtrlCd()).contains(ManagerCd)) {
        	havePermission = true;
        }
        havePermission = EverString.nullToEmptyString(userInfo.getSuperUserFlag()).equals("1") ? true : havePermission;
        
        req.setAttribute("havePermission", havePermission);
        req.setAttribute("FROM_PO_DATE", EverDate.addDateMonth(EverDate.getDate(), -1));
        req.setAttribute("TO_PO_DATE", EverDate.addDateMonth(EverDate.getDate(), 0));
        return "/nhepro/CPOI/CPOR0020";
    }

    // 조회
    @RequestMapping(value = "/cpor0020_doSearch")
    public void cpor0020_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> param = req.getFormData();

        param.put("SEL_BUYER", req.getParamDataMap().get("SEL_BUYER"));

        resp.setGridObject("grid", cpoi0010_service.cpor0020_doSearch(param));
    }

    // 발주생성 후 발주종결 POHD
    @RequestMapping(value = "/cpor0020_doClosing")
    public void cpor0020_doClosing(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        List<Map<String, Object>> grid = req.getGridData("grid");

        Map<String, String> rtnMap = cpoi0010_service.cpor0020_doClosing(req.getFormData(), grid);

        resp.setResponseMessage(rtnMap.get("rtnMsg"));
    }

    // 구매담당자 변경, POHD
    @RequestMapping(value = "/cpor0020_doUpdateChange")
    public void cpor0020_doUpdateChange(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        List<Map<String, Object>> grid = req.getGridData("grid");

        Map<String, String> rtnMap = cpoi0010_service.cpor0020_doUpdateChange(req.getFormData(), grid);

        resp.setResponseMessage(rtnMap.get("rtnMsg"));
    }
    
    // 2021.03.11 추가
    // 검수담당자 변경, POHD
    @RequestMapping(value = "/cpor0020_doUpdateChangeINV")
    public void cpor0020_doUpdateChangeINV(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	
        List<Map<String, Object>> grid = req.getGridData("grid");
        
        Map<String, String> rtnMap = cpoi0010_service.cpor0020_doUpdateChangeINV(req.getFormData(), grid);
        resp.setResponseMessage(rtnMap.get("rtnMsg"));
    }
    
    // 2021.09.16 추가
    // 검수유형 변경
    @RequestMapping(value = "/cpor0020_doUpdateDelivery")
    public void cpor0020_doUpdateDelivery(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	
        List<Map<String, Object>> grid = req.getGridData("grid");
        
        Map<String, String> rtnMap = cpoi0010_service.cpor0020_doUpdateDelivery(req.getFormData(), grid);
        resp.setResponseMessage(rtnMap.get("rtnMsg"));
    }

    /**
     * 화면명 : 발주진행현황
     * 처리내용 : 품목별 발주 진행현황을 보여주는 화면
     * 경로 : 고객사 > 발주관리 > 발주관리 > 발주진행현황
     */
    @RequestMapping(value="/CPOR0030/view")
    public String CPOR0030(EverHttpRequest req) throws Exception {
    	
        UserInfo userInfo = UserInfoManager.getUserInfo();
        boolean havePermission = false;
        
        // BR030 : 구매담당자권한, BR040 : 계약담당자
        if((userInfo.getCtrlCd()).contains("BR030") || (userInfo.getCtrlCd()).contains("BR040")) {
        	havePermission = true;
        }
        // BR900 : 관리자직무(업무담당자 변경가능 직무)
        String ManagerCd = EverString.nullToEmptyString(PropertiesManager.getString("eversrm.customer.admin.ManagerCd"));
        if((userInfo.getCtrlCd()).contains(ManagerCd)) {
        	havePermission = true;
        }
        havePermission = EverString.nullToEmptyString(userInfo.getSuperUserFlag()).equals("1") ? true : havePermission;
        
        req.setAttribute("havePermission", havePermission);
        req.setAttribute("FROM_DATE", EverDate.addDateMonth(EverDate.getDate(), -1));
        req.setAttribute("TO_DATE", EverDate.addDateMonth(EverDate.getDate(), 0));
        return "/nhepro/CPOI/CPOR0030";
    }

    // 조회
    @RequestMapping(value = "/cpor0030_doSearch")
    public void cpor0030_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> param = req.getFormData();

        param.put("SEL_DATE", req.getParamDataMap().get("SEL_DATE"));
        param.put("SEL_BUYER", req.getParamDataMap().get("SEL_BUYER"));

        resp.setGridObject("grid", cpoi0010_service.cpor0030_doSearch(param));
    }

    /**
     * 화면명 : 거래명세서현황
     * 처리내용 : 협력업체에서 제출한 거래명세서를 조회하는 화면
     * 경로 : 고객사 > 발주관리 > 발주관리 > 거래명세서현황
     */
    @RequestMapping(value="/CPOR0040/view")
    public String CPOR0040(EverHttpRequest req) throws Exception {
        req.setAttribute("FROM_DATE", EverDate.addDateMonth(EverDate.getDate(), -1));
        req.setAttribute("TO_DATE", EverDate.addDateMonth(EverDate.getDate(), 0));

        return "/nhepro/CPOI/CPOR0040";
    }

    // 조회
    @RequestMapping(value = "/cpor0040_doSearch")
    public void cpor0040_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> param = req.getFormData();

        param.put("SEL_DATE", req.getParamDataMap().get("SEL_DATE"));

        resp.setGridObject("grid", cpoi0010_service.cpor0040_doSearch(param));
    }
}
