package com.st_ones.common.util.clazz;

import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.util.clazz.SessionIgnore;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.Aspect;

import javax.servlet.http.HttpSession;
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
 * @File Name : MaskingProcessor.java
 * @date 2013. 07. 22.
 * @version 1.0
 * @see
 */
@SessionIgnore
@Aspect
public class MaskingProcessor {

	public void beforeMethod(JoinPoint joinPoint) throws Exception {

		EverHttpRequest everHttpRequest = null;
		EverHttpResponse everHttpResponse = null;

		Object[] args = joinPoint.getArgs();
		for (Object arg : args) {

			if(arg instanceof EverHttpRequest) {
				everHttpRequest = (EverHttpRequest)arg;
			} else if(arg instanceof EverHttpResponse) {
				everHttpResponse = (EverHttpResponse)arg;
			}
		}

		if(everHttpRequest != null && everHttpResponse != null) {

			everHttpRequest = (EverHttpRequest) joinPoint.getArgs()[0];
			everHttpResponse = (EverHttpResponse) joinPoint.getArgs()[1];

			String screenId = everHttpRequest.getFormData().get("_screenId");
			everHttpResponse.setScreenId(screenId);

			// User Session 정보 가져오기
			HttpSession session = everHttpRequest.getSession(true);
			UserInfo userInfo = (UserInfo) session.getAttribute("ses");

			if(PropertiesManager.getBoolean("eversrm.system.localserver")) {
				String maskDefinitions = everHttpRequest.getFormData().get("_maskDefinitions");
				everHttpResponse.setMaskDefinitions(maskDefinitions);
			} else {
				if(userInfo != null) {
					if(!"1".equals(userInfo.getSuperUserFlag())) {
						String maskDefinitions = everHttpRequest.getFormData().get("_maskDefinitions");
						everHttpResponse.setMaskDefinitions(maskDefinitions);
					}
				}
			}
		}
	}
}