package com.st_ones.nhepro.OETR.web;

import java.net.URLDecoder;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.util.clazz.EverCert;
import com.st_ones.common.util.clazz.EverDate;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.nhepro.OETR.service.OETR0020_Service;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : OETR0020_Controller.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

@Controller
@RequestMapping(value = "/nhepro/OETR")
public class OETR0020_Controller extends BaseController {
	
	@Autowired MessageService msg;
    @Autowired private OETR0020_Service oetr0020_service;

    /**
     * 화면명 : 공지사항
     * 처리내용 : 시스템 사용자들을 위한 공지사항을 조회/삭제하는 화면.
     * 경로 : 운영사 > My Page > My Page > 공지사항
     */
    @RequestMapping(value="/OETR0020/view")
    public String OETR0020(EverHttpRequest req) {
        req.setAttribute("addFromDate", EverDate.addDateMonth(EverDate.getDate(), -1));
        req.setAttribute("addToDate", EverDate.addDateMonth(EverDate.getDate(), +2));

        return "/nhepro/OETR/OETR0020";
    }

    // 조회
    @RequestMapping(value = "/oetr0020_doSearch")
    public void oetr0020_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	
    	Map<String, String> param = req.getFormData();
    	param.put("NOTICE_TYPE", "PCN");
    	
        resp.setGridObject("grid", oetr0020_service.oetr0020_doSearch(param));
    }

    /**
     * 화면명 : 공지사항 작성
     * 처리내용 : 시스템 사용자들을 위한 공지사항을 작성하는 화면.
     * 경로 : 공급사 > My Page > My Page > 공지사항 > 신규등록 (팝업), 상세 (팝업)
     */
    @RequestMapping(value="/OETR0021/view")
    public String OETR0021(EverHttpRequest req) throws Exception {

        Map<String, String> param = new HashMap<>();
        Map<String, Object> formData = new HashMap<>();
        UserInfo userInfo = UserInfoManager.getUserInfo();

        boolean havePermission;
        String noticeNum = EverString.nullToEmptyString(req.getParameter("NOTICE_NUM"));
        String detailView = EverString.nullToEmptyString(req.getParameter("detailView"));

        if(!noticeNum.equals("")) {
            param.put("NOTICE_NUM", noticeNum);
            param.put("detailView", detailView);
            formData = oetr0020_service.oetr0021_doSearchNoticeInfo(param);
            
            havePermission = userInfo.getUserId().equals(String.valueOf(formData.get("REG_USER_ID")));
        } else {
            formData.put("REG_DATE", EverDate.getDate());
            formData.put("REG_USER_NM", userInfo.getUserNm());
            
            havePermission = true;
        }

        req.setAttribute("formData", formData);
        req.setAttribute("havePermission", havePermission);

        return "/nhepro/OETR/OETR0021";
    }

    // 저장
    @RequestMapping(value = "/oetr0021_doSave")
    public void oetr0021_doSave(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	
    	Map<String, String> param = req.getFormData();
    	param.put("NOTICE_TYPE", "PCN");
    	
        Map<String, String> rtnMap = oetr0020_service.oetr0021_doSave(param);
        resp.setParameter("NOTICE_NUM", rtnMap.get("NOTICE_NUM"));
        resp.setResponseMessage(rtnMap.get("rtnMsg"));
    }

    // 삭제
    @RequestMapping(value = "/oetr0021_doDelete")
    public void oetr0021_doDelete(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        String rtnMsg = oetr0020_service.oetr0021_doDelete(req.getFormData());

        resp.setResponseMessage(rtnMsg);
    }
    
    /**
     * 2021.02.19 추가
     * My Page > My Page > ASP이용계약 (OETR0050)
     * @param req
     * @return
     */
    @RequestMapping(value="/OETR0050/view")
    public String OETR0050(EverHttpRequest req) {
        req.setAttribute("addFromDate", EverDate.addDateMonth(EverDate.getDate(), -1));
        req.setAttribute("addToDate", EverDate.addDateMonth(EverDate.getDate(), +2));
        
        return "/nhepro/OETR/OETR0050";
    }

    // 조회
    @RequestMapping(value = "/oetr0050_doSearch")
    public void oetr0050_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	
    	Map<String, String> param = req.getFormData();
    	param.put("NOTICE_TYPE", "CMS");
    	
        resp.setGridObject("grid", oetr0020_service.oetr0020_doSearch(param));
    }

    /**
     * ASP이용계약서 작성
     * @param req
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/OETR0051/view")
    public String OETR0051(EverHttpRequest req) throws Exception {

        Map<String, String> param = new HashMap<>();
        Map<String, Object> formData = new HashMap<>();
        UserInfo userInfo = UserInfoManager.getUserInfo();

        boolean havePermission;
        String noticeNum  = EverString.nullToEmptyString(req.getParameter("NOTICE_NUM"));
        String detailView = EverString.nullToEmptyString(req.getParameter("detailView"));
        
        String useCard = "";
        String localServerFlag = "N";
        if(PropertiesManager.getBoolean("eversrm.system.localserver") || PropertiesManager.getBoolean("eversrm.system.developmentFlag")) {
        	localServerFlag = "Y";
        	useCard = "1";
        }
        
        if( !noticeNum.equals("") ) {
            param.put("NOTICE_NUM", noticeNum);
            param.put("detailView", detailView);
            formData = oetr0020_service.oetr0051_doSearchNoticeInfo(param);
            
            // 서명값 검증
            String sSignData = String.valueOf(formData.get("SIGN_VALUE"));
            String vidRandom = String.valueOf(formData.get("VID_RANDOM"));
            String idn = String.valueOf(formData.get("IRS_NUM"));
            
            // useCard : "1" (Test용 법인용 공인인증서, 사업자 등록번호 : 2128159710)
            //"2" (Test용 법인용 블럭체인 사설인증서, 사업자 등록번호 : 1122334455)
            //"3" {Test용 개인용 블럭체인 사설인증서, 사업자 등록번호 : ""}
            if( !PropertiesManager.getBoolean("eversrm.system.localserver") && StringUtils.isNotEmpty(sSignData) ) {
            	boolean checkFlag = EverCert.doCheckSignedData(sSignData, vidRandom, idn, useCard);
                if(!checkFlag) {
                	throw new Exception(msg.getMessageByScreenId("OETR0051", "010"));
                }
            }
            
            havePermission = userInfo.getUserId().equals(String.valueOf(formData.get("REG_USER_ID")));
        }
        else {
            formData.put("REG_DATE", EverDate.getDate());
            formData.put("REG_USER_NM", userInfo.getUserNm());
            
            havePermission = true;
        }
        
        // ipoid : 법인용 공인인증기관 공인인증서, iboid : 법인용 블럭체인 사설인증서, pboid : 개인용 블럭체인 사설인증서
        req.setAttribute("certOidfilter", PropertiesManager.getString("magicline.certverify.ipoid"));
        req.setAttribute("formData", formData);
        req.setAttribute("havePermission", havePermission);
        req.setAttribute("localServerFlag", localServerFlag);
        
        return "/nhepro/OETR/OETR0051";
    }

    // 저장
    @RequestMapping(value = "/oetr0051_doSave")
    public void oetr0051_doSave(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	
    	/** ====================== 공인인증서 처리 ===========================================*/
		String sSignData = EverString.nullToEmptyString(req.getParameter("signedData"));
        	   sSignData = URLDecoder.decode(sSignData, "utf-8");
        String vidRandom = EverString.nullToEmptyString(req.getParameter("vidRandom"));
        	   vidRandom = URLDecoder.decode(vidRandom, "utf-8");
        String idn = EverString.nullToEmptyString(req.getParameter("idn"));
        
        /* useCard : "1" (Test용 법인용 공인인증서, 사업자 등록번호 : 2128159710)
        "2" (Test용 법인용 블럭체인 사설인증서, 사업자 등록번호 : 1122334455)
        "3" {Test용 개인용 블럭체인 사설인증서, 사업자 등록번호 : ""} */
		String localServerFlag = EverString.nullToEmptyString(req.getParameter("localServerFlag"));
        if(localServerFlag.equals("N")) {
            Map<String, String> rtnMap = EverCert.doCheckCert(sSignData, vidRandom, idn, "1");
            // 서명값 검증 실패
            if (rtnMap.get("certRtnCd").equals("-1")) {
                throw new Exception(rtnMap.get("certRtnMsg"));
            }
        }
		/** ====================== 공인인증서 처리 ===========================================*/
        
    	// 저장=0, 완료=1
    	String status = EverString.defaultIfEmpty(req.getParameter("status"), "0");
    	
    	Map<String, String> param = req.getFormData();
    	param.put("NOTICE_TYPE", "CMS");
    	param.put("POPUP_FLAG", status);
    	
    	param.put("TEXT_SIGN_CONTENTS", sSignData); // 전자서명값
    	param.put("VID_RANDOM", vidRandom); // 전자서명Key값
    	param.put("IRS_NUM", idn); // 전자서명 사업자번호
    	
        Map<String, String> rtnMap = oetr0020_service.oetr0021_doSave(param);
        
        resp.setParameter("NOTICE_NUM", rtnMap.get("NOTICE_NUM"));
        resp.setResponseMessage(rtnMap.get("rtnMsg"));
    }

    // 삭제
    @RequestMapping(value = "/oetr0051_doDelete")
    public void oetr0051_doDelete(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	
        String rtnMsg = oetr0020_service.oetr0021_doDelete(req.getFormData());
        resp.setResponseMessage(rtnMsg);
    }
    
    /**
     * 2021.02.22 추가
     * My Page > My Page > ASP이용계약현황 (OETR0060)
     * @param req
     * @return
     */
    @RequestMapping(value="/OETR0060/view")
    public String OETR0060(EverHttpRequest req) {
        req.setAttribute("addFromDate", EverDate.addDateMonth(EverDate.getDate(), -1));
        req.setAttribute("addToDate", EverDate.addDateMonth(EverDate.getDate(), +2));
        
        return "/nhepro/OETR/OETR0060";
    }
    
    // 조회
    @RequestMapping(value = "/oetr0060_doSearch")
    public void oetr0060_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	
    	Map<String, String> param = req.getFormData();
        resp.setGridObject("grid", oetr0020_service.oetr0060_doSearch(param));
    }
    
    /**
     * 2021.02.24 추가
     * My Page > My Page > ASP이용계약현황 (OETR0060) > 상세보기 팝업
     * @param req
     * @return
     */
    @RequestMapping(value="/OETR0061/view")
    public String OETR0061(EverHttpRequest req) throws Exception {
    	
    	Map<String, String> param = new HashMap<>();

        String companyCd = EverString.nullToEmptyString(req.getParameter("COMPANY_CD"));
        String signId    = EverString.nullToEmptyString(req.getParameter("SIGN_ID"));
        String signSq    = EverString.nullToEmptyString(req.getParameter("SIGN_SQ"));
        
        param.put("COMPANY_CD", companyCd);
        param.put("SIGN_ID", signId);
        param.put("SIGN_SQ", signSq);
        Map<String, Object> formData = oetr0020_service.oetr0061_doSearchNoticeInfo(param);
        
        req.setAttribute("formData", formData);
        return "/nhepro/OETR/OETR0061";
    }
    
    @RequestMapping(value="/OETR0062/view")
    public String OETR0062(EverHttpRequest req) throws Exception {
    	
    	Map<String, String> param = new HashMap<>();

        String companyCd = EverString.nullToEmptyString(req.getParameter("COMPANY_CD"));
        String signId    = EverString.nullToEmptyString(req.getParameter("SIGN_ID"));
        String signSq    = EverString.nullToEmptyString(req.getParameter("SIGN_SQ"));
        
        param.put("COMPANY_CD", companyCd);
        param.put("SIGN_ID", signId);
        param.put("SIGN_SQ", signSq);
        Map<String, Object> formData = oetr0020_service.oetr0061_doSearchNoticeInfo(param);
        
        req.setAttribute("formData", formData);
        return "/nhepro/OETR/OETR0062";
    }
    
}
