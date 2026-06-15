package com.st_ones.eversrm.manager.screen.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.text.WordUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.st_ones.common.combo.service.CommonComboService;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.info.BaseInfo;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.eversrm.manager.screen.service.MSRA0030_Service;

/**
 * <pre>
 * *****************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 * *****************************************************************************
 * </pre>
 *
 * @File Name : MSRA0030_Controller.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

@Controller
@RequestMapping(value = "/eversrm/manager/screen")
public class MSRA0030_Controller extends BaseController {

    @Autowired private CommonComboService commonComboService;

    @Autowired private MSRA0030_Service msra0030_Service;

    /**
     * 화면명 : 화면속성관리
     * 처리내용 : 화면에서 사용하는 속성 정보들을 관리하는 화면.
     * 경로 : 시스템관리 > 화면 > 화면속성관리
     */
    @RequestMapping(value = "/MSRA0030/view")
    public String MSRA0030(EverHttpRequest req, EverHttpRequest resp) {

        /* 관리자 권한이 존재하지 않으면 접속 불가 */
        if (!PropertiesManager.getBoolean("eversrm.system.developmentFlag")) {
            BaseInfo baseInfo = (BaseInfo) resp.getSession().getAttribute("ses");
            if (baseInfo.getSuperUserFlag().equals("0")) {
                //return "/eversrm/noSuperAuth";
            }
        }

        // STOCSCRN 의 APPROVAL_TYPE 을 조회한다.
        Map<String, String> paramMap = req.getParamDataMap();
        req.setAttribute("APPROVAL_TYPE", msra0030_Service.msra0030_doSearchApprovalType(paramMap));

        return "/eversrm/manager/screen/MSRA0030";
    }

    @RequestMapping(value = "/MSRA0030/doChoiceDomain")
    public void msra0030_doChoiceDomain(EverHttpResponse resp, @RequestParam(value = "searchWord") String searchWord) throws Exception {

        Map<String, String> param = new HashMap<String, String>();
        Map<String, Object> result = new HashMap<String, Object>();
        param.put("SEARCH_WORD", searchWord);
        param.put("st_SEARCH_WORD", "L");

        param.put("OWNER", PropertiesManager.getString("eversrm.system.database.owner"));
        List<Map<String, Object>> dataLengthData = msra0030_Service.msra0030_doSearchDataLength(param);

        Object dataLength = null;
        String dataLengthMsg = "";
        int dataCnt = dataLengthData.size();
        if (dataCnt == 1) {
            dataLength = dataLengthData.get(0).get("DATA_LENGTH");
        } else if (dataCnt > 1) {
            dataLength = dataLengthData.get(0).get("DATA_LENGTH");
            dataLengthMsg = "[해당 컬럼에 대한 Data Length 정보입니다.]";
            for (Map<String, Object> tmpMap : dataLengthData) {
                dataLengthMsg = dataLengthMsg + "@@" + tmpMap.get("TABLE_NAME") + " : " + tmpMap.get("DATA_TYPE") + "(" + tmpMap.get("DATA_LENGTH") + ")";
            }
        }

        List<Map<String, Object>> domainData = msra0030_Service.msra0030_doSearchDOMC(param);

        Map<String, String> mostUsedWord = msra0030_Service.msra0030_getMostUsedWord(param);
        resp.setParameter("mostUsedWord", new ObjectMapper().writeValueAsString(mostUsedWord));

        // 입력한 Column ID에 대한 Domain이 STCODOMC Table에 1건 있으므로 그리드에 바로 Setting 한다.
        if (domainData.size() == 1) {

            result = domainData.get(0);
            result.put("FORMAT", result.get("FORMAT"));
            result.put("DOMAIN_TYPE", result.get("DOMAIN_TYPE"));
            result.put("DOMAIN_NM", result.get("DOMAIN_NM"));
            result.put("DATA", result.get("DATA"));
            result.put("DATA_TYPE", result.get("PRE_FORMAT"));
            result.put("DATA_LENGTH", dataLength != null ? dataLength : result.get("DATA_LENGTH"));
            result.put("PRE_FORMAT", result.get("PRE_FORMAT"));
            result.put("ALIGNMENT", result.get("ALIGNMENT"));
            result.put("COL_WIDTH", result.get("COL_WIDTH"));
            result.put("COL_TYPE", result.get("COL_TYPE"));
            result.put("COMMON_ID", result.get("COMMON_ID"));

            ObjectMapper om = new ObjectMapper();
            resp.setParameter("openFlag", "N");
            resp.setParameter("domainData", om.writeValueAsString(result));

        } else if (domainData.size() >= 1) { // STCODOMC Table에서 여러건이 나왔으므로, STCODOMA Table을 조회한다.

            domainData.clear();
            domainData = msra0030_Service.msra0032_doSearchWord(param);

            // 입력한 Column ID에 대한 Domain이 STCODOMA Table에 1건 있으므로 그리드에 바로 Setting 한다.
            if (domainData.size() == 1) {

                result = domainData.get(0);
                result.put("FORMAT", result.get("FORMAT"));
                result.put("DOMAIN_TYPE", result.get("DOMAIN_TYPE"));
                result.put("DOMAIN_NM", result.get("DOMAIN_NM"));
                result.put("DATA", result.get("DATA"));
                result.put("DATA_TYPE", result.get("PRE_FORMAT"));
                result.put("DATA_LENGTH", dataLength != null ? dataLength : result.get("DATA_LENGTH"));
                result.put("PRE_FORMAT", result.get("PRE_FORMAT"));
                result.put("ALIGNMENT", result.get("ALIGNMENT"));
                result.put("COL_WIDTH", result.get("COL_WIDTH"));
                result.put("COL_TYPE", result.get("COL_TYPE"));
                result.put("MULTI_CONTENTS", result.get("DOMAIN_DESC"));
                result.put("COMMON_ID", result.get("COMMON_ID"));

                ObjectMapper om = new ObjectMapper();
                resp.setParameter("openFlag", "N");
                resp.setParameter("domainData", om.writeValueAsString(result));

            } else if (domainData.size() > 1) { // 입력한 Column ID에 대한 Domain이 STCODOMA Table에 여러건 있으므로 Popup창을 띄운다.
                resp.setParameter("openFlag", "Y");
                resp.setParameter("domainData", searchWord);
            }

        } else {

            // STCODOMC Table에서 조회된 건이 없으므로, STCODOMA Table을 조회한다.
            domainData.clear();
            domainData = msra0030_Service.msra0032_doSearchWord(param);

            // STCODOMC Table에는 없으나, STCODOMA Table에는 1건 있으므로 Grid에 바로 Setting 한다.
            if (domainData.size() > 0) {

                result = domainData.get(0);
                result.put("FORMAT", result.get("FORMAT"));
                result.put("DOMAIN_TYPE", result.get("DOMAIN_TYPE"));
                result.put("DOMAIN_NM", result.get("DOMAIN_NM"));
                result.put("DATA", result.get("DATA"));
                result.put("DATA_TYPE", result.get("PRE_FORMAT"));
                result.put("DATA_LENGTH", dataLength != null ? dataLength : result.get("DATA_LENGTH"));
                result.put("PRE_FORMAT", result.get("PRE_FORMAT"));
                result.put("ALIGNMENT", result.get("ALIGNMENT"));
                result.put("COL_WIDTH", result.get("COL_WIDTH"));
                result.put("COL_TYPE", result.get("COL_TYPE"));
                result.put("COMMON_ID", result.get("COMMON_ID"));

                ObjectMapper om = new ObjectMapper();
                resp.setParameter("openFlag", "N");
                resp.setParameter("domainData", om.writeValueAsString(result));

            } else { // STCODOMC, STCODOMA Table 모두 조회된 값이 없으므로 Domain을 검색할 수 있는 Popup창을 띄운다.
                resp.setParameter("openFlag", "Y");
                resp.setParameter("domainData", "");
            }
        }
        resp.setParameter("dataLengthMsg", dataLengthMsg);
    }

    @RequestMapping(value = "/MSRA0030/doSearch")
    public void msra0030_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        String tagGuide = "";
        Map<String, String> param = req.getFormData();
        param.put("ANOTHER_LANG", req.getParameter("anotherLangVal"));

        List<Map<String, Object>> gridData = msra0030_Service.msra0030_doSearch(param);
        for (Map<String, Object> datum : gridData) {

            final String columnType = (String) datum.get("COLUMN_TYPE");

            if (!datum.get("MULTI_TYPE").equals("F") || EverString.isEmpty(columnType)) {
                continue;
            }

            final String searchConditionFlag = (String) datum.get("SEARCH_CONDITION_FLAG");
            final String columnId = (String) datum.get("COLUMN_ID");
            final String formGridId = (String) datum.get("FORM_GRID_ID");
            final String disableFlag = (String) datum.get("DISABLE_FLAG");
            final String formId = formGridId + "_" + columnId;

            if (columnType.equals("text")) {
                tagGuide = String.format("<e:label for=\"%s\" title=\"${%s_N}\" />\n"
                                + "<e:field>\n"
                                + "<e:inputText id=\"%s\" name=\"%s\" value=\"\" width=\"${%s_W}\" maxLength=\"${%s_M}\" disabled=\"${%s_D}\" readOnly=\"${%s_RO}\" required=\"${%s_R}\" style=\"${imeMode}\" maskType=\"${%s_MT}\"/>\n"
                                + "</e:field>"
                        , columnId, formId
                        , columnId, columnId
                        , formId, formId, formId, formId, formId, formId, formId);
            }
            else if (columnType.equals("textarea")) {
                tagGuide = String.format("<e:label for=\"%s\" title=\"${%s_N}\"/>\n"
                                + "<e:field>\n"
                                + "<e:textArea id=\"%s\" name=\"%s\" value=\"\" height=\"100px\" width=\"${%s_W}\" maxLength=\"${%s_M}\" disabled=\"${%s_D}\" readOnly=\"${%s_RO}\" required=\"${%s_R}\" />\n"
                                + "</e:field>\n"
                        , columnId, formId
                        , columnId, columnId
                        , formId, formId, formId, formId, formId, formId, formId);
            }
            else if (columnType.equals("search")) {
                tagGuide = String.format("<e:label for=\"%s\" title=\"${%s_N}\"/>\n"
                                + "<e:field>\n"
                                + "<e:search id=\"%s\" name=\"%s\" value=\"\" width=\"${%s_W}\" maxLength=\"${%s_M}\" onIconClick=\"${%s_RO ? 'everCommon.blank' : ''}\" disabled=\"${%s_D}\" readOnly=\"${%s_RO}\" required=\"${%s_R}\" maskType=\"${%s_MT}\" />\n"
                                + "</e:field>\n"
                        , columnId, formId
                        , columnId, columnId
                        , formId, formId, formId, formId, formId, formId, formId, formId);
            }
            else if (columnType.equals("date") || columnType.equals("customdate")) {
                tagGuide = String.format("<e:label for=\"%s\" title=\"${%s_N}\"/>\n"
                                + "<e:field>\n"
                                + "<e:inputDate id=\"%s\" name=\"%s\" value=\"\" width=\"${inputDateWidth}\" datePicker=\"true\" required=\"${%s_R}\" disabled=\"${%s_D}\" readOnly=\"${%s_RO}\" />\n"
                                + "</e:field>\n"
                        , columnId, formId
                        , columnId, columnId, formId, formId, formId);
            }
            else if ((columnType.equals("date") || columnType.equals("customdate")) && disableFlag.equals("0")) {
                tagGuide = String.format("<e:inputDate id=\"%s\" name=\"%s\" value=\"\" width=\"${%s_W}\" datePicker=\"true\" required=\"${%s_R}\" disabled=\"${%s_D}\" readOnly=\"${%s_RO}\" />\n"
                        , columnId, columnId, formId, formId, formId, formId);
            }
            else if (columnType.equals("number")) {
                tagGuide = String.format("<e:label for=\"%s\" title=\"${%s_N}\"/>\n"
                                + "<e:field>\n"
                                + "<e:inputNumber id=\"%s\" name=\"%s\" value=\"\" width=\"${%s_W}\" maxValue=\"${%s_M}\" decimalPlace=\"${%s_NF}\" disabled=\"${%s_D}\" readOnly=\"${%s_RO}\" required=\"${%s_R}\" onNumberKr=\"${%s_KR}\" currencyText=\"${%s_CT}\"/>\n"
                                + "</e:field>\n"
                        , columnId, formId
                        , columnId, columnId
                        , formId, formId, formId, formId, formId, formId, formId, formId);
            }
            else if (columnType.equals("combo")) {
                String tempColId = WordUtils.capitalizeFully(columnId.replaceAll("_", " ")).replaceAll(" ", "");
                String colOptions = tempColId.substring(0, 1).toLowerCase() + tempColId.substring(1, tempColId.length()) + "Options";

                tagGuide = String.format("<e:label for=\"%s\" title=\"${%s_N}\"/>\n"
                                + "<e:field>\n"
                                + "<e:select id=\"%s\" name=\"%s\" value=\"\" options=\"${" + colOptions + "}\" width=\"${%s_W}\" disabled=\"${%s_D}\" readOnly=\"${%s_RO}\" required=\"${%s_R}\" placeHolder=\"\" maskType=\"${%s_MT}\" />\n"
                                + "</e:field>"
                        , columnId, formId
                        , columnId, columnId
                        , formId, formId, formId, formId, formId, formId);
            }
            else if (columnType.equals("checkbox")) {

            }
            else {
                tagGuide = "";
            }
            if (EverString.isNotEmpty(tagGuide)) {
                datum.put("TAG_GUIDE", tagGuide);
            }
        }
        resp.setGridObject("jqGrid", gridData);
    }

    @RequestMapping(value = "/MSRA0030/doSave")
    public void msra0030_doSave(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> formData = req.getFormData();
        List<Map<String, Object>> gridData = req.getGridData("jqGrid");

        // 개인정보승인유형을 저장한다.
        String msg = "";
        if(gridData.size() > 0) {
            msg = msra0030_Service.msra0030_doSave(gridData);
        } else {
            msg = msra0030_Service.msra0030_doApprovalTypeUpdate(formData);
        }
        resp.setResponseMessage(msg);
    }

    @RequestMapping(value = "/MSRA0030/doDelete")
    public void msra0030_doDelete(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        List<Map<String, Object>> gridData = req.getGridData("jqGrid");
        String msg = msra0030_Service.msra0030_doDelete(gridData);

        resp.setResponseMessage(msg);
    }

    /**
     * 화면명 : 화면속성정보 조회
     * 처리내용 : 화면에서 사용하는 속성 정보들을 관리하는 화면.
     * 경로 : Popup
     */
    @RequestMapping(value = "/MSRA0031/view")
    public String MSRA0031(EverHttpRequest req) throws Exception {

        /* 관리자 권한이 존재하지 않으면 접속 불가 */
        if (!PropertiesManager.getBoolean("eversrm.system.developmentFlag")) {
            BaseInfo baseInfo = (BaseInfo) req.getSession().getAttribute("ses");
            if (baseInfo.getSuperUserFlag().equals("0")) {
                return "/everqis/noSuperAuth";
            }
        }
        Map<String, String> parameters = reqParamMapToStringMap(req.getParameterMap());
        String multi_nm = getMultiName(parameters.get("multi_cd"));
        parameters.put("multi_nm", multi_nm);
        req.setAttribute("searchParam", parameters);
        return "/eversrm/manager/screen/MSRA0031";
    }

    @RequestMapping(value = "/MSRA0031/doSearch")
    public void msra0031_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> param = req.getFormData();
        List<Map<String, Object>> gridData = msra0030_Service.msra0031_doSearch(param);

        resp.setGridObject("grid", gridData);
    }

    @RequestMapping(value = "/MSRA0031/doSave")
    public void msra0031_doSave(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> searchParm = req.getFormData();
        List<Map<String, Object>> gridData = req.getGridData("grid");
        String msg = msra0030_Service.msra0031_doSave(searchParm, gridData);

        resp.setResponseMessage(msg);
    }

    @RequestMapping(value = "/MSRA0031/doDelete")
    public void msra0031_doDelete(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        List<Map<String, Object>> gridDataParam = req.getGridData("grid");
        String msg = msra0030_Service.msra0031_doDelete(gridDataParam);

        resp.setResponseMessage(msg);
        resp.getWriter().println();
    }

    /**
     * 화면명 : 화면속성정보 Column ID 조회
     * 처리내용 : 화면속성정보 등록시 사용하는 Column ID 정보들을 조회하는 화면.
     * 경로 : Popup
     */
    @RequestMapping(value = "/MSRA0032/view")
    public String MSRA0032(EverHttpRequest req) {

        /* 관리자 권한이 존재하지 않으면 접속 불가 */
        if (!PropertiesManager.getBoolean("eversrm.system.developmentFlag")) {
            BaseInfo baseInfo = (BaseInfo) req.getSession().getAttribute("ses");
            if (baseInfo.getSuperUserFlag().equals("0")) {
                return "/everqis/noSuperAuth";
            }
        }
        return "/eversrm/manager/screen/MSRA0032";
    }

    @RequestMapping(value = "/MSRA0032/doSearchWord")
    public void msra0032_doSearchWord(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.setGridObject("grid", msra0030_Service.msra0032_doSearchWord(req.getFormData()));
    }

    /**
     * 화면명 : 사용자별 컬럼 정의
     * 처리내용 : 로그인한 사용자별로 화면에 보이는 Grid 컬럼에 대한 설정값을 정의할 수 있다.
     * 경로 : 팝업
     */
    @RequestMapping(value = "/MSRA0033/view")
    public String MSRA0033(EverHttpRequest resp) {
        return "/eversrm/manager/screen/MSRA0033";
    }

    @RequestMapping(value = "/MSRA0033/doSearch")
    public void msra0033_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> param = req.getFormData();
        List<Map<String, Object>> list = msra0030_Service.msra0033_doSearch(param);

        resp.setGridObject("grid", list);
    }

    @RequestMapping(value = "/MSRA0033/doSave")
    public void msra0033_doSave(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> param = req.getFormData();
        List<Map<String, Object>> gridData = req.getGridData("grid");
        msra0030_Service.msra0033_doSave(gridData, param);
    }

    @RequestMapping(value = "/MSRA0033/doReset")
    public void msra0033_doReset(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> param = req.getFormData();
        List<Map<String, Object>> gridData = req.getGridData("grid");
        msra0030_Service.msra0033_doReset(gridData, param);
    }

    /**
     * 화면명 : 화면접근권한 관리
     * 처리내용 : 화면관리 화면에서 해당 화면에 대한 접근권한을 관리할 수 있는 화면.
     * 경로 : 팝업
     */
    @RequestMapping(value = "/MSRA0034/view")
    public String MSRA0034(EverHttpRequest req) {
        return "/eversrm/manager/screen/MSRA0034";
    }

    @RequestMapping(value = "/MSRA0034/doSearch")
    public void msra0034_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.setGridObject("grid", msra0030_Service.msra0034_doSearch(req.getFormData()));
    }

    @RequestMapping(value = "/MSRA0034/doSave")
    public void msra0034_doSave(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> formData = req.getFormData();
        List<Map<String, Object>> gridData = req.getGridData("grid");
        String msg = msra0030_Service.msra0034_doSave(formData, gridData);

        resp.setResponseMessage(msg);
    }

    @RequestMapping(value = "/MSRA0034/doDelete")
    public void msra0034_doDelete(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> formData = req.getFormData();
        List<Map<String, Object>> gridDataParam = req.getGridData("grid");
        String msg = msra0030_Service.msra0034_doDelete(formData, gridDataParam);

        resp.setResponseMessage(msg);
    }

    private String getMultiName(String multi_cd) throws Exception {

        List<Map<String, String>> multiNameList = commonComboService.getCodeCombo("M048");
        String multi_name_value = null;
        for (Map<String, String> map : multiNameList) {
            if (map.get("value").equals(multi_cd)) {
                multi_name_value = map.get("text");
            }
        }
        return multi_name_value;
    }

    /**
     * 화면명 : 그리드 이미지 관리
     * 처리내용 : 그리드의 해당 컬럼에 이미지를 삽입한다.
     * 경로 : 팝업
     */
    @RequestMapping(value = "/MSRA0035/view")
    public String MSRA0035(EverHttpRequest req) {
        req.setAttribute("form", req.getParamDataMap());

        return "/eversrm/manager/screen/MSRA0035";
    }

    @RequestMapping(value = "/MSRA0035/doSearch")
    public void msra0035_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.setGridObject("grid", msra0030_Service.msra0035_doSearch(req.getFormData()));
    }

    @RequestMapping(value = "/MSRA0035/doSave")
    public void msra0035_doSave(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        msra0030_Service.msra0035_doSave(req.getGridData("grid"));
    }
}