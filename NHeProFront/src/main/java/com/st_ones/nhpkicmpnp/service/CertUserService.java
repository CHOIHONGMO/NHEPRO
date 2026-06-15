package com.st_ones.nhpkicmpnp.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.nhpkicmpnp.CertMapper;

@Service
public class CertUserService extends BaseService {
    @Autowired private CertMapper certUserMapper;
    public String insertCertUser(Map<String, String> param) throws Exception {
		certUserMapper.insertCertUser(param);
        return "Success";
	}

	public int countCertUser(Map<String, String> param) throws Exception{
		int countCertUser = certUserMapper.countCertUser(param);
		return countCertUser;
	}

	public List<Map<String, Object>> certUserInfo(Map<String, String> param) throws Exception {
		return certUserMapper.certUserInfo(param);
	}

	public String userIrsNoInfo(Map<String, String> param) throws Exception {
		String irsNo ="";
		irsNo = certUserMapper.userIrsNoInfo(param);
		return irsNo;
	}

	public String userCompanyNm(Map<String, String> param) throws Exception {
		String companyNm ="";
		System.out.println(">>> userCompnayNm : " + certUserMapper.userCompanyNm(param));
		String temp = certUserMapper.userCompanyNm(param);
		if ( temp != null ) {
			companyNm = temp;
		}
		return companyNm;
	}

	public String superUserCheck(Map<String, String> param) throws Exception {
		String superUserFlag ="";
		superUserFlag = certUserMapper.superUserCheck(param);
		return superUserFlag;
	}

	public String revokeUserCert(Map<String, String> param) throws Exception {
		int result = certUserMapper.revokeUserCert(param);
		String res = null;
		if ( result > 0) {
			res = "success";
		} else {
			res = "error";
		}
		return res;
	}

	public Map<String, String> getUserInfo(Map<String, String> param) throws Exception {
		return certUserMapper.getUserInfo(param);
	}

	public List<Map<String, Object>> revokeCertTargetInfo(Map<String, String> param) throws Exception {
		return certUserMapper.revokeCertTargetInfo(param);
	}
}
