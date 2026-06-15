package com.st_ones.nhepro.CCDU;

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
 * @File Name : CCDU0010_Mapper.java
 * @date 2020.06.10
 * @version 1.0
 * @see
 */
public interface CCDU0010_Mapper {
	
	List<Map<String, Object>> ccdu0010_doSearch(Map<String, Object> formData);
	
	List<Map<String, Object>> ccdu0010_getCust(Map<String, String> approvalPathKey);
	
	List<Map<String, Object>> ccdu0020_doSearch(Map<String, Object> formData);

	List<Map<String, Object>> ccdu0030_doSearch(Map<String, Object> formObj);
}

