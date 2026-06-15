package com.st_ones.nhepro.OITR.web;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.util.clazz.EverConverter;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.info.BaseInfo;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.nhepro.OITR.service.OITR0020_Service;
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
 * @File Name : OITR0020_Controller.java
 * @date 2020.03.05
 * @version 1.0
 * @see
 */

@Controller
@RequestMapping(value = "/nhepro/OITR")
public class OITR0020_Controller extends BaseController{
    @Autowired
    private MessageService msg;
    @Autowired
    private OITR0020_Service oitr0020_Service;
    @Autowired
    private MessageService messageService;

    /**
     * 화면명 : 품목현황
     * 처리내용 : 시스템에 등록되어있는 품목들을 조회/수정/견적의뢰 할 수 있는 화면.
     * 경로 : 품목관리 > 품목관리 > 표준품목현황
     */
    @RequestMapping(value = "/OITR0020/view")
    public String OITR0020(EverHttpRequest req) throws Exception {
        return "/nhepro/OITR/OITR0020";
    }

    @RequestMapping(value="/OITR0020/oitr0020_doSearch")
    public void oitr0020_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.setGridObject("grid", oitr0020_Service.oitr0020_doSearch(req.getFormData()));
    }

    @RequestMapping(value="/OITR0020/oitr0020_doSave")
    public void oitr0020_doSave(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        List<Map<String, Object>> gridData = req.getGridData("grid");

        oitr0020_Service.oitr0020_doSave(gridData);
        resp.setResponseMessage(msg.getMessage("0031"));
        resp.setResponseCode("true");
    }

    /**
     * 화면명 : 품목분류
     * 처리내용 : 시스템에 등록된 품목분류를 조회하는 화면.
     * 경로 : 고객사 > Admin > Admin > MySite관리 > 품목분류 (팝업)
     * 경로 : 고객사 > Admin > Admin > 품목별계정지정 > 품목분류 (팝업)
     * 경로 : 고객사 > 주문관리 > 주문관리 > 품목검색 > 품목분류 (팝업)
     */
    @RequestMapping(value="/OITR0021/view")
    public String OITR0021(EverHttpRequest req) throws Exception {
        //Map<String, String> formData = req.getFormData();

        //List<Map<String, Object>> treeData = oitr0020_Service.oitr0021_doSearch_ItemClassPopup_TREE(formData);
        //req.setAttribute("treeData", new ObjectMapper().writeValueAsString(treeData));

        return "/nhepro/OITR/OITR0021";
    }

    @RequestMapping(value="/OITR0021/doSearch")
    public void OITR0021_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> formData = req.getFormData();

        List<Map<String,Object>> treeData = oitr0020_Service.oitr0021_doSearch_ItemClassPopup_TREE(formData);
        resp.setParameter("treeData", EverConverter.getJsonString(treeData));
    }

    /**
     * 화면명 : 품목등록(건별)
     * 처리내용 : 운영사가 사용할 품목을 등록하는 화면.
     * 경로 : 품목관리 > 품목표준화 > 품목등록(건별)
     */
    @RequestMapping(value = "/OITA0024/view")
    public String OITA0024(EverHttpRequest req) throws Exception {

        Map<String, String> formData = req.getParamDataMap();

        req.setAttribute("formData", oitr0020_Service.oita0024_doSearchInfo(formData));
        return "/nhepro/OITR/OITA0024";
    }

    @RequestMapping(value = "/OITA0024/oita0024_doSearch_AT")
    public void oita0024_doSearch_AT(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.setGridObject("gridat", oitr0020_Service.oita0024_doSearch_AT(req.getFormData()));
    }

    // 품목 저장
    @RequestMapping(value = "/OITA0024/oita0024_doSave")
    public void oita0024_doSave(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> formData = req.getFormData();
        formData.put("MAIN_IMG_SQ", req.getParameter("mainImgSq"));

        List<Map<String, Object>> gridDataAt = req.getGridData("gridat"); // 품목규격

        Map<String, String> rtnMap = oitr0020_Service.oita0024_doSave(formData, gridDataAt);
        resp.setResponseMessage(rtnMap.get("rtnMsg"));
        resp.setParameter("ITEM_CD", rtnMap.get("ITEM_CD"));
        resp.setParameter("STD_ITEM_CD", rtnMap.get("STD_ITEM_CD"));
    }

    /**
     * 화면명 : 품목속성정보
     * 처리내용 : 품목속성정보, 규격
     * 경로 : 주문관리 > 납품관리 > 납품현황 > 품목상세정보 (팝업) > 품목속성정보 (팝업)
     */
    @RequestMapping(value = "/OITA0025/view")
    public String OITA0025(EverHttpRequest req) throws Exception {
        return "/nhepro/OITR/OITA0025";
    }

    @RequestMapping(value = "/OITA0025/oita0025_doSearch")
    public void oita0025_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.setGridObject("grid", oitr0020_Service.oita0025_doSearch(req.getFormData()));
    }

    /**
     * 화면명 : 제조사/브랜드 관리
     * 처리내용 : 시스템에서 사용하는 제조사/브랜드를 조회/등록하는 화면.
     * 경로 : 품목관리 > 품목표준화 > 제조사/브랜드 관리
     */
    @RequestMapping(value = "/OITR0080/view")
    public String OITR0080(EverHttpRequest req) throws Exception {
        return "/nhepro/OITR/OITR0080";
    }

    @RequestMapping(value = "/OITR0080/oitr0080_doSearch")
    public void oitr0080_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.setGridObject("grid", oitr0020_Service.oitr0080_doSearch(req.getFormData()));
    }

    @RequestMapping(value = "/OITR0080/oitr0080_doSave")
    public void oitr0080_doSave(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        List<Map<String, Object>> gridData = req.getGridData("grid");
        oitr0020_Service.oitr0080_doSave(gridData);

        resp.setResponseMessage(messageService.getMessage("0031"));
    }

    /**
     * 화면명 : 품목분류-속성매핑
     * 처리내용 : 품목 세분류의 속성을 매핑하는 화면.
     * 경로 : 품목관리 > 품목분류/SG > 품목분류-속성매핑
     */
    @RequestMapping(value = "/OITR0070/view")
    public String OITR0070(EverHttpRequest req) throws Exception {
        return "/nhepro/OITR/OITR0070";
    }

    @RequestMapping(value = "/OITR0070/oitr0070_doSearchTree")
    public void oitr0070_doSearchTree(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> formData = req.getFormData();
        BaseInfo baseInfo = (BaseInfo)req.getSession().getAttribute("ses");
        formData.put("CUST_CD", baseInfo.getCompanyCd());

        List<Map<String, Object>> list = oitr0020_Service.oitr0021_doSearch_ItemClassPopup_TREE(formData);
        resp.setParameter("treeData", EverConverter.getJsonString(list));
    }

    /**
     * 분류별 속성 조회 (IM04_007/IM04_008)
     * @param req
     * @param resp
     * @throws Exception
     */
    @RequestMapping(value = "/OITR0070/oitr0070_doSearch")
    public void oitr0070_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> param = req.getFormData();
        resp.setGridObject("grid", oitr0020_Service.oitr0070_doSearchMTCR(param));
    }

    /**
     * 분류별 속성 등록 (IM04_007/IM04_008)
     * @param req
     * @param resp
     * @throws Exception
     */
    @RequestMapping(value = "/OITR0070/oitr0070_doSave")
    public void oitr0070_doSave(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> formData = req.getFormData();
        List<Map<String, Object>> gridData = req.getGridData("grid");

        String message = oitr0020_Service.oitr0070_doSave(formData, gridData);
        resp.setResponseMessage(message);
    }

    /**
     * 분류별 속성 삭제 (IM04_007/IM04_008)
     * @param req
     * @param resp
     * @throws Exception
     */
    @RequestMapping(value = "/OITR0070/oitr0070_doDelete")
    public void oitr0070_doDelete(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> formData = req.getFormData();
        List<Map<String, Object>> gridData = req.getGridData("grid");

        String message = oitr0020_Service.oitr0070_doDelete(formData, gridData);
        resp.setResponseMessage(message);
    }

    /**
     * 화면명 : 속성조회
     * 처리내용 : 품목 세분류의 속성을 조회하는 화면.
     * 경로 : Popup
     */
    @RequestMapping(value = "/OITR0071/view")
    public String OITR0071(EverHttpRequest req) throws Exception {
        return "/nhepro/OITR/OITR0071";
    }

    @RequestMapping(value = "/OITR0071/oitr0071_doSearchCommonCode")
    public void oitr0071_doSearchCommonCode(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> param = req.getFormData();
        param.put("CODE_TYPE", "MP025");
        resp.setGridObject("grid", oitr0020_Service.oitr0071_doSearchCommonCode(param));
    }

    /**
     * 화면명 : 속성기준현황
     * 처리내용 : 속성마스터를 관리하는 화면
     * 경로 : 품목관리 > 품목관리 > 속성기준현황
     */
    @RequestMapping(value = "/OITR0060/view")
    public String OITR0060(EverHttpRequest req) throws Exception {
        return "/nhepro/OITR/OITR0060";
    }

    @RequestMapping(value = "/OITR0060/oitr0060_doSearch")
    public void oitr0060_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.setGridObject("grid", oitr0020_Service.oitr0060_doSearch(req.getFormData()));
    }

    @RequestMapping(value = "/OITR0060/oitr0060_doSave")
    public void oitr0060_doSave(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        oitr0020_Service.oitr0060_doSave(req.getGridData("grid"));
    }

    @RequestMapping(value = "/OITR0060/oitr0060_doDelete")
    public void oitr0060_doDelete(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        oitr0020_Service.oitr0060_doDelete(req.getGridData("grid"));
    }

    /**
     * 화면명 : 품목분류 현황
     * 처리내용 : 고객사별 품목분류를 조회/관리하는 화면.
     * 경로 : 품목관리 > 품목분류/SG > 품목분류 현황
     */
    @RequestMapping(value = "/OITR0040/view")
    public String OITR0040(EverHttpRequest req) throws Exception {
        req.setAttribute("keyRule", PropertiesManager.getString("eversrm.item.type.management.rule"));
        return "/nhepro/OITR/OITR0040";
    }

    @RequestMapping(value = "/OITR0040/oitr0040_doSearch")
    public void oitr0040_doSearchItemClass(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> param = req.getFormData();

        List<Map<String, Object>> result = oitr0020_Service.oitr0040_doSearch(param);
        resp.setGridObject("grid1", result);

        ObjectMapper om = new ObjectMapper();
        String jsonStr = om.writeValueAsString(result);
        resp.setParameter("refItemList", jsonStr);
    }

    @RequestMapping(value = "/OITR0040/oitr0040_doSearchChild")
    public void oitr0040_doSearchChild(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> param = req.getFormData();

        String itemClassType = param.get("ITEM_CLS_TYPE_CLICKED");
        if (itemClassType.equals("C1")) {
            resp.setGridObject("grid2", oitr0020_Service.oitr0040_doSearchChild(param));
        } else if (itemClassType.equals("C2")) {
            resp.setGridObject("grid3", oitr0020_Service.oitr0040_doSearchChild(param));
        } else if (itemClassType.equals("C3")) {
            resp.setGridObject("grid4", oitr0020_Service.oitr0040_doSearchChild(param));
        }
    }

    @RequestMapping(value = "/OITR0040/oitr0040_doSave")
    public void oitr0040_doSave(EverHttpRequest req, EverHttpResponse resp) throws Exception {

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

        String message = oitr0020_Service.oitr0040_doSave(gridData);
        resp.setResponseMessage(message);
    }

    @RequestMapping(value = "/OITR0040/oitr0040_doDelete")
    public void oitr0040_doDelete(EverHttpRequest req, EverHttpResponse resp) throws Exception {

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

        String message = oitr0020_Service.oitr0040_doDelete(gridData);
        resp.setResponseMessage(message);
    }

    /**
     * 화면명 : 표준품목상세
     * 처리내용 : 표준품목현황에서 품목코드 클릭 시 표준품목상세 화면 호출
     * 경로 : 품목관리 > 품목관리 > 표준품목현황 > 표준품목상세(팝업)
     */
    @RequestMapping(value = "/OITR0022/view")
    public String OITR0022(EverHttpRequest req) throws Exception {
        Map<String, String> formData = req.getParamDataMap();
        formData.putAll(oitr0020_Service.oita0024_doSearchInfo(formData));

        req.setAttribute("formData", formData);

        return "/nhepro/OITR/OITR0022";
    }

    @RequestMapping(value="/OITR0022/oitr0022_doSearch")
    public void oitr0022_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.setGridObject("grid", oitr0020_Service.oitr0023_doSearch(req.getFormData()));
    }

    /**
     * 화면명 : 품목속성상세
     * 처리내용 : 품목속성상세 정보를 조회힌다.
     * 경로 : 품목관리 > 품목관리 > 표준품목현황 > 표준품목상세(팝업) > 품목속성상세 (팝업)
     */
    @RequestMapping(value = "/OITR0023/view")
    public String OITR0023(EverHttpRequest req) throws Exception {
        req.setAttribute("form", req.getParamDataMap());
        return "/nhepro/OITR/OITR0023";
    }

    @RequestMapping(value = "/OITR0023/oitr0023_doSearch")
    public void oitr0023_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.setGridObject("grid", oitr0020_Service.oitr0023_doSearch(req.getFormData()));
    }
}

