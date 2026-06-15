package com.st_ones.nhepro.TEST.web;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.st_ones.common.combo.service.CommonComboService;
import com.st_ones.common.util.clazz.EverDate;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.nhepro.TEST.service.TEST0010_Service;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : SVNR0010_Controller.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

@Controller
@RequestMapping(value = "/nhepro/TEST")
public class TEST0010_Controller extends BaseController {

    @Autowired private TEST0010_Service test0010_service;
    @Autowired private CommonComboService commonComboService;
    
    @RequestMapping(value="/TEST0010/view")
    public String TEST0010(EverHttpRequest req) throws Exception {
    	req.setAttribute("toDate", EverDate.getDate());

        return "/nhepro/TEST/TEST0010";
    }
    
    @RequestMapping(value = "/TEST0010/test0010_doSave")
    public void test0010_doSave(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	
    	List<Map<String, Object>> grid = req.getGridData("grid");

        Map<String, String> rtnMap = test0010_service.test0010_doSave(req.getFormData(), grid);

        resp.setResponseMessage(rtnMap.get("rtnMsg"));
       
    }
    
    
    @RequestMapping(value="/TEST0020/view")
    public String TEST0020(EverHttpRequest req) throws Exception {

        return "/nhepro/TEST/TEST0020";
    }
    
    @RequestMapping(value="/TEST0030/view")
    public String TEST0030(EverHttpRequest req) throws Exception {
    	req.setAttribute("fromDate", EverDate.addMonths(-1));
        req.setAttribute("toDate", EverDate.getDate());
        return "/nhepro/TEST/TEST0030";
    }
    
    @RequestMapping(value = "/TEST0030/test0030_doSearch")
	public void test0030_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
		resp.setGridObject("grid", test0010_service.test0030_doSearch(req.getFormData()));
	}
    
    
    @RequestMapping(value="/TEST0020P10/view")
    public String TEST0020P10(EverHttpRequest req) throws Exception {

        return "/nhepro/TEST/TEST0020P10";
             
    }
    
    @RequestMapping(value="/TEST0020P10/test0020P10_doSearch")
    public void test0020P10_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
       // Map<String, String> param = req.getFormData();

    	resp.setGridObject("grid", test0010_service.test0020P10_doSearch(req.getFormData()));
      //  resp.setGridObject("grid", test0010_service.test0020P10_doSearch(param));
      //  resp.setResponseCode("true");
    }
    
    @RequestMapping(value = "/TEST0020P10/test0020P10_doSave")
    public void test0020P10_doSave(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	List<Map<String, Object>> grid = req.getGridData("grid");

        Map<String, String> rtnMap = test0010_service.test0020P10_doSave(req.getFormData(), grid);

        resp.setResponseMessage(rtnMap.get("rtnMsg"));
       
    }
    
    @RequestMapping(value="/TEST0020P10/test0020P10_doDelete")
    public void test0020P10_doDelete(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        List<Map<String, Object>> gridData = req.getGridData("grid");

        test0010_service.test0020P10_doDelete(gridData);
    }
    
    
  
    
    
    
    @RequestMapping(value="/TEST0040/view")
    public String TEST0040(EverHttpRequest req) throws Exception {

        return "/nhepro/TEST/TEST0040";        
    }
    
    @RequestMapping(value="/TEST0050/view")
    public String TEST0050(EverHttpRequest req) throws Exception {

        return "/nhepro/TEST/TEST0050";     
    }
    

}
