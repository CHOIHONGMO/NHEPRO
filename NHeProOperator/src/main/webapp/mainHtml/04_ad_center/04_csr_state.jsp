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
    <div class="contents contents_ad_center contents_csr contents_csr_state">
        <ul class="tabs tabs_col4">
            <!--탭바 클릭됬을 경우 class="active" 추가-->
            <li><a href="/mainHtml/04_ad_center/04_award_2010.jsp"><span>수상 및 인증</span></a></li>
            <li><a href="/mainHtml/04_ad_center/04_right_human_type.jsp"><span>인재상</span></a></li>
            <li><a href="/mainHtml/04_ad_center/04_ad_ci.jsp"><span>홍보</span></a></li>
            <li class="active"><a href="/mainHtml/04_ad_center/04_csr_state.jsp"><span>CSR</span></a></li>
        </ul>

        <p class="path"><span class="one">HOME</span><span class="two">홍보센터</span><span class="three current">CSR</span>
        </p>

        <ul class="tabs tabs_2depth tabs_col2">
            <li class="active"><a href="/mainHtml/04_ad_center/04_csr_state.jsp">CSR 추진현황</a></li>
            <li><a href="/mainHtml/04_ad_center/04_csr_intro.jsp">CSR 소개</a></li>
        </ul>
        <div class="sub_tab_01">
            <section class="top">
                <div class="round_list_box_wrap">
                    <h5 class="title"><span class="title_point">타이틀</span>윤리경영<em class="eng">Compliance Program</em>
                    </h5>
                    <div class="round_list_box round_list_box_horizon clearfix">
                        <img src="/images/ymro/sub/csr_compliance.png" alt="윤리경영">
                        <ul>
                            <li>투명 경영을 실천하기 위해 홈페이지내 사이버 감사실을 운영하고 있습니다.</li>
                            <li class="point"><a href="https://www.donga.co.kr/Pass.da?viewPath=/b08/tipguide"
                                                 target="_blank">☞ 동아쏘시오홀딩스 감사실 바로가기</a></li>
                            <li>불공정한 업무처리, 직위를 이용한 부당 요구 및 비리, 성희롱 및 직장 질서문란 행위,<br>기타 비윤리적 행위에 대해 제보를 받습니다.</li>
                            <li>회사는 상담, 신고자의 신분 및 신고내용을 철저히 보호하며, 이로 인한 어떠한<br>불이익도 주지 않습니다.</li>
                        </ul>
                    </div>
                </div>
                <div class="round_list_box_wrap">
                    <h5 class="title"><span class="title_point">타이틀</span>환경경영<em class="eng">Environment Program</em>
                    </h5>
                    <div class="round_list_box round_list_box_horizon clearfix">
                        <img src="/images/ymro/sub/csr_environment.png" alt="환경경영">
                        <ul>
                            <li>지속 가능한 “저탄소 녹색성장 구현”을 위해 녹색물류를 실천하고 있습니다.</li>
                            <li>2009년부터 전사적 탄소배출정보시스템을 구축하여 총 배출량을 관리하고 있습니다.</li>
                            <li>수송차량 대형화로 물류비용 및 탄소배출량 절감에 노력하고 있습니다.</li>
                        </ul>
                    </div>
                </div>
                <div class="round_list_box_wrap">
                    <h5 class="title"><span class="title_point">타이틀</span>사회공헌<em class="eng">Corporate Social
                        Responsibility</em></h5>
                    <div class="round_list_box round_list_box_horizon clearfix">
                        <img src="/images/ymro/sub/csr_corporate.png" alt="사회공헌">
                        <ul>
                            <li>물류업계 최초로 효행상을 제정하여 시행하고 있습니다.</li>
                            <li>2015년부터
                                &lt;용마와 봉사해요&gt; 프로그램을 통해 전 임직원이 전국 각 지점에서<br>다양한 사회공헌 활동을 하고 있습니다.
                            </li>
                            <li>전 임직원이 기부하는 사랑의 우수리 계좌 모금으로 어려운 이웃을 돌아보고 있습니다.</li>
                            <li>교육과정과 연계하여 직원, DS 부모님 및 노인복지회관에 실버카를 기부하였습니다.</li>
                            <li>추운 겨울 불우이웃 가정 100곳에 희망꾸러미(월동물품)를 무료 배송하고 있습니다.</li>
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
</div>
<!--// wrap-->
</body>
</html>