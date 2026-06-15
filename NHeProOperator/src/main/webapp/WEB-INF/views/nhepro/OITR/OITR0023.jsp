<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
    <script>
        var grid;
        var baseUrl = "/nhepro/OITR/OITR0023/";

        function init() {
            grid = EVF.C("grid");

            grid.setProperty("shrinkToFit", true);		//컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
            grid.setProperty("rowNumbers", ${rowNumbers});			//로우의 번호 표시 여부를 지정한다. [true/false]
            grid.setProperty("sortable", ${sortable});				//컬럼 정렬기능 사용여부를 지정한다. [true/false]
            grid.setProperty("panelVisible", ${panelVisible});		//그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            grid.setProperty("enterToNextRow", ${enterToNextRow});	//셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            grid.setProperty("acceptZero", ${acceptZero});			//그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            grid.setProperty("multiSelect", false);		//[선택] 컬럼의 사용여부를 지정한다. [true/false]
            grid.setProperty("singleSelect", ${singleSelect});		//[선택] 컬럼의 다중선택 여부를 지정한다. [true/false]

            grid.excelExportEvent({
                allItems: "${excelExport.allCol}",
                fileName: "${screenName }"
            });

            doSearch();
        }

        function doSearch() {
            var store = new EVF.Store();
            store.setGrid([grid]);
            store.load(baseUrl + "oitr0023_doSearch.so", function () {
            });
        }

        function doClose() {
            EVF.closeWindow();
        }
    </script>

    <e:window id="OITR0023" onReady="init" initData="${initData}" title="${fullScreenName}">
        <e:inputHidden id="BUYER_CD" name="BUYER_CD" value="${form.BUYER_CD}" />
        <e:inputHidden id="ITEM_CD" name="ITEM_CD" value="${form.ITEM_CD}" />
        <e:inputHidden id="ITEM_CLS1" name="ITEM_CLS1" value="${form.ITEM_CLS1}"/>
        <e:inputHidden id="ITEM_CLS2" name="ITEM_CLS2" value="${form.ITEM_CLS2}"/>
        <e:inputHidden id="ITEM_CLS3" name="ITEM_CLS3" value="${form.ITEM_CLS3}"/>
        <e:inputHidden id="ITEM_CLS4" name="ITEM_CLS4" value="${form.ITEM_CLS4}"/>

        <e:buttonBar align="right" width="100%">
            <e:button id="doClose" name="doClose" label="${doClose_N}" onClick="doClose" disabled="${doClose_D}" visible="${doClose_V}"/>
        </e:buttonBar>

        <e:gridPanel gridType="${_gridType}" id="grid" name="grid" width="100%" height="fit" readOnly="${param.detailView}"/>
    </e:window>
</e:ui>