package com.st_ones.nhepro.OSYR.web;

import com.st_ones.common.combo.service.CommonComboService;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.nhepro.OSYR.service.OSYR0010_Service;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

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
 * @File Name : OSYR0010_Controller.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

@Controller
@RequestMapping(value = "/nhepro/OSYR")
public class OSYR0010_Controller extends BaseController {

	@Autowired private CommonComboService commonComboService;

	@Autowired private OSYR0010_Service osyr0010_Service;

	/**
	 * 화면명 : 회사단위
	 * 처리내용 : 시스템에서 사용 할 회사 단위를 관리하는 화면.
	 * 경로 : 운영사 > 조직관리 > 조직관리 > 회사단위
	 */
	@RequestMapping(value = "/OSYR0010/view")
	public String osyr0010_view(EverHttpRequest req) {
		return "/nhepro/OSYR/OSYR0010";
	}

	@RequestMapping(value = "/osyr0010_selectCompany")
	public void osyr0010_selectCompany(EverHttpRequest req, EverHttpResponse resp) throws Exception {
		Map<String, String> param = req.getFormData();
		resp.setGridObject("grid", osyr0010_Service.osyr0010_selectCompany(param));
	}

	@RequestMapping(value = "/osyr0010_saveCompany")
	public void osyr0010_saveCompany(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		String msg = osyr0010_Service.osyr0010_saveCompany(req.getFormData());

		resp.setResponseMessage(msg);
	}

	@RequestMapping(value = "/osyr0010_deleteCompany")
	public void osyr0010_deleteCompany(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		String msg = osyr0010_Service.osyr0010_deleteCompany(req.getFormData());

		resp.setResponseMessage(msg);
	}

}