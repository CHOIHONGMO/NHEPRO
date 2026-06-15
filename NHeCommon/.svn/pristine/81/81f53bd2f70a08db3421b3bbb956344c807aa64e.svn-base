package com.st_ones.eversrm.manager.basic.web;

import com.st_ones.common.combo.service.CommonComboService;
import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.common.util.clazz.EverDate;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.eversrm.manager.basic.service.BSN_Service;
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
 * @File Name : BSN_Controller.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

@Controller
@RequestMapping(value = "/eversrm/manager/basic")
public class BSN_Controller extends BaseController {

	@Autowired private CommonComboService commonComboService;

	@Autowired private BSN_Service BSN_Service;

	/**
	 * 화면명 : Mail/SMS 전송현황
	 * 처리내용 : Mail/SMS 전송 내역을 조회한다.
	 * 경로 : 시스템관리 > Mail/SMS > Mail/SMS 전송현황
	 */
	@RequestMapping(value = "/BSN_070/view")
	public String smsMessageSendingHistory(EverHttpRequest req) throws Exception {

		UserInfo userInfo = UserInfoManager.getUserInfo();
		if (! userInfo.isSuperUser() || ! userInfo.isOperator()) {
		    return "/eversrm/noSuperAuth";
		}

		req.setAttribute("fromDate", EverDate.addMonths(-1));
		req.setAttribute("toDate", EverDate.getDate());
		return "/eversrm/manager/basic/BSN_070";
	}

	@RequestMapping(value = "/BSN_070/doSearch")
	public void selectsmsMessageSendingHistory(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		Map<String, String> param = req.getFormData();
		resp.setGridObject("grid", BSN_Service.selectSmsMessageSendingHistory(param));
		resp.setResponseCode("true");
	}

	@RequestMapping(value = "/sendContentPopup/doSelectContent")
	public void doSelectContent(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		Map<String, String> paramMap = req.getFormData();
		String sendType = paramMap.get("sendType");

		if (sendType.equals("M")) {
			req.setAttribute("form", BSN_Service.getMessageInfo(paramMap));
			resp.setResponseCode("true");

		} else if (sendType.equals("S")) {

			req.setAttribute("form", BSN_Service.getSmsContent(paramMap));
			resp.setResponseCode("true");
		}
	}

	@RequestMapping(value = "/BSN_080/view")
	public String BSN_080(EverHttpRequest req) throws Exception {

		Map<String, String> paramMap = req.getFormData();
		String sendType = paramMap.get("sendType");
		String sendId = paramMap.get("sendId");
		if (sendType == null) {
			paramMap.put("sendType", req.getParameter("sendType"));
			sendType = req.getParameter("sendType");
		}
		if (sendId == null) {
			paramMap.put("sendId", req.getParameter("sendId"));
			sendId = req.getParameter("sendId");
		}

		if (sendType.equals("M")) {
			paramMap.put("recEmail", req.getParameter("recEmail"));
			paramMap.put("sendEmail", req.getParameter("sendEmail"));
			req.setAttribute("form", BSN_Service.getMessageInfo(paramMap));	///
		}
		else if (sendType.equals("S")) {
			req.setAttribute("form", BSN_Service.getSmsContent(paramMap));
		}
		return "/eversrm/manager/basic/BSN_080";
	}

	@RequestMapping(value = "/selectUserSearch")
	public void selectUserSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
		Map<String, String> param = req.getFormData();
		req.setAttribute("gridData", BSN_Service.selectUserSearch(param));
		resp.setResponseCode("true");
	}

}