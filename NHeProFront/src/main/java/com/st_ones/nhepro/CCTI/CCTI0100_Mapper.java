package com.st_ones.nhepro.CCTI;

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
 * @File Name : CCTI0100_Mapper.java
 * @date 2020.07.05
 * @version 1.0
 * @see
 */public interface CCTI0100_Mapper {

	/**
	 * 화면명 : 
	 * 처리내용 : 
	 * 경로 :  >  > 
	 */
    List<Map<String,Object>> ccti0100_doSearch(Map<String, String> param) throws Exception;
    
    List<Map<String,Object>> ccti0100_doSearchMTGL(Map<String, String> param) throws Exception;

    void ccti0100_doSaveECCT(Map<String, Object> rowData) throws Exception;
    
    // 2021.01.07 기능 변경
	void ccti0100_doDeleteECCM(Map<String, Object> rowData);
	void ccti0100_doInsertECCM(Map<String, Object> rowData);
	
	void ccti0100_doDeleteECMT(Map<String, Object> rowData);
	void ccti0100_doDeleteECCT(Map<String, Object> rowData);
	
	void ccti0100_doChangeECHB(Map<String, Object> rowData);
	
	// 2021.01.07 기능 추가
	void setPrProgressCd(Map<String, Object> rowData);
	void ccti0100_doInsertPohd(Map<String, Object> rowData);
	void ccti0100_doInsertPodt(Map<String, Object> rowData);
}

