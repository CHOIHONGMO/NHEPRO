package com.st_ones.nhepro.CCPR.web;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.util.clazz.EverConverter;
import com.st_ones.common.util.clazz.EverDate;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.nhepro.CCPR.service.CCPR1010_Service;

/*
파일명 : CCPR1010_Controller.java
화면ID : CCPR1010
화면명 : 계약체결진행현황
작성자 : 백태훈
생성일 : 2022.09.28

*/

@Controller
@RequestMapping(value = "/nhepro/CCPR")
public class CCPR1010_Controller {
    @Autowired
    private MessageService msg;
    @Autowired
    private CCPR1010_Service ccpr1010_Service;
    
	/**
	 * 화면명 : 계약체결진행현황
	 * 처리내용 :
	 * 경로 :  > >
	 */    
    @RequestMapping(value="/CCPR1010/view")
    public String ccpr1010_view(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        //req.setAttribute("fromDate", EverDate.addDateMonth(EverDate.getDate(), -3));
        //req.setAttribute("toDate", EverDate.addDateMonth(EverDate.getDate(),2));
       
       Map<String, String> parameterMap = req.getParamDataMap();
       UserInfo userInfo = UserInfoManager.getUserInfo();
       boolean havePermission = false;
       
       // BR100 : 직무관리자(계약담당자 변경가능 직무)
       String ctrlCd = EverString.nullToEmptyString(PropertiesManager.getString("eversrm.customer.admin.ctrlCd"));
       if((userInfo.getCtrlCd()).contains(ctrlCd)) {
       	havePermission = true;
       }
       
       havePermission = EverString.nullToEmptyString(userInfo.getSuperUserFlag()).equals("1") ? true : havePermission;
       //계약내용 가져오기 	
       //ccpi1200_Service.ccpi1200_getBundleContractInfo(req, resp, parameterMap);
	   req.setAttribute("havePermission", havePermission);
       req.setAttribute("fromDate", EverDate.addDateMonth(EverDate.getDate(), -1));
       req.setAttribute("toDate", EverDate.addDateMonth(EverDate.getDate(),3));
        return "/nhepro/CCPR/CCPR1010";
    }
	/**
	 * 화면명 : 계약체결현황
	 * 처리내용 :
	 * 경로 :  > >
	 */    
    @RequestMapping(value="/CCPR1010_B/view")
    public String ccpr1010_B_view(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        //req.setAttribute("fromDate", EverDate.addDateMonth(EverDate.getDate(), -3));
        //req.setAttribute("toDate", EverDate.addDateMonth(EverDate.getDate(),2));
       
       Map<String, String> parameterMap = req.getParamDataMap();
       UserInfo userInfo = UserInfoManager.getUserInfo();
       
       boolean havePermission = false;
       
       // BR100 : 직무관리자(계약담당자 변경가능 직무)
       String ctrlCd = EverString.nullToEmptyString(PropertiesManager.getString("eversrm.customer.admin.ctrlCd"));
       if((userInfo.getCtrlCd()).contains(ctrlCd)) {
       	havePermission = true;
       }
       
       havePermission = EverString.nullToEmptyString(userInfo.getSuperUserFlag()).equals("1") ? true : havePermission;
       
       //계약내용 가져오기 	
	   req.setAttribute("havePermission", havePermission);
	   req.setAttribute("fromDate", EverDate.addDateMonth(EverDate.getDate(), -1));
       req.setAttribute("toDate", EverDate.addDateMonth(EverDate.getDate(),3));
        return "/nhepro/CCPR/CCPR1010_B";
    }

	/**
	 * 화면명 : 거래처/현장명 팝업
	 * 처리내용 :
	 * 경로 :  > >
	 */  
    @RequestMapping(value="/CCPR0010/view")
    public String CCPR0010(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        req.setAttribute("form", req.getParamDataMap());
        return "/nhepro/CCPR/CCPR0010";
    }
    
 	@RequestMapping(value = "/CCPR1010/doSearch")
 	public void ccpr1010_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {

 		Map<String, String> param = req.getFormData();
 		resp.setGridObject("grid", ccpr1010_Service.ccpr1010_doSearch(param));
 	}
 	
 	@RequestMapping(value = "/CCPR1010_B/doSearch")
 	public void ccpr1010_B_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {

 		Map<String, String> param = req.getFormData();
 		resp.setGridObject("grid", ccpr1010_Service.ccpr1010_doSearch(param));
 	}
 	// 개인근로자 전자서명요청
 	@RequestMapping(value="/CCPR1010/doRequest")
 	public void ccpr1010_doRequest(EverHttpRequest req, EverHttpResponse resp) throws Exception {
 		Map<String, String> param = req.getFormData();
 		List<Map<String, Object>> gridData = req.getGridData("grid");

 		ccpr1010_Service.ccpr1010_doRequest(gridData);
 		resp.setResponseMessage(msg.getMessage("0001"));
 	}
 	
 	// 개인근로자 계약체결중단
 	@RequestMapping(value="/CCPR1010/doStop")
 	public void ccpr1010_doStop(EverHttpRequest req, EverHttpResponse resp) throws Exception {
 		Map<String, String> param = req.getFormData();
 		List<Map<String, Object>> gridData = req.getGridData("grid");

 		ccpr1010_Service.ccpr1010_doStop(param, gridData);
 		resp.setResponseMessage(msg.getMessage("0001"));
 	}
 	//거래처별 현장명 조회
 	@RequestMapping(value = "/CCPR0010/ccpr0010_doSearch")
 	public void ccpr0010_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
 		
 		Map<String, String> param = req.getFormData();
 		resp.setGridObject("grid", ccpr1010_Service.ccpr0010_doSearch(param));
 	}
 
 	
}
