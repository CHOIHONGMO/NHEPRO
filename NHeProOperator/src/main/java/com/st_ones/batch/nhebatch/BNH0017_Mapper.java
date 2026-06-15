package com.st_ones.batch.nhebatch;

import java.util.List;
import java.util.Map;

public interface BNH0017_Mapper {
	List<Map<String, String>> getTargetData1(Map<String, String> param);

	List<Map<String, String>> getTargetData2(Map<String, String> param);

	void insertSTOHCVUR(Map<String, String> data);

	void deleteSTOCCVUR(Map<String, String> data);
	
	void updateSTOCUSAP(Map<String, String> data);
	
	void updateSTOCBACP(Map<String, String> data);
	
	void deleteSTOCUSAP(Map<String, String> data);
	
	void deleteSTOCBACP(Map<String, String> data);

	void deleteSTOHCVUR(Map<String, String> data);
}
