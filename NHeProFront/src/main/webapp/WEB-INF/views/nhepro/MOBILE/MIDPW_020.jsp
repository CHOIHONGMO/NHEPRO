<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no">
    <meta name="robots" content="index,nofollow">
    <meta name="description" content="FIRSTePro 빠르고 투명한 전자구매/계약 서비스">
    <title>FIRSTePro 빠르고 투명한 전자구매/계약 서비스</title>
    <link rel="stylesheet" href="/css/nhepro/nhepro-m.css">
    <link rel="shortcut icon" href="/images/favicon.ico"/>
    <script type="text/javascript" src="/js/everuxf/everuxf.min.js"></script>
    <script type="text/javascript" src="/js/ever-popup.js"></script>
    <script type="text/javascript" src="/js/ever-string.js"></script>
</head>
<script>
    function mobileHome() {
        location.href = '/mobile/index.jsp';
    }

    function doSearchPw() {
        var url = "/nhepro/MOBILE/MIDPW_010/view.so";
        var param = {
            pageFlag: 'P'
        };

        everPopup.openWindowPopup(url, 700, 600, param, '_self', false);
    }
</script>
<body>
<div class="header">    
    <h1>아이디/비밀번호 찾기</h1> 
</div>     
<div class="page-wrap">

    <section class="contents">
        <div class="titbar">
            <h2 class="txt-black">아이디 찾기 결과</h2>            
        </div>
        <div class="fbox find-id">
            <div class="txt-find-id">
                <strong>회원님의 가입하신 정보는</strong><br>아래와 같습니다. 
            </div>
            <div class="ibox"> 
                <span><i class="dot"></i>아이디</span><strong>${USER_ID}</strong>
            </div>
            <ul class="help"> 
                <li><em>※</em>고객님의 안전한 개인정보보호를 위해<br>
                <strong>아이디 끝에 2자리는 *로 처리</strong>하였습니다 .
                </li>
            </ul>  
        </div>
        <div class="btn-area">
            <button type="button" class="btn-darkgray" onclick="javascript:doSearchPw();">비밀번호 찾기</button>
            <button type="button" class="btn-basic" onclick="javascript:mobileHome();">로그인 하기</button>
        </div>
    </section>
</div>

  
</body>

</html>