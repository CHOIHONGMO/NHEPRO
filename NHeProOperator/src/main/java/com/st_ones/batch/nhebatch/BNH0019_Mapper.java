package com.st_ones.batch.nhebatch;

import java.util.List;
import java.util.Map;

public interface BNH0019_Mapper {
	
	List<Map<String, String>> getTargetData1(Map<String, String> param);
	
	void updateSTOCTVUR(Map<String, String> data);

	//void deleteSTOCATCH(Map<String, String> data);
	
	//void deleteSTOCATCH_VENDOR(Map<String, String> data);
	
	void deleteSTOCTCRL(Map<String, String> data);
	
	void deleteSTOCTCCT(Map<String, String> data);
	
	void deleteSTOCTUPW(Map<String, String> data);
	
	void deleteSTOCTVUR(Map<String, String> data);
	
	//계약서 파일 관련 UUID
	List<Map<String, String>> getUUIDInfo(Map<String, String> param);
	//첨부 파일 관련 UUID
	List<Map<String, String>> getUUIDInfo2(Map<String, String> param);
	
	
	
}
