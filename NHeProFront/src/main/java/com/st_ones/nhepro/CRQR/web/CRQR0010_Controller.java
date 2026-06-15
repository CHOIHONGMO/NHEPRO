package com.st_ones.nhepro.CRQR.web;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
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
import com.st_ones.common.util.service.EverDateService;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.nhepro.CRQR.service.CRQR0010_Service;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : CRQR0010_Controller.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

@Controller
@RequestMapping(value = "/nhepro/CRQR")
public class CRQR0010_Controller extends BaseController {

    @Autowired private CRQR0010_Service crqr0010_service;
    @Autowired private EverDateService wiseDateService;
    @Autowired private CommonComboService commonComboService;
    @Autowired private MessageService msg;


    /**
     * 화면명 : 견적현황
     * 처리내용 : 견적 진행 현황을 조회하는 화면
     * 경로 : 고객사 > 구매관리 > 견적관리 > 견적현황
     */
    @RequestMapping(value="/CRQR0010/view")
    public String CRQR0010(EverHttpRequest req) {
    	String ManagerCd = PropertiesManager.getString("eversrm.customer.admin.ManagerCd");
        UserInfo userInfo = UserInfoManager.getUserInfo();
        boolean hasManagerCd = (userInfo.getCtrlCd()).contains(ManagerCd);
        String ctrlCd = userInfo.getCtrlCd();

        if(ctrlCd.contains("BR030")) {
            req.setAttribute("CTRL_USER_ID", userInfo.getUserId());
            req.setAttribute("CTRL_USER_NM", userInfo.getUserNm());
            req.setAttribute("CTRL_CD", "BR030");
        } else {
            req.setAttribute("CTRL_CD", "");
        }
        
        req.setAttribute("hasManagerCd", hasManagerCd);
        req.setAttribute("FROM_DATE", EverDate.addMonths(-1));
        req.setAttribute("TO_DATE", EverDate.addDateDay(EverDate.getDate(), 14));

        return "/nhepro/CRQR/CRQR0010";
    }

    // 조회
    @RequestMapping(value = "/crqr0010_doSearch")
    public void crqr0010_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	Map<String, String> param = req.getFormData();
    	
    	param.put("SEL_DATE", req.getParamDataMap().get("SEL_DATE"));
    	
        resp.setGridObject("grid", crqr0010_service.crqr0010_doSearch(param));
    }

    // 강제마감
    @RequestMapping(value = "/crqr0010_doForceClosing")
    public void crqr0010_doForceClosing(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        List<Map<String, Object>> grid = req.getGridData("grid");

        Map<String, String> rtnMap = crqr0010_service.crqr0010_doForceClosing(req.getFormData(), grid);

        resp.setResponseMessage(rtnMap.get("rtnMsg"));
    }

    // 구매담당자 변경
    @RequestMapping(value = "/crqr0010_doUpdateChange")
    public void crqr0010_doUpdateChange(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        List<Map<String, Object>> grid = req.getGridData("grid");

        Map<String, String> rtnMap = crqr0010_service.crqr0010_doUpdateChange(req.getFormData(), grid);

        resp.setResponseMessage(rtnMap.get("rtnMsg"));
    }

    /**
     * 화면명 : 견적요청서
     * 처리내용 : 구매담당자가 견적요청 정보를 등록하는 화면
     * 경로 : 고객사 > 구매관리 > 구매의뢰접수 > 구매의뢰접수 > 견적 (버튼) > 견적요청서 (팝업)
     * 경로 : 고객사 > 구매관리 > 구매의뢰접수 > 구매의뢰접수 > 수의시담 (버튼) > 견적요청서 (팝업)
     */
    @RequestMapping(value="/CRQI0011/view")
    public String CRQI0011(EverHttpRequest req) throws Exception {

        Map<String, String> param = req.getParamDataMap();
        UserInfo userInfo = UserInfoManager.getUserInfo();

        Date date = new Date();
		SimpleDateFormat sdformat = new SimpleDateFormat("yyyyMMddHHmmss");
		Calendar cal = Calendar.getInstance();
		cal.setTime(date);
		cal.add(Calendar.MINUTE, 10);
		
        String buyerCd   = req.getParameter("buyerCd");
        String appDocNum = req.getParameter("appDocNum");
        String appDocCnt = req.getParameter("appDocCnt");

        // PR, RFX, RERFX 등
        String baseDataType = EverString.defaultIfEmpty(req.getParameter("baseDataType"), "");
        
        Map<String, Object> data = new HashMap<>();
        // RFX, RERFX(재견적)에서 넘어오는 경우
        if( StringUtils.isNotEmpty(param.get("RFX_NUM"))) {
            data = crqr0010_service.crqi0011_doSearchRQHD(param);
            
            // 재견적
            if( baseDataType.equals("RERFX") ) {
            	String today  = sdformat.format(cal.getTime());
				String tmpMin = ((Integer.parseInt(String.valueOf(Math.round((Math.ceil(Double.parseDouble(today.substring(10, 12)) / 5))) * 5)) < 10) ? "0" + String.valueOf(Math.round((Math.ceil(Double.parseDouble(today.substring(10, 12)) / 5))) * 5) : String.valueOf(Math.round((Math.ceil(Double.parseDouble(today.substring(10, 12)) / 5))) * 5));
				if(tmpMin.equals("00") || tmpMin.equals("60")) {
					cal.add(Calendar.MINUTE, 10);
					today = sdformat.format(cal.getTime());
				}
				data.put("RFX_START_DATE", EverDate.getDate());
				data.put("RFX_START_HOUR", today.substring(8, 10));
				data.put("RFX_START_MIN",  null);
				data.put("RFX_CLOSE_DATE", null);
				data.put("RFX_CLOSE_HOUR", null);
				data.put("RFX_CLOSE_MIN",  null);
			}
        }// 견적요청서 품의상신번호로 조회
        else if( StringUtils.isNotEmpty(appDocNum) ) {
            param.put("BUYER_CD", buyerCd);
            param.put("APP_DOC_NUM", appDocNum);
            param.put("APP_DOC_CNT", appDocCnt);

            data = crqr0010_service.crqi0011_doSearchRQHD(param);
        }// PR에서 작성시
        else {
            data.put("BUYER_CD", 	 userInfo.getCompanyCd());
            data.put("RFX_SUBJECT",  param.get("RFX_SUBJECT"));	// 견적명(=구매의뢰명)
            data.put("RFX_TYPE", 	 param.get("RFX_TYPE"));	// 견적구분(견적, 수의시담)
            data.put("AMT_TYPE", 	 param.get("AMT_TYPE"));	// 금액구분(총액, 단가)
            data.put("CUR", 		 param.get("CUR"));			// 통화
            data.put("VAT_TYPE", 	 param.get("VAT_TYPE"));	// 부가세구분
            data.put("CTRL_USER_ID", userInfo.getUserId());		// 구매담당자ID
            data.put("CTRL_USER_NM", userInfo.getUserNm());		// 구매담당자명
            
        	String today  = sdformat.format(cal.getTime());
			String tmpMin = ((Integer.parseInt(String.valueOf(Math.round((Math.ceil(Double.parseDouble(today.substring(10, 12)) / 5))) * 5)) < 10) ? "0" + String.valueOf(Math.round((Math.ceil(Double.parseDouble(today.substring(10, 12)) / 5))) * 5) : String.valueOf(Math.round((Math.ceil(Double.parseDouble(today.substring(10, 12)) / 5))) * 5));
			if(tmpMin.equals("00") || tmpMin.equals("60")) {
				cal.add(Calendar.MINUTE, 10);
				today = sdformat.format(cal.getTime());
			}
			data.put("RFX_START_DATE", EverDate.getDate());
			data.put("RFX_START_HOUR", today.substring(8, 10));
			data.put("RFX_START_MIN",  null);
        }

        req.setAttribute("gridSel", param.get("gridSel")); // PR : 선택된 품목만, 견적 : 전체품목
        req.setAttribute("formData", data);
		req.setAttribute("today", EverDate.getDate());
		req.setAttribute("todayTime", EverDate.getTime());

        return "/nhepro/CRQR/CRQI0011";
    }

    // 품목정보, 조회
    @RequestMapping(value = "/crqi0011_doSearchPRDT")
    public void crqi0011_doSearchPRDT(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> param = req.getParamDataMap();

        resp.setGridObject("grid", crqr0010_service.crqi0011_doSearchPRDT(req.getFormData(), param));
    }

    // 품목정보, 조회
    @RequestMapping(value = "/crqi0011_doSearchRQDT")
    public void crqi0011_doSearchRQDT(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        
    	Map<String, String> param = req.getParamDataMap();
        resp.setGridObject("grid", crqr0010_service.crqi0011_doSearchRQDT(req.getFormData(), param));
    }

    // 저장
    @RequestMapping(value = "/crqi0011_doSave")
    public void crqi0011_doSave(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        
        Map<String, String> formData = req.getFormData();
    	
        List<Map<String, Object>> grid = req.getGridData("grid");
        List<Map<String, Object>> gridDEL = req.getGridData("gridDEL");
        
        Map<String, String> rtnMap = crqr0010_service.crqi0011_doSave(formData, grid, gridDEL);
        
        resp.setParameter("buyerCd", rtnMap.get("BUYER_CD"));
        resp.setParameter("rfxNum", rtnMap.get("RFX_NUM"));
        resp.setParameter("rfxCnt", rtnMap.get("RFX_CNT"));
        
        resp.setResponseMessage(rtnMap.get("rtnMsg"));
    }
    
    // 2020.12.09 기능 추가
    // 결재 승인 후 협력사 전송
    @RequestMapping(value = "/crqr0010_doSendVendor")
    public void crqr0010_doSendVendor(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        
    	List<Map<String, Object>> grid = req.getGridData("grid");
        Map<String, String> rtnMap = crqr0010_service.crqr0010_doSendVendor(grid);
        
        resp.setResponseMessage(rtnMap.get("rtnMsg"));
    }
    
    // 삭제
    @RequestMapping(value = "/crqi0011_doDelete")
    public void crqi0011_doDelete(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	
        Map<String, String> formData = req.getFormData();
        Map<String, String> rtnMap = crqr0010_service.crqi0011_doDelete(formData);
        resp.setResponseMessage(rtnMap.get("rtnMsg"));
    }
    
    /**
	 * 화면명 : 견적기간변경
	 * 처리내용 : 견적기간변경 화면
	 * 경로 : 고객사 > 구매관리 > 견적관리 > 견적현황 > 견적시간변경
	 * 2021.06.29 견적시간변경 신규 기능 추가
	 */
    
	@RequestMapping(value="/CRQI0012/view")
	public String crqi0012_view(EverHttpRequest req) throws Exception {
		
		Map<String,String> param = req.getParamDataMap();
        String buyerCd = req.getParameter("buyerCd");
        if (param.get("BUYER_CD") == null) {
        	param.put("BUYER_CD", buyerCd);
        }
		req.setAttribute("formData",  crqr0010_service.crqi0012_doSearchRQHD(param));
		req.setAttribute("today", EverDate.getDate());
		req.setAttribute("todayTime", EverDate.getTime());
		return "/nhepro/CRQR/CRQI0012";
	}
	
	@RequestMapping(value = "/crqi0012_doSave")
	public void crqi0012_doSave(EverHttpRequest req, EverHttpResponse resp) throws Exception {
		Map<String, String> formData = req.getFormData();
		
		String rtnMsg = crqr0010_service.crqi0012_doSave(formData);
		resp.setResponseMessage(rtnMsg);
	}

    /**
     * 화면명 : 협력업체 견적제출조회
     * 처리내용 : 참여협력업체 조회
     * 경로 : 고객사 > 구매관리 > 견적관리 > 견적현황, 협력업체선정 > 참여협력업체조회
     */
    @RequestMapping(value="/CRQR0031/view")
    public String CRQR0031(EverHttpRequest req) throws Exception {

    	Map<String, String> formData = req.getFormData();
    	String buyerCd = EverString.nullToEmptyString(req.getParameter("BUYER_CD"));
        if(buyerCd.equals("") || buyerCd == null) { buyerCd = EverString.nullToEmptyString(req.getParameter("buyerCd")); }
        formData.put("BUYER_CD",  buyerCd);
        formData.put("RFX_NUM",  req.getParameter("RFX_NUM"));
    	formData.put("RFX_CNT",  req.getParameter("RFX_CNT"));
    	
    	String appDocNum = req.getParameter("appDocNum");
        String appDocCnt = req.getParameter("appDocCnt");
        formData.put("APP_DOC_NUM",  appDocNum);
        formData.put("APP_DOC_CNT",  appDocCnt);
        
    	req.setAttribute("formData", crqr0010_service.crqr0031_doSearchRQHD(formData));

        return "/nhepro/CRQR/CRQR0031";
    }

    // 조회
    @RequestMapping(value = "/crqr0031_doSearchDT")
    public void crqr0031_doSearchDT(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> param = req.getFormData();

        resp.setGridObject("grid", crqr0010_service.crqr0031_doSearchDT(param));
        resp.setResponseCode("true");
    }

    /**
     * 화면명 : 협력업체선정
     * 처리내용 : 협력업체를 선정하기 위해 견적진행현황을 조회하는 화면
     * 경로 : 고객사 > 구매관리 > 견적관리 > 협력업체선정
     */
    @RequestMapping(value="/CRQA0040/view")
    public String CRQA0040(EverHttpRequest req) {

        req.setAttribute("FROM_DATE", EverDate.addMonths(-1));
        req.setAttribute("TO_DATE", EverDate.getDate());

        return "/nhepro/CRQR/CRQA0040";
    }

    // 조회
    @RequestMapping(value = "/crqa0040_doSearch")
    public void crqa0040_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> param = req.getFormData();
    	
    	param.put("SEL_DATE", req.getParamDataMap().get("SEL_DATE"));
    	
        resp.setGridObject("grid", crqr0010_service.crqa0040_doSearch(param));
        resp.setResponseCode("true");
    }

    // 견적 개찰
    @RequestMapping(value = "/crqa0040_doOpen")
	public void crqa0040_doOpen(EverHttpRequest req, EverHttpResponse resp) throws Exception {

   		List<Map<String, Object>> gridData = req.getGridData("grid");
		String msg = crqr0010_service.crqa0040_doOpen(gridData);

		resp.setResponseMessage(msg);
	}
    
    // 수의결과보고
    @RequestMapping(value = "/crqa0040_doApproval") 
    public void cbdr0040_doApproval(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	//
        List<Map<String, Object>> gridDatas = req.getGridData("grid");
        Map<String, String> formData = new HashMap<String, String>();
        formData.put("approvalFormData", EverString.nullToEmptyString(req.getParameter("approvalFormData")));
        formData.put("approvalGridData", EverString.nullToEmptyString(req.getParameter("approvalGridData")));
        formData.put("attachFileDatas", EverString.nullToEmptyString(req.getParameter("attachFileDatas")));

        String rtnMsg = crqr0010_service.crqa0040_doApproval(formData, gridDatas);
        resp.setResponseMessage(rtnMsg);
    }

    /**
     * 화면명 : 단일업체선정 견적비교
     * 처리내용 : 전체 품목에 대해 단일업체 선정
     * 경로 : 고객사 > 구매관리 > 견적관리 > 협력업체선정 > 단일업체선정 견적비교
     */
    @RequestMapping(value="/CRQI0041/view")
    public String crqi0041_view(EverHttpRequest req) throws Exception {
        req.setAttribute("refEVAL_TYPE", commonComboService.getCodeComboAsJson("M069"));

        Map<String, String> param = new HashMap<String, String>();
        param.put("BUYER_CD", EverString.nullToEmptyString(req.getParameter("BUYER_CD")));
        param.put("RFX_NUM",  EverString.nullToEmptyString(req.getParameter("RFX_NUM")));
        param.put("RFX_CNT",  EverString.nullToEmptyString(req.getParameter("RFX_CNT")));

        Map<String, String> formData = crqr0010_service.doSearchComparisonByTotal_F(param);
        req.setAttribute("formData", formData);
        return "/nhepro/CRQR/CRQI0041";
    }

    // 조회(업체)
    @RequestMapping(value = "/crqi0041_doSearchV")
    public void crqi0041_doSearchV(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.setGridObject("gridV", crqr0010_service.crqi0041_doSearchV(req.getFormData()));
    }

    // 조회(품목)
    @RequestMapping(value = "/crqi0041_doSearchI")
    public void crqi0041_doSearchI(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.setGridObject("gridI", crqr0010_service.crqi0041_doSearchI(req.getFormData()));
    }

    // 유찰 - PR복구
    @RequestMapping(value = "/crqi0041_doPRRestore")
    public void crqi0041_doPRRestore(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, Object> formData = new HashMap<String, Object>();
        formData.putAll(req.getFormData());

        String msg = crqr0010_service.crqi0041_doPRRestore(formData);
        resp.setResponseMessage(msg);
    }

    // 업체선정
    @RequestMapping(value = "/crqi0041_doFinal")
    public void crqi0041_doFinal(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        List<Map<String, Object>> gridData = req.getGridData("gridV");
        Map<String, Object> formData = new HashMap<String, Object>();
        formData.putAll(req.getFormData());

        String msg = crqr0010_service.crqi0041_doFinal(formData, gridData);

        resp.setResponseMessage(msg);
    }

    /**
     * 화면명 : 품목별선정 견적비교
     * 처리내용 : 품목별로 별도의 협력업체 선정
     * 경로 : 고객사 > 구매관리 > 견적관리 > 협력업체선정 > 품목별선정 견적비교
     */
    @RequestMapping(value="/CRQI0042/view")
    public String crqi0042_view(EverHttpRequest req) throws Exception {

        Map<String, String> param = new HashMap<String, String>();
        param.put("BUYER_CD", EverString.nullToEmptyString(req.getParameter("BUYER_CD")));
        param.put("RFX_NUM",  EverString.nullToEmptyString(req.getParameter("RFX_NUM")));
        param.put("RFX_CNT",  EverString.nullToEmptyString(req.getParameter("RFX_CNT")));

        Map<String, Object> formData = crqr0010_service.doSearchComparisonByItem_F(param);
        req.setAttribute("formData", formData);

        return "/nhepro/CRQR/CRQI0042";
    }

    @RequestMapping(value = "/crqi0042_doSearch")
    public void crqi0042_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        List<Map<String, Object>> list = crqr0010_service.doSearchComparisonByItem_G(req.getFormData());
        String vendorColor = "";
        String itemClolr = "#ABF200";
        String tempRfxSq = "";
        boolean chBole = true;

        for(int k = 0; k < list.size(); k++) {

            Map<String, Object> mdt = list.get(k);
            if( !String.valueOf(mdt.get("RFX_SQ")).equals(tempRfxSq) ) {
                tempRfxSq  = String.valueOf(mdt.get("RFX_SQ"));
                if (chBole == true) {
                    itemClolr = "#FFE400";
                    chBole = !chBole;
                } else {
                    itemClolr = "#ABF200";
                    chBole = !chBole;
                }
            }

            if (Integer.parseInt(String.valueOf(mdt.get("PRICE_RANK"))) == 1) {
                vendorColor = "#F5A9A9";
            } else {
                vendorColor = "#FFFFFF";
            }
            
            resp.setGridCellStyle("grid", String.valueOf(k), "FAIL_BID_FLAG" , "background-color", vendorColor);
            resp.setGridCellStyle("grid", String.valueOf(k), "AWARD" , "background-color", vendorColor);
            resp.setGridCellStyle("grid", String.valueOf(k), "PRICE_RANK" , "background-color", vendorColor);
            resp.setGridCellStyle("grid", String.valueOf(k), "VENDOR_CD" , "background-color", vendorColor);
            resp.setGridCellStyle("grid", String.valueOf(k), "VENDOR_NM" , "background-color", vendorColor);
            resp.setGridCellStyle("grid", String.valueOf(k), "UNIT_PRC" , "background-color", vendorColor);
            resp.setGridCellStyle("grid", String.valueOf(k), "ITEM_AMT" , "background-color", vendorColor);
            resp.setGridCellStyle("grid", String.valueOf(k), "SETTLE_RMK" , "background-color", vendorColor);
            resp.setGridCellStyle("grid", String.valueOf(k), "SW_BUS_PRICE" , "background-color", vendorColor);
            resp.setGridCellStyle("grid", String.valueOf(k), "SW_BUS_RATE" , "background-color", vendorColor);
            resp.setGridCellStyle("grid", String.valueOf(k), "MNT_SANGJU_YN" , "background-color", vendorColor);
            resp.setGridCellStyle("grid", String.valueOf(k), "CONSUMER_AMT" , "background-color", vendorColor);
            resp.setGridCellStyle("grid", String.valueOf(k), "CONSUMER_RATE" , "background-color", vendorColor);
            resp.setGridCellStyle("grid", String.valueOf(k), "FC_MNT_TERM" , "background-color", vendorColor);
            resp.setGridCellStyle("grid", String.valueOf(k), "CH_RATE" , "background-color", vendorColor);
            resp.setGridCellStyle("grid", String.valueOf(k), "DOIB_AMT" , "background-color", vendorColor);
            resp.setGridCellStyle("grid", String.valueOf(k), "MNT_RATE" , "background-color", vendorColor);
            resp.setGridCellStyle("grid", String.valueOf(k), "MNT_SDAY" , "background-color", vendorColor);
            resp.setGridCellStyle("grid", String.valueOf(k), "MNT_EDAY" , "background-color", vendorColor);
            resp.setGridCellStyle("grid", String.valueOf(k), "MNT_GUR_MONTH" , "background-color", vendorColor);
            resp.setGridCellStyle("grid", String.valueOf(k), "RT_INSP_PERIOD" , "background-color", vendorColor);
            resp.setGridCellStyle("grid", String.valueOf(k), "FALT_RC_TG_TIME" , "background-color", vendorColor);
            resp.setGridCellStyle("grid", String.valueOf(k), "DUE_DATE" , "background-color", vendorColor);
            resp.setGridCellStyle("grid", String.valueOf(k), "VALID_FROM_DATE" , "background-color", vendorColor);
            resp.setGridCellStyle("grid", String.valueOf(k), "VALID_TO_DATE" , "background-color", vendorColor);
            resp.setGridCellStyle("grid", String.valueOf(k), "PR_ATT_FILE_CNT" , "background-color", vendorColor);
            resp.setGridCellStyle("grid", String.valueOf(k), "VENDOR_ATT_FILE_CNT" , "background-color", vendorColor);
            resp.setGridCellStyle("grid", String.valueOf(k), "PR_ITEM_RMK" , "background-color", vendorColor);
            resp.setGridCellStyle("grid", String.valueOf(k), "VENDOR_ITEM_RMK" , "background-color", vendorColor);

            resp.setGridCellStyle("grid", String.valueOf(k), "BUYER_NM" , "background-color", itemClolr);
            resp.setGridCellStyle("grid", String.valueOf(k), "PURCHASE_TYPE" , "background-color", itemClolr);
            resp.setGridCellStyle("grid", String.valueOf(k), "ITEM_CD" , "background-color", itemClolr);
            resp.setGridCellStyle("grid", String.valueOf(k), "ITEM_DESC" , "background-color", itemClolr);
            resp.setGridCellStyle("grid", String.valueOf(k), "ITEM_SPEC" , "background-color", itemClolr);
            resp.setGridCellStyle("grid", String.valueOf(k), "MAKER_NM" , "background-color", itemClolr);
            resp.setGridCellStyle("grid", String.valueOf(k), "MAKER_PART_NO" , "background-color", itemClolr);
            resp.setGridCellStyle("grid", String.valueOf(k), "ORIGIN_CD" , "background-color", itemClolr);
            resp.setGridCellStyle("grid", String.valueOf(k), "RFX_QT" , "background-color", itemClolr);
            resp.setGridCellStyle("grid", String.valueOf(k), "UNIT_CD" , "background-color", itemClolr);
            resp.setGridCellStyle("grid", String.valueOf(k), "CUR" , "background-color", itemClolr);
            resp.setGridCellStyle("grid", String.valueOf(k), "R_UNIT_PRC" , "background-color", itemClolr);
            resp.setGridCellStyle("grid", String.valueOf(k), "R_ITEM_AMT" , "background-color", itemClolr);
        }

        resp.setGridObject("grid", list);

        // 합계금액
        Map<String, Object> unitPrcMap = crqr0010_service.doSearchComparisonSumUnitPrc(req.getFormData());
        if(unitPrcMap == null) {
            resp.setParameter("sumAmt", "0");
        } else {
            resp.setParameter("sumAmt", EverString.nullToEmptyString(String.valueOf(unitPrcMap.get("ITEM_AMT"))).equals("") ? "0" : String.valueOf(unitPrcMap.get("ITEM_AMT")));
        }
    }

    // CRQI0042 : 품목별 업체선정 => 유찰
    @RequestMapping(value = "/crqi0042_doPRRestore")
    public void crqi0042_doPRRestore(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, Object> form = new HashMap<String, Object>();
        form.putAll(req.getFormData());

        String msg = crqr0010_service.doRestoreComparisonByItem(form);
        resp.setResponseMessage(msg);
    }

    // CRQI0042 : 품목별 업체선정 => 재견적(일부 품목에 대해 업체선정)
    @RequestMapping(value = "/crqi0042_doFinalRe")
    public void crqi0042_doFinalRe(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        List<Map<String, Object>> gridData = req.getGridData("grid");
        Map<String, Object> formData = new HashMap<String, Object>();
        formData.putAll(req.getFormData());

        String msg = crqr0010_service.doFinalComparisonByItemDoRe(formData, gridData);
        resp.setResponseMessage(msg);
    }

    // CRQI0042 : 품목별 업체선정 => 협력업체 선정
    @RequestMapping(value = "/crqi0042_doFinal")
    public void crqi0042_doFinal(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        List<Map<String, Object>> gridData = req.getGridData("grid");
        Map<String, Object> formData = new HashMap<String, Object>();
        formData.putAll(req.getFormData());

        String msg = crqr0010_service.doFinalComparisonByItem(formData, gridData);
        resp.setResponseMessage(msg);
    }

}
