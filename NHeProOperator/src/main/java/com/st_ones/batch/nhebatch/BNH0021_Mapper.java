package com.st_ones.batch.nhebatch;

import java.util.List;
import java.util.Map;

public interface BNH0021_Mapper {
	List<Map<String,String>> getTagrgetData(Map<String, String> gridData);

	int upBIGO(Map<String, String> gridData);



}
