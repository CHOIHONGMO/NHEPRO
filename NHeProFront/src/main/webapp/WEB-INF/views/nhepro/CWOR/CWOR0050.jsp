<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
    <script type="text/javascript">

        var gridL = {};
        var gridR = {};
        var addParam = [];
        var baseUrl = "/nhepro/CWOR/";
        var checkRow = -1;
        var isDevelopmentMode = ${isDevelopmentMode};
        var corpType = "${ses.corpType}";
        var custCd   = "${param.CUST_CD}";

        function init() {

            gridL = EVF.C('gridL');
            gridR = EVF.C('gridR');

            gridL.cellChangeEvent(function (rowIdx, colIdx, iRow, iCol, value, oldValue) {
                if (colIdx == 'SIGN_REQ_TYPE') {
                    recountSignSequence();
                }
            });

            gridR.cellClickEvent(function (rowIdx, colIdx, value, iRow, iCol) {

                if (colIdx == 'SIGN_USER_NM') {

                    var selectedData = gridR.getRowValue(rowIdx);
                    gridR.checkRow(rowIdx, true);

                    var abc = selectedData.SIGN_USER_ID;
                    var rowIds = gridL.getAllRowId();
                    for(var i in rowIds) {
                        if (gridL.getCellValue(rowIds[i], 'SIGN_USER_ID') == abc) {
                            gridR.checkRow(rowIdx, false);
                            return EVF.alert("${CWOR0050_M009}" ); // 동일한 사용자가 이미 결재 경로에 존재합니다.
                        }
                    }

                    var userId = '${ses.userId}';
                    <%-- 본인에게 상신할 수 있도록 수정. 2020-08-07
                    if (!isDevelopmentMode && (userId == selectedData.SIGN_USER_ID))  {
                        return EVF.alert("${CWOR0050_M010}"); // 기안자 본인을 결재경로에 추가할 수 없습니다.
                    }
                    --%>

                    var addParam = [{
                        "SIGN_USER_ID": selectedData.SIGN_USER_ID,
                        "SIGN_USER_NM": selectedData.SIGN_USER_NM,
                        "DEPT_CD": selectedData.DEPT_CD,
                        "DEPT_NM": selectedData.DEPT_NM,
                        "POSITION_NM": selectedData.POSITION_NM,
                        "SIGN_REQ_TYPE": (EVF.C('SIGN_REQ_TYPE').getCheckedValue() == null || EVF.C('SIGN_REQ_TYPE').getCheckedValue() == "") ? "E" : EVF.C('SIGN_REQ_TYPE').getCheckedValue()
                    }];

                    gridR.checkRow(rowIdx, false);
                    gridL.addRow(addParam);
                    recountSignSequence();
                }
            });

            gridL.setProperty('shrinkToFit', true);		            // 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
            gridL.setProperty('rowNumbers', ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
            gridL.setProperty('sortable', ${sortable});			    // 컬럼 정렬기능 사용여부를 지정한다. [true/false]
            gridL.setProperty('panelVisible', ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            gridL.setProperty('enterToNextRow', ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            gridL.setProperty('acceptZero', ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            gridL.setProperty('singleSelect', ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]
            gridL.setProperty('multiSelect', ${param.detailView == true ? false : multiSelect}); // [선택] 컬럼의 사용여부를 지정한다. [true/false]

            gridR.setProperty('shrinkToFit', true);		            // 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
            gridR.setProperty('rowNumbers', ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
            gridR.setProperty('sortable', ${sortable});			    // 컬럼 정렬기능 사용여부를 지정한다. [true/false]
            gridR.setProperty('panelVisible', ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            gridR.setProperty('enterToNextRow', ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            gridR.setProperty('acceptZero', ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            gridR.setProperty('multiSelect', ${multiSelect});       // [선택] 컬럼의 사용여부를 지정한다. [true/false]
            gridR.setProperty('singleSelect', ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]

            <%-- 전결 미사용
            doSearchDecideArbitrarily();
            --%>
            
            if(corpType != '2'){
            	getCust();
            	EVF.C("CUST_CD").setReadOnly(false);
			}else{
				getCustCd();
				EVF.C("CUST_CD").setReadOnly(true);
			}
        }


        function doChoose() {

            if (gridR.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

            var selectedIds = gridR.getSelRowId();
            for(var j in selectedIds) {

                var rowIds = gridL.getAllRowId();
                for(var i in rowIds) {
                    if (gridL.getCellValue(rowIds[i], 'SIGN_USER_ID') == gridR.getCellValue(selectedIds[j], 'SIGN_USER_ID')) {
                        return EVF.alert("${CWOR0050_M009}" ); // 동일한 사용자가 이미 결재 경로에 존재합니다.
                    }
                }

                var addParam = [{
                    "SIGN_USER_ID": gridR.getCellValue(selectedIds[j], 'SIGN_USER_ID'),
                    "SIGN_USER_NM": gridR.getCellValue(selectedIds[j], 'SIGN_USER_NM'),
                    "DEPT_CD": gridR.getCellValue(selectedIds[j], 'DEPT_CD'),
                    "DEPT_NM": gridR.getCellValue(selectedIds[j], 'DEPT_NM'),
                    "POSITION_NM": gridR.getCellValue(selectedIds[j], 'POSITION_NM'),
                    "SIGN_REQ_TYPE": (EVF.C('SIGN_REQ_TYPE').getCheckedValue() == null || EVF.C('SIGN_REQ_TYPE').getCheckedValue() == "") ? "E" : EVF.C('SIGN_REQ_TYPE').getCheckedValue()
                }];
                gridR.checkRow(selectedIds[j], false);
                gridL.addRow(addParam);
                recountSignSequence();
            }
        }

        function doSearch() {

            var store = new EVF.Store();
            store.setGrid([gridR]);
            store.load(baseUrl + 'cwor0050_userSearch.so', function () {

                if (gridR.getRowCount() == 0) {
                    EVF.alert("${msg.M0002 }");
                }
                if (gridR.getRowCount() == 1) {

                    EVF.V("SIGN_USER_NM", "");

                    var selectedData = gridR.getRowValue(0);
                    gridR.checkRow(0, true);

                    var rowIds = gridL.getAllRowId();
                    for(var i in rowIds) {
                        if (gridL.getCellValue(rowIds[i], 'SIGN_USER_ID') == selectedData.SIGN_USER_ID) {
                            return EVF.alert("${CWOR0050_M009}"); // 동일한 사용자가 이미 결재 경로에 존재합니다.
                        }
                    }
                    var userId = '${ses.userId}';
                    <%-- 본인에게 상신할 수 있도록 수정. 2020-08-07
                    if (!isDevelopmentMode && (userId == selectedData.SIGN_USER_ID)) {
                        return EVF.alert("${CWOR0050_M010}"); // 기안자 본인을 결재경로에 추가할 수 없습니다.
                    }
                    --%>

                    var addParam = [{
                        "SIGN_USER_ID": selectedData.SIGN_USER_ID,
                        "SIGN_USER_NM": selectedData.SIGN_USER_NM,
                        "SIGN_USER_NM_$TP": selectedData.SIGN_USER_NM,
                        "DEPT_CD": selectedData.DEPT_CD,
                        "DEPT_NM": selectedData.DEPT_NM,
                        "POSITION_NM": selectedData.POSITION_NM,
                        "SIGN_REQ_TYPE": (EVF.C('SIGN_REQ_TYPE').getCheckedValue() == null || EVF.C('SIGN_REQ_TYPE').getCheckedValue() == "") ? "E" : EVF.C('SIGN_REQ_TYPE').getCheckedValue()
                    }];

                    gridL.addRow(addParam);
                    recountSignSequence();
                }
            });
        }

        function doSearchDecideArbitrarily() {

            var confirmMsg = "${CWOR0050_M007}";

            if (EVF.isEmpty("${param.bizCls1}") || EVF.isEmpty("${param.bizCls2}") || EVF.isEmpty("${param.bizCls3}") || EVF.isEmpty("${param.bizAmt}")) return;

            var store = new EVF.Store();
            <%--
            store.setParameter('bizCls1', '${param.bizCls1}');
            store.setParameter('bizCls2', '${param.bizCls2}');
            store.setParameter('bizCls3', '${param.bizCls3}');
            store.setParameter('bizRate', '${param.bizRate}');
            store.setParameter('reqUserId', '${param.reqUserId}');
            --%>
            store.setParameter('bizAmt', '${param.bizAmt}');
            store.setGrid([gridL]);
            store.load(baseUrl + 'cwor0050_doSearchDecideArbitrarily.so', function () {

                if(this.getParameter("appFlag") == "N"){

                    EVF.confirm(confirmMsg, function () {

                        var gridData = gridL.getSelRowValue();
                        var formData = {
                            DOC_TYPE: (EVF.isEmpty(EVF.V("DOC_TYPE")) ? "" : EVF.V("DOC_TYPE")),
                            SIGN_STATUS: "E"
                        };
                        var attachData = [{"UUID": ""}];
                        opener.window.focus();
                        opener.window['${param.callBackFunction}'](JSON.stringify(formData), JSON.stringify(gridData), JSON.stringify(attachData));
                        EVF.closeWindow();
                    });
                }
                else {
                    recountSignSequence();
                    gridR.showCheckBar(false);
                }
            }, false);
        }

        function doSearchSync() {

            if ('${param.USER_IDS}' == '') return;

            var store = new EVF.Store();
            store.setParameter('USER_IDS', '${param.USER_IDS}');
            store.setGrid([gridL]);
            store.load(baseUrl + 'cwor0050_doSearchSync.so', function () {
                recountSignSequence();
                gridR.showCheckBar(false);
            }, true);
        }

        function doApprovalRequest() {
            gridL.checkAll(true);
			
            if (gridL.getSelRowCount() == 0) { return EVF.alert("${CWOR0050_M006}"); }

            if (!gridL.validate().flag) { return EVF.alert(gridL.validate().msg); }

            <%-- 본인에게 상신할 수 있도록 수정. 2020-08-07
            if (!isDevelopmentMode ) {
                var kkk = gridL.getSelRowValue();
                for (k = 0; k < kkk.length; k++) {
                    if (kkk[k].SIGN_REQ_TYPE == 'E' || kkk[k].SIGN_REQ_TYPE == 'A') {
                        if (kkk[k].SIGN_USER_ID == '${ses.userId}') {
                            return EVF.alert("${CWOR0050_M005}");
                        }
                    }
                }
            }
            --%>
            var contType = EVF.V("CONT_TYPE");
            if("${ses.companyCd}" == "C00009" || "${ses.companyCd}" == "C00013"){
	            if(contType == "LP" || contType == "TS" || contType == "TD") {
	            	EVF.confirm("결재라인에 감사팀 사용자를 추가하셨습니까?", function () {
			            EVF.confirm(("${param.approvalType }" == "NOTICE" ? "${msg.M0099 }" : "${msg.M0100 }"), function () {
			
			                var gridData = gridL.getSelRowValue();
			
			                var store = new EVF.Store();
			                if (!store.validate()) return;
			
			                store.doFileUpload(function() {
			                    var formData = {
			                        SUBJECT: (EVF.isEmpty(EVF.V("SUBJECT")) ? "" : EVF.V("SUBJECT")),
			                        DOC_CONTENTS: (EVF.isEmpty(EVF.V("DOC_CONTENTS")) ? "" : EVF.V("DOC_CONTENTS")),
			                        CONTENTS_TEXT_NUM: (EVF.isEmpty(EVF.V("CONTENTS_TEXT_NUM")) ? "" : EVF.V("CONTENTS_TEXT_NUM")),
			                        APP_ATT_FILE_NUM: (EVF.isEmpty(EVF.V("ATT_FILE_NUM")) ? "" : EVF.V("ATT_FILE_NUM")),
			                        IMPORTANCE_STATUS: (EVF.isEmpty(EVF.V("IMPORTANCE_STATUS")) ? "" : EVF.V("IMPORTANCE_STATUS")),
			                        DOC_NUM: (EVF.isEmpty(EVF.V("DOC_NUM")) ? "" : EVF.V("DOC_NUM")),
			                        DOC_TYPE: (EVF.isEmpty(EVF.V("DOC_TYPE")) ? "" : EVF.V("DOC_TYPE")),
			                        SIGN_STATUS: (EVF.isEmpty(EVF.V("SIGN_STATUS")) ? "" : EVF.V("SIGN_STATUS")),
			                        DOC_ATT_FILE_NUM: (EVF.isEmpty(EVF.V("DOC_ATT_FILE_NUM")) ? "" : EVF.V("DOC_ATT_FILE_NUM")),
			                        SCREEN_ID: (EVF.isEmpty(EVF.V("SCREEN_ID")) ? "" : EVF.V("SCREEN_ID")),
			                        DOC_SUB_TYPE: (EVF.isEmpty(EVF.V("DOC_SUB_TYPE")) ? "" : EVF.V("DOC_SUB_TYPE")),
			                        APP_DOC_NUM: (EVF.isEmpty(EVF.V("APP_DOC_NUM")) ? "" : EVF.V("APP_DOC_NUM")),
			                        CUST_CD: (EVF.isEmpty(EVF.V("CUST_CD")) ? "" : EVF.V("CUST_CD")),
			                        APP_AMT: (EVF.isEmpty(EVF.V("APP_AMT")) ? "0" : EVF.V("APP_AMT"))
			                    };
			
			                    var attachData = [{"UUID": EVF.V("UUID")}];
			                    //opener.window.focus();
			                    //opener.window['${param.callBackFunction}'](JSON.stringify(formData), JSON.stringify(gridData), JSON.stringify(attachData));
			                    parent.${param.callBackFunction}(JSON.stringify(formData), JSON.stringify(gridData), JSON.stringify(attachData));
			                    //EVF.closeWindow();
			                    onClose();
			                });
			            });
	            	});
	            } else {
	            	EVF.confirm(("${param.approvalType }" == "NOTICE" ? "${msg.M0099 }" : "${msg.M0100 }"), function () {
	            		
		                var gridData = gridL.getSelRowValue();
		
		                var store = new EVF.Store();
		                if (!store.validate()) return;
		
		                store.doFileUpload(function() {
		                    var formData = {
		                        SUBJECT: (EVF.isEmpty(EVF.V("SUBJECT")) ? "" : EVF.V("SUBJECT")),
		                        DOC_CONTENTS: (EVF.isEmpty(EVF.V("DOC_CONTENTS")) ? "" : EVF.V("DOC_CONTENTS")),
		                        CONTENTS_TEXT_NUM: (EVF.isEmpty(EVF.V("CONTENTS_TEXT_NUM")) ? "" : EVF.V("CONTENTS_TEXT_NUM")),
		                        APP_ATT_FILE_NUM: (EVF.isEmpty(EVF.V("ATT_FILE_NUM")) ? "" : EVF.V("ATT_FILE_NUM")),
		                        IMPORTANCE_STATUS: (EVF.isEmpty(EVF.V("IMPORTANCE_STATUS")) ? "" : EVF.V("IMPORTANCE_STATUS")),
		                        DOC_NUM: (EVF.isEmpty(EVF.V("DOC_NUM")) ? "" : EVF.V("DOC_NUM")),
		                        DOC_TYPE: (EVF.isEmpty(EVF.V("DOC_TYPE")) ? "" : EVF.V("DOC_TYPE")),
		                        SIGN_STATUS: (EVF.isEmpty(EVF.V("SIGN_STATUS")) ? "" : EVF.V("SIGN_STATUS")),
		                        DOC_ATT_FILE_NUM: (EVF.isEmpty(EVF.V("DOC_ATT_FILE_NUM")) ? "" : EVF.V("DOC_ATT_FILE_NUM")),
		                        SCREEN_ID: (EVF.isEmpty(EVF.V("SCREEN_ID")) ? "" : EVF.V("SCREEN_ID")),
		                        DOC_SUB_TYPE: (EVF.isEmpty(EVF.V("DOC_SUB_TYPE")) ? "" : EVF.V("DOC_SUB_TYPE")),
		                        APP_DOC_NUM: (EVF.isEmpty(EVF.V("APP_DOC_NUM")) ? "" : EVF.V("APP_DOC_NUM")),
		                        CUST_CD: (EVF.isEmpty(EVF.V("CUST_CD")) ? "" : EVF.V("CUST_CD")),
		                        APP_AMT: (EVF.isEmpty(EVF.V("APP_AMT")) ? "0" : EVF.V("APP_AMT"))
		                    };
		
		                    var attachData = [{"UUID": EVF.V("UUID")}];
		                    //opener.window.focus();
		                    //opener.window['${param.callBackFunction}'](JSON.stringify(formData), JSON.stringify(gridData), JSON.stringify(attachData));
		                    parent.${param.callBackFunction}(JSON.stringify(formData), JSON.stringify(gridData), JSON.stringify(attachData));
		                    //EVF.closeWindow();
		                    onClose();
		                });
		            });
	            }
            } else {
            	EVF.confirm(("${param.approvalType }" == "NOTICE" ? "${msg.M0099 }" : "${msg.M0100 }"), function () {
            		
	                var gridData = gridL.getSelRowValue();
	
	                var store = new EVF.Store();
	                if (!store.validate()) return;
	
	                store.doFileUpload(function() {
	                    var formData = {
	                        SUBJECT: (EVF.isEmpty(EVF.V("SUBJECT")) ? "" : EVF.V("SUBJECT")),
	                        DOC_CONTENTS: (EVF.isEmpty(EVF.V("DOC_CONTENTS")) ? "" : EVF.V("DOC_CONTENTS")),
	                        CONTENTS_TEXT_NUM: (EVF.isEmpty(EVF.V("CONTENTS_TEXT_NUM")) ? "" : EVF.V("CONTENTS_TEXT_NUM")),
	                        APP_ATT_FILE_NUM: (EVF.isEmpty(EVF.V("ATT_FILE_NUM")) ? "" : EVF.V("ATT_FILE_NUM")),
	                        IMPORTANCE_STATUS: (EVF.isEmpty(EVF.V("IMPORTANCE_STATUS")) ? "" : EVF.V("IMPORTANCE_STATUS")),
	                        DOC_NUM: (EVF.isEmpty(EVF.V("DOC_NUM")) ? "" : EVF.V("DOC_NUM")),
	                        DOC_TYPE: (EVF.isEmpty(EVF.V("DOC_TYPE")) ? "" : EVF.V("DOC_TYPE")),
	                        SIGN_STATUS: (EVF.isEmpty(EVF.V("SIGN_STATUS")) ? "" : EVF.V("SIGN_STATUS")),
	                        DOC_ATT_FILE_NUM: (EVF.isEmpty(EVF.V("DOC_ATT_FILE_NUM")) ? "" : EVF.V("DOC_ATT_FILE_NUM")),
	                        SCREEN_ID: (EVF.isEmpty(EVF.V("SCREEN_ID")) ? "" : EVF.V("SCREEN_ID")),
	                        DOC_SUB_TYPE: (EVF.isEmpty(EVF.V("DOC_SUB_TYPE")) ? "" : EVF.V("DOC_SUB_TYPE")),
	                        APP_DOC_NUM: (EVF.isEmpty(EVF.V("APP_DOC_NUM")) ? "" : EVF.V("APP_DOC_NUM")),
	                        CUST_CD: (EVF.isEmpty(EVF.V("CUST_CD")) ? "" : EVF.V("CUST_CD")),
	                        APP_AMT: (EVF.isEmpty(EVF.V("APP_AMT")) ? "0" : EVF.V("APP_AMT"))
	                    };
	
	                    var attachData = [{"UUID": EVF.V("UUID")}];
	                    //opener.window.focus();
	                    //opener.window['${param.callBackFunction}'](JSON.stringify(formData), JSON.stringify(gridData), JSON.stringify(attachData));
	                    parent.${param.callBackFunction}(JSON.stringify(formData), JSON.stringify(gridData), JSON.stringify(attachData));
	                    //EVF.closeWindow();
	                    onClose();
	                });
	            });
            }
        }
		
        function onClose() {
        	new EVF.ModalWindow().close(null);
        }
        
        <%-- 결재 순번 계산 --%>
        function recountSignSequence() {

            <%-- 병렬타입의 행을 만났는지 여부 --%>
            var isBeforeArrangeAgree = false;
            var isBeforeArrangeApproval = false;
            var rowIds = gridL.getAllRowId();
            var selectedRowIdx = [];
            for (var i = 0, pathSq = 0; i < rowIds.length; i++) {

                var rowData = gridL.getRowValue(rowIds[i]);
                var signReqType = rowData['SIGN_REQ_TYPE'];

                <%-- 병렬결재 혹은 병렬합의면 번호를 증가시키지 않는다. --%>
                if (signReqType === 'P') {
                    if (!isBeforeArrangeAgree) {
                        pathSq++;
                        isBeforeArrangeAgree = true;
                    }
                } else {
                    pathSq++;
                    isBeforeArrangeAgree = false;
                    isBeforeArrangeApproval = false;
                }

                var checkFlag = rowData['CHECK_FLAG'];
                if (checkFlag == '1') {
                    selectedRowIdx.push(rowIds[i]);
                }
                gridL.setCellValue(rowIds[i], "CHECK_FLAG", "");
                gridL.setCellValue(rowIds[i], 'SIGN_PATH_SQ', pathSq);
            }

            var allRowIds = gridL.getAllRowId();
            for (var i = 0; i < allRowIds.length; i++) {
                gridL.setCellValue(allRowIds[i], 'CHECK_FLAG', ' ');
            }

            gridL.checkAll(false);

            for (var i = 0; i < selectedRowIdx.length; i++) {
                gridL.checkRow(selectedRowIdx[i], true);
            }
        }

        function doDelete() {
            if (gridL.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
            gridL.delRow();
            recountSignSequence();
        }

        function doUp() {

            if (gridL.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

            if (gridL.getSelRowCount() > 1) { return EVF.alert('${msg.M0006}'); }

            var selectedRowId = gridL.getSelRowId();
            var selectedRowData = gridL.getRowValue(selectedRowId[0]);

            var signReqType = selectedRowData['SIGN_REQ_TYPE'];
            if (signReqType === 'P') {
                return EVF.alert("${CWOR0050_M011}"); // 병렬의 건은 이동시키실 수 없습니다.
            }

            var decideFlag = selectedRowData['DECIDE_FLAG'];
            if (decideFlag === "Y") {
                return EVF.alert("${CWOR0050_M012}"); // 전결 결재자는 이동시키실 수 없습니다.
            }

            gridL.setCellValue(selectedRowId, 'CHECK_FLAG', '1');

            var store = new EVF.Store();
            store.setGrid([gridL]);
            store.setParameter('sortType', 'up');
            store.getGridData(gridL, 'all');
            store.load(baseUrl + 'getRealignmentApprovalList.so', function () {
                gridL.checkAll(false);
                recountSignSequence();
            }, false);
        }

        function doDown() {

            if (gridL.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

            if (gridL.getSelRowCount() > 1) { return EVF.alert('${msg.M0006}'); }

            var selectedRowId = gridL.getSelRowId();
            var selectedRowData = gridL.getRowValue(selectedRowId[0]);

            var signReqType = selectedRowData['SIGN_REQ_TYPE'];
            if (signReqType === 'P' ) {
                return EVF.alert("${CWOR0050_M011}"); // 병렬의 건은 이동시키실 수 없습니다.
            }

            var decideFlag = selectedRowData['DECIDE_FLAG'];
            if (decideFlag === "Y") {
                return EVF.alert("${CWOR0050_M012}"); // 전결 결재자는 이동시키실 수 없습니다.
            }

            gridL.setCellValue(selectedRowId, 'CHECK_FLAG', '1');

            var store = new EVF.Store();
            store.setGrid([gridL]);
            store.setParameter('sortType', 'down');
            store.getGridData(gridL, 'all');
            store.load(baseUrl + 'getRealignmentApprovalList.so', function () {
                gridL.checkAll(false);
                recountSignSequence();
            }, false);
        }

        function getMyApprovalPath() {
            everPopup.openMyApprovalPathPopup();
        }

        function myApprovalPathCallBack(dataJsonArray) {

            dataJsonArray = $.parseJSON(dataJsonArray);

            var store = new EVF.Store();
            store.setGrid([gridL]);
            store.setParameter('strApprovalPathKey', JSON.stringify(dataJsonArray));
            store.load(baseUrl + 'cwor0050_doSelectMyPath.so', function () {
                fillFixDataL();
            }, false);
        }

        function fillFixDataL() {
            fillPathSeq();
        }

        function fillPathSeq() {
            var seq = 1;
            var rowIds = gridL.getAllRowId();
            for (var i in rowIds) {
                var check = gridL.multiSelTest(i);
                gridL.setCellValue(i, 'SIGN_PATH_SQ', seq++);
            }
        }

        function doClose() {
            EVF.closeWindow();
        }

		var k = 0;
		var j = 0;
        function getCust() {

        	var changeCorpType = EVF.C('CORP_TYPE').getValue();
        	
        	if(changeCorpType != '2' || corpType != '2'){
	            var store = new EVF.Store();
	
	            var relat_yn = EVF.V("RELAT_YN");
	            var corp_type = EVF.V("CORP_TYPE");
	            store.load(baseUrl+'cwor0050_getCust.so?RELAT_YN='+relat_yn+'&CORP_TYPE='+corp_type, function() {
	               //조회후 넘겨받은 리스트를 해당 콤보다음에 셋팅한다.
	                EVF.C('CUST_CD').setOptions(this.getParameter("CUST_CD"));
	            });
		
				/* if (k==0) {
					EVF.C('CUST_CD').setValue('${ses.companyCd}');
					k = 1;
				} */
				setTimeout(function() {
		            if (k==0) {
						if(custCd == undefined || custCd == ''){
							EVF.C('CUST_CD').setValue('${ses.companyCd}');
						}else{
							EVF.C('CUST_CD').setValue('${param.CUST_CD}');
						}
						k = 1;
					} 
	            }, 1000)
	            
				EVF.C("CUST_CD").setReadOnly(false);
        	}else{
        		getCustCd();
        	}
        }
        
        function getCustCd() {
       		var store = new EVF.Store();
       		var relat_yn = EVF.V("RELAT_YN");
            var corp_type = EVF.V("CORP_TYPE");
            store.load(baseUrl+'cwor0050_getCustCd.so?RELAT_YN='+relat_yn+'&CORP_TYPE='+corp_type, function() {
                //조회후 넘겨받은 리스트를 해당 콤보다음에 셋팅한다.
                EVF.C('CUST_CD').setOptions(this.getParameter("CUST_CD"));
            });
            
            if (j==0) {
				EVF.C('CUST_CD').setValue('${ses.companyCd}');
				j = 1;
			}
            EVF.C("CUST_CD").setReadOnly(true);
        }
		
        //2021.04.19 첨부파일 업로드 시 서버에 파일이 등록되기전에도 다운로드 가능하도록 기능 추가
		function _doUpload() {
        	
            EVF.C('ATT_FILE_NUM').uploadFile();
        }

    </script>
    <e:window id="CWOR0050" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">

        <e:inputHidden id="CONTENTS_TEXT_NUM" name="CONTENTS_TEXT_NUM" value=""/>
        <e:inputHidden id="UUID" name="UUID" value=""/>
        <e:inputHidden id="APP_DOC_NUM" name="APP_DOC_NUM" value="${param.appDocNum }"/>
        <e:inputHidden id="DOC_NUM" name="DOC_NUM" value="${param.docNum }"/>
        <e:inputHidden id="DOC_TYPE" name="DOC_TYPE" value="${param.docType }"/>
        <e:inputHidden id="APP_AMT" name="APP_AMT" value="${param.appAmt }"/>
        <e:inputHidden id="DOC_ATT_FILE_NUM" name="DOC_ATT_FILE_NUM" value="${param.attFileNum }"/>
        <e:inputHidden id="DOC_SUB_TYPE" name="DOC_SUB_TYPE" value="${param.approvalType }"/>
        <e:inputHidden id="SCREEN_ID" name="SCREEN_ID" value="${param.screenId }"/>
        <e:inputHidden id="SIGN_STATUS" name="SIGN_STATUS" value="${param.signStatus }"/>
        <e:inputHidden id="IMPORTANCE_STATUS" name="IMPORTANCE_STATUS" value="N"/>
        <e:inputHidden id="COMPANY_CD" name="COMPANY_CD" value="${ses.companyCd}"/>
        <e:inputHidden id="CONT_TYPE" name="CONT_TYPE" value="${param.contType }"/>

        <e:buttonBar id="buttonBarTop" width="100%" title="${form_FORM_CAPTION_N }">
            <e:button id="Close" name="Close" label="${Close_N }" disabled="${Close_D }" align="right" onClick="doClose"/>
            <e:button id="ApprovalRequest" name="ApprovalRequest" label="${ApprovalRequest_N }" disabled="${ApprovalRequest_D }" align="right" onClick="doApprovalRequest"/>
        </e:buttonBar>

    <c:if test="${param.approvalType == 'APPROVAL'}">
        <e:searchPanel id="form1" title="" columnCount="2" labelWidth="120" useTitleBar="false">
            <e:row>
                <e:label for="SUBJECT" title="${form_SUBJECT_N }"/>
                <e:field colSpan="3">
                    <e:inputText id="SUBJECT" style="${imeMode }" name="SUBJECT" width="100%" maxLength="${form_SUBJECT_M }" value="${param.subject }" required="${form_SUBJECT_R }" readOnly="${form_SUBJECT_RO }" disabled="${form_SUBJECT_D }" maskType="${form_SUBJECT_MT}" />
                </e:field>
            </e:row>
            <e:row>
                <e:label for="OPINION" title="${form_OPINION_N}"></e:label>
                <e:field colSpan="3">
                    <e:richTextEditor id="DOC_CONTENTS" name="DOC_CONTENTS" width="100%" height="230px" value="" required="${form_OPINION_R }" readOnly="${form_OPINION_RO }" disabled="${form_OPINION_D }" useToolbar="${!param.detailView}" style="${imeMode }" />
                </e:field>
            </e:row>
            <e:row>
                <e:label for="ATT_FILE_NUM" title="${form_ATT_FILE_NUM_N}"></e:label>
                <e:field colSpan="3">
                    <e:fileManager id="ATT_FILE_NUM" name="ATT_FILE_NUM" downloadable="true" bizType="APP" height="120px" readOnly="${form_ATT_FILE_NUM_RO}"  onSuccess="onSuccess" onFileAdd="_doUpload" required="${form_ATT_FILE_NUM_R}"/>
                </e:field>
            </e:row>
        </e:searchPanel>

        <e:buttonBar id="buttonBarSearch" width="100%" title="${form_USER_CAPTION_N }" align="right">
            <e:button id="Search" name="Search" label="${Search_N }" disabled="${Search_D }" onClick="doSearch"/>
        </e:buttonBar>

        <%-- relatYn = '0' (농협)인 경우, 타사 사람에게도 상신이 가능하다. --%>
        <c:if test="${ses.relatYn == '0'}">
            <e:searchPanel id="form2" title="" columnCount="4" labelWidth="120" useTitleBar="false">
                <e:row>
					<e:label for="CORP_TYPE" title="${form_CORP_TYPE_N}"/>
					<e:field>
						<e:select id="RELAT_YN" name="RELAT_YN" value="${ses.relatYn}" options="${relatYnOptions}" width="50" disabled="${form_RELAT_YN_D}" readOnly="${form_RELAT_YN_RO}" required="${form_RELAT_YN_R}" placeHolder="" maskType="${form_RELAT_YN_MT}" />
						<e:select id="CORP_TYPE" name="CORP_TYPE" value="${ses.corpType}" options="${corpTypeOptions}" width="90" onChange="getCust" disabled="${form_CORP_TYPE_D}" readOnly="${form_CORP_TYPE_RO}" required="${form_CORP_TYPE_R}" placeHolder="" maskType="${form_CORP_TYPE_MT}" usePlaceHolder="false"/>
					</e:field>

					<e:label for="CUST_CD" title="${form_CUST_CD_N}"/>
					<e:field>
					<e:select id="CUST_CD" name="CUST_CD" value="" options="${custCdOptions}" width="120" disabled="${form_CUST_CD_D}" readOnly="${form_CUST_CD_RO}" required="${form_CUST_CD_R}" placeHolder="" maskType="${form_CUST_CD_MT}" usePlaceHolder="false"/>
					</e:field>

                    <e:label for="SIGN_USER_NM" title="${form_SIGN_USER_NM_N }"/>
                    <e:field>
                        <e:inputText id="SIGN_USER_NM" name="SIGN_USER_NM" value="" width="${form_SIGN_USER_NM_W}" maxLength="${form_SIGN_USER_NM_M}" required="${form_SIGN_USER_NM_R }" readOnly="${form_SIGN_USER_NM_RO }" disabled="${form_SIGN_USER_NM_D }" style="${imeMode }" onEnter="doSearch" maskType="${form_SIGN_USER_NM_MT}" />
                    </e:field>
                    <e:label for="DEPT_CD" title="${form_DEPT_CD_N }"/>
                    <e:field>
                        <e:inputText id="DEPT_CD" style="${imeMode }" name="DEPT_CD" value="" width="${form_DEPT_CD_W }" readOnly="${form_DEPT_CD_RO }" maxLength="${form_DEPT_CD_M}" required="${form_DEPT_CD_R }" disabled="${form_DEPT_CD_D }" onFocus="onFocus" onEnter="doSearch" maskType="${form_DEPT_CD_MT}" />
                    </e:field>
                </e:row>
            </e:searchPanel>
        </c:if>
        <c:if test="${ses.relatYn == '1'}">
            <e:searchPanel id="form2" title="" columnCount="2" labelWidth="120" useTitleBar="false">
                <e:row>
                    <e:label for="SIGN_USER_NM" title="${form_SIGN_USER_NM_N }"/>
                    <e:field>
                        <e:inputText id="SIGN_USER_NM" name="SIGN_USER_NM" value="" width="${form_SIGN_USER_NM_W}" maxLength="${form_SIGN_USER_NM_M}" required="${form_SIGN_USER_NM_R }" readOnly="${form_SIGN_USER_NM_RO }" disabled="${form_SIGN_USER_NM_D }" style="${imeMode }" onEnter="doSearch" maskType="${form_SIGN_USER_NM_MT}" />
                    </e:field>
                    <e:label for="DEPT_CD" title="${form_DEPT_CD_N }"/>
                    <e:field>
                        <e:inputText id="DEPT_CD" style="${imeMode }" name="DEPT_CD" value="" width="${form_DEPT_CD_W }" readOnly="${form_DEPT_CD_RO }" maxLength="${form_DEPT_CD_M}" required="${form_DEPT_CD_R }" disabled="${form_DEPT_CD_D }" onFocus="onFocus" onEnter="doSearch" maskType="${form_DEPT_CD_MT}" />
                    </e:field>
                </e:row>
            </e:searchPanel>
        </c:if>
    </c:if>
    <c:if test="${param.approvalType != 'APPROVAL'}">

        <e:inputHidden id="DOC_CONTENTS" name="DOC_CONTENTS"/>
        <e:inputHidden id="ATT_FILE_NUM" name="ATT_FILE_NUM" value=""/>
        <e:inputHidden id="SIGN_REQ_TYPE" name="SIGN_REQ_TYPE" value="R"/>

        <e:searchPanel id="form1" title="" columnCount="2" labelWidth="120" useTitleBar="false">
            <e:row>
                <e:label for="SUBJECT" title="${form_SUBJECT_N }"/>
                <e:field colSpan="3">
                    <e:inputText id="SUBJECT" style="${imeMode }" name="SUBJECT" width="100%" maxLength="${form_SUBJECT_M }" value="${param.subject }" required="${form_SUBJECT_R }" readOnly="${form_SUBJECT_RO }" disabled="${form_SUBJECT_D }" maskType="${form_SUBJECT_MT}" />
                </e:field>
            </e:row>
        </e:searchPanel>
        <e:searchPanel id="form2" title="${form_USER_CAPTION_N }" columnCount="2" labelWidth="120" useTitleBar="true">
            <e:row>
                <e:label for="SIGN_USER_NM" title="${form_SIGN_USER_NM_N }"/>
                <e:field colSpan="3">
                    <e:inputText id="SIGN_USER_NM" style="${imeMode }" name="SIGN_USER_NM" width="150" maxLength="${form_SIGN_USER_NM_M}" required="${form_SIGN_USER_NM_R }" readOnly="${form_SIGN_USER_NM_RO }" disabled="${form_SIGN_USER_NM_D }" onEnter="doSearch" maskType="${form_SIGN_USER_NM_MT}" />
                    &nbsp;&nbsp;
                    <e:button id="Search" name="Search" label="${Search_N }" disabled="${Search_D }" onClick="doSearch"/>
                </e:field>
            </e:row>
        </e:searchPanel>
    </c:if>

        <br>

		<e:panel id="bg1" width="47%">
            <e:buttonBar id="buttonBarBottomL" align="left" width="100%">
	            <e:button id="getMyApprovalPath" name="getMyApprovalPath" label="${getMyApprovalPath_N }" disabled="${getMyApprovalPath_D }" onClick="getMyApprovalPath"/>
	            <e:button id="Up" name="Up" label="${Up_N }" disabled="${Up_D }" onClick="doUp"/>
	            <e:button id="Down" name="Down" label="${Down_N }" disabled="${Down_D }" onClick="doDown"/>
                <e:button id="Delete" name="Delete" label="${Delete_N }" disabled="${Delete_D }" onClick="doDelete"/>
                <%--
                <e:button id="Arranging" name="Arranging" label="${Arranging_N }" disabled="${Arranging_D }" onClick="doArranging"/>
                <e:button id="CancelArg" name="CancelArg" label="${CancelArg_N }" disabled="${CancelArg_D }" onClick="doCancelArg"/>
                --%>
	        </e:buttonBar>

            <e:gridPanel id="gridL" name="gridL" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}"/>
        </e:panel>

        <e:panel id="null1" width="1%">&nbsp;</e:panel>

        <e:panel id="bg2" width="52%">
            <e:buttonBar id="buttonBarBottomR" align="right" width="100%">
                <e:text style="font-size:11pt; font-weight:bold;">[${form_SIGN_REQ_CAPTION_N }]&nbsp;&nbsp;</e:text>
                <e:radioGroup id="SIGN_REQ_TYPE" name="SIGN_REQ_TYPE" disabled="" readOnly="" required="" width="150px">
                    <e:radio id="R1" name="R1" label="결재" value="E" checked="true" readOnly="${form_SIGN_REQ_TYPE_RO }" disabled="${form_SIGN_REQ_TYPE_D }"/>
                    <e:radio id="R2" name="R2" label="결재(현장대리인)" value="ES" readOnly="${form_SIGN_REQ_TYPE_RO }" disabled="${form_SIGN_REQ_TYPE_D }"/>
                    <e:radio id="R3" name="R3" label="결재(구매담당자)" value="EP" readOnly="${form_SIGN_REQ_TYPE_RO }" disabled="${form_SIGN_REQ_TYPE_D }"/>
                    <e:radio id="R4" name="R4" label="합의" value="A" readOnly="${form_SIGN_REQ_TYPE_RO }" disabled="${form_SIGN_REQ_TYPE_D }"/>
                    <e:radio id="R5" name="R5" label="참조" value="CC" readOnly="${form_SIGN_REQ_TYPE_RO }" disabled="${form_SIGN_REQ_TYPE_D }"/>
                </e:radioGroup>
                <e:button id="Choose" name="Choose" label="${Choose_N }" disabled="${Choose_D }" onClick="doChoose"/>
            </e:buttonBar>

            <e:gridPanel id="gridR" name="gridR" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}"/>
        </e:panel>

    </e:window>
</e:ui>