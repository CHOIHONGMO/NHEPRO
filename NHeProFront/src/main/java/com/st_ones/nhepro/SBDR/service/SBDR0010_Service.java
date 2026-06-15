package com.st_ones.nhepro.SBDR.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.common.mail.service.EverMailService;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.util.clazz.EverMath;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.everf.serverside.util.EverString;
import com.st_ones.nhepro.SBDR.SBDR0010_Mapper;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2014 ST-Ones CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : SBDR0010_Service.java
 * @date 2020. 4. 29.
 * @version 1.0
 */

@Service(value = "sbdr0010_Service")
public class SBDR0010_Service extends BaseService {

    @Autowired private MessageService msg;
    @Autowired private SBDR0010_Mapper sbdr_Mapper;
    @Autowired private EverMailService everMailService;

    /**
     * 화면명 : 입찰참가신청
     * 처리내용 : 입찰공고 및 입찰참가신청 중인 입찰건의 목록이 조회하는 화면.
     * 경로 : 협력업체 > 구매관리 > 입찰관리 > 입찰참가신청
     */
    public List<Map<String, Object>> sbdr0010_doSearch(Map<String, String> param) throws Exception {
        return sbdr_Mapper.sbdr0010_doSearch(param);
    }
    
    /**
     * 2020.12.02 기능 추가
     * 입찰참가신청 체크로직을 Server에서 체크하도록 변경
     */
    public Map<String, String> sbdr0010_doCheckProgressCd(Map<String, String> param) throws Exception {
    	
    	Map<String, String> statusMap = sbdr_Mapper.sbdr0010_doCheckProgressCd(param);
        
        String rtnCode = "";
        String rtnMsg  = "";
        String bidStatus = statusMap.get("ORI_BID_STATUS");
        String possibleFlag = statusMap.get("APPLY_POSSIBLE_FLAG");
        String appInfo = statusMap.get("APP_INFO");
        
        // 2303 : 취소공고작성중, 2330 : 취소공고확정
        if( "2303".equals(bidStatus) || "2330".equals(bidStatus) ) {
        	rtnCode = "SBDR0010_001";
        	rtnMsg  = msg.getMessageByScreenId("SBDR0010", "003");
        }
        else if( "N".equals(possibleFlag) ) { 	// possibleFlag : 입찰신청시간 가능여부
        	rtnCode = "SBDR0010_001";
        	rtnMsg  = msg.getMessageByScreenId("SBDR0010", "001");
        }
        // 2021.06.29 이미 제출한 경우 중복 제출 가능
        //else if( "Y".equals(appInfo) ) { 		// 이미 제출한 경우
        //	rtnCode = "SBDR0010_002";
        //	rtnMsg  = msg.getMessageByScreenId("SBDR0010", "002");
        //}
        
        Map<String, String> rtnMap = new HashMap<>();
        rtnMap.put("rtnCode", rtnCode);
        rtnMap.put("rtnMsg", rtnMsg);
        
        return rtnMap;
    }

    /**
     * 화면명 : 참가신청등록
     * 처리내용 : 협력업체에서 참가신청서를 제출하는 화면 (제출시 공인인증서를 이용하여 전자서명을 진행해야 한다)
     * 경로 : 협력업체 > 구매관리 > 입찰관리 > 입찰참가신청 > 참가신청등록
     */
    public Map<String, String> sbdi0013_doSearch(Map<String, String> param) throws Exception {
        return sbdr_Mapper.sbdi0013_doSearch(param);
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String sbdi0013_doSubmit(Map<String, String> formData) throws Exception {
    	
        Map<String, String> possibleMap = sbdr_Mapper.sbdi0013_getPossibleFlag(formData);
        if (EverString.nullToEmptyString(possibleMap.get("APPLY_POSSIBLE_FLAG")).equals("N")) {
            throw new Exception(msg.getMessageByScreenId("SBDI0013", "004"));
        }
        
        // 2021.06.29 이미 제출한 경우 중복 제출 가능
        //if (!EverString.nullToEmptyString(possibleMap.get("APP_DATE")).equals("")) {
        //	throw new Exception(msg.getMessageByScreenId("SBDI0013", "005"));
        //}
        
        sbdr_Mapper.sbdi0013_doSubmit(formData);
        return msg.getMessageByScreenId("SBDI0013", "006");
    }
    
    /**
     * 2021.10.21 : 입찰신청취소
     * @param formData
     * @return
     * @throws Exception
     */
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String sbdi0013_doCancelReq(Map<String, String> formData) throws Exception {
    	
        Map<String, String> possibleMap = sbdr_Mapper.sbdi0013_getPossibleFlag(formData);
        if (!EverString.nullToEmptyString(possibleMap.get("APPLY_POSSIBLE_FLAG")).equals("Y")) {
            throw new Exception(msg.getMessageByScreenId("SBDI0013", "023"));
        }
        
        // 지명경쟁 : STOCBDAP의 APP_DATE, APP_TIME = NULL ELSE DELETE
        String contType1 = EverString.nullToEmptyString(formData.get("CONT_TYPE1"));
        if ("NC".equals(contType1)) {
            sbdr_Mapper.sbdi0013_doCancelReq(formData);
        } else {
        	sbdr_Mapper.sbdi0013_doDeleteReq(formData);
        }
        
        return msg.getMessageByScreenId("SBDI0013", "024");
    }

    public Map<String, String> sbdr0014_doSearch(Map<String, String> param) throws Exception {
        return sbdr_Mapper.sbdr0014_doSearch(param);
    }

    /**
     * 화면명 : 가격입찰
     * 처리내용 : 입찰서 제출 전부터 개찰 전까지의 입찰 목록이 조회하는 화면.
     * 경로 : 협력업체 > 구매관리 > 입찰관리 > 가격입찰
     */
    public List<Map<String, Object>> sbdr0020_doSearch(Map<String, String> param) throws Exception {
        return sbdr_Mapper.sbdr0020_doSearch(param);
    }

    /**
     * 화면명 : 입찰서제출
     * 처리내용 : 협력업체에서 입찰서를 제출하는 화면. (제출시 공인인증서를 이용하여 전자서명을 진행해야 한다)
     * 경로 : 협력업체 > 구매관리 > 입찰관리 > 가격입찰 > 입찰서제출
     */
    public Map<String, String> sbdi0021_doSearchHD(Map<String, String> param) throws Exception {
        return sbdr_Mapper.sbdi0021_doSearchHD(param);
    }

    public List<Map<String, Object>> sbdi0021_doSearch(Map<String, String> param) throws Exception {
        return sbdr_Mapper.sbdi0021_doSearch(param);
    }
    
    /**
     * 2020.12.02 기능 추가
     * 가격입찰시 체크로직을 Server에서 체크하도록 변경
     */
    public Map<String, String> sbdr0020_doCheckProgressCd(Map<String, String> param) throws Exception {
    	
    	Map<String, String> statusMap = sbdr_Mapper.sbdr0020_doCheckProgressCd(param);
        
        String rtnCode = "";
        String rtnMsg  = "";
        String bidStatus = statusMap.get("BID_STATUS");
        String possibleFlag = statusMap.get("SEND_POSSIBLE_FLAG");
        String sendFlag = statusMap.get("SEND_FLAG");
        
        // 200 : 협상중
        if( !"200".equals(bidStatus) ) {
        	rtnCode = "SBDR0020_001";
        	rtnMsg  = msg.getMessageByScreenId("SBDR0020", "001");
        }
        else if( "N".equals(possibleFlag) ) { 	// possibleFlag : 입찰신청시간 가능여부
        	rtnCode = "SBDR0020_001";
        	rtnMsg  = msg.getMessageByScreenId("SBDR0020", "001");
        }
        else if( "Y".equals(sendFlag) ) { 		// 이미 제출한 경우
        	rtnCode = "SBDR0020_002";
        	rtnMsg  = msg.getMessageByScreenId("SBDR0020", "002");
        }
        
        Map<String, String> rtnMap = new HashMap<>();
        rtnMap.put("rtnCode", rtnCode);
        rtnMap.put("rtnMsg", rtnMsg);
        
        return rtnMap;
    }
    
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String sbdi0021_doSend(Map<String, String> formData, List<Map<String, Object>> gridDatas) throws Exception {

        UserInfo userInfo = UserInfoManager.getUserInfo();
        Map<String, String> rtnMap = new HashMap<String, String>();

        // 예정가격 번호 선택시 최초 4개 번호까지는 중복 선택 불가(입찰서 제출시 Data Check)
        // A 업체가 최초 1, 2를 선택했다면, 2번째로 투찰하는 B 업체는 1, 2를 제외한 나머지 13개 중 2개를 선택해야 한다.
        // 세번째로 투찰하는 업체부터는 자유롭게 선택할 수 있다.
        List<Map<String, Object>> checkList = sbdr_Mapper.getCheckChoiceNum(formData);
        if(checkList.size() == 1) {
            Map<String, Object> checkMap = checkList.get(0);
            String sameFlag1 = EverString.nullToEmptyString(checkMap.get("SAME_FLAG1"));
            String sameFlag2 = EverString.nullToEmptyString(checkMap.get("SAME_FLAG2"));
            if (sameFlag1.equals("Y") || sameFlag2.equals("Y")) {
                String choiceEstmNum1 = String.valueOf(checkMap.get("CHOICE_ESTM_NUM1"));
                String choiceEstmNum2 = String.valueOf(checkMap.get("CHOICE_ESTM_NUM2"));
                String exceptionMsg = "";
                if (sameFlag1.equals("Y") && sameFlag2.equals("Y")) {
                    exceptionMsg = "'" + choiceEstmNum1 + "', '" + choiceEstmNum2 + "'";
                } else if (sameFlag1.equals("Y")) {
                    exceptionMsg = "'" + choiceEstmNum1 + "'";
                } else if (sameFlag2.equals("Y")) {
                    exceptionMsg = "'" + choiceEstmNum2 + "'";
                }
                throw new Exception(msg.getMessageByScreenId("SBDI0021", "T010") + exceptionMsg + msg.getMessageByScreenId("SBDI0021", "T011"));
            }
        }

        // 진행상태를 체크한다.
        String sendPossibleFlag = sbdr_Mapper.getSendPossibleFlag(formData);
        if(!EverString.nullToEmptyString(sendPossibleFlag).equals("Y")) {
            throw new Exception(msg.getMessageByScreenId("SBDI0021", "T012"));
        }

        formData.put("BID_STATUS", null);
        sbdr_Mapper.sbdi0021_doInsertVO(formData);

        // STOCBDVD [입찰 투찰상세정보]
        for(Map<String, Object> gridData : gridDatas) {
            gridData.put("VOTE_CNT", formData.get("VOTE_CNT"));
            gridData.put("VENDOR_CD", formData.get("VENDOR_CD"));
            sbdr_Mapper.sbdi0021_doInsertVD(gridData);
        }
        return msg.getMessageByScreenId("SBDI0021", "T013");
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String sbdi0021_doSendPrc(Map<String, String> formData, List<Map<String, Object>> gridDatas) throws Exception {

        UserInfo userInfo = UserInfoManager.getUserInfo();
        Map<String, String> rtnMap = new HashMap<String, String>();

        // 진행상태를 체크한다.
        String sendPossibleFlag = sbdr_Mapper.getSendPossibleFlagPrc(formData);
        if(!EverString.nullToEmptyString(sendPossibleFlag).equals("Y")) {
            throw new Exception(msg.getMessageByScreenId("SBDI0021", "T012"));
        }

        sbdr_Mapper.sbdi0021_doUpdateVO(formData);

        // STOCBDVD [입찰 투찰상세정보]
        for(Map<String, Object> gridData : gridDatas) {
            gridData.put("VOTE_CNT", formData.get("VOTE_CNT"));
            gridData.put("VENDOR_CD", formData.get("VENDOR_CD"));
            sbdr_Mapper.sbdi0021_doUpdateVD(gridData);
        }
        
        String msgStr = msg.getMessage("0031");
        if("E".equals(EverString.nullToEmptyString(formData.get("ADJ_PRC_STATUS")))) {
        	msgStr = msg.getMessageByScreenId("SBDI0021", "T013");
        }
        return msgStr;
    }

    /**
     * 화면명 : 입찰결과
     * 처리내용 : 협력업체에서 참여한 입찰의 개찰결과 목록이 조회된다.
     * 경로 : 협력업체 > 구매관리 > 입찰관리 > 입찰결과
     */
    public List<Map<String, Object>> sbdr0030_doSearch(Map<String, String> param) throws Exception {

        List<Map<String, Object>> rtnList = sbdr_Mapper.sbdr0030_doSearch(param);

        if(rtnList.size() > 0) {
            for(Map<String, Object> rtnData : rtnList) {
                if(rtnData.get("BID_AMT") != null) {
                    rtnData.put("BID_AMT", EverMath.EverNumberType(String.valueOf(rtnData.get("BID_AMT")), "###,###"));
                }
            }
        }
        return rtnList;
    }
    
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public Map<String, String> sbdi0013_doBidGuarCancel(Map<String, String> param) throws Exception {
    	Map<String, String> rtnMap = new HashMap<>();
    	
    	sbdr_Mapper.sbdi0013_doBidGuarCancel(param);
        
        String rtnMsg  = "";
        
        rtnMsg  = msg.getMessageByScreenId("SBDI0013", "021");
        
        
        // 고객사 입찰담당자에게 보증취소요청 메일발송
        Map<String, String> guarInformation = sbdr_Mapper.sbdi0013_getguarInformation(param);
        String linkUrl = PropertiesManager.getString("eversrm.urls.maintain.real");
    	try {
 			String subject = "[전자구매시스템] 협력사 [" + guarInformation.get("VENDOR_NM") + "]가 [" + guarInformation.get("ANN_ITEM") + "] 관련  입찰전자보증취소를 요청하였습니다";
 			
 			Map<String,String> mailMap = new HashMap<>();
 			
 			String contents = "<BR> 안녕하세요." +
 					"<BR> " + guarInformation.get("BID_USER_NM") + " 님" +
 					"<BR> " +
 					"<BR> 아래와 같이 협력사에서 입찰전자보증취소를 요청 하였습니다 <br>" +
 					"<BR> 협력사 : [" + guarInformation.get("VENDOR_NM") + "]" +
 					"<BR> 공고번호 : [" + guarInformation.get("ANN_NO") + "]" +
 					"<BR> 입찰건명 : ["+ guarInformation.get("ANN_ITEM") + "]" +
 					"<BR> 증권번호 : ["+ guarInformation.get("GUAR_NUM") + "]" +
 					"<BR> " +
 					"<BR> 전자구매시스템에 <a href='" + linkUrl + "' target='newP'>로그인</a> 하시어, 세부내용을 확인 해주십시오." +
 					"<BR> " +
 					"<BR> 감사합니다.";

 			mailMap.put("SUBJECT", subject);
 			mailMap.put("CONTENTS", contents);
 			mailMap.put("REF_MODULE_CD", "MCONT03");
 			mailMap.put("RECV_USER_ID", guarInformation.get("BID_USER_ID"));
 			everMailService.SendMail(mailMap);
    	} catch (Exception ex) {
            getLog().error("보증취소요청 전송 후 메일 발송 오류 : " + ex.getMessage(), ex);
        }
    	
        rtnMap.put("rtnMsg", rtnMsg);
        
        return rtnMap;
    }

}