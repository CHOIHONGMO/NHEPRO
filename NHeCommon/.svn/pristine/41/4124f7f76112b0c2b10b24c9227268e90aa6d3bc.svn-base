package com.st_ones.eversrm.master.user.web;

import com.st_ones.common.combo.service.CommonComboService;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.util.clazz.EverDate;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.eversrm.master.user.service.OSYR0132_Service;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;
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
 * @File Name : OSYR0132_Controller.java
 * @date 2020.02.17
 * @version 1.0
 * @see
 */

@Controller
@RequestMapping(value = "/eversrm/master/user")
public class OSYR0132_Controller extends BaseController{

    @Autowired private MessageService msg;

    @Autowired private CommonComboService commonComboService;

    @Autowired private OSYR0132_Service osyr0132_Service;

    /**
     * 화면명 : 개인정보요청 처리현황
     * 처리내용 : 개인정보 열람 요청에 대한 처리현황을 조회하는 화면.
     * 경로 : 시스템관리 > 사용자관리 > 개인정보요청 처리현황
     */
    @RequestMapping(value="/OSYR0132/view")
    public String OSYR0132(EverHttpRequest req) throws Exception {
        // req.setAttribute("defaultFromDate", EverDate.addMonths(-1));
        req.setAttribute("defaultFromDate", EverDate.getDate());
        req.setAttribute("defaultToDate", EverDate.getDate());
        return "/eversrm/master/user/OSYR0132";
    }

    @RequestMapping(value="/OSYR0132/doSearch")
    public void osyr0132_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.setGridObject("grid", osyr0132_Service.osyr0132_doSearch(req.getFormData()));
    }

    @RequestMapping(value="/OSYR0132/doUpdate")
    public void osyr0132_doUpdate(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        List<Map<String, Object>> gridData = req.getGridData("grid");
        osyr0132_Service.osyr0132_doUpdate(gridData);

        resp.setResponseMessage(msg.getMessage("0016"));
    }
}

