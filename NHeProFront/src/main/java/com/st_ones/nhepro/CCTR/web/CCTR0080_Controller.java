package com.st_ones.nhepro.CCTR.web;

import java.net.URLDecoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.st_ones.common.combo.service.CommonComboService;
import com.st_ones.common.docNum.service.DocNumService;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.serverpush.reverseajax.EverRestJson;
import com.st_ones.common.util.clazz.EverCert;
import com.st_ones.common.util.clazz.EverDate;
import com.st_ones.common.util.clazz.EverFile;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.util.EverString;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.nhepro.CCTR.service.CCTR0080_Service;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : CCTR0080_Controller.java
 * @date 2020.06.10
 * @version 1.0
 * @see
 */

@Controller
@RequestMapping(value = "/nhepro/CCTR")
public class CCTR0080_Controller extends BaseController{
    @Autowired
    private MessageService msg;
    @Autowired
    private CCTR0080_Service cctr0080_Service;
    @Autowired
    private CommonComboService commonComboService;
    @Autowired
    private DocNumService docNumService;

	/**
	 * 화면명 : 위임장 요청현황
	 * 처리내용 :
	 * 경로 : 계약관리 > 전자계약 > 위임장요청현황
	 */
    @RequestMapping(value="/CCTR0080/view")
    public String CCTR0080(EverHttpRequest req) throws Exception {
        req.setAttribute("fromDate", EverDate.addMonths(-1));
        req.setAttribute("toDate", EverDate.getDate());

        return "/nhepro/CCTR/CCTR0080";
    }

	/**
	 * 화면명 : 위임장 요청현황
	 * 처리내용 : 조회
	 * 경로 : 계약관리 > 전자계약 > 위임장요청현황
	 */
    @RequestMapping(value="/CCTR0080/doSearch")
    public void CCTR0080_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> param = req.getFormData();

        resp.setGridObject("grid", cctr0080_Service.cctr0080_doSearch(param));
        resp.setResponseCode("true");
    }
    
    /**
	 * 화면명 : 위임장 현황
	 * 처리내용 :
	 * 경로 : 계약관리 > 전자계약 > 위임장현황
	 */
    @RequestMapping(value="/CCTR0081/view")
    public String CCTR0081(EverHttpRequest req) throws Exception {
        req.setAttribute("fromDate", EverDate.addMonths(-1));
        req.setAttribute("toDate", EverDate.getDate());

        return "/nhepro/CCTR/CCTR0081";
    }
    
    /**
	 * 화면명 : 위임장 현황
	 * 처리내용 : 조회
	 * 경로 : 계약관리 > 전자계약 > 위임장현황
	 */
    @RequestMapping(value="/CCTR0081/doSearch")
    public void CCTR0081_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> param = req.getFormData();

        resp.setGridObject("grid", cctr0080_Service.cctr0081_doSearch(param));
        resp.setResponseCode("true");
    }

	/**
	 * 화면명 : 위임장 요청현황
	 * 처리내용 : 취소
	 * 경로 : 계약관리 > 전자계약 > 위임장요청현황
	 */
    @RequestMapping(value="/CCTR0080/doCancel")
    public void CCTR0080_doCancel(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        List<Map<String, Object>> gridData = req.getGridData("grid");

        cctr0080_Service.cctr0080_doCancel(gridData);
        resp.setResponseMessage(msg.getMessage("0001"));
        resp.setResponseCode("true");
    }

    /**
	 * 화면명 : 위임장 요청작성
	 * 처리내용 :
	 * 경로 : 계약관리 > 전자계약 > 위임장요청현황 > 위임장 요청작성
	 */
    @RequestMapping(value="/CCTR0070/view")
    public String CCTR0070(EverHttpRequest req) throws Exception {
    	
        req.setAttribute("defaultDate", EverDate.getDate());
        req.setAttribute("defaultToDate", EverDate.addMonths(1));
    	
        String buyerCd = req.getParameter("BUYER_CD");
        String reqNum  = req.getParameter("REQ_NUM");
        
    	Map<String, String> map = new HashMap<>();
        map.put("BUYER_CD", buyerCd);
        map.put("REQ_NUM", reqNum);
        
        Map<String, String> formData = new HashMap<>();
        if( EverString.isNotEmpty(reqNum) ) {
        	formData = cctr0080_Service.cctr0070_doSearchHD(map);
        }
        formData.put("EFORM_ID", PropertiesManager.getString("oz.entrust.eform.id"));
    	
    	req.setAttribute("form", formData);
        
        return "/nhepro/CCTR/CCTR0070";
    }
    
    @RequestMapping(value="/CCTR0070/doSearch")
    public void CCTR0070_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> param = req.getFormData();

        resp.setGridObject("grid", cctr0080_Service.cctr0070_doSearchDT(param));
        resp.setResponseCode("true");
    }
    
    /**
     * 위임장 저장
     *
     * @param req
     * @param resp
     * @throws Exception
     */
    @RequestMapping(value = "/CCTR0070/doSave")
    public void CCTR0070_doSave(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> dataForm = req.getFormData();
        dataForm.put("PROGRESS_CD", req.getParameter("PROGRESS_CD"));
        
        List<Map<String, Object>> gridData = req.getGridData("grid");

        Map<String, String> resultMap = cctr0080_Service.cctr0070_doSave(dataForm, gridData);
        resp.setParameter("BUYER_CD", resultMap.get("BUYER_CD"));
        resp.setParameter("REQ_NUM", resultMap.get("REQ_NUM"));
        
        resp.setResponseMessage(msg.getMessage("0001"));
        resp.setResponseCode("true");
    }
    
    /**
	 * 화면명 : 위임장 요청서 작성
	 * 처리내용 : 취소
	 * 경로 : 계약관리 > 전자계약 > 위임장요청현황 > 위임장 요청서 작성
	 */
    @RequestMapping(value="/CCTR0070/doCancel")
    public void CCTR0070_doCancel(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	Map<String, String> dataForm = req.getFormData();
    	
        cctr0080_Service.cctr0070_doCancel(dataForm);
        resp.setResponseMessage(msg.getMessage("0001"));
        resp.setResponseCode("true");
    }

    /**
	 * 화면명 : 위임장 요청상세
	 * 처리내용 : 위임장 요청상세 조회
	 * 경로 : 계약관리 > 전자계약 > 위임장요청현황 > 위임장 요청상세
	 */
    @RequestMapping(value="/CCTR0071/view")
    public String CCTR0071(EverHttpRequest req) throws Exception {
    	
    	String localServerFlag = "N";
    	
    	Map<String, String> param = req.getFormData();
 		String buyerCd   =(req.getParameter("BUYER_CD") == null)?req.getParameter("buyerCd"):req.getParameter("BUYER_CD");
 		String reqNum    = req.getParameter("REQ_NUM");
 		String reqSeq    = req.getParameter("REQ_SEQ");
    	String appDocNum = req.getParameter("appDocNum");
 		String appDocCnt = req.getParameter("appDocCnt");
 		
        Map<String, String> map = new HashMap<>();
        map.put("BUYER_CD", buyerCd);
        map.put("REQ_NUM", reqNum);
        map.put("REQ_SEQ", reqSeq);
        map.put("APP_DOC_NUM", appDocNum);
        map.put("APP_DOC_CNT", appDocCnt);
        
        if(PropertiesManager.getBoolean("eversrm.system.localserver") || PropertiesManager.getBoolean("eversrm.system.developmentFlag")) {
            localServerFlag = "Y";
        }
        
        // ipoid : 법인용 공인인증기관 공인인증서, iboid : 법인용 블럭체인 사설인증서, pboid : 개인용 블럭체인 사설인증서
        String multiCertOidFilter = PropertiesManager.getString("magicline.certverify.ipoid") + "," + PropertiesManager.getString("magicline.certverify.iboid");
        req.setAttribute("certOidfilter", multiCertOidFilter);
        
    	req.setAttribute("form", cctr0080_Service.cctr0071_doSearch(map));
    	req.setAttribute("localServerFlag", localServerFlag);
    	req.setAttribute("signDate", EverDate.getDate() + EverDate.getTime()); // signedData 검증용
    	
        return "/nhepro/CCTR/CCTR0071";
    }
    
    @RequestMapping(value="/CCTR0071/doSaveEform")
    public void CCTR0071_doSaveEform(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	
    	Map<String, String> param = req.getParamDataMap();
        String eformId = cctr0080_Service.cctr0071_doSaveEform(param);
        
        resp.setParameter("EFORM_ID", eformId);
        resp.setResponseMessage(msg.getMessage("0001"));
        resp.setResponseCode("true");
    }
    
    // 위임장 계약서 결재상신
  	@RequestMapping(value = "/CCTR0071/doReqSign")
  	public void cctr0071_doReqSign(EverHttpRequest req, EverHttpResponse resp) throws Exception {

  		Map<String, String> dataForm = req.getFormData();

  		List<Map<String, Object>> gridData  = null;
  		Map<String, String> resultMap = cctr0080_Service.cctr0071_doReqSign(dataForm, gridData);
  		
  		resp.setParameter("buyerCd", resultMap.get("BUYER_CD"));
  		resp.setParameter("reqNum", resultMap.get("REQ_NUM"));
  		resp.setParameter("reqSeq", String.valueOf(resultMap.get("REQ_SEQ")));

  		resp.setResponseMessage(msg.getMessage("0001"));
  		resp.setResponseCode("true");
  	}
  	
    /**
     * 위임장에 서명하기
     *
     * @param req
     * @param resp
     * @throws Exception
     */
    @RequestMapping(value = "/CCTR0071/cctr0071_doSignCompleteTSA")
    public void cctr0071_doSignCompleteTSA(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map jsonData = new ObjectMapper().readValue(req.getParamDataMap().get("FILE_INFO"), Map.class);
        
        // TSA 인증 값 입히기
        String targetDirectory = jsonData.get("FILE_PATH").toString();
        String targetFileNm = jsonData.get("UUID") + "_" + jsonData.get("UUID_SQ") + "." + jsonData.get("EXTENSION");

        // 파일 이동 후 위변조 방지를 위해 Binary 적용
        String binaryFile = EverFile.fileToBinary(targetDirectory, targetFileNm);
        Map<String, String> binaryMap = new HashMap<>();
        binaryMap.put("url", PropertiesManager.getString("block.chain.getToken"));
        binaryMap.put("strFromFile", binaryFile);
        
        JSONObject jsonObject = EverRestJson.actionAPI(binaryMap);
        System.out.println("jsonObject");
        System.out.println(jsonObject.toString());
        EverFile.binaryToFile(jsonObject.get("data").toString(), targetDirectory, targetFileNm);
    }
    
    /**
     * 전자서명된 데이터를 저장하고 계약서 상태를 변경한다.
     * @param req
     * @param resp
     * @throws Exception
     */
    @RequestMapping(value = "/CCTR0071/doSaveSignedData")
    public void sctr0071_doSaveSignedData(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	
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
            Map<String, String> rtnMap = EverCert.doCheckCert(sSignData, vidRandom, idn, "2");
            // 서명값 검증 실패
            if(rtnMap.get("certRtnCd").equals("-1")) {
                throw new Exception(rtnMap.get("certRtnMsg"));
            }
		}
		/** ====================== 공인인증서 처리 ===========================================*/
        
    	Map<String, String> param = req.getFormData();
    	
        Map<String, Object> map = new HashMap<>();
        map.put("BUYER_CD", param.get("BUYER_CD"));
        map.put("REQ_NUM", param.get("REQ_NUM"));
        map.put("REQ_SEQ", param.get("REQ_SEQ"));
        map.put("SIGN_VALUE", sSignData);	// 전자서명값
        map.put("VID_RANDOM", vidRandom);	// 전자서명값 검증을 위한 Key값
        
        cctr0080_Service.sctr0071_doSaveSignedData(map);
        
        resp.setResponseMessage(msg.getMessage("0001"));
        resp.setResponseCode("true");
    }
    
    /**
	 * 화면명 : 위임장요청 상세보기
	 * 처리내용 : 반려
	 * 경로 : 계약관리 > 전자계약 > 위임장요청 상세보기
	 */
    @RequestMapping(value="/CCTR0071/doReject")
    public void CCTR0071_doReject(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	
    	Map<String, String> param = req.getFormData();
        Map<String, Object> map = new HashMap<>();
        map.put("BUYER_CD", param.get("BUYER_CD"));
        map.put("REQ_NUM", param.get("REQ_NUM"));
        map.put("REQ_SEQ", param.get("REQ_SEQ"));
        map.put("REJECT_RMK", param.get("REJECT_RMK"));
        
        cctr0080_Service.CCTR0071_doReject(map);
        
        resp.setResponseMessage(msg.getMessage("0001"));
        resp.setResponseCode("true");
    }
    
}

