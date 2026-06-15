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
 * @File Name : CCTR0010_Mapper.java
 * @date 2020.04.13
 * @version 1.0
 * @see
 */public interface CCTR0010_Mapper {

	/**
	 * 화면명 : 
	 * 처리내용 : 
	 * 경로 :  >  > 
	 */
    List<Map<String,Object>> cctr0010_doSearch(Map<String, String> param) throws Exception;
    void cctr0010_doDeleteECCF(Map<String, Object> rowData);
	void cctr0010_doDeleteECCR(Map<String, Object> grid);
    void cctr0010_doCopyECCF(Map<String, Object> grid);
    void cctr0010_doCopyECCR(Map<String, Object> grid);
    void cctr0010_doUpdateECCF(Map<String, Object> grid);

    /**
     * 화면명 :
     * 처리내용 :
     * 경로 :  >  >
     */
    Map<String, String> ccti0011_doSearch(Map<String, String> param);

	List<Map<String, Object>> ccti0011_doSearchECCR(Map<String, String> param);

	void newFormRegistrationDoUpdateGridData(Map<String, Object> gridRow);
	void newFormRegistrationDoDeleteGridData(Map<String, Object> gridRow);
	int newFormRegistrationGetExistCount(Map<String, Object> gridRow);
	void newFormRegistrationDoInsertGridData(Map<String, Object> gridRow);

	void doUpdateSignInfo(Map<String, String> formData);

	int ccti0011_doInsertForm(Map<String, String> formData);
	int ccti0011_doUpdateForm(Map<String, String> formData);

	String ccti0011_doSearchFormText(Map<String, String> param);
}

