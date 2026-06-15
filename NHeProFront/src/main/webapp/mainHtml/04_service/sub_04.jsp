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
		<h2 class="sr-only">전자계약</h2>
		<div class="title">
			<p>전자계약</p>
		</div>
		<div class="box">
			<div>
				<ul class="nav nav-pills" id="pills-tab" role="tablist">
					<li class="nav-item">
						<a class="nav-link " href="sub_01.jsp">FIRSTePro란?</a>
					</li>
					<li class="nav-item">
						<a class="nav-link" href="sub_02.jsp">협력사관리</a>
					</li>
					<li class="nav-item">
						<a class="nav-link" href="sub_03.jsp">전자입찰</a>
					</li>
					<li class="nav-item">
						<a class="nav-link active" href="sub_04.jsp">전자계약</a>
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
								<li class="breadcrumb-item active" aria-current="page">전자계약</li>
							</ol>
						</nav>
						<div class="content content-sm">
							<div class="c-title">전자계약</div>
							<p class="c-desc">각종 계약서, 위임장을 전자문서로 구현하여 비대면 업무처리와 문서보안을 지원하고 신속한 계약업무 처리가
								<br/>가능하도록 지원합니다.
							</p>
							<div class="c-img-03">
								<img src="/images/nhepro/common/img_04_01.png" alt="">
							</div>
							<ul class="c-list4">
								<li>
									<span class="c-header">계약정보<br/>DB화</span>
									<p class="c-item">
										<span>입력된 주요 정보를 기준으로 계약정보를 실시간 조회하고 계약서를 다운로드</span>
										<span>전자문서를 암호화하여 보관하여 문서의 안전성과 신뢰성을 보장하고 편리한 검색 기능 제공</span>
									</p>
								</li>
								<li>
									<span class="c-header">계약업무의<br/>신속화</span>
									<p class="c-item">
										<span>업체선정 정보 및 표준 계약서식 활용으로 계약서 작성 시간을 단축</span>
										<span>인증시스템 및 블록체인을 통한 문서의 위변조 방지 및 보안강화</span>
									</p>
								</li>
								<li>
									<span class="c-header">계약정보<br/>체계적관리</span>
									<p class="c-item">
										<span>공고에서 사업자 선정까지 리드타임을  최소화 </span>
										<span>비대면 업무 처리를 통하여 신속한 업무처리와 비용절감 효과</span>
									</p>
								</li>
							</ul>
							<div class="c-title c-title-lg">주요기능</div>
							<ul class="c-list3">
								<li>
									<span class="top">디지털 전자문서 사용</span>
									<span class="bottom">계약서, 위임장의 전자문서 서식을 통하여 종이없는 업무환경구성</span>
								</li>
								<li>
									<span class="top">안전한 문서보관 및 검색기능 제공</span>
									<span class="bottom">작성된 전자문서는 시스템에 안전하게 보관되며 검색기능을 통하여 손쉽게 찾아볼 수 있습니다.</span>
								</li>
								<li>
									<span class="top">전자인증기반의 본인인증을 통한 전자서명으로 간편하고 신속한 업무 처리</span>
									<span class="bottom line-2">공인인증 및 블록체인을 통하여 본인인증을  진행하고 비대면 업무처리를 통하여 신속한 업무처리를<br/>지원합니다.</span>
								</li>
								<li>
									<span class="top">블록체인 시점확인 증명을 통하여 전자문서(PDF) 위변조 방지</span>
									<span class="bottom">저장된 PDF 전자문서는 시점확인(타임스탬프) 기능을 이용하여 위변조 및 부인방지 기능을 지원합니다.</span>
								</li>
								<li>
									<span class="top">전자근로계약 지원</span>
									<span class="bottom line-2">회사와 근로자간의 근로계약을 위한 전자근로계약기능을 지원하며 SMS 및 e-mail을 통하여<br/>쉽고 빠르게 계약이 가능합니다. </span>
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
