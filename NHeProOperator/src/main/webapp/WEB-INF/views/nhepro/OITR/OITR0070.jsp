<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
    <link rel="StyleSheet" href="/js/everuxf/lib/dtree/dtree.css" type="text/css" />
    <script type="text/javascript" src="/js/everuxf/lib/dtree/dtree.js"></script>
    <script>
        var grid;
        var gridTree;
        var baseUrl = "/nhepro/OITR/OITR0070/";
        var selRowId;

        function init() {
            // Left Grid
            gridTree = EVF.C("gridTree");

            gridTree.setProperty("shrinkToFit", true);		            //컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
            gridTree.setProperty("rowNumbers", ${rowNumbers});			//로우의 번호 표시 여부를 지정한다. [true/false]
            gridTree.setProperty("sortable", ${sortable});				//컬럼 정렬기능 사용여부를 지정한다. [true/false]
            gridTree.setProperty("panelVisible", ${panelVisible});		//그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            gridTree.setProperty("enterToNextRow", ${enterToNextRow});	//셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            gridTree.setProperty("acceptZero", ${acceptZero});			//그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            gridTree.setProperty("multiSelect", ${multiSelect});		//[선택] 컬럼의 사용여부를 지정한다. [true/false]
            gridTree.setProperty("singleSelect", ${singleSelect});		//[선택] 컬럼의 다중선택 여부를 지정한다. [true/false]
            
            var treeViewObj = gridTree.getGridViewObj();
            treeViewObj.setHeader({visible: true});
            treeViewObj.setCheckBar({visible: false});
            treeViewObj.setIndicator({visible: false});

            gridTree.setColCursor("ITEM_CLS_NM", "pointer");

            gridTree.cellClickEvent(function(rowIdx) {
                var data = gridTree.getRowValue(rowIdx);
                if( data["UPYN"] != "" ) {
                    return EVF.alert("${OITR0070_001 }");
                }
                selRowId = rowIdx;

                doSearchAttr();
            });

            // Right Grid
            grid = EVF.C("grid");

            grid.setProperty("shrinkToFit", true);					// 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
            grid.setProperty("rowNumbers", ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
            grid.setProperty("sortable", ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
            grid.setProperty("panelVisible", ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            grid.setProperty("enterToNextRow", ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            grid.setProperty("acceptZero", ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            grid.setProperty("multiSelect", true);					// [선택] 컬럼의 사용여부를 지정한다. [true/false]
            grid.setProperty("singleSelect", ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]

            grid.excelExportEvent({
                allItems: "${excelExport.allCol}",
                fileName: "${screenName }"
            });

            doSearch();
        }

        // 품목 분류 Tree 조회
        function doSearch() {
            var store = new EVF.Store();
            store.load(baseUrl + "oitr0070_doSearchTree.so", function() {

                var treeData = this.getParameter("treeData");
                var jsonTree = JSON.parse(treeData);

                gridTree.getDataProvider().setRows(jsonTree, "tree", true, "", "icon");
                var treeViewObj = gridTree.getGridViewObj();
                treeViewObj.expandAll();
            });
        }

        // 품목 분류별 속성 조회
        function doSearchAttr() {
            EVF.V("ITEM_CLS1", gridTree.getCellValue(selRowId, "ITEM_CLS1"));
            EVF.V("ITEM_CLS2", gridTree.getCellValue(selRowId, "ITEM_CLS2"));
            EVF.V("ITEM_CLS3", gridTree.getCellValue(selRowId, "ITEM_CLS3"));
            EVF.V("ITEM_CLS4", gridTree.getCellValue(selRowId, "ITEM_CLS4"));
            EVF.V("ITEM_PATH_NM", gridTree.getCellValue(selRowId, "ITEM_CLS_PATH_NM"));

            var store = new EVF.Store();
            if(!store.validate()) return;

            store.setGrid([grid]);
            store.load(baseUrl + "oitr0070_doSearch.so", function() {
            });
        }

        // 속성 팝업
        function doAdd() {
            var store = new EVF.Store();
            if(!store.validate()) return;

            var param = {
                callBackFunction: "setAttribution",
                detailView: false
            };
            everPopup.openPopupByScreenId("OITR0071", "600", "400", param);
        }

        function setAttribution(paramData) {
            var data = valid.equalPopupValid(paramData, grid, "CODE_NM");
            var arrData = [];
            for (var k = 0; k < data.length; k++) {
                var datum = data[k];
                arrData.push({
                    INSERT_FLAG: "I",
                    CODE: datum.CODE,
                    CODE_NM: datum.CODE_NM
                });
            }
            grid.addRow(arrData);
        }

        function doSave() {
            if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
            if (!grid.validate().flag ) { return EVF.alert(grid.validate().msg); }

            EVF.confirm("${msg.M0021 }", function () {
                var store = new EVF.Store();
                store.setGrid([grid]);
                store.getGridData(grid, "sel");
                store.load(baseUrl + "oitr0070_doSave.so", function(){
                    EVF.alert(this.getResponseMessage(), function() {
                        doSearchAttr();
                    });
                });
            });
        }

        function doDelete() {
            if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

            EVF.confirm("${msg.M0013 }", function () {
                var store = new EVF.Store();
                store.setGrid([grid]);
                store.getGridData(grid, "sel");
                store.load(baseUrl + "oitr0070_doDelete.so", function(){
                    EVF.alert(this.getResponseMessage(), function() {
                        doSearchAttr();
                    });
                });
            });
        }

        function doClose() {
            EVF.closeWindow();
        }

    </script>
    <%-- IM04_008 --%>
    <e:window id="OITR0070" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">
        <e:panel id="leftPanel" width="30%">
            <e:searchPanel id="form1" title="${msg.M9999}" labelWidth="${labelWidth}" columnCount="1" useTitleBar="false" onEnter="doSearch">
                <e:label for="ITEM_CLS_NM" title="${form1_ITEM_CLS_NM_N}" />
                <e:field>
                    <e:inputText id="ITEM_CLS_NM" name="ITEM_CLS_NM" value="" width="${form1_ITEM_CLS_NM_W}" maxLength="${form1_ITEM_CLS_NM_M}" disabled="${form1_ITEM_CLS_NM_D}" readOnly="${form1_ITEM_CLS_NM_RO}" required="${form1_ITEM_CLS_NM_R}"  maskType="${form_ITEM_CLS_NM_MT}" />
                </e:field>
            </e:searchPanel>

            <e:buttonBar id="buttonBar1" align="right" width="100%">
                <e:button id="doSearch" name="doSearch" label="${doSearch_N}" onClick="doSearch" disabled="${doSearch_D}" visible="${doSearch_V}"/>
            </e:buttonBar>

            <e:gridPanel id="gridTree" name="gridTree" width="100%" height="fit" gridType="RGT" readOnly="${param.detailView}"/>
        </e:panel>

        <e:panel width="1%">&nbsp;</e:panel>

        <e:panel id="rightPanel" width="68%">
            <e:searchPanel id="form" title="${msg.M9999}" labelWidth="${labelWidth}" columnCount="1" useTitleBar="false" onEnter="doSearch">
                <e:inputHidden id="ITEM_CLS1" name="ITEM_CLS1" value="" />
                <e:inputHidden id="ITEM_CLS2" name="ITEM_CLS2" value="" />
                <e:inputHidden id="ITEM_CLS3" name="ITEM_CLS3" value="" />

                <e:row>
                    <e:label for="ITEM_PATH_NM" title="${form_ITEM_PATH_NM_N}" />
                    <e:field>
                        <e:inputText id="ITEM_CLS4" name="ITEM_CLS4" value="" width="15%" maxLength="${form_ITEM_CLS4_M}" disabled="${form_ITEM_CLS4_D}" readOnly="${form_ITEM_CLS4_RO}" required="${form_ITEM_CLS4_R}"  maskType="${form_ITEM_CLS4_MT}" />
                        <e:inputText id="ITEM_PATH_NM" name="ITEM_PATH_NM" value="" width="85%" maxLength="${form_ITEM_PATH_NM_M}" disabled="${form_ITEM_PATH_NM_D}" readOnly="${form_ITEM_PATH_NM_RO}" required="${form_ITEM_PATH_NM_R}"  maskType="${form_ITEM_PATH_NM_MT}" />
                    </e:field>
                </e:row>
            </e:searchPanel>

            <e:buttonBar id="buttonBar" align="right" width="100%">
                <e:button id="doAdd" name="doAdd" label="${doAdd_N}" onClick="doAdd" disabled="${doAdd_D}" visible="${doAdd_V}"/>
                <e:button id="doSave" name="doSave" label="${doSave_N}" onClick="doSave" disabled="${doSave_D}" visible="${doSave_V}"/>
                <e:button id="doDelete" name="doDelete" label="${doDelete_N}" onClick="doDelete" disabled="${doDelete_D}" visible="${doDelete_V}"/>
            </e:buttonBar>

            <e:gridPanel id="grid" name="grid" width="100%" height="100%" gridType="${_gridType}" readOnly="${param.detailView}"/>
        </e:panel>
    </e:window>

</e:ui>
