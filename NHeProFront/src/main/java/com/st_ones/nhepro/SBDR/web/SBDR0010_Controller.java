package com.st_ones.nhepro.SBDR.web;

import com.st_ones.common.combo.service.CommonComboService;
import com.st_ones.common.file.service.FileAttachService;
import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.common.util.clazz.EverCert;
import com.st_ones.common.util.clazz.EverDate;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.common.util.service.EverDateService;
import com.st_ones.common.util.service.LargeTextService;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.nhepro.CBDI.service.CBDI0010_Service;
import com.st_ones.nhepro.SBDR.service.SBDR0010_Service;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import java.io.FileInputStream;
import java.io.InputStream;
import java.math.BigInteger;
import java.net.URLDecoder;
import java.util.*;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2014 ST-Ones CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : CBDI0010_Controller.java
 * @date 2020. 4. 02.
 * @version 1.0
 */

@Controller
@RequestMapping(value = "/nhepro/SBDR")
public class SBDR0010_Controller extends BaseController {

    @Autowired private EverDateService everDate;

    @Autowired private CommonComboService commonComboService;

    @Autowired private SBDR0010_Service sbdr_Service;

    @Autowired private CBDI0010_Service cbdi_Service;

	@Autowired private FileAttachService fileAttachService;

    @Autowired private LargeTextService largeTextService;

    /**
     * 화면명 : 입찰참가신청
     * 처리내용 : 입찰공고 및 입찰참가신청 중인 입찰건의 목록이 조회하는 화면.
     * 경로 : 협력업체 > 구매관리 > 입찰관리 > 입찰참가신청
     */
    @RequestMapping(value="/SBDR0010/view")
    public String sbdr0010_view(EverHttpRequest req) throws Exception {
        req.setAttribute("reqFromDate", EverDate.addDateMonth(EverDate.getDate(), -1));
        req.setAttribute("reqToDate", EverDate.addDateMonth(EverDate.getDate(), 1));
        return "/nhepro/SBDR/SBDR0010";
    }

    @RequestMapping(value = "/sbdr0010_doSearch")
    public void sbdr0010_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        UserInfo userInfo = UserInfoManager.getUserInfo();
        Map<String, String> param = req.getFormData();
        param.put("VENDOR_CD", userInfo.getCompanyCd());

        resp.setGridObject("grid", sbdr_Service.sbdr0010_doSearch(param));
    }
    
    /**
     * 2020.12.02 기능 추가
     * 입찰참가신청시 현재의 진행상태 가져와서 가능여부 체크함
     */
    @RequestMapping(value = "/sbdr0010_doCheckProgressCd")
    public void sbdr0010_doCheckProgressCd(EverHttpRequest req, EverHttpResponse resp) throws Exception {

    	Map<String, String> param = req.getFormData();
    	Map<String, String> rtnMsg = sbdr_Service.sbdr0010_doCheckProgressCd(param);
    	
        resp.setResponseCode(rtnMsg.get("rtnCode"));
        resp.setResponseMessage(rtnMsg.get("rtnMsg"));
    }

    /**
     * 화면명 : 입찰공고상세(업체)
     * 처리내용 : 입찰공고의 상세내용을 조회하는 Popup 화면.
     * 경로 : 협력업체 > 구매관리 > 입찰관리
     */
    @RequestMapping(value = "/SBDR0011/view")
    public String sbdr0011_view(EverHttpRequest req) throws Exception {
        Map<String,String> param = req.getParamDataMap();
        Map<String, Object> formData = cbdi_Service.cbdr0012_doSearch(param);
        formData.put("ATT_FILE", fileAttachService.getFilesInfo("BID",String.valueOf(formData.get("ATT_FILE_NUM"))));
        String appEtc = largeTextService.selectLargeText(String.valueOf(formData.get("APP_ETC")));
        if (appEtc!=null) {
			appEtc = appEtc.replaceAll("&amp;", "&").replaceAll("&lt;", "<").replaceAll("&gt;", ">").replaceAll("&apos;", "'").replaceAll("&quot;", "\\\"");
        }
        req.setAttribute("APP_ETC",  appEtc);
        req.setAttribute("formData",  formData);
        return "/nhepro/SBDR/SBDR0011";
    }
    /**
     * 화면명 : 취소공고상세(업체)
     * 처리내용 : 취소공고의 상세내용을 조회하는 Popup 화면.
     * 경로 : 협력업체 > 구매관리 > 입찰관리
     */
    @RequestMapping(value = "/SBDR0012/view")
    public String sbdr0012_view(EverHttpRequest req) throws Exception {
        Map<String,String> param = req.getParamDataMap();
        Map<String, Object> formData = cbdi_Service.cbdr0012_doSearch(param);
        req.setAttribute("formData",  formData);
        return "/nhepro/SBDR/SBDR0012";
    }

    /**
     * 화면명 : 참가신청등록
     * 처리내용 : 협력업체에서 참가신청서를 제출하는 화면 (제출시 공인인증서를 이용하여 전자서명을 진행해야 한다)
     * 경로 : 협력업체 > 구매관리 > 입찰관리 > 입찰참가신청 > 참가신청등록
     */
    @RequestMapping(value="/SBDI0013/view")
    public String sbdi0013_view(EverHttpRequest req) throws Exception {

        boolean havePermission = false;
        String localServerFlag = "N";

        Map<String, String> formData = new HashMap<String, String>();
        Map<String, String> param = new HashMap<String, String>();

        String buyerCd = EverString.nullToEmptyString(req.getParameter("BUYER_CD"));
        String bidNum = EverString.nullToEmptyString(req.getParameter("BID_NUM"));
        String bidCnt = EverString.nullToEmptyString(req.getParameter("BID_CNT"));
        String vendorCd = EverString.nullToEmptyString(req.getParameter("VENDOR_CD"));
        
        // 입찰참가신청서 수정
        if((!buyerCd.equals("") && !bidNum.equals("") && !bidCnt.equals(""))) {
            param.put("BUYER_CD", buyerCd);
            param.put("BID_NUM", bidNum);
            param.put("BID_CNT", bidCnt);
            param.put("VENDOR_CD", vendorCd);
            formData = sbdr_Service.sbdi0013_doSearch(param);
            
            // 2021.06.29 : 입찰신청을 중복으로 할 수 있음
            //if(formData.get("APPLY_POSSIBLE_FLAG").equals("Y") && EverString.nullToEmptyString(formData.get("APP_DATE")).equals("")) {
            if( formData.get("APPLY_POSSIBLE_FLAG").equals("Y") ) {
                havePermission = true;
            }
        }
        
        if(PropertiesManager.getBoolean("eversrm.system.localserver") || PropertiesManager.getBoolean("eversrm.system.developmentFlag")) {
            localServerFlag = "Y";
        }

        // ipoid : 법인용 공인인증기관 공인인증서, iboid : 법인용 블럭체인 사설인증서, pboid : 개인용 블럭체인 사설인증서
        req.setAttribute("certOidfilter", PropertiesManager.getString("magicline.certverify.ipoid"));

        req.setAttribute("formData", formData);
        req.setAttribute("today", EverDate.getDate());
		req.setAttribute("todayTime", EverDate.getTime());
        req.setAttribute("havePermission", havePermission);
        req.setAttribute("localServerFlag", localServerFlag);
        req.setAttribute("signDate", EverDate.getDate() + EverDate.getTime());
        return "/nhepro/SBDR/SBDI0013";
    }

    @RequestMapping(value = "/sbdi0013_doSubmit")
    public void sbdi0013_doSubmit(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        String localServerFlag = EverString.nullToEmptyString(req.getParameter("localServerFlag"));
        String sSignData = EverString.nullToEmptyString(req.getParameter("signedData"));
        sSignData = URLDecoder.decode(sSignData, "utf-8");
        String vidRandom = EverString.nullToEmptyString(req.getParameter("vidRandom"));
        vidRandom = URLDecoder.decode(vidRandom, "utf-8");
        String idn = EverString.nullToEmptyString(req.getParameter("idn"));

        /* useCard : "1" (Test용 법인용 공인인증서, 사업자 등록번호 : 2128159710)
                     "2" (Test용 법인용 블럭체인 사설인증서, 사업자 등록번호 : 1122334455)
                     "3" {Test용 개인용 블럭체인 사설인증서, 사업자 등록번호 : ""} */
        if(localServerFlag.equals("N")) {
            Map<String, String> rtnMap = EverCert.doCheckCert(sSignData, vidRandom, idn, "1");
            // 서명값 검증 실패
            if(rtnMap.get("certRtnCd").equals("-1")) {
                throw new Exception(rtnMap.get("certRtnMsg"));
            }
        }

        Map<String, String> formData = req.getFormData();
        formData.put("GUAR_AMT_CERTV", sSignData);
        formData.put("VID_RANDOM", vidRandom);

        String rtnMsg = sbdr_Service.sbdi0013_doSubmit(formData);
        resp.setParameter("buyerCd", formData.get("BUYER_CD"));
        resp.setParameter("bidNum", formData.get("BID_NUM"));
        resp.setParameter("bidCnt", formData.get("BID_CNT"));
        resp.setParameter("vendorCd", formData.get("VENDOR_CD"));
        resp.setResponseMessage(rtnMsg);
    }
    
    /**
     * 2021.10.21 : 입찰신청취소
     * @param req
     * @param resp
     * @throws Exception
     */
    @RequestMapping(value = "/sbdi0013_doCancelReq")
    public void sbdi0013_doCancelReq(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> formData = req.getFormData();
        String rtnMsg = sbdr_Service.sbdi0013_doCancelReq(formData);
        
        resp.setResponseMessage(rtnMsg);
    }

	/**
	 * 화면명 : 사업설명회조회
	 * 처리내용 : 취소공고의 상세내용을 조회하는 Popup 화면.
	 * 경로 : 협력업체 > 구매관리 > 입찰관리 > 입찰관리신정
	 */
	@RequestMapping(value = "/SBDR0014/view")
	public String sbdr0014_view(EverHttpRequest req) throws Exception {
		Map<String,String> param = req.getParamDataMap();
		Map<String, String> formData = sbdr_Service.sbdr0014_doSearch(param);
		req.setAttribute("formData",  formData);
		return "/nhepro/SBDR/SBDR0014";
	}

	/**
	 * 화면명 : 제안발표회조회
	 * 처리내용 : 취소공고의 상세내용을 조회하는 Popup 화면.
	 * 경로 : 협력업체 > 구매관리 > 입찰관리 > 입찰관리신정
	 */
	@RequestMapping(value = "/SBDR0015/view")
	public String sbdr0015_view(EverHttpRequest req) throws Exception {
		Map<String,String> param = req.getParamDataMap();
		Map<String, String> formData = sbdr_Service.sbdr0014_doSearch(param);
		req.setAttribute("formData",  formData);
		return "/nhepro/SBDR/SBDR0015";
	}

    /**
     * 화면명 : 가격입찰
     * 처리내용 : 입찰서 제출 전부터 개찰 전까지의 입찰 목록이 조회하는 화면.
     * 경로 : 협력업체 > 구매관리 > 입찰관리 > 가격입찰
     */
    @RequestMapping(value="/SBDR0020/view")
    public String sbdr0020_view(EverHttpRequest req) throws Exception {
        req.setAttribute("fromDate", EverDate.addDateMonth(EverDate.getDate(), -1));
        req.setAttribute("toDate", EverDate.addDateMonth(EverDate.getDate(), 1));
        return "/nhepro/SBDR/SBDR0020";
    }

    @RequestMapping(value = "/sbdr0020_doSearch")
    public void sbdr0020_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.setGridObject("grid", sbdr_Service.sbdr0020_doSearch(req.getFormData()));
    }

    /**
     * 화면명 : 입찰서제출
     * 처리내용 : 협력업체에서 입찰서를 제출하는 화면. (제출시 공인인증서를 이용하여 전자서명을 진행해야 한다)
     * 경로 : 협력업체 > 구매관리 > 입찰관리 > 가격입찰 > 입찰서제출
     */
    @RequestMapping(value="/SBDI0021/view")
    public String sbdi0021_view(EverHttpRequest req) throws Exception {

        UserInfo userInfo = UserInfoManager.getUserInfo();
        boolean havePermission = false;
        String localServerFlag = "N";

        Map<String, String> formData = new HashMap<String, String>();
        Map<String, String> param = new HashMap<String, String>();

        String buyerCd = EverString.nullToEmptyString(req.getParameter("buyerCd"));
        String bidNum = EverString.nullToEmptyString(req.getParameter("bidNum"));
        String bidCnt = EverString.nullToEmptyString(req.getParameter("bidCnt"));
        String voteCnt = EverString.nullToEmptyString(req.getParameter("voteCnt"));
        String vendorCd = EverString.nullToEmptyString(req.getParameter("vendorCd"));

        if(!bidNum.equals("") && !bidCnt.equals("") && !voteCnt.equals(""))
        {
            param.put("BUYER_CD", buyerCd);
            param.put("BID_NUM", bidNum);
            param.put("BID_CNT", bidCnt);
            param.put("VOTE_CNT", voteCnt);
            param.put("VENDOR_CD", vendorCd);
            formData = sbdr_Service.sbdi0021_doSearchHD(param);

            if(userInfo.getCompanyCd().equals(formData.get("VENDOR_CD"))) {
                havePermission = true;
            }
        }

        havePermission = EverString.nullToEmptyString(userInfo.getSuperUserFlag()).equals("1") ? true : havePermission;

        List<Map<String, String>> choiceList = new ArrayList<Map<String, String>>();
        int listIdx = 0;
        for(int i = 1; i < 16; i++) {
            Map<String, String> tmp = new HashMap<String, String>();
            tmp.put("value", String.valueOf(i));
            tmp.put("text", String.valueOf(i));
            choiceList.add(listIdx, tmp);
            listIdx++;
        }

        if(PropertiesManager.getBoolean("eversrm.system.localserver") || PropertiesManager.getBoolean("eversrm.system.developmentFlag")) {
            localServerFlag = "Y";
        }

        // ipoid : 법인용 공인인증기관 공인인증서, iboid : 법인용 블럭체인 사설인증서, pboid : 개인용 블럭체인 사설인증서
        req.setAttribute("certOidfilter", PropertiesManager.getString("magicline.certverify.ipoid"));

        req.setAttribute("choiceList", choiceList);
        req.setAttribute("formData", formData);
        req.setAttribute("havePermission", havePermission);
        req.setAttribute("localServerFlag", localServerFlag);
        req.setAttribute("signDate", EverDate.getDate() + EverDate.getTime());
        return "/nhepro/SBDR/SBDI0021";
    }

    @RequestMapping(value = "/sbdi0021_doSearch")
    public void sbdi0021_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.setGridObject("grid", sbdr_Service.sbdi0021_doSearch(req.getFormData()));
    }
    
    /**
     * 2020.12.02 기능 추가
     * 가격입찰시 현재의 진행상태 가져와서 가능여부 체크함
     */
    @RequestMapping(value = "/sbdr0020_doCheckProgressCd")
    public void sbdr0020_doCheckProgressCd(EverHttpRequest req, EverHttpResponse resp) throws Exception {

    	Map<String, String> param = req.getFormData();
    	Map<String, String> rtnMsg = sbdr_Service.sbdr0020_doCheckProgressCd(param);
    	
        resp.setResponseCode(rtnMsg.get("rtnCode"));
        resp.setResponseMessage(rtnMsg.get("rtnMsg"));
    }
    
    @RequestMapping(value = "/sbdi0021_doSend")
    public void sbdi0021_doSend(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        String localServerFlag = EverString.nullToEmptyString(req.getParameter("localServerFlag"));
        String sSignData = EverString.nullToEmptyString(req.getParameter("signedData"));
        sSignData = URLDecoder.decode(sSignData, "utf-8");
        String vidRandom = EverString.nullToEmptyString(req.getParameter("vidRandom"));
        vidRandom = URLDecoder.decode(vidRandom, "utf-8");
        String idn = EverString.nullToEmptyString(req.getParameter("idn"));
	        /* useCard : "1" (Test용 법인용 공인인증서, 사업자 등록번호 : 2128159710)
	                     "2" (Test용 법인용 블럭체인 사설인증서, 사업자 등록번호 : 1122334455)
	                     "3" {Test용 개인용 블럭체인 사설인증서, 사업자 등록번호 : ""} */
        
        if(localServerFlag.equals("N")) {
            Map<String, String> rtnMap = EverCert.doCheckCert(sSignData, vidRandom, idn, "1");
            // 서명값 검증 실패
            if(rtnMap.get("certRtnCd").equals("-1")) {
                throw new Exception(rtnMap.get("certRtnMsg"));
            }
        }

        Map<String, String> formData = req.getFormData();
        formData.put("CHOICE_ESTM_NUM1", EverString.nullToEmptyString(req.getParameter("CHOICE_ESTM_NUM1")));
        formData.put("CHOICE_ESTM_NUM2", EverString.nullToEmptyString(req.getParameter("CHOICE_ESTM_NUM2")));
        formData.put("BID_AMT_CERTV", sSignData);
        formData.put("VID_RANDOM", vidRandom);

        List<Map<String, Object>> gridDatas = req.getGridData("grid");

        String rtnMsg = sbdr_Service.sbdi0021_doSend(formData, gridDatas);
        resp.setResponseMessage(rtnMsg);
    }

    @RequestMapping(value = "/sbdi0021_doSendPrc")
    public void sbdi0021_doSendPrc(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        String localServerFlag = EverString.nullToEmptyString(req.getParameter("localServerFlag"));
        String progressCd = EverString.nullToEmptyString(req.getParameter("progressCd"));
        String sSignData = EverString.nullToEmptyString(req.getParameter("signedData"));
        sSignData = URLDecoder.decode(sSignData, "utf-8");
        String vidRandom = EverString.nullToEmptyString(req.getParameter("vidRandom"));
        vidRandom = URLDecoder.decode(vidRandom, "utf-8");
        String idn = EverString.nullToEmptyString(req.getParameter("idn"));

        /* useCard : "1" (Test용 법인용 공인인증서, 사업자 등록번호 : 2128159710)
                     "2" (Test용 법인용 블럭체인 사설인증서, 사업자 등록번호 : 1122334455)
                     "3" {Test용 개인용 블럭체인 사설인증서, 사업자 등록번호 : ""} */
        String useCard = "";
        if(PropertiesManager.getBoolean("eversrm.system.localserver") || PropertiesManager.getBoolean("eversrm.system.developmentFlag")) {
            useCard = "1";
        }
        
        // 로컬 서버이며 임시저장이 아닌경우에 서명 값 검증
        // progressCd "T" => 임시저장
        // progressCd "E" => 단가제출
	    if(localServerFlag.equals("N")) {
	        if(progressCd.equals("E")) {
	            Map<String, String> rtnMap = EverCert.doCheckCert(sSignData, vidRandom, idn, useCard);
	            // 서명값 검증 실패
	            if (rtnMap.get("certRtnCd").equals("-1")) {
	                throw new Exception(rtnMap.get("certRtnMsg"));
	            }
	        }
        }
        
        // 2021.11.02 : 단가제출상태 '임시저장' 추가
        Map<String, String> formData = req.getFormData();
        formData.put("ADJ_CERTV", sSignData);
        formData.put("ADJ_VID_RANDOM", vidRandom);
        formData.put("ADJ_PRC_STATUS", progressCd);

        List<Map<String, Object>> gridDatas = req.getGridData("grid");

        String rtnMsg = sbdr_Service.sbdi0021_doSendPrc(formData, gridDatas);
        resp.setResponseMessage(rtnMsg);
    }

    /**
     * 화면명 : 입찰결과
     * 처리내용 : 협력업체에서 참여한 입찰의 개찰결과 목록이 조회된다.
     * 경로 : 협력업체 > 구매관리 > 입찰관리 > 입찰결과
     */
    @RequestMapping(value="/SBDR0030/view")
    public String sbdr0030_view(EverHttpRequest req) throws Exception {
        req.setAttribute("fromDate", EverDate.addDateMonth(EverDate.getDate(), -1));
        req.setAttribute("toDate", EverDate.addDateMonth(EverDate.getDate(), 1));
        return "/nhepro/SBDR/SBDR0030";
    }

    @RequestMapping(value = "/sbdr0030_doSearch")
    public void sbdr0030_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.setGridObject("grid", sbdr_Service.sbdr0030_doSearch(req.getFormData()));
    }
    
    @RequestMapping(value = "/sbdi0013_doBidGuarCancel")
	public void sbdi0013_doBidGuarCancel(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	
    	Map<String, String> param = req.getFormData();
    	param.put("GUAR_CANCEL_RMK", req.getParameter("GUAR_CANCEL_RMK"));
    	Map<String, String> rtnMsg = sbdr_Service.sbdi0013_doBidGuarCancel(param);
    	
    	resp.setParameter("buyerCd", param.get("BUYER_CD"));
        resp.setParameter("bidNum", param.get("BID_NUM"));
        resp.setParameter("bidCnt", param.get("BID_CNT"));
        resp.setParameter("vendorCd", param.get("VENDOR_CD"));
        resp.setResponseMessage(rtnMsg.get("rtnMsg"));
	}
    
    @RequestMapping(value="/SBDI0014/view")
    public String sbdi0014_view(EverHttpRequest req) throws Exception {
        return "/nhepro/SBDR/SBDI0014";
    }

}