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
    <div class="spot_bg spot_intro_business">
        <h2 class="title"><span>용마로지스는</span><br>최첨단 Infra와 전문화된 e-Sourcing 시스템을 기반으로<br>구매부터 관리까지의 통합구매서비스를 제공합니다.
        </h2>
    </div>
    <!--// spot_bg-->

    <!--content-->
    <div class="contents contents_intro contents_intro_business contents_intro_delivery">
        <ul class="tabs tabs_col4">
            <li><a href="/mainHtml/02_intro_business/02_purchase_service.jsp">구매서비스</a></li>
            <li class="active"><a href="/mainHtml/02_intro_business/02_delivery_service.jsp">택배서비스</a></li>
            <li><a href="/mainHtml/02_intro_business/02_transport_service.jsp">수송서비스</a></li>
            <li><a href="/mainHtml/02_intro_business/02_give_worthy_customer.jsp">가치제공</a></li>
        </ul>

        <p class="path"><span class="one">HOME</span><span class="two">사업소개</span><span
                class="three current">택배서비스</span></p>
        <ul class="tabs tabs_2depth tabs_col4">
            <li><a href="/mainHtml/02_intro_business/02_delivery_service.jsp">소개</a></li>
            <li><a href="/mainHtml/02_intro_business/02_delivery_service_flow.jsp">FLOW</a></li>
            <li class="active"><a href="/mainHtml/02_intro_business/02_delivery_service_network.jsp">NETWORK</a></li>
            <li><a href="/mainHtml/02_intro_business/02_delivery_service_contact.jsp">CONTACT POINT</a></li>
        </ul>

        <div class="sub_tab_03">
            <section class="top">
                <h3 class="sub_title">우수한 택배 서비스 네트워크</h3>
                <h4 class="txt">용마로지스는 전국 30여 주요지역에서 자사 직영 서비스 네트워크를<br>구축하고 일원화된 관리를 통해 우수한 서비스를 제공하고 있습니다.</h4>
            </section>

            <section class="middle">
                <div>
                    <h5 class="title"><span class="title_point">타이틀</span>택배관리 시스템</h5>
                    <span class="network_system_img">수도권: 동대문, 구리, 고양, 의정부, 안양, 동인천, 서인천, 강서, 강남, 송파, 신갈, 안성, 박스터팀, 특수배송팀/ 충청권: 천안, 동대전, 서대전, 청주/ 호남권: 전주, 동광주, 서광주, 순천 / 강원권: 원주, 강릉, 춘천 / 영남권: 서대구, 동대구, 울산, 경주, 안동, 동부산, 서부산, 창원, 진주 / 제주도: 제주 / 안성물류센터 / 영동물류센터 / 배송센터</span>
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
</div><!--// wrap-->
</body>
</html>