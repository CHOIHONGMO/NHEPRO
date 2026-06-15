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
import com.st_ones.eversrm.manager.auth.service.MAUA0030_Service;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : MAUA0030_Controller.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

@Controller
@RequestMapping(value = "/eversrm/manager/auth")
public class MAUA0030_Controller extends BaseController {

	@Autowired private CommonComboService commonComboService;

	@Autowired private LargeTextService largeTextService;

	@Autowired private MAUA0030_Service maua0030_service;

	/**
	 * 화면명 : 권한프로프알관리
	 * 처리내용 : 화면 접근권한을 등록/수정/삭제/조회할 수 있는 화면
	 * 경로 : 시스템관리 > 권한 > 권한프로파일관리
	 */
	@RequestMapping(value = "/MAUA0030/view")
	public String MAUA0030(EverHttpRequest req) throws Exception {

		/* 관리자 권한이 존재하지 않으면 접속 불가 */
		BaseInfo baseInfo = (BaseInfo)req.getSession().getAttribute("ses");
		if (baseInfo.getSuperUserFlag().equals("0")) {
			return "/everqis/noSuperAuth";
		}
		return "/eversrm/manager/auth/MAUA0030";
	}

	@RequestMapping(value = "/MAUA0030/doSearch")
	public void doSearchAuthProfileManagement(EverHttpRequest req, EverHttpResponse resp) throws Exception {
		resp.setGridObject("grid", maua0030_service.doSearchAuthProfileManagement(req.getFormData()));
	}

	@RequestMapping(value = "/MAUA0030/doSave")
	public void doSaveAuthProfileManagement(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		List<Map<String, Object>> gridData = req.getGridData("grid");
		String msg = maua0030_service.doSaveAuthProfileManagement(gridData);

		resp.setResponseMessage(msg);
	}

	@RequestMapping(value = "/MAUA0030/doDelete")
	public void doDeleteAuthProfileManagement(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		List<Map<String, Object>> gridData = req.getGridData("grid");
		String msg = maua0030_service.doDeleteAuthProfileManagement(gridData);

		resp.setResponseMessage(msg);
	}

}