<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
    <script type="text/javascript">

    	var grid;
		var baseUrl = "/eversrm/manager/screen/";

		function init() {

			grid = EVF.C("grid");

			grid.setProperty('shrinkToFit', ${shrinkToFit});		// 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
            grid.setProperty('rowNumbers', ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
            grid.setProperty('sortable', ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
            grid.setProperty('panelVisible', ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            grid.setProperty('enterToNextRow', ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            grid.setProperty('acceptZero', ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            grid.setProperty('multiSelect', false);		            // [선택] 컬럼의 사용여부를 지정한다. [true/false]

            grid.excelExportEvent({
                allItems : "${excelExport.allCol}",
                fileName : "${screenName }"
            });

			grid.cellClickEvent(function(rowid, celname, value, iRow, iCol) {
				if (celname == "FROZE_FLAG") {
					var allRowIds = grid.getAllRowId();
					for(var i = 0; i < allRowIds.length; i++) {
						grid.setCellValue(allRowIds[i], 'FROZE_FLAG', '0');
					}
                    if(value=='1'){
                        grid.setCellValue(rowid, 'FROZE_FLAG', '1');
                    }
				}
			});
			doSearch();
        }

        function doSearch() {

        	var store = new EVF.Store();
        	store.setGrid([grid]);
			store.load(baseUrl + 'MSRA0033/doSearch.so', function() {
				if(grid.getRowCount() == 0){
					EVF.alert("${msg.M0002 }");
				} else {
					EVF.V("SCREEN_NM", "화면 : "+grid.getCellValue(0, "SCREEN_NM"));
					grid.setColMerge(['FORM_GRID_ID']);
				}
			});
        }

        function doSave() {
			EVF.confirm("${msg.M0011 }", function() {
                var store = new EVF.Store();
                store.setGrid([grid]);
                store.getGridData(grid, 'all');
                store.load(baseUrl + 'MSRA0033/doSave.so', function(){
                    EVF.confirm("${MSRA0033_M002}", function() {
                        if(opener) {
                            opener.location.reload();
                        }
                        doSearch();
                    });

                });
            });

        }
		//초기화 :usln의 테이블의 해당 화면 id 데이터 모두 삭제하고 다시 조회
		function doreset() {
			EVF.confirm("${MSRA0033_M001}", function() {
                var store = new EVF.Store();
                store.setGrid([grid]);
                store.getGridData(grid, 'all');
                store.load(baseUrl + 'MSRA0033/doReset.so', function() {
                    EVF.confirm("${MSRA0033_M003}", function() {
                        if(opener) {
                            opener.location.reload();
                        }
                        doSearch();
                    });
                });
            });
	    }

		function doClose() {
			EVF.closeWindow();
		}

    </script>
    <e:window id="MSRA0033" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">

		<e:buttonBar id="buttonBar" align="right" width="100%">
			<e:inputHidden id="SCREEN_ID" name="SCREEN_ID" value="${param.screenId}" />
			<e:text id="SCREEN_NM" name="SCREEN_NM" style="font-weight:bold; color:blue;">${SCREEN_NM}</e:text>
            <e:button id="Save" name="Save"  label="${Save_N }" disabled="${Save_D }" onClick="doSave" />
            <e:button id="reset" name="reset" label="${reset_N }" disabled="${reset_D }" onClick="doreset" />
			<e:button id="Close" name="Close" label="${Close_N }" disabled="${Close_D }" onClick="doClose" align="right" />
        </e:buttonBar>

        <e:gridPanel id="grid" name="grid" width="100%" height="fit"  gridType="${_gridType}" readOnly="${param.detailView}"/>

    </e:window>
</e:ui>