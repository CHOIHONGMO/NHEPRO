package com.st_ones.nhepro.MOBILE.service;

import com.st_ones.common.docNum.service.DocNumService;
import com.st_ones.common.file.service.FileAttachService;
import com.st_ones.common.file.web.FileAttachController;
import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.common.mail.service.EverMailService;
import com.st_ones.common.mail.web.MailTemplate;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.sms.EverSmsMapper;
import com.st_ones.common.sms.service.EverSmsService;
import com.st_ones.common.util.clazz.EverDate;
import com.st_ones.common.util.clazz.EverFile;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.eversrm.eApproval.eApprovalModule.service.BAPM_Service;
import com.st_ones.nhepro.MOBILE.Mobile_Mapper;
import org.apache.commons.io.FileUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * The type Mobile_Service
 */
@Service(value = "Mobile_Service")
public class Mobile_Service extends BaseService {

	@Autowired private MessageService msg;

	@Autowired private Mobile_Mapper mobile_mapper;
	
	@Autowired BAPM_Service approvalService;

	@Autowired private EverMailService everMailService;

	@Autowired private MailTemplate mailTemplate;

	@Autowired private DocNumService docNumService;

	@Autowired private FileAttachController fileAttachController;

	@Autowired private FileAttachService fileAttachService;

	@Autowired private EverSmsService everSmsService;

	@Autowired private EverSmsMapper everSmsMapper;

	public Map<String, String> userIdCheck(Map<String, String> param) throws Exception {
		return mobile_mapper.userIdCheck(param);
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public void certified_update(Map<String, String> param) throws Exception {
	    // SMS 전송
        try {
            Map<String, String> smsMap = new HashMap<>();

			if(PropertiesManager.getBoolean("eversrm.system.developmentFlag")) {
				param.put("CERTIFIED_NUMBER", "12345");
			}

            String subject  = "[전자구매시스템] 본인확인";
            String contents = "[전자구매시스템] 본인확인 인증번호는 "+ param.get("CERTIFIED_NUMBER") + " 입니다. 정확히 입력해 주세요.";

            smsMap.put("SEND_USER_ID", "SYSTEM");
            smsMap.put("SEND_USER_NM", PropertiesManager.getString("eversrm.system.mailSenderName"));
            smsMap.put("RECV_USER_ID", param.get("USER_ID")); // 수신자ID : 개인근로자ID
            smsMap.put("RECV_USER_NM", param.get("USER_NM")); // 수신자명 : 개인근
            smsMap.put("RECV_TEL_NUM", param.get("CELL_NUM"));
            smsMap.put("SUBJECT", subject );
            smsMap.put("CONTENTS", contents );
            smsMap.put("REF_MODULE_CD", "SMS");
            smsMap.put("REF_NUM", "");
            smsMap.put("BUYER_CD", "");

            // everSmsService.sendSms(smsMap);
        } catch (Exception e) {
            getLog().error("인증번호 발송 오류(SMS): " + e);
        }

		param.put("KEY", everSmsMapper.getKey(param));

        // 이력관리 테이블
		mobile_mapper.certified_update(param);

        // 실제 SMS 전송 테이블
		param.put("SEND_TEL_NUM", PropertiesManager.getString("eversrm.system.sms.default.telNo"));
		param.put("RECV_TEL_NUM", param.get("CELL_NUM"));
        mobile_mapper.insertSMS(param);
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public int certified_confirm(Map<String, String> param) throws Exception {
		// 인증번호 확인
		int confirm_flag = mobile_mapper.certified_confirm(param);

		// 인증여부 업데이트
		param.put("CONFIRM_FLAG", String.valueOf(confirm_flag));
		mobile_mapper.certified_confirm_Update(param);

		return confirm_flag;
	}

	public Map<String, String> emailCheck(Map<String, String> param) throws Exception {
		return mobile_mapper.emailCheck(param);
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public void doSave(Map<String, String> param) throws Exception {

		// 회원정보 Update 시에는 비밀번호 체크
		if("E".equals(param.get("PROGRESS_CD"))) {
			// PW 2회 중복체크
			List<Map<String, Object>> uspwList = mobile_mapper.MIDPW_040_doSearchUSPW(param);

			for (Map<String, Object> uspw : uspwList) {
				if (param.get("PASSWORD").equals(uspw.get("PASSWORD"))) {
					throw new Exception("최근에 사용한 비밀번호 입니다. 비밀번호를 다시 입력해 주십시오.");
				}
			}
		}

		// 회원가입 저장
		mobile_mapper.doSave(param);

		param.put("REG_IP_ADDR", EverString.getClientIP());
		mobile_mapper.MIDPW_010_InsertPW(param);

		if(!"E".equals(param.get("PROGRESS_CD"))) {
            // 이메일 발송
            Map<String, String> mailData = new HashMap<>();

            String subject  = "[전자구매시스템] 개인근로자 회원 가입 승인 요청 (이름 : " + param.get("USER_NM") + ")";
            String contentsText = "농협의 통합전자구매시스템에서 개인근로자 회원 가입 승인 요청 건이 도착 하였습니다.\n" +
                    "<br>" +
                    "  - 이름 : " + param.get("USER_NM")+ "<br>" +
                    "  - 사용자ID : " + param.get("USER_ID")+ "<br>" +
                    "<br>" +
                    "시스템에 접속하여 내용 검토 후, 회원 승인/거절 처리 바랍니다.<br>" +
                    "감사합니다.<br>";
            
            mailData.put("SEND_USER_ID", "SYSTEM");
            mailData.put("SEND_USER_NM", PropertiesManager.getString("eversrm.system.mailSenderName"));
            mailData.put("RECV_USER_ID", param.get("SITE_USER_ID"));
            mailData.put("SUBJECT",  subject);
            mailData.put("CONTENTS", contentsText);
            mailData.put("BUYER_CD", "");
            mailData.put("REF_MODULE_CD", "MESSAGE");
            mailData.put("REF_NUM", "");

            everMailService.SendMail(mailData);
        }
	}

	public List<Map<String, Object>> MAGG_030_doSearch(Map<String, String> param) throws Exception{
		return mobile_mapper.MAGG_030_doSearch(param);
	}

	public Map<String, String> MIDPW_010_doSearch(Map<String, String> param) throws Exception {
		return mobile_mapper.MIDPW_010_doSearch(param);
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public void MIDPW_010_Update(Map<String, String> userInfo) throws Exception {

		// SMS 전송
		String subject  = "[전자구매시스템] 사용자 비빌번호가 초기화 되었습니다.";
		String contentsText = "";
		if( !"".equals(EverString.nullToEmptyString(userInfo.get("CELL_NUM"))) ){
			try {
				Map<String, String> smsMap = new HashMap<>();

				contentsText = "[전자구매시스템] 사용자 비밀번호가 초기화 되었습니다. 임시비밀번호 ["+ userInfo.get("ppdd") +"] 위 정보로 접속 하신 후, 비밀번호를 반드시 변경하여 주시기 바랍니다.";
				
				if( EverString.isEmpty(userInfo.get("CELL_NUM")) ) {
					smsMap.put("RECV_USER_ID", userInfo.get("USER_ID"));
	            } else {
	                smsMap.put("DIRECT_TARGET", userInfo.get("CELL_NUM"));
					smsMap.put("DIRECT_USER_NM", userInfo.get("USER_NM"));
	            }
				
				smsMap.put("EPRO_PS_DSC", "1");			// 1  : 구매
				smsMap.put("EPRO_WRS_DS", "52");		// epro_wrs_ds [상품코드] - 10 : RFI, 20 : 입찰, 30 : 일반입찰계약, 40 : 일반수의계약, 50 : BtoC계약, 60 : 위임계약, 70 : 문서보관, 80 : SMS, 90 : LMS, 100 : 문서생성
	            smsMap.put("EPRO_RATE_DSC", "01");		// 01 : 최초
				smsMap.put("CONTENTS", contentsText);
				smsMap.put("BUYER_CD", "");
				smsMap.put("REF_MODULE_CD", "SMS");
				smsMap.put("REF_NUM", "");
				smsMap.put("payFlag", "Y");
				
				everSmsService.sendSmsNhe(smsMap);
			} catch (Exception e) {
				getLog().error("비밀번호 초기화 오류(SMS): " + e);
			}
		}

		// 이메일 발송
		if( !"".equals(EverString.nullToEmptyString(userInfo.get("EMAIL")))) {
			try {
				Map<String, String> mailData = new HashMap<>();

				contentsText = "[전자구매시스템]<br>" +
						"<br>" +
						"사용자 비밀번호가 초기화 되었습니다.<br>" +
						"아래 사용자 ID, 비밀번호로 접속하시기 바랍니다.<br>" +
						"<br>" +
						"- 사용자 ID : "+ userInfo.get("USER_ID") +"<br>" +
						"- 비밀번호 : "+ userInfo.get("ppdd")+"<br>" +
						"<br>" +
						"위 정보로 접속 하신 후, 비밀번호를 반드시 변경하여 주시기 바랍니다.<br>" +
						"감사합니다.";

				String mailContents = mailTemplate.getMailTemplate(""
						, subject
						, contentsText
						);

				mailData.put("SEND_USER_ID", "SYSTEM");
				mailData.put("SEND_USER_NM", PropertiesManager.getString("eversrm.system.mailSenderName"));
				mailData.put("RECV_USER_ID", userInfo.get("USER_ID"));
				mailData.put("RECV_USER_NM", userInfo.get("USER_NM"));
				mailData.put("RECV_EMAIL",   userInfo.get("EMAIL"));
				mailData.put("SUBJECT",  subject);
				mailData.put("CONTENTS", mailContents);
				mailData.put("BUYER_CD", "");
				mailData.put("REF_MODULE_CD", "MESSAGE");
				mailData.put("REF_NUM", "");
				mailData.put("ATT_FILE_NUM", "");

				everMailService.SendMail(mailData);
			} catch (Exception e) {
				getLog().error("비밀번호 초기화 오류(MAIL): " + e);
			}
		}
		// PW 초기화 여부 업데이트
		userInfo.put("PW_RESET_FLAG", "1");
		mobile_mapper.MIDPW_040_resetPassword(userInfo);
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public Boolean MIDPW_040_resetPassword(Map<String, String> param) throws Exception {
		// PW 2회 중복체크
		List<Map<String, Object>> uspwList = mobile_mapper.MIDPW_040_doSearchUSPW(param);

		Boolean pwFlag = true;
		for(Map<String, Object> uspw : uspwList) {
			if(param.get("PASSWORD").equals(uspw.get("PASSWORD"))) {
				pwFlag = false;
				//throw new Exception("패스워드를 중복교차 사용하실 수 없습니다.");
			}
		}

		// PW 변경
		param.put("PW_RESET_FLAG", "0");
		mobile_mapper.MIDPW_040_resetPassword(param);
		
		return pwFlag;
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public void MIDPW_010_InsertPW(Map<String, String> userInfo) throws Exception {
		mobile_mapper.MIDPW_010_InsertPW(userInfo);
	}

	public List<Map<String, Object>> mobileHome_contract_list(Map<String, String> param) throws Exception {

		List<Map<String, Object>> contractList = mobile_mapper.mobileHome_contract_list(param);
		return contractList;
	}

	public List<Map<String, Object>> mobileHome_doPledge_list(Map<String, String> param) throws Exception {
		return mobile_mapper.mobileHome_doPledge_list(param);
	}

	public List<Map<String, Object>> mobileHome_doNotice_list(Map<String, String> param) throws Exception {
		return mobile_mapper.mobileHome_doNotice_list(param);
	}

    public Map<String, String>  mobileHome_checkLeglAgree2(Map<String, String> param) throws Exception {
        return mobile_mapper.mobileHome_checkLeglAgree2(param);
    }

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public void mobile_doOath(Map<String, String> param) throws Exception {

		param.put("LEGL_NUM", docNumService.getDocNumber("1000", "MO"));

		// STOCLEGL 저장
		mobile_mapper.mobile_doOath(param);

		// 파일 이동
		File sourceFile = new File(param.get("sourcePath") + "/pdf/" + param.get("fileNm") + "." + "pdf");
		File targetFile = new File(param.get("filePath") + param.get("UUID") + "_" + param.get("UUID_SQ") + "." + "pdf");

		EverFile.makeDir(param.get("filePath"));
		FileUtils.moveFile(sourceFile, targetFile);

		String fileSize = EverFile.getFileSize(param.get("filePath"), param.get("UUID") + "_" + param.get("UUID_SQ") + ".pdf");

		// STOCATTCH 저장
		HashMap<String, String> fileSaveInfo = fileAttachController.getFileSaveInfo(
				"PDF", param.get("filePath"), "계약서_" + param.get("USER_NM") + "_" + EverDate.getDate2() + ".pdf",
				"pdf", param.get("UUID"), param.get("UUID_SQ"), fileSize, false);
		
		fileAttachService.insertFileInfo(fileSaveInfo);
    }

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public void mobile_doContract(Map<String, String> param) throws Exception {
		
		// 1. 개인 근로자 전자서명 완료 (STOCPCWU) 저장
		mobile_mapper.mobile_doContract(param);
		
		// 2020.11.25 추가
		// 2. 개인근로자 계약 고객사에 수수료 부과
    	Map<String, String> paymentMap = mobile_mapper.getPrepaymentCust(param); 	// 위수탁계약 : 고객사에 수수료 부과

        paymentMap.put("EPRO_PS_DSC", "1");			// epro_ps_dsc [구매공급구분코드] - 1 : 구매, 2 : 공급
        paymentMap.put("EPRO_WRS_DS", "50");		// epro_wrs_ds [상품코드] - 10 : RFI, 20 : 입찰, 30 : 일반입찰계약, 40 : 일반수의계약, 50 : BtoC계약, 60 : 위임계약, 70 : 문서보관, 80 : SMS, 90 : LMS, 100 : 문서생성
        paymentMap.put("EPRO_RATE_DSC", (String.valueOf(param.get("CONT_CNT")).equals("1") ? "01" : "02")); 	// epro_rate_dsc [단가코드] - 01 : 최초, 02 : 재입찰/재계약/재요청
        paymentMap.put("CONT_TBL_ID", "STOCPCWU");	// 업무 Table명
        // CONT_TBL_PK : 해당 Table에 Data 존재유무를 조회해볼 수 있는 Key 값. GATE_CD || '@@' || BUYER_CD || '@@' || ... 와 같이 설정.
        paymentMap.put("tmp", ""); 					// myBatis 버그 해결을 위한 무의미한, 유니크한 값. 단, EPRO_WRS_DS = '30' 또는 '40'일 때 반드시 계약금액을 넣어야 함.

        String resultMsg = approvalService.putBkCost(paymentMap);
        if( !resultMsg.equals("OK") ) {
        	throw new Exception(resultMsg);
        } else {
        	System.out.println("==========> 개인근로자 서명 완료 후 고객사에 수수료 청구 : PK => " + paymentMap.get("CONT_TBL_PK") + ", CORP_NO => " + paymentMap.get("CORP_NO"));
        }
		
		// 3. 파일 이동
		File sourceFile = new File(param.get("sourcePath") + param.get("fileNm") + "." + "pdf");
		File targetFile = new File(param.get("filePath") + param.get("UUID") + "_" + param.get("UUID_SQ") + "." + "pdf");

		EverFile.makeDir(param.get("filePath"));
		FileUtils.moveFile(sourceFile, targetFile);

		String fileSize = EverFile.getFileSize(param.get("filePath"), param.get("UUID") + "_" + param.get("UUID_SQ") + ".pdf");

		// STOCATTCH 저장
		HashMap<String, String> fileSaveInfo = fileAttachController.getFileSaveInfo(
				"PDF", param.get("filePath"), "계약서_" + param.get("USER_NM") + "_" + EverDate.getDate2() + ".pdf",
				"pdf", param.get("UUID"), param.get("UUID_SQ"), fileSize, false);
		
		fileAttachService.insertFileInfo(fileSaveInfo);
	}

	public int fileUserCheck(Map<String, String> formData) {
		return mobile_mapper.fileUserCheck(formData);
	}

	public Map<String, String> selectNotice(String noticeNo) {
		mobile_mapper.updateNoticeView(noticeNo);
		return mobile_mapper.selectNotice(noticeNo);
	}
}
