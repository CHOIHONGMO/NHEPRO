<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
    <script>
        var grid;
        var baseUrl = "/nhepro/OITR/OITR0060/";

        function init() {
            grid = EVF.C("grid");

            grid.setProperty("shrinkToFit", true);					// 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
            grid.setProperty("rowNumbers", ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
            grid.setProperty("sortable", ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
            grid.setProperty("panelVisible", ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            grid.setProperty("enterToNextRow", ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            grid.setProperty("acceptZero", ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            grid.setProperty("multiSelect", true);					// [선택] 컬럼의 사용여부를 지정한다. [true/false]
            grid.setProperty("singleSelect", ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]
            
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
            });

            grid.addRowEvent(function() {
                grid.addRow({"MDT_FLAG": "1", "USE_FLAG": "1"});
            });

            grid.delRowEvent(function() {
                grid.delRow();
            });

        }

        function doSearch() {
            var store = new EVF.Store();
            if(!store.validate()) return;

            store.setGrid([grid]);
            store.load(baseUrl + "oitr0060_doSearch.so", function() {
                if(grid.getRowCount() == 0) {
                    return EVF.alert("${msg.M0002}");
                }
            });
        }

        function doSave() {
            var store = new EVF.Store();
            if(!store.validate()) return;

            EVF.confirm("${msg.M0021 }", function () {
                store.setGrid([grid]);
                store.getGridData(grid, 'sel');
                store.load(baseUrl + "oitr0060_doSave.so", function() {
                    EVF.alert("${msg.M0031}", function() {
                        doSearch();
                    });
                });
            });


        }

        function doDelete() {
            var store = new EVF.Store();
            if(!store.validate()) return;

            EVF.confirm("${msg.M0013}", function() {
                store.setGrid([grid]);
                store.getGridData(grid, 'sel');
                store.load(baseUrl + "oitr0060_doDelete.so", function() {
                    EVF.alert("${msg.M0017 }", function() {
                        doSearch();
                    });
                });
            });
        }

    </script>
    <%-- IM04_001 --%>
    <e:window id="OITR0060" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">
        <e:searchPanel id="form" title="${msg.M9999}" labelWidth="${labelWidth}" columnCount="2" useTitleBar="false" onEnter="doSearch">
            <e:row>
                <%-- 속성명 --%>
                <e:label for="ATTR_NM" title="${form_ATTR_NM_N}" />
                <e:field>
                    <e:inputText id="ATTR_NM" name="ATTR_NM" value="" width="${form_ATTR_NM_W}" maxLength="${form_ATTR_NM_M}" disabled="${form_ATTR_NM_D}" readOnly="${form_ATTR_NM_RO}" required="${form_ATTR_NM_R}" style="${imeMode}" maskType="${form_ATTR_NM_MT}"/>
                </e:field>
                <%-- 속성코드 --%>
                <e:label for="ATTR_CD" title="${form_ATTR_CD_N}" />
                <e:field>
                    <e:inputText id="ATTR_CD" name="ATTR_CD" value="" width="${form_ATTR_CD_W}" maxLength="${form_ATTR_CD_M}" disabled="${form_ATTR_CD_D}" readOnly="${form_ATTR_CD_RO}" required="${form_ATTR_CD_R}" style="${imeMode}" maskType="${form_ATTR_CD_MT}"/>
                </e:field>
            </e:row>
        </e:searchPanel>

        <e:buttonBar id="buttonBar" align="right" width="100%">
            <e:button id="doSearch" name="doSearch" label="${doSearch_N}" onClick="doSearch" disabled="${doSearch_D}" visible="${doSearch_V}"/>
            <e:button id="doSave" name="doSave" label="${doSave_N}" onClick="doSave" disabled="${doSave_D}" visible="${doSave_V}"/>
            <e:button id="doDelete" name="doDelete" label="${doDelete_N}" onClick="doDelete" disabled="${doDelete_D}" visible="${doDelete_V}"/>
        </e:buttonBar>

        <e:gridPanel id="grid" name="grid" width="100%" height="100%" gridType="${_gridType}" readOnly="${param.detailView}"/>
    </e:window>

</e:ui>