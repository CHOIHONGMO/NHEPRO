<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
    <script type="text/javascript">
        var gridTree;
        var addParam = [];
        var baseUrl = "/nhepro/CITI/CITR0043/";
        var treeViewObj;

        function init() {
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

            // 멀티인경우에만
            if(${param.multiYN}){
                treeViewObj.setTreeOptions({showCheckBox: true}); //체크박스
                EVF.C("doChoose").setVisible(true);
                EVF.C("doClean").setVisible(false);

            }else{
                EVF.C("doChoose").setVisible(false);
                EVF.C("doClean").setVisible(true);
            }
            if(${param.searchYN}){
                EVF.C("doClean").setVisible(true);
            }else{
                EVF.C("doClean").setVisible(false);
            }

            treeViewObj.setCheckBar({visible: false});
            treeViewObj.setIndicator({visible: false});

            // 멀티인경우
            if(${param.multiYN}){
                gridTree.cellClickEvent(function(rowIdx) {
                    //전체선택 또는 상위 카테고리 선택시 하위항목 체크활성/비활성

                    if (gridTree.isChecked(rowIdx)) {
                        gridTree._gvo.checkChildren(gridTree.getIndex(rowIdx), true, true, true, true, false);
                    }else{
                        gridTree._gvo.checkChildren(gridTree.getIndex(rowIdx), false, true, true, true, false)}
//
//                    var data = gridTree.getGridViewObj().getDescendants(gridTree.getIndex(rowIdx));
//                    var lastV;
//                    if (gridTree.isChecked(rowIdx)) {
//                        for (var i in data) {
//                            console.log(data[i]);
//                            gridTree.getGridViewObj().checkRow(data[i], true);
//                            lastV = data[i];
//                        }
//                        gridTree.getGridViewObj().checkRow(lastV + 1, true);
//                    } else {
//                        for (var i in data) {
//                            gridTree.getGridViewObj().checkRow(data[i], false);
//                            lastV = data[i];
//                        }
//                        gridTree.getGridViewObj().checkRow(lastV + 1, false);
//                    }
                });
                // 싱글일경우 : 바로 선택값 넘기기
            } else {
                gridTree.cellClickEvent(function(rowIdx) {

                    var data = gridTree.getRowValue(rowIdx);
                    if(data["UPYN"] != ""){
                        //최하위 분류만 선택가능
                        return EVF.alert("${CITR0043_001 }");
                    }


                    data.rowIdx = "${param.rowIdx}";
                    var selectedData = JSON.stringify(data);

                    if(${param.ModalPopup == true}){
                        parent["${param.callBackFunction}"](selectedData);
                    }else{
                        opener["${param.callBackFunction}"](selectedData);
                    }
                    doClose();
                });
            }

            gridTree.setColCursor("ITEM_CLS_NM", "pointer");

            doSearch();

        }

        function doSearch() {
            var store = new EVF.Store();
            store.load(baseUrl + "citr0043_doSearch.so", function() {

                var treeData = this.getParameter("treeData");
                var jsonTree = JSON.parse(treeData);

                gridTree.getDataProvider().setRows(jsonTree, "tree", true, "", "icon");
                gridTree._gvo.orderBy(["SORT_SQ"],["ascending"]);
                treeViewObj.expandAll(); //전체펼치기
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

        function doChoose() {
            if (gridTree.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

            var selectedData = gridTree.getSelRowValue();
            if( gridTree.isEmpty( selectedData) ) { return ; }

            if(${param.ModalPopup == true}){
                parent["${param.callBackFunction}"](selectedData);
            }else{
                opener["${param.callBackFunction}"](selectedData);
            }
            gridTree.checkAll(false);
        }

        function doClose() {
            EVF.closeWindow();
        }
    </script>

    <e:window id="CITR0043" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">
        <e:searchPanel id="form" title="${form_CAPTION_N }" columnCount="1" labelWidth="${labelWidth }" useTitleBar="false" onEnter="doSearch">
            <e:row>
                <%-- 품목분류 --%>
                <e:label for="ITEM_CLS_NM" title="${form_ITEM_CLS_NM_N}" />
                <e:field>
                    <e:inputText id="ITEM_CLS_NM" name="ITEM_CLS_NM" value="${form.ITEM_CLS_NM}" width="${form_ITEM_CLS_NM_W}" maxLength="${form_ITEM_CLS_NM_M}" disabled="${form_ITEM_CLS_NM_D}" readOnly="${form_ITEM_CLS_NM_RO}" required="${form_ITEM_CLS_NM_R}" style="${imeMode}" maskType="${form_ITEM_CLS_NM_MT}"/>
                </e:field>
            </e:row>
        </e:searchPanel>

        <e:buttonBar id="buttonBar" align="right" width="100%">
            <e:button id="doSearch" name="doSearch" label="${doSearch_N}" onClick="doSearch" disabled="${doSearch_D}" visible="${doSearch_V}"/>
            <e:button id="doChoose" name="doChoose" label="${doChoose_N }" disabled="${doChoose_D }" visible="${doChoose_V}" onClick="doChoose" />
            <e:button id="doClean" name="doClean" label="${doClean_N}" onClick="doClean" disabled="${doClean_D}" visible="${doClean_V}"/>
        </e:buttonBar>

        <e:gridPanel id="gridTree" name="gridTree" height="fit" gridType="RGT" readOnly="${param.detailView}"/>

    </e:window>
</e:ui>