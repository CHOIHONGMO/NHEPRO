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
    <!--회사소개: spot_intro_company -->
    <div class="spot_bg spot_ethical_management"></div>
    <!--// spot_bg-->

    <!--content-->
    <div class="contents contents_ethical_management">
        <ul class="tabs tabs_col2">
            <!--탭바 클릭됬을 경우 class="active" 추가-->
            <li class="active"><a href="/mainHtml/05_ethical_management/05_ethical_policy.jsp"><span>윤리경영</span></a>
            </li>
            <li><a href="/mainHtml/05_ethical_management/05_fair_trade_rule.jsp"><span>공정거래</span></a></li>

        </ul>

        <p class="path"><span class="one">HOME</span><span class="two">윤리경영</span><span
                class="three current">윤리경영</span></p>

        <ul class="tabs tabs_2depth tabs_col2">
            <li><a href="/mainHtml/05_ethical_management/05_ethical_policy.jsp">윤리경영 방침</a></li>
            <li class="active"><a href="/mainHtml/05_ethical_management/05_ethical_inside_report.jsp">내부고발제도</a></li>
        </ul>
        <div class="tabs_contents inside_report">
            <section>
                <h3 class="title title_deco_blue_sq"><span class="title_point">타이틀</span>DSP MRO 내부고발 제보접수</h3>
                <div class="index index_color">
                    <p class="desc">이 곳은 DSP MRO 직원 또는 협력사 직원이 업무상 발생하는 부정/부실 관련 사항, 부당한 거래관행, 개선사항 등에 관해서 제보를
                        접수하는 곳입니다.</p>
                    <p class="desc">DSP MRO 내부 또는 다른 협력사의 계약, 거래 과정에서 부당한 행위가 있었다면 그에 관하여 제보를 주시면 최선을 다해 조치할 것을
                        약속 드립니다. 접수된 사항은 철저하게 비밀이 보장되며, 최대한 신속하게 조치하도록 하겠습니다.</p>
                    <p class="desc">단, 허위사실이나 기타 부적절한 글은 접수하지 않습니다.</p>
                    <p class="desc desc_caution">서비스 불만사항은 031-738-8157 또는 DSP MRO 로그인 후 ‘고객의 소리’란을 이용해주시기 바랍니다.</p>
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