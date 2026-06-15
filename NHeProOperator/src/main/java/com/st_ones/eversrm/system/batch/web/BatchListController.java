package com.st_ones.eversrm.system.batch.web;

import com.st_ones.common.combo.service.CommonComboService;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.util.clazz.EverDate;
import com.st_ones.everf.serverside.info.BaseInfo;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.eversrm.system.batch.service.BatchListService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.Map;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : BatchListController.java
 * @date 2013. 07. 22.
 * @version 1.0
 * @see
 */
@Controller
@RequestMapping(value = "/eversrm/system/batch")
public class BatchListController extends BaseController {

    @Autowired private MessageService msg;

    @Autowired private BatchListService batchListService;

    @Autowired private CommonComboService commonComboService;

    /**
     * 화면명 : Batch 실행이력
     * 처리내용 :batch 실행된 내역을 조회한다.
     * 경로 : 시스템관리 > 시스템 > Batch 실행이력
     */
    @RequestMapping("/batchList/view")
    public String batchListView(EverHttpRequest req) throws Exception {
        String curDate = EverDate.getDate();
        req.setAttribute("fromDate", curDate);
        req.setAttribute("toDate", curDate);
        return "/eversrm/system/batch/batchList";
    }

    @RequestMapping(value = "/batchList/doSearch")
    public void doSearchBatchLogList(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> param = req.getFormData();
        resp.setGridObject("grid", batchListService.doSearchBatchLogList(param));
    }

}