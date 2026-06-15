package com.st_ones.eversrm.eApproval.service;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.common.mail.service.EverMailService;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.sms.service.EverSmsService;
import com.st_ones.common.util.clazz.EverFile;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.common.util.service.LargeTextService;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.exception.ApprovalException;
import com.st_ones.everf.serverside.info.BaseInfo;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.everf.serverside.util.clazz.AuthorityIgnore;
import com.st_ones.eversrm.eApproval.EApprovalMapper;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2014 ST-Ones CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : EApprovalService.java
 * @date 2018. 2. 06.
 * @version 1.0
 * @see
 */
@Service(value = "eApprovalService")
public class EApprovalService extends BaseService {

	@Autowired private MessageService msg;
	@Autowired private EApprovalMapper eApprovalMapper;
	@Autowired private EndApprovalService endApprovalService;
	@Autowired private LargeTextService largeTextService;
    @Autowired private EverSmsService eversmsservice;
    @Autowired private EverMailService evermailservice;
    
    Logger logger = LoggerFactory.getLogger(this.getClass());
    
	public List<Map<String, Object>> selectPath(Map<String, String> param) throws Exception {
		return eApprovalMapper.selectPath(param);
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String insertPath(Map<String, Object> formData, List<Map<String, Object>> gridDatas) throws Exception {
		String pathNo = eApprovalMapper.getPathNo(formData);

		if("1".equals(formData.get("MAIN_PATH_FLAG"))){
			eApprovalMapper.updatePathMainPathFlag(formData);
		}
		formData.put("PATH_NO", pathNo);
		eApprovalMapper.insertPath(formData);

		eApprovalMapper.deleteLULP(formData);
		for (Map<String, Object> gridData : gridDatas) {
			gridData.put("PATH_NO", pathNo);
			eApprovalMapper.insertPathDetail(gridData);
		}

		return msg.getMessage("0015");
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String updatePath(Map<String, Object> formData, List<Map<String, Object>> gridDatas) throws Exception {
		String pathNo = (String) formData.get("PATH_NO");

		if("1".equals(formData.get("MAIN_PATH_FLAG"))){
			eApprovalMapper.updatePathMainPathFlag(formData);
		}

		eApprovalMapper.updatePath(formData);

		eApprovalMapper.deleteLULP(formData);
		for (Map<String, Object> gridData : gridDatas) {
			if (!gridData.get("INSERT_FLAG").toString().equals("D")) {
				gridData.put("PATH_NO", pathNo);
				eApprovalMapper.insertPathDetail(gridData);
			}
		}

		return msg.getMessage("0016");
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String deletePath(List<Map<String, Object>> gridDatas) throws Exception {

		for (Map<String, Object> gridData : gridDatas) {
			eApprovalMapper.deletePathDetail(gridData);
			eApprovalMapper.deletePath(gridData);
		}

		return msg.getMessage("0017");
	}

	public List<Map<String, Object>> selectPathDetail(Map<String, String> param) throws Exception {
		return eApprovalMapper.selectPathDetail(param);
	}

	public List<Map<String, Object>> selectPathPopup(Map<String, String> param) throws Exception {
		return eApprovalMapper.selectPathPopup(param);
	}

	public String getMatchUserInfoByName(String userName) throws ApprovalException, IOException {

		int count = matchUserCountByName(userName);

		if (count != 1) {
			if (count > 1) {
				ApprovalException e = new ApprovalException("More Than 1 Result");
				e.setSelectedUserCount(count);
				throw e;
			}
			ApprovalException e = new ApprovalException("No Result");
			e.setSelectedUserCount(count);
			throw e;
		}
		Map<String, String> userInfo = getUserInfoByName(userName);
		return new ObjectMapper().writeValueAsString(userInfo);
	}

	/**
	 * userInfo by userName
	 * @param userName
	 * @return
	 * @throws Exception
	 */
	private Map<String, String> getUserInfoByName(String userName) {
		HashMap<String, String> hashMap = new HashMap<String, String>();
		hashMap.put("USER_NAME", userName);
		return eApprovalMapper.getUserInfoByName(hashMap);
	}

	/**
	 * userCount with name
	 * @param userName
	 * @return
	 * @throws Exception
	 */
	private int matchUserCountByName(String userName) {
		HashMap<String, String> hashMap = new HashMap<String, String>();
		hashMap.put("USER_NAME", userName);
		return eApprovalMapper.matchUserCountByName(hashMap);
	}

	/**
	 * Request Approval Service
	 * @param docInfo APP_DOC_NO, APP_DOC_CNT, DOC_TYPE, PROCEEDING_FLAG를 설정 해야 합니다.
	 * @param strApprovalHeaderData 공통 결재 요청 팝업으로 부터 결재 Header Data 입니다.
	 * @param strApprovalDetailData 공통 결재 요청 팝업으로 부터 결재 Detail Data 입니다.
	 * @throws ApprovalException
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@AuthorityIgnore
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public void doApprovalProcess(Map<String, String> docInfo, String strApprovalFormData, String strApprovalGridData) throws Exception {

		/*System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
		System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
		System.out.println(">>>>>>>>>>>>>>> strApprovalFormData : " + strApprovalFormData);
		System.out.println(">>>>>>>>>>>>>>> strApprovalGridData : " + strApprovalGridData);
		System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
		System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");*/

		// 해당 결재문서번호가 STOCSCTM에 존재하는지 체크
		String previousUnAcceptableStatus = previousUnacceptableStatus(docInfo);

		if (EverString.equals(previousUnAcceptableStatus, "P")) {
			throw new ApprovalException("해당 문서는 현재 결재 진행중입니다.");
		}

		Map<String, String> approvalHeader = new ObjectMapper().readValue(strApprovalFormData, Map.class);
		List<Map<String, String>> approvalDetails = new ObjectMapper().readValue(strApprovalGridData, List.class);

		if(EverString.isNotEmpty(docInfo.get("PROCEEDING_FLAG"))){
			docInfo.put("SIGN_STATUS",docInfo.get("PROCEEDING_FLAG"));
		}

		if(EverString.isEmpty(docInfo.get("SIGN_STATUS"))){
			throw new ApprovalException("SIGN_STATUS is null");
		}

		approvalHeader.putAll(docInfo);
        String nextSignUserId = "";
		// String nextSignUserId = approvalDetails.get(0).get("SIGN_USER_ID");

        for(int i = 0; i < approvalDetails.size(); i++) {
		    if(!"CC".equals(approvalDetails.get(i).get("SIGN_REQ_TYPE"))) {
                nextSignUserId = approvalDetails.get(i).get("SIGN_USER_ID");
                break;
            }
        }

		approvalHeader.put("NEXT_SIGN_USER_ID", nextSignUserId);
		approvalHeader.put("CONTENTS_TEXT_NUM", largeTextService.saveLargeText(approvalHeader.get("CONTENTS_TEXT_NUM"), approvalHeader.get("DOC_CONTENTS")));

		eApprovalMapper.insertSTOCSCTM(approvalHeader);

		for (Map<String, String> approvalDetail : approvalDetails) {
			approvalDetail.putAll(docInfo);
			eApprovalMapper.insertSTOCSCTP(approvalDetail);
		}

		/* 결재요청 메일보내기 */
		Map<String, String> param = new HashMap<String, String>();
		param.put("BUYER_CD", approvalHeader.get("BUYER_CD"));
		param.put("APP_DOC_NUM", approvalHeader.get("APP_DOC_NUM"));
		param.put("APP_DOC_CNT", approvalHeader.get("APP_DOC_CNT"));
		Map<String, String> receiverInfo = eApprovalMapper.getReceiverInfo(param);
		eApprovalMailSend("P", receiverInfo, approvalHeader.get("BUYER_CD"), approvalHeader.get("APP_DOC_NUM"), approvalHeader.get("APP_DOC_CNT"));
	}

	@AuthorityIgnore
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public void sendDoApprovalNotice(Map<String, String> docInfo, String strApprovalGridData) throws Exception {
		BaseInfo userInfo = UserInfoManager.getUserInfo();
		String appDocNo = docInfo.get("APP_DOC_NO");
		String refModuleCode = "AP";
		@SuppressWarnings("unchecked")
		List<Map<String, String>> approvalDetails = new ObjectMapper().readValue(strApprovalGridData, List.class);
		String nextSignUserId = approvalDetails.get(0).get("SIGN_USER_ID");
		// Wise Alarm
		Map<String, String> map = new HashMap<String, String>();
		map.put("appDocNo", appDocNo);
		//requestAlarm.approvalRequestAlarm(map, nextSignUserId);
	}

	/**
	 * When the document is approved or proceeded then return the status of the approval process
	 * @param docInfo<br>
	 * HOUSE_CODE, APP_DOC_NO
	 * @return
	 * Approved then E, Proceeding then P others null
	 * @throws Exception
	 */
	private String previousUnacceptableStatus(Map<String, String> docInfo) {
		List<String> signStatusHistory = eApprovalMapper.selectSTOCSCTPSignStatusHistory(docInfo);
		if (signStatusHistory.isEmpty()) {
			return null;
		}
		if (signStatusHistory.contains("P")) {
			return "P";
		}
		return null;
	}

	/**
	 * 결재 마스터 조회
	 * HOUSE_CODE, APP_DOC_NO, APP_DOC_CNT
	 * @param approvalInfoKey
	 * @return
	 * @throws Exception
	 * @throws ApprovalException
	 */
	public Map<String, String> selectApprovalInfoHeader(Map<String, String> approvalInfoKey) throws Exception {
		if (!isAuthorized(approvalInfoKey)) {
			throw new ApprovalException("Un Authorized Access");
		}
		return eApprovalMapper.selectSTOCSCTM(approvalInfoKey);
	}

	public String selectMySignStatus(Map<String, String> formDataParam) {
		return eApprovalMapper.selectMySignStatus(formDataParam);
	}

	/**
	 * 결재 상세 조회
	 * HOUSE_CODE, APP_DOC_NO, APP_DOC_CNT
	 * @param formData
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> selectApprovalInfoDetail(Map<String, String> formData) throws Exception {
		return eApprovalMapper.selectSTOCSCTP(formData);
	}

	public boolean isAuthorized(Map<String, String> approvalInfoKey) throws Exception {
		int authorizedUserCount = eApprovalMapper.getAuthorizedCount(approvalInfoKey);
        return authorizedUserCount > 0;
    }

	/**
	 * approve document
	 * @param formData
	 * @return
	 * @throws Exception
	 * @throws ApprovalException
	 */
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String approve(Map<String, String> appParam) throws Exception {

		UserInfo userInfo = UserInfoManager.getUserInfo();
		String buyerCd    = appParam.get("BUYER_CD");
		String appDocNum  = appParam.get("APP_DOC_NUM");
		String appDocCnt  = appParam.get("APP_DOC_CNT");
		
		// 결재를 했는데 또 하는 경우 발생 (결재순번에따라 1>2>3>4 순으로 결재를 진행해야하나, 1>2>3>2로 중복결재하는 이슈 발생
		// 중복 결재여부 체크로직 추가
		Map<String, String> signStatus = eApprovalMapper.selectMySignStatusAndTime(appParam);
		boolean isDupSign = signStatus.get("MY_SIGN_STATUS").equals("E") && appParam.get("SIGN_STATUS").equals("E");
		if(isDupSign) {
			System.out.println("isDupSign" + isDupSign);
			return "문서번호 " + appDocNum  + " 건은 이미 " + signStatus.get("SIGN_DATE")  +" 에 결재 완료한 건 입니다"; 
		}
		
		// 결재자가 결재요청상세 화면을 오픈한 상태에서 해당 결재건이 상신취소 된 경우 결재가 이뤄지지 않도록 체크로직 추가
		Map<String, String> Status = eApprovalMapper.selectSTOCSCTM(appParam);
		boolean isCancelSign = Status.get("SIGN_STATUS").equals("C");
		if(isCancelSign) {
			System.out.println("isCancelSign" + isCancelSign);
			return "문서번호 " + appDocNum  + " 건은 상신 취소된 건 입니다"; 
		}
		
		eApprovalMapper.updateSTOCSCTP(appParam);
		String nextUserId = eApprovalMapper.getNextSignUserId(appParam);
		appParam.put("NEXT_SIGN_USER_ID", nextUserId);
		
		Map<String, String> sctmInfo = eApprovalMapper.selectSTOCSCTM(appParam);
		Map<String, String> receiverInfo = new HashMap<String, String>();

		if (nextUserId != null) {
			eApprovalMapper.setNextUser(appParam);
			
			try {
				/* 다음 결재자한테 메일 보내기 */
				String linkUrl = PropertiesManager.getString("eversrm.urls.maintain.real") ;
		        
				//EMAIL
				String subject = "[전자구매시스템] [" + sctmInfo.get("BUYER_NM") + "] " + sctmInfo.get("REG_USER_NM") + "님이 결재문서 [" + sctmInfo.get("SUBJECT") + "]을 상신하였습니다";
				
		        Map<String,String> mailMap = new HashMap<String,String>();
		        mailMap.put("SUBJECT", subject);
		        
		        StringBuffer content = new StringBuffer(255);
		        content.append("<BR> 안녕하세요.                     												");
		        content.append("<BR> ["+sctmInfo.get("BUYER_NM")+"] "+sctmInfo.get("NEXT_SIGN_USER_NM")+" 님.	");
		        content.append("<BR>                   															");
		        content.append("<BR> 아래와 같이 결재문서가 상신되었습니다                   								");
		        content.append("<BR> 제목 : [" + sctmInfo.get("SUBJECT") + "]										");
		        content.append("<BR> 상신자 : [" + sctmInfo.get("REG_USER_NM") + "]                   				");
		        content.append("<BR>                   															");
		        content.append("<BR> 전자구매시스템에 <a href=\""+linkUrl+"\" target=\"newP\">로그인</a> 하시어, 세부내용을 확인 후 [승인/반려] 해주십시오.  ");
		        content.append("<BR>                   															");
		        content.append("<BR> 감사합니다.          															");
		        
		        mailMap.put("CONTENTS", content.toString());
		        mailMap.put("REF_MODULE_CD", "MSIGN02");
		        mailMap.put("RECV_USER_ID", nextUserId);
		        mailMap.put("REF_NUM", appDocNum);
		        //개발테스트시에는 잠시 주석
		        evermailservice.SendMail(mailMap);
				
				//SMS
		        Map<String,String> smsMap = new HashMap<String,String>();
		        smsMap.put("CONTENTS", subject);
		        smsMap.put("REF_MODULE_CD", "SSIGN02");
		        smsMap.put("REF_NUM", appDocNum);
		        smsMap.put("RECV_USER_ID", nextUserId);
		        
		        // 2021.06.29 : 결재상신 SMS 수수료 부과하기
		        smsMap.put("CORP_NO", sctmInfo.get("CORP_NO"));			// 고객사 사업자번호
				smsMap.put("BRC", sctmInfo.get("BRC"));					// 고객사 부서
				smsMap.put("EPRO_PS_DSC", "1");							// 1  : 구매
	            smsMap.put("EPRO_RATE_DSC", "01");						// 01 : 최초
				smsMap.put("APLY_DT", sctmInfo.get("APLY_DT"));			// 발생일 YYYYMMDD
				smsMap.put("USER_ID", sctmInfo.get("USER_ID"));			// 고객사 보내는사람 ID
				smsMap.put("CONT_TBL_ID", "STOCSCTM");					// 검증 테이블
				smsMap.put("CONT_TBL_PK", sctmInfo.get("CONT_TBL_PK")); // 검증 조건(협력사별 입찰번호)
				smsMap.put("tmp", sctmInfo.get("CONT_TBL_PK"));			// myBatis 버그 해결을 위한 무의미한, 유니크한 값.
				smsMap.put("payFlag", "Y");								// SMS 과금여부
				//개발테스트시에는 잠시 주석
		        eversmsservice.sendSmsNhe(smsMap);
			}
			catch (Exception ex) {
			    logger.error("결재상신 관련 메일&문자 발송 오류 : " + ex.getMessage());
			}
			
			return msg.getMessageForService(this, "approved");
		}

		/**
		 * 결재승인완료 메일 보내기 [상신자, 참조자]
		 */
		Map<String, String> param = new HashMap<String, String>();
		param.put("BUYER_CD", buyerCd);
		param.put("APP_DOC_NUM", appDocNum);
		param.put("APP_DOC_CNT", appDocCnt);
		
		receiverInfo = eApprovalMapper.getEndReceiverInfo(param);
		eApprovalMailSend("E", receiverInfo, buyerCd, appDocNum, appDocCnt);

		param.put("USER_TYPE", userInfo.getUserType());
//		List<Map<String, String>> ccInfos = eApprovalMapper.getCcReceiverInfo(param);
//		for(Map<String, String> ccInfo : ccInfos) {
//			eApprovalMailSend("CC", ccInfo, buyerCd, appDocNum, appDocCnt);
//		}

		// end Approval Process
		// 2021.03.25 추가
		// 결재승인시 상신의견 및 첨부파일 저장
		if( EverString.isNotEmpty(appParam.get("CONTENTS_TEXT_NUM")) || EverString.isNotEmpty(appParam.get("DOC_CONTENTS")) ) {
			appParam.put("CONTENTS_TEXT_NUM", largeTextService.saveLargeText(appParam.get("CONTENTS_TEXT_NUM"), appParam.get("DOC_CONTENTS")));
		}
		eApprovalMapper.updateSTOCSCTM(appParam);
		
		String docType = appParam.get("DOC_TYPE");
		return endApprovalService.doAfterApprove(docType, buyerCd, appDocNum, appDocCnt,sctmInfo.get("REG_USER_ID"));
	}

	/**
	 * 결재 반려, 사용자 서비스 콜, 다음 결재자 승인 정보 NULL
	 * SIGN_STATUS, DOC_TYPE, APP_DOC_NO, APP_DOC_CNT
	 * @param formData
	 * @return
	 * @throws Exception
	 * @throws ApprovalException
	 */
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String reject(Map<String, String> appParam) throws Exception {
		
		String docType = appParam.get("DOC_TYPE");
		String buyerCd = appParam.get("BUYER_CD");
		String appDocNum = appParam.get("APP_DOC_NUM");
		String appDocCnt = appParam.get("APP_DOC_CNT");
		
		// 결재자가 결재요청상세 화면을 오픈한 상태에서 해당 결재건이 상신취소 된 경우 결재가 이뤄지지 않도록 체크로직 추가
		Map<String, String> Status = eApprovalMapper.selectSTOCSCTM(appParam);
		boolean isCancelSign = Status.get("SIGN_STATUS").equals("C");
		if(isCancelSign) {
			System.out.println("isCancelSign" + isCancelSign);
			return "문서번호 " + appDocNum  + " 건은 상신 취소된 건 입니다"; 
		}
		
		eApprovalMapper.updateSTOCSCTP(appParam);
		eApprovalMapper.updateSTOCSCTM(appParam);

		appParam.put("SIGN_PATH_SQ", eApprovalMapper.getNextSignPathSeq(appParam));
		
		/**
		 * 반려통보 메세지 보내기.
		 */
		Map<String, String> addUserId = eApprovalMapper.selectSTOCSCTM(appParam);

		Map<String, String> param = new HashMap<String, String>();
		param.put("BUYER_CD", buyerCd);
		param.put("APP_DOC_NUM", appDocNum);
		param.put("APP_DOC_CNT", appDocCnt);

		Map<String, String> receiverInfo = eApprovalMapper.getEndReceiverInfo(param);
		eApprovalMailSend("R", receiverInfo, buyerCd, appDocNum, appDocCnt);

		Map<String, String> approvalRequestInfo = eApprovalMapper.selectSTOCSCTM(appParam);
		return endApprovalService.doAfterReject(docType, buyerCd, appDocNum, appDocCnt,approvalRequestInfo.get("REG_USER_ID"));
	}

	public List<Map<String, String>> getMyPath() {
		return eApprovalMapper.getMyPath(new HashMap<String, String>());
	}

	public List<Map<String, String>> selectLULP(HashMap<String, String> approvalPathKey) {
		return eApprovalMapper.selectLULP(approvalPathKey);
	}

	/**
	 * 처리내용 : 로그인한 사용자가 상신한 결제문서들을 상신 취소하는 기능.
	 * 경로 : 고객사 > 전자결재 > 전자결재 > 결재상신함
	 */
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String cancelApprovalProcess(Map<String, String> param) throws Exception {

        if (!EverString.equals(param.get("SIGN_STATUS"), "P")) {
            throw new Exception(msg.getMessageForService(this, "cannotCancel_01"));
        }
        
        /** 2021.06.10 전결권자 휴가등 부재중으로 인하여 결재가 이루어지지 않는 경우 상신취소를 위해 결재자 List에 결재중인 결재자가 있는 경우의 조건 제외
        * int incorrectCount = eApprovalMapper.isCancellable(param);
        * if (incorrectCount != 0) {
        *     throw new Exception(msg.getMessageForService(this, "cannotCancel_02"));
        * }
        */

        int incorrectCountSctm = eApprovalMapper.isCancellableSctm(param);
        if (incorrectCountSctm != 0) {
            throw new Exception(msg.getMessageForService(this, "cannotCancel_03"));
        }

		param.put("SIGN_STATUS", "C");
		eApprovalMapper.updateSTOCSCTM(param);

		String docType = param.get("DOC_TYPE");
		String buyerCd = param.get("BUYER_CD");
		String appDocNum = param.get("APP_DOC_NUM");
		String appDocCnt = param.get("APP_DOC_CNT");
		String rtnMsg = endApprovalService.doAfterCancel(docType, buyerCd, appDocNum, appDocCnt);

		return msg.getMessageForService(this, "cancel");
	}

	public Map<String, String> selectPreviousInfoForm(Map<String, String> approvalInfoKey) throws Exception {

		Map<String, String> selectSTOCSCTM = eApprovalMapper.selectSTOCSCTM(approvalInfoKey);
		if (selectSTOCSCTM == null) {
			return null;
		}

		String appDocCnt = eApprovalMapper.getCurrentDocCount(approvalInfoKey);
		approvalInfoKey.put("APP_DOC_CNT", appDocCnt);
		if (!isAuthorized(approvalInfoKey)) {
			throw new ApprovalException("Un Authorized Access");
		}
		return selectSTOCSCTM;
	}

	public List<Map<String, String>> selectPreviousInfoGrid(Map<String, String> approvalInfoKey) throws Exception {

		String appDocCnt = eApprovalMapper.getCurrentDocCount(approvalInfoKey);
		approvalInfoKey.put("APP_DOC_CNT", appDocCnt);

		return eApprovalMapper.selectSTOCSCTP(approvalInfoKey);
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public void deleteSCTM(Map<String, String> appDocNo) {
		
		eApprovalMapper.deleteSCTM(appDocNo);
		eApprovalMapper.deleteSCTP(appDocNo);
	}

	public Map<String, String> selectPathDetail1(Map<String, String> param) {
		
		return eApprovalMapper.selectPathDetail1(param);
	}

	public List<Map<String, String>> selectMainPathDetail() throws Exception {
		
		BaseInfo baseInfo = UserInfoManager.getUserInfoImpl();
		Map<String, String> reqMap = new HashMap<String, String>();
		reqMap.put("USER_ID", baseInfo.getUserId());
		return eApprovalMapper.selectMainPathDetail(reqMap);
	}

	private void eApprovalMailSend(String approvalStatus, Map<String, String> receiverInfo, String buyerCd, String approvalNum, String appDocCnt) throws Exception {

		// E-Mail 발송
		String maintainUrl = "";
		// 개발 운영 모드 설정
		boolean isDevelopmentMode = PropertiesManager.getBoolean("eversrm.system.developmentFlag");
		if(isDevelopmentMode){
			maintainUrl = PropertiesManager.getString("eversrm.urls.maintain.dev");
		} else {
			maintainUrl = PropertiesManager.getString("eversrm.urls.maintain.real");
		}

		String templatePath = PropertiesManager.getString("eversrm.system.mailTemplatePath");
		String templateFileNm = "";
		String fileContents = "";

		Map<String, String> param = new HashMap<String, String>();
		param.put("BUYER_CD", buyerCd);
		param.put("APP_DOC_NUM", approvalNum);
		param.put("APP_DOC_CNT", appDocCnt);
		List<Map<String, String>> pathList = eApprovalMapper.getSignPathList(param);

		String appSubject = "";
		if(pathList.size() > 0) {
			appSubject = EverString.nullToEmptyString(pathList.get(0).get("SUBJECT"));
		}

		if(approvalStatus.equals("P")) {
			templateFileNm = templatePath + PropertiesManager.getString("eversrm.system.APPROVAL_TemplateFileName");
			fileContents = EverFile.fileReadByOffsetByEncoding(templateFileNm, "UTF-8");
			fileContents = EverString.replace(fileContents, "$TITLE$", receiverInfo.get("RECV_USER_NM") + " 님. 결재문서가 도착하였습니다.");
			fileContents = EverString.replace(fileContents, "$APP_CONTENTS$", "시스템에 로그인 하시어 해당 문건 검토 후 결재 승인 바랍니다.");
		}
		else if(approvalStatus.equals("E")) {
			templateFileNm = templatePath + PropertiesManager.getString("eversrm.system.END_TemplateFileName");
			fileContents = EverFile.fileReadByOffsetByEncoding(templateFileNm, "UTF-8");
			fileContents = EverString.replace(fileContents, "$TITLE$", receiverInfo.get("RECV_USER_NM") + " 님. 상신하신 결재문서가 승인 처리 되었습니다.");
			fileContents = EverString.replace(fileContents, "$SIGN_STATUS$", "승인");
		}
		else if(approvalStatus.equals("R")) {
			templateFileNm = templatePath + PropertiesManager.getString("eversrm.system.END_TemplateFileName");
			fileContents = EverFile.fileReadByOffsetByEncoding(templateFileNm, "UTF-8");
			fileContents = EverString.replace(fileContents, "$TITLE$", receiverInfo.get("RECV_USER_NM") + " 님. 상신하신 결재문서가 반려 처리 되었습니다.");
			fileContents = EverString.replace(fileContents, "$SIGN_STATUS$", "반려");
		}
		else if(approvalStatus.equals("CC")) {
			templateFileNm = templatePath + PropertiesManager.getString("eversrm.system.APPROVAL_TemplateFileName");
			fileContents = EverFile.fileReadByOffsetByEncoding(templateFileNm, "UTF-8");
			fileContents = EverString.replace(fileContents, "$TITLE$", receiverInfo.get("RECV_USER_NM") + " 님. 결재문서[참조]가 도착하였습니다.");
			fileContents = EverString.replace(fileContents, "$APP_CONTENTS$", "시스템에 로그인 하시어 해당 문건을 확인 바랍니다.");
		}
		fileContents = EverString.replace(fileContents, "$APP_DOC_NUM$", approvalNum);
		fileContents = EverString.replace(fileContents, "$APP_SUBJECT$", appSubject);
		fileContents = EverString.replace(fileContents, "$SIGN_USER_NM$", receiverInfo.get("RECV_USER_NM"));

		String tblBody = "<tbody>";
		String enter = "\n";
		if(pathList.size() > 0) {
			for (Map<String, String> pathData : pathList) {
				String tblRow = "<tr>"
						+ enter + "<td style='word-break:break-all;padding:5px 6px 6px 6px;color:#404141;text-align:center;font-size:12px;border-left:1px solid #cdcdcd;border-right:1px solid #cdcdcd;border-bottom:1px solid #cdcdcd'>" + EverString.nullToEmptyString(pathData.get("USER_NM")) + "</th>"
						+ enter + "<td style='word-break:break-all;padding:5px 6px 6px 6px;color:#404141;text-align:left;font-size:12px;border-left:1px solid #cdcdcd;border-right:1px solid #cdcdcd;border-bottom:1px solid #cdcdcd'>" + EverString.nullToEmptyString(pathData.get("DEPT_NM")) + "</th>"
						+ enter + "<td style='word-break:break-all;padding:5px 6px 6px 6px;color:#404141;text-align:left;font-size:12px;border-left:1px solid #cdcdcd;border-right:1px solid #cdcdcd;border-bottom:1px solid #cdcdcd'>" + EverString.nullToEmptyString(pathData.get("DUTY_NM")) + "</th>"
						+ enter + "<td style='word-break:break-all;padding:5px 6px 6px 6px;color:#404141;text-align:center;font-size:12px;border-left:1px solid #cdcdcd;border-right:1px solid #cdcdcd;border-bottom:1px solid #cdcdcd'>" + EverString.nullToEmptyString(pathData.get("SIGN_REQ_TYPE")) + "</th>"
						+ enter + "<td style='word-break:break-all;padding:5px 6px 6px 6px;color:#404141;text-align:center;font-size:12px;border-left:1px solid #cdcdcd;border-right:1px solid #cdcdcd;border-bottom:1px solid #cdcdcd'>" + EverString.nullToEmptyString(pathData.get("SIGN_STATUS")) + "</th>"
						+ enter + "<td style='word-break:break-all;padding:5px 6px 6px 6px;color:#404141;text-align:center;font-size:12px;border-left:1px solid #cdcdcd;border-right:1px solid #cdcdcd;border-bottom:1px solid #cdcdcd'>" + EverString.nullToEmptyString(pathData.get("SIGN_DATE")) + "</th>"
						+ enter + "</tr>";
				tblBody += tblRow;
			}
		}

		fileContents = EverString.replace(fileContents, "$tblBody$", tblBody);
		fileContents = EverString.replace(fileContents, "$maintainUrl$", maintainUrl);
		fileContents = EverString.rePreventSqlInjection(fileContents);
		
		
		if(!EverString.nullToEmptyString(receiverInfo.get("RECV_EMAIL")).equals("")) {
			Map<String, String> mdata = new HashMap<String, String>();
			mdata.put("SUBJECT", (approvalStatus.equals("P") ? "[DSPMRO] " + receiverInfo.get("RECV_USER_NM") + " 님. 결재문서가 도착하였습니다." : (approvalStatus.equals("E") ? "[DSPMRO] " + receiverInfo.get("RECV_USER_NM") + " 님. 상신하신 결재문서가 승인 처리 되었습니다." : (approvalStatus.equals("R") ? "[니즈풀] " + receiverInfo.get("RECV_USER_NM") + " 님. 상신하신 결재문서가 반려 처리 되었습니다." : "[니즈풀] " + receiverInfo.get("RECV_USER_NM") + " 님. 결재문서[참조]가 도착하였습니다."))));
			mdata.put("CONTENTS_TEMPLATE", fileContents);
			mdata.put("SEND_EMAIL", receiverInfo.get("SEND_EMAIL"));
			mdata.put("SEND_USER_NM", receiverInfo.get("SEND_USER_NM"));
			mdata.put("SEND_USER_ID", receiverInfo.get("SEND_USER_ID"));
			mdata.put("RECV_EMAIL", receiverInfo.get("RECV_EMAIL"));
			mdata.put("RECV_USER_NM", receiverInfo.get("RECV_USER_NM"));
			mdata.put("RECV_USER_ID", receiverInfo.get("RECV_USER_ID"));
			mdata.put("REF_NUM", approvalNum);
			mdata.put("REF_MODULE_CD","APP"); // 참조모듈
			// 메일전송.
			// everMailService.SendMail(mdata);
			mdata.clear();
			fileContents = "";
		}

	}

}
