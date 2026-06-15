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
    <div class="contents contents_ad_center contents_csr contents_csr_intro">
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
            <li><a href="/mainHtml/04_ad_center/04_csr_state.jsp">CSR 추진현황</a></li>
            <li class="active"><a href="/mainHtml/04_ad_center/04_csr_intro.jsp">CSR 소개</a></li>
        </ul>
        <div class="sub_tab_02">
            <section class="top">
                <div class="round_list_box_wrap">
                    <h5 class="title"><span class="title_point">타이틀</span>효행상 제정 및 시생 <em class="eng">Compliance
                        Program</em></h5>
                    <div class="round_list_box round_list_box_horizon clearfix">
                        <img src="/images/ymro/sub/csr_intro_img01.png" alt="효행상 제정 및 시생 ">
                        <ul>
                            <li>인류의 기본 및 아름다운 효 정신을 용마가족에게 전파하기 위해<br>
                                2015년부터 지속적으로 직원 및 DS, 협력사원 중 효행 공적내용을<br>
                                공정하게 심사하여 효행자를 선발하고 있습니다.

                            </li>
                            <li>효행자에게는 상금으로 1백만원과 부상으로 리조트 2박3일 숙박권을<br>
                                시상하여 가족과 여행을 갈 수 있도록 배려하고 있습니다.
                            </li>
                        </ul>
                    </div>
                </div>
                <div class="round_list_box_wrap">
                    <h5 class="title"><span class="title_point">타이틀</span>용마와 봉사해요!<em class="eng">Environment
                        Program</em></h5>
                    <div class="round_list_box round_list_box_horizon clearfix">
                        <img src="/images/ymro/sub/csr_intro_img02.png" alt="용마와 봉사해요!">
                        <ul>
                            <li>전국 각 부서에서 자발적으로 계획하는 봉사활동을 실시하고 있습니다.</li>
                            <li>소외계층을 찾아가는 노력봉사, 사회적 이슈를 주제로 한 테마봉사,<br>
                                임직원의 재능을 기부하는 재능 나눔 등으로 매년 1회 이상 꾸준히<br>
                                사회공헌 활동을 하고 있습니다
                            </li>
                        </ul>
                    </div>
                </div>
                <div class="round_list_box_wrap">
                    <h5 class="title"><span class="title_point">타이틀</span>사랑의 우수리 계좌모금<em class="eng">Corporate Social
                        Responsibility</em></h5>
                    <div class="round_list_box round_list_box_horizon clearfix">
                        <img src="/images/ymro/sub/csr_intro_img03.png" alt="사랑의 우수리 계좌모금">
                        <ul>
                            <li>전 임직원이 급여에서 우수리 금액을 기부하여 김포 및 안성지역<br>
                                저소득학생에게 장학금을 지급하고 있습니다.
                            </li>

                            <li>장학금 대상자 중 우수자는 회사 채용시 우대하여 더불어 행복한<br>
                                사회를 만드는데 앞장서고 있습니다.
                            </li>
                        </ul>
                    </div>
                </div>
                <div class="round_list_box_wrap">
                    <h5 class="title"><span class="title_point">타이틀</span>실버카 기부<em class="eng">Corporate Social
                        Responsibility</em></h5>
                    <div class="round_list_box round_list_box_horizon clearfix">
                        <img src="/images/ymro/sub/csr_intro_img04.png" alt="실버카 기부">
                        <ul>
                            <li>매년 권역별로 실시하는 CS교육과 연계하여 온정나눔골든벨을 통해<br>
                                실버카를 조립하였고,
                            </li>
                            <li>직원 및 DS 중 거동이 불편한 부모님과 노인복지회관에 실버카<br>
                                44대를 기부하였습니다.
                            </li>
                        </ul>
                    </div>
                </div>
                <div class="round_list_box_wrap">
                    <h5 class="title"><span class="title_point">타이틀</span>희망꾸러미 배송<em class="eng">Corporate Social
                        Responsibility</em></h5>
                    <div class="round_list_box round_list_box_horizon clearfix">
                        <img src="/images/ymro/sub/csr_intro_img05.png" alt="희망꾸러미 배송">
                        <ul>
                            <li>회사 물류 인프라를 활용하여 김포 관내 불우이웃 가정 100곳에<br>
                                희망꾸러미(월동물품)를 무료 배송 하고 있습니다.
                            </li>
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