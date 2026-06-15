<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">

	<style type="text/css">

		.todo {
			width: 225px;
			height: 225px;
			border: 1px solid #fff;
			float: left;
			margin: 4px;
		}

		.todo:first-child {
			left-margin: 0;
		}

		.todo:last-child {
			right-margin: 0;
		}

		.loading {
			background: url(/images/icon/loader-indicator6.gif) center center no-repeat #fff;
		}

		.todo table tr td {
			background-color: #fff;
			border-right: 0 solid #ccc;
			border-bottom: 0 solid #ccc;
			box-sizing: border-box;
			font-weight:bold;
			font-size: 12px;
		}

		.todo table tr td:first-child {
			text-align: left;
			padding-left: 4px;
		}

		.todo table tr td:last-child {
			text-align: right;
			font-weight: bold;
			padding-right: 8px;
			user-select: none;
			cursor: pointer;
		}

		.todo table tr td:last-child:hover {
			color: blue;
		}

		.todo table tr th {
			background-color: #ddd;
			border-right: 0 solid #ccc;
			border-bottom: 0 solid #ccc;
			text-align: center;
			font-weight: bold;
			font-size: 14px;
			user-select: none;
			position: relative;
			height: 31px;
		}

		.todo table tr th a {
			color: #000;
		}

		.todo table tr th div {
			background-color: green;
			border-radius: 15px;
			color: #fff;
			font-size: 10px;
			height: 16px;
			line-height: 16px;
			padding: 0 5px;
			position: absolute;
			right: 6px;
			top: 8px;
		}

		.todo table {
			background-color: #ccc;
			border: 0px solid #ccc;
			border-bottom: 2px solid #ccc;
			border-collapse: separate;
			border-spacing: 1px;
			display: none;
			table-layout: fixed;;
			height: 100%;
			width: 100%;
		}

		.textsA {
			font-size: 14px;
			color : #606060;
			margin-left : 65px;
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
			line-height : 20px;
		}
		.td-out1 {background-image:url("/images/ymro/dashboard/operation_01_w.png")}
		.td-over1 {background-image:url("/images/ymro/dashboard/operation_01_b.png")}

		.td-out2 {background-image:url("/images/ymro/dashboard/operation_02_w.png")}
		.td-over2 {background-image:url("/images/ymro/dashboard/operation_02_b.png")}

		.td-out3 {background-image:url("/images/ymro/dashboard/operation_03_w.png")}
		.td-over3 {background-image:url("/images/ymro/dashboard/operation_03_b.png")}

		.td-out4 {background-image:url("/images/ymro/dashboard/operation_04_w.png")}
		.td-over4 {background-image:url("/images/ymro/dashboard/operation_04_b.png")}

		.td-out5 {background-image:url("/images/ymro/dashboard/operation_05_w.png")}
		.td-over5 {background-image:url("/images/ymro/dashboard/operation_05_b.png")}

		/* TO-DO List Style */
		.todo-label-wrapper {
			background-color: #eee;
			color: #333;
			overflow: hidden;
			position: relative;
			vertical-align: top;
			min-height: 28px;
			font-weight: normal;
			font-size: 12px;
			text-align: center;
			border: 1px solid #aaa;
		}

		.todo-label-wrapper-sub {
			background-color: #eee;
			color: #333;
			overflow: hidden;
			position: relative;
			vertical-align: top;
			min-height: 28px;
			font-weight: normal;
			font-size: 12px;
			text-align: center;
			border-right: 1px solid #aaa;
			border-bottom: 1px solid #aaa;
		}

		.todo-label {
			background-color: #eee;
			color: #222;
			position: relative;
			top: 3px;
			line-height: 22px;
			font-weight: bold;
		}

		.todo-field-wrapper {
			background-color: #fff;
			padding: 2px;
			overflow: visible;
			vertical-align: top;
			border-left: 1px solid #aaa;
			border-bottom: 1px solid #aaa;
		}

		.todo-field-wrapper-sub {
			background-color: #fff;
			padding: 2px;
			overflow: visible;
			vertical-align: top;
			border-right: 1px solid #aaa;
			border-bottom: 1px solid #aaa;
		}

		.todo-field-wrapper-side {
			background-color: #fff;
			padding: 2px;
			overflow: visible;
			vertical-align: top;
			border-bottom: 1px solid #aaa;
		}

		.todo-field-wrapper-right {
			background-color: #fff;
			padding: 2px;
			overflow: visible;
			vertical-align: top;
			border-right: 1px solid #aaa;
		}

		.todo-field-div-wrapper {
			white-space: nowrap;
			padding: 0;
			margin: 0;
			height: 100%;
		}

		.todo-position-l {
			float: left;
		}

		.todo-position-r {
			float: right;
		}

		.todo-window-container-header-title {
			color: #222;
			float: left;
			position: relative;
			text-decoration: none;
			display: inline;
			padding-bottom: 10px;
		}

		.todo-window-container-header-text {
			margin-left: 6px;
			position: relative;
		}

		.todo-padding {
			padding-top: 10px;
		}

		.todo-padding-tab {
			padding: 5px 0 0 0;
		}

		/* 하단 bottom-panel 영역 삭제 */
		.todo-realgridpanel-wrapper {
			border-top: 2px solid #027bc2;
			margin-top: 2px;
			margin-bottom: 0 !important;
			clear: both;
		}

		.e-window-container-body {
			/*padding: 10px 0 0 10px;*/
		}

	</style>
	<script>
        var baseUrl = "/eversrm/";
		var grid1, grid2, grid3, grid4, grid5, notice, faq;
        var val = {"visible": true, "count": 1, "height": 30};
        var footer = {
            "styles": {
                "textAlignment": "cetner",
                "font": "Nanum Gothic,14"
            },
            "text": ["합 계"]
        };

        var footer1 = {
            "styles": {
                "textAlignment": "far",
                "numberFormat": "#,##0",
                "suffix": " 원 ",
                "font": "Nanum Gothic,14"
            },
            "text": "",
            "expression": "sum['CPO_ITEM_AMT_H']",
            "groupExpression": "sum"
        };

        function getContentTab(uu) {
            if (uu == '1') {
                window.scrollbars = true;
            }
/*             if (uu == '2') {
                window.scrollbars = true;
            } */
            if (uu == '3') {
                window.scrollbars = true;
            }
        }
        function init() {

            // bottom-panel 삭제
            // $('.e-realgridpanel-wrapper').attr('class', 'todo-realgridpanel-wrapper');
			// $('.e-realgridpanel-bottom-panel').remove();

            for(var i = 1; i < 6; i++) {
                EVF.C('grid' + i)._getFooterBoxEl().remove();
                EVF.C('grid' + i).getBoxEl().attr('class', 'todo-realgridpanel-wrapper');
			}

            notice = EVF.C('notice');
            faq = EVF.C('faq');
            grid1 = EVF.C('grid1');
            grid2 = EVF.C('grid2');
            grid3 = EVF.C('grid3');
            grid4 = EVF.C('grid4');
            grid5 = EVF.C('grid5');

            notice.setProperty('multiselect', false);
            notice.setProperty('shrinkToFit', true);
            notice.setHeaderStyle('fontSize', '14');
            notice._gvo.setStyles({indicator: {fontSize: '14'}});
            notice.cellClickEvent(function (rowIdx, colIdx, value, iRow, iCol) {
                var msg;
                if (colIdx == 'SUBJECT') {
                    var param = {
                        NOTICE_NUM: notice.getCellValue(rowIdx, 'NOTICE_NUM'),
                        detailView: true
                    };
                    everPopup.openPopupByScreenId('OETR0021', 950, 730, param);
                }
            });

            faq.setProperty('multiselect', false);
            faq.setProperty('shrinkToFit', true);
            faq.setHeaderStyle('fontSize', '14');
            faq._gvo.setStyles({indicator: {fontSize: '14'}});
            faq.cellClickEvent(function (rowIdx, colIdx, value, iRow, iCol) {
                if (colIdx == 'SUBJECT') {
                    var param = {
                        NOTICE_NUM: faq.getCellValue(rowIdx, 'NOTICE_NUM'),
                        detailView: true
                    };
                    everPopup.openPopupByScreenId('OETR0031', 950, 730, param);
                }
            });

            /////////////////////////// grid1 Set ///////////////////////////
            grid1.setProperty('multiSelect', false);
            grid1.setProperty('shrinkToFit', true);
            grid1.setProperty('footerVisible', val);

            grid1._gvo.setIndicator({ visible: false });
            // grid1._gvo.setHeader({height: 21});
            grid1.setColGroup([
                {
                    "groupName": '${mypageBuyer_GRID1_HEADER}',
                    "columns": ['CUST_NM', 'CPO_ITEM_AMT']
                }
            ]);

            grid1._gvo.setColumnProperty('${mypageBuyer_GRID1_HEADER}', "header", {styles: {fontSize: 14}});

            var colName1 = grid1._gvo.columnByName('${mypageBuyer_GRID1_HEADER}');
			var hide1 = !grid1._gvo.getColumnProperty(colName1, "hideChildHeaders");
            grid1._gvo.setColumnProperty(colName1, "hideChildHeaders", hide1);

            /////////////////////////// grid2 Set ///////////////////////////
            grid2.setProperty('multiSelect', false);
            grid2.setProperty('shrinkToFit', true);
            grid2.setProperty('footerVisible', val);

            grid2._gvo.setIndicator({ visible: false });
            // grid2._gvo.setHeader({height: 21});
            // grid2.setHeaderStyle('fontSize', '14');

            grid2.setColGroup([
                {
                    "groupName": '${mypageBuyer_GRID2_HEADER}',
                    "columns": ['CUST_NM', 'CPO_ITEM_AMT']
                }
            ]);

            grid2._gvo.setColumnProperty('${mypageBuyer_GRID2_HEADER}', "header", {styles: {fontSize: 14}});

            var colName2 = grid2._gvo.columnByName('${mypageBuyer_GRID2_HEADER}');
            var hide2 = !grid2._gvo.getColumnProperty(colName2, "hideChildHeaders");
            grid2._gvo.setColumnProperty(colName2, "hideChildHeaders", hide2);

            /////////////////////////// grid3 Set ///////////////////////////
            grid3.setProperty('multiSelect', false);
            grid3.setProperty('shrinkToFit', true);
            grid3._gvo.setIndicator({ visible: false });
            grid3._gvo.setHeader({visible: false});

            /////////////////////////// grid4 Set ///////////////////////////
            grid4.setProperty('multiSelect', false);
            grid4.setProperty('shrinkToFit', true);

            grid4._gvo.setIndicator({ visible: false });
            // grid4._gvo.setHeader({height: 21});
            grid4.setHeaderStyle('fontSize', '14');

            grid4.cellClickEvent(function (rowIdx, colIdx, value, iRow, iCol) {
                var param = {
                    'autoSearchFlag': "Y",
                    'yesterday': "${yesterday}",
                    'detailView': false
                };
                var el = parent.parent.document.getElementById('mainIframe');
                el.contentWindow.pageRedirectByScreenId("OD01_010", param);
            });

            /////////////////////////// grid5 Set ///////////////////////////
            grid5.setProperty('multiSelect', false);
            grid5.setProperty('shrinkToFit', true);

            grid5._gvo.setIndicator({ visible: false });
            // grid5._gvo.setHeader({height: 21});
            grid5.setHeaderStyle('fontSize', '14');

            grid5.cellClickEvent(function (rowIdx, colIdx, value, iRow, iCol) {
                var param;
                if(colIdx == 'CLAME_CNT') {
                    param = {
                        MOVE_LINK_YN: "Y",
                        PROGRESS_CD: ""
                    };

				}

                if(colIdx == 'CLAME_PRO') {
                    param = {
                        MOVE_LINK_YN: "Y",
                        PROGRESS_CD: "400"
                    };
                }

                var el = parent.parent.document.getElementById('mainIframe');
                el.contentWindow.pageRedirectByScreenId("BS99_020", param);
            });

//            for (var i = 1; i <= 8; i++) {
//                var to = document.getElementById("todo"+i);
//                to.classList.add("loading");
//                store.load(baseUrl+"getTodo"+i+".so", function() {
//                    var division = this.getParameter('division');
//                    $("#todo"+division).append($(this.getParameter("todo"+division+"Html"))).removeClass('loading');
//                    $("#todo"+division+" table").fadeIn('slow');
//                }, false);
//            }
//            $("#todoContainer").delegate(".todo table tr td:last-child", "click", function() {
//
//                var $this = $(this);
//                var id = $this.prop("id");
//                var moduleType = id.substring(0, 2);
//                if(top) {
//
//					top.$(".e-topmenu-wrapper").removeClass("e-topmenu-selected");
//                    top.$("#"+moduleType).addClass("e-topmenu-selected");
//                    top.EVF.C("leftMenuTree").setProperty("expandAllNode", true);
//                    top.EVF.C("leftMenuTree").loadTreeForModuleType(moduleType).then(function() {
//
//                        var menuName = $this.siblings("td").text();
//						top.$("#leftMenuTree .e-treepanel-contents").find("div[title=\""+menuName+"\"]").trigger("click");
//
//					}, function() {
//
//					});
//				}
//			});

            var store = new EVF.Store();
            store.setGrid([notice]);
            store.load(baseUrl + "doNotice.so", function () {

                for(var i = 0; i < notice.getRowCount(); i++) {
                    // notice.setRowHeight(i, 32);
                    notice.setRowFontSize(i, '14');
				}

                notice.setRowHeightAll(32);

            }, false);

            var store = new EVF.Store();
            store.setGrid([faq]);
            store.load(baseUrl + "doFaq.so", function () {

                for(var i = 0; i < faq.getRowCount(); i++) {
                    // faq.setRowHeight(i, 32);
                    faq.setRowFontSize(i, '14');
                }

	            notice.setRowHeightAll(32);

            }, false);

            var store = new EVF.Store();
			store.setGrid([grid1, grid2, grid3, grid4, grid5]);
			store.load(baseUrl + "opGrids.so", function () {

				if(grid1.getRowCount() > 0) {
					for (var i = 0; i < 4; i++) {
						if (grid1.getRowCount() < (i + 1)) {
							grid1.addRow();
						}
						grid1.addRow();
						grid1.setRowHeight(i, 30);
						grid1.setRowFontSize(i, '14');
					}
				} else {
					for (var i = 0; i < 4; i++) {
						grid1.addRow();
						grid1.setRowHeight(i, 30);
						grid1.setRowFontSize(i, '14');
					}
					footer1["text"] = "0";
				}
				grid1._gvo.resetCurrent();
                grid1.setRowFooter("CUST_NM", footer);
                grid1.setRowFooter("CPO_ITEM_AMT", footer1);

				if(grid2.getRowCount() > 0) {
					for (var i = 0; i < 4; i++) {
						if (grid2.getRowCount() < (i + 1)) {
							grid2.addRow();
						}
						grid2.setRowHeight(i, 30);
						grid2.setRowFontSize(i, '14');
					}
				} else {
					for (var i = 0; i < 4; i++) {
						grid2.addRow();
						grid2.setRowHeight(i, 30);
						grid2.setRowFontSize(i, '14');
					}
				}
				grid2._gvo.resetCurrent();
                grid2.setRowFooter("CUST_NM", footer);
                grid2.setRowFooter("CPO_ITEM_AMT", footer1);

				if(grid3.getRowCount() > 0) {
					for(var i = 0; i < grid3.getRowCount(); i++) {
						grid3.setRowHeight(i, 45);
						grid3.setRowFontSize(i, '14');
					}
				}

                if(grid4.getRowCount() == 0) {
                    grid4.addRow();
                }
                grid4.setRowHeight(0, 30);
                grid4.setRowFontSize(0, '14');

                if(grid5.getRowCount() == 0) {
                    grid5.addRow();
                }
                grid5.setRowHeight(0, 30);
                grid5.setRowFontSize(0, '14');
			}, false);

            onActive();
        }

        <%--$(document.body).ready(function () {--%>
            <%--$('#e-tabs').height(($('.ui-layout-center').height() - 30)).tabs({--%>
                <%--activate: function (event, ui) {--%>
                    <%--&lt;%&ndash; 이 부분을 해줘야 탭을 변경했을 때 그리드가 제대로 display 된다. &ndash;%&gt;--%>
                    <%--$(window).trigger('resize');--%>
                <%--}--%>
            <%--});--%>
            <%--$('#e-tabs').tabs('option', 'active', 0);--%>
            <%--getContentTab('1');--%>

        <%--});--%>

        function tab_click(screenId, e) {

            var param = {
                'autoSearchFlag': "Y",
                'detailView': false
            };

            if(screenId == 'IM01_040' || screenId == 'OD01_010A' || screenId == 'OD01_010B') {
                var text = $(e).find('.textsA').text().trim();
                if(text == '계약만료예정') {
					param['CONT_STATUS'] = '1';
				} else if(text == '계약만료') {
                    param['CONT_STATUS'] = '0';
				} else if(text == '납품거부') {
                    param['DELY_REJECT_CD'] = '1';
				} else if(text == '매입단가변경') {
                    param['CONT_STATUS'] = 'A';
				} else if(text == '판매단가변경') {
                    param['CONT_STATUS'] = 'A';
				}
                if(screenId.indexOf('OD01_010') > -1) {
                    param['callType'] = everString.replaceAll(screenId, "OD01_010", "");
                    screenId = "OD01_010";
                }
			}

            var el = parent.parent.document.getElementById('mainIframe');
            el.contentWindow.pageRedirectByScreenId(screenId, param);
        }

        function onActive(e) {
			$(window).trigger('resize');
        	/*if(e == "3") {
				notice.resize();
			} else if(e == "1") {
				faq.resize();
			}*/
		}

	</script>

	<%--운영사메인--%>
	<e:window id="mypageBuyer" onReady="init" initData="${initData}" title="">
		<div class="todo-window-container-header-title font-main-title" title="소싱업무현황">
			<div class="e-window-container-header-bullet"></div><span class="todo-window-container-header-text">소싱업무현황 (${systemDateTime})</span>
			<table width="100%" border="0" cellspacing="0" cellpadding="0" class="todo-padding">
				<tr height="62">
					<td width="20"></td>
					<td width="180" background="/images/ymro/dashboard/operation_01_w.png" onMouseOver="this.className='td-over1'" onMouseOut="this.className='td-out1'" style="cursor:pointer;" onClick="tab_click('RQ01_010')">
						<span class="textsA"> 단가미결</span>
						<br>
						<span class="textsB">  ${form.summary1}건</span>
					</td>
					<td width="20"></td>
					<td width="180" background="/images/ymro/dashboard/operation_01_w.png" onMouseOver="this.className='td-over1'" onMouseOut="this.className='td-out1'" style="cursor:pointer;" onClick="tab_click('IM01_040', this)">
						<span class="textsA"> 매입단가변경</span>
						<br>
						<span class="textsBB">  ${form.summary2}건</span>
					</td>
					<td width="20"></td>
					<td width="180" background="/images/ymro/dashboard/operation_02_w.png" onMouseOver="this.className='td-over2'" onMouseOut="this.className='td-out2'" style="cursor:pointer;" onClick="tab_click('IM01_040', this)">
						<span class="textsA"> 계약만료예정</span>
						<br>
						<span class="textsBB">  ${form.summary3}건</span>
					</td>
					<td width="20"></td>
					<td width="180" background="/images/ymro/dashboard/operation_02_w.png" onMouseOver="this.className='td-over2'" onMouseOut="this.className='td-out2'" style="cursor:pointer;" onClick="tab_click('IM01_040', this)">
						<span class="textsA"> 계약만료</span>
						<br>
						<span class="textsBB">  ${form.summary4}건</span>
					</td>
					<td width="20"></td>
					<td width="180" background="/images/ymro/dashboard/operation_03_w.png" onMouseOver="this.className='td-over3'" onMouseOut="this.className='td-out3'" style="cursor:pointer;" onClick="tab_click('OD03_010')">
						<span class="textsA"> 미입고현황</span>
						<br>
						<span class="textsBB">  ${form.summary5}건</span>
					</td>
					<td width="20"></td>
				</tr>
				<tr height="10">
					<td width="20"></td>
					<td width="180"></td>
					<td width="20"></td>
					<td width="180"></td>
					<td width="20"></td>
					<td width="180"></td>
					<td width="20"></td>
					<td width="180"></td>
					<td width="20"></td>
					<td width="180"></td>
					<td width="20"></td>
				</tr>
				<tr height="62">

					<td width="20"></td>
					<td width="180" background="/images/ymro/dashboard/operation_04_w.png" onMouseOver="this.className='td-over4'" onMouseOut="this.className='td-out4'" style="cursor:pointer;" onClick="tab_click('OD01_010A', this)">
						<span class="textsA"> 표준납기지연</span>
						<br>
						<span class="textsB">  ${form.summary6}건</span>
					</td>
					<td width="20"></td>
					<td width="180" background="/images/ymro/dashboard/operation_04_w.png" onMouseOver="this.className='td-over4'" onMouseOut="this.className='td-out4'" style="cursor:pointer;" onClick="tab_click('OD01_010B', this)">
						<span class="textsA"> 납품거부</span>
						<br>
						<span class="textsBB">  ${form.summary7}건</span>
					</td>
					<td width="20"></td>
					<td width="180" background="/images/ymro/dashboard/operation_01_w.png" onMouseOver="this.className='td-over1'" onMouseOut="this.className='td-out1'" style="cursor:pointer;" onClick="tab_click('IM02_010')">
						<span class="textsA"> 판매단가변경</span>
						<br>
						<span class="textsBB">  ${form.summary8}건</span>
					</td>
					<td width="20"></td>
					<td width="180" background="/images/ymro/dashboard/operation_05_w.png" onMouseOver="this.className='td-over5'" onMouseOut="this.className='td-out5'" style="cursor:pointer;" onClick="tab_click('MY02_001')">
						<span class="textsA"> 결재미결</span>
						<br>
						<span class="textsB">  ${form.summary9}건</span>
					</td>
					<td width="20"></td>
					<td width="180" background="/images/ymro/dashboard/operation_03_w.png" onMouseOver="this.className='td-over3'" onMouseOut="this.className='td-out3'" style="cursor:pointer;" onClick="tab_click('OD02_020')">
						<span class="textsA"> 입고지연관리</span>
						<br>
						<span class="textsB">  ${form.summary10}건</span>
					</td>
					<td width="20"></td>
				</tr>
			</table>
		</div>
		<br>

		<div class="todo-window-container-header-title font-main-title" title="매출현황" style="width: 100%;">
			<div class="e-window-container-header-bullet"></div><span class="todo-window-container-header-text">주요 고객사 매출현황 (당월 일자 기준)</span>
			<div class="e-searchpanel" style="width: 100%; display: -webkit-box; display: -ms-flexbox; display: flex;">
				<div style="width: 350px; padding: 10px 0 0 20px;">
					<e:gridPanel id="grid1" name="grid1" width="100%" height="183" gridType="${_gridType}" readOnly="${param.detailView}"/>
					<%--<table width="100%" border="0" cellspacing="0" cellpadding="0" >
						<tr height="32">
							<td width="100" colspan="3" class="todo-label-wrapper"><label class="todo-label" title="전월 매출">그룹사(높은순서)</label><div class="e-required-badge"></div></td>
						</tr>
						<tr>
							<td colspan="2" class="todo-field-wrapper">
								<div class="e-component e-text-container todo-position-l">DA인포메이션</div>
							</td>
							<td class="todo-field-wrapper-sub">
								<div class="e-component e-text-container todo-position-r">
									<div class="e-text font-component"> 1000000 원</div>
								</div>
							</td>
						</tr>
						<tr>
							<td colspan="2" class="todo-field-wrapper">
								<div class="todo-field-div-wrapper">
									<div class="e-component e-text-container todo-position-l">DA인포메이션</div>
								</div>
							</td>
							<td class="todo-field-wrapper-sub">
								<div class="todo-field-div-wrapper">
									<div class="e-component e-text-container todo-position-r">
										<div class="e-text font-component"> 원</div>
									</div>
								</div>
							</td>
						</tr>
					</table>--%>
				</div>
				<div style="width: 350px; padding: 10px 0 0 20px;">
					<e:gridPanel id="grid2" name="grid2" width="100%" height="183" gridType="${_gridType}" readOnly="${param.detailView}"/>
					<%--<table width="100%" border="0" cellspacing="0" cellpadding="0" >
						<tr height="32">
							<td colspan="3" class="todo-label-wrapper"><label class="todo-label" title="전월 매출">비룹사(높은순서)</label><div class="e-required-badge"></div></td>
						</tr>
						<tr>
							<td colspan="2" class="todo-field-wrapper">
								<div class="e-component e-text-container todo-position-l">DA인포메이션</div>
							</td>
							<td class="todo-field-wrapper-sub">
								<div class="e-component e-text-container todo-position-r">
									<div class="e-text font-component"> 1000000 원</div>
								</div>
							</td>
						</tr>
						<tr>
							<td colspan="2" class="todo-field-wrapper">
								<div class="todo-field-div-wrapper">
									<div class="e-component e-text-container todo-position-l">DA인포메이션</div>
								</div>
							</td>
							<td class="todo-field-wrapper-sub">
								<div class="todo-field-div-wrapper">
									<div class="e-component e-text-container todo-position-r">
										<div class="e-text font-component"> 원</div>
									</div>
								</div>
							</td>
						</tr>
					</table>--%>
				</div>
				<div style="width: 300px; padding: 10px 0 0 20px;">
					<e:gridPanel id="grid3" name="grid3" width="100%" height="181" gridType="${_gridType}" readOnly="${param.detailView}"/>
					<%--<table width="100%" border="0" cellspacing="0" cellpadding="0" style="border: 1px solid #aaa">
						<tr height="32">
							<td style="width: 100px;" class="todo-label-wrapper-sub"><label class="todo-label" title="전월 매출">매출총액</label><div class="e-required-badge"></div></td>
							<td style="width: 200px;" class="todo-field-wrapper-side">
								<div class="e-component e-text-container todo-position-r">
									<div class="e-text font-component"> 원</div>
								</div>
							</td>
						</tr>
						<tr>
							<td class="todo-label-wrapper-sub"><label class="todo-label" title="전월 매출">매입총액</label><div class="e-required-badge"></div></td>
							<td class="todo-field-wrapper-side">
								<div class="e-component e-text-container todo-position-r">
									<div class="e-text font-component"> 원</div>
								</div>
							</td>
						</tr>
						<tr>
							<td class="todo-label-wrapper-sub"><label class="todo-label" title="전월 매출">이익총액</label><div class="e-required-badge"></div></td>
							<td class="todo-field-wrapper-side">
								<div class="e-component e-text-container todo-position-r">
									<div class="e-text font-component"> 원</div>
								</div>
							</td>
						</tr>
						<tr>
							<td class="todo-label-wrapper-sub" style="border-bottom: none;"><label class="todo-label" title="전월 매출">마진율</label><div class="e-required-badge"></div></td>
							<td class="todo-field-wrapper-side" style="border-bottom: none;">
								<div class="e-component e-text-container todo-position-r">
									<div class="e-text font-component"> 원</div>
								</div>
							</td>
						</tr>
					</table>--%>
				</div>
			</div>
		</div>
		<div class="todo-window-container-header-title font-main-title" title="관리현황" style="width: 100%;">
			<div class="e-window-container-header-bullet"></div><span class="todo-window-container-header-text">관리현황</span>
			<div class="e-searchpanel" style="width: 100%; display: flex;">
				<div style="width: 350px; padding: 6px 0 0 20px;">
					<div>
						<span style="width: 10px; font-size: 10px; vertical-align: bottom; color: #999;">></span>
						<span style="color: #999; font-size: 14px;">전일기준</span>
					</div>
					<e:gridPanel id="grid4" name="grid4" width="100%" height="58" gridType="${_gridType}" readOnly="${param.detailView}"/>
					<%--<table width="100%" border="0" cellspacing="0" cellpadding="0" style="border: 1px solid #aaa;">
						<tr height="32">
							<td class="todo-label-wrapper-sub"><label class="todo-label" title="주문건수">주문건수</label><div class="e-required-badge"></div></td>
							<td class="todo-label-wrapper-sub"><label class="todo-label" title="주문금액">주문금액</label><div class="e-required-badge"></div></td>
							<td class="todo-label-wrapper-sub"><label class="todo-label" title="기준가총액">기준가총액</label><div class="e-required-badge"></div></td>
							<td class="todo-label-wrapper-sub" style="border-right: none;"><label class="todo-label" title="절감율">절감율</label><div class="e-required-badge"></div></td>
						</tr>
						<tr>
							<td class="todo-field-wrapper-right">
								<div class="e-component e-text-container todo-position-r">
									<div class="e-text font-component"> 1000000 원</div>
								</div>
							</td>
							<td class="todo-field-wrapper-right">
								<div class="e-component e-text-container todo-position-r">
									<div class="e-text font-component"> 1000000 원</div>
								</div>
							</td>
							<td class="todo-field-wrapper-right">
								<div class="e-component e-text-container todo-position-r">
									<div class="e-text font-component"> 1000000 원</div>
								</div>
							</td>
							<td class="todo-field-wrapper-right"  style="width: 60px; border-right: none;">
								<div class="e-component e-text-container todo-position-r">
									<div class="e-text font-component"> 100 %</div>
								</div>
							</td>
						</tr>
					</table>--%>
				</div>
				<div style="width: 350px; padding: 6px 0 0 20px;">
					<div>
						<span style="width: 10px; font-size: 10px; vertical-align: bottom; color: #999;">></span>
						<span style="color: #999; font-size: 14px;">클래임</span>
					</div>
					<e:gridPanel id="grid5" name="grid5" width="100%" height="58" gridType="${_gridType}" readOnly="${param.detailView}"/>
					<%--<table width="100%" border="0" cellspacing="0" cellpadding="0" style="border: 1px solid #aaa;">
						<tr height="32">
							<td class="todo-label-wrapper-sub"><label class="todo-label" title="전월 매출">클래임 접수</label><div class="e-required-badge"></div></td>
							<td class="todo-label-wrapper-sub" style="border-right: none;"><label class="todo-label" title="전월 매출">클래임 처리</label><div class="e-required-badge"></div></td>
						</tr>
						<tr>
							<td class="todo-field-wrapper-right">
								<div class="e-component e-text-container todo-position-r">
									<div class="e-text font-component"> 건</div>
								</div>
							</td>
							<td class="todo-field-wrapper-right" style="border-right: none;">
								<div class="e-component e-text-container todo-position-r">
									<div class="e-text font-component"> 건</div>
								</div>
							</td>
						</tr>
					</table>--%>
				</div>
			</div>
		</div>
		<br><br>

		<div class="todo-window-container-header-title font-main-title" style="padding: 0; width: 100%;" title="게시판">
			<div class="e-window-container-header-bullet"></div><span class="todo-window-container-header-text">게시판</span>
			<div id="t1" style="width: 100%;" class="todo-padding-tab">
				<div id="t1b" style="width: 100%; margin-left: 20px; max-width: 980px;">
					<e:tabPanel id="boards" onActive="onActive">
						<e:tab id="3" title="공지사항">
							<e:gridPanel gridType="${_gridType}" id="notice" name="notice" width="100%" height="fit" readOnly="${param.detailView}"/>
						</e:tab>
						<e:tab id="1" title="납품게시판">
							<e:gridPanel gridType="${_gridType}" id="faq" name="faq" width="100%" height="fit" readOnly="${param.detailView}"/>
						</e:tab>
					</e:tabPanel>
				</div>
			</div>
		</div>

		<%--<e:tabPanel id="boards" width="1020px">--%>
			<%--<e:tab id="3" title="공지사항">--%>
				<%--<e:gridPanel gridType="${_gridType}" id="notice" name="notice" width="1010px" height="fit" readOnly="${param.detailView}"/>--%>
			<%--</e:tab>--%>
			<%--<e:tab id="1" title="납품게시판">--%>
				<%--<e:gridPanel gridType="${_gridType}" id="faq" name="faq" width="1010px" height="fit" readOnly="${param.detailView}"/>--%>
			<%--</e:tab>--%>
		<%--</e:tabPanel>--%>
	</e:window>
</e:ui>