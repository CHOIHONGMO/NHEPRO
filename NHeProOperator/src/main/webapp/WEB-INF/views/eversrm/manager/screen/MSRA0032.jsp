<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
    <script type="text/javascript">

    	var grid = {};
    	var addParam = [];
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

            grid.excelExportEvent({
                allItems : "${excelExport.allCol}",
                fileName : "${screenName }"
            });

			grid.cellClickEvent(function(rowid, celname, value, iRow, iCol) {
				if(celname == "DOMAIN_NM") {
                    var rowValue = grid.getRowValue(rowid);
                    if(opener) {
                        opener['setDomain'](rowValue);
                    } else if(parent) {
                        parent['setDomain'](rowValue);
                    }
            		doClose();
	            }
			});

			doSearch();
        }

        function doSearch() {

        	var store = new EVF.Store();
        	store.setGrid([grid]);
            store.load(baseUrl + 'MSRA0032/doSearchWord.so', function() {

            });
        }

	    function doClose() {
            EVF.closeWindow();
	    }

    </script>
    <e:window id="MSRA0032" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">
        <e:searchPanel id="form" title="${form_CAPTION_N }" columnCount="1" labelWidth="${labelWidth }" onEnter="doSearch">
        	<e:row>
                <e:label for="SEARCH_WORD" title="${form_SEARCH_WORD_N }" />
                <e:field>
                	<e:inputText id="SEARCH_WORD" name="SEARCH_WORD" value="${param.searchWord }" width="${form_SEARCH_WORD_W }" readOnly="${form_SEARCH_WORD_RO }" maxLength="${form_SEARCH_WORD_M }" required="${form_SEARCH_WORD_R }" disabled="${form_SEARCH_WORD_D }" style="ime-mode: inactive;"  maskType="${form_SEARCH_WORD_MT}" />
                </e:field>
            </e:row>
        </e:searchPanel>

        <e:buttonBar id="buttonBar" align="right" width="100%">
            <e:button id="Search" name="Search" label="${Search_N }" disabled="${Search_D }" onClick="doSearch" />
            <e:button id="Close" name="Close" label="${Close_N }" disabled="${Close_D }" onClick="doClose" />
        </e:buttonBar>

        <e:gridPanel id="grid" name="grid" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}"/>

    </e:window>
</e:ui>