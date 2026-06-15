package com.st_ones.eversrm.manager.batch.web;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.st_ones.common.combo.service.CommonComboService;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.util.clazz.EverDate;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.eversrm.manager.batch.service.MBTB0010_Service;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : MBTB0010Controller.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

@Controller
@RequestMapping(value = "/eversrm/manager/batch")
public class MBTB0010_Controller extends BaseController {

    @Autowired private MessageService msg;

    @Autowired private CommonComboService commonComboService;

    @Autowired private MBTB0010_Service mbtb0010_service;

    /**
     * 화면명 : BATCH 실행이력
     * 처리내용 : 시스템에서 실행한 Batch 이력을 조회하는 화면.
     * 경로 : 시스템관리 > 시스템 > BATCH 실행이력
     */
    @RequestMapping("/MBTB0010/view")
    public String MBTB0010(EverHttpRequest req) throws Exception {

        String curDate = EverDate.getDate();
        req.setAttribute("fromDate", curDate);
        req.setAttribute("toDate", curDate);
        return "/eversrm/manager/batch/MBTB0010";
    }

    @RequestMapping(value = "/MBTB0010/doSearch")
    public void doSearchBatchLogList(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> param = req.getFormData();

        resp.setGridObject("grid", mbtb0010_service.doSearchBatchLogList(param));
    }
    
    /**
     * 화면명 : 전자보증 실행이력
     * 처리내용 : 시스템에서 실행한 전자보증 이력을 조회하는 화면.
     * 경로 : 시스템관리 > 시스템 > 전자보증 실행이력
     */
    @RequestMapping("/MBTB0030/view")
    public String MBTB0030(EverHttpRequest req) throws Exception {

        String curDate = EverDate.getDate();
        req.setAttribute("fromDate", curDate);
        req.setAttribute("toDate", curDate);
        return "/eversrm/manager/batch/MBTB0030";
    }

    @RequestMapping(value = "/MBTB0030/doSearch")
    public void doSearchGuarLogList(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> param = req.getFormData();

        resp.setGridObject("grid", mbtb0010_service.doSearchGuarLogList(param));
    }

}
