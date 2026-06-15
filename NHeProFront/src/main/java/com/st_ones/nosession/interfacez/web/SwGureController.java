package com.st_ones.nosession.interfacez.web;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.Map;

import javax.servlet.ServletOutputStream;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.st_ones.common.util.clazz.EverDate;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.nhepro.SCTR.service.SCTR0010_Service;
import com.st_ones.common.sms.service.EverSmsService;


@Controller
@RequestMapping(value = "/swic")
public class SwGureController extends BaseController {

	private static Logger logger = LoggerFactory.getLogger(SwGureController.class);

    @Autowired private SCTR0010_Service sctr0010_service;
    @Autowired private EverSmsService everSmsService;
    
    @RequestMapping("/recvSW")
    public void recvSW(EverHttpRequest request, EverHttpResponse response) throws Exception {
    	System.out.println("===================== HELLO!!!!!!!!! =====================");
    	System.out.println("===================== start =====================");
        
    	String jobRlt = "E";
        String startDate = EverDate.getTimeStampString();
        String msg = "";
        String contNum = "";
        String cont_numb_text = "";
        String responseResult = "";
	   	String responseName = "";
	   	String responseMessage = "";
	   	String ret = "";
	   	
    	try {
    		String name = null;
    		String value = null;
    		String type = "";
    		String respNO = "";
    		
    		Enumeration enumeration = request.getParameterNames();
    		System.out.println("===================== getParameterNames =>" + request.getParameterNames());
    		Hashtable hash = new Hashtable();
    		
    		while (enumeration.hasMoreElements()) {
    			name = (String) enumeration.nextElement();
    			value = request.getParameter(name);
    			System.out.println(name + "=" + value);
    			hash.put(name, value);
    		}
    		
    		// 수신한 보증서 정보 (NameValue 구조)
    		String inNameValue = (String)hash.get("inNameValue");
    		
    		System.out.println("===================== inNameValue =>" + inNameValue);
    		
    		HashMap resultMap = new HashMap();
    		String[] dataList = inNameValue.split("`&"); // `& 로 항목 구분
    		
    		String data = "";
    		
    		for (int i = 0 ; i < dataList.length ; i++) {
    			data = (String)dataList[i];
    			
    			System.out.println(data.substring(0, data.indexOf("`=")) + "=" + data.substring(data.indexOf("`=") + 2));
    			
    			resultMap.put(data.substring(0, data.indexOf("`=")), data.substring(data.indexOf("`=") + 2)); // Name`=Value 구분
    		}
    		
    		System.out.println("==== dataHash ===> " + resultMap);
    		
    		boolean ackMessage = true;
    		boolean sapSendMessage = false;

    	   	String result = "";
    	   	String seq    = "";
    		String head_mang_numb = "";
    		String bond_numb_text = "";
    		String head_mesg_type = "";
    		String head_mesg_name = "";
    		String resp_bond_begn_date = "";
    		String resp_bond_fnsh_date = "";
    		String resp_bond_penl_amnt = "";
    		String final_resp_send_yn  = "Y";
    	    	
    		String soapXml = (String)hash.get("ReceiveSignSoap"); // Sign Soap XML (전자서명된 SOAP)
    		String recvEncXml = (String)hash.get("ReceiveEncXML"); // 암호화된 ReceiveEncXML (보증서)
    		String recvXml = (String)hash.get("ReceiveXML"); // 복호화된 ReceiveXML (보증서)
    		
    		cont_numb_text = (String)resultMap.get("cont_numb_text");	// 계약서 번호
    		head_mang_numb = (String)resultMap.get("head_mang_numb");	// 문서관리 번호
    		bond_numb_text = (String)resultMap.get("bond_numb_text");	// 보증서 번호
    		head_mesg_type = (String)resultMap.get("head_mesg_type");
    		head_mesg_name = (String)resultMap.get("head_mesg_name");
    		resp_bond_begn_date	= (String)resultMap.get("bond_begn_date");
    		resp_bond_fnsh_date	= (String)resultMap.get("bond_fnsh_date");
    		resp_bond_penl_amnt	= (String)resultMap.get("bond_penl_amnt");
    		
    		System.out.println("==== soapXml ===> " + soapXml);
    		System.out.println("==== recvEncXml ===> " + recvEncXml);
    		System.out.println("==== recvXml ===> " + recvXml);
    		
    		String guar_req_num = cont_numb_text.substring(cont_numb_text.indexOf("GU"),cont_numb_text.indexOf("GU")+13);
    		contNum = cont_numb_text.substring(cont_numb_text.indexOf("GU"),cont_numb_text.indexOf("GU")+13);
    		
    		resultMap.put("GUAR_REQ_NUM", guar_req_num);
    		
    		if("CONGUA".equals(head_mesg_type)) {		// 계약보증서
    			resultMap.put("GUAR_TYPE", "CONT");
        	}
        	else if("PREGUA".equals(head_mesg_type)) { // 선급보증서
        		resultMap.put("GUAR_TYPE", "ADV");
        	}
        	else if("FLRGUA".equals(head_mesg_type)) { // 하자보증서
        		resultMap.put("GUAR_TYPE", "WARR");
        	}

    		Map<String, String> guarInfo = sctr0010_service.getGuarInfoCheck(resultMap);
    		//if( EverString.isNotEmpty(guarInfo.get("GUAR_REQ_NUM")) ) { // 임의 오류 테스트용 소스
    		if(guarInfo != null && guarInfo.size() > 0) {  // 정상 소스
    			
    			Map<String, String> guarNumInfo = sctr0010_service.getGuarNumInfoCheck(resultMap);
    			
    			if(guarNumInfo != null && guarNumInfo.size() > 0) {
    				System.out.println("이미 증권번호가 발행된 경우 ");
        			if("CONGUA".equals(head_mesg_type)) {		// 계약보증서
        				head_mesg_type = "RCONGUA";
            			//resultMap.put("head_mesg_type", "RCONGUA");
                	}
                	else if("PREGUA".equals(head_mesg_type)) { // 선급보증서
                		head_mesg_type = "RPREGUA";
                		//resultMap.put("head_mesg_type", "RPREGUA");
                	}
                	else if("FLRGUA".equals(head_mesg_type)) { // 하자보증서
                		head_mesg_type = "RFLRGUA";
                		//resultMap.put("head_mesg_type", "RFLRGUA");
                	}
        			
        			responseResult  = "SR";
        			responseName = "시스템거부";
        			responseMessage = "해당 계약 건 에 대해 이미 증권번호가 발행되었습니다.";
        			msg = "해당 계약 건 에 대해 이미 증권번호가 발행되었습니다.";
    			} else {
    				System.out.println("정상적인 보증 정보 수신!!!!");
        			responseResult  = "SA";
    				responseName = "시스템수용";
    				responseMessage = "시스템에 보증서 정보가 정상적으로 수신되었습니다.";
    				
    				resultMap.put("GUAR_RESULT", recvXml );
    	    		resultMap.put("RESP_TYPE_CODE", responseResult );
    	    		resultMap.put("RESP_TYPE_NAME", responseName );
    	    		resultMap.put("RESP_MESG_TEXT", responseMessage );
    	    		
    	    		System.out.println("==== STOCECPC 테이블 저장 시작 ====");
    				msg = sctr0010_service.sendGuarSWComplete(resultMap);
    				jobRlt = "S";
    	    		//jobId  = "SWGuar";
    				System.out.println("==== STOCECPC 테이블 저장 끝 ====");
    			}
    				
				/*
				 * System.out.println("정상적인 보증 정보 수신!!!!"); responseResult = "SA"; responseName
				 * = "시스템수용"; responseMessage = "시스템에 보증서 정보가 정상적으로 수신되었습니다.";
				 * 
				 * resultMap.put("GUAR_RESULT", recvXml ); resultMap.put("RESP_TYPE_CODE",
				 * responseResult ); resultMap.put("RESP_TYPE_NAME", responseName );
				 * resultMap.put("RESP_MESG_TEXT", responseMessage );
				 * 
				 * System.out.println("==== STOCECPC 테이블 저장 시작 ===="); msg =
				 * sctr0010_service.sendGuarSWComplete(resultMap); jobRlt = "S";
				 * System.out.println("==== STOCECPC 테이블 저장 끝 ====");
				 */
				
    		}else {
    			System.out.println("비정상적인 보증 정보 수신!!!!");
    			if("CONGUA".equals(head_mesg_type)) {		// 계약보증서
    				head_mesg_type = "RCONGUA";
        			//resultMap.put("head_mesg_type", "RCONGUA");
            	}
            	else if("PREGUA".equals(head_mesg_type)) { // 선급보증서
            		head_mesg_type = "RPREGUA";
            		//resultMap.put("head_mesg_type", "RPREGUA");
            	}
            	else if("FLRGUA".equals(head_mesg_type)) { // 하자보증서
            		head_mesg_type = "RFLRGUA";
            		//resultMap.put("head_mesg_type", "RFLRGUA");
            	}
    			
    			responseResult  = "SR";
    			responseName = "시스템거부";
    			responseMessage = "해당 계약 건 에 대해 시스템 데이터와 일치하는 계약이 없습니다.";
    			msg = "해당 계약 건 에 대해 시스템 데이터와 일치하는 계약이 없습니다.";
    		}
    		
    		System.out.println("==== 응답메세지 전달 시작 ====");
    		ret = "resp_type_code`=" + responseResult + "`&resp_type_name`=" + responseName + "`&resp_mesg_text`=" + responseMessage;
    		System.out.println("===  ret ===> "+ret);
    		
    		//ServletOutputStream output = null;
			//try {
			//	output = response.getOutputStream();
			//	output.write(ret.getBytes("EUC-KR")) ;
			//	output.flush() ;
			//	if (output != null) output.close();
			//} catch (IOException e3) {
			//	logger.error("응답서 전송중 오류가 발생하였습니다.:"+e3.toString());
			//	throw new Exception("응답서 전송중 오류가 발생하였습니다.:"+e3.toString());
			//} finally {
    		//	if (output != null) output.close();
    		//}
			System.out.println("==== 응답메세지 전달 끝 ====");
    	} catch (Exception e ) {
    		logger.error(e.getMessage(), e);
    		
    		responseResult  = "SR";
			responseName = "시스템거부";
			responseMessage = "시스템에서 DB 저장 실패 또는 기타 오류가 발생하였습니다.";
			ret = "resp_type_code`=" + responseResult + "`&resp_type_name`=" + responseName + "`&resp_mesg_text`=" + responseMessage;
    		System.out.println("===  ret ===> "+ret);
    		
    		//보증오류 발생시 SMS 보내기
            String strTelNums = PropertiesManager.getString("eversrm.guar.error.receive.telNo");
        	String[] telNums  = (strTelNums==null)?null:strTelNums.split(";");
        	if( telNums != null ) {
            	for (String telNum : telNums) {
                    try {
    	                Map<String,String> smsMap = new HashMap<String,String>();
    	                smsMap.put("CONTENTS", "[전자구매보증신청] 전자보증 전문 수신시 오류가 발생");
    					smsMap.put("REF_MODULE_CD", "BATCH");
    					smsMap.put("DIRECT_TARGET", telNum);
    					smsMap.put("DIRECT_USER_NM", "전자보증담당자");
    					everSmsService.sendSmsNhe(smsMap);
                    } catch (Exception e1) {
                    	logger.error(e1.getMessage(), e1);
                    }
                }
        	}
        	
            msg = getMessageAsString(e);
            throw new Exception();
            
    	} finally {
    		try {
                Map<String, Object> logData = new HashMap<String, Object>();
                logData.put("JOB_DATE", startDate.substring(0, 19));
                logData.put("JOB_TYPE", "Guar");
                logData.put("JOB_ID", "SWGuar");
                logData.put("JOB_KEY", "R");
                logData.put("JOB_RLT", jobRlt);
                logData.put("JOB_RLT_CD", "");
                logData.put("JOB_RLT_MSG", msg);
                logData.put("JOB_END_DATE", EverDate.getTimeStampString().substring(0, 19));
                logData.put("JOB_NUM", contNum);
                //로그에 해당메세지 저장.
                sctr0010_service.doSaveBatchLog(logData);
                
            } catch (Exception e2) {
                logger.error(e2.getMessage(), e2);
            }
    		
    		System.out.println("=== 응답메시지 전달 시작 ===");
    		ServletOutputStream output = null;
			try {
				output = response.getOutputStream();
				output.write(ret.getBytes("EUC-KR")) ;
				output.flush();
			} catch (IOException e3) {
				logger.error("응답서 전송중 오류가 발생하였습니다.:"+e3.toString());
				throw new Exception("응답서 전송중 오류가 발생하였습니다.:"+e3.toString());
			} finally {
				if (output != null) output.close();
			}
			System.out.println("=== 응답메시지 전달 끝 ===");
		}
		
    }
    
    protected String getMessageAsString(Throwable e) {
        StringWriter sw = new StringWriter();
        PrintWriter pw = new PrintWriter(sw, true);
        e.printStackTrace(pw);
        pw.flush();
        return StringUtils.abbreviate(sw.toString(), 3000);
    }

}