package com.st_ones.eversrm.master.user.web;

import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.common.util.clazz.EverDate;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.eversrm.master.user.service.MTUB0040_Service;
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
 * @File Name : MTUB0040_Controller.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

@Controller
@RequestMapping(value = "/eversrm/master/user")
public class MTUB0040_Controller extends BaseController {

	@Autowired private MTUB0040_Service mtub0040_Service;

	/**
	 * 화면명 : 엑셀다운로드이력
	 * 처리내용 : 그리드상의 엑셀다운로드 이력을 조회하는 화면.
	 * 경로 : 시스템관리 > 사용자관리 > 엑셀다운로드이력
	 */
	@RequestMapping(value = "/MTUB0040/view")
	public String MTUB0040(EverHttpRequest req) {

		/* 관리자 권한이 존재하지 않으면 접속 불가 */
		if(!PropertiesManager.getBoolean("eversrm.system.developmentFlag")) {
			UserInfo baseInfo = (UserInfo) req.getSession().getAttribute("ses");
			if (!baseInfo.isSuperUser() || !baseInfo.isOperator()) {
				//return "/eversrm/noSuperAuth";
			}
		}
		req.setAttribute("fromDate", EverDate.getDate());
		req.setAttribute("toDate", EverDate.getDate());
		return "/eversrm/master/user/MTUB0040";
	}

	@RequestMapping(value = "/mtub0040_doSearch")
	public void mtub0040_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
		resp.setGridObject("grid", mtub0040_Service.mtub0040_doSearch(req.getFormData()));
	}

}