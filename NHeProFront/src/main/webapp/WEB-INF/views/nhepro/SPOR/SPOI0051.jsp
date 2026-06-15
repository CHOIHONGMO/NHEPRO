<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
    <script type="text/javascript" src="/MagicLine4Web/ML4Web/js/ext/jquery.blockUI.js"></script>
    <script type="text/javascript" src="/MagicLine4Web/ML4Web/js/ext/ML_Config.js"></script>

    <script type="text/javascript">
        var gridPODT;
        var gridIVGH;
        var baseUrl = "/nhepro/SPOR/";
        var detailView  = "${param.detailView}" == "true";
        var PROGRESS_CD = "${empty formData.PROGRESS_CD ? param.PROGRESS_CD : formData.PROGRESS_CD}";
        var INV_SUM_AMT = 0;
        var PAY_SUM_AMT = 0;
        var localServerFlag = "${localServerFlag}";
        
        function init() {
            gridIVGH = EVF.C("gridIVGH");   // 검수요청상세

            gridIVGH.setProperty("shrinkToFit", ${shrinkToFit});
            gridIVGH.setProperty("rowNumbers", ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
            gridIVGH.setProperty("sortable", ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
            gridIVGH.setProperty("panelVisible", ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            gridIVGH.setProperty("enterToNextRow", ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            gridIVGH.setProperty("acceptZero", ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            gridIVGH.setProperty("multiSelect", false);					// [선택] 컬럼의 사용여부를 지정한다. [true/false]
            gridIVGH.setProperty("singleSelect", ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]

            gridPODT = EVF.C("gridPODT");   // 품목정보

            gridPODT.setProperty("shrinkToFit", ${shrinkToFit});
            gridPODT.setProperty("rowNumbers", ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
            gridPODT.setProperty("sortable", ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
            gridPODT.setProperty("panelVisible", ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            gridPODT.setProperty("enterToNextRow", ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            gridPODT.setProperty("acceptZero", ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            gridPODT.setProperty("multiSelect", ${param.detailView == true ? false : multiSelect});					// [선택] 컬럼의 사용여부를 지정한다. [true/false]
            gridPODT.setProperty("singleSelect", ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]
            
            gridPOPC = EVF.C("gridPOPC");   // 지불고객사

            gridPOPC.setProperty("shrinkToFit", ${shrinkToFit});
            gridPOPC.setProperty("rowNumbers", ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
            gridPOPC.setProperty("sortable", ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
            gridPOPC.setProperty("panelVisible", ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            gridPOPC.setProperty("enterToNextRow", ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            gridPOPC.setProperty("acceptZero", ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            gridPOPC.setProperty("multiSelect", false);					// [선택] 컬럼의 사용여부를 지정한다. [true/false]
            gridPOPC.setProperty("singleSelect", ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]

            gridPODT.cellChangeEvent(function (rowIdx, colIdx, irow, icol, value, oldValue) {
                var param;
                var PO_RE_QT  = gridPODT.getCellValue(rowIdx, "PO_RE_QT");
                var PO_RE_AMT = gridPODT.getCellValue(rowIdx, "PO_RE_AMT");
                var PAY_AMT   = EVF.V("PAY_AMT");
                var VAT_TYPE  = EVF.V("VAT_TYPE");

                if(colIdx == "INV_QT") {
                	if(value > PO_RE_QT) {
                        gridPODT.setCellValue(rowIdx, colIdx, oldValue);
                        EVF.alert("${SPOI0051_008}");
                    } else {
                        gridPODT.setCellValue(rowIdx, "INV_AMT", everMath.floor_float(value * gridPODT.getCellValue(rowIdx, "UNIT_PRC")));
						
                        if(gridPODT._gvo.getSummary("INV_AMT", "sum") > PAY_AMT) {
                            gridPODT.setCellValue(rowIdx, colIdx, oldValue);
                            gridPODT.setCellValue(rowIdx, "INV_AMT", everMath.floor_float(oldValue * gridPODT.getCellValue(rowIdx, "UNIT_PRC")));
                            
                            EVF.alert("${SPOI0051_009}"); // 검수요청금액의 합이 지급예정금액보다 클 수 없습니다.
                        }

                        if(VAT_TYPE == "1") {
                            gridPODT.setCellValue(rowIdx, "VAT_AMT", everMath.floor_float(gridPODT.getCellValue(rowIdx, "INV_AMT") / 11));
                        } else if(VAT_TYPE == "2") {
                            gridPODT.setCellValue(rowIdx, "VAT_AMT", everMath.floor_float(gridPODT.getCellValue(rowIdx, "INV_AMT") * 0.1));
                        } else {
                            gridPODT.setCellValue(rowIdx, "VAT_AMT", "0");
                        }
                        
                        onChangeINV_AMT();
                    }
                }
                else if(colIdx == "INV_AMT") {
                	if(value > PO_RE_AMT) {
                        gridPODT.setCellValue(rowIdx, colIdx, oldValue);
                        EVF.alert("${SPOI0051_007}");
                    } else {
                    	/** 2021.01.18 제외
                        gridPODT.setCellValue(rowIdx, "INV_QT", value / gridPODT.getCellValue(rowIdx, "UNIT_PRC"));*/
                        
                    	if(gridPODT._gvo.getSummary("INV_AMT", "sum") > PAY_AMT) {
                            gridPODT.setCellValue(rowIdx, colIdx, oldValue);
                            /** 2021.01.18 제외
                            gridPODT.setCellValue(rowIdx, "INV_QT", oldValue / gridPODT.getCellValue(rowIdx, "UNIT_PRC"));*/
                            EVF.alert("${SPOI0051_009}"); // 검수요청금액의 합이 지급예정금액보다 클 수 없습니다.
                        }

                        if(VAT_TYPE == "1") {
                            gridPODT.setCellValue(rowIdx, "VAT_AMT", everMath.floor_float(gridPODT.getCellValue(rowIdx, "INV_AMT") / 11));
                        } else if(VAT_TYPE == "2") {
                            gridPODT.setCellValue(rowIdx, "VAT_AMT", everMath.floor_float(gridPODT.getCellValue(rowIdx, "INV_AMT") * 0.1));
                        } else {
                            gridPODT.setCellValue(rowIdx, "VAT_AMT", "0");
                        }
                        
                        onChangeINV_AMT();
                    }
                }
            });

            if(detailView) {
                doSearchIVDT();
            } else {
                if( EVF.isEmpty(PROGRESS_CD) ) {
                    doSearchPODT();
                    EVF.C("doDelete").setDisabled(true);
                } else {
                    doSearchIVDT();
                }
            }
            doSearchPOPC();
            doSearchIVGH();
			
            gridPODT.setColGroup([
                {
                    "groupName": '발주정보',
                    "columns": ['PO_QT', 'UNIT_CD', 'UNIT_PRC', 'ITEM_AMT']
                }
                ,{
                    "groupName": '미검수정보',
                    "columns": ['PO_RE_QT', 'PO_RE_AMT']
                }
                ,{
                    "groupName": '검수요청정보',
                    "columns": ['INV_QT', 'INV_AMT', 'VAT_AMT']
                }
                ,{
                    "groupName": '누적검수요청정보',
                    "columns": ['SUM_INV_QT', 'SUM_INV_AMT']
                }
            ],50);
            
         	// ======================그리드 합계 구하기=======================
		    var val = {"visible": true, "count": 1, "height": 15};
		    gridPODT.setProperty('footerVisible', val);

		    var footer = {
		          "styles": {
		              "textAlignment": "center",
		              "fontBold": true,
		              "fontFmaily": "Nanum Gothic",
		          },
		          "text": "합   계"
		    };
		    gridPODT.setRowFooter("ITEM_CD", footer);

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
		    gridPODT.setRowFooter("PO_QT", distVal);
		    gridPODT.setRowFooter("ITEM_AMT", distVal);
		    gridPODT.setRowFooter("PO_RE_QT", distVal);
		    gridPODT.setRowFooter("PO_RE_AMT", distVal);
		    gridPODT.setRowFooter("INV_QT", distVal);
		    gridPODT.setRowFooter("INV_AMT", distVal);
		    gridPODT.setRowFooter("VAT_AMT", distVal);
		    gridPODT.setRowFooter("SUM_INV_QT", distVal);
		    gridPODT.setRowFooter("SUM_INV_AMT", distVal);
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
		 		
            EVF.C("PAY_PERCENT").setStyle("color:#FF0000;font-weight:bold;");
            EVF.C("PAY_AMT").setStyle("color:#FF0000;font-weight:bold;");
            EVF.C("SUBJECT").setStyle("color:#FF0000;font-weight:bold;");
            EVF.C("INV_AMT").setStyle("color:#FF0000;font-weight:bold;");
            EVF.C("PAY_AMT_TEXT").setStyle("color:#FF0000;font-weight:bold;");
            EVF.C("INV_AMT_TEXT").setStyle("color:#FF0000;font-weight:bold;");
        }

        function onChangeINV_AMT() {
            EVF.V("INV_AMT", gridPODT._gvo.getSummary("INV_AMT", "sum"));
            EVF.V("INV_AMT_TEXT", gridPODT._gvo.getSummary("INV_AMT", "sum"));

            var VAT_TYPE = EVF.V("VAT_TYPE");   // 1:부가세포함, 2:부가세별도, 0:부가세면제
            var INV_AMT  = EVF.V("INV_AMT");
            var VAT_AMT  = 0;

            if(VAT_TYPE == "1") {
                VAT_AMT = everMath.floor_float(INV_AMT / 11);
            } else if(VAT_TYPE == "2") {
                VAT_AMT = everMath.floor_float(INV_AMT * 0.1);
            }
            EVF.V("VAT_AMT", VAT_AMT);
        }
		
        // 발주서 기준으로 검수요청서 신규 작성
        function doSearchPODT() {
            var store = new EVF.Store();
            store.setParameter("gridSel", JSON.stringify(${gridSel}));
            store.setGrid([gridPODT]);
            store.load(baseUrl + "spoi0051_doSearchPODT.so", function() {
                if(gridPODT.getRowCount() > 0) {
                	var payPercent = EVF.V("PAY_PERCENT");
                	var vatType    = EVF.V("VAT_TYPE");
                	
                    var allRowId = gridPODT.getAllRowId();
                    for(var i in allRowId) {
                        var rowIdx = allRowId[i];
                        
                        // 2021.01.18 (검수요청수량 = 발주수량 * 지급율(%))
                        var invQt  = everMath.floor_float((gridPODT.getCellValue(rowIdx, "PO_QT") * payPercent)/100, 2);
                        var invAmt = everMath.floor_float((invQt * gridPODT.getCellValue(rowIdx, "UNIT_PRC")));
                        gridPODT.setCellValue(rowIdx, "INV_QT", invQt);
                        
                        /**
                         * 2021.09.17 (요청금액 수정하도록 변경)
                        gridPODT.setCellValue(rowIdx, "INV_AMT", invAmt);
                        
                        if(vatType == "1") {
                            gridPODT.setCellValue(rowIdx, "VAT_AMT", everMath.floor_float(invAmt / 11));
                        } else if(vatType == "2") {
                            gridPODT.setCellValue(rowIdx, "VAT_AMT", everMath.floor_float(invAmt * 0.1));
                        } else {
                            gridPODT.setCellValue(rowIdx, "VAT_AMT", "0");
                        }
                        
                        // FORM의 검수요청금액
                        onChangeINV_AMT();
                        */
                        
                        /* if(gridPODT.getCellValue(rowIdx, "ITEM_AMT") == gridPODT.getCellValue(rowIdx, "SUM_INV_AMT")) {
                            gridPODT.setCellReadOnly(rowIdx, "INV_QT", true);
                            gridPODT.setCellReadOnly(rowIdx, "INV_AMT", true);
                            gridPODT.setCellEdgeColor(rowIdx, "INV_QT", true);
                            gridPODT.setCellEdgeColor(rowIdx, "INV_AMT", true);
                        } */
                    }
                }
            });
        }
        
        function doSearchPOPC() {
            var store = new EVF.Store();
            store.setGrid([gridPOPC]);
            store.load(baseUrl + "spoi0051_doSearchPOPC.so", function() {
            	
            });
        }

        function doSearchIVGH() {
            var store = new EVF.Store();
            store.setGrid([gridIVGH]);
            store.load(baseUrl + "spoi0051_doSearchIVGH.so", function() {
                //INV_SUM_AMT = this.data.CNT_SUM_AMT[0].INV_AMT;
                //PAY_SUM_AMT = this.data.CNT_SUM_AMT[0].PAY_AMT;
            });
        }
		
        // 저장된 검수요청서 가져오기
        function doSearchIVDT() {
            var store = new EVF.Store();
            store.setGrid([gridPODT]);
            store.load(baseUrl + "spoi0051_doSearchIVDT.so", function() {
                /* if(gridPODT.getRowCount() > 0) {
                    var allRowId = gridPODT.getAllRowId();
                    for(var i in allRowId) {
                        var rowIdx = allRowId[i];
                        if(gridPODT.getCellValue(rowIdx, "ITEM_AMT") == gridPODT.getCellValue(rowIdx, "SUM_INV_AMT")) {
                            gridPODT.setCellReadOnly(rowIdx, "INV_QT", true);
                            gridPODT.setCellReadOnly(rowIdx, "INV_AMT", true);
                            gridPODT.setCellEdgeColor(rowIdx, "INV_QT", true);
                            gridPODT.setCellEdgeColor(rowIdx, "INV_AMT", true);
                        }
                    }
                } */
            });
        }
        
        function date_add(sDate, nDays) {
		    var yy = parseInt(sDate);
		    return '' + yy + nDays;
		}
        
        function LdateAdd(sDate, nDays) {
		    var yy = parseInt(sDate.substr(0, 4), 10);
		    var mm = parseInt(sDate.substr(5, 2), 10);
		    if(mm == 01){
		    	yy = yy - 1;
		    }
		    
			var dd = nDays
		    d = new Date(yy, mm - 1, dd);
		    yy = d.getFullYear();
		    mm = d.getMonth(); mm = (mm < 10) ? '0' + mm : mm;
		    if(mm == 00){
		    	mm = 12;
		    }
		    
		    dd = d.getDate(); dd = (dd < 10) ? '0' + dd : dd;
			
		    return '' + yy + mm + dd;
		}
        
        function MdateAdd(sDate, nDays) {
		    var yy = parseInt(sDate.substr(0, 4), 10);
		    var mm = parseInt(sDate.substr(5, 2), 10);
			var dd = nDays
		    d = new Date(yy, mm, dd);

		    yy = d.getFullYear();
		    mm = d.getMonth(); mm = (mm < 10) ? '0' + mm : mm;
		    dd = d.getDate(); dd = (dd < 10) ? '0' + dd : dd;

		    return '' + yy + mm + dd;
		}
        
        //2022.09.15 검수요청 시 당월 10일 기준으로 과거일자로 선택 할수 있도록 개선
        //당월 10일 전 전월1일부터 선택 
        //당월 10일 후 당월1일부터 선택
        function doSave() {
            var store = new EVF.Store();
            if(!store.validate()) { return; }
			
            var CUR_DATE = EVF.V("CUR_DATE");       
            var CUR_SEND_DATE = EVF.V("CUR_SEND_DATE");  
            
            var curSendDate = "";
            var curReqDate = "";
            var LsendDate = "";
            var LReqDate = "";
            var MsendDate = "";
            var MReqDate = "";
            var HReqDate = "";
            
            curSendDate = Number(CUR_SEND_DATE.substring(0, 6));
            //당월 10일 셋팅
            curReqDate = date_add(curSendDate, 10);     
            
            LsendDate = Number(CUR_SEND_DATE.substring(0, 4)) + "/" + CUR_SEND_DATE.substring(4, 6) + "/" + CUR_SEND_DATE.substring(6, 8);
            //전월 01일 셋팅
            LReqDate = LdateAdd(LsendDate, 1); 
            
            MsendDate = Number(CUR_SEND_DATE.substring(0, 4)) + "/" + CUR_SEND_DATE.substring(4, 6) + "/" + CUR_SEND_DATE.substring(6, 8);
            //당월 01일 셋팅
            MReqDate = MdateAdd(MsendDate, 1); 
            HReqDate = curSendDate + "01"; 
            
            //현재일자가 10일 전(매월 9일까지) 검수요청일자 전월1일부터 소급 가능
            //현재일자가 10일 이후(매월 10일부터) 검수요청일자 당월 1일부터 소급
            if( curReqDate > Number(CUR_DATE)){
            	if( LReqDate > Number(EVF.V("SEND_DATE")) ) {
                	return EVF.alert("검수요청일자는 전월 1일부터 이후로 선택하세요"); // 검수요청일자는 현재일자 이후로 선택하세요.
                }
	        } else if (curReqDate <= Number(CUR_DATE)){
	        	if(Number(HReqDate) > Number(EVF.V("SEND_DATE")) ) {
	            	return EVF.alert("검수요청일자는 당월 1일부터 이후로 선택하세요"); // 검수요청일자는 현재일자 이후로 선택하세요.
	            }
	        }
            
        	// 2021.04.28 추가
            // 검수요청일자 >= 현재일자
            //if( Number(EVF.V("CUR_DATE")) > Number(EVF.V("SEND_DATE")) ) {
            //	return EVF.alert("${SPOI0051_017}"); // 검수요청일자는 현재일자 이후로 선택하세요.
            //}
            
            if( EVF.isEmpty(EVF.V("INV_AMT")) || EVF.V("INV_AMT") == 0 ) {
                return EVF.alert("${SPOI0051_010}");
            }
			
            if(!gridPODT.validate(true).flag) { return EVF.alert(gridPODT.validate().msg); }
            
            var allRowId = gridPODT.getAllRowId();
            for(var i in allRowId) {
                var rowIdx = allRowId[i];
                if(gridPODT.getCellValue(rowIdx, "ITEM_AMT") != gridPODT.getCellValue(rowIdx, "SUM_INV_AMT")) {
	                if( EVF.isEmpty(gridPODT.getCellValue(rowIdx, "INV_QT")) || gridPODT.getCellValue(rowIdx, "INV_QT") == 0 ) {
	                    return EVF.alert("${SPOI0051_018}");
	                }
                }
                
                if( gridPODT.getCellValue(rowIdx, "INV_QT") > gridPODT.getCellValue(rowIdx, "PO_RE_QT") ) {
                    return EVF.alert("${SPOI0051_008}");
                }
                
                if( gridPODT.getCellValue(rowIdx, "INV_AMT") > gridPODT.getCellValue(rowIdx, "PO_RE_AMT") ) {
                    return EVF.alert("${SPOI0051_007}");
                }
            }
            
            var message = "${SPOI0051_004}";
            // 검수요청금액과 지급예정금액이 같지 않은 경우
            var payAmt = Number(EVF.V("PAY_AMT")); // 지급예정금액
            var invAmt = Number(EVF.V("INV_AMT")); // 검수요청금액
            if(payAmt != invAmt) {
            	if( invAmt > payAmt ) {
                	return EVF.alert("검수요청금액은 지급예정금액 이내에서 요청 가능합니다.");
            	} else if( invAmt != payAmt ) {
            		message = "지급예정금액과 검수요청금액이 일치하지 않습니다.\n\n이대로 임시저장 하시겠습니까?";
            	}
            }
            EVF.confirm(message, function () {
                store.setGrid([gridPODT]);
                store.getGridData(gridPODT, "all");
                store.doFileUpload(function () {
                    store.load(baseUrl + "spoi0051_doSave.so", function(){
                    	var buyerCd = this.getParameter("BUYER_CD");
    					var invNum  = this.getParameter("INV_NUM");
    					
                        EVF.alert(this.getResponseMessage(), function() {
                        	var param = {
        							'BUYER_CD': buyerCd,
        							'INV_NUM': invNum
        						};
                            window.location.href = '/nhepro/SPOR/SPOI0051/view.so?' + $.param(param);
                            
                            if(opener) {
                                opener.doSearch();
                            }
                        });
                    });
                });
            });
        }

        function doSend() {
            var store = new EVF.Store();
            if(!store.validate()) { return; }
			
            var CUR_DATE = EVF.V("CUR_DATE");           
            var CUR_SEND_DATE = EVF.V("CUR_SEND_DATE");
            
            var curSendDate = "";
            var curReqDate = "";
            var LsendDate = "";
            var LReqDate = "";
            var MsendDate = "";
            var MReqDate = "";
            var HReqDate = "";
            
            curSendDate = Number(CUR_SEND_DATE.substring(0, 6));
            //당월10일 셋팅
            curReqDate = date_add(curSendDate, 10);           
            
            LsendDate = Number(CUR_SEND_DATE.substring(0, 4)) + "/" + CUR_SEND_DATE.substring(4, 6) + "/" + CUR_SEND_DATE.substring(6, 8);
            //전월1일 셋팅
            LReqDate = LdateAdd(LsendDate, 1); 
            
            MsendDate = Number(CUR_SEND_DATE.substring(0, 4)) + "/" + CUR_SEND_DATE.substring(4, 6) + "/" + CUR_SEND_DATE.substring(6, 8);
            //당월1일 셋팅
            MReqDate = MdateAdd(MsendDate, 1); 
            HReqDate = curSendDate + "01"; 
            
            //현재일자가 10일 전(매월 9일까지) 검수요청일자 전월1일부터 소급 가능
            //현재일자가 10일 이후(매월 10일부터) 검수요청일자 당월 1일부터 소급
            if( curReqDate > Number(CUR_DATE)){
            	if( LReqDate > Number(EVF.V("SEND_DATE")) ) {
                	return EVF.alert("검수요청일자는 전월 1일부터 이후로 선택하세요"); // 검수요청일자는 현재일자 이후로 선택하세요.
                }
            	
            } else if (curReqDate <= Number(CUR_DATE)){
	        	if( Number(HReqDate) > Number(EVF.V("SEND_DATE")) ) {
	            	return EVF.alert("검수요청일자는 당월 1일부터 이후로 선택하세요"); // 검수요청일자는 현재일자 이후로 선택하세요.
	            }
	        }
            
            // 2021.04.28 (검수요청일자 >= 현재일자)
            //if( Number(EVF.V("CUR_DATE")) > Number(EVF.V("SEND_DATE")) ) {
            //	return EVF.alert("${SPOI0051_017}"); // 검수요청일자는 현재일자 이후로 선택하세요.
            //}
            
            if( EVF.isEmpty(EVF.V("INV_AMT")) || EVF.V("INV_AMT") == 0 ) {
                return EVF.alert("${SPOI0051_010}");
            }
			
			if(!gridPODT.validate(true).flag) { return EVF.alert(gridPODT.validate().msg); }
            
            var allRowId = gridPODT.getAllRowId();
            for(var i in allRowId) {
                var rowIdx = allRowId[i];
                if(gridPODT.getCellValue(rowIdx, "ITEM_AMT") != gridPODT.getCellValue(rowIdx, "SUM_INV_AMT")) {
	                if( EVF.isEmpty(gridPODT.getCellValue(rowIdx, "INV_QT")) || gridPODT.getCellValue(rowIdx, "INV_QT") == 0 ) {
	                    return EVF.alert("${SPOI0051_018}");
	                }
                }
                
                if( gridPODT.getCellValue(rowIdx, "INV_QT") > gridPODT.getCellValue(rowIdx, "PO_RE_QT") ) {
                    return EVF.alert("${SPOI0051_008}");
                }
                
                if( gridPODT.getCellValue(rowIdx, "INV_AMT") > gridPODT.getCellValue(rowIdx, "PO_RE_AMT") ) {
                    return EVF.alert("${SPOI0051_007}");
                }
            }
            
            var ItemConfirmMessage = "품목정보의 품목별 검수요청금액과 고객사별 지급예정금액 확인 하셨습니까?";
            var SendMessage = "${SPOI0051_005}";
         	// 검수요청금액과 지급예정금액이 같지 않은 경우
            var payAmt = Number(EVF.V("PAY_AMT")); // 지급예정금액
            var invAmt = Number(EVF.V("INV_AMT")); // 검수요청금액
            if(payAmt != invAmt) {
            	if( invAmt > payAmt ) {
                	return EVF.alert("검수요청금액은 지급예정금액 이내에서 요청 가능합니다.");
            	} else if( invAmt != payAmt ) {
            		SendMessage = "지급예정금액과 검수요청금액이 일치하지 않습니다.\n\n이대로 검수요청 하시겠습니까?";
            	}
            }
            EVF.confirm(ItemConfirmMessage, function () {
	            EVF.confirm(SendMessage, function () {
	            	if(localServerFlag == "Y") {
	            		doSendGo();
					} else {
		                document.reqForm.signData.value = EVF.V("VENDOR_CD") + "@@" + document.reqForm.idn.value + "@@" + EVF.V("INV_AMT") + "@@" + "${signDate}";
	
		                var certOdiFilter = "${certOidfilter}";
		                var listOdiArr = certOdiFilter.split(";");
		                var certOidfilter = "";
		                for(var i in listOdiArr) {
		                    certOidfilter = certOidfilter + listOdiArr[i] + ",";
		                }
	
		                certOidfilter = certOidfilter.substring(0, certOidfilter.length-1);
		                magicline.uiapi.MakeSignData(document.reqForm, null, mlCallBack, certOidfilter);
					}
	            });
            });
        }

        function mlCallBack(code, message){
            if(code == 0){ <%-- 정상메시지 --%>
                if (message.encMsg != null) { document.reqForm.signedData.value = encodeURIComponent(message.encMsg); }
                if (message.vidRandom != null) { document.reqForm.vidRandom.value = encodeURIComponent(message.vidRandom); }
                doSendGo();
            }
            else {
                return EVF.alert("결과값 수신에 실패하였습니다.");
            }
        }

        function doSendGo() {
            var store = new EVF.Store();
            store.setGrid([gridPODT]);
            store.getGridData(gridPODT, "all");
            store.setParameter("signedData", document.reqForm.signedData.value);
            store.setParameter("vidRandom", document.reqForm.vidRandom.value);
            store.setParameter("idn", document.reqForm.idn.value);
            store.doFileUpload(function () {
                store.load(baseUrl + "spoi0051_doSend.so", function(){
                    EVF.alert(this.getResponseMessage(), function() {
						if(opener) {
                            opener.doSearch();
                            doClose();
                        } else {
                        	window.location.href = '/nhepro/SPOR/SPOI0051/view.so'
                        }
                    });
                });
            });
        }

        function doDelete() {
            var store = new EVF.Store();
            EVF.confirm("${SPOI0051_006}", function () {
                store.setGrid([gridPODT]);
                store.getGridData(gridPODT, "all");
                store.doFileUpload(function () {
                    store.load(baseUrl + "spoi0051_doDelete.so", function(){
                        EVF.alert(this.getResponseMessage(), function() {
                            if(opener) {
                                opener.doSearch();
                                doClose();
                            } else {
                            	window.location.href = '/nhepro/SPOR/SPOI0051/view.so'
                            }
                        });
                    });
                });
            });
        }

        function doClose() {
            EVF.closeWindow();
        }
    </script>

    <e:window id="SPOI0051" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">
        <e:inputHidden id="BUYER_CD" name="BUYER_CD" value="${formData.BUYER_CD}"/>
        <e:inputHidden id="DEPT_CD" name="DEPT_CD" value="${formData.DEPT_CD}"/>
        <e:inputHidden id="PIC_USER_ID" name="PIC_USER_ID" value="${formData.PIC_USER_ID}"/>
        <e:inputHidden id="RMK_TEXT_NUM" name="RMK_TEXT_NUM" value="${formData.RMK_TEXT_NUM }" />
        <e:inputHidden id="CTRL_USER_ID" name="CTRL_USER_ID" value="${formData.CTRL_USER_ID }" />
        <e:inputHidden id="INSPECT_USER_ID" name="INSPECT_USER_ID" value="${formData.INSPECT_USER_ID }" />
        <e:inputHidden id="OLD_INV_AMT" name="OLD_INV_AMT" value="${formData.INV_AMT }" />
        <e:inputHidden id="OLD_VAT_AMT" name="OLD_VAT_AMT" value="${formData.VAT_AMT }" />
        <e:inputHidden id="INSU_STATUS" name="INSU_STATUS" value="${formData.INSU_STATUS }" />
        <e:inputHidden id="PAY_CNT_AMT" name="PAY_CNT_AMT" />
		<e:inputHidden id="CUR_DATE" name="CUR_DATE" value="${CUR_DATE }" />	<!-- 현재일자 -->
		<e:inputHidden id="CUR_SEND_DATE" name="CUR_SEND_DATE" value="${CUR_SEND_DATE }" />	<!-- 현재일자 -->
		
        <e:buttonBar width="100%" align="right" title="${SPOI0051_001}">
            <e:button id="doSave" name="doSave" label="${doSave_N}" onClick="doSave" disabled="${doSave_D}" visible="${doSave_V}"/>
            <e:button id="doSend" name="doSend" label="${doSend_N}" onClick="doSend" disabled="${doSend_D}" visible="${doSend_V}"/>
            <e:button id="doDelete" name="doDelete" label="${doDelete_N}" onClick="doDelete" disabled="${doDelete_D}" visible="${doDelete_V}"/>
            <e:button id="doClose" name="doClose" label="${doClose_N}" onClick="doClose" disabled="${doClose_D}" visible="${doClose_V}"/>
        </e:buttonBar>

		<%--일반정보--%>
        <e:searchPanel id="sp" title="${form_CAPTION_N}" labelWidth="${labelWidth}" useTitleBar="false" width="100%" columnCount="2" onEnter="">
            <e:row>
                <e:label for="INV_NUM" title="${form_INV_NUM_N}" />
                <e:field>
                    <e:inputText id="INV_NUM" name="INV_NUM" value="${formData.INV_NUM}" width="${form_INV_NUM_W}" maxLength="${form_INV_NUM_M}" disabled="${form_INV_NUM_D}" readOnly="${form_INV_NUM_RO}" required="${form_INV_NUM_R}" style="${imeMode}" maskType="${form_INV_NUM_MT}"/>
                </e:field>
                <e:label for="PO_CREATE_TYPE" title="${form_PO_CREATE_TYPE_N}"/>
                <e:field>
                    <e:select id="PO_CREATE_TYPE" name="PO_CREATE_TYPE" value="${formData.PO_CREATE_TYPE}" options="${poCreateTypeOptions}" width="${form_PO_CREATE_TYPE_W}" disabled="${form_PO_CREATE_TYPE_D}" readOnly="${form_PO_CREATE_TYPE_RO}" required="${form_PO_CREATE_TYPE_R}" placeHolder="" maskType="${form_PO_CREATE_TYPE_MT}" />
                </e:field>
            </e:row>

            <e:row>
                <e:label for="VENDOR_CD" title="${form_VENDOR_CD_N}" />
                <e:field>
                    <e:inputText id="VENDOR_CD" name="VENDOR_CD" value="${formData.VENDOR_CD}" width="${form_VENDOR_CD_W}" maxLength="${form_VENDOR_CD_M}" disabled="${form_VENDOR_CD_D}" readOnly="${form_VENDOR_CD_RO}" required="${form_VENDOR_CD_R}" style="${imeMode}" maskType="${form_VENDOR_CD_MT}"/>
                    <e:text>&nbsp;</e:text>
                    <e:inputText id="VENDOR_NM" name="VENDOR_NM" value="${formData.VENDOR_NM}" width="${form_VENDOR_NM_W}" maxLength="${form_VENDOR_NM_M}" disabled="${form_VENDOR_NM_D}" readOnly="${form_VENDOR_NM_RO}" required="${form_VENDOR_NM_R}" style="${imeMode}" maskType="${form_VENDOR_NM_MT}"/>
                </e:field>
                <e:label for="PIC_USER_NM" title="${form_PIC_USER_NM_N}" />
                <e:field>
                    <e:inputText id="PIC_USER_NM" name="PIC_USER_NM" value="${formData.PIC_USER_NM}" width="${form_PIC_USER_NM_W}" maxLength="${form_PIC_USER_NM_M}" disabled="${form_PIC_USER_NM_D}" readOnly="${form_PIC_USER_NM_RO}" required="${form_PIC_USER_NM_R}" style="${imeMode}" maskType="${form_PIC_USER_NM_MT}"/>
                </e:field>
            </e:row>

            <e:row>
                <e:label for="PIC_TEL_NUM" title="${form_PIC_TEL_NUM_N}" />
                <e:field>
                    <e:inputText id="PIC_TEL_NUM" name="PIC_TEL_NUM" value="${formData.PIC_TEL_NUM}" width="${form_PIC_TEL_NUM_W}" maxLength="${form_PIC_TEL_NUM_M}" disabled="${form_PIC_TEL_NUM_D}" readOnly="${form_PIC_TEL_NUM_RO}" required="${form_PIC_TEL_NUM_R}" style="${imeMode}" maskType="${form_PIC_TEL_NUM_MT}"/>
                </e:field>
                <e:label for="PIC_CELL_NUM" title="${form_PIC_CELL_NUM_N}" />
                <e:field>
                    <e:inputText id="PIC_CELL_NUM" name="PIC_CELL_NUM" value="${formData.PIC_CELL_NUM}" width="${form_PIC_CELL_NUM_W}" maxLength="${form_PIC_CELL_NUM_M}" disabled="${form_PIC_CELL_NUM_D}" readOnly="${form_PIC_CELL_NUM_RO}" required="${form_PIC_CELL_NUM_R}" style="${imeMode}" maskType="${form_PIC_CELL_NUM_MT}"/>
                    <e:text>(Ex:010-1234-5678, 검수요청서 승인/반려시 SMS수신)</e:text>
                </e:field>
            </e:row>

            <e:row>
                <e:label for="SEND_DATE" title="${form_SEND_DATE_N}"/>
                <e:field>
                    <e:inputDate id="SEND_DATE" name="SEND_DATE" value="${formData.SEND_DATE}" width="${inputDateWidth}" datePicker="true" required="${form_SEND_DATE_R}" disabled="${form_SEND_DATE_D}" readOnly="${form_SEND_DATE_RO}" />
                </e:field>
                <e:label for="PAY_CNT" title="${form_PAY_CNT_N}"/>
                <e:field>
                    <e:inputNumber id="PAY_CNT" name="PAY_CNT" value="${formData.PAY_CNT}" width="${form_PAY_CNT_W}" maxValue="${form_PAY_CNT_M}" decimalPlace="${form_PAY_CNT_NF}" disabled="${form_PAY_CNT_D}" readOnly="${form_PAY_CNT_RO}" required="${form_PAY_CNT_R}" onNumberKr="${form_PAY_CNT_KR}" currencyText="${form_PAY_CNT_CT}"/>
                    <e:text>/</e:text>
                    <e:inputText id="PAY_CNT_NM" name="PAY_CNT_NM" value="${formData.PAY_CNT_NM}" width="${form_PAY_CNT_NM_W}" maxLength="${form_PAY_CNT_NM_M}" disabled="${form_PAY_CNT_NM_D}" readOnly="${form_PAY_CNT_NM_RO}" required="${form_PAY_CNT_NM_R}" style="${imeMode}" maskType="${form_PAY_CNT_NM_MT}"/>
                </e:field>
            </e:row>

            <e:row>
                <e:label for="PAY_PERCENT" title="${form_PAY_PERCENT_N}"/>
                <e:field>
                    <e:inputNumber id="PAY_PERCENT" name="PAY_PERCENT" value="${formData.PAY_PERCENT}" width="${form_PAY_PERCENT_W}" maxValue="${form_PAY_PERCENT_M}" decimalPlace="${form_PAY_PERCENT_NF}" disabled="${form_PAY_PERCENT_D}" readOnly="${form_PAY_PERCENT_RO}" required="${form_PAY_PERCENT_R}" onNumberKr="${form_PAY_PERCENT_KR}" currencyText="${form_PAY_PERCENT_CT}"/>
                </e:field>
                <e:label for="PAY_AMT" title="${form_PAY_AMT_N}"/>
                <e:field>
                    <e:inputNumber id="PAY_AMT" name="PAY_AMT" value="${formData.PAY_AMT}" width="${form_PAY_AMT_W}" maxValue="${form_PAY_AMT_M}" decimalPlace="${form_PAY_AMT_NF}" disabled="${form_PAY_AMT_D}" readOnly="${form_PAY_AMT_RO}" required="${form_PAY_AMT_R}" onNumberKr="${form_PAY_AMT_KR}" currencyText="${form_PAY_AMT_CT}"/>
                </e:field>
            </e:row>

            <e:row>
                <e:label for="SUBJECT" title="${form_SUBJECT_N}" />
                <e:field colSpan="3">
                    <e:inputText id="SUBJECT" name="SUBJECT" value="${formData.SUBJECT}" width="${form_SUBJECT_W}" maxLength="${form_SUBJECT_M}" disabled="${form_SUBJECT_D}" readOnly="${form_SUBJECT_RO}" required="${form_SUBJECT_R}" style="${imeMode}" maskType="${form_SUBJECT_MT}"/>
                </e:field>
            </e:row>

            <e:row>
                <e:label for="PO_CREATE_DATE" title="${form_PO_CREATE_DATE_N}"/>
                <e:field>
                    <e:inputDate id="PO_CREATE_DATE" name="PO_CREATE_DATE" value="${formData.PO_CREATE_DATE}" width="${inputDateWidth}" datePicker="true" required="${form_PO_CREATE_DATE_R}" disabled="${form_PO_CREATE_DATE_D}" readOnly="${form_PO_CREATE_DATE_RO}" />
                </e:field>
                <e:label for="PO_NUM" title="${form_PO_NUM_N}" />
                <e:field>
                    <e:inputText id="PO_NUM" name="PO_NUM" value="${formData.PO_NUM}" width="${form_PO_NUM_W}" maxLength="${form_PO_NUM_M}" disabled="${form_PO_NUM_D}" readOnly="${form_PO_NUM_RO}" required="${form_PO_NUM_R}" style="${imeMode}" maskType="${form_PO_NUM_MT}"/>
                </e:field>
            </e:row>

            <e:row>
                <e:label for="CTRL_USER_NM" title="${form_CTRL_USER_NM_N}" />
                <e:field>
                    <e:inputText id="CTRL_USER_NM" name="CTRL_USER_NM" value="${formData.CTRL_USER_NM}" width="${form_CTRL_USER_NM_W}" maxLength="${form_CTRL_USER_NM_M}" disabled="${form_CTRL_USER_NM_D}" readOnly="${form_CTRL_USER_NM_RO}" required="${form_CTRL_USER_NM_R}" style="${imeMode}" maskType="${form_CTRL_USER_NM_MT}"/>
                </e:field>
                <e:label for="INSPECT_USER_NM" title="${form_INSPECT_USER_NM_N}" />
                <e:field>
                    <e:inputText id="INSPECT_USER_NM" name="INSPECT_USER_NM" value="${formData.INSPECT_USER_NM}" width="${form_INSPECT_USER_NM_W}" maxLength="${form_INSPECT_USER_NM_M}" disabled="${form_INSPECT_USER_NM_D}" readOnly="${form_INSPECT_USER_NM_RO}" required="${form_INSPECT_USER_NM_R}" style="${imeMode}" maskType="${form_INSPECT_USER_NM_MT}"/>
                </e:field>
            </e:row>

            <e:row>
                <e:label for="PAY_TERMS" title="${form_PAY_TERMS_N}"/>
                <e:field>
                    <e:select id="PAY_TERMS" name="PAY_TERMS" value="${formData.PAY_TERMS}" options="${payTermsOptions}" width="${form_PAY_TERMS_W}" disabled="${form_PAY_TERMS_D}" readOnly="${form_PAY_TERMS_RO}" required="${form_PAY_TERMS_R}" placeHolder="" maskType="${form_PAY_TERMS_MT}" />
                </e:field>
                <e:label for="PO_AMT" title="${form_PO_AMT_N}"/>
                <e:field>
                    <e:inputNumber id="PO_AMT" name="PO_AMT" value="${formData.PO_AMT}" width="${form_PO_AMT_W}" maxValue="${form_PO_AMT_M}" decimalPlace="${form_PO_AMT_NF}" disabled="${form_PO_AMT_D}" readOnly="${form_PO_AMT_RO}" required="${form_PO_AMT_R}" onNumberKr="${form_PO_AMT_KR}" currencyText="${form_PO_AMT_CT}"/>
                </e:field>
            </e:row>

            <e:row>
                <e:label for="CUR" title="${form_CUR_N}"/>
                <e:field>
                    <e:select id="CUR" name="CUR" value="${formData.CUR}" options="${curOptions}" width="${form_CUR_W}" disabled="${form_CUR_D}" readOnly="${form_CUR_RO}" required="${form_CUR_R}" placeHolder="" maskType="${form_CUR_MT}" />
                </e:field>
                <e:label for="VAT_TYPE" title="${form_VAT_TYPE_N}"/>
                <e:field>
                    <e:select id="VAT_TYPE" name="VAT_TYPE" value="${formData.VAT_TYPE}" options="${vatTypeOptions}" width="${form_VAT_TYPE_W}" disabled="${form_VAT_TYPE_D}" readOnly="${form_VAT_TYPE_RO}" required="${form_VAT_TYPE_R}" placeHolder="" maskType="${form_VAT_TYPE_MT}" />
                </e:field>
            </e:row>

            <e:row>
                <e:label for="INV_AMT" title="${form_INV_AMT_N}"/>
                <e:field>
                    <e:inputNumber id="INV_AMT" name="INV_AMT" value="${formData.INV_AMT}" onChange="onChangeINV_AMT" width="${form_INV_AMT_W}" maxValue="${form_INV_AMT_M}" decimalPlace="${form_INV_AMT_NF}" disabled="${form_INV_AMT_D}" readOnly="${form_INV_AMT_RO}" required="${form_INV_AMT_R}" onNumberKr="${form_INV_AMT_KR}" currencyText="${form_INV_AMT_CT}"/>
                    <br>
                    <e:text style="font-weight: bold; font-size: 10pt;">('지급예정금액'과 다를 경우 하단 '품목정보'의 '검수요청금액'을 변경하세요)</e:text>
                </e:field>
                <e:label for="VAT_AMT" title="${form_VAT_AMT_N}"/>
                <e:field>
                    <e:inputNumber id="VAT_AMT" name="VAT_AMT" value="${formData.VAT_AMT}" width="${form_VAT_AMT_W}" maxValue="${form_VAT_AMT_M}" decimalPlace="${form_VAT_AMT_NF}" disabled="${form_VAT_AMT_D}" readOnly="${form_VAT_AMT_RO}" required="${form_VAT_AMT_R}" onNumberKr="${form_VAT_AMT_KR}" currencyText="${form_VAT_AMT_CT}"/>
                </e:field>
            </e:row>

            <e:row>
                <e:label for="RMK_TEXT_NUM" title="${form_RMK_TEXT_NUM_N}" />
                <e:field colSpan="3">
                    <e:richTextEditor id="RMK_TEXT" name="RMK_TEXT" value="${formData.RMK_TEXT}" width="${form_RMK_TEXT_NUM_W}" height="180px" disabled="${form_RMK_TEXT_NUM_D}" readOnly="${form_RMK_TEXT_NUM_RO}" required="${form_RMK_TEXT_NUM_R}" style="${imeMode}"/>
                </e:field>
            </e:row>

            <e:row>
                <e:label for="ATT_FILE_NUM" title="${form_ATT_FILE_NUM_N}" />
                <e:field colSpan="3">
                    <e:fileManager id="ATT_FILE_NUM" width="${form_ATT_FILE_NUM_W}" height="80px" fileId="${formData.ATT_FILE_NUM}" bizType="OM" readOnly="${form_ATT_FILE_NUM_RO}" required="${form_ATT_FILE_NUM_R}"/>
                </e:field>
            </e:row>
        </e:searchPanel>

        <%--품목정보--%>
        <e:buttonBar width="100%" align="right" title="${SPOI0051_002}">
        	<e:text style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;■ 지급예정금액 : </e:text>
        	<e:inputNumber id="PAY_AMT_TEXT" name="PAY_AMT_TEXT" value="${formData.PAY_AMT}" width="140" maxValue="${form_PAY_AMT_M}" decimalPlace="${form_PAY_AMT_NF}" disabled="${form_PAY_AMT_D}" readOnly="${form_PAY_AMT_RO}" required="${form_PAY_AMT_R}" onNumberKr="${form_PAY_AMT_KR}" currencyText="${form_PAY_AMT_CT}"/>
        	<e:text style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;■ 검수요청금액 : </e:text>
        	<e:inputNumber id="INV_AMT_TEXT" name="INV_AMT_TEXT" value="${formData.INV_AMT}" width="140" maxValue="${form_INV_AMT_M}" decimalPlace="${form_INV_AMT_NF}" disabled="${form_INV_AMT_D}" readOnly="${form_INV_AMT_RO}" required="${form_INV_AMT_R}" onNumberKr="${form_INV_AMT_KR}" currencyText="${form_INV_AMT_CT}"/>
        	<e:text style="font-weight: bold; font-size: 10pt;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;▶ 금액을 필히 확인하세요 ◀</e:text>
        </e:buttonBar>
        <e:gridPanel id="gridPODT" name="gridPODT" width="100%" height="280px" gridType="${_gridType}" readOnly="${param.detailView}" />
		
		<%--지불고객사--%>
        <e:buttonBar width="100%" align="right" title="${SPOI0051_019}"/>
        <e:gridPanel id="gridPOPC" name="gridPOPC" width="100%" height="210px" gridType="${_gridType}" readOnly="${param.detailView}" />
        
        <%--검수요청상세--%>
        <e:buttonBar width="100%" align="right" title="${SPOI0051_003}">
        </e:buttonBar>
        <e:gridPanel id="gridIVGH" name="gridIVGH" width="100%" height="200px" gridType="${_gridType}" readOnly="${param.detailView}" />

        <form id="reqForm" name="reqForm" method="post" action="/MagicLine4Web/ML4Web/jcaosCheck.jsp">
            <input type="hidden" id="signData" name="signData" value="Login"/>
            <input type="hidden" id="signedData" name="signedData"/>
            <input type="hidden" id="vidRandom" name="vidRandom"/>
            <input type="hidden" id="vidType" name="vidType" value="client"/>
            <input type="hidden" id="idn" name="idn" value="${formData.IRS_NO}"/>
        </form>

        <div id="dscertContainer">
            <iframe id="dscert" name="dscert" src="" width="100%" height="100%" frameborder="0" allowTransparency="true" style="position:fixed;z-index:100010;top:0px;left:0px;width:100%;height:100%;"></iframe>
        </div>
    </e:window>
</e:ui>