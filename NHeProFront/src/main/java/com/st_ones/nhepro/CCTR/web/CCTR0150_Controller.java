package com.st_ones.nhepro.CCTR.web;

import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.common.util.clazz.EverDate;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.nhepro.CCTR.service.CCTR0150_Service;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : CCTR0150_Controller.java
 * @date 2021.06.23
 * @version 1.0
 * @see
 */

@Controller
@RequestMapping(value = "/nhepro/CCTR")
public class CCTR0150_Controller extends BaseController {
	
    @Autowired
    private CCTR0150_Service cctr0150_Service;
    
    /**
     * 계약체결현황(감사용)
     * @param req
     * @param resp
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/CCTR0150/view")
    public String CCTR0150(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	
        req.setAttribute("fromDate", EverDate.addDateMonth(EverDate.getDate(), -12));
        req.setAttribute("toDate", EverDate.addDateMonth(EverDate.getDate(), 1));
        
        return "/nhepro/CCTR/CCTR0150";
    }

    @RequestMapping(value="/CCTR0150/cctr0150_doSearch")
    public void cctr0150_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	
    	Map<String, String> param = req.getFormData();
    	
    	String MergeFlag = EverString.nullToEmptyString(param.get("MERGE_FLAG"));
    	
    	// BR900(업무관리자) 직무를 갖는 사람은 자신의 계약건만 조회함
    	UserInfo userInfo = UserInfoManager.getUserInfo();
    	String ctrlCd = userInfo.getCtrlCd();
    	if (StringUtils.isNotEmpty(ctrlCd) && ctrlCd.indexOf("BR900") > -1) {
    		param.put("ADMIN_FLAG", "1");
    	}
    	
        resp.setGridObject("grid", cctr0150_Service.cctr0150_doSearch(param));
        resp.setParameter("MergeFlag", MergeFlag);
    }
    
    @RequestMapping(value = "/CCTR0150/cctr0150_doSearchECMT")
    public void cctr0150_doSearchECMT(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	
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
        
        resp.setGridObject("gridI", cctr0150_Service.cctr0150_doSearchECMT(param));
        resp.setResponseCode("true");
    }
    
    @RequestMapping(value = "/CCTR0150/cctr0150_doSave")
    public void cctr0150_doSave(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	
        List<Map<String, Object>> gridData = req.getGridData("grid");
        String resultMsg = cctr0150_Service.cctr0150_doSave(gridData);
        
        resp.setResponseMessage(resultMsg);
        resp.setResponseCode("true");
    }
    
}

