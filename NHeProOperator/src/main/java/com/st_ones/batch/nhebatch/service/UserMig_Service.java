package com.st_ones.batch.nhebatch.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.st_ones.batch.nhebatch.UserMig_Mapper;
import com.st_ones.common.login.service.LoginService;
import com.st_ones.common.message.service.MessageService;
/**
 *
 * @author divin
 *
 */
@Service(value = "UserMig_Service")
public class UserMig_Service {
	@Autowired private MessageService msg;
	@Autowired
	private LoginService loginService;
	@Autowired
	private UserMig_Mapper usermig_mapper;


	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String doExecService(Map<String, String> param) throws Exception {
		System.err.println("==========================================UserMig_Service===================================================");
		List<Map<String,String>> targetList = usermig_mapper.targetUserList(new HashMap<String,String>());

		int cou = 0;
//		for(Map<String,String> data : targetList ) {
//			System.err.println(targetList.size()+"========================================================cou="+cou++);
//			loginService.createUser(data.get("USER_ID"));
//		}


		return msg.getMessage("0001");
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String createCust(Map<String, String> param) throws Exception {
		List<Map<String,String>> targetList = usermig_mapper.targetCustList(new HashMap<String,String>());

		int cou = 0;
//		for(Map<String,String> data : targetList ) {
//			System.err.println(targetList.size()+"========================================================cou="+cou++);
//			loginService.createCust(data);
//		}


		return msg.getMessage("0001");
	}

}
