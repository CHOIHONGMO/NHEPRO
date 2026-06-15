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
		<h2 class="sr-only">서비스안내</h2>
		<div class="title">
			<p>서비스안내</p>
		</div>
		<div class="box">
			<div>
				<ul class="nav nav-pills" id="pills-tab" role="tablist">
					<li class="nav-item">
						<a class="nav-link active" href="sub_01.jsp">FIRSTePro란?</a>
					</li>
					<li class="nav-item">
						<a class="nav-link" href="sub_02.jsp">협력사관리</a>
					</li>
					<li class="nav-item">
						<a class="nav-link" href="sub_03.jsp">전자입찰</a>
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
						<div class="contents">

							<!-- S Tab -->
							<div class="tab-btn" id="tab-btn">
								<ul class="clearfix">
									<li class="tab-item active"><a href="#">서비스 소개</a></li>
									<li class="tab-item"><a href="#">특징</a></li>
									<li class="tab-item"><a href="#">주요서비스 안내</a></li>
									<li class="tab-item"><a href="#">도입효과</a></li>
									<li class="tab-item"><a href="#">관련법령</a></li>
								</ul>
							</div>
							<!-- E Tab -->

							<!-- S tab content -->
							<div class="tab_content" id="tab-content">

								<!-- S content-01 -->
								<div class="content content-01">
									<nav aria-label="breadcrumb">
										<ol class="breadcrumb">
											<li class="breadcrumb-item"><a href="#">서비스안내</a></li>
											<li class="breadcrumb-item"><a href="#">FIRSTePro란?</a></li>
											<li class="breadcrumb-item active" aria-current="page">서비스 소개</li>
										</ol>
									</nav>
									<div class="img"><img src="/images/nhepro/common/sub_01.png" alt=""></div>
								</div>
								<!-- E content-01 -->

								<!-- S content-02 -->
								<div class="content content-02">
									<nav aria-label="breadcrumb">
										<ol class="breadcrumb">
											<li class="breadcrumb-item"><a href="#">서비스안내</a></li>
											<li class="breadcrumb-item"><a href="#">FIRSTePro란?</a></li>
											<li class="breadcrumb-item active" aria-current="page">특징</li>
										</ol>
									</nav>
									<ul class="f-list">
										<li class="f-item">
											<i class="fal fa-tasks"></i>
											<span class="title">품목의 체계적 관리</span>
											<span class="desc">거래 품목을 전자 카탈로그로 구현하여 품목정보를 체계적으로 통합 관리합니다.</span>
										</li>
										<li class="f-item">
											<i class="fal fa-stamp"></i>
											<span class="title">계약 업무의 표준화</span>
											<span class="desc">표준 계약서식을 사용하여 계약정보를 통합관리하고 시스템을 통한 계약 체결로 대면 계약 서명을 위한
                                          이동시간을 제거하여 업무 효율을 높일 수 있습니다.</span>
										</li>
										<li class="f-item">
											<i class="fal fa-database"></i>
											<span class="title">효율적 자료 관리</span>
											<span class="desc">수기로 관리하던 계약 서류를 데이터로 관리하여 검색 효율을 높이고 보관 비용을 절감합니다.</span>
										</li>
										<li class="f-item">
											<i class="fal fa-route-interstate"></i>
											<span class="title">문서 위변조 방지</span>
											<span class="desc">계약 당사자간 서명한 계약 서류는 인증 기관의 시점 확인(TSA)으로 문서의 신뢰성을 보증합니다.</span>
										</li>
										<li class="f-item">
											<i class="fal fa-clock"></i>
											<span class="title">실시간 정보 제공</span>
											<span class="desc">다양한 업무 단계의 진행상황을 실시간 확인이 가능합니다.</span>
										</li>
									</ul>
								</div>
								<!-- E content-02 -->

								<!-- S content-03 -->
								<div class="content content-03">
									<nav aria-label="breadcrumb">
										<ol class="breadcrumb">
											<li class="breadcrumb-item"><a href="#">서비스안내</a></li>
											<li class="breadcrumb-item"><a href="#">FIRSTePro란?</a></li>
											<li class="breadcrumb-item active" aria-current="page">주요서비스 안내</li>
										</ol>
									</nav>
									<ul class="f-list">
										<li class="f-item">
											<i class="fal fa-boxes-alt"></i>
											<span class="title">통합 구매관리</span>
											<span class="desc">구매 의뢰에서 견적, 입찰, 계약까지 통합된 구매업무 관리</span>
										</li>
										<li class="f-item">
											<i class="fal fa-file-certificate"></i>
											<span class="title">보증보험 연계</span>
											<span class="desc">보증보험사 연계를 통한 업무 간소화 및 효율화</span>
										</li>
										<li class="f-item">
											<i class="fal fa-alarm-clock"></i>
											<span class="title">실시간 알림 서비스</span>
											<span class="desc">업무 진행 단계별 SMS/E-mail 알림 서비스</span>
										</li>
										<li class="f-item">
											<i class="fal fa-search"></i>
											<span class="title">안전한 문서 보관/검색 서비스</span>
											<span class="desc">문서 보관의 안전성을 확보하기 위해 암호화하여 보관하고 검색엔진을 이용한 효율적 검색</span>
										</li>
									</ul>
								</div>
								<!-- E content-03 -->

								<!-- S content-04 -->
								<div class="content content-04">
									<nav aria-label="breadcrumb">
										<ol class="breadcrumb">
											<li class="breadcrumb-item"><a href="#">서비스안내</a></li>
											<li class="breadcrumb-item"><a href="#">FIRSTePro란?</a></li>
											<li class="breadcrumb-item active" aria-current="page">도입효과</li>
										</ol>
									</nav>
									<ul class="f-list">
										<li class="f-item">
											<i class="fal fa-hand-holding-usd"></i>
											<span class="title">구매원가 및 비용절감</span>
											<span class="desc">- IT통합구매로 물량통합을 통하여 구매원가 절감<br/>- 업무 간소화를 통한 계약기간 단축으로 간접원가 절감</span>
										</li>
										<li class="f-item">
											<i class="fal fa-plus-circle"></i>
											<span class="title">구매업무 생산성 증대</span>
											<span class="desc">- 구매처리 업무 프로세스 간소화<br/>- 계약서등 관련 문서 시스템 관리로 관리인력 및 공간 절약</span>
										</li>
										<li class="f-item">
											<i class="fal fa-info-circle"></i>
											<span class="title">거래 투명성 강화 및 정보공유 확대</span>
											<span class="desc">- 실시간 처리를 통한 거래 투명성 강화<br/>- 계약정보의 검색/조회 기능 제공 및 계약정보 재활용 가능</span>
										</li>
										<li class="f-item">
											<i class="fal fa-shield-check"></i>
											<span class="title">보안강화</span>
											<span class="desc">- 보안솔루션 적용을 통한 농협 보안규정 준수 및 사이버 위협 대응<br/>- 법인별 사용자별 권한관리로 정보의 접근통제 강화</span>
										</li>
									</ul>
								</div>
								<!-- E content-03 -->

								<!-- S content-03 -->
								<div class="content content-05">
									<nav aria-label="breadcrumb">
										<ol class="breadcrumb">
											<li class="breadcrumb-item"><a href="#">서비스안내</a></li>
											<li class="breadcrumb-item"><a href="#">FIRSTePro란?</a></li>
											<li class="breadcrumb-item active" aria-current="page">관련법령</li>
										</ol>
									</nav>
									<ul class="f-list">
										<li class="f-item">
											<i class="fal fa-money-check-edit"></i>
											<span class="title">전자문서 및 전자거래 기본법</span>
											<p class="desc">
                        <span class="c-lg">- <span class="font-weight-bold">제4조 1항</span>: 전자문서는 다른 법률에 특별한 규정이 있는 경우를 제외하고는 전자적 형태로 되어 있다는 이유로
  문서로서의 효력이 부인되지 아니한다.</span>
												<span class="c-lg">- <span class="font-weight-bold">제4조 3항</span>: 별표에서 정하고 있는 법률에 따른 기록, 보고, 보관, 비치 또는 작성 등의 행위가 전자 문서로 행하여진
  경우 해당 법률에 따른 행위가 이루어진 것으로 본다.</span>
											</p>
										</li>
										<li class="f-item">
											<i class="fal fa-gavel"></i>
											<span class="title">전자서명법</span>
											<p class="desc">
                        <span class="c-lg">- <span class="font-weight-bold">제3조 1항</span>: 다른 법령에서 문서 또는 서면에 서명, 서명날인 또는 기명날인을 요하는 경우 전자문서에
  공인전자서명이 있는 때에는 이를 충족한 것으로 본다.</span>
												<span class="c-lg">- <span class="font-weight-bold">제4조 3항</span>: 별표에서 정하고 있는 법률에 따른 기록, 보고, 보관, 비치 또는 작성 등의 행위가 전자 문서로 행하여진
  경우 해당 법률에 따른 행위가 이루어진 것으로 본다.</span>
												<span class="c-lg">- <span class="font-weight-bold">제4조 3항</span>: 공인전자서명 외의 전자서명은 당사자간의 약정에 따른 서명, 서명날인 또는 기명날인으로서의
  효력을 가진다.</span>
											</p>
										</li>
									</ul>
								</div>
								<!-- E content-03 -->
							</div>
							<!-- E tab content -->
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
