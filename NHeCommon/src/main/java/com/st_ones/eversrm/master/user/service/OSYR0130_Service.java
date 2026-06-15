package com.st_ones.eversrm.master.user.service;

import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.eversrm.master.user.OSYR0130_Mapper;
import com.st_ones.common.docNum.service.DocNumService;
import com.st_ones.common.message.service.MessageService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

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
 * @File Name : OSYR0130_Service.java
 * @date 2020.02.17
 * @version 1.0
 * @see
 */

@Service(value = "osyr0130_Service")
public class OSYR0130_Service extends BaseService {

    @Autowired private MessageService msg;

    @Autowired private DocNumService docNumService;

    @Autowired private OSYR0130_Mapper osyr0130_Mapper;

    /**
     * 화면명 : 개인정보요청현황
     * 처리내용 : 개인정보 열람요청을 조회/승인/반려하는 화면.
     * 경로 : 시스템관리 > 사용자관리 > 개인정보요청현황
     */
    public List<Map<String,Object>> osyr0130_doSearch(Map<String, String> param) throws Exception{
        return osyr0130_Mapper.osyr0130_doSearch(param);
    }

    public List<Map<String, Object>> osyr0130_doSearchSub(Map<String, String> param) {
        return osyr0130_Mapper.osyr0130_doSearchSub(param);
    }

}