<%@page import="com.st_ones.common.util.clazz.EverDate"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">

    <script type="text/javascript">

        var grid;
        var addParam = [];
        var baseUrl = "/eversrm/manager/basic/";

        function init() {

            grid = EVF.C("grid");

	        grid.addRowEvent(function() {
				grid.addRow();
			});

			grid.delRowEvent(function() {
				if(grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
				grid.delRow();
			});

			grid.excelImportEvent({
                'append': false
            }, function (msg, code) {
            	if (code) {
                    grid.checkAll(true);
                }
            });

			grid.excelExportEvent({
				allItems : "${excelExport.allCol}",
				fileName : "${screenName }"
			});

			grid.setProperty('shrinkToFit', true);					// 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
			grid.setProperty('rowNumbers', ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
			grid.setProperty('sortable', ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
			grid.setProperty('panelVisible', ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
			grid.setProperty('enterToNextRow', ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
			grid.setProperty('acceptZero', ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
			grid.setProperty('singleSelect', ${singleSelect});		//[선택] 컬럼의 다중선택 여부를 지정한다. [true/false]
			grid.setProperty('multiSelect', ${param.detailView == true ? false : multiSelect}); // [선택] 컬럼의 사용여부를 지정한다. [true/false]

        }

        function doSearch() {

	    	var store = new EVF.Store();
			if(!store.validate()) { return; }
	        store.setGrid([grid]);
	        store.load(baseUrl + 'mbsa0030_doSearch.so', function() {
	        	if(grid.getRowCount() == 0){
	            	EVF.alert("${msg.M0002 }");
	            }
	        });
        }

        function doSave() {

	    	if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

	    	if (!grid.validate().flag) { return EVF.alert(grid.validate().msg); }

			EVF.confirm("${msg.M0021 }", function () {
				var store = new EVF.Store();
				store.setGrid([grid]);
				store.getGridData(grid, 'sel');
				store.load(baseUrl + 'mbsa0030_doSave.so', function() {
					EVF.alert(this.getResponseMessage(), function() {
						doSearch();
					});
				});
			});
        }

	    function doDelete() {

	    	if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

			EVF.confirm("${msg.M0013 }", function () {
				var store = new EVF.Store();
				store.setGrid([grid]);
				store.getGridData(grid, 'sel');
				store.load(baseUrl + 'mbsa0030_doDelete.so', function() {
					EVF.alert(this.getResponseMessage(), function() {
						doSearch();
					});
				});
			});
	    }

    </script>
    <e:window id="MBSA0030" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">
		<e:searchPanel id="form" title="${form_CAPTION_N }" labelWidth="${labelWidth}" width="100%" columnCount="3" useTitleBar="false" onEnter="doSearch">
			<e:row>
				<e:label for="YEAR" title="${form_YEAR_N}" />
				<e:field>
					<e:select id="YEAR" name="YEAR" value="<%=EverDate.getYear()%>" options="${yearOptions}" width="100%" required="${form_YEAR_R }" readOnly="${form_YEAR_RO }" disabled="${form_YEAR_D }" useMultipleSelect="true"  maskType="${form_YEAR_MT}"/>
				</e:field>
				<e:label for="MONTH" title="${form_MONTH_N}" />
				<e:field>
					<e:select id="MONTH" name="MONTH" value="<%=EverDate.getMonth()%>" options="${monthOptions}" width="100%" required="${form_MONTH_R }" readOnly="${form_MONTH_RO }" disabled="${form_MONTH_D }" useMultipleSelect="true" usePlaceHolder="false" maskType="${form_MONTH_MT}"/>
				</e:field>
				<e:label for="HOLYDAY_TYPE" title="${form_HOLYDAY_TYPE_N}" />
				<e:field>
					<e:select id="HOLYDAY_TYPE" name="HOLYDAY_TYPE" value="" options="${holydayTypeOptions}" width="100%" required="${form_HOLYDAY_TYPE_R }" readOnly="${form_HOLYDAY_TYPE_RO }" disabled="${form_HOLYDAY_TYPE_D }" useMultipleSelect="true"  maskType="${form_HOLYDAY_TYPE_MT}"/>
				</e:field>
			</e:row>
		</e:searchPanel>

        <e:buttonBar id="buttonBar" align="right" width="100%">
            <e:button id="Search" name="Search" label="${Search_N }" disabled="${Search_D }" visible="${Search_V}" onClick="doSearch" />
            <e:button id="Save" name="Save" label="${Save_N }" disabled="${Save_D }" visible="${Save_V}" onClick="doSave" />
            <e:button id="Delete" name="Delete" label="${Delete_N }" disabled="${Delete_D }" visible="${Delete_V}" onClick="doDelete" />
        </e:buttonBar>

        <e:gridPanel id="grid" name="grid" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}"/>

    </e:window>
</e:ui>