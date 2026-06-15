package com.st_ones.nhepro.CBDR;

import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2014 ST-Ones CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : CBDR0050_Mapper.java
 * @date 2020. 4. 02.
 * @version 1.0
 */

@Repository
public interface CBDR0050_Mapper {

	List<Map<String, Object>> cbdr0050_doSearch(Map<String, String> param);

	String getPossibleFlag(Map<String, Object> gridData);

	void cbdr0050_doChangeCtrl(Map<String, Object> gridData);
	
	void cbdr0050_doChangeRfxCtrl(Map<String, Object> gridData);

	Map<String, Object>cbdi0051_doSearch(Map<String, String> param);

	void cbdi0051_doSave(Map<String, String> gridData);

	void cbdi0052_doSave(Map<String, String> gridData);

	void cbdi0053_doSave(Map<String, String> gridData);

}