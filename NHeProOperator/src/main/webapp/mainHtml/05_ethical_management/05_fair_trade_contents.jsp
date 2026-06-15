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
            <li><a href="/mainHtml/05_ethical_management/05_fair_trade_rule.jsp">공정거래제도 개요 및 관련법률</a></li>
            <li class="active"><a href="/mainHtml/05_ethical_management/05_fair_trade_contents.jsp">공정거래 주요내용</a></li>
        </ul>
        <div class="tabs_contents fair_trade_rule">
            <section>
                <h3 class="title title_deco_blue_sq"><span class="title_point">타이틀</span>공정거래</h3>
                <div class="index index_color">
                    <ul class="list">
                        <li class="trade">
                            공정거래제도의 기본이 되는 공정거래법은 자유로운 경쟁을 위한 시장구조의 개선과 공정한 경쟁을 위한 거래형태의 개선에 대한
                            <br>기본적인규범사항을 주 내용으로 하고 있습니다.
                        </li>
                        <li class="trade">카르텔, 남용행위 등 경쟁제한적인 관행과 행태를 금지합니다.</li>
                    </ul>
                </div>
            </section>
            <section>
                <h3 class="title title_deco_blue_sq"><span class="title_point">타이틀</span>시장구조개선</h3>
                <div class="index index_color">
                    <h4 class="title">경쟁력 집중 억제</h4>
                    <ul class="list">
                        <li>상호출자금지 : 자기의 주식을 소유하고 있는 계열회사의 주식취득, 소유금지</li>
                        <li>출자 총액금지 ('09.3 폐지)</li>
                        <li>채무보증제한 : 국내계열회사에 대하여 채무를 보증하는 행위를 금지 (산업합리화, 국제경쟁력강화 예외 인정)</li>
                        <li>대규모 내부거래 이사회 의결 공시 : 특수관계인과 자본총계 ∙ 자본금 중 큰 금액의 5% 이상 또는 50억원 이상의 거래행위</li>
                        <li>기업집단현황 공시제도 신설 ('09.7) : 기업집단 일반현황, 임원 이사회 운영현황 주식소유현황, 특수관계인과의 거래현황 공시</li>
                        <li>비상장 중요사항 공시 : 소유지배구조, 재무구조, 경영활동 중요사항 공시 의무</li>
                    </ul>
                </div>
            </section>
            <section>
                <h3 class="title title_deco_blue_sq"><span class="title_point">타이틀</span>거래형태의 개선</h3>
                <div class="index index_color ">
                    <h4 class="title">1. 일반 불공정 거래행위의 금지</h4>
                    <ul class="list">
                        <li>부당한 거래거절 : 부당하게 거래를 거절하는 행위</li>
                        <li>차별적 취급 : 가격이나 기타 거래조건 등을 지역별, 상대방별로 차별적으로 취급하여 거래하는 행위</li>
                        <li>경쟁사업자 배제 : 부당하게 자기 또는 계열사의 경쟁사를 배제하는 행위</li>
                        <li>부당한 고객유인 : 경쟁사의 고객을 우리회사와 거래하도록 유인하거나 강제하는 행위</li>
                        <li>거래강제 : 경쟁사의 고객을 자기와 거래하도록 강제하는 행위</li>
                        <li>거래상 지위남용 : 거래과정에서 자기의 거래상의 지위를 이용하여 거래상대방에게 불이익을 주는 행위</li>
                        <li>구속조건부 거래 : 거래상대방의 사업활동을 구속하는 조건으로 거래하거나 그 사업활동을 방해하는 행위</li>
                        <li>사업활동 방해 : 생산수단의 확보과정 또는 기존거래의 종료과정에서 거래상대방의 사업활동을 방해하는 행위</li>
                        <li>부당지원 : 부당하게 특수관계인 또는 다른 회사에 대해 가지급금, 대여금, 인력, 부동산, 유가증권 등을 제공하거나<br>현저히 유리한
                            조건으로 거래하여 특수관계인 또는 다른 회사를 지원하는 행위
                        </li>
                        <li>재판매가격 유지 : 상품을 생산 또는 판매하는 사업자가 그 상품을 판매함에 있어 거래상대방인 사업자에 대해 거래가격을<br>정하여
                            그 가격대로 판매할 것을 강제하거나 규약 기타 구속조건을 붙여 거래하는 행위
                        </li>
                    </ul>                
                    <h4 class="title">2. 시장지배적 사업자의 남용행위 금지</h4>
                    <ul class="list">
                        <li>가격남용 : 상품의 가격이나 용역의 대가를 부당하게 결정, 유지 또는 변경하는 행위</li>
                        <li>판매조절 : 상품의 판매 또는 용역의 제공을 부당하게 조절하는 행위</li>
                        <li>영업방해 : 다른 사업자의 사업활동을 부당하게 방해하는 행위</li>
                        <li>경쟁사업자 배제 : 부당하게 경쟁사업자를 배제하기 위하여 거래하거나 소비자의 이익을 현저히 제한할 우려가 있는 경우</li>
                    </ul>
                    <h4 class="title">3. 부당한 공동행위의 제한</h4>
                    <ul class="list">
                        <li>가격결정 : 다른 사업자와 공동으로 가격을 결정, 유지 변경하는 행위</li>
                        <li>거래조건 결정 : 상품의 판매, 용역의 제공조건이나 그 대금의 지급조건을 공동으로 정하는 행위</li>
                        <li>거래제한 : 거래지역이나 거래상대방을 제한하는 행위</li>
                        <li>상품제한 : 상품의 생산, 판매 시에 그 상품의 종류 또는 규격을 제한하는 행위</li>
                        <li>사업활동 방해 : 다른 사업자의 사업활동이나 사업내용을 방해하거나 제한하는 행위</li>
                    </ul>



                    <h4 class="title">4. 사업자 단체의 금지행위</h4>
                    <ul class="list">
                        <li>부당한 공동행위에 의하여 부당하게 경쟁을 제한하는 행위</li>
                        <li>일정한 거래분야에 있어서 현재 또는 장래의 사업자수를 제한하는 행위</li>
                        <li>사업자 단체의 구성원인 사업자의 사업내용 또는 활동을 부당하게 제한하는 행위 등</li>
                    </ul>

                    <h4 class="title">5. 불공정 하도급거래 주요 유형</h4>
                    <ul class="list">
                        <li>하도급 계약서 (발주서 등), 수령증 등의 미교부</li>
                        <li>하도급 대금의 미지급 또는 지연지급, 어음할인료ㆍ지연이자의 미지급</li>
                        <li>물품의 수령거부, 부당반품ㆍ감액, 공정 타당한 검사기준의 미비</li>
                        <li>물품의 구매강제, 부당한 조기결제 요구, 부당한 대물변제, 부당한 경영간섭 등</li>
                    </ul>

                    <h4 class="title">6. 불공정 약관 주요 유형</h4>
                    <ul class="list">
                        <li>면책조항, 손해배상 등에 있어서 부당하게 고객에게 불리한 조항</li>
                        <li>계약의 해제, 해지, 항변권 등 권리의 행사에서 고객에게 부당하게 불리한 조항</li>
                        <li>물품의 수령거부, 의사표시의 의제, 채무의 이행, 소제기의 제한 등 부당하게 고객의 권리를 제한, 불리한 조항 공정 타당한<br>검사기준의 미비</li>
                    </ul>

                    <h4 class="title">7. 부당한 표시광고에 대한 규제</h4>
                    <ul class="list">
                        <li>부당한 표시/광고행위의 금지 : 허위, 과장, 기만, 부당비교, 비방 손해배상 등에 있어서 부당하게 고객에게 불리한 조항</li>
                        <li>중요한 표시 : 광고사항을 의무적으로 공개토록 공정위가 지정고시
                            <ul class="list_3depth">
                                <li>소비자 피해가 빈번하게 발생하고 그 피해의 사후구제가 곤란한 상황</li>
                                <li>상품, 용역의 내용이나 거래조건상 중대한 결함, 한계 등 소비자의 구매선택에 결정적 영향을 미치는 사항</li>
                            </ul>
                        </li>
                        <li>광고실증제 : 사업자 등은 자기가 행한 표시, 광고 중 사실과 관련된 사항은 이를 실증할 수 있어야 함</li>
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