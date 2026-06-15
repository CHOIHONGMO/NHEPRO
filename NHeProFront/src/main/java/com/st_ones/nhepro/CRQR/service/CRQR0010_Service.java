package com.st_ones.nhepro.CRQR.service;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.st_ones.common.docNum.service.DocNumService;
import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.common.mail.service.EverMailService;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.util.clazz.EverCert;
import com.st_ones.common.util.clazz.EverConverter;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.common.util.service.LargeTextService;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.exception.EverException;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.eversrm.eApproval.eApprovalModule.service.BAPM_Service;
import com.st_ones.nhepro.CRQR.CRQR0010_Mapper;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : CRQR0010_Service.java
 * @date 2018. 01. 30.
 * @version 1.0
 */

@Service(value = "CRQR0010_Service")
public class CRQR0010_Service extends BaseService {

    @Autowired 
    MessageService msg;
    @Autowired 
    CRQR0010_Mapper crqr0010_mapper;
    @Autowired 
    LargeTextService largeTextService;
    @Autowired 
    private DocNumService docNumService;
    @Autowired
    private BAPM_Service approvalService;
    @Autowired 
    private EverMailService everMailService;

    /**
     * 화면명 : 견적현황
     * 처리내용 : 견적 진행 현황을 조회하는 화면
     * 경로 : 고객사 > 구매관리 > 견적관리 > 견적현황
     */
    public List<Map<String, Object>> crqr0010_doSearch(Map<String, String> formData) {
    	
    	Map<String, Object> formObj = new HashMap<String, Object>(formData);
    	formObj.put("PROGRESS_CD_LIST", Arrays.asList(formData.get("PROGRESS_CD").split(",")));
    	
        return crqr0010_mapper.crqr0010_doSearch(formObj);
    }

    // 강제마감
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public Map<String, String> crqr0010_doForceClosing(Map<String, String> formData, List<Map<String, Object>> grid) throws Exception {
    	
        Map<String, String> rtnMap = new HashMap<>();
        for(Map<String, Object> data : grid) {
        	// STOCRQHD 강제마감
            crqr0010_mapper.crqr0010_doForceClosingRQHD(data);
            // STOCRQDT 강제마감
            crqr0010_mapper.crqr0010_doForceClosingRQDT(data);
        }

        rtnMap.put("rtnMsg", msg.getMessage("0031"));
        return rtnMap;
    }
    
    // 2020.12.09 기능 추가
    // 견적서 협력사 전송 (1건의 견적서 단위로 전송함)
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public Map<String, String> crqr0010_doSendVendor(List<Map<String, Object>> gridDatas) throws Exception {
        
    	Map<String, String> rtnMap = new HashMap<>();
        for(Map<String, Object> grid : gridDatas) {
        	crqr0010_mapper.crqr0010_doSendVendorRQHD(grid);
     		crqr0010_mapper.crqr0010_doSendVendorRQDT(grid);
     		
     		// 2021.01.21 추가
	        // 견적서 협력사 전송이후 구매진행상태=2350(입찰/견적 진행중)
     		grid.put("PROGRESS_CD", "2350");
	        crqr0010_mapper.doUpdateComparisonByTotal_PRDT(grid);
	        
     		// 견적요청시 협력사에게 메일발송
     		try {
     			sendMail(grid);
     		} catch (Exception ex) {
                getLog().error("고객사 견적요청 메일 및 SMS 발송 오류 : " + ex.getMessage(), ex);
            }
        }

        rtnMap.put("rtnMsg", msg.getMessage("0001"));
        return rtnMap;
    }
    
    // 이메일 발송(협력사에게 견적서 작성요청)
 	public void sendMail(Map<String, Object> gridData) throws Exception {
        
 		//EMAIL
        String linkUrl = PropertiesManager.getString("eversrm.urls.maintain.real") ;
        
        // 메일 발송정보 가져오기
        List<Map<String, String>> mailList = crqr0010_mapper.getMailList(gridData);
        for(Map<String, String> data : mailList) {
        	String subject = "[전자구매시스템] 고객사 [" + data.get("BUYER_NM") + "]에서 [" + data.get("RFX_SUBJECT") + "] 관련 RFQ 등록을 요청하였습니다";
        	
            Map<String,String> mailMap = new HashMap<>();
            mailMap.put("SUBJECT", subject);
            
            String content = "<BR> 안녕하세요." +
		                     "<BR> [" + data.get("VENDOR_NM") + "] " + data.get("USER_NM") + " 님" +
		                     "<BR> " +
		                     "<BR> 아래와 같이 고객사에서 RFQ 등록을 요청 하였습니다." +
		                     "<BR> 고객사 : [" + data.get("BUYER_NM") + "]" +
		                     "<BR> 요청명 : [" + data.get("RFX_NUM") + "] " + data.get("RFX_SUBJECT") +
		                     "<BR> 요청일 : [" + data.get("RFX_REQ_DATE") + "]" +
		                     "<BR> 요청기한 : [" + data.get("RFX_START_DATE") + " ~ " + data.get("RFX_END_DATE") + "]" +
		                     "<BR> " +
		                     "<BR> 전자구매시스템에 <a href='" + linkUrl + "' target='newP'>로그인</a> 하시어, 세부내용을 확인 후 처리 해주십시오." +
		                     "<BR> " +
		                     "<BR> 감사합니다.";

            mailMap.put("CONTENTS", content);
            mailMap.put("REF_MODULE_CD", "MRFQ01");
            mailMap.put("RECV_USER_ID", data.get("USER_ID"));
            mailMap.put("REF_NUM", data.get("RFX_NUM"));
            everMailService.SendMail(mailMap);
        }
 	}
 	
    // 구매담당자 변경
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public Map<String, String> crqr0010_doUpdateChange(Map<String, String> formData, List<Map<String, Object>> grid) throws Exception {
        Map<String, String> rtnMap = new HashMap<>();

        for(Map<String, Object> data : grid) {
        	data.put("CTRL_USER_CH_ID", formData.get("CTRL_USER_CH_ID"));

            crqr0010_mapper.crqr0010_doUpdateChange(data);
        }

        rtnMap.put("rtnMsg", msg.getMessage("0031"));

        return rtnMap;
    }

    /**
     * 화면명 : 견적요청서
     * 처리내용 : 구매담당자가 견적요청 정보를 등록하는 화면
     * 경로 : 고객사 > 구매관리 > 구매의뢰접수 > 구매의뢰접수 > 견적 (버튼) > 견적요청서 (팝업)
     * 경로 : 고객사 > 구매관리 > 구매의뢰접수 > 구매의뢰접수 > 수의시담 (버튼) > 견적요청서 (팝업)
     */
    public Map<String, Object> crqi0011_doSearchRQHD(Map<String, String> param) throws Exception {
    	
        Map<String, Object> fParam;
        fParam = crqr0010_mapper.crqi0011_doSearchRQHD(param);
        fParam.put("RMK_TEXT", largeTextService.selectLargeText(EverString.nullToEmptyString(fParam.get("RMK_TEXT_NUM"))));

        return fParam;
    }

    // 품목정보, 조회
    public List<Map<String, Object>> crqi0011_doSearchPRDT(Map<String, String> formData, Map<String, String> param) throws Exception {
        
    	Map<String, Object> fParam = new HashMap<>();
        List<Map<String, Object>> list = EverConverter.readJsonObject(param.get("gridSel"), List.class);
        fParam.put("BUYER_CD", list.get(0).get("BUYER_CD"));
        fParam.put("LIST", list);

        return crqr0010_mapper.crqi0011_doSearchPRDT(fParam);
    }

    // 품목정보, 조회
    public List<Map<String, Object>> crqi0011_doSearchRQDT(Map<String, String> formData, Map<String, String> param) throws Exception {
        List<Map<String, Object>> RQDT = crqr0010_mapper.crqi0011_doSearchRQDT(formData);

        for(Map<String, Object> data : RQDT) {
        	data.put("RFX_TYPE", formData.get("RFX_TYPE"));
            data.put("baseDataType", formData.get("baseDataType"));
            data.put("RFX_CNT", formData.get("ORI_RFX_CNT"));
            
            List<Map<String, Object>> list = crqr0010_mapper.crqi0011_doSearchRQSE(data);
            
            data.put("VN_INFO",  EverConverter.getJsonString(list));
            data.put("VENDOR_LIST", (list.size() == 0) ? "" : (list.size() == 1 ? list.get(0).get("VENDOR_NM") : list.size()));
            data.put("VENDOR_CNT" , (list.size() == 0) ? "" : list.size());
        }

        return RQDT;
    }

    // 저장
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public Map<String, String> crqi0011_doSave(Map<String, String> formData, List<Map<String, Object>> grid, List<Map<String, Object>> gridDEL) throws Exception {
        Map<String, String> rtnMap = new HashMap<>();

        UserInfo userInfo = UserInfoManager.getUserInfo();

        String preSignStatus = formData.get("PRE_SIGN_STATUS");
        String appDocCnt     = formData.get("APP_DOC_CNT");
        String baseDataType  = formData.get("baseDataType");
        
		String rfxNum = EverString.nullToEmptyString(formData.get("RFX_NUM"));
		String rfxCnt = EverString.nullToEmptyString(formData.get("RFX_CNT")).equals("") ? "1" : formData.get("RFX_CNT");
		formData.put("RFX_CNT", rfxCnt);
		
		String signStatus = EverString.nullToEmptyString(formData.get("SIGN_STATUS"));
		formData.put("SIGN_DATE", 	signStatus.equals("E") ? "SYSDATE" : "NULL");
		// 2021.01.22 기능 변경 (2350 : 가격입찰 진행중 / 2300 : 작성중) 
		// 입찰/견적진행중(2350)은 결재 승인 후 협력사 견적서 전송시 변경
		//formData.put("PROGRESS_CD", signStatus.equals("E") ? "2350" : "2300");
		formData.put("PROGRESS_CD", "2300");
		
		String textNo = largeTextService.saveLargeText(formData.get("RMK_TEXT_NUM"), formData.get("RMK_TEXT"));
		formData.put("RMK_TEXT_NUM", textNo);
		
		// 업체선정유형(DOC/ITEM)
		String settleType = EverString.nullToEmptyString(formData.get("SETTLE_TYPE"));
		if( StringUtils.isEmpty(settleType) ) {
			settleType = "DOC";
		}
		
        // 1. 재견적인 경우 차수 체크
        if( "RERFX".equals(baseDataType) ) {
            // 이전차수의 진행상태 체크(2400 : 선정대기인 경우만 재견적)
	        String checkData = crqr0010_mapper.crqi0011_checkBeforeRfqProgressCd(formData);
			if( !StringUtils.isEmpty(checkData) && !"2400".equals(checkData) ) {
				throw new EverException(msg.getMessageByScreenId("CRQI0011", "012"));
			}
			
			// 견적제한횟수가 현재의 재견적차수보다 작으면 오류
			String limitCnt = crqr0010_mapper.crqi0011_checkRfqLimitCount(formData);
			if( !StringUtils.isEmpty(limitCnt) && Integer.parseInt(limitCnt) < Integer.parseInt(rfxCnt) ) {
				throw new EverException(msg.getMessageByScreenId("CRQI0011", "014"));
			}
			
			// 현재 재견적 차수가 존재하면 오류
			String existFlag = crqr0010_mapper.crqi0011_checkNextRfqExistYn(formData);
			if( !StringUtils.isEmpty(existFlag) && "Y".equals(existFlag) ) {
				throw new EverException(msg.getMessageByScreenId("CRQI0011", "013"));
			}
        }
        
        // 2. 결재상신
        if( signStatus.equals("P") ) {
            if (EverString.isEmpty(formData.get("APP_DOC_NUM"))) {
                formData.put("APP_DOC_NUM", docNumService.getDocNumber(userInfo.getCompanyCd(), "APPDOC"));
            }
            if (EverString.isEmpty(appDocCnt) || appDocCnt.equals("0")) {
                appDocCnt = "1";
            } else {
                appDocCnt = String.valueOf(Integer.parseInt(appDocCnt) + 1);
            }
            formData.put("APP_DOC_CNT", appDocCnt);
            
            // 결재요청
            approvalService.doApprovalProcess(formData, formData.get("approvalFormData"), formData.get("approvalGridData"));
        }
        
        // STOCRQHD [일반정보]
 		// 재견적
 		if( baseDataType.equals("RERFX") ) {
 			// 2021.03.15 기능 변경
 			// 견적서 결재승인 후 견적발송 기능 추가(2021.01월)에 따른 재견적시에는 진행상태를 견적진행중(2350)으로 강제 전환
 			formData.put("PROGRESS_CD", "2350");
            crqr0010_mapper.crqi0011_doInsertRQHD(formData);
            
            // 이전 차수 견적 PROGRESS_CD = 2550(재견적)으로 RQHD의 진행상태 변경
            formData.put("BF_PROGRESS_CD", "2550");
            crqr0010_mapper.crqi0011_doUpdateProgressCdReRoundingDate(formData);
 		}
 		else {
 	        if( StringUtils.isEmpty(rfxNum) ) {
 	        	rfxNum = docNumService.getDocNumber(userInfo.getCompanyCd(), "RFQ");
 				formData.put("RFX_NUM", rfxNum);
 	            crqr0010_mapper.crqi0011_doInsertRQHD(formData);
 	        } else {
                crqr0010_mapper.crqi0011_doUpdateRQHD(formData);
 	        }
 		}
        
	 	// STOCRQDT [품목정보]
        // 품목 삭제일 경우 > PRDT의 구매진행상태 = 접수완료(2200)
        for( Map<String, Object> data : gridDEL ) {
            data.put("PROGRESS_CD", "2200");
            if( !StringUtils.isEmpty(data.get("RFX_NUM")) ) {
                crqr0010_mapper.updateProgressCdToPR(data);
                crqr0010_mapper.crqi0011_doDeleteRQDT(data);
                crqr0010_mapper.crqi0011_doDeleteRQVN(data);
                crqr0010_mapper.crqi0011_doDeleteRQSE(data);
            }
        }
        
        // STOCRQDT [품목정보]
        List<Map<String, Object>> list;
        String temp = "";
        boolean rqvnDel = true;
        for( Map<String, Object> data : grid ) {
            data.put("PROGRESS_CD", formData.get("PROGRESS_CD"));
            data.put("RFX_CNT", rfxCnt);
            data.put("RFX_QT", data.get("PR_QT"));
            data.put("ITEM_AMT", data.get("PR_AMT"));

            if( !StringUtils.isEmpty(data.get("RFX_NUM")) ) {
                // 재견적인 경우
            	if("RERFX".equals(baseDataType)) {
                    crqr0010_mapper.crqi0011_doInsertRQDT(data);
                    
                    // RFX_SQ 값 설정
                    data.put("RFX_SQ", String.valueOf(data.get("RFX_SQ_KEY")));
                } else {
                    crqr0010_mapper.crqi0011_doUpdateRQDT(data);
                    if (rqvnDel == true) {
                        crqr0010_mapper.crqi0011_doDeleteRQVN(data);
                        rqvnDel = false;
                    }
                    if( "ITEM".equals(settleType) ) {
                    	crqr0010_mapper.crqi0011_doDeleteRQSE(data);
                    }
                }
            } else {
                data.put("RFX_NUM", rfxNum);
                crqr0010_mapper.crqi0011_doInsertRQDT(data);
                
                // RFX_SQ 값 설정
                data.put("RFX_SQ", String.valueOf(data.get("RFX_SQ_KEY")));
            }
            
            // 구매요청 품목의 진행상태 변경(견적 작성중 : 2300)
            crqr0010_mapper.updateProgressCdToPR(data);
            
            list = new ObjectMapper().readValue(EverString.nullToEmptyString(data.get("VN_INFO")), List.class);
            for(Map<String, Object> map : list) {
                map.put("BUYER_CD", data.get("BUYER_CD"));
                map.put("RFX_NUM",  data.get("RFX_NUM"));
                map.put("RFX_CNT",  data.get("RFX_CNT"));
                map.put("RFX_SQ",   EverString.nullToEmptyString(data.get("RFX_SQ")));
                map.put("RFX_PROGRESS_CD", "100");	// 미접수
                map.put("TEMP", temp);

                crqr0010_mapper.crqi0011_doInsertRQVN(map);
                // 품목별 협력업체 등록은 품목별 선정에서만 진행
                if( "ITEM".equals(settleType) ) {
                	crqr0010_mapper.crqi0011_doInsertRQSE(map);
                }
                temp = "1";
            }
        }
        
        rtnMap.put("BUYER_CD", userInfo.getCompanyCd());
        rtnMap.put("RFX_NUM",  formData.get("RFX_NUM"));
        rtnMap.put("RFX_CNT",  formData.get("RFX_CNT"));
        if (signStatus.equals("P")) {
            rtnMap.put("rtnMsg", msg.getMessage("0023"));
        } else {
            rtnMap.put("rtnMsg", msg.getMessage("0031"));
        }
        
        return rtnMap;
    }

    // 삭제
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public Map<String, String> crqi0011_doDelete(Map<String, String> formData) throws Exception {
        
        // RQHD : 삭제(DEL_FLAG = '1')
 		formData.put("_TABLE_NM", "STOCRQHD");
 		crqr0010_mapper.crqi0011_doDeleteFlag(formData);
 		// RQDT : 삭제(DEL_FLAG = '1')
 		formData.put("_TABLE_NM", "STOCRQDT");
 		crqr0010_mapper.crqi0011_doDeleteFlag(formData);
 		// SETTLE_TYPE = 'DOC' ? RQVN : RQSE : 삭제(DEL_FLAG = '1')
 		formData.put("_TABLE_NM", (formData.get("SETTLE_TYPE").equals("DOC") ? "STOCRQVN" : "STOCRQSE"));
 		crqr0010_mapper.crqi0011_doDeleteFlag(formData);
        
        // PRDT.PROGRESS_CD = '2200'로 원복.
 		List<Map<String, Object>> prList = crqr0010_mapper.getPRDataByRFX(formData);
		for(Map<String, Object> prData : prList) {
			prData.put("PROGRESS_CD", "2200");
			crqr0010_mapper.updateProgressCdToPR(prData);
		}
        
		Map<String, String> rtnMap = new HashMap<>();
        rtnMap.put("rtnMsg", msg.getMessage("0017"));
        return rtnMap;
    }
    
    /**
     * 화면명 : 견적시간 변경
     * 처리내용 : 견적시간 변경
     * 경로 : 고객사 > 구매관리 > 견적관리 > 견적현황 > 견적시간 변경
     * 21.06.29 신규추가
     */
    public Map<String, Object> crqi0012_doSearchRQHD(Map<String, String> param) throws Exception {
    	
        Map<String, Object> fParam;
        fParam = crqr0010_mapper.crqi0012_doSearchRQHD(param);

        return fParam;
    }
    
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String crqi0012_doSave(Map<String, String> formData) throws Exception {
        
		String ProgressCd = crqr0010_mapper.getProgressCd(formData);
		System.out.println("ProgressCd ====> " + ProgressCd);
        if(!ProgressCd.equals("2350")) {
            throw new Exception(msg.getMessageByScreenId("CRQI0012", "003"));
        }
		
        crqr0010_mapper.crqi0012_doSaveRQHD(formData);
		
		return msg.getMessageByScreenId("CRQI0012", "002");
	}
    
    /**
     * 화면명 : 협력업체 견적제출조회
     * 처리내용 : 참여협력업체 조회
     * 경로 : 고객사 > 구매관리 > 견적관리 > 견적현황, 협력업체선정 > 참여협력업체조회
     */
    public Map<String, Object> crqr0031_doSearchRQHD(Map<String, String> param) throws Exception {
    	
        Map<String, Object> fParam;
        fParam = crqr0010_mapper.crqr0031_doSearchRQHD(param);
        fParam.put("RMK_TEXT", largeTextService.selectLargeText(EverString.nullToEmptyString(fParam.get("RMK_TEXT_NUM"))));

        return fParam;
    }

    /**
     * 화면명 : 협력업체 견적제출조회
     * 처리내용 : 참여협력업체 조회
     * 경로 : 고객사 > 구매관리 > 견적관리 > 견적현황, 협력업체선정 > 참여협력업체조회
     */
    public List<Map<String, Object>> crqr0031_doSearchDT(Map<String, String> param) throws Exception {
        return crqr0010_mapper.crqr0031_doSearchDT(param);
    }

    /**
     * 화면명 : 협력업체선정
     * 처리내용 : 협력업체를 선정하기 위해 견적진행현황을 조회하는 화면
     * 경로 : 고객사 > 구매관리 > 견적관리 > 협력업체선정
     */
    public List<Map<String, Object>> crqa0040_doSearch(Map<String, String> param) {

        return crqr0010_mapper.crqa0040_doSearch(param);
    }

    // 견적서 개찰
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String crqa0040_doOpen(List<Map<String, Object>> gridDatas) throws Exception {

		for (Map<String, Object> gridData : gridDatas) {
			// 1. 이미 개찰된 경우
			String checkDate = EverString.nullToEmptyString(crqr0010_mapper.checkRfqOpenDate(gridData));
			if (!checkDate.equals("-")) {
				throw new EverException(msg.getMessageByScreenId("CRQA0040", "009"));
			}

			// 2. 마감이 아닌 경우 개찰할 수 없음
			String checkStatus = crqr0010_mapper.checkRfqOpenStatus(gridData);
			if (!"2400".equals(checkStatus)) {
				throw new Exception(msg.getMessageByScreenId("CRQA0040", "010"));
			}
			
			// 3. for문을 돌며 서명값을 검증한다.
			List<Map<String, Object>> signList = crqr0010_mapper.checkSignDataList(gridData);
	        for (Map<String, Object> rtnMap : signList) {

	            String sSignData = String.valueOf(rtnMap.get("SIGN_VALUE"));
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
	            if(!checkFlag) {
	            	throw new Exception(msg.getMessageByScreenId("CRQA0040", "014"));
	            }
	            
	            /* 서명데이터 검증
	            String[] oriSignedDataArgs = EverCert.getOriSignedData(sSignData, vidRandom, idn, "@@", useCard);
	            for(int z = 0; z < oriSignedDataArgs.length; z++) {
	                String oriSignedDataStr = oriSignedDataArgs[z];
	            }*/
	        }
	        
			// 4. 개찰 후 입찰진행상태 변경(=2400)
			crqr0010_mapper.doOpenRfqProposalOpen(gridData);

			// 5. 투찰헤더 복호화
			crqr0010_mapper.doOpenQTHD(gridData);

			// 6. 투찰상세 복호화
			crqr0010_mapper.doOpenQTDT(gridData);

			String rfxCnt = String.valueOf(gridData.get("RFX_CNT"));
	        if(rfxCnt.equals("1")) {
	        	crqr0010_mapper.setDecES(gridData);
	        	crqr0010_mapper.setFinalEstmPrcSE(gridData);
	        }
	        
	        /**
	         * 입찰 및 견적은 업체선정대기 이후에 재견적, 재입찰, 재공고등이 진행되기 때문에 구매진행상태를 2400으로 변경하지 않음
	         * 2021.01.21 추가
	         * 7. 견적서 개찰이후 구매진행상태=2400
	        gridData.put("PROGRESS_CD", "2400");
	        crqr0010_mapper.doUpdateComparisonByTotal_PRDT(gridData);
	        */
		}

		return msg.getMessageByScreenId("CRQA0040", "011");
	}
    
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String crqa0040_doApproval(Map<String, String> formData, List<Map<String, Object>> gridDatas) throws Exception {

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
            formData.put("DOC_TYPE", "RFXRLT");

            // 결재상신 공통모듈 호출
            approvalService.doApprovalProcess(formData, formData.get("approvalFormData"), formData.get("approvalGridData"));

            // 결재상신 후, STOCBDHD에 입찰결과 결재문서번호, 입찰결과 결재문서차수를 Update한다.
            gridData.put("RLT_APP_DOC_CNT", appDocCnt);
            gridData.put("RLT_SIGN_STATUS", "P");
            crqr0010_mapper.crqa0040_doUpdateAppNum(gridData);
        }
        return msg.getMessage("0023");
    }

    /**
     * 화면명 : 단일업체선정 견적비교
     * 처리내용 : 전체 품목에 대해 단일업체 선정
     * 경로 : 고객사 > 구매관리 > 견적관리 > 협력업체선정 > 단일업체선정 견적비교
     */
	public Map<String, String> doSearchComparisonByTotal_F(Map<String, String> param) throws Exception {
    	return crqr0010_mapper.doSearchComparisonByTotal_F(param);
    }

	public List<Map<String, Object>> crqi0041_doSearchV(Map<String, String> param) throws Exception {
		return crqr0010_mapper.crqi0041_doSearchV(param);
	}

	public List<Map<String, Object>> crqi0041_doSearchI(Map<String, String> param) throws Exception {
		return crqr0010_mapper.crqi0041_doSearchI(param);
	}

	// CRQI0041 : 단일업체선정 > 유찰 - 구매요청복구
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
   	public String crqi0041_doPRRestore(Map<String, Object> formData) throws Exception {

    	// 유찰 가능 진행상태 체크
    	int check = crqr0010_mapper.checkRfqProgressStatusComparisonByTotal(formData);
		if (check > 0) { return msg.getMessage("0044"); }

		formData.put("PROGRESS_CD", "1300");
		formData.put("DATE_UPDATED", "PR_RETURN_DATE");

		crqr0010_mapper.doUpdateComparisonByTotal_RQDT(formData);
		crqr0010_mapper.doUpdateComparisonByTotal_RQHD(formData);
		// 사용안함
		//crqr0010_mapper.doInsertComparisonByTotal_PRHB(formData);
		crqr0010_mapper.doUpdateComparisonByTotal_QTDT(formData);
		crqr0010_mapper.doUpdateComparisonByTotal_PRDT(formData);
		return msg.getMessage("0001");
   	}
    
    // CRQI0041 : 단일업체선정
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
   	public String crqi0041_doFinal(Map<String, Object> formData, List<Map<String, Object>> gridData) throws Exception {

    	// 업체선정 가능 진행상태 체크(<=2300 or >= 2500)
    	int check = crqr0010_mapper.checkRfqProgressStatusComparisonByTotal(formData);
		if (check > 0) { return msg.getMessage("0044"); }

		formData.put("PROGRESS_CD", "2500");
		formData.put("DATE_UPDATED", "SETTLE_DATE");

		crqr0010_mapper.doUpdateComparisonByTotal_RQDT(formData);
		crqr0010_mapper.doUpdateComparisonByTotal_RQHD(formData);
		crqr0010_mapper.doUpdateComparisonByTotal_PRDT(formData);

		for (Map<String, Object> grid : gridData) {
			grid.put("BUYER_CD", formData.get("BUYER_CD"));
			grid.put("RFX_NUM",  formData.get("RFX_NUM"));
			grid.put("RFX_CNT",  formData.get("RFX_CNT"));
			if (grid.get("AWARD").equals("1")) {
				// 업체선정
				crqr0010_mapper.doUpdateComparisonByTotal_QTDT_F(grid);
				
				// 품의대기 등록
				List<Map<String, Object>> itemList = crqr0010_mapper.getRfxQuotationItemList(grid);
				for (Map<String, Object> item : itemList) {
		            String execWtNum = docNumService.getDocNumber(item.get("BUYER_CD").toString(), "EXEW");
		            item.put("EXEC_WT_NUM", execWtNum);
					crqr0010_mapper.doInsertComparisonByTotal_CNHB(item);
				}
			}
		}

		// 업체선정 후 문서번호 저장
		List<Map<String, String>> donuList = crqr0010_mapper.getDonuList(formData);
		for(Map<String, String> donuData : donuList) {
			crqr0010_mapper.doUpdateDonuNum(donuData);
		}

		return msg.getMessage("0001");
   	}

    /**
     * 화면명 : 품목별선정 견적비교
     * 처리내용 : 품목별로 별도의 협력업체 선정
     * 경로 : 고객사 > 구매관리 > 견적관리 > 협력업체선정 > 품목별선정 견적비교
     */
    public Map<String, Object> doSearchComparisonByItem_F(Map<String, String> param) throws Exception {
    	return crqr0010_mapper.doSearchComparisonByItem_F(param);
    }

    public List<Map<String, Object>> doSearchComparisonByItem_G(Map<String, String> param) throws Exception {
		return crqr0010_mapper.doSearchComparisonByItem_G(param);
	}

    public Map<String, Object> doSearchComparisonSumUnitPrc(Map<String, String> param) throws Exception {
    	return crqr0010_mapper.doSearchComparisonSumUnitPrc(param);
    }

    // CRQI0042 : 품목별 업체선정 > 유찰 - 구매요청복구
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
   	public String doRestoreComparisonByItem(Map<String, Object> formData) throws Exception {
    	
    	// 품목별 업체선정시 품목별로 유찰 및 업체선정, 재견적을 할 수 있다.
    	int check = crqr0010_mapper.checkRfqProgressStatusComparisonByTotal(formData);
		if (check > 0) { return msg.getMessage("0044"); }

		formData.put("PROGRESS_CD", "1300");
		formData.put("DATE_UPDATED", "PR_RETURN_DATE");

		crqr0010_mapper.doUpdateComparisonByTotal_RQDT(formData);
		crqr0010_mapper.doUpdateComparisonByTotal_RQHD(formData);
		// 사용안함
		//crqr0010_mapper.doInsertComparisonByTotal_PRHB(formData);
		crqr0010_mapper.doUpdateComparisonByTotal_QTDT(formData);
		crqr0010_mapper.doUpdateComparisonByTotal_PRDT(formData);

		return msg.getMessage("0001");
   	}

    // CRQI0042 : 품목별업체선정
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
   	public String doFinalComparisonByItem(Map<String, Object> formData, List<Map<String, Object>> gridData) throws Exception {

    	int check = crqr0010_mapper.checkRfqProgressStatusComparisonByTotal(formData);
		if (check > 0) { return msg.getMessage("0044"); }

		formData.put("PROGRESS_CD", "2500");
		formData.put("DATE_UPDATED", "SETTLE_DATE");
		
		// 1. RQDT, PRDT 선정
		crqr0010_mapper.doUpdateComparisonByTotal_RQDT(formData);
		crqr0010_mapper.doUpdateComparisonByTotal_PRDT(formData);
		
		// 2. QTDT 선정, CNHB 등록
		for (Map<String, Object> grid : gridData) {
			grid.put("BUYER_CD", formData.get("BUYER_CD"));
			grid.put("RFX_NUM",  formData.get("RFX_NUM"));
			grid.put("RFX_CNT",  formData.get("RFX_CNT"));
			grid.put("PROGRESS_CD", "2500");
			grid.put("DATE_UPDATED", "SETTLE_DATE");

			if (grid.get("AWARD").equals("1") || grid.get("AWARD").equals("P")) {
				crqr0010_mapper.doUpdateComparisonByItem_QTDT_Y(grid);

				// 품의대기 테이블 저장
	            String execWtNum = docNumService.getDocNumber(grid.get("BUYER_CD").toString(), "EXEW");
	            grid.put("EXEC_WT_NUM", execWtNum);
				crqr0010_mapper.doInsertComparisonByItem_CNHB(grid);
			} else {
				crqr0010_mapper.doUpdateComparisonByItem_QTDT_N(grid);
			}

		}
		
		// 3. RQHD 진행상태 변경(전체품목이 선정시)
		Map<String, String> checkData = crqr0010_mapper.checkRfqProgressStatusComparisonByItem(formData);
		if( !StringUtils.isEmpty(checkData.get("ITEM_COUNT")) && checkData.get("ITEM_COUNT").equals(checkData.get("SEL_COUNT")) ) {
			crqr0010_mapper.doUpdateComparisonByTotal_RQHD(formData);
		}
		
		return msg.getMessage("0001");
   	}
    
    // 2020/07/06 : 미사용
    // 재견적시 부분 업체선정
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
   	public String doFinalComparisonByItemDoRe(Map<String, Object> formData, List<Map<String, Object>> gridData) throws Exception {

		formData.put("PROGRESS_CD", "2500");
		formData.put("DATE_UPDATED", "SETTLE_DATE");
		crqr0010_mapper.doUpdateComparisonByTotal_RQHD(formData);

		for (Map<String, Object> grid : gridData) {
			grid.put("BUYER_CD", formData.get("BUYER_CD"));
			grid.put("RFX_NUM",  formData.get("RFX_NUM"));
			grid.put("RFX_CNT",  formData.get("RFX_CNT"));
			grid.put("PROGRESS_CD", "2500");
			grid.put("DATE_UPDATED", "SETTLE_DATE");

			if( grid.get("AWARD").equals("1") || grid.get("AWARD").equals("P") ) {
				crqr0010_mapper.doUpdateComparisonByItem_QTDT_Y(grid);
				crqr0010_mapper.doUpdateComparisonByTotal_RQDT_Y(grid);

				// 품의대기 테이블 저장
	            String execWtNum = docNumService.getDocNumber(grid.get("BUYER_CD").toString(), "EXEW");
	            grid.put("EXEC_WT_NUM", execWtNum);
				crqr0010_mapper.doInsertComparisonByItem_CNHB(grid);
			} else {
				crqr0010_mapper.doUpdateComparisonByItem_QTDT_N(grid);
			}
		}
		return msg.getMessage("0001");
   	}

}
