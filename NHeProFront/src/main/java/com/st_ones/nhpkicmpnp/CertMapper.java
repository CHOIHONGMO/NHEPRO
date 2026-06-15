package com.st_ones.nhpkicmpnp;

import java.util.List;
import java.util.Map;

/**
 * Copyright (c) 2013 ST-Ones (http://www.st-ones.com/) All rights reserved.
 * @LastModified 17. 11. 20 오후 3:28
 */

import org.springframework.stereotype.Repository;

@Repository
public interface CertMapper {
//    public Map<String, String> getVendorInfo(Map<String, String> map);
	void insertCertUser(Map<String, String> param);
	int countCertUser(Map<String, String> param );
	List<Map<String, Object>> certUserInfo(Map<String, String> param);
	String userIrsNoInfo(Map<String, String> param);
	String userCompanyNm(Map<String, String> param);
	String superUserCheck(Map<String, String> param);
	int revokeUserCert(Map<String, String> param);
	Map<String,String> getUserInfo(Map<String, String> param);
	List<Map<String, Object>> revokeCertTargetInfo(Map<String, String> param);
}
