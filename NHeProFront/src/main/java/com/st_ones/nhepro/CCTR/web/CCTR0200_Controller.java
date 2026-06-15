package com.st_ones.nhepro.CCTR.web;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.st_ones.common.util.clazz.EverDate;
import com.st_ones.common.combo.service.CommonComboService;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.nhepro.CCTR.service.CCTR0200_Service;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : CCTR0200_Controller.java
 * @date 2020.04.17
 * @version 1.0
 * @see
 */

@Controller
@RequestMapping(value = "/nhepro/CCTR")
public class CCTR0200_Controller extends BaseController {
	
    @Autowired
    private CCTR0200_Service cctr0200_Service;
    @Autowired
    private CommonComboService commonComboService;
    
	/**
	 * 화면명 :
	 * 처리내용 :
	 * 경로 :  > >
	 */
    @RequestMapping(value = "/CCTR0200/view")
    public String CCTR0200(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        req.setAttribute("formTypes", commonComboService.getCodeComboAsJson("M078"));
        req.setAttribute("fromDate", EverDate.addDateMonth(EverDate.getDate(), -3));
        req.setAttribute("toDate", EverDate.addDateMonth(EverDate.getDate(), 1));
        return "/nhepro/CCTR/CCTR0200";
    }
    
    @RequestMapping(value="/CCTR0200/cctr0200_doSearch")
    public void cctr0200_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	
    	Map<String, String> param = req.getFormData();
    	
        resp.setGridObject("grid", cctr0200_Service.cctr0200_doSearch(param));
    }
}

