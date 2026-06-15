package com.st_ones.nhepro.CBDR.service;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.h2.engine.SysProperties;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.st_ones.common.docNum.service.DocNumService;
import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.common.mail.service.EverMailService;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.sms.service.EverSmsService;
import com.st_ones.common.util.clazz.EverCert;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.eversrm.eApproval.eApprovalModule.service.BAPM_Service;
import com.st_ones.nhepro.CBDR.CBDR0030_Mapper;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2014 ST-Ones CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : CBDR0030_Service.java
 * @date 2020. 5. 18.
 * @version 1.0
 */
@Service(value = "cbdr0030_Service")
public class CBDR0030_Service extends BaseService {

    @Autowired private MessageService msg;
    @Autowired private DocNumService docNumService;
    @Autowired private BAPM_Service approvalService;
    @Autowired private EverMailService everMailservice;
    @Autowired private EverSmsService everSmsService;
    @Autowired private CBDR0030_Mapper cbdr_Mapper;

    /**
     * 화면명 : 입찰진행
     * 처리내용 : 입찰공고 마감 이후 개찰전까지의 입찰공고 목록이 조회하는 화면.
     * 경로 : 고객사 > 구매관리 > 입찰관리 > 입찰진행
     */
    public List<Map<String, Object>> cbdr0030_doSearch(Map<String, String> param) throws Exception {
        return cbdr_Mapper.cbdr0030_doSearch(param);
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String cbdr0030_doUserChange(Map<String, String> formData, List<Map<String, Object>> gridDatas) throws Exception {

        for(Map<String, Object> gridData : gridDatas) {
            gridData.put("CHANGE_TYPE", formData.get("CHANGE_TYPE"));
            gridData.put("CHANGE_USER_ID", formData.get("CHANGE_USER_ID"));
            cbdr_Mapper.cbdr0030_doUserChange(gridData);
        }
        return msg.getMessageByScreenId("CBDR0030", "004");
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String cbdr0030_doFinishEvel(List<Map<String, Object>> gridDatas) throws Exception {

        for(Map<String, Object> gridData : gridDatas) {
            gridData.put("BID_STATUS", "2368");
            cbdr_Mapper.cbdr0030_doFinishEvel(gridData);

            /* 기술평가수행에서 완료한 평가점수를 STOCBDSP에 Insert한다.
               해당 입찰의 기술점수의 비율로 변환하여 BDSP.TECH_SCORE에 Insert.
               예 ) 이연무/금강 : 90점, 최승주/금강 : 100점, 두명의 평가자의 금강에 대한 점수 평균 : 95점
                    해당 입찰의 기술점수 기준 : 100점 만점에 80점 [100 : 80 = 95 : x] BDSP.TECH_SCORE = 76.##
            */
            List<Map<String, Object>> etResults = cbdr_Mapper.cbdr0030_getEtResults(gridData);
            for(Map<String, Object> etResult : etResults) {
                cbdr_Mapper.cbdr0030_doInsertSP(etResult);
            }
        }
        return msg.getMessageByScreenId("CBDR0030", "014");
    }
    
    /**
     * 2021.08.24
     * 입찰진행 > 유찰 처리
     * @param param
     * @return
     * @throws Exception
     */
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String cbdr0030_doFailBid(Map<String, String> param) throws Exception {

		param.put("BUYER_CD", param.get("SEL_BUYER_CD"));
		param.put("BID_NUM",  param.get("SEL_BID_NUM"));
		param.put("BID_CNT",  param.get("SEL_BID_CNT"));
    	
        // 진행상태를 체크한다.
        Map<String, Object> sParam = new HashMap<String, Object>();
        sParam.putAll(param);
        
        String oriBidStatus = cbdr_Mapper.getBidStatus(sParam);
        // 200 : 입찰시간알림, 300 : 입찰대기, 400 : 입출중
        if (EverString.nullToEmptyString(oriBidStatus).equals("200") ||
        	EverString.nullToEmptyString(oriBidStatus).equals("300") && EverString.nullToEmptyString(oriBidStatus).equals("400"))
        {
            throw new Exception(msg.getMessageByScreenId("CBDR0033", "T003")); // 진행상태를 확인하세요.
        }
        
        // 1. 해당 입찰공고의 진행상태를 '유찰'로 변경한다.
        param.put("BID_STATUS", "1300");
        cbdr_Mapper.setBidStatus(param);
        
        List<Map<String, Object>> vendorList = cbdr_Mapper.getVendorList(sParam);
        for(Map<String, Object> vendorData : vendorList) {
        	
            if(String.valueOf(vendorData.get("FINAL_FLAG")).equals("600")) { // 부적합업체
                vendorData.put("BID_STATUS", "600");
            } else {
                vendorData.put("BID_STATUS", "400"); // 유찰
            }
            
            vendorData.put("BUYER_CD", param.get("BUYER_CD"));
            vendorData.put("BID_NUM", param.get("BID_NUM"));
            vendorData.put("BID_CNT", param.get("BID_CNT"));
            vendorData.put("VOTE_CNT", param.get("VOTE_CNT"));
            cbdr_Mapper.doSuccessfulOrFailBid(vendorData);
        }
        
        // 3. 구매의뢰의 진행상태를 '유찰'로 변경한다.
        List<Map<String, Object>> prList = cbdr_Mapper.getPrList(param);
        for(Map<String, Object> prData : prList) {
            prData.put("PROGRESS_CD", "1300");
            cbdr_Mapper.setPrProgressCd(prData);
        }
        
        return msg.getMessageByScreenId("CBDR0033", "T006");
    }
    
    /**
     * 2021.08.24
     * 입찰진행 > 재공고시 입찰건에 대한 진행상태 체크
     * @param param
     * @return
     * @throws Exception
     */
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String cbdr0030_doCheckWithReAnn(Map<String, String> param) throws Exception {
    	
        // 진행상태를 체크한다.
        Map<String, Object> sParam = new HashMap<String, Object>();
        sParam.putAll(param);
        String oriBidStatus = cbdr_Mapper.getBidStatus(sParam);
        
        // 200 : 입찰시간알림, 300 : 입찰대기, 400 : 입출중
        if (EverString.nullToEmptyString(oriBidStatus).equals("200") ||
        	EverString.nullToEmptyString(oriBidStatus).equals("300") && EverString.nullToEmptyString(oriBidStatus).equals("400"))
        {
            throw new Exception(msg.getMessageByScreenId("CBDR0033", "T003")); // 진행상태를 확인하세요.
        }
        
        return null;
    }
    
    /**
     * 화면명 : 규격평가등록결과 등록
     * 처리내용 : 2단계(분리)경쟁의 규격평가 결과를 등록하는 화면
     * 경로 : 고객사 > 구매관리 > 입찰관리 > 입찰진행 > 규격평가등록결과 등록
     */
    public Map<String, String> cbdi0031_doSearchHD(Map<String, String> param) throws Exception {
        return cbdr_Mapper.cbdi0031_doSearchHD(param);
    }

    public List<Map<String, Object>> cbdi0031_doSearch(Map<String, String> param) throws Exception {
        return cbdr_Mapper.cbdi0031_doSearch(param);
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String cbdi0031_doConfirm(Map<String, String> formData, List<Map<String, Object>> gridDatas) throws Exception {

        // 진행상태를 체크한다.
        String closePossibleFlag = cbdr_Mapper.cbdi0031_getEvPossibleFlag(formData);
        if(!EverString.nullToEmptyString(closePossibleFlag).equals("Y")) {
            throw new Exception(msg.getMessageByScreenId("CBDI0031", "T003"));
        }

        for(Map<String, Object> gridData : gridDatas) {
            cbdr_Mapper.cbdi0031_doConfirm(gridData);
        }

        String contType2 = formData.get("CONT_TYPE2");
        if(contType2.equals("TD")) {
            formData.put("BID_STATUS", "2354"); // 2단계 분리 : 진행상태를 '규격평가'에서 '입찰시간알림'으로 변경한다.
        } else if(contType2.equals("TS")) {
            formData.put("BID_STATUS", "2364"); // 2단계 동시 : 진행상태를 '규격평가'에서 '개찰대기'로 변경한다.
        } else if(contType2.equals("NE")) {
            formData.put("BID_STATUS", "2367"); // 협상         : 진행상태를 '규격평가'에서 '기술평가'로 변경한다.
        }
        cbdr_Mapper.setBidStatus(formData);

        return msg.getMessageByScreenId("CBDI0031", "T007");
    }

    /**
     * 화면명 : 입찰시간 알림
     * 처리내용 : 2단계(분리)경쟁 또는 재입찰시 입찰서 제출일시 및 개찰일시를 지정하는 화면
     * 경로 : 고객사 > 구매관리 > 입찰관리 > 입찰진행 > 입찰시간 알림
     */
    public Map<String, String> cbdi0032_doSearchHD(Map<String, String> param) throws Exception {
        return cbdr_Mapper.cbdi0032_doSearchHD(param);
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String cbdi0032_doConfirm(Map<String, String> formData) throws Exception {

        boolean reBidFlag = Boolean.parseBoolean(formData.get("REBID"));
        String closePossibleFlag = "";

        if(!reBidFlag) {
            // 진행상태를 체크한다.
            closePossibleFlag = cbdr_Mapper.getBidTimePossibleFlag(formData);
            if(!EverString.nullToEmptyString(closePossibleFlag).equals("Y")) {
                throw new Exception(msg.getMessageByScreenId("CBDI0032", "T003"));
            }

            cbdr_Mapper.cbdi0032_doConfirm(formData);

            // 진행상태를 '입찰시간알림'에서 '입찰대기'으로 변경한다.
            formData.put("BID_STATUS", "2350"); // 입찰대기
            cbdr_Mapper.setBidStatus(formData);
        }

        // 재입찰
        if(reBidFlag) {
            // 진행상태를 체크한다.
            closePossibleFlag = cbdr_Mapper.getReBidTimePossibleFlag(formData);
            if(!EverString.nullToEmptyString(closePossibleFlag).equals("Y")) {
                throw new Exception(msg.getMessageByScreenId("CBDI0032", "T003"));
            }

            cbdr_Mapper.cbdi0032_doInsertNewVote(formData);

            // 진행상태를 '재입찰'로 변경한다.
            formData.put("BID_STATUS", "2550"); // 재입찰
            cbdr_Mapper.setBidStatus(formData);
        }
        return msg.getMessageByScreenId("CBDI0032", "T007");
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String cbdi0032_doConfirmIndividual(Map<String, String> formData) throws Exception {

        // 진행상태를 체크한다.
        String closePossibleFlag = cbdr_Mapper.getReBidTimePossibleFlag(formData);
        if(!EverString.nullToEmptyString(closePossibleFlag).equals("Y")) {
            throw new Exception(msg.getMessageByScreenId("CBDI0032", "T003"));
        }

        String vendorCd = formData.get("VENDOR_CD");
        String vendorMaxVoteCnt = formData.get("VENDOR_MAX_VOTE_CNT");
        String newVoteCnt = String.valueOf(Integer.parseInt(formData.get("VENDOR_MAX_VOTE_CNT")) + 1);
        String preVoteCnt = String.valueOf(Integer.parseInt(formData.get("VENDOR_MAX_VOTE_CNT")) - 1);

        // 해당 화면에서 ‘확정＇시 해당 업체의 STOCBDVO의 MAX(VOTE_CNT) + 1의 값을 STOCBDPG의 VOTE_CNT를 비교하여 Insert 또는 Update 한다.
        formData.put("NEW_VOTE_CNT", newVoteCnt);
        cbdr_Mapper.cbdi0032_doMergeNewVote(formData);

        // STOCBDHD.BID_STATUS = ‘2410’으로 Update
        formData.put("BID_STATUS", "2410");
        cbdr_Mapper.setBidStatus(formData);

        // 해당 업체의 STOCBDVO.BID_STATUS = ‘200’으로 Update하고,
        formData.put("BID_STATUS", "200");
        formData.put("VENDOR_CD", vendorCd);
        formData.put("VOTE_CNT", vendorMaxVoteCnt);
        cbdr_Mapper.setBidStatusVO(formData);

        // 이전 차수의 STOCBDVO.BID_STATUS를 NULL로 Update한다.
        formData.put("BID_STATUS", null);
        formData.put("VENDOR_CD", vendorCd);
        formData.put("VOTE_CNT", preVoteCnt);
        cbdr_Mapper.setBidStatusVO(formData);

        return msg.getMessageByScreenId("CBDI0032", "T007");
    }

    /**
     * 화면명 : 입찰신청자조서 및 입찰비교표
     * 처리내용 : 입찰에 참여한 협력업체 입찰정보를 참고하여 낙찰자를 선정하는 화면
     * 경로 : 고객사 > 구매관리 > 입찰관리 > 입찰진행 > 입찰신청자조서 및 입찰비교표
     */
    public Map<String, String> cbdr0033_doSearchHD(Map<String, String> param) throws Exception {
        return cbdr_Mapper.cbdr0033_doSearchHD(param);
    }

    public String cbdr0033_getBidStatus(Map<String, Object> param) throws Exception {

        String rtnCd = cbdr_Mapper.getBidStatus(param);
        if(rtnCd == null || EverString.nullToEmptyString(rtnCd).equals("")) {
            rtnCd = cbdr_Mapper.getOriBidStatus(param);
        }
        return rtnCd;
    }

    public Map<String, String> getSettleVendor(Map<String, String> param) throws Exception {
        return cbdr_Mapper.getSettleVendor(param);
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String cbdr0033_doUpdateBidStatus(Map<String, String> param) throws Exception {

        UserInfo userInfo = UserInfoManager.getUserInfo();
        
        String voteCnt = param.get("VOTE_CNT");
        
        // 진행상태를 체크한다.
        Map<String, Object> sParam = new HashMap<String, Object>();
        sParam.putAll(param);
        Map<String, String> checkMap = cbdr_Mapper.checkOpenPossible(sParam);
        if(!EverString.nullToEmptyString(checkMap.get("PROGRESS_CD")).equals("600") && !EverString.nullToEmptyString(checkMap.get("PROGRESS_CD")).equals("800")) {
            throw new Exception(msg.getMessageByScreenId("CBDR0033", "T003"));
        }
        if(!EverString.nullToEmptyString(checkMap.get("OPEN_POSSIBLE_FLAG")).equals("Y")) {
            throw new Exception(msg.getMessageByScreenId("CBDR0033", "T010"));
        }
        if(!EverString.nullToEmptyString(checkMap.get("OPEN_USER_ID")).equals(userInfo.getUserId())) {
            throw new Exception(msg.getMessageByScreenId("CBDR0033", "T011"));
        }

        List<Map<String, Object>> rtnList = cbdr_Mapper.checkSignDataList(sParam);

        // for문을 돌며 서명값을 검증한다.
        for (Map<String, Object> rtnMap : rtnList) {

            String sSignData = String.valueOf(rtnMap.get("BID_AMT_CERTV"));
            String vidRandom = String.valueOf(rtnMap.get("VID_RANDOM"));
            String idn = String.valueOf(rtnMap.get("IRS_NO"));

            /* useCard : "1" (Test용 법인용 공인인증서, 사업자 등록번호 : 2128159710)
                         "2" (Test용 법인용 블럭체인 사설인증서, 사업자 등록번호 : 1122334455)
                         "3" {Test용 개인용 블럭체인 사설인증서, 사업자 등록번호 : ""} */
            String useCard = "";
            if(PropertiesManager.getBoolean("eversrm.system.localserver") || PropertiesManager.getBoolean("eversrm.system.developmentFlag")) {
                useCard = "1";
            }
            
            boolean checkFlag = EverCert.doCheckSignedData(sSignData, vidRandom, idn, useCard);
            if(!checkFlag) { return "WRONGCERT"; }

            /* 서명데이터 검증
            String[] oriSignedDataArgs = EverCert.getOriSignedData(sSignData, vidRandom, idn, "@@", useCard);
            for(int z = 0; z < oriSignedDataArgs.length; z++) {
                String oriSignedDataStr = oriSignedDataArgs[z];
            }*/
        }

        // 진행상태[STOCBDHD.BID_STUATUS]를 선정대기 상태로 Update 한다.
        param.put("BID_STATUS", "2400");
        cbdr_Mapper.setBidStatus(param);
        
        // 협력업체에서 투찰한 단가와 금액을 복호화한다.
        cbdr_Mapper.setDecVO(param);

        // 투찰차수가 '1'인 경우, 예가(STOCBDES.ESTM_PRC1_ENC ... )를 복호화한다.
        if(voteCnt.equals("1")) {
        	
            cbdr_Mapper.setDecES(param);
            
            String estmType = EverString.nullToEmptyString(cbdr_Mapper.getEstmType(param));
            // 단일 예가인 경우, BDES.FINAL_ESTM_PRC = BDES.ESTM_PRC1로 Update한다.
            if (estmType.equals("SE")) {
                cbdr_Mapper.setFinalEstmPrcSE(param);
            }
            // 복수 예가인 경우, 업체가 선택 한 '선택 예정가격' [BDVO.CHOICE_ESTM_NUM1, CHOICE_ESTM_NUM2]의 정보를 가져와
            // 가장 많이 선택한 번호대로 BDES.CHOIC_ESTM_PRC1, 2, 3, 4...에 Update한 후, 4개의 평균값을 BDES.FINAL_ESTM_PRC에 Update한다.
            /* Example )
	                   협력업체에서 선택한 번호...
	                   업체 A : 1번, 3번   업체 B : 2번, 5번   업체 C : 7번, 11번   업체 D : 3번, 8번   업체 E : 3번, 1번 ...
               1등 : 3번(3개업체 선택)  BDES.CHOIC_ESTM_PRC1 = ESTM_PRC3
               2등 : 1번(2개업체 선택)  BDES.CHOIC_ESTM_PRC2 = ESTM_PRC1
               3등 : 2, 5, 7, 8, 11 (5개 중에 하나를 RANDOM으로 고른다.)    BDES.CHOIC_ESTM_PRC3 = ESTM_PRC5
               4등 : (3등에서 탈락한 번호들 중 하나를 RANDOM으로 고른다.)     BDES.CHOIC_ESTM_PRC4 = ESTM_PRC7

               FINAL_ESTM_PRC = AVG(CHOIC_ESTM_PRC1 + CHOIC_ESTM_PRC2 + CHOIC_ESTM_PRC3 + CHOIC_ESTM_PRC4)
            */
            else if (estmType.equals("PE")) {

                // 추첨에 필요한 변수를 생성한다.
                Map<String, Object> choiMap = new HashMap<String, Object>();
                // 최대 15개의 예정가격번호가 있으므로 i = 1 ~ 15까지...
                for (int i = 1; i < 16; i++) {
                    choiMap.put("CHOICE_" + i, 0);
                }

                // 협력업체가 선택한 예정가격 정보를 가져온다.
                List<Map<String, Object>> vendorChoiceList = cbdr_Mapper.getVendorChoiceList(param);
                if (vendorChoiceList.size() > 0) {
                    for (Map<String, Object> data : vendorChoiceList) {
                        // 최대 15개의 예정가격번호가 있으므로, for문을 돌면서 협력업체가 선택한 번호를 카운트한다.
                        for (int i = 1; i < 16; i++) {
                            int choiceCnt = Integer.parseInt(String.valueOf(choiMap.get("CHOICE_" + i)));
                            if (Integer.parseInt(String.valueOf(data.get("CHOICE_ESTM_NUM1"))) == i) {
                                choiceCnt++;
                            }
                            if (Integer.parseInt(String.valueOf(data.get("CHOICE_ESTM_NUM2"))) == i) {
                                choiceCnt++;
                            }
                            choiMap.put("CHOICE_" + i, choiceCnt);
                        }
                    }

                    int listIdx = 0;
                    List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
                    for (int i = 1; i < 16; i++) {
                        Map<String, Object> tmp = new HashMap<String, Object>();
                        tmp.put("GATE_CD", "100");
                        tmp.put("CHOICE_NUM", String.valueOf(i));
                        tmp.put("CHOICE_CNT", choiMap.get("CHOICE_" + i));
                        list.add(listIdx, tmp);
                        listIdx++;
                    }

                    Map<String, Object> objectMap = new HashMap<String, Object>();
                    objectMap.put("list", list);
                    // 위에서 카운트한 정보를 기준으로 순위를 정한다. 동일하게 선택을 받은 번호가 있는 경우, Oracle Random 함수를 이용하여 무작위로 순위를 정한다.
                    List<Map<String, String>> choiceRankList = cbdr_Mapper.getChoiceRankList(objectMap);

                    objectMap = new HashMap<String, Object>();
                    objectMap.put("BUYER_CD", sParam.get("BUYER_CD"));
                    objectMap.put("BID_NUM", sParam.get("BID_NUM"));
                    objectMap.put("BID_CNT", sParam.get("BID_CNT"));

                    listIdx = 0;
                    list = new ArrayList<Map<String, Object>>();
                    for (int r = 0; r < 4; r++) {
                        Map<String, String> choiceRankMap = choiceRankList.get(r);
                        Map<String, Object> tmp = new HashMap<String, Object>();
                        tmp.put("COL_ID", "ESTM_PRC" + choiceRankMap.get("CHOICE_NUM"));
                        tmp.put("COL_NM", "CHOIC_ESTM_PRC" + (r + 1));
                        list.add(listIdx, tmp);
                        listIdx++;
                    }
                    objectMap.put("list", list);

                    // 가장 많이 선택한 번호대로 BDES.CHOIC_ESTM_PRC1, 2, 3, 4에 Update하기 위해 해당 순위의 ESTM_PRC의 값을 가져온다.
                    List<Map<String, Object>> estmPrcList = cbdr_Mapper.getEstmPrcList(objectMap);
                    if (estmPrcList.size() > 0) {
                        Map<String, Object> estmPrcData = estmPrcList.get(0);
                        estmPrcData.put("BUYER_CD", sParam.get("BUYER_CD"));
                        estmPrcData.put("BID_NUM", sParam.get("BID_NUM"));
                        estmPrcData.put("BID_CNT", sParam.get("BID_CNT"));
                        cbdr_Mapper.setFinalEstm(estmPrcData);
                    }
                }
            }
        }
        
        /**
         * 입찰 및 견적은 업체선정대기 이후에 재견적, 재입찰, 재공고등이 진행되기 때문에 구매진행상태를 2400으로 변경하지 않음
         * 2021.01.22 추가
         * 구매진행상태 = '업체선정완료(2400)'로 변경한다.
        List<Map<String, Object>> prList = cbdr_Mapper.getPrList(param);
        for(Map<String, Object> prData : prList) {
            prData.put("PROGRESS_CD", "2400");
            cbdr_Mapper.setPrProgressCd(prData);
        }*/
        
        return msg.getMessageByScreenId("CBDI0032", "T007");
    }

    public List<Map<String, Object>> cbdr0033_doSearchVendorVO(Map<String, Object> param) throws Exception {

        List<Map<String, Object>> rtnList = null;
        String contType2 = EverString.nullToEmptyString(param.get("CONT_TYPE2"));

        // 최저가, 2단계 분리
        if(contType2.equals("LP") || contType2.equals("TD")) {
            rtnList = cbdr_Mapper.cbdr0033_doSearchVendorVO_LPTD(param);
        }
        // 적격심사, 협상에 의한 낙찰자선정
        else if(contType2.equals("QE") || contType2.equals("NE")) {

            // 협력업체별로 별도의 재입찰을 할 수 있음.
            // 협력업체별로 별도의 재입찰을 돌리는지 조회한다.
            Map<String, String> pParam = new HashMap<String, String>();
            pParam.put("BUYER_CD", String.valueOf(param.get("BUYER_CD")));
            pParam.put("BID_NUM", String.valueOf(param.get("BID_NUM")));
            pParam.put("BID_CNT", String.valueOf(param.get("BID_CNT")));

            List<Map<String, String>> checkList = cbdr_Mapper.cbdi0034_doSearchIndividualFlag(pParam);
            String individualFlag = "N";
            String maxVoteCnt = "";
            for(int i = 0; i < checkList.size(); i++) {
                Map<String, String> checkData = checkList.get(i);
                maxVoteCnt = String.valueOf(checkData.get("VENDOR_MAX_VOTE_CNT"));
                if(StringUtils.isNotEmpty(maxVoteCnt) && Integer.parseInt(maxVoteCnt) > 1) {
                	individualFlag = "Y"; // 별도의 재입찰 진행 중...
                	break;
                }
                
                /**
                 * 2021.10.07 : 1개 이상의 협력사가 개별 입찰할 경우
                if(i == 0) {
                    maxVoteCnt = String.valueOf(checkData.get("VENDOR_MAX_VOTE_CNT"));
                } else {
                    if(!maxVoteCnt.equals(String.valueOf(checkData.get("VENDOR_MAX_VOTE_CNT")))) {
                        individualFlag = "Y"; // 별도의 재입찰 진행 중...
                    }
                }*/
            }

            if(individualFlag.equals("Y")) {
                String rankVoteCnt = "";
                List<Map<String, String>> vendorList = new ArrayList<Map<String, String>>();
                for(int i = 0; i < checkList.size(); i++) {
                    Map<String, String> checkMap = checkList.get(i);
                    rankVoteCnt = checkMap.get("RANK_VOTE_CNT");
                }
                param.put("RANK_VOTE_CNT", rankVoteCnt);

                List<Map<String, Object>> colInfoList = (List<Map<String, Object>>) param.get("additionalColumnInfoList");
                for(int c = 0; c < colInfoList.size(); c++) {
                    Map<String, Object> colInfo = colInfoList.get(c);
                }
                rtnList = cbdr_Mapper.cbdr0033_doSearchVendorVO_Individual(param);
            } else {
                rtnList = cbdr_Mapper.cbdr0033_doSearchVendorVO_Etc(param);
            }
        } else {
            rtnList = cbdr_Mapper.cbdr0033_doSearchVendorVO_Etc(param);
        }
        return rtnList;
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String cbdr0033_setBidRank(Map<String, String> formData, List<Map<String, Object>> gridDatas) throws Exception {

        for(Map<String, Object> gridData : gridDatas) {
            gridData.put("BUYER_CD", formData.get("BUYER_CD"));
            gridData.put("BID_NUM", formData.get("BID_NUM"));
            gridData.put("BID_CNT", formData.get("BID_CNT"));
            gridData.put("VOTE_CNT", formData.get("VOTE_CNT"));
            cbdr_Mapper.setBidRank(gridData);
        }
        return msg.getMessageByScreenId("CBDR0033", "T012");
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String cbdr0033_doSuccessfulBid(Map<String, String> param, List<Map<String, Object>> gridHdDatas, List<Map<String, Object>> gridDtDatas) throws Exception {

        // 진행상태를 체크한다.
        Map<String, Object> sParam = new HashMap<String, Object>();
        sParam.putAll(param);
        
        String oriBidStatus = cbdr_Mapper.getBidStatus(sParam);
        if( !EverString.nullToEmptyString(oriBidStatus).equals("700") &&
        	!EverString.nullToEmptyString(oriBidStatus).equals("800") && !EverString.nullToEmptyString(oriBidStatus).equals("900")) {
            throw new Exception(msg.getMessageByScreenId("CBDR0033", "T003"));
        }

        // 해당 입찰공고의 진행상태를 '낙찰'로 변경한다.
        param.put("BID_STATUS", "2500");
        cbdr_Mapper.setBidStatus(param);

        for(Map<String, Object> gridDtData : gridDtDatas) {

            if(String.valueOf(gridDtData.get("VENDOR_CD")).equals(String.valueOf(gridHdDatas.get(0).get("VENDOR_CD")))) {
                gridDtData.put("BID_STATUS", "300"); // 낙찰
                gridDtData.put("ADJ_PRC_STATUS", "100"); // 대상
                gridDtData.put("BID_RMK", String.valueOf(gridHdDatas.get(0).get("BID_RMK"))); // 비고
            } else {
                if(String.valueOf(gridDtData.get("FINAL_FLAG")).equals("600")) { // 부적합업체
                    gridDtData.put("BID_STATUS", "600");
                } else {
                    gridDtData.put("BID_STATUS", "400"); // 유찰
                }
                gridDtData.put("ADJ_PRC_STATUS", "");
                gridDtData.put("BID_RMK",        "");
            }
            gridDtData.put("BUYER_CD", param.get("BUYER_CD"));
            gridDtData.put("BID_NUM", param.get("BID_NUM"));
            gridDtData.put("BID_CNT", param.get("BID_CNT"));
            gridDtData.put("VOTE_CNT", param.get("VOTE_CNT"));
            cbdr_Mapper.doSuccessfulOrFailBid(gridDtData);
        }

        // 협력사 선정 후 구매진행상태 = '업체선정완료(2500)'로 변경한다.
        List<Map<String, Object>> prList = cbdr_Mapper.getPrList(param);
        for(Map<String, Object> prData : prList) {
            prData.put("PROGRESS_CD", "2500");
            cbdr_Mapper.setPrProgressCd(prData);
        }

        // 품의작성 대기정보에 낙찰정보를 Insert한다. [STOCCNHB]
        Map<String, String> cnParam = new HashMap<String, String>();
        cnParam.put("BUYER_CD", param.get("BUYER_CD"));
        cnParam.put("BID_NUM", param.get("BID_NUM"));
        cnParam.put("BID_CNT", param.get("BID_CNT"));

        List<Map<String, Object>> cnWtList = cbdr_Mapper.getCnWtList(cnParam);
        for(Map<String, Object> cnWtData : cnWtList) {
            // 채번로직 변경. Parameter [화면에서 전달 받은 COMPANY_CD (없는 경우, ses.manageCd 또는 ses.companyCd), DOC_TYPE ]
            String execWtNum = docNumService.getDocNumber(param.get("BUYER_CD"), "EXEW");
            cnWtData.put("EXEC_WT_NUM", execWtNum);
            cbdr_Mapper.doInsertCNHB(cnWtData);
        }

        // 메일, SMS 발송.
        sendMailSms(param);

        return msg.getMessageByScreenId("CBDR0033", "T019");
    }
    
    /**
     * 유찰 처리
     * @param param
     * @return
     * @throws Exception
     */
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String cbdr0033_doFailBid(Map<String, String> param) throws Exception {
    	
    	// 2021.09.09 입찰진행 화면에서 단독 투찰건에 대한 유찰 처리인지 확인
    	String singleFlag = param.get("SINGLE_FLAG");
    	String contType2  = param.get("SEL_CONT_TYPE");
    	System.out.println("contType2 =====> " + contType2);
    	if( EverString.isNotEmpty(singleFlag) && "1".equals(singleFlag) ) {
    		param.put("BUYER_CD", param.get("SEL_BUYER_CD"));
    		param.put("BID_NUM",  param.get("SEL_BID_NUM"));
    		param.put("BID_CNT",  param.get("SEL_BID_CNT"));
    		param.put("VOTE_CNT", param.get("SEL_VOTE_CNT"));
    		param.put("PRE_BID_STATUS", param.get("SEL_ORI_BID_STATUS"));
    	}
    	
        // 진행상태를 체크한다.
        Map<String, Object> sParam = new HashMap<String, Object>();
        sParam.putAll(param);
        String oriBidStatus = cbdr_Mapper.getBidStatus(sParam);
        
        if( EverString.isNotEmpty(singleFlag) && "1".equals(singleFlag) ) {
        	
        	System.out.println("============== 단독입찰 유찰 및 재공고 =================");
        	if(EverString.isNotEmpty(contType2) && !contType2.equals("TD")) {
        		System.out.println("============== 2단계 분리입찰 제외 =================");
	        	// 200(입찰시간알림), 300(입찰대기), 400(입찰중)
	        	if (EverString.nullToEmptyString(oriBidStatus).equals("")    || EverString.nullToEmptyString(oriBidStatus).equals("200") ||
	                EverString.nullToEmptyString(oriBidStatus).equals("300") || EverString.nullToEmptyString(oriBidStatus).equals("400")) {
	                throw new Exception(msg.getMessageByScreenId("CBDR0033", "T003")); // 진행상태를 확인하세요.
	            }
        	}
        }
        else {
            // 700(선정대기), 800(협상중), 900(적격심사중)
            if (!EverString.nullToEmptyString(oriBidStatus).equals("") && !EverString.nullToEmptyString(oriBidStatus).equals("700") &&
                !EverString.nullToEmptyString(oriBidStatus).equals("800") && !EverString.nullToEmptyString(oriBidStatus).equals("900")) {
                throw new Exception(msg.getMessageByScreenId("CBDR0033", "T003")); // 진행상태를 확인하세요.
            }
        }
        
        // 1. 해당 입찰공고의 진행상태를 '유찰'로 변경한다.
        param.put("BID_STATUS", "1300");
        cbdr_Mapper.setBidStatus(param);
        
        List<Map<String, Object>> vendorList = cbdr_Mapper.getVendorList(sParam);
        for(Map<String, Object> vendorData : vendorList) {
            if(String.valueOf(vendorData.get("FINAL_FLAG")).equals("600")) { // 부적합업체
                vendorData.put("BID_STATUS", "600");
            } else {
                vendorData.put("BID_STATUS", "400"); // 유찰
            }
            
            vendorData.put("BUYER_CD", param.get("BUYER_CD"));
            vendorData.put("BID_NUM", param.get("BID_NUM"));
            vendorData.put("BID_CNT", param.get("BID_CNT"));
            vendorData.put("VOTE_CNT", param.get("VOTE_CNT"));
            cbdr_Mapper.doSuccessfulOrFailBid(vendorData);
        }
        
        // 3. 구매의뢰의 진행상태를 '유찰'로 변경한다.
        List<Map<String, Object>> prList = cbdr_Mapper.getPrList(param);
        for(Map<String, Object> prData : prList) {
            prData.put("PROGRESS_CD", "1300");
            cbdr_Mapper.setPrProgressCd(prData);
        }
        
        return msg.getMessageByScreenId("CBDR0033", "T006");
    }
    
    /**
     * 2021.04.14 추가
     * 재공고시 입찰건에 대한 진행상태 체크
     * @param param
     * @return
     * @throws Exception
     */
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String cbdr0033_doCheckWithReAnn(Map<String, String> param) throws Exception {
    	
    	// 2021.09.09 입찰진행 화면에서 단독 투찰건에 대한 유찰 처리인지 확인
    	String singleFlag = param.get("SINGLE_FLAG");
    	String contType2  = param.get("SEL_CONT_TYPE");
    	if( EverString.isNotEmpty(singleFlag) && "1".equals(singleFlag) ) {
    		param.put("BUYER_CD", param.get("SEL_BUYER_CD"));
    		param.put("BID_NUM",  param.get("SEL_BID_NUM"));
    		param.put("BID_CNT",  param.get("SEL_BID_CNT"));
    		param.put("VOTE_CNT", param.get("SEL_VOTE_CNT"));
    	}
    	
        // 진행상태를 체크한다.
        Map<String, Object> sParam = new HashMap<String, Object>();
        sParam.putAll(param);
        String oriBidStatus = cbdr_Mapper.getBidStatus(sParam);
        if( EverString.isNotEmpty(singleFlag) && "1".equals(singleFlag) ) {
        	if(EverString.isNotEmpty(contType2) && !contType2.equals("TD")) {
	            // 200(입찰시간알림), 300(입찰대기), 400(입찰중)
	        	if (EverString.nullToEmptyString(oriBidStatus).equals("")    || EverString.nullToEmptyString(oriBidStatus).equals("200") ||
	                EverString.nullToEmptyString(oriBidStatus).equals("300") || EverString.nullToEmptyString(oriBidStatus).equals("400")) {
	                throw new Exception(msg.getMessageByScreenId("CBDR0033", "T003")); // 진행상태를 확인하세요.
	            }
        	}
        }
        else {
            // 700(선정대기), 800(협상중), 900(적격심사중)
            if (!EverString.nullToEmptyString(oriBidStatus).equals("")    && !EverString.nullToEmptyString(oriBidStatus).equals("700") &&
            	!EverString.nullToEmptyString(oriBidStatus).equals("800") && !EverString.nullToEmptyString(oriBidStatus).equals("900")) {
                throw new Exception(msg.getMessageByScreenId("CBDR0033", "T003")); // 진행상태를 확인하세요.
            }
        }
        System.out.println("============== 진헹상태 체크 끝 =================");
        
        return null;
    }

    /**
     * 화면명 : 종합낙찰제결과 등록
     * 처리내용 : 종합낙찰제의 결과를 등록하는 화면
     * 경로 : 고객사 > 구매관리 > 입찰관리 > 입찰진행 > 입찰신청자조서 및 입찰비교표 > 종합낙찰제결과 등록
     */
    public List<Map<String, Object>> cbdi0034_doSearchVendorVO(Map<String, String> param) throws Exception {

        List<Map<String, Object>> rtnList = null;

        // 협력업체별로 별도의 재입찰을 돌리는지 조회한다.
        List<Map<String, String>> checkList = cbdr_Mapper.cbdi0034_doSearchIndividualFlag(param);
        String individualFlag = "N";
        String maxVoteCnt = "";
        for(int i = 0; i < checkList.size(); i++) {
            Map<String, String> checkData = checkList.get(i);
            maxVoteCnt = String.valueOf(checkData.get("VENDOR_MAX_VOTE_CNT"));
            if(StringUtils.isNotEmpty(maxVoteCnt) && Integer.parseInt(maxVoteCnt) > 1) {
            	individualFlag = "Y"; // 별도의 재입찰 진행 중...
            	break;
            }
            
            /**
             * 2021.10.07 : 1개 이상의 협력사가 개별 입찰할 경우
            if(i == 0) {
                maxVoteCnt = String.valueOf(checkData.get("VENDOR_MAX_VOTE_CNT"));
            } else {
                if(!maxVoteCnt.equals(String.valueOf(checkData.get("VENDOR_MAX_VOTE_CNT")))) {
                    individualFlag = "Y"; // 별도의 재입찰 진행 중...
                }
            }*/
        }
        
        if(individualFlag.equals("Y")) {
            int vendorIdx = 0;
            List<Map<String, String>> vendorList = new ArrayList<Map<String, String>>();
            for(int i = 0; i < checkList.size(); i++) {
                vendorList.add(vendorIdx, checkList.get(i));
                vendorIdx++;
            }

            Map<String,Object> sParam = new HashMap<String,Object>();
            sParam.putAll(param);
            sParam.put("vendorList", vendorList);
            rtnList = cbdr_Mapper.cbdi0034_doSearchVendorVoIndividual(sParam);

            // 협상중인 업체가 투찰한 금액이 선정기준에 벗어난 경우, 기존의 협상중(200)인 상태를 null로 변경한다.
            for(int j = 0; j < rtnList.size(); j++) {
                Map<String, Object> rtnData = rtnList.get(j);
                if(EverString.nullToEmptyString(rtnData.get("BID_STATUS")).equals("600")) {
                    cbdr_Mapper.doCleanBidStatus2(rtnData);
                }
            }
        } else {
            rtnList = cbdr_Mapper.cbdi0034_doSearchVendorVO(param);
        }
        
        return rtnList;
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String cbdi0034_doFirstNegotiator(Map<String, String> formData, List<Map<String, Object>> gridDatas) throws Exception {

        // 입력받은 가격점수와 투찰차수가 2차 이상인 경우, 기존의 기술점수를 Update한다.
        for(Map<String, Object> gridData : gridDatas) {
            cbdr_Mapper.doMergePrcScore(gridData);
        }

        // 기술점수 + 입력받은 가격점수 = 협산점수를 기준으로 순위를 정하여 BDVO.BID_RANK에 Update한다.
        List<Map<String, Object>> rankList = cbdr_Mapper.getRankList(formData);
        for(Map<String, Object> rankData : rankList) {
            cbdr_Mapper.setBidRank(rankData);
        }

        return msg.getMessageByScreenId("CBDI0034", "T022");
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String cbdi0034_doApproval(Map<String, String> formData) throws Exception {

        UserInfo userInfo = UserInfoManager.getUserInfo();

        String appDocNum = (formData.get("NEGO_APP_DOC_NUM") == null ? "" : String.valueOf(formData.get("NEGO_APP_DOC_NUM")));
        String appDocCnt = (formData.get("NEGO_APP_DOC_CNT") == null ? "" : String.valueOf(formData.get("NEGO_APP_DOC_CNT")));
        String oriSignStatus = (formData.get("NEGO_SIGN_STATUS") == null ? "" : String.valueOf(formData.get("NEGO_SIGN_STATUS")));
        if (appDocNum.equals("")) {
            // 채번로직 변경. Parameter [화면에서 전달 받은 COMPANY_CD (없는 경우, ses.manageCd 또는 ses.companyCd), DOC_TYPE ]
        	formData.put("NEGO_APP_DOC_NUM", docNumService.getDocNumber(String.valueOf(formData.get("BUYER_CD")), "APPDOC"));
        }
        if (EverString.isEmpty(appDocCnt) || appDocCnt.equals("0")) {
            appDocCnt = "1";
        }
        else {
            // 이전의 SIGN_STATUS가 반려(R), 결재취소(C)이면 결재차수 = 결재차수 + 1
            if (oriSignStatus.equals("R") || oriSignStatus.equals("C")) {
                appDocCnt = String.valueOf(Integer.parseInt(appDocCnt) + 1);
            }
        }

        Map<String, String> approvalHeader = new ObjectMapper().readValue(formData.get("approvalFormData"), Map.class);
        formData.put("APP_SUBJECT", approvalHeader.get("SUBJECT")); // 제목
        formData.put("APP_DOC_CONTENTS", approvalHeader.get("DOC_CONTENTS")); // 상신의견
        formData.put("APP_DOC_NUM", formData.get("NEGO_APP_DOC_NUM"));
        formData.put("APP_DOC_CNT", appDocCnt);
        formData.put("SIGN_STATUS", "P");
        formData.put("DOC_TYPE", "NEGORLT");

        // 결재상신 공통모듈 호출
        approvalService.doApprovalProcess(formData, formData.get("approvalFormData"), formData.get("approvalGridData"));

        // 결재상신 후, STOCBDHD에 입찰결과 결재문서번호, 입찰결과 결재문서차수를 Update한다.
        formData.put("NEGO_APP_DOC_CNT", appDocCnt);
        formData.put("NEGO_SIGN_STATUS", "P");
        cbdr_Mapper.cbdi0034_doUpdateAppNum(formData);

        return msg.getMessage("0023");
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String cbdi0034_doSuccessfulBid(Map<String, String> formData, List<Map<String, Object>> gridDatas) throws Exception {

        // 진행상태를 체크한다.
        Map<String, Object> sParam = new HashMap<String, Object>();
        sParam.putAll(formData);
        
        String oriBidStatus = cbdr_Mapper.getBidStatus(sParam);
        if( !EverString.nullToEmptyString(oriBidStatus).equals("700") &&
        	!EverString.nullToEmptyString(oriBidStatus).equals("800") && !EverString.nullToEmptyString(oriBidStatus).equals("900")) {
            throw new Exception(msg.getMessageByScreenId("CBDR0033", "T003"));
        }

        // 해당 입찰공고의 진행상태를 '낙찰'로 변경한다.
        formData.put("BID_STATUS", "2500");
        cbdr_Mapper.setBidStatus(formData);

        String settlevendorCd = "";
        String settleVoteCnt = "";

        for(Map<String, Object> gridData : gridDatas) {

            String gridBidStatus = String.valueOf(gridData.get("BID_STATUS"));
            String bidStatus = ((gridBidStatus.equals("300") || gridBidStatus.equals("400") || gridBidStatus.equals("600")) ? gridBidStatus : "700"); // 300 : 낙찰, 400 : 유찰, 700 : 협상종료, 600 : 부적합
            if(gridBidStatus.equals("300")) {
                settlevendorCd = String.valueOf(gridData.get("VENDOR_CD"));
                settleVoteCnt  = String.valueOf(gridData.get("VOTE_CNT"));
                gridData.put("ADJ_PRC_STATUS", "100"); // 대상
            }
            else {
                gridData.put("ADJ_PRC_STATUS", "");
            }

            gridData.put("BID_STATUS", bidStatus);
            gridData.put("BUYER_CD", formData.get("BUYER_CD"));
            gridData.put("BID_NUM",  formData.get("BID_NUM"));
            gridData.put("BID_CNT",  formData.get("BID_CNT"));

            // 해당 협력업체의 최종결과[STOCBDVO.BID_STATUS]를 '낙찰(300)' 또는 '협상종료(700)'로 Update한다.
            cbdr_Mapper.doSuccessfulOrFailBid(gridData);

            // 입찰 종합평가 결과 정보를 Update한다.
            cbdr_Mapper.doUpdateScore(gridData);
        }

        // 구매의뢰의 진행상태를 '업체선정완료'로 변경한다.
        List<Map<String, Object>> prList = cbdr_Mapper.getPrList(formData);
        for(Map<String, Object> prData : prList) {
            prData.put("PROGRESS_CD", "2500");
            cbdr_Mapper.setPrProgressCd(prData);
        }

        // 협력업체별 재입찰을 한 경우, 이전 차수의 STOCBDVO.BID_STATUS(200)을 NULL로 Update한다.
        Map<String, Object> nullData = new HashMap<String, Object>();
        nullData.put("BUYER_CD",  formData.get("BUYER_CD"));
        nullData.put("BID_NUM",   formData.get("BID_NUM"));
        nullData.put("BID_CNT",   formData.get("BID_CNT"));
        nullData.put("VOTE_CNT",  settleVoteCnt);
        nullData.put("VENDOR_CD", settlevendorCd);
        cbdr_Mapper.doCleanBidStatus(nullData);

        // 품의작성 대기정보에 낙찰정보를 Insert한다. [STOCCNHB]
        Map<String, String> cnParam = new HashMap<String, String>();
        cnParam.put("BUYER_CD", formData.get("BUYER_CD"));
        cnParam.put("BID_NUM",  formData.get("BID_NUM"));
        cnParam.put("BID_CNT",  formData.get("BID_CNT"));

        List<Map<String, Object>> cnWtList = cbdr_Mapper.getCnWtList(cnParam);
        for(Map<String, Object> cnWtData : cnWtList) {
            // 채번로직 변경. Parameter [화면에서 전달 받은 COMPANY_CD (없는 경우, ses.manageCd 또는 ses.companyCd), DOC_TYPE ]
            String execWtNum = docNumService.getDocNumber(formData.get("BUYER_CD"), "EXEW");
            cnWtData.put("EXEC_WT_NUM", execWtNum);
            cbdr_Mapper.doInsertCNHB(cnWtData);
        }
        
        // 2020.09.24 추가
        // 메일, SMS 발송.
        formData.put("VOTE_CNT", settleVoteCnt);
        sendMailSms(formData);
        
        return msg.getMessageByScreenId("CBDI0034", "T017");
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String cbdi0034_doFailBid(Map<String, String> formData, List<Map<String, Object>> gridDatas) throws Exception {

        // 진행상태를 체크한다.
        Map<String, Object> sParam = new HashMap<String, Object>();
        sParam.putAll(formData);
        
        String oriBidStatus = cbdr_Mapper.getBidStatus(sParam);
        if( !EverString.nullToEmptyString(oriBidStatus).equals("700") &&
        	!EverString.nullToEmptyString(oriBidStatus).equals("800") && !EverString.nullToEmptyString(oriBidStatus).equals("900")) {
            throw new Exception(msg.getMessageByScreenId("CBDI0034", "T010"));
        }
        
        for(Map<String, Object> gridData : gridDatas) {

            gridData.put("BUYER_CD", formData.get("BUYER_CD"));
            gridData.put("BID_NUM", formData.get("BID_NUM"));
            gridData.put("BID_CNT", formData.get("BID_CNT"));

            // 해당 협력업체의 최종결과[STOCBDVO.BID_STATUS]를 '유찰(400)'으로 Update한다.
            cbdr_Mapper.doSuccessfulOrFailBid(gridData);

            // 종합낙찰제에서 협력업체별로 재입찰을 진행한 경우, 이전 차수의 BID_STATUS가 '200'이므로
            // NULL로 Update한다.
            cbdr_Mapper.doCleanBidStatus(gridData);

        }
        // 해당 투찰차수의 모든 협력업체에 대한 최종결과가 유찰, 부적합이어서 최종적으로
        // 더 이상 낙찰할 수 없는 상태가 되면 해당 입찰공고의 상태를 '유찰'로 변경한다.
        String failVendorCnt = "";

        // 협력업체별로 별도의 재입찰을 돌리는지 조회한다.
        List<Map<String, String>> checkList = cbdr_Mapper.cbdi0034_doSearchIndividualFlag(formData);
        String individualFlag = "N";
        String maxVoteCnt = "";
        for(int i = 0; i < checkList.size(); i++) {
        	Map<String, String> checkData = checkList.get(i);
            maxVoteCnt = String.valueOf(checkData.get("VENDOR_MAX_VOTE_CNT"));
            if(StringUtils.isNotEmpty(maxVoteCnt) && Integer.parseInt(maxVoteCnt) > 1) {
            	individualFlag = "Y"; // 별도의 재입찰 진행 중...
            	break;
            }
            
            /**
             * 2021.10.07 : 1개 이상의 협력사가 개별 입찰할 경우
            if(i == 0) {
                maxVoteCnt = String.valueOf(checkData.get("VENDOR_MAX_VOTE_CNT"));
            } else {
                if(!maxVoteCnt.equals(String.valueOf(checkData.get("VENDOR_MAX_VOTE_CNT")))) {
                    individualFlag = "Y"; // 별도의 재입찰 진행 중...
                }
            }*/
        }

        if(individualFlag.equals("Y")) {
            int vendorIdx = 0;
            List<Map<String, String>> vendorList = new ArrayList<Map<String, String>>();
            for(int i = 0; i < checkList.size(); i++) {
                vendorList.add(vendorIdx, checkList.get(i));
                vendorIdx++;
            }

            Map<String,Object> eParam = new HashMap<String,Object>();
            eParam.putAll(formData);
            eParam.put("vendorList", vendorList);
            failVendorCnt = cbdr_Mapper.getFailVendorCntNE(eParam);
        } else {
            failVendorCnt = cbdr_Mapper.getFailVendorCnt(sParam);
        }

        if(failVendorCnt.equals("0")) {
            // 해당 입찰공고의 진행상태를 '유찰'로 변경한다.
            formData.put("BID_STATUS", "1300");
            cbdr_Mapper.setBidStatus(formData);

            // 구매의뢰의 진행상태를 '유찰'로 변경한다.
            List<Map<String, Object>> prList = cbdr_Mapper.getPrList(formData);
            for(Map<String, Object> prData : prList) {
                prData.put("PROGRESS_CD", "1300");
                cbdr_Mapper.setPrProgressCd(prData);
            }
        }
        
        return msg.getMessageByScreenId("CBDI0034", "T011");
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String cbdi0034_callBackIndividual(List<Map<String, Object>> gridDatas) throws Exception {

        for(Map<String, Object> gridData : gridDatas) {
            // 입력받은 가격점수와 투찰차수가 2차 이상인 경우, 기존의 기술점수를 Update한다.
            cbdr_Mapper.doMergePrcScore(gridData);
        }
        return msg.getMessageByScreenId("CBDI0034", "T022");
    }

    /**
     * 화면명 : 기술평가결과 등록
     * 처리내용 : 협상에 의한 계약 입찰에서 기술평가구분이 “평가결과등록” 인 경우 평가 결과를 등록하는 화면
     * 경로 : 고객사 > 구매관리 > 입찰관리 > 입찰진행 > 기술평가결과 등록
     */
    public List<Map<String, Object>> cbdi0035_doSearch(Map<String, String> param) throws Exception {
        return cbdr_Mapper.cbdi0035_doSearch(param);
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String cbdi0035_doConfirm(Map<String, String> formData, List<Map<String, Object>> gridDatas) throws Exception {

        // 진행상태를 체크한다.
        String closePossibleFlag = cbdr_Mapper.cbdi0035_getEvPossibleFlag(formData);
        if(!EverString.nullToEmptyString(closePossibleFlag).equals("Y")) {
            throw new Exception(msg.getMessageByScreenId("CBDI0035", "T003"));
        }

        for(Map<String, Object> gridData : gridDatas) {
            cbdr_Mapper.cbdi0035_doMergeSP(gridData);
        }

        String contType2 = formData.get("CONT_TYPE2");

    	if ("NE".equals(contType2)) {
    		formData.put("BID_STATUS", "2368");  // 진행상태를 '(기술평가)결과등록'에서 '개찰대기'으로 변경한다.
            cbdr_Mapper.setBidStatus(formData);
    	}

        return msg.getMessageByScreenId("CBDI0035", "T005");
    }

    /**
     * 화면명 : 적격심사결과 등록
     * 처리내용 : 적격심사 결과를 등록하는 화면
     * 경로 : 고객사 > 구매관리 > 입찰관리 > 입찰진행 > 입찰신청자조서 및 입찰비교표 > 적격심사결과 등록
     */
    public Map<String, String> cbdri036_doSearchHD(Map<String, String> param) throws Exception {
        return cbdr_Mapper.cbdri036_doSearchHD(param);
    }

    public List<Map<String, Object>> cbdi0036_doSearchVendorVO(Map<String, String> param) throws Exception {

        List<Map<String, Object>> rtnList = null;

        // 협력업체별로 별도의 재입찰을 돌리는지 조회한다.
        List<Map<String, String>> checkList = cbdr_Mapper.cbdi0034_doSearchIndividualFlag(param);
        String individualFlag = "N";
        String maxVoteCnt = "";
        for(int i = 0; i < checkList.size(); i++) {
        	Map<String, String> checkData = checkList.get(i);
            maxVoteCnt = String.valueOf(checkData.get("VENDOR_MAX_VOTE_CNT"));
            if(StringUtils.isNotEmpty(maxVoteCnt) && Integer.parseInt(maxVoteCnt) > 1) {
            	individualFlag = "Y"; // 별도의 재입찰 진행 중...
            	break;
            }
            
            /**
             * 2021.10.07 : 1개 이상의 협력사가 개별 입찰할 경우
            if(i == 0) {
                maxVoteCnt = String.valueOf(checkData.get("VENDOR_MAX_VOTE_CNT"));
            } else {
                if(!maxVoteCnt.equals(String.valueOf(checkData.get("VENDOR_MAX_VOTE_CNT")))) {
                    individualFlag = "Y"; // 별도의 재입찰 진행 중...
                }
            }*/
        }

        if(individualFlag.equals("Y")) {
            int vendorIdx = 0;
            List<Map<String, String>> vendorList = new ArrayList<Map<String, String>>();
            for(int i = 0; i < checkList.size(); i++) {
                vendorList.add(vendorIdx, checkList.get(i));
                vendorIdx++;
            }

            Map<String, Object> sParam = new HashMap<String,Object>();
            sParam.putAll(param);
            sParam.put("vendorList", vendorList);
            rtnList = cbdr_Mapper.cbdi0036_doSearchVendorVoIndividual(sParam);

            // 협상중인 업체가 투찰한 금액이 선정기준에 벗어난 경우, 기존의 협상중(200)인 상태를 null로 변경한다.
            for(int j = 0; j < rtnList.size(); j++) {
                Map<String, Object> rtnData = rtnList.get(j);
                if(EverString.nullToEmptyString(rtnData.get("BID_STATUS")).equals("600")) {
                    cbdr_Mapper.doCleanBidStatus2(rtnData);
                }
            }
        } else {
            rtnList = cbdr_Mapper.cbdi0036_doSearchVendorVO(param);
        }

        return rtnList;
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String cbdi0036_doSuccessfulBid(Map<String, String> formData, List<Map<String, Object>> gridDatas) throws Exception {

        // 진행상태를 체크한다.
        Map<String, Object> sParam = new HashMap<String, Object>();
        sParam.putAll(formData);
        
        String oriBidStatus = cbdr_Mapper.getBidStatus(sParam);
        if( !EverString.nullToEmptyString(oriBidStatus).equals("700") &&
        	!EverString.nullToEmptyString(oriBidStatus).equals("800") && !EverString.nullToEmptyString(oriBidStatus).equals("900")) {
            throw new Exception(msg.getMessageByScreenId("CBDR0033", "T003"));
        }

        // 해당 입찰공고의 진행상태를 '낙찰'로 변경한다.
        formData.put("BID_STATUS", "2500");
        cbdr_Mapper.setBidStatus(formData);

        String settlevendorCd = "";
        String settleVoteCnt = "";

        for(Map<String, Object> gridData : gridDatas) {

            String gridBidStatus = String.valueOf(gridData.get("BID_STATUS"));
            String bidStatus = ((gridBidStatus.equals("300") || gridBidStatus.equals("400") || gridBidStatus.equals("600")) ? gridBidStatus : "700"); // 300 : 적격, 400 : 부적격, 700 : 심사종료, 600 : 부적합

            if(gridBidStatus.equals("300")) {
                settlevendorCd = String.valueOf(gridData.get("VENDOR_CD"));
                settleVoteCnt = String.valueOf(gridData.get("VOTE_CNT"));
                gridData.put("ADJ_PRC_STATUS", "100"); // 대상
            } else {
                gridData.put("ADJ_PRC_STATUS", "");
            }

            gridData.put("BID_STATUS", bidStatus);
            gridData.put("BUYER_CD", formData.get("BUYER_CD"));
            gridData.put("BID_NUM", formData.get("BID_NUM"));
            gridData.put("BID_CNT", formData.get("BID_CNT"));

            // 해당 협력업체의 최종결과[STOCBDVO.BID_STATUS]를 '적격(300)' 또는 '심사종료(700)'로 Update한다.
            cbdr_Mapper.doSuccessfulOrFailBid(gridData);

            // 입찰 종합평가 결과 정보를 Update한다.
            cbdr_Mapper.doUpdateScore(gridData);
        }

        // 구매의뢰의 진행상태를 '업체선정완료'로 변경한다.
        List<Map<String, Object>> prList = cbdr_Mapper.getPrList(formData);
        for(Map<String, Object> prData : prList) {
            prData.put("PROGRESS_CD", "2500");
            cbdr_Mapper.setPrProgressCd(prData);
        }

        // 협력업체별 재입찰을 한 경우, 이전 차수의 STOCBDVO.BID_STATUS(200)을 NULL로 Update한다.
        Map<String, Object> nullData = new HashMap<String, Object>();
        nullData.put("BUYER_CD", formData.get("BUYER_CD"));
        nullData.put("BID_NUM", formData.get("BID_NUM"));
        nullData.put("BID_CNT", formData.get("BID_CNT"));
        nullData.put("VOTE_CNT", settleVoteCnt);
        nullData.put("VENDOR_CD", settlevendorCd);
        cbdr_Mapper.doCleanBidStatus(nullData);

        // 품의작성 대기정보에 낙찰정보를 Insert한다. [STOCCNHB]
        Map<String, String> cnParam = new HashMap<String, String>();
        cnParam.put("BUYER_CD", formData.get("BUYER_CD"));
        cnParam.put("BID_NUM", formData.get("BID_NUM"));
        cnParam.put("BID_CNT", formData.get("BID_CNT"));

        List<Map<String, Object>> cnWtList = cbdr_Mapper.getCnWtList(cnParam);
        for(Map<String, Object> cnWtData : cnWtList) {
            // 채번로직 변경. Parameter [화면에서 전달 받은 COMPANY_CD (없는 경우, ses.manageCd 또는 ses.companyCd), DOC_TYPE ]
            String execWtNum = docNumService.getDocNumber(formData.get("BUYER_CD"), "EXEW");
            cnWtData.put("EXEC_WT_NUM", execWtNum);
            cbdr_Mapper.doInsertCNHB(cnWtData);
        }

        return msg.getMessageByScreenId("CBDI0036", "T017");
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String cbdi0036_doFailBid(Map<String, String> formData, List<Map<String, Object>> gridDatas) throws Exception {

        // 진행상태를 체크한다.
        Map<String, Object> sParam = new HashMap<String, Object>();
        sParam.putAll(formData);
        
        String oriBidStatus = cbdr_Mapper.getBidStatus(sParam);
        if( !EverString.nullToEmptyString(oriBidStatus).equals("700") && 
        	!EverString.nullToEmptyString(oriBidStatus).equals("800") && !EverString.nullToEmptyString(oriBidStatus).equals("900")) {
            throw new Exception(msg.getMessageByScreenId("CBDI0036", "T010"));
        }

        for(Map<String, Object> gridData : gridDatas) {

            gridData.put("BUYER_CD", formData.get("BUYER_CD"));
            gridData.put("BID_NUM", formData.get("BID_NUM"));
            gridData.put("BID_CNT", formData.get("BID_CNT"));
            gridData.put("VOTE_CNT", formData.get("VOTE_CNT"));

            // 해당 협력업체의 최종결과[STOCBDVO.BID_STATUS]를 '부적격(400)'으로 Update한다.
            cbdr_Mapper.doSuccessfulOrFailBid(gridData);
            // 입찰 종합평가 결과 정보를 Update한다.
            cbdr_Mapper.doUpdateScore(gridData);
            // 종합낙찰제에서 협력업체별로 재입찰을 진행한 경우, 이전 차수의 BID_STATUS가 '200'이므로
            // NULL로 Update한다.
            cbdr_Mapper.doCleanBidStatus(gridData);
        }

        // 해당 투찰차수의 모든 협력업체에 대한 최종결과가 부적격, 부적합이어서 최종적으로
        // 더 이상 낙찰할 수 없는 상태가 되면 해당 입찰공고의 상태를 '유찰'로 변경한다.
        String failVendorCnt = "";

        // 협력업체별로 별도의 재입찰을 돌리는지 조회한다.
        List<Map<String, String>> checkList = cbdr_Mapper.cbdi0034_doSearchIndividualFlag(formData);
        String individualFlag = "N";
        String maxVoteCnt = "";
        for(int i = 0; i < checkList.size(); i++) {
        	Map<String, String> checkData = checkList.get(i);
            maxVoteCnt = String.valueOf(checkData.get("VENDOR_MAX_VOTE_CNT"));
            if(StringUtils.isNotEmpty(maxVoteCnt) && Integer.parseInt(maxVoteCnt) > 1) {
            	individualFlag = "Y"; // 별도의 재입찰 진행 중...
            	break;
            }
            
            /**
             * 2021.10.07 : 1개 이상의 협력사가 개별 입찰할 경우
            if(i == 0) {
                maxVoteCnt = String.valueOf(checkData.get("VENDOR_MAX_VOTE_CNT"));
            } else {
                if(!maxVoteCnt.equals(String.valueOf(checkData.get("VENDOR_MAX_VOTE_CNT")))) {
                    individualFlag = "Y"; // 별도의 재입찰 진행 중...
                }
            }*/
        }

        if(individualFlag.equals("Y")) {
            int vendorIdx = 0;
            List<Map<String, String>> vendorList = new ArrayList<Map<String, String>>();
            for(int i = 0; i < checkList.size(); i++) {
                vendorList.add(vendorIdx, checkList.get(i));
                vendorIdx++;
            }

            Map<String,Object> eParam = new HashMap<String,Object>();
            eParam.putAll(formData);
            eParam.put("vendorList", vendorList);
            failVendorCnt = cbdr_Mapper.getFailVendorCntNE(eParam);
        } else {
            failVendorCnt = cbdr_Mapper.getFailVendorCnt(sParam);
        }

        if(failVendorCnt.equals("0")) {
            // 해당 입찰공고의 진행상태를 '유찰'로 변경한다.
            formData.put("BID_STATUS", "1300");
            cbdr_Mapper.setBidStatus(formData);

            // 구매의뢰의 진행상태를 '유찰'로 변경한다.
            List<Map<String, Object>> prList = cbdr_Mapper.getPrList(formData);
            for(Map<String, Object> prData : prList) {
                prData.put("PROGRESS_CD", "1300");
                cbdr_Mapper.setPrProgressCd(prData);
            }
        }
        
        return msg.getMessageByScreenId("CBDI0036", "T011");
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String cbdi0036_callBackIndividual(List<Map<String, Object>> gridDatas) throws Exception {

        for(Map<String, Object> gridData : gridDatas) {
            // 입력받은 심사점수와 가격점수를 Update한다.
            cbdr_Mapper.doMergePrcScore(gridData);
        }
        return msg.getMessageByScreenId("CBDI0036", "T021");
    }
    
    // 2021.03.23 추가
    // 기술협상첨부파일, 기술협상비고, 추가첨부파일, 추가비고 등록
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public Map<String, String> cbdi0037_doSave(Map<String, String> param, List<Map<String, Object>> gridDatas) throws Exception {
    	
    	cbdr_Mapper.doUpdateNegoHeader(param);
        for(Map<String, Object> gridData : gridDatas) {
            cbdr_Mapper.doUpdateNegoInfo(gridData);
        }
        param.put("message", msg.getMessage("0001"));
        return param;
    }
    
    /**
     * 화면명 : 입찰결과
     * 처리내용 : 개찰 이후의 입찰공고 목록이 조회된다.
     * 경로 : 고객사 > 구매관리 > 입찰관리 > 입찰결과
     */
    public List<Map<String, Object>> cbdr0040_doSearch(Map<String, String> param) throws Exception {
    	
    	Map<String, Object> formObj = new HashMap<String, Object>(param);
    	
    	formObj.put("CONT_TYPE_LIST", Arrays.asList(param.get("CONT_TYPE").split(",")));
        return cbdr_Mapper.cbdr0040_doSearch(formObj);
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String cbdr0040_doUserChange(Map<String, String> formData, List<Map<String, Object>> gridDatas) throws Exception {

        for(Map<String, Object> gridData : gridDatas) {
            gridData.put("CHANGE_TYPE", "B");
            gridData.put("CHANGE_USER_ID", formData.get("CHANGE_USER_ID"));
            cbdr_Mapper.cbdr0030_doUserChange(gridData);
        }
        return msg.getMessageByScreenId("CBDR0040", "005");
    }
    
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String cbdr0040_doApproval(Map<String, String> formData, List<Map<String, Object>> gridDatas) throws Exception {

        UserInfo userInfo = UserInfoManager.getUserInfo();

        for(Map<String, Object> gridData : gridDatas) {

            String appDocNum = (gridData.get("RLT_APP_DOC_NUM") == null ? "" : String.valueOf(gridData.get("RLT_APP_DOC_NUM")));
            String appDocCnt = (gridData.get("RLT_APP_DOC_CNT") == null ? "" : String.valueOf(gridData.get("RLT_APP_DOC_CNT")));
            String oriSignStatus = (gridData.get("RLT_SIGN_STATUS") == null ? "" : String.valueOf(gridData.get("RLT_SIGN_STATUS")));
            if (appDocNum.equals("")) {
                // 채번로직 변경. Parameter [화면에서 전달 받은 COMPANY_CD (없는 경우, ses.manageCd 또는 ses.companyCd), DOC_TYPE ]
                gridData.put("RLT_APP_DOC_NUM", docNumService.getDocNumber(String.valueOf(gridData.get("BUYER_CD")), "APPDOC"));
            }
            if (EverString.isEmpty(appDocCnt) || appDocCnt.equals("0")) {
                appDocCnt = "1";
            }
            else {
                // 이전의 SIGN_STATUS가 반려(R), 결재취소(C)이면 결재차수 = 결재차수 + 1
                if (oriSignStatus.equals("R") || oriSignStatus.equals("C")) {
                    appDocCnt = String.valueOf(Integer.parseInt(appDocCnt) + 1);
                }
            }

            Map<String, String> approvalHeader = new ObjectMapper().readValue(formData.get("approvalFormData"), Map.class);
            formData.put("BUYER_CD", String.valueOf(gridData.get("BUYER_CD")));
            formData.put("APP_SUBJECT", approvalHeader.get("SUBJECT")); // 제목
            formData.put("APP_DOC_CONTENTS", approvalHeader.get("DOC_CONTENTS")); // 상신의견
            formData.put("APP_DOC_NUM", String.valueOf(gridData.get("RLT_APP_DOC_NUM")));
            formData.put("APP_DOC_CNT", appDocCnt);
            formData.put("SIGN_STATUS", "P");
            formData.put("DOC_TYPE", "BIDRLT");

            // 결재상신 공통모듈 호출
            approvalService.doApprovalProcess(formData, formData.get("approvalFormData"), formData.get("approvalGridData"));

            // 결재상신 후, STOCBDHD에 입찰결과 결재문서번호, 입찰결과 결재문서차수를 Update한다.
            gridData.put("RLT_APP_DOC_CNT", appDocCnt);
            gridData.put("RLT_SIGN_STATUS", "P");
            cbdr_Mapper.cbdr0040_doUpdateAppNum(gridData);
        }
        return msg.getMessage("0023");
    }
    
    /**
     * 입찰의 협력사 낙찰시 투찰을 진행한 협력사 담당자에게 메일 및 SMS 발송
     * @param param
     * @throws Exception
     */
    public void sendMailSms(Map<String, String> param) throws Exception {
    	
    	// 전자구매시스템 URL
        String linkUrl = PropertiesManager.getString("eversrm.urls.maintain.real");
        
        // 2021.06.29 : 낙찰시 입찰진행 고객사에 협력사 수만큼 SMS 수수료 부과
        // 대상이 되는 협력사코드, 투찰담당자 가져오기
        List<Map<String, String>> mailTargetList = cbdr_Mapper.getBidMailTargetList(param);
        for (Map<String, String> mailTargetData : mailTargetList) {

            if( !EverString.nullToEmptyString(mailTargetData.get("RECV_USER_ID")).equals("") ) {
            	String subject = "[전자구매시스템] 고객사 [" + mailTargetData.get("PR_BUYER_NM") + "]에서 실시한 입찰 [" + mailTargetData.get("ANN_ITEM") + "]의 결과가 발표되었습니다";
            	
                Map<String, String> mailMap = new HashMap<String, String>();
                mailMap.put("SUBJECT", subject);

                StringBuffer content = new StringBuffer(255);
                content.append("<BR> 안녕하세요.																							");
                content.append("<BR> [" + mailTargetData.get("VENDOR_NM") + "] [" + mailTargetData.get("RECV_USER_NM") + "]님.			");
                content.append("<BR>																									");
                content.append("<BR> 아래와 같이 고객사에서 실시한 입찰 결과가 발표 되었습니다.															");
                content.append("<BR> 고객사 : [" + mailTargetData.get("PR_BUYER_NM") + "]													");
                content.append("<BR> 입찰명 : [" + mailTargetData.get("ANN_ITEM") + "]														");
                content.append("<BR> 공고기간 : [" + mailTargetData.get("ANN_FROM_DATE") + " ~ " + mailTargetData.get("ANN_TO_DATE") + "] 	");
                content.append("<BR> 입찰일 : [" + mailTargetData.get("BID_END_DATE") + "]													");
                content.append("<BR> 계약방법 : [" + mailTargetData.get("CONT_TYPE1_LOC") + "]												");
                content.append("<BR> 낙찰자결정방법 : [" + mailTargetData.get("CONT_TYPE2_LOC") + "]											");
                content.append("<BR> 입찰회차 : [" + String.valueOf(mailTargetData.get("VOTE_CNT")) + "회차]								");
                content.append("<BR> 입찰결과 : [" + mailTargetData.get("SETTLE_FLAG_LOC") + "]											");
                content.append("<BR> 낙찰자 : [" + mailTargetData.get("SETTLE_VENDOR_NM") + "]												");
                content.append("<BR>																									");
                content.append("<BR> 전자구매시스템에 <a href=\"" + linkUrl + "\" target=\"newP\">로그인</a> 하시어, 세부내용을 확인 해주십시오.			");
                content.append("<BR>																									");
                content.append("<BR> 감사합니다.																							");
                
                mailMap.put("CONTENTS", content.toString());
                mailMap.put("REF_MODULE_CD", "MBID02");
                mailMap.put("REF_NUM", param.get("EXEC_NUM"));
                mailMap.put("RECV_USER_ID", mailTargetData.get("RECV_USER_ID"));
                everMailservice.SendMail(mailMap);

                Map<String, String> smsMap = new HashMap<String, String>();
                smsMap.put("CONTENTS", subject);
                smsMap.put("REF_MODULE_CD", "SBID02");
                smsMap.put("RECV_USER_ID", mailTargetData.get("RECV_USER_ID"));
                
                // 2021.06.29 : 입찰 낙찰시 SMS 수수료 부과하기
                smsMap.put("CORP_NO", mailTargetData.get("CORP_NO"));			// 고객사 사업자번호
        		smsMap.put("BRC", mailTargetData.get("BRC"));					// 고객사 부서
        		smsMap.put("EPRO_PS_DSC", "1");									// 1  : 구매
                smsMap.put("EPRO_RATE_DSC", "01");								// 01 : 최초
        		smsMap.put("APLY_DT", mailTargetData.get("APLY_DT"));			// 발생일 YYYYMMDD
        		smsMap.put("USER_ID", mailTargetData.get("USER_ID"));			// 고객사 보내는사람 ID
        		smsMap.put("CONT_TBL_ID", "STOCBDVO");							// 검증 테이블
        		smsMap.put("CONT_TBL_PK", mailTargetData.get("CONT_TBL_PK")); 	// 검증 조건(협력사별 입찰번호)
        		smsMap.put("tmp", mailTargetData.get("CONT_TBL_PK"));			// myBatis 버그 해결을 위한 무의미한, 유니크한 값.
        		smsMap.put("payFlag", "Y");										// SMS 과금여부
        		
                everSmsService.sendSmsNhe(smsMap);
            }
        }
    }

}