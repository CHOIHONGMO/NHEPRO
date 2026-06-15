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
</head>

<body>
<div class="wrap sub">
	<!--header_wrap-->
	<c:import url="../header/header.jsp" charEncoding="UTF-8"/>
	<!--// header_wrap-->

	<section class="service">
		<h2 class="sr-only">전자세금계산서</h2>
		<div class="title">
			<p>전자세금계산서</p>
		</div>
		<div class="box">
			<div>
				<ul class="nav nav-pills" id="pills-tab" role="tablist">
					<li class="nav-item">
						<a class="nav-link " href="sub_01.jsp">FIRSTePro란?</a>
					</li>
					<li class="nav-item">
						<a class="nav-link " href="sub_02.jsp">협력사관리</a>
					</li>
					<li class="nav-item">
						<a class="nav-link" href="sub_03.jsp">전자입찰</a>
					</li>
					<li class="nav-item">
						<a class="nav-link" href="sub_04.jsp">전자계약</a>
					</li>
					<li class="nav-item">
						<a class="nav-link active" href="sub_05.jsp">전자세금계산서</a>
					</li>
				</ul>
				<div class="tab-content">
					<div class="tab-pane show active">
						<nav aria-label="breadcrumb">
							<ol class="breadcrumb">
								<li class="breadcrumb-item"><a href="#">서비스안내</a></li>
								<li class="breadcrumb-item active" aria-current="page">전자세금계산서</li>
							</ol>
						</nav>
						<div class="content content-sm">
							<div class="c-title">전자세금계산서</div>
							<p class="c-desc">전자세금계산서 발행 및 관리를 무료가입하여 사용할 수 있습니다. 초보자도 세금계산서를 쉽게 관리할 수 있고
								<br/>확장성을 고려하려 전문화된 전자문서 관리를 지원합니다.</p>
							<div class="c-img-04">
								<img src="/images/nhepro/common/img_05.png" alt="">
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</section>
	<!--footer_wrap-->
	<c:import url="../footer/footer.jsp" charEncoding="UTF-8"/>
	<!--// footer_wrap-->

</div>
</body>
</html>