package com.st_ones.batch.nhebatch.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.st_ones.batch.nhebatch.BNH0014_Mapper;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.sms.service.EverSmsService;
/**
 *
 * @author divin
 *
 */
@Service(value = "BNH0014_Service")
public class BNH0014_Service {
	@Autowired private MessageService msg;
	@Autowired private BNH0014_Mapper bnh0014mapper;
    @Autowired private EverSmsService eversmsservice;

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String doExecService(Map<String, String> param) throws Exception {
		System.err.println("==========================================BNH0014_Service===================================================");
		List<Map<String,String>> userList1 = bnh0014mapper.getTagrgetData1(param);
		for(Map<String,String> data : userList1) {
            Map<String,String> smsMap = new HashMap<String,String>();
            smsMap.put("CONTENTS", "[전자구매시스템] ["+data.get("BUYER_NM")+" - "+data.get("REG_USER_NM")+"] 가 상신한 예정가격의 결재 작성기한이 ["+data.get("APP_END_DATETIME")+"] 입니다. 결재승인을 요청드립니다 ");
            smsMap.put("REF_MODULE_CD", "SBID04");
            smsMap.put("RECV_USER_ID", data.get("BID_USER_ID"));
            
            // 2021.07.02 : 예정가격 작성기한 승인 및 확정시 SMS 수수료 부과
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
 			
            eversmsservice.sendSmsNhe(smsMap);
		}
		
		List<Map<String,String>> userList2 = bnh0014mapper.getTagrgetData2(param);
		for(Map<String,String> data : userList2) {
			Map<String,String> smsMap = new HashMap<String,String>();
            smsMap.put("CONTENTS", "[전자구매시스템] ["+data.get("BUYER_NM")+" - "+data.get("REG_USER_NM")+"] 가 상신한 예정가격의 작성기한이 ["+data.get("APP_END_DATETIME")+"] 입니다. 예정가격을 확정 요청드립니다.");
            smsMap.put("REF_MODULE_CD", "SBID04");
            smsMap.put("RECV_USER_ID", data.get("ESTM_USER_ID"));
            
            // 2021.07.02 : 예정가격 작성기한 승인 및 확정시 SMS 수수료 부과
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
			
            eversmsservice.sendSmsNhe(smsMap);
		}
		return msg.getMessage("0001");
	}
}
