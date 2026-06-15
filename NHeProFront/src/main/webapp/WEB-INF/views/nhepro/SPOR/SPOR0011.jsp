<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
    <script type="text/javascript">
        var gridMTGL;
        var gridPOPY;
        var gridPOPC;
        var gridTEMP;
        var baseUrl = "/nhepro/SPOR/";
        var detailView = "${param.detailView}" == "true";
        var PROGRESS_CD = "${param.PROGRESS_CD}";

        function init() {
            gridMTGL = EVF.C("gridMTGL");   // 품목정보

            gridMTGL.setProperty("shrinkToFit", ${shrinkToFit});
            gridMTGL.setProperty("rowNumbers", ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
            gridMTGL.setProperty("sortable", ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
            gridMTGL.setProperty("panelVisible", ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            gridMTGL.setProperty("enterToNextRow", ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            gridMTGL.setProperty("acceptZero", ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            gridMTGL.setProperty("multiSelect", ${param.detailView == true ? false : multiSelect});					// [선택] 컬럼의 사용여부를 지정한다. [true/false]
            gridMTGL.setProperty("singleSelect", ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]

            gridPOPY = EVF.C("gridPOPY");   // 지불정보

            gridPOPY.setProperty("shrinkToFit", ${shrinkToFit});
            gridPOPY.setProperty("rowNumbers", ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
            gridPOPY.setProperty("sortable", ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
            gridPOPY.setProperty("panelVisible", ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            gridPOPY.setProperty("enterToNextRow", ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            gridPOPY.setProperty("acceptZero", ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            gridPOPY.setProperty("multiSelect", false);					// [선택] 컬럼의 사용여부를 지정한다. [true/false]
            gridPOPY.setProperty("singleSelect", ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]

            gridPOPC = EVF.C("gridPOPC");   // 고객사별 지불고객사 정보

            gridPOPC.setProperty("shrinkToFit", ${shrinkToFit});
            gridPOPC.setProperty("rowNumbers", ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
            gridPOPC.setProperty("sortable", ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
            gridPOPC.setProperty("panelVisible", ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            gridPOPC.setProperty("enterToNextRow", ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            gridPOPC.setProperty("acceptZero", ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            gridPOPC.setProperty("multiSelect", ${param.detailView == true ? false : multiSelect});					// [선택] 컬럼의 사용여부를 지정한다. [true/false]
            gridPOPC.setProperty("singleSelect", ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]

            gridMTGL.cellClickEvent(function(rowIdx, colIdx, value) {
                var param;

                if(!detailView) {
                    if(colIdx == "BUYER_DEPT_NM") {
                        if(value == "공동" || EVF.V("PO_CREATE_TYPE") == "MANUAL") {
                            param = {
                                callBackFunction: "callBackBUYER_DEPT_NM",
                                rowIdx: rowIdx
                            };
                            everPopup.openCommonPopup(param, "SP0119");
                        }
                    } else if(colIdx == "MAKER_NM") {
                        if(EVF.V("PO_CREATE_TYPE") == "MANUAL" && gridMTGL.getCellValue(rowIdx, "MAJOR_ITEM_FLAG") == "1") {
                            param = {
                                callBackFunction: "callBackMAKER_NM",
                                rowIdx: rowIdx
                            };
                            everPopup.openCommonPopup(param, "SP0068");
                        }
                    }
                }
            });

            gridMTGL.cellChangeEvent(function (rowIdx, colIdx, irow, icol, value, oldValue) {
                if(colIdx == "PO_QT" || colIdx == "UNIT_PRC") {
                    var PO_QT = gridMTGL.getCellValue(rowIdx, "PO_QT");
                    var UNIT_PRC = gridMTGL.getCellValue(rowIdx, "UNIT_PRC");

                    gridMTGL.setCellValue(rowIdx, "ITEM_AMT", PO_QT * UNIT_PRC);

                    var sumAmt = 0;

                    var allRowId = gridMTGL.getAllRowId();
                    for(var i in allRowId) {
                        var idx = allRowId[i];

                        sumAmt += gridMTGL.getCellValue(idx, "ITEM_AMT");
                    }

                    EVF.V("PO_AMT", sumAmt);
                    onChangePO_AMT(EVF.C("PO_AMT"), sumAmt);
                } else if(colIdx == "PURCHASE_TYPE") {
                    <%--if(value != "") {--%>
                    <%--    var allRowValue = gridMTGL.getAllRowValue();--%>
                    <%--    var chk = false;--%>
                    <%--    var null_chk = true;--%>

                    <%--    for(var j in allRowValue) {--%>
                    <%--        var row = allRowValue[j];--%>

                    <%--        if(row.PURCHASE_TYPE != "" && row.PURCHASE_TYPE != value) {--%>
                    <%--            chk = true;--%>
                    <%--        }--%>

                    <%--        if(row.PURCHASE_TYPE == "") {--%>
                    <%--            null_chk = false;--%>
                    <%--        }--%>
                    <%--    }--%>

                    <%--    if(chk && null_chk) {--%>
                    <%--        gridMTGL.setCellValue(rowIdx, colIdx, oldValue);--%>
                    <%--        EVF.alert("${CPOI0010_016}");--%>
                    <%--    }--%>
                    <%--}--%>
                }
            });

            gridPOPY.cellClickEvent(function(rowIdx) {
                var param = [{
                    PO_NUM: gridPOPY.getCellValue(rowIdx, "PO_NUM"),
                    PAY_CNT: gridPOPY.getCellValue(rowIdx, "PAY_CNT"),
                    PAY_CNT_TYPE: gridPOPY.getCellValue(rowIdx, "PAY_CNT_TYPE"),
                    PAY_CNT_NM: gridPOPY.getCellValue(rowIdx, "PAY_CNT_NM"),
                    PAY_AMT: gridPOPY.getCellValue(rowIdx, "PAY_AMT")
                }];

                if(gridPOPC.getRowCount() > 0) {
                    var idx = gridPOPC.getCellValue(0, "PAY_CNT");

                    POPC_COPY(idx - 1);
                }

                gridPOPC.delAllRow();

                var PC_INFO = gridPOPY.getCellValue(rowIdx, "PC_INFO");

                if(PC_INFO == "") {
                    gridPOPC.addRow(param);
                } else {
                    gridPOPC.addRow(JSON.parse(PC_INFO));
                }

                var sumPayAmt = gridPOPC._gvo.getSummary("PAY_AMT", "sum");

                // gridPOPY.setCellValue(rowIdx, "PY_PAY_AMT", sumPayAmt);
                gridPOPY._gdp.setValue(rowIdx, "PY_PAY_AMT", sumPayAmt);
            });

            gridPOPY.cellChangeEvent(function (rowIdx, colIdx, iRow, iCol, value) {
                if(EVF.V("PO_AMT") == "") {
                    return EVF.alert("${CPOI0010_013}");
                } else {
                    if(colIdx == "PAY_CNT_NM") {
                        var allRowId = gridPOPC.getAllRowId();

                        for(var k in allRowId) {
                            var idx = allRowId[k];

                            gridPOPC.setCellValue(idx, "PAY_CNT_NM", value);
                        }
                    } else if(colIdx == "PAY_PERCENT" || colIdx == "addRow") {
                        gridPOPY.setCellValue(rowIdx, "PAY_AMT", gridPOPY.getCellValue(rowIdx, "PAY_PERCENT") / 100 * EVF.V("PO_AMT"));
                    } else if(colIdx == "PAY_AMT") {
                        gridPOPY.setCellValue(rowIdx, "PAY_PERCENT", gridPOPY.getCellValue(rowIdx, "PAY_AMT") * 100 / EVF.V("PO_AMT"));
                    }
                }
            });

            gridPOPC.cellClickEvent(function(rowIdx, colIdx) {
                if(!detailView) {
                    if(colIdx == "PY_BUYER_DEPT_NM") {
                        var param = {
                            callBackFunction: "callBackPY_BUYER_DEPT_NM",
                            rowIdx: rowIdx
                        };
                        everPopup.openCommonPopup(param, "SP0119");
                    }
                }
            });

            gridPOPC.cellChangeEvent(function (rowIdx, colIdx) {
                var idx = gridPOPC.getCellValue(rowIdx, "PAY_CNT");

                if(colIdx == "PAY_AMT") {
                    var sumPayAmt = gridPOPC._gvo.getSummary("PAY_AMT", "sum");

                    gridPOPY.setCellValue(idx - 1, "PY_PAY_AMT", sumPayAmt);
                } else if(colIdx == "PY_BUYER_DEPT_NM") {

                }
            });

            gridPOPC.addRowEvent(function() {
                if(gridPOPC.getRowCount() == 0) { return EVF.alert("${CPOI0010_015}"); }

                var param = [{
                    PAY_CNT: gridPOPC.getCellValue(0, "PAY_CNT"),
                    PAY_CNT_TYPE: gridPOPC.getCellValue(0, "PAY_CNT_TYPE"),
                    PAY_CNT_NM: gridPOPC.getCellValue(0, "PAY_CNT_NM")
                }];

                gridPOPC.addRow(param);
            });

            gridPOPC.insertRowEvent(function() {
                gridPOPC.insertRow(true);
            });

            gridPOPC.upMoveRowEvent(function() {
                gridPOPC.upMoveRow();
            });

            gridPOPC.downMoveRowEvent(function() {
                gridPOPC.downMoveRow();
            });

            gridPOPC.delRowEvent(function() {
                if(gridPOPC.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
                gridPOPC.delRow();
            });

            doSearchPODT();
            doSearchPOPY();

            gridPOPY.setColBgColor("PY_PAY_AMT", "#f5f5f5");
            gridPOPY.setColBgColor("PY_BUYER_NM", "#f5f5f5");

            gridTEMP = EVF.C("gridTEMP");
            $("#panel_hide").hide();
            // $("#panel_01").hide();
        }

        function POPC_COPY(rowIdx) {
            var allRowValue = gridPOPC.getAllRowValue();
            var data = [];

            for(var k in allRowValue) {
                var PO_NUM = allRowValue[k].PO_NUM;
                var PAY_CNT = allRowValue[k].PAY_CNT;
                var PAY_CNT_TYPE = allRowValue[k].PAY_CNT_TYPE;
                var PAY_CNT_NM = allRowValue[k].PAY_CNT_NM;
                var PY_BUYER_CD = allRowValue[k].PY_BUYER_CD;
                var PY_DEPT_CD = allRowValue[k].PY_DEPT_CD;
                var PY_BUYER_DEPT_NM = allRowValue[k].PY_BUYER_DEPT_NM;
                var PAY_AMT = allRowValue[k].PAY_AMT;
                var RMK = allRowValue[k].RMK;

                data.push({
                    PO_NUM: PO_NUM,
                    PAY_CNT: PAY_CNT,
                    PAY_CNT_TYPE: PAY_CNT_TYPE,
                    PAY_CNT_NM: PAY_CNT_NM,
                    PY_BUYER_CD: PY_BUYER_CD,
                    PY_DEPT_CD: PY_DEPT_CD,
                    PY_BUYER_DEPT_NM: PY_BUYER_DEPT_NM,
                    PAY_AMT: PAY_AMT,
                    RMK: RMK
                });
            }

            // gridPOPY.setCellValue(rowIdx, "PC_INFO", JSON.stringify(data));
            gridPOPY._gdp.setValue(rowIdx, "PC_INFO", JSON.stringify(data));
        }

        function callBackBUYER_DEPT_NM(data) {
            gridMTGL.setCellValue(data.rowIdx, "BUYER_CD", data.BUYER_CD);
            gridMTGL.setCellValue(data.rowIdx, "BUYER_NM", data.BUYER_NM);
            gridMTGL.setCellValue(data.rowIdx, "DEPT_CD", data.DEPT_CD);
            gridMTGL.setCellValue(data.rowIdx, "DEPT_NM", data.DEPT_NM);
            gridMTGL.setCellValue(data.rowIdx, "BUYER_DEPT_NM", data.BUYER_NM + " " + data.DEPT_NM);
        }

        function callBackPY_BUYER_DEPT_NM(data) {
            var PY_BUYER_DEPT_NM = data.BUYER_NM + " " + data.DEPT_NM;

            var allRowId = gridPOPC.getAllRowId();
            var check = false;

            for(var i in allRowId) {
                var j = allRowId[i];

                if(PY_BUYER_DEPT_NM == gridPOPC.getCellValue(j, "PY_BUYER_DEPT_NM")) {
                    check = true;
                }
            }

            if(check) {
                return EVF.alert("${CPOI0010_017}");
            }

            gridPOPC.setCellValue(data.rowIdx, "PY_BUYER_CD", data.BUYER_CD);
            gridPOPC.setCellValue(data.rowIdx, "PY_BUYER_NM", data.BUYER_NM);
            gridPOPC.setCellValue(data.rowIdx, "PY_DEPT_CD", data.DEPT_CD);
            gridPOPC.setCellValue(data.rowIdx, "PY_DEPT_NM", data.DEPT_NM);
            gridPOPC.setCellValue(data.rowIdx, "PY_BUYER_DEPT_NM", data.BUYER_NM + " " + data.DEPT_NM);

            var idx = gridPOPC.getCellValue(data.rowIdx, "PAY_CNT");

            if(gridPOPC.getRowCount() > 1) {
                allRowId = gridPOPC.getAllRowId();
                var str = "";

                for(i in allRowId) {
                    j = allRowId[i];

                    str += gridPOPC.getCellValue(j, "PY_BUYER_DEPT_NM");
                }

                gridPOPY.setCellValue(idx - 1, "PY_BUYER_NM", str);
            } else {
                gridPOPY.setCellValue(idx - 1, "PY_BUYER_NM", data.BUYER_NM + " " + data.DEPT_NM);
            }
        }

        function callBackMAKER_NM(data) {
            gridMTGL.setCellValue(data.rowIdx, "MAKER_CD", data.MKBR_CD);
            gridMTGL.setCellValue(data.rowIdx, "MAKER_NM", data.MKBR_NM);
        }

        function onIconClickVENDOR_CD() {
            if(!detailView) {
                if(EVF.V("PO_CREATE_TYPE") == "MANUAL") { // LAST:종가발주, MANUAL:수기발주
                    var param = {
                        callBackFunction: "callBackVENDOR_CD",
                        BUYER_CD: "${ses.companyCd}"
                    };
                    everPopup.openCommonPopup(param, "SP0123");
                }
            }
        }

        function callBackVENDOR_CD(data) {
            EVF.V("VENDOR_CD", data.VENDOR_CD);
            EVF.V("VENDOR_NM", data.VENDOR_NM);
        }

        function onIconClickINSPECT_USER_ID() {
            if(!detailView) {
                var param = {
                    callBackFunction: "callBackINSPECT_USER_ID"
                };
                everPopup.openCommonPopup(param, "SP0090");
            }
        }

        function callBackINSPECT_USER_ID(data) {
            EVF.V("INSPECT_USER_ID", data.USER_ID);
            EVF.V("INSPECT_USER_NM", data.USER_NM);
        }

        function onChangeCUR(component, value) {
            EVF.V("CUR_DUP", value);
        }

        function onChangePO_AMT(component, value) {
            EVF.V("PO_AMT_DUP", value);

            if(value > 0) {
                var PAY_AMT;

                if(EVF.V("PAY_TYPE") == "IS") {   // LS:일괄지급, IS:분할지급
                    var allRowId = gridPOPY.getAllRowId();

                    for(var i in allRowId) {
                        var rowIdx = allRowId[i];

                        PAY_AMT = gridPOPY.getCellValue(rowIdx, "PAY_PERCENT") / 100 * value;
                        gridPOPY.setCellValue(rowIdx, "PAY_AMT", PAY_AMT);
                    }
                } else if(EVF.V("PAY_TYPE") == "LS") {
                    PAY_AMT = gridPOPY.getCellValue(0, "PAY_PERCENT") / 100 * value;
                    gridPOPY.setCellValue(0, "PAY_AMT", PAY_AMT);
                }
            }
        }

        function onChangeVAT_TYPE(component, value) {
            EVF.V("VAT_TYPE_DUP", value);
        }

        function onChangeDELIVERY_TYPE(component, value) {
            if(value == "DI") {     // DI:납품, PI:검수
                EVF.C("PAY_TYPE").setDisabled(true);
                EVF.C("PAY_TYPE").setRequired(false);
                EVF.C("PAY_TYPE_DUP").setRequired(false);

                EVF.V("PAY_TYPE", "LS");

                // $("#panel_01").hide();
            } else if(value == "PI") {
                EVF.C("PAY_TYPE").setDisabled(false);
                EVF.C("PAY_TYPE").setRequired(true);
                EVF.C("PAY_TYPE_DUP").setRequired(true);

                // $("#panel_01").show();
            }

            // $(window).trigger("resize");
        }

        function doSearchPODT() {
            var store = new EVF.Store();
            store.setGrid([gridMTGL]);
            store.load(baseUrl + "spor0011_doSearchPODT.so", function() {
                if(gridMTGL.getRowCount() > 0 && !detailView){
                    var allRowId = gridMTGL.getAllRowId();

                    for(var i in allRowId) {
                        var rowIdx = allRowId[i];

                        if (EVF.V("PO_CREATE_TYPE") == "LAST") { // LAST:종가발주, MANUAL:수기발주
                            gridMTGL.setFigureBackground("BUYER_DEPT_NM", gridMTGL._PROPERTIES.CELL_BG_COLOR.DEFAULT);
                            gridMTGL.setFigureBackground("PURCHASE_TYPE", gridMTGL._PROPERTIES.CELL_BG_COLOR.DEFAULT);
                            gridMTGL.setFigureBackground("PO_QT", gridMTGL._PROPERTIES.CELL_BG_COLOR.DEFAULT);
                            gridMTGL.setFigureBackground("UNIT_CD", gridMTGL._PROPERTIES.CELL_BG_COLOR.DEFAULT);
                            gridMTGL.setFigureBackground("UNIT_PRC", gridMTGL._PROPERTIES.CELL_BG_COLOR.DEFAULT);

                            gridMTGL.setCellReadOnly(rowIdx, "PO_QT", true);
                            gridMTGL.setCellReadOnly(rowIdx, "UNIT_CD", true);
                            gridMTGL.setCellReadOnly(rowIdx, "UNIT_PRC", true);
                            gridMTGL.setCellReadOnly(rowIdx, "PURCHASE_TYPE", true);
                        } else if (EVF.V("PO_CREATE_TYPE") == "MANUAL") {
                            gridMTGL.setFigureBackground("UNIT_CD", gridMTGL._PROPERTIES.CELL_BG_COLOR.DEFAULT);

                            if (gridMTGL.getCellValue(rowIdx, "MAJOR_ITEM_FLAG") == "1") {   // 대표품목
                                gridMTGL.setCellRequired(rowIdx, "ITEM_DESC", true);
                                gridMTGL.setCellReadOnly(rowIdx, "ITEM_DESC", false);
                                gridMTGL.setCellEdgeColor(rowIdx, "ITEM_SPEC", true, "gray");
                                gridMTGL.setCellReadOnly(rowIdx, "ITEM_SPEC", false);
                                gridMTGL.setCellEdgeColor(rowIdx, "MAKER_PART_NO", true, "gray");
                                gridMTGL.setCellReadOnly(rowIdx, "MAKER_PART_NO", false);
                                gridMTGL.setCellEdgeColor(rowIdx, "ORIGIN_CD", true, "gray");
                                gridMTGL.setCellReadOnly(rowIdx, "ORIGIN_CD", false);
                                gridMTGL.setCellRequired(rowIdx, "UNIT_CD", true);
                                gridMTGL.setCellReadOnly(rowIdx, "UNIT_CD", false);
                            } else {
                                gridMTGL.setCellRequired(rowIdx, "ITEM_DESC", false);
                                gridMTGL.setCellReadOnly(rowIdx, "ITEM_DESC", true);
                                gridMTGL.setCellReadOnly(rowIdx, "ITEM_SPEC", true);
                                gridMTGL.setCellReadOnly(rowIdx, "MAKER_NM", true);
                                gridMTGL.setCellReadOnly(rowIdx, "MAKER_PART_NO", true);
                                gridMTGL.setCellReadOnly(rowIdx, "ORIGIN_CD", true);
                                gridMTGL.setCellReadOnly(rowIdx, "UNIT_CD", true);
                            }
                        }
                    }
                }
            });
        }

        function doSearchPOPY() {
            var store = new EVF.Store();
            store.setGrid([gridPOPY]);
            store.load(baseUrl + "spor0011_doSearchPOPY.so", function () {
                if (gridPOPY.getRowCount() > 0) {
                    var PC_INFO = gridPOPY.getCellValue(0, "PC_INFO");

                    gridPOPC.addRow(JSON.parse(PC_INFO));

                    EVF.V("PAY_CNT", gridPOPY.getRowCount());
                }
            });
        }

        function doClose() {
            EVF.closeWindow();
        }

    </script>

    <e:window id="SPOR0011" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">
        <e:buttonBar width="100%" align="right" title="${SPOR0011_003}">
            <e:button id="doClose" name="doClose" label="${doClose_N}" onClick="doClose" disabled="${doClose_D}" visible="${doClose_V}"/>
        </e:buttonBar>

        <e:inputHidden id="PO_CREATE_TYPE" name="PO_CREATE_TYPE" value="${formData.PO_CREATE_TYPE}"/>
        <e:inputHidden id="BUYER_CD" name="BUYER_CD" value="${formData.BUYER_CD}"/>
        <e:inputHidden id="DEPT_CD" name="DEPT_CD" value="${formData.DEPT_CD}"/>
        <e:inputHidden id="CTRL_CD" name="CTRL_CD" value="${formData.CTRL_CD}"/>
        <e:inputHidden id="RMK_TEXT_NUM" name="RMK_TEXT_NUM" value="${formData.RMK_TEXT_NUM }" />
   		<e:inputHidden id='APP_DOC_NUM' name="APP_DOC_NUM" value="${empty param.appDocNum ? formData.APP_DOC_NUM : param.appDocNum}" />
    	<e:inputHidden id='APP_DOC_CNT' name="APP_DOC_CNT" value="${formData.APP_DOC_CNT}" />
    	<e:inputHidden id='PRE_SIGN_STATUS' name="PRE_SIGN_STATUS" value="${formData.SIGN_STATUS}" />
    	<e:inputHidden id='SIGN_STATUS' name="SIGN_STATUS" value="${formData.SIGN_STATUS}" />
    	<e:inputHidden id="approvalFormData" name="approvalFormData"/>
    	<e:inputHidden id="approvalGridData" name="approvalGridData"/>
	    <e:inputHidden id="attachFileDatas" name="attachFileDatas" visible="false" />

<%--일반정보--%>
        <e:searchPanel id="sp" title="${form_CAPTION_N}" labelWidth="${labelWidth}" useTitleBar="false" width="100%" columnCount="2" onEnter="">
            <e:row>
                <e:label for="PO_NUM" title="${form_PO_NUM_N}" />
                <e:field>
                    <e:inputText id="PO_NUM" name="PO_NUM" value="${formData.PO_NUM}" width="${form_PO_NUM_W}" maxLength="${form_PO_NUM_M}" disabled="${form_PO_NUM_D}" readOnly="${form_PO_NUM_RO}" required="${form_PO_NUM_R}" style="${imeMode}" maskType="${form_PO_NUM_MT}"/>
                </e:field>
                <e:label for="SUBJECT" title="${form_SUBJECT_N}" visible="false" />
                <e:field>
                    <e:inputText id="SUBJECT" name="SUBJECT" value="${formData.SUBJECT}" width="${form_SUBJECT_W}" maxLength="${form_SUBJECT_M}" disabled="${form_SUBJECT_D}" readOnly="${form_SUBJECT_RO}" required="${form_SUBJECT_R}" style="${imeMode}" maskType="${form_SUBJECT_MT}"/>
                </e:field>
            </e:row>

            <e:row>
                <e:label for="VENDOR_CD" title="${form_VENDOR_CD_N}"/>
                <e:field>
                    <e:search id="VENDOR_CD" name="VENDOR_CD" value="${formData.VENDOR_CD}" width="40%" maxLength="${form_VENDOR_CD_M}" onIconClick="onIconClickVENDOR_CD" disabled="${form_VENDOR_CD_D}" readOnly="${form_VENDOR_CD_RO}" required="${form_VENDOR_CD_R}" maskType="${form_VENDOR_CD_MT}" />
                    <e:inputText id="VENDOR_NM" name="VENDOR_NM" value="${formData.VENDOR_NM}" width="60%" maxLength="${form_VENDOR_NM_M}" disabled="${form_VENDOR_NM_D}" readOnly="${form_VENDOR_NM_RO}" required="${form_VENDOR_NM_R}" style="${imeMode}" maskType="${form_VENDOR_NM_MT}"/>
                </e:field>
                <e:label for="PO_CREATE_DATE" title="${form_PO_CREATE_DATE_N}"/>
                <e:field>
                    <e:inputDate id="PO_CREATE_DATE" name="PO_CREATE_DATE" value="${formData.PO_CREATE_DATE}" width="${inputDateWidth}" datePicker="true" required="${form_PO_CREATE_DATE_R}" disabled="${form_PO_CREATE_DATE_D}" readOnly="${form_PO_CREATE_DATE_RO}" />
                </e:field>
            </e:row>

            <e:row>
                <e:label for="CUR" title="${form_PO_AMT_N}"/>
                <e:field colSpan="3">
                    <e:inputNumber id="PO_AMT" name="PO_AMT" value="${formData.PO_AMT}" width="${form_PO_AMT_W}" maxValue="${form_PO_AMT_M}" decimalPlace="${form_PO_AMT_NF}" disabled="${form_PO_AMT_D}" readOnly="${form_PO_AMT_RO}" required="${form_PO_AMT_R}" onNumberKr="${form_PO_AMT_KR}" currencyText="${form_PO_AMT_CT}"/>
                    <e:select id="CUR" name="CUR" value="${formData.CUR}" options="${curOptions}" onChange="onChangeCUR" width="${form_CUR_W}" disabled="${form_CUR_D}" readOnly="${form_CUR_RO}" required="${form_CUR_R}" placeHolder="" maskType="${form_CUR_MT}" />
                    <e:select id="VAT_TYPE" name="VAT_TYPE" value="${formData.VAT_TYPE}" options="${vatTypeOptions}" onChange="onChangeVAT_TYPE" width="${form_VAT_TYPE_W}" disabled="${form_VAT_TYPE_D}" readOnly="${form_VAT_TYPE_RO}" required="${form_VAT_TYPE_R}" placeHolder="" maskType="${form_VAT_TYPE_MT}" />
                </e:field>
            </e:row>

            <e:row>
                <e:label for="DELIVERY_TYPE" title="${form_DELIVERY_TYPE_N}"/>
                <e:field>
                    <e:select id="DELIVERY_TYPE" name="DELIVERY_TYPE" value="${formData.DELIVERY_TYPE}" onChange="onChangeDELIVERY_TYPE" options="${deliveryTypeOptions}" width="${form_DELIVERY_TYPE_W}" disabled="${form_DELIVERY_TYPE_D}" readOnly="${form_DELIVERY_TYPE_RO}" required="${form_DELIVERY_TYPE_R}" placeHolder="" maskType="${form_DELIVERY_TYPE_MT}" />
                </e:field>
                <e:label for="PAY_TYPE" title="${form_PAY_TYPE_N}"/>
                <e:field>
                    <e:select id="PAY_TYPE" name="PAY_TYPE" value="${formData.PAY_TYPE}" options="${payTypeOptions}" onChange="onChangePAY_TYPE" width="${form_PAY_TYPE_W}" disabled="${form_PAY_TYPE_D}" readOnly="${form_PAY_TYPE_RO}" required="${form_PAY_TYPE_R}" placeHolder="" maskType="${form_PAY_TYPE_MT}" />
                </e:field>
            </e:row>

            <e:row>
                <e:label for="CTRL_USER_ID" title="${form_CTRL_USER_ID_N}" />
                <e:field>
                    <e:inputText id="CTRL_USER_ID" name="CTRL_USER_ID" value="${formData.CTRL_USER_ID}" width="40%" maxLength="${form_CTRL_USER_ID_M}" disabled="${form_CTRL_USER_ID_D}" readOnly="${form_CTRL_USER_ID_RO}" required="${form_CTRL_USER_ID_R}" style="${imeMode}" maskType="${form_CTRL_USER_ID_MT}"/>
                    <e:inputText id="CTRL_USER_NM" name="CTRL_USER_NM" value="${formData.CTRL_USER_NM}" width="60%" maxLength="${form_CTRL_USER_NM_M}" disabled="${form_CTRL_USER_NM_D}" readOnly="${form_CTRL_USER_NM_RO}" required="${form_CTRL_USER_NM_R}" style="${imeMode}" maskType="${form_CTRL_USER_NM_MT}"/>
                </e:field>
                <e:label for="INSPECT_USER_ID" title="${form_INSPECT_USER_ID_N}"/>
                <e:field>
                    <e:search id="INSPECT_USER_ID" name="INSPECT_USER_ID" value="${formData.INSPECT_USER_ID}" width="40%" maxLength="${form_INSPECT_USER_ID_M}" onIconClick="onIconClickINSPECT_USER_ID" disabled="${form_INSPECT_USER_ID_D}" readOnly="${form_INSPECT_USER_ID_RO}" required="${form_INSPECT_USER_ID_R}" maskType="${form_INSPECT_USER_ID_MT}" />
                    <e:inputText id="INSPECT_USER_NM" name="INSPECT_USER_NM" value="${formData.INSPECT_USER_NM}" width="60%" maxLength="${form_INSPECT_USER_NM_M}" disabled="${form_INSPECT_USER_NM_D}" readOnly="${form_INSPECT_USER_NM_RO}" required="${form_INSPECT_USER_NM_R}" style="${imeMode}" maskType="${form_INSPECT_USER_NM_MT}"/>
                </e:field>
            </e:row>

            <e:row>
                <e:label for="RMK_TEXT_NUM" title="${form_RMK_TEXT_NUM_N}" />
                <e:field colSpan="3">
                    <e:richTextEditor id="RMK_TEXT" name="RMK_TEXT" value="${formData.RMK_TEXT}" width="${form_RMK_TEXT_NUM_W}" height="200px" disabled="${form_RMK_TEXT_NUM_D}" readOnly="${form_RMK_TEXT_NUM_RO}" required="${form_RMK_TEXT_NUM_R}" style="${imeMode}"/>
                </e:field>
            </e:row>

            <e:row>
                <e:label for="ATT_FILE_NUM" title="${form_ATT_FILE_NUM_N}" />
                <e:field colSpan="3">
                    <e:fileManager id="ATT_FILE_NUM" width="${form_ATT_FILE_NUM_W}" height="100px" fileId="${formData.ATT_FILE_NUM}" bizType="OM" readOnly="${form_ATT_FILE_NUM_RO}" required="${form_ATT_FILE_NUM_R}"/>
                </e:field>
            </e:row>
        </e:searchPanel>

<%--품목정보--%>
        <e:buttonBar width="100%" align="right" title="${SPOR0011_004}">
        </e:buttonBar>
        <e:gridPanel id="gridMTGL" name="gridMTGL" width="100%" height="210px" gridType="${_gridType}" readOnly="${param.detailView}" />

<e:panel id="panel_01">
        <e:title title="${SPOR0011_005}"/>
        <e:panel width="5%"><e:br/></e:panel>

<%--대금지불정보--%>
        <e:panel width="95%">
            <e:searchPanel id="sp2" title="" labelWidth="${labelWidth}" useTitleBar="false" width="100%" columnCount="2" onEnter="" >
                <e:row>
                    <e:label for="PAY_TYPE_DUP" title="${form_PAY_TYPE_N}"/>
                    <e:field>
                        <e:select id="PAY_TYPE_DUP" name="PAY_TYPE_DUP" value="${formData.PAY_TYPE}" options="${payTypeOptions}" width="${form_PAY_TYPE_W}" disabled="${form_PAY_TYPE_D}" readOnly="true" required="${form_PAY_TYPE_R}" placeHolder="" maskType="${form_PAY_TYPE_MT}" />
                    </e:field>
                    <e:label for="PAY_CNT" title="${form_PAY_CNT_N}"/>
                    <e:field>
                        <e:inputNumber id="PAY_CNT" name="PAY_CNT" value="${formData.PAY_CNT}" width="${form_PAY_CNT_W}" maxValue="${form_PAY_CNT_M}" decimalPlace="${form_PAY_CNT_NF}" disabled="${form_PAY_CNT_D}" readOnly="${form_PAY_CNT_RO}" required="${form_PAY_CNT_R}" onNumberKr="${form_PAY_CNT_KR}" currencyText="${form_PAY_CNT_CT}"/>
                    </e:field>
                </e:row>

                <e:row>
                    <e:label for="CUR_DUP" title="${form_PO_AMT_N}"/>
                    <e:field>
                        <e:inputNumber id="PO_AMT_DUP" name="PO_AMT_DUP" value="${formData.PO_AMT}" onChange="onChangePO_AMT" width="${form_PO_AMT_W}" maxValue="${form_PO_AMT_M}" decimalPlace="${form_PO_AMT_NF}" disabled="${form_PO_AMT_D}" readOnly="true" required="${form_PO_AMT_R}" onNumberKr="${form_PO_AMT_KR}" currencyText="${form_PO_AMT_CT}"/>
                        <e:select id="CUR_DUP" name="CUR_DUP" value="${formData.CUR}" options="${curOptions}" width="${form_CUR_W}" disabled="${form_CUR_D}" readOnly="true" required="${form_CUR_R}" placeHolder="" maskType="${form_CUR_MT}" />
                        <e:select id="VAT_TYPE_DUP" name="VAT_TYPE_DUP" value="${formData.VAT_TYPE}" options="${vatTypeOptions}" width="${form_VAT_TYPE_W}" disabled="${form_VAT_TYPE_D}" readOnly="true" required="${form_VAT_TYPE_R}" placeHolder="" maskType="${form_VAT_TYPE_MT}" />
                    </e:field>
                    <e:label for="BUYER_DEPT_NM" title="${form_BUYER_DEPT_NM_N}" />
                    <e:field>
                        <e:inputText id="BUYER_DEPT_NM" name="BUYER_DEPT_NM" value="${formData.BUYER_DEPT_NM}" width="${form_BUYER_DEPT_NM_W}" maxLength="${form_BUYER_DEPT_NM_M}" disabled="${form_BUYER_DEPT_NM_D}" readOnly="${form_BUYER_DEPT_NM_RO}" required="${form_BUYER_DEPT_NM_R}" style="${imeMode}" maskType="${form_BUYER_DEPT_NM_MT}"/>
                    </e:field>
                </e:row>
            </e:searchPanel>

    <%--지불정보--%>
            <e:buttonBar width="100%" align="right" title="${SPOR0011_006}">
            </e:buttonBar>

            <e:gridPanel id="gridPOPY" name="gridPOPY" width="100%" height="210px" gridType="${_gridType}" readOnly="${param.detailView}" />

    <%--고객사별 지불고객사 정보--%>
            <e:title title="${SPOR0011_007}"/>
            <e:gridPanel id="gridPOPC" name="gridPOPC" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}"/>
        </e:panel>
</e:panel>

        <e:buttonBar width="100%" align="right">
            <e:button id="doClose2" name="doClose2" label="${doClose_N}" onClick="doClose" disabled="${doClose_D}" visible="${doClose_V}"/>
        </e:buttonBar>

        <e:panel id="panel_hide">
            <e:gridPanel id="gridTEMP" name="gridTEMP" width="" height="" gridType="${_gridType}" readOnly="${param.detailView}"/>
        </e:panel>
    </e:window>
</e:ui>
