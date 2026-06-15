package com.st_ones.common.util;

import com.st_ones.common.util.service.UtilService;
import org.springframework.context.ApplicationContext;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;
import org.springframework.web.servlet.FrameworkServlet;

import javax.servlet.ServletContext;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : SpringContextUtil.java
 * @date 2013. 07. 22.
 * @version 1.0
 * @see
 */
public class SpringContextUtil {

	private static ServletContext servletContext = null;
	private static ApplicationContext springContext = null;

	public static void setSpringContext(ServletContext _servletContext, WebApplicationContext _springContext) {
		SpringContextUtil.servletContext = _servletContext;
		SpringContextUtil.springContext = _springContext;
	}

	public static <T> T getBean(Class<T> t) {

		if(springContext == null) {
			springContext = WebApplicationContextUtils.getWebApplicationContext(servletContext, FrameworkServlet.SERVLET_CONTEXT_PREFIX+"EverSRM Dispatcher");
		}

		return SpringContextUtil.springContext.getBean(t);
	}

	public static UtilService getUtilService() {
		return getBean(UtilService.class);
	}
}