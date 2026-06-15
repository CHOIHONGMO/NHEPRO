package com.st_ones.eversrm.manager.system.web;

import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.eversrm.manager.system.service.MSYB0020_Service;
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
 * @File Name : MSYB0020_Controller.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

@Controller
@RequestMapping(value = "/eversrm/manager/system")
public class MSYB0020_Controller extends BaseController {

	@Autowired private MSYB0020_Service msyb0020_Service;

	/**
	 * 화면명 : 우편번호 검색
	 * 처리내용 : daum 에서 관리하는 우편번호 검색 팝업
	 */
	@RequestMapping(value = "/MSYB0020/view")
	public String MSYB0020(EverHttpRequest req) throws Exception {

		req.setAttribute("sslFlag", PropertiesManager.getBoolean("ever.ssl.use.flag"));
		req.setAttribute("useDaumApi", PropertiesManager.getBoolean("zipCode.outApi.use.flag"));

		req.setAttribute("domainName", PropertiesManager.getString("eversrm.system.domainName"));
		if (PropertiesManager.getBoolean("zipCode.outApi.use.flag")) { // 외부 주소 API를 사용할 경우
			return "/eversrm/manager/system/MSYB0021";
		} else {
			return "/eversrm/manager/system/MSYB0020";
		}
	}

	@RequestMapping(value = "/MSYB0020/doSearchByStreet")
	public void msyb0020_doSearchByStreet(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		Map<String, String> param = req.getFormData();
		String conditionStreet = param.get("conditionStreet");

		List<Map<String, Object>> rtnList = null;
		if (conditionStreet.equals("1")) {
			rtnList = msyb0020_Service.doSearchByStreet1(param);
		} else if (conditionStreet.equals("2")) {
			rtnList = msyb0020_Service.doSearchByStreet2(param);
		} else if (conditionStreet.equals("3")) {
			rtnList = msyb0020_Service.doSearchByStreet3(param);
		}
		resp.setGridObject("gridStreet", rtnList);
	}

	@RequestMapping(value = "/MSYB0020/doSearchByDistrict")
	public void msyb0020_doSearchByDistrict(EverHttpRequest req, EverHttpResponse resp) throws Exception {
		resp.setGridObject("gridDistrict", msyb0020_Service.doSearchByDistrict(req.getFormData()));
	}

}