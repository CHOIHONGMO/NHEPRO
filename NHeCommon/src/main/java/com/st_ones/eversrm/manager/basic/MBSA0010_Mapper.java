package com.st_ones.eversrm.manager.basic;

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
 * @File Name : MBSA0010_Mapper.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

public interface MBSA0010_Mapper {

	/**
	 * 화면명 : 문서번호
	 * 처리내용 : 시스템에서 사용 할 문서번호의 채번룰을 관리하는 화면.
	 * 경로 : 시스템관리 > 기본정보 > 문서번호
	 */
	List<Map<String, Object>> doSearch(Map<String, String> param);

	int checkDocType(Map<String, Object> param);

	void doInsert(Map<String, Object> param);

	void doUpdate(Map<String, Object> param);

	void doDelete(Map<String, Object> param);

}
