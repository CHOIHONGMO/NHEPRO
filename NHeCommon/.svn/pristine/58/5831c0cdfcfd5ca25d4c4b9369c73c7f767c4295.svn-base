package com.st_ones.eversrm.manager.system.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.transaction.TransactionRolledbackException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.st_ones.common.combo.service.CommonComboService;
import com.st_ones.everf.serverside.info.BaseInfo;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.eversrm.manager.system.service.MSYB0010_Service;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : MSYB0010_Controller.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

@Controller
@RequestMapping(value = "/eversrm/manager/system")
public class MSYB0010_Controller extends BaseController {

	@Autowired private CommonComboService commonComboService;

	@Autowired private MSYB0010_Service msyb0010_Service;

	/**
	 * 화면명 : 공통팝업관리
	 * 처리내용 : 시스템에서 사용할 공통팝업(싱글/멀티), 콤보박스들을 관리하는 화면.
	 * 경로 : 시스템관리 > 시스템 > 공통팝업관리
	 */
	@RequestMapping(value = "/MSYB0010/view")
	public String MSYB0010(EverHttpRequest req) throws Exception {

		/* 관리자 권한이 존재하지 않으면 접속 불가 */
		BaseInfo baseInfo = (BaseInfo)req.getSession().getAttribute("ses");
		if (baseInfo.getSuperUserFlag().equals("0") || ! baseInfo.getUserType().equals("B")) {
//			return "/eversrm/noSuperAuth";
		}

		String common_id = req.getParameter("COMMON_ID");
		String database_cd = req.getParameter("DATABASE_CD");

		if ( common_id != null && !"".equals(common_id) ) {
			Map<String, String> param = new HashMap<String,String>();
			param.put("COMMON_ID", common_id);
			param.put("DATABASE_CD", database_cd);

			Map<String, String> data = msyb0010_Service.getComboDetailInfo(param);
			if(data == null) {
				data = new HashMap<String,String>();
				data.put("DATABASE_CD", "OR");
				req.setAttribute("detailData",  data );
			} else {
				// 콤보의 경우 LIST_ITEM_CD 에 \r 이 들어오기 때문에 파싱 에러가 나서 치환...
				if ("\r".equals(data.get("LIST_ITEM_CD"))) {
					data.put("LIST_ITEM_CD", "");
				}
				req.setAttribute("detailData",  data );
			}
		} else {
			Map<String, String> param = new HashMap<String,String>();
			param.put("DATABASE_CD", "OR");
			req.setAttribute("detailData",  param );
		}

		req.setAttribute("langData", commonComboService.getCodeComboAsJson("M001"));
		req.setAttribute("maskType", commonComboService.getCodeComboAsJson("M247"));

		return "/eversrm/manager/system/MSYB0010";
	}

	@RequestMapping(value = "/MSYB0010/doSave")
	public void msyb0010_doSave(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		Map<String, String> param = req.getFormData();

		if (!param.get("TYPE_CD").equals("CB")) {
			List<Map<String, Object>> gridData2 = req.getGridData("grid2");
			List<Map<String, Object>> gridData3 = req.getGridData("grid3");

			if (gridData2.size() > 0 && gridData2 != null) {
				gridData2.get(0).put("MULTI_NM", param.get("LIST_ITEM_TEXT"));
				msyb0010_Service.multiLanguageCommonPopupDoSave(gridData2.get(0));
			}

			if (gridData3.size() > 0 && gridData3 != null) {
				gridData3.get(0).put("MULTI_NM", param.get("SEARCH_CONDITION_TEXT"));
				msyb0010_Service.multiLanguageCommonPopupDoSave(gridData3.get(0));
			}
		}

		String rtnMsg = msyb0010_Service.doSaveCommonCodeSql(param);

		resp.setResponseMessage(rtnMsg);
	}

	@RequestMapping(value = "/MSYB0010/doDelete")
	public void msyb0010_doDelete(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		Map<String, String> param = req.getFormData();
		String rtnMsg = msyb0010_Service.doDeleteCommonCodeSql(param);

		resp.setResponseMessage(rtnMsg);
	}

	@RequestMapping(value = "/MSYB0010/doVerify")
	public void msyb0010_doVerify(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		Map<String, String> param = req.getFormData();
		String sqlText = param.get("SQL_TEXT").toUpperCase();

		getLog().error(sqlText);
		sqlText = sqlText.replaceAll("#[._0-9a-zA-Z]*#", "''");
		sqlText = sqlText.replaceAll("<ARG.*>", "");
		sqlText = sqlText.replaceAll("</ARG.>", "");
		getLog().error(sqlText);
		param.put("SQL_TEXT", sqlText);

		try {
			msyb0010_Service.doVerifyCommonCodeSql(param);
		} catch (TransactionRolledbackException e) {
			throw e;
		}
		resp.setResponseCode("0001");
	}

}