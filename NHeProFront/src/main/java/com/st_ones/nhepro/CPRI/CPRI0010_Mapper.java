package com.st_ones.nhepro.CPRI;

import java.util.HashMap;
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
 * @File Name : CPRI0010_Mapper.java
 * @date 2020. 03. 20.
 * @version 1.0
 */
public interface CPRI0010_Mapper {

    /**
     * 화면명 : 구매의뢰등록
     * 처리내용 : 구매의뢰서를 작성하는 화면.
     * 경로 : 고객사 > 구매관리 > 구매의뢰 > 구매의뢰등록
     */
    public Map<String, String> getPrFormData(Map<String, String> map);

    public Map<String, String> getPrManualRegInitData(HashMap<String, String> hashMap);

    public List<Map<String, Object>> getPrGridData(Map<String, String> map);

    public List<Map<String, Object>> getPrsiData(Map<String, String> map);

    public String getSignStatus(Map<String, String> formData);

    public int getMaxProgressCode(Map<String, String> formData);

    public void prRegistrationInsertFormData(Map<String, String> formData);

    public String getPrSeq(Map<String, Object> map);

    public void prRegistrationInsertGridData(Map<String, Object> gridRow);

    public void updatePrRegistrationFormData(Map<String, String> formData);
    
    public void deletePrdtData(Map<String, String> formData);
    
    public void deletePrRegistrationGridData(Map<String, Object> gridRow);

    public void prRegistrationUpdateGridData(Map<String, Object> gridData);

    public int getPrdtCount(Map<String, String> formData);

	/** ******************************************************************************************
     * 구매요청 현황
     * @param req
     * @return
     * @throws Exception
     */
	
	public List<Map<String, Object>> CPRR0020_doSearch(Map<String, String> param);

	/** ******************************************************************************************
     * 구매요청진행현황
     * @param req
     * @return
     * @throws Exception
     */
	List<Map<String, Object>> CPRR0030_doSearch(Map<String, String> param);




































    public List<Map<String, Object>> getGridDataByRFINo(Map<String, String> map);

    public List<Map<String, String>> getDONU(Map<String, String> map);

    public void updatePRDTProgressCodeByDonu(Map<String, String> map);

    public void deletePrRegistrationFormData(Map<String, String> formData);

    public void deletePRHBData(Map<String, String> map);

    public void deleteDONUData(Map<String, String> map);

    public Map<String, String> getAppDocNo(Map<String, String> map);

    public int getPRHBDataCount(Map<String, String> formData);

    public List<Map<String, String>> getCtrlUserId(Map<String, String> gridRow);

    public void insertPRHBData(Map<String, String> formData);

    public void insertDONUData(Map<String, String> formData);

	public void updateSignStatus(Map<String, String> map);

	public void updateProgressCd(Map<String, String> map);

    Map<String, String> doAccountSearch(Map<String, String> map);

    Map<String, String> doCostSearch(Map<String, String> map);



































    /** 공통모듈 */
    public void deleteBasketData(Map<String, Object> prdtData);

    public void insertPrsiData(Map<String, Object> prsiData);

    public void deletePrsiData(Map<String, Object> prsiDatarow);

    public void updatePrsiData(Map<String, Object> prsiDatarow);

}