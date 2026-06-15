<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
    <script type="text/javascript">

    	var grid = {};
    	var addParam = [];
    	var baseUrl = "/eversrm/manager/menu/MNUA0016/";

		function init() {

			grid = EVF.C('grid');

			grid.cellClickEvent(function(rowIdx, colIdx, value) {

				if(colIdx == 'TMPL_MENU_GROUP_CD') {

					var selectedData = grid.getRowValue(rowIdx);

					if('${param.rowIdx}' !== ''){
						selectedData.rowIdx = Number('${param.rowIdx}');
					}
			        opener.${param.callBackFunction}(selectedData);
			        doClose();
			    }
			});

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

			doSearch();
        }

        function doSearch() {

        	var store = new EVF.Store();
        	store.setGrid([grid]);
            store.load(baseUrl + 'doSelect.so', function() {
                if(grid.getRowCount() == 0){
                	EVF.alert("${msg.M0002 }");
                }
            });
        }

        function doClose() {
	        EVF.closeWindow();
	    }

    </script>
    <e:window id="MNUA0016" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">
        <e:searchPanel id="form" title="" columnCount="3" labelWidth="${longLabelWidth }" useTitleBar="false" onEnter="doSearch">
        	<e:row>
                <e:label for="MODULE_TYPE" title="${form_MODULE_TYPE_N }" />
                <e:field>
                    <e:select id="MODULE_TYPE" name="MODULE_TYPE" value="" options="${moduleTypeOptions}" readOnly="${form_MODULE_TYPE_RO }" width="140px" required="${form_MODULE_TYPE_R }" disabled="${form_MODULE_TYPE_D }"  maskType="${form_MODULE_TYPE_MT}"/>
                </e:field>
                <e:label for="TMPL_MENU_GROUP_CD" title="${form_TMPL_MENU_GROUP_CD_N }" />
                <e:field>
                	<e:inputText id="TMPL_MENU_GROUP_CD" name="TMPL_MENU_GROUP_CD" width="148px" required="${form_TMPL_MENU_GROUP_CD_R }" disabled="${form_TMPL_MENU_GROUP_CD_D }" readOnly="${form_TMPL_MENU_GROUP_CD_RO }" maxLength="${form_TMPL_MENU_GROUP_CD_M}"  maskType="${form_TMPL_MENU_GROUP_CD_MT}" />
                </e:field>
				<e:label for="TMPL_MENU_GROUP_NM" title="${form_TMPL_MENU_GROUP_NM_N }" />
                <e:field>
                	<e:inputText id="TMPL_MENU_GROUP_NM" name="TMPL_MENU_GROUP_NM" width="148px" required="${form_TMPL_MENU_GROUP_NM_R }" disabled="${form_TMPL_MENU_GROUP_NM_D }" readOnly="${form_TMPL_MENU_GROUP_NMD_RO }" maxLength="${form_TMPL_MENU_GROUP_NM_M}" maskType="${form_TMPL_MENU_GROUP_NM_MT}" />
                </e:field>
            </e:row>
        </e:searchPanel>

        <e:buttonBar id="buttonBar" align="right" width="100%">
            <e:button id="Search" name="Search" label="${Search_N }" disabled="${Search_D }" onClick="doSearch" />
            <e:button id="Close" name="Close" label="${Close_N }" disabled="${Close_D }" onClick="doClose" />
        </e:buttonBar>

        <e:gridPanel gridType="${_gridType}" id="grid" name="grid" width="100%" height="fit" readOnly="${param.detailView}"/>

    </e:window>
</e:ui>