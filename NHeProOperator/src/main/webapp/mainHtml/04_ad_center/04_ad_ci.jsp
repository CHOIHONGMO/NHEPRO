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
    <script>
        $('#mainIframe', parent.document).css('height', '4220px');
    </script>
</head>
<body>
<!--wrap-->
<div class="wrap sub_page" style="height: 100vh;">
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
    <div class="contents contents_ad_center contents_ad contents_ad_ci">
        <ul class="tabs tabs_col4">
            <!--탭바 클릭됬을 경우 class="active" 추가-->
            <li><a href="/mainHtml/04_ad_center/04_award_2010.jsp"><span>수상 및 인증</span></a></li>
            <li><a href="/mainHtml/04_ad_center/04_right_human_type.jsp"><span>인재상</span></a></li>
            <li class="active"><a href="/mainHtml/04_ad_center/04_ad_ci.jsp"><span>홍보</span></a></li>
            <li><a href="/mainHtml/04_ad_center/04_csr_state.jsp"><span>CSR</span></a></li>
        </ul>

        <p class="path"><span class="one">HOME</span><span class="two">홍보센터</span><span class="three current">홍보</span>
        </p>

        <ul class="tabs tabs_2depth tabs_col2">
            <li class="active"><a href="04_ad_ci.jsp">CI</a></li>
            <li><a href="04_ad_doc.jsp">홍보자료</a></li>
        </ul>

        <div class="sub_tab_01">
            <section class="top">
                <div class="symbol clearfix">
                    <h5 class="title"><span class="title_point">타이틀</span>동아쏘시오그룹의 '피닉스'심볼</h5>
                    <img src="/images/ymro/sub/donga_symbol.png" alt="동아쏘시오그룹의 '피닉스'심볼">
                    <div class="desc_box">
                        <p class="sub_title">디자인 모티브는 <em>불사조의 불멸성과 힘차게 비상하는<br>날개를 컨셉</em>으로 무궁한 발전을 나타냅니다.</p>
                        <p class="desc"><em>첫째,</em> 영원한 마음가짐으로 고객의 건강과 행복을 위하여 서비스하는<br>불변의 동아인을 상징합니다.</p>
                        <p class="desc"><em>둘째,</em>언제나 새로운 연구와 개발로 우수의약품을 생산하여 인류질병<br>퇴치에 앞장서는 진취적인 기업으로서의 참모습을 표현합니다.
                        </p>
                        <p class="desc"><em>셋째,</em>모든 동아인은 동료로서의 믿음과 우호를 함께 나누며 모든 관련<br>기업과도 협동을 바탕으로 신의를 지켜 사회발전에 일익을
                            담당한다는<br>다짐을 나타냅니다.</p>
                    </div>
                </div>


                <div class="logo_type clearfix">
                    <h5 class="title"><span class="title_point">타이틀</span>CI 로고타입</h5>
                    <img src="/images/ymro/sub/ci_logo_type.png" alt="CI 로고타입">
                    <p>* 시그니처의 비례 또는 간격을 임으로 변경해서는 안됩니다.
                        <!--                         <a class="btn" href="http://yongmalogis.co.kr/resources/img/si_03_jpg.zip"><em class="icon icon_download">다운로드</em>AI</a>
                                                <a class="btn" href="#"><em class="icon icon_download">다운로드</em>JPG</a> -->
                    </p>
                </div>


                <div class="color_system clearfix">
                    <h5 class="title"><span class="title_point">타이틀</span>컬러시스템</h5>
                    <img src="/images/ymro/sub/ci_color_system.png" alt="컬러시스템">
                    <p class="desc">심볼의 색은 모든 매체를 통하여 동아쏘시오그룹의 코퍼레이트 컬러인 동아블루의 사용을 원칙으로 하며 흑백 매체인 경우에는 블랙으로 적용할 수도<br>있습니다.
                        또한 시각적으로 특수한 효과를 필요로 할 경우에는 금색과 은색을 적용할 수도 있습니다.</p>
                </div>


                <div class="ci_history clearfix">
                    <h5 class="title"><span class="title_point">타이틀</span>CI History</h5>
                    <img class="ci_history_img" src="/images/ymro/sub/ci_history.png" alt="CI History">

                    <div class="iist">
                        <img src="/images/ymro/sub/ci_1945.png" alt="1945’year - 1959’year ci">
                        <p class="year"><em>1945'</em>year - <em>1959'</em>year</p>
                        <p>전체형태는 지구를 상징하며 원 가운데의 東은 東亞를 의미합니다.<br>동아는 광역의 의미로서, 온 천하에 넓게 퍼져 나간다는 의미를 담고 있습니다.</p>
                    </div>

                    <div class="iist">
                        <img src="/images/ymro/sub/ci_1959.png" alt="1959’year - 1972’year ci">
                        <p class="year"><em>1959'</em>year - <em>1972'</em>year</p>
                        <p>윗부분에 접하는 2개의 원은 동아의 2개의 ‘ㅇ’을 형상화한 것입니다. 가운데 6각형은 화학기호 벤젠핵으로 다이아몬드를<br>나타내며 동아가 의약품 제조업에 있음을
                            의미합니다.</p>
                    </div>
                    <div class="iist">
                        <img src="/images/ymro/sub/ci_1973.png" alt="1973’year - 1982’year ci">
                        <p class="year"><em>1973'</em>year - <em>1982'</em>year</p>
                        <p>전체 형태는 東亞의 亞를 변형, 도안화한 것으로 전체 형태는 지구를 상징합니다.
                            동의 첫자인 ㄷ을 ◇으로,아의 첫자인 ㅇ을 외곽 ㅇ으로 나타냈습니다. 또 상반부의 은 제약의 ㅈ을 나타냅니다.<br>전체적으로 사각과 원을 조화시켜서 외유내강과
                            무궁한 발전을 상징합니다. 원만함과 친숙함을 상징하는 원을 중심으로<br>밖으로는 우수한 의약품을 생산하여 인류의 건강과 복지향상에 이바지하는 봉사의 마음을,
                            안으로는 사원 간의 협동,<br>단결하는 마음을 나타냅니다.</p>
                    </div>
                    <div class="iist present">
                        <img src="/images/ymro/sub/ci_1982.png" alt="1982’year - 현재 ci">
                        <p class="year"><em>1982'</em>year - <em>현재</em></p>
                        <p><em>동아제약의 심볼은</em><br>첫째, 영원한 마음가짐으로 고객의 건강과 행복을 위하여 서비스하는 불변의 동아인을 뜻하고,<br>둘째, 언제나 새로운 연구와
                            개발로 우수의약품을 생산하여 인류질병 퇴치에 앞장서는 진취적인 기업으로서의 참모습을 뜻하며,<br>셋째, 모든 동아인은 동료로서의 믿음과 우호를 함께 나누며 모든
                            관련기업과도 협동을 바탕으로 신의를 지켜 사회발전에 일익을<br>담당한다는 세가지 정신을 토대로 계획, 디자인되었습니다.<br>디자인 모티브는 불사조의 불멸성과
                            힘차게 비상하는 날개를 컨셉으로 동아쏘시오그룹의 무궁한 발전을 나타냅니다.</p>
                    </div>
                </div>

                <div class="no_use clearfix">
                    <h5 class="title"><span class="title_point">타이틀</span>사용금지규정</h5>
                    <img src="/images/ymro/sub/no_use_logo.png" alt="사용금지규정">
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