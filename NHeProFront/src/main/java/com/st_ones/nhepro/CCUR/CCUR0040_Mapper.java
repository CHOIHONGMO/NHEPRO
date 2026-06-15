package com.st_ones.nhepro.CCUR;

import java.util.List;
import java.util.Map;

public interface CCUR0040_Mapper {

	List<Map<String, Object>> ccur0040_doSearchEvalItemMgt(Map<String, String> param);

	List<Map<String, Object>> ccur0040_doSearchEvalItemMgtDetail(Map<String, String> param);
	List<Map<String, Object>> ccur0040_doSearchEvalItemMgtDetail2(Map<String, String> param);

	void ccur0040_doInsertEvalItemMgtMaster(Map<String, String> param);
	
	void ccur0040_doInsertEvalItemMgtDetail(Map<String, Object> param);
	
	void ccur0040_doUpdateEvalItemMgtMaster(Map<String, String> param);
	
	void ccur0040_doUpdateEvalItemMgtDetail(Map<String, Object> param);
	
	void ccur0040_doDeleteEvalItemMgtMaster(Map<String, Object> param);
	
	void ccur0040_doDeleteEvalItemMgtAllDetail(Map<String, Object> param);
	
	void ccur0040_doDeleteEvalItemMgtDetail(Map<String, Object> param);
	
	int ccur0040_doCheckEvalItemMgtDetail(Map<String, String> param);
	
	int ccur0040_doCheckInTemplateItemWeight(Map<String, String> param);
}
