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
		<h2 class="sr-only">협력사관리</h2>
		<div class="title">
			<p>협력사관리</p>
		</div>
		<div class="box">
			<div>
				<ul class="nav nav-pills" id="pills-tab" role="tablist">
					<li class="nav-item">
						<a class="nav-link " href="sub_01.jsp">FIRSTePro란?</a>
					</li>
					<li class="nav-item">
						<a class="nav-link active" href="sub_02.jsp">협력사관리</a>
					</li>
					<li class="nav-item">
						<a class="nav-link" href="sub_03.jsp">전자입찰</a>
					</li>
					<li class="nav-item">
						<a class="nav-link" href="sub_04.jsp">전자계약</a>
					</li>
					<li class="nav-item">
						<a class="nav-link " href="sub_05.jsp">전자세금계산서</a>
					</li>
				</ul>
				<div class="tab-content">
					<div class="tab-pane show active">
						<nav aria-label="breadcrumb">
							<ol class="breadcrumb">
								<li class="breadcrumb-item"><a href="#">서비스안내</a></li>
								<li class="breadcrumb-item active" aria-current="page">협력사관리</li>
							</ol>
						</nav>
						<div class="content content-sm">
							<div class="c-title">협력사 관리</div>
							<p class="c-desc">협력업체와의 협업체계를 구축하여 Supply Chain 기반을 수립하고 협력업체 내 · 외부 환경분석 및 정보공유
								프로세스를 지원합니다.</p>
							<ul class="c-list clearfix">
								<li>협력업체 등록</li>
								<li class="line-2">협력업체<br/>기본정보 관리</li>
								<li class="line-2">협력업체<br/>정보공유</li>
								<li class="line-2">협력업체<br/>고객의소리</li>
							</ul>
							<ul class="c-list2">
								<li>신규업체의 가입 요청 및 신용평가 기관정보를 활용한 협력업체의 등록</li>
								<li>협력업체 목록 및 업체 상세정보 데이터베이스 관리</li>
								<li>협력업체 계약 · 수주 및 거래실적 및 통계정보 관리</li>
								<li>협력업체와 게시판 및 고객의소리 기능 통한 정보공유 채널 제공</li>
							</ul>
							<div class="c-title c-title-lg">주요기능</div>
							<ul class="c-list3">
								<li>
									<span class="top">협력사 등록 및  기준정보 관리</span>
									<span class="bottom">신규업체를 등록하고 등록업체의 상세정보 및 협력업체 사용자에 대한 정보 관리를 지원합니다.</span>
								</li>
								<li>
									<span class="top">협력업체 거래내역 및 관리정보 </span>
									<span class="bottom">견적요청 및 주문내역, 납품건수, 매출현황 등의 업무 진행정보를 실시간 온라인 제공합니다.</span>
								</li>
								<li>
									<span class="top">고객과의 원활한 소통을 위한 정보공유 기능</span>
									<span class="bottom line-2">공지사항, 게시판, 고객의소리(VOC), 자주하는질문(FAQ) 채널을 통하여 원활한 정보공유가 이루어질 수 있도록 지원합니다.</span>
								</li>
								<li>
									<span class="top">본인확인을 위한 인증처리 기능</span>
									<span class="bottom line-2">공인인증서발급 또는 블록체인 등록을 통한 인증으로 안전하게 전자구매/계약시스템을 사용할 수 있도록 지원합니다.</span>
								</li>
							</ul>
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
