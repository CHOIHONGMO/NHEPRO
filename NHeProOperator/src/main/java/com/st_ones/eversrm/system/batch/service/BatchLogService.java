package com.st_ones.eversrm.system.batch.service;

import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.sms.service.EverSmsService;
import com.st_ones.eversrm.system.batch.BatchLogMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : BatchLogService.java
 * @date 2013. 07. 22.
 * @version 1.0
 * @see
 */
@Service(value = "BatchLogService")
public class BatchLogService {

	@Autowired private MessageService msg;
	@Autowired BatchLogMapper batchLogMapper;
	@Autowired private EverSmsService everSmsService;

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String doSaveBatchLog(Map<String, Object> logData) throws Exception {

		String jobRlt = (String)logData.get("JOB_RLT");

		if ("E".equals(jobRlt)) {

			/*
			String smsMessage = "Batch 오류가 발생하였습니다. "
			          + "프로그램명 : " + (String)logData.get("JOB_NM") + " Interface "
			          + "로그를 확인하시기 바랍니다.";
			List<Map<String, String>> receiverList = batchLogMapper.getBatchManagerSms(null);

			for (Map<String, String> map : receiverList) {

				map.put("RECV_USER_ID",  "");
				map.put("CONTENTS",      smsMessage);
				map.put("VENDOR_CD",     "");
				map.put("REF_NUM",       "");
				map.put("REF_MODULE_CD", "BATCH");
				map.put("BUYER_CD",      "SIIS");
				map.put("SEND_TEL_NUM",  "");

				everSmsService.sendSms(map);
			}
			*/
		}

		batchLogMapper.doSaveBatchLog(logData);

		return msg.getMessage("0001");
	}

	public List<Map<String, Object>> doSearchBatchLogList(Map<String, String> param) throws Exception {
		return batchLogMapper.doSearchBatchLogList(param);
	}

}
