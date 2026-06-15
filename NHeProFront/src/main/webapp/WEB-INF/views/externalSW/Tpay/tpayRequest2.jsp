<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.net.InetAddress" %>
<%@ page import="java.net.URL" %>
<%@ page import="kr.co.tpay.webtx.Encryptor"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>

<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.security.MessageDigest" %>
<%@ page import="org.apache.commons.codec.binary.Hex" %>

<%
try{
	
	response.addHeader("Access-Control-Allow-Origin", "*");

	String payMethod = request.getParameter("payMethod").toString();
	String goodsName = request.getParameter("goodsName") == null || request.getParameter("goodsName")== "" ?  "epro_point" : request.getParameter("goodsName") ;		// 상품명
	String Amt = request.getParameter("total");
	String MID = request.getAttribute("mid").toString();								// 상점 아이디
	String moid = request.getAttribute("moid").toString();							// 상품주문번호
	String buyerName = request.getParameter("buyerName");	// 결재자 이름 한글처리

	String buyerEmail = ""; //구매자이메일 happy@day.co.kr
	String buyerTel = ""; //구매자연락처 01000000000

	String payResultUrl = request.getAttribute("payResultUrl").toString();

	String VbankExpDate = ""; // 가상계좌입금만료일(YYYYMMDD)

	//옵션
	String GoodsCl = "1"; // <!-- 상품구분(실물(1),컨텐츠(0)) -->
	String TransType = "0"; // <!-- 일반(0)/에스크로(1) --> 
	String CharSet = "utf-8"; // <!-- 응답 파라미터 인코딩 방식 --> 
	String ReqReserved = ""; // <!-- 상점 예약필드 -->

	String merchantKey = request.getAttribute("merchantKey").toString();	//상점키
	merchantKey = StringEscapeUtils.unescapeHtml(merchantKey); // DB에 +가 ASCII 코드인 &#43;로 치환되어서 들어감 -> +로 다시 치환
	String merchantID = MID;
	String price = Amt;

	String ediDate = request.getAttribute("ediDate").toString();	
	String hashString = request.getAttribute("hashString").toString();	
	


%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no" />

<style>
	html,body {height: 100%;}
	form {overflow: hidden;}
</style>
<script type="text/javascript" src="/js/tpay/jquery-1.7.2.js"></script>
<script type="text/javascript" src="/js/tpay/jquery.nyroModal.tpay.custom.js"></script>
<script type="text/javascript" src="/js/tpay/client.tpay.webtx.js"></script>
<script type="text/javascript" src="/js/nicepay/nicepay-3.0.js"></script>
<script>


$(document).ready(function (){
	

	try {
		goPay(document.payForm);

	} catch (Exception) {
		alert("fnSubmit failed...");
	}
});



//[PC 결제창 전용]결제 최종 요청시 실행됩니다. <<'nicepaySubmit()' 이름 수정 불가능>>
function nicepaySubmit(){

	document.payForm.submit();
}

//[PC 결제창 전용]결제창 종료 함수 <<'nicepayClose()' 이름 수정 불가능>>
function nicepayClose(){
	alert("결제가 취소 되었습니다");
}

</script>

</head>

<body >

<form id="payForm" name="payForm" method="post" action="<%=payResultUrl %>" class="nyroModal" >

		<input type="hidden" name="PayMethod" value="<%=payMethod%>">
		<input type="hidden" name="GoodsName" value="<%=goodsName%>">		
		<input type="hidden" name="Amt" value="<%=price%>">
		<input type="hidden" name="MID" value="<%=merchantID%>">
		<input type="hidden" name="Moid" value="<%=moid%>">
		<input type="hidden" name="BuyerName" value="<%=buyerName%>">
		<input type="hidden" name="BuyerEmail" value="<%=buyerEmail%>">
		<input type="hidden" name="BuyerTel" value="<%=buyerTel%>">
		<input type="hidden" name="VbankExpDate" value="">
		<!-- 옵션 --> 
		<input type="hidden" name="GoodsCl" value="1"/>						<!-- 상품구분(실물(1),컨텐츠(0)) -->
		<input type="hidden" name="TransType" value="0"/>					<!-- 일반(0)/에스크로(1) --> 
		<input type="hidden" name="CharSet" value="utf-8"/>					<!-- 응답 파라미터 인코딩 방식 -->
		<input type="hidden" name="ReqReserved" value=""/>					<!-- 상점 예약필드 -->
					
		<!-- 변경 불가능 -->
		<input type="hidden" name="EdiDate" value="<%=ediDate%>"/>			<!-- 전문 생성일시 -->
		<input type="hidden" name="SignData" value="<%=hashString%>"/>	<!-- 해쉬값 -->
		
		<!-- 최종 db 처리 필요 -->		
	    <input type="hidden" name="payMethod"	value="<%=payMethod%>">	    
		
				

</form>



</body>
<%
}catch(Exception e){
	out.println(e.toString());
}
%>
</html>