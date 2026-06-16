package com.st_ones.nosession.interfacez;

import java.util.Map;

import org.springframework.stereotype.Repository;

@Repository
public interface ContSendErp_Mapper {
	public Map<String, String> getContData(Map<String, Object> map);

	public void erpSendComplete(Map<String, Object> map);

	// [고도화변경] 2026.06.16 NH-ERP 대금지급 연동 관련 Mapper 메소드 추가
	public Map<String, String> getEccmInfo(Map<String, Object> map);

	public int checkEcpcExists(Map<String, Object> map);

	public void insertEcpc(Map<String, Object> map);

	public void updateEcpc(Map<String, Object> map);
}