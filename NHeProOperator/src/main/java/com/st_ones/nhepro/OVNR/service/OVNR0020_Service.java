package com.st_ones.nhepro.OVNR.service;

import com.st_ones.common.docNum.service.DocNumService;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.util.clazz.EverEncryption;
import com.st_ones.common.util.service.LargeTextService;
import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.everf.serverside.util.EverString;
import com.st_ones.nhepro.OVNR.OVNR0020_Mapper;
import org.apache.commons.lang3.RandomStringUtils;
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
 * @File Name : OVNR0020_Service.java
 * @date 2018. 01. 30.
 * @version 1.0
 */

@Service(value = "OVNR0020_Service")
public class OVNR0020_Service extends BaseService {

    @Autowired MessageService msg;
    @Autowired OVNR0020_Mapper ovnr0020_mapper;
    @Autowired LargeTextService largeTextService;
    @Autowired private DocNumService docNumService;

    /**
     * 화면명 : 협력업체별 사용자현황
     * 처리내용 : 협력업체 사용자를 등록 및 수정하는 화면.
     * 경로 : 운영사 > 회원사 관리 > 협력업체 관리 > 협력업체별 사용자현황
     */
    public List<Map<String, Object>> ovnr0020_doSearch(Map<String, String> param) {
        return ovnr0020_mapper.ovnr0020_doSearch(param);
    }

    // 삭제
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String ovnr0020_doDelete(List<Map<String, Object>> gridDatas) throws Exception {
        for(Map<String, Object> gridData : gridDatas) {
            ovnr0020_mapper.ovnr0020_doDelete(gridData);
        }

        return msg.getMessage("0017");
    }

    /**
     * 화면명 : 협력업체별 사용자 상세
     * 처리내용 : 사용자 상세 정보 조회 및 수정(Block), 비밀번호 초기화 하는 화면.
     * 경로 : 운영사 > 회원사 관리 > 협력업체 관리 > 협력업체별 사용자현황 > 협력업체별 사용자 상세 (팝업)
     */
    public Map<String, Object> ovnr0021_doSearch(Map<String, String> param) {
        Map<String, Object> rtnMap = ovnr0020_mapper.ovnr0021_doSearch(param);

        return rtnMap;
    }

    // 저장
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public Map<String, String> ovnr0021_doSave(Map<String, String> formData) throws Exception {
        Map<String, String> rtnMap = new HashMap<>();

        String userId = EverString.nullToEmptyString(formData.get("USER_ID"));

        ovnr0020_mapper.ovnr0021_doSave(formData);

        rtnMap.put("USER_ID", userId);
        rtnMap.put("rtnMsg", msg.getMessage("0031"));

        return rtnMap;
    }

    // 삭제
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String ovnr0021_doDelete(Map<String, String> formData) throws Exception {
            ovnr0020_mapper.ovnr0021_doDelete(formData);
            ovnr0020_mapper.ovnr0021_doDeleteUserComm(formData);

        return msg.getMessage("0017");
    }

    // 비밀번호 초기화
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public Map<String, String> ovnr0021_doPasswordInit(Map<String, String> formData) throws Exception {
        Map<String, String> rtnMap = new HashMap<>();

        String userId = EverString.nullToEmptyString(formData.get("USER_ID"));
        String password = RandomStringUtils.randomAlphanumeric(10);

        formData.put("PASSWORD", EverEncryption.getEncryptedUserPassword(EverString.nullToEmptyString(password)));

        ovnr0020_mapper.ovnr0021_doPasswordInit(formData);

        rtnMap.put("USER_ID", userId);
        rtnMap.put("rtnMsg", msg.getMessage("0094"));

        return rtnMap;
    }
}
