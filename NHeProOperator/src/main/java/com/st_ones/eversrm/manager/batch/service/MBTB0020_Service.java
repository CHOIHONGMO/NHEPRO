package com.st_ones.eversrm.manager.batch.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.st_ones.common.message.service.MessageService;
import com.st_ones.eversrm.manager.batch.MBTB0020_Mapper;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : MBTB0020_Service.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

@Service(value = "MBTB0020_Service")
public class MBTB0020_Service {

	@Autowired private MessageService msg;

	@Autowired private MBTB0020_Mapper mbtb0020_mapper;

	/**
	 * 화면명 : BATCH 실행
	 * 처리내용 : 시스템에 등록된 Batch를 수동으로 실행시키는 화면.
	 * 경로 : 시스템관리 > 시스템 > BATCH 실행
	 */
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String doSaveBatchLog(Map<String, Object> logData) throws Exception {

		String jobRlt = (String)logData.get("JOB_RLT");

		if ("E".equals(jobRlt)) {

			/*
			String smsMessage = "Batch 오류가 발생하였습니다. "
			          + "프로그램명 : " + (String)logData.get("JOB_NM") + " Interface "
			          + "로그를 확인하시기 바랍니다.";
			List<Map<String, String>> receiverList = mbtb0020mapper.getBatchManagerSms(null);

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
		mbtb0020_mapper.doSaveBatchLog(logData);
		return msg.getMessage("0001");
	}

	public List<Map<String, Object>> doSearchBatchLogList(Map<String, String> param) throws Exception {
		return mbtb0020_mapper.doSearchBatchLogList(param);
	}
	
	/**
	 * STOCTXTD의 TEXT_CONTENTS => STOCTXTH의 TEXT_CONTENTS로 저장하기
	 * @param logData
	 * @return
	 * @throws Exception
	 */
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String doChangeClob(Map<String, String> param) throws Exception {
		
		List<Map<String, Object>> mainDatas = mbtb0020_mapper.doSearchClobGroup(param);
		for( Map<String, Object> mainData : mainDatas ) {
			List<Map<String, Object>> subDatas = mbtb0020_mapper.doSearchClobSub(mainData);
			
			StringBuffer buf = new StringBuffer();
			buf.setLength(0);
			for( Map<String, Object> subData : subDatas ) {
				buf.append(subData.get("TEXT_CONTENTS"));
			}
			
			Map<String, String> cmap = new HashMap<String, String>();
			cmap.put("GATE_CD", String.valueOf(mainData.get("GATE_CD")));
			cmap.put("TEXT_NUM", String.valueOf(mainData.get("TEXT_NUM")));
			cmap.put("CHANGE_CONTENTS", buf.toString());
			if(buf.length() > 0) {
				mbtb0020_mapper.doChangeClob(cmap);
			}
		}
		return msg.getMessage("0001");
	}

}
