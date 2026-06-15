package com.st_ones.batch.nhebatch;

import java.util.List;
import java.util.Map;

public interface BNH0011_Mapper {
	public List<Map<String, String>> getContTarget(Map<String, String> map);
	public Map<String, String> makeEcct(Map<String, String> map);
	public List<Map<String, String>> makeEcmt(Map<String, String> map);
	public List<Map<String, String>> makeEcpc(Map<String, String> map);
	public List<Map<String, String>> makeEcpy(Map<String, String> map);
	public List<Map<String, String>> makeEcbv(Map<String, String> map);
	public List<Map<String, String>> makeAtch(Map<String, String> map);

	List<Map<String,String>> getTragetContList(Map<String, String> gridData);

	List<Map<String,String>> getTragetContListXXXXX(Map<String, String> gridData);

	int completeTarget(Map<String, String> gridData);

	public Map<String, String> getFileSeq(Map<String, String> map);
	public List<Map<String, String>> getTargetRegUserId(Map<String, String> ecct);
	public List<Map<String, String>> getTargetRegUserId();
}
