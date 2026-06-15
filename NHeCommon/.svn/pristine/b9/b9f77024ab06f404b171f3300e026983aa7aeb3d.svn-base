package com.st_ones.eversrm.manager.basic.web;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.st_ones.everf.serverside.info.BaseInfo;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.eversrm.manager.basic.service.MBSA0020_Service;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : MBSA0020_Controller.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

@Controller
@RequestMapping(value = "/eversrm/manager/basic")
public class MBSA0020_Controller extends BaseController {

	@Autowired private MBSA0020_Service mbsa0020_service;

	/**
	 * 화면명 : 코드관리
	 * 처리내용 : 시스템에서 사용하는 공통코드를 관리하는 화면.
	 * 경로 : 시스템관리 > 기본정보 > 코드관리
	 */
	@RequestMapping(value = "/MBSA0020/view")
	public String MBSA0020(EverHttpRequest req) {

		/* 관리자 권한이 존재하지 않으면 접속 불가 */
		BaseInfo baseInfo = (BaseInfo)req.getSession().getAttribute("ses");
		if (baseInfo.getSuperUserFlag().equals("0") || ! baseInfo.getUserType().equals("B")) {
//			return "/eversrm/noSuperAuth";
		}
		return "/eversrm/manager/basic/MBSA0020";
	}

	@RequestMapping(value = "/doSearchHD")
	public void doSearchHD(EverHttpRequest req, EverHttpResponse resp) throws Exception {
		resp.setGridObject("gridHD", mbsa0020_service.doSearchHD(req.getFormData()));
	}

	@RequestMapping(value = "/doSaveHD")
	public void doSaveHD(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		List<Map<String, Object>> gridHDData = req.getGridData("gridHD");
		String msg = mbsa0020_service.doSaveHD(gridHDData);

		resp.setResponseMessage(msg);
	}

	@RequestMapping(value = "/doDeleteHD")
	public void doDeleteHD(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		List<Map<String, Object>> gridHDData = req.getGridData("gridHD");
		String msg = mbsa0020_service.doDeleteHD(gridHDData);

		resp.setResponseMessage(msg);
	}

	@RequestMapping(value = "/doSearchDT")
	public void doSearchDT(EverHttpRequest req, EverHttpResponse resp) throws Exception {
		resp.setGridObject("gridDT", mbsa0020_service.doSearchDT(req.getFormData()));
	}

	@RequestMapping(value = "/doSaveDT")
	public void doSaveDT(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		List<Map<String, Object>> gridDTData = req.getGridData("gridDT");
		String msg = mbsa0020_service.doSaveDT(gridDTData);

		resp.setResponseMessage(msg);
	}

	@RequestMapping(value = "/doDeleteDT")
	public void doDeleteDT(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		List<Map<String, Object>> gridDTData = req.getGridData("gridDT");
		String msg = mbsa0020_service.doDeleteDT(gridDTData);

		resp.setResponseMessage(msg);
	}

}