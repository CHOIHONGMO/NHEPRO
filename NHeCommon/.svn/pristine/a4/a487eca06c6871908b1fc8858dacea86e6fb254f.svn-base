package com.st_ones.eversrm.eApproval.eApprovalEnd.PCONT.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.st_ones.common.mail.service.EverMailService;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.sms.service.EverSmsService;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.eversrm.eApproval.eApprovalEnd.PCONT.EApprovalEndPcont_Mapper;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2014 ST-Ones CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : EApprovalEndPcont_Service.java
 * @date 2020. 4. 02.
 * @version 1.0
 */
@Service(value = "eApprovalEndPcont_Service")
public class EApprovalEndPcont_Service extends BaseService {

    @Autowired private MessageService msg;
	@Autowired private EverMailService evermailservice;
	@Autowired private EverSmsService eversmsservice;
	@Autowired private EApprovalEndPcont_Mapper endPcont_Mapper;
	
	Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/**
	 * 모듈명 : 개인근로 [PCONT]
	 * 처리내용 : SIGN_STATUS, SIGN_DATE, PROGRESS_CD 변경.
	 */
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String endApproval(String buyerCd, String appDocNum, String appDocCnt, String signStatus) throws Exception {

		Map<String, String> param = new HashMap<String, String>();
		param.put("BUYER_CD", buyerCd);
		param.put("APP_DOC_NUM", appDocNum);
		param.put("APP_DOC_CNT", appDocCnt);
		param.put("SIGN_STATUS", signStatus);

		// 결재번호에 해당하는 입찰번호 가져오기
		Map<String, String> bidMap = endPcont_Mapper.getContNum(param);
		param.put("CONT_NUM", bidMap.get("CONT_NUM"));
		param.put("CONT_CNT", String.valueOf(bidMap.get("CONT_CNT")));

		// STOCPCCT.SIGN_STATUS 변경
		endPcont_Mapper.setContSignStatus(param);
		
		String rtnMsg = (signStatus.equals("E") ? msg.getMessage("0057")
					  : (signStatus.equals("R") ? msg.getMessage("0058")
					  : (signStatus.equals("C") ? msg.getMessage("0061")
					  : msg.getMessage("0001"))));

		// signStatus = 'E'인 경우...
		if(signStatus.equals("E")) {
			try {
				// 개인근로자에게 Mail/SMS 발송.
				String linkUrl = PropertiesManager.getString("eversrm.urls.maintain.real") ;
				
				List<Map<String, String>> mailTargetList = endPcont_Mapper.getMailTargetList(param);
				for(Map<String, String> mailTargetData : mailTargetList) {
					
					String subject = "[전자구매시스템] 고객사 [" + mailTargetData.get("BUYER_NM") + "]에서 근로계약 체결건이 전송되었습니다";
					
					Map<String, String> mailMap = new HashMap<String, String>();
					mailMap.put("SUBJECT", subject);
					
					StringBuffer content = new StringBuffer(255);
					content.append("<BR> 안녕하세요.																								");
					content.append("<BR> " + mailTargetData.get("WORKER_NM") + " 님.																");
					content.append("<BR>																										");
					content.append("<BR> 귀하에게 새로운 근로계약 체결 건이 전송 되었습니다																		");
					content.append("<BR> 회사 	 	: [" + mailTargetData.get("BUYER_NM") + "]													");
					content.append("<BR> 계약번호	 	: [" + mailTargetData.get("CONT_NUM") + "]													");
					content.append("<BR> 계약명 	 	: [" + mailTargetData.get("CONT_DESC") + "]													");
					content.append("<BR> 계약담당자	: [" + String.valueOf(EverString.nullToEmptyString(mailTargetData.get("CONT_USER_NM"))) + " (TEL : " + String.valueOf(EverString.nullToEmptyString(mailTargetData.get("CONT_TEL_NUM"))) + "]												");
					content.append("<BR>																										");
					content.append("<BR> 전자구매시스템에 <a href=\"" + linkUrl + "\" target=\"newP\">로그인</a> 하시어, 세부내용을 확인 후 처리 바랍니다.			");
					content.append("<BR>																										");
					content.append("<BR> 감사합니다.																								");
                    
					mailMap.put("CONTENTS", content.toString());
					mailMap.put("REF_MODULE_CD", "PC");
					mailMap.put("REF_NUM", mailTargetData.get("CONT_NUM"));
					mailMap.put("RECV_USER_ID", mailTargetData.get("WORKER_ID"));
					evermailservice.SendMail(mailMap);
					
					// SMS발송
					Map<String, String> smsMap = new HashMap<String, String>();
					smsMap.put("CONTENTS", subject);
					smsMap.put("REF_MODULE_CD", "PC");
					smsMap.put("RECV_USER_ID", mailTargetData.get("WORKER_ID"));
					
					// 2021.06.30 : 전자계약서 결재완료시 SMS 수수료 부과
					smsMap.put("CORP_NO", mailTargetData.get("CORP_NO"));			// 고객사 사업자번호
					smsMap.put("BRC", mailTargetData.get("BRC"));					// 고객사 부서
					smsMap.put("EPRO_PS_DSC", "1");									// 1  : 구매
	                smsMap.put("EPRO_RATE_DSC", "01");								// 01 : 최초
					smsMap.put("APLY_DT", mailTargetData.get("APLY_DT"));			// 발생일 YYYYMMDD
					smsMap.put("USER_ID", mailTargetData.get("USER_ID"));			// 고객사 보내는사람 ID
					smsMap.put("CONT_TBL_ID", "STOCPCWU");							// 검증 테이블
					smsMap.put("CONT_TBL_PK", mailTargetData.get("CONT_TBL_PK")); 	// 검증 조건(협력사별 입찰번호)
					smsMap.put("tmp", mailTargetData.get("CONT_TBL_PK"));			// myBatis 버그 해결을 위한 무의미한, 유니크한 값.
					smsMap.put("payFlag", "Y");
					
					eversmsservice.sendSmsNhe(smsMap);
				}
			}
			catch (Exception ex) {
			    logger.error("개인근로계약 결재승인 후 메일&문자 발송 오류 : " + ex.getMessage());
			}
        }
		return rtnMsg;
	}

}
