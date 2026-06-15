package com.st_ones.nhepro.OETR.service;

import com.st_ones.common.docNum.service.DocNumService;
import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.util.clazz.EverMath;
import com.st_ones.common.util.service.LargeTextService;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.everf.serverside.util.EverString;
import com.st_ones.nhepro.OETR.OETR0030_Mapper;
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
 * @File Name : OETR0030_Service.java
 * @date 2018. 01. 30.
 * @version 1.0
 */

@Service(value = "OETR0030_Service")
public class OETR0030_Service extends BaseService {

    @Autowired MessageService msg;
    @Autowired OETR0030_Mapper oetr0030_mapper;
    @Autowired LargeTextService largeTextService;
    @Autowired private DocNumService docNumService;

    /**
     * 화면명 : 게시판
     * 처리내용 : 납품과 관련된 공지사항을 조회/삭제하는 화면.
     * 	 * 경로 : 운영사 > My Page > My Page > 게시판
     */
    public List<Map<String, Object>> oetr0030_doSearch(Map<String, String> param) {
        return oetr0030_mapper.oetr0030_doSearch(param);
    }

    /**
     * 화면명 : 게시판 상세
     * 처리내용 : 납품과 관련된 공지사항을 작성하는 화면.
     * 경로 : 운영사 > My Page > My Page > 게시판 > 신규등록 (팝업), 상세 (팝업)
     */
    public Map<String, Object> oetr0031_doSearchNoticeInfo(Map<String, String> param) throws Exception {
        Map<String, Object> rtnMap = oetr0030_mapper.oetr0031_doSearchNoticeInfo(param);

        String splitString = largeTextService.selectLargeText(String.valueOf(rtnMap.get("NOTICE_TEXT_NUM")));
        rtnMap.put("NOTICE_CONTENTS", splitString);

        if (param.get("detailView").equals("true")) {
            double cnt = Double.parseDouble(String.valueOf(rtnMap.get("VIEW_CNT"))) + 1;
            rtnMap.put("VIEW_CNT", Double.toString(cnt));

            oetr0030_mapper.oetr0031_doSaveCount(rtnMap);
        }

        rtnMap.put("VIEW_CNT", EverMath.EverNumberType(String.valueOf(rtnMap.get("VIEW_CNT")), "###,###"));

        return rtnMap;
    }

    // 저장
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public Map<String, String> oetr0031_doSave(Map<String, String> formData) throws Exception {

        UserInfo userInfo = UserInfoManager.getUserInfo();
        Map<String, String> rtnMap = new HashMap<>();

        String noticeNum = EverString.nullToEmptyString(formData.get("NOTICE_NUM"));
        String noticeTextNum = EverString.nullToEmptyString(formData.get("NOTICE_TEXT_NUM"));

        if(noticeNum.equals("")) {

            // 채번로직 변경. Parameter [화면에서 전달 받은 COMPANY_CD (없는 경우, ses.manageCd 또는 ses.companyCd), DOC_TYPE ]
            noticeNum = docNumService.getDocNumber(userInfo.getCompanyCd(), "NT");
            noticeTextNum = largeTextService.saveLargeText(null, formData.get("NOTICE_CONTENTS"));

            formData.put("NOTICE_NUM", noticeNum);
            formData.put("NOTICE_TEXT_NUM", noticeTextNum);

            oetr0030_mapper.oetr0031_doInsert(formData);
        }
        else {

            largeTextService.saveLargeText(noticeTextNum, formData.get("NOTICE_CONTENTS"));

            oetr0030_mapper.oetr0031_doUpdate(formData);
        }

        if("USXX".equals(formData.get("VIEW_TYPE"))) {
            String[] vendorCds = formData.get("VENDOR_CD").split(",");
            String[] vendorDeptCds = formData.get("VENDOR_CD").split(",");

            oetr0030_mapper.oetr0031_doDeleteSTOCNOTV(formData);

            for(int i = 0; i < vendorCds.length; i++) {
                formData.put("COMPANY_CD", vendorCds[i]);
                formData.put("COMPANY_DEPT_CD", vendorDeptCds[i]);

                oetr0030_mapper.oetr0031_doInsertSTOCNOTV(formData);
            }
        }

        rtnMap.put("NOTICE_NUM", noticeNum);
        rtnMap.put("rtnMsg", msg.getMessage("0031"));
        return rtnMap;
    }

    // 삭제
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String oetr0031_doDelete(Map<String, String> formData) throws Exception {
        Map<String, Object> param = new HashMap<>();

        param.put("NOTICE_NUM", formData.get("NOTICE_NUM"));

        oetr0030_mapper.oetr0031_doDelete(param);

        return msg.getMessage("0017");
    }
}
