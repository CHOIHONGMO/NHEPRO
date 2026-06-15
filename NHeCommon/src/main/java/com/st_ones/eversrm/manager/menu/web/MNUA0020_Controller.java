package com.st_ones.eversrm.manager.menu.web;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.st_ones.common.combo.service.CommonComboService;
import com.st_ones.everf.serverside.info.BaseInfo;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.eversrm.manager.menu.service.MNUA0020_Service;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : MNUA0020_Controller.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

@Controller
@RequestMapping(value = "/eversrm/manager/menu")
public class MNUA0020_Controller extends BaseController {

	@Autowired private CommonComboService commonComboService;

	@Autowired private MNUA0020_Service mnua0020_service;

	/**
	 * 화면명 : 메뉴그룹관리
	 * 처리내용 : 시스템에 등록된 메뉴템플릿들을 조합하여 사용자에게 부여 할 메뉴그룹을 관리하는 화면.
	 * 경로 : 시스템관리 > 메뉴 > 메뉴그룹관리
	 */
	@RequestMapping(value = "/MNUA0020/view")
	public String MNUA0020(EverHttpRequest req) throws Exception {

		/* 관리자 권한이 존재하지 않으면 접속 불가 */
		BaseInfo baseInfo = (BaseInfo)req.getSession().getAttribute("ses");
		if (baseInfo.getSuperUserFlag().equals("0") || ! baseInfo.getUserType().equals("B")) {
			//return "/eversrm/noSuperAuth";
		}
		return "/eversrm/manager/menu/MNUA0020";
	}

	@RequestMapping(value = "/MNUA0020/searchMenu")
	public void searchMenu(EverHttpRequest req, EverHttpResponse resp) throws Exception {
		resp.setGridObject("grid", mnua0020_service.searchMenu(req.getFormData()));
	}

	@RequestMapping(value = "/MNUA0020/doSaveMenu")
	public void doSaveMenu(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		List<Map<String, Object>> gridData = req.getGridData("grid");
		String msg = mnua0020_service.doSaveMenu(gridData);

		resp.setResponseMessage(msg);
	}

	@RequestMapping(value = "/MNUA0020/doCopyMenu")
	public void doCopyMenu(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		List<Map<String, Object>> gridData = req.getGridData("grid");
		String msg = mnua0020_service.doCopyMenu(gridData);

		resp.setResponseMessage(msg);
	}

	@RequestMapping(value = "/MNUA0020/deleteMenu")
	public void deleteMenu(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		List<Map<String, Object>> gridData = req.getGridData("grid");
		String msg = mnua0020_service.deleteMenu(gridData);

		resp.setResponseMessage(msg);
	}

}