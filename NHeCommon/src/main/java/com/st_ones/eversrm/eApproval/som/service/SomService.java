package com.st_ones.eversrm.eApproval.som.service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.st_ones.common.util.clazz.EverConverter;
import com.st_ones.common.util.service.LargeTextService;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.eversrm.eApproval.service.EndApprovalService;
import com.st_ones.eversrm.eApproval.som.SomMapper;

@Service("somService")
public class SomService extends BaseService {

    private final Logger logger = LoggerFactory.getLogger(SomService.class);

    @Autowired
    private SomMapper somMapper;

    @Autowired
    private EndApprovalService endApprovalService;

    @Autowired
    private LargeTextService largeTextService;

    /**
     * ePro -> SOM 결재상신 REST API 호출
     */
    public Map<String, Object> sendSomApproval(Map<String, String> docInfo, Map<String, String> approvalHeader) throws Exception {
        Map<String, Object> returnMap = new HashMap<>();
        
        // 1. SOM 연동 활성화 여부 체크
        boolean isSomEnabled = PropertiesManager.getBoolean("som.approval.integration.flag", true);
        if (!isSomEnabled) {
            returnMap.put("RESULT_YN", "Y");
            returnMap.put("RESULT_MSG", "SOM 연동 비활성화 모드 (로컬 처리)");
            return returnMap;
        }

        String somUrlStr = PropertiesManager.getString("som.approval.url", "http://som-gateway-host/som/api/requestApproval");
        String apiKey = PropertiesManager.getString("som.approval.api.key", "ever-som-secret-key-2026");

        // 2. 전송할 10종 데이터 매핑 객체 구성
        Map<String, Object> requestBody = new HashMap<>();
        requestBody.put("appDocNum", docInfo.get("APP_DOC_NUM"));
        requestBody.put("appDocCnt", docInfo.get("APP_DOC_CNT"));
        requestBody.put("docType", docInfo.get("DOC_TYPE"));
        requestBody.put("buyerCd", docInfo.get("BUYER_CD"));
        requestBody.put("subject", approvalHeader.get("SUBJECT"));
        requestBody.put("draftUserId", approvalHeader.get("REG_USER_ID"));
        requestBody.put("draftUserName", approvalHeader.get("REG_USER_NM"));
        
        // 기안자 부서명 가져오기
        String deptName = approvalHeader.get("REG_DEPT_NM");
        if (deptName == null || deptName.isEmpty()) {
            deptName = somMapper.getUserDeptName(approvalHeader);
        }
        requestBody.put("draftDeptName", deptName != null ? deptName : "");
        requestBody.put("draftDate", new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new java.util.Date()));
        
        // HTML 본문 생성 (문서유형과 결재번호를 통해 테이블 조회 후 생성)
        String htmlContent = makeApprovalHtml(docInfo.get("DOC_TYPE"), docInfo.get("APP_DOC_NUM"), docInfo.get("APP_DOC_CNT"));
        requestBody.put("docHtml", htmlContent != null ? htmlContent : "");

        String jsonPayload = EverConverter.getJsonString(requestBody);

        // 3. HttpURLConnection을 이용해 REST API 호출 (API Key 인증 헤더 적용)
        URL url = new URL(somUrlStr);
        HttpURLConnection httpConn = (HttpURLConnection) url.openConnection();
        try {
            httpConn.setDefaultUseCaches(false);
            httpConn.setDoInput(true);
            httpConn.setDoOutput(true);
            httpConn.setRequestMethod("POST");
            httpConn.setRequestProperty("Content-Type", "application/json;charset=UTF-8");
            httpConn.setRequestProperty("X-API-KEY", apiKey);

            try (OutputStreamWriter writer = new OutputStreamWriter(httpConn.getOutputStream(), "UTF-8");
                 PrintWriter wr = new PrintWriter(writer)) {
                wr.write(jsonPayload);
                wr.flush();
            }

            int responseCode = httpConn.getResponseCode();
            StringBuilder responseBuilder = new StringBuilder();
            try (InputStreamReader isr = new InputStreamReader(
                    responseCode >= 200 && responseCode < 300 ? httpConn.getInputStream() : httpConn.getErrorStream(), "UTF-8");
                 BufferedReader reader = new BufferedReader(isr)) {
                String line;
                while ((line = reader.readLine()) != null) {
                    responseBuilder.append(line);
                }
            }

            String responseStr = responseBuilder.toString();
            logger.info("SOM Response Code: {}, Body: {}", responseCode, responseStr);

            if (responseCode == 200 || responseCode == 201) {
                Map<String, Object> resultMap = EverConverter.readJsonObject(responseStr, Map.class);
                if (resultMap != null && "Y".equals(resultMap.get("RESULT_YN"))) {
                    // SOM 연동 완료 성공 로그 업데이트 등
                    Map<String, Object> logParam = new HashMap<>();
                    logParam.put("GATE_CD", docInfo.get("GATE_CD"));
                    logParam.put("BUYER_CD", docInfo.get("BUYER_CD"));
                    logParam.put("APP_DOC_NUM", docInfo.get("APP_DOC_NUM"));
                    logParam.put("APP_DOC_CNT", docInfo.get("APP_DOC_CNT"));
                    logParam.put("SOM_APP_ID", resultMap.get("SOM_APP_ID"));
                    logParam.put("STATUS", "SUCCESS");
                    
                    somMapper.insertSomInterfaceLog(logParam);
                    
                    returnMap.put("RESULT_YN", "Y");
                    returnMap.put("RESULT_MSG", "SUCCESS");
                } else {
                    String msg = resultMap != null && resultMap.get("RESULT_MSG") != null ? (String) resultMap.get("RESULT_MSG") : "Unknown Error";
                    throw new Exception("SOM API 응답 실패: " + msg);
                }
            } else {
                throw new Exception("SOM HTTP 연동 에러 (HTTP Status Code: " + responseCode + ", Response: " + responseStr + ")");
            }
        } finally {
            httpConn.disconnect();
        }
        return returnMap;
    }

    /**
     * SOM 결재 결과 Callback 수신 처리
     */
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public void receiveSomApprovalStatus(Map<String, Object> callbackData) throws Exception {
        if (callbackData == null) {
            throw new Exception("Callback 데이터가 유효하지 않습니다.");
        }

        String appDocNum = (String) callbackData.get("appDocNum");
        String appDocCnt = (String) callbackData.get("appDocCnt");
        String somAppId = (String) callbackData.get("somAppId");
        String signStatus = (String) callbackData.get("signStatus"); // P(진행), E(승인), R(반려), C(취소)
        String signUserId = (String) callbackData.get("signUserId");
        String signUserName = (String) callbackData.get("signUserName");
        String signRmk = (String) callbackData.get("signRmk");

        if (appDocNum == null || appDocCnt == null || signStatus == null) {
            throw new Exception("필수 Callback 정보가 누락되었습니다. (appDocNum, appDocCnt, signStatus)");
        }

        // 1. ePro 결재문서 헤더 정보 가져오기
        Map<String, String> queryParam = new HashMap<>();
        queryParam.put("APP_DOC_NUM", appDocNum);
        queryParam.put("APP_DOC_CNT", appDocCnt);
        
        Map<String, String> sctmInfo = somMapper.selectSTOCSCTM(queryParam);
        if (sctmInfo == null) {
            throw new Exception("해당 ePro 결재 문서가 존재하지 않습니다. (문서번호: " + appDocNum + ", 차수: " + appDocCnt + ")");
        }
        
        String buyerCd = sctmInfo.get("BUYER_CD");
        String docType = sctmInfo.get("DOC_TYPE");
        String regUserId = sctmInfo.get("REG_USER_ID");

        // 2. STOCSCTM (결재 마스터) 및 STOCSCTP (결재 상세) 상태 업데이트
        Map<String, Object> updateParam = new HashMap<>();
        updateParam.put("APP_DOC_NUM", appDocNum);
        updateParam.put("APP_DOC_CNT", appDocCnt);
        updateParam.put("SIGN_STATUS", signStatus);
        updateParam.put("MOD_USER_ID", signUserId != null ? signUserId : "SOM_GW");
        
        somMapper.updateSTOCSCTM(updateParam);

        // 결재 상세 라인 상태 업데이트
        Map<String, Object> detailParam = new HashMap<>();
        detailParam.put("APP_DOC_NUM", appDocNum);
        detailParam.put("APP_DOC_CNT", appDocCnt);
        detailParam.put("SIGN_STATUS", signStatus);
        detailParam.put("SIGN_USER_ID", signUserId != null ? signUserId : "SOM_GW");
        detailParam.put("SIGN_RMK", signRmk != null ? signRmk : "");
        
        somMapper.updateSTOCSCTP(detailParam);

        // 연동 로그 이력 갱신
        Map<String, Object> logParam = new HashMap<>();
        logParam.put("APP_DOC_NUM", appDocNum);
        logParam.put("APP_DOC_CNT", appDocCnt);
        logParam.put("SOM_APP_ID", somAppId);
        logParam.put("STATUS", signStatus);
        
        somMapper.updateSomInterfaceLog(logParam);

        // 3. 최종 결재 상태에 따른 ePro 비즈니스 후속 작업 처리 (endApprovalService)
        if ("E".equals(signStatus)) {
            // 승인완료 후속 처리
            endApprovalService.doAfterApprove(docType, buyerCd, appDocNum, appDocCnt, regUserId);
        } else if ("R".equals(signStatus)) {
            // 반려 후속 처리
            endApprovalService.doAfterReject(docType, buyerCd, appDocNum, appDocCnt, regUserId);
        } else if ("C".equals(signStatus)) {
            // 상신취소 후속 처리
            endApprovalService.doAfterCancel(docType, buyerCd, appDocNum, appDocCnt);
        }
    }

    /**
     * 문서유형(docType) 및 결재문서번호(appDocNum)로 업무 테이블 데이터를 조회하여 HTML 본문을 동적으로 생성함.
     */
    private String makeApprovalHtml(String docType, String appDocNum, String appDocCnt) {
        StringBuilder html = new StringBuilder();
        html.append("<html><head><style>");
        html.append("table { border-collapse: collapse; width: 100%; margin-top: 10px; }");
        html.append("th, td { border: 1px solid #dddddd; text-align: left; padding: 8px; font-size: 12px; }");
        html.append("th { background-color: #f2f2f2; }");
        html.append("</style></head><body>");

        Map<String, String> param = new HashMap<>();
        param.put("APP_DOC_NUM", appDocNum);
        param.put("APP_DOC_CNT", appDocCnt);

        try {
            if ("PR".equals(docType)) {
                java.util.List<Map<String, Object>> prItems = somMapper.selectPrData(param);
                if (prItems != null && !prItems.isEmpty()) {
                    Map<String, Object> first = prItems.get(0);
                    html.append("<h3>[구매의뢰 결재상신]</h3>");
                    html.append("<p><b>구매의뢰번호:</b> ").append(first.get("PR_NUM") != null ? first.get("PR_NUM") : "").append("</p>");
                    html.append("<p><b>제목:</b> ").append(first.get("SUBJECT") != null ? first.get("SUBJECT") : "").append("</p>");
                    html.append("<p><b>총금액:</b> ").append(first.get("PR_AMT") != null ? first.get("PR_AMT") : "0").append(" 원</p>");
                    
                    html.append("<table><tr><th>품목코드</th><th>품목명</th><th>수량</th><th>단가</th><th>금액</th></tr>");
                    for (Map<String, Object> item : prItems) {
                        html.append("<tr>");
                        html.append("<td>").append(item.get("ITEM_CD") != null ? item.get("ITEM_CD") : "").append("</td>");
                        html.append("<td>").append(item.get("ITEM_DESC") != null ? item.get("ITEM_DESC") : "").append("</td>");
                        html.append("<td>").append(item.get("QTY") != null ? item.get("QTY") : "0").append("</td>");
                        html.append("<td>").append(item.get("UNIT_PRC") != null ? item.get("UNIT_PRC") : "0").append("</td>");
                        html.append("<td>").append(item.get("AMT") != null ? item.get("AMT") : "0").append("</td>");
                        html.append("</tr>");
                    }
                    html.append("</table>");
                } else {
                    html.append("<p>구매의뢰 정보가 존재하지 않습니다.</p>");
                }
            } else if ("PO".equals(docType)) {
                java.util.List<Map<String, Object>> poItems = somMapper.selectPoData(param);
                if (poItems != null && !poItems.isEmpty()) {
                    Map<String, Object> first = poItems.get(0);
                    html.append("<h3>[발주 결재상신]</h3>");
                    html.append("<p><b>발주번호:</b> ").append(first.get("PO_NUM") != null ? first.get("PO_NUM") : "").append("</p>");
                    html.append("<p><b>제목:</b> ").append(first.get("SUBJECT") != null ? first.get("SUBJECT") : "").append("</p>");
                    html.append("<p><b>총발주금액:</b> ").append(first.get("PO_AMT") != null ? first.get("PO_AMT") : "0").append(" 원</p>");
                    
                    html.append("<table><tr><th>품목코드</th><th>품목명</th><th>수량</th><th>단가</th><th>금액</th></tr>");
                    for (Map<String, Object> item : poItems) {
                        html.append("<tr>");
                        html.append("<td>").append(item.get("ITEM_CD") != null ? item.get("ITEM_CD") : "").append("</td>");
                        html.append("<td>").append(item.get("ITEM_DESC") != null ? item.get("ITEM_DESC") : "").append("</td>");
                        html.append("<td>").append(item.get("QTY") != null ? item.get("QTY") : "0").append("</td>");
                        html.append("<td>").append(item.get("UNIT_PRC") != null ? item.get("UNIT_PRC") : "0").append("</td>");
                        html.append("<td>").append(item.get("AMT") != null ? item.get("AMT") : "0").append("</td>");
                        html.append("</tr>");
                    }
                    html.append("</table>");
                } else {
                    html.append("<p>발주 정보가 존재하지 않습니다.</p>");
                }
            } else {
                // 기본 결재 정보로 HTML 생성
                Map<String, String> sctm = somMapper.selectSTOCSCTM(param);
                if (sctm != null) {
                    html.append("<h3>[일반 결재상신]</h3>");
                    html.append("<p><b>결재문서번호:</b> ").append(appDocNum).append("</p>");
                    html.append("<p><b>문서유형:</b> ").append(docType).append("</p>");
                    html.append("<p><b>제목:</b> ").append(sctm.get("SUBJECT") != null ? sctm.get("SUBJECT") : "").append("</p>");
                    // HTML 본문 내용 가져오기
                    String content = largeTextService.selectLargeText(sctm.get("CONTENTS_TEXT_NUM"));
                    html.append("<div>").append(content != null ? content : "").append("</div>");
                } else {
                    html.append("<p>결재 문서 정보가 존재하지 않습니다.</p>");
                }
            }
        } catch (Exception e) {
            logger.error("HTML 본문 생성 중 에러 발생: " + e.getMessage(), e);
            html.append("<p>HTML 본문 생성 에러: ").append(e.getMessage()).append("</p>");
        }

        html.append("</body></html>");
        return html.toString();
    }
}
