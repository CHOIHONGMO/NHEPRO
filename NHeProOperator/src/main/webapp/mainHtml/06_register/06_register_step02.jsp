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
        <div class="contents contents_user contents_registery">
            <div class="registery_step02">
                <form id="form" name="form">
                    <section class="step">
                        <h3 class="title title_h_28">회원가입</h3>
                        <div class="step_bar clearfix">
                            <div><em>STEP 1</em><br>약관동의</div>
                            <span class="sprite sprite_common sprite_next text_out">다음</span>
                            <div class="active"><em>STEP 2</em><br>정보입력</div>
                            <span class="sprite sprite_common sprite_next text_out">다음</span>
                            <div><em>STEP 3</em><br>가입완료</div>
                        </div>
                    </section>
                    <section>
                        <h3 class="title title_deco_blue_sq"><span class="title_point">타이틀</span>회원정보</h3>
                        <p class="title_arrow"><span class="sprite sprite_common sprite_arrow_blue"></span>개인정보</p>
                        <div class="info_box clearfix">
                            <dl>
                                <dt>회사코드</dt>
                                <dd>
                                    <input type="text" id="VENDOR_CD" name="VENDOR_CD" disabled="disabled">
                                </dd>
                            </dl>
                            <dl>
                                <dt>회사명</dt>
                                <dd>
                                    <input type="text" id="VENDOR_NM" name="VENDOR_NM">
                                </dd>
                            </dl>
                            <dl>
                                <dt>사업부<em class="check sprite sprite_common">필수입력사항</em></dt>
                                <dd>
                                    <select name="" id="">
                                        <option value=""></option>
                                        <option value=""></option>
                                        <option value=""></option>
                                    </select>
                                </dd>
                            </dl>
                            <dl>
                                <dt>부서<em class="check sprite sprite_common">필수입력사항</em></dt>
                                <dd>
                                    <select name="" id="">
                                        <option value=""></option>
                                        <option value=""></option>
                                        <option value=""></option>
                                    </select>
                                </dd>
                            </dl>
                            <dl class="table_have_btn">
                                <dt>사용자 ID<em class="check sprite sprite_common">필수입력사항</em></dt>
                                <dd class="clearfix">
                                    <div><input type="text"></div>
                                    <div class="have_btn"><a href="#" class="btn btn_no_radius"><em class="icon icon_search sprite sprite_common"></em>중복체크</a></div>
                                </dd>
                            </dl>
                            <dl>
                                <dt>사용자명<em class="check sprite sprite_common">필수입력사항</em></dt>
                                <dd><input type="text"></dd>
                            </dl>
                            <dl>
                                <dt>비밀번호<em class="check sprite sprite_common">필수입력사항</em></dt>
                                <dd><input type="text"></dd>
                            </dl>
                            <dl>
                                <dt>비밀번호 재확인<em class="check sprite sprite_common">필수입력사항</em></dt>
                                <dd><input type="text"></dd>
                            </dl>
                            <dl>
                                <dt>회사전화<em class="check sprite sprite_common">필수입력사항</em></dt>
                                <dd><input type="text"></dd>
                            </dl>
                            <dl>
                                <dt>휴대전화<em class="check sprite sprite_common">필수입력사항</em></dt>
                                <dd><input type="text"></dd>
                            </dl>
                            <dl>
                                <dt>팩스번호</dt>
                                <dd>
                                    <input type="text">
                                </dd>
                            </dl>
                            <dl>
                                <dt>E-mail<em class="check sprite sprite_common">필수입력사항</em></dt>
                                <dd><input type="text"></dd>
                            </dl>
                            <dl>
                                <dt>직급</dt>
                                <dd>
                                    <input type="text">
                                </dd>
                            </dl>
                            <dl>
                                <dt>사번</dt>
                                <dd>
                                    <input type="text">
                                </dd>
                            </dl>
                            <dl class="table_w1020 table_three_box">
                                <dt>주소<em class="check sprite sprite_common">필수입력사항</em></dt>
                                <dd>
                                    <div class="input_search_box">
                                        <input type="text" class="">
                                        <input type="search" class="input_search">
                                    </div>
                                    <div class="input_half_box">
                                        <input type="text" class="input_half" disabled>
                                        <input type="text" class="input_half" disabled>
                                    </div>
                                </dd>
                            </dl>
                            <dl class="table_w1020">
                                <dt>예산부서<em class="check sprite sprite_common">필수입력사항</em></dt>
                                <dd class="table_w305">
                                    <select name="" id="">
                                        <option value=""></option>
                                        <option value=""></option>
                                        <option value=""></option>
                                    </select>
                                </dd>
                            </dl>
                            <dl>
                                <dt>SMS 수신여부<em class="check sprite sprite_common">필수입력사항</em></dt>
                                <dd>
                                    <select name="" id="">
                                        <option value="">미수신</option>
                                        <option value="">수신</option>
                                    </select>
                                </dd>
                            </dl>
                            <dl>
                                <dt>Mail 수신여부<em class="check sprite sprite_common">필수입력사항</em></dt>
                                <dd>
                                    <select name="" id="">
                                        <option value="">미수신</option>
                                        <option value="">수신</option>
                                    </select>
                                </dd>
                            </dl>
                        </div>

                        <p class="title_arrow"><span class="sprite sprite_common sprite_arrow_blue"></span>개인정보</p>
                        <div class="info_box margin_bottom clearfix">
                            <dl>
                                <dt>인수자명</dt>
                                <dd>
                                    <input type="text">
                                </dd>
                            </dl>
                            <dl>
                                <dt>회사명</dt>
                                <dd>
                                    <input type="text">
                                </dd>
                            </dl>
                            <dl>
                                <dt>회사전화</dt>
                                <dd>
                                    <input type="text">
                                </dd>
                            </dl>
                            <dl>
                                <dt>부서</dt>
                                <dd>
                                    <input type="text">
                                </dd>
                            </dl>
                            <dl class="table_w1020">
                                <dt>E-mail</dt>
                                <dd>
                                    <input type="text">
                                </dd>
                            </dl>
                            <dl class="table_w1020 table_three_box">
                                <dt>납품장소</dt>
                                <dd>
                                    <div class="input_search_box">
                                        <input type="text" class="">
                                        <input type="search" class="input_search">
                                    </div>
                                    <div class="input_half_box">
                                        <input type="text" class="input_half" disabled>
                                        <input type="text" class="input_half" disabled>
                                    </div>
                                </dd>
                            </dl>
                        </div>
                    </section>

                    <div class="input_checkbox input_checkbox_agree clearfix">
                        <input type="checkbox" id="enroll_agree_check">
                        <label for="enroll_agree_check" class="label_checkbox">개인정보와 동일</label>
                    </div>

                    <div class="btn_wrap">
                        <a href="#" class="btn btn_no_icon btn_middle">회원가입</a>
                        <a href="/welcome.so" class="btn btn_no_icon btn_cancel btn_middle">취소</a>
                    </div>
                </form>
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