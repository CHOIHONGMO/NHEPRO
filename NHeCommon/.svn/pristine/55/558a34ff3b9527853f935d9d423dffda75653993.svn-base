package com.st_ones.eversrm.manager.menu.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.st_ones.common.combo.service.CommonComboService;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.everf.serverside.info.BaseInfo;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.eversrm.manager.menu.service.MNUA0010_Service;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : MNUA0010_Controller.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

@Controller
@RequestMapping(value = "/eversrm/manager/menu")
public class MNUA0010_Controller extends BaseController {

	@Autowired private CommonComboService commonComboService;

	@Autowired private MNUA0010_Service mnua0010_service;

	/**
	 * 화면명 : 메뉴템플릿관리
	 * 처리내용 : 시스템에서 사용 할 메뉴들을 조합하여 템플릿을 관리하는 화면.
	 * 경로 : 시스템관리 > 메뉴 > 메뉴템플릿관리
	 */
	@RequestMapping(value = "/MNUA0010/view")
	public String MNUA0010(EverHttpRequest req) throws Exception {

		/* 관리자 권한이 존재하지 않으면 접속 불가 */
		BaseInfo baseInfo = (BaseInfo)req.getSession().getAttribute("ses");
		if (baseInfo.getSuperUserFlag().equals("0") || ! baseInfo.getUserType().equals("B")) {
			////return "/eversrm/noSuperAuth";
		}
		return "/eversrm/manager/menu/MNUA0010";
	}

	@RequestMapping(value = "/MNUA0010/doSelectMenuTemplate")
	public void doSelectMenuTemplate(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		Map<String, String> param = req.getFormData();
		List<Map<String, Object>> gridDatas = mnua0010_service.getMenuTemplates(param);

		resp.setGridObject("grid", gridDatas);
	}

	@RequestMapping(value = "/MNUA0010/doSaveMenuTemplate")
	public void doSaveMenuTemplate(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		List<Map<String, Object>> gridData = req.getGridData("grid");
		String msg = mnua0010_service.doSaveMenuTemplateMgmt(gridData);

		resp.setResponseMessage(msg);
	}

	@RequestMapping(value = "/MNUA0010/doCopyMenuTemplate")
	public void doCopyMenuTemplate(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		List<Map<String, Object>> gridData = req.getGridData("grid");
		String msg = mnua0010_service.doCopyMenuTemplateMgmt(gridData);

		resp.setResponseMessage(msg);
	}

	@RequestMapping(value = "/MNUA0010/doDeleteMenuTemplate")
	public void doDeleteMenuTemplate(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		List<Map<String, Object>> gridData = req.getGridData("grid");
		String msg = mnua0010_service.doDeleteMenuTemplateMgmt(gridData);

		resp.setResponseMessage(msg);
	}

	@RequestMapping(value = "/MNUA0011/view")
	public String MNUA0011(EverHttpRequest req) throws Exception {

		/* 관리자 권한이 존재하지 않으면 접속 불가 */
		BaseInfo baseInfo = (BaseInfo)req.getSession().getAttribute("ses");
		if (baseInfo.getSuperUserFlag().equals("0") || ! baseInfo.getUserType().equals("B")) {
			//return "/eversrm/noSuperAuth";
		}
		return "/eversrm/manager/menu/MNUA0011";
	}

	@RequestMapping(value = "/MNUA0012/view")
	public String MNUA0012(EverHttpRequest req) throws Exception {

		/* 관리자 권한이 존재하지 않으면 접속 불가 */
		BaseInfo baseInfo = (BaseInfo)req.getSession().getAttribute("ses");
		if (baseInfo.getSuperUserFlag().equals("0") || ! baseInfo.getUserType().equals("B")) {
			//return "/eversrm/noSuperAuth";
		}
		return "/eversrm/manager/menu/MNUA0012";
	}

	@RequestMapping(value = "/MNUA0012/listMenuTemplateTree")
	public void listMenuTemplateTree(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		ObjectMapper om = new ObjectMapper();

		Map<String, String> param = req.getFormData();
		param.put("TMPL_MENU_GROUP_CD", req.getParameter("TMPL_MENU_GROUP_CD"));
		param.put("MODULE_TYPE", req.getParameter("MODULE_TYPE"));
		param.put("TMPL_MENU_CD", null);

		// 1Level의 데이터를 가져온다.
		List<Map<String, Object>> listOfLevel1 = mnua0010_service.getMenuTemplateTree(param);
		listOfLevel1 = addChilds(listOfLevel1, param, "BSYM_020");

		resp.setParameter("treeData", om.writeValueAsString(listOfLevel1));
		resp.setResponseMessage("Success");
	}

	@RequestMapping(value = "/MNUA0012/listMenuTemplateDtree")
	public void listMenuTemplateDtree(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		ObjectMapper om = new ObjectMapper();

		Map<String, String> param = req.getFormData();
		param.put("TMPL_MENU_GROUP_CD", req.getParameter("TMPL_MENU_GROUP_CD"));
		param.put("MODULE_TYPE", req.getParameter("MODULE_TYPE"));
		param.put("TMPL_MENU_CD", null);

		List<Map<String, Object>> treeData = mnua0010_service.getMenuTemplateDtree(param);

		resp.setParameter("treeData", om.writeValueAsString(treeData));
		resp.setResponseMessage("Success");
	}

	@RequestMapping(value = "/MNUA0012/searchMenuTemplateTreeNode")
	public void searchMenuTemplateTreeNode(EverHttpRequest req, EverHttpResponse resp) {

		Map<String, String> param = req.getFormData();
		Map<String, Object> result = mnua0010_service.searchMenuTemplateTreeNode(param);

		Map<String, String> saveParam = new HashMap<String, String>();
		saveParam.putAll(param);

		Iterator<String> iterator = saveParam.keySet().iterator();
		while (iterator.hasNext()) {
			String key = iterator.next();
			if (!result.containsKey(key)) {
				result.put(key, "");
			}
		}
		req.setAttribute("searchParam", result);
	}

	@RequestMapping(value = "/MNUA0012/doSearchStocmuba")
	public void searchStocmuba(EverHttpRequest req, EverHttpResponse resp) throws Exception {
		Map<String, String> param = req.getFormData();
		resp.setGridObject("grid", mnua0010_service.selectStocmuba(param));
	}

	@RequestMapping(value = "/MNUA0012/createMenuTemplateTree")
	public void createMenuTemplateTree(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		Map<String, String> param = req.getFormData();
		List<Map<String, Object>> gridData = req.getGridData("grid");

		if (!String.valueOf(param.get("DEPTH")).equals("0")) {
			param.put("HIGH_TMPL_MENU_CD", param.get("TMPL_MENU_CD"));
		}

		String tmplMenuCd = mnua0010_service.getMenuTmplCode(param);
		param.put("TMPL_MENU_CD", tmplMenuCd);
		int rowCount = mnua0010_service.existsMenuTemplateDetail(param);

		if (rowCount == 0) {
			param.put("DEPTH", "1");
			param.put("SORT_SQ", "1");
		} else {
			if (param.get("SORT_SQ").equals("0")) {
				param.put("SORT_SQ", param.get("HIDDEN_SORT_SQ"));
				mnua0010_service.updateSortSeqPlusOne(param);
			} else {
				param.put("SORT_SQ", Integer.toString(Integer.parseInt(param.get("HIDDEN_SORT_SQ")) + 1));
				mnua0010_service.updateSortSeqPlusOne(param);
			}
		}

		String msg = mnua0010_service.createMenuTemplateDetail(param, gridData);

		resp.setParameter("tmplMenuCd", tmplMenuCd);
		resp.setResponseMessage(msg);
	}

	@RequestMapping(value = "/MNUA0012/updateMenuTemplateDetail")
	public void updateMenuTemplateDetail(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		Map<String, String> param = req.getFormData();
		List<Map<String, Object>> gridData = req.getGridData("grid");
		String tmplMenuCode = param.get("TMPL_MENU_CD");
		String msg = mnua0010_service.updateMenuTemplateDetail(param, gridData);

		resp.setParameter("tmplMenuCd", tmplMenuCode);
		resp.setResponseMessage(msg);
	}

	@RequestMapping(value = "/MNUA0012/deleteMenuTemplateDetail")
	public void deleteMenuTemplateDetail(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		Map<String, String> searchParam = req.getFormData();
		String msg = mnua0010_service.deleteMenuTemplateDetail(searchParam);

		resp.setResponseMessage(msg);
	}

	@RequestMapping(value = "/BSYM_040/view")
	public String BSYM_040(EverHttpRequest req) throws Exception {
		/* 관리자 권한이 존재하지 않으면 접속 불가 */
		BaseInfo baseInfo = (BaseInfo)req.getSession().getAttribute("ses");
		if (baseInfo.getSuperUserFlag().equals("0") || ! baseInfo.getUserType().equals("B")) {
			//return "/eversrm/noSuperAuth";
		}
		return "/eversrm/system/menu/BSYM_040";
	}

	@RequestMapping(value = "/MNUA0015/view")
	public String MNUA0015(EverHttpRequest req) throws Exception {

		/* 관리자 권한이 존재하지 않으면 접속 불가 */
		BaseInfo baseInfo = (BaseInfo)req.getSession().getAttribute("ses");
		if (baseInfo.getSuperUserFlag().equals("0") || ! baseInfo.getUserType().equals("B")) {
			//return "/eversrm/noSuperAuth";
		}
		return "/eversrm/manager/menu/MNUA0015";
	}

	@RequestMapping(value = "/MNUA0015/loadTree")
	public void loadTree(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		ObjectMapper om = new ObjectMapper();

		Map<String, String> param = req.getFormData();
		param.put("MENU_GROUP_CD", req.getParameter("MENU_GROUP_CD"));
		param.put("TMPL_MENU_GROUP_CD", req.getParameter("TMPL_MENU_GROUP_CD"));
		param.put("MODULE_TYPE", req.getParameter("MODULE_TYPE"));

		List<Map<String, Object>> mapMenuTemplateTree = mnua0010_service.getMenuTemplateTreePopup(param);
		mapMenuTemplateTree = addChilds(mapMenuTemplateTree, param, "BSYM_040R");

		List<Map<String, Object>> mapMenuTree = mnua0010_service.getMenuTree(param);
		mapMenuTree = addChilds(mapMenuTree, param, "BSYM_040L");

		resp.setParameter("treeData", om.writeValueAsString(mapMenuTemplateTree));
		resp.setParameter("mumsData", om.writeValueAsString(mapMenuTree));
		resp.setGridObject("grid", new ArrayList<Map<String, Object>>());
		resp.setResponseMessage("Success");
	}

	@RequestMapping(value = "/MNUA0015/loadDtree")
	public void loadDtree(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		ObjectMapper om = new ObjectMapper();

		Map<String, String> param = req.getFormData();
		param.put("MENU_GROUP_CD", req.getParameter("MENU_GROUP_CD"));
		param.put("TMPL_MENU_GROUP_CD", req.getParameter("TMPL_MENU_GROUP_CD"));
		param.put("MODULE_TYPE", req.getParameter("MODULE_TYPE"));

		List<Map<String, Object>> mapMenuTemplateDtree = mnua0010_service.getMenuTemplateDtreePopup(param);
//		mapMenuTemplateTree = addChilds(mapMenuTemplateTree, param, "BSYM_040R");

		List<Map<String, Object>> mapMenuDtree = mnua0010_service.getMenuDtree(param);
//		mapMenuDtree = addChilds(mapMenuDtree, param, "BSYM_040L");

		resp.setParameter("treeData", om.writeValueAsString(mapMenuTemplateDtree)); // RIGHT
		resp.setParameter("mumsData", om.writeValueAsString(mapMenuDtree)); // LEFT
		resp.setGridObject("grid", new ArrayList<Map<String, Object>>());
		resp.setResponseMessage("Success");
	}

	@RequestMapping(value = "/MNUA0015/doSaveMenuGroupCode")
	public void doSaveMenuGroupCode(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		BaseInfo baseInfo = UserInfoManager.getUserInfoImpl();

		@SuppressWarnings("unchecked")
		List<Map<String, Object>> tLists = new ObjectMapper().readValue(req.getParameter("treeData"), List.class);
		List<Map<String, Object>> gridData = req.getGridData("grid");

		Map<String, String> param = new HashMap<String, String>();
		param.put("GATE_CD", baseInfo.getGateCd());
		param.put("MENU_GROUP_CD", req.getParameter("MENU_GROUP_CD"));
		param.put("MODULE_TYPE", req.getParameter("MODULE_TYPE"));

		String msg = mnua0010_service.doSaveMenuGroupCode((tLists.size() > 0 ? tLists : gridData), param);

		resp.setParameter("retVal", "OK");
		resp.setResponseMessage(msg);
	}

	@RequestMapping(value = "/MNUA0016/view")
	public String MNUA0016(EverHttpRequest req) throws Exception {

		/* 관리자 권한이 존재하지 않으면 접속 불가 */
		BaseInfo baseInfo = (BaseInfo)req.getSession().getAttribute("ses");
		if (baseInfo.getSuperUserFlag().equals("0") || ! baseInfo.getUserType().equals("B")) {
			//return "/eversrm/noSuperAuth";
		}
		return "/eversrm/manager/menu/MNUA0016";
	}

	@RequestMapping(value = "/MNUA0016/doSelect")
	public void doSelect(EverHttpRequest req, EverHttpResponse resp) throws Exception {
		resp.setGridObject("grid", mnua0010_service.getMenuTemplates(req.getFormData()));
	}

	private List<Map<String, Object>> addChilds(List<Map<String, Object>> listOfLevel1, Map<String, String> searchParam, String type) throws Exception {

		ObjectMapper om = new ObjectMapper();

		for(int i = 0; i < listOfLevel1.size(); i++) {

			Map<String, Object> valudOfLevel1 = listOfLevel1.get(i);

			// 1Level의 데이터 중 isFolder가 true인 것은 2Level 데이터를 가져온다.
			if(EverString.nullToEmptyString(valudOfLevel1.get("isFolder")).equals("true")) {

				Map<String, String> paramOfLevel2 = new HashMap<String, String>();

				if(EverString.nullToEmptyString(type).equals("BSYM_020"))
				{
					paramOfLevel2.put("TMPL_MENU_GROUP_CD", searchParam.get("TMPL_MENU_GROUP_CD"));
					paramOfLevel2.put("MODULE_TYPE", searchParam.get("MODULE_TYPE"));
					paramOfLevel2.put("TMPL_MENU_CD", (String) valudOfLevel1.get("key"));
				}
				else if(EverString.nullToEmptyString(type).equals("BSYM_040R") || EverString.nullToEmptyString(type).equals("BSYM_040L")) {
					paramOfLevel2.put("TMPL_MENU_GROUP_CD", searchParam.get("TMPL_MENU_GROUP_CD"));
					paramOfLevel2.put("MENU_GROUP_CD", searchParam.get("MENU_GROUP_CD"));
					paramOfLevel2.put("MODULE_TYPE", searchParam.get("MODULE_TYPE"));
					paramOfLevel2.put("TMPL_MENU_CD", (String) valudOfLevel1.get("key"));
				}

				List<Map<String, Object>> listOfLevel2 = null;
				if(EverString.nullToEmptyString(type).equals("BSYM_020")) {
					listOfLevel2 = mnua0010_service.getMenuTemplateTree(paramOfLevel2);
				}
				else if(EverString.nullToEmptyString(type).equals("BSYM_040R")) {
					listOfLevel2 = mnua0010_service.getMenuTemplateTreePopup(paramOfLevel2);
				}
				else if(EverString.nullToEmptyString(type).equals("BSYM_040L")) {
					listOfLevel2 = mnua0010_service.getMenuTree(paramOfLevel2);
				}

				if(listOfLevel2.size() > 0) {

					for(int j = 0; j < listOfLevel2.size(); j++) {

						Map<String, Object> valudOfLevel2 = listOfLevel2.get(j);

						// 2Level 데이터 중 isFolder가 true인 것은 3Level 데이터를 가져온다.
						if(EverString.nullToEmptyString(valudOfLevel2.get("isFolder")).equals("true")) {

							Map<String, String> paramOfLevel3 = new HashMap<String, String>();

							if(EverString.nullToEmptyString(type).equals("BSYM_020")) {
								paramOfLevel3.put("TMPL_MENU_GROUP_CD", searchParam.get("TMPL_MENU_GROUP_CD"));
								paramOfLevel3.put("MODULE_TYPE", searchParam.get("MODULE_TYPE"));
								paramOfLevel3.put("TMPL_MENU_CD", (String) valudOfLevel2.get("key"));
							}
							else if(EverString.nullToEmptyString(type).equals("BSYM_040R") || EverString.nullToEmptyString(type).equals("BSYM_040L")) {
								paramOfLevel3.put("TMPL_MENU_GROUP_CD", searchParam.get("TMPL_MENU_GROUP_CD"));
								paramOfLevel3.put("MENU_GROUP_CD", searchParam.get("MENU_GROUP_CD"));
								paramOfLevel3.put("MODULE_TYPE", searchParam.get("MODULE_TYPE"));
								paramOfLevel3.put("TMPL_MENU_CD", (String) valudOfLevel2.get("key"));
							}

							List<Map<String, Object>> listOfLevel3 = null;
							if(EverString.nullToEmptyString(type).equals("BSYM_020")) {
								listOfLevel3 = mnua0010_service.getMenuTemplateTree(paramOfLevel3);
							}
							else if(EverString.nullToEmptyString(type).equals("BSYM_040R")) {
								listOfLevel3 = mnua0010_service.getMenuTemplateTreePopup(paramOfLevel3);
							}
							else if(EverString.nullToEmptyString(type).equals("BSYM_040L")) {
								listOfLevel3 = mnua0010_service.getMenuTree(paramOfLevel3);
							}

							if(listOfLevel3.size() > 0) {

								for(int k = 0; k < listOfLevel3.size(); k++) {

									Map<String, Object> valudOfLevel3 = listOfLevel3.get(k);

									// 3Level 데이터 중 isFolder가 true인 것은 4Level 데이터를 가져온다.
									if(EverString.nullToEmptyString(valudOfLevel3.get("isFolder")).equals("true")) {

										Map<String, String> paramOfLevel4 = new HashMap<String, String>();

										if(EverString.nullToEmptyString(type).equals("BSYM_020")) {
											paramOfLevel4.put("TMPL_MENU_GROUP_CD", searchParam.get("TMPL_MENU_GROUP_CD"));
											paramOfLevel4.put("MODULE_TYPE", searchParam.get("MODULE_TYPE"));
											paramOfLevel4.put("TMPL_MENU_CD", (String) valudOfLevel3.get("key"));
										}
										else if(EverString.nullToEmptyString(type).equals("BSYM_040R") || EverString.nullToEmptyString(type).equals("BSYM_040L")) {
											paramOfLevel4.put("TMPL_MENU_GROUP_CD", searchParam.get("TMPL_MENU_GROUP_CD"));
											paramOfLevel4.put("MENU_GROUP_CD", searchParam.get("MENU_GROUP_CD"));
											paramOfLevel4.put("MODULE_TYPE", searchParam.get("MODULE_TYPE"));
											paramOfLevel4.put("TMPL_MENU_CD", (String) valudOfLevel3.get("key"));
										}

										List<Map<String, Object>> listOfLevel4 = null;
										if(EverString.nullToEmptyString(type).equals("BSYM_020")) {
											listOfLevel4 = mnua0010_service.getMenuTemplateTree(paramOfLevel4);
										}
										else if(EverString.nullToEmptyString(type).equals("BSYM_040R")) {
											listOfLevel4 = mnua0010_service.getMenuTemplateTreePopup(paramOfLevel4);
										}
										else if(EverString.nullToEmptyString(type).equals("BSYM_040L")) {
											listOfLevel4 = mnua0010_service.getMenuTree(paramOfLevel4);
										}

										// 3Level 데이터의 childs에 4Level 데이터를 넣는다.
										listOfLevel3.get(k).put("childs", om.writeValueAsString(listOfLevel4));
									}
								}
							}
							// 2Level 데이터의 childs에 3Level 데이터를 넣는다.
							listOfLevel2.get(j).put("childs", om.writeValueAsString(listOfLevel3));
						}
					}
				}
				// 1Level 데이터의 childs에 2Level 데이터를 넣는다.
				listOfLevel1.get(i).put("childs", om.writeValueAsString(listOfLevel2));
			}
		}
		return listOfLevel1;
	}

}