package com.st_ones.nhepro.CBDR.web;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.st_ones.common.combo.service.CommonComboService;
import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.common.util.clazz.EverDate;
import com.st_ones.common.util.clazz.EverMath;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.nhepro.CBDR.service.CBDR0030_Service;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2014 ST-Ones CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : CBDR0030_Controller.java
 * @date 2020. 5. 18.
 * @version 1.0
 */
@Controller
@RequestMapping(value = "/nhepro/CBDR")
public class CBDR0030_Controller extends BaseController { 

    @Autowired private CommonComboService commonComboService;
    @Autowired private CBDR0030_Service cbdr_Service;

    /**
     * 화면명 : 입찰진행
     * 처리내용 : 입찰공고 마감 이후 개찰전까지의 입찰공고 목록이 조회하는 화면.
     * 경로 : 고객사 > 구매관리 > 입찰관리 > 입찰진행
     */
    @RequestMapping(value="/CBDR0030/view")
    public String cbdr0030_view(EverHttpRequest req) throws Exception {
    	String ManagerCd = PropertiesManager.getString("eversrm.customer.admin.ManagerCd");
    	UserInfo userInfo = UserInfoManager.getUserInfo();
		boolean hasManagerCd = (userInfo.getCtrlCd()).contains(ManagerCd);
		req.setAttribute("hasManagerCd", hasManagerCd);
        req.setAttribute("reqFromDate", EverDate.addDateMonth(EverDate.getDate(), -1));
        req.setAttribute("reqToDate", EverDate.addDateMonth(EverDate.getDate(), 1));
        return "/nhepro/CBDR/CBDR0030";
    }

    @RequestMapping(value = "/cbdr0030_doSearch")
    public void cbdr0030_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {

    	List<Map<String, Object>> searchList = cbdr_Service.cbdr0030_doSearch(req.getFormData());

        for (int i = 0; i < searchList.size(); i++) {
        	Map<String, Object> grid = searchList.get(i);
        	String contType2 = String.valueOf(grid.get("CONT_TYPE2"));
        	String techEvType = String.valueOf(grid.get("TECH_EV_TYPE"));
        	if (contType2.equals("TD") || contType2.equals("TS") || (contType2.equals("NE") && techEvType.equals("10"))) {
            	resp.setGridCellStyle("grid", String.valueOf(i), "BID_END_DATETIME", "color", "#0000FF");
        	} else {
            	resp.setGridCellStyle("grid", String.valueOf(i), "BID_END_DATETIME", "color", "#000000");
        	}
        }

        resp.setGridObject("grid", searchList);
    }

    @RequestMapping(value = "/cbdr0030_doUserChange")
    public void cbdr0030_doUserChange(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        List<Map<String, Object>> gridDatas = req.getGridData("grid");
        Map<String, String> formData = req.getFormData();
        formData.put("CHANGE_TYPE", EverString.nullToEmptyString(req.getParameter("CHANGE_TYPE")));
        formData.put("CHANGE_USER_ID", EverString.nullToEmptyString(req.getParameter("CHANGE_USER_ID")));

        String rtnMsg = cbdr_Service.cbdr0030_doUserChange(formData, gridDatas);
        resp.setResponseMessage(rtnMsg);
    }

    @RequestMapping(value = "/cbdr0030_doFinishEvel")
    public void cbdr0030_doFinishEvel(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        List<Map<String, Object>> gridDatas = req.getGridData("grid");

        String rtnMsg = cbdr_Service.cbdr0030_doFinishEvel(gridDatas);
        resp.setResponseMessage(rtnMsg);
    }
    
    // 유찰
    @RequestMapping(value = "/cbdr0030_doFailBid")
    public void cbdr0030_doFailBid(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> formData = req.getFormData();
        
        String rtnMsg = cbdr_Service.cbdr0030_doFailBid(formData);
        resp.setResponseMessage(rtnMsg);
    }
    
    // 재공고 진행상태 체크
    @RequestMapping(value = "/cbdr0030_doCheckWithReAnn")
    public void cbdr0030_doCheckWithReAnn(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> formData = req.getFormData();
        
        String rtnMsg = cbdr_Service.cbdr0030_doCheckWithReAnn(formData);
        resp.setResponseMessage(rtnMsg);
    }
    
    /**
     * 화면명 : 규격평가등록결과 등록
     * 처리내용 : 2단계(분리)경쟁의 규격평가 결과를 등록하는 화면
     * 경로 : 고객사 > 구매관리 > 입찰관리 > 입찰진행 > 규격평가등록결과 등록
     */
    @RequestMapping(value="/CBDI0031/view")
    public String cbdi0031_view(EverHttpRequest req) throws Exception {

        UserInfo userInfo = UserInfoManager.getUserInfo();
        boolean havePermission = false;

        Map<String, String> formData = new HashMap<String, String>();
        Map<String, String> param = new HashMap<String, String>();

        String buyerCd = EverString.nullToEmptyString(req.getParameter("BUYER_CD"));
        String bidNum = EverString.nullToEmptyString(req.getParameter("BID_NUM"));
        String bidCnt = EverString.nullToEmptyString(req.getParameter("BID_CNT"));

        if(!bidNum.equals("") && !bidCnt.equals(""))
        {
            param.put("BUYER_CD", buyerCd);
            param.put("BID_NUM", bidNum);
            param.put("BID_CNT", bidCnt);
            formData = cbdr_Service.cbdi0031_doSearchHD(param);

            if(userInfo.getUserId().equals(formData.get("EV_USER_ID"))) {
                havePermission = true;
            }
        }

        havePermission = EverString.nullToEmptyString(userInfo.getSuperUserFlag()).equals("1") ? true : havePermission;

        req.setAttribute("formData", formData);
        req.setAttribute("havePermission", havePermission);
        return "/nhepro/CBDR/CBDI0031";
    }

    @RequestMapping(value = "/cbdi0031_doSearch")
    public void cbdi0031_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.setGridObject("grid", cbdr_Service.cbdi0031_doSearch(req.getFormData()));
    }

    @RequestMapping(value = "/cbdi0031_doConfirm")
    public void cbdi0031_doConfirm(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> formData = req.getFormData();
        List<Map<String, Object>> gridDatas = req.getGridData("grid");

        String rtnMsg = cbdr_Service.cbdi0031_doConfirm(formData, gridDatas);
        resp.setResponseMessage(rtnMsg);
    }

    /**
     * 화면명 : 입찰시간 알림
     * 처리내용 : 2단계(분리)경쟁 또는 재입찰시 입찰서 제출일시 및 개찰일시를 지정하는 화면
     * 경로 : 고객사 > 구매관리 > 입찰관리 > 입찰진행 > 입찰시간 알림
     */
    @RequestMapping(value="/CBDI0032/view")
    public String cbdi0032_view(EverHttpRequest req) throws Exception {

        UserInfo userInfo = UserInfoManager.getUserInfo();
        boolean havePermission = false;

        Map<String, String> formData = new HashMap<String, String>();
        Map<String, String> param = new HashMap<String, String>();

        String buyerCd = EverString.nullToEmptyString(req.getParameter("BUYER_CD"));
        String bidNum = EverString.nullToEmptyString(req.getParameter("BID_NUM"));
        String bidCnt = EverString.nullToEmptyString(req.getParameter("BID_CNT"));

        if(!bidNum.equals("") && !bidCnt.equals(""))
        {
            param.put("BUYER_CD", buyerCd);
            param.put("BID_NUM", bidNum);
            param.put("BID_CNT", bidCnt);
            formData = cbdr_Service.cbdi0032_doSearchHD(param);

            if(userInfo.getUserId().equals(formData.get("BID_USER_ID")) || userInfo.getUserId().equals(formData.get("OPEN_USER_ID"))) {
                havePermission = true;
            }
        }

        havePermission = EverString.nullToEmptyString(userInfo.getSuperUserFlag()).equals("1") ? true : havePermission;

        req.setAttribute("formData", formData);
        req.setAttribute("havePermission", havePermission);
        req.setAttribute("today", EverDate.getDate());
        req.setAttribute("todayTime", EverDate.getTime());
        return "/nhepro/CBDR/CBDI0032";
    }

    @RequestMapping(value = "/cbdi0032_doConfirm")
    public void cbdi0032_doConfirm(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> formData = req.getFormData();

        String rtnMsg = cbdr_Service.cbdi0032_doConfirm(formData);
        resp.setResponseMessage(rtnMsg);
    }

    @RequestMapping(value = "/cbdi0032_doConfirmIndividual")
    public void cbdi0032_doConfirmIndividual(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> formData = req.getFormData();

        String rtnMsg = cbdr_Service.cbdi0032_doConfirmIndividual(formData);
        resp.setResponseMessage(rtnMsg);
    }

    /**
     * 화면명 : 입찰신청자조서 및 입찰비교표
     * 처리내용 : 입찰에 참여한 협력업체 입찰정보를 참고하여 낙찰자를 선정하는 화면
     * 경로 : 고객사 > 구매관리 > 입찰관리 > 입찰진행 > 입찰신청자조서 및 입찰비교표
     */
    @RequestMapping(value="/CBDR0033/view")
    public String cbdr0033_view(EverHttpRequest req) throws Exception {

        UserInfo userInfo = UserInfoManager.getUserInfo();
        boolean havePermission = false;
        String rtnMsg = "";

        Map<String, String> formData = new HashMap<String, String>();
        Map<String, String> param = new HashMap<String, String>();

        String buyerCd = EverString.nullToEmptyString(req.getParameter("BUYER_CD"));
        if(buyerCd.equals("") || buyerCd == null) { buyerCd = EverString.nullToEmptyString(req.getParameter("buyerCd")); }
        String bidNum    = EverString.nullToEmptyString(req.getParameter("BID_NUM"));
        String bidCnt    = EverString.nullToEmptyString(req.getParameter("BID_CNT"));
        String voteCnt   = EverString.nullToEmptyString(req.getParameter("VOTE_CNT"));
        String bidStatus = EverString.nullToEmptyString(req.getParameter("BID_STATUS"));
        String appDocNum = EverString.nullToEmptyString(req.getParameter("appDocNum"));
        String appDocCnt = EverString.nullToEmptyString(req.getParameter("appDocCnt"));

        if((!buyerCd.equals("") && !bidNum.equals("") && !bidCnt.equals("")) || (!buyerCd.equals("") && !appDocNum.equals("") && !appDocCnt.equals("")))
        {
            param.put("BUYER_CD", buyerCd);
            param.put("BID_NUM", bidNum);
            param.put("BID_CNT", bidCnt);
            param.put("VOTE_CNT", voteCnt);
            param.put("APP_DOC_NUM", appDocNum);
            param.put("APP_DOC_CNT", appDocCnt);

            // BID_STATUS가 2364, 2368, 2350, 2550(재입찰)인 경우(getBidProgressCd() = '600'), STOCBDHD.BID_STUATUS = ‘2400’으로 Update 한다.
            // 투찰단가, 금액, 예가를 복호화하며, 단일 예가인 경우, BDES.FINAL_ESTM_PRC = BDES.ESTM_PRC1로...
            // 복수 예가인 경우, 업체가 선택 한 '선택 예정가격' [BDVO.CHOICE_ESTM_NUM1, CHOICE_ESTM_NUM2]의 정보를 가져와
            // 많이 선택한 번호대로 BDES.CHOIC_ESTM_PRC1, 2, 3, 4...에 Update한 후, 4개의 평균값을 BDES.FINAL_ESTM_PRC에 Update한다.
            Map<String, Object> sParam = new HashMap<String, Object>();
            sParam.put("BUYER_CD", buyerCd);
            sParam.put("BID_NUM", bidNum);
            sParam.put("BID_CNT", bidCnt);

            String nowBidStatus = EverString.nullToEmptyString(cbdr_Service.cbdr0033_getBidStatus(sParam));

            if(nowBidStatus.equals("600") || nowBidStatus.equals("800")) {
                rtnMsg = cbdr_Service.cbdr0033_doUpdateBidStatus(param);
            }

            // 입찰정보를 조회한다.
            formData = cbdr_Service.cbdr0033_doSearchHD(param);

            // Grid의 동적컬럼(투찰차수별 입찰금액)을 생성하기 위한 데이터를 만든다.
            int listIdx = 0;
            int voteLimitCnt = Integer.parseInt(String.valueOf(formData.get("VOTE_LIMIT_CNT")));
            List<Map<String, Object>> colInfoList = new ArrayList<Map<String, Object>>();
            for(int i = voteLimitCnt; i > 0; i--) {
                Map<String, Object> colInfo = new HashMap<String, Object>();
                colInfo.put("COLUMN_ID", "BID_AMT_" + String.valueOf(i));
                colInfo.put("COLUMN_NM", "입찰금액(" + String.valueOf(i) + "차)");
                colInfoList.add(listIdx, colInfo);
                listIdx++;
            }

            req.setAttribute("columnInfos", colInfoList);
            req.setAttribute("columnsize", voteLimitCnt);

            if(userInfo.getUserId().equals(formData.get("BID_USER_ID")) || userInfo.getUserId().equals(formData.get("OPEN_USER_ID")) || userInfo.getUserId().equals(formData.get("EV_USER_ID"))) {
                havePermission = true;
            }

            if(formData.get("BID_STATUS").equals("2500")) {
                Map<String, String> settleData = cbdr_Service.getSettleVendor(formData);
                formData.put("SETTLE_VENDOR", settleData.get("VENDOR_CD"));
                formData.put("SETTLE_VOTE_CNT", String.valueOf(settleData.get("VOTE_CNT")));
            } else {
                formData.put("SETTLE_VENDOR", "");
                formData.put("SETTLE_VOTE_CNT", "");
            }
        }

        havePermission = EverString.nullToEmptyString(userInfo.getSuperUserFlag()).equals("1") ? true : havePermission;
        req.setAttribute("rtnMsg", rtnMsg);
        req.setAttribute("formData", formData);
        req.setAttribute("havePermission", havePermission);
        return "/nhepro/CBDR/CBDR0033";
    }

    @RequestMapping(value = "/cbdr0033_doSearchVendorVO")
    public void cbdr0033_doSearchVendorVO(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        int listIdx = 0;
        int voteLimitCnt = Integer.parseInt(EverString.nullToEmptyString(req.getParameter("voteLimitCnt")));
        List<Map<String, Object>> colInfoList = new ArrayList<Map<String, Object>>();
        for(int i = 0; i < voteLimitCnt; i++) {
            Map<String, Object> colInfo = new HashMap<String, Object>();
            colInfo.put("P_COLUMN_ID", "BID_AMT_" + String.valueOf(i+1));
            colInfo.put("P_TCO_AMT", "TCO_AMT_" + String.valueOf(i+1));
            colInfo.put("P_TABLE_ID", "VO_" + String.valueOf(i+1));
            colInfo.put("P_VOTE_CNT", String.valueOf(i+1));
            colInfoList.add(listIdx, colInfo);
            listIdx++;
        }

        Map<String,Object> sParam = new HashMap<String,Object>();
        sParam.putAll(req.getFormData());
        sParam.put("additionalColumnInfoList", colInfoList);

        String viewLotteryFlag = "N";
        List<Map<String, Object>> rtnList = cbdr_Service.cbdr0033_doSearchVendorVO(sParam);
        if(rtnList.size() > 0) {
            for(int i = 0; i < rtnList.size(); i++) {
                Map<String, Object> rtnMapI = rtnList.get(i);
                for(int j = (i+1); j < rtnList.size(); j++) {
                    Map<String, Object> rtnMapJ = rtnList.get(j);
                    if(String.valueOf(rtnMapI.get("PRICE_RANK")).equals(String.valueOf(rtnMapJ.get("PRICE_RANK")))) {
                        if(String.valueOf(rtnMapI.get("LOTTERY_FLAG")).equals("Y") ) {
                            rtnMapI.put("PRICE_RANK", "-");
                            rtnMapJ.put("PRICE_RANK", "-");
                            viewLotteryFlag = "Y";
                        }
                    }
                }
            }
        }

        // 최저가, 2단계인 경우...
        String contType2 = String.valueOf(sParam.get("CONT_TYPE2"));
        // 만약, '추첨'이 필요없다면 BDVO.BID_RANK을 Update한다.
        String bidStatus = String.valueOf(sParam.get("BID_STATUS"));
        if((!bidStatus.equals("2500") && !bidStatus.equals("1300")) && viewLotteryFlag.equals("N")) {
            if(contType2.equals("LP") || contType2.equals("TD") || contType2.equals("TS")) {
                if(rtnList.size() > 0) {
                    for(int i = 0; i < rtnList.size(); i++) {
                        Map<String, Object> rtnMap = rtnList.get(i);
                        rtnMap.put("PRICE_RANK", String.valueOf(i+1));
                    }
                    cbdr_Service.cbdr0033_setBidRank(req.getFormData(), rtnList);
                }
            }
        }

        resp.setGridObject("gridDT", rtnList);
        resp.setParameter("viewLotteryFlag", viewLotteryFlag);
    }

    @RequestMapping(value = "/cbdr0033_doLottery")
    public void cbdr0033_doLottery(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> formData = req.getFormData();
        List<Map<String, Object>> gridDatas = req.getGridData("gridDT");
        // ORI_PRICE_RANK : 가격으로 정한 순위, RANDOM_RANK : 동일한 순위일 떄 추첨을 통해 순위를 정하기 위한 숫자. (01 ~ 99)
        Collections.sort(gridDatas, new Comparator<Map<String, Object>>() {
            @Override
            public int compare(Map<String, Object> first, Map<String, Object> second) {
            Double firstVal = Double.parseDouble(String.valueOf(first.get("ORI_PRICE_RANK")) + String.valueOf(first.get("RANDOM_RANK")));
            Double secondVal = Double.parseDouble(String.valueOf(second.get("ORI_PRICE_RANK")) + String.valueOf(second.get("RANDOM_RANK")));
            return firstVal.compareTo(secondVal);
            }
        });

        for(int i = 0; i < gridDatas.size(); i++) {
            Map<String, Object> gridData = gridDatas.get(i);
            gridData.put("PRICE_RANK", (i+1));
        }

        // BDVO.BID_RANK에 순위를 Update한다.
        String rtnMsg = cbdr_Service.cbdr0033_setBidRank(formData, gridDatas);
        resp.setGridObject("gridDT", gridDatas);
        resp.setResponseMessage(rtnMsg);
    }

    @RequestMapping(value = "/cbdr0033_doSuccessfulBid")
    public void cbdr0033_doSuccessfulBid(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> formData = req.getFormData();
        List<Map<String, Object>> gridHdDatas = req.getGridData("gridHD");
        List<Map<String, Object>> gridDtDatas = req.getGridData("gridDT");

        String rtnMsg = cbdr_Service.cbdr0033_doSuccessfulBid(formData, gridHdDatas, gridDtDatas);
        resp.setResponseMessage(rtnMsg);
    }
    
    // 유찰
    @RequestMapping(value = "/cbdr0033_doFailBid")
    public void cbdr0033_doFailBid(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> formData = req.getFormData();
        
        String rtnMsg = cbdr_Service.cbdr0033_doFailBid(formData);
        resp.setResponseMessage(rtnMsg);
    }
    
    // 재공고 진행상태 체크
    @RequestMapping(value = "/cbdr0033_doCheckWithReAnn")
    public void cbdr0033_doCheckWithReAnn(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> formData = req.getFormData();
        
        String rtnMsg = cbdr_Service.cbdr0033_doCheckWithReAnn(formData);
        resp.setResponseMessage(rtnMsg);
    }

    /**
     * 화면명 : 종합낙찰제결과 등록
     * 처리내용 : 종합낙찰제의 결과를 등록하는 화면
     * 경로 : 고객사 > 구매관리 > 입찰관리 > 입찰진행 > 입찰신청자조서 및 입찰비교표 > 종합낙찰제결과 등록
     */
    @RequestMapping(value="/CBDI0034/view")
    public String cbdi0034_view(EverHttpRequest req) throws Exception {

        UserInfo userInfo = UserInfoManager.getUserInfo();
        boolean havePermission = false;

        Map<String, String> formData = new HashMap<String, String>();
        Map<String, String> param = new HashMap<String, String>();

        String buyerCd = EverString.nullToEmptyString(req.getParameter("BUYER_CD"));
        String bidNum = EverString.nullToEmptyString(req.getParameter("BID_NUM"));
        String bidCnt = EverString.nullToEmptyString(req.getParameter("BID_CNT"));
        String voteCnt = EverString.nullToEmptyString(req.getParameter("VOTE_CNT"));

        boolean evResultFlag =  ("true".equals(EverString.nullToEmptyString(req.getParameter("evResultFlag"))))? true : false;

        if(!buyerCd.equals("") && !bidNum.equals("") && !bidCnt.equals(""))
        {
            param.put("BUYER_CD", buyerCd);
            param.put("BID_NUM", bidNum);
            param.put("BID_CNT", bidCnt);
            param.put("VOTE_CNT", voteCnt);

            // 입찰정보를 조회한다.
            formData = cbdr_Service.cbdri036_doSearchHD(param);

            formData.put("PR_AMT", EverMath.EverNumberType(String.valueOf(formData.get("PR_AMT")), "###,###"));
            if (evResultFlag) {
                formData.put("MIN_BID_AMT", "-");
            } else {
                formData.put("MIN_BID_AMT", EverMath.EverNumberType(String.valueOf(formData.get("MIN_BID_AMT")), "###,###"));
            }
            formData.put("FINAL_ESTM_PRC", EverMath.EverNumberType(String.valueOf(formData.get("FINAL_ESTM_PRC")), "###,###"));
            formData.put("FINAL_ESTM_PRC_TXT", EverMath.EverNumberType(String.valueOf(formData.get("FINAL_ESTM_PRC")), "###,###") + "  " + String.valueOf(formData.get("CUR")) + " " + String.valueOf(formData.get("VAT_TYPE")));

            if(userInfo.getUserId().equals(formData.get("BID_USER_ID")) || userInfo.getUserId().equals(formData.get("OPEN_USER_ID"))) {
                havePermission = true;
            }
        }

        havePermission = EverString.nullToEmptyString(userInfo.getSuperUserFlag()).equals("1") ? true : havePermission;

        req.setAttribute("formData", formData);
        req.setAttribute("havePermission", havePermission);
        return "/nhepro/CBDR/CBDI0034";
    }

    @RequestMapping(value = "/cbdi0034_doSearchVendorVO")
    public void cbdi0034_doSearchVendorVO(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> param = req.getFormData();

        boolean evResultFlag = ("true".equals(param.get("evResultFlag")))? true : false;

        String firstNegotiatorFlag = "N";
        List<Map<String, Object>> rtnList = cbdr_Service.cbdi0034_doSearchVendorVO(param);
        for(Map<String, Object> rtnData : rtnList) {
            if(String.valueOf(rtnData.get("PRICE_RANK")).equals("-")) {
                firstNegotiatorFlag = "Y";
            }
            rtnData.put("ORI_BID_STATUS", rtnData.get("BID_STATUS"));

            if (evResultFlag) {
                rtnData.put("BID_AMT", "");
            }
        }
        resp.setGridObject("grid", rtnList);
        resp.setParameter("firstNegotiatorFlag", firstNegotiatorFlag);
    }

    @RequestMapping(value = "/cbdi0034_doFirstNegotiator")
    public void cbdi0034_doFirstNegotiator(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> formData = req.getFormData();
        List<Map<String, Object>> gridDatas = req.getGridData("grid");

        String rtnMsg = cbdr_Service.cbdi0034_doFirstNegotiator(formData, gridDatas);
        resp.setResponseMessage(rtnMsg);
    }

    @RequestMapping(value = "/cbdi0034_doApproval")
    public void cbdi0034_doApproval(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> formData = req.getFormData();
        formData.put("approvalFormData", EverString.nullToEmptyString(req.getParameter("approvalFormData")));
        formData.put("approvalGridData", EverString.nullToEmptyString(req.getParameter("approvalGridData")));
        formData.put("attachFileDatas", EverString.nullToEmptyString(req.getParameter("attachFileDatas")));

        String rtnMsg = cbdr_Service.cbdi0034_doApproval(formData);
        resp.setResponseMessage(rtnMsg);
    }

    @RequestMapping(value = "/cbdi0034_doSuccessfulBid")
    public void cbdi0034_doSuccessfulBid(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> formData = req.getFormData();
        List<Map<String, Object>> gridDatas = req.getGridData("grid");

        String rtnMsg = cbdr_Service.cbdi0034_doSuccessfulBid(formData, gridDatas);
        resp.setResponseMessage(rtnMsg);
    }

    @RequestMapping(value = "/cbdi0034_doFailBid")
    public void cbdi0034_doFailBid(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> formData = req.getFormData();
        List<Map<String, Object>> gridDatas = req.getGridData("grid");

        String rtnMsg = cbdr_Service.cbdi0034_doFailBid(formData, gridDatas);
        resp.setResponseMessage(rtnMsg);
    }

    @RequestMapping(value = "/cbdi0034_callBackIndividual")
    public void cbdi0034_callBackIndividual(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        List<Map<String, Object>> gridDatas = req.getGridData("grid");

        String rtnMsg = cbdr_Service.cbdi0034_callBackIndividual(gridDatas);
        resp.setResponseMessage(rtnMsg);
    }

    /**
     * 화면명 : 기술평가결과 등록
     * 처리내용 : 협상에 의한 계약 입찰에서 기술평가구분이 “평가결과등록” 인 경우 평가 결과를 등록하는 화면
     * 경로 : 고객사 > 구매관리 > 입찰관리 > 입찰진행 > 기술평가결과 등록
     */
    @RequestMapping(value="/CBDI0035/view")
    public String cbdi0035_view(EverHttpRequest req) throws Exception {

        UserInfo userInfo = UserInfoManager.getUserInfo();
        boolean havePermission = false;

        Map<String, String> formData = new HashMap<String, String>();
        Map<String, String> param = new HashMap<String, String>();

        String buyerCd = EverString.nullToEmptyString(req.getParameter("BUYER_CD"));
        String bidNum = EverString.nullToEmptyString(req.getParameter("BID_NUM"));
        String bidCnt = EverString.nullToEmptyString(req.getParameter("BID_CNT"));
        String voteCnt = EverString.nullToEmptyString(req.getParameter("VOTE_CNT"));

        if(!bidNum.equals("") && !bidCnt.equals(""))
        {
            param.put("BUYER_CD", buyerCd);
            param.put("BID_NUM", bidNum);
            param.put("BID_CNT", bidCnt);
            formData = cbdr_Service.cbdi0031_doSearchHD(param);

            if(userInfo.getUserId().equals(formData.get("EV_USER_ID"))) {
                havePermission = true;
            }
            formData.put("VOTE_CNT", voteCnt);
        }

        havePermission = EverString.nullToEmptyString(userInfo.getSuperUserFlag()).equals("1") ? true : havePermission;

        req.setAttribute("formData", formData);
        req.setAttribute("havePermission", havePermission);
        return "/nhepro/CBDR/CBDI0035";
    }

    @RequestMapping(value = "/cbdi0035_doSearch")
    public void cbdi0035_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.setGridObject("grid", cbdr_Service.cbdi0035_doSearch(req.getFormData()));
    }

    @RequestMapping(value = "/cbdi0035_doConfirm")
    public void cbdi0035_doConfirm(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> formData = req.getFormData();
        List<Map<String, Object>> gridDatas = req.getGridData("grid");

        String rtnMsg = cbdr_Service.cbdi0035_doConfirm(formData, gridDatas);
        resp.setResponseMessage(rtnMsg);
    }

    /**
     * 화면명 : 적격심사결과 등록
     * 처리내용 : 적격심사 결과를 등록하는 화면
     * 경로 : 고객사 > 구매관리 > 입찰관리 > 입찰진행 > 입찰신청자조서 및 입찰비교표 > 적격심사결과 등록
     */
    @RequestMapping(value="/CBDI0036/view")
    public String cbdi0036_view(EverHttpRequest req) throws Exception {

        UserInfo userInfo = UserInfoManager.getUserInfo();
        boolean havePermission = false;

        Map<String, String> formData = new HashMap<String, String>();
        Map<String, String> param = new HashMap<String, String>();

        String buyerCd = EverString.nullToEmptyString(req.getParameter("BUYER_CD"));
        String bidNum = EverString.nullToEmptyString(req.getParameter("BID_NUM"));
        String bidCnt = EverString.nullToEmptyString(req.getParameter("BID_CNT"));
        String voteCnt = EverString.nullToEmptyString(req.getParameter("VOTE_CNT"));

        if(!buyerCd.equals("") && !bidNum.equals("") && !bidCnt.equals(""))
        {
            param.put("BUYER_CD", buyerCd);
            param.put("BID_NUM", bidNum);
            param.put("BID_CNT", bidCnt);
            param.put("VOTE_CNT", voteCnt);

            // 입찰정보를 조회한다.
            formData = cbdr_Service.cbdri036_doSearchHD(param);

            formData.put("BASIC_AMT", EverMath.EverNumberType(String.valueOf(formData.get("BASIC_AMT")), "###,###"));
            formData.put("MIN_BID_AMT", EverMath.EverNumberType(String.valueOf(formData.get("MIN_BID_AMT")), "###,###"));
            formData.put("FINAL_ESTM_PRC", EverMath.EverNumberType(String.valueOf(formData.get("FINAL_ESTM_PRC")), "###,###"));
            formData.put("FINAL_ESTM_PRC_TXT", EverMath.EverNumberType(String.valueOf(formData.get("FINAL_ESTM_PRC")), "###,###") + "  " + String.valueOf(formData.get("CUR")) + " " + String.valueOf(formData.get("VAT_TYPE")));

            if(userInfo.getUserId().equals(formData.get("BID_USER_ID")) || userInfo.getUserId().equals(formData.get("OPEN_USER_ID"))) {
                havePermission = true;
            }
        }

        havePermission = EverString.nullToEmptyString(userInfo.getSuperUserFlag()).equals("1") ? true : havePermission;

        req.setAttribute("formData", formData);
        req.setAttribute("havePermission", havePermission);
        return "/nhepro/CBDR/CBDI0036";
    }

    @RequestMapping(value = "/cbdi0036_doSearchVendorVO")
    public void cbdi0036_doSearchVendorVO(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> param = req.getFormData();

        String bidStatus = param.get("BID_STATUS");

        String viewLotteryFlag = "N";
        List<Map<String, Object>> rtnList = cbdr_Service.cbdi0036_doSearchVendorVO(param);
        if(rtnList.size() > 0) {
            for(int i = 0; i < rtnList.size(); i++) {
                Map<String, Object> rtnMapI = rtnList.get(i);
                for(int j = (i+1); j < rtnList.size(); j++) {
                    Map<String, Object> rtnMapJ = rtnList.get(j);
                    if(String.valueOf(rtnMapI.get("PRICE_RANK")).equals(String.valueOf(rtnMapJ.get("PRICE_RANK")))) {
                        if(String.valueOf(rtnMapI.get("LOTTERY_FLAG")).equals("Y") ) {
                            rtnMapI.put("PRICE_RANK", "-");
                            rtnMapJ.put("PRICE_RANK", "-");
                            viewLotteryFlag = "Y";
                        }
                    }
                }
                // 업체별로 재입찰을 돌리는 경우, '추첨'이 필요없다.
                if(String.valueOf(rtnMapI.get("LOTTERY_FLAG")).equals("Z") ) {
                    viewLotteryFlag = "Z";
                }
                rtnMapI.put("ORI_BID_STATUS", rtnMapI.get("BID_STATUS"));
            }
        }

        // 만약, '추첨'이 필요없다면 BDVO.BID_RANK을 Update한다.
        if((!bidStatus.equals("2500") && !bidStatus.equals("1300")) && viewLotteryFlag.equals("N")) {
            if(rtnList.size() > 0) {
                for(int i = 0; i < rtnList.size(); i++) {
                    Map<String, Object> rtnMap = rtnList.get(i);
                    rtnMap.put("PRICE_RANK", String.valueOf(i+1));
                }
                cbdr_Service.cbdr0033_setBidRank(req.getFormData(), rtnList);
            }
        }

        resp.setGridObject("grid", rtnList);
        resp.setParameter("viewLotteryFlag", viewLotteryFlag);
    }

    @RequestMapping(value = "/cbdi0036_doLottery")
    public void cbdi0036_doLottery(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> formData = req.getFormData();
        List<Map<String, Object>> gridDatas = req.getGridData("grid");
        // ORI_PRICE_RANK : 가격으로 정한 순위, RANDOM_RANK : 동일한 순위일 떄 추첨을 통해 순위를 정하기 위한 숫자. (01 ~ 99)
        Collections.sort(gridDatas, new Comparator<Map<String, Object>>() {
            @Override
            public int compare(Map<String, Object> first, Map<String, Object> second) {
            Double firstVal = Double.parseDouble(String.valueOf(first.get("ORI_PRICE_RANK")) + String.valueOf(first.get("RANDOM_RANK")));
            Double secondVal = Double.parseDouble(String.valueOf(second.get("ORI_PRICE_RANK")) + String.valueOf(second.get("RANDOM_RANK")));
            return firstVal.compareTo(secondVal);
            }
        });

        for(int i = 0; i < gridDatas.size(); i++) {
            Map<String, Object> gridData = gridDatas.get(i);
            gridData.put("PRICE_RANK", (i+1));
        }

        // BDVO.BID_RANK에 순위를 Update한다.
        String rtnMsg = cbdr_Service.cbdr0033_setBidRank(formData, gridDatas);
        resp.setGridObject("grid", gridDatas);
        resp.setResponseMessage(rtnMsg);
    }

    @RequestMapping(value = "/cbdi0036_doSuccessfulBid")
    public void cbdi0036_doSuccessfulBid(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> formData = req.getFormData();
        List<Map<String, Object>> gridDatas = req.getGridData("grid");

        String rtnMsg = cbdr_Service.cbdi0036_doSuccessfulBid(formData, gridDatas);
        resp.setResponseMessage(rtnMsg);
    }

    @RequestMapping(value = "/cbdi0036_doFailBid")
    public void cbdi0036_doFailBid(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> formData = req.getFormData();
        List<Map<String, Object>> gridDatas = req.getGridData("grid");

        String rtnMsg = cbdr_Service.cbdi0036_doFailBid(formData, gridDatas);
        resp.setResponseMessage(rtnMsg);
    }

    @RequestMapping(value = "/cbdi0036_callBackIndividual")
    public void cbdi0036_callBackIndividual(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        List<Map<String, Object>> gridDatas = req.getGridData("grid");

        String rtnMsg = cbdr_Service.cbdi0036_callBackIndividual(gridDatas);
        resp.setResponseMessage(rtnMsg);
    }
    
    /**
     * 2021.02.09 추가
     * 구매관리 > 입찰관리 > 기술평가결과현황 (CBDR0090)에서 "입찰진행상태" 클릭시 팝업 추가
     * @param req
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/CBDI0037/view")
    public String cbdi0037_view(EverHttpRequest req) throws Exception {

        String buyerCd = EverString.nullToEmptyString(req.getParameter("BUYER_CD"));
        String bidNum  = EverString.nullToEmptyString(req.getParameter("BID_NUM"));
        String bidCnt  = EverString.nullToEmptyString(req.getParameter("BID_CNT"));
        String voteCnt = EverString.nullToEmptyString(req.getParameter("VOTE_CNT"));
        
        Map<String, String> param = new HashMap<String, String>();
        param.put("BUYER_CD", buyerCd);
        param.put("BID_NUM", bidNum);
        param.put("BID_CNT", bidCnt);
        param.put("VOTE_CNT", voteCnt);

        // 입찰정보를 조회한다.
        Map<String, String> formData = cbdr_Service.cbdri036_doSearchHD(param);
        
        req.setAttribute("formData", formData);
        return "/nhepro/CBDR/CBDI0037";
    }
    
    // 2021.03.23 추가
    // 기술협상첨부파일, 기술협상비고, 추가첨부파일, 추가비고 등록
    @RequestMapping(value = "/cbdi0037_doSave")
    public void cbdi0037_doSave(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	
        Map<String, String> formData = req.getFormData();
        List<Map<String, Object>> gridDatas = req.getGridData("grid");
        
        Map<String, String> result = cbdr_Service.cbdi0037_doSave(formData, gridDatas);
        resp.setParameter("BUYER_CD", result.get("BUYER_CD"));
        resp.setParameter("BID_NUM" , result.get("BID_NUM"));
        resp.setParameter("BID_CNT" , result.get("BID_CNT"));
        resp.setParameter("VOTE_CNT", result.get("VOTE_CNT"));
        resp.setResponseMessage(result.get("message"));
    }
    
    /**
     * 화면명 : 입찰결과
     * 처리내용 : 개찰 이후의 입찰공고 목록이 조회된다.
     * 경로 : 고객사 > 구매관리 > 입찰관리 > 입찰결과
     */
    @RequestMapping(value="/CBDR0040/view")
    public String cbdr0040_view(EverHttpRequest req) throws Exception {
        req.setAttribute("bidStatusOptions", commonComboService.getCodesAsJson("CB0073", new HashMap<String, String>()));
        req.setAttribute("fromDate", EverDate.addDateMonth(EverDate.getDate(), -1));
        req.setAttribute("toDate", EverDate.addDateMonth(EverDate.getDate(), 1));
        return "/nhepro/CBDR/CBDR0040";
    }

    @RequestMapping(value = "/cbdr0040_doSearch")
    public void cbdr0040_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	List<Map<String, Object>> searchList = cbdr_Service.cbdr0040_doSearch(req.getFormData());

        for (int i = 0; i < searchList.size(); i++) {
        	Map<String, Object> grid = searchList.get(i);
        	String contType2 = String.valueOf(grid.get("CONT_TYPE2"));
        	String techEvType = String.valueOf(grid.get("TECH_EV_TYPE"));
        	if (contType2.equals("TD") || contType2.equals("TS") || (contType2.equals("NE") && techEvType.equals("10"))) {
            	resp.setGridCellStyle("grid", String.valueOf(i), "BID_END_DATETIME", "color", "#0000FF");
        	} else {
            	resp.setGridCellStyle("grid", String.valueOf(i), "BID_END_DATETIME", "color", "#000000");
        	}
        }

        resp.setGridObject("grid", searchList);
    }

    @RequestMapping(value = "/cbdr0040_doUserChange")
    public void cbdr0040_doUserChange(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        List<Map<String, Object>> gridDatas = req.getGridData("grid");
        Map<String, String> formData = req.getFormData();
        formData.put("CHANGE_USER_ID", EverString.nullToEmptyString(req.getParameter("CHANGE_USER_ID")));

        String rtnMsg = cbdr_Service.cbdr0040_doUserChange(formData, gridDatas);
        resp.setResponseMessage(rtnMsg);
    }

    @RequestMapping(value = "/cbdr0040_doApproval") 
    public void cbdr0040_doApproval(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	//
        List<Map<String, Object>> gridDatas = req.getGridData("grid");
        Map<String, String> formData = new HashMap<String, String>();
        formData.put("approvalFormData", EverString.nullToEmptyString(req.getParameter("approvalFormData")));
        formData.put("approvalGridData", EverString.nullToEmptyString(req.getParameter("approvalGridData")));
        formData.put("attachFileDatas", EverString.nullToEmptyString(req.getParameter("attachFileDatas")));

        String rtnMsg = cbdr_Service.cbdr0040_doApproval(formData, gridDatas);
        resp.setResponseMessage(rtnMsg);
    }

}