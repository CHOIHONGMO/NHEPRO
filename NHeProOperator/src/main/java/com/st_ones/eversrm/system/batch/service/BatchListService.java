package com.st_ones.eversrm.system.batch.service;

import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.sms.service.EverSmsService;
import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.eversrm.system.batch.BatchListMapper;
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
 * @File Name : BatchListService.java
 * @date 2013. 07. 22.
 * @version 1.0
 * @see
 */
@Service(value = "BatchList_Service")
public class BatchListService extends BaseService {

	@Autowired private MessageService msg;

	@Autowired BatchListMapper batchListMapper;

	@Autowired private EverSmsService everSmsService;

	/**
	 * 화면명 : Batch 실행이력
	 * 처리내용 :batch 실행된 내역을 조회한다.
	 * 경로 : 시스템관리 > 시스템 > Batch 실행이력
	 */
	public List<Map<String, Object>> doSearchBatchLogList(Map<String, String> param) throws Exception {
		return batchListMapper.doSearchBatchLogList(param);
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String doSaveBatchLog(Map<String, Object> logData) throws Exception {

		String jobRlt = (String)logData.get("JOB_RLT");
		if ("E".equals(jobRlt)) {

			String smsMessage = "[SIIS] 통합정보시스템 Batch 오류가 발생하였습니다. "
			          + "프로그램명 : " + logData.get("JOB_NM") + " Interface "
			          + "로그를 확인하시기 바랍니다.";

			List<Map<String, String>> receiverList = batchListMapper.getBatchManagerSms(null);
			for (Map<String, String> map : receiverList) {

				map.put("RECV_USER_ID",  "");
				map.put("CONTENTS",      smsMessage);
				map.put("VENDOR_CD",     "");
				map.put("REF_NUM",       "");
				map.put("REF_MODULE_CD", "BATCH");
				map.put("BUYER_CD",      "SIIS");
				map.put("SEND_TEL_NUM",  "");

				everSmsService.sendSmsNhe(map);
			}
		}

		batchListMapper.doSaveBatchLog(logData);

		return msg.getMessage("0001");
	}

}
