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
        $(document).ready(function () {
            $('#mainIframe', parent.document).css('height', document.body.scrollHeight + 57);

            var param = {
                'NOTICE_NUM': '${param.NOTICE_NUM}'
            };

            $.post("/ymro/mainNoticeDetail.so", param, function (data) {
                console.log(data);
                $('#title').text(data.SUBJECT);
                $('#date').text(data.REG_DATE);
                $('#contents').html(data.TEXT_CONTENTS);

            }, "json");
        });
    </script>
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
    <div class="spot_bg spot_customer_service">
        <h2 class="title"><span>에스티원즈는</span><br>좋은 인재와 기술을 바탕으로<br>
            최상의 구매서비스와 가치를 창출하여 고객과 함께하겠습니다.</h2>
    </div>
    <!--// spot_bg-->

    <!--content-->
    <div class="contents contents_cus_center contents_notice">
        <ul class="tabs tabs_col4">
            <!--탭바 클릭됬을 경우 class="active" 추가-->
            <li><a href="/mainHtml/03_customer/03_customer_opinion.jsp"><span>고객의 소리</span></a></li>
            <li><a href="/mainHtml/03_customer/03_join_guide.jsp"><span>가입안내</span></a></li>
            <li class="active"><a href="/mainHtml/03_customer/03_notice_list.jsp"><span>공지사항</span></a></li>
            <li><a href="/mainHtml/03_customer/03_faq_cus.jsp"><span>FAQ</span></a></li>
        </ul>

        <p class="path"><span class="one">HOME</span><span class="two">고객지원</span><span
                class="three current">공지사항</span></p>

        <div class="tabs_contents notice_detail">
            <section class="clearfix">
                <div class="board_list">
                    <div class="title_area">
                        <h3 class="title" id="title"></h3>
                        <p class="date" id="date"></p>
                    </div>
                    <div class="contents_area" id="contents">
                    </div>
                </div>
                <a class="btn btn_no_radius" href="javascript:history.back();">목록</a>
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