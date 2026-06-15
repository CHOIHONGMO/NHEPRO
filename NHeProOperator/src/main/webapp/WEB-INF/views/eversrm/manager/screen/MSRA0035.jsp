<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
    <script type="text/javascript">

    	var grid = {};
    	var baseUrl = "/eversrm/manager/screen/";

		function init() {

			grid = EVF.C('grid');

            grid.setProperty('shrinkToFit', ${shrinkToFit});		// 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
            grid.setProperty('rowNumbers', ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
            grid.setProperty('sortable', ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
            grid.setProperty('panelVisible', ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            grid.setProperty('enterToNextRow', ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            grid.setProperty('acceptZero', ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            grid.setProperty('multiSelect', ${param.detailView == true ? false : multiSelect}); // [선택] 컬럼의 사용여부를 지정한다. [true/false]

			grid.addRowEvent(function() {
				grid.addRow({
                    "SCREEN_ID": "${form.screen_Id}",
                    "COLUMN_ID": "${form.column_Id}"
                });
			});

	        doSearch();
        }

        function doSearch() {

        	var store = new EVF.Store();
        	store.setGrid([grid]);
            store.load(baseUrl + 'MSRA0035/doSearch.so', function() {
            });
        }

        function doSave() {

        	if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

            EVF.confirm("${msg.M0011 }", function() {
                var store = new EVF.Store();
                store.setGrid([grid]);
                store.getGridData(grid, 'all');
                store.load(baseUrl + 'MSRA0035/doSave.so', function(){
                    EVF.alert("${msg.M0031}", function() {
                        doSearch();
                    });
                });
            });

        }

		function doClose() {
	        EVF.closeWindow();
	    }

    </script>
    <e:window id="MSRA0035" onReady="init" initData="${initData}" title="${screenName}" breadCrumbs="${breadCrumb }">

        <e:inputHidden id="SCREEN_ID" name="SCREEN_ID" value="${form.screen_Id}" />
        <e:inputHidden id="COLUMN_ID" name="COLUMN_ID" value="${form.column_Id}" />
        <e:text style="font_weight: bold; color: blue;">너비, 높이는 동일하게 적용하시기 바랍니다.</e:text>

        <e:buttonBar id="buttonBar" align="right" width="100%">
            <e:button id="doSearch" name="doSearch" label="${doSearch_N}" onClick="doSearch" />
            <e:button id="doSave" name="doSave" label="${doSave_N}" onClick="doSave" />
            <e:button id="doClose" name="doClose" label="${doClose_N}" onClick="doClose" />
        </e:buttonBar>

	    <e:gridPanel id="grid" name="grid" width="100%" height="fit" gridType="${_gridType}" />

	</e:window>
</e:ui>