<%--기준정보 > 고객사정보관리 > 고객사관리--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">

    <script type="text/javascript">

        var grid;
        var baseUrl = "/nhepro/OCUR/";

        function init() {

            grid = EVF.C("grid");

            grid.cellClickEvent(function(rowIdx, colIdx, value) {

                if (colIdx == "USER_ID") {
                    var param = {
                        'USER_ID': grid.getCellValue(rowIdx, 'ORI_USER_ID'),
                        'detailView': false,
                        'popupFlag': true
                    };
                    everPopup.openPopupByScreenId("OCUR0031", 900, 700, param);
                }
                if (colIdx == 'BLOCK_REASON') {
                    var param = {
                        title: "${OCUR0030_008}",
                        message: grid.getCellValue(rowIdx, 'BLOCK_REASON'),
                        callbackFunction: 'setRMK',
                        rowIdx: rowIdx
                    };
                    everPopup.commonTextInput(param);
                }
            });

            grid.excelExportEvent({
                allItems : "${excelExport.allCol}",
                fileName : "${screenName }"
            });

            grid.setProperty('shrinkToFit', ${shrinkToFit});		// 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
            grid.setProperty('rowNumbers', ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
            grid.setProperty('sortable', ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
            grid.setProperty('panelVisible', ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            grid.setProperty('enterToNextRow', ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            grid.setProperty('acceptZero', ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            grid.setProperty('singleSelect', ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]
            grid.setProperty('multiSelect', ${param.detailView == true ? false : multiSelect}); // [선택] 컬럼의 사용여부를 지정한다. [true/false]

            EVF.V("USER_TYPE", "B");
            EVF.C("USER_TYPE").setDisabled(true);
        }

        function doSearch() {

            var store = new EVF.Store();
            if(!store.validate()) { return; }

            if(EVF.isEmpty(EVF.V("USER_TYPE")) && EVF.isEmpty(EVF.V("USER_ID")) && EVF.isEmpty(EVF.V("USER_NM")) &&
                EVF.isEmpty(EVF.V("FROM_DATE")) && EVF.isEmpty(EVF.V("TO_DATE")) && EVF.isEmpty(EVF.V("DEPT_NM")) &&
                EVF.isEmpty(EVF.V("CUST_CD")) && EVF.isEmpty(EVF.V("CUST_NM"))) {
                return EVF.alert("${OCUR0030_001}");
            }

            store.setGrid([grid]);
            store.load(baseUrl + 'ocur0030_doSearch.so', function() {
                if(grid.getRowCount() == 0){
                    EVF.alert("${msg.M0002 }");
                }
                grid.setColIconify("BLOCK_REASON", "BLOCK_REASON", "comment", false);
            });
        }

        function doInsert() {
            var param = {
                'USER_ID': '',
                'detailView': false,
                'popupFlag': true
            };
            everPopup.openPopupByScreenId("OCUR0031", 900, 700, param);
        }

        function doSave() {

            if(grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

            if (!grid.validate().flag) { return EVF.alert(grid.validate().msg); }

            EVF.confirm('${msg.M0021}', function () {

                var rowIds = grid.getSelRowId();
                for( var i in rowIds ) {
                    if( grid.getCellValue(rowIds[i], 'MNG_YN') == "1" && grid.getCellValue(rowIds[i], 'BLOCK_FLAG') == "1" ) {
                        return EVF.alert("${OCUR0030_005}");
                    }
                }

                var store = new EVF.Store();
                store.setGrid([grid]);
                store.getGridData(grid, 'sel');
                store.load(baseUrl + 'ocur0030_doUpdate.so', function() {
                    EVF.alert(this.getResponseMessage(), function() {
                        doSearch();
                    });
                });
            });
        }

        function doDelete() {

            if(grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

            var rowIds = grid.getSelRowId();
            for(var i in rowIds) {
                if(EVF.isEmpty(grid.getCellValue(rowIds[i], 'BLOCK_REASON'))) {
                    return EVF.alert("${OCUR0030_009}");
                }
            }

            EVF.confirm("${msg.M0013 }", function () {
                var store = new EVF.Store();
                store.setGrid([grid]);
                store.getGridData(grid, 'sel');
                store.load(baseUrl + 'ocur0030_doDelete.so', function() {
                    EVF.alert(this.getResponseMessage(), function() {
                        doSearch();
                    });
                });
            });
        }

        function doInitPass() {

            EVF.confirm("${OCUR0030_007}", function () {
                var store = new EVF.Store();
                store.setGrid([grid]);
                store.getGridData(grid, 'sel');
                store.load(baseUrl + 'ocur0030_doInitPassword.so', function () {
                    EVF.alert(this.getResponseMessage(), function() {
                        doSearch();
                    });
                });
            });
        }

        function doResetPwd() {
            EVF.confirm("${OCUR0030_010}", function () {
                var store = new EVF.Store();
                store.setGrid([grid]);
                store.getGridData(grid, 'sel');
                store.load(baseUrl + 'ocur0030_doResetPwd.so', function () {
                    EVF.alert(this.getResponseMessage(), function() {
                        doSearch();
                    });
                });
            });
        }

        function setRMK(data) {
            grid.setCellValue(data.rowIdx, "BLOCK_REASON", data.message);
            grid.setColIconify("BLOCK_REASON", "BLOCK_REASON", "comment", false);
        }

        function searchCust() {
            var param = {
                callBackFunction : "selectCust"
            };
            everPopup.openCommonPopup(param, 'SP0066');
        }

        function selectCust(dataJsonArray) {
            EVF.V("CUST_CD", dataJsonArray.CUST_CD);
            EVF.V("CUST_NM", dataJsonArray.CUST_NM);
        }

        function clearCust() {
            EVF.V("CUST_CD", "");
        }

    </script>
    <e:window id="OCUR0030" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">
        <e:searchPanel id="form" title="${msg.M9999 }" columnCount="3" labelWidth="${labelWidth }" useTitleBar="false" onEnter="doSearch">
            <e:row>
                <e:label for="USER_TYPE" title="${form_USER_TYPE_N}"/>
                <e:field>
                    <e:select id="USER_TYPE" name="USER_TYPE" value="" options="${userTypeOptions}" width="${form_USER_TYPE_W}" disabled="${form_USER_TYPE_D}" readOnly="${form_USER_TYPE_RO}" required="${form_USER_TYPE_R}" placeHolder=""  maskType="${form_USER_TYPE_MT}"/>
                </e:field>
                <e:label for="USER_ID" title="${form_USER_ID_N }" />
                <e:field>
                    <e:inputText id="USER_ID" name="USER_ID" value=""   readOnly="${form_USER_ID_RO }"   maxLength="${form_USER_ID_M}"  width="${form_USER_ID_W }" required="${form_USER_ID_R }" disabled="${form_USER_ID_D }" onFocus="onFocus"  maskType="${form_USER_ID_MT}" />
                </e:field>
                <e:label for="USER_NM" title="${form_USER_NM_N }" />
                <e:field>
                    <e:inputText id="USER_NM" name="USER_NM" value=""   readOnly="${form_USER_NM_RO }"   maxLength="${form_USER_NM_M}"  width="${form_USER_NM_W }" required="${form_USER_NM_R }" disabled="${form_USER_NM_D }" onFocus="onFocus"  maskType="${form_USER_NM_MT}" />
                </e:field>
            </e:row>
            <e:row>
                <e:label for="FROM_DATE" title="${form_FROM_DATE_N }" />
                <e:field>
                    <e:inputDate id="FROM_DATE" name="FROM_DATE" toDate="TO_DATE" value="" width="${inputDateWidth}" datePicker="true" required="${form_FROM_DATE_R}" disabled="${form_FROM_DATE_D}" readOnly="${form_FROM_DATE_RO}" />
                    <e:text>~</e:text>
                    <e:inputDate id="TO_DATE" name="TO_DATE" fromDate="FROM_DATE" value="" width="${inputDateWidth}" datePicker="true" required="${form_TO_DATE_R}" disabled="${form_TO_DATE_D}" readOnly="${form_TO_DATE_RO}" />
                </e:field>
                <e:label for="CUST_NM" title="${form_CUST_NM_N}"/>
                <e:field>
                    <e:search id="CUST_CD" name="CUST_CD" value="" width="40%" maxLength="${form_CUST_CD_M}" onIconClick="${form_CUST_CD_D ? 'everCommon.blank' : 'searchCust'}" disabled="${form_CUST_CD_D}" readOnly="${form_CUST_CD_RO}" required="${form_CUST_CD_R}" maskType="${form_CUST_CD_MT}" placeHolder="회사코드" />
                    <e:inputText id="CUST_NM" name="CUST_NM" value="" width="60%" maxLength="${form_CUST_NM_M}" disabled="${form_CUST_NM_D}" readOnly="${form_CUST_NM_RO}" required="${form_CUST_NM_R}"  maskType="${form_CUST_NM_MT}" placeHolder="회사명" />
                </e:field>
                <e:label for="DEPT_NM" title="${form_DEPT_NM_N }" />
                <e:field>
                    <e:inputText id="DEPT_NM" name="DEPT_NM" value=""   readOnly="${form_DEPT_NM_RO }"   maxLength="${form_DEPT_NM_M}"  width="${form_DEPT_NM_W }" required="${form_DEPT_NM_R }" disabled="${form_DEPT_NM_D }" onFocus="onFocus"  maskType="${form_DEPT_NM_MT}" />
                </e:field>
            </e:row>
        </e:searchPanel>

        <e:buttonBar id="buttonBar" align="right" width="100%">
            <e:button id="Search" name="Search" label="${Search_N }" disabled="${Search_D }" visible="${Search_V}" onClick="doSearch" />
            <e:button id="Insert" name="Insert" label="${Insert_N }" disabled="${Insert_D }" visible="${Insert_V}" onClick="doInsert" />
            <%-- e:button id="Save" name="Save" label="${Save_N }" disabled="${Save_D }" visible="${Save_V}" onClick="doSave" / --%>
            <e:button id="Delete" name="Delete" label="${Delete_N }" disabled="${Delete_D }" visible="${Delete_V}" onClick="doDelete" />
            <e:button id="InitPass" name="InitPass" label="${InitPass_N}" onClick="doInitPass" disabled="${InitPass_D}" visible="${InitPass_V}"/>
            <e:button id="resetPwd" name="resetPwd" label="${resetPwd_N}" onClick="doResetPwd" disabled="${resetPwd_D}" visible="${resetPwd_V?(ses.superUserFlag=='1'?true:false):resetPwd_V}"/>
        </e:buttonBar>

        <e:gridPanel id="grid" name="grid" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}"/>

    </e:window>
</e:ui>