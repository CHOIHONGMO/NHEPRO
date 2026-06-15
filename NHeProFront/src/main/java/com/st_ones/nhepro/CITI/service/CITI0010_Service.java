package com.st_ones.nhepro.CITI.service;

import com.st_ones.common.docNum.service.DocNumService;
import com.st_ones.common.generator.service.QueryGenService;
import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.exception.NoResultException;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.nhepro.CITI.CITI0010_Mapper;
import org.apache.commons.lang.StringUtils;
import org.h2.engine.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

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
 * @File Name : CITI0010_Service.java
 * @date 2020.03.05
 * @version 1.0
 * @see
 */
@Service(value = "CITI0010_Service")
public class CITI0010_Service {
    /**
     * The CITI0010_Mapper.
     */
    @Autowired CITI0010_Mapper citi0010_mapper;
    /**
     * The Msg.
     */
    @Autowired MessageService msg;
    /**
     * The Doc num service.
     */
    @Autowired DocNumService docNumService;

    @Autowired private QueryGenService queryGenService;

    /**
     * 화면명 : 품목등록신청
     * 처리내용 : 신규품목요청
     * 경로 : 기준정보 > 품목관리 > 품목등록신청
     */
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String citi0010_doRequest(List<Map<String, Object>> gridDatas) throws Exception {

        UserInfo userInfo = UserInfoManager.getUserInfo();

        // 채번로직 변경. Parameter [화면에서 전달 받은 COMPANY_CD (없는 경우, ses.manageCd 또는 ses.companyCd), DOC_TYPE ]
        String docNo = docNumService.getDocNumber(userInfo.getCompanyCd(), "RE");

        for (Map<String, Object> gridData : gridDatas) {
            gridData.put("ITEM_REQ_NO", docNo);
            gridData.put("PROGRESS_CD", "100");

            citi0010_mapper.citi0010_doInsert(gridData);
        }

        /*
        String templatePath = PropertiesManager.getString("eversrm.system.mailTemplatePath");
        String templateFileNm = templatePath + PropertiesManager.getString("eversrm.system.BNM1_TemplateFileName");
        String fileContents = EverFile.fileReadByOffsetByEncoding(templateFileNm, "UTF-8");

        Map<String, String> param = new HashMap<String, String>();
        param.put("REQ_NO", docNo);
        param.put("fileContents", fileContents);

        sendMail(param);
        */

        return msg.getMessage("0122");
    }

    /**
     * 화면명 : 품목등록신청현황
     * 처리내용 : 신규로 등록요청한 품목정보에 대한 내용을 확인하는 화면
     * 경로 : 기준정보 > 품목관리 > 품목등록신청현황
     */
    public List<Map<String, Object>> citr0020_doSearch(Map<String, String> formData) {
        Map<String, String> sParam = new HashMap<String, String>();

        if(!EverString.nullToEmptyString(formData.get("ITEM_DESC")).equals("")) {
            sParam.put("COL_VAL", formData.get("ITEM_DESC"));
            sParam.put("COL_NM", "UPPER(ITEM_DESC)");
            formData.put("ITEM_DESC", EverString.nullToEmptyString(queryGenService.generateSearchCondition(sParam)));
        }
        if(!EverString.nullToEmptyString(formData.get("ITEM_SPEC")).equals("")) {
            sParam.put("COL_VAL", formData.get("ITEM_SPEC"));
            sParam.put("COL_NM", "UPPER(ITEM_SPEC)");
            formData.put("ITEM_SPEC", EverString.nullToEmptyString(queryGenService.generateSearchCondition(sParam)));
        }

        return citi0010_mapper.citr0020_doSearch(formData);
    }

    /**
     * 화면명 : 품목요청상세
     * 처리내용 : 품목등록신청 후 상세 페이지를 호출
     * 경로 : 기준정보 > 품목관리 > 품목등록신청현황 > 품목요청상세(팝업)
     */
    public Map<String, String> cita0021_doSearch(Map<String, String> formData) {
        return citi0010_mapper.cita0021_doSearch(formData);
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public void cita0021_doRequest(Map<String, String> formData) {
        citi0010_mapper.cita0021_doRequest(formData);
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public void cita0021_doDelete(Map<String, String> formData) {
        citi0010_mapper.cita0021_doDelete(formData);
    }

    /**
     * 화면명 : 품목등록승인현황
     * 처리내용 : 신규로 등록요청한 품목정보에 대한 내용을 재요청하는 화면
     * 경로 : 기준정보 > 품목관리 > 품목등록승인현황
     */
    /**
     * 화면명 : 품목등록신청현황
     * 처리내용 : 신규로 등록요청한 품목정보에 대한 내용을 확인하는 화면
     * 경로 : 기준정보 > 품목관리 > 품목등록신청현황
     */
    public List<Map<String, Object>> citr0030_doSearch(Map<String, String> formData) {
        Map<String, String> sParam = new HashMap<String, String>();

        if(!EverString.nullToEmptyString(formData.get("ITEM_DESC")).equals("")) {
            sParam.put("COL_VAL", formData.get("ITEM_DESC"));
            sParam.put("COL_NM", "UPPER(ITEM_DESC)");
            formData.put("ITEM_DESC", EverString.nullToEmptyString(queryGenService.generateSearchCondition(sParam)));
        }
        if(!EverString.nullToEmptyString(formData.get("ITEM_SPEC")).equals("")) {
            sParam.put("COL_VAL", formData.get("ITEM_SPEC"));
            sParam.put("COL_NM", "UPPER(ITEM_SPEC)");
            formData.put("ITEM_SPEC", EverString.nullToEmptyString(queryGenService.generateSearchCondition(sParam)));
        }

        return citi0010_mapper.citr0030_doSearch(formData);
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public void citr0030_doRequest(List<Map<String, Object>> gridData) {
        for (Map<String, Object> grid : gridData) {
            citi0010_mapper.citr0030_doRequest(grid);
        }
    }

    /**
     * 화면명 : 품목요청등록
     * 처리내용 : 품목등록승인현황에서 요청번호를 클릭하여 품목요청을 등록한다.
     * 경로 : 기준정보 > 품목관리 > 품목등록승인현황 > 품목요청등(팝업)
     */
    public Map<String, String> cita0031_doSearch(Map<String, String> paramData) {
        return citi0010_mapper.cita0031_doSearch(paramData);
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public Map<String, String> cita0031_doSave(Map<String, String> formData) throws Exception {

        UserInfo userInfo = UserInfoManager.getUserInfo();

        Map<String, String> rtnMap = new HashMap<String, String>();
        String itemCd = EverString.nullToEmptyString(formData.get("ITEM_CD"));
        String stdItemCd = "";

        formData.put("PROGRESS_CD","E"); //현재 무조건 승인으로 등록

        // 신규등록일경우 상품코드 번호채번, 품목 등록 | 수정 --------------------------------------------------
        if (itemCd.equals("")) {
            // 품목 insert
            // 채번로직 변경. Parameter [화면에서 전달 받은 COMPANY_CD (없는 경우, ses.manageCd 또는 ses.companyCd), DOC_TYPE ]
            itemCd = formData.get("ITEM_CLS1") + docNumService.getDocNumber(userInfo.getCompanyCd(), "IT");
            formData.put("ITEM_CD", itemCd);
            formData.put("STD_ITEM_CD", (formData.get("STD_ITEM_CD") == null || EverString.nullToEmptyString(formData.get("STD_ITEM_CD")).equals("") ? itemCd : EverString.nullToEmptyString(formData.get("STD_ITEM_CD"))));
            citi0010_mapper.cita0031_MTGL_Insert(formData);
        } else {
            // 품목 update
            formData.put("STD_ITEM_CD", (formData.get("STD_ITEM_CD") == null || EverString.nullToEmptyString(formData.get("STD_ITEM_CD")).equals("") ? itemCd : EverString.nullToEmptyString(formData.get("STD_ITEM_CD"))));
            citi0010_mapper.cita0031_MTGL_Update(formData);
        }

        // 이미지저장 -------------------------------------------------------------------------------------
        // 메인이미지 정보 초기화 후, 메인이미지가 있으면 저장
        citi0010_mapper.cita0031_doDeleteMTIM(formData);
        if (StringUtils.isNotEmpty(formData.get("MAIN_IMG_SQ"))) {
            citi0010_mapper.cita0031_doSaveMTIM(formData);
        }

        // 품목분류매핑저장
        citi0010_mapper.cita0031_doSaveMTGC(formData); // 분류맵핑

        if ("1".equals(formData.get("MKBR_FLAG"))) {
            // 고객사-신규품목등록요청 UPDATE
            citi0010_mapper.cita0031_doUpdateNWRQ(formData);
        } else {
            rtnMap.put("ITEM_CD", itemCd);
            rtnMap.put("STD_ITEM_CD", "".equals(stdItemCd) ? itemCd : stdItemCd);
        }
        rtnMap.put("rtnMsg", msg.getMessage("0031"));

        return rtnMap;
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public void cita0044_doDelete(Map<String, String> formData) {
        citi0010_mapper.cita0044_doDeleteMTGL(formData);
        citi0010_mapper.cita0044_doDeleteMTIM(formData);
        citi0010_mapper.cita0044_doDeleteMTGC(formData);
    }

    /**
     * 화면명 : 품목현황
     * 처리내용 : 고객사 기준정보의 품목현황 조회 및 처리
     * 경로 : 기준정보 >  > 품목관리 > 품목현황
     */
    public List<Map<String, Object>> citr0040_doSearch(Map<String, String> formData) {
    	
    	Map<String, String> sParam = new HashMap<String, String>();
        if(!EverString.nullToEmptyString(formData.get("ITEM_DESC")).equals("")) {
            sParam.put("COL_VAL", formData.get("ITEM_DESC"));
            sParam.put("COL_NM", "UPPER(ITEM_DESC)");
            formData.put("ITEM_DESC", EverString.nullToEmptyString(queryGenService.generateSearchCondition(sParam)));
        }
        if(!EverString.nullToEmptyString(formData.get("ITEM_SPEC")).equals("")) {
            sParam.put("COL_VAL", formData.get("ITEM_SPEC"));
            sParam.put("COL_NM", "UPPER(ITEM_SPEC)");
            formData.put("ITEM_SPEC", EverString.nullToEmptyString(queryGenService.generateSearchCondition(sParam)));
        }
        /* 2020.12.04 : 제조사, 브랜드 제외
        if(!EverString.nullToEmptyString(formData.get("MAKER_NM")).equals("")) {
            sParam.put("COL_VAL", formData.get("MAKER_NM"));
            sParam.put("COL_NM", "MAKER_NM");
            formData.put("MAKER_NM", EverString.nullToEmptyString(queryGenService.generateSearchCondition(sParam)));
        }
        if(!EverString.nullToEmptyString(formData.get("BRAND_NM")).equals("")) {
            sParam.put("COL_VAL", formData.get("BRAND_NM"));
            sParam.put("COL_NM", "BRAND_NM");
            formData.put("BRAND_NM", EverString.nullToEmptyString(queryGenService.generateSearchCondition(sParam)));
        }*/

        return citi0010_mapper.citr0040_doSearch(formData);
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public void citr0040_doSave(List<Map<String, Object>> gridData) throws Exception {

        UserInfo userInfo = UserInfoManager.getUserInfo();

        for (Map<String, Object> grid : gridData) {
            Map<String, String> map = (Map) grid;

            if ("".equals(EverString.nullToEmptyString(grid.get("ITEM_CD")))) {
                // 신규등록일경우 상품코드 번호채번, 품목 등록
                String itemCd = grid.get("ITEM_CLS1") + docNumService.getDocNumber(userInfo.getCompanyCd(), "IT");
                String stdItemCd = (grid.get("STD_ITEM_CD") == null || EverString.nullToEmptyString(grid.get("STD_ITEM_CD")).equals("") ? itemCd : EverString.nullToEmptyString(grid.get("STD_ITEM_CD")));
                grid.put("ITEM_CD", itemCd);
                grid.put("STD_ITEM_CD", stdItemCd);
                grid.put("PROGRESS_CD", "E");

                // MAKER / BRAND 명으로 동일한 명이 존재 시 UPDATE 아니면 INSERT
                List<Map<String, Object>> mkbrList = citi0010_mapper.citr0040_doSearchListMKBR(grid);

                if (mkbrList.size() > 0) {
                    // UPDATE
                    for (Map<String, Object> mkbr : mkbrList) {
                        if ("MK".equals(mkbr.get("MKBR_TYPE"))) {
                            grid.put("MAKER_CD", mkbr.get("MKBR_CD"));
                        } else {
                            grid.put("BRAND_CD", mkbr.get("MKBR_CD"));
                        }
                    }
                } else {
                    // INSERT
                    grid.put("USE_FLAG", "1");

                    if(!"".equals(EverString.nullToEmptyString(grid.get("MAKER_NM")))) {
                        grid.put("MKBR_TYPE", "MK");
                        grid.put("MKBR_NM", grid.get("MAKER_NM"));

                        citi0010_mapper.citr0060_doSave(grid);
                    }

                    if(!"".equals(EverString.nullToEmptyString(grid.get("BRAND_NM")))) {
                        grid.put("MKBR_TYPE", "BR");
                        grid.put("MKBR_NM", grid.get("BRAND_NM"));

                        citi0010_mapper.citr0060_doSave(grid);
                    }

                    // 저장 후 MAKER_CD / BRAND_CD 조회 후 put
                    Map<String, String> mkbrCd = citi0010_mapper.citr0040_doSearchMapMKBR(grid);
                    grid.put("MAKER_CD", mkbrCd.get("MAKER_CD"));
                    grid.put("BRAND_CD", mkbrCd.get("BRAND_CD"));
                }

                map = (Map) grid;
                citi0010_mapper.cita0031_MTGL_Insert(map);
            } else {
                // STOCMTGL UPDATE
                citi0010_mapper.cita0031_MTGL_Update(map);
            }

            citi0010_mapper.cita0031_doSaveMTGC(map);
        }
    }

    /**
     * 화면명 : 품목상세
     * 처리내용 : 품목현황에서 품목코드 클릭 시 품목상세 화면 호출
     * 경로 : 기준정보 > 품목관리 > 품목현황 > 품목상세(팝업)
     */
    public Map<String, String> citr0041_doSearchInfo(Map<String, String> formData) {
        return citi0010_mapper.citr0041_doSearchInfo(formData);
    }

    /**
     * 화면명 : 품목검색
     * 처리내용 : 품목 세분류의 속성을 매핑하는 화면.
     * 경로 : 고객사 > 품목관리 > 품목현황 > 품목검색(팝업) - 공통
     */
    public List<Map<String, Object>> citr0042_doSearchGrid(Map<String, String> formData) {
        Map<String, String> sParam = new HashMap<String, String>();

        if(!EverString.nullToEmptyString(formData.get("ITEM_INFO")).equals("")) {
            sParam.put("COL_VAL", formData.get("ITEM_INFO"));
            sParam.put("COL_NM", "UPPER(ITEM_DESC)");
            formData.put("ITEM_DESC", EverString.nullToEmptyString(queryGenService.generateSearchCondition(sParam)));
            
            sParam.put("COL_NM", "UPPER(ITEM_SPEC)");
            formData.put("ITEM_SPEC", EverString.nullToEmptyString(queryGenService.generateSearchCondition(sParam)));
        }
        /* 2020.12.04 : 제조사, 브랜드 제외
        if(!EverString.nullToEmptyString(formData.get("MAKER_NM")).equals("")) {
            sParam.put("COL_VAL", formData.get("MAKER_NM"));
            sParam.put("COL_NM", "MAKER_NM");
            formData.put("MAKER_NM", EverString.nullToEmptyString(queryGenService.generateSearchCondition(sParam)));
        }
        if(!EverString.nullToEmptyString(formData.get("BRAND_NM")).equals("")) {
            sParam.put("COL_VAL", formData.get("BRAND_NM"));
            sParam.put("COL_NM", "BRAND_NM");
            formData.put("BRAND_NM", EverString.nullToEmptyString(queryGenService.generateSearchCondition(sParam)));
        }*/

        return citi0010_mapper.citr0042_doSearchGrid(formData);
    }

    /**
     * 화면명 : 품목분류
     * 처리내용 : 품목요청등록 화면에서 분목분류 클릭 시 팝업 호출
     * 경로 : 기준정보 >  > 품목관리 > 품목등록승인현황 > 품목요청등록 > 품목분류 (팝업)
     */
    public List<Map<String, Object>> citr0043_doSearch_ItemClassPopup_TREE(Map<String, String> formData) {
        formData.put("manageFlag", "0");
        return citi0010_mapper.citr0043_doSearch_ItemClassPopup_TREE(formData);
    }

    /**
     * 화면명 : 표준관리 품목검색
     * 처리내용 : 품목 세분류의 속성을 매핑하는 화면.
     * 경로 : 고객사 > 품목관리 > 품목현황 > 표준관리 품목검색(팝업)
     */
    public List<Map<String, Object>> citr0045_doSearch_ItemClassPopup_TREE(Map<String, String> formData) {
        formData.put("manageFlag", "1");
        return citi0010_mapper.citr0043_doSearch_ItemClassPopup_TREE(formData);
    }

    public List<Map<String, Object>> citr0045_doSearchGrid(Map<String, String> formData) {
        Map<String, String> sParam = new HashMap<String, String>();

        if(!EverString.nullToEmptyString(formData.get("ITEM_DESC")).equals("")) {
            sParam.put("COL_VAL", formData.get("ITEM_DESC"));
            sParam.put("COL_NM", "UPPER(ITEM_DESC)");
            formData.put("ITEM_DESC", EverString.nullToEmptyString(queryGenService.generateSearchCondition(sParam)));
        }
        if(!EverString.nullToEmptyString(formData.get("ITEM_SPEC")).equals("")) {
            sParam.put("COL_VAL", formData.get("ITEM_SPEC"));
            sParam.put("COL_NM", "UPPER(ITEM_SPEC)");
            formData.put("ITEM_SPEC", EverString.nullToEmptyString(queryGenService.generateSearchCondition(sParam)));
        }
        /* 제조사, 브랜드 제외
        if(!EverString.nullToEmptyString(formData.get("MAKER_NM")).equals("")) {
            sParam.put("COL_VAL", formData.get("MAKER_NM"));
            sParam.put("COL_NM", "MAKER_NM");
            formData.put("MAKER_NM", EverString.nullToEmptyString(queryGenService.generateSearchCondition(sParam)));
        }
        if(!EverString.nullToEmptyString(formData.get("BRAND_NM")).equals("")) {
            sParam.put("COL_VAL", formData.get("BRAND_NM"));
            sParam.put("COL_NM", "BRAND_NM");
            formData.put("BRAND_NM", EverString.nullToEmptyString(queryGenService.generateSearchCondition(sParam)));
        }*/

        return citi0010_mapper.citr0045_doSearchGrid(formData);
    }

    /**
     * 화면명 : 품목속성상세
     * 처리내용 : 품목속성상세 정보를 조회힌다.
     * 경로 : 품목관리 > 품목관리 > 표준품목현황 > 표준품목상세(팝업) > 품목속성상세 (팝업)
     */
    public List<Map<String, Object>> citr0047_doSearch(Map<String, String> formData) {
        return citi0010_mapper.citr0047_doSearch(formData);
    }

    /**
     * 화면명 : 품목분류 현황
     * 처리내용 : 고객사별 품목분류를 조회/관리하는 화면.
     * 경로 : 품목관리 > 품목분류/SG > 품목분류 현황
     */
    public List<Map<String, Object>> citr0050_doSearch(Map<String, String> param) throws Exception {

        List<Map<String, Object>> rtn;

        if (EverString.isEmpty(param.get("ITEM_CLS"))) {
            rtn = citi0010_mapper.citr0050_doSearchItemClassSearchNm(param);
        } else {
            rtn = citi0010_mapper.citr0050_doSearchItemClass(param);
        }
        return rtn;
    }

    public List<Map<String, Object>> citr0050_doSearchChild(Map<String, String> param) throws Exception {
        return citi0010_mapper.citr0050_doSearchChild(param);
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String citr0050_doCopy(Map<String, String> formData) throws Exception {

        if (citi0010_mapper.citr0050_existsData(formData) > 0) {
            throw new NoResultException(msg.getMessageByScreenId("CITR0050", "0008"));
        }

        citi0010_mapper.citr0050_doCopyItemClass(formData);
        return msg.getMessageByScreenId("CITR0050", "0009");
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String citr0050_doSave(List<Map<String, Object>> gridData) throws Exception {

        for (Map<String, Object> gridDatum : gridData) {

            if ("I".equals(gridDatum.get("INSERT_FLAG"))) {
                gridDatum.put("DEL_FLAG", "0");
                if ("C1".equals(gridDatum.get("ITEM_CLS_TYPE"))) {
                    if (citi0010_mapper.citr0050_existsItemClass(gridDatum) > 0) {
                        throw new NoResultException(msg.getMessage("0034"));
                    }
                } else {
                    String ruleKey = PropertiesManager.getString("eversrm.item.type.management.rule");
                    if (ruleKey.equals("auto")) {
                        if ("C2".equals(gridDatum.get("ITEM_CLS_TYPE"))) {
                            gridDatum.put("ITEM_CLS2", citi0010_mapper.citr0050_newItemClassKey(gridDatum));
                        } else if ("C3".equals(gridDatum.get("ITEM_CLS_TYPE"))) {
                            gridDatum.put("ITEM_CLS3", citi0010_mapper.citr0050_newItemClassKey(gridDatum));
                        } else if ("C4".equals(gridDatum.get("ITEM_CLS_TYPE"))) {
                            gridDatum.put("ITEM_CLS4", citi0010_mapper.citr0050_newItemClassKey(gridDatum));
                        }
                    } else if (ruleKey.equals("manual")) {
                        if (citi0010_mapper.citr0050_existsItemClass(gridDatum) > 0) {
                            throw new NoResultException(msg.getMessage("0034"));
                        }
                    }
                }

                gridDatum.put("DEL_FLAG", "1");
                int chk = citi0010_mapper.citr0050_existsItemClass(gridDatum);

                gridDatum.put("TABLE_NM", "STOCMTCA");

                if (chk > 0) {
                    citi0010_mapper.citr0050_updateItemClass(gridDatum);
                } else {
                    if (!StringUtils.isNumeric(String.valueOf(gridDatum.get("SORT_SQ")))) {
                        gridDatum.put("SORT_SQ", citi0010_mapper.citr0050_newSortSeq(gridDatum));
                    }
                    citi0010_mapper.citr0050_insertItemClass(gridDatum);
                }

            } else {

                String itemClass = gridDatum.get("ITEM_CLS" + gridDatum.get("ITEM_CLS_TYPE").toString().substring(1)).toString();
                if (!itemClass.equals(gridDatum.get("ITEM_CLS_ORI").toString())) { // Key is changed
                    gridDatum.put("DEL_FLAG", "0");
                    if (citi0010_mapper.citr0050_existsItemClass(gridDatum) > 0) {
                        throw new NoResultException(msg.getMessage("0034"));
                    }

                    gridDatum.put("DEL_FLAG", "1");
                    int chk = citi0010_mapper.citr0050_existsItemClass(gridDatum);

                    gridDatum.put("TABLE_NM", "STOCMTCA");

                    if (chk > 0) {
                        citi0010_mapper.citr0050_updateItemClass(gridDatum);
                    } else {
                        if (!StringUtils.isNumeric(String.valueOf(gridDatum.get("SORT_SQ")))) {
                            gridDatum.put("SORT_SQ", citi0010_mapper.citr0050_newSortSeq(gridDatum));
                        }
                        citi0010_mapper.citr0050_insertItemClass(gridDatum);
                    }

                } else {
                    gridDatum.put("TABLE_NM", "STOCMTCA");
                    citi0010_mapper.citr0050_updateItemClass(gridDatum);
                }
            }
        }
        return msg.getMessage("0031");
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String citr0050_doDelete(List<Map<String, Object>> gridData) throws Exception {

        String rtnmsg = "";

        for (Map<String, Object> gridDatum : gridData) {
            if (!"I".equals(gridDatum.get("INSERT_FLAG"))) {

                gridDatum.put("TABLE_NM", "STOCMTCA");

                if (citi0010_mapper.citr0050_notDeleteItemClass(gridDatum) > 1) {
                    rtnmsg = "X";
                } else {
                    citi0010_mapper.citr0050_deleteItemClass_r(gridDatum);
                    rtnmsg = "Y";
                }
            }
        }
        return rtnmsg;
    }

    /**
     * 화면명 : 제조사/브랜드 관리
     * 처리내용 : 시스템에서 사용하는 제조사/브랜드를 조회/등록하는 화면.
     * 경로 : 품목관리 > 품목표준화 > 제조사/브랜드 관리
     */
    public List<Map<String, Object>> citr0060_doSearch(Map<String, String> formData) {
        return citi0010_mapper.citr0060_doSearch(formData);
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public void citr0060_doSave(List<Map<String, Object>> gridData) {
        for (Map<String, Object> gridDatum : gridData) {
            citi0010_mapper.citr0060_doSave(gridDatum);
        }
    }

}
