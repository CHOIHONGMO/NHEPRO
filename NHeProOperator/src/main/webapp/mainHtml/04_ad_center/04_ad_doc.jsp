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
    <div class="contents contents_ad_center contents_ad contents_ad_doc">
        <ul class="tabs tabs_col4">
            <!--탭바 클릭됬을 경우 class="active" 추가-->
            <li><a href="/mainHtml/04_ad_center/3_award_2010.jsp"><span>수상 및 인증</span></a></li>
            <li><a href="/mainHtml/04_ad_center/04_right_human_type.jsp"><span>인재상</span></a></li>
            <li class="active"><a href="/mainHtml/04_ad_center/04_ad_ci.jsp"><span>홍보</span></a></li>
            <li><a href="/mainHtml/04_ad_center/04_csr_state.jsp"><span>CSR</span></a></li>
        </ul>

        <p class="path"><span class="one">HOME</span><span class="two">홍보센터</span><span class="three current">홍보</span>
        </p>

        <ul class="tabs tabs_2depth tabs_col2">
            <li><a href="/mainHtml/04_ad_center/04_ad_ci.jsp">CI</a></li>
            <li class="active"><a href="/mainHtml/04_ad_center/04_ad_doc.jsp">홍보자료</a></li>
        </ul>
        <div class="sub_tab_02">
            <section class="top">
                <div class="brochure clearfix">
                    <h5 class="title"><span class="title_point">타이틀</span>홍보 브로슈어</h5>
                    <div class="img">홍보 브로슈어</div>
                    <p>EXPERTS OF LOGISTICS</p>
                    <a class="btn" href="#"><em class="icon icon_download">다운로드</em>Brochure (PDF)</a>
                </div>
                <div class="certify_mark clearfix">
                    <h5 class="title"><span class="title_point">타이틀</span>인증마크</h5>
                    <div class="img kmar">KmAR ISO 9001/14001</div>
                    <div class="img green">우수녹색물류실천기업 국토교통부</div>
                    <div class="img celc">CELC 인증우수물류기업 물류창고기업</div>
                    <div class="img celc_transport">CELC 인증우수물류기업 화물자동차운송기업</div>
                    <div class="img web_award">WEB AWARD 13TH NOMINEE</div>
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