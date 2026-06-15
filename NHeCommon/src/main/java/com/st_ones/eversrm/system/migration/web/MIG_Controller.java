package com.st_ones.eversrm.system.migration.web;

import com.st_ones.common.combo.service.CommonComboService;
import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.eversrm.system.migration.service.MIG_Service;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

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
 * @File Name : MIG_Controller.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

@Controller
@RequestMapping(value = "/eversrm/system/migration")
public class MIG_Controller extends BaseController {

	@Autowired private MIG_Service mig_Service;

	/**
	 * 화면명 : Migration
	 * 처리내용 :
	 * 경로 : 시스템관리 > 시스템 > Migration
	 */
	@RequestMapping(value = "/MIG_010/view")
	public String MIG_010(EverHttpRequest req) throws Exception {
		/* 관리자 권한이 존재하지 않으면 접속 불가 */
		if(!PropertiesManager.getBoolean("eversrm.system.developmentFlag")) {
			UserInfo baseInfo = (UserInfo) req.getSession().getAttribute("ses");
			if (!baseInfo.isSuperUser() || !baseInfo.isOperator()) {
				return "/eversrm/noSuperAuth";
			}
		}

		return "/eversrm/system/migration/MIG_010";
	}

	@RequestMapping(value = "/mig010_doSearch")
	public void mig010_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
		Map<String, String> formData = req.getFormData();
		resp.setGridObject("grid", mig_Service.mig010_doSearch(formData));
	}

	@RequestMapping(value = "/mig010_doSave")
	public void mig010_doSave(EverHttpRequest req, EverHttpResponse resp) throws Exception {
		List<Map<String, Object>> gridDatas = req.getGridData("grid");

		String returnMsg = mig_Service.mig010_doSave(gridDatas);
		resp.setResponseMessage(returnMsg);
	}

}