<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.net.InetAddress" %>
<%@ page import="java.net.URL" %>
<%@ page import="kr.co.tpay.webtx.Encryptor"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%
try{
	
response.addHeader("Access-Control-Allow-Origin", "*");
	
String merchantKey = request.getAttribute("merchantKey").toString();	//상점키
merchantKey = StringEscapeUtils.unescapeHtml(merchantKey); // DB에 +가 ASCII 코드인 &#43;로 치환되어서 들어감 -> +로 다시 치환
String moid = request.getAttribute("moid").toString();							// 상품주문번호
String mid = request.getAttribute("mid").toString();								// 상점 아이디
String goodsName = request.getParameter("goodsName") == null || request.getParameter("goodsName")== "" ?  "epro_point" : request.getParameter("goodsName") ;		// 상품명
String amt = request.getParameter("total");		
String mallUserId = request.getParameter("userId");					// 결재자 아이디
String buyerName = request.getParameter("buyerName");	// 결재자 이름 한글처리
String payMethod = request.getParameter("payMethod").toString();

String domain = request.getParameter("domain");

Encryptor encryptor = new Encryptor(merchantKey);
String encryptData = encryptor.encData(amt+mid+moid);
String ediDate = encryptor.getEdiDate();
String vbankExpDate = encryptor.getVBankExpDate();

InetAddress inet = InetAddress.getLocalHost();							// 상점 클라이언트 IP 가져오기
String mallIp = inet.getHostAddress();
String userIp = request.getRemoteAddr();

URL url = new URL(request.getRequestURL().toString());
String payActionUrl = request.getAttribute("payActionUrl").toString();
String payLocalUrl = request.getScheme() + "://" + url.getHost() ;
String payResultUrl = payLocalUrl + request.getAttribute("payResultUrl").toString();

String sysMode = System.getProperty("SYSTEM_MODE");



%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no" />

<link rel="stylesheet" href="/css/tpay/nyroModal.tpay.custom.css" type="text/css" media="screen" />
<script type="text/javascript" src="/js/tpay/jquery-1.7.2.js"></script>
<script type="text/javascript" src="/js/tpay/jquery.nyroModal.tpay.custom.js"></script>
<script type="text/javascript" src="/js/tpay/client.tpay.webtx.js"></script>
<script>

var resultUrl = "<%=payResultUrl%>";

$(document).ready(function (){
	try {
		$("#submitBtn").trigger("click");
	} catch (Exception) {
		alert("fnSubmit failed...");
	}
});

function receiveMsg(e) {
	var data;
	
	if(getInternetExplorerVersion() <= 9) {
		data = e.data.split(",");
	} else {
		data = e.data;
	}
	var statusCI = data[0];
	var resultStr = data[1];
	var url = data[2];
	
	if(statusCI == '0') {
		displayShow();
	} else if(statusCI == '1') {
		payWinClose();
		parent.Webcrea.CloseLayer('rundlg');
	} else if(statusCI == '2') {
		resultResponseIframe(data);
	} else if(statusCI == '-1') {
		alert(resultStr);
		payWinClose();
	} else if(statusCI == '3') {
		resultResponseIframeUrl(data, url);
	}
}

</script>

</head>

<body >
<form id="transMgr" name="transMgr" method="post" action="<%=payActionUrl %>/webTxInit" class="nyroModal" target="_blank">

	<input type="hidden" name="merchantKey" value="<%=merchantKey%>">
	<input type="hidden" name="moid"	value="<%=moid%>">
	<input type="hidden" name="mid"	value="<%=mid%>">
	<input type="hidden" name="goodsName"	value="<%=goodsName%>">
	<input type="hidden" name="amt"	value="<%=amt%>">
	<input type="hidden" name="mallUserId"	value="<%=mallUserId%>">
	<input type="hidden" name="buyerName"	value="<%=buyerName%>">
	<input type="hidden" name="buyerEmail"	value="">
	<input type="hidden" name="payMethod"	value="<%=payMethod%>">
	<input type="hidden" name="ediDate"	value="<%=ediDate%>">
	<input type="hidden" name="encryptData" value="<%=encryptData%>">
	<input type="hidden" name="vbankExpDate" value="<%=vbankExpDate%>">
	<input type="hidden" name="mallIp" value="<%=mallIp%>">
	<input type="hidden" name="userIp"	value="<%=userIp%>">
	<input type="hidden" name="resultYn" value="Y">
	<input type="hidden" name="domain" value="<%=domain%>">
	<input type="hidden" name="transType" value="0">
	<input type="hidden" name="mallReserved" value="">
	<input type="button" id="submitBtn" value="">
</form>

<div id="resultDiv"></div>

</body>
<%
}catch(Exception e){
	out.println(e.toString());
}
%>
</html>