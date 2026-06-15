package com.st_ones.eversrm.manager.screen.web;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.st_ones.everf.serverside.info.BaseInfo;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.eversrm.manager.screen.service.MSRA0020_Service;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : MSRA0020_Controller.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

@Controller
@RequestMapping(value = "/eversrm/manager/screen")
public class MSRA0020_Controller extends BaseController {

	@Autowired private MSRA0020_Service msra0020_service;

	/**
	 * 화면명 : 화면액션관리
	 * 처리내용 : 시스템에서 사용되는 화면 안에 존재하는 버튼들을 관리하는 화면
	 * 경로 : 시스템관리 > 화면 > 화면액션관리
	 */
	@RequestMapping(value = "/MSRA0020/view")
	public String MSRA0020(EverHttpRequest req) {
		/* 관리자 권한이 존재하지 않으면 접속 불가 */
		BaseInfo baseInfo = (BaseInfo)req.getSession().getAttribute("ses");
		if (baseInfo.getSuperUserFlag().equals("0")) {
			//return "/eversrm/noSuperAuth";
		}
		return "/eversrm/manager/screen/MSRA0020";
	}

//	@RequestMapping(value = "/screenActionManagement/iconPopup/view")
//	public String iconPopup(EverHttpRequest req) throws Exception {
//		/* 관리자 권한이 존재하지 않으면 접속 불가 */
//		BaseInfo baseInfo = (BaseInfo)req.getSession().getAttribute("ses");
//		if (baseInfo.getSuperUserFlag().equals("0")) {
//			return "/everqis/noSuperAuth";
//		}
//		req.setAttribute("refModuleType", commonComboService.getCodeCombo("M009"));
//		return "/eversrm/system/screen/iconPopup";
//	}

	@RequestMapping(value = "/screenActionManagement/doSearch")
	public void doSearchScreenActionManagement(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		String tagGuide;
		Map<String, String> param = req.getFormData();

		List<Map<String, Object>> gridDatas = msra0020_service.doSearchScreenActionManagement(param);
		for (Map<String, Object> gridData : gridDatas) {
			tagGuide = "<e:button id=\"" + gridData.get("ACTION_CD") + "\" name=\"" + gridData.get("ACTION_CD") + "\" label=\"${" + gridData.get("ACTION_CD") + "_N}\""  + " onClick=\"" + gridData.get("ACTION_CD") + "\" disabled=\"${" + gridData.get("ACTION_CD") + "_D}\" visible=\"${"
					+ gridData.get("ACTION_CD") + "_V}\"/>";
			gridData.put("BUTTON_TAG", tagGuide);
		}
		resp.setGridObject("grid", gridDatas);
	}

	@RequestMapping(value = "/screenActionManagement/doSave")
	public void doSaveScreenActionManagement(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		List<Map<String, Object>> gridData = req.getGridData("grid");
		String msg = msra0020_service.doSaveScreenActionManagement(gridData);

		resp.setResponseMessage(msg);
	}

	@RequestMapping(value = "/screenActionManagement/doDelete")
	public void doDeleteScreenActionManagement(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		List<Map<String, Object>> gridData = req.getGridData("grid");
		String msg = msra0020_service.doDeleteScreenActionManagement(gridData);

		resp.setResponseMessage(msg);
	}

}