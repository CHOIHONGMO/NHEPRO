package com.st_ones.eversrm.manager.basic.web;

import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.eversrm.manager.basic.service.MBSA0030_Service;
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
 * @File Name : MBSA0030_Controller.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

@Controller
@RequestMapping(value = "/eversrm/manager/basic")
public class MBSA0030_Controller extends BaseController {

    @Autowired private MBSA0030_Service mbsa0030_Service;

	/**
	 * 화면명 : 휴일관리
	 * 처리내용 : System에서 사용하는 휴일(Working Day)을 등록/관리한다.
	 * 경로 : 시스템관리 > 기본정보 > 휴일관리
	 */
    @RequestMapping(value="/MBSA0030/view")
    public String MBSA0030(EverHttpRequest req) {
        return "/eversrm/manager/basic/MBSA0030";
    }

	@RequestMapping(value = "/mbsa0030_doSearch")
	public void mbsa0030_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
		resp.setGridObject("grid", mbsa0030_Service.mbsa0030_doSearch(req.getFormData()));
	}    

	@RequestMapping(value = "/mbsa0030_doSave")
	public void mbsa0030_doSave(EverHttpRequest req, EverHttpResponse resp) throws Exception {

    	List<Map<String, Object>> gridDatas = req.getGridData("grid");
		String returnMsg = mbsa0030_Service.mbsa0030_doSave(gridDatas);

		resp.setResponseMessage(returnMsg);
	}	

	@RequestMapping(value = "/mbsa0030_doDelete")
	public void mbsa0030_doDelete(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		List<Map<String, Object>> gridDatas = req.getGridData("grid");
		String returnMsg = mbsa0030_Service.mbsa0030_doDelete(gridDatas);

		resp.setResponseMessage(returnMsg);
	}

}