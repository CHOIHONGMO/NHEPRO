<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
    <script type="text/javascript">
        var grid;
        var baseUrl = "/nhepro/OETR/";

        function init() {
            grid = EVF.C("grid");

            grid.setProperty("shrinkToFit", true);					// 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
            grid.setProperty("rowNumbers", ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
            grid.setProperty("sortable", ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
            grid.setProperty("panelVisible", ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            grid.setProperty("enterToNextRow", ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            grid.setProperty("acceptZero", ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            grid.setProperty("multiSelect", false);					// [선택] 컬럼의 사용여부를 지정한다. [true/false]
            grid.setProperty("singleSelect", ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]
            
            grid.cellClickEvent(function(rowIdx, colIdx) {
                var param;

                if(colIdx == "SUBJECT") {
                    param = {
                        NOTICE_NUM: grid.getCellValue(rowIdx, "NOTICE_NUM"),
                        detailView: ("${ses.userId }" != grid.getCellValue(rowIdx, "REG_USER_ID")),
                        popupFlag: true
                    };
                    everPopup.openPopupByScreenId("OETR0021", 1000, 730, param);

                } else if(colIdx == "ATTACH_FILE_NO_DISPLAY") {
                    if( !EVF.isEmpty(grid.getCellValue(rowIdx, "ATTACH_FILE_NO_DISPLAY")) ) {
                        var uuid = grid.getCellValue(rowIdx, "ATTACH_FILE_NO");
                        param = {
                            attFileNum: uuid,
                            rowIdx: rowIdx,
                            callBackFunction: "",
                            bizType: "NT",
                            detailView: true
                        };
                        everPopup.fileAttachPopup(param);
                        // everPopup.openPopupByScreenId("commonFileAttach", 650, 310, param);
                    }

                } else if(colIdx == "REG_USER_NAME") {
                    if( grid.getCellValue(rowIdx, "REG_USER_ID") == "" ) return;

                    param = {
                        callbackFunction: "",
                        USER_TYPE: "O",  // O:운영사, B:고객사, S:협력업체
                        USER_ID: grid.getCellValue(rowIdx, "REG_USER_ID"),
                        detailView: true
                    };
                    everPopup.openPopupByScreenId("MTUA0011", 600, 190, param);
                }
            });

            grid.excelExportEvent({
                allItems: "${excelExport.allCol}",
                fileName: "${screenName }"
            });
        }

        function doSearch() {
            var store = new EVF.Store();
            if(!store.validate()) { return; }
            store.setGrid([grid]);
            store.load(baseUrl + "oetr0020_doSearch.so", function() {
                if(grid.getRowCount() == 0){
                    EVF.alert("${msg.M0002 }");
                } else {
                    grid.setColIconify("ATTACH_FILE_NO_DISPLAY", "ATTACH_FILE_NO_DISPLAY", "file", false);
                }
            });
        }

        function doCreate(){
            var param = {
                NOTICE_NUM: "",
                detailView: false,
                popupFlag: true
            };
            everPopup.openPopupByScreenId("OETR0021", 1000, 730, param);
        }

        function doChange() {
            if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
            if (grid.getSelRowCount() > 1) { return EVF.alert("${msg.M0006}"); }

            var noticeNum = "";
            var rowIds = grid.getSelRowId();

            for(var i in rowIds) {
                if("${ses.userId }" != grid.getCellValue(rowIds[i], "REG_USER_ID")) {
                    return EVF.alert("${OETR0020_001}");
                }
                noticeNum = grid.getCellValue(rowIds[i], "NOTICE_NUM");
            }

            var param = {
                NOTICE_NUM: noticeNum,
                detailView: false,
                popupFlag: true
            };
            everPopup.openPopupByScreenId("OETR0021", 1000, 700, param);
        }

        function doDelete() {
            if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

            EVF.confirm("${msg.M0013 }", function () {
                var store = new EVF.Store();
                store.setGrid([grid]);
                store.getGridData(grid, "sel");
                store.load(baseUrl + "oetr0020_doDelete.so", function(){
                    EVF.alert(this.getResponseMessage(), function() {
                        doSearch();
                    });
                });
            });
        }
    </script>

    <e:window id="OETR0020" initData="${initData}" onReady="init" title="${fullScreenName}" breadCrumbs="${breadCrumb }">
        <e:searchPanel id="form" title="${form_CAPTION_N }" labelWidth="${labelWidth}" width="100%" columnCount="3" useTitleBar="false" onEnter="doSearch">
            <e:row>
                <e:label for="ADD_FROM_DATE" title="${form_ADD_FROM_DATE_N}" />
                <e:field>
                    <e:inputDate id="ADD_FROM_DATE" toDate="ADD_TO_DATE" name="ADD_FROM_DATE" value="${addFromDate }" width="${inputDateWidth }" datePicker="true" required="${form_ADD_FROM_DATE_R}" disabled="${form_ADD_FROM_DATE_D}" readOnly="${form_ADD_FROM_DATE_RO}" />
                    <e:text>&nbsp;~&nbsp;</e:text>
                    <e:inputDate id="ADD_TO_DATE" fromDate="ADD_FROM_DATE" name="ADD_TO_DATE" value="${addToDate }" width="${inputDateWidth }" datePicker="true" required="${form_ADD_TO_DATE_R}" disabled="${form_ADD_TO_DATE_D}" readOnly="${form_ADD_TO_DATE_RO}" />
                </e:field>
                <e:label for="SUBJECT" title="${form_SUBJECT_N}" />
                <e:field>
                    <e:inputText id="SUBJECT" name="SUBJECT" value="" width="${form_SUBJECT_W}" maxLength="${form_SUBJECT_M}" disabled="${form_SUBJECT_D}" readOnly="${form_SUBJECT_RO}" required="${form_SUBJECT_R}" style="${imeMode}" maskType="${form_SUBJECT_MT}"/>
                </e:field>

                <e:label for="ADD_USER_NAME" title="${form_ADD_USER_NAME_N}" />
                <e:field>
                    <e:inputText id="ADD_USER_NAME" name="ADD_USER_NAME" value="" width="${form_ADD_USER_NAME_W}" maxLength="${form_ADD_USER_NAME_M}" disabled="${form_ADD_USER_NAME_D}" readOnly="${form_ADD_USER_NAME_RO}" required="${form_ADD_USER_NAME_R}" style="${imeMode}" maskType="${form_ADD_USER_NAME_MT}"/>
                    <e:inputHidden id="ADD_USER_ID" name="ADD_USER_ID"/>
                </e:field>
            </e:row>
        </e:searchPanel>

        <e:buttonBar id="buttonBar" align="right" width="100%">
            <e:button id="doSearch" name="doSearch" label="${doSearch_N}" onClick="doSearch" disabled="${doSearch_D}" visible="${doSearch_V}"/>
            <e:button id="doCreate" name="doCreate" label="${doCreate_N}" onClick="doCreate" disabled="${doCreate_D}" visible="${doCreate_V}"/>
            <e:button id="doDelete" name="doDelete" label="${doDelete_N}" onClick="doDelete" disabled="${doDelete_D}" visible="${doDelete_V}"/>
        </e:buttonBar>

        <e:gridPanel id="grid" name="grid" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}" />

    </e:window>
</e:ui>