package com.st_ones.eversrm.master.user.web;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.common.util.clazz.EverDate;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.eversrm.master.user.service.MTUB0010_Service;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : MTUB0010_Controller.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

@Controller
@RequestMapping(value = "/eversrm/master/user")
public class MTUB0010_Controller extends BaseController {

	@Autowired private MTUB0010_Service mtub0010_Service;

	/**
	 * 화면명 : 사용자 작업이력
	 * 처리내용 : 시스템에 로그인한 사용자의 작업 이력을 조회하는 화면.
	 * 경로 : 시스템관리 > 사용자관리 > 사용자작업이력
	 */
	@RequestMapping(value = "/MTUB0010/view")
	public String MTUB0010(EverHttpRequest req) throws Exception {

		/* 관리자 권한이 존재하지 않으면 접속 불가 */
		if(!PropertiesManager.getBoolean("eversrm.system.developmentFlag")) {
			UserInfo baseInfo = (UserInfo) req.getSession().getAttribute("ses");
			if (!baseInfo.isSuperUser() || !baseInfo.isOperator()) {
				//return "/eversrm/noSuperAuth";
			}
		}
		req.setAttribute("fromDate", EverDate.getDate());
		req.setAttribute("toDate", EverDate.getDate());
		return "/eversrm/master/user/MTUB0010";
	}

	@RequestMapping(value = "/MTUB0010/doSearch")
	public void mtub0010_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
		resp.setGridObject("grid1", mtub0010_Service.mtub0010_doSearch(req.getFormData()));
	}

}