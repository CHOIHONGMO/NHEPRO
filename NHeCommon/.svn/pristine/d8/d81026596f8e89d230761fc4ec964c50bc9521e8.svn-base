package com.st_ones.eversrm.manager.auth.web;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.st_ones.common.combo.service.CommonComboService;
import com.st_ones.common.util.service.LargeTextService;
import com.st_ones.everf.serverside.info.BaseInfo;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.eversrm.manager.auth.service.MAUA0040_Service;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : MAUA0040_Controller.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

@Controller
@RequestMapping(value = "/eversrm/manager/auth")
public class MAUA0040_Controller extends BaseController {

	@Autowired private CommonComboService commonComboService;

	@Autowired private LargeTextService largeTextService;

	@Autowired private MAUA0040_Service maua0040_service;

	/**
	 * 화면명 : 메뉴-권한 매핑
	 * 처리내용 : 시스템에 등록된 권한프로파일코드에 메뉴를 매핑하여 해당 권한을 가진 사용자에게 노출될 메뉴들을 정의하는 화면.
	 * 경로 : 시스템관리 > 권한 > 메뉴-권한 매핑
	 */
	@RequestMapping(value = "/MAUA0040/view")
	public String screenActionManagement(EverHttpRequest req) throws Exception {
		/* 관리자 권한이 존재하지 않으면 접속 불가 */
		BaseInfo baseInfo = (BaseInfo)req.getSession().getAttribute("ses");
		if (baseInfo.getSuperUserFlag().equals("0")) {
//			return "/eversrm/noSuperAuth";
		}
		return "/eversrm/manager/auth/MAUA0040";
	}

	@RequestMapping(value = "/MAUA0040/doSearchL")
	public void doSearchLMenuAuthMapping(EverHttpRequest req, EverHttpResponse resp) throws Exception {
		resp.setGridObject("gridL", maua0040_service.doSearchLMenuAuthMapping(req.getFormData()));
	}

	@RequestMapping(value = "/MAUA0040/doSearchR")
	public void doSearchRMenuAuthMapping(EverHttpRequest req, EverHttpResponse resp) throws Exception {
		resp.setGridObject("gridR", maua0040_service.doSearchRMenuAuthMapping(req.getFormData()));
	}

	@RequestMapping(value = "/MAUA0040/doSave")
	public void doSaveMenuAuthMapping(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		List<Map<String, Object>> gridLData = req.getGridData("gridL");
		String msg = maua0040_service.doSaveMenuAuthMapping(gridLData);

		resp.setResponseMessage(msg);
	}

	@RequestMapping(value = "/MAUA0040/doDelete")
	public void doDeleteMenuAuthMapping(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		List<Map<String, Object>> gridLData = req.getGridData("gridL");
		String msg = maua0040_service.doDeleteMenuAuthMapping(gridLData);

		resp.setResponseMessage(msg);
	}

}