package com.st_ones.common.interceptor;

import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.common.session.web.EverHttpSessionListener;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.threadlocal.GlobalMapThreadLocal;
import com.st_ones.everf.serverside.util.clazz.SessionIgnore;
import com.st_ones.everf.serverside.web.interceptor.PropertyNotInjectException;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.slf4j.MDC;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.PrintWriter;
import java.util.Map;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : SessionInterceptor.java
 * @date 2013. 07. 22.
 * @version 1.0
 * @see
 */
public class SessionInterceptor extends HandlerInterceptorAdapter {

    private String noSessionRedirectUrl;
    private final String SESSION_ATTRIBUTE_NAME = "ses";
    private Logger logger = LoggerFactory.getLogger(SessionInterceptor.class);

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {

        HandlerMethod method = (HandlerMethod) handler;

        boolean isSessionIgnore = method.getMethod().isAnnotationPresent(SessionIgnore.class)
                || method.getClass().isAnnotationPresent(SessionIgnore.class);

        if (isSessionIgnore) {
            return super.preHandle(request, response, handler);
        } else {

            HttpSession httpSession = request.getSession(false);
            UserInfo userInfo;

            if (this.noSessionRedirectUrl == null) {
                throw new PropertyNotInjectException("Redirect URL for no session is required!!");
            }

            if(httpSession == null || httpSession.getAttribute(SESSION_ATTRIBUTE_NAME) == null) {						// 로그아웃된 상태
            	if(request.getContentType() == null) {                                                                  // 화면으로 접근

                    PrintWriter pw = response.getWriter();
                    response.setContentType("text/html");
                    pw.write("<html><script>top.location.href=\"/\";</script></html>");

                } else {                                                                                                // AJAX로 접근
                    response.setStatus(440);
                }
                return false;
            }

            if(httpSession.getAttribute(SESSION_ATTRIBUTE_NAME) != null) {                                              // 로그인된 상태라면

                userInfo = (UserInfo) httpSession.getAttribute(SESSION_ATTRIBUTE_NAME);

                EverHttpSessionListener instance = EverHttpSessionListener.getInstance();
                if(instance.isUserToLogout(userInfo)) {

                    logger.warn(userInfo.getUserId()+" logged in with another IP!");
                    httpSession.invalidate();

                    if(request.getContentType() == null) { /* Calling page */
                        PrintWriter pw = response.getWriter();
                        response.setContentType("text/html");
                        pw.write("<script>alert('다른 기기에서 로그인되어 로그아웃처리되었습니다.');");
                        pw.write("top.location.href='/';</script>");
                    } else {
                        response.setStatus(441);
                    }

                    instance.removeLogoutTargetUser(userInfo);
                    return false;

                }
            }

            /* 상단으로 이동 및 httpSession == null 추가
            if (httpSession.getAttribute(SESSION_ATTRIBUTE_NAME) == null) {                                             // 로그아웃된 상태
                if(request.getContentType() == null) {                                                                  // 화면으로 접근
                    PrintWriter pw = response.getWriter();
                    response.setContentType("text/html");
                    pw.write("<html><script>top.location.href=\"/\";</script></html>");
                } else {                                                                                                // AJAX로 접근
                    response.setStatus(440);
                }
                return false;
            }*/

            userInfo = (UserInfo) httpSession.getAttribute(SESSION_ATTRIBUTE_NAME);

            GlobalMapThreadLocal.removeAll();
            UserInfoManager.createUserInfo(userInfo);
            if(userInfo.getUserId() != null) {
                MDC.put("userId", "["+ EverString.setEncryptedString(userInfo.getUserNm(), "N")+"] ");

                String requestURI = request.getRequestURI();
                String screenId = "";
                if(requestURI.indexOf("view.so") > -1) {
                    String[] requestURIArr = requestURI.split("/");
                    screenId = requestURIArr[requestURIArr.length - 2];
                } else {
                    screenId = userInfo.getScreenId();
                }

                MDC.put("screenId", screenId);
            }
        }
        return super.preHandle(request, response, handler);
    }

    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {

        HandlerMethod method = (HandlerMethod) handler;
        boolean isSessionIgnore = method.getMethod().isAnnotationPresent(SessionIgnore.class)
                || method.getClass().isAnnotationPresent(SessionIgnore.class);

        if (isSessionIgnore) {
            GlobalMapThreadLocal.removeAll();
            super.postHandle(request, response, handler, modelAndView);
        } else {

            HttpSession httpSession = request.getSession(false);
            UserInfo userInfo = UserInfoManager.getUserInfo();

            boolean isOneShotSession = (userInfo != null && userInfo.getUserId() != null && userInfo.getUserId().equals("SYSTEM"));
            if (isSessionIgnore && isOneShotSession) {
                httpSession.invalidate();
            }
            GlobalMapThreadLocal.removeAll();
            super.postHandle(request, response, handler, modelAndView);
        }
    }

    public void setNoSessionRedirectUrl(String noSessionRedirectUrl) {
        this.noSessionRedirectUrl = noSessionRedirectUrl;
    }
}