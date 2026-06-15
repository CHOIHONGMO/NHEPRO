package com.st_ones.nhepro.IPRONET.service;

import com.st_ones.nhepro.IPRONET.IPRONET_Mapper;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.st_ones.common.docNum.service.DocNumService;
import com.st_ones.common.message.service.MessageService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
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
 * @File Name : IPRONET_Service.java
 * @date 2021.05.11
 * @version 1.0
 * @see
 */
@Service(value = "IPRONET_Service")
public class IPRONET_Service {
    /**
     * The IPRONET_Mapper.
     */
    @Autowired
    IPRONET_Mapper ipronet_Mapper;
    /**
     * The Msg.
     */
    @Autowired MessageService msg;
    /**
     * The Doc num service.
     */
    @Autowired DocNumService docNumService;

	/**
	 * 화면명 : 
	 * 처리내용 : 
	 * 경로 :  >  > 
	 */
    public String ipronet_getCount(Map<String, String> param) throws Exception{
    	

    	Map<String,String> returnMap = new HashMap<>();
    	Map<String,String> dataMap = new HashMap<>();
    	String returnStr ;
    	
    	try {
	    	// 잔여 결재견수
	    	String approvalCnt = ipronet_Mapper.getApprovalCount(param);
	
	    	// 유저에게 협력업체 관련 권한이 있을때만 
	    	List<Map<String, Object>> getAcceptCust = ipronet_Mapper.getAcceptCust(param);
	    	boolean hasAcceptCust = getAcceptCust != null && ! getAcceptCust.isEmpty();
	    	
	    	// 신규 협력업체 대기 건수
	    	String custCnt = "0" ;
	    	if( hasAcceptCust )
	    		custCnt = ipronet_Mapper.getCustCount(param); 
	    	
	    	dataMap.put("CNT0", approvalCnt);
	    	dataMap.put("CNT1", custCnt);
	    	ObjectMapper mapper = new ObjectMapper();
	    	String dataStr = mapper.writeValueAsString(dataMap);
	    	
	    	returnMap.put("code", "100");
	    	returnMap.put("data", dataStr);
//	    	returnMap.put("data", dataMap.toString());
	    	returnStr = mapper.writeValueAsString(returnMap);
	    	
	    	// { "code": "100", "data" : {"CNT0" : "1", "CNT1" : "2"} }
	    	
    	}catch(Exception e) {
    		e.printStackTrace();
    		dataMap.put("CNT0", "-");
	    	dataMap.put("CNT1", "-");
	    	ObjectMapper mapper = new ObjectMapper();
	    	String dataStr = mapper.writeValueAsString(dataMap);
	    	
    		returnMap.put("code", "200");
    		returnMap.put("data", dataStr);
    		System.out.println("Ipronet Exception : " + e.toString());
    		returnStr = mapper.writeValueAsString(returnMap);
    		
    	}
    	
    	return returnStr;
    }
    
	/**
	 * 화면명 : 
	 * 처리내용 : 
	 * 경로 :  >  > 
	 */
    public String ipronet_getCountJsonp(Map<String, String> param) throws Exception{
    	

    	Map<String,String> returnMap = new HashMap<>();
    	Map<String,String> dataMap = new HashMap<>();
    	String returnStr ;
    	String callback = param.get("callback");
    	
    	try {
	    	// 잔여 결재견수
	    	String approvalCnt = ipronet_Mapper.getApprovalCount(param);
	
	    	// 유저에게 협력업체 관련 권한이 있을때만 
	    	List<Map<String, Object>> getAcceptCust = ipronet_Mapper.getAcceptCust(param);
	    	boolean hasAcceptCust = getAcceptCust != null && ! getAcceptCust.isEmpty();
	    	
	    	// 신규 협력업체 대기 건수
	    	String custCnt = "0" ;
	    	if( hasAcceptCust )
	    		custCnt = ipronet_Mapper.getCustCount(param); 
	    	
	    	dataMap.put("CNT0", approvalCnt);
	    	dataMap.put("CNT1", custCnt);
	    	ObjectMapper mapper = new ObjectMapper();
	    	String dataStr = mapper.writeValueAsString(dataMap);
	    	
	    	returnMap.put("code", "100");
	    	returnMap.put("data", dataStr);

	    	returnStr = mapper.writeValueAsString(returnMap);
	    	
	    	returnStr = callback + "(" + returnStr + ")"; //jsonp 방식 
	    	
    	}catch(Exception e) {
    		e.printStackTrace();
    		dataMap.put("CNT0", "-");
	    	dataMap.put("CNT1", "-");
	    	ObjectMapper mapper = new ObjectMapper();
	    	String dataStr = mapper.writeValueAsString(dataMap);
	    	
    		returnMap.put("code", "200");
    		returnMap.put("data", dataStr);
    		System.out.println("Ipronet Exception : " + e.toString());
    		returnStr = mapper.writeValueAsString(returnMap);
    		
	    	returnStr = callback + "(" + returnStr + ")"; //jsonp 방식 
    		
    	}
    	
    	return returnStr;
    }    
}











