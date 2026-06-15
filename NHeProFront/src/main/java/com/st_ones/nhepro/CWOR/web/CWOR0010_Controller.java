package com.st_ones.nhepro.CWOR.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.st_ones.common.combo.service.CommonComboService;
import com.st_ones.common.util.clazz.EverConverter;
import com.st_ones.common.util.clazz.EverDate;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.util.EverString;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.eversrm.eApproval.eApprovalModule.service.BAPM_Service;
import com.st_ones.eversrm.eApproval.service.EApprovalService;
import com.st_ones.nhepro.CWOR.service.CWOR0010_Service;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : CWOR0010_Controller.java
 * @date 2020. 03. 04.
 * @version 1.0
 */

@Controller
@RequestMapping(value = "/nhepro/CWOR")
public class CWOR0010_Controller extends BaseController {

    private Logger logger = LoggerFactory.getLogger(BAPM_Service.class);

    @Autowired private CommonComboService commonComboService;

    @Autowired private CWOR0010_Service cwor_Service;

    @Autowired private EApprovalService eApprovalService;

    /**
     * 화면명 : 결재함
     * 처리내용 : 로그인한 사용자에게 상신된 결제문서들을 조회/승인/반려할 수 있는 화면.
     * 경로 : 고객사 > 전자결재 > 전자결재 > 결재함
     */
	@RequestMapping(value="/CWOR0010/view")
	public String cwor0010_view(EverHttpRequest req) throws Exception {

        String localServerFlag = "N";
        if(PropertiesManager.getBoolean("eversrm.system.localserver") || PropertiesManager.getBoolean("eversrm.system.developmentFlag")) {
            localServerFlag = "Y";
        }

        // ipoid : 법인용 공인인증기관 공인인증서, iboid : 법인용 블럭체인 사설인증서, pboid : 개인용 블럭체인 사설인증서
        req.setAttribute("certOidfilter", PropertiesManager.getString("magicline.certverify.pboid"));
        req.setAttribute("localServerFlag", localServerFlag);

		req.setAttribute("fromDate", EverDate.addDateMonth(EverDate.getDate(), -1));
		req.setAttribute("toDate", EverDate.getDate());
		req.setAttribute("loginStatus", "P");
		req.setAttribute("form", req.getParamDataMap());
		return "/nhepro/CWOR/CWOR0010";
	}

	@RequestMapping(value = "/cwor0010_doSearch")
	public void cwor0010_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
		resp.setGridObject("grid", cwor_Service.cwor0010_doSearch(req.getFormData()));
	}

	@RequestMapping(value = "/cwor0010_doApproval")
	public void cwor0010_doApproval(EverHttpRequest req, EverHttpResponse resp) throws Exception {

	    List<Map<String, Object>> gridDatas = req.getGridData("grid");
	    String rtnMsg = cwor_Service.cwor0010_doApproval(gridDatas);

		resp.setResponseMessage(rtnMsg);
	}

    /**
     * 화면명 : 결재요청상세
     * 처리내용 : 선택한 결제요청문서의 상세 정보를 조회하는 화면.
     * 경로 : Popup
     */
    @RequestMapping(value = "/CWOR0011/view")
    public String cwor0011_view(EverHttpRequest req) throws Exception {

        Map<String, String> param = new HashMap<String, String>();
        
        param.put("BUYER_CD", EverString.nullToEmptyString(req.getParameter("buyerCd")));
        param.put("APP_DOC_NUM", EverString.nullToEmptyString(req.getParameter("appDocNum")));
        param.put("APP_DOC_CNT", EverString.nullToEmptyString(req.getParameter("appDocCnt")));
        param.put("DOC_TYPE", EverString.nullToEmptyString(req.getParameter("docType")));
        
        // 2021.07.27 감사화면에서 결재화면 Open시
        param.put("AUTH_TYPE", EverString.nullToEmptyString(req.getParameter("authType")));
        
        Map<String, String> formData = cwor_Service.cwor0011_doSearchHeader(param);
        formData.put("MY_SIGN_STATUS", cwor_Service.selectMySignStatus(param));
        
        req.setAttribute("formData", formData);
        return "/nhepro/CWOR/CWOR0011";
    }

    @RequestMapping(value = "/cwor0011_doSearch")
    public void cwor0011_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> formData = cwor_Service.cwor0011_doSearchHeader(req.getFormData());
        setContents(resp, formData);
        resp.setFormDataObject(formData);

        List<Map<String, Object>> gridData = cwor_Service.cwor0011_doSearchDetail(req.getFormData());
        resp.setGridObject("grid", gridData);
    }

    @RequestMapping(value = "/cwor0011_documentRead")
    public void cwor0011_documentRead(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        cwor_Service.cwor0011_documentRead(req.getFormData());
    }

    @RequestMapping(value = "/cwor0011_doCancel")
    public void cwor0011_doCancel(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> formData = req.getFormData();

        Map<String, String> appParam = new HashMap<String, String>();
        appParam.put("BUYER_CD", formData.get("BUYER_CD"));
        appParam.put("APP_DOC_NUM", formData.get("APP_DOC_NUM"));
        appParam.put("APP_DOC_CNT", formData.get("APP_DOC_CNT"));
        appParam.put("DOC_TYPE", formData.get("DOC_TYPE"));
        appParam.put("SIGN_STATUS", formData.get("SIGN_STATUS"));
        String message = eApprovalService.cancelApprovalProcess(appParam);

        resp.setResponseMessage(message);
    }

    @RequestMapping(value = "/cwor0011_doApprovalOrReject")
    public void cwor0011_doApprovalOrReject(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> formData = req.getFormData();
        String signStatus = EverString.nullToEmptyString(req.getParameter("SIGN_STATUS"));
        String rtnMsg = "";

        Map<String, String> appParam = new HashMap<String, String>();
        appParam.put("BUYER_CD", formData.get("BUYER_CD"));
        appParam.put("APP_DOC_NUM", formData.get("APP_DOC_NUM"));
        appParam.put("APP_DOC_CNT", formData.get("APP_DOC_CNT"));
        appParam.put("DOC_TYPE", formData.get("DOC_TYPE"));
        appParam.put("SIGN_STATUS", signStatus);
        appParam.put("SIGN_RMK", EverString.nullToEmptyString(req.getParameter("SIGN_RMK")));
        /** 2020-07-22
         * 전자결재에서 전자서명 로직 삭제
        appParam.put("APP_CERTV", EverString.nullToEmptyString(req.getParameter("signedData")));
        appParam.put("VID_RANDOM", EverString.nullToEmptyString(req.getParameter("vidRandom")));
        */
        
        if(signStatus.equals("E")) {
        	// 2021.03.25 추가
        	// 결재 승인시 상신의견, 첨부파일 변경 가능하도록 함
        	appParam.put("CONTENTS_TEXT_NUM", formData.get("CONTENTS_TEXT_NUM"));
        	appParam.put("DOC_CONTENTS", formData.get("DOC_CONTENTS"));
        	appParam.put("ATT_FILE_NUM", formData.get("ATT_FILE_NUM"));
        	
            rtnMsg = eApprovalService.approve(appParam);
        }
        else if(signStatus.equals("R")) {
            rtnMsg = eApprovalService.reject(appParam);
        }

        resp.setResponseMessage(rtnMsg);
    }
    
    /**
	 * 화면명 : 결재요청상세
	 * 처리내용 : 선택한 결제요청문서 결재 문서유형이 "ESTM(예정가격)인 경우 해당 입찰의 예가등록 팝업을 오픈
	 * 경로 : Popup
	 */
    @RequestMapping(value = "/cwor0011_doSearchESTM")
	public void cwor0011_doSearchESTM(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	
    	String status = req.getParameter("bidStatus");
		String docNum = req.getParameter("docNum");
		String docCnt = req.getParameter("docCnt");
		
		Map<String, String> param = req.getFormData();
		param.put("BID_STATUS",  status);
		param.put("APP_DOC_NUM", docNum);
		param.put("APP_DOC_CNT", docCnt);

		List<Map<String, Object>> rtnList = cwor_Service.cwor0011_doSearchESTM(param);
	    
		String buyerCd 	  = "";
		String estmType   = "";
	    String bidNum 	  = "";
	    String bidCnt 	  = "";
	    String signStatus = "";
	    String bidStatus = "";
	    String estmUserID = "";
	    
	    for(Map<String, Object> rtnData : rtnList) {
	    	buyerCd = String.valueOf(rtnData.get("BUYER_CD"));
	    	estmType = String.valueOf(rtnData.get("ESTM_TYPE"));
            bidNum = String.valueOf(rtnData.get("BID_NUM"));
            bidCnt = String.valueOf(rtnData.get("BID_CNT"));
            signStatus = String.valueOf(rtnData.get("SIGN_STATUS"));
            bidStatus = String.valueOf(rtnData.get("BID_STATUS_LOC"));
            estmUserID = String.valueOf(rtnData.get("ESTM_USER_ID"));
        }
	    
	    resp.setParameter("buyerCd", buyerCd);
		resp.setParameter("estmType", estmType);
        resp.setParameter("bidNum", bidNum);
        resp.setParameter("bidCnt", bidCnt);
        resp.setParameter("signStatus", signStatus);
        resp.setParameter("bidStatus", bidStatus);
        resp.setParameter("estmUserID", estmUserID);
	}

    /**
     * 화면명 : 결재자리스트
     * 처리내용 : 선택한 결제요청문서의 결재자 정보를 조회하는 화면.
     * 경로 : Popup
     */
    @RequestMapping(value = "/CWOR0012/view")
    protected String cwor0012_view(EverHttpRequest req) throws Exception {

        ObjectMapper om1 = new ObjectMapper();
        req.setAttribute("approvalStatus", om1.writeValueAsString(commonComboService.getCodeCombo("M020")));
        return "/nhepro/CWOR/CWOR0012";
    }

    @RequestMapping(value = "/cwor0012_selectPathPopup")
    public void cwor0012_selectPathPopup(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.setGridObject("grid", cwor_Service.cwor0012_selectPathPopup(req.getFormData()));
    }

    /**
     * 화면명 : 업무화면 내에서 조회되는 결재자리스트
     * 처리내용 : 결재상신시 해당 업무화면 내에 include되는 결재자리스트
     * 경로 : include
     */
    @RequestMapping(value = "/CWOR0013/view")
    public String cwor0013_view(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.setParameter("APP_DOC_NUM", req.getParameter("APP_DOC_NUM"));
        resp.setParameter("APP_DOC_CNT", req.getParameter("APP_DOC_CNT"));
        return "/nhepro/CWOR/CWOR0013";
    }

    /**
     * 화면명 : 결재 승인/반려 사유
     * 처리내용 : 결재승인/반려시 사유를 적는 화면.
     * 경로 : Popup
     */
    @RequestMapping(value = "/CWOR0014/view")
    public String cwor0014_view(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        String localServerFlag = "N";

        if(PropertiesManager.getBoolean("eversrm.system.localserver") || PropertiesManager.getBoolean("eversrm.system.developmentFlag")) {
            localServerFlag = "Y";
        }

        // ipoid : 법인용 공인인증기관 공인인증서, iboid : 법인용 블럭체인 사설인증서, pboid : 개인용 블럭체인 사설인증서
        req.setAttribute("certOidfilter", PropertiesManager.getString("magicline.certverify.pboid"));
        req.setAttribute("localServerFlag", localServerFlag);
        return "/nhepro/CWOR/CWOR0014";
    }

    /**
     * 화면명 : 결재완료함
     * 처리내용 : 로그인한 사용자가 승인/반려한 결제문서들을 조회할 수 있는 화면.
     * 경로 : 고객사 > 전자결재 > 전자결재 > 결재완료함
     */
    @RequestMapping(value="/CWOR0020/view")
    public String cwor0020_view(EverHttpRequest req) throws Exception {
        req.setAttribute("fromDate", EverDate.addDateMonth(EverDate.getDate(), -1));
        req.setAttribute("toDate", EverDate.getDate());
        req.setAttribute("loginStatus", "E");
        return "/nhepro/CWOR/CWOR0020";
    }

    @RequestMapping(value = "/cwor0020_doSearch")
    public void cwor0020_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.setGridObject("grid", cwor_Service.cwor0020_doSearch(req.getFormData()));
    }
    
    /**
     * 화면명 : 부서(팀)결재완료함
     * 처리내용 : 로그인한 사용자가 팀내 결재건은 전체 조회 할 수 있는 화면
     * 경로 : 고객사 > 전자결재 > 전자결재 > 부터(팀)결재완료함
     */
    @RequestMapping(value="/CWOR0060/view")
    public String cwor0060_view(EverHttpRequest req) throws Exception {
        req.setAttribute("fromDate", EverDate.addDateMonth(EverDate.getDate(), -1));
        req.setAttribute("toDate", EverDate.getDate());
        req.setAttribute("loginStatus", "E");
        return "/nhepro/CWOR/CWOR0060";
    }

    @RequestMapping(value = "/cwor0060_doSearch")
    public void cwor0060_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.setGridObject("grid", cwor_Service.cwor0060_doSearch(req.getFormData()));
    }

    /**
     * 화면명 : 결재상신함
     * 처리내용 : 로그인한 사용자가 상신한 결제문서들을 조회/상신취소할 수 있는 화면.
     * 경로 : 고객사 > 전자결재 > 전자결재 > 결재상신함
     */
    @RequestMapping(value="/CWOR0030/view")
    public String cwor0030_view(EverHttpRequest req) throws Exception {
        req.setAttribute("fromDate", EverDate.addDateMonth(EverDate.getDate(), -1));
        req.setAttribute("toDate", EverDate.getDate());
        return "/nhepro/CWOR/CWOR0030";
    }

    @RequestMapping(value = "/cwor0030_doSearch")
    public void cwor0030_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.setGridObject("grid", cwor_Service.cwor0030_doSearch(req.getFormData()));
    }

    @RequestMapping(value = "/cwor0030_doCancel")
    public void cwor0030_doCancel(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        List<Map<String, Object>> gridDatas = req.getGridData("grid");
        String rtnMsg = cwor_Service.cwor0030_doCancel(gridDatas);

        resp.setResponseMessage(rtnMsg);
    }

    /**
     * 화면명 : 결재경로관리
     * 처리내용 : 로그인한 사용자가 결재상신시 사용할 경로를 조회/등록/삭제할 수 있는 화면.
     * 경로 : 고객사 > 전자결재 > 전자결재 > 결재경로관리
     */
    @RequestMapping(value="/CWOR0040/view")
    public String cwor0040_view(EverHttpRequest req) throws Exception {
        return "/nhepro/CWOR/CWOR0040";
    }

    @RequestMapping(value = "/cwor0040_doSearch")
    public void cwor0040_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.setGridObject("grid", cwor_Service.cwor0040_doSearch(req.getFormData()));
    }

    @RequestMapping(value = "/cwor0040_doDelete")
    public void cwor0040_doDelete(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        List<Map<String, Object>> gridDatas = req.getGridData("grid");
        String rtnMsg = cwor_Service.cwor0040_doDelete(gridDatas);

        resp.setResponseMessage(rtnMsg);
    }

    /**
     * 화면명 : 결재경로등록
     * 처리내용 : 로그인한 사용자가 결재상신시 사용할 경로를 등록/수정할 수 있는 화면.
     * 경로 : 고객사 > 전자결재 > 전자결재 > 결재경로관리 > 결재경로등록 (팝업)
     */
    @RequestMapping(value="/CWOR0041/view")
    public String cwor0041_view(EverHttpRequest req) throws Exception {
        return "/nhepro/CWOR/CWOR0041";
    }

    @RequestMapping(value = "/cwor0041_doSearchDT")
    public void cwor0041_doSearchDT(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.setGridObject("gridL", cwor_Service.cwor0041_doSearchDT(req.getFormData()));
    }

    @RequestMapping(value = "/cwor0041_doSave")
    public void cwor0041_doSave(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> formData = req.getFormData();
        formData.put("saveType", EverString.nullToEmptyString(req.getParameter("saveType")));
        List<Map<String, Object>> gridDatas = req.getGridData("gridL");

        String rtnMsg = cwor_Service.cwor0041_doSave(formData, gridDatas);
        resp.setResponseMessage(rtnMsg);
    }

    private void setContents(EverHttpResponse resp, Map<String, String> dataHeader) throws Exception {

        String gateCd    = dataHeader.get("GATE_CD");
        String buyerCd   = dataHeader.get("BUYER_CD");
        String appDocNum = dataHeader.get("APP_DOC_NUM");
        String appDocCnt = String.valueOf(dataHeader.get("APP_DOC_CNT"));
        String docType   = dataHeader.get("DOC_TYPE");

        String consultContentsUrl = PropertiesManager.getString("eversrm.approval.consultContentsUrl." + docType);
        if (!consultContentsUrl.contains("?")) {
            consultContentsUrl += "?";
        }
        resp.setParameter("consultContentsUrl", consultContentsUrl);
        resp.setParameter("detailView", "true");
        resp.setParameter("gateCd", gateCd);
        resp.setParameter("buyerCd", buyerCd);
        resp.setParameter("appDocNum", appDocNum);
        resp.setParameter("appDocCnt", appDocCnt);

    }

    /**
     * 화면명 : 나의결재경로
     * 처리내용 : 로그인한 사용자가 등록한 경로를 조회/선택할 수 있는 화면.
     * 경로 : 고객사 > 전자결재 > 전자결재 > 결재경로관리 > 나의결재경로 (팝업)
     */
    @RequestMapping(value="/CWOR0042/view")
    public String cwor0042_view(EverHttpRequest req) throws Exception {
        return "/nhepro/CWOR/CWOR0042";
    }

    @RequestMapping(value = "/cwor0042_doSearch")
    public void cwor0042_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.setGridObject("grid", cwor_Service.cwor0042_doSearch(req.getFormData()));
    }

    /**
     * 화면명 : 결재요청
     * 처리내용 : 결재상신을 위해 결재내용, 결재자 등을 지정하는 화면.
     * 경로 : 고객사 > 업무화면 > 결재요청
     */
    @RequestMapping(value = "/CWOR0050/view")
    public String cwor0050_view(EverHttpRequest req) {

        boolean isDevelopmentMode = PropertiesManager.getBoolean("eversrm.system.developmentFlag");
        req.setAttribute("isDevelopmentMode", isDevelopmentMode);

        return "/nhepro/CWOR/CWOR0050";
    }

    @RequestMapping(value = "/cwor0050_userSearch")
    public void cwor0050_userSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.setGridObject("gridR", cwor_Service.cwor0050_userSearch(req.getFormData()));
        resp.setResponseCode("0001");
    }


    @RequestMapping(value = "/cwor0050_getCust")
    public void cwor0050_getCust(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        resp.setParameter("CUST_CD", EverConverter.getJsonString(  cwor_Service.cwor0050_getCust(req.getFormData()   )));

        resp.setResponseCode("0001");
    }

    @RequestMapping(value = "/cwor0050_getCustCd")
    public void cwor0050_getCustCd(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        resp.setParameter("CUST_CD", EverConverter.getJsonString(  cwor_Service.cwor0050_getCustCd(req.getFormData()   )));

        resp.setResponseCode("0001");
    }



    @RequestMapping(value = "/cwor0050_doSearchDecideArbitrarily")
    public void cwor0050_doSearchDecideArbitrarily(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String,Object> param = new HashMap<String, Object>();
        param.put("BIZ_CLS1", com.st_ones.common.util.clazz.EverString.nullToEmptyString(req.getParameter("bizCls1")));
        param.put("BIZ_CLS2", com.st_ones.common.util.clazz.EverString.nullToEmptyString(req.getParameter("bizCls2")));
        param.put("BIZ_CLS3", com.st_ones.common.util.clazz.EverString.nullToEmptyString(req.getParameter("bizCls3")));
        param.put("BIZ_AMT", com.st_ones.common.util.clazz.EverString.nullToEmptyString(req.getParameter("bizAmt")));
        param.put("BIZ_RATE", com.st_ones.common.util.clazz.EverString.nullToEmptyString(req.getParameter("bizRate")));
        param.put("REQ_USER_ID", com.st_ones.common.util.clazz.EverString.nullToEmptyString(req.getParameter("reqUserId")));

        List<Map<String, Object>> rtnList = cwor_Service.cwor0050_doSearchDecideArbitrarily(param);
        resp.setParameter("appFlag", (rtnList.size() > 0 ? "Y" : "N"));
        resp.setGridObject("gridL", rtnList);
    }

    @RequestMapping(value = "/cwor0050_doSearchSync")
    public void cwor0050_doSearchSync(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String,Object> oParam = new HashMap<String,Object>();
        oParam.put("USER_IDS", req.getParameter("USER_IDS"));

        resp.setGridObject("gridL", cwor_Service.cwor0050_doSearchSync(oParam));
    }

    @RequestMapping(value = "/cwor0050_doSelectMyPath")
    public void cwor0050_doSelectMyPath(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        String strApprovalPathKey = req.getParameter("strApprovalPathKey");

        HashMap<String, String> approvalPathKey = new ObjectMapper().readValue(strApprovalPathKey, HashMap.class);
        approvalPathKey.put("PATH_NUM", approvalPathKey.get("PATH_NUM"));

        resp.setGridObject("gridL", cwor_Service.cwor0050_doSelectMyPath(approvalPathKey));
    }

    /**
     * 공통으로 사용하는 결재순서 변경 컨트롤러이므로 프로그램 변경 시 아래의 화면을 모두 테스트해야합니다.
     * - 사용하는 화면: 결재요청팝업, 결재경로관리
     * @param req
     * @param resp
     * @throws Exception
     */
    @RequestMapping(value = "/getRealignmentApprovalList")
    public void getRealignmentApprovalList(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        String sortType = req.getParameter("sortType");
        List<Map<String, Object>> grid = req.getGridData("gridL");

        if(sortType.equals("up")) {
            int maxSize = grid.size();
            for(int i = maxSize-1; i >= 0; i--) {
                Map<String, Object> currData = grid.get(i);
                String checkFlag = (String)currData.get("CHECK_FLAG");
                if(StringUtils.equals(checkFlag, "1")) {
                    if(i != 0) {
                        Map<String, Object> prevData = grid.get(i-1);
                        String signReqType = StringUtils.defaultIfEmpty((String)prevData.get("SIGN_REQ_TYPE"), "");
                        // 이전의 결재타입이 병렬합의, 병렬결재라면
                        if(signReqType.equals("4") || signReqType.equals("7")) {
                            for(int j = i; j > 0; j--) {
                                if(j-1 >= 0) {

                                    Map<String, Object> beforePrevData = grid.get(j-1);
                                    String beforePrevSignReqType = StringUtils.defaultIfEmpty((String)beforePrevData.get("SIGN_REQ_TYPE"), "");

                                    if(beforePrevSignReqType.equals("4") || beforePrevSignReqType.equals("7")) {
                                        grid.set(j, beforePrevData);
                                        if(j-1 == 0) {
                                            grid.set(j - 1, currData);
                                        }
                                    } else {
                                        grid.set(j, currData);
                                        grid.set(j - 1, beforePrevData);
                                        i = j-1;
                                        break;
                                    }
                                } else {
                                    grid.set(1, grid.get(0));
                                    grid.set(0, currData);
                                    i = j;
                                    break;
                                }
                            }
                        } else {
                            grid.set(i - 1, currData);
                            grid.set(i, prevData);
                            i--;
                            break;
                        }
                    }
                } else {
                    grid.set(i, currData);
                }
            }
        }
        else if(sortType.equals("down")) {
            int maxSize = grid.size();
            for(int i = 0; i < maxSize; i++) {
                Map<String, Object> currData = grid.get(i);
                String checkFlag = (String)currData.get("CHECK_FLAG");
                if(StringUtils.equals(checkFlag, "1")) {
                    if(i != maxSize-1) {
                        Map<String, Object> prevData = grid.get(i+1);
                        String signReqType = StringUtils.defaultIfEmpty((String)prevData.get("SIGN_REQ_TYPE"), "");
                        // 이전의 결재타입이 병렬합의, 병렬결재라면
                        if(signReqType.equals("4") || signReqType.equals("7")) {
                            for(int j = i; j < maxSize; j++) {
                                if(j+1 < maxSize) {

                                    Map<String, Object> afterNextData = grid.get(j+1);
                                    String beforePrevSignReqType = StringUtils.defaultIfEmpty((String)afterNextData.get("SIGN_REQ_TYPE"), "");

                                    if(beforePrevSignReqType.equals("4") || beforePrevSignReqType.equals("7")) {
                                        grid.set(j, afterNextData);
                                    } else {
                                        grid.set(j, currData);
                                        i = j;
                                        break;
                                    }
                                } else {
                                    grid.set(maxSize - 2, grid.get(maxSize - 1));
                                    grid.set(maxSize - 1, currData);
                                    i = j;
                                    break;
                                }
                            }
                        } else {
                            grid.set(i, prevData);
                            grid.set(i + 1, currData);
                            i++;
                        }
                    }
                } else {
                    grid.set(i, currData);
                }
            }
        }
        resp.setGridObject("gridL", grid);
    }

}