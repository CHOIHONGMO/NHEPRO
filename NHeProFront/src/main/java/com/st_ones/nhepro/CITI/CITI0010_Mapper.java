package com.st_ones.nhepro.CITI;

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
 * @File Name : CITI0010_Mapper.java
 * @date 2020.03.05
 * @version 1.0
 * @see
 */public interface CITI0010_Mapper {

	/**
	 * 화면명 : 신규품목요청
	 * 처리내용 : 신규품목요청, 저장
	 * 경로 : 기준정보 > 품목현황 > 신규품목요청
	 */
	void citi0010_doInsert(Map<String, Object> gridData);

	/**
	 * 화면명 : 품목등록신청현황
	 * 처리내용 : 신규로 등록요청한 품목정보에 대한 내용을 확인하는 화면
	 * 경로 : 기준정보 > 품목관리 > 품목등록신청현황
	 */
	List<Map<String, Object>> citr0020_doSearch(Map<String, String> formData);

	/**
	 * 화면명 : 품목요청상세
	 * 처리내용 : 품목등록신청 후 상세 페이지를 호출
	 * 경로 : 기준정보 > 품목관리 > 품목등록신청현황 > 품목요청상세(팝업)
	 */
	Map<String, String> cita0021_doSearch(Map<String, String> formData);

	void cita0021_doDelete(Map<String, String> formData);

	void cita0021_doRequest(Map<String, String> formData);

	/**
	 * 화면명 : 품목등록승인현황
	 * 처리내용 : 신규로 등록요청한 품목정보에 대한 내용을 재요청하는 화면
	 * 경로 : 기준정보 > 품목관리 > 품목등록승인현황
	 */
	List<Map<String, Object>> citr0030_doSearch(Map<String, String> formData);

	void citr0030_doRequest(Map<String, Object> grid);

    /**
     * 화면명 : 품목요청등록
     * 처리내용 : 품목등록승인현황에서 요청번호를 클릭하여 품목요청을 등록한다.
     * 경로 : 기준정보 > 품목관리 > 품목등록승인현황 > 품목요청등(팝업)
     */
	Map<String, String> cita0031_doSearch(Map<String, String> paramData);

	void cita0031_MTGL_Insert(Map<String, String> formData);
	void cita0031_MTGL_Update(Map<String, String> formData);
	int cita0031_doDeleteMTIM(Map<String, String> formData);
	int cita0031_doSaveMTIM(Map<String, String> formData);
	int cita0031_doSaveMTGC(Map<String, String> gridDatum);
	void cita0031_doUpdateNWRQ(Map<String, String> formData);

	/**
	 * 화면명 : 품목현황
	 * 처리내용 : 고객사 기준정보의 품목현황 조회 및 처리
	 * 경로 : 기준정보 >  > 품목관리 > 품목현황
	 */
	List<Map<String, Object>> citr0040_doSearch(Map<String, String> formData);
	List<Map<String, Object>> citr0040_doSearchListMKBR(Map<String, Object> grid);
	Map<String, String> citr0040_doSearchMapMKBR(Map<String, Object> grid);

	/**
	 * 화면명 : 품목상세
	 * 처리내용 : 품목현황에서 품목코드 클릭 시 품목상세 화면 호출
	 * 경로 : 기준정보 > 품목관리 > 품목현황 > 품목상세(팝업)
	 */
	Map<String, String> citr0041_doSearchInfo(Map<String, String> formData);

    /**
     * 화면명 : 품목검색
     * 처리내용 : 품목 세분류의 속성을 매핑하는 화면.
     * 경로 : 고객사 > 품목관리 > 품목현황 > 품목검색(팝업) - 공통
     */
    List<Map<String, Object>> citr0042_doSearchGrid(Map<String, String> formData);

	/**
	 * 화면명 : 품목분류
	 * 처리내용 : 품목요청등록 화면에서 분목분류 클릭 시 팝업 호출
	 * 경로 : 기준정보 >  > 품목관리 > 품목등록승인현황 > 품목요청등록 > 품목분류 (팝업)
	 */
	List<Map<String, Object>> citr0043_doSearch_ItemClassPopup_TREE(Map<String, String> param);

	/**
	 * 화면명 : 품목요청등록
	 * 처리내용 : 품목등록승인현황에서 요청번호를 클릭하여 품목요청을 등록한다.
	 * 경로 : 기준정보 > 품목관리 > 품목등록승인현황 > 품목요청등(팝업)
	 */
	void cita0044_doDeleteMTGL(Map<String, String> formData);
	void cita0044_doDeleteMTIM(Map<String, String> formData);
	void cita0044_doDeleteMTGC(Map<String, String> formData);

	/**
	 * 화면명 : 표준관리 품목검색
	 * 처리내용 : 품목 세분류의 속성을 매핑하는 화면.
	 * 경로 : 고객사 > 품목관리 > 품목현황 > 표준관리 품목검색(팝업)
	 */
	List<Map<String, Object>> citr0045_doSearchGrid(Map<String, String> formData);

	/**
	 * 화면명 : 품목속성상세
	 * 처리내용 : 품목속성상세 정보를 조회힌다.
	 * 경로 : 품목관리 > 품목관리 > 표준품목현황 > 표준품목상세(팝업) > 품목속성상세 (팝업)
	 */
	List<Map<String, Object>> citr0047_doSearch(Map<String, String> formData);
    
	/**
	 * 화면명 : 품목분류 현황
	 * 처리내용 : 고객사별 품목분류를 조회/관리하는 화면.
	 * 경로 : 품목관리 > 품목분류/SG > 품목분류 현황
	 */
	List<Map<String, Object>> citr0050_doSearchItemClass(Map<String, String> param);

	List<Map<String, Object>> citr0050_doSearchItemClassSearchNm(Map<String, String> param);

	List<Map<String, Object>> citr0050_doSearchChild(Map<String, String> param);

	int citr0050_existsData(Map<String, String> param);

	void citr0050_doCopyItemClass(Map<String, String> data);

	String citr0050_newSortSeq(Map<String, Object> param);

	String citr0050_newItemClassKey(Map<String, Object> param);

	int citr0050_existsItemClass(Map<String, Object> param);

	int citr0050_insertItemClass(Map<String, Object> gridData);

	int citr0050_updateItemClass(Map<String, Object> gridData);

	int citr0050_notDeleteItemClass(Map<String, Object> param);

	int citr0050_deleteItemClass_r(Map<String, Object> gridData);

	/**
	 * 화면명 : 제조사/브랜드 관리
	 * 처리내용 : 시스템에서 사용하는 제조사/브랜드를 조회/등록하는 화면.
	 * 경로 : 품목관리 > 품목표준화 > 제조사/브랜드 관리
	 */
	List<Map<String,Object>> citr0060_doSearch(Map<String, String> formData);

	int citr0060_doSave(Map<String, Object> gridDatum);

}

