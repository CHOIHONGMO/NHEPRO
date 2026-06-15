<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
	<meta name="Referrer" content="origin">
	<meta http-equiv="X-UA-Compatible" content="IE=Edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<meta name="apple-mobile-web-app-title" content="FIRSTePro"/>
	<meta name="robots" content="index,nofollow"/>
	<meta name="description" content="FIRSTePro"/>
	<meta name="keywords" content="FIRSTePro"/>
	<meta name="format-detection" content="telephone=no"/>
	<title>FIRSTePro 빠르고 투명한 전자구매/계약 서비스</title>
	<link rel="stylesheet" href="/css/nhepro/notice/common.css" type="text/css">
	<link rel="stylesheet" href="/css/nhepro/notice/layout.css" type="text/css">
	<link rel="stylesheet" href="/css/nhepro/notice/page.css" type="text/css">
	<link rel="stylesheet" href="/css/nhepro/notice/paging.css" type="text/css">
	<link rel="stylesheet" href="/css/nhepro/fonts/NanumGothic.css">
	<link rel="stylesheet" href="/css/nhepro/bootstrap.min.css">

	<script type="text/javascript" src="/js/jquery-3.2.1.min.js"></script>
	<script type="text/javascript" src="/js/nhepro/notice/jquery.bootpag.js"></script>
	<script type="text/javascript" src="/js/nhepro/notice/jquery.bxslider.js"></script>
	<script type="text/javascript" src="/js/nhepro/notice/common.js"></script>
	<script type="text/javascript" src="/js/ever-string.js"></script>
	<script type="text/javascript" src="/js/ever-popup.js"></script>
    <script>
        $(document).ready(function () {
        	doSearch();
        });
		
        function doSearch() {
        	var param = {
                    'NOTICE_NUM': '${param.NOTICE_NUM}'
                };

            $.post("/nhepro/mainNoticeDetail.so", param, function (data) {
                $('#title').text(data.SUBJECT);
                $('#date').text(data.REG_DATE);
                $('#contents').html(data.TEXT_CONTENTS);

                param = {
                    'ATT_FILE_NUM': data.ATT_FILE_NUM
                };

                $.post("/nhepro/mainNoticeDetailFile.so", param, function (fileData) {
                    var html = "";

                    for(var i in fileData) {
                        var fileInfo = fileData[i];
                        html += '<a href="javascript:downloadFile(\'' + fileInfo.UUID + '\',\'' + fileInfo.UUID_SQ + '\')">'+ fileInfo.REAL_FILE_NM +'</a><BR/>';
                    }
                    $('#fileInfo').append(html);
                }, "json");
            }, "json");
		}
        
        function downloadFile(uuid, uuid_sq) {
            if (!top['hidden_workspace'] || top['hidden_workspace'] == undefined) {
                var $aLink = $("<a id='hidden_workspace' download></a>");
                $aLink.appendTo(document.body);
            }
            $("#hidden_workspace").attr("href", "/common/file/fileAttach/download.so?EVER_REQUEST_DATA_TYPE=FILE_DOWNLOAD&UUID="+ uuid +"&UUID_SQ="+ uuid_sq);

            document.getElementById("hidden_workspace").click();
        }
    </script>
</head>
<body>

<!--wrap-->
<form id="form">
	<div class="wrap">
		<input type="hidden" id="NOTICE_NUM" name="NOTICE_NUM" value="${param.NOTICE_NUM}"/>
		
	    <!--header_wrap-->
	    <c:import url="../header/header.jsp" charEncoding="UTF-8"/>
	    <!--// header_wrap-->
	
	    <section class="service">
	        <h2 class="sr-only">고객지원센터</h2>
	        <div class="title">
	            <p>고객지원센터</p>
	        </div>
	
	        <!--content-->
	        <div class="contents contents_cus_center contents_notice">
	            <div>
	                <ul class="nav nav-pills" id="pills-tab" role="tablist" style="padding: 0;">
	                    <li class="nav-item">
	                        <a class="nav-link nav-link3 active" href="/mainHtml/03_customer/03_notice_list.jsp">공지사항</a>
	                    </li>
	                    <li class="nav-item">
	                        <a class="nav-link nav-link3" href="/mainHtml/03_customer/03_notice_list2.jsp">입찰공고</a>
	                    </li>
	                    <li class="nav-item">
	                        <a class="nav-link nav-link3" href="/mainHtml/03_customer/faq.jsp">FAQ</a>
	                    </li>
	                </ul>
	            </div>
	
	            <!-- S content-01 -->
	            <div class="content content-01">
	                <nav aria-label="breadcrumb">
	                    <ol class="breadcrumb">
	                        <li class="breadcrumb-item"><a href="#">고객지원센터</a></li>
	                        <li class="breadcrumb-item active"><a href="#">공지사항</a></li>
	                    </ol>
	                </nav>
	            </div>
	
	            <div class="tabs_contents notice_detail">
	                <section class="clearfix">
	                    <div class="board_list">
	                        <div class="title_area">
	                            <p class="date" id="date"></p>
	                        </div>
	                        <div class="contents_area" id="contents">
	                        </div>
	                        <div id="fileInfo" style="text-align: right;"></div>
	                    </div>
	                    <a class="btn btn_no_radius" href="/mainHtml/03_customer/03_notice_list.jsp">목록</a>
	                </section>
	            </div>
	        </div>
	    <!--// content-->
	    </section>
	
	    <c:import url="../footer/footer.jsp" charEncoding="UTF-8"/>
	</div>
	<!--// wrap-->
</form>
</body>
</html>