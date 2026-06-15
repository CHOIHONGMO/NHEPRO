package com.st_ones.nhepro.CETR.web;

import java.util.HashMap;
import java.util.List;
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
import com.st_ones.nhepro.CETR.service.CETR0040_Service;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : CETR0040_Controller.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

@Controller
@RequestMapping(value = "/nhepro/CETR")
public class CETR0040_Controller extends BaseController {

    @Autowired private CETR0040_Service cetr0040_service;
    @Autowired private CommonComboService commonComboService;

    /**
     * 화면명 : 고객의 소리(VOC)
     * 처리내용 : 고객사가 시스템 운영사 및 협력업체에게 필요한 내용을 요청하고 회신을 받는 화면.
     * 경로 : 고객사 > My Page > My Page > 고객의 소리(VOC)
     */
    @RequestMapping(value="/CETR0040/view")
    public String CETR0040(EverHttpRequest req) {
    	
        req.setAttribute("START_DATE", EverDate.addDateMonth(EverDate.getDate(), -1));
        req.setAttribute("END_DATE", EverDate.getDate());
        return "/nhepro/CETR/CETR0040";
    }

    // VOC 조회
    @RequestMapping(value="/cetr0040_doSearch")
    public void cetr0040_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	
        Map<String, String> formData = req.getFormData();
        resp.setGridObject("grid", cetr0040_service.cetr0040_doSearch(formData));
    }
    
    // 내 VOC 요청건만 조회
    @RequestMapping(value="/cetr0040_doSearchMyBiz")
    public void cetr0040_doSearchMyBiz(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	
        UserInfo userInfo = UserInfoManager.getUserInfo();
        
        Map<String, String> formData = req.getFormData();
        formData.put("REQ_USER_ID", userInfo.getUserId());
        
        resp.setGridObject("grid", cetr0040_service.cetr0040_doSearch(formData));
    }

    // VOC 만족도 저장
    @RequestMapping(value = "/cetr0040_doSave")
    public void cetr0040_doSave(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        
    	String rtnMsg = cetr0040_service.cetr0040_doSave(req.getGridData("grid"));
        resp.setResponseMessage(rtnMsg);
    }

    /**
     * 화면명 : 고객의소리(VOC) 상세
     * 처리내용 : 고객사 및 협력업체가 필요한 내용을 요청하는 화면.
     * 경로 : 고객사 > My Page > My Page > 고객의 소리 > 고객의소리 상세 (팝업)
     */
    @RequestMapping(value = "/CETR0041/view")
    public String CETR0041(EverHttpRequest req) throws Exception {
    	
    	UserInfo userInfo = UserInfoManager.getUserInfo();
        Map<String, String> param = req.getParamDataMap();
        
        String VC_NO = param.get("VC_NO");
        Map<String, Object> data  = new HashMap<>();
        if( !"".equals(VC_NO) && VC_NO != null ) {
            data = cetr0040_service.cetr0041_doSearch(param);
            
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
        return "/nhepro/CETR/CETR0041";
    }

    // VOC 요청
    @RequestMapping(value = "/cetr0041_doSaveReq")
    public void cetr0041_doSaveReq(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	
        Map<String, String> formData = req.getFormData();
        
        String rtnMsg = cetr0040_service.cetr0041_doSaveReq(formData);
        resp.setResponseMessage(rtnMsg);
    }

    // VOC 저장
    @RequestMapping(value = "/cetr0041_doSave")
    public void cetr0041_doSave(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	
        Map<String, String> formData = req.getFormData();
        
        Map<String, String> result = cetr0040_service.cetr0041_doSave(formData);
        resp.setParameter("VC_NO", result.get("VC_NO"));
        resp.setParameter("COMPANY_CD", result.get("COMPANY_CD"));
        resp.setResponseMessage(result.get("message"));
    }

    // VOC 삭제
    @RequestMapping(value = "/cetr0041_doDelete")
    public void cetr0041_doDelete(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	
        Map<String, String> formData = req.getFormData();
        
        String rtnMsg = cetr0040_service.cetr0041_doDelete(formData);
        resp.setResponseMessage(rtnMsg);
    }
    
    /**
     * 2021.03.09 추가
     * 화면명 : 고객소통창구
     * 경로 : 고객사 > My Page > My Page > 고객소통창구
     */
    @RequestMapping(value="/CETR0050/view")
    public String CETR0050(EverHttpRequest req) {
    	
        req.setAttribute("START_DATE", EverDate.addDateMonth(EverDate.getDate(), -1));
        req.setAttribute("END_DATE", EverDate.getDate());
        return "/nhepro/CETR/CETR0050";
    }

    // My Page > My Page > 고객소통창구 (CETR0050) 조회
    @RequestMapping(value="/cetr0050_doSearch")
    public void cetr0050_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	
        Map<String, String> formData = req.getFormData();
        resp.setGridObject("grid", cetr0040_service.cetr0050_doSearch(formData));
    }
    
    // 내 요청건만 조회
    @RequestMapping(value="/cetr0050_doSearchMyBiz")
    public void cetr0050_doSearchMyBiz(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	
        UserInfo userInfo = UserInfoManager.getUserInfo();
        
        Map<String, String> formData = req.getFormData();
        formData.put("REQ_USER_ID", userInfo.getUserId());
        
        resp.setGridObject("grid", cetr0040_service.cetr0050_doSearch(formData));
    }

    /**
     * 2021.03.09 추가
     * 화면명 : 고객소통창구 등록
     * 경로 : 고객사 > My Page > My Page > 고객소통창구 > 고객소통창구 상세 (팝업)
     */
    @RequestMapping(value = "/CETR0051/view")
    public String CETR0051(EverHttpRequest req) throws Exception {
    	
        UserInfo userInfo = UserInfoManager.getUserInfo();
        
        Map<String, String> param = req.getParamDataMap();
        Map<String, Object> data  = new HashMap<>();
        
        String VC_NO = param.get("VC_NO");
        if( !"".equals(VC_NO) && VC_NO != null ) {
            data = cetr0040_service.cetr0051_doSearch(param);
            
            String PROGRESS_CD = EverString.nullToEmptyString(data.get("PROGRESS_CD"));
            if( "100".equals(PROGRESS_CD) ) {
                data.put("REQ_DATE", EverDate.getFormatString("yyyy-MM-dd HH:mm:ss"));
            }
            
            String companyCd = userInfo.getCompanyCd();
            String deptCd    = userInfo.getDeptCd();
            if( (!companyCd.equals(data.get("REQ_COM_CD")) && !deptCd.equals(data.get("DEPT_CD")))
              ||( companyCd.equals(data.get("REQ_COM_CD")) && !deptCd.equals(data.get("DEPT_CD"))) ) {
            	//System.out.println("=============>" + PROGRESS_CD);
            	//System.out.println("=============>" + data.get("DS_USER_ID"));
                if( "200".equals(PROGRESS_CD) || "300".equals(PROGRESS_CD) ) { // 요청, 접수
                	// 접수일시, 접수자
                	if( data.get("RECV_USER_ID") == null || "".equals(data.get("RECV_USER_ID")) ) {
	                    data.put("RECV_DATE", EverDate.getFormatString("yyyy-MM-dd HH:mm:ss"));
	                    data.put("RECV_USER_ID", userInfo.getUserId());
	                    data.put("RECV_USER_NM", userInfo.getUserNm());
                	}
                    // 조치일시, 조치자
                    if( data.get("DS_USER_ID") == null || "".equals(data.get("DS_USER_ID")) ) {
	            		data.put("DS_DATE", EverDate.getFormatString("yyyy-MM-dd HH:mm:ss"));
	                    data.put("DS_USER_ID", userInfo.getUserId());
	                    data.put("DS_USER_NM", userInfo.getUserNm());
                    }
                }
                else if( "400".equals(PROGRESS_CD) ) { // 답변중
                	if( data.get("DS_USER_ID") == null || "".equals(data.get("DS_USER_ID")) ) {
                		data.put("DS_DATE", EverDate.getFormatString("yyyy-MM-dd HH:mm:ss"));
                        data.put("DS_USER_ID", userInfo.getUserId());
                        data.put("DS_USER_NM", userInfo.getUserNm());
                	}
                }
            }
        } else {
            data.put("VC_NO", "");
            data.put("REQ_COM_CD", userInfo.getCompanyCd());
            data.put("REQ_COM_NM", userInfo.getCompanyNm());
            data.put("DEPT_CD", userInfo.getDeptCd());
            data.put("DEPT_NM", userInfo.getDeptNm());
            data.put("REQ_USER_ID", userInfo.getUserId());
            data.put("REQ_USER_NM", userInfo.getUserNm());
            data.put("REQ_DATE", EverDate.getFormatString("yyyy-MM-dd HH:mm:ss"));
        }
        
        req.setAttribute("formData", data);
        return "/nhepro/CETR/CETR0051";
    }
    
    @RequestMapping(value="/cetr0051_doSearchVOCD")
    public void cetr0051_doSearchVOCD(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	
        Map<String, String> formData = req.getFormData();
        resp.setGridObject("grid", cetr0040_service.cetr0051_doSearchVOCD(formData));
    }
    
    // 고객소통 요청
    @RequestMapping(value = "/cetr0051_doSaveReq")
    public void cetr0051_doSaveReq(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	
        Map<String, String> formData = req.getFormData();
        List<Map<String, Object>> gridDatas = req.getGridData("grid");
        
        String rtnMsg = cetr0040_service.cetr0051_doSaveReq(formData, gridDatas);
        resp.setResponseMessage(rtnMsg);
    }

    // 고객소통 저장
    @RequestMapping(value = "/cetr0051_doSave")
    public void cetr0051_doSave(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	
        Map<String, String> formData = req.getFormData();
        List<Map<String, Object>> gridDatas = req.getGridData("grid");
        
        Map<String, String> result = cetr0040_service.cetr0051_doSave(formData, gridDatas);
        resp.setParameter("VC_NO", result.get("VC_NO"));
        resp.setParameter("VC_SQ", result.get("VC_SQ"));
        resp.setResponseMessage(result.get("message"));
    }

    // 고객소통 삭제
    @RequestMapping(value = "/cetr0051_doDelete")
    public void cetr0051_doDelete(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	
        Map<String, String> formData = req.getFormData();
        
        String rtnMsg = cetr0040_service.cetr0051_doDelete(formData);
        resp.setResponseMessage(rtnMsg);
    }
}
