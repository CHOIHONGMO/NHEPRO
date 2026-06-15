
package com.st_ones.nhpkicmpnp.web;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.ProtocolException;
import java.net.URL;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.st_ones.common.util.clazz.EverConverter;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.info.BaseInfo;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.nhpkicmpnp.dto.CertUserDTO;
import com.st_ones.nhpkicmpnp.exception.DTException;
import com.st_ones.nhpkicmpnp.exception.ErrorCode;
import com.st_ones.nhpkicmpnp.service.CertUserService;

@Controller
@RequestMapping(value="/certapi")
public class WebRestController extends BaseController {
	@Autowired
	private CertUserService certUserService;
	private static final Logger logger = LoggerFactory.getLogger(WebRestController.class);
	//private String userId;

	@RequestMapping("/connRest")
	public void connRest(@RequestBody String clientReq,@RequestHeader Map<String, String> header,  EverHttpResponse resp) throws Exception {
		BaseInfo userInfo = UserInfoManager.getUserInfoImpl();
		String baseUserId = userInfo.getUserId();

		String mpcId = "";
		String isCorporation = "";
		String irsNo = "";
		System.out.println("[connRest APP START] Dapp Info : " + PropertiesManager.getString("blockchain.cert.dappProtocol")
		+PropertiesManager.getString("blockchain.cert.dappIpAddr")
		+":"
		+PropertiesManager.getString("blockchain.cert.dappPort"));
		System.out.println("11111=====================================================================");
		Iterator<String>keys = header.keySet().iterator();

		while(keys.hasNext()) {
			String key = keys.next();
			System.out.println(String.format("Header '%s' = %s",  key, header.get(key)));
		}
		System.out.println("22222=====================================================================");
		System.out.println("[" + getTimeStamp() + "  Cert Client -> HTTPS -> WAS Container ] : " + clientReq);

		if (clientReq.length() < 0 || clientReq == null) {
			resp.setResponseMessage(getResposeMessage(ErrorCode.ERR_FAIL_GET_DATA, ErrorCode.msgERR_FAIL_GET_DATA));
		}

		JSONObject jsonObj = new JSONObject(clientReq);

		/*
		 * func :: "getpolicy", "challenge", "certissue", "certverify"
		 */
		String func = jsonObj.getString("tag");

		// SELECT 인증서 정보
		try {
			// 기존 발급된 계정의 법인/개인 인증서가 있는지 체크 후, 폐기로직을 태움
			if (func.equals("certissue")) {
				JSONObject json = new JSONObject(clientReq);
				System.out.println("[CertIssue] json Data : " + json);
				mpcId = json.getString("mpcId");
				isCorporation = json.getString("isCorporation");

				Map<String, String> Tempmap = new HashMap<String, String>();
				Tempmap.put("userId", baseUserId);
				Map<String,String> userInfoMap = certUserService.getUserInfo(Tempmap);
				System.out.println("[certIssue - " + getTimeStamp() + "] getUserInfo : " + userInfo);

				Map<String, String> selectUserParam = new HashMap<String,String>();
				selectUserParam.put("isCorporation", isCorporation);
				selectUserParam.put("userId", baseUserId);
				if (isCorporation.equals("true")) {
					// 법인인증서 - 해당 법인으로 발급된 인증서가 있는지 조회 후 삭제로직 시작
					irsNo = userInfoMap.get("IRS_NUM").toString();
					selectUserParam.put("irsNo", irsNo);
				}

				List<Map<String, Object>> certUserInfoResult = new ArrayList<Map<String, Object>>();
				certUserInfoResult =certUserService.revokeCertTargetInfo(selectUserParam);
				System.out.println("[certIssue - " + getTimeStamp() + "] revokeCertTargetInfo : " + certUserInfoResult);
				if (certUserInfoResult.size() > 0) {
					for ( int a=0; a<certUserInfoResult.size(); a++) {
						selectUserParam.put("bcid", certUserInfoResult.get(a).get("BCID").toString());
						String result = certUserService.revokeUserCert(selectUserParam);
						String revokeMsg = "{\"tag\": \"revokeBcid\", \"endReason\": \"998\", \"bcid\": "+certUserInfoResult.get(a).get("BCID").toString()+"}";
						if ( result.equals("success")) {
							String strRespData = invokeBlockChain("/revokeBcid", revokeMsg);
						}
					}
				}
			}

		} catch (Exception e1) {
			resp.setResponseMessage(getResposeMessage(ErrorCode.ERR_WAS_DBException, ErrorCode.msgERR_WAS_DBException));
		}

		String strRespData = "";
		String dappProtocol = PropertiesManager.getString("blockchain.cert.dappProtocol"); // 사설인증Dapp 통신프로토콜
		String dappIpAddr = PropertiesManager.getString("blockchain.cert.dappIpAddr"); // 사설인증Dapp 통신 IP
		String dappPort = PropertiesManager.getString("blockchain.cert.dappPort"); // 사설인증Dapp 통신 Port

//		strRespData = invokeBlockChain("/"+func, clientReq);
		try {
			strRespData = sendAndRecv(new URL(dappProtocol + dappIpAddr +":"+dappPort + "/" + func), clientReq);
			System.out.println("[" + getTimeStamp() + " BlockChain Result : " + strRespData);
		} catch (MalformedURLException e) {
			e.printStackTrace();
			resp.setResponseMessage(getResposeMessage(
					ErrorCode.ERR_WAS_MalformedURLException, ErrorCode.msgERR_WAS_MalformedURLException));
		} catch (DTException e) {
			e.printStackTrace();
			resp.setResponseMessage(getResposeMessage(e.getCode(), e.getMessage()));
		}
		// DB에 인증서, CN, 유효기간의 시작 일자, 만료 일자 저장
		if (func.equals("certissue")) {
			JSONObject json = new JSONObject(strRespData);
			JSONObject jsonMessage = json.getJSONObject("message");

			String sIsCorporation = isCorporation;
			String sSignCertCN = jsonMessage.getString("signCertCN");
			String sSignCertDN = jsonMessage.getString("signCertDN");
			String sSignCertOU = jsonMessage.getString("signCertOU");
			String sBefore = jsonMessage.getString("dateNotBefore");
			String sAfter = jsonMessage.getString("dateNotAfter");
			String sBCID = jsonMessage.getString("bcid");
			String sMpcId = mpcId;

			Map<String, String> param = new HashMap<String,String>();
			param.put("userId", baseUserId);
			param.put("isCorporation", sIsCorporation);
			param.put("signCertCn", sSignCertCN);
			param.put("signCertDn", sSignCertDN);
			param.put("signCertOu", sSignCertOU);
			param.put("beforeDate", sBefore);
			param.put("afterDate", sAfter);
			param.put("certStatus", "validity");
			param.put("bcid", sBCID);
			param.put("irsNo", irsNo);
			param.put("di", sMpcId);
			certUserService.insertCertUser(param);

			// end : DB에 데이터(인증서 죵류, CN, 유효기간의 시작 일자, 만료 일자 ) 넣는 부분

		}
		resp.getWriter().print(strRespData);
	}

	// 인증서폐기 페이지
	@ResponseBody
	@RequestMapping(value="/getCertDelInfo")
	public ResponseEntity<String> getCertDelInfo(@RequestBody Map<String, String> map,  EverHttpResponse resp) throws Exception {
		List<Map<String, Object>> certUserInfoResult = new ArrayList<Map<String, Object>>();
		System.out.println("[" + getTimeStamp() + " - CertDelInfo START !!");
		System.out.println("[" + getTimeStamp() + " - getCertDelInfo : " + map);

		BaseInfo userInfo = UserInfoManager.getUserInfoImpl();
		String baseUserId = userInfo.getUserId();

		System.out.println("[" + getTimeStamp() + " - userId : " + baseUserId);

		Map<String, String> delUserParam = new HashMap<String,String>();
		delUserParam.put("userId", baseUserId);

		try {
			certUserInfoResult =certUserService.certUserInfo(delUserParam);
		} catch (Exception e) {
			e.printStackTrace();
		}

		String certUserInfoRes = EverConverter.getJsonString(certUserInfoResult);

		HttpHeaders httpHeaders = new HttpHeaders();
		httpHeaders.add("Content-Type", "text/html; charset=utf-8");
		return new ResponseEntity<String>(certUserInfoRes, httpHeaders, HttpStatus.CREATED);
	}

	@RequestMapping("/certDel")
	public void certDelete(@RequestBody Map<String, String> map, EverHttpResponse resp) throws Exception {
		System.out.println(">>>> resp : " + resp);
		CertUserDTO dto = new CertUserDTO();
		ObjectMapper mapper = new ObjectMapper();
		String strRespData = "";

		BaseInfo userInfo = UserInfoManager.getUserInfoImpl();
		String baseUserId = userInfo.getUserId();
		System.out.println("[" + getTimeStamp() + " - BaseUserId : " + baseUserId);

		try {
			String jsonString = mapper.writeValueAsString(map);
			System.out.println(">>>> map : " + map);
			System.out.println(jsonString);
			String bcid = map.get("bcid").toString();
			String clientReq = "{\"tag\": \"revokeBcid\", \"endReason\": \"998\", \"bcid\": "+bcid+"}";
			dto = mapper.readValue(jsonString, CertUserDTO.class);

			//DB Parameter
			Map<String, String> delParam = new HashMap<String,String>();
			delParam.put("bcid", dto.getBcid());
			delParam.put("isCorporation", dto.getIs_corporation());
			delParam.put("userId", baseUserId);

			int certCheck = certUserService.countCertUser(delParam);
			System.out.println("[" + getTimeStamp() + " | certDelCount : " + certCheck);

			if (certCheck == 1) {
				String res = updateCertRevoke(dto.getBcid(), dto.getIs_corporation());
				System.out.println(">>> DB delete Res : " + res);

				if ( res.equals("success")) {
					strRespData = invokeBlockChain("/revokeBcid", clientReq);
				}

				System.out.println("UPDATE USER CERT strRespData : " + strRespData);
				System.out.println("UPDATE USER CERT res : " + res);
			} else {
				JSONObject json = new JSONObject();
				JSONObject jsonMsg = new JSONObject();
				jsonMsg.put("message", "error");
				json.put("rescode", "996");
				json.put("message", jsonMsg);
				System.out.println("[" + getTimeStamp() + " | json.toString() : " + json.toString());
				strRespData = json.toString();
				System.out.println("[" + getTimeStamp() + " | strRespDatastrRespData : " + strRespData);
			}

		} catch (Exception e) {
		}
		resp.getWriter().print(strRespData);
	}

	// 기본적인 사용자정보 - 회사코드/사업자관리번호/회사내 관리자여부 가져오는 부분
	// 해당 부분은 session interceptor에 등록되어있음
	@ResponseBody
	@RequestMapping("/getUserInfo")
	public ResponseEntity<String> getUserInfo(EverHttpResponse resp) throws Exception {
		BaseInfo userInfo = UserInfoManager.getUserInfoImpl();
		String userId = userInfo.getUserId();

		Map<String, String> Tempmap = new HashMap<String, String>();
		Tempmap.put("userId", userId);

		Map<String,String> userDataInfo = certUserService.getUserInfo(Tempmap);

		String companyCd = userDataInfo.get("COMPANY_CD");
		String iRsNo = userDataInfo.get("IRS_NUM");
		String companyNm = userDataInfo.get("CUST_NM");
		String superUserFlag = userDataInfo.get("SUPERUSERFLAG");

		// 2021/03/11 본인확인 추가개발 부분 (사용자 이름, 전화번호 추가)
		String userNm = userDataInfo.get("USER_NM");
		String cellNum = userDataInfo.get("CELL_NUM");


		Map<String, String> map = new HashMap<String, String>();
		map.put("userId", userId);
		map.put("companyCd", companyCd);
		map.put("iRsNo", iRsNo);
		map.put("superUser", superUserFlag);
		map.put("companyNm", companyNm);

		// 2021/03/11 본인확인 추가개발 부분 (사용자 이름, 전화번호 추가)
		map.put("userNm", userNm);
		map.put("cellNum", cellNum);

		System.out.println("getUserInfo userid : " + map.get("userId"));
		System.out.println("getUserInfo companyCd : " + map.get("companyCd"));
		System.out.println("getUserInfo superUser : " + map.get("superUser"));
		System.out.println("getUserInfo irsNo : " + map.get("iRsNo"));

		// 2021/03/11 본인확인 추가개발 부분 (사용자 이름, 전화번호 추가)
		System.out.println("getUserInfo userNm : " + map.get("userNm"));
		System.out.println("getUserInfo cellNum : " + map.get("cellNum"));

		HttpHeaders httpHeaders = new HttpHeaders();
		httpHeaders.add("Content-Type", "text/html; charset=utf-8");

		Map<String, String> checkResult = new HashMap<String,String>();
		checkResult.put("userId", map.get("userId").toString());
		checkResult.put("iRsNo", map.get("iRsNo").toString());
		checkResult.put("companyNm", map.get("companyNm").toString());
		checkResult.put("superUser", map.get("superUser").toString());
		checkResult.put("companyCd", map.get("companyCd").toString());

		// 2021/03/11 본인확인 추가개발 부분 (사용자 이름, 전화번호 추가)		
		checkResult.put("userNm", map.get("userNm").toString());
		checkResult.put("cellNum", map.get("cellNum").toString());

		String certUserInfoRes = EverConverter.getJsonString(checkResult);
		System.out.println(">>> getUserInfo : " + certUserInfoRes);
		return new ResponseEntity<String>(certUserInfoRes, httpHeaders, HttpStatus.CREATED);
	}

	// 법인 가입시 체크하는 부분
	@ResponseBody
	@RequestMapping(value="/checkCompanyCd")
	public ResponseEntity<String>  checkCompanyCd(@RequestBody Map<String, String> map, EverHttpResponse resp) throws Exception {
		System.out.println(">>> checkCompanyCd : " + map);
		String companyCdParam = "";
		String check = "false";
		String superFlag = "false";
		String iRsNo = "";
		String superUserFlag = "";

		// 임시코드 - 시작
		Map<String, String> Tempmap = new HashMap<String, String>();
		Tempmap.put("userId", map.get("mpcId"));
		Map<String,String> userInfo = certUserService.getUserInfo(Tempmap);
		System.out.println("[checkCompanyCd - " + getTimeStamp() + "] getUserInfo : " + userInfo);

		iRsNo = userInfo.get("IRS_NUM").toString();
		superUserFlag = userInfo.get("SUPERUSERFLAG").toString();
		// 임시코드 - 끝

		// 회사코드 비교
		if ( !map.get("companyCd").isEmpty()) {
			companyCdParam = map.get("companyCd").toString();
			System.out.println(">>> companyCd : " + companyCdParam);

			if ( iRsNo.equals(companyCdParam)) {
				check = "true";
			} else {
				check = "false";
			}
		}

		HttpHeaders httpHeaders = new HttpHeaders();
		httpHeaders.add("Content-Type", "text/html; charset=utf-8");
		Map<String, String> checkResult = new HashMap<String,String>();
		checkResult.put("check", check);
		System.out.println("SUPERUSERFLAG - " + superUserFlag);
		if ( superUserFlag.equals("Y") ) {
			System.out.println("SUPERUSERFLAG - not null");
			superFlag = "true";
			checkResult.put("superUser", superUserFlag);
		}
		checkResult.put("superFlag", superFlag);
		String certUserInfoRes = EverConverter.getJsonString(checkResult);
		return new ResponseEntity<String>(certUserInfoRes, httpHeaders, HttpStatus.CREATED);
	}

	private String updateCertRevoke(String bcid, String isCorporation) {
		String result ="false";
		//DB Parameter
		Map<String, String> delParam = new HashMap<String,String>();
		delParam.put("bcid", bcid);
		delParam.put("isCorporation", isCorporation);
		try {
			result = certUserService.revokeUserCert(delParam);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return result;
	}

	private String invokeBlockChain(String protocol, String clientReq) {
		String result = "false";
		String dappProtocol = PropertiesManager.getString("blockchain.cert.dappProtocol"); // 사설인증Dapp 통신프로토콜
		String dappIpAddr = PropertiesManager.getString("blockchain.cert.dappIpAddr"); // 사설인증Dapp 통신 IP
		String dappPort = PropertiesManager.getString("blockchain.cert.dappPort"); // 사설인증Dapp 통신 Port
		try {
			result = sendAndRecv(new URL(dappProtocol + dappIpAddr +":"+dappPort + protocol ), clientReq);
		} catch (MalformedURLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (DTException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return result;
	}

	// 블록체인 발송부
	public String sendAndRecv(URL url, String strJsonReqData) throws DTException {
		HttpURLConnection conn = null;
		String buffer = null;
		String respMsg = "";

		System.out.println("[" + getTimeStamp() + " - sendAndRecv] URL :" + url);
		System.out.println("[" + getTimeStamp() + " - sendAndRecv] strJsonReqData :" + strJsonReqData);
		try {
			System.out.println("[" + getTimeStamp() + "   strJsonReqData :" + strJsonReqData.getBytes("UTF-8").toString());
		} catch (UnsupportedEncodingException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}

		try {
			conn = (HttpURLConnection) url.openConnection();

			conn.setDoOutput(true);
			conn.setDoInput(true);
			try {
				conn.setRequestMethod("POST");
			} catch (ProtocolException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				throw new DTException(ErrorCode.ERR_WAS_ProtocolException, ErrorCode.msgERR_WAS_ProtocolException);
			}
			conn.setRequestProperty("Content-Type", "application/json;charset=utf-8");
			conn.setRequestProperty("Accept-Charset", "UTF-8");

			OutputStream os;

			os = conn.getOutputStream();
			os.write(strJsonReqData.getBytes("UTF-8"));
			os.flush();
			os.close();

			BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
			System.out.println("[" + getTimeStamp() + "   BufferdReader :" + in);
			while ((buffer = in.readLine()) != null) {
				respMsg += buffer;
				System.out.println("BufferdReader : " + respMsg);
			}
			in.close();
			System.out.println("[" + getTimeStamp() + "   CertDapp Server -> WAS Container ] : " + respMsg);

			return respMsg;
		} catch (IOException e) {
			e.printStackTrace();
			throw new DTException(ErrorCode.ERR_WAS_IOEXCEPTION, ErrorCode.msgERR_WAS_IOEXCEPTION);
		} finally {
			if (conn != null)
				conn.disconnect();
		}
	}

	public Timestamp getTimeStamp() {
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
		Calendar cal = Calendar.getInstance();
		String today = null;
		today = formatter.format(cal.getTime());
		return Timestamp.valueOf(today);
	}

	public String getResposeMessage(int errcode, String errMessage) {
		JSONObject json = new JSONObject();
		json.put("rescode", String.valueOf(errcode));
		json.put("message", errMessage);

		return json.toString();
	}
}
