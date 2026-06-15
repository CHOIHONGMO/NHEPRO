package com.st_ones.nhepro.OVNR.web;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.st_ones.common.util.clazz.EverDate;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.nhepro.OVNR.service.OVNR0030_Service;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : OVNR0030_Controller.java
 * @date 2020. 09. 16.
 * @version 1.0
 */

@Controller
@RequestMapping(value = "/nhepro/OVNR")
public class OVNR0030_Controller extends BaseController {

    @Autowired private OVNR0030_Service ovnr0030_service;
    
    /**
     * 화면명 : 신규업체대기현황
     * 처리내용 : 신규로 등록한 협력사를 승인하는 화면
     * 경로 : 고객사 > 기준정보 > 협력업체관리 > 신규업체대기현황
     */
    @RequestMapping(value="/OVNR0030/view")
    public String OVNR0030(EverHttpRequest req) {
        req.setAttribute("regFromDate", EverDate.addDateMonth(EverDate.getDate(), -1));
        req.setAttribute("regToDate", EverDate.addDateMonth(EverDate.getDate(), 0));
        
        return "/nhepro/OVNR/OVNR0030";
    }

    // 조회
    @RequestMapping(value = "/ovnr0030_doSearch")
    public void ovnr0030_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        
    	resp.setGridObject("grid", ovnr0030_service.ovnr0030_doSearch(req.getFormData()));
    }

    // 반려
    @RequestMapping(value = "/ovnr0030_doReject")
    public void ovnr0030_doReject(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	
        String rtnMap = ovnr0030_service.ovnr0030_doReject(req.getGridData("grid"));
        resp.setResponseMessage(rtnMap);
    }

}
