package com.st_ones.nhepro.CCTR.web;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.st_ones.common.combo.service.CommonComboService;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.message.service.MessageType;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.nhepro.CCTR.service.CCTR0012_Service;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : CCTR0012_Controller.java
 * @date 2020.04.13
 * @version 1.0
 * @see
 */

@Controller
@RequestMapping(value = "/nhepro/CCTR")
public class CCTR0012_Controller extends BaseController{
    @Autowired
    private MessageService msg;
    @Autowired
    private CCTR0012_Service cctr0012_Service;
    @Autowired
    private CommonComboService commonComboService;

	/**
	 * 화면명 :
	 * 처리내용 :
	 * 경로 :  > >
	 */
    @RequestMapping(value="/CCTR0012/view")
    public String CCTR0012(EverHttpRequest req) throws Exception {
        //req.setAttribute("defaultFromDate", EverDate.addDays(-7));
        //req.setAttribute("defaultToDate", EverDate.getDate());

        return "/nhepro/CCTR/CCTR0012";
    }

	/**
	 * 화면명 :
	 * 처리내용 :
	 * 경로 :  > >
	 */
    @RequestMapping(value="/CCTR0012/cctr0012_doSearch")
    public void CCTR0012_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> param = req.getFormData();
        
        resp.setGridObject("grid", cctr0012_Service.cctr0012_doSearch(param));
    }

    /**
     * 화면명 :
     * 처리내용 :
     * 경로 :  > >
     */
    @RequestMapping(value="/CCTR0012/cctr0012_doCopy")
    public void cctr0012_doCopy(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	
        List<Map<String, Object>> gridData = req.getGridData("grid");
        cctr0012_Service.cctr0012_doCopy(gridData);
    }
    
    @RequestMapping(value="/CCTR0012/cctr0012_doUpdate")
    public void cctr0012_doUpdate(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	
        List<Map<String, Object>> gridData = req.getGridData("grid");
        cctr0012_Service.cctr0012_doUpdate(gridData);
    }

	/**
	 * 화면명 :
	 * 처리내용 :
	 * 경로 :  > >
	 */
    @RequestMapping(value="/CCTR0012/cctr0012_doDelete")
    public void cctr0012_doDelete(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        List<Map<String, Object>> gridData = req.getGridData("grid");

        cctr0012_Service.cctr0012_doDelete(gridData);
    }

    /**
     * 서식등록
     * @param req
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/CCTI0013/view")
    public String CCTI0013(EverHttpRequest req) throws Exception {

    	Map<String, String> param = req.getFormData();
    	
    	String buyerCd   = req.getParameter("BUYER_CD");
 		String formNum   = req.getParameter("FORM_NUM");
 		String appDocNum = req.getParameter("appDocNum");
 		String appDocCnt = req.getParameter("appDocCnt");

 		if( EverString.isNotEmpty(formNum) || (EverString.isNotEmpty(appDocNum) && EverString.isNotEmpty(appDocCnt)) ) {
 			param.put("BUYER_CD", buyerCd);
 			param.put("FORM_NUM", formNum);
 			param.put("APP_DOC_NUM", appDocNum);
 			param.put("APP_DOC_CNT", appDocCnt);
 			
        	req.setAttribute("form", cctr0012_Service.ccti0013_doSearch(param));
 		}
        
        return "/nhepro/CCTR/CCTI0013";
    }

    // 서식관리의 부서식
    @RequestMapping(value = "/CCTI0013/ccti0013_doSearchECCR")
    public void ccti0013_doSearchECCR(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	
 	    
        resp.setGridObject("grid", cctr0012_Service.ccti0013_doSearchECCR(req.getFormData()));
    }

    // 서식 저장 
    @RequestMapping(value = "/CCTI0013/ccti0013_doSave")
    public void ccti0013_doSave(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> formData = req.getFormData();
        formData.put("FORM_TEXT", req.getParameter("FORM_TEXT"));
        formData.put("APP_USE_FLAG", req.getParameter("APP_USE_FLAG"));
        formData.put("SAVE_END_FLAG", req.getParameter("SAVE_END_FLAG"));        
                

        String formNum = cctr0012_Service.ccti0013_doSave(formData, req.getGridData("grid"));
        resp.setResponseMessage(msg.getMessage(MessageType.SAVE_SUCCEED));
        resp.setParameter("FORM_NUM", formNum);
    }
    


}

