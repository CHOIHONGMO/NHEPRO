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
 * @File Name : MAUA0020_Mapper.java
 * @date 2013. 07. 22.
 * @version 1.0
 */
@Repository
public interface MAUA0020_Mapper {

	/**
	 * 화면명 : 사용자별-직무매핑
	 * 처리내용 : 시스템에 등록된 직무를 사용자에게 매핑하여 권한을 부여할 수 있다.
	 * 경로 : 시스템관리 > 기본정보 > 사용자별-직무매핑
	 */
	List<Map<String, Object>> selectTaskPersonInCharge(Map<String, String> param);

	int checkTaskPersonInCharge(Map<String, Object> gridData);

	void insertTaskPersonInCharge(Map<String, Object> gridData);

	void updateTaskPersonInCharge(Map<String, Object> gridData);

	void saveHistoryBACH(Map<String, Object> gridData);

	int deleteTaskPersonInCharge(Map<String, Object> gridData);

}