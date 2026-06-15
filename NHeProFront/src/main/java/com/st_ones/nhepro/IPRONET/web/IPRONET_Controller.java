package com.st_ones.nhepro.IPRONET.web;

import com.st_ones.nhepro.IPRONET.service.IPRONET_Service;
import com.st_ones.everf.serverside.util.clazz.SessionIgnore;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.common.combo.service.CommonComboService;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : IPRONET_Controller.java
 * @date 2021.05.11
 * @version 1.0
 * @see
 */

@Controller
@RequestMapping(value = "/nhepro/IPRONET")
public class IPRONET_Controller extends BaseController{
    @Autowired
    private MessageService msg;
    @Autowired
    private IPRONET_Service ipronet_Service;
    @Autowired
    private CommonComboService commonComboService;

    /**
	 * 화면명 : 농협정보시스템 내부 시스템 "아이프로넷" 에서 남은 결재건수, 협력업체 대기건수 조회해가는 API
	 * 처리내용 : 
	 * 경로 :  > > 
	 */
    @SessionIgnore
    @RequestMapping(value="/approvalCount")
    public @ResponseBody String IpronetLogin(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	
    	// 사번
    	String userId = req.getParameter("userId");
    	Map<String, String> param = new HashMap<>();
    	param.put("userId", userId);
    	
    	String returnStr = ipronet_Service.ipronet_getCount(param);
    	System.out.println("returnStr" + returnStr);
		return returnStr;
    }
    
    /**
	 * 화면명 : 농협정보시스템 내부 시스템 "아이프로넷" 에서 남은 결재건수, 협력업체 대기건수 조회해가는 JSONP API
	 * 처리내용 : 
	 * 경로 :  > > 
	 */
    @SessionIgnore
    @RequestMapping(value="/approvalCountP")
    public @ResponseBody String IpronetLoginJsonp(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	
    	// 사번
    	String userId = req.getParameter("userId");
    	String callback = req.getParameter("callback");    	
    	Map<String, String> param = new HashMap<>();
    	param.put("userId", userId);
    	param.put("callback", callback);
    	
    	String returnStr = ipronet_Service.ipronet_getCountJsonp(param);
    	System.out.println("returnStr" + returnStr);
		return returnStr;
    }
    

	

}

