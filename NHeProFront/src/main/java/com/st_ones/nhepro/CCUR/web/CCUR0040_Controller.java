package com.st_ones.nhepro.CCUR.web;

import com.st_ones.common.combo.service.CommonComboService;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.nhepro.CCUR.service.CCUR0040_Service;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping(value = "/nhepro/CCUR")
public class CCUR0040_Controller extends BaseController {

	@Autowired
	private CommonComboService commonComboService;
	@Autowired
	private CCUR0040_Service ccur0040_service;

	@RequestMapping(value = "/CCUR0040/view")
	public String CCUR0040(EverHttpRequest req) throws Exception {

		return "/nhepro/CCUR/CCUR0040";
	}

	@RequestMapping(value = "/CCUR0040/ccur0040_doSearch")
	public void ccur0040_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		Map<String, String> param = req.getFormData();

		makeGridTextLinkStyle(resp, "gridMain", "EV_ITEM_SUBJECT");

		resp.setGridObject("gridMain", ccur0040_service.ccur0040_doSearchEvalItemMgt(param));
		resp.setResponseCode("true");
	}

	@RequestMapping(value = "/CCUR0040/ccur0040_doSearchDetail")
	public void ccur0040_doSearchDetail(EverHttpRequest req, EverHttpResponse resp) throws Exception {
		Map<String, String> param = req.getFormData();
		param.put("EV_ITEM_NUM", req.getParameter("EV_ITEM_NUM"));

		List<Map<String,Object>> gridQlyList = ccur0040_service.ccur0040_doSearchEvalItemMgtDetail(param);
		List<Map<String,Object>> gridQtyList = ccur0040_service.ccur0040_doSearchEvalItemMgtDetail2(param);

		for(int i = 0; i < gridQlyList.size(); i++) {
			resp.setGridRowStyle("gridQly", String.valueOf(i), "text-decoration", "inherit");
			resp.setGridRowStyle("gridQly", String.valueOf(i), "background-color", "#fdd");
		}

		for(int i = 0; i < gridQtyList.size(); i++) {
			resp.setGridRowStyle("gridQty", String.valueOf(i), "text-decoration", "inherit");
			resp.setGridRowStyle("gridQty", String.valueOf(i), "background-color", "#fdd");
		}

		resp.setGridObject("gridQly", gridQlyList);
		resp.setGridObject("gridQty", gridQtyList);
		resp.setResponseCode("true");
	}

	@RequestMapping(value = "/CCUR0040/ccur0040_doSave")
	public void ccur0040_doSave(EverHttpRequest req, EverHttpResponse resp) throws Exception {
		Map<String, String> formData = req.getFormData();
		List<Map<String, Object>> gridDatas = new ArrayList<Map<String, Object>>();
		if ("QUA".equals(formData.get("EV_ITEM_METHOD_CD_RT").toString())) {
			gridDatas = req.getGridData("gridQly");
		} else {
			gridDatas = req.getGridData("gridQty");
		}
		String[] msg = ccur0040_service.ccur0040_doSaveEvalItemMgt(formData, gridDatas);
		resp.setParameter("paramEV_ITEM_NO", msg[0]);
		resp.setResponseMessage(msg[1]);
		resp.setResponseCode("true");
	}

	@RequestMapping(value = "/CCUR0040/ccur0040_doDeleteR")
	public void ccur0040_doDeleteR(EverHttpRequest req, EverHttpResponse resp) throws Exception {
		Map<String, String> formData = req.getFormData();
		List<Map<String, Object>> gridDatas = new ArrayList<Map<String, Object>>();
		if ("QUA".equals(formData.get("EV_ITEM_METHOD_CD_RT").toString())) {
			gridDatas = req.getGridData("gridQly");
		} else {
			gridDatas = req.getGridData("gridQty");
		}
		String msg = ccur0040_service.ccur0040_doDeleteEvalItemMgt(formData, gridDatas);
		resp.setResponseMessage(msg);
		resp.setResponseCode("true");
	}

	@RequestMapping(value = "/CCUR0040/ccur0040_changeComboItemKindL")
	public void ccur0040_changeComboItemKindL(EverHttpRequest req, EverHttpResponse resp) throws Exception {
		Map<String, String> param = req.getFormData();
		if ("E".equals(param.get("EV_ITEM_KIND_CD")))
			resp.setParameter("itemTypeCode",  commonComboService.getCodeComboAsJson("M114")  );
		else
			resp.setParameter("itemTypeCode",  commonComboService.getCodeComboAsJson("M113")  );

		resp.setResponseCode("true");
	}

	@RequestMapping(value = "/CCUR0040/ccur0040_changeComboItemKindR")
	public void ccur0040_changeComboItemKindR(EverHttpRequest req, EverHttpResponse resp) throws Exception {
		Map<String, String> param = req.getFormData();
		if ("E".equals(param.get("EV_ITEM_KIND_CD_RT").toString()))
			resp.setParameter("itemTypeCode", commonComboService.getCodeComboAsJson("M114"));
		else
			resp.setParameter("itemTypeCode", commonComboService.getCodeComboAsJson("M113"));

		resp.setResponseCode("true");
	}


	@RequestMapping(value = "/CCUR0040/ccur0040_changeComboItemKindValue")
	public void ccur0040_changeComboItemKindValue(EverHttpRequest req, EverHttpResponse resp) throws Exception {
		Map<String, String> param = req.getFormData();
		param.put("EV_ITEM_KIND_CD", req.getParameter("EV_ITEM_KIND_CD"));
		if ("E".equals(param.get("EV_ITEM_KIND_CD").toString()))
			resp.setParameter("itemTypeCode",  commonComboService.getCodeComboAsJson("M114")  );
		else
			resp.setParameter("itemTypeCode",  commonComboService.getCodeComboAsJson("M113")  );

		resp.setResponseCode("true");
	}

	@RequestMapping(value = "/CCUR0040/ccur0040_doDelete")
	public void ccur0040_doDelete(EverHttpRequest req, EverHttpResponse resp) throws Exception {
		List<Map<String,Object>> gridData = req.getGridData("gridMain");

		String msg = ccur0040_service.ccur0040_doDeleteEvalItemMgt(gridData);

		resp.setResponseMessage(msg);
		resp.setResponseCode("true");
	}

	//이미지 텍스트그리드
	private void makeGridTextLinkStyle(EverHttpResponse resp, String grid, String columnName) {
        resp.setGridColStyle(grid, columnName, "cursor", "pointer");
        resp.setGridColStyle(grid, columnName, "color", "#000DFF");
        resp.setGridColStyle(grid, columnName, "text-decoration", "underline");
	}

}
