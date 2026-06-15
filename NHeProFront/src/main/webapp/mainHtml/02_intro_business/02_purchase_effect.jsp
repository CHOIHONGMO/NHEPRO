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
    <script>
        $(document).ready(function() {
            $('#mainIframe', parent.document).css('height', '1647px');
        });
    </script>
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
    <div class="contents contents_intro contents_intro_business contents_intro_purchase">
        <ul class="tabs tabs_col4">
            <li class="active"><a href="/mainHtml/02_intro_business/02_purchase_service.jsp">구매서비스</a></li>
            <li><a href="/mainHtml/02_intro_business/02_delivery_service.jsp">택배서비스</a></li>
            <li><a href="/mainHtml/02_intro_business/02_transport_service.jsp">수송서비스</a></li>
            <li><a href="/mainHtml/02_intro_business/02_give_worthy_customer.jsp">가치제공</a></li>
        </ul>

        <p class="path"><span class="one">HOME</span><span class="two">사업소개</span><span
                class="three current">구매서비스</span></p>
        <ul class="tabs tabs_2depth tabs_col2">
            <li><a href="/mainHtml/02_intro_business/02_purchase_service.jsp">통합구매서비스</a></li>
            <li class="active"><a href="#">프로세스 및 기대효과</a></li>
        </ul>

        <div class="tabs_contents intro_purchase_precess">
            <section class="top">
                <p class="desc">용마로지스는 B2B 물류를 기반으로 산업용품에 공급네트워크를 선도하는 구매 전문서비스 기업입니다.<br>
                    물류산업의 전문성을 바탕으로 의약품, 병원, 생활용품 등 산업전반에 소요되는 소모성 자재의 주문제작, 도매유통, 관리서비스를 제공<br>하고 있으며, 당사만의 차별화 된
                    솔루션을 기반으로 경쟁력 있는 구매력 확립과 합리적 가격으로 맞춤형 구매관리 서비스를 제공하고<br>있습니다. </p>
            </section>

            <section class="middle">
                <div class="process">
                    <h5 class="title title_deco_blue_sq"><span class="title_point">타이틀</span>통합구매서비스 프로세스</h5>
                    <div class="img img_center">
                        <img src="/images/ymro/sub/purchase_service_process.png" alt="통합구매서비스 프로세스">
                    </div>
                </div>
                <div class="effect">
                    <h5 class="title title_deco_blue_sq"><span class="title_point">타이틀</span>통합구매서비스 효과</h5>
                    <div class="img img_center">
                        <img src="/images/ymro/sub/purchase_service_process_02.png" alt="통합구매서비스 프로세스">
                    </div>
<!--                     
                    <div class="box box_radius box_col3 box_w_283 clearfix">
                        <div class="card card_color">
                            <div class="subject">통합구매 효과에 따른 비용절감</div>
                            <ul class="con">
                                <li>전문 구매 기관에 의한 통합구매로<br>비용절감 (3~15%)</li>
                                <li>100% 시스템 기반의 최저단가 유지</li>
                            </ul>
                        </div>
                        <div class="card card_color">
                            <div class="subject">구매 업무 및 프로세스 효율화</div>
                            <ul class="con">
                                <li>시장조사, 견적, 협상, 공급사 관리 등<br>
                                    프로세스 간소화로 구매 Lead Time 축소
                                </li>
                                <li>단순 반복 구매 업무 절감으로 핵심 업무<br>
                                    집중가능
                                </li>
                            </ul>
                        </div>
                        <div class="card card_color">
                            <div class="subject">구매 업무의 투명성 확보</div>
                            <ul class="con">
                                <li>비용분석 Tool 제공 (실시간 모니터링,<br>
                                    구매 비용분석 리포트 제공)
                                </li>
                                <li>구매 관리자의 시스템 관리를 통해<br>
                                    비용 및 예산 집행 통제 가능
                                </li>
                            </ul>
                        </div>
                    </div> -->
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