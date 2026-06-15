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
				grid.addRow();
			});

	        doSearch();
        }

        function doSearch() {

        	var store = new EVF.Store();
        	store.setGrid([grid]);
            store.load(baseUrl + 'MSRA0034/doSearch.so', function() {
                if(parent) {
                    parent['setScreenAccessibleCount']('${param.rowId}', grid.getRowCount());
                }
            });
        }

        function doSave() {

        	if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

			if (!grid.validate().flag) { return EVF.alert(grid.validate().msg); }

            var allRowId = grid.getAllRowId();
            var isExistsCdOption = false;
            for(var x in allRowId) {
                var rowId = allRowId[x];
                if(grid.getCellValue(rowId, 'AUTH_TYPE') === 'CD') {
                    if(isExistsCdOption) {
                        return EVF.alert('접근가능직무는 1건만 등록가능합니다.');
                    }
                    isExistsCdOption = true;
                }
            }

			EVF.confirm("${msg.M0021 }", function() {
                var store = new EVF.Store();
                store.setGrid([grid]);
                store.getGridData(grid, 'all');
                store.load(baseUrl + 'MSRA0034/doSave.so', function(){
                    EVF.alert(this.getResponseMessage(), function() {
                        doSearch();
                    });
                });
            });

        }

		function doDelete() {

			if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

            var selRowId = grid.getSelRowId();
            for(var x in selRowId) {
                var rowId = selRowId[x];
                grid.setCellValue(rowId, 'DEL_FLAG', '1');
            }

            EVF.confirm("${msg.M0013 }", function() {
                var store = new EVF.Store();
                store.setGrid([grid]);
                store.getGridData(grid, 'all');
                store.load(baseUrl + 'MSRA0034/doDelete.so', function(){
                    EVF.alert(this.getResponseMessage(), function() {
                        doSearch();
                    });
                });
            });
	    }

		function doClose() {
	        EVF.closeWindow();
	    }

    </script>
    <e:window id="MSRA0034" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">

        <e:inputHidden id="SCREEN_ID" name="SCREEN_ID" value="${param.screenId}" />

        <e:buttonBar id="buttonBar" align="right" width="100%">
            <e:text style="float: left;">※ 접근권한체크 우선순위: 접근가능직무→접근불가능직무→접근불가능사용자ID</e:text>
            <e:button id="doSearch" name="doSearch" label="${doSearch_N}" onClick="doSearch" disabled="${doSearch_D}" visible="${doSearch_V}"/>
            <e:button id="doSave" name="doSave" label="${doSave_N}" onClick="doSave" disabled="${doSave_D}" visible="${doSave_V}"/>
            <e:button id="doDelete" name="doDelete" label="${doDelete_N}" onClick="doDelete" disabled="${doDelete_D}" visible="${doDelete_V}"/>
            <e:button id="doClose" name="doClose" label="${doClose_N}" onClick="doClose" disabled="${doClose_D}" visible="${doClose_V}"/>
        </e:buttonBar>

	    <e:gridPanel id="grid" name="grid" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}"/>

	</e:window>
</e:ui>