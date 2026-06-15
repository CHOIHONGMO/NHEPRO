package com.st_ones.batch.nhebatch;

import java.util.List;
import java.util.Map;

public interface BNH0015_Mapper {
	List<Map<String,String>> getTagrgetData1(Map<String, String> gridData);
	
	List<Map<String,String>> getTagrgetData2(Map<String, String> gridData);
	
	/**
	 * 2021.09.28 신규 추가
	 * 견적 요청서 협력사 전송 안내(SYSTEM => 견적담당자) SMS 추가
	 */
	List<Map<String,String>> getTagrgetData3(Map<String, String> gridData);
	
	void doSendYn(Map<String, String> rowData);
	
}
