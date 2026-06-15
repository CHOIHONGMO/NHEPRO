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
    <script>
        $(document).ready(function() {
            $('#mainIframe', parent.document).css('height', '1873px');
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
    <div class="contents contents_intro contents_intro_business contents_worthy">
        <ul class="tabs tabs_col4">
            <li><a href="/mainHtml/02_intro_business/02_purchase_service.jsp">구매서비스</a></li>
            <li><a href="/mainHtml/02_intro_business/02_delivery_service.jsp">택배서비스</a></li>
            <li><a href="/mainHtml/02_intro_business/02_transport_service.jsp">수송서비스</a></li>
            <li class="active"><a href="/mainHtml/02_intro_business/02_give_worthy_customer.jsp">가치제공</a></li>
        </ul>

        <p class="path"><span class="one">HOME</span><span class="two">사업소개</span><span
                class="three current">가치제공</span></p>
        <ul class="tabs tabs_2depth tabs_col2">
            <li class="active"><a href="#">고객사 가치제공</a></li>
            <li><a href="/mainHtml/02_intro_business/02_give_worthy_supplier.jsp">공급사 가치제공</a></li>
        </ul>

        <div class="tabs_contents worth_customer">
            <section class="top">
                <h3 class="sub_title">신속하고 안정적인 SCM공급망을 바탕으로 고객니즈를 만족시킬 수 있는 Total Outsourcing Service 제공</h3>
                <p class="txt">용마로지스는 구매와 물류서비스 제공을 통한 SCM 전문기업으로 성장하는 고객만족을 최우선의 가치으로 여기며
                               <br>고객사는 용마로지스의 구매대행서비스를 통해서 비용절감뿐만 아니라 프로세스 개선을 통한 조직의 효율성을 높일 수 있습니다.</p>
                <p class="txt">표준화된 DB 구축, 맞춤형 카다로그 제공, 공급물량 통합, 구매비용 절감을 통해
                               <br>고객사의 경쟁력을 한층 더 높여 드릴 것입니다.</p>

                <div class="img img_center">
                    <img src="/images/ymro/sub/worth_cus_effect.png" style="display: inline" alt="구매비용절감 효과 극대화">
                </div>
            </section>

            <section class="bottom">
                <div class="box box_radius box_w_283 clearfix">


                
                    <div class="card card_color card_img">
                        <div class="subject">구매비용 절감</div>
                        <div class="con">
                            <div class="img img_center">
                                <img src="/images/ymro/sub/worth_cus_effect_box02.png" style="width: 258px; height: 60px; display: inline;" alt="공급사 용마로지스 구매사">

                            </div>
                            <ul>
                                <li>구매업무의 간소화(아웃소싱을 통한<br>공급사 관리, 신규품목 소싱, 마감관리)</li>
                                <li>구매에 특화된 전문 e-Marketplace<br>시스템을 통한 서비스 제공</li>

                            </ul>
                        </div>
                    </div>
                    


                    <div class="card card_color card_img">
                        <div class="subject">구매효율성 증대</div>
                        <div class="con">
                            <div class="img img_center">
                                <img src="/images/ymro/sub/worth_cus_effect_box01.png" style="width: 257px; height: 127px; display: inline;" alt="구매비용 절감 그래프">
                            </div>
                            <ul>
                                <li>직접구매비용 감소(구매단가인하)<br>간접구매비용 절감(인건비, 시스템 개발/<br>유지/보수 비용, 거래처 관리비용,<br>재고유지비용 등)</li>
                            </ul>
                        </div>
                    </div>



                    <div class="card card_color card_img">
                        <div class="subject">공정성, 투명성 확보</div>
                        <div class="con">
                            <div class="img img_center">
                                <img src="/images/ymro/sub/worth_cus_effect_box03.png" style="width: 229px; height: 64px; display: inline;" alt="용마로지스">
                            </div>
                            <ul>
                                <li>구매 투명성으로 인한 Compliance 준수</li>
                                <li>실시간 모니터링</li>
                                <li>공급사 등록절차 및 평가체계 수립</li>
                            </ul>
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