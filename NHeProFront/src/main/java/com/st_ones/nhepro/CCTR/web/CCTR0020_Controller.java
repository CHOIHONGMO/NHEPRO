package com.st_ones.nhepro.CCTR.web;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.h2.engine.SysProperties;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.github.jhonnymertz.wkhtmltopdf.wrapper.Pdf;
import com.github.jhonnymertz.wkhtmltopdf.wrapper.configurations.WrapperConfig;
import com.st_ones.common.combo.service.CommonComboService;
import com.st_ones.common.enums.system.Code;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.serverpush.reverseajax.EverRestJson;
import com.st_ones.common.util.clazz.EverConverter;
import com.st_ones.common.util.clazz.EverDate;
import com.st_ones.common.util.clazz.EverFile;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.nhepro.CCTR.service.CCTR0020_Service;
import com.st_ones.nosession.interfacez.service.BNH0011_Service;
import com.st_ones.nosession.interfacez.service.ContSendErpService;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : CCTR0020_Controller.java
 * @date 2020.04.17
 * @version 1.0
 * @see
 */

@Controller
@RequestMapping(value = "/nhepro/CCTR")
public class CCTR0020_Controller extends BaseController {
	
    @Autowired
    private MessageService msg;
    @Autowired
    private CCTR0020_Service cctr0020_Service;
    @Autowired
    private CommonComboService commonComboService;
    @Autowired
    private ContSendErpService contsenderpservice;
    @Autowired
    private BNH0011_Service bnh0011_Service;
    
	/**
	 * 화면명 :
	 * 처리내용 :
	 * 경로 :  > >
	 */
    @RequestMapping(value="/CCTR0020/view")
    public String CCTR0020(EverHttpRequest req) throws Exception {
        req.setAttribute("defaultFromDate", EverDate.addMonths(-1));
        req.setAttribute("defaultToDate", EverDate.getDate());

        return "/nhepro/CCTR/CCTR0020";
    }

	/**
	 * 화면명 : 계약대기목록
	 * 처리내용 :
	 * 경로 :  > >
	 */
    @RequestMapping(value="/CCTR0020/doSearch")
    public void CCTR0020_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> param = req.getFormData();

        resp.setGridObject("grid", cctr0020_Service.cctr0020_doSearch(param));
        resp.setResponseCode("true");
    }
    
    /**
     * 2021.01.08 추가 : 수기계약이관
     * @param req
     * @param resp
     * @throws Exception
     */
    @RequestMapping(value = "/CCTR0020/doTransferContract")
    public void cctr0020_doTransferContract(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	
        Map<String, String> param = req.getFormData();
    	param.put("EXEC_NUM_SQ", EverString.nullToEmptyString(req.getParameter("EXEC_NUM_SQ")));
    	
        cctr0020_Service.cctr0020_doTransferContract(param);
        
        resp.setResponseMessage(msg.getMessage("0031"));
        resp.setResponseCode("true");
    }
    
    @RequestMapping(value="/CCTR0020/cctr0020_doResume")
    public void cctr0020_doResume(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> param = req.getFormData();
        List<Map<String, Object>> gridData = req.getGridData("grid");

        String msg = "SUCCESS";
        String isResumeFlag = "";
        
        isResumeFlag = cctr0020_Service.cctr0020_doResumeCheck(gridData);

        // 이미 해당 차수의 수정/재계약이 진행중인 경우
        if( "1".equals(isResumeFlag) ){
            msg = "1";
        }

        resp.setResponseMessage(msg);
    }
    
    /**
     * 개별계약서 작성 화면
     * @param req
     * @param resp
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/CCTA0030/view")
    public String CCTA0030(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> param = req.getParamDataMap();
        
        // 1. STOCECCT의 FORM 데이터 가져오기
        cctr0020_Service.ccta0030_getFormWithManualContractInfo(req, resp, param, null);
        
        // 2021.08.24 제외 (사용안함)
        // 2. 추가서식 가져오기
        //List<Map<String, Object>> subFormList = cctr0020_Service.ccta0030_doSearchAdditionalForm(param);
        
        // 개발여부
        String localServerFlag = "N";
        if(PropertiesManager.getBoolean("eversrm.system.localserver") || PropertiesManager.getBoolean("eversrm.system.developmentFlag")) {
            localServerFlag = "Y";
        }
        
    	req.setAttribute("PDF_ATT_FILE_NUM", param.get("PDF_ATT_FILE_NUM"));
        req.setAttribute("localServerFlag", localServerFlag);  
        req.setAttribute("signDate", EverDate.getDate() + EverDate.getTime());
        //req.setAttribute("subFormList", subFormList); 
        
        return "/nhepro/CCTR/CCTA0030";
    }
    
    // 계약번호 클릭시 eform의 저장데이터 가져오기
    @RequestMapping(value = "/CCTA0030/ccta0030_doUpdateEformJsonData")
    public void ccta0030_doUpdateEformJsonData(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> formData = req.getFormData();
        formData.put("EFORM_INPUT_VALUE_CLOB", req.getParameter("EFORM_INPUT_VALUE_CLOB"));
        cctr0020_Service.ccta0030_doUpdateEformJsonData(formData);
    }
	
    // eform 생성시 eform 데이터 가져오기
	@RequestMapping(value = "/CCTA0030/ccta0030_doSelectEformJsonData") 
	public void ccta0030_doSelectEformJsonData(EverHttpRequest req, EverHttpResponse resp) throws Exception { Map<String, String> formData = req.getFormData();
		 String jsonData = cctr0020_Service.ccta0030_doSelectEformJsonData(formData);
		 resp.setParameter("EFORM_INPUT_VALUE_CLOB", jsonData); 
	}
	 
	// main 폼 가져오기
    @RequestMapping(value = "/CCTA0030/ccta0030_doSearchMainForm")
    public void ccta0030_doSearchMainForm(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> param = req.getFormData();
        param.put("BASIC_SEARCH", req.getParameter("BASIC_SEARCH"));

        resp.setGridObject("gridM", cctr0020_Service.ccta0030_doSearchMainForm(param));
        resp.setResponseCode("true");
    }
    
    // sub 폼 가져오기
    @RequestMapping(value = "/CCTA0030/ccta0030_doSearchAdditionalForm")
    public void ccta0030_doSearchAdditionalForm(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> param = req.getFormData();
        param.put("ADD_SEARCH", req.getParameter("ADD_SEARCH"));

        String selectedFormNum = req.getParameter("selectedFormNum");
        String bundleFlag = req.getParameter("bundleFlag");

        param.put("FORM_NUM", selectedFormNum);
        param.put("bundleFlag", String.valueOf(StringUtils.equals(bundleFlag, "1")));   // 일괄여부가 Y인 것만 조회할지

        resp.setGridObject("gridA", cctr0020_Service.ccta0030_doSearchAdditionalForm(param));
        resp.setResponseCode("true");
    }

    /**
     * 계약서 주서식 조회
     * @param req
     * @param resp
     * @throws Exception
     */
    @RequestMapping(value = "/CCTA0030/ccta0030_getContractForm")
    public void becf030_getContractForm(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	
        Map<String, String> param = req.getFormData();
        
        param.put("CONT_NUM", req.getParameter("CONT_NUM"));
        param.put("CONT_CNT", req.getParameter("CONT_CNT"));
        param.put("selectedFormNum", req.getParameter("selectedFormNum"));
        param.put("formContents", req.getParameter("formContents"));

        String resultContractForm = cctr0020_Service.ccta0030_getFormWithManualContractInfo(req, resp, param, param.get("bundleFlag").equals("1") ? null : req.getGridData("gridECCM"));
        resp.setParameter("contractForm", resultContractForm);
        
        resp.setResponseCode("true");
    }

    /**
     * 부서식 조회
     * @param req
     * @param resp
     * @throws Exception
     */
    @RequestMapping(value = "/CCTA0030/ccta0030_getSubContractForm")
    public void becf030_getSubContractForm(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> param = req.getFormData();

        param.put("CONT_NUM", req.getParameter("CONT_NUM"));
        param.put("CONT_CNT", req.getParameter("CONT_CNT"));
        param.put("FORM_NUM", req.getParameter("selectedFormNum"));

        String resultContractForm = cctr0020_Service.ccta0030_getFormWithManualContractInfo(req, resp, param, null);
        resp.setParameter("contractForm", resultContractForm);
        
        resp.setResponseCode("true");
    }

    /**
     * 계약 고객사 조회 (STOCECCM)
     * @param req
     * @param resp
     * @throws Exception
     */
    @RequestMapping(value = "/CCTA0030/ccta0030_doSearchECCM")
    public void ccta0030_doSearchECCM(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.setGridObject("gridECCM", cctr0020_Service.ccta0030_doSearchECCM(req.getFormData()));
    }
    
    /**
     * 선정품의 기준 품목정보 조회 (STOCCNDT)
     * @param req
     * @param resp
     * @throws Exception
     */
    @RequestMapping(value = "/CCTA0030/ccta0030_doSearchCNDT")
    public void ccta0030_doSearchCNDT(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.setGridObject("gridECMT", cctr0020_Service.ccta0030_doSearchCNDT(req.getFormData()));
        resp.setResponseCode("true");
    }

    /**
     * 계약서 기준 품목정보 조회 (STOCECMT)
     * @param req
     * @param resp
     * @throws Exception
     */
    @RequestMapping(value = "/CCTA0030/ccta0030_doSearchECMT")
    public void ccta0030_doSearchECMT(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	
    	Map<String, String> param = req.getFormData();
        resp.setGridObject("gridECMT", cctr0020_Service.ccta0030_doSearchECMT(param));
        resp.setResponseCode("true");
    }

    /**
     * 계약서 저장
     *
     * @param req
     * @param resp
     * @throws Exception
     */
    @RequestMapping(value = "/CCTA0030/ccta0030_doSave")
    public void doSaveContract(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> dataForm = req.getFormData();

        List<Map<String, Object>> gridDataM = req.getGridData("gridM");
        List<Map<String, Object>> gridDataA = req.getGridData("gridA");
        List<Map<String, Object>> gridDataECCM = req.getGridData("gridECCM");
        List<Map<String, Object>> gridDataECMT = req.getGridData("gridECMT");

        dataForm.put("PROGRESS_CD", Code.M135_4200);
        dataForm.put("SIGN_STATUS", Code.M020_T);
        Map<String, String> resultMap = cctr0020_Service.ccta0030_doSaveContract(dataForm, gridDataM, gridDataA, gridDataECCM, gridDataECMT);

        resp.setParameter("CONT_NUM", resultMap.get("CONT_NUM"));
        resp.setParameter("CONT_CNT", String.valueOf(resultMap.get("CONT_CNT")));
        
        resp.setResponseMessage(msg.getMessage("0001"));
        resp.setResponseCode("true");
    }
    
    /**
     * 2021.03.08 : 계약서 협력사 공유 기능 추가
     * @param req
     * @param resp
     * @throws Exception
     */
    @RequestMapping(value = "/CCTA0030/ccta0030_doVendorSend")
    public void ccta0030_doVendorSend(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> dataForm = req.getFormData();
        Map<String, String> resultMap = cctr0020_Service.ccta0030_doVendorSend(dataForm);

        resp.setParameter("CONT_NUM", resultMap.get("CONT_NUM"));
        resp.setParameter("CONT_CNT", String.valueOf(resultMap.get("CONT_CNT")));
        
        resp.setResponseMessage(msg.getMessage("0001"));
        resp.setResponseCode("true");
    }

    /**
     * 계약체결 기안 요청
     *
     * @param req
     * @param resp
     * @throws Exception
     */
    @RequestMapping(value = "/CCTA0030/ccta0030_doReqSign")
    public void becm030_doReqSign(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> dataForm = req.getFormData();

        dataForm.put("mainContractContents", req.getParameter("mainContractContents"));
        dataForm.put("gwUseFlag", req.getParameter("gwUseFlag"));

        List<Map<String, Object>> gridDataM = req.getGridData("gridM");
        List<Map<String, Object>> gridDataA = req.getGridData("gridA");
        List<Map<String, Object>> gridDataECCM = req.getGridData("gridECCM");
        List<Map<String, Object>> gridDataECMT = req.getGridData("gridECMT");

        dataForm.put("PROGRESS_CD", Code.M135_4206);
        dataForm.put("SIGN_STATUS", Code.M020_P);
        Map<String, String> resultMap = cctr0020_Service.ccta0030_doReqSign(dataForm, gridDataM, gridDataA, gridDataECCM, gridDataECMT);

        resp.setParameter("CONT_NUM", resultMap.get("CONT_NUM"));
        resp.setParameter("CONT_CNT", String.valueOf(resultMap.get("CONT_CNT")));

        resp.setResponseMessage(msg.getMessage("0001"));
        resp.setResponseCode("true");
    }

    /**
     * 계약서 삭제
     *
     * @param req
     * @param resp
     * @throws Exception
     */
    @RequestMapping(value = "/CCTA0030/ccta0030_doDeleteContract")
    public void doDeleteContract(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> formData = req.getFormData();
        cctr0020_Service.ccta0030_doDeleteContract(formData);

        resp.setResponseMessage(msg.getMessage("0001"));
        resp.setResponseCode("true");
    }

    /**
     * 운영사 계약서서명 (계약체결완료)
     * 계약체결 완료 후 계약번호 및 차수 return
     * @param req
     * @param resp
     * @throws Exception
     */
    @RequestMapping(value = "/CCTA0030/ccta0030_doSign")
    public void ccta0030_doSign(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	
    	Map<String, String> formData = cctr0020_Service.ccta0030_signContract(req, resp, req.getGridData("gridECCM"));
    	
    	resp.setParameter("CONT_NUM", formData.get("CONT_NUM"));
        resp.setParameter("CONT_CNT", String.valueOf(formData.get("CONT_CNT")));
    }
    
    /**
     * 2021.02.09 기능 추가
     * 협력사 전자서명 계약서 재서명요청
     * @param req
     * @param resp
     * @throws Exception
     */
    @RequestMapping(value = "/CCTA0030/ccta0030_doReSend")
    public void ccta0030_doReSend(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	
    	Map<String, String> formData = req.getFormData();
        cctr0020_Service.ccta0030_doReContract(formData);

        resp.setResponseMessage(msg.getMessage("0001"));
        resp.setResponseCode("true");
    }

    /**
     * 수기계약 계약완료
     *
     * @param req
     * @param resp
     * @throws Exception
     */
    @RequestMapping(value = "/CCTA0030/ccta0030_doFinishContract")
    public void doFinishContract(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> formData = cctr0020_Service.ccta0030_doFinishContract(req, resp);

        resp.setParameter("CONT_NUM", formData.get("CONT_NUM"));
        resp.setParameter("CONT_CNT", String.valueOf(formData.get("CONT_CNT")));
    }

    @RequestMapping(value = "/CCTA0030/ccta0030_doPdf")
    public void ccta0030_doPdf(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        String pdfHtml = req.getParameter("pdfHtml").replaceAll("&#37", "%").replaceAll("&#39", "'")
                .replaceAll("&lt;", "<").replaceAll("&gt;", ">");

        // pdf 변환 경로 설정
        WrapperConfig wc = new WrapperConfig("C:\\Program Files\\wkhtmltopdf\\bin\\wkhtmltopdf.exe");
        // 경로 주입
        Pdf pdf = new Pdf(wc);
        // 변환 html 내용
        pdf.addPageFromString("<html><head><meta charset=\"utf-8\"></head>" + pdfHtml + "</html>");
        try {
            pdf.saveAs("output.pdf");
        } catch(Exception e) {
            getLog().error(e.getMessage(), e);
//          System.out.println(e);
        }
    }

    @RequestMapping(value = "/CCTA0030/ccta0030_doPdfHashCode")
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
    
    /**
     * 2021.07.30 기능 추가
     * 고객사 전자서명전 전자보증 취소요청건 존재여부 체크
     */
    @RequestMapping(value = "/CCTA0030/ccta0030_guarCancelData")
    public void ccta0030_guarCancelData(EverHttpRequest req, EverHttpResponse resp) throws Exception {

    	Map<String, String> param = req.getFormData();
    	Map<String, String> rtnMsg = cctr0020_Service.ccta0030_guarCancelData(param);
    	
        resp.setResponseCode(rtnMsg.get("rtnCode"));
        resp.setResponseMessage(rtnMsg.get("rtnMsg"));
    }

    /**
     * 개별계약서 작성 화면
     *
     * @param req
     * @param resp
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/CCTR0050/view")
    public String CCTR0050(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        req.setAttribute("formTypes", commonComboService.getCodeComboAsJson("M078"));
        req.setAttribute("fromDate", EverDate.addDateMonth(EverDate.getDate(), -3));
        req.setAttribute("toDate", EverDate.addDateMonth(EverDate.getDate(), 1));
        return "/nhepro/CCTR/CCTR0050";
    }

    @RequestMapping(value="/CCTR0050/cctr0050_doSearch")
    public void cctr0050_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	
    	Map<String, String> param = req.getFormData();
    	
    	String MergeFlag = EverString.nullToEmptyString(param.get("MERGE_FLAG"));
        String type = EverString.nullToEmptyString(param.get("TYPE").substring(0, 1));
        param.put("TYPE", type);
        resp.setGridObject("grid", cctr0020_Service.cctr0050_doSearch(param));
        resp.setParameter("MergeFlag", MergeFlag);
    }
    
    /**
     * 2021.08.26
     * 계약서명 클릭시 계약서별 품목현황 조회
     */
    @RequestMapping(value = "/CCTR0050/cctr0050_doSearchECMT")
    public void cctr0050_doSearchECMT(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	
    	Map<String, String> param = req.getFormData();
    	
        String buyerCd = EverString.nullToEmptyString(param.get("SCH_BUYER_CD"));
        if( buyerCd != null && !"".equals(buyerCd) ) {
        	param.put("BUYER_CD", buyerCd);
        }
        String contNum = EverString.nullToEmptyString(param.get("SCH_CONT_NUM"));
        if( contNum != null && !"".equals(contNum) ) {
        	param.put("CONT_NUM", contNum);
        }
        String contCnt = EverString.nullToEmptyString(param.get("SCH_CONT_CNT"));
        if( contCnt != null && !"".equals(contCnt) ) {
        	param.put("CONT_CNT", contCnt);
        }
        
        resp.setGridObject("gridI", cctr0020_Service.ccta0030_doSearchECMT(param));
        resp.setResponseCode("true");
    }
    
    @RequestMapping(value="/CCTR0050/cctr0050_changeContUser")
    public void cctr0050_changeContUser(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        cctr0020_Service.cctr0050_changeContUser(req.getFormData(), req.getGridData("grid"));
    }

    // BECM_050(계약현황) : 계약체결중단
    @RequestMapping(value="/CCTR0050/cctr0050_doStop")
    public void cctr0050_doStop(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        cctr0020_Service.cctr0050_doStop(req.getFormData(), req.getGridData("grid"));
    }
    
    /**
     * 2021.08.26 : IT포탈 의뢰번호 등 저장
     * @param req
     * @param resp
     * @throws Exception
     */
    @RequestMapping(value="/CCTR0050/cctr0050_doSave")
    public void cctr0050_doSave(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	
    	Map<String, String> rtnMap = cctr0020_Service.cctr0050_doSave(req.getGridData("gridI"));
        resp.setResponseMessage(rtnMap.get("rtnMsg"));
    }
    
    // PDF 검증
    @RequestMapping(value="/CCTR0050/cctr0050_doPdfValid")
    public void cctr0050_doPdfValid(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> pdfFileInfo = cctr0020_Service.cctr0050_doPdfFileInfo(req.getParamDataMap());

        String targetPath = pdfFileInfo.get("FILE_PATH");
        String targetFileNm = pdfFileInfo.get("UUID") + "_" + pdfFileInfo.get("UUID_SQ") + "." + pdfFileInfo.get("FILE_EXTENSION");

        String binaryFile = EverFile.fileToBinary(targetPath, targetFileNm);
        Map<String, String> binaryMap = new HashMap<>();
        binaryMap.put("url", PropertiesManager.getString("block.chain.verify"));
        binaryMap.put("strFromFile", binaryFile);
        JSONObject jsonObject = EverRestJson.actionAPI(binaryMap);
        resp.setResponseMessage(jsonObject.get("msg").toString());
    }

    @RequestMapping(value = "/CCTR0051/view")
    public String CCTR0051(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        req.setAttribute("form", req.getParamDataMap());
        return "/nhepro/CCTR/CCTR0051";
    }

    @RequestMapping(value="/CCTR0051/cctr0051_doSearch")
    public void cctr0051_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.setGridObject("grid", cctr0020_Service.cctr0051_doSearch(req.getFormData()));
    }

    @RequestMapping(value="/CCTR0051/cctr0051_doSave")
    public void cctr0051_doSave(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        cctr0020_Service.cctr0051_doSave(req.getFormData(), req.getGridData("grid"));
    }
    
    //2021.03.11 협력업체 보증 취소요청 승인
    @RequestMapping(value = "/CCTR0051/cctr0051_doConfirm")
    public void cctr0051_doConfirm(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        List<Map<String, Object>> grid = req.getGridData("grid");

        Map<String, String> rtnMap = cctr0020_Service.cctr0051_doConfirm(req.getFormData(), grid);

        resp.setResponseMessage(rtnMap.get("rtnMsg"));
    }
    
    //2021.03.11 협력업체 보증 취소요청 반려
    @RequestMapping(value = "/CCTR0051/cctr0051_doReject")
    public void cctr0051_doReject(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        List<Map<String, Object>> grid = req.getGridData("grid");

        Map<String, String> rtnMap = cctr0020_Service.cctr0051_doReject(req.getFormData(), grid);

        resp.setResponseMessage(rtnMap.get("rtnMsg"));
    }

    @RequestMapping(value = "/CCTR0052/view")
    public String CCTR0052(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        req.setAttribute("form", req.getParamDataMap());
        return "/nhepro/CCTR/CCTR0052";
    }

    @RequestMapping(value="/CCTR0052/cctr0052_doSearch")
    public void cctr0052_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.setGridObject("grid", cctr0020_Service.cctr0052_doSearch(req.getFormData()));
    }

    @RequestMapping(value = "/CCTR0053/view")
    public String CCTR0053(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        req.setAttribute("form", req.getParamDataMap());
        return "/nhepro/CCTR/CCTR0053";
    }

    @RequestMapping(value="/CCTR0053/cctr0053_doSearch")
    public void cctr0053_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	
        resp.setGridObject("grid", cctr0020_Service.cctr0053_doSearch(req.getFormData()));
    }

    @RequestMapping(value = "/CCTR0054/view")
    public String CCTR0054(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	
        req.setAttribute("form", req.getParamDataMap());
        return "/nhepro/CCTR/CCTR0054";
    }

    @RequestMapping(value="/CCTR0054/cctr0054_doSearch")
    public void cctr0054_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	
        resp.setGridObject("grid", cctr0020_Service.cctr0054_doSearch(req.getFormData()));
    }

    @RequestMapping(value="/CCTR0050/cctr0050_doFinish")
    public void cctr0050_doFinish(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	
        cctr0020_Service.cctr0050_doFinish(req.getFormData(), req.getGridData("grid"));
    }

    @RequestMapping(value="/CCTR0050/cctr0050_doUpdate")
    public void cctr0050_doUpdate(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	
        cctr0020_Service.cctr0050_doUpdate(req.getGridData("grid"));
    }

    // 변경계약서작성
    @RequestMapping(value="/CCTR0050/cctr0050_doResume")
    public void cctr0050_doResume(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> param = req.getFormData();
        List<Map<String, Object>> gridData = req.getGridData("grid");
        List<Map<String, Object>> cont_num_cnt = null;
        Boolean bundleFlag = false;

        if(StringUtils.isNotEmpty(param.get("BUNDLE_NUM"))) {
            cont_num_cnt =  new ObjectMapper().readValue(param.get("CONT_NUM_CNT"), List.class);
            bundleFlag = true;
        }

        String msg = "SUCCESS";
        String isResumeFlag = "";
        if(bundleFlag) {
            isResumeFlag = cctr0020_Service.cctr0050_doResumeCheck2(param, cont_num_cnt);
        } else {
            isResumeFlag = cctr0020_Service.cctr0050_doResumeCheck(gridData);
        }

        // 이미 해당 차수의 수정/재계약이 진행중인 경우
        if( "1".equals(isResumeFlag) ){
            msg = "1";
        } else {
            if(bundleFlag) {
                Map<String, Object> resultMap = cctr0020_Service.cctr0050_doResume2(param, cont_num_cnt);

                resp.setParameter("BUNDLE_NUM", String.valueOf(resultMap.get("BUNDLE_NUM")));
                resp.setParameter("CONT_NUM_CNT", EverConverter.getJsonString(resultMap.get("CONT_NUM_CNT")));
            } else {
                Map<String, String> resultMap = cctr0020_Service.cctr0050_doResume(param, gridData);

                resp.setParameter("CONT_NUM", resultMap.get("CONT_NUM"));
                resp.setParameter("CONT_CNT", String.valueOf(resultMap.get("CONT_CNT")));
            }
        }

        resp.setResponseMessage(msg);
    }

    @RequestMapping(value = "/CCTA0040/view")
    public String CCTA0040(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> parameterMap = req.getParamDataMap();

        // 1. 계약내용 가져오기
        cctr0020_Service.ccta0040_getBundleContractInfo(req, resp, parameterMap);
        
        // 2021.08.06 제외 (사용안함)
        // 2. 추가서식 가져오기
        //List<Map<String, Object>> subFormList = cctr0020_Service.ccta0030_doSearchAdditionalForm(parameterMap);
        
        String localServerFlag = "N";
        if( PropertiesManager.getBoolean("eversrm.system.localserver")) {
            localServerFlag = "Y";
        }
        
        // 2021.08.31 : 공인, 사설인증서 서명 수정
        // ipoid : 법인용 공인인증기관 공인인증서, iboid : 법인용 블럭체인 사설인증서, pboid : 개인용 블럭체인 사설인증서
        String ipoidFilter = PropertiesManager.getString("magicline.certverify.ipoid");
        req.setAttribute("ipoidFilter", ipoidFilter);
        
        String iboidFilter = PropertiesManager.getString("magicline.certverify.iboid");
        req.setAttribute("iboidFilter", iboidFilter);
        
        req.setAttribute("PDF_ATT_FILE_NUM", parameterMap.get("PDF_ATT_FILE_NUM"));
        req.setAttribute("localServerFlag", localServerFlag);
        req.setAttribute("signDate", EverDate.getDate() + EverDate.getTime());
        //req.setAttribute("subFormList", subFormList);

        return "/nhepro/CCTR/CCTA0040";
    }

    /**
     * 일괄계약서 저장
     *
     * @param req
     * @param resp
     * @throws Exception
     */
    @RequestMapping(value = "/CCTA0040/ccta0040_doSave")
    public void ccta0040_doSave(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> dataForm = req.getFormData();
        dataForm.put("mainContractContents", req.getParameter("mainContractContents"));

        List<Map<String, Object>> gridDataM = req.getGridData("gridM");
        List<Map<String, Object>> gridDataA = req.getGridData("gridA");
        List<Map<String, Object>> gridDataV = req.getGridData("gridV");
        dataForm.put("SIGN_STATUS", Code.M020_T);
        Map<String, Object> resultMap = cctr0020_Service.ccta0040_doSave(dataForm, gridDataM, gridDataA, gridDataV);
        
        resp.setParameter("BUNDLE_NUM", (String)resultMap.get("BUNDLE_NUM"));
        resp.setParameter("CONT_TYPE", (String)resultMap.get("CONT_TYPE"));
    }
    
    /**
     * 계약서작성(단일업체)인 경우 PDF_ATT_FILE_NUM은 STOCECPC에 저장한다
     * @param req
     * @param resp
     * @throws Exception
     */
    @RequestMapping(value = "/CCTA0030/ccta0030_doUpdatePdfUUID")
    public void ccta0030_doUpdatePdfUUID(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> param = req.getParamDataMap();
        
        Map jsonData = new ObjectMapper().readValue(param.get("json"), Map.class);
        cctr0020_Service.ccta0030_doUpdatePdfUUID(jsonData);
    }
    
    /**
     * 2021.04.07 추가
     * 계약서작성(다수업체)인 경우 PDF_ATT_FILE_NUM은 STOCECCM에 저장한다
     * @param req
     * @param resp
     * @throws Exception
     */
    @RequestMapping(value = "/CCTA0040/ccta0040_doUpdatePdfUUID")
    public void ccta0040_doUpdatePdfUUID(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> param = req.getParamDataMap();
        
        Map jsonData = new ObjectMapper().readValue(param.get("json"), Map.class);
        cctr0020_Service.ccta0040_doUpdatePdfUUID(jsonData);
    }

    /**
     * 발주사 전자서명 (4230 => 4300)
     * @param req
     * @param resp
     * @throws Exception
     */
    @RequestMapping(value = "/CCTA0040/ccta0040_doSign")
    public void ccta0040_doSign(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	
    	Map<String, String> formData = cctr0020_Service.ccta0040_signContract(req, resp, req.getGridData("gridV"));
    	resp.setParameter("BUNDLE_NUM", formData.get("BUNDLE_NUM"));
        resp.setParameter("CONT_TYPE" , String.valueOf(formData.get("CONT_TYPE")));
    }

    /**
     * 운영사 계약서 서명
     *
     * @param req
     * @param resp
     * @throws Exception
     */
    @RequestMapping(value = "/CCTA0040/ccta0040_doUpdateVendorFile")
    public void ccta0040_doUpdateVendorFile(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	
    	Map<String, String> param = req.getFormData();
    	param.put("BUNDLE_NUM", req.getParameter("BUNDLE_NUM"));
        
        cctr0020_Service.ccta0040_doUpdateVendorFile(param);
    }

    /**
     * 협력사 전자서명 (4210 => 4230)
     * @param req
     * @param resp
     * @throws Exception
     */
    @RequestMapping(value = "/CCTA0040/ccta0040_doSignBuyer")
    public void ccta0040_doSignBuyer(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	
    	Map<String, String> formData = cctr0020_Service.ccta0040_signContractBuyer(req, resp, req.getGridData("gridV"));
    	resp.setParameter("BUNDLE_NUM", formData.get("BUNDLE_NUM"));
        resp.setParameter("CONT_TYPE" , String.valueOf(formData.get("CONT_TYPE")));
    }

    /**
     * 계약서 서명
     *
     * @param req
     * @param resp
     * @throws Exception
     */
    @RequestMapping(value = "/CCTA0040/ccta0040_doSignCompleteTSA")
    public void ccta0040_doSignCompleteTSA(EverHttpRequest req, EverHttpResponse resp) throws Exception {

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
        EverFile.binaryToFile(jsonObject.get("data").toString(), targetDirectory, targetFileNm);
    }

    /**
     * 일괄계약서 협력사 계약서 삭제
     * @param req
     * @param resp
     * @throws Exception
     */
    @RequestMapping(value = "/CCTA0040/ccta0040_doDeleteContract")
    public void ccta0040_doDeleteContract(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        cctr0020_Service.ccta0040_doDeleteContract(req.getFormData(), req.getGridData("gridV"));
    }

    @RequestMapping(value = "/CCTA0040/ccta0040_doSearchBundelInfo")
    public void ccta0040_doSearchBundelInfo(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> formData = req.getFormData();
        formData.put("BUNDLE_NUM", req.getParameter("BUNDLE_NUM"));
        if (Integer.parseInt(req.getParameter("BUNDLE_CNT")) > 1) {
            formData.put("CONT_NUM", "");
            formData.put("CONT_CNT", "");
        }
        List<Map<String, Object>> contInfo = cctr0020_Service.ccta0040_doSearchBundelInfo(formData);

        resp.setParameter("CONT_INFO", EverConverter.getJsonString(contInfo));
    }

    /**
     * 일괄 계약서 삭제
     *
     * @param req
     * @param resp
     * @throws Exception
     */
    @RequestMapping(value = "/CCTA0040/ccta0040_doDeleteBundleContract")
    public void ccta0040_doDeleteBundleContract(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        cctr0020_Service.ccta0040_doDeleteContract(req.getFormData(), req.getGridData("gridV"));
    }

    /**
     * 일괄 계약체결 기안 요청
     *
     * @param req
     * @param resp
     * @throws Exception
     */
    @RequestMapping(value = "/CCTA0040/ccta0040_doReqSign")
    public void ccta0040_doReqSign(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> dataForm = req.getFormData();

        List<Map<String, Object>> gridDataM = req.getGridData("gridM");
        List<Map<String, Object>> gridDataA = req.getGridData("gridA");
        List<Map<String, Object>> gridDataV = req.getGridData("gridV");

        dataForm.put("PROGRESS_CD", Code.M135_4206);
        dataForm.put("SIGN_STATUS", Code.M020_P);
        Map<String, String> resultMap = cctr0020_Service.ccta0040_doReqSign(dataForm, gridDataM, gridDataA, gridDataV);

        resp.setParameter("BUNDLE_NUM", resultMap.get("BUNDLE_NUM"));
        resp.setResponseCode("true");
    }

    /**
     * 일괄계약으로 저장된 협력회사 상세 목록을 조회한다.
     *
     * @param req
     * @param resp
     * @throws Exception
     */
    @RequestMapping(value = "/CCTA0040/ccta0040_getSavedVendorListForBundleContract")
    public void ccta0040_getSavedVendorListForBundleContract(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        List<Map<String, Object>> resultList = cctr0020_Service.ccta0040_getSavedVendorListForBundleContract(req.getFormData());
        resp.setGridObject("gridV", resultList);
    }

    /**
     * 일괄계약서 - 협력회사 엑셀 업로드 시 협력회사 코드기준으로 모든 데이터를 조회하여 그리드에 출력
     *
     * @param req
     * @param resp
     * @throws Exception
     */
    @RequestMapping(value = "/CCTA0040/ccta0040_getVendorListForBundleContract")
    public void ccta0040_getVendorListForBundleContract(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        List<Map<String, Object>> vndList = new ArrayList<Map<String, Object>>();
        List<Map<String, Object>> gridVData  = req.getGridData("gridV");
        List<Map<String, Object>> resultList = cctr0020_Service.ccta0040_getVendorListForBundleContract(gridVData);

        for(Map<String, Object> param1 : resultList ) {
            for(Map<String, Object> param2 : gridVData ) {
                if( (param1.get("VENDOR_CD")).equals(param2.get("VENDOR_CD")) ){
                    Map<String, Object> map = new HashMap<String, Object>();
                    map.put("VENDOR_CD", param1.get("VENDOR_CD"));
                    map.put("VENDOR_NM", param1.get("VENDOR_NM"));
                    map.put("VENDOR_PIC_USER_NM", param2.get("VENDOR_PIC_USER_NM"));
                    map.put("VENDOR_PIC_USER_EMAIL", param2.get("VENDOR_PIC_USER_EMAIL"));
                    map.put("VENDOR_PIC_USER_CELL_NUM", param2.get("VENDOR_PIC_USER_CELL_NUM"));

                    vndList.add(map);
                    break;
                }
            }
        }

        resp.setGridObject("gridV", vndList);
    }
    
    /**
 	 * 농협정보(C00007)인 경우 ERP 전송
 	 * @param req
 	 * @param resp
 	 * @throws Exception
 	 */
 	@RequestMapping(value="/CCTR0050/doSendErp")
 	public void CCTR0050_doSendErp(EverHttpRequest req, EverHttpResponse resp) throws Exception {
 		Map<String, String> param = req.getFormData();
 		List<Map<String, Object>> gridData = req.getGridData("grid");
 		
 		contsenderpservice.sendErp(gridData.get(0));
 		resp.setResponseMessage(msg.getMessage("0001"));
 	}
 	
 	/**
 	 * 2021.07.16 : 중앙회(C00009) IT전략본부(00032)인 경우 ITPortal 전송
 	 * @param req
 	 * @param resp
 	 * @throws Exception
 	 */
 	@RequestMapping(value="/CCTR0050/doSendITPortal")
 	public void CCTR0050_doSendITPortal(EverHttpRequest req, EverHttpResponse resp) throws Exception {
 		
 		Map<String, String> param = req.getFormData();
 		param.put("CONT_NUM_CNT", EverString.nullToEmptyString(req.getParameter("CONT_NUM_CNT")));
 		
 		bnh0011_Service.doExecService(param);
 		resp.setResponseMessage(msg.getMessage("0001"));
 	}
 	
 	@RequestMapping(value = "/CCTR0055/view")
    public String CCTR0055(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        req.setAttribute("fromDate", EverDate.addDateMonth(EverDate.getDate(), -3));
        req.setAttribute("toDate", EverDate.addDateMonth(EverDate.getDate(), 1));
        return "/nhepro/CCTR/CCTR0055";
    }
 	
 	@RequestMapping(value="/CCTR0055/cctr0055_doSearch")
    public void cctr0055_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.setGridObject("grid", cctr0020_Service.cctr0055_doSearch(req.getFormData()));
    }
 	
    /**
     * 전자서명 검증화면
     *
     * @param req
     * @param resp
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/CCTA0099/view")
    public String CCTA0099(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	return "/nhepro/CCTR/CCTA0099";
    }
    
    /**
     * 발주사 다건 전자서명 (4230 => 4300)
     * @param req
     * @param resp
     * @throws Exception
     */
    @RequestMapping(value = "/CCTR0050/cctr0050_doMultiSign")
    public void cctr0050_doMultiSign(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	cctr0020_Service.cctr0050_MultiSign(req, resp, req.getGridData("grid"));
    }      
    
	@RequestMapping(value = "/CCTA0030/ccta0030_doSelectEformJsonDataM") 
	public void ccta0030_doSelectEformJsonDataM(EverHttpRequest req, EverHttpResponse resp) throws Exception { 
		 Map<String, String> formData = req.getFormData();
	     formData.put("BUNDLE_NUM", req.getParameter("BUNDLE_NUM"));
	     formData.put("CONT_NUM", req.getParameter("CONT_NUM"));
	     formData.put("CONT_CNT", req.getParameter("CONT_CNT"));
	     formData.put("BUYER_CD", req.getParameter("BUYER_CD"));
		 String jsonData = cctr0020_Service.ccta0030_doSelectEformJsonData(formData);
		 resp.setParameter("EFORM_INPUT_VALUE_CLOB", jsonData); 
	 }    
	
    @RequestMapping(value = "/CCTA0040/ccta0040_doSearchBundelInfoM")
    public void ccta0040_doSearchBundelInfoM(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> formData = req.getFormData();
	    formData.put("BUNDLE_NUM", req.getParameter("BUNDLE_NUM"));
	    formData.put("CONT_NUM", req.getParameter("CONT_NUM"));
	    formData.put("CONT_CNT", req.getParameter("CONT_CNT"));
        List<Map<String, Object>> contInfo = cctr0020_Service.ccta0040_doSearchBundelInfo(formData);
        resp.setParameter("CONT_INFO", EverConverter.getJsonString(contInfo));
    }	    
}

