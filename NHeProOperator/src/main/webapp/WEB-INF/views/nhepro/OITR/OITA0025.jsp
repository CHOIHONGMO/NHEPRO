<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
    <script>
        var grid;
        var baseUrl = "/nhepro/OITR/OITA0025/";

        function init() {
            grid = EVF.C("grid");

            grid.setProperty("shrinkToFit", true);		//컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
            grid.setProperty("rowNumbers", ${rowNumbers});			//로우의 번호 표시 여부를 지정한다. [true/false]
            grid.setProperty("sortable", ${sortable});				//컬럼 정렬기능 사용여부를 지정한다. [true/false]
            grid.setProperty("panelVisible", ${panelVisible});		//그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            grid.setProperty("enterToNextRow", ${enterToNextRow});	//셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            grid.setProperty("acceptZero", ${acceptZero});			//그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            grid.setProperty("multiSelect", ${multiSelect});		//[선택] 컬럼의 사용여부를 지정한다. [true/false]
            grid.setProperty("singleSelect", ${singleSelect});		//[선택] 컬럼의 다중선택 여부를 지정한다. [true/false]
            
            if("${param.detailView}" == "true") {
            }

            grid.excelExportEvent({
                allItems: "${excelExport.allCol}",
                fileName: "${screenName }"
            });

            doSearch();
        }

        function doSearch() {
            var store = new EVF.Store();
            store.setGrid([grid]);
            store.load(baseUrl + "oita0025_doSearch.so", function () {

                var beforeStr = "${param.AT_DATA}";
                var setAtList = beforeStr.split("@");

                var allRowId = grid.getAllRowId();
                for(var i in allRowId) {
                    var rowId = allRowId[i];

                    for(var j =0; j<setAtList.length; j++){
                        var setAtValue = setAtList[j].split("|");

                        if(grid.getCellValue(rowId, "ATTR_CD") == setAtValue[0]){
                            grid.setCellValue(rowId, "ATTR_VALUE", setAtValue[1]);
                        }
                    }
                }
            });
        }
        
        function doSelect() {
            if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

            var allRowId = grid.getAllRowId();
            for(var i in allRowId) {
                var rowId = allRowId[i];

                if(grid.getCellValue(rowId, "MDT_FLAG") == "1"){
                    if(grid.getCellValue(rowId, "ATTR_VALUE") == "" || grid.getCellValue(rowId, "ATTR_VALUE") == null){
                        return EVF.alert("${OITA0025_001}");
                    }
                }
            }

            var selectedData = grid.getSelRowValue();
            parent["${param.callBackFunction}"](selectedData);
            EVF.closeWindow();
        }
    </script>

    <e:window id="OITA0025" onReady="init" initData="${initData}" title="${fullScreenName}">

        <c:if test="${param.detailView != 'true' }">
            <e:buttonBar align="right" width="100%">
                <e:button id="doSelect" name="doSelect" label="${doSelect_N}" onClick="doSelect" disabled="${doSelect_D}" visible="${doSelect_V}"/>
            </e:buttonBar>
        </c:if>

        <e:inputHidden id="ITEM_CLS1" name="ITEM_CLS1" value="${param.ITEM_CLS1}"/>
        <e:inputHidden id="ITEM_CLS2" name="ITEM_CLS2" value="${param.ITEM_CLS2}"/>
        <e:inputHidden id="ITEM_CLS3" name="ITEM_CLS3" value="${param.ITEM_CLS3}"/>
        <e:inputHidden id="ITEM_CLS4" name="ITEM_CLS4" value="${param.ITEM_CLS4}"/>

        <e:gridPanel gridType="${_gridType}" id="grid" name="grid" width="100%" height="fit" readOnly="${param.detailView}"/>
    </e:window>
</e:ui>