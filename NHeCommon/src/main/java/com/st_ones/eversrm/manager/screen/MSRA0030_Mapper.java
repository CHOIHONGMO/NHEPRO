package com.st_ones.eversrm.manager.screen;

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
 * @File Name : MSRA0030_Mapper.java
 * @date 2013. 07. 22.
 * @version 1.0
 */
@Repository
public interface MSRA0030_Mapper {

	/**
	 * 화면명 : 화면속성관리
	 * 처리내용 : 화면에서 사용하는 속성 정보들을 관리하는 화면.
	 * 경로 : 시스템관리 > 화면 > 화면속성관리
	 */
	String msra0030_doSearchApprovalType(Map<String, String> paramMap);

	List<Map<String, Object>> msra0030_doSearchDataLength(Map<String, String> param);

	List<Map<String, Object>> msra0030_doSearchDOMC(Map<String, String> param);

	Map<String,String> msra0030_getMostUsedWord(Map<String, String> param);

	List<Map<String, Object>> msra0030_doSearch(Map<String, String> searchForm);

	int checkColumnId(Map<String, Object> gridData);

	void msra0030_doInsert(Map<String, Object> gridData);

	void msra0030_doUpdate(Map<String, Object> gridData);

	void msra0030_doDelete(Map<String, Object> gridData);

	void msra0030_doApprovalTypeUpdate(Map<String, String> formData);

	/**
	 * 화면명 : 화면속성정보 조회
	 * 처리내용 : 화면에서 사용하는 속성 정보들을 관리하는 화면.
	 * 경로 : Popup
	 */
	List<Map<String, Object>> msra0031_doSearch(Map<String, String> param);

	void msra0031_doInsert(Map<String, Object> gridData);

	void msra0031_doUpdate(Map<String, Object> gridData);

	void msra0031_doDelete(Map<String, Object> gridData);

	/**
	 * 화면명 : 화면속성정보 Column ID 조회
	 * 처리내용 : 화면속성정보 등록시 사용하는 Column ID 정보들을 조회하는 화면.
	 * 경로 : Popup
	 */
	List<Map<String, Object>> msra0032_doSearchWord(Map<String, String> param);

	/**
	 * 화면명 : 사용자별 컬럼 정의
	 * 처리내용 : 로그인한 사용자별로 화면에 보이는 Grid 컬럼에 대한 설정값을 정의할 수 있다.
	 * 경로 : 팝업
	 */
	int checkUSLN(Map<String, String> param);

	List<Map<String, Object>> msra0033_STOCLANG_Search(Map<String, String> param);

	List<Map<String, Object>> msra0033_STOCUSCC_Search(Map<String, String> param);

	void msra0033_doDelete(Map<String, String> param) throws Exception;

	void msra0033_doSave(Map<String, Object> grid) throws Exception;

	/**
	 * 화면명 : 화면접근권한 관리
	 * 처리내용 : 화면관리 화면에서 해당 화면에 대한 접근권한을 관리할 수 있는 화면.
	 * 경로 : 팝업
	 */
	Map<String, String> msra0034_doSearch(Map<String, String> param);

	int msra0034_insertScreenAccessibleCd(Map<String, String> rowData);

	int msra0034_updateScreenAccessibleCd(Map<String, String> rowData);

	void insertMenuName(Map<String, String> param);

	void updateMenuName(Map<String, String> param);

	int getCountExistsScreenAccessibleCode(Map<String, String> formData);

    List<Map<String, Object>> msra0035_doSearch(Map<String, String> formData);

	void msra0035_doInsert(Map<String, Object> grid);

	void msra0035_doUpdate(Map<String, Object> grid);
}