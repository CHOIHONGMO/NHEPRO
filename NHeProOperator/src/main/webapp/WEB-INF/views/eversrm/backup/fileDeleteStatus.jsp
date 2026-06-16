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
            store.load(baseUrl + "selectStatus.so", function() {
                if(grid.getRowCount() == 0){
                    EVF.alert("${msg.M0002 }");
                }
            });
        }

        function doRestore() {
            if (grid.getSelRowCount() == 0) {
                return EVF.alert("${msg.M0004}");
            }

            var selRowValue = grid.getSelRowValue();
            var isInvalid = false;
            for (var i in selRowValue) {
                // 배치로 백업 디렉터리에 이동하기 전(결재완료 또는 결재중) 상태인 것만 복구 가능
                var status = selRowValue[i].SIGN_STATUS;
                if (status != 'E' && status != 'P') {
                    isInvalid = true;
                    break;
                }
            }

            if (isInvalid) {
                return EVF.alert("결재 대기('P') 또는 결재 승인('E') 상태이고 물리 파일 이동 전인 건만 복구할 수 있습니다.");
            }

            EVF.confirm("선택한 결재 문서의 삭제 요청을 취소하고 파일 정보를 복구하시겠습니까?", function () {
                var store = new EVF.Store();
                store.setGrid([grid]);
                store.getGridData(grid, "sel");
                store.load(baseUrl + "restoreFile.so", function() {
                    EVF.alert(this.getResponseMessage());
                    doSearch();
                });
            });
        }

        function runBackupBatch() {
            EVF.confirm("수동으로 결재 승인된 파일의 백업 및 삭제 처리 배치를 실행하시겠습니까?", function() {
                var store = new EVF.Store();
                store.load(baseUrl + "runBackupBatch.so", function() {
                    EVF.alert(this.getResponseMessage());
                    doSearch();
                });
            });
        }

        function runPurgeBatch() {
            EVF.confirm("수동으로 3개월 경과된 백업 파일 영구삭제 배치를 실행하시겠습니까?", function() {
                var store = new EVF.Store();
                store.load(baseUrl + "runPurgeBatch.so", function() {
                    EVF.alert(this.getResponseMessage());
                    doSearch();
                });
            });
        }

    </script>

    <e:window id="fileDeleteStatus" onReady="init" initData="${initData}" title="파일 삭제 및 백업 처리 현황" breadCrumbs="${breadCrumb }">
        <e:searchPanel id="sp" title="${form_CAPTION_N}" labelWidth="120px" useTitleBar="false" width="100%" columnCount="3" onEnter="doSearch">
            <e:row>
                <e:label for="REG_FROM_DATE" title="상신 일자"/>
                <e:field>
                    <e:inputDate id="REG_FROM_DATE" name="REG_FROM_DATE" toDate="REG_TO_DATE" value="${regFromDate}" width="${inputDateWidth}" datePicker="true" />
                    <e:text>&nbsp;~&nbsp;</e:text>
                    <e:inputDate id="REG_TO_DATE" name="REG_TO_DATE" fromDate="REG_FROM_DATE" value="${regToDate}" width="${inputDateWidth}" datePicker="true" />
                </e:field>
                <e:label for="SIGN_STATUS" title="결재 상태"/>
                <e:field>
                    <e:select id="SIGN_STATUS" name="SIGN_STATUS" value="" width="100%">
                        <e:option value="" text="-- 전체 --" />
                        <e:option value="P" text="결재중(상신)" />
                        <e:option value="E" text="승인(완료)" />
                        <e:option value="R" text="반려" />
                        <e:option value="C" text="취소/복구" />
                    </e:select>
                </e:field>
                <e:field />
            </e:row>
        </e:searchPanel>

        <e:buttonBar width="100%" align="right">
            <e:button id="doSearch" name="doSearch" label="조회" onClick="doSearch" />
            <e:button id="doRestore" name="doRestore" label="삭제 복구/취소" onClick="doRestore" />
            <e:button id="runBackupBatch" name="runBackupBatch" label="[수동] 백업배치 실행" onClick="runBackupBatch" />
            <e:button id="runPurgeBatch" name="runPurgeBatch" label="[수동] 영구삭제배치 실행" onClick="runPurgeBatch" />
        </e:buttonBar>

        <e:gridPanel id="grid" name="grid" width="100%" height="fit" gridType="${_gridType}" readOnly="true" />
    </e:window>
</e:ui>
