package com.st_ones.nhepro.LLM.web;

import com.st_ones.common.util.clazz.EverDate;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.nhepro.LLM.service.LLM0010_Service;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.Map;

/**
 * <pre>
 * ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 * ******************************************************************************
 * </pre>
 * @File Name : LLM0010_Controller.java
 * @date 2026.06.16
 * @version 1.0
 */
@Controller
@RequestMapping(value = "/nhepro/LLM")
public class LLM0010_Controller extends BaseController {

    @Autowired private LLM0010_Service llm0010_service;

    /**
     * 화면명 : AI 가격 정보 조회 (팝업)
     * 경로 : 고객사 > 품목관리 > 품목현황 > 품목상세(팝업) > AI 가격 정보 조회(팝업)
     */
    @RequestMapping(value = "/LLM0010/view")
    public String LLM0010(EverHttpRequest req) throws Exception {
        Map<String, String> param = req.getParamDataMap();
        req.setAttribute("form", param);
        return "/nhepro/LLM/LLM0010";
    }

    @RequestMapping(value = "/LLM0010/llm0010_doSearch")
    public void llm0010_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> param = req.getFormData();
        resp.setGridObject("grid", llm0010_service.llm0010_doSearch(param));
        resp.setResponseCode("true");
    }

    @RequestMapping(value = "/LLM0010/llm0010_doInquire")
    public void llm0010_doInquire(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> param = req.getFormData();
        Map<String, Object> result = llm0010_service.llm0010_doInquire(param);
        resp.setFormDataObject(result);
        resp.setResponseCode("true");
    }

    /**
     * 화면명 : AI 결과 데이터 목록 조회
     * 경로 : 고객사 > 품목관리 > AI 결과 데이터 목록 조회
     */
    @RequestMapping(value = "/LLM0020/view")
    public String LLM0020(EverHttpRequest req) throws Exception {
        req.setAttribute("START_DATE", EverDate.addDays(-7));
        req.setAttribute("END_DATE", EverDate.getDate());
        return "/nhepro/LLM/LLM0020";
    }

    @RequestMapping(value = "/LLM0020/llm0020_doSearch")
    public void llm0020_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> param = req.getFormData();
        resp.setGridObject("grid", llm0010_service.llm0020_doSearch(param));
        resp.setResponseCode("true");
    }

}
