<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>DSP MRO</title>
    <!--<meta name="viewport" content="width=device-width, initial-scale=1.0">-->
    <link rel="stylesheet" href="/css/ymro/ui/style.css" type="text/css">
    <script type="text/javascript" src="/js/jquery-3.2.1.min.js"></script>
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
            <li><a href="/mainHtml/02_intro_business/02_delivery_service_network.jsp">NETWORK</a></li>
            <li class="active"><a href="/mainHtml/02_intro_business/02_delivery_service_contact.jsp">CONTACT POINT</a>
            </li>
        </ul>

        <div class="sub_tab_04">
            <section class="top">
                <h3 class="sub_title">택배 서비스 상담센터입니다.</h3>
                <h4 class="txt">택배 서비스에 관한 문의사항을 전문적으로 상담할 수 있는 담당자에게 전화하세요.</h4>
            </section>

            <section class="middle">
                <div>
                    <h5 class="title"><span class="title_point">타이틀</span>연락처</h5>
                    <div class="border_box clearfix">
                        <div class="box">
                            <h6 class="box_title">최호민</h6>
                            <dl>
                                <dt class="list_title">Tel</dt>
                                <dd class="list_desc">02)3290-6443</dd>
                            </dl>
                            <dl>
                                <dt class="list_title">H.P</dt>
                                <dd class="list_desc">010-5418-7972</dd>
                            </dl>
                            <dl>
                                <dt class="list_title">E-mail</dt>
                                <dd class="list_desc">hmchoi@yongmalogis.co.kr</dd>
                            </dl>
                        </div>
                        <div class="box">
                            <h6 class="box_title">박민수</h6>
                            <dl>
                                <dt class="list_title">Tel</dt>
                                <dd class="list_desc">02)3290-6444</dd>
                            </dl>
                            <dl>
                                <dt class="list_title">H.P</dt>
                                <dd class="list_desc">010-8727-3132</dd>
                            </dl>
                            <dl>
                                <dt class="list_title">E-mail</dt>
                                <dd class="list_desc">msp10@yongmalogis.co.kr</dd>
                            </dl>
                        </div>

                    </div>
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