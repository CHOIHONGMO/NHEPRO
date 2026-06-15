<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
    <script type="text/javascript">
        var gridVNSL;
        var gridVNAP;
        var gridATTD;
        var gridVNCM;
        var baseUrl = "/nhepro/SVNR/";

        function init() {
            gridVNSL = EVF.C("gridVNSL");   /*특허 및 취급면허*/

            gridVNSL.setProperty("shrinkToFit", true);
            gridVNSL.setProperty("rowNumbers", ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
            gridVNSL.setProperty("sortable", ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
            gridVNSL.setProperty("panelVisible", ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            gridVNSL.setProperty("enterToNextRow", ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            gridVNSL.setProperty("acceptZero", ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            gridVNSL.setProperty("multiSelect", ${param.detailView == true ? false : multiSelect});					// [선택] 컬럼의 사용여부를 지정한다. [true/false]
            gridVNSL.setProperty("singleSelect", ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]

            gridVNAP = EVF.C("gridVNAP");   /*결제정보*/

            gridVNAP.setProperty("shrinkToFit", true);
            gridVNAP.setProperty("rowNumbers", ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
            gridVNAP.setProperty("sortable", ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
            gridVNAP.setProperty("panelVisible", ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            gridVNAP.setProperty("enterToNextRow", ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            gridVNAP.setProperty("acceptZero", ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            gridVNAP.setProperty("multiSelect", ${param.detailView == true ? false : multiSelect});					// [선택] 컬럼의 사용여부를 지정한다. [true/false]
            gridVNAP.setProperty("singleSelect", ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]

            gridATTD = EVF.C("gridATTD");   /*첨부파일*/

            gridATTD.setProperty("shrinkToFit", true);
            gridATTD.setProperty("rowNumbers", ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
            gridATTD.setProperty("sortable", ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
            gridATTD.setProperty("panelVisible", ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            gridATTD.setProperty("enterToNextRow", ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            gridATTD.setProperty("acceptZero", ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            gridATTD.setProperty("multiSelect", false);					// [선택] 컬럼의 사용여부를 지정한다. [true/false]
            gridATTD.setProperty("singleSelect", ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]

            gridVNCM = EVF.C("gridVNCM");   /*거래희망 고객사*/

            gridVNCM.setProperty("shrinkToFit", true);
            gridVNCM.setProperty("rowNumbers", ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
            gridVNCM.setProperty("sortable", ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
            gridVNCM.setProperty("panelVisible", ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            gridVNCM.setProperty("enterToNextRow", ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            gridVNCM.setProperty("acceptZero", ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            gridVNCM.setProperty("multiSelect", ${param.detailView == true ? false : multiSelect});					// [선택] 컬럼의 사용여부를 지정한다. [true/false]
            gridVNCM.setProperty("singleSelect", ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]

            gridVNSL.cellClickEvent(function(rowIdx, colIdx) {
                var param;
                var ATT_FILE_NUM = gridVNSL.getCellValue(rowIdx, "ATT_FILE_NUM");

                if(colIdx == "ATT_FILE_NUM_CNT") {
                    param = {
                        attFileNum: ATT_FILE_NUM,
                        rowIdx: rowIdx,
                        callBackFunction: "callbackATT_FILE_NUM_CNT",
                        bizType: "AD",
                        detailView: false
                    };
                    everPopup.fileAttachPopup(param);
                }
            });
            
            gridVNAP.cellClickEvent(function(rowIdx, colIdx, value) {
                var param;
                var ATT_FILE_NUM = gridVNAP.getCellValue(rowIdx, "PAY_ATT_FILE_NUM");

                if(colIdx == "PAY_ATT_FILE_NUM_CNT") {
                    param = {
                        attFileNum: ATT_FILE_NUM,
                        rowIdx: rowIdx,
                        callBackFunction: "callbackPAY_ATT_FILE_NUM_CNT",
                        bizType: "AD",
                        detailView: false
                    };
                    everPopup.fileAttachPopup(param);
                }
            });

            gridVNAP.cellChangeEvent(function(rowIdx, colIdx, iRow, iCol, value, oldValue) {
                if(colIdx == "PAY_ACC_NMG_TEL_NUM") {
                    if(!everString.isTel(value)) {
                        EVF.alert("${msg.M0128}", function () {
                            gridVNAP.setCellValue(rowIdx, colIdx, oldValue);
                        });
                    }

                } else if(colIdx == "PAY_ACC_MNG_EMAIL") {
                    if(!everString.isValidEmail(value)) {
                        EVF.alert("${msg.EMAIL_INVALID}", function x() {
                            gridVNAP.setCellValue(rowIdx, colIdx, oldValue);
                        });
                    }
                }
            });

            gridATTD.cellClickEvent(function(rowIdx, colIdx, value) {
                var param;
                var ATT_FILE_NUM = gridATTD.getCellValue(rowIdx, "ATTS_ATT_FILE_NUM");
                var TMPL_FILE_NUM = gridATTD.getCellValue(rowIdx, "TMPL_FILE_NUM");

                if(colIdx == "TMPL_FILE_NUM_CNT") {
                    if(value > 0) {
                        param = {
                            attFileNum: TMPL_FILE_NUM,
                            rowIdx: rowIdx,
                            callBackFunction: "callbackTMPL_FILE_NUM_CNT",
                            bizType: "AD",
                            detailView: true
                        };
                        everPopup.fileAttachPopup(param);
                    }
                } else if(colIdx == "ATTS_ATT_FILE_NUM_CNT") {
                    param = {
                        attFileNum: ATT_FILE_NUM,
                        rowIdx: rowIdx,
                        callBackFunction: "callbackATTS_ATT_FILE_NUM_CNT",
                        bizType: "AD",
                        detailView: false
                    };
                    everPopup.fileAttachPopup(param);
                }
            });

            gridVNCM.cellClickEvent(function(rowIdx, colIdx, value) {
                var CONFIRM_FLAG = gridVNCM.getCellValue(rowIdx, "CONFIRM_FLAG");
                if(CONFIRM_FLAG == "" && colIdx == "BUYER_NM") {
                	var param = {
                            rowIdx: rowIdx,
                            callBackFunction: "callbackBUYER_NM"
                        };
                	everPopup.openCommonPopup(param, "SP0066");
                	/*if(value != "") {
                        EVF.confirm("${SVNR0010_016 }", function () {
                            everPopup.openCommonPopup(param, "SP0066");
                        });
                    } else {
                        everPopup.openCommonPopup(param, "SP0066");
                    }*/
                }
                else if(colIdx == "CONFIRM_REASON") {
                	if( value == "" ) return;
                	var param = {
	                        title: "${SVNR0010_011}",
	                        message: value,
	                        callbackFunction: "",
	                        rowIdx: "",
	                        detailView: true
	                    };
                    everPopup.commonTextInput(param);
                }
                else if(colIdx == "REQ_REASON") {
                	
                	var CONFIRM_FLAG = gridVNCM.getCellValue(rowIdx, "CONFIRM_FLAG");
                	var BUYER_CD = gridVNCM.getCellValue(rowIdx, "BUYER_CD");
                	
                	if(CONFIRM_FLAG == ""){
                		var param = {
    	                        title: "${SVNR0010_015}",
    	                        message: value,
    	                        callbackFunction: "callbackNew_REQ_REASON",
    	                        rowIdx: rowIdx,
    	                        CUST_CD: BUYER_CD,
    	                        detailView: false
    	                    };
                        everPopup.commonTextInput(param);
                		
                	} else {
                		var param = {
    	                        title: "${SVNR0010_015}",
    	                        message: value,
    	                        callbackFunction: "callbackREQ_REASON",
    	                        rowIdx: rowIdx,
    	                        detailView: (CONFIRM_FLAG != 'R')
    	                    };
                        everPopup.commonTextInput(param);
                	}
                }
            });

            gridVNSL.addRowEvent(function() {
            	//21.01.19 realgrid update 이후 [{}] addRow 시 오류로 인해 {}로 변경
                var addParam = {
                };
                gridVNSL.addRow(addParam);
            });

            gridVNSL.delRowEvent(function() {
                if (gridVNSL.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

                var delCnt = 0;
                var rowIds = gridVNSL.getSelRowId();

                for(var i in rowIds) {
                    if(!EVF.isEmpty(gridVNSL.getCellValue(rowIds[i], "SEQ"))) {
                        delCnt++;
                    }
                }

                if(delCnt > 0) {
                	EVF.confirm("${SVNR0010_021}", function () {
	                    var store = new EVF.Store();
	                    store.setGrid([gridVNSL]);
	                    store.getGridData(gridVNSL, "sel");
	                    store.load(baseUrl + "svnr0010_doDeleteVNSL.so", function() {
	                        doSearchVNSL();
	                    });
                	});
                } else {
                    gridVNSL.delRow();
                }
            });

            gridVNAP.addRowEvent(function() {
                var addParam = {
                };
                gridVNAP.addRow(addParam);
            });

            gridVNAP.delRowEvent(function() {
                if (gridVNAP.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

                var totalCnt = gridVNAP.getRowCount();
                var delCnt = 0;
                var rowIds = gridVNAP.getSelRowId();
                for(var i in rowIds) {
                    if(!EVF.isEmpty(gridVNAP.getCellValue(rowIds[i], "SEQ"))) {
                        delCnt++;
                    }
                }
                
                if(totalCnt > 0 && totalCnt == delCnt) {
                	return EVF.alert("${SVNR0010_020}");
                }

                if(delCnt > 0) {
                	EVF.confirm("${SVNR0010_021}", function () {
	                    var store = new EVF.Store();
	                    store.setGrid([gridVNAP]);
	                    store.getGridData(gridVNAP, "sel");
	                    store.load(baseUrl + "svnr0010_doDeleteVNAP.so", function() {
	                        doSearchVNAP();
	                    });
                	});
                } else {
                    gridVNAP.delRow();
                }
            });

            gridVNCM.addRowEvent(function() {
            	//21.01.19 realgrid update 이후 [{}] addRow 시 오류로 인해 {}로 변경
            	var addParam = {
                };
                gridVNCM.addRow(addParam);
            });

            gridVNCM.delRowEvent(function() {
                if (gridVNCM.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

                var delCnt = 0;
                var rowIds = gridVNCM.getSelRowId();
                for(var i in rowIds) {
                	// 가입요청인 경우에만 삭제할 수 있음
                    if(gridVNCM.getCellValue(rowIds[i], "CONFIRM_FLAG") !== "J") {
                    	return EVF.alert("${SVNR0010_016}");
                    }
                    if(!EVF.isEmpty(gridVNCM.getCellValue(rowIds[i], "BUYER_CD"))) {
                        delCnt++;
                    }
                }

                if(delCnt > 0) {
                	EVF.confirm("${SVNR0010_021}", function () {
	                    var store = new EVF.Store();
	                    store.setGrid([gridVNCM]);
	                    store.getGridData(gridVNCM, "sel");
	                    store.load(baseUrl + "svnr0010_doDeleteVNCM.so", function () {
	                        doSearchVNCM();
	                        doSearchATTD();
	                    });
                	});
                } else {
                    gridVNCM.delRow();
                }
            });

            doSearchVNSL(); // 특허 및 취급면허
            doSearchVNAP(); // 결제정보
            doSearchATTD(); // 첨부파일
            doSearchVNCM(); // 거래희망 고객사

            onChangeRELAT_YN();
            onChangeEXEC();

            $("#sp3").hide();
            gridATTD.hideCol("TMPL_FILE_NUM_CNT", true);
        }

        function callbackATT_FILE_NUM_CNT(rowIdx, fileId, fileCnt) {
            gridVNSL.setCellValue(rowIdx, "ATT_FILE_NUM_CNT", fileCnt);
            gridVNSL.setCellValue(rowIdx, "ATT_FILE_NUM", fileId);
        }
        
        function callbackPAY_ATT_FILE_NUM_CNT(rowIdx, fileId, fileCnt) {
            gridVNAP.setCellValue(rowIdx, "PAY_ATT_FILE_NUM_CNT", fileCnt);
            gridVNAP.setCellValue(rowIdx, "PAY_ATT_FILE_NUM", fileId);
        }

        function callbackATTS_ATT_FILE_NUM_CNT(rowIdx, fileId, fileCnt) {
            gridATTD.setCellValue(rowIdx, "ATTS_ATT_FILE_NUM_CNT", fileCnt);
            gridATTD.setCellValue(rowIdx, "ATTS_ATT_FILE_NUM", fileId);
        }
		
        // 2021.03.25 신규 거래희망 고객사 가입요청 시 가입요청 사유 입력 추가
        // 거래희망 고객사에 거래요청하기
        function callbackBUYER_NM(data) {
        	
        	if( data.CUST_CD == "" ) return;
        	
        	// 요청고객사 중복체크
            var allRowId = gridVNCM.getAllRowId();
            for(var i in allRowId) {
                var rowIdx = allRowId[i];
                var BUYER_CD = gridVNCM.getCellValue(rowIdx, "BUYER_CD");
                if( BUYER_CD == data.CUST_CD ) {
                    return EVF.alert("${SVNR0010_017}");
                }
            }
            
            gridVNCM.setCellValue(data.rowIdx, "BUYER_CD", data.CUST_CD);
            gridVNCM.setCellValue(data.rowIdx, "BUYER_NM", data.CUST_NM);
            gridVNCM.setCellValue(data.rowIdx, "SEQ", gridVNCM.getRowCount() + 1);
            
            var param = {
                    title: "${SVNR0010_015}",
                    message: EVF.V("REQ_REASON"),
                    callbackFunction: "callbackNew_REQ_REASON",
                    rowIdx: data.rowIdx,
                    CUST_CD: data.CUST_CD,
                    detailView: false
                };
            everPopup.commonTextInput(param);
        	
           	/* EVF.confirm("${SVNR0010_022}", function () {
                gridVNCM.setCellValue(data.rowIdx, "BUYER_CD", data.CUST_CD);
                gridVNCM.setCellValue(data.rowIdx, "BUYER_NM", data.CUST_NM);
                gridVNCM.setCellValue(data.rowIdx, "SEQ", gridVNCM.getRowCount() + 1);

                var VNCM_BUYER_CD = data.CUST_CD;
                var store = new EVF.Store();
                store.setParameter("VNCM_BUYER_CD", VNCM_BUYER_CD);
                store.setParameter("VNCM_DEPT_CD", "O");
                store.setParameter("DEL_BUYER_CD", gridVNCM.getCellValue(data.rowIdx, "ORG_BUYER_CD")); // 기존 고객사를 변경하는 경우 변경전 고객사 삭제
                store.setParameter("DEL_DEPT_CD", "O");
                store.load(baseUrl + "svnr0010_doInsertVNCM.so", function () {
                	EVF.alert(this.getResponseMessage(), function () {
                		doSearchVNCM();
                	});
                });
           	}); */
        }
		
        function callbackREQ_REASON(data) {
        	gridVNCM.setCellValue(data.rowIdx, "REQ_REASON", data.message);
        }
        
        function callbackNew_REQ_REASON(data) {
        	
        	if(data.message == "") {
                EVF.alert("가입요청 사유를 입력해주세요");
            } else {
        		
	            gridVNCM.setCellValue(data.rowIdx, "REQ_REASON", data.message);
	            
	            EVF.confirm("${SVNR0010_022}", function () {
	            	
	            	/* var REQ_REASON = gridVNCM.getCellValue(data.rowIdx, "REQ_REASON");
	                if( REQ_REASON == "" ) {
	                	return EVF.alert("가입요청 사유를 입력해 주세요.");
	                } */
	
	                var VNCM_BUYER_CD = data.CUST_CD;
	                var store = new EVF.Store();
	                store.setParameter("VNCM_BUYER_CD", VNCM_BUYER_CD);
	                store.setParameter("VNCM_DEPT_CD", "O");
	                store.setParameter("DEL_BUYER_CD", gridVNCM.getCellValue(data.rowIdx, "ORG_BUYER_CD")); // 기존 고객사를 변경하는 경우 변경전 고객사 삭제
	                store.setParameter("DEL_DEPT_CD", "O");
	                store.setParameter("REQ_REASON", gridVNCM.getCellValue(data.rowIdx, "REQ_REASON"));
	                store.load(baseUrl + "svnr0010_doInsertVNCM.so", function () {
	                	EVF.alert(this.getResponseMessage(), function () {
	                		doSearchVNCM();
	                	});
	                });
	           	});
            
            }
        }

        function onChangeRELAT_YN() {
            if(EVF.V("RELAT_YN") == "0") {
                EVF.C("CORP_TYPE").setRequired(true);
                EVF.C("CORP_TYPE").setReadOnly(false);
            } else {
                EVF.C("CORP_TYPE").setRequired(false);
                EVF.C("CORP_TYPE").setReadOnly(true);
                EVF.V("CORP_TYPE", "");
            }
        }
		
        // 비율 : 소숫점 1자리까지 처리함
        function onChangeEXEC() {
        	
        	var totFundAmt = Number(EVF.V("TOT_FUND_AMT"));
		    var totLiabAmt = Number(EVF.V("TOT_LIAB_AMT"));
		    var currentAssetLiabilityAmount = Number(EVF.V("CURRENT_ASSET_LIABILITY_AMOUNT"));
		    var currentAssetAmount = Number(EVF.V("CURRENT_ASSET_AMOUNT"));
		    
		    var totCapitalAmt = totFundAmt + totLiabAmt;
            EVF.V("OWNER_CAPITAL_AMOUNT", totCapitalAmt);
            
         	// 2021.06.02 부채비율 계산방식 변경 
		    // 부채비율 = (총부채 / 총자산) * 100 : 소숫점 1자리(변경 전 방식)
		    // 부채비율 = (총부채 / 총자본) * 100 : 소숫점 1자리(변경 후 방식)
            if( totFundAmt != 0 ) {
                EVF.V("TOTAL_LIABILITY_RATE", (Math.floor((totLiabAmt / totFundAmt) * 1000)) / 10);
            } else {
                EVF.V("TOTAL_LIABILITY_RATE", 0);
            }

            if( currentAssetAmount > 0 ) {
                EVF.V("CURRENT_ASSET_LIABILITY_RATE", (Math.floor((currentAssetAmount / currentAssetLiabilityAmount) * 1000)) / 10);
            } else {
                EVF.V("CURRENT_ASSET_LIABILITY_RATE", 0);
            }
        }

        function onChangeCHECK() {
            var C = this;
            var id = C.getID();
            var value = C.getValue();
            var msg = "";

            if(id == "TEL_NO" || id == "FAX_NO" || id == "CELL_NUM") {
                if(!everString.isTel(value)) {
                    msg = "${msg.M0128}";
                }
            } else if(id == "EMAIL") {
                if(!everString.isValidEmail(value)) {
                    msg = "${msg.EMAIL_INVALID}";
                }
            }

            if(msg != "") {
                EVF.alert(msg, function () {
                    C.setValue("");
                    C.setFocus();
                });
            }
        }
		
        function onIconClickHQ_ZIP_CD() {
            var url = "/common/code/BADV_020/view.so";
            var param = {
                callBackFunction: "callbackHQ_ZIP_CD",
                modalYn: false
            };
            everPopup.openWindowPopup(url, 700, 600, param, "searchZip");
        }

        function callbackHQ_ZIP_CD(data) {
            if (data.ZIP_CD != "") {
                EVF.V("HQ_ZIP_CD", data.ZIP_CD_5);
                EVF.V("HQ_ADDR_1", data.ADDR);
            }
        }
		
        // 2021.04.12 재무정보 첨부파일 오류 수정 
        function doAttFIleNum() {
            var param = {
            	detailView: false,
                attFileNum: EVF.V("VNFI_ATT_FILE_NUM"),
                callBackFunction: "doAttFIleCallback",
                bizType: "AD",
                fileExtension: '*'
            };
            everPopup.fileAttachPopup(param);
        }
		
        function doAttFIleCallback(rowIdx, fileId, fileCnt) {
        	EVF.V("VNFI_ATT_FILE_NM", fileCnt);
        	EVF.V("VNFI_ATT_FILE_NUM", fileId);
		}
        
     	// 2021.04.12 관리정보 첨부파일 오류 수정 
        function doEvAttFIleNum() {
            var param = {
                detailView: false,
                attFileNum: EVF.V("EV_ATT_FILE_NUM"),
                callBackFunction: "doEvAttFIleCallback",
                bizType: "AD",
                fileExtension: '*'
            };
            everPopup.fileAttachPopup(param);
        }
        
        function doEvAttFIleCallback(rowIdx, fileId, fileCnt) {
        	EVF.V("EV_ATT_FILE_NM", fileCnt);
        	EVF.V("EV_ATT_FILE_NUM", fileId);
		}

        function doSearchVNSL() {
            var store = new EVF.Store();
            store.setGrid([gridVNSL]);
            store.load(baseUrl + "svnr0010_doSearchVNSL.so", function() {
                if(gridVNSL.getRowCount() > 0) {
                    gridVNSL.setColIconify("ATT_FILE_NUM_CNT", "ATT_FILE_NUM_CNT", "file", false);
                }
            });
        }

        function doSearchVNAP() {
            var store = new EVF.Store();
            store.setGrid([gridVNAP]);
            store.load(baseUrl + "svnr0010_doSearchVNAP.so", function() {
                if(gridVNAP.getRowCount() > 0) {
                	gridVNAP.setColIconify("PAY_ATT_FILE_NUM_CNT", "PAY_ATT_FILE_NUM_CNT", "file", false);
                }
            });
        }

        function doSearchATTD() {
            var store = new EVF.Store();
            store.setGrid([gridATTD]);
            store.load(baseUrl + "svnr0010_doSearchATTD.so", function() {
                if(gridATTD.getRowCount() > 0) {
                    gridATTD.setColIconify("TMPL_FILE_NUM_CNT", "TMPL_FILE_NUM_CNT", "file", false);
					
                    var regType = EVF.V("REG_TYPE");
                    
                    var allRowId = gridATTD.getAllRowId();
                    for(var i in allRowId) {
                        var rowIdx = allRowId[i];
                        
                        if(regType == "C" || regType == "P") {
                            if(gridATTD.getCellValue(rowIdx, "TMPL_FILE_NM") == "법인등기부등본" || gridATTD.getCellValue(rowIdx, "TMPL_FILE_NM") == "법인인감증명") {
                            	gridATTD.setCellValue(rowIdx, "REQUIRED_FLAG", "1");
                            	gridATTD.setCellValue(rowIdx, "REQUIRED_FLAG_NM", "Y");
                            } 
                        } else {
                        	if(gridATTD.getCellValue(rowIdx, "TMPL_FILE_NM") == "법인등기부등본" || gridATTD.getCellValue(rowIdx, "TMPL_FILE_NM") == "법인인감증명") {
                        		gridATTD.setCellValue(rowIdx, "REQUIRED_FLAG", "0");
                        		gridATTD.setCellValue(rowIdx, "REQUIRED_FLAG_NM", "N");
                            } 
                        }
                        
                        var requiredFlag = gridATTD.getCellValue(rowIdx, "REQUIRED_FLAG");

                        if(requiredFlag == "1") {
                            gridATTD.setCellRequired(rowIdx, "VALID_START_DATE", true);
                            gridATTD.setCellRequired(rowIdx, "VALID_END_DATE", true);
                            gridATTD.setCellRequired(rowIdx, "ATTS_ATT_FILE_NUM_CNT", true);
                        }
                    }
                }
            });
        }

        function doSearchVNCM() {
            var store = new EVF.Store();
            store.setGrid([gridVNCM]);
            store.load(baseUrl + "svnr0010_doSearchVNCM.so", function() {
                gridVNCM.setColIconify("CONFIRM_REASON", "CONFIRM_REASON", "comment", false);
                var allRowId = gridVNCM.getAllRowId();
                for(var i in allRowId) {
                    var rowIdx = allRowId[i];
                    //if("" == gridVNCM.getCellValue(rowIdx, "REQ_REASON")) {
                    //    gridVNCM.checkRow(rowIdx, true);
                    //}
                    if("E" == gridVNCM.getCellValue(rowIdx, "CONFIRM_FLAG")) {
                        gridVNCM.setCheckable(rowIdx, false);
                    }
                }
            });
        }

        function doUpdate() {
            var store = new EVF.Store();
            if(!store.validate()) return;

            if (!gridVNSL.validate().flag) { return EVF.alert(gridVNSL.validate().msg); }
            if (!gridVNAP.validate().flag) { return EVF.alert(gridVNAP.validate().msg); }
            if (!gridATTD.validate().flag) { return EVF.alert(gridATTD.validate().msg); }
            if (!gridVNCM.validate().flag) { return EVF.alert(gridVNCM.validate().msg); }
            
          	//2021.03.22 거래희망 고객사 재요청 시 요청 사유 저장 오류로 인한 체크로직변경
            var selRowId = gridVNCM.getSelRowId();
            for(var i in selRowId) {
                var rowIdx = selRowId[i];
                if(gridVNCM.getCellValue(rowIdx, "CONFIRM_FLAG") == "R") {
	                if(gridVNCM.getCellValue(rowIdx, "REQ_REASON") == "") {
	                    return EVF.alert("거래희망 고객사 반려 건 재 가입요청 시 재요청 사유를 입력해주세요.");
	                }
                }
            }
            
            var RowId = gridVNAP.getSelRowId();
            for(var i in RowId) {
                var rowIdx = RowId[i];
                if(gridVNAP.getCellValue(rowIdx, "PAY_ATT_FILE_NUM_CNT") == "" || gridVNAP.getCellValue(rowIdx, "PAY_ATT_FILE_NUM_CNT") == 0) {
                    return EVF.alert("결제정보 첨부파일은 필수입력 항목입니다.");
                }
            }
            
            EVF.confirm("${msg.M0021 }", function () {
                store.doFileUpload(function () {
                    store.setGrid([gridVNSL, gridVNAP, gridATTD, gridVNCM]);
                    store.getGridData(gridVNSL, "sel");
                    store.getGridData(gridVNAP, "sel");
                    store.getGridData(gridATTD, "sel");
                    store.getGridData(gridVNCM, "sel");
                    store.load(baseUrl + "svnr0010_doUpdate.so", function () {
                        var vendorCd = this.getParameter("VENDOR_CD");

                        EVF.alert(this.getResponseMessage(), function() {
                            location.href = baseUrl + "SVNR0010/view.so?VENDOR_CD=" + vendorCd + "&detailView=false";
                        });
                    });
                });
            });
        }

        function doUpdateReq() {
            var store = new EVF.Store();
            
            if(gridVNCM.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
			
            //2021.03.22 거래희망 고객사 재요청 시 요청 사유 저장 오류로 인한 체크로직변경
            var selRowId = gridVNCM.getSelRowId();
            for(var i in selRowId) {
                var rowIdx = selRowId[i];
                if(gridVNCM.getCellValue(rowIdx, "CONFIRM_FLAG") != "R") {
                    return EVF.alert("${SVNR0010_018}");
                }
                
                if(gridVNCM.getCellValue(rowIdx, "REQ_REASON") == "") {
                    return EVF.alert("거래희망 고객사 반려 건 재가입요청 시 재요청 사유를 입력해주세요.");
                }
            }
            
            if(!gridVNCM.validate().flag) { return EVF.alert(gridVNCM.validate().msg); }

            EVF.confirm("${SVNR0010_019 }", function () {
                store.doFileUpload(function () {
                    store.setGrid([gridVNCM]);
                    store.getGridData(gridVNCM, "sel");
                    store.load(baseUrl + "svnr0010_doUpdateReq.so", function () {
                        EVF.alert(this.getResponseMessage());
                        doSearchVNCM();
                    });
                });
            });
        }
        
        
        function checkCompanyRegNo(){
			if( !isCompanyRegNo(EVF.V("COMPANY_REG_NO")) ) {
				EVF.alert("${msg.M0174}");
				EVF.V("COMPANY_REG_NO", "");
				EVF.C('COMPANY_REG_NO').setFocus();
			}
		}
        
     	//2022.01.10 법인등록번호 자리수 및 유효성 체크
        function isCompanyRegNo(companyRegNo) {

			var as_Biz_no= String(companyRegNo);
			var isNum = true;
			var I_TEMP_SUM = 0 ;
			var I_TEMP = 0;
			var S_TEMP;
			var I_CHK_DIGIT = 0;

			if(companyRegNo.length != 13) { return false; }

			for(index01 = 1; index01 < 13; index01++) {
				var i = index01 % 2;
				var j = 0;

				if(i == 1) j = 1;
				else if( i == 0) j = 2;

				I_TEMP_SUM = I_TEMP_SUM + parseInt(as_Biz_no.substring(index01-1, index01),10) * j;
			}

			I_CHK_DIGIT= I_TEMP_SUM%10 ;
			if(I_CHK_DIGIT != 0 ) I_CHK_DIGIT = 10 - I_CHK_DIGIT;

			if (as_Biz_no.substring(12,13) != String(I_CHK_DIGIT)) return false;
			return true ;
		}

    </script>

    <e:window id="SVNR0010" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">
        <e:inputHidden id="REQ_REASON" name="REQ_REASON"/>
        
        <e:buttonBar width="100%" align="right" title="${SVNR0010_001}">
            <e:button id="doUpdate" name="doUpdate" label="${doUpdate_N}" onClick="doUpdate" disabled="${doUpdate_D}" visible="${doUpdate_V}"/>
        </e:buttonBar>

        <e:searchPanel id="sp" title="" labelWidth="${labelWidth}" useTitleBar="false" width="100%" columnCount="3">
            <e:inputHidden id="CONFIRM_REASON" name="CONFIRM_REASON"/>

            <e:row>
                <e:label for="VENDOR_CD" title="${form_VENDOR_CD_N}" />
                <e:field>
                    <e:inputText id="VENDOR_CD" name="VENDOR_CD" value="${formData.VENDOR_CD}" width="${form_VENDOR_CD_W}" maxLength="${form_VENDOR_CD_M}" disabled="${form_VENDOR_CD_D}" readOnly="${form_VENDOR_CD_RO}" required="${form_VENDOR_CD_R}" style="${imeMode}" maskType="${form_VENDOR_CD_MT}"/>
                </e:field>
                <e:label for="VENDOR_NM" title="${form_VENDOR_NM_N}" />
                <e:field>
                    <e:inputText id="VENDOR_NM" name="VENDOR_NM" value="${formData.VENDOR_NM}" width="${form_VENDOR_NM_W}" maxLength="${form_VENDOR_NM_M}" disabled="${form_VENDOR_NM_D}" readOnly="${form_VENDOR_NM_RO}" required="${form_VENDOR_NM_R}" style="${imeMode}" maskType="${form_VENDOR_NM_MT}"/>
                </e:field>
                <e:label for="VENDOR_ENG_NM" title="${form_VENDOR_ENG_NM_N}" />
                <e:field>
                    <e:inputText id="VENDOR_ENG_NM" name="VENDOR_ENG_NM" value="${formData.VENDOR_ENG_NM}" width="${form_VENDOR_ENG_NM_W}" maxLength="${form_VENDOR_ENG_NM_M}" disabled="${form_VENDOR_ENG_NM_D}" readOnly="${form_VENDOR_ENG_NM_RO}" required="${form_VENDOR_ENG_NM_R}" style="${imeMode}" maskType="${form_VENDOR_ENG_NM_MT}"/>
                </e:field>
            </e:row>

            <e:row>
                <e:label for="REG_TYPE" title="${form_REG_TYPE_N}"/>
                <e:field>
                    <e:select id="REG_TYPE" name="REG_TYPE" value="${formData.REG_TYPE}" options="${regTypeOptions}" width="${form_REG_TYPE_W}" disabled="${form_REG_TYPE_D}" readOnly="${form_REG_TYPE_RO}" required="${form_REG_TYPE_R}" placeHolder="" usePlaceHolder="false" maskType="${form_REG_TYPE_MT}" />
                </e:field>
                <e:label for="RELAT_YN" title="${form_RELAT_YN_N}"/>
                <e:field>
                    <e:select id="RELAT_YN" name="RELAT_YN" value="${formData.RELAT_YN}" options="${relatYnOptions}" onChange="onChangeRELAT_YN" width="${form_RELAT_YN_W}" disabled="${form_RELAT_YN_D}" readOnly="${form_RELAT_YN_RO}" required="${form_RELAT_YN_R}" placeHolder="" usePlaceHolder="false" maskType="${form_RELAT_YN_MT}" />
                </e:field>
                <e:label for="CORP_TYPE" title="${form_CORP_TYPE_N}"/>
                <e:field>
                    <e:select id="CORP_TYPE" name="CORP_TYPE" value="${formData.CORP_TYPE}" options="${corpTypeOptions}" width="${form_CORP_TYPE_W}" disabled="${form_CORP_TYPE_D}" readOnly="${form_CORP_TYPE_RO}" required="${form_CORP_TYPE_R}" placeHolder="" maskType="${form_CORP_TYPE_MT}" />
                </e:field>
            </e:row>

            <e:row>
                <e:label for="IRS_NO" title="${form_IRS_NO_N}" />
                <e:field>
                    <e:inputText id="IRS_NO" name="IRS_NO" value="${formData.IRS_NO}" width="${form_IRS_NO_W}" maxLength="${form_IRS_NO_M}" disabled="${form_IRS_NO_D}" readOnly="${form_IRS_NO_RO}" required="${form_IRS_NO_R}" style="${imeMode}" maskType="${form_IRS_NO_MT}"/>
                </e:field>
                <e:label for="COMPANY_REG_NO" title="${form_COMPANY_REG_NO_N}" />
                <e:field>
                    <e:inputText id="COMPANY_REG_NO" name="COMPANY_REG_NO" value="${formData.COMPANY_REG_NO}" width="${form_COMPANY_REG_NO_W}" maxLength="${form_COMPANY_REG_NO_M}" disabled="${form_COMPANY_REG_NO_D}" readOnly="${form_COMPANY_REG_NO_RO}" required="${form_COMPANY_REG_NO_R}" style="${imeMode}" onChange="checkCompanyRegNo" maskType="${form_COMPANY_REG_NO_MT}"/>
                </e:field>
                <e:label for="BUSINESS_SIZE" title="${form_BUSINESS_SIZE_N}"/>
                <e:field>
                    <e:select id="BUSINESS_SIZE" name="BUSINESS_SIZE" value="${formData.BUSINESS_SIZE}" options="${businessSizeOptions}" width="${form_BUSINESS_SIZE_W}" disabled="${form_BUSINESS_SIZE_D}" readOnly="${form_BUSINESS_SIZE_RO}" required="${form_BUSINESS_SIZE_R}" placeHolder="" usePlaceHolder="false" maskType="${form_BUSINESS_SIZE_MT}" />
                </e:field>
            </e:row>

            <e:row>
                <e:label for="HQ_ZIP_CD" title="${form_HQ_ZIP_CD_N}"/>
                <e:field>
                    <e:search id="HQ_ZIP_CD" name="HQ_ZIP_CD" value="${formData.HQ_ZIP_CD}" width="${form_HQ_ZIP_CD_W}" maxLength="${form_HQ_ZIP_CD_M}" onIconClick="onIconClickHQ_ZIP_CD" disabled="${form_HQ_ZIP_CD_D}" readOnly="${form_HQ_ZIP_CD_RO}" required="${form_HQ_ZIP_CD_R}" maskType="${form_HQ_ZIP_CD_MT}" />
                </e:field>
                <e:label for="HQ_ADDR_1" title="${form_HQ_ADDR_1_N}" />
                <e:field colSpan="3">
                    <e:inputText id="HQ_ADDR_1" name="HQ_ADDR_1" value="${formData.HQ_ADDR_1}" width="${form_HQ_ADDR_1_W}" maxLength="${form_HQ_ADDR_1_M}" disabled="${form_HQ_ADDR_1_D}" readOnly="${form_HQ_ADDR_1_RO}" required="${form_HQ_ADDR_1_R}" style="${imeMode}" maskType="${form_HQ_ADDR_1_MT}"/>
                </e:field>
            </e:row>

            <e:row>
                <e:label for="CEO_USER_NM" title="${form_CEO_USER_NM_N}" />
                <e:field>
                    <e:inputText id="CEO_USER_NM" name="CEO_USER_NM" value="${formData.CEO_USER_NM}" width="${form_CEO_USER_NM_W}" maxLength="${form_CEO_USER_NM_M}" disabled="${form_CEO_USER_NM_D}" readOnly="${form_CEO_USER_NM_RO}" required="${form_CEO_USER_NM_R}" style="${imeMode}" maskType="${form_CEO_USER_NM_MT}"/>
                </e:field>
                <e:label for="HQ_ADDR_2" title="${form_HQ_ADDR_2_N}" />
                <e:field colSpan="3">
                    <e:inputText id="HQ_ADDR_2" name="HQ_ADDR_2" value="${formData.HQ_ADDR_2}" width="${form_HQ_ADDR_2_W}" maxLength="${form_HQ_ADDR_2_M}" disabled="${form_HQ_ADDR_2_D}" readOnly="${form_HQ_ADDR_2_RO}" required="${form_HQ_ADDR_2_R}" style="${imeMode}" maskType="${form_HQ_ADDR_2_MT}"/>
                </e:field>
            </e:row>

            <e:row>
                <e:label for="BUSINESS_TYPE" title="${form_BUSINESS_TYPE_N}" />
                <e:field>
                    <e:inputText id="BUSINESS_TYPE" name="BUSINESS_TYPE" value="${formData.BUSINESS_TYPE}" width="${form_BUSINESS_TYPE_W}" maxLength="${form_BUSINESS_TYPE_M}" disabled="${form_BUSINESS_TYPE_D}" readOnly="${form_BUSINESS_TYPE_RO}" required="${form_BUSINESS_TYPE_R}" style="${imeMode}" maskType="${form_BUSINESS_TYPE_MT}"/>
                </e:field>
                <e:label for="INDUSTRY_TYPE" title="${form_INDUSTRY_TYPE_N}" />
                <e:field>
                    <e:inputText id="INDUSTRY_TYPE" name="INDUSTRY_TYPE" value="${formData.INDUSTRY_TYPE}" width="${form_INDUSTRY_TYPE_W}" maxLength="${form_INDUSTRY_TYPE_M}" disabled="${form_INDUSTRY_TYPE_D}" readOnly="${form_INDUSTRY_TYPE_RO}" required="${form_INDUSTRY_TYPE_R}" style="${imeMode}" maskType="${form_INDUSTRY_TYPE_MT}"/>
                </e:field>
                <e:label for="FOUNDATION_DATE" title="${form_FOUNDATION_DATE_N}"/>
                <e:field>
                    <e:inputDate id="FOUNDATION_DATE" name="FOUNDATION_DATE" value="${formData.FOUNDATION_DATE}" width="${inputDateWidth}" datePicker="true" required="${form_FOUNDATION_DATE_R}" disabled="${form_FOUNDATION_DATE_D}" readOnly="${form_FOUNDATION_DATE_RO}" />
                </e:field>
            </e:row>

            <e:row>
                <e:label for="TEL_NO" title="${form_TEL_NO_N}" />
                <e:field>
                    <e:inputText id="TEL_NO" name="TEL_NO" value="${formData.TEL_NO}" onChange="onChangeCHECK" width="${form_TEL_NO_W}" maxLength="${form_TEL_NO_M}" disabled="${form_TEL_NO_D}" readOnly="${form_TEL_NO_RO}" required="${form_TEL_NO_R}" style="${imeMode}" maskType="${form_TEL_NO_MT}"/>
                </e:field>
                <e:label for="FAX_NO" title="${form_FAX_NO_N}" />
                <e:field>
                    <e:inputText id="FAX_NO" name="FAX_NO" value="${formData.FAX_NO}" onChange="onChangeCHECK" width="${form_FAX_NO_W}" maxLength="${form_FAX_NO_M}" disabled="${form_FAX_NO_D}" readOnly="${form_FAX_NO_RO}" required="${form_FAX_NO_R}" style="${imeMode}" maskType="${form_FAX_NO_MT}"/>
                </e:field>
                <e:label for="EMAIL" title="${form_EMAIL_N}" />
                <e:field>
                    <e:inputText id="EMAIL" name="EMAIL" value="${formData.EMAIL}" onChange="onChangeCHECK" width="${form_EMAIL_W}" maxLength="${form_EMAIL_M}" disabled="${form_EMAIL_D}" readOnly="${form_EMAIL_RO}" required="${form_EMAIL_R}" style="${imeMode}" maskType="${form_EMAIL_MT}"/>
                </e:field>
            </e:row>

            <e:row>
                <e:label for="BUSINESS_REMARK" title="${form_BUSINESS_REMARK_N}"/>
                <e:field colSpan="5">
                    <e:textArea id="BUSINESS_REMARK" name="BUSINESS_REMARK" value="${formData.BUSINESS_REMARK}" height="100px" width="${form_BUSINESS_REMARK_W}" maxLength="${form_BUSINESS_REMARK_M}" disabled="${form_BUSINESS_REMARK_D}" readOnly="${form_BUSINESS_REMARK_RO}" required="${form_BUSINESS_REMARK_R}" />
                </e:field>
            </e:row>

            <e:row>
                <e:label for="REMARK_TEXT" title="${form_REMARK_TEXT_N}"/>
                <e:field colSpan="5">
                    <e:textArea id="REMARK_TEXT" name="REMARK_TEXT" value="${formData.REMARK_TEXT}" height="100px" width="${form_REMARK_TEXT_W}" maxLength="${form_REMARK_TEXT_M}" disabled="${form_REMARK_TEXT_D}" readOnly="${form_REMARK_TEXT_RO}" required="${form_REMARK_TEXT_R}" />
                </e:field>
            </e:row>
        </e:searchPanel>

<%-- 특허 및 취급면허--%>
        <e:panel id="panel" height="25px" width="40%">
            <e:title title="${SVNR0010_002}" depth="1" />
        </e:panel>
        <e:gridPanel id="gridVNSL" name="gridVNSL" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}" />

<%--재무정보--%>
        <e:panel id="panel21" height="25px" width="100%">
            <e:title title="${SVNR0010_006}" depth="1" />
            <span style="position: relative; left: 80px; top: -23px; font-size: 11px; color: #bfbfbf;">${SVNR0010_010}</span>
            <span style="position: relative; top: -18px; font-size: 11px; float: right; font-weight: bold; right: 2px; color: #bfbfbf;">${SVNR0010_007}</span>
        </e:panel>
        <e:searchPanel id="sp21" title="" labelWidth="${labelWidth}" useTitleBar="false" width="100%" columnCount="3">
            <e:row>
                <e:label for="FI_YEAR" title="${form_FI_YEAR_N}"/>
                <e:field>
                    <e:select id="FI_YEAR" name="FI_YEAR" value="${formData.FI_YEAR}" options="${fiYearOptions}" width="${form_FI_YEAR_W}" disabled="${form_FI_YEAR_D}" readOnly="${form_FI_YEAR_RO}" required="${form_FI_YEAR_R}" placeHolder="" maskType="${form_FI_YEAR_MT}" />
                </e:field>
                <e:label for="EVIDENCE_TYPE" title="${form_EVIDENCE_TYPE_N}"/>
                <e:field>
                    <e:select id="EVIDENCE_TYPE" name="EVIDENCE_TYPE" value="${formData.EVIDENCE_TYPE}" options="${evidenceTypeOptions}" width="${form_EVIDENCE_TYPE_W}" disabled="${form_EVIDENCE_TYPE_D}" readOnly="${form_EVIDENCE_TYPE_RO}" required="${form_EVIDENCE_TYPE_R}" placeHolder="" maskType="${form_EVIDENCE_TYPE_MT}" />
                </e:field>

                <e:label for="OWNER_CAPITAL_AMOUNT" title="${form_OWNER_CAPITAL_AMOUNT_N}"/>
                <e:field>
                    <e:inputNumber id="OWNER_CAPITAL_AMOUNT" name="OWNER_CAPITAL_AMOUNT" value="${formData.OWNER_CAPITAL_AMOUNT}" width="${form_OWNER_CAPITAL_AMOUNT_W}" maxValue="${form_OWNER_CAPITAL_AMOUNT_M}" decimalPlace="${form_OWNER_CAPITAL_AMOUNT_NF}" disabled="${form_OWNER_CAPITAL_AMOUNT_D}" readOnly="${form_OWNER_CAPITAL_AMOUNT_RO}" required="${form_OWNER_CAPITAL_AMOUNT_R}" onNumberKr="${form_OWNER_CAPITAL_AMOUNT_KR}" currencyText="${form_OWNER_CAPITAL_AMOUNT_CT}"/>
                </e:field>
            </e:row>

            <e:row>
                <e:label for="TOT_FUND_AMT" title="${form_TOT_FUND_AMT_N}"/>
                <e:field>
                    <e:inputNumber id="TOT_FUND_AMT" name="TOT_FUND_AMT" value="${formData.TOT_FUND_AMT}" onChange="onChangeEXEC" width="${form_TOT_FUND_AMT_W}" maxValue="${form_TOT_FUND_AMT_M}" decimalPlace="${form_TOT_FUND_AMT_NF}" disabled="${form_TOT_FUND_AMT_D}" readOnly="${form_TOT_FUND_AMT_RO}" required="${form_TOT_FUND_AMT_R}" onNumberKr="${form_TOT_FUND_AMT_KR}" currencyText="${form_TOT_FUND_AMT_CT}"/>
                </e:field>
                <e:label for="TOT_LIAB_AMT" title="${form_TOT_LIAB_AMT_N}"/>
                <e:field>
                    <e:inputNumber id="TOT_LIAB_AMT" name="TOT_LIAB_AMT" value="${formData.TOT_LIAB_AMT}" onChange="onChangeEXEC" width="${form_TOT_LIAB_AMT_W}" maxValue="${form_TOT_LIAB_AMT_M}" decimalPlace="${form_TOT_LIAB_AMT_NF}" disabled="${form_TOT_LIAB_AMT_D}" readOnly="${form_TOT_LIAB_AMT_RO}" required="${form_TOT_LIAB_AMT_R}" onNumberKr="${form_TOT_LIAB_AMT_KR}" currencyText="${form_TOT_LIAB_AMT_CT}"/>
                </e:field>
                <e:label for="TOTAL_LIABILITY_RATE" title="${form_TOTAL_LIABILITY_RATE_N}"/>
                <e:field>
                    <e:inputNumber id="TOTAL_LIABILITY_RATE" name="TOTAL_LIABILITY_RATE" value="${formData.TOTAL_LIABILITY_RATE}" width="${form_TOTAL_LIABILITY_RATE_W}" maxValue="${form_TOTAL_LIABILITY_RATE_M}" decimalPlace="${form_TOTAL_LIABILITY_RATE_NF}" disabled="${form_TOTAL_LIABILITY_RATE_D}" readOnly="${form_TOTAL_LIABILITY_RATE_RO}" required="${form_TOTAL_LIABILITY_RATE_R}" onNumberKr="${form_TOTAL_LIABILITY_RATE_KR}" currencyText="${form_TOTAL_LIABILITY_RATE_CT}"/>
                </e:field>
            </e:row>

            <e:row>
                <e:label for="CURRENT_ASSET_AMOUNT" title="${form_CURRENT_ASSET_AMOUNT_N}"/>
                <e:field>
                    <e:inputNumber id="CURRENT_ASSET_AMOUNT" name="CURRENT_ASSET_AMOUNT" value="${formData.CURRENT_ASSET_AMOUNT}" onChange="onChangeEXEC" width="${form_CURRENT_ASSET_AMOUNT_W}" maxValue="${form_CURRENT_ASSET_AMOUNT_M}" decimalPlace="${form_CURRENT_ASSET_AMOUNT_NF}" disabled="${form_CURRENT_ASSET_AMOUNT_D}" readOnly="${form_CURRENT_ASSET_AMOUNT_RO}" required="${form_CURRENT_ASSET_AMOUNT_R}" onNumberKr="${form_CURRENT_ASSET_AMOUNT_KR}" currencyText="${form_CURRENT_ASSET_AMOUNT_CT}"/>
                </e:field>
                <e:label for="CURRENT_ASSET_LIABILITY_AMOUNT" title="${form_CURRENT_ASSET_LIABILITY_AMOUNT_N}"/>
                <e:field>
                    <e:inputNumber id="CURRENT_ASSET_LIABILITY_AMOUNT" name="CURRENT_ASSET_LIABILITY_AMOUNT" value="${formData.CURRENT_ASSET_LIABILITY_AMOUNT}" onChange="onChangeEXEC" width="${form_CURRENT_ASSET_LIABILITY_AMOUNT_W}" maxValue="${form_CURRENT_ASSET_LIABILITY_AMOUNT_M}" decimalPlace="${form_CURRENT_ASSET_LIABILITY_AMOUNT_NF}" disabled="${form_CURRENT_ASSET_LIABILITY_AMOUNT_D}" readOnly="${form_CURRENT_ASSET_LIABILITY_AMOUNT_RO}" required="${form_CURRENT_ASSET_LIABILITY_AMOUNT_R}" onNumberKr="${form_CURRENT_ASSET_LIABILITY_AMOUNT_KR}" currencyText="${form_CURRENT_ASSET_LIABILITY_AMOUNT_CT}"/>
                </e:field>
                <e:label for="CURRENT_ASSET_LIABILITY_RATE" title="${form_CURRENT_ASSET_LIABILITY_RATE_N}"/>
                <e:field>
                    <e:inputNumber id="CURRENT_ASSET_LIABILITY_RATE" name="CURRENT_ASSET_LIABILITY_RATE" value="${formData.CURRENT_ASSET_LIABILITY_RATE}" width="${form_CURRENT_ASSET_LIABILITY_RATE_W}" maxValue="${form_CURRENT_ASSET_LIABILITY_RATE_M}" decimalPlace="${form_CURRENT_ASSET_LIABILITY_RATE_NF}" disabled="${form_CURRENT_ASSET_LIABILITY_RATE_D}" readOnly="${form_CURRENT_ASSET_LIABILITY_RATE_RO}" required="${form_CURRENT_ASSET_LIABILITY_RATE_R}" onNumberKr="${form_CURRENT_ASSET_LIABILITY_RATE_KR}" currencyText="${form_CURRENT_ASSET_LIABILITY_RATE_CT}"/>
                </e:field>
            </e:row>

            <e:row>
                <e:label for="SALES_AMOUNT" title="${form_SALES_AMOUNT_N}"/>
                <e:field>
                    <e:inputNumber id="SALES_AMOUNT" name="SALES_AMOUNT" value="${formData.SALES_AMOUNT}" width="${form_SALES_AMOUNT_W}" maxValue="${form_SALES_AMOUNT_M}" decimalPlace="${form_SALES_AMOUNT_NF}" disabled="${form_SALES_AMOUNT_D}" readOnly="${form_SALES_AMOUNT_RO}" required="${form_SALES_AMOUNT_R}" onNumberKr="${form_SALES_AMOUNT_KR}" currencyText="${form_SALES_AMOUNT_CT}"/>
                </e:field>
                <e:label for="NET_PROFIT_AMOUNT" title="${form_NET_PROFIT_AMOUNT_N}"/>
                <e:field>
                    <e:inputNumber id="NET_PROFIT_AMOUNT" name="NET_PROFIT_AMOUNT" value="${formData.NET_PROFIT_AMOUNT}" width="${form_NET_PROFIT_AMOUNT_W}" maxValue="${form_NET_PROFIT_AMOUNT_M}" decimalPlace="${form_NET_PROFIT_AMOUNT_NF}" disabled="${form_NET_PROFIT_AMOUNT_D}" readOnly="${form_NET_PROFIT_AMOUNT_RO}" required="${form_NET_PROFIT_AMOUNT_R}" onNumberKr="${form_NET_PROFIT_AMOUNT_KR}" currencyText="${form_NET_PROFIT_AMOUNT_CT}"/>
                </e:field>
                
                <e:label for="VNFI_ATT_FILE_NM" title="${form_VNFI_ATT_FILE_NM_N}"/>
				<e:field>
					<e:search id="VNFI_ATT_FILE_NM" name="VNFI_ATT_FILE_NM" value="${formData.VNFI_ATT_FILE_NM }" width="${form_VNFI_ATT_FILE_NM_W}" maxLength="20" onIconClick="doAttFIleNum" disabled="${form_VNFI_ATT_FILE_NM_D}" readOnly="true" required="${form_VNFI_ATT_FILE_NM_R}" />
					<e:inputHidden id="VNFI_ATT_FILE_NUM" name="VNFI_ATT_FILE_NUM" value="${formData.VNFI_ATT_FILE_NUM}" />
				</e:field>
                <%-- <e:label for="" title="">
                    <e:button id="doAttFIleNum" name="doAttFIleNum" label="${form_VNFI_ATT_FILE_NUM_CNT_N}" onClick="doAttFIleNum" style="margin-top: -1px;" disabled="${formData.VNFI_ATT_FILE_NUM_CNT==null?true:false}" visible="true"/>
                </e:label>
                <e:field>
                    <e:inputHidden id="VNFI_ATT_FILE_NUM" name="VNFI_ATT_FILE_NUM" value="${formData.VNFI_ATT_FILE_NUM}"/>
                    <e:text><a href="javascript:doAttFIleNum();">${formData.VNFI_ATT_FILE_NUM_CNT==null?'0':formData.VNFI_ATT_FILE_NUM_CNT}건</a></e:text>
                </e:field> --%>
            </e:row>

        </e:searchPanel>

<%--관리정보--%>
        <e:panel id="panel2" height="25px" width="40%">
            <e:title title="${SVNR0010_003}" depth="1" />
        </e:panel>
        <e:searchPanel id="sp2" title="" labelWidth="${labelWidth}" useTitleBar="false" width="100%" columnCount="3">
            <e:row>
                <e:label for="E_BILL_ASP_TYPE" title="${form_E_BILL_ASP_TYPE_N}"/>
                <e:field>
                    <e:select id="E_BILL_ASP_TYPE" name="E_BILL_ASP_TYPE" value="${formData.E_BILL_ASP_TYPE}" options="${eBillAspTypeOptions}" width="${form_E_BILL_ASP_TYPE_W}" disabled="${form_E_BILL_ASP_TYPE_D}" readOnly="${form_E_BILL_ASP_TYPE_RO}" required="${form_E_BILL_ASP_TYPE_R}" placeHolder="" usePlaceHolder="false" maskType="${form_E_BILL_ASP_TYPE_MT}" />
                </e:field>
                <e:label for="TAX_ASP_NM" title="${form_TAX_ASP_NM_N}" />
                <e:field>
                    <e:inputText id="TAX_ASP_NM" name="TAX_ASP_NM" value="${formData.TAX_ASP_NM}" width="${form_TAX_ASP_NM_W}" maxLength="${form_TAX_ASP_NM_M}" disabled="${form_TAX_ASP_NM_D}" readOnly="${form_TAX_ASP_NM_RO}" required="${form_TAX_ASP_NM_R}" style="${imeMode}" maskType="${form_TAX_ASP_NM_MT}"/>
                </e:field>
                <e:label for="TAX_SEND_TYPE" title="${form_TAX_SEND_TYPE_N}"/>
                <e:field>
                    <e:select id="TAX_SEND_TYPE" name="TAX_SEND_TYPE" value="${formData.TAX_SEND_TYPE}" options="${taxSendTypeOptions}" width="${form_TAX_SEND_TYPE_W}" disabled="${form_TAX_SEND_TYPE_D}" readOnly="${form_TAX_SEND_TYPE_RO}" required="${form_TAX_SEND_TYPE_R}" placeHolder="" usePlaceHolder="false" maskType="${form_TAX_SEND_TYPE_MT}" />
                </e:field>
            </e:row>

            <e:row>
                <e:label for="CREDIT_EVAL_COMPANY" title="${form_CREDIT_EVAL_COMPANY_N}" />
                <e:field>
                    <e:inputText id="CREDIT_EVAL_COMPANY" name="CREDIT_EVAL_COMPANY" value="${formData.CREDIT_EVAL_COMPANY}" width="${form_CREDIT_EVAL_COMPANY_W}" maxLength="${form_CREDIT_EVAL_COMPANY_M}" disabled="${form_CREDIT_EVAL_COMPANY_D}" readOnly="${form_CREDIT_EVAL_COMPANY_RO}" required="${form_CREDIT_EVAL_COMPANY_R}" style="${imeMode}" maskType="${form_CREDIT_EVAL_COMPANY_MT}"/>
                </e:field>
                <e:label for="CREDIT_CD" title="${form_CREDIT_CD_N}"/>
                <e:field>
                    <e:select id="CREDIT_CD" name="CREDIT_CD" value="${formData.CREDIT_CD}" options="${creditCdOptions}" width="${form_CREDIT_CD_W}" disabled="${form_CREDIT_CD_D}" readOnly="${form_CREDIT_CD_RO}" required="${form_CREDIT_CD_R}" placeHolder="" maskType="${form_CREDIT_CD_MT}" />
                </e:field>
                
                <e:label for="EV_ATT_FILE_NM" title="${form_EV_ATT_FILE_NM_N}"/>
				<e:field>
					<e:search id="EV_ATT_FILE_NM" name="EV_ATT_FILE_NM" value="${formData.EV_ATT_FILE_NM }" width="${form_EV_ATT_FILE_NM_W}" maxLength="20" onIconClick="doEvAttFIleNum" disabled="${form_EV_ATT_FILE_NM_D}" readOnly="true" required="${form_EV_ATT_FILE_NM_R}" />
					<e:inputHidden id="EV_ATT_FILE_NUM" name="EV_ATT_FILE_NUM" value="${formData.EV_ATT_FILE_NUM}" />
				</e:field>
				
                <%-- <e:label for="" title="">
                    <e:button id="doEvAttFIleNum" name="doEvAttFIleNum" label="${form_EV_ATT_FILE_NUM_CNT_N}" onClick="doEvAttFIleNum" style="margin-top: -1px;" disabled="${formData.EV_ATT_FILE_NUM_CNT==null?true:false}" visible="true"/>
                </e:label>
                <e:field>
                    <e:inputHidden id="EV_ATT_FILE_NUM" name="EV_ATT_FILE_NUM" value="${formData.EV_ATT_FILE_NUM}"/>
                    <e:inputHidden id="EV_ATT_FILE_NM" name="EV_ATT_FILE_NM" value="${formData.EV_ATT_FILE_NM}"/>
                    <e:text><a href="javascript:doEvAttFIleNum();">${formData.EV_ATT_FILE_NUM_CNT==null?'0':formData.EV_ATT_FILE_NUM_CNT}건</a></e:text>
                </e:field> --%>
            </e:row>

            <e:row>
                <e:label for="PROGRESS_NM" title="${form_PROGRESS_NM_N}" />
                <e:field>
                    <e:inputText id="PROGRESS_NM" name="PROGRESS_NM" value="${formData.PROGRESS_NM}" width="${form_PROGRESS_NM_W}" maxLength="${form_PROGRESS_NM_M}" disabled="${form_PROGRESS_NM_D}" readOnly="${form_PROGRESS_NM_RO}" required="${form_PROGRESS_NM_R}" style="${imeMode}" maskType="${form_PROGRESS_NM_MT}"/>
                </e:field>
                <e:label for="MOD_USER_NM" title="${form_MOD_USER_NM_N}" />
                <e:field>
                    <e:inputText id="MOD_USER_NM" name="MOD_USER_NM" value="${formData.MOD_USER_NM}" width="${form_MOD_USER_NM_W}" maxLength="${form_MOD_USER_NM_M}" disabled="${form_MOD_USER_NM_D}" readOnly="${form_MOD_USER_NM_RO}" required="${form_MOD_USER_NM_R}" style="${imeMode}" maskType="${form_MOD_USER_NM_MT}"/>
                </e:field>
                <e:label for="MOD_DATE" title="${form_MOD_DATE_N}" />
                <e:field>
                    <e:inputText id="MOD_DATE" name="MOD_DATE" value="${formData.MOD_DATE}" width="${form_MOD_DATE_W}" maxLength="${form_MOD_DATE_M}" disabled="${form_MOD_DATE_D}" readOnly="${form_MOD_DATE_RO}" required="${form_MOD_DATE_R}" style="${imeMode}" maskType="${form_MOD_DATE_MT}"/>
                </e:field>
            </e:row>
        </e:searchPanel>

<%--결제정보--%>
        <e:panel id="panel3" height="25px" width="40%">
            <e:title title="${SVNR0010_004}" depth="1" />
        </e:panel>
        <e:searchPanel id="sp3" title="" labelWidth="${labelWidth}" useTitleBar="false" width="100%" columnCount="3">
            <e:row>
                <e:label for="PAY_CONDITION" title="${form_PAY_CONDITION_N}"/>
                <e:field>
                    <e:select id="PAY_CONDITION" name="PAY_CONDITION" value="${formData.PAY_CONDITION}" options="${payConditionOptions}" width="${form_PAY_CONDITION_W}" disabled="${form_PAY_CONDITION_D}" readOnly="${form_PAY_CONDITION_RO}" required="${form_PAY_CONDITION_R}" placeHolder="" maskType="${form_PAY_CONDITION_MT}" />
                </e:field>
                <e:label for="PAY_TYPE" title="${form_PAY_TYPE_N}"/>
                <e:field>
                    <e:select id="PAY_TYPE" name="PAY_TYPE" value="${formData.PAY_TYPE}" options="${payTypeOptions}" width="${form_PAY_TYPE_W}" disabled="${form_PAY_TYPE_D}" readOnly="${form_PAY_TYPE_RO}" required="${form_PAY_TYPE_R}" placeHolder="" maskType="${form_PAY_TYPE_MT}" />
                </e:field>
                <e:label for="PAY_PUBLIC_TYPE" title="${form_PAY_PUBLIC_TYPE_N}"/>
                <e:field>
                    <e:select id="PAY_PUBLIC_TYPE" name="PAY_PUBLIC_TYPE" value="${formData.PAY_PUBLIC_TYPE}" options="${payPublicTypeOptions}" width="${form_PAY_PUBLIC_TYPE_W}" disabled="${form_PAY_PUBLIC_TYPE_D}" readOnly="${form_PAY_PUBLIC_TYPE_RO}" required="${form_PAY_PUBLIC_TYPE_R}" placeHolder="" maskType="${form_PAY_PUBLIC_TYPE_MT}" />
                </e:field>
            </e:row>
        </e:searchPanel>

        <e:gridPanel id="gridVNAP" name="gridVNAP" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}" />

<%--첨부파일--%>
        <e:panel id="pane4" height="25px" width="40%">
            <e:title title="${SVNR0010_005}" depth="1" />
        </e:panel>
        <e:gridPanel id="gridATTD" name="gridATTD" width="100%" height="250px" gridType="${_gridType}" readOnly="${param.detailView}" />

<%--거래희망 고객사--%>
        <e:buttonBar width="100%" align="right" title="${SVNR0010_008}">
            <e:button id="doUpdateReq" name="doUpdateReq" align="right" label="${doUpdateReq_N}" onClick="doUpdateReq" disabled="${doUpdateReq_D}" visible="${doUpdateReq_V}"/>
        </e:buttonBar>
        <e:gridPanel id="gridVNCM" name="gridVNCM" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}" />

        <e:buttonBar width="100%" align="right">
            <e:button id="doUpdate2" name="doUpdate2" label="${doUpdate_N}" onClick="doUpdate" disabled="${doUpdate_D}" visible="${doUpdate_V}"/>
        </e:buttonBar>
    </e:window>
</e:ui>
