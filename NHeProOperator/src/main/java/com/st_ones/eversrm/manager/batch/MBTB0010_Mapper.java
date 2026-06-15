package com.st_ones.eversrm.manager.batch;

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
 * @File Name : MBTB0010Mapper.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

@Repository
public interface MBTB0010_Mapper {

	/**
	 * 화면명 : BATCH 실행이력
	 * 처리내용 : 시스템에서 실행한 Batch 이력을 조회하는 화면.
	 * 경로 : 시스템관리 > 시스템 > BATCH 실행이력
	 */
	List<Map<String, Object>> doSearchBatchLogList(Map<String, String> param);
	
	List<Map<String, String>> getBatchManagerSms(Map<String, String> param);

	int doSaveBatchLog(Map<String, Object> gridData);
	
	/**
	 * 화면명 : 전자보증 실행이력
	 * 처리내용 : 시스템에서 실행한 전자보증 이력을 조회하는 화면.
	 * 경로 : 시스템관리 > 시스템 > 전자보증 실행이력
	 */
	List<Map<String, Object>> doSearchGuarLogList(Map<String, String> param);

}
