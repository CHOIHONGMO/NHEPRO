package com.st_ones.eversrm.manager.basic.web;

import com.st_ones.common.util.clazz.EverDate;
import com.st_ones.everf.serverside.info.BaseInfo;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.eversrm.manager.basic.service.MBSA0040_Service;
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
 * @File Name : MBSA0040_Controller.java
 * @date 2020. 03. 12.
 * @version 1.0
 */

@Controller
@RequestMapping(value = "/eversrm/manager/basic")
public class MBSA0040_Controller extends BaseController {

	@Autowired private MBSA0040_Service mbsa0040_Service;

	/**
	 * 화면명 : 첨부파일 템플릿 관리
	 * 처리내용 : 업무화면에서 사용하는 첨부파일들의 항목들을 템플릿으로 관리하는 화면.
	 * 경로 : 시스템관리 > 기본정보 > 첨부파일 템플릿 관리
	 */
	@RequestMapping(value = "/MBSA0040/view")
	public String mbsa0040_view(EverHttpRequest req) {
		req.setAttribute("regFromDate", EverDate.addDateMonth(EverDate.getDate(), -12));
		req.setAttribute("regToDate", EverDate.addDateMonth(EverDate.getDate(), 0));
		return "/eversrm/manager/basic/MBSA0040";
	}

	@RequestMapping(value = "/mbsa0040_doSearchHD")
	public void mbsa0040_doSearchHD(EverHttpRequest req, EverHttpResponse resp) throws Exception {
		resp.setGridObject("gridHD", mbsa0040_Service.mbsa0040_doSearchHD(req.getFormData()));
	}

    @RequestMapping(value = "/mbsa0040_doSearchDT")
    public void mbsa0040_doSearchDT(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.setGridObject("gridDT", mbsa0040_Service.mbsa0040_doSearchDT(req.getFormData()));
    }

    @RequestMapping(value = "/mbsa0040_doSaveHD")
    public void mbsa0040_doSaveHD(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        List<Map<String, Object>> gridHDData = req.getGridData("gridHD");
        String msg = mbsa0040_Service.mbsa0040_doSaveHD(gridHDData);

        resp.setResponseMessage(msg);
    }

	@RequestMapping(value = "/mbsa0040_doDeleteHD")
	public void mbsa0040_doDeleteHD(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		List<Map<String, Object>> gridHDData = req.getGridData("gridHD");
		String msg = mbsa0040_Service.mbsa0040_doDeleteHD(gridHDData);

		resp.setResponseMessage(msg);
	}

	@RequestMapping(value = "/mbsa0040_doSaveDT")
	public void mbsa0040_doSaveDT(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		List<Map<String, Object>> gridDTData = req.getGridData("gridDT");
		String msg = mbsa0040_Service.mbsa0040_doSaveDT(gridDTData);

		resp.setResponseMessage(msg);
	}

	@RequestMapping(value = "/mbsa0040_doDeleteDT")
	public void mbsa0040_doDeleteDT(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		List<Map<String, Object>> gridDTData = req.getGridData("gridDT");
		String msg = mbsa0040_Service.mbsa0040_doDeleteDT(gridDTData);

		resp.setResponseMessage(msg);
	}

}