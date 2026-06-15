<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">

	<style>

		.header_table {
			table-layout: fixed;
			border-collapse: collapse;
			font-family: 'Nanum Gothic','Malgun Gothic','맑은고딕','맑은 고딕',sans-serif;
		}

		.header_title {
			font-size: 14px;
			text-align: left;
			background-color: #ffffff;
			vertical-align: middle;
			font-weight: bold;
			border-top: none;
			border-bottom: 2px solid #027bc2;
			border-left: none;
			border-right: none;
			padding-left: 15px;
			background: url(/images/everuxf/theme/neo/icons/title_s_icon.png) no-repeat 5px 11px;

		}

		.header_first {
			font-size: 14px;
			background-color: #ffffff;
			vertical-align: middle;
			font-weight: bold;
			border: 1px solid #ccc;
			background: #eee url(/images/everuxf/theme/neo/icons/field_icon.png) no-repeat 6px 49px;
		}

		.header_text {
			font-size: 14px;
			background-color: #ffffff;
			vertical-align: middle;
			font-weight: normal;
			border: 1px solid #ccc;
		}

		.header_input {
			font-size: 14px;
			background-color: #ffffff;
			vertical-align: top;
			font-weight: normal;
			border: 1px solid #ccc;
		}

		.header_remark {
			font-size: 14px;
			background-color: #ffffff;
			vertical-align: middle;
			font-weight: normal;
			border: 1px solid #ccc;
		}

	</style>

	<script>

		var baseUrl = "/nhepro/CBDR/";
		var grid;
		var eventRowIdx = -1;
		var html = "";
		var btnFlag = false;

		function init() {

			grid = EVF.C("grid");

			grid.cellClickEvent(function(rowIdx, colIdx, value, iRow, iCol, treeInfo) {

				eventRowIdx = rowIdx;

				if (colIdx == 'VENDOR_NM') {

					$('#view').empty();

					EVF.V("EU_USER_NM", grid.getCellValue(rowIdx, "EU_USER_NM"));
					EVF.V("VENDOR_NM_R", grid.getCellValue(rowIdx, "VENDOR_NM"));
					EVF.V("SCORE", grid.getCellValue(rowIdx, "SUM_SCORE"));
					EVF.V("EU_USER_ID_R", grid.getCellValue(rowIdx, "EU_USER_ID"));
					EVF.V("VENDOR_CD", grid.getCellValue(rowIdx, "VENDOR_CD"));
					EVF.V("EU_SQ", grid.getCellValue(rowIdx, "EU_SQ"));
					EVF.V("REMARK", grid.getCellValue(rowIdx, "REMARK"));
					EVF.V("ATT_FILE_NUM", grid.getCellValue(rowIdx, "ATT_FILE_NUM"));

					var store = new EVF.Store();
					store.load(baseUrl + "cbdr0081_doSearchEVEI.so", function() {
						EVF.V("EI_SQ_LIST", this.getParameter("eiSqList"));
						var eiHtml = this.getParameter("eiHtml");
						$('#view').append(eiHtml);
					});
				}
			});

			// Grid Excel Export
			grid.excelExportEvent({
				allItems : "${excelExport.allCol}",
				fileName : "${screenName }"
			});

			grid.setProperty('shrinkToFit', true);					// 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
			grid.setProperty('rowNumbers', ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
			grid.setProperty('sortable', ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
			grid.setProperty('panelVisible', ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
			grid.setProperty('enterToNextRow', ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
			grid.setProperty('acceptZero', ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
			grid.setProperty('singleSelect', ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]
			grid.setProperty('multiSelect', true);					// [선택] 컬럼의 사용여부를 지정한다. [true/false]

			if(${havePermission}) {
				EVF.C('EU_USER_ID').setDisabled(false);
			} else {
				EVF.V('EU_USER_ID', "${ses.userId}");
				EVF.C('EU_USER_ID').setDisabled(true);
			}

			if (${param.evFinalFlag}) {
				EVF.C('EU_INSERT_FLAG').setDisabled(true);
				EVF.C('VENDOR_NM').setDisabled(true);
				EVF.C('EU_USER_ID').setDisabled(true);
				EVF.C('EU_USER_ID').setValue("");

				grid.hideCol("EV_EXCEPT_FLAG", false);
			} else {
				grid.hideCol("EV_EXCEPT_FLAG", ${hideEvExceptFlag});
			}

			btnFlag = true;

			if(!EVF.isEmpty(EVF.V('EI_NUM'))) { doSearch(); }
		}

		function doSearch() {

			if (btnFlag == false) return;

			var store = new EVF.Store();
			store.setGrid([grid]);
			store.load(baseUrl + "cbdr0081_doSearch.so", function() {
				if (grid.getRowCount() == 0) {
					EVF.alert("${msg.M0002 }");
				}
			});
		}

		function doSave() {

			var jsonArr = new Array();
			var eiSqListArgs = EVF.V("EI_SQ_LIST").split(",");
			for(var i = 0; i < eiSqListArgs.length; i++) {

				var jsonObj = new Object();
				jsonObj.EI_SQ = eiSqListArgs[i];

				var scaleTypeCd = document.getElementById("SCALE_TYPE_CD_EI_SQ_" + eiSqListArgs[i]).value;
				if(scaleTypeCd == "A") { <%-- 절대치 --%>
					var radioBoxVal = document.getElementsByName("EI_SQ_" + eiSqListArgs[i]);
					var checkedCnt = 0;
					for(var j = 0; j < radioBoxVal.length; j++) {
						if(radioBoxVal[j].checked == true) {
							jsonObj.SEL_EV_ID_SQ = (j+1);
							jsonObj.RESULT_SCORE = radioBoxVal[j].value;
							checkedCnt++;
						}
					}
					if(checkedCnt == 0) {
						return EVF.alert("'" + document.getElementById("EV_ITEM_SUBJECT_EI_SQ_" + eiSqListArgs[i]).value + "'의 지표를 선택해주세요.");
					}
				}
				else { <%-- 직접입력 --%>
					var eiSqsIdsStr = document.getElementById("EI_SQ_" + eiSqListArgs[i] + "_IDS").value;
					var eiSqsIdsArgs = eiSqsIdsStr.split(",");
					var totScore = 0;
					for(var k = 0; k < eiSqsIdsArgs.length; k++) {
						if(Number(document.getElementById("EI_SQ_" + eiSqListArgs[i] + "_EI_ID_SQ_" + eiSqsIdsArgs[k]).value) > Number(document.getElementById("EI_SQ_" + eiSqListArgs[i] + "_EI_ID_SQ_SCORE_" + eiSqsIdsArgs[k]).value)) {
							return EVF.alert("'" + document.getElementById("EV_ITEM_SUBJECT_EI_SQ_" + eiSqListArgs[i]).value + "'의 점수는 배점보다 높을 수 없습니다.");
						}
						totScore = totScore + Number(document.getElementById("EI_SQ_" + eiSqListArgs[i] + "_EI_ID_SQ_" + eiSqsIdsArgs[k]).value);
						if(Number(document.getElementById("EI_SQ_" + eiSqListArgs[i] + "_EI_ID_SQ_" + eiSqsIdsArgs[k]).value) > 0) {
							jsonObj.SEL_EV_ID_SQ = (k+1);
						}
					}
					if(totScore == 0) {
						return EVF.alert("'" + document.getElementById("EV_ITEM_SUBJECT_EI_SQ_" + eiSqListArgs[i]).value + "'의 점수를 입력해주세요.");
					}
					jsonObj.RESULT_SCORE = totScore;
				}
				jsonObj.REMARK = document.getElementById("REMARK_EI_SQ_" + eiSqListArgs[i]).value;
				jsonArr.push(jsonObj);
			}

			var store = new EVF.Store();
			store.setParameter("jsonStr", JSON.stringify(jsonArr));
			EVF.confirm("${msg.M0021 }", function () {
				store.doFileUpload(function() {
					store.load(baseUrl + 'cbdr0081_doSaveR.so', function() {
						EVF.alert(this.getResponseMessage(), function() {

							$('#view').empty();

							store = new EVF.Store();
							store.load(baseUrl + "cbdr0081_doSearchEVEI.so", function() {
								EVF.V("EI_SQ_LIST", this.getParameter("eiSqList"));
								var eiHtml = this.getParameter("eiHtml");
								$('#view').append(eiHtml);
							});
							doSearch();
						});
					});
				});
			});
		}

		function doFinishEval() {

			if (${param.evFinalFlag}) {
				doCompleteEval();
				return;
			}

			if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

			var rowIds = grid.getSelRowId();
			for(var i = 0; i < rowIds.length; i++) {
				if(${!havePermission}) {
					if(grid.getCellValue(rowIds[i], 'EU_USER_ID') != "${ses.userId}") {
						return EVF.alert("${CBDR0081_002}");
					}
				}
				if(grid.getCellValue(rowIds[i], 'EU_INSERT_FLAG') != "1") {
					return EVF.alert("${CBDR0081_001}");
				}
				if(grid.getCellValue(rowIds[i], 'EU_FINISH_FLAG') == "1") {
					return EVF.alert("${CBDR0081_003}");
				}
			}

			var store = new EVF.Store();
			store.setGrid([ grid ]);
			store.getGridData(grid, 'sel');
			EVF.confirm("${CBDR0081_005 }", function () {
				store.load(baseUrl + 'cbdr0081_doFinishEval.so', function() {
					EVF.alert(this.getResponseMessage(), function() {
						opener.doSearch();
						doSearch();
					});
				});
			});
		}

		function doCompleteEval() {
            var contType2 = EVF.C("CONT_TYPE2").getValue();

            EVF.confirm("${CBDR0081_005 }", function () {										<%-- 평가를 완료하시겠습니까? --%>

	        	grid.checkAll(true);

    	        var store = new EVF.Store();
        	    store.setGrid([grid]);
	        	store.getGridData(grid, 'sel');
	    	    store.load(baseUrl + 'cbdr0081_doCompleteEvel.so', function() {
    	        	EVF.alert(this.getResponseMessage(), function() {

    	        		if(contType2 == "NE") {
                        	opener.doSearch();
                    	} else {
                            opener.doOpenEvSpec(EVF.C("BUYER_CD").getValue(), EVF.C("BID_NUM").getValue(), EVF.C("BID_CNT").getValue(), contType2);
                    	}
                        doClose();

            		});
	        	});
    		});
		}

		function doClose() {
			EVF.closeWindow();
		}

	</script>

	<e:window id="CBDR0081" onReady="init" initData="${initData}" title="${screenName}">
		<e:panel width="48%" height="100%">

			<e:buttonBar id="btnN" align="right" title="${CBDR0081_CAPTION1 }" ></e:buttonBar>

			<e:searchPanel id="formL" useTitleBar="false" title="${form_CAPTION_N}" labelWidth="100px" labelAlign="${labelAlign}" columnCount="2" onEnter="doSearch">
				<e:row>
					<e:label for="EV_TPL_SUBJECT" title="${formL_EV_TPL_SUBJECT_N}" />
					<e:field>
						<e:inputText id="EV_TPL_SUBJECT" style="${imeMode}" name="EV_TPL_SUBJECT" value="${param.EV_TPL_SUBJECT}" width="${formL_EV_TPL_SUBJECT_W}" maxLength="${formL_EV_TPL_SUBJECT_M}" disabled="${formL_EV_TPL_SUBJECT_D}" readOnly="${formL_EV_TPL_SUBJECT_RO}" required="${formL_EV_TPL_SUBJECT_R}"/>
						<e:inputHidden id="BUYER_CD" name="BUYER_CD" value="${param.BUYER_CD}" />
						<e:inputHidden id="BID_NUM" name="BID_NUM" value="${param.BID_NUM}" />
						<e:inputHidden id="BID_CNT" name="BID_CNT" value="${param.BID_CNT}" />
						<e:inputHidden id="EI_NUM" name="EI_NUM" value="${param.EI_NUM}" />
						<e:inputHidden id="EV_TPL_NUM" name="EV_TPL_NUM" value="${param.EV_TPL_NUM}" />
						<e:inputHidden id="VOTE_CNT" name="VOTE_CNT" value="${param.VOTE_CNT}" />
						<e:inputHidden id="EU_USER_ID_R" name="EU_USER_ID_R" value="" />
						<e:inputHidden id="VENDOR_CD" name="VENDOR_CD" value="" />
						<e:inputHidden id="EU_SQ" name="EU_SQ" value="" />
						<e:inputHidden id="EI_SQ_LIST" name="EI_SQ_LIST" value="" />
						<e:inputHidden id="CONT_TYPE2" name="CONT_TYPE2" value="${param.CONT_TYPE2}" />
					</e:field>
					<e:label for="EU_INSERT_FLAG" title="${formL_EU_INSERT_FLAG_N}"/>
					<e:field>
						<e:select id="EU_INSERT_FLAG" name="EU_INSERT_FLAG" value="" options="${euInsertFlagOptions}" width="${formL_EU_INSERT_FLAG_W}" disabled="${formL_EU_INSERT_FLAG_D}" readOnly="${formL_EU_INSERT_FLAG_RO}" required="${formL_EU_INSERT_FLAG_R}" placeHolder="" />
					</e:field>
				</e:row>
				<e:row>
					<e:label for="VENDOR_NM" title="${formL_VENDOR_NM_N}"/>
					<e:field>
						<e:inputText id="VENDOR_NM" style="${imeMode}" name="VENDOR_NM" value="" width="${formL_VENDOR_NM_W}" maxLength="${formL_VENDOR_NM_M}" disabled="${formL_VENDOR_NM_D}" readOnly="${formL_VENDOR_NM_RO}" required="${formL_VENDOR_NM_R}"/>
					</e:field>
					<e:label for="EU_USER_ID" title="${formL_EU_USER_ID_N}"/>
					<e:field>
						<e:select id="EU_USER_ID" name="EU_USER_ID" value="${ses.userId}" options="${euUserIdOptions}" width="${formL_EU_USER_ID_W}" disabled="${formL_EU_USER_ID_D}" readOnly="${formL_EU_USER_ID_RO}" required="${formL_EU_USER_ID_R}" placeHolder="" onChange="doSearch" />
					</e:field>
				</e:row>
			</e:searchPanel>

			<e:buttonBar id="btnL" align="right">
				<e:button id="Search" name="Search" label="${Search_N}" onClick="doSearch" disabled="${Search_D}" visible="${Search_V}"/>
				<e:button id="FinishEval" name="FinishEval" label="${FinishEval_N}" onClick="doFinishEval" disabled="${FinishEval_D}" visible="${FinishEval_V}"/>
				<e:button id="Close" name="Close" label="${Close_N}" onClick="doClose" disabled="${Close_D}" visible="${Close_V}"/>
			</e:buttonBar>

			<e:gridPanel id="grid" name="grid" gridType="${_gridType}" height="250px" readOnly="${param.detailView}"/>

		</e:panel>

		<e:panel width="1%">&nbsp;</e:panel>

		<e:panel width="51%" height="100%">

			<e:buttonBar id="btnR" align="right" title="${CBDR0081_CAPTION2 }">
				<e:button id="Save" name="Save" label="${Save_N}" onClick="doSave" disabled="${Save_D}" visible="${Save_V}"/>
			</e:buttonBar>

			<e:searchPanel useTitleBar="false" id="formR" title="" labelWidth="${labelNarrowWidth}" labelAlign="${labelAlign}" columnCount="2">
				<e:row>
					<e:label for="EU_USER_NM" title="${formR_EU_USER_NM_N}"/>
					<e:field>
						<e:inputText id="EU_USER_NM" style="${imeMode}" name="EU_USER_NM" value="" width="${formR_EU_USER_NM_W}" maxLength="${formR_EU_USER_NM_M}" disabled="${formR_EU_USER_NM_D}" readOnly="${formR_EU_USER_NM_RO}" required="${formR_EU_USER_NM_R}"/>
					</e:field>
					<e:label for="VENDOR_NM_R" title="${formR_VENDOR_NM_R_N}"/>
					<e:field>
						<e:inputText id="VENDOR_NM_R" style="${imeMode}" name="VENDOR_NM_R" value="" width="${formR_VENDOR_NM_R_W}" maxLength="${formR_VENDOR_NM_R_M}" disabled="${formR_VENDOR_NM_R_D}" readOnly="${formR_VENDOR_NM_R_RO}" required="${formR_VENDOR_NM_R_R}"/>
					</e:field>
				</e:row>
				<e:row>
					<e:label for="SCORE" title="${formR_SCORE_N}"/>
					<e:field colSpan="3">
						<e:inputNumber id="SCORE" name="SCORE" value="" width="60px" align="left" maxValue="${formR_SCORE_M}" decimalPlace="${formR_SCORE_NF}" disabled="${formR_SCORE_D}" readOnly="${formR_SCORE_RO}" required="${formR_SCORE_R}" />
					</e:field>
				</e:row>
				<e:row>
					<e:label for="ATT_FILE_NUM" title="${formR_ATT_FILE_NUM_N}"/>
					<e:field colSpan="3">
						<e:fileManager id="ATT_FILE_NUM" name="ATT_FILE_NUM" bizType="EV" fileId="" readOnly="${!param.detailView ? false : true }" downloadable="true" width="100%" height="145px" onBeforeRemove="onBeforeRemove" onError="onError" onFileClick="onFileClick" onSuccess="onSuccess" required="" />
					</e:field>
				</e:row>
				<e:row>
					<e:label for="REMARK" title="${formR_REMARK_N}"/>
					<e:field colSpan="3">
						<e:textArea id="REMARK" name="REMARK" value="" height="150px" width="${formR_REMARK_W}" maxLength="${formR_REMARK_M}" disabled="${formR_REMARK_D}" readOnly="${formR_REMARK_RO}" required="${formR_REMARK_R}" />
					</e:field>
				</e:row>
			</e:searchPanel>
		</e:panel>

		<div id="view">

		</div>

	</e:window>
</e:ui>