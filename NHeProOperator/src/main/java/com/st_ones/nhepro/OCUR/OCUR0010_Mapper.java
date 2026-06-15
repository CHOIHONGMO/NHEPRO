package com.st_ones.nhepro.OCUR;

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
 * @File Name : OCUR0010_Mapper.java
 * @date 2020. 03. 09.
 * @version 1.0
 */
@Repository
public interface OCUR0010_Mapper {

	/**
	 * 화면명 : 고객사현황
	 * 처리내용 : 시스템에 등록된 고객사들을 조회하고, 신규 고객사를 등록하는 화면.
	 * 경로 : 시스템운영사 > 회원사관리 > 고객사 관리 > 고객사현황
	 */
	List<Map<String, Object>> ocur0010_doSearch(Map<String, String> param);

	/**
	 * 화면명 : 고객사 상세
	 * 처리내용 : 시스템에 등록된 고객사 정보를 조회/수정할 수 있는 화면
	 * 경로 : 시스템운영사 > 회원사관리 > 고객사 관리 > 고객사현황 > 고객사 등록/상세 (팝업)
	 */
	Map<String, String> ocur0011_doSearchInfo(Map<String, String> param);

	String getTmplNum(Map<String, String> param);

	List<Map<String, Object>> ocur0011_doSearchTs(Map<String, String> param);

	Map<String, String> ocur0011_doSearchTB(Map<String, String> param);

	void ocur0011_doMergeCorp(Map<String, Object> formData);

	int ocur0011_doCheckNum(Map<String, Object> param);

	void ocur0011_doMergeCust(Map<String, Object> formData);

	void ocur0011_doInsertCVSH(Map<String, Object> formData);

	void ocur0011_doInsertATTS(Map<String, Object> gridData);

	String ocur0011_checkIrsNum(Map<String, String> param);

	void ocur0011_doInsertDNCT(Map<String, String> formData);

	/**
	 * 화면명 : 고객사별 부서현황
	 * 처리내용 : 고객사별로 부서를 조회/관리하는 화면.
	 * 경로 : 시스템운영사 > 회원사관리 > 고객사 관리 > 고객사별 부서현황
	 */
	List<Map<String, Object>> ocur0020_doSearch(Map<String, String> param);

	List<Map<String, Object>> ocur0020_doSearch_parent(Map<String, String> param);

	int existsOPDP(Map<String, Object> gridData);

	void ocur0020_mergeData(Map<String, Object> gridData);

	List<Map<String, Object>> ocur0020_doSearchAccount(Map<String, String> param);

	void ocur0020_mergeAccData(Map<String, Object> gridData);

	String ocur0020_getRelatYN(Map<String, String> param);

	Map<String, Object> ocur0020_getTbData(Map<String, Object> param);

	void ocur0020_mergeBRC(Map<String, Object> data);

	void ocur0020_mergeDEPT(Map<String, Object> data);

}