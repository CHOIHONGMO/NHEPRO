package com.st_ones.nhepro.CCTR;

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
 * @File Name : CCTR0012_Mapper.java
 * @date 2020.04.13
 * @version 1.0
 * @see
 */public interface CCTR0012_Mapper {

	/**
	 * 화면명 : 
	 * 처리내용 : 
	 * 경로 :  >  > 
	 */
    List<Map<String,Object>> cctr0012_doSearch(Map<String, String> param) throws Exception;
    void cctr0012_doDeleteECCF(Map<String, Object> rowData);
	void cctr0012_doDeleteECCR(Map<String, Object> grid);
    void cctr0012_doCopyECCF(Map<String, Object> grid);
    void cctr0012_doCopyECCR(Map<String, Object> grid);
    void cctr0012_doUpdateECCF(Map<String, Object> grid);

    /**
     * 화면명 :
     * 처리내용 :
     * 경로 :  >  >
     */
    Map<String, String> ccti0013_doSearch(Map<String, String> param);

	List<Map<String, Object>> ccti0013_doSearchECCR(Map<String, String> param);

	void newFormRegistrationDoUpdateGridData(Map<String, Object> gridRow);
	void newFormRegistrationDoDeleteGridData(Map<String, Object> gridRow);
	int newFormRegistrationGetExistCount(Map<String, Object> gridRow);
	void newFormRegistrationDoInsertGridData(Map<String, Object> gridRow);

	void doUpdateSignInfo(Map<String, String> formData);

	int ccti0013_doInsertForm(Map<String, String> formData);
	int ccti0013_doUpdateForm(Map<String, String> formData);

	String ccti0013_doSearchFormText(Map<String, String> param);
	
	String ccti0013_getRelatYN(Map<String, String> param);	
}

