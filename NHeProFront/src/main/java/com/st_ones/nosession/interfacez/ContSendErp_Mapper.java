package com.st_ones.nosession.interfacez;

import java.util.Map;

import org.springframework.stereotype.Repository;

@Repository
public interface ContSendErp_Mapper {
	public Map<String, String> getContData(Map<String, Object> map);

	public void erpSendComplete(Map<String, Object> map);

}