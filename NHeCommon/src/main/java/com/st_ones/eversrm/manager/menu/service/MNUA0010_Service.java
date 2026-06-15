package com.st_ones.eversrm.manager.menu.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.everf.serverside.info.UserInfoManager;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.st_ones.common.cache.data.BreadCrumbCache;
import com.st_ones.common.docNum.service.DocNumService;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.everf.serverside.util.EverString;
import com.st_ones.eversrm.manager.menu.MNUA0010_Mapper;

/**
* <pre>
******************************************************************************
* 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
* ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
* ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
* (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
******************************************************************************
* </pre>
* @File Name : MNUA0010_Service.java
* @date 2013. 07. 22.
* @version 1.0
*/

@Service(value = "MNUA0010_Service")
public class MNUA0010_Service extends BaseService {

	@Autowired private DocNumService docNumService;

	@Autowired private MessageService msg;

	@Autowired private BreadCrumbCache breadCrumbCache;

	@Autowired private MNUA0010_Mapper mnua0010_mapper;

	/**
	 * 화면명 : 메뉴템플릿관리
	 * 처리내용 : 시스템에서 사용 할 메뉴들을 조합하여 템플릿을 관리하는 화면.
	 * 경로 : 시스템관리 > 메뉴 > 메뉴템플릿관리
	 */
	public List<Map<String, Object>> getMenuTemplates(Map<String, String> param) {
		return mnua0010_mapper.getMenuTemplates(param);
	}

	@SuppressWarnings("rawtypes")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String doSaveMenuTemplateMgmt(List<Map<String, Object>> gridDatas) throws Exception {

		UserInfo userInfo = UserInfoManager.getUserInfo();

		for (Map<String, Object> gridData : gridDatas) {

			if (String.valueOf(gridData.get("INSERT_FLAG")).equals("C")) {

				// 채번로직 변경. Parameter [화면에서 전달 받은 COMPANY_CD (없는 경우, ses.manageCd 또는 ses.companyCd), DOC_TYPE ]
				String docNum = docNumService.getDocNumber(userInfo.getCompanyCd(), "TG");
				gridData.put("TMPL_MENU_GROUP_CD", docNum);

				mnua0010_mapper.createMenuTemplate(gridData);

			} else if (String.valueOf(gridData.get("INSERT_FLAG")).equals("U")) {
				mnua0010_mapper.updateMenuTemplate(gridData);
				mnua0010_mapper.updateMenuTemplateList(gridData);
			}
		}
		return msg.getMessage("0001");
	}

	@SuppressWarnings("rawtypes")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String doCopyMenuTemplateMgmt(List<Map<String, Object>> gridDatas) throws Exception {

		UserInfo userInfo = UserInfoManager.getUserInfo();

		for (Map<String, Object> gridData : gridDatas) {

			Map<String, String> param = new HashMap<String, String>();
			String originTmplMenuGroupCd = (String) gridData.get("TMPL_MENU_GROUP_CD");

			// 채번로직 변경. Parameter [화면에서 전달 받은 COMPANY_CD (없는 경우, ses.manageCd 또는 ses.companyCd), DOC_TYPE ]
			String newTmplMenuGroupCd = docNumService.getDocNumber(userInfo.getCompanyCd(), "TG");
			gridData.put("TMPL_MENU_GROUP_CD", newTmplMenuGroupCd);

			mnua0010_mapper.createMenuTemplate(gridData);

			param.put("TMPL_MENU_GROUP_CD", originTmplMenuGroupCd);
			List<Map<String, Object>> menuDetailList = mnua0010_mapper.getStocmutm(param);
			Map<String, String> hisMap = new HashMap<String, String>();

			for(Map<String, Object> memuDetail : menuDetailList) {
				Map<String, String> mutmParam = new HashMap<String, String>();

				String newTmplMenuCd = this.getMenuTmplCode(param);
				mutmParam.put("TMPL_MENU_CD",  newTmplMenuCd);
				mutmParam.put("OLD_TMPL_MENU_CD",  (String) memuDetail.get("TMPL_MENU_CD"));
				mutmParam.put("DEPTH",  String.valueOf(memuDetail.get("DEPTH")));

				//Old New tmpl_menu_cd mapping
				hisMap.put((String) memuDetail.get("TMPL_MENU_CD"), newTmplMenuCd);

				String highTmplMenuCd = (String) memuDetail.get("HIGH_TMPL_MENU_CD");
				String newHighTmplMenuCd = EverString.nullToEmptyString(hisMap.get(highTmplMenuCd));

				mutmParam.put("HIGH_TMPL_MENU_CD", newHighTmplMenuCd);
				mutmParam.put("LEAF_FLAG",  (String) memuDetail.get("LEAF_FLAG"));
				mutmParam.put("USE_FLAG",  (String) memuDetail.get("USE_FLAG"));
				mutmParam.put("SORT_SQ",  String.valueOf(memuDetail.get("SORT_SQ")));
				mutmParam.put("TMPL_MENU_GROUP_CD",  newTmplMenuGroupCd);
				mutmParam.put("SCREEN_ID",  (String) memuDetail.get("SCREEN_ID"));
				mutmParam.put("MODULE_TYPE",  (String) memuDetail.get("MODULE_TYPE"));

				int rtn = mnua0010_mapper.createMenuTemplateDetail(mutmParam);
				getLog().error("[rtn] - " + rtn);

				int rtnMulg = mnua0010_mapper.copyMenuTemplateDetailMulg(mutmParam);
				getLog().error("[rtnMulg] - " + rtnMulg);
			}
		}
		return msg.getMessage("0001");
	}

	@SuppressWarnings("rawtypes")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String doDeleteMenuTemplateMgmt(List<Map<String, Object>> gridDatas) throws Exception {

		for (Map<String, Object> gridData : gridDatas) {
			mnua0010_mapper.deleteMenuTemplateDetailList(gridData);
			mnua0010_mapper.deleteMenuTemplate(gridData);
		}
		return msg.getMessage("0017");
	}

	public List<Map<String, Object>> getMenuTemplateTree(Map<String, String> param) {
		return mnua0010_mapper.getMenuTemplateTree(param);
	}

	public List<Map<String, Object>> getMenuTemplateDtree(Map<String, String> param) {
		return mnua0010_mapper.getMenuTemplateDtree(param);
	}

	public Map<String, Object> searchMenuTemplateTreeNode(Map<String, String> param) {
		return mnua0010_mapper.searchMenuTemplateTreeNode(param);
	}

	public List<Map<String, Object>> selectStocmuba(Map<String, String> param) {
		return mnua0010_mapper.selectStocmuba(param);
	}

	public String getMenuTmplCode(Map<String, String> param) {
		return mnua0010_mapper.getMenuTmplCode(param);
	}

	public int existsMenuTemplateDetail(Map<String, String> param) {
		return mnua0010_mapper.existsMenuTemplateDetail(param);
	}

	public int updateSortSeqPlusOne(Map<String, String> param) {

		int rtn = mnua0010_mapper.updateSortSeqPlusOne(param);
		return rtn;
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String createMenuTemplateDetail(Map<String, String> params, List<Map<String, Object>> gridDatas) throws Exception {

		int rtn = mnua0010_mapper.createMenuTemplateDetail(params);

		int rtnMulg = mnua0010_mapper.createMenuTemplateDetailMulg(params);

		breadCrumbCache.removeData(params.get("SCREEN_ID"), params.get("MODULE_TYPE"));

		if(gridDatas != null) {
			mnua0010_mapper.deleteStocmuba(params);
		}

		for (Map<String, Object> gridData : gridDatas) {
			gridData.put("TMPL_MENU_CD", (params.get("TMPL_MENU_CD") == null ? "" : params.get("TMPL_MENU_CD")));
			mnua0010_mapper.insertStocmuba(gridData);
		}

		return msg.getMessage("0001");
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String updateMenuTemplateDetail(Map<String, String> param, List<Map<String, Object>> gridDatas) throws Exception {

        mnua0010_mapper.updateMenuTemplateDetail(param);
		breadCrumbCache.initData();

		if(gridDatas != null) {
			mnua0010_mapper.deleteStocmuba(param);
		}

		for (Map<String, Object> gridData : gridDatas) {
			gridData.put("TMPL_MENU_CD", (param.get("TMPL_MENU_CD") == null ? "" : param.get("TMPL_MENU_CD")));
			mnua0010_mapper.insertStocmuba(gridData);
		}
		return msg.getMessage("0016");
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String deleteMenuTemplateDetail(Map<String, String> param) throws Exception {

		mnua0010_mapper.deleteMenuTemplateDetail(param);
		mnua0010_mapper.deleteStocmuba(param);
		breadCrumbCache.initData();
		return msg.getMessage("0017");
	}

	public List<Map<String, Object>> getMenuTree(Map<String, String> param) {
		return mnua0010_mapper.getMenuTree(param);
	}

	public List<Map<String, Object>> getMenuDtree(Map<String, String> param) {
		return mnua0010_mapper.getMenuDtree(param);
	}

	public List<Map<String, Object>> getMenuTreeForHiddenGrid(Map<String, String> param) {
		return mnua0010_mapper.getMenuTreeForHiddenGrid(param);
	}

	public List<Map<String, Object>> getMenuTemplateTreePopup(Map<String, String> param) {
		return mnua0010_mapper.getMenuTemplateTreePopup(param);
	}

	public List<Map<String, Object>> getMenuTemplateDtreePopup(Map<String, String> param) {
		return mnua0010_mapper.getMenuTemplateDtreePopup(param);
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String doSaveMenuGroupCode(List<Map<String, Object>> gridDatas, Map<String, String> param) throws Exception {

		mnua0010_mapper.deleteMenuTree(param);

		for (Map<String, Object> gridData : gridDatas) {

			gridData.put("GATE_CD", param.get("GATE_CD"));
			gridData.put("MENU_GROUP_CD", param.get("MENU_GROUP_CD"));
			gridData.put("MODULE_TYPE", param.get("MODULE_TYPE"));
			gridData.put("MENU_CD", gridData.get("MENU_CD"));
			gridData.put("TMPL_MENU_CD", gridData.get("TMPL_MENU_CD"));

			int checkExists = mnua0010_mapper.existsMenuGroupCode(gridData);
			if (checkExists > 0) {
				mnua0010_mapper.updateMenuGroupCode(gridData);
			} else {
				mnua0010_mapper.createMenuGroupCode(gridData);
			}
		}
		return msg.getMessage("0001");
	}

}