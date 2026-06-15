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
    <div class="spot_bg spot_intro_company"></div>
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

		<section class="top">
            <img alt="용마로지스 회사 개요" src="/images/ymro/sub/01_intro_history_2010.png">
        </section>

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