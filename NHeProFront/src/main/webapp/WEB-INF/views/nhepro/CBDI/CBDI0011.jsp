<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">

	<script type="text/javascript">

		var gridI; var gridE;
		var eventRowId;
		var eventRowIdE;
		var isDetailView = ('${param.detailView}' === 'true' ? true : (("${formData.SIGN_STATUS }" == "P" || "${formData.SIGN_STATUS }" == "E") ? true : false));
		var baseDataType = ("${param.baseDataType}" == null ? "" : "${param.baseDataType}");
		var oriBaseDataType = ("${param.baseDataType}" == null ? "" : "${param.baseDataType}");
		var paramPrNumSq = ("${param.paramPrNumSq}" == null ? "" : "${param.paramPrNumSq}");
		var userType = "${ses.userType}";
		var baseUrl = "/nhepro/CBDI/";
		var btnFlag = true;

		function init() {

			gridE = EVF.C("gridE");
			gridI = EVF.C("gridI");

			gridI.cellClickEvent(function(rowIdx, colIdx, value) {

				eventRowId = rowIdx;

				if (colIdx == 'multiSelect') {
					var sel = {startItem : rowIdx, endItem : rowIdx, style : "rows"};
					gridI._gvo.setSelection(sel);
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
					if (EVF.isEmpty(gridI.getCellValue(rowIdx, 'BUYER_CD'))) {
						return EVF.alert('${CBDI0011_T021}');
					}
					everPopup.openCommonPopup({
						callBackFunction: 'makerNmCallback',
						BUYER_CD : gridI.getCellValue(rowIdx, 'BUYER_CD'),
						rowIdx: rowIdx
					}, 'SP0120');
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
			});

			gridI.cellChangeEvent(function(rowIdx, colIdx, iRow, iCol, value, oldValue) {

				if (colIdx == "PR_QT" || colIdx == "UNIT_PRC") {
					var prQt = gridI.getCellValue(rowIdx, 'PR_QT');
					var unitPrc = gridI.getCellValue(rowIdx, 'UNIT_PRC');
					if(!EVF.isEmpty(prQt) && eval(prQt) > 0 && !EVF.isEmpty(unitPrc) && eval(unitPrc) > 0) {
						gridI.setCellValue(rowIdx, 'PR_AMT', everMath.floor_float(eval(prQt) * eval(unitPrc)));
					} else {
						gridI.setCellValue(rowIdx, 'PR_AMT', 0);
					}
				}
			});

			gridE.cellClickEvent(function(rowIdx, colIdx, value) {

				eventRowIdE = rowIdx;

				if(colIdx == "EU_USER_ID") {

					<%-- 기술평가구분이 ”기술평가수행 [20]“ 인 경우, Popup을 오픈할 수 없다. --%>
					var techEvType = EVF.V('TECH_EV_TYPE');
					if(techEvType == "20") {
						var param = {
							callBackFunction : "setEvaluatorGrid"
						};
						everPopup.openCommonPopup(param, 'SP0090');
					}
				}
			});

			gridE.cellChangeEvent(function(rowIdx, colIdx, iRow, iCol, value, oldValue) {

				if (colIdx == "EU_EMAIL") {
					if(!everString.isValidEmail(gridE.getCellValue(rowIdx, 'EU_EMAIL'))) {
						gridE.setCellValue(rowIdx, 'EU_EMAIL', '');
						return EVF.alert("${msg.EMAIL_INVALID}");
					}
				}
				if (colIdx == "EU_PHONE_NUM") {
					var CellNum = gridE.getCellValue(rowIdx, 'EU_PHONE_NUM');
					var rgEx = /(01[016789])[-](\d{4}|\d{3})[-]\d{4}$/g;
					var chkFlg = rgEx.test(CellNum);
					if(!chkFlg){
						gridE.setCellValue(rowIdx, 'EU_PHONE_NUM', '');
						return EVF.alert("${msg.CELL_NUM_INVALID}");
					}
				}
			});

			if(${havePermission}) {

				gridE.addRowEvent(function() {
					var techEvType = EVF.C("TECH_EV_TYPE").getValue();
					if(EVF.isEmpty(techEvType) || techEvType != "20") {
						return EVF.alert("${CBDI0011_T030}");
					}
					if(techEvType == "20") {
						var addParam = [
							{"EU_TYPE" : "20"}
						];
						gridE.addRow(addParam);
					}
				});

				gridE.delRowEvent(function() {
					var techEvType = EVF.C("TECH_EV_TYPE").getValue();
					if(EVF.isEmpty(techEvType) || techEvType != "20") {
						return EVF.alert("${CBDI0011_T030}");
					}
					if(techEvType == "20") {
						if (gridE.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
						gridE.delRow();
					}
				});
			}

			var visibleFlag = ${visibleFlag};

			if(${!havePermission})
			{
				EVF.C('Save').setDisabled(true);
				EVF.C('Approval').setDisabled(true);
				EVF.C('Delete').setDisabled(true);
				EVF.C('SearchEvaluator').setDisabled(true);
				EVF.C('CopyItem').setDisabled(true);
				EVF.C('DelItem').setDisabled(true);

				gridI.setColReadOnly("PURCHASE_TYPE", true);
				gridI.setColReadOnly("ITEM_DESC", true);
				gridI.setColReadOnly("ITEM_SPEC", true);
				gridI.setColReadOnly("MAKER_ART_NO", true);
				gridI.setColReadOnly("ORIGIN_CD", true);
				gridI.setColReadOnly("PR_QT", true);
				gridI.setColReadOnly("UNIT_CD", true);
				gridI.setColReadOnly("UNIT_PRC", true);

				gridE.setColReadOnly("EU_EMAIL", true);
				gridE.setColReadOnly("EU_PHONE_NUM", true);
			}
			else {
				if("${formData.BID_NUM }" == null || "${formData.BID_NUM }" == "") {
					EVF.C('Delete').setDisabled(true);
				} else {
					if("${formData.SIGN_STATUS }" == "P" || "${formData.SIGN_STATUS }" == "E")
					{
						EVF.C('Save').setDisabled(true);
						EVF.C('Approval').setDisabled(true);
						EVF.C('Delete').setDisabled(true);
						EVF.C('SearchEvaluator').setDisabled(true);
						EVF.C('CopyItem').setDisabled(true);
						EVF.C('DelItem').setDisabled(true);

						gridI.setColReadOnly("PURCHASE_TYPE", true);
						gridI.setColReadOnly("ITEM_DESC", true);
						gridI.setColReadOnly("ITEM_SPEC", true);
						gridI.setColReadOnly("MAKER_ART_NO", true);
						gridI.setColReadOnly("ORIGIN_CD", true);
						gridI.setColReadOnly("PR_QT", true);
						gridI.setColReadOnly("UNIT_CD", true);
						gridI.setColReadOnly("UNIT_PRC", true);

						gridE.setColReadOnly("EU_EMAIL", true);
						gridE.setColReadOnly("EU_PHONE_NUM", true);
					}
				}
			}

			gridI.setProperty('shrinkToFit', ${shrinkToFit});		// 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
			gridI.setProperty('rowNumbers', ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
			gridI.setProperty('sortable', ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
			gridI.setProperty('panelVisible', ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
			gridI.setProperty('enterToNextRow', ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
			gridI.setProperty('acceptZero', ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
			gridI.setProperty('singleSelect', ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]
			gridI.setProperty('multiSelect', ${param.detailView == true ? false : multiSelect}); // [선택] 컬럼의 사용여부를 지정한다. [true/false]

			gridE.setProperty('shrinkToFit', true);
			gridE.setProperty('rowNumbers', ${rowNumbers});
			gridE.setProperty('sortable', ${sortable});
			gridE.setProperty('panelVisible', ${panelVisible});
			gridE.setProperty('enterToNextRow', ${enterToNextRow});
			gridE.setProperty('acceptZero', ${acceptZero});
			gridE.setProperty('singleSelect', ${singleSelect});
			gridE.setProperty('multiSelect', ${param.detailView == true ? false : multiSelect});

			EVF.C('CONT_TYPE1').removeOption('PC');

			<%-- 계약방법(1)이 ”지명경쟁”이 아닌 경우 Disabled  --%>
			EVF.C('VENDOR_LIST').setDisabled(true);
			EVF.C('VENDOR_LIST').setRequired(false);

			if(baseDataType != "CreateBID") {
				btnFlag = false;
				chkContTypeA();
				chkContTypeB();
				chkContTypeC();
				chkAnnoOpenFlag();
				chkPropOpenFlag();
				chkTcoFlag();
				chkTechEvType();
			}
			
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
		    gridI.setRowFooter("PR_BUYER_DEPT_NM", footer);

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
		    // ===========================================================
			doSearchDT();
		}

		function doSearchDT() {

			var store = new EVF.Store();
			store.setGrid([gridI]);
			store.setParameter("baseDataType", baseDataType);
			store.setParameter("paramPrNumSq", paramPrNumSq);
			store.load(baseUrl + 'cbdi0011_doSearchDT.so', function() {

				if(gridI.getRowCount() > 0){
					gridI.checkAll(true);
					if(baseDataType == "CreateBID") {
						// 최초 PR에서 가져온 금액이 기준이 되며, 그리드에서 복사시 단가를 변경하여 PR_AMT와 동일하게 맞춰야 한다.
						var totBidAmt = 0;
						var rowIds = gridI.getAllRowId();
						for(var i = 0; i < rowIds.length; i++) {
							var prQt = gridI.getCellValue(rowIds[i], 'PR_QT');
							var unitPrc = gridI.getCellValue(rowIds[i], 'UNIT_PRC');
							if(!EVF.isEmpty(prQt) && eval(prQt) > 0 && !EVF.isEmpty(unitPrc) && eval(unitPrc) > 0) {
								totBidAmt = totBidAmt + everMath.floor_float(eval(prQt) * eval(unitPrc));
							}
						}
						EVF.V('PR_AMT', totBidAmt);
					}
				}

				<%-- 재공고인 경우, BID_NUM 등의 값을 초기화하여 새로운 공고를 작성하도록 한다. --%>
				if(baseDataType == "ReBID") {
					EVF.V("BID_NUM", "");
					EVF.V("BID_CNT", "1");
					EVF.V("VOTE_CNT", "1");
					EVF.V("SIGN_STATUS", "T");
					EVF.V("BID_USER_ID", "${ses.userId}");
					EVF.V("BID_USER_NM", "${ses.userNm}");
					EVF.V("ESTM_USER_ID", "${ses.userId}");
					EVF.V("ESTM_USER_NM", "${ses.userNm}");
					EVF.V("OPEN_USER_ID", "${ses.userId}");
					EVF.V("OPEN_USER_NM", "${ses.userNm}");
					EVF.V("EV_TPL_CNT", "");
					EVF.V("EV_TPL_NUM", "");
					EVF.V("EI_NUM", "");
					EVF.V("VENDOR_LIST", "");
					EVF.V("VENDOR_NMS", "");
					EVF.V("VENDOR_CDS", "");
					baseDataType = "CreateBID";
				}

				if(!EVF.isEmpty(EVF.V("EI_NUM"))) {
					store.setGrid([gridE]);
					store.load(baseUrl + 'cbdi0011_doSearchEU.so', function () {
						if (gridE.getRowCount() > 0) { gridE.checkAll(true); }
					});
				}
			});
		}

		function doSave() {

			var popupFlag = ${(param.popupFlag == null || !param.popupFlag) ? false : true};
			var signStatus = this.getData().data;
			EVF.C("SIGN_STATUS").setValue(signStatus);

			var store = new EVF.Store();
			if(!store.validate()) { return; }

			if(EVF.isEmpty(EVF.V("VOTE_LIMIT_CNT"))) { return alert("${CBDI0011_T039}") }

			<%-- 계약방법(1)이 ”지명경쟁 [NC]"인 경우 ① “협력업체지정” 필수이며, 2개 이상의 협력업체를 지정해야 함  그 외는 Hidden --%>
			if(EVF.V('CONT_TYPE1') == "NC") {
				if(EVF.isEmpty(EVF.V('VENDOR_CDS')) || Number(EVF.V('VENDOR_LIST')) < 2) {
					return EVF.alert("${CBDI0011_T029}"); <%-- 2개 이상의 협력업체를 지정해야 함 --%>
				}
			}
			<%-- 계약방법(2)가 ”협상에 의한 계약”인 경우 ③ “기술/가격/기술적격/종합적격“ 0점이상 필수 입력 --%>
			if(EVF.V('CONT_TYPE2') == "NE") {
				<%-- 0점이상 필수 입력 --%>
				if(EVF.isEmpty(EVF.V('TECH_SCORE')) || Number(EVF.V('TECH_SCORE')) == 0) {
					return EVF.alert("${CBDI0011_T023}");
				}
				if(EVF.isEmpty(EVF.V('PRC_SCORE')) || Number(EVF.V('PRC_SCORE')) == 0) {
					return EVF.alert("${CBDI0011_T024}");
				}
				if(EVF.isEmpty(EVF.V('MIN_TECH_SCORE')) || Number(EVF.V('MIN_TECH_SCORE')) == 0) {
					return EVF.alert("${CBDI0011_T025}");
				}
				if(EVF.isEmpty(EVF.V('MIN_TOT_SCORE')) || Number(EVF.V('MIN_TOT_SCORE')) == 0) {
					return EVF.alert("${CBDI0011_T026}");
				}
				if(Number(EVF.V('MIN_TOT_SCORE')) > 100) {
					return EVF.alert("${CBDI0011_T040}");
				}

				var techScore = eval(EVF.V('TECH_SCORE'));
				var prcScore = eval(EVF.V('PRC_SCORE'));
				var minTechScore = eval(EVF.V('MIN_TECH_SCORE'));
				<%-- 기술점수 + 가격점수 = 100 --%>
				if((techScore + prcScore) != 100) {
					return EVF.alert("${CBDI0011_T027}");
				}
				<%-- 기술점수 >= 기술적격점수 Check --%>
				if(techScore < minTechScore) {
					return EVF.alert("${CBDI0011_T028}");
				}
			}

			if(!checkTimeToServer(EVF.C("APP_BEGIN_DATE").getValue(), EVF.C("APP_BEGIN_TIME").getValue(), EVF.C("APP_BEGIN_MIN").getValue())) {
				EVF.C('APP_BEGIN_DATE').setFocus();
				return EVF.alert("${form_APP_BEGIN_DATE_N}" + '의 ' + '${CBDI0011_T018}');
			}
			if(!checkTimeToServer(EVF.C("APP_END_DATE").getValue(), EVF.C("APP_END_TIME").getValue(), EVF.C("APP_END_MIN").getValue())) {
				EVF.C('APP_END_DATE').setFocus();
				return EVF.alert("${form_APP_END_DATE_N}" + '의 ' + '${CBDI0011_T019}');
			}
			if(!checkTimeToValue(EVF.C("APP_BEGIN_DATE").getValue(), EVF.C("APP_BEGIN_TIME").getValue(), EVF.C("APP_BEGIN_MIN").getValue(), EVF.C("APP_END_DATE").getValue(), EVF.C("APP_END_TIME").getValue(), EVF.C("APP_END_MIN").getValue())) {
				EVF.C('APP_END_DATE').setFocus();
				return EVF.alert("${form_APP_END_DATE_N}" + '의 ' + '${CBDI0011_T020}');
			}

			if(!checkTimeToServer(EVF.C("BID_BEGIN_DATE").getValue(), EVF.C("BID_BEGIN_TIME").getValue(), EVF.C("BID_BEGIN_MIN").getValue())) {
				EVF.C('BID_BEGIN_DATE').setFocus();
				return EVF.alert("${form_BID_BEGIN_DATE_N}" + '의 ' + '${CBDI0011_T018}');
			}
			if(!checkTimeToServer(EVF.C("BID_END_DATE").getValue(), EVF.C("BID_END_TIME").getValue(), EVF.C("BID_END_MIN").getValue())) {
				EVF.C('BID_END_DATE').setFocus();
				return EVF.alert("${form_BID_END_DATE_N}" + '의 ' + '${CBDI0011_T019}');
			}
			if(!checkTimeToValue(EVF.C("BID_BEGIN_DATE").getValue(), EVF.C("BID_BEGIN_TIME").getValue(), EVF.C("BID_BEGIN_MIN").getValue(), EVF.C("BID_END_DATE").getValue(), EVF.C("BID_END_TIME").getValue(), EVF.C("BID_END_MIN").getValue())) {
				EVF.C('BID_END_DATE').setFocus();
				return EVF.alert("${form_BID_END_DATE_N}" + '의 ' + '${CBDI0011_T020}');
			}

			if(!checkTimeToServer(EVF.C("OPEN_DATE").getValue(), EVF.C("OPEN_TIME").getValue(), EVF.C("OPEN_MIN").getValue())) {
				EVF.C('OPEN_DATE').setFocus();
				return EVF.alert("${form_OPEN_DATE_N}" + '의 ' + '${CBDI0011_T018}');
			}

			if(!checkTimeToServer(EVF.C("ANNO_DATE").getValue(), EVF.C("ANNO_TIME_FROM").getValue(), EVF.C("ANNO_MIN_FROM").getValue())) {
				EVF.C('ANNO_DATE').setFocus();
				return EVF.alert("${form_ANNO_DATE_N}" + '의 ' + '${CBDI0011_T018}');
			}
			if(!checkTimeToValue(EVF.C("ANNO_DATE").getValue(), EVF.C("ANNO_TIME_FROM").getValue(), EVF.C("ANNO_MIN_FROM").getValue(), EVF.C("ANNO_DATE").getValue(), EVF.C("ANNO_TIME_TO").getValue(), EVF.C("ANNO_MIN_TO").getValue())) {
				EVF.C('ANNO_DATE').setFocus();
				return EVF.alert("${form_ANNO_DATE_N}" + '의 ' + '${CBDI0011_T020}');
			}

			if(!checkTimeToServer(EVF.C("PROP_DATE").getValue(), EVF.C("PROP_TIME_FROM").getValue(), EVF.C("PROP_MIN_FROM").getValue())) {
				EVF.C('PROP_DATE').setFocus();
				return EVF.alert("${form_PROP_DATE_N}" + '의 ' + '${CBDI0011_T018}');
			}
			if(!checkTimeToValue(EVF.C("PROP_DATE").getValue(), EVF.C("PROP_TIME_FROM").getValue(), EVF.C("PROP_MIN_FROM").getValue(), EVF.C("PROP_DATE").getValue(), EVF.C("PROP_TIME_TO").getValue(), EVF.C("PROP_MIN_TO").getValue())) {
				EVF.C('PROP_DATE').setFocus();
				return EVF.alert("${form_PROP_DATE_N}" + '의 ' + '${CBDI0011_T020}');
			}

			var contType2 = EVF.V('CONT_TYPE2');
			if(contType2 == "LP" || contType2 == "QE" || contType2 == "NE") {
				EVF.V('ORI_DIFF_GUAR_FLAG', (EVF.C("DIFF_GUAR_FLAG").isChecked() ? "1" : "0"));
				EVF.V('ORI_MIN_TECH_SCORE', EVF.V("MIN_TECH_SCORE"));
			}
			if(contType2 == "TD" || contType2 == "TS") {
				EVF.V('ORI_DIFF_GUAR_FLAG', (EVF.C("ONLY_DIFF_GUAR_FLAG").isChecked() ? "1" : "0"));
				EVF.V('ORI_MIN_TECH_SCORE', EVF.V("ONLY_MIN_TECH_SCORE"));
			}

			<%-- 작성일자 <= 공고일자 <= 입찰등록일시(From) <= 입찰등록일시(To) <= 입찰서제출일시(From) <= 입찰서제출일시(To) <= 개찰일시
			     최저가 LP, 2단계 동시 TS, 적격 QE, 협상 NE : 입찰등록일시(To) <= 입찰서제출일시(From), 입찰서제출일시(To) <= 개찰일시 --%>
			if(contType2 == "LP" || contType2 == "TS" || contType2 == "QE" || contType2 == "NE") {
				if(!checkTimeToValue(EVF.C("APP_END_DATE").getValue(), EVF.C("APP_END_TIME").getValue(), EVF.C("APP_END_MIN").getValue(), EVF.C("BID_BEGIN_DATE").getValue(), EVF.C("BID_BEGIN_TIME").getValue(), EVF.C("BID_BEGIN_MIN").getValue())) {
					EVF.C('BID_BEGIN_DATE').setFocus();
					return EVF.alert("${CBDI0011_T041}");
				}
				if(!checkTimeToValue(EVF.C("BID_END_DATE").getValue(), EVF.C("BID_END_TIME").getValue(), EVF.C("BID_END_MIN").getValue(), EVF.C("OPEN_DATE").getValue(), EVF.C("OPEN_TIME").getValue(), EVF.C("OPEN_MIN").getValue())) {
					EVF.C('OPEN_DATE').setFocus();
					return EVF.alert("${CBDI0011_T042}");
				}
			}

			gridI.checkAll(true);

			if (gridI.getSelRowCount() == 0) { return EVF.alert("${CBDI0011_T031}"); }

			if (!gridI.validate().flag) { return EVF.alert(gridI.validate().msg); }

			var calPrAmt = 0;
			var totPrAmt = Number(EVF.V('PR_AMT'));
			var rowIdsI = gridI.getSelRowId();
			for(var i in rowIdsI) {
				if(!EVF.isEmpty(gridI.getCellValue(rowIdsI[i], 'PR_AMT')) || Number(gridI.getCellValue(rowIdsI[i], 'PR_AMT')) > 0) {
					calPrAmt = calPrAmt + Number(gridI.getCellValue(rowIdsI[i], 'PR_AMT'));
				}
			}
			<%-- 최초 PR에서 가져온 금액이 기준이 되며, 그리드에서 단가/수량을 변경하여 예산금액(PR_AMT)과 동일하게 맞춰야 한다. --%>
			if(calPrAmt != totPrAmt) {
				return EVF.alert("${CBDI0011_T036}");
			}

			gridE.checkAll(true);

			var techEvType = EVF.C("TECH_EV_TYPE").getValue();
			if(techEvType == "20") {

				if(EVF.isEmpty(EVF.V("EI_NUM"))) {
					return EVF.alert("${CBDI0011_T038}");
				}

				if (gridE.getSelRowCount() == 0) { return EVF.alert("${CBDI0011_T032}"); }

				if (!gridE.validate().flag) { return EVF.alert(gridE.validate().msg); }

				var rowIdsE = gridE.getSelRowId();
				for(var i in rowIdsE) {

					if(!everString.isValidEmail(gridE.getCellValue(rowIdsE[i], 'EU_EMAIL'))) {
						return EVF.alert(gridE.getCellValue(rowIdsE[i], 'EU_USER_NM') + "의 " + "${msg.EMAIL_INVALID}");
					}

					var CellNum = gridE.getCellValue(rowIdsE[i], 'EU_PHONE_NUM');
					var rgEx = /(01[016789])[-](\d{4}|\d{3})[-]\d{4}$/g;
					var chkFlg = rgEx.test(CellNum);
					if(!chkFlg){
						return EVF.alert(gridE.getCellValue(rowIdsE[i], 'EU_USER_NM') + "의 " + "${msg.CELL_NUM_INVALID}");
					}
				}
			}

			var confirmMsg = (signStatus == "T" ? "${msg.M0021}" : "${msg.M0100}");
			EVF.confirm(confirmMsg, function () {
				if (signStatus === 'T' || signStatus === 'E') {
					goApproval();
				} else if (signStatus === 'P') {

					var param = {
						subject: EVF.V('ANN_ITEM'),
						docType: "BID",
						signStatus: signStatus,
						screenId: "CBDI0011",
						approvalType: 'APPROVAL',
						attFileNum: "",
						docNum: EVF.V('BID_NUM'),
						appDocNum: EVF.V('APP_DOC_NUM'),
						callBackFunction: "goApproval",
						appAmt: eval(EVF.V('PR_AMT'))
					};
					everPopup.openApprovalRequestIPopup(param);
				}
			});
		}

		function goApproval(formData, gridData, attachData) {

			var popupFlag = ${(param.popupFlag == null || !param.popupFlag) ? false : true};

			EVF.C('approvalFormData').setValue(formData);
			EVF.C('approvalGridData').setValue(gridData);
			EVF.C('attachFileDatas').setValue(attachData);

			var store = new EVF.Store();
			store.setGrid([gridI, gridE]);
			store.getGridData(gridI, 'sel');
			store.getGridData(gridE, 'sel');
			store.setParameter("baseDataType", baseDataType);
			store.setParameter("oriBaseDataType", oriBaseDataType);

			store.doFileUpload(function() {
				store.load(baseUrl + 'cbdi0011_doSave.so', function(){

					var buyerCd = this.getParameter("buyerCd");
					var bidNum = this.getParameter("bidNum");
					var bidCnt = this.getParameter("bidCnt");

					EVF.alert(this.getResponseMessage(), function() {
						var param = {
							'buyerCd' : buyerCd,
							'bidNum' : bidNum,
							'bidCnt' : bidCnt,
							'baseDataType': "ModifyBID",
							'popupFlag' : true,
							'detailView' : false
						};
						if(popupFlag) {
							if(oriBaseDataType == "ReBID") {
								opener['${param.callbackFunction}']();
								doClose();
							} else {
								opener.doSearch();
								window.location.href = '/nhepro/CBDI/CBDI0011/view.so?' + $.param(param);
							}
						}
						else { document.location.href = '/nhepro/CBDI/CBDI0011/view.so?' + $.param(param); }
					});
				});
			});
		}

		function doDelete() {

			var popupFlag = ${(param.popupFlag == null || !param.popupFlag) ? false : true};
			var store = new EVF.Store();

			EVF.confirm("${CBDI0011_T043 }", function () {
				EVF.confirm("${msg.M0013 }", function () {
					store.load(baseUrl + 'cbdi0011_doDelete.so', function() {
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
				gridI.setCellValue(copyRowIds[c], 'ITEM_SQ', null);
			}
		}

		function doDelItem() {

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
				EVF.alert(msgStr + "${CBDI0011_T022}");
			}
		}

		function doSearchVendor() {

			var contType = EVF.V('CONT_TYPE1');
			if(!EVF.isEmpty(contType)) {
				<%-- GC : 일반경쟁, LC : 제한경쟁, NC : 지명경쟁, PC : 수의계약 --%>
				<%-- 계약방법(1)이 ”지명경쟁 [NC]"인 경우 “협력업체지정” 필수이며, 2개 이상의 협력업체를 지정해야 함  그 외는 Hidden --%>
				if(contType == "NC") {
					var vendorArray = [];
					var array_data = EVF.V('VENDOR_CDS').split(",");
					for(var k = 0; k < array_data.length; k++) {
						if(!EVF.isEmpty(array_data[k])) {
							var addParam = {"VENDOR_CD" : array_data[k]};
							vendorArray.push(addParam);
						}
					}

					var param = {
						callBackFunction : "setVendorCd",
						candidateJson: (EVF.isEmpty(EVF.V('VENDOR_CDS')) ? [] : JSON.stringify(vendorArray)),
						detailView: (isDetailView == true ? true : false),
						callType: ''
					};
					everPopup.openWindowPopup("/nhepro/CBDI/CBDR0016/view.so", 1200, 700, param, 'openGetVendorPopup');
				}
			}
		}

		function setVendorCd(data) {

			var vendors = JSON.parse(data);

			var vendorCdStr = "";
			var vendorNmStr = " ";
			for(var idx in vendors) {
				vendorCdStr = vendorCdStr + vendors[idx].VENDOR_CD + ",";
				vendorNmStr = vendorNmStr + vendors[idx].VENDOR_NM + ", ";
			}
			vendorCdStr = vendorCdStr.substring(0, vendorCdStr.length-1);
			vendorNmStr = vendorNmStr.substring(0, vendorNmStr.length-2);
			EVF.V("VENDOR_LIST", vendors.length);
			EVF.V("VENDOR_NMS", vendorNmStr);
			EVF.V("VENDOR_CDS", vendorCdStr);
		}

		function getUserId() {

			var callType = this.getData().data;
			var callBackFunction = "";

			if(callType == "B") {
				callBackFunction = "setBidUserId";
			}
			else if(callType == "E") {
				callBackFunction = "setExpectedUserId";
			}
			else if(callType == "O") {
				callBackFunction = "setOpenUserId";
			}
			else if(callType == "T") {
				callBackFunction = "setTechUserId";
			}

			<%-- 기술평가구분이 ”기술평가수행 [20]“ 인 경우, Popup을 오픈할 수 없다. --%>
			var techEvType = EVF.V('TECH_EV_TYPE');
			if(callType == "T" && (techEvType == "10" || techEvType == "20")) {
				var param = {
					'callBackFunction': callBackFunction,
					'READONLY': 'N',		// 팝업 조회조건 변경불가
					'multiYN' : 'N',        // 멀티팝업여부
					'CTRL_CD' : '',			// 구매담당자권한
					'detailView': false
				};
				everPopup.openPopupByScreenId("CCDU0020", 1100, 700, param);
			}
			else if(callType == "E" || callType == "O") {
				var param = {
					'callBackFunction': callBackFunction,
					'READONLY': 'Y',		// 팝업 조회조건 변경불가
					'multiYN' : 'N',        // 멀티팝업여부
					'CTRL_CD' : '',			// 구매담당자권한
					'detailView': false
				};
				everPopup.openPopupByScreenId("CCDU0020", 1100, 700, param);
			}
			else if(callType == "B") {
				var param = {
					'callBackFunction': callBackFunction,
					'READONLY': 'Y',		// 팝업 조회조건 변경불가
					'multiYN' : 'N',        // 멀티팝업여부
					'CTRL_CD' : 'BR030',	// 구매담당자권한
					'detailView': false
				};
				everPopup.openPopupByScreenId("CCDU0020", 1100, 700, param);
			}
		}

		function setBidUserId(data) {
			if(data != null){
				data = JSON.parse(data);
				EVF.V("BID_USER_ID", data.USER_ID);
				EVF.V("BID_USER_NM", data.USER_NM);
			}
		}

		function setExpectedUserId(data) {
			if(data != null){
				data = JSON.parse(data);
				EVF.V("ESTM_USER_ID", data.USER_ID);
				EVF.V("ESTM_USER_NM", data.USER_NM);
			}
		}

		function setOpenUserId(data) {
			if(data != null){
				data = JSON.parse(data);
				EVF.V("OPEN_USER_ID", data.USER_ID);
				EVF.V("OPEN_USER_NM", data.USER_NM);
			}
		}

		function setTechUserId(data) {
			if(data != null){
				data = JSON.parse(data);
				EVF.V("EV_USER_ID", data.USER_ID);
				EVF.V("EV_USER_NM", data.USER_NM);
			}
		}

		function doSearchEvaluator() {

			<%-- 기술평가구분이 ”기술평가수행 [20]“ 인 경우, Popup을 오픈할 수 없다. --%>
			var techEvType = EVF.V('TECH_EV_TYPE');
			if(EVF.isEmpty(techEvType) || techEvType != "20") {
				return EVF.alert("${CBDI0011_T030}");
			}

			if(techEvType == "20") {
				var param = {
					'callBackFunction': "setEvaluator",
					'READONLY': 'Y',		// 팝업 조회조건 변경불가
					'multiYN' : 'Y',        // 멀티팝업여부
					'CTRL_CD' : '',
					'detailView': false
				};
				everPopup.openPopupByScreenId("CCDU0020", 1100, 700, param);
				<%--
				var param = {
					callBackFunction : "setEvaluator",
					custCd : "${ses.companyCd}"
				};
				everPopup.openCommonPopup(param, 'MP0005');
				--%>
			}
		}

		function setEvaluator(data) {
			if(data.length != 0) {
				for(var v in data) {
					if(data.hasOwnProperty(v)){
						if(!EVF.isEmpty(data[v].USER_ID)) {
							var addParam = [{
								"EU_TYPE" : "10"
								,"EU_USER_ID" : data[v].USER_ID
								,"EU_USER_NM" : data[v].USER_NM
								,"EU_EMAIL" : data[v].EMAIL
								,"EU_PHONE_NUM" : data[v].CELL_NUM
								,"BUYER_CD" : data[v].COMPANY_CD
								,"BID_NUM" : ''
								,"BID_CNT" : ''
								,"EU_SQ" : ''
							}];
							var validData = valid.equalPopupValid(JSON.stringify(addParam), gridE, "EU_USER_ID");
							gridE.addRow(validData);
						}
					}
				}
			}
		}

		function setEvaluatorGrid(dataJsonArray) {
			gridE.setCellValue(eventRowIdE, 'EU_USER_ID', dataJsonArray.USER_ID);
			gridE.setCellValue(eventRowIdE, 'EU_USER_NM', dataJsonArray.USER_NM);
			gridE.setCellValue(eventRowIdE, 'EU_EMAIL', dataJsonArray.EMAIL);
			gridE.setCellValue(eventRowIdE, 'EU_PHONE_NUM', dataJsonArray.CELL_NUM);
			gridE.setCellValue(eventRowIdE, 'BUYER_CD', dataJsonArray.COMPANY_CD);
		}

		function itemCdCallback(data) {

			for(var i in data) {
				gridI.setCellValue(eventRowId, 'ITEM_CD', data[i].ITEM_CD);
				gridI.setCellValue(eventRowId, 'ITEM_DESC', data[i].ITEM_DESC);
				gridI.setCellValue(eventRowId, 'ITEM_SPEC', data[i].ITEM_SPEC);
				gridI.setCellValue(eventRowId, 'MAKER_NM', data[i].MAKER_NM);
				gridI.setCellValue(eventRowId, 'MAKER_CD', data[i].MAKER_CD);
				gridI.setCellValue(eventRowId, 'MAKER_ART_NO', data[i].MAKER_PART_NO);
				gridI.setCellValue(eventRowId, 'ORIGIN_CD', data[i].ORIGIN_CD);
				gridI.setCellValue(eventRowId, 'UNIT_CD', data[i].UNIT_CD);
			}
		}

		function makerNmCallback(result) {
			gridI.setCellValue(result.rowIdx, 'MAKER_NM', result.MKBR_NM);
			gridI.setCellValue(result.rowIdx, 'MAKER_CD', result.MKBR_CD);
		}

		function getTemplate() {

			if(EVF.V('TECH_EV_TYPE') != "20") { return EVF.alert("${CBDI0011_T037}"); }

			var param = {
				EI_NUM       : EVF.V('EI_NUM'),
				EV_TPL_NUM   : EVF.V('EV_TPL_NUM'),
                'popupFlag'  : true,
            	'detailView' : ${param.detailView},
				callBackFunction: "setTemplate"
			};
			everPopup.openWindowPopup("/nhepro/CBDI/CBDI0016/view.so", 1200, 800, param, "openTemplatePopup", true);
		}

		function setTemplate(eiNum, evTplNum, evTplCnt) {
			EVF.C("EV_TPL_CNT").setValue(evTplCnt);
			EVF.C("EI_NUM").setValue(eiNum);
			EVF.C("EV_TPL_NUM").setValue(evTplNum);
		}

		function chkContTypeA() {
			var contType = EVF.V('CONT_TYPE1');
			if(!EVF.isEmpty(contType)) {
				<%-- GC : 일반경쟁, LC : 제한경쟁, NC : 지명경쟁, PC : 수의계약 --%>
				<%-- 계약방법(1)이 ”지명경쟁 [NC]"인 경우 “협력업체지정” 필수이며, 2개 이상의 협력업체를 지정해야 함  그 외는 Hidden --%>
				if(contType == "NC") {
					setDisabled(['VENDOR_LIST'], false);
					setRequired(['VENDOR_LIST'], true);

					$("#sp_form1 tr:eq(4)").show();
				} else {
					setDisabled(['VENDOR_LIST'], true);
					setRequired(['VENDOR_LIST'], false);
					setClean(['VENDOR_LIST','VENDOR_NMS','VENDOR_CDS']);

					$("#sp_form1 tr:eq(4)").hide();
				}
			}
		}

		function chkContTypeB() {

			//var btnFlag = (baseDataType == "CreateBID" || baseDataType == "ModifyBID" || baseDataType == "ModBID" || baseDataType == "ReBID") ? "true" : "false";

			<%-- 초기화 --%>
			var componentIdsDefault = [
				'BASIC_AMT', 'CONF_STD_SCORE', 'SB_LIMIT_RATE', 'ONLY_MIN_TECH_SCORE', 'ONLY_DIFF_GUAR_FLAG',
				'TECH_EV_TYPE', 'PRC_SCORE', 'TECH_SCORE', 'MIN_TECH_SCORE', 'MIN_TOT_SCORE',
                'DIFF_GUAR_FLAG', 'FINA_SOLV_FLAG', 'ESTM_LIMIT_RATE', 'RATE_CURR', 'RATE_SDEPT'
			];

			var contType = EVF.V('CONT_TYPE2');
			if(!EVF.isEmpty(contType)) {
				<%-- LP : 최저가, TD : 2단계분리입찰, TS : 2단계동시입찰, QE : 적격심사, NE : 협상에 의한 계약 --%>

				<%-- 계약방법(2)가 ”최저가”인 경우 “재무건전성체크여부”, ”예정가격비율“, “부채/유동비율“ 필수 입력, ”차액보증여부” 선택  그 외는 Hidden --%>
				var componentIdsCase1D = [
					'FINA_SOLV_FLAG', 'ESTM_LIMIT_RATE', 'RATE_CURR', 'RATE_SDEPT', 'DIFF_GUAR_FLAG'
				];
				var componentIdsCase1R = [
					'FINA_SOLV_FLAG', 'ESTM_LIMIT_RATE', 'RATE_CURR', 'RATE_SDEPT'
				];

				if(contType == "LP") {

					<%-- 초기화 --%>
					setDisabled(componentIdsDefault, true);
					setRequired(componentIdsDefault, false);

					if (isDetailView == false) {
						setDisabled(componentIdsCase1D, false);
					}
					setRequired(componentIdsCase1R, true);

					if (btnFlag == true) {
						EVF.C("FINA_SOLV_FLAG").setValue("1");   <%-- default 재무건전성체크여부 : Y --%>
						EVF.C("ESTM_LIMIT_RATE").setValue("80"); <%-- default 예정가격비율 : 80% --%>
						EVF.C('DIFF_GUAR_FLAG').setChecked(true); <%-- default 차액보증여부 : Y --%>

						<%-- EVF.C("RATE_SDEPT").setValue("114.07"); --%>  <%-- default 부채비율 : Y --%>
						<%-- EVF.C("RATE_CURR").setValue("134.03");  --%>  <%-- default 유동비율 : Y --%>
					}
					$("#sp_form1 tr:eq(19)").hide();
				} else {
					if (btnFlag == true) {
                        EVF.C('DIFF_GUAR_FLAG').setChecked(false); <%-- default 차액보증여부 : N --%>
                        setClean(componentIdsCase1D);
                    }
				}

				<%-- 계약방법(2)가 ”협상에 의한 계약”인 경우 “기술/가격/기술적격/종합적격“ 0점이상 필수 입력  그 외는 Hidden
					 기술점수 + 가격점수 = 100, 기술점수 >= 기술적격점수 Check --%>
				var componentIdsCase2 = [
					'PRC_SCORE', 'TECH_SCORE', 'MIN_TECH_SCORE', 'MIN_TOT_SCORE', 'TECH_EV_TYPE',
                    'BID_BEGIN_DATE', 'BID_BEGIN_MIN', 'BID_BEGIN_TIME', 'BID_END_DATE', 'BID_END_MIN',
                    'BID_END_TIME', 'OPEN_DATE', 'OPEN_MIN', 'OPEN_TIME'
				];
				if(contType == "NE") {

					<%-- 초기화 --%>
					setDisabled(componentIdsDefault, true);
					setRequired(componentIdsDefault, false);

					if (isDetailView == false) {
						setDisabled(componentIdsCase2, false);
					}
					setRequired(componentIdsCase2, true);

					if (btnFlag == true) {
						EVF.C("ESTM_OPEN_FLAG").setValue("1"); <%-- default 예산공개여부 : Y --%>
						EVF.C('DIFF_GUAR_FLAG').setChecked(false); <%-- default 차액보증여부 : N --%>
					}
					$("#sp_form1 tr:eq(19)").show();
				} else {
					if (btnFlag == true) {
                        EVF.C("ESTM_OPEN_FLAG").setValue("0"); <%-- default 예산공개여부 : N --%>
                        setClean(componentIdsCase2);
                    }
				}

				<%-- 계약방법(2)가 ”2단계분리/동시입찰”인 경우 “기술적격”점수 필수 입력, “차액보증여부” 선택  그 외는 Hidden --%>
				var componentIdsCase3D = [
					'ONLY_MIN_TECH_SCORE', 'ONLY_DIFF_GUAR_FLAG', 'TECH_EV_TYPE',
                    'BID_BEGIN_DATE', 'BID_BEGIN_MIN', 'BID_BEGIN_TIME', 'BID_END_DATE', 'BID_END_MIN',
                    'BID_END_TIME', 'OPEN_DATE', 'OPEN_MIN', 'OPEN_TIME'
				];
				var componentIdsCase3R = [
					'ONLY_MIN_TECH_SCORE', 'TECH_EV_TYPE',
                    'BID_BEGIN_DATE', 'BID_BEGIN_MIN', 'BID_BEGIN_TIME', 'BID_END_DATE', 'BID_END_MIN',
                    'BID_END_TIME', 'OPEN_DATE', 'OPEN_MIN', 'OPEN_TIME'
				];
				if(contType == "TD" || contType == "TS") {

					<%-- 초기화 --%>
					setDisabled(componentIdsDefault, true);
					setRequired(componentIdsDefault, false);

					if (isDetailView == false) {
						setDisabled(componentIdsCase3D, false);
					}
					setRequired(componentIdsCase3R, true);

					if (btnFlag == true) {
						EVF.C('ONLY_DIFF_GUAR_FLAG').setChecked(true);
					}

					<%-- 계약방법(2)가 ”2단계 분리 입찰”인 경우 “입찰서제출일시“, “개찰일시“ Hidden  그 외는 필수 입력 --%>
                    if(contType == "TD") {
                        var componentIdsCase4 = [
                            'BID_BEGIN_DATE', 'BID_BEGIN_MIN', 'BID_BEGIN_TIME',
                            'BID_END_DATE', 'BID_END_MIN', 'BID_END_TIME',
                            'OPEN_DATE', 'OPEN_MIN', 'OPEN_TIME'
                        ];
                        setDisabled(componentIdsCase4, true);
                        setRequired(componentIdsCase4, false);
                        setClean(componentIdsCase4);
                    }
					$("#sp_form1 tr:eq(19)").hide();
				} else {
					if (btnFlag == true) {
                        EVF.C('ONLY_DIFF_GUAR_FLAG').setChecked(false);
                        setClean(componentIdsCase3D);
                    }
				}

				<%-- 계약방법(2)가 ”적격심사”인 경우 “기초가격“ , “적격심사기준”, “낙찰하한율” 필수 입력  그 외는 Hidden --%>
				var componentIdsCase5 = [
					'BASIC_AMT', 'CONF_STD_SCORE', 'SB_LIMIT_RATE',
                    'BID_BEGIN_DATE', 'BID_BEGIN_MIN', 'BID_BEGIN_TIME', 'BID_END_DATE', 'BID_END_MIN',
                    'BID_END_TIME', 'OPEN_DATE', 'OPEN_MIN', 'OPEN_TIME'
				];
				if(contType == "QE") {

					<%-- 초기화 --%>
					setDisabled(componentIdsDefault, true);
					setRequired(componentIdsDefault, false);

					if (isDetailView == false) {
						setDisabled(componentIdsCase5, false);
					}
					setRequired(componentIdsCase5, true);

					if (btnFlag == true) {
						EVF.C("CONF_STD_SCORE").setValue("85");  <%-- default 적격심사기준 : 85점 --%>
						EVF.C("SB_LIMIT_RATE").setValue("84.5"); <%-- default 낙찰하한율 : 84.5% --%>
						EVF.C("ESTM_OPEN_FLAG").setValue("1"); <%-- default 예산공개여부 : Y --%>
						EVF.C('DIFF_GUAR_FLAG').setChecked(false); <%-- default 차액보증여부 : N --%>
					}
					$("#sp_form1 tr:eq(19)").hide();
				} else {
					if (btnFlag == true) {
                        EVF.C("ESTM_OPEN_FLAG").setValue("0"); <%-- default 예산공개여부 : N --%>
                        setClean(componentIdsCase5);
                    }
				}

				$("#sp_form1 tr:eq(5)").hide();
				$("#sp_form1 tr:eq(6)").hide();
				$("#sp_form1 tr:eq(7)").hide();
				$("#sp_form1 tr:eq(8)").hide();

				if(contType == "LP") {        <%-- LP : 최저가 --%>
					$("#sp_form1 tr:eq(5)").show();
				} else if(contType == "NE") { <%-- NE : 협상에 의한 계약 --%>
					$("#sp_form1 tr:eq(6)").show();
				} else if(contType == "TD" || contType == "TS") { <%-- TD : 2단계분리입찰 , TS : 2단계동시입찰--%>
					$("#sp_form1 tr:eq(7)").show();
				} else if(contType == "QE") { <%-- QE : 적격심사 --%>
					$("#sp_form1 tr:eq(8)").show();
				}

				if(contType == "TD") {        <%-- TD : 2단계분리입찰 --%>
					$("#sp_form1 tr:eq(11)").hide();
					$("#sp_form1 tr:eq(12)").hide();
				} else {
					$("#sp_form1 tr:eq(11)").show();
					$("#sp_form1 tr:eq(12)").show();
				}
			}

			btnFlag = true;
		}

		function chkContTypeC() {

			<%-- TA : 총액, UP : 단가 --%>
			<%-- 계약방법(3)이 “총액＂인 경우 “TCO 여부“ visible & TCO 여부가 “Y”인 경우 “TCO 년수”는 필수 입력, 그외 (단가)인 경우 Hidden --%>
			var contType = EVF.V('CONT_TYPE3');
			if(!EVF.isEmpty(contType)) {
				if (contType == "TA") {
					if (isDetailView == false) {
						setDisabled(['TCO_FLAG'], false);
					}
					setRequired(['TCO_FLAG'], true);
				} else {
					setDisabled(['TCO_FLAG', 'TCO_YEAR_CNT'], true);
					setRequired(['TCO_FLAG', 'TCO_YEAR_CNT'], false);
					setClean(['TCO_FLAG', 'TCO_YEAR_CNT']);
				}
			}
		}

		function chkAnnoOpenFlag() {

			var componentIdsD = [
				'ANNO_FLAG', 'ANNO_DATE', 'ANNO_MIN_FROM', 'ANNO_TIME_FROM', 'ANNO_MIN_TO',
				'ANNO_TIME_TO', 'ANNO_PLACE', 'ANNO_NOTIFIER', 'ANNO_RESP', 'ANNO_RMK'
			];
			var componentIdsR = [
				'ANNO_FLAG', 'ANNO_DATE', 'ANNO_MIN_FROM', 'ANNO_TIME_FROM', 'ANNO_MIN_TO',
				'ANNO_TIME_TO', 'ANNO_PLACE', 'ANNO_NOTIFIER', 'ANNO_RESP'
			];

			var annoOpenFlag = EVF.V('ANNO_OPEN_FLAG');
			if(!EVF.isEmpty(annoOpenFlag)) {
				if (annoOpenFlag == "1") {
					if (isDetailView == false) {
						setDisabled(componentIdsD, false);
					}
					setRequired(componentIdsR, true);

					$("#sp_form2 tr:eq(1)").show();
					$("#sp_form2 tr:eq(2)").show();
					$("#sp_form2 tr:eq(3)").show();
					$("#sp_form2 tr:eq(4)").show();
				} else {
					setDisabled(componentIdsD, true);
					setRequired(componentIdsR, false);
					setClean(componentIdsD);

					$("#sp_form2 tr:eq(1)").hide();
					$("#sp_form2 tr:eq(2)").hide();
					$("#sp_form2 tr:eq(3)").hide();
					$("#sp_form2 tr:eq(4)").hide();
				}
			}
		}

		function chkPropOpenFlag() {

			var componentIdsD = [
				'PROP_FLAG', 'PROP_DATE', 'PROP_MIN_FROM', 'PROP_TIME_FROM', 'PROP_MIN_TO',
				'PROP_TIME_TO', 'PROP_PLACE', 'PROP_NOTIFIER', 'PROP_RESP', 'PROP_RMK'
			];
			var componentIdsR = [
				'PROP_FLAG', 'PROP_DATE', 'PROP_MIN_FROM', 'PROP_TIME_FROM', 'PROP_MIN_TO',
				'PROP_TIME_TO', 'PROP_PLACE', 'PROP_NOTIFIER', 'PROP_RESP'
			];

			var propOpenFlag = EVF.V('PROP_OPEN_FLAG');
			if(!EVF.isEmpty(propOpenFlag)) {
				if (propOpenFlag == "1") {
					if (isDetailView == false) {
						setDisabled(componentIdsD, false);
					}
					setRequired(componentIdsR, true);

					$("#sp_form3 tr:eq(1)").show();
					$("#sp_form3 tr:eq(2)").show();
					$("#sp_form3 tr:eq(3)").show();
					$("#sp_form3 tr:eq(4)").show();
				} else {
					setDisabled(componentIdsD, true);
					setRequired(componentIdsR, false);
					setClean(componentIdsD);

					$("#sp_form3 tr:eq(1)").hide();
					$("#sp_form3 tr:eq(2)").hide();
					$("#sp_form3 tr:eq(3)").hide();
					$("#sp_form3 tr:eq(4)").hide();
				}
			}
		}

		function chkTcoFlag() {
			<%-- TCO 여부가 “Y”인 경우 “TCO 년수”는 필수 입력 --%>
			var tcoFlag = EVF.V('TCO_FLAG');
			if(!EVF.isEmpty(tcoFlag)) {
				if (tcoFlag == "1") {
					setDisabled(['TCO_YEAR_CNT'], false);
					setRequired(['TCO_YEAR_CNT'], true);
				} else {
					setDisabled(['TCO_YEAR_CNT'], true);
					setRequired(['TCO_YEAR_CNT'], false);
					setClean(['TCO_YEAR_CNT']);
				}
			}
		}

		function chkTechEvType() {

			<%-- 10 : 평가결과등록, 20 : 기술평가수행 --%>
			<%-- ”평가결과등록“ : 기술평가담당자 visible true  & 기술평가자지정 visible false  기술평가담당자 Default : 입찰담당자
				 ”기술평가수행“ : 기술평가담당자 visible fasle & 기술평가자지정 visible true --%>
			var contType = EVF.V('CONT_TYPE2');
			var techEvType = EVF.V('TECH_EV_TYPE');
            //if(!EVF.isEmpty(techEvType) && contType == "NE") {
			if(!EVF.isEmpty(techEvType) && (contType == "TD" || contType == "TS" || contType == "NE")) {
				if (techEvType == "10") {
					setDisabled(['EV_USER_ID','EV_USER_NM'], false);
					var userId = EVF.V('EV_USER_ID');
					if( EVF.isEmpty(userId) ) {
						EVF.V('EV_USER_ID', '${ses.userId}');
						EVF.V('EV_USER_NM', '${ses.userNm}');
					}
					EVF.C('SearchEvaluator').setDisabled(true);

					$("#sp_form1 tr:eq(19)").hide();
				}
				else {
					setDisabled(['EV_USER_ID','EV_USER_NM'], false);
					// PR기준 입찰서 작성(최초 신규등록)
					var userId = EVF.V('EV_USER_ID');
					if( btnFlag == true && EVF.isEmpty(userId) ) {
						EVF.V('EV_USER_ID', '${ses.userId}');
						EVF.V('EV_USER_NM', '${ses.userNm}');
					}
					EVF.C('SearchEvaluator').setDisabled(false);

					$("#sp_form1 tr:eq(19)").show();
				}
			}
		}

		function setDisabled(componentIds, flag) {
			for (var d = 0; d < componentIds.length; d++) {
				EVF.C(componentIds[d]).setDisabled(flag);
			}
		}

		function setRequired(componentIds, flag) {
			for (var d = 0; d < componentIds.length; d++) {
				EVF.C(componentIds[d]).setRequired(flag);
			}
		}

		function setClean(componentIds) {
			for (var d = 0; d < componentIds.length; d++) {
				EVF.V(componentIds[d], '');
			}
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
				if (validCloseDate < validStartDate) {
					return false;
				}
			}
			return true;
		}

		function openAnnPage() {
			if(!EVF.isEmpty(EVF.V("BID_NUM")) && baseDataType != "ModBID") {
				var param = {
					'buyerCd' : '${formData.BUYER_CD}',
					'bidNum' :  '${formData.BID_NUM}' ,
					'bidCnt' :  '${formData.BID_CNT}' ,
					'baseDataType': "ViewBID",
					'popupFlag' : true,
					'detailView' : true
				};
				everPopup.openWindowPopup("/nhepro/CBDI/CBDR0012/view.so", 1200, 800, param, "regBidNotice2", true);
			}
		}

		function doClose() {
			EVF.closeWindow();
		}

	</script>

	<e:window id="CBDI0011" initData="${initData}" onReady="init" title="${screenName }" breadCrumbs="${breadCrumb }">

		<%-- 입찰공고 정보 --%>
		<div class="e-component e-title-container" data-uuid="Title-541-391-560">
			<div class="e-title-bullet-h1"></div>
			<div class="e-title-text">${CBDI0011_CAPTION1 }</div>
		</div>
		<e:searchPanel id="form1" labelWidth="${longLabelWidth}" width="100%" columnCount="2" useTitleBar="false">

			<e:inputHidden id="BUYER_CD" name="BUYER_CD" value="${formData.BUYER_CD}" />
			<e:inputHidden id="DEPT_CD" name="DEPT_CD" value="${formData.DEPT_CD}" />
			<e:inputHidden id="BID_NUM" name="BID_NUM" value="${formData.BID_NUM}" />
			<e:inputHidden id="BID_CNT" name="BID_CNT" value="${formData.BID_CNT}" />
			<e:inputHidden id="VOTE_CNT" name="VOTE_CNT" value="${formData.VOTE_CNT}" />
			<e:inputHidden id="ORI_BID_CNT" name="ORI_BID_CNT" value="${formData.ORI_BID_CNT}" />
			<e:inputHidden id='APP_DOC_NUM' name="APP_DOC_NUM" value="${empty param.appDocNum ? formData.APP_DOC_NUM : param.appDocNum}" />
			<e:inputHidden id='APP_DOC_CNT' name="APP_DOC_CNT" value="${formData.APP_DOC_CNT}" />
			<e:inputHidden id="SIGN_STATUS" name="SIGN_STATUS" value="${formData.SIGN_STATUS}" />
			<e:inputHidden id="OLD_SIGN_STATUS" name="OLD_SIGN_STATUS" value="${formData.SIGN_STATUS}" />
			<e:inputHidden id="BID_STATUS" name="BID_STATUS" value="${formData.BID_STATUS}" />
			<e:inputHidden id="ORI_DIFF_GUAR_FLAG" name="ORI_DIFF_GUAR_FLAG" value="${formData.DIFF_GUAR_FLAG}" />
			<e:inputHidden id="ORI_MIN_TECH_SCORE" name="ORI_MIN_TECH_SCORE" value="${formData.MIN_TECH_SCORE}" />
			<e:inputHidden id="approvalFormData" name="approvalFormData" />
			<e:inputHidden id="approvalGridData" name="approvalGridData" />
			<e:inputHidden id="attachFileDatas" name="attachFileDatas" />
			
			<!-- 이전 입찰정보 -->
			<e:inputHidden id="PRE_BID_NUM"  name="PRE_BID_NUM"  value="${formData.PRE_BID_NUM}" />
			<e:inputHidden id="PRE_BID_CNT"  name="PRE_BID_CNT"  value="${formData.PRE_BID_CNT}" />
			<e:inputHidden id="PRE_VOTE_CNT" name="PRE_VOTE_CNT" value="${formData.PRE_VOTE_CNT}" />
			
			<e:inputHidden id="SINGLE_FLAG" name="SINGLE_FLAG" value="${param.singleFlag}" />
			<e:inputHidden id="SEL_BUYER_CD" name="SEL_BUYER_CD" value="${param.preBuyerCd}" />
			<e:inputHidden id="SEL_BID_NUM" name="SEL_BID_NUM" value="${param.preBidNum}" />
			<e:inputHidden id="SEL_BID_CNT" name="SEL_BID_CNT" value="${param.preBidCnt}" />
			<e:inputHidden id="SEL_VOTE_CNT" name="SEL_VOTE_CNT" value="${param.preVoteCnt}" />
			<e:inputHidden id="SEL_CONT_TYPE" name="SEL_CONT_TYPE" value="${param.preContType}" />
			
			<e:row>
				<e:label for="ANN_NO" title="${form_ANN_NO_N}"/>
				<e:field>
					<e:inputText id="ANN_NO" name="ANN_NO" value="${formData.ANN_NO }" style="${formData.ORI_BID_NUM == null ? '' : 'font-weight:bold; cursor:pointer; color:blue;'}" onClick="${formData.BID_NUM == null ? '' : 'openAnnPage'}" width="${form_ANN_NO_W}" maxLength="${form_ANN_NO_M}" disabled="${form_ANN_NO_D}" readOnly="${form_ANN_NO_RO}" required="${form_ANN_NO_R}" />
				</e:field>
				<e:label for="ANN_DATE" title="${form_ANN_DATE_N}" />
				<e:field>
					<e:inputDate id="ANN_DATE" name="ANN_DATE" value="${formData.ANN_DATE }" width="${inputDateWidth }" required="${form_ANN_DATE_R}" disabled="${form_ANN_DATE_D}" readOnly="${form_ANN_DATE_RO}" datePicker="true" />
				</e:field>
			</e:row>
			<e:row>
				<e:label for="ANN_ITEM" title="${form_ANN_ITEM_N}"/>
				<e:field colSpan="3">
					<e:inputText id="ANN_ITEM" name="ANN_ITEM" value="${formData.ANN_ITEM }" width="${form_ANN_ITEM_W}" maxLength="${form_ANN_ITEM_M}" disabled="${form_ANN_ITEM_D}" readOnly="${form_ANN_ITEM_RO}" required="${form_ANN_ITEM_R}" />
				</e:field>
			</e:row>
			<e:row>
				<e:label for="CONT_TYPE1" title="${form_CONT_TYPE1_N}" />
				<e:field>
					<e:select id="CONT_TYPE1" name="CONT_TYPE1" value="${formData.CONT_TYPE1 }" options="${contType1Options }" width="120px" disabled="${form_CONT_TYPE1_D}" readOnly="${form_CONT_TYPE1_RO}" required="${form_CONT_TYPE1_R}" placeHolder="" onChange="chkContTypeA" /><e:text>&nbsp;</e:text>
					<e:select id="CONT_TYPE2" name="CONT_TYPE2" value="${formData.CONT_TYPE2 }" options="${contType2Options }" width="160px" disabled="${form_CONT_TYPE2_D}" readOnly="${form_CONT_TYPE2_RO}" required="${form_CONT_TYPE2_R}" placeHolder="" onChange="chkContTypeB" /><e:text>&nbsp;</e:text>
					<e:select id="CONT_TYPE3" name="CONT_TYPE3" value="${formData.CONT_TYPE3 }" options="${contType3Options }" width="110px" disabled="${form_CONT_TYPE3_D}" readOnly="${form_CONT_TYPE3_RO}" required="${form_CONT_TYPE3_R}" placeHolder="" onChange="chkContTypeC" />
				</e:field>
				<e:label for="TCO_FLAG" title="${form_TCO_FLAG_N}" />
				<e:field>
					<e:select id="TCO_FLAG" name="TCO_FLAG" value="${formData.TCO_FLAG }" options="${tcoFlagOptions }" width="90px" disabled="${form_TCO_FLAG_D}" readOnly="${form_TCO_FLAG_RO}" required="${form_TCO_FLAG_R}" placeHolder="" onChange="chkTcoFlag" />
					<e:text id="txt1">&nbsp;${CBDI0011_T001 }</e:text>
					<e:inputNumber id="TCO_YEAR_CNT" name="TCO_YEAR_CNT" value='${formData.TCO_YEAR_CNT }' align='right' width='40px' required='${form_TCO_YEAR_CNT_R }' readOnly='${form_TCO_YEAR_CNT_RO }' disabled='${form_TCO_YEAR_CNT_D }' visible='${form_TCO_YEAR_CNT_V }' decimalPlace="0" />
				</e:field>
			</e:row>
			<e:row>
				<e:label for="CUR" title="${form_CUR_N}" />
				<e:field>
					<e:inputNumber id="PR_AMT" name="PR_AMT" value='${formData.PR_AMT }' align='right' width='320px' required='${form_PR_AMT_R }' readOnly='${form_PR_AMT_RO }' disabled='${form_PR_AMT_D }' visible='${form_PR_AMT_V }' decimalPlace="0" onNumberKr="${form_PR_AMT_KR}" /><e:text>&nbsp;</e:text>
					<e:select id="CUR" name="CUR" value="${formData.CUR }" options="${curOptions }" width="50px" disabled="${form_CUR_D}" readOnly="${form_CUR_RO}" required="${form_CUR_R}" placeHolder="" />
					<e:select id="VAT_TYPE" name="VAT_TYPE" value="${formData.VAT_TYPE }" options="${vatTypeOptions }" width="80px" style="text-align: center;" disabled="${form_VAT_TYPE_D}" readOnly="${form_VAT_TYPE_RO}" required="${form_VAT_TYPE_R}" placeHolder="" />
				</e:field>
				<e:label for="ESTM_OPEN_FLAG" title="${form_ESTM_OPEN_FLAG_N}"/>
				<e:field>
					<e:select id="ESTM_OPEN_FLAG" name="ESTM_OPEN_FLAG" value="${formData.ESTM_OPEN_FLAG }" options="${estmOpenFlagOptions }" width="90px" style="text-align: center;" disabled="${form_ESTM_OPEN_FLAG_D}" readOnly="${form_ESTM_OPEN_FLAG_RO}" required="${form_ESTM_OPEN_FLAG_R}" placeHolder="" />
				</e:field>
			</e:row>
			<e:row>
				<e:label for="VENDOR_LIST" title="${form_VENDOR_LIST_N}"/>
				<e:field colSpan="3">
					<e:search id="VENDOR_LIST" name="VENDOR_LIST" value="${formData.VENDOR_LIST }" width="60px;" maxLength="${form_VENDOR_LIST_M}" onIconClick="${(!param.detailView || param.detailView == null) ? 'doSearchVendor' : 'everCommon.blank'}" disabled="${form_VENDOR_LIST_D}" readOnly="${form_VENDOR_LIST_RO}" required="${form_VENDOR_LIST_R}" />
					<e:text id="VENDOR_NMS" name="VENDOR_NMS" >${formData.VENDOR_NMS }</e:text>
					<e:inputHidden id="VENDOR_CDS" name="VENDOR_CDS" value="${formData.VENDOR_CDS}" />
				</e:field>
			</e:row>
			<e:row>
				<e:label for="FINA_SOLV_FLAG" title="${form_FINA_SOLV_FLAG_N}"/>
				<e:field>
					<e:select id="FINA_SOLV_FLAG" name="FINA_SOLV_FLAG" value="${formData.FINA_SOLV_FLAG }" options="${finaSolvFlagOptions }" width="90px" style="text-align: center;" disabled="${form_FINA_SOLV_FLAG_D}" readOnly="${form_FINA_SOLV_FLAG_RO}" required="${form_FINA_SOLV_FLAG_R}" placeHolder="" />
					<e:text id="txt2">&nbsp;${CBDI0011_T016 }</e:text>
					<e:inputNumber id="ESTM_LIMIT_RATE" name="ESTM_LIMIT_RATE" value='${formData.ESTM_LIMIT_RATE }' align='right' width='40px' required='${form_ESTM_LIMIT_RATE_R }' readOnly='${form_ESTM_LIMIT_RATE_RO }' disabled='${form_ESTM_LIMIT_RATE_D }' visible='${form_ESTM_LIMIT_RATE_V }' decimalPlace="0" /><e:text>%</e:text>
				</e:field>
				<e:label for="RATE_SDEPT" title="${form_RATE_SDEPT_N}" />
				<e:field>
					<e:text id="txt3">${CBDI0011_T003 }</e:text>
					<e:inputNumber id="RATE_SDEPT" name="RATE_SDEPT" value='${formData.RATE_SDEPT }' align='right' width='60px' required='${form_RATE_SDEPT_R }' readOnly='${form_RATE_SDEPT_RO }' disabled='${form_RATE_SDEPT_D }' visible='${form_RATE_SDEPT_V }' decimalPlace="2" /><e:text>%</e:text>
					<e:text id="txt4">${CBDI0011_T004 }</e:text>
					<e:inputNumber id="RATE_CURR" name="RATE_CURR" value='${formData.RATE_CURR }' align='right' width='60px' required='${form_RATE_CURR_R }' readOnly='${form_RATE_CURR_RO }' disabled='${form_RATE_CURR_D }' visible='${form_RATE_CURR_V }' decimalPlace="2" /><e:text>%</e:text>
					<e:check id='DIFF_GUAR_FLAG' name="DIFF_GUAR_FLAG" value="1" checked="${formData.DIFF_GUAR_FLAG eq '1' ? 'true' : 'false'}" width='${inputTextWidth }' required='${form_DIFF_GUAR_FLAG_R }' disabled='${form_DIFF_GUAR_FLAG_D }' visible='${form_DIFF_GUAR_FLAG_V }' />
					<e:text id="txt5" style="position: relative; left: -3px; padding: 0;">${CBDI0011_T005 }</e:text>
				</e:field>
			</e:row>
			<e:row>
				<e:label for="TECH_SCORE"  title="${form_TECH_SCORE_N}" />
				<e:field colSpan="3">
					<e:text id="txt6">${CBDI0011_T006 }</e:text>
					<e:inputNumber id="TECH_SCORE" name="TECH_SCORE" value='${formData.TECH_SCORE }' align='right' width='40px' required='${form_TECH_SCORE_R }' readOnly='${form_TECH_SCORE_RO }' disabled='${form_TECH_SCORE_D }' visible='${form_TECH_SCORE_V }' decimalPlace="0" />
					<e:text id="txt7">${CBDI0011_T007 }</e:text>
					<e:inputNumber id="PRC_SCORE" name="PRC_SCORE" value='${formData.PRC_SCORE }' align='right' width='40px' required='${form_PRC_SCORE_R }' readOnly='${form_PRC_SCORE_RO }' disabled='${form_PRC_SCORE_D }' visible='${form_PRC_SCORE_V }' decimalPlace="0" />
					<e:text id="txt8">${CBDI0011_T008 }</e:text>
					<e:inputNumber id="MIN_TECH_SCORE" name="MIN_TECH_SCORE" value='${formData.MIN_TECH_SCORE }' align='right' width='40px' required='${form_MIN_TECH_SCORE_R }' readOnly='${form_MIN_TECH_SCORE_RO }' disabled='${form_MIN_TECH_SCORE_D }' visible='${form_MIN_TECH_SCORE_V }' decimalPlace="0" />
					<e:text id="txt9">${CBDI0011_T009 }</e:text>
					<e:inputNumber id="MIN_TOT_SCORE" name="MIN_TOT_SCORE" value='${formData.MIN_TOT_SCORE }' align='right' width='40px' required='${form_MIN_TOT_SCORE_R }' readOnly='${form_MIN_TOT_SCORE_RO }' disabled='${form_MIN_TOT_SCORE_D }' visible='${form_MIN_TOT_SCORE_V }' decimalPlace="0" />
					<e:text>점</e:text>
				</e:field>
			</e:row>
			<e:row>
				<e:label for="ONLY_MIN_TECH_SCORE" title="${form_ONLY_MIN_TECH_SCORE_N}" />
				<e:field colSpan="3">
					<e:text id="txt10">${CBDI0011_T017 }</e:text>
					<e:inputNumber id="ONLY_MIN_TECH_SCORE" name="ONLY_MIN_TECH_SCORE" value='${formData.ONLY_MIN_TECH_SCORE }' align='right' width='40px' required='${form_ONLY_MIN_TECH_SCORE_R }' readOnly='${form_ONLY_MIN_TECH_SCORE_RO }' disabled='${form_ONLY_MIN_TECH_SCORE_D }' visible='${form_ONLY_MIN_TECH_SCORE_V }' decimalPlace="0" />
					<e:text>점</e:text>
					<e:check id='ONLY_DIFF_GUAR_FLAG' name="ONLY_DIFF_GUAR_FLAG" value="1" checked="${formData.ONLY_DIFF_GUAR_FLAG eq '1' ? 'true' : 'false'}" width='${inputTextWidth }' required='${form_ONLY_DIFF_GUAR_FLAG_R }' disabled='${form_ONLY_DIFF_GUAR_FLAG_D }' visible='${form_ONLY_DIFF_GUAR_FLAG_V }' />
					<e:text id="txt11">${CBDI0011_T005 }</e:text>
				</e:field>
			</e:row>
			<e:row>
				<e:label for="BASIC_AMT" title="${form_BASIC_AMT_N}" />
				<e:field colSpan="3">
					<e:inputNumber id="BASIC_AMT" name="BASIC_AMT" value='${formData.BASIC_AMT }' align='right' width='260px' required='${form_BASIC_AMT_R }' readOnly='${form_BASIC_AMT_RO }' disabled='${form_BASIC_AMT_D }' visible='${form_BASIC_AMT_V }' decimalPlace="0" onNumberKr="${form_BASIC_AMT_KR}" /><e:text>&nbsp;</e:text>
					<e:select id="BASIC_CUR" name="BASIC_CUR" value="${formData.CUR }" options="${basicCurOptions }" width="50px" disabled="${form_BASIC_CUR_D}" readOnly="${form_BASIC_CUR_RO}" required="${form_BASIC_CUR_R}" placeHolder="" />
					<e:select id="BASIC_VAT_TYPE" name="BASIC_VAT_TYPE" value="${formData.VAT_TYPE }" options="${basicVatTypeOptions }" width="80px" disabled="${form_BASIC_VAT_TYPE_D}" readOnly="${form_BASIC_VAT_TYPE_RO}" required="${form_BASIC_VAT_TYPE_R}" placeHolder="" />
					<e:text id="txt12" style="position: relative; left: 0px; padding: 0;">${CBDI0011_T010 }</e:text>
					<e:inputNumber id="CONF_STD_SCORE" name="CONF_STD_SCORE" value='${formData.CONF_STD_SCORE }' align='right' width='40px' required='${form_CONF_STD_SCORE_R }' readOnly='${form_CONF_STD_SCORE_RO }' disabled='${form_CONF_STD_SCORE_D }' visible='${form_CONF_STD_SCORE_V }' decimalPlace="0" />
					<e:text id="txt13">${CBDI0011_T011 }</e:text>
					<e:inputNumber id="SB_LIMIT_RATE" name="SB_LIMIT_RATE" value='${formData.SB_LIMIT_RATE }' align='right' width='50px' required='${form_SB_LIMIT_RATE_R }' readOnly='${form_SB_LIMIT_RATE_RO }' disabled='${form_SB_LIMIT_RATE_D }' visible='${form_SB_LIMIT_RATE_V }' decimalPlace="3" />
					<e:text>%</e:text>
				</e:field>
			</e:row>
			<e:row>
				<e:label for="CONT_TERM" title="${form_CONT_TERM_N}"/>
				<e:field>
					<e:inputText id="CONT_TERM" name="CONT_TERM" value="${formData.CONT_TERM }" width="${form_CONT_TERM_W}" maxLength="${form_CONT_TERM_M}" disabled="${form_CONT_TERM_D}" readOnly="${form_CONT_TERM_RO}" required="${form_CONT_TERM_R}" />
				</e:field>
				<e:label for="VOTE_LIMIT_CNT" title="${form_VOTE_LIMIT_CNT_N}"/>
				<e:field>
					<e:inputNumber id="VOTE_LIMIT_CNT" name="VOTE_LIMIT_CNT" value='${formData.VOTE_LIMIT_CNT }' align='right' width='40px' required='${form_VOTE_LIMIT_CNT_R }' readOnly='${form_VOTE_LIMIT_CNT_RO }' disabled='${form_VOTE_LIMIT_CNT_D }' visible='${form_VOTE_LIMIT_CNT_V }' decimalPlace="0" />
				</e:field>
			</e:row>
			<e:row>
				<e:label for="APP_BEGIN_DATE" title="${form_APP_BEGIN_DATE_N}" />
				<e:field colSpan="3">
					<e:inputDate id="APP_BEGIN_DATE" name="APP_BEGIN_DATE" value="${formData.APP_BEGIN_DATE }" width="${inputDateWidth }" required="${form_APP_BEGIN_DATE_R}" disabled="${form_APP_BEGIN_DATE_D}" readOnly="${form_APP_BEGIN_DATE_RO}" datePicker="true" /><e:text>&nbsp;일&nbsp;</e:text>
					<e:select id="APP_BEGIN_TIME" name="APP_BEGIN_TIME" value="${formData.APP_BEGIN_TIME }" options="${appBeginTimeOptions }" width="${form_APP_BEGIN_TIME_W }" disabled="${form_APP_BEGIN_TIME_D}" readOnly="${form_APP_BEGIN_TIME_RO}" required="${form_APP_BEGIN_TIME_R}" placeHolder="" usePlaceHolder="false" /><e:text>&nbsp;시&nbsp;</e:text>
					<e:select id="APP_BEGIN_MIN" name="APP_BEGIN_MIN" value="${formData.APP_BEGIN_MIN }" options="${appBeginMinOptions }" width="${form_APP_BEGIN_MIN_W }" disabled="${form_APP_BEGIN_MIN_D}" readOnly="${form_APP_BEGIN_MIN_RO}" required="${form_APP_BEGIN_MIN_R}" placeHolder="" usePlaceHolder="false" /><e:text>&nbsp;분 ~ </e:text>
					<e:inputDate id="APP_END_DATE" name="APP_END_DATE" value="${formData.APP_END_DATE }" width="${inputDateWidth }" required="${form_APP_END_DATE_R}" disabled="${form_APP_END_DATE_D}" readOnly="${form_APP_END_DATE_RO}" datePicker="true" /><e:text>&nbsp;일&nbsp;</e:text>
					<e:select id="APP_END_TIME" name="APP_END_TIME" value="${formData.APP_END_TIME }" options="${appEndTimeOptions }" width="${form_APP_END_TIME_W }" disabled="${form_APP_END_TIME_D}" readOnly="${form_APP_END_TIME_RO}" required="${form_APP_END_TIME_R}" placeHolder="" usePlaceHolder="false" /><e:text>&nbsp;시&nbsp;</e:text>
					<e:select id="APP_END_MIN" name="APP_END_MIN" value="${formData.APP_END_MIN }" options="${appEndMinOptions }" width="${form_APP_END_MIN_W }" disabled="${form_APP_END_MIN_D}" readOnly="${form_APP_END_MIN_RO}" required="${form_APP_END_MIN_R}" placeHolder="" usePlaceHolder="false" /><e:text>&nbsp;분</e:text>
				</e:field>
			</e:row>
			<e:row>
				<e:label for="BID_BEGIN_DATE" title="${form_BID_BEGIN_DATE_N}" />
				<e:field colSpan="3">
					<e:inputDate id="BID_BEGIN_DATE" name="BID_BEGIN_DATE" value="${formData.BID_BEGIN_DATE }" width="${inputDateWidth }" required="${form_BID_BEGIN_DATE_R}" disabled="${form_BID_BEGIN_DATE_D}" readOnly="${form_BID_BEGIN_DATE_RO}" datePicker="true" /><e:text>&nbsp;일&nbsp;</e:text>
					<e:select id="BID_BEGIN_TIME" name="BID_BEGIN_TIME" value="${formData.BID_BEGIN_TIME }" options="${bidBeginTimeOptions }" width="${form_BID_BEGIN_TIME_W }" disabled="${form_BID_BEGIN_TIME_D}" readOnly="${form_BID_BEGIN_TIME_RO}" required="${form_BID_BEGIN_TIME_R}" placeHolder="" usePlaceHolder="false" /><e:text>&nbsp;시&nbsp;</e:text>
					<e:select id="BID_BEGIN_MIN" name="BID_BEGIN_MIN" value="${formData.BID_BEGIN_MIN }" options="${bidBeginMinOptions }" width="${form_BID_BEGIN_MIN_W }" disabled="${form_BID_BEGIN_MIN_D}" readOnly="${form_BID_BEGIN_MIN_RO}" required="${form_BID_BEGIN_MIN_R}" placeHolder="" usePlaceHolder="false" /><e:text>&nbsp;분 ~ </e:text>
					<e:inputDate id="BID_END_DATE" name="BID_END_DATE" value="${formData.BID_END_DATE }" width="${inputDateWidth }" required="${form_BID_END_DATE_R}" disabled="${form_BID_END_DATE_D}" readOnly="${form_BID_END_DATE_RO}" datePicker="true" /><e:text>&nbsp;일&nbsp;</e:text>
					<e:select id="BID_END_TIME" name="BID_END_TIME" value="${formData.BID_END_TIME }" options="${bidEndTimeOptions }" width="${form_BID_END_TIME_W }" disabled="${form_BID_END_TIME_D}" readOnly="${form_BID_END_TIME_RO}" required="${form_BID_END_TIME_R}" placeHolder="" usePlaceHolder="false" /><e:text>&nbsp;시&nbsp;</e:text>
					<e:select id="BID_END_MIN" name="BID_END_MIN" value="${formData.BID_END_MIN }" options="${bidEndMinOptions }" width="${form_BID_END_MIN_W }" disabled="${form_BID_END_MIN_D}" readOnly="${form_BID_END_MIN_RO}" required="${form_BID_END_MIN_R}" placeHolder="" usePlaceHolder="false" /><e:text>&nbsp;분</e:text>
				</e:field>
			</e:row>
			<e:row>
				<e:label for="OPEN_DATE" title="${form_OPEN_DATE_N}" />
				<e:field colSpan="3">
					<e:inputDate id="OPEN_DATE" name="OPEN_DATE" value="${formData.OPEN_DATE }" width="${inputDateWidth }" required="${form_OPEN_DATE_R}" disabled="${form_OPEN_DATE_D}" readOnly="${form_OPEN_DATE_RO}" datePicker="true" /><e:text>&nbsp;일&nbsp;</e:text>
					<e:select id="OPEN_TIME" name="OPEN_TIME" value="${formData.OPEN_TIME }" options="${openTimeOptions }" width="${form_OPEN_TIME_W }" disabled="${form_OPEN_TIME_D}" readOnly="${form_OPEN_TIME_RO}" required="${form_OPEN_TIME_R}" placeHolder="" usePlaceHolder="false" /><e:text>&nbsp;시&nbsp;</e:text>
					<e:select id="OPEN_MIN" name="OPEN_MIN" value="${formData.OPEN_MIN }" options="${openMinOptions }" width="${form_OPEN_MIN_W }" disabled="${form_OPEN_MIN_D}" readOnly="${form_OPEN_MIN_RO}" required="${form_OPEN_MIN_R}" placeHolder="" usePlaceHolder="false" /><e:text>&nbsp;분</e:text>
				</e:field>
			</e:row>
			<e:row>
				<e:label for="APP_PLACE" title="${form_APP_PLACE_N}"/>
				<e:field>
					<e:inputText id="APP_PLACE" name="APP_PLACE" value="${formData.APP_PLACE }" width="${form_APP_PLACE_W}" maxLength="${form_APP_PLACE_M}" disabled="${form_APP_PLACE_D}" readOnly="${form_APP_PLACE_RO}" required="${form_APP_PLACE_R}" />
				</e:field>
				<e:label for="ESTM_TYPE" title="${form_ESTM_TYPE_N}" />
				<e:field>
					<e:select id="ESTM_TYPE" name="ESTM_TYPE" value="${formData.ESTM_TYPE }" options="${estmTypeOptions }" width="${form_ESTM_TYPE_W}" disabled="${form_ESTM_TYPE_D}" readOnly="${form_ESTM_TYPE_RO}" required="${form_ESTM_TYPE_R}" placeHolder="" />
				</e:field>
			</e:row>
			<e:row>
				<e:label for="LIMIT_CRIT" title="${form_LIMIT_CRIT_N}"/>
				<e:field colSpan="3">
					<e:textArea id="LIMIT_CRIT" name="LIMIT_CRIT" value="${formData.LIMIT_CRIT}" height="100px" width="${form_LIMIT_CRIT_W}" maxLength="${form_LIMIT_CRIT_M}" disabled="${form_LIMIT_CRIT_D}" readOnly="${form_LIMIT_CRIT_RO}" required="${form_LIMIT_CRIT_R}" />
				</e:field>
			</e:row>
			<e:row>
				<e:label for="PROM_CRIT" title="${form_PROM_CRIT_N}"/>
				<e:field colSpan="3">
					<e:inputText id="PROM_CRIT" name="PROM_CRIT" value="${formData.PROM_CRIT }" width="${form_PROM_CRIT_W}" maxLength="${form_PROM_CRIT_M}" disabled="${form_PROM_CRIT_D}" readOnly="${form_PROM_CRIT_RO}" required="${form_PROM_CRIT_R}" />
				</e:field>
			</e:row>
			<e:row>
				<e:label for="BID_USER_ID" title="${form_BID_USER_ID_N}"/>
				<e:field>
					<e:search id="BID_USER_ID" name="BID_USER_ID" value="${formData.BID_USER_ID }" width="40%" maxLength="${form_BID_USER_ID_M}" onIconClick="${(!param.detailView || param.detailView == null) ? 'getUserId' : 'everCommon.blank'}" disabled="${form_BID_USER_ID_D}" readOnly="${form_BID_USER_ID_RO}" required="${form_BID_USER_ID_R}" data="B" />
					<e:inputText id="BID_USER_NM" name="BID_USER_NM" value="${formData.BID_USER_NM }" width="60%" maxLength="${form_BID_USER_NM_M}" disabled="${form_BID_USER_NM_D}" readOnly="${form_BID_USER_NM_RO}" required="${form_BID_USER_NM_R}" />
				</e:field>
				<e:label for="ESTM_USER_ID" title="${form_ESTM_USER_ID_N}"/>
				<e:field>
					<e:search id="ESTM_USER_ID" name="ESTM_USER_ID" value="${formData.ESTM_USER_ID }" width="40%" maxLength="${form_ESTM_USER_ID_M}" onIconClick="${(!param.detailView || param.detailView == null) ? 'getUserId' : 'everCommon.blank'}" disabled="${form_ESTM_USER_ID_D}" readOnly="${form_ESTM_USER_ID_RO}" required="${form_ESTM_USER_ID_R}" data="E" />
					<e:inputText id="ESTM_USER_NM" name="ESTM_USER_NM" value="${formData.ESTM_USER_NM }" width="60%" maxLength="${form_ESTM_USER_NM_M}" disabled="${form_ESTM_USER_NM_D}" readOnly="${form_ESTM_USER_NM_RO}" required="${form_ESTM_USER_NM_R}" />
				</e:field>
			</e:row>
			<e:row>
				<e:label for="OPEN_USER_ID" title="${form_OPEN_USER_ID_N}"/>
				<e:field>
					<e:search id="OPEN_USER_ID" name="OPEN_USER_ID" value="${formData.OPEN_USER_ID }" width="40%" maxLength="${form_OPEN_USER_ID_M}" onIconClick="${(!param.detailView || param.detailView == null) ? 'getUserId' : 'everCommon.blank'}" disabled="${form_OPEN_USER_ID_D}" readOnly="${form_OPEN_USER_ID_RO}" required="${form_OPEN_USER_ID_R}" data="O" />
					<e:inputText id="OPEN_USER_NM" name="OPEN_USER_NM" value="${formData.OPEN_USER_NM }" width="60%" maxLength="${form_OPEN_USER_NM_M}" disabled="${form_OPEN_USER_NM_D}" readOnly="${form_OPEN_USER_NM_RO}" required="${form_OPEN_USER_NM_R}" />
				</e:field>
				<e:label for="" title=""/>
				<e:field> </e:field>
			</e:row>
			<e:row>
				<e:label for="TECH_EV_TYPE" title="${form_TECH_EV_TYPE_N}"/>
				<e:field colSpan="3">
					<e:select id="TECH_EV_TYPE" name="TECH_EV_TYPE" value="${formData.TECH_EV_TYPE }" options="${techEvTypeOptions }" width="120px" disabled="${form_TECH_EV_TYPE_D}" readOnly="${form_TECH_EV_TYPE_RO}" required="${form_TECH_EV_TYPE_R}" placeHolder="" onChange="chkTechEvType" />
					<e:text id="txt14">&nbsp;${CBDI0011_T013 }</e:text>
					<e:search id="EV_USER_ID" name="EV_USER_ID" value="${formData.EV_USER_ID }" width="120px" maxLength="${form_EV_USER_ID_M}" onIconClick="${(!param.detailView || param.detailView == null) ? 'getUserId' : 'everCommon.blank'}" disabled="${form_EV_USER_ID_D}" readOnly="${form_EV_USER_ID_RO}" required="${form_EV_USER_ID_R}" data="T" />
					<e:inputText id="EV_USER_NM" name="EV_USER_NM" value="${formData.EV_USER_NM }" width="140px" maxLength="${form_EV_USER_NM_M}" disabled="${form_EV_USER_NM_D}" readOnly="${form_EV_USER_NM_RO}" required="${form_EV_USER_NM_R}" />
					<e:text id="txt15">${CBDI0011_T014 }</e:text>
					<%--
					<e:search id="EV_TPL_CNT" name="EV_TPL_CNT" value="${formData.EV_TPL_CNT }" width="60px" align="right" maxLength="${form_EV_TPL_CNT_M}" onIconClick="${(!param.detailView || param.detailView == null) ? 'getTemplate' : 'everCommon.blank'}" disabled="${form_EV_TPL_CNT_D}" readOnly="${form_EV_TPL_CNT_RO}" required="${form_EV_TPL_CNT_R}" data="O" />
					 --%>
					<e:search id="EV_TPL_CNT" name="EV_TPL_CNT" value="${formData.EV_TPL_CNT }" width="60px" align="right" maxLength="${form_EV_TPL_CNT_M}" onIconClick="getTemplate" disabled="${form_EV_TPL_CNT_D}" readOnly="${form_EV_TPL_CNT_RO}" required="${form_EV_TPL_CNT_R}" data="O" />
					<e:inputHidden id="EV_TPL_NUM" name="EV_TPL_NUM" value="${formData.EV_TPL_NUM}" />
					<e:inputHidden id="EI_NUM" name="EI_NUM" value="${formData.EI_NUM}" />
				</e:field>
			</e:row>
			<e:row>
				<e:label for="" title="${CBDI0011_T015}"/>
				<e:field colSpan="3">

					<e:buttonBar id="evalBtnBar" align="right" width="100%" title="${form_CAPTION_N }">
						<e:button id="SearchEvaluator" name="SearchEvaluator" label="${SearchEvaluator_N }" disabled="${SearchEvaluator_D }" visible="${SearchEvaluator_V}" onClick="doSearchEvaluator" />
					</e:buttonBar>

					<e:gridPanel id="gridE" name="gridE" width="100%" height="161px" gridType="${_gridType}" readOnly="${param.detailView}" />

				</e:field>
			</e:row>
			<e:row>
				<e:label for="APP_ETC" title="${form_APP_ETC_N }" />
				<e:field colSpan="3">
					<e:richTextEditor id="APP_ETC" name="APP_ETC" width="100%" height="250px" value="${formData.APP_ETC }" required="${form_APP_ETC_R }" readOnly="${form_APP_ETC_RO }" disabled="${form_APP_ETC_D }" useToolbar="${!param.detailView}" />
					<e:inputHidden id="APP_ETC_NUM" name="APP_ETC_NUM" value="${formData.APP_ETC_NUM }" />
				</e:field>
			</e:row>
			<e:row>
				<e:label for="ATT_FILE_NUM" title="${form_ATT_FILE_NUM_N}"/>
				<e:field colSpan="3">
					<e:fileManager id="ATT_FILE_NUM" height="200" width="100%" fileId="${formData.ATT_FILE_NUM}" readOnly="${form_ATT_FILE_NUM_RO}" bizType="BID" required="${form_ATT_FILE_NUM_R}"/>
				</e:field>
			</e:row>
		</e:searchPanel>

		<%-- 사업설명회 정보 --%>
		<div class="e-component e-title-container" data-uuid="Title-541-391-560">
			<div class="e-title-bullet-h1"></div>
			<div class="e-title-text">${CBDI0011_CAPTION2 }</div>
		</div>
		<e:searchPanel id="form2" labelWidth="${longLabelWidth}" width="100%" columnCount="2" useTitleBar="false">
			<e:row>
				<e:label for="ANNO_OPEN_FLAG" title="${form_ANNO_OPEN_FLAG_N}"/>
				<e:field>
					<e:select id="ANNO_OPEN_FLAG" name="ANNO_OPEN_FLAG" value="${formData.ANNO_OPEN_FLAG }" options="${annoOpenFlagOptions }" width="${form_ANNO_OPEN_FLAG_W}" disabled="${form_ANNO_OPEN_FLAG_D}" readOnly="${form_ANNO_OPEN_FLAG_RO}" required="${form_ANNO_OPEN_FLAG_R}" placeHolder="" onChange="chkAnnoOpenFlag" />
				</e:field>
				<e:label for="ANNO_FLAG" title="${form_ANNO_FLAG_N}"/>
				<e:field>
					<e:select id="ANNO_FLAG" name="ANNO_FLAG" value="${formData.ANNO_FLAG }" options="${annoFlagOptions }" width="${form_ANNO_FLAG_W}" disabled="${form_ANNO_FLAG_D}" readOnly="${form_ANNO_FLAG_RO}" required="${form_ANNO_FLAG_R}" placeHolder="" />
				</e:field>
			</e:row>
			<e:row>
				<e:label for="ANNO_DATE" title="${form_ANNO_DATE_N}" />
				<e:field>
					<e:inputDate id="ANNO_DATE" name="ANNO_DATE" value="${formData.ANNO_DATE }" width="${inputDateWidth }" required="${form_ANNO_DATE_R}" disabled="${form_ANNO_DATE_D}" readOnly="${form_ANNO_DATE_RO}" datePicker="true" />
				</e:field>
				<e:label for="ANNO_TIME_FROM" title="${form_ANNO_TIME_FROM_N}" />
				<e:field>
					<e:select id="ANNO_TIME_FROM" name="ANNO_TIME_FROM" value="${formData.ANNO_TIME_FROM }" options="${annoTimeFromOptions }" width="${form_ANNO_TIME_FROM_W }" disabled="${form_ANNO_TIME_FROM_D}" readOnly="${form_ANNO_TIME_FROM_RO}" required="${form_ANNO_TIME_FROM_R}" placeHolder="" usePlaceHolder="false" /><e:text>&nbsp;시&nbsp;</e:text>
					<e:select id="ANNO_MIN_FROM" name="ANNO_MIN_FROM" value="${formData.ANNO_MIN_FROM }" options="${annoMinFromOptions }" width="${form_ANNO_MIN_FROM_W }" disabled="${form_ANNO_MIN_FROM_D}" readOnly="${form_ANNO_MIN_FROM_RO}" required="${form_ANNO_MIN_FROM_R}" placeHolder="" usePlaceHolder="false" /><e:text>&nbsp;분 ~ </e:text>
					<e:select id="ANNO_TIME_TO" name="ANNO_TIME_TO" value="${formData.ANNO_TIME_TO }" options="${annoTimeToOptions }" width="${form_ANNO_TIME_TO_W }" disabled="${form_ANNO_TIME_TO_D}" readOnly="${form_ANNO_TIME_TO_RO}" required="${form_ANNO_TIME_TO_R}" placeHolder="" usePlaceHolder="false" /><e:text>&nbsp;시&nbsp;</e:text>
					<e:select id="ANNO_MIN_TO" name="ANNO_MIN_TO" value="${formData.ANNO_MIN_TO }" options="${annoMinToOptions }" width="${form_ANNO_MIN_TO_W }" disabled="${form_ANNO_MIN_TO_D}" readOnly="${form_ANNO_MIN_TO_RO}" required="${form_ANNO_MIN_TO_R}" placeHolder="" usePlaceHolder="false" /><e:text>&nbsp;분</e:text>
				</e:field>
			</e:row>
			<e:row>
				<e:label for="ANNO_PLACE" title="${form_ANNO_PLACE_N}"/>
				<e:field colSpan="3">
					<e:inputText id="ANNO_PLACE" name="ANNO_PLACE" value="${formData.ANNO_PLACE }" width="${form_ANNO_PLACE_W}" maxLength="${form_ANNO_PLACE_M}" disabled="${form_ANNO_PLACE_D}" readOnly="${form_ANNO_PLACE_RO}" required="${form_ANNO_PLACE_R}" />
				</e:field>
			</e:row>
			<e:row>
				<e:label for="ANNO_NOTIFIER" title="${form_ANNO_NOTIFIER_N}"/>
				<e:field>
					<e:inputText id="ANNO_NOTIFIER" name="ANNO_NOTIFIER" value="${formData.ANNO_NOTIFIER }" width="${form_ANNO_NOTIFIER_W}" maxLength="${form_ANNO_NOTIFIER_M}" disabled="${form_ANNO_NOTIFIER_D}" readOnly="${form_ANNO_NOTIFIER_RO}" required="${form_ANNO_NOTIFIER_R}" />
				</e:field>
				<e:label for="ANNO_RESP" title="${form_ANNO_RESP_N}"/>
				<e:field>
					<e:inputText id="ANNO_RESP" name="ANNO_RESP" value="${formData.ANNO_RESP }" width="${form_ANNO_RESP_W}" maxLength="${form_ANNO_RESP_M}" disabled="${form_ANNO_RESP_D}" readOnly="${form_ANNO_RESP_RO}" required="${form_ANNO_RESP_R}" />
				</e:field>
			</e:row>
			<e:row>
				<e:label for="ANNO_RMK" title="${form_ANNO_RMK_N}"/>
				<e:field colSpan="3">
					<e:textArea id="ANNO_RMK" name="ANNO_RMK" value="${formData.ANNO_RMK}" height="100px" width="${form_ANNO_RMK_W}" maxLength="${form_ANNO_RMK_M}" disabled="${form_ANNO_RMK_D}" readOnly="${form_ANNO_RMK_RO}" required="${form_ANNO_RMK_R}" />
				</e:field>
			</e:row>
		</e:searchPanel>

		<%-- 제안발표회 정보 --%>
		<div class="e-component e-title-container" data-uuid="Title-541-391-560">
			<div class="e-title-bullet-h1"></div>
			<div class="e-title-text">${CBDI0011_CAPTION3 }</div>
		</div>
		<e:searchPanel id="form3" labelWidth="${longLabelWidth}" width="100%" columnCount="2" useTitleBar="false">
			<e:row>
				<e:label for="PROP_OPEN_FLAG" title="${form_PROP_OPEN_FLAG_N}"/>
				<e:field>
					<e:select id="PROP_OPEN_FLAG" name="PROP_OPEN_FLAG" value="${formData.PROP_OPEN_FLAG }" options="${propOpenFlagOptions }" width="${form_PROP_OPEN_FLAG_W}" disabled="${form_PROP_OPEN_FLAG_D}" readOnly="${form_PROP_OPEN_FLAG_RO}" required="${form_PROP_OPEN_FLAG_R}" placeHolder="" onChange="chkPropOpenFlag" />
				</e:field>
				<e:label for="PROP_FLAG" title="${form_PROP_FLAG_N}"/>
				<e:field>
					<e:select id="PROP_FLAG" name="PROP_FLAG" value="${formData.PROP_FLAG }" options="${propFlagOptions }" width="${form_PROP_FLAG_W}" disabled="${form_PROP_FLAG_D}" readOnly="${form_PROP_FLAG_RO}" required="${form_PROP_FLAG_R}" placeHolder="" />
				</e:field>
			</e:row>
			<e:row>
				<e:label for="PROP_DATE" title="${form_PROP_DATE_N}" />
				<e:field>
					<e:inputDate id="PROP_DATE" name="PROP_DATE" value="${formData.PROP_DATE }" width="${inputDateWidth }" required="${form_PROP_DATE_R}" disabled="${form_PROP_DATE_D}" readOnly="${form_PROP_DATE_RO}" datePicker="true" />
				</e:field>
				<e:label for="PROP_TIME_FROM" title="${form_PROP_TIME_FROM_N}" />
				<e:field>
					<e:select id="PROP_TIME_FROM" name="PROP_TIME_FROM" value="${formData.PROP_TIME_FROM }" options="${propTimeFromOptions }" width="${form_PROP_TIME_FROM_W }" disabled="${form_PROP_TIME_FROM_D}" readOnly="${form_PROP_TIME_FROM_RO}" required="${form_PROP_TIME_FROM_R}" placeHolder="" usePlaceHolder="false" /><e:text>&nbsp;시&nbsp;</e:text>
					<e:select id="PROP_MIN_FROM" name="PROP_MIN_FROM" value="${formData.PROP_MIN_FROM }" options="${propMinFromOptions }" width="${form_PROP_MIN_FROM_W }" disabled="${form_PROP_MIN_FROM_D}" readOnly="${form_PROP_MIN_FROM_RO}" required="${form_PROP_MIN_FROM_R}" placeHolder="" usePlaceHolder="false" /><e:text>&nbsp;분 ~ </e:text>
					<e:select id="PROP_TIME_TO" name="PROP_TIME_TO" value="${formData.PROP_TIME_TO }" options="${propTimeToOptions }" width="${form_PROP_TIME_TO_W }" disabled="${form_PROP_TIME_TO_D}" readOnly="${form_PROP_TIME_TO_RO}" required="${form_PROP_TIME_TO_R}" placeHolder="" usePlaceHolder="false" /><e:text>&nbsp;시&nbsp;</e:text>
					<e:select id="PROP_MIN_TO" name="PROP_MIN_TO" value="${formData.PROP_MIN_TO }" options="${propMinToOptions }" width="${form_PROP_MIN_TO_W }" disabled="${form_PROP_MIN_TO_D}" readOnly="${form_PROP_MIN_TO_RO}" required="${form_PROP_MIN_TO_R}" placeHolder="" usePlaceHolder="false" /><e:text>&nbsp;분</e:text>
				</e:field>
			</e:row>
			<e:row>
				<e:label for="PROP_PLACE" title="${form_PROP_PLACE_N}"/>
				<e:field colSpan="3">
					<e:inputText id="PROP_PLACE" name="PROP_PLACE" value="${formData.PROP_PLACE }" width="${form_PROP_PLACE_W}" maxLength="${form_PROP_PLACE_M}" disabled="${form_PROP_PLACE_D}" readOnly="${form_PROP_PLACE_RO}" required="${form_PROP_PLACE_R}" />
				</e:field>
			</e:row>
			<e:row>
				<e:label for="PROP_NOTIFIER" title="${form_PROP_NOTIFIER_N}"/>
				<e:field>
					<e:inputText id="PROP_NOTIFIER" name="PROP_NOTIFIER" value="${formData.PROP_NOTIFIER }" width="${form_PROP_NOTIFIER_W}" maxLength="${form_PROP_NOTIFIER_M}" disabled="${form_PROP_NOTIFIER_D}" readOnly="${form_PROP_NOTIFIER_RO}" required="${form_PROP_NOTIFIER_R}" />
				</e:field>
				<e:label for="PROP_RESP" title="${form_PROP_RESP_N}"/>
				<e:field>
					<e:inputText id="PROP_RESP" name="PROP_RESP" value="${formData.PROP_RESP }" width="${form_PROP_RESP_W}" maxLength="${form_PROP_RESP_M}" disabled="${form_PROP_RESP_D}" readOnly="${form_PROP_RESP_RO}" required="${form_PROP_RESP_R}" />
				</e:field>
			</e:row>
			<e:row>
				<e:label for="PROP_RMK" title="${form_PROP_RMK_N}"/>
				<e:field colSpan="3">
					<e:textArea id="PROP_RMK" name="PROP_RMK" value="${formData.PROP_RMK}" height="100px" width="${form_PROP_RMK_W}" maxLength="${form_PROP_RMK_M}" disabled="${form_PROP_RMK_D}" readOnly="${form_PROP_RMK_RO}" required="${form_PROP_RMK_R}" />
				</e:field>
			</e:row>
		</e:searchPanel>

		<%-- 품목 정보 --%>
		<e:buttonBar id="itemBtnBar" align="right" width="100%" title="${CBDI0011_CAPTION4 }">
			<e:button id="CopyItem" name="CopyItem" label="${CopyItem_N }" disabled="${CopyItem_D }" visible="${CopyItem_V}" onClick="doCopyItem" />
			<e:button id="DelItem" name="DelItem" label="${DelItem_N }" disabled="${DelItem_D }" visible="${DelItem_V}" onClick="doDelItem" />
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