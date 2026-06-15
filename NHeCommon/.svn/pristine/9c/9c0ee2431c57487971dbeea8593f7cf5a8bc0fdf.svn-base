package com.st_ones.eversrm.board.sms.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.st_ones.common.mail.service.EverMailService;
import com.st_ones.common.mail.web.MailTemplate;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.sms.service.EverSmsService;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.common.util.service.LargeTextService;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.info.BaseInfo;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.everf.serverside.util.StringUtil;
import com.st_ones.eversrm.board.sms.BBOS_Mapper;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : BBOS_Service.java
 * @author  Yeon-moo, Lee (yeonmoo_lee@st-ones.com)
 * @date 2013. 07. 22.
 * @version 1.0
 * @see
 */

@Service(value = "bbos_Service")
public class BBOS_Service extends BaseService {

	@Autowired
	private MessageService msg;

	@Autowired
	private MailTemplate mt;

	@Autowired
	private EverMailService everMailService;

	@Autowired
	private EverSmsService everSmsService;

	@Autowired
	private BBOS_Mapper bbos_Mapper;

	@Autowired
	LargeTextService largeTextService;
	
	Logger logger = LoggerFactory.getLogger(this.getClass());
	
	public List<Map<String, Object>> selectUserSearch(Map<String, String> param) {

		BaseInfo baseInfo = UserInfoManager.getUserInfoImpl();
		String userType = baseInfo.getUserType();

		List<Map<String, Object>> resultList = new ArrayList<Map<String, Object>>();

		if ("S".equals(userType))
			resultList = bbos_Mapper.selectUserSearchB(param);
		else if ("B".equals(userType))
			resultList = bbos_Mapper.selectUserSearchS(param);

		return resultList;
	}
	
	/**
	 * 메일, SMS 동시 전송
	 * @param formData
	 * @return
	 * @throws Exception
	 */
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public Map<String, String> doMailSmsSend(Map<String, String> formData, List<Map<String, Object>> gridList) throws Exception {
		
		BaseInfo baseInfo = UserInfoManager.getUserInfo();
		
		Map<String, String> rtnMap = new HashMap<>();
		String sendType = EverString.nullToEmptyString(formData.get("SEND_TYPE"));
		String subject  = EverString.nullToEmptyString(formData.get("SUBJECT"));
		String contents = EverString.nullToEmptyString(formData.get("CAPTION_MSG"));
		
		if(sendType.equals("T")) {
			try {
				for( Map<String, Object> rowData : gridList ){
					String email = String.valueOf(rowData.get("VENDOR_PIC_USER_EMAIL"));
					contents = contents.replace("&lt;p&gt;", "").replace("&lt;/p&gt;", "");
					
					// 메일 전송
					if( email != "null" && !StringUtil.isEmpty(email) ){
						Map<String,String> mailMap = new HashMap<>();
						
						mailMap.put("SUBJECT", subject);
						mailMap.put("CONTENTS", contents );
						mailMap.put("REF_MODULE_CD", "MESSAGE");
						mailMap.put("RECV_USER_ID", String.valueOf(rowData.get("VENDOR_PIC_USER_ID")));
						mailMap.put("REF_NUM", "");
						
						everMailService.SendMail(mailMap);
					}
				}
			}
			catch (Exception ex) {
			    logger.error("공지사항 안내 수동 직접입력 메일전송 : " + ex.getMessage());
			}
		} else {
			try {
				for( Map<String, Object> rowData : gridList ){
					String email = String.valueOf(rowData.get("VENDOR_PIC_USER_EMAIL"));
					// 메일 전송
					if( email != "null" && !StringUtil.isEmpty(email) ){
						Map<String,String> mailMap = new HashMap<>();
						mailMap.put("SUBJECT", subject);
						
						String Autocontent = "<BR> 안녕하세요." +
								"<BR>    " +
		                        "<BR> FIRST-ePro를 이용해 주셔서 감사합니다." +
		                        "<BR>    " +
		                        "<BR> 안정적인 서비스 제공을 위해" +
		                        "<BR> 2021년 3월 서비스 오픈 이후 3년간 동결하였던" +
		                        "<BR> 이용 수수료 정책을 개편하오니" +
		                        "<BR> 양해하여 주시기 바랍니다." +
		                        "<BR> 고객 편의 증진을 위한 양질의 서비스 제공을 위해 노력하겠습니다." +
		                        "<BR>    " +
		                        "<BR> 서비스 이용 수수료에 대한 상세 내용은 공지사항 첨부파일을 확인해 주세요." +
		                        "<BR>    " +
		                        "<BR> 개편(안) 적용일 : 2023년 7월 1일(토)" +
		                        "<BR>    " +
		                        "<BR> 감사합니다.";
						
						mailMap.put("CONTENTS", Autocontent );
						mailMap.put("REF_MODULE_CD", "MESSAGE");
						mailMap.put("RECV_USER_ID", String.valueOf(rowData.get("VENDOR_PIC_USER_ID")));
						mailMap.put("REF_NUM", "");
						
						everMailService.SendMail(mailMap);
					}
				}
				}
				catch (Exception ex) {
					logger.error("공지사항 안내 수동 자동입력 메일전송 : " + ex);
				}
		}
		
		rtnMap.put("rtnMsg", msg.getMessageByScreenId("BSN_040", "003"));
        return rtnMap;
        
	}
}