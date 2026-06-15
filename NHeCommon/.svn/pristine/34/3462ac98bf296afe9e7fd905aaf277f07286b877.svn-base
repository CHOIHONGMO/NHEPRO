package com.st_ones.eversrm.manager.screen.service;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import com.st_ones.everf.serverside.util.StringUtil;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.st_ones.common.cache.data.BottomBarInfoCache;
import com.st_ones.common.cache.data.ColumnInfoCache;
import com.st_ones.common.cache.data.FormInfoCache;
import com.st_ones.common.cache.data.MessageCache;
import com.st_ones.common.cache.data.MulgMtCache;
import com.st_ones.common.cache.data.MulgPopupInfoCache;
import com.st_ones.common.cache.data.MulgPopupNameCache;
import com.st_ones.common.cache.data.MulgSaCache;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.everf.serverside.info.BaseInfo;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.info.UserInfoNotFoundException;
import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.eversrm.manager.screen.MSRA0030_Mapper;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : MSRA0030_Service.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

@Service(value = "msra0030_Service")
public class MSRA0030_Service extends BaseService {

    @Autowired private MessageService msg;

    @Autowired private MessageCache messageCache;

    @Autowired private ColumnInfoCache columnInfoCache;

    @Autowired private BottomBarInfoCache bottomBarInfoCache;

    @Autowired private FormInfoCache formInfoCache;

    @Autowired private MulgSaCache mulgSaCache;

    @Autowired private MulgPopupNameCache mulgPopupNameCache;

    @Autowired private MulgPopupInfoCache mulgPopupInfoCache;

    @Autowired private MulgMtCache mulgMtCache;

    @Autowired private MSRA0030_Mapper msra0030_Mapper;

    /**
     * 화면명 : 화면속성관리
     * 처리내용 : 화면에서 사용하는 속성 정보들을 관리하는 화면.
     * 경로 : 시스템관리 > 화면 > 화면속성관리
     */
    public String msra0030_doSearchApprovalType(Map<String, String> paramMap) {
        return msra0030_Mapper.msra0030_doSearchApprovalType(paramMap);
    }

    public List<Map<String, Object>> msra0030_doSearchDataLength(Map<String, String> param) {
        return msra0030_Mapper.msra0030_doSearchDataLength(param);
    }

    public List<Map<String, Object>> msra0030_doSearchDOMC(Map<String, String> param) {
        return msra0030_Mapper.msra0030_doSearchDOMC(param);
    }

    public Map<String, String> msra0030_getMostUsedWord(Map<String, String> param) {
        return msra0030_Mapper.msra0030_getMostUsedWord(param);
    }

    public List<Map<String, Object>> msra0030_doSearch(Map<String, String> param) {

        List<Map<String, Object>> multiLanguageData = msra0030_Mapper.msra0030_doSearch(param);

        for (Map<String, Object> map : multiLanguageData) {
            int width = 0;
            if (map.get("COLUMN_WIDTH") != null)
                width = ((BigDecimal)map.get("COLUMN_WIDTH")).intValue();

            if (width > 0 && width < 10)
                map.put("WIDTH_UNIT", "F");
            else
                map.put("WIDTH_UNIT", "X");
        }
        return multiLanguageData;
    }

    @SuppressWarnings("rawtypes")
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String msra0030_doSave(List<Map<String, Object>> gridDatas) throws Exception {

        for (int i = 0; i < gridDatas.size(); i++) {

            Map<String, Object> gridMap = gridDatas.get(i);
            Iterator<String> mapItor = gridMap.keySet().iterator();

            while (mapItor.hasNext()) {
                String keyVal = mapItor.next();
                if ("GATE_CD".equals(keyVal) || "SCREEN_ID".equals(keyVal) || "LANG_CD".equals(keyVal) || "MULTI_CD".equals(keyVal) || "FORM_GRID_ID".equals(keyVal)) {
                    String tmpVal = (String)gridMap.get(keyVal);
                    gridDatas.get(i).put(keyVal, tmpVal.trim());
                }
            }
        }

        int checkCnt = 0;
        String checkId = "";

        convertMultiContentsQuatation(gridDatas);

        for (Map<String, Object> gridData : gridDatas) {

            gridData.put("exclusion", "true");

            checkCnt = msra0030_Mapper.checkColumnId(gridData);

            // checkCnt == 0 ? insert : update
            if (checkCnt == 0) {
                msra0030_Mapper.msra0030_doInsert(gridData);
                removeCache(gridData);
            }
            else {
                checkId = checkId + gridData.get("MULTI_CD") + ",";
                msra0030_Mapper.msra0030_doUpdate(gridData);
                removeCache(gridData);
            }
        }
        checkId = checkId.length() > 0 ? checkId.substring(0, checkId.length() - 1) : checkId;
        return (checkId.length() > 0 ? msg.getMessage("0032", checkId) : msg.getMessage("0031"));
    }

    public String msra0030_doApprovalTypeUpdate(Map<String, String> formData) throws Exception {
        msra0030_Mapper.msra0030_doApprovalTypeUpdate(formData);
        return msg.getMessage("0031");
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String msra0030_doDelete(List<Map<String, Object>> gridDatas) throws Exception {

        for (Map<String, Object> gridData : gridDatas) {
            msra0030_Mapper.msra0030_doDelete(gridData);
            removeCache(gridData);
        }
        return msg.getMessage("0017");
    }

    /**
     * 화면명 : 화면속성정보 조회
     * 처리내용 : 화면에서 사용하는 속성 정보들을 관리하는 화면.
     * 경로 : Popup
     */
    public List<Map<String, Object>> msra0031_doSearch(Map<String, String> param) {
        return msra0030_Mapper.msra0031_doSearch(param);
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class, timeout = -1)
    public String msra0031_doSave(Map<String, String> param, List<Map<String, Object>> gridDatas) throws Exception {

        for (Map<String, Object> gridData : gridDatas) {

            gridData.put("MULTI_NM", EverString.isEmpty((String) gridData.get("MULTI_NM")) ? param.get("multi_nm") : gridData.get("MULTI_NM"));
            gridData.put("MULTI_CD", EverString.isEmpty((String) gridData.get("MULTI_CD")) ? param.get("multi_cd") : gridData.get("MULTI_CD"));
            gridData.put("SCREEN_ID", EverString.isEmpty((String) gridData.get("SCREEN_ID")) ? param.get("screen_id") : gridData.get("SCREEN_ID"));
            gridData.put("ACTION_CD", EverString.isEmpty((String) gridData.get("ACTION_CD")) ? param.get("action_cd") : gridData.get("ACTION_CD"));
            gridData.put("TMPL_MENU_CD", EverString.isEmpty((String) gridData.get("TMPL_MENU_CD")) ? param.get("tmpl_menu_cd") : gridData.get("TMPL_MENU_CD"));
            gridData.put("AUTH_CD", EverString.isEmpty((String) gridData.get("AUTH_CD")) ? param.get("auth_cd") : gridData.get("AUTH_CD"));
            gridData.put("ACTION_PROFILE_CD", EverString.isEmpty((String) gridData.get("ACTION_PROFILE_CD")) ? param.get("action_profile_cd") : gridData.get("ACTION_PROFILE_CD"));
            gridData.put("TMPL_MENU_GROUP_CD", EverString.isEmpty((String) gridData.get("TMPL_MENU_GROUP_CD")) ? param.get("tmpl_menu_group_cd") : gridData.get("TMPL_MENU_GROUP_CD"));
            gridData.put("MENU_GROUP_CD", EverString.isEmpty((String) gridData.get("MENU_GROUP_CD")) ? param.get("menu_group_cd") : gridData.get("MENU_GROUP_CD"));
            gridData.put("COMMON_ID", EverString.isEmpty((String) gridData.get("COMMON_ID")) ? param.get("common_id") : gridData.get("COMMON_ID"));
            gridData.put("OTHER_CD", EverString.isEmpty((String) gridData.get("OTHER_CD")) ? param.get("other_cd") : gridData.get("OTHER_CD"));

            Iterator<String> mapItor = gridData.keySet().iterator();
            while (mapItor.hasNext()) {

                String keyVal = mapItor.next();

                if ("GATE_CD".equals(keyVal) || "MULTI_SQ".equals(keyVal) || "LANG_CD".equals(keyVal)) {
                    String tmpVal = "";
                    if(gridData.get(keyVal) instanceof Integer || gridData.get(keyVal) instanceof Long) {
                        tmpVal = String.valueOf(gridData.get(keyVal));
                    } else {
                        tmpVal = (String) gridData.get(keyVal);
                    }
                    if (tmpVal== null) {
                        tmpVal="";
                    }
                    gridData.put(keyVal, tmpVal.trim());
                }
            }

            if ("U".equals(gridData.get("INSERT_FLAG"))) {
                msra0030_Mapper.msra0031_doUpdate(gridData);
                removeMulgCache(gridData);
            } else {
                msra0030_Mapper.msra0031_doInsert(gridData);
                removeMulgCache(gridData);
            }
        }
        return msg.getMessage("0001");
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String msra0031_doDelete(List<Map<String, Object>> gridData) throws Exception {

        for (Map<String, Object> gridRow : gridData) {
            if (EverString.isEmpty(gridRow.get("MULTI_SQ") instanceof String ? (String) gridRow.get("MULTI_SQ") : String.valueOf(gridRow.get("MULTI_SQ")))) {
                continue;
            }
            msra0030_Mapper.msra0031_doDelete(gridRow);
            initMulgCache();
        }
        return msg.getMessage("0017");
    }

    /**
     * 화면명 : 화면속성정보 Column ID 조회
     * 처리내용 : 화면속성정보 등록시 사용하는 Column ID 정보들을 조회하는 화면.
     * 경로 : Popup
     */
    public List<Map<String, Object>> msra0032_doSearchWord(Map<String, String> param) {

        BaseInfo baseInfo = UserInfoManager.getUserInfoImpl();

        String[] tmp = param.get("SEARCH_WORD").split("_");
        String sqlQuery = "";

        for (int i = tmp.length-1, y = 0; i > 0; i--, y++) {
            if (EverString.isNotEmpty(tmp[i])) {
                sqlQuery = sqlQuery + "UNION ALL \n";
                sqlQuery = sqlQuery + "SELECT FORMAT, DOMAIN_TYPE, DOMAIN_NM, DATA, DATA_LENGTH, PRE_FORMAT, ALIGNMENT, COL_WIDTH, '" + (y + 3) + "' AS NUM FROM STOCDOMA \n";
                sqlQuery = sqlQuery + "WHERE GATE_CD = '" + baseInfo.getGateCd() + "' AND UPPER(DOMAIN_NM) = UPPER('_" + EverString.CheckInjection(tmp[i]) + "')\n";
            }
        }
        param.put("sqlQuery", sqlQuery);
        return msra0030_Mapper.msra0032_doSearchWord(param);
    }

    /**
     * 화면명 : 사용자별 컬럼 정의
     * 처리내용 : 로그인한 사용자별로 화면에 보이는 Grid 컬럼에 대한 설정값을 정의할 수 있다.
     * 경로 : 팝업
     */
    public List<Map<String, Object>> msra0033_doSearch(Map<String, String> param) {

        List<Map<String, Object>> gridData;
        int checkCnt = msra0030_Mapper.checkUSLN(param);

        if (checkCnt == 0 ){
            //공통 - 화면속성관리의 그리드 레이아웃 데이터 조회
            gridData = msra0030_Mapper.msra0033_STOCLANG_Search(param);
        }else {
            //사용자별 - 사용자별 그리드 레이아웃 데이터 조회
            gridData = msra0030_Mapper.msra0033_STOCUSCC_Search(param);
        }
        return gridData;
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public void msra0033_doSave(List<Map<String, Object>> gridData, Map<String, String> param) throws Exception {


        msra0030_Mapper.msra0033_doDelete(param); //해당데이터 삭제후 insert

        for (Map<String, Object> grid : gridData) {

            if(grid.get("DISABLE_FLAG").equals("0")){  //표기x 면 넓이 =0
                grid.put("COLUMN_WIDTH",0);
            }else{ // 표기면 넓이 지정 또는 디폴트
                if(Integer.parseInt(grid.get("COLUMN_WIDTH").toString())>0){
                    grid.put("COLUMN_WIDTH", grid.get("COLUMN_WIDTH"));
                }else{
                    grid.put("COLUMN_WIDTH", grid.get("ORI_COLUMN_WIDTH"));
                }
            }
            msra0030_Mapper.msra0033_doSave(grid);

            String screenId = (String)grid.get("SCREEN_ID");
            String gridId = (String)grid.get("FORM_GRID_ID");
            String langCd = (String)grid.get("LANG_CD");

            columnInfoCache.removeData(screenId, gridId, langCd);
        }
    }

    public void msra0033_doReset(List<Map<String, Object>> gridData, Map<String, String> param) throws Exception {

        msra0030_Mapper.msra0033_doDelete(param);

        for (Map<String, Object> grid : gridData) {
            String screenId = (String)grid.get("SCREEN_ID");
            String gridId = (String)grid.get("FORM_GRID_ID");
            String langCd = (String)grid.get("LANG_CD");
            columnInfoCache.removeData(screenId, gridId, langCd);
        }
    }

    /**
     * 화면명 : 화면접근권한 관리
     * 처리내용 : 화면관리 화면에서 해당 화면에 대한 접근권한을 관리할 수 있는 화면.
     * 경로 : 팝업
     */
    public List<Map<String, Object>> msra0034_doSearch(Map<String, String> param) {


        List<Map<String, Object>> resultGridData = new ArrayList<Map<String, Object>>();
        Map<String, String> screenAccessibleData = msra0030_Mapper.msra0034_doSearch(param);

        if(screenAccessibleData != null) {

            String screenNotAccessibleCode = screenAccessibleData.get("TEXT1");
            String screenNotAccessibleUserIds = screenAccessibleData.get("TEXT2");
            String screenAccessibleCode = screenAccessibleData.get("TEXT3");
            if(StringUtils.isNotEmpty(screenAccessibleCode)) {
                Map<String, Object> rowData = new HashMap<String, Object>();
                rowData.put("AUTH_TYPE", "PD");
                rowData.put("AUTH_CONTENTS", screenAccessibleCode);
                resultGridData.add(rowData);
            }
            if(StringUtils.isNotEmpty(screenNotAccessibleCode)) {
                Map<String, Object> rowData = new HashMap<String, Object>();
                rowData.put("AUTH_TYPE", "CD");
                rowData.put("AUTH_CONTENTS", screenNotAccessibleCode);
                resultGridData.add(rowData);
            }
            if(StringUtils.isNotEmpty(screenNotAccessibleUserIds)) {
                String[] arrayOfUserIds = screenNotAccessibleUserIds.split(",");
                for (String userId : arrayOfUserIds) {
                    Map<String, Object> rowData = new HashMap<String, Object>();
                    rowData.put("AUTH_TYPE", "ID");
                    rowData.put("AUTH_CONTENTS", userId);
                    resultGridData.add(rowData);
                }
            }
        }
        return resultGridData;
    }

    public String msra0034_doSave(Map<String, String> formData, List<Map<String, Object>> gridData) throws Exception {

        String notAccessibleUserId = "";
        for (Map<String, Object> rowData : gridData) {
            if(StringUtils.equals((String)rowData.get("AUTH_TYPE"), "CD")) {
                formData.put("TEXT1", (String)rowData.get("AUTH_CONTENTS"));
            } else if(StringUtils.equals((String)rowData.get("AUTH_TYPE"), "ID")) {
                String authContents = (String)rowData.get("AUTH_CONTENTS");
                notAccessibleUserId = notAccessibleUserId + authContents + ",";
            } else if(StringUtils.equals((String)rowData.get("AUTH_TYPE"), "PD")) {
                formData.put("TEXT3", (String)rowData.get("AUTH_CONTENTS"));
            }
        }

        formData.put("TEXT2", notAccessibleUserId);

        if(msra0030_Mapper.getCountExistsScreenAccessibleCode(formData) == 0) {
            msra0030_Mapper.msra0034_insertScreenAccessibleCd(formData);
        } else {
            msra0030_Mapper.msra0034_updateScreenAccessibleCd(formData);
        }
        return msg.getMessage("0001");
    }

    public String msra0034_doDelete(Map<String, String> formData, List<Map<String, Object>> gridData) throws Exception {

        String notAccessibleUserId = "";
        for (Map<String, Object> rowData : gridData) {
            if(!StringUtils.equals((String)rowData.get("DEL_FLAG"), "1")) {
                if(StringUtils.equals((String)rowData.get("AUTH_TYPE"), "CD")) {
                    formData.put("TEXT1", (String)rowData.get("AUTH_CONTENTS"));
                } else if(StringUtils.equals((String)rowData.get("AUTH_TYPE"), "ID")) {
                    String authContents = (String)rowData.get("AUTH_CONTENTS");
                    notAccessibleUserId = notAccessibleUserId + authContents + ",";
                }
            }
        }
        formData.put("TEXT2", notAccessibleUserId);

        msra0030_Mapper.msra0034_updateScreenAccessibleCd(formData);
        return msg.getMessage("0017");
    }

    private void convertMultiContentsQuatation(List<Map<String, Object>> gridDatas) {

        for (Map<String, Object> gridData : gridDatas) {
            String value = (String)gridData.get("MULTI_CONTENTS");
            value = value.replace("'", "’");
            value = value.replace("\"", "＂");
            gridData.put("MULTI_CONTENTS", value);
        }
    }

    private void removeCache(Map<String, Object> gridData) {

        String screenId = (String)gridData.get("SCREEN_ID");
        String gridId = (String)gridData.get("FORM_GRID_ID");
        String langCd = (String)gridData.get("LANG_CD");
        messageCache.removeData(screenId, langCd);
        formInfoCache.removeData(screenId, langCd);
        columnInfoCache.removeData(screenId, gridId, langCd);
        bottomBarInfoCache.removeData(langCd);
    }

    public void removeMulgCache(Map<String, Object> gridData) {

        String screenId = (String) gridData.get("SCREEN_ID");
        String langCd = (String) gridData.get("LANG_CD");
        String commonId = (String) gridData.get("COMMON_ID");
        String tmplMenuCd = (String) gridData.get("TMPL_MENU_CD");
        String multiCd = (String) gridData.get("MULTI_CD");

        mulgMtCache.removeData(tmplMenuCd, langCd);
        mulgPopupInfoCache.removeData(commonId, langCd);
        mulgSaCache.removeData(screenId, langCd);
        mulgPopupNameCache.removeData(screenId, multiCd, langCd);
    }

    public void initMulgCache() {
        mulgMtCache.initData();
        mulgPopupInfoCache.initData();
        mulgSaCache.initData();
        mulgPopupNameCache.initData();
    }

    public List<Map<String, Object>> msra0035_doSearch(Map<String, String> formData) {
        return msra0030_Mapper.msra0035_doSearch(formData);
    }

    public void msra0035_doSave(List<Map<String, Object>> gridData) {

        for (Map<String, Object> grid : gridData) {
            if (grid.get("SORT_SQ") == null) {
                msra0030_Mapper.msra0035_doInsert(grid);
            } else {
                msra0030_Mapper.msra0035_doUpdate(grid);
            }
        }
    }
}