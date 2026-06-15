package com.st_ones.eversrm.manager.org.web;

import com.st_ones.common.util.clazz.EverConverter;
import com.st_ones.common.util.clazz.EverDate;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.eversrm.manager.org.service.MOGA0031_Service;

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
 * @File Name : MOGA0031Controller.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

@Controller
@RequestMapping(value = "/eversrm/manager/org")
public class MOGA0031_Controller extends BaseController {

	@Autowired private MOGA0031_Service moga0031_service;

	/**
	 * 화면명 : 조직관리 (Tree)
	 * 처리내용 : 조직(부서)을 조회/관리한다.
	 * 경로 : 시스템관리 > 조직관리 > 조직관리2 (Tree)
	 */
	@RequestMapping(value = "/MOGA0031/view")
	public String MOGA0031(EverHttpRequest req) throws Exception {
		req.setAttribute("yyyymm", EverDate.getShortDateString().substring(0, 6));
		return "/eversrm/manager/org/MOGA0031";
	}

	@RequestMapping(value = "/MOGA0031_doSelect_deptTree")
	public void MOGA0031_doSelect_deptTree(EverHttpRequest req, EverHttpResponse resp) throws Exception {
		List<Map<String,Object>> treeData = moga0031_service.MOGA0031_doSelect_deptTree(req.getFormData());
		resp.setParameter("treeData", EverConverter.getJsonString(treeData));
	}

	@RequestMapping(value="/MOGA0031_doSave_tree")
	public void MOGA0031_doSave_tree(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		Map<String, String> formData = req.getFormData();
		List<Map<String, Object>> grid = req.getGridData("grid");

		String msg = moga0031_service.MOGA0031_doSave_tree(formData, grid);
		resp.setResponseMessage(msg);
	}

}