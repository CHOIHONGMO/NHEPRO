package com.st_ones.eversrm.eApproval.eApprovalEnd.CCTR.service;

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
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.eversrm.eApproval.eApprovalEnd.CCTR.EApprovalEndCCTR_Mapper;

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
 * @date 2020. 4. 02.
 * @version 1.0
 */
@Service(value = "eApprovalEndCCTR_Service")
public class EApprovalEndCCTR_Service extends BaseService {

    @Autowired private MessageService msg;
    @Autowired private DocNumService docNumService;
	@Autowired private EApprovalEndCCTR_Mapper endCctr_Mapper;
	@Autowired private EverMailService everMailService;
	@Autowired private EverSmsService everSmsService;
	
	Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String endApproval_FORMNO(String buyerCd, String appDocNum, String appDocCnt, String signStatus) throws Exception {

		Map<String, String> param = new HashMap<>();
		param.put("BUYER_CD", buyerCd);
		param.put("APP_DOC_NUM", appDocNum);
		param.put("APP_DOC_CNT", appDocCnt);
		param.put("SIGN_STATUS", signStatus);

		endCctr_Mapper.setCctrSignStatus_FORMNO(param);

		String rtnMsg = (signStatus.equals("E") ? msg.getMessage("0057")
				: (signStatus.equals("R") ? msg.getMessage("0058")
				: (signStatus.equals("C") ? msg.getMessage("0061")
				: msg.getMessage("0001"))));

		return rtnMsg;
	}

	public String endApproval_EC(String buyerCd, String appDocNum, String appDocCnt, String signStatus) throws Exception {

		Map<String, String> param = new HashMap<>();
		param.put("BUYER_CD", buyerCd);
		param.put("APP_DOC_NUM", appDocNum);
		param.put("APP_DOC_CNT", appDocCnt);
		param.put("SIGN_STATUS", signStatus);

		endCctr_Mapper.setCctrSignStatus_EC(param);

		String rtnMsg = (signStatus.equals("E") ? msg.getMessage("0057")
				: (signStatus.equals("R") ? msg.getMessage("0058")
				: (signStatus.equals("C") ? msg.getMessage("0061")
				: msg.getMessage("0001"))));

		if (signStatus.equals("E")) {
			List<Map<String, Object>> eccmList =  endCctr_Mapper.getCtEccmInfo(param);
			if (eccmList != null && eccmList.size() > 0) {
				// 2021.09.29 추가
				// 계약서 협력사 반려 이후 다시 결재를 진행하는 경우가 있으므로, 해당 계약건으로 생성된 발주서 삭제처리함.
				endCctr_Mapper.deletePohd(param);
				endCctr_Mapper.deletePodt(param);
				
				for(Map<String, Object> eccmData : eccmList) {
					eccmData.put("PO_NUM", docNumService.getDocNumber(buyerCd, "PO"));
					endCctr_Mapper.insertPohd(eccmData);
					endCctr_Mapper.insertPodt(eccmData);
					endCctr_Mapper.insertPopy(eccmData);
					endCctr_Mapper.insertPopc(eccmData);
				}
			}
			
			// 2021.01.25 계약서 협력사 전송후 PRDT의 구매진행상태=4200(전자계약중)
			endCctr_Mapper.setPrProgressCd(param);
			
			try {
				String linkUrl = PropertiesManager.getString("eversrm.urls.maintain.real") ;
				
				// MAIL
				Map<String, String> sendVendorInfo = endCctr_Mapper.getSendVendorInfo(param);
				String subject = "[전자구매시스템] 고객사 ["+ sendVendorInfo.get("PR_BUYER_DEPT_NMS") +"]에서 ["+ sendVendorInfo.get("CONT_DESC") +"] 관련 전자계약서를 발송하였습니다";
				
				String contents = "<BR> 안녕하세요." +
						"<BR> ["+ sendVendorInfo.get("VENDOR_NM") +"] "+ sendVendorInfo.get("VENDOR_PIC_USER_NM") +" 님." +
						"<BR> " +
						"<BR> 아래와 같이 고객사에서 전자계약 체결을 요청 하였습니다." +
						"<BR> 고객사 : ["+ sendVendorInfo.get("PR_BUYER_DEPT_NMS") + "]" +
						"<BR> 계약명 : ["+ sendVendorInfo.get("CONT_DESC") + "]" +
						"<BR> 요청기일 : ["+ sendVendorInfo.get("CONT_DATE") + "]" +
						"<BR> " +
			            "<BR> 전자구매시스템에 <a href='" + linkUrl + "' target='newP'>로그인</a> 하시어, 세부내용을 확인 후 처리 해주십시오." +
			            "<BR> " +
			            "<BR> 감사합니다.";
				
				param.put("SUBJECT", subject);
				param.put("CONTENTS", contents);
				param.put("REF_MODULE_CD", "MCONT02");
				param.put("DIRECT_TARGET", sendVendorInfo.get("VENDOR_PIC_USER_EMAIL"));
				param.put("DIRECT_USER_NM", sendVendorInfo.get("VENDOR_PIC_USER_NM"));
				//개발테스트시에는 잠시 주석
				//everMailService.SendMail(param);
				
				// SMS
				Map<String,String> smsMap = new HashMap<String,String>();
				smsMap.put("CONTENTS", subject);
				smsMap.put("REF_MODULE_CD", "SCONT02");
				smsMap.put("DIRECT_TARGET", sendVendorInfo.get("VENDOR_PIC_USER_EMAIL"));
				smsMap.put("DIRECT_USER_NM", sendVendorInfo.get("VENDOR_PIC_USER_NM"));
				
				// 2021.06.30 : 전자계약서 결재완료시 SMS 수수료 부과
				smsMap.put("CORP_NO", sendVendorInfo.get("CORP_NO"));			// 고객사 사업자번호
				smsMap.put("BRC", sendVendorInfo.get("BRC"));					// 고객사 부서
				smsMap.put("EPRO_PS_DSC", "1");									// 1  : 구매
                smsMap.put("EPRO_RATE_DSC", "01");								// 01 : 최초
				smsMap.put("APLY_DT", sendVendorInfo.get("APLY_DT"));			// 발생일 YYYYMMDD
				smsMap.put("USER_ID", sendVendorInfo.get("USER_ID"));			// 고객사 보내는사람 ID
				smsMap.put("CONT_TBL_ID", "STOCECCT");							// 검증 테이블
				smsMap.put("CONT_TBL_PK", sendVendorInfo.get("CONT_TBL_PK")); 	// 검증 조건(협력사별 입찰번호)
				smsMap.put("tmp", sendVendorInfo.get("CONT_TBL_PK"));			// myBatis 버그 해결을 위한 무의미한, 유니크한 값.
				smsMap.put("payFlag", "Y");
				
				//개발테스트시에는 잠시 주석
				//everSmsService.sendSmsNhe(smsMap);
			}
			catch (Exception ex) {
			    logger.error("전자계약 결재승인 후 메일&문자 발송 오류 : " + ex.getMessage());
			}
		}
		return rtnMsg;
	}
}


