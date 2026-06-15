package com.st_ones.nhepro.SRQR.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.st_ones.common.docNum.service.DocNumService;
import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.common.mail.service.EverMailService;
import com.st_ones.common.mail.web.MailTemplate;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.sms.service.EverSmsService;
import com.st_ones.common.util.clazz.EverEncryption;
import com.st_ones.common.util.service.LargeTextService;
import com.st_ones.everf.serverside.exception.EverException;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.exception.NoResultException;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.everf.serverside.util.EverString;
import com.st_ones.nhepro.SRQR.SRQR0010_Mapper;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : SRQR0010_Service.java
 * @date 2020.06.10
 * @version 1.0
 * @see
 */
@Service(value = "SRQR0010_Service")
public class SRQR0010_Service extends BaseService{
    /**
     * The SRQR0010_Mapper.
     */
    @Autowired
    SRQR0010_Mapper srqr0010_Mapper;
    
    /**
     * The Msg.
     */
    @Autowired 
    MessageService msg;
    
    /**
     * The Doc num service.
     */
    @Autowired 
    DocNumService docNumService;
    
    @Autowired 
    private LargeTextService largeTextService;
    
    @Autowired 
    private EverMailService everMailservice;
    
    @Autowired 
    private EverSmsService everSmsService;
    
    @Autowired 
    private MailTemplate mt;
    
    /**
	 * 화면명 : 견적현황
	 * 처리내용 : 협력업체 견적현황
	 * 경로 : 계약관리 > 견적관리 > 견적현황
	 */
    public List<Map<String,Object>> srqr0010_doSearch(Map<String, String> formData) throws Exception{
        return srqr0010_Mapper.srqr0010_doSearch(formData);
    }
    
    // 견적접수
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String srqr0010_doAccept(List<Map<String, Object>> gridDatas) throws Exception {

		UserInfo userInfo = UserInfoManager.getUserInfo();
		for (Map<String, Object> gridData : gridDatas) {

			gridData.put("VENDOR_CD", userInfo.getCompanyCd());
			
			// 1. 견적 진행상태 체크(미제출인 경우에만 접수 가능)
			String rfxProgressCode = srqr0010_Mapper.checkVendorRfxProgressCode(gridData);
			if ( EverString.notEquals(rfxProgressCode, "100") ) {
				throw new NoResultException(msg.getMessage("0044")); // 처리할 수 없는 진행상태입니다.
			}
			
			// 2. 협력업체 견적포기
			srqr0010_Mapper.doAcceptRfx(gridData);
		}
		
		return msg.getMessage("0001");
	}
    
    // 협력업체 견적포기
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String srqr0010_doGiveup(List<Map<String, Object>> gridDatas) throws Exception {

		UserInfo userInfo = UserInfoManager.getUserInfo();
		for (Map<String, Object> gridData : gridDatas) {

			gridData.put("VENDOR_CD", userInfo.getCompanyCd());
			
			// 1. 견적 진행상태 체크(미접수, 미제출, 작성중인 경우에만 포기 가능)
			String rfxProgressCode = srqr0010_Mapper.checkVendorRfxProgressCode(gridData);
			if( EverString.notEquals(rfxProgressCode, "100") && EverString.notEquals(rfxProgressCode, "200") && EverString.notEquals(rfxProgressCode, "250") ) {
				throw new NoResultException(msg.getMessage("0044")); // 처리할 수 없는 진행상태입니다.
			}
			
			// 2. 협력업체 견적포기
			srqr0010_Mapper.doWaiveRfqReceiptStatus(gridData);

			// 3. 단일업체 견적시 해당 업체가 포기했을 때, 혹은 전체업체가 포기했을 떄 강제로 마감, 개찰한다.
			String compulsionFlag = srqr0010_Mapper.getCompulsionFlag(gridData);
			if(EverString.nullToEmptyString(compulsionFlag).equals("Y")) {
				srqr0010_Mapper.doCompulsionCloseRFX(gridData);
			}
			
			// 4. 견적 포기시 담당자에게 메일발송
			sendMail(gridData);
		}
		
		return msg.getMessage("0001");
	}
    
    /** ******************************************************************************************
     * 견적서 작성(협력업체)
     * @param param
     * @return
     * @throws Exception
     */
	public List<Map<String, String>> getVendorQtaCreation(Map<String, String> param) throws Exception {
		
		return srqr0010_Mapper.getVendorQtaCreation(param);
	}
	
	// 협력사 투찰정보 가져오기
	public Map<String, String> doSearchQtaCreation_F(Map<String, String> param) throws Exception {
		
		// 1. 협력사 투찰정보 가져오기
		Map<String, String> formData = srqr0010_Mapper.doSearchQtaCreation_F(param);
        if (formData != null) {
        	
        	// 구매사 특기사항
        	String bTextNo = formData.get("B_RMK_TEXT_NUM");
            String bSplitString = largeTextService.selectLargeText(bTextNo);
            formData.put("B_RMK_TEXT", bSplitString);
            
            // 협력사 특기사항
            String textNo = formData.get("QTA_RMK_TEXT_NUM");
            String splitString = largeTextService.selectLargeText(textNo);
            formData.put("QTA_RMK_TEXT", splitString);
        }
        
        return formData;
    }
	
	// 견적서 품목정보 가져오기
	public List<Map<String, Object>> doSearchQtaCreation_G(Map<String, String> param) throws Exception {

        return srqr0010_Mapper.doSearchQtaCreation_G(param);
    }

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public Map<String, String> srqi0011_doSave(Map<String, String> formData, List<Map<String, Object>> gridDatas) throws Exception {

		Map<String, String> rtnMap = new HashMap<String, String>();
		
		String sendFlag = EverString.nullToEmptyString(formData.get("SEND_FLAG")); // "S" : 제출, "T" : 저장
		String signedCd = "1"; // "1" : 성공(임시저장일 경우, 1), "0" : 실패

		// 1. 마감일자 이후에 제출 : 처리 불가
        if(EverString.nullToEmptyString(srqr0010_Mapper.getRfqCloseFlag(formData)).equals("Y")) {
        	throw new Exception(msg.getMessageByScreenId("SRQI0011", "limit_close_date"));
        }

        // 2. 견적 포기 : 작성 및 제출 불가 
        if (srqr0010_Mapper.checkValidVendor(formData) == 1) {
            throw new Exception(msg.getMessageByScreenId("SRQI0011", "vendorGiveup"));
        }

        String qtaTextNo = EverString.nullToEmptyString(formData.get("QTA_RMK_TEXT_NUM")).toString();
        String textNo = largeTextService.saveLargeText(qtaTextNo, EverString.nullToEmptyString(formData.get("QTA_RMK_TEXT")).toString());
        formData.put("QTA_RMK_TEXT_NUM", textNo);

        String qtaNo = EverString.nullToEmptyString(formData.get("QTA_NUM")).toString();
        if (EverString.isEmpty(qtaNo)) {
            qtaNo = docNumService.getDocNumber(formData.get("BUYER_CD"), "QTA");
            formData.put("QTA_NUM", qtaNo);
        }

        // 협력업체의 RFQ 진행상태코드[M072]를 Update 한다.
        formData.put("RFX_PROGRESS_CD", (sendFlag.equals("T") ? "250" : "300"));
        srqr0010_Mapper.doUpdateQtaCreation_RQVN(formData);
        
        // 협력업체가 이미 견적서를 작성했는지 체크하여 STOCQTHD에 Insert 또는 최종여부(LAST_FLAG)를 Update한다.
        int cnt = srqr0010_Mapper.checkExistsQtaCreation_QTHD(formData);
        if (cnt == 0) {
        	srqr0010_Mapper.doInsertQtaCreation_QTHD(formData);			// 견적서 Header 등록
        	srqr0010_Mapper.doUpdatePreviousLastFlag_QTHD(formData);	// 이전 견적서의 last_flag = 0
        } else {
            if (srqr0010_Mapper.checkCompanyCode(formData) == 0) {
                throw new NoResultException(msg.getMessage("0008"));
            }
            srqr0010_Mapper.doUpdateQtaCreation_QTHD(formData);
        }

        for (Map<String, Object> gridData : gridDatas) {
        	
            gridData.put("QTA_NUM", qtaNo);
            
            // 협력업체가 이미 견적서를 작성했는지 체크하여 STOCQTDT에 Insert ot Update한다.
            int cntg = srqr0010_Mapper.checkExistsQtaCreation_QTDT(gridData);
            if (cntg == 0) {
                gridData.put("QTA_SQ", srqr0010_Mapper.getQtaSq(gridData));
                srqr0010_Mapper.doInsertQtaCreation_QTDT(gridData);
            } else {
            	srqr0010_Mapper.doUpdateQtaCreation_QTDT(gridData);
            }
        }
        
        // Submit process
        if( sendFlag.equals("S") ) {
            // 전송정보 변경(전자서명값 저장)
        	srqr0010_Mapper.doUpdateQtaCreation_SendDate(formData);
        	
        	try {
        		Map<String, Object> mdata = new HashMap<>();
                mdata.put("BUYER_CD", formData.get("BUYER_CD"));
        		mdata.put("QTA_NUM",  formData.get("QTA_NUM"));
            	sendMail(mdata);
     		} catch (Exception ex) {
                getLog().error("협력사 견적제출 메일 및 SMS 발송 오류 : " + ex.getMessage(), ex);
            }
        	
            // 구매담당자에게 메일발송
            //Map<String, Object> mdata = new HashMap<>();
            //mdata.put("BUYER_CD", formData.get("BUYER_CD"));
    		//mdata.put("QTA_NUM",  formData.get("QTA_NUM"));
        	//sendMail(mdata);
        }
        
        rtnMap.put("BUYER_CD", formData.get("BUYER_CD"));
        rtnMap.put("RFX_NUM",  formData.get("RFX_NUM"));
        rtnMap.put("RFX_CNT",  formData.get("RFX_CNT"));
        rtnMap.put("QTA_NUM",  qtaNo);
        rtnMap.put("RFX_TYPE", formData.get("RFX_TYPE"));
        rtnMap.put("signedCd", signedCd);
        rtnMap.put("rtnMsg", (sendFlag.equals("T") ? msg.getMessage("0031") : msg.getMessageByScreenId("SRQI0011", "0005")));
        
		return rtnMap;
	}
    
	// 이메일 발송(견적서 포기 및 제출)
	public void sendMail(Map<String, Object> formData) throws Exception {
		
		// 전자구매시스템 URL
        String linkUrl = PropertiesManager.getString("eversrm.urls.maintain.real");
        
        Map<String, String> mdata = new HashMap<>();
        mdata.put("BUYER_CD", String.valueOf(formData.get("BUYER_CD")));
		mdata.put("QTA_NUM",  String.valueOf(formData.get("QTA_NUM")));
		
		// 메일 발송정보 가져오기
		//mdata = srqr0010_Mapper.getMailInfo(mdata);
		
		List<Map<String, String>> mailTargetList = srqr0010_Mapper.getMailInfo(mdata);
		
		for (Map<String, String> mailTargetData : mailTargetList) {
			
			if( !EverString.nullToEmptyString(mailTargetData.get("RECV_USER_ID")).equals("") ) {
				// 발송내용
				String subject = "[전자구매시스템] 협력사 [" + mailTargetData.get("VENDOR_NM") + "]에서 [" + mailTargetData.get("RFX_SUBJECT") + "] 관련 견적서를 제출하였습니다.";
				Map<String, String> mailMap = new HashMap<String, String>();
                mailMap.put("SUBJECT", subject);
				
                StringBuffer content = new StringBuffer(255);
                content.append("<BR> 안녕하세요.																							");
                content.append("<BR> [" + mailTargetData.get("BUYER_NM") + "] [" + mailTargetData.get("RECV_USER_NM") + "]님.			");
                content.append("<BR>																									");
                content.append("<BR> 아래와 같이 협력사에서 수의시담(견적)을 제출하였습니다.															");
                content.append("<BR> 협력사 : [" + mailTargetData.get("VENDOR_NM") + "]													");
                content.append("<BR> 의뢰명 : [" + mailTargetData.get("RFX_SUBJECT") + "]													");
                content.append("<BR> 제출일 : [" + mailTargetData.get("SEND_DATE") + "]													");
                content.append("<BR>																									");
                content.append("<BR> 전자구매시스템에 <a href=\"" + linkUrl + "\" target=\"newP\">로그인</a> 하시어, 세부내용을 확인 해주십시오.			");
                content.append("<BR>																									");
                content.append("<BR> 감사합니다.																							");
                
                mailMap.put("CONTENTS", content.toString());
                mailMap.put("REF_MODULE_CD", "MRFX01");
                mailMap.put("REF_NUM", mailTargetData.get("EXEC_NUM"));
                mailMap.put("RECV_USER_ID", mailTargetData.get("RECV_USER_ID"));
                everMailservice.SendMail(mailMap);
                
                Map<String, String> smsMap = new HashMap<String, String>();
                smsMap.put("CONTENTS", subject);
                smsMap.put("REF_MODULE_CD", "SRFX01");
                smsMap.put("RECV_USER_ID", mailTargetData.get("RECV_USER_ID"));
                
                smsMap.put("CORP_NO", mailTargetData.get("CORP_NO"));			// 고객사 사업자번호
        		smsMap.put("BRC", mailTargetData.get("BRC"));					// 고객사 부서
        		smsMap.put("EPRO_PS_DSC", "1");									// 1  : 구매
                smsMap.put("EPRO_RATE_DSC", "01");								// 01 : 최초
        		smsMap.put("APLY_DT", mailTargetData.get("APLY_DT"));			// 발생일 YYYYMMDD
        		smsMap.put("USER_ID", mailTargetData.get("USER_ID"));			// 고객사 보내는사람 ID
        		smsMap.put("CONT_TBL_ID", "STOCRQHD");							// 검증 테이블
        		smsMap.put("CONT_TBL_PK", mailTargetData.get("CONT_TBL_PK")); 	// 검증 조건(협력사별 입찰번호)
        		smsMap.put("tmp", mailTargetData.get("CONT_TBL_PK"));			// myBatis 버그 해결을 위한 무의미한, 유니크한 값.
        		smsMap.put("payFlag", "Y");										// SMS 과금여부
        		
                everSmsService.sendSmsNhe(smsMap);
				/*
				 * String contents = "<BR> 안녕하세요." + "<BR> [" + mdata.get("BUYER_NM") + "] " +
				 * mdata.get("RECV_USER_NM") + " 님" + "<BR> " +
				 * "<BR> 아래와 같이 협력사에서 수의시담(견적)을 제출하였습니다." + "<BR> " + "<BR> 협력사 : [" +
				 * mdata.get("VENDOR_NM") + "]" + "<BR> 요청명 : [" + mdata.get("RFX_SUBJECT") +
				 * "] " + "<BR> 등록일 : [" + mdata.get("SEND_DATE") + "]" + "<BR> 등록결과 : [" +
				 * mdata.get("SEND_TYPE_LOC") + "]" + "<BR> " +
				 * "<BR> 전자구매시스템에 로그인 하시어, 세부내용을 확인 해주십시오." + "<BR> " + "<BR> 감사합니다.";
				 */
				
				/*
				 * if( !EverString.nullToEmptyString(mdata.get("RECV_EMAIL")).equals("") ) {
				 * mdata.put("SUBJECT", subject); mdata.put("CONTENTS", contents);
				 * 
				 * // 수신자 
				 * mdata.put("RECV_EMAIL", String.valueOf(mdata.get("RECV_EMAIL")));
				 * mdata.put("RECV_USER_NM", String.valueOf(mdata.get("RECV_USER_NM")));
				 * mdata.put("RECV_USER_ID", String.valueOf(mdata.get("RECV_USER_ID")));
				 * 
				 * // 발신자(=시스템) 
				 * mdata.put("SEND_USER_ID", "SYSTEM"); mdata.put("SEND_USER_NM",
				 * PropertiesManager.getString("eversrm.system.mailSenderName"));
				 * mdata.put("SEND_EMAIL",PropertiesManager.getString("eversrm.system.mailSenderMail"));
				 * mdata.put("REF_MODULE_CD", "RFQ"); mdata.put("REF_NUM", null);
				 * 
				 * // 메일전송. everMailService.SendMail(mdata); }
				 */
			}
		}
	}
	
    /**
	 * 화면명 : 견적현황
	 * 처리내용 : 협력업체 견적현황
	 * 경로 : 계약관리 > 견적관리 > 견적현황
	 */
    public Map<String,Object> srqr0012_doSearchRQHD(Map<String, String> formData) throws Exception{
    	Map<String, Object> fParam;
        fParam = srqr0010_Mapper.srqr0012_doSearchRQHD(formData);
        fParam.put("RMK_TEXT", largeTextService.selectLargeText(EverString.nullToEmptyString(fParam.get("RMK_TEXT_NUM"))));

        return fParam;
    }
    
    public List<Map<String,Object>> srqr0012_doSearchRQDT(Map<String, String> formData) throws Exception{
        return srqr0010_Mapper.srqr0012_doSearchRQDT(formData);
    }
    
    /**
	 * 화면명 : 견적결과
	 * 처리내용 : 협력업체 견적결과
	 * 경로 : 계약관리 > 견적관리 > 견적결과
	 */
    public List<Map<String,Object>> srqr0020_doSearch(Map<String, String> formData) throws Exception{
        return srqr0010_Mapper.srqr0020_doSearch(formData);
    }

}
