package com.st_ones.nhepro.OETR.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.st_ones.common.docNum.service.DocNumService;
import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.util.clazz.EverMath;
import com.st_ones.common.util.service.LargeTextService;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.everf.serverside.util.EverString;
import com.st_ones.nhepro.OETR.OETR0020_Mapper;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : OETR0020_Service.java
 * @date 2018. 01. 30.
 * @version 1.0
 */

@Service(value = "OETR0020_Service")
public class OETR0020_Service extends BaseService {

    @Autowired MessageService msg;
    @Autowired OETR0020_Mapper oetr0020_mapper;
    @Autowired LargeTextService largeTextService;
    @Autowired private DocNumService docNumService;

    /**
     * 화면명 : 공지사항
     * 처리내용 : 시스템 사용자들을 위한 공지사항을 조회/삭제하는 화면.
     * 경로 : 운영사 > My Page > My Page > 공지사항
     */
    public List<Map<String, Object>> oetr0020_doSearch(Map<String, String> param) {
    	
        return oetr0020_mapper.oetr0020_doSearch(param);
    }

    /**
     * 화면명 : 공지사항 작성
     * 처리내용 : 시스템 사용자들을 위한 공지사항을 작성하는 화면.
     * 경로 : 공급사 > My Page > My Page > 공지사항 > 신규등록 (팝업), 상세 (팝업)
     */
    public Map<String, Object> oetr0021_doSearchNoticeInfo(Map<String, String> param) throws Exception {
        Map<String, Object> rtnMap = oetr0020_mapper.oetr0021_doSearchNoticeInfo(param);

        String splitString = largeTextService.selectLargeText(String.valueOf(rtnMap.get("NOTICE_TEXT_NUM")));
        rtnMap.put("NOTICE_CONTENTS", splitString);

        if (param.get("detailView").equals("true")) {
            double cnt = Double.parseDouble(String.valueOf(rtnMap.get("VIEW_CNT"))) + 1;
            rtnMap.put("VIEW_CNT", Double.toString(cnt));

            oetr0020_mapper.oetr0021_doSaveCount(rtnMap);
        }

        rtnMap.put("VIEW_CNT", EverMath.EverNumberType(String.valueOf(rtnMap.get("VIEW_CNT")), "###,###"));

        return rtnMap;
    }

    // 저장
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public Map<String, String> oetr0021_doSave(Map<String, String> formData) throws Exception {

        UserInfo userInfo = UserInfoManager.getUserInfo();
        Map<String, String> rtnMap = new HashMap<>();

        String noticeNum = EverString.nullToEmptyString(formData.get("NOTICE_NUM"));
        String noticeTextNum = EverString.nullToEmptyString(formData.get("NOTICE_TEXT_NUM"));
        
        // 확정시 : 최종여부=1인 경우 나머지 최종여부는 "0" 처리한다.
        String lastFlag = EverString.nullToEmptyString(formData.get("POPUP_FLAG"));
        if( "1".equals(lastFlag) ) {
        	oetr0020_mapper.oetr0051_doUpdateLastFlag(formData);
        }
        
        if( noticeNum.equals("") ) {
            // 채번로직 변경. Parameter [화면에서 전달 받은 COMPANY_CD (없는 경우, ses.manageCd 또는 ses.companyCd), DOC_TYPE ]
            noticeNum = docNumService.getDocNumber(userInfo.getCompanyCd(), "NT");
            noticeTextNum = largeTextService.saveLargeText(null, formData.get("NOTICE_CONTENTS"), formData);

            formData.put("NOTICE_NUM", noticeNum);
            formData.put("NOTICE_TEXT_NUM", noticeTextNum);
            oetr0020_mapper.oetr0021_doInsert(formData);
        }
        else {
            largeTextService.saveLargeText(noticeTextNum, formData.get("NOTICE_CONTENTS"), formData);
            oetr0020_mapper.oetr0021_doUpdate(formData);
        }

        rtnMap.put("NOTICE_NUM", noticeNum);
        rtnMap.put("rtnMsg", msg.getMessage("0031"));
        return rtnMap;
    }

    // 삭제
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String oetr0021_doDelete(Map<String, String> formData) throws Exception {
    	
        Map<String, Object> param = new HashMap<>();
        param.put("NOTICE_NUM", formData.get("NOTICE_NUM"));

        oetr0020_mapper.oetr0021_doDelete(param);
        return msg.getMessage("0017");
    }
    
    /**
     * 2021.02.19 추가
     * ASP 이용계약
     * @param param
     * @return
     */
    public Map<String, Object> oetr0051_doSearchNoticeInfo(Map<String, String> param) throws Exception {
    	
        Map<String, Object> rtnMap = oetr0020_mapper.oetr0021_doSearchNoticeInfo(param);
        String splitString = largeTextService.selectLargeText(String.valueOf(rtnMap.get("NOTICE_TEXT_NUM")));
        
        rtnMap.put("NOTICE_CONTENTS", splitString);
        return rtnMap;
    }
    
    public List<Map<String, Object>> oetr0060_doSearch(Map<String, String> param) {
    	
        return oetr0020_mapper.oetr0060_doSearch(param);
    }
    
    public Map<String, Object> oetr0061_doSearchNoticeInfo(Map<String, String> param) throws Exception {
    	
        Map<String, Object> rtnMap = oetr0020_mapper.oetr0061_doSearchNoticeInfo(param);
        String splitString = largeTextService.selectLargeText(String.valueOf(rtnMap.get("NOTICE_TEXT_NUM")));
        
        rtnMap.put("NOTICE_CONTENTS", splitString);
        return rtnMap;
    }

}
