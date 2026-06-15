<!--
날짜 : 2020.04.30
작성자 : 이주연
내용 : FAQ 페이지 추가
-->
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="ko">

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="Referrer" content="origin">
    <meta http-equiv="X-UA-Compatible" content="IE=Edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="apple-mobile-web-app-title" content="FIRSTePro" />
    <meta name="robots" content="index,nofollow" />
    <meta name="description" content="FIRSTePro" />
    <meta name="keywords" content="FIRSTePro" />
    <meta name="format-detection" content="telephone=no" />
    <title>FIRSTePro 빠르고 투명한 전자구매/계약 서비스</title>
	<link rel="stylesheet" href="/css/nhepro/notice/common.css" type="text/css">
	<link rel="stylesheet" href="/css/nhepro/notice/layout.css" type="text/css">
	<link rel="stylesheet" href="/css/nhepro/notice/page.css" type="text/css">
	<link rel="stylesheet" href="/css/nhepro/notice/paging.css" type="text/css">
	<link rel="stylesheet" href="/css/nhepro/fonts/NanumGothic.css">
	<link rel="stylesheet" href="/css/nhepro/bootstrap.min.css">

	<script type="text/javascript" src="/js/jquery-3.2.1.min.js"></script>
	<script type="text/javascript" src="/js/nhepro/notice/jquery.bootpag.js"></script>
	<script type="text/javascript" src="/js/nhepro/notice/jquery.bxslider.js"></script>
	<script type="text/javascript" src="/js/nhepro/notice/common.js"></script>
	<script type="text/javascript" src="/js/ever-string.js"></script>
	<script type="text/javascript" src="/js/ever-popup.js"></script>
    <script>
        $(document).ready(function() {
            $(".set > a").on("click", function() {
                if ($(this).hasClass("active")) {
                    $(this).removeClass("active");
                    $(this)
                        .siblings(".content")
                        .slideUp(100);
                } else {
                    // $(".set > a").removeClass("active");
                    $(this).addClass("active");
                    // $(".content").slideUp(200);
                    $(this)
                        .siblings(".content")
                        .slideDown(100);
                }
            });
        });
    </script>
</head>

<body>
    <div class="wra sub">
        <!--header_wrap-->
        <c:import url="../header/header.jsp" charEncoding="UTF-8"/>
        <!--// header_wrap-->

        <section class="service">
            <h2 class="sr-only">고객지원센터</h2>
            <div class="title">
                <p>고객지원센터</p>
            </div>
            <div class="box">
                <div>
                    <ul class="nav nav-pills" id="pills-tab" role="tablist">
                        <li class="nav-item">
                            <a class="nav-link nav-link3" href="/mainHtml/03_customer/03_notice_list.jsp">공지사항</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link nav-link3 " href="/mainHtml/03_customer/03_notice_list2.jsp">입찰공고</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link nav-link3 active" href="/mainHtml/03_customer/faq.jsp">FAQ</a>
                        </li>
                    </ul>
                </div>
                <!-- S content-01 -->
                <div class="content content-01">
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item"><a href="#">고객지원센터</a></li>
                            <li class="breadcrumb-item active"><a href="#">FAQ</a></li>
                        </ol>
                    </nav>
                </div>
            </div>
        </section>

        <section class="faq">
            <div class="box">
                <div class="tab_faq">
                    <ul class="nav nav-pills" role="tablist">
                        <li class="nav-item">
                            <a class="nav-link" href="faq.jsp">고객사</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link active" href="faq2.jsp">공급사</a>
                        </li>
                    </ul>
                    <div class="accordion-wrap">
                        <div class="accordion-container">
                            <p class="p-title">개요 및 회원관리</p>
                            <div class="set">
                                <a href="#">
                                    <i class="icon-q">Q</i>
                                    전자구매/계약 서비스가 무엇인가요?
                                </a>
                                <div class="content">
                                    <ul>
                                        <li><i class="icon-a">A</i>FIRSTePro(전자구매/계약 서비스)는 기업간(B2B)에 발생하는 입찰 및 계약 업무 효율성 증대를 위해 비대면으로 온라인상에서 계약을 체결할 수 있도록<br />
                                            지원하며 구매의뢰, 입찰공고, 계약, 검수, 정산까지 통합으로 관리하는 통합전자구매시스템 입니다.</li>
                                    </ul>
                                </div>
                            </div>
                            <div class="set">
                                <a href="#">
                                    회원가입은 어떻게 하나요?
                                    <i class="icon-q">Q</i>
                                </a>
                                <div class="content">
                                    <ul>
                                        <li><i class="icon-a">A</i>신규가입은 우측 상단의 회원가입을 클릭 후 가입 절차대로 진행합니다.</li>
                                        <li>등록 완료후 고객사의 사용 승인을 득한 후 접속 가능합니다.</li>
                                    </ul>
                                </div>
                            </div>
							<div class="set">
								<a href="#">
									<i class="icon-q">Q</i>
									아이디 찾기, 비밀번호 재설정은 어떻게 하나요?
								</a>
								<div class="content">
									<ul>
										<li><i class="icon-a">A</i>로그인 버튼 바로 아래의 [아이디/패스워드 찾기]를 클릭합니다.</li>
									</ul>
								</div>
							</div>
							<div class="set">
								<a href="#">
									<i class="icon-q">Q</i>
									공인인증서가 필요하나요? 그렇다면 등록은 어떻게 하나요?
								</a>
								<div class="content">
									<ul>
										<li><i class="icon-a">A</i>입찰신청 및 계약등의 주요 업무를 진행하기 위하여 반드시 필요합니다.<br>
										우측 하단의 [공인인증서 발급]을 클릭하여 필요 항목을 진행하시면 됩니다.</li>
									</ul>
								</div>
							</div>
							<div class="set">
								<a href="#">
									<i class="icon-q">Q</i>
									상세 문의는 어떻게 하면 되나요?
								</a>
								<div class="content">
									<ul>
										<li><i class="icon-a">A</i>고객센터(031-738-8157)로 문의하시면 됩니다. (이용시간: 평일 09:00 ~ 18:00, 점심시간: 12:00 ~ 13:00)</li>
									</ul>
								</div>
							</div>
                        </div>
                    </div>
                    <div class="accordion-wrap">
                        <div class="accordion-container">
                            <p class="p-title">구매관리</p>
                            <div class="set">
                                <a href="#">
                                    <i class="icon-q">Q</i>
                                    견적(수의시담)진행은 어떻게 하나요?
                                </a>
                                <div class="content">
                                    <ul>
                                        <li><i class="icon-a">A</i>[구매관리 >> 견적관리 >> 견적현황] 화면에서 진행중인 견적요청건의 목록이 조회됩니다.</li>
                                        <li>견적서를 작성할 요청건을 접수하고 견적서를 작성합니다.</li>
                                        <li>작성된 견적서는 공인인증서를 통하여 제출됩니다.</li>
                                        <li>[구매관리 >> 견적관리 >> 견적결과] 화면에서 개찰결과를 조회합니다.</li>
                                    </ul>
                                </div>
                            </div>
                            <div class="set">
                                <a href="#">
                                    입찰진행은 어떻게 하나요?
                                    <i class="icon-q">Q</i>
                                </a>
                                <div class="content">
                                    <ul>
                                        <li><i class="icon-a">A</i>[구매관리 >> 입찰관리 >> 입찰참가신청] 화면에서 입찰공고를 조회합니다.</li>
                                        <li>해당건을 선택하여 입찰 참가신청서를 작성합니다.</li>
                                        <li>작성된 신청서는 공인인증서를 통하여 제출됩니다.</li>
                                        <li>[구매관리 >> 입찰관리 >> 가격입찰] 화면에서 입찰참가 가능여부를 확인하고 입찰서를 제출합니다.</li>
                                        <li>작성된 입찰서는 공인인증서를 통하여 제출됩니다.</li>
                                        <li>[구매관리 >> 입찰관리 >> 견적결과] 화면에서 입찰결과를 조회합니다.</li>
                                    </ul>
                                </div>
                            </div>
                            <div class="set">
                                <a href="#">
                                    계약은 어떻게 진행하나요?
                                    <i class="icon-q">Q</i>
                                </a>
                                <div class="content">
                                    <ul>
                                        <li><i class="icon-a">A</i>낙찰된 협력업체는 [구매관리 >> 전자계약 >> 계약진행현황] 화면에서 계약요청내역을 조회합니다.</li>
                                        <li>해당건을 선택하여 계약서를 작성합니다.</li>
                                        <li>작성된 계약서는 공인인증서를 통하여 제출됩니다.</li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    
                    
                    
                    <div class="accordion-wrap">
                        <div class="accordion-container">
                            <p class="p-title">발주관리</p>
                            <div class="set">
                                <a href="#">
                                    <i class="icon-q">Q</i>
                                    발주는 어떻게 관리되나요?
                                </a>
                                <div class="content">
                                    <ul>
                                        <li><i class="icon-a">A</i>계약이 체결된 협력업체는 [발주관리 >> 발주관리 >> 발주접수현황] 화면에서 발주요청내역을 조회합니다.
                                        <br>해당건을 선택하여 발주 접수처리 합니다.</li>
                                    </ul>
                                </div>
                            </div>
                            <div class="set">
                                <a href="#">
                                    검수는 어떻게 관리되나요?
                                    <i class="icon-q">Q</i>
                                </a>
                                <div class="content">
                                    <ul>
                                        <li><i class="icon-a">A</i>협력업체는 [발주관리 >> 전체검수관리 >> 검수요청대상현황] 화면에서 검수요청대상내역을 조회합니다.
                                        <br>해당건을 선택하여 검수요청서를 작성합니다.</li>
                                        <li>작성된 요청서는 공인인증서를 통하여 제출됩니다.</li>
                                        <li>[발주관리 >> 전체검수관리 >> 검수요청현황] 화면에서 요청된 검수건의 처리현황을 조회합니다.</li>
                                    </ul>
                                </div>
                            </div>
                            <div class="set">
                                <a href="#">
                                    대금청구는 어떻게 진행되나요?
                                    <i class="icon-q">Q</i>
                                </a>
                                <div class="content">
                                    <ul>
                                        <li><i class="icon-a">A</i>협력업체는 [발주관리 >> 대금지급 >> 대금지급요청대상현황] 화면에서 대금지급요청대상내역을 조회합니다.</li>
                                        <li>해당건을 선택하여 대금지급요청서를 작성합니다.</li>
                                        <li>작성된 요청서는 공인인증서를 통하여 제출됩니다.</li>
                                        <li>[발주관리 >> 대금지급 >> 대금지급현황] 화면에서 요청된 대금지급건의 처리현황을 조회합니다.</li>
                                    </ul>
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
