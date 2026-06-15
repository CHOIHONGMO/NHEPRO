<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

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
</head>
<script>
    function mobileHome() {
        location.href = '/mobile/index.jsp';
    }
</script>
<body>
<div class="header">    
    <h1>회원가입</h1> 
</div>       
<div class="page-wrap">
    
    <section class="contents sign-up">
        <div class="titbar">
            <h2>신청 완료</h2>
            <div class="signup-step">
                <span>1</span><em></em><span>2</span><em></em><span class="active">3</span>
            </div>
        </div>
        <section class="fbox"> 
            <div class="txt-result01">
                <i class="ico-ok"></i><br>
                <strong>회원 가입 신청이 완료</strong>되었습니다. 
            </div>    
            
            <div class="txt-result02">
                신청하신 정보는 <br>
                현장 담당자의 검토 및 승인 처리 후 <br>
                시스템 사용이 가능합니다.<br><br>
                담당자 검토가 완료되면<br>
                문자 메시지, E-mail 로 승인 결과가 <br>
                회원님께 전송 됩니다.
            </div>    
        </section>
        
        <div class="btn-area f-none">
            <button type="button" class="btn-basic" onclick="javascript:mobileHome();">초기 화면으로 이동</button>
        </div>  
    </section>
    
</div>

    

    
</body>

</html>