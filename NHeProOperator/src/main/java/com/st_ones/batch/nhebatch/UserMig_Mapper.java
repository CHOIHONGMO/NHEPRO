package com.st_ones.batch.nhebatch;

import java.util.List;
import java.util.Map;

public interface UserMig_Mapper {
	List<Map<String,String>> targetUserList(Map<String, String> gridData);

	List<Map<String,String>> targetCustList(Map<String, String> gridData);

}
