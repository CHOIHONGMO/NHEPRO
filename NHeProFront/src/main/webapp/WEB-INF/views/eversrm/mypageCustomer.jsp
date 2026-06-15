<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
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
		color : #606060;
		margin-left : 65px;
		line-height : 24px;
	}

	.textsB {
		font-size: 18px;
		font-weight: bold;
		color : #dd1414;
		margin-left : 65px;
	}

	.textsBB {
		font-size: 18px;
		font-weight: bold;
		color : #006bb6;
		margin-left : 65px;
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
	.td-out1 {background-image:url("/images/ymro/dashboard/customer_01_w.png")}
	.td-over1 {background-image:url("/images/ymro/dashboard/customer_01_b.png")}

	.td-out2 {background-image:url("/images/ymro/dashboard/customer_02_w.png")}
	.td-over2 {background-image:url("/images/ymro/dashboard/customer_02_b.png")}

	.td-out3 {background-image:url("/images/ymro/dashboard/customer_03_w.png")}
	.td-over3 {background-image:url("/images/ymro/dashboard/customer_03_b.png")}

	.td-outS2 {background-image:url("/images/ymro/dashboard/supplier_02_w.png")}
	.td-overS2 {background-image:url("/images/ymro/dashboard/supplier_02_b.png")}

	.td-outS3 {background-image:url("/images/ymro/dashboard/supplier_03_w.png")}
	.td-overS3 {background-image:url("/images/ymro/dashboard/supplier_03_b.png")}

	.td-outS4 {background-image:url("/images/ymro/dashboard/supplier_04_w.png")}
	.td-overS4 {background-image:url("/images/ymro/dashboard/supplier_04_b.png")}

	.item_table{
		border-top: 2px #0072c9 double;
	}

	.item_td{
		height: 29px;
		width: 145px;
		text-align: center;
		border: 1px solid #b7b7b7;
		cursor:pointer;
	}
	.item_text {
		font-size: 12px;
		font-family: Nanum Barun Gothic !important;
		color : #606060;
	}
	.item_Btext {
		font-size: 12px;
		font-family: Nanum Barun Gothic !important;
		font-weight: bold;
		color : #303030;
	}

	.itemtd-out {
		height: 29px;
		width: 145px;
		text-align: center;
		border: 1px solid #b7b7b7;
		cursor:pointer;
	}
	.itemtd-over {
		height: 29px;
		width: 145px;
		text-align: center;
		border: 1px solid #b7b7b7;
		cursor:pointer;
		font-size: 12px;
		font-family: Nanum Barun Gothic !important;
		font-weight: bold;
		color : #303030;
		background-color: #e6f5ff;
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

	.todo-window-container-header-bullet {
		background: url(/images/everuxf/theme/neo/icons/title_b_icon.png) 0 0 no-repeat;
		float: left;
		position: relative;
		height: 16px;
		width: 14px;
		top: 3px;
	}

    .todo-realgridpanel-wrapper {
        border-top: 2px solid #027bc2;
        margin-top: 2px;
        margin-bottom: 0 !important;
        clear: both;
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

	function getContentTab(uu) {
		if (uu == '1') {
			window.scrollbars = true;
		}
	}

	var notice;
	var screenAuth;

	function init() {

		notice = EVF.C('notice');
        notice.setProperty('multiselect', false);
        notice.setProperty('shrinkToFit', true);
        notice.setHeaderStyle('fontSize', '14');
        notice._gvo.setStyles({indicator: {fontSize: '14'}});

		notice.cellClickEvent(function (rowid, celname, value, iRow, iCol) {
			var msg;
			if (celname == 'SUBJECT') {
				var param = {
						NOTICE_NUM: notice.getCellValue(rowid, 'NOTICE_NUM'),
						detailView: true
					};
				everPopup.openPopupByScreenId('CETR0021', 950, 700, param);
			}
		});

        var store = new EVF.Store();
        store.setGrid([notice]);
        store.load(baseUrl + "doNotice.so", function () {
            for(var i = 0; i < notice.getRowCount(); i++) {
                notice.setRowHeight(i, 30);
                notice.setRowFontSize(i, '14');
            }
        }, false);
		
        doSearchScreenAuth();
        //doSearchTodoNew(1);
        //doSearchTodo2();
        //doSearchTodo3();
        //doSearchTodo4();

		/*$("#todoContainer").delegate(".todo table tr td:last-child", "click", function() {

			var $this = $(this);
			var id = $this.prop("id");
			var moduleType = id.substring(0, 2);
			if(top) {

				top.$(".e-topmenu-wrapper").removeClass("e-topmenu-selected");
				top.$("#"+moduleType).addClass("e-topmenu-selected");
				top.EVF.C("leftMenuTree").setProperty("expandAllNode", true);
				top.EVF.C("leftMenuTree").loadTreeForModuleType(moduleType).then(function() {

					var menuName = $this.siblings("td").text();
					top.$("#leftMenuTree .e-treepanel-contents").find("div[title=\""+menuName+"\"]").trigger("click");

				}, function() {

				});
			}
		});*/
    }
	
	//2021.04.15 화면 권한에 따른 메인화면 대쉬보드 건수 클릭 시 접근권한 제어 추가 
	function doSearchScreenAuth() {
		var store = new EVF.Store()
		store.load(baseUrl + "getScreen.so", function() {
			screenAuth = this.getParameter("screenId");
			doSearchTodoNew(1);
		}, false);
	}
	
	function doSearchTodoNew(v) {
		var store = new EVF.Store();

		var totalCnt = 0;
		var s = 0;
		var e = 0;
		var c;

		/* if(v == "1") {
			s = 1;
			e = 5;
			c = "ap";
		} else if(v == "2") {
			s = 6;
			e = 13;
			c = "po";
		} else if(v == "3") {
			s = 14;
			e = 15;
			c = "ec";
		} else if(v == "4") {
			s = 16;
			e = 19;
			c = "om";
		} */
		
		if(v == "1") {
			s = 1;
			e = 6;
			c = "ap";
		} else if(v == "2") {
			s = 11;
			e = 18;
			c = "po";
		} else if(v == "3") {
			s = 21;
			e = 22;
			c = "ec";
		} else if(v == "4") {
			s = 31;
			e = 34;
			c = "om";
		}

		for (var i = s; i <= e; i++) {
			var to = document.getElementById("todo" + i);
			to.classList.add("loading");
		}

		store.load(baseUrl + "getTodoNew" + v + ".so", function() {
			for (var i = s; i <= e; i++) {
				var division = i;
				var cnt = 0;

				$("#todo" + division).html($(this.getParameter("todo" + division + "Html"))).removeClass("loading");
				$("#todo" + division).fadeIn("slow");

				var cntTxt = $("#todo"+division).find('.total a').text();
				cnt = Number(cntTxt.substr(0, cntTxt.length - 1));
				totalCnt += cnt;
			}
			// 2020.08.11 제외
			//$("." + c).find("span").text(totalCnt + "건");
		}, false);
	}
	
	//2021.04.15 화면 권한에 따른 메인화면 대쉬보드 건수 클릭 시 접근권한 제어 추가 
	function pageRedirectByScreen(screenId, param){
		if(screenId == "CBDR0050_A"){
			if (param == undefined) param = {};
			screenId = "CBDR0050";
			param.type = 'A';
		}
		if (screenAuth.indexOf(screenId) == -1) {
			return EVF.alert("접근 권한이 없습니다.");
        }else{
			top.pageRedirectByScreenId(screenId, param);
        }
	}
	
    function tab_click(screenId) {

        // 입고 권한 체크
        if(screenId == 'BGA1_030' || screenId == 'BGA1_010') {
            if('${ses.mngYn}' == '0' && '${ses.grFlag}' == '0') {
                return EVF.alert("접근 권한이 없습니다.");
            }
        }

        // 정산 권한 체크
        if(screenId == 'BGA1_040') {
            if('${ses.mngYn}' == '0' && '${ses.financialFlag}' == '0') {
                return EVF.alert("접근 권한이 없습니다.");
            }
        }

        var param;
        if (screenId == "BNM1_030") {
            param = {
                'progressCd': "ALL",
                'autoSearchFlag': "Y",
                'detailView': false
            };
        }
        if (screenId == "BGA1_030" || screenId == "BGA1_040" || screenId == "CWOR0010" || screenId == "BOD1_050") {
            param = {
                'autoSearchFlag': "Y",
                'detailView': false
            };
        }
        if (screenId == "BGA1_010") {
            param = {
                'fromDate': "${twoWeeks}",
                'toDate': "${toDate}",
                'autoSearchFlag': "Y",
                'detailView': false
            };
        }
        <%--
        var el = parent.parent.document.getElementById('mainIframe');
        el.contentWindow.pageRedirectByScreenId(screenId, param);
        --%>
		top.pageRedirectByScreenId(screenId, param);
    }

    function litemCls_click(itemCls,itemClsNm){

        var param = {
            'detailView': false,
			'ITEM_CLS1' : itemCls,
            'ITEM_CLS_NM' : itemClsNm,
			'autoSearch' : true
        };
        var el = parent.parent.document.getElementById('mainIframe');
        el.contentWindow.pageRedirectByScreenId("BOD1_010", param);
	}

	function searchBtn() {
        var param = {
            'detailView': false,
            'ITEM_DESC' : document.getElementById("ITEM_SEARCH_TEXT").value,
            'autoSearch' : true
        };
        var el = parent.parent.document.getElementById('mainIframe');
        el.contentWindow.pageRedirectByScreenId("BOD1_010", param);
    }

    function searchEnter(){
        if(event.keyCode == 13){
            searchBtn();
        }
	}
</script>

<%--고객사메인--%>
<e:window id="mypageCustomer" onReady="init" initData="${initData}" title="">
	<div class="wrap">
		<!--  <header>-->
		<!--    <h1 class="sr-only">FIRSTePro</h1>-->
		<!--    <div class="box">-->
		<!--      <div class="nav_top">-->
		<!--      </div>-->
		<!--      <nav class="navbar navbar-expand">-->
		<!--        <a class="navbar-brand" href="#"><img src="../img/common/logo_firstepro.png" alt="FIRSTePro"></a>-->
		<!--        <div class="collapse navbar-collapse">-->
		<!--        </div>-->
		<!--      </nav>-->
		<!--    </div>-->
		<!--  </header>-->

		<section class="dashboard">
			<h2 class="sr-only">대시보드</h2>
			<div class="inner">
				<div class="title">TO DO</div>
				<div class="list">
					<div class="title">
						<p class="title-sm ap">전자결재 / 기준정보<span class="total"></span></p>
						<a class="btn btn-sm" href="javascript:doSearchTodoNew(1);">조회하기</a>
					</div>
					<div class="item">
						<div class="row">
							<div class="col col-3" id="todo1">
								<p class="title">결재대기 현황</p>
								<p class="total">- 건</p>
								<p class="desc">결재함 : ALL</p>
							</div>
							<div class="col col-3" id="todo2">
								<p class="title">결재상신 현황</p>
								<p class="total">- 건</p>
								<p class="desc">결재상신함, 결재상태 : 결재중, 반려</p>
							</div>
							<div class="col col-3" id="todo3">
								<p class="title">품목승인대기 현황</p>
								<p class="total">- 건</p>
								<p class="desc">품목등록승인현황, 진행상태 : 등록완료 제외한 전부</p>
							</div>
							<div class="col col-3" id="todo4">
								<p class="title">품목등록신청 현황</p>
								<p class="total">- 건</p>
								<p class="desc">품목등록신청현황, 진행상태 : 등록완료 제외한 전부</p>
							</div>
						</div>
					</div>
					<div class="item">
						<div class="row">
							<div class="col col-3" id="todo5">
								<p class="title">신규업체대기 현황</p>
								<p class="total">- 건</p>
								<p class="desc">신규업체대기현황, 진행상태 : 승인 제외한 전부</p>
							</div>
							<div class="col col-3" id="todo6">
								<p class="title">나의 예정가격 미확정 현황</p>
								<p class="total">- 건</p>
								<p class="desc">예정가격 확정상태 : 미확정</p>
							</div>
						</div>
					</div>
				</div>
				<div class="list">
					<div class="title">
						<p class="title-sm po">구매관리<span class="total"></span></p>
						<a class="btn btn-sm" href="javascript:doSearchTodoNew(2);">조회하기</a>
					</div>
					<div class="item">
						<div class="row">
							<div class="col col-3" id="todo11">
								<p class="title">구매의뢰진행 현황</p>
								<p class="total">- 건</p>
								<p class="desc">구매의뢰진행현황 : ALL</p>
							</div>
							<div class="col col-3" id="todo12">
								<p class="title">구매의뢰 담당자 지정대기 현황</p>
								<p class="total">- 건</p>
								<p class="desc">담당자 지정 : 미지정</p>
							</div>
							<div class="col col-3" id="todo13">
								<p class="title">[수의계약] 견적 현황</p>
								<p class="total">- 건</p>
								<p class="desc">견적현황, 진행상태 : 선정완료 제외한 전부</p>
							</div>
							<div class="col col-3" id="todo14">
								<p class="title">[입찰] 입찰공고 현황</p>
								<p class="total">- 건</p>
								<p class="desc">입찰공고 : ALL</p>
							</div>
						</div>
					</div>
					<div class="item">
						<div class="row">
							<div class="col col-3" id="todo15">
								<p class="title">[입찰] 입찰등록 현황</p>
								<p class="total">- 건</p>
								<p class="desc">입찰등록 : ALL</p>
							</div>
							<div class="col col-3" id="todo16">
								<p class="title">[입찰] 입찰진행 현황</p>
								<p class="total">- 건</p>
								<p class="desc">입찰진행 : ALL</p>
							</div>
							<div class="col col-3" id="todo17">
								<p class="title">예정가격 현황</p>
								<p class="total">- 건</p>
								<p class="desc">예정가격, 진행상태 : 확정 제외한 전부</p>
							</div>
							<div class="col col-3" id="todo18">
								<p class="title">선정품의대기 현황</p>
								<p class="total">- 건</p>
								<p class="desc">선정품의대기목록 : ALL</p>
							</div>
						</div>
					</div>
				</div>
				<div class="list">
					<div class="title">
						<p class="title-sm ec">계약관리<span class="total"></span></p>
						<a class="btn btn-sm" href="javascript:doSearchTodoNew(3);">조회하기</a>
					</div>
					<div class="item">
						<div class="row">
							<div class="col col-3" id="todo21">
								<p class="title">계약대기 현황</p>
								<p class="total">- 건</p>
								<p class="desc">계약대기현황 : ALL</p>
							</div>
							<div class="col col-3" id="todo22">
								<p class="title">계약체결진행 현황</p>
								<p class="total">- 건</p>
								<p class="desc">계약체결진행현황 : ALL</p>
							</div>
						</div>
					</div>
				</div>
				<div class="list">
					<div class="title">
						<p class="title-sm om">발주관리<span class="total"></span></p>
						<a class="btn btn-sm" href="javascript:doSearchTodoNew(4);">조회하기</a>
					</div>
					<div class="item">
						<div class="row">
							<div class="col col-3" id="todo31">
								<p class="title">발주미접수 현황</p>
								<p class="total">- 건</p>
								<p class="desc">발주현황, 접수상태 : 미접수</p>
							</div>
							<div class="col col-3" id="todo32">
								<p class="title">전체검수대기 현황</p>
								<p class="total">- 건</p>
								<p class="desc">전체검수대기, 진행상태 : 요청완료, 반려</p>
							</div>
							<div class="col col-3" id="todo33">
								<p class="title">부분검수대기 현황</p>
								<p class="total">- 건</p>
								<p class="desc">부분검수대기, 진행상태 : 검수요청, 반송</p>
							</div>
							<div class="col col-3" id="todo34">
								<p class="title">대금지급대기 현황</p>
								<p class="total">- 건</p>
								<p class="desc">대금지급 현황, 진행상태 : 지급요청</p>
							</div>
						</div>
					</div>
				</div>
				<div class="p-table">
					<div class="title">
						<p class="title-sm">공지사항</p>
					</div>
					<e:gridPanel gridType="${_gridType}" id="notice" name="notice" width="100%" height="136px" readOnly="${param.detailView}"/>
				</div>
			</div>
		</section>
	</div>
	<%--
	<div class="todo-window-container-header-title font-main-title" title="상품검색" style="margin-top:10px; width: 100%;">
		<div class="todo-window-container-header-bullet"></div><span class="todo-window-container-header-text">상품검색</span>
		<div id="t5" style="width: 100%;" class="todo-padding">
			<div id="t5b" style="width: 100%;">
				<input id="ITEM_SEARCH_TEXT" name="ITEM_SEARCH_TEXT" class="e-abstractfield e-inputtext" type="search" style="margin-left:20px; width:820px !important; height:30px; text-align:center; border: none !important; outline: none;" placeholder="원하시는 상품을 검색해 보세요!" onkeydown="searchEnter()">
				<img src="/images/ymro/dashboard/search_02.png" style="cursor:pointer;" onclick="searchBtn()"/>
				<hr width="850" style="border-bottom:0px; text-align: left; margin-left:20px; border: solid 2px #00a0c9;">
			</div>
		</div>
	</div>
	<div class="todo-window-container-header-title font-main-title" title="취급품목안내">
		<div class="todo-window-container-header-bullet"></div><span class="todo-window-container-header-text">취급품목안내</span>
		<div id="t" style="width: 100%; margin-left:20px;" class="todo-padding">
			<div id="tb" style="width: 100%;">
				<table class="item_table">
					<c:forEach var="list" items="${ItemClsList}" varStatus="vs">

						<c:if test="${(list.ROWNUM-1) % 6 == 0}">
							<tr>
						</c:if>
						<td class="item_td" onMouseOver="this.className='itemtd-over'" onMouseOut="this.className='item_td'" onClick="litemCls_click('${list.ITEM_CLS1}','${list.ITEM_CLS_NM}')">
							<span lass="item_text" >${list.ITEM_CLS_NM}</span>
						</td>
						<c:if test="${(list.ROWNUM) % 6 == 0}">
							</tr>
						</c:if>
					</c:forEach>
				</table>
			</div>
		</div>
	</div>
	--%>
	<%--<div width="890">&nbsp;<br></div>--%>
	<%--
	<div class="todo-window-container-header-title font-main-title" title="관리현황" style="margin-top:10px; width: 100%;">
		<div class="todo-window-container-header-bullet"></div><span class="todo-window-container-header-text">관리현황 (${systemDateTime})</span>
		<div id="ta" style="width: 100%;">
			<table border="0" cellspacing="0" cellpadding="0" class="todo-padding" style="width:100%; max-width: 890px;">
				<tr height="62">
					<td width="20"></td>
					<td width="270" background="/images/ymro/dashboard/customer_01_w.png" onMouseOver="this.className='td-over1'" onMouseOut="this.className='td-out1'" style="cursor:pointer;" onClick="tab_click('BNM1_030')">
						<span class="textsA"> 신규요청 단가미결</span>
						<br>
						<span class="textsBB">  ${form.SUMMARY1}건</span>
					</td>
					<td width="20"></td>
					<td width="270" background="/images/ymro/dashboard/supplier_02_w.png" onMouseOver="this.className='td-overS2'" onMouseOut="this.className='td-outS2'" style="cursor:pointer;" onClick="tab_click('BOD1_050')">
						<span class="textsA"> 주문결재 중(최근1개월)</span>
						<br>
						<span class="textsBB">  ${form.SUMMARY2}건</span>
					</td>
					<td width="20"></td>
					<td width="270" background="/images/ymro/dashboard/customer_02_w.png" onMouseOver="this.className='td-over2'" onMouseOut="this.className='td-out2'" style="cursor:pointer;" onClick="tab_click('CWOR0010')">
						<span class="textsA"> 결재 미결(최근1개월)</span>
						<br>
						<span class="textsBB">  ${form.SUMMARY3}건</span>
					</td>
					<td width="20"></td>
				</tr>
				<tr height="10"><td colspan="6"></td></tr>
				<tr height="62">
					<td width="20"></td>
					<td width="270" background="/images/ymro/dashboard/supplier_04_w.png" onMouseOver="this.className='td-overS4'" onMouseOut="this.className='td-outS4'" style="cursor:pointer;" onClick="tab_click('BGA1_030')">
						<span class="textsA"> 입고 대행(최근1개월)</span>
						<br>
						<span class="textsBB">  ${form.SUMMARY4}건</span>
					</td>
					<td width="20"></td>
					<td width="270" background="/images/ymro/dashboard/supplier_03_w.png" onMouseOver="this.className='td-overS3'" onMouseOut="this.className='td-outS3'" style="cursor:pointer;" onClick="tab_click('BGA1_010')">
						<span class="textsA"> 입고처리 대상(최근2주)</span>
						<br>
						<span class="textsB">  ${form.SUMMARY5}건</span>
					</td>
					<td width="20"></td>
					<td width="270" background="/images/ymro/dashboard/customer_03_w.png" onMouseOver="this.className='td-over3'" onMouseOut="this.className='td-out3'" style="cursor:pointer;" onClick="tab_click('BGA1_040')">
						<span class="textsA"> 마감미결</span>
						<br>
						<span class="textsBB">  ${form.SUMMARY6}건</span>
					</td>
					<td width="20"></td>
				</tr>
			</table>
		</div>
	</div>
	--%>
	<%--<div class="todo-window-container-header-title font-main-title" title="신규상품 요청현황" style="margin-top:10px">
		<div class="todo-window-container-header-bullet"></div><span class="todo-window-container-header-text">신규상품 요청현황</span>
		<div id="t1" style="width: 100%; margin-left: 20px;" class="todo-padding">
			<div id="t1b" style="width: 100%; max-width: 850px;">
				<e:gridPanel id="newgrid" name="newgrid" width="100%" height="57px" gridType="${_gridType}" readOnly="${param.detailView}"/>
			</div>
		</div>
	</div>--%>

	<%--<c:if test="${ses.buyerBudgetUseFlag == '1'}">
		<div class="todo-window-container-header-title font-main-title" title="예산조회" style="margin-top:10px">
			<div class="todo-window-container-header-bullet"></div><span class="todo-window-container-header-text">예산조회(예산 사용부서에 한함)</span>
			<div id="t2" style="width: 100%; margin-left: 20px;" class="todo-padding">
				<div id="t2b" style="width:100%; max-width: 850px;">
					<e:gridPanel gridType="${_gridType}" id="bggrid" name="bggrid" width="100%" height="120px" readOnly="${param.detailView}"/>
				</div>
			</div>
		</div>
	</c:if>

	<div class="todo-window-container-header-title font-main-title" title="공지사항" style="margin-top:10px">
		<div class="todo-window-container-header-bullet"></div><span class="todo-window-container-header-text">공지사항</span>
		<div id="t3" style="width: 100%; margin-left: 20px;" class="todo-padding">
			<div id="t3b" style="width: 100%; max-width: 850px;">
				<e:gridPanel gridType="${_gridType}" id="notice" name="notice" width="100%" height="136px" readOnly="${param.detailView}"/>
			</div>
		</div>
	</div>

    <div class="todo-window-container-header-title font-main-title" title="나의관심품목" style="margin-top:10px">
        <div class="todo-window-container-header-bullet"></div><span class="todo-window-container-header-text">나의관심품목</span>
        <div id="t4" style="width: 100%; margin-left: 20px; padding: 10px 0 0 0;" >
            <div id="t4b" style="width: 100%; max-width: 850px;">
                <e:gridPanel gridType="${_gridType}" id="mygrid" name="mygrid" width="100%" height="181px" readOnly="${param.detailView}"/>
            </div>
        </div>
    </div>
    --%>

</e:window>
</e:ui>