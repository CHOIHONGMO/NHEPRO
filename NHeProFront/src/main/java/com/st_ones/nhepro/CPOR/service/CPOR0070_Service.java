package com.st_ones.nhepro.CPOR.service;

import com.st_ones.common.docNum.service.DocNumService;
import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.util.clazz.EverConverter;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.common.util.service.LargeTextService;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.eversrm.eApproval.eApprovalModule.service.BAPM_Service;
import com.st_ones.nhepro.CPOR.CPOR0070_Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

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
 * @File Name : CPOR0070_Service.java
 * @date 2018. 01. 30.
 * @version 1.0
 */

@Service(value = "CPOR0070_Service")
public class CPOR0070_Service extends BaseService {

    @Autowired MessageService msg;
    @Autowired CPOR0070_Mapper cpor0070_mapper;
    @Autowired LargeTextService largeTextService;
    @Autowired private DocNumService docNumService;
    @Autowired private BAPM_Service approvalService;

    /**
     * 화면명 : 입고대기현황
     * 처리내용 : 거래명세서를 기준으로 입고대기현황을 조회하고 입고처리 하는 화면
     * 경로 : 고객사 > 발주관리 > 검수/입고 > 입고대기현황
     */
    public List<Map<String, Object>> cpor0070_doSearch(Map<String, String> param) {

        return cpor0070_mapper.cpor0070_doSearch(param);
    }

    // 검수담당자 변경
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public Map<String, String> cpor0070_doUpdateChange(Map<String, String> formData, List<Map<String, Object>> grid) throws Exception {
        Map<String, String> rtnMap = new HashMap<>();

        for(Map<String, Object> data : grid) {
            data.put("INSPECT_USER_ID", formData.get("PIC_USER_ID"));

            cpor0070_mapper.cpor0070_doUpdateChangePOHD(data);
        }

        rtnMap.put("rtnMsg", msg.getMessageByScreenId("CPOR0070", "004"));

        return rtnMap;
    }

    // 승인
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public Map<String, String> cpor0070_doUpdateConfirm(Map<String, String> formData, List<Map<String, Object>> grid) throws Exception {
        Map<String, String> rtnMap = new HashMap<>();

        for(Map<String, Object> data : grid) {
            data.put("PROGRESS_CD", "700");
            data.put("INV_DATE", formData.get("INV_DATE"));

            cpor0070_mapper.cpor0070_doUpdateIVHD(data);
        }

        rtnMap.put("rtnMsg", msg.getMessageByScreenId("CPOR0070", "011"));

        return rtnMap;
    }

    // 반려
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public Map<String, String> cpor0070_doUpdateReject(Map<String, String> formData, List<Map<String, Object>> grid) throws Exception {
        Map<String, String> rtnMap = new HashMap<>();

        for(Map<String, Object> data : grid) {
            data.put("PROGRESS_CD", "500");
            data.put("INV_DATE", "");

            cpor0070_mapper.cpor0070_doUpdateIVHD(data);
            cpor0070_mapper.cpor0070_doUpdateIVGH(data);
        }

        rtnMap.put("rtnMsg", msg.getMessageByScreenId("CPOR0070", "012"));

        return rtnMap;
    }

    /**
     * 화면명 : 거래명세서
     * 처리내용 : 거래명세서의 상세정보를 조회하고 지급정보를 입력하여 결재 상신하는 화면
     * 경로 : 고객사 > 발주관리 > 검수/입고 > 입고대기현황 > 거래명세서 (팝업)
     */
    public Map<String, Object> cpor0071_doSearchIVHD(Map<String, String> param) throws Exception {
        Map<String, Object> fParam = new HashMap<>();
        List<Map<String, Object>> list = new ArrayList<>();
        String GR_DATE = "";

        fParam.put("BUYER_CD", param.get("BUYER_CD"));

        if(!"".equals(param.get("APP_DOC_NUM")) && param.get("APP_DOC_NUM") != null) {
            fParam.put("BUYER_CD", param.get("buyerCd"));
            fParam.put("INV_NUM", param.get("INV_NUM"));
            fParam.put("APP_DOC_NUM", param.get("APP_DOC_NUM"));
        } else if("".equals(param.get("gridSel")) || param.get("gridSel") == null) {
            fParam.put("INV_NUM", param.get("INV_NUM"));
            fParam.put("APP_DOC_NUM", param.get("APP_DOC_NUM"));
        } else {
            list = EverConverter.readJsonObject(param.get("gridSel"), List.class);
            fParam.put("BUYER_CD", list.get(0).get("BUYER_CD"));
            fParam.put("INV_NUM", list.get(0).get("INV_NUM"));
        }

        fParam = cpor0070_mapper.cpor0071_doSearchIVHD(fParam);

        fParam.put("RMK_TEXT", largeTextService.selectLargeText(EverString.nullToEmptyString(fParam.get("RMK_TEXT_NUM"))));

        return fParam;
    }

    // 품목정보, 조회
    public List<Map<String, Object>> cpor0071_doSearchIVDT(Map<String, String> formData, Map<String, String> param) throws Exception {
        Map<String, Object> fParam = new HashMap<>();

        return cpor0070_mapper.cpor0071_doSearchIVDT(formData);
    }

    // 검수요청상세, 조회
    public List<Map<String, Object>> cpor0071_doSearchIVGH(Map<String, String> formData, Map<String, String> param) throws Exception {

        return cpor0070_mapper.cpor0071_doSearchIVGH(formData);
    }

    // 지불고객사, 조회
    public List<Map<String, Object>> cpor0071_doSearchPOPC(Map<String, String> formData, Map<String, String> param) throws Exception {

        return cpor0070_mapper.cpor0071_doSearchPOPC(formData);
    }

    // 차수별 합계
    public List<Map<String, Object>> cpor0071_getPayCntSumAmt(Map<String, String> formData, Map<String, String> param) throws Exception {

        return cpor0070_mapper.cpor0071_getPayCntSumAmt(formData);
    }

    // 결재상신
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public Map<String, String> cpor0071_doUpdateApproval(Map<String, String> formData, List<Map<String, Object>> gridPODT, List<Map<String, Object>> gridPOPC) throws Exception {
        Map<String, String> rtnMap = new HashMap<>();

        UserInfo userInfo = UserInfoManager.getUserInfo();

        if (EverString.isEmpty(formData.get("APP_DOC_NUM"))) {
            // 채번로직 변경. Parameter [화면에서 전달 받은 COMPANY_CD (없는 경우, ses.manageCd 또는 ses.companyCd), DOC_TYPE ]
            formData.put("APP_DOC_NUM", docNumService.getDocNumber(userInfo.getCompanyCd(), "APPDOC"));
        }

        String preSignStatus = formData.get("PRE_SIGN_STATUS");
        String appDocCnt = formData.get("APP_DOC_CNT");

        if (EverString.isEmpty(appDocCnt) || appDocCnt.equals("0")) {
            appDocCnt = "1";
        } else {
            // 이전의 SIGN_STATUS가 반려(R), 결재취소(C)이면 결재차수 = 결재차수 + 1
            if (preSignStatus.equals("R") || preSignStatus.equals("C") || "200".equals(formData.get("PROGRESS_CD"))) {
                appDocCnt = String.valueOf(Integer.parseInt(appDocCnt) + 1);
            }
        }
        formData.put("APP_DOC_CNT", appDocCnt);

        // 결재요청
        approvalService.doApprovalProcess(formData, formData.get("approvalFormData"), formData.get("approvalGridData"));

        formData.put("INV_DATE", formData.get("GR_DATE"));

        cpor0070_mapper.cpor0071_doUpdateApprovalIVHD(formData);
        cpor0070_mapper.cpor0071_doUpdateApprovalIVGH(formData);

        String GR_NUM = docNumService.getDocNumber(formData.get("BUYER_CD"), "GR");

        for(Map<String, Object> data : gridPODT) {
            data.put("GR_NUM", GR_NUM);
            data.put("BUYER_CD", formData.get("BUYER_CD"));
            data.put("INV_NUM", formData.get("INV_NUM"));
            data.put("GR_DATE", formData.get("GR_DATE"));

            cpor0070_mapper.cpor0071_doUpdateApprovalGRDT(data);
        }

        for(Map<String, Object> data : gridPOPC) {
            data.put("BUYER_CD", formData.get("BUYER_CD"));
            data.put("DEPT_CD", formData.get("DEPT_CD"));
            data.put("INV_NUM", formData.get("INV_NUM"));
            data.put("VENDOR_CD", formData.get("VENDOR_CD"));
            data.put("CUR", formData.get("CUR"));
            data.put("VAT_TYPE", formData.get("VAT_TYPE"));

            if(!"".equals(data.get("IVPC_GATE_CD")) && data.get("IVPC_GATE_CD") != null) {
                cpor0070_mapper.cpor0071_doUpdateIVPC(data);
            } else {
                cpor0070_mapper.cpor0071_doInsertIVPC(data);
            }
            // 2021.09.06 : 발주서의 정산담당자 변경 추가
            cpor0070_mapper.cpor0071_doUpdatePOPC(data);
        }

        rtnMap.put("rtnMsg", msg.getMessageByScreenId("CPOR0071", "013"));

        return rtnMap;
    }

    /**
     * 화면명 : 입고현황
     * 처리내용 : 확정된 입고현황 정보를 조회하는 화면
     * 경로 : 고객사 > 발주관리 > 검수/입고 > 입고현황
     */
    public List<Map<String, Object>> cpor0080_doSearch(Map<String, String> param) {

        return cpor0070_mapper.cpor0080_doSearch(param);
    }

}
