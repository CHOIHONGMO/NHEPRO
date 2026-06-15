<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>FIRSTePro-전자구매/계약 서비스</title>
   <link rel="shortcut icon" href="/images/favicon.ico"/>
    <link rel="stylesheet" href="/css/ymro/ui/style.css" type="text/css">

    <script type="text/javascript" src="/js/everuxf/everuxf.min.js"></script>
    <script type="text/javascript" src="/js/everuxf/lic/licenseKey.js"></script>
    <script type="text/javascript" src="/js/ever-popup.js"></script>
    <script type="text/javascript" src="/js/ever-string.js"></script>
    <script type="text/javascript" src="/css/ymro/js/lib/jquery.bxslider.js"></script>
    <script type="text/javascript" src="/css/ymro/js/ui/common.js"></script>

    <script type="text/javascript" src="/js/RSA/rsa.js"></script>
    <script type="text/javascript" src="/js/RSA/jsbn.js"></script>
    <script type="text/javascript" src="/js/RSA/prng4.js"></script>
    <script type="text/javascript" src="/js/RSA/rng.js"></script>

    <style>
        .ly_v2 {
            position: absolute;
            z-index: 10;
            display: block;
            zoom: 1;
        }

        .ly_v2 .ly_box {
            font-size: 11px;
            line-height: 14px;
            position: static;
            margin-top: 8px;
            padding: 9px 9px 7px;
            letter-spacing: -1px;
            color: #777;
            border: solid 1px #d8d1aa;
            background: #fffadc;
        }

        .sp{
            background: url(https://static.nid.naver.com/images/ui/login/pc_sp_login_170424.png) no-repeat;
        }

        .ly_v2 .ly_point {
            position: absolute;
            top: 0;
            left: 8px;
            display: block;
            width: 12px;
            height: 10px;
            background-position: -41px -48px;
        }
    </style>
    <script type="text/javascript">

        function doLogin(param) {
            var rsa = new RSAKey();
            rsa.setPublic($('#RSAModulus').val(), $('#RSAExponent').val());

            var store = new EVF.Store();
            if (document.formData.userId.value != "") {
                store.setParameter("userId", rsa.encrypt($('#userId').val()));
                store.setParameter("checkUserId", $('#userId').val());
            } else {
                alert("아이디를 입력하세요.");
                document.formData.userId.focus();
                return;
            }

            if (document.formData.password.value == "") {
                alert("패스워드를 입력하세요.");
                document.formData.password.focus();
                return;
            } else {
                store.setParameter("password", rsa.encrypt($('#password').val()));
            }

            store.setParameter("userType", "A");
            if (param != undefined) {
                store.setParameter('invalidate', param.invalidate);
            }

            store.load('/login.so', function () {

                if (this.getResponseMessage() != null && this.getResponseMessage() != '') {
                    alert(this.getResponseMessage());
                } else {
                    store.load('/checkAgree.so', function () {
                        if (this.getResponseMessage() == null || this.getResponseMessage() == '0') {
                            var url = '/userAgreeCheck.so';
                            var params = {
                                title: '개인정보 이용약관',
                                USER_ID: $('#userId').val()
                            };

                            //everPopup.openModalPopup(url, 710, 500, params);
                            everPopup.openWindowPopup(url, 710, 500, params, '개인정보 이용약관');

                        } else {
                            var resCode = this.getResponseCode();
                            if (resCode == '201') {
                                if (confirm('다른 IP로 이미 로그인된 사용자가 있습니다.\n로그아웃시키고 다시 로그인하시겠습니까?')) {
                                    doLogin({
                                        invalidate: true
                                    });
                                }
                            } else if (resCode == '200') {
                                location.href = "/home.so";
                            }
                        }
                    }, false);
                }
            }, false);


        }

        function chekLoginY(data) {
            if (data == "Y") {
                var rsa = new RSAKey();
                rsa.setPublic($('#RSAModulus').val(), $('#RSAExponent').val());

                var store = new EVF.Store();
                store.setParameter("userId", rsa.encrypt($('#userId').val()));
                store.setParameter("checkUserId", $('#userId').val());
                store.setParameter("password", rsa.encrypt($('#password').val()));
                store.setParameter("userType", "A");

                store.load('/login.so', function () {
                    if (this.getResponseMessage() != null && this.getResponseMessage() != '') {
                        alert(this.getResponseMessage());
                    } else {
                        var resCode = this.getResponseCode();
                        if (resCode == '201') {
                            if (confirm('다른 IP로 이미 로그인된 사용자가 있습니다.\n로그아웃시키고 다시 로그인하시겠습니까?')) {
                                doLogin({
                                    invalidate: true
                                });
                            }
                        } else if (resCode == '200') {
                            location.href = "/home.so";
                        }
                    }
                }, false);
            } else {
//                var store = new EVF.Store();
//                store.load('/sessionCut.so', function() {
//                    location.href = "/welcome.so";
//                });
            }
        }

        $(window).ready(function () {
            $('#userId').keydown(function (e) {
                e.stopPropagation();
                if (e.keyCode === 13) {
                    doLogin();
                }
            });

            $('#password').keydown(function (e) {
                e.stopPropagation();
                if (e.keyCode === 13) {
                    doLogin();
                }
            });

            $('#lbtn').click(function (e) {
                e.stopPropagation();
                doLogin();
            });

            $('#formData').keypress(function (e) {
                if (e.keyCode == 13) return false;
            });

//            if ($('#userId').val() != '') {
//                document.formData.password.focus();
//            } else {
//                document.formData.userId.focus();
//            }

            if ($.cookie('nhSrmUserId') != null) {
                $('#userId').val($.cookie('nhSrmUserId'));
                $('#id_save_check').prop('checked', true);
            }

            // 로그인 공지사항 팝업
            <c:forEach var="noticePopup" items="${noticeListPopup}">
            noticeCookieCheck('${noticePopup.NOTICE_NUM }', 'loginPopupNotice');
            </c:forEach>

        });

        // 로그인 공지사항 팝업
        function noticeCookieCheck(noticeNum, loginPopupNotice) {
            var blnCookie = cookie.getCookie('div_laypopup' + noticeNum); // 공지사항 팝업ID
            if (!blnCookie) {
                openNotice(noticeNum, loginPopupNotice);
            }
        }

        // 로그인 공지사항 팝업
        function openNotice(noticeNum, loginPopupNotice) {
            var url = "/session/viewContents/view.so";
            var param = {
                realUrl: '/evermp/MY01/screenNotice/view.so',
                NOTICE_NUM: noticeNum,
                popupFlag: true,
                detailView: true,
                loginPopupNotice: loginPopupNotice
            };
            everPopup.openWindowPopup(url, 800, 600, param, 'NOTICE' + noticeNum);
        }

        // 공지사항 팝업 닫기
        function closeWinAt00(winName, expiredays) {
            cookie.setCookie(winName, "done", expiredays);
        }

        function toggleSaveUserId() {
            $.cookie('nhSrmUserId', ($('#id_save_check').prop('checked') == true ? $('#userId').val() : null), { expires: 365 });
            console.log($.cookie('nhSrmUserId'));
        }

        function resetPassword() {

            var store = new EVF.Store();

            if ($('#userId').val() == '') {
                return alert('아이디를 입력하셔야 합니다.');
            }

            store.setParameter("userId", $('#userId').val());

            if (confirm('비밀번호를 초기화하시겠습니까?')) {
                store.load('/resetPassword.so', function () {
                    alert(this.getResponseMessage());
                }, false);
            }
        }

        function changeLayer(fg) {
            var cur = document.getElementById("layer1");
            var old = document.getElementById("layer2");

            if (fg == '1') {
                cur.style.display = 'none';
                old.style.display = 'block';
            }
            else {
                cur.style.display = 'block';
                old.style.display = 'none';
            }

        }

        function capslockevt(e) {
            userStrokes = true;
            var myKeyCode = 0;
            var myShiftKey = false;
            if (window.event) { // IE
                myKeyCode = e.keyCode;
                myShiftKey = e.shiftKey;
            } else if (e.which) { // netscape ff opera
                myKeyCode = e.which; // myShiftKey=( myKeyCode == 16 ) ? true :
                // false;
                myShiftKey = isshift;
            }
            if ((myKeyCode >= 65 && myKeyCode <= 90) && !myShiftKey) {
                is_capslockon=true;
                show('err_capslock');
                setTimeout("hide('err_capslock')",3000);
            } else if ((myKeyCode >= 97 && myKeyCode <= 122) && myShiftKey) {
                is_capslockon=true;
                show('err_capslock');
                setTimeout("hide('err_capslock')",3000);
            } else {
                is_capslockon=false;
                setTimeout("hide('err_capslock')",1500);
            }
        }

        var isshift = false;
        var userStrokes = false;
        function checkShiftUp(e) {
            if (e.which && e.which == 16) {
                isshift = false;
            }
        }
        function checkShiftDown(e) {
            var down_keyCode=0;
            if (e.which && e.which == 16) {
                isshift = true;
            }
            if (window.event) {
                down_keyCode = e.keyCode;
            }
            else if (e.which) {
                down_keyCode = e.which;
            }

            if (down_keyCode && down_keyCode == 20) {
                if (!is_capslockon)
                {
                    is_capslockon=true;
                    show('err_capslock');
                    setTimeout("hide('err_capslock')",1500);
                }
                else
                {
                    is_capslockon=false;
                    hide('err_capslock');
                }
            }
        }
        var is_capslockon = false;

        function show(id) {
            $('#'+id).css('display', 'block');
        }
        function hide(id) {
            $('#'+id).css('display', 'none');
        }
    </script>

</head>
<body>
<!--wrap-->
<form id="formData" name="formData" onsubmit="return false;">
    <div class="wrap main_page">
        <!--header_wrap-->
        <div class="header_wrap">
            <c:import url="/mainHtml/header/header.jsp" charEncoding="UTF-8"/>
        </div>
        <div class="contents contents_main clearfix">
            <div class="home_banner">
                <div class="txt">
                    <div class="title">고객과 함께 성장하는 <b>MRO 구매 전문회사</b></div>
                    <div class="sub"><b>농협</b>은 투명한 구매 시스템을 통해<br>
                        고객의 기업가치를 창출하는 구매혁신 파트너가 되겠습니다.</div>
                </div>
            </div>
            <!--로그인, 덕성테크팩소식, 물류소식, 고객센터-->
            <section class="con_top clearfix">
                <!--로그인-->
                <div class="login_area">
                    <div class="title">사용자 로그인</div>
                    <ul>
                    	<li class="input_box">
                            <input id="userId" name="userId" type="text" placeholder="아이디" class="input_id" tabindex="1">
                            <input type="hidden" id="RSAModulus" value="${RSAModulus}"/>
                            <input type="hidden" id="RSAExponent" value="${RSAExponent}"/>
                            <label for="" class="blind">아이디 입력</label>
                            <a href="#" class="button_clear">클리어버튼</a>
                        </li>
                        <li class="input_box">
                            <input type="password" id="password" name="password" placeholder="비밀번호를 입력하세요." class="input_pw" tabindex="2" onkeypress="capslockevt(event);" onkeyup="checkShiftUp(event);" onkeydown="checkShiftDown(event);" />
                            <label for="" class="blind">비밀번호 입력</label>
                            <div class="ly_v2" id="err_capslock" style="display: none;">
                                <div class="ly_box">
                                    <p role="alert"><strong>Caps Lock</strong>이 켜져 있습니다.</p></div>
                                <span class="sp ly_point"></span>
                            </div>
                        </li>
                        <li class="login_submit">
                            <a href="#" id="goLogin" onclick="doLogin();" title="로그인" tabindex="3">로그인</a>
                        </li>
                        
                    </ul>

                    <div class="save_box">
                        <!--id값은 임시-->
                        <!--<span>아이디저장 체크박스</span>-->
                        <input type="checkbox" id="id_save_check" class="id_save_check">
                        <label for="id_save_check">아이디저장</label>
                    </div>
                </div>
                <!--// 로그인-->

                <!--덕성테크팩소식-->
                <div class="notice_area">
                    <h2 class="title">농협 소식<a href="/mainHtml/03_customer/03_notice_list.jsp" class="btn_more">더보기</a></h2>
                    <ul class="notice_list">
                        <c:forEach items="${noticeListMain }" var="C">
                            <li><a href="javascript:noticeCookieCheck('${C.NOTICE_NUM }', 'loginPopupNotice');" class="txt text_ellipsis">${C.SUBJECT} </a><span>${C.REG_DATE}</span></li>
                        </c:forEach>
                    </ul>
                </div>
                <!--// 덕성테크팩소식-->
                
                <!--물류소식-->
                <div class="notice_area notice_area_icon clearfix">
                   <div class="question">
                       <a href="/mainHtml/03_customer/03_join_guide.jsp?type=C">
                        <div class="title">고객사 거래 문의</div>
                        <div><img src="/images/ymro/common/question_person.png" alt="고객사 거래 문의"></div>
                       </a>
                   </div>
                   <div class="question">
                       <a href="/mainHtml/03_customer/03_join_guide.jsp?type=V">
                           <div class="title">공급사 거래 문의</div>
                           <div><img src="/images/ymro/common/question_truck.png" alt="공급사 거래 문의"></div>
                       </a>
                   </div>
                </div>
                <!--// 물류소식-->

                <!--고객센터-->
                <div class="service_area">
                    <h2 class="title">고객센터</h2>
                    <div>
                        <p class="service_number"><a href="tel:031-738-8157">031-738-8157</a></p>
                        <p class="txt">평일<em class="time">09:00</em> ~ <em class="time">18:00</em></p>
                        <span>고객센터 이미지</span>
                    </div>
                </div>
                <!--// 고객센터-->
            </section>
            <!--//로그인, 덕성테크팩소식, 물류소식, 고객센터-->
        </div>
        <!--// content-->
	        <!--footer_wrap-->
        <div class="footer_wrap">
            <c:import url="/mainHtml/footer/footer.jsp" charEncoding="UTF-8"/>
        </div>
    </div>
    <!--// wrap-->
</form>
</body>
</html>