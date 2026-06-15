package com.st_ones.eversrm.master.user.web;

import com.st_ones.common.util.clazz.EverConverter;
import com.st_ones.common.util.clazz.EverDate;
import com.st_ones.eversrm.master.user.service.OSYR0131_Service;
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
 * @File Name : OSYR0131_Controller.java
 * @date 2020.02.17
 * @version 1.0
 * @see
 */

@Controller
@RequestMapping(value = "/eversrm/master/user")
public class OSYR0131_Controller extends BaseController{

    @Autowired private MessageService msg;

    @Autowired private CommonComboService commonComboService;

    @Autowired private OSYR0131_Service osyr0131_Service;

    /**
     * 화면명 : 개인정보 열람요청
     * 처리내용 : 개인정보 열람을 요청하는 화면
     * 경로 : Popup
     */
    @RequestMapping(value="/OSYR0131/view")
    public String OSYR0131(EverHttpRequest req) throws Exception {

        String date = EverDate.getDate();
        Map<String, String> map = req.getParamDataMap();

        if (map.get("ACCESS_DATE") == null) {
            map.put("ACCESS_DATE", date);
        }

        // 개인정보해제요청 여부 조회
        Map<String, String> maskInfo = osyr0131_Service.osyr0131_doSearech(map);

        if(maskInfo != null) {
            map.putAll(maskInfo);
        }

        req.setAttribute("defaultDate", date);
        req.setAttribute("form", map);
        return "/eversrm/master/user/OSYR0131";
    }

    @RequestMapping(value="/OSYR0131/doMaskApproval")
    public void osyr0131_doMaskApproval(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> formData = req.getFormData();

        // 열람요청
        String maskSq = osyr0131_Service.osyr0131_doMaskApproval(formData);
        resp.setParameter("MASK_SQ", maskSq);
    }

    @RequestMapping(value="/OSYR0131/doMaskApprovalCancel")
    public void osyr0131_doMaskApprovalCancel(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> formData = req.getFormData();

        // 열람요청 취소
        osyr0131_Service.osyr0131_doMaskApprovalCancel(formData);
    }

    @RequestMapping(value="/OSYR0131/doMaskView")
    public void osyr0131_doMaskView(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> formData = req.getFormData();

        // 개인정보열람확인
        Map<String, String> maskApprovalInfo = osyr0131_Service.osyr0131_doMaskView(formData);

        resp.setParameter("maskApprovalInfo", EverConverter.getJsonString(maskApprovalInfo));
    }
}

