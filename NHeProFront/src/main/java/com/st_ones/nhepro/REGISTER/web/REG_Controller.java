package com.st_ones.nhepro.REGISTER.web;

/**
 * Copyright (c) 2013 ST-Ones (http://www.st-ones.com/) All rights reserved.
 * @LastModified 18. 10. 30 오후 4:58
 */

import com.st_ones.common.combo.service.CommonComboService;
import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.util.clazz.EverConverter;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.nhepro.REGISTER.service.REG_Service;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.HashMap;
import java.util.List;
import java.util.Map;


/**
 * The type REG _ controller.
 */
@Controller
@RequestMapping(value = "/nhepro/REGISTER")
public class REG_Controller {
    @Autowired
    private MessageService msg;
    @Autowired
    private REG_Service reg_service;
    @Autowired
    private CommonComboService commonComboService;

    /**
     * 메인화면 - 협력사 회원가입
     */
    @RequestMapping("/register_supplier/view")
    public String register_supplier(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> param = req.getParamDataMap();

        // 사업자구분
        req.setAttribute("regType", commonComboService.getCodeCombo("M014"));
        // 기업규모
        req.setAttribute("businessSize", commonComboService.getCodeCombo("MP039"));
        // 농협구분
        req.setAttribute("relatType", commonComboService.getCodeCombo("NH0005"));
        // 법인구분
        req.setAttribute("corpType", commonComboService.getCodeCombo("NH0002"));
        // 특허/면허 구분
        req.setAttribute("slType", commonComboService.getCodeCombo("NH0006"));
        // 기준년도
        req.setAttribute("fiYear", commonComboService.getCodeCombo("M174"));
        // 자료근거
        req.setAttribute("evidenceType", commonComboService.getCodeCombo("MP048"));
        // 계산서발행구분
        req.setAttribute("eBillAspType", commonComboService.getCodeCombo("MP075"));
        // 계산서발행구분
        req.setAttribute("taxSendType", commonComboService.getCodeCombo("MP064"));
        // 은행 및 지점명
        req.setAttribute("payBank", commonComboService.getCodeCombo("M017"));
        // 지급조건
        req.setAttribute("payCondition", commonComboService.getCodeCombo("MP045"));
        // 지급형태
        req.setAttribute("payType", commonComboService.getCodeCombo("MP046"));
        // 계산서발행조건
        req.setAttribute("payPublicType", commonComboService.getCodeCombo("MP047"));
        // 신용등급
        req.setAttribute("creditType", commonComboService.getCodeCombo("MP003"));
        // 개발서버 여부
        req.setAttribute("localServer", PropertiesManager.getBoolean("eversrm.system.localserver"));

        if (param.get("CONFIRM_FLAG") != null && param.get("CONFIRM_FLAG").equals("R")) {
            // 기본정보 / 관리정보
            Map<String, String> vnglInfo = reg_service.doSearchVNGL(param);
            param.put("VENDOR_CD", vnglInfo.get("VENDOR_CD"));
            // 특허 및 취급면허
            List<Map<String, Object>> vnslList = reg_service.doSearchVNSL(param);
            // 재무정보
            Map<String, String> vnfiInfo = reg_service.doSearchVNFI(param);
            // 결제정보
            List<Map<String, Object>> vnapList = reg_service.doSearchVNAP(param);
            // 거래희망 고객사 VNCM
            List<Map<String, Object>> vncmList = reg_service.doSearchVNCM(param);
            // 첨부파일 ATTS
            List<Map<String, Object>> attsList = reg_service.doSearchATTS(param);
            // 사용자정보 USER
            Map<String, String> userInfo = reg_service.doSearchCVUR(param);

            vnglInfo.putAll(param);
            vnglInfo.putAll(vnfiInfo);

            req.setAttribute("form", vnglInfo);
            req.setAttribute("user", userInfo);
            req.setAttribute("vnslList", vnslList);
            req.setAttribute("vnapList", vnapList);
            req.setAttribute("vncmList", vncmList);
            req.setAttribute("attachList", attsList);
        }
        else {
            // 첨부파일
            req.setAttribute("attachList", reg_service.doSearchATTD(param));
            req.setAttribute("form", param);
        }

        UserInfo baseInfo = (UserInfo)req.getSession().getAttribute("ses");
        baseInfo.setUserType("S");

        req.setAttribute("USER_TYPE", "S");
        return "/nhepro/REGISTER/sigin_in_02_case_01";
    }

    /**
     * 메인화면 - 고객사 회원가입
     */
    @RequestMapping("/register_customer/view")
    public String register_customer(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> param = req.getParamDataMap();

        // 사업자구분
        req.setAttribute("regType", commonComboService.getCodeCombo("M014"));
        // 기업규모
        req.setAttribute("businessSize", commonComboService.getCodeCombo("MP039"));
        // 농협구분
        req.setAttribute("relatType", commonComboService.getCodeCombo("NH0005"));
        // 법인구분
        req.setAttribute("corpType", commonComboService.getCodeCombo("NH0002"));
        // 특허/면허 구분
        req.setAttribute("slType", commonComboService.getCodeCombo("NH0006"));
        // 기준년도
        req.setAttribute("fiYear", commonComboService.getCodeCombo("M174"));
        // 자료근거
        req.setAttribute("evidenceType", commonComboService.getCodeCombo("MP048"));
        // 계산서발행구분
        req.setAttribute("eBillAspType", commonComboService.getCodeCombo("MP075"));
        // 계산서발행구분
        req.setAttribute("taxSendType", commonComboService.getCodeCombo("MP064"));
        // 은행 및 지점명
        req.setAttribute("payBank", commonComboService.getCodeCombo("M017"));
        // 지급조건
        req.setAttribute("payCondition", commonComboService.getCodeCombo("MP045"));
        // 지급형태
        req.setAttribute("payType", commonComboService.getCodeCombo("MP046"));
        // 계산서발행조건
        req.setAttribute("payPublicType", commonComboService.getCodeCombo("MP047"));
        // 신용등급
        req.setAttribute("creditType", commonComboService.getCodeCombo("MP003"));
        // 첨부파일
        req.setAttribute("attachList", reg_service.doSearchATTD(param));
        // 개발서버 여부
        req.setAttribute("localServer", PropertiesManager.getBoolean("eversrm.system.localserver"));

        req.setAttribute("form", param);

        UserInfo baseInfo = (UserInfo)req.getSession().getAttribute("ses");
        baseInfo.setUserType("B");

        req.setAttribute("USER_TYPE", "B");

        return "/nhepro/REGISTER/sigin_in_02_case_01";
    }

    /**
     * 메인화면 - 사용자 가입
     */
    @RequestMapping("/register_user/view")
    public String register_user(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> userCompanyInfo = reg_service.userCompanyInfo(req.getParamDataMap());
        userCompanyInfo.putAll(req.getParamDataMap());

        req.setAttribute("form", userCompanyInfo);
        return "/nhepro/REGISTER/sigin_in_02_case_03";
    }

    /**
     * 메인화면 - 회원가입
     */
    @RequestMapping("/userIdCheck")
    public void userIdCheck(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> reqMap = req.getParamDataMap();
        int userCnt = reg_service.userIdCheck(req.getParamDataMap());

        if(userCnt > 0) {
            reqMap.put("responseCode", "fail");
        } else {
            reqMap.put("responseCode", "success");
        }

        resp.sendJSON(reqMap);
    }

    /**
     * 메인화면 - 거래희망 고객사의 첨부파일 확인
     */
    @RequestMapping("/doBuyerAttr")
    public void doSearchATTD_Buyer(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> param = req.getParamDataMap();

        resp.sendJSON(reg_service.doSearchATTD(param));
    }

    /**
     * 메인화면 - 회원가입
     */
    @RequestMapping("/doSave")
    public void doSave(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> sendMsg = new HashMap<String, String>();
        Map<String, Object> paramObj = EverConverter.readJsonObject(req.getParameter("json"), Map.class);;

        // 저장
        reg_service.doSave(paramObj);

        // sendMsg.put("responseCode", "success");
        resp.sendJSON(sendMsg);
    }

}

