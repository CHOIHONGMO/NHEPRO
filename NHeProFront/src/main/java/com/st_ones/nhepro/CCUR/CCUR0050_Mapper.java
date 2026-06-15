package com.st_ones.nhepro.CCUR;

import java.util.List;
import java.util.Map;

public interface CCUR0050_Mapper {

	List<Map<String, Object>> ccur0050_doSearchLeftGrid(Map<String, String> param);
	
	List<Map<String, Object>> ccur0050_doSearchRightGrid(Map<String, String> param);
	
	int ccur0050_doDeleteSTOCEVTM(Map<String, Object> param);
	
	int ccur0050_doDeleteSTOCEVTD(Map<String, Object> param);
	
	int ccur0050_doDeleteAllSTOCEVTD(Map<String, Object> param);
	
	int ccur0050_doInsertSTOCEVTM(Map<String, String> param);
	
	int ccur0050_doInsertSTOCEVTD(Map<String, Object> param);
	
	int ccur0050_doUpdateSTOCEVTM(Map<String, String> param);
	
	int ccur0050_doUpdateSTOCEVTD(Map<String, Object> param);
	
	int ccur0050_checkExistEVTM(Map<String, String> param);
	
	int ccur0050_checkExistEVTD(Map<String, Object> param);
	
	List<Map<String, Object>> ccur0051_doSearchAppendItem(Map<String, String> param);

}