package com.st_ones.common.mail.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.st_ones.common.file.service.FileAttachService;
import com.st_ones.common.mail.EverMailMapper;
import com.st_ones.common.mail.web.EverMailVo;
import com.st_ones.common.mail.web.MailTemplate;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.common.util.service.LargeTextService;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.web.BaseController;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : EverMailService.java
 * @date 2013. 09. 10.
 * @version 1.0
 * @see
 */
@Service(value = "everMailService")
public class EverMailService extends BaseController {

	private Logger logger = LoggerFactory.getLogger(EverMailService.class);

	@Autowired FileAttachService fileAttachService;
	@Autowired LargeTextService largeTextService;
	@Autowired EverMailMapper everMailMapper;
	
	@Autowired protected JavaMailSender mailSender;
	@Autowired protected MailTemplate mailtemplate;

	public void SendMail(Map<String, String> param) throws Exception {
		
		// 보내는 사람ID 기본값 설정
		if( param.get("SEND_USER_ID") == null ) {
			param.put("SEND_USER_ID", PropertiesManager.getString("eversrm.userId.default"));
		}
		
		// 보내는 사람 기본값 설정
		param.put("SEND_USER_NM", PropertiesManager.getString("eversrm.system.mailSenderName"));
		
		// 보내는 사람 : webmaster@nhepro.com
		param.put("SEND_EMAIL", PropertiesManager.getString("eversrm.system.mailSenderMail"));
		
		// 직접 받는 메일,SMS 주소가 들어오면 받는 사람 아이디 삭제
		if( !EverString.isEmpty(param.get("DIRECT_TARGET")) ) {
			param.put("RECV_USER_ID", "");
		}
		
		String subject  = EverString.toEmpty(param.get("SUBJECT"));
		String contents = EverString.toEmpty(param.get("CONTENTS"));
		
		// 2021.05.10 변경
		// 받는 사람 : 고객 및 협력사일 경우 3명 까지 발송
		List<Map<String, String>> mailList = everMailMapper.getReceiverEmail(param);
		for( Map<String, String> mailMap : mailList ) {
			param.put("RECV_EMAIL",   mailMap.get("EMAIL"));
			param.put("RECV_USER_NM", mailMap.get("USER_NM"));
			param.put("RELAT_YN",     mailMap.get("RELAT_YN"));	//농협,비농협 구분[NH0005] - 농협 : 0, 비농협 : 1
			
			// 개발 또는 테스트 발송인 경우 받는 사람을 특정함
			boolean isDevelopmentMode = PropertiesManager.getBoolean("eversrm.system.developmentFlag");
			String sendType           = PropertiesManager.getString("eversrm.system.mailSendType");
			String receiveUserId	  = PropertiesManager.getString("eversrm.system.mail.test.receive.ID");
			String receiveEmail       = PropertiesManager.getString("eversrm.system.mail.test.receive.mail");
			if( isDevelopmentMode || "test".equals(sendType) ) {
				param.put("RECV_USER_ID", receiveUserId);
				param.put("RECV_EMAIL", receiveEmail);
			}
			System.err.println("======================isDevelopmentMode="+isDevelopmentMode);
			System.err.println("======================eversrm.system.mailSendType="+sendType);
			System.err.println("======================receiver_email="+param.get("RECV_EMAIL"));
			
			// 메일 내용
			param.put("CONTENTS", mailtemplate.getMailTemplate("", subject, contents));
			
			// ******************************** 메일 발송 세팅 *************************************
			EverMailVo everMailVO = new EverMailVo();
			everMailVO.setGateCd(EverString.toEmpty(param.get("GATE_CD")));
			everMailVO.setSubject(EverString.toEmpty(param.get("SUBJECT")));
			
			// 발신자 정보
			everMailVO.setSenderUserId(EverString.toEmpty(param.get("SEND_USER_ID")));
			everMailVO.setSenderNm(EverString.toEmpty(param.get("SEND_USER_NM")));
			everMailVO.setSenderEmail(EverString.toEmpty(param.get("SEND_EMAIL")));
			
			// 수신자 정보
			everMailVO.setReceiverUserId(EverString.toEmpty(param.get("RECV_USER_ID")));
			everMailVO.setReceiverNm(EverString.toEmpty(param.get("RECV_USER_NM")));
			everMailVO.setReceiverEmail(EverString.toEmpty(param.get("RECV_EMAIL")));
			
			// 메일 내용
			everMailVO.setContents(EverString.toEmpty(param.get("CONTENTS")));
			everMailVO.setContentsTemplate(EverString.toEmpty(param.get("CONTENTS")));
			
			// 참고 모듈
			everMailVO.setRefNum(EverString.toEmpty(param.get("REF_NUM")));
			everMailVO.setRefModuleCd(EverString.toEmpty(param.get("REF_MODULE_CD")));
	
			if( !EverString.nullToEmptyString(everMailVO.getReceiverEmail()).equals("") ) {
				
				// 메일 발송
				String succYn = SendMail(everMailVO, "1");
				
				// 메일 발송내용 STOCMAIL 저장
				Map<String, String> paramF = new HashMap<String,String>();
				paramF.put("gateCd", EverString.toEmpty(param.get("GATE_CD")));
				paramF.put("senderEmail", EverString.toEmpty(param.get("SEND_EMAIL")));
				paramF.put("senderNm", EverString.toEmpty(param.get("SEND_USER_NM")));
				paramF.put("senderUserId", EverString.toEmpty(param.get("SEND_USER_ID")));
				paramF.put("receiverEmail", everMailVO.getReceiverEmail());
				paramF.put("receiverNm", everMailVO.getReceiverNm());
				paramF.put("receiverUserId", everMailVO.getReceiverUserId());
				paramF.put("subject", everMailVO.getSubject());
				paramF.put("buyerCd", everMailVO.getBuyerCd());
				paramF.put("vendorCd", everMailVO.getVendorCd());
				paramF.put("attFileNum", everMailVO.getAttFileNum());
				paramF.put("refNum", everMailVO.getRefNum());
				paramF.put("refModuleCd", everMailVO.getRefModuleCd());
				paramF.put("contentsTemplate", everMailVO.getContentsTemplate());
				paramF.put("SEND_FLAG", succYn);
				
				insertMailHistory(paramF);
				paramF.clear();
			}
		}
	}

	public synchronized String SendMail(EverMailVo everMailVO, String relatYn) {
		String succYn = "0";
		try {
			// MAIL 전송여부
			boolean isSendFlag = PropertiesManager.getBoolean("eversrm.system.mailSendFlag");
			if( isSendFlag ) {
				MimeMessage msg = mailSender.createMimeMessage();
				MimeMessageHelper helper = new MimeMessageHelper(msg, false);
				
				helper.setSubject(everMailVO.getSubject());
				helper.setFrom(new InternetAddress(everMailVO.getSenderEmail(), everMailVO.getSenderNm(), "UTF-8"));
				helper.setTo(new InternetAddress(everMailVO.getReceiverEmail(), everMailVO.getReceiverNm(), "UTF-8"));
				helper.setText(everMailVO.getContentsTemplate(), true);
				
				mailSender.send(msg);
			}
			succYn = "1";
		}
		catch (Exception mex) {
			succYn = "0";
			logger.error(mex.getMessage(), mex);
		}
		return succYn;
	}
	
	// STOCMAIL 테이블에 등록하기
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	private void insertMailHistory(Map<String, String> param) throws Exception {

		String textNum = largeTextService.saveMailContents(param.get("contentsTemplate"));
		//everMailVO.setMailTextNum(textNum);
		param.put("mailTextNum", textNum);
		everMailMapper.doSendMail(param);
	}

	public List<Map<String, String>> getReceiverMailAddress(Map<String, String> param) throws Exception {
		return everMailMapper.getReceiverMailAddress(param);
	}

	public List<Map<String, String>> getBuyerMailAddress(Map<String, String> contInfo) {
		return everMailMapper.getBuyerMailAddress(contInfo);
	}
	
}
