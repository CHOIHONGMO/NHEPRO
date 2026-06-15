package com.st_ones.eversrm.manager.basic;

import org.springframework.stereotype.Repository;

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
 * @File Name : MBSA0030_Mapper.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

@Repository
public interface MBSA0030_Mapper {

	/**
	 * 화면명 : 휴일관리
	 * 처리내용 : System에서 사용하는 휴일(Working Day)을 등록/관리한다.
	 * 경로 : 시스템관리 > 기본정보 > 휴일관리
	 */
	List<Map<String, Object>> mbsa0030_doSearch(Map<String, Object> param);

	int mbsa0030_doCheck(Map<String, Object> gridData);

	void mbsa0030_doSave(Map<String, Object> gridData);
	
	void mbsa0030_doDelete(Map<String, Object> gridData);

}