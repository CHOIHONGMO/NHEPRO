package com.st_ones.nhepro.CITI.web;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.st_ones.common.combo.service.CommonComboService;
import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.util.clazz.EverConverter;
import com.st_ones.common.util.clazz.EverDate;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.common.util.service.LargeTextService;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.info.BaseInfo;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.nhepro.CITI.service.CITI0010_Service;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.ArrayList;
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
 * @File Name : CITI0010_Controller.java
 * @date 2020.03.05
 * @version 1.0
 * @see
 */

@Controller
@RequestMapping(value = "/nhepro/CITI")
public class CITI0010_Controller extends BaseController{
    @Autowired
    private MessageService msg;
    @Autowired
    private CITI0010_Service citi0010_service;
    @Autowired
    private CommonComboService commonComboService;
    @Autowired
    private LargeTextService largeTextService;
    @Autowired
    private MessageService messageService;

    /**
     * 화면명 : 품목등록신청
     * 처리내용 : 신규품목요청
     * 경로 : 기준정보 > 품목관리 > 품목등록신청
     */
    @RequestMapping(value = "/CITI0010/view")
    public String CITI0010(EverHttpRequest req) throws Exception {
        req.setAttribute("today", EverDate.getDate());
        return "/nhepro/CITI/CITI0010";
    }

    @RequestMapping(value = "/CITI0010/citi0010_doRequest")
    public void citi0010_doRequest(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        String rtnMsg = citi0010_service.citi0010_doRequest(req.getGridData("grid"));
        resp.setResponseMessage(rtnMsg);
    }

    /**
     * 화면명 : 품목등록신청현황
     * 처리내용 : 신규로 등록요청한 품목정보에 대한 내용을 확인하는 화면
     * 경로 : 기준정보 > 품목관리 > 품목등록신청현황
     */
    @RequestMapping(value = "/CITR0020/view")
    public String CITR0020(EverHttpRequest req) throws Exception {
        req.setAttribute("START_DATE", EverDate.addDays(-7));
        req.setAttribute("END_DATE", EverDate.getDate());

        return "/nhepro/CITI/CITR0020";
    }

    @RequestMapping(value = "/CITR0020/citr0020_doSearch")
    public void citr0020_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.setGridObject("grid", citi0010_service.citr0020_doSearch(req.getFormData()));
    }

    /**
     * 화면명 : 품목요청상세
     * 처리내용 : 품목등록신청 후 상세 페이지를 호출
     * 경로 : 기준정보 > 품목관리 > 품목등록신청현황 > 품목요청상세(팝업)
     */
    @RequestMapping(value = "/CITA0021/view")
    public String CITA0021(EverHttpRequest req) throws Exception {

        req.setAttribute("form", citi0010_service.cita0021_doSearch(req.getParamDataMap()));

        return "/nhepro/CITI/CITA0021";
    }

    @RequestMapping(value = "/CITA0021/cita0021_doRequest")
    public void cita0021_doRequest(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        citi0010_service.cita0021_doRequest(req.getFormData());
    }

    @RequestMapping(value = "/CITA0021/cita0021_doDelete")
    public void cita0021_doDelete(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        citi0010_service.cita0021_doDelete(req.getFormData());
    }

    /**
     * 화면명 : 품목등록승인현황
     * 처리내용 : 신규로 등록요청한 품목정보에 대한 내용을 재요청하는 화면
     * 경로 : 기준정보 > 품목관리 > 품목등록승인현황
     */
    @RequestMapping(value = "/CITR0030/view")
    public String CITR0030(EverHttpRequest req) throws Exception {
        req.setAttribute("START_DATE", EverDate.addDays(-7));
        req.setAttribute("END_DATE", EverDate.getDate());

        return "/nhepro/CITI/CITR0030";
    }

    @RequestMapping(value = "/CITR0030/citr0030_doSearch")
    public void citr0030_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.setGridObject("grid", citi0010_service.citr0030_doSearch(req.getFormData()));
    }

    @RequestMapping(value = "/CITR0030/citr0030_doRequest")
    public void citr0030_doRequest(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        citi0010_service.citr0030_doRequest(req.getGridData("grid"));
    }

    /**
     * 화면명 : 품목요청등록
     * 처리내용 : 품목등록승인현황에서 요청번호를 클릭하여 품목요청을 등록한다.
     * 경로 : 기준정보 > 품목관리 > 품목등록승인현황 > 품목요청등(팝업)
     */
    @RequestMapping(value = "/CITA0031/view")
    public String CITA0031(EverHttpRequest req) throws Exception {

        req.setAttribute("form", citi0010_service.cita0031_doSearch(req.getParamDataMap()));

        return "/nhepro/CITI/CITA0031";
    }

    @RequestMapping(value = "/CITA0031/cita0031_doSave")
    public void cita0031_doSave(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> formData = req.getFormData();
        formData.put("MKBR_FLAG", "1");
        formData.put("MAIN_IMG_SQ", req.getParameter("mainImgSq"));

        citi0010_service.cita0031_doSave(formData);
    }

    /**
     * 화면명 : 품목현황
     * 처리내용 : 고객사 기준정보의 품목현황 조회 및 처리
     * 경로 : 기준정보 >  > 품목관리 > 품목현황
     */
    @RequestMapping(value="/CITR0040/view")
    public String CITR0040(EverHttpRequest req) throws Exception {
        return "/nhepro/CITI/CITR0040";
    }

    @RequestMapping(value="/CITR0040/citr0040_doSearch")
    public void citr0040_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.setGridObject("grid", citi0010_service.citr0040_doSearch(req.getFormData()));
    }

    @RequestMapping(value="/CITR0040/citr0040_doSave")
    public void citr0040_doSave(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        citi0010_service.citr0040_doSave(req.getGridData("grid"));
    }

    /**
     * 화면명 : 품목상세
     * 처리내용 : 품목현황에서 품목코드 클릭 시 품목상세 화면 호출
     * 경로 : 기준정보 > 품목관리 > 품목현황 > 품목상세(팝업)
     */
    @RequestMapping(value = "/CITR0041/view")
    public String CITR0041(EverHttpRequest req) throws Exception {
    	
        Map<String, String> param = req.getParamDataMap();
        Map<String, String> formData = citi0010_service.citr0041_doSearchInfo(param);
        
        req.setAttribute("formData", formData);
        return "/nhepro/CITI/CITR0041";
    }

    /**
     * 화면명 : 품목검색
     * 처리내용 : 품목 세분류의 속성을 매핑하는 화면.
     * 경로 : 고객사 > 품목관리 > 품목현황 > 품목검색(팝업) - 공통
     */
    @RequestMapping(value = "/CITR0042/view")
    public String CITR0042(EverHttpRequest req) throws Exception {
        req.setAttribute("form", req.getParamDataMap());

        return "/nhepro/CITI/CITR0042";
    }

    @RequestMapping(value = "/CITR0042/citr0042_doSearchTree")
    public void citr0042_doSearchTree(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> formData = req.getFormData();

        List<Map<String, Object>> list = citi0010_service.citr0043_doSearch_ItemClassPopup_TREE(formData);
        resp.setParameter("treeData", EverConverter.getJsonString(list));
    }

    @RequestMapping(value = "/CITR0042/citr0042_doSearchGrid")
    public void citr0042_doSearchGrid(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.setGridObject("grid", citi0010_service.citr0042_doSearchGrid(req.getFormData()));
    }

    /**
     * 화면명 : 품목분류
     * 처리내용 : 품목요청등록 화면에서 분목분류 클릭 시 팝업 호출
     * 경로 : 기준정보 >  > 품목관리 > 품목등록승인현황 > 품목요청등록 > 품목분류 (팝업)
     */
    @RequestMapping(value="/CITR0043/view")
    public String CITR0043(EverHttpRequest req) throws Exception {
        req.setAttribute("form", req.getParamDataMap());
        return "/nhepro/CITI/CITR0043";
    }

    @RequestMapping(value="/CITR0043/citr0043_doSearch")
    public void citr0043_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> formData = req.getFormData();

        List<Map<String,Object>> treeData = citi0010_service.citr0043_doSearch_ItemClassPopup_TREE(formData);
        resp.setParameter("treeData", EverConverter.getJsonString(treeData));
    }

    /**
     * 화면명 : 품목상세
     * 처리내용 : 품목상세 내용을 등록, 수정, 삭제하는 화면
     * 경로 : 기준정보 >  > 품목관리 > 품목현황 > 품목등록 > 품목상세 (팝업)
     */
    @RequestMapping(value="/CITA0044/view")
    public String CITA0044(EverHttpRequest req) throws Exception {
        Map<String, String> formData = req.getParamDataMap();

        Map<String, String> doSearchInfo = citi0010_service.citr0041_doSearchInfo(formData);

        if (doSearchInfo != null) {
            formData.putAll(doSearchInfo);
        }

        req.setAttribute("form", formData);
        return "/nhepro/CITI/CITA0044";
    }

    // 품목 저장
    @RequestMapping(value = "/CITA0044/cita0044_doSave")
    public void cita0044_doSave(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> formData = req.getFormData();
        formData.put("MAIN_IMG_SQ", req.getParameter("mainImgSq"));
        formData.put("MKBR_FLAG", "0");

        Map<String, String> rtnMap = citi0010_service.cita0031_doSave(formData);
        resp.setResponseMessage(rtnMap.get("rtnMsg"));
        resp.setParameter("ITEM_CD", rtnMap.get("ITEM_CD"));
        resp.setParameter("STD_ITEM_CD", rtnMap.get("STD_ITEM_CD"));
    }

    // 품목 삭제
    @RequestMapping(value = "/CITA0044/cita0044_doDelete")
    public void cita0044_doDelete(EverHttpRequest req, EverHttpResponse resp) {
        citi0010_service.cita0044_doDelete(req.getFormData());
    }

    /**
     * 화면명 : 표준관리 품목검색
     * 처리내용 : 품목 세분류의 속성을 매핑하는 화면.
     * 경로 : 고객사 > 품목관리 > 품목현황 > 표준관리 품목검색(팝업)
     */
    @RequestMapping(value = "/CITR0045/view")
    public String CITR0045(EverHttpRequest req) throws Exception {
        req.setAttribute("form", req.getParamDataMap());

        return "/nhepro/CITI/CITR0045";
    }

    @RequestMapping(value = "/CITR0045/citr0045_doSearchTree")
    public void citr0045_doSearchTree(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> formData = req.getFormData();

        List<Map<String, Object>> list = citi0010_service.citr0045_doSearch_ItemClassPopup_TREE(formData);
        resp.setParameter("treeData", EverConverter.getJsonString(list));
    }

    @RequestMapping(value = "/CITR0045/citr0045_doSearchGrid")
    public void citr0045_doSearchGrid(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.setGridObject("grid", citi0010_service.citr0045_doSearchGrid(req.getFormData()));
    }

    /**
     * 화면명 : 표준품목상세
     * 처리내용 : 표준품목현황에서 품목코드 클릭 시 표준품목상세 화면 호출
     * 경로 : 기준정보 > 품목관리 > 품목현황 > 품목상세(팝업)
     */
    @RequestMapping(value = "/CITR0046/view")
    public String CITR0046(EverHttpRequest req) throws Exception {
        Map<String, String> formData = req.getParamDataMap();
        formData.putAll(citi0010_service.citr0041_doSearchInfo(formData));

        req.setAttribute("formData", formData);

        return "/nhepro/CITI/CITR0046";
    }

    @RequestMapping(value="/CITR0046/citr0046_doSearch")
    public void citr0046_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.setGridObject("grid", citi0010_service.citr0047_doSearch(req.getFormData()));
    }

    /**
     * 화면명 : 표준관리품목 속성 상세
     * 처리내용 : 표준관리품목 속성 상세 정보를 조회힌다.
     * 경로 : 기준정보 > 품목관리 > 품목현황 > 품목상세(팝업) > 표준관리품목 속성 상세 (팝업)
     */
    @RequestMapping(value = "/CITR0047/view")
    public String CITR0047(EverHttpRequest req) throws Exception {
        req.setAttribute("form", req.getParamDataMap());
        return "/nhepro/CITI/CITR0047";
    }

    @RequestMapping(value = "/CITR0047/citr0047_doSearch")
    public void citr0047_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.setGridObject("grid", citi0010_service.citr0047_doSearch(req.getFormData()));
    }

    /**
     * 화면명 : 품목분류관리
     * 처리내용 : 고객사별 품목분류를 조회/관리하는 화면.
     * 경로 : 기준정보 > 품목관리 > 품목분류관리
     */
    @RequestMapping(value = "/CITR0050/view")
    public String CITR0050(EverHttpRequest req) throws Exception {
        req.setAttribute("keyRule", PropertiesManager.getString("eversrm.item.type.management.rule"));
        return "/nhepro/CITI/CITR0050";
    }

    @RequestMapping(value = "/CITR0050/citr0050_doSearch")
    public void citr0050_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> param = req.getFormData();

        List<Map<String, Object>> result = citi0010_service.citr0050_doSearch(param);
        resp.setGridObject("grid1", result);

        ObjectMapper om = new ObjectMapper();
        String jsonStr = om.writeValueAsString(result);
        resp.setParameter("refItemList", jsonStr);
    }

    @RequestMapping(value = "/CITR0050/citr0050_doSearchChild")
    public void citr0050_doSearchChild(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> param = req.getFormData();

        String itemClassType = param.get("ITEM_CLS_TYPE_CLICKED");
        if (itemClassType.equals("C1")) {
            resp.setGridObject("grid2", citi0010_service.citr0050_doSearchChild(param));
        } else if (itemClassType.equals("C2")) {
            resp.setGridObject("grid3", citi0010_service.citr0050_doSearchChild(param));
        } else if (itemClassType.equals("C3")) {
            resp.setGridObject("grid4", citi0010_service.citr0050_doSearchChild(param));
        }
    }

    @RequestMapping(value = "/CITR0050/citr0050_doCopy")
    public void citr0050_doCopy(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        UserInfo userInfo = UserInfoManager.getUserInfo();
        Map<String, String> formData = req.getFormData();
        formData.put("MANAGE_CD", userInfo.getManageCd());

        String message = citi0010_service.citr0050_doCopy(formData);
        resp.setResponseMessage(message);
    }

    @RequestMapping(value = "/CITR0050/citr0050_doSave")
    public void citr0050_doSave(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        List<Map<String, Object>> gridData = new ArrayList<Map<String, Object>>();

        String classToSave = req.getParameter("CLASS_TO_SAVE");
        if (classToSave.equals("C1")) {
            gridData = req.getGridData("grid1");
        } else if (classToSave.equals("C2")) {
            gridData = req.getGridData("grid2");
        } else if (classToSave.equals("C3")) {
            gridData = req.getGridData("grid3");
        } else if (classToSave.equals("C4")) {
            gridData = req.getGridData("grid4");
        }

        String message = citi0010_service.citr0050_doSave(gridData);
        resp.setResponseMessage(message);
    }

    @RequestMapping(value = "/CITR0050/citr0050_doDelete")
    public void citr0050_doDelete(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        List<Map<String, Object>> gridData = new ArrayList<Map<String, Object>>();

        String classToDelete = req.getParameter("CLASS_TO_DELETE");
        if (classToDelete.equals("C1")) {
            gridData = req.getGridData("grid1");
        } else if (classToDelete.equals("C2")) {
            gridData = req.getGridData("grid2");
        } else if (classToDelete.equals("C3")) {
            gridData = req.getGridData("grid3");
        } else if (classToDelete.equals("C4")) {
            gridData = req.getGridData("grid4");
        }

        String message = citi0010_service.citr0050_doDelete(gridData);
        resp.setResponseMessage(message);
    }

    /**
     * 화면명 : 제조사/브랜드 관리
     * 처리내용 : 고객사 기준정보에서 사용하는 제조사/브랜드를 조회/등록하는 화면.
     * 경로 : 기준정보 > 품목관리 > 제조사/브랜드 관리
     */
    @RequestMapping(value = "/CITR0060/view")
    public String CITR0060(EverHttpRequest req) throws Exception {
        return "/nhepro/CITI/CITR0060";
    }

    @RequestMapping(value = "/CITR0060/citr0060_doSearch")
    public void citr0060_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.setGridObject("grid", citi0010_service.citr0060_doSearch(req.getFormData()));
    }

    @RequestMapping(value = "/CITR0060/citr0060_doSave")
    public void citr0060_doSave(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        List<Map<String, Object>> gridData = req.getGridData("grid");
        citi0010_service.citr0060_doSave(gridData);

        resp.setResponseMessage(messageService.getMessage("0031"));
    }

}

