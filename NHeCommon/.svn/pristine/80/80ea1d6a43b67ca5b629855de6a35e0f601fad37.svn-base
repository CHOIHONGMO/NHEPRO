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
 * @File Name : MBSA0040_Mapper.java
 * @date 2020. 03. 12.
 * @version 1.0
 */
@Repository
public interface MBSA0040_Mapper {

	/**
	 * 화면명 : 첨부파일 템플릿 관리
	 * 처리내용 : 업무화면에서 사용하는 첨부파일들의 항목들을 템플릿으로 관리하는 화면.
	 * 경로 : 시스템관리 > 기본정보 > 첨부파일 템플릿 관리
	 */
	List<Map<String, Object>> mbsa0040_doSearchHD(Map<String, String> param);

    List<Map<String, Object>> mbsa0040_doSearchDT(Map<String, String> param);

    String getNewKey(Map<String, Object> gridData);

	int mbsa0040_doInsertHD(Map<String, Object> gridData);

	int mbsa0040_doUpdateHD(Map<String, Object> gridData);

	int mbsa0040_doDeleteHD(Map<String, Object> gridData);

	int mbsa0040_doDeleteDT(Map<String, Object> gridData);

	int mbsa0040_doMergeDT(Map<String, Object> gridData);

	int mbsa0040_doDeleteTempSq(Map<String, Object> gridData);

}