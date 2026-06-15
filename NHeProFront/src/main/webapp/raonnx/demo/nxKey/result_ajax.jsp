<%@ page import="com.raonsecure.touchenkey.*"%>
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<html>
<head><title>TouchEn nxKey E2E Decode</title></head>
<body>
<b>ajax 복호화 페이지</b><br>
<p>
<%
	//out.println("hid_key_data : " + request.getParameter("hid_key_data") + "<BR>");
	//out.println("hid_enc_data : " + request.getParameter("hid_enc_data") + "<BR>");
%>
<BR><BR>
<%
	//Private2048.key.der 파일
	E2ECrypto.setDebugMode(false);
	//String privateKey = new String("D:/eclipse-workspace/20200717_nh_nxkey_e2e/WebContent/WEB-INF/raon_cert/Private2048.key.der");
	String privateKey = new String("/svc/nhepro/NHeProFront/raonnx/raon_cert/Private2048.key.der");
	
	
	//세션랜덤키가 생성되지 않은경우.
	if(session.getAttribute("TEKSRK") == null) {
		System.out.println("[raonsecure] TouchEnNxKey Session (TEKSRK) null ");
	}
	
	//키입력이 암호화되지 않은경우.
	if(request.getParameter("hid_key_data") == null) {
		System.out.println("[raonsecure] TouchEnNxKey hid_key_data null ");
	}
	
	E2ECrypto Tk = null;
	
	try{
		if(Tk == null){		
			Tk = new E2ECrypto(session);
			Tk.E2E_KeyExchange(request.getParameter("hid_key_data"), privateKey);
			
			int LastError = Tk.getLastError();
			if (LastError != 0) {
				// 공개키/ 개인키 교환 장애코드
				System.out.println("[raonsecure] TouchEnKey decode ERROR_CODE :[ " + LastError+ " ] , ERROR_Message [" + Tk.getLastErrorMessage()	+ " ]");
			}
		}
	}catch(Exception e){
	}

	String decode1 = null;
	String decode2 = null;
	String keyId = request.getParameter("keyId");
	String E2E_txtId = "E2E_txt"+keyId;
	String E2E_pwdId = "E2E_pwd"+keyId;
	// 세션키과 공개키로 암호화한 키데이터
	// 복호화 진행
	decode1 = Tk.decryptE2EField(request.getParameter(E2E_txtId));
	decode2 = Tk.decryptE2EField(request.getParameter(E2E_pwdId));

	int LastError = Tk.getLastError();
	if (LastError != 0) {
		// 복호화 장애코드
		System.out.println("[raonsecure] TouchEnKey decode ERROR_CODE :[ " + LastError+ " ] , ERROR_Message [" + Tk.getLastErrorMessage()	+ " ]");
	}
%>
====nxKey decode data====
txt01 : <%=decode1 %>
pwd01 : <%=decode2 %>