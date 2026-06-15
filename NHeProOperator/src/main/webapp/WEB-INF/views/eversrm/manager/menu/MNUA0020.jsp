<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
    <script type="text/javascript">

    	var grid = {};
    	var addParam = [];
    	var baseUrl = "/eversrm/manager/menu/MNUA0020/";

		function init() {

			grid = EVF.C('grid');

			grid.cellClickEvent(function(rowIdx, colIdx, value) {

				if(colIdx == 'MENU_GROUP_CD') {
					if (grid.getCellValue(rowIdx, 'MENU_GROUP_CD') == '') {
		                EVF.alert("${msg.M0007}");

		            } else {
		                var menuGroupCd = grid.getCellValue(rowIdx, 'MENU_GROUP_CD');
		                var tmplMenuGroupCd = grid.getCellValue(rowIdx, 'TMPL_MENU_GROUP_CD');
		                var gateCd = grid.getCellValue(rowIdx, 'GATE_CD');
		                var moduleType = grid.getCellValue(rowIdx, 'MODULE_TYPE');
		                var params = {
		                    MENU_GROUP_CD: menuGroupCd,
		                    TMPL_MENU_GROUP_CD: tmplMenuGroupCd,
		                    MODULE_TYPE: moduleType,
		                    callBackFunction: 'selectPlantRow'
		                };
						everPopup.openPopupByScreenId('MNUA0015', 1000, 700, params);
		            }
				}
				if (colIdx == 'TMPL_MENU_GROUP_CD') {
		            var params = {
		                rowIdx: rowIdx,
		                callBackFunction: 'selectMenuTemplateGroupCd'
		            };
		            everPopup.openMenuTemplateGroupCodePopup(params);
		        }
		        if (colIdx == 'MENU_GROUP_NM') {
		            var menu_group_cd = grid.getCellValue(rowIdx, 'MENU_GROUP_CD');
		            var params = {
		                multi_cd: 'MG',
		                choose_button_visibility: false,
		                screen_id: '-',
		                menu_group_cd: menu_group_cd,
		                rowIdx: rowIdx
		            };
		            everPopup.openMultiLanguagePopup(params);
		        }
			});

		    grid.setProperty('shrinkToFit', ${shrinkToFit});		// 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
		    grid.setProperty('rowNumbers', ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
		    grid.setProperty('sortable', ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
		    grid.setProperty('panelVisible', ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
		    grid.setProperty('enterToNextRow', ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
		    grid.setProperty('acceptZero', ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
		    grid.setProperty('multiSelect', ${param.detailView == true ? false : multiSelect}); // [선택] 컬럼의 사용여부를 지정한다. [true/false]

			grid.addRowEvent(function() {
				addParam = [{'USE_FLAG': '1', 'INSERT_FLAG': 'C', 'MODULE_TYPE': EVF.V('MODULE_TYPE').length == 0 ? 'MA' : EVF.V('MODULE_TYPE')}];
				grid.addRow(addParam);
			});

			grid.delRowEvent(function() {
				if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
				grid.delRow();
			});

			grid.excelExportEvent({
				allItems : "${excelExport.allCol}",
				fileName : "${screenName }"
			});

			grid.setProperty('shrinkToFit', true);
        }

        function doSearch() {

        	var store = new EVF.Store();
        	store.setGrid([grid]);
            store.load(baseUrl + 'searchMenu.so', function() {
                if(grid.getRowCount() == 0){
                	EVF.alert("${msg.M0002 }");
                }
            });
        }

        function doSave() {

			if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

	        if (!grid.validate().flag) { return EVF.alert(grid.validate().msg); }

	        EVF.confirm("${msg.M0021 }", function() {
				var store = new EVF.Store();
				store.setGrid([grid]);
				store.getGridData(grid, 'sel');
				store.load(baseUrl + 'doSaveMenu.so', function(){
					EVF.alert(this.getResponseMessage(), function() {
						doSearch();
					});
				});
			});
        }

        function doCopy() {

			if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

	        if (!grid.validate().flag) { return EVF.alert(grid.validate().msg); }

			EVF.confirm("${msg.M0021 }", function() {
				var store = new EVF.Store();
				store.setGrid([grid]);
				store.getGridData(grid, 'sel');
				store.load(baseUrl + 'doCopyMenu.so', function(){
					EVF.alert(this.getResponseMessage(), function() {
						doSearch();
					});
				});
			});
        }

		function doDelete() {

			if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

			EVF.confirm("${msg.M0013 }", function() {
				var store = new EVF.Store();
				store.setGrid([grid]);
				store.getGridData(grid, 'sel');
				store.load(baseUrl + 'deleteMenu.so', function(){
					EVF.alert(this.getResponseMessage(), function() {
						doSearch();
					});
				});
			});
        }

        function multiLanguagePopupCallBack(multiLanguagePopupReturn) {
	    	if(! (multiLanguagePopupReturn == null || multiLanguagePopupReturn == '')) {
	        	grid.setCellValue(multiLanguagePopupReturn.rowIdx, 'MENU_GROUP_NM', multiLanguagePopupReturn.multiNm);
	    	}
	    }

	    function selectMenuTemplateGroupCd(data) {
	    	grid.setCellValue(data.rowIdx, 'TMPL_MENU_GROUP_CD', data.TMPL_MENU_GROUP_CD);
	        grid.setCellValue(data.rowIdx, 'TMPL_MENU_GROUP_NM', data.TMPL_MENU_GROUP_NM);
	    }

    </script>
    <e:window id="MNUA0020" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">
        <e:searchPanel id="form" title="${form_CAPTION_N }" columnCount="3" labelWidth="${longLabelWidth }" onEnter="doSearch" useTitleBar="false">
        	<e:row>
                <e:label for="MODULE_TYPE" title="${form_MODULE_TYPE_N }" />
                <e:field>
                    <e:select id="MODULE_TYPE" name="MODULE_TYPE" value="" options="${moduleTypeOptions}" width="100%" readOnly="${form_MODULE_TYPE_RO }" required="${form_MODULE_TYPE_R }" disabled="${form_MODULE_TYPE_D }"  maskType="${form_MODULE_TYPE_MT}"/>
                </e:field>
                <e:label for="st_MENU_GROUP_NM" title="${form_MENU_GROUP_NM_N }" />
                <e:field>
                	<e:inputText id="MENU_GROUP_NM" name="MENU_GROUP_NM" width="100%" required="${form_MENU_GROUP_NM_R }" disabled="${form_MENU_GROUP_NM_D }" readOnly="${form_MENU_GROUP_NM_RO }" maxLength="${form_MENU_GROUP_NM_M}"  maskType="${form_MENU_GROUP_NM_MT}" />
                </e:field>
				<e:label for="TMPL_MENU_GROUP_NM" title="${form_TMPL_MENU_GROUP_NM_N }" />
                <e:field>
                	<e:inputText id="TMPL_MENU_GROUP_NM" name="TMPL_MENU_GROUP_NM" width="100%" required="${form_TMPL_MENU_GROUP_NM_R }" disabled="${form_TMPL_MENU_GROUP_NM_D }" readOnly="${form_TMPL_MENU_GROUP_NM_RO }" maxLength="${form_TMPL_MENU_GROUP_NM_M}"  maskType="${form_TMPL_MENU_GROUP_NM_MT}" />
                </e:field>
            </e:row>
        </e:searchPanel>

        <e:buttonBar id="buttonBar" align="right" width="100%">
            <e:button id="Search" name="Search" label="${Search_N }" disabled="${Search_D }" onClick="doSearch" />
            <e:button id="Save" name="Save" label="${Save_N }" disabled="${Save_D }" onClick="doSave" />
            <e:button id="Delete" name="Delete" label="${Delete_N }" disabled="${Delete_D }" onClick="doDelete" />
            <e:button id="Copy" name="Copy" label="${Copy_N}" onClick="doCopy" disabled="${Copy_D}" visible="${Copy_V}" />
        </e:buttonBar>

        <e:gridPanel gridType="${_gridType}" id="grid" name="grid" width="100%" height="fit" readOnly="${param.detailView}"/>

    </e:window>
</e:ui>