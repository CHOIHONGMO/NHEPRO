<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
    <script type="text/javascript">

    	var grid = {};
    	var addParam = [];
    	var baseUrl = "/eversrm/manager/screen/";
    	var searchRow = "";

		function init() {

			grid = EVF.C('grid');

			grid.cellClickEvent(function(rowIdx, colIdx) {

				searchRow = rowIdx;

		        if (colIdx == "SCREEN_ID") {
		            var popupUrl = "/eversrm/manager/screen/MSRA0011/view.so";
		            everPopup.openWindowPopup(popupUrl, 1000, 500, {
		                onSelect: 'selectScreen'
		            }, 'screenIdPopup');
		        }
		        else if (colIdx == 'ACTION_NM') {

					if (grid.getCellValue(rowIdx, 'ACTION_CD') == null || grid.getCellValue(rowIdx, 'ACTION_CD') == "") {
						return EVF.alert("${MSRA0020_MSG_0001}");
					}
		            var params = {
		                multi_cd: 'SA',
		                screen_id: grid.getCellValue(rowIdx, "SCREEN_ID"),
		                action_cd: grid.getCellValue(rowIdx, "ACTION_CD"),
		                rowIdx: rowIdx,
                        callBackFunction: "multiLanguagePopupCallBack"
		            };
		            everPopup.openMultiLanguagePopup(params);
		        }
		        else if (colIdx == 'BUTTON_ICON_NM') {
		            // everPopup.openIconPopup();
		        }
		        else if (colIdx == 'BUTTON_AUTH') {

                    if (grid.getCellValue(rowIdx, 'SCREEN_ID') == null || grid.getCellValue(rowIdx, 'SCREEN_ID') == '') {
                        return EVF.alert("${MSRA0020_MSG_0001 }");
                    }
                    var param = {
                        callbackFunction: "setScreenAuth",
                        screenId: grid.getCellValue(rowIdx, 'SCREEN_ID'),
                        actionCd: grid.getCellValue(rowIdx, 'ACTION_CD'),
                        rowIdx: rowIdx
                    };

                    var url = '/eversrm/system/multiLang/BSYL_050/view.so';
                    return new EVF.ModalWindow(url, param, 700, 400).open();
                }
			});

			grid.addRowEvent(function() {
				addParam = [{"INSERT_FLAG": "I", "GATE_CD": "${ses.gateCd }"}];
            	grid.addRow(addParam);
			});

            grid.delRowEvent(function() {
                if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
                grid.delRow();
            });

            grid.excelExportEvent({
                allItems : "${excelExport.allCol}",
                fileName : "${screenName }"
            });

            grid.setProperty('shrinkToFit', ${shrinkToFit});		// 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
            grid.setProperty('rowNumbers', ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
            grid.setProperty('sortable', ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
            grid.setProperty('panelVisible', ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            grid.setProperty('enterToNextRow', ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            grid.setProperty('acceptZero', ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            grid.setProperty('multiSelect', ${param.detailView == true ? false : multiSelect}); // [선택] 컬럼의 사용여부를 지정한다. [true/false]

            grid.setColIconify("SCREEN_NM_IMG", "SCREEN_NM_IMG", "detail", true);

            if ('${param.screenId}' != '') {
                EVF.V('SCREEN_ID', '${param.screenId}');
                doSearch();
            }
        }

        function doSearch() {

        	var store = new EVF.Store();
        	store.setGrid([grid]);
            store.load(baseUrl + 'screenActionManagement/doSearch.so', function() {
                if(grid.getRowCount() == 0){
                	EVF.alert("${msg.M0002 }");
                }
            });
        }

        function doSave() {

        	if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

            if (!grid.validate().flag) { return EVF.alert(grid.validate().msg); }

			if (!isValidFPColumn()) { return; }

			EVF.confirm("${msg.M0021 }", function() {
                var store = new EVF.Store();
                store.setGrid([grid]);
                store.getGridData(grid, 'sel');
                store.load(baseUrl + 'screenActionManagement/doSave.so', function(){
                    EVF.alert(this.getResponseMessage(), function() {
                        doSearch();
                    });
                });
            });
        }

		function doDelete() {

			if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

			EVF.confirm("${msg.M0013 }", function() {
                var store = new EVF.Store();
                store.setGrid([grid]);
                store.getGridData(grid, 'sel');
                store.load(baseUrl + 'screenActionManagement/doDelete.so', function(){
                    EVF.alert(this.getResponseMessage(), function() {
                        doSearch();
                    });
                });
            });
	    }

	    function doCopy() {

            if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

			var rowIds = grid.getSelRowId();
			grid.checkAll(false);

			for(var i = 0; i < rowIds.length; i++) {
				var selectedData = [{
					"SCREEN_ID": grid.getRowValue(rowIds[i]).SCREEN_ID,
					"SCREEN_NM": grid.getRowValue(rowIds[i]).SCREEN_NM,
					"MODULE_TYPE": grid.getRowValue(rowIds[i]).MODULE_TYPE,
					"GATE_CD": grid.getRowValue(rowIds[i]).GATE_CD,
					"INSERT_FLAG": "I"
				}];
				grid.addRow(selectedData);
			}
	    }

	    function selectScreen(data) {
	        grid.setCellValue(searchRow, "SCREEN_ID", data.SCREEN_ID); //{src:'', text: data.SCREEN_ID});
	        grid.setCellValue(searchRow, "SCREEN_NM", data.SCREEN_NM);
	        grid.setCellValue(searchRow, "MODULE_TYPE", data.MODULE_TYPE);
        }

        <%--
	    function setButtonIcon(val) {
	        grid.setCellValue('BUTTON_ICON_NAME', searchRow, val);
	    } --%>

	    function isValidFPColumn() {
	    	var rowIds = grid.getSelRowId();

			for(var i = 0; i < rowIds.length; i++) {
                var selectedCount = 0;
                if (isFPSelected(rowIds[i], 'FP_EQ_FLAG')) {
                    selectedCount++;
                }
                if (isFPSelected(rowIds[i], 'FP_EO_FLAG')) {
                    selectedCount++;
                }
                if (isFPSelected(rowIds[i], 'FP_EI_FLAG')) {
                    selectedCount++;
                }
                if (isFPSelected(rowIds[i], 'FP_ETC_TEXT')) {
                    selectedCount++;
                }
                if (selectedCount == 0) {
                    EVF.alert('${MSRA0020_0001 }');
                    return false;
                }
                if (selectedCount != 1) {
                    EVF.alert('${MSRA0020_0001 }');
                    return false;
                }
            }
	        return true;
	    }

	    function isFPSelected(nRow, id) {
	        if (grid.getCellValue(nRow, id) == '1') {
	            return true;
	        }
	        return false;
	    }

		function multiLanguagePopupCallBack(multiLanguagePopupReturn) {
	        grid.setCellValue(multiLanguagePopupReturn.rowIdx, 'ACTION_NM', multiLanguagePopupReturn.multiNm);
	    }

		function setSearchTemplate(buttonType) {

			if(EVF.isEmpty(EVF.V('MODULE_TYPE'))) {
				return EVF.alert('${MSRA0020_MSG_0007}');
			}

			if(EVF.isEmpty(EVF.V('SCREEN_ID'))) {
				return EVF.alert('${MSRA0020_MSG_0008}');
			}

			var btnName;
			var actionCode;

            if (buttonType === 'search') {
                btnName = '${MSRA0020_MSG_0003}';
                actionCode = "doSearch";
            } else if (buttonType === 'save') {
                btnName = '${MSRA0020_MSG_0004}';
                actionCode = "doSave";
            } else if (buttonType === 'delete') {
                btnName = '${MSRA0020_MSG_0005}';
                actionCode = "doDelete";
            } else if (buttonType === 'close') {
                btnName = '${MSRA0020_MSG_0006}';
                actionCode = "doClose";
            }

            var newRowId = grid.addRow([{
				"MODULE_TYPE":EVF.V('MODULE_TYPE'),
				"SCREEN_ID":EVF.V('SCREEN_ID'),
				"ACTION_CD": actionCode,
				"FP_EQ_FLAG": buttonType === 'search' ? '1' : '0',
				"FP_EI_FLAG": (buttonType === 'save' || buttonType === 'delete') ? '1' : '0',
				"FP_ETC_TEXT": buttonType === 'close' ? '1' : '0'
			}]);

			var params = {
				"multi_cd": 'SA',
				"screen_id": EVF.V('SCREEN_ID'),
				"action_cd": actionCode,
				"rowIdx": newRowId,
				"insertNew": true
			};

			everPopup.openMultiLanguagePopup(params);
		}

    </script>
    <e:window id="MSRA0020" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">
        <e:searchPanel id="form" title="${form_CAPTION_N }" columnCount="3" labelWidth="${labelWidth }" onEnter="doSearch" useTitleBar="false">
        	<e:row>
                <e:label for="MODULE_TYPE" title="${form_MODULE_TYPE_N }" />
                <e:field>
                    <e:select id="MODULE_TYPE" name="MODULE_TYPE" options="${moduleTypeOptions}" width="100%" required="${form_MODULE_TYPE_R }" readOnly="${form_MODULE_TYPE_RO }" disabled="${form_MODULE_TYPE_D }" onFocus="onFocus"  maskType="${form_MODULE_TYPE_MT}"/>
                </e:field>
                <e:label for="st_SCREEN_ID" title="${form_SCREEN_ID_N }" />
                <e:field>
                	<e:inputText id="SCREEN_ID" name="SCREEN_ID" width="100%" maxLength="${form_SCREEN_ID_M}" required="${form_SCREEN_ID_R }" readOnly="${form_SCREEN_ID_RO }" disabled="${form_SCREEN_ID_D }" value="${param.screenId}" maskType="${form_SCREEN_ID_MT}" />
                </e:field>
                <e:label for="st_SCREEN_NM" title="${form_SCREEN_NM_N }" />
                <e:field>
	                <e:inputText id="SCREEN_NM" name="SCREEN_NM" maxLength="${form_SCREEN_NM_M}" width="100%" required="${form_SCREEN_NM_R }" readOnly="${form_SCREEN_NM_RO }" disabled="${form_SCREEN_NM_D }"  maskType="${form_SCREEN_NM_MT}" />
                </e:field>
            </e:row>
			<e:row>
				<e:label for="st_ACTION_CD" title="${form_ACTION_CD_N }" />
                <e:field>
                	<e:inputText id="ACTION_CD" name="ACTION_CD" maxLength="${form_ACTION_ID_M}" width="100%" required="${form_ACTION_CD_R }" readOnly="${form_ACTION_CD_RO }" disabled="${form_ACTION_CD_D }"  maskType="${form_ACTION_CD_MT}" />
                </e:field>
				<e:label for="st_ACTION_NM" title="${form_ACTION_NM_N }" />
                <e:field colSpan="3">
                	<e:inputText id="ACTION_NM" name="ACTION_NM" maxLength="${form_ACTION_NM_M}" width="100%" required="${form_ACTION_NM_R }" readOnly="${form_ACTION_NM_RO }" disabled="${form_ACTION_NM_D }"  maskType="${form_ACTION_NM_MT}" />
                </e:field>
            </e:row>
        </e:searchPanel>

        <e:buttonBar id="buttonBar" align="right" width="100%">
			<div style="float: left; font-size: 12px; line-height: 22px;">${MSRA0020_MSG_0002}:</div>
			<a onclick="setSearchTemplate('search');" style="float: left; font-size: 12px; line-height: 22px; cursor: hand !important;">[${MSRA0020_MSG_0003}]</a>
			<a onclick="setSearchTemplate('save');" style="float: left; font-size: 12px; line-height: 22px; cursor: hand !important;">[${MSRA0020_MSG_0004}]</a>
			<a onclick="setSearchTemplate('delete');" style="float: left; font-size: 12px; line-height: 22px; cursor: hand !important;">[${MSRA0020_MSG_0005}]</a>
			<a onclick="setSearchTemplate('close');" style="float: left; font-size: 12px; line-height: 22px; cursor: hand !important;">[${MSRA0020_MSG_0006}]</a>
            <e:button id="doSearch" name="doSearch" label="${doSearch_N }" disabled="${doSearch_D }" onClick="doSearch" />
            <e:button id="doCopy" name="doCopy" label="${doCopy_N }" disabled="${doCopy_D }" onClick="doCopy" />
            <e:button id="doSave" name="doSave" label="${doSave_N }" disabled="${doSave_D }" onClick="doSave" />
            <e:button id="doDelete" name="doDelete" label="${doDelete_N }" disabled="${doDelete_D }" onClick="doDelete" />
        </e:buttonBar>

        <e:gridPanel id="grid" name="grid" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}"/>

    </e:window>
</e:ui>