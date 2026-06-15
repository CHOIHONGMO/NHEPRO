<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
    <script type="text/javascript">

        var baseUrl = "/eversrm/manager/auth/MAUA0030/";
        var grid    = {};
        var searchRow;

        function init() {

            grid = EVF.C("grid");

            grid.setProperty('shrinkToFit', true);		            // 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
            grid.setProperty('rowNumbers', ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
            grid.setProperty('sortable', ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
            grid.setProperty('panelVisible', ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            grid.setProperty('enterToNextRow', ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            grid.setProperty('acceptZero', ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            grid.setProperty('multiSelect', ${param.detailView == true ? false : multiSelect}); // [선택] 컬럼의 사용여부를 지정한다. [true/false]

            grid.addRowEvent(function() {
                doAddLine();
            });

            grid.cellClickEvent(function(rowIdx, colIdx, value) {

                searchRow = rowIdx;

                if (colIdx == "MAIN_MODULE_TYPE2") {
                    var param = {
                        callBackFunction: "selectModuleType"
                    };
                    everPopup.openCommonPopup(param, 'SP0007');
                }
                if (colIdx == "AUTH_NM" && grid.getCellValue(rowIdx, "INSERT_FLAG") != "I") {

                    var params = {
                        multi_cd: 'AU',
                        screen_id: '-',
                        "auth_cd": grid.getCellValue(rowIdx, "AUTH_CD"),
                        "choose_button_visibility": "true",
                        rowIdx: rowIdx
                    };
                    everPopup.openMultiLanguagePopup(params);
                }
            });

            grid.excelExportEvent({
                allItems : "${excelExport.allCol}",
                fileName : "${screenName }"
            });

        }

        function doSearch() {

            var store = new EVF.Store();
            store.setGrid([grid]);
            store.load(baseUrl + 'doSearch.so', function() {
                if(grid.getRowCount() == 0){
                    EVF.alert("${msg.M0002 }");
                }
            });
        }

        function doAddLine() {
            grid.addRow([{
                 'INSERT_FLAG' : 'I'
                ,'GATE_CD' : '${ses.gateCd}'
            }]);
        }

        function multiLanguagePopupCallBack(data) {
            grid.setCellValue(data.rowIdx, 'AUTH_NM', data.multiNm);
            grid.setCellValue(data.rowIdx, 'AUTH_DESC', data.multi_Desc);
        }

        function selectModuleType(data) {
            var oldValue = grid.getCellValue(searchRow, "MAIN_MODULE_TYPE");
            var newValue = data.CODE;
            grid.setCellValue(searchRow, "MAIN_MODULE_TYPE", newValue);
            grid.setCellValue(searchRow, "MAIN_MODULE_TYPE2", newValue);
            grid.setCellValue(searchRow, "MODULE_TYPE_NM", data.TEXT1 ? data.TEXT1 : ' ');
        }

        function doInsert() {

            if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

            var kkk = grid.getSelRowId();

            for (var i = 0; i < kkk.length; i++) {
                if (grid.getCellValue(kkk[i], 'INSERT_FLAG') == 'U') {
                    return EVF.alert("${msg.M0005}");
                }
            }

            EVF.confirm("${msg.M0011}", function() {
                var store = new EVF.Store();
                store.setGrid([grid]);
                store.getGridData(grid, 'sel');
                store.load(baseUrl + 'doSave.so', function(){
                    EVF.alert(this.getResponseMessage(), function() {
                        doSearch();
                    });
                });
            });
        }

        function doUpdate() {

            if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

            for (var i = 0; i < grid.getRowCount(); i++) {
                if (grid.getCellValue(i, 'INSERT_FLAG') == 'I') {
                    return EVF.alert("${msg.M0007}");
                }
            }

            EVF.confirm("${msg.M0012}", function() {
                var store = new EVF.Store();
                store.setGrid([grid]);
                store.getGridData(grid, 'sel');
                store.load(baseUrl + 'doSave.so', function(){
                    EVF.alert(this.getResponseMessage(), function() {
                        doSearch();
                    });
                });
            });

        }

        function doDelete() {

            if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

            for (var i = 0; i < grid.getRowCount(); i++) {
                if (grid.getCellValue(i, 'INSERT_FLAG') == 'I') {
                    return EVF.alert("${msg.M0007}");
                }
            }

            EVF.confirm("${msg.M0013}", function() {
                var store = new EVF.Store();
                store.setGrid([grid]);
                store.getGridData(grid, 'sel');
                store.load(baseUrl + 'doDelete.so', function(){
                    EVF.alert(this.getResponseMessage(), function() {
                        doSearch();
                    });
                });
            });
        }

    </script>

    <e:window id="MAUA0030" onReady="init" initData="${initData}" width="100%" height="100%" name="${screenName}" title="${fullScreenName}">
        <e:searchPanel id="form" title="${msg.M9999}" labelWidth="${labelWidth}" width="100%" columnCount="2" onEnter="doSearch"  useTitleBar="false">
            <e:row>
                <e:label for="MODULE_TYPE_NM" title="${form_MODULE_TYPE_NM_N}"/>
                <e:field>
                    <e:select id="MODULE_TYPE_NM" name="MODULE_TYPE_NM" value="${form.MODULE_TYPE_NM}" options="${moduleTypeNmOptions}" width="100%" disabled="${form_MODULE_TYPE_NM_D}" readOnly="${form_MODULE_TYPE_NM_RO}" required="${form_MODULE_TYPE_NM_R}" placeHolder=""  maskType="${form_MODULE_TYPE_NM_MT}"/>
                </e:field>
                <e:label for="AUTH_NM" title="${form_AUTH_NM_N}"/>
                <e:field>
                    <e:inputText id="AUTH_NM" name="AUTH_NM" width='100%' maxLength="${form_AUTH_NM_M }" required="${form_AUTH_NM_R }" readOnly="${form_AUTH_NM_RO }" disabled="${form_AUTH_NM_D}" visible="${form_AUTH_NM_V}"  maskType="${form_AUTH_NM_MT}" />
                </e:field>
            </e:row>
        </e:searchPanel>

        <e:buttonBar id="a" width="100%" align="right" >
            <e:button id="doSearch" name="doSearch" label="${doSearch_N }" onClick="doSearch" disabled="${doSearch_D }" visible="${doSearch_V }" />
            <e:button id="doInsert" name="doInsert" label="${doInsert_N }" onClick="doInsert" disabled="${doInsert_D }" visible="${doInsert_V }" />
            <e:button id="doUpdate" name="doUpdate" label="${doUpdate_N }" onClick="doUpdate" disabled="${doUpdate_D }" visible="${doUpdate_V }" />
            <e:button id="doDelete" name="doDelete" label="${doDelete_N }" onClick="doDelete" disabled="${doDelete_D }" visible="${doDelete_V }" />
        </e:buttonBar>

        <e:gridPanel gridType="${_gridType}" id="grid" name="grid" width="100%" height="100%" readOnly="${param.detailView}"/>

    </e:window>
</e:ui>
