package com.st_ones.nhepro.CCPI.web;

import java.util.List;

import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.st_ones.common.combo.service.CommonComboService;
import com.st_ones.common.enums.system.Code;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.util.clazz.EverDate;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.nhepro.CCPI.service.CCPI1300_Service;


/*
파일명 : CCPI1300_Controller.java
화면ID : CCPI1300
화면명 : 계약서작성(일용직근로계약서)
작성자 : 백태훈
생성일 : 2022.10.18

*/
@Controller
@RequestMapping(value = "/nhepro/CCPI")
public class CCPI1300_Controller {
    @Autowired
    private MessageService msg;
    @Autowired
    private CCPI1300_Service ccpi1300_Service;



    @RequestMapping(value="/CCPI1300/view")
    public String CCPI1300(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        //req.setAttribute("fromDate", EverDate.addDateMonth(EverDate.getDate(), -3));
        //req.setAttribute("toDate", EverDate.addDateMonth(EverDate.getDate(),2));
       
       Map<String, String> parameterMap = req.getParamDataMap();
       //계약내용 가져오기 	
       ccpi1300_Service.ccpi1300_getBundleContractInfo(req, resp, parameterMap);
    	  	
       req.setAttribute("toDate", EverDate.getDate());
        return "/nhepro/CCPI/CCPI1300";
    }
    
 // main 폼 가져오기
    @RequestMapping(value = "/CCPI1300/ccpi1300_doSearchMainForm")
    public void ccpi1300_doSearchMainForm(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> param = req.getFormData();
        param.put("BASIC_SEARCH", req.getParameter("BASIC_SEARCH"));

        resp.setGridObject("gridM", ccpi1300_Service.ccpi1300_doSearchMainForm(param));
        resp.setResponseCode("true");
    }
    
    // sub 폼 가져오기
    @RequestMapping(value = "/CCPI1300/ccpi1300_doSearchAdditionalForm")
    public void ccpi1300_doSearchAdditionalForm(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> param = req.getFormData();
        param.put("ADD_SEARCH", req.getParameter("ADD_SEARCH"));

        String selectedFormNum = req.getParameter("selectedFormNum");
        String bundleFlag = req.getParameter("bundleFlag");

        param.put("FORM_NUM", selectedFormNum);
        param.put("bundleFlag", String.valueOf(StringUtils.equals(bundleFlag, "1")));   // 일괄여부가 Y인 것만 조회할지

        resp.setGridObject("gridA", ccpi1300_Service.ccpi1300_doSearchAdditionalForm(param));
        resp.setResponseCode("true");
    }
    
    /**
     * 일괄계약서 저장
     *
     * @param req
     * @param resp
     * @throws Exception
     */
    @RequestMapping(value = "/CCPI1300/ccpi1300_doSave")
    public void ccpi1300_doSave(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> dataForm = req.getFormData();
       // dataForm.put("mainContractContents", req.getParameter("mainContractContents"));

        List<Map<String, Object>> gridDataM = req.getGridData("gridM");
        List<Map<String, Object>> gridDataA = req.getGridData("gridA");
        List<Map<String, Object>> gridDataV = req.getGridData("gridV");
        dataForm.put("SIGN_STATUS", Code.M020_T);
        System.out.println(gridDataV);
        Map<String, Object> resultMap = ccpi1300_Service.ccpi1300_doSave(dataForm, gridDataM, gridDataA, gridDataV);
        
        resp.setParameter("BUNDLE_NUM", (String)resultMap.get("BUNDLE_NUM"));
        resp.setParameter("CONT_TYPE", (String)resultMap.get("CONT_TYPE"));
    }
    
    /**
     * 일괄계약으로 저장된 개인근로자 상세 목록을 조회한다.
     *
     * @param req
     * @param resp
     * @throws Exception
     */
    @RequestMapping(value = "/CCPI1300/ccpi1300_getSavedEmpListForBundleContract")
    public void ccpi1300_getSavedVendorListForBundleContract(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        List<Map<String, Object>> resultList = ccpi1300_Service.ccpi1300_getSavedEmpListForBundleContract(req.getFormData());
        resp.setGridObject("gridV", resultList);
    }
    
    /**
     * 일괄 계약서 삭제
     *
     * @param req
     * @param resp
     * @throws Exception
     */
    @RequestMapping(value = "/CCPI1300/ccpi1300_doDeleteBundleContract")
    public void ccpi1100_doDeleteBundleContract(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	ccpi1300_Service.ccpi1300_doDeleteContract(req.getFormData(), req.getGridData("gridV"));
    }
    
    /**
     * 일괄 계약체결 기안 요청
     *
     * @param req
     * @param resp
     * @throws Exception
     */
    @RequestMapping(value = "/CCPI1300/ccpi1300_doReqSign")
    public void ccpi1200_doReqSign(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	
        Map<String, String> dataForm = req.getFormData();

        List<Map<String, Object>> gridDataM = req.getGridData("gridM");
        List<Map<String, Object>> gridDataA = req.getGridData("gridA");
        List<Map<String, Object>> gridDataV = req.getGridData("gridV");

        dataForm.put("PROGRESS_CD", Code.M135_4206);
        dataForm.put("SIGN_STATUS", Code.M020_P);
        Map<String, String> resultMap = ccpi1300_Service.ccpi1300_doReqSign(dataForm, gridDataM, gridDataA, gridDataV);

        resp.setParameter("BUNDLE_NUM", resultMap.get("BUNDLE_NUM"));
        //2022.10.04 cont_num, cont_cnt추가 
        resp.setParameter("CONT_NUM", resultMap.get("CONT_NUM"));
        resp.setParameter("CONT_CNT", resultMap.get("CONT_CNT"));
        
        System.out.println("-------BUNDLE_NUM--------"+resultMap.get("BUNDLE_NUM"));
        System.out.println("-------CONT_NUM--------"+resultMap.get("CONT_NUM"));
        System.out.println("-------CONT_CNT--------"+resultMap.get("CONT_CNT"));
        resp.setResponseMessage(msg.getMessage("0001"));
        resp.setResponseCode("true");
    }
    
    //근로자 서명완료 후 PDF 데이터 가져오기
   	@RequestMapping(value = "/CCPI1300/ccpi1300_doSelectPdfJsonData") 
   	public void ccpi1300_doSelectPdfJsonData(EverHttpRequest req, EverHttpResponse resp) throws Exception {
   		
   		 Map<String, String> param = req.getFormData();
   		 param.put("CONT_NUM", req.getParameter("CONT_NUM"));
   		 String jsonData = ccpi1300_Service.ccpi1300_doSelectPdfJsonData(param);
   		 resp.setParameter("PDF_VALUE", jsonData); 
   		
   	}
    
    /**
     * 
     * STOCATCH 저장 후  PDF_ATT_FILE_NUM은 STOCTCCT에 저장한다
     * @param req
     * @param resp
     * @throws Exception
     */
    @RequestMapping(value = "/CCPI1300/ccpi1300_doUpdatePdfUUID")
    public void ccpi1300_doUpdatePdfUUID(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> param = req.getParamDataMap();
        
        Map jsonData = new ObjectMapper().readValue(param.get("json"), Map.class);
        ccpi1300_Service.ccpi1300_doUpdatePdfUUID(jsonData);
    }
    
    
    /**
     * 계약체결완료 후 첨부파일 저장
     *
     * @param req
     * @param resp
     * @throws Exception
     */
    @RequestMapping(value = "/CCPI1300/ccpi1300_doSavePdf")
    public void ccpi1000_doSavePdf(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> dataForm = req.getFormData();
       // dataForm.put("mainContractContents", req.getParameter("mainContractContents"));

       
        List<Map<String, Object>> gridDataV = req.getGridData("gridV");
       // dataForm.put("SIGN_STATUS", Code.M020_T);
        Map<String, Object> resultMap = ccpi1300_Service.ccpi1300_doSavePdf(dataForm, gridDataV);
        
        resp.setParameter("BUNDLE_NUM", (String)resultMap.get("BUNDLE_NUM"));
        resp.setParameter("CONT_TYPE", (String)resultMap.get("CONT_TYPE"));
    }
    

}
