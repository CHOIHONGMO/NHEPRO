<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
    <script>
        var grid;
        var baseUrl = "/nhepro/OITR/OITR0071/";

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
            
            grid.cellClickEvent(function(rowIdx, colIdx) {
                if(colIdx == "CODE") {
                    grid.checkRow(rowIdx, true);
                }
            });

            grid.excelExportEvent({
                allItems: "${excelExport.allCol}",
                fileName: "${screenName }"
            });

        }

        function doSearch() {
            var store = new EVF.Store();
            if(!store.validate()) return;

            store.setGrid([grid]);
            store.load(baseUrl + "oitr0071_doSearchCommonCode.so", function() {
            });
        }

        function doSelect() {
            var resultData = grid.getSelRowValue();
            if( resultData.length == 0 ) {
                return EVF.alert("${msg.M0004}");
            }
            opener.window["${param.callBackFunction}"](JSON.stringify(resultData));
            grid.checkAll(false);
        }

        function doClose() {
            EVF.closeWindow();
        }

    </script>

    <e:window id="OITR0071" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">
        <e:searchPanel id="form" title="${msg.M9999}" labelWidth="${labelWidth}" columnCount="1" useTitleBar="false" onEnter="doSearch">
            <e:row>
                <e:label for="CODE_NM" title="${form_CODE_NM_N}" />
                <e:field>
                    <e:inputText id="CODE_NM" name="CODE_NM" value="" width="${form_CODE_NM_W}" maxLength="${form_CODE_NM_M}" disabled="${form_CODE_NM_D}" readOnly="${form_CODE_NM_RO}" required="${form_CODE_NM_R}"  maskType="${form_CODE_NM_MT}" />
                </e:field>
            </e:row>
        </e:searchPanel>

        <e:buttonBar id="buttonBar" align="right" width="100%">
            <e:button id="doSearch" name="doSearch" label="${doSearch_N}" onClick="doSearch" disabled="${doSearch_D}" visible="${doSearch_V}"/>
            <e:button id="doSelect" name="doSelect" label="${doSelect_N}" onClick="doSelect" disabled="${doSelect_D}" visible="${doSelect_V}"/>
        </e:buttonBar>

        <e:gridPanel id="grid" name="grid" width="100%" height="100%" gridType="${_gridType}" readOnly="${param.detailView}"/>
    </e:window>

</e:ui>