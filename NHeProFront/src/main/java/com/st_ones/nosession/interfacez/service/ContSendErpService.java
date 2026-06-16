package com.st_ones.nosession.interfacez.service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.st_ones.common.util.clazz.EverConverter;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.nosession.interfacez.ContSendErp_Mapper;


@Service
public class ContSendErpService extends BaseService {

    @Autowired
    ContSendErp_Mapper contsenderpMapper;

    public void sendErp(Map<String,Object> param) throws Exception {
        if (param == null) {
            throw new Exception("파라미터가 유효하지 않습니다.");
        }

    	String pURL = PropertiesManager.getString("eversrm.erp.url");
        if (pURL == null || pURL.isEmpty()) {
            throw new Exception("eversrm.erp.url 설정이 필요합니다.");
        }

    	URL url = new URL(pURL);
    	HttpURLConnection http = (HttpURLConnection)url.openConnection();
        try {
            http.setDefaultUseCaches(false);
            http.setDoInput(true);
            http.setDoOutput(true);
            http.setRequestMethod("POST");
            http.setRequestProperty("content-type", "application/x-www-form-urlencoded");

            String paramstr = "SEND_DATA=" + java.net.URLEncoder.encode(makeData(param), "EUC-KR");
            
            try (OutputStreamWriter outStream = new OutputStreamWriter(http.getOutputStream(), "EUC-KR");
                 PrintWriter wr = new PrintWriter(outStream)) {
                wr.write(paramstr);
                wr.flush();
            }

            StringBuilder builder = new StringBuilder();
            try (InputStreamReader tmp = new InputStreamReader(http.getInputStream(), "EUC-KR");
                 BufferedReader reader = new BufferedReader(tmp)) {
                String str;
                while ((str = reader.readLine()) != null) {
                    builder.append(str);
                }
            }
            
            String result = builder.toString();
            Map<String,Object> resultMap = EverConverter.readJsonObject(result, Map.class);
            if (resultMap == null) {
                throw new Exception("응답 데이터가 올바르지 않습니다. (result=" + result + ")");
            }

            if ("Y".equals(resultMap.get("RESULT_YN"))) {
                contsenderpMapper.erpSendComplete(param);
            } else {
                if (resultMap.get("RESULT_MSG") != null) {
                    throw new Exception(resultMap.get("RESULT_MSG").toString());
                } else {
                    throw new Exception("result=" + result);
                }
            }
        } finally {
            http.disconnect();
        }
    }

	public String makeData(Map<String,Object> param) throws Exception {
        if (param == null) {
            throw new Exception("파라미터가 유효하지 않습니다.");
        }

		Map<String,String> result = contsenderpMapper.getContData(param);

		if (result == null) throw new Exception("계약서 정보가 존재하지 않습니다.");

		Map<String,String> jsonMap = new HashMap<String,String>();
        String[] keys = {
            "CODE_COMPANY", "CODE_PROJECT", "NO_CONTRACT", "NM_CONTRACT", "CODE_CUST_CONTRACT",
            "GBN_GEORAE_CONTRACT", "CODE_CONTRACT_TYPE", "CODE_CONTRACT_METHOD", "CODE_CONTRACT_AMT",
            "AMT_CONTRACT", "AMT_CONTRACT_VAT", "DT_CONTRACT", "ID_CHARGE_CONTRACT", "DT_CONTRACT_ST",
            "DT_CONTRACT_ED", "DT_FIXDEFECT_ST", "DT_FIXDEFECT_ED", "RATE_FIXDEFECT", "RATE_DELAY",
            "NOTE_DELAY", "AS_MONTH", "AS_START_COND", "NM_CHARGE_PHASE", "NO_MOBILE", "EMAIL_ADDR",
            "ID_SEUNGIN", "STATUS", "DTM_SEUNGIN", "NOTE_ETC", "SAYU_RETURN", "CODE_PROJECT_PRE",
            "CODE_STATUS_LED", "ID_REG", "DTM_REG", "ID_UPT", "DTM_UPT", "AMT_EST", "AMT_EST_VAT",
            "GBN_MANAGE_CONTRACT", "CODE_BID_METHOD", "RATE_DC_CONTRACT", "CODE_PROJECT_TP",
            "CODE_OUTPUT_WAY", "DTM_CHG", "DTM_FIX", "ID_FIX", "CHASU_RE_SAUP_VAL"
        };
        
        for (String key : keys) {
            String val = result.get(key);
            jsonMap.put(key, val == null ? "" : val);
        }

		Map<String,Object> mam = new HashMap<String,Object>();
		mam.put("MST", new ArrayList<Map<String,String>>());
		List<Map<String,String>> det = new ArrayList<Map<String,String>>();
		det.add(jsonMap);
		mam.put("DET", det);

		return EverConverter.getJsonString(mam);
	}

    // [고도화변경] 2026.06.16 NH-ERP 대금정산 완료 정보 수신 및 STOCECPC 반영 비즈니스 로직 구현
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public void recvErpPay_doSave(Map<String, Object> param) throws Exception {
        if (param == null) {
            throw new Exception("파라미터가 유효하지 않습니다.");
        }

        List<Map<String, Object>> payList = null;
        Object mstData = param.get("MSTDATA");
        if (mstData instanceof List) {
            payList = (List<Map<String, Object>>) mstData;
        } else if (mstData instanceof String) {
            payList = EverConverter.readJsonObject((String) mstData, List.class);
        } else if (mstData != null) {
            payList = EverConverter.readJsonObject(EverConverter.getJsonString(mstData), List.class);
        } else {
            Object detData = param.get("DET");
            if (detData instanceof List) {
                payList = (List<Map<String, Object>>) detData;
            } else if (detData instanceof String) {
                payList = EverConverter.readJsonObject((String) detData, List.class);
            } else if (detData != null) {
                payList = EverConverter.readJsonObject(EverConverter.getJsonString(detData), List.class);
            }
        }

        if (payList == null || payList.isEmpty()) {
            throw new Exception("저장할 대금 정산 정보가 존재하지 않습니다.");
        }

        for (Map<String, Object> record : payList) {
            String gateCd   = record.get("GATE_CD") == null ? "" : String.valueOf(record.get("GATE_CD")).trim();
            String buyerCd  = record.get("BUYER_CD") == null ? "" : String.valueOf(record.get("BUYER_CD")).trim();
            String contNum  = record.get("CONT_NUM") == null ? "" : String.valueOf(record.get("CONT_NUM")).trim();
            String contCnt  = record.get("CONT_CNT") == null ? "" : String.valueOf(record.get("CONT_CNT")).trim();
            String payCnt   = record.get("PAY_CNT") == null ? "" : String.valueOf(record.get("PAY_CNT")).trim();
            String pyBuyerCd = record.get("PY_BUYER_CD") == null ? "" : String.valueOf(record.get("PY_BUYER_CD")).trim();
            String pyDeptCd = record.get("PY_DEPT_CD") == null ? "" : String.valueOf(record.get("PY_DEPT_CD")).trim();

            if (gateCd.isEmpty() || buyerCd.isEmpty() || contNum.isEmpty() || contCnt.isEmpty() || payCnt.isEmpty() || pyBuyerCd.isEmpty() || pyDeptCd.isEmpty()) {
                throw new Exception("필수 파라미터가 누락되었습니다. (GATE_CD, BUYER_CD, CONT_NUM, CONT_CNT, PAY_CNT, PY_BUYER_CD, PY_DEPT_CD)");
            }

            // 만약 PR_BUYER_CD, PR_DEPT_CD, VENDOR_CD가 누락된 경우 STOCECCM에서 가져옴
            String prBuyerCd = record.get("PR_BUYER_CD") == null ? "" : String.valueOf(record.get("PR_BUYER_CD")).trim();
            String prDeptCd  = record.get("PR_DEPT_CD") == null ? "" : String.valueOf(record.get("PR_DEPT_CD")).trim();
            String vendorCd  = record.get("VENDOR_CD") == null ? "" : String.valueOf(record.get("VENDOR_CD")).trim();

            if (prBuyerCd.isEmpty() || prDeptCd.isEmpty() || vendorCd.isEmpty()) {
                Map<String, Object> queryMap = new HashMap<String, Object>();
                queryMap.put("GATE_CD", gateCd);
                queryMap.put("BUYER_CD", buyerCd);
                queryMap.put("CONT_NUM", contNum);
                queryMap.put("CONT_CNT", contCnt);
                Map<String, String> eccmInfo = contsenderpMapper.getEccmInfo(queryMap);
                if (eccmInfo != null) {
                    if (prBuyerCd.isEmpty()) prBuyerCd = eccmInfo.get("PR_BUYER_CD");
                    if (prDeptCd.isEmpty()) prDeptCd = eccmInfo.get("PR_DEPT_CD");
                    if (vendorCd.isEmpty()) vendorCd = eccmInfo.get("VENDOR_CD");
                }
            }

            record.put("PR_BUYER_CD", prBuyerCd);
            record.put("PR_DEPT_CD", prDeptCd);
            record.put("VENDOR_CD", vendorCd);
            record.put("USER_ID", "SYSTEM");

            int exists = contsenderpMapper.checkEcpcExists(record);
            if (exists > 0) {
                contsenderpMapper.updateEcpc(record);
            } else {
                contsenderpMapper.insertEcpc(record);
            }
        }
    }

}