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
    <script type="text/javascript" src="/js/ever-popup.js"></script>
    <script type="text/javascript" src="/js/ever-string.js"></script>
</head>
<script>
    function mobileHome() {
        location.href = '/mobileHome.so?pageType=N';
    }

    function downloadFile(uuid, uuidSq) {
        if(!top['hidden_workspace']) {
            var $iframe = $("<iframe id=\"hidden_workspace\" style=\"position: absolute; width: 0; height: 0; display: none;\"></iframe>");
            $iframe.appendTo(top.document.body);
        }
        top.$("#hidden_workspace").attr("src", "/common/file/fileAttach/download.so?EVER_REQUEST_DATA_TYPE=FILE_DOWNLOAD&UUID=" + uuid + "&UUID_SQ=" + uuidSq);
    }
</script>
<body>
<div class="header">
    <a href="#" onclick="javascript:mobileHome();" class="btn-back"><span class="v-hidden">이전</span></a>
    <h1>공지사항 상세</h1>
</div>    
<div class="page-wrap">
    
    <section class="contents notice" >
        <div class="titbar">
            <h2 class="txt-black">${form.SUBJECT}</h2>
        </div>
        <section class="fbox">
           ${CONTENTS}
        </section>
        <ul class="link-file">
            <c:forEach var="attach" items="${attachedFiles}">
                <li><a href="javascript:downloadFile('${attach.UUID}','${attach.UUID_SQ}')">${attach.REAL_FILE_NM}</a></li>
            </c:forEach>
        </ul>
    </section>
</div>
</body>
</html>