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
        <div class="spot_bg spot_user_registery"></div>
        <!--// spot_bg-->

        <!--content-->
        <div class="contents contents_user contents_registery clearfix">
            <div class="registery_step03">
                <section class="step">
                    <h3 class="title title_h_28">회원가입</h3>
                    <div class="step_bar clearfix">
                        <div><em>STEP 1</em><br>약관동의</div>
                        <span class="sprite sprite_common sprite_next text_out">다음</span>
                        <div><em>STEP 2</em><br>정보입력</div>
                        <span class="sprite sprite_common sprite_next text_out">다음</span>
                        <div class="active"><em>STEP 3</em><br>가입완료</div>
                    </div>
                </section>

                <section class="complete">
                    <span class="sprite sprite_common">회원가입 완료</span>
                    <p><em>용마로지스 회원가입 신청이</em>완료되었습니다.</p>
                    <div class="btn_wrap">
                        <a href="#" class="btn btn_no_icon btn_middle">메인화면 가기</a>
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