package com.st_ones.eversrm.manager.auth.web;

import com.st_ones.common.combo.service.CommonComboService;
import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.eversrm.manager.auth.service.MAUB0010_Service;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

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
 * @File Name : MAUB0010_Controller.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

@Controller
@RequestMapping(value = "/eversrm/manager/auth")
public class MAUB0010_Controller extends BaseController {

    @Autowired private CommonComboService commonComboService;

    @Autowired private MAUB0010_Service maub0010_Service;

    /**
     * 화면명 : 사용자별-직무매핑 이력
     * 처리내용 : 사용자에게 직무를 매핑한 이력을 조회하는 화면
     * 경로 : 시스템관리 > 기본정보 > 사용자별-직무매핑 이력
     */
    @RequestMapping(value = "/MAUB0010/view")
    public String MAUB0010(EverHttpRequest req) {

        /* 관리자 권한이 존재하지 않으면 접속 불가 */
        if (!PropertiesManager.getBoolean("eversrm.system.developmentFlag")) {
            UserInfo userInfo = UserInfoManager.getUserInfo();
            if (!userInfo.isSuperUser() || !userInfo.isOperator()) {
//                return "/eversrm/noSuperAuth";
            }
        }
        return "/eversrm/manager/auth/MAUB0010";
    }

    @RequestMapping(value = "/doSelect")
    public void doSelect(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.setGridObject("grid", maub0010_Service.doSelect(req.getFormData()));
    }

}