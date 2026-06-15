package com.st_ones.eversrm.manager.menu;

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
 * @File Name : MNUA0010_Mapper.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

public interface MNUA0010_Mapper {

	/**
	 * 화면명 : 메뉴템플릿관리
	 * 처리내용 : 시스템에서 사용 할 메뉴들을 조합하여 템플릿을 관리하는 화면.
	 * 경로 : 시스템관리 > 메뉴 > 메뉴템플릿관리
	 */
	List<Map<String, Object>> getMenuTemplates(Map<String, String> param);

	List<Map<String, Object>> getStocmutm(Map<String, String> param);

	void createMenuTemplate(Map<String, Object> gridData);

	void updateMenuTemplate(Map<String, Object> gridData);

	void updateMenuTemplateList(Map<String, Object> gridData);

	void deleteMenuTemplate(Map<String, Object> gridData);

	void deleteMenuTemplateDetailList(Map<String, Object> gridData);

	List<Map<String, Object>> getMenuTemplateTree(Map<String, String> param);

	List<Map<String, Object>> getMenuTemplateDtree(Map<String, String> param);

	List<Map<String, Object>> selectStocmuba(Map<String, String> param);

	Map<String, Object> searchMenuTemplateTreeNode(Map<String, String> param);

	String getMenuTmplCode(Map<String, String> param);

	int existsMenuTemplateDetail(Map<String, String> param);

	int updateSortSeqPlusOne(Map<String, String> param);

	int createMenuTemplateDetail(Map<String, String> param);

	int createMenuTemplateDetailMulg(Map<String, String> param);

	int copyMenuTemplateDetailMulg(Map<String, String> param);

	void updateMenuTemplateDetail(Map<String, String> param);

	void deleteMenuTemplateDetail(Map<String, String> param);

	void deleteStocmuba(Map<String, String> param);

	List<Map<String, Object>> getMenuTree(Map<String, String> param);

	List<Map<String, Object>> getMenuDtree(Map<String, String> param);

	List<Map<String, Object>> getMenuTreeForHiddenGrid(Map<String, String> param);

	List<Map<String, Object>> getMenuTemplateTreePopup(Map<String, String> param);

	List<Map<String, Object>> getMenuTemplateDtreePopup(Map<String, String> param);

	void deleteMenuTree(Map<String, String> param);

	void createMenuGroupCode(Map<String, Object> gridData);

	void insertStocmuba(Map<String, Object> gridData);

	void updateMenuGroupCode(Map<String, Object> gridData);

	int existsMenuGroupCode(Map<String, Object> param);

}
