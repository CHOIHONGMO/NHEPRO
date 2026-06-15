package com.st_ones.nosession.interfacez.web;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
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

import com.st_ones.common.sms.service.EverSmsService;
import com.st_ones.common.util.clazz.EverConverter;
import com.st_ones.common.util.clazz.EverDate;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.nhepro.SCTR.service.SCTR0010_Service;

import kica.sgic.util.SGIxLinker;
import kica.sgic.util.XmlToData;

@Controller
@RequestMapping(value = "/sgic")//pmsInterface
public class SgicController extends BaseController {

	private static Logger logger = LoggerFactory.getLogger(SgicController.class);

    @Autowired private SCTR0010_Service sctr0010_service;
    @Autowired private EverSmsService everSmsService;

    @RequestMapping("/recv")
    public void recv(EverHttpRequest request, EverHttpResponse response) throws Exception {
    	
    	String jobRlt = "E";
        String startDate = EverDate.getTimeStampString();
        String msg = "";
        String guar_req_num = "";
        String contNum = "";
        String head_mesg_type = "";
        
		String cont_numb_text = "";
		//String bidd_numb_text = "";
		
		String bond_numb_text = "";
		String bond_begn_date = "";
		String bond_fnsh_date = "";
		
        String responseXml="";
        String recvinfo_conf = PropertiesManager.getString("recvinfo_conf", "");

		SGIxLinker xLinker =  new SGIxLinker(recvinfo_conf, "recv.jsp", false);  // true 는 파일로 받는거, false 는 Data로 받는거 (메뉴얼에 없음....)

		/* 수신자에 암호화용 인증서를 세팅한다 */
		//xLinker.setRecipientCert(String pemCert);
		
		XmlToData xmlToData = null;
		
		try {
			/* 송신자가 보내는 전문을 대기하여 수신 받는다. */
			boolean isOK = xLinker.doRecvProcess(request, response);

			if(!isOK) {
				request.getServletContext().log("isOK is false");
				throw new Exception("정보인증 정보수신 API 오류입니다 : [" + xLinker.getErrorCode() + "] : " + xLinker.getErrorMsg());
			}

			/* 전문코드 */
			String recvDocCode = xLinker.getRecvDocCode();
			System.out.println("recvDocCode ====> "+recvDocCode);
			
			/* 수신 전문데이터 */
			String recvXmlDoc =  xLinker.getRecvXmlData();
			System.out.println("recvXmlDoc ===========> "+ recvXmlDoc);
			
			if(recvXmlDoc.equals("")){
				/* 수신 전문 경로+파일명 */
				recvXmlDoc =  xLinker.getDecXmlPath();
			}
			
			System.err.println("===sgic recv start=======================================================================================================");
			/*
			HashMap resultMap = xLinker.getData();
			System.err.println("=xLinker.getData======================================================"+resultMap);
			Iterator k = resultMap.keySet().iterator();
			while (k.hasNext()) {
				String key = (String) k.next();
				Object obj = resultMap.get(key);
				if( obj instanceof String){
					System.out.println("Key " + key + "; Value " + (String) obj);
				}else if( obj instanceof byte[]){
					System.out.println("Key " + key + "; Value " + (byte[]) obj);
				}
			}
			System.err.println("===sgic recv end=======================================================================================================");
			*/
			HashMap resultMap = new HashMap();
			
			xmlToData = new XmlToData(xLinker.getTempPath() , recvDocCode, recvXmlDoc);

			if(xmlToData.getErrorCode()!=0)
			{
				System.out.println(xmlToData.getErrorMsg());
				throw new Exception("=="+xmlToData.getErrorMsg()+"==");
			}
			
			head_mesg_type = xmlToData.getData("head_mesg_type");   //문서코드 CONGUA:계약, PREGUA:선금, FLRGUA:하자, BIDGUA:입찰
			bond_numb_text = xmlToData.getData("bond_numb_text");   //증권보증보험번호
			bond_begn_date = xmlToData.getData("bond_begn_date");   //보험기간 시작일
			bond_fnsh_date = xmlToData.getData("bond_fnsh_date");   //보험기간 종료일
			
			if("BIDGUA".equals(head_mesg_type)) {
				cont_numb_text = xmlToData.getData("bidd_numb_text");   //입찰 전자보증신청번호
				//guar_req_num = cont_numb_text.substring(cont_numb_text.indexOf("GU"),cont_numb_text.indexOf("GU")+13);  //전자보증신청번호
				//contNum = cont_numb_text.substring(cont_numb_text.indexOf("GU"),cont_numb_text.indexOf("GU")+13); //전자보증신청번호
			} else {
				cont_numb_text = xmlToData.getData("cont_numb_text");   //계약,선금,하자 전자보증신청번호
				//guar_req_num = cont_numb_text.substring(cont_numb_text.indexOf("GU"),cont_numb_text.indexOf("GU")+13);  //전자보증신청번호
				//contNum = cont_numb_text.substring(cont_numb_text.indexOf("GU"),cont_numb_text.indexOf("GU")+13); //전자보증신청번호
			}
			
			guar_req_num = cont_numb_text.substring(cont_numb_text.indexOf("GU"),cont_numb_text.indexOf("GU")+13);  //전자보증신청번호
			contNum = cont_numb_text.substring(cont_numb_text.indexOf("GU"),cont_numb_text.indexOf("GU")+13); //전자보증신청번호
			
			System.out.println("head_mesg_type  ===============> " + head_mesg_type);
			System.out.println("bond_numb_text  ===============> " + bond_numb_text);
			
			System.out.println("bond_begn_date  ===============> " + bond_begn_date);
			System.out.println("bond_fnsh_date  ===============> " + bond_fnsh_date);
			
			System.out.println("cont_numb_text  ===============> " + cont_numb_text);
			System.out.println("contNum  ===============> " + contNum);
    		
    		resultMap.put("head_mesg_type", head_mesg_type);
    		resultMap.put("bond_numb_text", bond_numb_text);
    		resultMap.put("bond_begn_date", bond_begn_date);
    		resultMap.put("bond_fnsh_date", bond_fnsh_date);
    		
    		resultMap.put("GUAR_REQ_NUM", guar_req_num);
    		
			if("CONGUA".equals(head_mesg_type)) {		// 계약보증서
				resultMap.put("GUAR_TYPE", "CONT");
	    	}
	    	else if("PREGUA".equals(head_mesg_type)) { // 선금보증서
	    		resultMap.put("GUAR_TYPE", "ADV");
	    	}
	    	else if("FLRGUA".equals(head_mesg_type)) { // 하자보증서
	    		resultMap.put("GUAR_TYPE", "WARR");
	    	}
	    	else if("BIDGUA".equals(head_mesg_type)) { // 이행입찰보증서
	    		resultMap.put("GUAR_TYPE", "E");
	    	}
			
			System.out.println("======================= 계약번호 및 증권번호 검증 시작  =======================");
			Map<String, String> guarInfo = sctr0010_service.getGuarInfoCheck(resultMap);
			
			if(guarInfo != null && guarInfo.size() > 0) { 
				
				Map<String, String> guarNumInfo = sctr0010_service.getGuarNumInfoCheck(resultMap);
				
				if(guarNumInfo != null && guarNumInfo.size() > 0) {
					/* 오류 xml 응답서 생성 */
					responseXml = xLinker.responseAck("SR", "실행중 오류가 발생하였습니다.(원인:시스템 데이터와 일치하는 계약 건 에 이미 증권번호 발행)", "1234567890");
				} else {
					/*
					 * 일반적인 Ack성 Response를 보낼때의 샘플 코드임
					 */
					if( (recvDocCode!=null)&&(!recvDocCode.equals(""))&&
							(recvXmlDoc!=null)&&(!recvXmlDoc.equals("")))
					{
						/* 정상 xml 응답서 생성 */
						responseXml = xLinker.responseAck("SA", "업체정보 수신업무가 정상적으로 수행되었습니다.", "1234567890");
						//String recvxml = XmlUtil.readStringFileName("c:/recv20061030201939_dec.xml");
						//responseXml = xLinker.responseSoapMime(recvxml);
						
						System.out.println("==== STOCECPC 테이블 저장 시작 ====");
						resultMap.put("GUAR_RESULT", recvXmlDoc );
						sctr0010_service.sendGuarComplete(resultMap);
						jobRlt = "S";
						System.out.println("==== STOCECPC 테이블 저장 끝 ====");
					} else {
						/* 오류 xml 응답서 생성 */
						responseXml = xLinker.responseAck("SR", "실행중 오류가 발생하였습니다.(원인:수신업무 오류)", "1234567890");
					}
				}
				
			} else {
				responseXml = xLinker.responseAck("SR", "실행중 오류가 발생하였습니다.(원인:시스템 데이터와 일치하는 계약이 존재하지 않음)", "1234567890");
			}


			//ServletOutputStream output = null;
			//try {
			//	output = response.getOutputStream();
			//	output.write(responseXml.getBytes()) ;
			//	output.flush() ;
			//	if (output != null) output.close();
			//} catch (IOException e) {
			//	logger.error("응답서 전송중 오류가 발생하였습니다.:"+e.toString());
			//	throw new Exception("응답서 전송중 오류가 발생하였습니다.:"+e.toString());
			//}
		    //System.err.println("recv_jsp" + " service finished SUCCESSFULLY!!!");

			// 재 수신 Ack 메시지
			//System.err.println(xLinker.getRecvAckXmlData());

		} catch(Exception e)	{
			logger.error(e.getMessage());
			
			responseXml = xLinker.responseAck("SR", "실행중 오류가 발생하였습니다.(원인:DB 저장 실패 또는 기타 오류)", "1234567890");
			
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
                logData.put("JOB_ID", "SGGuar");
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
				output.write(responseXml.getBytes()) ;
				output.flush() ;
				if (output != null) output.close();
			} catch (IOException e) {
				logger.error("응답서 전송중 오류가 발생하였습니다.:"+e.toString());
				throw new Exception("응답서 전송중 오류가 발생하였습니다.:"+e.toString());
			}
		    System.err.println("recv_jsp" + " service finished SUCCESSFULLY!!!");

			// 재 수신 Ack 메시지
			System.err.println(xLinker.getRecvAckXmlData());
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