package com.st_ones.batch.nhebatch;

import java.util.List;
import java.util.Map;

public interface BNH0012_Mapper {
	List<Map<String,String>> getTagrgetCust(Map<String, String> gridData);
	List<Map<String,String>> getCoUserList(Map<String, String> gridData);
	Map<String,String> chkStocUser(Map<String, String> gridData);
	Map<String,String> chkStohUser(Map<String, String> gridData);
	
	int upsHvur(Map<String, String> gridData);
	
	int upsBacp(Map<String, String> gridData);
	
	int delOgdp(Map<String, String> gridData);
	int insOgdp(Map<String, String> gridData);

	int upsCust(Map<String, String> gridData);

	int upsCvur(Map<String, String> gridData);
	int insCvur(Map<String, String> gridData);
	int insUsap(Map<String, String> gridData);
	int insBacp(Map<String, String> gridData);
	
	// 2021.11.03 퇴사한 사용자 삭제
	int delCvur(Map<String, String> gridData);
	int delUsap(Map<String, String> gridData);
	int delBacp(Map<String, String> gridData);
	
	// 2023.01.04 퇴사한 휴먼사용자 삭제
	int delHvur(Map<String, String> gridData);

}
