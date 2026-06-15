<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
	<script>

		var baseUrl = "/nhepro/CCUR/CCUR0040/";
		var gridMain;
		var gridQly;
		var gridQty;

		function init() {

			gridMain = EVF.C("gridMain");
			gridQly = EVF.C("gridQly");
			gridQty = EVF.C("gridQty");

			gridQly.addRowEvent(function () {
				var addParam = [
					{ "INSERT_FLAG" : 'I' }
				];
				gridQly.addRow(addParam);
			});

			gridQly.delRowEvent(function() {

				if (gridQly.getSelRowCount() == 0) { return alert("${msg.M0004}"); }

				var rowIds = gridQly.getSelRowId();
				for(var i in rowIds) {
					if(gridQly.getCellValue(rowIds[i], 'INSERT_FLAG') == "I") {
						gridQly.delRow();
					}
				}
			});

			gridQty.addRowEvent(function () {
				var addParam = [
					{ "INSERT_FLAG" : 'I' }
				];
				gridQty.addRow(addParam);
			});

			gridQty.delRowEvent(function() {

				if (gridQty.getSelRowCount() == 0) { return alert("${msg.M0004}"); }

				var rowIds = gridQty.getSelRowId();
				for(var i in rowIds) {
					if(gridQty.getCellValue(rowIds[i], 'INSERT_FLAG') == "I") {
						gridQty.delRow();
					}
				}
			});

			gridMain.cellClickEvent(function(rowIdx, colIdx, value, iRow, iCol, treeInfo) {

				if (colIdx == 'EV_ITEM_SUBJECT') {

					EVF.C('EV_ITEM_KIND_CD_RT').setValue(gridMain.getCellValue(rowIdx,'EV_ITEM_KIND_CD'), false);
					EVF.C('EV_ITEM_METHOD_CD_RT').setValue(gridMain.getCellValue(rowIdx,'EV_ITEM_METHOD_CD'));
					EVF.C('SCALE_TYPE_CD_RT').setValue(gridMain.getCellValue(rowIdx,'SCALE_TYPE_CD'));
					EVF.C('EV_ITEM_CONTENTS_RT').setValue(gridMain.getCellValue(rowIdx,'EV_ITEM_CONTENTS'));
					EVF.C('EV_ITEM_SUBJECT_RT').setValue(gridMain.getCellValue(rowIdx,'EV_ITEM_SUBJECT'));
					EVF.C('EV_ITEM_NUM').setValue(gridMain.getCellValue(rowIdx,'EV_ITEM_NUM'));
					EVF.C('QTY_ITEM_CD').setValue(gridMain.getCellValue(rowIdx,'QTY_ITEM_CD'));

					getEvItemTypeRValue2(gridMain.getCellValue(rowIdx,'EV_ITEM_KIND_CD'), gridMain.getCellValue(rowIdx,'EV_ITEM_TYPE_CD') );
					doSearchDetail(gridMain.getCellValue(rowIdx,'EV_ITEM_NUM'));

					if(gridMain.getCellValue(rowIdx,'EV_ITEM_METHOD_CD') == '') {
						$('#tab1').focus();
						var e = jQuery.Event( 'keydown', { keyCode: 13 } );
						$("#tab1").trigger(e);
						window.scrollbars = true;
						EVF.C('EV_ITEM_SUBJECT_RT').setReadOnly(true);
					}
					else if (gridMain.getCellValue(rowIdx,'EV_ITEM_METHOD_CD') == 'QUA') {
						$('#tab2').hide();
						$('#tab1').show();
						$('#tab1').focus();
						var e = jQuery.Event( 'keydown', { keyCode: 13 } );
						$("#tab1").trigger(e);
						window.scrollbars = true;
						EVF.C('EV_ITEM_SUBJECT_RT').setReadOnly(false);
					} else {
						$('#tab1').hide();
						$('#tab2').show();
						$('#tab2').focus();
						var e = jQuery.Event( 'keydown', { keyCode: 13 } );
						$("#tab2").trigger(e);
						window.scrollbars = true;
						EVF.C('EV_ITEM_SUBJECT_RT').setReadOnly(true);
					}
				}
			});

			// Grid Excel Export
			gridMain.excelExportEvent({
				allItems : "${excelExport.allCol}",
				fileName : "${screenName }"
			});

			// Grid Excel Export
			gridQly.excelExportEvent({
				allItems : "${excelExport.allCol}",
				fileName : "${screenName }"
			});

			// Grid Excel Export
			gridQty.excelExportEvent({
				allItems : "${excelExport.allCol}",
				fileName : "${screenName }"
			});

			gridMain.setProperty('shrinkToFit', ${shrinkToFit});		// 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
			gridMain.setProperty('rowNumbers', ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
			gridMain.setProperty('sortable', ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
			gridMain.setProperty('panelVisible', ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
			gridMain.setProperty('enterToNextRow', ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
			gridMain.setProperty('acceptZero', ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
			gridMain.setProperty('singleSelect', ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]
			gridMain.setProperty('multiSelect', true);					// [선택] 컬럼의 사용여부를 지정한다. [true/false]

			gridQly.setProperty('shrinkToFit', ${shrinkToFit});
			gridQly.setProperty('rowNumbers', ${rowNumbers});
			gridQly.setProperty('sortable', ${sortable});
			gridQly.setProperty('panelVisible', ${panelVisible});
			gridQly.setProperty('enterToNextRow', ${enterToNextRow});
			gridQly.setProperty('acceptZero', ${acceptZero});
			gridQly.setProperty('singleSelect', ${singleSelect});
			gridQly.setProperty('multiSelect', ${param.detailView == true ? false : multiSelect});

			gridQty.setProperty('shrinkToFit', ${shrinkToFit});
			gridQty.setProperty('rowNumbers', ${rowNumbers});
			gridQty.setProperty('sortable', ${sortable});
			gridQty.setProperty('panelVisible', ${panelVisible});
			gridQty.setProperty('enterToNextRow', ${enterToNextRow});
			gridQty.setProperty('acceptZero', ${acceptZero});
			gridQty.setProperty('singleSelect', ${singleSelect});
			gridQty.setProperty('multiSelect', ${param.detailView == true ? false : multiSelect});

			EVF.V("EV_ITEM_METHOD_CD", "QUA");
			EVF.V("EV_ITEM_METHOD_CD_RT", "QUA");
			chgMethod();
		}

		function doNew() {

			EVF.C('EV_ITEM_KIND_CD_RT').setValue('', false);
			EVF.C('EV_ITEM_METHOD_CD_RT').setValue('QUA');
			EVF.C('SCALE_TYPE_CD_RT').setValue('');
			EVF.C('EV_ITEM_CONTENTS_RT').setValue('');
			EVF.C('EV_ITEM_SUBJECT_RT').setValue('');
			EVF.C('EV_ITEM_NUM').setValue('');
			EVF.C('EV_ITEM_TYPE_CD_RT').setValue('');

			EVF.C('EV_ITEM_SUBJECT_RT').setReadOnly(false);

			gridQly.delAllRow();
			gridQty.delAllRow();
		}

		function chgMethod() {

			var method = EVF.C('EV_ITEM_METHOD_CD_RT').getValue();

			if(method == '') {
				$('#tab1').show();
				$('#tab2').show();
				$('#tab1').focus();
				var e = jQuery.Event( 'keydown', { keyCode: 13 } );
				$("#tab1").trigger(e);
				window.scrollbars = true;
				EVF.C('EV_ITEM_SUBJECT_RT').setReadOnly(true);
			}
			else if (method == 'QUA') {
				$('#tab2').hide();
				$('#tab1').show();
				$('#tab1').focus();
				var e = jQuery.Event( 'keydown', { keyCode: 13 } );
				$("#tab1").trigger(e);
				window.scrollbars = true;
				EVF.C('EV_ITEM_SUBJECT_RT').setReadOnly(false);
			} else {
				$('#tab1').hide();
				$('#tab2').show();
				$('#tab2').focus();
				var e = jQuery.Event( 'keydown', { keyCode: 13 } );
				$("#tab2").trigger(e);
				window.scrollbars = true;
				EVF.C('EV_ITEM_SUBJECT_RT').setValue('');
				EVF.C('EV_ITEM_SUBJECT_RT').setReadOnly(true);
			}
		}

		function getEvItemTypeRValue2(type,value) {

			var store = new EVF.Store;
			store.setParameter('EV_ITEM_KIND_CD', type);
			store.load(baseUrl + 'ccur0040_changeComboItemKindValue.so', function() {
				EVF.C('EV_ITEM_TYPE_CD_RT').setOptions(this.getParameter("itemTypeCode"));
				EVF.C('EV_ITEM_TYPE_CD_RT').setValue(value);
			});
		}

		function doSearchDetail(value) {

			var store = new EVF.Store();
			store.setParameter('EV_ITEM_NUM',value);
			store.setGrid([gridQly, gridQty]);
			store.load(baseUrl + "ccur0040_doSearchDetail.so", function() {

			});
		}

		function doSearch() {

			var store = new EVF.Store();
			store.setGrid([gridMain]);
			store.load(baseUrl + "ccur0040_doSearch.so", function() {
				if (gridMain.getRowCount() == 0) {
					EVF.alert("${msg.M0002 }");
				}
				doNew();
			});
		}

		function getEvItemType() {

			var store = new EVF.Store;
			store.load(baseUrl + '/ccur0040_changeComboItemKindL.so', function() {
				EVF.C('EV_ITEM_TYPE_CD').setOptions(this.getParameter("itemTypeCode"));
			}, false);
		}

		function getEvItemTypeR() {

			var store = new EVF.Store;
			store.load(baseUrl + '/ccur0040_changeComboItemKindR.so', function() {
				EVF.C('EV_ITEM_TYPE_CD_RT').setOptions(this.getParameter("itemTypeCode"));
			}, false);
		}

		function getContentTab(uu) {
			return;
			if (uu == '1') {
			}
			if (uu == '2') {
			}
		}

		$(document.body).ready(function() {
			$('#e-tabs').height( ($('.ui-layout-center').height()-30) ).tabs(
				{
					activate: function(event, ui) {
						<%-- 이 부분을 해줘야 탭을 변경했을 때 그리드가 제대로 display 된다. --%>
						$(window).trigger('resize');
					}
				}
			);
			$('#e-tabs').tabs('option', 'active', 0);
			$(window).trigger('resize');
		});

		function doDelete() {

			if (!gridMain.isExistsSelRow()) { return EVF.alert('${msg.M0004}'); }

			var store = new EVF.Store();
			EVF.confirm("${msg.M8888 }", function () {
				store.setGrid([gridMain]);
				store.getGridData(gridMain, 'sel');
				store.load(baseUrl + 'ccur0040_doDelete.so', function() {
					EVF.alert(this.getResponseMessage(), function() {
						doSearch();
					});
				});
			});
		}

		function doSave() {

			var store = new EVF.Store();
			if (!store.validate()) { return; }

			gridQly.checkAll(true);
			gridQty.checkAll(true);

			var method = EVF.C('EV_ITEM_METHOD_CD_RT').getValue();
			var scaleType = EVF.C('SCALE_TYPE_CD_RT').getValue();

			if (method == 'QUA') {
				if(!gridQly.validate().flag) { return EVF.alert(gridQly.validate().msg); }
			} else {
				if(EVF.isEmpty(EVF.V('EV_ITEM_SUBJECT_RT'))) {
					return EVF.alert("${CCUR0040_EV_ITEM_SUBJECT_RT}");
				}
				if(!gridQty.validate().flag) { return EVF.alert(gridQty.validate().msg); }
			}

			store.setGrid([ gridQly, gridQty ]);
			store.getGridData(gridQly, 'sel');
			store.getGridData(gridQty, 'sel');
			EVF.confirm("${msg.M8888 }", function () {
				store.load(baseUrl + 'ccur0040_doSave.so', function() {
					EVF.alert(this.getResponseMessage(), function() {
						doSearch();
					});
				});
			});
		}

		function doDeleteR() {

			var store = new EVF.Store();
			store.setGrid([ gridQly, gridQty ]);
			store.getGridData(gridQly, 'sel');
			store.getGridData(gridQty, 'sel');
			EVF.confirm("${msg.M0013 }", function () {
				store.load(baseUrl + 'ccur0040_doDeleteR.so', function() {
					EVF.alert(this.getResponseMessage(), function() {
						doSearch();
					});
				});
			});
		}

		function doSearchQtyItem() {

			var method = EVF.C('EV_ITEM_METHOD_CD_RT').getValue();

			if (method != 'QTY') {
				return EVF.alert('${CCUR0040_MSG_001}'); <%-- 정량평가인 경우에만 처리 가능합니다. --%>
			}

			var param = {
				  callBackFunction : 'doSetQtyItem'
				, title : '평가항목'
				, codeType : 'M207'
			};
			everPopup.openCommonPopup(param, 'SP0029');
		}

		function doSetQtyItem(data) {
			EVF.C("EV_ITEM_SUBJECT_RT").setValue(data.CODE_DESC);
			EVF.C("QTY_ITEM_CD").setValue(data.CODE);
		}

	</script>

	<e:window id="CCUR0040" onReady="init" initData="${initData}" title="${screenName}">
		<e:panel width="54%" height="100%">
			<e:searchPanel id="form" useTitleBar="false" title="${form_CAPTION_N}" labelWidth="${labelNarrowWidth}" labelAlign="${labelAlign}" columnCount="2" onEnter="doSearch">
				<e:row>
					<%-- 평가종류 --%>
					<e:label for="EV_ITEM_KIND_CD" title="${form_EV_ITEM_KIND_CD_N}"/>
					<e:field>
						<e:select id="EV_ITEM_KIND_CD" name="EV_ITEM_KIND_CD" value="${form.EV_ITEM_KIND_CD}" onChange="getEvItemType"  options="${evItemKindCdOptions }" width="100%" disabled="${form_EV_ITEM_KIND_CD_D}" readOnly="${form_EV_ITEM_KIND_CD_RO}" required="${form_EV_ITEM_KIND_CD_R}" placeHolder="" />
					</e:field>
					<%-- 평가구분 --%>
					<e:label for="EV_ITEM_TYPE_CD" title="${form_EV_ITEM_TYPE_CD_N}"/>
					<e:field>
						<e:select id="EV_ITEM_TYPE_CD" name="EV_ITEM_TYPE_CD" value="${form.EV_ITEM_TYPE_CD}" options="${evItemTypeCdOptions}" width="100%" disabled="${form_EV_ITEM_TYPE_CD_D}" readOnly="${form_EV_ITEM_TYPE_CD_RO}" required="${form_EV_ITEM_TYPE_CD_R}" placeHolder="" />
					</e:field>
				</e:row>
				<e:row>
					<%-- 평가방법 --%>
					<e:label for="EV_ITEM_METHOD_CD" title="${form_EV_ITEM_METHOD_CD_N}"/>
					<e:field>
						<e:select id="EV_ITEM_METHOD_CD" name="EV_ITEM_METHOD_CD" value="${form.EV_ITEM_METHOD_CD}" options="${evItemMethodCdOptions }" width="100%" disabled="${form_EV_ITEM_METHOD_CD_D}" readOnly="${form_EV_ITEM_METHOD_CD_RO}" required="${form_EV_ITEM_METHOD_CD_R}" placeHolder="" />
					</e:field>
					<%-- 평가항목 --%>
					<e:label for="EV_ITEM_SUBJECT" title="${form_EV_ITEM_SUBJECT_N}" />
					<e:field>
						<e:inputText id="EV_ITEM_SUBJECT" style="ime-mode:auto" name="EV_ITEM_SUBJECT" value="${form.EV_ITEM_SUBJECT}" width="100%" maxLength="${form_EV_ITEM_SUBJECT_M}" disabled="${form_EV_ITEM_SUBJECT_D}" readOnly="${form_EV_ITEM_SUBJECT_RO}" required="${form_EV_ITEM_SUBJECT_R}"/>
					</e:field>
				</e:row>
				<e:row>
					<%-- 평가내용 --%>
					<e:label for="EV_ITEM_CONTENTS" title="${form_EV_ITEM_CONTENTS_N}" />
					<e:field colSpan="3">
						<e:inputText id="EV_ITEM_CONTENTS" style="${imeMode}" name="EV_ITEM_CONTENTS" value="${form.EV_ITEM_CONTENTS}" width="100%" maxLength="${form_EV_ITEM_CONTENTS_M}" disabled="${form_EV_ITEM_CONTENTS_D}" readOnly="${form_EV_ITEM_CONTENTS_RO}" required="${form_EV_ITEM_CONTENTS_R}"/>
					</e:field>
				</e:row>
			</e:searchPanel>

			<e:buttonBar align="right">
				<e:button id="doSearch" name="doSearch" label="${doSearch_N}" onClick="doSearch" disabled="${doSearch_D}" visible="${doSearch_V}"/>
				<e:button id="doNew" name="doNew" label="${doNew_N}" onClick="doNew" disabled="${doNew_D}" visible="${doNew_V}"/>
				<e:button id="doDelete" name="doDelete" label="${doDelete_N}" onClick="doDelete" disabled="${doDelete_D}" visible="${doDelete_V}"/>
			</e:buttonBar>

		</e:panel>

		<e:panel width="1%">&nbsp;</e:panel>

		<e:panel width="45%" height="100%">
			<e:searchPanel useTitleBar="false" id="formR" title="${form_CAPTION_N}" labelWidth="${labelNarrowWidth}" labelAlign="${labelAlign}" columnCount="2" onEnter="doSearch">
				<e:row>
					<%-- 평가종류 --%>
					<e:label for="EV_ITEM_KIND_CD_RT" title="${form_EV_ITEM_KIND_CD_RT_N}"/>
					<e:field>
						<e:select id="EV_ITEM_KIND_CD_RT" name="EV_ITEM_KIND_CD_RT"  onChange="getEvItemTypeR" value="${form.EV_ITEM_KIND_CD_RT}" options="${evItemKindCdRtOptions }" width="100%" disabled="${form_EV_ITEM_KIND_CD_RT_D}" readOnly="${form_EV_ITEM_KIND_CD_RT_RO}" required="${form_EV_ITEM_KIND_CD_RT_R}" placeHolder="" />
					</e:field>
					<%-- 평가구분 --%>
					<e:label for="EV_ITEM_TYPE_CD_RT" title="${form_EV_ITEM_TYPE_CD_RT_N}"/>
					<e:field>
						<e:select id="EV_ITEM_TYPE_CD_RT" name="EV_ITEM_TYPE_CD_RT" value="${form.EV_ITEM_TYPE_CD_RT}" options="${evItemTypeCdRtOptions}" width="100%" disabled="${form_EV_ITEM_TYPE_CD_RT_D}" readOnly="${form_EV_ITEM_TYPE_CD_RT_RO}" required="${form_EV_ITEM_TYPE_CD_RT_R}" placeHolder="" />
						<e:inputHidden id="EV_ITEM_NUM" name="EV_ITEM_NUM"/>
						<e:inputHidden id="QTY_ITEM_CD" name="QTY_ITEM_CD"/>
					</e:field>
				</e:row>
				<e:row>
					<%-- 평가방법 --%>
					<e:label for="EV_ITEM_METHOD_CD_RT" title="${form_EV_ITEM_METHOD_CD_RT_N}"/>
					<e:field>
						<e:select id="EV_ITEM_METHOD_CD_RT" name="EV_ITEM_METHOD_CD_RT" onChange="chgMethod" value="${form.EV_ITEM_METHOD_CD_RT}" options="${evItemMethodCdRtOptions }" width="100%" disabled="${form_EV_ITEM_METHOD_CD_RT_D}" readOnly="${form_EV_ITEM_METHOD_CD_RT_RO}" required="${form_EV_ITEM_METHOD_CD_RT_R}" placeHolder="" />
					</e:field>
					<%-- Scale Type --%>
					<e:label for="SCALE_TYPE_CD_RT" title="${form_SCALE_TYPE_CD_RT_N}"/>
					<e:field>
						<e:select id="SCALE_TYPE_CD_RT" name="SCALE_TYPE_CD_RT" value="${form.SCALE_TYPE_CD_RT}" options="${scaleTypeCdRtOptions }" width="100%" disabled="${form_SCALE_TYPE_CD_RT_D}" readOnly="${form_SCALE_TYPE_CD_RT_RO}" required="${form_SCALE_TYPE_CD_RT_R}" placeHolder="" />
					</e:field>
				</e:row>
				<e:row>
					<%-- 평가항목 --%>
					<e:label for="EV_ITEM_SUBJECT_RT" title="${form_EV_ITEM_SUBJECT_RT_N}"/>
					<e:field>
						<e:search id="EV_ITEM_SUBJECT_RT" style="ime-mode:auto" name="EV_ITEM_SUBJECT_RT" value="${form.EV_ITEM_SUBJECT_RT}" width="100%" maxLength="${form_EV_ITEM_SUBJECT_RT_M}" onIconClick="${form_EV_ITEM_SUBJECT_RT_RO ? 'everCommon.blank' : 'doSearchQtyItem'}" disabled="${form_EV_ITEM_SUBJECT_RT_D}" readOnly="${form_EV_ITEM_SUBJECT_RT_RO}" required="${form_EV_ITEM_SUBJECT_RT_R}" />
					</e:field>
					<%-- 평가내용 --%>
					<e:label for="EV_ITEM_CONTENTS_RT" title="${form_EV_ITEM_CONTENTS_RT_N}"/>
					<e:field>
						<e:inputText id="EV_ITEM_CONTENTS_RT" style="${imeMode}" name="EV_ITEM_CONTENTS_RT" value="${form.EV_ITEM_CONTENTS_RT}" width="100%" maxLength="${form_EV_ITEM_CONTENTS_RT_M}" disabled="${form_EV_ITEM_CONTENTS_RT_D}" readOnly="${form_EV_ITEM_CONTENTS_RT_RO}" required="${form_EV_ITEM_CONTENTS_RT_R}"/>
					</e:field>
				</e:row>
			</e:searchPanel>

			<e:buttonBar align="right">
				<e:button id="doSave" name="doSave" label="${doSave_N}" onClick="doSave" disabled="${doSave_D}" visible="${doSave_V}"/>
				<e:button id="doDeleteR" name="doDeleteR" label="${doDeleteR_N}" onClick="doDeleteR" disabled="${doDeleteR_D}" visible="${doDeleteR_V}"/>
			</e:buttonBar>

		</e:panel>

		<e:panel id="leftPanel" height="fit" width="54%">
			<e:gridPanel gridType="${_gridType}" id="gridMain" name="gridMain" height="fit" readOnly="${param.detailView}"/>
		</e:panel>

		<e:panel width="1%">&nbsp;</e:panel>

		<div id="e-tabs" class="e-tabs" style="padding: 0 !important;">
			<e:panel id="righttPanel1" height="fit" width="45%">
				<tr><td><div>
				  <ul>
					<li id="tab1"><a href="#ui-tabs-1" onclick="getContentTab('1');">${CCUR0040_QLY }</a></li>
					<li id="tab2"><a href="#ui-tabs-2" onclick="getContentTab('2');">${CCUR0040_QTY }</a></li>
				  </ul>

				  <div id="ui-tabs-1">
					<div style="height: auto;">
						<e:gridPanel gridType="${_gridType}" id="gridQly" name="gridQly" height="fit" readOnly="${param.detailView}"/>
					</div>
				  </div>

				  <div id="ui-tabs-2">
					<div style="height: auto;">
						<e:gridPanel gridType="${_gridType}" id="gridQty" name="gridQty" height="fit" readOnly="${param.detailView}"/>
					</div>
				  </div>
				</div></td></tr>
			</e:panel>
		</div>
	</e:window>
</e:ui>