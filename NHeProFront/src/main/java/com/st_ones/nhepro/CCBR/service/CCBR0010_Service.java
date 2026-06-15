package com.st_ones.nhepro.CCBR.service;

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
import com.st_ones.nhepro.CCBR.CCBR0010_Mapper;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2014 ST-Ones CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : CCBR0010_Service.java
 * @date 2024. 4. 01.
 * @version 1.0
 */
@Service(value = "ccbr0010_Service")
public class CCBR0010_Service extends BaseService {

    @Autowired private MessageService msg;
    @Autowired private DocNumService docNumService;
    @Autowired private BAPM_Service approvalService;
    @Autowired private EverMailService everMailservice;
    @Autowired private EverSmsService everSmsService;
    @Autowired private CCBR0010_Mapper ccbr_Mapper;


    
    /**
     * 화면명 : 계약수수료청구내역
     * 처리내용 : 계약수수료청구내역 조회(농협파트너스 외 고객사)
     * 경로 : 고객사 > 마감관리 > 마감관리 > 계약수수료청구내역
     */
    public List<Map<String, Object>> ccbr0010_doSearch(Map<String, String> param) throws Exception {
        return ccbr_Mapper.ccbr0010_doSearch(param);
    }
    
    public Map<String, Object> ccbr0010_doSearchSUM(Map<String, String> param) throws Exception {
    	return ccbr_Mapper.ccbr0010_doSearchSUM(param);
    }
    
    /**
     * 화면명 : 계약수수료청구내역
     * 처리내용 : 계약수수료청구내역 조회(농협파트너스 고객사)
     * 경로 : 고객사 > 마감관리 > 마감관리 > 계약수수료청구내역
     */
    public List<Map<String, Object>> ccbr0010_doSearchPT(Map<String, String> param) throws Exception {
        return ccbr_Mapper.ccbr0010_doSearchPT(param);
    }
    
    public Map<String, Object> ccbr0010_doSearchPTSUM(Map<String, String> param) throws Exception {
    	return ccbr_Mapper.ccbr0010_doSearchPTSUM(param);
    }
    
    /**
     * 화면명 : SMS수수료청구내역
     * 처리내용 : SMS수수료청구내역(농협파트너스 외 고객사)
     * 경로 : 경로 : 고객사 > 마감관리 > 마감관리 > SMS수수료청구내역
     */
    public List<Map<String, Object>> ccbr0020_doSearchSMS(Map<String, String> param) throws Exception {
        return ccbr_Mapper.ccbr0020_doSearchSMS(param);
    }
    
    public Map<String, Object> ccbr0020_doSearchSMSSUM(Map<String, String> param) throws Exception {
    	return ccbr_Mapper.ccbr0020_doSearchSMSSUM(param);
    }  
    
    /**
     * 화면명 : SMS수수료청구내역
     * 처리내용 : SMS수수료청구내역 조회(농협파트너스 고객사)
     * 경로 : 고객사 > 마감관리 > 마감관리 > SMS수수료청구내역
     */
    public List<Map<String, Object>> ccbr0020_doSearchSMSPT(Map<String, String> param) throws Exception {
        return ccbr_Mapper.ccbr0020_doSearchSMSPT(param);
    }
    
    public Map<String, Object> ccbr0020_doSearchSMSPTSUM(Map<String, String> param) throws Exception {
    	return ccbr_Mapper.ccbr0020_doSearchSMSPTSUM(param);
    }

}