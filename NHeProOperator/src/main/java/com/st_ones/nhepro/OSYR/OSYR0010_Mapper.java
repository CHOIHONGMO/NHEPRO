package com.st_ones.nhepro.OSYR;

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
 * @File Name : OSYR0010_Mapper.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

public interface OSYR0010_Mapper {

	/**
	 * 화면명 : 회사단위
	 * 처리내용 : 시스템에서 사용 할 회사 단위를 관리하는 화면.
	 * 경로 : 운영사 > 조직관리 > 조직관리 > 회사단위
	 */
	List<Map<String, Object>> osyr0010_selectCompany(Map<String, String> param);

	int checkCompanyExists(Map<String, String> param);

	int updateCompany(Map<String, String> param);

	int insertCompany(Map<String, String> param);

	void deleteCompany(Map<String, String> param);

}
