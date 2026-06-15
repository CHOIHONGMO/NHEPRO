package com.st_ones.common.serverpush.reverseajax;

import org.directwebremoting.annotations.RemoteProxy;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Iterator;
import java.util.Map;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : EverAlarm.java
 * @date 2013. 07. 22.
 * @version 1.0
 * @see
 */
@Service
@RemoteProxy
public class EverRestJson {

	private static Logger logger = LoggerFactory.getLogger(EverRestJson.class);

	public static JSONObject actionAPI(Map<String, String> restInfo) throws Exception {

		HttpURLConnection conn = null;
		JSONObject jsonObject = null;
		JSONParser jsonParser = null;

		try {
			// URL 설정
			URL url = new URL(restInfo.get("url"));
			conn = (HttpURLConnection) url.openConnection();
			// Request 형식 설정
			conn.setRequestMethod("POST");
			conn.setRequestProperty("Content-Type", "application/json");

			// Request에 JSON data 주입
			conn.setDoOutput(true);
			BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(conn.getOutputStream()));

			JSONObject formFile = new JSONObject();
			Iterator<String> restItor = restInfo.keySet().iterator();

			while (restItor.hasNext()) {
				String keyVal = restItor.next();
				if (!keyVal.equals("url")) {
					String tmpVal = restInfo.get(keyVal);
					formFile.put(keyVal, tmpVal);
				}
			}

			// request 에 쓰기
			bw.write(formFile.toJSONString());
			bw.flush();
			bw.close();

			// 결과 값 받기
			BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
			StringBuffer sb = new StringBuffer();
			String line = "";
			while ((line = br.readLine()) != null) {
				sb.append(line);
				jsonParser = new JSONParser();
				jsonObject = (JSONObject) jsonParser.parse(sb.toString());
			}

			br.close();

			conn.disconnect();

		} catch(Exception e) {
			logger.error(e.getMessage());
		}

		return jsonObject;
	}

}