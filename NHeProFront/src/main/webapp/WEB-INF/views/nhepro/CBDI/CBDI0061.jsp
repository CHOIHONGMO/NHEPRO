<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">

	<script type="text/javascript">

		var gridV; var gridI;
		var eventRowIdV;
		var eventRowIdI;
		var isDetailView = ('${param.detailView}' === 'true' ? true : (("${formData.SIGN_STATUS }" == "P" || "${formData.SIGN_STATUS }" == "E") ? true : false));
		var baseDataType = ("${param.baseDataType}" == null ? "" : "${param.baseDataType}");
		var paramExecWtNum = ("${param.paramExecWtNum}" == null ? "" : "${param.paramExecWtNum}");
		var popupFlag = ${(param.popupFlag == null || !param.popupFlag) ? false : true};
		var tcoFlag = ("${param.tcoFlag}" == null ? "N" : "${param.tcoFlag}");
		var contType = ("${param.contType}" == null ? "" : "${param.contType}");
		var userType = "${ses.userType}";
		var baseUrl = "/nhepro/CBDR/";
		function init() {

			gridV = EVF.C("gridV");
			gridI = EVF.C("gridI");

			gridV.cellClickEvent(function(rowIdx, colIdx, value) {

				eventRowIdV = rowIdx;
				var bidNum = gridV.getCellValue(rowIdx, 'BID_NUM');
				
				if (colIdx === 'RFX_AMT') {
					
					if( bidNum == "" ) return;
					
					var param = {
						'BUYER_CD'     : gridV.getCellValue(rowIdx, 'BUYER_CD'),
						'BID_NUM'      : gridV.getCellValue(rowIdx, 'BID_NUM'),
						'BID_CNT'      : gridV.getCellValue(rowIdx, 'BID_CNT'),
						'VOTE_CNT'     : gridV.getCellValue(rowIdx, 'VOTE_CNT'),
						//'BID_STATUS'   : '2500',
		                'evResultFlag' : false,
						'popupFlag'    : true,
						'detailView'   : true
					};
					everPopup.openWindowPopup("/nhepro/CBDR/CBDR0033/view.so", 1200, 800, param, "bidClose", true);
				}
				if (colIdx === 'CONT_USER_NM') {
					var param = {
						'callBackFunction': "setContUserInfo",
						'READONLY': 'Y',		// 팝업 조회조건 변경불가
						'multiYN' : 'N',        // 멀티팝업여부
						'CTRL_CD' : 'BR030',	// 구매담당자권한
						'detailView': false
					};
					everPopup.openPopupByScreenId("CCDU0020", 1100, 700, param);
				}
				if (colIdx === 'PO_USER_NM') {
					var param = {
						'callBackFunction': "setPoUserInfo",
						'READONLY': 'Y',		// 팝업 조회조건 변경불가
						'multiYN' : 'N',        // 멀티팝업여부
						'CTRL_CD' : 'BR030',	// 구매담당자권한
						'detailView': false
					};
					everPopup.openPopupByScreenId("CCDU0020", 1100, 700, param);
				}
			});

			gridI.cellClickEvent(function(rowIdx, colIdx, value) {

				eventRowIdI = rowIdx;

				if (colIdx == 'multiSelect') {
					var sel = {startItem : rowIdx, endItem : rowIdx, style : "rows"};
					gridI._gvo.setSelection(sel);
				}

				if (colIdx === 'PR_BUYER_NM') {
					if(EVF.isEmpty(gridI.getCellValue(rowIdx, 'EXEC_SQ'))) {
						return EVF.alert("${CBDI0061_010}");
					}
					var param = {
						callBackFunction : "setBuyerCd"
					};
					everPopup.openCommonPopup(param, 'SP0066');
				}
				if (colIdx === 'ITEM_CD') {
					var param = {
						PROJECT_SQ: null,
						detailView: false,
						callType : "S",
						callbackFunction: "itemCdCallback"
					};
					everPopup.openPopupByScreenId("CITR0042", 1150, 810, param);
				}
				if (colIdx === 'MAKER_NM') {
					if (EVF.isEmpty(gridI.getCellValue(rowIdx, 'PR_BUYER_CD'))) {
						return EVF.alert('${CBDI0061_008}');
					}
					everPopup.openCommonPopup({
						callBackFunction: 'makerNmCallback',
						BUYER_CD : gridI.getCellValue(rowIdx, 'PR_BUYER_CD'),
						rowIdx: rowIdx
					}, 'SP0120');
				}
				if(colIdx == "REQ_NUM") {
					var rfxType = gridI.getCellValue(rowIdx, "RFX_TYPE");
					if(rfxType == "BID") {
						var param = {
							'buyerCd'      : gridI.getCellValue(rowIdx, 'BUYER_CD'),
							'bidNum'       : gridI.getCellValue(rowIdx, 'REQ_NUM'),
							'bidCnt'       : gridI.getCellValue(rowIdx, 'REQ_CNT'),
							'baseDataType' : "ModifyBID",
							'popupFlag'    : true,
							'detailView'   : true
						};
						var callUrl = "/nhepro/CBDI/CBDI0011/view.so";
						everPopup.openWindowPopup(callUrl, 1200, 800, param, "bidDetail", true);
					}
					else {
						var param = {
		                        callbackFunction: "",
		                        BUYER_CD: gridI.getCellValue(rowIdx, "BUYER_CD"),
		                        RFX_NUM: gridI.getCellValue(rowIdx, "REQ_NUM"),
		                        RFX_CNT: gridI.getCellValue(rowIdx, "REQ_CNT"),
		                        detailView: true,
		                        buttonView: false
		                    };
	                    everPopup.openPopupByScreenId("CRQI0011", 1200, 900, param);
	        		}
				}
				if(colIdx == "PR_NUM") {
					var param = {
						prNum: gridI.getCellValue(rowIdx, "PR_NUM"),
						buyerCd : gridI.getCellValue(rowIdx, "PB_BUYER_CD"),
						popupFlag: true,
						detailView : true
					};
					everPopup.openPopupByScreenId("CPRI0010", 1200, 900, param);
				}
				if(colIdx == "BATT_FILE_CNT") {
					var param = {
						attFileNum: gridI.getCellValue(rowIdx, 'BATT_FILE_NUM'),
						rowIdx: rowIdx,
						callBackFunction: 'setFileAttach',
						bizType: 'BID',
						detailView : true
					};
					everPopup.fileAttachPopup(param);
				}
				if (colIdx == 'BITEM_RMK') {
					var param = {
						title: "${CBDI0061_006}",
						message: gridI.getCellValue(rowIdx, 'BITEM_RMK')
					};
					everPopup.commonTextView(param);
				}
				if(colIdx == "SATT_FILE_CNT") {
					var param = {
						attFileNum: gridI.getCellValue(rowIdx, 'SATT_FILE_NUM'),
						rowIdx: rowIdx,
						callBackFunction: 'setFileAttach',
						bizType: 'SBDI',
						detailView : true
					};
					everPopup.fileAttachPopup(param);
				}
				if (colIdx == 'SITEM_RMK') {
					var param = {
						title: "${CBDI0061_007}",
						message: gridI.getCellValue(rowIdx, 'SITEM_RMK')
					};
					everPopup.commonTextView(param);
				}
				if (colIdx == 'SPEC_VIEW') {
					var rfxType = gridI.getCellValue(rowIdx, "RFX_TYPE");
					if(rfxType == "BID") {
						
					} else {
						var params = {
		                		BUYER_CD: gridI.getCellValue(rowIdx, 'BUYER_CD'),
		                		RFX_NUM: gridI.getCellValue(rowIdx, 'REQ_NUM'),
			                	RFX_CNT: gridI.getCellValue(rowIdx, 'REQ_CNT'),
			                    detailView: false,
			                    popupFlag: true,
			                    callBackFunction: "doSearch"
			                };
		                everPopup.openPopupByScreenId("CRQI0041", 1200, 800, params);
					}
				}
			});

			gridI.cellChangeEvent(function(rowIdx, colIdx, iRow, iCol, value, oldValue) {

                if (colIdx == "PR_QT" || colIdx == "UNIT_PRC") {
					var preUnitPrc = Number(gridI.getCellValue(rowIdx, 'PRE_UNIT_PRC'));
					var unitPrc = Number(gridI.getCellValue(rowIdx, 'UNIT_PRC'));
					var prQt = Number(gridI.getCellValue(rowIdx, 'PR_QT'));
					if(EVF.isNotEmpty(preUnitPrc) && preUnitPrc > 0 && EVF.isNotEmpty(unitPrc) && unitPrc > 0) {
						gridI.setCellValue(rowIdx, 'DISCOUNT_RATE', ((preUnitPrc - unitPrc) / preUnitPrc) * 100);
					} else {
						gridI.setCellValue(rowIdx, 'DISCOUNT_RATE', null);
					}
					if(EVF.isNotEmpty(unitPrc) && unitPrc > 0 && EVF.isNotEmpty(prQt) && prQt > 0) {
						gridI.setCellValue(rowIdx, 'PR_AMT', unitPrc * prQt);
					} else {
						gridI.setCellValue(rowIdx, 'PR_AMT', null);
					}
                }
			});

			if(${!havePermission}) {
				EVF.C('Save').setDisabled(true);
				EVF.C('Approval').setDisabled(true);
				EVF.C('Delete').setDisabled(true);
				EVF.C('CopyItem').setDisabled(true);
				EVF.C('doDeleteItem').setDisabled(true);
			}
			else {
				if("${formData.EXEC_NUM }" == null || "${formData.EXEC_NUM }" == "") {
					EVF.C('Delete').setDisabled(true);
				} else {
					if("${formData.SIGN_STATUS }" == "P" || "${formData.SIGN_STATUS }" == "E") {
						EVF.C('Save').setDisabled(true);
						EVF.C('Approval').setDisabled(true);
						EVF.C('Delete').setDisabled(true);
						EVF.C('CopyItem').setDisabled(true);
						EVF.C('doDeleteItem').setDisabled(true);
					}
				}
			}

			<%-- 입찰의 TCO 여부가 “Y”인 경우 “TCO 년수”와 “TCO 비용”을 Display --%>
			if(tcoFlag == "N") {
                gridV.hideCol('TCO_YEAR_CNT', true);
                gridV.hideCol('TCO_AMT', true);
            }

			gridV.setProperty('shrinkToFit', true);		// 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
			gridV.setProperty('rowNumbers', ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
			gridV.setProperty('sortable', ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
			gridV.setProperty('panelVisible', ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
			gridV.setProperty('enterToNextRow', ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
			gridV.setProperty('acceptZero', ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
			gridV.setProperty('singleSelect', ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]
			gridV.setProperty('multiSelect', false);                // [선택] 컬럼의 사용여부를 지정한다. [true/false]

            gridI.setProperty('shrinkToFit', ${shrinkToFit});
            gridI.setProperty('rowNumbers', ${rowNumbers});
            gridI.setProperty('sortable', ${sortable});
            gridI.setProperty('panelVisible', ${panelVisible});
            gridI.setProperty('enterToNextRow', ${enterToNextRow});
            gridI.setProperty('acceptZero', ${acceptZero});
            gridI.setProperty('singleSelect', ${singleSelect});
            gridI.setProperty('multiSelect', ${param.detailView == true ? false : multiSelect});
			
            gridI.setColGroup([
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
		    gridV.setProperty('footerVisible', val);

		    var footer = {
		          "styles": {
		              "textAlignment": "center",
		              "fontBold": true,
		              "fontFmaily": "Nanum Gothic",
		          },
		          "text": "합   계"
		    };
		    gridV.setRowFooter("VENDOR_CD", footer);

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
		    gridV.setRowFooter("RFX_AMT", distVal);
		    gridV.setRowFooter("PR_AMT", distVal);
		    gridV.setRowFooter("TCO_AMT", distVal);
		    // ===========================================================
		    
         	// ======================그리드 합계 구하기=======================
		    var val = {"visible": true, "count": 1, "height": 15};
		    gridI.setProperty('footerVisible', val);

		    var footer = {
		          "styles": {
		              "textAlignment": "center",
		              "fontBold": true,
		              "fontFmaily": "Nanum Gothic",
		          },
		          "text": "합   계"
		    };
		    gridI.setRowFooter("PR_BUYER_NM", footer);

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
		    gridI.setRowFooter("PR_QT", distVal);
		    gridI.setRowFooter("PR_AMT", distVal);
		    gridI.setRowFooter("TCO_AMT", distVal);
		    gridI.setRowFooter("CONSUMER_AMT", distVal);
		    gridI.setRowFooter("DOIB_AMOUNT", distVal);
		    // ===========================================================
		    
			doSearchVD();
		}

		function doSearchVD() {

			var store = new EVF.Store();
			store.setGrid([gridV]);
            store.setParameter("paramExecWtNum", paramExecWtNum);
			store.load(baseUrl + 'cbdi0061_doSearchVD.so', function() {

				if(gridV.getRowCount() > 0){
					
                    gridV.checkAll(true);
					
                    var tcoFlag = EVF.V("EXEC_TCO_FLAG");
                    
                    var execAmt = 0;
                    var rowIds = gridV.getSelRowId();
					for(var i in rowIds) {
						execAmt += Number(gridV.getCellValue(rowIds[i], 'PR_AMT'));
						if( tcoFlag == "1" ) {
							execAmt += Number(gridV.getCellValue(rowIds[i], 'TCO_AMT'));
						}
						if((gridV.getCellValue(rowIds[i], 'BID_NUM') != null) && (gridV.getCellValue(rowIds[i], 'BID_NUM') != "")){
							gridV.setColFontColor("RFX_AMT", "#000DFF");
							gridV.setCellFontWeight(rowIds[i], 'RFX_AMT', true);
						} else {
							
						}
					}
					EVF.V("EXEC_AMT", execAmt);
					EVF.V("HIDDEN_EXEC_AMT", execAmt);
					
                    doSearchDT();
				}
			});
		}

        function doSearchDT() {

            var store = new EVF.Store();
            store.setGrid([gridI]);
            store.setParameter("paramExecWtNum", paramExecWtNum);
            store.load(baseUrl + 'cbdi0061_doSearchDT.so', function() {
                if(gridI.getRowCount() > 0){

                    gridI.checkAll(true);
					gridI.setColIconify("BITEM_RMK", "BITEM_RMK", "comment", false);
					gridI.setColIconify("SITEM_RMK", "SITEM_RMK", "comment", false);

					var bidCnt = 0;
					var rowIds = gridI.getSelRowId();
					for(var i in rowIds) {

						var prAmt = Number(gridI.getCellValue(rowIds[i], 'PR_AMT'));
						var preUnitPrc = Number(gridI.getCellValue(rowIds[i], 'PRE_UNIT_PRC'));
						var unitPrc = Number(gridI.getCellValue(rowIds[i], 'UNIT_PRC'));
						if(EVF.isNotEmpty(preUnitPrc) && preUnitPrc > 0) {
							gridI.setCellValue(rowIds[i], 'DISCOUNT_RATE', ((preUnitPrc - unitPrc) / preUnitPrc) * 100);
						} else {
							gridI.setCellValue(rowIds[i], 'DISCOUNT_RATE', null);
						}

						var swBusAmt = Number(gridI.getCellValue(rowIds[i], 'SW_BUS_AMT'));
						if(EVF.isNotEmpty(swBusAmt) && swBusAmt > 0 && EVF.isNotEmpty(prAmt) && prAmt > 0) {
							gridI.setCellValue(rowIds[i], 'SW_BUS_RATE', ((swBusAmt - prAmt) / swBusAmt) * 100);
						} else {
							gridI.setCellValue(rowIds[i], 'SW_BUS_RATE', null);
						}

						var consumerAmt = Number(gridI.getCellValue(rowIds[i], 'CONSUMER_AMT'));
						if(EVF.isNotEmpty(consumerAmt) && consumerAmt > 0 && EVF.isNotEmpty(prAmt) && prAmt > 0) {
							gridI.setCellValue(rowIds[i], 'CONSUMER_RATE', ((consumerAmt - prAmt) / consumerAmt) * 100);
						} else {
							gridI.setCellValue(rowIds[i], 'CONSUMER_RATE', null);
						}

						if(gridI.getCellValue(rowIds[i], 'RFX_TYPE') == "BID") {
							bidCnt++;
						}

						<%-- 구매유형이 '용역'인 경우, [SW사업대가, 상주여부] 필수 --%>
						if(gridI.getCellValue(rowIds[i], 'PURCHASE_TYPE') == "S") {
							gridI.setCellReadOnly(rowIds[i], 'SW_BUS_AMT', false);
							gridI.setCellRequired(rowIds[i], 'SW_BUS_AMT', true);
							gridI.setCellReadOnly(rowIds[i], 'MNT_SANGJU_YN', false);
							gridI.setCellRequired(rowIds[i], 'MNT_SANGJU_YN', true);
						}
						<%-- 구매유형이 '물품/공사'인 경우, [소비자금액, 무상유지보수기간, 유상요율] 필수 --%>
						if(gridI.getCellValue(rowIds[i], 'PURCHASE_TYPE') == "G" || gridI.getCellValue(rowIds[i], 'PURCHASE_TYPE') == "C") {
							gridI.setCellReadOnly(rowIds[i], 'CONSUMER_AMT', false);
							gridI.setCellRequired(rowIds[i], 'CONSUMER_AMT', true);
							gridI.setCellReadOnly(rowIds[i], 'FC_MNT_TERM', false);
							gridI.setCellRequired(rowIds[i], 'FC_MNT_TERM', true);
							gridI.setCellReadOnly(rowIds[i], 'CH_RATE', false);
							gridI.setCellRequired(rowIds[i], 'CH_RATE', true);
						}
						<%-- 구매유형이 '유지보수'인 경우, [도입금액, 유지보수요율, 유지보수시작일, 유지보수종료일, 개월수, 정기점검주기, 장애복구목표시간] 필수 --%>
						if(gridI.getCellValue(rowIds[i], 'PURCHASE_TYPE') == "M") {
							gridI.setCellReadOnly(rowIds[i], 'DOIB_AMOUNT', false);
							gridI.setCellRequired(rowIds[i], 'DOIB_AMOUNT', true);
							gridI.setCellReadOnly(rowIds[i], 'MNT_RATE', false);
							gridI.setCellRequired(rowIds[i], 'MNT_RATE', true);
							gridI.setCellReadOnly(rowIds[i], 'MNT_SDAY', false);
							gridI.setCellRequired(rowIds[i], 'MNT_SDAY', true);
							gridI.setCellReadOnly(rowIds[i], 'MNT_EDAY', false);
							gridI.setCellRequired(rowIds[i], 'MNT_EDAY', true);
							gridI.setCellReadOnly(rowIds[i], 'MNT_GUR_MONTH', false);
							gridI.setCellRequired(rowIds[i], 'MNT_GUR_MONTH', true);
							gridI.setCellReadOnly(rowIds[i], 'RT_INSP_PERIOD', false);
							gridI.setCellRequired(rowIds[i], 'RT_INSP_PERIOD', true);
							gridI.setCellReadOnly(rowIds[i], 'FALT_RC_TG_TIME', false);
							gridI.setCellRequired(rowIds[i], 'FALT_RC_TG_TIME', true);
						}
						<%-- 구매유형이 '도급'인 경우, [유지보수시작일, 유지보수종료일, 개월수, 정기점검주기, 장애복구목표시간] 필수 --%>
						if(gridI.getCellValue(rowIds[i], 'PURCHASE_TYPE') == "O") {
							gridI.setCellReadOnly(rowIds[i], 'MNT_SDAY', false);
							gridI.setCellRequired(rowIds[i], 'MNT_SDAY', true);
							gridI.setCellReadOnly(rowIds[i], 'MNT_EDAY', false);
							gridI.setCellRequired(rowIds[i], 'MNT_EDAY', true);
							gridI.setCellReadOnly(rowIds[i], 'MNT_GUR_MONTH', false);
							gridI.setCellRequired(rowIds[i], 'MNT_GUR_MONTH', true);
							gridI.setCellReadOnly(rowIds[i], 'RT_INSP_PERIOD', false);
							gridI.setCellRequired(rowIds[i], 'RT_INSP_PERIOD', true);
							gridI.setCellReadOnly(rowIds[i], 'FALT_RC_TG_TIME', false);
							gridI.setCellRequired(rowIds[i], 'FALT_RC_TG_TIME', true);
						}
					}
					if(bidCnt > 0) {
						gridI.hideCol('INFO_FLAG', true);
						gridI.hideCol('VALID_FROM_DATE', true);
						gridI.hideCol('VALID_TO_DATE', true);
					}
                }
            });
        }

		function doSave() {

			var signStatus = this.getData().data;
			EVF.C("SIGN_STATUS").setValue(signStatus);

			var store = new EVF.Store();
			if(!store.validate()) { return; }

			EVF.V('HIDDEN_EXEC_DOIB_FLAG', (EVF.C("EXEC_DOIB_FLAG").isChecked() ? "1" : "0"));
			EVF.V('HIDDEN_EXEC_TCO_FLAG', (EVF.C("EXEC_TCO_FLAG").isChecked() ? "1" : "0"));

			gridV.checkAll(true);
			gridI.checkAll(true);

			if (gridI.getSelRowCount() == 0) { return EVF.alert("${CBDI0011_T031}"); }
			if (!gridI.validate().flag) { return EVF.alert(gridI.validate().msg); }

			var isAmtSame    = true;
			var diffVendorNm = "";
			
			var rowIdsV = gridV.getSelRowId();
			var rowIdsI = gridI.getSelRowId();
			for(var i in rowIdsV) {
				var vendorCd = gridV.getCellValue(rowIdsV[i], 'VENDOR_CD');
				var vendorNm = gridV.getCellValue(rowIdsV[i], 'VENDOR_NM');
				
				// 2021.06.10 : 도입금액 => 입찰/견적금액, TCO금액으로 변경
				// 품목별 도입금액 체크
				var vendorPrAmt  = Number(gridV.getCellValue(rowIdsV[i], 'RFX_AMT')); // 협력사별 도입금액(=입찰/견적금액)
				var sumVendorAmt = 0;
				for(var j in rowIdsI) {
					if(vendorCd == gridI.getCellValue(rowIdsI[j], 'VENDOR_CD')) {
						sumVendorAmt += Number(gridI.getCellValue(rowIdsI[j], 'PR_AMT')); // 품목별 도입금액
					}
				}
				
				// 협력사별 도입금액은 견적/입찰금액보다 적을 수 있다. (클수는 없음)
				// 2020.10.26 : 입찰금액 >= 품목정보에 입력한 도입금액(단가) 합계
				if( sumVendorAmt > vendorPrAmt ) {
					var commaAmt = "";
					var amtStr   = vendorPrAmt + "";
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
					return EVF.alert(vendorNm + "${CBDI0061_011}" + "입찰/견적금액인 (" + commaAmt + ")" + "${CBDI0061_012_2}");
				}
				
				// 협력사별 도입금액과 품목별 도입금액의 합이 다른 경우
				if(vendorPrAmt != sumVendorAmt){
					isAmtSame = false;
					diffVendorNm = vendorNm;
				}
			}
			
			var confirmAmtMsg = ( !isAmtSame ? diffVendorNm + "${CBDI0061_016}" : "");
			
			// 입찰금액 > 품목정보 가격 인 경우
			// => 금액이 다르다는 알림 출력 후 계속 진행여부 체크함.
			if( ! isAmtSame ){
				EVF.confirm(confirmAmtMsg, function(){
					var confirmMsg = (signStatus == "T" ? "${msg.M0021}" : "${msg.M0100}");
					EVF.confirm(confirmMsg, function () {
						if (signStatus === 'T' || signStatus === 'E') {
							goApproval();
						}
						else if (signStatus === 'P') {
							var param = {
								subject: EVF.V('EXEC_SUBJECT'),
								docType: "EXEC",
								signStatus: signStatus,
								screenId: "CBDI0061",
								approvalType: 'APPROVAL',
								attFileNum: "",
								docNum: EVF.V('EXEC_NUM'),
								appDocNum: EVF.V('APP_DOC_NUM'),
								callBackFunction: "goApproval",
								appAmt: eval(EVF.V('EXEC_AMT')),
								contType: contType
							};
							everPopup.openApprovalRequestIPopup(param);
						}
					});
				});
			}// 입찰금액 = 품목정보 가격 인 경우 
			else {
				var confirmMsg = (signStatus == "T" ? "${msg.M0021}" : "${msg.M0100}");
				EVF.confirm(confirmMsg, function () {
					if (signStatus === 'T' || signStatus === 'E') {
						goApproval();
					}
					else if (signStatus === 'P') {
						var param = {
							subject: EVF.V('EXEC_SUBJECT'),
							docType: "EXEC",
							signStatus: signStatus,
							screenId: "CBDI0061",
							approvalType: 'APPROVAL',
							attFileNum: "",
							docNum: EVF.V('EXEC_NUM'),
							appDocNum: EVF.V('APP_DOC_NUM'),
							callBackFunction: "goApproval",
							appAmt: eval(EVF.V('EXEC_AMT')), 
							contType: contType
						};
						everPopup.openApprovalRequestIPopup(param);
					}
				});
			}
		}

		function goApproval(formData, gridData, attachData) {

			EVF.C('approvalFormData').setValue(formData);
			EVF.C('approvalGridData').setValue(gridData);
			EVF.C('attachFileDatas').setValue(attachData);

			var store = new EVF.Store();
			store.setGrid([gridV, gridI]);
			store.getGridData(gridV, 'sel');
			store.getGridData(gridI, 'sel');
			
			store.doFileUpload(function() {
				store.load(baseUrl + 'cbdi0061_doSave.so', function(){

					var buyerCd = this.getParameter("buyerCd");
					var execNum = this.getParameter("execNum");
					EVF.alert(this.getResponseMessage(), function() {
						var param = {
							'buyerCd' : buyerCd,
							'execNum' : execNum,
                            'tcoFlag' : tcoFlag,
							'popupFlag' : true,
							'detailView' : false
						};
						if(popupFlag) {
                            opener.doSearch();
							window.location.href = '/nhepro/CBDR/CBDI0061/view.so?' + $.param(param);
						}
						else { document.location.href = '/nhepro/CBDR/CBDI0061/view.so?' + $.param(param); }
					});
				});
			});
		}

		function doDelete() {

			var popupFlag = ${(param.popupFlag == null || !param.popupFlag) ? false : true};
			
			gridI.checkAll(true);
			EVF.confirm("${CBDI0061_015 }", function () {
				EVF.confirm("${msg.M0013 }", function () {
					var store = new EVF.Store();
					store.setGrid([gridI]);
					store.getGridData(gridI, 'sel');
					store.load(baseUrl + 'cbdi0061_doDelete.so', function() {
						EVF.alert(this.getResponseMessage(), function() {
							if(popupFlag) {
								opener.doSearch();
								doClose();
							}
						});
					});
				});
			});
		}
		
		function doCopyItem() {

			if (gridI.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
			if (gridI.getSelRowCount() > 1) { return EVF.alert("${msg.M0006}"); }
			
			var rowIds = gridI.getSelRowId();
			gridI.checkAll(false);
			for(var i = 0; i < rowIds.length; i++) {
				var sel = {startItem : rowIds[i], endItem : rowIds[i], style : "rows"};
				gridI._gvo.setSelection(sel);
			}
			
			gridI.insertRow(true);
			
			<%-- 복사한 Row의 ITEM_SQ 값을 지운다. --%>
			var copyRowIds = gridI.getSelRowId();
			for(var c = 0; c < rowIds.length; c++) {
				gridI.setCellValue(copyRowIds[c], 'EXEC_SQ', null);
			}
		}

		/* function doDelItem() {

			if (gridI.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

			var msgStr = "";
			var selRowId = gridI.getSelRowId();
			for(var i = selRowId.length-1; i > -1; i--) {
				var sameCnt = 0;
				var allRowId = gridI.getAllRowId();
				for(var j = allRowId.length-1; j > -1; j--) {
					if ((gridI.getCellValue(selRowId[i], "PB_BUYER_CD") == gridI.getCellValue(allRowId[j], "PB_BUYER_CD"))
						&& (gridI.getCellValue(selRowId[i], "PR_NUM") == gridI.getCellValue(allRowId[j], "PR_NUM"))
						&& (gridI.getCellValue(selRowId[i], "PR_SQ") == gridI.getCellValue(allRowId[j], "PR_SQ"))) {
						sameCnt++;
					}
				}
				if(sameCnt > 1) {
					gridI.delRow(selRowId[i]);
				} else {
					msgStr = gridI.getCellValue(selRowId[i], "ITEM_DESC") + "," + msgStr;
				}
			}

			if(msgStr.length > 0) {
				msgStr = msgStr.substring(0, msgStr.length-1);
				EVF.alert(msgStr + "${CBDI0061_009}");
			}
		} */
		
		function doDeleteItem() {
            if(gridI.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
			
            if(gridI.getSelRowCount() == gridI.getRowCount()) {
                return EVF.alert("${CBDI0061_018}")
            }
            
            EVF.confirm("${CBDI0061_017}", function () {	
            	for(var i = gridI.getRowCount() - 1; i >= 0; i--) {
                    if(gridI.isChecked(i)) {
                    	gridI.delRow(i);
                    }
                }
            });
        }

		function setContUserInfo(data) {
			gridV.setCellValue(eventRowIdV, 'CONT_USER_ID', data.USER_ID);
			gridV.setCellValue(eventRowIdV, 'CONT_USER_NM', data.USER_NM);

			if(data != null){
				data = JSON.parse(data);
				gridV.setCellValue(eventRowIdV, 'CONT_USER_ID', data.USER_ID);
				gridV.setCellValue(eventRowIdV, 'CONT_USER_NM', data.USER_NM);
			}
		}

		function setPoUserInfo(data) {
			gridV.setCellValue(eventRowIdV, 'PO_USER_ID', data.USER_ID);
			gridV.setCellValue(eventRowIdV, 'PO_USER_NM', data.USER_NM);

			if(data != null){
				data = JSON.parse(data);
				gridV.setCellValue(eventRowIdV, 'PO_USER_ID', data.USER_ID);
				gridV.setCellValue(eventRowIdV, 'PO_USER_NM', data.USER_NM);
			}
		}

		function setBuyerCd(data) {
			gridI.setCellValue(eventRowIdI, 'PR_BUYER_CD', data.CUST_CD);
			gridI.setCellValue(eventRowIdI, 'PR_BUYER_NM', data.CUST_NM);
		}

		function itemCdCallback(data) {

			for(var i in data) {
				gridI.setCellValue(eventRowIdI, 'ITEM_CD', data[i].ITEM_CD);
				gridI.setCellValue(eventRowIdI, 'ITEM_DESC', data[i].ITEM_DESC);
				gridI.setCellValue(eventRowIdI, 'ITEM_SPEC', data[i].ITEM_SPEC);
				gridI.setCellValue(eventRowIdI, 'MAKER_NM', data[i].MAKER_NM);
				gridI.setCellValue(eventRowIdI, 'MAKER_CD', data[i].MAKER_CD);
				gridI.setCellValue(eventRowIdI, 'MAKER_ART_NO', data[i].MAKER_PART_NO);
				gridI.setCellValue(eventRowIdI, 'ORIGIN_CD', data[i].ORIGIN_CD);
				gridI.setCellValue(eventRowIdI, 'UNIT_CD', data[i].UNIT_CD);
			}
		}

		function makerNmCallback(result) {
			gridI.setCellValue(eventRowIdI, 'MAKER_NM', result.MKBR_NM);
			gridI.setCellValue(eventRowIdI, 'MAKER_CD', result.MKBR_CD);
		}

		function calExecAmt() {

			var tcoFlag = (EVF.C("EXEC_TCO_FLAG").isChecked() ? "1" : "0");
			var execAmt = 0;

			var rowIds = gridV.getSelRowId();
			for(var i in rowIds) {
				if(tcoFlag == "1") {
					execAmt = execAmt + (Number(gridV.getCellValue(rowIds[i], 'PR_AMT')) + Number(gridV.getCellValue(rowIds[i], 'TCO_AMT')));
				} else {
					execAmt = execAmt + Number(gridV.getCellValue(rowIds[i], 'PR_AMT'))
				}
			}
			EVF.V('EXEC_AMT', execAmt);
			EVF.V("HIDDEN_EXEC_AMT", execAmt);
		}

		function doClose() {
			EVF.closeWindow();
		}
	</script>

	<e:window id="CBDI0061" initData="${initData}" onReady="init" title="${fullScreenName }" breadCrumbs="${breadCrumb }">

		<%-- 일반정보 --%>
		<div class="e-component e-title-container" data-uuid="Title-541-391-560">
			<div class="e-title-bullet-h1"></div>
			<div class="e-title-text">${CBDI0061_001 }</div>
		</div>
		<e:searchPanel id="form1" labelWidth="${longLabelWidth}" width="100%" columnCount="2" useTitleBar="false">

			<e:inputHidden id="BUYER_CD" name="BUYER_CD" value="${formData.BUYER_CD}" />
			<e:inputHidden id="DEPT_CD" name="DEPT_CD" value="${formData.DEPT_CD}" />
			<e:inputHidden id="EXEC_TYPE" name="EXEC_TYPE" value="${formData.EXEC_TYPE}" />
			<e:inputHidden id="APPROVAL_FLAG" name="APPROVAL_FLAG" value="${formData.APPROVAL_FLAG}" />
			<e:inputHidden id='APP_DOC_NUM' name="APP_DOC_NUM" value="${empty param.appDocNum ? formData.APP_DOC_NUM : param.appDocNum}" />
			<e:inputHidden id='APP_DOC_CNT' name="APP_DOC_CNT" value="${formData.APP_DOC_CNT}" />
			<e:inputHidden id="SIGN_STATUS" name="SIGN_STATUS" value="${formData.SIGN_STATUS}" />
			<e:inputHidden id="OLD_SIGN_STATUS" name="OLD_SIGN_STATUS" value="${formData.SIGN_STATUS}" />
			<e:inputHidden id="HIDDEN_EXEC_DOIB_FLAG" name="HIDDEN_EXEC_DOIB_FLAG" value="${formData.EXEC_DOIB_FLAG}" />
			<e:inputHidden id="HIDDEN_EXEC_TCO_FLAG" name="HIDDEN_EXEC_TCO_FLAG" value="${formData.EXEC_TCO_FLAG}" />
			<e:inputHidden id="HIDDEN_EXEC_AMT" name="HIDDEN_EXEC_AMT" />
			<e:inputHidden id="approvalFormData" name="approvalFormData" />
			<e:inputHidden id="approvalGridData" name="approvalGridData" />
			<e:inputHidden id="attachFileDatas" name="attachFileDatas" />

			<e:row>
				<e:label for="EXEC_NUM" title="${form_EXEC_NUM_N}"/>
				<e:field>
					<e:inputText id="EXEC_NUM" name="EXEC_NUM" value="${formData.EXEC_NUM }" width="${form_EXEC_NUM_W}" maxLength="${form_EXEC_NUM_M}" disabled="${form_EXEC_NUM_D}" readOnly="${form_EXEC_NUM_RO}" required="${form_EXEC_NUM_R}" />
				</e:field>
				<e:label for="REF_DOC_NUM" title="${form_REF_DOC_NUM_N}"/>
				<e:field>
					<e:inputText id="REF_DOC_NUM" name="REF_DOC_NUM" value="${formData.REF_DOC_NUM }" width="${form_REF_DOC_NUM_W}" maxLength="${form_REF_DOC_NUM_M}" disabled="${form_REF_DOC_NUM_D}" readOnly="${form_REF_DOC_NUM_RO}" required="${form_REF_DOC_NUM_R}" />
				</e:field>
			</e:row>
			<e:row>
				<e:label for="EXEC_SUBJECT" title="${form_EXEC_SUBJECT_N}"/>
				<e:field colSpan="3">
					<e:inputText id="EXEC_SUBJECT" name="EXEC_SUBJECT" value="${formData.EXEC_SUBJECT }" width="${form_EXEC_SUBJECT_W}" maxLength="${form_EXEC_SUBJECT_M}" disabled="${form_EXEC_SUBJECT_D}" readOnly="${form_EXEC_SUBJECT_RO}" required="${form_EXEC_SUBJECT_R}" />
				</e:field>
			</e:row>
			<e:row>
				<e:label for="EXEC_DATE" title="${form_EXEC_DATE_N}" />
				<e:field>
					<e:inputDate id="EXEC_DATE" name="EXEC_DATE" value="${formData.EXEC_DATE }" width="${inputDateWidth }" required="${form_EXEC_DATE_R}" disabled="${form_EXEC_DATE_D}" readOnly="${form_EXEC_DATE_RO}" datePicker="true" />
				</e:field>
				<e:label for="CTRL_USER_NM" title="${form_CTRL_USER_NM_N}"/>
				<e:field>
					<e:inputText id="CTRL_USER_NM" name="CTRL_USER_NM" value="${formData.CTRL_USER_NM }" width="${form_CTRL_USER_NM_W}" maxLength="${form_CTRL_USER_NM_M}" disabled="${form_CTRL_USER_NM_D}" readOnly="${form_CTRL_USER_NM_RO}" required="${form_CTRL_USER_NM_R}" />
					<e:inputHidden id="CTRL_USER_ID" name="CTRL_USER_ID" value="${formData.CTRL_USER_ID}" />
				</e:field>
			</e:row>
			<e:row>
				<e:label for="CUR" title="${form_CUR_N}" />
				<e:field colSpan="3">
					<e:inputNumber id="EXEC_AMT" name="EXEC_AMT" value='${formData.EXEC_AMT }' align='right' width='160px' required='${form_EXEC_AMT_R }' readOnly='${form_EXEC_AMT_RO }' disabled='${form_EXEC_AMT_D }' visible='${form_EXEC_AMT_V }' decimalPlace="0" /><e:text>&nbsp;</e:text>
					<e:select id="CUR" name="CUR" value="${formData.CUR }" options="${curOptions }" width="80px" disabled="${form_CUR_D}" readOnly="${form_CUR_RO}" required="${form_CUR_R}" placeHolder="" />
					<e:select id="VAT_TYPE" name="VAT_TYPE" value="${formData.VAT_TYPE }" options="${vatTypeOptions }" width="80px" style="text-align: center;" disabled="${form_VAT_TYPE_D}" readOnly="${form_VAT_TYPE_RO}" required="${form_VAT_TYPE_R}" placeHolder="" />
					<e:check id='EXEC_DOIB_FLAG' name="EXEC_DOIB_FLAG" value="1" checked="${formData.EXEC_DOIB_FLAG eq '1' ? 'true' : 'false'}" width='${inputTextWidth }' required='${form_EXEC_DOIB_FLAG_R }' disabled='true' visible='${form_EXEC_DOIB_FLAG_V }' />
					<e:text id="txt1" style="position: relative; left: -4px; padding: 0;">${CBDI0061_004 }</e:text>
					<e:check id='EXEC_TCO_FLAG' name="EXEC_TCO_FLAG" value="1" checked="${formData.EXEC_TCO_FLAG eq '1' ? 'true' : 'false'}" width='${inputTextWidth }' required='${form_EXEC_TCO_FLAG_R }' disabled='${form_EXEC_TCO_FLAG_D }' visible='${form_EXEC_TCO_FLAG_V }' onChange="calExecAmt" />
					<e:text id="txt2" style="position: relative; left: -4px; padding: 0;">${CBDI0061_005 }</e:text>
				</e:field>
			</e:row>
			<e:row>
				<e:label for="RMK_TEXT_CONTENTS" title="${form_RMK_TEXT_CONTENTS_N }" />
				<e:field colSpan="3">
					<e:richTextEditor id="RMK_TEXT_CONTENTS" name="RMK_TEXT_CONTENTS" width="100%" height="340px" value="${formData.RMK_TEXT_CONTENTS }" required="${form_RMK_TEXT_CONTENTS_R }" readOnly="${form_RMK_TEXT_CONTENTS_RO }" disabled="${form_RMK_TEXT_CONTENTS_D }" useToolbar="${!param.detailView}" />
					<e:inputHidden id="RMK_TEXT_NUM" name="RMK_TEXT_NUM" value="${formData.RMK_TEXT_NUM }" />
				</e:field>
			</e:row>
			<e:row>
				<e:label for="ATT_FILE_NUM" title="${form_ATT_FILE_NUM_N}"/>
				<e:field colSpan="3">
					<e:fileManager id="ATT_FILE_NUM" height="150" width="100%" fileId="${formData.ATT_FILE_NUM}" readOnly="${form_ATT_FILE_NUM_RO}" bizType="EXEC" required="${form_ATT_FILE_NUM_R}"/>
				</e:field>
			</e:row>
		</e:searchPanel>

		<%-- 협력업체 정보 --%>
		<div class="e-component e-title-container" data-uuid="Title-541-391-560">
			<div class="e-title-bullet-h1"></div>
			<div class="e-title-text">${CBDI0061_002 }</div>
		</div>

		<e:gridPanel id="gridV" name="gridV" width="100%" height="220px" gridType="${_gridType}" readOnly="${param.detailView}" />

		<%-- 품목 정보 --%>
        <e:buttonBar id="itemBtnBar" align="right" width="100%" title="${CBDI0061_003 }">
            <e:button id="CopyItem" name="CopyItem" label="${CopyItem_N }" disabled="${CopyItem_D }" visible="${CopyItem_V}" onClick="doCopyItem" />
            <%-- <e:button id="DelItem" name="DelItem" label="${DelItem_N }" disabled="${DelItem_D }" visible="${DelItem_V}" onClick="doDelItem" /> --%>
        	<e:button id="doDeleteItem" name="doDeleteItem" label="${doDeleteItem_N}" disabled="${doDeleteItem_D}" visible="${doDeleteItem_V}" onClick="doDeleteItem"/>
        </e:buttonBar>

		<e:gridPanel id="gridI" name="gridI" width="100%" height="400px" gridType="${_gridType}" readOnly="${param.detailView}" />

		<e:buttonBar id="buttonBar" align="right" width="100%" title="${form_CAPTION_N }">
			<e:button id="Save" name="Save" label="${Save_N }" disabled="${Save_D }" visible="${Save_V}" onClick="doSave" data="T" />
			<e:button id="Approval" name="Approval" label="${Approval_N }" disabled="${Approval_D }" visible="${Approval_V}" onClick="doSave" data="P" />
			<e:button id="Delete" name="Delete" label="${Delete_N }" disabled="${Delete_D }" visible="${Delete_V}" onClick="doDelete" />
        <c:if test="${param.popupFlag == true}">
            <e:button id="Close" name="Close" label="${Close_N }" disabled="${Close_D }" visible="${Close_V}" onClick="doClose" />
        </c:if>
		</e:buttonBar>

		<%-- 결재자 리스트 Include --%>
		<jsp:include page="/WEB-INF/views/nhepro/CWOR/CWOR0013.jsp" flush="true" >
			<jsp:param value="${formData.APP_DOC_NUM}" name="APP_DOC_NUM"/>
			<jsp:param value="${formData.APP_DOC_CNT}" name="APP_DOC_CNT"/>
			<jsp:param value="${formData.BUYER_CD}" name="BUYER_CD"/>
		</jsp:include>

	</e:window>
</e:ui>