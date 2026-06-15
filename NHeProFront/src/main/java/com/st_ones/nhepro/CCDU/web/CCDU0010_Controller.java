package com.st_ones.nhepro.CCDU.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.st_ones.common.combo.service.CommonComboService;
import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.util.clazz.EverConverter;
import com.st_ones.common.util.clazz.EverDate;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.nhepro.CCDU.service.CCDU0010_Service;
import com.st_ones.nosession.interfacez.service.ContSendErpService;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : CCDU0010_Controller.java
 * @date 2020.06.10
 * @version 1.0
 * @see
 */

@Controller
@RequestMapping(value = "/nhepro/CCDU")
public class CCDU0010_Controller extends BaseController{
    @Autowired
    private MessageService msg;
    @Autowired
    private CCDU0010_Service ccdu0010_Service;
    @Autowired
    private CommonComboService commonComboService;
    @Autowired
    private ContSendErpService contsenderpservice;

    @RequestMapping(value="/CCDU0010/view")
    public String CCDU0010(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        req.setAttribute("form", req.getParamDataMap());
        return "/nhepro/CCDU/CCDU0010";
    }
    
    @RequestMapping(value="/CCDU0010/ccdu0010_doSearch")
    public void ccdu0010_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.setGridObject("grid", ccdu0010_Service.ccdu0010_doSearch(req.getFormData()));
    }
    
    @RequestMapping(value="/CCDU0010/ccdu0010_getCust")
    public void ccdu0010_getCust(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        resp.setParameter("CUST_CD", EverConverter.getJsonString(ccdu0010_Service.ccdu0010_getCust(req.getFormData())));

        resp.setResponseCode("0001");
    }
    
    @RequestMapping(value="/CCDU0020/view")
    public String CCDU0020(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        req.setAttribute("form", req.getParamDataMap());
        return "/nhepro/CCDU/CCDU0020";
    }

    @RequestMapping(value="/CCDU0020/ccdu0020_doSearch")
    public void ccdu0020_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.setGridObject("grid", ccdu0010_Service.ccdu0020_doSearch(req.getFormData()));
    }

    @RequestMapping(value="/CCDU0030/view")
    public String CCDU0030(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        req.setAttribute("form", req.getParamDataMap());
        return "/nhepro/CCDU/CCDU0030";
    }

    @RequestMapping(value="/CCDU0010/ccdu0030_doSearch")
    public void ccdu0030_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.setGridObject("grid", ccdu0010_Service.ccdu0030_doSearch(req.getFormData()));
    }
}

