<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
    <link rel="StyleSheet" href="/js/everuxf/lib/dtree/dtree.css" type="text/css" />
    <script type="text/javascript" src="/js/everuxf/lib/dtree/dtree.js"></script>
    <script>
        var grid, gridDt;
        var gridTree;
        var baseUrl = "/nhepro/CITI/CITR0045/";
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
                    return EVF.alert("${CITR0045_001 }");
                }
                selRowId = rowIdx;

				$(".e-text").text(" 품목분류 : " + data.ITEM_CLS_PATH_NM);
				EVF.V("ITEM_CLS1", data.ITEM_CLS1);
				EVF.V("ITEM_CLS2", data.ITEM_CLS2);
				EVF.V("ITEM_CLS3", data.ITEM_CLS3);
				EVF.V("ITEM_CLS4", data.ITEM_CLS4);
				
				doSearch();
            });

            // Right Grid
            grid = EVF.C("grid");
            grid.setProperty("shrinkToFit", ${shrinkToFit});					// 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
            grid.setProperty("rowNumbers", ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
            grid.setProperty("sortable", ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
            grid.setProperty("panelVisible", ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            grid.setProperty("enterToNextRow", ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            grid.setProperty("acceptZero", ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            grid.setProperty("multiSelect", true);					// [선택] 컬럼의 사용여부를 지정한다. [true/false]
            grid.setProperty("singleSelect", ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]
            grid.freezeCol("ITEM_CD");

            gridDt = EVF.C("gridDt");
            gridDt.setProperty("shrinkToFit", ${shrinkToFit});					// 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
            gridDt.setProperty("rowNumbers", ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
            gridDt.setProperty("sortable", ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
            gridDt.setProperty("panelVisible", ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            gridDt.setProperty("enterToNextRow", ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            gridDt.setProperty("acceptZero", ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            gridDt.setProperty("multiSelect", true);					// [선택] 컬럼의 사용여부를 지정한다. [true/false]
            gridDt.setProperty("singleSelect", ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]
            gridDt.freezeCol("ITEM_CD");

            grid.cellClickEvent(function(rowIdx, colIdx, value) {
                switch (colIdx) {
                    case "ITEM_CD":
                        // grid.checkRow(rowIdx, true);
                        doUpDown("down", false, rowIdx);
                        break;
                }
            });

            gridDt.cellClickEvent(function(rowIdx, colIdx, value) {
                var param;

                switch (colIdx) {
                    case "ITEM_CD":
                        param = {
                            ITEM_CD: gridDt.getCellValue(rowIdx, "ITEM_CD"),
                            STD_ITEM_CD: gridDt.getCellValue(rowIdx, "STD_ITEM_CD"),
                            popupFlag: true,
                            detailView: true,
                            manageFlag: "1"
                        };
                        everPopup.openPopupByScreenId("CITR0046", 1150, 663, param);
                        break;
                }
            });

            doSearchTree();
        }

        // 품목 분류 Tree 조회
        function doSearchTree() {
            var store = new EVF.Store();
            store.load(baseUrl + "citr0045_doSearchTree.so", function() {

                var treeData = this.getParameter("treeData");
                var jsonTree = JSON.parse(treeData);

                gridTree.getDataProvider().setRows(jsonTree, "tree", true, "", "icon");
                gridTree._gvo.orderBy(["SORT_SQ"],["ascending"]);
                var treeViewObj = gridTree.getGridViewObj();
                treeViewObj.expandAll();
            });
        }

        // 품목 분류별 속성 조회
        function doSearch() {
            var store = new EVF.Store();
            store.setGrid([grid]);
            store.load(baseUrl + "citr0045_doSearchGrid.so", function() {
            });
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

        function doClose() {
            EVF.closeWindow();
        }

        function getVendor() {
            EVF.alert("업무 협의 후 구현예정");
        }

        function doClear() {
	        $(".e-text").text(" 품목분류 : ");
	        EVF.V("ITEM_CLS_NM", "");
	        EVF.V("ITEM_CLS1", "");
	        EVF.V("ITEM_CLS2", "");
	        EVF.V("ITEM_CLS3", "");
	        EVF.V("ITEM_CLS4", "");

	        doSearchTree();
		}

		function doUpDown(type, btnFlag, rowIdx) {
            if( type == "up" ) {
                if (gridDt.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

                var rowIdx = gridDt.getSelRowId();
                for (var i = 0; i < rowIdx.length; i++) {
                    gridDt.delRow(rowIdx[i]);
                }

            } else {
                var data;
                if(btnFlag) {
                    if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

                    data = valid.equalPopupValid(JSON.stringify(grid.getSelRowValue()), gridDt, "ITEM_CD");

                } else {
                    var dataArr = [];
                    dataArr.push(grid.getRowValue(rowIdx));
                    data = valid.equalPopupValid(JSON.stringify(dataArr), gridDt, "ITEM_CD");
                }

                gridDt.addRow(data);
            }
        }

        function doChoose() {
            if (gridDt.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

            if(opener) {
                opener.window.focus();
                opener['${form.callbackFunction}'](gridDt.getSelRowValue());
            } else if(parent) {
                parent.window.focus();
                parent['${form.callbackFunction}'](gridDt.getSelRowValue());
            }
        }

    </script>
    <%-- IM04_008 --%>
    <e:window id="CITR0045" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">
        <e:panel id="leftPanel" width="25%">
            <e:searchPanel id="form1" title="${msg.M9999}" labelWidth="100px" columnCount="1" useTitleBar="false" onEnter="doSearchTree">
                <%-- 품목분류 --%>
                <e:label for="ITEM_CLS_NM" title="${form1_ITEM_CLS_NM_N}" />
                <e:field>
                    <e:inputText id="ITEM_CLS_NM" name="ITEM_CLS_NM" value="" width="${form1_ITEM_CLS_NM_W}" maxLength="${form1_ITEM_CLS_NM_M}" disabled="${form1_ITEM_CLS_NM_D}" readOnly="${form1_ITEM_CLS_NM_RO}" required="${form1_ITEM_CLS_NM_R}" style="${imeMode}" maskType="${form1_ITEM_CLS_NM_MT}"/>
                </e:field>
            </e:searchPanel>

            <e:buttonBar id="buttonBar1" align="right" width="100%">
                <e:button id="doSearchTree" name="doSearchTree" label="${doSearchTree_N}" onClick="doSearchTree" disabled="${doSearchTree_D}" visible="${doSearchTree_V}"/>
				<e:button id="doClear" name="doClear" label="${doClear_N}" onClick="doClear" disabled="${doClear_D}" visible="${doClear_V}"/>
			</e:buttonBar>

            <e:gridPanel id="gridTree" name="gridTree" width="100%" height="fit" gridType="RGT" readOnly="${param.detailView}"/>
        </e:panel>

        <e:panel width="1%">&nbsp;</e:panel>

        <e:panel id="rightPanel" width="74%">
            <e:searchPanel id="form" title="${msg.M9999}" labelWidth="${labelWidth}" columnCount="3" useTitleBar="false" onEnter="doSearch">
                <e:inputHidden id="ITEM_CLS1" name="ITEM_CLS1" value="" />
                <e:inputHidden id="ITEM_CLS2" name="ITEM_CLS2" value="" />
                <e:inputHidden id="ITEM_CLS3" name="ITEM_CLS3" value="" />
                <e:inputHidden id="ITEM_CLS4" name="ITEM_CLS4" value="" />

                <e:row>
                    <%-- 품목코드 --%>
                    <e:label for="ITEM_CD" title="${form_ITEM_CD_N}" />
                    <e:field>
                        <e:inputText id="ITEM_CD" name="ITEM_CD" value="" width="${form_ITEM_CD_W}" maxLength="${form_ITEM_CD_M}" disabled="${form_ITEM_CD_D}" readOnly="${form_ITEM_CD_RO}" required="${form_ITEM_CD_R}" style="${imeMode}" maskType="${form_ITEM_CD_MT}"/>
                    </e:field>
                    <%-- 품명 --%>
                    <e:label for="ITEM_DESC" title="${form_ITEM_DESC_N}" />
                    <e:field>
                        <e:inputText id="ITEM_DESC" name="ITEM_DESC" value="" width="${form_ITEM_DESC_W}" maxLength="${form_ITEM_DESC_M}" disabled="${form_ITEM_DESC_D}" readOnly="${form_ITEM_DESC_RO}" required="${form_ITEM_DESC_R}" style="${imeMode}" maskType="${form_ITEM_DESC_MT}"/>
                    </e:field>
                    <%-- 규격 --%>
                    <e:label for="ITEM_SPEC" title="${form_ITEM_SPEC_N}" />
                    <e:field>
                        <e:inputText id="ITEM_SPEC" name="ITEM_SPEC" value="" width="${form_ITEM_SPEC_W}" maxLength="${form_ITEM_SPEC_M}" disabled="${form_ITEM_SPEC_D}" readOnly="${form_ITEM_SPEC_RO}" required="${form_ITEM_SPEC_R}" style="${imeMode}" maskType="${form_ITEM_SPEC_MT}"/>
                    </e:field>
                </e:row>
                <e:row>
                    <%-- 제조사 --%>
                    <e:label for="MAKER_NM" title="${form_MAKER_NM_N}" />
                    <e:field>
                        <e:inputText id="MAKER_NM" name="MAKER_NM" value="" width="${form_MAKER_NM_W}" maxLength="${form_MAKER_NM_M}" disabled="${form_MAKER_NM_D}" readOnly="${form_MAKER_NM_RO}" required="${form_MAKER_NM_R}" style="${imeMode}" maskType="${form_MAKER_NM_MT}"/>
                    </e:field>
                    <%-- 모델번호 --%>
                    <e:label for="MAKER_PART_NO" title="${form_MAKER_PART_NO_N}" />
                    <e:field>
                        <e:inputText id="MAKER_PART_NO" name="MAKER_PART_NO" value="" width="${form_MAKER_PART_NO_W}" maxLength="${form_MAKER_PART_NO_M}" disabled="${form_MAKER_PART_NO_D}" readOnly="${form_MAKER_PART_NO_RO}" required="${form_MAKER_PART_NO_R}" style="${imeMode}" maskType="${form_MAKER_PART_NO_MT}"/>
                    </e:field>
                    <%-- 브랜드 --%>
                    <e:label for="BRAND_NM" title="${form_BRAND_NM_N}" />
                    <e:field>
                        <e:inputText id="BRAND_NM" name="BRAND_NM" value="" width="${form_BRAND_NM_W}" maxLength="${form_BRAND_NM_M}" disabled="${form_BRAND_NM_D}" readOnly="${form_BRAND_NM_RO}" required="${form_BRAND_NM_R}" style="${imeMode}" maskType="${form_BRAND_NM_MT}"/>
                    </e:field>
                </e:row>
            </e:searchPanel>

            <e:buttonBar id="buttonBar" align="right" width="100%">
				<span style="color: #333; font-size: 12px; font-weight: normal; line-height: 23px; float: left; padding-top: 1px;"><i class="fas fa-building fa-chevron-circle-right"></i></span>
				<e:text style="text-align:left;"> 품목분류 : </e:text>
                
                <e:button id="doSearch" name="doSearch" label="${doSearch_N}" onClick="doSearch" disabled="${doSearch_D}" visible="${doSearch_V}"/>
                <e:button id="doClose" name="doClose" label="${doClose_N}" onClick="doClose" disabled="${doClose_D}" visible="${doClose_V}"/>
            </e:buttonBar>
            <e:gridPanel id="grid" name="grid" width="100%" height="290" gridType="${_gridType}" readOnly="${param.detailView}"/>

            <div style="text-align: center;">
                <span style="color: #0a8eeb;">
                    <i class="fas fa-building fa-arrow-down" onclick="javascript:doUpDown('down',true)"></i>
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <i class="fas fa-building fa-arrow-up" onclick="javascript:doUpDown('up',true)"></i>
                </span>
                <e:buttonBar id="buttonBarxx" align="right" width="100%" title="선택 품목">
	                <e:button id="doChoose" name="doChoose" label="${doChoose_N}" onClick="doChoose" disabled="${doChoose_D}" visible="${doChoose_V}"/>
	            </e:buttonBar>
            </div>

            <e:gridPanel id="gridDt" name="gridDt" width="fit" height="fit" gridType="${_gridType}" readOnly="${param.detailView}"/>
        </e:panel>
    </e:window>

</e:ui>
