package com.st_ones.nhepro.SRQR.web;

import java.net.URLDecoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.st_ones.common.combo.service.CommonComboService;
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
import com.st_ones.nhepro.SRQR.service.SRQR0010_Service;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : SRQR0010_Controller.java
 * @date 2020.06.10
 * @version 1.0
 * @see
 */

@Controller
@RequestMapping(value = "/nhepro/SRQR")
public class SRQR0010_Controller extends BaseController{
    @Autowired
    private MessageService msg;
    @Autowired
    private SRQR0010_Service srqr0010_Service;
    @Autowired
    private CommonComboService commonComboService;

	/**
	 * 화면명 : 견적현황
	 * 처리내용 : 협력업체 견적현황
	 * 경로 : 계약관리 > 견적관리 > 견적현황
	 */
    @RequestMapping(value="/SRQR0010/view")
    public String SRQR0010(EverHttpRequest req) throws Exception {
        req.setAttribute("fromDate", EverDate.addMonths(-1));
        req.setAttribute("toDate", EverDate.addMonths(1));
        //req.setAttribute("toDate", EverDate.getDate());

        return "/nhepro/SRQR/SRQR0010";
    }

    /**
	 * 화면명 : 견적현황
	 * 처리내용 : 협력업체 견적현황
	 * 경로 : 계약관리 > 견적관리 > 견적현황
	 */
    @RequestMapping(value="/srqr0010_doSearch")
    public void SRQR0010_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> param = req.getFormData();

        resp.setGridObject("grid", srqr0010_Service.srqr0010_doSearch(param));
        resp.setResponseCode("true");
    }
    
    // 견적접수
    @RequestMapping(value = "/srqr0010_doAccept")
	public void srqr0010_doAccept(EverHttpRequest req, EverHttpResponse resp) throws Exception {
		
		List<Map<String, Object>> gridDatas = req.getGridData("grid");
		
		String rtnMsg = srqr0010_Service.srqr0010_doAccept(gridDatas);
		resp.setResponseMessage(rtnMsg);
	}
    
    // 견적포기
    @RequestMapping(value = "/srqr0010_doGiveup")
	public void srqr0010_doGiveup(EverHttpRequest req, EverHttpResponse resp) throws Exception {
		
		List<Map<String, Object>> gridDatas = req.getGridData("grid");
		
		String rtnMsg = srqr0010_Service.srqr0010_doGiveup(gridDatas);
		resp.setResponseMessage(rtnMsg);
	}
    
    /** ******************************************************************************************
     * 견적서 작성(협력업체)
     * @param req
     * @return
     * @throws Exception
     */
	@RequestMapping("/SRQI0011/view")
    public String SRQI0011(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		UserInfo userInfo = UserInfoManager.getUserInfo();
		boolean havePermission = true;
        String localServerFlag = "N";
        
        HashMap<String, String> param = new HashMap<String, String>();
        param.put("BUYER_CD", EverString.nullToEmptyString(req.getParameter("BUYER_CD")));
        param.put("RFX_NUM",  EverString.nullToEmptyString(req.getParameter("RFX_NUM")));
        param.put("RFX_CNT",  EverString.nullToEmptyString(req.getParameter("RFX_CNT")));
        param.put("QTA_NUM",  EverString.nullToEmptyString(req.getParameter("QTA_NUM")));
        param.put("RFX_TYPE", EverString.nullToEmptyString(req.getParameter("RFX_TYPE")));
        param.put("VENDOR_CD",EverString.nullToEmptyString(req.getParameter("VENDOR_CD")));
        
        // 1. 견적에 포함된 협력업체 정보 가져오기
        List<Map<String, String>> vendorList = srqr0010_Service.getVendorQtaCreation(param);
        if (vendorList == null || vendorList.size() == 0) {
            req.setAttribute("refVendorValue", "");
        } else {
            param.put("VENDOR_CD", EverString.nullToEmptyString(req.getParameter("VENDOR_CD")));
            req.setAttribute("refVendorValue", new ObjectMapper().writeValueAsString(vendorList));
        }
        req.setAttribute("refVendor", vendorList);
        
        // 2. 협력사 투찰정보 가져오기
        Map<String, String> formData = srqr0010_Service.doSearchQtaCreation_F(param);
        if(EverString.nullToEmptyString(formData.get("SEND_DATE")).trim().length() > 0) {
        	req.setAttribute("buttonStatus", "N");	// 제출완료
        	havePermission = false;
        } else {
        	req.setAttribute("buttonStatus", "Y");	// 미제출
        	// Session과 투찰정보의 협력업체 코드가 같은지 체크
        	if(userInfo.getUserType().equals("S") && userInfo.getCompanyCd().equals(formData.get("VENDOR_CD"))) {
				havePermission = true;
			} else {
				havePermission = false;
			}
        }
        
        // 3. 유효기간
        if(EverString.nullToEmptyString(formData.get("VALID_TO_DATE")).equals("")) {
        	formData.put("VALID_TO_DATE", EverDate.addDateMonth(EverDate.getDate(), 3));
        }
        
        if(PropertiesManager.getBoolean("eversrm.system.localserver") || PropertiesManager.getBoolean("eversrm.system.developmentFlag")) {
            localServerFlag = "Y";
        }
        
        // ipoid : 법인용 공인인증기관 공인인증서, iboid : 법인용 블럭체인 사설인증서, pboid : 개인용 블럭체인 사설인증서
        req.setAttribute("certOidfilter", PropertiesManager.getString("magicline.certverify.ipoid"));
        
        req.setAttribute("formData", formData);
        req.setAttribute("havePermission", havePermission);
        req.setAttribute("localServerFlag", localServerFlag);
        req.setAttribute("signDate", EverDate.getDate() + EverDate.getTime()); // signedData 검증용
        req.setAttribute("today", EverDate.getDate()); // 견적유효기간 체크용
        
        return "/nhepro/SRQR/SRQI0011";
    }

	@RequestMapping(value = "/srqi0011_doSearchDT")
	public void srqi0011_doSearchDT(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		Map<String, String> param = req.getFormData();
		resp.setGridObject("grid", srqr0010_Service.doSearchQtaCreation_G(param));
	}
	
	@RequestMapping(value = "/srqi0011_doSave")
	public void srqi0011_doSave(EverHttpRequest req, EverHttpResponse resp) throws Exception {
		
		Map<String, String> formData = req.getFormData();
		formData.put("SEND_FLAG", EverString.nullToEmptyString(req.getParameter("sendFlag")));
        
		List<Map<String, Object>> gridDatas = req.getGridData("grid");
		
		Map<String, String> rtnMap = srqr0010_Service.srqi0011_doSave(formData, gridDatas);
		resp.setParameter("BUYER_CD", rtnMap.get("BUYER_CD"));
		resp.setParameter("RFX_NUM",  rtnMap.get("RFX_NUM"));
		resp.setParameter("RFX_CNT",  rtnMap.get("RFX_CNT"));
		resp.setParameter("QTA_NUM",  rtnMap.get("QTA_NUM"));
		resp.setParameter("RFX_TYPE", rtnMap.get("RFX_TYPE"));
		resp.setParameter("signedCd", rtnMap.get("signedCd"));
		resp.setResponseMessage(rtnMap.get("rtnMsg"));
	}
	
	@RequestMapping(value = "/srqi0011_doSubmit")
	public void srqi0011_doSubmit(EverHttpRequest req, EverHttpResponse resp) throws Exception {
		
		/** ====================== 공인인증서 처리 ===========================================*/
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
            if (rtnMap.get("certRtnCd").equals("-1")) {
                throw new Exception(rtnMap.get("certRtnMsg"));
            }
        }
		/** ====================== 공인인증서 처리 ===========================================*/
        
		Map<String, String> formData = req.getFormData();
		formData.put("SEND_FLAG", EverString.nullToEmptyString(req.getParameter("sendFlag")));
		formData.put("SIGN_VALUE", sSignData);	// 전자서명값
        formData.put("VID_RANDOM", vidRandom);	// 전자서명값 검증을 위한 Key값
        
		List<Map<String, Object>> gridDatas = req.getGridData("grid");
		
		Map<String, String> resultMap = srqr0010_Service.srqi0011_doSave(formData, gridDatas);
		resp.setParameter("BUYER_CD", resultMap.get("BUYER_CD"));
		resp.setParameter("RFX_NUM",  resultMap.get("RFX_NUM"));
		resp.setParameter("RFX_CNT",  resultMap.get("RFX_CNT"));
		resp.setParameter("QTA_NUM",  resultMap.get("QTA_NUM"));
		resp.setParameter("RFX_TYPE", resultMap.get("RFX_TYPE"));
		resp.setParameter("signedCd", resultMap.get("signedCd"));
		resp.setResponseMessage(resultMap.get("rtnMsg"));
	}
    
    /**
	 * 화면명 : 견적서 상세보기
	 * 처리내용 : 협력업체 견적서 상세보기
	 * 경로 : 계약관리 > 견적관리 > 견적현황 > 견적서 상세보기
	 */
    @RequestMapping(value="/SRQR0012/view")
    public String SRQR0012(EverHttpRequest req) throws Exception {
    	
    	Map<String, String> param = new HashMap<String, String>();
    	param.put("BUYER_CD", EverString.nullToEmptyString(req.getParameter("BUYER_CD")));
        param.put("RFX_NUM",  EverString.nullToEmptyString(req.getParameter("RFX_NUM")));
        param.put("RFX_CNT",  EverString.nullToEmptyString(req.getParameter("RFX_CNT")));
        
        Map<String, Object> formData = srqr0010_Service.srqr0012_doSearchRQHD(param);
        req.setAttribute("formData", formData);
        
        return "/nhepro/SRQR/SRQR0012";
    }

    /**
	 * 화면명 : 견적현황
	 * 처리내용 : 협력업체 견적현황
	 * 경로 : 계약관리 > 견적관리 > 견적현황
	 */
    @RequestMapping(value="/srqr0012_doSearchRQDT")
    public void SRQR0012_doSearchRQDT(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> param = req.getFormData();

        resp.setGridObject("grid", srqr0010_Service.srqr0012_doSearchRQDT(param));
        resp.setResponseCode("true");
    }
    
    /**
	 * 화면명 : 견적결과
	 * 처리내용 : 협력업체 견적결과
	 * 경로 : 계약관리 > 견적관리 > 견적결과
	 */
    @RequestMapping(value="/SRQR0020/view")
    public String SRQR0020(EverHttpRequest req) throws Exception {
        req.setAttribute("fromDate", EverDate.addMonths(-1));
        req.setAttribute("toDate", EverDate.addMonths(1));
        //req.setAttribute("toDate", EverDate.getDate());

        return "/nhepro/SRQR/SRQR0020";
    }

    /**
	 * 화면명 : 견적결과
	 * 처리내용 : 협력업체 견적결과
	 * 경로 : 계약관리 > 견적관리 > 견적결과
	 */
    @RequestMapping(value="/srqr0020_doSearch")
    public void SRQR0020_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> param = req.getFormData();

        resp.setGridObject("grid", srqr0010_Service.srqr0020_doSearch(param));
        resp.setResponseCode("true");
    }
    
    
}

