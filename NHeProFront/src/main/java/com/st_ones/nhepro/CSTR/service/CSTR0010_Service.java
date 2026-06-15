package com.st_ones.nhepro.CSTR.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.st_ones.common.docNum.service.DocNumService;
import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.common.mail.service.EverMailService;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.sms.service.EverSmsService;
import com.st_ones.common.util.clazz.EverCert;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.eversrm.eApproval.eApprovalModule.service.BAPM_Service;
import com.st_ones.nhepro.CSTR.CSTR0010_Mapper;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2014 ST-Ones CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : CSTR0010_Service.java
 * @date 2020. 5. 18.
 * @version 1.0
 */
@Service(value = "cstr0010_Service")
public class CSTR0010_Service extends BaseService {

    @Autowired private MessageService msg;
    @Autowired private DocNumService docNumService;
    @Autowired private BAPM_Service approvalService;
    @Autowired private EverMailService everMailservice;
    @Autowired private EverSmsService everSmsService;
    @Autowired private CSTR0010_Mapper cstr_Mapper;


    
    /**
     * 화면명 : 공급사 입찰이력
     * 처리내용 : 입찰이력 조회
     * 경로 : 고객사 > 통계관리 > 통계관리 > 공급사 입찰이력
     */
    public List<Map<String, Object>> cstr0010_doSearch(Map<String, String> param) throws Exception {
        return cstr_Mapper.cstr0010_doSearch(param);
    }
    
    /**
     * 화면명 : 대금지급이력
     * 처리내용 : 검수 및 대금지급 이력조회
     * 경로 : 고객사 > 통계관리 > 통계관리 > 대금지급이력
     */
    public List<Map<String, Object>> cstr0020_doSearch(Map<String, String> param) throws Exception {
        return cstr_Mapper.cstr0020_doSearch(param);
    } 
    
    /**
     * 화면명 : 공급사 견적이력
     * 처리내용 : 견적이력 조회
     * 경로 : 고객사 > 통계관리 > 통계관리 > 공급사 견적이력
     */
    public List<Map<String, Object>> cstr0030_doSearch(Map<String, String> param) throws Exception {
        return cstr_Mapper.cstr0030_doSearch(param);
    }


}