package com.st_ones.eversrm.manager.screen;

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
 * @File Name : MSRA0020_Mapper.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

public interface MSRA0020_Mapper {

	/**
	 * 화면명 : 화면액션관리
	 * 처리내용 : 시스템에서 사용되는 화면 안에 존재하는 버튼들을 관리하는 화면
	 * 경로 : 시스템관리 > 화면 > 화면액션관리
	 */
	List<Map<String, Object>> doSearchScreenActionManagement(Map<String, String> param);

	List<Map<String, String>> getAvailableButtonCodeList();

	int checkScreenActionManagement(Map<String, Object> param);

	void doUpdateScreenActionManagement(Map<String, Object> gridData);

	void doInsertScreenActionManagement(Map<String, Object> gridData);

	void doDeleteScreenActionManagement(Map<String, Object> gridData);

}
