package com.st_ones.nhepro.CBDR.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.st_ones.common.docNum.service.DocNumService;
import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.common.mail.web.MailTemplate;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.sms.service.EverSmsService;
import com.st_ones.common.util.TemplateUtil;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.common.util.service.LargeTextService;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.eversrm.eApproval.eApprovalModule.BAPM_Mapper;
import com.st_ones.eversrm.eApproval.eApprovalModule.service.BAPM_Service;
import com.st_ones.nhepro.CBDR.CBDR0060_Mapper;
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
 * (Copyright ⓒ 2014 ST-Ones CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : CBDR0060_Service.java
 * @date 2020. 6. 23.
 * @version 1.0
 */
@Service(value = "cbdr0060_Service")
public class CBDR0060_Service extends BaseService {

    @Autowired private MessageService msg;

    @Autowired private LargeTextService largeTextService;

    @Autowired private DocNumService docNumService;

    @Autowired private BAPM_Service approvalService;

    @Autowired private BAPM_Mapper bapm_mapper;

    @Autowired private MailTemplate mt;

    @Autowired private EverSmsService everSmsService;

    @Autowired private TemplateUtil templateUtil;

    @Autowired private CBDR0060_Mapper cbdr_Mapper;

    /**
     * 화면명 : 선정품의대기목록
     * 처리내용 : 낙찰된 협력업체에 대한 선정품의를 작성하는 화면.
     * 경로 : 고객사 > 구매관리 > 품의관리 > 선정품의대기목록
     */
    public List<Map<String, Object>> cbdr0060_doSearch(Map<String, String> param) throws Exception {
        return cbdr_Mapper.cbdr0060_doSearch(param);
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String cbdr0060_doCancelSettle(List<Map<String, Object>> gridDatas) throws Exception {

        for(Map<String, Object> gridData : gridDatas) {

            // 1. 품의대기(CNHB) 테이블의 진행상태 체크.
            String cancelPossibleFlag1 = cbdr_Mapper.cbdr0060_getCancelPossibleFlag(gridData);
            if(!EverString.nullToEmptyString(cancelPossibleFlag1).equals("Y")) {
                throw new Exception(msg.getMessageByScreenId("CBDR0060", "004"));
            }
            
            /**
            // 2. 동일한 견적/입찰건으로 품의 진행중인 건이 있는지 검토
            String cancelPossibleFlag2 = cbdr_Mapper.cbdr0060_getConfirmProgressFlag(gridData);
            if(!EverString.nullToEmptyString(cancelPossibleFlag2).equals("Y")) {
                throw new Exception(msg.getMessageByScreenId("CBDR0060", "016"));
            }*/
            
            String rfxType = String.valueOf(gridData.get("RFX_TYPE"));
            // 입찰업체 선정 취소
            if(rfxType.equals("BID")) {
                List<Map<String, Object>> targetList = cbdr_Mapper.cbdr0060_getTargetList(gridData);
                for(Map<String, Object> targetData : targetList) {
                    // 입찰공고의 진행상태(STOCBDHD.BID_STAUTS)를 '2400'으로 Update.
                    cbdr_Mapper.cancelBDHD(targetData);
                    // 선정된 업체의 STOCBDVO.BID_STATUS를 '300'에서 null로 Update.
                    cbdr_Mapper.cancelBDVO(targetData);
                    // 2021.01.22 변경
                    // 구매의뢰의 진행상태(STOCPRDT.PROGRESS_CD)를 '2350(입찰/견적 진행중)'으로 Update.
                    cbdr_Mapper.cancelPRDT(targetData);
                    // STOCCNHB 삭제.
                    cbdr_Mapper.deleteCNHB(targetData);
                }
            } // 견적업체 선정 취소
            else {
            	// 단일업체 선정
        		cbdr_Mapper.doUpdateProgressRQDT(gridData);
        		cbdr_Mapper.doUpdateProgressRQHD(gridData);
        		cbdr_Mapper.doUpdateSettleQTDT(gridData);
        		cbdr_Mapper.doDeleteCNHB(gridData);
        		
        		// 1. 구매의뢰품목 진행상태 : 2400(선정대기)
        		// 2. 2021.01.26 구매진행상태=2350으로 변경
        		List<Map<String, Object>> list = cbdr_Mapper.doSearchRqdt(gridData);
				for(Map<String, Object> data : list) {
					cbdr_Mapper.doUpdateInitJungGa(data);
				}
            }
        }
        return msg.getMessageByScreenId("CBDR0060", "003");
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String cbdr0060_doPrcConfirm(List<Map<String, Object>> gridDatas) throws Exception {

        for(Map<String, Object> gridData : gridDatas) {
            // 진행상태 체크.
            String cancelPossibleFlag = cbdr_Mapper.cbdr0060_getPrcPossibleFlag(gridData);
            if(!EverString.nullToEmptyString(cancelPossibleFlag).equals("Y")) {
                throw new Exception(msg.getMessageByScreenId("CBDR0060", "009"));
            }
        }
        for(Map<String, Object> gridData : gridDatas) {
            gridData.put("ADJ_PRC_STATUS", "400");
            cbdr_Mapper.doUpdateAdjPrcStatus(gridData);
        }
        return msg.getMessageByScreenId("CBDR0060", "011");
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String cbdr0060_doPrcReject(List<Map<String, Object>> gridDatas) throws Exception {

        for(Map<String, Object> gridData : gridDatas) {
            // 진행상태 체크.
            String cancelPossibleFlag = cbdr_Mapper.cbdr0060_getPrcPossibleFlag(gridData);
            if(!EverString.nullToEmptyString(cancelPossibleFlag).equals("Y")) {
                throw new Exception(msg.getMessageByScreenId("CBDR0060", "012"));
            }
        }
        for(Map<String, Object> gridData : gridDatas) {
            gridData.put("ADJ_PRC_STATUS", "300");
            cbdr_Mapper.doUpdateAdjPrcStatus(gridData);
        }
        return msg.getMessageByScreenId("CBDR0060", "014");
    }

    /**
     * 화면명 : 선정품의작성
     * 처리내용 : 협력업체 선정 품의서를 작성하는 화면.
     * 경로 : 고객사 > 구매관리 > 품의관리 > 선정품의대기목 > 선정품의작성
     */
    public Map<String, String> cbdi0061_doSearchHD(Map<String, String> param) throws Exception {

        Map<String, String> formData = cbdr_Mapper.cbdi0061_doSearchHD(param);
        if( EverString.isNotEmpty(formData.get("RMK_TEXT_NUM")) ) {
            formData.put("RMK_TEXT_CONTENTS", largeTextService.selectLargeText(formData.get("RMK_TEXT_NUM")));
        }

        return formData;
    }

    public List<Map<String, Object>> cbdi0061_doSearchVD(Map<String, String> param) throws Exception {

        List<Map<String, Object>> rtnList = null;
        String execNum = EverString.nullToEmptyString(param.get("EXEC_NUM"));

        if(execNum.equals("")) {
            if(EverString.isNotEmpty(param.get("paramExecWtNum"))) {
                param.put("paramExecWtNum", EverString.forInQuery(param.get("paramExecWtNum"), "@@"));
            }
            rtnList = cbdr_Mapper.cbdi0061_doSearchVDByRfx(param);
        }
        else {
            rtnList = cbdr_Mapper.cbdi0061_doSearchVD(param);
        }
        return rtnList;
    }

    public List<Map<String, Object>> cbdi0061_doSearchDT(Map<String, String> param) throws Exception {

        List<Map<String, Object>> rtnList = null;
        String execNum = EverString.nullToEmptyString(param.get("EXEC_NUM"));

        if(execNum.equals("")) {
            if(EverString.isNotEmpty(param.get("paramExecWtNum"))) {
                param.put("paramExecWtNum", EverString.forInQuery(param.get("paramExecWtNum"), "@@"));
            }
            rtnList = cbdr_Mapper.cbdi0061_doSearchDTByRfx(param);
        }
        else {
            rtnList = cbdr_Mapper.cbdi0061_doSearchDT(param);
        }
        return rtnList;
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public Map<String, String> cbdi0061_doSave(Map<String, String> formData, List<Map<String, Object>> gridDatasV, List<Map<String, Object>> gridDatasI) throws Exception {

        UserInfo userInfo = UserInfoManager.getUserInfo();
        Map<String, String> rtnMap = new HashMap<String, String>();

        String signStatus = EverString.nullToEmptyString(formData.get("SIGN_STATUS"));
        String oldSignStatus = EverString.nullToEmptyString(formData.get("OLD_SIGN_STATUS"));
        String buyerCd = EverString.nullToEmptyString(formData.get("BUYER_CD"));
        String execNum = EverString.nullToEmptyString(formData.get("EXEC_NUM"));

        String rmkTextNum = largeTextService.saveLargeText(formData.get("RMK_TEXT_NUM"), formData.get("RMK_TEXT_CONTENTS"));
        formData.put("RMK_TEXT_NUM", rmkTextNum);

        if(execNum.equals("")) {

            // 채번로직 변경. Parameter [화면에서 전달 받은 COMPANY_CD (없는 경우, ses.manageCd 또는 ses.companyCd), DOC_TYPE ]
            execNum = docNumService.getDocNumber(buyerCd, "EXEC");
            formData.put("EXEC_NUM", execNum);
        }
        else {
            // 결재상태가 "E", "P"인 경우, 수정/결재요청이 불가하다.
            String signStatusStr = getSignStatus(formData);
            if(EverString.nullToEmptyString(signStatusStr).equals("P")) {
                throw new Exception(msg.getMessageByScreenId("CBDI0061", "013"));
            }
            if(EverString.nullToEmptyString(signStatusStr).equals("E")) {
                throw new Exception(msg.getMessageByScreenId("CBDI0061", "014"));
            }
        }

        formData.put("EXEC_DOIB_FLAG", EverString.nullToEmptyString(formData.get("HIDDEN_EXEC_DOIB_FLAG")));
        formData.put("EXEC_TCO_FLAG", EverString.nullToEmptyString(formData.get("HIDDEN_EXEC_TCO_FLAG")));

        // STOCCNHD [일반정보]
        cbdr_Mapper.cbdi0061_doMergeHD(formData);

        // STOCCNVD [업체선정 품의서 협력사정보]
        for(Map<String, Object> gridDataV : gridDatasV) {
            gridDataV.put("BUYER_CD", formData.get("BUYER_CD"));
            gridDataV.put("EXEC_NUM", formData.get("EXEC_NUM"));
            cbdr_Mapper.cbdi0061_doMergeVD(gridDataV);
        }

        // STOCCNDT [업체선정 품의서 품목정보]
        cbdr_Mapper.cbdi0061_doDeleteAllDT(formData);

        for(Map<String, Object> gridDataI : gridDatasI) {

            gridDataI.put("BUYER_CD", formData.get("BUYER_CD"));
            gridDataI.put("EXEC_NUM", formData.get("EXEC_NUM"));
            gridDataI.put("PROGRESS_CD", "3100"); // PROGRESS_CD : 3100 (품의중)
            
            /**
             * 2021.06.18
             * 도입금액에 TCO비용을 합산하지 않는다.
            String execTcoFlag = formData.get("EXEC_TCO_FLAG");
            Double execAmt = (execTcoFlag.equals("1") ? (Double.parseDouble(String.valueOf(gridDataI.get("PR_AMT"))) + Double.parseDouble(String.valueOf(gridDataI.get("TCO_AMT")))) : Double.parseDouble(String.valueOf(gridDataI.get("PR_AMT"))));
            gridDataI.put("EXEC_AMT", execAmt);
			*/
            gridDataI.put("EXEC_AMT", gridDataI.get("PR_AMT"));
            cbdr_Mapper.cbdi0061_doInsertDT(gridDataI);
            
            // STOCCNHB [품의작성 대기정보]의 데이터를 삭제한다.
            gridDataI.put("EXEC_SQ", String.valueOf(gridDataI.get("EXEC_SQ_KEY")));
            cbdr_Mapper.cbdi0061_doDeleteCNHB(gridDataI);
        }

        // STOCCNHD, STOCCNVD, STOCCNDT에 저장(SIGN_STATUS = 'T' or 'P') 후, 결재요청인 경우 STOCSCTM 테이블에 저장.
        String appDocCnt = formData.get("APP_DOC_CNT");
        if (signStatus.equals("P"))
        {
            if (EverString.isEmpty(formData.get("APP_DOC_NUM"))) {
                // 채번로직 변경. Parameter [화면에서 전달 받은 COMPANY_CD (없는 경우, ses.manageCd 또는 ses.companyCd), DOC_TYPE ]
                formData.put("APP_DOC_NUM", docNumService.getDocNumber(buyerCd, "APPDOC"));
            }
            if (EverString.isEmpty(appDocCnt) || appDocCnt.equals("0")) {
                appDocCnt = "1";
            }
            else {
                appDocCnt = String.valueOf(Integer.parseInt(appDocCnt) + 1);
            }

            Map<String, String> approvalHeader = new ObjectMapper().readValue(formData.get("approvalFormData"), Map.class);
            formData.put("APP_SUBJECT", approvalHeader.get("SUBJECT")); // 제목
            formData.put("APP_DOC_CONTENTS", approvalHeader.get("DOC_CONTENTS")); // 상신의견
            formData.put("APP_DOC_CNT", appDocCnt);
            formData.put("DOC_TYPE", "EXEC");

            // 결재상신 공통모듈 호출
            approvalService.doApprovalProcess(formData, formData.get("approvalFormData"), formData.get("approvalGridData"));

            // 결재상신 후, STOCCNHD에 결재문서번호, 결재문서차수를 Update한다.
            cbdr_Mapper.updateAppNum(formData);
        }

        rtnMap.put("buyerCd", buyerCd);
        rtnMap.put("execNum", execNum);
        rtnMap.put("rtnMsg", (signStatus.equals("T") ? msg.getMessage("0031") : msg.getMessage("0023")));
        return rtnMap;
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String cbdi0061_doDelete(Map<String, String> formData, List<Map<String, Object>> gridDatasI) throws Exception {

        // STOCCNHD [일반정보]
        cbdr_Mapper.cbdi0061_doDeleteHD(formData);

        // STOCCNVD [업체선정 품의서 협력사정보]
        cbdr_Mapper.cbdi0061_doDeleteVD(formData);

        // STOCCNDT [업체선정 품의서 품목정보]
        cbdr_Mapper.cbdi0061_doDeleteDT(formData);

        // Insert Info STOCCNHB Select STOCCNDT
        for(Map<String, Object> gridDataI : gridDatasI) {
            gridDataI.put("BUYER_CD", formData.get("BUYER_CD"));
            gridDataI.put("EXEC_NUM", formData.get("EXEC_NUM"));
            cbdr_Mapper.cbdi0061_doInsertHB(gridDataI);
        }

        return msg.getMessage("0017");
    }

    /**
     * 화면명 : 선정품의현황
     * 처리내용 : 작성된 품의 목록을 조회하는 화면.
     * 경로 : 고객사 > 구매관리 > 품의관리 > 선정품의현황
     */
    public List<Map<String, Object>> cbdr0070_doSearch(Map<String, String> param) throws Exception {
        return cbdr_Mapper.cbdr0070_doSearch(param);
    }

    public String getSignStatus(Map<String, String> param) throws Exception {
        return cbdr_Mapper.getSignStatus(param);
    }

}