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
        <div class="spot_bg spot_user_registery"></div>
        <!--// spot_bg-->

        <!--content-->
        <div class="contents contents_user contents_site_map clearfix">
            <div class="clearfix">
                <h3 class="title title_h_28">SITEMAP</h3>

                <section>
                    <div class="site_title col_4 clearfix">
                        <p>회사소개</p>
                        <p>사업소개</p>
                        <p>고객지원</p>
                        <p>윤리경영</p>
                    </div>
                    <div class="site_list col_4 clearfix">
                        <ul>
                            <li><a href="/mainHtml/01_intro_company/01_ceo_intro.jsp">CEO 인사말</a></li>
                            <li><a href="/mainHtml/01_intro_company/01_intro_summary.jsp">회사개요</a></li>
                            <li><a href="/mainHtml/01_intro_company/01_intro_vision.jsp">비젼/미션</a></li>
                            <li><a href="/mainHtml/01_intro_company/01_intro_history_2010.jsp">연혁</a></li>
                            <li><a href="/mainHtml/01_intro_company/01_how_come.jsp">오시는 길</a></li>
                        </ul>
                        <ul>
                            <li><a href="/mainHtml/02_intro_business/02_purchase_service.jsp">MRO</a></li>
                            <li><a href="/mainHtml/02_intro_business/02_delivery_service.jsp">도입효과</a></li>
                            <li><a href="/mainHtml/02_intro_business/02_transport_service.jsp">거래품목</a></li>
                        </ul>
                        <ul>
                            <li><a href="/mainHtml/03_customer/03_customer_opinion.jsp">고객의 소리</a></li>
                            <li><a href="/mainHtml/03_customer/03_join_guide.jsp">가입안내</a></li>
                            <li><a href="/mainHtml/03_customer/03_notice_list.jsp">공지사항</a></li>
                            <li><a href="/mainHtml/03_customer/03_faq_cus.jsp">FAQ</a></li>
                        </ul>
                        <ul>
                            <li><a href="/mainHtml/05_ethical_management/05_ethical_policy.jsp">윤리경영</a></li>
                            <li><a href="/mainHtml/05_ethical_management/05_fair_trade_rule.jsp">공정거래</a></li>
                        </ul>
                    </div>
                    <div class="site_user col_5 clearfix">
                        <p><a href="/mainHtml/06_register/06_register_step01.jsp">회원가입</a></p>
                        <p><a href="/mainHtml/07_search_id_n_pw/07_search_id_pw.jsp">ID/PW 찾기</a></p>
                        <p><a href="/mainHtml/08_policy_use/08_policy_use.jsp">이용약관</a></p>
                        <p><a href="/mainHtml/09_policy_info_treat/09_policy_info_treat.jsp">개인정보 취급방침</a></p>
                        <p><a href="/mainHtml/10_policy_info_process/10_policy_info_process.jsp">개인정보 처리방침</a></p>
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