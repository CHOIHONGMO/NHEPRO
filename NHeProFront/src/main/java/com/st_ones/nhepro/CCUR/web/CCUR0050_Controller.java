package com.st_ones.nhepro.CCUR.web;

import com.st_ones.common.combo.service.CommonComboService;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.nhepro.CCUR.service.CCUR0050_Service;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;
import java.util.Map;

@Controller
@RequestMapping(value = "/nhepro/CCUR/")
public class CCUR0050_Controller extends BaseController {

	@Autowired
	private CCUR0050_Service ccur0050_service;
	
	@Autowired 
	private CommonComboService commonComboService;

	@RequestMapping(value = "/CCUR0050/view")
	public String CCUR0050(EverHttpRequest req) throws Exception {
		req.setAttribute("evalKind", commonComboService.getCodeComboAsJson("M115"));
		return "/nhepro/CCUR/CCUR0050";
	}

	@RequestMapping(value = "/CCUR0050/ccur0050_doSearchLeftGrid")
	public void ccur0050_doSearchLeftGrid(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		Map<String, String> param = req.getFormData();

		makeGridTextLinkStyle(resp, "leftGrid", "EV_TPL_SUBJECT");

		resp.setGridObject("leftGrid", ccur0050_service.ccur0050_doSearchLeftGrid(param));
		resp.setResponseCode("true");
	}
	
	@RequestMapping(value = "/CCUR0050/ccur0050_doSearchRightGrid")
	public void ccur0050_doSearchRightGrid(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		Map<String, String> param = req.getFormData();
		param.put("EV_TPL_NUM", req.getParameter("EV_TPL_NUM"));
		List<Map<String,Object>> gridData = ccur0050_service.ccur0050_doSearchRightGrid(param);
/*
		for(int i = 0; i < gridData.size(); i++) {
			resp.setGridRowStyle("rightGrid", String.valueOf(i), "text-decoration", "inherit");
			resp.setGridRowStyle("rightGrid", String.valueOf(i), "background-color", "#fdd");
		}

		makeGridTextLinkStyle(resp, "rightGrid", "EV_ITEM_SUBJECT");
*/
		resp.setGridObject("rightGrid", gridData);
		resp.setResponseCode("true");
	}
	
	@RequestMapping(value = "/CCUR0050/ccur0050_doDelete")
	public void ccur0050_doDelete(EverHttpRequest req, EverHttpResponse resp) throws Exception {
		String msg = "";
		try {
			//Map<String, String> param = req.getFormData();
			List<Map<String, Object>> gridData = req.getGridData("leftGrid");

			msg = ccur0050_service.ccur0050_doDelete(gridData);
		} catch (Exception e) {
			getLog().error(e.getMessage(), e);
			msg = e.getMessage();
		} finally {
			resp.setResponseMessage(msg);
			resp.setResponseCode("true");
		}
	}
	
	@RequestMapping(value = "/CCUR0050/ccur0050_doCopy")
	public void ccur0050_doCopy(EverHttpRequest req, EverHttpResponse resp) throws Exception {
		String[] msg = new String[2] ;
		try {
			Map<String, String> param = req.getFormData();
			List<Map<String, Object>> gridDatas = req.getGridData("rightGrid"); 
			msg = ccur0050_service.ccur0050_doCopy(param, gridDatas);
		} catch (Exception e) {
			getLog().error(e.getMessage(), e);
			msg[1] = e.getMessage();
		} finally {
			resp.setParameter("EV_TPL_NO", msg[0]);
			resp.setResponseMessage(msg[1]);
			resp.setResponseCode("true");
		}
	}
	
	@RequestMapping(value = "/CCUR0050/ccur0050_doSave")
	public void ccur0050_doSave(EverHttpRequest req, EverHttpResponse resp) throws Exception {
		String[] msg = new String[2] ;
		try {
			Map<String, String> param = req.getFormData();
			List<Map<String, Object>> gridDatas = req.getGridData("rightGrid"); 
			msg = ccur0050_service.ccur0050_doSave(param, gridDatas);
		} catch (Exception e) {
			getLog().error(e.getMessage(), e);
			msg[1] = e.getMessage();
		} finally {
			resp.setParameter("EV_TPL_NO", msg[0]);
			resp.setResponseMessage(msg[1]);
			resp.setResponseCode("true");
		}
	}

	//CCUR0051
	@RequestMapping(value = "/CCUR0051/view")
	public String CCUR0051(EverHttpRequest req) throws Exception {
		String evalKind = req.getParameter("evalKind");
		if(evalKind.equals("S")){
			req.setAttribute("evalType", commonComboService.getCodeComboAsJson("M113"));
		}else{
			req.setAttribute("evalType", commonComboService.getCodeComboAsJson("M114"));
		}
		req.setAttribute("evalKind", commonComboService.getCodeComboAsJson("M115"));
		req.setAttribute("evalMethod", commonComboService.getCodeComboAsJson("M116"));
		return "/nhepro/CCUR/CCUR0051";
	}
	
	@RequestMapping(value = "/CCUR0051/ccur0051_doSearch")
	public void ccur0051_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
		Map<String, String> param = req.getFormData();
		resp.setGridObject("leftGrid", ccur0050_service.ccur0051_doSearchAppendItem(param));
		resp.setResponseCode("true");
	}

	//이미지 텍스트그리드
	private void makeGridTextLinkStyle(EverHttpResponse resp, String grid, String columnName) {
        resp.setGridColStyle(grid, columnName, "cursor", "pointer");
        resp.setGridColStyle(grid, columnName, "color", "#000DFF");
        resp.setGridColStyle(grid, columnName, "text-decoration", "underline");
	}

}