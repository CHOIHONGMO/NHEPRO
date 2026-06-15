<%@ page import="com.st_ones.everf.serverside.config.PropertiesManager" %>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="com.st_ones.everf.serverside.config.PropertiesManager" %>
<%@ include file="/WEB-INF/views/common/ozUrlInfo.jsp" %>

<%
	String ksfcUrl = PropertiesManager.getString("eversrm.ksfc.url");
	String ozSchedulerIp = PropertiesManager.getString("oz.scheduler.ip");
	String ozSchedulerPort = PropertiesManager.getString("oz.scheduler.port");
	response.addHeader("Access-Control-Allow-Origin", "*");
%>

<c:set var="ozExportUrl" value="<%=ozExportUrl%>" />
<c:set var="ozUrl" value="<%=ozUrl%>" />
<c:set var="ozServer" value="<%=ozServer%>" />
<c:set var="ozSchedulerIp" value="<%=ozSchedulerIp%>" />
<c:set var="ozSchedulerPort" value="<%=ozSchedulerPort%>" />
<c:set var="ksfcUrl" value="<%=ksfcUrl%>" />

<%-- 계약서를 수정할 수 있는 상태변수(저장 전, 임시저장(4200), 협력사서명반려(4220), 품의중(4206)(결재반려:R,상신취소:C)) --%>
<c:set var="editableStatus" value="${empty form.PROGRESS_CD or form.PROGRESS_CD eq '4200' or form.PROGRESS_CD eq '4220'
                                       or (form.PROGRESS_CD eq '4206' and form.SIGN_STATUS eq 'R')
                                       or (form.PROGRESS_CD eq '4206' and form.SIGN_STATUS eq 'C')}" 
/>

<%-- 수정가능상태에 따라 그리드 높이를 조절하기 위한 변수 --%>
<c:set var="formSelGridHeight"  value="${(!param.detailView and editableStatus) ? '160' : '100'}" />
<c:set var="formSelPanelHeight" value="${(!param.detailView and editableStatus) ? '220' : '160'}" />

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
	<script type="text/javascript" src="/MagicLine4Web/ML4Web/js/ext/jquery.blockUI.js"></script>
	<script type="text/javascript" src="/MagicLine4Web/ML4Web/js/ext/ML_Config.js"></script>
	<script type="text/javascript">

		var gridM; // 계약서식
		var gridA; // 부서식(추가서식)
		var gridECCM; // 고객사
		var gridECMT; // 품목정보
		var gridECPY;
		var gridECPC_HD;
		var gridECPC;
		var editor;
		var detailView  = "${param.detailView}" == "true";
		var payTypeFlag = true;
		var ecmtFlag    = true;

		var baseUrl  = "/nhepro/CCTR/SCMS0010";
		var userType = '${ses.userType}';   <%-- --%>
		var formNumUpdateState = false;     <%-- 이 값이 true면 서식을 확인해야 저장 등을 할 수 있다. --%>
		var shouldConfirmSubFormNum = {};   <%-- 이 값에 담긴 부서식 객체가 true면 부서식을 확인해야 저장 등을 할 수 있다. --%>
		var localServerFlag  = "${localServerFlag}";

		// CKEDITOR.disableAutoInline = true;  // 인라인에디터를 자동으로 초기화하는 것을 방지(원하는 영역만 수동으로 에디터를 로드하기 위해)
		$(document).ready(function () {
			$("#BASIC_SEARCH, #ADD_SEARCH").keypress(function (e) {
				if (e.keyCode == 13) {
					if (e.target.id == 'BASIC_SEARCH') {
						doBasicSearch();
					} else if (e.target.id == 'ADD_SEARCH') {
						doAddSearch();
					}
				}
			});
		});
		
		function init() {
			
			gridM = EVF.C("gridM");
			gridA = EVF.C("gridA");
			gridECCM = EVF.C("gridECCM");

			gridM.setProperty('singleSelect', true);
			gridM.setProperty('shrinkToFit', true);
			gridA.setProperty('shrinkToFit', true);
			gridECCM.setProperty('shrinkToFit', true);

			gridECMT = EVF.C("gridECMT");		// 품목정보
			gridECMT.setProperty("shrinkToFit", ${shrinkToFit});
			gridECMT.setProperty("rowNumbers", ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
			gridECMT.setProperty("sortable", ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
			gridECMT.setProperty("panelVisible", ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
			gridECMT.setProperty("enterToNextRow", ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
			gridECMT.setProperty("acceptZero", ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
			gridECMT.setProperty("multiSelect", true);					// [선택] 컬럼의 사용여부를 지정한다. [true/false]
			gridECMT.setProperty("singleSelect", ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]

			gridECPY = EVF.C("gridECPY");   	// 지불정보
			gridECPY.setProperty("shrinkToFit", ${shrinkToFit});
			gridECPY.setProperty("rowNumbers", ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
			gridECPY.setProperty("sortable", ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
			gridECPY.setProperty("panelVisible", ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
			gridECPY.setProperty("enterToNextRow", ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
			gridECPY.setProperty("acceptZero", ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
			gridECPY.setProperty("multiSelect", false);					// [선택] 컬럼의 사용여부를 지정한다. [true/false]
			gridECPY.setProperty("singleSelect", ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]

			gridECPC_HD = EVF.C("gridECPC_HD");	// 계약보증 정보
			gridECPC_HD.setProperty("shrinkToFit", ${shrinkToFit});
			gridECPC_HD.setProperty("rowNumbers", ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
			gridECPC_HD.setProperty("sortable", ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
			gridECPC_HD.setProperty("panelVisible", ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
			gridECPC_HD.setProperty("enterToNextRow", ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
			gridECPC_HD.setProperty("acceptZero", ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
			gridECPC_HD.setProperty("multiSelect", true);					// [선택] 컬럼의 사용여부를 지정한다. [true/false]
			gridECPC_HD.setProperty("singleSelect", ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]

			gridECPC = EVF.C("gridECPC");   	// 고객사별 지불고객사 정보
			gridECPC.setProperty("shrinkToFit", ${shrinkToFit});
			gridECPC.setProperty("rowNumbers", ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
			gridECPC.setProperty("sortable", ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
			gridECPC.setProperty("panelVisible", ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
			gridECPC.setProperty("enterToNextRow", ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
			gridECPC.setProperty("acceptZero", ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
			gridECPC.setProperty("multiSelect", ${param.detailView == true ? false : multiSelect});	// [선택] 컬럼의 사용여부를 지정한다. [true/false]
			gridECPC.setProperty("singleSelect", ${singleSelect});

			// 부서식(추가서식)은 전체선택이 없음
			gridA._gvo.setCheckBar({showAll: false});

			gridM.cellClickEvent(function (rowIdx, colId, value) {

				if (colId == "FORM_NM") {
					var param = {
							bizType: "EC",
							BUYER_CD: "${ses.companyCd}",
							CONT_NUM: "${form.CONT_NUM}",
							CONT_CNT: "${form.CONT_CNT}",
							ozrName: gridM.getCellValue(rowIdx, "FORM_FILE_NM"),
							SUB_FORM_FILE_NM: "",
							exportFormat: "ozr"
					};
					SetOZParamters_OZViewer(param)
				}

				if( ${not param.detailView eq 'true'} ){
					var formNum = gridM.getCellValue(rowIdx, 'FORM_NUM');
					if( formNum != EVF.V("bf_main_form_num") ){
						gridM.checkRow(rowIdx, true, true, false);
						formNumUpdateState = true;
						setForm(rowIdx); 		// 주서식 선택
						doSearchSubForms(); 	// 부서식 선택
						setButtons();
					}
				}
			});

			gridA.cellClickEvent(function (rowIdx, colId, value, iRow, iCol) {
				
				if (colId === "multiSelect") {
					<c:if test="${param.detailView or !editableStatus}">
					var existsFlag = gridA.getCellValue(rowIdx, 'EXISTS_FLAG');
					if( existsFlag === '1' ){
						gridA.checkRow(rowIdx, true);
					} else {
						gridA.checkRow(rowIdx, false);
					}
					</c:if>
				}

				if (colId === "REL_FORM_NM") {
					var param = {
						"BUYER_CD": "${ses.companyCd}",
						"CONT_NUM": "${form.CONT_NUM}",
						"CONT_CNT": "${form.CONT_CNT}",
						"ozrName": gridA.getCellValue(rowIdx, "FORM_FILE_NM"),
						"SUB_FORM_FILE_NM": null,
						"exportFormat": "ozr"
					};
					SetOZParamters_OZViewer(param)
				}
			});

			<c:if test="${!param.detailView and editableStatus}">
				gridECCM.addRowEvent(function() {
					ecmtFlag = false;

					if (EVF.V("VENDOR_CD") == "") {
						formUtil.animate("VENDOR_NM", "form");
						return EVF.alert("협력업체를 선택하여 주시기 바랍니다.");
					}

					if (EVF.V("AMT_TYPE") == "") {
						formUtil.animateFor(["AMT_TYPE"], "form");
						return EVF.alert("금액구분을 선택하여 주시기 바랍니다.");
					}

					var amt_type = EVF.V("AMT_TYPE");
					var param = {
						VENDOR_CD: EVF.V("VENDOR_CD"),
						PO_CREATE_FLAG: amt_type == "TA" ? "1" : "0"
					};

					/**
					 * 2020.12.04 : 중앙회 요청으로 제거
					 * 기존 : 금액구분 총액인 경우 자동 발주생성 => 발주생성 안할수도 있음으로 수정 가능하도록 변경
					 * readonly=true => false로 변경
					 */
					var rowIdx = gridECCM.addRow(param);
					for(var i in rowIdx) {
						if(amt_type == "TA") {
							gridECCM.setCellReadOnly(rowIdx[i], "PO_CREATE_FLAG", false);
						}
					}

					var param = {
            				'callBackFunction': 'callBackBuyerDept',
            				'READONLY': 'N',	//팝업 조회조건 변경불가
            				'multiYN': 'N',		//멀티팝업여부
            				'rowIdx': rowIdx,
            				'detailView': false
            		};
            		everPopup.openPopupByScreenId("CCDU0010", 1000, 700, param);
				});
				
				//2021.11.25 계약정보 고객사 그리드의 선택한 고객사만 삭제되도록 수정
				gridECCM.delRowEvent(function() {
					var delItemCount = 0;
					for (var i = gridECCM.getRowCount() - 1; i >= 0; i--) {
						if( gridECCM.isChecked(i) ) {
							var eccmPrBuyerCd = gridECCM.getCellValue(i, "PR_BUYER_CD");
							var eccmPrDeptCd  = gridECCM.getCellValue(i, "PR_DEPT_CD");
							for (var j = gridECMT.getRowCount() - 1; j >= 0; j--) {
								var ecmtPrBuyerCd = gridECMT.getCellValue(j, "PR_BUYER_CD");
								var ecmtPrDeptCd  = gridECMT.getCellValue(j, "PR_DEPT_CD");
								if( eccmPrBuyerCd == ecmtPrBuyerCd && eccmPrDeptCd == ecmtPrDeptCd ) {
									delItemCount++;
								}
							}
						}
					}
					
					if( delItemCount > 0 ) {
						EVF.confirm("고객사를 삭제할 경우 고객사와 연결된 품목도 함께 삭제됩니다.", function() {
							for (var i = gridECCM.getRowCount() - 1; i >= 0; i--) {
								if( gridECCM.isChecked(i) ) {
									var eccmPrBuyerCd = gridECCM.getCellValue(i, "PR_BUYER_CD");
									var eccmPrDeptCd  = gridECCM.getCellValue(i, "PR_DEPT_CD");
									for (var j = gridECMT.getRowCount() - 1; j >= 0; j--) {
										var ecmtPrBuyerCd = gridECMT.getCellValue(j, "PR_BUYER_CD");
										var ecmtPrDeptCd  = gridECMT.getCellValue(j, "PR_DEPT_CD");
										if( eccmPrBuyerCd == ecmtPrBuyerCd && eccmPrDeptCd == ecmtPrDeptCd ) {
											delItemCount++;
											gridECMT.delRow(j);
										}
									}
									gridECCM.delRow(i);
								}
							}
	                    });
					} else {
						for (var i = gridECCM.getRowCount() - 1; i >= 0; i--) {
							if( gridECCM.isChecked(i) ) {
								gridECCM.delRow(i);
							}
						}
					}
					
					if(gridECCM.getRowCount() > 0) {
						gridECCM.checkRow(0, true);
					}
					
					contAmtSum();
				});
			</c:if>

			gridECCM.cellClickEvent(function (rowIdx, colIdx, value, iRow, iCol) {
				
				// 2021.12.17 품목정보의 고객사별 계약정보 추가시 rowIdx = -1인 경우 제외
				if ( rowIdx < 0 ) return;
				
				var param;
				var oldIdx = "";
				// 하나만 선택하기 위해 제어
				if(colIdx == "multiSelect") {
					var selRowIdx = gridECCM.getSelRowId();
					for(var i in selRowIdx) {
						if(selRowIdx[i] != rowIdx) {
							oldIdx = selRowIdx[i];
						}
					}
				} else {
					oldIdx = gridECCM.getSelRowId()[0];
				}
				
				gridECCM.checkAll(false);
				gridECCM.checkRow(rowIdx, true, false, false);
				rowIdx = gridECCM.getSelRowId()[0];
				
				if(gridECPY.getRowCount() > 0) {
					ECPY_COPY(oldIdx);
				}
				
				gridECPC_HD.delAllRow();
				gridECPY.delAllRow();
				gridECPC.delAllRow();

				var PC_HD_INFO = gridECCM.getCellValue(rowIdx, "PC_HD_INFO");
				if( PC_HD_INFO != "" ) {
					//21.01.19 realgrid update시 배열 data addRow시 오류로 인해 for문 사용으로 변경
					//gridECPC_HD.addRow(JSON.parse(PC_HD_INFO));
					var EcpcHdInfo = JSON.parse(PC_HD_INFO);
					for(var j in EcpcHdInfo) {
						gridECPC_HD.addRow(EcpcHdInfo[j]);
				    }
					// 2021.12.17 : IT포탈 변경계약서 작성시 "대금지불정보, 지불정보, 고객사별 지불고객사 정보"의 협력사를 "견적/입찰" 선정 협력사로 변경
					if(gridECPC_HD.getRowCount() > 0) {
						var curVendorCd = "";
						if( "${form.copyFlag}" == "true" && EVF.V("CONT_REQ_CD") == '20' ) {
							curVendorCd = EVF.V("VENDOR_CD");
						}
						if( !EVF.isEmpty(curVendorCd) ) {
							var idx = gridECPC_HD.getAllRowId();
							for(var i in idx) {
								gridECPC_HD.setCellValue(idx[i], "VENDOR_CD", curVendorCd);
							}
						}
					}
				}

				var PY_INFO = gridECCM.getCellValue(rowIdx, "PY_INFO");
				if( PY_INFO != "" ) {
					//21.01.19 realgrid update시 배열 data addRow시 오류로 인해 for문 사용으로 변경
					//gridECPY.addRow(JSON.parse(PY_INFO));
					var EcpyInfo = JSON.parse(PY_INFO);
					for(var j in EcpyInfo) {
						gridECPY.addRow(EcpyInfo[j]);
				    }
					// 2021.12.17 : IT포탈 변경계약서 작성시 "대금지불정보, 지불정보, 고객사별 지불고객사 정보"의 협력사를 "견적/입찰" 선정 협력사로 변경
					if(gridECPY.getRowCount() > 0) {
						var curVendorCd = "";
						if( "${form.copyFlag}" == "true" && EVF.V("CONT_REQ_CD") == '20' ) {
							curVendorCd = EVF.V("VENDOR_CD");
						}
						if( !EVF.isEmpty(curVendorCd) ) {
							var idx = gridECPY.getAllRowId();
							for(var i in idx) {
								gridECPY.setCellValue(idx[i], "VENDOR_CD", curVendorCd);
							}
						}
					}
				}
				
				if(colIdx == "PR_BUYER_DEPT_NM") {
					if( ("${form.copyFlag}" != "true" || value == "") || ("${form.copyFlag}" == "true" && EVF.V("CREATE_TYPE") == "PR") ) {
						var param = {
				                'callBackFunction': 'callBackBuyerDept',
				                'READONLY': 'N',		//팝업 조회조건 변경불가
								'multiYN' : 'N',        //멀티팝업여부
								'rowIdx': rowIdx,
								'detailView': false
				            };
				        everPopup.openPopupByScreenId("CCDU0010", 1000, 700, param);
					}
				} else {
					// 고객사 Grid의 Row 클릭시 세팅하기
					gridECCMClickDefault(rowIdx);
				}
			});

			gridECCM.cellChangeEvent(function (rowIdx, colIdx, irow, icol, value, oldValue) {
				var param;
				var ivType = gridECCM.getCellValue(rowIdx, "IV_TYPE");
				switch (colIdx) {
					case "METHOD_TYPE_NM":
						break;
						
					case "IV_TYPE" :
						onChangeIV_TYPE(rowIdx, value);
						break;	
				}
			});

			gridECMT.cellClickEvent(function (rowIdx, colIdx, value, iRow, iCol) {
				var param;
				switch (colIdx) {
					case "MAKER_NM":
						if (gridECMT.getCellValue(rowIdx, "MAJOR_ITEM_FLAG") == "1") {
							param = {
								callBackFunction: "callBackMAKER_NM",
								rowIdx: rowIdx
							};
							everPopup.openCommonPopup(param, "SP0068");
						}
						break;

					case "IV_USER_NM":
						param = {
			                'callBackFunction': 'callBackINSPECT_USER_ID',
			                'READONLY': 'N',         //팝업 조회조건 변경불가
			                'multiYN' : 'N',         //멀티팝업여부
			                'rowIdx': rowIdx,
			                'detailView': false
						};
						everPopup.openPopupByScreenId("CCDU0020", 1100, 700, param);
						break;

					case "PR_NUM":
						if( value == "" ) return;
	                    param = {
	                        prNum: value,
	                        buyerCd: gridECMT.getCellValue(rowIdx, "PB_BUYER_CD"),
	                        popupFlag: true,
	                        detailView: true
	                    };
	                    everPopup.openPopupByScreenId("CPRI0010", 1200, 900, param);
						break;

					case "EXEC_NUM":
						if( value == "" ) return;
						param = {
							'execNum': value,
							'buyerCd': gridECMT.getCellValue(rowIdx, 'BUYER_CD'),
							'tcoFlag': null,
							'popupFlag': true,
							'detailView': true
						};
						everPopup.openWindowPopup("/nhepro/CBDR/CBDI0061/view.so", 1400, 800, param, "createCN", true);
						break;

					case "ITEM_CD":
						param = {
							detailView: false,
							callbackFunction: "callBackGridITEM",
							rowIdx: rowIdx,
							callType: "S"
						};
						everPopup.openPopupByScreenId("CITR0042", 1150, 810, param);
						break;
				}
			});

			gridECMT.cellChangeEvent(function (rowIdx, colIdx, irow, icol, value, oldValue) {
				var param;
				var purchase_type = gridECMT.getCellValue(rowIdx, "PURCHASE_TYPE");
				switch (colIdx) {
					case "ITEM_QT" :
						onchangeQtPrc(rowIdx);
						if(purchase_type == "S" || purchase_type == "M") {
							onChangeDiscount(rowIdx, "SW_BIZ_AMT");
						} else {
							onChangeDiscount(rowIdx, "CONSUMER_AMT");
						}
						break;

					case "ITEM_PRC":
						onchangeQtPrc(rowIdx);
						if(purchase_type == "S" || purchase_type == "M") {
							onChangeDiscount(rowIdx, "SW_BIZ_AMT");
						} else {
							onChangeDiscount(rowIdx, "CONSUMER_AMT");
						}
						break;

					case "SW_BIZ_AMT":
						onChangeDiscount(rowIdx, colIdx);
						break;

					case "CONSUMER_AMT":
						onChangeDiscount(rowIdx, colIdx);
						break;

					case "PURCHASE_TYPE":
						ecmtPurchaseTypeDefaultSet(rowIdx, value);
						break;
				}
			});

			gridECPY.cellClickEvent(function (rowIdx) {

				var param = {
					PR_BUYER_CD: gridECPY.getCellValue(rowIdx, "PR_BUYER_CD"),
					PR_DEPT_CD: gridECPY.getCellValue(rowIdx, "PR_DEPT_CD"),
					VENDOR_CD: gridECPY.getCellValue(rowIdx, "VENDOR_CD"),

					PAY_CNT: gridECPY.getCellValue(rowIdx, "PAY_CNT"),
					PAY_CNT_TYPE: gridECPY.getCellValue(rowIdx, "PAY_CNT_TYPE"),
					PAY_CNT_NM: gridECPY.getCellValue(rowIdx, "PAY_CNT_NM"),
					PAY_AMT: gridECPY.getCellValue(rowIdx, "PAY_AMT")
				};

				if(gridECPC.getRowCount() > 0) {
					var idx = gridECPC.getCellValue(0, "PAY_CNT");
					ECPC_COPY(idx - 1);
				}

				if(gridECPY.getRowCount() > 0) {
					ECPY_COPY(gridECCM.getSelRowId()[0]);
				}
				
				gridECPC.delAllRow();
				
				var PC_INFO = gridECPY.getCellValue(rowIdx, "PC_INFO");
				if( PC_INFO == "" ) {
					gridECPC.addRow(param);
				} else {
					//21.01.19 realgrid update시 배열 data addRow시 오류로 인해 for문 사용으로 변경
					//gridECPC._gdp.addRow(JSON.parse(PC_INFO));
					var parseEcpcInfo = JSON.parse(PC_INFO);
					for(var j in parseEcpcInfo) {
						gridECPC._gdp.addRow(parseEcpcInfo[j]);
				    } 
					gridECPC.checkAll(true);
				}
				if(gridECPC.getRowCount() > 0) {
					// 2021.12.17 : IT포탈 변경계약서 작성시 "대금지불정보, 지불정보, 고객사별 지불고객사 정보"의 협력사를 "견적/입찰" 선정 협력사로 변경
					var curVendorCd = "";
					if( "${form.copyFlag}" == "true" && EVF.V("CONT_REQ_CD") == '20' ) {
						curVendorCd = EVF.V("VENDOR_CD");
					}
					if( !EVF.isEmpty(curVendorCd) ) {
						var idx = gridECPC.getAllRowId();
						for(var i in idx) {
							gridECPC.setCellValue(idx[i], "VENDOR_CD", curVendorCd);
						}
					}
				}
				
				gridECPC_HD.setColIconify("RMK", "RMK", "detail", true);
				
				var sumPayAmt = gridECPC._gvo.getSummary("PAY_AMT", "sum");
				gridECPY._gdp.setValue(rowIdx, "PY_PAY_AMT", sumPayAmt);
			});

			gridECPY.cellChangeEvent(function (rowIdx, colIdx, iRow, iCol, value) {
				var contAmt = 0;
				if(gridECCM.getSelRowId()[0] == undefined) {
					contAmt = gridECCM.getCellValue(gridECCM._gvo.getCurrent().dataRow, "CONT_AMT");
				} else {
					contAmt = gridECCM.getCellValue(gridECCM.getSelRowId()[0], "CONT_AMT");
				}

				if(colIdx == "PAY_CNT_NM") {
					var allRowId = gridECPC.getAllRowId();
					for(var k in allRowId) {
						var idx = allRowId[k];
						gridECPC.setCellValue(idx, "PAY_CNT_NM", value);
					}
				}
				else if(colIdx == "PAY_PERCENT") {
					gridECPY.setCellValue(rowIdx, "PAY_AMT", everMath.floor_float((gridECPY.getCellValue(rowIdx, "PAY_PERCENT") / 100) * contAmt));
				}
				else if(colIdx == "PAY_AMT") {
					//2020.09.04 : 보증금 바뀔때 요율(%)은 바뀌지 않도록 함.
					//gridECPY.setCellValue(rowIdx, "PAY_PERCENT", (gridECPY.getCellValue(rowIdx, "PAY_AMT") * 100) / contAmt);
					if (gridECPY._gvo.getSummary("PAY_AMT", "sum") > contAmt) {
						gridECPY.setCellValue(rowIdx, "PAY_AMT", "");
						return EVF.alert("지불정보의 지급예정금액 합이 계약금액을 초과합니다.\n확인하여 주시기 바랍니다.");
					}
				}
				else if(colIdx == "PAY_CNT_TYPE") {
					gridECPY.setCellValue(rowIdx, "PAY_CNT_NM", gridECPY.getCellText(rowIdx, colIdx));
				}

				if(gridECPC.getRowCount() > 0) {
					var idx = gridECPC.getCellValue(0, "PAY_CNT");
					ECPC_COPY(idx - 1);
				}

				if(gridECPY.getRowCount() > 0) {
					ECPY_COPY(gridECCM.getSelRowId()[0]);
				}
			});

			gridECPC_HD.cellClickEvent(function(rowIdx, colIdx, value) {
				var url;
				var param;
				var oldIdx = gridECPC_HD.getSelRowId()[0];
				var guaranteer = gridECPC_HD.getCellValue(rowIdx, "GUARANTEER");
				
				if(colIdx == "PY_USER_NM") {
					onSearchPyUserNm(rowIdx);
				}
				if(colIdx == "RMK") {
					param = {
						title: "비고",
						message: value,
						callbackFunction: 'setHDRmk',
						rowIdx: rowIdx,
						detailView: detailView
					};
					url = "/common/popup/common_text_input/view.so";
					everPopup.openModalPopup(url, 500, (param.detailView == true ? 300 : 320), param);
				}
				if(colIdx == "ATT_FILE_CNT") {
					if(value == 0) return;
					
					param = {
						bizType: 'EC',
						attFileNum: gridECPC_HD.getCellValue(rowIdx, 'ATT_FILE_NUM'),
						callBackFunction: 'setHdAttachFileNo',
						rowIdx: rowIdx,
						detailView: detailView
					};
					everPopup.fileAttachPopup(param);
				}
				if(colIdx == "DI_ATT_FILE_CNT") {
					if(value == 0) return;
					
					param = {
						bizType: 'EC',
						attFileNum: gridECPC_HD.getCellValue(rowIdx, 'DI_ATT_FILE_NUM'),
						callBackFunction: 'setDiAttachFileNo',
						rowIdx: rowIdx,
						detailView: detailView
					};
					everPopup.fileAttachPopup(param);
				}
				if(colIdx == "GUAR_NUM") {
					if( value == "" ) return;
					if (guaranteer == "20") {
                		var url = "${ksfcUrl}";
                		window.open(url);
            		}
				}
			});

			gridECPC_HD.cellChangeEvent(function(rowIdx, colIdx, iRow, iCol, value) {
				switch(colIdx) {
					case "PAY_AMT":
						var payAmtSum = gridECPC_HD._gvo.getSummary("PAY_AMT", "sum");
						if (payAmtSum > EVF.V("CONT_AMT_DUP")) {
							gridECPC_HD.setCellValue(rowIdx, "PAY_AMT", "");
							return EVF.alert("지급금액 합의 값이 계약금액을 초과합니다.\n확인하여 주시기 바랍니다.");
						}
						break;

					case "GUAR_TYPE2":
						ecpcHdGuarTypeDefaultSet(rowIdx);
						break;

					case "GUAR_PERCENT":
						onChangeGuarAmt(rowIdx, gridECPC_HD);
						break;

					case "GUAR_AMT":
						//2020.09.04 : 보증금 바뀔때 요율(%)은 바뀌지 않도록 함.
						//onChangeGuarPercent(rowIdx, gridECPC_HD);
						break;

					case "DI_GUAR_AMT":
						EVF.V("GUAR_AMT", gridECPC_HD._gvo.getSummary("DI_GUAR_AMT", "sum"));
						break;

					case "GUAR_TYPE":

						if(val == "DIF") {
							gridECPC_HD.setCellValue(rowIdx, colIdx, "");
							return EVF.alert("계약보증에서는 차액보증을 선택하실 수 없습니다.")
						}
						break;

					case "SIGN_FLAG":
						if(value == "0") {
							gridECPC_HD.setCellRequired(rowIdx, "CTRL_USER_NM", true);
						} else {
							gridECPC_HD.setCellRequired(rowIdx, "CTRL_USER_NM", false);
						}
						break;
				}

				ECPC_HD_COPY(gridECCM.getSelRowId()[0]);
			});

			gridECPC_HD.addRowEvent(function() {

				if (gridECCM.getSelRowCount() == 0) { return EVF.alert("고객사를 선택하여 주시기 바랍니다."); }
				if (gridECCM.getSelRowCount() > 1) { return EVF.alert("고객사 정보를 "+ "${msg.M0006}"); }

				var selRowId = gridECCM.getSelRowId()[0];

				// 고객사 그리드의 addRow 후 고객사 선택을 안했을 경우 다시 체크
				if(gridECCM.getCellValue(selRowId, "PR_BUYER_DEPT_NM") == "") {
					return EVF.alert("고객사를 선택하여 주시기 바랍니다.");
				}

				var param = {
					CONT_NUM: gridECCM.getCellValue(selRowId, "CONT_NUM"),
					CONT_CNT: gridECCM.getCellValue(selRowId, "CONT_CNT"),
					PR_BUYER_CD: gridECCM.getCellValue(selRowId, "PR_BUYER_CD"),
					PR_DEPT_CD: gridECCM.getCellValue(selRowId, "PR_DEPT_CD"),
					VENDOR_CD: gridECCM.getCellValue(selRowId, "VENDOR_CD"),
					PAY_AMT: gridECPC_HD.getRowCount() == 0 ? gridECCM.getCellValue(selRowId, "CONT_AMT") : "0",
					GUAR_TYPE: "CONT",
					DI_GUAR_TYPE: "DIF",
					DI_GUAR_AMT: 0
				};
				var addRow = gridECPC_HD.addRow(param);

				gridECPC_HD.setColIconify("RMK", "RMK", "detail", true);

				onSearchPyUserNm(addRow);
			});

			gridECPC_HD.delRowEvent(function() {
				if(gridECPC_HD.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
				gridECPC_HD.delRow();
				ECPC_HD_COPY(gridECCM.getSelRowId()[0]);
			});

			gridECPC.cellClickEvent(function(rowIdx, colIdx, value) {
				var param;
				var url;
				var idx = gridECPC.getCellValue(rowIdx, "PAY_CNT");
				var guaranteer  = gridECPC.getCellValue(rowIdx, "GUARANTEER");
				
				if(gridECPC.getRowCount() > 0) {
					ECPC_COPY(idx - 1);
				}

				if(gridECPY.getRowCount() > 0) {
					ECPY_COPY(gridECCM.getSelRowId()[0]);
				}

				/*if(gridECPC_HD.getRowCount() > 0) {
					ECPC_HD_COPY(gridECCM.getSelRowId()[0]);
				}*/

				if(!detailView) {
					if(colIdx == "PY_USER_NM") {
						doSearchPY_BUYER_DEPT_NM(rowIdx);
					}
				}

				if(colIdx == "ATT_FILE_CNT") {
					if(value > 0) {
						param = {
							bizType: 'EC',
							attFileNum: gridECPC.getCellValue(rowIdx, 'ATT_FILE_NUM'),
							callBackFunction: 'setAttachFileNo',
							rowIdx: rowIdx,
							detailView: true
						};
						everPopup.fileAttachPopup(param);
					}
				}

				if(colIdx == "RMK") {
					param = {
						title: "비고",
						message: value,
						callbackFunction: 'setRmk',
						rowIdx: rowIdx,
						idx : idx-1,
						detailView: false
					};

					url = "/common/popup/common_text_input/view.so";
					everPopup.openModalPopup(url, 500, (param.detailView == true ? 300 : 320), param);
				}
				
				if(colIdx == "GUAR_NUM") {
					if( value == "" ) return;
					if (guaranteer == "20") {
                		var url = "${ksfcUrl}";
                		window.open(url);
            		}
				}
			});

			gridECPC.cellChangeEvent(function(rowIdx, colIdx, iRow, iCol, value) {
				var idx = gridECPC.getCellValue(rowIdx, "PAY_CNT");

				if(gridECPC.getRowCount() > 0) {
					ECPC_COPY(idx - 1);
				}

				if(gridECPY.getRowCount() > 0) {
					ECPY_COPY(gridECCM.getSelRowId()[0]);
				}

				/*if(gridECPC_HD.getRowCount() > 0) {
					ECPC_HD_COPY(gridECCM.getSelRowId()[0]);
				}*/

				if(colIdx == "PAY_AMT") {
					var sumPayAmt = gridECPC._gvo.getSummary("PAY_AMT", "sum");
					if(sumPayAmt > gridECPY.getCellValue(idx - 1, "PAY_AMT")) {
						gridECPC.setCellValue(rowIdx, "PAY_AMT", "");
						return EVF.alert("고객사별 지불고객사 정보의 지급금액의 합이 지불정보의 지급예정금액을 초과합니다.\n확인하여 주시기 바랍니다.");
					}
					gridECPY.setCellValue(idx - 1, "PY_PAY_AMT", sumPayAmt);
				}
				else if(colIdx == "GUAR_TYPE") {
					if(value == "WARR") {
						gridECPC.setCellRequired(rowIdx, "GUAR_QT", true);
					}
					else {
						gridECPC.setCellRequired(rowIdx, "GUAR_QT", false);
					}
				}
				else if(colIdx == "GUAR_PERCENT") {
					if( gridECPC.getCellValue(rowIdx, "GUAR_TYPE") == "WARR"){
						onChangeWarrGuarAmt(rowIdx, gridECPC);
					}
					else{
						onChangeGuarAmt(rowIdx, gridECPC);	
					}
				}
				else if(colIdx == "GUAR_AMT") {
					//2020.09.04 : 보증금 바뀔때 요율(%)은 바뀌지 않도록 함.
					//onChangeGuarPercent(rowIdx, gridECPC);
				}
			});
			
			// 행추가
			gridECPC.addRowEvent(function() {
				
				if(gridECPC.getRowCount() == 0) { return EVF.alert("지불정보 차수를 먼저 선택하세요."); }
				
				var row = gridECPY._gvo.getCurrent().dataRow;
				var selRowValue = gridECPY.getRowValue(row);
				var param = {
					PR_BUYER_CD : selRowValue.PR_BUYER_CD,
					PR_DEPT_CD  : selRowValue.PR_DEPT_CD,
					VENDOR_CD   : selRowValue.VENDOR_CD,
					PAY_CNT: gridECPC.getCellValue(0, "PAY_CNT"),
					PAY_CNT_TYPE: gridECPC.getCellValue(0, "PAY_CNT_TYPE"),
					PAY_CNT_NM: gridECPC.getCellValue(0, "PAY_CNT_NM")
				};
				var rowIdx = gridECPC.addRow(param);
				gridECPC.setColIconify("RMK", "RMK", "detail", true);
			});
			
			// 행복사 후 추가
			gridECPC.insertRowEvent(function() {
				gridECPC.insertRow(true);
			});
			
			gridECPC.upMoveRowEvent(function() {
				gridECPC.upMoveRow();
			});

			gridECPC.downMoveRowEvent(function() {
				gridECPC.downMoveRow();
			});

			gridECPC.delRowEvent(function() {
				if(gridECPC.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
				
				// 그리드 데이터 삭제
				gridECPC.delRow();
				
				ECPC_COPY(gridECPY._gvo.getCurrent().dataRow);
			});

			doSearchForm(); // 주서식조회
			
			// 2021.05.18 기능 추가
			var preContNum = EVF.V("PRE_CONT_NUM");
			if( preContNum != '' || (EVF.V("CONT_CNT") != '' && Number(EVF.V("CONT_CNT")) > 1) ) {
				//2021.12.17 : 2차수 이상의 계약건이 신규인 경우도 존재함(중앙회 박기현 책임)
				//EVF.C('CONT_REQ_CD').removeOption('10');
				if( preContNum != '' ) {
					if( EVF.V("CONT_NUM") == '' && EVF.V("CONT_CNT") == '' ) {
						EVF.C("CONT_NUM_AND_CNT").setValue(preContNum + " / " + "자동채번");
					}
					EVF.C('CONT_REQ_CD').setDisabled(true);
				}
			}
			else if (preContNum == '' || EVF.V("CONT_CNT") == '') {
				EVF.C('CONT_REQ_CD').setValue('10');
			}
			
			// 폼 셋팅
			doSetDefaultForm();
			
			// 2021.05.25 추가
			// 구매의뢰(연장계약:30) 및 선정품의(신규:10 및 변경계약:20) 기준 계약서 작성
			console.log("form.copyFlag =====> " + "${form.copyFlag}" + ", CREATE_TYPE ====> " + EVF.V("CREATE_TYPE"));
			// 연장계약서 신규작성(30), 일반(10) 및 변경(20) 계약서 신규작성인 경우 copyFlag = true
			// 수정화면은 copyFlag = undefined
			if("${form.copyFlag}" == "true") {
				EVF.C("CUR").setDisabled(true);			// 통화
				EVF.C("VAT_TYPE").setDisabled(true);	// 부가세구분
				EVF.C("VENDOR_NM").setDisabled(true);	// 협력사명
				EVF.C("AMT_TYPE").setDisabled(true);	// 단가구분(총액, 단가)
				
				// 구매의뢰(PR) 기준 연장계약(30)인 경우 이전계약번호 기준 고객사 조회(ECCM, ECMT, ECPC)
				if( EVF.V("PRE_CONT_NUM") != '' && EVF.V("CONT_REQ_CD") == '30' ) {
					EVF.C("DELAY_RMK").setDisabled(true);		// 지체상금율비고
					EVF.C("DELAY_NUME_RATE").setDisabled(true);	// 지체상금율(분자)
					EVF.C("DELAY_DENO_RATE").setDisabled(true);	// 지체상금율(분모)
					EVF.C("STAMP_DUTY_FLAG").setDisabled(true);	// 인지세여부
					EVF.C("STAMP_DUTY_AMT").setDisabled(true);	// 인지세금액
				}
				
				// 이전계약번호의 계약정보를 가져와서 세팅해준다.
				doSearchECCM();
			} // 작성된 계약서 기준 계약정보 조회(수정)
			else {
				if (EVF.V("CREATE_TYPE") == "PR") {
					EVF.C('CONT_REQ_CD').setDisabled(true);		// 계약구분
					EVF.C("CUR").setDisabled(true);				// 통화
					EVF.C("VAT_TYPE").setDisabled(true);		// 부가세구분
					EVF.C("VENDOR_NM").setDisabled(true);		// 협력사명
					EVF.C("AMT_TYPE").setDisabled(true);		// 단가구분(총액, 단가)
					EVF.C("DELAY_RMK").setDisabled(true);		// 지체상금율비고
					EVF.C("DELAY_NUME_RATE").setDisabled(true);	// 지체상금율(분자)
					EVF.C("DELAY_DENO_RATE").setDisabled(true);	// 지체상금율(분모)
					EVF.C("STAMP_DUTY_FLAG").setDisabled(true);	// 인지세여부
					EVF.C("STAMP_DUTY_AMT").setDisabled(true);	// 인지세금액
				}
				doSearchECCM(); 	// 고객사 조회
				doSearchECMT(); 	// 품목정보 조회
			}
			
			gridECPY.setColBgColor("PY_PAY_AMT", "#f5f5f5");
			gridECPY.setColBgColor("PY_BUYER_NM", "#f5f5f5");
			
			gridECPC_HD.setColGroup([
				{
					"groupName": "계약보증",
					"columns": ["GUAR_TYPE", "GUAR_PERCENT", "GUAR_AMT", "GUAR_TYPE2", "GUARANTEER", "GUAR_REQ_NUM_CNT", "GUAR_NUM", "BOND_BEGN_DATE", "BOND_FNSH_DATE", "ATT_FILE_CNT"]
				},
				{
					"groupName": "차액보증",
					"columns": ["DI_GUAR_TYPE","DI_GUAR_AMT","DI_ATT_FILE_CNT"]
				}
			], 50);

			gridECPC.setColGroup([
				{
					"groupName": "보증정보",
					"columns": ["GUAR_TYPE", "GUAR_PERCENT", "GUAR_QT", "GUAR_AMT", "GUAR_TYPE2", "GUARANTEER", "GUAR_REQ_NUM_CNT", "GUAR_NUM", "BOND_BEGN_DATE", "BOND_FNSH_DATE", "ATT_FILE_CNT"]
				}
			], 50);
		    
		    gridECMT.setColGroup([
                {
                    "groupName": '용역',
                    "columns": ['SW_BIZ_AMT', 'SW_BIZ_DISCOUNT', 'MNT_SANGJU_YN']
                }
                ,{
                    "groupName": '물품(공사,기타,양수)',
                    "columns": ['CONSUMER_AMT', 'CONSUMER_DISCOUNT', 'FC_MNT_TERM', 'CH_RATE']
                }
                ,{
                    "groupName": '유지보수(리스,재리스,렌탈,도급)',
                    "columns": ['DOIB_AMOUNT', 'MNT_RATE', 'MNT_SDAY', 'MNT_EDAY', 'MNT_GUR_MONTH', 'RT_INSP_PERIOD', 'FALT_RC_TG_TIME']
                }
                ,{
                    "groupName": '계약금액 상세정보',
                    "columns": ['5_CONT_AMT', '1_CONT_AMT', 'A_CONT_AMT', '2_CONT_AMT', '3_CONT_AMT']
                }
                ,{
                    "groupName": '인터페이스정보(IT포탈)',
                    "columns": ['PRE_CONT_NUM', 'PRE_CONT_CNT', 'CM_REQ_ID', 'IF_TYPE']
                }
            ],50);

			// ======================그리드 합계 구하기=======================
		    var val = {"visible": true, "count": 1, "height": 15};
		    gridECMT.setProperty('footerVisible', val);
		    
		    var footer = {
		          "styles": {
		              "textAlignment": "center",
		              "fontBold": true,
		              "fontFmaily": "Nanum Gothic",
		          },
		          "text": "합   계"
		    };
		    gridECMT.setRowFooter("PR_BUYER_DEPT_NM", footer);
		    
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
		    gridECMT.setRowFooter("ITEM_QT", distVal);
		    gridECMT.setRowFooter("ITEM_AMT", distVal);
		    gridECMT.setRowFooter("SW_BIZ_AMT", distVal);
		    gridECMT.setRowFooter("CONSUMER_AMT", distVal);
		    gridECMT.setRowFooter("DOIB_AMOUNT", distVal);
		    gridECMT.setRowFooter("5_CONT_AMT", distVal);
		    gridECMT.setRowFooter("1_CONT_AMT", distVal);
		    gridECMT.setRowFooter("A_CONT_AMT", distVal);
		    gridECMT.setRowFooter("2_CONT_AMT", distVal);
		    gridECMT.setRowFooter("3_CONT_AMT", distVal);
		    // ===========================================================
		    	
		    // ======================그리드 합계 구하기=======================
		    var val = {"visible": true, "count": 1, "height": 15};
		    gridECPC.setProperty('footerVisible', val);

		    var footer = {
		          "styles": {
		              "textAlignment": "center",
		              "fontBold": true,
		              "fontFmaily": "Nanum Gothic",
		          },
		          "text": "합   계"
		    };
		    gridECPC.setRowFooter("PAY_CNT_NM", footer);

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
		    gridECPC.setRowFooter("PAY_AMT", distVal);
		    gridECPC.setRowFooter("GUAR_AMT", distVal);
		    // ===========================================================
		    
		    // ======================지불정보 : 그리드 합계 구하기=======================
		    var val = {"visible": true, "count": 1, "height": 15};
		    gridECPY.setProperty('footerVisible', val);

		    var footer = {
		          "styles": {
		              "textAlignment": "center",
		              "fontBold": true,
		              "fontFmaily": "Nanum Gothic",
		          },
		          "text": "합   계"
		    };
		    gridECPY.setRowFooter("PAY_CNT_TYPE", footer);

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
		    gridECPY.setRowFooter("PAY_PERCENT", distVal);
		    gridECPY.setRowFooter("PAY_AMT", distVal);
		    gridECPY.setRowFooter("PY_PAY_AMT", distVal);
		    // ===========================================================
		    
		    // ======================계약보증 정보 및 서명여부 : 그리드 합계 구하기=======================
		    var val = {"visible": true, "count": 1, "height": 15};
		    gridECPC_HD.setProperty('footerVisible', val);

		    var footer = {
		          "styles": {
		              "textAlignment": "center",
		              "fontBold": true,
		              "fontFmaily": "Nanum Gothic",
		          },
		          "text": "합   계"
		    };
		    gridECPC_HD.setRowFooter("PY_BUYER_DEPT_NM", footer);

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
		    gridECPC_HD.setRowFooter("PAY_AMT", distVal);
		    gridECPC_HD.setRowFooter("GUAR_AMT", distVal);
		    gridECPC_HD.setRowFooter("DI_GUAR_AMT", distVal);
		    // ===========================================================
		    
		    setLinkStyle(); 
		}
		
		function setLinkStyle() {
			gridECPC_HD.setColFontColor("GUAR_NUM", "#FF0000");
			gridECPC.setColFontColor("GUAR_NUM", "#FF0000");
        }
		
		function doSetDefaultForm() {
			var preContNum = EVF.V("PRE_CONT_NUM");
			if ("${form.CONT_NUM}" == "" && "${form.CONT_CNT}" == "") {
				EVF.V("CONT_USER_NM", "${ses.userNm}");
				EVF.V("CONT_USER_ID", "${ses.userId}");
				
				// 신규(10) 계약인 경우에만 통화 = KRW
				if( preContNum != "" ) {
					EVF.V("CUR", "KRW");
				}
			}
			else {
				EVF.C('CONT_NUM_AND_CNT').setStyle('color:blue;font-weight:bold;');
			}
			
			// 사용자의 법인구분이 중앙회 OR 은행일 경우만 각각의 항목이 보여야 한다.
			if (!("${ses.corpType}" == "5" || "${ses.corpType}" == "1")) {
				gridECMT.hideCol("5_CONT_AMT", true);
				gridECMT.hideCol("1_CONT_AMT", true);
				gridECMT.hideCol("A_CONT_AMT", true);
				gridECMT.hideCol("2_CONT_AMT", true);
				gridECMT.hideCol("3_CONT_AMT", true);
			}
			
			// 공인인증서 디폴트
			EVF.V("CERT_TYPE", "C");
		}
		
		// 2021.05.25
		// 구매의뢰(연장계약) 및 선정품의(신규, 변경계약) 기준으로 계약품목 조회
		function doSearchCNDT() {
			var store = new EVF.Store();
			store.setGrid([gridECMT]);
			store.load(baseUrl + '/SCMS0010_doSearchCNDT.so', function() {
				
				// 구매의뢰(PRDT), 선정품의(CNDT)를 기반으로 고객사 정보를 셋팅
				var allRowId = gridECMT.getAllRowId();
				
				// form의 계약금액 세팅하기
				EVF.V("CONT_AMT", gridECMT._gvo.getSummary("ITEM_AMT","sum"));
				
				var pr_buyer_dept_list = [];
				var po_create_type = EVF.V("AMT_TYPE") == "TA" ? "1" : "0";
				for(var i in allRowId) {
					var rowIdx = allRowId[i];
					var purchase_type = gridECMT.getCellValue(rowIdx, "PURCHASE_TYPE");
					pr_buyer_dept_list.push(
						{
							PR_BUYER_CD: gridECMT.getCellValue(rowIdx, "PR_BUYER_CD"),
							PR_DEPT_CD : gridECMT.getCellValue(rowIdx, "PR_DEPT_CD"),
							PR_BUYER_DEPT_NM: gridECMT.getCellValue(rowIdx, "PR_BUYER_DEPT_NM"),
							PO_CREATE_FLAG  : po_create_type,
							VENDOR_CD  : gridECMT.getCellValue(rowIdx, "VENDOR_CD")
						}
					);
				}
				
				// 동일 값을 제외한 PR_BUYER_CD, PR_DEPT_CD, PR_BUYER_DEPT_NM 값 추출
				var uniqueArr = [];
				var ecmtInfo = pr_buyer_dept_list.map(function(val, index) {
					return val["PR_BUYER_DEPT_NM"];
				}).filter(function(val, index, arr) {
					if(arr.indexOf(val) === index) {
						uniqueArr.push(pr_buyer_dept_list[index]);
					}
					return arr.indexOf(val) === index;
				});
				
				// 추출한 uniqueArr 의 조건에 따라 금액 SUM
				for(var i in uniqueArr) {
					var unique = uniqueArr[i];
					var item_amt = 0;
					for(var j in allRowId) {
						var rowIdx = allRowId[j];
						if( unique.PR_BUYER_CD == gridECMT.getCellValue(rowIdx, "PR_BUYER_CD") &&
							unique.PR_DEPT_CD  == gridECMT.getCellValue(rowIdx, "PR_DEPT_CD") ) {
							item_amt += gridECMT.getCellValue(rowIdx, "ITEM_AMT");
						}
					}
					unique["CONT_AMT"] = item_amt;
				}
				
				// copyFlag=true : 구매의뢰접수에서 연장계약작성, 계약대기현황에서 전자계약서 작성 (신규작성시에만 true)
				// IT포탈 변경계약(20) : 고객사별 계약금액 세팅하기
				if( "${form.copyFlag}" == "true" && EVF.V("PRE_CONT_NUM") != '' && (EVF.V("CONT_REQ_CD") == '20' || EVF.V("CONT_REQ_CD") == '30') ) {
					var allCmRowId = gridECCM.getAllRowId();
					for(var i in allCmRowId) {
						var rowIdx = allCmRowId[i];
						for(var i in uniqueArr) {
							var unique = uniqueArr[i];
							//gridECCM.setCellValue(rowIdx, "PR_BUYER_CD", unique.PR_BUYER_CD);
							//gridECCM.setCellValue(rowIdx, "PR_DEPT_CD", unique.PR_DEPT_CD);
							//gridECCM.setCellValue(rowIdx, "PR_BUYER_DEPT_NM", unique.PR_BUYER_DEPT_NM);
							
							if( unique.PR_BUYER_CD == gridECCM.getCellValue(rowIdx, "PR_BUYER_CD") &&
								unique.PR_DEPT_CD  == gridECCM.getCellValue(rowIdx, "PR_DEPT_CD") ) {
								gridECCM.setCellValue(rowIdx, "CONT_AMT",  unique.CONT_AMT);// 품목별 금액 세팅
							}
							gridECCM.setCellValue(rowIdx, "VENDOR_CD", unique.VENDOR_CD);	// 품목의 협력사를 계약고객사 협력사에 세팅
						}
					}
				} else {
					// 계약 고객사를 Grid에 Add
					gridECCM.addRow(uniqueArr);
					if(gridECCM.getRowCount() > 0) {
						//setCallBackECCM();
						var eccmRowId = gridECCM.getAllRowId();
						for(var i in eccmRowId) {
							gridECCM.setCellReadOnly(eccmRowId[i], "PO_CREATE_FLAG", false);
						}
					}
				}
				
				if (gridECCM.getRowCount() > 0) {
					// 계약 고객사가 존재하는 경우 첫번째 고객사 정보 선택하고 세팅함
					setCallBackECCM();
					
					// 금액구분(총액, 단가)에 따른 ECCM의 발주생성여부 자동 세팅
					onChangeAmtType(true);
				}
				
				for(var i in allRowId) {
					var rowIdx = allRowId[i];
					var purchase_type = gridECMT.getCellValue(rowIdx, "PURCHASE_TYPE");
					
					// 2021.05.25 변경 : 구매유형에 따른 품목 필수값 체크하기
					//onChangePurchaseType(rowIdx, purchase_type);
					ecmtPurchaseTypeDefaultSet(rowIdx, purchase_type);
					
					if(purchase_type == "S" || purchase_type == "M") {
						onChangeDiscount(rowIdx, "SW_BIZ_AMT");
					} else {
						onChangeDiscount(rowIdx, "CONSUMER_AMT");
					}
				}
			}, false);
		}
		
		function SetOZParamters_OZViewer(param){
			var url = "${ozUrl}" + "/ozhviewer_canvas_eform.jsp";
			everPopup.openWindowPopup(url, 850, 1265, param, 'eform');
		}

		function gridECCMClickDefault(rowIdx) {
			if(gridECMT.getRowCount() > 0) {
				var allRowId = gridECMT.getAllRowId();
				var buyerDeptCnt = 0;
				for(var i in allRowId) {
					var selRowId = allRowId[i];
					if(gridECMT.getCellValue(selRowId, "PR_BUYER_DEPT_NM") == gridECCM.getCellValue(rowIdx, "PR_BUYER_DEPT_NM")) {
						buyerDeptCnt++;
					}
				}
				
				// 고객정보의 고객사와 품목정보의 고객사가 다른 경우 계약고객사 품목을 추가한다.
				if( buyerDeptCnt == 0 && ecmtFlag ) {
					EVF.confirm(gridECCM.getCellValue(rowIdx, "PR_BUYER_DEPT_NM") + " 품목정보를 추가하여 주시기 바랍니다.", function() {
						doItemSearch();
                    });
				}

				var cur = EVF.V("CUR");
				var vatType = EVF.V("VAT_TYPE");

				EVF.V("BUYER_DEPT_NM", gridECCM.getCellValue(rowIdx, "PR_BUYER_DEPT_NM"));
				EVF.V("CONT_AMT_DUP", gridECCM.getCellValue(rowIdx, "CONT_AMT"));
				EVF.V("CUR_DUP", cur);
				EVF.V("CUR_GUAR", cur);
				EVF.V("VAT_TYPE_DUP", vatType);
				EVF.V("PAY_TYPE_DUP", gridECCM.getCellValue(rowIdx, "METHOD_TYPE"), false);
				EVF.V("PAY_CNT", gridECCM.getCellValue(rowIdx, "PAY_CNT"));
			}
			
			if(gridECPC_HD.getRowCount() > 0) {
				EVF.V("GUAR_AMT", gridECPC_HD._gvo.getSummary("DI_GUAR_AMT","sum"));

				var idx = gridECPC_HD.getAllRowId();
				for(var i in idx) {
					ecpcHdGuarTypeDefaultSet(idx[i]);
				}
			}
		}
		
		function onChangeIV_TYPE(rowIdx, value) {
			if (value == "DI") {	// DI:부분(납품), PI:전체
                EVF.C("PAY_TYPE_DUP").setDisabled(true);
                EVF.C("PAY_TYPE_DUP").setRequired(false);
                EVF.V("PAY_TYPE_DUP", "LS");
            }
            else if (value == "PI") {
                EVF.C("PAY_TYPE_DUP").setDisabled(false);
                EVF.C("PAY_TYPE_DUP").setRequired(true);
            }
		}
		
		// 계약보증 정보 및 서명여부의 지불담당자
		function onSearchPyUserNm(rowIdx) {
			
			var param = {
                'callBackFunction': 'callBackHD_PY_USER_NM',
                'READONLY'  : 'N',         	// 팝업 조회조건 변경불가
                'multiYN'   : 'N',         	// 멀티팝업여부
             	// 2021.09.08 : 지불담당자는 '정산담당자' 권한을 갖는 사람만 조회해야 함
                // 중앙회 허현과장 요청으로 해당 기능 제외
                //'CTRL_CD'   : 'BR080',		// 대금지급 담당자권한
                'rowIdx'    : rowIdx,
                'detailView': false
			};
			everPopup.openPopupByScreenId("CCDU0020", 1100, 700, param);
		}
		
		function callBackHD_PY_USER_NM(data) {

			data = JSON.parse(data);
			var PY_BUYER_DEPT_NM = data.CUST_NM + " " + data.DEPT_NM;

			var allRowId = gridECPC_HD.getAllRowId();
			var check = false;
			for(var i in allRowId) {
				var j = allRowId[i];
				if(PY_BUYER_DEPT_NM == gridECPC_HD.getCellValue(j, "PY_BUYER_DEPT_NM")) {
					check = true;
				}
			}

			if(check) {
				return EVF.alert("동일한 지불고객사가 있습니다.");
			}

			gridECPC_HD.setCellValue(data.rowIdx, "PY_BUYER_CD", data.CUST_CD);
			gridECPC_HD.setCellValue(data.rowIdx, "PY_BUYER_NM", data.CUST_NM);
			gridECPC_HD.setCellValue(data.rowIdx, "PY_DEPT_CD", data.DEPT_CD);
			gridECPC_HD.setCellValue(data.rowIdx, "PY_DEPT_NM", data.DEPT_NM);
			gridECPC_HD.setCellValue(data.rowIdx, "PY_USER_NM", data.USER_NM);
			gridECPC_HD.setCellValue(data.rowIdx, "PY_USER_ID", data.USER_ID);
			gridECPC_HD.setCellValue(data.rowIdx, "CEO_USER_NM", data.CEO_USER_NM);
			gridECPC_HD.setCellValue(data.rowIdx, "PY_BUYER_DEPT_NM", data.CUST_NM + " " + data.DEPT_NM);

			if((data.CUST_CD + data.DEPT_CD) == ("${ses.companyCd}" + "${ses.deptCd}")) {
				gridECPC_HD.setCellValue(data.rowIdx, "SIGN_FLAG", "1");
			} else {
				gridECPC_HD.setCellValue(data.rowIdx, "SIGN_FLAG", "0");
				gridECPC_HD.setCellReadOnly(data.rowIdx, "SIGN_FLAG", false);
			}

			if (gridECPC_HD.getCellValue(data.rowIdx, "SIGN_FLAG") == "0") {
				gridECPC_HD.setCellRequired(data.rowIdx, "CTRL_USER_NM", true);
			}

			ECPC_HD_COPY(gridECCM.getSelRowId()[0]);
		}
		
		// 고객사별 지불고객사 정보의 지불담당자
		function doSearchPY_BUYER_DEPT_NM(rowIdx) {
			
			var param = {
					'callBackFunction': 'callBackPY_BUYER_DEPT_NM',
	                'READONLY'  : 'N',         	// 팝업 조회조건 변경불가
	                'multiYN'   : 'N',         	// 멀티팝업여부
	                // 2021.09.08 : 지불담당자는 '정산담당자' 권한을 갖는 사람만 조회해야 함
	                // 중앙회 허현과장 요청으로 해당 기능 제외
	                //'CTRL_CD'   : 'BR080',		// 대금지급 담당자권한
	                'rowIdx'    : rowIdx,
	                'detailView': false
				};
			everPopup.openPopupByScreenId("CCDU0020", 1100, 700, param);
		}

		function callBackPY_BUYER_DEPT_NM(data) {

			data = JSON.parse(data);
			var PY_BUYER_DEPT_NM = data.CUST_NM + " " + data.DEPT_NM;

			var check = false;
			var allRowId = gridECPC.getAllRowId();
			for(var i in allRowId) {
				var j = allRowId[i];
				if(PY_BUYER_DEPT_NM == gridECPC.getCellValue(j, "PY_BUYER_DEPT_NM")) {
					check = true;
				}
			}

			if(check) {
				return EVF.alert("동일한 지불고객사가 있습니다.");
			}

			gridECPC.setCellValue(data.rowIdx, "PY_BUYER_CD", data.CUST_CD);
			gridECPC.setCellValue(data.rowIdx, "PY_BUYER_NM", data.CUST_NM);
			gridECPC.setCellValue(data.rowIdx, "PY_DEPT_CD", data.DEPT_CD);
			gridECPC.setCellValue(data.rowIdx, "PY_DEPT_NM", data.DEPT_NM);
			gridECPC.setCellValue(data.rowIdx, "PY_USER_NM", data.USER_NM);
			gridECPC.setCellValue(data.rowIdx, "PY_USER_ID", data.USER_ID);
			gridECPC.setCellValue(data.rowIdx, "PY_BUYER_DEPT_NM", data.CUST_NM + " " + data.DEPT_NM);
			gridECPC.setCellValue(data.rowIdx, "CORP_TYPE", data.CORP_TYPE);

			var idx = gridECPC.getCellValue(data.rowIdx, "PAY_CNT");
			if(gridECPC.getRowCount() > 1) {
				allRowId = gridECPC.getAllRowId();
				var str = "";
				for(i in allRowId) {
					j = allRowId[i];
					if(allRowId.length == ((i * 1) + 1)) {
						str += gridECPC.getCellValue(j, "PY_BUYER_DEPT_NM");
					}
					else {
						str += gridECPC.getCellValue(j, "PY_BUYER_DEPT_NM") + ", ";
					}
				}
				gridECPY.setCellValue(idx - 1, "PY_BUYER_NM", str);
			}
			else {
				gridECPY.setCellValue(idx - 1, "PY_BUYER_NM", data.CUST_NM + " " + data.DEPT_NM);
			}
			
			ECPC_COPY(idx - 1);
			ECPY_COPY(gridECCM.getSelRowId()[0]);
		}
		
		function setHdAttachFileNo(rowIdx, uuid, fileCount) {
			if(fileCount > 0) {
				gridECPC_HD.setCellValue(rowIdx, 'ATT_FILE_CNT', fileCount);
				gridECPC_HD.setCellValue(rowIdx, 'ATT_FILE_NUM', uuid);
			}
		}

		function setDiAttachFileNo(rowIdx, uuid, fileCount) {
			if(fileCount > 0) {
				gridECPC_HD.setCellValue(rowIdx, 'DI_ATT_FILE_CNT', fileCount);
				gridECPC_HD.setCellValue(rowIdx, 'DI_ATT_FILE_NUM', uuid);
			}
		}

		function setAttachFileNo(rowIdx, uuid, fileCount) {
			if(fileCount > 0) {
				gridECPC.setCellValue(rowIdx, 'ATT_FILE_CNT', fileCount);
				gridECPC.setCellValue(rowIdx, 'ATT_FILE_NUM', uuid);
			}
		}

		function setHDRmk(data) {
			if(!EVF.isEmpty(data.message)) {
				gridECPC_HD.setCellValue(data.rowIdx, 'RMK', data.message);
				ECPC_HD_COPY(gridECCM.getSelRowId()[0]);
			}else{
				gridECPC_HD.setCellValue(data.rowIdx, 'RMK', data.message);
				ECPC_HD_COPY(gridECCM.getSelRowId()[0]);
			}
		}
		
		//2021.03.22 고객사별 지불고객사 정보 비고 입력시 저장 오류 수정
		function setRmk(data) {
			if(!EVF.isEmpty(data.message)) {
				gridECPC.setCellValue(data.rowIdx, 'RMK', data.message);
				ECPC_COPY(data.idx);
				ECPY_COPY(gridECCM.getSelRowId()[0]);
			}
			else {
				gridECPC.setCellValue(data.rowIdx, 'RMK', data.message);
				ECPC_COPY(data.idx);
				ECPY_COPY(gridECCM.getSelRowId()[0]);
			}
		}

		function doApplyPayCnt() {

			if (gridECCM.getSelRowCount() == 0) { return EVF.alert("고객사를 선택하여 주시기 바랍니다."); }
			if (gridECCM.getSelRowCount() > 1) { return EVF.alert("고객사 정보를 "+ "${msg.M0006}"); }

			var PAY_CNT = EVF.V("PAY_CNT");
			if(EVF.V("PAY_TYPE_DUP") == "") {
				return EVF.alert("대금지급방식을 선택해주세요.");
			}else if( EVF.V("PAY_TYPE_DUP") == "LS" ) {
            	PAY_CNT = "1";
            }
			

			/*var selRowId = gridECPC_HD.getSelRowId()[0];
			var hdPayAmt = gridECPC_HD.getCellValue(selRowId, "PAY_AMT");
			if(hdPayAmt == "" || hdPayAmt == 0) {
				return EVF.alert("계약보증 정보의 지급금액을 입력하여 주시기 바랍니다.");
			}*/

			if(gridECPY.getRowCount() > 0) {
				EVF.confirm("입력하신 지불정보가 삭제 됩니다. 진행하시겠습니까?", function () {
					display(PAY_CNT);
				});
			} else {
				display(PAY_CNT);
			}
		}

		function onChangePurchaseType(rowIdx, purchase_type) {
			if(purchase_type == "S" || purchase_type == "M") {
				gridECMT.setCellReadOnly(rowIdx, "CONSUMER_AMT", true);
				gridECMT.setCellRequired(rowIdx, "CONSUMER_AMT", false);
				gridECMT.setCellReadOnly(rowIdx, "SW_BIZ_AMT", true);
				gridECMT.setCellRequired(rowIdx, "SW_BIZ_AMT", false);
			} else {
				gridECMT.setCellReadOnly(rowIdx, "CONSUMER_AMT", false);
				gridECMT.setCellRequired(rowIdx, "CONSUMER_AMT", true);
				gridECMT.setCellReadOnly(rowIdx, "SW_BIZ_AMT", true);
				gridECMT.setCellRequired(rowIdx, "SW_BIZ_AMT", false);
			}
		}

		function display(PAY_CNT) {
			gridECPY.delAllRow();
			gridECPC.delAllRow();

			var selRowValue = gridECCM.getSelRowValue()[0];
			var param;
			//2021.09.23 : 지급율 자동 계산시 소수점 2자리까지 계산
			//var percent = Math.floor(100 / PAY_CNT);
			//var lastPercent = percent + 100 - (PAY_CNT * percent);
			var percent = parseFloat((100 / PAY_CNT).toFixed(2));
			var lastPercent = parseFloat((percent + 100) - (PAY_CNT * percent));
			
			if(PAY_CNT == "1") {
				param = {
					PAY_CNT: "1",
					PAY_CNT_TYPE: "BP",     // 계약금:DP, 중도금:PP, 잔금:BP
					PAY_CNT_NM: "잔금",
					PR_BUYER_CD: selRowValue.PR_BUYER_CD,
					PR_DEPT_CD: selRowValue.PR_DEPT_CD,
					VENDOR_CD: selRowValue.VENDOR_CD,
					PAY_PERCENT: "100"
				};
				gridECPY.addRow(param);
			}
			else {
				for(var i = 1; i<=PAY_CNT; i++) {
					if(PAY_CNT == "2") {
						param = {
							PAY_CNT: i,
							PAY_CNT_TYPE: i==1?"DP":"BP",
							PAY_CNT_NM: i==1?"계약금":"잔금",
							PR_BUYER_CD: selRowValue.PR_BUYER_CD,
							PR_DEPT_CD: selRowValue.PR_DEPT_CD,
							VENDOR_CD: selRowValue.VENDOR_CD,
							PAY_PERCENT: "50"
						};
					} else {
						param = {
							PAY_CNT: i,
							PAY_CNT_TYPE: i==1?"DP":PAY_CNT > 1 && PAY_CNT != i ? "PP":"BP",
							PAY_CNT_NM: i==1?"계약금":PAY_CNT > 1 && PAY_CNT != i ? "중도금":"잔금",
							PR_BUYER_CD: selRowValue.PR_BUYER_CD,
							PR_DEPT_CD: selRowValue.PR_DEPT_CD,
							VENDOR_CD: selRowValue.VENDOR_CD,
							PAY_PERCENT: PAY_CNT == i ? lastPercent : percent
						};
					}
					gridECPY.addRow(param);
					gridECPY.setCurrent(0);
				}
			}
		}

		function ecpcHdGuarTypeDefaultSet(rowIdx) {
			/* var guarType2 = gridECPC_HD.getCellValue(rowIdx, "GUAR_TYPE2");
			if (guarType2 == "20") {
				gridECPC_HD.setCellReadOnly(rowIdx, "GUARANTEER", false);
			}
			else {
				gridECPC_HD.setCellValue(rowIdx, "GUARANTEER", "");
				gridECPC_HD.setCellReadOnly(rowIdx, "GUARANTEER", true);
			} */
			/** 2021.12.17 : 사용하지 않음으로 제외
			<c:if test="${param.detailView or editableStatus}">
				if ((gridECPC_HD.getCellValue(rowIdx, "PY_BUYER_CD") + gridECPC_HD.getCellValue(rowIdx, "PY_DEPT_CD")) != ("${ses.companyCd}" + "${ses.deptCd}")) {
					gridECPC_HD.setCellReadOnly(rowIdx, "SIGN_FLAG", false);
				}
			</c:if>*/
			gridECPC_HD.setCellReadOnly(rowIdx, "SIGN_FLAG", false);
			
			if(gridECPC_HD.getCellValue(rowIdx, "SIGN_FLAG") == "0") {
				gridECPC_HD.setCellRequired(rowIdx, "CTRL_USER_NM", true);
			}
		}

		function ecmtPurchaseTypeDefaultSet(rowIdx, value) {
			if(value == "G" || value == "C") {
				// 물품/공사
				gridECMT.setCellRequired(rowIdx, "CONSUMER_AMT", true);
				gridECMT.setCellReadOnly(rowIdx, "CONSUMER_AMT", false);
				gridECMT.setCellRequired(rowIdx, "FC_MNT_TERM", true);
				gridECMT.setCellRequired(rowIdx, "CH_RATE", true);

				gridECMT.setCellRequired(rowIdx, "SW_BIZ_AMT", false);
				gridECMT.setCellReadOnly(rowIdx, "SW_BIZ_AMT", true);
				gridECMT.setCellEdgeColor(rowIdx, "SW_BIZ_AMT", false);
				gridECMT.setCellRequired(rowIdx, "MNT_SANGJU_YN", false);
				gridECMT.setCellRequired(rowIdx, "DOIB_AMOUNT", false);
				gridECMT.setCellRequired(rowIdx, "MNT_RATE", false);
				gridECMT.setCellRequired(rowIdx, "MNT_SDAY", false);
				gridECMT.setCellRequired(rowIdx, "MNT_EDAY", false);
				gridECMT.setCellRequired(rowIdx, "MNT_GUR_MONTH", false);
				gridECMT.setCellRequired(rowIdx, "RT_INSP_PERIOD", false);
				gridECMT.setCellRequired(rowIdx, "FALT_RC_TG_TIME", false);
			} else if (value == "S") {
				// 용역
				gridECMT.setCellRequired(rowIdx, "SW_BIZ_AMT", true);
				gridECMT.setCellReadOnly(rowIdx, "SW_BIZ_AMT", false);
				gridECMT.setCellRequired(rowIdx, "MNT_SANGJU_YN", true);

				gridECMT.setCellRequired(rowIdx, "CONSUMER_AMT", true);
				gridECMT.setCellReadOnly(rowIdx, "CONSUMER_AMT", true);
				gridECMT.setCellEdgeColor(rowIdx, "CONSUMER_AMT", false);
				gridECMT.setCellRequired(rowIdx, "FC_MNT_TERM", false);
				gridECMT.setCellRequired(rowIdx, "CH_RATE", false);
				gridECMT.setCellRequired(rowIdx, "DOIB_AMOUNT", false);
				gridECMT.setCellRequired(rowIdx, "MNT_RATE", false);
				gridECMT.setCellRequired(rowIdx, "MNT_SDAY", false);
				gridECMT.setCellRequired(rowIdx, "MNT_EDAY", false);
				gridECMT.setCellRequired(rowIdx, "MNT_GUR_MONTH", false);
				gridECMT.setCellRequired(rowIdx, "RT_INSP_PERIOD", false);
				gridECMT.setCellRequired(rowIdx, "FALT_RC_TG_TIME", false);
			} else if (value == "M") {
				// 유지보수
				gridECMT.setCellRequired(rowIdx, "DOIB_AMOUNT", true);
				gridECMT.setCellRequired(rowIdx, "MNT_RATE", true);
				gridECMT.setCellRequired(rowIdx, "MNT_SDAY", true);
				gridECMT.setCellRequired(rowIdx, "MNT_EDAY", true);
				gridECMT.setCellRequired(rowIdx, "MNT_GUR_MONTH", true);
				gridECMT.setCellRequired(rowIdx, "RT_INSP_PERIOD", true);
				gridECMT.setCellRequired(rowIdx, "FALT_RC_TG_TIME", true);

				gridECMT.setCellRequired(rowIdx, "CONSUMER_AMT", true);
				gridECMT.setCellReadOnly(rowIdx, "CONSUMER_AMT", true);
				gridECMT.setCellEdgeColor(rowIdx, "CONSUMER_AMT", false);
				gridECMT.setCellRequired(rowIdx, "FC_MNT_TERM", false);
				gridECMT.setCellRequired(rowIdx, "CH_RATE", false);
				gridECMT.setCellRequired(rowIdx, "SW_BIZ_AMT", false);
				gridECMT.setCellReadOnly(rowIdx, "SW_BIZ_AMT", false);
				gridECMT.setCellRequired(rowIdx, "MNT_SANGJU_YN", false);
			} else if (value == "O") {
				// 도급
				gridECMT.setCellRequired(rowIdx, "MNT_SDAY", true);
				gridECMT.setCellRequired(rowIdx, "MNT_EDAY", true);
				gridECMT.setCellRequired(rowIdx, "MNT_GUR_MONTH", true);
				gridECMT.setCellRequired(rowIdx, "RT_INSP_PERIOD", true);
				gridECMT.setCellRequired(rowIdx, "FALT_RC_TG_TIME", true);

				gridECMT.setCellRequired(rowIdx, "DOIB_AMOUNT", false);
				gridECMT.setCellRequired(rowIdx, "MNT_RATE", false);
				gridECMT.setCellRequired(rowIdx, "CONSUMER_AMT", false);
				gridECMT.setCellReadOnly(rowIdx, "CONSUMER_AMT", false);
				gridECMT.setCellRequired(rowIdx, "FC_MNT_TERM", false);
				gridECMT.setCellRequired(rowIdx, "CH_RATE", false);
				gridECMT.setCellRequired(rowIdx, "SW_BIZ_AMT", false);
				gridECMT.setCellReadOnly(rowIdx, "SW_BIZ_AMT", true);
				gridECMT.setCellEdgeColor(rowIdx, "SW_BIZ_AMT", false);
				gridECMT.setCellRequired(rowIdx, "MNT_SANGJU_YN", false);
			} else {
				gridECMT.setCellRequired(rowIdx, "CONSUMER_AMT", false);
				gridECMT.setCellReadOnly(rowIdx, "CONSUMER_AMT", false);
				gridECMT.setCellRequired(rowIdx, "FC_MNT_TERM", false);
				gridECMT.setCellRequired(rowIdx, "CH_RATE", false);
				gridECMT.setCellRequired(rowIdx, "SW_BIZ_AMT", false);
				gridECMT.setCellReadOnly(rowIdx, "SW_BIZ_AMT", true);
				gridECMT.setCellEdgeColor(rowIdx, "SW_BIZ_AMT", false);
				gridECMT.setCellRequired(rowIdx, "MNT_SANGJU_YN", false);
				gridECMT.setCellRequired(rowIdx, "DOIB_AMOUNT", false);
				gridECMT.setCellRequired(rowIdx, "MNT_RATE", false);
				gridECMT.setCellRequired(rowIdx, "MNT_SDAY", false);
				gridECMT.setCellRequired(rowIdx, "MNT_EDAY", false);
				gridECMT.setCellRequired(rowIdx, "MNT_GUR_MONTH", false);
				gridECMT.setCellRequired(rowIdx, "RT_INSP_PERIOD", false);
				gridECMT.setCellRequired(rowIdx, "FALT_RC_TG_TIME", false);
			}
		}

		function ECPC_COPY(rowIdx) {
			var allRowValue = gridECPC.getAllRowValue();
			gridECPY._gdp.setValue(rowIdx, "PC_INFO", JSON.stringify(allRowValue));
		}

		function ECPY_COPY(rowIdx) {
			var allRowValue = gridECPY.getAllRowValue();
			gridECCM._gdp.setValue(rowIdx, "PY_INFO", JSON.stringify(allRowValue));
		}

		function ECPC_HD_COPY(rowIdx) {
			var allRowValue = gridECPC_HD.getAllRowValue();
			gridECCM._gdp.setValue(rowIdx, "PC_HD_INFO", JSON.stringify(allRowValue));
		}

		function callBackINSPECT_USER_ID(data) {

			data = JSON.parse(data);

			gridECMT.setCellValue(data.rowIdx, "IV_BUYER_CD", data.CUST_CD);
			gridECMT.setCellValue(data.rowIdx, "IV_DEPT_CD", data.DEPT_CD);
			gridECMT.setCellValue(data.rowIdx, "IV_BUYER_DEPT_NM", data.CUST_NM + " " + data.DEPT_NM);
			gridECMT.setCellValue(data.rowIdx, "IV_USER_ID", data.USER_ID);
			gridECMT.setCellValue(data.rowIdx, "IV_USER_NM", data.USER_NM);
			
			var selectedRow = gridECMT.getSelRowId();
			if (selectedRow.length > 1) {
				EVF.confirm('${SCMS0010_0035}', function() {
					for(var i in selectedRow) {
						gridECMT.setCellValue(selectedRow[i], "IV_BUYER_CD", data.CUST_CD);
						gridECMT.setCellValue(selectedRow[i], "IV_DEPT_CD", data.DEPT_CD);
						gridECMT.setCellValue(selectedRow[i], "IV_BUYER_DEPT_NM", data.CUST_NM + " " + data.DEPT_NM);
						gridECMT.setCellValue(selectedRow[i], "IV_USER_ID", data.USER_ID);
						gridECMT.setCellValue(selectedRow[i], "IV_USER_NM", data.USER_NM);
					}
				});
			}
		}

		function callBackMAKER_NM(data) {
			gridECMT.setCellValue(data.rowIdx, "MAKER_CD", data.MKBR_CD);
			gridECMT.setCellValue(data.rowIdx, "MAKER_NM", data.MKBR_NM);
		}

		function onChangeGuarPercent(rowIdx, grid) {
			var discount = (grid.getCellValue(rowIdx, "GUAR_AMT") / grid.getCellValue(rowIdx, "PAY_AMT")) * 100;
			grid.setCellValue(rowIdx, "GUAR_PERCENT", discount.toFixed(1));
		}

		function onChangeGuarAmt(rowIdx, grid) {
			var amt = (grid.getCellValue(rowIdx, "PAY_AMT") * grid.getCellValue(rowIdx, "GUAR_PERCENT")) / 100;
			grid.setCellValue(rowIdx, "GUAR_AMT", everMath.floor_float(amt.toFixed(0)));
		}
		
		function onChangeWarrGuarAmt (rowIdx, grid) {
			var amt = (EVF.V("CONT_AMT") * grid.getCellValue(rowIdx, "GUAR_PERCENT")) / 100;
			grid.setCellValue(rowIdx, "GUAR_AMT", everMath.floor_float(amt));
		}

		function onChangeDiscount(rowIdx, colIdx) {
			if (gridECMT.getCellValue(rowIdx, "ITEM_AMT") == 0) return;
			
			var prAmt     = Number(gridECMT.getCellValue(rowIdx, "ITEM_AMT"));
			var targetAmt = Number(gridECMT.getCellValue(rowIdx, colIdx));
			var discount  = 0
			if (targetAmt > 0) {
				discount = ((targetAmt - prAmt) / targetAmt) * 100;
			}
			gridECMT.setCellValue(rowIdx, colIdx.replace("AMT", "DISCOUNT"), Math.abs(discount.toFixed(1)));
		}

		function callBackBuyerDept(data) {
			
			data = JSON.parse(data);
			
			var prBuyerDeptNm = data.CUST_NM + " " + data.DEPT_NM;
			var allRowId = gridECCM.getAllRowId();
			for(var i in allRowId) {
				var rowIdx = allRowId[i];
				if( gridECCM.getCellValue(rowIdx, "PR_BUYER_DEPT_NM") == prBuyerDeptNm ) {
					return EVF.alert("동일한 고객사가 존재합니다.\n확인하여 주시기 바랍니다.");
				}
			}
			
			gridECCM.setCellValue(data.rowIdx, "PR_BUYER_CD", data.CUST_CD);
			gridECCM.setCellValue(data.rowIdx, "PR_BUYER_NM", data.CUST_NM);
			gridECCM.setCellValue(data.rowIdx, "PR_DEPT_CD", data.DEPT_CD);
			gridECCM.setCellValue(data.rowIdx, "PR_DEPT_NM", data.DEPT_NM);
			gridECCM.setCellValue(data.rowIdx, "PR_BUYER_DEPT_NM", prBuyerDeptNm);
			
			// 최초 품목정보 입력 시 체크 로직 제외하기 위해 선언
			ecmtFlag = true;
			
			doItemSearch();
		}

		function onchangeQtPrc(rowIdx) {
			
			var item_amt = gridECMT.getCellValue(rowIdx, "ITEM_QT") * gridECMT.getCellValue(rowIdx, "ITEM_PRC");
			gridECMT.setCellValue(rowIdx, "ITEM_AMT", everMath.floor_float(item_amt.toFixed(0)));
			
			// copyFlag = true : 구매의뢰접수현황의 "연장계약작성", 계약대기현황의 "전자계약작성"
			// 변경, 연장계약인 경우 품목금액 변경시 고객사별 계약금액이 변경됨
			var item_amt_sum = 0;
			if( "${form.copyFlag}" != "true" || ("${form.copyFlag}" == "true" && (EVF.V("CONT_REQ_CD") == '20' || EVF.V("CONT_REQ_CD") == '30')) ) {
				var allRowIdECMT = gridECMT.getAllRowId();
				for(var i in allRowIdECMT) {
					if (gridECMT.getCellValue(i, "PR_BUYER_CD") == gridECMT.getCellValue(rowIdx, "PR_BUYER_CD") &&
						gridECMT.getCellValue(i, "PR_DEPT_CD")  == gridECMT.getCellValue(rowIdx, "PR_DEPT_CD")) {
						item_amt_sum += gridECMT.getCellValue(i, "ITEM_AMT");
					}
				}
				
				var allRowIdECCM = gridECCM.getAllRowId();
				for(var i in allRowIdECCM) {
					if (gridECCM.getCellValue(i, "PR_BUYER_CD") == gridECMT.getCellValue(rowIdx, "PR_BUYER_CD") &&
						gridECCM.getCellValue(i, "PR_DEPT_CD")  == gridECMT.getCellValue(rowIdx, "PR_DEPT_CD")) {
						gridECCM.setCellValue(i, "CONT_AMT", item_amt_sum);
					}
				}
				
				EVF.V("CONT_AMT_DUP", item_amt_sum);
				contAmtSum();
			}
		}
		
		// STOCECCT의 계약금액 변경
		function contAmtSum() {
			if (gridECCM.getRowCount() > 0) {
				EVF.V("CONT_AMT", gridECCM._gvo.getSummary("CONT_AMT", "sum"));
			} else {
				EVF.V("CONT_AMT", "0");
			}
		}
		
		function onIconClickVENDOR_CD() {
			
			var param = {
				callBackFunction: "callBackVENDOR_CD"
			};
			//2020.12.14 : 중앙회 요청으로 협력업체 선택 시 협력업체 담당자명, 이메일, 연락처 자동 셋팅되도록 변경
			//everPopup.openCommonPopup(param, "SP0123");
			everPopup.openCommonPopup(param, "MP0019");
		}
		
		function callBackVENDOR_CD(data) {
			for(var idx in data) {
				if(idx > 0) {
					return EVF.alert("담당자는 한명만 선택해 주십시오"); 
				}
			}
			
			EVF.V("VENDOR_CD", data[idx].VENDOR_CD);
			EVF.V("VENDOR_NM", data[idx].VENDOR_NM);
			//2023.02.03 계약담당자가 계약서 작성 시 "협력업체 담당자", "협력업체 담당자 이메일", "협력업체 담당자 전화번호"를 직접 입력 하도록 변경
			//EVF.V("VENDOR_PIC_USER_NM", data[idx].VENDOR_PIC_USER_NM);
			//EVF.V("VENDOR_PIC_USER_EMAIL", data[idx].VENDOR_PIC_USER_EMAIL);
			//EVF.V("VENDOR_PIC_USER_CELL_NUM", data[idx].VENDOR_PIC_USER_CELL_NUM);
		}
		
		//2021.06.23 선택한 협력업체의 담당자 조회 및 선택한 담당자명, 이메일, 연락처 셋팅 할수있도록  text => search로 변경
		function onIconClickVENDOR_PIC_USER_NM() {

			var vendorCd = EVF.C('VENDOR_CD').getValue();
			if( EVF.isEmpty(vendorCd) ) {
				return EVF.alert("협력업체를 우선 선택해 주십시오.");
			}

			var param = {
				callBackFunction : 'callBackVENDOR_PIC_USER_NM'
				, vendorCd : vendorCd
			};
			everPopup.openCommonPopup(param, 'SP0028');
		}
		
		function callBackVENDOR_PIC_USER_NM(data) {
			
			EVF.V("VENDOR_PIC_USER_NM", data.VENDOR_PIC_USER_NM);
			EVF.V("VENDOR_PIC_USER_EMAIL", data.VENDOR_PIC_USER_EMAIL);
			EVF.V("VENDOR_PIC_USER_CELL_NUM", data.VENDOR_PIC_USER_CELL_NUM);
		}
		
		function doSearchECCM() {
			var store = new EVF.Store();
			store.setGrid([gridECCM]);
			store.load(baseUrl + '/SCMS0010_doSearchECCM.so', function() {
				
				// 신규(10), 변경(20) 계약 => 선정품의 품목 가져오기
				// 연장(30) 계약 => 구매의뢰 품목 가져오기
				// 품목별 금액 합산액을 계약 고객사에 SUM하기 위해서...
				if( "${form.copyFlag}" == "true" ) {
					doSearchCNDT();
				}
				
				// 구매유형에 따른 품목정보 기본 필수 셋팅
				var ecmtIdx = gridECMT.getAllRowId();
				for(var j in ecmtIdx) {
					ecmtPurchaseTypeDefaultSet(ecmtIdx[j], gridECMT.getCellValue(ecmtIdx[j], "PURCHASE_TYPE"));
				}
				
				gridECPC_HD.delAllRow();
				if(gridECCM.getRowCount() > 0) {
					var PC_HD_INFO  = gridECCM.getCellValue(0, "PC_HD_INFO");
					// 2021.12.17 : IT포탈 변경계약서 작성시 "대금지불정보, 지불정보, 고객사별 지불고객사 정보"의 협력사를 "견적/입찰" 선정 협력사로 변경
					var curVendorCd = "";
					if( "${form.copyFlag}" == "true" && EVF.V("CONT_REQ_CD") == '20' ) {
						curVendorCd = EVF.V("VENDOR_CD");
					}
					
					if( PC_HD_INFO != "" && PC_HD_INFO != null ) {
						//21.01.19 realgrid update시 배열 data addRow시 오류로 인해 for문 사용으로 변경
						var parseEcpcHdInfo = JSON.parse(PC_HD_INFO);
					    for(var j in parseEcpcHdInfo) {
					    	gridECPC_HD.addRow(parseEcpcHdInfo[j]);
							EVF.V("GUAR_AMT", gridECPC_HD._gvo.getSummary("DI_GUAR_AMT", "sum"), false);
					    }
						// 2021.12.17 : IT포탈 변경계약서 작성시 "대금지불정보, 지불정보, 고객사별 지불고객사 정보"의 협력사를 "견적/입찰" 선정 협력사로 변경
					    if(gridECPC_HD.getRowCount() > 0) {
							var idx = gridECPC_HD.getAllRowId();
							for(var i in idx) {
								ecpcHdGuarTypeDefaultSet(idx[i]);
								if( !EVF.isEmpty(curVendorCd) ) {
									gridECPC_HD.setCellValue(idx[i], "VENDOR_CD", curVendorCd);
								}
							}
						}
					}
					
					gridECPY.delAllRow();
					var PY_INFO = gridECCM.getCellValue(0, "PY_INFO");
					if( PY_INFO != "" && PY_INFO != null ) {
						//21.01.19 realgrid update시 배열 data addRow시 오류로 인해 for문 사용으로 변경
						var parseEcpyInfo = JSON.parse(PY_INFO);
					    for(var j in parseEcpyInfo) {
					    	gridECPY.addRow(parseEcpyInfo[j]);
					    }
						// 2021.12.17 : IT포탈 변경계약서 작성시 "대금지불정보, 지불정보, 고객사별 지불고객사 정보"의 협력사를 "견적/입찰" 선정 협력사로 변경
					    if( !EVF.isEmpty(curVendorCd) && gridECPY.getRowCount() > 0 ) {
							var idx = gridECPY.getAllRowId();
							for(var i in idx) {
								gridECPY.setCellValue(idx[i], "VENDOR_CD", curVendorCd);
							}
						}
					}
					
					gridECPC.delAllRow();
					var PC_INFO = gridECPY.getCellValue(gridECPY._gvo.getCurrent().dataRow, "PC_INFO");
					if( PC_INFO != "" && PC_INFO != null ) {
						//21.01.19 realgrid update시 배열 data addRow시 오류로 인해 for문 사용으로 변경
						var parseEcpcInfo = JSON.parse(PC_INFO);
						for(var j in parseEcpcInfo) {
							gridECPC.addRow(parseEcpcInfo[j]);
					    }
						// 2021.12.17 : IT포탈 변경계약서 작성시 "대금지불정보, 지불정보, 고객사별 지불고객사 정보"의 협력사를 "견적/입찰" 선정 협력사로 변경
						if( !EVF.isEmpty(curVendorCd) && gridECPC.getRowCount() > 0 ) {
							var idx = gridECPC.getAllRowId();
							for(var i in idx) {
								gridECPC.setCellValue(idx[i], "VENDOR_CD", curVendorCd);
							}
						}
					}
					gridECPC_HD.setColIconify("RMK", "RMK", "detail", true);
					gridECPC.setColIconify("RMK", "RMK", "detail", true);
					
					// 금액구분(총액, 단가)에 따른 ECCM의 발주생성여부 자동 세팅
					onChangeAmtType(true);
				}
				
				// 계약 고객사가 존재하는 경우 첫번째 고객사 정보 선택하고 세팅함
				if( "${form.copyFlag}" != "true" && gridECCM.getRowCount() > 0) {
					setCallBackECCM();
				}
				
				// 4230 : 협력사 서명완료
				if( !detailView && EVF.V("PROGRESS_CD") == "4230" ) {
					if ("${ses.ctrlCd}".indexOf("BR050") > -1) { // BR050 : 고객사_계약체결자 권한
						var buyerCd = EVF.V("BUYER_CD");
						var deptCd  = EVF.V("DEPT_CD");
						var sFlag   = false;
						var allRowIdx = gridECCM.getAllRowId();
						for(var i in allRowIdx) {
							var rowIdx   = allRowIdx[i];
							var pcHdInfo = JSON.parse(gridECCM.getCellValue(rowIdx, "PC_HD_INFO"));
							for(var j in pcHdInfo) {
								var pcVal = pcHdInfo[j];
								var ecpcPyBuyerCd = pcVal.PY_BUYER_CD;
								var ecpcPyDeptCd  = pcVal.PY_DEPT_CD;
								
								if(pcVal.SIGN_ID != "unsigned") {
									continue;
								}
								
								// sign_flag=지불고객사별 전자서명여부
								if( (pcVal.SIGN_FLAG == "1" && ecpcPyBuyerCd == "${ses.companyCd}" && ecpcPyDeptCd == "${ses.deptCd}")
								 || (pcVal.SIGN_FLAG == "0" && buyerCd       == "${ses.companyCd}" && deptCd       == "${ses.deptCd}") ) {
									sFlag = true;
									break;
								} else {
									sFlag = false;
								}
								if(sFlag) {
									break;
								}
							}
						}
						if(sFlag) {
							EVF.C("doSign").setDisabled(false);		// 계약체결완료
							EVF.C("doReSend").setDisabled(false);	// 협력사재전송
						} else {
							EVF.C("doSign").setDisabled(true);		// 계약체결완료
							EVF.C("doReSend").setDisabled(true);	// 협력사재전송
						}
					} else {
						EVF.C("doSign").setVisible(false);		// 계약체결완료
						EVF.C("doReSend").setVisible(false);	// 협력사재전송
					}
				}
			}, false);
		}
		
		// 계약고객사(STOCECCM)의 첫번째 Row 체크하기
		function setCallBackECCM() {
			gridECCM.checkRow(0, true, false, false);
			
			EVF.V("PAY_TYPE_DUP", gridECCM.getCellValue(0, "METHOD_TYPE"), false);
			EVF.V("BUYER_DEPT_NM", gridECCM.getCellValue(0, "PR_BUYER_DEPT_NM"), false);
			EVF.V("CONT_AMT_DUP", gridECCM.getCellValue(0, "CONT_AMT"), false);
			EVF.V("PAY_CNT", gridECCM.getCellValue(0, "PAY_CNT"), false);
		}

		function doSearchECMT() {
			var store = new EVF.Store();
			store.setGrid([gridECMT]);
			store.load(baseUrl + '/SCMS0010_doSearchECMT.so', function() {
				if(EVF.V("reCont") == "true") {
					eformScheduler(EVF.V("CONT_NUM"), EVF.V("CONT_CNT"), "S");
				}
				
				var allRowId = gridECMT.getAllRowId();
				for(var i in allRowId) {
					var rowIdx = allRowId[i];
					var purchase_type = gridECMT.getCellValue(rowIdx, "PURCHASE_TYPE");
					
					// 2021.05.25 변경 : 구매유형에 따른 필수값 체크하기
					//onChangePurchaseType(rowIdx, purchase_type);
					ecmtPurchaseTypeDefaultSet(rowIdx, purchase_type);
					
					if(purchase_type == "S" || purchase_type == "M") {
						onChangeDiscount(rowIdx, "SW_BIZ_AMT");
					} else {
						onChangeDiscount(rowIdx, "CONSUMER_AMT");
					}
				}
			}, false);
		}

		<%-- 계약서 주서식 변경 시 계약서 기본정보의 폼을 자동셋팅하는 함수 --%>
		function setForm(rowId) {

			if(rowId === undefined) {
				rowId = 0;
			}

			var contNum = EVF.V("CONT_NUM"); // 계약번호
			var autoRenewFlag = ""; // 자동갱신여부
			if( contNum == "" ){
				<%-- 전자서명 여부 --%>
				var econtFlag = gridM.getCellValue(rowId, 'ECONT_FLAG');
				EVF.V('MANUAL_CONT_FLAG', (econtFlag === '1' ? "0" : "1"));
				<%-- 서식작성시 기안의견 --%>
				EVF.V('APPROVAL_OPINION', gridM.getCellValue(rowId, 'APPROVAL_OPINION'));
			}
		}

		<%-- 계약서 진행상태에 따라 버튼의 노출 처리 --%>
		<%-- 버튼은 기본적으로 hidden 처리되어 있으며, 계약서 진행상태에 따라 노출시킨다. --%>
		function setButtons() {

			if( ${not param.detailView eq 'true'} ){
				EVF.C('doSave').setVisible(false); 			// 임시저장
				EVF.C('doDelete').setVisible(false); 		// 삭제
				EVF.C('doSend').setVisible(false); 			// 결재상신
				
			<c:if test="${editableStatus}">
				EVF.C('doSave').setVisible(true); 			// 저장
				EVF.C('doSend').setVisible(true); 			// 결재상신
				
				<c:if test="${not empty form.CONT_NUM}">
					EVF.C('doDelete').setVisible(true); 	// 삭제
				</c:if>
			</c:if>
			}
			else {
				EVF.C('doItemSearch').setVisible(false); 	// 폼목선택
				EVF.C('doItemDelete').setVisible(false); 	// 품목삭제
				EVF.C('doApplyPayCnt').setVisible(false); 	// 적용
			}
		}

		<%-- 주계약서 서식을 조회하여 그리드에 조회한다 --%>
		function doSearchForm() {
			var store = new EVF.Store();
			store.setParameter("BASIC_SEARCH", $('#BASIC_SEARCH').val());
			store.setGrid([ gridM ]);
			store.load(baseUrl + '/SCMS0010_doSearchMainForm.so', function() {
				if (gridM.getRowCount() == 1) {
					//2023.02.21 계약서 작성 화면 오픈 시 default로 서식이 선택 되어있으면 잘못된 서식으로 계약서 작성하는 실수 방지를 위해 default 선택 안하도록 변경
					gridM.checkRow(0, true, true, false);
					setForm(0); // 주계약서 서식 세팅
				} else {
					gridM.checkRow(0, false, true, false);
				}
				
				doSearchSubForms();
				setButtons();
			}, false);
		}

		<%-- 부서식을 조회하여 그리드에 보여준다 --%>
		function doSearchSubForms() {
			if(gridM.isExistsSelRow()) {
				var store = new EVF.Store();
				store.setParameter('ADD_SEARCH', $('#ADD_SEARCH').val());
				store.setParameter('selectedFormNum', gridM.getSelRowValue()[0].FORM_NUM);
				store.setGrid([ gridA ]);
				store.load(baseUrl + '/SCMS0010_doSearchAdditionalForm.so', function() {
					var rowIds = gridA.getAllRowId();
					if(EVF.V("CONT_NUM") == "") {
						// 부서식의 기본선택여부 및 필수여부인 경우 체크를 해준다.
						for(var i in rowIds) {
							if (gridA.getCellValue(rowIds[i], "DEFAULT_FLAG") == "1" || gridA.getCellValue(rowIds[i], "REQUIRE_FLAG") == "1") {
								gridA.checkRow(rowIds[i], true, false, false);
							}
						}
					} else {
						// 부서식이 필수여부인 경우 체크를 해준다.
						for(var i in rowIds) {
							if (gridA.getCellValue(rowIds[i], "EXISTS_FLAG") == "1") {
								gridA.checkRow(rowIds[i], true, false, false);
							}
						}
					}
				}, false);
			}
		}

		function checkAmtValidation() {
			var validResult = true;

			// 고객사별 지불고객사 정보의 sum 값과 지불정보 일치 여부 확인
			var allRowIdECCM = gridECCM.getAllRowId();
			var pcFiveContAmtSum = 0, mtFiveContAmtSum = 0;
			var pcOneContAmtSum = 0, mtOneContAmtSum = 0;
			var pcAContAmtSum = 0, mtAContAmtSum = 0;
			var pcTwoContAmtSum = 0, mtTwoContAmtSum = 0;
			var pcThreeContAmtSum = 0, mtThreeContAmtSum = 0;

			for(var i in allRowIdECCM) {
				var buyerDeptNm = gridECCM.getCellValue(allRowIdECCM[i], "PR_BUYER_DEPT_NM");
				var eccmContAmt = gridECCM.getCellValue(allRowIdECCM[i], "CONT_AMT");
				
				// 고객사 계약금액과 계약보증 정보의 지급금액이 동일한지 체크
				if (gridECCM.getCellValue(allRowIdECCM[i], "PC_HD_INFO") == "") {
					return EVF.alert(buyerDeptNm + " 계약보증 정보를 입력하여 주시기 바랍니다.");
				}

				// 고객사 계약금액과 계약보증 정보의 지급금액 합이 동일한지 체크
				if (gridECCM.getCellValue(allRowIdECCM[i], "PY_INFO") == "") {
					return EVF.alert(buyerDeptNm + " 지불정보를 입력하여 주시기 바랍니다.");
				}

				var pcHdInfoList = JSON.parse(gridECCM.getCellValue(allRowIdECCM[i], "PC_HD_INFO"));
				var pyInfoList   = JSON.parse(gridECCM.getCellValue(allRowIdECCM[i], "PY_INFO"));
				var pcHdGridAmtSum = 0;
				for(var c in pcHdInfoList) {
					var pcHdGridInfo = pcHdInfoList[c];
					pcHdGridAmtSum += pcHdGridInfo.PAY_AMT;
				}

				if (eccmContAmt != pcHdGridAmtSum) {
					validResult = false;
					return EVF.alert(buyerDeptNm + "고객사 계약금액과 계약보증 정보의 지급금액 합이 일치하지 않습니다.\n확인하여 주시기 바랍니다.");
				}

				var pyGridAmtSum = 0;
				for(var j in pyInfoList) {
					var pyGridInfo = pyInfoList[j];
					pyGridAmtSum += pyGridInfo.PAY_AMT;

					if(pyGridInfo.PC_INFO == "") {
						return EVF.alert(buyerDeptNm + " 고객사별 지불고객사 정보를 입력하여 주시기 바랍니다.");
					}

					var pcGridList = JSON.parse(pyGridInfo.PC_INFO);
					var pcGridAmtSum = 0;

					for(var l in pcGridList) {
						var pcGridInfo = pcGridList[l];
						pcGridAmtSum += pcGridInfo.PAY_AMT;

						if (pcGridInfo.CORP_TYPE == "5") {				// 중앙회
							pcFiveContAmtSum += pcGridInfo.PAY_AMT;
						} else if (pcGridInfo.CORP_TYPE == "1") {		// 은행
							pcOneContAmtSum += pcGridInfo.PAY_AMT;
						} else if (pcGridInfo.CORP_TYPE == "A") {		// 금융지주
							pcAContAmtSum += pcGridInfo.PAY_AMT;
						} else if (pcGridInfo.CORP_TYPE == "2") {		// 지역농축협
							pcTwoContAmtSum += pcGridInfo.PAY_AMT;
						} else {		// 나머지는 모두다 기타(2020.09.14) : 계열사(3), 경제지주(B), 생명(C), 손해(D)
							pcThreeContAmtSum += pcGridInfo.PAY_AMT;
						}
					}

					if(pyGridInfo.PAY_AMT != pcGridAmtSum) {
						validResult = false;
						return EVF.alert(buyerDeptNm + " 지불정보의 지급예정금액과 고객사별 지불고객사 정보의 합이 일치하지 않습니다.\n확인하여 주시기 바랍니다.");
					}
				}
				/** 2021.10.20
				// 계약보증정보의 지불고객사별 지불금액과 고객사별 지불고객사의 지급금액 합계 체크
				// 2021.10.29 : 박기현 책임 = 중앙회에서 지불고객사별 지불금에 대한 차수별 지불고객사가 다른 경우 있음 => 주석처리
				for(var d in pcHdInfoList) {
					var pcHdGridInfo = pcHdInfoList[d];
					var pcHdGridAmt  = pcHdGridInfo.PAY_AMT;
					
					var pcGridAmtSum = 0;
					for(var e in pyInfoList) {
						var pyGridInfo = pyInfoList[e];
						var pcGridList = JSON.parse(pyGridInfo.PC_INFO);
						for(var l in pcGridList) {
							var pcGridInfo = pcGridList[l];
							if(pcHdGridInfo.PY_BUYER_CD == pcGridInfo.PY_BUYER_CD && pcHdGridInfo.PY_DEPT_CD == pcGridInfo.PY_DEPT_CD) {
								pcGridAmtSum += pcGridInfo.PAY_AMT;
							}
						}
					}
					if (pcHdGridAmt != pcGridAmtSum) {
						validResult = false;
						return EVF.alert(buyerDeptNm + " 계약보증 정보의 지불고객사별 지급금액과 지불고객사 정보의 지불고객사 지급금액의 합이 일치하지 않습니다.\n확인하여 주시기 바랍니다.");
					}
				}*/
				
				if (eccmContAmt != pyGridAmtSum) {
					validResult = false;
					return EVF.alert(buyerDeptNm + " 고객사 계약금액과 지불정보의 지급예정금액의 합이 일치하지 않습니다.\n확인하여 주시기 바랍니다.");
				}
			}
			
			// 구매의뢰(PR), 계약대기(선정품의 기준) 현황에서 넘어 온 경우 품목정보의 금액과 고객사의 금액을 비교한다.
			if ("${form.copyFlag}" == "true") {
				for(var i in gridECCM.getSelRowValue()) {
					var eccmRowValue = gridECCM.getSelRowValue()[i];
					var ecmtItemAmtSum = 0;

					for(var j in gridECMT.getAllRowValue()) {
						var ecmtRowValue = gridECMT.getAllRowValue()[j];

						if(eccmRowValue.PR_BUYER_CD == ecmtRowValue.PR_BUYER_CD &&
							eccmRowValue.PR_DEPT_CD == ecmtRowValue.PR_DEPT_CD) {
							ecmtItemAmtSum += ecmtRowValue.ITEM_AMT;
						}
					}

					if (eccmRowValue.CONT_AMT != ecmtItemAmtSum) {
						return EVF.alert("품목정보의 금액과 고객사 계약금액의 값이 일치하지 않습니다.");
					}
				}

				if ("${form.IF_TYPE}" == "IT") {
					for (var i in gridECMT.getAllRowValue()) {
						var rowValue = gridECMT.getAllRowValue()[i];
						var corp_cont_sum = 0;
						// 품목의 IF_TYPE이 'IT'일 경우 각각의 값 중 하나에는 값이 필히 있어야 한다.
						if (rowValue["5_CONT_AMT"] == "" && rowValue["1_CONT_AMT"] == "" &&
							rowValue["A_CONT_AMT"] == "" && rowValue["2_CONT_AMT"] == "" &&
							rowValue["3_CONT_AMT"] == "") {
							return EVF.alert("품목정보의 중앙회, 은행, 금융지주, 지역농축협, 기타의\n값 중 하나는 필수로 입력하여 주시기 바랍니다.");
						} else {
							corp_cont_sum = Number(rowValue["5_CONT_AMT"]) + Number(rowValue["1_CONT_AMT"]) + Number(rowValue["A_CONT_AMT"]) + Number(rowValue["2_CONT_AMT"]) + Number(rowValue["3_CONT_AMT"]);
							mtFiveContAmtSum += Number(rowValue["5_CONT_AMT"]);
							mtOneContAmtSum += Number(rowValue["1_CONT_AMT"]);
							mtAContAmtSum += Number(rowValue["A_CONT_AMT"]);
							mtTwoContAmtSum += Number(rowValue["2_CONT_AMT"]);
							mtThreeContAmtSum += Number(rowValue["3_CONT_AMT"]);
						}

						// 각각의 금액 합 = 금액과 동일해야 함
						if (rowValue.ITEM_AMT != corp_cont_sum) {
							return EVF.alert("품목정보의 금액과 중앙회, 은행, 금융지주, 지역농축협, 기타의 합의 값이 일치하지 않습니다.");
						}
					}

					if (mtFiveContAmtSum != pcFiveContAmtSum) {
						return EVF.alert("품목정보의 [중앙회]의 합과 고객사별 지불고객사 정보의 지금금액의 합이 일치하지 않습니다.");
					} else if (mtOneContAmtSum != pcOneContAmtSum) {
						return EVF.alert("품목정보의 [은행]의 합과 고객사별 지불고객사 정보의 지금금액의 합이 일치하지 않습니다.");
					} else if (mtAContAmtSum != pcAContAmtSum) {
						return EVF.alert("품목정보의 [금융지주]의 합과 고객사별 지불고객사 정보의 지금금액의 합이 일치하지 않습니다.");
					} else if (mtTwoContAmtSum != pcTwoContAmtSum) {
						return EVF.alert("품목정보의 [지역농축협]의 합과 고객사별 지불고객사 정보의 지금금액의 합이 일치하지 않습니다.");
					} else if (mtThreeContAmtSum != pcThreeContAmtSum) {
						return EVF.alert("품목정보의 [기타]의 합과 고객사별 지불고객사 정보의 지금금액의 합이 일치하지 않습니다.");
					}
				}
				
			} else {
				
				if ("${form.IF_TYPE}" == "IT") {
					for (var i in gridECMT.getAllRowValue()) {
						var rowValue = gridECMT.getAllRowValue()[i];
						var corp_cont_sum = 0;
						// 품목의 IF_TYPE이 'IT'일 경우 각각의 값 중 하나에는 값이 필히 있어야 한다.
						if (rowValue["5_CONT_AMT"] == "" && rowValue["1_CONT_AMT"] == "" &&
							rowValue["A_CONT_AMT"] == "" && rowValue["2_CONT_AMT"] == "" &&
							rowValue["3_CONT_AMT"] == "") {
							return EVF.alert("품목정보의 중앙회, 은행, 금융지주, 지역농축협, 기타의\n값 중 하나는 필수로 입력하여 주시기 바랍니다.");
						} else {
							corp_cont_sum = Number(rowValue["5_CONT_AMT"]) + Number(rowValue["1_CONT_AMT"]) + Number(rowValue["A_CONT_AMT"]) + Number(rowValue["2_CONT_AMT"]) + Number(rowValue["3_CONT_AMT"]);
							mtFiveContAmtSum += Number(rowValue["5_CONT_AMT"]);
							mtOneContAmtSum += Number(rowValue["1_CONT_AMT"]);
							mtAContAmtSum += Number(rowValue["A_CONT_AMT"]);
							mtTwoContAmtSum += Number(rowValue["2_CONT_AMT"]);
							mtThreeContAmtSum += Number(rowValue["3_CONT_AMT"]);
						}

						// 각각의 금액 합 = 금액과 동일해야 함
						if (rowValue.ITEM_AMT != corp_cont_sum) {
							return EVF.alert("품목정보의 금액과 중앙회, 은행, 금융지주, 지역농축협, 기타의 합의 값이 일치하지 않습니다.");
						}
					}
					if (mtFiveContAmtSum != pcFiveContAmtSum) {
						return EVF.alert("품목정보의 [중앙회]의 합과 고객사별 지불고객사 정보의 지금금액의 합이 일치하지 않습니다.");
					} else if (mtOneContAmtSum != pcOneContAmtSum) {
						return EVF.alert("품목정보의 [은행]의 합과 고객사별 지불고객사 정보의 지금금액의 합이 일치하지 않습니다.");
					} else if (mtAContAmtSum != pcAContAmtSum) {
						return EVF.alert("품목정보의 [금융지주]의 합과 고객사별 지불고객사 정보의 지금금액의 합이 일치하지 않습니다.");
					} else if (mtTwoContAmtSum != pcTwoContAmtSum) {
						return EVF.alert("품목정보의 [지역농축협]의 합과 고객사별 지불고객사 정보의 지금금액의 합이 일치하지 않습니다.");
					} else if (mtThreeContAmtSum != pcThreeContAmtSum) {
						return EVF.alert("품목정보의 [기타]의 합과 고객사별 지불고객사 정보의 지금금액의 합이 일치하지 않습니다.");
					}
				}
			}

			return validResult;
		}

		<%-- 저장을 하기 전에 입력되지 않은 폼이 있는지 확인해주는 체크함수 --%>
		function checkFormValidation() {

			var store = new EVF.Store();
			if(!store.validate()) {
				return false;
			}

			if(!gridM.isExistsSelRow()) {
				return EVF.alert('계약서 서식을 선택하셔야 합니다.');
			}

			var phoneCheck    = /^(?:(010-\d{4})|(01[1|6|7|8|9]-\d{3,4}))(-\d{4})$/;
			var phoneCheckAdd = /^(?:(010\d{4})|(01[1|6|7|8|9]\d{3,4}))(\d{4})$/;
			var normalCallCheck = /^\d{2,3}-\d{3,4}-\d{4}$/; //일반 전화번호 정규식 추가요청 - 201112 IT 통합구매팀 유희철과장
			var normalCallCheck2 = /^\d{9,11}$/; //일반 전화번호 정규식 추가요청 - 201112 IT 통합구매팀 유희철과장
			var emailCheck    = /^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$/i;

			// 협력사 담당자 이메일/헨드폰중에 한개는 필수
			var phone = EVF.V("VENDOR_PIC_USER_CELL_NUM");
			var email = EVF.V("VENDOR_PIC_USER_EMAIL");
			if( EVF.isEmpty(phone) && EVF.isEmpty(email) ) {
				return EVF.alert("협력사담당자 정보(EMAIL, 휴대전화)중에 한개는 입력해야 합니다.");
			}
			if( !EVF.isEmpty(phone) && (!phoneCheck.test(phone) && !phoneCheckAdd.test(phone) && !normalCallCheck.test(phone) && !normalCallCheck2.test(phone) ) ){
				return EVF.alert("협력사 담당자의 전화번호 형식이 올바르지 않습니다.");
			}
			if( !EVF.isEmpty(email) && !emailCheck.test(email) ){
				return EVF.alert("협력사 담당자의 이메일(E-Mail) 주소 형식이 올바르지 않습니다.");
			}

			var subFormGridRowId = gridA.getAllRowId();
			for(var i in subFormGridRowId) {
				var rowId = subFormGridRowId[i];
				if(gridA.getCellValue(rowId, 'REQUIRE_FLAG') === '1' && !gridA.isChecked(rowId)) {
					return EVF.alert('['+gridA.getCellValue(rowId, 'REL_FORM_NM')+'] 추가서식은 반드시 선택하셔야 합니다.');
				}
			}

			<c:if test="${editableStatus}">
				for(var id in shouldConfirmSubFormNum) {
					if(shouldConfirmSubFormNum[id] === true) {
						return EVF.alert("확인되지 않은 추가서식이 있습니다.\n추가서식을 모두 확인해주시고 '확인' 버튼을 눌러주세요.");
					}
				}
			</c:if>
			
			return true;
		}

		<%-- 계약서를 임시저장 상태로 저장한다 --%>
		function doSave() {

			if (!checkAmtValidation()) { return; }

			if (!checkFormValidation()) { return; }
			
			// 2021.09.13 고객사별 품목정보 검수자가 다른경우 부분검수로 저장하도록 체크 로직 추가
			var rowIds = gridECMT.jsonToArray(gridECMT.getSelRowId()).value;
            var rowData1 = {};
            var rowData2 = {};
            
			for(var i in rowIds) {
				rowData1 = gridECMT.getRowValue(rowIds[i]);
				
				for(var j in rowIds) {
                    rowData2 = gridECMT.getRowValue(rowIds[j]);
                    if (rowData1.PR_DEPT_CD == rowData2.PR_DEPT_CD) {
	                    if (rowData1.IV_USER_ID != rowData2.IV_USER_ID) {
	                    	var Idx = gridECCM.getAllRowId();
	                        for(var m in Idx) {
	                       	var rowIdx = Idx[m];
	                       	var prDeptCd = gridECCM.getCellValue(rowIdx, "PR_DEPT_CD");
	                       	var prDeptNm = gridECCM.getCellValue(rowIdx, "PR_BUYER_DEPT_NM");
	                       	var ivType   = gridECCM.getCellValue(rowIdx, "IV_TYPE");
		                       	if(rowData1.PR_DEPT_CD == prDeptCd){
		                       		if(ivType == "PI"){
		                       			return EVF.alert(prDeptNm +" 고객사의 품목정보 검수자가 2명 이상입니다.\n"+prDeptNm +" 고객사의 납품유형을 부분검수로 변경하시기 바랍니다");
		                       		}
		                       	}
	                    	}
                    	}
                	}
				}
            }
            
			var allRowIdx = gridECCM.getAllRowId();
			for(var i in allRowIdx) {
				var rowIdx = allRowIdx[i];
				var PC_HD_INFO = gridECCM.getCellValue(rowIdx, "PC_HD_INFO");
				if(PC_HD_INFO == "") {
					return EVF.alert("계약보증 정보를 1개 이상 입력하여 주시기 바랍니다.");
				}
			}
			
			// 지급율(100%)의 합은 100%를 초과할 수 없다.
			var payPercent = 0;
			var rowIdx = gridECPY.getAllRowId();
			for(var i in rowIdx) {
				payPercent += Number(gridECPY.getCellValue(rowIdx[i], "PAY_PERCENT"));
			}
			payPercent = Math.round(payPercent * 1e12) / 1e12;
			if( payPercent > 100 || payPercent < 100 ) {
            	return EVF.alert("${SCMS0010_0034}");
            }
			
			//2021.10.28 계약보증 요율이 (보증금/지급금액) * 100으로 계산 시 요율보다 ±0.3 차이 나는경우 체크 
			var allRowIdECCM = gridECCM.getAllRowId();
			
			for(var i in allRowIdECCM) {
				var pcHdInfoList = JSON.parse(gridECCM.getCellValue(allRowIdECCM[i], "PC_HD_INFO"));
				
				for(var c in pcHdInfoList) {
					var pcHdGridInfo = pcHdInfoList[c];
					var guarPercent = pcHdGridInfo.GUAR_PERCENT;
					var payAmt      = pcHdGridInfo.PAY_AMT;
					var guarAmt     = pcHdGridInfo.GUAR_AMT;
					var rate        = everMath.round_float((guarAmt / payAmt) * 100, 1);
					if( guarPercent + 0.3 < rate || guarPercent - 0.3 > rate ) {
						if( !confirm(pcHdGridInfo.PY_BUYER_DEPT_NM + " 고객사의 입력하신 보증금 대비 요율이 계약보증의 요율과 ±0.3의 차이가 있습니다. 계속 진행하시겠습니까?") ) {
							return;
						}
					} 
				}
			} 
			
			var store = new EVF.Store();
			if (!store.validate()) return;
			if (!gridECCM.validate().flag) { return EVF.alert(gridECCM.validate().msg); }
			if (!gridECMT.validate().flag) { return EVF.alert(gridECMT.validate().msg); }
			if (!gridECPC_HD.validate().flag) { return EVF.alert(gridECPC_HD.validate().msg); }
			if (!gridECPY.validate().flag) { return EVF.alert(gridECPY.validate().msg); }
			if (!gridECPC.validate().flag) { return EVF.alert(gridECPC.validate().msg); }
			
			EVF.confirm("${msg.M0021 }", function() {
				store.setGrid([gridM, gridA, gridECCM, gridECMT, gridECPC_HD]);
				store.getGridData(gridM, 'sel'); // 주서식
				store.getGridData(gridA, 'sel'); // 추가서식
				store.getGridData(gridECCM, 'all'); // 고객사 정보
				store.getGridData(gridECMT, 'all'); // 품목정보
				store.doFileUpload(function() {
					store.load(baseUrl + '/SCMS0010_doSave.so', function() {
						// 저장 완료 후 ozd, pdf 저장
						var contNum = this.getParameter('CONT_NUM');
						var contCnt = this.getParameter('CONT_CNT');

						new EVF.Mask().mask();

						if(EVF.V("CONT_NUM") == "" && EVF.V("CONT_CNT") == "") {
							eformScheduler(contNum, contCnt, 'S');
						} else {
							eformScheduler(contNum, contCnt, 'S');
						}
					});
				});
			});
		}
		
		<%-- 2021.03.08 기능 추가 --%>
		<%-- 작성중인 계약서를 협력사와 공유한다 --%>
		function doVendorSend() {

			var store = new EVF.Store();
			EVF.confirm("변경된 내용이 있는 경우 '저장' 이후에 협력사와 공유하세요.\n\n작성중인 계약서를 협력사와 공유하시겠습니까?", function() {
				store.load(baseUrl + '/SCMS0010_doVendorSend.so', function() {
					EVF.alert(this.getResponseMessage());
					
					var contNum = this.getParameter('CONT_NUM');
					var contCnt = this.getParameter('CONT_CNT');
					location.href = baseUrl+"/view.so?CONT_NUM="+contNum+'&CONT_CNT='+contCnt+'&bundleFlag=0';
					
					if(opener) {
						opener['doSearch']();
					}
				});
			});
		}

		function eformScheduler(contNum, contCnt, signFlag) {
			console.log("OZ Scheduler Start");
			
			// 저장된 JSON 데이터 값을 조회하여 가져온다.
			//2021.02.16 STOCECCT 테이블 CLOB TYPE 신규 컬럼 EFORM_INPUT_VALUE_CLOB 생성, 기존 EFORM_INPUT_VALUE 사용 => EFORM_INPUT_VALUE_CLOB 사용
			var eformInputValue = "";
			var store = new EVF.Store();
			store.setAsync(false);
			console.log("동기화 방식 OZ eform 데이터 존재 시 저장");
			store.load(baseUrl + '/SCMS0010_doSelectEformJsonData.so', function() {
				eformInputValue = this.getParameter("EFORM_INPUT_VALUE_CLOB");
				console.log("동기화 방식 OZ eform 데이터 존재 시 완료");
			});
			// 서브 폼 파일명을 가져온다.
			var subFormFileNm = "";
			for(var i in gridA.getSelRowValue()) {
				var value = gridA.getSelRowValue()[i];
				subFormFileNm += value.FORM_FILE_NM + ",";
			}

			// 파일이 첨부되어 있는 경우 서브 페이지를 호출한다.
			var fileCnt = EVF.C("ATT_FILE_NUM").getFileCount();
			if (fileCnt > 0) {
				subFormFileNm += "BS_FILE_INFO" + ",";
			}

			// maxFileCnt를 가져오기 위해 선 조회
			var maxFileCnt = 0;
			var allRowId = gridECCM.getAllRowId();
			for(var i in allRowId) {
				var rowIdx = allRowId[i];
				var ecpcHdInfo = gridECCM.getCellValue(rowIdx, "PC_HD_INFO");
				var parseEcpcHdInfo = JSON.parse(ecpcHdInfo);

				maxFileCnt += parseEcpcHdInfo.length;
			}

			// pdf 저장
			var odiParamVal = "BUYER_CD=" + "${ses.companyCd}" + ",CONT_NUM=" + contNum + ",CONT_CNT=" + contCnt;
			var param = {
					bizType: "EC",
	                SUB_FORM_FILE_NM: subFormFileNm.substring(0, subFormFileNm.length - 1),
					odiName: "DANIL_INFO",
					ozrName: gridM.getSelRowValue()[0].FORM_FILE_NM,
					// OZ Scheduler Info
					serverUrl: "${ozServer}",
					schedulerIp: "${ozSchedulerIp}",
					schedulerPort: "${ozSchedulerPort}",
					exportFileName: "${ses.companyCd}" + contNum + contCnt,
					odiParamVal: odiParamVal,
					url: "${ozUrl}",
					inputJson: eformInputValue,
					exportFormat: "pdf"
			};
			
			console.log("동기화 방식 OZ Scheduler 페이지 호출 시작"); 
			$.ajax({
				url: "${ozUrl}" + "/oz_export_directexport.jsp",
				type: "post",
				data: param,
				async: false,
				success: function(data) {
					console.log("동기화 방식 OZ Scheduler 페이지 호출 완료");

					// 전자결제 완료 후 PDF DB 관리(공통 처리)
					var fileCnt = 0;
					for(var i in allRowId) {
						var rowIdx = allRowId[i];
						var ecpcHdInfo = gridECCM.getCellValue(rowIdx, "PC_HD_INFO");
						var parseEcpcHdInfo = JSON.parse(ecpcHdInfo);
						for(var j in parseEcpcHdInfo) {
							fileCnt++;

							var ecpcHd = parseEcpcHdInfo[j];
							param = {
								bizType: "EC",
								fileNm: "${ses.companyCd}" + contNum + contCnt,
								fileExtension: "pdf",
								CONT_NUM: contNum,
								CONT_CNT: contCnt,
								buyerCd: ecpcHd.BUYER_CD,
								prBuyerCd: ecpcHd.PY_BUYER_CD,
								prDeptCd: ecpcHd.PY_DEPT_CD,
								uuid: ecpcHd.PDF_ATT_FILE_NUM,
								fileCnt: fileCnt,
								maxFileCnt: maxFileCnt
							};

							console.log("동기화 방식 pdf eform Server 에서 생성 파일 이동");
							$.ajax({
								url: "/common/file/eformPdfUpload.so",
								type: "post",
								data: param,
								async: false,
								success: function(data) {
									console.log("동기화 방식 pdf eform Server 에서 생성 파일 이동 완료");
									console.log("동기화 방식 pdf eform Server 에서 생성 파일 DB 관리 위해 채번");
									// STOCATCH 저장 후 PDF UUID 저장(개별 처리)
									$.ajax({
										url: baseUrl + "/SCMS0010_doUpdatePdfUUID.so",
										type: "post",
										data: {json: data},
										async: false,
										success: function(data) {
											console.log("동기화 방식 pdf eform Server 에서 생성 파일 DB 관리 위해 채번 완료");
											if(fileCnt == maxFileCnt) {
												if(signFlag == "S") {
													EVF.alert('${msg.M0031}');
													location.href = baseUrl+"/view.so?CONT_NUM="+contNum+'&CONT_CNT='+contCnt+'&bundleFlag=0';
													if(opener) {
														opener['doSearch']();
													}
												} else {
													EVF.alert('${msg.M0023}');
													if(opener) {
														opener['doSearch']();
														doClose();
													} else {
														location.href = baseUrl + "/view.so";
													}
												}
											}
										}
									});
								}
							});
						}
					}
				}
			});
		}

		<%-- 계약체결 기안 버튼을 처리한다 --%>
		function doReqSign() {

			var store = new EVF.Store();
			store.setGrid([gridM, gridA, gridECCM, gridECMT]);
			store.getGridData(gridM, 'sel');
			store.getGridData(gridA, 'sel');
			store.getGridData(gridECCM, 'all'); // 고객사 정보
			store.getGridData(gridECMT, 'all'); // 품목정보
			store.doFileUpload(function() {
				store.load(baseUrl + '/SCMS0010_doReqSign.so', function() {
					// 저장 완료 후 ozd, pdf 저장
					var contNum = this.getParameter('CONT_NUM');
					var contCnt = this.getParameter('CONT_CNT');
					if(EVF.V("CONT_NUM") == "" && EVF.V("CONT_CNT") == "") {
						eformScheduler(contNum, contCnt, "P");
					} else {
						eformScheduler(contNum, contCnt, "P");
					}
				});
			});
		}

		<%-- 계약서를 삭제처리한다 --%>
		function doDelete() {
			EVF.confirm("${msg.M0013}" + "\n" + "${SCMS0010_0042}", function() {
				var store = new EVF.Store();
				store.load(baseUrl + "/SCMS0010_doDeleteContract.so", function () {
					EVF.confirm(this.getResponseMessage(), function () {
						if (opener) {
							opener['doSearch']();
							doClose();
						} else {
							location.href = baseUrl + "/view.so";
						}
					});
				});
			});
		}
		
		<%-- 2021.02.08 추가 : 계약서를 협력사에 다시 전송한다. --%>
		function doReSend() {
			EVF.confirm("${SCMS0010_0041}", function() {
				EVF.confirm("${SCMS0010_0040}", function() {
					var store = new EVF.Store();
					store.load(baseUrl + "/SCMS0010_doReSend.so", function () {
						EVF.confirm(this.getResponseMessage(), function () {
							if (opener) {
								opener['doSearch']();
								doClose();
							}
						});
					});
				});
			});
		}
		
		<%-- 계약서에 서명한다 --%>
		function doSign() {

			if(!gridM.isExistsSelRow()) {
				return EVF.alert('선택된 계약서 서식이 없습니다. 서식관리에서 사용한 서식의 상태를 확인하세요.');
			}
			
			//2021.07.28 고객사 서명전 협력사 전자보증 상태 체크
			for(var i in gridECPC_HD.getAllRowValue()) {
                var hdRowValue = gridECPC_HD.getAllRowValue()[i];
                
                //협력사가 증권번호 발행 후 취소요청에 대한 승인 후 고객사 서명시 전자보증이며 증권번호가 없는 경우 서명 불가
                if(hdRowValue.GUAR_TYPE2 == "20") {
                	if(hdRowValue.GUAR_NUM == null || hdRowValue.GUAR_NUM == "") {
                		return EVF.alert("전자서명을 할 수 없습니다. 협력업체의 보증신청이 완료 되지 않았습니다.\n협력업체의 보증 재신청을 위해 재서명 요청 하시길 바랍니다.");
                	}
                }
			}
			
			//서명전 서버에서 전자보증 취소요청건 존재 여부 체크
			EVF.confirm("${SCMS0010_0016}", function() {
				var store = new EVF.Store();
				store.load(baseUrl + '/SCMS0010_guarCancelData.so', function() {
					var responseCode = this.getResponseCode();
					
	            	if( responseCode == "Y" ) {
	            		return EVF.alert(this.getResponseMessage());
	            	} else {
	            		sign();
	            	}
				});
				
			});
		}
		
		function sign(){
			<%-- local에서 테스트시 localServerFlag : "N", skip은 localServerFlag : "Y"
			localServerFlag = "N"; --%>
			document.reqForm.useCard.value = "1";
			if(localServerFlag == "Y") {
				signCompleteCallback();
			} else {
				if( EVF.V("PROGRESS_CD") == "4230" ) {
					// PDF Hash Code 값 서명값으로 셋팅
					document.reqForm.signData.value = "${ses.companyCd}" + "@@" + document.reqForm.idn.value + "@@" + EVF.V("HASH_NUM") + "@@" + "${signDate}";
					magicline.uiapi.MakeSignData(document.reqForm, null, mlCallBack);
				} else {
					return EVF.alert("진행상태가 올바르지 않습니다.");
				}
			}
		}
		
		function mlCallBack(code, message){
			if(code == 0) { <%-- 정상메시지 --%>
				if (message.encMsg != null) { document.reqForm.signedData.value = encodeURIComponent(message.encMsg); }
				if (message.vidRandom != null) { document.reqForm.vidRandom.value = encodeURIComponent(message.vidRandom); }
				signCompleteCallback();
			}
			else {
				return EVF.alert("결과값 수신에 실패하였습니다.");
			}
		}
		
		<%-- 전자서명 완료 후 처리 --%>
		function signCompleteCallback() {
			var store = new EVF.Store();
			store.doFileUpload(function() {
				store.setGrid([gridECCM]);
				store.getGridData(gridECCM, 'all');
				store.setParameter("signedData", document.reqForm.signedData.value);
				store.setParameter("vidRandom", document.reqForm.vidRandom.value);
				store.setParameter("idn", document.reqForm.idn.value);
				store.setParameter("useCard", document.reqForm.useCard.value);
				store.setParameter("localServerFlag", localServerFlag);
				store.load(baseUrl + '/SCMS0010_doSign.so', function () {
					EVF.alert("계약서에 서명하셨습니다.");
					
					// 2020.12.07 현업요청사항 추가
					// 계약서 전자서명 완료 후 pdf 재생성 추가
					var contNum = this.getParameter('CONT_NUM');
					var contCnt = this.getParameter('CONT_CNT');
					
					// 마스킹(Masking) 처리
					new EVF.Mask().mask();
					
		            //20211202 계약서에 첨부파일 추가
		            //eformScheduler(contNum, contCnt, "4300");
		            eformSchedulerWithAtt(contNum, contCnt, "4300");			
					
					/* 2020.12.21 현업요청사항 추가
					 * 계약서 전자서명 완료 후 pdf 재생성 추가
					if(opener) {
						opener['doSearch']();
						doClose();
					} else {
						location.href = baseUrl + "/view.so";
					}*/
				}, true);
			});
		}

		// 결재상신창에서 오픈할 경우는 Modal
		function doClose() {
			if ('${param.appDocNum}' === '') {
				window.close();
			} else {
				new EVF.ModalWindow().close(null);
			}
		}
		
		<%-- GW미사용 계열사의 계약체결 기안 버튼을 처리한다 --%>
		function doSend() {

			if (!checkAmtValidation()) { return; }

			if (!checkFormValidation()) { return; }
			
			// 2021.09.13 고객사별 품목정보 검수자가 다른경우 부분검수로 저장하도록 체크 로직 추가
			var rowIds = gridECMT.jsonToArray(gridECMT.getSelRowId()).value;
            var rowData1 = {};
            var rowData2 = {};
            
			for(var i in rowIds) {
				rowData1 = gridECMT.getRowValue(rowIds[i]);
				
				for(var j in rowIds) {
                    rowData2 = gridECMT.getRowValue(rowIds[j]);
                    if (rowData1.PR_DEPT_CD == rowData2.PR_DEPT_CD) {
	                    if (rowData1.IV_USER_ID != rowData2.IV_USER_ID) {
	                    	var Idx = gridECCM.getAllRowId();
	                        for(var m in Idx) {
	                       	var rowIdx = Idx[m];
	                       	var prDeptCd = gridECCM.getCellValue(rowIdx, "PR_DEPT_CD");
	                       	var prDeptNm = gridECCM.getCellValue(rowIdx, "PR_BUYER_DEPT_NM");
	                       	var ivType   = gridECCM.getCellValue(rowIdx, "IV_TYPE");
		                       	if(rowData1.PR_DEPT_CD == prDeptCd){
		                       		if(ivType == "PI"){
		                       			return EVF.alert(prDeptNm +" 고객사의 품목정보 검수자가 2명 이상입니다.\n"+prDeptNm +" 고객사의 납품유형을 부분검수로 변경하시기 바랍니다");
		                       		}
		                       	}
	                    	}
                    	}
                	}
				}
            }
			
			var allRowIdx = gridECCM.getAllRowId();
			for(var i in allRowIdx) {
				var rowIdx = allRowIdx[i];
				var PC_HD_INFO = gridECCM.getCellValue(rowIdx, "PC_HD_INFO");

				if(PC_HD_INFO == "") {
					return EVF.alert("계약보증 정보를 1개 이상 입력하여 주시기 바랍니다.");
				}
			}
			
			//2021.10.28 계약보증 요율이 (보증금/지급금액) * 100으로 계산 시 요율보다 ±0.3 차이 나는경우 체크 
			var allRowIdECCM = gridECCM.getAllRowId();
			for(var i in allRowIdECCM) {
				var pcHdInfoList = JSON.parse(gridECCM.getCellValue(allRowIdECCM[i], "PC_HD_INFO"));
				
				for(var c in pcHdInfoList) {
					var pcHdGridInfo = pcHdInfoList[c];
					var guarPercent = pcHdGridInfo.GUAR_PERCENT;
					var payAmt      = pcHdGridInfo.PAY_AMT;
					var guarAmt     = pcHdGridInfo.GUAR_AMT;
					var rate        = everMath.round_float((guarAmt / payAmt) * 100, 1);
					if( guarPercent + 0.3 < rate || guarPercent - 0.3 > rate ) {
						if( !confirm(pcHdGridInfo.PY_BUYER_DEPT_NM + " 고객사의 입력하신 보증금 대비 요율이 계약보증의 요율과 ±0.3의 차이가 있습니다. 계속 진행하시겠습니까?") ) {
							return;
						}
					} 
				}
			}

			var store = new EVF.Store();
			if (!store.validate()) { return; }

			if (!gridECCM.validate().flag) { return EVF.alert(gridECCM.validate().msg); }
			if (!gridECMT.validate().flag) { return EVF.alert(gridECMT.validate().msg); }
			if (!gridECPY.validate().flag) { return EVF.alert(gridECPY.validate().msg); }
			if (!gridECPC_HD.validate().flag) { return EVF.alert(gridECPC_HD.validate().msg); }
			if (!gridECPC.validate().flag) { return EVF.alert(gridECPC.validate().msg); }

			var signStatus = EVF.V("SIGN_STATUS") == "" ? "T" : EVF.V("SIGN_STATUS"); <%-- 결재상태 --%>
			if( signStatus == "T" || signStatus == "R" || signStatus == "C" ){
				EVF.confirm("결재상신 하시겠습니까?", function () {
					var param = {
						subject: EVF.V('CONT_DESC'),
						docType: "EC",
						signStatus: signStatus,
						screenId: "SCMS0010",
						approvalType: 'APPROVAL',
						attFileNum: "",
						docNum: EVF.V('CONT_NUM'),
						appDocNum: EVF.V('APP_DOC_NUM'),
						callBackFunction: "goApproval",
						appAmt: eval(EVF.V("CONT_AMT"))
					};
					everPopup.openApprovalRequestIPopup(param);
				});
			}
		}

		// 결재상신 완료 후 결재창에서 호출하는 메소드
		function goApproval(formData, gridData, attachData) {
			EVF.V('approvalFormData', formData);
			EVF.V('approvalGridData', gridData);
			EVF.V('attachFileDatas', attachData);

			doReqSign() ;
		}

		// 두개의 날짜를 비교하여 차이를 알려준다.
		function dateDiff(_date1, _date2) {
			var diffDate_1 = _date1 instanceof Date ? _date1 : new Date(_date1);
			var diffDate_2 = _date2 instanceof Date ? _date2 : new Date(_date2);

			diffDate_1 = new Date(diffDate_1.getFullYear(), diffDate_1.getMonth()+1, diffDate_1.getDate());
			diffDate_2 = new Date(diffDate_2.getFullYear(), diffDate_2.getMonth()+1, diffDate_2.getDate());

			var diff = Math.abs(diffDate_2.getTime() - diffDate_1.getTime());
			diff = Math.ceil(diff / (1000 * 3600 * 24));

			return diff;
		}

		function doReset() {
			location.href = baseUrl + "/view.so";
		}

		function doBasicSearch() {
			doSearchForm();
		}

		function doAddSearch() {
			doSearchSubForms();
		}

		function onChangeContReqCd() {
			<%-->
			if( EVF.V("CONT_CNT") == '' || EVF.V("CONT_CNT") == '1' ) {
				if( EVF.V('CONT_REQ_CD') != '10' ){
					EVF.alert('${SCMS0010_0033}');
					EVF.C('CONT_REQ_CD').setValue('10');
				}
			}
			--%>
		}

		function doItemSearch() {

			if (gridECCM.getSelRowCount() == 0) { return EVF.alert("고객사를 선택하여 주시기 바랍니다."); }
			if (gridECCM.getSelRowCount() > 1) { return EVF.alert("고객사 정보를 "+ "${msg.M0006}"); }

			var selRowValue = gridECCM.getSelRowValue()[0];
			if (selRowValue.PR_BUYER_DEPT_NM == "") {
				return EVF.alert("고객사를 선택하여 주시기 바랍니다.");
			}

			var param = {
				PROJECT_SQ: null,
				detailView: false,
				callbackFunction: "callBackITEM"
			};
			everPopup.openPopupByScreenId("CITR0042", 1150, 810, param);

		}

		function callBackGridITEM(data, rowIdx) {
			for(var i in data) {
				var selData = data[i];
				gridECMT.setCellValue(rowIdx, "ITEM_CD", selData.ITEM_CD);
				gridECMT.setCellValue(rowIdx, "ITEM_DESC", selData.ITEM_DESC);
				gridECMT.setCellValue(rowIdx, "ITEM_SPEC", selData.ITEM_SPEC);
				gridECMT.setCellValue(rowIdx, "ORIGIN_CD", selData.ORIGIN_CD);
				gridECMT.setCellValue(rowIdx, "UNIT_CD", selData.UNIT_CD);
				gridECMT.setCellValue(rowIdx, "MAKER_PART_NO", selData.MAKER_PART_NO);
				gridECMT.setCellValue(rowIdx, "MAJOR_ITEM_FLAG", selData.MAJOR_ITEM_FLAG);
				gridECMT.setCellValue(rowIdx, "MAKER_CD", selData.MAKER_CD);
				gridECMT.setCellValue(rowIdx, "MAKER_NM", selData.MAKER_NM);

				if(selData.MAJOR_ITEM_FLAG == "0") {
					gridECMT.setCellReadOnly(rowIdx, "ITEM_DESC", true);
					gridECMT.setCellReadOnly(rowIdx, "ITEM_SPEC", true);
					gridECMT.setCellReadOnly(rowIdx, "MAKER_NM", true);
					gridECMT.setCellReadOnly(rowIdx, "MAKER_PART_NO", true);
					gridECMT.setCellReadOnly(rowIdx, "ORIGIN_CD", true);

					gridECMT.setCellEdgeColor(rowIdx, "ITEM_DESC", true);
					gridECMT.setCellEdgeColor(rowIdx, "ITEM_SPEC", true);
					gridECMT.setCellEdgeColor(rowIdx, "MAKER_NM", true);
					gridECMT.setCellEdgeColor(rowIdx, "MAKER_PART_NO", true);
					gridECMT.setCellEdgeColor(rowIdx, "ORIGIN_CD", true);
				}
			}
		}

		function callBackITEM(data) {
			// gridECMT.setFigureBackground("UNIT_CD", gridECMT._PROPERTIES.CELL_BG_COLOR.DEFAULT);
			var selRowValue = gridECCM.getSelRowValue()[0];

			for(var j in data) {
				var rowIdx = gridECMT.addRow(data[j]);
				var selItem = data[j];

				gridECMT.setCellValue(rowIdx, "PR_BUYER_CD", selRowValue.PR_BUYER_CD);
				gridECMT.setCellValue(rowIdx, "PR_DEPT_CD", selRowValue.PR_DEPT_CD);
				gridECMT.setCellValue(rowIdx, "VENDOR_CD", selRowValue.VENDOR_CD);
				gridECMT.setCellValue(rowIdx, "PR_BUYER_DEPT_NM", selRowValue.PR_BUYER_DEPT_NM);
				gridECMT.setCellValue(rowIdx, "ITEM_PRC", selItem.CONT_AMT);

				if(selItem.MAJOR_ITEM_FLAG == "0") {
					gridECMT.setCellReadOnly(rowIdx, "ITEM_DESC", true);
					gridECMT.setCellReadOnly(rowIdx, "ITEM_SPEC", true);
					gridECMT.setCellReadOnly(rowIdx, "MAKER_NM", true);
					gridECMT.setCellReadOnly(rowIdx, "MAKER_PART_NO", true);
					gridECMT.setCellReadOnly(rowIdx, "ORIGIN_CD", true);

					gridECMT.setCellEdgeColor(rowIdx, "ITEM_DESC", true);
					gridECMT.setCellEdgeColor(rowIdx, "ITEM_SPEC", true);
					gridECMT.setCellEdgeColor(rowIdx, "MAKER_NM", true);
					gridECMT.setCellEdgeColor(rowIdx, "MAKER_PART_NO", true);
					gridECMT.setCellEdgeColor(rowIdx, "ORIGIN_CD", true);
				}
			}
		}
		
		//2021.11.25 품목 삭제 시 총 계약금액, 고객사별 계약금액, 고객사별 대금지불정보 계약금액 변경되도록 수정
		function doItemDelete() {
			if(gridECMT.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
			
			gridECMT.delRow();
			
			setTimeout(function() {
				var rowIds = gridECCM.jsonToArray(gridECCM.getAllRowId()).value;
	            var rowData1 = {};
	            var item_amt_sum = 0;
	            
				for(var i in rowIds) {
					rowData1 = gridECCM.getRowValue(rowIds[i]);
					var rowIdx = gridECMT.jsonToArray(gridECMT.getAllRowId()).value;
	    			var rowData2 = {};
	    			for(var k in rowIdx) {
	    				rowData2 = gridECMT.getRowValue(rowIdx[k]);
	    				if (rowData1.PR_BUYER_CD == rowData2.PR_BUYER_CD && rowData1.PR_DEPT_CD == rowData2.PR_DEPT_CD) {
	                    	item_amt_sum += rowData2.ITEM_AMT;
	                	}
	                }
	    			gridECCM.setCellValue(i, "CONT_AMT", item_amt_sum);
	    			item_amt_sum = 0;
	            }
				
				if(gridECCM.getRowCount() > 0) {
					gridECCM.checkRow(0, true);
					EVF.V("CONT_AMT_DUP", gridECCM.getCellValue(0, "CONT_AMT"), false);
				}
				
				contAmtSum();
			}, 300); 
			
		}

		function onChangeAmtType(viewFlag) {
			var allRowIdx = gridECCM.getAllRowId();
			for(var i in allRowIdx) {
				var rowIdx = allRowIdx[i];
				if (EVF.V("AMT_TYPE") == "TA") {
					if (!viewFlag) {
						gridECCM.setCellValue(rowIdx, "PO_CREATE_FLAG", "1");
					}
					gridECCM.setCellReadOnly(rowIdx, "PO_CREATE_FLAG", false);
				} else {
					gridECCM.setCellReadOnly(rowIdx, "PO_CREATE_FLAG", false);
				}
			}
		}

		function onChangeCUR(component, value) {
			EVF.V("CUR_DUP", value);
			EVF.V("CUR_GUAR", value);
		}

		function onChangeVAT_TYPE(component, value) {
			EVF.V("VAT_TYPE_NM", EVF.C("VAT_TYPE").getText());
			EVF.V("VAT_TYPE_DUP", value);
			EVF.V("VAT_TYPE_GUAR", value);
		}

		function onChangeCONT_AMT(component, value) {
			EVF.V("CONT_AMT_DUP", value);

			if(value > 0) {
				var PAY_AMT;
				if(EVF.V("PAY_TYPE_DUP") == "IS") {   // LS:일괄지급, IS:분할지급
					var allRowId = gridECPY.getAllRowId();
					for(var i in allRowId) {
						var rowIdx = allRowId[i];
						
						PAY_AMT = gridECPY.getCellValue(rowIdx, "PAY_PERCENT") / 100 * value;
						gridECPY.setCellValue(rowIdx, "PAY_AMT", PAY_AMT);
					}
				}
				else if(EVF.V("PAY_TYPE_DUP") == "LS") {
					PAY_AMT = gridECPY.getCellValue(0, "PAY_PERCENT") / 100 * value;
					gridECPY.setCellValue(0, "PAY_AMT", PAY_AMT);
				}
			}
		}

		function onChangePAY_TYPE() {
			if(!detailView) {
				var isSelRow = gridECCM.getSelRowCount() == 0 ? true : false;
				var isSelRowMulti = gridECCM.getSelRowCount() > 1 ? true : false;
				//var isSelRowItem = gridECMT.getSelRowCount() == 0 ? true : false;
				
				//if(isSelRow || isSelRowMulti || isSelRowItem) {
				if(isSelRow || isSelRowMulti) {
					if(payTypeFlag) {
						if (gridECCM.getSelRowCount() == 0) {
							EVF.alert("고객사를 선택하여 주시기 바랍니다.", function() {
								payTypeFlag = false;
								return EVF.V("PAY_TYPE_DUP", "", false);
							});
						}
						if (gridECCM.getSelRowCount() > 1) {
							EVF.alert("고객사를 " + "${msg.M0006}", function() {
								payTypeFlag = false;
								return EVF.V("PAY_TYPE_DUP", "", false);
							});
						}
						/*if (gridECMT.getSelRowCount() == 0) {
							EVF.alert("품목정보를 선택하여 주시기 바랍니다.", function() {
								payTypeFlag = false;
								return EVF.V("PAY_TYPE_DUP", "", false);
							});
						}*/
					}
					payTypeFlag = true;
				}
				else {
					var selRowId = gridECCM.getSelRowId()[0];
					gridECCM.setCellValue(selRowId, "METHOD_TYPE", EVF.V("PAY_TYPE_DUP"));
					gridECCM.setCellValue(selRowId, "PAY_CNT", EVF.V("PAY_CNT"));
					
					EVF.V("BUYER_DEPT_NM", gridECCM.getCellValue(selRowId, "PR_BUYER_DEPT_NM"));
					if(EVF.V("PAY_TYPE_DUP") == "LS") { // LS:일괄지급, IS:분할지급
						EVF.V("PAY_CNT", "1");
						EVF.C("doApplyPayCnt").setDisabled(true);
						doApplyPayCnt();
					}else {
						EVF.V("PAY_CNT", "");
						EVF.C("doApplyPayCnt").setDisabled(false);
					} 
				}
			}
		}

		function doItemCopy() {
			gridECMT.addRow(gridECMT.getSelRowValue());
		}
		
		// 계약번호 클릭시 팝업창
		// 임시저장(4200) 인 경우 oz 폼을 보여줌
		var winPop;
		function onContNumAndCnt() {
			
			if(!gridM.isExistsSelRow()) {
				return EVF.alert('선택된 계약서식이 존재하지 않습니다.');
			}
			
			// 2021.05.18 변경
			// 변경 및 연장 계약서 기능 추가에 따른 변경
			if( EVF.V("CONT_NUM") != "" && EVF.V("CONT_CNT") != "" ) {
				if ("${form.PROGRESS_CD}" == "4200") {
					ozdViewAndSave();
				} else {
					var pdfAttFileNum = EVF.V('PDF_ATT_FILE_NUM');
					var contNum = EVF.V('CONT_NUM');
					var contCnt = EVF.V('CONT_CNT');
					
					if( pdfAttFileNum == '' ) {
						pdfAttFileNum = PDF_ATT_FILE_NUM;
					}
					var selRowValue = gridECCM.getRowValue(0);
					//2022.03.24 최종 계약서 다운로드시 다운로드파일명 변경(회사코드계약번호계약차수 => 회사코드계약번호계약차수_일자_계약명_업체명)
					//var url = "/common/file/fileAttach/viewPdf.so?EVER_REQUEST_DATA_TYPE=FILE_DOWNLOAD&UUID=" + pdfAttFileNum;
					var url = "/common/file/fileAttach/contViewPdf.so?EVER_REQUEST_DATA_TYPE=FILE_DOWNLOAD&UUID=" + pdfAttFileNum + "&CONT_NUM=" + contNum + "&CONT_CNT=" + contCnt;
					url = XSSCheck(url, 1);
					
					// 2021.08.23 : 익스플로러 : 동일 name의 팝업이 2개 이상 열리는 버그로 인해...
					//window.open(url, "eform", "width=850,height=1265,scrollbars=yes,resizeable=no,left=0,top=0");
					if(!winPop || (winPop && winPop.closed)){
						winPop = window.open(url, "eform", "width=850,height=1265,scrollbars=yes,resizeable=no,left=0,top=0");
					} else {
						winPop.location.href = url;
					}
				}
			}
		}
		
		// 임시저장인 경우에는 EFORM 데이터를 저장할 수 있음
		function ozdViewAndSave() {
			var eformInputValue = "";
			
			var store = new EVF.Store();
			store.setAsync(false);
			store.load(baseUrl + '/SCMS0010_doSelectEformJsonData.so', function() {
				eformInputValue = this.getParameter("EFORM_INPUT_VALUE_CLOB");
			});

			// 서브 폼 파일명을 가져온다.
			var subFormFileNm = "";
			for(var i in gridA.getSelRowValue()) {
				var value = gridA.getSelRowValue()[i];
				subFormFileNm += value.FORM_FILE_NM + ",";
			}

			// 파일이 첨부되어 있는 경우 서브 페이지를 호출한다.
			var fileCnt = EVF.C("ATT_FILE_NUM").getFileCount();
			if (fileCnt > 0) {
				subFormFileNm += "BS_FILE_INFO" + ",";
			}

			// ozd 호출
			var contNum = EVF.V("CONT_NUM");
			var contCnt = EVF.V("CONT_CNT");
			var param = {
					bizType: "EC",
	                BUYER_CD: "${ses.companyCd}",
					CONT_NUM: contNum,
					CONT_CNT: contCnt,
					SUB_FORM_FILE_NM: subFormFileNm.substring(0, subFormFileNm.length - 1),
					odiName: "DANIL_INFO",
					ozrName: gridM.getSelRowValue()[0].FORM_FILE_NM,
					// OZ Scheduler Info
					serverUrl: "${ozServer}",
					schedulerIp: "${ozSchedulerIp}",
					schedulerPort: "${ozSchedulerPort}",
					exportFileName: "${ses.companyCd}" + contNum + contCnt,
					exportFormat: "ozr",
					url: "${ozUrl}",
					ozExportUrl: "${ozExportUrl}",
					callbackFunction: "eformCallbackFunction",
					inputJson: eformInputValue
			};
			
			// 2021.08.23 : 익스플로러 : 동일 name의 팝업이 2개 이상 열리는 버그로 인해...
			// var url = "${ozUrl}" + "/ozhviewer_canvas_eform.jsp";
			// IT포탈의 변경 및 연장계약인 경우
			// 2022.01.21 IT포탈의 변경 및 연장계약인 경우 계약번호 클릭 시 팝업 오픈 방식 get=>post로 변경
			if( EVF.V("PRE_CONT_NUM") != '' && (EVF.V("CONT_REQ_CD") == '20' || EVF.V("CONT_REQ_CD") == '30') ) {
				EVF.confirm("IT포탈 '변경 및 연장계약'의 경우 해당 화면의 최초 저장정보는 이전계약정보를 보여줍니다.\n\n해당 정보를 사용할 경우 반드시 '저장'하여 사용하세요.", function() {
					var url = "${ozUrl}" + "/ozhviewer_canvas_eform.jsp?"+ $.param(param);
					url = XSSCheck(url, 1);
					if(!winPop || (winPop && winPop.closed)){
						//winPop = window.open(url, "eform", "width=850,height=1265,scrollbars=yes,resizeable=no,left=0,top=0");
						url = "${ozUrl}" + "/ozhviewer_canvas_eform.jsp";
						everPopup.openWindowPopup(url, 850, 1265, param, 'eform');
					} else {
						winPop.location.href = url;
						//everPopup.openWindowPopup(url, 850, 1265, param, 'eform');
					}
				});
			} else {
				var url = "${ozUrl}" + "/ozhviewer_canvas_eform.jsp?"+ $.param(param);
				url = XSSCheck(url, 1);
				if(!winPop || (winPop && winPop.closed)){
					//winPop = window.open(url, "eform", "width=850,height=1265,scrollbars=yes,resizeable=no,left=0,top=0");
					url = "${ozUrl}" + "/ozhviewer_canvas_eform.jsp";
					everPopup.openWindowPopup(url, 850, 1265, param, 'eform');
				} else {
					winPop.location.href = url;
				}
			}
		}
		
		function XSSCheck(str, level){
			if(level == undefined || level == 0) {
				str = str.replace(/\<|\>|\"|\'|\%|\;|\(|\)|\&|\+|\-/g, " ");
			} else if (level != undefined && level == 1){
				str = str.replace(/\</g, "&lt:")	
				str = str.replace(/\>/g, "&gt:");	
			}
			return str;
		}
		
		/**
		 * 2020.12.16
		 * 계약서작성화면 계약번호 클릭 시 SCMS0010_doUpdatePdfUUID 업데이트 시 고객사정보 잘못 가져오는 오류로 인해 업데이트 실패 수정
		 */
		function eformCallbackFunction(json, jsonData) {
		    // 받은 JSON Data 값을 DB 에 저장한다.
		    //2021.02.16 STOCECCT 테이블 CLOB TYPE 신규 컬럼 EFORM_INPUT_VALUE_CLOB 생성, 기존 EFORM_INPUT_VALUE 사용 => EFORM_INPUT_VALUE_CLOB 사용
		   	var store = new EVF.Store();
		    store.setAsync(false);
		    store.setParameter("EFORM_INPUT_VALUE_CLOB", jsonData);
		    store.load(baseUrl + '/SCMS0010_doUpdateEformJsonData.so', function() {
			    // pdf 이동
			    var maxFileCnt = 0;
			    var allRowId = gridECCM.getAllRowId();
			    for(var i in allRowId) {
			        var rowIdx = allRowId[i];
			        var ecpcHdInfo = gridECCM.getCellValue(rowIdx, "PC_HD_INFO");
			    	var parseEcpcHdInfo = JSON.parse(ecpcHdInfo);
			        maxFileCnt += parseEcpcHdInfo.length;
			    }
			    
				var fileCnt = 0;
				for(var i in allRowId) {
					var rowIdx = allRowId[i];
				    var ecpcHdInfo = gridECCM.getCellValue(rowIdx, "PC_HD_INFO");
				    var parseEcpcHdInfo = JSON.parse(ecpcHdInfo);
				    for(var j in parseEcpcHdInfo) {
				    	fileCnt++;
	
				        var ecpcHd = parseEcpcHdInfo[j];
				        param = {
				            bizType: "EC",
				        	fileNm: "${ses.companyCd}" + json.CONT_NUM + json.CONT_CNT,
				        	fileExtension: "pdf",
				        	CONT_NUM: json.CONT_NUM,
				        	CONT_CNT: json.CONT_CNT,
				        	buyerCd: ecpcHd.BUYER_CD,
				        	prBuyerCd: ecpcHd.PY_BUYER_CD,
				        	prDeptCd: ecpcHd.PY_DEPT_CD,
				        	uuid: ecpcHd.PDF_ATT_FILE_NUM,
				        	fileCnt: fileCnt,
				        	maxFileCnt: maxFileCnt
				        };
				        
				        $.ajax({
				            url: "/common/file/eformPdfUpload.so",
				        	type: "post",
				        	data: param,
				        	async: false,
				        	success: function(data) {
					         	// STOCATCH 저장 후 PDF UUID 저장(개별 처리)
					         	$.ajax({
					          	    url: baseUrl + "/SCMS0010_doUpdatePdfUUID.so",
					                type: "post",
					                data: {json: data},
					                async: false,
					           		success: function(data) {
					           		}
					         	});
				        	 }
				    	});
					}
				}
			});
		}
		
		function doCopy() {
			var ecpcAllRowId = gridECPC.getAllRowId();
			var py_buyer_dept_nm = "";
			var ecpcList = [];
			
			for(var i in ecpcAllRowId) {
				var ecpcRowIdx = ecpcAllRowId[i];
				
				// 지불정보의 지불고객사를 설정하기 위해 고객사별 지불고객사 정보를 취합
				if (gridECPC.getRowCount() > 1) {
					if(ecpcAllRowId.length == ((i * 1) + 1)) {
						py_buyer_dept_nm += gridECPC.getCellValue(ecpcRowIdx, "PY_BUYER_DEPT_NM");
					}
					else {
						py_buyer_dept_nm += gridECPC.getCellValue(ecpcRowIdx, "PY_BUYER_DEPT_NM") + ", ";
					}
				}
				else {
					py_buyer_dept_nm += gridECPC.getCellValue(ecpcRowIdx, "PY_BUYER_DEPT_NM");
				}
				
				// 고객사별 지불고객사 정보를 일괄 적용하기 위해 추출
				ecpcList.push({
					"PY_BUYER_CD": gridECPC.getCellValue(ecpcRowIdx, "PY_BUYER_CD"),
					"PY_BUYER_NM": gridECPC.getCellValue(ecpcRowIdx, "PY_BUYER_NM"),
					"PY_DEPT_CD": gridECPC.getCellValue(ecpcRowIdx, "PY_DEPT_CD"),
					"PY_DEPT_NM": gridECPC.getCellValue(ecpcRowIdx, "PY_DEPT_NM"),
					"PY_USER_NM": gridECPC.getCellValue(ecpcRowIdx, "PY_USER_NM"),
					"PY_USER_ID": gridECPC.getCellValue(ecpcRowIdx, "PY_USER_ID"),
					"PY_BUYER_DEPT_NM": gridECPC.getCellValue(ecpcRowIdx, "PY_BUYER_DEPT_NM"),
					"CORP_TYPE": gridECPC.getCellValue(ecpcRowIdx, "CORP_TYPE"),
					"ATT_FILE_CNT": gridECPC.getCellValue(ecpcRowIdx, "ATT_FILE_CNT")
				})
			}
			
			// 지불정보 가져오기
			var ecpyAllRowId = gridECPY.getAllRowId();
			for(var j in ecpyAllRowId) {
				var ecpyRowIdx = ecpyAllRowId[j];
				
				gridECPY._gvo.setCurrent({itemIndex:ecpyRowIdx});
				// 지불정보의 값에 맞춰 고객사별 지불고객사 정보에 주입
				gridECPC.delAllRow();
				for(var n in ecpcList) {
					ecpcList[n]["PAY_CNT"] = gridECPY.getCellValue(ecpyRowIdx, "PAY_CNT");
					ecpcList[n]["PAY_CNT_NM"] = gridECPY.getCellValue(ecpyRowIdx, "PAY_CNT_NM");
					ecpcList[n]["PAY_CNT_TYPE"] = gridECPY.getCellValue(ecpyRowIdx, "PAY_CNT_TYPE");
					ecpcList[n]["PR_BUYER_CD"] = gridECPY.getCellValue(ecpyRowIdx, "PR_BUYER_CD");
					ecpcList[n]["PR_DEPT_CD"] = gridECPY.getCellValue(ecpyRowIdx, "PR_DEPT_CD");
					ecpcList[n]["VENDOR_CD"] = gridECPY.getCellValue(ecpyRowIdx, "VENDOR_CD");

					gridECPC.addRow(ecpcList[n]);
					ECPC_COPY(ecpyRowIdx);
				}
				gridECPY.setCellValue(ecpyRowIdx, "PY_BUYER_NM", py_buyer_dept_nm);
			}
			ECPY_COPY(gridECCM.getSelRowId()[0]);
		}
		
		// 2021.10.15 : 지불고객사별 지급금액 동일여부 체크
		function pyCustPayCheck() {
			if(gridECPC_HD.getRowCount() > 0) {
				EVF.V("GUAR_AMT", gridECPC_HD._gvo.getSummary("DI_GUAR_AMT","sum"));
				
				var idx = gridECPC_HD.getAllRowId();
				for(var i in idx) {
					ecpcHdGuarTypeDefaultSet(idx[i]);
				}
			}
		}
		
		// 2021.12.02 : 계약서에 발주사 첨부파일 추가
		// 2022.03.10 : PDF파일 생성시 파일명 방식 변경 기존(고객사코드 + 계약번호 + 계약차수) => 변경 (고객사코드 + 계약번호 + 계약차수 + _계약일자_계약명_협력업체명)
		function eformSchedulerWithAtt(contNum, contCnt, signFlag) {
			console.log("OZ Scheduler Start");
        	
            var buyerCd = EVF.V("BUYER_CD");
            var contDesc = EVF.V("CONT_DESC");
            var contDate = EVF.V("CONT_DATE");
            var vendorNm = EVF.V("VENDOR_NM"); 
			
			// 저장된 JSON 데이터 값을 조회하여 가져온다.
			//2021.02.16 STOCECCT 테이블 CLOB TYPE 신규 컬럼 EFORM_INPUT_VALUE_CLOB 생성, 기존 EFORM_INPUT_VALUE 사용 => EFORM_INPUT_VALUE_CLOB 사용
			var eformInputValue = "";
			var store = new EVF.Store();
			store.setAsync(false);
			console.log("동기화 방식 OZ eform 데이터 존재 시 저장");
			store.load(baseUrl + '/SCMS0010_doSelectEformJsonData.so', function() {
				eformInputValue = this.getParameter("EFORM_INPUT_VALUE_CLOB");
				console.log("동기화 방식 OZ eform 데이터 존재 시 완료");
			});
			// 서브 폼 파일명을 가져온다.
			var subFormFileNm = "";
			for(var i in gridA.getSelRowValue()) {
				var value = gridA.getSelRowValue()[i];
				subFormFileNm += value.FORM_FILE_NM + ",";
			}

			// 파일이 첨부되어 있는 경우 서브 페이지를 호출한다.
			var fileCnt = EVF.C("ATT_FILE_NUM").getFileCount();
			if (fileCnt > 0) {
				subFormFileNm += "BS_FILE_INFO" + ",";
			}

			// maxFileCnt를 가져오기 위해 선 조회
			var maxFileCnt = 0;
			var allRowId = gridECCM.getAllRowId();
			for(var i in allRowId) {
				var rowIdx = allRowId[i];
				var ecpcHdInfo = gridECCM.getCellValue(rowIdx, "PC_HD_INFO");
				var parseEcpcHdInfo = JSON.parse(ecpcHdInfo);

				maxFileCnt += parseEcpcHdInfo.length;
			}

			// pdf 저장
			var odiParamVal = "BUYER_CD=" + "${ses.companyCd}" + ",CONT_NUM=" + contNum + ",CONT_CNT=" + contCnt;
			var param = {
					bizType: "EC",
	                SUB_FORM_FILE_NM: subFormFileNm.substring(0, subFormFileNm.length - 1),
					odiName: "DANIL_INFO",
					ozrName: gridM.getSelRowValue()[0].FORM_FILE_NM,
					// OZ Scheduler Info
					serverUrl: "${ozServer}",
					schedulerIp: "${ozSchedulerIp}",
					schedulerPort: "${ozSchedulerPort}",
					exportFileName: "${ses.companyCd}" + contNum + contCnt,
					odiParamVal: odiParamVal,
					url: "${ozUrl}",
					inputJson: eformInputValue,
					exportFormat: "pdf"
			};
			
			console.log("동기화 방식 OZ Scheduler 페이지 호출 시작"); 
			$.ajax({
				url: "${ozUrl}" + "/oz_export_directexport.jsp",
				type: "post",
				data: param,
				async: false,
				success: function(data) {
					console.log("동기화 방식 OZ Scheduler 페이지 호출 완료");
                    param = {
                            bizType: "EC",
                            fileNm: buyerCd + contNum + contCnt,
                            fileExtension: "pdf",
                            uuid: EVF.V('ATT_FILE_NUM')
                        };
					$.ajax({
						url: "/common/file/eformPdfMergeAttach.so",
						type: "post",
						data: param,
						async: false,
						success: function(data) {					
							// 전자결제 완료 후 PDF DB 관리(공통 처리)
							var fileCnt = 0;
							for(var i in allRowId) {
								var rowIdx = allRowId[i];
								var ecpcHdInfo = gridECCM.getCellValue(rowIdx, "PC_HD_INFO");
								var parseEcpcHdInfo = JSON.parse(ecpcHdInfo);
								for(var j in parseEcpcHdInfo) {
									fileCnt++;
									var ecpcHd = parseEcpcHdInfo[j];
									param = {
										bizType: "EC",
										fileNm: "${ses.companyCd}" + contNum + contCnt,
										fileExtension: "pdf",
										CONT_NUM: contNum,
										CONT_CNT: contCnt,
										buyerCd: ecpcHd.BUYER_CD,
										prBuyerCd: ecpcHd.PY_BUYER_CD,
										prDeptCd: ecpcHd.PY_DEPT_CD,
										uuid: ecpcHd.PDF_ATT_FILE_NUM,
										fileCnt: fileCnt,
										maxFileCnt: maxFileCnt
									};
		
									console.log("동기화 방식 pdf eform Server 에서 생성 파일 이동");
									$.ajax({
										url: "/common/file/eformPdfUpload.so",
										type: "post",
										data: param,
										async: false,
										success: function(data) {
											console.log("동기화 방식 pdf eform Server 에서 생성 파일 이동 완료");
											console.log("동기화 방식 pdf eform Server 에서 생성 파일 DB 관리 위해 채번");
											// STOCATCH 저장 후 PDF UUID 저장(개별 처리)
											$.ajax({
												url: baseUrl + "/SCMS0010_doUpdatePdfUUID.so",
												type: "post",
												data: {json: data},
												async: false,
												success: function(data) {
													console.log("동기화 방식 pdf eform Server 에서 생성 파일 DB 관리 위해 채번 완료");
													if(fileCnt == maxFileCnt) {
														if(signFlag == "S") {
															EVF.alert('${msg.M0031}');
															location.href = baseUrl+"/view.so?CONT_NUM="+contNum+'&CONT_CNT='+contCnt+'&bundleFlag=0';
															if(opener) {
																opener['doSearch']();
															}
														} else {
															EVF.alert('${msg.M0023}');
															if(opener) {
																opener['doSearch']();
																doClose();
															} else {
																location.href = baseUrl + "/view.so";
															}
														}
													}
												}
											});
										}
									});
								}
							}
						}
					});
				}
			});
		}					
		
	</script>

	<e:window id="SCMS0010" onReady="init" initData="${initData}" title="${fullScreenName }" breadCrumbs="${breadCrumb }" margin="0 4px">
		<!-- 2021.07.16 : 계약서 작성유형(PR : 구매의뢰, CN : 품의) -->
		<e:inputHidden id='CREATE_TYPE' name='CREATE_TYPE' value="${form.CREATE_TYPE}"/>
		
		<!-- 계약번호, 계약차수, 계약체결고객사 -->
		<e:inputHidden id="BUYER_CD" name="BUYER_CD" value="${empty form.BUYER_CD ? param.BUYER_CD : form.BUYER_CD}"/>
		<e:inputHidden id="CONT_NUM" name="CONT_NUM" value="${empty form.CONT_NUM ? param.CONT_NUM : form.CONT_NUM}"/>
		<e:inputHidden id="CONT_CNT" name="CONT_CNT" value="${empty form.CONT_CNT ? param.CONT_CNT : form.CONT_CNT}"/>
		
		<!-- 이전계약번호 및 차수는 이전 화면에서만 받아오도록 함 -->
		<e:inputHidden id="PRE_BUYER_CD" name="PRE_BUYER_CD" value="${empty form.PRE_BUYER_CD ? param.PRE_BUYER_CD : form.PRE_BUYER_CD}"/>
		<e:inputHidden id="PRE_CONT_NUM" name="PRE_CONT_NUM" value="${empty form.PRE_CONT_NUM ? param.PRE_CONT_NUM : form.PRE_CONT_NUM}"/>
		<e:inputHidden id="PRE_CONT_CNT" name="PRE_CONT_CNT" value="${empty form.PRE_CONT_CNT ? param.PRE_CONT_CNT : form.PRE_CONT_CNT}"/>
		
		<!-- 결재상신번호, 결재상신차수 -->
		<e:inputHidden id="APP_DOC_NUM" name="APP_DOC_NUM" value="${empty form.APP_DOC_NUM ? param.APP_DOC_NUM : form.APP_DOC_NUM}"/>
		<e:inputHidden id="APP_DOC_CNT" name="APP_DOC_CNT" value="${empty form.APP_DOC_CNT ? param.APP_DOC_CNT : form.APP_DOC_CNT}"/>
		
		<e:inputHidden id='PROGRESS_CD' name='PROGRESS_CD' value='${form.PROGRESS_CD}'/>
		<e:inputHidden id='CONTRACT_TEXT_NUM' name='CONTRACT_TEXT_NUM' value='${form.CONTRACT_TEXT_NUM}'/>
		<e:inputHidden id='FORM_NUM' name='FORM_NUM' value='${form.MAIN_FORM_NUM}' alt="주계약서 서식번호" />
		
		<e:inputHidden id="approvalFormData" name="approvalFormData" value="" />
		<e:inputHidden id="approvalGridData" name="approvalGridData" value="" />
		<e:inputHidden id="attachFileDatas"  name="attachFileDatas"  value="" />
		<e:inputHidden id='APPROVAL_OPINION' name='APPROVAL_OPINION' value="" /> <!-- 기안내용 -->
		<e:inputHidden id='MANUAL_CONT_FLAG' name='MANUAL_CONT_FLAG' value="${empty form.MANUAL_CONT_FLAG ? param.MANUAL_CONT_FLAG : form.MANUAL_CONT_FLAG}" />
		<e:inputHidden id="VENDOR_CD"   name="VENDOR_CD"   value="${form.VENDOR_CD}"/>
		<e:inputHidden id="SIGN_STATUS" name="SIGN_STATUS" value="${form.SIGN_STATUS}"/>
		<e:inputHidden id="bundleFlag"  name="bundleFlag"  value="0"/>
		<e:inputHidden id="EXEC_NUM_SQ" name="EXEC_NUM_SQ" value="${form.EXEC_NUM_SQ}"/>
		<e:inputHidden id="PDF_ATT_FILE_NUM" name="PDF_ATT_FILE_NUM" value="${form.PDF_ATT_FILE_NUM}"/>
		
		<%--전자 서명 시 자신의 고객사를 판단하기 위해 계약체결진행현황에서 PR_BUYER_CD, PR_DEPT_CD 를 넘겨준다. --%>
		<e:inputHidden id="PR_BUYER_CD" name="PR_BUYER_CD" value="${param.PR_BUYER_CD}"/>
		<e:inputHidden id="PR_DEPT_CD" name="PR_DEPT_CD" value="${param.PR_DEPT_CD}"/>
		<e:inputHidden id="reCont" name="reCont" value="${form.reCont}"/>
		<e:inputHidden id="HASH_NUM" name="HASH_NUM" value="${form.HASH_NUM}"/>
		<e:inputHidden id="DEPT_CD" name="DEPT_CD" value="${form.DEPT_CD}"/>
		<e:inputHidden id='bf_main_form_num' name='bf_main_form_num' value="" /> <!-- 이전 주서식 -->
		
		<%-- 2020.11.25 추가 --%>
		<%-- 입찰을 통한 계약이 포함된 경우 수수료 청구시 "일반입찰계약(30)"으로 청구 --%>
		<e:inputHidden id="CONT_BID_GBN" name="CONT_BID_GBN" value="${form.CONT_BID_GBN}"/>

		<e:buttonBar id="buttonBar" align="right" width="100%" title="계약정보">
			<!-- 초기화 -->
			<c:if test="${!param.detailView and editableStatus}">
				<e:button id="doReset" name="doReset" label="${doReset_N}" onClick="doReset" disabled="${doReset_D}" visible="${doReset_V}"/>
			</c:if>
			<!-- 계약서 작성중(4200), 결재중(4206), 협력사 공유여부=N 인 경우 협력사 계약서 공유 버튼 활성화 -->
			<c:if test="${(!param.detailView and form.VENDOR_SEND_FLAG != '1' and form.PROGRESS_CD eq '4200') or (param.detailView and form.VENDOR_SEND_FLAG != '1' and form.PROGRESS_CD eq '4206')}">
				<e:button id="doVendorSend" name="doVendorSend" label="${doVendorSend_N}" onClick="doVendorSend" disabled="false" visible="true"/>
			</c:if>
			<!-- 최종 계약서 pdf 파일 변환된 경우 -->
			<c:if test="${form.PROGRESS_CD == '4300' and form.PDF_ATT_FILE_CNT > 0}">
				<e:button id="downloadPdf" name="downloadPdf" label="${downloadPdf_N}" onClick="downloadPdf" disabled="${downloadPdf_D}" visible="${downloadPdf_V}"/>
			</c:if>
			<e:button id="doClose" name="doClose" label="${doClose_N}" onClick="doClose" disabled="${doClose_D}" visible="${doClose_V}"/>
		</e:buttonBar>
		
		<%-- 계약정보 --%>
		<e:searchPanel id="form" title="계약정보" columnCount="3" labelWidth="135" onEnter="doSearch" useTitleBar="false">
			<e:row>
				<%-- 계약번호/차수 --%>
				<e:label for="CONT_NUM_AND_CNT" title="${form_CONT_NUM_AND_CNT_N}" />
				<e:field>
					<e:inputText id="CONT_NUM_AND_CNT" name="CONT_NUM_AND_CNT" value="${form.CONT_NUM_AND_CNT}" width="${form_CONT_NUM_AND_CNT_W}" maxLength="${form_CONT_NUM_AND_CNT_M}" disabled="${form_CONT_NUM_AND_CNT_D}" readOnly="${form_CONT_NUM_AND_CNT_RO}" required="${form_CONT_NUM_AND_CNT_R}" style="${imeMode}cursor:pointer;" maskType="${form_CONT_NUM_AND_CNT_MT}" onClick="onContNumAndCnt"/>
				</e:field>
				<%-- 계약일자 --%>
				<e:label for="CONT_DATE" title="${form_CONT_DATE_N}"/>
				<e:field>
					<e:inputDate id="CONT_DATE" name="CONT_DATE" value="${form.CONT_DATE}" width="${inputDateWidth}" datePicker="true" required="${form_CONT_DATE_R}" disabled="${form_CONT_DATE_D}" readOnly="${form_CONT_DATE_RO}" />
				</e:field>
				<%-- 계약기간 --%>
				<e:label for="CONT_START_DATE" title="${form_CONT_START_DATE_N}"/>
				<e:field>
					<e:inputDate id="CONT_START_DATE" name="CONT_START_DATE" toDate="CONT_END_DATE" value="${form.CONT_START_DATE}" width="${inputDateWidth}" datePicker="true" required="${form_CONT_START_DATE_R}" disabled="${form_CONT_START_DATE_D}" readOnly="${form_CONT_START_DATE_RO}" />
					<e:text>~</e:text>
					<e:inputDate id="CONT_END_DATE" name="CONT_END_DATE" fromDate="CONT_START_DATE" value="${form.CONT_END_DATE}" width="${inputDateWidth}" datePicker="true" required="${form_CONT_END_DATE_R}" disabled="${form_CONT_END_DATE_D}" readOnly="${form_CONT_END_DATE_RO}" />
				</e:field>
			</e:row>
			<e:row>
				<%-- 2021.07.16 변경
				         기존 : 중앙회, 은행의 경우 IT Portal 전송용 계약번호/차수 컬럼 따로 추가
				<c:choose>
					<c:when test="${ ( ses.companyCd eq 'C00009' or ses.companyCd eq 'C00066' or ses.companyCd eq 'C00013' or ses.companyCd eq 'C00068' ) and form.IF_TYPE eq 'IT' }"> 
						<e:label for="CONT_NUM_PORTAL" title="${form_CONT_NUM_PORTAL_N}" />
						<e:field>
							<e:inputText id="CONT_NUM_PORTAL" name="CONT_NUM_PORTAL" value="${form.CONT_NUM_PORTAL}" width="${form_CONT_NUM_PORTAL_W}" maxLength="${form_CONT_NUM_PORTAL_M}" disabled="${form_CONT_NUM_PORTAL_D}" readOnly="${form_CONT_NUM_PORTAL_RO}" required="${form_CONT_NUM_PORTAL_R}" style="${imeMode}" maskType="${form_CONT_NUM_PORTAL_MT}"/>
						</e:field>
						<e:label for="CONT_DESC" title="${form_CONT_DESC_N}" />
						<e:field colSpan="1">
							<e:inputText id="CONT_DESC" name="CONT_DESC" value="${form.CONT_DESC}" width="${form_CONT_DESC_W}" maxLength="${form_CONT_DESC_M}" disabled="${form_CONT_DESC_D}" readOnly="${form_CONT_DESC_RO}" required="${form_CONT_DESC_R}" style="${imeMode}" maskType="${form_CONT_DESC_MT}"/>
						</e:field>
					</c:when>
					<c:otherwise>
						<e:label for="CONT_DESC" title="${form_CONT_DESC_N}" />
						<e:field colSpan="3">
							<e:inputText id="CONT_DESC" name="CONT_DESC" value="${form.CONT_DESC}" width="${form_CONT_DESC_W}" maxLength="${form_CONT_DESC_M}" disabled="${form_CONT_DESC_D}" readOnly="${form_CONT_DESC_RO}" required="${form_CONT_DESC_R}" style="${imeMode}" maskType="${form_CONT_DESC_MT}"/>
						</e:field>
					</c:otherwise>
				</c:choose>
				--%>
				
				<e:label for="CONT_DESC" title="${form_CONT_DESC_N}" />
				<e:field colSpan="3">
					<e:inputText id="CONT_DESC" name="CONT_DESC" value="${form.CONT_DESC}" width="${form_CONT_DESC_W}" maxLength="${form_CONT_DESC_M}" disabled="${form_CONT_DESC_D}" readOnly="${form_CONT_DESC_RO}" required="${form_CONT_DESC_R}" style="${imeMode}" maskType="${form_CONT_DESC_MT}"/>
				</e:field>
				<%-- 계약구분 --%>
				<e:label for="CONT_REQ_CD" title="${form_CONT_REQ_CD_N}"/>
				<e:field>
					<e:select id="CONT_REQ_CD" name="CONT_REQ_CD" value="${form.CONT_REQ_CD}" options="${contReqCdOptions}" width="${form_CONT_REQ_CD_W}" disabled="${form_CONT_REQ_CD_D}" readOnly="${form_CONT_REQ_CD_RO}" required="${form_CONT_REQ_CD_R}" placeHolder="" maskType="${form_CONT_REQ_CD_MT}" onChange="onChangeContReqCd"/>
				</e:field>
			</e:row>
			<e:row>
				<%-- 계약금액 --%>
				<e:label for="CONT_AMT" title="${form_CONT_AMT_N}"/>
				<e:field colSpan="3">
					<e:inputNumber id="CONT_AMT" name="CONT_AMT" value="${form.CONT_AMT}" width="30%" maxValue="${form_CONT_AMT_M}" decimalPlace="${form_CONT_AMT_NF}" disabled="${form_CONT_AMT_D}" readOnly="${form_CONT_AMT_RO}" required="${form_CONT_AMT_R}" onNumberKr="${form_CONT_AMT_KR}" currencyText="${form_CONT_AMT_CT}"/>
					<e:text>&nbsp;</e:text>
					<e:select id="CUR" name="CUR" value="${form.CUR}" options="${curOptions}" width="20%" disabled="${form_CUR_D}" readOnly="${form_CUR_RO}" required="${form_CUR_R}" placeHolder="" maskType="${form_CUR_MT}" onChange="onChangeCUR"/>
					<e:text>&nbsp;</e:text>
					<e:select id="VAT_TYPE" name="VAT_TYPE" value="${form.VAT_TYPE}" options="${vatTypeOptions}" width="45%" disabled="${form_VAT_TYPE_D}" readOnly="${form_VAT_TYPE_RO}" required="${form_VAT_TYPE_R}" placeHolder="" maskType="${form_VAT_TYPE_MT}" onChange="onChangeVAT_TYPE"/>
					<e:inputHidden id="VAT_TYPE_NM" name="VAT_TYPE_NM" />
				</e:field>
				<%-- 계약담당자 --%>
				<e:label for="CONT_USER_NM" title="${form_CONT_USER_NM_N}" />
				<e:field>
					<e:inputText id="CONT_USER_NM" name="CONT_USER_NM" value="${form.CONT_USER_NM}" width="${form_CONT_USER_NM_W}" maxLength="${form_CONT_USER_NM_M}" disabled="${form_CONT_USER_NM_D}" readOnly="${form_CONT_USER_NM_RO}" required="${form_CONT_USER_NM_R}" style="${imeMode}" maskType="${form_CONT_USER_NM_MT}"/>
					<e:inputHidden id="CONT_USER_ID" name="CONT_USER_ID" value="${form.CONT_USER_ID}"/>
				</e:field>
			</e:row>
			<e:row>
				<%-- 협력업체 --%>
				<e:label for="VENDOR_NM" title="${form_VENDOR_NM_N}"/>
				<e:field>
					<e:search id="VENDOR_NM" name="VENDOR_NM" value="${form.VENDOR_NM}" width="${form_VENDOR_NM_W}" maxLength="${form_VENDOR_NM_M}" onIconClick="${(!param.detailView||param.detailView==null)?'onIconClickVENDOR_CD':'everCommon.blank'}" disabled="${form_VENDOR_NM_D}" readOnly="${form_VENDOR_NM_RO}" required="${form_VENDOR_NM_R}" maskType="${form_VENDOR_NM_MT}" />
				</e:field>
				<%-- 인증서종류 --%>
				<e:label for="CERT_TYPE" title="${form_CERT_TYPE_N}"/>
				<e:field>
					<e:select id="CERT_TYPE" name="CERT_TYPE" value="${form.CERT_TYPE}" options="${certTypeOptions}" width="${form_CERT_TYPE_W}" disabled="${form_CERT_TYPE_D}" readOnly="${form_CERT_TYPE_RO}" required="${form_CERT_TYPE_R}" placeHolder="" maskType="${form_CERT_TYPE_MT}" />
				</e:field>
				<%-- 금액구분 --%>
				<e:label for="AMT_TYPE" title="${form_AMT_TYPE_N}"/>
				<e:field>
					<e:select id="AMT_TYPE" name="AMT_TYPE" value="${form.AMT_TYPE}" options="${amtTypeOptions}" width="${form_AMT_TYPE_W}" disabled="${form_AMT_TYPE_D}" readOnly="${form_AMT_TYPE_RO}" required="${form_AMT_TYPE_R}" placeHolder="" maskType="${form_AMT_TYPE_MT}" onChange="onChangeAmtType"/>
				</e:field>
			</e:row>
			<e:row>
				<%-- 협력업체 담당자 --%>
				<e:label for="VENDOR_PIC_USER_NM" title="${form_VENDOR_PIC_USER_NM_N}" />
				<e:field>
					<e:search id="VENDOR_PIC_USER_NM" name="VENDOR_PIC_USER_NM" value="${form.VENDOR_PIC_USER_NM}" width="${form_VENDOR_PIC_USER_NM_W}" maxLength="${form_VENDOR_PIC_USER_NM_M}" onIconClick="${(!param.detailView||param.detailView==null)?'onIconClickVENDOR_PIC_USER_NM':'everCommon.blank'}" disabled="${form_VENDOR_PIC_USER_NM_D}" readOnly="${form_VENDOR_PIC_USER_NM_RO}" required="${form_VENDOR_PIC_USER_NM_R}" style="${imeMode}" maskType="${form_VENDOR_PIC_USER_NM_MT}"/>
				</e:field>
				<%-- 담당자 이메일 --%>
				<e:label for="VENDOR_PIC_USER_EMAIL" title="${form_VENDOR_PIC_USER_EMAIL_N}" />
				<e:field>
					<e:inputText id="VENDOR_PIC_USER_EMAIL" name="VENDOR_PIC_USER_EMAIL" value="${form.VENDOR_PIC_USER_EMAIL}" width="${form_VENDOR_PIC_USER_EMAIL_W}" maxLength="${form_VENDOR_PIC_USER_EMAIL_M}" disabled="${form_VENDOR_PIC_USER_EMAIL_D}" readOnly="${form_VENDOR_PIC_USER_EMAIL_RO}" required="${form_VENDOR_PIC_USER_EMAIL_R}" style="${imeMode}" maskType="${form_VENDOR_PIC_USER_EMAIL_MT}"/>
				</e:field>
				<%-- 담당자 휴대전화번호 --%>
				<e:label for="VENDOR_PIC_USER_CELL_NUM" title="${form_VENDOR_PIC_USER_CELL_NUM_N}" />
				<e:field>
					<e:inputText id="VENDOR_PIC_USER_CELL_NUM" name="VENDOR_PIC_USER_CELL_NUM" value="${form.VENDOR_PIC_USER_CELL_NUM}" width="${form_VENDOR_PIC_USER_CELL_NUM_W}" maxLength="${form_VENDOR_PIC_USER_CELL_NUM_M}" disabled="${form_VENDOR_PIC_USER_CELL_NUM_D}" readOnly="${form_VENDOR_PIC_USER_CELL_NUM_RO}" required="${form_VENDOR_PIC_USER_CELL_NUM_R}" style="${imeMode}" maskType="${form_VENDOR_PIC_USER_CELL_NUM_MT}"/>
				</e:field>
			</e:row>
			<e:row>
				<%-- 고객사 --%>
				<e:label for="BUYER_CD" title="${form_BUYER_CD_N}" />
				<e:field colSpan="5">
					<e:gridPanel gridType="${_gridType}" id="gridECCM" name="gridECCM" width="100%" height="97px" readOnly="${param.detailView}"/>
					<%-- 그리드 셋팅 --%>
				</e:field>
			</e:row>
			<e:row>
				<%-- 지체상금율 --%>
				<e:label for="DELAY_NUME_RATE" title="${form_DELAY_NUME_RATE_N}"/>
				<e:field colSpan="3">
					<e:inputText id="DELAY_RMK" name="DELAY_RMK" value="${form.DELAY_RMK}" width="50%" maxLength="${form_DELAY_RMK_M}" disabled="${form_DELAY_RMK_D}" readOnly="${form_DELAY_RMK_RO}" required="${form_DELAY_RMK_R}" style="${imeMode}" maskType="${form_DELAY_RMK_MT}"/>
					<e:text> </e:text>
					<e:inputNumber id="DELAY_NUME_RATE" name="DELAY_NUME_RATE" value="${form.DELAY_NUME_RATE}" width="15%" maxValue="${form_DELAY_NUME_RATE_M}" decimalPlace="${form_DELAY_NUME_RATE_NF}" disabled="${form_DELAY_NUME_RATE_D}" readOnly="${form_DELAY_NUME_RATE_RO}" required="${form_DELAY_NUME_RATE_R}" onNumberKr="${form_DELAY_NUME_RATE_KR}" currencyText="${form_DELAY_NUME_RATE_CT}"/>
					<e:text>/</e:text>
					<e:inputNumber id="DELAY_DENO_RATE" name="DELAY_DENO_RATE" value="${form.DELAY_DENO_RATE}" width="20%" maxValue="${form_DELAY_DENO_RATE_M}" decimalPlace="${form_DELAY_DENO_RATE_NF}" disabled="${form_DELAY_DENO_RATE_D}" readOnly="${form_DELAY_DENO_RATE_RO}" required="${form_DELAY_DENO_RATE_R}" onNumberKr="${form_DELAY_DENO_RATE_KR}" currencyText="${form_DELAY_DENO_RATE_CT}"/>
				</e:field>
				<%-- 인지세여부/금액 --%>
				<e:label for="STAMP_DUTY_FLAG" title="${form_STAMP_DUTY_FLAG_N}" />
				<e:field>
					<div style="width: 30%;">
						<e:checkGroup id="STAMP_DUTY_FLAG" name="STAMP_DUTY_FLAG" width="10%" value="${form.STAMP_DUTY_FLAG}" disabled="${form_STAMP_DUTY_FLAG_D}" readOnly="${form_STAMP_DUTY_FLAG_RO}" required="${form_STAMP_DUTY_FLAG_R}">
							<e:check id="STAMP_DUTY_FLAG1" name="STAMP_DUTY_FLAG1" value="1"  />
						</e:checkGroup>
					</div>
					<e:text>${SCMS0010_STAMP_DUTY_TXT} / </e:text>
					<e:inputNumber id="STAMP_DUTY_AMT" name="STAMP_DUTY_AMT" value="${form.STAMP_DUTY_AMT}" width="40%" maxValue="${form_STAMP_DUTY_AMT_M}" decimalPlace="${form_STAMP_DUTY_AMT_NF}" disabled="${form_STAMP_DUTY_AMT_D}" readOnly="${form_STAMP_DUTY_AMT_RO}" required="${form_STAMP_DUTY_AMT_R}" onNumberKr="${form_STAMP_DUTY_AMT_KR}" currencyText="${form_STAMP_DUTY_AMT_CT}"/>
				</e:field>
				<%--&lt;%&ndash; 자동갱신여부 &ndash;%&gt;
				<e:label for="AUTO_RENEW_FLAG" title="${form_AUTO_RENEW_FLAG_N}"/>
				<e:field>
					<e:select id="AUTO_RENEW_FLAG" name="AUTO_RENEW_FLAG" value="${form.AUTO_RENEW_FLAG}" options="${autoRenewFlagOptions}" width="${form_AUTO_RENEW_FLAG_W}" disabled="${form_AUTO_RENEW_FLAG_D}" readOnly="${form_AUTO_RENEW_FLAG_RO}" required="${form_AUTO_RENEW_FLAG_R}" placeHolder="" maskType="${form_AUTO_RENEW_FLAG_MT}" />
				</e:field>--%>
			</e:row>
			<e:row>
				<%-- 비고 --%>
				<e:label for="CONT_RMK" title="${form_CONT_RMK_N}" />
				<e:field colSpan="5">
					<e:inputText id="CONT_RMK" name="CONT_RMK" value="${form.CONT_RMK}" width="${form_CONT_RMK_W}" maxLength="${form_CONT_RMK_M}" disabled="${form_CONT_RMK_D}" readOnly="${form_CONT_RMK_RO}" required="${form_CONT_RMK_R}" style="${imeMode}" maskType="${form_CONT_RMK_MT}"/>
				</e:field>
			</e:row>
		</e:searchPanel>
		
		<%-- 서식선택 --%>
		<div id="Panel2" class="e-panel" style="height: ${formSelPanelHeight}px;width: 100%; float:none;">
			<div class="e-panel-body">
				<div class="e-panel" style="width: 49.5%;">
					<div style="float: left; width: 30%;">
						<e:title title="기본서식 선택" width="100px"/>
					</div>
					<div style="width: 100%; text-align: right;">
						<label style="font-size: 12px;">주서식명</label>
						<input type="text" id="BASIC_SEARCH" name="BASIC_SEARCH" style="vertical-align: middle;">
						&nbsp;
						<e:button id="doBasicSearch" name="doBasicSearch" label="${doBasicSearch_N}" onClick="doBasicSearch" disabled="${doBasicSearch_D}" visible="${doBasicSearch_V}"/>
					</div>
					<div class="e-panel-body">
						<e:gridPanel gridType="${_gridType}" id="gridM" name="gridM" width="100%" height="${formSelGridHeight}" readOnly="${param.detailView}"/>
					</div>
				</div>
				<div class="e-panel" style="width: 1%;">
					<div class="e-panel-body">&nbsp;</div>
				</div>
				<div class="e-panel" style="width: 49.5%;">
					<div style="float: left; width: 30%;">
						<e:title title="추가서식 선택"/>
					</div>
					<div style="width: 100%; text-align: right;">
						<label style="font-size: 12px;">추가 서식명</label>
						<input type="text" id="ADD_SEARCH" name="ADD_SEARCH" style="vertical-align: middle;">
						&nbsp;
						<e:button id="doAddSearch" name="doAddSearch" label="${doAddSearch_N}" onClick="doAddSearch" disabled="${doAddSearch_D}" visible="${doAddSearch_V}"/>
					</div>
					<div class="e-panel-body">
						<e:gridPanel gridType="${_gridType}" id="gridA" name="gridA" width="100%" height="${formSelGridHeight}" readOnly="${param.detailView}"/>
					</div>
				</div>
			</div>
		</div>
		
		<%-- 첨부파일 --%>
		<e:searchPanel id="form2" title="첨부파일" columnCount="2" labelWidth="125" onEnter="doSearch" useTitleBar="false">
			<e:row>
				<c:set var="attFileEditable" value="${empty form.PROGRESS_CD or form.ATT_FILE_EDITABLE eq 'true'}"/>
				<e:label for="ATT_FILE_NUM" title="${form_ATT_FILE_NUM_N}"/>
				<e:field>
					<e:fileManager id="ATT_FILE_NUM" height="100" width="100%" fileId="${form.ATT_FILE_NUM}" readOnly="${not attFileEditable}" bizType="EC" required="false" uploadable="${attFileEditable}"/>
				</e:field>
				<e:label for="VENDOR_ATT_FILE_NUM" title="${form_VENDOR_ATT_FILE_NUM_N}"/>
				<e:field>
					<e:fileManager id="VENDOR_ATT_FILE_NUM" height="100" width="100%" fileId="${form.VENDOR_ATT_FILE_NUM}" readOnly="true" bizType="EC" required="false" uploadable="false" />
				</e:field>
			</e:row>
		</e:searchPanel>
		
		<%-- 품목정보 --%>
		<e:buttonBar id="itemtButtons" align="right" title="품목정보">
			<!-- 전자계약서 수정 -->
			<c:if test="${empty form.copyFlag}">
				<e:button id="doItemSearch" name="doItemSearch" label="${doItemSearch_N}" onClick="doItemSearch" disabled="${doItemSearch_D}" visible="${doItemSearch_V}"/>
			</c:if>
			<!-- 구매의뢰(PR), 선정품의 기준 계약서 작성창 오픈 -->
			<c:if test="${not empty form.copyFlag}">
				<e:button id="doItemCopy" name="doItemCopy" label="${doItemCopy_N}" onClick="doItemCopy" disabled="${doItemCopy_D}" visible="${doItemCopy_V}"/>
			</c:if>
			<e:button id="doItemDelete" name="doItemDelete" label="${doItemDelete_N}" onClick="doItemDelete" disabled="${doItemDelete_D}" visible="${doItemDelete_V}"/>
		</e:buttonBar>
		<e:gridPanel gridType="${_gridType}" id="gridECMT" name="gridECMT" width="100%" height="223px" readOnly="${param.detailView}"/>
		
		<%-- 대금지불정보 --%>
		<e:panel id="panel_01" width="100%">
			<e:panel width="1%"><e:br/></e:panel>

			<%--대금지불정보--%>
			<e:panel width="99%">
				<e:searchPanel id="sp2" title="" labelWidth="${labelWidth}" useTitleBar="false" width="100%" columnCount="2" onEnter="" >
					<e:row>
						<%--대금지급방식--%>
						<e:label for="PAY_TYPE_DUP" title="${form_PAY_TYPE_N}"/>
						<e:field>
							<e:select id="PAY_TYPE_DUP" name="PAY_TYPE_DUP" value="${form.PAY_TYPE}" options="${payTypeOptions}" width="${form_PAY_TYPE_W}" disabled="${form_PAY_TYPE_D}" readOnly="${form_PAY_TYPE_RO}" required="${form_PAY_TYPE_R}" placeHolder="" maskType="${form_PAY_TYPE_MT}" onChange="onChangePAY_TYPE"/>
						</e:field>
						<%--차수--%>
						<e:label for="PAY_CNT" title="${form_PAY_CNT_N}"/>
						<e:field>
							<e:inputNumber id="PAY_CNT" name="PAY_CNT" value="${form.PAY_CNT}" width="${form_PAY_CNT_W}" maxValue="${form_PAY_CNT_M}" decimalPlace="${form_PAY_CNT_NF}" disabled="${form_PAY_CNT_D}" readOnly="${form_PAY_CNT_RO}" required="${form_PAY_CNT_R}" onNumberKr="${form_PAY_CNT_KR}" currencyText="${form_PAY_CNT_CT}"/>
							<e:text> </e:text><e:button id="doApplyPayCnt" name="doApplyPayCnt" label="${doApplyPayCnt_N}" onClick="doApplyPayCnt" disabled="${doApplyPayCnt_D}" visible="${doApplyPayCnt_V}"/>
						</e:field>
					</e:row>
					<e:row>
						<%--계약금액--%>
						<e:label for="CUR_DUP" title="${form_CONT_AMT_N}"/>
						<e:field>
							<e:inputNumber id="CONT_AMT_DUP" name="CONT_AMT_DUP" value="" onChange="onChangeCONT_AMT" width="30%" maxValue="${form_CONT_AMT_M}" decimalPlace="${form_CONT_AMT_NF}" disabled="${form_CONT_AMT_D}" readOnly="true" required="${form_CONT_AMT_R}" onNumberKr="${form_CONT_AMT_KR}" currencyText="${form_CONT_AMT_CT}"/>
							<e:select id="CUR_DUP" name="CUR_DUP" value="${form.CUR}" options="${curOptions}" width="20%" disabled="${form_CUR_D}" readOnly="true" required="${form_CUR_R}" placeHolder="" maskType="${form_CUR_MT}" />
							<e:select id="VAT_TYPE_DUP" name="VAT_TYPE_DUP" value="${form.VAT_TYPE}" options="${vatTypeOptions}" width="50%" disabled="${form_VAT_TYPE_D}" readOnly="true" required="${form_VAT_TYPE_R}" placeHolder="" maskType="${form_VAT_TYPE_MT}" />
						</e:field>
						<%--고객사--%>
						<e:label for="BUYER_DEPT_NM" title="${form_BUYER_DEPT_NM_N}" />
						<e:field>
							<e:inputText id="BUYER_DEPT_NM" name="BUYER_DEPT_NM" value="${form.BUYER_DEPT_NM}" width="${form_BUYER_DEPT_NM_W}" maxLength="${form_BUYER_DEPT_NM_M}" disabled="${form_BUYER_DEPT_NM_D}" readOnly="${form_BUYER_DEPT_NM_RO}" required="${form_BUYER_DEPT_NM_R}" style="${imeMode}" maskType="${form_BUYER_DEPT_NM_MT}"/>
						</e:field>
					</e:row>
					<e:row>
						<%--차액보증금--%>
						<e:label for="GUAR_AMT" title="${form_GUAR_AMT_N}"/>
						<e:field>
							<e:inputNumber id="GUAR_AMT" name="GUAR_AMT" value="" width="30%" maxValue="${form_GUAR_AMT_M}" decimalPlace="${form_GUAR_AMT_NF}" disabled="${form_GUAR_AMT_D}" readOnly="${form_GUAR_AMT_RO}" required="${form_GUAR_AMT_R}" onNumberKr="${form_GUAR_AMT_KR}" currencyText="${form_GUAR_AMT_CT}"/>
							<e:select id="CUR_GUAR" name="CUR_GUAR" value="${form.CUR}" options="${curOptions}" width="20%" disabled="${form_CUR_D}" readOnly="true" required="${form_CUR_R}" placeHolder="" maskType="${form_CUR_MT}" />
							<e:select id="VAT_TYPE_GUAR" name="VAT_TYPE_GUAR" value="${form.VAT_TYPE}" options="${vatTypeOptions}" width="50%" disabled="${form_VAT_TYPE_D}" readOnly="true" required="${form_VAT_TYPE_R}" placeHolder="" maskType="${form_VAT_TYPE_MT}" />
						</e:field>
						<e:label for="" title=""/>
						<e:field> </e:field>
					</e:row>
				</e:searchPanel>

				<%--계약보증 정보--%>
				<e:title title="계약보증 정보 및 서명여부"/>
				<e:gridPanel id="gridECPC_HD" name="gridECPC_HD" width="100%" height="208px" gridType="${_gridType}" readOnly="${param.detailView}"/>

				<%--지불정보--%>
				<e:buttonBar width="100%" align="right" title="지불정보" />
				<e:gridPanel id="gridECPY" name="gridECPY" width="100%" height="208px" gridType="${_gridType}" readOnly="${param.detailView}" />
				
				<%--고객사별 지불고객사 정보--%>
				<e:buttonBar width="100%" align="right" title="고객사별 지불고객사 정보">
					<c:if test="${!param.detailView and (form.PROGRESS_CD eq '4200' or empty form.PROGRESS_CD)}">
						<e:button id="doCopy" name="doCopy" label="${doCopy_N}" onClick="doCopy" disabled="${doCopy_D}" visible="${doCopy_V}"/>
					</c:if>
				</e:buttonBar>
				<e:gridPanel id="gridECPC" name="gridECPC" width="100%" height="208px" gridType="${_gridType}" readOnly="${param.detailView}"/>
			</e:panel>
		</e:panel>
		
		<e:buttonBar id="contButtons" width="100%" align="right">
			<e:button id="doSave" name="doSave" label="${doSave_N}" onClick="doSave" disabled="${doSave_D}" visible="${doSave_V}"/>
			<e:button id="doSend" name="doSend" label="${doSend_N}" onClick="doSend" disabled="${doSend_D}" visible="${doSend_V}"/>
			<c:if test="${!param.detailView and form.PROGRESS_CD eq '4230'}">
				<e:button id="doSign" name="doSign" label="${doSign_N}" onClick="doSign" disabled="${doSign_D}" visible="${doSign_V}"/>
				<e:button id="doReSend" name="doReSend" label="${doReSend_N}" onClick="doReSend" disabled="${doReSend_D}" visible="${doReSend_V}"/>
			</c:if>
			<e:button id="doDelete" name="doDelete" label="${doDelete_N}" onClick="doDelete" disabled="${doDelete_D}" visible="${doDelete_V}"/>
			<e:button id="doClose1" name="doClose" label="${doClose_N}" onClick="doClose" disabled="${doClose_D}" visible="${doClose_V}"/>
		</e:buttonBar>

		<%-- 결재자 리스트 Include --%>
		<jsp:include page="/WEB-INF/views/nhepro/CWOR/CWOR0013.jsp" flush="true" >
			<jsp:param value="${form.APP_DOC_NUM}" name="APP_DOC_NUM"/>
			<jsp:param value="${form.APP_DOC_CNT}" name="APP_DOC_CNT"/>
			<jsp:param value="${form.BUYER_CD}" name="BUYER_CD"/>
		</jsp:include>

		<form id='reqForm' name='reqForm' method='post' action="/MagicLine4Web/ML4Web/jcaosCheck.jsp">
			<input type="hidden" id="signData" name="signData" value=""/>
			<input type="hidden" id="signedData" name="signedData"/>
			<input type="hidden" id="vidRandom" name="vidRandom"/>
			<input type="hidden" id="vidType" name="vidType" value="client"/>
			<input type="hidden" id="idn" name="idn" value="${ses.irsNum}"/>
			<input type="hidden" id="useCard" name="useCard" value=""/>
		</form>
		
		<div id="dscertContainer">
			<iframe id="dscert" name="dscert" src="" width="100%" height="100%" frameborder="0" allowTransparency="true" style="position:fixed;z-index:100010;top:0px;left:0px;width:100%;height:100%;"></iframe>
		</div>
		<br>
	</e:window>
</e:ui>
