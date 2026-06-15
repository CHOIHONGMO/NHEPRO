<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
    <script>
        var grid1;
        var grid2;
        var grid3;
        var grid4;
        var itemList;
        var parentClass;
        var saveClassCode;
        var init;
        var baseUrl = "/nhepro/OITR/OITR0040/";

        var activeGrid1RowId;
        var activeGrid2RowId;
        var activeGrid3RowId;
        var activeGrid4RowId;

        function init() {
            grid1 = EVF.C("grid1");
            grid2 = EVF.C("grid2");
            grid3 = EVF.C("grid3");
            grid4 = EVF.C("grid4");

            grid1.setProperty("shrinkToFit", true);					// 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
            grid1.setProperty("rowNumbers", ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
            grid1.setProperty("sortable", ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
            grid1.setProperty("panelVisible", ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            grid1.setProperty("enterToNextRow", ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            grid1.setProperty("acceptZero", ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            grid1.setProperty("multiSelect", ${multiSelect});			// [선택] 컬럼의 사용여부를 지정한다. [true/false]
            grid1.setProperty("singleSelect", ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]

            grid2.setProperty("shrinkToFit", true);					// 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
            grid2.setProperty("rowNumbers", ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
            grid2.setProperty("sortable", ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
            grid2.setProperty("panelVisible", ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            grid2.setProperty("enterToNextRow", ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            grid2.setProperty("acceptZero", ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            grid2.setProperty("multiSelect", ${multiSelect});			// [선택] 컬럼의 사용여부를 지정한다. [true/false]
            grid2.setProperty("singleSelect", ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]

            grid3.setProperty("shrinkToFit", true);					// 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
            grid3.setProperty("rowNumbers", ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
            grid3.setProperty("sortable", ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
            grid3.setProperty("panelVisible", ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            grid3.setProperty("enterToNextRow", ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            grid3.setProperty("acceptZero", ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            grid3.setProperty("multiSelect", ${multiSelect});			// [선택] 컬럼의 사용여부를 지정한다. [true/false]
            grid3.setProperty("singleSelect", ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]

            grid4.setProperty("shrinkToFit", true);					// 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
            grid4.setProperty("rowNumbers", ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
            grid4.setProperty("sortable", ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
            grid4.setProperty("panelVisible", ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            grid4.setProperty("enterToNextRow", ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            grid4.setProperty("acceptZero", ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            grid4.setProperty("multiSelect", ${multiSelect});			// [선택] 컬럼의 사용여부를 지정한다. [true/false]
            grid4.setProperty("singleSelect", ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]

            grid1.cellClickEvent(function(rowIdx, colIdx) {
                EVF.C("radio1").setChecked(true);
                if(colIdx == "ITEM_CLS1") {
                    activeGrid1RowId = rowIdx;
                    onCellClick1(colIdx, rowIdx);
                }
            });
            grid2.cellClickEvent(function(rowIdx, colIdx) {
                EVF.C("radio2").setChecked(true);
                if(colIdx == "ITEM_CLS2") {
                    activeGrid2RowId = rowIdx;
                    onCellClick2(colIdx, rowIdx);
                }
            });
            grid3.cellClickEvent(function(rowIdx, colIdx) {
                EVF.C("radio3").setChecked(true);
                if(colIdx == "ITEM_CLS3") {
                    activeGrid3RowId = rowIdx;
                    onCellClick3(colIdx, rowIdx);
                }
            });
            grid4.cellClickEvent(function(rowIdx, colIdx) {
                EVF.C("radio4").setChecked(true);
                if(colIdx == "ITEM_CLS4") {
                    activeGrid4RowId = rowIdx;
                    onCellClick4(colIdx, rowIdx);
                }
            });

            grid1.addRowEvent(function() {
                grid1.addRow([{
                    INSERT_FLAG: "I",
                    ITEM_CLS_TYPE: "C1",
                    ITEM_CLS2: "*",
                    ITEM_CLS3: "*",
                    ITEM_CLS4: "*",
                    GATE_CD: "${ses.gateCd}",
                    BUYER_CD: "${ses.manageCd}",
                    USE_FLAG: "1"
                }]);
            });

            grid2.addRowEvent(function() {
                if (grid1.getRowCount() > 0 && activeGrid1RowId != -1 && grid1.getCellValue(activeGrid1RowId, "ITEM_CLS1") != null) {

                    if (grid1.getCellValue(activeGrid1RowId, "INSERT_FLAG") == "I") {
                        return EVF.alert("${OITR0040_0002}");
                    }

                    grid2.addRow([{
                        INSERT_FLAG: "I",
                        ITEM_CLS_TYPE: "C2",
                        ITEM_CLS1: grid1.getCellValue(activeGrid1RowId, "ITEM_CLS1"),
                        ITEM_CLS3: "*",
                        ITEM_CLS4: "*",
                        GATE_CD: grid1.getCellValue(activeGrid1RowId, "GATE_CD"),
                        BUYER_CD: grid1.getCellValue(activeGrid1RowId, "BUYER_CD"),
                        USE_FLAG: "1"
                    }]);

                    parentClass = "1";
                    saveClassCode = grid2.getCellValue(activeGrid2RowId, "ITEM_CLS1");

                } else {
                    EVF.alert("${OITR0040_0002}");
                }
            });

            grid3.addRowEvent(function() {
                if (grid2.getRowCount() > 0 && activeGrid2RowId != -1 && grid2.getCellValue(activeGrid2RowId, "ITEM_CLS2") != null) {

                    if (grid2.getCellValue(activeGrid2RowId, "INSERT_FLAG") == "I") {
                        return EVF.alert("${OITR0040_0003}");
                    }

                    grid3.addRow([{
                        INSERT_FLAG: "I",
                        ITEM_CLS_TYPE: "C3",
                        ITEM_CLS1: grid1.getCellValue(activeGrid1RowId, "ITEM_CLS1"),
                        ITEM_CLS2: grid2.getCellValue(activeGrid2RowId, "ITEM_CLS2"),
                        <%--ITEM_CLS3: ("${keyRule}" === "auto" ? "." : ""),--%>
                        ITEM_CLS4: "*",
                        GATE_CD: grid1.getCellValue(activeGrid1RowId, "GATE_CD"),
                        BUYER_CD: grid1.getCellValue(activeGrid1RowId, "BUYER_CD"),
                        USE_FLAG: "1"
                    }]);

                    parentClass = "2";
                    saveClassCode = grid3.getCellValue("ITEM_CLS2", activeGrid3RowId);

                } else {
                    EVF.alert("${OITR0040_0003}");
                }
            });

            grid4.addRowEvent(function() {
                if (grid3.getRowCount() > 0 && activeGrid3RowId != -1 && grid3.getCellValue(activeGrid3RowId, "ITEM_CLS3") != null) {

                    if (grid3.getCellValue(activeGrid3RowId, "INSERT_FLAG") == "I") {
                        return EVF.alert("${OITR0040_0004}");
                    }

                    grid4.addRow([{
                        INSERT_FLAG: "I",
                        ITEM_CLS_TYPE: "C4",
                        ITEM_CLS1: grid1.getCellValue(activeGrid1RowId, "ITEM_CLS1"),
                        ITEM_CLS2: grid2.getCellValue(activeGrid2RowId, "ITEM_CLS2"),
                        ITEM_CLS3: grid3.getCellValue(activeGrid3RowId, "ITEM_CLS3"),
                        <%--ITEM_CLS4: ("${keyRule}" === "auto" ? "." : ""),--%>
                        GATE_CD: grid1.getCellValue(activeGrid1RowId, "GATE_CD"),
                        BUYER_CD: grid1.getCellValue(activeGrid1RowId, "BUYER_CD"),
                        USE_FLAG: "1"
                    }]);

                    parentClass = "3";
                    saveClassCode = grid4.getCellValue("ITEM_CLS3", activeGrid4RowId);

                } else {
                    return EVF.alert("${OITR0040_0004}");
                }
            });

            var excelProp = {
                allItems: "${excelExport.allCol}",
                fileName: "${screenName }"
            };

            grid1.excelExportEvent(excelProp);
            grid2.excelExportEvent(excelProp);
            grid3.excelExportEvent(excelProp);
            grid4.excelExportEvent(excelProp);

            setLinkStyle();
            doSearch();
        }

        function setLinkStyle() {
            grid1.setColFontColor("ITEM_CLS1", "#000DFF");
            grid1.setColFontUnderline("ITEM_CLS1", true);

            grid2.setColFontColor("ITEM_CLS2", "#000DFF");
            grid2.setColFontUnderline("ITEM_CLS2", true);

            grid3.setColFontColor("ITEM_CLS3", "#000DFF");
            grid3.setColFontUnderline("ITEM_CLS3", true);

            grid4.setColFontColor("ITEM_CLS4", "#000DFF");
            grid4.setColFontUnderline("ITEM_CLS4", true);
        }

        function onCellClick1(colIdx, rowIdx) {
            if (colIdx === "ITEM_CLS1" && grid1.getCellValue(rowIdx, "INSERT_FLAG") !== "I") {
                grid2.checkAll(true);
                grid2.delRow();
                grid3.checkAll(true);
                grid3.delRow();
                grid4.checkAll(true);
                grid4.delRow();

                EVF.V("ITEM_CLS_CLICKED", grid1.getCellValue(rowIdx, "ITEM_CLS1"));
                EVF.V("ITEM_CLS_TYPE_CLICKED", grid1.getCellValue(rowIdx, "ITEM_CLS_TYPE"));
                var store = new EVF.Store();
                store.setGrid([grid2, grid3, grid4]);
                store.getGridData(grid2, "all");
                store.load(baseUrl + "oitr0040_doSearchChild.so", function () {
                    if(grid2.getRowCount() != 0) {
                        EVF.C("radio2").setChecked(true);
                        activeGrid2RowId = 0;
                        onCellClick2("ITEM_CLS2", 0);
                    }
                }, false);
            }
        }

        function onCellClick2(colIdx, rowIdx) {
            if (colIdx === "ITEM_CLS2" && grid2.getCellValue(rowIdx, "INSERT_FLAG") !== "I") {
                grid3.checkAll(true);
                grid3.delRow();
                grid4.checkAll(true);
                grid4.delRow();

                EVF.V("ITEM_CLS_CLICKED", grid2.getCellValue(rowIdx, "ITEM_CLS2"));
                EVF.V("ITEM_CLS_TYPE_CLICKED", grid2.getCellValue(rowIdx, "ITEM_CLS_TYPE"));
                var store = new EVF.Store();
                store.setGrid([grid3]);
                store.getGridData(grid3, "all");
                store.load(baseUrl + "oitr0040_doSearchChild.so", function () {
                    if(grid3.getRowCount() != 0) {
                        EVF.C("radio3").setChecked(true);
                        activeGrid3RowId = 0;
                        onCellClick3("ITEM_CLS3", 0);
                    }
                }, false);
            }
        }

        function onCellClick3(colIdx, rowIdx) {
            if (colIdx === "ITEM_CLS3" && grid3.getCellValue(rowIdx, "INSERT_FLAG") !== "I") {
                EVF.V("ITEM_CLS_CLICKED", grid3.getCellValue(rowIdx, "ITEM_CLS3"));
                EVF.V("ITEM_CLS_TYPE_CLICKED", grid3.getCellValue(rowIdx, "ITEM_CLS_TYPE"));
                var store = new EVF.Store();
                store.setGrid([grid4]);
                store.getGridData(grid4, "all");
                store.load(baseUrl + "oitr0040_doSearchChild.so", function () {
                    if(grid4.getRowCount() != 0) {
                        EVF.C("radio4").setChecked(true);
                        activeGrid4RowId = 0;
                        onCellClick4("ITEM_CLS4", 0);
                    }
                }, false);
            }
        }

        function onCellClick4(colIdx, rowIdx) {
            var gridClass = grid4;
        }

        function doSearch() {
            if(EVF.V("USE_FLAG")=="0" || EVF.V("ITEM_CLS_NM")!=""){
                init ="N"
            }else{
                init ="Y";
                EVF.V("ITEM_CLS", "C1");
            }

            var store = new EVF.Store();
            store.load(baseUrl + "oitr0040_doSearch.so", function () {
                itemList = JSON.parse(this.getParameter("refItemList"));
                if (itemList.length > 0) {
                    if (init == "Y") {
                        EVF.V("ITEM_CLS", "");
                    }
                    renderItemClass();
                } else {
                    grid1.checkAll(true);
                    grid2.checkAll(true);
                    grid3.checkAll(true);
                    grid4.checkAll(true);
                    grid1.delRow();
                    grid2.delRow();
                    grid3.delRow();
                    grid4.delRow();
                    EVF.alert("${msg.M0002 }");
                }
            });
        }

        function renderItemClass() {
            var itemClass = EVF.V("ITEM_CLS");

            if (itemClass == "" || itemClass == null) {
                if (itemClass == "") {
                    itemClass = "C1";
                }
            }

            var grid1Data = [];
            var grid2Data = [];
            var grid3Data = [];
            var grid4Data = [];

            grid1.checkAll(true);
            grid2.checkAll(true);
            grid3.checkAll(true);
            grid4.checkAll(true);
            grid1.delRow();
            grid2.delRow();
            grid3.delRow();
            grid4.delRow();

            for (var i = 0, length = itemList.length; i < length; i++) {
                var itemClassType = itemList[i].ITEM_CLS_TYPE;
                switch (itemClassType) {
                    case "C1":
                        insertClass(grid1Data, i);
                        break;
                    case "C2":
                        insertClass(grid2Data, i);
                        break;
                    case "C3":
                        insertClass(grid3Data, i);
                        break;
                    case "C4":
                        insertClass(grid4Data, i);
                        break;
                }
            }

            grid1.setGridData(grid1Data);
            grid2.setGridData(grid2Data);
            grid3.setGridData(grid3Data);
            grid4.setGridData(grid4Data);

            if (grid1.getRowCount() > 0) {
                if(EVF.V("USE_FLAG") == "0" || EVF.V("ITEM_CLS_NM") != ""){

                }else{
                    EVF.C("radio1").setChecked(true);
                    activeGrid1RowId = 0;
                    onCellClick1("ITEM_CLS1", 0);
                    if (EVF.V("ITEM_CLS") != "") {
                        searchAfter(itemClass);
                    }
                }
            }
        }

        function searchAfter(itemClass) {
            if(itemClass == "C1"){
                EVF.C("radio1").setChecked(true);
                activeGrid1RowId = 0;
                onCellClick1("ITEM_CLS1", 0);
            }else if(itemClass == "C2"){
                EVF.C("radio2").setChecked(true);
                activeGrid2RowId = 0;
                onCellClick2("ITEM_CLS2", 0);
            }else if(itemClass == "C3"){
                EVF.C("radio3").setChecked(true);
                activeGrid3RowId = 0;
                onCellClick3("ITEM_CLS3", 0);
            }else if(itemClass == "C4"){
                EVF.C("radio4").setChecked(true);
                activeGrid4RowId = 0;
                onCellClick4("ITEM_CLS4", 0);
            }
        }

        function insertClass(gridData, fromIndex) {
            gridData.push({
                ITEM_CLS1 : itemList[fromIndex].ITEM_CLS1,
                ITEM_CLS_ORI: itemList[fromIndex].ITEM_CLS_ORI, //itemList[fromIndex].ITEM_CLS + itemList[fromIndex].ITEM_CLS_TYPE.substring(1, 2),
                ITEM_CLS2: itemList[fromIndex].ITEM_CLS2,
                ITEM_CLS3: itemList[fromIndex].ITEM_CLS3,
                ITEM_CLS4: itemList[fromIndex].ITEM_CLS4,
                ITEM_CLS_NM: itemList[fromIndex].ITEM_CLS_NM,
                ITEM_CLS_TYPE: itemList[fromIndex].ITEM_CLS_TYPE,
                USE_FLAG: itemList[fromIndex].USE_FLAG,
                GATE_CD: itemList[fromIndex].GATE_CD,
                BUYER_CD: itemList[fromIndex].BUYER_CD,
                SORT_SQ: itemList[fromIndex].SORT_SQ,
                INSERT_FLAG: "U"
            });
        }

        function getActiveGrid() {
            var radioArray = ["radio1", "radio2", "radio3", "radio4"];
            var gridArray = ["grid1", "grid2", "grid3", "grid4"];

            for (var i = 0; i < radioArray.length; i++) {
                if (EVF.C(radioArray[i]).isChecked()) {
                    return gridArray[i];
                }
            }
        }

        function getActiveRadio() {
            var radioArray = ["radio1", "radio2", "radio3", "radio4"];

            for (var i = 0; i < radioArray.length; i++) {
                if (EVF.C(radioArray[i]).isChecked()) {
                    return radioArray[i];
                }
            }
        }

        function doSave() {
            var activeGridId = getActiveGrid();

            if (activeGridId == undefined) {
                return EVF.alert("${OITR0040_0001}");
            }

            var activeGrid = EVF.C(activeGridId);

            <%-- 대분류를 제외한 모든 컬럼의 코드가 자동생성(auto)일 때만 유효성을 체크한다. --%>
            if (getActiveRadio() !== "radio1" && "${keyRule}" === "auto") {

                var selectedRowIds = activeGrid.getSelRowId();
                for(var i in selectedRowIds) {
                    var selRowId = selectedRowIds[i];
                    var colValue = activeGrid.getCellValue(selRowId, "ITEM_CLS_NM");
                    if(EVF.isEmpty(colValue)) {
                        return EVF.alert("${OITR0040_0005}"); <%-- 코드명을 입력하시기 바랍니다. --%>
                    }
                }
            } else {
                if (activeGrid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
                if(!activeGrid.validate().flag) { return EVF.alert(activeGrid.validate().msg); }
            }

            EVF.confirm("${msg.M0021 }", function () {
                var store = new EVF.Store();
                store.setGrid([activeGrid]);
                store.getGridData(activeGrid, "sel");

                if (getActiveRadio() == "radio1") {
                    parentClass = undefined;
                    saveClassCode = undefined;

                    store.setParameter("CLASS_TO_SAVE", "C1");
                    store.load(baseUrl + "oitr0040_doSave.so", function () {
                        EVF.alert(this.getResponseMessage(), function() {
                            doSearch();
                        });
                    });
                } else if (getActiveRadio() == "radio2") {
                    parentClass = "1";
                    saveClassCode = grid1.getCellValue(activeGrid1RowId, "ITEM_CLS1");

                    store.setParameter("CLASS_TO_SAVE", "C2");
                    store.load(baseUrl + "oitr0040_doSave.so", function () {
                        EVF.alert(this.getResponseMessage(), function() {
                            doSearch();
                        });
                    });
                } else if (getActiveRadio() == "radio3") {
                    parentClass = "2";
                    saveClassCode = grid2.getCellValue(activeGrid2RowId, "ITEM_CLS2");

                    store.setParameter("CLASS_TO_SAVE", "C3");
                    store.load(baseUrl + "oitr0040_doSave.so", function () {
                        EVF.alert(this.getResponseMessage(), function() {
                            doSearch();
//                          onCellClick2("ITEM_CLS2", saveClassRow);
                        });
                    });
                } else if (getActiveRadio() == "radio4") {
                    parentClass = "3";
                    saveClassCode = grid3.getCellValue(activeGrid3RowId, "ITEM_CLS3");

                    store.setParameter("CLASS_TO_SAVE", "C4");
                    store.load(baseUrl + "oitr0040_doSave.so", function () {
                        EVF.alert(this.getResponseMessage(), function() {
                            doSearch();
//                          onCellClick3("ITEM_CLS3", saveClassRow);
                        });
                    });
                }
            });
        }

        function doDelete() {
            var activeGridId = getActiveGrid();
            if (activeGridId == undefined) { return EVF.alert("${OITR0040_0001}"); }

            var activeGrid = EVF.C(activeGridId);

            if (activeGrid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

            EVF.confirm("${msg.M0013 }", function () {
                var store = new EVF.Store();

                if (getActiveRadio() == "radio1") {
                    store.setParameter("CLASS_TO_DELETE", "C1");
                } else if (getActiveRadio() == "radio2") {
                    store.setParameter("CLASS_TO_DELETE", "C2");
                } else if (getActiveRadio() == "radio3") {
                    store.setParameter("CLASS_TO_DELETE", "C3");
                } else if (getActiveRadio() == "radio4") {
                    store.setParameter("CLASS_TO_DELETE", "C4");
                }

                store.setGrid([activeGrid]);
                store.getGridData(activeGrid, "sel");
                store.load(baseUrl + "oitr0040_doDelete.so", function () {
                    if(this.getResponseMessage() == "X"){
                        return EVF.alert("${OITR0040_0005}");
                    } else {
                        EVF.alert("${msg.M0017 }", function() {
                            activeGrid.delRow();
                            <%-- 지운 값을 기준으로 그 다음 분류의 그리드는 모두 초기화시켜버린다. --%>
                            switch (activeGridId) {
                                case "grid1":
                                    grid2.checkAll(true);
                                    grid2.delRow();
                                    grid3.checkAll(true);
                                    grid3.delRow();
                                    grid4.checkAll(true);
                                    grid4.delRow();
                                    break;
                                case "grid2":
                                    grid3.checkAll(true);
                                    grid3.delRow();
                                    grid4.checkAll(true);
                                    grid4.delRow();
                                    break;
                                case "grid3":
                                    grid4.checkAll(true);
                                    grid4.delRow();
                                    break;
                            }
                        });
                    }
                });
            });
        }

    </script>
    <%-- IM04_001 --%>
    <e:window id="OITR0040" onReady="init" initData="${initData}" title="${fullScreenName}">
        <e:inputHidden id="BUYER_CD" name="BUYER_CD" value="${ses.manageCd}" />
        <e:searchPanel id="form" title="${form_CAPTION_N}" labelWidth="${labelWidth}" labelAlign="${labelAlign}" columnCount="2" useTitleBar="false" onEnter="doSearch">
            <e:label for="ITEM_CLS" title="${form_ITEM_CLS_NM_N}"/>
            <e:field>
                <e:select id="ITEM_CLS" name="ITEM_CLS" value="${form.ITEM_CLS}" options="${itemClsOptions}" width="40%" disabled="${form_ITEM_CLS_D}" readOnly="${form_ITEM_CLS_RO}" required="${form_ITEM_CLS_R}" placeHolder="" usePlaceHolder="false"  maskType="${form_ITEM_CLS_MT}"/>
                <e:inputText id="ITEM_CLS_NM" name="ITEM_CLS_NM" width="60%" maxLength="${form_ITEM_CLS_NM_M }" required="${form_ITEM_CLS_NM_R }" readOnly="${form_ITEM_CLS_NM_RO }" disabled="${form_ITEM_CLS_NM_D}" visible="${form_ITEM_CLS_NM_V}" maskType="${form_ITEM_CLS_NM_MT}" />
            </e:field>
            <e:label for="ITEM_CLS" title="${form_USE_FLAG_N}"/>
            <e:field>
                <e:select id="USE_FLAG" name="USE_FLAG" value="${form.USE_FLAG}" options="${useFlagOptions}" width="${form_USE_FLAG_W}" disabled="${form_USE_FLAG_D}" readOnly="${form_USE_FLAG_RO}" required="${form_USE_FLAG_R}" placeHolder=""  maskType="${form_USE_FLAG_MT}"/>
                <e:inputHidden id="ITEM_CLS_CLICKED" name="ITEM_CLS_CLICKED"/>
                <e:inputHidden id="ITEM_CLS_TYPE_CLICKED" name="ITEM_CLS_TYPE_CLICKED"/>
            </e:field>
        </e:searchPanel>

        <e:buttonBar align="right" width="100%">
            <e:button label="${doSearch_N }" id="doSearch" onClick="doSearch" disabled="${doSearch_D }" visible="${doSearch_V }" data="${doSearch_A}"/>
            <c:if test="${ses.ctrlCd != null && ses.ctrlCd != '' }">
                <e:button label="${doSave_N }" id="doSave" onClick="doSave" disabled="${doSave_D }" visible="${doSave_V }" data="${doSave_A}"/>
                <e:button label="${doDelete_N }" id="doDelete" onClick="doDelete" disabled="${doDelete_D }" visible="${doDelete_V }" data="${doDelete_A}"/>
            </c:if>
        </e:buttonBar>

        <e:panel id="radioPanel" height="100%" width="100%">
            <e:panel id="pn1" width="24%">
                <e:radio id="radio1" name="radio" label="${form_RADIO1_N }" required="${form_RADIO1_R }" readOnly="${form_RADIO1_RO }"/>
            </e:panel>
            <e:panel id="pn1_1" width="1%">&nbsp;</e:panel>
            <e:panel id="pn2" width="24%">
                <e:radio id="radio2" name="radio" label="${form_RADIO2_N }" required="${form_RADIO2_R }" readOnly="${form_RADIO2_RO }"/>
            </e:panel>
            <e:panel id="pn2_1" width="1%">&nbsp;</e:panel>
            <e:panel id="pn3" width="24%">
                <e:radio id="radio3" name="radio" label="${form_RADIO3_N }" required="${form_RADIO3_R }" readOnly="${form_RADIO3_RO }"/>
            </e:panel>
            <e:panel id="pn3_1" width="1%">&nbsp;</e:panel>
            <e:panel id="pn4" width="24%">
                <e:radio id="radio4" name="radio" label="${form_RADIO4_N }" required="${form_RADIO4_R }" readOnly="${form_RADIO4_RO }"/>
            </e:panel>
        </e:panel>
        <e:panel id="gridPanel" height="100%" width="100%">
            <e:panel id="pn11" height="fit" width="24%">
                <e:gridPanel gridType="${_gridType}" id="grid1" name="grid1" width="100%" height="fit" readOnly="${param.detailView}"/>
            </e:panel>
            <e:panel id="pn11_1" width="1%">&nbsp;</e:panel>
            <e:panel id="pn22" height="fit" width="24%">
                <e:gridPanel gridType="${_gridType}" id="grid2" name="grid2" width="100%" height="fit" readOnly="${param.detailView}"/>
            </e:panel>
            <e:panel id="pn22_1" width="1%">&nbsp;</e:panel>
            <e:panel id="pn33" height="fit" width="24%">
                <e:gridPanel gridType="${_gridType}" id="grid3" name="grid3" width="100%" height="fit" readOnly="${param.detailView}"/>
            </e:panel>
            <e:panel id="pn33_1" width="1%">&nbsp;</e:panel>
            <e:panel id="pn44" height="fit" width="25%">
                <e:gridPanel gridType="${_gridType}" id="grid4" name="grid4" width="100%" height="fit" readOnly="${param.detailView}"/>
            </e:panel>
        </e:panel>
    </e:window>
</e:ui>