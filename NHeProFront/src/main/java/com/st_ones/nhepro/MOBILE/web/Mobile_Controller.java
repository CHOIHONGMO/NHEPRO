package com.st_ones.nhepro.MOBILE.web;

import com.st_ones.common.file.service.FileAttachService;
import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.util.clazz.EverConverter;
import com.st_ones.common.util.clazz.EverDate;
import com.st_ones.common.util.clazz.EverEncryption;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.common.util.service.LargeTextService;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.nhepro.MOBILE.service.Mobile_Service;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

/**
 * The type Mobile_Controller.
 */
@Controller
@RequestMapping(value = "/nhepro/MOBILE")
public class Mobile_Controller extends BaseController {

    @Autowired
    private MessageService msg;

    @Autowired
    private Mobile_Service mobile_service;

    @Autowired
    private LargeTextService largeTextService;

    @Autowired
    private FileAttachService fileAttachService;

    /**
     * 화면설명 : 약관동의
     */
    @RequestMapping(value = "/MAGG_010/view")
    public String MAGG_010(EverHttpRequest req) {
        return "/nhepro/MOBILE/MAGG_010";
    }

    /**
     * 화면설명 : 약관동의 후 정보입력
     */
    @RequestMapping(value = "/MAGG_020/view")
    public String MAGG_020(EverHttpRequest req) {
        req.setAttribute("secureFlag", req.isSecure());
        req.setAttribute("NOW_YEAR", EverDate.getYear());
        req.setAttribute("sslFlag", PropertiesManager.getBoolean("ever.ssl.use.flag"));
        return "/nhepro/MOBILE/MAGG_020";
    }

    /**
     * 화면설명 : 담당자검색
     */
    @RequestMapping(value = "/MAGG_030/view")
    public String MAGG_030(EverHttpRequest req) throws Exception {
        Map<String, String> form = EverString.replaceInjection(req.getParamDataMap());

        req.setAttribute("form", form);
        return "/nhepro/MOBILE/MAGG_030";
    }

    /**
     * 화면설명 : 담당자검색 - 조회
     */
    @RequestMapping(value = "/MAGG_030_doSearch")
    public void MAGG_030_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        List<Map<String, Object>> deptUserList = mobile_service.MAGG_030_doSearch(req.getParamDataMap());

        resp.sendJSON(deptUserList);
    }

    /**
     * 화면설명 : 신청완료
     */
    @RequestMapping(value = "/MAGG_040/view")
    public String MAGG_040(EverHttpRequest req) {
        return "/nhepro/MOBILE/MAGG_040";
    }

    /**
     * 메인화면 - 회원가입(아이디 체크)
     */
    @RequestMapping("/userIdCheck")
    public void userIdCheck(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        UserInfo sesInfo = (UserInfo) req.getSession().getAttribute("ses");

        Map<String, String> reqMap = req.getParamDataMap();
        reqMap.put("LANG_CD", sesInfo.getLangCd());

        Map<String, String> userInfo = mobile_service.userIdCheck(reqMap);

        if (userInfo == null) {
            userInfo = new HashMap<>();
            userInfo.put("responseCode", "success");
        } else {
            userInfo.put("responseCode", "fail");
        }

        resp.sendJSON(userInfo);
    }

    /**
     * 메인화면 - 회원가입(선택 일자 체크)
     */
    @RequestMapping("/getDay")
    public void getDay(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> reqMap = req.getParamDataMap();
        /*if(reqMap.get("MONTH").length() == 1) {
            reqMap.put("MONTH", "0" + reqMap.get("MONTH"));
        }*/

        reqMap.put("DAY", EverDate.getLastDayofMonth(reqMap.get("YEAR") + reqMap.get("MONTH")).substring(6, 8));

        resp.sendJSON(reqMap);
    }

    /**
     * 메인화면 - 회원가입(인증시간번호 발송 후 시간 저장)
     */
    @RequestMapping("/certified_update")
    public void certified_update(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        long seed = System.currentTimeMillis();
        Random rand = new Random(seed);

        Map<String, String> reqMap = req.getParamDataMap();
        reqMap.put("CERTIFIED_NUMBER", String.valueOf(rand.nextInt()).substring(2, 7));

        // SMS 전송 후 인증 시간 기록
        mobile_service.certified_update(reqMap);

        resp.sendJSON(reqMap);
    }

    /**
     * 메인화면 - 회원가입(인증번호확인)
     */
    @RequestMapping("/certified_confirm")
    public void certified_confirm(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        // SMS 전송 후 인증 시간 기록
        Map<String, String> reqMap = req.getParamDataMap();

        int confirm_flag = mobile_service.certified_confirm(reqMap);
        reqMap.put("CONFIRM_FLAG", String.valueOf(confirm_flag));
        resp.sendJSON(reqMap);
    }

    /**
     * 메인화면 - 회원가입(이메일 체크)
     */
    @RequestMapping("/emailCheck")
    public void emailCheck(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> emailCheck = mobile_service.emailCheck(req.getParamDataMap());

        resp.sendJSON(emailCheck);
    }

    /**
     * 메인화면 - 회원가입(저장)
     */
    @RequestMapping("/doSave")
    public void doSave(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        UserInfo sesInfo = (UserInfo) req.getSession().getAttribute("ses");

        Map<String, String> reqMap = req.getParamDataMap();
        reqMap.put("GATE_CD", sesInfo.getGateCd());
        reqMap.put("LANG_CD", sesInfo.getLangCd());
        reqMap.put("GMT_CD", sesInfo.getSystemGmt());
        reqMap.put("IP_ADDR", EverString.getClientIP());
        reqMap.put("USER_DATE_FORMAT_CD", sesInfo.getDateFormat());
        reqMap.put("USER_NUMBER_FORMAT_CD", sesInfo.getNumberFormat());
        reqMap.put("CELL_NUM", reqMap.get("CELL_NUM1") + "-" + reqMap.get("CELL_NUM2") + "-" + reqMap.get("CELL_NUM3"));

        Map<String, String> respMap = new HashMap<>();
        
        /**
         * 2021.02.26 만 14세 이상 계산 삭제
        int old = Integer.parseInt(EverDate.getYear()) - Integer.parseInt(reqMap.get("BIRTH_DATE1"));
        if (!(Integer.parseInt(EverDate.getMonth()) >= Integer.parseInt(reqMap.get("BIRTH_DATE2"))
                && Integer.parseInt(EverDate.getDay()) >= Integer.parseInt(reqMap.get("BIRTH_DATE3")))) {
            old = old - 1;
        }
        if (old < 14) {
            respMap.put("responseMsg", "만 14세 이하는 가입하실 수 없습니다.");
            respMap.put("responseCode", "fail");
            resp.sendJSON(respMap);
            return;
        }
        reqMap.put("BIRTH_DATE", reqMap.get("BIRTH_DATE1") + reqMap.get("BIRTH_DATE2") + reqMap.get("BIRTH_DATE3"));
        */
        
        if (!"".equals(EverString.nullToEmptyString(reqMap.get("PASSWORD")))) {
            reqMap.put("PASSWORD", EverEncryption.getEncryptedUserPassword(reqMap.get("PASSWORD")));
        }
        reqMap.put("PROGRESS_CD", sesInfo.getProgressCd());
        
        try {
            mobile_service.doSave(reqMap);
        } catch (Exception e) {
            getLog().error(e.getMessage(), e);
            respMap.put("responseMsg", e.getMessage());
            respMap.put("responseCode", "fail");
            resp.sendJSON(respMap);
            return;
        }
        
        respMap.put("responseCode", "success");
        resp.sendJSON(respMap);
    }

    /**
     * 화면설명 : 아이디/비밀번호 찾기
     */
    @RequestMapping(value = "/MIDPW_010/view")
    public String MIDPW_010(EverHttpRequest req) {
        req.setAttribute("pageFlag", req.getParameter("pageFlag"));
        return "/nhepro/MOBILE/MIDPW_010";
    }

    /**
     * 메인화면 - 회원가입(인증번호확인)
     */
    @RequestMapping("/MIDPW_010_doSearch")
    public void MIDPW_010_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> reqMap = req.getParamDataMap();
        Map<String, String> userInfo = mobile_service.MIDPW_010_doSearch(reqMap);

        if (userInfo != null) {
            userInfo.put("USER_ID", userInfo.get("USER_ID").substring(0, userInfo.get("USER_ID").length() - 2) + "**");
            userInfo.put("responseCode", "success");
        } else {
            userInfo = new HashMap<>();
            userInfo.put("responseCode", "fail");
        }

        resp.sendJSON(userInfo);
    }

    /**
     * 화면설명 : 아이디 찾기
     */
    @RequestMapping(value = "/MIDPW_020/view")
    public String MIDPW_020(EverHttpRequest req) {
        req.setAttribute("USER_ID", req.getParameter("USER_ID"));

        return "/nhepro/MOBILE/MIDPW_020";
    }

    /**
     * 화면설명 : 비밀번호 찾기
     */
    @RequestMapping("/MIDPW_010_doSendPw")
    public void MIDPW_010_doSendPw(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> reqMap = req.getParamDataMap();
        Map<String, String> userInfo = mobile_service.MIDPW_010_doSearch(reqMap);

        if (userInfo != null) {
            userInfo.putAll(reqMap);

            String ppdd = EverString.getRandomPassword(8);
            String password = EverEncryption.getEncryptedUserPassword(ppdd);

            // PW 초기화 여부 업데이트
            userInfo.put("ppdd", ppdd);
            userInfo.put("PASSWORD", password);
            mobile_service.MIDPW_010_Update(userInfo);

            // PW 이력관리
            userInfo.put("REG_IP_ADDR", EverString.getClientIP());
            mobile_service.MIDPW_010_InsertPW(userInfo);

            userInfo.put("responseCode", "success");
        } else {
            userInfo = new HashMap<>();
            userInfo.put("responseCode", "fail");
        }

        resp.sendJSON(userInfo);
    }

    /**
     * 화면설명 : 비밀번호 찾기
     */
    @RequestMapping(value = "/MIDPW_030/view")
    public String MIDPW_030(EverHttpRequest req) {
        req.setAttribute("EMAIL", req.getParameter("EMAIL"));

        return "/nhepro/MOBILE/MIDPW_030";
    }

    /**
     * 화면설명 : 90일 경과 비밀번호 변경 화면
     */
    @RequestMapping(value = "/MIDPW_040/view")
    public String MIDPW_040(EverHttpRequest req) {
        req.setAttribute("USER_ID", req.getParameter("USER_ID"));
        return "/nhepro/MOBILE/MIDPW_040";
    }

    /**
     * 화면설명 : 90일 경과 비밀번호 변경
     */
    @RequestMapping(value = "/MIDPW_040_resetPassword")
    public void MIDPW_040_resetPassword(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        req.setAttribute("USER_ID", req.getParameter("USER_ID"));

        Map<String, String> reqMap = req.getParamDataMap();

        // PW 2회 중복체크 / 변경
        reqMap.put("PASSWORD", EverEncryption.getEncryptedUserPassword(reqMap.get("PASSWORD")));
        Boolean pwFlag = mobile_service.MIDPW_040_resetPassword(reqMap);

        Map<String, String> responseMap = new HashMap<>();
        if (pwFlag) {
            // PW 이력관리
            reqMap.put("REG_IP_ADDR", EverString.getClientIP());
            mobile_service.MIDPW_010_InsertPW(reqMap);
            responseMap.put("responseCode", "success");
        } else {
            // PW 2회 중복
            responseMap.put("responseCode", "fail");
        }

        resp.sendJSON(responseMap);

    }

    /**
     * mobileHoem - 근로계약서 조회
     */
    @RequestMapping(value = "/mobileHome_contract_list")
    public void mobileHome_contract_list(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        List<Map<String, Object>> list = mobile_service.mobileHome_contract_list(req.getParamDataMap());

        resp.sendJSON(list);
    }

    /**
     * mobileHoem - 서약서 조회
     */
    @RequestMapping(value = "/mobileHome_doPledge_list")
    public void mobileHome_doPledge_list(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        List<Map<String, Object>> list = mobile_service.mobileHome_doPledge_list(req.getParamDataMap());

        resp.sendJSON(list);
    }

    /**
     * mobileHoem - 공지사항 조회
     */
    @RequestMapping(value = "/mobileHome_doNotice_list")
    public void mobileHome_doNotice_list(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        List<Map<String, Object>> list = mobile_service.mobileHome_doNotice_list(req.getParamDataMap());

        resp.sendJSON(list);
    }

    /**
     * mobileHoem - 회원정보 조회
     */
    @RequestMapping(value = "/mobileHome_doMember")
    public void mobileHome_doMember(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> userInfo = mobile_service.userIdCheck(req.getParamDataMap());

        resp.sendJSON(userInfo);
    }

    /**
     * 화면설명 : 모바일 공지사항 상세화면
     */
    @RequestMapping(value = "/MECM_060/view")
    public String MECM_060(EverHttpRequest req) throws Exception {
        String noticeNo = EverString.nullToEmptyString(req.getParameter("NOTICE_NUM"));
        Map<String, String> formData = mobile_service.selectNotice(noticeNo);
        String splitString = largeTextService.selectLargeText(formData.get("NOTICE_TEXT_NUM")).replaceAll("&lt;", "<").replaceAll("&gt;", ">").replaceAll("&amp;", "<br>");

        req.setAttribute("CONTENTS", splitString);
        req.setAttribute("form", formData);

        List<Map<String, Object>> filesInfo = fileAttachService.getFilesInfo("NT", formData.get("ATT_FILE_NUM"));
        req.setAttribute("attachedFiles", filesInfo);

        return "/nhepro/MOBILE/MECM_060";
    }

    /**
     * 정도경영 / 보안서약서 동의 체크
     */
    @RequestMapping(value = "/mobileHome_checkLeglAgree2")
    public void mobileHome_checkLeglAgree2(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        UserInfo userinfo = UserInfoManager.getUserInfo();
        Map<String, String> oathMap = mobile_service.mobileHome_checkLeglAgree2(req.getParamDataMap());

        oathMap.put("USER_NM", userinfo.getUserNm());
        resp.setParameter("oathMap", EverConverter.getJsonString(oathMap));
    }

    /**
     * 정도경영 / 보안서약서 저장
     */
    @RequestMapping(value = "/mobile_doOath")
    public void mobile_doOath(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> reqMap = req.getParamDataMap();

        mobile_service.mobile_doOath(reqMap);
    }

    /**
     * 계약서 저장
     */
    @RequestMapping(value = "/mobile_doContract")
    public void mobile_doContract(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        UserInfo userinfo = UserInfoManager.getUserInfo();

        Map<String, String> reqMap = req.getParamDataMap();
        reqMap.put("USER_NM", userinfo.getUserNm());

        mobile_service.mobile_doContract(reqMap);
    }

    // 파일 존재여부 체크
    @RequestMapping(value = "/mobile_downloadFile")
    public void mobile_downloadFile(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> formData = req.getParamDataMap();

        Map<String, String> respMap = new HashMap<>();

        int fileUserCheck = mobile_service.fileUserCheck(formData);

        if (fileUserCheck == 0) {
            respMap.put("code", "0003");
            respMap.put("msg", "파일 다운로드 권한이 없습니다.");
        } else {
            Map<String, String> fileInfo = fileAttachService.getFileInfo(formData.get("UUID"), formData.get("UUID_SQ"));
            if (fileInfo == null || fileInfo.size() == 0) {
                respMap.put("code", "0001");
                respMap.put("msg", "파일정보가 존재하지 않습니다.");
            }

            String sourceFile = fileInfo.get("FILE_PATH") + "/" + fileInfo.get("FILE_NM") + "." + fileInfo.get("FILE_EXTENSION");

            File finalFile = new File(sourceFile);
            if (!finalFile.isFile()) {
                respMap.put("code", "0002");
                respMap.put("msg", "파일이 존재하지 않습니다");
            } else {
                respMap.put("code", "0000");
                respMap.put("msg", "파일이 존재합니다.");
            }
        }

        resp.sendJSON(respMap);
    }
    
    
}