<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
    <script type="text/javascript">
        var grid;
        var gridDEL;
        var baseUrl = "/nhepro/CRQR/";
        
        var PROGRESS_CD = "${empty formData.PROGRESS_CD ? param.PROGRESS_CD : formData.PROGRESS_CD}";
        var SIGN_STATUS = "${formData.SIGN_STATUS}";
        var RFX_TYPE    = "${formData.RFX_TYPE}";
        var rfxCnt      =("${formData.RFX_CNT}" == "")? "0" : "${formData.RFX_CNT}";
        var detailView  = "${param.detailView}" == "true";
        var ROWIDX;

        function init() {
            grid = EVF.C("grid");
            
            grid.setProperty("shrinkToFit", ${shrinkToFit});
            grid.setProperty("rowNumbers", ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
            grid.setProperty("sortable", ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
            grid.setProperty("panelVisible", ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            grid.setProperty("enterToNextRow", ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            grid.setProperty("acceptZero", ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            grid.setProperty("multiSelect", ${param.detailView == true ? false : multiSelect});					// [선택] 컬럼의 사용여부를 지정한다. [true/false]
            grid.setProperty("singleSelect", ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]

            grid.cellClickEvent(function(rowIdx, colIdx, value) {
                var ATT_FILE_NUM = grid.getCellValue(rowIdx, "ATT_FILE_NUM");
                var BUYER_CD = grid.getCellValue(rowIdx, "BUYER_CD");
                var param;

                ROWIDX = rowIdx;
                if(colIdx == "PR_BUYER_DEPT_NM") {
                    param = {
                        callBackFunction: "callBackPR_BUYER_DEPT_NM",
                        rowIdx: rowIdx
                    };
                    everPopup.openCommonPopup(param, "SP0119");
                }
                if(colIdx === "ITEM_CD") {
                    param = {
                        callBackFunction: "callBackITEM_CD",
                        BUYER_CD: BUYER_CD,
                        rowIdx: rowIdx
                    };
                    everPopup.openCommonPopup(param, "SP0121");
                }
                if(colIdx == "MAKER_NM") {
                    if(grid.getCellValue(rowIdx, "ITEM_CD") != "" && grid.getCellValue(rowIdx, "MAJOR_ITEM_FLAG") != "1") {
                        return EVF.alert("${CRQI0011_002}");
                    }
                    param = {
                        callBackFunction: "callBackMAKER_NM",
                        BUYER_CD: BUYER_CD,
                        rowIdx: rowIdx
                    };
                    everPopup.openCommonPopup(param, "SP0120");
                }
                if(colIdx == "VENDOR_LIST") {
                	if( value == "" ) return;
                	
                    var VN_INFO = grid.getCellValue(rowIdx, "VN_INFO");
                    param = {
                        callBackFunction : "callBackVENDOR_CD",
                        candidateJson: (EVF.isEmpty(VN_INFO) ? [] : VN_INFO),
                        detailView: EVF.V("SETTLE_TYPE") == "DOC",
                        callType: ""
                    };
                    everPopup.openPopupByScreenId("CBDR0016", 1200, 700, param);
                }
                if(colIdx == "ATT_FILE_NUM_CNT") {
                    param = {
                        attFileNum: ATT_FILE_NUM,
                        rowIdx: rowIdx,
                        callBackFunction: "callbackATT_FILE_NUM_CNT",
                        bizType: "PR",
                        detailView: detailView
                    };
                    everPopup.fileAttachPopup(param);
                }
                if(colIdx == "PR_NUM") {
                    param = {
                        prNum: grid.getCellValue(rowIdx, "PR_NUM"),
                        buyerCd: grid.getCellValue(rowIdx, "PB_BUYER_CD"),
                        popupFlag: true,
                        detailView: true
                    };
                    everPopup.openPopupByScreenId("CPRI0010", 1200, 900, param);
                }
            });
			
            grid.cellChangeEvent(function (rowIdx, colIdx, iRow, iCol, newValue, oldValue) {
                if(colIdx == "PR_QT" || colIdx == "UNIT_PRC") {
                    var prQt    = Number(grid.getCellValue(rowIdx, "PR_QT"));
                    var unitPrc = Number(grid.getCellValue(rowIdx, "UNIT_PRC"));
                   	
                    var prAmt   = 0;
                    if(!EVF.isEmpty(prQt) && prQt > 0 && !EVF.isEmpty(unitPrc) && unitPrc > 0) {
                    	prAmt = prQt * unitPrc;
                    	grid.setCellValue(rowIdx, "PR_AMT", everMath.floor_float(prAmt));
                    }
                    else {
						grid.setCellValue(rowIdx, 'PR_AMT', null);
					}
                    
                    /** 품목별 금액은 구매의뢰금액과 같아야 함
                    var sumAmt = 0;
                    var allRowId = grid.getAllRowId();
                    for(var i in allRowId) {
                        sumAmt += Number(grid.getCellValue(allRowId[i], "PR_AMT"));
                    }
                    EVF.V("PR_AMT", sumAmt);*/
                }
            });
			
            // 견적 : 유효시작일 및 종료일 숨기기
            if(RFX_TYPE == "RFQ") {
                EVF.C("doSearchItem").setVisible(false);
                EVF.C("doCopyItem").setVisible(true);
                
                grid.hideCol("VALID_FROM_DATE", true);
                grid.hideCol("VALID_TO_DATE", true);
                
                grid.setColRequired("VALID_FROM_DATE", false);
                grid.setColRequired("VALID_TO_DATE", false);
            }// 수의시담(RPC), 부속합의(RCA) 추가
            else if(RFX_TYPE == "RPC" || RFX_TYPE == "RCA") {
                EVF.C("doSearchItem").setVisible(false);
                EVF.C("doCopyItem").setVisible(true);
				
                grid.hideCol("VALID_FROM_DATE", true);
                grid.hideCol("VALID_TO_DATE", true);
				
                grid.setColRequired("VALID_FROM_DATE", false);
                grid.setColRequired("VALID_TO_DATE", false);
            }// 견적(단가계약)
            else {
                EVF.C("doSearchItem").setVisible(true);
                EVF.C("doCopyItem").setVisible(false);

                grid.hideCol("VALID_FROM_DATE", false);
                grid.hideCol("VALID_TO_DATE", false);
            }
			
            // 상세보기 팝업
            if(detailView) {
                doSearchRQDT();
				
                EVF.C("doCopyItem").setVisible(false);
                EVF.C("doSearchItem").setVisible(false);
                EVF.C("doDeleteItem").setVisible(false);
                EVF.C("doShowVendorList").setVisible(false);
            }
            else {
            	// 재견적 > 전송만 활성화
                if("${param.baseDataType}" == "RERFX") {
                    EVF.C("doSave").setVisible(false);
                    EVF.C("doApproval").setVisible(false);
                }
                else {
                	// 미작성, 임시저장 => 저장/결재상신 활성화
                	if( EVF.isEmpty(SIGN_STATUS) || SIGN_STATUS == 'T' ) {
                        EVF.C("doSend").setVisible(false);
                	}// 결재중 => 모두 비활성화
                	else if( SIGN_STATUS == 'P' ) {
                        EVF.C("doSave").setVisible(false);
                		EVF.C("doApproval").setVisible(false);
                		EVF.C("doDelete").setVisible(false);
                        EVF.C("doSend").setVisible(false);
                        
                		EVF.C("doCopyItem").setVisible(false);
                        EVF.C("doSearchItem").setVisible(false);
                        EVF.C("doDeleteItem").setVisible(false);
                        EVF.C("doShowVendorList").setVisible(false);
                	}// 반려, 상신취소 => 결재상신만 활성화
                	else if( SIGN_STATUS == 'R' || SIGN_STATUS == 'C' ) {
                		EVF.C("doSave").setVisible(false);
                		EVF.C("doSend").setVisible(false);
                	}
                	else {
                        EVF.C("doSave").setVisible(false);
                   		EVF.C("doApproval").setVisible(false);
                        EVF.C("doSend").setVisible(false);
                        EVF.C("doDelete").setVisible(false);
                        
                   		EVF.C("doCopyItem").setVisible(false);
                        EVF.C("doSearchItem").setVisible(false);
                        EVF.C("doDeleteItem").setVisible(false);
                        EVF.C("doShowVendorList").setVisible(false);
                	}
                }
				
                if( EVF.isEmpty(PROGRESS_CD) ) {
                    if("${param.baseDataType}" == "RERFX") {
                        doSearchRQDT();	// 이전차수의 견적품목 조회
                    } else {
                        doSearchPRDT();	// 구매요청 품목 조회
                    }
                    EVF.C("doDelete").setVisible(false);
                }
                else {
                    doSearchRQDT();
                }
            }

            gridDEL = EVF.C("gridDEL");
            $("#panel_hide").hide();

            if (rfxCnt > 1) {
            	EVF.C("RFX_LIMIT_CNT").setReadOnly(true);
            	EVF.C("SETTLE_TYPE").setReadOnly(true);
            	EVF.C("AMT_TYPE").setReadOnly(true);
            	EVF.C("EST_PRICE_TYPE").setReadOnly(true);
            	EVF.C("ATT_FILE_NUM").setReadOnly(true);
            	
            	EVF.C("doCopyItem").setVisible(false);
                EVF.C("doSearchItem").setVisible(false);
                EVF.C("doDeleteItem").setVisible(false);
                EVF.C("doShowVendorList").setVisible(false);
            }
            
         	// ======================그리드 합계 구하기=======================
		    var val = {"visible": true, "count": 1, "height": 15};
		    grid.setProperty('footerVisible', val);

		    var footer = {
		          "styles": {
		              "textAlignment": "center",
		              "fontBold": true,
		              "fontFmaily": "Nanum Gothic",
		          },
		          "text": "합   계"
		    };
		    grid.setRowFooter("PR_BUYER_DEPT_NM", footer);

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
		    grid.setRowFooter("PR_QT", distVal);
		    grid.setRowFooter("PR_AMT", distVal);
		    // ===========================================================
        }

        function callBackPR_BUYER_DEPT_NM(data) {
            grid.setCellValue(data.rowIdx, "PR_BUYER_CD", data.BUYER_CD);
            grid.setCellValue(data.rowIdx, "PR_DEPT_CD", data.DEPT_CD);
            grid.setCellValue(data.rowIdx, "PR_BUYER_DEPT_NM", data.BUYER_NM + " " + data.DEPT_NM);
        }

        function callBackITEM_CD(data) {
            grid.setCellValue(data.rowIdx, "ITEM_CD", data.ITEM_CD);
            grid.setCellValue(data.rowIdx, "ITEM_DESC", data.ITEM_DESC);
            grid.setCellValue(data.rowIdx, "ITEM_SPEC", data.ITEM_SPEC);
            grid.setCellValue(data.rowIdx, "MAKER_NM", data.MAKER_NM);
            grid.setCellValue(data.rowIdx, "MAKER_CD", data.MAKER_CD);
            grid.setCellValue(data.rowIdx, "MAKER_PART_NO", data.MAKER_PART_NO);
            grid.setCellValue(data.rowIdx, "ORIGIN_CD", data.ORIGIN_CD);
            grid.setCellValue(data.rowIdx, "UNIT_CD", data.UNIT_CD);
            grid.setCellValue(data.rowIdx, "MAJOR_ITEM_FLAG", data.MAJOR_ITEM_FLAG);
        }

        function callBackMAKER_NM(data) {
            grid.setCellValue(data.rowIdx, "MAKER_CD", data.MKBR_CD);
            grid.setCellValue(data.rowIdx, "MAKER_NM", data.MKBR_NM);
        }
		
        // 품목별 협력업체 선정
        function callBackVENDOR_CD(data) {
        	
            var VN_INFO = JSON.parse(data);
            var VN_INFO_CNT = VN_INFO.length;
            
            var vendorNm = "";
			if( VN_INFO_CNT == 1 ) {
				vendorNm = VN_INFO[0].VENDOR_NM;
			} else {
				vendorNm = VN_INFO_CNT;
			}
			
			// 수의시담, 부속합의 : 협력업체는 1개만 선택
            if((RFX_TYPE == "RPC" || RFX_TYPE == "RCA") && VN_INFO_CNT > 1) {
                return EVF.alert("${CRQI0011_005}");
            }
            
            grid.setCellValue(ROWIDX, "VENDOR_LIST", vendorNm);
            grid._gdp.setValue(ROWIDX, "VN_INFO", JSON.stringify(VN_INFO));
            grid.setCellValue(ROWIDX, "VENDOR_CNT", VN_INFO_CNT);
        }

        function callbackATT_FILE_NUM_CNT(rowIdx, fileId, fileCnt) {
            grid.setCellValue(rowIdx, "ATT_FILE_NUM_CNT", fileCnt);
            grid.setCellValue(rowIdx, "ATT_FILE_NUM", fileId);
        }

        function onChangeSETTLE_TYPE(c, v) {
            if(v == "ITEM") {
                EVF.V("EST_PRICE_TYPE", "0");
                EVF.C("EST_PRICE_TYPE").setReadOnly(true);
            } else {
                EVF.V("EST_PRICE_TYPE", "");
                EVF.C("EST_PRICE_TYPE").setReadOnly(false);
            }
        }
		
        // 품목복사
        function doCopyItem() {
        	
            if(grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

            var selRowValue = grid.getSelRowValue();
            for(var i in selRowValue) {
                var rowData = selRowValue[i];
                rowData.RFX_NUM = "";
                rowData.RFX_SQ  = "";
                grid.addRow(rowData);
            }
            /** 견적요청금액은 구매의뢰금액과 같아야 함.
            var sumAmt = 0;
            var allRowId = grid.getAllRowId();
            for(var i in allRowId) {
                sumAmt += Number(grid.getCellValue(allRowId[i], "PR_AMT"));
            }
            EVF.V("PR_AMT", sumAmt);*/
        }
		
        // 품목삭제
        function doDeleteItem() {
            if(grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

            var param;
            for(var i = grid.getRowCount() - 1; i >= 0; i--) {
                if(grid.isChecked(i)) {
                    param = [{
                        BUYER_CD: grid.getCellValue(i, "BUYER_CD"),
                        RFX_NUM: grid.getCellValue(i, "RFX_NUM"),
                        RFX_SQ: grid.getCellValue(i, "RFX_SQ"),
                        RFX_CNT: grid.getCellValue(i, "RFX_CNT"),
                        PB_BUYER_CD: grid.getCellValue(i, "PB_BUYER_CD"),
                        PR_NUM: grid.getCellValue(i, "PR_NUM"),
                        PR_SQ: grid.getCellValue(i, "PR_SQ")
                    }];
                    gridDEL.addRow(param);
                    grid.delRow(i);
                }
            }
            /** 견적요청금액은 구매의뢰금액과 같아야 함.
            var sumAmt = 0;
            var allRowId = grid.getAllRowId();
            for(var i in allRowId) {
                sumAmt += Number(grid.getCellValue(allRowId[i], "PR_AMT"));
            }
            EVF.V("PR_AMT", sumAmt);*/
        }
		
        // 단일업체선정의 협력업체 선택
        function doShowVendorList() {
            var VN_INFO = grid.getCellValue(0, "VN_INFO");
            var param = {
                    callBackFunction : "callBackALL_VENDOR_CD",
                    candidateJson: (EVF.isEmpty(VN_INFO) ? [] : VN_INFO),
                    detailView: detailView,
                    callType: ""
                };
            everPopup.openPopupByScreenId("CBDR0016", 1200, 700, param);
        }

        function callBackALL_VENDOR_CD(data) {
        	
            var VN_INFO = JSON.parse(data);
            var VN_INFO_CNT = VN_INFO.length;
            
            var vendorNm = "";
			if( VN_INFO_CNT == 1 ) {
				vendorNm = VN_INFO[0].VENDOR_NM;
			} else {
				vendorNm = VN_INFO_CNT;
			}
			
            // 수의시담, 부속합의 : 협력업체는 1개만 선택
            if((RFX_TYPE == "RPC" || RFX_TYPE == "RCA") && VN_INFO_CNT > 1) {
                return EVF.alert("${CRQI0011_005}");
            }
			
            var allRowId = grid.getAllRowId();
            for(var i in allRowId) {
                var idx = allRowId[i];
                grid.setCellValue(idx, "VENDOR_LIST", vendorNm);
                grid._gdp.setValue(idx, "VN_INFO", JSON.stringify(VN_INFO));
                grid.setCellValue(idx, "VENDOR_CNT", VN_INFO_CNT);
            }
        }

        function doSearchRQDT() {
            var store = new EVF.Store();
            store.setGrid([grid]);
            store.load(baseUrl + "crqi0011_doSearchRQDT.so", function() {
            });
        }

        function doSearchPRDT() {
            var store = new EVF.Store();
            store.setParameter("gridSel", JSON.stringify(${gridSel}));
            store.setGrid([grid]);
            store.load(baseUrl + "crqi0011_doSearchPRDT.so", function() {
                var allRowValue = grid.getAllRowValue();
                var isChk1 = false;
                var isChk2 = false;
                var rmkText;
				
                var sumAmt = 0;
                for(var i in allRowValue) {
                    var rowData = allRowValue[i];
                    if(rowData.PURCHASE_TYPE == "G" || rowData.PURCHASE_TYPE == "C") {
                        isChk1 = true;
                    } else if(rowData.PURCHASE_TYPE == "M") {
                        isChk2 = true;
                    }
                    sumAmt += Number(rowData.PR_AMT);
                }
                EVF.V("PR_AMT", sumAmt);

                if(isChk1 && isChk2) {
                    EVF.V("RMK_TEXT", "${CRQI0011_003}<br><br>${CRQI0011_004}");
                } else {
                    if(isChk1) {
                        EVF.V("RMK_TEXT", "${CRQI0011_004}");
                    }
                    if(isChk2) {
                        EVF.V("RMK_TEXT", "${CRQI0011_004}");
                    }
                }
            });
        }

        function doSave() {
            var signStatus = this.getData().data;
            
            var store = new EVF.Store();
            if(!store.validate()) { return; }

			if(!checkTimeToServer(EVF.C("RFX_START_DATE").getValue(), EVF.C("RFX_START_HOUR").getValue(), EVF.C("RFX_START_MIN").getValue())) {
				EVF.C('RFX_START_DATE').setFocus();
				return EVF.alert("${form_RFX_START_DATE_N}" + '의 ' + '${CRQI0011_009}');
			}

			if(!checkTimeToServer(EVF.C("RFX_CLOSE_DATE").getValue(), EVF.C("RFX_CLOSE_HOUR").getValue(), EVF.C("RFX_CLOSE_MIN").getValue())) {
				EVF.C('RFX_CLOSE_DATE').setFocus();
				return EVF.alert("${form_RFX_CLOSE_DATE_N}" + '의 ' + '${CRQI0011_010}');
			}

			if(!checkTimeToValue(EVF.C("RFX_START_DATE").getValue(), EVF.C("RFX_START_HOUR").getValue(), EVF.C("RFX_START_MIN").getValue(), EVF.C("RFX_CLOSE_DATE").getValue(), EVF.C("RFX_CLOSE_HOUR").getValue(), EVF.C("RFX_CLOSE_MIN").getValue())) {
				EVF.C('RFX_CLOSE_DATE').setFocus();
				return EVF.alert("${form_RFX_CLOSE_DATE_N}" + '의 ' + '${CRQI0011_011}');
			}
			
			if(EVF.C("EST_PRICE_TYPE").getValue() == "1" && EVF.C("ESTM_USER_ID").getValue() == "") {
				return EVF.alert('${CRQI0011_016}');
			}
            
            grid.checkAll(true);
            if(!grid.validate().flag) { return EVF.alert(grid.validate().msg); }

			// 품목별 협력업체가 다르면 안됨
            var sumAmt = 0;
			var vendorInfo = grid.getCellValue(0, "VN_INFO");
			var rowIds = grid.getAllRowId();
            for(var i in rowIds) {
        		if( vendorInfo != grid.getCellValue(rowIds[i], "VN_INFO") ) {
        			return EVF.alert("${CRQI0011_015}");
        		}
        		if( Number(grid.getCellValue(rowIds[i], "VENDOR_CNT")) == 0 ) {
        			return EVF.alert("${CRQI0011_017}");
        		}
        		// 수의시담 및 부속합의인 경우 견적업체는 1개만 선택
        		if( (RFX_TYPE == "RPC" || RFX_TYPE == "RCA") && Number(grid.getCellValue(rowIds[i], "VENDOR_CNT")) > 1 ) {
        			return EVF.alert("${CRQI0011_005}");
        		}
        		// 견적인 경우 견적업체는 2개 이상 선택(재견적 제외)
            	if( "${param.baseDataType}" !== "RERFX" && RFX_TYPE !== "RPC" && RFX_TYPE !== "RCA" && Number(grid.getCellValue(rowIds[i], "VENDOR_CNT")) < 2 ) {
        			return EVF.alert("${CRQI0011_020}");
        		}
                sumAmt += Number(grid.getCellValue(rowIds[i], "PR_AMT"));
            }
			
            // 추정금액과 품목별 추정금액의 합계가 같아야 한다.
            var prAmt  = EVF.V("PR_AMT");
            var rfxAmt = everMath.floor_float(sumAmt);
            if( prAmt !== rfxAmt ) {
            	return EVF.alert("${CRQI0011_019}");
            }

            var preSignStatus = EVF.V("PRE_SIGN_STATUS");
            if (preSignStatus != "E") {
                EVF.V("SIGN_STATUS", signStatus);
            }

            var confirmMessage;
            
            switch (signStatus) {
                case "T":
                    confirmMessage = "${msg.M0021}";
                    break;
                case "E":
                    confirmMessage = "${CRQI0011_008}";
                    break;
                case "P":
                    confirmMessage = "${msg.M0053}" + "<br/><br/>${CRQI0011_021}";
                    break;
            }

            EVF.confirm(confirmMessage, function () {
                if( signStatus === "T" || signStatus === "E" ) {
                    goApproval();
                }
                else if (signStatus === "P") {
                    var param = {
                            callBackFunction: "goApproval",
	                        subject: EVF.V("RFX_SUBJECT"),
	                        docType: "RFQ",
	                        signStatus: signStatus,
	                        screenId: "CRQI0011",
	                        approvalType: "APPROVAL",
	                        attFileNum: "",
	                        docNum: EVF.V("RFX_NUM"),
	                        appDocNum: EVF.V("APP_DOC_NUM"),
	                        appAmt: eval(grid._gvo.getSummary("PR_AMT", "sum"))
	                    };
                    everPopup.openApprovalRequestIPopup(param);
                }
            });
        }

        function goApproval(formData, gridData, attachData) {
        	var store = new EVF.Store();
            
        	var popupFlag = ${(param.popupFlag == null || !param.popupFlag) ? false : true};
        	
            EVF.V("approvalFormData", formData);
            EVF.V("approvalGridData", gridData);
            EVF.V("attachFileDatas", attachData);
			
            /** 견적요청금액은 구매의뢰금액과 같아야 함.
            var sumAmt = 0;
            var allRowId = grid.getAllRowId();
            for(var i in allRowId) {
                sumAmt += Number(grid.getCellValue(allRowId[i], "PR_AMT"));
            }
            EVF.V("PR_AMT", sumAmt);*/
            
            if(!store.validate()) { return; }

            store.setGrid([grid, gridDEL]);
            store.getGridData(grid, "all");
            store.getGridData(gridDEL, "all");
            store.doFileUpload(function () {
                store.load(baseUrl + "crqi0011_doSave.so", function(){
                    EVF.alert(this.getResponseMessage());
                    
	        		var param = {
	        				'BUYER_CD': this.getParameter("buyerCd"),
	        				'RFX_NUM': this.getParameter("rfxNum"),
	           				'RFX_CNT': this.getParameter("rfxCnt"),
	           				'baseDataType': "RFX",
	           				'detailView': false,
	           				'popupFlag': popupFlag
	           			};
	        		
	        		// OPENER 창 닫기(재견적)
	        		if( !EVF.isEmpty("${param.callBackFunction}") ) {
	    	    		opener['${param.callBackFunction}']();
	    	    		doClose();
	    	    	} else {
	        	    	if(popupFlag) {
	        	    		opener.doSearch();
	        	        	window.location.href = '/nhepro/CRQR/CRQI0011/view.so?' + $.param(param);
	        	    	} else {
	        	    		document.location.href = '/nhepro/CRQR/CRQI0011/view.so?' + $.param(param);
	        	    	}
	    	    	}
                });
            });
        }
		
        // 견적서 삭제
        function doDelete() {
            EVF.confirm("${CRQI0011_007}", function () {
                var store = new EVF.Store();

                store.setGrid([grid, gridDEL]);
                store.getGridData(grid, "all");
                store.getGridData(gridDEL, "all");
                store.doFileUpload(function () {
                    store.load(baseUrl + "crqi0011_doDelete.so", function(){
                        EVF.alert(this.getResponseMessage(), function() {
                            opener.doSearch();
                            doClose();
                        });
                    });
                });
            });
        }
	
        function doClose() {
            EVF.closeWindow();
        }

		function checkTimeToServer(date, time, min) {
			if(!EVF.isEmpty(date) && !EVF.isEmpty(time) && !EVF.isEmpty(min)) {
				var validStartDate = Number(date) + time + min;
				if ("${today}" + "${todayTime}" > validStartDate) {
					return false
				}
			}
			return true;
		}

		function checkTimeToValue(fromDate, fromTime, fromMin, toDate, toTime, toMin) {
			if(!EVF.isEmpty(fromDate) && !EVF.isEmpty(fromTime) && !EVF.isEmpty(fromMin)
					&& !EVF.isEmpty(toDate) && !EVF.isEmpty(toTime) && !EVF.isEmpty(toMin)) {
				var validStartDate = Number(fromDate) + fromTime + fromMin;
				var validCloseDate = Number(toDate) + toTime + toMin;
				if (validCloseDate <= validStartDate) {
					return false;
				}
			}
			return true;
		}
		
		function openEstmUserInfo() {
			if(EVF.V("EST_PRICE_TYPE") == "0") return;
			var param = {
				'callBackFunction': 'setEstmUserInfo',
				'multiYN' : 'N',
				'detailView': false
			};
			everPopup.openPopupByScreenId("CCDU0020", 1000, 550, param);
		}
		
		function setEstmUserInfo(data) {
		    data = JSON.parse(data);
			EVF.V("ESTM_USER_ID", data.USER_ID);
			EVF.V("ESTM_USER_NM", data.USER_NM);
		}
		
		function changeEstmTypeCd() {
			if(EVF.V("EST_PRICE_TYPE") == "0") {
				EVF.V("ESTM_USER_ID", "");
				EVF.V("ESTM_USER_NM", "");
			}
		}
    </script>

    <e:window id="CRQI0011" onReady="init" initData="${initData}" title="${screenName}" breadCrumbs="${breadCrumb }">
		
		<e:inputHidden id="PROGRESS_CD" name="PROGRESS_CD" value="${empty formData.PROGRESS_CD ? param.PROGRESS_CD : formData.PROGRESS_CD}" />
		<e:inputHidden id="baseDataType" name="baseDataType" value="${param.baseDataType}" />
        <e:inputHidden id="BUYER_CD" name="BUYER_CD" value="${formData.BUYER_CD}" />
        <e:inputHidden id="SETTLE_TYPE" name="SETTLE_TYPE" value="DOC" />
        <e:inputHidden id="RMK_TEXT_NUM" name="RMK_TEXT_NUM" value="${formData.RMK_TEXT_NUM }" />
        <e:inputHidden id="APP_DOC_NUM" name="APP_DOC_NUM" value="${empty param.appDocNum ? formData.APP_DOC_NUM : param.appDocNum}" />
        <e:inputHidden id="APP_DOC_CNT" name="APP_DOC_CNT" value="${formData.APP_DOC_CNT}" />
        <e:inputHidden id="PRE_SIGN_STATUS" name="PRE_SIGN_STATUS" value="${formData.SIGN_STATUS}" />
        <e:inputHidden id="SIGN_STATUS" name="SIGN_STATUS" value="${formData.SIGN_STATUS}" />
		<e:inputHidden id="ORI_RFX_CNT" name="ORI_RFX_CNT" value="${formData.ORI_RFX_CNT}" />
        <e:inputHidden id="approvalFormData" name="approvalFormData"/>
        <e:inputHidden id="approvalGridData" name="approvalGridData"/>
        <e:inputHidden id="attachFileDatas" name="attachFileDatas" visible="false" />
		
		<!-- 버튼 영역 -->
        <e:buttonBar width="100%" align="right">
            <e:button id="doSave" name="doSave" data="T" label="${doSave_N}" onClick="doSave" disabled="${doSave_D}" visible="${doSave_V}"/>
            <e:button id="doApproval" name="doApproval" data="P" label="${doApproval_N}" onClick="doSave" disabled="${doApproval_D}" visible="${doApproval_V}"/>
            <e:button id="doSend" name="doSend" data="E" label="${doSend_N}" onClick="doSave" disabled="${doSend_D}" visible="${doSend_V}"/>
            <e:button id="doDelete" name="doDelete" label="${doDelete_N}" onClick="doDelete" disabled="${doDelete_D}" visible="${doDelete_V}"/>
            <e:button id="doClose" name="doClose" label="${doClose_N}" onClick="doClose" disabled="${doClose_D}" visible="${doClose_V}"/>
        </e:buttonBar>

        <e:panel id="panel_hide">
            <e:gridPanel id="gridDEL" name="gridDEL" width="0" height="0" gridType="${_gridType}" readOnly="${param.detailView}"/>
        </e:panel>

        <e:searchPanel id="sp" title="${form_CAPTION_N}" labelWidth="${labelWidth}" useTitleBar="false" width="100%" columnCount="2" onEnter="doSearch">
            <e:row>
                <e:label for="RFX_NUM" title="${form_RFX_NUM_N}" />
                <e:field>
                    <e:inputText id="RFX_NUM" name="RFX_NUM" value="${formData.RFX_NUM}" width="${form_RFX_NUM_W}" maxLength="${form_RFX_NUM_M}" disabled="${form_RFX_NUM_D}" readOnly="${form_RFX_NUM_RO}" required="${form_RFX_NUM_R}" style="${imeMode}" maskType="${form_RFX_NUM_MT}"/>
                    <e:text>${formData.RFX_NUM} / ${formData.RFX_CNT}</e:text>
                    <e:inputNumber id="RFX_CNT" name="RFX_CNT" value="${formData.RFX_CNT}" width="${form_RFX_CNT_W}" maxValue="${form_RFX_CNT_M}" decimalPlace="${form_RFX_CNT_NF}" disabled="${form_RFX_CNT_D}" readOnly="${form_RFX_CNT_RO}" required="${form_RFX_CNT_R}" onNumberKr="${form_RFX_CNT_KR}" currencyText="${form_RFX_CNT_CT}"/>
                </e:field>
                <e:label for="CTRL_USER_ID" title="${form_CTRL_USER_ID_N}" />
                <e:field>
                    <e:inputText id="CTRL_USER_ID" name="CTRL_USER_ID" value="${formData.CTRL_USER_ID}" width="${form_CTRL_USER_ID_W}" maxLength="${form_CTRL_USER_ID_M}" disabled="${form_CTRL_USER_ID_D}" readOnly="${form_CTRL_USER_ID_RO}" required="${form_CTRL_USER_ID_R}" style="${imeMode}" maskType="${form_CTRL_USER_ID_MT}"/>
                    <e:text> ${formData.CTRL_USER_ID} / ${formData.CTRL_USER_NM} </e:text>
                    <e:inputText id="CTRL_USER_NM" name="CTRL_USER_NM" value="${formData.CTRL_USER_NM}" width="${form_CTRL_USER_NM_W}" maxLength="${form_CTRL_USER_NM_M}" disabled="${form_CTRL_USER_NM_D}" readOnly="${form_CTRL_USER_NM_RO}" required="${form_CTRL_USER_NM_R}" style="${imeMode}" maskType="${form_CTRL_USER_NM_MT}"/>
                </e:field>
            </e:row>
            <e:row>
                <e:label for="RFX_SUBJECT" title="${form_RFX_SUBJECT_N}" />
                <e:field>
                    <e:inputText id="RFX_SUBJECT" name="RFX_SUBJECT" value="${formData.RFX_SUBJECT}" width="${form_RFX_SUBJECT_W}" maxLength="${form_RFX_SUBJECT_M}" disabled="${form_RFX_SUBJECT_D}" readOnly="${form_RFX_SUBJECT_RO}" required="${form_RFX_SUBJECT_R}" style="${imeMode}" maskType="${form_RFX_SUBJECT_MT}"/>
                </e:field>
                <e:label for="RFX_TYPE" title="${form_RFX_TYPE_N}"/>
                <e:field>
                    <e:select id="RFX_TYPE" name="RFX_TYPE" value="${formData.RFX_TYPE}" options="${rfxTypeOptions}" width="${form_RFX_TYPE_W}" disabled="${form_RFX_TYPE_D}" readOnly="${form_RFX_TYPE_RO}" required="${form_RFX_TYPE_R}" placeHolder="" maskType="${form_RFX_TYPE_MT}" />
                    <e:text>[${form_RFX_LIMIT_CNT_N}]</e:text>
                    <e:inputText id="RFX_LIMIT_CNT" name="RFX_LIMIT_CNT" value="${formData.RFX_LIMIT_CNT}" width="${form_RFX_LIMIT_CNT_W}" maxLength="${form_RFX_LIMIT_CNT_M}" disabled="${form_RFX_LIMIT_CNT_D}" readOnly="${form_RFX_LIMIT_CNT_RO}" required="${form_RFX_LIMIT_CNT_R}" style="${imeMode}" maskType="${form_RFX_LIMIT_CNT_MT}"/>
                </e:field>
            </e:row>
            <e:row>
                <e:label for="RFX_START_DATE" title="${form_RFX_START_DATE_N}"/>
                <e:field>
                    <e:inputDate id="RFX_START_DATE" name="RFX_START_DATE" toDate="RFX_CLOSE_DATE" value="${formData.RFX_START_DATE}" width="${inputDateWidth}" datePicker="true" required="${form_RFX_START_DATE_R}" disabled="${form_RFX_START_DATE_D}" readOnly="${form_RFX_START_DATE_RO}" />
                    <e:text> </e:text>
                    <e:select id="RFX_START_HOUR" name="RFX_START_HOUR" value="${formData.RFX_START_HOUR}" options="${rfxStartHourOptions}" width="${form_RFX_START_HOUR_W}" disabled="${form_RFX_START_HOUR_D}" readOnly="${form_RFX_START_HOUR_RO}" required="${form_RFX_START_HOUR_R}" placeHolder="시" maskType="${form_RFX_START_HOUR_MT}" />
                    <e:text>시</e:text>
                    <e:select id="RFX_START_MIN" name="RFX_START_MIN" value="${formData.RFX_START_MIN}" options="${rfxStartMinOptions}" width="${form_RFX_START_MIN_W}" disabled="${form_RFX_START_MIN_D}" readOnly="${form_RFX_START_MIN_RO}" required="${form_RFX_START_MIN_R}" placeHolder="분" maskType="${form_RFX_START_MIN_MT}" />
                    <e:text>분</e:text>
                </e:field>
                <e:label for="RFX_CLOSE_DATE" title="${form_RFX_CLOSE_DATE_N}"/>
                <e:field>
                    <e:inputDate id="RFX_CLOSE_DATE" name="RFX_CLOSE_DATE" fromDate="RFX_START_DATE" value="${formData.RFX_CLOSE_DATE}" width="${inputDateWidth}" datePicker="true" required="${form_RFX_CLOSE_DATE_R}" disabled="${form_RFX_CLOSE_DATE_D}" readOnly="${form_RFX_CLOSE_DATE_RO}" />
                    <e:text> </e:text>
                    <e:select id="RFX_CLOSE_HOUR" name="RFX_CLOSE_HOUR" value="${formData.RFX_CLOSE_HOUR}" options="${rfxCloseHourOptions}" width="${form_RFX_CLOSE_HOUR_W}" disabled="${form_RFX_CLOSE_HOUR_D}" readOnly="${form_RFX_CLOSE_HOUR_RO}" required="${form_RFX_CLOSE_HOUR_R}" placeHolder="시" maskType="${form_RFX_CLOSE_HOUR_MT}" />
                    <e:text>시</e:text>
                    <e:select id="RFX_CLOSE_MIN" name="RFX_CLOSE_MIN" value="${formData.RFX_CLOSE_MIN}" options="${rfxCloseMinOptions}" width="${form_RFX_CLOSE_MIN_W}" disabled="${form_RFX_CLOSE_MIN_D}" readOnly="${form_RFX_CLOSE_MIN_RO}" required="${form_RFX_CLOSE_MIN_R}" placeHolder="분" maskType="${form_RFX_CLOSE_MIN_MT}" />
                    <e:text>분</e:text>
                </e:field>
            </e:row>
            <e:row>
                <%-- 업체선정기준 : 단일업체선정(DOC)로 FIX
                <e:label for="SETTLE_TYPE" title="${form_SETTLE_TYPE_N}"/>
                <e:field>
                    <e:select id="SETTLE_TYPE" name="SETTLE_TYPE" value="${formData.SETTLE_TYPE}" onChange="onChangeSETTLE_TYPE" options="${settleTypeOptions}" width="${form_SETTLE_TYPE_W}" disabled="${form_SETTLE_TYPE_D}" readOnly="${form_SETTLE_TYPE_RO}" required="${form_SETTLE_TYPE_R}" placeHolder="" maskType="${form_SETTLE_TYPE_MT}" />
                </e:field>
                --%>
                <e:label for="AMT_TYPE" title="${form_AMT_TYPE_N}"/>
                <e:field>
                    <e:select id="AMT_TYPE" name="AMT_TYPE" value="${formData.AMT_TYPE}" options="${amtTypeOptions}" width="${form_AMT_TYPE_W}%" disabled="${form_AMT_TYPE_D}" readOnly="${form_AMT_TYPE_RO}" required="${form_AMT_TYPE_R}" placeHolder="" maskType="${form_AMT_TYPE_MT}" />
                </e:field>
                <e:label for="EST_PRICE_TYPE" title="${form_EST_PRICE_TYPE_N}"/>
                <e:field>
                    <e:select id="EST_PRICE_TYPE" name="EST_PRICE_TYPE" value="${formData.EST_PRICE_TYPE}" options="${estPriceTypeOptions}" width="${form_EST_PRICE_TYPE_W}%" disabled="${form_EST_PRICE_TYPE_D}" readOnly="${form_EST_PRICE_TYPE_RO}" required="${form_EST_PRICE_TYPE_R}" placeHolder="" maskType="${form_EST_PRICE_TYPE_MT}" onChange="changeEstmTypeCd"/>
                </e:field>
            </e:row>
            <e:row>
                <e:label for="CUR" title="${form_CUR_N}"/>
                <e:field>
					<e:inputNumber id="PR_AMT" name="PR_AMT" value="${formData.PR_AMT}" width="${form_PR_AMT_W}" maxValue="${form_PR_AMT_M}" decimalPlace="${form_PR_AMT_NF}" disabled="${form_PR_AMT_D}" readOnly="${form_PR_AMT_RO}" required="${form_PR_AMT_R}" onNumberKr="${form_PR_AMT_KR}" currencyText="${form_PR_AMT_CT}"/>
                    <e:select id="CUR" name="CUR" value="${formData.CUR}" options="${curOptions}" width="${form_CUR_W}" disabled="${form_CUR_D}" readOnly="${form_CUR_RO}" required="${form_CUR_R}" placeHolder="" maskType="${form_CUR_MT}" />
                    <e:select id="VAT_TYPE" name="VAT_TYPE" value="${formData.VAT_TYPE}" options="${vatTypeOptions}" width="${form_VAT_TYPE_W}" disabled="${form_VAT_TYPE_D}" readOnly="${form_VAT_TYPE_RO}" required="${form_VAT_TYPE_R}" placeHolder="" maskType="${form_VAT_TYPE_MT}" />
                </e:field>
                <e:label for="ESTM_USER_ID" title="${form_ESTM_USER_ID_N}"/>
				<e:field>
					<e:search id="ESTM_USER_ID" name="ESTM_USER_ID" value="${formData.ESTM_USER_ID}" width="${form_ESTM_USER_ID_W}" maxLength="${form_ESTM_USER_ID_M}" onIconClick="openEstmUserInfo" disabled="${form_ESTM_USER_ID_D}" readOnly="${form_ESTM_USER_ID_RO}" required="${form_ESTM_USER_ID_R}" maskType="${form_ESTM_USER_ID_MT}" />
					<e:inputText id="ESTM_USER_NM" name="ESTM_USER_NM" value="${formData.ESTM_USER_NM}" width="${form_ESTM_USER_NM_W}" maxLength="${form_ESTM_USER_NM_M}" disabled="${form_ESTM_USER_NM_D}" readOnly="${form_ESTM_USER_NM_RO}" required="${form_ESTM_USER_NM_R}" style="${imeMode}" maskType="${form_ESTM_USER_NM_MT}"/>
				</e:field>
            </e:row>
            <e:row>
                <e:label for="RMK_TEXT_NUM" title="${form_RMK_TEXT_NUM_N}" />
                <e:field colSpan="3">
                    <e:richTextEditor id="RMK_TEXT" name="RMK_TEXT" value="${formData.RMK_TEXT}" width="${form_RMK_TEXT_NUM_W}" height="200px" disabled="${form_RMK_TEXT_NUM_D}" readOnly="${form_RMK_TEXT_NUM_RO}" required="${form_RMK_TEXT_NUM_R}" style="${imeMode}"/>
                </e:field>
            </e:row>
            <e:row>
                <e:label for="ATT_FILE_NUM" title="${form_ATT_FILE_NUM_N}" />
                <e:field colSpan="3">
                    <e:fileManager id="ATT_FILE_NUM" width="${form_ATT_FILE_NUM_W}" height="100px" fileId="${formData.ATT_FILE_NUM}" bizType="RFQ" readOnly="${form_ATT_FILE_NUM_RO}" required="${form_ATT_FILE_NUM_R}"/>
                </e:field>
            </e:row>
        </e:searchPanel>

		<%-- 품목정보--%>
        <e:buttonBar width="100%" align="right" title="${CRQI0011_CAPTION1}">
            <e:button id="doCopyItem" name="doCopyItem" label="${doCopyItem_N}" onClick="doCopyItem" disabled="${doCopyItem_D}" visible="${doCopyItem_V}"/>
            <e:button id="doSearchItem" name="doSearchItem" label="${doSearchItem_N}" onClick="doSearchItem" disabled="${doSearchItem_D}" visible="${doSearchItem_V}"/>
            <e:button id="doDeleteItem" name="doDeleteItem" label="${doDeleteItem_N}" onClick="doDeleteItem" disabled="${doDeleteItem_D}" visible="${doDeleteItem_V}"/>
            <e:button id="doShowVendorList" name="doShowVendorList" label="${doShowVendorList_N}" onClick="doShowVendorList" disabled="${doShowVendorList_D}" visible="${doShowVendorList_V}"/>
        </e:buttonBar>

        <e:gridPanel id="grid" name="grid" width="100%" height="fit" gridType="${_gridType}" readOnly="${!param.detailView?(param.baseDataType=='RERFX'):true}" />

	    <%-- 결재자 리스트 Include --%>
	    <jsp:include page="/WEB-INF/views/nhepro/CWOR/CWOR0013.jsp" flush="true" >
	        <jsp:param value="${formData.APP_DOC_NUM}" name="APP_DOC_NUM"/>
	        <jsp:param value="${formData.APP_DOC_CNT}" name="APP_DOC_CNT"/>
	        <jsp:param value="${formData.BUYER_CD}" name="BUYER_CD"/>
	    </jsp:include>

    </e:window>
</e:ui>
