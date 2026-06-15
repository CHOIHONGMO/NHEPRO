package com.st_ones.nhepro.CBDI.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.st_ones.common.docNum.service.DocNumService;
import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.util.clazz.EverCert;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.common.util.service.LargeTextService;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.exception.NoResultException;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.eversrm.eApproval.eApprovalModule.service.BAPM_Service;
import com.st_ones.nhepro.CBDI.CBDI0010_Mapper;
import com.st_ones.nhepro.CBDR.service.CBDR0030_Service;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2014 ST-Ones CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : CBDI0010_Service.java
 * @date 2020. 4. 02.
 * @version 1.0
 */

@Service(value = "cbdi0010_Service")
public class CBDI0010_Service extends BaseService {

	@Autowired private MessageService msg;
	@Autowired private LargeTextService largeTextService;
	@Autowired private DocNumService docNumService;
	@Autowired private BAPM_Service approvalService;
	@Autowired private CBDI0010_Mapper cbdi_Mapper;
	@Autowired private CBDR0030_Service cbdr0030_Service;
	
	/**
	 * 화면명 : 입찰공고
	 * 처리내용 : 입찰공고의 생성 이후 입찰등록까지의 입찰공고 목록을 조회하는 화면.
	 * 경로 : 고객사 > 구매관리 > 입찰관리 > 입찰공고 > 입찰공고
	 */
	public List<Map<String, Object>> cbdi0010_doSearch(Map<String, String> param) throws Exception {
		return cbdi_Mapper.cbdi0010_doSearch(param);
	}
	
	// 입찰담당자 변경
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String cbdi0010_doChangeCtrl(String ctrlUserId, List<Map<String, Object>> gridDatas) throws Exception {

		for(Map<String, Object> gridData : gridDatas) {

			gridData.put("CTRL_USER_ID", ctrlUserId);

			// 진행상태를 체크한다.
			String possibleFlag = cbdi_Mapper.getPossibleFlag(gridData);
			if(!EverString.nullToEmptyString(possibleFlag).equals("Y")) {
				throw new Exception(msg.getMessageByScreenId("CBDI0010", "002"));
			}
			cbdi_Mapper.cbdi0010_doChangeCtrl(gridData);
		}
		return msg.getMessageByScreenId("CBDI0010", "004");
	}
	
	// 규격/기술평가 담당자 변경
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String cbdi0010_doChangeEv(String evUserId, List<Map<String, Object>> gridDatas) throws Exception {

		for(Map<String, Object> gridData : gridDatas) {
			gridData.put("EV_USER_ID", evUserId);
			// 진행상태를 체크한다.
			String possibleFlag = cbdi_Mapper.getPossibleFlag(gridData);
			if(!EverString.nullToEmptyString(possibleFlag).equals("Y")) {
				throw new Exception(msg.getMessageByScreenId("CBDI0010", "002"));
			}
			cbdi_Mapper.cbdi0010_doChangeEv(gridData);
		}
		return msg.getMessageByScreenId("CBDI0010", "004");
	}

	/**
	 * 화면명 : 입찰공고생성
	 * 처리내용 : 입찰공고를 작성하는 화면.
	 * 경로 : 고객사 > 구매관리 > 입찰관리 > 입찰공고 > 입찰공고생성
	 */
	public Map<String, String> cbdi0011_doSearchHD(Map<String, String> param) throws Exception {

		// 일반정보
		Map<String, String> formData = cbdi_Mapper.cbdi0011_doSearchHD(param);
		formData.put("APP_ETC_NUM", formData.get("APP_ETC"));
		formData.put("APP_ETC", largeTextService.selectLargeText(formData.get("APP_ETC")));

		// ONLY_DIFF_GUAR_FLAG
		String contType2 = EverString.nullToEmptyString(formData.get("CONT_TYPE2"));
		if(contType2.equals("TD") || contType2.equals("TS")) {
			formData.put("ONLY_DIFF_GUAR_FLAG", formData.get("DIFF_GUAR_FLAG"));
			formData.put("DIFF_GUAR_FLAG", "");
			formData.put("ONLY_MIN_TECH_SCORE", String.valueOf(formData.get("MIN_TECH_SCORE")));
			formData.put("MIN_TECH_SCORE", "");
		}
		return formData;
	}

	public List<Map<String, Object>> cbdi0011_doSearchDT(Map<String, String> param) throws Exception {

        List<Map<String, Object>> rtnList = null;
        String baseDataType = EverString.nullToEmptyString(param.get("baseDataType"));

        if(baseDataType.equals("CreateBID")) {
            if(EverString.isNotEmpty(param.get("paramPrNumSq"))) {
                param.put("paramPrNumSq", EverString.forInQuery(param.get("paramPrNumSq"), "@@"));
            }
            rtnList = cbdi_Mapper.cbdi0011_doSearchItemByPr(param);
        }
        else {
            rtnList = cbdi_Mapper.cbdi0011_doSearchDT(param);
        }
		return rtnList;
	}

	public List<Map<String, Object>> cbdi0011_doSearchEU(Map<String, String> param) throws Exception {
		return cbdi_Mapper.cbdi0011_doSearchEU(param);
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public Map<String, String> cbdi0011_doSave(Map<String, String> formData, List<Map<String, Object>> gridDatasI, List<Map<String, Object>> gridDatasE) throws Exception {

		UserInfo userInfo = UserInfoManager.getUserInfo();
		Map<String, String> rtnMap = new HashMap<String, String>();
		
		String baseDataType = EverString.nullToEmptyString(formData.get("baseDataType"));
		String oriBaseDataType = EverString.nullToEmptyString(formData.get("oriBaseDataType"));
		
		String signStatus= EverString.nullToEmptyString(formData.get("SIGN_STATUS"));
		String buyerCd   = EverString.nullToEmptyString(formData.get("BUYER_CD"));
		String bidNum    = EverString.nullToEmptyString(formData.get("BID_NUM"));
		String bidCnt    = EverString.nullToEmptyString(formData.get("BID_CNT")).equals("") ? "1" : formData.get("BID_CNT");
		String voteCnt   = EverString.nullToEmptyString(formData.get("VOTE_CNT")).equals("") ? "1" : ((baseDataType.equals("ModBID")) ? "1" : formData.get("VOTE_CNT"));
		String appEtcNum = largeTextService.saveLargeText(formData.get("APP_ETC_NUM"), formData.get("APP_ETC"));
		
		formData.put("BID_CNT", bidCnt);
		formData.put("VOTE_CNT", voteCnt);
		formData.put("APP_ETC_NUM", appEtcNum);

		if( bidNum.equals("") ) {
			bidNum = docNumService.getDocNumber(buyerCd, "BID");
			formData.put("BID_NUM", bidNum);
		} else {
			// 결재상태가 "E", "P"인 경우, 수정/결재요청이 불가하다.
			String signStatusStr = getSignStatus(formData);
            if(EverString.nullToEmptyString(signStatusStr).equals("P")) {
                throw new Exception(msg.getMessageByScreenId("CBDI0011", "T033"));
            }
            if(EverString.nullToEmptyString(signStatusStr).equals("E")) {
                throw new Exception(msg.getMessageByScreenId("CBDI0011", "T035"));
            }
		}
		
		formData.put("PROGRESS_CD", "2301"); 	// PROGRESS_CD : 2301 (작성중)
		formData.put("BID_STATUS", "2301"); 	// BID_STATUS : 2301 (작성중)
		formData.put("DIFF_GUAR_FLAG", EverString.nullToEmptyString(formData.get("ORI_DIFF_GUAR_FLAG")));
		formData.put("MIN_TECH_SCORE", EverString.nullToEmptyString(formData.get("ORI_MIN_TECH_SCORE")));

		// STOCBDEU [입찰 기술평가자]
		// 기술평가구분이 ”기술평가수행 [20]“ 인 경우, 평가자 정보를 Insert.
		String techEvType = EverString.nullToEmptyString(formData.get("TECH_EV_TYPE"));
		if(techEvType.equals("20")) {
			if(EverString.nullToEmptyString(formData.get("EI_NUM")).equals("")) {
				String eiNum = docNumService.getDocNumber(userInfo.getCompanyCd(), "EV");
				formData.put("EI_NUM", eiNum);
			}
			this.saveTechEvUser(formData, gridDatasE);
		}

		// 1. STOCRQHD [일반정보]
		cbdi_Mapper.cbdi0011_doMergeHD(formData);

        // 2. 정정공고시 이전 차수의 BID_STATUS = '9999'로 Update.
		if(baseDataType.equals("ModBID")) {
            formData.put("BID_STATUS", "9999");
            cbdi_Mapper.setBidStatusForPreCnt(formData);
            cbdi_Mapper.setBDESCopy(formData);
        }
		
		// 3. STOCBDPG [입찰 진행정보]
		cbdi_Mapper.cbdi0011_doMergePG(formData);
		
		// 4. STOCBDAP [입찰 참가신청정보]
		String contType1 = EverString.nullToEmptyString(formData.get("CONT_TYPE1"));
		if(contType1.equals("NC")) { this.saveVendor(formData); }
		
		// 5. 이전 입찰건의 예정가격 복사
		if (!EverString.nullToEmptyString(formData.get("PRE_BID_NUM")).equals("") && !EverString.nullToEmptyString(formData.get("PRE_BID_CNT")).equals("")) {
            cbdi_Mapper.setBDESPreCopy(formData);
            
            // 2021.04.22 재공고 추가
            // 재공고시 기존 입찰건 유찰 처리
            if( oriBaseDataType.equals("ReBID") ) {
            	Map<String, String> formReAnn = new HashMap<String, String>();
            	formReAnn.put("BUYER_CD", formData.get("BUYER_CD"));
            	formReAnn.put("BID_NUM", formData.get("PRE_BID_NUM"));
            	formReAnn.put("BID_CNT", formData.get("PRE_BID_CNT"));
            	formReAnn.put("VOTE_CNT", formData.get("PRE_VOTE_CNT"));
            	formReAnn.put("SINGLE_FLAG", formData.get("SINGLE_FLAG"));
            	formReAnn.put("SEL_BUYER_CD", formData.get("SEL_BUYER_CD"));
            	formReAnn.put("SEL_BID_NUM", formData.get("SEL_BID_NUM"));
            	formReAnn.put("SEL_BID_CNT", formData.get("SEL_BID_CNT"));
            	formReAnn.put("SEL_VOTE_CNT", formData.get("SEL_VOTE_CNT"));
            	formReAnn.put("SEL_CONT_TYPE", formData.get("SEL_CONT_TYPE"));
            	cbdr0030_Service.cbdr0033_doFailBid(formReAnn);
            }
		}
		
		// 6. STOCBDDT [입찰 상세정보 (품목) 삭제]
		cbdi_Mapper.cbdi0011_doDeleteAllDT(formData);
		
		// 7. STOCBDDT [입찰 상세정보 (품목)]
		for(Map<String, Object> gridDataI : gridDatasI) {
			gridDataI.put("BUYER_CD", formData.get("BUYER_CD"));
			gridDataI.put("BID_NUM", formData.get("BID_NUM"));
			gridDataI.put("BID_CNT", formData.get("BID_CNT"));
			gridDataI.put("TCO_YEAR_CNT", formData.get("TCO_YEAR_CNT"));
			cbdi_Mapper.cbdi0011_doInsertDT(gridDataI);
			
			gridDataI.put("ITEM_SQ", String.valueOf(gridDataI.get("ITEM_SQ_KEY")));
			
			// STOCPRDT [구매의뢰 Detail - P/R Item Information] 진행상태 Update. 최초 입찰공고 작성시에만 Update한다.
            if(baseDataType.equals("CreateBID")) {
                gridDataI.put("PROGRESS_CD", "2300"); // PROGRESS_CD : 2300 (작성중)
                cbdi_Mapper.cbdi0011_doUpdatePrdtProgressCd(gridDataI);
            }
		}

		// 8. STOCBDHD, STOCBDDT에 저장(SIGN_STATUS = 'T' or 'P') 후, 결재요청인 경우 STOCSCTM 테이블에 저장.
		String appDocCnt = formData.get("APP_DOC_CNT");
		if (signStatus.equals("P")) {
			if (EverString.isEmpty(formData.get("APP_DOC_NUM"))) {
				// 채번로직 변경. Parameter [화면에서 전달 받은 COMPANY_CD (없는 경우, ses.manageCd 또는 ses.companyCd), DOC_TYPE ]
				formData.put("APP_DOC_NUM", docNumService.getDocNumber(buyerCd, "APPDOC"));
			}
			if (EverString.isEmpty(appDocCnt) || appDocCnt.equals("0")) {
				appDocCnt = "1";
			} else {
				appDocCnt = String.valueOf(Integer.parseInt(appDocCnt) + 1);
			}
			
			Map<String, String> approvalHeader = new ObjectMapper().readValue(formData.get("approvalFormData"), Map.class);
			formData.put("APP_SUBJECT", approvalHeader.get("SUBJECT")); // 제목
			formData.put("APP_DOC_CONTENTS", approvalHeader.get("DOC_CONTENTS")); // 상신의견
			formData.put("APP_DOC_CNT", appDocCnt);
			formData.put("DOC_TYPE", "BID");
			
			// 결재상신 공통모듈 호출
			approvalService.doApprovalProcess(formData, formData.get("approvalFormData"), formData.get("approvalGridData"));
			
			// 결재상신 후, STOCBDHD에 결재문서번호, 결재문서차수를 Update한다.
			cbdi_Mapper.updateAppNum(formData);
		}

		rtnMap.put("buyerCd", buyerCd);
		rtnMap.put("bidNum", bidNum);
		rtnMap.put("bidCnt", bidCnt);
		rtnMap.put("rtnMsg", (signStatus.equals("T") ? msg.getMessage("0031") : msg.getMessage("0023")));
		
		return rtnMap;
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String cbdi0011_doDelete(Map<String, String> formData) throws Exception {
		
		// 결재상태가 "E", "P"인 경우, 삭제가 불가하다.
		String signStatusStr = getSignStatus(formData);
		if(EverString.nullToEmptyString(signStatusStr).equals("P")) {
			throw new Exception(msg.getMessageByScreenId("CBDI0011", "T033"));
		}
		
		if(EverString.nullToEmptyString(signStatusStr).equals("E")) {
			throw new Exception(msg.getMessageByScreenId("CBDI0011", "T035"));
		}
		
		// STOCBDHD : 삭제(DEL_FLAG = '1')
		cbdi_Mapper.cbdi0011_doDeleteBDHD(formData);
		// STOCBDPG : 삭제(DEL_FLAG = '1')
        cbdi_Mapper.cbdi0011_doDeleteBDPG(formData);
		// STOCBDAP : 삭제(DEL_FLAG = '1')
        cbdi_Mapper.cbdi0011_doDeleteBDAP(formData);
		// STOCBDDT : 삭제(DEL_FLAG = '1')
		cbdi_Mapper.cbdi0011_doDeleteBDDT(formData);
		
		String techEvType = EverString.nullToEmptyString(formData.get("TECH_EV_TYPE"));
		if(techEvType.equals("20")) {
			// STOCBDEU : 삭제(DEL_FLAG = '1')
			cbdi_Mapper.cbdi0011_doDeleteBDEU(formData);
		}
		
		// STOCPRDT.PROGRESS_CD를 원복한다.
		List<Map<String, String>> prInfoList = cbdi_Mapper.getPrSqs(formData);
		for(Map<String, String> prInfoData : prInfoList) {
			prInfoData.put("PROGRESS_CD", "2200"); // 접수완료
			cbdi_Mapper.updatePrProgressCd(prInfoData);
		}
		
		return msg.getMessage("0017");
	}

    /**
     * 화면명 : 입찰공고상세
     * 처리내용 : 입찰공고의 상세내용을 조회하는 Popup 화면.
     * 경로 : 고객사 > 구매관리 > 입찰관리 > 입찰공고 > 입찰공고상세
     */
    public Map<String, Object> cbdr0012_doSearch(Map<String, String> param) throws Exception {
        return cbdi_Mapper.cbdr0012_doSearch(param);
    }

	/**
	 * 화면명 : 취소공고생성
	 * 처리내용 : (입찰)취소공고를 작성하는 화면.
	 * 경로 : 고객사 > 구매관리 > 입찰관리 > 입찰공고 > 취소공고생성
	 */
	public Map<String, String> cbdr0013_doSearchHD(Map<String, String> param) throws Exception {

		// 일반정보
		Map<String, String> formData = cbdi_Mapper.cbdr0013_doSearchHD(param);
		formData.put("CANCEL_RMK_NUM", formData.get("CANCEL_RMK"));
		formData.put("CANCEL_RMK", largeTextService.selectLargeText(formData.get("CANCEL_RMK")));
		return formData;
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String cbdr0013_doSave(Map<String, String> formData) throws Exception {

		UserInfo userInfo = UserInfoManager.getUserInfo();
		Map<String, String> rtnMap = new HashMap<String, String>();

		String baseDataType = EverString.nullToEmptyString(formData.get("baseDataType"));
		String signStatus = EverString.nullToEmptyString(formData.get("SIGN_STATUS"));
		String oldSignStatus = EverString.nullToEmptyString(formData.get("OLD_SIGN_STATUS"));
		String buyerCd = EverString.nullToEmptyString(formData.get("BUYER_CD"));
		String bidNum = EverString.nullToEmptyString(formData.get("BID_NUM"));
		String bidCnt = EverString.nullToEmptyString(formData.get("BID_CNT"));

		String cancelRmkNum = largeTextService.saveLargeText(formData.get("CANCEL_RMK_NUM"), formData.get("CANCEL_RMK"));
		formData.put("CANCEL_RMK_NUM", cancelRmkNum);

		// 결재상태가 "E", "P"인 경우, 수정/결재요청이 불가하다.
		String signStatusStr = getSignStatus(formData);
		if(EverString.nullToEmptyString(signStatusStr).equals("P")) {
			throw new Exception(msg.getMessageByScreenId("CBDR0013", "T001"));
		}
		if(EverString.nullToEmptyString(signStatusStr).equals("E")) {
			throw new Exception(msg.getMessageByScreenId("CBDR0013", "T002"));
		}

		formData.put("BID_STATUS", "2303"); // BID_STATUS : 2303 (취소공고 작성중)

		// STOCRQHD [일반정보]
		if(baseDataType.equals("CancelBID")) {
			// 이전 차수의 데이터를 Select > Insert하여 +1 차수 생성.
			cbdi_Mapper.cbdr0013_doCancelBid(formData);
			cbdi_Mapper.cbdr0013_doCancelBidDT(formData);
			// 2021.07.05 취소공고시 지명경쟁 업체도 추가
			cbdi_Mapper.cbdr0013_doCancelBidAP(formData);
			
			// 2021.07.05 변경
			// 취소공고 : 결재완료(E)인 경우에만 이전차수의 진행상태를 '9999'로 변경한다.(EApprovalEndBid_Service.java)
			// 이전 차수의 BID_STATUS = '9999'로 Update.
			//formData.put("BID_STATUS", "9999");
			//cbdi_Mapper.setBidStatusForPreCnt(formData);
		}
		else {
			// 취소사유 Update.
			cbdi_Mapper.cbdr0013_doUpdateBid(formData);
		}

		// STOCBDHD, STOCBDDT에 저장(SIGN_STATUS = 'T' or 'P') 후, 결재요청인 경우 STOCSCTM 테이블에 저장.
		String appDocCnt = formData.get("APP_DOC_CNT");
		if (signStatus.equals("P")) {
			if (EverString.isEmpty(formData.get("APP_DOC_NUM"))) {
				formData.put("APP_DOC_NUM", docNumService.getDocNumber(buyerCd, "APPDOC"));
			}
			if (EverString.isEmpty(appDocCnt) || appDocCnt.equals("0")) {
				appDocCnt = "1";
			} else {
				appDocCnt = String.valueOf(Integer.parseInt(appDocCnt) + 1);
			}
			
			Map<String, String> approvalHeader = new ObjectMapper().readValue(formData.get("approvalFormData"), Map.class);
			formData.put("APP_SUBJECT", approvalHeader.get("SUBJECT")); // 제목
			formData.put("APP_DOC_CONTENTS", approvalHeader.get("DOC_CONTENTS")); // 상신의견
			formData.put("APP_DOC_CNT", appDocCnt);
			formData.put("DOC_TYPE", "CANCELBID");
			
			// 결재상신 공통모듈 호출
			approvalService.doApprovalProcess(formData, formData.get("approvalFormData"), formData.get("approvalGridData"));
			
			// 결재상신 후, STOCBDHD에 결재문서번호, 결재문서차수를 Update한다.
			cbdi_Mapper.updateAppNum(formData);
		}
		
		return (signStatus.equals("T") ? msg.getMessage("0031") : msg.getMessage("0023"));
	}
	
	/**
	 * 2021.07.05 : 취소공고 삭제
	 * @param formData
	 * @return
	 * @throws Exception
	 */
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String cbdi0013_doDelete(Map<String, String> formData) throws Exception {

		// 결재상태가 "E", "P"인 경우, 삭제가 불가하다.
		String signStatusStr = getSignStatus(formData);
		if(EverString.nullToEmptyString(signStatusStr).equals("P")) {
			throw new Exception(msg.getMessageByScreenId("CBDI0011", "T033"));
		}
		
		if(EverString.nullToEmptyString(signStatusStr).equals("E")) {
			throw new Exception(msg.getMessageByScreenId("CBDI0011", "T035"));
		}
		
		// STOCBDHD : 삭제
		cbdi_Mapper.cbdi0011_doDeleteCompBDHD(formData);
		// STOCBDAP : 삭제
        cbdi_Mapper.cbdi0011_doDeleteCompBDAP(formData);
		// STOCBDDT : 삭제
		cbdi_Mapper.cbdi0011_doDeleteCompBDDT(formData);
		
		return msg.getMessage("0017");
	}
	
	/**
	 * 화면명 : 기술평가실행
	 * 처리내용 : 기술평가를 진행하기 위하여 평가자에게 통보하는 화면.
	 * 경로 : 고객사 > 구매관리 > 입찰관리 > 입찰공고 > 기술평가실행
	 */
	public Map<String, String> cbdr0015_doSearchHD(Map<String, String> param) throws Exception {
		return cbdi_Mapper.cbdr0015_doSearchHD(param);
	}

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String cbdr0015_doEval(Map<String, String> formData, List<Map<String, Object>> gridDatas) throws Exception {

        // 진행상태를 체크한다.
        String maxProgressCd = cbdi_Mapper.getMaxProgressCd(formData);
        if(!EverString.nullToEmptyString(maxProgressCd).equals("100")) {
            throw new Exception(msg.getMessageByScreenId("CBDR0015", "T003"));
        }

        for(Map<String, Object> gridData : gridDatas) {

			gridData.put("BUYER_CD", formData.get("BUYER_CD"));
			gridData.put("EI_NUM", formData.get("EI_NUM"));
			gridData.put("PROGRESS_CD", "200"); // 평가진행중

        	if(gridData.get("EU_SQ") == null || EverString.nullToEmptyString(gridData.get("EU_SQ")) == "") {
				cbdi_Mapper.cbdi0011_doInsertEU(gridData);
				gridData.put("EU_SQ", String.valueOf(gridData.get("EU_SQ_KEY")));
			} else {
				cbdi_Mapper.cbdr0015_doEval(gridData);
			}
        }

        // 해당 입철건의 진행상태를 '기술평가'로 변경한다.
		//formData.put("BID_STATUS", "2367");
		//cbdi_Mapper.cbdr0015_setBidStatus(formData);

		// TO-DO
		// 평가자들에게 메일 발송!!!

        return msg.getMessageByScreenId("CBDR0015", "T005");
    }

	/**
	 * 화면명 : 지명경쟁 협력업체조회
	 * 처리내용 : 입찰요청서를 전송할 업체를 조회하는 Popup 화면.
	 * 경로 : 고객사 > 구매관리 > 입찰관리 > 입찰공고 > 입찰공고생성 > Popup
	 */
	public List<Map<String, Object>> cbdr0016_doSearchCandidate(Map<String, Object> param) throws Exception {
		return cbdi_Mapper.cbdr0016_doSearchCandidate(param);
	}

	/**
	 * 화면명 : 평가템플릿 선택
	 * 처리내용 : 시스템에 등록된 평가템플릿을 조회/선택할 수 있는 Popup 화면.
	 * 경로 : 고객사 > 구매관리 > 입찰관리 > 입찰공고 > 입찰공고생성 > Popup
	 */
	public List<Map<String, Object>> cbdi0016_doSearch(Map<String, String> param) throws Exception {

		List<Map<String, Object>> rtnList = new ArrayList<Map<String, Object>>();

		if(EverString.nullToEmptyString(param.get("EI_NUM")).equals("")) {
			rtnList = cbdi_Mapper.cbdi0016_doSearchEVTD(param);
		} else {
			rtnList = cbdi_Mapper.cbdi0016_doSearchBDEV(param);
		}
		return rtnList;
	}

	public List<Map<String, Object>> cbdi0016_doSearchEvalItemMgtDetail1(Map<String, String> param) throws Exception {

		List<Map<String, Object>> rtnList = new ArrayList<Map<String, Object>>();

		if(EverString.nullToEmptyString(param.get("EI_SQ_RT")).equals("") && EverString.nullToEmptyString(param.get("EI_NUM")).equals("")) {
			rtnList = cbdi_Mapper.cbdi0016_doSearchEvalItemMgtDetail1(param);
		} else {
			rtnList = cbdi_Mapper.cbdi0016_doSearchBDEI(param);
		}
		return rtnList;
	}

	public List<Map<String, Object>> cbdi0016_doSearchEvalItemMgtDetail2(Map<String, String> param) throws Exception {

		List<Map<String, Object>> rtnList = new ArrayList<Map<String, Object>>();

		if(EverString.nullToEmptyString(param.get("EI_SQ_RT")).equals("") && EverString.nullToEmptyString(param.get("EI_NUM")).equals("")) {
			rtnList = cbdi_Mapper.cbdi0016_doSearchEvalItemMgtDetail2(param);
		} else {
			rtnList = cbdi_Mapper.cbdi0016_doSearchBDEI(param);
		}
		return rtnList;
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String[] cbdi0016_doSaveH(Map<String, String> formData, List<Map<String, Object>> gridDatas) throws Exception {

		String[] arr = new String[2];
		boolean newFlag = false;
		UserInfo userInfo = UserInfoManager.getUserInfo();
		formData.put("BUYER_CD", userInfo.getCompanyCd());

		if (gridDatas.size() > 0) {
			double sumWeight = 0;
			for (Map<String, Object> gridData : gridDatas) {
				sumWeight = sumWeight + Double.parseDouble(String.valueOf(gridData.get("WEIGHT")));
			}
			if(sumWeight != 100) { throw new NoResultException(msg.getMessageByScreenId("CBDI0016", "MSG_007")); }
		}

		if (EverString.nullToEmptyString(formData.get("EI_NUM")).equals("")) {
			// 채번로직 변경. Parameter [화면에서 전달 받은 COMPANY_CD (없는 경우, ses.manageCd 또는 ses.companyCd), DOC_TYPE ]
			String eiNum = docNumService.getDocNumber(userInfo.getCompanyCd(), "EV");
			formData.put("EI_NUM", eiNum);
			newFlag = true;
		}

		if (gridDatas.size() > 0) {
			for (Map<String, Object> gridData : gridDatas) {
				gridData.put("BUYER_CD", userInfo.getCompanyCd());
				gridData.put("EI_NUM", formData.get("EI_NUM"));
				cbdi_Mapper.cbdi0016_doMergeBDEV(gridData);

				gridData.put("EI_SQ", String.valueOf(gridData.get("EI_SQ_KEY")));

				// newFlag가 true이면 최초 등록이므로 평가항목의 지표도 함께 Select >> Insert 한다.
				if(newFlag) {
					cbdi_Mapper.cbdi0016_doInsertBDEI(gridData);
				}
			}

			if(newFlag) {
				cbdi_Mapper.cbdi0016_doDeleteBDEUGarbage1(formData);
				cbdi_Mapper.cbdi0016_doDeleteBDEIGarbage2(formData);
				cbdi_Mapper.cbdi0016_doDeleteBDEVGarbage3(formData);
			}
		}
		arr[0] = formData.get("EI_NUM");
		arr[1] = msg.getMessage("0031");
		return arr;
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String cbdi0016_doDelete(Map<String, String> formData, List<Map<String, Object>> gridDatas) throws Exception {

		UserInfo userInfo = UserInfoManager.getUserInfo();

		for (Map<String, Object> gridData : gridDatas) {
			gridData.put("BUYER_CD", userInfo.getCompanyCd());
			gridData.put("EI_NUM", formData.get("EI_NUM"));
			cbdi_Mapper.cbdi0016_doDeleteBDEV(gridData);
			cbdi_Mapper.cbdi0016_doDeleteBDEI(gridData);
		}
		return msg.getMessage("0017");
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String[] cbdi0016_doSaveR(Map<String, String> formData, List<Map<String, Object>> gridDatas) throws Exception {

		String[] arr = new String[3];
		UserInfo userInfo = UserInfoManager.getUserInfo();
		formData.put("BUYER_CD", userInfo.getCompanyCd());

		if (EverString.nullToEmptyString(formData.get("EI_NUM")).equals("")) {
			// 채번로직 변경. Parameter [화면에서 전달 받은 COMPANY_CD (없는 경우, ses.manageCd 또는 ses.companyCd), DOC_TYPE ]
			String eiNum = docNumService.getDocNumber(userInfo.getCompanyCd(), "EV");
			formData.put("EI_NUM", eiNum);
		}

		Map<String, Object> mergeMap = new HashMap<String, Object>();
		mergeMap.putAll(formData);
		mergeMap.put("EI_SQ", formData.get("EI_SQ_RT"));
		mergeMap.put("EV_ITEM_TYPE_CD", formData.get("EV_ITEM_TYPE_CD_RT"));
		mergeMap.put("EV_ITEM_KIND_CD", formData.get("EV_ITEM_KIND_CD_RT"));
		mergeMap.put("EV_ITEM_SUBJECT", formData.get("EV_ITEM_SUBJECT_RT"));
		mergeMap.put("EV_ITEM_CONTENTS", formData.get("EV_ITEM_CONTENTS_RT"));
		mergeMap.put("SCALE_TYPE_CD", formData.get("SCALE_TYPE_CD_RT"));
		mergeMap.put("EV_ITEM_METHOD_CD", formData.get("EV_ITEM_METHOD_CD_RT"));
		mergeMap.put("WEIGHT", formData.get("WEIGHT_RT"));
		mergeMap.put("SORT_SQ", formData.get("SORT_SQ_RT"));

		cbdi_Mapper.cbdi0016_doMergeBDEV(mergeMap);

		mergeMap.put("EI_SQ", String.valueOf(mergeMap.get("EI_SQ_KEY")));

		if (gridDatas.size() > 0) {

			for (Map<String, Object> gridData : gridDatas) {
				gridData.put("BUYER_CD", userInfo.getCompanyCd());
				gridData.put("EI_NUM", mergeMap.get("EI_NUM"));
				gridData.put("EI_SQ", mergeMap.get("EI_SQ"));
				cbdi_Mapper.cbdi0016_doMergeBDEI(gridData);

				gridData.put("EI_ID_SQ", String.valueOf(gridData.get("EI_ID_SQ_KEY")));
			}
		}
		arr[0] = formData.get("EI_NUM");
		arr[1] = formData.get("EI_SQ");
		arr[2] = msg.getMessage("0031");
		return arr;
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String cbdi0016_doDeleteR(Map<String, String> formData, List<Map<String, Object>> gridDatas) throws Exception {

		UserInfo userInfo = UserInfoManager.getUserInfo();

		for (Map<String, Object> gridData : gridDatas) {
			gridData.put("BUYER_CD", userInfo.getCompanyCd());
			gridData.put("EI_NUM", formData.get("EI_NUM"));
			gridData.put("EI_SQ", formData.get("EI_SQ_RT"));
			cbdi_Mapper.cbdi0016_doDeleteR(gridData);
		}
		return msg.getMessage("0017");
	}

	/**
	 * 화면명 : 입찰등록
	 * 처리내용 : 입찰공고 중부터 입찰마감까지의 입찰공고 목록을 조회하여 마감/유찰처리한다.
	 * 경로 : 고객사 > 구매관리 > 입찰관리 > 입찰등록
	 */
	public List<Map<String, Object>> cbdi0020_doSearch(Map<String, String> param) throws Exception {
		return cbdi_Mapper.cbdi0020_doSearch(param);
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String cbdi0020_doChangeCtrl(String ctrlUserId, List<Map<String, Object>> gridDatas) throws Exception {

		for(Map<String, Object> gridData : gridDatas) {
			gridData.put("CTRL_USER_ID", ctrlUserId);
			cbdi_Mapper.cbdi0010_doChangeCtrl(gridData);
		}
		return msg.getMessageByScreenId("CBDI0020", "004");
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String cbdi0020_doFailBidding(List<Map<String, Object>> gridDatas) throws Exception {

		for(Map<String, Object> gridData : gridDatas) {

			gridData.put("BID_STATUS", "1300"); // 유찰
			cbdi_Mapper.cbdi0020_doFailBidding(gridData);

			// 구매의뢰의 진행상태를 '유찰'(1300)로 Update 한다.
			List<Map<String, Object>> prList = cbdi_Mapper.cbdi0020_getPrList(gridData);
			for(Map<String, Object> prData : prList) {
				prData.put("PROGRESS_CD", "1300"); // 유찰
				cbdi_Mapper.cbdi0020_doUpdatePrProgressCd(prData);
			}
		}
		return msg.getMessageByScreenId("CBDI0020", "008");
	}
	
	/**
     * 2020.12.02 기능 추가
     * 입찰마감 체크로직을 Server에서 체크하도록 변경
     */
    public Map<String, String> cbdi0020_doCheckBidClose(Map<String, String> param) throws Exception {
    	
    	Map<String, String> statusMap = cbdi_Mapper.cbdi0020_doCheckProgressCd(param);
        
        String rtnCode = "";
        String rtnMsg  = "";
        String bidStatus = statusMap.get("BID_STATUS");
        String oriBidStatus = statusMap.get("ORI_BID_STATUS");
        String estmFinishFlag = statusMap.get("ESTM_FINISH_FLAG");
        
        if( "100".equals(bidStatus) ) {
        	rtnCode = "CBDI0020_009";
        	rtnMsg  = msg.getMessageByScreenId("CBDI0020", "009");
        }
        else if( "2330".equals(oriBidStatus) ) {
        	rtnCode = "CBDI0020_010";
        	rtnMsg  = msg.getMessageByScreenId("CBDI0020", "010");
        }
        else if( !"Y".equals(estmFinishFlag) ) {
        	rtnCode = "CBDI0020_011";
        	rtnMsg  = msg.getMessageByScreenId("CBDI0020", "011");
        }
        
        Map<String, String> rtnMap = new HashMap<>();
        rtnMap.put("rtnCode", rtnCode);
        rtnMap.put("rtnMsg", rtnMsg);
        
        return rtnMap;
    }
    
    /**
     * 2020.12.02 기능 추가
     * 입찰 유찰 체크로직을 Server에서 체크하도록 변경
     */
    public Map<String, String> cbdi0020_doCheckFailBidding(Map<String, String> param) throws Exception {
    	
    	Map<String, String> statusMap = cbdi_Mapper.cbdi0020_doCheckProgressCd(param);
        
        String rtnCode = "";
        String rtnMsg  = "";
        String bidStatus = statusMap.get("BID_STATUS");
        String oriBidStatus = statusMap.get("ORI_BID_STATUS");
        
        if( "100".equals(bidStatus) ) {
        	rtnCode = "CBDI0020_009";
        	rtnMsg  = msg.getMessageByScreenId("CBDI0020", "009");
        }
        else if( "2330".equals(oriBidStatus) ) {
        	rtnCode = "CBDI0020_010";
        	rtnMsg  = msg.getMessageByScreenId("CBDI0020", "010");
        }
        
        Map<String, String> rtnMap = new HashMap<>();
        rtnMap.put("rtnCode", rtnCode);
        rtnMap.put("rtnMsg", rtnMsg);
        
        return rtnMap;
    }
    
	/**
	 * 화면명 : 입찰등록결과 등록
	 * 처리내용 : 협력업체의 입찰참가자격을 확인하여 입찰등록을 마감하는 화면
	 * 경로 : 고객사 > 구매관리 > 입찰관리 > 입찰등록 > 입찰등록결과 등록
	 */
	public Map<String, String> cbdi0021_doSearchHD(Map<String, String> param) throws Exception {
		return cbdi_Mapper.cbdi0021_doSearchHD(param);
	}

	public List<Map<String, Object>> cbdi0021_doSearch(Map<String, String> param) throws Exception {

		List<Map<String, Object>> rtnList = cbdi_Mapper.cbdi0021_doSearch(param);

		// for문을 돌며 서명값을 검증한다.
		for (Map<String, Object> rtnMap : rtnList) {

			String sSignData = String.valueOf(rtnMap.get("GUAR_AMT_CERTV"));
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

			rtnMap.put("CHECK_CERTV", (checkFlag ? "Y" : "N"));
		}
		return rtnList;
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String cbdi0021_doBidClose(Map<String, String> formData, List<Map<String, Object>> gridDatas) throws Exception {

		// 진행상태를 체크한다.
		String closePossibleFlag = cbdi_Mapper.getClosePossibleFlag(formData);
		if(!EverString.nullToEmptyString(closePossibleFlag).equals("Y")) {
			throw new Exception(msg.getMessageByScreenId("CBDI0021", "T003"));
		}

		for(Map<String, Object> gridData : gridDatas) {
			cbdi_Mapper.cbdi0021_doFinalFlagUpdate(gridData);
		}

		// 해당 입철건의 진행상태를 '마감'로 변경한다.
		String contType2 = formData.get("CONT_TYPE2");
		// 최저가, 적격심사 : 2350
		if(contType2.equals("LP") || contType2.equals("QE")) {
			formData.put("BID_STATUS", "2350");
		}
		// 분리(2단계) : 2353
		else if(contType2.equals("TD")) {
			formData.put("BID_STATUS", "2353");
		}
		/*
		// 동시(2단계), 협상 : 2363
		else if(contType2.equals("TS") || contType2.equals("NE")) {
			formData.put("BID_STATUS", "2363");
		}
		*/
		// 동시(2단계) : 2363
		else if(contType2.equals("TS")) {
			formData.put("BID_STATUS", "2363");
		}
		// 협상 : 2367
		else if(contType2.equals("NE")) {
			formData.put("BID_STATUS", "2367");
		}

		cbdi_Mapper.cbdr0015_setBidStatus(formData);

		return msg.getMessageByScreenId("CBDI0021", "T007");
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String cbdi0021_doFailBidding(Map<String, String> formData) throws Exception {

		Map<String, Object> data = new HashMap<String, Object>();
		data.putAll(formData);
		data.put("BID_STATUS", "1300"); // 유찰
		cbdi_Mapper.cbdi0020_doFailBidding(data);

		// 구매의뢰의 진행상태를 '유찰'(1300)로 Update 한다.
		List<Map<String, Object>> prList = cbdi_Mapper.cbdi0020_getPrList(data);
		for(Map<String, Object> prData : prList) {
			prData.put("PROGRESS_CD", "1300"); // 유찰
			cbdi_Mapper.cbdi0020_doUpdatePrProgressCd(prData);
		}

		return msg.getMessageByScreenId("CBDI0021", "T008");
	}

	/**
	 * 공통모듈
	 */
	public List<Map<String, String>> getCodeCombo(String codeType) throws Exception {

		List<Map<String, String>> list = new ArrayList<Map<String, String>>();

		Map<String, String> param = new HashMap<String, String>();
		param.put("CODE_TYPE", codeType);
		param.put("LANG_CD", UserInfoManager.getUserInfo().getLangCd());

		List<Map<String, String>> codes = cbdi_Mapper.getComCodeAndText(param);
		for (Map<String, String> code : codes) {
			Map<String, String> map = new HashMap<String, String>();
			map.put("value", code.get("CODE"));
			map.put("text", code.get("CODE_DESC"));
			list.add(map);
		}
		return list;
	}

    public String getSignStatus(Map<String, String> param) throws Exception {
        return cbdi_Mapper.getSignStatus(param);
    }

	private int saveVendor(Map<String, String> formData) throws Exception {

		int rtn = -1;
		int bdapIdx = 0;
		List<Map<String, String>> bdapList = new ArrayList<Map<String, String>>();

		if (StringUtils.isNotEmpty(formData.get("VENDOR_CDS"))) {

			String[] vendorArgs = EverString.nullToEmptyString(formData.get("VENDOR_CDS")).split(",");

			// Add bdapList
			for(int i = 0; i < vendorArgs.length; i++) {
				Map<String, String> tmpMap = new HashMap<String, String>();
				tmpMap.put("BUYER_CD", formData.get("BUYER_CD"));
				tmpMap.put("BID_NUM", formData.get("BID_NUM"));
				tmpMap.put("BID_CNT", formData.get("BID_CNT"));
				tmpMap.put("VENDOR_CD", vendorArgs[i]);
				bdapList.add(bdapIdx, tmpMap);
				bdapIdx++;
			}
		}

		if(bdapList.size() <= 0) { throw new Exception(msg.getMessageByScreenId("CBDI0011", "T034")); }

		cbdi_Mapper.cbdi0011_doDeleteAP(formData);

		// STOCBDAP [입찰 참가신청정보] Insert
		for(Map<String, String> bdapData : bdapList) {
			cbdi_Mapper.cbdi0011_doInsertAP(bdapData);
		}
		rtn = 1;
		return rtn;
	}

	private int saveTechEvUser(Map<String, String> formData, List<Map<String, Object>> gridDatasE) throws Exception {

		int rtn = -1;

		cbdi_Mapper.cbdi0011_doDeleteAllEU(formData);

		// STOCBDEU [입찰 기술평가자] Insert
		for(Map<String, Object> gridDataE : gridDatasE) {
			gridDataE.put("BUYER_CD", formData.get("BUYER_CD"));
			gridDataE.put("EI_NUM", formData.get("EI_NUM"));
			gridDataE.put("PROGRESS_CD", "100"); // 평가생성
			cbdi_Mapper.cbdi0011_doInsertEU(gridDataE);

			gridDataE.put("EU_SQ", String.valueOf(gridDataE.get("EU_SQ_KEY")));
		}
		rtn = 1;
		return rtn;
	}
	
	public Map<String, Object> cbdi0022_doSearch(Map<String, String> param) throws Exception {
		return cbdi_Mapper.cbdi0022_doSearch(param);
	}
	
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String cbdi0022_doSave(Map<String, String> formData) throws Exception {
        
		String screenId = EverString.nullToEmptyString(formData.get("screenId"));
		System.out.println("screenId =====> " + screenId);
		String status = "";
		
		if(screenId.equals("CBDI0020")) { 
			status = cbdi_Mapper.getBidAppStatus(formData);
			System.out.println("status ====> " + status);
	        if(!status.equals("100")) {
	            throw new Exception(msg.getMessageByScreenId("CBDI0022", "003"));
	        }
		} else {
			status = cbdi_Mapper.getBidStatus(formData);
			System.out.println("status ====> " + status);
	        if(!status.equals("400")) {
	            throw new Exception(msg.getMessageByScreenId("CBDI0022", "003"));
	        }
		}
		
		cbdi_Mapper.cbdi0022_doSaveHD(formData);
		cbdi_Mapper.cbdi0022_doSavePG(formData);			
		
		return msg.getMessageByScreenId("CBDI0022", "002");
	}
}
