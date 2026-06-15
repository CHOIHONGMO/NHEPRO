package com.st_ones.batch.nhebatch;

import java.util.Map;

public interface BNH0001_Mapper {



	int doDelTbCoInsa(Map<String, String> gridData);
	int doInsTbCoInsa(Map<String, Object> gridData);

	int doUpsTbCoInsa(Map<String, Object> gridData);

	int doDelTbCoOrgz(Map<String, String> gridData);
	int doInsTbCoOrgz(Map<String, String> gridData);

	int doUpsTbCoOrgz(Map<String, String> gridData);

	void doSaveBatchLog(Map<String, Object> gridData);
}
