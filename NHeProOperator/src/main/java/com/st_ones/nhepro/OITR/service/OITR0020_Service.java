package com.st_ones.nhepro.OITR.service;

import com.st_ones.common.docNum.service.DocNumService;
import com.st_ones.common.generator.service.QueryGenService;
import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.common.util.service.LargeTextService;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.exception.NoResultException;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.eversrm.eApproval.service.EApprovalService;
import com.st_ones.nhepro.OITR.OITR0020_Mapper;
import org.apache.commons.lang.StringUtils;
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
 * @File Name : OITR0020_Service.java
 * @date 2020.03.05
 * @version 1.0
 * @see
 */
@Service(value = "OITR0020_Service")
public class OITR0020_Service {
    /**
     * The OITR0020_Mapper.
     */
    @Autowired OITR0020_Mapper oitr0020_Mapper;
    /**
     * The Msg.
     */
    @Autowired MessageService msg;
    /**
     * The Doc num service.
     */
    @Autowired DocNumService docNumService;

    @Autowired private QueryGenService queryGenService;

    @Autowired private LargeTextService largeTextService;

    /**
     * 화면명 : 품목현황
     * 처리내용 : 시스템에 등록되어있는 품목들을 조회/수정/견적의뢰 할 수 있는 화면.
     * 경로 : 품목관리 > 품목관리 > 표준품목현황
     */
    public List<Map<String,Object>> oitr0020_doSearch(Map<String, String> formData) throws Exception{
        Map<String, String> sParam = new HashMap<String, String>();

        if(!EverString.nullToEmptyString(formData.get("ITEM_DESC")).equals("")) {
            sParam.put("COL_VAL", formData.get("ITEM_DESC"));
            sParam.put("COL_NM", "A.ITEM_DESC");
            formData.put("ITEM_DESC", EverString.nullToEmptyString(queryGenService.generateSearchCondition(sParam)));
        }
        if(!EverString.nullToEmptyString(formData.get("ITEM_SPEC")).equals("")) {
            sParam.put("COL_VAL", formData.get("ITEM_SPEC"));
            sParam.put("COL_NM", "A.ITEM_SPEC");
            formData.put("ITEM_SPEC", EverString.nullToEmptyString(queryGenService.generateSearchCondition(sParam)));
        }
        /* 2021.04.14 : 제조사, 브랜드 제외
        if(!EverString.nullToEmptyString(formData.get("MAKER_NM")).equals("")) {
            sParam.put("COL_VAL", formData.get("MAKER_NM"));
            sParam.put("COL_NM", "A.MAKER_NM");
            formData.put("MAKER_NM", EverString.nullToEmptyString(queryGenService.generateSearchCondition(sParam)));
        }
        if(!EverString.nullToEmptyString(formData.get("BRAND_NM")).equals("")) {
            sParam.put("COL_VAL", formData.get("BRAND_NM"));
            sParam.put("COL_NM", "A.BRAND_NM");
            formData.put("BRAND_NM", EverString.nullToEmptyString(queryGenService.generateSearchCondition(sParam)));
        }*/
        return oitr0020_Mapper.oitr0020_doSearch(formData);
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public void oitr0020_doSave(List<Map<String, Object>> gridData) throws Exception {
        for (Map<String, Object> rowData : gridData) {
            oitr0020_Mapper.oitr0020_doSave(rowData);
        }
    }

    /**
     * 화면명 : 품목분류-속성매핑
     * 처리내용 : 시스템에 등록된 품목분류를 조회하는 화면.
     * 경로 : 품목관리 > 품목분류/SG > 품목분류-속성매핑
     */
    public List<Map<String, Object>> oitr0021_doSearch_ItemClassPopup_TREE(Map<String, String> param) {
        return oitr0020_Mapper.oitr0021_doSearch_ItemClassPopup_TREE(param);
    }

    /**
     * 화면명 : 품목등록(건별)
     * 처리내용 : 운영사가 사용할 품목을 등록하는 화면.
     * 경로 : 품목관리 > 품목표준화 > 품목등록(건별)
     */
    public Map<String, String> oita0024_doSearchInfo(Map<String, String> param) throws Exception {
        Map<String, String> formData = oitr0020_Mapper.oita0024_doSearchInfo(param);
        return formData;
    }

    // 품목 속성
    public List<Map<String, Object>> oita0024_doSearch_AT(Map<String, String> formData) {
        return oitr0020_Mapper.oita0024_doSearch_AT(formData);
    }

    // 품목등록
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public Map<String, String> oita0024_doSave(Map<String, String> formData, List<Map<String, Object>> gridDataAt) throws Exception {

        UserInfo userInfo = UserInfoManager.getUserInfo();
        Map<String, Object> ObjData = new HashMap<String, Object>();

        Map<String, String> rtnMap = new HashMap<String, String>();
        String itemCd = EverString.nullToEmptyString(formData.get("ITEM_CD"));

        formData.put("PROGRESS_CD","E"); //현재 무조건 승인으로 등록

        // 신규등록일경우 상품코드 번호채번, 품목 등록 | 수정 --------------------------------------------------
        if (itemCd.equals("")) {
            // 품목 insert
            // 채번로직 변경. Parameter [화면에서 전달 받은 COMPANY_CD (없는 경우, ses.manageCd 또는 ses.companyCd), DOC_TYPE ]
            itemCd = formData.get("ITEM_CLS1") + docNumService.getDocNumber(userInfo.getCompanyCd(), "IT");
            formData.put("ITEM_CD", itemCd);
            oitr0020_Mapper.oita0024_MTGL_Insert(formData);
        } else {
            // 품목 update
            oitr0020_Mapper.oita0024_MTGL_Update(formData);
        }

        // 이미지저장 -------------------------------------------------------------------------------------
        // 메인이미지 정보 초기화 후, 메인이미지가 있으면 저장
        oitr0020_Mapper.oita0024_doDeleteMTIM(formData);
        if (StringUtils.isNotEmpty(formData.get("MAIN_IMG_SQ"))) {
            oitr0020_Mapper.oita0024_doSaveMTIM(formData);
        }

        // 품목분류매핑저장
        ObjData.putAll(formData);
        oitr0020_Mapper.oitr0024_doSaveMTGC(ObjData);     // 분류맵핑

        // 품목속성저장 -----------------------------------------------------------------------------------
        oitr0020_Mapper.oita0024_doDeleteMTAT(formData);
        for (Map<String, Object> atList : gridDataAt) {
            atList.put("ITEM_CD", itemCd);
            atList.put("ITEM_CLS1", formData.get("ITEM_CLS1"));
            atList.put("ITEM_CLS2", formData.get("ITEM_CLS2"));
            atList.put("ITEM_CLS3", formData.get("ITEM_CLS3"));
            atList.put("ITEM_CLS4", formData.get("ITEM_CLS4"));
            oitr0020_Mapper.oita0024_doSaveMTAT(atList);
        }

        rtnMap.put("ITEM_CD", itemCd);
        rtnMap.put("STD_ITEM_CD", itemCd);
        rtnMap.put("rtnMsg", msg.getMessage("0031"));
        return rtnMap;
    }

    /**
     * 품목속성 조회
     * @param formData
     * @return
     * @throws Exception
     */
    public List<Map<String, Object>> oita0025_doSearch(Map<String, String> formData) {
        return oitr0020_Mapper.oita0025_doSearch(formData);
    }

    /**
     * 화면명 : 제조사/브랜드 관리
     * 처리내용 : 시스템에서 사용하는 제조사/브랜드를 조회/등록하는 화면.
     * 경로 : 품목관리 > 품목표준화 > 제조사/브랜드 관리
     */
    public List<Map<String, Object>> oitr0080_doSearch(Map<String, String> formData) {
        return oitr0020_Mapper.oitr0080_doSearch(formData);
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public void oitr0080_doSave(List<Map<String, Object>> gridData) {
        for (Map<String, Object> gridDatum : gridData) {
            oitr0020_Mapper.oitr0080_doSave(gridDatum);
        }
    }

    /**
     * 화면명 : 분류속성등록
     * 처리내용 : 품목 세분류의 속성을 등록하는 화면.
     * 경로 : Popup
     */
    public List<Map<String, Object>> oitr0070_doSearchMTCR(Map<String, String> param) throws Exception {
        return oitr0020_Mapper.oitr0070_doSearchMTCR(param);
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String oitr0070_doSave(Map<String, String> formData, List<Map<String, Object>> gridDatas) throws Exception {

        for (Map<String, Object> gridData : gridDatas) {
            gridData.put("ITEM_CLS1", formData.get("ITEM_CLS1"));
            gridData.put("ITEM_CLS2", formData.get("ITEM_CLS2"));
            gridData.put("ITEM_CLS3", formData.get("ITEM_CLS3"));
            gridData.put("ITEM_CLS4", formData.get("ITEM_CLS4"));

            if( "U".equals(gridData.get("INSERT_FLAG")) ) {
                oitr0020_Mapper.oitr0070_doDeleteMTCR(gridData);
                oitr0020_Mapper.oitr0070_doInsertMTCR(gridData);
            } else {
                oitr0020_Mapper.oitr0070_doInsertMTCR(gridData);
            }
        }
        return msg.getMessage("0001");
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String oitr0070_doDelete(Map<String, String> formData, List<Map<String, Object>> gridDatas) throws Exception {

        for (Map<String, Object> gridData : gridDatas) {
            gridData.put("ITEM_CLS1", formData.get("ITEM_CLS1"));
            gridData.put("ITEM_CLS2", formData.get("ITEM_CLS2"));
            gridData.put("ITEM_CLS3", formData.get("ITEM_CLS3"));
            gridData.put("ITEM_CLS4", formData.get("ITEM_CLS4"));

            oitr0020_Mapper.oitr0070_doDeleteMTCR(gridData);
        }
        return msg.getMessage("0001");
    }

    /**
     * 화면명 : 속성조회
     * 처리내용 : 품목 세분류의 속성을 조회하는 화면.
     * 경로 : Popup
     */
    public List<Map<String, Object>> oitr0071_doSearchCommonCode(Map<String, String> param) throws Exception {
        return oitr0020_Mapper.oitr0071_doSearchCommonCode(param);
    }

    /**
     * 화면명 : 속성기준현황
     * 처리내용 : 속성마스터를 관리하는 화면
     * 경로 : 품목관리 > 품목관리 > 속성기준현황
     */
    public List<Map<String, Object>> oitr0060_doSearch(Map<String, String> formData) {
        return oitr0020_Mapper.oitr0060_doSearch(formData);
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public void oitr0060_doSave(List<Map<String, Object>> gridData) throws Exception {

        UserInfo userInfo = UserInfoManager.getUserInfo();

        for (Map<String, Object> grid : gridData) {

            // 속성코드 존재 여부에 따라 Insert, Update
            if (grid.get("ATTR_CD") == null) {
                // 채번로직 변경. Parameter [화면에서 전달 받은 COMPANY_CD (없는 경우, ses.manageCd 또는 ses.companyCd), DOC_TYPE ]
                grid.put("ATTR_CD", docNumService.getDocNumber(userInfo.getCompanyCd(), "ATT"));
                oitr0020_Mapper.oitr0060_doInsert(grid);
            } else {
                oitr0020_Mapper.oitr0060_doUpdate(grid);
            }

        }
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public void oitr0060_doDelete(List<Map<String, Object>> gridData) throws Exception {
        for (Map<String, Object> grid : gridData) {
            oitr0020_Mapper.oitr0060_doDelete(grid);
        }
    }

    /**
     * 화면명 : 품목분류 현황
     * 처리내용 : 고객사별 품목분류를 조회/관리하는 화면.
     * 경로 : 품목관리 > 품목분류/SG > 품목분류 현황
     */
    public List<Map<String, Object>> oitr0040_doSearch(Map<String, String> param) throws Exception {

        List<Map<String, Object>> rtn;

        if (EverString.isEmpty(param.get("ITEM_CLS"))) {
            rtn = oitr0020_Mapper.oitr0040_doSearchItemClassSearchNm(param);
        } else {
            rtn = oitr0020_Mapper.oitr0040_doSearchItemClass(param);
        }
        return rtn;
    }

    public List<Map<String, Object>> oitr0040_doSearchChild(Map<String, String> param) throws Exception {
        return oitr0020_Mapper.oitr0040_doSearchChild(param);
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String oitr0040_doSave(List<Map<String, Object>> gridData) throws Exception {

        for (Map<String, Object> gridDatum : gridData) {

            if ("I".equals(gridDatum.get("INSERT_FLAG"))) {
                gridDatum.put("DEL_FLAG", "0");
                if ("C1".equals(gridDatum.get("ITEM_CLS_TYPE"))) {
                    if (oitr0020_Mapper.oitr0040_existsItemClass(gridDatum) > 0) {
                        throw new NoResultException(msg.getMessage("0034"));
                    }
                } else {
                    String ruleKey = PropertiesManager.getString("eversrm.item.type.management.rule");
                    if (ruleKey.equals("auto")) {
                        if ("C2".equals(gridDatum.get("ITEM_CLS_TYPE"))) {
                            gridDatum.put("ITEM_CLS2", oitr0020_Mapper.oitr0040_newItemClassKey(gridDatum));
                        } else if ("C3".equals(gridDatum.get("ITEM_CLS_TYPE"))) {
                            gridDatum.put("ITEM_CLS3", oitr0020_Mapper.oitr0040_newItemClassKey(gridDatum));
                        } else if ("C4".equals(gridDatum.get("ITEM_CLS_TYPE"))) {
                            gridDatum.put("ITEM_CLS4", oitr0020_Mapper.oitr0040_newItemClassKey(gridDatum));
                        }
                    } else if (ruleKey.equals("manual")) {
                        if (oitr0020_Mapper.oitr0040_existsItemClass(gridDatum) > 0) {
                            throw new NoResultException(msg.getMessage("0034"));
                        }
                    }
                }

                gridDatum.put("DEL_FLAG", "1");
                int chk = oitr0020_Mapper.oitr0040_existsItemClass(gridDatum);

                gridDatum.put("TABLE_NM", "STOCMTCA");

                if (chk > 0) {
                    oitr0020_Mapper.oitr0040_updateItemClass(gridDatum);
                } else {
                    if (!StringUtils.isNumeric(String.valueOf(gridDatum.get("SORT_SQ")))) {
                        gridDatum.put("SORT_SQ", oitr0020_Mapper.oitr0040_newSortSeq(gridDatum));
                    }
                    oitr0020_Mapper.oitr0040_insertItemClass(gridDatum);
                }

            } else {

                String itemClass = gridDatum.get("ITEM_CLS" + gridDatum.get("ITEM_CLS_TYPE").toString().substring(1)).toString();
                if (!itemClass.equals(gridDatum.get("ITEM_CLS_ORI").toString())) { // Key is changed
                    gridDatum.put("DEL_FLAG", "0");
                    if (oitr0020_Mapper.oitr0040_existsItemClass(gridDatum) > 0) {
                        throw new NoResultException(msg.getMessage("0034"));
                    }

                    gridDatum.put("DEL_FLAG", "1");
                    int chk = oitr0020_Mapper.oitr0040_existsItemClass(gridDatum);

                    gridDatum.put("TABLE_NM", "STOCMTCA");

                    if (chk > 0) {
                        oitr0020_Mapper.oitr0040_updateItemClass(gridDatum);
                    } else {
                        if (!StringUtils.isNumeric(String.valueOf(gridDatum.get("SORT_SQ")))) {
                            gridDatum.put("SORT_SQ", oitr0020_Mapper.oitr0040_newSortSeq(gridDatum));
                        }
                        oitr0020_Mapper.oitr0040_insertItemClass(gridDatum);
                    }

                } else {
                    gridDatum.put("TABLE_NM", "STOCMTCA");
                    oitr0020_Mapper.oitr0040_updateItemClass(gridDatum);
                }
            }
        }
        return msg.getMessage("0031");
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String oitr0040_doDelete(List<Map<String, Object>> gridData) throws Exception {

        String rtnmsg = "";

        for (Map<String, Object> gridDatum : gridData) {
            if (!"I".equals(gridDatum.get("INSERT_FLAG"))) {

                gridDatum.put("TABLE_NM", "STOCMTCA");

                if (oitr0020_Mapper.oitr0040_notDeleteItemClass(gridDatum) > 1) {
                    rtnmsg = "X";
                } else {
                    oitr0020_Mapper.oitr0040_deleteItemClass_r(gridDatum);
                    rtnmsg = "Y";
                }
            }
        }
        return rtnmsg;
    }

    /**
     * 화면명 : 품목속성상세
     * 처리내용 : 품목속성상세 정보를 조회힌다.
     * 경로 : 품목관리 > 품목관리 > 표준품목현황 > 표준품목상세(팝업) > 품목속성상세 (팝업)
     */
    public List<Map<String, Object>> oitr0023_doSearch(Map<String, String> formData) {
        return oitr0020_Mapper.oitr0023_doSearch(formData);
    }
}
