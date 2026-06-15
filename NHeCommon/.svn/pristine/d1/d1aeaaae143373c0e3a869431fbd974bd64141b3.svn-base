package com.st_ones.eversrm.manager.auth.web;

import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.eversrm.manager.auth.service.MAUA0010_Service;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;
import java.util.Map;

/**
 * <pre>
 * *****************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 * *****************************************************************************
 * </pre>
 *
 * @File Name : MAUA0010_Controller.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

@Controller
@RequestMapping(value = "/eversrm/manager/auth/MAUA0010/")
public class MAUA0010_Controller extends BaseController {

    @Autowired private MAUA0010_Service maua0010_Service;

    /**
     * 화면명 : 직무관리/직무별-사용자매핑
     * 처리내용 : 직무를 조회/관리하며, 등록된 직무에 사용자를 매핑하여 권한을 부여할 수 있다.
     * 경로 : 시스템관리 > 기본정보 > 직무관리/직무별-사용자매핑
     */
    @RequestMapping(value = "view")
    public String MAUA0010(EverHttpRequest req) {
        /* 관리자 권한이 존재하지 않으면 접속 불가 */
        if (!PropertiesManager.getBoolean("eversrm.system.developmentFlag")) {
            UserInfo userInfo = UserInfoManager.getUserInfo();
            if (!userInfo.isSuperUser() || !userInfo.isOperator()) {
//                return "/eversrm/noSuperAuth";
            }
        }
        return "/eversrm/manager/auth/MAUA0010";
    }

    @RequestMapping(value = "selectTaskCode")
    public void selectTaskCode(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	
        resp.setGridObject("grid", maua0010_Service.selectTaskCode(req.getFormData()));
    }
    
    @RequestMapping(value = "selectMappingCust")
    public void selectMappingCust(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	
        resp.setGridObject("gridCUST", maua0010_Service.selectMappingCust(req.getFormData()));
    }
    
    @RequestMapping(value = "selectMappingUser_add")
    public void selectMappingUser(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	
        resp.setGridObject("gridDT", maua0010_Service.selectMappingUser_add(req.getFormData()));
    }

    @RequestMapping(value = "saveTaskCode")
    public void saveTaskCode(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        List<Map<String, Object>> gridData = req.getGridData("grid");
        String msg = maua0010_Service.saveTaskCode(gridData);

        resp.setResponseMessage(msg);
    }

    @RequestMapping(value = "/deleteTaskCode")
    public void deleteTaskCode(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        List<Map<String, Object>> gridData = req.getGridData("grid");
        String msg = maua0010_Service.deleteTaskCode(gridData);

        resp.setResponseMessage(msg);
    }

    @RequestMapping(value = "/doSaveTaskUser")
    public void doSaveTaskUser(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> form = req.getFormData();
        List<Map<String, Object>> gridDT = req.getGridData("gridDT");

        String msg = maua0010_Service.doSaveTaskUser(form, gridDT);
        resp.setResponseMessage(msg);
    }

    @RequestMapping(value = "/doDeleteTaskUser")
    public void doDeleteTaskUser(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> form = req.getFormData();
        List<Map<String, Object>> gridDT = req.getGridData("gridDT");

        String msg = maua0010_Service.doDeleteTaskUser(form, gridDT);
        resp.setResponseMessage(msg);
    }

}