package com.st_ones.eversrm.manager.auth;

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
 * @File Name : MAUA0010_Mapper.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

@Repository
public interface MAUA0010_Mapper {

	/**
	 * 화면명 : 직무관리/직무별-사용자매핑
	 * 처리내용 : 직무를 조회/관리하며, 등록된 직무에 사용자를 매핑하여 권한을 부여할 수 있다.
	 * 경로 : 시스템관리 > 기본정보 > 직무관리/직무별-사용자매핑
	 */
	List<Map<String, Object>> selectTaskCode(Map<String, String> param);
	
	List<Map<String, Object>> selectMappingCust(Map<String, String> param);
	
	List<Map<String, Object>> selectMappingUser_add(Map<String, String> param);

	int checkTaskCode(Map<String, Object> param);

	void insertTaskCode(Map<String, Object> gridData);

	void updateTaskCode(Map<String, Object> gridData);

	int deleteTaskCode(Map<String, Object> gridData);

	int checkTaskPersonInCharge(Map<String, Object> gridData);

	void insertTaskPersonInCharge(Map<String, Object> gridData);

	void updateTaskPersonInCharge(Map<String, Object> gridData);
	
	void updateCustomerMngYn(Map<String, Object> gridData);

	void saveHistoryBACH(Map<String, Object> gridData);

	int deleteTaskPersonInCharge(Map<String, Object> gridData);

	void saveHistoryBACH2(Map<String, Object> gridData);
	void deleteTaskPersonInCharge2(Map<String, Object> gridData);





}