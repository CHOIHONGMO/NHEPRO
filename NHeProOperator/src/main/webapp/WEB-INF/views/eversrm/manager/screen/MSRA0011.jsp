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

			if ('${param.screenId}' != '') {
	            EVF.V('SCREEN_ID', '${param.screenId}');
	            doSearch();
	        }

			grid.cellClickEvent(function(rowid, celname, value, iRow, iCol) {
				if (celname == "SCREEN_ID") {
					var selectedData = grid.getRowValue(rowid);
		       		opener.selectScreen(selectedData);
		       		EVF.closeWindow();
		        }
			});
        }

        function search() {

        	var store = new EVF.Store();
        	store.setGrid([grid]);
            store.load(baseUrl + 'screenIdPopup/doSearch.so', function() {
                if(grid.getRowCount() == 0){
                	EVF.alert("${msg.M0002 }");
                }
            });
        }

	    function close2() {
	        EVF.closeWindow();
	    }

    </script>
    <e:window id="MSRA0011" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">
        <e:searchPanel id="form" title="${msg.M9999}" columnCount="3" labelWidth="${labelWidth }" onEnter="search" useTitleBar="false">
        	<e:row>
                <e:label for="MODULE_TYPE" title="${form_MODULE_TYPE_N }" />
                <e:field>
                    <e:select id="MODULE_TYPE" name="MODULE_TYPE" options="${moduleTypeOptions}" readOnly="${form_MODULE_TYPE_RO }" width="160" required="${form_MODULE_TYPE_R }" disabled="${form_MODULE_TYPE_D }" onFocus="onFocus"  maskType="${form_MODULE_TYPE_MT}"/>
                </e:field>
                <e:label for="st_SCREEN_ID" title="${form_SCREEN_ID_N }" />
                <e:field>
                	<e:inputText id="SCREEN_ID" name="SCREEN_ID" width="${form_SCREEN_ID_W }" required="${form_SCREEN_ID_R }" disabled="${form_SCREEN_ID_D }" value="" style="${imeMode }" readOnly="${form_SCREEN_ID_RO }" maxLength="${form_SCREEN_ID_M}"  maskType="${form_SCREEN_ID_MT}" />
                </e:field>
                <e:label for="st_SCREEN_NM" title="${form_SCREEN_NM_N }" />
                <e:field>
	                <e:inputText id="SCREEN_NM" name="SCREEN_NM" width="${form_SCREEN_NM_W }" required="${form_SCREEN_NM_R }" disabled="${form_SCREEN_NM_D }" style="${imeMode }" readOnly="${form_SCREEN_NM_RO }" maxLength="${form_SCREEN_NM_M}"  maskType="${form_SCREEN_NM_MT}" />
                </e:field>
            </e:row>
			<e:row>
				<e:label for="st_SCREEN_URL" title="${form_SCREEN_URL_N }" />
                <e:field colSpan="5">
                	<e:inputText id="SCREEN_URL" name="SCREEN_URL" width="${form_SCREEN_URL_W }" required="${form_SCREEN_URL_R }" disabled="${form_SCREEN_URL_D }" style="${imeMode }" readOnly="${form_SCREEN_URL_RO }" maxLength="${form_SCREEN_URL_M}" maskType="${form_SCREEN_URL_MT}" />
                </e:field>
            </e:row>
        </e:searchPanel>
        <e:buttonBar id="buttonBar" align="right" width="100%">
            <e:button id="Search" name="Search" label="${Search_N }" disabled="${Search_D }" onClick="search" />
            <e:button id="Close" name="Close"  label="${Close_N }" disabled="${Close_D }" onClick="close2" />
        </e:buttonBar>

        <e:gridPanel id="grid" name="grid" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}"/>

    </e:window>
</e:ui>