<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
    <script type="text/javascript">

        var grid = {};
        var addParam = [{}];
        var baseUrl = "/eversrm/system/migration/";

        function init() {

            grid = EVF.C('grid');

            grid.excelExportEvent({
                allItems: "${excelExport.allCol}",
                fileName: "${screenName }"
            });

            grid.excelImportEvent({
                'append': false
            }, function (msg, code) {
                if (code) {
                    grid.checkAll(true);
                }
            });

            grid.setProperty('shrinkToFit', ${shrinkToFit});		// 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
            grid.setProperty('rowNumbers', ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
            grid.setProperty('sortable', ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
            grid.setProperty('panelVisible', ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            grid.setProperty('enterToNextRow', ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            grid.setProperty('acceptZero', ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            grid.setProperty('singleSelect', ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]
            grid.setProperty('multiSelect', ${param.detailView == true ? false : multiSelect}); //[선택] 컬럼의 사용여부를 지정한다. [true/false]
        }

        function doSearch() {

            var store = new EVF.Store();
            store.setGrid([grid]);
            store.load(baseUrl + 'mig010_doSearch.so', function () {
                if (grid.getRowCount() == 0) {
                    EVF.alert("${msg.M0002 }");
                }else{
                    grid.checkAll(true);
                }
            });
        }

        function doSave() {
            var store = new EVF.Store();
            store.setGrid([grid]);
            store.getGridData(grid, 'sel');
            store.load(baseUrl + 'mig010_doSave.so', function () {
                EVF.alert(this.getResponseMessage());
            });
        }
    </script>

    <e:window id="MIG_010" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">

        <e:textArea id="CONSOLE" name="CONSOLE" required="false" disabled="false" readOnly="false" maxLength="" width="100%" height="350px" placeHolder="실행할 query를 입력하세요." />

        <e:buttonBar width="100%" align="right">
            <e:button id="Search" name="Search" label="${Search_N}" disabled="${Search_D}" visible="${Search_V}" onClick="doSearch"/>
            <e:button id="Save" name="Save" label="${Save_N}" disabled="${Save_D}" visible="${Save_V}" onClick="doSave"/>
        </e:buttonBar>

        <e:gridPanel id="grid" name="grid" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}"/>
    </e:window>
</e:ui>