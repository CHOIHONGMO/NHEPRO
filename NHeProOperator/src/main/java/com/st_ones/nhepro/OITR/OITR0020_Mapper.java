package com.st_ones.nhepro.OITR;

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
 * @File Name : OITR0020_Mapper.java
 * @date 2020.03.05
 * @version 1.0
 * @see
 */public interface OITR0020_Mapper {

	/**
	 * 화면명 : 품목현황
	 * 처리내용 : 시스템에 등록되어있는 품목들을 조회/수정/견적의뢰 할 수 있는 화면.
	 * 경로 : 품목관리 > 품목관리 > 품목현황
	 */
    List<Map<String,Object>> oitr0020_doSearch(Map<String, String> formData) throws Exception;

    void oitr0020_doSave(Map<String, Object> rowData) throws Exception;

	/**
	 * 화면명 : 품목분류-속성매핑
	 * 처리내용 : 시스템에 등록된 품목분류를 조회하는 화면.
	 * 경로 : 품목관리 > 품목분류/SG > 품목분류-속성매핑
	 */
	List<Map<String, Object>> oitr0021_doSearch_ItemClassPopup_TREE(Map<String, String> param);

	/**
	 * 화면명 : 품목등록(건별)
	 * 처리내용 : 운영사가 사용할 품목을 등록하는 화면.
	 * 경로 : 품목관리 > 품목표준화 > 품목등록(건별)
	 */
	Map<String, String> oita0024_doSearchInfo(Map<String, String> param);

	List<Map<String,Object>> oita0024_doSearch_AT(Map<String, String> formData);

	void oita0024_MTGL_Insert(Map<String, String> formData) throws Exception;

	void oita0024_MTGL_Update(Map<String, String> formData) throws Exception;

	void oita0024_doDeleteMTAT(Map<String, String> formData) throws Exception;

	int oita0024_doDeleteMTIM(Map<String, String> formData);

	int oita0024_doSaveMTIM(Map<String, String> formData);

	int oita0024_doSaveMTAT(Map<String, Object> gridDatum) throws Exception;

	int oitr0024_doSaveMTGC(Map<String, Object> gridDatum);

	List<Map<String,Object>> oita0025_doSearch(Map<String, String> formData);

	/**
	 * 화면명 : 제조사/브랜드 관리
	 * 처리내용 : 시스템에서 사용하는 제조사/브랜드를 조회/등록하는 화면.
	 * 경로 : 품목관리 > 품목표준화 > 제조사/브랜드 관리
	 */
	List<Map<String,Object>> oitr0080_doSearch(Map<String, String> formData);

	int oitr0080_doSave(Map<String, Object> gridDatum);

    /**
     * 화면명 : 분류속성등록
     * 처리내용 : 품목 세분류의 속성을 등록하는 화면.
     * 경로 : Popup
     */
    List<Map<String, Object>> oitr0070_doSearchMTCR(Map<String, String> param);

    int oitr0070_doInsertMTCR(Map<String, Object> gridData);

    int oitr0070_doDeleteMTCR(Map<String, Object> gridData);

    /**
     * 화면명 : 속성조회
     * 처리내용 : 품목 세분류의 속성을 조회하는 화면.
     * 경로 : Popup
     */
    List<Map<String, Object>> oitr0071_doSearchCommonCode(Map<String, String> param);

    /**
     * 화면명 : 속성기준현황
     * 처리내용 : 속성마스터를 관리하는 화면
     * 경로 : 품목관리 > 품목관리 > 속성기준현황
     */
    List<Map<String, Object>> oitr0060_doSearch(Map<String, String> formData);


    void oitr0060_doInsert(Map<String, Object> formData);

    void oitr0060_doUpdate(Map<String, Object> formData);

    void oitr0060_doDelete(Map<String, Object> grid);

	/**
	 * 화면명 : 품목분류 현황
	 * 처리내용 : 고객사별 품목분류를 조회/관리하는 화면.
	 * 경로 : 품목관리 > 품목분류/SG > 품목분류 현황
	 */
	List<Map<String, Object>> oitr0040_doSearchItemClass(Map<String, String> param);

	List<Map<String, Object>> oitr0040_doSearchItemClassSearchNm(Map<String, String> param);

	List<Map<String, Object>> oitr0040_doSearchChild(Map<String, String> param);

	String oitr0040_newSortSeq(Map<String, Object> param);

	String oitr0040_newItemClassKey(Map<String, Object> param);

	int oitr0040_existsItemClass(Map<String, Object> param);

	int oitr0040_insertItemClass(Map<String, Object> gridData);

	int oitr0040_updateItemClass(Map<String, Object> gridData);

	int oitr0040_notDeleteItemClass(Map<String, Object> param);

	int oitr0040_deleteItemClass_r(Map<String, Object> gridData);

	/**
	 * 화면명 : 품목속성상세
	 * 처리내용 : 품목속성상세 정보를 조회힌다.
	 * 경로 : 품목관리 > 품목관리 > 표준품목현황 > 표준품목상세(팝업) > 품목속성상세 (팝업)
	 */
	List<Map<String, Object>> oitr0023_doSearch(Map<String, String> formData);
}

