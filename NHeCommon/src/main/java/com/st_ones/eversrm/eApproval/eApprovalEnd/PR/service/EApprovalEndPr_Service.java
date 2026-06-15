package com.st_ones.eversrm.eApproval.eApprovalEnd.PR.service;

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
import com.st_ones.eversrm.eApproval.eApprovalEnd.PR.EApprovalEndPr_Mapper;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2014 ST-Ones CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : EApprovalEndPr_Service.java
 * @date 2020. 4. 02.
 * @version 1.0
 */
@Service(value = "eApprovalEndPr_Service")
public class EApprovalEndPr_Service extends BaseService {

    @Autowired private MessageService msg;
	@Autowired private EverSmsService eversmsservice;
	@Autowired private EverMailService evermailservice;
    @Autowired private DocNumService docNumService;
	@Autowired private EApprovalEndPr_Mapper endPr_Mapper;
	
	Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/**
	 * 모듈명 : 구매의뢰 [PR]
	 * 처리내용 : SIGN_STATUS, SIGN_DATE, PROGRESS_CD 변경.
	 */
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String endApproval(String buyerCd, String appDocNum, String appDocCnt, String signStatus) throws Exception {

		Map<String, String> param = new HashMap<String, String>();
		param.put("BUYER_CD", buyerCd);
		param.put("APP_DOC_NUM", appDocNum);
		param.put("APP_DOC_CNT", appDocCnt);
		param.put("SIGN_STATUS", signStatus);

		// 결재번호에 해당하는 구매요청번호 가져오기
		String prNum = endPr_Mapper.getPrNum(param);
		param.put("PR_NUM", prNum);

		// STOCPRHD.SIGN_STATUS 변경
		endPr_Mapper.setPrSignStatus(param);
		
		// signStatus = 'E'인 경우, STOCPRDT.PROGRESS_CD = '2100'(접수대기)으로 변경
		if(signStatus.equals("E")) {
			endPr_Mapper.setPrProgressCd(param);
		}
		
		String rtnMsg = (signStatus.equals("E") ? msg.getMessage("0057")
				: (signStatus.equals("R") ? msg.getMessage("0058")
				: (signStatus.equals("C") ? msg.getMessage("0061")
				: msg.getMessage("0001"))));
		
		// 구매요청에 대한 직발주 생성 후
		List<Map<String, Object>> targetVendor =  endPr_Mapper.getDirectPoTargetVendor(param);
		for(Map<String, Object> vendor : targetVendor) {
			
			vendor.put("PO_NUM", docNumService.getDocNumber(String.valueOf(vendor.get("PR_BUYER_CD")), "PO"));
			endPr_Mapper.insertPodt(vendor);
			endPr_Mapper.insertPohd(vendor);
			endPr_Mapper.setDirectPoProgressCd(vendor);
		
			try {
				String linkUrl = PropertiesManager.getString("eversrm.urls.maintain.real") ;
				
				// 직발주 메일
				Map<String, String> prhd =  endPr_Mapper.getPrhd(vendor);
				
				String subject = "[전자구매시스템] 고객사 ["+prhd.get("BUYER_NM")+" "+prhd.get("REG_USER_NM")+"]에서 ["+prhd.get("SUBJECT")+"] 관련 직발주를 전송하였습니다";
		        //EMAIL
		        Map<String,String> mailMap = new HashMap<String,String>();
		        mailMap.put("SUBJECT", subject);
		        
		        StringBuffer content = new StringBuffer(255);
		        content.append("<BR> 안녕하세요.												");
		        content.append("<BR> " + prhd.get("VENDOR_NM") + " 님.						");
		        content.append("<BR>                       									");
		        content.append("<BR> 아래와 같이 고객사에서 직발주서를 발송 하였습니다                 		   	");
		        content.append("<BR> 고객사 : [" + prhd.get("BUYER_NM") + "]					");
		        content.append("<BR> 발주명 : [" + prhd.get("SUBJECT") + "]					");
		        content.append("<BR> 발주일 : [" + prhd.get("PO_CREATE_DATE") + "]				");
		        content.append("<BR> 납품기한 : [" + prhd.get("DUE_DATE") + "]					");
		        content.append("<BR>                       									");
		        content.append("<BR> 전자구매시스템에 <a href=\""+linkUrl+"\" target=\"newP\">로그인</a> 하시어, 세부내용을 확인 후 처리 해주십시오.  ");
		        content.append("<BR>                       									");
		        content.append("<BR> 감사합니다.                      							");
		        
		        mailMap.put("CONTENTS", content.toString());
		        mailMap.put("REF_MODULE_CD", "MPO01");
		        mailMap.put("RECV_USER_ID", vendor.get("VENDOR_CD").toString());
		        mailMap.put("REF_NUM", appDocNum);
		        evermailservice.SendMail(mailMap);
		        
				//SMS발송
		        Map<String,String> smsMap = new HashMap<String,String>();
		        // 2021.01.05 SMS 문구 조정
		        smsMap.put("CONTENTS", subject);
                //smsMap.put("CONTENTS", "[전자구매시스템]발주번호 (" + prhd.get("PO_NUM") + ") 관련 직발주서가 전송되었습니다");
		        smsMap.put("REF_MODULE_CD", "SPO01");
		        smsMap.put("RECV_USER_ID", vendor.get("VENDOR_CD").toString());
		        eversmsservice.sendSmsNhe(smsMap);
			}
			catch (Exception ex) {
			    logger.error("직발주서 결재승인 후 메일&문자 발송 오류 : " + ex.getMessage());
			}
		}
		return rtnMsg;
	}

}
