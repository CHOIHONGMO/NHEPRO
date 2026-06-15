package com.st_ones.nhepro.OETR.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.st_ones.common.mail.service.EverMailService;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.sms.service.EverSmsService;
import com.st_ones.common.util.clazz.EverDate;
import com.st_ones.common.util.service.LargeTextService;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.nhepro.OETR.OETR0040_Mapper;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : OETR0040_Service.java
 * @date 2018. 01. 30.
 * @version 1.0
 */

@Service(value = "OETR0040_Service")
public class OETR0040_Service extends BaseService {

    @Autowired MessageService msg;
    @Autowired OETR0040_Mapper oetr0040_mapper;
    @Autowired LargeTextService largeTextService;
    @Autowired private EverMailService evermailservice;
    @Autowired private EverSmsService eversmsservice;
    
    /**
     * 화면명 : 고객의 소리(VOC)
     * 처리내용 : VOC를 조회하는화면.
     * 경로 : 운영사 > My Page > My Page > 고객의 소리(VOC)
     */
    public List<Map<String, Object>> oetr0040_doSearch(Map<String, String> param) {
        return oetr0040_mapper.oetr0040_doSearch(param);
    }

    /**
     * 화면명 : 고객의소리 상세
     * 처리내용 : VOC를 조치하고 처리하는 결과를 입력하는 화면.
     * 경로 : 운영사 > My Page > My Page > 고객의 소리 > 고객의소리 상세 (팝업)
     */
    public Map<String, Object> oetr0041_doSearch(Map<String, String> param) {

        return oetr0040_mapper.oetr0041_doSearch(param);
    }

    // 저장
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public Map<String, String> oetr0041_doSave(Map<String, String> param) throws Exception {
    	
        String PROGRESS_CD = param.get("PROGRESS_CD");
        if("500".equals(PROGRESS_CD)) {
            param.put("DS_DATE", EverDate.getFormatString("yyyy-MM-dd HH:mm:ss"));
            
            String linkUrl = PropertiesManager.getString("eversrm.urls.maintain.real") ;
            String subject = "[전자구매시스템] VOC담당자 [" + param.get("DS_USER_NM") + "](이)가 귀하께서 등록하신 [" + param.get("VOC_TYPE_NM") + "] 관련 조치를 등록하였습니다";
            //SMS
            Map<String,String> smsMap = new HashMap<String,String>();
            smsMap.put("CONTENTS", subject);
            smsMap.put("REF_MODULE_CD", "SVOC05");
            smsMap.put("RECV_USER_ID", param.get("REQ_USER_ID"));

            Map<String, String> costInfo = oetr0040_mapper.costSmsInfo(param);
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
                    "<BR> 고객사 : [" + param.get("REQ_COM_NM") + "]" +
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
            mailMap.put("REF_MODULE_CD", "MVOC05");
            mailMap.put("RECV_USER_ID", param.get("REQ_USER_ID"));
            mailMap.put("REF_NUM", param.get("VC_NO"));
            evermailservice.SendMail(mailMap);
        }
        
        oetr0040_mapper.oetr0041_doSave(param);
        param.put("message", msg.getMessage("0001"));
        return param;
    }

}
