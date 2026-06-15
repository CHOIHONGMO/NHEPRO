package com.st_ones.eversrm.system.batch.web;

import java.io.IOException;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.st_ones.common.combo.service.CommonComboService;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : BatchLogController.java
 *
 * @date 2013. 07. 22.
 * @version 1.0
 * @see
 */
@Controller
@RequestMapping(value = "/eversrm/system/batch")
public class BatchLogController extends BaseController {

	@Autowired private MessageService msg;
	@Autowired private CommonComboService commonComboService;

	/**
	 * 화면명 : Batch 실행
	 * 처리내용 :batch 실행
	 * 경로 : 시스템관리 > 시스템 > Batch 실행
	 */
	@RequestMapping("/batchLog/view")
	public String BatchLog(EverHttpRequest req) throws Exception {

		/*String[] ext = {"log", "zip"};
		ArrayList<Map<String, String>> fileList = new ArrayList<Map<String, String>>();
		Iterator<File> fileIterator = FileUtils.iterateFiles(new File("/services/logs"), ext, true);
		while(fileIterator.hasNext()) {
			File file = fileIterator.next();
			Map<String, String> p = new HashMap<String, String>();
			p.put("text", file.getAbsolutePath());
			p.put("value", file.getAbsolutePath());
			fileList.add(p);
		}
		req.setAttribute("logFileList", new ObjectMapper().writeValueAsString(fileList));*/
		return "/eversrm/system/batch/batchLog";
	}

	@RequestMapping(value = "/batchLog/doExecute")
	public void doExecute(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		Map<String, String> param = req.getFormData();
		String execCd = param.get("EXEC_CD");
		String rtnMsg = "";

        try {
//			if( "Comch".equals(execCd) ){ //업체변경정보 i/f
//				comchIf.execute(null);
//			} else if ( "Smstran".equals(execCd) ){ //SMS 전송 I/F
//				smstranIf.execute(null);
//			} else if ( "Smsresult".equals(execCd) ){ //SMS 결과반영 I/F
//				smsresultIf.execute(null);
//			} else if ( "InvoiceDelay".equals(execCd) ){ //납품지연알림(D+1) : 시스템 -> 운영사품목담당자
//				invoiceDelayIf.execute(null);
//			} else if ("CUST_CFM_REQ_MAIL".equals(execCd)){ //마감확정요청(고객)
//				custCfmReqMail.execute(null);
//			} else if ("delyAlarm".equals(execCd)){ //납품예정알림(D-1) : 운영사품목담당자 -> 공급사납품담당자
//				delyAlarmIf.execute(null);
//			} else if ("curDelyInvoice".equals(execCd)){ //금일납품알림(D+0) : 운영사품목담당자 -> 공급사납품담당자
//				curDelyAlarmIf.execute(null);
//			} else if("GR_REQUEST_DELAY_SMS".equals(execCd)) { // 입고완료처리 요청(고객사, 입고담당자)
//				grRequestDelaySms.execute(null);
//			} else if("rfqNoticeMail".equals(execCd)) { // 견적지연 안내 E-mail 발송(운영사 시스템 => 운영사 품목담당자)
//				rfqNoticeMail.execute(null);
//			} else if("sendMail".equals(execCd)) { // Batch E-mail 발송
//				sendMail.execute(null);
//			} else if("IF_MRO_JOB".equals(execCd)) { // 전표배치작업
//				ifmrojob.execute(null);
//			} else if("IF_SENDBILL_JOB".equals(execCd)) { // sendbill배치작업
//				ifsendbilljob.execute(null);
//			} else if("userBlock".equals(execCd)) { // User Block
//				userBlockjob.execute(null);
//			}

			rtnMsg = msg.getMessage("0001");
        } catch (Exception e) {
			getLog().error(e.getMessage(), e);
        	rtnMsg = msg.getMessage("0003");
        }

		resp.setResponseMessage(rtnMsg);
	}

	@RequestMapping(value = "/batchLog/doDownload")
	public void doDownload(EverHttpRequest req, EverHttpResponse resp) throws IOException {
		Map<String, String> formData = req.getFormData();
		String logFile = formData.get("logFile");
	}
}