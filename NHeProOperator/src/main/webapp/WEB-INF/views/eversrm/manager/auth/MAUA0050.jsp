<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
    <script type="text/javascript">
        var baseUrl = "/eversrm/manager/auth/MAUA0050/";
        var grid = {};

        function init() {

            grid = EVF.C("grid");

            grid.setProperty('shrinkToFit', ${shrinkToFit});		// 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
            grid.setProperty('rowNumbers', ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
            grid.setProperty('sortable', ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
            grid.setProperty('panelVisible', ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            grid.setProperty('enterToNextRow', ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            grid.setProperty('acceptZero', ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            grid.setProperty('multiSelect', ${param.detailView == true ? false : multiSelect}); // [선택] 컬럼의 사용여부를 지정한다. [true/false]

            grid.excelExportEvent({
                allItems: "${excelExport.allCol}",
                fileName: "${screenName }"
            });

            grid.addRowEvent(function() {
                grid.addRow({
                    USE_FLAG: "1"
                });
            });

            grid.dupRowEvent(function(rowId) {
            }, ["DEPT_CD", "DEPT_NM", "USE_FLAG"]);

            grid.cellClickEvent(function(rowId, colId, value) {

                if(colId == 'DEPT_NM') {
                    var param = {
                        multiYN: "false",
                        callbackFunction: "setDeptInfo",
                        rowId: rowId,
                        detailView: false,
                        buyerCd : EVF.V('BUYER_CD')
                    };
                    everPopup.openPopupByScreenId('MOGA0032', 400, 600, param);
                }

            });

        }

        function setDeptInfo(data) {
            data = JSON.parse(data);
            grid.setCellValue(data.rowId, 'DEPT_CD', data.DEPT_CD);
            grid.setCellValue(data.rowId, 'DEPT_NM', data.DEPT_NM);
        }

        function doSearch() {

            var store = new EVF.Store();
            store.setGrid([grid]);
            store.load(baseUrl + 'doSearch.so', function () {
                if (grid.getRowCount() == 0) {
                    EVF.alert("${msg.M0002 }");
                }
            });

        }

        function doSave() {

            if (!grid.getSelRowCount()) {
                EVF.alert("${msg.M0004}");
                return;
            }

            if(!grid.validate().flag) {
                return EVF.alert(grid.validate().msg);
            }

            EVF.confirm("${msg.M0021}", function() {
                var store = new EVF.Store();
                store.setGrid([grid]);
                store.getGridData(grid, 'sel');
                store.load(baseUrl + 'doSave.so', function () {
                    EVF.alert(this.getResponseMessage());
                    doSearch();
                });
            });
        }

        function doDelete() {

            if (!grid.getSelRowCount()) {
                EVF.alert("${msg.M0004}");
                return;
            }

            var selRowId = grid.getSelRowId();
            for(var i in selRowId) {
                var rowId = selRowId[i];
                if(grid.getCellValue(rowId, 'ECCD_NUM') == '') {
                    return EVF.alert('아직 저장되지 않은 데이터입니다.');
                }
            }

            EVF.confirm("${msg.M0013}", function() {
                var store = new EVF.Store();
                store.setGrid([grid]);
                store.getGridData(grid, 'sel');
                store.load(baseUrl + 'doDelete.so', function () {
                    EVF.alert(this.getResponseMessage());
                    doSearch();
                });
            });

        }

    </script>

    <e:window id="MAUA0050" onReady="init" initData="${initData}" width="100%" height="100%" name="${screenName}" title="${fullScreenName}">
        <e:searchPanel id="frmLeft" useTitleBar="false" labelWidth="${labelWidth}" width="100%" columnCount="2" onEnter="doSearch">
            <e:row>
                <e:label for="BUYER_CD" title="${form_BUYER_CD_N}"/>
                <e:field>
                    <e:select id="BUYER_CD" name="BUYER_CD" value="${form.BUYER_CD}" options="${buyerCdOptions}" width="100%" disabled="${form_BUYER_CD_D}" readOnly="${form_BUYER_CD_RO}" required="${form_BUYER_CD_R}" placeHolder="" usePlaceHolder="false"  maskType="${form_BUYER_CD_MT}"/>
                </e:field>
                <e:label for="DEPT_NM" title="${form_DEPT_NM_N}"/>
                <e:field>
                    <e:inputText id="DEPT_NM" name="DEPT_NM" value="" width="100%" maxLength="${form_DEPT_NM_M}" disabled="${form_DEPT_NM_D}" readOnly="${form_DEPT_NM_RO}" required="${form_DEPT_NM_R}" placeHolder=""  maskType="${form_DEPT_NM_MT}" />
                </e:field>
            </e:row>
            <e:row>
                <e:label for="FORM_ROLE_TYPE" title="${form_FORM_ROLE_TYPE_N}"/>
                <e:field colSpan="3">
                    <e:select id="FORM_ROLE_TYPE" name="FORM_ROLE_TYPE" value="" options="${formRoleTypeOptions}" width="100%" disabled="${form_FORM_ROLE_TYPE_D}" readOnly="${form_FORM_ROLE_TYPE_RO}" required="${form_FORM_ROLE_TYPE_R}" placeHolder=""  maskType="${form_FORM_ROLE_TYPE_MT}"/>
                </e:field>
            </e:row>
        </e:searchPanel>

        <e:buttonBar id="a" width="100%" align="right">
            <e:button id="doSearch" name="doSearch" label="${doSearch_N}" onClick="doSearch" disabled="${doSearch_D}" visible="${doSearch_V}"/>
            <e:button id="doSave" name="doSave" label="${doSave_N}" onClick="doSave" disabled="${doSave_D}" visible="${doSave_V}"/>
            <e:button id="doDelete" name="doDelete" label="${doDelete_N}" onClick="doDelete" disabled="${doDelete_D}" visible="${doDelete_V}"/>
        </e:buttonBar>

        <e:gridPanel gridType="${_gridType}" id="grid" name="grid" width="100%" height="100%" readOnly="${param.detailView}"/>
    </e:window>
</e:ui>

