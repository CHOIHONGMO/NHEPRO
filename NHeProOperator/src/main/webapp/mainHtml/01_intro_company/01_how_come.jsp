<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>DSPMRO</title>
    <!--<meta name="viewport" content="width=device-width, initial-scale=1.0">-->
    <link rel="stylesheet" href="/css/ymro/ui/style.css" type="text/css">
    <script type="text/javascript" src="/js/everuxf/everuxf.min.js"></script>
    <script type="text/javascript" src="/css/ymro/js/lib/jquery.bxslider.js"></script>
    <script type="text/javascript" src="/css/ymro/js/ui/common.js"></script>
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=8d2375069de7bc8aa3f6514a2de4634d&libraries=services"></script>
    <script>
        $(document).ready(function() {

            var mapContainer = document.getElementById('map'), // 지도를 표시할 div
                mapOption = {
                    center: new kakao.maps.LatLng(35.954042, 127.001268), // 지도의 중심좌표
                    level: 4 // 지도의 확대 레벨
                };

            // 지도를 생성합니다
            var map = new kakao.maps.Map(mapContainer, mapOption);

            // 주소-좌표 변환 객체를 생성합니다
            var geocoder = new kakao.maps.services.Geocoder();

            // 주소로 좌표를 검색합니다
            geocoder.addressSearch('전북 익산시 석암로3길 59(팔봉동 827-2)', function(result, status) {

                // 정상적으로 검색이 완료됐으면
                if (status === kakao.maps.services.Status.OK) {

                    var coords = new kakao.maps.LatLng(result[0].y, result[0].x);

                    // 결과값으로 받은 위치를 마커로 표시합니다
                    var marker = new kakao.maps.Marker({
                        map: map,
                        position: coords
                    });

                    // 인포윈도우로 장소에 대한 설명을 표시합니다
                    var infowindow = new kakao.maps.InfoWindow({
                        content: '<div style="width:150px;text-align:center;padding:6px 0;">본사</div>'
                    });
                    infowindow.open(map, marker);

                    // 지도의 중심을 결과값으로 받은 위치로 이동시킵니다
                    map.setCenter(coords);
                }
            });
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
    <div class="spot_bg spot_intro_company"></div>
    <!--// spot_bg-->

    <!--content-->
    <div class="contents contents_intro contents_intro_company contents_how_come">
        <ul class="tabs">
            <!--탭바 클릭됬을 경우 class="active" 추가-->
            <li><a href="/mainHtml/01_intro_company/01_ceo_intro.jsp"><span>CEO 인사말</span></a></li>
            <li><a href="/mainHtml/01_intro_company/01_intro_summary.jsp"><span>회사개요</span></a></li>
            <li><a href="/mainHtml/01_intro_company/01_intro_vision.jsp"><span>비젼과 미션</span></a></li>
            <li><a href="/mainHtml/01_intro_company/01_intro_history_2010.jsp"><span>연혁</span></a></li>
            <li class="active"><a href="#"><span>오시는 길</span></a></li>
        </ul>

        <p class="path"><span class="one">HOME</span><span class="two">회사소개</span><span class="three current">오시는 길</span></p>
        <ul class="tabs tabs_2depth tabs_col2">
            <li class="active"><a href="#">본사</a></li>
            <li><a href="/mainHtml/01_intro_company/01_how_come_2.jsp">지사</a></li>
        </ul>
        <div class="tabs_contents intro_how_come">
            <section class="info clearfix">
                <div>
                    <div class="desc_wrap clearfix">
                        <span class="title">주소</span>
                        <p class="desc">전북 익산시 석암로3길 59(팔봉동 827-2)</p>
                    </div>
                    <div class="desc_wrap clearfix">
                        <span class="title">전화</span>
                        <p class="desc">063 - 834 - 6384</p>
                    </div>
                </div>
                <div>
                    <div class="desc_wrap desc_wrap_mt clearfix">
                        <span class="title">팩스</span>
                        <p class="desc">063 - 835 - 6385</p>
                    </div>
                </div>
            </section>

            <section class="map_info">
            <div class="img_center">
                <div id="map" style="width:940px;height:502px;left: 40px;"></div>
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