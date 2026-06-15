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
                            <a class="nav-link active" href="faq.jsp">발주사</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="faq2.jsp">공급사</a>
                        </li>
                    </ul>
                    <div class="accordion-wrap">
                        <div class="accordion-container">
                            <p class="p-title">개요 및 사용자관리</p>
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
                                    아이디 찾기, 비밀번호 재설정은 어떻게 하나요?
                                    <i class="icon-q">Q</i>
                                </a>
                                <div class="content">
                                    <ul>
                                        <li><i class="icon-a">A</i>로그인 버튼 바로 아래의 [아이디/패스워드 찾기]를 클릭합니다.</li>
                                    </ul>
                                </div>
                            </div>
                            
                            <div class="set">
                                <a href="#">
                                    공인인증서가 필요하나요? 그렇다면 등록은 어떻게 하나요?
                                    <i class="icon-q">Q</i>
                                </a>
                                <div class="content">
                                    <ul>
                                        <li><i class="icon-a">A</i>입찰신청 및 계약등의 주요 업무를 진행하기 위하여 반드시 필요합니다.<br>우측 하단의 [공인인증서 발급]을 클릭하여 필요 항목을 진행하시면 됩니다.</li>
                                    </ul>
                                </div>
                            </div>
                            
                            <div class="set">
                                <a href="#">
                                    상세 문의는 어떻게 하면 되나요?
                                    <i class="icon-q">Q</i>
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
                            <p class="p-title">기준정보</p>
                            <div class="set">
                                <a href="#">
                                    <i class="icon-q">Q</i>
                                    구매하려는 품목이 등록되어 있지 않습니다. 어떻게 하나요?
                                </a>
                                <div class="content">
                                    <ul>
                                        <li><i class="icon-a">A</i>[기준정보 >> 품목관리 >> 품목등록신청] 화면에서 등록요청을 합니다.<br />
                                            관리자는 이를 조회하여 표준품목으로 등록되어 있는지 확인하고 표준품목을 사용하거나 혹은 자체적으로 관리되는 품목으로 생성하여 사용합니다.</li>
                                    </ul>
                                </div>
                            </div>
                            <div class="set">
                                <a href="#">
                                    우리 조합의 협력업체들은 어디서 확인할 수 있으며 어떻게 관리할 수 있나요?
                                    <i class="icon-q">Q</i>
                                </a>
                                <div class="content">
                                    <ul>
                                        <li><i class="icon-a">A</i>[기준정보 >> 협력업체관리 >> 협력업체현황] 화면에서 조회할 수 있습니다.</li>
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
                                    구매의뢰를 하려고 합니다. 어떻게 하나요?
                                </a>
                                <div class="content">
                                    <ul>
                                        <li><i class="icon-a">A</i>구매요청자가 [구매관리 >> 구매의뢰 >> 구매의뢰등록] 화면에서 구매의뢰서를 작성하고 결재를 품의합니다.<br />
                                           	 결재가 승인되면 구매담당자는 [구매관리 >> 구매의뢰접수 >> 담당자지정] 화면에서 담당자를 지정합니다.</li>
                                            <li>지정된 담당자는 [구매관리 >> 구매의뢰접수 >> 구매의뢰접수] 화면에서 접수합니다.</li>
                                    </ul>
                                </div>
                            </div>
                            <div class="set">
                                <a href="#">
                                    견적(수의시담)을 받으려고 합니다. 어떻게 하나요?
                                    <i class="icon-q">Q</i>
                                </a>
                                <div class="content">
                                    <ul>
                                        <li><i class="icon-a">A</i>구매담당자는 [구매관리 >> 구매의뢰접수 >> 구매의뢰접수] 화면에서 구매의뢰 접수된 건중 견적대상을 조회합니다.<br />
                                                                              해당건을 선택하여 견적요청서를 생성하고 결재를 품의합니다.</li>
                                            <li>해당건이 예정가격을 사용할 경우 [구매관리 >> 입찰관리 >> 예정가격] 화면에서 예정가격을 상신하고 확정합니다.</li>
                                            <li>[구매관리 >> 품의관리 >> 선정품의 대기목록] 화면에서 선정된 업체에 대한 선정품의서를 작성합니다.</li>
                                    </ul>
                                </div>
                            </div>
                            
                            
                            
                            <div class="set">
                                <a href="#">
                                    최저가 입찰진행은 어떻게 하나요?
                                    <i class="icon-q">Q</i>
                                </a>
                                <div class="content">
                                    <ul>
                                        <li><i class="icon-a">A</i>구매담당자는 [구매관리 >> 입찰관리 >> 구매의뢰접수] 화면에서 구매의뢰 접수된 건중 입찰대상을 조회합니다.<br />
                                                                              해당건을 선택하여 입찰공고를 생성하고 결재를 품의합니다.</li>
                                            <li>[구매관리 >> 입찰관리 >> 입찰등록] 화면에서 협력업체들이 작성한 입찰참가신청서를 확인하고 입찰등록을 마감합니다.</li>
                                            <li>해당건이 예정가격을 사용할 경우 [구매관리 >> 입찰관리 >> 예정가격] 화면에서 예정가격을 상신하고 확정합니다.</li>
                                            <li>[구매관리 >> 입찰관리 >> 입찰진행] 화면에서 개찰을 하고 입찰에 참여한 협력업체 입찰정보를 참고하여 낙찰자를 선정합니다.</li>
                                            <li>[구매관리 >> 품의관리 >> 선정품의 대기목록] 화면에서 선정된 업체에 대한 선정품의서를 작성합니다.</li>
                                    </ul>
                                </div>
                            </div>
                            
                            
                            
                            <div class="set">
                                <a href="#">
                                    적격심사 입찰진행은 어떻게 하나요?
                                    <i class="icon-q">Q</i>
                                </a>
                                <div class="content">
                                    <ul>
                                        <li><i class="icon-a">A</i>구매담당자는 [구매관리 >> 입찰관리 >> 구매의뢰접수] 화면에서 구매의뢰 접수된 건중 입찰대상을 조회합니다.<br />
                                                                             해당건을 선택하여 입찰공고를 생성하고 결재를 품의합니다.</li>
                                            <li>[구매관리 >> 입찰관리 >> 입찰등록] 화면에서 협력업체들이 작성한 입찰참가신청서를 확인하고 입찰등록을 마감합니다.</li>
                                            <li>해당건이 예정가격을 사용할 경우 [구매관리 >> 입찰관리 >> 예정가격] 화면에서 예정가격을 상신하고 확정합니다.</li>
                                            <li>[구매관리 >> 입찰관리 >> 입찰진행] 화면에서 개찰을 합니다.</li>
                                            <li>[구매관리 >> 입찰관리 >> 입찰진행] 화면에서 입찰에 참여한 협력업체 입찰정보를 참고하여 적격심사 결과를 등록합니다.</li>
                                            <li>[구매관리 >> 품의관리 >> 선정품의 대기목록] 화면에서 선정된 업체에 대한 선정품의서를 작성합니다.</li>
                                    </ul>
                                </div>
                            </div>
                            
                            
                        </div>
                    </div>
                    









                    <div class="accordion-wrap">
                        <div class="accordion-container">
                            <p class="p-title">계약관리</p>
                            <div class="set">
                                <a href="#">
                                    <i class="icon-q">Q</i>
                                    계약은 어떻게 진행하나요?
                                </a>
                                <div class="content">
                                    <ul>
                                        <li><i class="icon-a">A</i>구매담당자는 [계약관리 >> 전자계약 >> 계약대기현황] 화면에서 승인된 선정품의에 대해서 계약서를 생성하고 결재요청합니다.<br />
                                            의뢰법인은 본인이 의뢰한 품목에 대한 계약건에 대하여 계약내용을 검토하고 결재승인을 합니다.</li>
                                            <li>구매담당자는 승인된 내용을 확인하여 결재완료하고 전자계약서를 협력업체에게 전송합니다.</li>
                                            <li>협력업체는 계약내용을 확인하고 전자서명합니다.</li>
                                    </ul>
                                </div>
                            </div>
                            <div class="set">
                                <a href="#">
                                    개인용역계약은 어떻게 관리되나요?
                                    <i class="icon-q">Q</i>
                                </a>
                                <div class="content">
                                    <ul>
                                        <li><i class="icon-a">A</i>근로계약 업무담당자는 [계약관리 >> 개인근로계약 >> 계약서작성] 화면에서 개인용역계약서를 작성합니다.</li>
                                        <li>작성된 계약정보는 근로자에게 SMS로 발송되고 근로자는 Mobile Web으로 계약내용을 조회하고 전자서명을 합니다.</li>
                                    </ul>
                                </div>
                            </div>
                            
                            <div class="set">
                                <a href="#">
                                    위임장은 어떻게 관리되나요?
                                    <i class="icon-q">Q</i>
                                </a>
                                <div class="content">
                                    <ul>
                                        <li><i class="icon-a">A</i>위임업무 수탁담당자는 [계약관리 >> 위임장 >> 위임장요청] 화면에서 위임요청서를 작성합니다.</li>
                                        <li>작성된 위임요청서는 위임고객사의 담당자에게 [계약관리 >> 위임장 >> 위임장현황] 화면에서 조회되고 위임장 서명을 합니다.</li>
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
                                    발주에 대하여 알려 주세요.
                                </a>
                                <div class="content">
                                    <ul>
                                        <li><i class="icon-a">A</i>계약체결에 의하여 발주서가 자동으로 작성되어 협력업체에 전달됩니다.</li>
                                    </ul>
                                </div>
                            </div>
                            <div class="set">
                                <a href="#">
                                    수기발주에 대하여 알려 주세요.
                                    <i class="icon-q">Q</i>
                                </a>
                                <div class="content">
                                    <ul>
                                        <li><i class="icon-a">A</i>[발주관리 >> 발주관리 >> 수기계약생성] 화면에서 구매의뢰 작업없이 발주서를 작성합니다.<br>이 때, 사전에 Off-Line으로 품의작업이 수행되었으면 해당 정보를 첨부합니다.</li>
                                        <li>해당 수기발주서 정보를 결재상신하고 승인이 되면 협력업체에 발주정보가 전달됩니다.</li>
                                    </ul>
                                </div>
                            </div>
                            
                            <div class="set">
                                <a href="#">
                                    검수는 어떻게 진행되나요?
                                    <i class="icon-q">Q</i>
                                </a>
                                <div class="content">
                                    <ul>
                                        <li><i class="icon-a">A</i>검수담당자는 [발주관리 >> 검수 >> 검수대기현황] 화면에서 검수대상을 조회합니다.</li>
                                        <li>요청된 검수정보를 확인하고 검수결과를 등록한 후 결재를 상신합니다.</li>
                                    </ul>
                                </div>
                            </div>
                            

                            <div class="set">
                                <a href="#">
                                    대금지급은 어떻게 관리되나요?
                                    <i class="icon-q">Q</i>
                                </a>
                                <div class="content">
                                    <ul>
                                        <li><i class="icon-a">A</i>구매담당자는 [발주관리 >> 대금지급 >> 대금지급현황] 화면에서 대금지급대상을 조회합니다.</li>
                                        <li>요청된 대금청구정보를 확인하고 확정여부를 등록한 후 결재를 상신합니다.</li>
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