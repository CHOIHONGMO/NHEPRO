<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
    <script>
        var grid;
        var baseUrl = "/nhepro/OITR/OITR0080/";

        function init() {
            grid = EVF.C("grid");

            grid.setProperty("shrinkToFit", true);		            // 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
            grid.setProperty("rowNumbers", ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
            grid.setProperty("sortable", ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
            grid.setProperty("panelVisible", ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            grid.setProperty("enterToNextRow", ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            grid.setProperty("acceptZero", ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            grid.setProperty("multiSelect", ${multiSelect});		// [선택] 컬럼의 사용여부를 지정한다. [true/false]
            grid.setProperty("singleSelect", ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]

            grid.cellClickEvent(function(rowIdx, colIdx) {
                var param;

                 if(colIdx == "REG_USER_NM") {
                    if( grid.getCellValue(rowIdx, "REG_USER_ID") == "" ) return;

                    param = {
                        callbackFunction: "",
                        USER_TYPE: "O",  // O:운영사, B:고객사, S:공급사
                        USER_ID: grid.getCellValue(rowIdx, "REG_USER_ID"),
                        detailView: true
                    };
                    everPopup.openPopupByScreenId("MTUA0011", 600, 190, param);
                } else if(colIdx == "MOD_USER_NM") {
                    if( grid.getCellValue(rowIdx, "MOD_USER_ID") == "" ) return;

                    param = {
                        callbackFunction: "",
                        USER_TYPE: "O",  // O:운영사, B:고객사, S:공급사
                        USER_ID: grid.getCellValue(rowIdx, "MOD_USER_ID"),
                        detailView: true
                    };
                    everPopup.openPopupByScreenId("MTUA0011", 600, 190, param);
                }
            });

            grid.addRowEvent(function() {
                var rowId = grid.addRow([{
                    USE_FLAG: "1",
                    MKBR_TYPE: "MK"
                }]);
                grid.setCellReadOnly(rowId, ["MKBR_TYPE", "MKBR_NM", "MAJOR_ITEM_TEXT", "ADD_TEXT"], false);
            });

            grid.delRowEvent(function() {
                if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
                grid.delRow();
            });

            grid.dupRowEvent(function() {

            }, ["MKBR_TYPE", "MKBR_NM", "USE_FLAG", "MAJOR_ITEM_TEXT", "ADD_TEXT"]);

            grid.excelExportEvent({
                allItems: "${excelExport.allCol}",
                fileName: "${screenName }"
            });

            grid.excelImportEvent({
                append: false
            }, function (msg, code) {
                if (code) {
                    grid.checkAll(true);
                }

//                var allRowIds = grid.getAllRowId();
//                for(var i in allRowIds) {
//                    var rowId = allRowIds[i];
//                    var value = grid.getCellValue(rowId, "MKBR_TYPE");
//                    if(value == "제조사") {
//                        grid.setCellValue(rowId, "MKBR_TYPE", "MK");
//                    } else if(value == "브랜드") {
//                        grid.setCellValue(rowId, "MKBR_TYPE", "BR");
//                    }
//                }
            });
        }

        function doSearch() {
            var store = new EVF.Store();
            store.setGrid([grid]);
            store.load(baseUrl + "oitr0080_doSearch.so", function () {
                if(grid.getRowCount() == 0) {
                    return EVF.alert("${msg.M0002}");
                }
            });
        }

        function doSave() {

	        if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

	        if (!grid.validate().flag) {
		        return EVF.alert(grid.validate().msg);
	        }

            EVF.confirm("${msg.M0021 }", function () {
                var store = new EVF.Store();
                store.setGrid([grid]);
                store.getGridData(grid, "sel");
                store.load(baseUrl + "oitr0080_doSave.so", function () {
                    EVF.alert(this.getResponseMessage(), function() {
                        doSearch();
                    });
                });
            });
        }
    </script>
    <%-- IM03_007 --%>
    <e:window id="OITR0080" onReady="init" initData="${initData}" title="${fullScreenName}">

        <e:searchPanel id="form" title="${form_CAPTION_N}" labelWidth="${labelWidth}" labelAlign="${labelAlign}" columnCount="3" useTitleBar="false" onEnter="doSearch">
            <e:label for="MKBR_TYPE" title="${form_MKBR_TYPE_N}"/>
            <e:field>
                <e:select id="MKBR_TYPE" name="MKBR_TYPE" value="MK" options="${mkbrTypeOptions}" width="${form_MKBR_TYPE_W}" disabled="${form_MKBR_TYPE_D}" readOnly="${form_MKBR_TYPE_RO}" required="${form_MKBR_TYPE_R}" placeHolder=""  maskType="${form_MKBR_TYPE_MT}"/>
            </e:field>
            <e:label for="MKBR_NM" title="${form_MKBR_NM_N}"/>
            <e:field>
                <e:inputText id="MKBR_NM" name="MKBR_NM" value="" maxLength="${form_MKBR_NM_M}" width="${form_MKBR_NM_W}" disabled="${form_MKBR_NM_D}" readOnly="${form_MKBR_NM_RO}" required="${form_MKBR_NM_R}" placeHolder=""  maskType="${form_MKBR_NM_MT}" />
            </e:field>
            <e:label for="USE_FLAG" title="${form_USE_FLAG_N}"/>
            <e:field>
                <e:select id="USE_FLAG" name="USE_FLAG" value="1" options="${useFlagOptions}" width="${form_USE_FLAG_W}" disabled="${form_USE_FLAG_D}" readOnly="${form_USE_FLAG_RO}" required="${form_USE_FLAG_R}" placeHolder=""  maskType="${form_USE_FLAG_MT}"/>
            </e:field>
        </e:searchPanel>

        <e:buttonBar align="right" width="100%">
            <e:button id="doSearch" name="doSearch" label="${doSearch_N}" onClick="doSearch" disabled="${doSearch_D}" visible="${doSearch_V}"/>
            <e:button id="doSave" name="doSave" label="${doSave_N}" onClick="doSave" disabled="${doSave_D}" visible="${doSave_V}"/>
        </e:buttonBar>

        <e:gridPanel id="grid" name="grid" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}"/>

    </e:window>
</e:ui>