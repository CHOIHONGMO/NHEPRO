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
    function doSearch() {
        if($('#USER_NM').val() == '' && $('#DEPT_NM').val() == '') {
            return alert("담당자 이름 또는 담당자 부서명을 입력하여 주시기 바랍니다.");
        }

        var url = "/nhepro/MOBILE/MAGG_030_doSearch.so";
        var param = {
            USER_NM: $('#USER_NM').val(),
            DEPT_NM: $('#DEPT_NM').val()
        };
        $.post(url, param, function (data) {
            if(data.length == 0) {
                alert('${msg.M0002}');
            } else {
                var html = "";
                for(var i in data) {
                    html += "<tr>";
                    html += "   <td><a href='javascript:doSelUser(" + JSON.stringify(data[i]) + ");'>" + data[i].USER_NM + "</a></td>";
                    html += "   <td>" + data[i].COMPANY_NM + "</td>";
                    html += "   <td>" + data[i].DEPT_NM + "</td>";
                    html += "   <td>" + data[i].DUTY_NM + "</td>";
                    html += "</tr>";
                }

                $('tbody').html(html);
            }
        }, 'json');
    }

    function doSelUser(data) {
        opener['${form.callBackFunction}'](data);
        window.close();
    }
</script>
<body>
<div class="header">    
     <h1>회원가입</h1> 
</div>    
<div class="page-wrap">
    <section class="contents sign-up">
        <div class="titbar">
            <h2>담당자 검색</h2>
            <div class="signup-step">
                <span>1</span><em></em><span class="active">2</span><em></em><span>3</span>
            </div>
        </div>        
        <fieldset class="ins person">
            <legend class="v-hidden">담당자 검색</legend>
            <form>
                <div class="fbox">
                    <div class="i-text">
                        <label for="USER_NM"><i class="dot"></i>담당자 이름</label>
                        <input type="text" name="USER_NM" id="USER_NM" value="">
                    </div>
                    <div class="i-text">
                        <label for="DEPT_NM"><i class="dot"></i>담당자 부서명</label>
                        <input type="text" name="DEPT_NM" id="DEPT_NM" placeholder="담당자 부서명을 입력해 주세요">
                    </div>
                    <div class="btn-area f-right">
                        <button type="button" class="btn-search" onclick="javascript:doSearch();">검색</button>
                    </div>
                </div>
            </form>    
        </fieldset>

        <div class="table-header-fixed">
            <div class="data-table">
                <table class="list">
                    <colgroup>
                        <%-- <col style="width: 128px;">
                        <col style="width: 192px;">
                        <col style="width: 192px;">
                        <col style="width: 128px;"> --%>
                        <col style="width: 20%">
                        <col style="width: 30%">
                        <col style="width: 30%">
                        <col style="width: 20%">
                    </colgroup>
                    <thead>
                    <tr>
                        <th>이름</th>
                        <th>회사</th>
                        <th>부서명</th>
                        <th>직책</th>
                    </tr>
                    </thead>
                    <tbody>
                    </tbody>
                </table>
            </div>
        <div>
    </section>    
</div>    

</body>

</html>