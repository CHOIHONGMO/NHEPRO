package com.st_ones.nosession.interfacez.web;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.st_ones.common.util.clazz.EverConverter;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.nosession.interfacez.service.PmsService;

@Controller
@RequestMapping(value = "/nheproif")//pmsInterface
public class PmsController extends BaseController {


    @Autowired
    PmsService pmsservice;


    @RequestMapping("/pms")
    public void pms(EverHttpRequest req, EverHttpResponse resp) throws Exception {

    	String send_data = req.getParameter("SEND_DATA");
    	
    	Map<String,Object> send_data_map = null;
    	Map<String, String> resultMap = null;
    	try {
        	resultMap = new HashMap<String,String>();
        	send_data_map = EverConverter.readJsonObject(send_data, Map.class);
        	
    		// PMS 적용
        	pmsservice.pms_doSave(send_data_map);
        	
        	resultMap.put("RESULT_YN", "Y");
        	resultMap.put("RESULT_MSG", "SUCCESS");
    	}
    	catch (Exception e) {
			getLog().error(e.getMessage(), e);
        	resultMap.put("RESULT_YN", "N");
        	resultMap.put("RESULT_MSG", "FAIL");
    	}
    	
    	resp.getWriter().write(EverConverter.getJsonString(resultMap));
    	System.err.println("=========================INTERFACE END================================");
    }

}
