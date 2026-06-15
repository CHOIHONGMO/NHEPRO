package com.st_ones.nhepro.CETR.web;

import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.common.util.clazz.EverDate;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.nhepro.CETR.service.CETR0030_Service;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.HashMap;
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
 * @File Name : CETR0030_Controller.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

@Controller
@RequestMapping(value = "/nhepro/CETR")
public class CETR0030_Controller extends BaseController {

    @Autowired private CETR0030_Service cetr0030_service;

    /**
     * 화면명 : 게시판
     * 처리내용 : 납품과 관련된 공지사항을 조회/삭제하는 화면.
     * 	 * 경로 : 고객사 > My Page > My Page > 게시판
     */
    @RequestMapping(value="/CETR0030/view")
    public String CETR0030(EverHttpRequest req) {
        req.setAttribute("addFromDate", EverDate.addDateMonth(EverDate.getDate(), -1));
        req.setAttribute("addToDate", EverDate.addDateMonth(EverDate.getDate(), +2));

        return "/nhepro/CETR/CETR0030";
    }

    // 조회
    @RequestMapping(value = "/cetr0030_doSearch")
    public void cetr0030_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.setGridObject("grid", cetr0030_service.cetr0030_doSearch(req.getFormData()));
    }

    /**
     * 화면명 : 게시판 상세
     * 처리내용 : 납품과 관련된 공지사항을 작성하는 화면.
     * 경로 : 고객사 > My Page > My Page > 게시판 > 신규등록 (팝업), 상세 (팝업)
     */
    @RequestMapping(value="/CETR0031/view")
    public String CETR0031(EverHttpRequest req) throws Exception {
        Map<String, String> param = new HashMap<>();
        Map<String, Object> formData = new HashMap<>();
        UserInfo userInfo = UserInfoManager.getUserInfo();

        boolean havePermission;
        String noticeNum = EverString.nullToEmptyString(req.getParameter("NOTICE_NUM"));
        String BUYER_CD = EverString.nullToEmptyString(req.getParameter("BUYER_CD"));
        String detailView = EverString.nullToEmptyString(req.getParameter("detailView"));

        if(!noticeNum.equals("")) {
            param.put("NOTICE_NUM", noticeNum);
            param.put("BUYER_CD", BUYER_CD);
            param.put("detailView", detailView);

            formData = cetr0030_service.cetr0031_doSearchNoticeInfo(param);

            havePermission = userInfo.getUserId().equals(String.valueOf(formData.get("REG_USER_ID")));
        } else {
            formData.put("REG_DATE", EverDate.getDate());
            formData.put("REG_USER_NM", userInfo.getUserNm());
            formData.put("USER_TYPE", "USNA");  // 게시구분 : 전체
            formData.put("ANN_FLAG", "0");      // 공지구분 : N

            havePermission = true;
        }

        req.setAttribute("formData", formData);
        req.setAttribute("havePermission", havePermission);

        return "/nhepro/CETR/CETR0031";
    }

    // 저장
    @RequestMapping(value = "/cetr0031_doSave")
    public void cetr0031_doSave(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> rtnMap = cetr0030_service.cetr0031_doSave(req.getFormData());

        resp.setParameter("NOTICE_NUM", rtnMap.get("NOTICE_NUM"));
        resp.setResponseMessage(rtnMap.get("rtnMsg"));
    }

    // 삭제
    @RequestMapping(value = "/cetr0031_doDelete")
    public void cetr0031_doDelete(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        String rtnMsg = cetr0030_service.cetr0031_doDelete(req.getFormData());

        resp.setResponseMessage(rtnMsg);
    }
}
