package com.st_ones.nhepro.SCTR.service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLDecoder;
import java.nio.ByteBuffer;
import java.nio.CharBuffer;
import java.nio.charset.Charset;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.st_ones.common.docNum.service.DocNumService;
import com.st_ones.common.enums.econtract.ContStringUtil;
import com.st_ones.common.enums.system.Code;
import com.st_ones.common.file.service.FileAttachService;
import com.st_ones.common.mail.service.EverMailService;
import com.st_ones.common.mail.web.MailTemplate;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.sms.service.EverSmsService;
import com.st_ones.common.util.clazz.EverCert;
import com.st_ones.common.util.clazz.EverDate;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.common.util.service.LargeTextService;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.eversrm.eApproval.eApprovalModule.service.BAPM_Service;
import com.st_ones.nhepro.CCTR.CCTR0020_Mapper;
import com.st_ones.nhepro.SCTR.SCTR0010_Mapper;

import io.netty.util.internal.StringUtil;
import kica.sgic.util.DataToXml;
import kica.sgic.util.SGIxLinker;
import kica.sgic.util.XmlToData;


/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 St-Ones CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : BECM_Service.java
 * @author
 * @date 2018. 03. 27.
 * @version 1.0
 * @see
 */

@Service(value = "SCTR0010_Service")
@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
public class SCTR0010_Service extends BaseService {

    Logger logger = LoggerFactory.getLogger(this.getClass());
    
    @Autowired MessageService msg;
	@Autowired private SCTR0010_Mapper sctr0010_mapper;
	@Autowired private CCTR0020_Mapper cctr0020_mapper;
	@Autowired private EverMailService everMailService;
	@Autowired private LargeTextService largeTextService;
	@Autowired private MessageService messageService;
	@Autowired private EverSmsService everSmsService;
    @Autowired private DocNumService docNumService;
    @Autowired BAPM_Service approvalService;
	@Autowired private FileAttachService fileAttachService;
    
    /**
     * 계약서 현황 조회
     * @param param
     * @return
     * @throws Exception
     */
	public List<Map<String, Object>> sctr0010_doSearchContractProgressStatus(Map<String, String> param) throws Exception {
		Map<String, Object> formObj = new HashMap<String, Object>(param);
        formObj.put("PROGRESS_CD_LIST", Arrays.asList(param.get("PROGRESS_CD").split(",")));
        return sctr0010_mapper.sctr0010_doSearchContractProgressStatus(formObj);
	}

    /**
     * 계약서 정보
     * @param req
     * @param resp
     * @throws Exception
     */
	public void sctr0011_getContractInfo(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		Map<String, String> formData = req.getParamDataMap();

		/* 계약서 키값이 존재하냐 안하냐에 따라 insert, update를 구분합니다. */
		if(StringUtils.isNotEmpty(formData.get("CONT_NUM")) && StringUtils.isNotEmpty(formData.get("CONT_CNT"))) {

			/* 키값이 존재하면 데이터를 조회만 합니다. */
			Map<String, String> contInfo = sctr0010_mapper.sctr0011_getContractInformation(formData);
			// String contractFormContents  = largeTextService.selectLargeText(contInfo.get("CONTRACT_TEXT_NUM"));
			//String contractFormContents = StringUtils.defaultIfEmpty(contInfo.get("CONTRACT_TEXT"), "");

			// HTML 서식 제거한 계약폼(전자서명용)
			// String signContractFormContents = ContStringUtil.getHtmlContents(contractFormContents.replaceAll("&lt;", "<").replaceAll("&gt;", ">"), true);
			// contInfo.put("formContents", signContractFormContents);

			formData.putAll(contInfo);
		}

		req.setAttribute("form", formData);
	}

	public void sctr0010_doGurSave(List<Map<String, Object>> gridData) {
		for(Map<String, Object> grid : gridData) {
			sctr0010_mapper.sctr0010_doGurSave(grid);
		}
	}

	public List<Map<String, Object>> secm030_doSearchSubForm(Map<String, String> param) throws Exception {

		param.put("CONT_NUM", param.get("CONT_NUM"));
		param.put("CONT_CNT", param.get("CONT_CNT"));

		List<Map<String, Object>> additionalFormList = cctr0020_mapper.ccta0030_doSearchAdditionalForm(param);
		for (Map<String, Object> map : additionalFormList) {
			String contents = largeTextService.selectLargeText(String.valueOf(map.get("CONTRACT_TEXT_NUM")));
			//String contents = (String)map.get("CONTRACT_TEXT");
			contents = ContStringUtil.getHtmlContents(contents, true);

			map.put("ADDITIONAL_CONTENTS", contents);
		}

		return additionalFormList;
	}

    /**
     * 주계약서, 첨부서식 등을 DB에서 조회한 값으로 전자서명하기 위해 조회 (클라이언트에서 임의로 변경할 수도 있으므로)
     * @param req
     * @param resp
     * @throws Exception
     */
	public void sctr0011_getContractsToSign(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		Map<String, String> formData = req.getFormData();
		List<Map<String, String>> contractAllContents = sctr0010_mapper.getContractAllContents(formData);

		// 계약서, 첨부문서 등을 하나로 합친다. 서명인증도 하나로 합쳐서 진행
		StringBuilder allContents = new StringBuilder();
        for (Map<String, String> contents : contractAllContents) {
        	String contractContents = largeTextService.selectLargeText(contents.get("CONTRACT_TEXT_NUM"));
            allContents.append(ContStringUtil.getHtmlContents(contractContents, true));
        }

        resp.setParameter("formContents", allContents.toString());
	}

    /**
     * 전자서명 데이터 저장 및 계약서 상태 변경
     * @param req
     * @param resp
     */
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public void sctr0011_doSaveSignedData(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		String localServerFlag = EverString.nullToEmptyString(req.getParameter("localServerFlag"));
		String sSignData = EverString.nullToEmptyString(req.getParameter("signedData"));
		sSignData = URLDecoder.decode(sSignData, "utf-8");
		String vidRandom = EverString.nullToEmptyString(req.getParameter("vidRandom"));
		vidRandom = URLDecoder.decode(vidRandom, "utf-8");
		String idn = EverString.nullToEmptyString(req.getParameter("idn"));
		String useCard = EverString.nullToEmptyString(req.getParameter("useCard"));

		if(localServerFlag.equals("N")) {
			Map<String, String> rtnMap = EverCert.doCheckCert(sSignData, vidRandom, idn, useCard);
			// 서명값 검증 실패
			if (rtnMap.get("certRtnCd").equals("-1")) {
				throw new Exception(rtnMap.get("certRtnMsg"));
			}
		}

        Map<String, String> formData = req.getFormData();
        List<Map<String, Object>> gridECPC_HD = req.getGridData("gridECPC_HD");
        List<Map<String, Object>> gridECPC = req.getGridData("gridECPC");

        // 3. 2021.02.09 : 협력사 재전송 기능 추가에 따른 기존 전자서명 여부 가져오기
        String vendorSignCnt = sctr0010_mapper.getVendorSignData(formData);
        if( StringUtil.isNullOrEmpty(vendorSignCnt) ) {
        	vendorSignCnt = "0";
        }
        
        // 2021.02.22 : 기존에 협력사에서 서명한 경우 수수료 청구는 하지 않음
        if( Integer.parseInt(vendorSignCnt) == 0 ) {
			// 추가 : 2021.02.22
	        // 1. 협력사 선불 이용료(수수료) 청구
	        Map<String, String> paymentMapSub = cctr0020_mapper.getPrepaymentVendor(formData);
	        
	        paymentMapSub.put("EPRO_PS_DSC", "2");			// epro_ps_dsc [구매공급구분코드] - 1 : 구매, 2 : 공급
	        paymentMapSub.put("EPRO_WRS_DS", "30");			// epro_wrs_ds [상품코드] - 10 : RFI, 20 : 입찰, 30 : 일반입찰계약, 40 : 일반수의계약, 50 : BtoC계약, 60 : 위임계약, 70 : 문서보관, 80 : SMS, 90 : LMS, 100 : 문서생성
	        paymentMapSub.put("CONT_TBL_ID", "STOCECCT");	// 업무 Table명
	        //CONT_TBL_PK : 해당 Table에 Data 존재유무를 조회해볼 수 있는 Key 값. GATE_CD || '@@' || BUYER_CD || '@@' || ... 와 같이 설정.
	        paymentMapSub.put("tmp", String.valueOf(paymentMapSub.get("CONT_AMT")));	//tmp : myBatis 버그 해결을 위한 무의미한, 유니크한 값. 단, EPRO_WRS_DS = '30' 또는 '40'일 때 반드시 계약금액을 넣어야 함.
	        
	        String resultMsgSub = approvalService.putBkCost(paymentMapSub);
	        if( !resultMsgSub.equals("OK") ) {
	        	throw new Exception(resultMsgSub);
	        } else {
	        	System.out.println("==========> 협력사 전자서명 후 협력사에 수수료 청구 : PK => " + paymentMapSub.get("CONT_TBL_PK") + ", AMT => " + paymentMapSub.get("tmp"));
	        }
        }
        
        // 2. 협력사 서명완료(4230) 처리
        formData.put("PROGRESS_CD", Code.M137_4230);        	// 협력사 서명완료(4230)
        sctr0010_mapper.doUpdateContractStatusECCT(formData);   // 계약서 상태 변경
        
        // 3. 2021.02.22 : 협력사 재전송 기능 추가에 따른 로직 변경
        // 3-1. 기존 협력사 전자서명값 있는 경우 삭제 후 전자서명값 등록
        if( Integer.parseInt(vendorSignCnt) > 0 ) {
        	sctr0010_mapper.doDeleteVendorSignData(formData);
        }
        
		// 3-2. 보증정보만큼 전자서명 데이터 생성
		formData.put("VID_RANDOM", vidRandom);
		formData.put("SIGN_VALUE", sSignData);
		formData.put("FORM_NUM", formData.get("FORM_NUM"));
		sctr0010_mapper.doInsertSignedData(formData); // 전자서명 데이터 저장

		// 4. 보증정보(계약보증, 차액보증)
		for (Map<String, Object> ecpc_hd : gridECPC_HD) {
			// 계약보증
			ecpc_hd.put("PAY_CNT", "0");
			sctr0010_mapper.doUpdateECPC_HD(ecpc_hd);
			if(Integer.parseInt(String.valueOf(ecpc_hd.get("DI_ATT_FILE_CNT"))) > 0) {
				// 차액보증
				ecpc_hd.put("PAY_CNT", "-1");
				sctr0010_mapper.doUpdateECPC_HD_DI(ecpc_hd);
			}
		}

		// 5. 보증정보(선급보증, 하자보증)
		for (Map<String, Object> ecpc : gridECPC) {
			sctr0010_mapper.doUpdateECPC_HD(ecpc);
		}
		
        // 6. 전자서명 완료 후 계약담당자에게 메일발송
		Map<String, String> mailInfo = sctr0010_mapper.sctr0011_getContractInformation(formData);
		try {
			String subject  = "[전자구매시스템] 협력사 [" + mailInfo.get("VENDOR_NM") + "]에서 ["+ mailInfo.get("CONT_DESC") +"] 계약을 [서명완료] 하였습니다";
			
			String contents = "안녕하세요." +
					"<BR> " + mailInfo.get("CONT_USER_NM") + " 님." +
					"<BR> " +
					"<BR> 아래와 같이 협력사에서 전자서명을 완료 하였습니다." +
					"<BR> 협력사 : [" + mailInfo.get("VENDOR_NM") + "]" +
					"<BR> 계약명 : [" + mailInfo.get("CONT_DESC") + "]" +
					"<BR> 처리일 : [" + mailInfo.get("SYS_DATE") + "]" +
					"<BR> 처리결과 : [서명완료]" +
					"<BR> " +
					"<BR> 전자구매시스템에 로그인 하시어, 세부내용을 확인 해주십시오." +
					"<BR> " +
					"<BR> 감사합니다.";
			
			formData.put("SUBJECT", subject);
			formData.put("CONTENTS", contents);
			formData.put("REF_MODULE_CD", "MCONT03");
			formData.put("RECV_USER_ID", mailInfo.get("CONT_USER_ID"));
			everMailService.SendMail(formData);

			// SMS발송
			Map<String,String> smsMap = new HashMap<String,String>();
            smsMap.put("CONTENTS", subject);
			smsMap.put("REF_MODULE_CD", "SCONT03");
			smsMap.put("RECV_USER_ID", String.valueOf(mailInfo.get("CONT_USER_ID")));
			
			// 2021.07.01 : 협력사 전자서명 완료 후 SMS 수수료 부과
			smsMap.put("CORP_NO", mailInfo.get("CORP_NO"));			// 고객사 사업자번호
			smsMap.put("BRC", mailInfo.get("BRC"));					// 고객사 부서
			smsMap.put("EPRO_PS_DSC", "1");							// 1  : 구매
            smsMap.put("EPRO_RATE_DSC", "01");						// 01 : 최초
			smsMap.put("APLY_DT", mailInfo.get("APLY_DT"));			// 발생일 YYYYMMDD
			smsMap.put("USER_ID", mailInfo.get("USER_ID"));			// 고객사 보내는사람 ID
			smsMap.put("CONT_TBL_ID", "STOCECCT");					// 검증 테이블
			smsMap.put("CONT_TBL_PK", "SMS_CONT_4230@@" + mailInfo.get("CONT_TBL_PK")); // 검증 조건(협력사별 입찰번호)
			smsMap.put("tmp", mailInfo.get("CONT_TBL_PK"));			// myBatis 버그 해결을 위한 무의미한, 유니크한 값.
			smsMap.put("payFlag", "Y");
			
			everSmsService.sendSmsNhe(smsMap);
		}
		catch (Exception ex) {
		    logger.error("협력사 전자서명 완료(4230) 메일&문자 발송 오류 : " + ex.getMessage());
		}
        resp.setResponseMessage(messageService.getMessageByScreenId("SECM_030", "0001"));
    }

    /**
     * 계약서 반려처리
     * @param req
     * @param resp
     */
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public void sctr0011_doRejectContract(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> formData = req.getFormData();
        formData.put("PROGRESS_CD", Code.M137_4220);
        formData.put("REJECT_RMK", req.getParameter("rejectRemark"));

        sctr0010_mapper.doUpdateContractStatusECCT(formData);    // 계약서 상태 변경
        sctr0010_mapper.doMergeRejectHistoryECRJ(formData);      // 반려사유 입력

		// 계약서 반려 완료 후 계약담당자에게 메일발송
		Map<String, String> mailInfo = sctr0010_mapper.sctr0011_getContractInformation(formData);
		try {
			String subject  = "[전자구매시스템] 협력사 [" + mailInfo.get("VENDOR_NM") + "]에서 [" + mailInfo.get("CONT_DESC") + "] 계약을 [서명거부] 하였습니다";
			String contents = "<BR> 안녕하세요." +
					"<BR> " + mailInfo.get("CONT_USER_NM") + " 님." +
					"<BR> " +
					"<BR> 아래와 같이 협력사에서 전자서명을 거부 하였습니다 <br>" +
					"<BR> 협력사 : ["+ mailInfo.get("VENDOR_NM") + "]" +
					"<BR> 계약명 : ["+ mailInfo.get("CONT_DESC") + "]" +
					"<BR> 처리일 : ["+ mailInfo.get("SYS_DATE") + "]" +
					"<BR> 처리결과 : [서명거부]" +
					"<BR> " +
					"<BR> 전자구매시스템에 로그인 하시어, 세부내용을 확인 해주십시오.<br>" +
					"<BR> " +
					"<BR> 감사합니다.";

			formData.put("SUBJECT", subject);
			formData.put("CONTENTS", contents);
			formData.put("REF_MODULE_CD", "MCONT03");
			formData.put("RECV_USER_ID", mailInfo.get("CONT_USER_ID"));
			everMailService.SendMail(formData);

			// SMS
			Map<String,String> smsMap = new HashMap<String,String>();
            smsMap.put("CONTENTS", subject);
			smsMap.put("REF_MODULE_CD", "SCONT03");
			smsMap.put("RECV_USER_ID", String.valueOf(mailInfo.get("CONT_USER_ID")));
			
			// 2021.07.01 : 협력사 전자서명 반려 후 SMS 수수료 부과
			smsMap.put("CORP_NO", mailInfo.get("CORP_NO"));			// 고객사 사업자번호
			smsMap.put("BRC", mailInfo.get("BRC"));					// 고객사 부서
			smsMap.put("EPRO_PS_DSC", "1");							// 1  : 구매
            smsMap.put("EPRO_RATE_DSC", "01");						// 01 : 최초
			smsMap.put("APLY_DT", mailInfo.get("APLY_DT"));			// 발생일 YYYYMMDD
			smsMap.put("USER_ID", mailInfo.get("USER_ID"));			// 고객사 보내는사람 ID
			smsMap.put("CONT_TBL_ID", "STOCECCT");					// 검증 테이블
			smsMap.put("CONT_TBL_PK", "SMS_CONT_4220@@" + mailInfo.get("CONT_TBL_PK")); // 검증 조건(협력사별 입찰번호)
			smsMap.put("tmp", mailInfo.get("CONT_TBL_PK"));			// myBatis 버그 해결을 위한 무의미한, 유니크한 값.
			smsMap.put("payFlag", "Y");
			
			everSmsService.sendSmsNhe(smsMap);
		}
		catch (Exception ex) {
		    logger.error("협력사 전자서명 거부 메일&문자 발송 오류 : " + ex.getMessage());
		}
    }

    public Map<String, String> sctr0012_doSearchPrint(Map<String, String> param) throws Exception {
        return sctr0010_mapper.sctr0012_doSearchPrint(param);
    }

	public List<Map<String, String>> sctr0012_doSearchOtherPrint(Map<String, String> param) throws Exception {
		return sctr0010_mapper.sctr0012_doSearchOtherPrint(param);
	}

	public List<Map<String, Object>> sctr0011_doSearchECPC_HD(Map<String, String> formData) {
    	return sctr0010_mapper.sctr0011_doSearchECPC_HD(formData);
	}

    public int sctr0011_doSearchGuarInfo(Map<String, String> paramDataMap) {
    	return sctr0010_mapper.sctr0011_doSearchGuarInfo(paramDataMap);
    }

	public void sctr0011_doSaveECPC_HD(List<Map<String, Object>> gridData) {
    	for(Map<String, Object> grid : gridData) {
    		grid.put("PAY_CNT", "0");
			sctr0010_mapper.sctr0011_doSaveECPC_HD(grid);

			if (Integer.parseInt(String.valueOf(grid.get("DI_ATT_FILE_CNT"))) > 0) {
				grid.put("PAY_CNT", "-1");
				sctr0010_mapper.sctr0011_doSaveECPC_HD_GUAR(grid);
			}
		}
	}

	public List<Map<String, Object>> sctr0011_doSearchECPC(Map<String, String> formData) {
		return sctr0010_mapper.sctr0011_doSearchECPC(formData);
	}

	public void sctr0011_doSaveECPC(List<Map<String, Object>> gridData) {
		for(Map<String, Object> grid : gridData) {
			sctr0010_mapper.sctr0011_doSaveECPC_HD(grid);
		}
	}

	public List<Map<String, Object>> sctr0011_doSearchECMT(Map<String, String> formData) {
		return sctr0010_mapper.sctr0011_doSearchECMT(formData);
	}
	
	/**
	 * 협력사 입찰참가신청 : 입찰보증증권
	 * @param param
	 * @param grid
	 * @throws Exception
	 */
    public String sendBdhdGuar(Map<String, Object> guarData) throws Exception {
    	
    	//Map<String, Object> guarData = grid.get(0);
    	
    	/*  GUAR_TYPE : ADV	  선급보증 ,CONT 계약보증	,WARR 하자보증	,DIF	 차액보증 */
    	// 1. [필수] 전문송신기관(송신자ID : A+피보험자사업자번호+00 (총 13자리))
		String	head_mesg_send  = "";	/*	[필수]	 전문송신기관	*/
        if(PropertiesManager.getBoolean("eversrm.system.developmentFlag")) {// 개발서버에서는 고정된 값으로.
    		head_mesg_send="A120870175500";
        } else {
    		head_mesg_send="A120870175500";
        }
        guarData.put("HEAD_MESG_SEND", head_mesg_send);
        
        // 서울보증증권 전송전문 가져오기
    	Map<String, String> guarInfo = sctr0010_mapper.getGuarDataBdhd(guarData);
    	System.err.println("==============================guarInfo=============="+guarInfo);
    	
    	
    	String guarReqNum = "";
    	if( StringUtils.isEmpty(guarInfo.get("GUAR_REQ_NUM")) ) {
    		guarReqNum = docNumService.getDocNumber(PropertiesManager.getString("eversrm.default.company.code"), "GU");
    	}
    	else {
    		guarReqNum = String.valueOf(guarData.get("GUAR_REQ_NUM"));
    	}
    	guarData.put("GUAR_REQ_NUM", guarReqNum);
    	
        String sendinfo_conf  = PropertiesManager.getString("sendinfo_conf", "");	// 서울보증전송 설정정보 가져오기
        String templates_path = PropertiesManager.getString("templates_path", "");	// 서울보증 템플릿 경로
        
        /**
		 * 문서코드(문서명) -  BIDINF(입찰정보통보서)
		 * 상품(보험종류)구분코드- 001:입찰
		 */
        
        /* HEADER */
        String headMesgType = "BIDINF";
        String headMesgName = "입찰정보통보서";
        
        // 2. [필수] 수신처ID (z120811300200 : 서울보증보험 13자리 고정값)
    	//String headMesgRecv    = PropertiesManager.getString("eversrm.head_mesg_recv");
    	String head_mesg_recv  = "z120811300200";	/*	[필수]	 전문수신기관	*/
		String head_func_code  = "53";				/*	[필수]	 문서기능 (9 : 원본, 1 : 취소, 53 : 테스트)	*/
		String head_mesg_type  = headMesgType;		/*	[필수]	 문서코드 (BIDINF : 입찰정보통보서, CONINF : 계약정보통보서, FLRINF : 하자정보통보서, PREINF : 선금정보통보서)	*/
		String head_mesg_name  = headMesgName;		/*	[필수]	 문서명	*/
		String head_mesg_vers  = "1.0";				/*	[선택]	 전자문서버전	*/
		
		// 계약보증번호 채번
		//String guarReqNum = docNumService.getDocNumber(PropertiesManager.getString("eversrm.default.company.code"), "GU");
    	//guarData.put("GUAR_REQ_NUM", guarReqNum);

		String head_docu_numb  = guarInfo.get("HEAD_DOCU_NUMB");	/*	[필수]	 문서번호	*/
		String head_mang_numb  = guarInfo.get("HEAD_MANG_NUMB");	/*	[필수]	 문서관리번호 (피보험자측 계약번호(차수포함) : CONT_NUM+CONT_CNT+'_'+GUAR_REQ_NUM)	*/
		String head_refr_numb  = guarInfo.get("HEAD_REFR_NUMB");	/*	[필수]	 참조번호 (피보험자측 계약번호(차수포함) : CONT_NUM+CONT_CNT+'_'+GUAR_REQ_NUM)	*/

		String head_titl_name  = headMesgName;		/*	[필수]	문서개요(=문서명과 동일)	*/
		String head_orga_code  = "NHI";   		/*  [필수]   연계기관코드   */
		
		head_docu_numb = head_docu_numb.replaceAll("XXXXXXXXXX", guarReqNum);
		head_mang_numb = head_mang_numb.replaceAll("XXXXXXXXXX", guarReqNum);
		head_refr_numb = head_refr_numb.replaceAll("XXXXXXXXXX", guarReqNum);

		/** BODY */
		/* 보험계약정보 Guarantee.Info.Details */
		String	bond_kind_code  = "001"; 							/*	[필수]	" 보험종목구분(001:입찰, 002:계약, 003:하자, 004:선금, 006:지급)"	*/
		String	bond_fnsh_date  = guarInfo.get("BOND_FNSH_DATE"); 	/*	[필수]	" 보험종료일자 - YYYYMMDD"	*/
		String	bond_curc_code  = "WON"; 							/*		" 보험가입금액 통화코드 - WON(원화), USD(미달러),EUR(유로화) 등"	*/
		String	bond_penl_amnt  = String.valueOf(guarInfo.get("BOND_PENL_AMNT")); 	/*		" 보험가입금액 예) 1500000	*/

		/* 입찰공고 정보 Bidding.Info.Details */
		String bidd_noti_numb = guarInfo.get("BIDD_NOTI_NUMB"); 	/*필수 공고번호 - 피보험자 측 입찰번호 (차수를 포함한 정확한 입찰번호만 기재) ex) T2008100100                                                                                                                                                  */
		bidd_noti_numb = bidd_noti_numb.replaceAll("XXXXXXXXXX", guarReqNum);
		String bidd_proc_type = guarInfo.get("BIDD_PROC_TYPE"); 	/*필수 계약구분코드 - 별첨 sheet의 코드 참조                                                                                                                                                                                                   */
		String bidd_name_text = guarInfo.get("BIDD_NAME_TEXT"); 	/*필수 입찰건명                                                                                                                                                                                                                                */
		String bidd_pric_rate = guarInfo.get("BIDD_PRIC_RATE"); 	/*보증금율                                                                                                                                                                                                                                */
		String bidd_fnsh_date = guarInfo.get("BIDD_FNSH_DATE");     /*	입찰마감일자	*/
		String bidd_frop_date = guarInfo.get("BIDD_FROP_DATE"); 	/*필수 1차 입찰일 - YYYYMMDD                                                                                                                                                                                                                   */
		String bidd_sdop_date = guarInfo.get("BIDD_SDOP_DATE"); 	/*2차 입찰일 - YYYYMMDD                                                                                                                                                                                                                   */
		String bidd_open_spot = guarInfo.get("BIDD_OPEN_SPOT"); 	/*입찰장소                                                                                                                                                                                                                                */
		String hist_bond_numb = guarInfo.get("HIST_BOND_NUMB"); 	/*변경(배서) 대상 증권번호 - 기존에 발행되었던 신규(원) 증권번호(18자리) 예)100000200801111111- 꼭 18자리 원증권번호이어야 함- 기존 증권구분번호가 004001100000200800123456 00 이었다면 밑줄 되어 있는 부분이 원증권번호 18자리 임        */

		/* 채권자 정보     */
		String cred_exst_code = guarInfo.get("CRED_EXST_CODE"); 	/*필수  채권자 존재형태 구분 - 1:단독, 2:공동                                    */
		String cred_orga_name = guarInfo.get("CRED_ORGA_NAME"); 	/*필수  기관명 - 피보험자 상호                                                   */
		String cred_orps_divs = guarInfo.get("CRED_ORPS_DIVS"); 	/*필수  개인/사업자 구분 코드 - O - 사업자, P - 개인                             */
		//String cred_orga_numb = guarInfo.get("CRED_ORGA_NUMB"); 	/*필수  법인등록번호                                                             */
		String cred_orga_numb  = "0000000000000";		
		String cred_orps_iden = guarInfo.get("CRED_ORPS_IDEN"); 	/*필수  "사업자/주민등록번호 - O인 경우 사업자번호, P인 경우 주민등록번호"       */
		String cred_ownr_numb = guarInfo.get("CRED_OWNR_NUMB"); 	/*대표자 주민등록번호                                                      */
		String cred_ownr_name = guarInfo.get("CRED_OWNR_NAME"); 	/*대표자 성명                                                              */
		String cred_bond_hold = guarInfo.get("CRED_BOND_HOLD"); 	/*필수  채권자 명(상호)                                                          */
		String cred_addn_name = guarInfo.get("CRED_ADDN_NAME"); 	/* 채권기관 부가상호                                                        */
		String cred_orga_post = guarInfo.get("CRED_ORGA_POST"); 	/*필수  회사 우편번호                                                            */
		String cred_orga_addr = guarInfo.get("CRED_ORGA_ADDR"); 	/*필수  회사 주소                                                                */
		String cred_chrg_name = guarInfo.get("CRED_CHRG_NAME"); 	/*필수  담당자 이름                                                              */
		String cred_dept_name = guarInfo.get("CRED_DEPT_NAME"); 	/*필수  담당자 소속 부서                                                         */
		String cred_phon_numb = guarInfo.get("CRED_PHON_NUMB"); 	/*필수  담당자 전화 번호                                                         */
		String cred_cell_phon = guarInfo.get("CRED_CELL_PHON"); 	/*필수  담당자 휴대전화 번호                                                     */
		String cred_send_mail = guarInfo.get("CRED_SEND_MAIL"); 	/*필수  담당자 e-Mail 주소                                                       */
		String cred_user_iden = guarInfo.get("CRED_USER_IDEN"); 	/*필수  수신처 아이디 - 헤더정보의 전문송신기관 아이디                           */
		String cred_user_type = guarInfo.get("CRED_USER_TYPE"); 	/*필수  수신처TYPE - 헤더정보의 연계기관코드                                     */

		/* 계약자 정보(A형인경우 계약자 정보필수, */
		String appl_exst_code = guarInfo.get("APPL_EXST_CODE"); 	/*필수 계약자 존재 형태 구분 - 1:단독, 2:공동                                        */
		String appl_orga_name = guarInfo.get("APPL_ORGA_NAME"); 	/*     기관명                                                                    */
		String appl_orps_divs = guarInfo.get("APPL_ORPS_DIVS"); 	/*     구분코드 - O:사업자 P:개인                                                */
		String appl_orga_numb = guarInfo.get("APPL_ORGA_NUMB"); 	/*     법인등록번호                                                              */
		String appl_orps_iden = guarInfo.get("APPL_ORPS_IDEN"); 	/*     "사업자/주민등록번호 - O인 경우 사업자번호, P인 경우 주민등록번호"        */
		
		//String	appl_orps_iden  = "2128300381";						/*     "테스트용 사업자번호        */
		
		String appl_ownr_numb = guarInfo.get("APPL_OWNR_NUMB"); 	/*     "대표자 주민등록번호 - 개인사업자일 경우 필수 입력"                       */
		String appl_ownr_name = guarInfo.get("APPL_OWNR_NAME"); 	/*     대표자 이름                                                               */
		String appl_addn_name = guarInfo.get("APPL_ADDN_NAME"); 	/*     계약업체 부가 상호                                                        */
		String appl_orga_post = guarInfo.get("APPL_ORGA_POST"); 	/*     계약 회사 우편번호                                                        */
		String appl_orga_addr = guarInfo.get("APPL_ORGA_ADDR"); 	/*     계약 회사 주소                                                            */
		String appl_chrg_name = guarInfo.get("APPL_CHRG_NAME"); 	/*     담당자 이름                                                               */
		String appl_dept_name = guarInfo.get("APPL_DEPT_NAME"); 	/*     담당자 소속 부서                                                          */
		String appl_offc_phon = guarInfo.get("APPL_OFFC_PHON"); 	/*     담당자 전화 번호                                                          */
		String appl_cell_phon = guarInfo.get("APPL_CELL_PHON"); 	/*     담당자 휴대전화 번호                                                      */
		String appl_send_mail = guarInfo.get("APPL_SEND_MAIL"); 	/*     담당자 e-Mail 주소                                                        */
		String appl_home_post = guarInfo.get("APPL_HOME_POST"); 	/*     자택 우편번호                                                             */
		String appl_home_addr = guarInfo.get("APPL_HOME_ADDR"); 	/*     자택 주소                                                                 */
		String appl_home_phon = guarInfo.get("APPL_HOME_PHON"); 	/*     자택 전화 번호                                                            */
		String appl_user_iden = guarInfo.get("APPL_USER_IDEN"); 	/*필수 수신처 아이디 - 헤더정보의 전문송신기관                                   */
		String appl_user_type = guarInfo.get("APPL_USER_TYPE"); 	/*필수 수신처 Type - 헤더정보의 연계기관코드                                     */

		String xml_str = null;

		// 매핑 정보 파일, XML 탬플릿 정보 파일
		DataToXml datatoxml = new DataToXml( templates_path, headMesgType );
		if(datatoxml.getErrorCode()!=0)
		{
			System.out.println(datatoxml.getErrorMsg());
			return msg.getMessage("서울보증 전송 전문 xml 생성 실패");
		}

		/* HEADER */
		try{

			if(
				/* Begin of Header */
					datatoxml.setData("head_mesg_send", head_mesg_send)
				&&	datatoxml.setData("head_mesg_recv", head_mesg_recv)
				&&	datatoxml.setData("head_func_code", head_func_code)
				&&	datatoxml.setData("head_mesg_type", head_mesg_type)
				&&	datatoxml.setData("head_mesg_name", head_mesg_name)
				&&	datatoxml.setData("head_mesg_vers", head_mesg_vers)
				&&	datatoxml.setData("head_docu_numb", head_docu_numb)
				&&	datatoxml.setData("head_mang_numb", head_mang_numb)
				&&	datatoxml.setData("head_refr_numb", head_refr_numb)
				&&	datatoxml.setData("head_titl_name", head_titl_name)
				&&  datatoxml.setData("head_orga_code", head_orga_code)
				/* End of Header */

				/* 보험계약정보 Guarantee.Info.Details */
				&&  datatoxml.setData("bond_kind_code", bond_kind_code)
				&&  datatoxml.setData("bond_fnsh_date", bond_fnsh_date)
				&&  datatoxml.setData("bond_curc_code", bond_curc_code)
				&&  datatoxml.setData("bond_penl_amnt", bond_penl_amnt)

				/* 입찰공고 정보 Bidding.Info.Details */
				&& datatoxml.setData("bidd_noti_numb", bidd_noti_numb)
				&& datatoxml.setData("bidd_proc_type", bidd_proc_type)
				&& datatoxml.setData("bidd_name_text", bidd_name_text)
				&& datatoxml.setData("bidd_pric_rate", bidd_pric_rate)
				&& datatoxml.setData("bidd_fnsh_date", bidd_fnsh_date)
				&& datatoxml.setData("bidd_frop_date", bidd_frop_date)
				&& datatoxml.setData("bidd_sdop_date", bidd_sdop_date)
				&& datatoxml.setData("bidd_open_spot", bidd_open_spot)
				&& datatoxml.setData("hist_bond_numb", hist_bond_numb)

				/* 채권자 정보     */
				&& datatoxml.setData("cred_exst_code", cred_exst_code)
				&& datatoxml.setData("cred_orga_name", cred_orga_name)
				&& datatoxml.setData("cred_orps_divs", cred_orps_divs)
				&& datatoxml.setData("cred_orga_numb", cred_orga_numb)
				&& datatoxml.setData("cred_orps_iden", cred_orps_iden)
				&& datatoxml.setData("cred_ownr_numb", cred_ownr_numb)
				&& datatoxml.setData("cred_ownr_name", cred_ownr_name)
				&& datatoxml.setData("cred_bond_hold", cred_bond_hold)
				&& datatoxml.setData("cred_addn_name", cred_addn_name)
				&& datatoxml.setData("cred_orga_post", cred_orga_post)
				&& datatoxml.setData("cred_orga_addr", cred_orga_addr)
				&& datatoxml.setData("cred_chrg_name", cred_chrg_name)
				&& datatoxml.setData("cred_dept_name", cred_dept_name)
				&& datatoxml.setData("cred_phon_numb", cred_phon_numb)
				&& datatoxml.setData("cred_cell_phon", cred_cell_phon)
				&& datatoxml.setData("cred_send_mail", cred_send_mail)
				&& datatoxml.setData("cred_user_iden", cred_user_iden)
				&& datatoxml.setData("cred_user_type", cred_user_type)

				/* 계약자 정보(A형인경우 계약자 정보필수, */
				&& datatoxml.setData("appl_exst_code", appl_exst_code)
				&& datatoxml.setData("appl_orga_name", appl_orga_name)
				&& datatoxml.setData("appl_orps_divs", appl_orps_divs)
				&& datatoxml.setData("appl_orga_numb", appl_orga_numb)
				&& datatoxml.setData("appl_orps_iden", appl_orps_iden)
				&& datatoxml.setData("appl_ownr_numb", appl_ownr_numb)
				&& datatoxml.setData("appl_ownr_name", appl_ownr_name)
				&& datatoxml.setData("appl_addn_name", appl_addn_name)
				&& datatoxml.setData("appl_orga_post", appl_orga_post)
				&& datatoxml.setData("appl_orga_addr", appl_orga_addr)
				&& datatoxml.setData("appl_chrg_name", appl_chrg_name)
				&& datatoxml.setData("appl_dept_name", appl_dept_name)
				&& datatoxml.setData("appl_offc_phon", appl_offc_phon)
				&& datatoxml.setData("appl_cell_phon", appl_cell_phon)
				&& datatoxml.setData("appl_send_mail", appl_send_mail)
				&& datatoxml.setData("appl_home_post", appl_home_post)
				&& datatoxml.setData("appl_home_addr", appl_home_addr)
				&& datatoxml.setData("appl_home_phon", appl_home_phon)
				&& datatoxml.setData("appl_user_iden", appl_user_iden)
				&& datatoxml.setData("appl_user_type", appl_user_type)
			)
			{
				xml_str = datatoxml.getxmlData();
				
				if(PropertiesManager.getBoolean("eversrm.system.developmentFlag")) {// 개발서버에서는
			        if(PropertiesManager.getBoolean("eversrm.system.localserver")) {// 개발서버에서는 고정된 값으로.
						datatoxml.writexmlFile("C:/mmmm.xml");
			        } else {
						datatoxml.writexmlFile("/svc/nhepro/TempXml/mmmm.xml");
			        }
		        } else {
		        	datatoxml.writexmlFile("C:/mmmm.xml");
		        }
				
				logger.debug(xml_str);
				System.err.println("===xml start=======================================================================================================");
				System.err.println(xml_str);
				System.err.println("===xml end=======================================================================================================");
			} else {
				throw new Exception(datatoxml.getErrorMsg());
			}
		}
		catch(Exception e){
			logger.error(e.getMessage());
			throw e;
		}
		/////////////////////// xml문서 생성 end ////////////////////////

		if(xml_str == null){
            logger.debug("xml문서 생성 실패");
			return msg.getMessage("서울보증 전송 전문 xml 생성 실패");
		}
		System.out.println("=================== 전송 시작 =========================");
		try {
		// 로컬서버가 아닌 경우
	        if( !PropertiesManager.getBoolean("eversrm.system.localserver") ) {
				SGIxLinker xLinker =  new SGIxLinker(sendinfo_conf, "send_jsp", true);
				xLinker.setXmlEncoding("UTF-8");
				
		    	boolean isOK = xLinker.doSendProcess(xml_str, null);
				if(!isOK) {
					logger.debug("SGIxLinker 에러메시지:" + xLinker.getErrorMsg());
					throw new Exception("=="+xLinker.getErrorMsg()+"==");
				}
		
				String recvXml = xLinker.getRecvXmlData();
				XmlToData xmlToData = null;
				try{
					System.err.println("==recvXmlrecvXmlrecvXmlrecvXmlrecvXmlrecvXmlrecvXmlrecvXmlrecvXmlrecvXmlrecvXml==========================================================recvXml==recvXml="+recvXml);
					xmlToData = new XmlToData(xLinker.getTempPath() , "RESPONSE", recvXml);
					if( xmlToData.getErrorCode() != 0 ) {
		                logger.debug(xmlToData.getErrorMsg());
						throw new Exception("=="+xmlToData.getErrorMsg()+"==");
					}
				}
				catch(Exception e){
					logger.error(e.getMessage());
					throw new Exception("=="+xmlToData.getErrorMsg()+"==");
				}
		
				System.out.println("=================================4=xmlToData :" + xmlToData);
				String res_cont_num = xmlToData.getData("res_cont_num");
				//String res_docu_num = xmlToData.getData("res_docu_num");
				String respTypeCode = xmlToData.getData("res_info_code");
				String respTypeName = xmlToData.getData("res_info_typename");
				String respMesgText = xmlToData.getData("res_info_result");
	
				System.out.println("계약번호 = "+res_cont_num);
				System.out.println("응답코드 = "+respTypeCode);
				System.out.println("응답코드명 = "+respTypeName);
				System.out.println("응답메시지 = "+respMesgText);
				if(respTypeCode==null || !"SA".equals(respTypeCode)) {
					throw new Exception("정상적으로 처리되지 않았습니다.");
				}
	        }	
				// STOCBDAP(협력사 입찰참가신청정보)의 INSU_STATUS = 'TA'로 변경
		    	sctr0010_mapper.setGuarSendCompleteBdhd(guarData);
	        //}
		}catch (Exception e) {
    		logger.error(e.getMessage());
			throw e;
		}
    	
    	return msg.getMessage("0001");
    }
    
    /**
	 * 협력사 입찰참가신청 : 입찰보증증권 증권번호 발행전 취소
	 * @param param
	 * @param grid
	 * @throws Exception
	 */
    public String sendBdhdGuarCancel(Map<String, Object> guarData) throws Exception {
    	
    	//Map<String, Object> guarData = grid.get(0);
    	
    	/*  GUAR_TYPE : ADV	  선급보증 ,CONT 계약보증	,WARR 하자보증	,DIF	 차액보증 */
    	// 1. [필수] 전문송신기관(송신자ID : A+피보험자사업자번호+00 (총 13자리))
		String	head_mesg_send  = "";	/*	[필수]	 전문송신기관	*/
        if(PropertiesManager.getBoolean("eversrm.system.developmentFlag")) {// 개발서버에서는 고정된 값으로.
    		head_mesg_send="A120870175500";
        } else {
    		head_mesg_send="A120870175500";
        }
        guarData.put("HEAD_MESG_SEND", head_mesg_send);
        
        // 서울보증증권 전송전문 가져오기
    	Map<String, String> guarInfo = sctr0010_mapper.getGuarDataBdhd(guarData);
    	System.err.println("==============================guarInfo=============="+guarInfo);
    	
    	
    	String guarReqNum = "";
    	if( StringUtils.isEmpty(guarInfo.get("GUAR_REQ_NUM")) ) {
    		guarReqNum = docNumService.getDocNumber(PropertiesManager.getString("eversrm.default.company.code"), "GU");
    	}
    	else {
    		guarReqNum = String.valueOf(guarData.get("GUAR_REQ_NUM"));
    	}
    	guarData.put("GUAR_REQ_NUM", guarReqNum);
    	
        String sendinfo_conf  = PropertiesManager.getString("sendinfo_conf", "");	// 서울보증전송 설정정보 가져오기
        String templates_path = PropertiesManager.getString("templates_path", "");	// 서울보증 템플릿 경로
        
        /**
		 * 문서코드(문서명) -  BIDINF(입찰정보통보서)
		 * 상품(보험종류)구분코드- 001:입찰
		 */
        
        /* HEADER */
        String headMesgType = "BIDINF";
        String headMesgName = "입찰정보통보서";
        
        // 2. [필수] 수신처ID (z120811300200 : 서울보증보험 13자리 고정값)
    	//String headMesgRecv    = PropertiesManager.getString("eversrm.head_mesg_recv");
    	String head_mesg_recv  = "z120811300200";	/*	[필수]	 전문수신기관	*/
		String head_func_code  = "1";				/*	[필수]	 문서기능 (9 : 원본, 1 : 취소, 53 : 테스트)	*/
		String head_mesg_type  = headMesgType;		/*	[필수]	 문서코드 (BIDINF : 입찰정보통보서, CONINF : 계약정보통보서, FLRINF : 하자정보통보서, PREINF : 선금정보통보서)	*/
		String head_mesg_name  = headMesgName;		/*	[필수]	 문서명	*/
		String head_mesg_vers  = "1.0";				/*	[선택]	 전자문서버전	*/
		
		// 계약보증번호 채번
		//String guarReqNum = docNumService.getDocNumber(PropertiesManager.getString("eversrm.default.company.code"), "GU");
    	//guarData.put("GUAR_REQ_NUM", guarReqNum);

		String head_docu_numb  = guarInfo.get("HEAD_DOCU_NUMB");	/*	[필수]	 문서번호	*/
		String head_mang_numb  = guarInfo.get("HEAD_MANG_NUMB");	/*	[필수]	 문서관리번호 (피보험자측 계약번호(차수포함) : CONT_NUM+CONT_CNT+'_'+GUAR_REQ_NUM)	*/
		String head_refr_numb  = guarInfo.get("HEAD_REFR_NUMB");	/*	[필수]	 참조번호 (피보험자측 계약번호(차수포함) : CONT_NUM+CONT_CNT+'_'+GUAR_REQ_NUM)	*/

		String head_titl_name  = headMesgName;		/*	[필수]	문서개요(=문서명과 동일)	*/
		String head_orga_code  = "NHI";   		/*  [필수]   연계기관코드   */
		
		head_docu_numb = head_docu_numb.replaceAll("XXXXXXXXXX", guarReqNum);
		head_mang_numb = head_mang_numb.replaceAll("XXXXXXXXXX", guarReqNum);
		head_refr_numb = head_refr_numb.replaceAll("XXXXXXXXXX", guarReqNum);

		/** BODY */
		/* 보험계약정보 Guarantee.Info.Details */
		String	bond_kind_code  = "001"; 							/*	[필수]	" 보험종목구분(001:입찰, 002:계약, 003:하자, 004:선금, 006:지급)"	*/
		String	bond_fnsh_date  = guarInfo.get("BOND_FNSH_DATE"); 	/*	[필수]	" 보험종료일자 - YYYYMMDD"	*/
		String	bond_curc_code  = "WON"; 							/*		" 보험가입금액 통화코드 - WON(원화), USD(미달러),EUR(유로화) 등"	*/
		String	bond_penl_amnt  = String.valueOf(guarInfo.get("BOND_PENL_AMNT")); 	/*		" 보험가입금액 예) 1500000	*/

		/* 입찰공고 정보 Bidding.Info.Details */
		String bidd_noti_numb = guarInfo.get("BIDD_NOTI_NUMB"); 	/*필수 공고번호 - 피보험자 측 입찰번호 (차수를 포함한 정확한 입찰번호만 기재) ex) T2008100100                                                                                                                                                  */
		String bidd_proc_type = guarInfo.get("BIDD_PROC_TYPE"); 	/*필수 계약구분코드 - 별첨 sheet의 코드 참조                                                                                                                                                                                                   */
		String bidd_name_text = guarInfo.get("BIDD_NAME_TEXT"); 	/*필수 입찰건명                                                                                                                                                                                                                                */
		String bidd_pric_rate = guarInfo.get("BIDD_PRIC_RATE"); 	/*     보증금율                                                                                                                                                                                                                                */
		String bidd_frop_date = guarInfo.get("BIDD_FROP_DATE"); 	/*필수 1차 입찰일 - YYYYMMDD                                                                                                                                                                                                                   */
		String bidd_sdop_date = guarInfo.get("BIDD_SDOP_DATE"); 	/*     2차 입찰일 - YYYYMMDD                                                                                                                                                                                                                   */
		String bidd_fnsh_date = guarInfo.get("BIDD_FNSH_DATE");     /*	입찰마감일자	*/
		String bidd_open_spot = guarInfo.get("BIDD_OPEN_SPOT"); 	/*     입찰장소                                                                                                                                                                                                                                */
		String hist_bond_numb = guarInfo.get("HIST_BOND_NUMB"); 	/*     변경(배서) 대상 증권번호 - 기존에 발행되었던 신규(원) 증권번호(18자리) 예)100000200801111111- 꼭 18자리 원증권번호이어야 함- 기존 증권구분번호가 004001100000200800123456 00 이었다면 밑줄 되어 있는 부분이 원증권번호 18자리 임        */

		/* 채권자 정보     */
		String cred_exst_code = guarInfo.get("CRED_EXST_CODE"); 	/*필수  채권자 존재형태 구분 - 1:단독, 2:공동                                    */
		String cred_orga_name = guarInfo.get("CRED_ORGA_NAME"); 	/*필수  기관명 - 피보험자 상호                                                   */
		String cred_orps_divs = guarInfo.get("CRED_ORPS_DIVS"); 	/*필수  개인/사업자 구분 코드 - O - 사업자, P - 개인                             */
		//String cred_orga_numb = guarInfo.get("CRED_ORGA_NUMB"); 	/*필수  법인등록번호                                                             */
		String cred_orga_numb  = "0000000000000";	
		String cred_orps_iden = guarInfo.get("CRED_ORPS_IDEN"); 	/*필수  "사업자/주민등록번호 - O인 경우 사업자번호, P인 경우 주민등록번호"       */
		String cred_ownr_numb = guarInfo.get("CRED_OWNR_NUMB"); 	/*      대표자 주민등록번호                                                      */
		String cred_ownr_name = guarInfo.get("CRED_OWNR_NAME"); 	/*      대표자 성명                                                              */
		String cred_bond_hold = guarInfo.get("CRED_BOND_HOLD"); 	/*필수  채권자 명(상호)                                                          */
		String cred_addn_name = guarInfo.get("CRED_ADDN_NAME"); 	/*      채권기관 부가상호                                                        */
		String cred_orga_post = guarInfo.get("CRED_ORGA_POST"); 	/*필수  회사 우편번호                                                            */
		String cred_orga_addr = guarInfo.get("CRED_ORGA_ADDR"); 	/*필수  회사 주소                                                                */
		String cred_chrg_name = guarInfo.get("CRED_CHRG_NAME"); 	/*필수  담당자 이름                                                              */
		String cred_dept_name = guarInfo.get("CRED_DEPT_NAME"); 	/*필수  담당자 소속 부서                                                         */
		String cred_phon_numb = guarInfo.get("CRED_PHON_NUMB"); 	/*필수  담당자 전화 번호                                                         */
		String cred_cell_phon = guarInfo.get("CRED_CELL_PHON"); 	/*필수  담당자 휴대전화 번호                                                     */
		String cred_send_mail = guarInfo.get("CRED_SEND_MAIL"); 	/*필수  담당자 e-Mail 주소                                                       */
		String cred_user_iden = guarInfo.get("CRED_USER_IDEN"); 	/*필수  수신처 아이디 - 헤더정보의 전문송신기관 아이디                           */
		String cred_user_type = guarInfo.get("CRED_USER_TYPE"); 	/*필수  수신처TYPE - 헤더정보의 연계기관코드                                     */

		/* 계약자 정보(A형인경우 계약자 정보필수, */
		String appl_exst_code = guarInfo.get("APPL_EXST_CODE"); 	/*필수 계약자 존재 형태 구분 - 1:단독, 2:공동                                        */
		String appl_orga_name = guarInfo.get("APPL_ORGA_NAME"); 	/*     기관명                                                                    */
		String appl_orps_divs = guarInfo.get("APPL_ORPS_DIVS"); 	/*     구분코드 - O:사업자 P:개인                                                */
		String appl_orga_numb = guarInfo.get("APPL_ORGA_NUMB"); 	/*     법인등록번호                                                              */
		String appl_orps_iden = guarInfo.get("APPL_ORPS_IDEN"); 	/*     "사업자/주민등록번호 - O인 경우 사업자번호, P인 경우 주민등록번호"        */
		String appl_ownr_numb = guarInfo.get("APPL_OWNR_NUMB"); 	/*     "대표자 주민등록번호 - 개인사업자일 경우 필수 입력"                       */
		String appl_ownr_name = guarInfo.get("APPL_OWNR_NAME"); 	/*     대표자 이름                                                               */
		String appl_addn_name = guarInfo.get("APPL_ADDN_NAME"); 	/*     계약업체 부가 상호                                                        */
		String appl_orga_post = guarInfo.get("APPL_ORGA_POST"); 	/*     계약 회사 우편번호                                                        */
		String appl_orga_addr = guarInfo.get("APPL_ORGA_ADDR"); 	/*     계약 회사 주소                                                            */
		String appl_chrg_name = guarInfo.get("APPL_CHRG_NAME"); 	/*     담당자 이름                                                               */
		String appl_dept_name = guarInfo.get("APPL_DEPT_NAME"); 	/*     담당자 소속 부서                                                          */
		String appl_offc_phon = guarInfo.get("APPL_OFFC_PHON"); 	/*     담당자 전화 번호                                                          */
		String appl_cell_phon = guarInfo.get("APPL_CELL_PHON"); 	/*     담당자 휴대전화 번호                                                      */
		String appl_send_mail = guarInfo.get("APPL_SEND_MAIL"); 	/*     담당자 e-Mail 주소                                                        */
		String appl_home_post = guarInfo.get("APPL_HOME_POST"); 	/*     자택 우편번호                                                             */
		String appl_home_addr = guarInfo.get("APPL_HOME_ADDR"); 	/*     자택 주소                                                                 */
		String appl_home_phon = guarInfo.get("APPL_HOME_PHON"); 	/*     자택 전화 번호                                                            */
		String appl_user_iden = guarInfo.get("APPL_USER_IDEN"); 	/*필수 수신처 아이디 - 헤더정보의 전문송신기관                                   */
		String appl_user_type = guarInfo.get("APPL_USER_TYPE"); 	/*필수 수신처 Type - 헤더정보의 연계기관코드                                     */

		String xml_str = null;

		// 매핑 정보 파일, XML 탬플릿 정보 파일
		DataToXml datatoxml = new DataToXml( templates_path, headMesgType );
		if(datatoxml.getErrorCode()!=0)
		{
			System.out.println(datatoxml.getErrorMsg());
			return msg.getMessage("서울보증 전송 전문 xml 생성 실패");
		}

		/* HEADER */
		try{

			if(
				/* Begin of Header */
					datatoxml.setData("head_mesg_send", head_mesg_send)
				&&	datatoxml.setData("head_mesg_recv", head_mesg_recv)
				&&	datatoxml.setData("head_func_code", head_func_code)
				&&	datatoxml.setData("head_mesg_type", head_mesg_type)
				&&	datatoxml.setData("head_mesg_name", head_mesg_name)
				&&	datatoxml.setData("head_mesg_vers", head_mesg_vers)
				&&	datatoxml.setData("head_docu_numb", head_docu_numb)
				&&	datatoxml.setData("head_mang_numb", head_mang_numb)
				&&	datatoxml.setData("head_refr_numb", head_refr_numb)
				&&	datatoxml.setData("head_titl_name", head_titl_name)
				&&  datatoxml.setData("head_orga_code", head_orga_code)
				/* End of Header */

				/* 보험계약정보 Guarantee.Info.Details */
				&&  datatoxml.setData("bond_kind_code", bond_kind_code)
				&&  datatoxml.setData("bond_fnsh_date", bond_fnsh_date)
				&&  datatoxml.setData("bond_curc_code", bond_curc_code)
				&&  datatoxml.setData("bond_penl_amnt", bond_penl_amnt)

				/* 입찰공고 정보 Bidding.Info.Details */
				&& datatoxml.setData("bidd_noti_numb", bidd_noti_numb)
				&& datatoxml.setData("bidd_proc_type", bidd_proc_type)
				&& datatoxml.setData("bidd_name_text", bidd_name_text)
				&& datatoxml.setData("bidd_pric_rate", bidd_pric_rate)
				&& datatoxml.setData("bidd_fnsh_date", bidd_fnsh_date)
				&& datatoxml.setData("bidd_frop_date", bidd_frop_date)
				&& datatoxml.setData("bidd_sdop_date", bidd_sdop_date)
				&& datatoxml.setData("bidd_open_spot", bidd_open_spot)
				&& datatoxml.setData("hist_bond_numb", hist_bond_numb)

				/* 채권자 정보     */
				&& datatoxml.setData("cred_exst_code", cred_exst_code)
				&& datatoxml.setData("cred_orga_name", cred_orga_name)
				&& datatoxml.setData("cred_orps_divs", cred_orps_divs)
				&& datatoxml.setData("cred_orga_numb", cred_orga_numb)
				&& datatoxml.setData("cred_orps_iden", cred_orps_iden)
				&& datatoxml.setData("cred_ownr_numb", cred_ownr_numb)
				&& datatoxml.setData("cred_ownr_name", cred_ownr_name)
				&& datatoxml.setData("cred_bond_hold", cred_bond_hold)
				&& datatoxml.setData("cred_addn_name", cred_addn_name)
				&& datatoxml.setData("cred_orga_post", cred_orga_post)
				&& datatoxml.setData("cred_orga_addr", cred_orga_addr)
				&& datatoxml.setData("cred_chrg_name", cred_chrg_name)
				&& datatoxml.setData("cred_dept_name", cred_dept_name)
				&& datatoxml.setData("cred_phon_numb", cred_phon_numb)
				&& datatoxml.setData("cred_cell_phon", cred_cell_phon)
				&& datatoxml.setData("cred_send_mail", cred_send_mail)
				&& datatoxml.setData("cred_user_iden", cred_user_iden)
				&& datatoxml.setData("cred_user_type", cred_user_type)

				/* 계약자 정보(A형인경우 계약자 정보필수, */
				&& datatoxml.setData("appl_exst_code", appl_exst_code)
				&& datatoxml.setData("appl_orga_name", appl_orga_name)
				&& datatoxml.setData("appl_orps_divs", appl_orps_divs)
				&& datatoxml.setData("appl_orga_numb", appl_orga_numb)
				&& datatoxml.setData("appl_orps_iden", appl_orps_iden)
				&& datatoxml.setData("appl_ownr_numb", appl_ownr_numb)
				&& datatoxml.setData("appl_ownr_name", appl_ownr_name)
				&& datatoxml.setData("appl_addn_name", appl_addn_name)
				&& datatoxml.setData("appl_orga_post", appl_orga_post)
				&& datatoxml.setData("appl_orga_addr", appl_orga_addr)
				&& datatoxml.setData("appl_chrg_name", appl_chrg_name)
				&& datatoxml.setData("appl_dept_name", appl_dept_name)
				&& datatoxml.setData("appl_offc_phon", appl_offc_phon)
				&& datatoxml.setData("appl_cell_phon", appl_cell_phon)
				&& datatoxml.setData("appl_send_mail", appl_send_mail)
				&& datatoxml.setData("appl_home_post", appl_home_post)
				&& datatoxml.setData("appl_home_addr", appl_home_addr)
				&& datatoxml.setData("appl_home_phon", appl_home_phon)
				&& datatoxml.setData("appl_user_iden", appl_user_iden)
				&& datatoxml.setData("appl_user_type", appl_user_type)
			)
			{
				xml_str = datatoxml.getxmlData();
				
		        if(PropertiesManager.getBoolean("eversrm.system.developmentFlag")) {// 개발서버에서는
			        if(PropertiesManager.getBoolean("eversrm.system.localserver")) {// 개발서버에서는 고정된 값으로.
						datatoxml.writexmlFile("C:/mmmm.xml");
			        } else {
						datatoxml.writexmlFile("/svc/nhepro/TempXml/mmmm.xml");
			        }
		        } else {
		        	datatoxml.writexmlFile("C:/mmmm.xml");
		        }
		        
				logger.debug(xml_str);
				System.err.println("===xml start=======================================================================================================");
				System.err.println(xml_str);
				System.err.println("===xml end=======================================================================================================");
			} else {
				throw new Exception(datatoxml.getErrorMsg());
			}
		}
		catch(Exception e){
			logger.error(e.getMessage());
			throw e;
		}
		/////////////////////// xml문서 생성 end ////////////////////////

		if(xml_str == null){
            logger.debug("xml문서 생성 실패");
			return msg.getMessage("서울보증 전송 전문 xml 생성 실패");
		}
		
		try {
		// 로컬서버가 아닌 경우
	        if( !PropertiesManager.getBoolean("eversrm.system.localserver") ) {
				SGIxLinker xLinker =  new SGIxLinker(sendinfo_conf, "send_jsp", true);
				xLinker.setXmlEncoding("UTF-8");
				
		    	boolean isOK = xLinker.doSendProcess(xml_str, null);
				if(!isOK) {
					logger.debug("SGIxLinker 에러메시지:" + xLinker.getErrorMsg());
					throw new Exception("=="+xLinker.getErrorMsg()+"==");
				}
		
				String recvXml = xLinker.getRecvXmlData();
				XmlToData xmlToData = null;
				try{
					System.err.println("==recvXmlrecvXmlrecvXmlrecvXmlrecvXmlrecvXmlrecvXmlrecvXmlrecvXmlrecvXmlrecvXml==========================================================recvXml==recvXml="+recvXml);
					xmlToData = new XmlToData(xLinker.getTempPath() , "RESPONSE", recvXml);
					if( xmlToData.getErrorCode() != 0 ) {
		                logger.debug(xmlToData.getErrorMsg());
						throw new Exception("=="+xmlToData.getErrorMsg()+"==");
					}
				}
				catch(Exception e){
					logger.error(e.getMessage());
					throw new Exception("=="+xmlToData.getErrorMsg()+"==");
				}
		
				System.out.println("=================================4=xmlToData :" + xmlToData);
				String res_cont_num = xmlToData.getData("res_cont_num");
				//String res_docu_num = xmlToData.getData("res_docu_num");
				String respTypeCode = xmlToData.getData("res_info_code");
				String respTypeName = xmlToData.getData("res_info_typename");
				String respMesgText = xmlToData.getData("res_info_result");
	
				System.out.println("계약번호 = "+res_cont_num);
				System.out.println("응답코드 = "+respTypeCode);
				System.out.println("응답코드명 = "+respTypeName);
				System.out.println("응답메시지 = "+respMesgText);
				if(respTypeCode==null || !"SA".equals(respTypeCode)) {
					throw new Exception("정상적으로 처리되지 않았습니다.");
				}
	        }	
				// STOCBDAP(협력사 입찰참가신청정보)의 INSU_STATUS = 'TA'로 변경
		    	sctr0010_mapper.upsGuarCancelRecevieBdhd(guarData);
		}catch (Exception e) {
    		logger.error(e.getMessage());
			throw e;
		}
    	
    	return msg.getMessage("0001");
    }
    
    //입찰보증 증권번호 발행 후 취소
    public String sendBdhdGuarDataCancel(Map<String, Object> guarData) throws Exception {
    	
    	//Map<String, Object> guarData = grid.get(0);
    	
    	/*  GUAR_TYPE : ADV	  선급보증 ,CONT 계약보증	,WARR 하자보증	,DIF	 차액보증 */
    	// 1. [필수] 전문송신기관(송신자ID : A+피보험자사업자번호+00 (총 13자리))
		String	head_mesg_send  = "";	/*	[필수]	 전문송신기관	*/
        if(PropertiesManager.getBoolean("eversrm.system.developmentFlag")) {// 개발서버에서는 고정된 값으로.
    		head_mesg_send="A120870175500";
        } else {
    		head_mesg_send="A120870175500";
        }
        guarData.put("HEAD_MESG_SEND", head_mesg_send);
        
        // 서울보증증권 전송전문 가져오기
    	Map<String, String> guarInfo = sctr0010_mapper.getGuarCancelDataBdhd(guarData);
    	System.err.println("==============================guarInfo=============="+guarInfo);
    	
    	
    	String guarReqNum = "";
    	if( StringUtils.isEmpty(guarInfo.get("GUAR_REQ_NUM")) ) {
    		guarReqNum = docNumService.getDocNumber(PropertiesManager.getString("eversrm.default.company.code"), "GU");
    	}
    	else {
    		guarReqNum = String.valueOf(guarData.get("GUAR_REQ_NUM"));
    	}
    	guarData.put("GUAR_REQ_NUM", guarReqNum);
    	
        String sendinfo_conf  = PropertiesManager.getString("sendinfo_conf", "");	// 서울보증전송 설정정보 가져오기
        String templates_path = PropertiesManager.getString("templates_path", "");	// 서울보증 템플릿 경로
        
        /**
		 * 문서코드(문서명) -  BIDINF(입찰정보통보서)
		 * 상품(보험종류)구분코드- 001:입찰
		 */
        
        /* HEADER */
        String headMesgType = "RBONGU";
        String headMesgName = "최종응답서";
        
        // 2. [필수] 수신처ID (z120811300200 : 서울보증보험 13자리 고정값)
    	//String headMesgRecv    = PropertiesManager.getString("eversrm.head_mesg_recv");
        String head_mesg_recv  = "z120811300200";					/*	[필수]	 전문수신기관	*/
		String head_func_code  = "53";								/*	[필수]	 문서기능 (9 : 원본, 1 : 취소, 53 : 테스트)	*/
		String head_mesg_type  = headMesgType;						/*	[필수]	 문서코드 (CONINF : 계약정보통보서, FLRINF : 하자정보통보서, PREINF : 선금정보통보서)	*/
		String head_mesg_name  = headMesgName;						/*	[필수]	 문서명	*/
		String head_mesg_vers  = "1.0";								/*	[선택]	 전자문서버전	*/
		
		String head_docu_numb  = guarInfo.get("HEAD_DOCU_NUMB");	/*	[필수]	 문서번호	*/
		String head_mang_numb  = guarInfo.get("HEAD_MANG_NUMB");	/*	[필수]	 문서관리번호 (피보험자측 계약번호(차수포함) : CONT_NUM+CONT_CNT+'_'+GUAR_REQ_NUM)	*/
		String head_refr_numb  = guarInfo.get("HEAD_REFR_NUMB");	/*	[필수]	 참조번호 (피보험자측 계약번호(차수포함) : CONT_NUM+CONT_CNT+'_'+GUAR_REQ_NUM)	*/

		String head_titl_name  = headMesgName;						/*	[필수]	문서개요(=문서명과 동일)	*/
		String head_orga_code  = "NHI";   							/*  [필수]   연계기관코드   */

		head_docu_numb = head_docu_numb.replaceAll("XXXXXXXXXX", guarReqNum);		/* 문서번호 */
		head_mang_numb = head_mang_numb.replaceAll("XXXXXXXXXX", guarReqNum);		/* 문서관리번호 */
		head_refr_numb = head_refr_numb.replaceAll("XXXXXXXXXX", guarReqNum);		/* 참조번호 */

		/** BODY */
		/* 문서정보 Document.Info.Details */
		String	docu_numb_text  = guarInfo.get("DOCU_NUMB_TEXT"); 					/*	[필수]	문서관리번호 (GUAR_REQ_NUM+''+'00') */
		docu_numb_text = docu_numb_text.replaceAll("XXXXXXXXXX", guarReqNum);		/* 문서관리번호 */
		String	docu_kind_code  = guarInfo.get("DOCU_KIND_CODE"); 					/*	[필수]	" 보험종목구분(001:입찰,002:계약,003:하자,004:선금,006:지급)"	*/
		String	docu_issu_date  = guarInfo.get("DOCU_ISSU_DATE"); 					/*	[선택]	작성일자	*/
		String	docu_user_type  = "NHI";  											/*	[필수]	연계기관코드*/
		
		/* 주요계약정보 MainContract.Info.Details */
		String	cont_numb_text  = guarInfo.get("CONT_NUMB_TEXT");					/*	[필수]	계약번호	*/
		cont_numb_text = cont_numb_text.replaceAll("XXXXXXXXXX", guarReqNum);

		String	cont_main_name  = guarInfo.get("CONT_MAIN_NAME");					/*	[필수]	계약명(특수문자 제외)	*/
		String	cont_curc_code  = guarInfo.get("CONT_CURC_CODE");					/*	[필수]	 계약금액(원화)/통화코드(WON)	*/
		String	cont_main_amnt  = String.valueOf(guarInfo.get("CONT_MAIN_AMNT"));	/*	[필수]	 계약금액(원화)/계약금액	*/

		/* 채권자 정보 Creditor.Info.Details */
		String	cred_bond_hold  = guarInfo.get("CRED_BOND_HOLD");					/*	[필수]	 채권자명	*/
		
		/* 계약자 정보 Applier.Info.Details */
		String	appl_orga_name  = guarInfo.get("APPL_ORGA_NAME");					/*	[필수]	 기관명	*/
		String	appl_orps_divs  = guarInfo.get("APPL_ORPS_DIVS");					/*	[필수]	 구분(O:사업자번호 P:주민등록번호)	*/
		String	appl_orps_iden  = guarInfo.get("APPL_ORPS_IDEN");					/*	[필수]	 사업자/주민번호	*/
		//String	appl_orps_iden  = "2128300381";									/*	[필수]	 테스트용 사업자번호 */
		String	appl_ownr_name  = guarInfo.get("APPL_OWNR_NAME");					/*	[필수]	 성명(대표자명)	*/
		
		/* 응답 정보 Response.Info.Details */
		String	resp_type_code  = "DD";												/*	[필수]	 응답코드	*/
		String	resp_type_name  = "취소";												/*	[필수]	 응답코드명	*/
		String	resp_mesg_text  = "보증신청내역취소";									/*	[필수]	 응답내용	*/

		String xml_str = null;

		// 매핑 정보 파일, XML 탬플릿 정보 파일
		DataToXml datatoxml = new DataToXml( templates_path, headMesgType );
		if(datatoxml.getErrorCode()!=0)
		{
			System.out.println(datatoxml.getErrorMsg());
			return msg.getMessage("서울보증 전송 전문 xml 생성 실패");
		}

		/* HEADER */
		try{

			if(
					/* Begin of Header */
					datatoxml.setData("head_mesg_send", head_mesg_send)
				&&	datatoxml.setData("head_mesg_recv", head_mesg_recv)
				&&	datatoxml.setData("head_func_code", head_func_code)
				&&	datatoxml.setData("head_mesg_type", head_mesg_type)
				&&	datatoxml.setData("head_mesg_name", head_mesg_name)
				&&	datatoxml.setData("head_mesg_vers", head_mesg_vers)
				&&	datatoxml.setData("head_docu_numb", head_docu_numb)
				&&	datatoxml.setData("head_mang_numb", head_mang_numb)
				&&	datatoxml.setData("head_refr_numb", head_refr_numb)
				&&	datatoxml.setData("head_titl_name", head_titl_name)
				&&  datatoxml.setData("head_orga_code", head_orga_code)
				/* End of Header */

				/* Begin of 문서정보 */
				&&  datatoxml.setData("docu_numb_text", docu_numb_text)
				&&  datatoxml.setData("docu_kind_code", docu_kind_code)
				&&  datatoxml.setData("docu_issu_date", docu_issu_date)
				&&  datatoxml.setData("docu_user_type", docu_user_type)
				/* End of 문서정보 */

				/* Begin of 주요계약정보 */
				&&  datatoxml.setData("cont_numb_text", cont_numb_text)
				&&  datatoxml.setData("cont_main_name", cont_main_name)
				&&  datatoxml.setData("cont_curc_code", cont_curc_code)
				&&  datatoxml.setData("cont_main_amnt", cont_main_amnt)
				/* End of 주요계약정보 */

				/* Begin of 채권자 정보 */
				&&  datatoxml.setData("cred_bond_hold", cred_bond_hold)
				/* End of 채권자 정보 */

				/* Begin of 계약자 정보 */
				&&  datatoxml.setData("appl_orga_name", appl_orga_name)
				&&  datatoxml.setData("appl_orps_divs", appl_orps_divs)
				&&  datatoxml.setData("appl_orps_iden", appl_orps_iden)
				&&  datatoxml.setData("appl_ownr_name", appl_ownr_name)
				/* End of 계약자 정보 */
				
				/* Begin of 응답 정보 */
				&&  datatoxml.setData("resp_type_code", resp_type_code)
				&&  datatoxml.setData("resp_type_name", resp_type_name)
				&&  datatoxml.setData("resp_mesg_text", resp_mesg_text)
				/* End of 응답 정보 */
			)
			{
				xml_str = datatoxml.getxmlData();
				
		        if(PropertiesManager.getBoolean("eversrm.system.developmentFlag")) {// 개발서버에서는
			        if(PropertiesManager.getBoolean("eversrm.system.localserver")) {// 개발서버에서는 고정된 값으로.
						datatoxml.writexmlFile("C:/mmmm.xml");
			        } else {
						datatoxml.writexmlFile("/svc/nhepro/TempXml/mmmm.xml");
			        }
		        } else {
		        	datatoxml.writexmlFile("C:/mmmm.xml");
		        }
		        
				logger.debug(xml_str);
				System.err.println("===xml start=======================================================================================================");
				System.err.println(xml_str);
				System.err.println("===xml end=======================================================================================================");
			} else {
				throw new Exception(datatoxml.getErrorMsg());
			}
		}
		catch(Exception e){
			logger.error(e.getMessage());
			throw e;
		}
		/////////////////////// xml문서 생성 end ////////////////////////

		if(xml_str == null){
            logger.debug("xml문서 생성 실패");
			return msg.getMessage("서울보증 전송 전문 xml 생성 실패");
		}
		
		try {
		// 로컬서버가 아닌 경우
	        if( !PropertiesManager.getBoolean("eversrm.system.localserver") ) {
				SGIxLinker xLinker =  new SGIxLinker(sendinfo_conf, "send_jsp", true);
				xLinker.setXmlEncoding("UTF-8");
				
		    	boolean isOK = xLinker.doSendProcess(xml_str, null);
				if(!isOK) {
					logger.debug("SGIxLinker 에러메시지:" + xLinker.getErrorMsg());
					throw new Exception("=="+xLinker.getErrorMsg()+"==");
				}
		
				String recvXml = xLinker.getRecvXmlData();
				XmlToData xmlToData = null;
				try{
					System.err.println("==recvXmlrecvXmlrecvXmlrecvXmlrecvXmlrecvXmlrecvXmlrecvXmlrecvXmlrecvXmlrecvXml==========================================================recvXml==recvXml="+recvXml);
					xmlToData = new XmlToData(xLinker.getTempPath() , "RESPONSE", recvXml);
					if( xmlToData.getErrorCode() != 0 ) {
		                logger.debug(xmlToData.getErrorMsg());
						throw new Exception("=="+xmlToData.getErrorMsg()+"==");
					}
				}
				catch(Exception e){
					logger.error(e.getMessage());
					throw new Exception("=="+xmlToData.getErrorMsg()+"==");
				}
		
				System.out.println("=================================4=xmlToData :" + xmlToData);
				String res_cont_num = xmlToData.getData("res_cont_num");
				//String res_docu_num = xmlToData.getData("res_docu_num");
				String respTypeCode = xmlToData.getData("res_info_code");
				String respTypeName = xmlToData.getData("res_info_typename");
				String respMesgText = xmlToData.getData("res_info_result");
	
				System.out.println("계약번호 = "+res_cont_num);
				System.out.println("응답코드 = "+respTypeCode);
				System.out.println("응답코드명 = "+respTypeName);
				System.out.println("응답메시지 = "+respMesgText);
				if(respTypeCode==null || !"SA".equals(respTypeCode)) {
					throw new Exception("정상적으로 처리되지 않았습니다.");
				}
	        }	
				// STOCBDAP(협력사 입찰참가신청정보)의 INSU_STATUS = 'TA'로 변경
		    	sctr0010_mapper.upsGuarCancelRecevieBdhd(guarData);
		}catch (Exception e) {
    		logger.error(e.getMessage());
			throw e;
		}
    	
    	return msg.getMessage("0001");
    }
    
    //입찰보증 증권번호 발행 후 취소
    public String sendBdhdGuarNumDataCancel(Map<String, Object> guarData) throws Exception {
    	
    	//Map<String, Object> guarData = grid.get(0);
    	
    	/*  GUAR_TYPE : ADV	  선급보증 ,CONT 계약보증	,WARR 하자보증	,DIF	 차액보증 */
    	// 1. [필수] 전문송신기관(송신자ID : A+피보험자사업자번호+00 (총 13자리))
    	String guarNum = "";			/*	[필수]	 발급받은 증권번호(18자리)	*/
		String	head_mesg_send  = "";	/*	[필수]	 전문송신기관	*/
		
        if(PropertiesManager.getBoolean("eversrm.system.developmentFlag")) {// 개발서버에서는 고정된 값으로.
    		head_mesg_send="A120870175500";
        } else {
    		head_mesg_send="A120870175500";
        }
        guarData.put("HEAD_MESG_SEND", head_mesg_send);
        
        // 서울보증증권 전송전문 가져오기
    	Map<String, String> guarInfo = sctr0010_mapper.getGuarCancelDataBdhd(guarData);
    	System.err.println("==============================guarInfo=============="+guarInfo);
    	
    	
    	String guarReqNum = "";
    	if( StringUtils.isEmpty(guarInfo.get("GUAR_REQ_NUM")) ) {
    		guarReqNum = docNumService.getDocNumber(PropertiesManager.getString("eversrm.default.company.code"), "GU");
    	}
    	else {
    		guarReqNum = String.valueOf(guarData.get("GUAR_REQ_NUM"));
    	}
    	guarData.put("GUAR_REQ_NUM", guarReqNum);
    	
        String sendinfo_conf  = PropertiesManager.getString("sendinfo_conf", "");	// 서울보증전송 설정정보 가져오기
        String templates_path = PropertiesManager.getString("templates_path", "");	// 서울보증 템플릿 경로
        
        /**
		 * 문서코드(문서명) -  BIDINF(입찰정보통보서)
		 * 상품(보험종류)구분코드- 001:입찰
		 */
        
        guarNum = guarInfo.get("GUAR_NUM");
        
        /* HEADER */
        String headMesgType = "RBONGU";
        String headMesgName = "최종응답서";
        
        // 2. [필수] 수신처ID (z120811300200 : 서울보증보험 13자리 고정값)
    	//String headMesgRecv    = PropertiesManager.getString("eversrm.head_mesg_recv");
        String head_mesg_recv  = "z120811300200";					/*	[필수]	 전문수신기관	*/
		String head_func_code  = "53";								/*	[필수]	 문서기능 (9 : 원본, 1 : 취소, 53 : 테스트)	*/
		String head_mesg_type  = headMesgType;						/*	[필수]	 문서코드 (CONINF : 계약정보통보서, FLRINF : 하자정보통보서, PREINF : 선금정보통보서)	*/
		String head_mesg_name  = headMesgName;						/*	[필수]	 문서명	*/
		String head_mesg_vers  = "1.0";								/*	[선택]	 전자문서버전	*/
		
		String head_docu_numb  = guarInfo.get("HEAD_DOCU_NUMB");	/*	[필수]	 문서번호	*/
		String head_mang_numb  = guarInfo.get("HEAD_MANG_NUMB");	/*	[필수]	 문서관리번호 (피보험자측 계약번호(차수포함) : CONT_NUM+CONT_CNT+'_'+GUAR_REQ_NUM)	*/
		String head_refr_numb  = guarInfo.get("HEAD_REFR_NUMB");	/*	[필수]	 참조번호 (피보험자측 계약번호(차수포함) : CONT_NUM+CONT_CNT+'_'+GUAR_REQ_NUM)	*/

		String head_titl_name  = headMesgName;						/*	[필수]	문서개요(=문서명과 동일)	*/
		String head_orga_code  = "NHI";   							/*  [필수]   연계기관코드   */

		head_docu_numb = head_docu_numb.replaceAll("XXXXXXXXXX", guarNum);		/* 문서번호 */
		head_mang_numb = head_mang_numb.replaceAll("XXXXXXXXXX", guarNum);		/* 문서관리번호 */
		head_refr_numb = head_refr_numb.replaceAll("XXXXXXXXXX", guarNum);		/* 참조번호 */

		/** BODY */
		/* 문서정보 Document.Info.Details */
		String	docu_numb_text  = guarInfo.get("DOCU_NUMB_TEXT"); 					/*	[필수]	문서관리번호 (GUAR_REQ_NUM+''+'00') */
		docu_numb_text = docu_numb_text.replaceAll("XXXXXXXXXX", guarNum);			/* 문서관리번호 */
		String	docu_kind_code  = guarInfo.get("DOCU_KIND_CODE"); 					/*	[필수]	" 보험종목구분(001:입찰,002:계약,003:하자,004:선금,006:지급)"	*/
		String	docu_issu_date  = guarInfo.get("DOCU_ISSU_DATE"); 					/*	[선택]	작성일자	*/
		String	docu_user_type  = "NHI";  											/*	[필수]	연계기관코드*/
		
		/* 주요계약정보 MainContract.Info.Details */
		String	cont_numb_text  = guarInfo.get("CONT_NUMB_TEXT");					/*	[필수]	계약번호	*/
		cont_numb_text = cont_numb_text.replaceAll("XXXXXXXXXX", guarReqNum);

		String	cont_main_name  = guarInfo.get("CONT_MAIN_NAME");					/*	[필수]	계약명(특수문자 제외)	*/
		String	cont_curc_code  = guarInfo.get("CONT_CURC_CODE");					/*	[필수]	 계약금액(원화)/통화코드(WON)	*/
		String	cont_main_amnt  = String.valueOf(guarInfo.get("CONT_MAIN_AMNT"));	/*	[필수]	 계약금액(원화)/계약금액	*/

		/* 채권자 정보 Creditor.Info.Details */
		String	cred_bond_hold  = guarInfo.get("CRED_BOND_HOLD");					/*	[필수]	 채권자명	*/
		
		/* 계약자 정보 Applier.Info.Details */
		String	appl_orga_name  = guarInfo.get("APPL_ORGA_NAME");					/*	[필수]	 기관명	*/
		String	appl_orps_divs  = guarInfo.get("APPL_ORPS_DIVS");					/*	[필수]	 구분(O:사업자번호 P:주민등록번호)	*/
		String	appl_orps_iden  = guarInfo.get("APPL_ORPS_IDEN");					/*	[필수]	 사업자/주민번호	*/
		//String	appl_orps_iden  = "2128300381";										/*	[필수]	 테스트용 사업자번호	*/
		String	appl_ownr_name  = guarInfo.get("APPL_OWNR_NAME");					/*	[필수]	 성명(대표자명)	*/
		
		/* 응답 정보 Response.Info.Details */
		String	resp_type_code  = "DE";												/*	[필수]	 응답코드	*/
		String	resp_type_name  = "파기";												/*	[필수]	 응답코드명	*/
		String	resp_mesg_text  = "보증증권취소";										/*	[필수]	 응답내용	*/

		String xml_str = null;

		// 매핑 정보 파일, XML 탬플릿 정보 파일
		DataToXml datatoxml = new DataToXml( templates_path, headMesgType );
		if(datatoxml.getErrorCode()!=0)
		{
			System.out.println(datatoxml.getErrorMsg());
			return msg.getMessage("서울보증 전송 전문 xml 생성 실패");
		}

		/* HEADER */
		try{

			if(
					/* Begin of Header */
					datatoxml.setData("head_mesg_send", head_mesg_send)
				&&	datatoxml.setData("head_mesg_recv", head_mesg_recv)
				&&	datatoxml.setData("head_func_code", head_func_code)
				&&	datatoxml.setData("head_mesg_type", head_mesg_type)
				&&	datatoxml.setData("head_mesg_name", head_mesg_name)
				&&	datatoxml.setData("head_mesg_vers", head_mesg_vers)
				&&	datatoxml.setData("head_docu_numb", head_docu_numb)
				&&	datatoxml.setData("head_mang_numb", head_mang_numb)
				&&	datatoxml.setData("head_refr_numb", head_refr_numb)
				&&	datatoxml.setData("head_titl_name", head_titl_name)
				&&  datatoxml.setData("head_orga_code", head_orga_code)
				/* End of Header */

				/* Begin of 문서정보 */
				&&  datatoxml.setData("docu_numb_text", docu_numb_text)
				&&  datatoxml.setData("docu_kind_code", docu_kind_code)
				&&  datatoxml.setData("docu_issu_date", docu_issu_date)
				&&  datatoxml.setData("docu_user_type", docu_user_type)
				/* End of 문서정보 */

				/* Begin of 주요계약정보 */
				&&  datatoxml.setData("cont_numb_text", cont_numb_text)
				&&  datatoxml.setData("cont_main_name", cont_main_name)
				&&  datatoxml.setData("cont_curc_code", cont_curc_code)
				&&  datatoxml.setData("cont_main_amnt", cont_main_amnt)
				/* End of 주요계약정보 */

				/* Begin of 채권자 정보 */
				&&  datatoxml.setData("cred_bond_hold", cred_bond_hold)
				/* End of 채권자 정보 */

				/* Begin of 계약자 정보 */
				&&  datatoxml.setData("appl_orga_name", appl_orga_name)
				&&  datatoxml.setData("appl_orps_divs", appl_orps_divs)
				&&  datatoxml.setData("appl_orps_iden", appl_orps_iden)
				&&  datatoxml.setData("appl_ownr_name", appl_ownr_name)
				/* End of 계약자 정보 */
				
				/* Begin of 응답 정보 */
				&&  datatoxml.setData("resp_type_code", resp_type_code)
				&&  datatoxml.setData("resp_type_name", resp_type_name)
				&&  datatoxml.setData("resp_mesg_text", resp_mesg_text)
				/* End of 응답 정보 */
			)
			{
				xml_str = datatoxml.getxmlData();
				
		        if(PropertiesManager.getBoolean("eversrm.system.developmentFlag")) {// 개발서버에서는
			        if(PropertiesManager.getBoolean("eversrm.system.localserver")) {// 개발서버에서는 고정된 값으로.
						datatoxml.writexmlFile("C:/mmmm.xml");
			        } else {
						datatoxml.writexmlFile("/svc/nhepro/TempXml/mmmm.xml");
			        }
		        } else {
		        	datatoxml.writexmlFile("C:/mmmm.xml");
		        }
		        
				logger.debug(xml_str);
				System.err.println("===xml start=======================================================================================================");
				System.err.println(xml_str);
				System.err.println("===xml end=======================================================================================================");
			} else {
				throw new Exception(datatoxml.getErrorMsg());
			}
		}
		catch(Exception e){
			logger.error(e.getMessage());
			throw e;
		}
		/////////////////////// xml문서 생성 end ////////////////////////

		if(xml_str == null){
            logger.debug("xml문서 생성 실패");
			return msg.getMessage("서울보증 전송 전문 xml 생성 실패");
		}
		
		try {
		// 로컬서버가 아닌 경우
	        if( !PropertiesManager.getBoolean("eversrm.system.localserver") ) {
				SGIxLinker xLinker =  new SGIxLinker(sendinfo_conf, "send_jsp", true);
				xLinker.setXmlEncoding("UTF-8");
				
		    	boolean isOK = xLinker.doSendProcess(xml_str, null);
				if(!isOK) {
					logger.debug("SGIxLinker 에러메시지:" + xLinker.getErrorMsg());
					throw new Exception("=="+xLinker.getErrorMsg()+"==");
				}
		
				String recvXml = xLinker.getRecvXmlData();
				XmlToData xmlToData = null;
				try{
					System.err.println("==recvXmlrecvXmlrecvXmlrecvXmlrecvXmlrecvXmlrecvXmlrecvXmlrecvXmlrecvXmlrecvXml==========================================================recvXml==recvXml="+recvXml);
					xmlToData = new XmlToData(xLinker.getTempPath() , "RESPONSE", recvXml);
					if( xmlToData.getErrorCode() != 0 ) {
		                logger.debug(xmlToData.getErrorMsg());
						throw new Exception("=="+xmlToData.getErrorMsg()+"==");
					}
				}
				catch(Exception e){
					logger.error(e.getMessage());
					throw new Exception("=="+xmlToData.getErrorMsg()+"==");
				}
		
				System.out.println("=================================4=xmlToData :" + xmlToData);
				String res_cont_num = xmlToData.getData("res_cont_num");
				//String res_docu_num = xmlToData.getData("res_docu_num");
				String respTypeCode = xmlToData.getData("res_info_code");
				String respTypeName = xmlToData.getData("res_info_typename");
				String respMesgText = xmlToData.getData("res_info_result");
	
				System.out.println("계약번호 = "+res_cont_num);
				System.out.println("응답코드 = "+respTypeCode);
				System.out.println("응답코드명 = "+respTypeName);
				System.out.println("응답메시지 = "+respMesgText);
				if(respTypeCode==null || !"SA".equals(respTypeCode)) {
					throw new Exception("정상적으로 처리되지 않았습니다.");
				}
	        }	
				// STOCBDAP(협력사 입찰참가신청정보)의 INSU_STATUS = 'TA'로 변경
		    	sctr0010_mapper.upsGuarCancelRecevieBdhd(guarData);
		}catch (Exception e) {
    		logger.error(e.getMessage());
			throw e;
		}
    	
    	return msg.getMessage("0001");
    }

    public String sendGuarComplete(Map<String, String> param) throws Exception {
    	System.err.println("====================================================================param="+param);

    	param.put("GUAR_NUM",param.get("bond_numb_text")); 		 // 증권보증보험번호
    	param.put("BOND_BEGN_DATE",param.get("bond_begn_date")); // 보험시작일
    	param.put("BOND_FNSH_DATE",param.get("bond_fnsh_date")); // 보험만료일

    	param.put("INSU_STATUS", "SA" );
    	if("CONGUA".equals(param.get("head_mesg_type"))) {		// 계약보증서
    		//param.put("GUAR_TYPE", "CONT");
    		sctr0010_mapper.upsGuarRecevieEcpc(param);
    	}
    	else if("PREGUA".equals(param.get("head_mesg_type"))) { // 선급보증서
    		//param.put("GUAR_TYPE", "ADV");
    		sctr0010_mapper.upsGuarRecevieEcpc(param);
    	}
    	else if("FLRGUA".equals(param.get("head_mesg_type"))) { // 하자보증서
    		//param.put("GUAR_TYPE", "WARR");
    		sctr0010_mapper.upsGuarRecevieEcpc(param);
    	}
    	else if("BIDGUA".equals(param.get("head_mesg_type"))) { // 이행입찰보증서
    		sctr0010_mapper.upsGuarRecevieBdhd(param);
    	}
    	System.err.println("=====================================================================2");
    	
    	return msg.getMessage("0001");
    }
    
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public Map<String, String> getGuarInfoCheck(Map<String, String> formData) throws Exception {
    	return sctr0010_mapper.getGuarInfoCheck(formData);
    }
    
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public Map<String, String> getGuarNumInfoCheck(Map<String, String> formData) throws Exception {
    	return sctr0010_mapper.getGuarNumInfoCheck(formData);
    }
    
    //소프트웨어공제조합 보증신청응답 받은 후 처리
    public String sendGuarSWComplete(Map<String, String> param) throws Exception {
    	System.err.println("====================================================================param="+param);

    	String cont_numb_text = param.get("cont_numb_text");
    	
    	System.err.println("=====================================cont_numb_text="+cont_numb_text);
    	//GU20070000241
    	String guar_req_num = cont_numb_text.substring(cont_numb_text.indexOf("GU"),cont_numb_text.indexOf("GU")+13);
    	
    	System.err.println("=====================================guar_req_num="+guar_req_num);
    	param.put("GUAR_REQ_NUM", guar_req_num );
		
    	param.put("GUAR_NUM",param.get("bond_numb_text")); // 보증보험 번호
    	param.put("BOND_BEGN_DATE",param.get("bond_begn_date")); // 보증시작일
    	param.put("BOND_FNSH_DATE",param.get("bond_fnsh_date")); // 보증만료일
    	
    	if("CONGUA".equals(param.get("head_mesg_type"))) {		// 계약보증서
    		param.put("GUAR_TYPE", "CONT");
    	}
    	else if("PREGUA".equals(param.get("head_mesg_type"))) { // 선급보증서
    		param.put("GUAR_TYPE", "ADV");
    	}
    	else if("FLRGUA".equals(param.get("head_mesg_type"))) { // 하자보증서
    		param.put("GUAR_TYPE", "WARR");
    	}
    	
    	param.put("INSU_STATUS", "SA" );
    	
    	sctr0010_mapper.upsGuarRecevieEcpc(param);
    	
    	//sendGuarSWResponse(param);
    	
    	//if(bond_numb_text==null || "".equals(bond_numb_text)) {
    		//sctr0010_mapper.upsGuarCancelRecevieEcpc(param);   //보증 취소신청 후 응답
    	//}
    	//else {
    	//	param.put("INSU_STATUS", "SA" );
    	//	sctr0010_mapper.upsGuarRecevieEcpc(param);         //정상 신청 후 응답
    	//}
    	
		// 대금지급 : 사용안함
		//sctr0010_mapper.upsGuarRecevieIvap(param);
    	
		
		//param.put("HEAD_MESG_SEND", param.get("head_mesg_send") );
		//param.put("HEAD_MESG_RECV", param.get("head_mesg_recv") );
		//param.put("HEAD_FUNC_CODE", param.get("head_func_code") );
		//param.put("HEAD_MESG_TYPE", param.get("head_mesg_type") );
		//param.put("HEAD_MESG_NAME", param.get("head_mesg_name") );
		//param.put("HEAD_MESG_VERS", param.get("head_mesg_vers") );
		//param.put("HEAD_DOCU_NUMB", param.get("head_docu_numb") );
    	//param.put("HEAD_MANG_NUMB", param.get("head_mang_numb") );
    	//param.put("HEAD_REFR_NUMB", param.get("head_refr_numb") );
    	//param.put("HEAD_TITL_NAME", param.get("head_titl_name") );
    	//param.put("HEAD_ORGA_CODE", "" ); 
    	//param.put("BOND_ORGA_NAME", param.get("bond_orga_name") ); 
    	//param.put("BOND_ORGA_IDEN", param.get("bond_orga_iden") ); 
    	//param.put("BOND_ORGA_ADDN", param.get("bond_orga_addn") ); 
    	//param.put("BOND_ORGA_CEO",  param.get("bond_orga_ceo") ); 
    	//param.put("GOVN_ORGA_NAME", param.get("govn_orga_name") ); 
    	//param.put("GOVN_ORGA_IDEN", param.get("govn_orga_iden") ); 
    	//param.put("GOVN_ORGA_ADDN", param.get("govn_orga_addn") ); 
    	//param.put("GOVN_OWNR_NAME", param.get("govn_ownr_name") ); 
    	//param.put("DOCU_ISSU_DATE", param.get("docu_issu_date") ); 
    	//param.put("BUSI_CLAS_CODE", param.get("busi_clas_code") ); 
    	//param.put("BOND_NUMB_TEXT", param.get("bond_numb_text") ); 
    	//param.put("BOND_PENL_TEXT", param.get("bond_penl_text") ); 
    	//param.put("BOND_PENL_AMNT", param.get("bond_penl_amnt") ); 
    	//param.put("PENL_CURC_CODE", param.get("penl_curc_code") ); 
    	//param.put("BOND_BEGN_DATE", param.get("bond_begn_date") ); 
    	//param.put("BOND_FNSH_DATE", param.get("bond_fnsh_date") ); 
    	//param.put("BOND_PREM_AMNT", param.get("bond_prem_amnt") ); 
    	//param.put("PREM_CURC_CODE", param.get("prem_curc_code") ); 
    	//param.put("BOND_PRIC_RATE", param.get("bond_pric_rate") ); 
    	//param.put("APPL_ORGA_NAME", param.get("appl_orga_name") ); 
    	//param.put("APPL_ORPS_DIVS", param.get("appl_orps_divs") ); 
    	//param.put("APPL_ORPS_IDEN", param.get("appl_orps_iden") ); 
    	//param.put("APPL_OWNR_NAME", param.get("appl_ownr_name") ); 
    	//param.put("CRED_ORGA_NAME", param.get("cred_orga_name") ); 
    	//param.put("CRED_ORPS_DIVS", param.get("cred_orps_divs") ); 
    	//param.put("CRED_ORPS_IDEN", param.get("cred_orps_iden") ); 
    	//param.put("BOND_HOLD_NAME", param.get("bond_hold_name") ); 
    	//param.put("CONT_NAME_TEXT", param.get("cont_name_text") ); 
    	//param.put("CONT_MAIN_AMNT", param.get("cont_main_amnt") ); 
    	//param.put("CONT_CURC_CODE", param.get("cont_curc_code") ); 
    	//param.put("CONT_NUMB_TEXT", param.get("cont_numb_text") );
    	//param.put("CONT_MAIN_DATE", param.get("cont_main_date") ); 
    	//param.put("CONT_BEGN_DATE", param.get("cont_begn_date") ); 
    	//param.put("CONT_FNSH_DATE", param.get("cont_fnsh_date") );
		 
    	//if("PREGUA".equals(param.get("head_mesg_type"))) { // 선급보증서
    	//param.put("PREP_PAY_AMNT", param.get("prep_pay_amnt"));
    	//param.put("PREP_PAY_DATE", param.get("prep_pay_date"));
    	//param.put("PREP_PREF_DATE", param.get("prep_pref_date")); 
    	//} else if("FLRGUA".equals(param.get("head_mesg_type"))) { // 하자보증서
    	//param.put("MORG_BEGN_DATE", param.get("morg_begn_date"));
    	//param.put("MORG_FNSH_DATE", param.get("morg_fnsh_date"));
    	//param.put("CONT_PERF_DATE", param.get("cont_perf_date")); 
		//}
		  
		//param.put("SPCL_COND_TEXT", param.get("spcl_cond_text") );
		//param.put("SPCL_PROV_TEXT", param.get("spcl_prov_text") );
		//param.put("BOND_STAT_TEXT", param.get("bond_stat_text") );
		//param.put("ISSU_ADDR_TXT1", param.get("issu_addr_txt1") );
		//param.put("ISSU_ADDR_TXT2", param.get("issu_addr_txt2") );
		//param.put("ISSU_ORGA_NAME", param.get("issu_orga_name") );
		//param.put("ISSU_OWNR_NAME", param.get("issu_ownr_name") );
		//param.put("ISSU_DEPT_NAME", param.get("issu_dept_name") );
		//param.put("ISSU_DEPT_OWNR", param.get("issu_dept_ownr") );
		//param.put("CHRG_NAME_TEXT", param.get("chrg_name_text") );
		//param.put("CHRG_PHON_TEXT", param.get("chrg_phon_text") );
		//param.put("CHRG_FAXS_TEXT", param.get("chrg_faxs_text") );
		//param.put("GENE_NOTE_TEXT", param.get("gene_note_text") );
		 
		//sctr0010_mapper.insGuarRecevieGrtswgua(param);
		 
    	
    	System.err.println("=====================================================================2");
    	
    	return msg.getMessage("0001");
    }
    
    
    public String transHan(String str) throws Exception {
    	if(str==null) str="";
		//iso-8859-1,KSC5601,euc-kr,utf-8
		CharBuffer cbuffer = CharBuffer.wrap((str).toCharArray());
		Charset charset = Charset.forName("euc-kr");
		ByteBuffer bbuffer = charset.encode(cbuffer);
		str = new String(bbuffer.array(),"euc-kr").trim();

    	return str.replaceAll("\\?", "");
    }

    public String transHan2(String str) throws Exception {
    	if(str==null) str="";
		//iso-8859-1,KSC5601,euc-kr,utf-8
		CharBuffer cbuffer = CharBuffer.wrap((str).toCharArray());
		Charset charset = Charset.forName("euc-kr");
		ByteBuffer bbuffer = charset.encode(cbuffer);
		str = new String(bbuffer.array()).trim();

    	return str;
    }
    
    public String transHan3(String str) throws Exception {
    	if(str==null) str="";
		//iso-8859-1,KSC5601,euc-kr,utf-8
		CharBuffer cbuffer = CharBuffer.wrap((str).toCharArray());
		Charset charset = Charset.forName("utf-8");
		ByteBuffer bbuffer = charset.encode(cbuffer);
		str = new String(bbuffer.array()).trim();

    	return str;
    }
    
    public String transHan4(String str) throws Exception {
    	if(str==null) str="";
		//iso-8859-1,KSC5601,euc-kr,utf-8
		CharBuffer cbuffer = CharBuffer.wrap((str).toCharArray());
		Charset charset = Charset.forName("euc-kr");
		ByteBuffer bbuffer = charset.encode(cbuffer);
		str = new String(bbuffer.array(),"utf-8").trim();

    	return str.replaceAll("\\?", "");
    }

	/**
	 * 전자계약 : 서울보증전송
	 * @param guarData
	 * @throws Exception
	 */
    public String sendContGuar(Map<String, Object> guarData) throws Exception {
    	
		/*  GUAR_TYPE : ADV	  선급보증 ,CONT 계약보증	,WARR 하자보증	,DIF	 차액보증 */
    	// 1. [필수] 전문송신기관(송신자ID : A+피보험자사업자번호+00 (총 13자리))
		String head_mesg_send  = "";
        if(PropertiesManager.getBoolean("eversrm.system.developmentFlag")) {// 개발서버 : 농협정보시스템
    		head_mesg_send="A120870175500";
        } else {
    		head_mesg_send="A120870175500";
        }
        guarData.put("HEAD_MESG_SEND", head_mesg_send);
        
        // 서울보증 전송전문 가져오기
    	Map<String, String> guarInfo = sctr0010_mapper.getGuarDataEcct(guarData);
    	System.err.println("==============================guarInfo=============="+guarInfo);
    	
    	// 계약보증번호 채번
    	String guarReqNum = "";
    	if( StringUtils.isEmpty(guarInfo.get("GUAR_REQ_NUM")) ) {
    		guarReqNum = docNumService.getDocNumber(PropertiesManager.getString("eversrm.default.company.code"), "GU");
    	}
    	else {
    		guarReqNum = String.valueOf(guarData.get("GUAR_REQ_NUM"));
    	}
    	guarData.put("GUAR_REQ_NUM", guarReqNum);
    	
    	// 서울보증증권 전송 세팅정보
        String sendinfo_conf  = PropertiesManager.getString("sendinfo_conf", "");
        System.out.println("sendinfo_conf ======> "+sendinfo_conf);
        
        // 서울보증증권 템플릿 경로
        String templates_path = PropertiesManager.getString("templates_path", "");

		/**
		 * 문서코드(문서명) -  BIDINF(입찰정보통보서), CONINF(계약정보통보서), FLRINF(하자정보통보서),
		 *                 PREINF(선금정보통보서), PAYINF(지급정보통보서), LIVINF(생활안정통보서), SALINF(상품판매통보서)
		 * 상품(보험종류)구분코드- 001:입찰, 002:계약, 003:하자, 004:선금,
		 */
        /** HEADER */
        String headMesg = "";
        String headMesgType = "";

        boolean coninf = false;//계약정보통보서
        boolean preinf = false;//선금정보통보서
        boolean flrinf = false;//하자정보통보서
        /*	[필수]	 문서코드	*/
        if ("CONT".equals(guarData.get("GUAR_TYPE"))) {		//계약보증
        	headMesg = "계약정보통보서";
        	headMesgType = "CONINF";
        	coninf = true;
        }
        else if ("ADV".equals(guarData.get("GUAR_TYPE"))) {	//선급보증
        	headMesg = "선금정보통보서";
        	headMesgType = "PREINF";
        	preinf = true;
        }
        else if ("WARR".equals(guarData.get("GUAR_TYPE"))) {//하자보증
        	headMesg = "하자정보통보서";
        	headMesgType = "FLRINF";
        	flrinf = true;
        }
        
        // 2. [필수] 수신처ID (z120811300200 : 서울보증보험 13자리 고정값)
    	//String headMesgRecv    = PropertiesManager.getString("eversrm.head_mesg_recv");
		String head_mesg_recv  = "z120811300200";					/*	[필수]	 전문수신기관	*/
		String head_func_code  = "53";								/*	[필수]	 문서기능 (9 : 원본, 1 : 취소, 53 : 테스트)	*/
		String head_mesg_type  = headMesgType;						/*	[필수]	 문서코드 (CONINF : 계약정보통보서, FLRINF : 하자정보통보서, PREINF : 선금정보통보서)	*/
		String head_mesg_name  = headMesg;							/*	[필수]	 문서명	*/
		String head_mesg_vers  = "1.0";								/*	[선택]	 전자문서버전	*/
		
		String head_docu_numb  = guarInfo.get("HEAD_DOCU_NUMB");	/*	[필수]	 문서번호	*/
		String head_mang_numb  = guarInfo.get("HEAD_MANG_NUMB");	/*	[필수]	 문서관리번호 (피보험자측 계약번호(차수포함) : CONT_NUM+CONT_CNT+'_'+GUAR_REQ_NUM)	*/
		String head_refr_numb  = guarInfo.get("HEAD_REFR_NUMB");	/*	[필수]	 참조번호 (피보험자측 계약번호(차수포함) : CONT_NUM+CONT_CNT+'_'+GUAR_REQ_NUM)	*/

		String head_titl_name  = headMesg;							/*	[필수]	문서개요(=문서명과 동일)	*/
		String head_orga_code  = "NHI";   							/*  [필수]   연계기관코드   */

		head_docu_numb = head_docu_numb.replaceAll("XXXXXXXXXX", guarReqNum);		/* 계약보증번호 */
		head_mang_numb = head_mang_numb.replaceAll("XXXXXXXXXX", guarReqNum);		/* 계약보증번호 */
		head_refr_numb = head_refr_numb.replaceAll("XXXXXXXXXX", guarReqNum);		/* 계약보증번호 */

		/** BODY */
		/* 보험계약정보 Guarantee.Info.Details */
		String	bond_kind_code  = guarInfo.get("BOND_KIND_CODE"); 					/*	[필수]	" 보험종목구분(001:입찰,002:계약,003:하자,004:선금,006:지급)"	*/
		String	bond_begn_date  = guarInfo.get("BOND_BEGN_DATE");					/*	[필수]	보험개시일자	*/
		String	bond_fnsh_date  = guarInfo.get("BOND_FNSH_DATE");					/*	[필수]	보험종료일자	*/
		String	bond_curc_code  = guarInfo.get("BOND_CURC_CODE");					/*	[필수]	" 보험가입금액/통화코드(WON, USD …)"	*/
		String	bond_penl_amnt  = String.valueOf(guarInfo.get("BOND_PENL_AMNT"));	/*	[필수]	보험가입금액/보험가입금액	*/
		String	bond_oper_code  = guarInfo.get("BOND_OPER_CODE");					/*	[선택]	" 조회등록 업무구분(SELECT,INSERT)"	*/
		String	bond_appl_code  = guarInfo.get("BOND_APPL_CODE");					/*	[필수]	" 신규 또는 변경(배서) 업무구분(10:신규(*), 20:연장(*), 60:증액(*), 62:연장증액, 70:감액(*), 90:기타)"	*/

		/* 주요계약정보 MainContract.Info.Details */
		String	cont_numb_text  = guarInfo.get("CONT_NUMB_TEXT");					/*	[필수]	계약번호	*/
		cont_numb_text = cont_numb_text.replaceAll("XXXXXXXXXX", guarReqNum);

		String	cont_name_text  = guarInfo.get("CONT_NAME_TEXT");					/*	[필수]	계약명(특수문자 제외)	*/
		String	cont_proc_type  = guarInfo.get("CONT_PROC_TYPE");					/*	[필수]	계약구분	*/
		String	cont_type_iden  = guarInfo.get("CONT_TYPE_IDEN");					/*	[필수]	" 계약방식(1:공동, 2:단독, 3:분담)"	*/
		String	cont_asgn_rate  = guarInfo.get("CONT_ASGN_RATE");					/*	[선택]	지분율	*/
		String	cont_news_divs  = guarInfo.get("CONT_NEWS_DIVS");					/*	[필수]	" 신규/갱신 계약구분(1:신규계약, 2:갱신계약)"	*/
		String	cont_plan_date  = guarInfo.get("CONT_PLAN_DATE");					/*	[선택]	 준공예정일	*/
		String	cont_main_date  = guarInfo.get("CONT_MAIN_DATE");					/*	[선택]	 계약체결일자(YYYYMMDD)	*/
		String	cont_curc_code  = guarInfo.get("CONT_CURC_CODE");					/*	[필수]	 계약금액(원화)/통화코드(WON)	*/
		String	cont_main_amnt  = String.valueOf(guarInfo.get("CONT_MAIN_AMNT"));	/*	[필수]	 계약금액(원화)/계약금액	*/
		String	forn_curc_code  = guarInfo.get("FORN_CURC_CODE");					/*	[선택]	 계약금액(외화)/통화코드(USD …)	*/
		String	forn_main_amnt  = guarInfo.get("FORN_MAIN_AMNT");					/*	[선택]	 계약금액(외화)/계약금액	*/
		String	hist_bond_numb  = guarInfo.get("HIST_BOND_NUMB");					/*	[선택]	 변경(배서)대상 증권번호(반드시 18자리 증권번호여야 함 : 기존 증권구분번호가 "004002XXXXXXXXXXXXXXXXXX 00인 경우 중앙의 18자리)	*/

		/* 계약정보(이행 계약 통보 정보) Contract.Info.Details */
		String	cont_begn_date  = guarInfo.get("CONT_BEGN_DATE");					/*	[필수]	 계약시작일자(YYYYMMDD)	*/
		String	cont_fnsh_date  = guarInfo.get("CONT_FNSH_DATE");					/*	[필수]	 계약종료일자(YYYYMMDD)	*/
		String	cont_term_text  = guarInfo.get("CONT_TERM_TEXT");					/*	[선택]	 계약기간(계약종료일자 - 계약시작일자 : 계약기간 총 일수)	*/
		String	cont_pric_rate  = String.valueOf(guarInfo.get("CONT_PRIC_RATE"));	/*	[필수]	" 보증금율(단가계약일 경우 ""0""으로 입력)"	*/
		String	cont_unit_divs  = guarInfo.get("CONT_UNIT_DIVS");					/*	[필수]	" 단가계약 여부(1:단가계약, 2:일반계약)"	*/

		/* 선금정보(이행 선금 통보 정보) */
		String	prep_paym_type  = guarInfo.get("PREP_PAYM_TYPE");					/*	[필수]	지급구분 - 1:직불(수요자), 2;대지급(채권자)	*/
		String	prep_begn_date  = guarInfo.get("PREP_BEGN_DATE");					/*	[필수]	계약 시작일자(YYYYMMDD)	*/
		String	prep_fnsh_date  = guarInfo.get("PREP_FNSH_DATE");					/*	[필수]	계약 종료일자(YYYYMMDD)	*/
		String	prep_term_text  = String.valueOf(guarInfo.get("PREP_TERM_TEXT"));	/*	계약기간(일수) = 계약종료일자-계약시작일자(계약기간 총 일수)	*/
		String	prep_paym_date  = guarInfo.get("PREP_PAYM_DATE");					/*	[필수]	선금지급(예정)일자(YYYYMMDD) 	*/
		String	prep_curc_code  = String.valueOf(guarInfo.get("PREP_CURC_CODE"));	/*	[필수]	선금지급(예정)금액(원화) 통화코드 - WON(원화)	*/
		String	prep_paym_amnt  = String.valueOf(guarInfo.get("PREP_PAYM_AMNT"));	/*	[필수]	선금지급(예정)금액(원화)	*/
		String	fpre_curc_code  = guarInfo.get("FPRE_CURC_CODE");					/*	선금지급(예정)금액(외화) 통화코드 - USD(미달러), EUR(유로화) 등	*/
		String	fpre_paym_amnt  = guarInfo.get("FPRE_PAYM_AMNT");					/*	선금지급(예정)금액(외화) - 예)260.55	*/
		String	prep_pric_rate  = guarInfo.get("PREP_PRIC_RATE");					/*	선금율	*/

		/* 하자정보(이행 하자 통보 정보) */
		String	morg_begn_date  = guarInfo.get("MORG_BEGN_DATE");					/*	[필수]	하자보수 책임시작일 - YYYYMMDD	*/
		String	morg_fnsh_date  = guarInfo.get("MORG_FNSH_DATE");					/*	[필수]	하자보수 책임종료일 - YYYYMMDD	*/
		String	morg_term_text  = String.valueOf(guarInfo.get("MORG_TERM_TEXT"));	/*	[필수]	하자보수 책임기간 = 하자보수책임 종료일자-하자보수책임 시작일자(하자보수책임 총 일수)	*/
		String	morg_pric_rate  = String.valueOf(guarInfo.get("MORG_PRIC_RATE"));	/*	[필수]	하자보증금율	*/
		String	morg_cnfm_code  = guarInfo.get("MORG_CNFM_CODE");					/*	무사고 확인   - Y:하자없음, N:하자있음 (하자보수 책임시작일로 부터 30일이상 경과시 필수항목)	*/
		String	morg_cnfm_date  = guarInfo.get("MORG_CNFM_DATE");					/*	무사고 확인일 - YYYYMMDD	*/

		/* 채권자 정보 Creditor.Info.Details */
		String	cred_exst_code  = guarInfo.get("CRED_EXST_CODE");					/*	채권자 존재형태 구분(1 : 단독, 2 : 공동) 	*/
		String	cred_orga_name  = guarInfo.get("CRED_ORGA_NAME");					/*	[필수]	 기관명	*/
		String	cred_orps_divs  = guarInfo.get("CRED_ORPS_DIVS");					/*	[필수]	 구분(O:사업자번호 P:주민등록번호)	*/
		//String	cred_orga_numb  = guarInfo.get("CRED_ORGA_NUMB");					/*	[필수]	 법인등록번호	*/
		//String	cred_orga_numb  = "1353110003920";									/*	[필수]	테스트용 법인등록번호	*/
		String	cred_orga_numb  = "0000000000000";									/*	[필수]	테스트용 법인등록번호	*/
		String	cred_orps_iden  = guarInfo.get("CRED_ORPS_IDEN");					/*	[필수]	 사업자/주민번호	*/
		String	cred_ownr_numb  = guarInfo.get("CRED_OWNR_NUMB");					/*	[필수]	 대표자 주민등록번호	*/
		String	cred_ownr_name  = guarInfo.get("CRED_OWNR_NAME");					/*	[필수]	 성명(대표자명)	*/
		String	cred_bond_hold  = guarInfo.get("CRED_BOND_HOLD");					/*	[필수]	 채권자명	*/
		String	cred_addn_name  = guarInfo.get("CRED_ADDN_NAME");					/*	[선택]	 채권기관 부가상호	*/
		String	cred_orga_post  = guarInfo.get("CRED_ORGA_POST");					/*	[필수]	 회사 우편번호	*/
		String	cred_orga_addr  = guarInfo.get("CRED_ORGA_ADDR");					/*	[필수]	 회사 주소	*/
		String	cred_chrg_name  = guarInfo.get("CRED_CHRG_NAME");					/*	[필수]	 담당자명	*/
		String	cred_dept_name  = guarInfo.get("CRED_DEPT_NAME");					/*	[필수]	 소속부서	*/
		String	cred_phon_numb  = guarInfo.get("CRED_PHON_NUMB");					/*	[필수]	 전화번호	*/
		String	cred_cell_phon  = guarInfo.get("CRED_CELL_PHON");					/*	[필수]	 핸드폰번호	*/
		String	cred_send_mail  = guarInfo.get("CRED_SEND_MAIL");					/*	[필수]	 담당자 EMAIL	*/

		String	cred_user_iden  = head_mesg_send;									/*	[필수]	 수신처ID	*/
		String	cred_user_type  = head_orga_code;									/*	[필수]	 수신처TYPE	*/

		/* 계약자 정보 Applier.Info.Details */
		String	appl_orga_name  = guarInfo.get("APPL_ORGA_NAME");					/*	[필수]	 기관명	*/
		String	appl_orps_divs  = guarInfo.get("APPL_ORPS_DIVS");					/*	[필수]	 구분(O:사업자번호 P:주민등록번호)	*/
		String	appl_orga_numb  = guarInfo.get("APPL_ORGA_NUMB");					/*	[선택]	 법인등록번호	*/
		String	appl_orps_iden  = guarInfo.get("APPL_ORPS_IDEN");					/*	[필수]	 사업자/주민번호	*/
		//String	appl_orps_iden  = "2128300381";									/*	[필수]	 테스트용 사업자번호	*/
		String	appl_ownr_numb  = guarInfo.get("APPL_OWNR_NUMB");					/*	[필수]	 대표자 주민등록번호	*/
		String	appl_ownr_name  = guarInfo.get("APPL_OWNR_NAME");					/*	[필수]	 성명(대표자명)	*/
		String	appl_addn_name  = guarInfo.get("APPL_ADDN_NAME");					/*	[선택]	 계약업체 부가상호	*/
		String	appl_orga_post  = guarInfo.get("APPL_ORGA_POST");					/*	[선택]	 회사 우편번호	*/
		String	appl_orga_addr  = guarInfo.get("APPL_ORGA_ADDR");					/*	[선택]	 회사 주소	*/
		String	appl_chrg_name  = guarInfo.get("APPL_CHRG_NAME");					/*	[필수]	 담당자명	*/
		String	appl_dept_name  = guarInfo.get("APPL_DEPT_NAME");					/*	[필수]	 소속부서	*/
		String	appl_offc_phon  = guarInfo.get("APPL_OFFC_PHON");					/*	[필수]	 전화번호	*/
		String	appl_cell_phon  = guarInfo.get("APPL_CELL_PHON");					/*	[필수]	 핸드폰번호	*/
		String	appl_send_mail  = guarInfo.get("APPL_SEND_MAIL");					/*	[필수]	 담당자 EMAIL	*/
		String	appl_home_post  = guarInfo.get("APPL_HOME_POST");					/*	[선택]	 자택 우편번호	*/
		String	appl_home_addr  = guarInfo.get("APPL_HOME_ADDR");					/*	[선택]	 자택 주소	*/
		String	appl_home_phon  = guarInfo.get("APPL_HOME_PHON");					/*	[선택]	 자택 전화번호	*/
		String	appl_user_iden  = head_mesg_send;									/*	[필수]	 수신처ID	*/
		String	appl_user_type  = head_orga_code;									/*	[필수]	 수신처TYPE	*/
		System.out.println("head_mesg_name ====>" + head_mesg_name);
		System.out.println("head_titl_name ====>" + head_titl_name);
		System.out.println("transHan =====> " + transHan(head_mesg_name));
		System.out.println("transHan2 =====> " + transHan2(head_mesg_name));
		System.out.println("transHan3 =====> " + transHan3(head_mesg_name));
		System.out.println("transHan4 =====> " + transHan4(head_mesg_name));
		String xml_str = null;
		
		// 매핑 정보 파일, XML 탬플릿 정보 파일
		DataToXml datatoxml = new DataToXml(templates_path, headMesgType);
		//DataToXml datatoxml = new DataToXml(templates_path,headMesgType);
		if( datatoxml.getErrorCode() != 0 ) {
			System.out.println(datatoxml.getErrorMsg());
			return msg.getMessage("서울보증 전송 전문 xml 생성 실패");
		}
		
		/* HEADER */
		try{
			if(
				/* Begin of Header */
					datatoxml.setData("head_mesg_send", head_mesg_send)
				&&	datatoxml.setData("head_mesg_recv", head_mesg_recv)
				&&	datatoxml.setData("head_func_code", head_func_code)
				&&	datatoxml.setData("head_mesg_type", head_mesg_type)
				&&	datatoxml.setData("head_mesg_name", head_mesg_name)
				&&	datatoxml.setData("head_mesg_vers", head_mesg_vers)
				&&	datatoxml.setData("head_docu_numb", head_docu_numb)
				&&	datatoxml.setData("head_mang_numb", head_mang_numb)
				&&	datatoxml.setData("head_refr_numb", head_refr_numb)
				&&	datatoxml.setData("head_titl_name", head_titl_name)
				&&  datatoxml.setData("head_orga_code", head_orga_code)
				/* End of Header */

				/* Begin of 보험계약정보 */
				&&  datatoxml.setData("bond_kind_code", bond_kind_code)
				&&  datatoxml.setData("bond_begn_date", bond_begn_date)
				&&  datatoxml.setData("bond_fnsh_date", bond_fnsh_date)
				&&  datatoxml.setData("bond_curc_code", bond_curc_code)
				&&  datatoxml.setData("bond_penl_amnt", bond_penl_amnt)
				&&  datatoxml.setData("bond_oper_code", bond_oper_code)
				&&  datatoxml.setData("bond_appl_code", bond_appl_code)
				/* End of 보험계약정보 */

				/* Begin of 주요계약정보 */
				&&  datatoxml.setData("cont_numb_text", cont_numb_text)
				&&  datatoxml.setData("cont_name_text", cont_name_text)
				&&  datatoxml.setData("cont_proc_type", cont_proc_type)
				&&  datatoxml.setData("cont_type_iden", cont_type_iden)
				//&&  datatoxml.setData("cont_asgn_rate", cont_asgn_rate)
				&&  datatoxml.setData("cont_news_divs", cont_news_divs)
				&&  datatoxml.setData("cont_plan_date", cont_plan_date)
				&&  datatoxml.setData("cont_main_date", cont_main_date)
				&&  datatoxml.setData("cont_curc_code", cont_curc_code)
				&&  datatoxml.setData("cont_main_amnt", cont_main_amnt)
				//&&  datatoxml.setData("forn_curc_code", forn_curc_code)
				//&&  datatoxml.setData("forn_main_amnt", forn_main_amnt)
				//&&  datatoxml.setData("hist_bond_numb", hist_bond_numb)
				/* End of 주요계약정보 */

				/* Begin of 계약정보 */
				&& (coninf ? datatoxml.setData("cont_begn_date", cont_begn_date) : true)
				&& (coninf ? datatoxml.setData("cont_fnsh_date", cont_fnsh_date) : true)
				&& (coninf ? datatoxml.setData("cont_term_text", cont_term_text) : true)
				&& (coninf ? datatoxml.setData("cont_pric_rate", cont_pric_rate) : true)
				&& (coninf ? datatoxml.setData("cont_unit_divs", cont_unit_divs) : true)
				/* End of 계약정보 */

				/* Begin of 선급보증 */
				&& (preinf ? datatoxml.setData("prep_paym_type", prep_paym_type) : true)
				&& (preinf ? datatoxml.setData("prep_begn_date", prep_begn_date) : true)
				&& (preinf ? datatoxml.setData("prep_fnsh_date", prep_fnsh_date) : true)
				&& (preinf ? datatoxml.setData("prep_term_text", prep_term_text) : true)
				&& (preinf ? datatoxml.setData("prep_paym_date", prep_paym_date) : true)
				&& (preinf ? datatoxml.setData("prep_curc_code", prep_curc_code) : true)
				&& (preinf ? datatoxml.setData("prep_paym_amnt", prep_paym_amnt) : true)
				&& (preinf ? datatoxml.setData("fpre_curc_code", fpre_curc_code) : true)
				&& (preinf ? datatoxml.setData("fpre_paym_amnt", fpre_paym_amnt) : true)
				&& (preinf ? datatoxml.setData("prep_pric_rate", prep_pric_rate) : true)
				/* End of 선급보증 */

				/* Begin of 하자보증 */
				&& (flrinf ? datatoxml.setData("morg_begn_date", morg_begn_date) : true)
				&& (flrinf ? datatoxml.setData("morg_fnsh_date", morg_fnsh_date) : true)
				&& (flrinf ? datatoxml.setData("morg_term_text", morg_term_text) : true)
				&& (flrinf ? datatoxml.setData("morg_pric_rate", morg_pric_rate) : true)
				&& (flrinf ? datatoxml.setData("morg_cnfm_code", morg_cnfm_code) : true)
				&& (flrinf ? datatoxml.setData("morg_cnfm_date", morg_cnfm_date) : true)
				/* End of 하자보증 */

				/* Begin of 채권자 정보 */
				&&  datatoxml.setData("cred_orga_name", cred_orga_name)
				&&  datatoxml.setData("cred_orps_divs", cred_orps_divs)
				&&  datatoxml.setData("cred_orga_numb", cred_orga_numb)
				&&  datatoxml.setData("cred_orps_iden", cred_orps_iden)
				&&  datatoxml.setData("cred_ownr_numb", cred_ownr_numb)
				&&  datatoxml.setData("cred_ownr_name", cred_ownr_name)
				&&  datatoxml.setData("cred_bond_hold", cred_bond_hold)
				&&  datatoxml.setData("cred_addn_name", cred_addn_name)
				&&  datatoxml.setData("cred_orga_post", cred_orga_post)
				&&  datatoxml.setData("cred_orga_addr", cred_orga_addr)
				&&  datatoxml.setData("cred_chrg_name", cred_chrg_name)
				&&  datatoxml.setData("cred_dept_name", cred_dept_name)
				&&  datatoxml.setData("cred_phon_numb", cred_phon_numb)
				&&  datatoxml.setData("cred_cell_phon", cred_cell_phon)
				&&  datatoxml.setData("cred_send_mail", cred_send_mail)
				&&  datatoxml.setData("cred_user_iden", cred_user_iden)
				&&  datatoxml.setData("cred_user_type", cred_user_type)
				/* End of 채권자 정보 */

				/* Begin of 계약자 정보 */
				&&  datatoxml.setData("appl_orga_name", appl_orga_name)
				&&  datatoxml.setData("appl_orps_divs", appl_orps_divs)
				&&  datatoxml.setData("appl_orga_numb", appl_orga_numb)
				&&  datatoxml.setData("appl_orps_iden", appl_orps_iden)
				&&  datatoxml.setData("appl_ownr_numb", appl_ownr_numb)
				&&  datatoxml.setData("appl_ownr_name", appl_ownr_name)
				&&  datatoxml.setData("appl_addn_name", appl_addn_name)
				&&  datatoxml.setData("appl_orga_post", appl_orga_post)
				&&  datatoxml.setData("appl_orga_addr", appl_orga_addr)
				&&  datatoxml.setData("appl_chrg_name", appl_chrg_name)
				&&  datatoxml.setData("appl_dept_name", appl_dept_name)
				&&  datatoxml.setData("appl_offc_phon", appl_offc_phon)
				&&  datatoxml.setData("appl_cell_phon", appl_cell_phon)
				&&  datatoxml.setData("appl_send_mail", appl_send_mail)
				&&  datatoxml.setData("appl_home_post", appl_home_post)
				&&  datatoxml.setData("appl_home_addr", appl_home_addr)
				&&  datatoxml.setData("appl_home_phon", appl_home_phon)
				&&  datatoxml.setData("appl_user_iden", appl_user_iden)
				&&  datatoxml.setData("appl_user_type", appl_user_type)
				/* End of 계약자 정보 */
				
				/* Begin of 수요자 정보 */
				&&  datatoxml.setData("mang_orga_name", "")
				&&  datatoxml.setData("mang_orps_divs", "")
				&&  datatoxml.setData("mang_orga_numb", "")
				&&  datatoxml.setData("mang_orps_iden", "")
				&&  datatoxml.setData("mang_ownr_numb", "")
				&&  datatoxml.setData("mang_ownr_name", "")
				&&  datatoxml.setData("mang_addn_name", "")
				&&  datatoxml.setData("mang_orga_post", "")
				&&  datatoxml.setData("mang_orga_addr", "")
				&&  datatoxml.setData("mang_bond_hold", "")
				&&  datatoxml.setData("mang_chrg_name", "")
				&&  datatoxml.setData("mang_dept_name", "")
				&&  datatoxml.setData("mang_phon_numb", "")
				&&  datatoxml.setData("mang_cell_phon", "")
				&&  datatoxml.setData("mang_send_mail", "")
				&&  datatoxml.setData("mang_user_iden", "")
				&&  datatoxml.setData("mang_user_type", "")
				/* End of 수요자 정보 */
			)
			{
				xml_str = datatoxml.getxmlData();
		        if(PropertiesManager.getBoolean("eversrm.system.developmentFlag")) {// 개발서버에서는
			        if(PropertiesManager.getBoolean("eversrm.system.localserver")) {// 개발서버에서는 고정된 값으로.
						datatoxml.writexmlFile("C:/mmmm.xml");
			        } else {
						datatoxml.writexmlFile("/svc/nhepro/TempXml/mmmm.xml");
			        }
		        } else {
		        	datatoxml.writexmlFile("C:/mmmm.xml");
		        }
				System.err.println("===xml start=======================================================================================================");
				System.err.println(xml_str);
				System.err.println("===xml end=======================================================================================================");
			} else {
				System.out.println(datatoxml.getErrorMsg());
				throw new Exception(datatoxml.getErrorMsg());
			}
		}
		catch(Exception e){
			logger.error(e.getMessage());
			throw e;
		}
		/////////////////////// xml문서 생성 end ////////////////////////

		if(xml_str == null){
			System.out.println("서울보증 전송 전문 xml 생성 실패");
			return msg.getMessage("서울보증 전송 전문 xml 생성 실패");
		}
		
		// 개발 테스트가 아닌 경우
		try {
	        if( !PropertiesManager.getBoolean("eversrm.system.localserver") ) {
				////////////////////// xml 문서 송신 start ///////////////////////
	        	
				SGIxLinker xLinker =  new SGIxLinker(sendinfo_conf, "send_jsp", true);
				//xLinker.setXmlEncoding("EUC-KR");
				xLinker.setXmlEncoding("UTF-8");
				
		    	boolean isOK = xLinker.doSendProcess(xml_str, null);
		    	// 전송완료처리
		    	System.err.println("=============================================================================isOK="+isOK);
				if(!isOK) {
					logger.debug("SGIxLinker 에러메시지:" + xLinker.getErrorMsg());
					throw new Exception("=="+xLinker.getErrorMsg()+"==");
				}
	
				//***************************************
				// xml 응답서 문서 정보를 XmltoData로 추출하여 상태값 DB에 저장
				// 매핑 정보 파일, XML 탬플릿 정보 파일
				String recvXml = xLinker.getRecvXmlData();
				XmlToData xmlToData = null;
				try{
					System.err.println("==recvXmlrecvXmlrecvXmlrecvXmlrecvXmlrecvXmlrecvXmlrecvXmlrecvXmlrecvXmlrecvXml==========================================================recvXml==recvXml="+recvXml);
					xmlToData = new XmlToData(xLinker.getTempPath() , "RESPONSE", recvXml);
					if( xmlToData.getErrorCode() != 0 ) {
						logger.debug(xmlToData.getErrorMsg());
						throw new Exception("=="+xmlToData.getErrorMsg()+"==");
					}
				}
				catch(Exception e){
					logger.error(e.getMessage());
					throw new Exception("=="+xmlToData.getErrorMsg()+"==");
				}
	
				String res_cont_num = xmlToData.getData("res_cont_num");
				//String res_docu_num = xmlToData.getData("res_docu_num");
				String respTypeCode = xmlToData.getData("res_info_code");
				String respTypeName = xmlToData.getData("res_info_typename");
				String respMesgText = xmlToData.getData("res_info_result");
				System.out.println("계약번호 = "+res_cont_num);
				System.out.println("응답코드 = "+respTypeCode);
				System.out.println("응답코드명 = "+respTypeName);
				System.out.println("응답메시지 = "+respMesgText);
				
				if( respTypeCode == null || !"SA".equals(respTypeCode) ) {
					throw new Exception("계약번호 = "+res_cont_num
							+"\n응답코드 = "+respTypeCode
							+"\n응답코드명 = "+respTypeName
							+"\n응답메시지 = "+respMesgText
					);
				}
		         
		        // STOCECPC(계약 고객사별 지불고객사(지급/보증) 정보)의 INSU_STATUS = 'TA'
				sctr0010_mapper.setGuarSendComplete(guarData);
				
	        }
		}
    	catch (Exception e) {
    		logger.error(e.getMessage());
			throw e;
		}
    	
    	return msg.getMessage("0001");
    }
    
    /**
	 * 전자계약 : 서울보증전송 보증번호 발행 전 취소
	 * @param guarData
	 * @throws Exception
	 */
    public String sendContGuarCancel(Map<String, Object> guarData) throws Exception {
    	
		/*  GUAR_TYPE : ADV	  선급보증 ,CONT 계약보증	,WARR 하자보증	,DIF	 차액보증 */
    	// 1. [필수] 전문송신기관(송신자ID : A+피보험자사업자번호+00 (총 13자리))
		String head_mesg_send  = "";
        if(PropertiesManager.getBoolean("eversrm.system.developmentFlag")) {// 개발서버 : 농협정보시스템
    		head_mesg_send="A120870175500";
        } else {
    		head_mesg_send="A120870175500";
        }
        guarData.put("HEAD_MESG_SEND", head_mesg_send);
        
        // 서울보증 전송전문 가져오기
    	//Map<String, String> guarInfo = sctr0010_mapper.getGuarDataEcct(guarData);
    	Map<String, String> guarInfo = sctr0010_mapper.getGuarDataEcct(guarData);
    	System.err.println("==============================guarInfo=============="+guarInfo);
    	
    	// 계약보증번호 채번
    	String guarReqNum = "";
    	if( StringUtils.isEmpty(guarInfo.get("GUAR_REQ_NUM")) ) {
    		guarReqNum = docNumService.getDocNumber(PropertiesManager.getString("eversrm.default.company.code"), "GU");
    	}
    	else {
    		guarReqNum = String.valueOf(guarData.get("GUAR_REQ_NUM"));
    	}
    	guarData.put("GUAR_REQ_NUM", guarReqNum);
    	
    	// 서울보증증권 전송 세팅정보
        String sendinfo_conf  = PropertiesManager.getString("sendinfo_conf", "");
        // 서울보증증권 템플릿 경로
        String templates_path = PropertiesManager.getString("templates_path", "");

		/**
		 * 문서코드(문서명) -  BIDINF(입찰정보통보서), CONINF(계약정보통보서), FLRINF(하자정보통보서),
		 *                 PREINF(선금정보통보서), PAYINF(지급정보통보서), LIVINF(생활안정통보서), SALINF(상품판매통보서)
		 * 상품(보험종류)구분코드- 001:입찰, 002:계약, 003:하자, 004:선금,
		 */
        /** HEADER */
        String headMesg = "";
        String headMesgType = "";

        boolean coninf = false;//계약정보통보서
        boolean preinf = false;//선금정보통보서
        boolean flrinf = false;//하자정보통보서
        /*	[필수]	 문서코드	*/
        if ("CONT".equals(guarData.get("GUAR_TYPE"))) {		//계약보증
        	headMesg = "계약정보통보서";
        	headMesgType = "CONINF";
        	coninf = true;
        }
        else if ("ADV".equals(guarData.get("GUAR_TYPE"))) {	//선급보증
        	headMesg = "선금정보통보서";
        	headMesgType = "PREINF";
        	preinf = true;
        }
        else if ("WARR".equals(guarData.get("GUAR_TYPE"))) {//하자보증
        	headMesg = "하자정보통보서";
        	headMesgType = "FLRINF";
        	flrinf = true;
        }
        
        // 2. [필수] 수신처ID (z120811300200 : 서울보증보험 13자리 고정값)
    	//String headMesgRecv    = PropertiesManager.getString("eversrm.head_mesg_recv");
		String head_mesg_recv  = "z120811300200";						/*	[필수]	 전문수신기관	*/
		String head_func_code  = "1";								/*	[필수]	 문서기능 (9 : 원본, 1 : 취소, 53 : 테스트)	*/
		String head_mesg_type  = headMesgType;						/*	[필수]	 문서코드 (CONINF : 계약정보통보서, FLRINF : 하자정보통보서, PREINF : 선금정보통보서)	*/
		String head_mesg_name  = headMesg;							/*	[필수]	 문서명	*/
		String head_mesg_vers  = "1.0";								/*	[선택]	 전자문서버전	*/
		
		String head_docu_numb  = guarInfo.get("HEAD_DOCU_NUMB");	/*	[필수]	 문서번호	*/
		String head_mang_numb  = guarInfo.get("HEAD_MANG_NUMB");	/*	[필수]	 문서관리번호 (피보험자측 계약번호(차수포함) : CONT_NUM+CONT_CNT+'_'+GUAR_REQ_NUM)	*/
		String head_refr_numb  = guarInfo.get("HEAD_REFR_NUMB");	/*	[필수]	 참조번호 (피보험자측 계약번호(차수포함) : CONT_NUM+CONT_CNT+'_'+GUAR_REQ_NUM)	*/

		String head_titl_name  = headMesg;							/*	[필수]	문서개요(=문서명과 동일)	*/
		String head_orga_code  = "NHI";   							/*  [필수]   연계기관코드   */

		head_docu_numb = head_docu_numb.replaceAll("XXXXXXXXXX", guarReqNum);		/* 계약보증번호 */
		head_mang_numb = head_mang_numb.replaceAll("XXXXXXXXXX", guarReqNum);		/* 계약보증번호 */
		head_refr_numb = head_refr_numb.replaceAll("XXXXXXXXXX", guarReqNum);		/* 계약보증번호 */

		/** BODY */
		/* 보험계약정보 Guarantee.Info.Details */
		String	bond_kind_code  = guarInfo.get("BOND_KIND_CODE"); 					/*	[필수]	" 보험종목구분(001:입찰,002:계약,003:하자,004:선금,006:지급)"	*/
		String	bond_begn_date  = guarInfo.get("BOND_BEGN_DATE");					/*	[필수]	보험개시일자	*/
		String	bond_fnsh_date  = guarInfo.get("BOND_FNSH_DATE");					/*	[필수]	보험종료일자	*/
		String	bond_curc_code  = guarInfo.get("BOND_CURC_CODE");					/*	[필수]	" 보험가입금액/통화코드(WON, USD …)"	*/
		String	bond_penl_amnt  = String.valueOf(guarInfo.get("BOND_PENL_AMNT"));	/*	[필수]	보험가입금액/보험가입금액	*/
		String	bond_oper_code  = guarInfo.get("BOND_OPER_CODE");					/*	[선택]	" 조회등록 업무구분(SELECT,INSERT)"	*/
		String	bond_appl_code  = guarInfo.get("BOND_APPL_CODE");					/*	[필수]	" 신규 또는 변경(배서) 업무구분(10:신규(*), 20:연장(*), 60:증액(*), 62:연장증액, 70:감액(*), 90:기타)"	*/

		/* 주요계약정보 MainContract.Info.Details */
		String	cont_numb_text  = guarInfo.get("CONT_NUMB_TEXT");					/*	[필수]	계약번호	*/
		cont_numb_text = cont_numb_text.replaceAll("XXXXXXXXXX", guarReqNum);

		String	cont_name_text  = guarInfo.get("CONT_NAME_TEXT");					/*	[필수]	계약명(특수문자 제외)	*/
		String	cont_proc_type  = guarInfo.get("CONT_PROC_TYPE");					/*	[필수]	계약구분	*/
		String	cont_type_iden  = guarInfo.get("CONT_TYPE_IDEN");					/*	[필수]	" 계약방식(1:공동, 2:단독, 3:분담)"	*/
		String	cont_asgn_rate  = guarInfo.get("CONT_ASGN_RATE");					/*	[선택]	지분율	*/
		String	cont_news_divs  = guarInfo.get("CONT_NEWS_DIVS");					/*	[필수]	" 신규/갱신 계약구분(1:신규계약, 2:갱신계약)"	*/
		String	cont_plan_date  = guarInfo.get("CONT_PLAN_DATE");					/*	[선택]	 준공예정일	*/
		String	cont_main_date  = guarInfo.get("CONT_MAIN_DATE");					/*	[선택]	 계약체결일자(YYYYMMDD)	*/
		String	cont_curc_code  = guarInfo.get("CONT_CURC_CODE");					/*	[필수]	 계약금액(원화)/통화코드(WON)	*/
		String	cont_main_amnt  = String.valueOf(guarInfo.get("CONT_MAIN_AMNT"));	/*	[필수]	 계약금액(원화)/계약금액	*/
		String	forn_curc_code  = guarInfo.get("FORN_CURC_CODE");					/*	[선택]	 계약금액(외화)/통화코드(USD …)	*/
		String	forn_main_amnt  = guarInfo.get("FORN_MAIN_AMNT");					/*	[선택]	 계약금액(외화)/계약금액	*/
		String	hist_bond_numb  = guarInfo.get("HIST_BOND_NUMB");					/*	[선택]	 변경(배서)대상 증권번호(반드시 18자리 증권번호여야 함 : 기존 증권구분번호가 "004002XXXXXXXXXXXXXXXXXX 00인 경우 중앙의 18자리)	*/

		/* 계약정보(이행 계약 통보 정보) Contract.Info.Details */
		String	cont_begn_date  = guarInfo.get("CONT_BEGN_DATE");					/*	[필수]	 계약시작일자(YYYYMMDD)	*/
		String	cont_fnsh_date  = guarInfo.get("CONT_FNSH_DATE");					/*	[필수]	 계약종료일자(YYYYMMDD)	*/
		String	cont_term_text  = guarInfo.get("CONT_TERM_TEXT");					/*	[선택]	 계약기간(계약종료일자 - 계약시작일자 : 계약기간 총 일수)	*/
		String	cont_pric_rate  = String.valueOf(guarInfo.get("CONT_PRIC_RATE"));	/*	[필수]	" 보증금율(단가계약일 경우 ""0""으로 입력)"	*/
		String	cont_unit_divs  = guarInfo.get("CONT_UNIT_DIVS");					/*	[필수]	" 단가계약 여부(1:단가계약, 2:일반계약)"	*/

		/* 선금정보(이행 선금 통보 정보) */
		String	prep_paym_type  = guarInfo.get("PREP_PAYM_TYPE");					/*	[필수]	지급구분 - 1:직불(수요자), 2;대지급(채권자)	*/
		String	prep_begn_date  = guarInfo.get("PREP_BEGN_DATE");					/*	[필수]	계약 시작일자(YYYYMMDD)	*/
		String	prep_fnsh_date  = guarInfo.get("PREP_FNSH_DATE");					/*	[필수]	계약 종료일자(YYYYMMDD)	*/
		String	prep_term_text  = String.valueOf(guarInfo.get("PREP_TERM_TEXT"));	/*	계약기간(일수) = 계약종료일자-계약시작일자(계약기간 총 일수)	*/
		String	prep_paym_date  = guarInfo.get("PREP_PAYM_DATE");					/*	[필수]	선금지급(예정)일자(YYYYMMDD) 	*/
		String	prep_curc_code  = String.valueOf(guarInfo.get("PREP_CURC_CODE"));	/*	[필수]	선금지급(예정)금액(원화) 통화코드 - WON(원화)	*/
		String	prep_paym_amnt  = String.valueOf(guarInfo.get("PREP_PAYM_AMNT"));	/*	[필수]	선금지급(예정)금액(원화)	*/
		String	fpre_curc_code  = guarInfo.get("FPRE_CURC_CODE");					/*	선금지급(예정)금액(외화) 통화코드 - USD(미달러), EUR(유로화) 등	*/
		String	fpre_paym_amnt  = guarInfo.get("FPRE_PAYM_AMNT");					/*	선금지급(예정)금액(외화) - 예)260.55	*/
		String	prep_pric_rate  = guarInfo.get("PREP_PRIC_RATE");					/*	선금율	*/

		/* 하자정보(이행 하자 통보 정보) */
		String	morg_begn_date  = guarInfo.get("MORG_BEGN_DATE");					/*	[필수]	하자보수 책임시작일 - YYYYMMDD	*/
		String	morg_fnsh_date  = guarInfo.get("MORG_FNSH_DATE");					/*	[필수]	하자보수 책임종료일 - YYYYMMDD	*/
		String	morg_term_text  = String.valueOf(guarInfo.get("MORG_TERM_TEXT"));	/*	[필수]	하자보수 책임기간 = 하자보수책임 종료일자-하자보수책임 시작일자(하자보수책임 총 일수)	*/
		String	morg_pric_rate  = String.valueOf(guarInfo.get("MORG_PRIC_RATE"));	/*	[필수]	하자보증금율	*/
		String	morg_cnfm_code  = guarInfo.get("MORG_CNFM_CODE");					/*	무사고 확인   - Y:하자없음, N:하자있음 (하자보수 책임시작일로 부터 30일이상 경과시 필수항목)	*/
		String	morg_cnfm_date  = guarInfo.get("MORG_CNFM_DATE");					/*	무사고 확인일 - YYYYMMDD	*/

		/* 채권자 정보 Creditor.Info.Details */
		String	cred_exst_code  = guarInfo.get("CRED_EXST_CODE");					/*	채권자 존재형태 구분(1 : 단독, 2 : 공동) 	*/
		String	cred_orga_name  = guarInfo.get("CRED_ORGA_NAME");					/*	[필수]	 기관명	*/
		String	cred_orps_divs  = guarInfo.get("CRED_ORPS_DIVS");					/*	[필수]	 구분(O:사업자번호 P:주민등록번호)	*/
		//String	cred_orga_numb  = guarInfo.get("CRED_ORGA_NUMB");					/*	[필수]	 법인등록번호	*/
		//String	cred_orga_numb  = "1353110003920";									/*	[필수]	테스트용 법인등록번호	*/
		String	cred_orga_numb  = "0000000000000";		
		String	cred_orps_iden  = guarInfo.get("CRED_ORPS_IDEN");					/*	[필수]	 사업자/주민번호	*/
		String	cred_ownr_numb  = guarInfo.get("CRED_OWNR_NUMB");					/*	[필수]	 대표자 주민등록번호	*/
		String	cred_ownr_name  = guarInfo.get("CRED_OWNR_NAME");					/*	[필수]	 성명(대표자명)	*/
		String	cred_bond_hold  = guarInfo.get("CRED_BOND_HOLD");					/*	[필수]	 채권자명	*/
		String	cred_addn_name  = guarInfo.get("CRED_ADDN_NAME");					/*	[선택]	 채권기관 부가상호	*/
		String	cred_orga_post  = guarInfo.get("CRED_ORGA_POST");					/*	[필수]	 회사 우편번호	*/
		String	cred_orga_addr  = guarInfo.get("CRED_ORGA_ADDR");					/*	[필수]	 회사 주소	*/
		String	cred_chrg_name  = guarInfo.get("CRED_CHRG_NAME");					/*	[필수]	 담당자명	*/
		String	cred_dept_name  = guarInfo.get("CRED_DEPT_NAME");					/*	[필수]	 소속부서	*/
		String	cred_phon_numb  = guarInfo.get("CRED_PHON_NUMB");					/*	[필수]	 전화번호	*/
		String	cred_cell_phon  = guarInfo.get("CRED_CELL_PHON");					/*	[필수]	 핸드폰번호	*/
		String	cred_send_mail  = guarInfo.get("CRED_SEND_MAIL");					/*	[필수]	 담당자 EMAIL	*/

		String	cred_user_iden  = head_mesg_send;									/*	[필수]	 수신처ID	*/
		String	cred_user_type  = head_orga_code;									/*	[필수]	 수신처TYPE	*/

		/* 계약자 정보 Applier.Info.Details */
		String	appl_orga_name  = guarInfo.get("APPL_ORGA_NAME");					/*	[필수]	 기관명	*/
		String	appl_orps_divs  = guarInfo.get("APPL_ORPS_DIVS");					/*	[필수]	 구분(O:사업자번호 P:주민등록번호)	*/
		String	appl_orga_numb  = guarInfo.get("APPL_ORGA_NUMB");					/*	[선택]	 법인등록번호	*/
		String	appl_orps_iden  = guarInfo.get("APPL_ORPS_IDEN");					/*	[필수]	 사업자/주민번호	*/
		//String	appl_orps_iden  = "2128300381";									/*	[필수]	 테스트용  사업자번호	*/
		String	appl_ownr_numb  = guarInfo.get("APPL_OWNR_NUMB");					/*	[필수]	 대표자 주민등록번호	*/
		String	appl_ownr_name  = guarInfo.get("APPL_OWNR_NAME");					/*	[필수]	 성명(대표자명)	*/
		String	appl_addn_name  = guarInfo.get("APPL_ADDN_NAME");					/*	[선택]	 계약업체 부가상호	*/
		String	appl_orga_post  = guarInfo.get("APPL_ORGA_POST");					/*	[선택]	 회사 우편번호	*/
		String	appl_orga_addr  = guarInfo.get("APPL_ORGA_ADDR");					/*	[선택]	 회사 주소	*/
		String	appl_chrg_name  = guarInfo.get("APPL_CHRG_NAME");					/*	[필수]	 담당자명	*/
		String	appl_dept_name  = guarInfo.get("APPL_DEPT_NAME");					/*	[필수]	 소속부서	*/
		String	appl_offc_phon  = guarInfo.get("APPL_OFFC_PHON");					/*	[필수]	 전화번호	*/
		String	appl_cell_phon  = guarInfo.get("APPL_CELL_PHON");					/*	[필수]	 핸드폰번호	*/
		String	appl_send_mail  = guarInfo.get("APPL_SEND_MAIL");					/*	[필수]	 담당자 EMAIL	*/
		String	appl_home_post  = guarInfo.get("APPL_HOME_POST");					/*	[선택]	 자택 우편번호	*/
		String	appl_home_addr  = guarInfo.get("APPL_HOME_ADDR");					/*	[선택]	 자택 주소	*/
		String	appl_home_phon  = guarInfo.get("APPL_HOME_PHON");					/*	[선택]	 자택 전화번호	*/
		String	appl_user_iden  = head_mesg_send;									/*	[필수]	 수신처ID	*/
		String	appl_user_type  = head_orga_code;									/*	[필수]	 수신처TYPE	*/

		String xml_str = null;

		// 매핑 정보 파일, XML 탬플릿 정보 파일
		DataToXml datatoxml = new DataToXml(templates_path,headMesgType);
		if( datatoxml.getErrorCode() != 0 ) {
			System.out.println(datatoxml.getErrorMsg());
			return msg.getMessage("서울보증 전송 전문 xml 생성 실패");
		}
		
		/* HEADER */
		try{
			if(
				/* Begin of Header */
					datatoxml.setData("head_mesg_send", head_mesg_send)
				&&	datatoxml.setData("head_mesg_recv", head_mesg_recv)
				&&	datatoxml.setData("head_func_code", head_func_code)
				&&	datatoxml.setData("head_mesg_type", head_mesg_type)
				&&	datatoxml.setData("head_mesg_name", head_mesg_name)
				&&	datatoxml.setData("head_mesg_vers", head_mesg_vers)
				&&	datatoxml.setData("head_docu_numb", head_docu_numb)
				&&	datatoxml.setData("head_mang_numb", head_mang_numb)
				&&	datatoxml.setData("head_refr_numb", head_refr_numb)
				&&	datatoxml.setData("head_titl_name", head_titl_name)
				&&  datatoxml.setData("head_orga_code", head_orga_code)
				/* End of Header */

				/* Begin of 보험계약정보 */
				&&  datatoxml.setData("bond_kind_code", bond_kind_code)
				&&  datatoxml.setData("bond_begn_date", bond_begn_date)
				&&  datatoxml.setData("bond_fnsh_date", bond_fnsh_date)
				&&  datatoxml.setData("bond_curc_code", bond_curc_code)
				&&  datatoxml.setData("bond_penl_amnt", bond_penl_amnt)
				&&  datatoxml.setData("bond_oper_code", bond_oper_code)
				&&  datatoxml.setData("bond_appl_code", bond_appl_code)
				/* End of 보험계약정보 */

				/* Begin of 주요계약정보 */
				&&  datatoxml.setData("cont_numb_text", cont_numb_text)
				&&  datatoxml.setData("cont_name_text", cont_name_text)
				&&  datatoxml.setData("cont_proc_type", cont_proc_type)
				&&  datatoxml.setData("cont_type_iden", cont_type_iden)
				//&&  datatoxml.setData("cont_asgn_rate", cont_asgn_rate)
				&&  datatoxml.setData("cont_news_divs", cont_news_divs)
				&&  datatoxml.setData("cont_plan_date", cont_plan_date)
				&&  datatoxml.setData("cont_main_date", cont_main_date)
				&&  datatoxml.setData("cont_curc_code", cont_curc_code)
				&&  datatoxml.setData("cont_main_amnt", cont_main_amnt)
				//&&  datatoxml.setData("forn_curc_code", forn_curc_code)
				//&&  datatoxml.setData("forn_main_amnt", forn_main_amnt)
				//&&  datatoxml.setData("hist_bond_numb", hist_bond_numb)
				/* End of 주요계약정보 */

				/* Begin of 계약정보 */
				&& (coninf ? datatoxml.setData("cont_begn_date", cont_begn_date) : true)
				&& (coninf ? datatoxml.setData("cont_fnsh_date", cont_fnsh_date) : true)
				&& (coninf ? datatoxml.setData("cont_term_text", cont_term_text) : true)
				&& (coninf ? datatoxml.setData("cont_pric_rate", cont_pric_rate) : true)
				&& (coninf ? datatoxml.setData("cont_unit_divs", cont_unit_divs) : true)
				/* End of 계약정보 */

				/* Begin of 선급보증 */
				&& (preinf ? datatoxml.setData("prep_paym_type", prep_paym_type) : true)
				&& (preinf ? datatoxml.setData("prep_begn_date", prep_begn_date) : true)
				&& (preinf ? datatoxml.setData("prep_fnsh_date", prep_fnsh_date) : true)
				&& (preinf ? datatoxml.setData("prep_term_text", prep_term_text) : true)
				&& (preinf ? datatoxml.setData("prep_paym_date", prep_paym_date) : true)
				&& (preinf ? datatoxml.setData("prep_curc_code", prep_curc_code) : true)
				&& (preinf ? datatoxml.setData("prep_paym_amnt", prep_paym_amnt) : true)
				&& (preinf ? datatoxml.setData("fpre_curc_code", fpre_curc_code) : true)
				&& (preinf ? datatoxml.setData("fpre_paym_amnt", fpre_paym_amnt) : true)
				&& (preinf ? datatoxml.setData("prep_pric_rate", prep_pric_rate) : true)
				/* End of 선급보증 */

				/* Begin of 하자보증 */
				&& (flrinf ? datatoxml.setData("morg_begn_date", morg_begn_date) : true)
				&& (flrinf ? datatoxml.setData("morg_fnsh_date", morg_fnsh_date) : true)
				&& (flrinf ? datatoxml.setData("morg_term_text", morg_term_text) : true)
				&& (flrinf ? datatoxml.setData("morg_pric_rate", morg_pric_rate) : true)
				&& (flrinf ? datatoxml.setData("morg_cnfm_code", morg_cnfm_code) : true)
				&& (flrinf ? datatoxml.setData("morg_cnfm_date", morg_cnfm_date) : true)
				/* End of 하자보증 */

				/* Begin of 채권자 정보 */
				&&  datatoxml.setData("cred_orga_name", cred_orga_name)
				&&  datatoxml.setData("cred_orps_divs", cred_orps_divs)
				&&  datatoxml.setData("cred_orga_numb", cred_orga_numb)
				&&  datatoxml.setData("cred_orps_iden", cred_orps_iden)
				&&  datatoxml.setData("cred_ownr_numb", cred_ownr_numb)
				&&  datatoxml.setData("cred_ownr_name", cred_ownr_name)
				&&  datatoxml.setData("cred_bond_hold", cred_bond_hold)
				&&  datatoxml.setData("cred_addn_name", cred_addn_name)
				&&  datatoxml.setData("cred_orga_post", cred_orga_post)
				&&  datatoxml.setData("cred_orga_addr", cred_orga_addr)
				&&  datatoxml.setData("cred_chrg_name", cred_chrg_name)
				&&  datatoxml.setData("cred_dept_name", cred_dept_name)
				&&  datatoxml.setData("cred_phon_numb", cred_phon_numb)
				&&  datatoxml.setData("cred_cell_phon", cred_cell_phon)
				&&  datatoxml.setData("cred_send_mail", cred_send_mail)
				&&  datatoxml.setData("cred_user_iden", cred_user_iden)
				&&  datatoxml.setData("cred_user_type", cred_user_type)
				/* End of 채권자 정보 */

				/* Begin of 계약자 정보 */
				&&  datatoxml.setData("appl_orga_name", appl_orga_name)
				&&  datatoxml.setData("appl_orps_divs", appl_orps_divs)
				&&  datatoxml.setData("appl_orga_numb", appl_orga_numb)
				&&  datatoxml.setData("appl_orps_iden", appl_orps_iden)
				&&  datatoxml.setData("appl_ownr_numb", appl_ownr_numb)
				&&  datatoxml.setData("appl_ownr_name", appl_ownr_name)
				&&  datatoxml.setData("appl_addn_name", appl_addn_name)
				&&  datatoxml.setData("appl_orga_post", appl_orga_post)
				&&  datatoxml.setData("appl_orga_addr", appl_orga_addr)
				&&  datatoxml.setData("appl_chrg_name", appl_chrg_name)
				&&  datatoxml.setData("appl_dept_name", appl_dept_name)
				&&  datatoxml.setData("appl_offc_phon", appl_offc_phon)
				&&  datatoxml.setData("appl_cell_phon", appl_cell_phon)
				&&  datatoxml.setData("appl_send_mail", appl_send_mail)
				&&  datatoxml.setData("appl_home_post", appl_home_post)
				&&  datatoxml.setData("appl_home_addr", appl_home_addr)
				&&  datatoxml.setData("appl_home_phon", appl_home_phon)
				&&  datatoxml.setData("appl_user_iden", appl_user_iden)
				&&  datatoxml.setData("appl_user_type", appl_user_type)
				/* End of 계약자 정보 */
				
				/* Begin of 수요자 정보 */
				&&  datatoxml.setData("mang_orga_name", "")
				&&  datatoxml.setData("mang_orps_divs", "")
				&&  datatoxml.setData("mang_orga_numb", "")
				&&  datatoxml.setData("mang_orps_iden", "")
				&&  datatoxml.setData("mang_ownr_numb", "")
				&&  datatoxml.setData("mang_ownr_name", "")
				&&  datatoxml.setData("mang_addn_name", "")
				&&  datatoxml.setData("mang_orga_post", "")
				&&  datatoxml.setData("mang_orga_addr", "")
				&&  datatoxml.setData("mang_bond_hold", "")
				&&  datatoxml.setData("mang_chrg_name", "")
				&&  datatoxml.setData("mang_dept_name", "")
				&&  datatoxml.setData("mang_phon_numb", "")
				&&  datatoxml.setData("mang_cell_phon", "")
				&&  datatoxml.setData("mang_send_mail", "")
				&&  datatoxml.setData("mang_user_iden", "")
				&&  datatoxml.setData("mang_user_type", "")
				/* End of 수요자 정보 */
			)
			{
				xml_str = datatoxml.getxmlData();
		        if(PropertiesManager.getBoolean("eversrm.system.developmentFlag")) {// 개발서버에서는
			        if(PropertiesManager.getBoolean("eversrm.system.localserver")) {// 개발서버에서는 고정된 값으로.
						datatoxml.writexmlFile("C:/mmmm.xml");
			        } else {
						datatoxml.writexmlFile("/svc/nhepro/TempXml/mmmm.xml");
			        }
		        } else {
		        	datatoxml.writexmlFile("C:/mmmm.xml");
		        }
				System.err.println("===xml start=======================================================================================================");
				System.err.println(xml_str);
				System.err.println("===xml end=======================================================================================================");
			} else {
				System.out.println(datatoxml.getErrorMsg());
				throw new Exception(datatoxml.getErrorMsg());
			}
		}
		catch(Exception e){
			logger.error(e.getMessage());
			throw e;
		}
		/////////////////////// xml문서 생성 end ////////////////////////

		if(xml_str == null){
			System.out.println("서울보증 전송 전문 xml 생성 실패");
			return msg.getMessage("서울보증 전송 전문 xml 생성 실패");
		}
		
		// 개발 테스트가 아닌 경우
		try {
	        if( !PropertiesManager.getBoolean("eversrm.system.localserver") ) {
				////////////////////// xml 문서 송신 start ///////////////////////
				SGIxLinker xLinker =  new SGIxLinker(sendinfo_conf, "send_jsp", true);
				xLinker.setXmlEncoding("UTF-8");
				
		    	boolean isOK = xLinker.doSendProcess(xml_str, null);
		    	// 전송완료처리
		    	System.err.println("=============================================================================isOK="+isOK);
				if(!isOK) {
					//System.out.println("SGIxLinker 에러메시지 : " + xLinker.getErrorMsg());
					logger.debug("SGIxLinker 에러메시지:" + xLinker.getErrorMsg());
					throw new Exception("=="+xLinker.getErrorMsg()+"==");
				}
	
				//***************************************
				// xml 응답서 문서 정보를 XmltoData로 추출하여 상태값 DB에 저장
				// 매핑 정보 파일, XML 탬플릿 정보 파일
				String recvXml = xLinker.getRecvXmlData();
				XmlToData xmlToData = null;
				try{
					System.err.println("==recvXmlrecvXmlrecvXmlrecvXmlrecvXmlrecvXmlrecvXmlrecvXmlrecvXmlrecvXmlrecvXml==========================================================recvXml==recvXml="+recvXml);
					xmlToData = new XmlToData(xLinker.getTempPath() , "RESPONSE", recvXml);
					if( xmlToData.getErrorCode() != 0 ) {
						//System.out.println(xmlToData.getErrorMsg());
						logger.debug(xmlToData.getErrorMsg());
						throw new Exception("=="+xmlToData.getErrorMsg()+"==");
					}
				}
				catch(Exception e){
					logger.error(e.getMessage());
					throw new Exception("=="+xmlToData.getErrorMsg()+"==");
				}
	
				String res_cont_num = xmlToData.getData("res_cont_num");
				//String res_docu_num = xmlToData.getData("res_docu_num");
				String respTypeCode = xmlToData.getData("res_info_code");
				String respTypeName = xmlToData.getData("res_info_typename");
				String respMesgText = xmlToData.getData("res_info_result");
				System.out.println("계약번호 = "+res_cont_num);
				System.out.println("응답코드 = "+respTypeCode);
				System.out.println("응답코드명 = "+respTypeName);
				System.out.println("응답메시지 = "+respMesgText);
				
				if( respTypeCode == null || !"SA".equals(respTypeCode) ) {
					throw new Exception("계약번호 = "+res_cont_num
							+"\n응답코드 = "+respTypeCode
							+"\n응답코드명 = "+respTypeName
							+"\n응답메시지 = "+respMesgText
					);
				}
		        
				sctr0010_mapper.upsGuarCancelRecevieEcpc(guarData);
	        }
		}
    	catch (Exception e) {
    		logger.error(e.getMessage());
			throw e;
		}
    	
    	return msg.getMessage("0001");
    }
    
    
    /**
     * 전자계약 : 소프트웨어(SW) 공제조합 보증 신청
     * @param guarData
     * @throws Exception
     */
    public String sendGuarSW(Map<String, Object> guarData) throws Exception {
    	
    	//Map<String, Object> guarData = grid.get(0);
    	
    	// 소프트웨어(SW) 공지조합 전송전문 가져오기
    	Map<String, String> guarInfo = sctr0010_mapper.getGuarSWDataEcct(guarData);
    	System.err.println("==============================guarInfo=============="+guarInfo);
    	
    	// 계약보증번호 채번
    	String guarReqNum = "";
    	if( StringUtils.isEmpty(guarInfo.get("GUAR_REQ_NUM")) ) {
    		guarReqNum = docNumService.getDocNumber(PropertiesManager.getString("eversrm.default.company.code"), "GU");
        	guarData.put("GUAR_REQ_NUM", guarReqNum);
    	} else {
    		guarData.put("GUAR_REQ_NUM", guarInfo.get("GUAR_REQ_NUM"));
    	}
    	guarReqNum = String.valueOf(guarData.get("GUAR_REQ_NUM"));

    	String guarSWUrl = "";
    	
    	if (PropertiesManager.getBoolean("eversrm.system.localserver") || PropertiesManager.getBoolean("eversrm.system.developmentFlag")) {// 개발서버 : 농협정보시스템
    		System.out.println(" ====== 개발 ======");
    		guarSWUrl = PropertiesManager.getString("eversrm.developswGuar.url");
        } else {
        	System.out.println(" ====== 운영 ======");
        	//운영서버url
        	guarSWUrl = PropertiesManager.getString("eversrm.swGuar.url");
        }

    	String headMesgRecv = "z211821245600";
    	String headMesgType = "UNICON";
    	String head_docu_func = "UNICON";
    	
    	String headMesgName = "통합계약정보통보서";
    	String head_docu_numb  =guarInfo.get("HEAD_DOCU_NUMB");	/*	문서번호		*/
		String head_mang_numb  =guarInfo.get("HEAD_MANG_NUMB");	/*	문서관리번호	*/
		String head_refr_numb  =guarInfo.get("HEAD_REFR_NUMB");	/*	참조번호		*/
		String cont_unin_numb  =guarInfo.get("CONT_UNIN_NUMB");	/*	통합계약번호	*/
		String cont_rfrn_numb  =guarInfo.get("CONT_RFRN_NUMB");	/*	계약참조번호	*/
		String cont_numb_idnr  =guarInfo.get("CONT_NUMB_IDNR");	/*	확정계약번호	*/

		head_docu_numb = head_docu_numb.replaceAll("XXXXXXXXXX", guarReqNum);
		head_mang_numb = head_mang_numb.replaceAll("XXXXXXXXXX", guarReqNum);
		head_refr_numb = head_refr_numb.replaceAll("XXXXXXXXXX", guarReqNum); //실계약번호
		cont_unin_numb = cont_unin_numb.replaceAll("XXXXXXXXXX", guarReqNum);
		cont_rfrn_numb = cont_rfrn_numb.replaceAll("XXXXXXXXXX", guarReqNum);
		cont_numb_idnr = cont_numb_idnr.replaceAll("XXXXXXXXXX", guarReqNum);
		
    	try {
    		URL url = new URL(guarSWUrl);
    		HttpURLConnection conn = (HttpURLConnection)url.openConnection();
    		conn.setDefaultUseCaches(false);
    		conn.setDoInput(true);
    		conn.setDoOutput(true);
    		conn.setRequestMethod("POST");
    		conn.setRequestProperty("content-type", "application/x-www-form-urlencoded");

    		//항목이름`=항목값`&항목이름`=항목값`
    		String emptyString = "";
    		String nameValue = "head_mesg_send=21&head_mesg_recv_cont=1"
    				+ "&head_mesg_recv1=" + headMesgRecv
    				+ "&head_func_code=09"
    				+ "&head_mesg_type=" + headMesgType
    				+ "&head_mesg_name=" + transHan(headMesgName)
    				+ "&head_mesg_vers=1.0"
    				+ "&head_docu_numb=" + head_docu_numb
    				+ "&head_mang_numb=" + head_mang_numb
    				+ "&head_refr_numb=" + head_refr_numb
    				+ "&head_titl_name=" + transHan(headMesgName)
    				+ "&head_orga_code=NHI"
    				+ "&head_docu_func=" + head_docu_func 
    				+ "&head_docu_issu=" + guarInfo.get("HEAD_DOCU_ISSU")
    				+ "&cont_unin_numb=" + cont_unin_numb
    				+ "&cont_rfrn_numb=" + cont_rfrn_numb
    				+ "&cont_numb_idnr=" + cont_numb_idnr
    				+ "&cont_seqn_numb=" + guarInfo.get("CONT_SEQN_NUMB")
    				+ "&cont_ibid_indr=" + guarInfo.get("CONT_IBID_INDR")
    				+ "&cont_name_text=" + transHan(guarInfo.get("CONT_NAME_TEXT"))
    				+ "&cont_mean_code=" + guarInfo.get("CONT_MEAN_CODE")
    				+ "&cont_paym_code=" + guarInfo.get("CONT_PAYM_CODE")
    				+ "&cont_clas_code=" + guarInfo.get("CONT_CLAS_CODE")
    				+ "&cont_dcls_code=" + guarInfo.get("CONT_DCLS_CODE")
    				+ "&cont_acls_code=" + emptyString
    				+ "&cont_ctyp_indr=" + guarInfo.get("CONT_CTYP_INDR")
    				+ "&cont_rnum_idnr=" + emptyString
    				+ "&cont_cprn_indr=" + guarInfo.get("CONT_CPRN_INDR")
    				+ "&cont_date_time=" + guarInfo.get("CONT_DATE_TIME")
    				+ "&cont_strt_date=" + guarInfo.get("CONT_STRT_DATE")
    				+ "&cont_ends_date=" + guarInfo.get("CONT_ENDS_DATE")
    				+ "&cont_perd_text=" + String.valueOf(guarInfo.get("CONT_PERD_TEXT"))
    				+ "&cont_cmpt_date=" + guarInfo.get("CONT_ENDS_DATE")
    				+ "&cont_blaw_code=" + guarInfo.get("CONT_BLAW_CODE")
    				+ "&cont_lcls_code=" + emptyString
    				+ "&cont_bcla_text=" + emptyString
    				+ "&cont_bdtl_text=" + emptyString
    				+ "&cont_acls_code=" + emptyString
    				+ "&cont_gnot_text=" + emptyString
    				+ "&cont_amnt_cont=" + String.valueOf(guarInfo.get("CONT_AMNT_CONT"))
    				+ "&cont_this_amnt=" + String.valueOf(guarInfo.get("CONT_AMNT_CONT"))
    				+ "&cont_amnt_rate=" + String.valueOf(guarInfo.get("CONT_AMNT_RATE"))
    				+ "&cont_pric_rate=" + String.valueOf(guarInfo.get("CONT_PRIC_RATE"))
    				+ "&cont_mrtg_perd=" + String.valueOf(guarInfo.get("CONT_MRTG_PERD"))
    				+ "&cont_ntfy_info=" + emptyString
    				+ "&cont_reqt_idnr=" + emptyString
    				+ "&cont_curl_link=" + emptyString
    				+ "&coor_item_cont=1"
    				+ "&coor_line_numb1=" + guarInfo.get("COOR_LINE_NUMB")
    				+ "&coor_orgn_cccd1=" + guarInfo.get("COOR_ORGN_CCCD")
    				+ "&coor_orgn_idnr1=" + guarInfo.get("COOR_ORGN_IDNR")
    				+ "&coor_orgn_addi1=" + guarInfo.get("COOR_ORGN_ADDI")
    				+ "&coor_orgn_addd1=" + emptyString
    				+ "&coor_orgn_name1=" + transHan(guarInfo.get("COOR_ORGN_NAME"))
    				+ "&coor_orgn_gccd1=" + emptyString
    				+ "&coor_empl_cred1=" + transHan(guarInfo.get("COOR_EMPL_CRED"))
    				+ "&coor_empl_dept1=" + transHan(guarInfo.get("COOR_EMPL_DEPT"))
    				+ "&coor_empl_idnr1=" + emptyString
    				+ "&coor_empl_idnn1=" + emptyString
    				+ "&coor_empl_name1=" + transHan(guarInfo.get("COOR_EMPL_NAME"))
    				+ "&coor_tele_numb1=" + guarInfo.get("COOR_TELE_NUMB")
    				+ "&coor_faxs_numb1=" + guarInfo.get("COOR_FAXS_NUMB")
    				+ "&suor_item_cont=1"
    				+ "&suor_line_numb1=" + guarInfo.get("SUOR_LINE_NUMB")
    				+ "&suor_orgn_cccd1=" + guarInfo.get("SUOR_ORGN_CCCD")
    				+ "&suor_orgn_ctcd1=" + emptyString
    				+ "&suor_orgn_idnr1=" + guarInfo.get("SUOR_ORGN_IDNR")
    				+ "&suor_orgn_addi1=" + guarInfo.get("SUOR_ORGN_ADDI")
    				+ "&suor_orgn_addd1=" + emptyString
     				+ "&suor_orgn_name1=" + transHan(guarInfo.get("SUOR_ORGN_NAME"))
    				+ "&suor_orgn_cred1=" + guarInfo.get("SUOR_ORGN_CRED")
    				+ "&suor_empl_dept1=" + transHan(guarInfo.get("SUOR_EMPL_DEPT"))
    				+ "&suor_empl_idnr1=" + emptyString
    				+ "&suor_empl_idnn1=" + emptyString
    				+ "&suor_empl_name1=" + transHan(guarInfo.get("SUOR_EMPL_NAME"))
    				+ "&suor_tele_numb1=" + guarInfo.get("SUOR_TELE_NUMB")
    				+ "&suor_faxs_numb1=" + emptyString
    				+ "&suor_ctyp_code1=" + emptyString
    				+ "&suor_cons_rate1=" + emptyString
    				+ "&svce_line_numb=" + emptyString
    				+ "&svce_repr_indr=" + emptyString
    				+ "&svce_clas_code=" + emptyString
    				+ "&svce_cons_tycd=" + emptyString
    				+ "&svce_cons_locd=" + emptyString
    				+ "&svce_amnt_cont=" + emptyString
    				+ "&svce_rela_dtls=" + emptyString
    				+ "&svce_genl_note=" + emptyString;
    		
    		
    		OutputStreamWriter outStream = new OutputStreamWriter(conn.getOutputStream(), "UTF-8");

    		PrintWriter wr = new PrintWriter(outStream);
        	wr.write(nameValue);
        	wr.flush();
        	wr.close();

		    BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream(), "EUC-KR"));
		    StringBuilder builder = new StringBuilder();

		    String str = "";

		    while((str = in.readLine()) != null) {
		    	builder.append(str);
		    }

		    in.close();

		    System.out.println("=====================");
    	    System.out.println("" + builder.toString());
    	    System.out.println("=====================");

    	    String recv = builder.toString();
    	    System.out.println("===================== recv=" +recv);
    	    
    		Hashtable dataHash = new Hashtable();
    		String[] dataList = recv.split("`&"); // `& 로 항목 구분
    		
    		String data = "";
    		
    	    for (int i = 0 ; i < dataList.length ; i++) {
    			data = (String)dataList[i];
    			System.out.println(data.substring(0, data.indexOf("`=")) + "=" + data.substring(data.indexOf("`=") + 2));
    			
    			dataHash.put(data.substring(0, data.indexOf("`=")), data.substring(data.indexOf("`=") + 2)); // Name`=Value 구분
    		}
    	    
			String contNumbText = (String)dataHash.get("cont_numb_text");
			String respTypeCode = (String)dataHash.get("resp_type_code");
			String respTypeName = (String)dataHash.get("resp_type_name");
			String respMesgText = (String)dataHash.get("resp_mesg_text");
			System.out.println("계약번호 = "+contNumbText);
			System.out.println("응답코드 = "+respTypeCode);
			System.out.println("응답코드명 = "+respTypeName);
			System.out.println("응답메시지 = "+respMesgText);
			
			if( respTypeCode == null || !"SA".equals(respTypeCode) ) {
				throw new Exception("계약번호 = "+contNumbText
						+"\n응답코드 = "+respTypeCode
						+"\n응답코드명 = "+respTypeName
						+"\n응답메시지 = "+respMesgText
				);
			}
    	    
	    	sctr0010_mapper.setGuarSendComplete(guarData);  //최초신청 INSU_STATUS = 'TA'
			//대금지급 사용안함
			//sctr0010_mapper.setGuarSendCompleteIvap(guarData);
    	}
    	catch (Exception e) {
    		logger.error(e.getMessage());
			throw e;
		}
    	
    	return msg.getMessage("0001");
    }
    
    
    /**
     * 전자계약 : 소프트웨어(SW) 공제조합 보증증권 발행 전 취소
     * @param guarData
     * @throws Exception
     */
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String sendGuarCancelSW(Map<String, Object> guarData) throws Exception {
    	
    	// 소프트웨어(SW) 공제조합 전송전문 가져오기
    	Map<String, String> guarInfo = sctr0010_mapper.getGuarSWDataEcct(guarData);
    	System.err.println("==============================guarInfo=============="+guarInfo);
    	
    	// 계약보증번호 채번
    	String guarReqNum = "";
    	if( StringUtils.isEmpty(guarInfo.get("GUAR_REQ_NUM")) ) {
    		guarReqNum = docNumService.getDocNumber(PropertiesManager.getString("eversrm.default.company.code"), "GU");
        	guarData.put("GUAR_REQ_NUM", guarReqNum);
    	} else {
    		guarData.put("GUAR_REQ_NUM", guarInfo.get("GUAR_REQ_NUM"));
    	}
    	guarReqNum = String.valueOf(guarData.get("GUAR_REQ_NUM"));

    	String guarSWUrl = "";
    	
    	if (PropertiesManager.getBoolean("eversrm.system.localserver") || PropertiesManager.getBoolean("eversrm.system.developmentFlag")) {
    		guarSWUrl = PropertiesManager.getString("eversrm.developswGuar.url");
        } else {
        	//운영서버url
        	guarSWUrl = PropertiesManager.getString("eversrm.swGuar.url");
        }
    	
    	String headMesgRecv = "z211821245600";
    	String headMesgType = "UNICON";
    	String head_docu_func = "DD";
    	
    	String headMesgName = "통합계약정보통보서";
    	String head_docu_numb  =guarInfo.get("HEAD_DOCU_NUMB");	/*	문서번호		*/
		String head_mang_numb  =guarInfo.get("HEAD_MANG_NUMB");	/*	문서관리번호	*/
		String head_refr_numb  =guarInfo.get("HEAD_REFR_NUMB");	/*	참조번호		*/
		String cont_unin_numb  =guarInfo.get("CONT_UNIN_NUMB");	/*	통합계약번호	*/
		String cont_rfrn_numb  =guarInfo.get("CONT_RFRN_NUMB");	/*	계약참조번호	*/
		String cont_numb_idnr  =guarInfo.get("CONT_NUMB_IDNR");	/*	확정계약번호	*/
		
		head_docu_numb = head_docu_numb.replaceAll("XXXXXXXXXX", guarReqNum);
		head_mang_numb = head_mang_numb.replaceAll("XXXXXXXXXX", guarReqNum);
		head_refr_numb = head_refr_numb.replaceAll("XXXXXXXXXX", guarReqNum);
		cont_unin_numb = cont_unin_numb.replaceAll("XXXXXXXXXX", guarReqNum);
		cont_rfrn_numb = cont_rfrn_numb.replaceAll("XXXXXXXXXX", guarReqNum);
		cont_numb_idnr = cont_numb_idnr.replaceAll("XXXXXXXXXX", guarReqNum);
				
    	try {
    		
    		URL url = new URL(guarSWUrl);
    		HttpURLConnection conn = (HttpURLConnection)url.openConnection();
    		conn.setDefaultUseCaches(false);
    		conn.setDoInput(true);
    		conn.setDoOutput(true);
    		conn.setRequestMethod("POST");
    		conn.setRequestProperty("content-type", "application/x-www-form-urlencoded");

    		//항목이름`=항목값`&항목이름`=항목값`
    		String emptyString = "";
    		String nameValue = "head_mesg_send=21&head_mesg_recv_cont=1"
    				+ "&head_mesg_recv1=" + headMesgRecv
    				+ "&head_func_code=09"
    				+ "&head_mesg_type=" + headMesgType
    				+ "&head_mesg_name=" + transHan(headMesgName)
    				+ "&head_mesg_vers=1.0"
    				+ "&head_docu_numb=" + head_docu_numb
    				+ "&head_mang_numb=" + head_mang_numb
    				+ "&head_refr_numb=" + head_refr_numb
    				+ "&head_titl_name=" + transHan(headMesgName)
    				+ "&head_orga_code=NHI"
    				+ "&head_docu_func=" + head_docu_func 
    				+ "&head_docu_issu=" + guarInfo.get("HEAD_DOCU_ISSU")
    				+ "&cont_unin_numb=" + cont_unin_numb
    				+ "&cont_rfrn_numb=" + cont_rfrn_numb
    				+ "&cont_numb_idnr=" + cont_numb_idnr
    				+ "&cont_seqn_numb=" + guarInfo.get("CONT_SEQN_NUMB")
    				+ "&cont_ibid_indr=" + guarInfo.get("CONT_IBID_INDR")
    				+ "&cont_name_text=" + transHan(guarInfo.get("CONT_NAME_TEXT"))
    				+ "&cont_mean_code=" + guarInfo.get("CONT_MEAN_CODE")
    				+ "&cont_paym_code=" + guarInfo.get("CONT_PAYM_CODE")
    				+ "&cont_clas_code=" + guarInfo.get("CONT_CLAS_CODE")
    				+ "&cont_dcls_code=" + guarInfo.get("CONT_DCLS_CODE")
    				+ "&cont_acls_code=" + emptyString
    				+ "&cont_ctyp_indr=" + guarInfo.get("CONT_CTYP_INDR")
    				+ "&cont_rnum_idnr=" + emptyString
    				+ "&cont_cprn_indr=" + guarInfo.get("CONT_CPRN_INDR")
    				+ "&cont_date_time=" + guarInfo.get("CONT_DATE_TIME")
    				+ "&cont_strt_date=" + guarInfo.get("CONT_STRT_DATE")
    				+ "&cont_ends_date=" + guarInfo.get("CONT_ENDS_DATE")
    				+ "&cont_perd_text=" + String.valueOf(guarInfo.get("CONT_PERD_TEXT"))
    				+ "&cont_cmpt_date=" + guarInfo.get("CONT_ENDS_DATE")
    				+ "&cont_blaw_code=" + guarInfo.get("CONT_BLAW_CODE")
    				+ "&cont_lcls_code=" + emptyString
    				+ "&cont_bcla_text=" + emptyString
    				+ "&cont_bdtl_text=" + emptyString
    				+ "&cont_acls_code=" + emptyString
    				+ "&cont_gnot_text=" + emptyString
    				+ "&cont_amnt_cont=" + String.valueOf(guarInfo.get("CONT_AMNT_CONT"))
    				+ "&cont_this_amnt=" + String.valueOf(guarInfo.get("CONT_AMNT_CONT"))
    				+ "&cont_amnt_rate=" + String.valueOf(guarInfo.get("CONT_AMNT_RATE"))
    				+ "&cont_pric_rate=" + String.valueOf(guarInfo.get("CONT_PRIC_RATE"))
    				+ "&cont_mrtg_perd=" + String.valueOf(guarInfo.get("CONT_MRTG_PERD"))
    				+ "&cont_ntfy_info=" + emptyString
    				+ "&cont_reqt_idnr=" + emptyString
    				+ "&cont_curl_link=" + emptyString
    				+ "&coor_item_cont=1"
    				+ "&coor_line_numb1=" + guarInfo.get("COOR_LINE_NUMB")
    				+ "&coor_orgn_cccd1=" + guarInfo.get("COOR_ORGN_CCCD")
    				+ "&coor_orgn_idnr1=" + guarInfo.get("COOR_ORGN_IDNR")
    				+ "&coor_orgn_addi1=" + guarInfo.get("COOR_ORGN_ADDI")
    				+ "&coor_orgn_addd1=" + emptyString
    				+ "&coor_orgn_name1=" + transHan(guarInfo.get("COOR_ORGN_NAME"))
    				+ "&coor_orgn_gccd1=" + emptyString
    				+ "&coor_empl_cred1=" + transHan(guarInfo.get("COOR_EMPL_CRED"))
    				+ "&coor_empl_dept1=" + transHan(guarInfo.get("COOR_EMPL_DEPT"))
    				+ "&coor_empl_idnr1=" + emptyString
    				+ "&coor_empl_idnn1=" + emptyString
    				+ "&coor_empl_name1=" + transHan(guarInfo.get("COOR_EMPL_NAME"))
    				+ "&coor_tele_numb1=" + guarInfo.get("COOR_TELE_NUMB")
    				+ "&coor_faxs_numb1=" + guarInfo.get("COOR_FAXS_NUMB")
    				+ "&suor_item_cont=1"
    				+ "&suor_line_numb1=" + guarInfo.get("SUOR_LINE_NUMB")
    				+ "&suor_orgn_cccd1=" + guarInfo.get("SUOR_ORGN_CCCD")
    				+ "&suor_orgn_ctcd1=" + emptyString
    				+ "&suor_orgn_idnr1=" + guarInfo.get("SUOR_ORGN_IDNR")
    				+ "&suor_orgn_addi1=" + guarInfo.get("SUOR_ORGN_ADDI")
    				+ "&suor_orgn_addd1=" + emptyString
     				+ "&suor_orgn_name1=" + transHan(guarInfo.get("SUOR_ORGN_NAME"))
    				+ "&suor_orgn_cred1=" + guarInfo.get("SUOR_ORGN_CRED")
    				+ "&suor_empl_dept1=" + transHan(guarInfo.get("SUOR_EMPL_DEPT"))
    				+ "&suor_empl_idnr1=" + emptyString
    				+ "&suor_empl_idnn1=" + emptyString
    				+ "&suor_empl_name1=" + transHan(guarInfo.get("SUOR_EMPL_NAME"))
    				+ "&suor_tele_numb1=" + guarInfo.get("SUOR_TELE_NUMB")
    				+ "&suor_faxs_numb1=" + emptyString
    				+ "&suor_ctyp_code1=" + emptyString
    				+ "&suor_cons_rate1=" + emptyString
    				+ "&svce_line_numb=" + emptyString
    				+ "&svce_repr_indr=" + emptyString
    				+ "&svce_clas_code=" + emptyString
    				+ "&svce_cons_tycd=" + emptyString
    				+ "&svce_cons_locd=" + emptyString
    				+ "&svce_amnt_cont=" + emptyString
    				+ "&svce_rela_dtls=" + emptyString
    				+ "&svce_genl_note=" + emptyString;
    		
    		
    		OutputStreamWriter outStream = new OutputStreamWriter(conn.getOutputStream(), "UTF-8");

    		PrintWriter wr = new PrintWriter(outStream);
        	wr.write(nameValue);
        	wr.flush();
        	wr.close();

		    BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream(), "EUC-KR"));
		    StringBuilder builder = new StringBuilder();

		    String str = "";

		    while((str = in.readLine()) != null) {
		    	builder.append(str);
		    }

		    in.close();

		    System.out.println("=====================");
    	    System.out.println("" + builder.toString());
    	    System.out.println("=====================");

    	    String recv = builder.toString();
    	    System.out.println("===================== recv=" +recv);
    	    
    		Hashtable dataHash = new Hashtable();
    		String[] dataList = recv.split("`&"); // `& 로 항목 구분
    		
    		String data = "";
    		
    	    for (int i = 0 ; i < dataList.length ; i++) {
    			data = (String)dataList[i];
    			System.out.println(data.substring(0, data.indexOf("`=")) + "=" + data.substring(data.indexOf("`=") + 2));
    			
    			dataHash.put(data.substring(0, data.indexOf("`=")), data.substring(data.indexOf("`=") + 2)); // Name`=Value 구분
    		}
    	    
			String contNumbText = (String)dataHash.get("cont_numb_text");
			String respTypeCode = (String)dataHash.get("resp_type_code");
			String respTypeName = (String)dataHash.get("resp_type_name");
			String respMesgText = (String)dataHash.get("resp_mesg_text");
			System.out.println("계약번호 = "+contNumbText);
			System.out.println("응답코드 = "+respTypeCode);
			System.out.println("응답코드명 = "+respTypeName);
			System.out.println("응답메시지 = "+respMesgText);
			
			if( respTypeCode == null || !"SA".equals(respTypeCode) ) {
				throw new Exception("계약번호 = "+contNumbText
						+"\n응답코드 = "+respTypeCode
						+"\n응답코드명 = "+respTypeName
						+"\n응답메시지 = "+respMesgText
				);
			}
			
	    	sctr0010_mapper.upsGuarCancelRecevieEcpc(guarData);
	    	
    	} catch (Exception e) {
			throw new Exception(e.getMessage());
		} 
    	
    	return msg.getMessage("0001");
    }
    
    
    public void doSaveBatchLog(Map<String, Object> logData) throws Exception {
    	sctr0010_mapper.doSaveBatchLog(logData);
    }
    
    /**
     * 전자계약 : 소프트웨어(SW) 공제조합 증권번호 발행 후 취소요청
     * @param guarData
     * @throws Exception
     */
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public Map<String, String> sendGuarCancel(Map<String, String> formData, List<Map<String, Object>> grid) throws Exception {
        Map<String, String> rtnMap = new HashMap<>();
        
        String guarType = "";
        String payCnt = "";
        
        for(Map<String, Object> data : grid) {
        	
        	guarType = String.valueOf(data.get("GUAR_TYPE"));
        	payCnt  = String.valueOf(data.get("PAY_CNT"));
        	
        	formData.put("GUAR_TYPE", guarType);
        	formData.put("PAY_CNT", payCnt);
            
            data.put("GUAR_CANCEL_RMK", formData.get("GUAR_CANCEL_RMK"));

            sctr0010_mapper.setGuarDelete(data);
            
        }
        
        // 고객사 계약담당자에게 보증취소요청 메일발송
        Map<String, String> guarInformation = sctr0010_mapper.sctr0010_getguarInformation(formData);
        String linkUrl = PropertiesManager.getString("eversrm.urls.maintain.real");
    	try {
 			String subject = "[전자구매시스템] 협력사 [" + guarInformation.get("VENDOR_NM") + "]가 [" + guarInformation.get("CONT_DESC") + "] 관련  보증취소를 요청하였습니다";
 			
 			Map<String,String> mailMap = new HashMap<>();
 			
 			String contents = "<BR> 안녕하세요." +
 					"<BR> [" + guarInformation.get("PR_BUYER_DEPT_NM") + "]" + guarInformation.get("CONT_USER_NM") + " 님" +
 					"<BR> " +
 					"<BR> 아래와 같이 협력사에서 보증취소를 요청 하였습니다 <br>" +
 					"<BR> 협력사 : [" + guarInformation.get("VENDOR_NM") + "]" +
 					"<BR> 계약번호 : [" + guarInformation.get("CONT_NUM") + "]" +
 					"<BR> 계약명 : ["+ guarInformation.get("CONT_DESC") + "]" +
 					"<BR> 보증구분 : ["+ guarInformation.get("GUAR_TYPE") + "]" +
 					"<BR> 증권번호 : ["+ guarInformation.get("GUAR_NUM") + "]" +
 					"<BR> " +
 					"<BR> 전자구매시스템에 <a href='" + linkUrl + "' target='newP'>로그인</a> 하시어, 세부내용을 확인 해주십시오." +
 					"<BR> " +
 					"<BR> 감사합니다.";

 			mailMap.put("SUBJECT", subject);
 			mailMap.put("CONTENTS", contents);
 			mailMap.put("REF_MODULE_CD", "MCONT03");
 			mailMap.put("RECV_USER_ID", guarInformation.get("CONT_USER_ID"));
 			everMailService.SendMail(mailMap);
    	} catch (Exception ex) {
            getLog().error("보증취소요청 전송 후 메일 발송 오류 : " + ex.getMessage(), ex);
        }

        rtnMap.put("rtnMsg", msg.getMessage("0061"));

        return rtnMap;
    }
    
    //public void sendGuarCancel(Map<String, Object> guarData) throws Exception {
    //	sctr0010_mapper.setGuarDelete(guarData);
    //}


    public List<Map<String, Object>> sctr0011_doSearchECCM(Map<String, String> formData) {
        return sctr0010_mapper.sctr0011_doSearchECCM(formData);
    }

	public Map<String, String> sctr0010_doPdfValid(Map<String, String> param) {
    	return sctr0010_mapper.sctr0010_doPdfValid(param);
	}

	public void sctr0011_doUpdateVendorFile(Map<String, String> param) {
    	sctr0010_mapper.sctr0011_doUpdateVendorFile(param);
	}
	
	/**
	 * 전자계약 : 서울보증전송 보증번호 발행 전 취소
	 * @param guarData
	 * @throws Exception
	 */
    public String sendContSGGuarCancel(Map<String, Object> guarData) throws Exception {
    	
		/*  GUAR_TYPE : ADV	  선급보증 ,CONT 계약보증	,WARR 하자보증	,DIF	 차액보증 */
    	// 1. [필수] 전문송신기관(송신자ID : A+피보험자사업자번호+00 (총 13자리))
		String head_mesg_send  = "";
        if(PropertiesManager.getBoolean("eversrm.system.developmentFlag")) {// 개발서버 : 농협정보시스템
    		head_mesg_send="A120870175500";
        } else {
    		head_mesg_send="A120870175500";
        }
        guarData.put("HEAD_MESG_SEND", head_mesg_send);
        
        // 서울보증 전송전문 가져오기
    	//Map<String, String> guarInfo = sctr0010_mapper.getGuarDataEcct(guarData);
    	Map<String, String> guarInfo = sctr0010_mapper.getGuarCancelDataEcct(guarData);
    	System.err.println("==============================guarInfo=============="+guarInfo);
    	
    	// 계약보증번호 채번
    	String guarReqNum = "";
    	if( StringUtils.isEmpty(guarInfo.get("GUAR_REQ_NUM")) ) {
    		guarReqNum = docNumService.getDocNumber(PropertiesManager.getString("eversrm.default.company.code"), "GU");
    	}
    	else {
    		guarReqNum = String.valueOf(guarData.get("GUAR_REQ_NUM"));
    	}
    	guarData.put("GUAR_REQ_NUM", guarReqNum);
    	
    	// 서울보증증권 전송 세팅정보
        String sendinfo_conf  = PropertiesManager.getString("sendinfo_conf", "");
        // 서울보증증권 템플릿 경로
        String templates_path = PropertiesManager.getString("templates_path", "");

		/**
		 * 문서코드(문서명) -  BIDINF(입찰정보통보서), CONINF(계약정보통보서), FLRINF(하자정보통보서),
		 *                 PREINF(선금정보통보서), PAYINF(지급정보통보서), LIVINF(생활안정통보서), SALINF(상품판매통보서)
		 * 상품(보험종류)구분코드- 001:입찰, 002:계약, 003:하자, 004:선금,
		 */
        /** HEADER */
        String headMesg = "";
        String headMesgType = "";

        /*	[필수]	 문서코드	*/
        if ("CONT".equals(guarData.get("GUAR_TYPE"))) {		//계약보증
        	headMesg = "최종응답서";
        	headMesgType = "RBONGU";
        }
        else if ("ADV".equals(guarData.get("GUAR_TYPE"))) {	//선급보증
        	headMesg = "최종응답서";
        	headMesgType = "RBONGU";
        }
        else if ("WARR".equals(guarData.get("GUAR_TYPE"))) {//하자보증
        	headMesg = "최종응답서";
        	headMesgType = "RBONGU";
        }
        
        // 2. [필수] 수신처ID (z120811300200 : 서울보증보험 13자리 고정값)
    	//String headMesgRecv    = PropertiesManager.getString("eversrm.head_mesg_recv");
		String head_mesg_recv  = "z120811300200";						/*	[필수]	 전문수신기관	*/
		String head_func_code  = "53";								/*	[필수]	 문서기능 (9 : 원본, 1 : 취소, 53 : 테스트)	*/
		String head_mesg_type  = headMesgType;						/*	[필수]	 문서코드 (CONINF : 계약정보통보서, FLRINF : 하자정보통보서, PREINF : 선금정보통보서)	*/
		String head_mesg_name  = headMesg;							/*	[필수]	 문서명	*/
		String head_mesg_vers  = "1.0";								/*	[선택]	 전자문서버전	*/
		
		String head_docu_numb  = guarInfo.get("HEAD_DOCU_NUMB");	/*	[필수]	 문서번호	*/
		String head_mang_numb  = guarInfo.get("HEAD_MANG_NUMB");	/*	[필수]	 문서관리번호 (피보험자측 계약번호(차수포함) : CONT_NUM+CONT_CNT+'_'+GUAR_REQ_NUM)	*/
		String head_refr_numb  = guarInfo.get("HEAD_REFR_NUMB");	/*	[필수]	 참조번호 (피보험자측 계약번호(차수포함) : CONT_NUM+CONT_CNT+'_'+GUAR_REQ_NUM)	*/

		String head_titl_name  = headMesg;							/*	[필수]	문서개요(=문서명과 동일)	*/
		String head_orga_code  = "NHI";   							/*  [필수]   연계기관코드   */

		head_docu_numb = head_docu_numb.replaceAll("XXXXXXXXXX", guarReqNum);		/* 문서번호 */
		head_mang_numb = head_mang_numb.replaceAll("XXXXXXXXXX", guarReqNum);		/* 문서관리번호 */
		head_refr_numb = head_refr_numb.replaceAll("XXXXXXXXXX", guarReqNum);		/* 참조번호 */

		/** BODY */
		/* 문서정보 Document.Info.Details */
		String	docu_numb_text  = guarInfo.get("DOCU_NUMB_TEXT"); 					/*	[필수]	문서관리번호 (GUAR_REQ_NUM+''+'00') */
		docu_numb_text = docu_numb_text.replaceAll("XXXXXXXXXX", guarReqNum);		/* 문서관리번호 */
		String	docu_kind_code  = guarInfo.get("DOCU_KIND_CODE"); 					/*	[필수]	" 보험종목구분(001:입찰,002:계약,003:하자,004:선금,006:지급)"	*/
		String	docu_issu_date  = guarInfo.get("DOCU_ISSU_DATE"); 					/*	[선택]	작성일자	*/
		String	docu_user_type  = "NHI";  											/*	[필수]	연계기관코드*/
		
		/* 주요계약정보 MainContract.Info.Details */
		String	cont_numb_text  = guarInfo.get("CONT_NUMB_TEXT");					/*	[필수]	계약번호	*/
		cont_numb_text = cont_numb_text.replaceAll("XXXXXXXXXX", guarReqNum);

		String	cont_main_name  = guarInfo.get("CONT_MAIN_NAME");					/*	[필수]	계약명(특수문자 제외)	*/
		String	cont_curc_code  = guarInfo.get("CONT_CURC_CODE");					/*	[필수]	 계약금액(원화)/통화코드(WON)	*/
		String	cont_main_amnt  = String.valueOf(guarInfo.get("CONT_MAIN_AMNT"));	/*	[필수]	 계약금액(원화)/계약금액	*/

		/* 채권자 정보 Creditor.Info.Details */
		String	cred_bond_hold  = guarInfo.get("CRED_BOND_HOLD");					/*	[필수]	 채권자명	*/
		
		/* 계약자 정보 Applier.Info.Details */
		String	appl_orga_name  = guarInfo.get("APPL_ORGA_NAME");					/*	[필수]	 기관명	*/
		String	appl_orps_divs  = guarInfo.get("APPL_ORPS_DIVS");					/*	[필수]	 구분(O:사업자번호 P:주민등록번호)	*/
		String	appl_orps_iden  = guarInfo.get("APPL_ORPS_IDEN");					/*	[필수]	 사업자/주민번호	*/
		//String	appl_orps_iden  = "2128300381";										/*	[필수]	 사업자/주민번호	*/
		String	appl_ownr_name  = guarInfo.get("APPL_OWNR_NAME");					/*	[필수]	 성명(대표자명)	*/
		
		/* 응답 정보 Response.Info.Details */
		String	resp_type_code  = "DD";												/*	[필수]	 응답코드	*/
		String	resp_type_name  = "취소";												/*	[필수]	 응답코드명	*/
		String	resp_mesg_text  = "보증신청내역취소";									/*	[필수]	 응답내용	*/
		
		String xml_str = null;

		// 매핑 정보 파일, XML 탬플릿 정보 파일
		DataToXml datatoxml = new DataToXml(templates_path,headMesgType);
		if( datatoxml.getErrorCode() != 0 ) {
			System.out.println(datatoxml.getErrorMsg());
			return msg.getMessage("서울보증 전송 전문 xml 생성 실패");
		}
		
		/* HEADER */
		try{
			if(
				/* Begin of Header */
					datatoxml.setData("head_mesg_send", head_mesg_send)
				&&	datatoxml.setData("head_mesg_recv", head_mesg_recv)
				&&	datatoxml.setData("head_func_code", head_func_code)
				&&	datatoxml.setData("head_mesg_type", head_mesg_type)
				&&	datatoxml.setData("head_mesg_name", head_mesg_name)
				&&	datatoxml.setData("head_mesg_vers", head_mesg_vers)
				&&	datatoxml.setData("head_docu_numb", head_docu_numb)
				&&	datatoxml.setData("head_mang_numb", head_mang_numb)
				&&	datatoxml.setData("head_refr_numb", head_refr_numb)
				&&	datatoxml.setData("head_titl_name", head_titl_name)
				&&  datatoxml.setData("head_orga_code", head_orga_code)
				/* End of Header */

				/* Begin of 문서정보 */
				&&  datatoxml.setData("docu_numb_text", docu_numb_text)
				&&  datatoxml.setData("docu_kind_code", docu_kind_code)
				&&  datatoxml.setData("docu_issu_date", docu_issu_date)
				&&  datatoxml.setData("docu_user_type", docu_user_type)
				/* End of 문서정보 */

				/* Begin of 주요계약정보 */
				&&  datatoxml.setData("cont_numb_text", cont_numb_text)
				&&  datatoxml.setData("cont_main_name", cont_main_name)
				&&  datatoxml.setData("cont_curc_code", cont_curc_code)
				&&  datatoxml.setData("cont_main_amnt", cont_main_amnt)
				/* End of 주요계약정보 */

				/* Begin of 채권자 정보 */
				&&  datatoxml.setData("cred_bond_hold", cred_bond_hold)
				/* End of 채권자 정보 */

				/* Begin of 계약자 정보 */
				&&  datatoxml.setData("appl_orga_name", appl_orga_name)
				&&  datatoxml.setData("appl_orps_divs", appl_orps_divs)
				&&  datatoxml.setData("appl_orps_iden", appl_orps_iden)
				&&  datatoxml.setData("appl_ownr_name", appl_ownr_name)
				/* End of 계약자 정보 */
				
				/* Begin of 응답 정보 */
				&&  datatoxml.setData("resp_type_code", resp_type_code)
				&&  datatoxml.setData("resp_type_name", resp_type_name)
				&&  datatoxml.setData("resp_mesg_text", resp_mesg_text)
				/* End of 응답 정보 */
			)
			{
				xml_str = datatoxml.getxmlData();
		        if(PropertiesManager.getBoolean("eversrm.system.developmentFlag")) {// 개발서버에서는
			        if(PropertiesManager.getBoolean("eversrm.system.localserver")) {// 개발서버에서는 고정된 값으로.
						datatoxml.writexmlFile("C:/mmmm.xml");
			        } else {
						datatoxml.writexmlFile("/svc/nhepro/TempXml/mmmm.xml");
			        }
		        } else {
		        	datatoxml.writexmlFile("C:/mmmm.xml");
		        }
				System.err.println("===xml start=======================================================================================================");
				System.err.println(xml_str);
				System.err.println("===xml end=======================================================================================================");
			} else {
				System.out.println(datatoxml.getErrorMsg());
				throw new Exception(datatoxml.getErrorMsg());
			}
		}
		catch(Exception e){
			logger.error(e.getMessage());
			throw e;
		}
		/////////////////////// xml문서 생성 end ////////////////////////

		if(xml_str == null){
			System.out.println("서울보증 전송 전문 xml 생성 실패");
			return msg.getMessage("서울보증 전송 전문 xml 생성 실패");
		}
		
		// 개발 테스트가 아닌 경우
		try {
	        if( !PropertiesManager.getBoolean("eversrm.system.localserver") ) {
				////////////////////// xml 문서 송신 start ///////////////////////
				SGIxLinker xLinker =  new SGIxLinker(sendinfo_conf, "send_jsp", true);
				xLinker.setXmlEncoding("UTF-8");
				
		    	boolean isOK = xLinker.doSendProcess(xml_str, null);
		    	// 전송완료처리
		    	System.err.println("=============================================================================isOK="+isOK);
				if(!isOK) {
					//System.out.println("SGIxLinker 에러메시지 : " + xLinker.getErrorMsg());
					logger.debug("SGIxLinker 에러메시지:" + xLinker.getErrorMsg());
					throw new Exception("=="+xLinker.getErrorMsg()+"==");
				}
	
				//***************************************
				// xml 응답서 문서 정보를 XmltoData로 추출하여 상태값 DB에 저장
				// 매핑 정보 파일, XML 탬플릿 정보 파일
				String recvXml = xLinker.getRecvXmlData();
				XmlToData xmlToData = null;
				try{
					System.err.println("==recvXmlrecvXmlrecvXmlrecvXmlrecvXmlrecvXmlrecvXmlrecvXmlrecvXmlrecvXmlrecvXml==========================================================recvXml==recvXml="+recvXml);
					xmlToData = new XmlToData(xLinker.getTempPath() , "RESPONSE", recvXml);
					if( xmlToData.getErrorCode() != 0 ) {
						//System.out.println(xmlToData.getErrorMsg());
						logger.debug(xmlToData.getErrorMsg());
						throw new Exception("=="+xmlToData.getErrorMsg()+"==");
					}
				}
				catch(Exception e){
					logger.error(e.getMessage());
					throw new Exception("=="+xmlToData.getErrorMsg()+"==");
				}
	
				String res_cont_num = xmlToData.getData("res_cont_num");
				//String res_docu_num = xmlToData.getData("res_docu_num");
				String respTypeCode = xmlToData.getData("res_info_code");
				String respTypeName = xmlToData.getData("res_info_typename");
				String respMesgText = xmlToData.getData("res_info_result");
				System.out.println("계약번호 = "+res_cont_num);
				System.out.println("응답코드 = "+respTypeCode);
				System.out.println("응답코드명 = "+respTypeName);
				System.out.println("응답메시지 = "+respMesgText);
				
				if( respTypeCode == null || !"SA".equals(respTypeCode) ) {
					throw new Exception("계약번호 = "+res_cont_num
							+"\n응답코드 = "+respTypeCode
							+"\n응답코드명 = "+respTypeName
							+"\n응답메시지 = "+respMesgText
					);
				}
		        
				sctr0010_mapper.upsGuarCancelRecevieEcpc(guarData);
	        }
		}
    	catch (Exception e) {
    		logger.error(e.getMessage());
			throw e;
		}
    	
    	return msg.getMessage("0001");
    }
    
    /**
	 * 전자계약 : 서울보증전송 보증번호 발행 후 취소
	 * @param guarData
	 * @throws Exception
	 */
    public String sendContSGGuarNumCancel(Map<String, Object> guarData) throws Exception {
    	
		/*  GUAR_TYPE : ADV	  선급보증 ,CONT 계약보증	,WARR 하자보증	,DIF	 차액보증 */
    	// 1. [필수] 전문송신기관(송신자ID : A+피보험자사업자번호+00 (총 13자리))
    	
    	String guarNum = "";
		String head_mesg_send  = "";
        if(PropertiesManager.getBoolean("eversrm.system.developmentFlag")) {// 개발서버 : 농협정보시스템
    		head_mesg_send="A120870175500";
        } else {
    		head_mesg_send="A120870175500";
        }
        guarData.put("HEAD_MESG_SEND", head_mesg_send);
        
        // 서울보증 전송전문 가져오기
    	//Map<String, String> guarInfo = sctr0010_mapper.getGuarDataEcct(guarData);
    	Map<String, String> guarInfo = sctr0010_mapper.getGuarCancelDataEcct(guarData);
    	System.err.println("==============================guarInfo=============="+guarInfo);
    	
    	// 계약보증번호 채번
    	String guarReqNum = "";
    	if( StringUtils.isEmpty(guarInfo.get("GUAR_REQ_NUM")) ) {
    		guarReqNum = docNumService.getDocNumber(PropertiesManager.getString("eversrm.default.company.code"), "GU");
    	}
    	else {
    		guarReqNum = String.valueOf(guarData.get("GUAR_REQ_NUM"));
    	}
    	guarData.put("GUAR_REQ_NUM", guarReqNum);
    	
    	// 서울보증증권 전송 세팅정보
        String sendinfo_conf  = PropertiesManager.getString("sendinfo_conf", "");
        // 서울보증증권 템플릿 경로
        String templates_path = PropertiesManager.getString("templates_path", "");

		/**
		 * 문서코드(문서명) -  BIDINF(입찰정보통보서), CONINF(계약정보통보서), FLRINF(하자정보통보서),
		 *                 PREINF(선금정보통보서), PAYINF(지급정보통보서), LIVINF(생활안정통보서), SALINF(상품판매통보서)
		 * 상품(보험종류)구분코드- 001:입찰, 002:계약, 003:하자, 004:선금,
		 */
        /** HEADER */
        String headMesg = "";
        String headMesgType = "";

        /*	[필수]	 문서코드	*/
        if ("CONT".equals(guarData.get("GUAR_TYPE"))) {		//계약보증
        	headMesg = "최종응답서";
        	headMesgType = "RBONGU";
        }
        else if ("ADV".equals(guarData.get("GUAR_TYPE"))) {	//선급보증
        	headMesg = "최종응답서";
        	headMesgType = "RBONGU";
        }
        else if ("WARR".equals(guarData.get("GUAR_TYPE"))) {//하자보증
        	headMesg = "최종응답서";
        	headMesgType = "RBONGU";
        }
        
        guarNum = guarInfo.get("GUAR_NUM");
        // 2. [필수] 수신처ID (z120811300200 : 서울보증보험 13자리 고정값)
    	//String headMesgRecv    = PropertiesManager.getString("eversrm.head_mesg_recv");
		String head_mesg_recv  = "z120811300200";						/*	[필수]	 전문수신기관	*/
		String head_func_code  = "53";								/*	[필수]	 문서기능 (9 : 원본, 1 : 취소, 53 : 테스트)	*/
		String head_mesg_type  = headMesgType;						/*	[필수]	 문서코드 (CONINF : 계약정보통보서, FLRINF : 하자정보통보서, PREINF : 선금정보통보서)	*/
		String head_mesg_name  = headMesg;							/*	[필수]	 문서명	*/
		String head_mesg_vers  = "1.0";								/*	[선택]	 전자문서버전	*/
		
		String head_docu_numb  = guarInfo.get("HEAD_DOCU_NUMB");	/*	[필수]	 문서번호	*/
		String head_mang_numb  = guarInfo.get("HEAD_MANG_NUMB");	/*	[필수]	 문서관리번호 (피보험자측 계약번호(차수포함) : CONT_NUM+CONT_CNT+'_'+GUAR_REQ_NUM)	*/
		String head_refr_numb  = guarInfo.get("HEAD_REFR_NUMB");	/*	[필수]	 참조번호 (피보험자측 계약번호(차수포함) : CONT_NUM+CONT_CNT+'_'+GUAR_REQ_NUM)	*/

		String head_titl_name  = headMesg;							/*	[필수]	문서개요(=문서명과 동일)	*/
		String head_orga_code  = "NHI";   							/*  [필수]   연계기관코드   */

		head_docu_numb = head_docu_numb.replaceAll("XXXXXXXXXX", guarNum);		/* 문서번호 */
		head_mang_numb = head_mang_numb.replaceAll("XXXXXXXXXX", guarNum);		/* 문서관리번호 */
		head_refr_numb = head_refr_numb.replaceAll("XXXXXXXXXX", guarNum);		/* 참조번호 */

		/** BODY */
		/* 문서정보 Document.Info.Details */
		String	docu_numb_text  = guarInfo.get("DOCU_NUMB_TEXT"); 					/*	[필수]	문서관리번호 (GUAR_REQ_NUM+''+'00') */
		docu_numb_text = docu_numb_text.replaceAll("XXXXXXXXXX", guarNum);		/* 문서관리번호 */
		String	docu_kind_code  = guarInfo.get("DOCU_KIND_CODE"); 					/*	[필수]	" 보험종목구분(001:입찰,002:계약,003:하자,004:선금,006:지급)"	*/
		String	docu_issu_date  = guarInfo.get("DOCU_ISSU_DATE"); 					/*	[선택]	작성일자	*/
		String	docu_user_type  = "NHI";  											/*	[필수]	연계기관코드*/
		
		/* 주요계약정보 MainContract.Info.Details */
		String	cont_numb_text  = guarInfo.get("CONT_NUMB_TEXT");					/*	[필수]	계약번호	*/
		cont_numb_text = cont_numb_text.replaceAll("XXXXXXXXXX", guarReqNum);
		
		
		System.out.println("head_docu_numb ====> "+ head_docu_numb);
		System.out.println("head_mang_numb ====> "+ head_mang_numb);
		System.out.println("head_refr_numb ====> "+ head_refr_numb);
		System.out.println("docu_numb_text ====> "+ docu_numb_text);
		System.out.println("cont_numb_text ====> "+ cont_numb_text);
		
		String	cont_main_name  = guarInfo.get("CONT_MAIN_NAME");					/*	[필수]	계약명(특수문자 제외)	*/
		String	cont_curc_code  = guarInfo.get("CONT_CURC_CODE");					/*	[필수]	 계약금액(원화)/통화코드(WON)	*/
		String	cont_main_amnt  = String.valueOf(guarInfo.get("CONT_MAIN_AMNT"));	/*	[필수]	 계약금액(원화)/계약금액	*/

		/* 채권자 정보 Creditor.Info.Details */
		String	cred_bond_hold  = guarInfo.get("CRED_BOND_HOLD");					/*	[필수]	 채권자명	*/
		
		/* 계약자 정보 Applier.Info.Details */
		String	appl_orga_name  = guarInfo.get("APPL_ORGA_NAME");					/*	[필수]	 기관명	*/
		String	appl_orps_divs  = guarInfo.get("APPL_ORPS_DIVS");					/*	[필수]	 구분(O:사업자번호 P:주민등록번호)	*/
		String	appl_orps_iden  = guarInfo.get("APPL_ORPS_IDEN");	 				/*	[필수]	 사업자/주민번호	*/
		//String	appl_orps_iden  = "2128300381";									/*	[필수]	 테스트용 사업자번호	*/
		String	appl_ownr_name  = guarInfo.get("APPL_OWNR_NAME");					/*	[필수]	 성명(대표자명)	*/
		
		/* 응답 정보 Response.Info.Details */
		String	resp_type_code  = "DE";												/*	[필수]	 응답코드	*/
		String	resp_type_name  = "파기";												/*	[필수]	 응답코드명	*/
		String	resp_mesg_text  = "보증증권취소";										/*	[필수]	 응답내용	*/
		
		String xml_str = null;

		// 매핑 정보 파일, XML 탬플릿 정보 파일
		DataToXml datatoxml = new DataToXml(templates_path,headMesgType);
		if( datatoxml.getErrorCode() != 0 ) {
			System.out.println(datatoxml.getErrorMsg());
			return msg.getMessage("서울보증 전송 전문 xml 생성 실패");
		}
		
		/* HEADER */
		try{
			if(
				/* Begin of Header */
					datatoxml.setData("head_mesg_send", head_mesg_send)
				&&	datatoxml.setData("head_mesg_recv", head_mesg_recv)
				&&	datatoxml.setData("head_func_code", head_func_code)
				&&	datatoxml.setData("head_mesg_type", head_mesg_type)
				&&	datatoxml.setData("head_mesg_name", head_mesg_name)
				&&	datatoxml.setData("head_mesg_vers", head_mesg_vers)
				&&	datatoxml.setData("head_docu_numb", head_docu_numb)
				&&	datatoxml.setData("head_mang_numb", head_mang_numb)
				&&	datatoxml.setData("head_refr_numb", head_refr_numb)
				&&	datatoxml.setData("head_titl_name", head_titl_name)
				&&  datatoxml.setData("head_orga_code", head_orga_code)
				/* End of Header */

				/* Begin of 문서정보 */
				&&  datatoxml.setData("docu_numb_text", docu_numb_text)
				&&  datatoxml.setData("docu_kind_code", docu_kind_code)
				&&  datatoxml.setData("docu_issu_date", docu_issu_date)
				&&  datatoxml.setData("docu_user_type", docu_user_type)
				/* End of 문서정보 */

				/* Begin of 주요계약정보 */
				&&  datatoxml.setData("cont_numb_text", cont_numb_text)
				&&  datatoxml.setData("cont_main_name", cont_main_name)
				&&  datatoxml.setData("cont_curc_code", cont_curc_code)
				&&  datatoxml.setData("cont_main_amnt", cont_main_amnt)
				/* End of 주요계약정보 */

				/* Begin of 채권자 정보 */
				&&  datatoxml.setData("cred_bond_hold", cred_bond_hold)
				/* End of 채권자 정보 */

				/* Begin of 계약자 정보 */
				&&  datatoxml.setData("appl_orga_name", appl_orga_name)
				&&  datatoxml.setData("appl_orps_divs", appl_orps_divs)
				&&  datatoxml.setData("appl_orps_iden", appl_orps_iden)
				&&  datatoxml.setData("appl_ownr_name", appl_ownr_name)
				/* End of 계약자 정보 */
				
				/* Begin of 응답 정보 */
				&&  datatoxml.setData("resp_type_code", resp_type_code)
				&&  datatoxml.setData("resp_type_name", resp_type_name)
				&&  datatoxml.setData("resp_mesg_text", resp_mesg_text)
				/* End of 응답 정보 */
			)
			{
				xml_str = datatoxml.getxmlData();
		        if(PropertiesManager.getBoolean("eversrm.system.developmentFlag")) {// 개발서버에서는
			        if(PropertiesManager.getBoolean("eversrm.system.localserver")) {// 개발서버에서는 고정된 값으로.
						datatoxml.writexmlFile("C:/mmmm.xml");
			        } else {
						datatoxml.writexmlFile("/svc/nhepro/TempXml/mmmm.xml");
			        }
		        } else {
		        	datatoxml.writexmlFile("C:/mmmm.xml");
		        }
				System.err.println("===xml start=======================================================================================================");
				System.err.println(xml_str);
				System.err.println("===xml end=======================================================================================================");
			} else {
				System.out.println(datatoxml.getErrorMsg());
				throw new Exception(datatoxml.getErrorMsg());
			}
		}
		catch(Exception e){
			logger.error(e.getMessage());
			throw e;
		}
		/////////////////////// xml문서 생성 end ////////////////////////

		if(xml_str == null){
			System.out.println("서울보증 전송 전문 xml 생성 실패");
			return msg.getMessage("서울보증 전송 전문 xml 생성 실패");
		}
		
		// 개발 테스트가 아닌 경우
		try {
	        if( !PropertiesManager.getBoolean("eversrm.system.localserver") ) {
				////////////////////// xml 문서 송신 start ///////////////////////
				SGIxLinker xLinker =  new SGIxLinker(sendinfo_conf, "send_jsp", true);
				xLinker.setXmlEncoding("UTF-8");
				
		    	boolean isOK = xLinker.doSendProcess(xml_str, null);
		    	// 전송완료처리
		    	System.err.println("=============================================================================isOK="+isOK);
				if(!isOK) {
					//System.out.println("SGIxLinker 에러메시지 : " + xLinker.getErrorMsg());
					logger.debug("SGIxLinker 에러메시지:" + xLinker.getErrorMsg());
					throw new Exception("=="+xLinker.getErrorMsg()+"==");
				}
	
				//***************************************
				// xml 응답서 문서 정보를 XmltoData로 추출하여 상태값 DB에 저장
				// 매핑 정보 파일, XML 탬플릿 정보 파일
				String recvXml = xLinker.getRecvXmlData();
				XmlToData xmlToData = null;
				try{
					System.err.println("==recvXmlrecvXmlrecvXmlrecvXmlrecvXmlrecvXmlrecvXmlrecvXmlrecvXmlrecvXmlrecvXml==========================================================recvXml==recvXml="+recvXml);
					xmlToData = new XmlToData(xLinker.getTempPath() , "RESPONSE", recvXml);
					if( xmlToData.getErrorCode() != 0 ) {
						//System.out.println(xmlToData.getErrorMsg());
						logger.debug(xmlToData.getErrorMsg());
						throw new Exception("=="+xmlToData.getErrorMsg()+"==");
					}
				}
				catch(Exception e){
					logger.error(e.getMessage());
					throw new Exception("=="+xmlToData.getErrorMsg()+"==");
				}
	
				String res_cont_num = xmlToData.getData("res_cont_num");
				//String res_docu_num = xmlToData.getData("res_docu_num");
				String respTypeCode = xmlToData.getData("res_info_code");
				String respTypeName = xmlToData.getData("res_info_typename");
				String respMesgText = xmlToData.getData("res_info_result");
				System.out.println("계약번호 = "+res_cont_num);
				System.out.println("응답코드 = "+respTypeCode);
				System.out.println("응답코드명 = "+respTypeName);
				System.out.println("응답메시지 = "+respMesgText);
				
				if( respTypeCode == null || !"SA".equals(respTypeCode) ) {
					throw new Exception("계약번호 = "+res_cont_num
							+"\n응답코드 = "+respTypeCode
							+"\n응답코드명 = "+respTypeName
							+"\n응답메시지 = "+respMesgText
					);
				}
		        
				sctr0010_mapper.upsGuarCancelConfirmRecevieEcpc(guarData);
	        }
		}
    	catch (Exception e) {
    		logger.error(e.getMessage());
			throw e;
		}
		
		// 협력업체 보증 취소요청 승인 메일발송
 		try {
 			sendConfirmMail(guarData);
 		} catch (Exception ex) {
            getLog().error("협력업체 보증 취소요청 승인 메일 발송 오류 : " + ex.getMessage(), ex);
        }
    	
    	return msg.getMessage("0001");
    }
    
    public void sendConfirmMail(Map<String, Object> gridData) throws Exception {
        
        String linkUrl = PropertiesManager.getString("eversrm.urls.maintain.real") ;
        
        // 메일 발송정보 가져오기
        List<Map<String, String>> mailList = sctr0010_mapper.sctr0010_getSgGuarInformation(gridData);
        for(Map<String, String> data : mailList) {
        	try {
	 			String subject  = "[전자구매시스템] 협력사 [" + data.get("VENDOR_NM") + "]에서 요청하신 보증취소요청 건에 대해 [승인] 하였습니다";
	 			
	 			Map<String,String> mailMap = new HashMap<>();
	 			
	 			String contents = "<BR> 안녕하세요." +
	 					"<BR> [" + data.get("VENDOR_NM") + "] " + data.get("USER_NM") + " 님" +
	 					"<BR> " +
	 					"<BR> 아래와 같이 고객사에서 보증취소요청 건에 대해 [승인] 하였습니다.<br>" +
	 					"<BR> 계약명 : ["+ data.get("CONT_DESC") + "]" +
	 					"<BR> 보증구분 : ["+ data.get("GUAR_TYPE") + "]" +
	 					"<BR> 처리일 : ["+ data.get("SYS_DATE") + "]" +
	 					"<BR> 처리결과 : [승인]" +
	 					"<BR> " +
	 					"<BR> 전자구매시스템에 <a href='" + linkUrl + "' target='newP'>로그인</a> 하시어, 세부내용을 확인 해주십시오." +
	 					"<BR> " +
	 					"<BR> 감사합니다.";
	
	 			mailMap.put("SUBJECT", subject);
	 			mailMap.put("CONTENTS", contents);
	 			mailMap.put("REF_MODULE_CD", "MCONT03");
	 			mailMap.put("RECV_USER_ID", data.get("USER_ID"));
	 			everMailService.SendMail(mailMap);
        	} catch (Exception ex) {
                getLog().error("보증취소요청 승인 전송 후 메일 발송 오류 : " + ex.getMessage(), ex);
          }
       }
 	}
    
    public void sctr0010_doGuarSave(List<Map<String, Object>> gridData) {
		for(Map<String, Object> grid : gridData) {
			sctr0010_mapper.sctr0010_doGuarSave(grid);
		}
	}
    
    /**
     * 전자서명 데이터 저장 및 계약서 상태 변경
     * @param req
     * @param resp
     */
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public void docFee_doSaveSignedData(EverHttpRequest req, EverHttpResponse resp) throws Exception {
//임시		
System.out.println("docFee_doSaveSignedData param=>"+req.getParamDataMap().toString());
		String localServerFlag = EverString.nullToEmptyString(req.getParameter("localServerFlag"));
		String sSignData = EverString.nullToEmptyString(req.getParameter("signedData"));
		sSignData = URLDecoder.decode(sSignData, "utf-8");
		String vidRandom = EverString.nullToEmptyString(req.getParameter("vidRandom"));
		vidRandom = URLDecoder.decode(vidRandom, "utf-8");
		String idn = EverString.nullToEmptyString(req.getParameter("idn"));
		String useCard = EverString.nullToEmptyString(req.getParameter("useCard"));

		String UUID = EverString.nullToEmptyString(req.getParameter("UUID"));
		String UUID_SQ = EverString.nullToEmptyString(req.getParameter("UUID_SQ"));
		String VENDOR_CD = EverString.nullToEmptyString(req.getParameter("VENDOR_CD"));		
		
		if(localServerFlag.equals("N")) {
			Map<String, String> rtnMap = EverCert.doCheckCert(sSignData, vidRandom, idn, useCard);
			// 서명값 검증 실패
			if (rtnMap.get("certRtnCd").equals("-1")) {
				throw new Exception(rtnMap.get("certRtnMsg"));
			}
		}
		
		//대상확인 함수 추가
		Map<String, String> targetFileInfo = fileAttachService.getTagrgetFile(UUID, UUID_SQ);
		if(targetFileInfo != null && targetFileInfo.size() != 0) {
			targetFileInfo.put("EPRO_WRS_DS", "70");		/* 상품코드 */	// epro_wrs_ds [상품코드] - 10 : RFI, 20 : 입찰, 30 : 일반입찰계약, 40 : 일반수의계약, 50 : BtoC계약, 60 : 위임계약, 70 : 문서보관, 80 : SMS, 90 : LMS, 100 : 문서생성
			targetFileInfo.put("EPRO_RATE_DSC", "01");	/* 단가코드 */	// epro_rate_dsc [단가코드] - 01 : 최초, 02 : 재입찰/재계약/재요청
			targetFileInfo.put("CONT_TBL_ID", "STOCATCH");/* 계약테이블ID */
			targetFileInfo.put("tmp", ""); 				// myBatis 버그 해결을 위한 무의미한, 유니크한 값. 단, EPRO_WRS_DS = '30' 또는 '40'일 때 반드시 계약금액을 넣어야 함.
			
			String resultMsgSub = approvalService.putBkCost(targetFileInfo);
			if( !targetFileInfo.get("RESULT_STR").equals("OK") ) {
				throw new Exception("수수료 부과중 문제가 발생 했습니다.(관리자에게 문의 바랍니다.)");
			} else {
				targetFileInfo.put("FEE_ETC", "0");	/* 0:정상, 1:수수료처리실패, 2:실물파일없음 */
				fileAttachService.upsComplete(targetFileInfo);				
			}			
						
		} else {
			throw new Exception("결제할 대상이 없습니다.");
		}		
		
		// 전자서명 데이터 생성
		Map<String, String> formData = req.getFormData();
		formData.put("VID_RANDOM", vidRandom);
		formData.put("SIGN_VALUE", sSignData);
		formData.put("UUID", UUID);
		formData.put("UUID_SQ", UUID_SQ);
		formData.put("VENDOR_CD", VENDOR_CD);
		sctr0010_mapper.doInsertDFSignedData(formData); // 전자서명 데이터 저장
		
        resp.setResponseMessage(messageService.getMessageByScreenId("SECM_030", "0001"));
    }    
}