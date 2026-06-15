package com.st_ones.nhepro.CCPR;

import java.util.List;
import java.util.Map;

public interface CCPR1010_Mapper {
	List<Map<String, Object>> ccpr1010_doSearch(Map<String, String> formData);
	// 개인근로자 전자서명 직접 요청
    void ccpr1010_doSendYn(Map<String, Object> rowData);
    
 	Map<String, String> costSmsInfo(Map<String, Object> rowData);
	// 계약중단
    void ccpr1010_doStop(Map<String, Object> rowData);
    
    String getPossibleFlag(Map<String, Object> rowData);
    
    String ccpr1010_doSearchPW(Map<String, Object> rowData);
    
    //현장팝업
    List<Map<String, Object>> ccpr0010_doSearch(Map<String, String> formData);
    
    List<Map<String, Object>> ccdu0010_getCust(Map<String, String> approvalPathKey);
    
}
