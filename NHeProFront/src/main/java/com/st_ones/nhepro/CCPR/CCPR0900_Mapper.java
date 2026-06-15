package com.st_ones.nhepro.CCPR;

import java.util.List;
import java.util.Map;

public interface CCPR0900_Mapper {
	
	//근로계약대상자조회
	List<Map<String, Object>> ccpr0900_doSearch(Map<String, String> formData);
	
 	//개인근로자 승인 및 반려
 	void ccpr0900_doConfirm(Map<String, Object> rowData);
 	
 	// 2021.07.01 SMS 수수료 추가
  	Map<String, String> costPersonalInfo(Map<String, Object> rowData);
  	
  	//연계아이디 업데이트
  	void ccpr0900_doUpdate(Map<String, Object> rowData);
  	
  	int ccpr0900_doEmpInsert(Map<String, Object> objectMap);
  	
  	void ccpr0900_doEmpUpdate(Map<String, Object> objectMap);
  	
  	void ccpr0900_doEmpUpdate2(Map<String, Object> objectMap);
  	
  	void ccpr0900_InsertPW(Map<String, Object> objectMap);
}
