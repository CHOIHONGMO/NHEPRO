package com.st_ones.nhepro.CTPI.service;

import com.st_ones.nhepro.CTPI.CTPI0010_Mapper;

import kr.co.tpay.webtx.Encryptor;

import com.itextpdf.text.pdf.PdfStructTreeController.returnType;
import com.st_ones.common.docNum.service.DocNumService;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;

import org.apache.commons.codec.binary.Hex;
import org.apache.commons.lang.StringEscapeUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.net.URLDecoder;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
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
 * @File Name : CTPI0010_Service.java
 * @date 2020.06.19
 * @version 1.0
 * @see
 */
@Service(value = "CTPI0010_Service")
public class CTPI0010_Service {
    /**
     * The CTPI0010_Mapper.
     */
    @Autowired
    CTPI0010_Mapper ctpi0010_Mapper;
    /**
     * The Msg.
     */
    @Autowired MessageService msg;
    /**
     * The Doc num service.
     */
    @Autowired DocNumService docNumService;
    
    @Autowired Environment environment;

	/**
	 * 화면명 : 
	 * 처리내용 : 
	 * 경로 :  >  > 
	 */
    public List<Map<String,Object>> ctpi0010_doSearch(Map<String, String> param) throws Exception{
        return ctpi0010_Mapper.ctpi0010_doSearch(param);
    }

    /**
	 * 화면명 : 
	 * 처리내용 : 
	 * 경로 :  >  > 
	 */
	public void ctpi0010_doInsertPoint(Map<String, String> reqParamrMap) {
		Map<String, Object> userCompanyInfo = getUserCompanyInfo();
		// 사업자 번호 
		String corpNo = (String)userCompanyInfo.get("CORP_NO");
		reqParamrMap.put("CORP_NO", corpNo);
		
		System.out.println("reqParamMap : "+ reqParamrMap.toString());
		// TODO Auto-generated method stub
		ctpi0010_Mapper.ctpi0010_doInsertPoint(reqParamrMap);
	}

	public void ctpi0010_doUpdatePoint(Map<String, String> reqParamrMap) {
		Map<String, Object> userCompanyInfo = getUserCompanyInfo();
		// 사업자 번호 
		String corpNo = (String)userCompanyInfo.get("CORP_NO");
		reqParamrMap.put("CORP_NO", corpNo);
		ctpi0010_Mapper.ctpi0010_doUpdatePoint(reqParamrMap);
	}

	public List<Map<String, Object>> ctpi0010_doSearchAmtList() {
		// TODO Auto-generated method stub
		return ctpi0010_Mapper.ctpi0010_doSearchAmtList();
	}

	public Map<String, Object> ctpi0010_doSearchTpayInfo() {
		
		//  개발/로컬 : test , 
		boolean isProduction = !PropertiesManager.getBoolean("eversrm.system.localserver") && !PropertiesManager.getBoolean("eversrm.system.developmentFlag");
		Map<String, Object> userCompanyInfo = getUserCompanyInfo();
		// mid - 농협 : 3m, 일반 : 2m,
		boolean isNHUser = (boolean) userCompanyInfo.get("isNHUser");
		
		
		Map<String, Boolean> param = new HashMap<>();
		param.put("isProduction", isProduction);
		param.put("isNHUser", isNHUser);
		
		List<Map<String, Object>> allList = ctpi0010_Mapper.ctpi0010_doSearchTpayInfo(param);
		Map<String, Object> infoList = selectOnlyNeed(allList, isProduction, isNHUser );
		
		
		// TODO Auto-generated method stub
		return infoList;
	}
	
	public Map<String, Object> ctpi0010_doSearchTpayInfo2() {
		
		//  개발/로컬 : test , 
		boolean isProduction = !PropertiesManager.getBoolean("eversrm.system.localserver") && !PropertiesManager.getBoolean("eversrm.system.developmentFlag");
		Map<String, Object> userCompanyInfo = getUserCompanyInfo();
		// mid - 농협 : 3m, 일반 : 2m,
		boolean isNHUser = (boolean) userCompanyInfo.get("isNHUser");
		
		
		Map<String, Boolean> param = new HashMap<>();
		param.put("isProduction", isProduction);
		param.put("isNHUser", isNHUser);
		
		List<Map<String, Object>> allList = ctpi0010_Mapper.ctpi0010_doSearchTpayInfo2(param);
		Map<String, Object> infoList = selectOnlyNeed(allList, isProduction, isNHUser );
		
		
		// TODO Auto-generated method stub
		return infoList;
	}	


	private Map<String, Object> selectOnlyNeed(List<Map<String, Object>> allList, boolean isProduction, boolean isNHUser) {
		Map<String, Object> resultTpayInfo = new HashMap<>();
		String moid = getPropertyValue("eversrm.tpay.moid");
		String payActionUrl = getPropertyValue("eversrm.tpay.payActionUrl");
		String payResultUrl = getPropertyValue("eversrm.tpay.payResultUrl");
		String nonghyup3m = getPropertyValue("eversrm.tpay.nonghyup3m");
		String nonghyup3m_merchantkey = getPropertyValue("eversrm.tpay.nonghyup3m_merchantkey");
		String nonghyup2m = getPropertyValue("eversrm.tpay.nonghyup2m");
		String nonghyup2m_merchantkey = getPropertyValue("eversrm.tpay.nonghyup2m_merchantkey");
		String mid = getPropertyValue("eversrm.tpay.mid");
		String merchantKey = getPropertyValue("eversrm.tpay.merchantKey");
		

		
		int size = allList.size();
		isProduction = true;
		if( isProduction ) { // 운영환경

			String[] prodSetting;
			if( isNHUser ){
				// 운영환경 , 농협사용자가 사용하는 key
				String[] temp = {moid, payActionUrl, payResultUrl, nonghyup3m, nonghyup3m_merchantkey };
				prodSetting = temp;
			}else{
				// 운영환경 , 비농협사용자가 사용하는 key
				String[] temp = {moid, payActionUrl, payResultUrl, nonghyup2m, nonghyup2m_merchantkey };
				prodSetting = temp;
			}
			
			
			for(int i = 0 ; i < size ; i ++) {
				Map<String, Object> allTpayInfo = allList.get(i);
				
				List<String> prodSetting2 = new ArrayList<>( Arrays.asList( prodSetting ) );
				
				// 값 읽어오기 
				String key = (String) allTpayInfo.get("SIMP_CNM");
				boolean isProdTpayInfo =  prodSetting2.contains(key);
				if(isProdTpayInfo) {
					
					boolean isMid = key.equals("nonghyup2m") || key.equals("nonghyup3m");
					if(isMid) {
						key = "mid"; // key값 변환 
					}
					boolean isMerchantKey = key.equals("nonghyup2m_merchantkey") || key.equals("nonghyup3m_merchantkey");
					if(isMerchantKey) {
						key = "merchantKey"; // key값 변환 
					}
					resultTpayInfo.put(key, allTpayInfo.get("AMN_HDNG_EXPL1" ));
				}
			}
			
		}else {  // 개발환경 
			for(int i = 0 ; i < size ; i ++) {
				Map<String, Object> allTpayInfo = allList.get(i);
				
				// 개발환경 , 모든 사용자가 사용하는 key 
				String[] testSetting = {moid, payActionUrl, payResultUrl, mid, merchantKey };
				List<String> testSetting2 = new ArrayList<>( Arrays.asList( testSetting) );
				String key = (String) allTpayInfo.get("SIMP_CNM");
				boolean isTestTpayInfo =  testSetting2.contains(key);
				if(isTestTpayInfo) {
					resultTpayInfo.put(key, allTpayInfo.get("AMN_HDNG_EXPL1" ));
				}
			}
			
		}
		System.out.println("resultTpayInfo" + resultTpayInfo.toString());
		
		return resultTpayInfo;
	}

	
	public Map<String, Object> getUserCompanyInfo() {
		Map<String, Object> resultMap = new HashMap<>();
		boolean isNHUser = false;
		List<Map<String, Object>> result = ctpi0010_Mapper.ctpi0010_doSearchCompanyType();
		String companyCd = (String) result.get(0).get("NC_COMP_DS_C"); // 회사 구분코드 ( 01: 일반회사 코드)
		String corpNo = (String) result.get(0).get("CORP_NO"); // 사업자번호
		
		isNHUser = ! companyCd.isEmpty() && ! companyCd.equals("01"); // 01 : 일반회사 코드 
		
		
		resultMap.put("isNHUser", isNHUser);
		resultMap.put("CORP_NO", corpNo);
		resultMap.put("RQS_BRC", (String) result.get(0).get("RQS_BRC"));
		
		return resultMap;
	}
	
	
	
	private String getPropertyValue(String key) {
		return PropertiesManager.getString(key);
		
	}

	public void ctpi0010_doInsertTmpPoint(Map<String, String> paramDataMap) {
		ctpi0010_Mapper.ctpi0010_doInsertTmptPoint(paramDataMap);
		
	}

	public void ctpi0010_doSearchTmpData(Map<String, String> paramDataMap) {
		// TODO Auto-generated method stub
		ctpi0010_Mapper.ctpi0010_doSearchTmpData(paramDataMap);
	}

	public void ctpi0010_doDeleteTmpPoint(Map<String, String> paramDataMap) {
		// TODO Auto-generated method stub
		ctpi0010_Mapper.ctpi0010_doDeleteTmpPoint(paramDataMap);
	}

	public List<Map<String, Object>> ctpi0020_doSearch(Map<String, String> reqParamrMap) {
		
		Map<String, Object> userCompanyInfo = getUserCompanyInfo();
		// 사업자 번호 
		String corpNo = (String)userCompanyInfo.get("CORP_NO");
		reqParamrMap.put("CORP_NO", corpNo);
		return ctpi0010_Mapper.ctpi0020_doSearch(reqParamrMap);
	}

	// 복호화된 amt, moid가 복호화 이전 데이터와 같은지 확인
	public Map<String,Object> ctpi0010_getDecValue(Map<String, String> params) throws Exception {
		
		// get original value
		Map<String, Object> tpayInfo = ctpi0010_Mapper.ctpi0010_getDecValue(params);
    	String amtPrev = tpayInfo.get("DCZ_AM").toString();
    	String moidPrev = tpayInfo.get("MOID").toString();
    	String merchantKey = tpayInfo.get("MERCHANT_KEY").toString();
    	
    	String ediDate = params.get("ediDate");
    	String amt = params.get("amt");
    	String moid = params.get("moid");
    	// 복호화 
    	merchantKey = StringEscapeUtils.unescapeHtml(merchantKey); // DB에 +가  &#43;로 치환되어서 들어감 -> +로 다시 치환
    	amt =  URLDecoder.decode(amt, "UTF-8"); // %2F, %2B, %3D.. -> UTF-8
    	moid = URLDecoder.decode(moid, "UTF-8");
    	System.out.println("=====amt" + amt + "moid" + moid);
    	Encryptor encryptor = new Encryptor(merchantKey, ediDate);
    	String decAmt = encryptor.decData(amt);
    	String decMoid = encryptor.decData(moid);
    	
    	Map<String, Object> result = new HashMap<>();
    	result.put("decAmt", decAmt);
    	result.put("decMoid", decMoid);
    	System.out.println("=====amtPrev" + amtPrev + "moidPrev" + moidPrev);
    	System.out.println("=====decAmt" + decAmt + "decMoid" + decMoid);
    	// 복호화된 값이 original 값과 같은지 여부
    	result.put("isSameAmtMoid", amtPrev.equals(decAmt) && moidPrev.equals(decMoid));
    	return result;
     	
    	 
	}
	
	// 위변조 여부 확인
	public Map<String,Object> ctpi0010_getDecValue2(Map<String, String> params) throws Exception {
		
		// get original value
		Map<String, Object> tpayInfo = ctpi0010_Mapper.ctpi0010_getDecValue(params);
    	String amtPrev = tpayInfo.get("DCZ_AM").toString();		
    	String merchantKey = tpayInfo.get("MERCHANT_KEY").toString();
    	String authToken = params.get("AuthToken");
    	String mid = params.get("MID");
    	
    	String authSignature = params.get("Signature");    	
    	
    	DataEncrypt sha256Enc 	= new DataEncrypt();
    	String authComparisonSignature = sha256Enc.encrypt(authToken + mid + amtPrev + merchantKey);
    	
    	
    	String ediDate			= getyyyyMMddHHmmss();
    	String signData 		= sha256Enc.encrypt(authToken + mid + amtPrev + ediDate + merchantKey);
    	
    	// 복호화된 값이 original 값과 같은지 여부
    	Map<String, Object> result = new HashMap<>();
    	result.put("merchantKey", merchantKey);    	
    	result.put("ediDate", ediDate);
    	result.put("signData", signData);    	
    	result.put("isSameAmtMoid", authSignature.equals(authComparisonSignature));
    	return result;
     	
    	 
	}	

	public List<Map<String, Object>> ctpu0040_getUserInfo() {
		Map<String, Object> userCompanyInfo = getUserCompanyInfo();
		// 사업자 번호 
		Map<String, String> req = new HashMap<>();
		String corpNo = (String)userCompanyInfo.get("CORP_NO");
		req.put("CORP_NO", corpNo);
		return ctpi0010_Mapper.ctpu0040_getUserInfo(req);
	}

	public void CTPU0040_insertRefundRequest(Map<String, String> params) {
		Map<String, Object> userCompanyInfo = getUserCompanyInfo();
		// 사업자 번호 
		String corpNo = (String)userCompanyInfo.get("CORP_NO");
		params.put("CORP_NO", corpNo);
		ctpi0010_Mapper.CTPU0040_insertRefundRequest(params);
	}

	public void CTPU0040_updateRefundPoint(Map<String, String> params) {
		Map<String, Object> userCompanyInfo = getUserCompanyInfo();
		// 사업자 번호 
		String corpNo = (String)userCompanyInfo.get("CORP_NO");
		params.put("CORP_NO", corpNo);
		ctpi0010_Mapper.CTPU0040_updateRefundPoint(params);
	}

	public List<Map<String, Object>> ctpr0050_doSearch(Map<String, String> formData) {
		// TODO Auto-generated method stub
		Map<String, Object> userCompanyInfo = getUserCompanyInfo();
		// 사업자 번호 
		String corpNo = (String)userCompanyInfo.get("CORP_NO");
		formData.put("CORP_NO", corpNo);
		return ctpi0010_Mapper.ctpr0050_doSearch(formData);
	}

	public List<Map<String, Object>> ctpr0060_doSearch(Map<String, String> formData) {
		// TODO Auto-generated method stub
		List<Map<String, Object>> return_list   = null;
		String search_dsc = formData.get("SEARCH_DSC");
		
		if ("01".equals(search_dsc)) {
            // 구매
			return_list = ctpi0010_Mapper.CTPR0060R2(formData);
        } else if ("02".equals(search_dsc)) {
            // 사용
        	return_list = ctpi0010_Mapper.CTPR0060R3(formData);
        } else if ("03".equals(search_dsc)) {
            // 환불
        	return_list = ctpi0010_Mapper.CTPR0060R4(formData);
        } else {
            // 전체
        	return_list = ctpi0010_Mapper.CTPR0060R1(formData);
        }
		return return_list;
		
	}

	public List<Map<String, Object>> ctpr0070_doSearch(Map<String, String> formData) {
		// TODO Auto-generated method stub
		Map<String, Object> userCompanyInfo = getUserCompanyInfo();
		// 사업자 번호 
		String corpNo = (String)userCompanyInfo.get("CORP_NO");
		formData.put("CORP_NO", corpNo);
		return ctpi0010_Mapper.CTPR0070_doSearch(formData);
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
	
	
}
