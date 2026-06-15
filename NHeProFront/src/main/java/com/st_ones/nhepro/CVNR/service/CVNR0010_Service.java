package com.st_ones.nhepro.CVNR.service;

import com.st_ones.common.docNum.service.DocNumService;
import com.st_ones.common.mail.service.EverMailService;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.sms.service.EverSmsService;
import com.st_ones.common.util.service.LargeTextService;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.everf.serverside.util.EverString;
import com.st_ones.eversrm.manager.auth.MAUA0010_Mapper;
import com.st_ones.nhepro.CVNR.CVNR0010_Mapper;
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
 * @File Name : CVNR0010_Service.java
 * @date 2018. 01. 30.
 * @version 1.0
 */

@Service(value = "CVNR0010_Service")
public class CVNR0010_Service extends BaseService {

    @Autowired MessageService msg;
    @Autowired CVNR0010_Mapper cvnr0010_mapper;
    @Autowired LargeTextService largeTextService;
    @Autowired private DocNumService docNumService;
    @Autowired private EverSmsService eversmsservice;
    @Autowired private EverMailService evermailservice;

    /**
     * 화면명 : 신규업체대기현황
     * 처리내용 : 신규로 등록한 협력사를 승인하는 화면
     * 경로 : 고객사 > 기준정보 > 협력업체관리 > 신규업체대기현황
     */
    public List<Map<String, Object>> cvnr0010_doSearch(Map<String, String> param) {
        return cvnr0010_mapper.cvnr0010_doSearch(param);
    }

    /**
     * 화면명 : 협력업체 상세
     * 처리내용 : 등록된 협력사를 수정/승인/반려 하는 화면.
     * 경로 : 고객사 > 기준정보 > 협력업체관리 > 신규업체대기현황 > 협력업체 상세 (팝업)
     */
    public Map<String, Object> cvnr0011_doSearch(Map<String, String> param) {
        Map<String, Object> rtnMap = cvnr0010_mapper.cvnr0011_doSearch(param);

        rtnMap.put("HQ_ADDR", EverString.nullToEmptyString(rtnMap.get("HQ_ADDR_1")) + ' ' + EverString.nullToEmptyString(rtnMap.get("HQ_ADDR_2")));

        return rtnMap;
    }
    
    // 담당자정보 조회
    public List<Map<String, Object>> cvnr0011_doSearchCVUR(Map<String, String> param) {
        return cvnr0010_mapper.cvnr0011_doSearchCVUR(param);
    }
    
    // 특허 및 취급면허, 조회
    public List<Map<String, Object>> cvnr0011_doSearchVNSL(Map<String, String> param) {
        return cvnr0010_mapper.cvnr0011_doSearchVNSL(param);
    }

    // 결제정보, 조회
    public List<Map<String, Object>> cvnr0011_doSearchVNAP(Map<String, String> param) {
        return cvnr0010_mapper.cvnr0011_doSearchVNAP(param);
    }

    // 첨부파일, 조회
    public List<Map<String, Object>> cvnr0011_doSearchATTD(Map<String, String> param) {
        return cvnr0010_mapper.cvnr0011_doSearchATTD(param);
    }

    // 거래희망 고객사, 조회
    public List<Map<String, Object>> cvnr0011_doSearchVNCM(Map<String, String> param) {
        return cvnr0010_mapper.cvnr0011_doSearchVNCM(param);
    }
    @Autowired private MAUA0010_Mapper maua0010_Mapper;

    // 승인
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public Map<String, String>  cvnr0011_doConfirm(Map<String, String> param) throws Exception {
        Map<String, String> rtnMap = new HashMap<>();

        cvnr0010_mapper.cvnr0011_doConfirm(param);
        cvnr0010_mapper.cvnr0011_doUpdateCvur(param);
        cvnr0010_mapper.cvnr0011_doUpdateVngl(param);
        
        Map<String, String> map = cvnr0010_mapper.cvnr0011_vendorUserId(param);

        List<Map<String, Object>> userList = cvnr0010_mapper.vendorUserList(param);

        for(Map<String,Object> user : userList) {
        	user.put("CTRL_CD", "SR020");
        	user.put("USE_FLAG", "1");
            maua0010_Mapper.insertTaskPersonInCharge(user);
        }
        
        Map<String, String> corpData = cvnr0010_mapper.cvnr0011_corpList(param);
        if(corpData != null) {
        	cvnr0010_mapper.cvnr0011_doInsertCorp(corpData);
        	cvnr0010_mapper.cvnr0011_doInsertBrc(corpData);
        	cvnr0010_mapper.cvnr0011_doInsertBrcDetail(corpData);
        	cvnr0010_mapper.cvnr0011_doInsertDept(corpData);
        }else{
        	Map<String, String> corpDept = cvnr0010_mapper.cvnr0011_corpDeptList(param);
        	if(corpDept != null) {
        		cvnr0010_mapper.cvnr0011_doInsertDeptCust(corpDept);
        	}
        }
        
        List<Map<String, Object>> corpUserList = cvnr0010_mapper.cnvr0011_userList(param);
        
        for(Map<String,Object> corpUser : corpUserList) {
        	cvnr0010_mapper.cnvr0011_doInsertUserComm(corpUser);
        	cvnr0010_mapper.cnvr0011_doInsertUserBasic(corpUser);
        	cvnr0010_mapper.cnvr0011_doInsertUserDetail(corpUser);
        }
        
        String subject = "[전자구매시스템] 요청하신 협력사 [" + param.get("VENDOR_NM") + "]의 등록이 [승인]되었습니다";
        
        //SMS
        Map<String,String> smsMap = new HashMap<String,String>();
        smsMap.put("CONTENTS", subject);
        smsMap.put("REF_MODULE_CD", "SVD02");
        smsMap.put("RECV_USER_ID", map.get("USER_ID"));

        Map<String, String> costInfo = cvnr0010_mapper.costSmsInfo(param);
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

        //EMAIL
        String linkUrl = PropertiesManager.getString("eversrm.urls.maintain.real") ;
        Map<String,String> mailMap = new HashMap<>();
        mailMap.put("SUBJECT", subject);

        String content = "<BR> 안녕하십니까!                      " +
                "<BR> [" + param.get("VENDOR_NM") + "] [" + map.get("USER_NM") + "]님" +
                "<BR>                   " +
                "<BR> 아래와 같이 협력업체 등록요청이 처리되었습니다." +
                "<BR> 협력업체 : [" + param.get("VENDOR_NM") + "]" +
                "<BR> 가입자 : [" + map.get("USER_NM") + "]" +
                "<BR> 처리결과 : [승인]" +
                "<BR> " +
                "<BR> 전자구매시스템에 <a href='" + linkUrl + "' target='newP'>로그인</a> 하시어, 세부내용을 확인 해주십시오." +
                "<BR>                   " +
                "<BR> 감사합니다.";

        mailMap.put("CONTENTS", content);
        mailMap.put("REF_MODULE_CD", "MVD01");
        mailMap.put("RECV_USER_ID", map.get("USER_ID"));
        mailMap.put("REF_NUM", "");
        evermailservice.SendMail(mailMap);

        rtnMap.put("rtnMsg", msg.getMessage("0001"));

        return rtnMap;
    }
 
    // 반려
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public Map<String, String>  cvnr0011_doReject(Map<String, String> param) throws Exception {
        Map<String, String> rtnMap = new HashMap<>();

        cvnr0010_mapper.cvnr0011_doReject(param);

        Map<String, String> map = cvnr0010_mapper.cvnr0011_vendorUserId(param);
        if( map != null && map.size() > 0) {
	        //SMS
	        String subject = "[전자구매시스템] 요청하신 협력사 [" + param.get("VENDOR_NM") + "]의 등록이 [반려]되었습니다.";
	        
	        Map<String,String> smsMap = new HashMap<String,String>();
	        smsMap.put("CONTENTS", subject + " 구매시스템 내 회원가입 > 사업자번호 입력 > 가입확인 을 통해 반려사유를 조회하세요.");
	        smsMap.put("REF_MODULE_CD", "SVD02");
	        smsMap.put("RECV_USER_ID", param.get("VENDOR_CD"));
	
	        Map<String, String> costInfo = cvnr0010_mapper.costSmsInfo(param);
	        smsMap.put("CORP_NO", costInfo.get("CORP_NO"));     	// 고객사 사업자번호
	        smsMap.put("BRC", costInfo.get("BRC"));             	// 고객사 부서
	        smsMap.put("EPRO_PS_DSC", "1");     					// 1  : 구매
	        smsMap.put("EPRO_RATE_DSC", "01");  					// 01 : 최초
	        smsMap.put("APLY_DT", costInfo.get("APLY_DT"));     	// 발생일 YYYYMMDD
	        smsMap.put("USER_ID", costInfo.get("USER_ID"));     	// 고객사 보내는사람 ID
	        smsMap.put("CONT_TBL_ID", "STOCVNCM");              	// 검증 테이블
	        smsMap.put("CONT_TBL_PK", costInfo.get("CONT_TBL_PK")); // 검증 조건
	        smsMap.put("tmp", costInfo.get("CONT_TBL_PK"));         // 유니크한 값.
	        smsMap.put("payFlag", "Y");
	        eversmsservice.sendSmsNhe(smsMap);
	
	        //EMAIL
	        Map<String,String> mailMap = new HashMap<>();
	        mailMap.put("SUBJECT", subject);
	
	        String content = "<BR> 안녕하십니까!                      " +
	                "<BR> [" + param.get("VENDOR_NM") + "] [" + map.get("USER_NM") + "]님" +
	                "<BR>                   " +
	                "<BR> 아래와 같이 협력업체 등록요청이 처리되었습니다." +
	                "<BR> 협력업체 : [" + param.get("VENDOR_NM") + "]" +
	                "<BR> 가입자 : [" + map.get("USER_NM") + "]" +
	                "<BR> 처리결과 : [반려]" +
	                "<BR> " +
	                "<BR> 처리결과를 확인 하시기 바랍니다." +
	                "<BR>                   " +
	                "<BR> 감사합니다.";
	
	        mailMap.put("CONTENTS", content);
	        mailMap.put("REF_MODULE_CD", "MVD01");
	        mailMap.put("RECV_USER_ID", map.get("USER_ID"));
	        mailMap.put("REF_NUM", "");
	        evermailservice.SendMail(mailMap);
        }

        rtnMap.put("rtnMsg", msg.getMessage("0058"));
        return rtnMap;
    }

    /**
     * 화면명 : 협력업체현황
     * 처리내용 : 등록된 협력사정보를 조회하는 화면
     * 경로 : 고객사 > 기준정보 > 협력업체관리 > 협력업체현황
     */
    public List<Map<String, Object>> cvnr0020_doSearch(Map<String, String> param) {
        return cvnr0010_mapper.cvnr0020_doSearch(param);
    }

}
