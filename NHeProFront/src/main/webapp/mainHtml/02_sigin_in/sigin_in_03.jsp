<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="ko">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
	<meta name="Referrer" content="origin">
	<meta http-equiv="X-UA-Compatible" content="IE=Edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<meta name="apple-mobile-web-app-title" content="FIRSTePro"/>
	<meta name="robots" content="index,nofollow"/>
	<meta name="description" content="FIRSTePro"/>
	<meta name="keywords" content="FIRSTePro"/>
	<meta name="format-detection" content="telephone=no"/>
	<title>FIRSTePro 빠르고 투명한 전자구매/계약 서비스</title>
	<link rel="stylesheet" href="/css/nhepro/fonts/NanumGothic.css">
	<link rel="stylesheet" href="/css/nhepro/bootstrap.min.css">
	
	<script type="text/javascript" src="/js/jquery-3.2.1.min.js"></script>
	<script type="text/javascript" src="/js/nhepro/bundle.js"></script>
	<script type="text/javascript" src="/js/everuxf/everuxf.min.js"></script>
	<script type="text/javascript" src="/js/everuxf/lic/licenseKey.js"></script>
	<script type="text/javascript" src="/js/ever-popup.js"></script>
	<script type="text/javascript" src="/js/ever-string.js"></script>
    <script>
        function doHome() {
          location.href = "/welcome.so";
        }
    </script>
</head>

<body>
<div class="wrap">
    <c:import url="../header/header.jsp" charEncoding="UTF-8"/>
	<section class="personal sign_in">
		<h2 class="sr-only">회원가입</h2>
		<div class="title">
			<p>회원가입</p>
		</div>
		<div class="box">
			<div class="content">
				<div class="clearfix pb-3">
					<ul class="step">
						<li class="active">STEP 1. 약관동의</li>
						<li class="active">STEP 2. 정보입력</li>
						<li class="current">STEP 3. 가입완료</li>
					</ul>
				</div>
				<div class="p-content">
					<div class="p-text">
						<p><i class="fas fa-check"></i></p>
						<div>
							<p class="text">회원가입이 <span class="font-weight-bold">완료되었습니다.</span></p>
							<p class="text-sm" style="font-size: 24px">거래희망 고객사 담당자에게 가입 승인을 위한 SMS 발송이 완료되었으며,</p>
							<p class="text-sm" style="font-size: 24px">담당자의 승인 이후 로그인가능합니다.</p>
							<p class="text-sm" style="font-size: 24px;margin-top: 10px;">빠른 승인처리를 원하시면,</p>
							<p class="text-sm" style="font-size: 24px">참여하고자 하는 입찰공고의  <span class="font-weight-bold">'입찰사무관련문의'</span> 담당자에게 연락바랍니다.</p>
							<p class="text-sm" style="font-size: 24px">감사합니다.</p>
						</div>
					</div>
				</div>
				<div class="p-content">
					<div class="btn-area single">
						<button class="btn btn-xl btn-primary" onclick="doHome();">메인화면으로 이동</button>
					</div>
				</div>
			</div>
		</div>
	</section>
    <c:import url="../footer/footer.jsp" charEncoding="UTF-8"/>
</div>
</body>
</html>
