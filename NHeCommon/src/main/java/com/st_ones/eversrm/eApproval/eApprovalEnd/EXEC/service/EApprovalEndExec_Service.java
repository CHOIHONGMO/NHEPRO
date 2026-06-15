package com.st_ones.eversrm.eApproval.eApprovalEnd.EXEC.service;

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
import com.st_ones.eversrm.eApproval.eApprovalEnd.EXEC.EApprovalEndExec_Mapper;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2014 ST-Ones CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : EApprovalEndExec_Service.java
 * @date 2020. 4. 02.
 * @version 1.0
 */
@Service(value = "eApprovalEndExec_Service")
public class EApprovalEndExec_Service extends BaseService {

    @Autowired private MessageService msg;
	@Autowired private EverMailService evermailservice;
	@Autowired private EverSmsService eversmsservice;
    @Autowired private DocNumService docNumService;
	@Autowired private EApprovalEndExec_Mapper endExec_Mapper;
	
	Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/**
	 * 모듈명 : 선정품의 [EXEC]
	 * 처리내용 : SIGN_STATUS, SIGN_DATE, PROGRESS_CD 변경.
	 */
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String endApproval(String buyerCd, String appDocNum, String appDocCnt, String signStatus) throws Exception {

		Map<String, String> param = new HashMap<String, String>();
		param.put("BUYER_CD", buyerCd);
		param.put("APP_DOC_NUM", appDocNum);
		param.put("APP_DOC_CNT", appDocCnt);
		param.put("SIGN_STATUS", signStatus);

		// 결재번호에 해당하는 품의번호 가져오기
		Map<String, String> bidMap = endExec_Mapper.getExecNum(param);
		param.put("EXEC_NUM", bidMap.get("EXEC_NUM"));

		// STOCCNHD.SIGN_STATUS 변경
		endExec_Mapper.setExecSignStatus(param);
		if(signStatus.equals("E")) {
			// STOCCNDT.PROGRESS_CD = '3200'(품의완료)로 변경
			param.put("PROGRESS_CD", "3200");
			endExec_Mapper.setProgressCd(param);
			
			// 구매품의 결재승인 후 PRDT의 구매진행상태 = 3200(품의완료)로 변경
			endExec_Mapper.setPrProgressCd(param);
			
			// 계약 대기정보[STOCECHB]를 생성한다.
			List<Map<String, Object>> targetList = endExec_Mapper.getTargetList(param);
			for(Map<String, Object> targetData : targetList) {

				// 채번로직 변경. Parameter [화면에서 전달 받은 COMPANY_CD (없는 경우, ses.manageCd 또는 ses.companyCd), DOC_TYPE ]
				String contWtNum = docNumService.getDocNumber(buyerCd, "CWT");
				targetData.put("CONT_WT_NUM", contWtNum);

				endExec_Mapper.insertECHB(targetData);
			}

			// 메일발송
			try {
				sendBidMail(param);
			}
			catch (Exception ex) {
			    logger.error("입찰/견적품의 결재승인 후 메일&문자 발송 오류 : " + ex.getMessage());
			}
		}

		String rtnMsg = (signStatus.equals("E") ? msg.getMessage("0057")
						: (signStatus.equals("R") ? msg.getMessage("0058")
						: (signStatus.equals("C") ? msg.getMessage("0061")
						: msg.getMessage("0001"))));

		return rtnMsg;
	}
	
	// 이메일 발송(입찰 품의 승인)
	public void sendBidMail(Map<String, String> param) throws Exception {
		
		// 협력업체 담당자에게 Mail/SMS 발송.
		// 입찰과 견적을 묶어서 업체선정 품의를 작성할 수 있기 때문에 입찰, 견적 따로 List를 가져와 Mail/SMS를 보낸다.
		String linkUrl = PropertiesManager.getString("eversrm.urls.maintain.real") ;

		/**
		// 입찰 >> 낙찰시 전송으로 변경.
		String bidExSqStr = EverString.nullToEmptyString(endExec_Mapper.getBidExSq(param));
		if(bidExSqStr != null && !bidExSqStr.equals("")) {

			param.put("paramExSq", EverString.forInQuery(bidExSqStr, "@@"));
			List<Map<String, String>> mailTargetList = endExec_Mapper.getBidMailTargetList(param);
			
			for (Map<String, String> mailTargetData : mailTargetList) {

				if (mailTargetData.get("RECV_USER_ID") != null && !EverString.nullToEmptyString(mailTargetData.get("RECV_USER_ID")).equals("")) {

					Map<String, String> mailMap = new HashMap<String, String>();
					mailMap.put("SUBJECT", "[전자구매시스템] 고객사[" + mailTargetData.get("PR_BUYER_NM") + "]에서 실시한 입찰[" + mailTargetData.get("ANN_ITEM") + "]의 결과가 발표 되었습니다");
					mailMap.put("REF_MODULE_CD", "MBID02");
					mailMap.put("REF_NUM", param.get("EXEC_NUM"));
					mailMap.put("RECV_USER_ID", mailTargetData.get("RECV_USER_ID"));

					StringBuffer content = new StringBuffer(255);
					content.append("<BR> 안녕하십니까!																							");
					content.append("<BR> [" + mailTargetData.get("VENDOR_NM") + "] [" + mailTargetData.get("RECV_USER_NM") + "]님			");
					content.append("<BR>																									");
					content.append("<BR> 아래와 같이 고객사에서 실시한 입찰결과가 발표 되었습니다.															");
					content.append("<BR> 고객사 : [" + mailTargetData.get("PR_BUYER_NM") + "]													");
					content.append("<BR> 입찰명 : [" + mailTargetData.get("ANN_ITEM") + "]														");
					content.append("<BR> 공고기간 : [" + mailTargetData.get("ANN_FROM_DATE") + " ~ " + mailTargetData.get("ANN_TO_DATE") + "]	");
					content.append("<BR> 입찰일 : [" + mailTargetData.get("BID_END_DATE") + "]													");
					content.append("<BR> 계약방법 : [" + mailTargetData.get("CONT_TYPE1_LOC") + "]												");
					content.append("<BR> 낙찰자결정방법 : [" + mailTargetData.get("CONT_TYPE2_LOC") + "]											");
					content.append("<BR> 입찰회차 : [" + String.valueOf(mailTargetData.get("VOTE_CNT")) + "회차]								");
					content.append("<BR> 입찰결과 : [" + mailTargetData.get("SETTLE_FLAG_LOC") + "]											");
					content.append("<BR> 낙찰자 : [" + mailTargetData.get("SETTLE_VENDOR_NM") + "]												");
					content.append("<BR>																									");
					content.append("<BR> 전자구매시스템에 <a href=\"" + linkUrl + "\" target=\"newP\">로그인</a> 하시어, 세부내용을 확인 해주십시오.			");
					content.append("<BR>																									");
					content.append("<BR> 감사합니다.																							");
					mailMap.put("CONTENTS", content.toString());

					evermailservice.SendMail(mailMap);

					Map<String, String> smsMap = new HashMap<String, String>();
					smsMap.put("CONTENTS", "[전자구매시스템] 고객사[" + mailTargetData.get("PR_BUYER_NM") + "]에서 실시한 입찰[" + mailTargetData.get("ANN_ITEM") + "]의 결과가 발표 되었습니다");
					smsMap.put("REF_MODULE_CD", "SBID02");
					smsMap.put("RECV_USER_ID", mailTargetData.get("RECV_USER_ID"));

					eversmsservice.sendSmsNhe(smsMap);
				}
			}
		}
		*/
		
		// 견적, 수의시담
		String rfxExSqStr = EverString.nullToEmptyString(endExec_Mapper.getRfxExSq(param));
		if(rfxExSqStr != null && !rfxExSqStr.equals("")) {

			param.put("paramExSq", EverString.forInQuery(rfxExSqStr, "@@"));
			
			List<Map<String, String>> mailTargetList = endExec_Mapper.getRfxMailTargetList(param);
			for (Map<String, String> mailTargetData : mailTargetList) {

				if (mailTargetData.get("RECV_USER_ID") != null && !EverString.nullToEmptyString(mailTargetData.get("RECV_USER_ID")).equals("")) {
					String subject = "[전자구매시스템] 고객사 [" + mailTargetData.get("PR_BUYER_NM") + "]에서 실시한 견적 [" + mailTargetData.get("ANN_ITEM") + "]의 결과가 발표되었습니다";
					
					Map<String, String> mailMap = new HashMap<String, String>();
					mailMap.put("SUBJECT", subject);
					
					StringBuffer content = new StringBuffer(255);
					content.append("<BR> 안녕하세요.																							");
					content.append("<BR> [" + mailTargetData.get("VENDOR_NM") + "] " + mailTargetData.get("RECV_USER_NM") + " 님.			");
					content.append("<BR>																									");
					content.append("<BR> 아래와 같이 고객사에서 실시한 견적의 결과가 발표 되었습니다.															");
					content.append("<BR> 고객사 : [" + mailTargetData.get("PR_BUYER_NM") + "]													");
					content.append("<BR> 견적명 : [" + mailTargetData.get("RFX_NUM") + "] " + mailTargetData.get("ANN_ITEM") + "				");
					content.append("<BR> 공고기간 : [" + mailTargetData.get("ANN_FROM_DATE") + " ~ " + mailTargetData.get("ANN_TO_DATE") + "]	");
					content.append("<BR> 요청구분 : [" + mailTargetData.get("RFX_TYPE_LOC") + "]												");
					content.append("<BR> 금액구분 : [" + mailTargetData.get("AMT_TYPE_LOC") + "]												");
					content.append("<BR> 견적결과 : [낙찰]																						");
					content.append("<BR> 낙찰자 : [" + mailTargetData.get("VENDOR_NM") + "]													");
					content.append("<BR>																									");
					content.append("<BR> 전자구매시스템에 <a href=\"" + linkUrl + "\" target=\"newP\">로그인</a> 하시어, 세부내용을 확인 해주십시오.			");
					content.append("<BR>																									");
					content.append("<BR> 감사합니다.																							");
					
					mailMap.put("CONTENTS", content.toString());
					mailMap.put("REF_MODULE_CD", "MRFX02");
					mailMap.put("REF_NUM", param.get("EXEC_NUM"));
					mailMap.put("RECV_USER_ID", mailTargetData.get("RECV_USER_ID"));
					evermailservice.SendMail(mailMap);

					Map<String, String> smsMap = new HashMap<String, String>();
					smsMap.put("CONTENTS", subject);
					smsMap.put("REF_MODULE_CD", "SRFX02");
					smsMap.put("RECV_USER_ID", mailTargetData.get("RECV_USER_ID"));
					
					// 2021.06.30 : 견적/수의시담 선정품의 결재완료시 SMS 수수료 부과
					smsMap.put("CORP_NO", mailTargetData.get("CORP_NO"));			// 고객사 사업자번호
					smsMap.put("BRC", mailTargetData.get("BRC"));					// 고객사 부서
					smsMap.put("EPRO_PS_DSC", "1");									// 1  : 구매
                    smsMap.put("EPRO_RATE_DSC", "01");								// 01 : 최초
					smsMap.put("APLY_DT", mailTargetData.get("APLY_DT"));			// 발생일 YYYYMMDD
					smsMap.put("USER_ID", mailTargetData.get("USER_ID"));			// 고객사 보내는사람 ID
					smsMap.put("CONT_TBL_ID", "STOCCNVD");							// 검증 테이블
					smsMap.put("CONT_TBL_PK", mailTargetData.get("CONT_TBL_PK")); 	// 검증 조건(협력사별 입찰번호)
					smsMap.put("tmp", mailTargetData.get("CONT_TBL_PK"));			// myBatis 버그 해결을 위한 무의미한, 유니크한 값.
					smsMap.put("payFlag", "Y");
					
					eversmsservice.sendSmsNhe(smsMap);
				}
			}
		}
	}
}


