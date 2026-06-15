package com.st_ones.batch.nhebatch.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.st_ones.batch.nhebatch.BNH0020_Mapper;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.sms.service.EverSmsService;
import com.st_ones.common.util.clazz.EverString;
/**
 *
 * @author divin
 *
 */
@Service(value = "BNH0020_Service")
public class BNH0020_Service {
	@Autowired private MessageService msg;
	@Autowired private BNH0020_Mapper bnh0020mapper;
    @Autowired private EverSmsService eversmsservice;

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String doExecService(Map<String, String> param) throws Exception {
		System.err.println("==========================================BNH0020_Service===================================================");
		List<Map<String,String>> userList1 = bnh0020mapper.getTagrgetData1(param);
		for(Map<String,String> data : userList1) {
            Map<String,String> smsMap = new HashMap<String,String>();
            
            smsMap.put("CONTENTS", "[전자구매시스템] 협력사 ["+data.get("VENDOR_NM")+"]에서 검수요청한 ["+data.get("SUBJECT")+"] 검수요청 7일이 지났습니다. 원활한 대급지급을 위하여  ["+data.get("SEND_REQ_DATE")+"]일까지 검수를 완료해주시길 바랍니다.");
            smsMap.put("REF_MODULE_CD", "SIV03");
            smsMap.put("RECV_USER_ID", data.get("RECV_USER_ID"));
            
            // 2021.07.02 : 예정가격 작성기한 승인 및 확정시 SMS 수수료 부과
 			smsMap.put("CORP_NO", data.get("CORP_NO"));			// 고객사 사업자번호
 			smsMap.put("BRC", data.get("BRC"));					// 고객사 부서
 			smsMap.put("EPRO_PS_DSC", "1");						// 1  : 구매
            smsMap.put("EPRO_RATE_DSC", "01");					// 01 : 최초
 			smsMap.put("APLY_DT", data.get("APLY_DT"));			// 발생일 YYYYMMDD
 			smsMap.put("USER_ID", data.get("USER_ID"));			// 고객사 보내는사람 ID
 			smsMap.put("CONT_TBL_ID", "STOCIVHD");				// 검증 테이블
 			smsMap.put("CONT_TBL_PK", data.get("CONT_TBL_PK")); // 검증 조건(협력사별 입찰번호)
 			smsMap.put("tmp", data.get("CONT_TBL_PK"));			// myBatis 버그 해결을 위한 무의미한, 유니크한 값.
 			smsMap.put("payFlag", "Y");
 			
 			System.out.println("SUBJECT ===> " + "[전자구매시스템] 협력사 ["+data.get("VENDOR_NM")+"]에서 검수요청한 ["+data.get("SUBJECT")+"] 검수요청 7일이 지났습니다. 원활한 대급지급을 위하여 ["+data.get("SEND_REQ_DATE")+"]일까지 검수를 완료해주시길 바랍니다.");
 			System.out.println("CORP_NO ====> "+data.get("CORP_NO"));
 			System.out.println("BRC ====> "+data.get("BRC"));
 			System.out.println("USER_ID ====> "+data.get("USER_ID"));
 			System.out.println("CONT_TBL_PK ===> "+data.get("CONT_TBL_PK"));
 			
            eversmsservice.sendSmsNhe(smsMap);
		}
		
		List<Map<String,String>> userList2 = bnh0020mapper.getTagrgetData2(param);
		for(Map<String,String> data : userList2) {
			Map<String,String> smsMap = new HashMap<String,String>();
			smsMap.put("CONTENTS", "[전자구매시스템] 협력사 ["+data.get("VENDOR_NM")+"]에서 검수요청한 ["+data.get("SUBJECT")+"] 검수완료 7일이 지났습니다. 원활한 대급지급을 위하여 대금지급요청을 해주시길 바랍니다.");
            smsMap.put("REF_MODULE_CD", "SAP03");
            //검수요청서 작성시 입력한 협력업체 담당자 휴대전화번호로 SMS 발송
            if( EverString.isEmpty(data.get("CELL_NUM")) ) {
				smsMap.put("RECV_USER_ID", data.get("RECV_USER_ID"));
            } else {
                smsMap.put("DIRECT_TARGET", data.get("CELL_NUM"));
				smsMap.put("DIRECT_USER_NM", data.get("USER_NM"));
            }
            
            // 2021.07.02 : 예정가격 작성기한 승인 및 확정시 SMS 수수료 부과
			smsMap.put("CORP_NO", data.get("CORP_NO"));			// 고객사 사업자번호
			smsMap.put("BRC", data.get("BRC"));					// 고객사 부서
			smsMap.put("EPRO_PS_DSC", "1");						// 1  : 구매
            smsMap.put("EPRO_RATE_DSC", "01");					// 01 : 최초
			smsMap.put("APLY_DT", data.get("APLY_DT"));			// 발생일 YYYYMMDD
			smsMap.put("USER_ID", data.get("AP_USER_ID"));		// 고객사 보내는사람 ID
			smsMap.put("CONT_TBL_ID", "STOCIVAP");	// 검증 테이블
 			smsMap.put("CONT_TBL_PK", data.get("CONT_TBL_PK")); // 검증 조건(협력사별 입찰번호)
 			smsMap.put("tmp", EverString.isEmpty(data.get("CELL_NUM")) ? data.get("RECV_USER_ID") : data.get("CELL_NUM"));	// myBatis 버그 해결을 위한 무의미한, 유니크한 값.
			smsMap.put("payFlag", "Y");
			
			System.out.println("SUBJECT ===> " + "[전자구매시스템] 협력사 ["+data.get("VENDOR_NM")+"]에서 검수요청한 ["+data.get("SUBJECT")+"] 검수완료 7일이 지났습니다. 원활한 대급지급을 위하여 대금지급요청을 해주시실 바랍니다.");
 			System.out.println("CORP_NO ====> "+data.get("CORP_NO"));
 			System.out.println("BRC ====> "+data.get("BRC"));
 			System.out.println("USER_ID ====> "+data.get("AP_USER_ID"));
 			System.out.println("CONT_TBL_PK ===> "+data.get("CONT_TBL_PK"));
 			
            eversmsservice.sendSmsNhe(smsMap);
		}
		return msg.getMessage("0001");
	}
}
