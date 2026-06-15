package com.st_ones.eversrm.manager.batch.service;

import java.util.List;
import java.util.Map;

import com.st_ones.everf.serverside.service.BaseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.st_ones.common.message.service.MessageService;
import com.st_ones.eversrm.manager.batch.MBTB0010_Mapper;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : MBTB0010Service.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

@Service(value = "MBTB0010_Service")
public class MBTB0010_Service extends BaseService {

	@Autowired private MessageService msg;

	@Autowired MBTB0010_Mapper mbtb0010_mapper;

	/**
	 * 화면명 : BATCH 실행이력
	 * 처리내용 : 시스템에서 실행한 Batch 이력을 조회하는 화면.
	 * 경로 : 시스템관리 > 시스템 > BATCH 실행이력
	 */
	public List<Map<String, Object>> doSearchBatchLogList(Map<String, String> param) throws Exception {
		return mbtb0010_mapper.doSearchBatchLogList(param);
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String doSaveBatchLog(Map<String, Object> logData) throws Exception {

		String jobRlt = (String)logData.get("JOB_RLT");
		if ("E".equals(jobRlt)) {

			String smsMessage = "[SIIS] 통합정보시스템 Batch 오류가 발생하였습니다. "
			          + "프로그램명 : " + logData.get("JOB_NM") + " Interface "
			          + "로그를 확인하시기 바랍니다.";

			List<Map<String, String>> receiverList = mbtb0010_mapper.getBatchManagerSms(null);
			for (Map<String, String> map : receiverList) {
				map.put("RECV_USER_ID",  "");
				map.put("CONTENTS",      smsMessage);
				map.put("VENDOR_CD",     "");
				map.put("REF_NUM",       "");
				map.put("REF_MODULE_CD", "BATCH");
				map.put("BUYER_CD",      "SIIS");
				map.put("SEND_TEL_NUM",  "");
				//everSmsService.sendSms(map);
			}
		}
		mbtb0010_mapper.doSaveBatchLog(logData);
		return msg.getMessage("0001");
	}
	
	/**
	 * 화면명 : 전자보증 실행이력
	 * 처리내용 : 시스템에서 실행한 전자보증 이력을 조회하는 화면.
	 * 경로 : 시스템관리 > 시스템 > 전자보증 실행이력
	 */
	public List<Map<String, Object>> doSearchGuarLogList(Map<String, String> param) throws Exception {
		return mbtb0010_mapper.doSearchGuarLogList(param);
	}

}
