<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
    <link rel="StyleSheet" href="/js/everuxf/lib/dtree/dtree.css" type="text/css" />
    <script type="text/javascript" src="/js/everuxf/lib/dtree/dtree.js"></script>
    <script>
        var grid;
        var gridTree;
        var baseUrl = "/nhepro/CCUR/CCUR0023/";
        var selRowId;
        var treeViewObj;

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
            
            treeViewObj = gridTree.getGridViewObj();
            treeViewObj.setHeader({visible: true});
            treeViewObj.setCheckBar({visible: false});
            treeViewObj.setIndicator({visible: false});

            gridTree.setColCursor("ITEM_CLS_NM", "pointer");

            // Right Grid
            grid = EVF.C("grid");

            grid.setProperty("shrinkToFit", false);					// 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
            grid.setProperty("rowNumbers", ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
            grid.setProperty("sortable", ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
            grid.setProperty("panelVisible", ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            grid.setProperty("enterToNextRow", ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            grid.setProperty("acceptZero", ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            grid.setProperty("multiSelect", false);					// [선택] 컬럼의 사용여부를 지정한다. [true/false]

            grid.cellClickEvent(function(rowIdx, colIdx, value) {
                if (colIdx == "USER_NM") {
                    doChoose(rowIdx);
                }
            });

            grid.excelExportEvent({
                allItems: "${excelExport.allCol}",
                fileName: "${screenName }"
            });

            doSearchTree();
        }

        function doSearchTree() {
            var store = new EVF.Store();
            store.load(baseUrl + "ccur0023_doSearchTree.so", function() {

                var treeData = this.getParameter("treeData");
                var jsonTree = JSON.parse(treeData);

                gridTree.getDataProvider().setRows(jsonTree, "tree", true, "", "icon");
                treeViewObj.expandAll(); //전체펼치기
            });
        }

        // 품목 분류 Tree 조회
        function doSearch() {
            var store = new EVF.Store();
            store.setGrid([grid]);
            store.load(baseUrl + 'ccur0023_doSearch.so', function() {
                if(grid.getRowCount() == 0){
                    EVF.alert("${msg.M0002 }");
                }
            });
        }

        function doClean(){
            var selectedData = null;

            if(${param.ModalPopup == true}){
                parent["${param.callBackFunction}"](selectedData);
            } else {
                opener["${param.callBackFunction}"](selectedData);
            }
            doClose();
        }

        function doChoose(rowIdx) {

            var selectedData = grid.getRowValue(rowIdx);

            if(${param.ModalPopup == true}){
                parent["${param.callBackFunction}"](selectedData);
            }else{
                opener["${param.callBackFunction}"](selectedData);
            }

            doClose();
        }

        function doClose() {
            EVF.closeWindow();
        }

    </script>
    <%-- IM04_008 --%>
    <e:window id="CCUR0023" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">
        <e:panel id="leftPanel" width="30%">
            <e:searchPanel id="form1" title="${msg.M9999}" labelWidth="${labelWidth}" columnCount="1" useTitleBar="false">
                <%-- 사무소명 --%>
                <e:label for="DEPT_NM_L" title="${form1_DEPT_NM_L_N}" />
                <e:field>
                    <e:inputText id="DEPT_NM_LT" name="DEPT_NM_LT" value="" width="${form1_DEPT_NM_L_W}" maxLength="${form1_DEPT_NM_L_M}" disabled="${form1_DEPT_NM_L_D}" readOnly="${form1_DEPT_NM_L_RO}" required="${form1_DEPT_NM_L_R}" style="${imeMode}" maskType="${form1_DEPT_NM_L_MT}"/>
                </e:field>
            </e:searchPanel>

            <e:buttonBar id="buttonBar1" align="right" width="100%">
                <e:button id="doSearchLeft" name="doSearchLeft" label="${doSearchLeft_N}" onClick="doSearchTree" disabled="${doSearchLeft_D}" visible="${doSearchLeft_V}"/>
            </e:buttonBar>

            <e:gridPanel id="gridTree" name="gridTree" width="100%" height="fit" gridType="RGT" readOnly="${param.detailView}"/>
        </e:panel>

        <e:panel width="1%">&nbsp;</e:panel>

        <e:panel id="rightPanel" width="68%">
            <e:searchPanel id="form" title="${msg.M9999}" labelWidth="${labelWidth}" columnCount="2" useTitleBar="false" onEnter="doSearch">
                <e:row>
                    <%-- 사무소코드 --%>
                    <e:label for="DEPT_C" title="${form_DEPT_C_N}" />
                    <e:field>
                        <e:inputText id="DEPT_C" name="DEPT_C" value="" width="${form_DEPT_C_W}" maxLength="${form_DEPT_C_M}" disabled="${form_DEPT_C_D}" readOnly="${form_DEPT_C_RO}" required="${form_DEPT_C_R}" style="${imeMode}" maskType="${form_DEPT_C_MT}"/>
                        <e:checkGroup id="UP_DEPT_C" name="UP_DEPT_C" width="100%" value="" disabled="${form_UP_DEPT_C_D}" readOnly="${form_UP_DEPT_C_RO}" required="${form_UP_DEPT_C_R}">
                            <e:check id="UP_DEPT_C1" name="UP_DEPT_C1" value="1"  />
                        </e:checkGroup>
                        <e:text>${form_UP_DEPT_C_N}</e:text>
                    </e:field>
                    <%-- 사무소명 --%>
                    <e:label for="DEPT_NM" title="${form_DEPT_NM_N}" />
                    <e:field>
                        <e:inputText id="DEPT_NM" name="DEPT_NM" value="" width="${form_DEPT_NM_W}" maxLength="${form_DEPT_NM_M}" disabled="${form_DEPT_NM_D}" readOnly="${form_DEPT_NM_RO}" required="${form_DEPT_NM_R}" style="${imeMode}" maskType="${form_DEPT_NM_MT}"/>
                    </e:field>
                </e:row>
                <e:row>
                    <%-- 성명 --%>
                    <e:label for="USER_NM" title="${form_USER_NM_N}" />
                    <e:field>
                        <e:inputText id="USER_NM" name="USER_NM" value="" width="${form_USER_NM_W}" maxLength="${form_USER_NM_M}" disabled="${form_USER_NM_D}" readOnly="${form_USER_NM_RO}" required="${form_USER_NM_R}" style="${imeMode}" maskType="${form_USER_NM_MT}"/>
                    </e:field>
                    <%-- ID(사번) --%>
                    <e:label for="USER_ID" title="${form_USER_ID_N}" />
                    <e:field>
                        <e:inputText id="USER_ID" name="USER_ID" value="" width="${form_USER_ID_W}" maxLength="${form_USER_ID_M}" disabled="${form_USER_ID_D}" readOnly="${form_USER_ID_RO}" required="${form_USER_ID_R}" style="${imeMode}" maskType="${form_USER_ID_MT}"/>
                    </e:field>
                </e:row>
            </e:searchPanel>

            <e:buttonBar id="buttonBar" align="right" width="100%">
                <e:button id="doSearch" name="doSearch" label="${doSearch_N}" onClick="doSearch" disabled="${doSearch_D}" visible="${doSearch_V}"/>
                <%--<e:button id="doChoose" name="doChoose" label="${doChoose_N}" onClick="doChoose" disabled="${doChoose_D}" visible="${doChoose_V}"/>--%>
                <e:button id="doClean" name="doClean" label="${doClean_N}" onClick="doClean" disabled="${doClean_D}" visible="${doClean_V}"/>
            </e:buttonBar>

            <e:gridPanel id="grid" name="grid" width="100%" height="100%" gridType="${_gridType}" readOnly="${param.detailView}"/>
        </e:panel>
    </e:window>

</e:ui>
