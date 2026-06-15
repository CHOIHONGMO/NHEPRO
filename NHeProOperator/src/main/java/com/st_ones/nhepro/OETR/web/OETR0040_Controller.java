package com.st_ones.nhepro.OETR.web;

import com.st_ones.common.combo.service.CommonComboService;
import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.common.util.clazz.EverDate;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.nhepro.OETR.service.OETR0040_Service;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
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
 * @File Name : OETR0040_Controller.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

@Controller
@RequestMapping(value = "/nhepro/OETR")
public class OETR0040_Controller extends BaseController {

    @Autowired private OETR0040_Service oetr0040_service;
    @Autowired private CommonComboService commonComboService;

    /**
     * 화면명 : 고객의 소리(VOC)
     * 처리내용 : VOC를 조회하는화면.
     * 경로 : 운영사 > My Page > My Page > 고객의 소리(VOC)
     */
    @RequestMapping(value="/OETR0040/view")
    public String OETR0040(EverHttpRequest req) {
        req.setAttribute("START_DATE", EverDate.addDateMonth(EverDate.getDate(), -1));
        req.setAttribute("END_DATE", EverDate.getDate());

        return "/nhepro/OETR/OETR0040";
    }

    // 조회
    @RequestMapping(value="/oetr0040_doSearch")
    public void oetr0040_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> param = req.getFormData();

        resp.setGridObject("grid", oetr0040_service.oetr0040_doSearch(param));
    }

    /**
     * 화면명 : 고객의소리 상세
     * 처리내용 : VOC를 조치하고 처리하는 결과를 입력하는 화면.
     * 경로 : 운영사 > My Page > My Page > 고객의 소리 > 고객의소리 상세 (팝업)
     */
    @RequestMapping(value = "/OETR0041/view")
    public String OETR0041(EverHttpRequest req) throws Exception {
        Map<String, String> param = req.getParamDataMap();
        
        UserInfo userInfo = UserInfoManager.getUserInfo();
        
        Map<String, Object> data = oetr0040_service.oetr0041_doSearch(param);
        
        String PROGRESS_CD = EverString.nullToEmptyString(data.get("PROGRESS_CD"));
        if("200".equals(PROGRESS_CD)) {
            data.put("RECV_DATE", EverDate.getFormatString("yyyy-MM-dd HH:mm:ss"));
            data.put("CD_DATE", EverDate.getDate());
            data.put("DS_USER_ID", userInfo.getUserId());
            data.put("DS_USER_NM", userInfo.getUserNm());
        }

        req.setAttribute("formData", data);

        return "/nhepro/OETR/OETR0041";
    }

    // 저장
    @RequestMapping(value = "/oetr0041_doSave")
    public void oetr0041_doSave(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> inParam = req.getFormData();
        
        Map<String, String> result = oetr0040_service.oetr0041_doSave(inParam);
        resp.setParameter("VC_NO", result.get("VC_NO"));
        resp.setParameter("COMPANY_CD", result.get("COMPANY_CD"));
        resp.setResponseMessage(result.get("message"));
    }

}
