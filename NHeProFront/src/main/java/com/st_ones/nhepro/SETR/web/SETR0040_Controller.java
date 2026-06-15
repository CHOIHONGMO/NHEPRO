package com.st_ones.nhepro.SETR.web;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.st_ones.common.combo.service.CommonComboService;
import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.common.util.clazz.EverDate;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.nhepro.SETR.service.SETR0040_Service;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : SETR0040_Controller.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

@Controller
@RequestMapping(value = "/nhepro/SETR")
public class SETR0040_Controller extends BaseController {

    @Autowired private SETR0040_Service setr0040_service;
    @Autowired private CommonComboService commonComboService;

    /**
     * 화면명 : 고객의 소리(VOC)
     * 처리내용 : 고객사 및 운영사에서 작성한 VOC를 조히하는 화면.
     * 경로 : 협력업체 > My Page > My Page > 고객의 소리(VOC)
     */
    @RequestMapping(value="/SETR0040/view")
    public String SETR0040(EverHttpRequest req) {
        req.setAttribute("START_DATE", EverDate.addDateMonth(EverDate.getDate(), -1));
        req.setAttribute("END_DATE", EverDate.getDate());

        return "/nhepro/SETR/SETR0040";
    }

    // 조회
    @RequestMapping(value="/setr0040_doSearch")
    public void setr0040_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> formData = req.getFormData();

        resp.setGridObject("grid", setr0040_service.setr0040_doSearch(formData));
    }

    // 만족도 저장
    @RequestMapping(value = "/setr0040_doSave")
    public void setr0040_doSave(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        String rtnMsg = setr0040_service.setr0040_doSave(req.getGridData("grid"));

        resp.setResponseMessage(rtnMsg);
    }

    /**
     * 화면명 : 고객의소리 상세
     * 처리내용 : VOC를 조치하고 처리하는 결과를 입력하는 화면.
     * 경로 : 협력업체 > My Page > My Page > 고객의 소리 > 고객의소리 상세 (팝업)
     */
    @RequestMapping(value = "/SETR0041/view")
    public String SETR0041(EverHttpRequest req) throws Exception {
        
    	UserInfo userInfo = UserInfoManager.getUserInfo();
    	Map<String, String> param = req.getParamDataMap();
        
        String VC_NO = param.get("VC_NO");
        Map<String, Object> data = new HashMap<>();
        if( !"".equals(VC_NO) && VC_NO != null ) {
            data = setr0040_service.setr0041_doSearch(param);
            
            String PROGRESS_CD = EverString.nullToEmptyString(data.get("PROGRESS_CD"));
            if("100".equals(PROGRESS_CD)) {
                data.put("REQ_DATE", EverDate.getFormatString("yyyy-MM-dd HH:mm:ss"));
            }
            
            String companyCd = userInfo.getCompanyCd();
            if( !companyCd.equals(data.get("REQ_COM_CD")) ) {
                if("200".equals(PROGRESS_CD)) {
                    data.put("RECV_DATE", EverDate.getFormatString("yyyy-MM-dd HH:mm:ss"));
                    data.put("DS_USER_ID", userInfo.getUserId());
                    data.put("DS_USER_NM", userInfo.getUserNm());
                }
            }
        } else {
            data.put("VC_NO", "");
            data.put("REQ_COM_CD", userInfo.getCompanyCd());
            data.put("REQ_COM_NM", userInfo.getCompanyNm());
            data.put("REQ_DATE", EverDate.getFormatString("yyyy-MM-dd HH:mm:ss"));
            data.put("REQ_USER_ID", userInfo.getUserId());
            data.put("REQ_USER_NM", userInfo.getUserNm());
            data.put("DEPT_CD", userInfo.getDeptCd());
            data.put("DEPT_NM", userInfo.getDeptNm());
            data.put("PH_DATE", EverDate.getDate());
        }
        
        req.setAttribute("formData", data);
        return "/nhepro/SETR/SETR0041";
    }

    // 요청
    @RequestMapping(value = "/setr0041_doSaveReq")
    public void setr0041_doSaveReq(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> formData = req.getFormData();
        
        String rtnMsg = setr0040_service.setr0041_doSaveReq(formData);
        resp.setResponseMessage(rtnMsg);
    }

    // 저장
    @RequestMapping(value = "/setr0041_doSave")
    public void setr0041_doSave(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> formData = req.getFormData();

        Map<String, String> result = setr0040_service.setr0041_doSave(formData);
        resp.setParameter("VC_NO", result.get("VC_NO"));
        resp.setParameter("COMPANY_CD", result.get("COMPANY_CD"));
        resp.setResponseMessage(result.get("message"));
    }

    // 삭제
    @RequestMapping(value = "/setr0041_doDelete")
    public void setr0041_doDelete(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> formData = req.getFormData();

        String rtnMsg = setr0040_service.setr0041_doDelete(formData);

        resp.setResponseMessage(rtnMsg);
    }
}
