package com.st_ones.nhepro.CBDR.service;

import com.st_ones.common.docNum.service.DocNumService;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.common.util.service.LargeTextService;
import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.nhepro.CBDR.CBDR0080_Mapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2014 ST-Ones CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : CBDR0080_Service.java
 * @date 2020. 5. 27.
 * @version 1.0
 */

@Service(value = "cbdr0080_Service")
public class CBDR0080_Service extends BaseService {

    @Autowired private MessageService msg;

    @Autowired private LargeTextService largeTextService;

    @Autowired private DocNumService docNumService;

    @Autowired private CBDR0080_Mapper cbdr_Mapper;

    /**
     * 화면명 : 기술평가진행현황
     * 처리내용 : 평가자로 지정된 사용자가 배정된 평가건을 조회, 평가할 수 있는 화면.
     * 경로 : 고객사 > 구매관리 > 입찰관리 > 기술평가진행 > 기술평가진행현황
     */
    public List<Map<String, Object>> cbdr0080_doSearch(Map<String, String> param) throws Exception {
        return cbdr_Mapper.cbdr0080_doSearch(param);
    }

    /**
     * 화면명 : 기술평가등록
     * 처리내용 : 협력업체별 평가를 수행하는 화면.
     * 경로 : 고객사 > 구매관리 > 입찰관리 > 기술평가진행 > 기술평가진행현황 > 기술평가등록
     */
    public List<Map<String, Object>> cbdr0081_doSearch(Map<String, String> param) throws Exception {
        return cbdr_Mapper.cbdr0081_doSearch(param);
    }

    public Map<String, String> getEiHtml(Map<String, String> formData) throws Exception {

        Map<String, String> rtnMap = new HashMap<String, String>();

        // EI_SQ를 '1,2,3,4,5,...'의 형태로 가져와 jsp로 return 한다.
        String eiSqList = cbdr_Mapper.cbdr0081_getEiSqList(formData);
        rtnMap.put("eiSqList", eiSqList);

        String rtnHtmlTag = "";
        List<Map<String, Object>> rtnList = new ArrayList<Map<String, Object>>();
        Map<String, String> param = new HashMap<String, String>();
        param.putAll(formData);

        rtnHtmlTag += "<div>\n";
        rtnHtmlTag += "   <div></div>\n";
        rtnHtmlTag += "        <div style='width: 1162px;'>\n";
        rtnHtmlTag += "            <table class='header_table' width='100%' border='0' style='float: left; height: 100px;'>\n";
        rtnHtmlTag += "                <colgroup>\n";
        rtnHtmlTag += "                    <col style='text-align: center;' width='450'>\n";
        rtnHtmlTag += "                    <col style='text-align: center;' width='*'>\n";
        rtnHtmlTag += "                    <col style='text-align: left;' width='350'>\n";
        rtnHtmlTag += "                </colgroup>\n";

        rtnHtmlTag += "            <tr height='30'>\n";
        rtnHtmlTag += "                <td class='header_title' colspan='3'>&nbsp;평가상세내용</td>\n";
        rtnHtmlTag += "            </tr>\n";

        int typeACnt;
        List<Map<String, Object>> listTypeA = cbdr_Mapper.cbdr0081_getHtmlTypeA(param);
        for(int i = 0; i < listTypeA.size(); i++) {

        	typeACnt = 1;
            Map<String, Object> mapTypeA = listTypeA.get(i);
            mapTypeA.put("BUYER_CD", param.get("BUYER_CD"));
            mapTypeA.put("EI_NUM", param.get("EI_NUM"));

            rtnHtmlTag += "            <tr height='30'>\n";
            rtnHtmlTag += "                <td class='header_first' colspan='3'>" + String.valueOf(i + 1) + "." +  String.valueOf(mapTypeA.get("EV_ITEM_TYPE_NM")) + "</td>\n";
            rtnHtmlTag += "            </tr>\n";

            List<Map<String, Object>> listTypeB = cbdr_Mapper.cbdr0081_getHtmlTypeB(mapTypeA);
            for(int j = 0; j < listTypeB.size(); j++) {

                Map<String, Object> mapTypeB = listTypeB.get(j);
                mapTypeB.put("BUYER_CD", param.get("BUYER_CD"));
                mapTypeB.put("EI_NUM", param.get("EI_NUM"));
                mapTypeB.put("VENDOR_CD", param.get("VENDOR_CD"));
                mapTypeB.put("EU_SQ", param.get("EU_SQ"));

                String evItemContents = String.valueOf(mapTypeB.get("EV_ITEM_CONTENTS"));
                if(evItemContents.length() > 0) {
                    evItemContents = String.valueOf(mapTypeB.get("EV_ITEM_CONTENTS")).replaceAll("ㅇ", "<br>ㅇ");
                    if(evItemContents.substring(0, 4).equals("<br>")) {
                        evItemContents = evItemContents.substring(4, evItemContents.length());
                    }
                }

                rtnHtmlTag += "        <tr height='20'>\n";
                rtnHtmlTag += "            <td class='header_first' style='text-align: left; padding-left: 14px;' colspan='3'>" + String.valueOf(i + 1) + "." + String.valueOf(typeACnt++) + String.valueOf(mapTypeB.get("EV_ITEM_SUBJECT")) + "</td>\n";
                rtnHtmlTag += "        </tr>\n";

                rtnHtmlTag += "        <tr height='50'>\n";
                rtnHtmlTag += "            <td class='header_input' style='text-align: left; padding-left: 28px; line-height: 20px;'>" + evItemContents + "</td>\n";
                rtnHtmlTag += "            <td class='header_input' style='text-align: left; line-height: 20px;'>\n";

                String remarkVal = "";
                List<Map<String, Object>> listTypeC = cbdr_Mapper.cbdr0081_getHtmlTypeC(mapTypeB);
                for(int k = 0; k < listTypeC.size(); k++) {
                    Map<String, Object> mapTypeC = listTypeC.get(k);
                    if(String.valueOf(mapTypeB.get("SCALE_TYPE_CD")).equals("A")) { // 절대치
                        rtnHtmlTag += "        <div>\n";
                        rtnHtmlTag += "            <input type='radio' style='display:block; float: left; margin-left: 5px; margin-top: 4px;' id='EI_SQ_" + String.valueOf(mapTypeB.get("EI_SQ")) + "' name='EI_SQ_" + String.valueOf(mapTypeB.get("EI_SQ")) + "' value='" + String.valueOf(mapTypeC.get("EV_ID_SCORE")) + "' " + (mapTypeC.get("RESULT_SCORE") == null || String.valueOf(mapTypeC.get("RESULT_SCORE")).equals("") || String.valueOf(mapTypeC.get("RESULT_SCORE")).equals("null") || String.valueOf(mapTypeC.get("RESULT_SCORE")).equals("0") ? "" : "checked='checked'") + "/>";
                        rtnHtmlTag += "            &nbsp;" + String.valueOf(mapTypeC.get("EV_ID_CONTENTS")) + "\n";
                        rtnHtmlTag += "        </div>\n";
                    }
                    else if(String.valueOf(mapTypeB.get("SCALE_TYPE_CD")).equals("M")) { // 직접입력
                        rtnHtmlTag += "        <div style='width: 70px;float: left;'>&nbsp;" + String.valueOf(mapTypeC.get("EV_ID_CONTENTS")) + "</div>\n";
                        rtnHtmlTag += "        <input type='number' style='width: 50px;' id='EI_SQ_" + String.valueOf(mapTypeB.get("EI_SQ")) + "_EI_ID_SQ_" + String.valueOf(mapTypeC.get("EI_ID_SQ")) + "' name='EI_SQ_" + String.valueOf(mapTypeB.get("EI_SQ")) + "_EI_ID_SQ_" + String.valueOf(mapTypeC.get("EI_ID_SQ")) + "' value='" + (mapTypeC.get("RESULT_SCORE") == null || String.valueOf(mapTypeC.get("RESULT_SCORE")).equals("") || String.valueOf(mapTypeC.get("RESULT_SCORE")).equals("null") ? "0" : String.valueOf(mapTypeC.get("RESULT_SCORE"))) + "'/>\n";
                        rtnHtmlTag += "        &nbsp;배점[" + String.valueOf(mapTypeC.get("EV_ID_SCORE")) + "]<br>\n";
                        rtnHtmlTag += "        <input type='hidden' id='EI_SQ_" + String.valueOf(mapTypeB.get("EI_SQ")) + "_EI_ID_SQ_SCORE_" + String.valueOf(mapTypeC.get("EI_ID_SQ")) + "' name='EI_SQ_" + String.valueOf(mapTypeB.get("EI_SQ")) + "_EI_ID_SQ_SCORE_" + String.valueOf(mapTypeC.get("EI_ID_SQ")) + "' value='" + String.valueOf(mapTypeC.get("EV_ID_SCORE")) + "'/>\n";
                    }
                    if(mapTypeC.get("REMARK") != null && !String.valueOf(mapTypeC.get("REMARK")).equals("") && !String.valueOf(mapTypeC.get("REMARK")).equals("null")) {
                        remarkVal = String.valueOf(mapTypeC.get("REMARK"));
                    }
                }
                rtnHtmlTag += "                <input type='hidden' id='EV_ITEM_SUBJECT_EI_SQ_" + String.valueOf(mapTypeB.get("EI_SQ")) + "' name='EV_ITEM_SUBJECT_EI_SQ_" + String.valueOf(mapTypeB.get("EI_SQ")) + "' value='" + mapTypeB.get("EV_ITEM_SUBJECT") + "'/>\n";
                rtnHtmlTag += "                <input type='hidden' id='SCALE_TYPE_CD_EI_SQ_" + String.valueOf(mapTypeB.get("EI_SQ")) + "' name='SCALE_TYPE_CD_EI_SQ_" + String.valueOf(mapTypeB.get("EI_SQ")) + "' value='" + mapTypeB.get("SCALE_TYPE_CD") + "'/>\n";
                rtnHtmlTag += "                <input type='hidden' id='EI_SQ_" + String.valueOf(mapTypeB.get("EI_SQ")) + "_IDS' name='EI_SQ_" + String.valueOf(mapTypeB.get("EI_SQ")) + "_IDS' value='" + mapTypeB.get("EI_ID_SQ_LIST") + "'/>\n";
                rtnHtmlTag += "            </td>\n";
                rtnHtmlTag += "            <td class='header_remark' style='text-align: left;'>평가의견<br>\n";
                rtnHtmlTag += "                <textArea class='header_text' id='REMARK_EI_SQ_" + String.valueOf(mapTypeB.get("EI_SQ")) + "' name='REMARK_EI_SQ_" + String.valueOf(mapTypeB.get("EI_SQ")) + "' cols='45' rows='5'>" + remarkVal + "</textarea>\n";
                rtnHtmlTag += "            </td>\n";
                rtnHtmlTag += "        </tr>\n";

            }
        }
        rtnHtmlTag += "                <tr><td colspan='3'>&nbsp;</td></tr>\n";
        rtnHtmlTag += "            </table>\n";
        rtnHtmlTag += "        </div><br><br>\n";
        rtnHtmlTag += "</div>\n";

        rtnMap.put("eiHtml", rtnHtmlTag);

        return rtnMap;
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String cbdr0081_doSaveR(Map<String, String> formData, List<Map<String, Object>> eiLists) throws Exception {

        // 완료여부를 체크한다.
        Map<String, Object> sParam = new HashMap<String, Object>();
        sParam.putAll(formData);
        String compliteFlag = cbdr_Mapper.getCompliteFlag(sParam);
        if(EverString.nullToEmptyString(compliteFlag).equals("Y")) {
            throw new Exception(msg.getMessageByScreenId("CBDR0081", "003"));
        }

        // EI_SQ = '0'으로 담당자의 첨부파일, 평가의견을 등록한다.
        Map<String, Object> hdData = new HashMap<String, Object>();
        hdData.put("BUYER_CD", formData.get("BUYER_CD"));
        hdData.put("EI_NUM", formData.get("EI_NUM"));
        hdData.put("EI_SQ", "0");
        hdData.put("EU_SQ", formData.get("EU_SQ"));
        hdData.put("VENDOR_CD", formData.get("VENDOR_CD"));
        hdData.put("ATT_FILE_NUM", formData.get("ATT_FILE_NUM"));
        hdData.put("REMARK", formData.get("REMARK"));
        cbdr_Mapper.cbdr0081_doMergeResult(hdData);

        for(Map<String, Object> eiData : eiLists) {
            eiData.put("BUYER_CD", formData.get("BUYER_CD"));
            eiData.put("EI_NUM", formData.get("EI_NUM"));
            eiData.put("EU_SQ", formData.get("EU_SQ"));
            eiData.put("VENDOR_CD", formData.get("VENDOR_CD"));
            cbdr_Mapper.cbdr0081_doMergeResult(eiData);
        }

        return msg.getMessage("0031");
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String cbdr0081_doFinishEval(Map<String, String> formData, List<Map<String, Object>> gridDatas) throws Exception {

        for(Map<String, Object> gridData : gridDatas) {

            // 완료여부를 체크한다.
            String compliteFlag = cbdr_Mapper.getCompliteFlag(gridData);
            if(EverString.nullToEmptyString(compliteFlag).equals("Y")) {
                throw new Exception(msg.getMessageByScreenId("CBDR0081", "003"));
            }

            cbdr_Mapper.cbdr0081_doCompliteET(gridData);

            // 입찰에 참가한 모든 업체에 대한 완료처리를 했는지 여부를 조회하여 STOCBDEU.PROGRESS_CD = '300'으로 Update한다.
            String finishPossibleFlag = cbdr_Mapper.getFinishPossibleFlag(gridData);
            if(EverString.nullToEmptyString(finishPossibleFlag).equals("Y")) {
                gridData.put("PROGRESS_CD", "300"); // 평가완료
                cbdr_Mapper.cbdr0081_doFinishEU(gridData);
            }
        }
        return msg.getMessageByScreenId("CBDR0081", "004");
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String cbdr0081_doCompleteEvel(Map<String, String> formData, List<Map<String, Object>> gridDatas) throws Exception {

    	if ("NE".equals(formData.get("CONT_TYPE2"))) {
        	formData.put("BID_STATUS", "2368");
            cbdr_Mapper.cbdr0081_doCompleteEvel(formData);
    	}

        for(Map<String, Object> gridData : gridDatas) {

        	if ("0".equals(gridData.get("EV_EXCEPT_FLAG"))) {
        		continue;
        	}

        	cbdr_Mapper.cbdr0081_doEvExceptET(gridData);
        }

        /* 기술평가수행에서 완료한 평가점수를 STOCBDSP에 Insert한다. */
        List<Map<String, Object>> etResults = cbdr_Mapper.cbdr0081_getEtResults(formData);
        for(Map<String, Object> etResult : etResults) {
            cbdr_Mapper.cbdr0081_doInsertSP(etResult);
        }

        return msg.getMessageByScreenId("CBDR0081", "004");
    }

    /**
     * 화면명 : 기술평가결과현황
     * 처리내용 : 평가자로 지정된 사용자가 배정된 평가건을 조회, 평가할 수 있는 화면.
     * 경로 : 고객사 > 구매관리 > 입찰관리 > 기술평가결과 > 기술평가결과현황
     */
    public List<Map<String, Object>> cbdr0090_doSearch(Map<String, String> param) throws Exception {
        return cbdr_Mapper.cbdr0090_doSearch(param);
    }
    
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String cbdr0090_doUserChange(Map<String, String> formData, List<Map<String, Object>> gridDatas) throws Exception {

        for(Map<String, Object> gridData : gridDatas) {
            gridData.put("CHANGE_USER_ID", formData.get("CHANGE_USER_ID"));
            cbdr_Mapper.cbdr0090_doUserChange(gridData);
        }
        return msg.getMessageByScreenId("CBDR0090", "016");
    }

}