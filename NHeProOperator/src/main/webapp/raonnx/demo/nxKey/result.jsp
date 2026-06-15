<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="com.raonsecure.touchenkey.*"%>
<%@ page import="java.util.*"%>
<html>
<head><title>TouchEn Key E2E Decode</title>
<body>
<b>결과값 페이지</b><br>

<p>

<%
	out.println("hid_key_data : " + request.getParameter("hid_key_data") + "<BR>");
	out.println("hid_enc_data : " + request.getParameter("hid_enc_data") + "<BR>");
%>
<BR><BR>
<%
	//Private2048.key.der 파일
	String privateKey = new String("/svc/nhepro/NHeProFront/raonnx/raon_cert/Private2048.key.der");
	//String privateKey = new String("D:/eclipse-workspace/20200728_nh_nxkey_e2e/WebContent/WEB-INF/raon_cert/Private2048.key.der");
	  
	//session을 사용할 경우
	E2ECrypto Tk = new E2ECrypto(request, (String)session.getAttribute("TEKSRK"), privateKey);
	
	E2ECrypto.setDebugMode(false);
	
	out.println("<b>E2ECrypto Tk = new E2ECrypto(request, session, privateKey);</b><br>"); 
	out.println("result : " + Tk.getLastError() + " (" + Tk.getLastErrorMessage() + ")<br>"); 
%>
	<br><b>Fetch decrypted attributes using E2ECrypto::getDecryptedHashTable method</b><br>
<%
	Hashtable<String, String> ht = Tk.getDecryptedHashTable();
	Iterator itr = ht.keySet().iterator();
	while (itr.hasNext()) {
		String key = (String)itr.next();
		if (key.indexOf("E2E_") == -1) {		// 파라미터에 E2E 필드가 없는 경우
	   			out.println(key + " : " + ht.get(key) + "<BR>");
		}
	}	


%>

<br><br><br><br>
</body>
</html>
