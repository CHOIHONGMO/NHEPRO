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
           if('${param.type}' == 'V') {
               $('#vendor').focus();
           } else {
               $('#cust').focus();
           }
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
    <div class="spot_bg spot_customer_service"></div>
    <!--// spot_bg-->

    <!--content-->
    <div class="contents contents_cus_center contents_join_guide">
        <ul class="tabs tabs_col4">
            <!--탭바 클릭됬을 경우 class="active" 추가-->
            <li><a href="/mainHtml/03_customer/03_customer_opinion.jsp"><span>고객의 소리</span></a></li>
            <li class="active"><a href="/mainHtml/03_customer/03_join_guide.jsp"><span>가입안내</span></a></li>
            <li><a href="/mainHtml/03_customer/03_notice_list.jsp"><span>공지사항</span></a></li>
            <li><a href="/mainHtml/03_customer/03_faq_cus.jsp"><span>FAQ</span></a></li>
        </ul>

        <p class="path"><span class="one">HOME</span><span class="two">고객지원</span><span
                class="three current">가입안내</span></p>

        <div class="tabs_contents join_guide">
            <section class="guide_cus">
                <h3 class="title title_deco_blue_sq"><span class="title_point">타이틀</span>고객사</h3>

                <div class="border_box border_box_col1 join_order clearfix">
                    <div class="box">
                        <h6 class="box_title">신규 고객사 가입문의 (법인 가입시)</h6>
                        <dl>
                            <dt class="list_title">Tel</dt>
                            <dd class="list_desc">031-738-8157</dd>
                        </dl>
                        <dl>
                            <dt class="list_title">E-mail</dt>
                            <dd class="list_desc" style="margin-bottom: 32px;">suji@nhepro.com</dd>
                        </dl>

                        <div class="box box_radius box_add_arrow box_w_183 clearfix">
                            <div class="card card_color">
                                <div class="subject">01. 가입 문의</div>
                                <ul class="con">
                                    <li>가입시 상기 고객사담당자에게<br>연락 후 구비서류를<br>전달해 주시기 바랍니다.</li>
                                </ul>
                            </div>
                            <span class="arrow_order"></span>
                            <div class="card card_color">
                                <div class="subject">02. 실무 협의</div>
                                <ul class="con">
                                    <li>DSP MRO 고객사담당<br>직원과 미팅을 통해 실무적인<br>세부사항(품목,결제조건 등)에<br>대해 협의합니다.</li>
                                </ul>
                            </div>
                            <span class="arrow_order"></span>
                            <div class="card card_color">
                                <div class="subject">03. 계약 진행</div>
                                <ul class="con">
                                    <li>협의된 내용을 바탕으로<br>계약 체결 및 거래계약서를<br>작성 합니다.</li>
                                </ul>
                            </div>
                            <span class="arrow_order"></span>
                            <div class="card card_color">
                                <div class="subject">04. ID/PW 배정</div>
                                <ul class="con">
                                    <li>계약 완료 후 e-mail 주소로<br>ID/PW를 전송해 드립니다.</li>
                                </ul>
                            </div>
                            <span class="arrow_order"></span>
                            <div class="card card_color card_padding">
                                <div class="subject">05. 로그인</div>
                                <ul class="con">
                                    <li>메인 홈페이지에서 전송 받은<br>ID/PW를 통해 당사 구매<br>시스템에 접속하시어 서비스를<br>이용하실 수 있습니다.</li>
                                </ul>
                            </div>
                            <div class="card card_color card_padding" style="float: right; position: relative; right: 5.5%; text-align: left; width: 305px; padding-top: 114px;">
                                <ul class="con" style="border-radius: 9px; height: 105px;">
                                    <li style="padding-left: 10px; line-height: 25px;">
                                        <span style="font-weight: bold">※ 구비서류</span><br>
                                        ㆍ사업자등록증 사본<br>
                                        ㆍ우편, e-mail 또는 Fax로 보내주시기 바랍니다.
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- <a id="cust" href="#" class="btn btn_no_icon">약관동의 및 ID 발급 신청</a> -->

            </section>

            <section class="guide_sup">
                <h5 class="title title_deco_blue_sq"><span class="title_point">타이틀</span>공급사</h5>
                <div class="border_box border_box_col1 join_order clearfix">
                    <div class="box">
                        <h4 class="box_title">신규 공급사 등록절차</h4>
                        <p class="desc">신규 공급사로 신청을 원하시는 경우 아래의 절차에 따라 주시기 바랍니다.</p>
                        <div class="box box_radius box_add_arrow box_w_183 clearfix">
                            <div class="card card_color">
                                <div class="subject">01. 가입문의</div>
                                <ul class="con">
                                    <li>품목담당자와 상담을 통해<br>가입 진행하세요.<br>
                                        <em class="point">031-738-8157</em></li>
                                </ul>
                            </div>
                            <span class="arrow_order"></span>
                            <div class="card card_color">
                                <div class="subject">02. 약관동의</div>
                                <ul class="con">
                                    <li>가입신청 시 약관을 확인하시고<br>동의하시기 바랍니다.</li>
                                </ul>
                            </div>
                            <span class="arrow_order"></span>
                            <div class="card card_color">
                                <div class="subject">03. 가입신청</div>
                                <ul class="con">
                                    <li>기재사항을 확인하시고<br>정확하게 입력바랍니다.</li>
                                </ul>
                            </div>
                            <span class="arrow_order"></span>
                            <div class="card card_color">
                                <div class="subject">04. ID/PW 배정</div>
                                <ul class="con">
                                    <li>[가입신청]에서 입력하신<br>e-mail주소로 사용하실<br>ID/PW를 전송해드립니다.</li>
                                </ul>
                            </div>
                            <span class="arrow_order"></span>
                            <div class="card card_color card_padding">
                                <div class="subject">05. 로그인</div>
                                <ul class="con">
                                    <li>메인 홈페이지에서 전송 받은<br>ID/PW를 통해 구매시스템을<br>사용하실 수 있습니다.</li>
                                </ul>
                            </div>
                            <span  style="background-position: -400px -60px;" class="arrow_order"></span>
                            <div class="card card_color card_padding">
                                <div class="subject">06. 계약체결 및 서류제출</div>
                                <ul class="con">
                                    <li>거래시작 전 반드시 공급사<br>거래기본계약 및 관련서류의<br>제출이 필요합니다.</li>
                                </ul>
                            </div>
                            <a id="vendor" href="/mainHtml/06_register/06_register_step01.jsp" class="btn btn_no_icon">약관동의 및 ID 가입신청</a>
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
</div>
<!--// wrap-->
</body>
</html>