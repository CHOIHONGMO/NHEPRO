<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
    <script type="text/javascript">
        var grid;
        var baseUrl = "/eversrm/backup/fileBackup/";

        function init() {
            grid = EVF.C("grid");

            grid.setProperty("shrinkToFit", true);
            grid.setProperty("rowNumbers", true);
            grid.setProperty("sortable", true);
            grid.setProperty("panelVisible", false);
            grid.setProperty("multiSelect", true);
            grid.setProperty("singleSelect", false);

            doSearch();
        }

        function doSearch() {
            var store = new EVF.Store();
            if(!store.validate()) { return; }
            store.setGrid([grid]);
            store.load(baseUrl + "selectOldFiles.so", function() {
                if(grid.getRowCount() == 0){
                    EVF.alert("${msg.M0002 }");
                }
            });
        }

        function doRequestApproval() {
            if (grid.getSelRowCount() == 0) {
                return EVF.alert("${msg.M0004}");
            }

            EVF.confirm("선택한 파일들에 대해 삭제 결재를 상신하시겠습니까?", function () {
                var store = new EVF.Store();
                store.setGrid([grid]);
                store.getGridData(grid, "sel");
                store.load(baseUrl + "requestApproval.so", function() {
                    EVF.alert(this.getResponseMessage());
                    doSearch();
                });
            });
        }

    </script>

    <e:window id="fileDeleteList" onReady="init" initData="${initData}" title="보관중인 파일 삭제 신청 (5년 경과 대상)" breadCrumbs="${breadCrumb }">
        <e:searchPanel id="sp" title="${form_CAPTION_N}" labelWidth="120px" useTitleBar="false" width="100%" columnCount="3" onEnter="doSearch">
            <e:row>
                <e:label for="REAL_FILE_NM" title="파일명"/>
                <e:field>
                    <e:inputText id="REAL_FILE_NM" name="REAL_FILE_NM" value="" width="100%" maxLength="100" />
                </e:field>
                <e:label for="REG_USER_NM" title="등록자명"/>
                <e:field>
                    <e:inputText id="REG_USER_NM" name="REG_USER_NM" value="" width="100%" maxLength="50" />
                </e:field>
                <e:label for="BIZ_TYPE" title="업무 구분"/>
                <e:field>
                    <e:inputText id="BIZ_TYPE" name="BIZ_TYPE" value="" width="100%" maxLength="10" placeHolder="예: PR, BID 등" />
                </e:field>
            </e:row>
        </e:searchPanel>

        <e:buttonBar width="100%" align="right">
            <e:button id="doSearch" name="doSearch" label="조회" onClick="doSearch" />
            <e:button id="doRequestApproval" name="doRequestApproval" label="삭제 결재 상신" onClick="doRequestApproval" />
        </e:buttonBar>

        <e:gridPanel id="grid" name="grid" width="100%" height="fit" gridType="${_gridType}" readOnly="false" />
    </e:window>
</e:ui>
