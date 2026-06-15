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
import com.st_ones.nhepro.CCTR.service.CCTR0010_Service;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : CCTR0010_Controller.java
 * @date 2020.04.13
 * @version 1.0
 * @see
 */

@Controller
@RequestMapping(value = "/nhepro/CCTR")
public class CCTR0010_Controller extends BaseController{
    @Autowired
    private MessageService msg;
    @Autowired
    private CCTR0010_Service cctr0010_Service;
    @Autowired
    private CommonComboService commonComboService;

	/**
	 * 화면명 :
	 * 처리내용 :
	 * 경로 :  > >
	 */
    @RequestMapping(value="/CCTR0010/view")
    public String CCTR0010(EverHttpRequest req) throws Exception {
        //req.setAttribute("defaultFromDate", EverDate.addDays(-7));
        //req.setAttribute("defaultToDate", EverDate.getDate());

        return "/nhepro/CCTR/CCTR0010";
    }

	/**
	 * 화면명 :
	 * 처리내용 :
	 * 경로 :  > >
	 */
    @RequestMapping(value="/CCTR0010/cctr0010_doSearch")
    public void CCTR0010_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> param = req.getFormData();

        resp.setGridObject("grid", cctr0010_Service.cctr0010_doSearch(param));
    }

    /**
     * 화면명 :
     * 처리내용 :
     * 경로 :  > >
     */
    @RequestMapping(value="/CCTR0010/cctr0010_doCopy")
    public void cctr0010_doCopy(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	
        List<Map<String, Object>> gridData = req.getGridData("grid");
        cctr0010_Service.cctr0010_doCopy(gridData);
    }
    
    @RequestMapping(value="/CCTR0010/cctr0010_doUpdate")
    public void cctr0010_doUpdate(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	
        List<Map<String, Object>> gridData = req.getGridData("grid");
        cctr0010_Service.cctr0010_doUpdate(gridData);
    }

	/**
	 * 화면명 :
	 * 처리내용 :
	 * 경로 :  > >
	 */
    @RequestMapping(value="/CCTR0010/cctr0010_doDelete")
    public void cctr0010_doDelete(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        List<Map<String, Object>> gridData = req.getGridData("grid");

        cctr0010_Service.cctr0010_doDelete(gridData);
    }

    /**
     * 서식등록
     * @param req
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/CCTI0011/view")
    public String CCTI0011(EverHttpRequest req) throws Exception {

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
 			
        	req.setAttribute("form", cctr0010_Service.ccti0011_doSearch(param));
 		}
        
        return "/nhepro/CCTR/CCTI0011";
    }

    // 서식관리의 부서식
    @RequestMapping(value = "/CCTI0011/ccti0011_doSearchECCR")
    public void ccti0011_doSearchECCR(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.setGridObject("grid", cctr0010_Service.ccti0011_doSearchECCR(req.getFormData()));
    }

    // 서식 저장 / 결재요청
    @RequestMapping(value = "/CCTI0011/ccti0011_doSave")
    public void ccti0011_doSave(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> formData = req.getFormData();
        formData.put("FORM_TEXT", req.getParameter("FORM_TEXT"));
        formData.put("APP_USE_FLAG", req.getParameter("APP_USE_FLAG"));

        Map<String, String> returnData = cctr0010_Service.ccti0011_doSave(formData, req.getGridData("grid"));
        
        resp.setResponseMessage(msg.getMessage(MessageType.SAVE_SUCCEED));
        resp.setParameter("BUYER_CD", returnData.get("BUYER_CD"));
        resp.setParameter("FORM_NUM", returnData.get("FORM_NUM"));
    }
    
    // 부서식 저장
    @RequestMapping(value = "/CCTI0011/ccti0011_doSubSave")
    public void ccti0011_doSubSave(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        cctr0010_Service.ccti0011_doSubSave(req.getGridData("grid"));
        resp.setResponseMessage(msg.getMessage(MessageType.SAVE_SUCCEED));
    }

}

