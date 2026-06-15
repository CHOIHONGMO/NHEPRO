package com.st_ones.nhepro.SPOR.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.st_ones.common.docNum.service.DocNumService;
import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.util.clazz.EverConverter;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.common.util.service.LargeTextService;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.nhepro.SPOR.SPOR0010_Mapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.HashMap;
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
 * @File Name : SPOR0010_Service.java
 * @date 2018. 01. 30.
 * @version 1.0
 */

@Service(value = "SPOR0010_Service")
public class SPOR0010_Service extends BaseService {

    @Autowired MessageService msg;
    @Autowired SPOR0010_Mapper spor0010_mapper;
    @Autowired LargeTextService largeTextService;
    @Autowired private DocNumService docNumService;

    /**
     * 화면명 : 발주접수현황
     * 처리내용 : 협력업체에서 발주 요청 현황을 조회하고, 접수 및 반려하는 화면
     * 경로 : 협력업체 > 발주관리 > 발주관리 > 발주접수현황
     */
    public List<Map<String, Object>> spor0010_doSearch(Map<String, String> param) throws Exception {
        return spor0010_mapper.spor0010_doSearch(param);
    }

    // 접수
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public Map<String, String> spor0010_doSaveReceipt(Map<String, String> formData, List<Map<String, Object>> grid) throws Exception {
        Map<String, String> rtnMap = new HashMap<>();

        for(Map<String, Object> data : grid) {
            data.put("VENDOR_RECEIPT_STATUS", "200");   // 접수
            spor0010_mapper.spor0010_doUpdatePOHD(data);

            data.put("PROGRESS_CD", "5300");    // 협력업체접수완료
            spor0010_mapper.spor0010_doUpdatePODT(data);
        }

        rtnMap.put("rtnMsg", msg.getMessage("0031"));

        return rtnMap;
    }

    // 반려
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public Map<String, String> spor0010_doSaveReject(Map<String, String> formData, List<Map<String, Object>> grid) throws Exception {
        Map<String, String> rtnMap = new HashMap<>();

        for(Map<String, Object> data : grid) {
            data.put("VENDOR_REJECT_RMK", formData.get("VENDOR_REJECT_RMK"));
            data.put("VENDOR_RECEIPT_STATUS", "100");   // 반려

            spor0010_mapper.spor0010_doUpdatePOHD(data);

            data.put("PROGRESS_CD", "5200");    // 발주완료
            spor0010_mapper.spor0010_doUpdatePODT(data);
        }

        rtnMap.put("rtnMsg", msg.getMessage("0031"));

        return rtnMap;
    }

    /**
     * 화면명 : 발주서
     * 처리내용 : 협력업체에서 발주 요청 현황을 조회하고, 접수 및 반려하는 화면
     * 경로 : 협력업체 > 발주관리 > 발주관리 > 발주접수현황 (SPOR0010) > 발주서(팝업)
     */
    public Map<String, Object> spor0011_doSearchPOHD(Map<String, String> param) throws Exception {
        Map<String, Object> fParam;

        fParam = spor0010_mapper.spor0011_doSearchPOHD(param);

        fParam.put("RMK_TEXT", largeTextService.selectLargeText(EverString.nullToEmptyString(fParam.get("RMK_TEXT_NUM"))));

        return fParam;
    }

    // 품목정보, 조회, PODT
    public List<Map<String, Object>> spor0011_doSearchPODT(Map<String, String> formData, Map<String, String> param) throws Exception {

        return spor0010_mapper.spor0011_doSearchPODT(formData);
    }

    // 지불정보, 조회, PODT
    public List<Map<String, Object>> spor0011_doSearchPOPY(Map<String, String> formData, Map<String, String> param) throws Exception {
        List<Map<String, Object>> POPY = spor0010_mapper.spor0011_doSearchPOPY(formData);

        for(Map<String, Object> data : POPY) {
            data.put("BUYER_CD", formData.get("BUYER_CD"));

            List<Map<String, Object>> POPC = spor0010_mapper.spor0011_doSearchPOPC(data);

            data.put("PC_INFO",  EverConverter.getJsonString(POPC));
        }

        return POPY;
    }

    /**
     * 화면명 : 발주진행현황
     * 처리내용 : 품목별 발주 진행현황을 보여주는 화면
     * 경로 : 협력업체 > 발주관리 > 발주관리 > 발주진행현황
     */
    public List<Map<String, Object>> spor0020_doSearch(Map<String, String> param) throws Exception {
        return spor0010_mapper.spor0020_doSearch(param);
    }
}
