package com.st_ones.nhepro.BLOC.web;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.st_ones.common.message.service.MessageService;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.nhepro.BLOC.service.BLOC0010_Service;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : BLOC_Controller.java
 * @date 2020.07.24
 * @version 1.0
 * @see
 */

@Controller
@RequestMapping(value = "/nhepro/BLOC")
public class BLOC_Controller extends BaseController{

	@Autowired
    private MessageService msg;
	
    @Autowired
    private BLOC0010_Service bloc0010_Service;
	    
    @RequestMapping(value="/BLOC0010/view")
    public String BLOC(EverHttpRequest req) throws Exception {
    	req.setAttribute("NPKI_URL", PropertiesManager.getString("npki.private.url", ""));
        return "/nhepro/BLOC/BLOC0010";
    }
    
    @RequestMapping(value="/BLOC0020/doSearch")
    public void BLOC0020_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	 Map<String, String> param = req.getFormData();
    	 resp.setGridObject("grid", bloc0010_Service.bloc0020_doSearch(param));
         resp.setResponseCode("true");
    }
    
    @RequestMapping(value="/BLOC0020/view")
    public String BLOC0020(EverHttpRequest req) throws Exception {
        return "/nhepro/BLOC/BLOC0020";
    }
    
    @RequestMapping(value="/BLOC0030/view")
    public String BLOC0030(EverHttpRequest req) throws Exception {
        return "/nhepro/BLOC/BLOC0030";
    }
    
    @RequestMapping(value="/BLOC0030/doSearch")
    public void bloc0030_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	 Map<String, String> param = req.getFormData();

         resp.setGridObject("grid", bloc0010_Service.bloc0030_doSearch(param));
         resp.setResponseCode("true");
    }
    
}

