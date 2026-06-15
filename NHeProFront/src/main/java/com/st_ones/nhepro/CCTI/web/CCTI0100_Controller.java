package com.st_ones.nhepro.CCTI.web;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.File;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.st_ones.common.util.clazz.EverFile;
import com.st_ones.common.util.clazz.EverString;

import org.apache.commons.codec.binary.Base64;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.st_ones.common.combo.service.CommonComboService;
import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.util.clazz.CryptoUtil;
import com.st_ones.common.util.clazz.EverConverter;
import com.st_ones.common.util.clazz.EverDate;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.nhepro.CCTI.service.CCTI0100_Service;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : CCTI0100_Controller.java
 * @date 2020.07.05
 * @version 1.0
 * @see
 */

@Controller
@RequestMapping(value = "/nhepro/CCTI")
public class CCTI0100_Controller extends BaseController{
    @Autowired
    private MessageService msg;
    @Autowired
    private CCTI0100_Service ccti0100_Service;
    @Autowired
    private CommonComboService commonComboService;

	/**
	 * 화면명 :
	 * 처리내용 :
	 * 경로 :  > >
	 */
    @RequestMapping(value="/CCTI0100/view")
    public String CCTI0100(EverHttpRequest req) throws Exception {
        req.setAttribute("fromDate", EverDate.addDateMonth(EverDate.getDate(), -3));
        req.setAttribute("toDate", EverDate.addDateMonth(EverDate.getDate(), 1));
        return "/nhepro/CCTI/CCTI0100";
    }

	/**
	 * 화면명 : 수기계약서 등록 (CCTI0100)
	 * 처리내용 : 조회
	 * 경로 : 계약관리 > 전자계약 > 수기계약서등록
	 */
    @RequestMapping(value="/CCTI0100/doSearch")
    public void CCTI0100_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> param = req.getFormData();

        resp.setGridObject("grid", ccti0100_Service.ccti0100_doSearch(param));
        resp.setResponseCode("true");
    }
    
    /**
	 * 화면명 : 수기계약서 등록 (CCTI0100)
	 * 처리내용 : 계약서별 품목 조회
	 * 경로 : 계약관리 > 전자계약 > 수기계약서등록
	 */
    @RequestMapping(value="/CCTI0100/doSearchMTGL")
    public void CCTI0100_doSearchMTGL(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	
        Map<String, String> param = req.getFormData();
        
        resp.setGridObject("gridMTGL", ccti0100_Service.ccti0100_doSearchMTGL(param));
        resp.setResponseCode("true");
    }

    /**
	 * 화면명 : 수기계약서 등록 및 계약완료 처리 (CCTI0100)
	 * 처리내용 : 수기 계약서를 등록하고, 발주서를 작성중 상태로 만듬
	 * 경로 : 계약관리 > 전자계약 > 수기계약서등록
	 */
    @RequestMapping(value="/CCTI0100/doSave")
    public void ccti0100_doSave(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	
    	Map<String, String> param = req.getFormData();
    	param.put("PROGRESS_CD", EverString.nullToEmptyString(req.getParameter("progressCd")));
    	
        List<Map<String, Object>> gridData = req.getGridData("grid");
        ccti0100_Service.ccti0100_doSave(param, gridData);
        
        resp.setResponseMessage(msg.getMessage("0031"));
        resp.setResponseCode("true");
    }
    
    /**
	 * 화면명 : 수기계약서 삭제 (CCTI0100)
	 * 처리내용 : 임시저장된 수기계약서를 삭제함
	 * 경로 : 계약관리 > 전자계약 > 수기계약서등록
	 */
    @RequestMapping(value="/CCTI0100/doDelete")
    public void ccti0100_doDelete(EverHttpRequest req, EverHttpResponse resp) throws Exception {
    	
        List<Map<String, Object>> gridData = req.getGridData("grid");
        ccti0100_Service.ccti0100_doDelete(gridData);
        
        resp.setResponseMessage(msg.getMessage("0031"));
        resp.setResponseCode("true");
    }

    @RequestMapping(value="/CCTI0100/isFileDirectory")
    public void CCTI0100_isFileDirectory(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		UserInfo userInfo = UserInfoManager.getUserInfo();
		String folderNm = userInfo.getCompanyCd() + "_" + userInfo.getDeptCd();
		String folderPath = PropertiesManager.getString("everf.fileUpload.path") + "EC/" + folderNm;
		File file = new File(folderPath + "/");
		if (!file.isDirectory()) {
			// 디렉토리가 존재하지 않으면 생성
			EverFile.makeDir(file.getPath());
		}

		Map<String, String> ezFinderInfo = new HashMap<>();
        ezFinderInfo.put("ezFinderUrl", PropertiesManager.getString("ezfinder.common.url"));
        System.err.println("=================ezFinderInfo===================================="+ezFinderInfo);
        System.err.println("=================folderNm===================================="+folderNm);
        System.err.println("=================folderNm===================================="+folderNm);
        System.err.println("=================folderNm===================================="+folderNm);
        ezFinderInfo.put("folderEncNm", CryptoUtil.encryptAES256(folderNm, "nh"));

		// 112, 113 API 호출
        ezFinderApi("1", folderPath, folderNm);
		if (!PropertiesManager.getBoolean("eversrm.system.developmentFlag")) {
			ezFinderApi("2", folderPath, folderNm);
		}

		resp.setParameter("ezFinderInfo", EverConverter.getJsonString(ezFinderInfo));
    }

    public void ezFinderApi(String num, String folderPath, String folderNm) throws Exception {
		Map<String, String> ezFinderInfo = new HashMap<>();
		ezFinderInfo.put("folderPath", folderPath);
		ezFinderInfo.put("folderNm", folderNm);
		ezFinderInfo.put("ezFinderUrl", PropertiesManager.getString("ezfinder.url" + num));
		ezFinderInfo.put("Authorization", "Basic " + Base64.encodeBase64String(
				(PropertiesManager.getString("ezfinder.clientId" + num) + ":" + PropertiesManager.getString("ezfinder.clientSecret" + num)).getBytes()));
		ezFinderInfo.put("username", PropertiesManager.getString("ezfinder.username" + num));
		ezFinderInfo.put("ppdd", PropertiesManager.getString("ezfinder.ppdd" + num));
		ezFinderInfo.put("roleIdxs", PropertiesManager.getString("ezfinder.roleIdxs" + num));

		String pURL = ezFinderInfo.get("ezFinderUrl") +"/oauth/token";
//		String pURL = "http://192.168.65.151:8380/" + "oauth/token";
		URL url = new URL(pURL);
		HttpURLConnection http = (HttpURLConnection) url.openConnection();
		http.setDefaultUseCaches(false);
		http.setDoInput(true);
		http.setDoOutput(true);
		http.setRequestMethod("POST");
		http.setRequestProperty("content-type", "application/x-www-form-urlencoded");
		http.setRequestProperty("Authorization", ezFinderInfo.get("Authorization"));
		String paramstr = "grant_type=password&username=" + ezFinderInfo.get("username") + "&password=" + ezFinderInfo.get("ppdd");
		System.out.println(pURL + "=1=====================================================paramstr=" + paramstr);
		OutputStreamWriter outStream = new OutputStreamWriter(http.getOutputStream(), "UTF-8");
		PrintWriter wr = new PrintWriter(outStream);
		wr.write(paramstr);
		wr.flush();
		wr.close();

		InputStreamReader tmp = new InputStreamReader(http.getInputStream(), "UTF-8");
		BufferedReader reader = new BufferedReader(tmp);
		StringBuilder builder = new StringBuilder();
		String str = "";
		while ((str = reader.readLine()) != null) {
			builder.append(str);
		}
		System.err.println("builder=" + builder);
		Map<String, Object> send_data_map = EverConverter.readJsonObject(builder.toString(), Map.class);
		System.err.println("===send_data_map=" + send_data_map);
		String access_token = String.valueOf(send_data_map.get("access_token"));
		reader.close();
		tmp.close();

		// Map<String, List<String>> imap = http.getHeaderFields();

		pURL = ezFinderInfo.get("ezFinderUrl") +"/api/indexer/v1";
		url = new URL(pURL);
		http = (HttpURLConnection)url.openConnection();
		http.setDefaultUseCaches(false);
		http.setDoInput(true);
//    	http.setDoOutput(true);
		http.setRequestMethod("GET");
		http.setRequestProperty("content-type", "application/x-www-form-urlencoded");
		http.setRequestProperty("Authorization", "Bearer "+ access_token);

		paramstr = "";
		System.out.println(pURL+"=2=====================================================send_data_map="+send_data_map.get("access_token"));
//    	outStream = new OutputStreamWriter(http.getOutputStream(),"UTF-8");
//    	wr = new PrintWriter(outStream);
//    	wr.write(paramstr);
//    	wr.flush();

		tmp = new InputStreamReader(http.getInputStream(),"UTF-8");
		reader = new BufferedReader(tmp);
		builder = new StringBuilder();
		str = "";
		while((str = reader.readLine()) != null) {
			builder.append(str);
		}
		System.err.println("builder2="+builder);
		send_data_map = EverConverter.readJsonObject(builder.toString(), Map.class);
		System.err.println("===send_data_map2="+send_data_map);

		List<Map> folderListM = (List)send_data_map.get("results");
		reader.close();
		tmp.close();


		System.out.println("=================================");
		System.out.println("==="+folderListM);
		System.out.println("=================================");

		boolean isFolderEz = true;

		// 초기화 키
		String indexKey = "";
		for(Map mmm : folderListM) {
			Map<String, String> map = (Map) mmm.get("info");

			indexKey = map.get("key");
			if(map.get("name").equals( ezFinderInfo.get("folderNm")  )) {
				isFolderEz = false;
				break;
			}
		}
		if (isFolderEz) {


			pURL = ezFinderInfo.get("ezFinderUrl") +"/api/role/v1";
			System.out.println(pURL + "=3=========================11111111111111====GET ROWIDX=========================");
			url = new URL(pURL);
			http = (HttpURLConnection)url.openConnection();
			http.setDefaultUseCaches(false);
			http.setDoInput(true);
			http.setRequestMethod("GET");
			http.setRequestProperty("content-type", "application/x-www-form-urlencoded");
			http.setRequestProperty("Authorization", "Bearer "+ access_token);
			paramstr = "";

			tmp = new InputStreamReader(http.getInputStream(),"UTF-8");
			reader = new BufferedReader(tmp);
			builder = new StringBuilder();
			str = "";
			while((str = reader.readLine()) != null) {
				builder.append(str);
			}
			System.err.println("builder2="+builder);
			send_data_map = EverConverter.readJsonObject(builder.toString(), Map.class);
			System.err.println("===send_data_map2="+send_data_map);

			List<Map> roleListM = (List)send_data_map.get("results");
			reader.close();
			tmp.close();

			// 초기화 키
			String rowIdx = "";
			System.out.println(pURL + "=3=====================222222222222========GET ROWIDX====================xxxxxxxxxxxxxxx====");
			for(Map mmm : roleListM) {
				String role = String.valueOf(mmm.get("role"));
				if(role.equals( ezFinderInfo.get("folderNm")  )) {
					rowIdx = String.valueOf(mmm.get("idx"));;
					break;
				}
			}
			System.out.println(pURL + "=3==================444444444444444444444===========GET ROWIDX========================rowIdx="+rowIdx);


			if ("".equals(rowIdx)) {
				pURL = ezFinderInfo.get("ezFinderUrl") + "/api/role/v1";
				System.out.println(pURL + "=3=====================333333333333333333333========CREATE ROWIDX=========================");
				url = new URL(pURL);
				http = (HttpURLConnection) url.openConnection();
				http.setDefaultUseCaches(false);
				http.setDoInput(true);
				http.setDoOutput(true);
				http.setRequestMethod("POST");
				http.setRequestProperty("content-type", "application/x-www-form-urlencoded");
				http.setRequestProperty("Authorization", "Bearer " + access_token);
				paramstr = "name=" + ezFinderInfo.get("folderNm") + "&role=" + ezFinderInfo.get("folderNm");
				System.out.println(pURL + "=3==========================CREATE ROWIDX===========================paramstr=" + paramstr);
				outStream = new OutputStreamWriter(http.getOutputStream(), "UTF-8");
				wr = new PrintWriter(outStream);
				wr.write(paramstr);
				wr.flush();
				wr.close();

				tmp = new InputStreamReader(http.getInputStream(),"UTF-8");
				reader = new BufferedReader(tmp);
				builder = new StringBuilder();
				str = "";
				while((str = reader.readLine()) != null) {
					builder.append(str);
				}
				System.err.println("CREATE ROWIDX========================="+builder);
			}



			pURL = ezFinderInfo.get("ezFinderUrl") +"/api/role/v1";
			System.out.println(pURL + "=3=============================GET ROWIDX=========================");
			url = new URL(pURL);
			http = (HttpURLConnection)url.openConnection();
			http.setDefaultUseCaches(false);
			http.setDoInput(true);
			http.setRequestMethod("GET");
			http.setRequestProperty("content-type", "application/x-www-form-urlencoded");
			http.setRequestProperty("Authorization", "Bearer "+ access_token);
			paramstr = "";

			tmp = new InputStreamReader(http.getInputStream(),"UTF-8");
			reader = new BufferedReader(tmp);
			builder = new StringBuilder();
			str = "";
			while((str = reader.readLine()) != null) {
				builder.append(str);
			}
			System.err.println("builder2="+builder);
			send_data_map = EverConverter.readJsonObject(builder.toString(), Map.class);
			System.err.println("===send_data_map2="+send_data_map);

			roleListM = (List)send_data_map.get("results");
			reader.close();
			tmp.close();

			// 초기화 키
			rowIdx = "";
			System.out.println(pURL + "=3=============================GET ROWIDX====================xxxxxxxxxxxxxxx====");
			for(Map mmm : roleListM) {
				String role = String.valueOf(mmm.get("role"));
				if(role.equals( ezFinderInfo.get("folderNm")  )) {
					rowIdx = String.valueOf(mmm.get("idx"));;
					break;
				}
			}

			System.out.println(pURL + "=3=============================GET ROWIDX========================rowIdx="+rowIdx);









			pURL = ezFinderInfo.get("ezFinderUrl") + "/api/indexer/v1";
			url = new URL(pURL);
			http = (HttpURLConnection) url.openConnection();
			http.setDefaultUseCaches(false);
			http.setDoInput(true);
			http.setDoOutput(true);
			http.setRequestMethod("POST");
			http.setRequestProperty("content-type", "application/x-www-form-urlencoded");
			http.setRequestProperty("Authorization", "Bearer " + access_token);
			paramstr = "folder=" + ezFinderInfo.get("folderPath") + "&name=" + ezFinderInfo.get("folderNm") + "&roleIdxs=" + rowIdx + "&schedule=0 0 2 * * *&type=DISK";
			System.out.println(pURL + "=3=====================================================paramstr=" + paramstr);
			outStream = new OutputStreamWriter(http.getOutputStream(), "UTF-8");
			wr = new PrintWriter(outStream);
			wr.write(paramstr);
			wr.flush();
			wr.close();

			tmp = new InputStreamReader(http.getInputStream(), "UTF-8");
			reader = new BufferedReader(tmp);
			builder = new StringBuilder();
			str = "";
			while ((str = reader.readLine()) != null) {
				builder.append(str);
			}
			reader.close();
			tmp.close();
			System.err.println("builder3=" + builder);









		}
    }
}

