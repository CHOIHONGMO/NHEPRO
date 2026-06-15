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

import com.fasterxml.jackson.databind.ObjectMapper;
import com.st_ones.common.util.clazz.EverConverter;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.nosession.interfacez.ContSendErp_Mapper;


@Service
public class ContSendErpService extends BaseService {

    @Autowired
    ContSendErp_Mapper contsenderpMapper;

    public void sendErp(Map<String,Object> param) throws Exception {

    	String pURL = PropertiesManager.getString("eversrm.erp.url");;

    	URL url = new URL(pURL);
    	HttpURLConnection http = (HttpURLConnection)url.openConnection();
    	http.setDefaultUseCaches(false);
    	http.setDoInput(true);
    	http.setDoOutput(true);
    	http.setRequestMethod("POST");
    	http.setRequestProperty("content-type", "application/x-www-form-urlencoded");

    	String paramstr = "SEND_DATA="+makeData(param);
//    	System.err.println("===========================paramstr="+paramstr);
    	OutputStreamWriter outStream = new OutputStreamWriter(http.getOutputStream(),"EUC-KR");
    	PrintWriter wr = new PrintWriter(outStream);
    	wr.write(paramstr);
    	wr.flush();

    	InputStreamReader tmp = new InputStreamReader(http.getInputStream(),"EUC-KR");
    	BufferedReader reader = new BufferedReader(tmp);
    	StringBuilder builder = new StringBuilder();
    	String str = "";
    	while((str = reader.readLine()) != null) {
    		builder.append(str);
    	}
    	String result = builder.toString();
//    	System.err.println("==========================result="+result);
    	Map<String,Object> resultMap = EverConverter.readJsonObject(result, Map.class);
//    	System.err.println("==========================resultMap="+resultMap);

//    	System.err.println("==========================22222="+resultMap.get("RESULT_MSG"));

    	if("Y".equals(resultMap.get("RESULT_YN"))) {
    	   	contsenderpMapper.erpSendComplete(param);
    	} else {//RESULT_MSG
    		if (resultMap.get("RESULT_MSG")!=null) {
        		throw new Exception(resultMap.get("RESULT_MSG").toString());
    		} else {
        		throw new Exception("result="+result);
    		}
    	}
    }

	public String makeData(Map<String,Object> param) throws Exception {

		Map<String,String> result = contsenderpMapper.getContData(param);

		if (result==null) throw new Exception("계약서 정보가 존재하지 않습니다.");

		Map<String,String> jsonMap = new HashMap<String,String>();
		jsonMap.put("CODE_COMPANY",result.get("CODE_COMPANY"));
		jsonMap.put("CODE_PROJECT",result.get("CODE_PROJECT"));
		jsonMap.put("NO_CONTRACT",result.get("NO_CONTRACT"));
		jsonMap.put("NM_CONTRACT",result.get("NM_CONTRACT"));
		jsonMap.put("CODE_CUST_CONTRACT",result.get("CODE_CUST_CONTRACT"));
		jsonMap.put("GBN_GEORAE_CONTRACT",result.get("GBN_GEORAE_CONTRACT"));
		jsonMap.put("CODE_CONTRACT_TYPE",result.get("CODE_CONTRACT_TYPE"));
		jsonMap.put("CODE_CONTRACT_METHOD",result.get("CODE_CONTRACT_METHOD"));
		jsonMap.put("CODE_CONTRACT_AMT",result.get("CODE_CONTRACT_AMT"));
		jsonMap.put("AMT_CONTRACT",result.get("AMT_CONTRACT"));
		jsonMap.put("AMT_CONTRACT_VAT",result.get("AMT_CONTRACT_VAT"));
		jsonMap.put("DT_CONTRACT",result.get("DT_CONTRACT"));
		jsonMap.put("ID_CHARGE_CONTRACT",result.get("ID_CHARGE_CONTRACT"));
		jsonMap.put("DT_CONTRACT_ST",result.get("DT_CONTRACT_ST"));
		jsonMap.put("DT_CONTRACT_ED",result.get("DT_CONTRACT_ED"));
		jsonMap.put("DT_FIXDEFECT_ST",result.get("DT_FIXDEFECT_ST"));
		jsonMap.put("DT_FIXDEFECT_ED",result.get("DT_FIXDEFECT_ED"));
		jsonMap.put("RATE_FIXDEFECT",result.get("RATE_FIXDEFECT"));
		jsonMap.put("RATE_DELAY",result.get("RATE_DELAY"));
		jsonMap.put("NOTE_DELAY",result.get("NOTE_DELAY"));
		jsonMap.put("AS_MONTH",result.get("AS_MONTH"));
		jsonMap.put("AS_START_COND",result.get("AS_START_COND"));
		jsonMap.put("NM_CHARGE_PHASE",result.get("NM_CHARGE_PHASE"));
		jsonMap.put("NO_MOBILE",result.get("NO_MOBILE"));
		jsonMap.put("EMAIL_ADDR",result.get("EMAIL_ADDR"));
		jsonMap.put("ID_SEUNGIN",result.get("ID_SEUNGIN"));
		jsonMap.put("STATUS",result.get("STATUS"));
		jsonMap.put("DTM_SEUNGIN",result.get("DTM_SEUNGIN"));
		jsonMap.put("NOTE_ETC",result.get("NOTE_ETC"));
		jsonMap.put("SAYU_RETURN",result.get("SAYU_RETURN"));
		jsonMap.put("CODE_PROJECT_PRE",result.get("CODE_PROJECT_PRE"));
		jsonMap.put("CODE_STATUS_LED",result.get("CODE_STATUS_LED"));
		jsonMap.put("ID_REG",result.get("ID_REG"));
		jsonMap.put("DTM_REG",result.get("DTM_REG"));
		jsonMap.put("ID_UPT",result.get("ID_UPT"));
		jsonMap.put("DTM_UPT",result.get("DTM_UPT"));
		jsonMap.put("AMT_EST",result.get("AMT_EST"));
		jsonMap.put("AMT_EST_VAT",result.get("AMT_EST_VAT"));
		jsonMap.put("GBN_MANAGE_CONTRACT",result.get("GBN_MANAGE_CONTRACT"));
		jsonMap.put("CODE_BID_METHOD",result.get("CODE_BID_METHOD"));
		jsonMap.put("RATE_DC_CONTRACT",result.get("RATE_DC_CONTRACT"));
		jsonMap.put("CODE_PROJECT_TP",result.get("CODE_PROJECT_TP"));
		jsonMap.put("CODE_OUTPUT_WAY",result.get("CODE_OUTPUT_WAY"));
		jsonMap.put("DTM_CHG",result.get("DTM_CHG"));
		jsonMap.put("DTM_FIX",result.get("DTM_FIX"));
		jsonMap.put("ID_FIX",result.get("ID_FIX"));
		jsonMap.put("CHASU_RE_SAUP_VAL",result.get("CHASU_RE_SAUP_VAL"));

		Map<String,Object> mam = new HashMap<String,Object>();
		mam.put("MST", new ArrayList<Map<String,String>>());
		List<Map<String,String>> det = new ArrayList<Map<String,String>>();
		det.add(jsonMap);
		mam.put("DET", det);

		String data = new ObjectMapper().writeValueAsString( mam  );
		return data.replaceAll("null", "\"\"");
	}

}