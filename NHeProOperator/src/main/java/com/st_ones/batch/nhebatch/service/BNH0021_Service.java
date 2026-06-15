package com.st_ones.batch.nhebatch.service;

import java.io.File;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.st_ones.batch.nhebatch.BNH0021_Mapper;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.eversrm.eApproval.eApprovalModule.BAPM_Mapper;

/**
 *
 * @author divin
 *
 */
@Service(value = "BNH0021_Service")
public class BNH0021_Service {
	@Autowired private MessageService msg;
	@Autowired private BNH0021_Mapper bnh0021mapper;
	@Autowired private BAPM_Mapper bapm_Mapper;

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String doExecService(Map<String, String> param) throws Exception {
		
		System.err.println("==========================================BNH0021_Service===================================================");
		int upCnt = 0;
		
		List<Map<String, String>> fileList = bnh0021mapper.getTagrgetData(param);
		
		for(Map<String, String> data : fileList) {
			
			if(data.get("CONT_NUM_CNT") != null) {
				bnh0021mapper.upBIGO(data);
				upCnt++;
			}
			
		}
		
		System.out.println("FROMDATE==>"+param.get("FROMDATE"));
		System.out.println("TODATE==>"+param.get("TODATE"));		
		System.out.println("tarCnt==>"+fileList.size());		
		System.out.println("upCnt==>"+upCnt);
				
		String returnMsg = msg.getMessage("0001");
		
		return returnMsg;
	}
}
