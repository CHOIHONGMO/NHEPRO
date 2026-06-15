<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%-- 20.02.02 키보드보안 제거 중앙회 요청 농협정보 최종 결정 --%>
    <%-- 키보드보안 암호화 라이브러리 적용 시작 --%>
    <%--<%@ include file="/raonnx/nxKey/jsp/makeRndValue.jsp" %> --%>
    <%-- 키보드보안 암호화 라이브러리 적용 종료 --%>
    <%-- 라온시큐어 스크립트 로출 시작 --%>
    <%--<%@ include file="/raonnx/jsp/raonnx.jsp" %> --%>
    <%-- 라온시큐어 스크립트 로출 종료 --%>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="Referrer" content="origin">
    <meta http-equiv="X-UA-Compatible" content="IE=Edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="apple-mobile-web-app-title" content="FIRSTePro" />
    <meta name="robots" content="index,nofollow" />
    <meta name="description" content="FIRSTePro" />
    <meta name="keywords" content="FIRSTePro" />
    <meta name="format-detection" content="telephone=no" />
    <title>FIRSTePro 빠르고 투명한 전자구매/계약 서비스</title>
    <link rel="shortcut icon" href="/images/favicon.ico"/>
    <link rel="stylesheet" href="/css/nhepro/fonts/NanumGothic.css">
    <link rel="stylesheet" href="/css/nhepro/bootstrap.css">

    <script type="text/javascript" src="/js/everuxf/everuxf.min.js"></script>
    <script type="text/javascript" src="/js/everuxf/lic/licenseKey.js"></script>
    <script type="text/javascript" src="/js/ever-popup.js"></script>
    <script type="text/javascript" src="/js/ever-string.js"></script>

    <script type="text/javascript" src="/js/RSA/rsa.js"></script>
    <script type="text/javascript" src="/js/RSA/jsbn.js"></script>
    <script type="text/javascript" src="/js/RSA/prng4.js"></script>
    <script type="text/javascript" src="/js/RSA/rng.js"></script>

    <script>
        // 20.02.02 키보드보안 제거 중앙회 요청 농협정보 최종 결정
        // TouchEnNxConfig.installPage.tos = TouchEnNxConfig.installPage.nxkey;
    </script>
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

        $(document).ready(function() {
	        if("${param.loginType}" == "S") {
	        	$("#userId").val("${param.userId}");
		        $("#password").val("${param.password}");
	        	doLogin();
	        }
        });

        function doLogin(param) {
        	
        	// 20.02.02 키보드보안 제거, 키보드보안 적용 전 rsa방식 사용 중앙회 요청 농협정보 최종 결정 
            var rsa = new RSAKey();
            rsa.setPublic($('#RSAModulus').val(), $('#RSAExponent').val());
            //TK_makeEncData(document.formData);

            var store = new EVF.Store();
            if (document.formData.userId.value != "") {
                store.setParameter("userId", rsa.encrypt($('#userId').val()));
                //store.setParameter("userId", document.formData.E2E_userId.value);
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
                //store.setParameter("password", document.formData.E2E_password.value);
            }

            store.setParameter("userType", "A");
            store.setParameter("siteType", "O");
            if (param != undefined) {
                store.setParameter('invalidate', param.invalidate);
            }
            
         	// 20.02.02 키보드보안 제거  중앙회 요청 농협정보 최종 결정 
            //store.setParameter("hid_key_data", document.formData.hid_key_data.value);
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
                            everPopup.openWindowPopup(url, 900, 750, params, '개인정보 이용약관');
                        }
                        else {
                            var resCode = this.getResponseCode();
                            if (resCode == '201') {
                                if (confirm('다른 IP로 이미 로그인된 사용자가 있습니다.\n로그아웃시키고 다시 로그인하시겠습니까?')) {
                                    doLogin({
                                        invalidate: true
                                    });
                                }
                            } else if (resCode == '200') {
                                location.href = "/home.so";
                            } else if (resCode == '180') {
                            	alert(this.getResponseMessage());
                            	location.href = "/home.so";
                            }
                        }
                    }, false);
                }
            }, false);
        }

        function chekLoginY(data) {
            if (data == "Y") {
            	
            	// 20.02.02 키보드보안 제거, 키보드보안 적용 전 rsa방식 사용 중앙회 요청 농협정보 최종 결정 
                var rsa = new RSAKey();
                rsa.setPublic($('#RSAModulus').val(), $('#RSAExponent').val());
                //TK_makeEncData(document.formData);

                var store = new EVF.Store();
                store.setParameter("userId", rsa.encrypt($('#userId').val()));
                //store.setParameter("userId", document.formData.E2E_userId.value);
                store.setParameter("checkUserId", $('#userId').val());
                store.setParameter("password", rsa.encrypt($('#password').val()));
                //store.setParameter("password", document.formData.E2E_password.value);
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
                $('#loginSave').prop('checked', true);
            }

            // 로그인 공지사항 팝업
            <c:forEach var="noticePopup" items="${noticeListPopup}">
            noticeCookieCheck('${noticePopup.NOTICE_NUM }', 'loginPopupNotice');
            </c:forEach>

        });

        // 로그인 공지사항 팝업
        function noticeCookieCheck(noticeNum, loginPopupNotice) {
            var blnCookie = $.cookie('div_laypopup' + noticeNum); // 공지사항 팝업ID
            if (!blnCookie) {
                openNotice(noticeNum, loginPopupNotice);
            }
        }

        // 로그인 공지사항 팝업
        function openNotice(noticeNum, loginPopupNotice) {
            var url = "/session/viewContents/view.so";
            var param = {
                realUrl: '/eversrm/board/notice/screenNotice/view.so',
                NOTICE_NUM: noticeNum,
                popupFlag: true,
                detailView: true,
                loginPopupNotice: loginPopupNotice
            };
            everPopup.openWindowPopup(url, 800, 600, param, 'NOTICE' + noticeNum);
        }

        // 공지사항 팝업 닫기
        function closeWinAt00(winName, expiredays) {
            $.cookie.setCookie(winName, "done", expiredays);
        }

        function toggleSaveUserId() {
            $.cookie('nhSrmUserId', ($('#loginSave').prop('checked') == true ? $('#userId').val() : null), { expires: 365 });
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
<div class="wrap">
    <!--wrap-->
    <header>
        <h1 class="sr-only">FIRSTePro</h1>
        <div class="box">
            <div class="nav_top">
            </div>
            <nav class="navbar navbar-expand">
                <a class="navbar-brand" href="#"><img src="/images/nhepro/common/logo_firstepro.png" alt="FIRSTePro"></a>
                <div class="collapse navbar-collapse">
                </div>
            </nav>
        </div>
    </header>
    <section class="main admin">
        <h2 class="sr-only">빠르고 투명한 전자구매/계약 서비스</h2>
        <div class="box">
            <div class="box_main">
                <div class="contents">
                    <p class="title">빠르고 투명한 <span class="font-weight-bold">전자구매/계약 서비스</span></p>
                    <p class="desc"><span class="font-weight-bold">FIRSTeProcument</span> SOLUTION SERVICE</p>
                </div>
                <div class="contents-login">
                    <div class="box_login">
                        <span class="bar"></span>
                        <div class="inner">
                            <div class="title">
                                <p class="highlight">FIRSTePro</p>
                                에 오신 걸 환영합니다.
                            </div>
                            <form id="formData" name="formData" onsubmit="return false;">
                                <div class="login_area clearfix">
                                    <div class="float-left">
                                        <div class="form-group">
                                            <label for="userId" class="sr-only">ID</label>
                                            <input type="text" class="form-control" id="userId" name="userId" placeholder="회원ID를 입력해 주세요" tabindex="1" data-enc="on">
                                            <!-- 20.02.02 키보드보안 제거, 키보드보안 적용 전 rsa방식 사용 중앙회 요청 농협정보 최종 결정  -->
                                            <input type="hidden" id="RSAModulus" value="${RSAModulus}"/>
                                            <input type="hidden" id="RSAExponent" value="${RSAExponent}"/>
                                            
                                        </div>
                                        <div class="form-group">
                                            <label for="password" class="sr-only">Password</label>
                                            <input type="password" class="form-control" id="password" name="password" placeholder="비밀번호를 입력해 주세요" tabindex="2" onkeypress="capslockevt(event);" onkeyup="checkShiftUp(event);" onkeydown="checkShiftDown(event);" autocomplete="off" data-enc="on">
                                            <div class="ly_v2" id="err_capslock" style="display: none;">
                                                <div class="ly_box">
                                                    <p role="alert"><strong>Caps Lock</strong>이 켜져 있습니다.</p></div>
                                                <span class="sp ly_point"></span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="float-right">
                                        <button type="submit" class="btn btn-login" tabindex="3" onclick="doLogin();">로그인</button>
                                    </div>
                                </div>
                                <div class="custom-control custom-checkbox float-left">
                                    <%--<input type="checkbox" class="custom-control-input" id="loginSave" onclick="toggleSaveUserId()">
                                    <label class="custom-control-label" for="loginSave">아이디 저장</label>--%>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
    <div class="footer_wrap">
        <c:import url="/mainHtml/footer/footer.jsp" charEncoding="UTF-8"/>
    </div>
</div>
</body>
</html>