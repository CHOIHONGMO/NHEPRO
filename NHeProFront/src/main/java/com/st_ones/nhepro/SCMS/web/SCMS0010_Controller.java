package com.st_ones.nhepro.SCMS.web;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.st_ones.common.combo.service.CommonComboService;
import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.common.util.clazz.EverDate;
import com.st_ones.common.util.clazz.EverMath;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.nhepro.CSTR.service.CSTR0010_Service;


/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2014 ST-Ones CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : CSTR0010_Controller.java
 * @date 2020. 5. 18.
 * @version 1.0
 */
@Controller
@RequestMapping(value = "/nhepro/SCMS")
public class SCMS0010_Controller extends BaseController { 

    @Autowired private CommonComboService commonComboService;

    
    /**
     * 화면명 : 공급사 입찰이력
     * 처리내용 : 입찰이력 조회
     * 경로 : 고객사 > 통계관리 > 통계관리 > 공급사 입찰이력
     */
    @RequestMapping(value="/SCMS0010/view")
    public String cstr0010_view(EverHttpRequest req) throws Exception {

        return "/nhepro/SCMS/SCMS0010";
    }




}