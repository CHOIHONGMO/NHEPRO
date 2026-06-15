package com.st_ones.eversrm.manager.org.web;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.st_ones.common.combo.service.CommonComboService;
import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.eversrm.manager.org.service.MOGA0020_Service;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : MOGA0020_Controller.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

@Controller
@RequestMapping(value = "/eversrm/manager/org")
public class MOGA0020_Controller extends BaseController {

	@Autowired private CommonComboService commonComboService;

	@Autowired private MOGA0020_Service moga0020_service;

	/**
	 * 화면명 : 회사단위
	 * 처리내용 : 시스템에서 사용 할 회사 단위를 관리하는 화면.
	 * 경로 : 시스템관리 > 조직관리 > 회사단위
	 */
	@RequestMapping(value = "/MOGA0020/view")
	public String MOGA0020(EverHttpRequest req) {

		UserInfo userInfo = UserInfoManager.getUserInfo();

		if (! userInfo.isSuperUser() || ! userInfo.getUserType().equals("B")) {
		    //return "/eversrm/noSuperAuth";
		}
		return "/eversrm/manager/org/MOGA0020";
	}

	@RequestMapping(value = "/companyUnit/selectCompany")
	public void doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
		resp.setGridObject("grid", moga0020_service.selectCompany(req.getFormData()));
	}

	@RequestMapping(value = "/companyUnit/saveCompany")
	public void saveCompany(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		Map<String, String> formData = req.getFormData();
		String msg = moga0020_service.saveCompany(formData);

		resp.setResponseMessage(msg);
	}

	@RequestMapping(value = "/companyUnit/deleteCompany")
	public void deleteCompany(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		Map<String, String> formData = req.getFormData();
		String msg = moga0020_service.deleteCompany(formData);

		resp.setResponseMessage(msg);
	}

}