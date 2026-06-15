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
    <div class="contents contents_intro contents_intro_business contents_intro_transport">
        <ul class="tabs tabs_col4">
            <li><a href="/mainHtml/02_intro_business/02_purchase_service.jsp">구매서비스</a></li>
            <li><a href="/mainHtml/02_intro_business/02_delivery_service.jsp">택배서비스</a></li>
            <li class="active"><a href="/mainHtml/02_intro_business/02_transport_service.jsp">수송서비스</a></li>
            <li><a href="/mainHtml/02_intro_business/02_give_worthy_customer.jsp">가치제공</a></li>
        </ul>

        <p class="path"><span class="one">HOME</span><span class="two">사업소개</span><span
                class="three current">수송서비스</span></p>
        <ul class="tabs tabs_2depth tabs_col3">
            <li><a href="/mainHtml/02_intro_business/02_transport_service.jsp">소개</a></li>
            <li class="active"><a href="/mainHtml/02_intro_business/02_transport_service_flow.jsp">FLOW</a></li>
            <li><a href="/mainHtml/02_intro_business/02_transport_service_contact.jsp">CONTACT POINT</a></li>
        </ul>

        <div class="sub_tab_02">
            <section class="top">
                <h3 class="sub_title">인터넷 및 모바일 무선통신기술 기반의 첨단수송시스템</h3>
                <h4 class="txt">용마로지스는 오랜 수송관리 경험을 바탕으로 인터넷 및 모바일 무선통신기술 기반의 첨단수송시스템을<br>자체 개발하는 등 수송효율화를 위한 투자를 아끼지 않고
                    있습니다.</h4>
            </section>

            <section class="middle">
                <div class="flow">
                    <h5 class="title"><span class="title_point">타이틀</span>수송 서비스 FLOW </h5>
                    <img src="/images/ymro/sub/trasport_service_flow.png" alt="수송 서비스 flow">
                </div>

                <div class="state">
                    <h5 class="title"><span class="title_point">타이틀</span>수송의뢰</h5>
                    <ul>
                        <li>노선별, 차량별 상품별 특성을 반영한 차량배정과 맞춤 서비스 제공합니다.</li>
                        <li>사전 물동량 분석 및 예측으로 최적의 배차계획 수립합니다.</li>
                        <li>인터넷을 통한 화물공차정보 서비스 및 실시간 화물수송예약 서비스를 제공합니다.</li>
                    </ul>
                </div>
                <div class="state">
                    <h5 class="title"><span class="title_point">타이틀</span>차량배차</h5>
                    <ul>
                        <li>차량의 실시간 Scheduling, Routing을 통해 최적 배차를 실현합니다.</li>
                        <li>전국 자영차량을 통한 연계배차로 비용을 절감시켜 드립니다.</li>
                    </ul>
                </div>
                <div class="state">
                    <h5 class="title"><span class="title_point">타이틀</span>수송</h5>
                    <ul>
                        <li>오랜 경험과 최신식 차량으로 안전하고 신속한 수송서비스를 보장합니다.</li>
                        <li>화물 파손 및 훼손 또는 도착지연에 따른 피해를 보상해 드립니다.</li>
                    </ul>
                </div>
                <div class="state">
                    <h5 class="title"><span class="title_point">타이틀</span>인수</h5>
                    <ul>
                        <li>정기적 또는 고객 요구시점에 인수증 발송을 의무화하고 있습니다.</li>
                    </ul>
                </div>
                <div class="state">
                    <h5 class="title"><span class="title_point">타이틀</span>사후관리</h5>
                    <ul>
                        <li>수송관리시스템에 의한 수송결과 정보를 실시간으로 제공합니다.</li>
                    </ul>
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