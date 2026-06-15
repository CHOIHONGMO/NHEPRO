package com.st_ones.nhepro.CPOR.web;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.common.util.clazz.EverDate;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.nhepro.CPOR.service.CPOR0050_Service;
import com.st_ones.nhepro.CPOR.service.CPOR0070_Service;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : CPOR0070_Controller.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

@Controller
@RequestMapping(value = "/nhepro/CPOR")
public class CPOR0070_Controller extends BaseController {
	
	@Autowired private CPOR0050_Service cpor0050_service;
    @Autowired private CPOR0070_Service cpor0070_service;

    /**
     * 화면명 : 입고대기현황
     * 처리내용 : 거래명세서를 기준으로 입고대기현황을 조회하고 입고처리 하는 화면
     * 경로 : 고객사 > 발주관리 > 검수/입고 > 입고대기현황
     */
    @RequestMapping(value="/CPOR0070/view")
    public String CPOR0070(EverHttpRequest req) throws Exception {
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
        req.setAttribute("TO_DATE", EverDate.getDate());
        
        return "/nhepro/CPOR/CPOR0070";
    }

    // 조회
    @RequestMapping(value = "/cpor0070_doSearch")
    public void cpor0070_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> param = req.getFormData();

        param.put("SEL_DATE", req.getParamDataMap().get("SEL_DATE"));
        param.put("SEL_BUYER", req.getParamDataMap().get("SEL_BUYER"));

        resp.setGridObject("grid", cpor0070_service.cpor0070_doSearch(param));
    }

    // 검수담당자 변경
    @RequestMapping(value = "/cpor0070_doUpdateChange")
    public void cpor0070_doUpdateChange(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        List<Map<String, Object>> grid = req.getGridData("grid");

        Map<String, String> rtnMap = cpor0070_service.cpor0070_doUpdateChange(req.getFormData(), grid);

        resp.setResponseMessage(rtnMap.get("rtnMsg"));
    }

    // 승인
    @RequestMapping(value = "/cpor0070_doUpdateConfirm")
    public void cpor0070_doUpdateConfirm(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        List<Map<String, Object>> grid = req.getGridData("grid");

        Map<String, String> rtnMap = cpor0070_service.cpor0070_doUpdateConfirm(req.getFormData(), grid);

        resp.setResponseMessage(rtnMap.get("rtnMsg"));
    }

    // 반려
    @RequestMapping(value = "/cpor0070_doUpdateReject")
    public void cpor0070_doUpdateReject(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        List<Map<String, Object>> grid = req.getGridData("grid");

        Map<String, String> rtnMap = cpor0070_service.cpor0070_doUpdateReject(req.getFormData(), grid);

        resp.setResponseMessage(rtnMap.get("rtnMsg"));
    }


    /**
     * 화면명 : 거래명세서
     * 처리내용 : 거래명세서의 상세정보를 조회하고 지급정보를 입력하여 결재 상신하는 화면
     * 경로 : 고객사 > 발주관리 > 검수/입고 > 입고대기현황 > 거래명세서 (팝업)
     */
    @RequestMapping(value="/CPOR0071/view")
    public String CPOR0071(EverHttpRequest req) throws Exception {
        Map<String, String> param = req.getParamDataMap();

        Map<String, Object> data = cpor0070_service.cpor0071_doSearchIVHD(param);

        req.setAttribute("gridSel", param.get("gridSel"));
        req.setAttribute("formData", data);

        return "/nhepro/CPOR/CPOR0071";
    }

    // 품목정보, 조회
    @RequestMapping(value = "/cpor0071_doSearchIVDT")
    public void cpor0071_doSearchIVDT(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> param = req.getParamDataMap();

        resp.setGridObject("gridPODT", cpor0070_service.cpor0071_doSearchIVDT(req.getFormData(), param));
    }

    // 검수요청상세, 조회
    @RequestMapping(value = "/cpor0071_doSearchIVGH")
    public void cpor0071_doSearchIVGH(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> param = req.getParamDataMap();

        resp.setGridObject("gridIVGH", cpor0070_service.cpor0071_doSearchIVGH(req.getFormData(), param));
        resp.setDataObject("CNT_SUM_AMT", cpor0070_service.cpor0071_getPayCntSumAmt(req.getFormData(), param));
    }

    // 지불고객사, 조회
    @RequestMapping(value = "/cpor0071_doSearchPOPC")
    public void cpor0071_doSearchPOPC(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> param = req.getParamDataMap();

        resp.setGridObject("gridPOPC", cpor0070_service.cpor0071_doSearchPOPC(req.getFormData(), param));
    }
    
    /**
     * 2021.01.20 검수요청서 반송 추가 (필요한 경우)
     * @param req
     * @param resp
     * @throws Exception
     */
    @RequestMapping(value = "/cpor0071_doReject")
    public void cpor0071_doReject(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	
        Map<String, String> param = req.getFormData();
        
        Map<String, String> rtnMap = cpor0050_service.cpor0051_doReject(param);
        resp.setResponseMessage(rtnMap.get("rtnMsg"));
    }
    
    // 결재상신
    @RequestMapping(value = "/cpor0071_doUpdateApproval")
    public void cpor0071_doUpdateApproval(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        List<Map<String, Object>> gridPODT = req.getGridData("gridPODT");
        List<Map<String, Object>> gridPOPC = req.getGridData("gridPOPC");

        Map<String, String> rtnMap = cpor0070_service.cpor0071_doUpdateApproval(req.getFormData(), gridPODT, gridPOPC);

        resp.setResponseMessage(rtnMap.get("rtnMsg"));
    }
    
    /**
     * 2021.11.23 검수요청서 고객사 파일만 변경
     * @param req
     * @param resp
     * @throws Exception
     */
    @RequestMapping(value = "/cpor0071_doUpdateFileInfo")
    public void cpor0071_doUpdateFileInfo(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	
        Map<String, String> param = req.getFormData();
        Map<String, String> rtnMap = cpor0050_service.cpor0051_doUpdateFileInfo(param);
        
        resp.setParameter("BUYER_CD", param.get("BUYER_CD"));
        resp.setParameter("INV_NUM", param.get("INV_NUM"));
        resp.setResponseMessage(rtnMap.get("rtnMsg"));
    }

    /**
     * 화면명 : 입고현황
     * 처리내용 : 확정된 입고현황 정보를 조회하는 화면
     * 경로 : 고객사 > 발주관리 > 검수/입고 > 입고현황
     */
    @RequestMapping(value="/CPOR0080/view")
    public String CPOR0080(EverHttpRequest req) throws Exception {
    	
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
        req.setAttribute("TO_DATE", EverDate.getDate());

        return "/nhepro/CPOR/CPOR0080";
    }

    // 조회
    @RequestMapping(value = "/cpor0080_doSearch")
    public void cpor0080_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> param = req.getFormData();

        param.put("SEL_BUYER", req.getParamDataMap().get("SEL_BUYER"));

        resp.setGridObject("grid", cpor0070_service.cpor0080_doSearch(param));
    }

}
