<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>DSP MRO</title>
    <!--<meta name="viewport" content="width=device-width, initial-scale=1.0">-->
    <link rel="stylesheet" href="/css/ymro/ui/style.css" type="text/css">
    <script type="text/javascript" src="/js/everuxf/everuxf.min.js"></script>
    <script type="text/javascript" src="/css/ymro/js/lib/jquery.bxslider.js"></script>
    <script type="text/javascript" src="/css/ymro/js/ui/common.js"></script>
</head>
<body>
<!--wrap-->
<div class="wrap sub_page">
    <!--header_wrap-->
    <div class="header_wrap">
        <c:import url="../header/header.jsp" charEncoding="UTF-8"/>
    </div>
    <!--// header_wrap-->

    <!--spot_bg-->
    <!--회사소개: spot_intro_company -->
    <div class="spot_bg spot_intro_company">
        <h2 class="title"><span>용마로지스는</span><br>투명성과 신뢰성을 바탕으로 책임경영을 통해 기업의 사회적 책임을 다하겠습니다.</h2>
    </div>
    <!--// spot_bg-->

    <!--content-->
    <div class="contents contents_intro contents_intro_company contents_intro_history">
        <ul class="tabs">
            <!--탭바 클릭됬을 경우 class="active" 추가-->
            <li><a href="/mainHtml/01_intro_company/01_ceo_intro.jsp"><span>CEO 인사말</span></a></li>
            <li><a href="/mainHtml/01_intro_company/01_intro_summary.jsp"><span>회사개요</span></a></li>
            <li><a href="/mainHtml/01_intro_company/01_intro_vision.jsp"><span>비젼과 미션</span></a></li>
            <li class="active"><a href="/mainHtml/01_intro_company/01_intro_history_2010.jsp"><span>연혁</span></a></li>
            <li><a href="/mainHtml/01_intro_company/01_how_come.jsp"><span>오시는 길</span></a></li>
        </ul>

        <p class="path"><span class="one">HOME</span><span class="two">회사소개</span><span class="three current">연혁</span>
        </p>

        <ul class="tabs tabs_2depth tabs_col4">
            <li><a href="/mainHtml/01_intro_company/01_intro_history_2010.jsp">2010's</a></li>
            <li><a href="/mainHtml/01_intro_company/01_intro_history_2000.jsp">2000's</a></li>
            <li class="active"><a href="/mainHtml/01_intro_company/01_intro_history_1990.jsp">1990's</a></li>
            <li><a href="/mainHtml/01_intro_company/01_intro_history_1980.jsp">1980's</a></li>
        </ul>

        <div class="tabs_contents intro_history_1990s">
            <section class="box_history">
                <div class="text_box">
                    <h3 class="title">고객과 함께 만들어 온<br>용마로지스의 역사를 소개합니다.</h3>
                    <h4 class="sub_title">용마로지스는 1983년 창사 이래<br>올바른 물류에 대한 철학을 변함 없이 지켜왔습니다.</h4>
                </div>
                <div class="list_box list_box_history">
                    <span class="line"></span>
                    <dl class="list">
                        <dt class="title"><em>연도</em>1999</dt>
                        <dd class="desc"><em>내용</em>11월 WMS 솔루션 도입(EXE Exceed, 업계최초)</dd>
                    </dl>
                    <dl class="list">
                        <dt class="title"><em>연도</em>1999</dt>
                        <dd class="desc"><em>내용</em>02월택배 정보시스템 개발</dd>
                    </dl>
                    <dl class="list">
                        <dt class="title"><em>연도</em>1996</dt>
                        <dd class="desc"><em>내용</em>10월 물류BPR 실시(동아제약 공동)</dd>
                        <dd class="img"><img src="/images/ymro/sub/intro_history_1996_10.png"
                                             alt="1996년 10월 물류BPR 실시(동아제약 공동)"></dd>
                    </dl>
                    <dl class="list">
                        <dt class="title"><em>연도</em>1995</dt>
                        <dd class="desc"><em>내용</em>09월 소화물 일관수송업(택배) 면허 취득</dd>
                    </dl>
                    <dl class="list">
                        <dt class="title"><em>연도</em>1994</dt>
                        <dd class="desc"><em></em>09월 화물자동차 운송사업 면허 취득</dd>
                        <dd class="img"><img src="/images/ymro/sub/intro_history_1994_09.png"
                                             alt="1994년 09월 화물자동차 운송사업 면허 취득"></dd>
                    </dl>
                    <dl class="list">
                        <dt class="title"><em>연도</em>1991</dt>
                        <dd class="desc"><em>내용</em>10월 신갈 물류센터 개설</dd>
                        <dd class="img"><img src="/images/ymro/sub/intro_history_1991_10.png"
                                             alt="1991년 10월 신갈 물류센터 개설"></dd>
                    </dl>

                </div>
            </section>
        </div>


    </div>
    <!--// content-->

    <!--footer_wrap-->
    <div class="footer_wrap">
        <c:import url="../footer/footer.jsp" charEncoding="UTF-8"/>
    </div>
    <!--// footer_wrap-->
</div>
<!--// wrap-->
</body>
</html>