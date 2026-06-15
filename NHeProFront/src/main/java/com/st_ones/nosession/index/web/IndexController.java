package com.st_ones.nosession.index.web;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.security.KeyFactory;
import java.security.KeyPair;
import java.security.KeyPairGenerator;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.security.spec.RSAPublicKeySpec;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang3.RandomStringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.st_ones.common.file.service.FileAttachService;
import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.common.login.service.LoginService;
import com.st_ones.common.page.PageNaviBean;
import com.st_ones.common.sms.service.EverSmsService;
import com.st_ones.common.util.clazz.EverDate;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.common.util.service.LargeTextService;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.nosession.index.service.IndexService;

@Controller
@RequestMapping(value = "/")
public class IndexController extends BaseController {

    private static final String START_PAGE   = "/indexFront";
    private static final String START_PAGE_B = "/indexBS";

    @Autowired
    IndexService indexService;
    @Autowired
    private LoginService loginService;
    @Autowired
    FileAttachService fileAttachService;
    @Autowired
    LargeTextService largeTextService;
    @Autowired
    private EverSmsService eversmsservice;
    
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

        // 입찰공고 조회
        List<Map<String, String>> cbdi0010_doSearch = new ArrayList<Map<String, String>>();
        cbdi0010_doSearch = indexService.cbdi0010_doSearch_Main(cbdi0010_doSearch);
        req.setAttribute("cbdiList", cbdi0010_doSearch);

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
            return START_PAGE;
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
            return START_PAGE_B;
        } else {
            return START_PAGE_B;
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
    
    /**
     * 개인정보의 수집.활용 동의서
     * @param req
     * @return
     */
    @RequestMapping("userAgreeCheck")
    public String userAgreeCheck(EverHttpRequest req) throws Exception {
        String userid = EverString.nullToEmptyString(req.getParameter("USER_ID"));
        
        // 개인정보처리방침 조회
    	Map<String, String> param = new HashMap<String, String>();
    	param.put("USER_ID", userid);
    	param.put("viewType", "PC");	// 개인정보처리방침 및 서비스이용약관(PC)
    	
    	param.put("GATE_CD", PropertiesManager.getString("eversrm.gateCd.default"));
    	Map<String, String> userType = loginService.findUserType(param);
		param.put("USER_TYPE", userType.get("USER_TYPE"));
		
		Map<String, Object> formData = indexService.getSystemAgreeInfo(param);
        
        req.setAttribute("formData", formData);
        req.setAttribute("userId", userid);
        
        return "/common/userAgreeCheck";
    }
    
    /**
     * 2021.02.16 추가
     * 시스템 이용수수료 동의서(선불 : 서비스이용약관/개인정보처리방침, 후불 : 계약일반조건/개인정보처리방침)
     * @param req
     * @return
     */
    @RequestMapping("systemAgreeCheck")
    public String systemAgreeCheck(EverHttpRequest req) throws Exception {
    	
        String userid = EverString.nullToEmptyString(req.getParameter("USER_ID"));
        
        // 시스템이용동의서 조회
    	Map<String, String> param = new HashMap<String, String>();
    	param.put("USER_ID", userid);
    	param.put("viewType", "SC");	// 사업자 ASP 이용계약서(SC)
    	
    	param.put("GATE_CD", PropertiesManager.getString("eversrm.gateCd.default"));
    	Map<String, String> userType = loginService.findUserType(param);
		param.put("USER_TYPE", userType.get("USER_TYPE"));
		param.put("COMPANY_CD", userType.get("COMPANY_CD"));
		/**
		 * 2022.05.16 추가 ajk 
		 * 부서별 ASP이용 대상 확인 
		*/        	
        Map<String, String> userDeptAsp = loginService.findCompanyAsp(param);
        if(userDeptAsp != null && userDeptAsp.size() > 0) {
        	param.put("ASP_NOTICE_NUM", userDeptAsp.get("ASP_NOTICE_NUM"));
        }				
		
        Map<String, Object> formData = indexService.getSystemAgreeInfo(param);
		
		req.setAttribute("certOidfilter", PropertiesManager.getString("magicline.certverify.ipoid"));
        
        String localServerFlag = "N";
        if(PropertiesManager.getBoolean("eversrm.system.localserver") || PropertiesManager.getBoolean("eversrm.system.developmentFlag")) {
        	localServerFlag = "Y";
        }
        
        req.setAttribute("formData", formData);
        req.setAttribute("userId", userid);
        req.setAttribute("localServerFlag", localServerFlag);
        
        return "/common/systemAgreeCheck";
    }
    
    /**
     * 2021.12.13 추가 : 관리자 모드 난수 발생
     * @param req
     * @return
     */
    @RequestMapping("/common/userManagerCheck/view")
    public String userManagerCheck(EverHttpRequest req) throws Exception {
    	
    	Map<String, String> param = new HashMap<String, String>();
    	param.put("USER_ID",  EverString.nullToEmptyString(req.getParameter("USER_ID")));
		param.put("USER_NM",  EverString.nullToEmptyString(req.getParameter("USER_NM")));
		param.put("CELL_NUM", EverString.nullToEmptyString(req.getParameter("CELL_NUM")));
    	
		req.setAttribute("formData", param);
        return "/common/userManagerCheck";
    }
    
    /**
     * 2021.12.13 추가 : 관리자 모드 난수 발생
     * @param req
     * @return
     */
    @RequestMapping("/managerKeyClear")
    public void managerKeyClear(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	
    	Map<String, String> param = req.getFormData();
    	param.put("GATE_CD", PropertiesManager.getString("eversrm.gateCd.default"));
    	
    	// 관리자모드 난수 발생 6자리
		String verCode = RandomStringUtils.randomNumeric(6);
		// 로컬 및 개발서버인 경우 : 123456
		if (PropertiesManager.getBoolean("eversrm.system.localserver") || PropertiesManager.getBoolean("eversrm.system.developmentFlag")) {
			verCode = "123456";
		}
		param.put("VERCODE", EverString.nullToEmptyString(verCode));
		loginService.doSaveVerCode(param);
		
		// 관리자모드 난수발생 문자발송
		Map<String, String> map = new HashMap<String, String>();
		map.put("DIRECT_TARGET", EverString.nullToEmptyString(param.get("CELL_NUM")));
		map.put("DIRECT_USER_NM", EverString.nullToEmptyString(param.get("USER_NM")));
		map.put("CONTENTS", "[전자구매시스템]인증번호 [" + verCode + "]를 입력해주세요.");
		map.put("REF_NUM", "");
		map.put("REF_MODULE_CD", "BADU"); // 참조모듈
		map.put("BUYER_CD", "1000");
		eversmsservice.sendSmsNhe(map);
    }
    
    /**
     * 공지사항 팝업
     * @param req
     * @return
     * @throws Exception
     */
    @RequestMapping("/evermp/MY01/screenNotice/view")
    public String screenNotice(EverHttpRequest req) throws Exception {
        Map<String, String> param = new HashMap<String, String>();
        
        String noticeNo = EverString.nullToEmptyString(req.getParameter("NOTICE_NUM"));
        param.put("NOTICE_NUM", noticeNo);
        
        Map<String, Object> formData = indexService.getNoticePopupInfo(param);
        List<Map<String, Object>> filesInfo = fileAttachService.getFilesInfo("NT", (String) formData.get("ATT_FILE_NUM"));
        
        req.setAttribute("formData", formData);
        req.setAttribute("attachedFiles", filesInfo);
        
        return "/evermp/MY01/screenNotice";
    }

    @RequestMapping("/nhepro/mainNoticeList")
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

    @RequestMapping("/nhepro/mainNoticeList2")
    public void mainNoticeList2(EverHttpRequest req, EverHttpResponse resp, @ModelAttribute("pBean") PageNaviBean pBean) throws Exception {
        Map<String, String> param = req.getParamDataMap();

        // ************** 페이징 구현 ***********************//
        int totalCount = indexService.mainNoticeTotalCount2(param);
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
            resp.sendJSON(indexService.mainNoticeList2(param));
        }
    }

    @RequestMapping("/nhepro/mainNoticeDetail")
    public void mainNoticeDetail(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> detail = indexService.mainNoticeDetail(req.getParamDataMap());

        detail.put("TEXT_CONTENTS", largeTextService.selectLargeText(detail.get("NOTICE_TEXT_NUM")).replaceAll("&lt;", "<").replaceAll("&gt;", ">").replaceAll("&amp;", "<br>"));

        resp.sendJSON(detail);
    }

    @RequestMapping("/nhepro/mainNoticeDetailFile")
    public void mainNoticeDetailFile(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        List<Map<String, Object>> detailFile = indexService.mainNoticeDetail_File(req.getParamDataMap());
        resp.sendJSON(detailFile);
    }

    @RequestMapping("/mobile")
    public void mobile(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.getWriter().write("<html><script>top.location.href=\"/mobile/index.jsp\";</script></html>");
    }
    
    /*2022.10.11 전자근로계약시스템 농협파트너스 _모바일화면 추가*/
    @RequestMapping("/mobileNHPT")
    public void mobile_nhpt(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.getWriter().write("<html><script>top.location.href=\"/mobileNHPT/index.jsp\";</script></html>");
    }
    
    /**
     * 소프트웨어공제조합 신청 시 주의사항 안내
     * @param req
     * @return
     */
    @RequestMapping("guarGuide")
    public String guarGuide(EverHttpRequest req) throws Exception {
        
        return "/common/guarGuide";
    }
    
    /**
     * 서울보증 신청 시 주의사항 안내
     * @param req
     * @return
     */
    @RequestMapping("guarSgGuide")
    public String guarSgGuide(EverHttpRequest req) throws Exception {
        
        return "/common/guarSgGuide";
    }
    
    /**
     * 서비스 이용약관
     * @param req
     * @return
     */
    @RequestMapping("/nhepro/serviceGuide")
    public void serviceGuide(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	Map<String, String> detail = indexService.mainNoticeDetail(req.getParamDataMap());

        detail.put("TEXT_CONTENTS", largeTextService.selectLargeText(detail.get("NOTICE_TEXT_NUM")).replaceAll("&lt;", "<").replaceAll("&gt;", ">").replaceAll("&amp;", "<br>"));
        resp.sendJSON(detail);
    }
}
