package com.st_ones.common.code.web;

import com.st_ones.common.code.service.CodeService;
import com.st_ones.common.combo.service.CommonComboService;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

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
 * @File Name : CodeController.java
 * @date 2013. 08. 27.
 * @version 1.0
 * @see
 */
@Controller
@RequestMapping(value = "/common/code")
public class CodeController extends BaseController {

	@Autowired private CodeService codeService;

	@Autowired private CommonComboService commonComboService;

	@RequestMapping(value = "/codeList/view")
	public String codeList(EverHttpRequest req) throws Exception {
		req.setAttribute("languageList", commonComboService.getCodeCombo("M001"));
		return "/common/code/codeList";
	}

	@RequestMapping(value = "/doSearchHD")
	public void doSearchHD(EverHttpRequest req, EverHttpResponse resp) throws Exception {
		Map<String, String> param = req.getFormData();
		resp.setGridObject("gridHD", codeService.doSearchHD(param));
	}

	@RequestMapping(value = "/doSaveHD")
	public void doSaveHD(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		List<Map<String, Object>> gridHDData = req.getGridData("gridHD");
		String msg = codeService.doSaveHD(gridHDData);

		resp.setResponseMessage(msg);
	}

	@RequestMapping(value = "/doDeleteHD")
	public void doDeleteHD(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		List<Map<String, Object>> gridHDData = req.getGridData("gridHD");
		String msg = codeService.doDeleteHD(gridHDData);

		resp.setResponseMessage(msg);
	}

	@RequestMapping(value = "/doSearchDT")
	public void doSearchDT(EverHttpRequest req, EverHttpResponse resp) throws Exception {
		Map<String, String> param = req.getFormData();
		resp.setGridObject("gridDT", codeService.doSearchDT(param));
	}

	@RequestMapping(value = "/doSaveDT")
	public void doSaveDT(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		List<Map<String, Object>> gridDTData = req.getGridData("gridDT");
		String msg = codeService.doSaveDT(gridDTData);

		resp.setResponseMessage(msg);
	}

	@RequestMapping(value = "/doDeleteDT")
	public void doDeleteDT(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		List<Map<String, Object>> gridDTData = req.getGridData("gridDT");
		String msg = codeService.doDeleteDT(gridDTData);

		resp.setResponseMessage(msg);
	}

	/**
	 * 화면명 : 우편번호조회
	 * 처리내용 : 우편번호조회
	 * 경로 : 기준정보 > 공급사/사용자 관리 > 공급사 관리 > 공급사 등록/상세 (팝업) > 우편번호조회
	 * 경로 : 주문관리 > 주문관리 > 주문진행 현황 > 주문정보변경 (팝업) > 우편번호
	 * 경로 : 고객사 > Admin > Admin > 회사정보 조회
	 */
	@RequestMapping(value = "/BADV_020/view")
	public String zipCode(EverHttpRequest req) throws Exception {
        req.setAttribute("sslFlag", PropertiesManager.getBoolean("ever.ssl.use.flag"));
        // req.setAttribute("useDaumApi", PropertiesManager.getBoolean("zipCode.outApi.use.flag"));
		return "/common/code/BADV_021";
	}

	@RequestMapping(value = "/BADV_022/view")
	public String mobileZipCode(EverHttpRequest req) throws Exception {
		req.setAttribute("sslFlag", PropertiesManager.getBoolean("ever.ssl.use.flag"));
		// req.setAttribute("useDaumApi", PropertiesManager.getBoolean("zipCode.outApi.use.flag"));
		return "/common/code/BADV_022";
	}

	@RequestMapping(value = "/zipCode/doSearchByStreet")
	public void doSearchByStreet(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		Map<String, String> param = req.getFormData();
		String conditionStreet = param.get("conditionStreet");

		if (conditionStreet.equals("1")) {
			resp.setGridObject("gridStreet", codeService.doSearchByStreet1(param));
		} else if (conditionStreet.equals("2")) {
			resp.setGridObject("gridStreet", codeService.doSearchByStreet2(param));
		} else if (conditionStreet.equals("3")) {
			resp.setGridObject("gridStreet", codeService.doSearchByStreet3(param));
		}
	}

	@RequestMapping(value = "/zipCode/doSearchByDistrict")
	public void doSearchByDistrict(EverHttpRequest req, EverHttpResponse resp) throws Exception {
		Map<String, String> param = req.getFormData();
		resp.setGridObject("gridDistrict", codeService.doSearchByDistrict(param));
	}

}