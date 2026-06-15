package com.st_ones.nhepro.CCTR.service;

import java.io.IOException;
import java.net.URLDecoder;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.joda.time.Days;
import org.joda.time.LocalDate;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.st_ones.common.docNum.service.DocNumService;
import com.st_ones.common.enums.econtract.ContStringUtil;
import com.st_ones.common.enums.system.Code;
import com.st_ones.common.file.service.FileAttachService;
import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.common.mail.service.EverMailService;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.serverpush.reverseajax.EverRestJson;
import com.st_ones.common.sms.service.EverSmsService;
import com.st_ones.common.util.clazz.EverCert;
import com.st_ones.common.util.clazz.EverConverter;
import com.st_ones.common.util.clazz.EverDate;
import com.st_ones.common.util.clazz.EverFile;
import com.st_ones.common.util.clazz.EverMath;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.info.BaseInfo;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.info.UserInfoNotFoundException;
import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.everf.serverside.util.EverString;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.eversrm.eApproval.eApprovalModule.service.BAPM_Service;
import com.st_ones.nhepro.CCTR.CCTR0020_Mapper;

import net.htmlparser.jericho.FormControl;
import net.htmlparser.jericho.OutputDocument;
import net.htmlparser.jericho.Source;

import com.dreamsecurity.magicline.json.*;
import com.dreamsecurity.magicline.JCaosCheckCert;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : CCTR0020_Service.java
 * @date 2020.04.17
 * @version 1.0
 * @see
 */
@Service(value = "CCTR0020_Service")
public class CCTR0020_Service extends BaseService {
	
	Logger logger = LoggerFactory.getLogger(this.getClass());
	
    @Autowired CCTR0020_Mapper cctr0020_Mapper;
    @Autowired MessageService msg;
    @Autowired DocNumService docNumService;
    @Autowired BAPM_Service approvalService;
    @Autowired private FileAttachService fileAttachService;
    @Autowired private EverSmsService everSmsService;
    @Autowired private EverMailService everMailService;

    private static final String MAIN_FORM_SQ = "0";

    /**
     * 조회한 서식을 화면에 입력한 데이터로 치환한 후 리턴합니다.
     * @param req
     * @param resp
     * @param paramMap
     * @throws Exception
     */
    public String ccta0030_getFormWithManualContractInfo(EverHttpRequest req, EverHttpResponse resp, Map<String, String> param, List<Map<String, Object>> gridDataECCM) throws Exception {

        String resultContractForm = "";
        
        String contNum   = EverString.nullToEmptyString(param.get("CONT_NUM"));
        String contCnt   = EverString.nullToEmptyString(param.get("CONT_CNT"));
        String appDocNum = EverString.nullToEmptyString(param.get("appDocNum"));
        String appDocCnt = EverString.nullToEmptyString(param.get("appDocCnt"));
        
        // 화면에서 넘어온 서식 데이터 (입력폼에 입력된 값을 유지하기 위해 화면에서 받아옴)
        String selectedFormNum  = req.getParameter("selectedFormNum"); // 화면에서 넘어온 서식번호
        if( (StringUtils.isNotEmpty(contNum) && StringUtils.isNotEmpty(contCnt)) || (StringUtils.isNotEmpty(appDocNum)  && StringUtils.isNotEmpty(appDocCnt)) ) {
        	param.put("formNum", selectedFormNum);
            Map<String, String> contInfo = cctr0020_Mapper.ccta0030_getContractInformation(param);
            param.putAll(contInfo);
        }
        
        req.setAttribute("form", param);
        return resultContractForm;
    }

	/**
	 * 화면명 : 계약대기현황 조회
	 * 처리내용 :
	 * 경로 :  >  >
	 */
    public List<Map<String,Object>> cctr0020_doSearch(Map<String, String> param) throws Exception {
    	
        return cctr0020_Mapper.cctr0020_doSearch(param);
    }
    
    /**
     * 계약대기현황에서 수기계약 이관하기
     * @param formData
     * @return
     */
    public void cctr0020_doTransferContract(Map<String, String> param) throws Exception {
    	
    	UserInfo userInfo = UserInfoManager.getUserInfo();
    	
    	//수기계약 이관할 품의번호, 품의항번 가져오기
        Map<String, Object> formData = (Map) param;
        formData.put("EXEC_NUM_SQ_LIST", Arrays.asList(param.get("EXEC_NUM_SQ").split(",")));
        
        // 문서번호 채번
        formData.put("CONT_NUM", docNumService.getDocNumber(userInfo.getCompanyCd(), "EC"));
        formData.put("CONT_CNT", "1");
        
        //1. STOCECMT 등록
        cctr0020_Mapper.cctr0020_doInsertECMT(formData);
        //2. STOCECCM 등록
        cctr0020_Mapper.cctr0020_doInsertECCM(formData);
        //3. STOCECCT 등록
        cctr0020_Mapper.cctr0020_doInsertECCT(formData);
        //4. STOCECHB 삭제
        cctr0020_Mapper.cctr0020_doDeleteECHB(formData);
    }
    
    public String makeMultiBuyerHtml(String contractForm,
                                     Map<String, String> paramMap,
                                     List<Map<String, Object>> gridDataECCM,
                                     List<Map<String, String>> buyerInformationList) throws Exception {
        /* 구매사의 추가 정보를 조회합니다. */
        Map<String, String> buyerInformation = new HashMap<>();
        StringBuffer eccmHtml = new StringBuffer();
        StringBuffer ecpcHdHtml = new StringBuffer();
        StringBuffer ecpcHtml = new StringBuffer();
        StringBuffer buyerHtml = new StringBuffer();

        String cur = paramMap.get("CUR").equals("KRW") ? "\\" : "";
        String vatTypeNm = paramMap.get("VAT_TYPE_NM");

        long contAmtSum = 0;
        long payAmtHd = 0;
        long guarAmtHd = 0;
        long payAmt = 0;
        long guarAmt = 0;
        int eccmCnt = 1;
        int ecpcHdCnt = 1;
        int ecpcCnt = 1;
        // int renderHeight = 0;

        boolean eccmFlag = false;
        boolean ecpcHdFlag = false;
        boolean ecpcFlag = false;


        buyerHtml.append("<table>");
        buyerHtml.append("<colgroup>");
        buyerHtml.append("<col width=\"87\">");
        buyerHtml.append("<col width=\"153\">");
        buyerHtml.append("<col width=\"11\">");
        buyerHtml.append("<col style=\"width: auto;\">");
        buyerHtml.append("</colgroup>");

        // colspan 을 하기 위해 업체 수 Count
        int ecpcColSpan = 1;
        int ecpcHdColSpan = 1;
        if (gridDataECCM != null) {
            for (Map<String, Object> gridECCM : gridDataECCM) {
                List<Map<String, Object>> gridDataECPC_HD = EverConverter.readJsonObject(String.valueOf(gridECCM.get("PC_HD_INFO")), List.class);
                if (gridDataECPC_HD != null && gridDataECPC_HD.size() > 0) {
                    for (Map<String, Object> gridECPC_HD : gridDataECPC_HD) {
                        ecpcHdColSpan++;
                    }
                }

                List<Map<String, Object>> gridDataECPY = EverConverter.readJsonObject(String.valueOf(gridECCM.get("PY_INFO")), List.class);
                if (gridDataECPY != null && gridDataECPY.size() > 0) {
                    for (Map<String, Object> gridECPY : gridDataECPY) {

                        List<Map<String, Object>> gridDataECPC = EverConverter.readJsonObject(String.valueOf(gridECPY.get("PC_INFO")), List.class);
                        if (gridDataECPC != null && gridDataECPC.size() > 0) {
                            for (Map<String, Object> gridECPC : gridDataECPC) {
                                if (gridECPC.get("GUAR_TYPE") != null) {
                                    if (gridECPC.get("GUAR_TYPE").equals("WARR")) {
                                        ecpcColSpan++;
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        if (gridDataECCM != null) {

            for (Map<String, Object> gridECCM : gridDataECCM) {
                buyerInformation.putAll(cctr0020_Mapper.ccta0030_getBuyerInformation(gridECCM));
                buyerInformationList.add(buyerInformation);

                buyerHtml.append("<tr>");
                if (eccmCnt == 1) {
                    buyerHtml.append("<th class=\"fs11\">계약담당자</th>");
                } else {
                    buyerHtml.append("<th class=\"fs11\"></th>");
                }
                buyerHtml.append("<th class=\"fs11\">주&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;소</th>");
                buyerHtml.append("<th class=\"fs11\">:</th>");
                buyerHtml.append("<td class=\"txt-left fs11\">" + buyerInformation.get("BUYER_ADDR") + "</td>");
                buyerHtml.append("</tr>");
                buyerHtml.append("<tr>");
                buyerHtml.append("<th></th>");
                buyerHtml.append("<th class=\"fs11\">상&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;호</th>");
                buyerHtml.append("<th class=\"fs11\">:</th>");
                buyerHtml.append("<td class=\"txt-left fs11\">" + buyerInformation.get("BUYER_NM") + "</td>");
                buyerHtml.append("</tr>");
                buyerHtml.append("<tr>");
                buyerHtml.append("<th></th>");
/*
                if(gridECCM.get("SIGN_FLAG") != null) {
                    if (gridECCM.get("SIGN_FLAG").equals("0")) {
                        buyerHtml.append("<th class=\"fs11\">담&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;당&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;자</th>");
                        buyerHtml.append("<th class=\"fs11\">:</th>");
                        buyerHtml.append("<td class=\"txt-left fs11\">" + buyerInformation.get("BUYER_CEO_NM") + "</td>");
                        buyerHtml.append("</tr>");

                        buyerHtml.append("<tr>");
                        buyerHtml.append("<th></th>");
                        buyerHtml.append("<th class=\"fs11\" style=\"letter-spacing: -1px;\">농협은행주식회사의<br>대&nbsp;&nbsp;&nbsp;&nbsp;리&nbsp;&nbsp;&nbsp;&nbsp;인</th>");
                        buyerHtml.append("<th class=\"fs11\">:</th>");
                        buyerHtml.append("<td class=\"txt-left fs11\">" + "" + "</td>");
                        buyerHtml.append("</tr>");

                        // renderHeight += 190;
                    } else {
                        buyerHtml.append("<th class=\"fs11\">대&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;표&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;자</th>");
                        buyerHtml.append("<th class=\"fs11\">:</th>");
                        buyerHtml.append("<td class=\"txt-left fs11\">" + buyerInformation.get("BUYER_NM") + " " + buyerInformation.get("BUYER_CEO_NM") + "</td>");
                        buyerHtml.append("</tr>");

                        // renderHeight += 120;
                    }
                } else {
                    buyerHtml.append("<th class=\"fs11\">대&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;표&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;자</th>");
                    buyerHtml.append("<th class=\"fs11\">:</th>");
                    buyerHtml.append("<td class=\"txt-left fs11\">" + buyerInformation.get("BUYER_NM") + " " + buyerInformation.get("BUYER_CEO_NM") + "</td>");
                    buyerHtml.append("</tr>");

                    // renderHeight += 120;
                }
*/

                if(gridECCM.get("SIGN_FLAG") != null && gridECCM.get("SIGN_FLAG").equals("0")) {
                    buyerHtml.append("<th class=\"fs11\">담&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;당&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;자</th>");
                    buyerHtml.append("<th class=\"fs11\">:</th>");
                    buyerHtml.append("<td class=\"txt-left fs11\">" + buyerInformation.get("BUYER_CEO_NM") + "</td>");
                    buyerHtml.append("</tr>");

                    buyerHtml.append("<tr>");
                    buyerHtml.append("<th></th>");
                    buyerHtml.append("<th class=\"fs11\" style=\"letter-spacing: -1px;\">" + buyerInformation.get("BUYER_NM") + " 의<br>대&nbsp;&nbsp;&nbsp;&nbsp;리&nbsp;&nbsp;&nbsp;&nbsp;인</th>");
                    buyerHtml.append("<th class=\"fs11\">:</th>");
                    buyerHtml.append("<td class=\"txt-left fs11\">" + "" + "</td>");
                    buyerHtml.append("</tr>");

                    // renderHeight += 190;
                } else {
                    buyerHtml.append("<th class=\"fs11\">대&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;표&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;자</th>");
                    buyerHtml.append("<th class=\"fs11\">:</th>");
                    buyerHtml.append("<td class=\"txt-left fs11\">" + "대표이사" + " " + buyerInformation.get("BUYER_CEO_NM") + "</td>");
                    buyerHtml.append("</tr>");

                    // renderHeight += 120;
                }

                // 계약금액 셋팅
                if (gridECCM.get("CONT_AMT") != null && EverString.isNotEmpty(String.valueOf(gridECCM.get("CONT_AMT")))) {
                    eccmHtml.append("<tr>");
                    if (eccmCnt == 1) {
                        eccmHtml.append("<th rowspan=\"" + (gridDataECCM.size() + 1) + "\" class=\"fs11\" style=\"word-break: initial;\">계<br>약<br>금<br>액</th>");
                    }
                    eccmHtml.append("<th class=\"fs11\">" + gridECCM.get("PR_BUYER_DEPT_NM") + "</th>");
                    eccmHtml.append("<td class=\"txt-left\">");
                    eccmHtml.append("<span class=\"fs11\">금"
                            + ContStringUtil.numberToKorean(String.valueOf(gridECCM.get("CONT_AMT")))
                            + "원정(" + cur
                            + ContStringUtil.toDecimalNumber(String.valueOf(gridECCM.get("CONT_AMT")))
                            + "), "
                            + vatTypeNm + "</span>");
                    eccmHtml.append("</td>");
                    eccmHtml.append("</tr>");

                    eccmFlag = true;
                }

                // 계약보증금
                List<Map<String, Object>> gridDataECPC_HD = EverConverter.readJsonObject(String.valueOf(gridECCM.get("PC_HD_INFO")), List.class);

                if (gridDataECPC_HD != null && gridDataECPC_HD.size() > 0) {
                    for(Map<String, Object> gridECPC_HD : gridDataECPC_HD) {
                        if (gridECPC_HD.get("PAY_AMT") != null && EverString.isNotEmpty(String.valueOf(gridECPC_HD.get("PAY_AMT")))) {
                            // 계약보증금 셋팅
                            ecpcHdHtml.append("<tr>");
                            if (ecpcHdCnt == 1) {
                                ecpcHdHtml.append("<th rowspan=\"" + ecpcHdColSpan + "\" class=\"fs11\" style=\"word-break: initial;\">계<br>약<br>보<br>증<br>금</th>");
                            }
                            ecpcHdHtml.append("<th class=\"fs11\" style=\"border-left: 1px solid #ccc;\">" + gridECPC_HD.get("PY_BUYER_DEPT_NM") + "</th>");
                            ecpcHdHtml.append("<td class=\"txt-left\">");
                            ecpcHdHtml.append("<span class=\"fs11\">금"
                                    + ContStringUtil.numberToKorean(String.valueOf(gridECPC_HD.get("PAY_AMT")))
                                    + "원정(" + cur
                                    + ContStringUtil.toDecimalNumber(String.valueOf(gridECPC_HD.get("PAY_AMT")))
                                    + ")"
                                    + "</span>");
                            ecpcHdHtml.append("</td>");
                            ecpcHdHtml.append("</tr>");

                            ecpcHdFlag = true;
                        }

                        if (gridECPC_HD.get("PAY_AMT") != null && gridECPC_HD.get("GUAR_AMT") != null && EverString.isNotEmpty(String.valueOf(gridECPC_HD.get("PAY_AMT"))) && EverString.isNotEmpty(String.valueOf(gridECPC_HD.get("GUAR_AMT")))) {
                            payAmtHd += Long.parseLong(String.valueOf(gridECPC_HD.get("PAY_AMT")));
                            guarAmtHd += Long.parseLong(String.valueOf(gridECPC_HD.get("GUAR_AMT")));
                        }

                        ecpcHdCnt++;
                    }
                }

                List<Map<String, Object>> gridDataECPY = EverConverter.readJsonObject(String.valueOf(gridECCM.get("PY_INFO")), List.class);

                if (gridDataECPY != null && gridDataECPY.size() > 0) {

                    for (Map<String, Object> gridECPY : gridDataECPY) {

                        List<Map<String, Object>> gridDataECPC = EverConverter.readJsonObject(String.valueOf(gridECPY.get("PC_INFO")), List.class);

                        if (gridDataECPC != null && gridDataECPC.size() > 0) {

                            for (Map<String, Object> gridECPC : gridDataECPC) {

                                if (gridECPC.get("PAY_AMT") != null && EverString.isNotEmpty(String.valueOf(gridECPC.get("PAY_AMT")))) {
                                    // 하자보증금 셋팅
                                    if (gridECPC.get("GUAR_TYPE") != null) {
                                        if (gridECPC.get("GUAR_TYPE").equals("WARR")) {
                                            ecpcHtml.append("<tr>");
                                            if (ecpcCnt == 1) {
                                                ecpcHtml.append("<th rowspan=\"" + ecpcColSpan + "\" class=\"fs11\" style=\"word-break: initial;\">하<br>자<br>보<br>증<br>금</th>");
                                            }
                                            ecpcHtml.append("<th class=\"fs11\">" + gridECPC.get("PY_BUYER_DEPT_NM") + "</th>");
                                            ecpcHtml.append("<td class=\"txt-left\">");
                                            ecpcHtml.append("<span class=\"fs11\">금"
                                                    + ContStringUtil.numberToKorean(String.valueOf(gridECPC.get("PAY_AMT")))
                                                    + "원정(" + cur
                                                    + ContStringUtil.toDecimalNumber(String.valueOf(gridECPC.get("PAY_AMT")))
                                                    + ")"
                                                    + "</span>");
                                            ecpcHtml.append("</td>");
                                            ecpcHtml.append("</tr>");

                                            if (gridECPC.get("PAY_AMT") != null && gridECPC.get("GUAR_AMT") != null && EverString.isNotEmpty(String.valueOf(gridECPC.get("PAY_AMT"))) && EverString.isNotEmpty(String.valueOf(gridECPC.get("GUAR_AMT")))) {
                                                payAmt += Long.parseLong(String.valueOf(gridECPC.get("PAY_AMT")));
                                                guarAmt += Long.parseLong(String.valueOf(gridECPC.get("GUAR_AMT")));
                                            }
                                            ecpcCnt++;

                                            ecpcFlag = true;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                if (gridECCM.get("CONT_AMT") != null && EverString.isNotEmpty(String.valueOf(gridECCM.get("CONT_AMT")))) {
                    contAmtSum += Long.parseLong(String.valueOf(gridECCM.get("CONT_AMT")));
                }
                eccmCnt++;
            }
        }

        if (gridDataECCM != null && gridDataECCM.size() > 0) {
            // 계약담당자
            buyerHtml.append("</table>");
        }

        if (eccmFlag) {
            // 계약금액 합계
            eccmHtml.append("<tr>");
            eccmHtml.append("<th class=\"fs11\">합    계</th>");
            eccmHtml.append("<td class=\"txt-left\">");
            eccmHtml.append("<span class=\"fs11\">금"
                    + ContStringUtil.numberToKorean(String.valueOf(contAmtSum))
                    + "원정(" + cur
                    + ContStringUtil.toDecimalNumber(String.valueOf(contAmtSum))
                    + "), "
                    + vatTypeNm + "</span>");
            eccmHtml.append("</td>");
            eccmHtml.append("</tr>");
        }

        if (ecpcHdFlag) {
            // 요율 계산
            double pcHdGuarPercent = ((double) guarAmtHd / (double) payAmtHd) * 100d;
            // 계약보증금 내역
            ecpcHdHtml.append("<tr>");
            ecpcHdHtml.append("<th class=\"fs11\">내    역</th>");
            ecpcHdHtml.append("<td class=\"txt-left\">");
            ecpcHdHtml.append("<span class=\"fs11\">계약금액의 " + EverMath.getRound(pcHdGuarPercent, 2) + "%에 해당하는 계약이행보증증권(지급각서) 제출</span>");
            ecpcHdHtml.append("</td>");
            ecpcHdHtml.append("</tr>");
        }

        if (ecpcFlag) {
            // 요율 계산
            double pcGuarPercent = ((double) guarAmt / (double) payAmt) * 100d;
            // 하자보증금 내역
            ecpcHtml.append("<tr>");
            ecpcHtml.append("<th class=\"fs11\">내    역</th>");
            ecpcHtml.append("<td class=\"txt-left\">");
            ecpcHtml.append("<span class=\"fs11\">계약금액의 " + EverMath.getRound(pcGuarPercent, 2) + "%에 해당하는 계약이행보증증권(지급각서) 제출</span>");
            ecpcHtml.append("</td>");
            ecpcHtml.append("</tr>");
        }

        // contractForm = contractForm.replace("&lt;div style=\"height: 120px;\"&gt;&nbsp;&lt;/div&gt;", "&lt;div style=\"height: "+ renderHeight +"px;\"&gt;&lt;/div&gt;");
        buyerHtml.append("<br>");
        contractForm = contractForm.replace("#CONT_BUYER_LIST#", buyerHtml);

        contractForm = contractForm.replace("&lt;tr&gt;\n" +
                "\t\t\t&lt;td colspan=\"3\"&gt;#CONT_MULTI_LIST#&lt;/td&gt;\n" +
                "\t\t&lt;/tr&gt;", eccmHtml.toString() + ecpcHdHtml.toString() + ecpcHtml.toString());

        return ContStringUtil.getHtmlContents(contractForm, false);
    }
    
    public String cctr0020_doResumeCheck(List<Map<String, Object>> gridData) {
        String returnStr = "";
        for (Map<String, Object> rowData : gridData) {
            returnStr = cctr0020_Mapper.cctr0020_doResumeCheck(rowData);
        }
        return returnStr;
    }
    
    /**
     * 메인 서식 가져오기
     * @param param
     * @return
     */
    public List<Map<String, Object>> ccta0030_doSearchMainForm(Map<String, String> param) {
        return cctr0020_Mapper.ccta0030_doSearchMainForm(param);
    }
    
    /**
     * 추가서식 가져오기
     * @param param
     * @return
     * @throws Exception
     */
    public List<Map<String, Object>> ccta0030_doSearchAdditionalForm(Map<String, String> param) throws Exception {
        return cctr0020_Mapper.ccta0030_doSearchAdditionalForm(param);
    }

    /**
     * CCTI0030 : 부서식 조회
     * @param param
     * @return
     * @throws Exception
     */
    public List<Map<String, Object>> doSearchAdditionalForm(Map<String, String> param) throws Exception {

        Map<String, String> contractInformation = new HashMap<String, String>();
        List<Map<String, Object>> additionalFormList = new ArrayList<Map<String, Object>>();

        if (EverString.isNotEmpty((String)param.get("CONT_NUM")) && EverString.isNotEmpty(String.valueOf(param.get("CONT_CNT")))) {

            contractInformation = cctr0020_Mapper.ccta0030_getContractInformation(param);
            additionalFormList  = cctr0020_Mapper.doSearchAdditionalForm(param);
            for (Map<String, Object> map : additionalFormList) {
                //STOCTXHD, TXDT로 변경
                //String contents = String.valueOf(map.get("CONTRACT_TEXT")); // Contract form no.
                String contents = (String) map.get("CONTRACT_TEXT");
                Map<String, String> dataMap = this.getBaseDataForm();
                dataMap.putAll(param);

                String progressCd   = contractInformation.get("PROGRESS_CD");
                String sign_status  = contractInformation.get("SIGN_STATUS");
                String sign_status2 = contractInformation.get("SIGN_STATUS2");

                // 일괄계약인 경우 부서식은 결재상신 이전까지만 수정가능함
                if (EverString.isNotEmpty(param.get("bundleNum"))) {
                    //계약서를 수정할 수 있는 상태 : 저장 전, 임시저장(4200)
                    if( EverString.isNotEmpty(progressCd) && Integer.parseInt(progressCd) > 4200 ){
                        contents = ContStringUtil.getHtmlContents(contents, true);
                    }
                } else {
                    //계약서를 수정할 수 있는 상태 : 저장 전, 임시저장(4200), 협력사서명반려(4220), 품의중(4206)(결재반려:R,상신취소:C)
                    if( !(progressCd.equals("") || progressCd.equals(Code.M135_4200) || progressCd.equals(Code.M135_4220)
                            ||(progressCd.equals(Code.M135_4203) && sign_status.equals(Code.M020_R))
                            ||(progressCd.equals(Code.M135_4206) && sign_status2.equals(Code.M020_R))
                            ||(progressCd.equals(Code.M135_4206) && sign_status2.equals(Code.M020_C))) ){

                        contents = ContStringUtil.getHtmlContents(contents, true);
                    }
                }
                map.put("ADDITIONAL_CONTENTS", contents);
            }
        }
        return additionalFormList;
    }

    /**
     * 계약서 저장
     *
     * @param formData
     * @param gridDataM
     * @param gridDataA
     * @return
     * @throws Exception
     */
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public Map<String, String> ccta0030_doSaveContract(Map<String, String> formData, List<Map<String, Object>> gridDataM, List<Map<String, Object>> gridDataA, List<Map<String, Object>> gridDataECCM, List<Map<String, Object>> gridDataECMT) throws Exception {
    	
        UserInfo userInfo = UserInfoManager.getUserInfo();
        
        String contNum = EverString.nullToEmptyString(formData.get("CONT_NUM"));
        String contCnt = EverString.nullToEmptyString(formData.get("CONT_CNT"));
        
        // 2021.05.24 추가
        // 이전계약번호(PRE_CONT_NUM)가 존재하는 경우 변경(20) 또는 연장계약(30)으로 처리
        String preContNum = EverString.nullToEmptyString(formData.get("PRE_CONT_NUM"));
        
        // 2021.05.28 추가
        // 계약서작성유형(PR : 구매의뢰, CN : 선정품의)
        String createType = EverString.nullToEmptyString(formData.get("CREATE_TYPE"));
        
        formData.put("FORM_NUM", (String) gridDataM.get(0).get("FORM_NUM"));
        formData.put("FORM_SQ", MAIN_FORM_SQ);
        
        String largeTextNum = "";
        if (StringUtils.isEmpty(contNum) && StringUtils.isEmpty(contCnt)) {
        	System.out.println("============================================================");
            System.out.println("계약번호 없을 경우 저장 시작");
            System.out.println("============================================================");
            
            // 2021.05.24 변경
            // 계약번호가 없으면 저장이 안된 상태이므로 INSERT 처리 (이전계약번호가 존재하는 경우 변경 또는 연장계약으로 처리)
            if( StringUtils.isNotEmpty(preContNum) ) {
                formData.put("CONT_NUM", preContNum);
                formData.put("CONT_CNT", cctr0020_Mapper.ccta0030_getMaxContCnt(formData));
            }
            else {
                formData.put("CONT_NUM", docNumService.getDocNumber(userInfo.getCompanyCd(), "EC"));
                formData.put("CONT_CNT", "1");
            }
            
            System.out.println("============================================================");
            System.out.println("계약번호 채번 완료");
            System.out.println("============================================================");

            // 계약정보 저장
            cctr0020_Mapper.ccta0030_doInsertECCT(formData);
            System.out.println("============================================================");
            System.out.println("ECCT Insert 완료");
            System.out.println("============================================================");
            // mainContractContents = ContStringUtil.replaceUserNotEditableForms(formData.get("mainContractContents"), formData);
            // formData.put("CONTRACT_TEXT", mainContractContents);

            largeTextNum = formData.get("CONTRACT_TEXT_NUM");
            if( EverString.isEmpty(EverString.replace(largeTextNum, " ", "")) ){
                largeTextNum = docNumService.getDocNumber(userInfo.getCompanyCd(), "TN");
                formData.put("CONTRACT_TEXT_NUM", largeTextNum);
            } else {
                formData.put("CONTRACT_TEXT_NUM", largeTextNum);
            }
            System.out.println("============================================================");
            System.out.println("Text Number 채번 완료");
            System.out.println("============================================================");
            
            // 주서식 저장
            cctr0020_Mapper.ccta0030_doInsertECRL(formData);
            System.out.println("============================================================");
            System.out.println("ECRL(주서식) Insert 완료");
            System.out.println("============================================================");

            // 고객사(ECCM), 계약보증정보(ECPC_HD), 지불정보(ECPY), 고객사별 지불고객사 정보(ECPC)
            Map<String, Object> gridInfo = new HashMap<>();
            gridInfo.put("CONT_NUM", formData.get("CONT_NUM"));
            gridInfo.put("CONT_CNT", formData.get("CONT_CNT"));
            gridInfo.put("PROGRESS_CD", formData.get("PROGRESS_CD"));

            for (Map<String, Object> gridECCM : gridDataECCM) {
                // 기본 정보를 최초 셋팅
                gridECCM.putAll(gridInfo);

                // 고객사 정보
                cctr0020_Mapper.ccta0030_doInsertECCM(gridECCM);
                System.out.println("============================================================");
                System.out.println("ECCM Insert 완료");
                System.out.println("============================================================");
                
                List<Map<String,Object>> gridDataECPC_HD = EverConverter.readJsonObject(String.valueOf(gridECCM.get("PC_HD_INFO")), List.class);
                if(gridDataECPC_HD != null && gridDataECPC_HD.size() > 0) {
                    for(Map<String, Object> gridECPC_HD : gridDataECPC_HD) {
                        gridECPC_HD.putAll(gridInfo);

                        // 계약보증(STOCECPC)
                        gridECPC_HD.put("PAY_CNT", "0");
                        cctr0020_Mapper.ccta0030_doInsertECPC(gridECPC_HD);
                        System.out.println("============================================================");
                        System.out.println("ECPC HD(계약보증) Insert 완료");
                        System.out.println("============================================================");

                        // 차액보증(STOCECPC)
                        gridECPC_HD.put("PAY_CNT", "-1"); // 지급차수
                        gridECPC_HD.put("GUAR_TYPE", gridECPC_HD.get("DI_GUAR_TYPE")); // 보증구분
                        gridECPC_HD.put("GUAR_AMT", gridECPC_HD.get("DI_GUAR_AMT")); // 차액보증금
                        gridECPC_HD.put("GUAR_PERCENT", "0"); // 요율
                        gridECPC_HD.put("ATT_FILE_NUM", gridECPC_HD.get("DI_ATT_FILE_NUM")); // 첨부파일
                        gridECPC_HD.put("GUAR_NUM", null); // 증권번호
                        gridECPC_HD.put("GUAR_TYPE2", "10"); // 보증방법
                        gridECPC_HD.put("GUARANTEER", null); // 보증기관
                        cctr0020_Mapper.ccta0030_doInsertECPC(gridECPC_HD);
                        System.out.println("============================================================");
                        System.out.println("ECPC HD(차액보증) Insert 완료");
                        System.out.println("============================================================");
                    }
                }

                List<Map<String,Object>> gridDataECPY = EverConverter.readJsonObject(String.valueOf(gridECCM.get("PY_INFO")), List.class);
                if (gridDataECPY != null && gridDataECPY.size() > 0) {
                    for(Map<String, Object> gridECPY : gridDataECPY) {
                        gridECPY.putAll(gridInfo);

                        // 지불정보(STOCECPY)
                        cctr0020_Mapper.ccta0030_doInsertECPY(gridECPY);
                        List<Map<String,Object>> gridDataECPC = EverConverter.readJsonObject(String.valueOf(gridECPY.get("PC_INFO")), List.class);

                        if(gridDataECPC != null && gridDataECPC.size() > 0) {
                            for(Map<String, Object> gridECPC : gridDataECPC) {
                                gridECPC.putAll(gridInfo);

                                // 고객사별 지불고객사 정보
                                cctr0020_Mapper.ccta0030_doInsertECPC(gridECPC);
                            }
                        }
                        System.out.println("============================================================");
                        System.out.println("ECPC Insert 완료");
                        System.out.println("============================================================");
                    }
                }
                System.out.println("============================================================");
                System.out.println("ECPY Insert 완료");
                System.out.println("============================================================");
            }

            // 품목정보(ECMT)
            for (Map<String, Object> gridECMT : gridDataECMT) {
                gridECMT.putAll(gridInfo);

                cctr0020_Mapper.ccta0030_doInsertECMT(gridECMT);
                System.out.println("============================================================");
                System.out.println("ECMT Insert 완료");
                System.out.println("============================================================");
                
                // 구매의뢰(PR) 기준 연장계약 체결
                if ("PR".equals(createType)) {
                	if( gridECMT.get("PR_NUM") != null && gridECMT.get("PR_SQ") != null ) {
                    	gridECMT.put("PROGRESS_CD", "4200");
                    	cctr0020_Mapper.setPrProgressCdReCont(gridECMT);
                        System.out.println("============================================================");
                        System.out.println("PRDT(연장계약(30) 진행상태 변경완료");
                        System.out.println("============================================================");
                	}
                }
                else {
                    // EXEC_NUM, EXEC_SQ 가 존재 시 STOCECHB 삭제
                	if( gridECMT.get("EXEC_NUM") != null && gridECMT.get("EXEC_SQ") != null ) {
                		gridECMT.put("DEL_FLAG", "1");
	                    cctr0020_Mapper.ccta0030_doDeleteECHB(gridECMT);
	                    System.out.println("============================================================");
	                    System.out.println("ECHB(계약대기정보 Delete 완료");
	                    System.out.println("============================================================");
                	}
                }
            }
        }
        else {
        	System.out.println("============================================================");
            System.out.println("계약서번호가 있을 경우 계약서 수정 시작");
            System.out.println("============================================================");
            // 계약정보 저장
            cctr0020_Mapper.ccta0030_doUpdateECCT(formData);
            System.out.println("============================================================");
            System.out.println("STOCECCT 수정 완료");
            System.out.println("============================================================");
            
            // 고객사(ECCM), 계약보증정보(ECPC_HD), 지불정보(ECPY), 고객사별 지불고객사 정보(ECPC), 계약서 서식정보 삭제
            cctr0020_Mapper.ccta0030_doDeleteECCM(formData);
            cctr0020_Mapper.ccta0030_doDeleteECMT(formData);
            cctr0020_Mapper.ccta0030_doDeleteECPC(formData);
            cctr0020_Mapper.ccta0030_doDeleteECPY(formData);
            System.out.println("============================================================");
            System.out.println("ECCT, ECCM, ECMT, ECPC, ECPY 정보 Delete");
            System.out.println("============================================================");

            //mainContractContents = ContStringUtil.replaceUserNotEditableForms(formData.get("mainContractContents"), formData);
            //formData.put("CONTRACT_TEXT", mainContractContents);
            largeTextNum = formData.get("CONTRACT_TEXT_NUM");
            if( EverString.isEmpty(EverString.replace(largeTextNum, " ", "")) ){
                largeTextNum = docNumService.getDocNumber(userInfo.getCompanyCd(), "TN");
                formData.put("CONTRACT_TEXT_NUM", largeTextNum);
            } else {
                formData.put("CONTRACT_TEXT_NUM", largeTextNum);
            }
            System.out.println("============================================================");
            System.out.println("Text Number 채번 완료");
            System.out.println("============================================================");

            // 주서식 저장
            cctr0020_Mapper.ccta0030_doUpdateECRL(formData);
            System.out.println("============================================================");
            System.out.println("ECRL(주서식) Update 완료");
            System.out.println("============================================================");
            
            // 주계약서를 제외한 부서식은 저장 후에 선택을 뺄 수도 있으므로 기존 데이터를 삭제하고 다시 넣는다.
            cctr0020_Mapper.ccta0030_doDeleteAddECRL(formData); // 부서식 내용 삭제
            System.out.println("============================================================");
            System.out.println("ECRL(부서식) Delete 완료");
            System.out.println("============================================================");

            // 고객사(ECCM), 계약보증정보(ECPC_HD), 지불정보(ECPY), 고객사별 지불고객사 정보(ECPC)
            Map<String, Object> gridInfo = new HashMap<>();
            gridInfo.put("PROGRESS_CD", formData.get("PROGRESS_CD"));
            gridInfo.put("CONT_NUM", formData.get("CONT_NUM"));
            gridInfo.put("CONT_CNT", formData.get("CONT_CNT"));
            for (Map<String, Object> gridECCM : gridDataECCM) {
                // 기본 정보를 최초 셋팅
                gridECCM.putAll(gridInfo);

                // 고객사 정보 삭제
                cctr0020_Mapper.ccta0030_doInsertECCM(gridECCM);
                System.out.println("============================================================");
                System.out.println("ECCM Insert 완료");
                System.out.println("============================================================");

                List<Map<String,Object>> gridDataECPC_HD = EverConverter.readJsonObject(String.valueOf(gridECCM.get("PC_HD_INFO")), List.class);
                if (gridDataECPC_HD != null && gridDataECPC_HD.size() > 0) {
                    for(Map<String, Object> gridECPC_HD : gridDataECPC_HD) {
                        gridECPC_HD.putAll(gridInfo);

                        // 계약보증(STOCECPC)
                        gridECPC_HD.put("PAY_CNT", "0");
                        cctr0020_Mapper.ccta0030_doInsertECPC(gridECPC_HD);
                        System.out.println("============================================================");
                        System.out.println("ECPC HD(계약보증) Insert 완료");
                        System.out.println("============================================================");

                        // 차액보증(STOCECPC)
                        gridECPC_HD.put("PAY_CNT", "-1"); // 지급차수
                        gridECPC_HD.put("GUAR_TYPE", gridECPC_HD.get("DI_GUAR_TYPE")); // 보증구분
                        gridECPC_HD.put("GUAR_AMT", gridECPC_HD.get("DI_GUAR_AMT")); // 차액보증금
                        gridECPC_HD.put("GUAR_PERCENT", "0"); // 요율
                        gridECPC_HD.put("ATT_FILE_NUM", gridECPC_HD.get("DI_ATT_FILE_NUM")); // 첨부파일
                        gridECPC_HD.put("GUAR_NUM", null); // 증권번호
                        gridECPC_HD.put("GUAR_TYPE2", "10"); // 보증방법
                        gridECPC_HD.put("GUARANTEER", null); // 보증기관
                        cctr0020_Mapper.ccta0030_doInsertECPC(gridECPC_HD);
                        System.out.println("============================================================");
                        System.out.println("ECPC HD(차액보증) Insert 완료");
                        System.out.println("============================================================");
                    }
                }

                List<Map<String,Object>> gridDataECPY = EverConverter.readJsonObject(String.valueOf(gridECCM.get("PY_INFO")), List.class);
                if(gridDataECPY != null && gridDataECPY.size() > 0) {
                    for(Map<String, Object> gridECPY : gridDataECPY) {
                        gridECPY.putAll(gridInfo);
                        
                        // 지불정보(STOCECPY)
                        cctr0020_Mapper.ccta0030_doInsertECPY(gridECPY);
                        
                        List<Map<String,Object>> gridDataECPC = EverConverter.readJsonObject(String.valueOf(gridECPY.get("PC_INFO")), List.class);
                        if (gridDataECPC != null && gridDataECPC.size() > 0) {
                            for(Map<String, Object> gridECPC : gridDataECPC) {
                                gridECPC.putAll(gridInfo);
                                
                                // 고객사별 지불고객사 정보
                                cctr0020_Mapper.ccta0030_doInsertECPC(gridECPC);
                            }
                        }
                        System.out.println("============================================================");
                        System.out.println("ECPC Insert 완료");
                        System.out.println("============================================================");
                    }
                }
                System.out.println("============================================================");
                System.out.println("ECPY Insert 완료");
                System.out.println("============================================================");
            }

            // 품목정보(ECMT)
            for (Map<String, Object> gridECMT : gridDataECMT) {
                gridECMT.putAll(gridInfo);
                
                cctr0020_Mapper.ccta0030_doInsertECMT(gridECMT);
                System.out.println("============================================================");
                System.out.println("ECMT Insert 완료");
                System.out.println("============================================================");
            }
        }

        // 부서식 저장
        for (int i = 0; i < gridDataA.size(); i++) {
            Map<String, Object> datum = gridDataA.get(i);
            datum.put("CONT_NUM", formData.get("CONT_NUM"));
            datum.put("CONT_CNT", formData.get("CONT_CNT"));

            //String addContractText = ContStringUtil.replaceUserNotEditableForms((String)datum.get("FORM_CONTENTS"), formData);
            //formData.put("CONTRACT_TEXT", addContractText);
            largeTextNum = formData.get("CONTRACT_TEXT_NUM");
            if( EverString.isEmpty(EverString.replace(largeTextNum, " ", "")) ){
                largeTextNum = docNumService.getDocNumber(userInfo.getCompanyCd(), "TN");
                formData.put("CONTRACT_TEXT_NUM", largeTextNum);
            } else {
                formData.put("CONTRACT_TEXT_NUM", largeTextNum);
            }
            System.out.println("============================================================");
            System.out.println("Text Number(부서식) 채번 완료");
            System.out.println("============================================================");

            cctr0020_Mapper.ccta0030_doInsertAddECRL(datum);
            System.out.println("============================================================");
            System.out.println("ECRL(부서식) Insert 완료");
            System.out.println("============================================================");
        }

        return formData;
    }

    // CCTA0030(계약서작성) : 계약서 결재상신 후 처리
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public Map<String, String> ccta0030_doReqSign(Map<String, String> dataForm, List<Map<String, Object>> gridDataM, List<Map<String, Object>> gridDataA, List<Map<String, Object>> gridDataECCM, List<Map<String, Object>> gridDataECMT) throws Exception {

        UserInfo userInfo = UserInfoManager.getUserInfoImpl();
        
        // 계약서 저장 후 결재상신내용 저장하기
        Map<String, String> formData = ccta0030_doSaveContract(dataForm, gridDataM, gridDataA, gridDataECCM, gridDataECMT);

        cctr0020_Mapper.ccta0030_doUpdateECCT4NotesIF(dataForm);

        if (EverString.isEmpty(dataForm.get("APP_DOC_NUM"))) {
            dataForm.put("APP_DOC_NUM", docNumService.getDocNumber(userInfo.getCompanyCd(), "APPDOC"));
        }

        String appDocCnt = dataForm.get("APP_DOC_CNT");
        if (EverString.isEmpty(appDocCnt) || appDocCnt.equals("0")) {
            appDocCnt = "1";
        } else {
            appDocCnt = String.valueOf(Integer.parseInt(appDocCnt) + 1);
        }

        dataForm.put("APP_DOC_CNT", appDocCnt);
        dataForm.put("DOC_TYPE", "EC");
        dataForm.put("SUBJECT", dataForm.get("CONT_DESC"));
        dataForm.put("REL_TEXT_NUM", dataForm.get("CONTRACT_TEXT_NUM"));
        dataForm.put("BUYER_CD", userInfo.getCompanyCd());

        String strApprovalFormData = dataForm.get("approvalFormData");
        String strApprovalGridData = dataForm.get("approvalGridData");

        approvalService.doApprovalProcess(dataForm, strApprovalFormData, strApprovalGridData);
        cctr0020_Mapper.ccta0030_doUpdateApprovalInformation(dataForm);

        return formData;
    }
    
    // CCTA0030(계약서작성) : 계약서삭제
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public void ccta0030_doDeleteContract(Map<String, String> dataForm) throws Exception {

        if (dataForm != null) {
            Map<String, String> contractInformation = cctr0020_Mapper.ccta0030_getContractInformation(dataForm);

            // 계약서 삭제 가능상태 : 임시저장(4200), 품의중(4206)(결재반려:R,상신취소:C)
            if( !(contractInformation.get("PROGRESS_CD").equals(Code.M135_4200)
              || (contractInformation.get("PROGRESS_CD").equals(Code.M135_4203) && contractInformation.get("SIGN_STATUS").equals(Code.M020_R))
              || (contractInformation.get("PROGRESS_CD").equals(Code.M135_4206) && contractInformation.get("SIGN_STATUS2").equals(Code.M020_R))
              || (contractInformation.get("PROGRESS_CD").equals(Code.M135_4206) && contractInformation.get("SIGN_STATUS2").equals(Code.M020_C))) ){
                throw new Exception("계약서를 삭제할 수 없는 상태입니다.\n진행상태를 다시 확인해주세요.");
            }
            
            // 2021.05.28 계약서 작성유형(PR, CN) 추가
            String createType = EverString.nullToEmptyString(contractInformation.get("CREATE_TYPE"));
            
            // 계약대기현황의 데이터를 다시 살려준다.
            // PR : 구매의뢰(PR) 기준 계약서 작성
            // CN : 선정품의(CN) 기준 계약서 작성
            // CT : 기존 계약서(CT) 기준 변경 및 연장계약서 작성
            List<Map<String, Object>> gridECMT = cctr0020_Mapper.ccta0030_doSearchECMT(dataForm);
            for( Map<String, Object> grid : gridECMT ) {
            	// 계약서 삭제시 구매의뢰(PRDT)기준 계약서 작성인 경우 진행상태=2200(접수완료)로 변경
            	if ("PR".equals(createType)) {
            		if( grid.get("PR_NUM") != null && grid.get("PR_SQ") != null ) {
                		grid.put("PROGRESS_CD", "2200");
                		cctr0020_Mapper.setPrProgressCdReCont(grid);
            		}
            	}// 품의서 기준 계약서 작성인 경우 => 계약대기현황으로 BACK
            	else if ("CN".equals(createType)) {
            		/**
            		 * 2021.11.29 신규 계약서 작성시 삭제하면 계약대기현황으로 가는게 맞으나 변경계약서로 작성된 2차 계약서는 삭제시 사라져야함(박기현 책임 요청건)
            		String curContCnt = EverString.nullToEmptyString(String.valueOf(grid.get("CONT_CNT")));
            		String preContNum = EverString.nullToEmptyString(String.valueOf(grid.get("PRE_CONT_NUM")));
            		String contReqCd  = EverString.nullToEmptyString(String.valueOf(grid.get("CONT_REQ_CD")));
            		if( "1".equals(curContCnt) || (!"1".equals(curContCnt) && !"".equals(preContNum) && !"null".equals(preContNum) && "20".equals(contReqCd)) ) {
	                    grid.put("DEL_FLAG", "0");
	                    cctr0020_Mapper.ccta0030_doDeleteECHB(grid);
            		}*/
            		if( grid.get("EXEC_NUM") != null && grid.get("EXEC_SQ") != null ) {
                		grid.put("DEL_FLAG", "0");
                        cctr0020_Mapper.ccta0030_doDeleteECHB(grid);
            		}
            	}
            }
            
            cctr0020_Mapper.ccta0030_doDeleteECRL(dataForm);
            cctr0020_Mapper.ccta0030_doDeleteECCT(dataForm);
            cctr0020_Mapper.ccta0030_doDeleteECCM(dataForm);
            cctr0020_Mapper.ccta0030_doDeleteECMT(dataForm);
            cctr0020_Mapper.ccta0030_doDeleteECPY(dataForm);
            cctr0020_Mapper.ccta0030_doDeleteECPC(dataForm);
        }
    }
    
    /**
     * 2021.03.08 기능 추가 : 작성중인 계약서 협력사 계약서 공유
     * @param dataForm
     * @throws Exception
     */
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public Map<String, String> ccta0030_doVendorSend(Map<String, String> param) throws Exception {
    	
    	cctr0020_Mapper.ccta0030_doVendorSend(param);
    	return param;
    }
    
    /**
     * 2021.02.09 기능 추가 : 협력사 서명완료 계약서 협력사 재서명 요청
     * @param dataForm
     * @throws Exception
     */
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public void ccta0030_doReContract(Map<String, String> param) throws Exception {
    	
    	cctr0020_Mapper.ccta0030_doReContract(param);
    }
    
    /**
     * 단일계약 : 고객사 계약서 전자서명 (서버인증서)
     * @param req
     * @param resp
     * @param gridECCM
     * @throws Exception
     */
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public Map<String, String> ccta0030_signContract(EverHttpRequest req, EverHttpResponse resp, List<Map<String, Object>> gridECCM) throws Exception {

        UserInfo userInfo = UserInfoManager.getUserInfo();
        
        // 로컬 및 개발서버 여부
        String localServerFlag = EverString.nullToEmptyString(req.getParameter("localServerFlag"));
        
        String sSignData = EverString.nullToEmptyString(req.getParameter("signedData"));
        	   sSignData = URLDecoder.decode(sSignData, "utf-8");
        String vidRandom = EverString.nullToEmptyString(req.getParameter("vidRandom"));
        	   vidRandom = URLDecoder.decode(vidRandom, "utf-8");
        String idn       = EverString.nullToEmptyString(req.getParameter("idn"));
        String useCard   = EverString.nullToEmptyString(req.getParameter("useCard"));
        
        // 운영서버에서만 서명값 검증을 진행함
        if( "N".equals(localServerFlag) ) {
            Map<String, String> rtnMap = EverCert.doCheckCert(sSignData, vidRandom, idn, useCard);
            if (rtnMap != null && rtnMap.get("certRtnCd").equals("-1")) { // 서명값 검증 실패
                throw new Exception(rtnMap.get("certRtnMsg"));
            }
        }

        Map<String, String> formData = req.getFormData();

        // 1. 서명된 값을 서명테이블(STOCECSV)에 저장 및 협력업체 검증
        Map<String, Object> formObj = (Map) formData;
        // --> 협력업체 서명 값 가져오기
        Map<String, String> signChk = cctr0020_Mapper.ccta0030_doSignChk(formObj);
        String sSignDataChk = String.valueOf(signChk.get("SIGN_VALUE"));
        String vidRandomChk = String.valueOf(signChk.get("VID_RANDOM"));
        String idnChk = String.valueOf(signChk.get("IRS_NO"));

		/**
		 * useCard : "1" (Test용 법인용 공인인증서, 사업자 등록번호 : 2128159710)
		 *			 "2" (Test용 법인용 블럭체인 사설인증서, 사업자 등록번호 : 1122334455)CITR0043
		 *			 "3" {Test용 개인용 블럭체인 사설인증서, 사업자 등록번호 : ""}
		 */
        String useCardChk = "";
        if( !"N".equals(localServerFlag) ) {
            useCardChk = "1";
        }
        
        // --> 계약서의 협력업체 서명값 검증
        boolean checkFlag = EverCert.doCheckSignedData(sSignDataChk, vidRandomChk, idnChk, useCardChk);
        if (!checkFlag) {
            throw new Exception("협력업체의 서명값 검증에 실패하였습니다.");
        }
        
        // --> 2020.12.30 변경
        // --> 지불 고객사 수수료 청구
        // 수수료 청구시 formData("CONT_BID_GBN") = BID 인 경우 EPRO_WRS_DS = 30, ELSE EPRO_WRS_DS = 40
        String contBidGbn = "40"; 	// 40 : 일반수의계약
        if( StringUtils.isNotEmpty(formData.get("CONT_BID_GBN")) && "BID".equals(formData.get("CONT_BID_GBN")) ) {
        	contBidGbn = "30"; 		// 30 : 일반입찰계약
        }
        System.out.println("==================================> 단일업체 계약서 작성 입찰(30)/수의(40) 계약구분 : " + contBidGbn);
        
        // --> 협력업체 계약서 서명값 검증 성공시 ==> 고객사 전자서명 진행
        for (Map<String, Object> grid : gridECCM) {
        	
            List<Map<String, Object>> gridDataECPC_HD = EverConverter.readJsonObject(String.valueOf(grid.get("PC_HD_INFO")), List.class);
            // --> 지불 고객사 서명 값 저장
            for (Map<String, Object> gridECPC_HD : gridDataECPC_HD) {
                gridECPC_HD.put("SIGN_VALUE", sSignData);
                gridECPC_HD.put("FORM_NUM", formData.get("FORM_NUM"));
                gridECPC_HD.put("VID_RANDOM", vidRandom);
                gridECPC_HD.put("USER_TYPE", "B");

                if( (gridECPC_HD.get("SIGN_FLAG").equals("1") && userInfo.getCompanyCd().equals(gridECPC_HD.get("PY_BUYER_CD")) && userInfo.getDeptCd().equals(gridECPC_HD.get("PY_DEPT_CD")))
                  ||(gridECPC_HD.get("SIGN_FLAG").equals("0") && userInfo.getCompanyCd().equals(formData.get("BUYER_CD")) && userInfo.getDeptCd().equals(formData.get("DEPT_CD"))))
                {
                    Map<String, String> gridMap = (Map) gridECPC_HD;
                    // 동일한 데이터 존재 시 스킵
                    int ecsvCnt = cctr0020_Mapper.cctr0030_doSearchECSV(gridMap);
                    if (ecsvCnt == 0) {
                        cctr0020_Mapper.ccta0030_doInsertECSV(gridMap);
                    }
                    cctr0020_Mapper.cctr0030_doUpdateECPC_HD(gridMap);
                }
            }
        }
        
        // 전체 지불고객사의 최종 전자서명 여부 확인.
        int cnt = cctr0020_Mapper.cctr0030_doSingCnt(formData);
        // cnt 가 0 이면 서명자 전체 적용
        if( cnt == 0 ) {
        	// --> 2020.12.30 기존 지불고객사에서 계약고객사로 변경
            // --> 2020.11.25 추가
            // -- 계약체결 완료 후 고객사에 수수료 부과
            Map<String, String> paymentMap = cctr0020_Mapper.getPrepaymentCust(formData);
            paymentMap.put("EPRO_PS_DSC", "1");			// epro_ps_dsc [구매공급구분코드] - 1 : 구매, 2 : 공급
            paymentMap.put("EPRO_WRS_DS", contBidGbn);	// epro_wrs_ds [상품코드] - 10 : RFI, 20 : 입찰, 30 : 일반입찰계약, 40 : 일반수의계약, 50 : BtoC계약, 60 : 위임계약, 70 : 문서보관, 80 : SMS, 90 : LMS, 100 : 문서생성
            paymentMap.put("CONT_TBL_ID", "STOCECCT");	// 업무 Table명(계약마스터)
            //CONT_TBL_PK : 해당 Table에 Data 존재유무를 조회해볼 수 있는 Key 값. GATE_CD || '@@' || BUYER_CD || '@@' || ... 와 같이 설정.
            paymentMap.put("tmp", String.valueOf(paymentMap.get("CONT_AMT")));	//tmp : myBatis 버그 해결을 위한 무의미한, 유니크한 값. 단, EPRO_WRS_DS = '30' 또는 '40'일 때 반드시 계약(지불)금액을 넣어야 함.
            
            String resultMsg = approvalService.putBkCost(paymentMap);
            if( !resultMsg.equals("OK") ) {
            	throw new Exception(resultMsg);
            } else {
            	System.out.println("==========> 일반 계약 완료 후 고객사에 수수료 청구 : PK => " + paymentMap.get("CONT_TBL_PK") + ", AMT => " + paymentMap.get("tmp"));
            }
            
            // 2. 계약마스터(STOCECCT)의 진행상태를 계약체결완료 변경
            formData.put("PROGRESS_CD", Code.M135_4300);
            cctr0020_Mapper.ccta0030_doUpdateStatusOfECCT(formData);
            
            // 3. 2021.01.25 계약완료 후 구매진행상태=4300(계약완료)
            cctr0020_Mapper.setPrProgressCdCont(formData);
            
            // 4. 수정/재계약인 경우 전차수의 계약종료일자는 현재차수의 계약시작일자 - 1일로 변경함
            // 2024.05.29 이전 계약의 종료일자 업데이트는 계약 원장의 종료일자와 상이 하기 때문에 양사 합의되지 않은 사항에서 시스템 데이터의 종료일자를 업데이트 하는것은 안되므로 해당 로직은 제외
            //if( Integer.parseInt(String.valueOf(formData.get("CONT_CNT"))) > 1 ){
            //    int contCntMinus = Integer.parseInt(formData.get("CONT_CNT")) - 1;
            //    formData.put("CONT_CNT_MINUS", String.valueOf(contCntMinus));
            //    cctr0020_Mapper.ccta0030_updateBfContEndDate(formData);
            //}
            
            // 5. 발주 대기 상태의 POHD, PODT 의 값을 PROGRESS_CD = 5200(발주완료)로 상태값 변경
            List<Map<String, Object>> poList = cctr0020_Mapper.ccta0030_doSearchPOList(formData);
            for(Map<String, Object> po : poList) {
                cctr0020_Mapper.ccta0030_doUpdatePOHD(po);
                cctr0020_Mapper.ccta0030_doUpdatePODT(po);
                
                // 2021.01.25 발주서 생성 후 구매진행상태=5200
                cctr0020_Mapper.setPrProgressCdPo(po);
            }

            // 5-1. 계약완료 메일 발송
            if( poList.size() > 0 ) {
            	try {
                	sendMailAfterSign(formData);
            	} catch (Exception ex) {
            		getLog().error("==> 단일업체 : 고객사 전자서명 완료 메일&문자 발송 오류 : " + ex.getMessage(), ex);
            	}
            }
        }
        
        return formData;
    }
    
    /**
     * 전자서명 완료 후 발주서에 대한 메일, SMS 보내기
     * @param formData
     * @throws Exception
     */
    @Transactional(propagation = Propagation.REQUIRES_NEW, rollbackFor = Exception.class)
 	public void sendMailAfterSign(Map<String, String> formData) throws Exception {
 		
    	// 전자구매시스템 URL
        String linkUrl = PropertiesManager.getString("eversrm.urls.maintain.real");
        
        List<Map<String, String>> vendorInfo = cctr0020_Mapper.ccta0030_sendVendorInfo(formData);
        String prBuyerDeptNms = "";
        String ctrlUserNm = "";
        Map<String, String> infoMap = new HashMap<>();
        int i = 1;
        for (Map<String, String> info : vendorInfo) {
            ctrlUserNm = info.get("CTRL_USER_NM");
            if (vendorInfo.size() == i) {
                infoMap.putAll(info);
                prBuyerDeptNms += info.get("PR_BUYER_DEPT_NM");
            } else {
                prBuyerDeptNms += info.get("PR_BUYER_DEPT_NM") + ",";
            }
        }
        
        // 협력업체 담당자 조회
        List<Map<String, String>> vendorUserInfo = cctr0020_Mapper.ccta0030_sendVendorUserInfo(formData);
        for(Map<String, String> vendorUser : vendorUserInfo) {
            try {
                String subject  = "[전자구매시스템] 고객사 [" + prBuyerDeptNms + " - " + ctrlUserNm + "]에서 [" + infoMap.get("SUBJECT") + "] 관련 계약발주를 전송하였습니다";
                
                StringBuffer sb = new StringBuffer();
                sb.setLength(0);
                sb.append("<BR> 안녕하세요.																							");
                sb.append("<BR> [" + vendorUser.get("VENDOR_NM") + "] " + vendorUser.get("RECV_USER_NM") + " 님.						");
                sb.append("<BR> 																									");
                sb.append("<BR> 아래와 같이 고객사에서 발주서를 발송 하였습니다																	");
                sb.append("<BR> 고객사 : [" + prBuyerDeptNms + "]																		");
                sb.append("<BR> 발주명 : [" + infoMap.get("PO_NUM") + "] " + infoMap.get("SUBJECT") + "								");
                sb.append("<BR> 발주일 : [" + infoMap.get("PO_CREATE_DATE") + "]														");
                sb.append("<BR> 계약기간 : [" + infoMap.get("CONT_START_END_DATE") + "]												");
                
                if (StringUtils.isNotEmpty(infoMap.get("DUE_DATE"))) {
                    sb.append("<BR> 납품기한 : [" + infoMap.get("DUE_DATE") + "]														");
                }
                
                sb.append("<BR> 																									");
                sb.append("<BR> 전자구매시스템에 <a href=\"" + linkUrl + "\" target=\"newP\">로그인</a> 하시어, 세부내용을 확인 후 처리 해주십시오.	");
                sb.append("<BR> 																									");
                sb.append("<BR> 감사합니다.																							");

                formData.put("SUBJECT", subject);
                formData.put("CONTENTS", sb.toString());
                formData.put("REF_MODULE_CD", "MPO03");
                formData.put("RECV_USER_ID", vendorUser.get("RECV_USER_ID"));
                
                // 2020.12.15 기능 추가
                // 계약마스터(STOCECCT)의 협력사 계약담당자인 경우 직접 메일 보내기
                if( StringUtils.isEmpty(vendorUser.get("RECV_USER_ID")) ) {
                    formData.put("DIRECT_TARGET", vendorUser.get("RECV_EMAIL"));
                    formData.put("DIRECT_USER_NM", vendorUser.get("USER_NM"));
                }
                everMailService.SendMail(formData);
                
                // SMS
                Map<String,String> smsMap = new HashMap<String,String>();
                smsMap.put("CONTENTS", subject);
                smsMap.put("REF_MODULE_CD", "SPO03");
                
                if( StringUtils.isEmpty(vendorUser.get("RECV_USER_ID")) ) {
                    formData.put("DIRECT_TARGET", vendorUser.get("RECV_TEL_NUM"));
                    formData.put("DIRECT_USER_NM", vendorUser.get("RECV_USER_NM"));
                }
                smsMap.put("RECV_USER_ID", vendorUser.get("RECV_USER_ID"));
                
                // 2021.06.30 : 계약서 체결 완료 및 발주서 전송 후 SMS 수수료 부과
                smsMap.put("CORP_NO", vendorUser.get("CORP_NO"));     		// 고객사 사업자번호
                smsMap.put("BRC", vendorUser.get("BRC"));            		// 고객사 부서
                smsMap.put("EPRO_PS_DSC", "1");     						// 1  : 구매
                smsMap.put("EPRO_RATE_DSC", "01");  						// 01 : 최초
                smsMap.put("APLY_DT", vendorUser.get("APLY_DT"));     		// 발생일 YYYYMMDD
                smsMap.put("USER_ID", vendorUser.get("USER_ID"));     		// 고객사 보내는사람 ID
                smsMap.put("CONT_TBL_ID", "STOCPODT");              		// 검증 테이블
                smsMap.put("CONT_TBL_PK", vendorUser.get("CONT_TBL_PK")); 	// 검증 조건
                smsMap.put("tmp", vendorUser.get("CONT_TBL_PK"));         	// 유니크한 값.
                smsMap.put("payFlag", "Y");
                
                everSmsService.sendSmsNhe(smsMap);
            }
            catch (Exception ex) {
                getLog().error("단일업체 계약 고객사 전자서명 완료(4300) 메일 및 SMS 발송 오류 : " + ex.getMessage(), ex);
            }
        }
 	}
    
    /**
     * 다수계약 : 발주사 계약서 전자서명 (4230 => 4300)
     * @param req
     * @param resp
     * @param gridV
     * @throws Exception
     */
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public Map<String, String> ccta0040_signContract(EverHttpRequest req, EverHttpResponse resp, List<Map<String, Object>> gridV) throws Exception {

        String localServerFlag = EverString.nullToEmptyString(req.getParameter("localServerFlag"));
        
        String sSignData = EverString.nullToEmptyString(req.getParameter("signedData"));
        	   sSignData = URLDecoder.decode(sSignData, "utf-8");
        String vidRandom = EverString.nullToEmptyString(req.getParameter("vidRandom"));
        	   vidRandom = URLDecoder.decode(vidRandom, "utf-8");
        String idn       = EverString.nullToEmptyString(req.getParameter("idn"));
        String useCard   = EverString.nullToEmptyString(req.getParameter("useCard"));
        
        // 운영서버에서만 서명값 검증을 진행함
        if( "N".equals(localServerFlag) ) {
            Map<String, String> rtnMap = EverCert.doCheckCert(sSignData, vidRandom, idn, useCard);
            // 서명값 검증 실패
            if (rtnMap != null && rtnMap.get("certRtnCd").equals("-1")) {
                throw new Exception(rtnMap.get("certRtnMsg"));
            }
        }
        
        Map<String, String> formData = req.getFormData();
        System.out.println("CONT_TYPE ==========> "+ formData.get("CONT_TYPE"));
        // 위수탁계약 : 협력사가 지역농축협(STOCCUST)
        for( Map<String, Object> grid : gridV ) {
            // 1. 협력업체 서명 값 검증
            Map<String, String> signChk = null;
            if( "1120".equals(formData.get("CONT_TYPE")) ) {
                signChk = cctr0020_Mapper.ccta0040_doSignChk(grid); // 위수탁계약서 : 고객사 서명값 가져오기
            } else {
                signChk = cctr0020_Mapper.ccta0030_doSignChk(grid); // 일반계약서    : 협력사 서명값 가져오기
            }

            String sSignDataChk = String.valueOf(signChk.get("SIGN_VALUE"));
            String vidRandomChk = String.valueOf(signChk.get("VID_RANDOM"));
            String idnChk = String.valueOf(signChk.get("IRS_NO"));

			/* useCard : "1" (Test용 법인용 공인인증서, 사업자 등록번호 : 2128159710)
						 "2" (Test용 법인용 블럭체인 사설인증서, 사업자 등록번호 : 1122334455)
						 "3" {Test용 개인용 블럭체인 사설인증서, 사업자 등록번호 : ""} */
            String useCardChk = "";
            if( "N".equals(localServerFlag) ) {
                useCardChk = useCard;
            }
            
            boolean checkFlag = EverCert.doCheckSignedData(sSignDataChk, vidRandomChk, idnChk, useCardChk);
            if (!checkFlag) {
                if( formData.get("CONT_TYPE").equals("1120") ) {
                    throw new Exception("고객사의 서명값 검증에 실패하였습니다."); // 위수탁계약 : 고객사 서명 검증
                } else {
                    throw new Exception("협력사의 서명값 검증에 실패하였습니다."); // 일반 계약 : 협력사 서명 검증
                }
            }

            // 2. 고객사 서명 값 저장(STOCECSV)
            grid.put("SIGN_VALUE", sSignData);
            grid.put("FORM_NUM", formData.get("FORM_NUM"));
            grid.put("VID_RANDOM", vidRandom);
            grid.put("USER_TYPE", "B");

            Map<String, String> gridMap = (Map) grid;
            gridMap.put("PR_BUYER_CD", formData.get("PR_BUYER_CD"));
            gridMap.put("PR_DEPT_CD", formData.get("PR_DEPT_CD"));
            cctr0020_Mapper.ccta0030_doInsertECSV(gridMap);
            
            // TSA 서명 값 검증 (위수탁계약인 경우에만 위변조 검증)
            if( "1120".equals(formData.get("CONT_TYPE")) && "N".equals(localServerFlag) ) {
            	String pdfAttFileNum = String.valueOf(grid.get("PDF_ATT_FILE_NUM"));
            	if( StringUtils.isEmpty(pdfAttFileNum) ) {
            		throw new Exception("위변조를 확인할 계약서 파일이 없습니다.(pdfAttFileNum)"); // 위변조 확인할 계약서 파일 존재여부
            	}
            	
	            Map<String, String> fileInfo = fileAttachService.getFileInfo(pdfAttFileNum, null);
	            if( fileInfo != null && fileInfo.size() > 0 ) {
		            // TSA 인증 값 입히기
		            String targetDirectory = fileInfo.get("FILE_PATH");
		            String targetFileNm = fileInfo.get("UUID") + "_" + fileInfo.get("UUID_SQ") + "." + fileInfo.get("FILE_EXTENSION");
		
		            // 파일 이동 후 위변조 방지를 위해 Binary 적용
		            String binaryFile = EverFile.fileToBinary(targetDirectory, targetFileNm);
		            
		            Map<String, String> binaryMap = new HashMap<>();
		            binaryMap.put("url", PropertiesManager.getString("block.chain.verify"));
		            binaryMap.put("strFromFile", binaryFile);
		            
		            JSONObject jsonObject = EverRestJson.actionAPI(binaryMap);
		            if( !"success".equals(jsonObject.get("msg")) ) {
		                throw new Exception("계약서 파일이 변조되었습니다. 전자서명을 진행하실 수 없습니다.");
		            }
	            } else {
	            	throw new Exception("위변조를 확인할 계약서 파일정보가 없습니다.(getFileInfo)"); // 위변조 확인할 계약서 파일 존재여부
	            }
            }

            // 3. 계약체결완료(STOCECCT)로 상태 변경
            formData.put("PROGRESS_CD", Code.M135_4300);
            formData.put("CONT_NUM", String.valueOf(grid.get("CONT_NUM")));
            formData.put("CONT_CNT", String.valueOf(grid.get("CONT_CNT")));
            cctr0020_Mapper.ccta0030_doUpdateStatusOfECCT(formData);

            // 발주 대기 상태의 POHD, PODT 의 값을 PROGRESS_CD = 5200(발주완료)로 상태 값 변경.
            List<Map<String, Object>> poList = cctr0020_Mapper.ccta0030_doSearchPOList(formData);
            for(Map<String, Object> po : poList) {
                cctr0020_Mapper.ccta0030_doUpdatePOHD(po);
                cctr0020_Mapper.ccta0030_doUpdatePODT(po);
            }
            
            // 2021.04.19 변경
            // 위수탁 계약의 수수료는 수탁 및 위탁사(지역농축협)에 동시에 부과함
            if( "1120".equals(formData.get("CONT_TYPE")) ) {
	            // 2020.12.30 고객이 의뢰고객에서 계약서 작성 고객으로 변경
	            // 2020.11.25 수탁사에게 수수료부과 추가
	            // -- 계약체결 완료 후 고객 및 협력사에 수수료 부과
	        	List<Map<String, String>> paymentList = cctr0020_Mapper.getPrepaymentConsignCust(grid); 	// 위수탁계약 : 고객사 및 에 수수료 부과
	        	
	        	for( Map<String, String> paymentMap : paymentList ) {
		            paymentMap.put("EPRO_PS_DSC", "1");			// epro_ps_dsc [구매공급구분코드] - 1 : 구매, 2 : 공급
		            paymentMap.put("EPRO_WRS_DS", "60");		// epro_wrs_ds [상품코드] - 10 : RFI, 20 : 입찰, 30 : 일반입찰계약, 40 : 일반수의계약, 50 : BtoC계약, 60 : 위임계약, 70 : 문서보관, 80 : SMS, 90 : LMS, 100 : 문서생성
		            paymentMap.put("CONT_TBL_ID", "STOCECCT");	// 업무 Table명
		            // CONT_TBL_PK : 해당 Table에 Data 존재유무를 조회해볼 수 있는 Key 값. GATE_CD || '@@' || BUYER_CD || '@@' || ... 와 같이 설정.
		            paymentMap.put("tmp", ""); 					// myBatis 버그 해결을 위한 무의미한, 유니크한 값. 단, EPRO_WRS_DS = '30' 또는 '40'일 때 반드시 계약금액을 넣어야 함.

		            String resultMsg = approvalService.putBkCost(paymentMap);
		            if(!resultMsg.equals("OK")) {
		            	throw new Exception(resultMsg);
		            } else {
		            	System.out.println("==========> (다수계약) 위수탁 계약 완료 후 위수탁사에 수수료 청구 : PK => " + paymentMap.get("CONT_TBL_PK") + ", CORP_NO => " + paymentMap.get("CORP_NO"));
		            }
	        	}
            }
            
            // 5. 발주가 생성된 경우 : 계약완료 메일 발송
            if( poList.size() > 0 ) {
            	try {
                	sendMailAfterMultiSign(formData, grid);
            	} catch (Exception ex) {
            		getLog().error("==> 다수업체 고객사 전자서명 완료(4300) 메일&문자 발송 오류 : " + ex.getMessage(), ex);
            	}
            }
        }
        
        return formData;
    }
    
    /**
     * 다수업체 계약서 전자서명 완료 후 협력사에게 메일 발송
     * @param formData
     * @param grid
     * @throws Exception
     */
    @Transactional(propagation = Propagation.REQUIRES_NEW, rollbackFor = Exception.class)
  	public void sendMailAfterMultiSign(Map<String, String> formData, Map<String, Object> grid) throws Exception {
  		
    	// 전자구매시스템 URL
        String linkUrl = PropertiesManager.getString("eversrm.urls.maintain.real");
        
        List<Map<String, String>> vendorInfo = cctr0020_Mapper.ccta0030_sendVendorInfo(formData);
        String prBuyerDeptNms = "";
        String ctrlUserNm = "";
        Map<String, String> infoMap = new HashMap<>();
        int i = 1;
        for (Map<String, String> info : vendorInfo) {
            ctrlUserNm = info.get("CTRL_USER_NM");
            if (vendorInfo.size() == i) {
                infoMap.putAll(info);
                prBuyerDeptNms += info.get("PR_BUYER_DEPT_NM");
            } else {
                prBuyerDeptNms += info.get("PR_BUYER_DEPT_NM") + ",";
            }
        }

        List<Map<String, String>> vendorUserInfo = null;
        // 협력업체 담당자 조회
        if (String.valueOf(grid.get("VENDOR_CD")).substring(0, 1).equals("S")) {
            vendorUserInfo = cctr0020_Mapper.ccta0030_sendVendorUserInfo(formData);
        } // 지역농축협 담당자 조회
        else {
            vendorUserInfo = cctr0020_Mapper.ccta0030_sendCustUserInfo(formData);
        }

        for(Map<String, String> vendorUser : vendorUserInfo) {
            try {
                String subject  = "[전자구매시스템] 고객사 [" + prBuyerDeptNms + " - " + ctrlUserNm + "]에서 ["+ infoMap.get("SUBJECT") +"] 관련 계약발주를 전송하였습니다.";
                
                StringBuffer sb = new StringBuffer();
                sb.setLength(0);
                sb.append("<BR> 안녕하세요.																								");
                sb.append("<BR> ["+ vendorUser.get("VENDOR_NM") +"] "+ vendorUser.get("USER_NM") +" 님.									");
                sb.append("<BR> 																										");
                sb.append("<BR> 아래와 같이 고객사에서 발주서를 발송 하였습니다																		");
                sb.append("<BR> 고객사 : [" + prBuyerDeptNms + "]																			");
                sb.append("<BR> 발주명 : [" + infoMap.get("PO_NUM") + "] " + infoMap.get("SUBJECT") + "									");
                sb.append("<BR> 발주일 : [" + infoMap.get("PO_CREATE_DATE") + "]															");
                sb.append("<BR> 계약기간 : [" + infoMap.get("CONT_START_END_DATE") +"] 													");
                
                if (StringUtils.isNotEmpty(infoMap.get("DUE_DATE"))) {
                    sb.append("<BR> 납품기한 : [" + infoMap.get("DUE_DATE") + "]															");
                }
                
                sb.append("<BR> 																										");
                sb.append("<BR> 전자구매시스템에 <a href=\"" + linkUrl + "\" target=\"newP\">로그인</a> 하시어, 세부내용을 확인 후 처리 해주십시오.		");
                sb.append("<BR> 																										");
                sb.append("<BR> 감사합니다.																								");

                formData.put("SUBJECT", subject);
                formData.put("CONTENTS", sb.toString());
                formData.put("REF_MODULE_CD", "MPO03");
                formData.put("RECV_USER_ID", vendorUser.get("RECV_USER_ID"));
                
                // 2020.12.15 기능 추가
                // 계약마스터(STOCECCT)의 협력사 계약담당자인 경우 직접 메일 보내기
                if( StringUtils.isEmpty(vendorUser.get("RECV_USER_ID")) ) {
                    formData.put("DIRECT_TARGET", vendorUser.get("RECV_EMAIL"));
                    formData.put("DIRECT_USER_NM", vendorUser.get("RECV_USER_NM"));
                }
                everMailService.SendMail(formData);
                
                // SMS
                Map<String,String> smsMap = new HashMap<String,String>();
                smsMap.put("CONTENTS", subject);
                smsMap.put("REF_MODULE_CD", "SPO03");
                smsMap.put("RECV_USER_ID", vendorUser.get("RECV_USER_ID"));
                
                // 2021.07.02 : 계약서 체결 완료 및 발주서 전송 후 SMS 수수료 부과
                smsMap.put("CORP_NO", vendorUser.get("CORP_NO"));     		// 고객사 사업자번호
                smsMap.put("BRC", vendorUser.get("BRC"));            		// 고객사 부서
                smsMap.put("EPRO_PS_DSC", "1");     						// 1  : 구매
                smsMap.put("EPRO_RATE_DSC", "01");  						// 01 : 최초
                smsMap.put("APLY_DT", vendorUser.get("APLY_DT"));     		// 발생일 YYYYMMDD
                smsMap.put("USER_ID", vendorUser.get("USER_ID"));     		// 고객사 보내는사람 ID
                smsMap.put("CONT_TBL_ID", "STOCPODT");              		// 검증 테이블
                smsMap.put("CONT_TBL_PK", vendorUser.get("CONT_TBL_PK")); 	// 검증 조건
                smsMap.put("tmp", vendorUser.get("CONT_TBL_PK"));         	// 유니크한 값.
                smsMap.put("payFlag", "Y");
                
                everSmsService.sendSmsNhe(smsMap);
            }
            catch (Exception ex) {
                getLog().error("다수업체 고객사 전자서명 완료(4300) 메일&문자 발송 오류 : " + ex.getMessage(), ex);
            }
        }
  	}
  	
    /**
     * 협력사 계약서 전자서명(4210 => 4230)
     * 다수업체 계약의 협력사에서 전자서명(4230)을 진행한 경우
     * @param req
     * @param resp
     * @param gridV
     * @throws Exception
     */
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public Map<String, String> ccta0040_signContractBuyer(EverHttpRequest req, EverHttpResponse resp, List<Map<String, Object>> gridV) throws Exception {
    	
        String localServerFlag = EverString.nullToEmptyString(req.getParameter("localServerFlag"));
        
        String sSignData = EverString.nullToEmptyString(req.getParameter("signedData"));
        sSignData = URLDecoder.decode(sSignData, "utf-8");
        String vidRandom = EverString.nullToEmptyString(req.getParameter("vidRandom"));
        vidRandom = URLDecoder.decode(vidRandom, "utf-8");
        String idn = EverString.nullToEmptyString(req.getParameter("idn"));
        String useCard = EverString.nullToEmptyString(req.getParameter("useCard"));
        
        // 운영에서만 서명값 검증
        if( "N".equals(localServerFlag) ) {
            Map<String, String> rtnMap = EverCert.doCheckCert(sSignData, vidRandom, idn, useCard);
            // 서명값 검증 실패
            if (rtnMap != null && rtnMap.get("certRtnCd").equals("-1")) {
                throw new Exception(rtnMap.get("certRtnMsg"));
            }
        }

        Map<String, String> formData = req.getFormData();
        for (Map<String, Object> grid : gridV) {
            // 1. 협력사 서명 값 저장
            grid.put("SIGN_VALUE", sSignData);
            grid.put("FORM_NUM", formData.get("FORM_NUM"));
            grid.put("VID_RANDOM", vidRandom);
            grid.put("USER_TYPE", "B");
            grid.put("BUYER_CD", formData.get("BUYER_CD"));

            Map<String, String> gridMap = (Map) grid;
            cctr0020_Mapper.ccta0040_doInsertECSV(grid);

            // 2. 협력사서명완료(4230)로 상태 변경
            formData.put("PROGRESS_CD", Code.M137_4230);
            cctr0020_Mapper.ccta0030_doUpdateStatusOfECCT(formData);
            
            /**
             * 2021.01.12 변경
             * 협력사 수수료는 협력사에서 전자서명시 부과하도록 함
            // 위수탁 계약이 아닌 경우 협력사에도 수수료 부과
            if( !"1120".equals(formData.get("CONT_TYPE")) ) {
            	Map<String, String> paymentSub = cctr0020_Mapper.getPrepaymentConsignVendor(grid);	// 일반계약 : 협력사에 수수료 부과

            	paymentSub.put("EPRO_PS_DSC", "2");			// epro_ps_dsc [구매공급구분코드] - 1 : 구매, 2 : 공급
            	paymentSub.put("EPRO_WRS_DS", "60");		// epro_wrs_ds [상품코드] - 10 : RFI, 20 : 입찰, 30 : 일반입찰계약, 40 : 일반수의계약, 50 : BtoC계약, 60 : 위임계약, 70 : 문서보관, 80 : SMS, 90 : LMS, 100 : 문서생성
            	paymentSub.put("CONT_TBL_ID", "STOCECCM");	// 업무 Table명
                // CONT_TBL_PK : 해당 Table에 Data 존재유무를 조회해볼 수 있는 Key 값. GATE_CD || '@@' || BUYER_CD || '@@' || ... 와 같이 설정.
            	paymentSub.put("tmp", ""); 					// myBatis 버그 해결을 위한 무의미한, 유니크한 값. 단, EPRO_WRS_DS = '30' 또는 '40'일 때 반드시 계약금액을 넣어야 함.

                String resultSubMsg = approvalService.putBkCost(paymentSub);
                if( !resultSubMsg.equals("OK") ) {
                	throw new Exception(resultSubMsg);
                } else {
                	System.out.println("==========> (다수계약) 위수탁 제외 계약 완료 후 협력사에 수수료 청구 : PK => " + paymentMap.get("CONT_TBL_PK") + ", CORP_NO => " + paymentMap.get("CORP_NO"));
                }
            }*/
            
            // 3. 고객사 계약담당자에게 메일 발송
            try {
            	sendMailAfterMultiSignBuyer(formData, grid);
        	} catch (Exception ex) {
        		getLog().error("==> 다수업체 협력사 전자서명 완료(4230) 메일&문자 발송 오류 : " + ex.getMessage(), ex);
        	}
        }
        
        return formData;
    }
    
    /**
     * 다수업체 계약서에서 협력사 전자서명 완료 후 계약담당자에게 메일 발송
     * @param formData
     * @param grid
     * @throws Exception
     */
    @Transactional(propagation = Propagation.REQUIRES_NEW, rollbackFor = Exception.class)
  	public void sendMailAfterMultiSignBuyer(Map<String, String> formData, Map<String, Object> grid) throws Exception {
  		
    	// 전자구매시스템 URL
        String linkUrl = PropertiesManager.getString("eversrm.urls.maintain.real");
        
        // 협력업체 담당자 조회
        String subject  = "[전자구매시스템] 협력사 [" + grid.get("VENDOR_NM") + "]에서 ["+ formData.get("CONT_DESC") +"] 계약을 [서명완료] 하였습니다";
        
        StringBuffer sb = new StringBuffer();
        sb.setLength(0);
        sb.append("<BR> 안녕하세요.																								");
        sb.append("<BR> " + formData.get("CONT_USER_NM") +" 님.																	");
        sb.append("<BR> 																										");
        sb.append("<BR> 아래와 같이 협력사에서 계약서에 대한 전자서명을 완료 하였습니다															");
        sb.append("<BR> 협력사 : [" + grid.get("VENDOR_NM") + "]																	");
        sb.append("<BR> 계약명 : [" + formData.get("CONT_NUM") + "] " + formData.get("CONT_DESC") + " 								");
        sb.append("<BR> 처리일 : [" + EverDate.getDateString() + "	]																");
        sb.append("<BR> 처리결과 : [서명완료]																						");
        sb.append("<BR> 																										");
        sb.append("<BR> 전자구매시스템에 <a href=\"" + linkUrl + "\" target=\"newP\">로그인</a> 하시어, 세부내용을 확인 후 처리 해주십시오.		");
        sb.append("<BR> 																										");
        sb.append("<BR> 감사합니다.																								");

        formData.put("SUBJECT", subject);
        formData.put("CONTENTS", sb.toString());
        formData.put("REF_MODULE_CD", "MCONT03");
        formData.put("RECV_USER_ID", formData.get("CONT_USER_ID"));	// 계약담당자
        everMailService.SendMail(formData);

        // SMS 발송
        Map<String,String> smsMap = new HashMap<String,String>();
        smsMap.put("CONTENTS", subject);
        smsMap.put("REF_MODULE_CD", "SCONT03");
        smsMap.put("RECV_USER_ID", formData.get("CONT_USER_ID"));	// 계약담당자
        
        // 2021.07.02 : 다수계약서 협력사 서명완료 후 SMS 수수료 부과
        Map<String, String> costInfo = cctr0020_Mapper.costSmsInfo(formData);
        smsMap.put("CORP_NO", costInfo.get("CORP_NO"));     	// 고객사 사업자번호
        smsMap.put("BRC", costInfo.get("BRC"));            		// 고객사 부서
        smsMap.put("EPRO_PS_DSC", "1");     					// 1  : 구매
        smsMap.put("EPRO_RATE_DSC", "01");  					// 01 : 최초
        smsMap.put("APLY_DT", costInfo.get("APLY_DT"));     	// 발생일 YYYYMMDD
        smsMap.put("USER_ID", costInfo.get("USER_ID"));     	// 고객사 보내는사람 ID
        smsMap.put("CONT_TBL_ID", "STOCECCT");              	// 검증 테이블
        smsMap.put("CONT_TBL_PK", costInfo.get("CONT_TBL_PK")); // 검증 조건
        smsMap.put("tmp", costInfo.get("CONT_TBL_PK"));         // 유니크한 값.
        smsMap.put("payFlag", "Y");
        
        everSmsService.sendSmsNhe(smsMap);
  	}
    
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public Map<String, String> ccta0030_doFinishContract(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> formData = req.getFormData();
        Map<String, String> contractInformation = cctr0020_Mapper.ccta0030_getContractInformation(formData);

        // 수기계약일때만 계약완료 가능하도록 체크
        if(!contractInformation.get("MANUAL_CONT_FLAG").equals(Code.M008_1)) {
            throw new Exception("수기계약만 계약완료 처리할 수 있습니다.");
        }

        formData.put("PROGRESS_CD", Code.M135_4300);
        cctr0020_Mapper.ccta0030_doUpdateStatusOfECCT(formData);

        resp.setResponseMessage(msg.getMessageByScreenId("CCTA0030", "0021"));

        return formData;
    }

    /**
     * 계약서 서식을 넘겨받은 정보로 내용을 치환하여 리턴
     *
     * @param contents          대상데이터(서식)
     * @param buyerInformationList  조회한 구매사 정보
     * @param vendorInformation 조회한 협력회사 정보
     * @param formData          화면의 입력폼
     * @return
     * @throws ParseException
     * @throws UserInfoNotFoundException
     */
    public String getReplacedContentsWithInformation(String contents,
                                                     List<Map<String, String>> buyerInformationList,
                                                     Map<String, String> vendorInformation,
                                                     Map<String, String> formData) throws ParseException {

        Source source = new Source(contents.replaceAll("&lt;", "<").replaceAll("&gt;", ">"));
        OutputDocument outputDocument = new OutputDocument(source);

        List<FormControl> formControls = source.getFormControls();
        for (FormControl formControl : formControls) {

            String name = formControl.getName();
            if (EverString.isNotEmpty(name)) {

                /* 서식선택 팝업에서 입력한 정보들과 동일한 이름들이 있는 지 체크 후 치환 */
                if (formData != null) {
                    if (formData.containsKey(name)) {
                        formControl.setValue(EverString.defaultIfEmpty(String.valueOf(formData.get(name)), ""));
                        ContStringUtil.makeupFormValue(formControl);
                    }

                    /* 지체상금율 */
                    if(name.equals("DELAY")) {
                        String delay = "";
                        String delayDefaultTxt = " 1일에 대하여 계약금액의 ";

                        if(StringUtils.isNotEmpty(formData.get("DELAY_RMK")) &&
                                StringUtils.isNotEmpty(String.valueOf(formData.get("DELAY_NUME_RATE"))) &&
                                StringUtils.isNotEmpty(String.valueOf(formData.get("DELAY_DENO_RATE")))) {
                            delay = formData.get("DELAY_RMK") + delayDefaultTxt + String.valueOf(formData.get("DELAY_NUME_RATE")) + " / " + String.valueOf(formData.get("DELAY_DENO_RATE"));
                        }

                        formControl.setValue(EverString.defaultIfEmpty(delay, ""));
                    }

                    /* 계약금액(한글)일 경우 한글로 숫자를 표기하도록 치환 */
                    if (name.equals("CONT_AMT_KR")) {
                        if(StringUtils.isNotEmpty(formData.get("CONT_AMT"))) {
                            formControl.setValue(ContStringUtil.numberToKorean(String.valueOf(formData.get("CONT_AMT"))));
                        }
                    }

                    if (name.equals("CONT_LAST_DAYS")) {
                        if(StringUtils.isNotEmpty(formData.get("CONT_START_DATE")) && StringUtils.isNotEmpty(formData.get("CONT_END_DATE"))) {
                            SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
                            Date contStartDate = sdf.parse(formData.get("CONT_START_DATE"));
                            Date contEndDate = sdf.parse(formData.get("CONT_END_DATE"));
                            formControl.setValue(ContStringUtil.toPositionalNumber(String.valueOf(Days.daysBetween(new LocalDate(contStartDate), new LocalDate(contEndDate)).getDays()+1 )));
                            ContStringUtil.makeupFormValue(formControl);
                        }
                    }
                }

                /* 구매사 정보와 동일한 이름이 있으면 치환 */
                if (buyerInformationList != null) {
                    for(Map<String, String> buyerInfo : buyerInformationList) {
                        if (buyerInfo.containsKey(name)) {
                            formControl.setValue(EverString.defaultIfEmpty(String.valueOf(buyerInfo.get(name)), ""));
                            ContStringUtil.makeupFormValue(formControl);
                        }
                    }

                }
                if (vendorInformation != null) {
                    if (vendorInformation.containsKey(name)) {
                        formControl.setValue(EverString.defaultIfEmpty(vendorInformation.get(name), ""));
                        ContStringUtil.makeupFormValue(formControl);
                    }
                }
            }
            /* 각각의 formControl에 setValue() 한 결과가 적용되기 위한 필수코드입니다. */
            outputDocument.replace(formControl);
        }

        return outputDocument.toString();
    }

    private Map<String, String> getBaseDataForm() {

        Map<String, String> dataFormMap = new HashMap<String, String>();
        dataFormMap.put("CONT_USER_ID", UserInfoManager.getUserInfo().getUserId());
        dataFormMap.put("CONT_USER_NM", UserInfoManager.getUserInfo().getUserNm());
        dataFormMap.put("BUYER_CD", UserInfoManager.getUserInfo().getCompanyCd());
        dataFormMap.put("BUYER_NM", UserInfoManager.getUserInfo().getCompanyNm());
        dataFormMap.put("CONT_DATE", EverDate.getDate());

        return dataFormMap;
    }

    /**
     * 계약서 저장
     *
     * @param formData
     * @param gridDataM
     * @param gridDataA
     * @return
     * @throws Exception
     */
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public Map<String, String> doSaveContract(Map<String, String> formData, List<Map<String, Object>> gridDataM, List<Map<String, Object>> gridDataA) throws Exception
    {
        formData.put("FORM_NUM", (String) gridDataM.get(0).get("FORM_NUM"));
        String deptFlag = (String) gridDataM.get(0).get("DEPT_FLAG"); // 주소속부서지정유무 (이 값이 1(Y)이면 form의 부서코드값을 넣어주고, 0(N)이면 세션의 부서코드를 넣어준다.
        boolean legalTeamFlag = StringUtils.equals((String) gridDataM.get(0).get("EXAM_FLAG"), "1");       // 법무팀 검토 여부
        boolean approvalFlag = StringUtils.equals((String) gridDataM.get(0).get("APPROVAL_FLAG"), "1");    // 체결기안 여부

        // 주소속부서지정이 Y가 아니면 세션의 부서코드를 넣어준다.
        UserInfo userInfo = UserInfoManager.getUserInfo();
        if (!StringUtils.equals(deptFlag, Code.M008_1)) {
            formData.put("BELONG_DEPT_CD", userInfo.getDeptCd());
        }

        String contNum = formData.get("CONT_NUM");
        String contCnt = formData.get("CONT_CNT");
        if (StringUtils.isEmpty(contNum) && StringUtils.isEmpty(contCnt)) {

            // 계약번호가 없으면 저장이 안된 상태이므로 INSERT 처리
            formData.put("CONT_NUM", docNumService.getDocNumber(userInfo.getCompanyCd(), "EC"));
            formData.put("CONT_CNT", "1");
            formData.put("PROGRESS_CD", Code.M135_4200);
            formData.put("CONT_DEPT_CD", UserInfoManager.getUserInfo().getDeptCd());

            cctr0020_Mapper.ccta0030_doInsertECCT(formData);

            formData.put("FORM_SQ", MAIN_FORM_SQ);

            //STOCTXHD, TXDT로 변경
            String largeTextNum = formData.get("CONTRACT_TEXT_NUM");
            if( EverString.isEmpty(EverString.replace(largeTextNum, " ", "")) ){
                largeTextNum = docNumService.getDocNumber(userInfo.getCompanyCd(), "TN");
                formData.put("CONTRACT_TEXT_NUM", largeTextNum);
            } else {
                formData.put("CONTRACT_TEXT_NUM", largeTextNum);
            }

            formData.put("CONTRACT_TEXT", ContStringUtil.replaceUserNotEditableForms(formData.get("mainContractContents"), formData));

            cctr0020_Mapper.ccta0030_doInsertECRL(formData);

            //법무팀 계약정보 테이블(STOCECWT)에 계약번호 UPDATE하기
            if( StringUtils.isNotEmpty(formData.get("IF_NUM")) ){
                cctr0020_Mapper.ccta0030_doUpdateECWT(formData);
            }
        }
        else {
            formData.put("FORM_SQ", MAIN_FORM_SQ);
            formData.put("PROGRESS_CD", Code.M135_4200);

            //STOCTXHD, TXDT로 변경
            String largeTextNum = formData.get("CONTRACT_TEXT_NUM");
            if( EverString.isEmpty(EverString.replace(largeTextNum, " ", "")) ){
                largeTextNum = docNumService.getDocNumber(userInfo.getCompanyCd(), "TN");
                formData.put("CONTRACT_TEXT_NUM", largeTextNum);
            } else {
                formData.put("CONTRACT_TEXT_NUM", largeTextNum);
            }

            formData.put("CONTRACT_TEXT", ContStringUtil.replaceUserNotEditableForms(formData.get("mainContractContents"), formData));

            cctr0020_Mapper.ccta0030_doUpdateECCT(formData);
            cctr0020_Mapper.ccta0030_doUpdateECRL(formData);

        }

        // 부서식 저장
        for (int i = 0; i < gridDataA.size(); i++) {
            Map<String, Object> datum = gridDataA.get(i);
            datum.put("CONT_NUM", formData.get("CONT_NUM"));
            datum.put("CONT_CNT", formData.get("CONT_CNT"));

            //STOCTXHD, TXDT로 변경
            String largeTextNum = (String) datum.get("CONTRACT_TEXT_NUM");
            if( EverString.isEmpty(EverString.replace(largeTextNum, " ", "")) ){
                largeTextNum = docNumService.getDocNumber(userInfo.getCompanyCd(), "TN");
                datum.put("CONTRACT_TEXT_NUM", largeTextNum);
            } else {
                datum.put("CONTRACT_TEXT_NUM", largeTextNum);
            }

            //datum.put("CONTRACT_TEXT", ContStringUtil.replaceUserNotEditableForms((String) datum.get("FORM_CONTENTS"), formData));
            //datum.put("CONTRACT_TEXT", addContractText);

            cctr0020_Mapper.ccta0030_doInsertAddECRL(datum);
        }

        return formData;
    }

    /**
     * 첨부파일 정보를 계약서에 첨부하기 위한 메소드
     * @param paramMap
     * @return
     * @throws IOException
     */
    private String getFileInformation(Map<String, String> paramMap) throws IOException {

        StringBuilder sb = new StringBuilder();
        List<Map<String, Object>> fileInformation = cctr0020_Mapper.ccta0030_getFileInformation(paramMap);
        if(fileInformation != null && fileInformation.size() > 0) {
            sb.append("<br><br><div style=\"margin: 0 auto;display: table;\">\n" +
                    "<section style=\"width: 674px;padding: 5px;border: 1px solid #b0b0b0;\">\n" +
                    "\t<h1 style=\"margin: 5px 5px 5px;\n" +
                    "    font-size: 18px;\n" +
                    "    text-align: center;\n" +
                    "    font-weight: 800;\">계 약 서 파 일</h1></h1>\n" +
                    "<div class=\"txt-comm\">");

            sb.append("<style type=\"text/css\"> \n")
                    .append(" table.econtAttach {width:100%;border-collapse:collapse;border-spacing:0;border-left:1px solid #ccc;border-bottom:1px solid #ccc;padding:2px;} \n")
                    .append("      .econtAttach th {font-size:13px;font-weight:bold;text-align:center;color:#333;border-top:1px solid #ccc;border-right:1px solid #ccc;font-family:'Nanum Gothic', '맑은 고딕', '돋움', sans-serif} \n")
                    .append("      .econtAttach td {font-size:12px;text-align:left;color:#333;border-top:1px solid #ccc;border-right:1px solid #ccc;font-family:'Nanum Gothic', '맑은 고딕', '돋움', sans-serif} \n")
                    .append("</style> \n")
                    .append("<br><br> \n")
                    .append("<table class=\"econtAttach\"> \n")
                    .append("<tr><th>순서</th><th>계약서 첨부파일명</th><th>파일크기</th><th>MD5 Checksum</th></tr> \n");

            int seqNumber = 0;
            for (Map<String, Object> datum : fileInformation) {
                String fullPath = (String) datum.get("FULL_PATH");
                /*
                File file = new File(fullPath);
                if (file.exists()) {
                    FileInputStream fis = new FileInputStream(file);
                    String md5 = DigestUtils.md5Hex(fis);
                    sb.append("<tr>")
                            .append("<td style=\"text-align: center;\">").append(++seqNumber).append("</td> \n")
                            .append("<td>").append(datum.get("REAL_FILE_NM")).append("</td> \n")
                            .append("<td style=\"text-align: right;\">").append(ContStringUtil.toPositionalNumber(String.valueOf(datum.get("FILE_SIZE")))).append("</td> \n")
                            .append("<td>").append(md5).append("</td> \n")
                            .append("</tr>");
                }
                */
            }
            sb.append("</table><br>");
            sb.append("</section>\n" +
                    "</div>");
        }
        return sb.toString();
    }
    
    /**
     * 계약 고객사별 지불고객사 및 지불정보 가져오기
     * @param formData
     * @return
     * @throws Exception
     */
    public List<Map<String, Object>> ccta0030_doSearchECCM(Map<String, String> formData) throws Exception {
    	
    	// 계약번호, 이전계약번호가 존재하는 경우 데이터 가져오기
        List<Map<String, Object>> gridDataECCM = cctr0020_Mapper.ccta0030_doSearchECCM(formData);
        for (Map<String, Object> gridECCM : gridDataECCM) {
            gridECCM.put("PC_HD_INFO", EverConverter.getJsonString(cctr0020_Mapper.ccta0030_doSearchECPC_HD(gridECCM)));

            int ecpyCnt = 0;
            List<Map<String, Object>> gridDataECPY = cctr0020_Mapper.ccta0030_doSearchECPY(gridECCM);
            for (Map<String, Object> gridECPY : gridDataECPY) {
                String pyBuyerNm = "";
                if(!"".equals(EverString.nullToEmptyString(formData.get("BUYER_CD")))) {
                    gridECPY.put("BUYER_CD", formData.get("BUYER_CD"));
                }
                List<Map<String, Object>> gridDataECPC = cctr0020_Mapper.ccta0030_doSearchECPC(gridECPY);

                int ecpcCnt = 1;
                for (Map<String, Object> gridECPC : gridDataECPC) {
                    if (gridDataECPC.size() == ecpcCnt) {
                        pyBuyerNm += gridECPC.get("PY_BUYER_DEPT_NM");
                    } else {
                        pyBuyerNm += gridECPC.get("PY_BUYER_DEPT_NM") + ", ";
                    }
                    ecpcCnt++;
                }

                gridECPY.put("PY_BUYER_NM", pyBuyerNm);
                gridECPY.put("PC_INFO", EverConverter.getJsonString(gridDataECPC));
                ecpyCnt++;
            }
            gridECCM.put("PAY_CNT", ecpyCnt);
            gridECCM.put("PY_INFO", EverConverter.getJsonString(gridDataECPY));
        }

        return gridDataECCM;
    }
    
    /**
     * 작성된 계약서 기준 품목정보 조회 (STOCECMT)
     * @param formData
     * @return
     */
    public List<Map<String, Object>> ccta0030_doSearchECMT(Map<String, String> formData) throws Exception {
        return cctr0020_Mapper.ccta0030_doSearchECMT(formData);
    }
    
    /**
     * 선정품의 기준 계약서 작성 (STOCCNDT)
     * @param formData
     * @return
     */
    public List<Map<String, Object>> ccta0030_doSearchCNDT(Map<String, String> formData) throws Exception {
    	
    	String contReqCd = formData.get("CONT_REQ_CD");
    	String autoExtend = formData.get("AUTO_EXTEND");
    	System.out.println("구매의뢰 연장계약 구분 값 AUTO_EXTEND ==========> " + autoExtend );
        Map<String, Object> formDataMap = (Map) formData;
        List<Map<String, Object>> gridList = new ArrayList<Map<String, Object>>();
        
        // 1. 연장계약인 경우 구매의뢰 기준으로 계약서 작성
        formDataMap.put("EXEC_NUM_SQ_LIST", Arrays.asList(formData.get("EXEC_NUM_SQ").split(",")));
        if(autoExtend.equals("1")) {
        	System.out.println(" ===== 구매의뢰 계약대기현황 연장계약 =====");
        	gridList = cctr0020_Mapper.ccta0030_doSearchCNDT(formDataMap);
        } else {
	        if( "30".equals(contReqCd) ) {
	        	System.out.println(" ===== 구매의뢰 구매의뢰접수 연장계약 =====");
	        	gridList = cctr0020_Mapper.ccta0030_doSearchPRDT(formDataMap);
	        } // 2. 품의서 기준으로 계약서 작성 (변경(20), 신규(10) 계약)
	        else {
	        	System.out.println(" ===== 구매의뢰 계약대기현황 신규,변경 계약 및 계약서 작성화면 신규계약  =====");
	            gridList = cctr0020_Mapper.ccta0030_doSearchCNDT(formDataMap);
	        }
        }
        return gridList;
    }
    
    public List<Map<String, Object>> cctr0050_doSearch(Map<String, String> formData) {
    	String type   = formData.get("TYPE");
        Map<String, Object> formObj = new HashMap<String, Object>(formData);
        
        /**
         * 2021.09.07
         * 계약체결, 위수탁 화면 조회조건 진행상태 코드명 분리
         */
        if( type.equals("A") || type.equals("B") ){
        	formObj.put("PROGRESS_CD_LIST", Arrays.asList(formData.get("PROGRESS_CD").split(",")));
        } else {
        	formObj.put("NHPROGRESS_CD_LIST", Arrays.asList(formData.get("NHPROGRESS_CD").split(",")));
        }
        
        //formObj.put("PROGRESS_CD_LIST", Arrays.asList(formData.get("PROGRESS_CD").split(",")));
        return cctr0020_Mapper.cctr0050_doSearch(formObj);
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public void cctr0050_changeContUser(Map<String, String> formData, List<Map<String, Object>> gridData) {
        for (Map<String, Object> grid : gridData) {
            grid.put("CHANGE_CONT_USER_ID", formData.get("CHNG_USER_ID"));
            cctr0020_Mapper.cctr0050_changeContUser(grid);
        }
    }
    
    /**
     * 2021.07.30 기능 추가
     * 고객사 전자서명전 전자보증 취소요청건 존재여부 체크
     */
    public Map<String, String> ccta0030_guarCancelData(Map<String, String> param) throws Exception {
    	
    	Map<String, String> guarMap = cctr0020_Mapper.ccta0030_guarCancelData(param);
        
        String rtnCode = "";
        String rtnMsg  = "";
        String guarFlag = guarMap.get("GUAR_FLAG");
        
        if( "N".equals(guarFlag) ) { 	//취소요청건 없는 경우
        	rtnCode = "N";
        	rtnMsg  = msg.getMessageByScreenId("CCTA0030", "0050");
        }
        else if( "Y".equals(guarFlag) ) { // 취소요청건 있는는 경우
        	rtnCode = "Y";
        	rtnMsg  = msg.getMessageByScreenId("CCTA0030", "0051");
        }
        
        Map<String, String> rtnMap = new HashMap<>();
        rtnMap.put("rtnCode", rtnCode);
        rtnMap.put("rtnMsg", rtnMsg);
        
        return rtnMap;
    }
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public int cctr0050_doStop(Map<String, String> formData, List<Map<String, Object>> gridData) {
    	
        BaseInfo baseInfo = UserInfoManager.getUserInfo();

        String companyName = PropertiesManager.getString("eversrm.system.mailSenderCompanyName", "");
        String senderName  = PropertiesManager.getString("eversrm.system.mailSenderName", "");
        String domailUrl   = PropertiesManager.getString("personal.url", "");

        int maxIfCount = 0;
        for (Map<String, Object> grid : gridData) {
            grid.put("CONT_CLOSE_RMK", formData.get("CONT_CLOSE_RMK"));

            // 1. 계약체결 중단
            cctr0020_Mapper.cctr0050_doStop(grid);

            /**
             * 협력사 계약체결 중단 메일 및 sms 전송
             * 기존 제외된 사항임 (문구 작성 : 2021.01.05)
            String contMngNum = (String)grid.get("CONT_NUM");
            // 1. 메일 전송
            if( EverString.isNotEmpty(String.valueOf(grid.get("VENDOR_PIC_USER_EMAIL"))) && !"null".equals(String.valueOf(grid.get("VENDOR_PIC_USER_EMAIL")))) {
                try {
                    Map<String, String> mailData = new HashMap<>();

                    String contDesc = String.valueOf(grid.get("CONT_DESC"));
                    String subject  = "[" + companyName + "] 전자계약 체결 중단 통보";
                    String contentsText = "[" + senderName + "]<br><br>" +
                            "귀사와 진행 중인 전자계약 체결 건이 계약담당자에 의해 중단 되었습니다.<br><br>" +
                            "- 회사 : " + companyName + "<br>" +
                            "- 계약번호 : " + contMngNum + "<br>" +
                            "- 계약명 : " + contDesc + "<br>" +
                            "- 계약담당자 : " + String.valueOf(EverString.nullToEmptyString(grid.get("DEC_CONT_USER_NM"))) + " (TEL : " + String.valueOf(EverString.nullToEmptyString(grid.get("DEC_CONT_USER_TEL_NUM"))) + ")<br>" +
                            "- 중단사유 : " + EverString.nToBr(EverString.nullToEmptyString(grid.get("CONT_CLOSE_RMK"))) + "<br><br>" +
                            "시스템에 접속하여 내용 검토 하시기 바랍니다.<br>" +
                            "감사합니다.<br>";

                    String mailContents = mailTemplate.getMailTemplate("", subject, contentsText);

                    mailData.put("SEND_USER_ID", baseInfo.getUserId()); // 발신자ID : 계약담당자ID
                    mailData.put("SEND_USER_NM", baseInfo.getUserNm()); // 발신자명 : 계약담당자명
                    mailData.put("RECV_USER_ID", String.valueOf(grid.get("VENDOR_CD"))); // 수신자ID
                    mailData.put("RECV_USER_NM", String.valueOf(grid.get("VENDOR_PIC_USER_NM"))); // 수신자명
                    mailData.put("RECV_EMAIL",   String.valueOf(grid.get("VENDOR_PIC_USER_EMAIL"))); // 수신자EMAIL
                    mailData.put("SUBJECT",  subject);
                    mailData.put("CONTENTS", mailContents);
                    mailData.put("REF_MODULE_CD", "EC");
                    mailData.put("REF_NUM", contMngNum);
                    mailData.put("BUYER_CD", baseInfo.getCompanyCd());
                    // everMailService.SendMail(mailData);
                }
                catch (Exception ex) {
                    getLog().error("협력사 계약중단 MAIL 발송 오류 : " + ex.getMessage(), ex);
                }
            }

            // SMS 전송
            if( EverString.isNotEmpty(String.valueOf(grid.get("VENDOR_PIC_USER_CELL_NUM"))) && !"null".equals(String.valueOf(grid.get("VENDOR_PIC_USER_CELL_NUM")))) {
                try {
                    Map<String, String> smsMap = new HashMap<String, String>();

                    String subject  = "[" + companyName + "] 전자계약 체결 중단 통보";
                    String contents = "[" + senderName + "] 귀사와 진행 중인 전자계약 체결 건이 계약담당자에 의해 중단 되었습니다. (계약번호 : " + contMngNum + ")";

                    smsMap.put("SEND_USER_ID", baseInfo.getUserId());
                    smsMap.put("SEND_USER_NM", baseInfo.getUserNm());
                    smsMap.put("RECV_USER_ID", String.valueOf(grid.get("VENDOR_CD")));
                    smsMap.put("RECV_USER_NM", String.valueOf(grid.get("VENDOR_PIC_USER_NM")));
                    smsMap.put("RECV_TEL_NUM", String.valueOf(grid.get("VENDOR_PIC_USER_CELL_NUM")));
                    smsMap.put("SUBJECT", subject );
                    smsMap.put("CONTENTS", contents );
                    smsMap.put("REF_MODULE_CD", "EC");
                    smsMap.put("REF_NUM", contMngNum);
                    smsMap.put("BUYER_CD", baseInfo.getCompanyCd());
                    // everSmsService.sendSms(smsMap);
                }
                catch (Exception ex) {
                    getLog().error("협력사 계약중단 SMS 발송 오류 : " + ex.getMessage(), ex);
                }
            }*/
        }
        
        return maxIfCount;
    }
    
    /**
     * 2021.08.26 : IT포탈 의뢰번호 등 저장
     * @param formData
     * @param gridData
     */
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public Map<String, String> cctr0050_doSave(List<Map<String, Object>> gridData) throws Exception {
        for (Map<String, Object> grid : gridData) {
            cctr0020_Mapper.cctr0050_doSave(grid);
        }
        Map<String, String> rtnMap = new HashMap<>();
        rtnMap.put("rtnMsg", msg.getMessage("0031"));
		
        return rtnMap;
    }
    
    public List<Map<String, Object>> cctr0051_doSearch(Map<String, String> paramDataMap) {
        return cctr0020_Mapper.cctr0051_doSearch(paramDataMap);
    }

    public List<Map<String, Object>> cctr0052_doSearch(Map<String, String> paramDataMap) {
        return cctr0020_Mapper.cctr0052_doSearch(paramDataMap);
    }

    public List<Map<String, Object>> cctr0053_doSearch(Map<String, String> paramDataMap) {
        return cctr0020_Mapper.cctr0053_doSearch(paramDataMap);
    }

    public List<Map<String, Object>> cctr0054_doSearch(Map<String, String> paramDataMap) {
        return cctr0020_Mapper.cctr0054_doSearch(paramDataMap);
    }
    
    // 2021.03.11 협력업체 보증 취소요청 승인
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public Map<String, String> cctr0051_doConfirm(Map<String, String> formData, List<Map<String, Object>> grid) throws Exception {
        Map<String, String> rtnMap = new HashMap<>();

        for(Map<String, Object> data : grid) {

            cctr0020_Mapper.cctr0051_doConfirm(data);
            
            // 협력업체 보증 취소요청 승인 메일발송
     		try {
     			sendConfirmMail(data);
     		} catch (Exception ex) {
                getLog().error("협력업체 보증 취소요청 승인 메일 발송 오류 : " + ex.getMessage(), ex);
            }
        }
        
        //rtnMap.put("rtnMsg", msg.getMessage("0125"));
        rtnMap.put("rtnMsg", msg.getMessageByScreenId("CCTR0055", "001"));

        return rtnMap;
    }
    
    // 이메일 발송(협력업체 보증 취소요청 승인)
   	public void sendConfirmMail(Map<String, Object> gridData) throws Exception {
          
          String linkUrl = PropertiesManager.getString("eversrm.urls.maintain.real") ;
          
          // 메일 발송정보 가져오기
          List<Map<String, String>> mailList = cctr0020_Mapper.cctr0051_getguarInformation(gridData);
          for(Map<String, String> data : mailList) {
          	try {
  	 			String subject  = "[전자구매시스템] 협력사 [" + data.get("VENDOR_NM") + "]에서 요청하신 보증취소요청 건에 대해 [승인] 하였습니다";
  	 			
  	 			Map<String,String> mailMap = new HashMap<>();
  	 			
  	 			String contents = "<BR> 안녕하세요." +
  	 					"<BR> [" + data.get("VENDOR_NM") + "] " + data.get("USER_NM") + " 님" +
  	 					"<BR> " +
  	 					"<BR> 아래와 같이 고객사에서 보증취소요청 건에 대해 승인 하였습니다. 신청하신 보증기관에 별도로 취소요청을 해주시기 바랍니다.<br>" +
  	 					"<BR> 계약명 : ["+ data.get("CONT_DESC") + "]" +
  	 					"<BR> 보증구분 : ["+ data.get("GUAR_TYPE") + "]" +
  	 					"<BR> 처리일 : ["+ data.get("SYS_DATE") + "]" +
  	 					"<BR> 처리결과 : [승인]" +
  	 					"<BR> " +
  	 					"<BR> 전자구매시스템에 <a href='" + linkUrl + "' target='newP'>로그인</a> 하시어, 세부내용을 확인 해주십시오." +
  	 					"<BR> " +
  	 					"<BR> 감사합니다.";
  	
  	 			mailMap.put("SUBJECT", subject);
  	 			mailMap.put("CONTENTS", contents);
  	 			mailMap.put("REF_MODULE_CD", "MCONT03");
  	 			mailMap.put("RECV_USER_ID", data.get("USER_ID"));
  	 			everMailService.SendMail(mailMap);
          	} catch (Exception ex) {
                  getLog().error("보증취소요청 승인 전송 후 메일 발송 오류 : " + ex.getMessage(), ex);
            }
   		 }
   	}
    
    // 2021.03.11 협력업체 보증 취소요청 반려
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public Map<String, String> cctr0051_doReject(Map<String, String> formData, List<Map<String, Object>> grid) throws Exception {
        Map<String, String> rtnMap = new HashMap<>();

        for(Map<String, Object> data : grid) {
        	data.put("GUAR_REJECT_RMK", formData.get("GUAR_REJECT_RMK"));
            cctr0020_Mapper.cctr0051_doReject(data);
            
            // 협력업체 보증 취소요청 반려 메일발송
     		try {
     			sendRejectMail(data);
     		} catch (Exception ex) {
                getLog().error("협력업체 보증 취소요청 반려 메일 발송 오류 : " + ex.getMessage(), ex);
            }
        }
        
        rtnMap.put("rtnMsg", msg.getMessage("0058"));

        return rtnMap;
    }
    
    // 이메일 발송(협력업체 보증 취소요청 반려)
  	public void sendRejectMail(Map<String, Object> gridData) throws Exception {
         
         String linkUrl = PropertiesManager.getString("eversrm.urls.maintain.real") ;
         
         // 메일 발송정보 가져오기
         List<Map<String, String>> mailList = cctr0020_Mapper.cctr0051_getguarInformation(gridData);
         for(Map<String, String> data : mailList) {
         	try {
 	 			String subject  = "[전자구매시스템] 협력사 [" + data.get("VENDOR_NM") + "]에서 요청하신 보증취소요청 건에 대해 [반려] 하였습니다";
 	 			
 	 			Map<String,String> mailMap = new HashMap<>();
 	 			
 	 			String contents = "<BR> 안녕하세요." +
 	 					"<BR> [" + data.get("VENDOR_NM") + "] " + data.get("USER_NM") + " 님" +
 	 					"<BR> " +
 	 					"<BR> 아래와 같이 고객사에서 보증취소요청 건에 대해 반려 하였습니다 <br>" +
 	 					"<BR> 계약명 : ["+ data.get("CONT_DESC") + "]" +
 	 					"<BR> 보증구분 : ["+ data.get("GUAR_TYPE") + "]" +
 	 					"<BR> 처리일 : ["+ data.get("SYS_DATE") + "]" +
 	 					"<BR> 처리결과 : [반려]" +
 	 					"<BR> " +
 	 					"<BR> 전자구매시스템에 <a href='" + linkUrl + "' target='newP'>로그인</a> 하시어, 세부내용을 확인 해주십시오." +
 	 					"<BR> " +
 	 					"<BR> 감사합니다.";
 	
 	 			mailMap.put("SUBJECT", subject);
 	 			mailMap.put("CONTENTS", contents);
 	 			mailMap.put("REF_MODULE_CD", "MCONT03");
 	 			mailMap.put("RECV_USER_ID", data.get("USER_ID"));
 	 			everMailService.SendMail(mailMap);
         	} catch (Exception ex) {
                 getLog().error("보증취소요청 반려 전송 후 메일 발송 오류 : " + ex.getMessage(), ex);
            }
  		 }
  	}
    
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public void cctr0050_doFinish(Map<String, String> formData, List<Map<String, Object>> gridData) {
        for (Map<String, Object> grid : gridData) {
            grid.put("CONT_CLOSE_DATE", formData.get("CONT_CLOSE_DATE"));
            grid.put("CONT_CLOSE_RMK", formData.get("CONT_CLOSE_RMK"));
            cctr0020_Mapper.cctr0050_doFinish(grid);
        }
    }

    public void cctr0050_doUpdate(List<Map<String, Object>> gridData) {
        for (Map<String, Object> grid : gridData) {
            cctr0020_Mapper.cctr0050_doUpdate(grid);
        }
    }

    public String cctr0050_doResumeCheck(List<Map<String, Object>> gridData) {
        int contCnt = 0;
        String returnStr = "";
        for (Map<String, Object> rowData : gridData) {
            try {
                contCnt = Integer.parseInt(String.valueOf(rowData.get("CONT_CNT"))) + 1;
            } catch (Exception e) {
                getLog().error(e.getMessage(), e);
                contCnt = 1;
            }
            rowData.put("NEW_CONT_CNT", contCnt);

            returnStr = cctr0020_Mapper.cctr0050_doResumeCheck(rowData);
        }
        return returnStr;
    }
    
    /**
     * 계약체결현황 (CCTR0050) > 변경계약서 작성
     * @param param
     * @param gridData
     * @return
     * @throws Exception
     */
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public Map<String, String> cctr0050_doResume(Map<String, String> param, List<Map<String, Object>> gridData) throws Exception {
        UserInfo userInfo = UserInfoManager.getUserInfo();
        
        String buyerCd = "";
        String contNum = "";
        String contCnt = "";
        int newContCnt = 0;
        for (Map<String, Object> rowData : gridData) {
        	buyerCd = String.valueOf(rowData.get("BUYER_CD"));
            contNum = String.valueOf(rowData.get("CONT_NUM"));
            contCnt = String.valueOf(rowData.get("CONT_CNT"));
            
            try {
                newContCnt = Integer.parseInt(String.valueOf(rowData.get("CONT_CNT"))) + 1;
            } catch (Exception e) {
                getLog().error(e.getMessage(), e);
                newContCnt = 1;
            }
            rowData.put("NEW_CONT_CNT", newContCnt);
            
            // 1. STOCECCT 복사
            cctr0020_Mapper.cctr0050_doResume(rowData);
            // 2. STOCECCM 복사
            cctr0020_Mapper.cctr0050_doResumeECCM(rowData);
            // 3. STOCECMT 복사
            cctr0020_Mapper.cctr0050_doResumeECMT(rowData);
            // 4. STOCECPC 복사
            cctr0020_Mapper.cctr0050_doResumeECPC(rowData);
            // 5. STOCECPY 복사
            cctr0020_Mapper.cctr0050_doResumeECPY(rowData);
        }

        // STOCECRL 복사
        param.put("BUYER_CD", buyerCd);
        param.put("CONT_NUM", contNum);
        param.put("CONT_CNT", contCnt);
        List<Map<String, Object>> ecrlList = cctr0020_Mapper.cctr0050_doSearchECRL(param);
        
        for (Map<String, Object> ecrlData : ecrlList) {
            String largeTextNum = docNumService.getDocNumber(userInfo.getCompanyCd(), "TN");
            ecrlData.put("CONTRACT_TEXT_NUM", largeTextNum);
            
            // STOCECRL 복사
            ecrlData.put("NEW_CONT_CNT", String.valueOf(newContCnt));
            cctr0020_Mapper.cctr0050_doResumeECRL(ecrlData);
        }
        param.put("CONT_CNT", String.valueOf(newContCnt));

        return param;
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public Map<String, Object> cctr0050_doResume2(Map<String, String> param, List<Map<String, Object>> contNumList) throws Exception {
        UserInfo userInfo = UserInfoManager.getUserInfo();

        String contNum = "";
        String contCnt = "";
        String bundleNum = "";
        int newContCnt = 0;

        // 일괄계약번호가 있으면 채번
        if( StringUtils.isNotEmpty(param.get("BUNDLE_NUM")) ){
            bundleNum = docNumService.getDocNumber(userInfo.getCompanyCd(), "BC");
        }

        List<Map<String, Object>> contInfoList = new ArrayList<>();
        Map<String, Object> contInfo = new HashMap<>();
        for (Map<String, Object> rowData : contNumList) {
            rowData.put("BUNDLE_NUM", bundleNum);
            contNum = (String) rowData.get("CONT_NUM");
            contCnt = String.valueOf(rowData.get("CONT_CNT"));

            try {
                newContCnt = Integer.parseInt(String.valueOf(rowData.get("CONT_CNT"))) + 1;
            } catch (Exception e) {
                getLog().error(e.getMessage(), e);
                newContCnt = 1;
            }
            rowData.put("NEW_CONT_CNT", newContCnt);
            // 1. STOCECCT 복사
            cctr0020_Mapper.cctr0050_doResume(rowData);
            // 2. STOCECCM 복사
            cctr0020_Mapper.cctr0050_doResumeECCM(rowData);

            contInfo.put("CONT_NUM", contNum);
            contInfo.put("CONT_CNT", newContCnt);

            contInfoList.add(contInfo);

            // STOCECRL 복사
            param.put("CONT_NUM", contNum);
            param.put("CONT_CNT", contCnt);

            List<Map<String, Object>> ecrlList = cctr0020_Mapper.cctr0050_doSearchECRL(param);
            for (Map<String, Object> ecrlData : ecrlList) {

                String largeTextNum = docNumService.getDocNumber(userInfo.getCompanyCd(), "TN");
                ecrlData.put("CONTRACT_TEXT_NUM", largeTextNum);

                // STOCECRL 복사
                ecrlData.put("NEW_CONT_CNT", String.valueOf(newContCnt));
                cctr0020_Mapper.cctr0050_doResumeECRL(ecrlData);
            }
        }

        Map<String, Object> resultMap = new HashMap<>();
        resultMap.putAll(param);
        resultMap.put("BUNDLE_NUM", bundleNum);
        resultMap.put("CONT_NUM_CNT", contInfoList);

        return resultMap;
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public Map<String, Object> ccta0040_doSave(Map<String, String> dataForm, List<Map<String, Object>> gridDataM, List<Map<String, Object>> gridDataA, List<Map<String, Object>> gridDataV) throws Exception {
        return processBundleContract(Code.M135_4200, dataForm, gridDataM, gridDataA, gridDataV);
    }

    /**
     * 일괄계약서의 저장 또는 전송처리 (상태 빼고는 저장과 전송의 처리가 동일 -> 메일 처리는 생각)
     * @param progressCd 진행상태만 다르게 넣어줌
     * @param formData
     * @param gridDataM
     * @param gridDataA
     * @param gridDataV
     * @return
     */
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public Map<String, Object> processBundleContract(String progressCd, Map<String, String> formData, List<Map<String, Object>> gridDataM, List<Map<String, Object>> gridDataA, List<Map<String, Object>> gridDataV) throws Exception {

        UserInfo userInfo = UserInfoManager.getUserInfo();
        // 리턴 값
        Map<String, Object> rtnData = new HashMap<String, Object>();

        formData.put("FORM_NUM", (String) gridDataM.get(0).get("FORM_NUM"));
        formData.put("CONT_TYPE", (String) gridDataM.get(0).get("CONTRACT_FORM_TYPE"));
        // 주소속부서지정유무 (이 값이 1(Y)이면 해당 협력회사 영업사원의 부서코드값을 넣어주고, 0(N)이면 세션의 부서코드를 넣어준다.
        boolean shouldPutBizUserDept = String.valueOf(gridDataM.get(0).get("DEPT_FLAG")).equalsIgnoreCase(Code.M008_1);
        if (!shouldPutBizUserDept) {
            formData.put("BELONG_DEPT_CD", UserInfoManager.getUserInfo().getDeptCd());
        }

        // 일괄계약번호가 없으면 채번
        if( StringUtils.isEmpty(formData.get("BUNDLE_NUM")) ){
            String bundleNum = docNumService.getDocNumber(userInfo.getCompanyCd(), "BC");
            formData.put("BUNDLE_NUM", bundleNum);
            // 리턴값
            rtnData.put("BUNDLE_NUM", bundleNum);
        }

        // 협력사별 계약정보 세팅
        List<Map<String, Object>> vndList = new ArrayList<>();

        /* 구매사의 정보를 조회 */
        List<Map<String, String>> buyerInformationList = new ArrayList<>();
        Map<String, String> buyerInformation = new HashMap<>();

        Map<String, Object> formDataObj = (Map) formData;
        buyerInformation.putAll(cctr0020_Mapper.ccta0030_getBuyerInformation(formDataObj));
        buyerInformationList.add(buyerInformation);

        for (Map<String, Object> vendorDatum : gridDataV) {

            /* 협력회사의 정보를 조회 */
            Map<String, String> map = new HashMap<String, String>();
            map.put("VENDOR_CD", (String) vendorDatum.get("VENDOR_CD"));
            // Map<String, String> vendorInformation = cctr0020_Mapper.ccta0030_getVendorInformation(map);

            // String contractForm = formData.get("mainContractContents");
            /* 계약서 서식에서 입력폼의 내용을 협력회사마다 다르게 처리해준다. */
            // String resultContractForm = getReplacedContentsWithInformation(contractForm, buyerInformationList, vendorInformation, formData);

            formData.put("PROGRESS_CD", progressCd);
            formData.put("FORM_SQ", MAIN_FORM_SQ);
            formData.put("VENDOR_CD", (String) vendorDatum.get("VENDOR_CD"));
            formData.put("VENDOR_NM", (String) vendorDatum.get("VENDOR_NM"));
            formData.put("VENDOR_PIC_USER_NM", (String) vendorDatum.get("VENDOR_PIC_USER_NM"));
            formData.put("VENDOR_PIC_USER_EMAIL", (String) vendorDatum.get("VENDOR_PIC_USER_EMAIL"));
            formData.put("VENDOR_PIC_USER_CELL_NUM", (String) vendorDatum.get("VENDOR_PIC_USER_CELL_NUM"));
            formData.put("APP_DOC_NUM", (String) vendorDatum.get("APP_DOC_NUM"));
            formData.put("APP_DOC_CNT", String.valueOf(vendorDatum.get("APP_DOC_CNT")));
            // formData.put("CONTRACT_TEXT", resultContractForm);

            String largeTextNum = formData.get("CONTRACT_TEXT_NUM");
            if( EverString.isEmpty(EverString.replace(largeTextNum, " ", "")) ){
                largeTextNum = docNumService.getDocNumber(userInfo.getCompanyCd(), "TN");
                formData.put("CONTRACT_TEXT_NUM", largeTextNum);
            } else {
                formData.put("CONTRACT_TEXT_NUM", largeTextNum);
            }

            /* PK가 없으면 insert 한다. */
            String contNum = "";
            String contCnt = "1";
            if (StringUtils.isEmpty((String) vendorDatum.get("CONT_NUM")) && StringUtils.isEmpty((String) vendorDatum.get("CONT_CNT"))) {
                contNum = docNumService.getDocNumber(userInfo.getCompanyCd(),"EC");
                contCnt = "1";
            } else {
                contNum = (String) vendorDatum.get("CONT_NUM");
                contCnt = String.valueOf(vendorDatum.get("CONT_CNT"));
            }
            formData.put("CONT_NUM", contNum);
            formData.put("CONT_CNT", contCnt);

            if (StringUtils.isEmpty((String) vendorDatum.get("CONT_NUM")) && StringUtils.isEmpty((String) vendorDatum.get("CONT_CNT"))) {
                cctr0020_Mapper.ccta0030_doInsertECCT(formData);
                cctr0020_Mapper.ccta0030_doInsertECRL(formData);
                if(formData.get("CONT_TYPE").equals("1120")) {
                    formDataObj.put("VENDOR_DEPT_CD", vendorDatum.get("VENDOR_DEPT_CD"));
                    cctr0020_Mapper.ccta0030_doInsertECCM2(formDataObj);
                } else {
                    cctr0020_Mapper.ccta0030_doInsertECCM(formDataObj);
                }
            }
            else {
                cctr0020_Mapper.ccta0030_doUpdateECCT(formData);
                cctr0020_Mapper.ccta0030_doUpdateECRL(formData);
                if (formData.get("CONT_TYPE").equals("1120")) {
                    formDataObj.put("VENDOR_DEPT_CD", vendorDatum.get("VENDOR_DEPT_CD"));
                    cctr0020_Mapper.ccta0030_doUpdateECCM2(formDataObj);
                } else {
                    cctr0020_Mapper.ccta0030_doUpdateECCM(formDataObj);
                }

                // 주계약서를 제외한 부서식은 저장 후에 선택을 뺄 수도 있으므로 기존 데이터를 삭제하고 다시 넣는다.
                cctr0020_Mapper.ccta0030_doDeleteAddECRL(formData); // 부서식 내용번호 삭제
            }

            Map<String, Object> vndMap = new HashMap<String, Object>();
            vndMap.put("VENDOR_CD",   formData.get("VENDOR_CD"));
            vndMap.put("VENDOR_NM",   formData.get("VENDOR_NM"));
            vndMap.put("CONT_NUM",    formData.get("CONT_NUM"));
            vndMap.put("CONT_CNT",    formData.get("CONT_CNT"));
            vndMap.put("APP_DOC_NUM", formData.get("APP_DOC_NUM"));
            vndMap.put("APP_DOC_CNT", formData.get("APP_DOC_CNT"));
            vndList.add(vndMap);

            // 부서식 처리
            for (int i = 0; i < gridDataA.size(); i++) {
                Map<String, Object> datum = gridDataA.get(i);
                datum.put("CONT_NUM", formData.get("CONT_NUM"));
                datum.put("CONT_CNT", formData.get("CONT_CNT"));
                
                String subLargeTextNum  = (String) datum.get("CONTRACT_TEXT_NUM");
                if( EverString.isEmpty(EverString.replace(subLargeTextNum, " ", "")) ){
                    subLargeTextNum = docNumService.getDocNumber(userInfo.getCompanyCd(), "TN");
                    datum.put("CONTRACT_TEXT_NUM", subLargeTextNum);
                } else {
                    datum.put("CONTRACT_TEXT_NUM", subLargeTextNum);
                }

                cctr0020_Mapper.ccta0030_doInsertAddECRL(datum);
            }
        }

        // 협력사 데이터에 계약번호 넣은 후 리턴
        rtnData.putAll(formData);
        rtnData.put("gridDataV", vndList);

        return rtnData;
    }
    
    /**
     * 위수탁계약서 등 다수계약서 계약Header정보 가져오기
     * @param req
     * @param resp
     * @param parameterMap
     */
    public void ccta0040_getBundleContractInfo(EverHttpRequest req, EverHttpResponse resp, Map<String, String> parameterMap) {
    	
    	UserInfo userInfo = UserInfoManager.getUserInfo();
    	
        // 일괄계약번호
        String bundleNum = EverString.nullToEmptyString(parameterMap.get("BUNDLE_NUM"));
        String appDocNum = EverString.nullToEmptyString(parameterMap.get("APP_DOC_NUM"));
        String appDocCnt = EverString.nullToEmptyString(parameterMap.get("APP_DOC_CNT"));
        
        Map<String, String> bundleContractInfo = new HashMap<String, String>();
        bundleContractInfo.putAll(parameterMap);
        
        String progressCd   = "";
        String contractForm = "";
        if( !"".equals(bundleNum) || !("".equals(appDocNum) && "".equals(appDocCnt))) {
            bundleContractInfo = cctr0020_Mapper.ccta0040_getBundleContractInfo(bundleContractInfo);
            
            progressCd = bundleContractInfo.get("PROGRESS_CD");
            // 결재상신 후 수정 불가능
            if( Integer.parseInt(progressCd) > 4200 ){
                contractForm = ContStringUtil.getHtmlContents(bundleContractInfo.get("CONTRACT_TEXT"),true);
            }
            bundleContractInfo.put("formContents", contractForm);
        }
        else {
        	bundleContractInfo.put("PR_BUYER_CD", userInfo.getCompanyCd());
        	bundleContractInfo.put("PR_DEPT_CD", userInfo.getDeptCd());
        	bundleContractInfo.put("PR_BUYER_DEPT_NM", userInfo.getCompanyNm() + " " + userInfo.getDeptNm());
        }
        bundleContractInfo.put("reCont", parameterMap.get("reCont"));
        
        req.setAttribute("form", bundleContractInfo);
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public void ccta0040_doDeleteContract(Map<String, String> formData, List<Map<String, Object>> gridV) throws Exception {
        for(Map<String, Object> grid : gridV) {
            Map<String, String> param = new HashMap<>();
            param.put("CONT_NUM", (String)grid.get("CONT_NUM"));
            param.put("CONT_CNT", String.valueOf(grid.get("CONT_CNT")));
            param.put("VENDOR_CD", (String) grid.get("VENDOR_CD"));
            
            if (formData.get("CONT_TYPE").equals("1120")) {
                param.put("PR_BUYER_CD", formData.get("VENDOR_CD"));
            } else {
                param.put("PR_BUYER_CD", formData.get("PR_BUYER_CD"));
            }
            param.put("PR_DEPT_CD", formData.get("PR_DEPT_CD"));
            
            String progressCd = cctr0020_Mapper.ccta0040_isDeleteBundleFlag(param);
            if( EverString.isNotEmpty(progressCd) && Integer.parseInt(progressCd) > 4200 ){
                throw new Exception("계약서를 삭제할 수 없는 상태입니다.\n진행상태를 다시 확인해주세요.");
            }
            
            cctr0020_Mapper.ccta0030_doDeleteECRL(param); // 계약서식정보
            cctr0020_Mapper.ccta0030_doDeleteECCT(param); // 계약기본정보
            cctr0020_Mapper.ccta0040_doDeleteECCM(param); // 고객사정보
        }
    }

    // 일괄계약서 결재상신 후 처리
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public Map<String, String> ccta0040_doReqSign(Map<String, String> dataForm, List<Map<String, Object>> gridDataM, List<Map<String, Object>> gridDataA, List<Map<String, Object>> gridDataV) throws Exception {

        UserInfo userInfo = UserInfoManager.getUserInfo();

        // 1. 임시저장(4200)으로 등록
        Map<String, Object> formData = ccta0040_doSaveBundleContract(dataForm, gridDataM, gridDataA, gridDataV);
        
        // 2. 결재상신 후 진행상태 및 결재상태 변경
        Map<String, String> param = new HashMap<String, String>();
        param.put("BUNDLE_NUM", (String)formData.get("BUNDLE_NUM"));
        param.put("PROGRESS_CD", Code.M135_4206);
        param.put("SIGN_STATUS", Code.M020_P);
        cctr0020_Mapper.ccta0040_doUpdateECCTSignStatus(param);

        List<Map<String, Object>> vndList = (List<Map<String, Object>>) formData.get("gridDataV");
        for (Map<String, Object> rowData : vndList) {
            String appDocNum = String.valueOf(rowData.get("APP_DOC_NUM"));
            String appDocCnt = String.valueOf(rowData.get("APP_DOC_CNT"));

            if( EverString.isEmpty(appDocNum) || "null".equals(appDocNum)){
                dataForm.put("APP_DOC_NUM", docNumService.getDocNumber(userInfo.getCompanyCd(),"APPDOC"));
            }

            if( EverString.isEmpty(appDocCnt) || "null".equals(appDocCnt) || appDocCnt.equals("0") ){
                appDocCnt = "1";
            } else {
                appDocCnt = String.valueOf(Integer.parseInt(appDocCnt) + 1);
            }

            dataForm.put("APP_DOC_CNT", appDocCnt);
            dataForm.put("DOC_TYPE", "EC2");
            dataForm.put("SUBJECT", "[" + rowData.get("VENDOR_NM") + "] " + dataForm.get("CONT_DESC"));
            dataForm.put("REL_TEXT_NUM", dataForm.get("CONTRACT_TEXT_NUM"));
            dataForm.put("BUYER_CD", userInfo.getCompanyCd());
            // 일괄계약의 계약번호는 협력사별로 체번한 것을 사용함
            dataForm.put("CONT_NUM", (String)rowData.get("CONT_NUM"));
            dataForm.put("CONT_CNT", String.valueOf(rowData.get("CONT_CNT")));

            String strApprovalFormData = dataForm.get("approvalFormData");
            String strApprovalGridData = dataForm.get("approvalGridData");

            approvalService.doApprovalProcess(dataForm, strApprovalFormData, strApprovalGridData);
            cctr0020_Mapper.ccta0030_doUpdateApprovalInformation(dataForm);
        }

        return param;
    }

    /**
     * 일괄계약서 저장
     * @param formData  화면의 폼데이터
     * @param gridDataM 주서식 그리드 데이터
     * @param gridDataA 부서식 그리드 데이터
     * @param gridDataV 협력회사 그리드 데이터
     * @return
     */
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public Map<String, Object> ccta0040_doSaveBundleContract(Map<String, String> formData, List<Map<String, Object>> gridDataM, List<Map<String, Object>> gridDataA, List<Map<String, Object>> gridDataV) throws Exception {
        return processBundleContract(Code.M135_4200, formData, gridDataM, gridDataA, gridDataV);
    }

    public List<Map<String, Object>> ccta0040_getSavedVendorListForBundleContract(Map<String, String> formData) {
        if(formData.get("CONT_TYPE").equals("1120")) {
            return cctr0020_Mapper.ccta0040_getSavedCustListForBundleContract(formData);
        } else {
            return cctr0020_Mapper.ccta0040_getSavedVendorListForBundleContract(formData);
        }
    }

    public List<Map<String, Object>> ccta0040_getVendorListForBundleContract(List<Map<String, Object>> gridVData) {
        String vendorCdList = "";
        int cnt = 1;
        for (Map<String, Object> gridVDatum : gridVData) {
            if(cnt == gridVData.size()) {
                vendorCdList += gridVDatum.get("VENDOR_CD");
            } else {
                vendorCdList += gridVDatum.get("VENDOR_CD") + ",";
            }
            cnt++;
        }

        Map<String, Object> param = new HashMap<>();
        param.put("VENDOR_CD_LIST", Arrays.asList(vendorCdList.split(",")));

        return cctr0020_Mapper.ccta0040_getVendorListForBundleContract(param);
    }

    public void cctr0051_doSave(Map<String, String> formData, List<Map<String, Object>> gridData) {
        for (Map<String, Object> grid : gridData) {
            grid.putAll(formData);
            cctr0020_Mapper.cctr0051_cctr0053_doSave(grid);
        }
    }

    public List<Map<String, Object>> ccta0040_doSearchBundelInfo(Map<String, String> formData) {
        return cctr0020_Mapper.ccta0040_doSearchBundelInfo(formData);
    }

    public void ccta0030_doUpdatePdfUUID(Map<String, Object> param) {
        cctr0020_Mapper.ccta0030_doUpdatePdfUUID(param);
    }
    
    /**
     * 2021.04.07 추가
     * 계약서작성(다수업체)인 경우 PDF_ATT_FILE_NUM은 STOCECCM에 저장한다
     * @param param
     */
    public void ccta0040_doUpdatePdfUUID(Map<String, Object> param) {
        cctr0020_Mapper.ccta0040_doUpdatePdfUUID(param);
    }

    public Map<String, String> cctr0050_doPdfFileInfo(Map<String, String> param) {
        return cctr0020_Mapper.cctr0050_doPdfFileInfo(param);
    }
    
    /**
     * 계약체결현황 (CCTR0050) > 변경계약서 작성시 체크로직
     * @param param
     * @param cont_num_cnt
     * @return
     */
    public String cctr0050_doResumeCheck2(Map<String, String> param, List<Map<String, Object>> cont_num_cnt) {
        int contCnt = 0;
        String returnStr = "0";
        for (Map<String, Object> rowData : cont_num_cnt) {
            try {
                contCnt = Integer.parseInt(String.valueOf(rowData.get("CONT_CNT"))) + 1;
            } catch (Exception e) {
                getLog().error(e.getMessage(), e);
                contCnt = 1;
            }
            rowData.put("NEW_CONT_CNT", contCnt);
            
            returnStr = cctr0020_Mapper.cctr0050_doResumeCheck(rowData);
            if (returnStr.equals("0")) {
                continue;
            } else {
                return returnStr;
            }
        }
        
        return returnStr;
    }

    public void ccta0030_doUpdateEformJsonData(Map<String, String> param) {
        cctr0020_Mapper.ccta0030_doUpdateEformJsonData(param);
    }

	public String ccta0030_doSelectEformJsonData(Map<String, String> formData) {
		return cctr0020_Mapper.ccta0030_doSelectEformJsonData(formData); 
	}
	 
    public List<Map<String, Object>> ccta0030_doSearchPdfNum(Map<String, String> parameterMap) {
		return  cctr0020_Mapper.ccta0030_doSearchPdfNum(parameterMap);
	}
    
    public void ccta0040_doUpdateVendorFile(Map<String, String> formData) {
        cctr0020_Mapper.ccta0040_doUpdateVendorFile(formData);
    }
    
    public List<Map<String, Object>> cctr0055_doSearch(Map<String, String> formData) {
        Map<String, Object> formObj = new HashMap<String, Object>(formData);
        return cctr0020_Mapper.cctr0055_doSearch(formObj);
    }

    
    
    
    /**
     * 다수계약 : 발주사 계약서 전자서명 (4230 => 4300)
     * @param req
     * @param resp
     * @param gridV
     * @throws Exception
     */
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public Map<String, String> cctr0050_MultiSign(EverHttpRequest req, EverHttpResponse resp, List<Map<String, Object>> gridV) throws Exception {

        String localServerFlag = EverString.nullToEmptyString(req.getParameter("localServerFlag"));
        
        String sSignDatas = EverString.nullToEmptyString(req.getParameter("signedData"));
        	   sSignDatas = URLDecoder.decode(sSignDatas, "utf-8");
        String vidRandom = EverString.nullToEmptyString(req.getParameter("vidRandom"));
        	   vidRandom = URLDecoder.decode(vidRandom, "utf-8");
        String idn       = EverString.nullToEmptyString(req.getParameter("idn"));
        String useCard   = EverString.nullToEmptyString(req.getParameter("useCard"));

        
        Map<String, String> formData = req.getFormData();
        
        
        
        System.out.println("array sSignDatas==>"+sSignDatas);
        
    	Object jsonMultiObject  = null;
    	jsonMultiObject = (new JSONParser()).parse(sSignDatas);
    	JSONArray	obj = (JSONArray)jsonMultiObject;      
    	
    	System.out.println("array sSignDatas size()==>"+obj.size());
        
        int loopCnt = 0;
         
        for( Map<String, Object> grid : gridV ) {    
        	String sSignData = "";    
        	sSignData = obj.get(loopCnt).toString();
        	loopCnt ++;
        	
        	//컨버전
        	formData.put("CONT_TYPE", grid.get("CONT_TYPE").toString());
        	//formData.put("FORM_NUM", grid.get("FORM_NUM").toString());    // 쓰는 곳이 안보임
        	formData.put("PR_BUYER_CD", grid.get("PR_BUYER_CD").toString());
        	formData.put("PR_DEPT_CD", grid.get("PR_DEPT_CD").toString());
        	formData.put("VENDOR_ATT_FILE_NUM", grid.get("VENDOR_ATT_FILE_NUM").toString());
        	formData.put("BUYER_CD", grid.get("BUYER_CD").toString());
        	
        	
	        // 운영서버에서만 서명값 검증을 진행함
	        if( "N".equals(localServerFlag) ) {
	            Map<String, String> rtnMap = EverCert.doCheckCert(sSignData, vidRandom, idn, useCard);
	            // 서명값 검증 실패
	            if (rtnMap != null && rtnMap.get("certRtnCd").equals("-1")) {
	                throw new Exception(rtnMap.get("certRtnMsg"));
	            }
	        }
	        
	        // 서명값과 원장 비교
	        JCaosCheckCert jcaosCheck = new JCaosCheckCert();
	        int iResult = jcaosCheck.checkCert(sSignData);
	        String oriSignedDataStr = ""; 
	        if (iResult == 0 || iResult == 3000) {
	        	oriSignedDataStr = jcaosCheck.getSrcStr();
	        }	        
	        
	        String oriHash = EverString.nullToEmptyString(cctr0020_Mapper.cctr0050_getHash(grid));
	        
	        System.out.println("oriSignedDataStr==>"+oriSignedDataStr);
	        System.out.println("oriHash==>"+oriHash);
	        
	        if(!oriSignedDataStr.contains(oriHash)) {
	        	throw new Exception("고객사의 서명값과 계약이 불일치 합니다"); // 위수탁계약 : 고객사 서명 검증 	
	        }
	
	        // 위수탁계약 : 협력사가 지역농축협(STOCCUST)
	        //for( Map<String, Object> grid : gridV ) {
	            // 1. 협력업체 서명 값 검증
	            Map<String, String> signChk = null;
	            if( "1120".equals(formData.get("CONT_TYPE")) ) {
	                signChk = cctr0020_Mapper.ccta0040_doSignChk(grid); // 위수탁계약서 : 고객사 서명값 가져오기
	            } else {
	                signChk = cctr0020_Mapper.ccta0030_doSignChk(grid); // 일반계약서    : 협력사 서명값 가져오기
	            }
	
	            String sSignDataChk = String.valueOf(signChk.get("SIGN_VALUE"));
	            String vidRandomChk = String.valueOf(signChk.get("VID_RANDOM"));
	            String idnChk = String.valueOf(signChk.get("IRS_NO"));
	
				/* useCard : "1" (Test용 법인용 공인인증서, 사업자 등록번호 : 2128159710)
							 "2" (Test용 법인용 블럭체인 사설인증서, 사업자 등록번호 : 1122334455)
							 "3" {Test용 개인용 블럭체인 사설인증서, 사업자 등록번호 : ""} */
	            String useCardChk = "";
	            if( "N".equals(localServerFlag) ) {
	                useCardChk = useCard;
	            }

	            boolean checkFlag = EverCert.doCheckSignedData(sSignDataChk, vidRandomChk, idnChk, useCardChk);
	            if (!checkFlag) {
	                if( formData.get("CONT_TYPE").equals("1120") ) {
	                    throw new Exception("고객사의 서명값 검증에 실패하였습니다."); // 위수탁계약 : 고객사 서명 검증
	                } else {
	                    throw new Exception("협력사의 서명값 검증에 실패하였습니다."); // 일반 계약 : 협력사 서명 검증
	                }
	            }

	            // 2. 고객사 서명 값 저장(STOCECSV)
	            grid.put("SIGN_VALUE", sSignData);
	            // 쓰는 곳이 안 보임
	            //grid.put("FORM_NUM", formData.get("FORM_NUM"));
	            grid.put("VID_RANDOM", vidRandom);
	            grid.put("USER_TYPE", "B");
	
	            Map<String, String> gridMap = (Map) grid;
	            gridMap.put("PR_BUYER_CD", formData.get("PR_BUYER_CD"));
	            gridMap.put("PR_DEPT_CD", formData.get("PR_DEPT_CD"));
	            cctr0020_Mapper.ccta0030_doInsertECSV(gridMap);
	            
	            // TSA 서명 값 검증 (위수탁계약인 경우에만 위변조 검증)
	            if( "1120".equals(formData.get("CONT_TYPE")) && "N".equals(localServerFlag)  && !"1".equals(useCard) ) {
	            	String pdfAttFileNum = String.valueOf(grid.get("PDF_ATT_FILE_NUM"));
	            	if( StringUtils.isEmpty(pdfAttFileNum) ) {
	            		throw new Exception("위변조를 확인할 계약서 파일이 없습니다.(pdfAttFileNum)"); // 위변조 확인할 계약서 파일 존재여부
	            	}
	            	
		            Map<String, String> fileInfo = fileAttachService.getFileInfo(pdfAttFileNum, null);
		            if( fileInfo != null && fileInfo.size() > 0 ) {
			            // TSA 인증 값 입히기
			            String targetDirectory = fileInfo.get("FILE_PATH");
			            String targetFileNm = fileInfo.get("UUID") + "_" + fileInfo.get("UUID_SQ") + "." + fileInfo.get("FILE_EXTENSION");
			
			            // 파일 이동 후 위변조 방지를 위해 Binary 적용
			            String binaryFile = EverFile.fileToBinary(targetDirectory, targetFileNm);
			            
			            Map<String, String> binaryMap = new HashMap<>();
			            binaryMap.put("url", PropertiesManager.getString("block.chain.verify"));
			            binaryMap.put("strFromFile", binaryFile);
			            
			            JSONObject jsonObject = EverRestJson.actionAPI(binaryMap);
			            if( !"success".equals(jsonObject.get("msg")) ) {
			                throw new Exception("계약서 파일이 변조되었습니다. 전자서명을 진행하실 수 없습니다.");
			            }
		            } else {
		            	throw new Exception("위변조를 확인할 계약서 파일정보가 없습니다.(getFileInfo)"); // 위변조 확인할 계약서 파일 존재여부
		            }
	            }
	
	            // 3. 계약체결완료(STOCECCT)로 상태 변경
	            formData.put("PROGRESS_CD", Code.M135_4300);
	            formData.put("CONT_NUM", String.valueOf(grid.get("CONT_NUM")));
	            formData.put("CONT_CNT", String.valueOf(grid.get("CONT_CNT")));
	            cctr0020_Mapper.ccta0030_doUpdateStatusOfECCT(formData);
	
	            // 발주 대기 상태의 POHD, PODT 의 값을 PROGRESS_CD = 5200(발주완료)로 상태 값 변경.
	            List<Map<String, Object>> poList = cctr0020_Mapper.ccta0030_doSearchPOList(formData);
	            for(Map<String, Object> po : poList) {
	                cctr0020_Mapper.ccta0030_doUpdatePOHD(po);
	                cctr0020_Mapper.ccta0030_doUpdatePODT(po);
	            }
	            
	            // 2021.04.19 변경
	            // 위수탁 계약의 수수료는 수탁 및 위탁사(지역농축협)에 동시에 부과함
	            if( "1120".equals(formData.get("CONT_TYPE")) ) {
		            // 2020.12.30 고객이 의뢰고객에서 계약서 작성 고객으로 변경
		            // 2020.11.25 수탁사에게 수수료부과 추가
		            // -- 계약체결 완료 후 고객 및 협력사에 수수료 부과
		        	List<Map<String, String>> paymentList = cctr0020_Mapper.getPrepaymentConsignCust(grid); 	// 위수탁계약 : 고객사 및 에 수수료 부과
		        	
		        	for( Map<String, String> paymentMap : paymentList ) {
			            paymentMap.put("EPRO_PS_DSC", "1");			// epro_ps_dsc [구매공급구분코드] - 1 : 구매, 2 : 공급
			            paymentMap.put("EPRO_WRS_DS", "60");		// epro_wrs_ds [상품코드] - 10 : RFI, 20 : 입찰, 30 : 일반입찰계약, 40 : 일반수의계약, 50 : BtoC계약, 60 : 위임계약, 70 : 문서보관, 80 : SMS, 90 : LMS, 100 : 문서생성
			            paymentMap.put("CONT_TBL_ID", "STOCECCT");	// 업무 Table명
			            // CONT_TBL_PK : 해당 Table에 Data 존재유무를 조회해볼 수 있는 Key 값. GATE_CD || '@@' || BUYER_CD || '@@' || ... 와 같이 설정.
			            paymentMap.put("tmp", ""); 					// myBatis 버그 해결을 위한 무의미한, 유니크한 값. 단, EPRO_WRS_DS = '30' 또는 '40'일 때 반드시 계약금액을 넣어야 함.
			      
			            String resultMsg = approvalService.putBkCost(paymentMap);
			            if(!resultMsg.equals("OK")) {
			            	throw new Exception(resultMsg);
			            } else {
			            	System.out.println("==========> (다수계약) 위수탁 계약 완료 후 위수탁사에 수수료 청구 : PK => " + paymentMap.get("CONT_TBL_PK") + ", CORP_NO => " + paymentMap.get("CORP_NO"));
			            }
			            
		        	}
	            }
	            
	            // 5. 발주가 생성된 경우 : 계약완료 메일 발송
	            if( poList.size() > 0 ) {
	            	try {
	                	sendMailAfterMultiSign(formData, grid);
	            	} catch (Exception ex) {
	            		getLog().error("==> 다수업체 고객사 전자서명 완료(4300) 메일&문자 발송 오류 : " + ex.getMessage(), ex);
	            	}
	            }
	        //}
        }    
        return formData;
    }    
}

