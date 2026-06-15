package com.st_ones.nhepro.CPOI.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.st_ones.common.docNum.service.DocNumService;
import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.util.clazz.EverConverter;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.common.util.service.LargeTextService;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.eversrm.eApproval.eApprovalModule.service.BAPM_Service;
import com.st_ones.nhepro.CPOI.CPOI0010_Mapper;
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
 * @File Name : CPOI0010_Service.java
 * @date 2018. 01. 30.
 * @version 1.0
 */

@Service(value = "CPOI0010_Service")
public class CPOI0010_Service extends BaseService {

    @Autowired MessageService msg;
    @Autowired CPOI0010_Mapper cpoi0010_mapper;
    @Autowired LargeTextService largeTextService;
    @Autowired private DocNumService docNumService;
    @Autowired private BAPM_Service approvalService;

    /**
     * 화면명 : 발주서생성
     * 처리내용 : 발주서를 작성하여 결재상신하는 화면
     * 경로 : 고객사 > 발주관리 > 발주관리 > 발주서생성
     */
    public Map<String, Object> cpoi0010_doSearch(Map<String, String> param) throws Exception {
        Map<String, Object> fParam = new HashMap<>();

        List<Map<String, Object>> list = EverConverter.readJsonObject(param.get("gridSel"), List.class);

        fParam.put("LIST", list);

        return cpoi0010_mapper.cpoi0010_doSearch(fParam);
    }

    // 발주 상세 조회, POHD
    public Map<String, Object> cpoi0010_doSearchPOHD(Map<String, String> param) throws Exception {
        Map<String, Object> fParam;

        fParam = cpoi0010_mapper.cpoi0010_doSearchPOHD(param);

        fParam.put("RMK_TEXT", largeTextService.selectLargeText(EverString.nullToEmptyString(fParam.get("RMK_TEXT_NUM"))));

        return fParam;
    }

    // 품목정보, 조회, POHB
    public List<Map<String, Object>> cpoi0010_doSearchMTGL(Map<String, String> formData, Map<String, String> param) throws Exception {
        Map<String, Object> fParam = new HashMap<>();

        List<Map<String, Object>> list = EverConverter.readJsonObject(param.get("gridSel"), List.class);

        fParam.put("PB_BUYER_CD", list.get(0).get("PB_BUYER_CD"));
        fParam.put("LIST", list);

        return cpoi0010_mapper.cpoi0010_doSearchMTGL(fParam);
    }

    // 품목정보, 조회, PODT
    public List<Map<String, Object>> cpoi0010_doSearchPODT(Map<String, String> formData, Map<String, String> param) throws Exception {

        return cpoi0010_mapper.cpoi0010_doSearchPODT(formData);
    }

    // 지불정보, 조회
    public List<Map<String, Object>> cpoi0010_doSearchPOPY(Map<String, String> formData, Map<String, String> param) throws Exception {
        List<Map<String, Object>> POPY = cpoi0010_mapper.cpoi0010_doSearchPOPY(formData);

        for(Map<String, Object> data : POPY) {
            data.put("BUYER_CD", formData.get("BUYER_CD"));

            List<Map<String, Object>> POPC = cpoi0010_mapper.cpoi0010_doSearchPOPC(data);

            data.put("PC_INFO",  EverConverter.getJsonString(POPC));
        }

        return POPY;
    }

    // 저장
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public Map<String, String> cpoi0010_doSave(Map<String, String> formData, List<Map<String, Object>> gridMTGL, List<Map<String, Object>> gridPOPY, List<Map<String, Object>> gridTEMP, String signStatus) throws Exception {
        Map<String, String> rtnMap = new HashMap<>();

        UserInfo userInfo = UserInfoManager.getUserInfo();

        String PO_NUM;

        String BUYER_CD = userInfo.getCompanyCd();
        String DEPT_CD = userInfo.getDeptCd();

        String PO_CREATE_TYPE = formData.get("PO_CREATE_TYPE");
        Boolean isNewPo = false;

        if(!"".equals(formData.get("PO_NUM")) && formData.get("PO_NUM") != null) {
            PO_NUM = formData.get("PO_NUM");
        } else {
        	isNewPo = true;
            PO_NUM = docNumService.getDocNumber(userInfo.getCompanyCd(), "PO");
            formData.put("PO_NUM", PO_NUM);
        }

        String preSignStatus = formData.get("PRE_SIGN_STATUS");
        String appDocCnt = formData.get("APP_DOC_CNT");
        if (signStatus.equals("P")) {
            if (EverString.isEmpty(formData.get("APP_DOC_NUM"))) {
                // 채번로직 변경. Parameter [화면에서 전달 받은 COMPANY_CD (없는 경우, ses.manageCd 또는 ses.companyCd), DOC_TYPE ]
                formData.put("APP_DOC_NUM", docNumService.getDocNumber(userInfo.getCompanyCd(), "APPDOC"));
            }

            if (EverString.isEmpty(appDocCnt) || appDocCnt.equals("0")) {
                appDocCnt = "1";
            }
            else {
                appDocCnt = String.valueOf(Integer.parseInt(appDocCnt) + 1);
            }
            formData.put("APP_DOC_CNT", appDocCnt);
            formData.put("DOC_TYPE", "PO");

            // 결재요청
            approvalService.doApprovalProcess(formData, formData.get("approvalFormData"), formData.get("approvalGridData"));
        }

        formData.put("PROGRESS_CD", "100"); // 작성중
        formData.put("RMK_TEXT_NUM", largeTextService.saveLargeText(formData.get("RMK_TEXT_NUM"), formData.get("RMK_TEXT")));

        formData.put("BUYER_CD", BUYER_CD);
        formData.put("DEPT_CD", DEPT_CD);

        if (isNewPo) {
            cpoi0010_mapper.cpoi0010_doInsertPOHD(formData);
        } else {
            cpoi0010_mapper.cpoi0010_doUpdatePOHD(formData);
        }

        for(Map<String, Object> data : gridMTGL) {
            data.put("BUYER_CD", formData.get("BUYER_CD"));

//            if("MANUAL".equals(PO_CREATE_TYPE)) {
//                data.put("PR_BUYER_CD", "");
//                data.put("PR_DEPT_CD", "");
//                data.put("PB_BUYER_CD", "");
//            } else {
//                data.put("PR_BUYER_CD", data.get("BUYER_CD"));
//                data.put("PR_DEPT_CD", data.get("DEPT_CD"));
//                data.put("PB_BUYER_CD ", data.get("PB_BUYER_CD"));
//            }

            if(!"".equals(data.get("PO_NUM")) && data.get("PO_NUM") != null) {
                cpoi0010_mapper.cpoi0010_doUpdatePODT(data);
            } else {
                data.put("PO_NUM", PO_NUM);

                cpoi0010_mapper.cpoi0010_doInsertPODT(data);

                if("LAST".equals(PO_CREATE_TYPE)) {
                    data.put("DEL_FLAG", "1");
                    cpoi0010_mapper.cpoi0010_doUpdatePOHB(data);
                }
            }
        }

        for(Map<String, Object> data : gridTEMP) {
            data.put("BUYER_CD", formData.get("BUYER_CD"));

            cpoi0010_mapper.cpoi0010_doDeleteItemPODT(data);
        }

        List<Map<String, Object>> gridPOPC = new ArrayList<>();

        cpoi0010_mapper.cpoi0010_doDeletePOPY(formData);

        for(Map<String, Object> data : gridPOPY) {
            data.put("BUYER_CD", formData.get("BUYER_CD"));
            data.put("DEPT_CD", formData.get("DEPT_CD"));
            data.put("VENDOR_CD", formData.get("VENDOR_CD"));
            data.put("PO_NUM", PO_NUM);

            cpoi0010_mapper.cpoi0010_doInsertPOPY(data);

            List<Map<String, Object>> grid = new ObjectMapper().readValue(EverString.nullToEmptyString(data.get("PC_INFO")), List.class);

            gridPOPC.addAll(grid);
        }

        cpoi0010_mapper.cpoi0010_doDeletePOPC(formData);

        for(Map<String, Object> data : gridPOPC) {
            data.put("BUYER_CD", formData.get("BUYER_CD"));
            data.put("DEPT_CD", formData.get("DEPT_CD"));
            data.put("VENDOR_CD", formData.get("VENDOR_CD"));
            data.put("PO_NUM", PO_NUM);

            cpoi0010_mapper.cpoi0010_doInsertPOPC(data);
        }

        rtnMap.put("PO_NUM", PO_NUM);

        if (signStatus.equals("P")) {
        	rtnMap.put("rtnMsg", msg.getMessage("0023"));
        } else {
        	rtnMap.put("rtnMsg", msg.getMessage("0031"));
        }

        return rtnMap;
    }

    // 삭제
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public Map<String, String> cpoi0010_doDelete(Map<String, String> formData) throws Exception {
        Map<String, String> rtnMap = new HashMap<>();
        Map<String, Object> param = new HashMap<>();

        param.put("PB_BUYER_CD", formData.get("PB_BUYER_CD"));
        param.put("PR_NUM", formData.get("PR_NUM"));
        param.put("PR_SQ", formData.get("PR_SQ"));

        if("LAST".equals(formData.get("PO_CREATE_TYPE"))) {     // 종가발주
            param.put("DEL_FLAG", "0");
            cpoi0010_mapper.cpoi0010_doUpdatePOHB(param);
        }

        formData.put("DEL_FLAG", "1");

        cpoi0010_mapper.cpoi0010_doDeletePOHD(formData);
        cpoi0010_mapper.cpoi0010_doDeletePODT(formData);
        cpoi0010_mapper.cpoi0010_doDeletePOPY(formData);
        cpoi0010_mapper.cpoi0010_doDeletePOPC(formData);

        rtnMap.put("rtnMsg", msg.getMessage("0017"));

        return rtnMap;
    }

    /**
     * 화면명 : 발주대기목록
     * 처리내용 : 구매검토목록에서 종가발주 생성요청건들을 대상으로 조회한 후 선택하여 발주서를 생성할 수 있는 화면.
     * 경로 : 고객사 > 발주관리 > 발주관리 > 발주대기목록
     */
    public List<Map<String, Object>> cpoi0011_doSearch(Map<String, String> param) {

        return cpoi0010_mapper.cpoi0011_doSearch(param);
    }

    // // 종가발주취소
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public Map<String, String> cpoi0011_doClosing(Map<String, String> formData, List<Map<String, Object>> grid) throws Exception {
        Map<String, String> rtnMap = new HashMap<>();

        for(Map<String, Object> data : grid) {
            cpoi0010_mapper.cpoi0011_doDeletePOHB(data);
            cpoi0010_mapper.cpoi0011_doUpdatePRDT(data);
        }

        rtnMap.put("rtnMsg", msg.getMessage("0031"));

        return rtnMap;
    }

    /**
     * 화면명 : 발주현황
     * 처리내용 : 발주 현황을 조회하여 관리를 하는 화면. (작성중인 발주서의 수정이나 발주서 종결을 할 수 있는 화면을 팝업으로 오픈한다.)
     * 경로 : 고객사 > 발주관리 > 발주관리 > 발주현황
     */
    public List<Map<String, Object>> cpor0020_doSearch(Map<String, String> param) {

        return cpoi0010_mapper.cpor0020_doSearch(param);
    }

    // 발주종결
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public Map<String, String> cpor0020_doClosing(Map<String, String> formData, List<Map<String, Object>> grid) throws Exception {
        Map<String, String> rtnMap = new HashMap<>();

        for(Map<String, Object> data : grid) {
            data.put("FORCE_CLOSE_RMK", formData.get("CONFIRM_REASON"));

            cpoi0010_mapper.cpor0020_doClosingPOHD(data);
            cpoi0010_mapper.cpor0020_doClosingPODT(data);
        }

        rtnMap.put("rtnMsg", msg.getMessage("0031"));

        return rtnMap;
    }

    // 구매담당자 변경, POHD
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public Map<String, String> cpor0020_doUpdateChange(Map<String, String> formData, List<Map<String, Object>> grid) throws Exception {
    	
        Map<String, String> rtnMap = new HashMap<>();
        for(Map<String, Object> data : grid) {
        	data.put("CTRL_USER_CH_ID", formData.get("CTRL_USER_CH_ID"));
            cpoi0010_mapper.cpor0020_doUpdateChange(data);
        }
        
        rtnMap.put("rtnMsg", msg.getMessage("0031"));
        return rtnMap;
    }
    
    // 2021.03.11 추가
    // 검수담당자 변경, POHD
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public Map<String, String> cpor0020_doUpdateChangeINV(Map<String, String> formData, List<Map<String, Object>> grid) throws Exception {
    	
        Map<String, String> rtnMap = new HashMap<>();
        for(Map<String, Object> data : grid) {
        	data.put("INSPECT_USER_ID", formData.get("PIC_USER_ID"));
            cpoi0010_mapper.cpor0020_doUpdateChangeINV(data);
        }
        
        rtnMap.put("rtnMsg", msg.getMessage("0031"));
        return rtnMap;
    }
    
    // 2021.09.16 추가
    // 검수유형 변경
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public Map<String, String> cpor0020_doUpdateDelivery(Map<String, String> formData, List<Map<String, Object>> grid) throws Exception {
    	
        Map<String, String> rtnMap = new HashMap<>();
        for(Map<String, Object> data : grid) {
        	String status = cpoi0010_mapper.cpor0020_doCheckDelivery(data);
            if (EverString.nullToEmptyString(status).equals("1")) {
                throw new Exception(msg.getMessageByScreenId("CPOR0020", "021")); // 진행상태를 확인하세요.
            }
            cpoi0010_mapper.cpor0020_doUpdateDelivery(data);
        }
        
        rtnMap.put("rtnMsg", msg.getMessage("0031"));	// 성공적으로 저장되었습니다.
        return rtnMap;
    }

    /**
     * 화면명 : 발주진행현황
     * 처리내용 : 품목별 발주 진행현황을 보여주는 화면
     * 경로 : 고객사 > 발주관리 > 발주관리 > 발주진행현황
     */
    public List<Map<String, Object>> cpor0030_doSearch(Map<String, String> param) {

        return cpoi0010_mapper.cpor0030_doSearch(param);
    }

    /**
     * 화면명 : 거래명세서현황
     * 처리내용 : 협력업체에서 제출한 거래명세서를 조회하는 화면
     * 경로 : 고객사 > 발주관리 > 발주관리 > 거래명세서현황
     */
    public List<Map<String, Object>> cpor0040_doSearch(Map<String, String> param) {

        return cpoi0010_mapper.cpor0040_doSearch(param);
    }
}
