package com.st_ones.common.util.clazz;

import com.st_ones.common.util.SpringContextUtil;
import com.st_ones.everf.serverside.domain.BaseCombo;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;
import org.springframework.web.servlet.FrameworkServlet;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import java.util.ArrayList;
import java.util.List;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : EverServletContextListener.java
 * @date 2013. 07. 22.
 * @version 1.0
 * @see
 */
public class EverServletContextListener implements ServletContextListener {

	public void contextDestroyed(ServletContextEvent arg0) {
		return ;
	}

	public void contextInitialized(ServletContextEvent event) {

		ServletContext sc = event.getServletContext();
		List<BaseCombo> refYNlist = new ArrayList<BaseCombo>();
		List<BaseCombo> trueFalseList = new ArrayList<BaseCombo>();
		List<BaseCombo> searchTermList = new ArrayList<BaseCombo>();

		// 순서 : TEXT, VALUE
		refYNlist.add(new BaseCombo("Y", "1"));
		refYNlist.add(new BaseCombo("N", "0"));
		sc.setAttribute("refYN", refYNlist);

		trueFalseList.add(new BaseCombo("True", "1"));
		trueFalseList.add(new BaseCombo("False", "0"));
		sc.setAttribute("refTF", trueFalseList);

		searchTermList.add(new BaseCombo("=", "E"));
		searchTermList.add(new BaseCombo("!=", "D"));
		searchTermList.add(new BaseCombo("Like", "L"));
		searchTermList.add(new BaseCombo("Not Like", "NL"));
		searchTermList.add(new BaseCombo(">", "B"));
		searchTermList.add(new BaseCombo(">=", "BE"));
		searchTermList.add(new BaseCombo("<", "S"));
		searchTermList.add(new BaseCombo("<=", "SE"));
		searchTermList.add(new BaseCombo("In", "I"));
		searchTermList.add(new BaseCombo("Not In", "NI"));
		searchTermList.add(new BaseCombo("is Null", "IN"));
		searchTermList.add(new BaseCombo("is Not Null", "INN"));
		sc.setAttribute("searchTerms", searchTermList);

		ServletContext ctx = event.getServletContext();
		WebApplicationContext springContext = WebApplicationContextUtils.getWebApplicationContext(ctx, FrameworkServlet.SERVLET_CONTEXT_PREFIX+"EverSRM Dispatcher");
		SpringContextUtil.setSpringContext(ctx, springContext);
	}
}