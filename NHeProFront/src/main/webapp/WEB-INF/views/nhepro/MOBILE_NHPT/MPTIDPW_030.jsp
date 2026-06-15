<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="utf-8">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no">
    <meta name="robots" content="index,nofollow">
    <meta name="description" content="FIRSTePro 빠르고 투명한 전자구매/계약 서비스">
    <title>FIRSTePro 빠르고 투명한 전자구매/계약 서비스</title>
    <link rel="stylesheet" href="/css/nhepro/nhepro-m.css">
    <link rel="shortcut icon" href="/images/favicon.ico"/>
</head>
<script>
    function mobileHome() {
        location.href = '/mobileNHPT/index.jsp';
    }
</script>
<body>
<div class="header">
    <h1>회원가입</h1>
</div>
<div class="page-wrap">

    <section class="contents sign-up">
        <section class="fbox">
            <div class="txt-result01">
                <i class="ico-ok"></i><br>
                임시 비밀번호가<br>
                <strong>${CELL_NUM}</strong><br>
                으로 발송 되었습니다.<br>
                	휴대전화를 확인하시기<br>
                바랍니다.
            </div>
        </section>

        <div class="btn-area f-none">
            <button type="button" class="btn-basic" onclick="javascript:mobileHome();">초기 화면으로 이동</button>
        </div>
    </section>

</div>


</body>

</html>