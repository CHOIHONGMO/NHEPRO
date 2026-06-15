<!--
2022.10.11 
전자근로계약시스템 파트너스용 모바일 화면  
 -->
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.st_ones.everf.serverside.config.PropertiesManager" %>
<%@ page import="com.st_ones.common.util.clazz.EverDate" %>
<%@ include file="/WEB-INF/views/common/ozUrlInfo.jsp" %>
<%
    String ozSchedulerIp = PropertiesManager.getString("oz.scheduler.ip");
    String ozSchedulerPort = PropertiesManager.getString("oz.scheduler.port");
    String tempDirectory = PropertiesManager.getString("oz.source.file.path");
    String filePath = PropertiesManager.getString("everf.fileUpload.path") + EverDate.getYear() + "/" + EverDate.getYear() + EverDate.getMonth() + "/EC/PDF/";
	
%>
<c:set var="ozUrl" value="<%=ozUrl%>" />
<c:set var="ozServer" value="<%=ozServer%>" />
<c:set var="ozSchedulerIp" value="<%=ozSchedulerIp%>" />
<c:set var="ozSchedulerPort" value="<%=ozSchedulerPort%>" />
<c:set var="tempDirectory" value="<%=tempDirectory%>" />
<c:set var="filePath" value="<%=filePath%>" />
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no">
    <meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
    <meta name="robots" content="index,nofollow">
    <meta name="description" content="FIRSTePro 빠르고 투명한 전자구매/계약 서비스">
    <link rel="shortcut icon" href="/images/favicon.ico"/>
    <title>FIRSTePro 빠르고 투명한 전자구매/계약 서비스</title>
    <link rel="stylesheet" href="/css/nhepro/nhepro-m.css">
    <script src="/js/everuxf/everuxf.min.js"></script>
    <script type="text/javascript" src="/js/ever-popup.js"></script>
    <script type="text/javascript" src="/js/ever-string.js"></script>
    <script type="text/javascript" src="/js/everuxf/lic/licenseKey.js"></script>
</head>

<script>
    $(window).ready(function () {
        if ($.cookie('c-id') != null) {
            $('#c-id').val($.cookie('c-id'));
            $('#c-id-save').prop('checked', true);
        }
    });

    function doLogin() {
        toggleSaveUserId(); // id저장

        if ($('#c-id').val() == "") {
            alert("아이디를 입력하세요.");
            $('#c-id').focus();
            return;
        }

        if ($('#c-pw').val() == "") {
            alert("비밀번호를 입력하세요.");
            $('#c-pw').focus();
            return;
        }

        var store = new EVF.Store();
        store.setParameter("userId", $('#c-id').val());
        store.setParameter("password", $('#c-pw').val());
        store.load('/mobileLoginPT.so', function () {
            if (this.getResponseMessage() != null && this.getResponseMessage() != '') {
                if(this.getResponseCode() == 'WRONG_PASSWORD_RESET_DATE' || this.getResponseCode() == 'FAIL_LOGIN_DATE_PASS' || this.getResponseCode() == 'WRONG_PASSWORD_EXCEEDED_CNT' || this.getResponseCode() == 'WRONG_PASSWORD_RESET_FLAG') {
                    if (confirm(this.getResponseMessage())) {
                        if(this.getResponseCode() == 'FAIL_LOGIN_DATE_PASS') {
                            var url = '/session/viewContents/view.so?realUrl=/nhepro/MOBILE_NHPT/MPTIDPW_040/view.so';
                            var param = {
                                USER_ID: $('#c-id').val(),
                                CODE: 'FAIL_LOGIN_DATE_PASS'
                            };

                            everPopup.openWindowPopup(url, 700, 600, param, '_self', false);
                        }

                        if (this.getResponseCode() == 'WRONG_PASSWORD_EXCEEDED_CNT') {
                            var url = "/session/viewContents/view.so?realUrl=/nhepro/MOBILE_NHPT/MPTIDPW_010/view.so";
                            var param = {
                                pageFlag: 'P'
                            };

                            everPopup.openWindowPopup(url, 700, 600, param, '_self', false);
                        }

                        // PW_RESET_FLAG = 1 일 경우 비밀번호 재설정
                        if (this.getResponseCode() == 'WRONG_PASSWORD_RESET_FLAG') {
                            var url = '/session/viewContents/view.so?realUrl=/nhepro/MOBILE_NHPT/MPTIDPW_040/view.so';
                            var param = {
                                USER_ID: $('#c-id').val(),
                                CODE: 'WRONG_PASSWORD_RESET_FLAG'
                            };

                            everPopup.openWindowPopup(url, 700, 600, param, '_self', false);
                        }

                        // 비밀번호 90일 경과 확인
                        if (this.getResponseCode() == 'WRONG_PASSWORD_RESET_DATE') {
                            var url = '/session/viewContents/view.so?realUrl=/nhepro/MOBILE_NHPT/MPTIDPW_040/view.so';
                            var param = {
                                USER_ID: $('#c-id').val(),
                                CODE: 'WRONG_PASSWORD_RESET_DATE'
                            };

                            everPopup.openWindowPopup(url, 700, 600, param, '_self', false);
                        }
                        //2023.01.10 휴면계정 로그인시 계정 전환 로직
                        //2024.01.08 파트너스 휴먼계정 제외
                        //if(this.getResponseCode() == 'LONG_TERM_NON_USER') {
                        //	store.load('/changeLongTermNonUserPT.so', function () {
                        //        alert("휴면 계정 전환이 완료되었습니다.\n다시 로그인 하시기 바랍니다.");
                        //    });
                        //	 location.reload();
                        //}
                    }
                } else {
                    alert(this.getResponseMessage());
                    
                }
                 } else {
                	 mobileHome();
            }
        }, false);
    }

    function mobileHome() {
        location.href = "/mobileHomePT.so";

    }

    function toggleSaveUserId() {
        $.cookie('c-id', ($('#c-id-save').prop('checked') == true ? $('#c-id').val() : null));
    }
</script>
<body>
    <section class="login-wrap">
        <div class="login-box">
            <div class="system-name">
                <h1><img src="/images/nhepro/common/logo_firstepro.png" alt="First ePro 전자계약시스템 NH INFORMATION SYSTEM"></h1>
                <h1 class="logoTxtStyle">전자계약시스템</h1>
             </div>
            <fieldset class="ins">
                <legend class="v-hidden">LOGIN</legend>
                <form>
                    <div class="fbox">
                        <p class="i-text">
                            <label for="c-id"><i class="dot"></i>아이디</label>
                            <input type="text" name="c-id" id="c-id" value="">
                        </p>
                        <p class="i-text">
                            <label for="c-pw"><i class="dot"></i>비밀번호</label>
                            <input type="password" name="c-pw" id="c-pw" value="" autocomplete=off>
                        </p>
                        <p class="i-chk">
                            <input type="checkbox" name="c-id-save" id="c-id-save" checked>
                            <label for="c-id-save">ID 기억하기</label>
                        </p>
                        <input type="button" value="로그인" class="btn-login" onclick="javascript:doLogin();">
                    </div>
                </form>                
            </fieldset>
            <div class="login-link"> 
                <a href="/session/viewContents/view.so?realUrl=/nhepro/MOBILE_NHPT/MPTAGG_010/view.so">회원가입</a>
                <span class="vline"></span>
                <a href="/session/viewContents/view.so?realUrl=/nhepro/MOBILE_NHPT/MPTIDPW_010/view.so">아이디/비밀번호 찾기</a>
            </div>
            

        </div>
        <div class="footer-copy">CAPYRIGHTⓒ 2020 NH INFORMATION SYSTEM CO., LTD ALL RIGHT RESERVED.</div>
    </section>
</body>

</html>