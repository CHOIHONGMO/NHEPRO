<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>My Page</title>
	<style>

		body {
			margin: 0;
			padding: 0;
			font-family: "맑은 고딕";
			font-size: 12px;
			line-height: 130%;
		}

		p {
			font-size: 13px;
			line-height: 120%;
			font-family: "맑은 고딕";
		}

		.title {
			font-size: 12pt;
			font-family: 맑은 고딕;
			font-weight: bold;
		}

		.textsA {
			font-size: 14px;
			color: #606060;
			margin-left: 65px;
		}

		.textsB {
			font-size: 18px;
			font-weight: bold;
			color: #dd1414;
			margin-left: 65px;
		}

		.textsBB {
			font-size: 18px;
			font-weight: bold;
			color: #006bb6;
			margin-left: 65px;
			line-height: 20px;
		}

		.num {
			font-size: 11pt;
			font-family: 맑은 고딕;
			font-weight: bold;
		}

		.salesform {
			background-color: #b8b8b8;
			border-collapse: separate;
			table-layout: fixed;
			position: relative;
			z-index: 1;
		}

		.td-out1 {
			background-image: url("/images/ymro/dashboard/supplier_01_w.png")
		}

		.td-over1 {
			background-image: url("/images/ymro/dashboard/supplier_01_b.png")
		}

		.td-out2 {
			background-image: url("/images/ymro/dashboard/supplier_02_w.png")
		}

		.td-over2 {
			background-image: url("/images/ymro/dashboard/supplier_02_b.png")
		}

		.td-out3 {
			background-image: url("/images/ymro/dashboard/supplier_03_w.png")
		}

		.td-over3 {
			background-image: url("/images/ymro/dashboard/supplier_03_b.png")
		}

		.td-out4 {
			background-image: url("/images/ymro/dashboard/supplier_04_w.png")
		}

		.td-over4 {
			background-image: url("/images/ymro/dashboard/supplier_04_b.png")
		}

		.td-out5 {
			background-image: url("/images/ymro/dashboard/supplier_05_w.png")
		}

		.td-over5 {
			background-image: url("/images/ymro/dashboard/supplier_05_b.png")
		}

		.todo-window-container-header-title {
			color: #222;
			position: relative;
			text-decoration: none;
			display: inline;
			line-height: 20px;
		}

		.todo-window-container-header-text {
			margin-left: 6px;
			position: relative;
		}

		.todo-padding {
			padding-top: 10px;
			padding-bottom: 10px;
		}

		todo-padding-tab {
			padding: 0;
		}

		.todo-window-container-header-bullet {
			background: url(/images/everuxf/theme/neo/icons/title_b_icon.png) 0 0 no-repeat;
			float: left;
			position: relative;
			height: 16px;
			width: 14px;
			top: 3px;
		}

		.e-window-container-body {
			padding: 10px 0 0 10px;
		}

		.loading {
			background: url(/images/icon/loader-indicator6.gif) center center no-repeat #fff;
		}

	</style>
	<link rel="stylesheet" href="/css/nhepro/fonts/NanumGothic.css">
	<link rel="stylesheet" href="/css/nhepro/bootstrap.min.css">

	<script>

        var baseUrl = "/eversrm/";

        function init() {

            var notice = EVF.C('notice');
            notice.setProperty('multiselect', false);
            notice.setProperty('shrinkToFit', true);
            notice.setHeaderStyle('fontSize', '14');
            notice._gvo.setStyles({indicator: {fontSize: '14'}});
            notice.cellClickEvent(function (rowid, celname, value, iRow, iCol) {
                if (celname == 'SUBJECT') {
                    var param = {
                        NOTICE_NUM: notice.getCellValue(rowid, 'NOTICE_NUM')
                        , detailView: true
                    };
                    everPopup.openPopupByScreenId('SETR0021', 950, 700, param);
                }
            });

            var store = new EVF.Store();
            store.setGrid([notice]);
            store.load(baseUrl + "doNotice.so", function () {

                for(var i = 0; i < notice.getRowCount(); i++) {
                    // notice.setRowHeight(i, 30);
                    notice.setRowFontSize(i, '14');
                }

                notice.setRowHeightAll(32);
            });

            resizeWindow();

			doSearchTodoNew(12);
			doSearchTodoNew(13);
        }

        function resizeWindow() {
            $(window).trigger('resize');
		}

		function doSearchTodoNew(v) {
			var store = new EVF.Store();

			var totalCnt = 0;
			var s = 0;
			var e = 0;
			var c;

			/* if(v == "11") {
				s = 20;
				e = 20;
				c = "mp";
			} else if(v == "12") {
				s = 21;
				e = 24;
				c = "pr";
			} else if(v == "13") {
				s = 25;
				e = 29;
				c = "om";
			} */
			
			if(v == "11") {
				s = 41;
				e = 41;
				c = "mp";
			} else if(v == "12") {
				s = 51;
				e = 54;
				c = "pr";
			} else if(v == "13") {
				s = 61;
				e = 65;
				c = "om";
			}
			
			for (var i = s; i <= e; i++) {
				if(i != 62) {
					var to = document.getElementById("todo" + i);

					to.classList.add("loading");
				}
			}

			store.load(baseUrl + "getTodoNew" + v + ".so", function() {
				for (var i = s; i <= e; i++) {
					if(i != 62) {
						var division = i;
						var cnt = 0;
						$("#todo" + division).html($(this.getParameter("todo" + division + "Html"))).removeClass("loading");
						$("#todo" + division).fadeIn("slow");

						var cntTxt = $("#todo"+division).find('.total a').text();

						cnt = Number(cntTxt.substr(0, cntTxt.length - 1));
						totalCnt += cnt;
					}
				}
				// 2020.08.11 제외
				//$("." + c).find("span").text(totalCnt + "건");
			}, false);
		}
		
		function pageRedirectByScreen(screenId){
			
			top.pageRedirectByScreenId(screenId);
		}
		
	</script>
</head>


<e:window id="mypageSupplier" onReady="init" initData="${initData}" title="">
	<div class="wrap">
		<section class="dashboard">
			<h2 class="sr-only">대시보드</h2>
			<div class="inner">
				<div class="title">TO DO</div>
<%--				<div class="list">--%>
<%--					<div class="title">--%>
<%--						<p class="title-sm mp">My Page<span class="total">건</span></p>--%>
<%--						<a class="btn btn-sm" href="javascript:doSearchTodoNew(11);">조회하기</a>--%>
<%--					</div>--%>
<%--					<div class="item">--%>
<%--						<div class="row">--%>
<%--							<div class="col col-3" id="todo20">--%>
<%--								<p class="title">고객의 소리(VOC)</p>--%>
<%--								<p class="total">건</p>--%>
<%--								<p class="desc">VOC, 진행상태 : 조치완료 제외한 전부</p>--%>
<%--							</div>--%>
<%--						</div>--%>
<%--					</div>--%>
<%--				</div>--%>
				<div class="list">
					<div class="title">
						<p class="title-sm pr">구매관리<span class="total"></span></p>
						<a class="btn btn-sm" href="javascript:doSearchTodoNew(12);">조회하기</a>
					</div>
					<div class="item">
						<div class="row">
							<div class="col col-3" id="todo51">
								<p class="title">견적 현황</p>
								<p class="total">- 건</p>
								<p class="desc">제출상태 : 마감 제외한 전부</p>
							</div>
							<div class="col col-3" id="todo52">
								<p class="title">견적선정결과대기 현황</p>
								<p class="total">- 건</p>
								<p class="desc">선정여부 : 선정대기</p>
							</div>
							<div class="col col-3" id="todo53">
								<p class="title">참가 가능한 입찰 현황</p>
								<p class="total">- 건</p>
								<p class="desc">참가 가능한 입찰 현황 : 미신청</p>
							</div>
							<div class="col col-3" id="todo54">
								<p class="title">계약진행 현황</p>
								<p class="total">- 건</p>
								<p class="desc">진행상태 : 계약체결완료 제외한 전부</p>
							</div>
						</div>
					</div>
				</div>
				<div class="list">
					<div class="title">
						<p class="title-sm om">발주관리<span class="total"></span></p>
						<a class="btn btn-sm" href="javascript:doSearchTodoNew(13);">조회하기</a>
					</div>
					<div class="item">
						<div class="row">
							<div class="col col-3" id="todo61">
								<p class="title">발주접수 현황</p>
								<p class="total">- 건</p>
								<p class="desc">발주접수 현황 : ALL</p>
							</div>
<%--							<div class="col col-3" id="todo62">--%>
<%--								<p class="title">발주진행 현황</p>--%>
<%--								<p class="total">건</p>--%>
<%--								<p class="desc">발주진행 현황 : 미정의</p>--%>
<%--							</div>--%>
							<div class="col col-3" id="todo63">
								<p class="title">부분검수요청 현황</p>
								<p class="total">- 건</p>
								<p class="desc">부분검수요청 현황 : 검수요청, 반송</p>
							</div>
							<div class="col col-3" id="todo64">
								<p class="title">검수요청 현황</p>
								<p class="total">- 건</p>
								<p class="desc">검수요청 현황 : 요청완료, 반려</p>
							</div>
<%--						</div>--%>
<%--						<div class="row">--%>
							<div class="col col-3" id="todo65">
								<p class="title">대금지급 현황</p>
								<p class="total">- 건</p>
								<p class="desc">대금지급 현황 : 지급요청</p>
							</div>
						</div>
					</div>
				</div>
				<div class="p-table">
					<div class="title">
						<p class="title-sm">공지사항</p>
					</div>
					<e:gridPanel gridType="${_gridType}" id="notice" name="notice" width="100%" height="fit" readOnly="${param.detailView}"/>
				</div>
			</div>
		</section>
	</div>
</e:window>
</e:ui>