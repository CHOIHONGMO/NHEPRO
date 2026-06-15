package com.st_ones.nhepro.CPRA.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.st_ones.common.combo.service.CommonComboService;
import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.common.mail.service.EverMailService;
import com.st_ones.common.util.clazz.EverDate;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.common.util.service.LargeTextService;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.nhepro.CPRA.service.CPRA0040_Service;
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
 * @File Name : CPRA0040_Controller.java
 * @date 2020. 03. 20.
 * @version 1.0
 */
@Controller
@RequestMapping(value = "/nhepro/CPRA")
public class CPRA0040_Controller extends BaseController {

    @Autowired private LargeTextService largeTextService;
	@Autowired private CommonComboService commonComboService;
    @Autowired private CPRA0040_Service cpri_Service;

    @Autowired EverMailService evermailservice;
    @Autowired ContSendErpService contsenderpservice;

    /** ******************************************************************************************
	 * 담당자 지정
	 * @param req
	 * @return
	 * @throws Exception
	 */
    @RequestMapping(value = "/CPRA0040/view")
    public String CPRA0040_view(EverHttpRequest req) throws Exception {
    	
    	UserInfo userInfo = UserInfoManager.getUserInfo();
        boolean havePermission = false;
        
        // 관리자인 경우에만 IT포탈의 구매의뢰건 삭제 가능
        havePermission = EverString.nullToEmptyString(userInfo.getSuperUserFlag()).equals("1") ? true : havePermission;
        
        req.setAttribute("havePermission", havePermission);
		req.setAttribute("reqFromDate", EverDate.addDateMonth(EverDate.getDate(), -1));
		req.setAttribute("reqToDate", EverDate.getDate());
		req.setAttribute("defaultProgressCd", "0");
		
        return "/nhepro/CPRA/CPRA0040";
    }

    @RequestMapping(value = "/CPRA0040/CPRA0040_doSearch")
	public void CPRA0040_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
		Map<String, String> formData = req.getFormData();
		resp.setGridObject("grid", cpri_Service.CPRA0040_doSearch(formData));
	}

    @RequestMapping(value = "/CPRA0040/CPRA0040_doChangeCtrl")
  	public void CPRA0040_doChangeCtrl(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	Map<String, String> formData = req.getFormData();
    	List<Map<String, Object>> gridDatas = req.getGridData("grid");
    	
		String rtnMsg = cpri_Service.CPRA0040_doChangeCtrl(formData, gridDatas);
		resp.setResponseMessage(rtnMsg);
    }

    @RequestMapping(value = "/CPRA0040_doSearchCtrlUserNm")
    public void CPRA0040_doSearchCtrlUserNm(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> formData = req.getFormData();
        
        String rtnMsg = cpri_Service.cpra0040_doSearchCtrlUserNm(formData);
        resp.setResponseMessage(rtnMsg);
    }
    
    /**
     * IT포탈 구매의뢰건 삭제
     * @param req
     * @param resp
     * @throws Exception
     */
    @RequestMapping(value = "/CPRA0040/cpra0040_doDelete")
  	public void cpra0040_doDelete(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	Map<String, String> formData = req.getFormData();
    	List<Map<String, Object>> gridDatas = req.getGridData("grid");
    	
		String rtnMsg = cpri_Service.cpra0040_doDelete(formData, gridDatas);
		resp.setResponseMessage(rtnMsg);
    }
    
	/** ******************************************************************************************
	 * 구매요청 접수
	 * @param req
	 * @return
	 * @throws Exception
	 */
    @RequestMapping(value = "/CPRA0050/view")
    public String CPRA0050_view(EverHttpRequest req) throws Exception {
		req.setAttribute("reqFromDate", EverDate.addDateMonth(EverDate.getDate(), -1));
		req.setAttribute("reqToDate", EverDate.getDate());
		req.setAttribute("rfxTypeOptions", commonComboService.getCodeComboAsJson("CB0063"));
		req.setAttribute("defaultProgressCd", "0");
        return "/nhepro/CPRA/CPRA0050";
    }

	@RequestMapping(value = "/CPRA0050/CPRA0050_doSearch")
	public void CPRA0050_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		Map<String,String> param = new HashMap<String,String>();
		param.put("BUYER_CD", "C00009");
		param.put("CONT_NUM", "EC20200500034");
		param.put("CONT_CNT", "1");

		Map<String, String> formData = req.getFormData();
		formData.put("ASSIGN_YN", EverString.nullToEmptyString(req.getParameter("ASSIGN_YN")).equals("0") ? null : "1");

		resp.setGridObject("grid", cpri_Service.CPRA0050_doSearch(formData));
	}

	@RequestMapping(value = "/CPRA0050/CPRA0050_doReceipt")
	public void CPRA0050_doReceipt(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		List<Map<String, Object>> gridDatas = req.getGridData("grid");

		String rtnMsg = cpri_Service.CPRA0050_doReceipt(gridDatas);
		resp.setResponseMessage(rtnMsg);
	}

	@RequestMapping(value = "/CPRA0050/CPRA0050_doReject")
	public void CPRA0050_doReject(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		String rejectRMK = req.getParameter("REJECT_RMK");
		List<Map<String, Object>> gridDatas = req.getGridData("grid");

		String rtnMsg = cpri_Service.CPRA0050_doReject(rejectRMK, gridDatas);
		resp.setResponseMessage(rtnMsg);
	}

	@RequestMapping(value = "/CPRA0050/CPRA0050_doTrans")
	public void CPRA0050_doTrans(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		String ctrlUserId = req.getParameter("CTRL_USER_ID");
		List<Map<String, Object>> gridDatas = req.getGridData("grid");

		String rtnMsg = cpri_Service.CPRA0050_doTrans(ctrlUserId, gridDatas);
		resp.setResponseMessage(rtnMsg);
	}

	@RequestMapping(value = "/CPRA0050/CPRA0050_doJongPo")
	public void CPRA0050_doJongPo(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		String ctrlUserId = req.getParameter("CTRL_USER_ID");
		List<Map<String, Object>> gridDatas = req.getGridData("grid");

		String rtnMsg = cpri_Service.CPRA0050_doJongPo(ctrlUserId, gridDatas);
		resp.setResponseMessage(rtnMsg);
	}

	/** ******************************************************************************************
	 * IT POTAL
	 * @param req
	 * @return
	 * @throws Exception
	 */
    @RequestMapping(value = "/CPRA0060/view")
    public String CPRA0060_view(EverHttpRequest req) throws Exception {
    	//System.out.println("=======================MNT_YN="+req.getParameter("MNT_YN"));
    	Map<String, String> formData = req.getFormData();
    	formData.put("CM_REQ_ID", req.getParameter("CM_REQ_ID"));
    	req.setAttribute("form", cpri_Service.CPRA0060_Master(formData));
    	return "/nhepro/CPRA/CPRA0060";
    }

	@RequestMapping(value = "/CPRA0060/CPRA0060_doSearchGrid1")
	public void CPRA0060_doSearchGrid1(EverHttpRequest req, EverHttpResponse resp) throws Exception {
		Map<String, String> formData = req.getFormData();
		resp.setGridObject("grid1", cpri_Service.CPRA0060_Grid1(formData));
	}
	@RequestMapping(value = "/CPRA0060/CPRA0060_doSearchGrid2")
	public void CPRA0060_doSearchGrid2(EverHttpRequest req, EverHttpResponse resp) throws Exception {
		Map<String, String> formData = req.getFormData();
		resp.setGridObject("grid2", cpri_Service.CPRA0060_Grid2(formData));
	}
	@RequestMapping(value = "/CPRA0060/CPRA0060_doSearchGrid3")
	public void CPRA0060_doSearchGrid3(EverHttpRequest req, EverHttpResponse resp) throws Exception {
		Map<String, String> formData = req.getFormData();
		resp.setGridObject("grid3", cpri_Service.CPRA0060_Grid3(formData));
	}

	@RequestMapping(value = "/CPRA0060/CPRA0060_doSearchGrid4")
	public void CPRA0060_doSearchGrid4(EverHttpRequest req, EverHttpResponse resp) throws Exception {
		Map<String, String> formData = req.getFormData();
		resp.setGridObject("grid4", cpri_Service.CPRA0060_Grid4(formData));
	}
	@RequestMapping(value = "/CPRA0060/CPRA0060_doSearchGrid5")
	public void CPRA0060_doSearchGrid5(EverHttpRequest req, EverHttpResponse resp) throws Exception {
		Map<String, String> formData = req.getFormData();
		resp.setGridObject("grid5", cpri_Service.CPRA0060_Grid5(formData));
	}
	@RequestMapping(value = "/CPRA0060/CPRA0060_doSearchGrid6")
	public void CPRA0060_doSearchGrid6(EverHttpRequest req, EverHttpResponse resp) throws Exception {
		Map<String, String> formData = req.getFormData();
		resp.setGridObject("grid6", cpri_Service.CPRA0060_Grid6(formData));
	}

}
