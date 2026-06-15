package com.st_ones.eversrm.manager.basic.web;

import com.st_ones.everf.serverside.info.BaseInfo;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.eversrm.manager.basic.service.MBSA0010_Service;
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
 * @File Name : MBSA0010_Controller.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

@Controller
@RequestMapping(value = "/eversrm/manager/basic")
public class MBSA0010_Controller extends BaseController {

	@Autowired private MBSA0010_Service mbsa0010_service;

	/**
	 * 화면명 : 문서번호
	 * 처리내용 : 시스템에서 사용 할 문서번호의 채번룰을 관리하는 화면.
	 * 경로 : 시스템관리 > 기본정보 > 문서번호
	 */
	@RequestMapping(value = "/MBSA0010/view")
	public String MBSA0010(EverHttpRequest req) {

		/* 관리자 권한이 존재하지 않으면 접속 불가 */
		BaseInfo baseInfo = (BaseInfo)req.getSession().getAttribute("ses");
		if (baseInfo.getSuperUserFlag().equals("0") || ! baseInfo.getUserType().equals("B")) {
//			return "/eversrm/noSuperAuth";
		}
		return "/eversrm/manager/basic/MBSA0010";
	}

	@RequestMapping(value = "/doSearch")
	public void doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		String subGridID = "";
		String gridID = "";

		if( !"".equals(subGridID) ) { gridID = subGridID; } else { gridID = "grid"; }

		Map<String, String> param = req.getFormData();
		resp.setGridObject(gridID, mbsa0010_service.doSearch(param));
	}

	@RequestMapping(value = "/doSave")
	public void doSave(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		List<Map<String, Object>> gridData = req.getGridData("grid");
		String msg = mbsa0010_service.doSave(gridData);

		resp.setResponseMessage(msg);
	}

	@RequestMapping(value = "/doDelete")
	public void doDelete(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		List<Map<String, Object>> gridData = req.getGridData("grid");
		String msg = mbsa0010_service.doDelete(gridData);

		resp.setResponseMessage(msg);
	}

	@RequestMapping(value = "/doTest")
	public void doTest(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		List<Map<String, Object>> gridData = req.getGridData("grid");
		String newNum = mbsa0010_service.doTest(gridData);

		resp.setParameter("newNum", newNum);
	}

}