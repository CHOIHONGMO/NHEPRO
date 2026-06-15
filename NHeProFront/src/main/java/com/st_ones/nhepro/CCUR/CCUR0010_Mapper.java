package com.st_ones.nhepro.CCUR;

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
 * @File Name : CCUR0010_Mapper.java
 * @date 2020. 03. 18.
 * @version 1.0
 */
@Repository
public interface CCUR0010_Mapper {

	/**
	 * 화면명 : 회사정보
	 * 처리내용 : 로그인한 사용자의 회사정보를 조회/수정할 수 있는 화면
	 * 경로 : 고객사 > 관리자 > 조직관리 > 회사정보
	 */
	Map<String, String> ccur0010_doSearchInfo(Map<String, String> param);

	String getTmplNum(Map<String, String> param);

	List<Map<String, Object>> ccur0010_doSearchTs(Map<String, String> param);

	void ccur0010_doUpdateCust(Map<String, Object> formData);

	void ccur0010_doInsertCVSH(Map<String, Object> formData);

	void ccur0010_doInsertATTS(Map<String, Object> gridData);

	Map<String, Object> ccur0010_getTbData(Map<String, Object> param);

	void ccur0010_mergeCORP(Map<String, Object> data);

	/**
	 * 화면명 : 조직정보
	 * 처리내용 : 로그인한 사용자 회사의 조직을 조회/관리하는 화면.
	 * 경로 : 고객사 > 관리자 > 조직관리 > 조직정보
	 */
	String ccur0020_getRelatYN(Map<String, String> param);

	List<Map<String, Object>> ccur0020_doSearch(Map<String, String> param);

	List<Map<String, Object>> ccur0020_doSearch_parent(Map<String, String> param);

	int existsOPDP(Map<String, Object> gridData);

	void ccur0020_mergeData(Map<String, Object> gridData);

	Map<String, Object> ccur0020_getTbData(Map<String, Object> param);

	void ccur0020_mergeBRC(Map<String, Object> data);

	void ccur0020_mergeDEPT(Map<String, Object> data);

	List<Map<String, Object>> ccur0020_doSearchAccount(Map<String, String> param);

	void ccur0020_mergeAccData(Map<String, Object> gridData);

}