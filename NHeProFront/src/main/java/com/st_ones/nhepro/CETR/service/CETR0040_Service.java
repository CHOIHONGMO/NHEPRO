package com.st_ones.nhepro.CETR.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.st_ones.common.docNum.service.DocNumService;
import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.common.mail.service.EverMailService;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.sms.service.EverSmsService;
import com.st_ones.common.util.clazz.EverDate;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.common.util.service.LargeTextService;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.nhepro.CETR.CETR0040_Mapper;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : CETR0040_Service.java
 * @date 2018. 01. 30.
 * @version 1.0
 */

@Service(value = "CETR0040_Service")
public class CETR0040_Service extends BaseService {

    @Autowired MessageService msg;
    @Autowired CETR0040_Mapper cetr0040_mapper;
    @Autowired LargeTextService largeTextService;
    @Autowired private DocNumService docNumService;
    @Autowired private EverMailService evermailservice;
    @Autowired private EverSmsService eversmsservice;
    
    Logger logger = LoggerFactory.getLogger(this.getClass());
    
    /**
     * 화면명 : 고객의 소리(VOC)
     * 처리내용 : 고객사가 시스템 운영사 및 협력업체에게 필요한 내용을 요청하고 회신을 받는 화면.
     * 경로 : 고객사 > My Page > My Page > 고객의 소리(VOC)
     */
    public List<Map<String, Object>> cetr0040_doSearch(Map<String, String> param) {
    	
        return cetr0040_mapper.cetr0040_doSearch(param);
    }

    // VOC 만족도 저장
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String cetr0040_doSave(List<Map<String, Object>> gridDatas) throws Exception {
        
    	for (Map<String, Object> gridData : gridDatas) {
            cetr0040_mapper.cetr0040_doSave(gridData);
        }
        return msg.getMessage("0164");
    }

    /**
     * 화면명 : 고객의소리 상세
     * 처리내용 : 고객사 및 협력업체가 필요한 내용을 요청하는 화면.
     * 경로 : 고객사 > My Page > My Page > 고객의 소리 > 고객의소리 상세 (팝업)
     */
    public Map<String, Object> cetr0041_doSearch(Map<String, String> param) {
    	
        return cetr0040_mapper.cetr0041_doSearch(param);
    }

    // VOC 요청
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String cetr0041_doSaveReq(Map<String, String> param) throws Exception {
    	
        UserInfo userInfo = UserInfoManager.getUserInfo();
        String VOC_OBJ    = param.get("VOC_OBJ");
        
        param.put("PROGRESS_CD", "200");
        if( !"".equals(param.get("VC_NO")) && param.get("VC_NO") != null ) {
            cetr0040_mapper.cetr0041_doUpdate(param);
        }
        else {
            String COMPANY_CD = "";
            if("USNI".equals(VOC_OBJ)) {	// VOC대상: 운영사
                COMPANY_CD = userInfo.getManageCd();
            } else {	// VOC대상: 협력업체
                COMPANY_CD = userInfo.getCompanyCd();
            }
            
            param.put("VC_NO", docNumService.getDocNumber(COMPANY_CD, "VC"));
            param.put("COMPANY_CD", COMPANY_CD);
            param.put("VIEW_TYPE", "VOC");
            cetr0040_mapper.cetr0041_doInsert(param);
        }

        // 처음등록시 해당 고객사/공급사 담당자에게 mail, sms 전송
        Map<String, String> sendInfo = new HashMap<>();
        sendInfo.put("VC_NO", param.get("VC_NO"));
        sendInfo.put("VOC_OBJ", param.get("VOC_OBJ"));
        sendInfo.put("VOC_TYPE", param.get("VOC_TYPE"));
        
        if("USNI".equals(VOC_OBJ)) {	// VOC대상: 운영사
            sendInfo.put("CTRL_CD", "AR030");
            sendInfo.put("BUYER_CD", userInfo.getManageCd());
        } else {	// VOC대상: 협력업체
            sendInfo.put("CTRL_CD", "SR020");
            sendInfo.put("BUYER_CD", param.get("VOC_OBJ_SUP_CD"));
        }
        
        String linkUrl = PropertiesManager.getString("eversrm.urls.maintain.real") ;
        List<Map<String, String>> mapBACP = cetr0040_mapper.cetr0041_getSelectBACP(sendInfo);    // 직무에서 조회, 담당자 아이디, 이메일, 전화번호
        for(Map<String, String> data : mapBACP) {
        	String subject = "[전자구매시스템] 고객사 [" + param.get("REQ_COM_NM") + " - " + param.get("REQ_USER_NM") + "]에서 [" + data.get("VOC_TYPE_NM") + "] 관련 VOC를 등록하였습니다";
            
        	//SMS
            if("1".equals(data.get("SMS_FLAG")) || "USNI".equals(VOC_OBJ)) {
                Map<String,String> smsMap = new HashMap<String,String>();
                smsMap.put("CONTENTS", subject);
                smsMap.put("REF_MODULE_CD", "SVOC01");
                smsMap.put("RECV_USER_ID", data.get("CTRL_USER_ID"));
                
                // 2021.07.12 : 고객사에서 VOC 등록시 고객사에 SMS 수수료 부과
                smsMap.put("CORP_NO", data.get("CORP_NO"));     	// 고객사 사업자번호
                smsMap.put("BRC", data.get("BRC"));             	// 고객사 부서
                smsMap.put("EPRO_PS_DSC", "1");     				// 1:구매
                smsMap.put("EPRO_RATE_DSC", "01");  				// 01
                smsMap.put("APLY_DT", data.get("APLY_DT"));     	// 발생일 YYYYMMDD
                smsMap.put("USER_ID", data.get("USER_ID"));     	// 고객사 보내는사람 ID
                smsMap.put("CONT_TBL_ID", "STOCVOCM");              // 검증 테이블
                smsMap.put("CONT_TBL_PK", data.get("CONT_TBL_PK")); // 검증 조건
                smsMap.put("tmp", param.get("REQ_USER_ID"));		// 유니크한 값.
                smsMap.put("payFlag", "Y");
                
                eversmsservice.sendSmsNhe(smsMap);
            }

            //EMAIL
            if("1".equals(data.get("MAIL_FLAG")) || "USNI".equals(VOC_OBJ)) {
                Map<String,String> mailMap = new HashMap<>();
                mailMap.put("SUBJECT", subject);
                
                String content = "<BR> 안녕하십니까!" +
                        "<BR> [" + data.get("CTRL_USER_NM") + "]님" +
                        "<BR> " +
                        "<BR> 아래와 같이 고객사에서 VOC를 등록 하였습니다." +
                        "<BR> 고객사 : [" + param.get("REQ_COM_NM") + "]" +
                        "<BR> 등록자 : [" + param.get("REQ_USER_NM") + "]" +
                        "<BR> 등록일 : [" + param.get("REQ_DATE") + "]" +
                        "<BR> VOC유형 : [" + data.get("VOC_TYPE_NM") + "]" +
                        "<BR> 등록내용 : [" + param.get("REQ_RMK") + "]" +
                		"<BR> " +
                        "<BR> 전자구매시스템에 <a href='" + linkUrl + "' target='newP'>로그인</a> 하시어, 세부내용을 확인 후 처리 해주십시오." +
                        "<BR> " +
                        "<BR> 감사합니다.";
                
                mailMap.put("CONTENTS", content);
                mailMap.put("REF_MODULE_CD", "MVOC01");
                mailMap.put("RECV_USER_ID", data.get("CTRL_USER_ID"));
                mailMap.put("REF_NUM", param.get("VC_NO"));
                evermailservice.SendMail(mailMap);
            }
        }
        
        return msg.getMessage("0122");
    }

    // VOC 저장
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public Map<String, String> cetr0041_doSave(Map<String, String> param) throws Exception {
    	
        UserInfo userInfo  = UserInfoManager.getUserInfo();
        String VOC_OBJ     = param.get("VOC_OBJ");
        String PROGRESS_CD = param.get("PROGRESS_CD");
        if( "".equals(PROGRESS_CD) || "100".equals(PROGRESS_CD) ) {
            param.put("PROGRESS_CD", "100");
        }
        else if("500".equals(PROGRESS_CD)) {
        	param.put("DS_DATE", EverDate.getFormatString("yyyy-MM-dd HH:mm:ss"));
        }
        
        if( !"".equals(param.get("VC_NO")) && param.get("VC_NO") != null ) {
            if("100".equals(PROGRESS_CD)) {
                cetr0040_mapper.cetr0041_doUpdate(param);
            } else {
                cetr0040_mapper.cetr0041_doUpdate2(param);
            }
        }
        else {
            String COMPANY_CD = "";
            if("USNI".equals(VOC_OBJ)) {    // VOC대상: 운영사
                COMPANY_CD = userInfo.getManageCd();
            } else {    // VOC대상: 협력업체
                COMPANY_CD = userInfo.getCompanyCd();
            }
            
            param.put("VC_NO", docNumService.getDocNumber(COMPANY_CD, "VC"));
            param.put("COMPANY_CD", COMPANY_CD);
            param.put("VIEW_TYPE", "VOC");
            cetr0040_mapper.cetr0041_doInsert(param);
        }

        if("500".equals(PROGRESS_CD)) {
            String linkUrl = PropertiesManager.getString("eversrm.urls.maintain.real") ;
            String subject = "[전자구매시스템] VOC담당자 [" + param.get("DS_USER_NM") + "](이)가 귀하께서 등록한 [" + param.get("VOC_TYPE_NM") + "] 관련 조치를 등록하였습니다";
            //SMS
            Map<String,String> smsMap = new HashMap<String,String>();
            smsMap.put("CONTENTS", subject);
            smsMap.put("REF_MODULE_CD", "SVOC02");
            smsMap.put("RECV_USER_ID", param.get("REQ_USER_ID"));

            Map<String, String> costInfo = cetr0040_mapper.costSmsInfo(param);
            if( costInfo != null && costInfo.size() > 0 ) {
	            smsMap.put("CORP_NO", costInfo.get("CORP_NO"));     	// 고객사 사업자번호
	            smsMap.put("BRC", costInfo.get("BRC"));             	// 고객사 부서
	            smsMap.put("EPRO_PS_DSC", "1");     					// 1:구매
	            smsMap.put("EPRO_RATE_DSC", "01");  					// 01
	            smsMap.put("APLY_DT", costInfo.get("APLY_DT"));     	// 발생일 YYYYMMDD
	            smsMap.put("USER_ID", costInfo.get("USER_ID"));     	// 고객사 보내는사람 ID
	            smsMap.put("CONT_TBL_ID", "STOCVOCM");              	// 검증 테이블
	            smsMap.put("CONT_TBL_PK", costInfo.get("CONT_TBL_PK")); // 검증 조건
	            smsMap.put("tmp", param.get("REQ_USER_ID"));			// 유니크한 값.
	            smsMap.put("payFlag", "Y");
            }
            eversmsservice.sendSmsNhe(smsMap);

            //EMAIL
            Map<String,String> mailMap = new HashMap<>();
            mailMap.put("SUBJECT", subject);

            String content = "<BR> 안녕하십니까!" +
                    "<BR> [" + param.get("REQ_COM_NM") + "][" + param.get("REQ_USER_NM") + "]님" +
                    "<BR> " +
                    "<BR> 아래와 같이 " + param.get("DS_USER_NM") + "님이 VOC 답변을 등록 하였습니다." +
                    "<BR> 협력사 : [" + param.get("REQ_COM_NM") + "]" +
                    "<BR> 등록자 : [" + param.get("REQ_USER_NM") + "]" +
                    "<BR> 등록일 : [" + param.get("REQ_DATE") + "]" +
                    "<BR> VOC유형 : [" + param.get("VOC_TYPE_NM") + "]" +
                    "<BR> 등록내용 : [" + param.get("REQ_RMK") + "]" +
                    "<BR> 답변내용 : [" + param.get("DF_RMK") + "]" +
            		"<BR> " +
                    "<BR> 전자구매시스템에 <a href='" + linkUrl + "' target='newP'>로그인</a> 하시어, 세부내용을 확인 해주십시오." +
                    "<BR> " +
                    "<BR> 감사합니다.";

            mailMap.put("CONTENTS", content);
            mailMap.put("REF_MODULE_CD", "MVOC02");
            mailMap.put("RECV_USER_ID", param.get("REQ_USER_ID"));
            mailMap.put("REF_NUM", param.get("VC_NO"));
            evermailservice.SendMail(mailMap);
        }

        param.put("message", msg.getMessage("0001"));
        return param;
    }

    // VOC 삭제
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String cetr0041_doDelete(Map<String, String> param) throws Exception {
    	
        cetr0040_mapper.cetr0041_doDelete(param);
        return msg.getMessage("0017");
    }
    
    /**
     * 2021.03.09 추가
     * 화면명 : 고객의 소리(VOC)
     * 경로 : 고객사 > My Page > My Page > 고객소통창구
     */
    public List<Map<String, Object>> cetr0050_doSearch(Map<String, String> param) {
    	
        return cetr0040_mapper.cetr0050_doSearch(param);
    }

    /**
     * 2021.03.09 추가
     * 화면명 : 고객의소리 상세
     * 경로 : 고객사 > My Page > My Page > 고객소통창구 > 고객소통창구 상세 (팝업)
     */
    public Map<String, Object> cetr0051_doSearch(Map<String, String> param) {
    	
        return cetr0040_mapper.cetr0051_doSearch(param);
    }
    
    public List<Map<String, Object>> cetr0051_doSearchVOCD(Map<String, String> param) {
    	
        return cetr0040_mapper.cetr0051_doSearchVOCD(param);
    }

    // 고객소통 요청
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String cetr0051_doSaveReq(Map<String, String> param, List<Map<String, Object>> gridDatas) throws Exception {
    	
    	// 1. STOCVOCM 저장
        param.put("PROGRESS_CD", "200"); // 요청(200)
        if( !"".equals(param.get("VC_NO")) && param.get("VC_NO") != null ) {
            cetr0040_mapper.cetr0051_doUpdate(param);		// STOCVOCM
            cetr0040_mapper.cetr0051_doDeleteVOCD(param);	// STOCVOCD
        }
        else {
            param.put("VC_NO", docNumService.getDocNumber(PropertiesManager.getString("eversrm.default.company.code"), "VC"));
            param.put("VIEW_TYPE", "BCT");
            cetr0040_mapper.cetr0051_doInsert(param);		// STOCVOCM
        }
        
        // 2. STOCVOCD 저장
        for (Map<String, Object> grid : gridDatas) {
        	grid.put("VC_NO", param.get("VC_NO"));
            cetr0040_mapper.cetr0051_doInsertVOCD(grid);	// STOCVOCD
        }
        
        // 3. 고객사 담당자에게 mail, sms 전송
        String phDate = EverString.nullToEmptyString(param.get("PH_DATE")); // 조치요청일자
        if( phDate != null && !"".equals(phDate) ) {
            String linkUrl = PropertiesManager.getString("eversrm.urls.maintain.real") ;
            for (Map<String, Object> grid : gridDatas) {
                try {
                    Map<String, String> sendInfo = new HashMap<>();
                    sendInfo.put("VC_NO",  	  param.get("VC_NO"));
                    sendInfo.put("VOC_OBJ",   param.get("VOC_OBJ"));
                    sendInfo.put("VOC_TYPE",  param.get("VOC_TYPE"));
                    sendInfo.put("CTRL_CD" ,  "BR100"); // 고객사 직무관리자 권한
                    sendInfo.put("BUYER_CD",  EverString.nullToEmptyString(grid.get("BUYER_CD")));
                    sendInfo.put("DEPT_CD" ,  EverString.nullToEmptyString(grid.get("DEPT_CD")));
                    
                    List<Map<String, String>> mapBACP = cetr0040_mapper.cetr0041_getSelectBACP(sendInfo);    // 직무에서 조회, 담당자 아이디, 이메일, 전화번호
                    for(Map<String, String> data : mapBACP) {
                    	String subject = "[전자구매시스템] 고객사 [" + param.get("REQ_COM_NM") + " - " + param.get("REQ_USER_NM") + "]에서 [" + param.get("VOC_TYPE_NM") + "] 관련 업무연락을 등록하였습니다";
                        //SMS
                        if( "1".equals(data.get("SMS_FLAG")) && !"".equals(data.get("USER_CELL_NUM")) ) {
                            Map<String,String> smsMap = new HashMap<String,String>();
                            smsMap.put("CONTENTS", subject);
                            smsMap.put("REF_MODULE_CD", "SBCT01");
                            smsMap.put("RECV_USER_ID", data.get("CTRL_USER_ID"));
                            
                            // 2021.07.12 : 고객사에서 VOC 등록시 고객사에 SMS 수수료 부과
                            smsMap.put("CORP_NO", data.get("CORP_NO"));     	// 고객사 사업자번호
                            smsMap.put("BRC", data.get("BRC"));             	// 고객사 부서
                            smsMap.put("EPRO_PS_DSC", "1");     				// 1:구매
                            smsMap.put("EPRO_RATE_DSC", "01");  				// 01
                            smsMap.put("APLY_DT", data.get("APLY_DT"));     	// 발생일 YYYYMMDD
                            smsMap.put("USER_ID", data.get("USER_ID"));     	// 고객사 보내는사람 ID
                            smsMap.put("CONT_TBL_ID", "STOCVOCM");              // 검증 테이블
                            smsMap.put("CONT_TBL_PK", data.get("CONT_TBL_PK")); // 검증 조건
                            smsMap.put("tmp", param.get("REQ_USER_ID"));		// 유니크한 값.
                            smsMap.put("payFlag", "Y");
                            
                            eversmsservice.sendSmsNhe(smsMap);
                        }
                        
                        //EMAIL
                        if( "1".equals(data.get("MAIL_FLAG")) && !"".equals(data.get("USER_EMAIL")) ) {
                            Map<String,String> mailMap = new HashMap<>();
                            mailMap.put("SUBJECT", subject);
                            String content = "<BR> 안녕하십니까!" +
                                    "<BR> [" + data.get("CTRL_USER_NM") + "]님" +
                                    "<BR> " +
                                    "<BR> 아래와 같이 고객사에서 업무연락을 등록하였습니다." +
                                    "<BR> 고객사 : [" + param.get("REQ_COM_NM") + "]" +
                                    "<BR> 등록자 : [" + param.get("REQ_USER_NM") + "]" +
                                    "<BR> 등록일 : [" + param.get("REQ_DATE") + "]" +
                                    "<BR> 요청유형 : [" + param.get("VOC_TYPE_NM") + "]" +
                                    "<BR> 등록내용 : [" + param.get("REQ_RMK") + "]" +
                            		"<BR> " +
                                    "<BR> 전자구매시스템에 <a href='" + linkUrl + "' target='newP'>로그인</a> 하시어, 세부내용을 확인 후 처리 해주십시오." +
                                    "<BR> " +
                                    "<BR> 감사합니다.";
                            
                            mailMap.put("CONTENTS", content);
                            mailMap.put("REF_MODULE_CD", "MBCT01");
                            mailMap.put("RECV_USER_ID", data.get("CTRL_USER_ID"));
                            mailMap.put("REF_NUM", param.get("VC_NO"));
                            evermailservice.SendMail(mailMap);
                        }
    	            }
                } catch (Exception ex) {
                	logger.error("고객업무연락 요청 후 메일&문자 발송 오류 : " + ex.getMessage());
                }
            }
        }
        
        return msg.getMessage("0122");
    }

    // 고객소통 저장
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public Map<String, String> cetr0051_doSave(Map<String, String> param, List<Map<String, Object>> gridDatas) throws Exception {
    	
        String PROGRESS_CD = param.get("PROGRESS_CD");
        if( "".equals(PROGRESS_CD) || "100".equals(PROGRESS_CD) ) { // 작성중(100)
            param.put("PROGRESS_CD", "100");
        }
        else if( "500".equals(PROGRESS_CD) ) { // 조치완료(500)
        	param.put("DS_DATE", EverDate.getFormatString("yyyy-MM-dd HH:mm:ss"));
        }
        
        if( !"".equals(param.get("VC_NO")) && param.get("VC_NO") != null ) {
            if( "100".equals(PROGRESS_CD) ) { // 작성중(100)
                // 1. STOCVOCM 저장
                cetr0040_mapper.cetr0051_doUpdate(param);
                // 2. STOCVOCD 저장
                cetr0040_mapper.cetr0051_doDeleteVOCD(param);	// STOCVOCD
                for (Map<String, Object> grid : gridDatas) {
                	grid.put("VC_NO", param.get("VC_NO"));
                    cetr0040_mapper.cetr0051_doInsertVOCD(grid);// STOCVOCD
                }
            }
            else {
                // 1. STOCVOCM 저장
                cetr0040_mapper.cetr0051_doUpdate2(param);
            }
        }
        else {
            param.put("VC_NO", docNumService.getDocNumber(PropertiesManager.getString("eversrm.default.company.code"), "VC"));
            param.put("VIEW_TYPE", "BCT");
            
            // 1. STOCVOCM 저장
            cetr0040_mapper.cetr0051_doInsert(param);		// STOCVOCM
            
            // 2. STOCVOCD 저장
            for (Map<String, Object> grid : gridDatas) {
            	grid.put("VC_NO", param.get("VC_NO"));
                cetr0040_mapper.cetr0051_doInsertVOCD(grid);// STOCVOCD
            }
        }
        
        // 3. 회신완료인 경우 요청자에게 mail, sms 보내기
        if("500".equals(PROGRESS_CD)) {
        	try {
	            String linkUrl = PropertiesManager.getString("eversrm.urls.maintain.real") ;
	            String subject = "[전자구매시스템] 업무연락담당자 [" + param.get("DS_USER_NM") + "](이)가 귀하께서 등록한 [" + param.get("VOC_TYPE_NM") + "] 관련 답변을 등록하였습니다.";
	            //SMS
	            Map<String,String> smsMap = new HashMap<String,String>();
	            smsMap.put("CONTENTS", subject);
	            smsMap.put("REF_MODULE_CD", "SBCT02");
	            smsMap.put("RECV_USER_ID", param.get("REQ_USER_ID"));
	            
	            // 2021.07.12 업무연락 답변 등록시
	            Map<String, String> costInfo = cetr0040_mapper.costSmsInfo(param);
	            if( costInfo != null && costInfo.size() > 0 ) {
		            smsMap.put("CORP_NO", costInfo.get("CORP_NO"));     	// 고객사 사업자번호
		            smsMap.put("BRC", costInfo.get("BRC"));             	// 고객사 부서
		            smsMap.put("EPRO_PS_DSC", "1");     					// 1:구매
		            smsMap.put("EPRO_RATE_DSC", "01");  					// 01
		            smsMap.put("APLY_DT", costInfo.get("APLY_DT"));     	// 발생일 YYYYMMDD
		            smsMap.put("USER_ID", costInfo.get("USER_ID"));     	// 고객사 보내는사람 ID
		            smsMap.put("CONT_TBL_ID", "STOCVOCM");              	// 검증 테이블
		            smsMap.put("CONT_TBL_PK", costInfo.get("CONT_TBL_PK")); // 검증 조건
		            smsMap.put("tmp", param.get("REQ_USER_ID"));			// 유니크한 값.
		            smsMap.put("payFlag", "Y");
	            }
	            eversmsservice.sendSmsNhe(smsMap);
	            
	            //EMAIL
	            Map<String,String> mailMap = new HashMap<>();
	            mailMap.put("SUBJECT", subject);
	            String content = "<BR> 안녕하십니까!" +
	                    "<BR> [" + param.get("REQ_COM_NM") + "][" + param.get("REQ_USER_NM") + "]님" +
	                    "<BR> " +
	                    "<BR> 아래와 같이 " + param.get("DS_USER_NM") + "님이 업무연락 답변을 등록하였습니다." +
	                    "<BR> 고객사 : [" + param.get("REQ_COM_NM") + "]" +
	                    "<BR> 등록자 : [" + param.get("REQ_USER_NM") + "]" +
	                    "<BR> 등록일 : [" + param.get("REQ_DATE") + "]" +
	                    "<BR> 요청유형 : [" + param.get("VOC_TYPE_NM") + "]" +
	                    "<BR> 등록내용 : [" + param.get("REQ_RMK") + "]" +
	                    "<BR> 답변내용 : [" + param.get("DF_RMK") + "]" +
	            		"<BR> " +
	                    "<BR> 전자구매시스템에 <a href='" + linkUrl + "' target='newP'>로그인</a> 하시어, 세부내용을 확인 해주십시오." +
	                    "<BR> " +
	                    "<BR> 감사합니다.";
	            
	            mailMap.put("CONTENTS", content);
	            mailMap.put("REF_MODULE_CD", "MBCT02");
	            mailMap.put("RECV_USER_ID", param.get("REQ_USER_ID"));
	            mailMap.put("REF_NUM", param.get("VC_NO"));
	            evermailservice.SendMail(mailMap);
	        }
        	catch (Exception ex) {
	        	logger.error("고객업무연락 조치 완료 후 메일&문자 발송 오류 : " + ex.getMessage());
	        }
        }
        
        param.put("message", msg.getMessage("0001"));
        return param;
    }

    // 삭제
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String cetr0051_doDelete(Map<String, String> param) throws Exception {
    	
        cetr0040_mapper.cetr0051_doDelete(param);		// STOCVOCM
        cetr0040_mapper.cetr0051_doDeleteVOCD(param);	// STOCVOCD
        return msg.getMessage("0017");
    }
}
