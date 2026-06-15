package com.st_ones.nhepro.CCTR.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.st_ones.common.combo.service.CommonComboService;
import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.util.clazz.EverDate;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.nhepro.CCTR.service.CCTI0090_Service;
import com.st_ones.nosession.interfacez.service.ContSendErpService;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : CCTI0090_Controller.java
 * @date 2020.06.10
 * @version 1.0
 * @see
 */

@Controller
@RequestMapping(value = "/nhepro/CCTR")
public class CCTI0090_Controller extends BaseController{
    @Autowired
    private MessageService msg;
    @Autowired
    private CCTI0090_Service ccti0090_Service;
    @Autowired
    private CommonComboService commonComboService;


    @Autowired
    private ContSendErpService contsenderpservice;

	/**
	 * 화면명 : 계약서작성
	 * 처리내용 : 개인근로 계약서작성
	 * 경로 : 계약관리 > 개인근로계약 > 계약서작성
	 */
    @RequestMapping(value="/CCTI0090/view")
 	public String ccti0090_view(EverHttpRequest req, EverHttpResponse resp) throws Exception {
 		// =============== 관리자 여부 ==================== //
 		UserInfo userInfo = UserInfoManager.getUserInfo();
 		boolean havePermission = EverString.nullToEmptyString(userInfo.getSuperUserFlag()).equals("1");
 		req.setAttribute("havePermission", havePermission);

 		Map<String, String> param = req.getFormData();
 		String buyerCd   = req.getParameter("buyerCd");
 		String contNum   = req.getParameter("contNum");
 		String contCnt   = req.getParameter("contCnt");
 		String appDocNum = req.getParameter("appDocNum");
 		String appDocCnt = req.getParameter("appDocCnt");

 		if( (EverString.isNotEmpty(contNum) && EverString.isNotEmpty(contCnt))
 				||(EverString.isNotEmpty(appDocNum) && EverString.isNotEmpty(appDocCnt))){
 			param.put("BUYER_CD", buyerCd);
 			param.put("CONT_NUM", contNum);
 			param.put("CONT_CNT", contCnt);
 			param.put("APP_DOC_NUM", appDocNum);
 			param.put("APP_DOC_CNT", appDocCnt);

 			req.setAttribute("form", ccti0090_Service.ccti0090_doSearch(param));
 		}
 		req.setAttribute("toDate", EverDate.getDate());

 		return "/nhepro/CCTR/CCTI0090";
 	}

 	@RequestMapping(value = "/CCTI0090/doSearchPCWU")
 	public void ccti0090_doSearchPCWU(EverHttpRequest req, EverHttpResponse resp) throws Exception {

 		Map<String, String> param = req.getFormData();
 		resp.setGridObject("grid", ccti0090_Service.ccti0090_doSearchPCWU(param));
 	}

 	/**
 	 * 개인근로자 엑셀 업로드
 	 * @param req
 	 * @param resp
 	 * @throws Exception
 	 */
 	@RequestMapping(value = "/CCTI0090/getWorkerListForContract")
 	public void ccti0090_getWorkerListForContract(EverHttpRequest req, EverHttpResponse resp) throws Exception {

 		List<Map<String, Object>> rtnList = new ArrayList<Map<String, Object>>();

 		List<Map<String, Object>> gridData   = req.getGridData("grid");
 		List<Map<String, Object>> resultList = ccti0090_Service.ccti0090_getWorkerListForContract(gridData);
 		for(Map<String, Object> param1 : resultList ) {
 			for(Map<String, Object> param2 : gridData ) {
 				if( (param1.get("USER_ID")).equals(param2.get("USER_ID")) ){
 					Map<String, Object> map = new HashMap<String, Object>();
 					map.put("WORKER_ID", param1.get("USER_ID"));
 					map.put("WORKER_NM", param1.get("USER_NM"));
 					map.put("GENDER", param1.get("GENDER"));
 					map.put("SITE_USER_ID", param1.get("SITE_USER_ID"));
 					map.put("SITE_USER_NM", param1.get("SITE_USER_NM"));
 					map.put("WORKER_DEPT_NM", param2.get("WORKER_DEPT_NM"));
 					map.put("WORKER_JOB_NM", param2.get("WORKER_JOB_NM"));
 					map.put("WORKER_CONT_DATE", param2.get("WORKER_CONT_DATE"));
 					map.put("WORKER_CONT_START_DATE", param2.get("WORKER_CONT_START_DATE"));
 					map.put("WORKER_CONT_END_DATE", param2.get("WORKER_CONT_END_DATE"));
 					map.put("BASE_PAY", param2.get("BASE_PAY"));
 					map.put("BASE_PAY_RMKS", param2.get("BASE_PAY_RMKS"));
 					map.put("FOOD_PAY", param2.get("FOOD_PAY"));
 					map.put("FOOD_PAY_RMKS", param2.get("FOOD_PAY_RMKS"));
 					map.put("JOB_PAY", param2.get("JOB_PAY"));
 					map.put("JOB_PAY_RMKS", param2.get("JOB_PAY_RMKS"));
 					map.put("EXTEND_PAY", param2.get("EXTEND_PAY"));
 					map.put("EXTEND_PAY_RMKS", param2.get("EXTEND_PAY_RMKS"));
 					map.put("WORK_PAY", param2.get("WORK_PAY"));
 					map.put("WORK_PAY_RMKS", param2.get("WORK_PAY_RMKS"));
 					map.put("NIGHT_PAY", param2.get("NIGHT_PAY"));
 					map.put("NIGHT_PAY_RMKS", param2.get("NIGHT_PAY_RMKS"));
 					map.put("ETC_PAY", param2.get("ETC_PAY"));
 					map.put("ETC_PAY_RMKS", param2.get("ETC_PAY_RMKS"));
 					map.put("WORKER_PAY_AMT", param2.get("WORKER_PAY_AMT"));

 					rtnList.add(map);
 					break;
 				}
 			}
 		}

 		resp.setGridObject("grid", rtnList);
 		resp.setResponseMessage(msg.getMessage("0031"));

 	}

 	// 개인근로자 계약서 저장
 	@RequestMapping(value = "/CCTI0090/doSave")
 	public void ccti0090_doSave(EverHttpRequest req, EverHttpResponse resp) throws Exception {

 		Map<String, String> dataForm = req.getFormData();

 		List<Map<String, Object>> gridData  = req.getGridData("grid");  // 개인근로자

 		Map<String, String> resultMap = ccti0090_Service.ccti0090_doSave(dataForm, gridData);
 		
 		resp.setParameter("buyerCd", resultMap.get("BUYER_CD"));
 		resp.setParameter("contNum", resultMap.get("CONT_NUM"));
 		resp.setParameter("contCnt", String.valueOf(resultMap.get("CONT_CNT")));

 		resp.setResponseMessage(msg.getMessage("0001"));
 		resp.setResponseCode("true");
 	}

 	// 개인근로자 계약서 삭제
 	@RequestMapping(value = "/CCTI0090/doDelete")
 	public void ccti0090_doDelete(EverHttpRequest req, EverHttpResponse resp) throws Exception {

 		Map<String, String> formData = req.getFormData();
 		ccti0090_Service.ccti0090_doDelete(formData);

 		resp.setResponseMessage(msg.getMessage("0001"));
 		resp.setResponseCode("true");
 	}

 	// 개인근로자 계약서 결재상신
 	@RequestMapping(value = "/CCTI0090/doReqSign")
 	public void ccti0090_doReqSign(EverHttpRequest req, EverHttpResponse resp) throws Exception {

 		Map<String, String> dataForm = req.getFormData();

 		List<Map<String, Object>> gridData  = req.getGridData("grid");

 		Map<String, String> resultMap = ccti0090_Service.ccti0090_doReqSign(dataForm, gridData);
 		resp.setParameter("buyerCd", resultMap.get("BUYER_CD"));
 		resp.setParameter("contNum", resultMap.get("CONT_NUM"));
 		resp.setParameter("contCnt", String.valueOf(resultMap.get("CONT_CNT")));

 		resp.setResponseMessage(msg.getMessage("0001"));
 		resp.setResponseCode("true");
 	}

 	// CCTR0100 : 개인근로자 계약진행현황
 	@RequestMapping(value = "/CCTR0100/view")
 	public String cctr0100_view(EverHttpRequest req, EverHttpResponse resp) throws Exception {

 		// =============== 관리자 여부 ==================== //
 		UserInfo userInfo = UserInfoManager.getUserInfo();
 		boolean havePermission = EverString.nullToEmptyString(userInfo.getSuperUserFlag()).equals("1");
 		req.setAttribute("havePermission", havePermission);

 		req.setAttribute("fromDate", EverDate.addMonths(-1));
 		req.setAttribute("toDate", EverDate.getDate());

 		return "/nhepro/CCTR/CCTR0100";
 	}

 	@RequestMapping(value = "/CCTR0100/doSearch")
 	public void cctr0100_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {

 		Map<String, String> param = req.getFormData();
 		resp.setGridObject("grid", ccti0090_Service.cctr0100_doSearch(param));
 	}

 	// 개인근로자 전자서명요청
 	@RequestMapping(value="/CCTR0100/doRequest")
 	public void cctr0100_doRequest(EverHttpRequest req, EverHttpResponse resp) throws Exception {
 		Map<String, String> param = req.getFormData();
 		List<Map<String, Object>> gridData = req.getGridData("grid");

 		ccti0090_Service.cctr0100_doRequest(gridData);
 		resp.setResponseMessage(msg.getMessage("0001"));
 	}

 	// 개인근로자 계약체결중단
 	@RequestMapping(value="/CCTR0100/doStop")
 	public void cctr0100_doStop(EverHttpRequest req, EverHttpResponse resp) throws Exception {
 		Map<String, String> param = req.getFormData();
 		List<Map<String, Object>> gridData = req.getGridData("grid");

 		ccti0090_Service.cctr0100_doStop(param, gridData);
 		resp.setResponseMessage(msg.getMessage("0001"));
 	}

 	// 담당자 변경
 	@RequestMapping(value="/CCTR0100/changeContUser")
 	public void cctr0100_changeContUser(EverHttpRequest req, EverHttpResponse resp) throws Exception {
 		Map<String, String> param = req.getFormData();
 		List<Map<String, Object>> gridData = req.getGridData("grid");

 		ccti0090_Service.cctr0100_changeContUser(param, gridData);
 		resp.setResponseMessage(msg.getMessage("0001"));
 	}

 	// 템플릿양식 다운로드
 	@RequestMapping(value="/CCTI0090/getTmplAttFileNum")
	public void getTmplAttFileNum(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		String attFileNum = "";
		String tmplNum = req.getParameter("tmplNum");

		List<Map<String, String>> codeCombo = commonComboService.getCodeCombo("NH000004");
		for (Map<String, String> code : codeCombo) {
			if(code.get("value").equals(tmplNum)) {
				attFileNum = code.get("ATT_FILE_NUM");
				break;
			}
		}
		resp.setParameter("attFileNum", attFileNum);
	} 	
 	
 	// ERP 계약전송
 	@RequestMapping(value="/CCTR0100/doSendErp")
 	public void cctr0100_doSendErp(EverHttpRequest req, EverHttpResponse resp) throws Exception {
 		Map<String, String> param = req.getFormData();
 		List<Map<String, Object>> gridData = req.getGridData("grid");
 		contsenderpservice.sendErp(gridData.get(0));
 		resp.setResponseMessage(msg.getMessage("0001"));
 	}
 	
 	// CCTR0120 : 개인근로자현황
  	@RequestMapping(value = "/CCTR0120/view")
  	public String cctr0120_view(EverHttpRequest req, EverHttpResponse resp) throws Exception {

  		// =============== 관리자 여부 ==================== //
  		UserInfo userInfo = UserInfoManager.getUserInfo();
  		boolean havePermission = EverString.nullToEmptyString(userInfo.getSuperUserFlag()).equals("1");
  		req.setAttribute("havePermission", havePermission);

  		req.setAttribute("fromDate", EverDate.addMonths(-1));
  		req.setAttribute("toDate", EverDate.getDate());

  		return "/nhepro/CCTR/CCTR0120";
  	}
  	
  	// CCTR0120 : 개인근로자현황 조회
  	@RequestMapping(value = "/CCTR0120/doSearch")
 	public void cctr0120_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {

 		Map<String, String> param = req.getFormData();
 		resp.setGridObject("grid", ccti0090_Service.cctr0120_doSearch(param));
 	}
  	
  	// 2021.03.02 프로세스 추가
  	// 개인근로자 승인/반려
  	@RequestMapping(value="/CCTR0120/cctr0120_doConfirm")
  	public void cctr0120_doConfirm(EverHttpRequest req, EverHttpResponse resp) throws Exception {
  		
  		Map<String, String> param = req.getFormData();
  		String progressCd = EverString.nullToEmptyString(req.getParameter("progressCd"));
  		param.put("PROGRESS_CD", progressCd);
  		
  		List<Map<String, Object>> gridData = req.getGridData("grid");

  		ccti0090_Service.cctr0120_doConfirm(param, gridData);
  		resp.setResponseMessage(msg.getMessage("0001"));
  	}
}

