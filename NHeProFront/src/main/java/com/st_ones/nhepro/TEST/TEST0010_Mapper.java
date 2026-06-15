package com.st_ones.nhepro.TEST;

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
 * @File Name : TEST0010_Mapper.java
 * @date 2018. 01. 30.
 * @version 1.0
 */
@Repository
public interface TEST0010_Mapper {
	
	
	void test0010_doSave(Map<String, String> formData); 

	 List<Map<String,Object>> test0020P10_doSearch(Map<String, Object> formDate) throws Exception;
	 
	 void test0020P10_doSave(Map<String, Object> param) throws Exception;
	 
	 void test0020P10_doDeleteECCF(Map<String, Object> rowData);
	 void test0020P10_doDeleteECCR(Map<String, Object> grid);
	 
	 List<Map<String, Object>> test0030_doSearch(Map<String, String> param);

}