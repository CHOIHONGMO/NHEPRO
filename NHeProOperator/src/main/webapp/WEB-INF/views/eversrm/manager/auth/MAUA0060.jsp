<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">

    <script type="text/javascript">

        var s_userGrid, s_ctrlGrid, menuGrid, historymenuGrid, buttonGrid, userGrid, ctrlGrid;

        var tab2_menuGrid, tab2_buttonGrid, tab2_userGrid, tab2_ctrlGrid;

        var baseUrl = "/eversrm/manager/auth/MAUA0060/";

        var treeViewObj;
        var selectUserNm;

        function init() {

            s_userGrid = EVF.C("s_userGrid");
            s_ctrlGrid = EVF.C("s_ctrlGrid");
            menuGrid = EVF.C("menuGrid");
            buttonGrid = EVF.C("buttonGrid");
            userGrid = EVF.C("userGrid");
            ctrlGrid = EVF.C("ctrlGrid");
            historymenuGrid = EVF.C("historymenuGrid");

            tab2_menuGrid = EVF.C("tab2_menuGrid");
            tab2_buttonGrid = EVF.C("tab2_buttonGrid");
            tab2_userGrid = EVF.C("tab2_userGrid");
            tab2_ctrlGrid = EVF.C("tab2_ctrlGrid");

            // 사용자
            s_userGrid.setProperty('shrinkToFit', true);		        // 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
            s_userGrid.setProperty('rowNumbers', ${rowNumbers});		// 로우의 번호 표시 여부를 지정한다. [true/false]
            s_userGrid.setProperty('sortable', ${sortable});			// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
            s_userGrid.setProperty('panelVisible', ${panelVisible});	// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            s_userGrid.setProperty('enterToNextRow', ${enterToNextRow});// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            s_userGrid.setProperty('acceptZero', ${acceptZero});		// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            s_userGrid.setProperty('multiSelect', false);		        // [선택] 컬럼의 사용여부를 지정한다. [true/false]

            // 직무
            s_ctrlGrid.setProperty('shrinkToFit', true);
            s_ctrlGrid.setProperty('rowNumbers', ${rowNumbers});
            s_ctrlGrid.setProperty('sortable', ${sortable});
            s_ctrlGrid.setProperty('panelVisible', ${panelVisible});
            s_ctrlGrid.setProperty('enterToNextRow', ${enterToNextRow});
            s_ctrlGrid.setProperty('acceptZero', ${acceptZero});
            s_ctrlGrid.setProperty('multiSelect', false);

            // 전체메뉴
            menuGrid.setProperty('shrinkToFit', true);
            menuGrid.setProperty('rowNumbers', ${rowNumbers});
            menuGrid.setProperty('sortable', ${sortable});
            menuGrid.setProperty('panelVisible', ${panelVisible});
            menuGrid.setProperty('enterToNextRow', ${enterToNextRow});
            menuGrid.setProperty('acceptZero', ${acceptZero});
            menuGrid.setProperty('multiSelect', false);

            // 버튼권한 - 메뉴
            tab2_menuGrid.setProperty('shrinkToFit', true);
            tab2_menuGrid.setProperty('rowNumbers', ${rowNumbers});
            tab2_menuGrid.setProperty('sortable', ${sortable});
            tab2_menuGrid.setProperty('panelVisible', ${panelVisible});
            tab2_menuGrid.setProperty('enterToNextRow', ${enterToNextRow});
            tab2_menuGrid.setProperty('acceptZero', ${acceptZero});
            tab2_menuGrid.setProperty('multiSelect', false);

            // 메뉴단위 버튼
            buttonGrid.setProperty('shrinkToFit', true);
            buttonGrid.setProperty('rowNumbers', ${rowNumbers});
            buttonGrid.setProperty('sortable', ${sortable});
            buttonGrid.setProperty('panelVisible', ${panelVisible});
            buttonGrid.setProperty('enterToNextRow', ${enterToNextRow});
            buttonGrid.setProperty('acceptZero', ${acceptZero});
            buttonGrid.setProperty('multiSelect', false);

            // 메뉴/버튼 사용자 권한매핑 현황
            userGrid.setProperty('shrinkToFit', true);
            userGrid.setProperty('rowNumbers', ${rowNumbers});
            userGrid.setProperty('sortable', ${sortable});
            userGrid.setProperty('panelVisible', ${panelVisible});
            userGrid.setProperty('enterToNextRow', ${enterToNextRow});
            userGrid.setProperty('acceptZero', ${acceptZero});
            userGrid.setProperty('multiSelect', false);

            // 메뉴/버튼 직무 권한매핑 현황
            ctrlGrid.setProperty('shrinkToFit', true);
            ctrlGrid.setProperty('rowNumbers', ${rowNumbers});
            ctrlGrid.setProperty('sortable', ${sortable});
            ctrlGrid.setProperty('panelVisible', ${panelVisible});
            ctrlGrid.setProperty('enterToNextRow', ${enterToNextRow});
            ctrlGrid.setProperty('acceptZero', ${acceptZero});
            ctrlGrid.setProperty('multiSelect', false);

            tab2_buttonGrid.setProperty('shrinkToFit', true);
            tab2_buttonGrid.setProperty('rowNumbers', ${rowNumbers});
            tab2_buttonGrid.setProperty('sortable', ${sortable});
            tab2_buttonGrid.setProperty('panelVisible', ${panelVisible});
            tab2_buttonGrid.setProperty('enterToNextRow', ${enterToNextRow});
            tab2_buttonGrid.setProperty('acceptZero', ${acceptZero});
            tab2_buttonGrid.setProperty('multiSelect', ${param.detailView == true ? false : multiSelect});

            tab2_userGrid.setProperty('shrinkToFit', true);
            tab2_userGrid.setProperty('rowNumbers', ${rowNumbers});
            tab2_userGrid.setProperty('sortable', ${sortable});
            tab2_userGrid.setProperty('panelVisible', ${panelVisible});
            tab2_userGrid.setProperty('enterToNextRow', ${enterToNextRow});
            tab2_userGrid.setProperty('acceptZero', ${acceptZero});
            tab2_userGrid.setProperty('multiSelect', ${param.detailView == true ? false : multiSelect});

            tab2_ctrlGrid.setProperty('shrinkToFit', true);
            tab2_ctrlGrid.setProperty('rowNumbers', ${rowNumbers});
            tab2_ctrlGrid.setProperty('sortable', ${sortable});
            tab2_ctrlGrid.setProperty('panelVisible', ${panelVisible});
            tab2_ctrlGrid.setProperty('enterToNextRow', ${enterToNextRow});
            tab2_ctrlGrid.setProperty('acceptZero', ${acceptZero});
            tab2_ctrlGrid.setProperty('multiSelect', ${param.detailView == true ? false : multiSelect});

            var treeViewObj = menuGrid.getGridViewObj();
            treeViewObj.setHeader({visible: true});
            treeViewObj.setCheckBar({visible: true});
            treeViewObj.setIndicator({visible: false});

            treeViewObj.setTreeOptions({showCheckBox: true});
            menuGrid.setColCursor('MENU_NM', 'pointer');
            menuGrid.setColReadOnly('CTRL_MAPPING_YN', true);

            menuGrid.setColReadOnly('USER_MAPPING_YN', true);
            var treeViewObj_tab2 = tab2_menuGrid.getGridViewObj();
            treeViewObj_tab2.setHeader({visible: true});
//          treeViewObj_tab2.setCheckBar({visible: false});
            treeViewObj_tab2.setIndicator({visible: false});
            tab2_menuGrid.setColCursor('MENU_NM', 'pointer');

            s_userGrid.cellClickEvent(function (rowIdx, colIdx) {
                if (colIdx == "USER_ID_V") {
                    EVF.V("CtrlClickYn", "");
                    EVF.V("userClickYn", "Y");
                    EVF.V("title", "※ 적용대상 : " + s_userGrid.getCellValue(rowIdx, "USER_NM"));
                    selectUserNm = s_userGrid.getCellValue(rowIdx, "USER_NM");
                    EVF.V("USER_ID", s_userGrid.getCellValue(rowIdx, "USER_ID"));

                    doSearch_Ctrl();
                    doSearchTree();
                }
            });

            s_ctrlGrid.cellClickEvent(function (rowIdx, colIdx) {
                if (colIdx == "CTRL_NM") {
                    EVF.V("CtrlClickYn", "Y");
                    EVF.V("userClickYn", "");
                    EVF.V("CTRL_CD", s_ctrlGrid.getCellValue(rowIdx, "CTRL_CD"));
                    EVF.V("title", "${MAUA0060_TITLE8 }" + s_ctrlGrid.getCellValue(rowIdx, "CTRL_NM"));
                    doSearchTree();
                }
            });

            menuGrid.cellClickEvent(function (rowIdx, colIdx) {

                if (colIdx == "MENU_NM") {
                    EVF.V("SCREEN_ID", menuGrid.getCellValue(rowIdx, 'SCREEN_ID'));
                }
                else if (colIdx == "CTRL_MAPPING_YN") {
                    if (EVF.V("CtrlClickYn") != "Y") {
                        menuGrid.setColReadOnly('CTRL_MAPPING_YN', true);
                        return EVF.alert("${MAUA0060_002 }");
                    } else {
                        menuGrid.setColReadOnly('CTRL_MAPPING_YN', false);
                        var allRowId = menuGrid.getAllRowId();
                        if (menuGrid.getCellValue(rowIdx, 'LVL') == "1") {
                            for (var i in allRowId) {
                                var rowIds = allRowId[i];
                                var datum = menuGrid.getRowValue(rowIds);

                                if (rowIds != rowIdx) {
                                    if (datum['CLS1'] == menuGrid.getCellValue(rowIdx, 'CLS1')) {
                                        if (menuGrid.getCellValue(rowIdx, 'CTRL_MAPPING_YN') == "0") {
                                            menuGrid.setCellValue(rowIds, 'CTRL_MAPPING_YN', '1');
                                        } else {
                                            menuGrid.setCellValue(rowIds, 'CTRL_MAPPING_YN', '0');
                                        }
                                    }
                                }
                            }
                        } else if (menuGrid.getCellValue(rowIdx, 'LVL') == "2") {
                            for (var i in allRowId) {
                                var rowIds = allRowId[i];
                                var datum = menuGrid.getRowValue(rowIds);
                                if (rowIds != rowIdx) {
                                    if (datum['CLS2'] == menuGrid.getCellValue(rowIdx, 'CLS2')) {
                                        if (menuGrid.getCellValue(rowIdx, 'CTRL_MAPPING_YN') == "0") {
                                            menuGrid.setCellValue(rowIds, 'CTRL_MAPPING_YN', '1');
                                        } else {
                                            menuGrid.setCellValue(rowIds, 'CTRL_MAPPING_YN', '0');
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                else if (colIdx == "USER_MAPPING_YN") {
                    if (EVF.V("userClickYn") != "Y") {
                        menuGrid.setColReadOnly('USER_MAPPING_YN', true);
                        return EVF.alert("${MAUA0060_003 }");
                    } else {
                        menuGrid.setColReadOnly('USER_MAPPING_YN', false);
                        var allRowId = menuGrid.getAllRowId();
                        if (menuGrid.getCellValue(rowIdx, 'LVL') == "1") {
                            for (var i in allRowId) {
                                var rowIds = allRowId[i];
                                var datum = menuGrid.getRowValue(rowIds);

                                if (rowIds != rowIdx) {
                                    if (datum['CLS1'] == menuGrid.getCellValue(rowIdx, 'CLS1')) {
                                        if (menuGrid.getCellValue(rowIdx, 'USER_MAPPING_YN') == "0") {
                                            menuGrid.setCellValue(rowIds, 'USER_MAPPING_YN', '1');
                                        } else {
                                            menuGrid.setCellValue(rowIds, 'USER_MAPPING_YN', '0');
                                        }
                                    }
                                }
                            }
                        } else if (menuGrid.getCellValue(rowIdx, 'LVL') == "2") {
                            for (var i in allRowId) {
                                var rowIds = allRowId[i];
                                var datum = menuGrid.getRowValue(rowIds);
                                if (rowIds != rowIdx) {
                                    if (datum['CLS2'] == menuGrid.getCellValue(rowIdx, 'CLS2')) {
                                        if (menuGrid.getCellValue(rowIdx, 'USER_MAPPING_YN') == "0") {
                                            menuGrid.setCellValue(rowIds, 'USER_MAPPING_YN', '1');
                                        } else {
                                            menuGrid.setCellValue(rowIds, 'USER_MAPPING_YN', '0');
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            });

            tab2_menuGrid.cellClickEvent(function (rowIdx, colIdx) {

                if (colIdx == "MENU_NM") {
                    EVF.V("SCREEN_ID", tab2_menuGrid.getCellValue(rowIdx, 'SCREEN_ID'));
                    EVF.V("SCREEN_NM", tab2_menuGrid.getCellValue(rowIdx, 'MENU_NM'));
                    tab2_buttonGrid.delAllRow();
                    doSearch_DT_Button_Tab2();
                }
            });

            tab2_buttonGrid.cellClickEvent(function (rowIdx, colIdx) {
                if (colIdx == "ACTION_CD") {
                    EVF.V("tab2_buttonGrid_YN", "Y");
                    EVF.V("SCREEN_ID", tab2_buttonGrid.getCellValue(rowIdx, "SCREEN_ID"));
                    EVF.V("ACTION_CD", tab2_buttonGrid.getCellValue(rowIdx, "ACTION_CD"));
                    tab2_userGrid.delAllRow();
                    tab2_ctrlGrid.delAllRow();
                    doSearch_DT_Tab2();
                }
            });

            doSearchTree();

            doSearch_Ctrl();

            doSearchTree_tab2();

            gridResize();
        }

        function gridResize() {
            s_ctrlGrid.resize();
            menuGrid.resize();
            ctrlGrid.resize();
        }

        $(document.body).ready(function () {
            $('#e-tabs').height(($('.ui-layout-center').height() - 30)).tabs(
                {
                    activate: function (event, ui) {
                        $(window).trigger('resize');
                    }
                }
            );
            $('#e-tabs').tabs('option', 'active', 0);
            getContentTab('1');
        });

        function getContentTab(uu) {
            if (uu == '1') {
                window.scrollbars = true;
            }
            if (uu == '2') {
                window.scrollbars = true;
            }
        }

        function doSearch() {

            var store = new EVF.Store();
            store.setGrid([s_userGrid]);
            store.load(baseUrl + 'doSearch_UserList.so', function () {
                if (s_userGrid.getRowCount() == 0) {
                    EVF.alert("${msg.M0002 }", function() {
                        doClear();
                    });
                } else {

                }
            });
        }

        function doSearch_Ctrl() {

            var store = new EVF.Store();
            store.setGrid([s_ctrlGrid]);
            store.load(baseUrl + 'doSearch_CtrlList.so', function () {

            });
        }

        function doSearch_DT(){

            var store = new EVF.Store();
            store.setGrid([buttonGrid]);
            store.load(baseUrl + 'doSearch_ButtonList.so', function() {

                var store = new EVF.Store();
                store.setGrid([userGrid]);
                store.load(baseUrl + 'doSearch_Menu_UserList.so', function() {
                    var store = new EVF.Store();
                    store.setGrid([ctrlGrid]);
                    store.load(baseUrl + 'doSearch_Menu_CtrlList.so', function() {

                    }, false);
                }, false);
            }, false);
        }

        function doSearchTree() {

            var store = new EVF.Store();
            store.load(baseUrl + 'doSearch_menuTree.so', function () {

                var treeData = this.getParameter("treeData");
                var jsonTree = JSON.parse(treeData);

                menuGrid.getDataProvider().setRows(jsonTree, 'tree', '', '', 'icon');
                treeViewObj = menuGrid.getGridViewObj();
                treeViewObj.expandAll();
            });
        }

        function doSearch_DT_Tab1(){

            var store = new EVF.Store();
            store.setGrid([userGrid]);
            store.load(baseUrl + 'doSearch_Button_UserList_Tab1.so', function() {
                var store = new EVF.Store();
                store.setGrid([ctrlGrid]);
                store.load(baseUrl + 'doSearch_Button_CtrlList_Tab1.so', function() {

                });
            });
        }

        function doSave() {

            var checkMappingYn = "";
            var allRowId = menuGrid.getAllRowId();
            for (var i in allRowId) {
                var rowIds = allRowId[i];
                var datum = menuGrid.getRowValue(rowIds);

                if (EVF.V("CtrlClickYn") == "Y") {
                    if (datum['CTRL_MAPPING_YN'] == "1") {
                        if (datum['SCREEN_ID'] == " " || datum['SCREEN_ID'] == "") {

                        } else {
                            checkMappingYn = "Y";
                        }
                    }
                }
                if (EVF.V("userClickYn") == "Y") {
                    if (datum['USER_MAPPING_YN'] == "1") {
                        if (datum['SCREEN_ID'] == " " || datum['SCREEN_ID'] == "") {

                        } else {
                            checkMappingYn = "Y";
                        }
                    }
                }
            }

            EVF.confirm("${msg.M0021}", function() {

                doSetMenuHistoryTable();

                var store = new EVF.Store();
                store.setGrid([menuGrid, historymenuGrid]);
                store.getGridData(menuGrid, 'all');
                store.getGridData(historymenuGrid, 'all');
                store.load(baseUrl + 'doSave_Menu_Auth.so', function () {
                    EVF.alert(this.getResponseMessage(), function() {
                        doSearchTree();
                    });
                });
            });
        }

        function doSave2(){

            if(ctrlGrid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

            EVF.confirm("${msg.M0021}", function() {
                var store = new EVF.Store();
                store.setGrid([ctrlGrid]);
                store.getGridData(ctrlGrid, 'all');
                store.load(baseUrl + 'doSave_Menu_Auth_CTRL.so', function() {
                    EVF.alert(this.getResponseMessage(), function() {
                        var store = new EVF.Store();
                        store.setGrid([ctrlGrid]);
                        store.load(baseUrl + 'doSearch_Button_CtrlList_Tab1.so', function() {

                        });
                    });
                });
            });
        }

        function doSetMenuHistoryTable() {

            var addParam = [];
            var chType;
            var allRowId = menuGrid.getAllRowId();
            for (var ri in allRowId) {
                var rowIdx = allRowId[ri];

                if (menuGrid.getCellValue(rowIdx, 'SCREEN_ID') != "") {

                    if (menuGrid.getCellValue(rowIdx, 'CTRL_MAPPING_YN') != menuGrid.getCellValue(rowIdx, 'HIDDEN_CTRL_MAP_YN')) {

                        if (menuGrid.getCellValue(rowIdx, 'CTRL_MAPPING_YN') == "0") {
                            chType = "D";
                        } else {
                            chType = "C";
                        }

                        addParam = [{
                            "SCREEN_ID": menuGrid.getCellValue(rowIdx, 'SCREEN_ID')
                            , "DATA_TYPE": 'J'
                            , "DATA_CD": EVF.V("CTRL_CD")
                            , "CH_TYPE": chType
                        }];
                        historymenuGrid.addRow(addParam);
                    }
                    if (menuGrid.getCellValue(rowIdx, 'USER_MAPPING_YN') != menuGrid.getCellValue(rowIdx, 'HIDDEN_USER_MAP_YN')) {

                        if (menuGrid.getCellValue(rowIdx, 'USER_MAPPING_YN') == "0") {
                            chType = "C";
                        } else {
                            chType = "D";
                        }

                        addParam = [{

                            "SCREEN_ID": menuGrid.getCellValue(rowIdx, 'SCREEN_ID')
                            , "DATA_TYPE": 'U'
                            , "DATA_CD": EVF.V("USER_ID")
                            , "CH_TYPE": chType
                        }];
                        historymenuGrid.addRow(addParam);
                    }
                }
            }
        }

        function doClear() {
            s_ctrlGrid.delAllRow();
            menuGrid.delAllRow();
            buttonGrid.delAllRow();
            userGrid.delAllRow();
            ctrlGrid.delAllRow();
        }

        function doSearchTree_tab2() {

            var store = new EVF.Store();
            store.load(baseUrl + 'doSearch_menuTree.so', function () {

                var treeData = this.getParameter("treeData");
                var jsonTree = JSON.parse(treeData);

                tab2_menuGrid.getDataProvider().setRows(jsonTree, 'tree', '', '', 'icon');
                var treeViewObj_tab2 = tab2_menuGrid.getGridViewObj();
                treeViewObj_tab2.expandAll();
            });
        }

        function doSearch_DT_Button_Tab2() {

            var store = new EVF.Store();
            store.setGrid([tab2_buttonGrid]);
            store.load(baseUrl + 'doSearch_ButtonList_tab2.so', function () {
                if (tab2_buttonGrid.getRowCount() != 0) {

                    EVF.V("tab2_buttonGrid_YN", "Y");
                    EVF.V("SCREEN_ID", tab2_buttonGrid.getCellValue(0, "SCREEN_ID"));
                    EVF.V("ACTION_CD", tab2_buttonGrid.getCellValue(0, "ACTION_CD"));
                    tab2_userGrid.delAllRow();
                    tab2_ctrlGrid.delAllRow();
                    doSearch_DT_Tab2();
                }
            });
        }

        function doSearch_DT_Tab2() {

            var store = new EVF.Store();
            store.setGrid([tab2_userGrid]);
            store.load(baseUrl + 'doSearch_Button_UserList_Tab2.so', function () {
                var store = new EVF.Store();
                store.setGrid([tab2_ctrlGrid]);
                store.load(baseUrl + 'doSearch_Button_CtrlList_Tab2.so', function () {

                });
            });
        }

        function Tab2_doSaveBtnGrid() {

            if (tab2_buttonGrid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

            EVF.confirm("${msg.M0021}", function() {
                var store = new EVF.Store();
                store.setGrid([tab2_buttonGrid, tab2_ctrlGrid, tab2_userGrid]);
                store.getGridData(tab2_buttonGrid, 'sel');
                store.getGridData(tab2_ctrlGrid, 'sel');
                store.getGridData(tab2_userGrid, 'sel');
                store.load(baseUrl + 'doSave_Button_Auth.so', function () {
                    EVF.alert(this.getResponseMessage(), function() {
                        doSearch_DT_Tab2();
                    });
                });
            });
        }

        function Tab2_doSaveCtrlGrid() {

            if (tab2_ctrlGrid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

            EVF.confirm("${msg.M0021}", function() {
                var store = new EVF.Store();
                store.setGrid([tab2_ctrlGrid]);
                store.getGridData(tab2_ctrlGrid, 'sel');
                store.load(baseUrl + 'doSave_Button_Auth.so', function () {
                    EVF.alert(this.getResponseMessage(), function() {
                        doSearch_DT_Tab2();
                    });
                });
            });
        }

        function Tab2_doSaveUserGrid() {

            if (tab2_userGrid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

            EVF.confirm("${msg.M0021}", function() {
                var store = new EVF.Store();
                store.setGrid([tab2_userGrid]);
                store.getGridData(tab2_userGrid, 'sel');
                store.load(baseUrl + 'doSave_Button_Auth.so', function () {
                    EVF.alert(this.getResponseMessage(), function() {
                        doSearch_DT_Tab2();
                    });
                });
            });
        }

        function Tab2_doDelete() {

            if (tab2_buttonGrid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

            if (!tab2_ctrlGrid.getSelRowCount() && !tab2_userGrid.getSelRowCount()) {
                return EVF.alert("${msg.M0004}");
            }

            EVF.confirm("${msg.M0013}", function() {
                var store = new EVF.Store();
                store.setGrid([tab2_buttonGrid, tab2_ctrlGrid, tab2_userGrid]);
                store.getGridData(tab2_buttonGrid, 'sel');
                store.getGridData(tab2_ctrlGrid, 'sel');
                store.getGridData(tab2_userGrid, 'sel');
                store.load(baseUrl + 'doDelete_Button_Auth.so', function () {
                    EVF.alert(this.getResponseMessage(), function() {
                        doSearch_DT_Tab2();
                    });
                });
            });
        }

        function doSearchCTRL() {
            var param;
            if (this.getData().data == "T1") {
                param = {
                    callBackFunction: "setCtrlCdMulti_T1"
                };
                everPopup.openCommonPopup(param, 'MP0016');
            } else {
                param = {
                    callBackFunction: "setCtrlCdMulti_T2"
                };
                everPopup.openCommonPopup(param, 'MP0016');
            }
        }

        function setCtrlCdMulti_T1(data) {

            if (data.length != undefined) {
                var dataArr = [];
                for (var idx in data) {
                    var arr = {
                        'CTRL_CD': data[idx].CTRL_CD,
                        'CTRL_NM': data[idx].CTRL_NM
                    };
                    dataArr.push(arr);
                }
                var validData = valid.equalPopupValid(JSON.stringify(dataArr), ctrlGrid, "CTRL_NM");
                ctrlGrid.addRow(validData);
            }
        }

        function setCtrlCdMulti_T2(data) {

            if (data.length != undefined) {
                var dataArr = [];
                for (var idx in data) {
                    var arr = {
                        'CTRL_CD': data[idx].CTRL_CD,
                        'CTRL_NM': data[idx].CTRL_NM
                    };
                    dataArr.push(arr);
                }
                var validData = valid.equalPopupValid(JSON.stringify(dataArr), tab2_ctrlGrid, "CTRL_NM");
                tab2_ctrlGrid.addRow(validData);
            }
        }

        function doSearchUser() {
            var param = {
                callBackFunction: "setUserCdMulti"
            };
            everPopup.openCommonPopup(param, 'MP0007');
        }

        function setUserCdMulti(data) {
            if (data.length != undefined) {
                var dataArr = [];
                for (var idx in data) {
                    var arr = {
                        'USER_ID_V': data[idx].USER_ID,
                        'DATA_CD': data[idx].USER_ID,
                        'USER_NM': data[idx].USER_NM,
                        'DEPT_NM': data[idx].DEPT_NM
                    };
                    dataArr.push(arr);
                }
                var validData = valid.equalPopupValid(JSON.stringify(dataArr), tab2_userGrid, "USER_ID");
                tab2_userGrid.addRow(validData);
            }
        }

        function getRegUserId() {
            var param = {
                callBackFunction: "setRegUserId"
            };
            everPopup.openCommonPopup(param, 'SP0011');
        }

        function setRegUserId(dataJsonArray) {
            EVF.V("COPY_USER_ID", dataJsonArray.USER_ID);
        }

        function doCopy() {

            if (EVF.V("userClickYn") == "") { return EVF.alert("${MAUA0060_003 }"); }

            if (EVF.V("COPY_USER_ID") == "") { return EVF.alert("${MAUA0060_004 }"); }

            EVF.confirm(everString.getMessage("${MAUA0060_005}", selectUserNm), function() {
                var store = new EVF.Store();
                store.load(baseUrl + 'doCopy_Auth.so', function () {
                    EVF.alert(this.getResponseMessage(), function() {
                        doSearch_DT_Tab2();
                    });
                });
            });
        }

    </script>
    <e:window id="MAUA0060" onReady="init" initData="${initData}" title="${fullScreenName}">
        <e:panel id="pnl2" width="100%" height="fit">
            <div id="e-tabs" class="e-tabs">
                <ul>
                    <li><a href="#ui-tabs-1" onclick="getContentTab('1');">메뉴 권한</a></li>
                    <li><a href="#ui-tabs-2" onclick="getContentTab('2');">버튼 권한</a></li>
                </ul>
                <e:panel id="pnl2_sub" width="100%" height="fit">

                    <%-----------------------------------------------------------------------%>
                    <div id="ui-tabs-1">
                        <e:panel id="H1" width="30%" height="fit">
                            <e:panel id="h1_f1" width="100%" height="78px">
                                <e:searchPanel id="form" title="${form_CAPTION_N }" onEnter="doSearch" labelWidth="${labelWidth}" useTitleBar="false" width="100%" columnCount="1">
                                    <e:row>
                                        <e:label for="USER_NM" title="${form_USER_NM_N}"/>
                                        <e:field>
                                            <e:inputText id="USER_NM" name="USER_NM" value="${form.USER_NM}" width="100%" maxLength="${form_USER_NM_M}" disabled="${form_USER_NM_D}" readOnly="${form_USER_NM_RO}" required="${form_USER_NM_R}" maskType="${form_USER_NM_MT}" />
                                            <e:inputHidden id="USER_ID" name="USER_ID" value=""/>
                                            <e:inputHidden id="SCREEN_ID" name="SCREEN_ID" value=""/>
                                            <e:inputHidden id="SCREEN_NM" name="SCREEN_NM" value=""/>
                                            <e:inputHidden id="ACTION_CD" name="ACTION_CD" value=""/>
                                            <e:inputHidden id="CTRL_CD" name="CTRL_CD" value=""/>

                                            <e:inputHidden id="userClickYn" name="userClickYn" value=""/>
                                            <e:inputHidden id="CtrlClickYn" name="CtrlClickYn" value=""/>
                                        </e:field>
                                    </e:row>
                                </e:searchPanel>

                                <e:buttonBar id="bt1" align="right" width="100%">
                                    <e:button id="doSearch" name="doSearch" label="${doSearch_N }" disabled="${doSearch_D }" visible="${doSearch_V }" onClick="doSearch"/>
                                </e:buttonBar>
                            </e:panel>

                            <e:panel id="h1_g1" width="100%" height="350px">
                                <e:gridPanel gridType="${_gridType}" id="s_userGrid" name="s_userGrid" width="100%" height="320px" readOnly="${param.detailView}"/>
                            </e:panel>
                            <e:panel id="h1_g2" width="100%" height="fit">
                                <e:title title="${MAUA0060_TITLE5}" depth="1"/>
                                <e:gridPanel gridType="${_gridType}" id="s_ctrlGrid" name="s_ctrlGrid" width="100%" height="fit" readOnly="${param.detailView}"/>
                            </e:panel>
                        </e:panel>

                        <e:panel id="H2_b" width="1%" height="fit">&nbsp;</e:panel>
                        <e:panel id="H2" width="41%" height="fit">
                            <e:text id="title" name="title" style="font-weight:bold; color:blue; font-size:13px; margin-right : 5px;">※ 적용대상 : </e:text>
                            <e:search id="COPY_USER_ID" name="COPY_USER_ID" value="" width="120px" maxLength="${form_COPY_USER_ID_M}" onIconClick="getRegUserId" disabled="${form_COPY_USER_ID_D}" readOnly="${form_COPY_USER_ID_RO}" required="${form_COPY_USER_ID_R}" maskType="${form_COPY_USER_ID_MT}" />
                            <e:text>&nbsp;</e:text>
                            <e:button id="copy" name="copy" label="${copy_N }" disabled="${copy_D }" visible="${copy_V }" onClick="doCopy"/>

                            <e:buttonBar id="bt2" align="right" width="100%" title="${MAUA0060_TITLE3 }">
                                <e:button id="doSave" name="doSave" label="${doSave_N }" disabled="${doSave_D }" visible="${doSave_V }" onClick="doSave"/>
                            </e:buttonBar>
                            <e:gridPanel gridType="RGT" id="menuGrid" name="menuGrid" width="100%" height="fit" readOnly="${param.detailView}"/>

                            <e:panel id="Hidden1" width="0" height="0">
                                <e:gridPanel gridType="${_gridType}" id="historymenuGrid" name="historymenuGrid" width="0" height="0" readOnly="${param.detailView}"/>
                            </e:panel>
                        </e:panel>

                        <e:panel id="H3_b" width="1%"  height="fit" >&nbsp;</e:panel>
                        <e:panel id="H3" width="27%"  height="fit">
                            <e:title title="${MAUA0060_TITLE4}" depth="1" />
                            <e:gridPanel gridType="${_gridType}" id="buttonGrid" name="buttonGrid" width="100%" height="180" readOnly="${param.detailView}"/>

                            <e:title title="${MAUA0060_TITLE1}" depth="1" />
                            <e:gridPanel gridType="${_gridType}" id="userGrid" name="userGrid" width="100%" height="300" />

                            <e:buttonBar id="tab1_btn3" align="right" width="100%" title="${MAUA0060_TITLE2 }">
                                <e:button id="doSelectBaco" name="doSelectBaco" label="${doSelectBaco_N }" disabled="${doSelectBaco_D }" visible="${doSelectBaco_V}" onClick="doSearchCTRL" data="T1"/>
                                <e:button id="doSave2" name="doSave2" label="${doSave2_N }" disabled="${doSave2_D }" visible="${doSave2_V}" onClick="doSave2" />
                            </e:buttonBar>
                            <e:gridPanel gridType="${_gridType}" id="ctrlGrid" name="ctrlGrid" width="100%" height="fit" readOnly="${param.detailView}"/>
                        </e:panel>
                    </div>

                    <%-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%>

                    <div id="ui-tabs-2">
                        <e:panel id="tab2_t1" height="400" width="50%">
                            <e:gridPanel gridType="RGT" id="tab2_menuGrid" name="tab2_menuGrid" width="100%" height="370" readOnly="${param.detailView}"/>
                        </e:panel>
                        <e:panel id="tab2_null1" height="400" width="1%">&nbsp;</e:panel>
                        <e:panel id="tab2_t2" height="400" width="49%">
                            <e:buttonBar id="tab2_btn1" align="right" width="100%" title="${MAUA0060_TITLE4 }">
                                <e:button id="Tab2_doSaveBtnGrid" name="Tab2_doSaveBtnGrid" label="${Tab2_doSaveBtnGrid_N}" onClick="Tab2_doSaveBtnGrid" disabled="${Tab2_doSaveBtnGrid_D}" visible="${Tab2_doSaveBtnGrid_V}"/>
                                <e:button id="Tab2_doDelete" name="Tab2_doDelete" label="${Tab2_doDelete_N }" disabled="${Tab2_doDelete_D }" visible="${Tab2_doDelete_V}" onClick="Tab2_doDelete"/>
                            </e:buttonBar>
                            <e:inputHidden id="tab2_buttonGrid_YN" name="tab2_buttonGrid_YN" value=""/>
                            <e:gridPanel id="tab2_buttonGrid" name="tab2_buttonGrid" width="100%" height="345" gridType="${_gridType}" readOnly="${param.detailView}"/>
                        </e:panel>
                        <e:panel id="tab2_b1" height="fit" width="50%">
                            <e:buttonBar id="tab2_btn2" align="right" width="100%" title="${MAUA0060_TITLE6 }">
                                <e:button id="doSearchCTRL" name="doSearchCTRL" label="${doSearchCTRL_N }" disabled="${doSearchCTRL_D }" visible="${doSearchCTRL_V}" onClick="doSearchCTRL" data="T2"/>
                            </e:buttonBar>
                            <e:gridPanel id="tab2_ctrlGrid" name="tab2_ctrlGrid" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}"/>
                        </e:panel>
                        <e:panel id="tab2_null2" height="fit" width="1%">&nbsp;</e:panel>
                        <e:panel id="tab2_b2" height="fit" width="49%">
                            <e:buttonBar id="tab2_btn3" align="right" width="100%" title="${MAUA0060_TITLE7 }">
                                <e:button id="doSearchUser" name="doSearchUser" label="${doSearchUser_N }" disabled="${doSearchUser_D }" visible="${doSearchUser_V}" onClick="doSearchUser"/>
                            </e:buttonBar>
                            <e:gridPanel id="tab2_userGrid" name="tab2_userGrid" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}"/>
                        </e:panel>
                    </div>
                </e:panel>
            </div>
        </e:panel>
    </e:window>
</e:ui>