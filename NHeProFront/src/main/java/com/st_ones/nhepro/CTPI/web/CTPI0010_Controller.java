package com.st_ones.nhepro.CTPI.web;

import com.st_ones.nhepro.CTPI.service.CTPI0010_Service;
import com.st_ones.nhepro.CTPI.service.CTPI0010_Service.DataEncrypt;

import kr.co.tpay.webtx.Encryptor;

import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.common.combo.service.CommonComboService;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.util.clazz.EverDate;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;

import org.apache.commons.lang.StringEscapeUtils;
import org.apache.ibatis.scripting.xmltags.TrimSqlNode;
import org.json.simple.JSONArray;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import java.text.SimpleDateFormat;
import java.security.MessageDigest;
import java.security.cert.CertificateException;
import java.util.Date;
import org.apache.commons.codec.binary.Hex;

import java.net.HttpURLConnection;
import java.io.BufferedReader;
import java.io.PrintWriter;
import java.net.URL;
import java.io.InputStreamReader;
import org.json.simple.parser.JSONParser;
import org.json.simple.JSONObject;
import java.util.Iterator;

import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;
import javax.net.ssl.SSLSession;
import javax.net.ssl.HostnameVerifier;
import javax.security.cert.X509Certificate;







/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : CTPI0010_Controller.java
 * @date 2020.06.19
 * @version 1.0
 * @see
 */

@Controller
@RequestMapping(value = "/nhepro/CTPI")
public class CTPI0010_Controller extends BaseController{

	private static Logger logger = LoggerFactory.getLogger(CTPI0010_Controller.class);

    @Autowired private MessageService msg;

    @Autowired private CTPI0010_Service ctpi0010_Service;

    @Autowired private CommonComboService commonComboService;
    

	/**
	 * 화면명 : 
	 * 처리내용 : 
	 * 경로 :  > > 
	 */
    @RequestMapping(value="/CTPI0010/view")
    public String CTPI0010(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	// 가격 리스트
    	List<Map<String, Object>> amtList = ctpi0010_Service.ctpi0010_doSearchAmtList();
    	// 농협 사용자 여부 
    	
    	req.setAttribute("amtList", amtList);
    	
    	
        return "/nhepro/CTPI/CTPI0010";
    }
    
    /**
	 * 화면명 : 
	 * 처리내용 : 
	 * 경로 :  > > 
	 */
    @RequestMapping(value="/CTPI0010/doBuy")
    public String CTPI0010_doBuy(EverHttpRequest req) throws Exception {
    	
    	// DB에서 읽어오는 방식 
    	Map<String, Object> tpayInfo = ctpi0010_Service.ctpi0010_doSearchTpayInfo();
    	String moid = (String) tpayInfo.get("moid");
    	String mid = (String)  tpayInfo.get("mid");
    	
    	String merchantKey = (String) tpayInfo.get("merchantKey");
    	req.setAttribute("mid",  mid);
    	req.setAttribute("merchantKey",merchantKey);
    	req.setAttribute("moid", moid);
    	req.setAttribute("payActionUrl", tpayInfo.get("payActionUrl"));
    	req.setAttribute("payResultUrl", tpayInfo.get("payResultUrl"));
    	req.setAttribute("domain", PropertiesManager.getString("eversrm.tpay.domain"));
    	
    	System.out.println("tpayInfo After: " + tpayInfo.toString());
    	
    	// 가비지 데이터 삭제 (이전 미완결 처리 건)
    	Map<String, String> params = req.getParamDataMap();
    	ctpi0010_Service.ctpi0010_doDeleteTmpPoint(params);
    	
    	// 임시 테이블에 추가
    	params.put("moid", moid);
    	params.put("merchantKey", merchantKey);
    	ctpi0010_Service.ctpi0010_doInsertTmpPoint(params);
    	
    	return "/externalSW/Tpay/tpayRequest";
    }
    
    /**
	 * 화면명 : 
	 * 처리내용 : 
	 * 경로 :  > > 
	 */
    @RequestMapping(value="/CTPI0010/doBuy2")
    public String CTPI0010_doBuy2(EverHttpRequest req) throws Exception {
    	
    	System.out.println("doBuy2 start: " + req.getParamDataMap().toString());    	
    	
    	// DB에서 읽어오는 방식 
    	Map<String, Object> tpayInfo = ctpi0010_Service.ctpi0010_doSearchTpayInfo2();
    	String moid = (String) tpayInfo.get("moid");
    	String mid = (String)  tpayInfo.get("mid");
    	
    	String merchantKey = (String) tpayInfo.get("merchantKey");
    	req.setAttribute("mid",  mid);
    	req.setAttribute("merchantKey",merchantKey);
    	req.setAttribute("moid", moid);
    	req.setAttribute("payActionUrl", tpayInfo.get("payActionUrl"));
    	req.setAttribute("payResultUrl", tpayInfo.get("payResultUrl"));
    	req.setAttribute("domain", PropertiesManager.getString("eversrm.tpay.domain"));
    	
    	
    	// 가비지 데이터 삭제 (이전 미완결 처리 건)
    	Map<String, String> params = req.getParamDataMap();
    	ctpi0010_Service.ctpi0010_doDeleteTmpPoint(params);
    	
    	DataEncrypt sha256Enc 	= new DataEncrypt();
    	String ediDate 			= getyyyyMMddHHmmss();	
    	String price 				= (String)req.getParameter("total"); 				// 결제 금액
    	String hashString 		= sha256Enc.encrypt(ediDate + mid + price + merchantKey);    	
    	req.setAttribute("ediDate",  ediDate);
    	req.setAttribute("hashString",  hashString);    	
    	
    	// 임시 테이블에 추가
    	params.put("moid", moid);
    	params.put("merchantKey", merchantKey);
    	ctpi0010_Service.ctpi0010_doInsertTmpPoint(params);
    	
    	System.out.println("doBuy2 end ");    	    	
    	
    	return "/externalSW/Tpay/tpayRequest2";
    }    

    @RequestMapping(value="/CTPI0010/tpayResult")
    public String CTPI0010_TPayResult(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	String resultCd = (req.getParameter("resultCd") == null) ? "" : req.getParameter("resultCd");
    	String resultMsg = (req.getParameter("resultMsg") == null) ? "" : req.getParameter("resultMsg");
    	Map<String, String> params = req.getParamDataMap();
    	
    	try {
	    	
    		// params 깊은복사 - params를 파라미터에 넣었더니 쿼리 수행 후 값이 의도치않게 변경됨...
    		Map<String, String> params2 = new HashMap<>();
    		params2.putAll(params);
    		Map<String, Object> decValue = ctpi0010_Service.ctpi0010_getDecValue(params2);

    		// 들어온 moid, amt가 복호화된 값과 일치한지 비교 
    		boolean isSameAmtMoid = (boolean) decValue.get("isSameAmtMoid");
    		
    		//결제성공일때
    		System.out.println("req.toString()" + req.getParamDataMap().toString());
	    	boolean isBuySuccess = resultCd.equals("3001") || resultCd.equals("4000");
	    	
	    	if(isSameAmtMoid && isBuySuccess) {
	    		
	    		// value url decode 처리
	    		params = getUrlDecodedValueMap(params);
	    		
	    		params.put("amt", decValue.get("decAmt").toString());
	    		// 포인트 추가 후 기존 포인트와 합산
	    		ctpi0010_Service.ctpi0010_doInsertPoint(params);
	    		ctpi0010_Service.ctpi0010_doUpdatePoint(params);
	    		
	    		req.setAttribute("tpayMsg", "결제 성공!");
	    	}else {
	    		// 에러메시지 
	    		req.setAttribute("tpayMsg", resultMsg);
	    	}
    	} catch (Exception e) {
			// TODO: handle exception
    		// 에러메시지
			logger.error(e.getMessage());
			req.setAttribute("tpayMsg", "결제 실패 : " + e.getMessage());
		} finally {
			ctpi0010_Service.ctpi0010_doDeleteTmpPoint(params);
		}
    	
    	return "/externalSW/Tpay/tpayResult";
    }
    
    
    @RequestMapping(value="/CTPI0010/tpayResult2")
    public String CTPI0010_TPayResult2(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	
    	System.out.println("npay 1step result: " + req.getParamDataMap().toString());    	    	
    	
    	String authResultCode 	= (String)req.getParameter("AuthResultCode"); 	// 인증결과 : 0000(성공)
    	String authResultMsg 	= (String)req.getParameter("AuthResultMsg"); 	// 인증결과 메시지
    	String nextAppURL 		= (String)req.getParameter("NextAppURL"); 		// 승인 요청 URL
    	String txTid 			= (String)req.getParameter("TxTid"); 			// 거래 ID
    	String authToken 		= (String)req.getParameter("AuthToken"); 		// 인증 TOKEN
    	String payMethod 		= (String)req.getParameter("PayMethod"); 		// 결제수단
    	String mid 				= (String)req.getParameter("MID"); 				// 상점 아이디
    	String moid 			= (String)req.getParameter("Moid"); 			// 상점 주문번호
    	String amt 				= (String)req.getParameter("Amt"); 				// 결제 금액
    	String reqReserved 		= (String)req.getParameter("ReqReserved"); 		// 상점 예약필드
    	String netCancelURL 	= (String)req.getParameter("NetCancelURL"); 	// 망취소 요청 URL    	
    	String authSignature    = (String)req.getParameter("Signature");		// Nicepay에서 내려준 응답값의 무결성 검증 Data
    	
    	
    	
    	Map<String, String> params = req.getParamDataMap();
    	
    	try {    	
    	    
    		//위변조 검증
    		Map<String, String> params2 = new HashMap<>();
    		params2.putAll(params);
    		Map<String, Object> decValue = ctpi0010_Service.ctpi0010_getDecValue2(params2);    		
    		
    		boolean isSameAmtMoid = (boolean) decValue.get("isSameAmtMoid");
        	System.out.println("npay 1step isSameAmtMoid: " + isSameAmtMoid);
        	
    		/*
    		****************************************************************************************
    		* <승인 결과 파라미터 정의>
    		****************************************************************************************
    		*/
    		String ResultCode 	= ""; String ResultMsg 	= ""; String PayMethod 	= "";
    		String GoodsName 	= ""; String Amt 		= ""; String TID 		= ""; 
    		String Signature = ""; String paySignature = "";    		

    		
    		/*
    		****************************************************************************************
    		* <인증 결과 성공시 승인 진행>
    		****************************************************************************************
    		*/
    		String resultJsonStr = "";
    		if(authResultCode.equals("0000") && isSameAmtMoid ){
    			
    			String ediDate			= (String)decValue.get("ediDate");
    			String signData 		= (String)decValue.get("signData");    			
    			
    			/*
    			****************************************************************************************
    			* <승인 요청>
    			* 승인에 필요한 데이터 생성 후 server to server 통신을 통해 승인 처리 합니다.
    			****************************************************************************************
    			*/
    			
    			    			
    			
    			StringBuffer requestData = new StringBuffer();

    			requestData.append("TID=").append(txTid).append("&");
    			requestData.append("AuthToken=").append(authToken).append("&");
    			requestData.append("MID=").append(mid).append("&");
    			requestData.append("Amt=").append(amt).append("&");
    			requestData.append("EdiDate=").append(ediDate).append("&");
    			requestData.append("CharSet=").append("utf-8").append("&"); 
    			requestData.append("SignData=").append(signData);

    			
    			System.out.println("npay 2step before: " + requestData.toString());    	    
    			
    			//nextAppURL = "http://webapi.nicepay.co.kr/webapi/pay_process.jsp";    			
    			System.out.println("nextAppURL: " + nextAppURL);    	    	    			    			
    			
    			resultJsonStr = connectToServer(requestData.toString(), nextAppURL);
    			
    			System.out.println("npay 2step after: " + resultJsonStr.toString());    	    	    			

    			HashMap resultData = new HashMap();
    			boolean paySuccess = false;    			    			
    			if("9999".equals(resultJsonStr)){
        			System.out.println("npay 2step fail start");    				    				
    				/*
    				*************************************************************************************
    				* <망취소 요청>
    				* 승인 통신중에 Exception 발생시 망취소 처리를 권고합니다.
    				*************************************************************************************
    				*/
    				StringBuffer netCancelData = new StringBuffer();
    				requestData.append("&").append("NetCancel=").append("1");
    				
        			System.out.println("npay 2step fail before: " + requestData.toString());    	    	    			
        			
    				String cancelResultJsonStr = connectToServer(requestData.toString(), netCancelURL);
    				
        			System.out.println("npay 2step fail after: " + cancelResultJsonStr.toString());    	    	    			    				
    				
    				HashMap cancelResultData = jsonStringToHashMap(cancelResultJsonStr);
    				ResultCode = (String)cancelResultData.get("ResultCode");
    				ResultMsg = (String)cancelResultData.get("ResultMsg");
    				/*Signature = (String)cancelResultData.get("Signature");
    				String CancelAmt = (String)cancelResultData.get("CancelAmt");
    				paySignature = sha256Enc.encrypt(TID + mid + CancelAmt + merchantKey);*/
    				
        			System.out.println("npay 2step fail: " + resultJsonStr.toString());    				
    				

    			}else{
        			System.out.println("npay 2step sucess start");    				    				    				
        			
    				resultData = jsonStringToHashMap(resultJsonStr);
    				ResultCode 	= (String)resultData.get("ResultCode");	// 결과코드 (정상 결과코드:3001)
    				ResultMsg 	= (String)resultData.get("ResultMsg");	// 결과메시지
    				PayMethod 	= (String)resultData.get("PayMethod");	// 결제수단
    				GoodsName   = (String)resultData.get("GoodsName");	// 상품명
    				Amt       	= (String)resultData.get("Amt");		// 결제 금액
    				TID       	= (String)resultData.get("TID");		// 거래번호
    				// Signature : Nicepay에서 내려준 응답값의 무결성 검증 Data
    				// 가맹점에서 무결성을 검증하는 로직을 구현하여야 합니다.
    				Signature = (String)resultData.get("Signature");
    				
    				String merchantKey = (String)decValue.get("merchantKey");
    		    	DataEncrypt sha256Enc 	= new DataEncrypt();
    				paySignature = sha256Enc.encrypt(TID + mid + Amt + merchantKey);
    				
        			System.out.println("Signature: " + Signature);    				    				
        			System.out.println("paySignature: " + paySignature);    				    				        		
    				
    				/*
    				*************************************************************************************
    				* <결제 성공 여부 확인>
    				*************************************************************************************
    				*/
    				if(PayMethod != null && Signature.equals(paySignature)){
    					if(PayMethod.equals("CARD")){
    						if(ResultCode.equals("3001")) paySuccess = true; // 신용카드(정상 결과코드:3001)       	
    					}else if(PayMethod.equals("BANK")){
    						if(ResultCode.equals("4000")) paySuccess = true; // 계좌이체(정상 결과코드:4000)	
    					}else if(PayMethod.equals("CELLPHONE")){
    						if(ResultCode.equals("A000")) paySuccess = true; // 휴대폰(정상 결과코드:A000)	
    					}else if(PayMethod.equals("VBANK")){
    						if(ResultCode.equals("4100")) paySuccess = true; // 가상계좌(정상 결과코드:4100)
    					}else if(PayMethod.equals("SSG_BANK")){
    						if(ResultCode.equals("0000")) paySuccess = true; // SSG은행계좌(정상 결과코드:0000)
    					}else if(PayMethod.equals("CMS_BANK")){
    						if(ResultCode.equals("0000")) paySuccess = true; // 계좌간편결제(정상 결과코드:0000)
    					}
    				}
    			}    	
    			
    			if(paySuccess) {
        			System.out.println("npay 2step sucess db");
    	    		params.put("buyerName", (String)resultData.get("BuyerName"));      
    	    		params.put("buyerEmail", (String)resultData.get("BuyerEmail"));      
    	    		params.put("buyerTel", (String)resultData.get("BuyerTel"));      
    	    		params.put("goodsName", (String)resultData.get("GoodsName"));      
    	    		params.put("amt", amt);
    	    		params.put("authCode", (String)resultData.get("AuthCode"));    	
    	    		params.put("tid", TID);    	    	    		
    	    		params.put("mid", (String)resultData.get("MID"));    	    	    		
    	    		
    	    		// 포인트 추가 후 기존 포인트와 합산
    	    		ctpi0010_Service.ctpi0010_doInsertPoint(params);
    	    		ctpi0010_Service.ctpi0010_doUpdatePoint(params);
    	    		
    	    		req.setAttribute("tpayMsg", "결제 성공!");
    	    	}else {
        			System.out.println("npay 2step sucess error");    	    		
    	    		// 에러메시지 
    	    		req.setAttribute("tpayMsg", "결재처리중 오류, 관리자 문의 바람..");
    	    	}
    			
    			
    		}
    	
        	System.out.println("tpayResult2 end ");    	    	    		
    	
    	} catch (Exception e) {
			// TODO: handle exception
    		// 에러메시지
			logger.error(e.getMessage());
			req.setAttribute("npayMsg", "결제 실패 : " + e.getMessage());
		} finally {
			System.out.println("npay 2step final db");			
			ctpi0010_Service.ctpi0010_doDeleteTmpPoint(params);
		}
    	
    	return "/externalSW/Tpay/tpayResult2";
    	

    }    
	
    
	/**
	 * 화면명 : 
	 * 처리내용 : 
	 * 경로 :  > > 
	 */
    @RequestMapping(value="/CTPR0020/view")
    public String CTPR0020(EverHttpRequest req) throws Exception {
    	req.setAttribute("DATE_FROM", EverDate.addDateMonth(EverDate.getDate(), -1));
		req.setAttribute("DATE_TO", EverDate.getDate());
//    	List<Map<String, Object>> list = ctpi0010_Service.ctpi0020_doSearch(req.getParamDataMap());
//    	req.setAttribute("list", list);
		List<Map<String, Object>> userInfo = ctpi0010_Service.ctpu0040_getUserInfo();
    	req.setAttribute("CORP_NUM", userInfo.get(0).get("CORP_NUM"));
    	req.setAttribute("AMOUNT", userInfo.get(0).get("AMOUNT"));
        return "/nhepro/CTPI/CTPR0020";
    }
    
   	/**
   	 * 화면명 : 
   	 * 처리내용 : 
   	 * 경로 :  > > 
   	 */
       @RequestMapping(value="/CTPR0020/CTPR0020_doSearch")
       public void CTPR0020_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
		    Map<String, String> formData = req.getFormData();
		    List<Map<String, Object>> list = ctpi0010_Service.ctpi0020_doSearch(formData);
	   		resp.setGridObject("grid", list );
       }
    
    
    public Map<String, String> getUrlDecodedValueMap(Map<String, String> param) throws UnsupportedEncodingException{
    	for( String key : param.keySet() ) {
    		String value = param.get(key); 
    		param.put(key, URLDecoder.decode(value, "UTF-8"));
    	}
    	return param;
    }
    
    /**
  	 * 화면명 : 이용권 대체 
  	 * 처리내용 : 
  	 * 경로 :  > > 
  	 */
      @RequestMapping(value="/CTPI0030/view")
      public String CTPI0030(EverHttpRequest req) throws Exception {
		 Map<String, Object> userInfo = ctpi0010_Service.getUserCompanyInfo();
		 req.setAttribute("CORP_NO", userInfo.get("CORP_NO"));
		 req.setAttribute("RQS_BRC", userInfo.get("RQS_BRC"));
		 req.setAttribute("ST_DT", EverDate.addDateMonth(EverDate.getDate(), -1));
		 req.setAttribute("ED_DT", EverDate.getDate());
		 return "/nhepro/CTPI/CTPR0070";
      }
    
    
    @RequestMapping(value="/CTPU0040/view")
    public String CTPU0040(EverHttpRequest req) throws Exception {
    	List<Map<String, Object>> userInfo = ctpi0010_Service.ctpu0040_getUserInfo();
    	req.setAttribute("CORP_NUM", userInfo.get(0).get("CORP_NUM"));
    	req.setAttribute("AMOUNT", userInfo.get(0).get("AMOUNT"));
        return "/nhepro/CTPI/CTPU0040";
    }
    
    @RequestMapping(value="/CTPU0040/doRefund")
    public void CTPU0040_doRefund(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	Map<String, String> params = req.getFormData();
    	List<Map<String, Object>> userInfo = ctpi0010_Service.ctpu0040_getUserInfo();
    	// 환불 가능 금액
    	int refundableAmt =  Integer.parseInt( String.valueOf(userInfo.get(0).get("AMOUNT") ) );
    	// 환불 입력한 금액
    	int inputAmt = Integer.parseInt( params.get("RFDM_PNT") );
    	
    	boolean canRefund = refundableAmt >= inputAmt;
    	
    	if(canRefund) {
	    	try {
		    	//이용권 환불신청 등록
		    	ctpi0010_Service.CTPU0040_insertRefundRequest(params);
		    	ctpi0010_Service.CTPU0040_updateRefundPoint(params);
		    	resp.setResponseMessage("환불 신청을 성공적으로 완료하였습니다");
	    	}catch(Exception e) {
	    		resp.setResponseMessage("환불 신청 실패 : " + e.toString());
	    	}
    	}else {
    		resp.setResponseMessage("환불 신청 실패 : 입력한 금액이 환불 가능 금액보다  큽니다 ");
    	}
    }
    
    
    /**
	 * 화면명 : 
	 * 처리내용 : 
	 * 경로 :  > > 
	 */
    @RequestMapping(value="/CTPR0050/view")
    public String CTPR0050(EverHttpRequest req) throws Exception {
    	req.setAttribute("DATE_FROM", EverDate.addDateMonth(EverDate.getDate(), -1));
		req.setAttribute("DATE_TO", EverDate.getDate());
        return "/nhepro/CTPI/CTPR0050";
    }
    
    
    @RequestMapping(value="/CTPR0050/CTPR0050_doSearch")
    public void CTPR0050_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
	    	req.setAttribute("DATE_FROM", EverDate.addDateMonth(EverDate.getDate(), -1));
			req.setAttribute("DATE_TO", EverDate.getDate());
		    Map<String, String> formData = req.getFormData();
		    List<Map<String, Object>> list = ctpi0010_Service.ctpr0050_doSearch(formData);
	   		resp.setGridObject("grid", list );
    }
    
    /**
   	 * 화면명 : 
   	 * 처리내용 : 
   	 * 경로 :  > > 
   	 */
       @RequestMapping(value="/CTPR0060/view")
       public String CTPR0060(EverHttpRequest req) throws Exception {
		   req.setAttribute("CORP_NO", ctpi0010_Service.getUserCompanyInfo().get("CORP_NO"));
	       req.setAttribute("ST_DT", EverDate.addDateMonth(EverDate.getDate(), -1));
	       req.setAttribute("ED_DT", EverDate.getDate());
           return "/nhepro/CTPI/CTPR0060";
       }
       
       @RequestMapping(value="/CTPR0060/CTPR0060_doSearch")
       public void CTPR0060_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
   		    Map<String, String> formData = req.getFormData();
   		    List<Map<String, Object>> list = ctpi0010_Service.ctpr0060_doSearch(formData);
   	   		resp.setGridObject("grid", list );
       }
       
       /**
      	 * 화면명 : 청구내역조회
      	 * 처리내용 : 
      	 * 경로 :  > > 
      	 */
          @RequestMapping(value="/CTPR0070/view")
          public String CTPR0070(EverHttpRequest req) throws Exception {
			 Map<String, Object> userInfo = ctpi0010_Service.getUserCompanyInfo();
			 req.setAttribute("CORP_NO", userInfo.get("CORP_NO"));
			 req.setAttribute("RQS_BRC", userInfo.get("RQS_BRC"));
			 req.setAttribute("ST_DT", EverDate.addDateMonth(EverDate.getDate(), -1));
			 req.setAttribute("ED_DT", EverDate.getDate());
			 return "/nhepro/CTPI/CTPR0070";
          }
          
          @RequestMapping(value="/CTPR0070/CTPR0070_doSearch")
          public void CTPR0070_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
      		    Map<String, String> formData = req.getFormData();
      		    List<Map<String, Object>> list = ctpi0010_Service.ctpr0070_doSearch(formData);
      	   		resp.setGridObject("grid", list );
          }
         
          
          public final synchronized String getyyyyMMddHHmmss(){
        		SimpleDateFormat yyyyMMddHHmmss = new SimpleDateFormat("yyyyMMddHHmmss");
        		return yyyyMMddHHmmss.format(new Date());
        	}
        	// SHA-256 형식으로 암호화
        	public class DataEncrypt{
        		MessageDigest md;
        		String strSRCData = "";
        		String strENCData = "";
        		String strOUTData = "";
        		
        		public DataEncrypt(){ }
        		public String encrypt(String strData){
        			String passACL = null;
        			MessageDigest md = null;
        			try{
        				md = MessageDigest.getInstance("SHA-256");
        				md.reset();
        				md.update(strData.getBytes());
        				byte[] raw = md.digest();
        				passACL = encodeHex(raw);
        			}catch(Exception e){
        				System.out.print("암호화 에러" + e.toString());
        			}
        			return passACL;
        		}
        		
        		public String encodeHex(byte [] b){
        			char [] c = Hex.encodeHex(b);
        			return new String(c);
        		}
        	}          

        	public String connectToServer(String data, String reqUrl) throws Exception{
        		HttpURLConnection conn 		= null;
        		BufferedReader resultReader = null;
        		PrintWriter pw 				= null;
        		URL url 					= null;
        		
        		int statusCode = 0;
        		StringBuffer recvBuffer = new StringBuffer();
        		try{
        			url = new URL(reqUrl);

        			//SSL 인증 무시
        			TrustManager[] trustAllCerts = new TrustManager[] {
        					new X509TrustManager() {
        						public java.security.cert.X509Certificate[] getAcceptedIssuers(){
                					return null;
                				}
								@Override
								public void checkClientTrusted(java.security.cert.X509Certificate[] certs, String authType)
										throws CertificateException {
									// TODO Auto-generated method stub
									
								}
								@Override
								public void checkServerTrusted(java.security.cert.X509Certificate[] certs, String authType)
										throws CertificateException {
									// TODO Auto-generated method stub
									
								}        				        						
        					}
        						
        			};
        			
        			SSLContext sc = SSLContext.getInstance("SSL");
        			sc.init(null, trustAllCerts, new java.security.SecureRandom());
        			HttpsURLConnection.setDefaultSSLSocketFactory(sc.getSocketFactory());
        			
        			HttpsURLConnection.setDefaultHostnameVerifier(
        					new HostnameVerifier() {
        						public boolean verify(String string, SSLSession ssls) {
        							return true;
        						}
        					}
        			);
        			
        			conn = (HttpURLConnection) url.openConnection();
        			conn.setRequestMethod("POST");
        			conn.setConnectTimeout(15000);
        			conn.setReadTimeout(25000);
        			conn.setDoOutput(true);
        			
        			pw = new PrintWriter(conn.getOutputStream());
        			pw.write(data);
        			pw.flush();
        			
        			statusCode = conn.getResponseCode();
        			resultReader = new BufferedReader(new InputStreamReader(conn.getInputStream(), "utf-8"));
        			for(String temp; (temp = resultReader.readLine()) != null;){
        				recvBuffer.append(temp).append("\n");
        			}
        			
        			if(!(statusCode == HttpURLConnection.HTTP_OK)){
        				throw new Exception();
        			}
        			
        			return recvBuffer.toString().trim();
        		}catch (Exception e){
        			System.out.println("connectToServer e.getMessage() : "+e.getMessage());        			
        			return "9999";
        		}finally{
        			recvBuffer.setLength(0);
        			
        			try{
        				if(resultReader != null){
        					resultReader.close();
        				}
        			}catch(Exception ex){
        				resultReader = null;
        			}
        			
        			try{
        				if(pw != null) {
        					pw.close();
        				}
        			}catch(Exception ex){
        				pw = null;
        			}
        			
        			try{
        				if(conn != null) {
        					conn.disconnect();
        				}
        			}catch(Exception ex){
        				conn = null;
        			}
        		}
        	}        	

        	
        	//JSON String -> HashMap 변환
        	private static HashMap jsonStringToHashMap(String str) throws Exception{
        		HashMap dataMap = new HashMap();
        		JSONParser parser = new JSONParser();
        		try{
        			Object obj = parser.parse(str);
        			JSONObject jsonObject = (JSONObject)obj;

        			Iterator<String> keyStr = jsonObject.keySet().iterator();
        			while(keyStr.hasNext()){
        				String key = keyStr.next();
        				Object value = jsonObject.get(key);
        				
        				dataMap.put(key, value);
        			}
        		}catch(Exception e){
        			
        		}
        		return dataMap;
        	}        	
}

