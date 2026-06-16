package com.st_ones.nosession.interfacez.web;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.st_ones.common.util.clazz.EverConverter;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.eversrm.eApproval.som.service.SomService;

/**
 * SOM 그룹웨어 연동 Callback 수신 컨트롤러
 * URL: /nheproif/somCallback
 */
@Controller
@RequestMapping(value = "/nheproif")
public class SomController extends BaseController {

    @Autowired
    private SomService somService;

    @RequestMapping("/somCallback")
    public void somCallback(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        resp.setContentType("application/json;charset=UTF-8");
        
        // 1. API Key 인증 확인
        String apiKeyHeader = req.getHeader("X-API-KEY");
        String configApiKey = PropertiesManager.getString("som.approval.api.key", "ever-som-secret-key-2026");
        
        Map<String, String> resultMap = new HashMap<>();
        
        if (apiKeyHeader == null || !apiKeyHeader.equals(configApiKey)) {
            resultMap.put("RESULT_YN", "N");
            resultMap.put("RESULT_MSG", "Unauthorized - Invalid API Key");
            resp.setStatus(EverHttpResponse.SC_UNAUTHORIZED);
            resp.getWriter().write(EverConverter.getJsonString(resultMap));
            return;
        }

        // 2. 수신 데이터 파싱 및 처리
        String sendData = req.getParameter("SEND_DATA");
        Map<String, Object> callbackDataMap = null;
        
        try {
            if (sendData == null || sendData.trim().isEmpty()) {
                // 파라미터가 없으면 Request Body에서 읽기 시도
                java.io.BufferedReader reader = req.getReader();
                StringBuilder sb = new StringBuilder();
                String line;
                while ((line = reader.readLine()) != null) {
                    sb.append(line);
                }
                sendData = sb.toString();
            }
            
            callbackDataMap = EverConverter.readJsonObject(sendData, Map.class);
            
            if (callbackDataMap == null) {
                throw new Exception("수신된 결재 데이터가 비어있거나 올바르지 않습니다.");
            }
            
            // SOM 결재 결과 비즈니스 로직 적용
            somService.receiveSomApprovalStatus(callbackDataMap);
            
            resultMap.put("RESULT_YN", "Y");
            resultMap.put("RESULT_MSG", "SUCCESS");
        } catch (Exception e) {
            getLog().error("SOM Callback Processing Error: " + e.getMessage(), e);
            resultMap.put("RESULT_YN", "N");
            resultMap.put("RESULT_MSG", "FAIL: " + e.getMessage());
            resp.setStatus(EverHttpResponse.SC_INTERNAL_SERVER_ERROR);
        }
        
        resp.getWriter().write(EverConverter.getJsonString(resultMap));
        getLog().info("========================= SOM INTERFACE CALLBACK END ================================");
    }
}
