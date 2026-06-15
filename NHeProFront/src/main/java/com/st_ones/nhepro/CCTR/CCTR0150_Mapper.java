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
 * @File Name : CCTR0150_Mapper.java
 * @date 2021.06.23
 * @version 1.0
 * @see
 */
public interface CCTR0150_Mapper {

    List<Map<String,Object>> cctr0150_doSearch(Map<String, String> param) throws Exception;
    
	List<Map<String, Object>> cctr0150_doSearchECMT(Map<String, String> formData) throws Exception;
	
	void cctr0150_doSave(Map<String, Object> gridData) throws Exception;
	
}

