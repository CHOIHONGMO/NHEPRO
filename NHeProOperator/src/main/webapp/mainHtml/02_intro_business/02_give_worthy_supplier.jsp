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
            <li><a href="/mainHtml/02_intro_business/02_give_worthy_customer.jsp">고객사 가치제공</a></li>
            <li class="active"><a href="#">공급사 가치제공</a></li>
        </ul>

        <div class="tabs_contents worth_supplier">
            <section class="top">
                <h3 class="sub_title">공급망 정예화는 용마로지스 경쟁력의 근원입니다.
                                      <br>용마로지스는 공정거래를 바탕으로 한 공정성 확보 및 투명성 제고를 중요가치로 여기고 있습니다.</h3>
                <p class="txt">용마로지스와 거래를 통해 다양한 판매처를 확보할 수 있습니다.<br>
                    구매대행시스템을 통해 신속하고 정확한 입찰 정보를 수신할 수 있으며,<br>
                  1인기업,스타트업 기업, 여성기업,장애인 기업과의 거래를 통해 수익의 일부를<br>
                    사회공헌사업에 지원합니다.</p>
                <p class="txt">용마로지스는 IT Infra와 구매전문인력 활용, 물류컨설팅 지원 등을 통해 공급사의 성장 발판이 될 수 있도록 지원하고 있습니다.</p>

            </section>

            <section class="bottom">
                <div class="round_list_box round_list_box_col4 clearfix">
                    <div class="list route">
                        <span>공급사의 다양한 판로제공</span>
                        <h5 class="list_title"><em>공급사의 다양한 판로제공</em></h5>
                        <ul>
                            <li class="cust">공급사 관계관리체계 구축</li>
                            <li class="cust">그룹사 및 화주사 등 새로운 판로개척 &nbsp;&nbsp;&nbsp;기회</li>
                        </ul>
                    </div>
                    <div class="list safe">
                        <span>구매Biz. 성장성 확대</span>
                        <h5 class="list_title"><em>구매Biz. 성장성 확대</em></h5>
                        <ul>
                            <li class="cust">공급사의 영업망 증대는 물론<br>
                                &nbsp;&nbsp;&nbsp;공급사와의 동반성장 비즈니스<br>
                                &nbsp;&nbsp;&nbsp;모델을 지속적으로 확대
                            </li>
                        </ul>
                    </div>
                    <div class="list effect">
                        <span>업무효율성 향상</span>
                        <h5 class="list_title"><em>업무효율성 향상</em></h5>
                        <ul>
                            <li class="cust">e-MarketPlace 활용으로<br>
                                &nbsp;&nbsp;&nbsp;별도의 시스템 구축 없이 프로세스<br>
                                &nbsp;&nbsp;&nbsp;전산화 및 운영효율성 증대
                            </li>
                        </ul>
                    </div>
                    <div class="list info">
                        <span>체계적인 DB구축</span>
                        <h5 class="list_title"><em>체계적인 DB구축</em></h5>
                        <ul>
                            <li class="cust">상품 DB 표준화/관리체계 강화</li>
                            <li class="cust"> 선진사례 Tool 활용<br>
                                &nbsp;&nbsp;&nbsp;(S/G설계,공급사 정예화,PB개발 등)</li>
                            <li class="cust">입찰정보 및 다양한 정보채널 공유</li>
                        </ul>
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