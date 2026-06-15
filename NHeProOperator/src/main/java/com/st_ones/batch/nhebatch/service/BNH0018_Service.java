package com.st_ones.batch.nhebatch.service;

import com.st_ones.batch.nhebatch.BNH0018_Mapper;
import com.st_ones.common.mail.service.EverMailService;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.sms.service.EverSmsService;
import com.st_ones.eversrm.eApproval.eApprovalModule.service.BAPM_Service;

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
@Service(value = "BNH0018_Service")
public class BNH0018_Service {
	@Autowired private MessageService msg;
	@Autowired private BNH0018_Mapper bnh0018mapper;
	@Autowired private EverMailService everMailService;
	@Autowired private EverSmsService everSmsService;
	@Autowired BAPM_Service approvalService;

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String doExecService(Map<String, String> param) throws Exception {
		System.err.println("==========================================BNH0018_Service===================================================");

		/** 휴면계정 전환 안내메시지 */
		List<Map<String,String>> targetList = bnh0018mapper.getTargetData(param);
		String subject = "[농협정보시스템] 휴면계정 전환 안내메시지";

		for(Map<String,String> data : targetList) {
			
			Map<String, String> smsMap = new HashMap<String, String>();

			String content = "안녕하십니까! 농협정보시스템 입니다.<br>" +
					data.get("USER_NM") + "님의 미접속 기간이 11개월을 초과하여 휴면계정 전환 알림메시지를<br>" +
					"발송합니다. 접속 후 로그인하여 주시기 바랍니다.<br>";

			smsMap.put("CONTENTS",content);
			smsMap.put("REF_MODULE_CD", "TC");
	        smsMap.put("RECV_USER_ID", data.get("RECV_USER_ID"));
	        smsMap.put("DIRECT_TARGET", String.valueOf(data.get("CELL_NUM")));
			smsMap.put("DIRECT_USER_NM", String.valueOf(data.get("USER_NM")));
				
            // 2021.07.02 : 입찰서 제출 기한 사전안내 SMS 수수료 부과
 			smsMap.put("CORP_NO", data.get("CORP_NO"));			// 고객사 사업자번호
 			smsMap.put("BRC", data.get("BRC"));					// 고객사 부서
 			smsMap.put("EPRO_PS_DSC", "1");						// 1  : 구매
 			smsMap.put("EPRO_WRS_DS", "52");		// epro_wrs_ds [상품코드] - 10 : RFI, 20 : 입찰, 30 : 일반입찰계약, 40 : 일반수의계약, 50 : BtoC계약, 60 : 위임계약, 70 : 문서보관, 80 : SMS, 90 : LMS, 100 : 문서생성
            smsMap.put("EPRO_RATE_DSC", "01");					// 01 : 최초
 			smsMap.put("APLY_DT", data.get("APLY_DT"));			// 발생일 YYYYMMDD
 			smsMap.put("USER_ID", data.get("USER_ID"));			// 고객사 보내는사람 ID
 			smsMap.put("CONT_TBL_ID", "STOCTCCT");	// 업무 Table명
 			smsMap.put("tmp", data.get("CONT_TBL_PK"));			// myBatis 버그 해결을 위한 무의미한, 유니크한 값.
 			smsMap.put("payFlag", "Y");
 			
            everSmsService.sendSmsNhe(smsMap);
		}

		
		
		
		
		return msg.getMessage("0001");
	}

}
