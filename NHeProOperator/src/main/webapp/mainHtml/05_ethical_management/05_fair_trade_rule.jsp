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
    <div class="contents contents_ethical_management fair_trade">
        <ul class="tabs tabs_col2">
            <!--탭바 클릭됬을 경우 class="active" 추가-->
            <li><a href="/mainHtml/05_ethical_management/05_ethical_policy.jsp"><span>윤리경영</span></a></li>
            <li class="active"><a href="/mainHtml/05_ethical_management/05_fair_trade_rule.jsp"><span>공정거래</span></a>
            </li>

        </ul>

        <p class="path"><span class="one">HOME</span><span class="two">윤리경영</span><span
                class="three current">공정거래</span></p>

        <ul class="tabs tabs_2depth tabs_col2">
            <li class="active"><a href="/mainHtml/05_ethical_management/05_fair_trade_rule.jsp">공정거래제도 개요 및 관련법률</a>
            </li>
            <li><a href="/mainHtml/05_ethical_management/05_fair_trade_contents.jsp">공정거래 주요내용</a></li>
        </ul>
        <div class="tabs_contents fair_trade_rule">
            <section>
                <h3 class="title title_deco_blue_sq"><span class="title_point">타이틀</span>공정거래제도 개요</h3>

                <div class="index index_color ">
                    <h4 class="title">1. 목적</h4>
                    <p class="desc">공정하고 자유로운 경쟁의 촉진을 통해서 경제의 효율성을 제고하고 경제력 집중을 억제함으로써 국민경제의 건전한 발전을 도모
                        하는데<br>있습니다.</p>
                    <h4 class="title">2. 정의</h4>
                    <p class="desc">공정거래법은 기업간의 공정하고 자유로운 경쟁을 촉진하고 소비자를 보호할 목적으로 제정된 법률입니다. 이는 시장 경제체제의
                        근간이<br>되고 사업자 간의 자유롭고 공정한 경쟁을 촉진하기 위한 경제활동의 준칙(Rule of Game)이 되는 기본 규범입니다.
                        공정거래법은 통상<br>독점규제 및 공정거래에 관한 법률(독점규제법)을 약칭하는 용어로 사용되고 있지만 실제는 독점규제법 외에도
                        하도급법(하도급거래공정화에 관한 법률), 약관법(약관의 규제에 관한 법률), 표시, 광고법(표시, 광고의 공정화에 관한 법률)등
                        공정거래 관련 법규를 총칭하는<br>개념으로 사용됩니다.</p>
                </div>
            </section>
            <section>
                <h3 class="title title_deco_blue_sq"><span class="title_point">타이틀</span>관련법규</h3>

                <div class="index index_color">
                    <h4 class="title">1. 특징</h4>
                    <ul class="list">
                        <li>폐해 규제 : 독과점 자체의 규제가 아니라 폐해만 규제</li>
                        <li>행정 규제 : 위법성 판단은 행정기관인 공정거래위원회가 1차 심사담당</li>
                        <li>직권 규제 : 법 위반 행위에 대한 조사, 시정, 소송도 공정거래위원회의 직권 판단</li>
                    </ul>
                    <h4 class="title">2. 관련법률</h4>
                    <ul class="list">
                        <li>하도급 거래공정화에 관한 법률 (1984. 12. 31 제정)</li>
                        <li>약관의 규제에 관한 법률 (1986. 12. 31 제정)</li>
                        <li>표시, 광고의 공정화에 관한 법률 (1999. 2. 5 제정) 등</li>
                    </ul>
                    <h4 class="title">3. 기본법규</h4>
                    <ul class="list">
                        <li>독점규제 및 공정거래에 관한 법률 (1980. 12. 31 제정)</li>
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
</div>
<!--// wrap-->
</body>
</html>