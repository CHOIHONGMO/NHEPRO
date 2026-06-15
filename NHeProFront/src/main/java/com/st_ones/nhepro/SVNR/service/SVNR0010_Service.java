package com.st_ones.nhepro.SVNR.service;

import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.sms.service.EverSmsService;
import com.st_ones.common.util.service.LargeTextService;
import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.everf.serverside.util.EverString;
import com.st_ones.nhepro.SVNR.SVNR0010_Mapper;
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
 * @File Name : SVNR0010_Service.java
 * @date 2018. 01. 30.
 * @version 1.0
 */

@Service(value = "SVNR0010_Service")
public class SVNR0010_Service extends BaseService {

    @Autowired MessageService msg;
    @Autowired SVNR0010_Mapper svnr0010_mapper;
    @Autowired LargeTextService largeTextService;
    @Autowired private EverSmsService eversmsservice;

    /**
     * 화면명 : 회사정보
     * 처리내용 : 회사정보를 수정하는 화면.
     * 경로 : 협력회사 > 관리자 > 조직관리 > 회사정보
     */
    public Map<String, Object> svnr0010_doSearch(Map<String, String> param) {
        Map<String, Object> rtnMap = svnr0010_mapper.svnr0010_doSearch(param);

        rtnMap.put("HQ_ADDR", rtnMap.get("HQ_ADDR_1").toString() + ' ' + rtnMap.get("HQ_ADDR_2").toString());

        return rtnMap;
    }

    // 특허 및 취급면허, 조회
    public List<Map<String, Object>> svnr0010_doSearchVNSL(Map<String, String> param) {
        return svnr0010_mapper.svnr0010_doSearchVNSL(param);
    }

    // 결제정보, 조회
    public List<Map<String, Object>> svnr0010_doSearchVNAP(Map<String, String> param) {
        return svnr0010_mapper.svnr0010_doSearchVNAP(param);
    }

    // 첨부파일, 조회
    public List<Map<String, Object>> svnr0010_doSearchATTD(Map<String, String> param) {
        return svnr0010_mapper.svnr0010_doSearchATTD(param);
    }

    // 거래희망 고객사, 조회
    public List<Map<String, Object>> svnr0010_doSearchVNCM(Map<String, String> param) {
        return svnr0010_mapper.svnr0010_doSearchVNCM(param);
    }

    // 수정
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public Map<String, String> svnr0010_doUpdate(Map<String, String> formData, List<Map<String, Object>> gridVNSL, List<Map<String, Object>> gridVNAP, List<Map<String, Object>> gridATTD, List<Map<String, Object>> gridVNCM) throws Exception {
        Map<String, String> rtnMap = new HashMap<>();

        String VENDOR_CD = EverString.nullToEmptyString(formData.get("VENDOR_CD"));

        svnr0010_mapper.svnr0010_doUpdate(formData); // VNGL
        svnr0010_mapper.svnr0010_doMergeVNFI(formData);
        
        svnr0010_mapper.svnr0010_doUpateCorp(formData);
        svnr0010_mapper.svnr0010_doUpateBrc(formData);
        svnr0010_mapper.svnr0010_doUpateDept(formData);
        
        for(Map<String, Object> data : gridVNSL) {
            Map<String, String> param = new HashMap<>();

            param.put("COMPANY_CD", VENDOR_CD);
            param.put("SEQ", EverString.nullToEmptyString(data.get("SEQ")));
            param.put("SL_TYPE", EverString.nullToEmptyString(data.get("SL_TYPE")));
            param.put("SL_NUM", EverString.nullToEmptyString(data.get("SL_NUM")));
            param.put("SL_NM", EverString.nullToEmptyString(data.get("SL_NM")));
            param.put("ISSUE_NM", EverString.nullToEmptyString(data.get("ISSUE_NM")));
            param.put("EXPIRY_DATE", EverString.nullToEmptyString(data.get("EXPIRY_DATE")));
            param.put("ATT_FILE_NUM", EverString.nullToEmptyString(data.get("ATT_FILE_NUM")));

            if("".equals(param.get("SEQ"))) {
                svnr0010_mapper.svnr0010_doInsertVNSL(param);
            } else {
                svnr0010_mapper.svnr0010_doUpdateVNSL(param);
            }
        }

        for(Map<String, Object> data : gridVNAP) {
            Map<String, String> param = new HashMap<>();

            param.put("VENDOR_CD", VENDOR_CD);
            param.put("SEQ", EverString.nullToEmptyString(data.get("SEQ")));
            param.put("PAY_ACC_NM", EverString.nullToEmptyString(data.get("PAY_ACC_NM")));
            param.put("PAY_BANK", EverString.nullToEmptyString(data.get("PAY_BANK")));
            param.put("PAY_ACCOUNT_NUM", EverString.nullToEmptyString(data.get("PAY_ACCOUNT_NUM")));
            param.put("PAY_ACCOUNT_USER_NM", EverString.nullToEmptyString(data.get("PAY_ACCOUNT_USER_NM")));
            param.put("PAY_ACC_MNG_NM", EverString.nullToEmptyString(data.get("PAY_ACC_MNG_NM")));
            param.put("PAY_ACC_NMG_TEL_NUM", EverString.nullToEmptyString(data.get("PAY_ACC_NMG_TEL_NUM")));
            param.put("PAY_ACC_MNG_EMAIL", EverString.nullToEmptyString(data.get("PAY_ACC_MNG_EMAIL")));
            param.put("PAY_ATT_FILE_NUM", EverString.nullToEmptyString(data.get("PAY_ATT_FILE_NUM")));

            if("".equals(param.get("SEQ"))) {
                svnr0010_mapper.svnr0010_doInsertVNAP(param);
            } else {
                svnr0010_mapper.svnr0010_doUpdateVNAP(param);
            }
        }

        for(Map<String, Object> data : gridATTD) {
            Map<String, String> param = new HashMap<>();

            param.put("VENDOR_CD", VENDOR_CD);
            param.put("BUYER_CD", EverString.nullToEmptyString(data.get("BUYER_CD")));
            param.put("TMPL_NUM", EverString.nullToEmptyString(data.get("TMPL_NUM")));
            param.put("TMPL_SQ", EverString.nullToEmptyString(String.valueOf(data.get("TMPL_SQ"))));
            param.put("VALID_START_DATE", EverString.nullToEmptyString(data.get("VALID_START_DATE")));
            param.put("VALID_END_DATE", EverString.nullToEmptyString(data.get("VALID_END_DATE")));
            param.put("ATT_FILE_NUM", EverString.nullToEmptyString(data.get("ATTS_ATT_FILE_NUM")));

            svnr0010_mapper.svnr0010_doMergeATTS(param);
        }

        for(Map<String, Object> data : gridVNCM) {
            Map<String, String> param = new HashMap<>();

            String ORG_BUYER_CD = EverString.nullToEmptyString(data.get("ORG_BUYER_CD"));
            String ORG_DEPT_CD = EverString.nullToEmptyString(data.get("ORG_DEPT_CD"));

            param.put("VENDOR_CD", VENDOR_CD);
            param.put("SEQ", EverString.nullToEmptyString(data.get("SEQ")));
            param.put("BUYER_CD", EverString.nullToEmptyString(data.get("BUYER_CD")));
            param.put("DEPT_CD", EverString.nullToEmptyString(data.get("DEPT_CD")));
            param.put("REQ_REASON", EverString.nullToEmptyString(data.get("REQ_REASON")));

            if("".equals(param.get("SEQ"))) {
                svnr0010_mapper.svnr0010_doInsertVNCM(param);

                List<Map<String, Object>> brUserList = svnr0010_mapper.getBrUserList(param);
                for(Map<String, Object> brUserInfo : brUserList) {
                    Map<String,String> smsMap = new HashMap<>();
                    smsMap.put("CONTENTS", "[전자구매시스템] 협력사 [" + formData.get("VENDOR_NM") + "]이 등록요청 하였습니다");
                    smsMap.put("REF_MODULE_CD", "SVD01");
                    smsMap.put("RECV_USER_ID", String.valueOf(brUserInfo.get("CTRL_USER_ID")));
                    
                    // 2021.07.02 : 협력사 거래 요청 후 SMS 수수료 부과
                    brUserInfo.put("VENDOR_CD", param.get("VENDOR_CD"));
                    Map<String, String> costInfo = svnr0010_mapper.costSmsInfo(brUserInfo);
                    smsMap.put("CORP_NO", costInfo.get("CORP_NO"));     	// 고객사 사업자번호
                    smsMap.put("BRC", costInfo.get("BRC"));             	// 고객사 부서
                    smsMap.put("EPRO_PS_DSC", "1");     					// 1  : 구매
                    smsMap.put("EPRO_RATE_DSC", "01");  					// 01 : 최초
                    smsMap.put("APLY_DT", costInfo.get("APLY_DT"));     	// 발생일 YYYYMMDD
                    smsMap.put("USER_ID", costInfo.get("USER_ID"));     	// 고객사 보내는사람 ID
                    smsMap.put("CONT_TBL_ID", "STOCVNCM");              	// 검증 테이블
                    smsMap.put("CONT_TBL_PK", costInfo.get("CONT_TBL_PK")); // 검증 조건
                    smsMap.put("tmp", costInfo.get("CONT_TBL_PK"));			// 유니크한 값.
                    smsMap.put("payFlag", "Y");
                    
                    eversmsservice.sendSmsNhe(smsMap);
                }
            } else {
                if(!ORG_BUYER_CD.equals(param.get("BUYER_CD"))) {
                    svnr0010_mapper.svnr0010_doInsertVNCM(param);

                    param.put("BUYER_CD", ORG_BUYER_CD);
                    param.put("DEPT_CD", ORG_DEPT_CD);

                    svnr0010_mapper.svnr0010_doDeleteVNCM(param);
                } else {
                    svnr0010_mapper.svnr0010_doUpdateVNCM(param);
                }
            }
        }

        rtnMap.put("VENDOR_CD", VENDOR_CD);
        rtnMap.put("rtnMsg", msg.getMessage("0031"));

        return rtnMap;
    }

    // 특허 및 취급면허 그리드, 삭제
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public void svnr0010_doDeleteVNSL(Map<String, String> formData, List<Map<String, Object>> grid) throws Exception {
        String VENDOR_CD = EverString.nullToEmptyString(formData.get("VENDOR_CD"));

        for(Map<String, Object> data : grid) {
            Map<String, String> param = new HashMap<>();

            param.put("COMPANY_CD", VENDOR_CD);
            param.put("SEQ", EverString.nullToEmptyString(data.get("SEQ")));

            svnr0010_mapper.svnr0010_doDeleteVNSL(param);
        }
    }

    // 결제정보 그리드, 행 삭제
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public void svnr0010_doDeleteVNAP(Map<String, String> formData, List<Map<String, Object>> grid) throws Exception {
        String VENDOR_CD = EverString.nullToEmptyString(formData.get("VENDOR_CD"));

        for(Map<String, Object> data : grid) {
            Map<String, String> param = new HashMap<>();

            param.put("VENDOR_CD", VENDOR_CD);
            param.put("SEQ", EverString.nullToEmptyString(data.get("SEQ")));

            svnr0010_mapper.svnr0010_doDeleteVNAP(param);
        }
    }

    // 거래희망 고객사 그리드, 행 삭제
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public void svnr0010_doDeleteVNCM(Map<String, String> formData, List<Map<String, Object>> grid) throws Exception {
        String VENDOR_CD = EverString.nullToEmptyString(formData.get("VENDOR_CD"));

        for(Map<String, Object> data : grid) {
            Map<String, String> param = new HashMap<>();

            param.put("VENDOR_CD", VENDOR_CD);
            param.put("BUYER_CD", EverString.nullToEmptyString(data.get("BUYER_CD")));
            param.put("DEPT_CD", EverString.nullToEmptyString(data.get("DEPT_CD")));

            svnr0010_mapper.svnr0010_doDeleteVNCM(param);

            int cnt = svnr0010_mapper.svnr0010_doSearchCntVNCM(param);

            if(cnt == 0) {
                svnr0010_mapper.svnr0010_doDeleteATTS(param);
            }
        }
    }

    // 거래희망 고객사 그리드, 행 저장 (수정 시, 변경전 고객사 삭제)
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public Map<String, String> svnr0010_doInsertVNCM(Map<String, String> param) throws Exception {
    	Map<String, String> rtnMap = new HashMap<>();
    	
        param.put("VENDOR_CD", EverString.nullToEmptyString(param.get("VENDOR_CD")));
        param.put("BUYER_CD", EverString.nullToEmptyString(param.get("BUYER_CD")));
        param.put("DEPT_CD", EverString.nullToEmptyString(param.get("DEPT_CD")));
        svnr0010_mapper.svnr0010_doInsertVNCM(param);
        
        List<Map<String, Object>> brUserList = svnr0010_mapper.getBrUserList(param);
        for(Map<String, Object> brUserInfo : brUserList) {
            Map<String,String> smsMap = new HashMap<>();
            smsMap.put("CONTENTS", "[전자구매시스템] 협력사 [" + param.get("VENDOR_NM") + "]이 등록요청 하였습니다");
            smsMap.put("REF_MODULE_CD", "SVD01");
            smsMap.put("RECV_USER_ID", String.valueOf(brUserInfo.get("CTRL_USER_ID")));
            
            // 2021.07.02 : 협력사 거래 요청 후 SMS 수수료 부과
            brUserInfo.put("VENDOR_CD", param.get("VENDOR_CD"));
            Map<String, String> costInfo = svnr0010_mapper.costSmsInfo(brUserInfo);
            smsMap.put("CORP_NO", costInfo.get("CORP_NO"));     	// 고객사 사업자번호
            smsMap.put("BRC", costInfo.get("BRC"));             	// 고객사 부서
            smsMap.put("EPRO_PS_DSC", "1");     					// 1  : 구매
            smsMap.put("EPRO_RATE_DSC", "01");  					// 01 : 최초
            smsMap.put("APLY_DT", costInfo.get("APLY_DT"));     	// 발생일 YYYYMMDD
            smsMap.put("USER_ID", costInfo.get("USER_ID"));     	// 고객사 보내는사람 ID
            smsMap.put("CONT_TBL_ID", "STOCVNCM");              	// 검증 테이블
            smsMap.put("CONT_TBL_PK", costInfo.get("CONT_TBL_PK")); // 검증 조건
            smsMap.put("tmp", costInfo.get("CONT_TBL_PK"));			// 유니크한 값.
            smsMap.put("payFlag", "Y");
            
            eversmsservice.sendSmsNhe(smsMap);
        }
        
        // 기존 고객사를 변경하는 경우
        if( EverString.isNotEmpty(param.get("DEL_BUYER_CD")) ) {
	        param.put("BUYER_CD", EverString.nullToEmptyString(param.get("DEL_BUYER_CD")));
	        param.put("DEPT_CD", EverString.nullToEmptyString(param.get("DEL_DEPT_CD")));
	        svnr0010_mapper.svnr0010_doDeleteVNCM(param);
        }
        
        rtnMap.put("rtnMsg", msg.getMessage("0001"));
        return rtnMap;
    }

    // 거래희망 고객사 그리드, 재요청
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public Map<String, String> svnr0010_doUpdateReq(Map<String, String> formData, List<Map<String, Object>> gridVNCM) throws Exception {
        
    	Map<String, String> rtnMap = new HashMap<>();
        String VENDOR_CD = EverString.nullToEmptyString(formData.get("VENDOR_CD"));
        
        for(Map<String, Object> data : gridVNCM) {
            Map<String, String> param = new HashMap<>();
            param.put("VENDOR_CD", VENDOR_CD);
            param.put("BUYER_CD", EverString.nullToEmptyString(data.get("BUYER_CD")));
            param.put("DEPT_CD", EverString.nullToEmptyString(data.get("DEPT_CD")));
            param.put("REQ_REASON", EverString.nullToEmptyString(data.get("REQ_REASON")));

            svnr0010_mapper.svnr0010_doUpdateReqVNCM(param);

            List<Map<String, Object>> brUserList = svnr0010_mapper.getBrUserList(param);
            for(Map<String, Object> brUserInfo : brUserList) {
                Map<String,String> smsMap = new HashMap<>();
                smsMap.put("CONTENTS", "[전자구매시스템] 협력사 [" + formData.get("VENDOR_NM") + "]이 등록요청 하였습니다");
                smsMap.put("REF_MODULE_CD", "SVD01");
                smsMap.put("RECV_USER_ID", String.valueOf(brUserInfo.get("CTRL_USER_ID")));
                
                // 2021.07.02 : 협력사 거래 요청 후 SMS 수수료 부과
                brUserInfo.put("VENDOR_CD", param.get("VENDOR_CD"));
                Map<String, String> costInfo = svnr0010_mapper.costSmsInfo(brUserInfo);
                smsMap.put("CORP_NO", costInfo.get("CORP_NO"));     	// 고객사 사업자번호
                smsMap.put("BRC", costInfo.get("BRC"));             	// 고객사 부서
                smsMap.put("EPRO_PS_DSC", "1");     					// 1  : 구매
                smsMap.put("EPRO_RATE_DSC", "01");  					// 01 : 최초
                smsMap.put("APLY_DT", costInfo.get("APLY_DT"));     	// 발생일 YYYYMMDD
                smsMap.put("USER_ID", costInfo.get("USER_ID"));     	// 고객사 보내는사람 ID
                smsMap.put("CONT_TBL_ID", "STOCVNCM");              	// 검증 테이블
                smsMap.put("CONT_TBL_PK", costInfo.get("CONT_TBL_PK")); // 검증 조건
                smsMap.put("tmp", costInfo.get("CONT_TBL_PK"));			// 유니크한 값.
                smsMap.put("payFlag", "Y");
                
                eversmsservice.sendSmsNhe(smsMap);
            }
        }

        rtnMap.put("rtnMsg", msg.getMessage("0031"));

        return rtnMap;
    }

}
