package com.st_ones.eversrm.manager.auth;

import org.apache.ibatis.annotations.Param;

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
 * @File Name : MAUA0040_Mapper.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

public interface MAUA0040_Mapper {

	/**
	 * 화면명 : 메뉴-권한 매핑
	 * 처리내용 : 시스템에 등록된 권한프로파일코드에 메뉴를 매핑하여 해당 권한을 가진 사용자에게 노출될 메뉴들을 정의하는 화면.
	 * 경로 : 시스템관리 > 권한 > 메뉴-권한 매핑
	 */
	List<Map<String, Object>> doSearchLMenuAuthMapping(Map<String, String> param);

	List<Map<String, Object>> doSearchRMenuAuthMapping(Map<String, String> param);

	void doInsertMenuAuthMapping(Map<String, Object> gridData);

	void doDeleteMenuAuthMapping(Map<String, Object> gridData);

}
