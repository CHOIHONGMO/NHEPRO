<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
    <script>

    var grid;
    var baseUrl = '/nhepro/CWOR/';

    function init() {

    	grid = EVF.C('grid');

        grid.setProperty('shrinkToFit', true);		            // 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
        grid.setProperty('rowNumbers', ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
        grid.setProperty('sortable', ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
        grid.setProperty('panelVisible', ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
        grid.setProperty('enterToNextRow', ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
        grid.setProperty('acceptZero', ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
        grid.setProperty('multiSelect', false);		            // [선택] 컬럼의 사용여부를 지정한다. [true/false]
        grid.setProperty('singleSelect', ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]

		grid.cellClickEvent(function(rowIdx, colIdx, value, iRow, iCol) {
			onCellClick( colIdx, rowIdx );
		});

        doSearch();
    }

    function doSearch() {
        var store = new EVF.Store();
        store.setGrid([grid]);
        store.load(baseUrl + 'cwor0042_doSearch.so', function() {
        	if(grid.getRowCount() == 0){
            	EVF.alert("${msg.M0002 }");
            }
        });
    }

    function onCellClick(colIdx, rowIdx) {
    	var rowData = grid.getRowValue(rowIdx);
        parent.window['myApprovalPathCallBack'](JSON.stringify(rowData));
        doClose();
    }

    function doClose() {
        EVF.closeWindow();
    }

    </script>

    <e:window id="CWOR0042" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">

    	<e:buttonBar id="buttonBar" align="right" width="100%">
            <%-- e:button id="Search" name="Search" label="${Search_N }" disabled="${Search_D }" onClick="doSearch" / --%>
            <e:button id="Close" name="Close" label="${Close_N }" disabled="${Close_D }" onClick="doClose" />
        </e:buttonBar>

        <e:gridPanel gridType="${_gridType}" id="grid" name="grid" width="100%" height="fit" readOnly="${param.detailView}"/>

    </e:window>
</e:ui>
