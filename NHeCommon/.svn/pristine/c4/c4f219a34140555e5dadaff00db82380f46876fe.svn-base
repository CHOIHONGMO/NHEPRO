package com.st_ones.eversrm.manager.org.web;

import com.st_ones.common.file.service.FileAttachService;
import com.st_ones.common.util.clazz.EverDate;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.eversrm.manager.org.service.MOGA0030_Service;

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
 * @File Name : MOGA0030Controller.java
 * @date 2013. 07. 22.
 * @version 1.0MOGA0030_doSave
 */

@Controller
@RequestMapping(value = "/eversrm/manager/org")
public class MOGA0030_Controller extends BaseController {

	@Autowired FileAttachService fileAttachService;
	@Autowired private MOGA0030_Service moga0030_service;

	/**
	 * 화면명 : 조직관리 (Grid)
	 * 처리내용 : 조직(부서)을 조회/관리한다.
	 * 경로 : 시스템관리 > 조직관리 > 조직관리 (Grid)
	 */
	@RequestMapping(value = "/MOGA0030/view")
	public String MOGA0030(EverHttpRequest req) {
		req.setAttribute("yyyymm", EverDate.getShortDateString().substring(0, 6));
		return "/eversrm/manager/org/MOGA0030";
	}

	@RequestMapping(value="/MOGA0030_doSearch")
	public void MOGA0030_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		Map<String, String> param = req.getFormData();

		if(!param.get("DEPT_NM").equals("")){
			param.put("DEPT_TYPE", "400");
			resp.setGridObject("gridDP", moga0030_service.MOGA0030_doSearch(param));

			param.put("DEPT_TYPE", "300");
			resp.setGridObject("gridB", moga0030_service.MOGA0030_doSearch(param));

			param.put("DEPT_TYPE", "200");
			param.put("STEP2", "Y");
			resp.setGridObject("gridM", moga0030_service.MOGA0030_doSearch_parent(param));

			param.put("DEPT_TYPE", "100");
			param.put("STEP2", "");
			param.put("STEP1", "Y");
			resp.setGridObject("gridT", moga0030_service.MOGA0030_doSearch_parent(param));
		}
		else {
			param.put("DEPT_TYPE", "100");
			resp.setGridObject("gridT", moga0030_service.MOGA0030_doSearch(param));
		}
	}

	@RequestMapping(value="/MOGA0030_doSearchM")
	public void MOGA0030_doSearchM(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		Map<String, String> param = req.getFormData();
		param.put("PARENT_DEPT_CD", req.getParameter("PARENT_DEPT_CD"));
		param.put("DEPT_TYPE", "200");

		resp.setGridObject("gridM", moga0030_service.MOGA0030_doSearch(param));
	}

	@RequestMapping(value="/MOGA0030_doSearchB")
	public void MOGA0030_doSearchB(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		Map<String, String> param = req.getFormData();
		param.put("PARENT_DEPT_CD", req.getParameter("PARENT_DEPT_CD"));
		param.put("DEPT_TYPE", "300");

		resp.setGridObject("gridB", moga0030_service.MOGA0030_doSearch(param));
	}

	@RequestMapping(value="/MOGA0030_doSearchDP")
	public void MOGA0030_doSearchDP(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		Map<String, String> param = req.getFormData();
		param.put("PARENT_DEPT_CD", req.getParameter("PARENT_DEPT_CD"));
		param.put("DEPT_TYPE", "400");

		resp.setGridObject("gridDP", moga0030_service.MOGA0030_doSearch(param));
	}

	@RequestMapping(value="/MOGA0030_doSave")
	public void MOGA0030_doSave(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		Map<String, String> formData = req.getFormData();
		String radioVal = EverString.nullToEmptyString(req.getParameter("radioVal"));

		List<Map<String, Object>> gridList = null;
		if(radioVal.equals("R1")) { gridList = req.getGridData("gridT"); }
		else if(radioVal.equals("R2")) { gridList = req.getGridData("gridM"); }
		else if(radioVal.equals("R3")) { gridList = req.getGridData("gridB"); }
		else if(radioVal.equals("R4")) { gridList = req.getGridData("gridDP"); }

		String returnMsg = (gridList == null ? "" : moga0030_service.MOGA0030_doSave(formData, gridList));
		resp.setResponseMessage(returnMsg);
	}

}