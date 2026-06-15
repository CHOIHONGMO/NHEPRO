package com.st_ones.nosession.index.web;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.st_ones.common.combo.service.CommonComboService;
import com.st_ones.common.enums.system.Code;
import com.st_ones.common.file.service.FileAttachService;
import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.common.page.PageNaviBean;
import com.st_ones.common.util.clazz.EverDate;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.nosession.index.service.IndexService;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpSession;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.security.*;
import java.security.spec.RSAPublicKeySpec;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping(value = "/")
public class IndexController extends BaseController {

    private static final String M_START_PAGE = "/indexOperator";
    private static final String START_PAGE = "/indexOperator";
    private static final String START_PAGE_F = "/indexFront";

    @Autowired
    IndexService indexService;
    
    @Autowired
    FileAttachService fileAttachService;

    @RequestMapping("/gateway")
    public String gateway(EverHttpRequest req, EverHttpResponse resp) {
        req.setAttribute("isLocalServer", PropertiesManager.getBoolean("eversrm.system.localserver"));
        return "/gateway";
    }

    @RequestMapping("/m/welcome")
    public String getMobileLoginLayer(EverHttpRequest req, EverHttpResponse resp) throws UnsupportedEncodingException {
        req.setAttribute("returnUrl", URLDecoder.decode(req.getParameter("returnUrl"), "UTF-8"));
        initRsa(req); // RSA 키 생성
        return "/mLoginLayer";
    }

    @RequestMapping("/loginLayer")
    public String getLoginLayer(EverHttpRequest req, EverHttpResponse resp) {

        String systemName = "";
        req.setAttribute("userId", req.getParameter("id"));
        req.setAttribute("systemName", systemName);

        initRsa(req);// RSA 키 생성
        return "/loginLayer";
    }

    @RequestMapping("/welcome")
    public String welcomePage(EverHttpRequest req, EverHttpResponse response) throws Exception {

        req.setAttribute("getYear", EverDate.getYear());
        req.setAttribute("getMonth", EverDate.getMonth());
        req.setAttribute("getDay", EverDate.getDay());
        req.setAttribute("getFormattedTime", EverDate.getFormattedTime());

        UserInfo baseInfo = (UserInfo)req.getSession().getAttribute("ses");
        if (baseInfo != null && !baseInfo.getUserId().equals("VIRTUAL")) {
            UserInfoManager.createUserInfo(baseInfo);
            Map<String, String> initDataMap = new HashMap<String, String>();
            initDataMap.put("langCd", UserInfoManager.getUserInfo().getLangCd());
            initDataMap.put("sessionType", (UserInfoManager.getUserInfo().getUserId().equals("VIRTUAL") ? "virtual" : "normal"));
            initDataMap.put("userId", UserInfoManager.getUserInfo().getUserId());
            initDataMap.put("userType", UserInfoManager.getUserInfo().getUserType());
            req.setAttribute("initData", new ObjectMapper().writeValueAsString(initDataMap));

            return "forward:/home.so";
            //return "forward:/";
        }

        // 공지사항 팝업 목록
        List<Map<String, String>> noticeList = new ArrayList<Map<String, String>>();
        noticeList = indexService.getNoticeListPopup(noticeList);
        req.setAttribute("noticeListPopup", noticeList);

        List<Map<String, String>> MainnoticeList = new ArrayList<Map<String, String>>();
        MainnoticeList = indexService.getNoticeListMain(MainnoticeList);
        req.setAttribute("noticeListMain", MainnoticeList);


        req.setAttribute("eversrmSystemDomainPort", PropertiesManager.getString("eversrm.system.domainPort"));
        req.setAttribute("eversrmSystemDomainUrl", PropertiesManager.getString("eversrm.system.domainUrl"));
        req.setAttribute("eversrmSystemDomainPortHttp", PropertiesManager.getString("eversrm.system.domainPort.http"));
        req.setAttribute("eversrmDevelopmentFlag", PropertiesManager.getBoolean("eversrm.system.developmentFlag"));

        if(StringUtils.isNotEmpty(req.getParameter("returnUrl"))) {
            req.setAttribute("returnUrl", URLDecoder.decode(req.getParameter("returnUrl"), "UTF-8"));
        }

        // RSA 키 생성
        initRsa(req);

        String userAgent = req.getHeader("User-Agent");
        if(StringUtils.containsIgnoreCase(userAgent, "android") || StringUtils.containsIgnoreCase(userAgent, "iphone")) {
            return M_START_PAGE;
        } else {
            return START_PAGE;
        }
    }

    @RequestMapping("/welcomeBS")
    public String welcomePageForPromotion(EverHttpRequest req, EverHttpResponse response) throws Exception {

        req.setAttribute("getYear", EverDate.getYear());
        req.setAttribute("getMonth", EverDate.getMonth());
        req.setAttribute("getDay", EverDate.getDay());
        req.setAttribute("getFormattedTime", EverDate.getFormattedTime());

        UserInfo baseInfo = (UserInfo)req.getSession().getAttribute("ses");
        if (baseInfo != null && !baseInfo.getUserId().equals("VIRTUAL")) {
            UserInfoManager.createUserInfo(baseInfo);
            Map<String, String> initDataMap = new HashMap<String, String>();
            initDataMap.put("langCd", UserInfoManager.getUserInfo().getLangCd());
            initDataMap.put("sessionType", (UserInfoManager.getUserInfo().getUserId().equals("VIRTUAL") ? "virtual" : "normal"));
            initDataMap.put("userId", UserInfoManager.getUserInfo().getUserId());
            initDataMap.put("userType", UserInfoManager.getUserInfo().getUserType());
            req.setAttribute("initData", new ObjectMapper().writeValueAsString(initDataMap));

            return "forward:/home.so";
        }

        req.setAttribute("eversrmSystemDomainPort", PropertiesManager.getString("eversrm.system.domainPort"));
        req.setAttribute("eversrmSystemDomainUrl", PropertiesManager.getString("eversrm.system.domainUrl"));
        req.setAttribute("eversrmSystemDomainPortHttp", PropertiesManager.getString("eversrm.system.domainPort.http"));
        req.setAttribute("eversrmDevelopmentFlag", PropertiesManager.getBoolean("eversrm.system.developmentFlag"));

        if(StringUtils.isNotEmpty(req.getParameter("returnUrl"))) {
            req.setAttribute("returnUrl", URLDecoder.decode(req.getParameter("returnUrl"), "UTF-8"));
        }

        // RSA 키 생성
        initRsa(req);

        String userAgent = req.getHeader("User-Agent");
        if(StringUtils.containsIgnoreCase(userAgent, "android") || StringUtils.containsIgnoreCase(userAgent, "iphone")) {
            return M_START_PAGE;
        } else {
            return START_PAGE;
        }
    }

    /**
     * rsa 공개키, 개인키 생성
     *
     * @param request
     */
    public void initRsa(EverHttpRequest request) {
        HttpSession session = request.getSession();

        KeyPairGenerator generator;
        try {
            generator = KeyPairGenerator.getInstance("RSA");
            generator.initialize(1024);

            KeyPair keyPair = generator.genKeyPair();
            KeyFactory keyFactory = KeyFactory.getInstance("RSA");
            PublicKey publicKey = keyPair.getPublic();
            PrivateKey privateKey = keyPair.getPrivate();

            session.setAttribute("_RSA_WEB_Key_", privateKey); // session에 RSA 개인키를 세션에 저장

            RSAPublicKeySpec publicSpec = keyFactory.getKeySpec(publicKey, RSAPublicKeySpec.class);
            String publicKeyModulus = publicSpec.getModulus().toString(16);
            String publicKeyExponent = publicSpec.getPublicExponent().toString(16);

            request.setAttribute("RSAModulus", publicKeyModulus); // rsa modulus 를 request 에 추가
            request.setAttribute("RSAExponent", publicKeyExponent); // rsa exponent 를 request 에 추가
        } catch (Exception e) {
            getLog().error(e.getMessage(), e);
        }
    }

    @RequestMapping("userAgreeCheck")
    public String userAgreeCheck(EverHttpRequest req) {
        String userid = EverString.nullToEmptyString(req.getParameter("USER_ID"));
        req.setAttribute("userId", userid);

        return "/common/userAgreeCheck";
    }
    
    /**
     * 공지사항 팝업
     * @param req
     * @return
     * @throws Exception
     */
    @RequestMapping("/eversrm/board/notice/screenNotice/view")
    public String screenNotice(EverHttpRequest req) throws Exception {
        Map<String, String> param = new HashMap<String, String>();
        
        String noticeNo = EverString.nullToEmptyString(req.getParameter("NOTICE_NUM"));
        param.put("NOTICE_NUM", noticeNo);
        
        Map<String, Object> formData = indexService.getNoticePopupInfo(param);
        List<Map<String, Object>> filesInfo = fileAttachService.getFilesInfo("NT", (String) formData.get("ATT_FILE_NUM"));
        
        req.setAttribute("formData", formData);
        req.setAttribute("attachedFiles", filesInfo);
        
        return "/eversrm/board/notice/screenNotice";
    }

    @RequestMapping("/ymro/mainNoticeList")
    public void mainNoticeList(EverHttpRequest req, EverHttpResponse resp, @ModelAttribute("pBean") PageNaviBean pBean) throws Exception {
        Map<String, String> param = req.getParamDataMap();

        // ************** 페이징 구현 ***********************//
        int totalCount = indexService.mainNoticeTotalCount(param);
        // paging 정보 셋팅
        pBean.setPagingValue(Integer.parseInt(param.get("pageNo")), 10);
        // start, end 주입
        param.put("startNo", String.valueOf(pBean.getStartNo()));
        param.put("endNo", String.valueOf(pBean.getEndNo()));
        param.put("totalCount", String.valueOf(totalCount));
        // ************** 페이징 구현 ***********************//

        if("1".equals(param.get("countFlag"))) {
            resp.sendJSON(param);
        } else {
            resp.sendJSON(indexService.mainNoticeList(param));
        }
    }

    @RequestMapping("/ymro/mainNoticeDetail")
    public void mainNoticeDetail(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> reqMap = req.getParamDataMap();
        resp.sendJSON(indexService.mainNoticeDetail(req.getParamDataMap()));
    }

}
