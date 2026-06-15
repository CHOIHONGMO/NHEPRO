package com.st_ones.eversrm.manager.system.web;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.st_ones.common.combo.service.CommonComboService;
import com.st_ones.everf.serverside.info.BaseInfo;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.eversrm.manager.system.service.MSYA0010_Service;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : MSYA0010_Controller.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

@Controller
@RequestMapping(value = "/eversrm/manager/system")
public class MSYA0010_Controller extends BaseController {

	@Autowired private CommonComboService commonComboService;

	@Autowired private MSYA0010_Service msya0010_Service;

	/**
	 * 화면명 : 공통팝업현황
	 * 처리내용 : 시스템에 등록된 공통팝업(싱글/멀티), 콤보박스들을 조회하는 화면
	 * 경로 : 시스템관리 > 시스템 > 공통팝업현황
	 */
	@RequestMapping(value = "/MSYA0010/view")
	public String MSYA0010(EverHttpRequest req) throws Exception {

		/* 관리자 권한이 존재하지 않으면 접속 불가 */
		BaseInfo baseInfo = (BaseInfo)req.getSession().getAttribute("ses");
		if (baseInfo.getSuperUserFlag().equals("0") || ! baseInfo.getUserType().equals("B")) {
			//return "/eversrm/noSuperAuth";
		}
		return "/eversrm/manager/system/MSYA0010";
	}

	@RequestMapping(value = "/MSYA0010/doSearch")
	public void msya0010_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
	    resp.setGridObject("grid1", msya0010_Service.doSearch(req.getFormData()));
	}

}
