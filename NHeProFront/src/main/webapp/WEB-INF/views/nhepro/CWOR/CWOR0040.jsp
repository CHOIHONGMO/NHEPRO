<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
    <script>

    var grid;
    var saveKey;
    var baseUrl = "/nhepro/CWOR/";

    function init() {

    	grid = EVF.C("grid");

		grid.cellClickEvent(function(rowIdx, colIdx, value, iRow, iCol) {

			if (colIdx == "SIGN_PATH_NM") {

	            saveKey = grid.getCellValue(rowIdx, "PATH_NUM");
	            var popupUrl = baseUrl + 'CWOR0041/view.so';
	            var param = {
	                'toolbar': 'no',
	                'menubar': 'no',
	                'status': 'yes',
	                'scrollbars': 'auto',
	                'resizable': 'no',
	                '_title': 'Path Change',
	                'VALUE': 'C',
	                'GATECD': grid.getCellValue(rowIdx, 'GATE_CD'),
	                'PATHNUM': grid.getCellValue(rowIdx, 'PATH_NUM'),
	                'MAINPATHFLAG': grid.getCellValue(rowIdx, 'MAIN_PATH_FLAG'),
	                'SIGNPATHNM': grid.getCellValue(rowIdx, 'SIGN_PATH_NM'),
	                'SIGNRMK': grid.getCellValue(rowIdx, 'SIGN_RMK'),
	                'popupFlag': true,
	                'onClose': 'closePopup'
	            };
	            everPopup.openWindowPopup(popupUrl, 870, 600, param, 'pathRegister');
	        }
		});

		grid.excelExportEvent({
			allItems : "${excelExport.allCol}",
			fileName : "${screenName }"
		});

		grid.setProperty('shrinkToFit', true);                  // 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
        grid.setProperty('rowNumbers', ${rowNumbers});		    // 로우의 번호 표시 여부를 지정한다. [true/false]
        grid.setProperty('sortable', ${sortable});			    // 컬럼 정렬기능 사용여부를 지정한다. [true/false]
        grid.setProperty('panelVisible', ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
        grid.setProperty('enterToNextRow', ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
        grid.setProperty('acceptZero', ${acceptZero});		    // 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
        grid.setProperty('singleSelect', ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]
        grid.setProperty('multiSelect', ${param.detailView == true ? false : multiSelect}); // [선택] 컬럼의 사용여부를 지정한다. [true/false]

        doSearch();
    }

    function doSearch() {

        var store = new EVF.Store();
        store.setGrid([grid]);
        store.load(baseUrl + 'cwor0040_doSearch.so', function() {
        	if(grid.getRowCount() == 0){
            	EVF.alert("${msg.M0002 }");
            } else {
				var rowIds = grid.getAllRowId();
    			for (var i in rowIds) {
    				if (grid.getCellValue(rowIds[i], "PATH_NUM") == saveKey) {
        				grid.checkRow(i, true);
        				return;
    				}
    			}
            }
        });
    }

    function doRegister() {
        var popupUrl = baseUrl + "CWOR0041/view.so";
        var param = {
            'VALUE': 'R',
            'onClose': 'closePopup',
            'toolbar': 'no',
            'menubar': 'no',
            'status': 'yes',
            'scrollbars': 'auto',
            'resizable': 'no'
        };
        everPopup.openWindowPopup(popupUrl, 1000, 600, param, "pathRegister");
    }

    function doDelete() {

    	if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

        EVF.confirm("${msg.M0013 }", function () {
            var store = new EVF.Store();
            store.setGrid([grid]);
            store.getGridData(grid, 'sel');
            store.load(baseUrl + 'cwor0040_doDelete.so', function () {
                EVF.alert(this.getResponseMessage(), function() {
                    doSearch();
                });
            });
        });
    }

    function closePopup() {
        EVF.V("SIGN_PATH_NM", "");
        doSearch();
    }

    </script>

    <e:window id="CWOR0040" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">

        <e:inputHidden id='APP_DOC_NUM' name="APP_DOC_NUM" />
        <e:inputHidden id='APP_DOC_CNT' name="APP_DOC_CNT" />
        <e:inputHidden id='SIGN_STATUS' name="SIGN_STATUS" />
        <e:inputHidden id="approvalFormData" name="approvalFormData"/>
        <e:inputHidden id="approvalGridData" name="approvalGridData"/>
        <e:inputHidden id="attachFileDatas" name="attachFileDatas" visible="false" />

		<e:searchPanel id="form" onEnter="doSearch" title="${msg.M9999}" labelWidth="${labelWidth}" width="100%" columnCount="2" useTitleBar="false">
            <e:row>
                <e:label for="SIGN_PATH_NM" title="${form_SIGN_PATH_NM_N}"></e:label>
                <e:field>
					<e:inputText id="SIGN_PATH_NM" name="SIGN_PATH_NM" width="100%" maxLength="${form_SIGN_PATH_NM_M }" required="${form_SIGN_PATH_NM_R }" readOnly="${form_SIGN_PATH_NM_RO }" disabled="${form_SIGN_PATH_NM_D}" visible="${form_SIGN_PATH_NM_V}" ></e:inputText>
                </e:field>
                <e:label for="MAIN_PATH_FLAG" title="${form_MAIN_PATH_FLAG_N}"/>
                <e:field>
                    <e:select id="MAIN_PATH_FLAG" name="MAIN_PATH_FLAG" value="" options="${mainPathFlagOptions}" width="${form_MAIN_PATH_FLAG_W}" disabled="${form_MAIN_PATH_FLAG_D}" readOnly="${form_MAIN_PATH_FLAG_RO}" required="${form_MAIN_PATH_FLAG_R}" placeHolder="" maskType="${form_MAIN_PATH_FLAG_MT}" />
                </e:field>
            </e:row>
        </e:searchPanel>

    	<e:buttonBar id="buttonBar" align="right" width="100%">
            <e:button id="Search" name="Search" label="${Search_N }" disabled="${Search_D }" onClick="doSearch" />
            <e:button id="Register" name="Register" label="${Register_N }" disabled="${Register_D }" onClick="doRegister" />
            <e:button id="Delete" name="Delete" label="${Delete_N }" disabled="${Delete_D }" onClick="doDelete" />
        </e:buttonBar>

        <e:gridPanel id="grid" name="grid" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}"/>

    </e:window>
</e:ui>
