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
    <script>
        $(document).ready(function() {
            $('#mainIframe', parent.document).css('height', '3256px');
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
    <!--사업소개 : spot_intro_business-->
    <div class="spot_bg spot_intro_business">
        <h2 class="title"><span>용마로지스는</span><br>최첨단 Infra와 전문화된 e-Sourcing 시스템을 기반으로<br>구매부터 관리까지의 통합구매서비스를 제공합니다.
        </h2>
    </div>
    <!--// spot_bg-->

    <!--content-->
    <div class="contents contents_intro contents_intro_business contents_intro_delivery">
        <ul class="tabs tabs_col4">
            <li><a href="/mainHtml/02_intro_business/02_purchase_service.jsp">구매서비스</a></li>
            <li class="active"><a href="/mainHtml/02_intro_business/02_delivery_service.jsp">택배서비스</a></li>
            <li><a href="/mainHtml/02_intro_business/02_transport_service.jsp">수송서비스</a></li>
            <li><a href="/mainHtml/02_intro_business/02_give_worthy_customer.jsp">가치제공</a></li>
        </ul>

        <p class="path"><span class="one">HOME</span><span class="two">사업소개</span><span
                class="three current">택배서비스</span></p>
        <ul class="tabs tabs_2depth tabs_col4">
            <li><a href="/mainHtml/02_intro_business/02_delivery_service.jsp">소개</a></li>
            <li class="active"><a href="/mainHtml/02_intro_business/02_delivery_service_flow.jsp">FLOW</a></li>
            <li><a href="/mainHtml/02_intro_business/02_delivery_service_network.jsp">NETWORK</a></li>
            <li><a href="/mainHtml/02_intro_business/02_delivery_service_contact.jsp">CONTACT POINT</a></li>
        </ul>

        <div class="sub_tab_02">
            <section class="top">
                <h3 class="sub_title">Know-how 바탕의 신개념 택배서비스</h3>
                <h4 class="txt">용마로지스는 복잡하고 까다로운 의약품택배의 경험과 Know-how를 바탕으로<br>신개념의 택배서비스시스템을 구축하고 "고객의 마음까지 전달"해 드리기 위해
                    노력하고 있습니다.</h4>
            </section>

            <section class="middle">
                <div class="feature clearfix">
                    <h5 class="title"><span class="title_point">타이틀</span>택배 서비스의 특징</h5>
                    <img class="flow_img" src="/images/ymro/sub/delivery_flow_feature.png"
                         alt="D일 화주사/3PL물류센터 집하 안성물류센터 분류, D+1일 간선수송 용마로지스 배송 고객(병의원, 약국, 백화점, 도소매)">
                    <p class="desc">고객사로부터 접수된 택배주문에 대하여 집하,분류,택배센터별 수송을 거쳐 전국 택배센터에서 최종소비자에게 전달됩니다. 또한 용마로지스는<br>무선
                        통신기술(스마트폰&스캐너(블루투스)), 스마트 택배 시스템등 차량관제시스템 기반의 첨단 택배관리시스템을 통하여 택배 전과정에 대해<br>신뢰성있는 화물추적정보를 제공해
                        드립니다.</p>
                    <div class="horizon_box horizon_box_col2 clearfix">
                        <h6 class="box_title">집하 및 분류</h6>
                        <div class="box">
                            <img src="/images/ymro/sub/delivery_flow_clarify_01.png" alt="종합물류서비스 역량">
                            <p class="list_title">종합물류서비스 역량</p>
                            <p class="list_desc">화주고객이 지정하는 시간에 집하할 수 있는 맞춤형 집화
                                서비스를 제공합니다.</p>
                        </div>
                        <div class="box">
                            <img src="/images/ymro/sub/delivery_flow_clarify_02.png" alt="정확한 지역 택배센터별 분류">
                            <p class="list_title">정확한 지역 택배센터별 분류</p>
                            <p class="list_desc">화주고객이 지정하는 시간에 집하할 수 있는 맞춤형 집화
                                서비스를 제공합니다.</p>
                        </div>
                    </div>

                    <div class="horizon_box horizon_box_col2 clearfix">
                        <h6 class="box_title">택배서비스</h6>
                        <div class="box">
                            <img src="/images/ymro/sub/delivery_flow_deliver_01.png" alt="2인 택배 서비스 진행">
                            <p class="list_title">2인 택배 서비스 진행</p>
                            <p class="list_desc">운전원과 정규 택배직원의 동승에 의한 2인 택배을 실시
                                하여 고객에게 보다 친절하고 신뢰성 있는 고품질의
                                택배서비스를 제공합니다.</p>
                        </div>
                        <div class="box">
                            <img src="/images/ymro/sub/delivery_flow_deliver_02.png" alt="전국 직영 택배센터의 운영">
                            <p class="list_title">전국 직영 택배센터의 운영</p>
                            <p class="list_desc">모든 택배센터의 직영체제로의 운영함으로써 고객의 다양한
                                Needs와 Claim에 대응하고 있습니다.</p>
                        </div>
                        <div class="box">
                            <img src="/images/ymro/sub/delivery_flow_deliver_03.png" alt="전국 직영 택배센터의 운영">
                            <p class="list_title">전담 택배 서비스 진행</p>
                            <p class="list_desc">전문 의약품 또는 특화 된 택배 서비스가 필요한 경우
                                별도의 컨설턴팅을 통한 최적화된 전담 택배 서비스를 제공합니다.<br>
                                現 고객사 : 박스터, 보스톤 등 다수</p>
                        </div>
                        <div class="box">
                            <img src="/images/ymro/sub/delivery_flow_deliver_04.png" alt="전국 직영 택배센터의 운영">
                            <p class="list_title">백화점 오픈 전 서비스 제공</p>
                            <p class="list_desc">백화점 납품 화주의 경우 별도의 오픈 전(오전)택배 서비스를
                                통해 화주사의 편의에 부합하는 택배 서비스를 제공하고 있습니다.</p>
                        </div>
                        <div class="box">
                            <img src="/images/ymro/sub/delivery_flow_deliver_05.png" alt="전국 직영 택배센터의 운영">
                            <p class="list_title">로드샵 화장품 전담 차량 운영</p>
                            <p class="list_desc">전문 의약품 또는 특화 된 택배 서비스가 필요한 경우
                                별도의 컨설턴팅을 통한 최적화된 전담 택배 서비스를
                                제공합니다.<br>
                                現 고객사 : 박스터, 보스톤 등 다수</p>
                        </div>
                    </div>

                    <div class="horizon_box horizon_box_col1 clearfix">
                        <h6 class="box_title">취소 및 반품 서비스</h6>
                        <div class="box">
                            <img src="/images/ymro/sub/delivery_flow_refund_01.png" alt="취소 반품 사유 제공 및 신속한 업무처리 진행">
                            <p class="list_title">취소 반품 사유 제공 및 신속한 업무처리 진행</p>
                            <p class="list_desc">운전원과 정규 택배직원의 동승에 의한 2인 택배을 실시<br>하여 고객에게 보다 친절하고 신뢰성 있는 고품질의<br>택배서비스를
                                제공합니다.</p>
                        </div>
                    </div>

                    <div class="horizon_box horizon_box_col1 clearfix">
                        <h6 class="box_title">인수증관리</h6>
                        <div class="box">
                            <img src="/images/ymro/sub/delivery_flow_receipt_01.png"
                                 alt="고객사의 인수증 날인 및 인수증 보관 관리 서비스 제공">
                            <p class="list_title">고객사의 인수증 날인 및 인수증 보관 관리 서비스 제공</p>
                            <p class="list_desc">화물 인도시 철저하게 인수증 날인을 실시하며, 요청시 각 택배센터에서<br>인수증 보관 관리 서비스를 제공</p>
                        </div>
                    </div>

                    <div class="horizon_box horizon_box_col1 clearfix">
                        <h6 class="box_title">화물추적 서비스</h6>
                        <div class="box">
                            <img src="/images/ymro/sub/delivery_flow_trace_01.png" alt="취소 반품 사유 제공 및 신속한 업무처리 진행">
                            <p class="list_title">Internet 및 스마트폰을 통한 화물의 처리상황 정보 제공</p>
                            <p class="list_desc">실시간 화물의 위치추적 및 Lead-Time, 취소 반품율 등 각종 통계분석<br>정보를 고객 및 영업사원에게 제공합니다.
                            </p>
                        </div>
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
</div><!--// wrap-->
</body>
</html>