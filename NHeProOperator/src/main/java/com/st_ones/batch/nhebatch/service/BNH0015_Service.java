package com.st_ones.batch.nhebatch.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.st_ones.batch.nhebatch.BNH0015_Mapper;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.sms.service.EverSmsService;
import com.st_ones.common.util.clazz.EverString;

/**
 *
 * @author hmchoi
 *
 */
@Service(value = "BNH0015_Service")
public class BNH0015_Service {
	@Autowired private MessageService msg;
	@Autowired private BNH0015_Mapper bnh0015mapper;
	@Autowired private EverSmsService everSmsService;

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String doExecService(Map<String, String> param) throws Exception {
		System.err.println("==========================================BNH0015_Service===================================================");

		/** 입찰서 제출기한 안내 */
		List<Map<String,String>> targetList1 = bnh0015mapper.getTagrgetData1(param);
		for (Map<String,String> data : targetList1) {
			if (data.get("RECV_USER_ID") != null && !EverString.nullToEmptyString(data.get("RECV_USER_ID")).equals("")) {

                Map<String, String> smsMap = new HashMap<String, String>();
                smsMap.put("CONTENTS", "[전자구매시스템] 고객사 [" + data.get("ANN_ITEM") + "]의 입찰서 제출기한이 [" + data.get("BID_END_DATETIME") + "]입니다. 기한내 제출해 주시기 바랍니다.");
                smsMap.put("REF_MODULE_CD", "SBID03");
                smsMap.put("RECV_USER_ID", data.get("RECV_USER_ID"));
                
                // 2021.07.02 : 입찰서 제출 기한 사전안내 SMS 수수료 부과
     			smsMap.put("CORP_NO", data.get("CORP_NO"));			// 고객사 사업자번호
     			smsMap.put("BRC", data.get("BRC"));					// 고객사 부서
     			smsMap.put("EPRO_PS_DSC", "1");						// 1  : 구매
                smsMap.put("EPRO_RATE_DSC", "01");					// 01 : 최초
     			smsMap.put("APLY_DT", data.get("APLY_DT"));			// 발생일 YYYYMMDD
     			smsMap.put("USER_ID", data.get("USER_ID"));			// 고객사 보내는사람 ID
     			smsMap.put("CONT_TBL_ID", data.get("CONT_TBL_ID"));	// 검증 테이블
     			smsMap.put("CONT_TBL_PK", data.get("CONT_TBL_PK")); // 검증 조건(협력사별 입찰번호)
     			smsMap.put("tmp", data.get("CONT_TBL_PK"));			// myBatis 버그 해결을 위한 무의미한, 유니크한 값.
     			smsMap.put("payFlag", "Y");
     			
                everSmsService.sendSmsNhe(smsMap);
            }
		}

		/** 입찰마감 기한 안내 */
		List<Map<String,String>> targetList2 = bnh0015mapper.getTagrgetData2(param);
		for (Map<String,String> data : targetList2) {
			if (data.get("RECV_USER_ID") != null && !EverString.nullToEmptyString(data.get("RECV_USER_ID")).equals("")) {

                Map<String, String> smsMap = new HashMap<String, String>();
                smsMap.put("CONTENTS", "[전자구매시스템] 고객사 [" + data.get("ANN_ITEM") + "]의 입찰이 마감되지 않았습니다. 입찰서 제출 시작 [" + data.get("BID_BEGIN_DATETIME") + "] 전에 마감해 주시기 바랍니다.");
                smsMap.put("REF_MODULE_CD", "SBID03");
                smsMap.put("RECV_USER_ID", data.get("RECV_USER_ID"));
                
                // 2021.07.02 : 임찰마감 기한 사전안내 SMS 수수료 부과
     			smsMap.put("CORP_NO", data.get("CORP_NO"));			// 고객사 사업자번호
     			smsMap.put("BRC", data.get("BRC"));					// 고객사 부서
     			smsMap.put("EPRO_PS_DSC", "1");						// 1  : 구매
                smsMap.put("EPRO_RATE_DSC", "01");					// 01 : 최초
     			smsMap.put("APLY_DT", data.get("APLY_DT"));			// 발생일 YYYYMMDD
     			smsMap.put("USER_ID", data.get("USER_ID"));			// 고객사 보내는사람 ID
     			smsMap.put("CONT_TBL_ID", data.get("CONT_TBL_ID"));	// 검증 테이블
     			smsMap.put("CONT_TBL_PK", data.get("CONT_TBL_PK")); // 검증 조건(협력사별 입찰번호)
     			smsMap.put("tmp", data.get("CONT_TBL_PK"));			// myBatis 버그 해결을 위한 무의미한, 유니크한 값.
     			smsMap.put("payFlag", "Y");
     			
                everSmsService.sendSmsNhe(smsMap);
            }
		}
		
		/**
		 * 2021.09.28 신규 추가
		 * 견적 요청서 협력사 전송 안내(SYSTEM => 견적담당자) SMS 추가 */
		List<Map<String,String>> targetList3 = bnh0015mapper.getTagrgetData3(param);
		for (Map<String,String> data : targetList3) {
			if (data.get("RECV_USER_ID") != null && !EverString.nullToEmptyString(data.get("RECV_USER_ID")).equals("")) {
				
                Map<String, String> smsMap = new HashMap<String, String>();
                smsMap.put("CONTENTS", "[전자구매시스템] 고객사 [" + data.get("RFX_SUBJECT") + "]의 견적이 협력사에게 전송되지 않았습니다. 견적서 제출 종료 [" + data.get("RFX_END_DATE") + "] 전에 전송해 주시기 바랍니다.");
                smsMap.put("REF_MODULE_CD", "SRFX03");
                smsMap.put("RECV_USER_ID", data.get("RECV_USER_ID"));
                
                // 견적 요청서 협력사 전송 안내 SMS 수수료 부과
     			smsMap.put("CORP_NO", data.get("CORP_NO"));			// 고객사 사업자번호
     			smsMap.put("BRC", data.get("BRC"));					// 고객사 부서
     			smsMap.put("EPRO_PS_DSC", "1");						// 1  : 구매
                smsMap.put("EPRO_RATE_DSC", "01");					// 01 : 최초
     			smsMap.put("APLY_DT", data.get("APLY_DT"));			// 발생일 YYYYMMDD
     			smsMap.put("USER_ID", data.get("USER_ID"));			// 고객사 보내는사람 ID
     			smsMap.put("CONT_TBL_ID", data.get("CONT_TBL_ID"));	// 검증 테이블
     			smsMap.put("CONT_TBL_PK", data.get("CONT_TBL_PK")); // 검증 조건(협력사별 입찰번호)
     			smsMap.put("tmp", data.get("CONT_TBL_PK"));			// myBatis 버그 해결을 위한 무의미한, 유니크한 값.
     			smsMap.put("payFlag", "Y");
     			
                everSmsService.sendSmsNhe(smsMap);
                bnh0015mapper.doSendYn(data);
            }
		}
		
		return msg.getMessage("0001");
	}

}
