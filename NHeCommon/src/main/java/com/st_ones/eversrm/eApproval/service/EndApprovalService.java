package com.st_ones.eversrm.eApproval.service;

import java.util.HashMap;
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
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.eversrm.eApproval.EApprovalMapper;
import com.st_ones.eversrm.eApproval.eApprovalEnd.AP.service.EApprovalEndAp_Service;
import com.st_ones.eversrm.eApproval.eApprovalEnd.BID.service.EApprovalEndBid_Service;
import com.st_ones.eversrm.eApproval.eApprovalEnd.CCTR.service.EApprovalEndCCTR_Service;
import com.st_ones.eversrm.eApproval.eApprovalEnd.ESTM.service.EApprovalEndESTM_Service;
import com.st_ones.eversrm.eApproval.eApprovalEnd.ETST.service.EApprovalEndEtst_Service;
import com.st_ones.eversrm.eApproval.eApprovalEnd.EXEC.service.EApprovalEndExec_Service;
import com.st_ones.eversrm.eApproval.eApprovalEnd.INV.service.EApprovalEndInv_Service;
import com.st_ones.eversrm.eApproval.eApprovalEnd.PCONT.service.EApprovalEndPcont_Service;
import com.st_ones.eversrm.eApproval.eApprovalEnd.PO.service.EApprovalEndPo_Service;
import com.st_ones.eversrm.eApproval.eApprovalEnd.PR.service.EApprovalEndPr_Service;
import com.st_ones.eversrm.eApproval.eApprovalEnd.RFQ.service.EApprovalEndRfq_Service;
import com.st_ones.eversrm.eApproval.eApprovalEnd.CCPI.service.EApprovalEndCCPI_Service;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2014 ST-Ones CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : EndApprovalService.java
 * @date 2018. 2. 06.
 * @version 1.0
 */
@Service(value = "endApprovalService")
public class EndApprovalService extends BaseService {

	private enum DOC_TYPE{ PR, BID, BIDRLT, RFXRLT, NEGORLT, FORMNO, CANCELBID , ESTM, PO, EC, EC2, INV, DINV, AP, RFQ, EXEC, PCONT, ETST, TC1, TC2, TC3, TC4 }

    @Autowired private MessageService msg;
    @Autowired private EverSmsService eversmsservice;
    @Autowired private EverMailService evermailservice;
	@Autowired private EApprovalMapper eApprovalMapper;
    @Autowired private EApprovalEndPr_Service endPr;		// 구매의뢰
    @Autowired private EApprovalEndBid_Service endBid;		// 입찰공고
	@Autowired private EApprovalEndESTM_Service endEstm; 	// 예가 결재
    @Autowired private EApprovalEndCCTR_Service endCctr; 	// 서식 결재상신
    @Autowired private EApprovalEndPo_Service endPo;		// 발주
	@Autowired private EApprovalEndInv_Service endInv;		// 검수요청
	@Autowired private EApprovalEndAp_Service endAp;		// 대금지급요청
	@Autowired private EApprovalEndRfq_Service endRfq;		// 견적요청서
	@Autowired private EApprovalEndExec_Service endExec;	// 선정품의
	@Autowired private EApprovalEndPcont_Service endPcont;	// 개인근로
	@Autowired private EApprovalEndEtst_Service endEtst;	// 위임장	
	/*2022.10.06 전자근로계약_파트너스 추가*/
	@Autowired private EApprovalEndCCPI_Service endCcpi;	// 개인근로 
	
	
	Logger logger = LoggerFactory.getLogger(this.getClass());
	
	// 결재완료(sign_status = 'E')인 경우, 후처리
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String doAfterApprove(String docTypeString, String buyerCd, String appDocNum, String appDocCnt,String regUserId) throws Exception {

		DOC_TYPE docType = DOC_TYPE.valueOf(docTypeString);
		String message = null;
		/* @formatter:off */
		switch (docType) {
			// 구매의뢰
			case PR: message = endPr.endApproval(buyerCd, appDocNum, appDocCnt, "E"); break;
			// 입찰공고
			case BID: message = endBid.endApproval(buyerCd, appDocNum, appDocCnt, "E"); break;
			// 취소공고
			case CANCELBID: message = endBid.endCancelApproval(buyerCd, appDocNum, appDocCnt, "E"); break;
			// 입찰결과보고
			case BIDRLT: message = endBid.endBidRltApproval(buyerCd, appDocNum, appDocCnt, "E"); break;
			// 수의결과보고
			case RFXRLT: message = endRfq.endRfxRltApproval(buyerCd, appDocNum, appDocCnt, "E"); break;
			// 우선협상자선정결과
			case NEGORLT: message = endBid.endNegoRltApproval(buyerCd, appDocNum, appDocCnt, "E"); break;
			// 평가
			case ESTM: message = endEstm.endApproval(buyerCd, appDocNum, appDocCnt, "E"); break;
			// 서식 결재상신
			case FORMNO: message = endCctr.endApproval_FORMNO(buyerCd, appDocNum, appDocCnt, "E"); break;
			// 발주
			case PO: message = endPo.endApproval(buyerCd, appDocNum, appDocCnt, "E"); break;
			// 계약서 결재상신
			case EC: message = endCctr.endApproval_EC(buyerCd, appDocNum, appDocCnt, "E"); break;
			// 계약서(다수) 결재상신
			case EC2: message = endCctr.endApproval_EC(buyerCd, appDocNum, appDocCnt, "E"); break;
			// 검수요청
			case INV:
			case DINV: message = endInv.endApproval(buyerCd, appDocNum, appDocCnt, "E"); break;
			// 대금지급요청
			case AP: message = endAp.endApproval(buyerCd, appDocNum, appDocCnt, "E"); break;
			// 견적요청서
			case RFQ: message = endRfq.endApproval(buyerCd, appDocNum, appDocCnt, "E"); break;
			// 선정품의
			case EXEC: message = endExec.endApproval(buyerCd, appDocNum, appDocCnt, "E"); break;
			// 개인근로
			case PCONT: message = endPcont.endApproval(buyerCd, appDocNum, appDocCnt, "E"); break;
			// 위임장
			case ETST: message = endEtst.endApproval(buyerCd, appDocNum, appDocCnt, "E"); break;
			//파트너스_근로계약(도급)
			case TC1: message = endCcpi.endApproval(buyerCd, appDocNum, appDocCnt, "E"); break;
			//파트너스_근로계약(단기간)
			case TC2: message = endCcpi.endApproval(buyerCd, appDocNum, appDocCnt, "E"); break;
			//파트너스_근로계약(일용직)
			case TC3: message = endCcpi.endApproval(buyerCd, appDocNum, appDocCnt, "E"); break;
			//파트너스_근로계약(파견)
			case TC4: message = endCcpi.endApproval(buyerCd, appDocNum, appDocCnt, "E"); break;
			// 기본
			default: throw new Exception(msg.getMessageForService(this, "no_matched_doc"));
		}

		try {
			Map<String,String> param = new HashMap<String,String>();
			param.put("BUYER_CD", buyerCd);
			param.put("APP_DOC_NUM", appDocNum);
			param.put("APP_DOC_CNT", appDocCnt);
			Map<String, String> sctmInfo = eApprovalMapper.selectSTOCSCTM(param);
			
			String linkUrl = PropertiesManager.getString("eversrm.urls.maintain.real") ;
			
			String subject = "[전자구매시스템] 상신한 결재문서 [" + sctmInfo.get("SUBJECT") + "]이 [" + sctmInfo.get("NEXT_SIGN_USER_NM") + "]님에게 승인되었습니다 ";
			
			// EMAIL
	        Map<String,String> mailMap = new HashMap<String,String>();
	        mailMap.put("SUBJECT", subject);
	
	        StringBuffer content = new StringBuffer(255);
	        content.append("<BR> 안녕하세요.											                      		");
	        content.append("<BR> [" + sctmInfo.get("BUYER_NM") + "] " + sctmInfo.get("REG_USER_NM") + " 님.    	");
	        content.append("<BR>                   																");
	        content.append("<BR> 아래와 같이 결재문서가 승인되었습니다                            							");
	        content.append("<BR> 제목 : " + sctmInfo.get("SUBJECT") + "          									");
	        content.append("<BR>                   																");
	        content.append("<BR> 전자구매시스템에 <a href=\""+linkUrl+"\" target=\"newP\">로그인</a> 세부내용을 확인 후 처리를 해주십시오.	");
	        content.append("<BR>                   																");
	        content.append("<BR> 감사합니다.          																");
	        
	        mailMap.put("CONTENTS", content.toString());
	        mailMap.put("REF_MODULE_CD", "MSIGN03");
	        mailMap.put("REF_NUM", appDocNum);
	        mailMap.put("RECV_USER_ID", regUserId);
	        //evermailservice.SendMail(mailMap);
			
			// SMS
	        Map<String,String> smsMap = new HashMap<String,String>();
	        // 2021.01.05 SMS 문구 조정
	        smsMap.put("CONTENTS", subject);
            //smsMap.put("CONTENTS", "[전자구매시스템]결재문서번호 (" + sctmInfo.get("APP_DOC_NUM") + ")이 [" + sctmInfo.get("NEXT_SIGN_USER_NM") + "] 님에게 승인되었습니다");
	        smsMap.put("REF_MODULE_CD", "SSIGN03");
	        smsMap.put("REF_NUM", appDocNum);
	        smsMap.put("RECV_USER_ID", regUserId);
	        
	        // 2021.06.29 : 결재상신 SMS 수수료 부과하기
	        smsMap.put("CORP_NO", sctmInfo.get("CORP_NO"));			// 고객사 사업자번호
			smsMap.put("BRC", sctmInfo.get("BRC"));					// 고객사 부서
			smsMap.put("EPRO_PS_DSC", "1");							// 1  : 구매
            smsMap.put("EPRO_RATE_DSC", "01");						// 01 : 최초
			smsMap.put("APLY_DT", sctmInfo.get("APLY_DT"));			// 발생일 YYYYMMDD
			smsMap.put("USER_ID", sctmInfo.get("USER_ID"));			// 고객사 보내는사람 ID
			smsMap.put("CONT_TBL_ID", "STOCSCTM");					// 검증 테이블
			smsMap.put("CONT_TBL_PK", sctmInfo.get("CONT_TBL_PK")); // 검증 조건(협력사별 입찰번호)
			smsMap.put("tmp", sctmInfo.get("CONT_TBL_PK"));			// myBatis 버그 해결을 위한 무의미한, 유니크한 값.
			smsMap.put("payFlag", "Y");								// SMS 과금여부
			
	        //eversmsservice.sendSmsNhe(smsMap);
		}
		catch (Exception ex) {
		    logger.error("결재 승인 후 상신자에게 메일&문자 발송 오류 : " + ex.getMessage());
		}
		
		return message;
	}

	// 결재반려(sign_status = 'R')인 경우, 후처리
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String doAfterReject(String docTypeString, String buyerCd, String appDocNum, String appDocCnt,String regUserId) throws Exception {

		DOC_TYPE docType = DOC_TYPE.valueOf(docTypeString);
		String message = null;
		/* @formatter:off */
		switch (docType) {

			// 구매의뢰
			case PR: message = endPr.endApproval(buyerCd, appDocNum, appDocCnt, "R"); break;
			// 입찰공고
			case BID: message = endBid.endApproval(buyerCd, appDocNum, appDocCnt, "R"); break;
            // 취소공고
            case CANCELBID: message = endBid.endCancelApproval(buyerCd, appDocNum, appDocCnt, "R"); break;
            // 입찰결과보고
            case BIDRLT: message = endBid.endBidRltApproval(buyerCd, appDocNum, appDocCnt, "R"); break;
            // 수의결과보고
         	case RFXRLT: message = endRfq.endRfxRltApproval(buyerCd, appDocNum, appDocCnt, "R"); break;
            // 우선협상결과
            case NEGORLT: message = endBid.endNegoRltApproval(buyerCd, appDocNum, appDocCnt, "R"); break;

			case ESTM: message = endEstm.endApproval(buyerCd, appDocNum, appDocCnt, "R"); break;
			// 서식 결재취소
			case FORMNO: message = endCctr.endApproval_FORMNO(buyerCd, appDocNum, appDocCnt, "R"); break;
			// 발주
			case PO: message = endPo.endApproval(buyerCd, appDocNum, appDocCnt, "R"); break;
			// 계약서 반려
			case EC: message = endCctr.endApproval_EC(buyerCd, appDocNum, appDocCnt, "R"); break;
			// 계약서 반려
			case EC2: message = endCctr.endApproval_EC(buyerCd, appDocNum, appDocCnt, "R"); break;
			// 검수요청
			case INV:
			case DINV: message = endInv.endApproval(buyerCd, appDocNum, appDocCnt, "R"); break;
			// 대금지급요청
			case AP: message = endAp.endApproval(buyerCd, appDocNum, appDocCnt, "R"); break;
			// 견적요청서
			case RFQ: message = endRfq.endApproval(buyerCd, appDocNum, appDocCnt, "R"); break;
			// 선정품의
			case EXEC: message = endExec.endApproval(buyerCd, appDocNum, appDocCnt, "R"); break;
			// 개인근로
			case PCONT: message = endPcont.endApproval(buyerCd, appDocNum, appDocCnt, "R"); break;
			// 위임장
			case ETST: message = endEtst.endApproval(buyerCd, appDocNum, appDocCnt, "R"); break;
			//파트너스_근로계약(도급)
			case TC1: message = endCcpi.endApproval(buyerCd, appDocNum, appDocCnt, "R"); break;
			//파트너스_근로계약(단기간)
			case TC2: message = endCcpi.endApproval(buyerCd, appDocNum, appDocCnt, "R"); break;
			//파트너스_근로계약(일용직)
			case TC3: message = endCcpi.endApproval(buyerCd, appDocNum, appDocCnt, "R"); break;
			//파트너스_근로계약(파견)
			case TC4: message = endCcpi.endApproval(buyerCd, appDocNum, appDocCnt, "R"); break;
			// 기본
			default: throw new Exception(msg.getMessageForService(this, "no_matched_doc"));
		}
		
		try {
			Map<String,String> param = new HashMap<String,String>();
			param.put("BUYER_CD", buyerCd);
			param.put("APP_DOC_NUM", appDocNum);
			param.put("APP_DOC_CNT", appDocCnt);
			Map<String, String> sctmInfo = eApprovalMapper.selectSTOCSCTM(param);
			
			String linkUrl = PropertiesManager.getString("eversrm.urls.maintain.real") ;
	        
			//EMAIL
			String subject = "[전자구매시스템] 상신한 결재문서 [" + sctmInfo.get("SUBJECT") + "]이 [" + sctmInfo.get("NEXT_SIGN_USER_NM") + "]님에게 반려되었습니다.";
			
	        Map<String,String> mailMap = new HashMap<String,String>();
	        mailMap.put("CONTENTS", subject);
	
	        StringBuffer content = new StringBuffer(255);
	        content.append("<BR> 안녕하세요.                      													");
	        content.append("<BR> [" + sctmInfo.get("BUYER_NM") + "] " + sctmInfo.get("REG_USER_NM") + " 님.    	");
	        content.append("<BR>                   																");
	        content.append("<BR> 아래와 같이 결재문서가 반려되었습니다                           										");
	        content.append("<BR> 제목 : [" + sctmInfo.get("SUBJECT") + "]  	         							");
	        content.append("<BR> 반려자 : [" + sctmInfo.get("NEXT_SIGN_USER_NM") + "]   							");
	        content.append("<BR> 반려내용 : [" + sctmInfo.get("SIGN_RMK") + "]                 		 			");
	        content.append("<BR>                   																");
	        content.append("<BR> 전자구매시스템에 <a href=\""+linkUrl+"\" target=\"newP\">로그인</a> 세부내용을 확인 후, 사후 처리를 해주십시오.  ");
	        content.append("<BR>                   																");
	        content.append("<BR> 감사합니다.                                          								");
	        
	        mailMap.put("CONTENTS", content.toString());
	        mailMap.put("REF_MODULE_CD", "MSIGN03");
	        mailMap.put("REF_NUM", appDocNum);
	        mailMap.put("RECV_USER_ID", regUserId);
	        evermailservice.SendMail(mailMap);
			
			//SMS
	        Map<String,String> smsMap = new HashMap<String,String>();
	        // 2021.01.05 SMS 문구 조정
	        smsMap.put("CONTENTS", subject);
            //smsMap.put("CONTENTS", "[전자구매시스템]결재문서번호 (" + sctmInfo.get("APP_DOC_NUM") + ")이 [" + sctmInfo.get("NEXT_SIGN_USER_NM") + "] 님에게 반려되었습니다");
	        smsMap.put("REF_MODULE_CD", "SSIGN03");
	        smsMap.put("REF_NUM", appDocNum);
	        smsMap.put("RECV_USER_ID", regUserId);
	        
	        // 2021.06.29 : 결재상신 SMS 수수료 부과하기
	        smsMap.put("CORP_NO", sctmInfo.get("CORP_NO"));			// 고객사 사업자번호
			smsMap.put("BRC", sctmInfo.get("BRC"));					// 고객사 부서
			smsMap.put("EPRO_PS_DSC", "1");							// 1  : 구매
            smsMap.put("EPRO_RATE_DSC", "01");						// 01 : 최초
			smsMap.put("APLY_DT", sctmInfo.get("APLY_DT"));			// 발생일 YYYYMMDD
			smsMap.put("USER_ID", sctmInfo.get("USER_ID"));			// 고객사 보내는사람 ID
			smsMap.put("CONT_TBL_ID", "STOCSCTM");					// 검증 테이블
			smsMap.put("CONT_TBL_PK", sctmInfo.get("CONT_TBL_PK")); // 검증 조건(협력사별 입찰번호)
			smsMap.put("tmp", sctmInfo.get("CONT_TBL_PK"));			// myBatis 버그 해결을 위한 무의미한, 유니크한 값.
			smsMap.put("payFlag", "Y");								// SMS 과금여부
			
	        eversmsservice.sendSmsNhe(smsMap);
		}
		catch (Exception ex) {
		    logger.error("결재 반려 후 상신자에게 메일&문자 발송 오류 : " + ex.getMessage());
		}
		return message;
	}

	// 결재취소(sign_status = 'C')인 경우, 후처리
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String doAfterCancel(String docTypeString, String buyerCd, String appDocNum, String appDocCnt) throws Exception {

		DOC_TYPE docType = DOC_TYPE.valueOf(docTypeString);
		String message = null;
		
		switch (docType) {
			// 구매의뢰
			case PR: message = endPr.endApproval(buyerCd, appDocNum, appDocCnt, "C"); break;
			// 입찰공고
			case BID: message = endBid.endApproval(buyerCd, appDocNum, appDocCnt, "C"); break;
			// 취소공고
			case CANCELBID: message = endBid.endCancelApproval(buyerCd, appDocNum, appDocCnt, "C"); break;
			// 입찰결과보고
			case BIDRLT: message = endBid.endBidRltApproval(buyerCd, appDocNum, appDocCnt, "C"); break;
			// 수의결과보고
         	case RFXRLT: message = endRfq.endRfxRltApproval(buyerCd, appDocNum, appDocCnt, "C"); break;
			// 우선협상결과
			case NEGORLT: message = endBid.endNegoRltApproval(buyerCd, appDocNum, appDocCnt, "C"); break;

			case ESTM: message = endEstm.endApproval(buyerCd, appDocNum, appDocCnt, "C"); break;
			// 서식 결재상신
			case FORMNO: message = endCctr.endApproval_FORMNO(buyerCd, appDocNum, appDocCnt, "C"); break;
			// 발주
			case PO: message = endPo.endApproval(buyerCd, appDocNum, appDocCnt, "C"); break;
			// 계약서 취소
			case EC: message = endCctr.endApproval_EC(buyerCd, appDocNum, appDocCnt, "C"); break;
			// 계약서(다수) 취소
			case EC2: message = endCctr.endApproval_EC(buyerCd, appDocNum, appDocCnt, "C"); break;
			// 검수요청
			case INV:
			case DINV: message = endInv.endApproval(buyerCd, appDocNum, appDocCnt, "C"); break;
			// 대금지급요청
			case AP: message = endAp.endApproval(buyerCd, appDocNum, appDocCnt, "C"); break;
			// 견적요청서
			case RFQ: message = endRfq.endApproval(buyerCd, appDocNum, appDocCnt, "C"); break;
			// 선정품의
			case EXEC: message = endExec.endApproval(buyerCd, appDocNum, appDocCnt, "C"); break;
			// 개인근로
			case PCONT: message = endPcont.endApproval(buyerCd, appDocNum, appDocCnt, "C"); break;
			// 위임장
			case ETST: message = endEtst.endApproval(buyerCd, appDocNum, appDocCnt, "C"); break;
			//파트너스_근로계약(도급)
			case TC1: message = endCcpi.endApproval(buyerCd, appDocNum, appDocCnt, "C"); break;
			//파트너스_근로계약(단기간)
			case TC2: message = endCcpi.endApproval(buyerCd, appDocNum, appDocCnt, "C"); break;
			//파트너스_근로계약(일용직)
			case TC3: message = endCcpi.endApproval(buyerCd, appDocNum, appDocCnt, "C"); break;
			//파트너스_근로계약(파견)
			case TC4: message = endCcpi.endApproval(buyerCd, appDocNum, appDocCnt, "C"); break;
			// 기본
			default: throw new Exception(msg.getMessageForService(this, "no_matched_doc"));
		}
		return message;
	}
}

