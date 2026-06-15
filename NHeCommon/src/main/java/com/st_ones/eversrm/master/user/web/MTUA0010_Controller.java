package com.st_ones.eversrm.master.user.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.everf.serverside.exception.EverException;
import com.st_ones.everf.serverside.info.BaseInfo;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.eversrm.master.user.service.MTUA0010_Service;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : MTUA0010_Controller.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

@Controller
@RequestMapping(value = "/eversrm/master/user")
public class MTUA0010_Controller extends BaseController {

	@Autowired private MessageService msg;

	@Autowired private MTUA0010_Service mtua0010_Service;

	/**
	 * 화면명 : 사용자정보
	 * 처리내용 : 시스템에서 사용할 사용자정보를 조회/관리하는 화면.
	 * 경로 : 시스템관리 > 사용자관리 > 사용자정보
	 */
	@RequestMapping(value = "/MTUA0010/view")
	public String MTUA0010(EverHttpRequest req) {

		BaseInfo baseInfo = (BaseInfo)req.getSession().getAttribute("ses");

        if (EverString.nullToEmptyString(baseInfo.getSuperUserFlag()).equals("0")) {
           // return "/eversrm/noSuperAuth";
        }
		return "/eversrm/master/user/MTUA0010";
	}

	@RequestMapping(value = "/MTUA0010/doSearchUser")
	public void mtua0010_doSearchUser(EverHttpRequest req, EverHttpResponse resp, @RequestParam(value = "userType") String userType) throws Exception {

		Map<String, String> formDataL = req.getFormData();
		
		if("T".equals(String.valueOf(formDataL.get("USER_TYPE_SEARCH"))))//2022.10.24 개인근로자(파트너스) 로직 처리
		{
			resp.setGridObject("sGrid", mtua0010_Service.mtua0010_doSearchUserEmp(formDataL));
		}else {
			resp.setGridObject("sGrid", mtua0010_Service.mtua0010_doSearchUser(formDataL));
		}
		
	}

	@RequestMapping(value = "/MTUA0010/doGetUser")
	public void mtua0010_doGetUser(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		Map<String, String> formDataR = req.getFormData();

		Map<String, Object> userMap;
		if("O".equals(String.valueOf(formDataR.get("GRID_USER_TYPE")))){	// B:구매사, S:협력사 , O : OPER , T: 개인근로자(파트너스)
			userMap = mtua0010_Service.doGetUser(formDataR);
		}else if("T".equals(String.valueOf(formDataR.get("GRID_USER_TYPE")))){	// B:구매사, S:협력사 , O : OPER , T: 개인근로자(파트너스)
			userMap = mtua0010_Service.doGetUserTVUR(formDataR);
		}else {
			userMap = mtua0010_Service.doGetUser_VNGL(formDataR);
		}

		String[] userColumns = {
				"GATE_CD"
				, "USER_ID"
				, "USER_ID_ORI"
				, "MOD_DATE_LAST"
				, "MOD_DATE"
				, "MOD_USER_ID"
				, "MOD_USER_NM"
				, "CHANGE_USER_ID"
				, "DEL_FLAG"
				, "USE_FLAG"
				, "COMPANY_CD"
				, "USER_TYPE"
				, "WORK_TYPE"
				, "USER_NM"
				, "USER_NM_ENG"
				, "PASSWORD"
				, "PASSWORD_CHECK"
				, "TMP_WORD"
				, "TMP_WORD_CHK"
				, "DEPT_CD"
				, "POSITION_NM"
				, "DUTY_NM"
				, "EMPLOYEE_NUM"
				, "EMAIL"
				, "TEL_NUM"
				, "CELL_NUM"
				, "FAX_NUM"
				, "COUNTRY_CD"
				, "PROGRESS_CD"
				, "PW_WRONG_CNT"
				, "PW_RESET_FLAG"
				, "PW_RESET_DATE"
				, "LAST_LOGIN_DATE"
				, "LAST_LOGIN_TIME"
				, "IP_ADDR"
				, "COMPANY_NM"
				, "DEPT_NM"
				, "INSERT_FLAG"
				, "SUPER_USER_FLAG"
				, "PROGRESS_CD"
				, "USER_DATE_FORMAT_CD"
				, "USER_NUMBER_FORMAT_CD"
		};

		if(userMap != null) {
			for (int i = 0; i < userColumns.length; i++) {
				if (!userMap.containsKey(userColumns[i])) {
					userMap.put(userColumns[i], "");
				}
			}
		}
		resp.setFormDataObject(userMap);
	}

	@RequestMapping(value = "/MTUA0010/doGetProfile")
	public void mtua0010_doGetProfile(EverHttpRequest req, EverHttpResponse resp, @RequestParam(value = "userType") String userType) throws Exception {

		Map<String, String> formData = req.getFormData(); // <--formR
		formData.put("userType", userType);

		resp.setGridObject("acGrid", mtua0010_Service.doGetAcProfile(formData));
		resp.setGridObject("auGrid", mtua0010_Service.doGetAuProfile(formData));
	}

	@RequestMapping(value = "/MTUA0010/checkPass")
	public void mtua0010_checkPass(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		Map<String, String> formR = req.getFormData();
		String pwd = EverString.nullToEmptyString(formR.get("PASSWORD")).trim();
		String pwdChk = EverString.nullToEmptyString(formR.get("PASSWORD_CHECK")).trim();

		String strMsg = "";
		String userId = formR.get("USER_ID");
		String userIdOri = formR.get("USER_ID_ORI");

		if(! userId.equals(userIdOri)) {
			if(pwd.length() <= 0 || pwdChk.length() <= 0) {
				throw new EverException(msg.getMessageByScreenId("MSI_080", "006"));
			}
		}

		if(! pwd.equals(pwdChk)) {
			throw new EverException(msg.getMessageByScreenId("MSI_080", "004"));
		}

		if (pwd.equals(pwdChk)) {
			resp.setParameter("PASSWORD", pwd);
			resp.setParameter("chkFlag", "true");
		} else {
			resp.setParameter("PASSWORD", "");
			resp.setParameter("chkFlag", "false");
			strMsg = msg.getMessage("0028");
		}
		resp.setResponseMessage(strMsg);
	}

	@RequestMapping(value = "/MTUA0010/doResetLast")
	public void mtua0010_doResetLast(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		Map<String, String> formR = req.getFormData();
		String msg = mtua0010_Service.doResetUserInfo(formR);

		resp.setResponseMessage(msg);
	}


	// 비밀번호초기화
	@RequestMapping(value = "/MTUA0010/doInitPassword")
	public void mtua0010_doInitPassword(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		Map<String, String> form = req.getFormData();
		String msg = mtua0010_Service.doInitPassword(form);

		resp.setResponseMessage(msg);
	}

	// 비밀번호초기화 -협력,고객사
	@RequestMapping(value = "/MTUA0010/doInitPassword_CVUR")
	public void mtua0010_doInitPassword_CVUR(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		Map<String, String> form = req.getFormData();
		String gridFlag = req.getParameter("gridFlag");

		if(!"Y".equals(gridFlag)) {
			mtua0010_Service.doInitPassword_CVUR(form);
		} else {

			List<Map<String, Object>> gridData = req.getGridData("grid");

			for(Map<String, Object> grid : gridData) {
				grid.put("USER_ID", grid.get("USER_ID_$TP"));
				Map<String, String> parseGrid = new HashMap<String, String>((Map) grid);
				
				mtua0010_Service.doInitPassword_CVUR(parseGrid);
			}
		}
		resp.setResponseMessage(msg.getMessage("0094"));
	}
	
	// 2022.12.07 비밀번호초기화 -개인근로자- 파트너스
		@RequestMapping(value = "/MTUA0010/doInitPassword_TVUR")
		public void mtua0010_doInitPassword_TVUR(EverHttpRequest req, EverHttpResponse resp) throws Exception {

			Map<String, String> form = req.getFormData();
			String gridFlag = req.getParameter("gridFlag");

			if(!"Y".equals(gridFlag)) {
				mtua0010_Service.doInitPassword_TVUR(form);
			} else {

				List<Map<String, Object>> gridData = req.getGridData("grid");

				for(Map<String, Object> grid : gridData) {
					grid.put("USER_ID", grid.get("USER_ID_$TP"));
					Map<String, String> parseGrid = new HashMap<String, String>((Map) grid);
					
					mtua0010_Service.doInitPassword_TVUR(parseGrid);
				}
			}
			resp.setResponseMessage(msg.getMessage("0094"));
		}

	@RequestMapping(value = "/MTUA0010/doSaveUserInfo")
	public void mtua0010_doSaveUserInfo(EverHttpRequest req, EverHttpResponse resp, @RequestParam(value = "mode") String mode) throws Exception {

		Map<String, String> formR = req.getFormData();
		List<Map<String, Object>> auGridData = req.getGridData("auGrid");
		List<Map<String, Object>> acGridData = req.getGridData("acGrid");
		String userId = formR.get("USER_ID");
		String userIdOri = formR.get("USER_ID_ORI");
		String passWord = EverString.nullToEmptyString(formR.get("PASSWORD")).trim();

		String passWordCheck = EverString.nullToEmptyString(formR.get("PASSWORD_CHECK")).trim();

		@SuppressWarnings("hiding")
		String msgString = "";
		if (mode.equals("I") && !userId.equals(userIdOri)) {

			if(passWord.length() <= 0 || passWordCheck.length() <= 0) {
				throw new EverException(msg.getMessageByScreenId("MSI_080", "006"));
			}
			if(! passWord.equals(passWordCheck)) {
				throw new EverException(msg.getMessageByScreenId("MSI_080", "004"));
			}
			// STOCUSER insert
			msgString = mtua0010_Service.doInsertUserInfo(formR, auGridData, acGridData);
			if (!msg.equals("confirm")) {
				resp.setParameter("checkResult", "");
			} else {
				resp.setParameter("checkResult", msgString);
			}
		} else {
			if(! passWord.equals(passWordCheck)) {
				throw new EverException(msg.getMessageByScreenId("MSI_080", "004"));
			}
			// STOCUSER update
			msgString = mtua0010_Service.doUpdateUserInfo(formR, auGridData, acGridData);
		}
		resp.setResponseMessage(msgString);
	}

	@RequestMapping(value = "/MTUA0010/doSaveUserInfo_VNGL")
	public void mtua0010_doSaveUserInfo_VNGL(EverHttpRequest req, EverHttpResponse resp, @RequestParam(value = "mode") String mode) throws Exception {

		Map<String, String> formR = req.getFormData();
		List<Map<String, Object>> auGridData = req.getGridData("auGrid");
		String userId = formR.get("USER_ID");
		String userIdOri = formR.get("USER_ID_ORI");
		String passWord = EverString.nullToEmptyString(formR.get("PASSWORD")).trim();
		String passWordCheck = EverString.nullToEmptyString(formR.get("PASSWORD_CHECK")).trim();

		String msgString = "";
		if (mode.equals("I") && !userId.equals(userIdOri)) {
			if(passWord.length() <= 0 || passWordCheck.length() <= 0) {
				throw new EverException(msg.getMessageByScreenId("MSI_080", "006"));
			}
			if(! passWord.equals(passWordCheck)) {
				throw new EverException(msg.getMessageByScreenId("MSI_080", "004"));
			}
			// STOCUSER insert
			msgString = mtua0010_Service.doInsertUserInfo_VNGL(formR, auGridData);
			if (!msg.equals("confirm")) {
				resp.setParameter("checkResult", "");
			} else {
				resp.setParameter("checkResult", msgString);
			}
		} else {
			if(! passWord.equals(passWordCheck)) {
				throw new EverException(msg.getMessageByScreenId("MSI_080", "004"));
			}
			// STOCUSER update
			msgString = mtua0010_Service.doUpdateUserInfo_VNGL(formR, auGridData);
		}
		resp.setResponseMessage(msgString);
	}

	@RequestMapping(value = "/MTUA0010/doDeleteUser")
	public void doDeleteUserInfo(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		Map<String, String> formR = req.getFormData();
		String msg = mtua0010_Service.doDeleteUserInfo(formR);

		resp.setResponseMessage(msg);
	}

	@RequestMapping(value = "/MTUA0012/view")
	public String passwordNumberIssue(EverHttpRequest req) throws Exception {
		req.setAttribute("form", req.getParamDataMap());
		return "/eversrm/master/user/MTUA0012";
	}

	// 비밀번호변경
	@RequestMapping(value = "/MTUA0012/mtua0012_doSave")
	public void doSaveIssue(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		Map<String, String> form = req.getFormData();
		String msg = mtua0010_Service.doSaveIssue(form);

		resp.setResponseMessage(msg);
	}

	@RequestMapping(value = "/MTUA0012/mtua0012_doSave_CVUR")
	public void doSaveIssue_CVUR(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		Map<String, String> form = req.getFormData();
		String msg = mtua0010_Service.doSaveIssue_CVUR(form);

		resp.setResponseMessage(msg);
	}
	//개인근로자_지정 비밀번호 등록 추가
	@RequestMapping(value = "/MTUA0012/mtua0012_doSave_TVUR")
	public void doSaveIssue_TVUR(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		Map<String, String> form = req.getFormData();
		String msg = mtua0010_Service.doSaveIssue_TVUR(form);

		resp.setResponseMessage(msg);
	}
}