package com.st_ones.nhepro.CSTR.web;

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
import com.st_ones.nhepro.CSTR.service.CSTR0010_Service;


/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2014 ST-Ones CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : CSTR0010_Controller.java
 * @date 2020. 5. 18.
 * @version 1.0
 */
@Controller
@RequestMapping(value = "/nhepro/CSTR")
public class CSTR0010_Controller extends BaseController { 

    @Autowired private CommonComboService commonComboService;
    @Autowired private CSTR0010_Service cstr_Service;

    
    /**
     * 화면명 : 공급사 입찰이력
     * 처리내용 : 입찰이력 조회
     * 경로 : 고객사 > 통계관리 > 통계관리 > 공급사 입찰이력
     */
    @RequestMapping(value="/CSTR0010/view")
    public String cstr0010_view(EverHttpRequest req) throws Exception {
        req.setAttribute("fromDate", EverDate.addDateMonth(EverDate.getDate(), -3));
        req.setAttribute("toDate", EverDate.addDateMonth(EverDate.getDate(), 0));
        return "/nhepro/CSTR/CSTR0010";
    }

    @RequestMapping(value = "/cstr0010_doSearch")
    public void cstr0010_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	List<Map<String, Object>> searchList = cstr_Service.cstr0010_doSearch(req.getFormData());
    	
        for (int i = 0; i < searchList.size(); i++) {
        	Map<String, Object> grid = searchList.get(i);
        	String BID_STATUS_NM = String.valueOf(grid.get("BID_STATUS_NM"));
        	if (BID_STATUS_NM.equals("낙찰")) {
            	resp.setGridCellStyle("grid", String.valueOf(i), "BID_STATUS_NM", "color", "#0000FF");
        	} else {
            	resp.setGridCellStyle("grid", String.valueOf(i), "BID_STATUS_NM", "color", "#000000");
        	}
        }    	

        resp.setGridObject("grid", searchList);
    }
    
    /**
     * 화면명 : 대금지급이력
     * 처리내용 : 검수 및 대금지급 이력조회
     * 경로 : 고객사 > 통계관리 > 통계관리 > 대금지급이력
     */
    @RequestMapping(value="/CSTR0020/view")
    public String cstr0020_view(EverHttpRequest req) throws Exception {
        req.setAttribute("fromDate", EverDate.addDateMonth(EverDate.getDate(), -3));
        req.setAttribute("toDate", EverDate.addDateMonth(EverDate.getDate(), 0));
        return "/nhepro/CSTR/CSTR0020";
    }

    @RequestMapping(value = "/cstr0020_doSearch")
    public void cstr0020_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	List<Map<String, Object>> searchList = cstr_Service.cstr0020_doSearch(req.getFormData());

        resp.setGridObject("grid", searchList);
    }
    
    /**
     * 화면명 : 공급사 견적이력
     * 처리내용 : 견적이력 조회
     * 경로 : 고객사 > 통계관리 > 통계관리 > 공급사 견적이력
     */
    @RequestMapping(value="/CSTR0030/view")
    public String cstr0030_view(EverHttpRequest req) throws Exception {
        req.setAttribute("FROM_DATE", EverDate.addDateMonth(EverDate.getDate(), -2));
        req.setAttribute("TO_DATE", EverDate.addDateMonth(EverDate.getDate(), 0));
        return "/nhepro/CSTR/CSTR0030";
    }

    @RequestMapping(value = "/cstr0030_doSearch")
    public void cstr0030_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	
    	Map<String, String> param = req.getFormData();
    	
    	param.put("SEL_DATE", req.getParamDataMap().get("SEL_DATE"));
    	
    	List<Map<String, Object>> searchList = cstr_Service.cstr0030_doSearch(param);
    	
        resp.setGridObject("grid", searchList);
    }


}