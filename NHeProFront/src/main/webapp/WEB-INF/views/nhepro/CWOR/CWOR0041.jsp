<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
    <script>

    var baseUrl = "/nhepro/CWOR/";
    var gridL = {};
    var currentRow;
    var relatYn = "${ses.relatYn }"

    function init() {

    	gridL = EVF.C("gridL");

		gridL.addRowEvent(function() {
			var addParam = [{}];
			gridL.addRow(addParam);
			recountSignSequence();
		});

		gridL.delRowEvent(function() {
			if(gridL.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
			gridL.delRow();
			recountSignSequence();
		});

		gridL.cellClickEvent(function(rowIdx, colIdx, value) {

			currentRow = rowIdx;

			if (colIdx == 'SIGN_USER_ID') {
                var param = {
                    callBackFunction: "setUserMulti",
                    'READONLY': 'N',         //팝업 조회조건 변경불가
                    'multiYN' : 'Y',         //멀티팝업여부
    				'detailView': false,
                };
                
                everPopup.openPopupByScreenId("CCDU0020", 1100, 700, param);
	        }
		});

		gridL.excelExportEvent({
        	allItems : "${excelExport.allCol}",
			fileName : "${screenName }"
		});

        gridL.setProperty('shrinkToFit', true);                 // 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
        gridL.setProperty('rowNumbers', ${rowNumbers});		    // 로우의 번호 표시 여부를 지정한다. [true/false]
        gridL.setProperty('sortable', false);			        // 컬럼 정렬기능 사용여부를 지정한다. [true/false]
        gridL.setProperty('panelVisible', ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
        gridL.setProperty('enterToNextRow', ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
        gridL.setProperty('acceptZero', ${acceptZero});		    // 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
        gridL.setProperty('singleSelect', ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]
        gridL.setProperty('multiSelect', ${param.detailView == true ? false : multiSelect}); // [선택] 컬럼의 사용여부를 지정한다. [true/false]

        if(relatYn == "1") {
            gridL.hideCol("BUYER_CD", true);
            gridL.hideCol("BUYER_NM", true);
        }

        if ("${param.VALUE}" == "C") {
            doSearch();
        }
    }

    function doSearch() {

        var store = new EVF.Store();
        store.setGrid([gridL]);
        store.load(baseUrl + 'cwor0041_doSearchDT.so', function() {
        	if(gridL.getRowCount() == 0){
            	EVF.alert("${msg.M0002 }");
            } else {
            	EVF.C("MAIN_PATH_FLAG").setChecked(("${param.MAINPATHFLAG}" == "1" ? true : false));
            	gridL.checkAll(true);
            }
        });
    }

    function doSave() {

		var store = new EVF.Store();
		if(!store.validate()) { return; }

        gridL.checkAll(true);
		if (gridL.getSelRowCount() == 0) { return EVF.alert("${CWOR0041_001}"); }

        if (!gridL.validate().flag) { return EVF.alert(gridL.validate().msg); }

        EVF.confirm("${msg.M0021 }", function () {

            var rowIds = gridL.getAllRowId();
            for (var i in rowIds) {
                gridL.setCellValue(i, "PATH_NUM", EVF.V("PATH_NUM"));
            }
            EVF.V("GATE_CD", "${ses.gateCd}");

            store.setGrid([gridL]);
            store.getGridData(gridL, 'sel');
            store.setParameter("saveType", "${param.VALUE }");
            store.load(baseUrl + 'cwor0041_doSave.so', function(){
                EVF.alert(this.getResponseMessage(), function() {
                    opener.window["${param.onClose}"]();
                    doClose();
                });
            });
        });
    }

    function doDelLine() {

    	if(gridL.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

		gridL.delRow();

		var pathSeq = 1;
		var rowIds  = gridL.getAllRowId();
    	for (var i in rowIds) {
        	gridL.setCellValue(i, "PATH_SQ", pathSeq++);
    	}
    	gridL.checkAll(false);
    }

    function doMoveUp() {

    	if(gridL.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

    	if(gridL.getSelRowCount() > 1) { return EVF.alert("${msg.M0006}"); }

        var selectedRowId = gridL.getSelRowId()[0]
           ,selectedRowData = gridL.getRowValue(selectedRowId);

        var allRowIds = gridL.getAllRowId();
        gridL.setCellValue(selectedRowId, 'CHECK_FLAG', '1');

        var store = new EVF.Store();
        store.setGrid([gridL]);
        store.setParameter('sortType', 'up');
        store.getGridData(gridL, 'all');
        store.load(baseUrl+'/getRealignmentApprovalList.so', function() {
            gridL.checkAll(false);
            recountSignSequence();
        }, false);
    }

    function doMoveDown() {

        if(gridL.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

        if(gridL.getSelRowCount() > 1) { return EVF.alert("${msg.M0006}"); }

        var selectedRowId = gridL.getSelRowId()[0]
                ,selectedRowData = gridL.getRowValue(selectedRowId);

        <%--
        var signReqType = selectedRowData['SIGN_REQ_TYPE'];
        if(signReqType === '4' || signReqType === '7') {
            return EVF.alert('병렬의 건은 이동시키실 수 없습니다.');
        }
        --%>

        var allRowIds = gridL.getAllRowId();
        gridL.setCellValue(selectedRowId, 'CHECK_FLAG', '1');

        var store = new EVF.Store();
        store.setGrid([gridL]);
        store.setParameter('sortType', 'down');
        store.getGridData(gridL, 'all');
        store.load(baseUrl+'/getRealignmentApprovalList.so', function() {
            gridL.checkAll(false);
            recountSignSequence();
        }, false);
    }

    <%-- 결재 순번 계산 --%>
    function recountSignSequence() {

        var rowIds = gridL.getAllRowId();
        var selectedRowIdx = [];
        for(var i = 0; i < rowIds.length; i++) {

            var rowData = gridL.getRowValue(rowIds[i]);
            var checkFlag = rowData['CHECK_FLAG'];
            if(checkFlag == '1') {
                selectedRowIdx.push(rowIds[i]);
            }
            gridL.setCellValue(rowIds[i], "CHECK_FLAG", "");
            gridL.setCellValue(rowIds[i], 'PATH_SQ', i+1);
        }

        var allRowIds = gridL.getAllRowId();
        for(var i = 0; i < allRowIds.length; i++) {
            gridL.setCellValue(allRowIds[i], 'CHECK_FLAG', '');
        }
        gridL.checkAll(false);
        for(var i = 0; i < selectedRowIdx.length; i++) {
            gridL.checkRow(selectedRowIdx[i], true);
        }
    }

    function setUserMulti(data) {
        if (data.length != undefined) {
            var dataArr = [];
            for (var idx in data) {
                if(idx == 0) {
                    var tmpArr = [{
                        'SIGN_USER_ID': data[idx].USER_ID,
                        'USER_NM': data[idx].USER_NM,
                        'DEPT_NM': data[idx].DEPT_NM,
                        'POSITION_NM': data[idx].POSITION_NM,
                        'DUTY_NM': data[idx].DUTY_NM,
                        'BUYER_CD': data[idx].CUST_CD,
                        'BUYER_NM': data[idx].CUST_NM
                    }];
                    var setData = valid.equalPopupValid(JSON.stringify(tmpArr), gridL, "SIGN_USER_ID");
                    if(setData) {
                        gridL.setCellValue(currentRow, 'SIGN_USER_ID', data[idx].USER_ID);
                        gridL.setCellValue(currentRow, 'USER_NM', data[idx].USER_NM);
                        gridL.setCellValue(currentRow, 'DEPT_NM', data[idx].DEPT_NM);
                        gridL.setCellValue(currentRow, 'POSITION_NM', data[idx].POSITION_NM);
                        gridL.setCellValue(currentRow, 'DUTY_NM', data[idx].DUTY_NM);
                        gridL.setCellValue(currentRow, 'BUYER_CD', data[idx].CUST_CD);
                        gridL.setCellValue(currentRow, 'BUYER_NM', data[idx].CUST_NM);
                    }
                }
                else {
                    var arr = {
                        'SIGN_USER_ID': data[idx].USER_ID,
                        'USER_NM': data[idx].USER_NM,
                        'DEPT_NM': data[idx].DEPT_NM,
                        'POSITION_NM': data[idx].POSITION_NM,
                        'DUTY_NM': data[idx].DUTY_NM,
                        'BUYER_CD': data[idx].CUST_CD,
                        'BUYER_NM': data[idx].CUST_NM
                    };
                    dataArr.push(arr);
                }
            }
            var validData = valid.equalPopupValid(JSON.stringify(dataArr), gridL, "SIGN_USER_ID");
            if(validData) {
                gridL.addRow(validData);
                recountSignSequence();
            }
        }
    }

    function doClose() {
        EVF.closeWindow();
    }

    </script>

    <e:window id="CWOR0041" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }" margin="0 5px 0 5px">

		<e:inputHidden id="GATE_CD" name="GATE_CD" value="${param.VALUE == 'C' ? param.GATECD : '' }"/>

		<e:searchPanel id="form" title="${form_caption_form_N}" useTitleBar="false" labelWidth="${labelWidth}" width="100%" columnCount="2">
            <e:row>
                <e:label for="PATH_NUM" title="${form_PATH_NUM_N}"></e:label>
                <e:field>
					<e:inputText id="PATH_NUM" name="PATH_NUM" width="${form_PATH_NUM_W }" maxLength="${form_PATH_NUM_M }" value="${param.VALUE == 'C' ? param.PATHNUM : '' }" required="${form_PATH_NUM_R }" readOnly="${form_PATH_NUM_RO }" disabled="${form_PATH_NUM_D}" visible="${form_PATH_NUM_V}"  maskType="${form_PATH_NUM_MT}" />
               </e:field>
                <e:label for="MAIN_PATH_FLAG" title="${form_MAIN_PATH_FLAG_N}"></e:label>
                <e:field>
					<e:check id="MAIN_PATH_FLAG" name="MAIN_PATH_FLAG" label="${form_MAIN_PATH_FLAG_N }" readOnly="${form_MAIN_PATH_FLAG_RO }" disabled="${form_MAIN_PATH_FLAG_D }" />
                </e:field>
            </e:row>
            <e:row>
                <e:label for="SIGN_PATH_NM" title="${form_SIGN_PATH_NM_N}"></e:label>
                <e:field colSpan="3">
					<e:inputText id="SIGN_PATH_NM" name="SIGN_PATH_NM" width="${form_SIGN_PATH_NM_W }" maxLength="${form_SIGN_PATH_NM_M }" value="${param.VALUE == 'C' ? param.SIGNPATHNM : '' }" required="${form_SIGN_PATH_NM_R }" readOnly="${form_SIGN_PATH_NM_RO }" disabled="${form_SIGN_PATH_NM_D}" visible="${form_SIGN_PATH_NM_V}"  maskType="${form_SIGN_PATH_NM_MT}" />
                </e:field>
            </e:row>
            <e:row>
                <e:label for="SIGN_RMK" title="${form_SIGN_RMK_N}"></e:label>
                <e:field colSpan="3">
					<e:textArea id="SIGN_RMK" name="SIGN_RMK" width="${form_SIGN_RMK_W}" height="100" disabled="${form_SIGN_RMK_D}" maxLength="${form_SIGN_RMK_M }" required="${form_SIGN_RMK_R }" value="${param.VALUE == 'C' ? param.SIGNRMK : '' }" readOnly="${form_SIGN_RMK_R }" />
                </e:field>
            </e:row>
        </e:searchPanel>

    	<e:buttonBar id="buttonBarS" align="right" width="100%">
            <%-- e:button id="Search" name="Search" label="${Search_N }" disabled="${Search_D }" onClick="doSearch" / --%>
            <e:button id="MoveUp" name="MoveUp" label="${MoveUp_N }" disabled="${MoveUp_D }" onClick="doMoveUp" />
            <e:button id="MoveDown" name="MoveDown" label="${MoveDown_N }" disabled="${MoveDown_D }" onClick="doMoveDown" />
        </e:buttonBar>

        <e:gridPanel id="gridL" name="gridL" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}"/>

        <e:buttonBar id="buttonBarM" align="right" width="100%">
            <e:button id="Save" name="Save" label="${Save_N }" disabled="${Save_D }" onClick="doSave" />
            <e:button id="Close" name="Close" label="${Close_N }" disabled="${Close_D }" onClick="doClose" />
        </e:buttonBar>

    </e:window>
</e:ui>

