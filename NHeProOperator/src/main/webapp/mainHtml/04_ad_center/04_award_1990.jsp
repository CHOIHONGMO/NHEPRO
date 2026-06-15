<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>덕성테크팩</title>
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
    <!--회사소개: spot_ad_center -->
    <div class="spot_bg spot_ad_center">
        <h2 class="title"><span>용마로지스는</span><br>투명성과 신뢰성을 바탕으로 책임경영을 통해 기업의 사회적 책임을 다하겠습니다.</h2>
    </div>
    <!--// spot_bg-->

    <!--content-->
    <div class="contents contents_ad_center contents_award">
        <ul class="tabs tabs_col4">
            <!--탭바 클릭됬을 경우 class="active" 추가-->
            <li class="active"><a href="/mainHtml/04_ad_center/04_award_2010.jsp"><span>수상 및 인증</span></a></li>
            <li><a href="/mainHtml/04_ad_center/04_right_human_type.jsp"><span>인재상</span></a></li>
            <li><a href="/mainHtml/04_ad_center/04_ad_ci.jsp"><span>홍보</span></a></li>
            <li><a href="/mainHtml/04_ad_center/04_csr_state.jsp"><span>CSR</span></a></li>
        </ul>

        <p class="path"><span class="one">HOME</span><span class="two">홍보센터</span><span
                class="three current">수상 및 인증</span></p>

        <ul class="tabs tabs_2depth tabs_col3">
            <li><a href="/mainHtml/04_ad_center/04_award_2010.jsp">2010's</a></li>
            <li><a href="/mainHtml/04_ad_center/04_award_2000.jsp">2000's</a></li>
            <li class="active"><a href="/mainHtml/04_ad_center/04_award_1990.jsp">1990's</a></li>
        </ul>

        <div class="tabs_contents award_history_1990s">
            <section class="box_history">
                <div class="text_box">
                    <h3 class="title">고객과 함께 만들어 온<br>용마로지스의 역사를 소개합니다.</h3>
                    <h4 class="sub_title">용마로지스는 1983년 창사 이래<br>올바른 물류에 대한 철학을 변함 없이 지켜왔습니다.</h4>
                </div>
                <div class="list_box list_box_history">
                    <span class="line"></span>
                    <dl class="list">
                        <dt class="title"><em>연도</em>1998</dt>
                        <dd class="desc"><em>내용</em>12월 물류 공동화 부문 물류대상 수상</dd>
                        <dd class="img award_img"><img src="/images/ymro/sub/award_history_1998_12.png"
                                                       alt="1998년 12월 물류 공동화 부문 물류대상 수상"></dd>
                    </dl>
                    <dl class="list">
                        <dt class="title"><em>연도</em>1996</dt>
                        <dd class="desc"><em>내용</em>11월 물류 공동화 부문 물류대상 수상</dd>
                        <dd class="img award_img"><img src="/images/ymro/sub/award_history_1996_11.png"
                                                       alt="1996년 11월 물류 공동화 부문 물류대상 수상"></dd>

                    </dl>
                    <dl class="list">
                        <dt class="title"><em>연도</em>1993</dt>
                        <dd class="desc"><em>내용</em>10월 전국물류대회 수송부만 대상수상</dd>
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