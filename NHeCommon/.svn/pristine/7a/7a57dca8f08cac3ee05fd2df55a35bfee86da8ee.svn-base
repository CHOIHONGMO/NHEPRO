package com.st_ones.common.menu.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.st_ones.common.menu.service.MenuService;
import com.st_ones.everf.serverside.util.EverString;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : MenuController.java
 * @date 2013. 07. 22.
 * @version 1.0
 * @see
 */
@Controller
@RequestMapping(value = "/common/menu")
public class MenuController extends BaseController {

	@Autowired private MenuService menuService;

	@RequestMapping(value = "/getScreenInfo")
	public void getScreenInfo(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		Map<String, String> params = req.getFormData();
		params.put("SCREEN_ID", req.getParameter("SCREEN_ID"));

		List<Map<String, Object>> data = menuService.getScreenInfo(params);
		String screen_id = "";
		if (data.size() != 0) {
			screen_id = (String) data.get(0).get("SCREEN_URL");
		} else {
			screen_id = "NOTFOUNDSCRRENID";
		}

		resp.setParameter("SCREEN_URL", screen_id);
		resp.setParameter("screenInfo", new ObjectMapper().writeValueAsString(data));
	}

	@RequestMapping(value = "/getScreenInfo2")
	public void getScreenInfo2(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		Map<String, String> params = req.getFormData();
		params.put("tmpl_menu_cd", req.getParameter("tmpl_menu_cd"));

		List<Map<String, Object>> data = menuService.getScreenInfo2(params);

		ObjectMapper om = new ObjectMapper();
		resp.setParameter("SCREENINFO", om.writeValueAsString(data));
	}

	@RequestMapping(value = "/getLeftMenu")
	public void getLeftMenu(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		Map<String, String> params = req.getFormData();
		params.put("moduleType", req.getParameter("moduleType"));
		params.put("menuType", req.getParameter("menuType"));
		params.put("SSL_FLAG", "false");

		List<Map<String, Object>> dataList = menuService.getLeftMenu(params);
		
		/**
		 * 2021.04.28 추가
		 * 로그인한 사용자 직무의 권한이 있는 중메뉴 출력
		 */
		List<Map<String, Object>> trueDataList = new ArrayList<Map<String, Object>>();
		for( Map<String, Object> idata : dataList ) {
			Map<String, Object> trueData = new HashMap<String, Object>();
			
			if( "Y".equals(idata.get("screenAccessAuth")) ) {
				trueData.putAll(idata);
			} else {
				for( Map<String, Object> jdata : dataList ) {
					if( EverString.nullToEmptyString(jdata.get("parentId")).equals(idata.get("id")) && "Y".equals(jdata.get("screenAccessAuth")) ) {
						trueData.putAll(idata);
						break;
					}
				}
			}
			if( trueData.size() > 0 ) {
				trueDataList.add(trueData);
			}
		}
		
		ObjectMapper om = new ObjectMapper();
		resp.setParameter("treeRawData", om.writeValueAsString(trueDataList));
		resp.setResponseCode("true");
	}

	@RequestMapping(value = "/setBookmark")
	public void setBookmark(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		menuService.setBookmark(req.getParameter("templateMenuCd"), req.getParameter("bookmarkMode"));
		resp.setContentType("application/json");
		resp.getWriter().write("{}");
	}
}

