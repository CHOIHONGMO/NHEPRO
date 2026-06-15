package com.st_ones.eversrm.manager.auth.web;

import com.st_ones.common.combo.service.CommonComboService;
import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.eversrm.manager.auth.service.MAUA0020_Service;
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
 * @File Name : MAUA0020_Controller.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

@Controller
@RequestMapping(value = "/eversrm/manager/auth")
public class MAUA0020_Controller extends BaseController {

    @Autowired private CommonComboService commonComboService;

    @Autowired private MAUA0020_Service maua0020_Service;

    /**
     * 화면명 : 사용자별-직무매핑
     * 처리내용 : 시스템에 등록된 직무를 사용자에게 매핑하여 권한을 부여할 수 있다.
     * 경로 : 시스템관리 > 기본정보 > 사용자별-직무매핑
     */
    @RequestMapping(value = "/MAUA0020/view")
    public String MAUA0020(EverHttpRequest req) throws Exception {

        // 관리자 권한이 존재하지 않으면 접속 불가
        if (!PropertiesManager.getBoolean("eversrm.system.developmentFlag")) {
            UserInfo userInfo = UserInfoManager.getUserInfo();
            if (!userInfo.isSuperUser() || !userInfo.isOperator()) {
//                return "/eversrm/noSuperAuth";
            }
        }
        // 예외로 컨트롤러에 적용
        req.setAttribute("refBuyerCode", commonComboService.getCodesAsJson("CB0002", new HashMap<String, String>()));
        return "/eversrm/manager/auth/MAUA0020";
    }

    @RequestMapping(value = "/selectTaskPersonInCharge")
    public void selectTaskPersonInCharge(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.setGridObject("grid", maua0020_Service.selectTaskPersonInCharge(req.getFormData()));
    }

    @RequestMapping(value = "/saveTaskPersonInCharge")
    public void saveTaskPersonInCharge(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        List<Map<String, Object>> gridData = req.getGridData("grid");
        String msg = maua0020_Service.saveTaskPersonInCharge(gridData);

        resp.setResponseMessage(msg);
    }

    @RequestMapping(value = "/deleteTaskPersonInCharge")
    public void deleteTaskPersonInCharge(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        List<Map<String, Object>> gridData = req.getGridData("grid");
        String msg = maua0020_Service.deleteTaskPersonInCharge(gridData);

        resp.setResponseMessage(msg);
    }

}