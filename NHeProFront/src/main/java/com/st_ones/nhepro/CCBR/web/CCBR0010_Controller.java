package com.st_ones.nhepro.CCBR.web;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.st_ones.common.combo.service.CommonComboService;
import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.common.util.clazz.EverDate;
import com.st_ones.common.util.clazz.EverMath;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.nhepro.CCBR.service.CCBR0010_Service;


/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2014 ST-Ones CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : CCBR0010_Controller.java
 * @date 2024. 4. 01.
 * @version 1.0
 */
@Controller
@RequestMapping(value = "/nhepro/CCBR")
public class CCBR0010_Controller extends BaseController { 

    @Autowired private CommonComboService commonComboService;
    @Autowired private CCBR0010_Service ccbr_Service;

    
    /**
     * 화면명 : 후불수수료청구내역
     * 처리내용 : 후불수수료청구내역 조회
     * 경로 : 고객사 > 마감관리 > 마감관리 > 후불수수료청구내역
     */
    @RequestMapping(value="/CCBR0010/view")
    public String ccbr0010_view(EverHttpRequest req) throws Exception {
    	req.setAttribute("STD_YEAR", EverDate.getYear());
        return "/nhepro/CCBR/CCBR0010";
    }

    @RequestMapping(value = "/ccbr0010_doSearch")
    public void cstr0010_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {

    	Map<String, String> param = req.getFormData();
    	String buyerCd = param.get("BUYER_CD");
    	String stdPreYear = String.valueOf(Integer.parseInt(param.get("STD_YEAR")) - 1);
    	String stdYear = param.get("STD_YEAR");
    	String stdQuarter = param.get("STD_QUARTER");
    	
    	if(stdQuarter != null && "10".equals(stdQuarter)) {
	        param.put("OCC_FROM_DATE", stdPreYear + "1201");
	        param.put("OCC_TO_DATE", stdYear + "0229");
    	} else if(stdQuarter != null && "20".equals(stdQuarter)) {    
	        param.put("OCC_FROM_DATE", stdYear + "0301");
	        param.put("OCC_TO_DATE", stdYear + "0531");
    	} else if(stdQuarter != null && "20".equals(stdQuarter)) {
    		param.put("OCC_FROM_DATE", stdYear + "0601");
	        param.put("OCC_TO_DATE", stdYear + "0831");
    	} else {
    		param.put("OCC_FROM_DATE", stdYear + "0901");
	        param.put("OCC_TO_DATE", stdYear + "1130");
    	}
	        
        if(buyerCd != null && "C08761".equals(buyerCd)) {	//운영 농협파트너스 고객사 코드
        //if(buyerCd != null && "C05861".equals(buyerCd)) {	//개발 테스트용 농협파트너스 고객사 코드
        	Map<String, Object> rtnMap = ccbr_Service.ccbr0010_doSearchPTSUM(param);
        	if(rtnMap == null) {
                resp.setParameter("pyCostSum", "0");
                resp.setParameter("pyVatSum", "0");
                resp.setParameter("pyAmt", "0");
            } else {
                resp.setParameter("pyCostSum", EverString.nullToEmptyString(String.valueOf(rtnMap.get("PY_COST_SUM"))).equals("") ? "0" : String.valueOf(rtnMap.get("PY_COST_SUM")));
                resp.setParameter("pyVatSum", EverString.nullToEmptyString(String.valueOf(rtnMap.get("PY_VAT_SUM"))).equals("") ? "0" : String.valueOf(rtnMap.get("PY_VAT_SUM")));
                resp.setParameter("pyAmt", EverString.nullToEmptyString(String.valueOf(rtnMap.get("PY_AMT"))).equals("") ? "0" : String.valueOf(rtnMap.get("PY_AMT")));
            }
        	
        	resp.setGridObject("grid", ccbr_Service.ccbr0010_doSearchPT(param));
        } else {
        	Map<String, Object> rtnMap = ccbr_Service.ccbr0010_doSearchSUM(param);
        	if(rtnMap == null) {
                resp.setParameter("pyCostSum", "0");
                resp.setParameter("pyVatSum", "0");
                resp.setParameter("pyAmt", "0");
            } else {
                resp.setParameter("pyCostSum", EverString.nullToEmptyString(String.valueOf(rtnMap.get("PY_COST_SUM"))).equals("") ? "0" : String.valueOf(rtnMap.get("PY_COST_SUM")));
                resp.setParameter("pyVatSum", EverString.nullToEmptyString(String.valueOf(rtnMap.get("PY_VAT_SUM"))).equals("") ? "0" : String.valueOf(rtnMap.get("PY_VAT_SUM")));
                resp.setParameter("pyAmt", EverString.nullToEmptyString(String.valueOf(rtnMap.get("PY_AMT"))).equals("") ? "0" : String.valueOf(rtnMap.get("PY_AMT")));
            }
        	
        	resp.setGridObject("grid", ccbr_Service.ccbr0010_doSearch(param));
        }
    }
    
    /**
     * 화면명 : SMS수수료청구내역
     * 처리내용 : SMS수수료청구내역
     * 경로 : 경로 : 고객사 > 마감관리 > 마감관리 > SMS수수료청구내역
     */
    @RequestMapping(value="/CCBR0020/view")
    public String ccbr0020_view(EverHttpRequest req) throws Exception {
    	req.setAttribute("STD_YEAR", EverDate.getYear());
        return "/nhepro/CCBR/CCBR0020";
    }

    @RequestMapping(value = "/ccbr0020_doSearch")
    public void ccbr0020_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	Map<String, String> param = req.getFormData();
    	String buyerCd = param.get("BUYER_CD");
    	String stdPreYear = String.valueOf(Integer.parseInt(param.get("STD_YEAR")) - 1);
    	String stdYear = param.get("STD_YEAR");
    	String stdQuarter = param.get("STD_QUARTER");
    	
    	if(stdQuarter != null && "10".equals(stdQuarter)) {
	        param.put("OCC_FROM_DATE", stdPreYear + "1201");
	        param.put("OCC_TO_DATE", stdYear + "0229");
    	} else if(stdQuarter != null && "20".equals(stdQuarter)) {    
	        param.put("OCC_FROM_DATE", stdYear + "0301");
	        param.put("OCC_TO_DATE", stdYear + "0531");
    	} else if(stdQuarter != null && "20".equals(stdQuarter)) {
    		param.put("OCC_FROM_DATE", stdYear + "0601");
	        param.put("OCC_TO_DATE", stdYear + "0831");
    	} else {
    		param.put("OCC_FROM_DATE", stdYear + "0901");
	        param.put("OCC_TO_DATE", stdYear + "1130");
    	}
	        
        if(buyerCd != null && "C08761".equals(buyerCd)) {	//운영 농협파트너스 고객사 코드
        //if(buyerCd != null && "C05861".equals(buyerCd)) {	//개발 테스트용 농협파트너스 고객사 코드
        	Map<String, Object> rtnMap = ccbr_Service.ccbr0020_doSearchSMSPTSUM(param);
        	if(rtnMap == null) {
                resp.setParameter("pyCostSum", "0");
                resp.setParameter("pyVatSum", "0");
                resp.setParameter("pyAmt", "0");
            } else {
                resp.setParameter("pyCostSum", EverString.nullToEmptyString(String.valueOf(rtnMap.get("PY_COST_SUM"))).equals("") ? "0" : String.valueOf(rtnMap.get("PY_COST_SUM")));
                resp.setParameter("pyVatSum", EverString.nullToEmptyString(String.valueOf(rtnMap.get("PY_VAT_SUM"))).equals("") ? "0" : String.valueOf(rtnMap.get("PY_VAT_SUM")));
                resp.setParameter("pyAmt", EverString.nullToEmptyString(String.valueOf(rtnMap.get("PY_AMT"))).equals("") ? "0" : String.valueOf(rtnMap.get("PY_AMT")));
            }
        	
        	resp.setGridObject("grid", ccbr_Service.ccbr0020_doSearchSMSPT(param));
        } else {
        	Map<String, Object> rtnMap = ccbr_Service.ccbr0020_doSearchSMSSUM(param);
        	if(rtnMap == null) {
                resp.setParameter("pyCostSum", "0");
                resp.setParameter("pyVatSum", "0");
                resp.setParameter("pyAmt", "0");
            } else {
                resp.setParameter("pyCostSum", EverString.nullToEmptyString(String.valueOf(rtnMap.get("PY_COST_SUM"))).equals("") ? "0" : String.valueOf(rtnMap.get("PY_COST_SUM")));
                resp.setParameter("pyVatSum", EverString.nullToEmptyString(String.valueOf(rtnMap.get("PY_VAT_SUM"))).equals("") ? "0" : String.valueOf(rtnMap.get("PY_VAT_SUM")));
                resp.setParameter("pyAmt", EverString.nullToEmptyString(String.valueOf(rtnMap.get("PY_AMT"))).equals("") ? "0" : String.valueOf(rtnMap.get("PY_AMT")));
            }
        	
        	resp.setGridObject("grid", ccbr_Service.ccbr0020_doSearchSMS(param));
        }
    }    
}