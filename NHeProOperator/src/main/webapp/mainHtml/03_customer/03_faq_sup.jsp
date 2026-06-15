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
            <li><a href="/mainHtml/03_customer/03_faq_cus.jsp">고객사</a></li>
            <li class="active"><a href="/mainHtml/03_customer/03_faq_sup.jsp">공급사</a></li>
        </ul>

        <div class="tabs_contents faq_cus">
            <section class="join">
                <h3 class="title title_deco_blue_sq"><span class="title_point">타이틀</span>회원가입</h3>

                <div class="border_box border_box_list clearfix">
                    <div class="list_wrap clearfix">
                        <dl class="list clearfix">
                            <dt class="q">question</dt>
                            <dd class="tit"><a href="javascript:resize();">공급사 회원가입은 어떻게 해야 하나요?</a></dd>
                        </dl>
                        <div class="answer_box clearfix">
                            <span class="a">answer</span>
                            <p class="answer">[ 가입신청 ]<br>DSP MRO와 귀사간의 오프라인으로 "거래계약" 체결이 선행되어야 합니다.<br><br>1) DSP MRO 홈페이지 메인의 [공급사 가입안내] 클릭 후, 공급사 가입신청 페이지 아래 [약관동의 및 가입신청]<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;버튼을 클릭합니다.</p>
                            <p class="answer">2) 개인정보 취급방침, 이용약관 동의 체크 하고, [확인] 버튼을 클릭하여
                                                        가입신청 화면에서 필수사항 입력 후 [저장하기]<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;버튼을 클릭 하면 가입신청이 접수되며, 담당자가 확인 후 승인하면 ID부여하여 신청인의 E-mail 주소로 안내메일을
                                                        <br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;보내드립니다. </p>
                        </div>
                    </div>
                    <div class="list_wrap clearfix">
                        <dl class="list clearfix">
                            <dt class="q">question</dt>
                            <dd class="tit"><a href="javascript:resize();">기본정보의 자사정보는 어떻게 수정해야 하나요?</a></dd>
                        </dl>
                        <div class="answer_box clearfix">
                            <span class="a">answer</span>
                            <p class="answer">[My Page > 회사정보] 에서 변경된 사항을 기재 하시고 우측 상단에 [수정] 버튼을 클릭하시면 됩니다.
                                              V 표시된 사항은 필수사항<br>이므로 반드시 입력 하셔야 되며,정보 변경시 아래에 해당되는 경우는 제출 서류가 필요하니 참고 하시기 바랍니다.</p>
                            <p class="answer">*** 정보 변경시 제출 서류 안내 ***<br>
                            ⊙ 상호변경, 대표이름, 주소 변경시 : 사업자등록증 사본, 인감증명서<br>
                            ⊙ 입금계좌 변경시 : 대금수령신청서, 변경 통장 사본<br>
                            ⊙ 사업자등록번호 변경시 (개인에서 법인으로 전환의 경우)<br>
     &nbsp;&nbsp;&nbsp;&nbsp;- 신규로 업체등록요청 하신 후, 아이디를 새로 부여받아야 합니다.                            
                            </p>
                        </div>
                    </div>
                </div>
            </section>
            <section class="join">
                <h3 class="title title_deco_blue_sq"><span class="title_point">타이틀</span>견적/계약</h3>

                <div class="border_box border_box_list clearfix">
                    <div class="list_wrap clearfix">
                        <dl class="list clearfix">
                            <dt class="q">question</dt>
                            <dd class="tit"><a href="javascript:resize();">견적의뢰는 어디에서 확인하고 입력해야 하나요?</a></dd>
                        </dl>
                        <div class="answer_box clearfix">
                            <span class="a">answer</span>
                            <p class="answer">1) [견적/계약관리 > 견적관리]에서 마감일자 또는 의뢰일자를 기준일로 조회하여 견적의뢰를 확인합니다.</p>
                            <p class="answer">2) 견적의뢰 목록 중 견적 입력할 품목을 선택하고 최소주문수량, 주문배수, 납품지역, 견적단가를 입력하신 후<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[견적서제출]을 클릭하면 됩니다. </p>
                        </div>
                    </div>
                    <div class="list_wrap clearfix">
                        <dl class="list clearfix">
                            <dt class="q">question</dt>
                            <dd class="tit"><a href="javascript:resize();">견적입력 후 계약 확인은 어떻게 해야 하나요?</a></dd>
                        </dl>
                        <div class="answer_box clearfix">
                            <span class="a">answer</span>
                            <p class="answer">[견적/계약관리 > 계약현황]에서 계약일자, 품명/규격 등을 입력한 후, 조회버튼을 눌러 조회합니다.</p>
                        </div>
                    </div>
                </div>
            </section>
            <section class="join">
                <h3 class="title title_deco_blue_sq"><span class="title_point">타이틀</span>납품</h3>

                <div class="border_box border_box_list clearfix">
                    <div class="list_wrap clearfix">
                        <dl class="list clearfix">
                            <dt class="q">question</dt>
                            <dd class="tit"><a href="javascript:resize();">어떻게 발주를 확인하고 납품하면 될까요?</a></dd>
                        </dl>
                        <div class="answer_box clearfix">
                            <span class="a">answer</span>
                            <p class="answer">1) 먼저 로그인 하신 후, [납품관리 > 납품서 생성]를 클릭합니다.</p>
                            <p class="answer">2) 해당 화면에서 조회버튼을 누르시면 조회기간내의 발주내역을 보실 수 있습니다.<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                        발주 건에 대하여 납품가능한 일자로 약속일을 입력하신 후, 납품생성 버튼을 눌러서 [납품생성]을 하십시오.<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                        분할납품이 필요한 경우 [분할납품]버튼을 클릭 하시어 납품계획을 입력하십시요.</p>
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
                            <p class="answer">DSP MRO의 공급사 담당자나 고객센터로 문의하시어 도움을 받으시면 됩니다.</p>
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
                            <dd class="tit"><a href="javascript:resize();">대금청구는 어떻게 하나요?</a></dd>
                        </dl>
                        <div class="answer_box clearfix">
                            <span class="a">answer</span>
                            <p class="answer">매달 말일 기준으로 1회 계산서를 발행하며, 정산관리 메뉴에서 마감현황을 조회하여 계산서
                                                     발행금액을 확인하고<br>처리하면 됩니다. 발행문의는 귀사의 DSP MRO 담당자 및 고객센터로 문의하세요.</p>
                        </div>
                    </div>
                    <div class="list_wrap clearfix">
                        <dl class="list clearfix">
                            <dt class="q">question</dt>
                            <dd class="tit"><a href="javascript:resize();">대금결제를 위해 제출해야 하는 서류는 무엇인지요?</a></dd>
                        </dl>
                        <div class="answer_box clearfix">
                            <span class="a">answer</span>
                            <p class="answer">DSP MRO의 공급사 담당자나 고객센터로 문의하시어 도움을 받으시면 됩니다.</p>
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