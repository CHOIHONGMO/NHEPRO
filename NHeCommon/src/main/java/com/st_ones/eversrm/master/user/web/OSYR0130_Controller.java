package com.st_ones.eversrm.master.user.web;

import com.st_ones.common.util.clazz.EverDate;
import com.st_ones.eversrm.master.user.service.OSYR0130_Service;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.common.combo.service.CommonComboService;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

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
 * @File Name : OSYR0130_Controller.java
 * @date 2020.02.17
 * @version 1.0
 * @see
 */

@Controller
@RequestMapping(value = "/eversrm/master/user")
public class OSYR0130_Controller extends BaseController{

    @Autowired private MessageService msg;

    @Autowired private CommonComboService commonComboService;

    @Autowired private OSYR0130_Service osyr0130_Service;

    /**
     * 화면명 : 개인정보요청현황
     * 처리내용 : 개인정보 열람요청을 조회/승인/반려하는 화면.
     * 경로 : 시스템관리 > 사용자관리 > 개인정보요청현황
     */
    @RequestMapping(value="/OSYR0130/view")
    public String OSYR0130(EverHttpRequest req) throws Exception {
        // req.setAttribute("defaultFromDate", EverDate.addMonths(-1));
        req.setAttribute("defaultFromDate", EverDate.getDate());
        req.setAttribute("defaultToDate", EverDate.getDate());
        return "/eversrm/master/user/OSYR0130";
    }

    @RequestMapping(value="/OSYR0130/doSearch")
    public void osyr0130_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.setGridObject("grid", osyr0130_Service.osyr0130_doSearch(req.getFormData()));
    }

    @RequestMapping(value="/OSYR0130/doSearchSub")
    public void osyr0130_doSearchSub(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> param = req.getParamDataMap();
        param.putAll(req.getFormData());
        param.put("USER_ID", req.getParameter("USER_ID"));

        resp.setGridObject("gridSub", osyr0130_Service.osyr0130_doSearchSub(param));
    }

}