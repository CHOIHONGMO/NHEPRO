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
import com.st_ones.nosession.interfacez.service.ContSendErpService;

// [고도화변경] 2026.06.16 NH-ERP -> ePro 대금지급정보 연동 수신용 REST 컨트롤러 신규 생성
@Controller
@RequestMapping(value = "/nheproif")
public class NhErpPayController extends BaseController {

    @Autowired
    private ContSendErpService contSendErpService;

    // [고도화변경] 2026.06.16 NH-ERP로부터 대금지급완료 정보를 수신하여 저장/갱신하는 REST API
    @RequestMapping("/recvErpPay")
    public void recvErpPay(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        String send_data = req.getParameter("SEND_DATA");
        Map<String, Object> send_data_map = null;
        Map<String, String> resultMap = new HashMap<String, String>();
        try {
            send_data_map = EverConverter.readJsonObject(send_data, Map.class);
            contSendErpService.recvErpPay_doSave(send_data_map);
            resultMap.put("RESULT_YN", "Y");
            resultMap.put("RESULT_MSG", "SUCCESS");
        } catch (Exception e) {
            getLog().error(e.getMessage(), e);
            resultMap.put("RESULT_YN", "N");
            resultMap.put("RESULT_MSG", "FAIL: " + e.getMessage());
        }
        resp.getWriter().write(EverConverter.getJsonString(resultMap));
        System.err.println("=========================ERP INTERFACE END================================");
    }
}
