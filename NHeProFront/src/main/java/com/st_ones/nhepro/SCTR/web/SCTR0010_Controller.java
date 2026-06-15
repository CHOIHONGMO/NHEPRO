package com.st_ones.nhepro.SCTR.web;

import java.io.File;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.json.simple.JSONObject;
import org.quartz.JobExecutionException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.st_ones.common.enums.econtract.ContStringUtil;
import com.st_ones.common.enums.system.Code;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.serverpush.reverseajax.EverRestJson;
import com.st_ones.common.util.clazz.EverConverter;
import com.st_ones.common.util.clazz.EverDate;
import com.st_ones.common.util.clazz.EverFile;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.common.util.clazz.PdfPrintUtil;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.nhepro.SCTR.service.SCTR0010_Service;
import com.st_ones.common.sms.service.EverSmsService;
import com.st_ones.common.file.service.FileAttachService;

/**
 * <pre>
 * *****************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 St-Ones CORP., ALL RIGHTS RESERVED | Confidential)
 * *****************************************************************************
 * </pre>
 *
 * @author
 * @version 1.0
 * @File Name : SECM_Controller.java
 * @date 2012. 04. 10.
 * @see
 */

@Controller
@RequestMapping(value = "/nhepro/SCTR")
public class SCTR0010_Controller extends BaseController {
	
	Logger logger = LoggerFactory.getLogger(this.getClass());
	
    @Autowired
    private MessageService msg;
    @Autowired
    private SCTR0010_Service sctr0010_service;
    @Autowired
    private PdfPrintUtil pdfUtil;
    @Autowired 
    private EverSmsService everSmsService;
    @Autowired
    FileAttachService fileAttachService;    

    //계약서 현황(협력사)
    @RequestMapping(value = "/SCTR0010/view")
    public String contractProgressStatus(EverHttpRequest req) {

        req.setAttribute("fromDate", EverDate.addMonths(-6));
        req.setAttribute("toDate", EverDate.addMonths(1));
        return "/nhepro/SCTR/SCTR0010";
    }

    //계약서 현황 조회(협력사)
    @RequestMapping(value = "/SCTR0010/sctr0010_doSearch")
    public void sctr0010_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> param = req.getFormData();

        resp.setGridObject("grid", sctr0010_service.sctr0010_doSearchContractProgressStatus(param));
    }

    //계약서 현황 조회(협력사)
    @RequestMapping(value = "/SCTR0010/sctr0010_doGurSave")
    public void sctr0010_doGurSave(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        List<Map<String, Object>> gridData = req.getGridData("grid");

        sctr0010_service.sctr0010_doGurSave(gridData);
    }

    //계약서 상세
    @RequestMapping(value = "/SCTR0011/view")
    public String secm030_view(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        sctr0010_service.sctr0011_getContractInfo(req, resp);
        // List<Map<String, Object>> subFormList = sctr0010_service.secm030_doSearchSubForm(parameterMap);

        req.setAttribute("toDate", EverDate.getShortDateString());
        req.setAttribute("isDevEnv", PropertiesManager.getBoolean("eversrm.system.developmentFlag"));
        req.setAttribute("guarFlag", sctr0010_service.sctr0011_doSearchGuarInfo(req.getParamDataMap()));

        String localServerFlag = "N";
        if( PropertiesManager.getBoolean("eversrm.system.localserver") || PropertiesManager.getBoolean("eversrm.system.developmentFlag") ) {
            localServerFlag = "Y";
        }
        req.setAttribute("localServerFlag", localServerFlag);

        return "/nhepro/SCTR/SCTR0011";
    }

    @RequestMapping(value="/SCTR0011/sctr0011_doSearchECPC_HD")
    public void sctr0011_doSearchECPC_HD(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.setGridObject("gridECPC_HD", sctr0010_service.sctr0011_doSearchECPC_HD(req.getFormData()));
    }

    @RequestMapping(value="/SCTR0011/sctr0011_doSearchECPC")
    public void sctr0011_doSearchECPC(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.setGridObject("gridECPC", sctr0010_service.sctr0011_doSearchECPC(req.getFormData()));
    }

    @RequestMapping(value="/SCTR0011/sctr0011_doSearchECMT")
    public void sctr0011_doSearchECMT(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.setGridObject("gridECMT", sctr0010_service.sctr0011_doSearchECMT(req.getFormData()));
    }

    @RequestMapping(value="/SCTR0011/sctr0011_doSearchECCM")
    public void sctr0011_doSearchECCM(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.setGridObject("gridECCM", sctr0010_service.sctr0011_doSearchECCM(req.getFormData()));
    }

    @RequestMapping(value = "/SCTR0011/sctr0011_doSaveECPC_HD")
    public void sctr0011_doSaveECPC_HD(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        sctr0010_service.sctr0011_doSaveECPC_HD(req.getGridData("gridECPC_HD"));
    }

    @RequestMapping(value = "/SCTR0011/sctr0011_doSaveECPC")
    public void sctr0011_doSaveECPC(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        sctr0010_service.sctr0011_doSaveECPC(req.getGridData("gridECPC"));
    }

    @RequestMapping(value = "/SCTR0011/sctr0011_doUpdateVendorFile")
    public void sctr0011_doUpdateVendorFile(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        sctr0010_service.sctr0011_doUpdateVendorFile(req.getFormData());
    }

    @RequestMapping(value = "/SCTR0011/sctr0011_doPdfHashCode")
    public void sctr0011_doPdfBinary(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> param = req.getParamDataMap();
        Map jsonData = new ObjectMapper().readValue(param.get("json"), Map.class);
        String targetDirectory = jsonData.get("FILE_PATH").toString();
        String targetFileNm = jsonData.get("UUID") + "_" + jsonData.get("UUID_SQ") + "." + jsonData.get("EXTENSION");

        File file = new File(targetDirectory + targetFileNm);

        // 파일 이동 후 위변조 방지를 위해 Binary 적용
        String hashCode = EverFile.fileToHash(file);
        param.put("hashCode", hashCode);
        resp.sendJSON(param);
    }

    // PDF 검증
    @RequestMapping(value="/SCTR0010/sctr0010_doPdfValid")
    public void sctr0010_doPdfValid(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> pdfFileInfo = sctr0010_service.sctr0010_doPdfValid(req.getParamDataMap());

        String targetPath = pdfFileInfo.get("FILE_PATH");
        String targetFileNm = pdfFileInfo.get("UUID") + "_" + pdfFileInfo.get("UUID_SQ") + "." + pdfFileInfo.get("FILE_EXTENSION");

        String binaryFile = EverFile.fileToBinary(targetPath, targetFileNm);
        Map<String, String> binaryMap = new HashMap<>();
        binaryMap.put("url", PropertiesManager.getString("block.chain.verify"));
        binaryMap.put("strFromFile", binaryFile);
        JSONObject jsonObject = EverRestJson.actionAPI(binaryMap);
        resp.setResponseMessage(jsonObject.get("msg").toString());
    }

    /**
     * 서명할 계약서를 조회한다.
     *
     * @param req
     * @param resp
     * @throws Exception
     */
    @RequestMapping(value = "/SCTR0011/sctr0011_getContractsToSign")
    public void sctr0011_getContractsToSign(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        sctr0010_service.sctr0011_getContractsToSign(req, resp);
    }

    @RequestMapping(value = "/SECM_030/downloadPdf")
    public void secm030_downloadPdf(EverHttpRequest req, EverHttpResponse resp) throws Exception {

    	//pdfUtil.htmlTopdfConvert(req, resp);
    }

    /**
     * 전자서명된 데이터를 저장하고 계약서 상태를 변경한다.
     *
     * @param req
     * @param resp
     * @throws Exception
     */
    @RequestMapping(value = "/SCTR0011/sctr0011_doSaveSignedData")
    public void sctr0011_doSaveSignedData(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        sctr0010_service.sctr0011_doSaveSignedData(req, resp);
    }

    /**
     * 계약서를 반려처리하고 사유를 저장한다.
     *
     * @param req
     * @param resp
     * @throws Exception
     */
    @RequestMapping(value = "/SCTR0011/sctr0011_doRejectContract")
    public void sctr0011_doRejectContract(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        sctr0010_service.sctr0011_doRejectContract(req, resp);
    }

    //htmlTopdf
    @RequestMapping(value = "/htmlTopdfViewer/view")
    public String htmlTopdfViewer(EverHttpRequest req) {
        return "/eversrm/eContract/eContractMgt/htmlTopdfViewer";
    }

    //계약서 출력화면 Loading 시
    @RequestMapping(value = "/SCTR0012/view")
    public String printContractView(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> param = req.getFormData();
        String contNum = req.getParameter("contNum");
        String contCnt = req.getParameter("contCnt");

        param.put("CONT_NUM", contNum);
        param.put("CONT_CNT", contCnt);

        //	3-1. 서명완료서식
        String signOrgText = "<span class=\"changeVal_61\">&nbsp;</span>";

        //	3-2. 서명완료를 위한 데이터 조회
        Map<String, String> formData = sctr0010_service.sctr0012_doSearchPrint(param);
        String progressCd  = formData.get("PROGRESS_CD");
        String cFormContents = "";

        List<Map<String, String>> otherData = sctr0010_service.sctr0012_doSearchOtherPrint(param);
        String cOtherContents = "";

        //	3-3. 서명완료서식에 대체할 문구
        String dtBody = "";
        String enter = "\n";
        if (Code.M135_4300.equals(progressCd)) {
            dtBody = dtBody
                    + enter + "<table border='0' cellpadding='0' cellspacing='1' style='width: 100%; height: 50px;'>"
                    + enter + "	<tbody>"
                    + enter + "		<tr>"
                    + enter + "			<td align='center' width='98%'><span style='font-size: 12px; color: red; font-weight: bold;'>"
                    + enter + "			    <br>* 본 계약서는 상기업체 간에 전자서명법 등 관련법령에 근거하여 전자서명으로 체결한 전자계약서입니다.<br>&nbsp;&nbsp;(계약번호: "+contNum+")</span><br/>"
                    + enter + "			<td width='2%'>&nbsp;</td>"
                    + enter + "		</tr>"
                    + enter + "	</tbody>"
                    + enter + "</table>";
        }
        dtBody = dtBody + "<br><br>";

        String signOtherContents = "";
        String contractOtherContents = "";

        for (int i=0; i< otherData.size(); i++) {
            Map<String, String> map = otherData.get(i);

            contractOtherContents = ContStringUtil.getHtmlContents(map.get("CONTRACT_TEXT"), true);
            signOtherContents = contractOtherContents.replaceAll(signOrgText, dtBody);
            signOtherContents = signOtherContents + dtBody;

            //Only JDK 1.8 support
            //otherData.set(i, map).replace("CONTRACT_TEXT", signOtherContents);

            map.put("CONTRACT_TEXT", signOtherContents);
            otherData.set(i, map);
        }

        //1. 페이지 분할 영역 글자 없애기
        cFormContents = formData.get("CONTRACT_TEXT").replaceAll("==================== 페이지 분할 영역 ====================", "");

        //2. HTML 변환
        String contractFormContents = ContStringUtil.getHtmlContents(cFormContents.replaceAll("&lt;", "<").replaceAll("&gt;", ">"), true);

        //	3-4. 서명완료서식을 서명완료문구로 대체
        String signFormContents = contractFormContents.replaceAll(signOrgText, dtBody);
        signFormContents = signFormContents + dtBody;

        req.setAttribute("formContents", signFormContents);
        req.setAttribute("formEtc", formData);
        req.setAttribute("additionalFormContents", otherData);

        return "/nhepro/SCTR/SCTR0012";
    }


    // ECPCHD 소프트웨어공제조합보증신청
    @RequestMapping(value = "/SCTR0011/sctr0011_guar_approval")
    public void sctr0011_guar_approval(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map guardata = EverConverter.readJsonObject(req.getParameter("guardata"),Map.class);
        
    	String jobRlt = "E";
    	String jobId = "SWGuar";
        String startDate = EverDate.getTimeStampString();
        String msg = "";
        String message = "";
        String contNum = guardata.get("CONT_NUM")+ "-" + String.valueOf(guardata.get("CONT_CNT")) + "-" + String.valueOf(guardata.get("PAY_CNT"));
        
        try {
	    	msg = sctr0010_service.sendGuarSW(guardata);
	    	jobRlt = "S";
	    	
	    	message = "성공적으로 전자보증 신청하였습니다.";
	    	resp.setResponseMessage(message);
        } catch (Exception e) {
            logger.error(e.getMessage(), e);
            //보증오류 발생시 SMS 보내기
            String strTelNums = PropertiesManager.getString("eversrm.guar.error.receive.telNo");
        	String[] telNums  = (strTelNums==null)?null:strTelNums.split(";");
        	if( telNums != null ) {
            	for (String telNum : telNums) {
                    try {
    	                Map<String,String> smsMap = new HashMap<String,String>();
    	                smsMap.put("CONTENTS", "[전자구매보증신청] 전자보증 신청전문 송신시 오류가 발생");
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
            message = "시스템 오류로 인해 전자보증 신청이 실패하였습니다.";
            resp.setResponseMessage(message);
            //throw new Exception();
        } finally {
            try {
                Map<String, Object> logData = new HashMap<String, Object>();
                logData.put("JOB_DATE", startDate.substring(0, 19));
                logData.put("JOB_TYPE", "Guar");
                logData.put("JOB_ID", jobId);
                logData.put("JOB_KEY", "S");
                logData.put("JOB_RLT", jobRlt);
                logData.put("JOB_RLT_CD", "");
                logData.put("JOB_RLT_MSG", "(신청)" + message + msg);
                logData.put("JOB_END_DATE", EverDate.getTimeStampString().substring(0, 19));
                logData.put("JOB_NUM", contNum);
                //로그에 해당메세지 저장.
                sctr0010_service.doSaveBatchLog(logData);
            } catch (Exception e2) {
                logger.error(e2.getMessage(), e2);
            }
        }
        System.out.println("message ====> "+ message);
    }
    
    // ECPCHD 서울보증신청
    @RequestMapping(value = "/SCTR0011/sctr0011_guarSg_approval")
    public void sctr0011_guarSg_approval(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	
    	System.out.println("====================== 서울보증 시작 ======================");
        Map guardata = EverConverter.readJsonObject(req.getParameter("guardata"),Map.class);
        
    	String jobRlt = "E";
    	String jobId = "SGGuar";
        String startDate = EverDate.getTimeStampString();
        String msg = "";
        String message = "";
        String contNum = guardata.get("CONT_NUM")+ "-" + String.valueOf(guardata.get("CONT_CNT")) + "-" + String.valueOf(guardata.get("PAY_CNT"));
        
        try {
	    	msg = sctr0010_service.sendContGuar(guardata);
	    	jobRlt = "S";
	    	
	    	message = "성공적으로 전자보증 신청하였습니다.";
	    	resp.setResponseMessage(message);
        } catch (Exception e) {
            logger.error(e.getMessage(), e);
            //보증오류 발생시 SMS 보내기
            String strTelNums = PropertiesManager.getString("eversrm.guar.error.receive.telNo");
        	String[] telNums  = (strTelNums==null)?null:strTelNums.split(";");
        	if( telNums != null ) {
            	for (String telNum : telNums) {
                    try {
    	                Map<String,String> smsMap = new HashMap<String,String>();
    	                smsMap.put("CONTENTS", "[전자구매보증신청] 전자보증 신청전문 송신시 오류가 발생");
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
            message = "시스템 오류로 인해 전자보증 신청이 실패하였습니다.";
            resp.setResponseMessage(message);
            //throw new Exception();
        } finally {
            try {
                Map<String, Object> logData = new HashMap<String, Object>();
                logData.put("JOB_DATE", startDate.substring(0, 19));
                logData.put("JOB_TYPE", "Guar");
                logData.put("JOB_ID", jobId);
                logData.put("JOB_KEY", "S");
                logData.put("JOB_RLT", jobRlt);
                logData.put("JOB_RLT_CD", "");
                logData.put("JOB_RLT_MSG", "(신청)" + message + msg);
                logData.put("JOB_END_DATE", EverDate.getTimeStampString().substring(0, 19));
                logData.put("JOB_NUM", contNum);
                //로그에 해당메세지 저장.
                sctr0010_service.doSaveBatchLog(logData);
            } catch (Exception e2) {
                logger.error(e2.getMessage(), e2);
            }
        }
        System.out.println("message ====> "+ message);
    }

    // ECPC 소프트웨어공제조합보증신청(선금,하자)
    @RequestMapping(value = "/SCTR0011/sctr0011_guar_approval2")
    public void sctr0011_guar_approval2(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map guardata = EverConverter.readJsonObject(req.getParameter("guardata"),Map.class);
        
        String jobRlt = "E";
        String jobId = "SWGuar";
        String startDate = EverDate.getTimeStampString();
        String msg = "";
        String message = "";
        String contNum = guardata.get("CONT_NUM")+ "-" + String.valueOf(guardata.get("CONT_CNT")) + "-" + String.valueOf(guardata.get("PAY_CNT"));
        
        try {
	    	msg = sctr0010_service.sendGuarSW(guardata);
	    	jobRlt = "S";
	    	
	    	message = "성공적으로 전자보증 신청하였습니다.";
	    	resp.setResponseMessage(message);
        } catch (Exception e) {
            logger.error(e.getMessage(), e);
            
            //보증오류 발생시 SMS 보내기
            String strTelNums = PropertiesManager.getString("eversrm.guar.error.receive.telNo");
        	String[] telNums  = (strTelNums==null)?null:strTelNums.split(";");
        	if( telNums != null ) {
            	for (String telNum : telNums) {
                    try {
    	                Map<String,String> smsMap = new HashMap<String,String>();
    	                smsMap.put("CONTENTS", "[전자구매보증신청] 전자보증 신청전문 송신시 오류가 발생");
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
            message = "시스템 오류로 인해 전자보증 신청이 실패하였습니다.";
            resp.setResponseMessage(message);
            //throw new Exception();
        } finally {
            try {
                Map<String, Object> logData = new HashMap<String, Object>();
                logData.put("JOB_DATE", startDate.substring(0, 19));
                logData.put("JOB_TYPE", "Guar");
                logData.put("JOB_ID", jobId);
                logData.put("JOB_KEY", "S");
                logData.put("JOB_RLT", jobRlt);
                logData.put("JOB_RLT_CD", "");
                logData.put("JOB_RLT_MSG", "(신청)" + message + msg);
                logData.put("JOB_END_DATE", EverDate.getTimeStampString().substring(0, 19));
                logData.put("JOB_NUM", contNum);
                //로그에 해당메세지 저장.
                sctr0010_service.doSaveBatchLog(logData);
            } catch (Exception e2) {
                logger.error(e2.getMessage(), e2);
            }
        }
    }
    
    // ECPC 서울보증신청(선금,하자보증)
    @RequestMapping(value = "/SCTR0011/sctr0011_guarSg_approval2")
    public void sctr0011_guarSg_approval2(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map guardata = EverConverter.readJsonObject(req.getParameter("guardata"),Map.class);
        
        String jobRlt = "E";
        String jobId = "SGGuar";
        String startDate = EverDate.getTimeStampString();
        String msg = "";
        String message = "";
        String contNum = guardata.get("CONT_NUM")+ "-" + String.valueOf(guardata.get("CONT_CNT")) + "-" + String.valueOf(guardata.get("PAY_CNT"));
        
        try {
	    	
	    	msg = sctr0010_service.sendContGuar(guardata);
	    	jobRlt = "S";
	    	
	    	message = "성공적으로 전자보증 신청하였습니다.";
	    	resp.setResponseMessage(message);
        } catch (Exception e) {
            logger.error(e.getMessage(), e);
            
            //보증오류 발생시 SMS 보내기
            String strTelNums = PropertiesManager.getString("eversrm.guar.error.receive.telNo");
        	String[] telNums  = (strTelNums==null)?null:strTelNums.split(";");
        	if( telNums != null ) {
            	for (String telNum : telNums) {
                    try {
    	                Map<String,String> smsMap = new HashMap<String,String>();
    	                smsMap.put("CONTENTS", "[전자구매보증신청] 전자보증 신청전문 송신시 오류가 발생");
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
            message = "시스템 오류로 인해 전자보증 신청이 실패하였습니다.";
            resp.setResponseMessage(message);
            //throw new Exception();
        } finally {
            try {
                Map<String, Object> logData = new HashMap<String, Object>();
                logData.put("JOB_DATE", startDate.substring(0, 19));
                logData.put("JOB_TYPE", "Guar");
                logData.put("JOB_ID", jobId);
                logData.put("JOB_KEY", "S");
                logData.put("JOB_RLT", jobRlt);
                logData.put("JOB_RLT_CD", "");
                logData.put("JOB_RLT_MSG", "(신청)" + message + msg);
                logData.put("JOB_END_DATE", EverDate.getTimeStampString().substring(0, 19));
                logData.put("JOB_NUM", contNum);
                //로그에 해당메세지 저장.
                sctr0010_service.doSaveBatchLog(logData);
            } catch (Exception e2) {
                logger.error(e2.getMessage(), e2);
            }
        }
    }
    
    // ECPCHD 증권번호 발행 전 소프트웨어공제조합보증취소
    @RequestMapping(value = "/SCTR0011/sctr0011_guar_cancel")
    public void sctr0011_guar_cancel(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map guardata = EverConverter.readJsonObject(req.getParameter("guardata"),Map.class);
        
        String jobRlt = "E";
        String jobId = "SWGuar";
        String startDate = EverDate.getTimeStampString();
        String msg = "";
        String message = "";
        String contNum = guardata.get("CONT_NUM")+ "-" + String.valueOf(guardata.get("CONT_CNT")) + "-" + String.valueOf(guardata.get("PAY_CNT"));
        
        try {
	    	msg = sctr0010_service.sendGuarCancelSW(guardata);
	    	jobRlt = "S";
	    	
	    	message = "성공적으로 전자보증 취소하였습니다.";
	    	resp.setResponseMessage(message);
        } catch (Exception e) {
            logger.error(e.getMessage(), e);
            
            //보증오류 발생시 SMS 보내기
            String strTelNums = PropertiesManager.getString("eversrm.guar.error.receive.telNo");
        	String[] telNums  = (strTelNums==null)?null:strTelNums.split(";");
        	if( telNums != null ) {
            	for (String telNum : telNums) {
                    try {
    	                Map<String,String> smsMap = new HashMap<String,String>();
    	                smsMap.put("CONTENTS", "[전자구매보증신청] 전자보증 취소전문 송신시 오류가 발생");
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
            message = "시스템 오류로 인해 전자보증 취소가 실패하였습니다.";
            resp.setResponseMessage(message);
            //throw new Exception();
        } finally {
            try {
                Map<String, Object> logData = new HashMap<String, Object>();
                logData.put("JOB_DATE", startDate.substring(0, 19));
                logData.put("JOB_TYPE", "Guar");
                logData.put("JOB_ID", jobId);
                logData.put("JOB_KEY", "S");
                logData.put("JOB_RLT", jobRlt);
                logData.put("JOB_RLT_CD", "");
                logData.put("JOB_RLT_MSG", "(취소)" + message + msg);
                logData.put("JOB_END_DATE", EverDate.getTimeStampString().substring(0, 19));
                logData.put("JOB_NUM", contNum);
                //로그에 해당메세지 저장.
                sctr0010_service.doSaveBatchLog(logData);
            } catch (Exception e2) {
                logger.error(e2.getMessage(), e2);
            }
        }	
    }
    
    // ECPCHD 증권번호 발행 전 서울보증취소
    @RequestMapping(value = "/SCTR0011/sctr0011_guarSg_cancel")
    public void sctr0011_guarSg_cancel(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map guardata = EverConverter.readJsonObject(req.getParameter("guardata"),Map.class);
        
        String jobRlt = "E";
        String jobId = "SGGuar";
        String startDate = EverDate.getTimeStampString();
        String msg = "";
        String message = "";
        String contNum = guardata.get("CONT_NUM")+ "-" + String.valueOf(guardata.get("CONT_CNT")) + "-" + String.valueOf(guardata.get("PAY_CNT"));
        
        try {
	    	msg = sctr0010_service.sendContSGGuarCancel(guardata);
	    	jobRlt = "S";
	    	
	    	message = "성공적으로 전자보증 취소하였습니다.";
	    	resp.setResponseMessage(message);
        } catch (Exception e) {
            logger.error(e.getMessage(), e);
            
            //보증오류 발생시 SMS 보내기
            String strTelNums = PropertiesManager.getString("eversrm.guar.error.receive.telNo");
        	String[] telNums  = (strTelNums==null)?null:strTelNums.split(";");
        	if( telNums != null ) {
            	for (String telNum : telNums) {
                    try {
    	                Map<String,String> smsMap = new HashMap<String,String>();
    	                smsMap.put("CONTENTS", "[전자구매보증신청] 전자보증 취소전문 송신시 오류가 발생");
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
            message = "시스템 오류로 인해 전자보증 취소가 실패하였습니다.";
            resp.setResponseMessage(message);
            //throw new Exception();
        } finally {
            try {
                Map<String, Object> logData = new HashMap<String, Object>();
                logData.put("JOB_DATE", startDate.substring(0, 19));
                logData.put("JOB_TYPE", "Guar");
                logData.put("JOB_ID", jobId);
                logData.put("JOB_KEY", "S");
                logData.put("JOB_RLT", jobRlt);
                logData.put("JOB_RLT_CD", "");
                logData.put("JOB_RLT_MSG", "(취소)" + message + msg);
                logData.put("JOB_END_DATE", EverDate.getTimeStampString().substring(0, 19));
                logData.put("JOB_NUM", contNum);
                //로그에 해당메세지 저장.
                sctr0010_service.doSaveBatchLog(logData);
            } catch (Exception e2) {
                logger.error(e2.getMessage(), e2);
            }
        }	
    }
    
    // ECPC 증권번호 발행 전 소프트웨어공제조합보증취소(선금,하자)
    @RequestMapping(value = "/SCTR0011/sctr0011_guar_cancel2")
    public void sctr0011_guar_cancel2(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map guardata = EverConverter.readJsonObject(req.getParameter("guardata"),Map.class);
        
        String jobRlt = "E";
        String jobId = "SWGuar";
        String startDate = EverDate.getTimeStampString();
        String msg = "";
        String message = "";
        String contNum = guardata.get("CONT_NUM")+ "-" + String.valueOf(guardata.get("CONT_CNT")) + "-" + String.valueOf(guardata.get("PAY_CNT"));
        
        try {
	    	msg = sctr0010_service.sendGuarCancelSW(guardata);
	    	jobRlt = "S";
	    	
	    	message = "성공적으로 전자보증 취소하였습니다.";
	    	resp.setResponseMessage(message);
        } catch (Exception e) {
            logger.error(e.getMessage(), e);
            
            //보증오류 발생시 SMS 보내기
            String strTelNums = PropertiesManager.getString("eversrm.guar.error.receive.telNo");
        	String[] telNums  = (strTelNums==null)?null:strTelNums.split(";");
        	if( telNums != null ) {
            	for (String telNum : telNums) {
                    try {
    	                Map<String,String> smsMap = new HashMap<String,String>();
    	                smsMap.put("CONTENTS", "[전자구매보증신청] 전자보증 취소전문 송신시 오류가 발생");
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
            message = "시스템 오류로 인해 전자보증 취소가 실패하였습니다.";
            resp.setResponseMessage(message);
            //throw new Exception();
        } finally {
            try {
                Map<String, Object> logData = new HashMap<String, Object>();
                logData.put("JOB_DATE", startDate.substring(0, 19));
                logData.put("JOB_TYPE", "Guar");
                logData.put("JOB_ID", jobId);
                logData.put("JOB_KEY", "S");
                logData.put("JOB_RLT", jobRlt);
                logData.put("JOB_RLT_CD", "");
                logData.put("JOB_RLT_MSG", "(취소)" + message + msg);
                logData.put("JOB_END_DATE", EverDate.getTimeStampString().substring(0, 19));
                logData.put("JOB_NUM", contNum);
                //로그에 해당메세지 저장.
                sctr0010_service.doSaveBatchLog(logData);
            } catch (Exception e2) {
                logger.error(e2.getMessage(), e2);
            }
        }
    }
    
    // ECPC 증권번호 발행 전 서울보증취소(선금,하자)
    @RequestMapping(value = "/SCTR0011/sctr0011_guarSg_cancel2")
    public void sctr0011_guarSg_cancel2(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map guardata = EverConverter.readJsonObject(req.getParameter("guardata"),Map.class);
        
        String jobRlt = "E";
        String jobId = "SGGuar";
        String startDate = EverDate.getTimeStampString();
        String msg = "";
        String message = "";
        String contNum = guardata.get("CONT_NUM")+ "-" + String.valueOf(guardata.get("CONT_CNT")) + "-" + String.valueOf(guardata.get("PAY_CNT"));
        
        try {
	    	msg = sctr0010_service.sendContSGGuarCancel(guardata);
	    	jobRlt = "S";
	    	
	    	message = "성공적으로 전자보증 취소하였습니다.";
	    	resp.setResponseMessage(message);
        } catch (Exception e) {
            logger.error(e.getMessage(), e);
            
            //보증오류 발생시 SMS 보내기
            String strTelNums = PropertiesManager.getString("eversrm.guar.error.receive.telNo");
        	String[] telNums  = (strTelNums==null)?null:strTelNums.split(";");
        	if( telNums != null ) {
            	for (String telNum : telNums) {
                    try {
    	                Map<String,String> smsMap = new HashMap<String,String>();
    	                smsMap.put("CONTENTS", "[전자구매보증신청] 전자보증 취소전문 송신시 오류가 발생");
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
            message = "시스템 오류로 인해 전자보증 취소가 실패하였습니다.";
            resp.setResponseMessage(message);
            //throw new Exception();
        } finally {
            try {
                Map<String, Object> logData = new HashMap<String, Object>();
                logData.put("JOB_DATE", startDate.substring(0, 19));
                logData.put("JOB_TYPE", "Guar");
                logData.put("JOB_ID", jobId);
                logData.put("JOB_KEY", "S");
                logData.put("JOB_RLT", jobRlt);
                logData.put("JOB_RLT_CD", "");
                logData.put("JOB_RLT_MSG", "(취소)" + message + msg);
                logData.put("JOB_END_DATE", EverDate.getTimeStampString().substring(0, 19));
                logData.put("JOB_NUM", contNum);
                //로그에 해당메세지 저장.
                sctr0010_service.doSaveBatchLog(logData);
            } catch (Exception e2) {
                logger.error(e2.getMessage(), e2);
            }
        }
    }
    
    // ECPCHD 증권번호 발행 후 보증취소
    @RequestMapping(value = "/SCTR0011/sctr0011_guar_delete")
    public void sctr0011_guar_delete(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	
    	List<Map<String, Object>> grid = req.getGridData("gridECPC_HD");

        Map<String, String> rtnMap = sctr0010_service.sendGuarCancel(req.getFormData(), grid);

        resp.setResponseMessage(rtnMap.get("rtnMsg"));
    }
    
    // ECPC 증권번호 발행 후 보증취소
    @RequestMapping(value = "/SCTR0011/sctr0011_guar_delete2")
    public void sctr0011_guar_delete2(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	
    	List<Map<String, Object>> grid = req.getGridData("gridECPC");

        Map<String, String> rtnMap = sctr0010_service.sendGuarCancel(req.getFormData(), grid);

        resp.setResponseMessage(rtnMap.get("rtnMsg"));
    }
    
    protected String getMessageAsString(Throwable e) {
        StringWriter sw = new StringWriter();
        PrintWriter pw = new PrintWriter(sw, true);
        e.printStackTrace(pw);
        pw.flush();
        return StringUtils.abbreviate(sw.toString(), 3000);
    }
    
    // 입찰보증 서울보증신청
    @RequestMapping(value = "/SCTR0011/sctr0011_guarBdhd_approval")
    public void sctr0011_guarBdhd_approval(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	
    	System.out.println("====================== 입찰 서울보증 시작 ======================");
        Map guardata = EverConverter.readJsonObject(req.getParameter("guardata"),Map.class);
        
    	String jobRlt = "E";
    	String jobId = "SGGuar";
        String startDate = EverDate.getTimeStampString();
        String msg = "";
        String message = "";
        String contNum = guardata.get("BID_NUM")+ "-" + String.valueOf(guardata.get("BID_CNT"))+ "-" + String.valueOf(guardata.get("VENDOR_CD"));
        
        try {
	    	msg = sctr0010_service.sendBdhdGuar(guardata);
	    	jobRlt = "S";
	    	message = "성공적으로 전자입찰보증 신청하였습니다.";
	    	
	    	resp.setParameter("buyerCd", String.valueOf(guardata.get("BUYER_CD")));
	        resp.setParameter("bidNum", String.valueOf(guardata.get("BID_NUM")));
	        resp.setParameter("bidCnt", String.valueOf(guardata.get("BID_CNT")));
	        resp.setParameter("vendorCd", String.valueOf(guardata.get("VENDOR_CD")));
	    	resp.setResponseMessage(message);
        } catch (Exception e) {
            logger.error(e.getMessage(), e);
            //보증오류 발생시 SMS 보내기
            String strTelNums = PropertiesManager.getString("eversrm.guar.error.receive.telNo");
        	String[] telNums  = (strTelNums==null)?null:strTelNums.split(";");
        	if( telNums != null ) {
            	for (String telNum : telNums) {
                    try {
    	                Map<String,String> smsMap = new HashMap<String,String>();
    	                smsMap.put("CONTENTS", "[전자구매입찰보증신청] 전자입찰보증 신청전문 송신시 오류가 발생");
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
            message = "시스템 오류로 인해 전자입찰보증 신청이 실패하였습니다.";
            resp.setResponseMessage(message);
            //throw new Exception();
        } finally {
            try {
                Map<String, Object> logData = new HashMap<String, Object>();
                logData.put("JOB_DATE", startDate.substring(0, 19));
                logData.put("JOB_TYPE", "Guar");
                logData.put("JOB_ID", jobId);
                logData.put("JOB_KEY", "S");
                logData.put("JOB_RLT", jobRlt);
                logData.put("JOB_RLT_CD", "");
                logData.put("JOB_RLT_MSG", "(신청)" + message + msg);
                logData.put("JOB_END_DATE", EverDate.getTimeStampString().substring(0, 19));
                logData.put("JOB_NUM", contNum);
                //로그에 해당메세지 저장.
                sctr0010_service.doSaveBatchLog(logData);
            } catch (Exception e2) {
                logger.error(e2.getMessage(), e2);
            }
        }
        System.out.println("message ====> "+ message);
    }
    
    // BDHD 증권번호 발행 전 입찰보증 서울보증취소
    @RequestMapping(value = "/SCTR0011/sctr0011_guarBdhd_cancel")
    public void sctr0011_guarBdhd_cancel(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	
    	System.out.println("====================== 입찰보증취소 서울보증 시작 ======================");
    	
        Map guardata = EverConverter.readJsonObject(req.getParameter("guardata"),Map.class);
        
        String jobRlt = "E";
        String jobId = "SGGuar";
        String startDate = EverDate.getTimeStampString();
        String msg = "";
        String message = "";
        String contNum = guardata.get("BID_NUM") + "-" + String.valueOf(guardata.get("BID_CNT"))+ "-" + String.valueOf(guardata.get("VENDOR_CD"));
        
        try {
	    	msg = sctr0010_service.sendBdhdGuarDataCancel(guardata);
	    	jobRlt = "S";
	    	message = "성공적으로 전자입찰보증 취소하였습니다.";
	    	
	    	resp.setParameter("buyerCd", String.valueOf(guardata.get("BUYER_CD")));
	        resp.setParameter("bidNum", String.valueOf(guardata.get("BID_NUM")));
	        resp.setParameter("bidCnt", String.valueOf(guardata.get("BID_CNT")));
	        resp.setParameter("vendorCd", String.valueOf(guardata.get("VENDOR_CD")));
	    	resp.setResponseMessage(message);
        } catch (Exception e) {
            logger.error(e.getMessage(), e);
            
            //보증오류 발생시 SMS 보내기
            String strTelNums = PropertiesManager.getString("eversrm.guar.error.receive.telNo");
        	String[] telNums  = (strTelNums==null)?null:strTelNums.split(";");
        	if( telNums != null ) {
            	for (String telNum : telNums) {
                    try {
    	                Map<String,String> smsMap = new HashMap<String,String>();
    	                smsMap.put("CONTENTS", "[전자구매보증신청] 전자입찰보증 취소전문 송신시 오류가 발생");
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
            message = "시스템 오류로 인해 전자입찰보증 취소가 실패하였습니다. ";
            resp.setResponseMessage(message);
            //throw new Exception();
        } finally {
            try {
                Map<String, Object> logData = new HashMap<String, Object>();
                logData.put("JOB_DATE", startDate.substring(0, 19));
                logData.put("JOB_TYPE", "Guar");
                logData.put("JOB_ID", jobId);
                logData.put("JOB_KEY", "S");
                logData.put("JOB_RLT", jobRlt);
                logData.put("JOB_RLT_CD", "");
                logData.put("JOB_RLT_MSG", "(취소)" + message + msg);
                logData.put("JOB_END_DATE", EverDate.getTimeStampString().substring(0, 19));
                logData.put("JOB_NUM", contNum);
                //로그에 해당메세지 저장.
                sctr0010_service.doSaveBatchLog(logData);
            } catch (Exception e2) {
                logger.error(e2.getMessage(), e2);
            }
        }
    }
    
    // BDHD 증권번호 발행 후 입찰보증 서울보증취소
    @RequestMapping(value = "/SCTR0011/sctr0011_guarNumBdhd_cancel")
    public void sctr0011_guarNumBdhd_cancel(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	
    	System.out.println("====================== 입찰보증취소 서울보증 시작 ======================");
    	
        Map guardata = EverConverter.readJsonObject(req.getParameter("guardata"),Map.class);
        
        String jobRlt = "E";
        String jobId = "SGGuar";
        String startDate = EverDate.getTimeStampString();
        String msg = "";
        String message = "";
        String contNum = guardata.get("BID_NUM") + "-" + String.valueOf(guardata.get("BID_CNT"))+ "-" + String.valueOf(guardata.get("VENDOR_CD"));
        
        try {
	    	msg = sctr0010_service.sendBdhdGuarNumDataCancel(guardata);
	    	jobRlt = "S";
	    	message = "성공적으로 전자입찰보증 취소하였습니다.";
	    	
	    	resp.setParameter("buyerCd", String.valueOf(guardata.get("BUYER_CD")));
	        resp.setParameter("bidNum", String.valueOf(guardata.get("BID_NUM")));
	        resp.setParameter("bidCnt", String.valueOf(guardata.get("BID_CNT")));
	        resp.setParameter("vendorCd", String.valueOf(guardata.get("VENDOR_CD")));
	    	resp.setResponseMessage(message);
        } catch (Exception e) {
            logger.error(e.getMessage(), e);
            
            //보증오류 발생시 SMS 보내기
            String strTelNums = PropertiesManager.getString("eversrm.guar.error.receive.telNo");
        	String[] telNums  = (strTelNums==null)?null:strTelNums.split(";");
        	if( telNums != null ) {
            	for (String telNum : telNums) {
                    try {
    	                Map<String,String> smsMap = new HashMap<String,String>();
    	                smsMap.put("CONTENTS", "[전자구매보증신청] 전자입찰보증 취소전문 송신시 오류가 발생");
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
            message = "시스템 오류로 인해 전자입찰보증 취소가 실패하였습니다.";
            resp.setResponseMessage(message);
            //throw new Exception();
        } finally {
            try {
                Map<String, Object> logData = new HashMap<String, Object>();
                logData.put("JOB_DATE", startDate.substring(0, 19));
                logData.put("JOB_TYPE", "Guar");
                logData.put("JOB_ID", jobId);
                logData.put("JOB_KEY", "S");
                logData.put("JOB_RLT", jobRlt);
                logData.put("JOB_RLT_CD", "");
                logData.put("JOB_RLT_MSG", "(취소)" + message + msg);
                logData.put("JOB_END_DATE", EverDate.getTimeStampString().substring(0, 19));
                logData.put("JOB_NUM", contNum);
                //로그에 해당메세지 저장.
                sctr0010_service.doSaveBatchLog(logData);
            } catch (Exception e2) {
                logger.error(e2.getMessage(), e2);
            }
        }
    }
    
    //서을보증 증권번호 발행 후 취소 시 고객사에서 전문취소 전송
    @RequestMapping(value = "/SCTR0011/sctr0011_guarNumSg_cancel")
    public void sctr0011_guarNumSg_cancel(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map guardata = EverConverter.readJsonObject(req.getParameter("guardata"),Map.class);
        
        String jobRlt = "E";
        String jobId = "SGGuar";
        String startDate = EverDate.getTimeStampString();
        String msg = "";
        String message = "";
        String contNum = guardata.get("CONT_NUM")+ "-" + String.valueOf(guardata.get("CONT_CNT")) + "-" + String.valueOf(guardata.get("PAY_CNT"));
        
        try {
	    	
	    	msg = sctr0010_service.sendContSGGuarNumCancel(guardata);
	    	jobRlt = "S";
	    	
	    	message = "승인이 완료되었습니다.\n전자보증 재 신청을 위해 협력사 재서명 요청 바랍니다.";
	    	resp.setResponseMessage(message);
        } catch (Exception e) {
            logger.error(e.getMessage(), e);
            
            //보증오류 발생시 SMS 보내기
            String strTelNums = PropertiesManager.getString("eversrm.guar.error.receive.telNo");
        	String[] telNums  = (strTelNums==null)?null:strTelNums.split(";");
        	if( telNums != null ) {
            	for (String telNum : telNums) {
                    try {
    	                Map<String,String> smsMap = new HashMap<String,String>();
    	                smsMap.put("CONTENTS", "[전자구매보증신청] 전자보증 취소전문 송신시 오류가 발생");
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
            message = "시스템 오류로 인해 전자보증 취소가 실패하였습니다.";
            resp.setResponseMessage(message);
            //throw new Exception();
        } finally {
            try {
                Map<String, Object> logData = new HashMap<String, Object>();
                logData.put("JOB_DATE", startDate.substring(0, 19));
                logData.put("JOB_TYPE", "Guar");
                logData.put("JOB_ID", jobId);
                logData.put("JOB_KEY", "S");
                logData.put("JOB_RLT", jobRlt);
                logData.put("JOB_RLT_CD", "");
                logData.put("JOB_RLT_MSG", "(취소)" + message + msg);
                logData.put("JOB_END_DATE", EverDate.getTimeStampString().substring(0, 19));
                logData.put("JOB_NUM", contNum);
                //로그에 해당메세지 저장.
                sctr0010_service.doSaveBatchLog(logData);
            } catch (Exception e2) {
                logger.error(e2.getMessage(), e2);
            }
        }	
    }
    
    //계약체결이후 선급/하자보증 저장
    @RequestMapping(value = "/SCTR0011/sctr0010_doGuarSave")
    public void sctr0010_doGuarSave(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        List<Map<String, Object>> gridData = req.getGridData("gridECPC");

        sctr0010_service.sctr0010_doGuarSave(gridData);
    }

    
    /**
     * 공급사 문서보관료 결제
     * @param req
     * @return
     */
    @RequestMapping("/supplyDocFee/view")
    public String supplyDocFee(EverHttpRequest req) throws Exception {

        String UUID = EverString.nullToEmptyString(req.getParameter("UUID"));
        String UUID_SQ = EverString.nullToEmptyString(req.getParameter("UUID_SQ"));
        
        Map<String, String> targetFileInfo = fileAttachService.getTagrgetFile(UUID, UUID_SQ);        
        String REAL_FILE_NM = targetFileInfo.get("REAL_FILE_NM");
        String COST = targetFileInfo.get("COST");
        String FINAL_DATE = targetFileInfo.get("FINAL_DATE");
        String VENDOR_CD = targetFileInfo.get("VENDOR_CD");
        String CORP_NO = targetFileInfo.get("CORP_NO");
        
        req.setAttribute("UUID", UUID);
        req.setAttribute("UUID_SQ", UUID_SQ);
        req.setAttribute("REAL_FILE_NM", REAL_FILE_NM);
        req.setAttribute("COST", COST);
        req.setAttribute("FINAL_DATE", FINAL_DATE);
        req.setAttribute("VENDOR_CD", VENDOR_CD);
        req.setAttribute("CORP_NO", CORP_NO);
        req.setAttribute("signDate", EverDate.getDate() + EverDate.getTime());
        String localServerFlag = "N";
        if( PropertiesManager.getBoolean("eversrm.system.localserver") || PropertiesManager.getBoolean("eversrm.system.developmentFlag") ) {
            localServerFlag = "Y";
        }
        req.setAttribute("localServerFlag", localServerFlag);        

        return "/nhepro/SCTR/supplyDocFee";
    }
    
    /**
     * 전자서명된 데이터를 저장하고 계약서 상태를 변경한다.
     *
     * @param req
     * @param resp
     * @throws Exception
     */
    @RequestMapping(value = "/SCTR0011/docFee_doSaveSignedData")
    public void docFee_doSaveSignedData(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        sctr0010_service.docFee_doSaveSignedData(req, resp);
    }    
}