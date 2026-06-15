package com.st_ones.nosession.front.web;

import com.st_ones.common.util.clazz.EverConverter;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.nosession.front.service.Front_Service;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping(value = "/")
public class Front_Controller extends BaseController {

    @Autowired
    Front_Service front_service;

    /**
     * 메인화면 - 회원가입 - 사업자번호 체크
     */
    @RequestMapping("/register/doIrsNumCheck")
    public void doIrsNumCheck(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> companyInfo = front_service.doIrsNumCheck(req.getParamDataMap());

        resp.setParameter("companyInfo", EverConverter.getJsonString(companyInfo));
    }

    /**
     * 메인화면 - ID/PW 찾기
     */
    @RequestMapping("/register/doSearchInfo")
    public void doSearchInfo(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> param = req.getParamDataMap();
        Map<String, String> reqData = new HashMap<String, String>();
        if("I".equals(param.get("sFlag"))) {
            reqData = front_service.doIdSearch(param);

        } else if("P".equals(param.get("sFlag"))) {
            reqData = front_service.doPwInfo(param);

            if(reqData == null) {
                reqData = new HashMap<String, String>();
                reqData.put("responseCode", "fail");
            } else {
                if(Integer.parseInt(String.valueOf(reqData.get("CNT"))) > 0) {
                    reqData.put("responseCode", "success");
                }
            }
            /*if(Integer.parseInt(String.valueOf(reqData.get("CNT"))) > 0) {
                // PW 메일로 전송
                // String code = reg_service.doPwSend(param);

                reqData.put("responseCode", "success");
            } else {
                reqData.put("responseCode", "fail");
            }*/
        }

        resp.sendJSON(reqData);
    }

    /**
     * 메인화면 - ID/PW 찾기
     */
    @RequestMapping("/register/doSendPwSMS")
    public void doSendPwSMS(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> formData = req.getParamDataMap();
        String msg = front_service.doPwSend(formData);

        formData.put("responseMessage", msg);

        resp.sendJSON(formData);
    }
}
