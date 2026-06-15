package com.st_ones.batch.nhebatch;

import java.util.List;
import java.util.Map;

public interface BNH0013_Mapper {
	List<Map<String,String>> getTagrgetData(Map<String, String> gridData);

	int upsComplete(Map<String, String> gridData);



}
