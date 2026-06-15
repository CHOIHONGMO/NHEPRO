<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
    <script type="text/javascript">

    	var grid = {};
    	var addParam = [];
    	var baseUrl = "/eversrm/manager/basic/";
    	var eventRowIdx;

		function init() {

			grid = EVF.C('grid');

            grid.cellClickEvent(function(rowIdx, colIdx, value) {

                eventRowIdx = rowIdx;

                if(colIdx == "COMPANY_NM") {
                    if(EVF.isEmpty(grid.getCellValue(rowIdx, 'COMPANY_CD'))) {
                        var param = {
                            callBackFunction: "selectCustGrid",
                            rowIdx: rowIdx
                        };
                        everPopup.openCommonPopup(param, 'SP0067');
                    }
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
			    addParam = [{"USE_FLAG": "1", "DB_FLAG": "I"}];
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
        }

        function doSearch() {

        	var store = new EVF.Store();
            if(!store.validate()) { return; }

        	store.setGrid([grid]);
            store.load(baseUrl + 'doSearch.so', function() {
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
                store.load(baseUrl + 'doSave.so', function(){
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
                store.load(baseUrl + 'doDelete.so', function(){
                    EVF.alert(this.getResponseMessage(), function() {
                        doSearch();
                    });
                });
            });
	    }

		function doTest() {

			if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

            if (grid.getSelRowCount() > 1) { return EVF.alert("${msg.M0006}"); }

			EVF.confirm("${MBSA0010_0002 }", function() {
                var store = new EVF.Store();
                store.setGrid([grid]);
                store.getGridData(grid, 'sel');
                store.load(baseUrl + 'doTest.so', function(){
                    var newNum = this.getParameter("newNum");
                    EVF.alert(newNum, function() {
                        doSearch();
                    });
                });
            });
	    }

        function searchCust() {
            var param = {
                callBackFunction : "selectCust"
            };
            everPopup.openCommonPopup(param, 'SP0067');
        }

        function selectCust(data) {
            EVF.V("COMPANY_CD", data.CUST_CD);
            EVF.V("COMPANY_NM", data.CUST_NM);
        }

        function selectCustGrid(data) {
		    grid.setCellValue(eventRowIdx, 'COMPANY_CD', data.CUST_CD);
		    grid.setCellValue(eventRowIdx, 'COMPANY_NM', data.CUST_NM);
        }

    </script>
    <e:window id="MBSA0010" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">
        <e:searchPanel id="form" title="${form_SC_TEXT_N }" columnCount="3" labelWidth="${labelWidth }" onEnter="doSearch" useTitleBar="false">
        	<e:row>
                <e:label for="DOC_TYPE" title="${form_DOC_TYPE_N}"/>
                <e:field>
                    <e:select id="DOC_TYPE" name="DOC_TYPE" value="" options="${docTypeOptions}" width="${form_DOC_TYPE_W}" disabled="${form_DOC_TYPE_D}" readOnly="${form_DOC_TYPE_RO}" required="${form_DOC_TYPE_R}" placeHolder=""  maskType="${form_DOC_TYPE_MT}" useMultipleSelect="true" singleSelect="true"/>
                </e:field>
                <e:label for="COMPANY_NM" title="${form_COMPANY_NM_N}"/>
                <e:field>
                    <e:search id="COMPANY_CD" name="COMPANY_CD" value="${ses.companyCd }" width="40%" maxLength="${form_COMPANY_CD_M}" onIconClick="${form_COMPANY_CD_D ? 'everCommon.blank' : 'searchCust'}" disabled="${form_COMPANY_CD_D}" readOnly="${form_COMPANY_CD_RO}" required="${form_COMPANY_CD_R}" maskType="${form_COMPANY_CD_MT}" />
                    <e:inputText id="COMPANY_NM" name="COMPANY_NM" value="${ses.companyNm }" width="60%" maxLength="${form_COMPANY_NM_M}" disabled="${form_COMPANY_NM_D}" readOnly="${form_COMPANY_NM_RO}" required="${form_COMPANY_NM_R}" maskType="${form_COMPANY_NM_MT}" />
                </e:field>
                <e:label for="PREFIX_STRING" title="${form_PREFIX_STRING_N }" />
                <e:field>
                	<e:inputText id="PREFIX_STRING" name="PREFIX_STRING" width="${form_PREFIX_STRING_W }" required="${form_PREFIX_STRING_R }" disabled="${form_PREFIX_STRING_D }" value="" readOnly="${form_PREFIX_STRING_RO }" maxLength="${form_PREFIX_STRING_M}" maskType="${form_PREFIX_STRING_MT}" />
                </e:field>
            </e:row>
        </e:searchPanel>

        <e:buttonBar id="buttonBar" align="right" width="100%">
			<e:button id="doSearch" name="doSearch" label="${doSearch_N}" onClick="doSearch" disabled="${doSearch_D}" visible="${doSearch_V}"/>
			<e:button id="doSave" name="doSave" label="${doSave_N}" onClick="doSave" disabled="${doSave_D}" visible="${doSave_V}"/>
			<e:button id="doDelete" name="doDelete" label="${doDelete_N}" onClick="doDelete" disabled="${doDelete_D}" visible="${doDelete_V}"/>
			<e:button id="doTest" name="doTest" label="${doTest_N}" onClick="doTest" disabled="${doTest_D}" visible="${doTest_V}"/>
        </e:buttonBar>

        <e:gridPanel gridType="${_gridType}" id="grid" name="grid" width="100%" height="fit" readOnly="${param.detailView}"/>

    </e:window>
</e:ui>