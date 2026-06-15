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
            <li class="active"><a href="/mainHtml/05_ethical_management/05_ethical_policy.jsp">윤리경영 방침</a></li>
            <li><a href="/mainHtml/05_ethical_management/05_ethical_inside_report.jsp">내부고발제도</a></li>
        </ul>
        <div class="tabs_contents e_m_policy">
            <section>
                <h3 class="title title_deco_blue_sq"><span class="title_point">타이틀</span>제 1장 고객에 대한 책임과 의무</h3>
                <div class="index index_color">
                    <h4 class="title">1. 고객존중</h4>
                    <ul class="list">
                        <li>고객의 의견에 항상 귀를 기울이고, 고객의 요구는 항상 옳다고 생각하며, 고객을 모든 판단 및 행동의 최우선으로 삼는다.</li>
                    </ul>

                    <h4 class="title">2. 가치 창조</h4>
                    <ul class="list">
                        <li>고객 발전이 곧 회사 발전이라는 인식하에 고객이 필요로 하는 가치를 찾기 위해 항상 노력한다.</li>
                        <li>고객에게 실질적으로 도움이 되고 만족을 줄 수 있는 참된 가치를 끊임없이 창조한다.</li>
                    </ul>

                    <h4 class="title">3. 가치 제공</h4>
                    <ul class="list">
                        <li>고객에게 진실만을 말하며, 고객과의 약속은 반드시 지킨다.</li>
                        <li>고객의 정당한 요구에 신속, 정확하게 친절과 봉사로 대한다.</li>
                        <li>고객이 바라는 가치를 고객이 요구하기 전에 미리 제공하도록 노력한다.</li>
                    </ul>

                    <h4 class="title">4. 공정한 거래</h4>
                    <ul class="list">
                        <li>거래는 자유경쟁의 원칙에 따라 항상 시장경제질서를 존중하고 관계법규를 준수하며, 품질과 서비스의 질을 통하여 고객의 신뢰를 확보한다.</li>
                        <li>진정한 실력으로 선의의 경쟁을 하며, 경쟁사의 이익을 침해하거나 약점을 부당하게 이용하지 않는다.</li>
                        <li>깨끗한 거래풍토를 조성하고 공정한 거래질서를 유지하기 위하여 거래선과 상호 노력한다.</li>
                        <li>우월적 지위를 이용한 어떠한 형태의 부당행위도 하지 않는다.</li>
                    </ul>
                </div>


            </section>
            <section>
                <h3 class="title title_deco_blue_sq"><span class="title_point">타이틀</span>제 2 장 임직원의 기본윤리</h3>

                <div class="index index_color">
                    <h4 class="title">1. 기본 윤리</h4>
                    <ul class="list">
                        <li>임직원은 DSP MRO 직원으로서의 긍지와 자부심을 가지고, 항상 정직하고 성실한 자세로 매사에 임한다.</li>
                        <li>높은 윤리적 가치관을 가지고 개인의 품위 및 DSP MRO의 명예를 유지, 발전시킬 수 있도록 노력한다.</li>
                        <li>회사의 제반규정을 준수함과 동시에 양심에 어긋남이 없도록 행동한다.</li>
                    </ul>

                    <h4 class="title">2. 사명 완수</h4>
                    <ul class="list">
                        <li>회사의 비전과 경영방침에 따라 각자의 사명을 성실히 수행한다.</li>
                        <li>주어진 직무는 최선을 다해 정당한 방법으로 수행한다.</li>
                        <li>회사의 재산을 유지, 관리하고, 업무상 알게 된 회사의 비밀을 보호한다.</li>
                        <li>동료 및 관계 부처간에 적극적인 협조와 원만한 의사소통으로 업무의 효율을 높인다.</li>
                    </ul>

                    <h4 class="title">3. 공정한 직무 수행</h4>
                    <ul class="list">
                        <li>모든 직무를 정직하고 공정하게 수행하며, 건전한 기업문화를 조성하기 위해 항상 노력한다.</li>
                        <li>관행에 만족하지 않고 항상 새로운 것을 추구하며, 문제의 해결을 기피하지 않고 능동적으로 대처한다.</li>
                        <li>일상생활 및 직무와 관련하여 사회로부터 지탄받을 수 있는 비도덕적, 비윤리적 행위를 하지 않는다.</li>
                        <li>직무와 관련하여 판단의 공정성을 저해할 수 있는 어떠한 형태의 금전적 이익도 이해관계자로부터 취하지 않는다.</li>
                        <li>맡고 있는 분야에서 회사를 대표하고 있다는 주인의식을 갖고 행동하며 항시 품위유지를 위해 노력한다.</li>
                    </ul>

                    <h4 class="title">4. 자기 계발 및 지도</h4>
                    <ul class="list">
                        <li>임직원은 스스로 끊임없는 자기계발을 통해 회사의 인재상에 부합되도록 꾸준히 노력한다.</li>
                        <li>상사는 성실히 부하를 지도하고 통솔함과 동시에 솔선하여 업무를 수행한다.</li>
                    </ul>

                    <h4 class="title">5. 회사와 이해 상충 회피</h4>
                    <ul class="list">
                        <li>회사와 개인의 이해가 상충되는 어떠한 행위나 관계도 회피한다.</li>
                        <li>개인의 이익을 위해 회사의 재산을 무단 사용하지 않는다.</li>
                    </ul>

                    <h4 class="title">6. 임직원 상호존중 </h4>
                    <ul class="list">
                        <li>임직원은 상하 및 동료간 상호신뢰를 바탕으로 서로 존중하며, 원활한 의사소통이 될 수 있도록 노력한다.</li>
                        <li>상급자는 하급자에게 부당한 지시를 해서는 안되며, 하급자는 상급자의 정당한 지시를 따르되 부당한 지시를 거절해야 한다.</li>
                        <li>임직원은 학벌, 성별, 종교, 혈연, 출신지역 등에 따른 차별대우를 하지 않는다.</li>
                    </ul>

                </div>


            </section>
            <section>
                <h3 class="title title_deco_blue_sq"><span class="title_point">타이틀</span>제 3장 임직원에 대한 책임</h3>

                <div class="index index_color">
                    <h4 class="title">1. 인간 존중</h4>
                    <ul class="list">
                        <li>사람에 대한 믿음을 가지고, 임직원 모두 독립된 인격으로 대한다.</li>
                        <li>주인의식을 바탕으로 일을 통해 긍지와 보람을 성취할 수 있도록 최선을 다한다.</li>
                        <li>정당한 방법으로 사명을 수행할 수 있도록 제도의 확립과 교육, 지도 등 필요한 조치를 강구한다.</li>
                    </ul>
                    <h4 class="title">2. 공정한 대우</h4>
                    <ul class="list">
                        <li>임직원의 능력과 자질에 따라 평등한 기회를 부여한다.</li>
                        <li>업적과 역량에 대해 공정한 기준에 따라 평가하고, 정당하게 보상한다.</li>
                    </ul>

                    <h4 class="title">3. 창의성 촉진</h4>
                    <ul class="list">
                        <li class="list_title"><h4 class="tit"></h4></li>
                        <li>독창적 사고를 가지고, 자율적으로 업무에 임할 수 있도록 여건을 최대한 조성한다.</li>
                        <li>임직원의 능력개발을 위해 적극적으로 지원하고, 장기적 관점에서 인재를 육성한다.</li>
                        <li>개인의 사생활을 존중하고 상호신뢰와 이해를 바탕으로 성숙한 조직문화를 이룩한다.</li>
                    </ul>
                </div>


            </section>
            <section>
                <h3 class="title title_deco_blue_sq"><span class="title_point">타이틀</span>제 4장 국가와 사회에 대한 책임</h3>

                <div class="index index_color">
                    <h4 class="title">1. 합리적인 사업전개</h4>
                    <ul class="list">
                        <li>국내외 해당지역의 사회적 가치관을 존중하며 사업을 수행한다.</li>
                        <li>회사의 안정적 성장의 바탕 위에서 사업의 확대를 도모한다.</li>
                    </ul>
                    <h4 class="title">2. 사회발전에 기여</h4>
                    <ul class="list">
                        <li>고용창출과 조세의 성실한 납부로 국가발전에 기여하고 기업의 사회적 책임 활동을 통해 사회발전에 공헌한다.</li>
                    </ul>

                    <h4 class="title">3. 환경 보호</h4>
                    <ul class="list">
                        <li>깨끗한 환경의 보전을 위해 환경오염의 방지 및 자연보호에 최선을 다한다.</li>
                    </ul>
                </div>


            </section>
            <section>
                <h3 class="title title_deco_blue_sq"><span class="title_point">타이틀</span>제 5장 적용</h3>
                <div class="index index_color">
                    <p class="desc">회사 제 규정의 해석 및 적용은 본 규범에 나타난 취지와 기본정신에 준거하며 본 윤리경영방침은 2019년 11월 11일 제정, 시행한다.</p>
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