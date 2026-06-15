package com.st_ones.nhepro.CBDR.web;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.st_ones.common.combo.service.CommonComboService;
import com.st_ones.common.util.clazz.EverDate;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.common.util.service.EverDateService;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.nhepro.CBDR.service.CBDR0050_Service;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2014 ST-Ones CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : CBDI0010_Controller.java
 * @date 2020. 4. 02.
 * @version 1.0
 */

@Controller
@RequestMapping(value = "/nhepro/CBDR")
public class CBDR0050_Controller extends BaseController {

	@Autowired private EverDateService everDate;

	@Autowired private CommonComboService commonComboService;

	@Autowired private CBDR0050_Service cbdi_Service;

	/**
	 * 화면명 :
	 * 처리내용 : 예정가격 조회 화면.
	 * 경로 : 고객사 > 구매관리 > 입찰관리 > 예정가격
	 */
	@RequestMapping(value="/CBDR0050/view")
	public String cbdi0010_view(EverHttpRequest req) throws Exception {
		req.setAttribute("reqFromDate", EverDate.addDateMonth(EverDate.getDate(), -1));
		req.setAttribute("reqToDate", EverDate.getDate());
		return "/nhepro/CBDR/CBDR0050";
	}

	@RequestMapping(value = "/cbdr0050_doSearch")
	public void cbdr0050_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
		resp.setGridObject("grid", cbdi_Service.cbdr0050_doSearch(req.getFormData()));
	}

	@RequestMapping(value = "/cbdr0050_doChangeCtrl")
	public void cbdi0010_doChangeCtrl(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		List<Map<String, Object>> gridDatas = req.getGridData("grid");

		String rtnMsg = cbdi_Service.cbdr0050_doChangeCtrl(EverString.nullToEmptyString(req.getParameter("CTRL_USER_ID")), gridDatas);
		resp.setResponseMessage(rtnMsg);
	}

	/**
	 * 화면명 : 예정가격상신
	 * 처리내용 : 예가가격 결재상신하는 화면.
	 * 경로 : 고객사 > 구매관리 > 입찰관리 > 예정가격 > 예정가격상신
	 */
	@RequestMapping(value="/CBDI0051/view")
	public String cbdi0051_view(EverHttpRequest req) throws Exception {

		Map<String,String> param = req.getParamDataMap();
        String buyerCd = req.getParameter("buyerCd");
        String appDocNum = req.getParameter("appDocNum");
        if (param.get("BUYER_CD") == null) {
        	param.put("BUYER_CD", buyerCd);
        }
		req.setAttribute("formData", cbdi_Service.cbdi0051_doSearch(param));
		return "/nhepro/CBDR/CBDI0051";
	}

	@RequestMapping(value = "/cbdi0051_doSave")
	public void cbdi0051_doSave(EverHttpRequest req, EverHttpResponse resp) throws Exception {
		String rtnMsg = cbdi_Service.cbdi0051_doSave(req.getFormData());
		resp.setResponseMessage(rtnMsg);
	}

	/**
	 * 화면명 : 복수예가등록
	 * 처리내용 : 예가가격(단일) 확정하는 화면.
	 * 경로 : 고객사 > 구매관리 > 입찰관리 > 예정가격 > 복수예가등록
	 */
	@RequestMapping(value="/CBDI0052/view")
	public String cbdi0052_view(EverHttpRequest req) throws Exception {

		Map<String,String> param = req.getParamDataMap();
        String buyerCd = req.getParameter("buyerCd");
        String appDocNum = req.getParameter("appDocNum");
        if (param.get("BUYER_CD") == null) {
        	param.put("BUYER_CD", buyerCd);
        }
		req.setAttribute("formData",  cbdi_Service.cbdi0051_doSearch(param));
		return "/nhepro/CBDR/CBDI0052";
	}

	@RequestMapping(value = "/cbdi0052_doSave")
	public void cbdi0052_doSave(EverHttpRequest req, EverHttpResponse resp) throws Exception {
		String rtnMsg = cbdi_Service.cbdi0052_doSave(req.getFormData());
		resp.setResponseMessage(rtnMsg);
	}

	/**
	 * 화면명 : 예정가격 확정
	 * 처리내용 : 예가가격(복수) 확정하는 화면.
	 * 경로 : 고객사 > 구매관리 > 입찰관리 > 예정가격 > 예정가격 확정
	 */
	@RequestMapping(value="/CBDI0053/view")
	public String cbdi0053_view(EverHttpRequest req) throws Exception {

		Map<String,String> param = req.getParamDataMap();
        String buyerCd = req.getParameter("buyerCd");
        String appDocNum = req.getParameter("appDocNum");
        if (param.get("BUYER_CD") == null) {
        	param.put("BUYER_CD", buyerCd);
        }
		req.setAttribute("formData",  cbdi_Service.cbdi0051_doSearch(param));
		return "/nhepro/CBDR/CBDI0053";
	}

	@RequestMapping(value = "/cbdi0053_doSave")
	public void cbdi0053_doSave(EverHttpRequest req, EverHttpResponse resp) throws Exception {
		String rtnMsg = cbdi_Service.cbdi0053_doSave(req.getFormData());
		resp.setResponseMessage(rtnMsg);
	}

}