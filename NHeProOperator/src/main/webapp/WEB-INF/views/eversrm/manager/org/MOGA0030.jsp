<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">

    <script type="text/javascript">

        var gridT; var gridM; var gridB; var gridDP;
        var addParam = [];
        var baseUrl = "/eversrm/manager/org/";

        function init() {

            gridT = EVF.C("gridT");
            gridM = EVF.C("gridM");
            gridB = EVF.C("gridB");
            gridDP = EVF.C("gridDP");

            gridT.setProperty('shrinkToFit', true);                 // 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
            gridT.setProperty('rowNumbers', ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
            gridT.setProperty('sortable', ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
            gridT.setProperty('panelVisible', ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            gridT.setProperty('enterToNextRow', ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            gridT.setProperty('acceptZero', ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            gridT.setProperty('singleSelect', ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]
            gridT.setProperty('multiSelect', ${param.detailView == true ? false : multiSelect}); //[선택] 컬럼의 사용여부를 지정한다. [true/false]

            gridM.setProperty('shrinkToFit', true);                 // 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
            gridM.setProperty('rowNumbers', ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
            gridM.setProperty('sortable', ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
            gridM.setProperty('panelVisible', ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            gridM.setProperty('enterToNextRow', ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            gridM.setProperty('acceptZero', ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            gridM.setProperty('singleSelect', ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]
            gridM.setProperty('multiSelect', ${param.detailView == true ? false : multiSelect}); //[선택] 컬럼의 사용여부를 지정한다. [true/false]

            gridB.setProperty('shrinkToFit', true);                 // 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
            gridB.setProperty('rowNumbers', ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
            gridB.setProperty('sortable', ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
            gridB.setProperty('panelVisible', ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            gridB.setProperty('enterToNextRow', ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            gridB.setProperty('acceptZero', ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            gridB.setProperty('singleSelect', ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]
            gridB.setProperty('multiSelect', ${param.detailView == true ? false : multiSelect}); //[선택] 컬럼의 사용여부를 지정한다. [true/false]

            gridDP.setProperty('shrinkToFit', true);                    // 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
            gridDP.setProperty('rowNumbers', ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
            gridDP.setProperty('sortable', ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
            gridDP.setProperty('panelVisible', ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            gridDP.setProperty('enterToNextRow', ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            gridDP.setProperty('acceptZero', ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            gridDP.setProperty('singleSelect', ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]
            gridDP.setProperty('multiSelect', ${param.detailView == true ? false : multiSelect}); //[선택] 컬럼의 사용여부를 지정한다. [true/false]


            gridT.cellClickEvent(function(rowIdx, colIdx, value) {

                if(colIdx == "DEPT_CD") {

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
                        store.load(baseUrl + 'MOGA0030_doSearchM.so', function() {
                            if(gridM.getRowCount() == 0){
                                EVF.alert("${msg.M0002 }");
                            }
                        });
                        EVF.C("R1").setChecked(false);
                        EVF.C("R2").setChecked(true);
                        EVF.C("R3").setChecked(false);
                        EVF.C("R4").setChecked(false);
                    }

                }
                if(colIdx == "TEAM_LEADER_USER_NM") {
                    var	param =	{
                    	rowIdx : rowIdx,
                        custCd: EVF.V("CUST_CD"),
                        callBackFunction: "lv1_callBackCTRL_USER_ID"
                    };
                    everPopup.openCommonPopup(param, 'SP0086');
                }
            });

            gridT.cellChangeEvent(function(rowIdx, colIdx, iRow, iCol, value, oldValue) {
                if (colIdx == "PARENT_DEPT_NM") {
                    gridT.setCellValue(rowIdx, 'PARENT_DEPT_CD', gridT.getCellValue(rowIdx, 'PARENT_DEPT_NM'));
                }
            });

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
                        store.load(baseUrl + 'MOGA0030_doSearchB.so', function() {

                        });
                        EVF.C("R1").setChecked(false);
                        EVF.C("R2").setChecked(false);
                        EVF.C("R3").setChecked(true);
                        EVF.C("R4").setChecked(false);
                        EVF.V("DEPT_CD",gridM.getCellValue(rowIdx, 'DEPT_CD'));
                    }
                }
                if(colIdx == "TEAM_LEADER_USER_NM") {
                    var	param =	{
                    		rowIdx : rowIdx,
                        custCd: EVF.V("CUST_CD"),
                        callBackFunction: "lv2_callBackCTRL_USER_ID"
                    };
                    everPopup.openCommonPopup(param, 'SP0086');
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
                        store.load(baseUrl + 'MOGA0030_doSearchDP.so', function() {

                        });
                        EVF.C("R1").setChecked(false);
                        EVF.C("R2").setChecked(false);
                        EVF.C("R3").setChecked(false);
                        EVF.C("R4").setChecked(true);
                        EVF.V("DEPT_CD",gridB.getCellValue(rowIdx, 'DEPT_CD'));
                    }
                }
                if(colIdx == "TEAM_LEADER_USER_NM") {
                    var	param =	{
                    		rowIdx : rowIdx,
                        custCd: EVF.V("CUST_CD"),
                        callBackFunction: "lv3_callBackCTRL_USER_ID"
                    };
                    everPopup.openCommonPopup(param, 'SP0086');
                }
            });

            gridB.cellChangeEvent(function(rowIdx, colIdx, iRow, iCol, value, oldValue) {
                if (colIdx == "PARENT_DEPT_NM") {
                    gridB.setCellValue(rowIdx, 'PARENT_DEPT_CD', gridB.getCellValue(rowIdx, 'PARENT_DEPT_NM'));
                }
            });

            gridDP.cellClickEvent(function(rowIdx, colIdx, value) {
                if(colIdx == "TEAM_LEADER_USER_NM") {
                    var	param =	{
                    		rowIdx : rowIdx,
                        custCd: EVF.V("CUST_CD"),
                        callBackFunction: "lv4_callBackCTRL_USER_ID"
                    };
                    everPopup.openCommonPopup(param, 'SP0086');
                }
            });

            gridT.addRowEvent(function() {
                addParam = [{'PARENT_DEPT_CD': EVF.V("CUST_CD"), 'PARENT_DEPT_NM': EVF.V("CUST_NM"), 'DEL_FLAG': '1'}];
                gridT.addRow(addParam);
                EVF.C("R1").setChecked(true);
                EVF.C("R2").setChecked(false);
                EVF.C("R3").setChecked(false);
                EVF.C("R4").setChecked(false);
            });

            gridT.delRowEvent(function() {
                if(!gridT.getSelRowCount()) { return EVF.alert("${msg.M0004}"); }
                gridT.delRow();
            });

            gridM.addRowEvent(function() {
                if(EVF.V("M_PARENT_DEPT_CD")==""){
                    return EVF.alert("${MOGA0030_003}");
                }
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
                if(EVF.V("B_PARENT_DEPT_CD")==""){
                    return EVF.alert("${MOGA0030_003}");
                }
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
                if(EVF.V("DP_PARENT_DEPT_CD")==""){
                    return EVF.alert("${MOGA0030_003}");
                }
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

            gridT.excelExportEvent({
                allItems : "${excelExport.allCol}",
                fileName : "${screenName }"
            });

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

            doSearch();
        }

        function doSearch() {

            EVF.V("M_PARENT_DEPT_CD", "");
            EVF.V("B_PARENT_DEPT_CD", "");
            EVF.V("DP_PARENT_DEPT_CD", "");

            var store = new EVF.Store();
            if(!store.validate()) { return; }
            store.setGrid([gridT, gridM, gridB,gridDP]);
            store.load(baseUrl + 'MOGA0030_doSearch.so', function() {
                if(gridT.getRowCount() == 0 && gridM.getRowCount() == 0 && gridB.getRowCount() == 0 && gridDP.getRowCount() == 0 ){
                    EVF.alert("${msg.M0002 }");
                }
            });
        }

        function doSave() {

            if(EVF.V("CUST_CD") == ""){
                EVF.C('CUST_NM').setFocus();
                return EVF.alert("${MOGA0030_001}");
            }

            var radioVal = (EVF.C("R1").isChecked() == true ? "R1" :(EVF.C("R2").isChecked() == true ? "R2" : (EVF.C("R3").isChecked() == true ? "R3" : (EVF.C("R4").isChecked() == true ? "R4" : ""))));

            if(radioVal == "R1") {
                if(gridT.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
                if (!gridT.validate().flag) { return EVF.alert(gridT.validate().msg); }
                EVF.V("DEPT_TYPE_RADIO", "100");
                EVF.V("DIVISION_YN", "1");
                EVF.V("LVL","1");
            }
            else if(radioVal == "R2") {
                if(gridM.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
                if (!gridM.validate().flag) { return EVF.alert(gridM.validate().msg); }
                EVF.V("DEPT_TYPE_RADIO", "200");
                EVF.V("DIVISION_YN", "0");
                EVF.V("LVL","2");
            }
            else if(radioVal == "R3") {
                if(gridB.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
                if (!gridB.validate().flag) { return EVF.alert(gridB.validate().msg); }
                EVF.V("DEPT_TYPE_RADIO", "300");
                EVF.V("DIVISION_YN", "0");
                EVF.V("LVL","3");
            }
            else if(radioVal == "R4") {
                if(gridDP.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
                if (!gridDP.validate().flag) { return EVF.alert(gridDP.validate().msg); }
                EVF.V("DEPT_TYPE_RADIO", "400");
                EVF.V("DIVISION_YN", "0");
                EVF.V("LVL","4");
            }

            EVF.confirm("${msg.M0021 }", function () {
                var store = new EVF.Store();
                store.setParameter("radioVal", radioVal);
                store.setGrid([gridT, gridM, gridB, gridDP]);
                store.getGridData(gridT, 'sel');
                store.getGridData(gridM, 'sel');
                store.getGridData(gridB, 'sel');
                store.getGridData(gridDP, 'sel');
                store.load(baseUrl + 'MOGA0030_doSave.so', function() {
                    EVF.alert(this.getResponseMessage());
                    doSearch();
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

        function lv1_callBackCTRL_USER_ID(jsonData)	{
            gridT.setCellValue(jsonData.rowIdx, 'TEAM_LEADER_USER_NM', jsonData.USER_NM);
            gridT.setCellValue(jsonData.rowIdx, 'TEAM_LEADER_USER_ID', jsonData.USER_ID);

        }

        function lv2_callBackCTRL_USER_ID(jsonData)	{
            gridM.setCellValue(jsonData.rowIdx, 'TEAM_LEADER_USER_NM', jsonData.USER_NM);
            gridM.setCellValue(jsonData.rowIdx, 'TEAM_LEADER_USER_ID', jsonData.USER_ID);
        }

        function lv3_callBackCTRL_USER_ID(jsonData)	{
            gridB.setCellValue(jsonData.rowIdx, 'TEAM_LEADER_USER_NM', jsonData.USER_NM);
            gridB.setCellValue(jsonData.rowIdx, 'TEAM_LEADER_USER_ID', jsonData.USER_ID);
        }

        function lv4_callBackCTRL_USER_ID(jsonData)	{
            gridDP.setCellValue(jsonData.rowIdx, 'TEAM_LEADER_USER_NM', jsonData.USER_NM);
            gridDP.setCellValue(jsonData.rowIdx, 'TEAM_LEADER_USER_ID', jsonData.USER_ID);
        }

        function setBuyer(data) {
            EVF.V('CUST_CD', data.CUST_CD);
            EVF.V('CUST_NM', data.CUST_NM);
        }

    </script>
    <e:window id="MOGA0030" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">
        <e:searchPanel id="form" title="${msg.M9999 }" columnCount="2" labelWidth="${labelWidth }" useTitleBar="false" onEnter="doSearch">
            <e:row>
                <e:label for="CUST_CD" title="${form_CUST_CD_N}"/>
                <e:field>
                    <e:inputText id="CUST_CD" name="CUST_CD" value="${ses.companyCd}" width="0" maxLength="${form_CUST_CD_M}" disabled="${form_CUST_CD_D}" readOnly="${form_CUST_CD_RO}" required="${form_CUST_CD_R}" />
                    <e:search id="CUST_NM" name="CUST_NM" value="${ses.companyNm}" width="100%" maxLength="${form_CUST_NM_M}" onIconClick="${form_CUST_NM_RO ? 'everCommon.blank' : 'getBuyer'}" popupCode="SP0066.setBuyer" disabled="${form_CUST_NM_D}" readOnly="${form_CUST_NM_RO}" required="${form_CUST_NM_R}" />
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

        <e:panel id="leftPanel" height="385px" width="50%">
            <e:radio id="R1" name="R1" label="" value="1" checked="true" readOnly="false" disabled="false" onClick="checkRadio" data="R1" />
            <e:text style="float: left; line-height: 27px; font-size: 14px; font-weight: bold;">${MOGA0030_LV1}</e:text>
            <e:gridPanel id="gridT" name="gridT" gridType="${_gridType}" width="100%" height="330px" readOnly="${param.detailView}"/>
        </e:panel>
        <e:panel id="nullPanel" height="385" width="1%">&nbsp;</e:panel>
        <e:panel id="rightPanel" height="385" width="49%">
            <e:radio id="R2" name="R2" label="" value="2" checked="false" readOnly="false" disabled="false" onClick="checkRadio" data="R2" />
            <e:text style="float: left; line-height: 27px; font-size: 14px; font-weight: bold;">${MOGA0030_LV2}</e:text>
            <e:gridPanel id="gridM" name="gridM" gridType="${_gridType}" width="100%" height="330px" readOnly="${param.detailView}"/>
        </e:panel>

        <e:panel id="leftPanelB" height="fit" width="50%">
            <e:radio id="R3" name="R3" label="" value="3" checked="false" readOnly="false" disabled="false" onClick="checkRadio" data="R3" />
            <e:text style="float: left; line-height: 27px; font-size: 14px; font-weight: bold;">${MOGA0030_LV3}</e:text>
            <e:gridPanel id="gridB" name="gridB" gridType="${_gridType}" width="100%" height="fit" readOnly="${param.detailView}"/>
        </e:panel>
        <e:panel id="nullPanel2" height="fit" width="1%">&nbsp;</e:panel>
        <e:panel id="rightPanelB" height="fit" width="49%">
            <e:radio id="R4" name="R4" label="" value="4" checked="false" readOnly="false" disabled="false" onClick="checkRadio" data="R4" />
            <e:text style="float: left; line-height: 27px; font-size: 14px; font-weight: bold;">${MOGA0030_LV4}</e:text>
            <e:gridPanel id="gridDP" name="gridDP" gridType="${_gridType}" width="100%" height="fit" readOnly="${param.detailView}"/>
        </e:panel>

    </e:window>
</e:ui>