package com.st_ones.nhepro.OVNR.service;

import com.st_ones.common.docNum.service.DocNumService;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.common.util.service.LargeTextService;
import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.nhepro.OVNR.OVNR0010_Mapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

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
 * @File Name : OVNR0010_Service.java
 * @date 2018. 01. 30.
 * @version 1.0
 */

@Service(value = "OVNR0010_Service")
public class OVNR0010_Service extends BaseService {

    @Autowired MessageService msg;
    @Autowired OVNR0010_Mapper ovnr0010_mapper;
    @Autowired LargeTextService largeTextService;
    @Autowired private DocNumService docNumService;

    /**
     * 화면명 : 협력업체현황
     * 처리내용 : 등록된 협력사정보를 조회하는 화면.
     * 경로 : 운영사 > 회원사 관리 > 협력업체 관리 > 협력업체현황
     */
    public List<Map<String, Object>> ovnr0010_doSearch(Map<String, String> param) {
        return ovnr0010_mapper.ovnr0010_doSearch(param);
    }
    
    // 협력업체 BLOCK
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public Map<String, String> ovnr0010_doBlock(Map<String, String> formData, List<Map<String, Object>> grid) throws Exception {
        Map<String, String> rtnMap = new HashMap<>();

        for(Map<String, Object> data : grid) {
            data.put("BLOCK_REASON", formData.get("BLOCK_REASON"));

            ovnr0010_mapper.ovnr0010_doBlock(data);
        }

        rtnMap.put("rtnMsg", msg.getMessage("0031"));

        return rtnMap;
    }
    
    // 협력업체 BLOCK 해제
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public Map<String, String> ovnr0010_doBlockRemove(Map<String, String> formData, List<Map<String, Object>> grid) throws Exception {
        Map<String, String> rtnMap = new HashMap<>();

        for(Map<String, Object> data : grid) {

            ovnr0010_mapper.ovnr0010_doBlockRemove(data);
        }

        rtnMap.put("rtnMsg", msg.getMessage("0031"));

        return rtnMap;
    }
    /**
     * 화면명 : 협력업체 상세
     * 처리내용 : 등록된 협력사정보를 조회하는 화면.
     * 경로 : 운영사 > 회원사 관리 > 협력업체 관리 > 협력업체현황 > 협력업체 상세 (팝업)
     */
    public Map<String, Object> ovnr0011_doSearch(Map<String, String> param) {
        Map<String, Object> rtnMap = ovnr0010_mapper.ovnr0011_doSearch(param);

        rtnMap.put("HQ_ADDR", EverString.nullToEmptyString(rtnMap.get("HQ_ADDR_1")) + ' ' + EverString.nullToEmptyString(rtnMap.get("HQ_ADDR_2")));

        return rtnMap;
    }

    // 특허 및 취급면허, 조회
    public List<Map<String, Object>> ovnr0011_doSearchVNSL(Map<String, String> param) {
        return ovnr0010_mapper.ovnr0011_doSearchVNSL(param);
    }

    // 결제정보, 조회
    public List<Map<String, Object>> ovnr0011_doSearchVNAP(Map<String, String> param) {
        return ovnr0010_mapper.ovnr0011_doSearchVNAP(param);
    }

    // 첨부파일, 조회
    public List<Map<String, Object>> ovnr0011_doSearchATTD(Map<String, String> param) {
        return ovnr0010_mapper.ovnr0011_doSearchATTD(param);
    }

    // 거래희망 고객사, 조회
    public List<Map<String, Object>> ovnr0011_doSearchVNCM(Map<String, String> param) {
        return ovnr0010_mapper.ovnr0011_doSearchVNCM(param);
    }

}
