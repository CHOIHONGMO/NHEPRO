package com.st_ones.common.session.web;

import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.exception.InternetSecurityException;
import com.st_ones.everf.serverside.info.BaseInfo;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.util.clazz.SessionIgnore;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**  
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며, 
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>  
 * @File Name : VirtualSessionController.java
 * @date 2013. 07. 22.
 * @version 1.0  
 * @see 
 */
@Controller
@RequestMapping(value = "/session/viewContents")
public class VirtualSessionController extends BaseController {

	@Autowired private MessageService messageService;

	@SessionIgnore
	@RequestMapping(value = "/view")
	public void createSession(EverHttpRequest req, EverHttpResponse resp) throws Exception {
		
		UserInfo baseInfo = new UserInfo();
		baseInfo.setGateCd(PropertiesManager.getString("eversrm.gateCd.default"));
		baseInfo.setLangCd(PropertiesManager.getString("eversrm.langCd.default"));
		baseInfo.setDatabaseCd(PropertiesManager.getString("eversrm.system.database"));
		baseInfo.setUserGmt(PropertiesManager.getString("eversrm.gmt.default"));
		baseInfo.setSystemGmt(PropertiesManager.getString("eversrm.gmt.default"));

		String langCode = req.getParameter("langCd");
		if(EverString.isNotEmpty(langCode)){
			baseInfo.setLangCd(langCode);
		}
		
		baseInfo.setUserId("VIRTUAL");
		baseInfo.setUserNm("가상 로그인");
		baseInfo.setUserNmEng("Virtual Session");
		baseInfo.setUserType(req.getParameter("userType"));
		baseInfo.setDateFormat("yyyy/MM/dd");
		baseInfo.setDateValueFormat("yyyy/MM/dd");
		baseInfo.setNumberFormat("###,##0.00");
		baseInfo.setIpAddress(req.getRemoteAddr());
		baseInfo.setManageCd("1000");
		UserInfoManager.createUserInfo(baseInfo);
		
		Map<String, BaseInfo> resultInfo = new HashMap<String, BaseInfo>();
		resultInfo.put("baseInfo", baseInfo);
		HttpSession httpSession = req.getSession();
		httpSession.setAttribute("ses", baseInfo);
		req.setAttribute("ses", resultInfo.get("baseInfo"));		
		
		List<Map<String, String>> msgResults = messageService.getCommonMsg();

		Map<String, String> msg = new HashMap<String, String>();
		for (Map<String, String> msgResult : msgResults) {
			msg.put(msgResult.get("MULTI_CD"), msgResult.get("MULTI_CONTENTS"));
		}
		httpSession.setAttribute("msg", msg);
		
		Map<String, String> params = reqParamMapToStringMap(req.getParameterMap());
		Set<String> keySet = params.keySet();
		int i = 0;

		for (String key : keySet) {
			httpSession.setAttribute(key, params.get(key));
			
			if(key.equals("realUrl")) {
				continue;
			}
			
			if(i ==0) {
//				paramValues += "?";
			}
			
			i++;
			
			req.setAttribute(key, params.get(key));
		}

		// realUrl web.xml 접근 제어
		if(req.getParameter("realUrl").indexOf("xml") > -1) {
			throw new InternetSecurityException(messageService.getMessage("0043"));
		}

		RequestDispatcher dispatcher = req.getRequestDispatcher(req.getParameter("realUrl"));
		dispatcher.forward(req, resp);
	}
}
