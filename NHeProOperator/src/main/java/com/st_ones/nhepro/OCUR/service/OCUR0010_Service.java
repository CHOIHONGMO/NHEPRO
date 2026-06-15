package com.st_ones.nhepro.OCUR.service;

import com.st_ones.batch.nhebatch.service.BNH0012_Service;
import com.st_ones.common.docNum.service.DocNumService;
import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.util.clazz.EverEncryption;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.common.util.service.LargeTextService;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.nhepro.OCUR.OCUR0010_Mapper;
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
 * @File Name : OCUR0010_Service.java
 * @date 2020. 03. 09.
 * @version 1.0
 */
@Service(value = "ocur0010_Service")
public class OCUR0010_Service extends BaseService {

    @Autowired private DocNumService docNumService;

    @Autowired private MessageService msg;

    @Autowired private LargeTextService largeTextService;

    @Autowired private OCUR0010_Mapper ocur_Mapper;

    @Autowired private BNH0012_Service bnh0012_Service;

    /**
     * 화면명 : 고객사현황
     * 처리내용 : 시스템에 등록된 고객사들을 조회하고, 신규 고객사를 등록하는 화면.
     * 경로 : 시스템운영사 > 회원사관리 > 고객사 관리 > 고객사현황
     */
    public List<Map<String, Object>> ocur0010_doSearch(Map<String, String> param) throws Exception {
        return ocur_Mapper.ocur0010_doSearch(param);
    }

    /**
     * 화면명 : 고객사 상세
     * 처리내용 : 시스템에 등록된 고객사 정보를 조회/수정할 수 있는 화면
     * 경로 : 시스템운영사 > 회원사관리 > 고객사 관리 > 고객사현황 > 고객사 등록/상세 (팝업)
     */
    public Map<String, String> ocur0011_doSearchInfo(Map<String, String> param) throws Exception {
        return ocur_Mapper.ocur0011_doSearchInfo(param);
    }

    public List<Map<String, Object>> ocur0011_doSearchTs(Map<String, String> param) {

        String tmplNum = "";

        // 화면의 'BUYER_CD'로 등록된 첨부파일 템플릿 정보를 가져온다.
        param.put("PARAM_BUYER_CD", param.get("BUYER_CD"));
        param.put("PARAM_TMPL_NUM", ocur_Mapper.getTmplNum(param));
        List<Map<String, Object>> rtnList = ocur_Mapper.ocur0011_doSearchTs(param);

        // 조회된 데이터가 없으면 시스템 운영사가 등록한 첨부파일 템플릿 정보를 가져온다.
        if(rtnList.size() == 0) {
            param.put("PARAM_BUYER_CD", EverString.nullToEmptyString(param.get("MANAGE_CD")));
            param.put("PARAM_TMPL_NUM", ocur_Mapper.getTmplNum(param));
            rtnList = ocur_Mapper.ocur0011_doSearchTs(param);
        }
        return rtnList;
    }

    public Map<String, String> ocur0011_doSearchTB(Map<String, String> param) {
        return ocur_Mapper.ocur0011_doSearchTB(param);
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public Map<String, String> ocur0011_doSave(Map<String, Object> formData, List<Map<String, Object>> gridDatas) throws Exception {

        UserInfo userInfo = UserInfoManager.getUserInfo();
        Map<String, String> rtnMap = new HashMap<String, String>();

        String custCd = EverString.nullToEmptyString(formData.get("CUST_CD"));

        // 1. 신규등록일 경우, 법인등록번호 + 사업자번호 중복체크
        if( "".equals(custCd) ) {
            String cehckNum = EverString.nullToEmptyString(formData.get("COMPANY_REG_NUM")) + EverString.nullToEmptyString(formData.get("IRS_NUM"));
            cehckNum = cehckNum.replaceAll("-","");
            cehckNum = cehckNum.replaceAll("\\p{Z}","");
            formData.put("CEHCK_NUM", cehckNum);

            int check = ocur_Mapper.ocur0011_doCheckNum(formData);
            if( check > 0 ) {
                rtnMap.put("rtnMsg", msg.getMessage("0147"));
                return rtnMap;
            }
        }

        // 2. 신규 등록 : 고객사번호 채번
        boolean isNew = false; // 신규여부
        if( "".equals(EverString.nullToEmptyString(custCd)) ) {
            // 채번로직 변경. Parameter [화면에서 전달 받은 COMPANY_CD (없는 경우, ses.manageCd 또는 ses.companyCd), DOC_TYPE ]
            custCd = docNumService.getDocNumber(userInfo.getCompanyCd(), "CUST");
            isNew  = true;
        }
        formData.put("CUST_CD", custCd);
        formData.put("PROGRESS_CD", "E"); // 승인(M050)

        formData.put("TOT_ASSET", (EverString.nullToEmptyString(String.valueOf(formData.get("TOT_ASSET"))).equals("") ? null : Double.parseDouble(String.valueOf(formData.get("TOT_ASSET")))));     // 총자산
        formData.put("TOT_FUND", (EverString.nullToEmptyString(String.valueOf(formData.get("TOT_FUND"))).equals("") ? null : Double.parseDouble(String.valueOf(formData.get("TOT_FUND")))));        // 총자본
        formData.put("TOT_SDEPT", (EverString.nullToEmptyString(String.valueOf(formData.get("TOT_SDEPT"))).equals("") ? null : Double.parseDouble(String.valueOf(formData.get("TOT_SDEPT")))));     // 총부채
        formData.put("RATE_SDEPT", (EverString.nullToEmptyString(String.valueOf(formData.get("RATE_SDEPT"))).equals("") ? null : Double.parseDouble(String.valueOf(formData.get("RATE_SDEPT")))));  // 부채비율
        formData.put("CURR_ASSET", (EverString.nullToEmptyString(String.valueOf(formData.get("CURR_ASSET"))).equals("") ? null : Double.parseDouble(String.valueOf(formData.get("CURR_ASSET")))));  // 유동자산
        formData.put("CURR_SDEPT", (EverString.nullToEmptyString(String.valueOf(formData.get("CURR_SDEPT"))).equals("") ? null : Double.parseDouble(String.valueOf(formData.get("CURR_SDEPT")))));  // 유동부채
        formData.put("RATE_CURR", (EverString.nullToEmptyString(String.valueOf(formData.get("RATE_CURR"))).equals("") ? null : Double.parseDouble(String.valueOf(formData.get("RATE_CURR")))));     // 유동비율
        formData.put("TOT_SALES", (EverString.nullToEmptyString(String.valueOf(formData.get("TOT_SALES"))).equals("") ? null : Double.parseDouble(String.valueOf(formData.get("TOT_SALES")))));     // 총매출액
        formData.put("NET_INCOM", (EverString.nullToEmptyString(String.valueOf(formData.get("NET_INCOM"))).equals("") ? null : Double.parseDouble(String.valueOf(formData.get("NET_INCOM")))));     // 당기순이익

        // 3. 고객사 등록/수정
        ocur_Mapper.ocur0011_doMergeCust(formData);

        // 4. 대표자명, 우편번호, 주소, 상세주소 변경시 History 등록
        if( isNew || EverString.nullToEmptyString(formData.get("changeFlag")).equals("Y") ) {
            ocur_Mapper.ocur0011_doInsertCVSH(formData);
        }

        // 5. 첨부파일 등록
        for(Map<String, Object> gridData : gridDatas) {
            Map<String, Object> tmpData = new HashMap<String, Object>();
            tmpData.putAll(gridData);
            tmpData.put("CUST_CD", custCd);
            tmpData.put("DOC_NUM", ((EverString.nullToEmptyString(String.valueOf(gridData.get("DOC_NUM"))).equals("") || gridData.get("DOC_NUM") == null) ? "1" : gridData.get("DOC_NUM")));
            tmpData.put("DOC_CNT", ((EverString.nullToEmptyString(String.valueOf(gridData.get("DOC_CNT"))).equals("") || gridData.get("DOC_CNT") == null) ? "1" : gridData.get("DOC_CNT")));
            tmpData.put("VENDOR_CD", ((EverString.nullToEmptyString(String.valueOf(gridData.get("VENDOR_CD"))).equals("") || gridData.get("VENDOR_CD") == null) ? "1" : gridData.get("VENDOR_CD")));
            ocur_Mapper.ocur0011_doInsertATTS(tmpData);
        }

        // 6. 비농협 고객사의 수동 생성 및 수정 후 TB_CO_CORP에 INSERT OR UPDATE
        if(EverString.nullToEmptyString(formData.get("RELAT_YN")).equals("1")) {

            if(EverString.nullToEmptyString(formData.get("CORP_TYPE")).equals("1")) { formData.put("NC_COMP_DS_C", "02"); }
            else if(EverString.nullToEmptyString(formData.get("CORP_TYPE")).equals("2")) { formData.put("NC_COMP_DS_C", "03"); }
            else if(EverString.nullToEmptyString(formData.get("CORP_TYPE")).equals("3")) { formData.put("NC_COMP_DS_C", "04"); }
            else if(EverString.nullToEmptyString(formData.get("CORP_TYPE")).equals("5")) { formData.put("NC_COMP_DS_C", "06"); }
            else if(EverString.nullToEmptyString(formData.get("CORP_TYPE")).equals("A")) { formData.put("NC_COMP_DS_C", "08"); }
            else if(EverString.nullToEmptyString(formData.get("CORP_TYPE")).equals("B")) { formData.put("NC_COMP_DS_C", "09"); }
            else if(EverString.nullToEmptyString(formData.get("CORP_TYPE")).equals("C")) { formData.put("NC_COMP_DS_C", "10"); }
            else if(EverString.nullToEmptyString(formData.get("CORP_TYPE")).equals("D")) { formData.put("NC_COMP_DS_C", "11"); }
            else { formData.put("NC_COMP_DS_C", ""); }

            ocur_Mapper.ocur0011_doMergeCorp(formData);
        }



        if(isNew) {
            // 7. 농협 고객사의 경우, 고객사 하위정보 일괄 가져오기
            if(EverString.nullToEmptyString(formData.get("RELAT_YN")).equals("0")) {
                Map<String, String> execMap = new HashMap<String, String>();
                execMap.put("CUST_CD", custCd);
                bnh0012_Service.doExecService(execMap);
            }


            Map<String, String> param = new HashMap<>();
            param.put("COMPANY_CD", custCd);
            ocur_Mapper.ocur0011_doInsertDNCT(param);
        }

        rtnMap.put("CUST_CD", custCd);
        rtnMap.put("rtnMsg", (isNew ? msg.getMessage("0015") : msg.getMessage("0016")));
        return rtnMap;
    }

    public String ocur0011_checkIrsNum(Map<String, String> param) throws Exception {
        return ocur_Mapper.ocur0011_checkIrsNum(param);
    }

    /**
     * 화면명 : 고객사별 부서현황
     * 처리내용 : 고객사별로 부서를 조회/관리하는 화면.
     * 경로 : 시스템운영사 > 회원사관리 > 고객사 관리 > 고객사별 부서현황
     */
    public List<Map<String, Object>> ocur0020_doSearch(Map<String, String> param) {
        return ocur_Mapper.ocur0020_doSearch(param);
    }

    public List<Map<String, Object>> ocur0020_doSearch_parent(Map<String, String> param) {
        return ocur_Mapper.ocur0020_doSearch_parent(param);
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String ocur0020_doSave(Map<String, String> formData, List<Map<String, Object>> gridList) throws Exception {

        int checkCnt;
        for(Map<String, Object> gridData : gridList) {
            // 부서코드 중복체크
            gridData.put("CUST_CD", formData.get("CUST_CD"));
            checkCnt = ocur_Mapper.existsOPDP(gridData);
            if (checkCnt > 0) {
                throw new Exception("이미 등록된 부서코드가 존재합니다.");
            }
        }

        for(Map<String, Object> gridData : gridList) {

            gridData.put("CUST_CD", formData.get("CUST_CD"));
            gridData.put("DEPT_TYPE", formData.get("DEPT_TYPE_RADIO"));
            gridData.put("LVL", formData.get("LVL"));
            gridData.put("DIVISION_YN", formData.get("DIVISION_YN"));
            ocur_Mapper.ocur0020_mergeData(gridData);

            Map<String, Object> tbData = ocur_Mapper.ocur0020_getTbData(gridData);
            if(tbData != null) {
                ocur_Mapper.ocur0020_mergeBRC(tbData);
                ocur_Mapper.ocur0020_mergeDEPT(tbData);
            }
        }
        return msg.getMessage("0031");
    }

    public List<Map<String, Object>> ocur0020_doSearchAccount(Map<String, String> param) {
        return ocur_Mapper.ocur0020_doSearchAccount(param);
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String ocur0020_doSaveAcc(Map<String, String> formData, List<Map<String, Object>> gridList) throws Exception {

        for(Map<String, Object> gridData : gridList) {
            gridData.put("CUST_CD", formData.get("CUST_CD"));
            gridData.put("DEPT_CD", (EverString.nullToEmptyString(formData.get("activeDeptCd")).equals("") ? gridData.get("DEPT_CD") : formData.get("activeDeptCd")));
            gridData.put("DEL_FLAG", formData.get("DEL_FLAG"));
            ocur_Mapper.ocur0020_mergeAccData(gridData);
        }
        return msg.getMessage((formData.get("DEL_FLAG").equals("1") ? "0017" : "0031"));
    }

    public String ocur0020_getRelatYN(Map<String, String> param) {
        return ocur_Mapper.ocur0020_getRelatYN(param);
    }

}