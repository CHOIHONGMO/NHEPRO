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
		<h2 class="sr-only">전자입찰</h2>
		<div class="title">
			<p>전자입찰</p>
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
						<a class="nav-link active" href="sub_03.jsp">전자입찰</a>
					</li>
					<li class="nav-item">
						<a class="nav-link" href="sub_04.jsp">전자계약</a>
					</li>
					<li class="nav-item">
						<a class="nav-link" href="sub_05.jsp">전자세금계산서</a>
					</li>
				</ul>
				<div class="tab-content">
					<div class="tab-pane show active">
						<nav aria-label="breadcrumb">
							<ol class="breadcrumb">
								<li class="breadcrumb-item"><a href="#">서비스안내</a></li>
								<li class="breadcrumb-item active" aria-current="page">전자입찰</li>
							</ol>
						</nav>
						<div class="content content-sm">
							<div class="c-title">전자입찰</div>
							<p class="c-desc">입찰 전과정을 시스템으로 처리하여 입찰관리의 투명성 및 기밀성을 보장하고 신속한 입찰업무 처리를 지원합니다.</p>
							<div class="c-img-01">
								<img src="/images/nhepro/common/img_03_01.png" alt="">
							</div>
							<div class="c-img-02">
								<img src="/images/nhepro/common/img_03_02.png" alt="">
							</div>
							<ul class="c-list4">
								<li>
									<span class="c-header">입찰정보의<br/>기밀성 확보</span>
									<p class="c-item">
										<span>견적정보의 개찰시간 관리로 사전 견적정보 유출을 예방</span>
										<span>기술 및 가격 평가정보의 취급자를 지정하여 관련정보의 사전 유출을 방지﻿</span>
									</p>
								</li>
								<li class="lg">
									<span class="c-header">입찰과정의<br/>투명성 확보</span>
									<p class="c-item">
										<span>견적정보는 암호화하여 저장되고 인증서에 의해 복호화되며 개찰시간 이전에는 정보의<br/>접근이 불가능</span>
										<span>업무 권한 이외의 사용자는 정보의 접근이 불가능</span>
									</p>
								</li>
								<li>
									<span class="c-header">입찰업무의<br/>신속성 확보</span>
									<p class="c-item">
										<span>입찰 의뢰 및 주요 마스터 정보를 기준으로 업무를 진행하여 준비 시간을 단축</span>
										<span>입찰과정을 실시간으로 처리하여 입찰공고 에서 사업자 선정까지 리드타임을  최소화    </span>
									</p>
								</li>
							</ul>
							<div class="c-title c-title-lg">주요기능</div>
							<ul class="c-list3">
								<li>
									<span class="top">시스템을 통한 입찰등록 및 입찰공고</span>
									<span class="bottom line-2">입찰등록 및 입찰공고를 시스템을 통하여 진행하고 입찰가, 평가결과가 신속하고 투명하게 관리되도록<br/>지원합니다.</span>
								</li>
								<li>
									<span class="top">시스템을 통한 적격심사 및 기술평가 관리</span>
									<span class="bottom line-2">협력업체의 기술제안서를 심사하여 가격제안서 제출대상 협력업체를 선별하고 선별된 협력업체의 가격제안서를접수하고 비교하여 낙찰업체 선정을 시스템으로 진행하도록 지원합니다.</span>
								</li>
								<li>
									<span class="top">투명한 입찰관리</span>
									<span class="bottom line-2">견적정보는 암호화되어 저장되고 개찰시간 이전에는 정보의 접근이 불가능하도록 관리되어 투명한 입찰<br/>진행이 가능합니다.</span>
								</li>
								<li>
									<span class="top">신용평가 연동하여 사전 모니터링 지원</span>
									<span class="bottom line-2">사전에 고객사와 정보제공에 대해 약정된 신용평가 기관과 연계하여 협력업체의 기업정보, 신용등급, 재무제표<br/>등의 정보조회 기능을 제공하여 사전 위험 모니터링에 활용합니다./계약시스템을 사용할 수 있도록 지원합니다.</span>
								</li>
								<li>
									<span class="top">입찰등록 및 보증보험 연계를 통하여 전자계약 진행</span>
									<span class="bottom line-2">입찰을 통하여 선정된 업체가 전자계약을 진행하고 보증보험사와 연계하여 보증보험을 발행할 수 있도록<br/>지원합니다.</span>
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
