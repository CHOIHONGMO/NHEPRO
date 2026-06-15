package com.st_ones.eversrm.eApproval.eApprovalModule.web;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.st_ones.common.combo.service.CommonComboService;
import com.st_ones.common.util.service.LargeTextService;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.exception.ApprovalException;
import com.st_ones.everf.serverside.exception.NoResultException;
import com.st_ones.everf.serverside.util.EverString;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.eversrm.eApproval.eApprovalModule.service.BAPM_Service;
import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**  
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며, 
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>  
 * @File Name : BAPM_Controller.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

@Controller
@RequestMapping(value = "/eversrm/eApproval/eApprovalModule")
public class BAPM_Controller extends BaseController {

	@Autowired private BAPM_Service bapm_Service;

	@Autowired private CommonComboService commonComboService;

	@Autowired private LargeTextService largeTextService;

	private Logger logger = LoggerFactory.getLogger(BAPM_Controller.class);

	@RequestMapping(value = "/BAPM_010/view")
	public String pathManagement() throws Exception {
		return "/eversrm/eApproval/eApprovalModule/BAPM_010";
	}

	@RequestMapping(value = "/BAPM_010/selectPath")
	public void selectPath(EverHttpRequest req, EverHttpResponse resp) throws Exception {
		Map<String, String> param = req.getFormData();
    	resp.setGridObject("grid", bapm_Service.selectPath(param));
	}

	@RequestMapping(value = "/BAPM_010/deletePath")
	public void deletePath(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		List<Map<String, Object>> gridDatas = req.getGridData("grid");

		String msg = bapm_Service.deletePath(gridDatas);
		resp.setResponseMessage(msg);
	}

	@RequestMapping(value = "/BAPM_020/view")
	public String pathRegister() throws Exception {
		return "/eversrm/eApproval/eApprovalModule/BAPM_020";
	}

	@RequestMapping(value = "/BAPM_020/selectPathDetail")
	public void selectPathDetail(EverHttpRequest req, EverHttpResponse resp) throws Exception {
		Map<String, String> param = req.getFormData();
    	resp.setGridObject("grid", bapm_Service.selectPathDetail(param));
	}

	@RequestMapping(value = "/BAPM_020/insertPath")
	public void insertPath(EverHttpRequest req, EverHttpResponse resp) throws Exception {

    	Map<String, String> param = req.getFormData();
		List<Map<String, Object>> gridDatas = req.getGridData("grid");

		String msg = bapm_Service.insertPath(param, gridDatas);
		resp.setResponseMessage(msg);
	}

	@RequestMapping(value = "/BAPM_020/updatePath")
	public void updatePath(EverHttpRequest req, EverHttpResponse resp) throws Exception {

    	Map<String, String> param = req.getFormData();
		List<Map<String, Object>> gridDatas = req.getGridData("grid");

		String msg = bapm_Service.updatePath(param, gridDatas);
		resp.setResponseMessage(msg);
	}

	@RequestMapping(value = "/BAPP_030/view")
	protected String pathSearch(EverHttpRequest req) throws Exception {
        ObjectMapper om1 = new ObjectMapper();
		req.setAttribute("approvalStatus", om1.writeValueAsString(commonComboService.getCodeCombo("M020")));		

		return "/eversrm/eApproval/eApprovalBox/BAPP_030";
	}

	@RequestMapping(value = "/BAPP_030/selectPathPopup")
	public void selectPathPopup(EverHttpRequest req, EverHttpResponse resp) throws Exception {

    	Map<String, String> param = req.getFormData();
    	param.put("userType", EverString.nullToEmptyString(req.getParameter("userType")));

    	resp.setGridObject("grid", bapm_Service.selectPathPopup(param));
	}

	@RequestMapping(value = "/BAPM_040/view")
	public String myApprovalPathView() {
		return "/eversrm/eApproval/eApprovalModule/BAPM_040";
	}
	
	@RequestMapping(value = "/BAPM_040/getMyPath")
	public void myApprovalPathSelectPath(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	resp.setGridObject("grid", bapm_Service.getMyPath());
	}

    /**
     * 공통으로 사용하는 결재순서 변경 컨트롤러이므로 프로그램 변경 시 아래의 화면을 모두 테스트해야합니다.
     * - 사용하는 화면: 결재요청팝업, 결재경로관리
     * @param req
     * @param resp
     * @throws Exception
     */
    @RequestMapping(value = "/getRealignmentApprovalList")
    public void approvalHelper(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        String sortType = req.getParameter("sortType");
        List<Map<String, Object>> grid = req.getGridData("grid");
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

        } else if(sortType.equals("down")) {
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

        resp.setGridObject("grid", grid);
    }

	@RequestMapping(value = "/approvalRequestPopup/view")
	public String approvalRequestPopupView() {
		return "/eversrm/eApproval/eApprovalModule/approvalRequestPopup";
	}

	@RequestMapping(value = "/BAPP_051/view")
	public String BAPP_051View(EverHttpRequest req) throws Exception {

		Map<String, String> param = new HashMap<String, String>();
		param.put("APP_DOC_NUM", EverString.nullToEmptyString(req.getParameter("appDocNum")));
		param.put("APP_DOC_CNT", EverString.nullToEmptyString(req.getParameter("appDocCnt")));
		param.put("DOC_TYPE", EverString.nullToEmptyString(req.getParameter("docType")));
        
		Map<String, String> formData = bapm_Service.selectApprovalInfoHeader(param);
		formData.put("MY_SIGN_STATUS", bapm_Service.selectMySignStatus(param));
		req.setAttribute("formData", formData);
		return "/eversrm/eApproval/eApprovalBox/BAPP_051";
	}

	@RequestMapping(value = "/BAPP_051/doSearch")
	public void approvalOrRejectPopupDoSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		Map<String, String> formData = bapm_Service.selectApprovalInfoHeader(req.getFormData());
		setContents(resp, formData);
		resp.setFormDataObject(formData);

		List<Map<String, Object>> gridData = bapm_Service.selectApprovalInfoDetail(req.getFormData());
    	resp.setGridObject("grid", gridData);
	}

	@RequestMapping(value = "/BAPP_051/doCancel")
	public void approvalOrRejectPopupDoCancel(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	Map<String, String> param = req.getFormData();

    	if (param == null) {
			throw new NoResultException("form Data is null");
		}

		String message = null;
		try {
			message = bapm_Service.cancelApprovalProcess(param);
			resp.setResponseMessage(message);
		} catch (ApprovalException e) {
			message = e.getMessage();
		}
		resp.setResponseMessage(message);
	}
	
	private void setContents(EverHttpResponse resp, Map<String, String> dataHeader) throws Exception {

		String gateCd    = dataHeader.get("GATE_CD");
		String appDocNum = dataHeader.get("APP_DOC_NUM");
		String appDocCnt = String.valueOf(dataHeader.get("APP_DOC_CNT"));
		String docType   = dataHeader.get("DOC_TYPE");
		
		String consultContentsUrl = PropertiesManager.getString("eversrm.approval.consultContentsUrl." + docType);
		if (!consultContentsUrl.contains("?")) {
			consultContentsUrl += "?";
		}
		//consultContentsUrl += String.format("&gateCd=%s&appDocNum=%s&appDocCnt=%s", gateCd, appDocNum, appDocCnt);
		resp.setParameter("consultContentsUrl", consultContentsUrl);
		resp.setParameter("detailView", "true");
		resp.setParameter("gateCd", gateCd);
		resp.setParameter("appDocNum", appDocNum);
		resp.setParameter("appDocCnt", appDocCnt);
	
	}	

	@RequestMapping(value = "/BAPP_052/view")
	public String eApprovalRemarkPopupView() {
		return "/eversrm/eApproval/eApprovalBox/BAPP_052";
	}

}