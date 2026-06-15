<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">

    <script type="text/javascript">

        var gridT;
        <%-- var gridM; var gridB; var gridDP; var gridA; --%>
        var addParam = [];
        var activeGrid;
        var activeRow;
        var activeDeptCd;
        var activeParentDeptCd; var activeParentDeptNm;
        var baseUrl = "/nhepro/OCUR/";

        function init() {

            gridT = EVF.C("gridT");
            <%--
            gridM = EVF.C("gridM");
            gridB = EVF.C("gridB");
            gridDP = EVF.C("gridDP");
            gridA = EVF.C("gridA");
            --%>

            gridT.setProperty('shrinkToFit', true);		            // 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
            gridT.setProperty('rowNumbers', ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
            gridT.setProperty('sortable', ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
            gridT.setProperty('panelVisible', ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            gridT.setProperty('enterToNextRow', ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            gridT.setProperty('acceptZero', ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            gridT.setProperty('singleSelect', ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]
            gridT.setProperty('multiSelect', ${param.detailView == true ? false : multiSelect}); // [선택] 컬럼의 사용여부를 지정한다. [true/false]

            <%--
            gridM.setProperty('shrinkToFit', ${shrinkToFit});
            gridM.setProperty('rowNumbers', ${rowNumbers});
            gridM.setProperty('sortable', ${sortable});
            gridM.setProperty('panelVisible', ${panelVisible});
            gridM.setProperty('enterToNextRow', ${enterToNextRow});
            gridM.setProperty('acceptZero', ${acceptZero});
            gridM.setProperty('singleSelect', ${singleSelect});
            gridM.setProperty('multiSelect', ${param.detailView == true ? false : multiSelect});

            gridB.setProperty('shrinkToFit', ${shrinkToFit});
            gridB.setProperty('rowNumbers', ${rowNumbers});
            gridB.setProperty('sortable', ${sortable});
            gridB.setProperty('panelVisible', ${panelVisible});
            gridB.setProperty('enterToNextRow', ${enterToNextRow});
            gridB.setProperty('acceptZero', ${acceptZero});
            gridB.setProperty('singleSelect', ${singleSelect});
            gridB.setProperty('multiSelect', ${param.detailView == true ? false : multiSelect});

            gridDP.setProperty('shrinkToFit', ${shrinkToFit});
            gridDP.setProperty('rowNumbers', ${rowNumbers});
            gridDP.setProperty('sortable', ${sortable});
            gridDP.setProperty('panelVisible', ${panelVisible});
            gridDP.setProperty('enterToNextRow', ${enterToNextRow});
            gridDP.setProperty('acceptZero', ${acceptZero});
            gridDP.setProperty('singleSelect', ${singleSelect});
            gridDP.setProperty('multiSelect', ${param.detailView == true ? false : multiSelect});

            gridA.setProperty('shrinkToFit', true);
            gridA.setProperty('rowNumbers', ${rowNumbers});
            gridA.setProperty('sortable', ${sortable});
            gridA.setProperty('panelVisible', ${panelVisible});
            gridA.setProperty('enterToNextRow', ${enterToNextRow});
            gridA.setProperty('acceptZero', ${acceptZero});
            gridA.setProperty('singleSelect', ${singleSelect});
            gridA.setProperty('multiSelect', ${param.detailView == true ? false : multiSelect});
            --%>

            gridT.cellClickEvent(function(rowIdx, colIdx, value) {

                if(colIdx == "DEPT_CD") {

                    <%--
                    gridM.delAllRow();
                    gridB.delAllRow();
                    gridDP.delAllRow();

                    if(gridT.getCellValue(rowIdx, 'DEPT_CD') == ""){
                        EVF.C("R1").setChecked(true);
                        EVF.C("R2").setChecked(false);
                        EVF.C("R3").setChecked(false);
                        EVF.C("R4").setChecked(false);
                    } else {
                        var store = new EVF.Store();
                        store.setParameter("PARENT_DEPT_CD", gridT.getCellValue(rowIdx, 'DEPT_CD'));
                        EVF.V("M_PARENT_DEPT_CD", gridT.getCellValue(rowIdx, 'DEPT_CD'));
                        EVF.V("M_PARENT_DEPT_NM", gridT.getCellValue(rowIdx, 'DEPT_NM'));
                        EVF.V("B_PARENT_DEPT_CD", ""); EVF.V("B_PARENT_DEPT_NM","");
                        store.setGrid([gridM]);
                        store.load(baseUrl + 'ocur0020_doSearchM.so', function() {
                            if(gridM.getRowCount() == 0){
                                EVF.alert("${msg.M0002 }");
                            }
                        });
                        EVF.C("R1").setChecked(false);
                        EVF.C("R2").setChecked(true);
                        EVF.C("R3").setChecked(false);
                        EVF.C("R4").setChecked(false);

                        if(!EVF.isEmpty(gridT.getCellValue(rowIdx, 'DEPT_CD'))) {
                            gridA.delAllRow();
                            activeDeptCd = gridT.getCellValue(rowIdx, 'DEPT_CD');
                            store = new EVF.Store();
                            store.setParameter("DEPT_CD", activeDeptCd);
                            store.setGrid([gridA]);
                            store.load(baseUrl + 'ocur0020_doSearchAccount.so', function () {

                            });
                        }
                    }
                    --%>
                }
                if(colIdx == "ZIP_CD") {
                    var url = '/common/code/BADV_020/view.so';
                    var param = {
                        callBackFunction : "setZipCode",
                        modalYn : false
                    };
                    everPopup.openWindowPopup(url, 700, 600, param);
                    activeGrid = gridT;
                    activeRow = rowIdx;
                }
            });

            gridT.cellChangeEvent(function(rowIdx, colIdx, iRow, iCol, value, oldValue) {
                if (colIdx == "PARENT_DEPT_NM") {
                    gridT.setCellValue(rowIdx, 'PARENT_DEPT_CD', gridT.getCellValue(rowIdx, 'PARENT_DEPT_NM'));
                }
            });

            gridT.addRowEvent(function() {
                addParam = [{'PARENT_DEPT_CD': EVF.V("CUST_CD"), 'PARENT_DEPT_NM': EVF.V("CUST_NM"), 'DEL_FLAG': '1'}];
                gridT.addRow(addParam);
                <%--
                EVF.C("R1").setChecked(true);
                EVF.C("R2").setChecked(false);
                EVF.C("R3").setChecked(false);
                EVF.C("R4").setChecked(false);
                --%>
            });

            gridT.delRowEvent(function() {
                if(!gridT.getSelRowCount()) { return EVF.alert("${msg.M0004}"); }
                gridT.delRow();
            });

            <%--
            gridM.cellClickEvent(function(rowIdx, colIdx, value) {

                if(colIdx == "DEPT_CD") {

                    gridB.delAllRow();
                    gridDP.delAllRow();

                    if(gridM.getCellValue(rowIdx, 'DEPT_CD') == ""){
                        EVF.C("R1").setChecked(false);
                        EVF.C("R2").setChecked(true);
                        EVF.C("R3").setChecked(false);
                        EVF.C("R4").setChecked(false);
                    } else {
                        var store = new EVF.Store();
                        store.setParameter("PARENT_DEPT_CD", gridM.getCellValue(rowIdx, 'DEPT_CD'));
                        EVF.V("B_PARENT_DEPT_CD", gridM.getCellValue(rowIdx, 'DEPT_CD'));
                        EVF.V("B_PARENT_DEPT_NM", gridM.getCellValue(rowIdx, 'DEPT_NM'));
                        EVF.V("M_PARENT_DEPT_CD", ""); EVF.V("M_PARENT_DEPT_NM","");
                        store.setGrid([gridB]);
                        store.load(baseUrl + 'ocur0020_doSearchB.so', function() {

                        });
                        EVF.C("R1").setChecked(false);
                        EVF.C("R2").setChecked(false);
                        EVF.C("R3").setChecked(true);
                        EVF.C("R4").setChecked(false);
                        EVF.V("DEPT_CD",gridM.getCellValue(rowIdx, 'DEPT_CD'));

                        if(!EVF.isEmpty(gridM.getCellValue(rowIdx, 'DEPT_CD'))) {
                            gridA.delAllRow();
                            activeDeptCd = gridM.getCellValue(rowIdx, 'DEPT_CD');
                            store = new EVF.Store();
                            store.setParameter("DEPT_CD", activeDeptCd);
                            store.setGrid([gridA]);
                            store.load(baseUrl + 'ocur0020_doSearchAccount.so', function () {

                            });
                        }
                    }
                }
                if(colIdx == "ZIP_CD") {
                    var url = '/common/code/BADV_020/view.so';
                    var param = {
                        callBackFunction : "setZipCode",
                        modalYn : false
                    };
                    everPopup.openWindowPopup(url, 700, 600, param);
                    activeGrid = gridM;
                    activeRow = rowIdx;
                }
            });

            gridM.cellChangeEvent(function(rowIdx, colIdx, iRow, iCol, value, oldValue) {
                if (colIdx == "PARENT_DEPT_NM") {
                    gridM.setCellValue(rowIdx, 'PARENT_DEPT_CD', gridM.getCellValue(rowIdx, 'PARENT_DEPT_NM'));
                }
            });

            gridB.cellClickEvent(function(rowIdx, colIdx, value) {

                if(colIdx == "DEPT_CD") {

                    gridDP.delAllRow();

                    if(gridB.getCellValue(rowIdx, 'DEPT_CD') == ""){
                        EVF.C("R1").setChecked(false);
                        EVF.C("R2").setChecked(false);
                        EVF.C("R3").setChecked(true);
                        EVF.C("R4").setChecked(false);
                    } else {
                        var store = new EVF.Store();
                        store.setParameter("PARENT_DEPT_CD", gridB.getCellValue(rowIdx, 'DEPT_CD'));
                        EVF.V("DP_PARENT_DEPT_CD", gridB.getCellValue(rowIdx, 'DEPT_CD'));
                        EVF.V("DP_PARENT_DEPT_NM", gridB.getCellValue(rowIdx, 'DEPT_NM'));
                        EVF.V("B_PARENT_DEPT_CD", ""); EVF.V("B_PARENT_DEPT_NM","");
                        store.setGrid([gridDP]);
                        store.load(baseUrl + 'ocur0020_doSearchDP.so', function() {

                        });
                        EVF.C("R1").setChecked(false);
                        EVF.C("R2").setChecked(false);
                        EVF.C("R3").setChecked(false);
                        EVF.C("R4").setChecked(true);
                        EVF.V("DEPT_CD",gridB.getCellValue(rowIdx, 'DEPT_CD'));

                        if(!EVF.isEmpty(gridB.getCellValue(rowIdx, 'DEPT_CD'))) {
                            gridA.delAllRow();
                            activeDeptCd = gridB.getCellValue(rowIdx, 'DEPT_CD');
                            store = new EVF.Store();
                            store.setParameter("DEPT_CD", activeDeptCd);
                            store.setGrid([gridA]);
                            store.load(baseUrl + 'ocur0020_doSearchAccount.so', function () {

                            });
                        }
                    }
                }
                if(colIdx == "ZIP_CD") {
                    var url = '/common/code/BADV_020/view.so';
                    var param = {
                        callBackFunction : "setZipCode",
                        modalYn : false
                    };
                    everPopup.openWindowPopup(url, 700, 600, param);
                    activeGrid = gridB;
                    activeRow = rowIdx;
                }
            });

            gridB.cellChangeEvent(function(rowIdx, colIdx, iRow, iCol, value, oldValue) {
                if (colIdx == "PARENT_DEPT_NM") {
                    gridB.setCellValue(rowIdx, 'PARENT_DEPT_CD', gridB.getCellValue(rowIdx, 'PARENT_DEPT_NM'));
                }
            });

            gridDP.cellClickEvent(function(rowIdx, colIdx, value) {

                if(colIdx == "DEPT_CD") {

                    if(!EVF.isEmpty(gridDP.getCellValue(rowIdx, 'DEPT_CD'))) {
                        gridA.delAllRow();
                        activeDeptCd = gridDP.getCellValue(rowIdx, 'DEPT_CD');
                        var store = new EVF.Store();
                        store.setParameter("DEPT_CD", activeDeptCd);
                        store.setGrid([gridA]);
                        store.load(baseUrl + 'ocur0020_doSearchAccount.so', function () {

                        });
                    }
                }
                if(colIdx == "ZIP_CD") {
                    var url = '/common/code/BADV_020/view.so';
                    var param = {
                        callBackFunction : "setZipCode",
                        modalYn : false
                    };
                    everPopup.openWindowPopup(url, 700, 600, param);
                    activeGrid = gridDP;
                    activeRow = rowIdx;
                }
            });

            gridA.cellClickEvent(function(rowIdx, colIdx, value) {

                if(colIdx == "ATTACH_FILE_CNT") {
                    var param = {
                        detailView: false,
                        attFileNum: gridA.getCellValue(rowIdx, 'ATTACH_FILE_NUM'),
                        rowIdx: rowIdx,
                        callBackFunction: 'setFileAttachCnt',
                        bizType: 'OCUR',
                        fileExtension: '*'
                    };
                    everPopup.fileAttachPopup(param);
                }
            });

            gridM.addRowEvent(function() {
                if(EVF.V("M_PARENT_DEPT_CD") == ""){ return EVF.alert("${OCUR0020_003}"); }
                addParam = [{'PARENT_DEPT_CD': EVF.V("M_PARENT_DEPT_CD"),'PARENT_DEPT_NM': EVF.V("M_PARENT_DEPT_NM"), 'DEL_FLAG': '1'}];
                gridM.addRow(addParam);
                EVF.C("R1").setChecked(false);
                EVF.C("R2").setChecked(true);
                EVF.C("R3").setChecked(false);
                EVF.C("R4").setChecked(false);
            });

            gridM.delRowEvent(function() {
                if(!gridM.getSelRowCount()) { return EVF.alert("${msg.M0004}"); }
                gridM.delRow();
            });

            gridB.addRowEvent(function() {
                if(EVF.V("B_PARENT_DEPT_CD") == ""){ return EVF.alert("${OCUR0020_003}"); }
                addParam = [{'PARENT_DEPT_CD': EVF.V("B_PARENT_DEPT_CD"),'PARENT_DEPT_NM': EVF.V("B_PARENT_DEPT_NM"), 'DEL_FLAG': '1'}];
                gridB.addRow(addParam);
                EVF.C("R1").setChecked(false);
                EVF.C("R2").setChecked(false);
                EVF.C("R3").setChecked(true);
                EVF.C("R4").setChecked(false);
            });

            gridB.delRowEvent(function() {
                if(!gridB.getSelRowCount()) { return EVF.alert("${msg.M0004}"); }
                gridB.delRow();
            });

            gridDP.addRowEvent(function() {
                if(EVF.V("DP_PARENT_DEPT_CD") == ""){ return EVF.alert("${OCUR0020_003}"); }
                addParam = [{'PARENT_DEPT_CD': EVF.V("DP_PARENT_DEPT_CD"),'PARENT_DEPT_NM': EVF.V("DP_PARENT_DEPT_NM"), 'DEL_FLAG': '1'}];
                gridDP.addRow(addParam);
                EVF.C("R1").setChecked(false);
                EVF.C("R2").setChecked(false);
                EVF.C("R3").setChecked(false);
                EVF.C("R4").setChecked(true);
            });

            gridDP.delRowEvent(function() {
                if(!gridDP.getSelRowCount()) { return EVF.alert("${msg.M0004}"); }
                gridDP.delRow();
            });

            gridA.addRowEvent(function() {
                addParam = [{'USE_FLAG': '1'}];
                gridA.addRow(addParam);
            });

            gridA.delRowEvent(function() {
                if(!gridA.getSelRowCount()) { return EVF.alert("${msg.M0004}"); }
                gridA.delRow();
            });
            --%>

            gridT.excelExportEvent({
                allItems : "${excelExport.allCol}",
                fileName : "${screenName }"
            });

            <%--
            gridM.excelExportEvent({
                allItems : "${excelExport.allCol}",
                fileName : "${screenName }"
            });

            gridB.excelExportEvent({
                allItems : "${excelExport.allCol}",
                fileName : "${screenName }"
            });

            gridDP.excelExportEvent({
                allItems : "${excelExport.allCol}",
                fileName : "${screenName }"
            });

            gridA.excelExportEvent({
                allItems : "${excelExport.allCol}",
                fileName : "${screenName }"
            });
            --%>
        }

        function doSearch() {

            EVF.V("M_PARENT_DEPT_CD", "");
            EVF.V("B_PARENT_DEPT_CD", "");
            EVF.V("DP_PARENT_DEPT_CD", "");

            var store = new EVF.Store();
            if(!store.validate()) { return; }
            <%-- store.setGrid([gridT, gridM, gridB, gridDP]); --%>
            store.setGrid([gridT]);
            store.load(baseUrl + 'ocur0020_doSearch.so', function() {
                <%-- if(gridT.getRowCount() == 0 && gridM.getRowCount() == 0 && gridB.getRowCount() == 0 && gridDP.getRowCount() == 0 ){ --%>
                if(gridT.getRowCount() == 0){
                    EVF.alert("${msg.M0002 }");
                }
            });
        }

        function doSave() {

            if(EVF.V("CUST_CD") == ""){
                EVF.C('CUST_NM').setFocus();
                return EVF.alert("${OCUR0020_001}");
            }

            if(gridT.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

            if (!gridT.validate().flag) { return EVF.alert(gridT.validate().msg); }

            EVF.V("DEPT_TYPE_RADIO", "100");
            EVF.V("DIVISION_YN", "1");
            EVF.V("LVL","1");
            activeGrid = gridT;

            <%-- 2020.08.04 Level의 개념을 사용하지 않음.
            var radioVal = (EVF.C("R1").isChecked() == true ? "R1" :(EVF.C("R2").isChecked() == true ? "R2" : (EVF.C("R3").isChecked() == true ? "R3" : (EVF.C("R4").isChecked() == true ? "R4" : ""))));

            if(radioVal == "R1") {

                if(gridT.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
                if (!gridT.validate().flag) { return EVF.alert(gridT.validate().msg); }

                EVF.V("DEPT_TYPE_RADIO", "100");
                EVF.V("DIVISION_YN", "1");
                EVF.V("LVL","1");
                activeGrid = gridT;
            }
            else if(radioVal == "R2") {

                if(gridM.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
                if (!gridM.validate().flag) { return EVF.alert(gridM.validate().msg); }

                EVF.V("DEPT_TYPE_RADIO", "200");
                EVF.V("DIVISION_YN", "0");
                EVF.V("LVL","2");
                activeGrid = gridM;
            }
            else if(radioVal == "R3") {

                if(gridB.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
                if (!gridB.validate().flag) { return EVF.alert(gridB.validate().msg); }

                EVF.V("DEPT_TYPE_RADIO", "300");
                EVF.V("DIVISION_YN", "0");
                EVF.V("LVL","3");
                activeGrid = gridB;
            }
            else if(radioVal == "R4") {

                if(gridDP.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
                if (!gridDP.validate().flag) { return EVF.alert(gridDP.validate().msg); }

                EVF.V("DEPT_TYPE_RADIO", "400");
                EVF.V("DIVISION_YN", "0");
                EVF.V("LVL","4");
                activeGrid = gridDP;
            }
            --%>

            var rowIds = activeGrid.getSelRowId();
            for(var i in rowIds) {
                if(i == 0) {
                    activeParentDeptCd = activeGrid.getCellValue(rowIds[i], 'PARENT_DEPT_CD');
                    activeParentDeptNm = activeGrid.getCellValue(rowIds[i], 'PARENT_DEPT_NM');
                }
            }

            EVF.confirm("${msg.M0021 }", function () {
                var store = new EVF.Store();
                <%--
                store.setParameter("radioVal", radioVal);
                store.setGrid([gridT, gridM, gridB, gridDP]);
                store.getGridData(gridT, 'sel');
                store.getGridData(gridM, 'sel');
                store.getGridData(gridB, 'sel');
                store.getGridData(gridDP, 'sel');
                --%>
                store.setGrid([gridT]);
                store.getGridData(gridT, 'sel');
                store.load(baseUrl + 'ocur0020_doSave.so', function() {
                    EVF.alert(this.getResponseMessage(), function() {

                        if(activeGrid == gridT) {
                            EVF.V("M_PARENT_DEPT_CD", "");
                            EVF.V("B_PARENT_DEPT_CD", "");
                            EVF.V("DP_PARENT_DEPT_CD", "");

                            store = new EVF.Store();
                            if(!store.validate()) { return; }
                            <%-- store.setGrid([gridT, gridM, gridB, gridDP]); --%>
                            store.setGrid([gridT]);
                            store.load(baseUrl + 'ocur0020_doSearch.so', function() {

                            });
                        }
                        <%--
                        else if(activeGrid == gridM) {
                            store = new EVF.Store();
                            store.setParameter("PARENT_DEPT_CD", activeParentDeptCd);
                            EVF.V("M_PARENT_DEPT_CD", activeParentDeptCd);
                            EVF.V("M_PARENT_DEPT_NM", activeParentDeptNm);
                            EVF.V("B_PARENT_DEPT_CD", ""); EVF.V("B_PARENT_DEPT_NM","");
                            store.setGrid([gridM]);
                            store.load(baseUrl + 'ocur0020_doSearchM.so', function() {

                            });
                        }
                        else if(activeGrid == gridB) {
                            store = new EVF.Store();
                            store.setParameter("PARENT_DEPT_CD", activeParentDeptCd);
                            EVF.V("B_PARENT_DEPT_CD", activeParentDeptCd);
                            EVF.V("B_PARENT_DEPT_NM", activeParentDeptNm);
                            EVF.V("M_PARENT_DEPT_CD", ""); EVF.V("M_PARENT_DEPT_NM","");
                            store.setGrid([gridB]);
                            store.load(baseUrl + 'ocur0020_doSearchB.so', function() {

                            });
                        }
                        else if(activeGrid == gridDP) {
                            store = new EVF.Store();
                            store.setParameter("PARENT_DEPT_CD", activeParentDeptCd);
                            EVF.V("DP_PARENT_DEPT_CD", activeParentDeptCd);
                            EVF.V("DP_PARENT_DEPT_NM", activeParentDeptNm);
                            EVF.V("B_PARENT_DEPT_CD", ""); EVF.V("B_PARENT_DEPT_NM","");
                            store.setGrid([gridDP]);
                            store.load(baseUrl + 'ocur0020_doSearchDP.so', function() {

                            });
                        }
                        --%>
                    });
                });
            });
        }

        function doSaveAcc() {

            if(EVF.isEmpty(EVF.V("CUST_CD"))){
                EVF.C('CUST_NM').setFocus();
                return EVF.alert("${OCUR0020_001}");
            }
            if(EVF.isEmpty(activeDeptCd)){
                return EVF.alert("${OCUR0020_004}");
            }

            if(gridA.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

            if (!gridA.validate().flag) { return EVF.alert(gridA.validate().msg); }

            EVF.confirm("${msg.M0021 }", function () {
                var store = new EVF.Store();
                store.setParameter("activeDeptCd", activeDeptCd);
                store.setGrid([gridA]);
                store.getGridData(gridA, 'sel');
                store.load(baseUrl + 'ocur0020_doSaveAcc.so', function() {
                    EVF.alert(this.getResponseMessage(), function() {
                        gridA.delAllRow();
                        store = new EVF.Store();
                        store.setParameter("DEPT_CD", activeDeptCd);
                        store.setGrid([gridA]);
                        store.load(baseUrl + 'ocur0020_doSearchAccount.so', function() {

                        });
                    });
                });
            });
        }

        function doDelAcc() {

            if(gridA.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

            EVF.confirm("${msg.M0013 }", function () {
                var store = new EVF.Store();
                store.setGrid([gridA]);
                store.getGridData(gridA, 'sel');
                store.load(baseUrl + 'ocur0020_doDelAcc.so', function() {
                    EVF.alert(this.getResponseMessage(), function() {
                        gridA.delAllRow();
                        store = new EVF.Store();
                        store.setParameter("DEPT_CD", activeDeptCd);
                        store.setGrid([gridA]);
                        store.load(baseUrl + 'ocur0020_doSearchAccount.so', function() {

                        });
                    });
                });
            });
        }

        function checkRadio() {

            var clickBtn = this.getData().data;

            if(clickBtn == "R1") {
                EVF.C("R1").setChecked(true);
                EVF.C("R2").setChecked(false);
                EVF.C("R3").setChecked(false);
                EVF.C("R4").setChecked(false);
            }
            else if(clickBtn == "R2") {
                EVF.C("R1").setChecked(false);
                EVF.C("R2").setChecked(true);
                EVF.C("R3").setChecked(false);
                EVF.C("R4").setChecked(false);
            }
            else if(clickBtn == "R3") {
                EVF.C("R1").setChecked(false);
                EVF.C("R2").setChecked(false);
                EVF.C("R3").setChecked(true);
                EVF.C("R4").setChecked(false);
            }
            else if(clickBtn == "R4") {
                EVF.C("R1").setChecked(false);
                EVF.C("R2").setChecked(false);
                EVF.C("R3").setChecked(false);
                EVF.C("R4").setChecked(true);
            }
        }

        function setBuyer(data) {

            EVF.V('CUST_CD', data.CUST_CD);
            EVF.V('CUST_NM', data.CUST_NM);

            if(!EVF.isEmpty(data.CUST_CD)) {
                var store = new EVF.Store();
                store.setParameter("CUST_CD", data.CUST_CD);
                store.load(baseUrl + 'ocur0020_getRelatYN.so', function() {
                    var relatYN = this.getParameter("RELAT_YN");
                    <%-- 아리오피스에서 넘어온(농협 법인) 고객사의 경우 수동으로 부서/사무소 생성, 수정은 못하게 처리 --%>
                    if(relatYN == "0") {
                        EVF.C('Save').setDisabled(true);
                    }
                }, false);
            }
        }

        function setZipCode(zipcd) {
            activeGrid.setCellValue(activeRow, ZIP_CD, zipcd.ZIP_CD_5);
            activeGrid.setCellValue(activeRow, ADDR1, zipcd.ADD);
        }

        function setFileAttachCnt(rowIdx, fileId, fileCnt) {
            gridA.setCellValue(rowIdx, 'ATTACH_FILE_CNT', fileCnt);
            gridA.setCellValue(rowIdx, 'ATTACH_FILE_NUM', fileId);
        }

    </script>

    <e:window id="OCUR0020" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">
        <e:searchPanel id="form" title="${msg.M9999 }" columnCount="2" labelWidth="${labelWidth }" useTitleBar="false" onEnter="doSearch">
            <e:row>
                <e:label for="CUST_CD" title="${form_CUST_CD_N}"/>
                <e:field>
                    <e:inputText id="CUST_CD" name="CUST_CD" value="" width="0" maxLength="${form_CUST_CD_M}" disabled="${form_CUST_CD_D}" readOnly="${form_CUST_CD_RO}" required="${form_CUST_CD_R}" />
                    <e:search id="CUST_NM" name="CUST_NM" value="" width="100%" maxLength="${form_CUST_NM_M}" onIconClick="${form_CUST_NM_RO ? 'everCommon.blank' : 'getBuyer'}" popupCode="SP0066.setBuyer" disabled="${form_CUST_NM_D}" readOnly="${form_CUST_NM_RO}" required="${form_CUST_NM_R}" />
                </e:field>
                <e:label for="DEPT_NM" title="${form_DEPT_NM_N}"/>
                <e:field>
                    <e:inputText id="DEPT_NM" style="${imeMode}" name="DEPT_NM" value="" width="100%" maxLength="${form_DEPT_NM_M}" disabled="${form_DEPT_NM_D}" readOnly="${form_DEPT_NM_RO}" required="${form_DEPT_NM_R}"/>
                    <e:inputHidden id="DEPT_TYPE_RADIO" name="DEPT_TYPE_RADIO"/>
                    <e:inputHidden id="DIVISION_YN" name="DIVISION_YN"/>
                    <e:inputHidden id="M_PARENT_DEPT_CD" name="M_PARENT_DEPT_CD"/>
                    <e:inputHidden id="M_PARENT_DEPT_NM" name="M_PARENT_DEPT_NM"/>
                    <e:inputHidden id="B_PARENT_DEPT_CD" name="B_PARENT_DEPT_CD"/>
                    <e:inputHidden id="B_PARENT_DEPT_NM" name="B_PARENT_DEPT_NM"/>
                    <e:inputHidden id="DP_PARENT_DEPT_CD" name="DP_PARENT_DEPT_CD"/>
                    <e:inputHidden id="DP_PARENT_DEPT_NM" name="DP_PARENT_DEPT_NM"/>
                    <e:inputHidden id="LVL" name="LVL"/>
                    <e:inputHidden id="DEPT_CD" name="DEPT_CD"/>
                </e:field>
            </e:row>
        </e:searchPanel>

        <e:buttonBar id="buttonBar" align="right" width="100%">
            <e:button id="Search" name="Search" label="${Search_N }" disabled="${Search_D }" visible="${Search_V}" onClick="doSearch" />
            <e:button id="Save" name="Save" label="${Save_N }" disabled="${Save_D }" visible="${Save_V}" onClick="doSave" />
        </e:buttonBar>

        <e:gridPanel id="gridT" name="gridT" gridType="${_gridType}" width="100%" height="fit" readOnly="${param.detailView}"/>

        <%--
        <e:panel id="leftPanel" height="440" width="50%">
            <e:radio id="R1" name="R1" label="" value="1" checked="true" readOnly="false" disabled="false" onClick="checkRadio" data="R1" />
            <e:text style="float: left; line-height: 27px; font-size: 14px; font-weight: bold;">${OCUR0020_LV1}</e:text>
            <e:gridPanel id="gridT" name="gridT" gridType="${_gridType}" width="100%" height="380px" readOnly="${param.detailView}"/>
        </e:panel>

        <e:panel id="nullPanel" height="440" width="1%">&nbsp;</e:panel>

        <e:panel id="rightPanel" height="440" width="49%">
            <e:radio id="R2" name="R2" label="" value="2" checked="false" readOnly="false" disabled="false" onClick="checkRadio" data="R2" />
            <e:text style="float: left; line-height: 27px; font-size: 14px; font-weight: bold;">${OCUR0020_LV2}</e:text>
            <e:gridPanel id="gridM" name="gridM" gridType="${_gridType}" width="100%" height="380px" readOnly="${param.detailView}"/>
        </e:panel>

        <e:panel id="leftPanelB" height="440" width="50%">
            <e:radio id="R3" name="R3" label="" value="3" checked="false" readOnly="false" disabled="false" onClick="checkRadio" data="R3" />
            <e:text style="float: left; line-height: 27px; font-size: 14px; font-weight: bold;">${OCUR0020_LV3}</e:text>
            <e:gridPanel id="gridB" name="gridB" gridType="${_gridType}" width="100%" height="380px" readOnly="${param.detailView}"/>
        </e:panel>

        <e:panel id="nullPanel2" height="440" width="1%">&nbsp;</e:panel>

        <e:panel id="rightPanelB" height="440" width="49%">
            <e:radio id="R4" name="R4" label="" value="4" checked="false" readOnly="false" disabled="false" onClick="checkRadio" data="R4" />
            <e:text style="float: left; line-height: 27px; font-size: 14px; font-weight: bold;">${OCUR0020_LV4}</e:text>
            <e:gridPanel id="gridDP" name="gridDP" gridType="${_gridType}" width="100%" height="380px" readOnly="${param.detailView}"/>
        </e:panel>

        <e:buttonBar id="buttonBarAcc" title="${OCUR0020_002}" align="right" width="100%">
            <e:button id="SaveAcc" name="SaveAcc" label="${SaveAcc_N }" disabled="${SaveAcc_D }" visible="${SaveAcc_V}" onClick="doSaveAcc" />
            <e:button id="DelAcc" name="DelAcc" label="${DelAcc_N }" disabled="${DelAcc_D }" visible="${DelAcc_V}" onClick="doDelAcc" />
        </e:buttonBar>

        <e:gridPanel id="gridA" name="gridA" gridType="${_gridType}" width="100%" height="300px" readOnly="${param.detailView}"/>
        --%>

    </e:window>
</e:ui>