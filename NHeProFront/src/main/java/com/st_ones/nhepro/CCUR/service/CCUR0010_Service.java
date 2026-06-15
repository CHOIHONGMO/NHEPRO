package com.st_ones.nhepro.CCUR.service;

import com.st_ones.common.docNum.service.DocNumService;
import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.common.util.service.LargeTextService;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.nhepro.CCUR.CCUR0010_Mapper;
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
 * @File Name : CCUR0010_Service.java
 * @date 2020. 03. 18.
 * @version 1.0
 */
@Service(value = "ccur0010_Service")
public class CCUR0010_Service extends BaseService {

    @Autowired private DocNumService docNumService;

    @Autowired private MessageService msg;

    @Autowired private LargeTextService largeTextService;

    @Autowired private CCUR0010_Mapper ccur_Mapper;

    /**
     * 화면명 : 회사정보
     * 처리내용 : 로그인한 사용자의 회사정보를 조회/수정할 수 있는 화면
     * 경로 : 고객사 > 관리자 > 조직관리 > 회사정보
     */
    public Map<String, String> ccur0010_doSearchInfo(Map<String, String> param) throws Exception {
        return ccur_Mapper.ccur0010_doSearchInfo(param);
    }

    public List<Map<String, Object>> ccur0010_doSearchTs(Map<String, String> param) {

        String tmplNum = "";

        // 화면의 'BUYER_CD'로 등록된 첨부파일 템플릿 정보를 가져온다.
        param.put("PARAM_BUYER_CD", param.get("BUYER_CD"));
        param.put("PARAM_TMPL_NUM", ccur_Mapper.getTmplNum(param));
        List<Map<String, Object>> rtnList = ccur_Mapper.ccur0010_doSearchTs(param);

        // 조회된 데이터가 없으면 시스템 운영사가 등록한 첨부파일 템플릿 정보를 가져온다.
        if(rtnList.size() == 0) {
            param.put("PARAM_BUYER_CD", EverString.nullToEmptyString(param.get("MANAGE_CD")));
            param.put("PARAM_TMPL_NUM", ccur_Mapper.getTmplNum(param));
            rtnList = ccur_Mapper.ccur0010_doSearchTs(param);
        }
        return rtnList;
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public Map<String, String> ccur0010_doSave(Map<String, Object> formData, List<Map<String, Object>> gridDatas) throws Exception {

        UserInfo userInfo = UserInfoManager.getUserInfo();
        Map<String, String> rtnMap = new HashMap<String, String>();

        String custCd = EverString.nullToEmptyString(formData.get("CUST_CD"));

        formData.put("TOT_ASSET", (EverString.nullToEmptyString(String.valueOf(formData.get("TOT_ASSET"))).equals("") ? null : Double.parseDouble(String.valueOf(formData.get("TOT_ASSET")))));     // 총자산
        formData.put("TOT_FUND", (EverString.nullToEmptyString(String.valueOf(formData.get("TOT_FUND"))).equals("") ? null : Double.parseDouble(String.valueOf(formData.get("TOT_FUND")))));        // 총자본
        formData.put("TOT_SDEPT", (EverString.nullToEmptyString(String.valueOf(formData.get("TOT_SDEPT"))).equals("") ? null : Double.parseDouble(String.valueOf(formData.get("TOT_SDEPT")))));     // 총부채
        formData.put("RATE_SDEPT", (EverString.nullToEmptyString(String.valueOf(formData.get("RATE_SDEPT"))).equals("") ? null : Double.parseDouble(String.valueOf(formData.get("RATE_SDEPT")))));  // 부채비율
        formData.put("CURR_ASSET", (EverString.nullToEmptyString(String.valueOf(formData.get("CURR_ASSET"))).equals("") ? null : Double.parseDouble(String.valueOf(formData.get("CURR_ASSET")))));  // 유동자산
        formData.put("CURR_SDEPT", (EverString.nullToEmptyString(String.valueOf(formData.get("CURR_SDEPT"))).equals("") ? null : Double.parseDouble(String.valueOf(formData.get("CURR_SDEPT")))));  // 유동부채
        formData.put("RATE_CURR", (EverString.nullToEmptyString(String.valueOf(formData.get("RATE_CURR"))).equals("") ? null : Double.parseDouble(String.valueOf(formData.get("RATE_CURR")))));     // 유동비율
        formData.put("TOT_SALES", (EverString.nullToEmptyString(String.valueOf(formData.get("TOT_SALES"))).equals("") ? null : Double.parseDouble(String.valueOf(formData.get("TOT_SALES")))));     // 총매출액
        formData.put("NET_INCOM", (EverString.nullToEmptyString(String.valueOf(formData.get("NET_INCOM"))).equals("") ? null : Double.parseDouble(String.valueOf(formData.get("NET_INCOM")))));     // 당기순이익

        // 1. 회사정보 등록/수정
        ccur_Mapper.ccur0010_doUpdateCust(formData);

        // 2. 대표자명, 우편번호, 주소, 상세주소 변경시 History 등록
        if(EverString.nullToEmptyString(formData.get("changeFlag")).equals("Y")) {
            ccur_Mapper.ccur0010_doInsertCVSH(formData);
        }

        // 3. 첨부파일 등록
        for(Map<String, Object> gridData : gridDatas) {
            Map<String, Object> tmpData = new HashMap<String, Object>();
            tmpData.putAll(gridData);
            tmpData.put("CUST_CD", custCd);
            tmpData.put("DOC_NUM", ((EverString.nullToEmptyString(String.valueOf(gridData.get("DOC_NUM"))).equals("") || gridData.get("DOC_NUM") == null) ? "1" : gridData.get("DOC_NUM")));
            tmpData.put("DOC_CNT", ((EverString.nullToEmptyString(String.valueOf(gridData.get("DOC_CNT"))).equals("") || gridData.get("DOC_CNT") == null) ? "1" : gridData.get("DOC_CNT")));
            tmpData.put("VENDOR_CD", ((EverString.nullToEmptyString(String.valueOf(gridData.get("VENDOR_CD"))).equals("") || gridData.get("VENDOR_CD") == null) ? "1" : gridData.get("VENDOR_CD")));
            ccur_Mapper.ccur0010_doInsertATTS(tmpData);
        }

        Map<String, Object> tbData = ccur_Mapper.ccur0010_getTbData(formData);
        if(tbData != null) {
            ccur_Mapper.ccur0010_mergeCORP(tbData);
        }

        rtnMap.put("CUST_CD", custCd);
        rtnMap.put("rtnMsg", msg.getMessage("0016"));
        return rtnMap;
    }

    /**
     * 화면명 : 조직정보
     * 처리내용 : 로그인한 사용자 회사의 조직을 조회/관리하는 화면.
     * 경로 : 고객사 > 관리자 > 조직관리 > 조직정보
     */
    public String ccur0020_getRelatYN(Map<String, String> param) {
        return ccur_Mapper.ccur0020_getRelatYN(param);
    }

    public List<Map<String, Object>> ccur0020_doSearch(Map<String, String> param) {
        return ccur_Mapper.ccur0020_doSearch(param);
    }

    public List<Map<String, Object>> ccur0020_doSearch_parent(Map<String, String> param) {
        return ccur_Mapper.ccur0020_doSearch_parent(param);
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String ccur0020_doSave(Map<String, String> formData, List<Map<String, Object>> gridList) throws Exception {

        int checkCnt;
        for(Map<String, Object> gridData : gridList) {
            // 부서코드 중복체크
            gridData.put("CUST_CD", formData.get("CUST_CD"));
            checkCnt = ccur_Mapper.existsOPDP(gridData);
            if (checkCnt > 0) {
                throw new Exception("이미 등록된 부서코드가 존재합니다.");
            }
        }

        for(Map<String, Object> gridData : gridList) {
            gridData.put("CUST_CD", formData.get("CUST_CD"));
            gridData.put("DEPT_TYPE", formData.get("DEPT_TYPE_RADIO"));
            gridData.put("LVL", formData.get("LVL"));
            gridData.put("DIVISION_YN", formData.get("DIVISION_YN"));
            ccur_Mapper.ccur0020_mergeData(gridData);

            Map<String, Object> tbData = ccur_Mapper.ccur0020_getTbData(gridData);
            if(tbData != null) {
                ccur_Mapper.ccur0020_mergeBRC(tbData);
                ccur_Mapper.ccur0020_mergeDEPT(tbData);
            }
        }
        return msg.getMessage("0031");
    }

    public List<Map<String, Object>> ccur0020_doSearchAccount(Map<String, String> param) {
        return ccur_Mapper.ccur0020_doSearchAccount(param);
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String ccur0020_doSaveAcc(Map<String, String> formData, List<Map<String, Object>> gridList) throws Exception {

        for(Map<String, Object> gridData : gridList) {
            gridData.put("CUST_CD", formData.get("CUST_CD"));
            gridData.put("DEPT_CD", (EverString.nullToEmptyString(formData.get("activeDeptCd")).equals("") ? gridData.get("DEPT_CD") : formData.get("activeDeptCd")));
            gridData.put("DEL_FLAG", formData.get("DEL_FLAG"));
            ccur_Mapper.ccur0020_mergeAccData(gridData);
        }
        return msg.getMessage((formData.get("DEL_FLAG").equals("1") ? "0017" : "0031"));
    }

}