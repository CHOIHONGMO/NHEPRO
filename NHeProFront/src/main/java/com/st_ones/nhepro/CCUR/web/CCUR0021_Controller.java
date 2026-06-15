package com.st_ones.nhepro.CCUR.web;

import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.nhepro.CCUR.service.CCUR0021_Service;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.HashMap;
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
 * @File Name : CCUR0021_Controller.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

@Controller
@RequestMapping(value = "/nhepro/CCUR")
public class CCUR0021_Controller extends BaseController {

    @Autowired private CCUR0021_Service ccur0021_service;

    /**
     * 화면명 : 직무관리/직무별-사용자매핑
     * 처리내용 : 직무를 조회/관리하며, 등록된 직무에 사용자를 매핑하여 권한을 부여할 수 있다.
     * 경로 : 시스템관리 > 기본정보 > 직무관리/직무별-사용자매핑
     */
    @RequestMapping(value = "/CCUR0021/view")
    public String CCUR0021(EverHttpRequest req) {
        /* 관리자 권한이 존재하지 않으면 접속 불가 */
        if (!PropertiesManager.getBoolean("eversrm.system.developmentFlag")) {
            UserInfo userInfo = UserInfoManager.getUserInfo();
            if (!userInfo.isSuperUser() || !userInfo.isOperator()) {
//                return "/eversrm/noSuperAuth";
            }
        }
        return "/nhepro/CCUR/CCUR0021";
    }

    @RequestMapping(value = "/CCUR0021/ccur0021_selectTaskCode")
    public void ccur0021_selectTaskCode(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.setGridObject("grid", ccur0021_service.ccur0021_selectTaskCode(req.getFormData()));
    }

    @RequestMapping(value = "/CCUR0021/ccur0021_selectMappingUser_add")
    public void ccur0021_selectMappingUser(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.setGridObject("gridDT", ccur0021_service.ccur0021_selectMappingUser_add(req.getFormData()));
    }

    @RequestMapping(value = "/CCUR0021/ccur0021_saveTaskCode")
    public void ccur0021_saveTaskCode(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        List<Map<String, Object>> gridData = req.getGridData("grid");
        String msg = ccur0021_service.ccur0021_saveTaskCode(gridData);

        resp.setResponseMessage(msg);
    }

    @RequestMapping(value = "/CCUR0021/ccur0021_deleteTaskCode")
    public void ccur0021_deleteTaskCode(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        List<Map<String, Object>> gridData = req.getGridData("grid");
        String msg = ccur0021_service.ccur0021_deleteTaskCode(gridData);

        resp.setResponseMessage(msg);
    }

    @RequestMapping(value = "/CCUR0021/ccur0021_doSaveTaskUser")
    public void ccur0021_doSaveTaskUser(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> form = req.getFormData();
        List<Map<String, Object>> gridDT = req.getGridData("gridDT");

        String msg = ccur0021_service.ccur0021_doSaveTaskUser(form, gridDT);
        resp.setResponseMessage(msg);
    }

    @RequestMapping(value = "/CCUR0021/ccur0021_doDeleteTaskUser")
    public void ccur0021_doDeleteTaskUser(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> form = req.getFormData();
        List<Map<String, Object>> gridDT = req.getGridData("gridDT");

        String msg = ccur0021_service.ccur0021_doDeleteTaskUser(form, gridDT);
        resp.setResponseMessage(msg);
    }


    /**
     * 화면명 : 사용자별-직무매핑
     * 처리내용 : 시스템에 등록된 직무를 사용자에게 매핑하여 권한을 부여할 수 있다.
     * 경로 : 시스템관리 > 기본정보 > 사용자별-직무매핑
     */
    @RequestMapping(value = "/CCUR0022/view")
    public String MAUA0020(EverHttpRequest req) throws Exception {

        // 관리자 권한이 존재하지 않으면 접속 불가
        if (!PropertiesManager.getBoolean("eversrm.system.developmentFlag")) {
            UserInfo userInfo = UserInfoManager.getUserInfo();
            if (!userInfo.isSuperUser() || !userInfo.isOperator()) {
//                return "/eversrm/noSuperAuth";
            }
        }
        // 예외로 컨트롤러에 적용
        return "/nhepro/CCUR/CCUR0022";
    }

    @RequestMapping(value = "/CCUR0022/ccur0022_selectTaskPersonInCharge")
    public void ccur0020_selectTaskPersonInCharge(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.setGridObject("grid", ccur0021_service.ccur0022_selectTaskPersonInCharge(req.getFormData()));
    }

    @RequestMapping(value = "/CCUR0022/ccur0022_saveTaskPersonInCharge")
    public void ccur0020_saveTaskPersonInCharge(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        List<Map<String, Object>> gridData = req.getGridData("grid");
        String msg = ccur0021_service.ccur0022_saveTaskPersonInCharge(gridData);

        resp.setResponseMessage(msg);
    }

    @RequestMapping(value = "/CCUR0022/ccur0022_deleteTaskPersonInCharge")
    public void ccur0020_deleteTaskPersonInCharge(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        List<Map<String, Object>> gridData = req.getGridData("grid");
        String msg = ccur0021_service.ccur0022_deleteTaskPersonInCharge(gridData);

        resp.setResponseMessage(msg);
    }
}