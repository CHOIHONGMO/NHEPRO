package com.st_ones.eversrm.manager.screen.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.st_ones.common.util.clazz.EverString;
import com.st_ones.common.util.service.LargeTextService;
import com.st_ones.everf.serverside.info.BaseInfo;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.eversrm.manager.screen.service.MSRA0010_Service;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : MSRA0010_Controller.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

@Controller
@RequestMapping(value = "/eversrm/manager/screen")
public class MSRA0010_Controller extends BaseController {

	@Autowired private LargeTextService largeTextService;

	@Autowired private MSRA0010_Service msra0010_service;

	/**
	 * 화면명 : 화면관리
	 * 처리내용 : 시스템에서 사용하는 화면정보를 관리하는 화면
	 * 경로 : 시스템관리 > 화면 > 화면관리
	 */
	@RequestMapping(value = "/MSRA0010/view")
	public String MSRA0010(EverHttpRequest req) {
		/* 관리자 권한이 존재하지 않으면 접속 불가 */
		BaseInfo baseInfo = (BaseInfo)req.getSession().getAttribute("ses");
		if (baseInfo.getSuperUserFlag().equals("0")) {
//			return "/everqis/noSuperAuth";
		}
		return "/eversrm/manager/screen/MSRA0010";
	}

	@RequestMapping(value = "/screenManagement/doSearch")
	public void doSearchScreenManagement(EverHttpRequest req, EverHttpResponse resp) throws Exception {
		resp.setGridObject("grid", msra0010_service.doSearchScreenManagement(req.getFormData()));
	}

	@RequestMapping(value = "/screenManagement/doInsert")
	public void doInsertScreenManagement(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		List<Map<String, Object>> gridData = req.getGridData("grid");
		String msg = msra0010_service.doSaveScreenManagement(gridData);

		resp.setResponseMessage(msg);
	}

	@RequestMapping(value = "/screenManagement/doUpdate")
	public void doUpdateScreenManagement(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		List<Map<String, Object>> gridData = req.getGridData("grid");
		String msg = msra0010_service.doSaveScreenManagement(gridData);

		resp.setResponseMessage(msg);
	}

	@RequestMapping(value = "/screenManagement/doDelete")
	public void doDeleteScreenManagement(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		List<Map<String, Object>> gridData = req.getGridData("grid");
		String msg = msra0010_service.doDeleteScreenManagement(gridData);

		resp.setResponseMessage(msg);
	}

	@RequestMapping(value = "/MSRA0011/view")
	public String MSRA0011(EverHttpRequest req) {
		/* 관리자 권한이 존재하지 않으면 접속 불가 */
		BaseInfo baseInfo = (BaseInfo)req.getSession().getAttribute("ses");
		if (baseInfo.getSuperUserFlag().equals("0")) {
			//return "/everqis/noSuperAuth";
		}
		return "/eversrm/manager/screen/MSRA0011";
	}

	@RequestMapping(value = "/screenIdPopup/doSearch")
	public void doSearchScreenIdPopup(EverHttpRequest req, EverHttpResponse resp) throws Exception {
		resp.setGridObject("grid", msra0010_service.doSearchScreenIdPopup(req.getFormData()));
	}

	@RequestMapping(value = "/MSRA0012/view")
	public String MSRA0012(EverHttpRequest req) throws Exception {

		String paramScreenId = EverString.nullToEmptyString(req.getParameter("PARAM_SCREEN_ID"));

		if (paramScreenId != null && !"".equals(paramScreenId)) {
			Map<String, String> formData = msra0010_service.selectHelpInfo(paramScreenId);
			String splitString = largeTextService.selectLargeText(formData.get("HELP_TEXT_NUM"));
			formData.put("CONTENTS", splitString);
			req.setAttribute("formData", formData);
		} else {
			req.setAttribute("formData", new HashMap<String, String>());
		}
		return "/eversrm/manager/screen/MSRA0012";
	}

	@RequestMapping(value = "/helpInfo/doSave")
	public void doSaveHelpInfo(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		Map<String, String> formData = req.getFormData();
		String msg = msra0010_service.doSaveHelpInfo(formData);

		resp.setResponseMessage(msg);
	}

	@RequestMapping(value = "/helpInfo/doDelete")
	public void doDeleteHelpInfo(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		Map<String, String> formData = req.getFormData();
		String msg = msra0010_service.doDeleteHelpInfo(formData);

		resp.setResponseMessage(msg);
	}

}