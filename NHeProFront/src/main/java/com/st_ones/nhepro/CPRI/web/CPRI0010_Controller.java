package com.st_ones.nhepro.CPRI.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.codehaus.jackson.map.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.st_ones.common.combo.service.CommonComboService;
import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.common.util.clazz.EverConverter;
import com.st_ones.common.util.clazz.EverDate;
import com.st_ones.common.util.service.LargeTextService;
import com.st_ones.everf.serverside.info.BaseInfo;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.nhepro.CPRI.service.CPRI0010_Service;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : CPRI0010_Controller.java
 * @date 2020. 03. 20.
 * @version 1.0
 */
@Controller
@RequestMapping(value = "/nhepro/CPRI")
public class CPRI0010_Controller extends BaseController {

    @Autowired private LargeTextService largeTextService;
	@Autowired private CommonComboService commonComboService;
    @Autowired private CPRI0010_Service cpri_Service;

    /**
     * 화면명 : 구매의뢰등록
     * 처리내용 : 구매의뢰서를 작성하는 화면.
     * 경로 : 고객사 > 구매관리 > 구매의뢰 > 구매의뢰등록
     */
    @RequestMapping(value = "/CPRI0010/view")
    public String cpri0010_view(EverHttpRequest req) throws Exception {

        Map<String, String> formData;
        UserInfo userInfo = UserInfoManager.getUserInfo();

        String buyerCd = req.getParameter("buyerCd");
        String prNum = req.getParameter("prNum");
        String appDocNum = req.getParameter("appDocNum");
        
        if( StringUtils.isNotEmpty(prNum) || StringUtils.isNotEmpty(appDocNum) ) {
            Map<String, String> map = new HashMap<>();
            map.put("BUYER_CD", buyerCd);
            map.put("PR_NUM", prNum);
            map.put("APP_DOC_NUM", appDocNum);

            formData = cpri_Service.getPrFormData(map);
            if(formData != null) {
            	formData.put("RMK", largeTextService.selectLargeText(formData.get("RMK_TEXT_NUM")));
            }
        }
        else {
            formData = cpri_Service.getPrManualRegInitData(userInfo);
            formData.put("PRDT_MAX_PROGRESS", "1000");
            formData.put("PROJECT_SQ", "0");
        }
        
        req.setAttribute("formData", formData);
        return "/nhepro/CPRI/CPRI0010";
    }

    @RequestMapping(value = "/cpri0010_doSearch")
    public void cpri0010_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	
        Map<String, String> formData = req.getFormData();
        
        List<Map<String, Object>> gridData;
        if( "".equals(formData.get("prList")) ) {
            gridData = cpri_Service.getPrGridData(formData);
        }
        else {
            List<Map<String, String>> prList = new ObjectMapper().readValue(formData.get("prList"), List.class);
            gridData = cpri_Service.getPrGridData2(prList);
        }
        
        resp.setGridObject("grid", gridData);
    }
    
    /**
     * 구매의뢰 저장
     * @param req
     * @param resp
     * @throws Exception
     */
    @RequestMapping(value = "/cpri0010_doSave")
    public void cpri0010_doSave(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> formData = req.getFormData();
        List<Map<String, Object>> gridData = req.getGridData("grid");
        String signStatus = formData.get("SIGN_STATUS");
        Map<String, String> result = null;

        try {
            result = cpri_Service.cpri0010_doSave(formData, gridData, signStatus);
            
            resp.setParameter("isSuccess", "true");
            resp.setParameter("BUYER_CD", result.get("BUYER_CD"));
            resp.setParameter("PR_NUM", result.get("PR_NUM"));
            resp.setParameter("SIGN_STATUS", signStatus);
            resp.setResponseMessage(result.get("message"));
        }
        catch (Exception e) {
            resp.setParameter("isSuccess", "false");
            resp.setResponseMessage(e.getMessage());
            getLog().error(e.getMessage(), e);
        }
    }

	/** ******************************************************************************************
     * 구매요청 현황
     * @param req
     * @return
     * @throws Exception
     */
	@RequestMapping(value="/CPRR0020/view")
	public String p03002_view(EverHttpRequest req) throws Exception {
		req.setAttribute("fromDate", EverDate.addDateMonth(EverDate.getDate(), -1));
		req.setAttribute("toDate", EverDate.getDate());
        return "/nhepro/CPRI/CPRR0020";
	}

	@RequestMapping(value ="/CPRR0020/doSearch")
	public void p03002_doSearchHD(EverHttpRequest req, EverHttpResponse resp) throws Exception {
		Map<String, String> param = req.getFormData();
		List<Map<String, Object>> list = cpri_Service.CPRR0020_doSearch(param);
		resp.setGridObject("grid", list);
	}

	/**
	 * 화면명 : 구매요청진행현황
	 * 처리내용 : 구매요청진행현황
	 * 경로 : 구매관리 > 구매관리 > 구매요청진행현황
	 */
	@RequestMapping(value = "/CPRR0030/view")
	public String BPRP_020(EverHttpRequest req) throws Exception {

		BaseInfo baseInfo = UserInfoManager.getUserInfo();
		Map<String, String> param = new HashMap<String, String>();
		param.put("GATE_CD", baseInfo.getGateCd());
		param.put("BUYER_CD", baseInfo.getCompanyCd());
		req.setAttribute("refPLANT_CODE", commonComboService.getCodesAsJson("CB0036", param));
		req.setAttribute("fromDate", EverDate.addMonths(-1));
		req.setAttribute("toDate", EverDate.getDate());
        return "/nhepro/CPRI/CPRR0030";
	}

	@RequestMapping(value = "/CPRR0030/doSearch")
	public void doSearchPrProgressStatus(EverHttpRequest req, EverHttpResponse resp) throws Exception {
		Map<String, String> param = req.getFormData();
		List<Map<String, Object>> list = cpri_Service.CPRR0030_doSearch(param);
		resp.setGridObject("grid", list);
	}

    /**
     * Gets grid data by rFI no.
     *
     * @param req request
     * @param resp response
     * @throws Exception the exception
     */
    @RequestMapping(value = "/BPRM_010/getGridDataByRFINo")
    public void getGridDataByRFINo(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        String rfiNo = req.getParameter("RFI_NUM");
        List<Map<String, Object>> gridData = cpri_Service.getGridDataByRFINo(rfiNo);
        resp.setGridObject("grid", gridData);
        resp.setResponseCode("true");
    }

    /**
     * Copy previous pr.
     *
     * @param req request
     * @param resp response
     * @throws Exception the exception
     */
    @RequestMapping(value = "/BPRM_010/copyPreviousPr")
    public void copyPreviousPr(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        String prNum = req.getParameter("PR_NUM");
        Map<String, String> formData = cpri_Service.copyPrFormData(prNum);
        List<Map<String, Object>> gridData = cpri_Service.copyPrGridData(prNum);
        resp.setFormDataObject(formData);
        resp.setParameter("grid", new ObjectMapper().writeValueAsString(gridData));
        resp.setResponseCode("true");
    }

    /**
     * Pr registration do delete.
     *
     * @param req request
     * @param resp response
     * @throws Exception the exception
     */
    @RequestMapping(value = "/CPRI0010/doDelete")
    public void prRegistrationDoDelete(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> formData = req.getFormData();

    	String message = cpri_Service.prRegistrationDoDelete(formData);
        resp.setResponseMessage(message);
        resp.setResponseCode("true");
    }

    // 계정 팝업
    @RequestMapping(value = "/BPRM_010/accountPop/view")
    public String accountPop(EverHttpRequest req) {
        return "/eversrm/purchase/prMgt/prRequestReg/accountPop";
    }

    @RequestMapping(value = "/BPRM_010/doAccountSearch")
    public void doAccountSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> reqMap = new HashMap<String, String>();
        reqMap.put("PLANT_CD", req.getParameter("PLANT_CD"));
        reqMap.put("ACCOUNT_NUM", req.getParameter("ACCOUNT_NUM"));

        resp.setParameter("accountMap", EverConverter.getJsonString(cpri_Service.doAccountSearch(reqMap)));
        resp.setResponseCode("true");
    }

    @RequestMapping(value = "/BPRM_010/doCostSearch")
    public void doCostSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> reqMap = new HashMap<String, String>();
        reqMap.put("PLANT_CD", req.getParameter("PLANT_CD"));
        reqMap.put("COST_CD", req.getParameter("COST_CD"));

        resp.setParameter("costMap", EverConverter.getJsonString(cpri_Service.doCostSearch(reqMap)));
        resp.setResponseCode("true");
    }
}
