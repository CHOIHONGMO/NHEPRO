
package com.st_ones.eversrm.manager.basic.service;

import com.st_ones.common.mail.service.EverMailService;
import com.st_ones.common.mail.web.MailTemplate;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.sms.service.EverSmsService;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.common.util.service.LargeTextService;
import com.st_ones.everf.serverside.info.BaseInfo;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.eversrm.manager.basic.BSN_Mapper;
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
 * @File Name : BSN_Service.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

@Service(value = "bsn_Service")
public class BSN_Service extends BaseService {

	@Autowired private MessageService msg;

	@Autowired private MailTemplate mt;

	@Autowired private EverMailService everMailService;

	@Autowired private EverSmsService everSmsService;

	@Autowired private LargeTextService largeTextService;

	@Autowired private BSN_Mapper BSN_Mapper;

	public List<Map<String, Object>> selectUserSearch(Map<String, String> param) {

		BaseInfo baseInfo = UserInfoManager.getUserInfoImpl();
		String userType = baseInfo.getUserType();

		List<Map<String, Object>> resultList = new ArrayList<Map<String, Object>>();

		if ("S".equals(userType))
			resultList = BSN_Mapper.selectUserSearchB(param);
		else if ("B".equals(userType))
			resultList = BSN_Mapper.selectUserSearchS(param);

		return resultList;
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String doSendSms(Map<String, String> formData, List<Map<String, Object>> gridData) throws Exception {
//		BaseInfo baseInfo = UserInfoManager.getUserInfoImpl();
		String user_ids = formData.get("TFT_MEMBER");
		String contents = formData.get("CAPTION_SMS");
		ArrayList<String> list = com.st_ones.common.util.clazz.EverString.chopSplitString(contents, 80);
//		boolean multiFlag = list.size() > 1;

		Map<String, Object>  param = new HashMap<String, Object>();
		StringTokenizer st = new StringTokenizer(user_ids,",");
		ArrayList<Map<String,String>> al = new ArrayList<Map<String,String>>();
		while(st.hasMoreElements())  {
			Map<String,String> map = new LinkedHashMap<String,String>();
			map.put("value", st.nextToken());
			al.add(map);
		}
		param.put("list", al);
		param.put("USER_IDS",user_ids);

		for(Map<String, Object> data : gridData) {

			Map<String, String> map = new HashMap<String, String>();

			map.put("RECV_USER_ID", String.valueOf(data.get("RECV_USER_ID")));
			map.put("RECV_USER_NM", String.valueOf(data.get("RECV_USER_NM")));
			map.put("RECV_TEL_NUM", String.valueOf(data.get("RECV_TEL_NUM")));
			map.put("CONTENTS",      contents);
			map.put("VENDOR_CD", String.valueOf(data.get("VENDOR_CD")));
			map.put("REF_NUM", "");
			map.put("REF_MODULE_CD", "BBOS");	//참조모듈
			map.put("BUYER_CD",      "1000");

			everSmsService.sendSmsNhe(map);
		}

		return msg.getMessage("0001");
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String doSendMsg(Map<String, String> formData, List<Map<String, Object>> gridData) throws Exception {

		BaseInfo baseInfo = UserInfoManager.getUserInfoImpl();

		//메일보내는 사용자만큼 for문을 돌면서 메일을 전송한다.
		for(Map<String, Object> data : gridData) {

			Map<String,String> mdata = new HashMap<String, String>();
			mdata.put("CONTENTS", formData.get("CAPTION_MSG"));		//내용******(필수)
			mdata.put("SUBJECT", formData.get("SUBJECT"));			//제목******(필수)
			mdata.put("RECV_EMAIL", String.valueOf(data.get("RECV_EMAIL")));		//수신자메일 ******(필수)
			mdata.put("SEND_USER_ID", baseInfo.getUserId());		//전송자userId
			mdata.put("SEND_EMAIL", "");			//전송자메일
			mdata.put("SEND_USER_NM", "");		//전송자이름
			mdata.put("RECV_USER_NM", String.valueOf(data.get("RECV_USER_NM")));	//수신자이름
			mdata.put("RECV_USER_ID", String.valueOf(data.get("RECV_USER_ID")));	//수신자userId
			//mdata.put("ATT_FILE_NUM", formData.get("ATT_FILE_NUM")   );			//첨부파일 (사용안함)

			//내용 > 메일템플릿에 담기(사용자 user_type을 넘겨주세요.-사용자타입에 따른 템플릿이 미세하게 다릅니다.)*******필수
			//get_Mail_Template(스크린네임,사용자구분,mdata[내용,제목이포함되어잇는],null)
//			mdata.put("CONTENTS_TEMPLATE", mt.get_Mail_Template("메일전송",formData.get("USER_TYPE"),mdata,null));
			if (EverString.isEmpty(mdata.get("RECV_EMAIL"))) {
				continue;
			}
			//메일전송.
			everMailService.SendMail(mdata);
			mdata.clear();
		}

		return msg.getMessage("0001");
	}

	/**
	 * 화면명 : Mail/SMS 전송현황
	 * 처리내용 : Mail/SMS 전송 내역을 조회한다.
	 * 경로 : 시스템관리 > Mail/SMS > Mail/SMS 전송현황
	 */
	public List<Map<String, Object>> selectSmsMessageSendingHistory(Map<String, String> param) throws Exception {
		return BSN_Mapper.selectSmsMessageSendingHistory(param);
	}

	public Map<String, String> getSmsContent(Map<String, String> param) throws Exception {
		Map<String, String> params = BSN_Mapper.getSmsContent(param);
		params.put("CONTENTS", params.get("CONTENTS"));
		return params;
	}

	public Map<String, String> getMessageInfo(Map<String, String> param) throws Exception {

		Map<String, String> params = BSN_Mapper.getMessageInfo(param);
		String textNum = (params == null ? "" : (params.get("MSG_TEXT_NUM") == null ? "" : params.get("MSG_TEXT_NUM")));
		String subject = (params == null ? "" : (params.get("SUBJECT") == null ? "" : params.get("SUBJECT")));
		String splitString = (params == null ? "" : largeTextService.selectLargeText(textNum));
		params.put("CONTENTS", splitString);
		params.put("subject", subject);
		return params;

	}

}