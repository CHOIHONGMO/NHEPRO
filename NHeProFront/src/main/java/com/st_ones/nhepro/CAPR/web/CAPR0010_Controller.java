package com.st_ones.nhepro.CAPR.web;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.st_ones.common.combo.service.CommonComboService;
import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.util.clazz.EverDate;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.nhepro.CAPR.service.CAPR0010_Service;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : CAPR0010_Controller.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

@Controller
@RequestMapping(value = "/nhepro/CAPR")
public class CAPR0010_Controller extends BaseController {

    @Autowired private CAPR0010_Service capr0010_service;
    @Autowired private CommonComboService commonComboService;
    @Autowired private MessageService msg;

    /**
     * 화면명 : 대금지급현황
     * 처리내용 : 대금지급요청 현황을 조회하여 심사 및 지급내역을 등록하는 화면
     * 경로 : 고객사 > 발주관리 > 대금지급 > 대금지급현황
     */
    @RequestMapping(value="/CAPR0010/view")
    public String CAPR0010(EverHttpRequest req) throws Exception {
    	
        UserInfo userInfo = UserInfoManager.getUserInfo();
        boolean havePermission = false;
        
        // BR030 : 구매담당자권한, BR040 : 계약담당자
        if((userInfo.getCtrlCd()).contains("BR030") || (userInfo.getCtrlCd()).contains("BR040")) {
        	havePermission = true;
        }
        // BR900 : 관리자직무(업무담당자 변경가능 직무)
        String ManagerCd = EverString.nullToEmptyString(PropertiesManager.getString("eversrm.customer.admin.ManagerCd"));
        if((userInfo.getCtrlCd()).contains(ManagerCd)) {
        	havePermission = true;
        }
        havePermission = EverString.nullToEmptyString(userInfo.getSuperUserFlag()).equals("1") ? true : havePermission;
        
        req.setAttribute("havePermission", havePermission);
        req.setAttribute("FROM_DATE", EverDate.addDateMonth(EverDate.getDate(), -1));
        req.setAttribute("TO_DATE", EverDate.getDate());

        return "/nhepro/CAPR/CAPR0010";
    }

    // 조회
    @RequestMapping(value = "/capr0010_doSearch")
    public void capr0010_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> param = req.getFormData();

        param.put("SEL_BUYER", req.getParamDataMap().get("SEL_BUYER"));

        resp.setGridObject("grid", capr0010_service.capr0010_doSearch(param));
    }

    // 대금지급담당자 변경
    @RequestMapping(value = "/capr0010_doUpdateChange")
    public void capr0010_doUpdateChange(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        List<Map<String, Object>> grid = req.getGridData("grid");

        Map<String, String> rtnMap = capr0010_service.capr0010_doUpdateChange(req.getFormData(), grid);

        resp.setResponseMessage(rtnMap.get("rtnMsg"));
    }
    
    // 2021.11.18 Multi 결재상신 기능추가
    @RequestMapping(value = "/capr0010_doUpdateApproval")
    public void capr0010_doUpdateApproval(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	
        List<Map<String, Object>> grid = req.getGridData("grid");
        Map<String, String> rtnMap = capr0010_service.capr0010_doUpdateApproval(req.getFormData(), grid);
        
        resp.setResponseMessage(rtnMap.get("rtnMsg"));
    }
    
    // 대금지급 등록
    @RequestMapping(value = "/capr0010_doUpdatePayReg")
    public void capr0010_doUpdatePayReg(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	
        List<Map<String, Object>> grid = req.getGridData("grid");
        Map<String, String> rtnMap = capr0010_service.capr0010_doUpdatePayReg(req.getFormData(), grid);
        
        resp.setResponseMessage(rtnMap.get("rtnMsg"));
    }

    /**
     * 화면명 : 대금지급요청서
     * 처리내용 : 대금청구요청서 상세내역을 확인하고 내부 의사결정을 위한 품의를 진행하는 화면
     * 경로 : 고객사 > 발주관리 > 대금지급 > 대금지급현황 > 대금지급요청서 (팝업)
     */
    @RequestMapping(value="/CAPR0011/view")
    public String CAPR0011(EverHttpRequest req) throws Exception {
    	
        Map<String, String> param = req.getParamDataMap();
        Map<String, Object> data = capr0010_service.capr0011_doSearchIVHD(param);
        
        req.setAttribute("formData", data);
        return "/nhepro/CAPR/CAPR0011";
    }

    // 품목정보, 조회
    @RequestMapping(value = "/capr0011_doSearchIVDT")
    public void capr0011_doSearchIVDT(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        
    	Map<String, String> param = req.getParamDataMap();
        resp.setGridObject("gridPODT", capr0010_service.capr0011_doSearchIVDT(req.getFormData(), param));
    }

    // 대금지급요청 이력, 조회
    @RequestMapping(value = "/capr0011_doSearchIVAP")
    public void sapi0011_doSearchIVAP(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        
    	Map<String, String> param = req.getParamDataMap();
        resp.setGridObject("gridIVAP", capr0010_service.capr0011_doSearchIVAP(req.getFormData(), param));
    }
    
    // 2021.12.13 멀티결재상신 전 대금지급요청서 내용 수정필요 저장기능 추가
    @RequestMapping(value = "/capr0011_doUpdateIVAP")
    public void capr0011_doUpdateIVAP(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	
        Map<String, String> rtnMap = capr0010_service.capr0011_doUpdateIVAP(req.getFormData());
        
        resp.setParameter("BUYER_CD", rtnMap.get("BUYER_CD"));
 		resp.setParameter("AP_NUM", rtnMap.get("AP_NUM"));
 		
        resp.setResponseMessage(msg.getMessage("0001"));
    }

    // 반송
    @RequestMapping(value = "/capr0011_doReject")
    public void capr0011_doReject(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        
    	List<Map<String, Object>> gridPODT = req.getGridData("gridPODT");
        Map<String, String> rtnMap = capr0010_service.capr0011_doReject(req.getFormData(), gridPODT);
        
        resp.setResponseMessage(rtnMap.get("rtnMsg"));
    }

    // 결재상신
    @RequestMapping(value = "/capr0011_doUpdateApproval")
    public void capr0011_doUpdateApproval(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	
        Map<String, String> rtnMap = capr0010_service.capr0011_doUpdateApproval(req.getFormData());
        resp.setResponseMessage(rtnMap.get("rtnMsg"));
    }
    
    /**
     * PDF_ATT_FILE_NUM은 STOCIVAP에 저장한다
     * @param req
     * @param resp
     * @throws Exception
     */
    @RequestMapping(value = "/capr0011_doUpdatePdfUUID")
    public void capr0011_doUpdatePdfUUID(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> param = req.getParamDataMap();
        System.out.println("================ PDF_ATT_FILE_NUM 저장 ================");
        Map jsonData = new ObjectMapper().readValue(param.get("json"), Map.class);
        capr0010_service.capr0011_doUpdatePdfUUID(jsonData);
    }

}
