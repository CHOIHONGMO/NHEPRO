package com.st_ones.common.interceptor;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.st_ones.common.cache.data.ScrnCache;
import com.st_ones.common.interceptor.service.ScreenInterceptorService;
import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.util.clazz.EverDate;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.everf.serverside.config.BaseConstant;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.info.BaseInfo;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.threadlocal.GlobalMapThreadLocal;
import com.st_ones.everf.serverside.util.StringUtil;
import com.st_ones.everf.serverside.util.clazz.SessionIgnore;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import org.apache.commons.lang3.StringUtils;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import javax.servlet.ServletContext;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : ScreenInterceptor.java
 * @date 2013. 07. 22.
 * @version 1.0
 * @see
 */
public class ScreenInterceptor extends HandlerInterceptorAdapter {

	private Logger logger = LoggerFactory.getLogger(ScreenInterceptor.class);

	@Autowired private ScreenInterceptorService screenInterceptorService;

	@Autowired private ScrnCache scrnCache;

	@Autowired private MessageService msg;

	private String[] allowedUrlsForVirtualSessions;

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
		return super.preHandle(request, response, handler);
	}

	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {

		EverHttpRequest req = (EverHttpRequest) request;
		// 세션없는 화면 구현 시 com.st_ones.nosession 밑에 개발하면 됩니다.

//		HandlerMethod method = (HandlerMethod) handler;
//		boolean isSessionIgnore = method.getMethod().isAnnotationPresent(SessionIgnore.class)
//				|| method.getClass().isAnnotationPresent(SessionIgnore.class);
//
//		if(isSessionIgnore) {
//			return;
//		}

		doNormalProcess(request, modelAndView, req, response);
		super.postHandle(request, response, handler, modelAndView);
	}

    @SessionIgnore
	private void doNormalProcess(HttpServletRequest request, ModelAndView modelAndView, EverHttpRequest req, HttpServletResponse response) throws Exception {

    	request.setCharacterEncoding("UTF-8");

		if (PropertiesManager.getBoolean("eversrm.system.urlDirectInputPermission", false)) {
            //if (!PropertiesManager.getBoolean("eversrm.system.developmentFlag", false)) {
                if (EverString.isEmpty(req.getHeader("referer"))) {
//                    throw new InternetSecurityException(msg.getMessage("0043"));
                }
            //}
		}

		String screenURL = request.getRequestURI();
		String screenId = request.getParameter("SCREEN_ID");

		// show.so 첨부파일용...
		int screenURLExceptionCnt = screenURL.indexOf("show.so");

		if (screenURLExceptionCnt < 0) {

			screenInterceptorService.checkScreenURL(screenURL);

			// Screen attribute setting.
			if (screenId == null || "".equals(screenId)) {
				screenId = screenInterceptorService.getScreenId(screenURL);
			}

			// 사용자 ScreenId 를 담는다.
            UserInfoManager.getUserInfo().setScreenId(screenId);

			String moduleType = request.getParameter("moduleType");
			String screenName = request.getParameter("screen_name");
			boolean popupFlag = Boolean.parseBoolean(request.getParameter("popupFlag"));
			boolean detailView = Boolean.parseBoolean(request.getParameter("detailView"));
			boolean buttonView = Boolean.parseBoolean(EverString.defaultIfEmpty(request.getParameter("buttonView"), "1"));
			if(request.getAttribute("detailView") != null) {
				detailView = Boolean.parseBoolean(String.valueOf(request.getAttribute("detailView")));
			}
			String tmplMenuCd = request.getParameter("tmpl_menu_cd");

			if(modelAndView != null) {
                String viewName = modelAndView.getViewName();
                Map<String, Object> maskInfo = null;

                // 화면별 마스킹 선결, 후결 여부를 조회한다.
                Map<String, Object> screenMaskTypeInfo = screenInterceptorService.getScreenApprovalType(screenId);

                // screenId 로 마스킹 승인 여부를 가져온다.
                if(screenMaskTypeInfo != null) {
                    maskInfo = screenInterceptorService.getMaskInfo(screenId, EverDate.getDate());
                }

                Map<String, String> tmp = screenInterceptorService.getBreadCrumbs(screenId, moduleType, popupFlag, viewName, detailView, tmplMenuCd, screenName);
                modelAndView.addAllObjects(tmp);

                Map<String, String> screenMessageMap = screenInterceptorService.getScreenMessage(screenId);
                modelAndView.addAllObjects(screenMessageMap);

                Map<String, String> formInfoMap = screenInterceptorService.getFormInfo(req, screenId, detailView, maskInfo);
                modelAndView.addAllObjects(formInfoMap);

                if(GlobalMapThreadLocal.get(BaseConstant.THREAD_LOCAL_USERINFO_KEY) != null) {
                	String newScreenId = screenId;

        			String screenType = request.getParameter("TYPE");
        			if (screenType != null && !"".equals(screenType)) {
        				newScreenId = newScreenId + "_" + screenType.substring(0, 1);
        			}

        			Map<String, String> buttonInfoMap = screenInterceptorService.getButtonInfo(newScreenId, detailView, buttonView, popupFlag);
                    modelAndView.addAllObjects(buttonInfoMap);
                }

                Map<String, Object> toolbarInfo = screenInterceptorService.getToolbarInfo(screenId, tmplMenuCd);

                Properties props = new Properties();
                try {
                    props.load(new InputStreamReader(getClass().getResourceAsStream("/everuxf.properties"), "MS949"));
                } catch (IOException e) {
                    logger.error("/WEB-INF 디렉토리 밑에 everuxf.properties 파일이 존재하지 않습니다.", e);
                }

                Map<String, Object> initDataMap = new HashMap<String, Object>();
                initDataMap.put("langCd", UserInfoManager.getUserInfo().getLangCd());
                initDataMap.put("sessionType", ("VIRTUAL".equals(UserInfoManager.getUserInfo().getUserId()) ? "virtual" : "normal"));
                initDataMap.put("screenCd", screenId);
                initDataMap.put("templateMenuCd", tmplMenuCd);
                initDataMap.put("theme", props.getProperty("evf.theme", "neo"));
                initDataMap.put("userId", UserInfoManager.getUserInfo().getUserId());
                initDataMap.put("userType", UserInfoManager.getUserInfo().getUserType());

                if (screenMaskTypeInfo != null) {
                    initDataMap.put("maskView", true);
                    initDataMap.put("approvalType", screenMaskTypeInfo.get("APPROVAL_TYPE"));
                }

                if (maskInfo != null) {
                    initDataMap.put("screenCrud", maskInfo.get("SCREEN_CRUD"));
                    initDataMap.put("maskApproval", true);
                }

                initDataMap.putAll(toolbarInfo);
                req.setAttribute("initData", new JSONObject(initDataMap).toJSONString());

                modelAndView.addObject("st_default", PropertiesManager.getString("eversrm.style.multiSearchDefaultValue"));

                String excelDownMode = screenInterceptorService.getExcelDownMode(screenId);
                excelDownMode = EverString.nullToEmptyString(excelDownMode);

                tmp.clear();
                tmp.put("allCol", (excelDownMode.equals("B") || excelDownMode.equals("D")) ? "true" : "false");
                tmp.put("selRow", (excelDownMode.equals("C") || excelDownMode.equals("D")) ? "true" : "false");
                tmp.put("fileType", PropertiesManager.getString("everF.excel.fileType"));
                modelAndView.addObject("excelExport", tmp);

                // Common comboBox setting.
                ObjectMapper om = new ObjectMapper();
                ServletContext servletContext = req.getSession().getServletContext();
                req.setAttribute("searchTerms", om.writeValueAsString(servletContext.getAttribute("searchTerms")));
                req.setAttribute("refYN", om.writeValueAsString(servletContext.getAttribute("refYN")));
                req.setAttribute("refTF", om.writeValueAsString(servletContext.getAttribute("refTF")));
                req.setAttribute("_gridType", scrnCache.getGridTypeByScreenId(screenId));
            }
		}
	}
}