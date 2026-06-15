package com.st_ones.nhepro.CCUR.web;

import com.st_ones.common.util.clazz.EverConverter;
import com.st_ones.everf.serverside.info.BaseInfo;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.nhepro.CCUR.service.CCUR0023_Service;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;
import java.util.Map;

/**
 * <pre>
 * *****************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 * *****************************************************************************
 * </pre>
 *
 * @File Name : CCUR0021_Controller.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

@Controller
@RequestMapping(value = "/nhepro/CCUR")
public class CCUR0023_Controller extends BaseController {

    @Autowired private CCUR0023_Service ccur0023_service;

    /**
     * 화면명 : 직무관리/직무별-사용자매핑
     * 처리내용 : 직무를 조회/관리하며, 등록된 직무에 사용자를 매핑하여 권한을 부여할 수 있다.
     * 경로 : 시스템관리 > 기본정보 > 직무관리/직무별-사용자매핑
     */
    /**
     * 화면명 : 품목분류-속성매핑
     * 처리내용 : 품목 세분류의 속성을 매핑하는 화면.
     * 경로 : 품목관리 > 품목분류/SG > 품목분류-속성매핑
     */
    @RequestMapping(value = "/CCUR0023/view")
    public String CCUR0023(EverHttpRequest req) throws Exception {
        return "/nhepro/CCUR/CCUR0023";
    }

    @RequestMapping(value = "/CCUR0023/ccur0023_doSearchTree")
    public void ccur0023_doSearchTree(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> formData = req.getFormData();
        BaseInfo baseInfo = (BaseInfo)req.getSession().getAttribute("ses");
        formData.put("CUST_CD", baseInfo.getCompanyCd());

        List<Map<String, Object>> list = ccur0023_service.ccur0023_doSearch_ItemClassPopup_TREE(formData);
        resp.setParameter("treeData", EverConverter.getJsonString(list));
    }

    @RequestMapping(value = "/CCUR0023/ccur0023_doSearch")
    public void oitr0070_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> param = req.getFormData();
        resp.setGridObject("grid", ccur0023_service.ccur0023_doSearch(param));
    }
}