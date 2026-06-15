package com.st_ones.nhepro.CPCR.web;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.st_ones.common.combo.service.CommonComboService;
import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.util.clazz.EverDate;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.nhepro.CPCR.service.CPCR0010_Service;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : CPCR0010_Controller.java
 * @date 2022. 04. 15.
 * @version 1.0
 */

@Controller
@RequestMapping(value = "/nhepro/CPCR")
public class CPCR0010_Controller extends BaseController {

    @Autowired private CPCR0010_Service cpcr0010_service;
    @Autowired private CommonComboService commonComboService;
    @Autowired private MessageService msg;

    /**
     * 화면명 : 대금지급현황
     * 처리내용 : 대금지급요청 현황을 조회하여 심사 및 지급내역을 등록하는 화면
     * 경로 : 고객사 > 발주관리 > 대금지급 > 대금지급현황
     */
    @RequestMapping(value="/CPCR0010/view")
    public String CPCR0010(EverHttpRequest req) throws Exception {
    	
        UserInfo userInfo = UserInfoManager.getUserInfo();
        
        req.setAttribute("payFromDate", EverDate.addDateMonth(EverDate.getDate(), -1));
        req.setAttribute("payToDate", EverDate.getDate());

        return "/nhepro/CPCR/CPCR0010";
    }

    // 조회
    @RequestMapping(value = "/cpcr0010_doSearch")
    public void cpcr0010_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> param = req.getFormData();

        resp.setGridObject("grid", cpcr0010_service.cpcr0010_doSearch(param));
    }

}
