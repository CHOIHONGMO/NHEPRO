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
 * @File Name : MNUA0020_Mapper.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

public interface MNUA0020_Mapper {

	/**
	 * 화면명 : 메뉴그룹관리
	 * 처리내용 : 시스템에 등록된 메뉴템플릿들을 조합하여 사용자에게 부여 할 메뉴그룹을 관리하는 화면.
	 * 경로 : 시스템관리 > 메뉴 > 메뉴그룹관리
	 */
	List<Map<String, Object>> searchMenu(Map<String, String> param);

	void createMenu(Map<String, Object> gridData);

	void copyMenuMums(Map<String, Object> gridData);

	void updateMenu(Map<String, Object> gridData);

	void deleteMenu(Map<String, Object> gridData);

	void deleteMenuMums(Map<String, Object> gridData);

}