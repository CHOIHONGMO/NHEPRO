<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">

	<script type="text/javascript" src="/MagicLine4Web/ML4Web/js/ext/jquery.blockUI.js"></script>
	<!-- ML4WEB JS -->
	<script type="text/javascript" src="/MagicLine4Web/ML4Web/js/ext/ML_Config.js"></script>

	<script type="text/javascript">

	    var grid;
	    var eventRowId = 0;
	    var isDetailView = ('${param.detailView}' === 'true' ? true : false);
		var baseUrl = "/nhepro/SBDR/";
		var maxProgressCd;
		var localServerFlag = "${localServerFlag}";

	    function init() {

            grid = EVF.C("grid");
            grid.cellClickEvent(function(rowIdx, colIdx, value) {
				
				eventRowId = rowIdx;
                if (colIdx == 'PR_ITEM_RMK') {
                    var param = {
                        title: "${SBDI0021_T005}",
                        message: grid.getCellValue(rowIdx, 'PR_ITEM_RMK')
                    };
                    everPopup.commonTextView(param);
                }
                if (colIdx == 'VENDOR_ITEM_RMK') {
                    var param = {
                        title: "${SBDI0021_T006}",
                        message: grid.getCellValue(rowIdx, 'VENDOR_ITEM_RMK'),
                        callbackFunction: 'setRMK',
                        rowIdx: rowIdx
                    };
                    if(isDetailView) {
                        everPopup.commonTextView(param);
                    } else {
                        everPopup.commonTextInput(param);
                    }
                }
                if(colIdx == "PR_ATT_FILE_CNT") {
                    var param = {
                        attFileNum: grid.getCellValue(rowIdx, 'PR_ATT_FILE_NUM'),
                        rowIdx: rowIdx,
                        callBackFunction: '',
                        bizType: 'PR',
                        detailView : true
                    };
                    everPopup.fileAttachPopup(param);
                }
                if(colIdx == "VENDOR_ATT_FILE_CNT") {
                    var param = {
                        attFileNum: grid.getCellValue(rowIdx, 'VENDOR_ATT_FILE_NUM'),
                        rowIdx: rowIdx,
                        callBackFunction: 'setFileAttach',
                        bizType: 'SBDI',
                        detailView : isDetailView
                    };
                    everPopup.fileAttachPopup(param);
                }
			});

			grid.cellChangeEvent(function(rowIdx, colIdx, iRow, iCol, value, oldValue) {

				if (colIdx == "PR_QT" || colIdx == "UNIT_PRC") {

					var prQt = Number(grid.getCellValue(rowIdx, 'PR_QT'));
					var unitPrc = Number(grid.getCellValue(rowIdx, 'UNIT_PRC'));
					var prAmt = 0;
					if(!EVF.isEmpty(prQt) && prQt > 0 && !EVF.isEmpty(unitPrc) && unitPrc > 0) {
						prAmt = everMath.floor_float(prQt * unitPrc);
						grid.setCellValue(rowIdx, 'PR_AMT', prAmt);
					} else {
						grid.setCellValue(rowIdx, 'PR_AMT', null);
					}
					
					var swBusAmt = Number(grid.getCellValue(rowIdx, 'SW_BUS_AMT'));
					if(!EVF.isEmpty(swBusAmt) && Number(swBusAmt) > 0 && !EVF.isEmpty(prAmt) && Number(prAmt) > 0) {
						grid.setCellValue(rowIdx, 'SW_BUS_RATE', ((swBusAmt - prAmt) / swBusAmt) * 100);
					} else {
						grid.setCellValue(rowIdx, 'SW_BUS_RATE', null);
					}
					var consumerAmt = Number(grid.getCellValue(rowIdx, 'CONSUMER_AMT'));
					if(!EVF.isEmpty(consumerAmt) && Number(consumerAmt) > 0 && !EVF.isEmpty(prAmt) && Number(prAmt) > 0) {
						grid.setCellValue(rowIdx, 'CONSUMER_RATE', ((consumerAmt - prAmt) / consumerAmt) * 100);
					} else {
						grid.setCellValue(rowIdx, 'CONSUMER_RATE', null);
					}
				}
				if (colIdx == "SW_BUS_AMT") {

					if(EVF.isEmpty(grid.getCellValue(rowIdx, 'PR_AMT'))) {
						EVF.alert("${SBDI0021_T007}");
						grid.setCellValue(rowIdx, 'SW_BUS_AMT', null);
						return;
					}
					var prAmt = Number(grid.getCellValue(rowIdx, 'PR_AMT'));
					var swBusAmt = Number(grid.getCellValue(rowIdx, 'SW_BUS_AMT'));
					if(!EVF.isEmpty(swBusAmt) && Number(swBusAmt) > 0 && !EVF.isEmpty(prAmt) && Number(prAmt) > 0) {
						grid.setCellValue(rowIdx, 'SW_BUS_RATE', ((swBusAmt - prAmt) / swBusAmt) * 100);
					} else {
						grid.setCellValue(rowIdx, 'SW_BUS_RATE', null);
					}
				}
				if (colIdx == "CONSUMER_AMT") {

					if(EVF.isEmpty(grid.getCellValue(rowIdx, 'PR_AMT'))) {
						EVF.alert("${SBDI0021_T007}");
						grid.setCellValue(rowIdx, 'CONSUMER_AMT', null);
						return;
					}
					var prAmt = Number(grid.getCellValue(rowIdx, 'PR_AMT'));
					var consumerAmt = Number(grid.getCellValue(rowIdx, 'CONSUMER_AMT'));
					if(!EVF.isEmpty(consumerAmt) && Number(consumerAmt) > 0 && !EVF.isEmpty(prAmt) && Number(prAmt) > 0) {
						grid.setCellValue(rowIdx, 'CONSUMER_RATE', ((consumerAmt - prAmt) / consumerAmt) * 100);
					} else {
						grid.setCellValue(rowIdx, 'CONSUMER_RATE', null);
					}
				}
			});

	        if(${!havePermission}) {
	        	EVF.C('Send').setDisabled(true);
	    	} else {
				EVF.C('Send').setDisabled(false);
	    	}

			grid.setProperty('shrinkToFit', ${shrinkToFit});		// 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
			grid.setProperty('rowNumbers', ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
			grid.setProperty('sortable', ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
			grid.setProperty('panelVisible', ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
			grid.setProperty('enterToNextRow', ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
			grid.setProperty('acceptZero', ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
			grid.setProperty('singleSelect', ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]
			grid.setProperty('multiSelect', false);					// [선택] 컬럼의 사용여부를 지정한다. [true/false]
			
			if (EVF.V("ESTM_TYPE") != "PE" || EVF.V("VOTE_CNT") != "1") {
				$("#estmDiv").hide();
				$("#sp_form3 tr:eq(0)").hide();
			}
			
			if(EVF.V("SEND_FLAG") == "N") {
				EVF.C('BID_AMT').setRequired(true);
				EVF.C("BID_AMT").setReadOnly(false);
				if (EVF.V("TCO_FLAG") == "1") {
					EVF.C('TCO_AMT').setRequired(true);
					EVF.C("TCO_AMT").setReadOnly(false);
				}
				EVF.C('SavePrc').setVisible(false);	// 단가제출 임시저장
                EVF.C('SendPrc').setVisible(false);	// 단가제출
			} else {
				EVF.C('BID_AMT').setRequired(false);
				EVF.C("BID_AMT").setReadOnly(true);
				if (EVF.V("TCO_FLAG") == "1") {
					EVF.C('TCO_AMT').setRequired(false);
					EVF.C("TCO_AMT").setReadOnly(true);
                    grid.setColRequired('TCO_AMT', true);
				} else {
                    grid.hideCol('TCO_YEAR_CNT', true);
                    grid.hideCol('TCO_AMT', true);
                    grid.setColRequired('TCO_AMT', false);
                }
				
				// 2021.11.02 : 임시저장 추가
				var adjPrcStatus = EVF.V("ADJ_PRC_STATUS");
                if(adjPrcStatus == "100" || adjPrcStatus == "150" || adjPrcStatus == "300") {
                    EVF.C('SavePrc').setVisible(true);
                    EVF.C('SendPrc').setVisible(true);
                } else {
                    EVF.C('SavePrc').setVisible(false);
                    EVF.C('SendPrc').setVisible(false);
                }
                EVF.C('Send').setVisible(false);
			}
			
			grid.setColGroup([
                {
                    "groupName": '용역',
                    "columns": ['SW_BUS_AMT', 'SW_BUS_RATE', 'MNT_SANGJU_YN']
                }
                ,{
                    "groupName": '물품(공사,기타,양수)',
                    "columns": ['CONSUMER_AMT', 'CONSUMER_RATE', 'FC_MNT_TERM', 'CH_RATE']
                }
                ,{
                    "groupName": '유지보수(리스,재리스,렌탈,도급)',
                    "columns": ['DOIB_AMOUNT', 'MNT_RATE', 'MNT_SDAY', 'MNT_EDAY', 'MNT_GUR_MONTH', 'RT_INSP_PERIOD', 'FALT_RC_TG_TIME']
                }
            ],50);
		    
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
		    grid.setRowFooter("PR_BUYER_NM", footer);

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
		    grid.setRowFooter("TCO_AMT", distVal);
		    grid.setRowFooter("SW_BUS_AMT", distVal);
		    grid.setRowFooter("CONSUMER_AMT", distVal);
		    grid.setRowFooter("DOIB_AMOUNT", distVal);
		    // ===========================================================
		    
        	doSearchDT();
		    
        	EVF.C("VAT_TYPE_LOC").setStyle("color:#FF0000;font-weight:bold;");
	    }

	    function doSearchDT() {

	    	var store = new EVF.Store();
	    	store.setGrid([grid]);
	        store.load(baseUrl + 'sbdi0021_doSearch.so', function() {
	        	if(grid.getRowCount() > 0){

                    grid.checkAll(true);

                    grid.setColIconify("PR_ITEM_RMK", "PR_ITEM_RMK", "comment", false);
                    grid.setColIconify("VENDOR_ITEM_RMK", "VENDOR_ITEM_RMK", "comment", false);

					var rowIds = grid.getSelRowId();
					for(var i in rowIds) {

						<%-- 구매유형이 '용역'인 경우, [SW사업대가, 상주여부] 필수 --%>
						if(grid.getCellValue(rowIds[i], 'PURCHASE_TYPE') == "S") {
							grid.setCellRequired(rowIds[i], 'SW_BUS_AMT', true);
							grid.setCellRequired(rowIds[i], 'MNT_SANGJU_YN', true);
						}
						<%-- 구매유형이 '물품/공사'인 경우, [소비자금액, 무상유지보수기간, 유상요율] 필수 --%>
						if(grid.getCellValue(rowIds[i], 'PURCHASE_TYPE') == "G" || grid.getCellValue(rowIds[i], 'PURCHASE_TYPE') == "C") {
							grid.setCellRequired(rowIds[i], 'CONSUMER_AMT', true);
							grid.setCellRequired(rowIds[i], 'FC_MNT_TERM', true);
							grid.setCellRequired(rowIds[i], 'CH_RATE', true);
						}
						<%-- 구매유형이 '유지보수'인 경우, [도입금액, 유지보수요율, 유지보수시작일, 유지보수종료일, 개월수, 정기점검주기, 장애복구목표시간] 필수 --%>
						if(grid.getCellValue(rowIds[i], 'PURCHASE_TYPE') == "M") {
							grid.setCellRequired(rowIds[i], 'DOIB_AMOUNT', true);
							grid.setCellRequired(rowIds[i], 'MNT_RATE', true);
							grid.setCellRequired(rowIds[i], 'MNT_SDAY', true);
							grid.setCellRequired(rowIds[i], 'MNT_EDAY', true);
							grid.setCellRequired(rowIds[i], 'MNT_GUR_MONTH', true);
							grid.setCellRequired(rowIds[i], 'RT_INSP_PERIOD', true);
							grid.setCellRequired(rowIds[i], 'FALT_RC_TG_TIME', true);
						}
						<%-- 구매유형이 '도급'인 경우, [유지보수시작일, 유지보수종료일, 개월수, 정기점검주기, 장애복구목표시간] 필수 --%>
						if(grid.getCellValue(rowIds[i], 'PURCHASE_TYPE') == "O") {
							grid.setCellRequired(rowIds[i], 'MNT_SDAY', true);
							grid.setCellRequired(rowIds[i], 'MNT_EDAY', true);
							grid.setCellRequired(rowIds[i], 'MNT_GUR_MONTH', true);
							grid.setCellRequired(rowIds[i], 'RT_INSP_PERIOD', true);
							grid.setCellRequired(rowIds[i], 'FALT_RC_TG_TIME', true);
						}
					}
	        	}
	        });
	    }

		var choiceEstmNum1;
	    var choiceEstmNum2;

	    function doSend() {
			
			var store = new EVF.Store();
			if(!store.validate()) { return; }

	    	if(EVF.V("ESTM_TYPE") == "PE" && EVF.V("VOTE_CNT") == "1") {
				var cgArgs = EVF.V("cg").split(",");
				if (cgArgs.length != 2) {
					return EVF.alert("${SBDI0021_T008}");
				}
				for (var i = 0; i < cgArgs.length; i++) {
					if (i == 0) { choiceEstmNum1 = cgArgs[i]; }
					if (i == 1) { choiceEstmNum2 = cgArgs[i]; }
				}
			}
	    	
			var confirmMsg = "${form_CUR_N} ";		// 입찰금액
			if (EVF.V("TCO_FLAG") == "1") {
				confirmMsg = "${SBDI0021_T091} ";	// 입찰금액(도입금액 + TCO금액)
			}
			confirmMsg += setText() + "을 제출하면 수정할 수 없습니다. \n계속하시겠습니까?";
			
			EVF.confirm(confirmMsg, function () {
				confirmMsg = "${form_CUR_N} ";
				if (EVF.V("TCO_FLAG") == "1") {
					confirmMsg = "${SBDI0021_T091} ";	// 입찰금액(도입금액 + TCO금액)
				}
				confirmMsg += setText() + "을 " + '${SBDI0021_T009 }';
				
				EVF.confirm(confirmMsg, function () {
					if (localServerFlag == "Y") {
						doSave();
					} else {
						document.reqForm.signData.value = EVF.V("VENDOR_CD") + "@@" + document.reqForm.idn.value + "@@" + EVF.V("BID_AMT") + "@@" + "${signDate}";

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
				doSave();
			}
			else {
				return EVF.alert("결과값 수신에 실패하였습니다.");
			}
		}

		function doSave() {

			var popupFlag = ${(param.popupFlag == null || !param.popupFlag) ? false : true};

			var store = new EVF.Store();
			store.setGrid([grid]);
			store.getGridData(grid, 'all');
			store.setParameter("CHOICE_ESTM_NUM1", choiceEstmNum1);
			store.setParameter("CHOICE_ESTM_NUM2", choiceEstmNum2);
			store.setParameter("signedData", document.reqForm.signedData.value);
			store.setParameter("vidRandom", document.reqForm.vidRandom.value);
			store.setParameter("idn", document.reqForm.idn.value);
			store.setParameter("localServerFlag", localServerFlag);
			store.doFileUpload(function() {
				store.load(baseUrl + 'sbdi0021_doSend.so', function(){

					EVF.alert(this.getResponseMessage(), function() {
						var param = {
							buyerCd: "${param.buyerCd}",
							bidNum: "${param.bidNum}",
							bidCnt : "${param.bidCnt}",
							voteCnt : "${param.voteCnt}",
							vendorCd : "${param.vendorCd}",
							detailView: true,
							popupFlag: true
						};
						if(popupFlag) {
							opener.doSearch();
							doClose();
						}
						else { document.location.href = '/nhepro/SBDR/SBDI0021/view.so?' + $.param(param); }
					});
				});
			});
		}
		
		var progressCd = "";
	    function doSendPrc() {

			var store = new EVF.Store();
			if(!store.validate()) { return; }

	    	if(EVF.V("ESTM_TYPE") == "PE" && EVF.V("VOTE_CNT") == "1") {
				var cgArgs = EVF.V("cg").split(",");
				if (cgArgs.length != 2) {
					return EVF.alert("${SBDI0021_T008}");
				}
				for (var i = 0; i < cgArgs.length; i++) {
					if (i == 0) { choiceEstmNum1 = cgArgs[i]; }
					if (i == 1) { choiceEstmNum2 = cgArgs[i]; }
				}
			}
			
			if (!grid.validate().flag) { return EVF.alert(grid.validate().msg); }
			
			var cnt = 0;
			var sumPrAmt = 0;
			var sumTcoAmt = 0;
			var sumAmt = 0;
            var rowIds = grid.getAllRowId();
            var isAmtSame = true; 
            for(var i in rowIds) {
                sumPrAmt = sumPrAmt + Number(grid.getCellValue(rowIds[i], 'PR_AMT'));
                sumTcoAmt = sumTcoAmt + Number(grid.getCellValue(rowIds[i], 'TCO_AMT'));
                
                if(grid.getCellValue(rowIds[i], 'BID_QT') != grid.getCellValue(rowIds[i], 'PR_QT')) {
					cnt++;
				}
            }
			
            if(Number(EVF.V('BID_AMT')) < sumPrAmt) {
                return EVF.alert("${SBDI0021_T016}"); // 입찰금액 < 품목정보에 입력한 도입금액(단가) 합계 - ERROR #201027 - 구매팀 수정 요청사항
            }
            
            if (EVF.V("TCO_FLAG") == "1") {
                if(Number(EVF.V('TCO_AMT')) < sumTcoAmt) {
                	return EVF.alert("${SBDI0021_T017}"); // 입찰금액 < 품목정보에 입력한 도입금액(단가) 합계 - ERROR 
                }
            }
            
            if(Number(EVF.V('BID_AMT')) != sumPrAmt || Number(EVF.V('TCO_AMT')) != sumTcoAmt  ){
            	isAmtSame = false;
            }
            
			var msg = "";
			if (cnt > 0) {
				msg = "<< '투찰수량'이 변경된 품목이 존재합니다 >>\n\n";
			}
			
			var confirmMsg = msg + "${form_CUR_N}";		// 입찰금액
			if (EVF.V("TCO_FLAG") == "1") {
				confirmMsg = msg + "${SBDI0021_T091} ";	// 입찰금액(도입금액 + TCO금액)
			}
			
			// 2021.11.02 : 임시저장 추가
			progressCd = this.data.data;
			if (progressCd == "T") {
				confirmMsg += setText() + "을 " + '${SBDI0021_T019 }';
			} else {
				confirmMsg += setText() + "을 " + '${SBDI0021_T009 }';
			}
			
			var confirmAmtMsg = (!isAmtSame ? "${SBDI0021_T018}" : "");
			
			// 입찰금액 > 품목정보 가격 인 경우 
			var localServerFlag = "${localServerFlag}";
			if( ! isAmtSame ){
				// 품목별 금액 합이 입찰금액과 상이합니다. 계속 진행하시겠습니까?  
				EVF.confirm(confirmAmtMsg, function () {
					EVF.confirm(confirmMsg, function () {
						if (localServerFlag == "Y" || progressCd == "T") {
		                    doSavePrc();
						} else {
							document.reqForm.signData.value = EVF.V("VENDOR_CD") + "@@" + document.reqForm.idn.value + "@@" + EVF.V("BID_AMT") + "@@" + "${signDate}";
							
							var certOdiFilter = "${certOidfilter}";
							var listOdiArr = certOdiFilter.split(";");
							var certOidfilter = "";
							for(var i in listOdiArr) {
								certOidfilter = certOidfilter + listOdiArr[i] + ",";
							}
							certOidfilter = certOidfilter.substring(0, certOidfilter.length-1);
							magicline.uiapi.MakeSignData(document.reqForm, null, mlCallBackPrc, certOidfilter);
						}
					});
				});
			} else{
				EVF.confirm(confirmMsg, function () {
					if (localServerFlag == "Y" || progressCd == "T") {
	                    doSavePrc();
					} else {
						document.reqForm.signData.value = EVF.V("VENDOR_CD") + "@@" + document.reqForm.idn.value + "@@" + EVF.V("BID_AMT") + "@@" + "${signDate}";
						
						var certOdiFilter = "${certOidfilter}";
						var listOdiArr = certOdiFilter.split(";");
						var certOidfilter = "";
						for(var i in listOdiArr) {
							certOidfilter = certOidfilter + listOdiArr[i] + ",";
						}
						certOidfilter = certOidfilter.substring(0, certOidfilter.length-1);
						magicline.uiapi.MakeSignData(document.reqForm, null, mlCallBackPrc, certOidfilter);
					}
				});
			}
		}

		function mlCallBackPrc(code, message){
			if(code == 0){ <%-- 정상메시지 --%>
				if (message.encMsg != null) { document.reqForm.signedData.value = encodeURIComponent(message.encMsg); }
				if (message.vidRandom != null) { document.reqForm.vidRandom.value = encodeURIComponent(message.vidRandom); }
				doSavePrc();
			}
			else {
				return EVF.alert("결과값 수신에 실패하였습니다.");
			}
		}

		function doSavePrc() {
			
			var popupFlag = ${(param.popupFlag == null || !param.popupFlag) ? false : true};

			var store = new EVF.Store();
			store.setGrid([grid]);
			store.getGridData(grid, 'all');
			store.setParameter("signedData", document.reqForm.signedData.value);
			store.setParameter("vidRandom", document.reqForm.vidRandom.value);
			store.setParameter("idn", document.reqForm.idn.value);
			store.setParameter("localServerFlag", localServerFlag);
			store.setParameter("progressCd", progressCd);
			store.doFileUpload(function() {
				store.load(baseUrl + 'sbdi0021_doSendPrc.so', function(){

					EVF.alert(this.getResponseMessage(), function() {
						var param = {
							buyerCd : "${param.buyerCd}",
							bidNum  : "${param.bidNum}",
							bidCnt  : "${param.bidCnt}",
							voteCnt : "${param.voteCnt}",
							vendorCd: "${param.vendorCd}",
							detailView: ((progressCd == "T") ? false : true),
							popupFlag : true
						};
						if(popupFlag) {
							if (progressCd == "T") {
								opener.doSearch();
								document.location.href = '/nhepro/SBDR/SBDI0021/view.so?' + $.param(param);
							} else {
								opener.doSearch();
								doClose();
							}
						} else {
							document.location.href = '/nhepro/SBDR/SBDI0021/view.so?' + $.param(param);
						}
					});
				});
			});
		}

        function setFileAttach(rowIdx, fileId, fileCnt) {
            grid.setCellValue(rowIdx, 'VENDOR_ATT_FILE_CNT', fileCnt);
            grid.setCellValue(rowIdx, 'VENDOR_ATT_FILE_NUM', fileId);
        }

        function setRMK(data) {
            grid.setCellValue(data.rowIdx, "VENDOR_ITEM_RMK", data.message);
            grid.setColIconify("VENDOR_ITEM_RMK", "VENDOR_ITEM_RMK", "comment", false);
        }

	    function doClose() {
			EVF.closeWindow();
        }

		function setText() {

			var sumPrAmt = 0;
			var sumTcoAmt = 0;
			var sumAmt = 0;
            var rowIds = grid.getAllRowId();
            for(var i in rowIds) {
                sumPrAmt = sumPrAmt + Number(grid.getCellValue(rowIds[i], 'PR_AMT'));
                sumTcoAmt = sumTcoAmt + Number(grid.getCellValue(rowIds[i], 'TCO_AMT'));
            }
            
            var tcoAmt = 0;
            var bidAmt = 0;
            if (EVF.V("TCO_FLAG") == "1") {
            	bidAmt = EVF.V('BID_AMT');
            	tcoAmt = EVF.V('TCO_AMT');
            	//sumAmt = EVF.V('TCO_AMT');
            } else {
            	bidAmt = EVF.V('BID_AMT');
            	//sumAmt = EVF.V('BID_AMT');
            }
            sumAmt = Number(bidAmt) + Number(tcoAmt);
            
			var element = Number(sumAmt);
			var num = String(element);
			var hanA = new Array("", "일", "이", "삼", "사", "오", "육", "칠", "팔", "구");
			var danA = new Array("", "십", "백", "천", "", "십", "백", "천", "", "십", "백", "천", "", "십", "백", "천");
			var result = "";
			var commaAmt = "";
			var vatTypeLoc = EVF.V('VAT_TYPE_LOC');
			
			var C1 = true;
			var C2 = true;
			var C3 = true;
			for (var i = 0; i < num.length; i++) {
				var str = "";
				var han = hanA[num.charAt(num.length - (i + 1))];
				if (han != "") {
					str += han+danA[i];

					if (4 <= i && i <= 7  && C1 == true) {str += "만"; C1 = false;}
					if (8 <= i && i <= 11 && C2 == true) {str += "억"; C2 = false;}
					if (i >= 12 && C3 == true) {str += "조"; C3 = false;}
					result = str + result;
				}
			}
			
			var amtSum = Number(sumAmt);
			var amtStr = String(amtSum) + "";;
			if(amtStr.length > 3){
				var loop = Math.ceil(amtStr.length / 3);
				var offset = amtStr.length % 3;
				if((amtStr.length % 3) == 0){
					offset = 3;
				}
				commaAmt = amtStr.substring(0, offset);
				for(var i = 1; i < loop; i++){
					commaAmt += "," + amtStr.substring(offset, offset+3);
					offset += 3;
				}
			}
			
			result = (EVF.V('CUR') == "KRW") ? commaAmt+"원 ( 금 " + result + "원 ) "+vatTypeLoc : " ( " + result + " " + EVF.V('CUR') +" )";
			return result;
		}
		

    </script>
	<e:window id="SBDI0021" initData="${initData}" onReady="init" title="${fullScreenName }" breadCrumbs="${breadCrumb }">

		<e:inputHidden id="BUYER_CD" name="BUYER_CD" value="${formData.BUYER_CD}" />
		<e:inputHidden id="BID_NUM" name="BID_NUM" value="${formData.BID_NUM}" />
		<e:inputHidden id="BID_CNT" name="BID_CNT" value="${formData.BID_CNT}" />
		<e:inputHidden id="VOTE_CNT" name="VOTE_CNT" value="${formData.VOTE_CNT}" />
		<e:inputHidden id="BID_STATUS" name="BID_STATUS" value="${formData.BID_STATUS}" />
		<e:inputHidden id="CONT_TYPE1" name="CONT_TYPE1" value="${formData.CONT_TYPE1}" />
		<e:inputHidden id="CONT_TYPE2" name="CONT_TYPE2" value="${formData.CONT_TYPE2}" />
		<e:inputHidden id="CONT_TYPE3" name="CONT_TYPE3" value="${formData.CONT_TYPE3}" />
		<e:inputHidden id="VENDOR_CD" name="VENDOR_CD" value="${formData.VENDOR_CD}" />
		<e:inputHidden id="BID_USER_ID" name="BID_USER_ID" value="${formData.BID_USER_ID}" />
		<e:inputHidden id="ESTM_TYPE" name="ESTM_TYPE" value="${formData.ESTM_TYPE}" />
		<e:inputHidden id="TCO_FLAG" name="TCO_FLAG" value="${formData.TCO_FLAG}" />
		<e:inputHidden id="TCO_YEAR_CNT" name="TCO_YEAR_CNT" value="${formData.TCO_YEAR_CNT}" />
		<e:inputHidden id="IRS_NO" name="IRS_NO" value="${formData.IRS_NO}" />
		<e:inputHidden id="SEND_FLAG" name="SEND_FLAG" value="${formData.SEND_FLAG}" />
		<e:inputHidden id="ADJ_PRC_STATUS" name="ADJ_PRC_STATUS" value="${formData.ADJ_PRC_STATUS}" />

		<%-- 입찰공고 정보 --%>
		<div class="e-component e-title-container" data-uuid="Title-541-391-560">
			<div class="e-title-bullet-h1"></div>
			<div class="e-title-text">${SBDI0021_T001 }</div>
		</div>
		<e:searchPanel id="form1" labelWidth="${labelWidth}" width="100%" columnCount="2" useTitleBar="false">
			<e:row>
				<e:label for="ANN_NO" title="${form_ANN_NO_N}"/>
				<e:field colSpan="3">
					<e:text> ${formData.ANN_NO } </e:text>
				</e:field>
			</e:row>
			<e:row>
				<e:label for="ANN_ITEM" title="${form_ANN_ITEM_N}"/>
				<e:field colSpan="3">
					<e:text> ${formData.ANN_ITEM } </e:text>
				</e:field>
			</e:row>
			<e:row>
				<e:label for="CONT_TYPE_TXT" title="${form_CONT_TYPE_TXT_N}"/>
				<e:field colSpan="3">
					<e:text> ${formData.CONT_TYPE_TXT } </e:text>
				</e:field>
			</e:row>
			<e:row>
				<e:label for="BID_USER_NM" title="${form_BID_USER_NM_N}"/>
				<e:field colSpan="3">
					<e:text> ${formData.BID_USER_NM } </e:text>
				</e:field>
			</e:row>
		</e:searchPanel>

		<%-- 입찰서 정보 --%>
		<div class="e-component e-title-container" data-uuid="Title-541-391-560">
			<div class="e-title-bullet-h1"></div>
			<div class="e-title-text">${SBDI0021_T002 }</div>
		</div>
		<e:searchPanel id="form2" labelWidth="${labelWidth}" width="100%" columnCount="2" useTitleBar="false">
			<e:row>
				<e:label for="CUR" title="${(formData.TCO_FLAG eq '1') ? SBDI0021_T092 : form_CUR_N}" />
				<e:field>
					<e:inputNumber id="BID_AMT" name="BID_AMT" value='${formData.BID_AMT }' align='right' width='160px' required='${form_BID_AMT_R }' readOnly='${form_BID_AMT_RO }' disabled='${form_BID_AMT_D }' visible='${form_BID_AMT_V }' decimalPlace="0" /><e:text>&nbsp;</e:text>
					<e:select id="CUR" name="CUR" value="${formData.CUR }" options="${curOptions }" width="80px" disabled="${form_CUR_D}" readOnly="${form_CUR_RO}" required="${form_CUR_R}" placeHolder="" />
					<e:inputText id="VAT_TYPE_LOC" name="VAT_TYPE_LOC" value="${formData.VAT_TYPE_LOC }" width="${form_VAT_TYPE_LOC_W}" maxLength="${form_VAT_TYPE_LOC_M}" disabled="${form_VAT_TYPE_LOC_D}" readOnly="${form_VAT_TYPE_LOC_RO}" required="${form_VAT_TYPE_LOC_R}"  maskType="${form_VAT_TYPE_LOC_MT}" />
					<e:inputHidden id="VAT_TYPE" name="VAT_TYPE" value="${formData.VAT_TYPE }"/>
					<%-- <e:select id="VAT_TYPE" name="VAT_TYPE" value="${formData.VAT_TYPE }" options="${vatTypeOptions }" width="100px" style="text-align: center;" disabled="${form_VAT_TYPE_D}" readOnly="${form_VAT_TYPE_RO}" required="${form_VAT_TYPE_R}" placeHolder="" /> --%>
				</e:field>
				<e:label for="BID_CNT" title="${form_BID_CNT_N}"/>
				<e:field>
					<e:text> ${formData.VOTE_CNT }차 </e:text>
				</e:field>
			</e:row>
		<c:if test="${formData.TCO_FLAG eq '1'}">
			<e:row>
				<e:label for="TCO_AMT" title="${formData.TCO_YEAR_CNT}년 TCO" />
				<e:field colSpan="3">
					<e:inputNumber id="TCO_AMT" name="TCO_AMT" value='${formData.TCO_AMT }' align='right' width='450px' required='${form_TCO_AMT_R }' readOnly='${form_TCO_AMT_RO }' disabled='${form_TCO_AMT_D }' visible='${form_TCO_AMT_V }' decimalPlace="0" />
					<e:text>&nbsp;<font color='#ff0000'>(도입금액 별도)</font></e:text>
				</e:field>
			</e:row>
		</c:if>
		<c:if test="${formData.TCO_FLAG eq '0'}">
			<e:row>
				<e:inputHidden id="TCO_AMT" name="TCO_AMT" value="${formData.TCO_AMT}" />
			</e:row>
		</c:if>
			<e:row>
				<e:label for="VO_ATT_FILE_NUM" title="${form_VO_ATT_FILE_NUM_N}"/>
				<e:field colSpan="3">
					<e:fileManager id="VO_ATT_FILE_NUM" height="150" width="100%" fileId="${formData.VO_ATT_FILE_NUM}" readOnly="${form_VO_ATT_FILE_NUM_RO}" bizType="QTA" required="${form_VO_ATT_FILE_NUM_R}"/>
				</e:field>
			</e:row>
		</e:searchPanel>

		<%-- 예정가격 선택 --%>
		<div id="estmDiv" class="e-component e-title-container" data-uuid="Title-541-391-560">
			<div class="e-title-bullet-h1"></div>
			<div class="e-title-text">${SBDI0021_T003 }</div>
		</div>
		<e:searchPanel id="form3" labelWidth="${labelWidth}" width="100%" columnCount="2" useTitleBar="false">
			<e:row>
				<e:label for="CHOICE_CASE" title="${form_CHOICE_CASE_N}" />
				<e:field colSpan="3">
					<e:checkGroup id="cg" name="cg" width="100%" visible="true" disabled="" readOnly="" required="">
						<c:forEach var="data" items="${choiceList}" varStatus="status">
							<e:check id="CHOICE_CASE${data.value}" name="CHOICE_CASE${data.value}" value="${data.value}" label="${data.text}&nbsp;&nbsp;&nbsp;&nbsp;" disabled="${form_CHOICE_CASE_D}" readOnly="${form_CHOICE_CASE_RO}" checked="${formData.CHOICE_ESTM_NUM1 == data.value ? true : (formData.CHOICE_ESTM_NUM2 == data.value ? true : false)}" />
						</c:forEach>
					</e:checkGroup>
				</e:field>
			</e:row>
		</e:searchPanel>

		<%-- 품목 정보 --%>
		<div class="e-component e-title-container" data-uuid="Title-541-391-560" style="display: ${formData.SEND_FLAG eq 'Y' ? 'block' : 'none'}">
			<div class="e-title-bullet-h1"></div>
			<div class="e-title-text">${SBDI0021_T004 }</div>
		</div>
		<div style="display: ${formData.SEND_FLAG eq 'Y' ? 'block' : 'none'}">
			<e:gridPanel id="grid" name="grid" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}" />
		</div>

		<e:buttonBar id="buttonBar" align="right" width="100%" title="${form_CAPTION3_N }">
			<e:button id="Send" name="Send" label="${Send_N }" disabled="${Send_D }" visible="${Send_V}" onClick="doSend" />
			<e:button id="SavePrc" name="SavePrc" label="${SavePrc_N}" disabled="${SavePrc_D}" visible="${SavePrc_V}" onClick="doSendPrc" data="T"/>
			<e:button id="SendPrc" name="SendPrc" label="${SendPrc_N }" disabled="${SendPrc_D }" visible="${SendPrc_V}" onClick="doSendPrc" data="E"/>
			<e:button id="Close" name="Close" label="${Close_N }" disabled="${Close_D }" visible="${Close_V}" onClick="doClose" />
		</e:buttonBar>

		<form id='reqForm' name='reqForm' method='post' action="/MagicLine4Web/ML4Web/jcaosCheck.jsp">
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