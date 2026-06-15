package com.st_ones.eversrm.board.sms.web;

import com.st_ones.common.combo.service.CommonComboService;
import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.common.util.clazz.EverDate;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.common.util.service.LargeTextService;
import com.st_ones.everf.serverside.info.BaseInfo;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.eversrm.board.sms.service.BBOS_Service;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.HashMap;
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
 * @File Name : BBOS_Controller.java
 * @author  Yeon-moo, Lee (yeonmoo_lee@st-ones.com)
 * @date 2013. 07. 22.
 * @version 1.0
 * @see
 */

@Controller
@RequestMapping(value = "/eversrm/basic/message")
public class BBOS_Controller extends BaseController {

	@Autowired
	private CommonComboService commonComboService;

	@Autowired
	LargeTextService largeTextService;

	@Autowired
	private BBOS_Service bbos_Service;


	@RequestMapping(value = "/selectUserSearch")
	public void selectUserSearch(EverHttpRequest req, EverHttpResponse resp) {
		Map<String, String> param = req.getFormData();
		req.setAttribute("gridData", bbos_Service.selectUserSearch(param));
		resp.setResponseCode("true");
	}

	@RequestMapping(value = "/BSN_040/view")
	public String bsn040_view(EverHttpRequest req) {
		UserInfo userInfo = UserInfoManager.getUserInfo();

		req.setAttribute("defaultDate", EverDate.getYear() + "/" + EverDate.getMonth() + "/" + EverDate.getDay());

		return "/eversrm/basic/message/BSN_040";
	}
	
	@RequestMapping(value = "/BSN_040/doMailSmsSend")
	public void bsn040_doMailSmsSend(EverHttpRequest req, EverHttpResponse resp) throws Exception {
		List<Map<String, Object>> gridData = req.getGridData("gridMsg");
		
		Map<String, String> rtnMap = bbos_Service.doMailSmsSend(req.getFormData(), gridData);
		
		resp.setResponseMessage(rtnMap.get("rtnMsg"));
	}
	
}