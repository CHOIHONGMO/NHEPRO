package com.st_ones.eversrm.manager.org.web;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.st_ones.common.combo.service.CommonComboService;
import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.eversrm.manager.org.service.MOGA0010_Service;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : MOGA0010Controller.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

@Controller
@RequestMapping(value = "/eversrm/manager/org")
public class MOGA0010_Controller extends BaseController {

	@Autowired private CommonComboService commonComboService;

	@Autowired private MOGA0010_Service moga0010_service;

	/**
	 * 화면명 : GATE 단위
	 * 처리내용 : 시스템에서 사용 할 Gate 단위를 관리하는 화면.
	 * 경로 : 시스템관리 > 조직관리 > GATE 단위
	 */
	@RequestMapping(value = "/MOGA0010/view")
	public String MOGA0010(EverHttpRequest req) throws Exception {

		UserInfo userInfo = UserInfoManager.getUserInfo();

		if (! userInfo.isSuperUser() || ! userInfo.getUserType().equals("B")) {
		    //return "/eversrm/noSuperAuth";
		}

        ObjectMapper om = new ObjectMapper();
		req.setAttribute("gmtCdList", om.writeValueAsString(commonComboService.getCodeCombo("M005")));
		return "/eversrm/manager/org/MOGA0010";
	}

	@RequestMapping(value = "/houseUnit/selectGate")
	public void selectGate(EverHttpRequest req, EverHttpResponse resp) throws Exception {
		Map<String, String> param = req.getFormData();
		resp.setGridObject("grid", moga0010_service.selectGate(param));
	}

	@RequestMapping(value = "/houseUnit/saveGate")
	public void saveGate(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		Map<String, String> formData = req.getFormData();
		String msg = moga0010_service.saveGate(formData);

		resp.setResponseMessage(msg);
	}

	@RequestMapping(value = "/houseUnit/deleteGate")
	public void deleteGate(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		Map<String, String> formData = req.getFormData();
		String msg = moga0010_service.deleteGate(formData);

		resp.setResponseMessage(msg);
	}

}