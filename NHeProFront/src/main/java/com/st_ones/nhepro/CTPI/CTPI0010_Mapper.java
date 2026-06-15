package com.st_ones.nhepro.CTPI;

import java.util.List;
import java.util.Map;

import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : CTPI0010_Mapper.java
 * @date 2020.06.19
 * @version 1.0
 * @see
 */public interface CTPI0010_Mapper {

	/**
	 * 화면명 : 
	 * 처리내용 : 
	 * 경로 :  >  > 
	 */
    List<Map<String,Object>> ctpi0010_doSearch(Map<String, String> param) throws Exception;

	/**
	 * 화면명 : 
	 * 처리내용 : 
	 * 경로 :  >  > 
	 */
    void ctpi0010_doDelete(Map<String, Object> rowData) throws Exception;

	/**
	 * 화면명 : 
	 * 처리내용 : 
	 * 경로 :  >  > 
	 */
    void ctpi0010_doSave(Map<String, Object> rowData) throws Exception;

	/**
	 * 화면명 : 
	 * 처리내용 : 
	 * 경로 :  >  > 
	 */
    void ctpi0010_doInsert(Map<String, Object> rowData) throws Exception;

	/**
	 * 화면명 : 
	 * 처리내용 : 
	 * 경로 :  >  > 
	 */
    void ctpi0010_doUpdate(Map<String, Object> rowData) throws Exception;

    /**
	 * 화면명 : 
	 * 처리내용 : 
	 * 경로 :  >  > 
	 */
	void ctpi0010_doInsertPoint(Map<String, String> reqParamrMap);

	
	/**
	 * 화면명 : 
	 * 처리내용 : 
	 * 경로 :  >  > 
	 */
	void ctpi0010_doUpdatePoint(Map<String, String> reqParamrMap);

	List<Map<String, Object>> ctpi0010_doSearchAmtList();

	
	List<Map<String, Object>> ctpi0010_doSearchCompanyType();

	List<Map<String, Object>> ctpi0010_doSearchTpayInfo(Map<String, Boolean> param);

	void ctpi0010_doInsertTmptPoint(Map<String, String> paramDataMap);

	void ctpi0010_doSearchTmpData(Map<String, String> paramDataMap);

	void ctpi0010_doDeleteTmpPoint(Map<String, String> paramDataMap);

	List<Map<String, Object>> ctpi0020_doSearch(Map<String, String> map);

	Map<String, Object> ctpi0010_getDecValue(Map<String, String> params);

	List<Map<String, Object>> ctpu0040_getUserInfo(EverHttpRequest req);

	List<Map<String, Object>> ctpu0040_getUserInfo(Map<String, String> req);

	void CTPU0040_insertRefundRequest(Map<String, String> params);

	void CTPU0040_updateRefundPoint(Map<String, String> params);

	List<Map<String, Object>> ctpr0050_doSearch(Map<String, String> formData);

	List<Map<String, Object>> CTPR0060R1(Map<String, String> formData);

	List<Map<String, Object>> CTPR0060R4(Map<String, String> formData);

	List<Map<String, Object>> CTPR0060R3(Map<String, String> formData);

	List<Map<String, Object>> CTPR0060R2(Map<String, String> formData);

	List<Map<String, Object>> CTPR0070_doSearch(Map<String, String> formData);
	
	List<Map<String, Object>> ctpi0010_doSearchTpayInfo2(Map<String, Boolean> param);	
	
}

