package com.st_ones.nosession.web;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.st_ones.common.util.clazz.EverConverter;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.nosession.service.VendorService;

@Controller
@RequestMapping(value = "/")//
public class VendorController extends BaseController {


    @Autowired
    VendorService vendorservice;


    @RequestMapping("/getVendorInfo")
    public void getVendorInfo(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	String companyCd = req.getParameter("companyCd");
    	Map<String, String> param = new HashMap<String,String>();
    	param.put("companyCd", companyCd);
    	resp.getWriter().write(EverConverter.getJsonString(vendorservice.getVendorInfo(param)));
    }

}
