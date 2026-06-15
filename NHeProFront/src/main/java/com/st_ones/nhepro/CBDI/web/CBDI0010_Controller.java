package com.st_ones.nhepro.CBDI.web;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.st_ones.common.combo.service.CommonComboService;
import com.st_ones.common.file.service.FileAttachService;
import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.common.util.clazz.EverConverter;
import com.st_ones.common.util.clazz.EverDate;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.common.util.service.EverDateService;
import com.st_ones.common.util.service.LargeTextService;
import com.st_ones.everf.serverside.info.BaseInfo;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.nhepro.CBDI.service.CBDI0010_Service;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import com.st_ones.everf.serverside.config.PropertiesManager;

import java.text.SimpleDateFormat;
import java.util.*;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2014 ST-Ones CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : CBDI0010_Controller.java
 * @date 2020. 4. 02.
 * @version 1.0
 */

@Controller
@RequestMapping(value = "/nhepro/CBDI")
public class CBDI0010_Controller extends BaseController {

	@Autowired private EverDateService everDate;

	@Autowired private CommonComboService commonComboService;

	@Autowired private CBDI0010_Service cbdi_Service;

	@Autowired private FileAttachService fileAttachService;

	@Autowired private LargeTextService largeTextService;

	/**
	 * 화면명 : 입찰공고
	 * 처리내용 : 입찰공고의 생성 이후 입찰등록까지의 입찰공고 목록을 조회하는 화면.
	 * 경로 : 고객사 > 구매관리 > 입찰관리 > 입찰공고 > 입찰공고
	 */
	@RequestMapping(value="/CBDI0010/view")
	public String cbdi0010_view(EverHttpRequest req) throws Exception {
		req.setAttribute("reqFromDate", EverDate.addDateMonth(EverDate.getDate(), -1));
		req.setAttribute("reqToDate", EverDate.addDateMonth(EverDate.getDate(), 1));
        req.setAttribute("bidStatusOptions", commonComboService.getCodesAsJson("CB0071", new HashMap<String, String>()));
		return "/nhepro/CBDI/CBDI0010";
	}

	@RequestMapping(value = "/cbdi0010_doSearch")
	public void cbdi0010_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
		resp.setGridObject("grid", cbdi_Service.cbdi0010_doSearch(req.getFormData()));
	}
	
	// 입찰담당자 변경
	@RequestMapping(value = "/cbdi0010_doChangeCtrl")
	public void cbdi0010_doChangeCtrl(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		List<Map<String, Object>> gridDatas = req.getGridData("grid");

		String rtnMsg = cbdi_Service.cbdi0010_doChangeCtrl(EverString.nullToEmptyString(req.getParameter("CTRL_USER_ID")), gridDatas);
		resp.setResponseMessage(rtnMsg);
	}
	
	// 규격/기술평가 담당자 변경
	@RequestMapping(value = "/cbdi0010_doChangeEv")
	public void cbdi0010_doChangeEv(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		List<Map<String, Object>> gridDatas = req.getGridData("grid");

		String rtnMsg = cbdi_Service.cbdi0010_doChangeEv(EverString.nullToEmptyString(req.getParameter("EV_USER_ID")), gridDatas);
		resp.setResponseMessage(rtnMsg);
	}

	/**
	 * 화면명 : 입찰공고생성
	 * 처리내용 : 입찰공고를 작성하는 화면.
	 * 경로 : 고객사 > 구매관리 > 입찰관리 > 입찰공고 > 입찰공고생성
	 */
	@RequestMapping(value="/CBDI0011/view")
	public String cbdi0011_view(EverHttpRequest req) throws Exception {

		UserInfo userInfo = UserInfoManager.getUserInfo();
		boolean havePermission = false;
		boolean visibleFlag = false;

		Map<String, String> formData = new HashMap<String, String>();
		Map<String, String> param = new HashMap<String, String>();

		String baseDataType = EverString.defaultIfEmpty(req.getParameter("baseDataType"), "");
		String buyerCd = EverString.nullToEmptyString(req.getParameter("buyerCd"));
		String bidNum = EverString.nullToEmptyString(req.getParameter("bidNum"));
		String bidCnt = EverString.nullToEmptyString(req.getParameter("bidCnt"));
		String appDocNum = EverString.nullToEmptyString(req.getParameter("appDocNum"));
		String appDocCnt = EverString.nullToEmptyString(req.getParameter("appDocCnt"));
		String paramPrNumSq = EverString.nullToEmptyString(req.getParameter("paramPrNumSq"));
		String preBidNum = EverString.nullToEmptyString(req.getParameter("preBidNum"));
		String preBidCnt = EverString.nullToEmptyString(req.getParameter("preBidCnt"));
		String preVoteCnt = EverString.nullToEmptyString(req.getParameter("preVoteCnt")); // 이전입찰의 입찰차수
		String subject = EverString.nullToEmptyString(req.getParameter("subject"));
		
		// 수정 또는 결재화면에서 입찰상세화면 이동시
		if((!buyerCd.equals("") && !bidNum.equals("") && !bidCnt.equals("")) || (!buyerCd.equals("") && !appDocNum.equals("") && !appDocCnt.equals("")))
		{
			param.put("BUYER_CD", buyerCd);
			param.put("BID_NUM", bidNum);
			param.put("BID_CNT", bidCnt);
			param.put("APP_DOC_NUM", appDocNum);
			param.put("APP_DOC_CNT", appDocCnt);
			param.put("baseDataType", baseDataType);
			formData = cbdi_Service.cbdi0011_doSearchHD(param);
			
			if(userInfo.getUserId().equals(formData.get("BID_USER_ID"))) {
				havePermission = true;
				visibleFlag = true;
			}
		} // 구매의뢰에서 작성
		else {
			formData.put("BUYER_CD", userInfo.getCompanyCd());
			formData.put("DEPT_CD", userInfo.getDeptCd());
			formData.put("BID_CNT", "1");
			formData.put("VOTE_CNT", "1");
			formData.put("ANN_ITEM", subject);
			formData.put("CUR", (EverString.nullToEmptyString(req.getParameter("paramCur")).equals("") ? "KRW" : req.getParameter("paramCur"))); // default "대한민국 원"
			formData.put("VAT_TYPE", (EverString.nullToEmptyString(req.getParameter("paramVat")).equals("") ? "1" : req.getParameter("paramVat"))); // default "부가세 포함"
			formData.put("BID_USER_ID", userInfo.getUserId());
			formData.put("BID_USER_NM", userInfo.getUserNm());
			//formData.put("ESTM_USER_ID", userInfo.getUserId());
			//formData.put("ESTM_USER_NM", userInfo.getUserNm());
			formData.put("OPEN_USER_ID", userInfo.getUserId());
			formData.put("OPEN_USER_NM", userInfo.getUserNm());
			formData.put("EI_NUM", "");
			formData.put("SIGN_STATUS", "T");

			havePermission = true;
			visibleFlag = true;
		}
		
		// 재공고 (종합낙찰재 : CBDI0034, 적성검사 : CBDI0036 등)
		if(baseDataType.equals("ReBID")) {
			formData.put("ORI_BID_NUM", null);
			formData.put("PRE_BID_NUM", preBidNum);
			formData.put("PRE_BID_CNT", preBidCnt);
			formData.put("PRE_VOTE_CNT", preVoteCnt);
			formData.put("ANN_DATE", null);
		}
		else {
			formData.put("ORI_BID_NUM", formData.get("BID_NUM"));
			formData.put("PRE_BID_NUM", null);
			formData.put("PRE_BID_CNT", null);
		}
		
		havePermission = EverString.nullToEmptyString(userInfo.getSuperUserFlag()).equals("1") ? true : havePermission;
		havePermission = (EverString.nullToEmptyString(formData.get("SIGN_STATUS")).equals("P") || EverString.nullToEmptyString(formData.get("SIGN_STATUS")).equals("E")) ? false : havePermission;
		havePermission = baseDataType.equals("ViewBID") ? false : havePermission;
		
		req.setAttribute("formData", formData);
		req.setAttribute("baseDataType", baseDataType);
		req.setAttribute("paramPrNumSq", paramPrNumSq);
		req.setAttribute("today", EverDate.getDate());
		req.setAttribute("todayTime", EverDate.getTime());
		req.setAttribute("havePermission", havePermission);
		req.setAttribute("visibleFlag", visibleFlag);
		
		return "/nhepro/CBDI/CBDI0011";
	}

	@RequestMapping(value = "/cbdi0011_doSearchDT")
	public void cbdi0011_doSearchDT(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		Map<String, String> param = req.getFormData();
		param.put("baseDataType", EverString.nullToEmptyString(req.getParameter("baseDataType")));
		param.put("paramPrNumSq", EverString.nullToEmptyString(req.getParameter("paramPrNumSq")));

		resp.setGridObject("gridI", cbdi_Service.cbdi0011_doSearchDT(param));
	}

	@RequestMapping(value = "/cbdi0011_doSearchEU")
	public void cbdi0011_doSearchEU(EverHttpRequest req, EverHttpResponse resp) throws Exception {
		resp.setGridObject("gridE", cbdi_Service.cbdi0011_doSearchEU(req.getFormData()));
	}

	@RequestMapping(value = "/cbdi0011_doSave")
	public void cbdi0011_doSave(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		Map<String, String> formData = req.getFormData();
		formData.put("baseDataType", EverString.nullToEmptyString(req.getParameter("baseDataType"))); // 변경 입찰유형 : CreateBid, ModBid, ReBid etc
		formData.put("oriBaseDataType", EverString.nullToEmptyString(req.getParameter("oriBaseDataType"))); // 원래 입찰유형

		List<Map<String, Object>> gridDatasI = req.getGridData("gridI");
		List<Map<String, Object>> gridDatasE = req.getGridData("gridE");

		Map<String, String> rtnMap = cbdi_Service.cbdi0011_doSave(formData, gridDatasI, gridDatasE);
		resp.setParameter("buyerCd", rtnMap.get("buyerCd"));
		resp.setParameter("bidNum", rtnMap.get("bidNum"));
		resp.setParameter("bidCnt", rtnMap.get("bidCnt"));
		resp.setResponseMessage(rtnMap.get("rtnMsg"));
	}

	@RequestMapping(value = "/cbdi0011_doDelete")
	public void cbdi0011_doDelete(EverHttpRequest req, EverHttpResponse resp) throws Exception {
		resp.setResponseMessage(cbdi_Service.cbdi0011_doDelete(req.getFormData()));
	}

	/**
	 * 화면명 : 입찰공고상세
	 * 처리내용 : 입찰공고의 상세내용을 조회하는 Popup 화면.
	 * 경로 : 고객사 > 구매관리 > 입찰관리 > 입찰공고 > 입찰공고상세
	 */
	@RequestMapping(value = "/CBDR0012/view")
	public String cbdr0012_view(EverHttpRequest req) throws Exception {
		Map<String,String> param = req.getParamDataMap();
		Map<String, Object> formData = cbdi_Service.cbdr0012_doSearch(param);
		formData.put("ATT_FILE", fileAttachService.getFilesInfo("BID",String.valueOf(formData.get("ATT_FILE_NUM"))));

		String appEtc = largeTextService.selectLargeText(String.valueOf(formData.get("APP_ETC")));

		if (appEtc!=null) {
			appEtc = appEtc.replaceAll("&amp;", "&").replaceAll("&lt;", "<").replaceAll("&gt;", ">").replaceAll("&apos;", "'").replaceAll("&quot;", "\\\"");
		}

		req.setAttribute("APP_ETC",  appEtc);

		req.setAttribute("formData",  formData);
		return "/nhepro/CBDI/CBDR0012";
	}

	/**
	 * 화면명 : 취소공고생성
	 * 처리내용 : (입찰)취소공고를 작성하는 화면.
	 * 경로 : 고객사 > 구매관리 > 입찰관리 > 입찰공고 > 취소공고생성
	 */
	@RequestMapping(value="/CBDR0013/view")
	public String cbdr0013_view(EverHttpRequest req) throws Exception {

		UserInfo userInfo = UserInfoManager.getUserInfo();
		boolean havePermission = false;
		boolean visibleFlag = false;

		Map<String, String> formData = new HashMap<String, String>();
		Map<String, String> param = new HashMap<String, String>();

		String baseDataType = EverString.defaultIfEmpty(req.getParameter("baseDataType"), "");
		String buyerCd = EverString.nullToEmptyString(req.getParameter("buyerCd"));
		String bidNum = EverString.nullToEmptyString(req.getParameter("bidNum"));
		String bidCnt = EverString.nullToEmptyString(req.getParameter("bidCnt"));
		String appDocNum = EverString.nullToEmptyString(req.getParameter("appDocNum"));
		String appDocCnt = EverString.nullToEmptyString(req.getParameter("appDocCnt"));

		if((!buyerCd.equals("") && !bidNum.equals("") && !bidCnt.equals("")) || (!buyerCd.equals("") && !appDocNum.equals("") && !appDocCnt.equals("")))
		{
			param.put("BUYER_CD", buyerCd);
			param.put("BID_NUM", bidNum);
			param.put("BID_CNT", bidCnt);
			param.put("APP_DOC_NUM", appDocNum);
			param.put("APP_DOC_CNT", appDocCnt);
			param.put("baseDataType", baseDataType);
			formData = cbdi_Service.cbdr0013_doSearchHD(param);

			if(formData != null) {
				if (userInfo.getUserId().equals(formData.get("BID_USER_ID"))) {
					havePermission = true;
					visibleFlag = true;
				}
			}
		}

		havePermission = EverString.nullToEmptyString(userInfo.getSuperUserFlag()).equals("1") ? true : havePermission;
		havePermission = (formData == null ? false : (EverString.nullToEmptyString(formData.get("SIGN_STATUS")).equals("P") || EverString.nullToEmptyString(formData.get("SIGN_STATUS")).equals("E")) ? false : havePermission);
		havePermission = baseDataType.equals("ViewBID") ? false : havePermission;

		req.setAttribute("formData", formData);
		req.setAttribute("baseDataType", baseDataType);
		req.setAttribute("today", EverDate.getDate());
		req.setAttribute("todayTime", EverDate.getTime());
		req.setAttribute("havePermission", havePermission);
		req.setAttribute("visibleFlag", visibleFlag);
		return "/nhepro/CBDI/CBDR0013";
	}

	@RequestMapping(value = "/cbdr0013_doSave")
	public void cbdr0013_doSave(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		Map<String, String> formData = req.getFormData();
		formData.put("baseDataType", EverString.nullToEmptyString(req.getParameter("baseDataType")));

		String rtnMsg = cbdi_Service.cbdr0013_doSave(formData);
		resp.setResponseMessage(rtnMsg);
	}
	
	/**
	 * 2021.07.05 : 취소공고 삭제
	 * @param req
	 * @param resp
	 * @throws Exception
	 */
	@RequestMapping(value = "/cbdi0013_doDelete")
	public void cbdi0013_doDelete(EverHttpRequest req, EverHttpResponse resp) throws Exception {
		resp.setResponseMessage(cbdi_Service.cbdi0013_doDelete(req.getFormData()));
	}
	
	/**
	 * 화면명 : 취소공고상세
	 * 처리내용 : 취소공고의 상세내용을 조회하는 Popup 화면.
	 * 경로 : 고객사 > 구매관리 > 입찰관리 > 입찰공고 > 취소공고상세
	 */
	@RequestMapping(value = "/CBDR0014/view")
	public String cbdr0014_view(EverHttpRequest req) throws Exception {
		Map<String,String> param = req.getParamDataMap();
		Map<String, Object> formData = cbdi_Service.cbdr0012_doSearch(param);

		String cancelRmk = largeTextService.selectLargeText(String.valueOf(formData.get("CANCEL_RMK")));

		if (cancelRmk!=null) {
			cancelRmk = cancelRmk.replaceAll("&amp;", "&").replaceAll("&lt;", "<").replaceAll("&gt;", ">").replaceAll("&apos;", "'").replaceAll("&quot;", "\\");
		}

		req.setAttribute("CANCEL_RMK",  cancelRmk);


		req.setAttribute("formData",  formData);
		return "/nhepro/CBDI/CBDR0014";
	}

	/**
	 * 화면명 : 기술평가실행
	 * 처리내용 : 기술평가를 진행하기 위하여 평가자에게 통보하는 화면.
	 * 경로 : 고객사 > 구매관리 > 입찰관리 > 입찰공고 > 기술평가실행
	 */
	@RequestMapping(value="/CBDR0015/view")
	public String cbdr0015_view(EverHttpRequest req) throws Exception {

		UserInfo userInfo = UserInfoManager.getUserInfo();
		boolean havePermission = false;

		Map<String, String> formData = new HashMap<String, String>();
		Map<String, String> param = new HashMap<String, String>();

		String buyerCd = EverString.nullToEmptyString(req.getParameter("buyerCd"));
		String bidNum = EverString.nullToEmptyString(req.getParameter("bidNum"));
		String bidCnt = EverString.nullToEmptyString(req.getParameter("bidCnt"));

		if(!bidNum.equals("") && !bidCnt.equals(""))
		{
			param.put("BUYER_CD", buyerCd);
			param.put("BID_NUM", bidNum);
			param.put("BID_CNT", bidCnt);
			formData = cbdi_Service.cbdr0015_doSearchHD(param);

			if(userInfo.getUserId().equals(formData.get("BID_USER_ID"))) {
				havePermission = true;
			}
		}

		havePermission = EverString.nullToEmptyString(userInfo.getSuperUserFlag()).equals("1") ? true : havePermission;

		req.setAttribute("formData", formData);
		req.setAttribute("havePermission", havePermission);
		return "/nhepro/CBDI/CBDR0015";
	}

	@RequestMapping(value = "/cbdr0015_doSearchEU")
	public void cbdr0015_doSearchEU(EverHttpRequest req, EverHttpResponse resp) throws Exception {
		resp.setGridObject("gridEU", cbdi_Service.cbdi0011_doSearchEU(req.getFormData()));
	}

    @RequestMapping(value = "/cbdr0015_doEval")
    public void cbdr0015_doEval(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> formData = req.getFormData();
        List<Map<String, Object>> gridDatas = req.getGridData("gridEU");

        String rtnMsg = cbdi_Service.cbdr0015_doEval(formData, gridDatas);
        resp.setResponseMessage(rtnMsg);
    }

    /**
     * 화면명 : 지명경쟁 협력업체조회
     * 처리내용 : 입찰요청서를 전송할 업체를 조회하는 Popup 화면.
     * 경로 : 고객사 > 구매관리 > 입찰관리 > 입찰공고 > 입찰공고생성 > Popup
     */
    @RequestMapping(value = "/CBDR0016/view")
    public String cbdr0016_view(EverHttpRequest req) throws Exception {
        return "/nhepro/CBDI/CBDR0016";
    }

	@RequestMapping(value = "/cbdr0016_doSearchCandidate")
	public void cbdr0016_doSearchCandidate(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		Map<String, String> formData = req.getFormData();
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.putAll(formData);

		String selectedVenderJson = req.getParameter("selectedVendors");
		if (selectedVenderJson != null) {
			paramMap.put("selectedVendors", new ObjectMapper().readValue(selectedVenderJson, List.class));
			resp.setGridObject("gridR", cbdi_Service.cbdr0016_doSearchCandidate(paramMap));
		} else {
			resp.setGridObject("gridL", cbdi_Service.cbdr0016_doSearchCandidate(paramMap));
		}
	}

	/**
	 * 화면명 : 평가템플릿 선택
	 * 처리내용 : 시스템에 등록된 평가템플릿을 조회/선택할 수 있는 Popup 화면.
	 * 경로 : 고객사 > 구매관리 > 입찰관리 > 입찰공고 > 입찰공고생성 > Popup
	 */
	@RequestMapping(value = "/CBDI0016/view")
	public String cbdi0016_view(EverHttpRequest req) throws Exception {
		return "/nhepro/CBDI/CBDI0016";
	}

	@RequestMapping(value = "/cbdi0016_doSearch")
	public void cbdi0016_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {

	    List<Map<String, Object>> rtnList = cbdi_Service.cbdi0016_doSearch(req.getFormData());
	    String evTplSubject = "";
	    for(Map<String, Object> rtnData : rtnList) {
            evTplSubject = String.valueOf(rtnData.get("EV_TPL_SUBJECT"));
        }

		resp.setGridObject("gridMain", rtnList);
	    resp.setParameter("EV_TPL_SUBJECT", evTplSubject);
	}

    @RequestMapping(value = "/cbdi0016_changeComboItemKindR")
    public void ccur0040_changeComboItemKindR(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> param = req.getFormData();
        if ("E".equals(param.get("EV_ITEM_KIND_CD_RT").toString())) {
            resp.setParameter("itemTypeCode", commonComboService.getCodeComboAsJson("M114"));
        } else {
            resp.setParameter("itemTypeCode", commonComboService.getCodeComboAsJson("M113"));
        }
    }

    @RequestMapping(value = "/cbdi0016_changeComboItemKindValue")
    public void cbdi0016_changeComboItemKindValue(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> param = req.getFormData();
        param.put("EV_ITEM_KIND_CD", req.getParameter("EV_ITEM_KIND_CD"));

        if ("E".equals(param.get("EV_ITEM_KIND_CD").toString())) {
            resp.setParameter("itemTypeCode", commonComboService.getCodeComboAsJson("M114"));
        } else {
            resp.setParameter("itemTypeCode", commonComboService.getCodeComboAsJson("M113"));
        }
    }

	@RequestMapping(value = "/cbdi0016_doSearchDetail")
	public void cbdi0016_doSearchDetail(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		Map<String, String> param = req.getFormData();
		param.put("EV_ITEM_NUM", req.getParameter("EV_ITEM_NUM"));

		List<Map<String,Object>> gridQlyList = cbdi_Service.cbdi0016_doSearchEvalItemMgtDetail1(param);
		List<Map<String,Object>> gridQtyList = cbdi_Service.cbdi0016_doSearchEvalItemMgtDetail2(param);

		for(int i = 0; i < gridQlyList.size(); i++) {
			resp.setGridRowStyle("gridQly", String.valueOf(i), "text-decoration", "inherit");
			resp.setGridRowStyle("gridQly", String.valueOf(i), "background-color", "#fdd");
		}

		for(int i = 0; i < gridQtyList.size(); i++) {
			resp.setGridRowStyle("gridQty", String.valueOf(i), "text-decoration", "inherit");
			resp.setGridRowStyle("gridQty", String.valueOf(i), "background-color", "#fdd");
		}
		resp.setGridObject("gridQly", gridQlyList);
		resp.setGridObject("gridQty", gridQtyList);
	}

	@RequestMapping(value = "/cbdi0016_doSaveH")
	public void cbdi0016_doSaveH(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		Map<String, String> formData = req.getFormData();
		List<Map<String, Object>> gridDatas = req.getGridData("gridMain");

		String[] msg = cbdi_Service.cbdi0016_doSaveH(formData, gridDatas);
		resp.setParameter("EI_NUM", msg[0]);
		resp.setResponseMessage(msg[1]);
	}

    @RequestMapping(value = "/cbdi0016_doDelete")
    public void cbdi0016_doDelete(EverHttpRequest req, EverHttpResponse resp) throws Exception {

	    Map<String, String> formData = req.getFormData();
        List<Map<String,Object>> gridData = req.getGridData("gridMain");

        String msg = cbdi_Service.cbdi0016_doDelete(formData, gridData);
        resp.setResponseMessage(msg);
    }

	@RequestMapping(value = "/cbdi0016_doSaveR")
	public void cbdi0016_doSaveR(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		Map<String, String> formData = req.getFormData();
		List<Map<String, Object>> gridDatas = new ArrayList<Map<String, Object>>();

		if ("QUA".equals(EverString.nullToEmptyString(formData.get("EV_ITEM_METHOD_CD_RT")))) {
			gridDatas = req.getGridData("gridQly");
		} else {
			gridDatas = req.getGridData("gridQty");
		}

		String[] msg = cbdi_Service.cbdi0016_doSaveR(formData, gridDatas);
		resp.setParameter("EI_NUM", msg[0]);
		resp.setParameter("EI_SQ", msg[1]);
		resp.setResponseMessage(msg[2]);
	}

	@RequestMapping(value = "/cbdi0016_doDeleteR")
	public void cbdi0016_doDeleteR(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		Map<String, String> formData = req.getFormData();
		List<Map<String, Object>> gridDatas = new ArrayList<Map<String, Object>>();
		if ("QUA".equals(EverString.nullToEmptyString(formData.get("EV_ITEM_METHOD_CD_RT")))) {
			gridDatas = req.getGridData("gridQly");
		} else {
			gridDatas = req.getGridData("gridQty");
		}

		String msg = cbdi_Service.cbdi0016_doDeleteR(formData, gridDatas);
		resp.setResponseMessage(msg);
	}

	/**
	 * 화면명 : 입찰등록
	 * 처리내용 : 입찰공고 중부터 입찰마감까지의 입찰공고 목록을 조회하여 마감/유찰처리한다.
	 * 경로 : 고객사 > 구매관리 > 입찰관리 > 입찰등록
	 */
	@RequestMapping(value="/CBDI0020/view")
	public String cbdi0020_view(EverHttpRequest req) throws Exception {
		String ManagerCd = PropertiesManager.getString("eversrm.customer.admin.ManagerCd"); 
		UserInfo userInfo = UserInfoManager.getUserInfo();
		boolean hasManagerCd = (userInfo.getCtrlCd()).contains(ManagerCd);
		
		req.setAttribute("reqFromDate", EverDate.addDateMonth(EverDate.getDate(), -1));
		req.setAttribute("reqToDate", EverDate.addDateMonth(EverDate.getDate(), 1));
		req.setAttribute("hasManagerCd", hasManagerCd);
		return "/nhepro/CBDI/CBDI0020";
	}

	@RequestMapping(value = "/cbdi0020_doSearch")
	public void cbdi0020_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {

    	List<Map<String, Object>> searchList = cbdi_Service.cbdi0020_doSearch(req.getFormData());
        for (int i = 0; i < searchList.size(); i++) {
        	Map<String, Object> grid = searchList.get(i);
        	resp.setGridCellStyle("grid", String.valueOf(i), "APP_END_DATETIME", "color", "#0000FF");
        }

        resp.setGridObject("grid", searchList);
	}

	@RequestMapping(value = "/cbdi0020_doChangeCtrl")
	public void cbdi0020_doChangeCtrl(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		List<Map<String, Object>> gridDatas = req.getGridData("grid");

		String rtnMsg = cbdi_Service.cbdi0020_doChangeCtrl(EverString.nullToEmptyString(req.getParameter("CTRL_USER_ID")), gridDatas);
		resp.setResponseMessage(rtnMsg);
	}

	@RequestMapping(value = "/cbdi0020_doFailBidding")
	public void cbdi0020_doFailBidding(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		List<Map<String, Object>> gridDatas = req.getGridData("grid");

		String rtnMsg = cbdi_Service.cbdi0020_doFailBidding(gridDatas);
		resp.setResponseMessage(rtnMsg);
	}
	
	/**
     * 2020.12.02 기능 추가
     * 입찰 마감시 현재의 진행상태 체크
     */
    @RequestMapping(value = "/cbdi0020_doCheckBidClose")
    public void cbdi0020_doCheckBidClose(EverHttpRequest req, EverHttpResponse resp) throws Exception {

    	Map<String, String> param = req.getFormData();
    	Map<String, String> rtnMsg = cbdi_Service.cbdi0020_doCheckBidClose(param);
    	
        resp.setResponseCode(rtnMsg.get("rtnCode"));
        resp.setResponseMessage(rtnMsg.get("rtnMsg"));
    }
    
    /**
     * 2020.12.02 기능 추가
     * 입찰 유찰시 현재의 진행상태 체크
     */
    @RequestMapping(value = "/cbdi0020_doCheckFailBidding")
    public void cbdi0020_doCheckFailBidding(EverHttpRequest req, EverHttpResponse resp) throws Exception {

    	Map<String, String> param = req.getFormData();
    	Map<String, String> rtnMsg = cbdi_Service.cbdi0020_doCheckFailBidding(param);
    	
        resp.setResponseCode(rtnMsg.get("rtnCode"));
        resp.setResponseMessage(rtnMsg.get("rtnMsg"));
    }
    
    /**
     * 화면명 : 입찰등록결과 등록
     * 처리내용 : 협력업체의 입찰참가자격을 확인하여 입찰등록을 마감하는 화면
     * 경로 : 고객사 > 구매관리 > 입찰관리 > 입찰등록 > 입찰등록결과 등록
     */
    @RequestMapping(value="/CBDI0021/view")
    public String cbdi0021_view(EverHttpRequest req) throws Exception {

        UserInfo userInfo = UserInfoManager.getUserInfo();
        boolean havePermission = false;

        Map<String, String> formData = new HashMap<String, String>();
        Map<String, String> param = new HashMap<String, String>();

        String buyerCd = EverString.nullToEmptyString(req.getParameter("buyerCd"));
        String bidNum  = EverString.nullToEmptyString(req.getParameter("bidNum"));
        String bidCnt  = EverString.nullToEmptyString(req.getParameter("bidCnt"));
        String voteCnt = EverString.nullToEmptyString(req.getParameter("voteCnt"));

        if(!bidNum.equals("") && !bidCnt.equals("")) {
            param.put("BUYER_CD", buyerCd);
            param.put("BID_NUM", bidNum);
            param.put("BID_CNT", bidCnt);
            formData = cbdi_Service.cbdi0021_doSearchHD(param);
            
            if(userInfo.getUserId().equals(formData.get("BID_USER_ID"))) {
                havePermission = true;
            }
        }
        formData.put("VOTE_CNT", voteCnt);
        
        havePermission = EverString.nullToEmptyString(userInfo.getSuperUserFlag()).equals("1") ? true : havePermission;
        
        req.setAttribute("formData", formData);
        req.setAttribute("havePermission", havePermission);
        return "/nhepro/CBDI/CBDI0021";
    }

    @RequestMapping(value = "/cbdi0021_doSearch")
    public void cbdi0021_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.setGridObject("grid", cbdi_Service.cbdi0021_doSearch(req.getFormData()));
    }

    @RequestMapping(value = "/cbdi0021_doBidClose")
    public void cbdi0021_doBidClose(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> formData = req.getFormData();
        List<Map<String, Object>> gridDatas = req.getGridData("grid");

        String rtnMsg = cbdi_Service.cbdi0021_doBidClose(formData, gridDatas);
        resp.setResponseMessage(rtnMsg);
    }

    @RequestMapping(value = "/cbdi0021_doFailBidding")
    public void cbdi0021_doFailBidding(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> formData = req.getFormData();

        String rtnMsg = cbdi_Service.cbdi0021_doFailBidding(formData);
        resp.setResponseMessage(rtnMsg);
    }

	/** ******************************************************************************************
     * Up/Down 버튼
     * @param req
     * @return
     * @throws Exception
     */
	@RequestMapping(value = "/getRealignmentApprovalList")
	public void getRealignmentApprovalList(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        String sortType = req.getParameter("sortType");

        List<Map<String, Object>> gridR = req.getGridData("rightGrid");

        if(sortType.equals("up")) {

        	int maxSize = gridR.size();

        	for(int i = maxSize-1; i >= 0; i--) {

        		Map<String, Object> currData = gridR.get(i);
                String checkFlag = (String)currData.get("CHECK_FLAG");

                if(StringUtils.equals(checkFlag, "1")) {
                    if(i != 0) {
                    	Map<String, Object> prevData = gridR.get(i-1);
                        gridR.set(i-1, currData);
                        gridR.set(i, prevData);
                        i--;
                        break;
                    }
                } else {
                    gridR.set(i, currData);
                }
            }

        } else if(sortType.equals("down")) {

        	int maxSize = gridR.size();

        	for(int i = 0; i < maxSize; i++) {

        		Map<String, Object> currData = gridR.get(i);
                String checkFlag = (String)currData.get("CHECK_FLAG");

                if(StringUtils.equals(checkFlag, "1")) {
                    if(i != maxSize-1) {
                    	Map<String, Object> prevData = gridR.get(i+1);
                        gridR.set(i, prevData);
                        gridR.set(i+1, currData);
                        i++;
                    }
                } else {
                    gridR.set(i, currData);
                }
            }
        }
        resp.setGridObject("rightGrid", gridR);
	}

	/**
	 * 화면명 : 입찰신청기간변경
	 * 처리내용 : 입찰신청기간변경하는 화면.
	 * 경로 : 고객사 > 구매관리 > 입찰등록 > 입찰신청기간변경
	 * 2021.06.08 입찰등록 화면에서 입찰신청기간변경 기능 추가
	 */
	@RequestMapping(value="/CBDI0022/view")
	public String cbdi0022_view(EverHttpRequest req) throws Exception {
		
		Map<String,String> param = req.getParamDataMap();
        String buyerCd = req.getParameter("buyerCd");
        if (param.get("BUYER_CD") == null) {
        	param.put("BUYER_CD", buyerCd);
        }
		req.setAttribute("formData",  cbdi_Service.cbdi0022_doSearch(param));
		req.setAttribute("today", EverDate.getDate());
		req.setAttribute("todayTime", EverDate.getTime());
		return "/nhepro/CBDI/CBDI0022";
	}
	
	@RequestMapping(value = "/cbdi0022_doSave")
	public void cbdi0022_doSave(EverHttpRequest req, EverHttpResponse resp) throws Exception {
		Map<String, String> formData = req.getFormData();
		
		formData.put("screenId", EverString.nullToEmptyString(req.getParameter("screenId")));
		
		String rtnMsg = cbdi_Service.cbdi0022_doSave(req.getFormData());
		resp.setResponseMessage(rtnMsg);
	}
	
}
