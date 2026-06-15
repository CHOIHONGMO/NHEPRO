package com.st_ones.batch.nhebatch.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.st_ones.batch.nhebatch.BNH0017_Mapper;
import com.st_ones.common.message.service.MessageService;

/**
 * 12개월 미접속 사용자 정보 이관(삭제계정 포함)
 * 4년 미접속 사용자 정보 삭제(삭제계정 포함)
 * @author 
 */
@Service(value = "BNH0017_Service")
public class BNH0017_Service {
	@Autowired private MessageService msg;
	@Autowired private BNH0017_Mapper bnh0017mapper;

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String doExecService(Map<String, String> param) throws Exception {
		System.err.println("==========================================BNH0017_Service===================================================");

		/** 12개월 미접속 사용자 정보 이관(삭제계정 포함) */
		param.put("minusMonth", "-12");
		List<Map<String,String>> tagrgetData1 = bnh0017mapper.getTargetData1(param);
		for (Map<String, String> data : tagrgetData1) {
			// 휴먼계정 이관(STOHCVUR)
			bnh0017mapper.insertSTOHCVUR(data);

			// 휴먼계정 및 삭제계정 삭제(STOCCVUR)
			bnh0017mapper.deleteSTOCCVUR(data);
			
			// 휴먼계정 및 삭제계정 권한프로파일 삭제(STOCUSAP)
			bnh0017mapper.updateSTOCUSAP(data);
						
			// 휴먼계정 및 삭제계정 직무권한 삭제(STOCBASP)
			bnh0017mapper.updateSTOCBACP(data);
		}

		/** 4년 미접속 사용자 정보 삭제(삭제계정 포함) */
		param.put("minusMonth", "-48");
		List<Map<String,String>> targetList2 = bnh0017mapper.getTargetData2(param);
		for (Map<String, String> data : targetList2) {
			// 휴먼계정 삭제(STOHCVUR)
			bnh0017mapper.deleteSTOHCVUR(data);
			
			// 휴먼계정 및 삭제계정 권한프로파일 삭제(STOCUSAP)
			bnh0017mapper.deleteSTOCUSAP(data);
									
			// 휴먼계정 및 삭제계정 직무권한 삭제(STOCBASP)
			bnh0017mapper.deleteSTOCBACP(data);
		}
		
		return msg.getMessage("0001");
	}
}
