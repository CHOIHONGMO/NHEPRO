package com.st_ones.eversrm.eApproval.eApprovalEnd.CCPI.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.st_ones.common.docNum.service.DocNumService;
import com.st_ones.common.mail.service.EverMailService;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.sms.service.EverSmsService;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.eversrm.eApproval.eApprovalEnd.CCPI.EApprovalEndCCPI_Mapper;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2014 ST-Ones CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : EApprovalEndBid_Service.java
 * @date 2022. 10. 05.
 * @version 1.0
 */
@Service(value = "eApprovalEndCCPI_Service")
public class EApprovalEndCCPI_Service extends BaseService {

    @Autowired private MessageService msg;
    @Autowired private DocNumService docNumService;
	@Autowired private EApprovalEndCCPI_Mapper endCcpi_Mapper;
	@Autowired private EverMailService everMailService;
	@Autowired private EverSmsService everSmsService;
	
	Logger logger = LoggerFactory.getLogger(this.getClass());
	/**
	 * 모듈명 : 전자근로계약_도급[TC1]
	 * 처리내용 : SIGN_STATUS, SIGN_DATE, PROGRESS_CD 변경.
	 */
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String endApproval(String buyerCd, String appDocNum, String appDocCnt, String signStatus) throws Exception {

		Map<String, String> param = new HashMap<>();
		param.put("BUYER_CD", buyerCd);
		param.put("APP_DOC_NUM", appDocNum);
		param.put("APP_DOC_CNT", appDocCnt);
		param.put("SIGN_STATUS", signStatus);

		// 결재번호에 해당하는 입찰번호 가져오기
		Map<String, String> bidMap = endCcpi_Mapper.getContNum(param);
		param.put("CONT_NUM", bidMap.get("CONT_NUM"));
		param.put("CONT_CNT", String.valueOf(bidMap.get("CONT_CNT")));
		
		endCcpi_Mapper.setCcpiSignStatus(param);

		String rtnMsg = (signStatus.equals("E") ? msg.getMessage("0057")
				: (signStatus.equals("R") ? msg.getMessage("0058")
				: (signStatus.equals("C") ? msg.getMessage("0061")
				: msg.getMessage("0001"))));

		if (signStatus.equals("E")) {

			try {
				// 개인근로자에게 Mail/SMS 발송.
				String linkUrl = PropertiesManager.getString("eversrm.urls.maintain.real") ;
				
				// MAIL
				Map<String, String> mailTargetrInfo = endCcpi_Mapper.getMailTargetList(param);
				//String subject = "[전자구매시스템] 고객사 ["+ sendVendorInfo.get("PR_BUYER_DEPT_NMS") +"]에서 ["+ sendVendorInfo.get("CONT_DESC") +"] 관련 전자계약서를 발송하였습니다";
				String subject = "[전자근로계약시스템] 고객사 [" + mailTargetrInfo.get("BUYER_NM") + "]에서 근로계약 체결건이 전송되었습니다";
				
				String contents = "<BR> 안녕하세요." +
						"<BR>"+ mailTargetrInfo.get("USER_NM") +" 님." +
						"<BR> " +
						"<BR> 귀하에게 새로운 근로계약 체결 건이 전송 되었습니다.	" +
						"<BR> 회사 : ["+ mailTargetrInfo.get("BUYER_NM") + "]" +
						"<BR> 계약명 : ["+ mailTargetrInfo.get("CONT_DESC") + "]" +
						"<BR> 계약번호	 	: [" + mailTargetrInfo.get("CONT_NUM")  + "]" +
						"<BR> 계약담당자	: [" + String.valueOf(EverString.nullToEmptyString(mailTargetrInfo.get("CONT_USER_NM"))) + "]"+
						"<BR> 요청기일 : ["+ mailTargetrInfo.get("CONT_DATE") + "]" +
						"<BR> " +
			            "<BR> 전자근로계약시스템에 <a href='" + linkUrl + "' target='newP'>로그인</a> 하시어, 세부내용을 확인 후 처리 해주십시오." +
			            "<BR> " +
			            "<BR> 감사합니다.";
				
				param.put("SUBJECT", subject);
				param.put("CONTENTS", contents);
				param.put("REF_MODULE_CD", "MPI01");
				//param.put("DIRECT_TARGET", mailTargetrInfo.get("VENDOR_PIC_USER_EMAIL"));
				//param.put("DIRECT_USER_NM", mailTargetrInfo.get("VENDOR_PIC_USER_NM"));
				everMailService.SendMail(param);
				
				// SMS
				Map<String,String> smsMap = new HashMap<String,String>();
				smsMap.put("CONTENTS", subject);
				smsMap.put("REF_MODULE_CD", "SPI01");
				//smsMap.put("DIRECT_TARGET", mailTargetrInfo.get("VENDOR_PIC_USER_EMAIL"));
				//smsMap.put("DIRECT_USER_NM", mailTargetrInfo.get("VENDOR_PIC_USER_NM"));
				
				// 2022.10.06 : 전자계약서 결재완료시 SMS 수수료 부과
				smsMap.put("CORP_NO", mailTargetrInfo.get("CORP_NO"));			// 고객사 사업자번호
				smsMap.put("BRC", mailTargetrInfo.get("BRC"));					// 고객사 부서
				smsMap.put("EPRO_PS_DSC", "1");									// 1  : 구매
				smsMap.put("EPRO_WRS_DS", "52");		// epro_wrs_ds [상품코드] - 10 : RFI, 20 : 입찰, 30 : 일반입찰계약, 40 : 일반수의계약, 50 : BtoC계약, 60 : 위임계약, 70 : 문서보관, 80 : SMS, 90 : LMS, 100 : 문서생성
                smsMap.put("EPRO_RATE_DSC", "01");								// 01 : 최초
				smsMap.put("APLY_DT", mailTargetrInfo.get("APLY_DT"));			// 발생일 YYYYMMDD
				smsMap.put("USER_ID", mailTargetrInfo.get("USER_ID"));			// 고객사 보내는사람 ID
				smsMap.put("CONT_TBL_ID", "STOCTCCT");							// 검증 테이블
				smsMap.put("CONT_TBL_PK", mailTargetrInfo.get("CONT_TBL_PK")); 	// 검증 조건(협력사별 입찰번호)
				smsMap.put("tmp", mailTargetrInfo.get("CONT_TBL_PK"));			// myBatis 버그 해결을 위한 무의미한, 유니크한 값.
				smsMap.put("payFlag", "Y");
				
				everSmsService.sendSmsNhe(smsMap);
			}
			catch (Exception ex) {
			    logger.error("전자계약 결재승인 후 메일&문자 발송 오류 : " + ex.getMessage());
			}
		}
		return rtnMsg;
	}
}


