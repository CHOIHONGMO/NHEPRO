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
	<!--<meta name="viewport" content="width=device-width, initial-scale=1.0">-->
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
	<style>
		.table_paginate .first,
		.table_paginate .prev,
		.table_paginate .next,
		.table_paginate .last {
			border: none;
		}

		.table_paginate a:active,
		.table_paginate a.active {
			border: none;
			line-height: 29px;
			color: #303030;
			font-weight: bold;
		}

		.table_paginate a {
			height: 27px;
			width: 27px;
		}

		.pagination {
			margin: 0 auto;
			padding-left: 60px;
		}
	</style>
	<script>
		$(document).ready(function () {
			// $('#mainIframe', parent.document).css('height', document.body.scrollHeight + 57);
			doSearch();
		});

		function doSearch() {
			doSearchCount();
			doSearchList();
		}

		function doSearchCount() {
			$('#countFlag').val('1');

			$.post("/nhepro/mainNoticeList.so", $('#form').serialize(), function (data) {
				// paging 구현
				// TotalCount 받아오기
				var totalCount = JSON.parse(data).totalCount;
				$('#page-selection').bootpag({
					total: parseInt((totalCount - 1) / 10 + 1),
					page: $('#pageNo').val(),
					maxVisible: 10,
					leaps: true,
					firstLastUse: true,
					first: '<img class="pagingBtnStyle" src="/images/nhepro/paging/paging_to_first.jpg" alt="처음">',
					prev: '<img class="pagingBtnStyle" src="/images/nhepro/paging/paging_to_prev.png" alt="이전">',
					next: '<img class="pagingBtnStyle" src="/images/nhepro/paging/paging_to_next.png" alt="다음">',
					last: '<img class="pagingBtnStyle" src="/images/nhepro/paging/paging_to_end.jpg" alt="마지막">',
					wrapClass: 'pagination',
					activeClass: 'active',
					disabledClass: 'disabled',
					nextClass: 'next',
					prevClass: 'prev',
					lastClass: 'last',
					firstClass: 'first'
				}).on("page", function (event, /* page number here */ num) {
					// Page 내용 별도 조회
					$('#pageNo').val(num);
					doSearchList();
				});
			});
		}

		function doSearchList() {
			$('#countFlag').val('0');
			$.post("/nhepro/mainNoticeList.so", $('#form').serialize(), function (data) {
				data = JSON.parse(data);
				var html = "<thead>\n";
				html += "<tr>\n";
				html += "    <th>번호</th>\n";
				html += "    <th>제&nbsp;&nbsp;&nbsp;&nbsp;목</th>\n";
				html += "    <th>작성일</th>\n";
				html += "</tr>\n";
				html += "</thead>\n";
				html += "<tbody>\n";
				for (var i in data) {
					html += "<tr style='height: 42px;'>\n";
					html += "    <td>" + data[i].RN + "</td>\n";
					html += "    <td><a href=\"javascript:doClick('" + data[i].NOTICE_NUM + "');\">" + data[i].SUBJECT + "</a></td>\n";
					html += "    <td>" + data[i].REG_DATE + "</td>\n";
					html += "</tr>\n";
				}
				for (var i = 0; i < 10 - data.length; i++) {
					html += "<tr style='height: 42px;'>\n";
					html += "    <td></td>\n";
					html += "    <td></td>\n";
					html += "    <td></td>\n";
					html += "</tr>\n";
				}
				html += "</tbody>";

				$('.table_list').html(html);
			});
		}

		function doClick(notice_num) {
			var url = "/mainHtml/03_customer/03_notice_detail.jsp";
			var param = {
				NOTICE_NUM: notice_num
			};
			everPopup.openWindowPopup(url, 700, 600, param, '_self', true);
		}

	</script>
</head>
<body>
<!--wrap-->
<form id="form" onsubmit="return false">
	<div class="wrap">
		<input type="hidden" id="pageNo" name="pageNo" value="1"/>
		<input type="hidden" id="countFlag" name="countFlag" value="1"/>
		<!--header_wrap-->
		<c:import url="../header/header.jsp" charEncoding="UTF-8"/>
		<!--// header_wrap-->

		<section class="service">
			<h2 class="sr-only">고객지원센터</h2>
			<div class="title">
				<p>고객지원센터</p>
			</div>
			<div class="box">
				<div>
					<ul class="nav nav-pills" id="pills-tab" role="tablist">
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
			</div>

			<!--content-->
			<div class="contents contents_cus_center contents_notice">
				<div class="tabs_contents notice_list">
					<section class="notice_area">
						<div class="table_search">
							<fieldset class="board_search">
								<legend class="screen_out">검색</legend>
								<select name="selectType" id="selectType">
									<option value="title">제목</option>
									<option value="contents">내용</option>
									<option value="contents">사무소명</option>
									<option value="contents">담당자</option>
									<option value="all">전체</option>
								</select>
								<input type="text" class="input_search" name="searchText" id="searchText" onkeypress="doSearch()">
								<a class="btn btn_no_radius btn_search" href="javascript:doSearch();" style="color: #fff;">검색</a>
							</fieldset>
						</div>

						<table class="table_list notice" summary="공지사항 번호, 제목, 등록일" style="height: 474px;">

						</table>

						<!-- 페이징 -->
						<div class="table_paginate">
							<div id="page-selection"></div>
						</div>
					</section>
				</div>
			</div>
			<!--// content-->
        </section>

        <!--footer_wrap-->
        <c:import url="../footer/footer.jsp" charEncoding="UTF-8"/>
        <!--// footer_wrap-->
	</div>
	<!--// wrap-->
</form>
</body>
</html>