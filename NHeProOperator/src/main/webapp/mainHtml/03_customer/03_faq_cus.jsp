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
        function resize() {
            $('#mainIframe', parent.document).css('height', document.body.scrollHeight);
        }
    </script>
</head>
<body onload="resize();">
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
    <div class="contents contents_cus_center contents_faq">
        <ul class="tabs tabs_col4">
            <!--탭바 클릭됬을 경우 class="active" 추가-->
            <li><a href="/mainHtml/03_customer/03_customer_opinion.jsp"><span>고객의 소리</span></a></li>
            <li><a href="/mainHtml/03_customer/03_join_guide.jsp"><span>가입안내</span></a></li>
            <li><a href="/mainHtml/03_customer/03_notice_list.jsp"><span>공지사항</span></a></li>
            <li class="active"><a href="/mainHtml/03_customer/03_faq_cus.jsp"><span>FAQ</span></a></li>
        </ul>

        <p class="path"><span class="one">HOME</span><span class="two">고객지원</span><span class="three current">FAQ</span>
        </p>

        <ul class="tabs tabs_2depth tabs_col2">
            <li class="active"><a href="/mainHtml/03_customer/03_faq_cus.jsp">고객사</a></li>
            <li><a href="/mainHtml/03_customer/03_faq_sup.jsp">공급사</a></li>
        </ul>

        <div class="tabs_contents faq_cus">
            <section class="join">
                <h3 class="title title_deco_blue_sq"><span class="title_point">타이틀</span>회원가입</h3>

                <div class="border_box border_box_list clearfix">
                    <div class="list_wrap clearfix">
                        <dl class="list clearfix">
                            <dt class="q">question</dt>
                            <dd class="tit"><a href="javascript:resize();">고객사 가입은 어떻게 해야하는 건가요?</a></dd>
                        </dl>
                        <div class="answer_box clearfix">
                            <span class="a">answer</span>
                            <p class="answer">1) DSP MRO와 귀사간의 오프라인으로 "거래계약" 체결이 선행되어야 합니다.<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;계약 이후 당사의 담당자가 온라인등록을 진행하여 드립니다.</p>
                        </div>
                    </div>
                    <div class="list_wrap clearfix">
                        <dl class="list clearfix">
                            <dt class="q">question</dt>
                            <dd class="tit"><a href="javascript:resize();">사용자가 DSP MRO의 Buyer(고객)로 가입하기 위해서는 어떤 절차가 필요하나요?</a></dd>
                        </dl>
                        <div class="answer_box clearfix">
                            <span class="a">answer</span>
                            <p class="answer">1) 먼저 귀사가 DSP MRO에 고객으로 등록되어있어야 합니다.</p>
                            <p class="answer">2) 귀사가 DSP MRO에 고객으로 등록 되어 있다면 관리자에게 요청 또는 DSP MRO 담당자에게 연락하시면 등록해 드립니다.</p>
                        </div>
                    </div>
                </div>
            </section>
            <section class="join">
                <h3 class="title title_deco_blue_sq"><span class="title_point">타이틀</span>주문관련</h3>

                <div class="border_box border_box_list clearfix">
                    <div class="list_wrap clearfix">
                        <dl class="list clearfix">
                            <dt class="q">question</dt>
                            <dd class="tit"><a href="javascript:resize();">주문은 어떻게 하나요?</a></dd>
                        </dl>
                        <div class="answer_box clearfix">
                            <span class="a">answer</span>
                            <p class="answer">1) 홈페이지 로그인 후, [HOME]화면 또는 [주문관리 > 주문관리 > 품목검색]에서 품목코드나, 품명 또는 규격으로 구매하고자<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;하는 품목을 검색하신 후, 
                                                        원하는 품목을 선택하여 [카트담기]를 클릭합니다.</p>
                            <p class="answer">2) 주문하실 품목의 [카트담기]가 끝나면 [카트보기] 또는 [주문관리 > 주문관리 > 주문Cart]에서 구매할 품목의 예산적용 부서,<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;계정, 납품장소를 확인합니다.</p>
                            <p class="answer">3) 이 때, 카트에 담긴 구매품목에 대해 주문정보를 일괄적용 하고자 할 경우에는 주문정보 일괄적용 항목에서 [일괄반영]버튼을<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;클릭합니다.
                                                        물론 품목별 주문정보 항목에서 개별 품목별로도 예산부서, 계정, 인수자, 납품장소를 각각 지정할 수 있습니다. </p>
                        </div>
                    </div>
                    <div class="list_wrap clearfix">
                        <dl class="list clearfix">
                            <dt class="q">question</dt>
                            <dd class="tit"><a href="javascript:resize();">구매하고자 하는 품목이 없을 경우 어떻게 합니까?</a></dd>
                        </dl>
                        <div class="answer_box clearfix">
                            <span class="a">answer</span>
                            <p class="answer">1) [신규품목요청 > 신규품목요청 > 신규품목요청] 화면으로 이동합니다.</p>
                            <p class="answer">2) 구매하고자 하는 품목의 정보를 입력하신 후, [요청]버튼을 클릭하여 요청하시면 품목등록 및 가격결정 작업을 진행합니다.<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;가격결정이 완료되면 주문하실 수 있습니다.</p>
                            <p class="answer">3) 신규등록 신청시, 요청정보 입력 메뉴 하단에 있는 [자동발주]를 선택하면 신규등록 요청하신 품목이 주문 가능할 상태가 될 때,<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;자동으로 주문생성 됩니다. </p>
                        </div>
                    </div>
                    <div class="list_wrap clearfix">
                        <dl class="list clearfix">
                            <dt class="q">question</dt>
                            <dd class="tit"><a href="javascript:resize();">주문한 물품을 받은 후에는 어떻게 해야 하나요?</a></dd>
                        </dl>
                        <div class="answer_box clearfix">
                            <span class="a">answer</span>
                            <p class="answer">1) [주문진행현황] 또는 [미입고현황] 화면에서 주문내역을 조회합니다.</p>
                            <p class="answer">2) [미입고현황]에서 받으신 품목을 선택하여 [입고처리] 버튼을 클릭하여 처리합니다.</p>
                            <p class="answer">3) 입고처리가 지연되면 공급사의 대금지급이 지연되므로, 물품 수령 후<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                실시간으로 입고처리를 부탁합니다. </p>
                        </div>
                    </div>
                </div>
            </section>
            <section class="join">
                <h3 class="title title_deco_blue_sq"><span class="title_point">타이틀</span>교환/반품</h3>

                <div class="border_box border_box_list clearfix">
                    <div class="list_wrap clearfix">
                        <dl class="list clearfix">
                            <dt class="q">question</dt>
                            <dd class="tit"><a href="javascript:resize();">교환이나 반품요청은 어떻게 하나요?</a></dd>
                        </dl>
                        <div class="answer_box clearfix">
                            <span class="a">answer</span>
                            <p class="answer">DSP MRO의 고객사 담당자나 고객센터로 문의하시어 도움을 받으시면 됩니다.</p>
                        </div>
                    </div>
                </div>
            </section>
            <section class="join">
                <h3 class="title title_deco_blue_sq"><span class="title_point">타이틀</span>결제</h3>

                <div class="border_box border_box_list clearfix">
                    <div class="list_wrap clearfix">
                        <dl class="list clearfix">
                            <dt class="q">question</dt>
                            <dd class="tit"><a href="javascript:resize();">대금지불은 어떻게 하는건가요?</a></dd>
                        </dl>
                        <div class="answer_box clearfix">
                            <span class="a">answer</span>
                            <p class="answer">DSP MRO와 체결한 "거래계약"을 기준으로 고객사가 일괄로 매월 1회 정기적으로 지불을 합니다.</p>
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
        <!--// footer_wrap-->
    </div>
    <!--// wrap-->
</body>
</html>