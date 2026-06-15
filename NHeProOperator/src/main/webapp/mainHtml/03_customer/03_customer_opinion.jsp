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
    <div class="spot_bg spot_customer_service"></div>
    <!--// spot_bg-->

    <!--content-->
    <div class="contents contents_cus_center contents_cus_opinion">
        <ul class="tabs tabs_col4">
            <!--탭바 클릭됬을 경우 class="active" 추가-->
            <li class="active"><a href="/mainHtml/03_customer/03_customer_opinion.jsp"><span>고객의 소리</span></a></li>
            <li><a href="/mainHtml/03_customer/03_join_guide.jsp"><span>가입안내</span></a></li>
            <li><a href="/mainHtml/03_customer/03_notice_list.jsp"><span>공지사항</span></a></li>
            <li><a href="/mainHtml/03_customer/03_faq_cus.jsp"><span>FAQ</span></a></li>
        </ul>

        <p class="path"><span class="one">HOME</span><span class="two">고객지원</span><span
                class="three current">고객의 소리</span></p>

        <div class="tabs_contents customer_opinion">
        
            <section class="top">
            <h3 class="title title_deco_blue_sq"><span class="title_point">타이틀</span>고객의 소리</h3><br>
                <p class="desc">항상 DSP MRO에 관심과 사랑을 보내주시는 고객 여러분께 감사드립니다.<br>
                    DSP MRO는 고객 여러분의 작은 의견이라도 소중히 들을 것이며, 열린 마음으로 겸허히 수용하여 더 좋은 서비스를 위해 항상 노력할<br>것입니다. 로그인 후 고객의 소리에 등록해 주시면 빠른 시간 내에 응답하여 드리겠습니다.</p><br>
                <p class="desc">
                    고객의 소리는 실시간 상담이 아니므로 답변이 지연될 수 있습니다. 신속한 답변을 원하시는 경우 고객센터 번호 (031-738-8157)로<br>연락주시기 바랍니다. 자주하는 질문은
                    FAQ에서 바로 확인이 가능합니다.</p>
            </section>

            <section class="bottom list_box_square list_box_square_col3 clearfix">
                <div class="box">
                    <span></span>
                    <p>자주하는 질문은?<br>
                        <em>FAQ에서 확인가능</em></p>
                </div>
                <div class="box">
                    <span></span>
                    <p>DSP MRO 고객센터<br>
                        <em>031-738-8157</em></p>
                </div>
                <div class="box">
                    <span></span>
                    <p>토요일, 일요일, 공휴일 휴무<br>
                        <em>평일 : 09:00 ~ 18:00</em></p>
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