package com.st_ones.common.session.web;

import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.common.util.clazz.EverString;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;
import java.util.ArrayList;
import java.util.Hashtable;
import java.util.Iterator;

/**
 * <pre>
 * *****************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 * *****************************************************************************
 * </pre>
 * @File Name : EverHttpSessionListener.java
 * @date 2013. 12. 01.
 * @version 1.0
 * @see
 */
public class EverHttpSessionListener implements HttpSessionListener {

    Logger logger = LoggerFactory.getLogger(EverHttpSessionListener.class);

    private static EverHttpSessionListener everHttpSessionListener = null;

    private static Hashtable<String, UserInfo> loginUsersTable = new Hashtable();
    private static ArrayList<UserInfo> userToLogoutList = new ArrayList();

    public static synchronized EverHttpSessionListener getInstance(){
        if(everHttpSessionListener == null){
            everHttpSessionListener = new EverHttpSessionListener();
        }
        return everHttpSessionListener;
    }

    public synchronized void addLoginUser(String jsessionId, UserInfo newUserInfo) {
        newUserInfo.setJsessionId(jsessionId);
        loginUsersTable.put(jsessionId, newUserInfo);
        printLoginUsers();
    }

    public synchronized void addUserToLogout(UserInfo logoutUserInfo) {

        userToLogoutList.add(logoutUserInfo);
        Iterator<String> iterator = loginUsersTable.keySet().iterator();
        while(iterator.hasNext()) {
            String jSessionId = iterator.next();
            UserInfo loginUserInfo = loginUsersTable.get(jSessionId);
            if(loginUserInfo.getUserId().equals(logoutUserInfo.getUserId())
                    && loginUserInfo.getUserType().equals(logoutUserInfo.getUserType())) {
                //loginUsersTable.remove(jSessionId);
                break;
            }
        }
    }

    public boolean isUserToLogout(UserInfo targetUserInfo) {

        for (UserInfo userToLogout : userToLogoutList) {

            if(userToLogout.getUserId().equals(targetUserInfo.getUserId())
                    && userToLogout.getUserType().equals(targetUserInfo.getUserType())
                    && userToLogout.getIpAddress().equals(targetUserInfo.getIpAddress())) {
                return true;
            }
        }

        return false;
    }

    public synchronized UserInfo getLoggedUserInfo(String userId, String userType) {

        Iterator<String> iterator = loginUsersTable.keySet().iterator();
        while(iterator.hasNext()) {
            String jSessionId = iterator.next();
            UserInfo userInfo = loginUsersTable.get(jSessionId);
            if(userInfo.getUserId().equals(userId)
                    && userInfo.getUserType().equals(userType)) {
                return userInfo;
            }
        }

        return null;
    }

    public void printLoginUsers() {
//        logger.info("-- LoginUser List ----------------");
//        for (String userId : loginUsersTable.keySet()) {
//            UserInfo userInfo = loginUsersTable.get(userId);
//            logger.info("{} ({})", userInfo.getUserId(), userInfo.getIpAddress());
//        }
//        logger.info("----------------------------------");
    }

    @Override
    public void sessionCreated(HttpSessionEvent httpSessionEvent) {
        HttpSession session = httpSessionEvent.getSession();
        logger.info("Session created: "+session.getId());
    }

    @Override
    public synchronized void sessionDestroyed(HttpSessionEvent httpSessionEvent) {
        HttpSession session = httpSessionEvent.getSession();
        String jSessionId = session.getId();
        logger.info("Session destroyed: {} / Last Accessed Time: {} / max Inactive interval time: {}", jSessionId, session.getLastAccessedTime(), session.getMaxInactiveInterval());

        if(loginUsersTable.containsKey(jSessionId)) {

            try {
                UserInfo userInfo = loginUsersTable.get(jSessionId);
                logger.info(EverString.setEncryptedString(userInfo.getUserNm(), "N") + "[" + userInfo.getIpAddress() + "] 님이 로그아웃되었습니다.");
            } catch (Exception e) {
                logger.error(e.getMessage(), e);
            } finally {
                //loginUsersTable.remove(jSessionId);
                printLoginUsers();
            }
        }
    }

    public void removeLogoutTargetUser(UserInfo targetUserInfo) {

        for (UserInfo userToLogout : userToLogoutList) {

            if(userToLogout.getUserId().equals(targetUserInfo.getUserId())
                    && userToLogout.getUserType().equals(targetUserInfo.getUserType())) {
                userToLogoutList.remove(userToLogout);
                break;
            }
        }
    }
}
