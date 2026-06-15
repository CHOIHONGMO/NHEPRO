package com.st_ones.eversrm.manager.org.web;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.st_ones.common.util.clazz.EverConverter;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.eversrm.manager.org.service.MOGA0032_Service;
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
 * @File Name : MOGA0032Controller.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

@Controller
@RequestMapping(value = "/eversrm/manager/org/MOGA0032")
public class MOGA0032_Controller extends BaseController {

	@Autowired private MOGA0032_Service MOGA0032service;

	/**
	 * 화면명 : 팀검색
	 * 처리내용 : 시스템에 등록된 팀(부서)를 조회하는 팝업 화면.
	 * 경로 : 팝업
	 */
	@RequestMapping(value="/view")
	public String MOGA0032(EverHttpRequest req) throws Exception {

		Map<String, String> formTree = req.getFormData();
		List<Map<String, Object>> list = MOGA0032service.MOGA0032_doSelect_deptTree(formTree);
		req.setAttribute("treeData", new ObjectMapper().writeValueAsString(list));

		return "/eversrm/manager/org/MOGA0032";
	}

	@RequestMapping(value = "/MOGA0032_doSearch")
	public void MOGA0032_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
		Map<String, String> formTree = req.getFormData();
		List<Map<String,Object>> treeData = MOGA0032service.MOGA0032_doSelect_deptTree(formTree);
		resp.setParameter("treeData", EverConverter.getJsonString(treeData));
	}

}