<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
    <script type="text/javascript">
        var gridMTGL;
        var gridPOPY;
        var gridPOPC;
        var gridTEMP;
        var baseUrl = "/nhepro/CPOI/";
        var detailView = "${param.detailView}" == "true";
        var PROGRESS_CD = "${empty formData.PROGRESS_CD ? param.PROGRESS_CD : formData.PROGRESS_CD}";

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
                    if(colIdx == "PR_BUYER_DEPT_NM") {
                        if(value == "공동" || EVF.V("PO_CREATE_TYPE") == "MANUAL") {
                        	param = {
                    				'callBackFunction': 'callBackBUYER_DEPT_NM',
                    				'READONLY': 'N',	//팝업 조회조건 변경불가
                    				'multiYN': 'N',		//멀티팝업여부
                    				'rowIdx': rowIdx,
                    				'detailView': false
                    		};
                    		everPopup.openPopupByScreenId("CCDU0010", 1000, 700, param);
                        }
                    }
                    else if(colIdx == "MAKER_NM") {
                        if(EVF.V("PO_CREATE_TYPE") == "MANUAL" && gridMTGL.getCellValue(rowIdx, "MAJOR_ITEM_FLAG") == "1") {
                            param = {
                                callBackFunction: "callBackMAKER_NM",
                                rowIdx: rowIdx
                            };
                            everPopup.openCommonPopup(param, "SP0068");
                        }
                    }
                }
				
                if(colIdx == "EXEC_NUM") {
                	if( value == "" ) return;
                    param = {
                        execNum: value,
                        buyerCd: gridMTGL.getCellValue(rowIdx, "BUYER_CD"),
                        tcoFlag: null,
                        popupFlag: true,
                        detailView: true
                    };
                    everPopup.openWindowPopup("/nhepro/CBDR/CBDI0061/view.so", 1400, 800, param, "createCN", true);
                }
                
                if(colIdx == "CONT_NUM") {
                	if( value == "" ) return;
                    param = {
                        callbackFunction: "",
                        url: '/nhepro/CCTR/CCTA0030/view.so',
                        CONT_NUM: value,
                        CONT_CNT: gridMTGL.getCellValue(rowIdx, "CONT_CNT"),
                        detailView: true,
                        buttonView: false
                    };
                    everPopup.openContractChangeInformation(param);
                }
            });

            gridMTGL.cellChangeEvent(function (rowIdx, colIdx, irow, icol, value, oldValue) {
                if(colIdx == "PO_QT" || colIdx == "UNIT_PRC") {
                    var PO_QT = Number(gridMTGL.getCellValue(rowIdx, "PO_QT"));
                    var UNIT_PRC = Number(gridMTGL.getCellValue(rowIdx, "UNIT_PRC"));
                    gridMTGL.setCellValue(rowIdx, "ITEM_AMT", everMath.floor_float(PO_QT * UNIT_PRC));

                    var sumAmt = 0;
                    var allRowId = gridMTGL.getAllRowId();
                    for(var i in allRowId) {
                        var idx = allRowId[i];
                        sumAmt += gridMTGL.getCellValue(idx, "ITEM_AMT");
                    }
                    EVF.V("PO_AMT", sumAmt);
                    onChangePO_AMT(EVF.C("PO_AMT"), sumAmt);
                }
            });
			
         	// 지불정보
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
                }
                else {
                    gridPOPC.addRow(JSON.parse(PC_INFO));
                }
				
                var sumPayAmt = gridPOPC._gvo.getSummary("PAY_AMT", "sum");
                gridPOPY._gdp.setValue(rowIdx, "PY_PAY_AMT", sumPayAmt);
                
                // 2021.08.03 지불정보 클릭시 지급차수를 Hidden값으로 추가
                EVF.V("SEL_PAY_CNT", gridPOPY.getCellValue(rowIdx, "PAY_CNT"));
            });
			
            // 지불정보
            gridPOPY.cellChangeEvent(function (rowIdx, colIdx, iRow, iCol, value) {
                if(EVF.V("PO_AMT") == "") {
                    return EVF.alert("${CPOI0010_013}");
                }
                else {
                    if(colIdx == "PAY_CNT_TYPE") {
                        gridPOPY.setCellValue(rowIdx, "PAY_CNT_NM", value);
                    }
                    else if(colIdx == "PAY_CNT_NM") {
                        var allRowId = gridPOPC.getAllRowId();
                        for(var k in allRowId) {
                            var idx = allRowId[k];
                            gridPOPC.setCellValue(idx, "PAY_CNT_NM", value);
                        }
                    }
                    else if(colIdx == "PAY_PERCENT") {
                        gridPOPY.setCellValue(rowIdx, "PAY_AMT", everMath.floor_float((gridPOPY.getCellValue(rowIdx, "PAY_PERCENT") / 100) * EVF.V("PO_AMT")));
                    }
                }
            });
			
            // 고객사별 지불고객사 정보
            gridPOPC.cellClickEvent(function(rowIdx, colIdx) {
                if(!detailView) {
                    if(colIdx == "PY_BUYER_DEPT_NM") {
                    	var param = {
                				'callBackFunction': 'callBackPY_BUYER_DEPT_NM',
                				'READONLY': 'N',	//팝업 조회조건 변경불가
                				'multiYN': 'N',		//멀티팝업여부
                				'rowIdx': rowIdx,
                				'detailView': false
                		};
                		everPopup.openPopupByScreenId("CCDU0010", 1000, 700, param);
                    }
                }
            });
			
         	// 고객사별 지불고객사 정보
            gridPOPC.cellChangeEvent(function (rowIdx, colIdx) {
            	
                var idx = gridPOPC.getCellValue(rowIdx, "PAY_CNT");
                if(colIdx == "PAY_AMT") {
                    var sumPayAmt = gridPOPC._gvo.getSummary("PAY_AMT", "sum");
                    gridPOPY.setCellValue(idx - 1, "PY_PAY_AMT", sumPayAmt);
                }
            });
			
         	// 고객사별 지불고객사 정보
            gridPOPC.addRowEvent(function() {
                if(gridPOPC.getRowCount() == 0) { return EVF.alert("${CPOI0010_015}"); }
                var param = [{
                    PAY_CNT: gridPOPC.getCellValue(0, "PAY_CNT"),
                    PAY_CNT_TYPE: gridPOPC.getCellValue(0, "PAY_CNT_TYPE"),
                    PAY_CNT_NM: gridPOPC.getCellValue(0, "PAY_CNT_NM")
                }];

                gridPOPC.addRow(param);
            });
			
            // 2021.08.04 : 복사기능 제외
            //gridPOPC.insertRowEvent(function() {
            //    gridPOPC.insertRow(true);
            //});
			
            gridPOPC.upMoveRowEvent(function() {
                gridPOPC.upMoveRow();
            });
			
            gridPOPC.downMoveRowEvent(function() {
                gridPOPC.downMoveRow();
            });
			
         	// 고객사별 지불고객사 정보
            gridPOPC.delRowEvent(function(rowIdx, colIdx) {
                if(gridPOPC.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
                
                gridPOPC.delRow();
                
                // 고객사별 지불고객사 정보 Row 삭제시 "지불정보"의 "지불고객사" 항목 변경
                var str = "";
                var idx = Number(EVF.V("SEL_PAY_CNT"));
                if(gridPOPC.getRowCount() > 0) {
                    allRowId = gridPOPC.getAllRowId();
                    for(i in allRowId) {
                    	if (i > 0) str += ',';
                        str += gridPOPC.getCellValue(allRowId[i], "PY_BUYER_DEPT_NM");
                    }
                }
                gridPOPY.setCellValue(idx - 1, "PY_BUYER_NM", str);
            });
            if(detailView) {
            	EVF.C("doApprovalRequest").setVisible(false);
                EVF.C("doApprovalRequest2").setVisible(false);
                EVF.C("doApplyPayCnt").setVisible(false);
            }
            else {
                EVF.C("doApprovalRequest").setVisible(true);
                EVF.C("doApprovalRequest2").setVisible(true);

                if(PROGRESS_CD == "100") {
                    EVF.C("doDelete").setVisible(true);
                    EVF.C("doDelete2").setVisible(true);
                    
                    // 2021.08.03 변경
                    //onChangeDELIVERY_TYPE(EVF.C("DELIVERY_TYPE"), EVF.V("DELIVERY_TYPE"));
                    var delyType = EVF.V("DELIVERY_TYPE");	// DI:납품, PI:검수
                    if(delyType == "DI") {
                        EVF.C("PAY_TYPE").setDisabled(true);
                        EVF.C("PAY_TYPE").setRequired(false);
                        EVF.C("PAY_TYPE_DUP").setRequired(false);
                    }
                    else if(delyType == "PI") {
                        EVF.C("PAY_TYPE").setDisabled(false);
                        EVF.C("PAY_TYPE").setRequired(true);
                        EVF.C("PAY_TYPE_DUP").setRequired(true);
                    }
                }
                else {
                    EVF.C("doDelete").setVisible(false);
                    EVF.C("doDelete2").setVisible(false);
                }

                if(EVF.V("PO_CREATE_TYPE") == "LAST") { // LAST:종가발주
                    EVF.C("doSearchItem").setDisabled(true);
                    EVF.C("doDeleteItem").setDisabled(true);

                    EVF.C("CUR").setReadOnly(true);
                    EVF.C("VAT_TYPE").setReadOnly(true);
                }
                else if(EVF.V("PO_CREATE_TYPE") == "MANUAL") { // MANUAL:수기발주
                    EVF.C("doSearchItem").setDisabled(false);
                    EVF.C("doDeleteItem").setDisabled(false);
                    EVF.C("doClose").setVisible(false);
                    EVF.C("doClose2").setVisible(false);
                }
                else if(EVF.V("PO_CREATE_TYPE") == "MDRAFT") { // MDRAFT:수기계약발주
                	if( !EVF.isEmpty(EVF.V("EXEC_NUM")) ) { // 품의를 타고 들어온 건은 품목추가/삭제 불가능
                        EVF.C("doSearchItem").setDisabled(true);
                        EVF.C("doDeleteItem").setDisabled(true);
                	}
                }
            }
            
            if(detailView) {
                doSearchPODT();
                doSearchPOPY();
            } else {
                if(PROGRESS_CD == "100") {
                    doSearchPODT();
                    doSearchPOPY();
                } else {
                    if(EVF.V("PO_CREATE_TYPE") == "LAST") {
                        doSearchMTGL();
                    } else {
                        EVF.V("CUR", "KRW");
                    }
                }
            }

            if(EVF.V("PO_CREATE_TYPE") == "MANUAL") {
                gridMTGL.removeColumn("PR_BUYER_DEPT_NM");
            }

            gridPOPY.setColBgColor("PY_PAY_AMT", "#f5f5f5");
            gridPOPY.setColBgColor("PY_BUYER_NM", "#f5f5f5");

            gridTEMP = EVF.C("gridTEMP");
            $("#panel_hide").hide();

            // ======================그리드 합계 구하기=======================
		    var val = {"visible": true, "count": 1, "height": 15};
		    gridMTGL.setProperty('footerVisible', val);

		    var footer = {
		          "styles": {
		              "textAlignment": "center",
		              "fontBold": true,
		              "fontFmaily": "Nanum Gothic",
		          },
		          "text": "합   계"
		    };
		    gridMTGL.setRowFooter("PURCHASE_TYPE", footer);

		    var distVal = {
		          "styles": {
		              "textAlignment": "far",
		              "numberFormat" : "#,###.###",
		              "fontFmaily": "Nanum Gothic",
		              "paddingRight": 5,
		              "fontBold": true
		          },
		          "expression": ["sum"],
		          "groupExpression": "sum"
		    };
		    gridMTGL.setRowFooter("PO_QT", distVal);
		    gridMTGL.setRowFooter("ITEM_AMT", distVal);
		    // ===========================================================
		    
		    // ======================그리드 합계 구하기=======================
		    var val = {"visible": true, "count": 1, "height": 15};
		    gridPOPY.setProperty('footerVisible', val);

		    var footer = {
		          "styles": {
		              "textAlignment": "center",
		              "fontBold": true,
		              "fontFmaily": "Nanum Gothic",
		          },
		          "text": "합   계"
		    };
		    gridPOPY.setRowFooter("PAY_CNT_TYPE", footer);

		    var distVal = {
		          "styles": {
		              "textAlignment": "far",
		              "numberFormat" : "#,###.###",
		              "fontFmaily": "Nanum Gothic",
		              "paddingRight": 5,
		              "fontBold": true
		          },
		          "expression": ["sum"],
		          "groupExpression": "sum"
		    };
		    gridPOPY.setRowFooter("PAY_PERCENT", distVal);
		    gridPOPY.setRowFooter("PAY_AMT", distVal);
		    gridPOPY.setRowFooter("PY_PAY_AMT", distVal);
		    // ===========================================================
		    
		    // ======================그리드 합계 구하기=======================
		    var val = {"visible": true, "count": 1, "height": 15};
		    gridPOPC.setProperty('footerVisible', val);

		    var footer = {
		          "styles": {
		              "textAlignment": "center",
		              "fontBold": true,
		              "fontFmaily": "Nanum Gothic",
		          },
		          "text": "합   계"
		    };
		    gridPOPC.setRowFooter("PAY_CNT_NM", footer);

		    var distVal = {
		          "styles": {
		              "textAlignment": "far",
		              "numberFormat" : "#,###.###",
		              "fontFmaily": "Nanum Gothic",
		              "paddingRight": 5,
		              "fontBold": true
		          },
		          "expression": ["sum"],
		          "groupExpression": "sum"
		    };
		    gridPOPC.setRowFooter("PAY_AMT", distVal);
		    // ===========================================================
		    
		    // 2021.08.03 제외
		    //onChangePAY_TYPE();
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
            gridPOPY._gdp.setValue(rowIdx, "PC_INFO", JSON.stringify(data));
        }
		
        // 계약의뢰 고객사 전체적용
        function callBackBUYER_DEPT_NM(data) {
        	
        	data = JSON.parse(data);
        	if( data != null ) {
	        	if(gridMTGL.getRowCount() == 1) {
	        		gridMTGL.setCellValue(data.rowIdx, "BUYER_CD", data.CUST_CD);
	        		gridMTGL.setCellValue(data.rowIdx, "BUYER_NM", data.CUST_NM);
	        		gridMTGL.setCellValue(data.rowIdx, "DEPT_CD",  data.DEPT_CD);
	                gridMTGL.setCellValue(data.rowIdx, "DEPT_NM",  data.DEPT_NM);
	                gridMTGL.setCellValue(data.rowIdx, "PR_BUYER_DEPT_NM", data.CUST_NM + " " + data.DEPT_NM);
				} else{
					EVF.confirm('전체 적용하시겠습니까?', function() {
						var kcou = gridMTGL.getRowCount();
						for(var k=0;k < kcou;k++) {
							gridMTGL.setCellValue(k, "BUYER_CD", data.CUST_CD);
							gridMTGL.setCellValue(k, "BUYER_NM", data.CUST_NM);
							gridMTGL.setCellValue(k, "DEPT_CD",  data.DEPT_CD);
			                gridMTGL.setCellValue(k, "DEPT_NM",  data.DEPT_NM);
			                gridMTGL.setCellValue(k, "PR_BUYER_DEPT_NM", data.CUST_NM + " " + data.DEPT_NM);
						}
					}, function() {
						gridMTGL.setCellValue(data.rowIdx, "BUYER_CD", data.CUST_CD);
						gridMTGL.setCellValue(data.rowIdx, "BUYER_NM", data.CUST_NM);
						gridMTGL.setCellValue(data.rowIdx, "DEPT_CD",  data.DEPT_CD);
		                gridMTGL.setCellValue(data.rowIdx, "DEPT_NM",  data.DEPT_NM);
		                gridMTGL.setCellValue(data.rowIdx, "PR_BUYER_DEPT_NM", data.CUST_NM + " " + data.DEPT_NM);
					});
				}
        	}
        }
		
        function callBackPY_BUYER_DEPT_NM(data) {
        	
        	data = JSON.parse(data);
            if( data != null ) {
	            var PY_BUYER_DEPT_NM = data.CUST_NM + " " + data.DEPT_NM;
				
	            var check = false;
	            var allRowId = gridPOPC.getAllRowId();
	            for(var i in allRowId) {
	                var j = allRowId[i];
	                if(PY_BUYER_DEPT_NM == gridPOPC.getCellValue(j, "PY_BUYER_DEPT_NM")) {
	                    check = true;
	                }
	            }
				
	            if(check) {
	                return EVF.alert("${CPOI0010_017}");
	            }
				
	            gridPOPC.setCellValue(data.rowIdx, "PY_BUYER_CD", data.CUST_CD);
            	gridPOPC.setCellValue(data.rowIdx, "PY_BUYER_NM", data.CUST_NM);
            	gridPOPC.setCellValue(data.rowIdx, "PY_DEPT_CD", data.DEPT_CD);
            	gridPOPC.setCellValue(data.rowIdx, "PY_DEPT_NM", data.DEPT_NM);
            	gridPOPC.setCellValue(data.rowIdx, "PY_BUYER_DEPT_NM", data.CUST_NM + " " + data.DEPT_NM);
				
                var str = "";
	            var idx = gridPOPC.getCellValue(data.rowIdx, "PAY_CNT");
	            if (gridPOPC.getRowCount() > 1) {
	                allRowId = gridPOPC.getAllRowId();
	                for(i in allRowId) {
	                	if (i > 0) str += ',';
	                    str += gridPOPC.getCellValue(allRowId[i], "PY_BUYER_DEPT_NM");
	                }
	            }
	            else {
	            	str = data.CUST_NM + " " + data.DEPT_NM;
	            }
	            gridPOPY.setCellValue(idx - 1, "PY_BUYER_NM", str);
        	}
        }
		
        function callBackMAKER_NM(data) {
            gridMTGL.setCellValue(data.rowIdx, "MAKER_CD", data.MKBR_CD);
            gridMTGL.setCellValue(data.rowIdx, "MAKER_NM", data.MKBR_NM);
        }
		
        // 협력사 검색
        function onIconClickVENDOR_CD() {
            if(EVF.V("PO_CREATE_TYPE") == "MANUAL") { // LAST:종가발주, MANUAL:수기발주
                var param = {
                    callBackFunction: "callBackVENDOR_CD",
                    BUYER_CD: "${ses.companyCd}"
                };
                everPopup.openCommonPopup(param, "SP0123");
            }
        }

        function callBackVENDOR_CD(data) {
            EVF.V("VENDOR_CD", data.VENDOR_CD);
            EVF.V("VENDOR_NM", data.VENDOR_NM);
        }
		
        // 구매담당자 검색
        function onIconClickCTRL_USER_ID() {
        	var param = {
					'callBackFunction': 'callBackCTRL_USER_ID',
					'READONLY': 'N',		//팝업 조회조건 변경불가
					'multiYN' : 'N',        //멀티팝업여부
					'CTRL_CD' : 'BR020',	//검수담당자권한(=기본권한으로 변경)
					'detailView': false
			};
			everPopup.openPopupByScreenId("CCDU0020", 1100, 700, param);
        }
		
        function callBackCTRL_USER_ID(data) {
        	if(data!=null){
				data = JSON.parse(data);
	            EVF.V("CTRL_USER_ID", data.USER_ID);
	            EVF.V("CTRL_USER_NM", data.USER_NM);
        	}
        }
        
        // 검수담당자 검색
        function onIconClickINSPECT_USER_ID() {
        	var param = {
					'callBackFunction': 'callBackINSPECT_USER_ID',
					'READONLY': 'N',		//팝업 조회조건 변경불가
					'multiYN' : 'N',        //멀티팝업여부
					'CTRL_CD' : 'BR020',	//검수담당자권한(=기본권한으로 변경)
					'detailView': false
			};
			everPopup.openPopupByScreenId("CCDU0020", 1100, 700, param);
        }

        function callBackINSPECT_USER_ID(data) {
        	if(data!=null){
				data = JSON.parse(data);
	            EVF.V("INSPECT_USER_ID", data.USER_ID);
	            EVF.V("INSPECT_USER_NM", data.USER_NM);
        	}
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
                        PAY_AMT = (gridPOPY.getCellValue(rowIdx, "PAY_PERCENT") / 100) * value;
                        gridPOPY.setCellValue(rowIdx, "PAY_AMT", everMath.floor_float(PAY_AMT));
                    }
                }
                else if(EVF.V("PAY_TYPE") == "LS") {
                    PAY_AMT = (gridPOPY.getCellValue(0, "PAY_PERCENT") / 100) * value;
                    gridPOPY.setCellValue(0, "PAY_AMT", everMath.floor_float(PAY_AMT));
                }
            }
        }
		
        function onChangeVAT_TYPE(component, value) {
            EVF.V("VAT_TYPE_DUP", value);
        }
		
        // 검수유형
        function onChangeDELIVERY_TYPE(component, value) {
            if (value == "DI") {	// DI:납품, PI:검수
                EVF.C("PAY_TYPE").setDisabled(true);
                EVF.C("PAY_TYPE").setRequired(false);
                EVF.C("PAY_TYPE_DUP").setRequired(false);
                EVF.V("PAY_TYPE", "LS");
            }
            else if (value == "PI") {
                EVF.C("PAY_TYPE").setDisabled(false);
                EVF.C("PAY_TYPE").setRequired(true);
                EVF.C("PAY_TYPE_DUP").setRequired(true);
            }
        }
        
        // 대금지불방식
        function onChangePAY_TYPE(component, value) {
        	
        	if( value == "" || value == undefined ) {
        		value = EVF.V("PAY_TYPE");
        	}
            EVF.V("PAY_TYPE_DUP", value);
            
            if(value == "LS") { // LS:일괄지급, IS:분할지급
                EVF.V("PAY_CNT", "1");
                EVF.C("doApplyPayCnt").setDisabled(true);
                if(PROGRESS_CD == "" || PROGRESS_CD == "100") {
                    doApplyPayCnt();
                }
            }
            else if(value == "IS") {
                EVF.V("PAY_CNT", "");
                EVF.C("doApplyPayCnt").setDisabled(false);
            }
        }

        function doSearchMTGL() {
            var store = new EVF.Store();
            store.setParameter("gridSel", JSON.stringify(${gridSel}));
            store.setGrid([gridMTGL]);
            store.load(baseUrl + "cpoi0010_doSearchMTGL.so", function() {
                if(gridMTGL.getRowCount() > 0){
                    var allRowId = gridMTGL.getAllRowId();
					
                    gridMTGL.setFigureBackground("PR_BUYER_DEPT_NM", gridMTGL._PROPERTIES.CELL_BG_COLOR.DEFAULT);
                    gridMTGL.setFigureBackground("PURCHASE_TYPE", gridMTGL._PROPERTIES.CELL_BG_COLOR.DEFAULT);
                    gridMTGL.setFigureBackground("PO_QT", gridMTGL._PROPERTIES.CELL_BG_COLOR.DEFAULT);
                    gridMTGL.setFigureBackground("UNIT_CD", gridMTGL._PROPERTIES.CELL_BG_COLOR.DEFAULT);
                    gridMTGL.setFigureBackground("UNIT_PRC", gridMTGL._PROPERTIES.CELL_BG_COLOR.DEFAULT);

                    for(var i in allRowId) {
                        var rowIdx = allRowId[i];
						
                        gridMTGL.setCellReadOnly(rowIdx, "PO_QT", true);
                        gridMTGL.setCellReadOnly(rowIdx, "UNIT_CD", true);
                        gridMTGL.setCellReadOnly(rowIdx, "UNIT_PRC", true);
                        gridMTGL.setCellReadOnly(rowIdx, "PURCHASE_TYPE", true);
                    }
                }
            });
        }

        function doSearchPODT() {
            var store = new EVF.Store();
            store.setGrid([gridMTGL]);
            store.load(baseUrl + "cpoi0010_doSearchPODT.so", function() {
                if(gridMTGL.getRowCount() > 0 && !detailView){
                    var allRowId = gridMTGL.getAllRowId();

                    for(var i in allRowId) {
                        var rowIdx = allRowId[i];

                        if (EVF.V("PO_CREATE_TYPE") == "LAST") { // LAST:종가발주, MANUAL:수기발주
                            gridMTGL.setFigureBackground("PR_BUYER_DEPT_NM", gridMTGL._PROPERTIES.CELL_BG_COLOR.DEFAULT);
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
            store.load(baseUrl + "cpoi0010_doSearchPOPY.so", function () {
                if (gridPOPY.getRowCount() > 0) {
                    var PC_INFO = gridPOPY.getCellValue(0, "PC_INFO");

                    gridPOPC.addRow(JSON.parse(PC_INFO));

                    EVF.V("PAY_CNT", gridPOPY.getRowCount());
                }
            });
        }
        
        function doSearchCont() {
			var param = {
					'callBackFunction': 'setCont',
					'detailView': false
			};
			everPopup.openPopupByScreenId("CCTR0200", 1300, 700, param);
		}

		function setCont(data) {
			if(data!=null){
				data = JSON.parse(data);
				EVF.V("CONT_NUM", data.CONT_NUM);
				EVF.V("CONT_CNT", data.CONT_CNT);
			}
		}
		
		function doApplyCont() {
			if (gridMTGL.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
			
			if( EVF.V("CONT_NUM") == "" || EVF.V("CONT_NUM") == "" ) {
				return EVF.alert("적용할 계약번호가 선택되지 않았습니다.");
			}
			
			var selectedRow = gridMTGL.getSelRowId();
			if (selectedRow.length >= 1) {
				EVF.confirm('선택한 품목정보에 해당 계약번호를 적용 하시겠습니까?', function() {
					for(var i in selectedRow) {
						gridMTGL.setCellValue(selectedRow[i], "CONT_NUM", EVF.V("CONT_NUM"));
						gridMTGL.setCellValue(selectedRow[i], "CONT_CNT", EVF.V("CONT_CNT"));
					}
				});
			}
		}

        function doSearchItem() {
            var param = {
                PROJECT_SQ: null,
                detailView: false,
                callbackFunction: "callBackITEM"
            };
            everPopup.openPopupByScreenId("CITR0042", 1150, 810, param);
        }

        function callBackITEM(data) {
            gridMTGL.setFigureBackground("UNIT_CD", gridMTGL._PROPERTIES.CELL_BG_COLOR.DEFAULT);

            for(var j in data) {
                var rowIdx = gridMTGL.addRow(data[j]);

                gridMTGL.setCellValue(rowIdx, "PR_BUYER_CD", EVF.V("BUYER_CD"));
                gridMTGL.setCellValue(rowIdx, "PR_DEPT_CD", EVF.V("DEPT_CD"));

                if(data[j].MAJOR_ITEM_FLAG == "1") {   // 대표품목
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

        function doDeleteItem() {
            if(gridMTGL.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

            var sum = 0;
            var param;
            for(var i = gridMTGL.getRowCount() - 1; i >= 0; i--) {
                if(gridMTGL.isChecked(i)) {
                    sum += gridMTGL.getCellValue(i, "ITEM_AMT");
                    param = [{
                        ITEM_CD: gridMTGL.getCellValue(i, "ITEM_CD"),
                        PO_NUM: gridMTGL.getCellValue(i, "PO_NUM"),
                        PO_SQ: gridMTGL.getCellValue(i, "PO_SQ")
                    }];
                    gridTEMP.addRow(param);
                    gridMTGL.delRow(i);
                }
            }

            EVF.V("PO_AMT", EVF.V("PO_AMT") - sum);
            onChangePO_AMT(EVF.C("PO_AMT"), EVF.V("PO_AMT"));
        }

        function doApplyPayCnt() {
        	
            var PAY_CNT = EVF.V("PAY_CNT");
            if( EVF.V("PAY_TYPE") == "" ) {
                return EVF.alert("${CPOI0010_008}");
            }
            else if( EVF.V("PAY_TYPE") == "LS" ) {
            	PAY_CNT = "1";
            }
            
            /**
             * 2021.04.30 분할지급인 경우 차수 입력시 제한 삭제
            if(PAY_CNT < 1 || PAY_CNT > 12) {
                EVF.V("PAY_CNT", "");
                return EVF.alert("${CPOI0010_009}");
            }*/
			
            if(gridPOPY.getRowCount() > 0) {
                EVF.confirm("${CPOI0010_012}", function () {
                    display(PAY_CNT);
                });
            } else {
                display(PAY_CNT);
            }
        }

        function display(PAY_CNT) {
            gridPOPY.delAllRow();
            gridPOPC.delAllRow();

            var param;
            if(PAY_CNT == "1") {
                param = {
                    PAY_CNT: "1",
                    PAY_CNT_TYPE: "BP",     // 계약금:DP, 중도금:PP, 잔금:BP
                    PAY_CNT_NM: "잔금",
                    PAY_PERCENT: "100"
                };
                gridPOPY.addRow(param);
            } else {
                for(var i = 1; i<=PAY_CNT; i++) {
                    if(PAY_CNT == "2") {
                        param = {
                            PAY_CNT: i,
                            PAY_CNT_TYPE: i==1?"DP":"BP",
                            PAY_CNT_NM: i==1?"계약금":"잔금"
                        };
                    } else if(PAY_CNT == "3") {
                    	param = {
                            PAY_CNT: i,
                            PAY_CNT_TYPE: i==1?"DP":i==2?"PP":"BP",
                            PAY_CNT_NM: i==1?"계약금":i==2?"중도금":"잔금"
                        };
                    } else {
                        param = {
                            PAY_CNT: i,
                            PAY_CNT_TYPE: i==1?"DP":i<PAY_CNT?"PP":"BP",
                            PAY_CNT_NM: i==1?"계약금":i<PAY_CNT?"중도금":"잔금"
                        };
                    }

                    var cnt = gridPOPY.addRow(param);
                    if((cnt + 1) == PAY_CNT) {
                        setTimeout(function() {
                            gridPOPY._gvo.resetCurrent(0);
                        }, 100)
                    } 
                }
            }
        }

        function doSave() {
        	var signStatus = this.getData().data;

            var store = new EVF.Store();
            if(!store.validate()) { return; }

            if (!gridMTGL.validate(true).flag) { return EVF.alert(gridMTGL.validate().msg); }
            if (!gridPOPY.validate(true).flag) { return EVF.alert(gridPOPY.validate().msg); }
            if (!gridPOPC.validate(true).flag) { return EVF.alert(gridPOPC.validate().msg); }

            var PO_AMT = Number(EVF.V("PO_AMT"));
            if(PO_AMT == 0) {
                return EVF.alert("${CPOI0010_014}");
            }
			
            var payPercent = 0;
            var allRowId = gridPOPY.getAllRowId();
            for(var i in allRowId) {
                var rowIdx = allRowId[i];
                payPercent += Number(gridPOPY.getCellValue(rowIdx, "PAY_PERCENT"));
                if(gridPOPY.getCellValue(rowIdx, "PAY_AMT") != gridPOPY.getCellValue(rowIdx, "PY_PAY_AMT")) {
                    return EVF.alert("[" + gridPOPY.getCellValue(rowIdx, "PAY_CNT_NM") + "] " + "${CPOI0010_011}");
                }
            }
            payPercent = Math.round(payPercent * 1e12) / 1e12;
            if( payPercent > 100 || payPercent < 100 ) {
            	return EVF.alert("${CPOI0010_020}");
            }
            
            var sumAmt = gridPOPY._gvo.getSummary("PAY_AMT", "sum");
            if(PO_AMT != sumAmt) {
                return EVF.alert("${CPOI0010_010}");
            }

			var preSignStatus = EVF.V('PRE_SIGN_STATUS');
			if (preSignStatus != 'E') {
				EVF.V('SIGN_STATUS', signStatus);
			}

			var confirmMessage;
			switch (signStatus) {
				case 'T':
					confirmMessage = '${msg.M0021}';
					break;
				case 'E':
					confirmMessage = '${msg.M0053}';
					break;
				case 'P':
					confirmMessage = '${msg.M0053}';
					break;
			}

			EVF.confirm(confirmMessage, function () {

				if (signStatus === 'T' || signStatus === 'E') {
					goApproval();
				}
				else if (signStatus === 'P') {

					var param = {
						subject: EVF.V('SUBJECT'),
						docType: "PO",
						signStatus: signStatus,
						screenId: "CPOI0010",
						approvalType: 'APPROVAL',
						attFileNum: "",
						docNum: EVF.V('PO_NUM'),
						appDocNum: EVF.V('APP_DOC_NUM'),
						callBackFunction: "goApproval",
                        appAmt: eval(EVF.V('PO_AMT'))
					};
					everPopup.openApprovalRequestIPopup(param);
				}
			});
        }

		function goApproval(formData, gridData, attachData) {
			EVF.V('approvalFormData', formData);
			EVF.V('approvalGridData', gridData);
			EVF.V('attachFileDatas', attachData);

            var idx = gridPOPC.getCellValue(0, "PAY_CNT");
            POPC_COPY(idx - 1);

            var store = new EVF.Store();
            if(!store.validate()) { return; }

            store.setGrid([gridMTGL, gridPOPY, gridTEMP]);
            store.getGridData(gridMTGL, "all");
            store.getGridData(gridPOPY, "all");
            store.getGridData(gridTEMP, "all");
            store.doFileUpload(function () {
                store.load(baseUrl + "cpoi0010_doSave.so", function(){
                	
                	var buyerCd = this.getParameter("BUYER_CD");
					var poNum = this.getParameter("PO_NUM");
					var signStatus = this.getParameter("SIGN_STATUS");
					
                    EVF.alert(this.getResponseMessage(), function() {
                    	var param = {
    							'BUYER_CD' : buyerCd,
    							'PO_NUM' : poNum
    						}; 
                    	
                    	/** 21.01.13 농협중앙회 요청 
                		 *  기존에는 저장이후 팝업 close => close 하지 않고 바로 결재상신 할 수 있도록 화면 재조회, 결재상신 이후에는 화면 close
                		 */
                        if(opener) {
                       		opener.doSearch();
                        	if (signStatus === 'P') {
                        		doClose();
                        	} else {
                                window.location.href = '/nhepro/CPOI/CPOI0010/view.so?' + $.param(param);
                        	}
                        } else {
                        	if (signStatus === 'P') {
                        		document.location.href = "/nhepro/CPOI/CPOI0010/view.so?";
                        	} else {
                        		document.location.href = '/nhepro/CPOI/CPOI0010/view.so?' + $.param(param);
                        	}
                        }
                    });
                });
            });
        }
		
		function doCopy() {
			var popcAllRowId = gridPOPC.getAllRowId();
			var py_buyer_dept_nm = "";
			var popcList = [];
			
			for(var i in popcAllRowId) {
				var popcRowIdx = popcAllRowId[i];
				
				// 지불정보의 지불고객사를 설정하기 위해 고객사별 지불고객사 정보를 취합
				if (gridPOPC.getRowCount() > 1) {
					if(popcAllRowId.length == ((i * 1) + 1)) {
						py_buyer_dept_nm += gridPOPC.getCellValue(popcRowIdx, "PY_BUYER_DEPT_NM");
					}
					else {
						py_buyer_dept_nm += gridPOPC.getCellValue(popcRowIdx, "PY_BUYER_DEPT_NM") + ", ";
					}
				}
				else {
					py_buyer_dept_nm += gridPOPC.getCellValue(popcRowIdx, "PY_BUYER_DEPT_NM");
				}
				
				// 고객사별 지불고객사 정보를 일괄 적용하기 위해 추출
				popcList.push({
					"PY_BUYER_CD": gridPOPC.getCellValue(popcRowIdx, "PY_BUYER_CD"),
					"PY_BUYER_NM": gridPOPC.getCellValue(popcRowIdx, "PY_BUYER_NM"),
					"PY_DEPT_CD": gridPOPC.getCellValue(popcRowIdx, "PY_DEPT_CD"),
					"PY_DEPT_NM": gridPOPC.getCellValue(popcRowIdx, "PY_DEPT_NM"),
					"PY_BUYER_DEPT_NM": gridPOPC.getCellValue(popcRowIdx, "PY_BUYER_DEPT_NM"),
				})
			}
			
			// 지불정보 가져오기
			var popyAllRowId = gridPOPY.getAllRowId();
			for(var j in popyAllRowId) {
				var popyRowIdx = popyAllRowId[j];
				
				gridPOPY._gvo.setCurrent({itemIndex:popyRowIdx});
				// 지불정보의 값에 맞춰 고객사별 지불고객사 정보에 주입
				gridPOPC.delAllRow();
				for(var n in popcList) {
					popcList[n]["PAY_CNT"] = gridPOPY.getCellValue(popyRowIdx, "PAY_CNT");
					popcList[n]["PAY_CNT_NM"] = gridPOPY.getCellValue(popyRowIdx, "PAY_CNT_NM");
					popcList[n]["PAY_CNT_TYPE"] = gridPOPY.getCellValue(popyRowIdx, "PAY_CNT_TYPE");
					popcList[n]["PR_BUYER_CD"] = gridPOPY.getCellValue(popyRowIdx, "PR_BUYER_CD");
					popcList[n]["PR_DEPT_CD"] = gridPOPY.getCellValue(popyRowIdx, "PR_DEPT_CD");

					gridPOPC.addRow(popcList[n]);
					//ECPC_COPY(ecpyRowIdx);
					POPC_COPY(popyRowIdx);
				}
				gridPOPY.setCellValue(popyRowIdx, "PY_BUYER_NM", py_buyer_dept_nm);
			}
			//ECPY_COPY(gridECCM.getSelRowId()[0]);
			//POPY_COPY(gridECCM.getSelRowId()[0]);
		}
		
		/* function POPC_COPY(rowIdx) {
			var allRowValue = gridECPC.getAllRowValue();
			gridPOPY._gdp.setValue(rowIdx, "PC_INFO", JSON.stringify(allRowValue));
		} */

		function POPY_COPY(rowIdx) {
			var allRowValue = gridPOPY.getAllRowValue();
			gridECCM._gdp.setValue(rowIdx, "PY_INFO", JSON.stringify(allRowValue));
		}
		
        function doDelete() {
        	
        	if( EVF.V("PO_CREATE_TYPE") != "MANUAL" ) {
        		return EVF.alert("${CPOI0010_021}");
        	}
        	
            EVF.confirm("${msg.M0013}", function () {
                var store = new EVF.Store();
                store.load(baseUrl + "cpoi0010_doDelete.so", function() {
                    EVF.alert(this.getResponseMessage(), function () {
                        doClose();
                    });
                    opener.doSearch();
                });
            });
        }
        

        function doClose() {
            EVF.closeWindow();
        }

    </script>

    <e:window id="CPOI0010" onReady="init" initData="${initData}" title="${formData.SCREEN_NAME}" breadCrumbs="${breadCrumb }">
        <e:buttonBar width="100%" align="right" title="${CPOI0010_003}">
            <e:button id="doSave" name="doSave" label="${doSave_N}" onClick="doSave" disabled="${doSave_D}" visible="${doSave_V}" data="T"/>
            <e:button id="doApprovalRequest" name="doApprovalRequest" label="${doApprovalRequest_N}" onClick="doSave" disabled="${doApprovalRequest_D}" visible="${doApprovalRequest_V}" data="P"/>
            <e:button id="doDelete" name="doDelete" label="${doDelete_N}" onClick="doDelete" disabled="${doDelete_D}" visible="${doDelete_V}"/>
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
	    <!-- 2021.01.13 추가 : 수기계약발주이면서 품의를 타고 들어온 경우 체크하기 위해 -->
		<e:inputHidden id="EXEC_NUM" name="EXEC_NUM" value="${formData.EXEC_NUM}"/>
		<!-- 2021.08.03 추가 : 지불정보 클릭시 지불차수(pay_cnt) -->
		<e:inputHidden id="SEL_PAY_CNT" name="SEL_PAY_CNT"/>
        
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
                    <e:select id="CUR" name="CUR" value="${formData.CUR}" options="${curOptions}" onChange="onChangeCUR" width="${form_CUR_W}" disabled="${form_CUR_D}" readOnly="${form_CUR_RO}" required="${form_CUR_R}" placeHolder="선택" maskType="${form_CUR_MT}" />
                    <e:select id="VAT_TYPE" name="VAT_TYPE" value="${formData.VAT_TYPE}" options="${vatTypeOptions}" onChange="onChangeVAT_TYPE" width="${form_VAT_TYPE_W}" disabled="${form_VAT_TYPE_D}" readOnly="${form_VAT_TYPE_RO}" required="${form_VAT_TYPE_R}" placeHolder="선택" maskType="${form_VAT_TYPE_MT}" />
                </e:field>
            </e:row>

            <e:row>
                <e:label for="DELIVERY_TYPE" title="${form_DELIVERY_TYPE_N}"/>
                <e:field>
                    <e:select id="DELIVERY_TYPE" name="DELIVERY_TYPE" value="${formData.DELIVERY_TYPE}" options="${deliveryTypeOptions}" onChange="onChangeDELIVERY_TYPE" width="${form_DELIVERY_TYPE_W}" disabled="${form_DELIVERY_TYPE_D}" readOnly="${form_DELIVERY_TYPE_RO}" required="${form_DELIVERY_TYPE_R}" placeHolder="선택" maskType="${form_DELIVERY_TYPE_MT}" />
                </e:field>
                <e:label for="PAY_TYPE" title="${form_PAY_TYPE_N}"/>
                <e:field>
                    <e:select id="PAY_TYPE" name="PAY_TYPE" value="${formData.PAY_TYPE}" options="${payTypeOptions}" onChange="onChangePAY_TYPE" width="${form_PAY_TYPE_W}" disabled="${form_PAY_TYPE_D}" readOnly="${form_PAY_TYPE_RO}" required="${form_PAY_TYPE_R}" placeHolder="선택" maskType="${form_PAY_TYPE_MT}" />
                </e:field>
            </e:row>

            <e:row>
                <e:label for="CTRL_USER_ID" title="${form_CTRL_USER_ID_N}" />
                <e:field>
                	<e:search id="CTRL_USER_ID" name="CTRL_USER_ID" value="${formData.CTRL_USER_ID}" width="40%" maxLength="${form_CTRL_USER_ID_M}" onIconClick="onIconClickCTRL_USER_ID" disabled="${form_CTRL_USER_ID_D}" readOnly="${form_CTRL_USER_ID_RO}" required="${form_CTRL_USER_ID_R}" maskType="${form_CTRL_USER_ID_MT}" />
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
                    <e:richTextEditor id="RMK_TEXT" name="RMK_TEXT" value="${formData.RMK_TEXT}" width="${form_RMK_TEXT_NUM_W}" height="400px" disabled="${form_RMK_TEXT_NUM_D}" readOnly="${form_RMK_TEXT_NUM_RO}" required="${form_RMK_TEXT_NUM_R}" style="${imeMode}"/>
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
        <e:buttonBar width="100%" align="right" title="${CPOI0010_004}">
        	<c:if test="${!param.detailView and formData.PO_CREATE_TYPE eq 'MANUAL'}">
	        	<e:text style="color: blue;font-weight: bold;">■ 관련 계약번호 : </e:text>
				<e:inputHidden id="CONT_CNT" name="CONT_CNT" />
				<e:search id="CONT_NUM" name="CONT_NUM" value="" width="140" maxLength="${for_CONT_NUM_M}" onIconClick="doSearchCont" disabled="${form_CONT_NUM_D}" readOnly="${form_CONT_NUM_RO}" required="${form_CONT_NUM_R}" />
				<e:button id="doApplyCont" name="doApplyCont" label="${doApplyCont_N}" onClick="doApplyCont" disabled="${doApplyCont_D}" visible="${doApplyCont_V}" align="left" style="padding-left: 3px;"/>
			</c:if>
            <e:button id="doSearchItem" name="doSearchItem" label="${doSearchItem_N}" onClick="doSearchItem" disabled="${doSearchItem_D}" visible="${doSearchItem_V}"/>
            <e:button id="doDeleteItem" name="doDeleteItem" label="${doDeleteItem_N}" onClick="doDeleteItem" disabled="${doDeleteItem_D}" visible="${doDeleteItem_V}"/>
        </e:buttonBar>
        <!-- 2021.01.13 : 품의번호가 존재하는 경우 품목정보를 수정할 수 없다. -->
        <e:gridPanel id="gridMTGL" name="gridMTGL" width="100%" height="225px" gridType="${_gridType}" readOnly="${(param.detailView==true)?true:((formData.EXEC_NUM==null)?false:true)}" />

		<e:panel id="panel_01" width="100%">
	        <e:title title="${CPOI0010_005}" />
	        <e:panel width="1%"><e:br/></e:panel>
	
			<%--대금지불정보--%>
	        <e:panel width="99%">
	            <e:searchPanel id="sp2" title="" labelWidth="${labelWidth}" useTitleBar="false" width="100%" columnCount="2" onEnter="" >
	                <e:row>
	                    <e:label for="PAY_TYPE_DUP" title="${form_PAY_TYPE_N}"/>
	                    <e:field>
	                        <e:select id="PAY_TYPE_DUP" name="PAY_TYPE_DUP" value="${formData.PAY_TYPE}" options="${payTypeOptions}" width="${form_PAY_TYPE_W}" disabled="${form_PAY_TYPE_D}" readOnly="true" required="${form_PAY_TYPE_R}" placeHolder="선택" maskType="${form_PAY_TYPE_MT}" />
	                    </e:field>
	                    <e:label for="PAY_CNT" title="${form_PAY_CNT_N}"/>
	                    <e:field>
	                        <e:inputNumber id="PAY_CNT" name="PAY_CNT" value="${formData.PAY_CNT}" onEnter="doApplyPayCnt" width="${form_PAY_CNT_W}" maxValue="${form_PAY_CNT_M}" decimalPlace="${form_PAY_CNT_NF}" disabled="${form_PAY_CNT_D}" readOnly="${form_PAY_CNT_RO}" required="${form_PAY_CNT_R}" onNumberKr="${form_PAY_CNT_KR}" currencyText="${form_PAY_CNT_CT}"/>
	                        <e:text> </e:text>
	                        <e:button id="doApplyPayCnt" name="doApplyPayCnt" label="${doApplyPayCnt_N}" onClick="doApplyPayCnt" disabled="${doApplyPayCnt_D}" visible="${doApplyPayCnt_V}"/>
	                    </e:field>
	                </e:row>
	                <e:row>
	                    <e:label for="CUR_DUP" title="${form_PO_AMT_N}"/>
	                    <e:field>
	                        <e:inputNumber id="PO_AMT_DUP" name="PO_AMT_DUP" value="${formData.PO_AMT}" onChange="onChangePO_AMT" width="${form_PO_AMT_W}" maxValue="${form_PO_AMT_M}" decimalPlace="${form_PO_AMT_NF}" disabled="${form_PO_AMT_D}" readOnly="true" required="${form_PO_AMT_R}" onNumberKr="${form_PO_AMT_KR}" currencyText="${form_PO_AMT_CT}"/>
	                        <e:select id="CUR_DUP" name="CUR_DUP" value="${formData.CUR}" options="${curOptions}" width="${form_CUR_W}" disabled="${form_CUR_D}" readOnly="true" required="${form_CUR_R}" placeHolder="선택" maskType="${form_CUR_MT}" />
	                        <e:select id="VAT_TYPE_DUP" name="VAT_TYPE_DUP" value="${formData.VAT_TYPE}" options="${vatTypeOptions}" width="${form_VAT_TYPE_W}" disabled="${form_VAT_TYPE_D}" readOnly="true" required="${form_VAT_TYPE_R}" placeHolder="선택" maskType="${form_VAT_TYPE_MT}" />
	                    </e:field>
	                    <e:label for="BUYER_DEPT_NM" title="${form_BUYER_DEPT_NM_N}" />
	                    <e:field>
	                        <e:inputText id="BUYER_DEPT_NM" name="BUYER_DEPT_NM" value="${formData.BUYER_DEPT_NM}" width="${form_BUYER_DEPT_NM_W}" maxLength="${form_BUYER_DEPT_NM_M}" disabled="${form_BUYER_DEPT_NM_D}" readOnly="${form_BUYER_DEPT_NM_RO}" required="${form_BUYER_DEPT_NM_R}" style="${imeMode}" maskType="${form_BUYER_DEPT_NM_MT}"/>
	                    </e:field>
	                </e:row>
	            </e:searchPanel>
	
	    		<%--지불정보--%>
	            <e:buttonBar width="100%" align="right" title="${CPOI0010_006}" />
	            <e:gridPanel id="gridPOPY" name="gridPOPY" width="100%" height="225px" gridType="${_gridType}" readOnly="${param.detailView}" />
	
	   			<%--고객사별 지불고객사 정보--%>
	            <e:buttonBar width="100%" align="right" title="${CPOI0010_007}">
					<c:if test="${!param.detailView and formData.PO_CREATE_TYPE eq 'MANUAL'}">
						<e:button id="doCopy" name="doCopy" label="${doCopy_N}" onClick="doCopy" disabled="${doCopy_D}" visible="${doCopy_V}"/>
					</c:if>
				</e:buttonBar>
	            <e:gridPanel id="gridPOPC" name="gridPOPC" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}"/>
	        </e:panel>
		</e:panel>
		
        <e:buttonBar width="100%" align="right">
            <e:button id="doSave2" name="doSave2" label="${doSave_N}" onClick="doSave" disabled="${doSave_D}" visible="${doSave_V}" data="T"/>
            <e:button id="doApprovalRequest2" name="doApprovalRequest2" label="${doApprovalRequest_N}" onClick="doSave" disabled="${doApprovalRequest_D}" visible="${doApprovalRequest_V}" data="P"/>
            <e:button id="doDelete2" name="doDelete2" label="${doDelete_N}" onClick="doDelete" disabled="${doDelete_D}" visible="${doDelete_V}"/>
            <e:button id="doClose2" name="doClose2" label="${doClose_N}" onClick="doClose" disabled="${doClose_D}" visible="${doClose_V}"/>
        </e:buttonBar>
        <e:panel id="panel_hide">
            <e:gridPanel id="gridTEMP" name="gridTEMP" width="" height="" gridType="${_gridType}" readOnly="${param.detailView}"/>
        </e:panel>

		<%-- 결재자 리스트 Include --%>
		<jsp:include page="/WEB-INF/views/nhepro/CWOR/CWOR0013.jsp" flush="true" >
			<jsp:param value="${formData.APP_DOC_NUM}" name="APP_DOC_NUM"/>
			<jsp:param value="${formData.APP_DOC_CNT}" name="APP_DOC_CNT"/>
			<jsp:param value="${formData.BUYER_CD}" name="BUYER_CD"/>
		</jsp:include>
    </e:window>
</e:ui>
