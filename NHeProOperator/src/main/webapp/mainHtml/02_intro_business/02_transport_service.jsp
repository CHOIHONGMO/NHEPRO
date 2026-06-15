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
    <!--사업소개 : spot_intro_business-->
    <div class="spot_bg spot_intro_business"></div>
    <!--// spot_bg-->

    <!--content-->
    <div class="contents contents_intro contents_intro_business contents_intro_transport">
        <ul class="tabs tabs_col3">
            <li><a href="/mainHtml/02_intro_business/02_purchase_service.jsp">MRO</a></li>
            <li><a href="/mainHtml/02_intro_business/02_delivery_service.jsp">도입효과</a></li>
            <li class="active"><a href="/mainHtml/02_intro_business/02_transport_service.jsp">거래품목</a></li>
        </ul>

        <p class="path"><span class="one">HOME</span><span class="two">사업소개</span><span
                class="three current">거래품목</span></p>

        <section class="top">
            <img alt="용마로지스 회사 개요" src="/images/ymro/sub/02_transport_service.png">
        </section>
    </div>


    <!--// content-->

    <!--footer_wrap-->
    <div class="footer_wrap">
        <c:import url="../footer/footer.jsp" charEncoding="UTF-8"/>
    </div>
    <!--// footer_wrap-->
</div><!--// wrap-->
</body>
</html>