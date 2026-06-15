package com.st_ones.nhepro.CCUR.service;

import com.st_ones.common.docNum.service.DocNumService;
import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.util.clazz.EverEncryption;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.common.util.service.LargeTextService;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.nhepro.CCUR.CCUR0030_Mapper;
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
 * @File Name : CCUR0030_Service.java
 * @date 2020. 03. 18.
 * @version 1.0
 */
@Service(value = "ccur0030_Service")
public class CCUR0030_Service extends BaseService {

    @Autowired private DocNumService docNumService;

    @Autowired private MessageService msg;

    @Autowired private LargeTextService largeTextService;

    @Autowired private CCUR0030_Mapper ccur_Mapper;

    /**
     * 화면명 : 사용자현황
     * 처리내용 : 로그인한 사용자 회상의 사용자들을 조회/관리하는 화면.
     * 경로 : 고객사 > 관리자 > 사용자관리 > 사용자현황
     */
    public List<Map<String, Object>> ccur0030_doSearch(Map<String, String> param) throws Exception {
        return ccur_Mapper.ccur0030_doSearch(param);
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String ccur0030_doUpdate(List<Map<String, Object>> gridDatas) throws Exception {

        for(Map<String, Object> gridData : gridDatas) {
            ccur_Mapper.ccur0030_doUpdate(gridData);
        }
        return msg.getMessage("0031");
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String ccur0030_doDelete(List<Map<String, Object>> gridDatas) throws Exception {

        for(Map<String, Object> gridData : gridDatas) {
            ccur_Mapper.ccur0030_doDelete(gridData);
        }
        return msg.getMessage("0017");
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String ccur0030_doInitPassword(List<Map<String, Object>> gridDatas) throws Exception {

        for(Map<String, Object> gridData : gridDatas) {

            // 비밀번호 난수발생 > 업데이트
            String password = RandomStringUtils.randomAlphanumeric(10);
            gridData.put("PASSWORD", EverEncryption.getEncryptedUserPassword(EverString.nullToEmptyString(password)));
            ccur_Mapper.ccur0030_doInitPassword(gridData);

            // 변경된 비밀번호 문자발송
            Map<String, String> map = new HashMap<String, String>();
            String smsMessage = "[FIRSTePro] 임시비밀번호 : " + password + "로 로그인 한 후 비밀번호를 변경하세요";
        /*
            map.put("RECV_USER_ID",  generalForm.get("USER_ID"));
            map.put("RECV_USER_NM",  generalForm.get("USER_NM"));
            map.put("RECV_TEL_NUM",  generalForm.get("CELL_NUM"));
            map.put("SEND_USER_ID",  PropertiesManager.getString("eversrm.userId.default"));
            map.put("SEND_USER_NM",  "SYSTEM");
            map.put("SEND_TEL_NUM",  PropertiesManager.getString("eversrm.system.sms.default.telNo"));
            map.put("CONTENTS",      smsMessage);
            map.put("VENDOR_CD",     generalForm.get("COMPANY_CD"));	//업체코드
            map.put("REF_NUM", "");
            map.put("REF_MODULE_CD", "BADU");	//참조모듈
            map.put("BUYER_CD",      "1000");

            everSmsService.sendSms(map);
         */
        }
        return msg.getMessage("0094");
    }

    /**
     * 화면명 : 사용자 등록/상세 (팝업)
     * 처리내용 : 로그인한 사용자 회사의 사용자들의 상세정보를 조회, 신규 사용자를 등록하는 화면.
     * 경로 : 고객사 > 관리자 > 사용자관리 > 사용자현황 > 사용자 등록/상세 (팝업)
     */
    public Map<String, String> ccur0031_doSearchInfo(Map<String, String> param) throws Exception {
        return ccur_Mapper.ccur0031_doSearchInfo(param);
    }

    public List<Map<String, Object>> ccur0031_doSearchAuth(Map<String, String> param) throws Exception {
        return ccur_Mapper.ccur0031_doSearchAuth(param);
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String ccur0031_doSave(Map<String, String> formData) throws Exception {

        // 아이디중복체크
        String oriUserId = EverString.nullToEmptyString(formData.get("ORI_USER_ID"));
        if(oriUserId.equals("")) {
            Map<String, String> params = new HashMap<String, String>();
            params.put("USER_ID", EverString.nullToEmptyString(formData.get("USER_ID")));

            String possibleFlag = ccur_Mapper.ccur0031_doCheckUserId(params);
            if(possibleFlag.equals("N")) {
                throw new Exception(msg.getMessageByScreenId("CCUR0031", "006"));
            }
        }

        if("Y".equals(formData.get("CHANGE_PW"))){
            formData.put("PASSWORD", EverEncryption.getEncryptedUserPassword(formData.get("PASSWORD")));
            // 비밀번호저장시 기존비밀번호와 동일하면 리턴
            int checkPW = ccur_Mapper.CheckUserInfoPassWordSame(formData);
            if (checkPW > 0) {
                throw new Exception(msg.getMessage("0153"));
            }
        }

        // 사용자 등록/수정
        ccur_Mapper.ccur0031_doMerge(formData);

        if(oriUserId.equals("")) {
            // 사용자처음등록시 프로파일 등록
            formData.put("AUTH_CD", "PF0131");
            ccur_Mapper.ccur0031_doInsertUSAP(formData);
        }

        // 수동 사용자 생성 및 수정 후 TB_CO_USER에 INSERT OR UPDATE
        //if("1".equals(formData.get("RELAT_YN"))){
            Map<String, String> userData = ccur_Mapper.ccur0031_getUserData(formData);
            if(userData != null) {
                ccur_Mapper.ccur0031_doMergeTB(userData);
            }
        //}
        return msg.getMessage("0031");
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String ccur0031_doSaveAuth(Map<String, String> formData, List<Map<String, Object>> gridDatas) throws Exception {

        UserInfo userInfo = UserInfoManager.getUserInfo();
        
        // 고객사 사용자 테이블에서 MNG_YN = '1'로 변경할 직무 가져오기
        String[] ctrlCdList = PropertiesManager.getString("eversrm.customer.admin.ctrlCd", "").split(";");
        
        String buyerCd = formData.get("COMPANY_CD");
        String ctrlUserId = formData.get("USER_ID");
        
        Map<String, Object> param = new HashMap<>();
        param.put("BUYER_CD", buyerCd);
        param.put("CTRL_USER_ID", ctrlUserId);
        
        // 권한 전체 삭제
        ccur_Mapper.ccur0031_doDeleteAuth(param);
        
        // 고객사_관리자 직무 삭제인 경우 MNG_YN = '0'으로 변경
        param.put("DEL_FLAG", "1");
        ccur_Mapper.ccur0031_updateCustomerMngYn(param);
        
        for(Map<String, Object> gridData : gridDatas) {

            gridData.put("BUYER_CD", buyerCd);
            gridData.put("CTRL_USER_ID", ctrlUserId);
            
            // 사용자 권한정보 등록/수정
            ccur_Mapper.ccur0031_doMergeAuth(gridData);
            // 고객사_관리자 직무인 경우 STOCCVUR의 MNG_YN = '1'로 변경
            for (String code : ctrlCdList) {
            	if( code.equalsIgnoreCase(String.valueOf(gridData.get("CTRL_CD"))) ) {
            		ccur_Mapper.ccur0031_updateCustomerMngYn(gridData);
            	}
            }
        }
        
        return msg.getMessage("0031");
    }

    public String ccur0031_doCheckUserId(Map<String, String> param) throws Exception {
        return ccur_Mapper.ccur0031_doCheckUserId(param);
    }

}