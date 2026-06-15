<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
    <script type="text/javascript">

    	var grid = {};
    	var addParam = [];
    	var baseUrl = "/eversrm/manager/screen/";
    	var flag = "";

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
				grid.addRow([{"LANG_CD": "${ses.langCd}"}]);
			});

			var choose_button_visibility = '${param.choose_button_visibility}';
	        if (choose_button_visibility === 'false') {
	            EVF.C('Choose').setVisible(false);
	        }

	        doSearch();
        }

        function doSearch() {

        	var store = new EVF.Store();
        	store.setGrid([grid]);
        	store.setParameter('multi_cd', EVF.V('multi_cd'));
	        store.setParameter('screen_id', EVF.V('screen_id'));
	        store.setParameter('tmpl_menu_group_cd', EVF.V('tmpl_menu_group_cd'));
	        store.setParameter('auth_cd', EVF.V('auth_cd'));
	        store.setParameter('menu_group_cd', EVF.V('menu_group_cd'));
	        store.setParameter('action_cd', EVF.V('action_cd'));
	        store.setParameter('action_profile_cd', EVF.V('action_profile_cd'));
	        store.setParameter('tmpl_menu_cd', EVF.V('tmpl_menu_cd'));
	        store.setParameter('common_id', EVF.V('common_id'));

	        if (EVF.V('screen_id') == "" && EVF.V('tmpl_menu_group_cd') == "" && EVF.V('auth_cd') == "" && EVF.V('menu_group_cd') == "" && EVF.V('action_cd') == "" && EVF.V('action_profile_cd') == "" && EVF.V('tmpl_menu_cd') == "" && EVF.V('common_id') == "") {
	            EVF.alert("There is not exists parameter value. Please enter parameter value.");
	            return;
	        }

            store.load(baseUrl + 'MSRA0031/doSearch.so', function() {
                if(grid.getRowCount() == 0) {
                    //	EVF.alert("${msg.M0002 }");
	                grid.addRow([{"LANG_CD": "${ses.langCd}"}]);
                }
                grid.checkAll(true);
            });
        }

        function doSave() {

        	if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
			if (!grid.validate().flag) {
				return EVF.alert(grid.validate().msg);
			}

			var rowIds = grid.getSelRowId();
			var rowData1 = {};
			var rowData2 = {};

			for(var i in rowIds) {

				rowData1 = grid.getRowValue(rowIds[i]);

				for(var j in rowIds) {
					if(rowIds[i] == rowIds[j]) { continue; }

					rowData2 = grid.getRowValue(rowIds[j]);

					if (rowData1.LANG_CD == rowData2.LANG_CD) {
                        return EVF.alert("${msg.M0086 }");
	                }
				}
			}

            EVF.confirm("${msg.M0021 }", function () {

                var store = new EVF.Store();
                store.setGrid([grid]);
                store.getGridData(grid, 'sel');
                store.load(baseUrl + 'MSRA0031/doSave.so', function(){
                    EVF.alert(this.getResponseMessage());
                    flag = 1;
                    doSearch();
                    if('${param.choose_button_visibility}' == 'false') {
                        parent['${param.callBackFunction}']();
                        doClose();
                    }
                });
            });
        }

		function doDelete() {

			if (grid.getSelRowCount() == 0) {
	            return EVF.alert("${msg.M0004}");
	        }

            EVF.confirm("${msg.M0013 }", function () {

                var store = new EVF.Store();
                store.setGrid([grid]);
                store.getGridData(grid, 'sel');
                store.load(baseUrl + 'MSRA0031/doDelete.so', function(){
                    EVF.alert(this.getResponseMessage());
                    doSearch();
                });
            });
	    }

        function doChoose() {

	        var multi_cd = EVF.V('multi_cd');
	        var checkRowId = grid.getSelRowId();
	        var chkRowIdLen = grid.getSelRowCount();
	        var rowData = {};
	        var multiNm = "";
            var multi_Desc = "";

	        if (grid.getSelRowCount() == 0) {
	            return EVF.alert("${msg.M0004}");
	        }
			if (grid.getSelRowCount() > 1) {
	            return EVF.alert("${msg.M0006}");
	        }

			for(var i = 0; i < chkRowIdLen; i++) {
	        	rowData = grid.getRowValue(checkRowId[i]);
	        	multiNm = rowData.MULTI_NM;
	        	multi_Desc = rowData.MULTI_DESC;
	        	if (rowData.INSERT_FLAG !== 'U') {
		            return EVF.alert('${msg.M0007}');
		        }
	        }

	        var multiLanguagePopupReturn = {
		        rowIdx: '${param.rowIdx}',
		        multiCd: multi_cd,
		        multiNm: multiNm,
		        multi_Desc : multi_Desc
	        };

	        parent['${param.callBackFunction}'](multiLanguagePopupReturn);
		    doClose();
	    }

		function doClose() {
	        EVF.closeWindow();
	    }

    </script>
    <e:window id="MSRA0031" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">
        <e:inputHidden id="multi_nm" name="multi_nm" value="${searchParam.multi_nm }"/>
        <e:inputHidden id="multi_cd" name="multi_cd" value="${searchParam.multi_cd }"/>
        <e:inputHidden id="screen_id" name="screen_id" value="${searchParam.screen_id }"/>
        <e:inputHidden id="tmpl_menu_group_cd" name="tmpl_menu_group_cd" value="${searchParam.tmpl_menu_group_cd }"/>
        <e:inputHidden id="auth_cd" name="auth_cd" value="${searchParam.auth_cd }"/>
        <e:inputHidden id="menu_group_cd" name="menu_group_cd" value="${searchParam.menu_group_cd }"/>
        <e:inputHidden id="action_cd" name="action_cd" value="${searchParam.action_cd }"/>
        <e:inputHidden id="action_profile_cd" name="action_profile_cd" value="${searchParam.action_profile_cd }"/>
        <e:inputHidden id="tmpl_menu_cd" name="tmpl_menu_cd" value="${searchParam.tmpl_menu_cd }"/>
        <e:inputHidden id="common_id" name="common_id" value="${searchParam.common_id }"/>

        <e:buttonBar id="buttonBar" align="right" width="100%">
            <e:button id="Choose" name="Choose" label="${Choose_N }" disabled="${Choose_D }" onClick="doChoose" />
            <e:button id="Save" name="Save"  label="${Save_N }" disabled="${Save_D }" onClick="doSave" />
            <e:button id="Delete" name="Delete" label="${Delete_N }" disabled="${Delete_D }" onClick="doDelete" />
            <e:button id="Close" name="Close" label="${Close_N }" disabled="${Close_D }" onClick="doClose" />
        </e:buttonBar>

	    <e:gridPanel id="grid" name="grid" gridType="${_gridType}" width="100%" height="fit" readOnly="${param.detailView}"/>

	</e:window>
</e:ui>