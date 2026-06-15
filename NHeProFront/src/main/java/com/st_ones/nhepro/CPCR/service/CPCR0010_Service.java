package com.st_ones.nhepro.CPCR.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
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
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.common.util.service.LargeTextService;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.eversrm.eApproval.eApprovalEnd.AP.EApprovalEndAp_Mapper;
import com.st_ones.eversrm.eApproval.eApprovalModule.service.BAPM_Service;
import com.st_ones.nhepro.CPCR.CPCR0010_Mapper;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : CAPR0010_Service.java
 * @date 2018. 01. 30.
 * @version 1.0
 */

@Service(value = "CPCR0010_Service")
public class CPCR0010_Service extends BaseService {

    @Autowired MessageService msg;
    @Autowired CPCR0010_Mapper cpcr0010_mapper;
    @Autowired LargeTextService largeTextService;
    
    Logger logger = LoggerFactory.getLogger(this.getClass());
    
    /**
     * 화면명 : 대금지급현황
     * 처리내용 : 대금지급요청 현황을 조회하여 심사 및 지급내역을 등록하는 화면
     * 경로 : 고객사 > 발주관리 > 대금지급 > 대금지급현황
     */
    public List<Map<String, Object>> cpcr0010_doSearch(Map<String, String> param) {

        return cpcr0010_mapper.cpcr0010_doSearch(param);
    }

}
