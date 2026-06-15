package com.st_ones.batch.nhebatch.service;

import com.st_ones.batch.nhebatch.BNH0016_Mapper;
import com.st_ones.common.mail.service.EverMailService;
import com.st_ones.common.message.service.MessageService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 *
 * @author hmchoi
 *
 */
@Service(value = "BNH0016_Service")
public class BNH0016_Service {
	@Autowired private MessageService msg;
	@Autowired private BNH0016_Mapper bnh0016mapper;
	@Autowired private EverMailService everMailService;

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String doExecService(Map<String, String> param) throws Exception {
		System.err.println("==========================================BNH0016_Service===================================================");

		/** 휴면계정 전환 안내메일 */
		List<Map<String,String>> targetList = bnh0016mapper.getTargetData(param);
		String subject = "[농협정보시스템] 휴면계정 전환 안내메일";

		for(Map<String,String> data : targetList) {
			String content = "안녕하십니까! 농협정보시스템 입니다.<br>" +
					data.get("USER_NM") + "님의 미접속 기간이 11개월을 초과하여 휴면계정 전환 알림메일을<br>" +
					"발송합니다. 접속 후 로그인하여 주시기 바랍니다.<br>";

			HashMap mailMap = new HashMap();
			mailMap.put("SUBJECT", subject);
			mailMap.put("CONTENTS", content);
			mailMap.put("REF_MODULE_CD", "MUSER02");
			mailMap.put("RECV_USER_ID", data.get("USER_ID"));
			mailMap.put("REF_NUM", "");
			everMailService.SendMail(mailMap);
		}

		return msg.getMessage("0001");
	}

}
