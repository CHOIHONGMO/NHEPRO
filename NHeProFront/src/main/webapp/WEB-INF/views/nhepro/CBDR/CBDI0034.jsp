<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">

	<script type="text/javascript">

        var grid;
		var baseUrl = "/nhepro/CBDR/";
	    var isDetailView = ('${param.detailView}' === 'true' ? true : false);
		var firstNegotiatorFlag;

	    function init() {
			
            grid = EVF.C("grid");
            
            var bidStatus = "${formData.BID_STATUS}";
        	var contType2 = "${formData.CONT_TYPE2}";
        	
            grid.cellClickEvent(function(rowIdx, colIdx, value) {
				
            	// 2021.03.24 : 기술평가결과 첨부파일
            	// 기술평가파일 첨부는 기술평가결과 등록화면에서 이루어짐(detailView=false => detailView=true로 변경)
                if(colIdx == "TECH_ATT_FILE_CNT") {
                	if( value == 0 ) return;
					var param = {
						attFileNum: grid.getCellValue(rowIdx, 'TECH_ATT_FILE_NUM'),
						rowIdx: rowIdx,
						callBackFunction: 'setFileAttach',
						bizType: 'BID',
						detailView: true
					};
					everPopup.fileAttachPopup(param);
                }
				
            	// 기술협상 첨부파일(detailView=true)
                if(colIdx == "NEGO_ATT_FILE_CNT") {
                	if( value == 0 ) return;
					var param = {
						attFileNum: grid.getCellValue(rowIdx, 'NEGO_ATT_FILE_NUM'),
						rowIdx: rowIdx,
						callBackFunction: 'setNegoFileAttach',
						bizType: 'BID',
						detailView: true
					};
					everPopup.fileAttachPopup(param);
                }
                
            	// 추가 첨부파일(detailView=false)
                if(colIdx == "ETC_ATT_FILE_CNT") {
					var param = {
						attFileNum: grid.getCellValue(rowIdx, 'ETC_ATT_FILE_NUM'),
						rowIdx: rowIdx,
						callBackFunction: 'setEtcFileAttach',
						bizType: 'BID',
						detailView: bidStatus=='2500'?true:false
					};
					everPopup.fileAttachPopup(param);
                }
            	
            	// 기술평가결과 비고
                if(colIdx == "TECH_RMK") {
                	if( value == "" ) return;
					var param = {
						title: "${CBDI0034_T003}",
						message: grid.getCellValue(rowIdx, 'TECH_RMK'),
						callbackFunction: 'setRMK',
						rowIdx: rowIdx
					};
					everPopup.commonTextView(param);
                }
				
            	// 기술협상 비고
                if(colIdx == "NEGO_RMK") {
                	if( value == "" ) return;
					var param = {
							callbackFunction: 'setNEGORMK',
							title: "기술협상내역",
							message: grid.getCellValue(rowIdx, 'NEGO_RMK'),
							rowIdx: rowIdx
						};
					everPopup.commonTextView(param);
                }
                
            	// 추가내역 기타
                if(colIdx == "ETC_RMK") {
					var param = {
							callbackFunction: 'setETCRMK',
							title: "추가내역",
							message: grid.getCellValue(rowIdx, 'ETC_RMK'),
							rowIdx: rowIdx
						};
					if( bidStatus == "2500" ) {
						everPopup.commonTextView(param);
					} else {
						everPopup.commonTextInput(param);
					}
                }
            });

			grid.cellChangeEvent(function(rowIdx, colIdx, iRow, iCol, value, oldValue) {

				if (colIdx == "PRC_SCORE") {

					var techScore = Number(grid.getCellValue(rowIdx, 'TECH_SCORE'));
					var prcScore  = Number(grid.getCellValue(rowIdx, 'PRC_SCORE'));
					var sumScore  = techScore + prcScore;
					if(sumScore > 100) {
						grid.setCellValue(rowIdx, 'PRC_SCORE', null);
						return EVF.alert("${CBDI0034_T015}")
					}
					if(sumScore < 0) {
						grid.setCellValue(rowIdx, 'PRC_SCORE', null);
						return EVF.alert("${CBDI0034_T016}")
					}
					if(!EVF.isEmpty(prcScore) && prcScore > -1) {
						grid.setCellValue(rowIdx, 'SUM_SCORE', sumScore);
					} else {
						grid.setCellValue(rowIdx, 'SUM_SCORE', techScore);
					}

					var docPrcScore = Number(EVF.V("PRC_SCORE"));
					if((docPrcScore > 0) && (prcScore > docPrcScore)) {
						grid.setCellValue(rowIdx, 'PRC_SCORE', null);
						grid.setCellValue(rowIdx, 'SUM_SCORE', techScore);
						return EVF.alert("${CBDI0034_T020}" + " '" + docPrcScore + "'" + "${CBDI0034_T021}");
					}
				}
			});

            grid.setProperty('shrinkToFit', true);                  // 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
            grid.setProperty('rowNumbers', ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
            grid.setProperty('sortable', ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
            grid.setProperty('panelVisible', ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            grid.setProperty('enterToNextRow', ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            grid.setProperty('acceptZero', ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            grid.setProperty('singleSelect', ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]
            grid.setProperty('multiSelect', false);                	// [선택] 컬럼의 사용여부를 지정한다. [true/false]

            if(${!havePermission}) {
                EVF.C('FirstNegotiator').setDisabled(true);
                EVF.C('Approval').setDisabled(true);
                EVF.C('SuccessfulBid').setDisabled(true);
                EVF.C('FailBid').setDisabled(true);
                EVF.C('ReBid').setDisabled(true);
                EVF.C('ReAnn').setDisabled(true);
                EVF.C('doSave').setDisabled(true);
            } else {
                EVF.C('FirstNegotiator').setDisabled(false);
                EVF.C('Approval').setDisabled(false);
                EVF.C('SuccessfulBid').setDisabled(false);
                EVF.C('FailBid').setDisabled(false);
                EVF.C('ReBid').setDisabled(false);
                EVF.C('ReAnn').setDisabled(false);
                EVF.C('doSave').setDisabled(false);
            }

			if(EVF.V("BID_STATUS") == "1300" || EVF.V("BID_STATUS") == "2500" || ${param.evResultFlag}) {
				EVF.C('FirstNegotiator').setVisible(false);
				EVF.C('Approval').setVisible(false);
				EVF.C('SuccessfulBid').setVisible(false);
				EVF.C('FailBid').setVisible(false);
				EVF.C('ReBid').setVisible(false);
				EVF.C('ReAnn').setVisible(false);
				EVF.C('doSave').setVisible(false);
			}
			
			grid.setColGroup([
				{
                    "groupName": '기술평가내역',
                    "columns": ['TECH_SCORE', 'PRC_SCORE', 'SUM_SCORE', 'TECH_ATT_FILE_CNT', 'TECH_RMK']
                }
				,{
                    "groupName": '기술협상내역',
                    "columns": ['NEGO_ATT_FILE_CNT', 'NEGO_RMK']
                }
				,{
                    "groupName": '추가정보 등록',
                    "columns": ['ETC_ATT_FILE_CNT', 'ETC_RMK']
                }
            ],50);
			
			// 업체선정완료인 경우 저장 비활성화
            if( bidStatus == "2500" ) {
            	EVF.C('doSave').setDisabled(true);
            	
            	EVF.C('NEGO_START_DATE').setReadOnly(true);
       	        EVF.C('NEGO_END_DATE').setReadOnly(true);
            } else {
            	EVF.C('doSave').setDisabled(false);
            	
            	if( contType2 == "NE" ) { // 협상에 의한 낙찰자 선정
	            	EVF.C('NEGO_START_DATE').setReadOnly(false);
	       	        EVF.C('NEGO_END_DATE').setReadOnly(false);
            	} else {
	            	EVF.C('NEGO_START_DATE').setReadOnly(true);
	       	        EVF.C('NEGO_END_DATE').setReadOnly(true);
            	}
            }
			
            doSearchVendorVO();
        }

        function doSearchVendorVO() {

            var store = new EVF.Store();
			
            store.setGrid([grid]);
            store.load(baseUrl + 'cbdi0034_doSearchVendorVO.so', function() {

				firstNegotiatorFlag = this.getParameter("firstNegotiatorFlag");

                if(grid.getRowCount() == 0) {
                    EVF.alert("${msg.M0002 }");
                } else {
					var rowIds = grid.getAllRowId();
					if(firstNegotiatorFlag == "N") {
						for (var i in rowIds) {
							if (grid.getCellValue(rowIds[i], 'BID_STATUS') == "100" || grid.getCellValue(rowIds[i], 'BID_STATUS') == "200") {
								grid.setCellValue(rowIds[i], 'BID_STATUS', "200");
								grid.setCellValue(rowIds[i], 'ORI_BID_STATUS', "200");
								grid.setCellReadOnly(rowIds[i], 'PRC_SCORE', false);
								break;
							}
						}
					} else {
						for (var i in rowIds) {
                            grid.setCellReadOnly(rowIds[i], 'PRC_SCORE', false);
						}
					}

                    for (var i in rowIds) {
                        if (grid.getCellValue(rowIds[i], 'BID_STATUS') == "300") {
                            grid.setCellFontColor(rowIds[i], 'VENDOR_NM', "#ff0000");
                            grid.setCellFontWeight(rowIds[i], 'VENDOR_NM', true);
                            grid.setCellFontColor(rowIds[i], 'BID_AMT', "#ff0000");
                            grid.setCellFontColor(rowIds[i], 'SUM_SCORE', "#ff0000");
                            grid.setCellFontWeight(rowIds[i], 'SUM_SCORE', true);
                            grid.setCellFontColor(rowIds[i], 'BID_STATUS', "#ff0000");
                            grid.setCellFontWeight(rowIds[i], 'BID_STATUS', true);
                        }
                    }

                 	// 기술평가 첨부파일
                    grid.setColIconify("TECH_RMK", "TECH_RMK", "comment", false);
                    
                    // 기술협상 첨부파일
                    grid.setColIconify("NEGO_RMK", "NEGO_RMK", "comment", false);
                    
                    // 추가 첨부파일
                    grid.setColIconify("ETC_RMK", "ETC_RMK", "comment", false);
                }
                if(firstNegotiatorFlag == "Y") {
                    EVF.C('FirstNegotiator').setDisabled(false);
                    EVF.C('Approval').setDisabled(true);
                    EVF.C('SuccessfulBid').setDisabled(true);
                    EVF.C('doSave').setDisabled(false);
                } else {
                    EVF.C('FirstNegotiator').setVisible(false);
                    if (EVF.V("NEGO_SIGN_STATUS") == 'E') {
                        EVF.C('Approval').setDisabled(true);
                    	if(EVF.V("DOC_TYPE") != '' || EVF.V("DOC_TYPE") == 'NEGORLT' ){
                    		EVF.C('SuccessfulBid').setDisabled(true);
                    	} else {
                    		EVF.C('SuccessfulBid').setDisabled(false);
                    	}
                    } else if (EVF.V("NEGO_SIGN_STATUS") == 'P') {
                        EVF.C('Approval').setDisabled(true);
    					EVF.C('SuccessfulBid').setDisabled(true);
    	                EVF.C('FailBid').setDisabled(true);
    	                EVF.C('ReBid').setDisabled(true);
    	                EVF.C('ReAnn').setDisabled(true);
                    } else {
                        EVF.C('Approval').setDisabled(false);
    					EVF.C('SuccessfulBid').setDisabled(true);
                    }
                    EVF.C('doSave').setDisabled(false);
                }
            });
        }
		
        // 우선협상자 선정
        function doFirstNegotiator() {

            var store = new EVF.Store();
	    	
	    	var confirmMsg = "${CBDI0034_T004 }";
			var rowIds = grid.getAllRowId();
			for(var i in rowIds) {
				if(EVF.isEmpty(grid.getCellValue(rowIds[i], 'PRC_SCORE')) || Number(grid.getCellValue(rowIds[i], 'PRC_SCORE')) == 0) {
					confirmMsg = "${CBDI0034_T023 }";
				}
			}

            EVF.confirm(confirmMsg, function () {
                store.setGrid([grid]);
                store.getGridData(grid, 'all');
                store.load(baseUrl + 'cbdi0034_doFirstNegotiator.so', function() {
                    EVF.alert(this.getResponseMessage(), function() {
                        doSearchVendorVO();
                    });
                });
            });
        }

        function doApproval() {
			
			var subject   = "[우선협상선정결과] " + "${formData.ANN_ITEM }";
			var docNum    = EVF.V('BID_NUM');
			var appDocNum = EVF.V('NEGO_APP_DOC_NUM');
			
        	var negoStartDate = "${formData.NEGO_START_DATE}";
			var negoEndDate   = "${formData.NEGO_END_DATE}";
			if( EVF.V("CONT_TYPE2") == "NE" && (negoStartDate == "" || negoEndDate == "") ) {
	    		return EVF.alert("협상에 의한 낙찰자 선정의 (1 순위) 우선협상기간에 대한 [추가정보 저장] 후 결재요청하세요.");
	    	}

			EVF.confirm("${CBDI0034_T027 }", function () {
				var param = {
					subject: subject,
					docType: "NEGORLT",
					signStatus: "P",
					screenId: "CBDI0034",
					approvalType: 'APPROVAL',
					attFileNum: "",
					docNum: docNum,
					appDocNum: appDocNum,
					callBackFunction: "goApproval",
					appAmt: 0
				};
				everPopup.openApprovalRequestIPopup(param);
			});
        }

		function goApproval(formData, gridData, attachData) {

			var store = new EVF.Store();
			store.setParameter("approvalFormData", formData);
			store.setParameter("approvalGridData", gridData);
			store.setParameter("attachFileDatas", attachData);
			store.load(baseUrl + 'cbdi0034_doApproval.so', function(){
                EVF.alert(this.getResponseMessage(), function() {
                    var popupFlag = ${(param.popupFlag == null || !param.popupFlag) ? false : true};
                    if(popupFlag) {
                        opener.opener.doSearch();
                        opener.doClose();
                        doClose();
                    }
                });
			});
		}
		
		// 낙찰
        function doSuccessfulBid() {

            var confirmMsg = "";
            var settleCnt = 0;

			if (!grid.validate().flag) { return EVF.alert(grid.validate().msg); }

			var checkedRowId = null;
            var rowIds = grid.getAllRowId();
            for(var i in rowIds) {
            	if(grid.getCellValue(rowIds[i], 'BID_STATUS') == "200") {
        			checkedRowId = rowIds[i];
            	}

            	var estmAmt = 0;
            	var estmMsg = "";
                if(grid.getCellValue(rowIds[i], 'BID_STATUS') == "200") {

        			if (EVF.V("ESTM_TYPE") == 'SE' || EVF.V("ESTM_TYPE") == 'PE') {
        				estmMsg = "${form_FINAL_ESTM_PRC_TXT_N}" + "${CBDI0034_T026}";
        				estmAmt = everString.replaceAll(EVF.V("FINAL_ESTM_PRC"), ",", "");
        			} else {
        				estmMsg = "${form_PR_AMT_N}" + "${CBDI0034_T026}";
        				estmAmt = everString.replaceAll("${formData.PR_AMT }", ",", "");
        			}
        			if (estmAmt < grid.getCellValue(rowIds[i], 'BID_AMT')) {
						return EVF.alert(estmMsg)
        			}

					if(Number(grid.getCellValue(rowIds[i], 'SUM_SCORE')) > 100) {
						return EVF.alert("${CBDI0034_T015}")
					}
					if(Number(grid.getCellValue(rowIds[i], 'SUM_SCORE')) < 0) {
						return EVF.alert("${CBDI0034_T016}")
					}
					if(Number(grid.getCellValue(rowIds[i], 'SUM_SCORE')) == 0) {
						confirmMsg = grid.getCellValue(rowIds[i], 'VENDOR_NM') + "${CBDI0034_T019}";
					} else {
						confirmMsg = grid.getCellValue(rowIds[i], 'VENDOR_NM') + "${CBDI0034_T014}";
					}
					settleCnt++;
                }
            }

            if(settleCnt == 0) { return EVF.alert("${CBDI0034_T018}") }

            EVF.confirm(confirmMsg, function () {
				if (!EVF.isEmpty(checkedRowId)) {
            		grid.setCellValue(checkedRowId, 'BID_STATUS', "300");
				}
				
            	var store = new EVF.Store();
                store.setGrid([grid]);
                store.getGridData(grid, 'all');
                store.load(baseUrl + 'cbdi0034_doSuccessfulBid.so', function(){
                    EVF.alert(this.getResponseMessage(), function() {
                        var popupFlag = ${(param.popupFlag == null || !param.popupFlag) ? false : true};
                        if(popupFlag) {
                            opener.opener.doSearch();
                            opener.doClose();
                            doClose();
                        }
                    });
                });
            });
        }
		
        // 유찰
        function doFailBid() {

            var confirmMsg = "${CBDI0034_T009}";
            var remainVendorCnt = 0;

			grid.checkAll(false);

			var checkedRowId = null;
			var rowIds = grid.getAllRowId();
			for(var i in rowIds) {
				if(grid.getCellValue(rowIds[i], 'ORI_BID_STATUS') == "200") {
					grid.checkRow(rowIds[i], true);
					checkedRowId = rowIds[i];
					confirmMsg = grid.getCellValue(rowIds[i], 'VENDOR_NM') + "${CBDI0034_T008}";

				}
				
				if(grid.getCellValue(rowIds[i], 'ORI_BID_STATUS') == "600") {
					grid.checkRow(rowIds[i], true);
					grid.setCellValue(rowIds[i], 'BID_STATUS', "600");
				}
				
				if(grid.getCellValue(rowIds[i], 'ORI_BID_STATUS') == "100") {
					remainVendorCnt++;
				}
            }

			if(remainVendorCnt == 0) { confirmMsg = "${CBDI0034_T009}"; }

            EVF.confirm(confirmMsg, function () {
				if (!EVF.isEmpty(checkedRowId)) {
	            	grid.setCellValue(checkedRowId, 'BID_STATUS', "400");
				}

    			var store = new EVF.Store();
				store.setGrid([grid]);
				store.getGridData(grid, 'sel');
                store.load(baseUrl + 'cbdi0034_doFailBid.so', function(){
                    EVF.alert(this.getResponseMessage(), function() {
                    	if(remainVendorCnt == 0) {
							var popupFlag = ${(param.popupFlag == null || !param.popupFlag) ? false : true};
							if(popupFlag) {
								opener.opener.doSearch();
								opener.doClose();
								doClose();
							}
						} else {
							doSearchVendorVO();
						}
                    });
                });
            });
        }
		
        // 재입찰
        function doReBid() {

			var confirmMsg = "";
			var voteCnt = Number(EVF.V("VOTE_CNT"));
			var voteLimitCnt = Number(EVF.V("CHECK_VOTE_LIMIT_CNT"));

			<%-- 우선협상선정 버튼 클릭없이 ‘재입찰＇을 누르면 전체 협력업체에 대해 재입찰을 진행. --%>
			if(firstNegotiatorFlag == "Y") {
				confirmMsg = "${CBDI0034_T006 }";
				if(voteCnt > voteLimitCnt) {
		            confirmMsg = "${CBDI0034_T028}";
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
			<%-- 우선협상선정 후, 재입찰 누르면 ‘협상중＇인 협력업체만 재입찰을 진행. --%>
			else {

				var remainVendorCnt = 0;
				var reBidVendorCnt = 0;

				grid.checkAll(false);
				var rowIds = grid.getAllRowId();
				var vendorCd = ""; var vendorMaxVoteCnt = "";
				for(var i in rowIds) {
					if(grid.getCellValue(rowIds[i], 'ORI_BID_STATUS') == "200") {
						if(Number(grid.getCellValue(rowIds[i], 'VENDOR_MAX_VOTE_CNT')) > Number(voteLimitCnt)) {
							//return EVF.alert("${CBDI0034_T007}");
							confirmMsg = grid.getCellValue(rowIds[i], 'VENDOR_NM') + "${CBDI0034_T028}";
						} else {
							confirmMsg = grid.getCellValue(rowIds[i], 'VENDOR_NM') + "${CBDI0034_T024}";
						}
						vendorCd = grid.getCellValue(rowIds[i], 'VENDOR_CD');
						vendorMaxVoteCnt = grid.getCellValue(rowIds[i], 'VENDOR_MAX_VOTE_CNT');
                        reBidVendorCnt++;
					}
					if(grid.getCellValue(rowIds[i], 'ORI_BID_STATUS') == "100") {
						remainVendorCnt++;
					}
				}

				if(remainVendorCnt == 0 && reBidVendorCnt == 0) { return EVF.alert("${CBDI0034_T025}"); }

				EVF.confirm(confirmMsg, function () {
					var param = {
						'BUYER_CD' : EVF.V('BUYER_CD'),
						'BID_NUM' : EVF.V('BID_NUM'),
						'BID_CNT' : EVF.V('BID_CNT'),
						'VENDOR_CD' : vendorCd,
						'VENDOR_MAX_VOTE_CNT' : vendorMaxVoteCnt,
						'REBID' : true,
						'individualFlag' : true,
						'callbackFunction' : "doCallBackFunctionIndividual",
						'popupFlag' : true,
						'detailView' : false
					};
					everPopup.openWindowPopup("/nhepro/CBDR/CBDI0032/view.so", 900, 590, param, "reBid", true);
				});
			}
        }
		
        // 재공고
        // 2021.04.14 프로세스 변경
        // 기존 유찰 후 재공고 => 재공고 완료 후 유찰로 변경
        function doReAnn() {

	        <%-- 이전 공고를 '유찰'시킨 후, 새로운 공고를 작성하기 위한 Popup창을 띄운다. --%>
            var store = new EVF.Store();
            EVF.confirm("${CBDI0034_T005 }", function () {
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
                opener.opener.doSearch();
                opener.doClose();
                doClose();
            }
        }

        function doCallBackFunctionIndividual() {

            grid.checkAll(false);
            var rowIds = grid.getAllRowId();
            for(var i in rowIds) {
                if(grid.getCellValue(rowIds[i], 'ORI_BID_STATUS') == "200") {
                    grid.checkRow(rowIds[i], true);
                }
            }

            var store = new EVF.Store();
            store.setGrid([grid]);
            store.getGridData(grid, 'sel');
            store.load(baseUrl + 'cbdi0034_callBackIndividual.so', function() {
                var popupFlag = ${(param.popupFlag == null || !param.popupFlag) ? false : true};
                if(popupFlag) {
                    opener.opener.doSearch();
                    opener.doClose();
                    doClose();
                }
            });
        }
		
     	// 기술평가 첨부파일
        function setFileAttach(rowIdx, fileId, fileCnt) {
        	grid.setCellValue(rowIdx, 'TECH_ATT_FILE_CNT', fileCnt);
            grid.setCellValue(rowIdx, 'TECH_ATT_FILE_NUM', fileId);
        }

     	// 기술협상 첨부파일
        function setNegoFileAttach(rowIdx, fileId, fileCnt) {
        	grid.setCellValue(rowIdx, 'NEGO_ATT_FILE_CNT', fileCnt);
            grid.setCellValue(rowIdx, 'NEGO_ATT_FILE_NUM', fileId);
        }
        
     	// 추가 첨부파일
        function setEtcFileAttach(rowIdx, fileId, fileCnt) {
        	grid.setCellValue(rowIdx, 'ETC_ATT_FILE_CNT', fileCnt);
            grid.setCellValue(rowIdx, 'ETC_ATT_FILE_NUM', fileId);
        }
     	
     	// 기술평가 비고
        function setRMK(data) {
            grid.setCellValue(data.rowIdx, "TECH_RMK", data.message);
            grid.setColIconify("TECH_RMK", "TECH_RMK", "comment", false);
        }

        // 기술협상 비고
        function setNEGORMK(data) {
            grid.setCellValue(data.rowIdx, "NEGO_RMK", data.message);
            grid.setColIconify("NEGO_RMK", "NEGO_RMK", "comment", false);
        }
        
        // 추가 비고
        function setETCRMK(data) {
            grid.setCellValue(data.rowIdx, "ETC_RMK", data.message);
            grid.setColIconify("ETC_RMK", "ETC_RMK", "comment", false);
        }
        
        function openFinalEstmPrc() {

			var param = {
				 BID_NUM : EVF.V("BID_NUM")
				,BID_CNT : EVF.V("BID_CNT")
				,BUYER_CD : EVF.V("BUYER_CD")
				,'detailView' : true
			};
			if (EVF.V("ESTM_TYPE") == 'SE') {
				everPopup.openPopupByScreenId('CBDI0052', 1000, 300, param);
			} else if (EVF.V("ESTM_TYPE") == 'PE') {
				everPopup.openPopupByScreenId('CBDI0053', 1000, 480, param);
			}
		}
		
        // 2021.03.24 추가
        // 추가첨부파일 및 비고 저장
		function doSave() {
			
			var store = new EVF.Store();
			
			if( EVF.V("CONT_TYPE2") == "NE" && (EVF.isEmpty(EVF.V("NEGO_START_DATE")) || EVF.isEmpty(EVF.V("NEGO_END_DATE"))) ) {
	    		return EVF.alert("협상에 의한 낙찰자 선정의 (1 순위) 우선협상기간이 입력되지 않았습니다.");
	    	}
			
            EVF.confirm("${msg.M0021}", function () {
				store.doFileUpload(function() {
					store.setGrid([grid]);
					store.getGridData(grid, 'all');
					store.load(baseUrl + '/cbdi0037_doSave.so', function () {
						
						var buyerCd = this.getParameter('BUYER_CD');
						var bidNum  = this.getParameter('BID_NUM');
						var bidCnt  = this.getParameter('BID_CNT');
						var voteCnt = this.getParameter("VOTE_CNT");
						var param = {
	        					'BUYER_CD'     : buyerCd,
	        					'BID_NUM'      : bidNum,
	        					'BID_CNT'      : bidCnt,
	        					'VOTE_CNT'     : voteCnt,
	        					'evResultFlag' : false,
	        	                'popupFlag'    : true,
	        	                'detailView'   : false
	        	            };
						
						EVF.alert(this.getResponseMessage(), function () {
							location.href = baseUrl + 'CBDI0034/view.so?' + $.param(param);
						});
					});
				});
			});
		}
		
        function doClose() {
            EVF.closeWindow();
        }

    </script>
    <e:window id="CBDI0034" initData="${initData}" onReady="init" title="${fullScreenName }" breadCrumbs="${breadCrumb }">

        <e:inputHidden id="PR_BUYER_CD" name="PR_BUYER_CD" value="${formData.PR_BUYER_CD}" />
        <e:inputHidden id="BUYER_CD" name="BUYER_CD" value="${formData.BUYER_CD}" />
        <e:inputHidden id="BID_NUM" name="BID_NUM" value="${formData.BID_NUM}" />
        <e:inputHidden id="BID_CNT" name="BID_CNT" value="${formData.BID_CNT}" />
        <e:inputHidden id="VOTE_CNT" name="VOTE_CNT" value="${formData.VOTE_CNT}" />
        <e:inputHidden id="BID_STATUS" name="BID_STATUS" value="${formData.BID_STATUS}" />
        <e:inputHidden id="BID_USER_ID" name="BID_USER_ID" value="${formData.BID_USER_ID}" />
        <e:inputHidden id="CONT_TYPE1" name="CONT_TYPE1" value="${formData.CONT_TYPE1}" />
        <e:inputHidden id="CONT_TYPE2" name="CONT_TYPE2" value="${formData.CONT_TYPE2}" />
        <e:inputHidden id="CONT_TYPE3" name="CONT_TYPE3" value="${formData.CONT_TYPE3}" />
        <e:inputHidden id="VOTE_LIMIT_CNT" name="VOTE_LIMIT_CNT" value="${formData.VOTE_LIMIT_CNT}" />
        <e:inputHidden id="CHECK_VOTE_LIMIT_CNT" name="CHECK_VOTE_LIMIT_CNT" value="${formData.CHECK_VOTE_LIMIT_CNT}" />
        <e:inputHidden id="DIFF_GUAR_FLAG" name="DIFF_GUAR_FLAG" value="${formData.DIFF_GUAR_FLAG}" />
        <e:inputHidden id="ESTM_LIMIT_RATE" name="ESTM_LIMIT_RATE" value="${formData.ESTM_LIMIT_RATE}" />
        <e:inputHidden id="CONF_STD_SCORE" name="CONF_STD_SCORE" value="${formData.CONF_STD_SCORE}" />
        <e:inputHidden id="PRC_SCORE" name="PRC_SCORE" value="${formData.PRC_SCORE}" />
        <e:inputHidden id="ESTM_TYPE" name="ESTM_TYPE" value="${formData.ESTM_TYPE}" />
   		<e:inputHidden id='NEGO_APP_DOC_NUM' name="NEGO_APP_DOC_NUM" value="${formData.NEGO_APP_DOC_NUM}" />
    	<e:inputHidden id='NEGO_APP_DOC_CNT' name="NEGO_APP_DOC_CNT" value="${formData.NEGO_APP_DOC_CNT}" />
    	<e:inputHidden id='NEGO_SIGN_STATUS' name="NEGO_SIGN_STATUS" value="${formData.NEGO_SIGN_STATUS}" />
    	<e:inputHidden id="approvalFormData" name="approvalFormData"/>
    	<e:inputHidden id="approvalGridData" name="approvalGridData"/>
        <e:inputHidden id="evResultFlag" name="evResultFlag" value="${param.evResultFlag}" />
        <e:inputHidden id="DOC_TYPE" name="DOC_TYPE" value="${param.DOC_TYPE}"/>

        <%-- 입찰공고 정보 --%>
        <e:buttonBar id="buttonBar" align="right" width="100%" title="${CBDI0034_T001 }">
            <e:button id="FirstNegotiator" name="FirstNegotiator" label="${FirstNegotiator_N }" disabled="${FirstNegotiator_D }" visible="${FirstNegotiator_V}" onClick="doFirstNegotiator" />
            <e:button id="Approval" name="Approval" label="${Approval_N }" disabled="${Approval_D }" visible="${Approval_V}" onClick="doApproval" />
            <e:button id="SuccessfulBid" name="SuccessfulBid" label="${SuccessfulBid_N }" disabled="${SuccessfulBid_D }" visible="${SuccessfulBid_V}" onClick="doSuccessfulBid" />
            <e:button id="FailBid" name="FailBid" label="${FailBid_N }" disabled="${FailBid_D }" visible="${FailBid_V}" onClick="doFailBid" />
            <e:button id="ReBid" name="ReBid" label="${ReBid_N }" disabled="${ReBid_D }" visible="${ReBid_V}" onClick="doReBid" />
            <e:button id="ReAnn" name="ReAnn" label="${ReAnn_N }" disabled="${ReAnn_D }" visible="${ReAnn_V}" onClick="doReAnn" />
            <e:button id="Close" name="Close" label="${Close_N }" disabled="${Close_D }" visible="${Close_V}" onClick="doClose" />
        </e:buttonBar>

		<e:searchPanel id="form" labelWidth="${labelWidth}" width="100%" columnCount="2" useTitleBar="false">
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
			<e:row>
				<e:label for="PR_AMT" title="${form_PR_AMT_N}"/>
				<e:field>
					<e:text>${formData.PR_AMT }&nbsp;&nbsp;${formData.CUR }&nbsp;&nbsp;${formData.VAT_TYPE } </e:text>
				</e:field>
				<e:label for="FINAL_ESTM_PRC_TXT" title="${form_FINAL_ESTM_PRC_TXT_N}"/>
				<e:field>
					<e:inputText id="FINAL_ESTM_PRC_TXT" name="FINAL_ESTM_PRC_TXT" value="${formData.FINAL_ESTM_PRC_TXT }" style="${formData.FINAL_ESTM_PRC == null ? '' : 'font-weight:bold; cursor:pointer; color:blue;'}" onClick="${formData.FINAL_ESTM_PRC == null ? '' : 'openFinalEstmPrc'}" width="${form_FINAL_ESTM_PRC_TXT_W}" maxLength="${form_FINAL_ESTM_PRC_TXT_M}" disabled="${form_FINAL_ESTM_PRC_TXT_D}" readOnly="${form_FINAL_ESTM_PRC_TXT_RO}" required="${form_FINAL_ESTM_PRC_TXT_R}" />
					<e:inputHidden id="FINAL_ESTM_PRC" name="FINAL_ESTM_PRC" value="${formData.FINAL_ESTM_PRC }" />
				</e:field>
			</e:row>
			<e:row>
				<e:label for="MIN_BID_AMT" title="${form_MIN_BID_AMT_N}"/>
				<e:field colSpan="3">
                    <e:text>${formData.MIN_BID_AMT }&nbsp;&nbsp;${formData.CUR }&nbsp;&nbsp;${formData.VAT_TYPE } </e:text>
				</e:field>
			</e:row>
		</e:searchPanel>

        <%-- 적격심사결과 --%>
        <e:buttonBar id="buttonBar1" title="${CBDI0034_T002 }" align="right" width="100%">
			<e:button id="doSave" name="doSave" label="${doSave_N}" onClick="doSave" disabled="${doSave_D}" visible="${doSave_V}"/>
		</e:buttonBar>
		
		<c:if test="${formData.CONT_TYPE2 eq 'NE'}">
			<e:searchPanel id="form1" labelWidth="${labelWidth}" width="100%" columnCount="2" useTitleBar="false">
				<e:row>
					<e:label colSpan="3" for="NEGO_START_DATE" title="${form_NEGO_START_DATE_N}"/>
					<e:field>
						<e:inputDate id="NEGO_START_DATE" name="NEGO_START_DATE" toDate="NEGO_END_DATE" value="${formData.NEGO_START_DATE }" width="${inputDateWidth}" datePicker="true" required="${form_NEGO_START_DATE_R}" disabled="${form_NEGO_START_DATE_D}" readOnly="${form_NEGO_START_DATE_RO}" />
						<e:text> ~ </e:text>
						<e:inputDate id="NEGO_END_DATE" name="NEGO_END_DATE" fromDate="NEGO_START_DATE" value="${formData.NEGO_END_DATE }" width="${inputDateWidth}" datePicker="true" required="${form_NEGO_END_DATE_R}" disabled="${form_NEGO_END_DATE_D}" readOnly="${form_NEGO_END_DATE_RO}" />
					</e:field>
				</e:row>
			</e:searchPanel>
		</c:if>
		
        <e:gridPanel id="grid" name="grid" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}" />

		<%-- 결재자 리스트 Include --%>
		<jsp:include page="/WEB-INF/views/nhepro/CWOR/CWOR0013.jsp" flush="true" >
			<jsp:param value="${formData.NEGO_APP_DOC_NUM}" name="APP_DOC_NUM"/>
			<jsp:param value="${formData.NEGO_APP_DOC_CNT}" name="APP_DOC_CNT"/>
			<jsp:param value="${formData.BUYER_CD}" name="BUYER_CD"/>
		</jsp:include>

	</e:window>
</e:ui>