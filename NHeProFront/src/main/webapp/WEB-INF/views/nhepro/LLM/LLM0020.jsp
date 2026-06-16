<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
    <script>
        var grid;
        var baseUrl = "/nhepro/LLM/LLM0020/";

        function init() {
            grid = EVF.C("grid");

            grid.setProperty("shrinkToFit", true);
            grid.setProperty("rowNumbers", true);
            grid.setProperty("sortable", true);
            grid.setProperty("panelVisible", true);
            grid.setProperty("enterToNextRow", true);
            grid.setProperty("multiSelect", false);

            grid.cellClickEvent(function(rowIdx, colIdx, value) {
                if (colIdx === "AI_INQ_NO" || colIdx === "ITEM_DESC") {
                    var param = {
                        ITEM_CD: grid.getCellValue(rowIdx, "ITEM_CD"),
                        ITEM_DESC: grid.getCellValue(rowIdx, "ITEM_DESC"),
                        ITEM_SPEC: grid.getCellValue(rowIdx, "ITEM_SPEC"),
                        detailView: true
                    };
                    var url = '/nhepro/LLM/LLM0010/view.so';
                    everPopup.openWindowPopup(url, 1000, 750, param, "aiPriceInquiryPopup");
                }
            });

            grid.excelExportEvent({
                allItems: true,
                fileName: "${screenName}"
            });

            doSearch();
        }

        function doSearch() {
            var store = new EVF.Store();
            store.setGrid([grid]);
            store.load(baseUrl + "llm0020_doSearch.so", function () {
                if(grid.getRowCount() === 0) {
                    return EVF.alert("${msg.M0002}");
                }
            });
        }
    </script>

    <e:window id="LLM0020" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">
        <e:searchPanel id="form" title="${form_CAPTION_N}" labelWidth="${labelWidth}" labelAlign="${labelAlign}" columnCount="3" useTitleBar="false" onEnter="doSearch">
            <e:row>
                <%-- 조회기간 --%>
                <e:label for="START_DATE" title="조회기간" />
                <e:field colSpan="1">
                    <e:inputDate id="START_DATE" name="START_DATE" value="${START_DATE}" width="${inputDateWidth}" datePicker="true" required="true" />
                    <e:text> ~ </e:text>
                    <e:inputDate id="END_DATE" name="END_DATE" value="${END_DATE}" width="${inputDateWidth}" datePicker="true" required="true" />
                </e:field>
                <%-- 품목코드 --%>
                <e:label for="ITEM_CD" title="${form_ITEM_CD_N}" />
                <e:field>
                    <e:inputText id="ITEM_CD" name="ITEM_CD" value="" width="100%" />
                </e:field>
                <%-- 품명 --%>
                <e:label for="ITEM_DESC" title="${form_ITEM_DESC_N}" />
                <e:field>
                    <e:inputText id="ITEM_DESC" name="ITEM_DESC" value="" width="100%" />
                </e:field>
            </e:row>
            <e:row>
                <%-- 등록자명 --%>
                <e:label for="REG_USER_NM" title="등록자명" />
                <e:field colSpan="5">
                    <e:inputText id="REG_USER_NM" name="REG_USER_NM" value="" width="30%" />
                </e:field>
            </e:row>
        </e:searchPanel>

        <e:buttonBar align="right" width="100%">
            <e:button id="doSearch" name="doSearch" label="조회" onClick="doSearch" />
        </e:buttonBar>

        <e:gridPanel id="grid" name="grid" width="100%" height="fit" gridType="${_gridType}" readOnly="true" />
    </e:window>
</e:ui>
