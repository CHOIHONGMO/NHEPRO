<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">

	<script type="text/javascript">

        var gridHD; var gridDT;
	    var isDetailView = ('${param.detailView}' === 'true' ? true : false);
		var baseUrl = "/nhepro/CBDR/";
		var maxProgressCd;

	    function init() {
            gridHD = EVF.C("gridHD");
            gridDT = EVF.C("gridDT");

			gridHD._gvo.setColumnProperty(gridHD._gvo.columnByField("SAVING_RATE"), "header", {text:"절감율(%)\n(A-C)/A"});
			gridHD._gvo.setColumnProperty(gridHD._gvo.columnByField("SETTLE_RATE"), "header", {text:"낙찰율(%)\n(B-C)/B"});

            gridHD.cellClickEvent(function(rowIdx, colIdx, value) {
                if (colIdx == 'BID_RMK') {
                    var param = {
                        title: "${CBDR0033_T025}",
                        message: gridHD.getCellValue(rowIdx, 'BID_RMK'),
                        callbackFunction: 'setRMK',
                        rowIdx: rowIdx
                    };
                    if( isDetailView ) {
                        everPopup.commonTextView(param);
                    } else {
                        everPopup.commonTextInput(param);
                    }
                }
            });

            gridDT.cellClickEvent(function(rowIdx, colIdx, value) {

                if (isDetailView == false) {
                    if(colIdx == "multiSelect" || colIdx == "VENDOR_NM") {
                        var contType2 = EVF.V("CONT_TYPE2");
                        if(contType2 == "LP" || contType2 == "TD" || contType2 == "TS") {
                        	if(colIdx == "VENDOR_NM") {
                            	gridDT.checkAll(false, false, false, false);
                        		gridDT.checkRow(rowIdx, true, false, false);
                        	}

                        	if (colIdx == "multiSelect" && value == "0"){
                        		gridHD.delAllRow();
                        	} else {
                            	vendorNmClickEvent(rowIdx);
                        	}
                        }
                    }
                }
                
                if(colIdx == "VENDOR_CD") {
                    param = {
                        VENDOR_CD: value,
                        detailView: true,
                        popupFlag: true,
                        buttonView: false
                    };
                    everPopup.openPopupByScreenId("CVNR0011", 1000, 730, param);
                }
                
                // 2021.05.13 변경
                // 2021.03.03 : 협력업체 가격입찰 시 첨부파일 그리드 추가
                if(colIdx == "ATT_FILE_CNT") {
                	if( value == "0" ) return;
                    var param = {
                        attFileNum: gridDT.getCellValue(rowIdx, 'ATT_FILE_NUM'),
                        rowIdx: rowIdx,
                        callBackFunction: '',
                        bizType: 'CBDR',
                        detailView : true
                    };
                    everPopup.fileAttachPopup(param);
                }
            });

            var multiSelectFlag = false;
            if (EVF.V('CONT_TYPE2') == "LP" || EVF.V('CONT_TYPE2') == "TD" || EVF.V('CONT_TYPE2') == "TS") {
            	if (!(EVF.V("BID_STATUS") == "1300" || EVF.V("BID_STATUS") == "2500")) {
            		multiSelectFlag = true;
            	}
            }

            gridHD.setProperty('shrinkToFit', true);                    // 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
            gridHD.setProperty('rowNumbers', ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
            gridHD.setProperty('sortable', ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
            gridHD.setProperty('panelVisible', ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            gridHD.setProperty('enterToNextRow', ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            gridHD.setProperty('acceptZero', ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            gridHD.setProperty('singleSelect', ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]
            gridHD.setProperty('multiSelect', false);                   // [선택] 컬럼의 사용여부를 지정한다. [true/false]

            gridDT.setProperty('shrinkToFit', ${shrinkToFit});
            gridDT.setProperty('rowNumbers', ${rowNumbers});
            gridDT.setProperty('sortable', ${sortable});
            gridDT.setProperty('panelVisible', ${panelVisible});
            gridDT.setProperty('enterToNextRow', ${enterToNextRow});
            gridDT.setProperty('acceptZero', ${acceptZero});
            gridDT.setProperty('singleSelect', true);
            gridDT.setProperty('multiSelect', multiSelectFlag);
            
            if("${rtnMsg}" == "WRONGCERT") {
                EVF.C('Lottery').setVisible(false);
                EVF.C('SuccessfulBid').setVisible(false);
                EVF.C('ReBid').setVisible(false);
                EVF.C('ReAnn').setVisible(false);
                EVF.C('TotalSB').setVisible(false);
                EVF.C('QualifiedTest').setVisible(false);
                return EVF.alert("${CBDR0033_T021}");
            }
            else {
                if(EVF.V('DIFF_GUAR_FLAG') != "1") {
                    gridHD.hideCol("DIFF_GUAR_AMT", true);
                }

                <%-- 계약방법(2)가 “최저가(LP)”, “2단계경쟁(TD, TS)”인 경우, 추첨, 낙찰, 유찰, 재입찰, 재공고 Button visible --%>
                if(EVF.V('CONT_TYPE2') == "LP" || EVF.V('CONT_TYPE2') == "TD" || EVF.V('CONT_TYPE2') == "TS") {
                    EVF.C('QualifiedTest').setVisible(false);
                    EVF.C('TotalSB').setVisible(false);
                } else {
                    gridHD.hideCol("BID_RMK", true);
                }
                <%-- 계약방법(2)가 “적격심사(QE)”인 경우, 적격심사 Button visible --%>
                if(EVF.V('CONT_TYPE2') == "QE") {
                    EVF.C('Lottery').setVisible(false);
                    EVF.C('SuccessfulBid').setVisible(false);
                    EVF.C('FailBid').setVisible(false);
                    EVF.C('ReBid').setVisible(false);
                    EVF.C('ReAnn').setVisible(false);
                    EVF.C('TotalSB').setVisible(false);
                }
                <%-- 계약방법(2)가 “협상에 의한 계약(NE)“인 경우, 종합낙찰제 Button visible --%>
                if(EVF.V('CONT_TYPE2') == "NE") {
                    EVF.C('Lottery').setVisible(false);
                    EVF.C('SuccessfulBid').setVisible(false);
                    EVF.C('FailBid').setVisible(false);
                    EVF.C('ReBid').setVisible(false);
                    EVF.C('ReAnn').setVisible(false);
                    EVF.C('QualifiedTest').setVisible(false);
                }

                if(${havePermission}) {
                    EVF.C('Lottery').setDisabled(false);
                    EVF.C('SuccessfulBid').setDisabled(false);
                    EVF.C('FailBid').setDisabled(false);
                    EVF.C('ReBid').setDisabled(false);
                    EVF.C('ReAnn').setDisabled(false);
                    EVF.C('QualifiedTest').setDisabled(false);
                    EVF.C('TotalSB').setDisabled(false);
                } else {
                	if(EVF.V("DOC_TYPE") != '' || EVF.V("DOC_TYPE") == 'NEGORLT' ){
                		EVF.C('Lottery').setDisabled(true);
                        EVF.C('SuccessfulBid').setDisabled(true);
                        EVF.C('FailBid').setDisabled(true);
                        EVF.C('ReBid').setDisabled(true);
                        EVF.C('ReAnn').setDisabled(true);
                        EVF.C('QualifiedTest').setDisabled(true);
                        EVF.C('TotalSB').setDisabled(false);
                	} else {
                		EVF.C('Lottery').setDisabled(true);
                        EVF.C('SuccessfulBid').setDisabled(true);
                        EVF.C('FailBid').setDisabled(true);
                        EVF.C('ReBid').setDisabled(true);
                        EVF.C('ReAnn').setDisabled(true);
                        EVF.C('QualifiedTest').setDisabled(true);
                        EVF.C('TotalSB').setDisabled(true);
                	}
                }

                if(EVF.V("BID_STATUS") == "1300" || EVF.V("BID_STATUS") == "2500") {
                    EVF.C('Lottery').setVisible(false);
                    EVF.C('SuccessfulBid').setVisible(false);
                    EVF.C('FailBid').setVisible(false);
                    EVF.C('ReBid').setVisible(false);
                    EVF.C('ReAnn').setVisible(false);
                    if(EVF.V('CONT_TYPE2') == "QE") {
                        EVF.C('QualifiedTest').setDisabled(false);
                    } else {
                    	EVF.C('QualifiedTest').setVisible(false);
                    }
                    if(EVF.V('CONT_TYPE2') == "NE") {
                        EVF.C('TotalSB').setDisabled(false);
                    } else {
                    	EVF.C('TotalSB').setVisible(false);
                    }
                }

                var cols = [];
                var col = [];
                var cnt = 0;
                <c:forEach varStatus="status" var="columnx" items="${columnInfos}">
                    gridDT.createColumn('${columnx.COLUMN_ID}', '${columnx.COLUMN_NM}', 150, 'right', 'number', 50, false, false, '', 3);
                    col.push('${columnx.COLUMN_ID}');
                    cols[cnt] = col;
                    col = [];
                    cnt++;
                </c:forEach>

                if(EVF.V('CONT_TYPE2')  != "LP") {
                    gridDT.hideCol("TOTAL_LIABILITY_RATE", true);
                    gridDT.hideCol("CURRENT_ASSET_LIABILITY_RATE", true);
                }

                doSearchVendorVO();
            }
        }

	    function doSearchVendorVO() {

            var store = new EVF.Store();
            if(!store.validate()) { return; }

            store.setGrid([gridDT]);
            store.setParameter("voteLimitCnt", EVF.V("VOTE_LIMIT_CNT"));
            store.load(baseUrl + 'cbdr0033_doSearchVendorVO.so', function() {

                var viewLotteryFlag = this.getParameter("viewLotteryFlag");

                if(gridDT.getRowCount() == 0) {
                    EVF.alert("${msg.M0002 }");
                } else {
                    if(EVF.V('CONT_TYPE2') == "LP" || EVF.V('CONT_TYPE2') == "TD" || EVF.V('CONT_TYPE2') == "TS") {
                        if (viewLotteryFlag != "Y") {
                            EVF.C('Lottery').setVisible(false);
                            if (EVF.V("BID_STATUS") != "1300" && EVF.V("BID_STATUS") != "2500") {
                                EVF.C('SuccessfulBid').setVisible(true);
                            }
                        } else {
                            EVF.C('SuccessfulBid').setVisible(false);
                        }
                    }

                    if (EVF.V("BID_STATUS") == "2500") {
                        var rowIdx = -1;
                        var rowIds = gridDT.getAllRowId();
                        var settleVendor = EVF.V("SETTLE_VENDOR");
                        if(EVF.isEmpty(settleVendor) || settleVendor == "") {
                            rowIdx = rowIds[0];
                        } else {
                            for(var i in rowIds) {
                                if(gridDT.getCellValue(rowIds[i], 'VENDOR_CD') == settleVendor) {
                                    rowIdx = rowIds[i];
                                    break;
                                }
                            }
                        }

                        //gridDT.checkRow(rowIdx, true, false, false);
                        vendorNmClickEvent(rowIdx);
                    }
                    
                    setHideGrid();
                }
            });
        }
	    
	    function setHideGrid() {
	    	if(EVF.V('CONT_TYPE2') == "TD" || EVF.V('CONT_TYPE2') == "TS") {
	    		gridDT.hideCol("EV_FINAL_FLAG", false);
	    	} else {
	    		gridDT.hideCol("EV_FINAL_FLAG", true);
	    	}
	    }

        function setRMK(data) {
            gridHD.setCellValue(data.rowIdx, "BID_RMK", data.message);
            gridHD.setColIconify("BID_RMK", "BID_RMK", "comment", false);
        }

        function doLottery() {

            EVF.confirm("${CBDR0033_T013 }", function () {
                var store = new EVF.Store();
                store.setGrid([gridDT]);
                store.getGridData(gridDT, 'all');
                store.load(baseUrl + 'cbdr0033_doLottery.so', function() {
                    EVF.alert(this.getResponseMessage(), function() {
                        doSearchVendorVO();
                    });
                });
            });
        }

        function doSuccessfulBid() {

            var popupFlag = ${(param.popupFlag == null || !param.popupFlag) ? false : true};

            gridHD.checkAll(true);
            gridDT.checkAll(true);

            if (gridHD.getSelRowCount() == 0) { return EVF.alert("${CBDR0033_T014}"); }

            var confirmMsg = "${CBDR0033_T015 }";
            var rowIds = gridHD.getSelRowId();
            for(var i in rowIds) {

                <%-- 1.예정가격(없으면 예산금액)을 초과한 경우, 낙찰시킬 수 없다. --%>
                var standardAmt = Number(gridHD.getCellValue(rowIds[i], 'PRESUM_AMT'));
                if(EVF.isEmpty(standardAmt) || standardAmt == 0) {
                    standardAmt = Number(gridHD.getCellValue(rowIds[i], 'PR_AMT'));
                }
                if(Number(gridHD.getCellValue(rowIds[i], 'BID_AMT')) > standardAmt) {
                    return EVF.alert("${CBDR0033_T016}");
                }

                <%-- 2.재무건전성 체크가 없는 경우는 skip하여 낙찰 --%>
                if(EVF.V("FINA_SOLV_FLAG") == "1") {

                	<%-- 3.예정가격비율 이상인 경우 skip하여 낙찰 --%>
                    var estmLimitRate = Number(EVF.V("ESTM_LIMIT_RATE"));
                    if(Number(gridHD.getCellValue(rowIds[i], 'BID_AMT')) < everMath.round_float(standardAmt * (estmLimitRate / 100))) {

                    	<%-- 4.부채비율 이하 && 유동비율 이상인 경우 skip하여 낙찰 --%>
                    	if(!((Number(EVF.V("RATE_SDEPT")) >= Number(gridHD.getCellValue(rowIds[i], 'TOTAL_LIABILITY_RATE'))) &&
                    	     (Number(EVF.V("RATE_CURR")) <= Number(gridHD.getCellValue(rowIds[i], 'CURRENT_ASSET_LIABILITY_RATE'))))) {

                            <%-- 5.차액보증여부가 'Y'인 경우 skip하여 낙찰 --%>
                            if(EVF.V("DIFF_GUAR_FLAG") == "1") {

                            	var bidAmt = Number(gridHD.getCellValue(rowIds[i], 'BID_AMT')); <%-- 낙찰금액 --%>
                                var presumAmt = Number(gridHD.getCellValue(rowIds[i], 'PRESUM_AMT')); <%-- 예정가격 --%>
                                var diffGuarAmt = Number(gridHD.getCellValue(rowIds[i], 'DIFF_GUAR_AMT')); <%-- 차액보증금 --%>

                                if(bidAmt < everMath.round_float(presumAmt * 0.85)) {
                                    if(EVF.isEmpty(diffGuarAmt) || diffGuarAmt == 0) {
                                        confirmMsg = "${CBDR0033_T020}";
                                    }
                                }
                            } else {
                                return EVF.alert("${CBDR0033_T022}"); <%-- 해당업체는 낙찰조건을 만족하지 않습니다. --%>
                            }
                    	}
                    }
                }

                if (gridHD.getCellValue(rowIds[i], 'PRICE_RANK') != "1") {
                	confirmMsg = "${CBDR0033_T023}" + confirmMsg;
                }
            }

            EVF.confirm(confirmMsg, function () {
                var store = new EVF.Store();
                store.setGrid([gridHD, gridDT]);
                store.getGridData(gridHD, 'sel');
                store.getGridData(gridDT, 'sel');
                store.load(baseUrl + 'cbdr0033_doSuccessfulBid.so', function(){
                    EVF.alert(this.getResponseMessage(), function() {
                        if(popupFlag) {
                            opener.doSearch();
                            doClose();
                        }
                    });
                });
            });
        }

        function doFailBid() {

            var popupFlag = ${(param.popupFlag == null || !param.popupFlag) ? false : true};

            EVF.confirm("${CBDR0033_T005 }", function () {
                var store = new EVF.Store();
                store.load(baseUrl + 'cbdr0033_doFailBid.so', function(){
                    EVF.alert(this.getResponseMessage(), function() {
                        if(popupFlag) {
                            opener.doSearch();
                            doClose();
                        }
                    });
                });
            });
        }

        function doReBid() {

	        var voteCnt = Number(EVF.V("VOTE_CNT"));
	        var voteLimitCnt = Number(EVF.V("CHECK_VOTE_LIMIT_CNT"));
	        
	        var confirmMsg = "${CBDR0033_T007 }";
	        if(voteCnt > voteLimitCnt) {
	            confirmMsg = "${CBDR0033_T024}";
            }

            EVF.confirm(confirmMsg, function () {
                var param = {
                    'BUYER_CD' : EVF.V('BUYER_CD'),
                    'BID_NUM' : EVF.V('BID_NUM'),
                    'BID_CNT' : EVF.V('BID_CNT'),
                    'REBID' : true,
                    'individualFlag' : false,
                    'callbackFunction' : "doCallBackFunction",
                    'popupFlag' : true,
                    'detailView' : false
                };
                everPopup.openWindowPopup("/nhepro/CBDR/CBDI0032/view.so", 900, 590, param, "reBid", true);
            });
        }

        function doReAnn() {

	        <%-- 이전 공고를 '유찰'시킨 후, 새로운 공고를 작성하기 위한 Popup창을 띄운다. --%>
            var store = new EVF.Store();
            EVF.confirm("${CBDR0033_T008 }", function () {
            	// 2021.04.14 변경
                // 기존 유찰 => 재공고 가능 진행상태 체크
            	//store.load(baseUrl + 'cbdr0033_doFailBid.so', function(){
                store.load(baseUrl + 'cbdr0033_doCheckWithReAnn.so', function(){
                    var param = {
                        'buyerCd' : EVF.V('BUYER_CD'),
                        'bidNum' : EVF.V('BID_NUM'),
                        'bidCnt' : EVF.V('BID_CNT'),
                        'preBidNum' : EVF.V('BID_NUM'),
                        'preBidCnt' : EVF.V('BID_CNT'),
                        'preVoteCnt' : EVF.V('VOTE_CNT'),
                        'baseDataType': "ReBID",
                        'callbackFunction': "doCallBackFunction",
                        'popupFlag' : true,
                        'detailView' : false
                    };
                    everPopup.openWindowPopup("/nhepro/CBDI/CBDI0011/view.so", 1300, 800, param, "modBidNotice", true);
                });
            });
        }

        function doCallBackFunction() {
            var popupFlag = ${(param.popupFlag == null || !param.popupFlag) ? false : true};
            if(popupFlag) {
                opener.doSearch();
                doClose();
            }
        }

        function doQualifiedTest() {
            var param = {
                'BUYER_CD' : EVF.V("BUYER_CD"),
                'BID_NUM' : EVF.V("BID_NUM"),
                'BID_CNT' : EVF.V("BID_CNT"),
                'VOTE_CNT' : EVF.V("VOTE_CNT"),
                'popupFlag' : true,
                'detailView' : false
            };
            everPopup.openWindowPopup("/nhepro/CBDR/CBDI0036/view.so", 1200, 800, param, "qualifiedTest", true);
        }

        function doTotalSB() {
            var param = {
                'BUYER_CD'     : EVF.V("BUYER_CD"),
                'BID_NUM'      : EVF.V("BID_NUM"),
                'BID_CNT'      : EVF.V("BID_CNT"),
                'VOTE_CNT'     : EVF.V("VOTE_CNT"),
                'DOC_TYPE'     : EVF.V("DOC_TYPE"),
                'evResultFlag' : false,
                'popupFlag'    : true,
                'detailView'   : false
            };
            everPopup.openWindowPopup("/nhepro/CBDR/CBDI0034/view.so", 1200, 800, param, "totalSB", true);
        }

        function vendorNmClickEvent(rowIdx) {

            var finalFlag = gridDT.getCellValue(rowIdx, 'FINAL_FLAG');
            var bidAmt = Number(gridDT.getCellValue(rowIdx, 'BID_AMT_' + "${formData.VOTE_CNT}")); <%-- 낙찰금액 SETTLE_VOTE_CNT --%>
            var prAmt = Number(gridDT.getCellValue(rowIdx, 'PR_AMT')); <%-- 예산금액 --%>
            var presumAmt = Number(gridDT.getCellValue(rowIdx, 'PRESUM_AMT')); <%-- 예정가격 --%>
            var savingRate = everMath.round_float(((prAmt - bidAmt) / prAmt * 100), 2); <%-- 절감율 : (예산금액 - 낙찰금액) / 예산금액 --%>
            var settleRTate = everMath.round_float(((presumAmt - bidAmt) / presumAmt * 100), 2); <%-- 낙찰율 : (예정가격 - 낙찰금액) / 예정가격 --%>

            <%-- 차액보증금 : 차액보증여부가 “Y”인 경우 ④“차액보증금” 항목 visible
                 입찰진행 고객사가 중앙회[C00009]인 경우 아래 수식적용 & readOnly, 다른 고객사인 경우는 수기 입력
                  -. 예정가격의 70%미만 낙찰인 경우 : 차액보증금 = (예정가격 – 낙찰금액) * 2
                  -. 예정가격의 85%미만 낙찰인 경우 : 차액보증금 = 예정가격 – 낙찰금액 --%>
            var diffGuarAmt = 0;
            if(EVF.V("DIFF_GUAR_FLAG") == "1" && EVF.V("PR_BUYER_CD") == "C00009") {

                if(bidAmt < everMath.round_float(presumAmt * 0.7)) {
                    diffGuarAmt = (presumAmt - bidAmt) * 2;
                } else {
                    if((everMath.round_float(presumAmt * 0.7) <= bidAmt) && (bidAmt < everMath.round_float(presumAmt * 0.85))) {
                        diffGuarAmt = presumAmt - bidAmt;
                    }
                }
            }

            if(bidAmt > 0 && finalFlag == "500") {
                gridHD.delAllRow();
                
                var bidRmk = gridDT.getCellValue(rowIdx, 'BID_RMK');
                var addParam = [{
                    "VENDOR_CD": gridDT.getCellValue(rowIdx, 'VENDOR_CD')
                    , "VENDOR_NM": gridDT.getCellValue(rowIdx, 'VENDOR_NM')
                    , "CEO_USER_NM": gridDT.getCellValue(rowIdx, 'CEO_USER_NM')
                    , "BID_AMT": bidAmt
                    , "PR_AMT": prAmt
                    , "SAVING_RATE": savingRate
                    , "PRESUM_AMT": presumAmt
                    , "SETTLE_RATE": settleRTate
                    , "DIFF_GUAR_AMT": diffGuarAmt
                    , "TOTAL_LIABILITY_RATE": gridDT.getCellValue(rowIdx, 'TOTAL_LIABILITY_RATE')
                    , "CURRENT_ASSET_LIABILITY_RATE": gridDT.getCellValue(rowIdx, 'CURRENT_ASSET_LIABILITY_RATE')
                    , "PRICE_RANK": gridDT.getCellValue(rowIdx, 'PRICE_RANK')
                    , "BID_RMK": (EVF.isEmpty(bidRmk)||bidRmk=='null') ? "" : bidRmk
                }];
                gridHD.addRow(addParam);
                
                gridHD.setColIconify("BID_RMK", "BID_RMK", "comment", false);
            } else {
                gridHD.delAllRow();
            }
        }
        
        function doClose() {
            EVF.closeWindow();
        }

    </script>
    <e:window id="CBDR0033" initData="${initData}" onReady="init" title="${fullScreenName }" breadCrumbs="${breadCrumb }">

        <e:inputHidden id="PR_BUYER_CD" name="PR_BUYER_CD" value="${formData.PR_BUYER_CD}" />
        <e:inputHidden id="BUYER_CD" name="BUYER_CD" value="${formData.BUYER_CD}" />
        <e:inputHidden id="BID_NUM" name="BID_NUM" value="${formData.BID_NUM}" />
        <e:inputHidden id="BID_CNT" name="BID_CNT" value="${formData.BID_CNT}" />
        <e:inputHidden id="BID_STATUS" name="BID_STATUS" value="${formData.BID_STATUS}" />
        <e:inputHidden id="BID_USER_ID" name="BID_USER_ID" value="${formData.BID_USER_ID}" />
        <e:inputHidden id="OPEN_USER_ID" name="OPEN_USER_ID" value="${formData.OPEN_USER_ID}" />
        <e:inputHidden id="VOTE_CNT" name="VOTE_CNT" value="${formData.VOTE_CNT}" />
        <e:inputHidden id="CONT_TYPE1" name="CONT_TYPE1" value="${formData.CONT_TYPE1}" />
        <e:inputHidden id="CONT_TYPE2" name="CONT_TYPE2" value="${formData.CONT_TYPE2}" />
        <e:inputHidden id="CONT_TYPE3" name="CONT_TYPE3" value="${formData.CONT_TYPE3}" />
        <e:inputHidden id="TECH_EV_TYPE" name="TECH_EV_TYPE" value="${formData.TECH_EV_TYPE}" />
        <e:inputHidden id="VOTE_LIMIT_CNT" name="VOTE_LIMIT_CNT" value="${formData.VOTE_LIMIT_CNT}" />
        <e:inputHidden id="CHECK_VOTE_LIMIT_CNT" name="CHECK_VOTE_LIMIT_CNT" value="${formData.CHECK_VOTE_LIMIT_CNT}" />
        <e:inputHidden id="DIFF_GUAR_FLAG" name="DIFF_GUAR_FLAG" value="${formData.DIFF_GUAR_FLAG}" />
        <e:inputHidden id="ESTM_LIMIT_RATE" name="ESTM_LIMIT_RATE" value="${formData.ESTM_LIMIT_RATE}" />
        <e:inputHidden id="SETTLE_VENDOR" name="SETTLE_VENDOR" value="${formData.SETTLE_VENDOR}" />
        <e:inputHidden id="FINA_SOLV_FLAG" name="FINA_SOLV_FLAG" value="${formData.FINA_SOLV_FLAG}" />
        <e:inputHidden id="RATE_SDEPT" name="RATE_SDEPT" value="${formData.RATE_SDEPT}" />
        <e:inputHidden id="RATE_CURR" name="RATE_CURR" value="${formData.RATE_CURR}" />
        <e:inputHidden id="PRE_BID_STATUS" name="PRE_BID_STATUS" value="${formData.PRE_BID_STATUS}" />
        <e:inputHidden id="DOC_TYPE" name="DOC_TYPE" value="${param.DOC_TYPE}"/>

		<%--
        <e:inputHidden id="SETTLE_VOTE_CNT" name="SETTLE_VOTE_CNT" value="${formData.SETTLE_VOTE_CNT}" />
		 --%>
        <e:inputHidden id="SETTLE_VOTE_CNT" name="SETTLE_VOTE_CNT" value="${formData.VOTE_CNT}" />

        <%-- 입찰공고 정보 --%>
        <e:buttonBar id="buttonBar" align="right" width="100%" title="${CBDR0033_T001 }">
            <e:button id="Lottery" name="Lottery" label="${Lottery_N }" disabled="${Lottery_D }" visible="${Lottery_V}" onClick="doLottery" />
            <e:button id="SuccessfulBid" name="SuccessfulBid" label="${SuccessfulBid_N }" disabled="${SuccessfulBid_D }" visible="${SuccessfulBid_V}" onClick="doSuccessfulBid" />
            <e:button id="FailBid" name="FailBid" label="${FailBid_N }" disabled="${FailBid_D }" visible="${FailBid_V}" onClick="doFailBid" />
            <e:button id="ReBid" name="ReBid" label="${ReBid_N }" disabled="${ReBid_D }" visible="${ReBid_V}" onClick="doReBid" />
            <e:button id="ReAnn" name="ReAnn" label="${ReAnn_N }" disabled="${ReAnn_D }" visible="${ReAnn_V}" onClick="doReAnn" />
            <e:button id="QualifiedTest" name="QualifiedTest" label="${QualifiedTest_N }" disabled="${QualifiedTest_D }" visible="${QualifiedTest_V}" onClick="doQualifiedTest" />
            <e:button id="TotalSB" name="TotalSB" label="${TotalSB_N }" disabled="${TotalSB_D }" visible="${TotalSB_V}" onClick="doTotalSB" />
            <e:button id="Close" name="Close" label="${Close_N }" disabled="${Close_D }" visible="${Close_V}" onClick="doClose" />
        </e:buttonBar>

		<e:searchPanel id="form1" labelWidth="${labelWidth}" width="100%" columnCount="2" useTitleBar="false">
			<e:row>
				<e:label for="ANN_NO" title="${form_ANN_NO_N}"/>
				<e:field>
					<e:text> ${formData.ANN_NO } </e:text>
				</e:field>
				<e:label for="ANN_DATE" title="${form_ANN_DATE_N}"/>
				<e:field>
					<e:text> ${formData.ANN_DATE } </e:text>
				</e:field>
			</e:row>
			<e:row>
				<e:label for="ANN_ITEM" title="${form_ANN_ITEM_N}"/>
				<e:field>
					<e:text> ${formData.ANN_ITEM } </e:text>
				</e:field>
				<e:label for="CUR_VAT_TYPE" title="${form_CUR_VAT_TYPE_N}"/>
				<e:field>
					<e:text> ${formData.CUR } / ${formData.VAT_TYPE } </e:text>
				</e:field>
			</e:row>
			<e:row>
				<e:label for="CONT_TYPE_TXT" title="${form_CONT_TYPE_TXT_N}"/>
				<e:field colSpan="3">
					<e:text> ${formData.CONT_TYPE_TXT } </e:text>
				</e:field>
			</e:row>
			<e:row>
				<e:label for="BID_PR_AMT" title="${form_BID_PR_AMT_N}"/>
				<e:field>
					<e:text> ${formData.BID_PR_AMT } </e:text>
				</e:field>
				<e:label for="ESTM_AMT" title="${form_ESTM_AMT_N}"/>
				<e:field >
					<e:text> ${formData.ESTM_AMT } </e:text>
				</e:field>
			</e:row>
		</e:searchPanel>

        <%-- 낙찰자 정보 --%>
        <div class="e-component e-title-container" data-uuid="Title-541-391-560">
            <div class="e-title-bullet-h1"></div>
            <div class="e-title-text">${CBDR0033_T002 }</div>
            <div class="e-title-text" style="font-size:11px;padding-left: 5px;">${CBDR0033_T026 }</div>
        </div>
        <e:gridPanel id="gridHD" name="gridHD" width="100%" height="100px" gridType="${_gridType}" readOnly="${param.detailView}" />

        <%-- 입찰 정보 --%>
        <div class="e-component e-title-container" data-uuid="Title-541-391-560">
            <div class="e-title-bullet-h1"></div>
            <div class="e-title-text">${CBDR0033_T004 }</div>
            <div class="e-title-text" style="font-size:11px;padding-left: 5px;">${CBDR0033_T027 }</div>
        </div>
        <e:gridPanel id="gridDT" name="gridDT" width="100%" height="400px" gridType="${_gridType}" readOnly="${param.detailView}" />

	</e:window>
</e:ui>