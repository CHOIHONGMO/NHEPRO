package com.st_ones.eversrm.manager.auth.web;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.st_ones.common.util.service.LargeTextService;
import com.st_ones.everf.serverside.info.BaseInfo;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.eversrm.manager.auth.service.MAUA0050_Service;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : MAUA0050Controller.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

@Controller
@RequestMapping(value = "/eversrm/manager/auth")
public class MAUA0050_Controller extends BaseController {

	@Autowired
	private MAUA0050_Service maua0050_service;

	@Autowired
	LargeTextService largeTextService;

	/**
	 * 화면명 : 부서-서식 Role 매핑
	 * 처리내용 : 부서에서 사용하는 서식 Role을 매핑/관리하는 화면.
	 * 경로 : 시스템관리 > 권한 > 부서-서식 Role 매핑
	 */
	@RequestMapping(value = "/MAUA0050/view")
	public String MAUA0050(EverHttpRequest req) {

		BaseInfo baseInfo = (BaseInfo)req.getSession().getAttribute("ses");
		if (baseInfo.getSuperUserFlag().equals("0") || ! baseInfo.getUserType().equals("B")) {
//			return "/eversrm/noSuperAuth";
		}
		return "/eversrm/manager/auth/MAUA0050";
	}

	@RequestMapping(value = "/MAUA0050/doSearch")
	public void bsya030_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
		Map<String, String> param = req.getFormData();
		resp.setGridObject("grid", maua0050_service.MAUA0050_doSearch(param));
	}

	@RequestMapping(value = "/MAUA0050/doSave")
	public void bsya030_doSave(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		List<Map<String, Object>> gridData = req.getGridData("grid");
		Map<String, String> formData = req.getFormData();
		String msg = maua0050_service.MAUA0050_doSave(gridData, formData);

		resp.setResponseMessage(msg);
	}

	@RequestMapping(value = "/MAUA0050/doDelete")
	public void bsya030_doDelete(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		List<Map<String, Object>> gridData = req.getGridData("grid");
		String msg = maua0050_service.MAUA0050_doDelete(gridData);

		resp.setResponseMessage(msg);
	}

}