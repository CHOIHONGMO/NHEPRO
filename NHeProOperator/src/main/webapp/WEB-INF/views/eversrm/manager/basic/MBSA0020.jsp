<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
    <script type="text/javascript">

    	var gridHD = {};
    	var gridDT = {};
    	var addParamHD = [];
    	var addParamDT = [];
    	var baseUrl = "/eversrm/manager/basic/";
    	var flag = "";

		function init() {

			gridHD = EVF.C('gridHD');
			gridDT = EVF.C('gridDT');

			gridHD.setProperty('shrinkToFit', ${shrinkToFit});		// 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
			gridHD.setProperty('rowNumbers', ${rowNumbers});		// 로우의 번호 표시 여부를 지정한다. [true/false]
			gridHD.setProperty('sortable', ${sortable});			// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
			gridHD.setProperty('panelVisible', ${panelVisible});	// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
			gridHD.setProperty('enterToNextRow', ${enterToNextRow});// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
			gridHD.setProperty('acceptZero', ${acceptZero});		// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
			gridHD.setProperty('multiSelect', ${param.detailView == true ? false : multiSelect}); // [선택] 컬럼의 사용여부를 지정한다. [true/false]

			gridDT.setProperty('shrinkToFit', ${shrinkToFit});
			gridDT.setProperty('rowNumbers', ${rowNumbers});
			gridDT.setProperty('sortable', ${sortable});
			gridDT.setProperty('panelVisible', ${panelVisible});
			gridDT.setProperty('enterToNextRow', ${enterToNextRow});
			gridDT.setProperty('acceptZero', ${acceptZero});
			gridDT.setProperty('multiSelect', ${param.detailView == true ? false : multiSelect});

			gridHD.addRowEvent(function() {
				addParamHD = [{
					"LANG_CD": "${ses.langCd}",
					"USE_FLAG": "1"
				}];
            	gridHD.addRow(addParamHD);
			});

			gridHD.delRowEvent(function() {
                if (gridHD.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
				gridHD.delRow();
			});

			gridHD.cellClickEvent(function(rowIdx, colIdx) {
				if(!EVF.isEmpty(gridHD.getCellValue(rowIdx, 'CODE_TYPE'))) {
					if (colIdx == 'CODE_TYPE') {
			            EVF.V("CODE_TYPE_DT", gridHD.getCellValue(rowIdx, 'CODE_TYPE'));
			            EVF.V("LANG_CD_DT", gridHD.getCellValue(rowIdx, 'LANG_CD'));
			            EVF.V("CODE_DT", "");
			            EVF.V("CODE_DESC_DT", "");
			            doSearchDT();
			        }
				}
			});

			gridHD.cellChangeEvent(function(rowIdx, colIdx) {
				if (colIdx == 'CODE_TYPE') {
		            if (gridHD.getCellValue(rowIdx, 'CODE_TYPE') != "") {
		                EVF.V("CODE_TYPE_DT", gridHD.getCellValue(rowIdx, 'CODE_TYPE'));
		                EVF.V("LANG_CD_DT", gridHD.getCellValue(rowIdx, 'LANG_CD'));
		                EVF.V("CODE_DT", "");
			            EVF.V("CODE_DESC_DT", "");
		                doSearchDT();
		            }
		        }
			});

			gridHD.excelExportEvent({
				allItems : "${excelExport.allCol}",
				fileName : "${screenName }"
			});

			gridDT.addRowEvent(function() {
				addParamDT = [{
					"GATE_CD": "${ses.gateCd}",
					"LANG_CD": EVF.V("LANG_CD_DT") == "" ? "${ses.langCd}" : EVF.V("LANG_CD_DT"),
					"CODE_TYPE": EVF.V("CODE_TYPE_DT") == "" ? '' : EVF.V("CODE_TYPE_DT"),
					"USE_FLAG": "1"
				}];
            	gridDT.addRow(addParamDT);
 			});

			gridDT.delRowEvent(function() {
                if (gridDT.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
				gridDT.delRow();
			});

			gridDT.excelExportEvent({
				allItems : "${excelExport.allCol}",
				fileName : "${screenName }"
			});

			gridDT.dupRowEvent(function(rowId) {

			}, ["LANG_CD",
				"CODE_TYPE",
				"CODE",
				"CODE_DESC",
				"SORT_SQ",
				"USE_FLAG",
				"TEXT1",
				"TEXT2",
				"TEXT3",
				"TEXT4",
				"FLAG",
				"DB_FLAG",
				"GATE_CD"]
			);
			EVF.V("LANG_CD", "KO");
        }

        function doSearchHD() {

			var store = new EVF.Store();
        	store.setGrid([gridHD]);
            store.load(baseUrl + 'doSearchHD.so', function() {
                if(gridHD.getRowCount() == 0){
                	EVF.alert("${msg.M0002 }");
                }
            });
        }

		function doCopyHD() {

            if (gridHD.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

	        var copyArgs = [];
	        var checkCnt = 0;

			var rowIds = gridHD.getSelRowId();
			for(var i = 0; i < rowIds.length; i++) {
                var tmp = [];
                tmp[0] = gridHD.getCellValue(rowIds[i], "GATE_CD");
                tmp[1] = gridHD.getCellValue(rowIds[i], "CODE_TYPE");
                tmp[2] = gridHD.getCellValue(rowIds[i], "CODE_TYPE_DESC");
                tmp[3] = gridHD.getCellValue(rowIds[i], "CODE_TYPE_RMK");
                tmp[4] = gridHD.getCellValue(rowIds[i], "DETAIL_DESC");
                copyArgs[checkCnt] = tmp;
                checkCnt++;
                gridHD.checkRow(i, false);
	        }

	        for (var j = 0; j < copyArgs.length; j++) {
	        	addParamHD = [{
	        		"USE_FLAG": "1",
					"LANG_CD": "${ses.langCd}",
					"GATE_CD": copyArgs[j][0],
					"CODE_TYPE": copyArgs[j][1],
					"CODE_TYPE_DESC": copyArgs[j][2],
					"CODE_TYPE_RMK": copyArgs[j][3],
					"DETAIL_DESC": copyArgs[j][4]
	        	}];
            	gridHD.addRow(addParamHD);
	        }
	    }

        function doSaveHD() {

            if(gridHD.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

            if(!gridHD.validate().flag) { return EVF.alert(gridHD.validate().msg); }

                var rowIds = gridHD.getSelRowId();
                for(var i = 0; i < rowIds.length; i++) {
                    for (var j = 0; j < i; j++) {
                        if (gridHD.getCellValue(rowIds[i], "CODE_TYPE") == gridHD.getCellValue(rowIds[j], "CODE_TYPE")) {
                            if (gridHD.getCellValue(rowIds[i], "LANG_CD") == gridHD.getCellValue(rowIds[j], "LANG_CD")) {
								gridHD.setCellValue(rowIds[i], 'LANG_CD', '');
								return EVF.alert("${msg.M0033}");
                            }
                        }
                    }
                }

                EVF.confirm("${msg.M0021 }", function() {
					var store = new EVF.Store();
					store.setGrid([gridHD]);
					store.getGridData(gridHD, 'sel');
					store.load(baseUrl + 'doSaveHD.so', function(){
						EVF.alert(this.getResponseMessage(), function() {
							doSearchHD();
						});
					});
				});

		}

		function doDeleteHD() {

			if (gridHD.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

			EVF.confirm("${msg.M0013 }", function() {
				var store = new EVF.Store();
				store.setGrid([gridHD]);
				store.getGridData(gridHD, 'sel');
				store.load(baseUrl + 'doDeleteHD.so', function(){
					EVF.alert(this.getResponseMessage(), function() {
						doSearchHD();
					});
				});
			});

		}

		function doSearchDT() {

			if ((EVF.V('CODE_TYPE_DT') == "" || EVF.V('CODE_TYPE_DT') == null)
				&& (EVF.V('CODE_DT') == "" || EVF.V('CODE_DT') == null)
				&& (EVF.V('CODE_DESC_DT') == "" || EVF.V('CODE_DESC_DT') == null)) {
				return EVF.alert("${msg.M0035 }");
			}

			var store = new EVF.Store();
			store.setGrid([gridDT]);
			store.load(baseUrl + 'doSearchDT.so', function() {
				if(gridDT.getRowCount() == 0){
					EVF.alert("${msg.M0002 }");
				}
			});
		}

		function doCopyDT() {

			if (gridDT.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

			var copyArgs = [];
			var checkCnt = 0;

			var rowIds = gridDT.getSelRowId();
			for(var i = 0; i < rowIds.length; i++) {
				var tmp = [];
				tmp[0] = gridDT.getCellValue(rowIds[i], "GATE_CD");
				tmp[1] = gridDT.getCellValue(rowIds[i], "CODE_TYPE");
				tmp[2] = gridDT.getCellValue(rowIds[i], "LANG_CD");
				tmp[3] = gridDT.getCellValue(rowIds[i], "CODE");
				tmp[4] = gridDT.getCellValue(rowIds[i], "TEXT1");
				tmp[5] = gridDT.getCellValue(rowIds[i], "TEXT2");
				tmp[6] = gridDT.getCellValue(rowIds[i], "TEXT3");
				tmp[7] = gridDT.getCellValue(rowIds[i], "TEXT4");
				copyArgs[checkCnt] = tmp;
				checkCnt++;
				gridDT.checkRow(i, false);
			}

			for (var j = 0; j < copyArgs.length; j++) {
				addParamDT = [{
					"USE_FLAG": "1",
					"GATE_CD": copyArgs[j][0],
					"CODE_TYPE": copyArgs[j][1],
					"LANG_CD": copyArgs[j][2],
					"CODE": copyArgs[j][3],
					"TEXT1": copyArgs[j][4],
					"TEXT2": copyArgs[j][5],
					"TEXT3": copyArgs[j][6],
					"TEXT4": copyArgs[j][7]
				}];
				gridDT.addRow(addParamDT);
			}
		}

		function doSaveDT() {

			if (gridDT.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

			if(!gridDT.validate().flag) { return EVF.alert(gridDT.validate().msg); }

			var rowIds = gridDT.getSelRowId();
			for(var i = 0; i < rowIds.length; i++) {
				for (var j = 0; j < i; j++) {
					if (gridDT.getCellValue(rowIds[i], "CODE_TYPE") == gridDT.getCellValue(rowIds[j], "CODE_TYPE")) {
						if (gridDT.getCellValue(rowIds[i], "CODE") == gridDT.getCellValue(rowIds[j], "CODE")) {
							if (gridDT.getCellValue(rowIds[i], "LANG_CD") == gridDT.getCellValue(rowIds[j], "LANG_CD")) {
								gridDT.setCellValue(rowIds[i], 'LANG_CD', '');
								return EVF.alert("${msg.M0033}");
							}
						}
					}
				}
			}

			EVF.confirm("${msg.M0021 }", function () {
				var store = new EVF.Store();
				store.setGrid([gridDT]);
				store.getGridData(gridDT, 'sel');
				store.load(baseUrl + 'doSaveDT.so', function(){
					EVF.alert(this.getResponseMessage(), function() {
						doSearchDT();
					});
				});
			});
		}

		function doDeleteDT() {

			if (gridDT.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

			EVF.confirm("${msg.M0013 }", function () {
				var store = new EVF.Store();
				store.setGrid([gridDT]);
				store.getGridData(gridDT, 'sel');
				store.load(baseUrl + 'doDeleteDT.so', function(){
					EVF.alert(this.getResponseMessage(), function() {
						doSearchDT();
					});
				});
			});
		}

		function commonPopup() {
			var param = {
				callBackFunction: "setCodeType"
			};
			everPopup.openCommonPopup(param, 'SP0019');
		}

		function setCodeType(data) {
			EVF.V("CODE_TYPE_DT", data.CODE);
		}

	</script>
	<e:window id="MBSA0020" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">
		<e:panel id="leftPanel" height="100%" width="39%">
			<e:searchPanel id="formHD" title="${formHD_CAPTION_N }" labelWidth="120" width="100%" columnCount="2" onEnter="doSearchHD" useTitleBar="false">
				<e:row>
					<e:label for="LANG_CD" title="${formHD_LANG_CD_N }" />
					<e:field>
						<e:select id="LANG_CD" name="LANG_CD" value="" readOnly="${formHD_LANG_CD_RO }" options="${langCdOptions}" width="100%" required="${formHD_LANG_CD_R }" disabled="${formHD_LANG_CD_D }"  maskType="${form_LANG_CD_MT}"/>
					</e:field>
					<e:label for="CODE_TYPE" title="${formHD_CODE_TYPE_N }" />
					<e:field>
						<e:inputText id="CODE_TYPE" name="CODE_TYPE" label="${formHD_CODE_TYPE_N }" readOnly="${formHD_CODE_TYPE_RO }" disabled="${formHD_CODE_TYPE_N }" maxLength="${formHD_CODE_TYPE_M}" width="100%" required="${formHD_CODE_TYPE_R }"  maskType="${form_CODE_TYPE_MT}" />
					</e:field>
				</e:row>
				<e:row>
					<e:label for="CODE_DESC" title="${formHD_CODE_DESC_N }" />
					<e:field colSpan="3">
						<e:inputText id="CODE_DESC" name="CODE_DESC" label="${formHD_CODE_DESC_N }" readOnly="${formHD_CODE_DESC_RO }" disabled="${formHD_CODE_DESC_N }" maxLength="${formHD_CODE_DESC_M}" width="100%" required="${formHD_CODE_DESC_R }"  maskType="${form_CODE_DESC_MT}" />
					</e:field>
				</e:row>
			</e:searchPanel>

			<e:buttonBar id="buttonBarHDTop" align="right" width="100%">
				<e:button id="SearchHD" name="SearchHD" label="${SearchHD_N }" disabled="${SearchHD_D }" onClick="doSearchHD" />
				<%-- <e:button id="CopyHD" name="CopyHD"  label="${CopyHD_N }" disabled="${CopyHD_D }" onClick="doCopyHD" /> --%>
	            <e:button id="SaveHD" name="SaveHD"  label="${SaveHD_N }" disabled="${SaveHD_D }" onClick="doSaveHD" />
	            <e:button id="DeleteHD" name="DeleteHD" label="${DeleteHD_N }" disabled="${DeleteHD_D }" onClick="doDeleteHD" />
	        </e:buttonBar>

	        <e:gridPanel id="gridHD" name="gridHD" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}"/>

        </e:panel>

        <e:panel id="middlePanel" height="100%" width="1%">&nbsp;</e:panel>

	    <e:panel id="rightPanel" height="100%" width="60%">
	        <e:searchPanel id="formDT" title="${formDT_CAPTION_DT_N }" columnCount="2" labelWidth="120" onEnter="doSearchDT" useTitleBar="false">
	        	<e:row>
	            	<e:label for="CODE_TYPE_DT" title="${formDT_CODE_TYPE_DT_N }" />
	            	<e:field>
		                <e:inputText id="CODE_TYPE_DT" name="CODE_TYPE_DT" disabled="${formDT_CODE_TYPE_DT_D}"  readOnly="${formDT_CODE_TYPE_DT_RO}" maxLength="${formDT_CODE_TYPE_DT_M}" label="${formDT_CODE_TYPE_DT_N }" width="100%" required="${formDT_CODE_TYPE_DT_R }"  maskType="${form_CODE_TYPE_DT_MT}" />
	            	</e:field>
	            	<e:label for="CODE_DT" title="${formDT_CODE_DT_N }" />
	            	<e:field>
		                <e:inputText id="CODE_DT" name="CODE_DT" label="${formDT_CODE_DT_N }" width="100%" required="${formDT_CODE_DT_R }" readOnly="${formDT_CODE_DT_RO }" maxLength="${formDT_CODE_DT_M}" disabled="${formDT_CODE_DT_N }" maskType="${form_CODE_DT_MT}" />
	            	</e:field>
	            </e:row>
	            <e:row>
					<e:label for="CODE_DESC_DT" title="${formDT_CODE_DESC_DT_N}"/>
					<e:field>
						<e:inputText id="CODE_DESC_DT" name="CODE_DESC_DT" value="${form.CODE_DESC_DT}" width="100%" maxLength="${formDT_CODE_DESC_DT_M}" disabled="${formDT_CODE_DESC_DT_D}" readOnly="${formDT_CODE_DESC_DT_RO}" required="${formDT_CODE_DESC_DT_R}"  maskType="${form_CODE_DESC_DT_MT}" />
					</e:field>
					<e:label for="LANG_CD_DT" title="${formDT_LANG_CD_DT_N}"/>
					<e:field>
						<e:select id="LANG_CD_DT" name="LANG_CD_DT" value="" options="${langCdDtOptions}" width="${formDT_LANG_CD_DT_W}" disabled="${formDT_LANG_CD_DT_D}" readOnly="${formDT_LANG_CD_DT_RO}" required="${formDT_LANG_CD_DT_R}" placeHolder=""  maskType="${form_LANG_CD_DT_MT}"/>
					</e:field>
	            </e:row>
	        </e:searchPanel>

	        <e:buttonBar id="buttonBarDTTop" align="right" width="100%">
	            <e:button id="SearchDT" name="SearchDT" label="${SearchDT_N }" disabled="${SearchDT_D }" onClick="doSearchDT" />
	        	<e:button id="CopyDT" name="CopyDT"  label="${CopyDT_N }" disabled="${CopyDT_D }" onClick="doCopyDT" />
	            <e:button id="SaveDT" name="SaveDT"  label="${SaveDT_N }" disabled="${SaveDT_D }" onClick="doSaveDT" />
	            <e:button id="DeleteDT" name="DeleteDT" label="${DeleteDT_N }" disabled="${DeleteDT_D }" onClick="doDeleteDT" />
	        </e:buttonBar>

	        <e:gridPanel id="gridDT" name="gridDT" width="100%" height="fit" virtualScroll="true" gridType="${_gridType}" readOnly="${param.detailView}"/>

	    </e:panel>
    </e:window>
</e:ui>