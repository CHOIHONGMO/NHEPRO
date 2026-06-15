<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="com.st_ones.everf.serverside.config.PropertiesManager" %>
<%@ include file="/WEB-INF/views/common/ozUrlInfo.jsp" %>

<%
	String ozSchedulerIp = PropertiesManager.getString("oz.scheduler.ip");
	String ozSchedulerPort = PropertiesManager.getString("oz.scheduler.port");
	response.addHeader("Access-Control-Allow-Origin", "*");
%>

<c:set var="ozExportUrl" value="<%=ozExportUrl%>" />
<c:set var="ozUrl" value="<%=ozUrl%>" />
<c:set var="ozServer" value="<%=ozServer%>" />
<c:set var="ozSchedulerIp" value="<%=ozSchedulerIp%>" />
<c:set var="ozSchedulerPort" value="<%=ozSchedulerPort%>" />

<%-- 계약서 수정 가능상태 : 저장전, 임시저장 => 일괄계약서는 결재상신 후 수정 불가능 --%>
<c:set var="editableStatus" value="${ (empty param.singleFlag or param.singleFlag eq '0')
								  and (empty form.PROGRESS_CD or form.PROGRESS_CD == '4200') }" />

<%-- 수정가능상태에 따라 그리드 높이를 조절하기 위한 변수 --%>
<c:set var="formSelGridHeight"  value="${(!param.detailView and editableStatus) ? '160' : '100'}"/>
<c:set var="formSelPanelHeight" value="${(!param.detailView and editableStatus) ? '220' : '160'}"/>

<e:ui>
	<script type="text/javascript" src="/MagicLine4Web/ML4Web/js/ext/jquery.blockUI.js"></script>
	<script type="text/javascript" src="/MagicLine4Web/ML4Web/js/ext/ML_Config.js"></script>
	<script type="text/javascript">
		
		var gridM; // 주서식 Grid
		var gridA; // 부서식 Grid
		var gridV; // 공급사 Grid
		
		var baseUrl = "/nhepro/CCTR/CCTA0040";
		var detailView = "${param.detailView}" == "true";
        var localServerFlag = "${localServerFlag}";
		
		$(document).ready(function () {
			$("#BASIC_SEARCH, #ADD_SEARCH").keypress(function (e) {
				if (e.keyCode == 13) {
					if (e.target.id == 'BASIC_SEARCH') {
						doBasicSearch();	// 주서식명 조회
					} else if (e.target.id == 'ADD_SEARCH') {
						doAddSearch();		// 추가서식명 조회
					}
				}
			});
		});

		function init() {

			gridM = EVF.C("gridM");
			gridA = EVF.C("gridA");
			gridM.setProperty('singleSelect', true);
			gridM.setProperty('shrinkToFit', true);
			gridA.setProperty('shrinkToFit', true);

			gridV = EVF.C("gridV");
			gridV.setProperty("shrinkToFit", true);
			gridV.setProperty("rowNumbers", ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
			gridV.setProperty("sortable", ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
			gridV.setProperty("panelVisible", ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
			gridV.setProperty("enterToNextRow", ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
			gridV.setProperty("acceptZero", ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
			gridV.setProperty("multiSelect", ${multiSelect});		// [선택] 컬럼의 사용여부를 지정한다. [true/false]
			gridV.setProperty("singleSelect", ${singleSelect});

			// 부서식(추가서식)은 전체선택이 없음
			gridA._gvo.setCheckBar({showAll: false});
			
			var buyerCd = EVF.V("BUYER_CD");
			var contNum = EVF.V("CONT_NUM");
			var contCnt = EVF.V("CONT_CNT");
			
			// 주서식 Grid
			gridM.cellClickEvent(function (rowId, colId, value) {
				
				if (colId == "FORM_NM") {
					var param = {
							bizType: "EC",
							BUYER_CD: buyerCd,
							CONT_NUM: contNum,
							CONT_CNT: contCnt,
							ozrName: gridM.getCellValue(rowId, "FORM_FILE_NM"),
							SUB_FORM_FILE_NM: "",
							exportFormat: "ozr"
					};
					SetOZParamters_OZViewer(param)
				}
				
				// 계약서 주서식 선택
				if( ${not param.detailView eq 'true'} ) {
					var formNum = gridM.getCellValue(rowId, 'FORM_NUM');
					if (formNum != EVF.V("bf_main_form_num")) {
						gridM.checkRow(rowId, true, true, false);
						setForm(rowId); 	// 주서식 선택
						doSearchSubForms(); // 부서식 선택
						setButtons();		// 버튼 처리
					}
				}
				
				// 인증서종류 선택
				onChangeCertType();
			});
			
			// 부서식 Grid
			gridA.cellClickEvent(function (rowId, colId, value, iRow, iCol) {
				if (colId === "multiSelect") {
					<c:if test="${param.detailView or !editableStatus}">
						var existsFlag = gridA.getCellValue(rowId, 'EXISTS_FLAG');
						if (existsFlag === '1') {
							gridA.checkRow(rowId, true);
						} else {
							gridA.checkRow(rowId, false);
						}
					</c:if>
				}

				if (colId === "REL_FORM_NM") {
					var param = {
						"BUYER_CD": buyerCd,
						"CONT_NUM": contNum,
						"CONT_CNT": contCnt,
						"ozrName": gridA.getCellValue(rowId, "FORM_FILE_NM"),
						"SUB_FORM_FILE_NM": "",
						"exportFormat": "ozr"
					};
					SetOZParamters_OZViewer(param)
				}
			});
			
			// 협력사 Grid
			gridV.cellClickEvent(function (rowId, colId, value) {
				switch (colId) {
					case 'CONT_NUM':
						if (value == '') return;
						// 2021.04.07 제외
						// 계약서작성(다수계약)은 협력사별로 EFORM_INPUT_VALUE를 별도로 저장하지 않음
						//if(EVF.V("PROGRESS_CD") == "4200") {
						//	ozdViewAndSave(gridV.getCellValue(rowId, "CONT_NUM"), gridV.getCellValue(rowId, "CONT_CNT"));
						//} else {
						var uuid = gridV.getCellValue(rowId, "PDF_ATT_FILE_NUM");
						if( !EVF.isEmpty(uuid) ) {
							var url  = "/common/file/fileAttach/viewPdf.so?EVER_REQUEST_DATA_TYPE=FILE_DOWNLOAD&UUID="+uuid;
							window.open(url, "eform", "width=850,height=1265,scrollbars=yes,resizeable=no,left=0,top=0");
						} else {
							return EVF.alert("생성된 계약서 PDF 파일이 없습니다.");
						}
						//}
						break;
						
					case 'VENDOR_ATT_FILE_CNT':
						if (value == '0') return;
						var param = {
							havePermission: 'false',
							attFileNum: gridV.getCellValue(rowId, 'VENDOR_ATT_FILE_NUM'),
							rowId: rowId,
							callBackFunction: '',
							bizType: 'EC',
							fileExtension: '*'
						};
						everPopup.openPopupByScreenId('commonFileAttach', 650, 310, param);
						break;
					
					case 'PDF_ATT_FILE_CNT':
						if (value == '0') return;
						var param = {
							havePermission: 'false',
							attFileNum: gridV.getCellValue(rowId, 'PDF_ATT_FILE_NUM'),
							rowId: rowId,
							callBackFunction: '',
							bizType: 'EC',
							fileExtension: '*'
						};
						everPopup.openPopupByScreenId('commonFileAttach', 650, 310, param);
						break;
				}
			});

			<c:if test="${!param.detailView and editableStatus}">
				// 협력사
				gridV.addRowEvent(function () {
					var contract_form_type = gridM.getSelRowValue()[0].CONTRACT_FORM_TYPE;
					// 위수탁계약서인 경우 고객사 조회 팝업을 호출한다.
					if (contract_form_type == "1120") {
						getBuyerCd();
					} else {
						getVendorCd();
					}
				});
	
				gridV.delRowEvent(function () {
					var contCnt = 0;
					var rowIds = gridV.getSelRowId();
					for (var i in rowIds) {
						if (gridV.getCellValue(rowIds[i], 'CONT_NUM') !== '' && !gridV.getCellValue(rowIds[i], 'CONT_CNT') == '') {
							contCnt++;
						}
					}
					if (contCnt > 0) {
						EVF.confirm("계약번호가 생성된 협력사를 삭제할 경우 해당 계약서도 함께 삭제됩니다.\n선택한 협력사를 삭제하시겠습니까?", function () {
							var store = new EVF.Store();
							store.setGrid([gridV]);
							store.getGridData(gridV, 'sel');
							store.load(baseUrl + "/ccta0040_doDeleteContract.so", function () {
								EVF.alert("${msg.M0017}");
								doSearchVendor();
								if (opener) {
									opener.doSearch();
								}
							});
						});
					} else {
						gridV.delRow();
					}
				});
			</c:if>
			
			// 주서식조회
			doSearchForm();
			// 폼 셋팅
			doSetDefaultForm();
			
			// 수정 및 재계약인 경우 신규는 제외함
			if (contCnt != '' && Number(contCnt) > 1) {
				EVF.C('CONT_REQ_CD').removeOption('10');
			} else {
				EVF.V('CONT_REQ_CD', '10');
			}
			
			// 위수탁 협력사 조회
			if (EVF.V("BUNDLE_NUM") != "") {
				doSearchVendor();
			}
		}
		
		// 위수탁 협력사 조회
		function doSearchVendor() {
			
			var store = new EVF.Store();
			store.setGrid([gridV]);
			store.load(baseUrl + "/ccta0040_getSavedVendorListForBundleContract.so", function () {
				
			}, false);
		}
		
		function doSetDefaultForm() {
			if ("${form.CONT_NUM}" == "" && "${form.CONT_CNT}" == "") {
				EVF.V("CONT_USER_ID", "${ses.userId}");
				EVF.V("CONT_USER_NM", "${ses.userNm}");
				EVF.V("CUR", "KRW");
			}
			
			// 협력사 서명대기(4210)
			if (!detailView) {
				if(EVF.V("PROGRESS_CD") == "4210" || EVF.V("PROGRESS_CD") == "4230") {
					if(EVF.V("PROGRESS_CD") == "4210") {
						EVF.C("VENDOR_ATT_FILE_NUM").setReadOnly(false);
					}
					EVF.C("CONT_DATE").setReadOnly(true);
					EVF.C("CONT_START_DATE").setReadOnly(true);
					EVF.C("CONT_END_DATE").setReadOnly(true);
					EVF.C("CONT_DESC").setReadOnly(true);
					EVF.C("CONT_REQ_CD").setReadOnly(true);
					EVF.C("CONT_AMT").setReadOnly(true);
					EVF.C("CUR").setReadOnly(true);
					EVF.C("VAT_TYPE").setReadOnly(true);
					EVF.C("CERT_TYPE").setReadOnly(true);
					EVF.C("CONT_RMK").setReadOnly(true);
				}
			}
			
			// 그리드 높이 조절
			$(window).trigger('resize');
		}
		
		<%-- 계약서 진행상태에 따라 버튼의 노출 처리 --%>
		<%-- 버튼은 기본적으로 hidden 처리되어 있으며, 계약서 진행상태에 따라 노출시킨다. --%>
		function setButtons() {
			if (${not param.detailView eq 'true'}) {
				EVF.C('doSave').setVisible(false); 		// 임시저장
				EVF.C('doDelete').setVisible(false); 	// 삭제
				EVF.C('doSend').setVisible(false); 		// 결재상신
				
				<c:if test="${editableStatus}">
					EVF.C('doSave').setVisible(true); 		// 저장
					<c:if test="${not empty form.CONT_NUM}">
						EVF.C('doDelete').setVisible(true); // 삭제
					</c:if>
					EVF.C('doSend').setVisible(true); 		// 결재상신
				</c:if>
			}
		}
		
		// 위수탁계약(1120)인 경우 고객사 조회 팝업
		function getBuyerCd() {

			var param = {
				'callBackFunction': 'setBuyerCd',
				'READONLY': 'Y',	//팝업 조회조건 변경불가
				'CORP_TYPE': '2',	//지역농축협(2) : NH0002
				'multiYN': 'Y',		//멀티팝업여부
				'detailView': false,
				'WORK_TYPE': 1
			};
			everPopup.openPopupByScreenId("CCDU0030", 1000, 700, param);
		}
		
		function setBuyerCd(data) {
			
			var setData = valid.equalPopupValid(JSON.stringify(data), gridV, "VENDOR_CD");
			for(var s in setData) {
				if(EVF.V("PR_BUYER_CD") == setData[s].VENDOR_CD) {
					return EVF.alert("위수탁 고객사가 동일합니다.");
				}
			}
			gridV.addRow(setData);
		}
		
		// 위수탁계약(1120)이 아닌 경우 협력사 조회 팝업
		function getVendorCd() {

			var param = {
				callBackFunction: "setVendorCd"
			};
			everPopup.openCommonPopup(param, "MP0019");
		}

		function setVendorCd(data) {

			var setData = valid.equalPopupValid(JSON.stringify(data), gridV, "VENDOR_CD");
			gridV.addRow(setData);
		}

		<%-- 계약서 주서식 변경 시 계약서 기본정보의 폼을 자동셋팅하는 함수 --%>
		function setForm(rowId) {

			if (rowId === undefined) {
				rowId = 0;
			}
			var contNum = EVF.V("CONT_NUM"); // 계약번호
			var autoRenewFlag = ""; // 자동갱신여부
			if (contNum == "") {
				<%-- 전자서명 여부 --%>
				var econtFlag = gridM.getCellValue(rowId, 'ECONT_FLAG');
				EVF.V('MANUAL_CONT_FLAG', (econtFlag === '1' ? "0" : "1"));
				<%-- 서식작성시 기안의견 --%>
				EVF.V('APPROVAL_OPINION', gridM.getCellValue(rowId, 'APPROVAL_OPINION'));
			}
		}
		
		// 주서식명 조회
		function doBasicSearch() {
			doSearchForm();
		}
		
		// 추가서식명 조회
		function doAddSearch() {
			doSearchSubForms();
		}

		<%-- 주계약서 서식을 조회하여 그리드에 조회한다 --%>
		function doSearchForm() {
			var store = new EVF.Store();
			store.setParameter("BASIC_SEARCH", $('#BASIC_SEARCH').val());
			store.setGrid([gridM]);
			store.load("/nhepro/CCTR/CCTA0030/ccta0030_doSearchMainForm.so", function () {
				if (gridM.getRowCount() > 0) {
					gridM.checkRow(0, true, true, false);
					setForm(0);			// 주계약서 서식 세팅
					doSearchSubForms();	// 추가서식 조회
				}
				setButtons();
			}, false);
		}

		<%-- 부서식을 조회하여 그리드에 보여준다 --%>
		function doSearchSubForms() {
			if (gridM.isExistsSelRow()) {
				var store = new EVF.Store();
				
				var selectedFormNum = gridM.getSelRowValue()[0].FORM_NUM;
				if (EVF.isEmpty(selectedFormNum)) return;
				
				store.setParameter("ADD_SEARCH", $("#ADD_SEARCH").val());
				store.setParameter("selectedFormNum", selectedFormNum);
				store.setGrid([gridA]);
				store.load("/nhepro/CCTR/CCTA0030/ccta0030_doSearchAdditionalForm.so", function () {
					
					var rowIds = gridA.getAllRowId();
					for(var i in rowIds) {
						if (gridA.getCellValue(rowIds[i], "DEFAULT_FLAG") == "1" || gridA.getCellValue(rowIds[i], "REQUIRE_FLAG") == "1") {
							gridA.checkRow(rowIds[i], true, false, false);
						}
					}
					
					// 2021.08.25 계약서 PDF 생성
					// 진행상태 = 작성중(4200), 협력사서명대기(4210), 협력사서명완료(4230)이면서 pdf 첨부파일이 없는 경우 pdf 생성
					var singleFlag = EVF.V("singleFlag");
					if( singleFlag == "1" ) {
						var progressCd  = EVF.V("PROGRESS_CD");
						var contFileNum = EVF.V("PDF_ATT_FILE_NUM");
						if( (progressCd == "4200" || progressCd == "4210" || progressCd == "4230") && EVF.isEmpty(contFileNum) ) {
							var bundleNum = EVF.V("BUNDLE_NUM");
							var contType  = EVF.V("CONT_TYPE");
							eformScheduler(bundleNum, contType, 'S');
						}
					}
				}, false);
			}
		}

		function getPrBuyerDeptNm() {
			var param = {
	                'callBackFunction': 'setPrBuyerDeptNm',
	                'READONLY': 'N',		//팝업 조회조건 변경불가
					'multiYN' : 'N',        //멀티팝업여부
					'detailView': false
	            };
	        everPopup.openPopupByScreenId("CCDU0010", 1000, 700, param);
		}

		function setPrBuyerDeptNm(data) {
			if(data != null){
        		data = JSON.parse(data);
        		
				var prBuyerDeptNm = data.CUST_NM + " " + data.DEPT_NM;
				EVF.V("PR_BUYER_DEPT_NM", prBuyerDeptNm);
				EVF.V("PR_BUYER_CD", data.CUST_CD);
				EVF.V("PR_DEPT_CD", data.DEPT_CD);
			}
		}

		function SetOZParamters_OZViewer(param) {
			var url = "${ozUrl}" + "/ozhviewer_canvas_eform.jsp";
			everPopup.openWindowPopup(url, 850, 1265, param, 'eform');
		}

		// 임시저장
		function doSave() {

			if (!checkFormValidation()) {
				return;
			}
			
			EVF.confirm("${msg.M0021 }", function () {
				var store = new EVF.Store();
				store.setGrid([gridM, gridA, gridV]);
				store.getGridData(gridM, 'sel'); // 주서식
				store.getGridData(gridA, 'sel'); // 추가서식
				store.getGridData(gridV, 'all'); // 협력사
				store.doFileUpload(function () {
					store.load(baseUrl + "/ccta0040_doSave.so", function () {
						// 2021.08.30 제외
						// 임시 저장시 pdf 생성 제외 : 계약번호 클릭시 생성되는 팝업에서 자동 생성함
						var bundleNum = this.getParameter('BUNDLE_NUM');
						var contType  = this.getParameter("CONT_TYPE");
						//eformScheduler(bundleNum, contType, 'S');
						
						EVF.alert('${msg.M0031}');
						location.href = baseUrl + "/view.so?BUNDLE_NUM=" + bundleNum + "&CONT_TYPE=" + contType + "&singleFlag=0";
						if(opener) {
							opener['doSearch']();
						}
					});
				});
			});
		}

		function eformScheduler(bundle_num, cont_type, signFlag) {
			console.log("OZ Scheduler Start");
			
			var hashNum = "";
			// 저장된 JSON 데이터 값을 조회하여 가져온다.
			//2021.02.16 STOCECCT 테이블 CLOB TYPE 신규 컬럼 EFORM_INPUT_VALUE_CLOB 생성, 기존 EFORM_INPUT_VALUE 사용 => EFORM_INPUT_VALUE_CLOB 사용
			var eformInputValue = "";
			var store = new EVF.Store();
			store.setAsync(false);
			store.load("/nhepro/CCTR/CCTA0030/ccta0030_doSelectEformJsonData.so", function() {
				eformInputValue = this.getParameter("EFORM_INPUT_VALUE_CLOB");
			});

			// 서브 폼 파일명을 가져온다.
			var subFormFileNm = "";
			for(var i in gridA.getSelRowValue()) {
				var value = gridA.getSelRowValue()[i];
				subFormFileNm += value.FORM_FILE_NM + ",";
			}
			
			// 협력사 첨부파일 : 파일이 첨부되어 있는 경우 서브 페이지를 호출한다.
			var fileCnt = EVF.C("VENDOR_ATT_FILE_NUM").getFileCount();
			if (fileCnt > 0) {
				subFormFileNm += "BS_FILE_INFO";
				
				// 협력사 첨부파일이 존재하는 경우 => 파일 정보 우선 저장
				// 계약번호, 계약차수, 일괄계약번호 : 협력사 전자서명시
				var store = new EVF.Store();
				store.setParameter("BUNDLE_NUM", bundle_num);
				store.doFileUpload(function() {
					store.load(baseUrl+'/ccta0040_doUpdateVendorFile.so', function() {
					}, true);
				});
			}
			
			// BUNDLE_NUM 로 전체 CONT_NUM, CONT_CNT를 조회한다.
			// 협력사 및 고객사 전자서명시와 같이 계약번호, 차수가 있는 경우 계약번호로만 조회한다.
			var store = new EVF.Store();
			store.setAsync(false);
			store.setParameter("BUNDLE_NUM", bundle_num);			// 일괄계약번호
			store.setParameter("CONT_NUM",   EVF.V("CONT_NUM"));	// 개별계약번호
			store.setParameter("CONT_CNT",   EVF.V("CONT_CNT"));	// 개별계약차수
			store.setParameter("BUNDLE_CNT", gridV.getRowCount());	// 개별계약번호 건수
			store.load(baseUrl + "/ccta0040_doSearchBundelInfo.so", function () {
				
				var contInfo   = JSON.parse(this.getParameter("CONT_INFO"));
				var maxContCnt = contInfo.length;		// 계약서 전체 건수
				for(var i in contInfo) {
					var curContCnt = (Number(i) + 1);	// 현재 계약서 번호
					
					// pdf 저장
					var odiParamVal = "BUYER_CD=" + contInfo[i].BUYER_CD + ",CONT_NUM=" + contInfo[i].CONT_NUM + ",CONT_CNT=" + contInfo[i].CONT_CNT;
					var name = contInfo[i].BUYER_CD + contInfo[i].CONT_NUM + contInfo[i].CONT_CNT;
					var param = {
							bizType: "EC",
			                SUB_FORM_FILE_NM: subFormFileNm,
							odiName: "DANIL_INFO",
							ozrName: gridM.getCellValue(0, "FORM_FILE_NM"),
							// OZ Scheduler Info
							serverUrl: "${ozServer}",
							schedulerIp: "${ozSchedulerIp}",
							schedulerPort: "${ozSchedulerPort}",
							exportFileName: name,
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
								fileNm: name,
								fileExtension: "pdf",
								CONT_NUM: contInfo[i].CONT_NUM,
								CONT_CNT: contInfo[i].CONT_CNT,
								buyerCd: contInfo[i].BUYER_CD,
								prBuyerCd: contInfo[i].PR_BUYER_CD,
								prDeptCd: contInfo[i].PR_DEPT_CD,
								uuid: contInfo[i].PDF_ATT_FILE_NUM,
								fileCnt: 1,
								maxFileCnt: 1,
								fileType: "M"
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
									
									var fileInfo = data;
									var jsonData = JSON.parse(data);
									    hashNum  = jsonData.HASH_NUM;
									var uuid	 = jsonData.UUID;
									// STOCATCH 저장 후 PDF UUID 저장(개별 처리)
									$.ajax({
										url: baseUrl + "/ccta0040_doUpdatePdfUUID.so",
										type: "post",
										data: {json: data},
										success: function(data) {
											
											console.log("동기화 방식 pdf eform Server 에서 생성 파일 DB 관리 위해 채번 완료");
											if(curContCnt == maxContCnt) {
												// 2021.08.30 : 생성된 pdf 번호 세팅
												EVF.V("PDF_ATT_FILE_NUM", uuid);
												gridV.setCellValue(0, 'PDF_ATT_FILE_NUM', uuid);
												
												// 협력사/발주사 전자서명시 생성된 pdf 파일에 대한 위변조 적용
												if(signFlag == "T") {		// 전자서명
													signCompleteTSA(fileInfo, hashNum);
												}
												else if(signFlag == "P") {	// 결재상신
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
					});
				}
			});
		}

		// 삭제
		function doDelete() {
			EVF.confirm("${msg.M0013}", function () {
				var store = new EVF.Store();
				store.setGrid([gridV]);
				store.getGridData(gridV, 'all');
				store.load(baseUrl + "/ccta0040_doDeleteBundleContract.so", function () {
					EVF.alert("${msg.M0001}");
					if (opener) {
						opener.doSearch();
						doClose();
					} else {
						location.href = baseUrl + "/view.so";
					}
				});
			});
		}

		function doClose() {
			EVF.closeWindow();
		}

		function doSend() {
			var store = new EVF.Store();
			if (!store.validate()) { return; }

			var signStatus = EVF.V("SIGN_STATUS") == "" ? "T" : EVF.V("SIGN_STATUS");
			<%-- 결재상태 --%>
			if (signStatus == "T") {
				EVF.confirm("결재상신 하시겠습니까?", function () {
					var contAmt = EVF.V("CONT_AMT");
					if (contAmt == null || contAmt == "") {
						contAmt = "0";
					}
					
					var param = {
						subject: EVF.V('CONT_DESC'),
						docType: "EC2",
						signStatus: signStatus,
						screenId: "CCTA0040",
						approvalType: 'APPROVAL',
						attFileNum: "",
						docNum: EVF.V('APP_DOC_NUM'),
						docCnt: EVF.V('APP_DOC_CNT'),
						callBackFunction: "goApproval",
						appAmt: eval(contAmt)
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

			doReqSign();
		}
		
		// 결재상신 완료 후 결재창에서 호출하는 메소드
		function doReqSign() {
			if (!checkFormValidation()) {
				return;
			}

			var store = new EVF.Store();
			store.setAsync(false);
			store.setGrid([gridM, gridA, gridV]);
			store.getGridData(gridM, "sel");
			store.getGridData(gridA, "sel");
			store.getGridData(gridV, "all"); // 협력사
			store.doFileUpload(function () {
				store.load(baseUrl + "/ccta0040_doReqSign.so", function () {
					var bundleNum = this.getParameter('BUNDLE_NUM');
					var contType  = this.getParameter("CONT_TYPE");
					eformScheduler(bundleNum, contType, 'P');
				});
			});
		}

		<%-- 저장을 하기 전에 입력되지 않은 폼이 있는지 확인해주는 체크함수 --%>
		function checkFormValidation() {

			var store = new EVF.Store();
			if (!store.validate()) {
				EVF.C('T1').setActive(0);
				return false;
			}

			if (!gridM.isExistsSelRow()) {
				return EVF.alert('계약서 주서식을 선택하셔야 합니다.');
			}

			if (!gridV.isExistsRow()) {
				return EVF.alert('농축협이 선택되지 않았습니다.');
			}

			// 부서식은 반드시 선택하도록 함
			var subFormGridRowId = gridA.getAllRowId();
			for (var i in subFormGridRowId) {
				var rowId = subFormGridRowId[i];
				if (gridA.getCellValue(rowId, 'REQUIRE_FLAG') === '1' && !gridA.isChecked(rowId)) {
					return alert('[' + gridA.getCellValue(rowId, 'REL_FORM_NM') + '] 추가서식은 반드시 선택하셔야 합니다.');
				}
			}

			var phoneCheck = /^(?:(010-\d{4})|(01[1|6|7|8|9]-\d{3,4}))(-\d{4})$/;
			var phoneCheckAdd = /^(?:(010\d{4})|(01[1|6|7|8|9]\d{3,4}))(\d{4})$/;
			var emailCheck = /^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$/i;

			var rowIds = gridV.getAllRowId();
			for (var i = 0; i < rowIds.length; i++) {
				// 협력사 담당자EMAIL, 담당자헨드폰 중에 한개는 필수..
				var phone = gridV.getCellValue(rowIds[i], 'VENDOR_PIC_USER_CELL_NUM');
				var email = gridV.getCellValue(rowIds[i], 'VENDOR_PIC_USER_EMAIL').trim();
				if (!EVF.isEmpty(phone) && (!phoneCheck.test(phone) && !phoneCheckAdd.test(phone))) {
					return alert("농축협 담당자의 휴대폰번호 형식이 올바르지 않습니다.");
				}
				if (!EVF.isEmpty(email) && !emailCheck.test(email)) {
					return alert("농축협 담당자의 이메일(E-Mail) 주소 형식이 올바르지 않습니다.");
				}
			}

			return true;
		}
		
		// 인증서종류 선택
		// 위수탁계약서(1120)인 경우에만 사설인증서를 사용할 수 있다.
		function onChangeCertType() {
			var rowIdx = gridM.getSelRowId()[0];
			var certType = EVF.V("CERT_TYPE");
			if(gridM.getCellValue(rowIdx, "CONTRACT_FORM_TYPE") != "1120") {
				if(certType == "P") {
					EVF.V("CERT_TYPE", "C");
					return EVF.alert("사설인증서는 선택하실 수 없습니다.");
				}
			}
		}
		
		// 공급사 전자서명 (4210 => 4230)
		function doSign() {

			if(!gridM.isExistsSelRow()) {
				return EVF.alert('선택된 계약서 서식이 없습니다. 서식관리에서 사용한 서식의 상태를 확인하세요.');
			}
			
			if( EVF.isEmpty(EVF.V("PDF_ATT_FILE_NUM")) ) {
		    	return EVF.alert("생성된 PDF 계약서가 없습니다. 잠시후에 사용하세요.\n\n지속적인 오류 발생시 관리자에게 문의하세요.");
		    }
			
			EVF.confirm("${CCTA0040_0001}", function() {
				if(EVF.V("CERT_TYPE") == "C") {
					document.reqForm.useCard.value = "1"; // 공인인증서
				} else {
					document.reqForm.useCard.value = "2"; // 사설인증서
				}
				
				if(localServerFlag == "Y") {
					signCompleteCallback();
				} else {
					if (EVF.V("PROGRESS_CD") == "4210") {
						eformScheduler(EVF.V("BUNDLE_NUM"), gridM.getCellValue(0, "CONTRACT_FORM_TYPE"), "T");
					} else {
						return EVF.alert("진행상태가 올바르지 않습니다.");
					}
				}
			});
		}
		
		// 발주사 전자서명 (4230 => 4300)
		function doCustSign() {

			if(!gridM.isExistsSelRow()) {
				return EVF.alert('선택된 계약서 서식이 없습니다. 서식관리에서 사용한 서식의 상태를 확인하세요.');
			}
			
			if( EVF.isEmpty(EVF.V("PDF_ATT_FILE_NUM")) ) {
		    	return EVF.alert("생성된 PDF 계약서가 없습니다. 잠시후에 사용하세요.\n\n지속적인 오류 발생시 관리자에게 문의하세요.");
		    }
			
			EVF.confirm("${CCTA0040_0002}", function() {
				if(EVF.V("CERT_TYPE") == "C") {
					document.reqForm.useCard.value = "1"; // 공인인증서
				} else {
					document.reqForm.useCard.value = "2"; // 사설인증서
				}
				
				if(localServerFlag == "Y") {
					signCompleteCallback();
				} else {
					if( EVF.V("PROGRESS_CD") == "4230" ) {
						eformScheduler(EVF.V("BUNDLE_NUM"), gridM.getCellValue(0, "CONTRACT_FORM_TYPE"), "T");
					} else {
						return EVF.alert("진행상태가 올바르지 않습니다.");
					}
				}
			});
		}
		
		<%-- 파일에 대한 hash값 저장 --%>
		function signCompleteTSA(fileInfo, hashNum) {
			var store = new EVF.Store();
			store.setAsync(false);
			store.setParameter("FILE_INFO", fileInfo);
			store.load(baseUrl + '/ccta0040_doSignCompleteTSA.so', function () {
				document.reqForm.signData.value = "${ses.companyCd}" + "@@" + document.reqForm.idn.value + "@@" + hashNum + "@@" + "${signDate}";
				
				// 공인, 사설 인증서 팝업창 띄우기
				var certType = EVF.V("CERT_TYPE");
				var certOdiFilter = "";
				if (certType == "C") {
					certOdiFilter = "${ipoidFilter}";	// 공인인증서 정책
				} else {
					certOdiFilter = "${iboidFilter}";	// 사설인증서 정책
				}
				var listOdiArr    = certOdiFilter.split(";");
				var certOidfilter = "";
				for(var i in listOdiArr) {
					certOidfilter = certOidfilter + listOdiArr[i] + ",";
				}
				certOidfilter = certOidfilter.substring(0, certOidfilter.length-1);
				
				// 공인, 사설 인증하기
	        	magicline.uiapi.MakeSignData(document.reqForm, null, mlCallBack, certOidfilter);
			});
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
		
		<%-- 위탁사 및 수탁사 전자서명 완료 후 처리 --%>
		function signCompleteCallback() {
			var store = new EVF.Store();
			store.setAsync(false);
			store.setGrid([gridV]);
			store.getGridData(gridV, 'all');
			store.setParameter("signedData", document.reqForm.signedData.value);
			store.setParameter("vidRandom", document.reqForm.vidRandom.value);
			store.setParameter("idn", document.reqForm.idn.value);
			store.setParameter("useCard", document.reqForm.useCard.value);
			store.setParameter("localServerFlag", localServerFlag);
			
			// 공급사 전자서명
			if( EVF.V("PROGRESS_CD") == "4210" ) {
				store.load(baseUrl + '/ccta0040_doSignBuyer.so', function () {
					EVF.alert("계약서에 서명하셨습니다.");
					if (opener) {
						opener.doSearch();
						doClose();
					} else {
						location.href = baseUrl + "/view.so";
					}
				}, true);
			}// 발주사 전자서명
			else {
				store.load(baseUrl + '/ccta0040_doSign.so', function () {
					EVF.alert("계약서에 서명하셨습니다.");
					if (opener) {
						opener.doSearch();
						doClose();
					} else {
						location.href = baseUrl + "/view.so";
					}
				}, true);
			}
		}
		
		function doReset() {
			location.href = baseUrl + "/view.so";
		}
	</script>

	<e:window id="CCTA0040" onReady="init" initData="${initData}" title="${fullScreenName }" breadCrumbs="${breadCrumb }" margin="0 4px">
		<e:inputHidden id="BUYER_CD" name="BUYER_CD" value="${empty param.BUYER_CD ? form.BUYER_CD : param.BUYER_CD}"/>
		<e:inputHidden id="CONT_NUM" name="CONT_NUM" value="${empty param.CONT_NUM ? form.CONT_NUM : param.CONT_NUM}"/> <!-- 계약번호 -->
		<e:inputHidden id="CONT_CNT" name="CONT_CNT" value="${empty param.CONT_CNT ? form.CONT_CNT : param.CONT_CNT}"/> <!-- 계약차수 -->
		<e:inputHidden id="PR_BUYER_CD" name="PR_BUYER_CD" value="${empty param.PR_BUYER_CD ? form.PR_BUYER_CD : param.PR_BUYER_CD}"/> <!-- 계약의뢰고객사 -->
		<e:inputHidden id="PR_DEPT_CD" name="PR_DEPT_CD" value="${empty param.PR_DEPT_CD ? form.PR_DEPT_CD : param.PR_DEPT_CD}"/> <!-- 계약의뢰부서 -->

		<e:inputHidden id='PROGRESS_CD' name='PROGRESS_CD' value='${form.PROGRESS_CD}'/>
		<e:inputHidden id='CONTRACT_TEXT_NUM' name='CONTRACT_TEXT_NUM' value='${form.CONTRACT_TEXT_NUM}'/>
		<e:inputHidden id='FORM_NUM' name='FORM_NUM' value='${form.MAIN_FORM_NUM}' alt="주계약서 서식번호"/>
		<e:inputHidden id="APP_DOC_NUM" name="APP_DOC_NUM" value="${empty param.APP_DOC_NUM ? form.APP_DOC_NUM : param.APP_DOC_NUM}"/>
		<e:inputHidden id="APP_DOC_CNT" name="APP_DOC_CNT" value="${empty param.APP_DOC_CNT ? form.APP_DOC_CNT : param.APP_DOC_CNT}"/>
		<e:inputHidden id="approvalFormData" name="approvalFormData" value=""/>
		<e:inputHidden id="approvalGridData" name="approvalGridData" value=""/>
		<e:inputHidden id="attachFileDatas" name="attachFileDatas" value=""/>
		<e:inputHidden id='APPROVAL_OPINION' name='APPROVAL_OPINION' value=""/> <!-- 기안내용 -->
		<e:inputHidden id='MANUAL_CONT_FLAG' name='MANUAL_CONT_FLAG' value="${empty form.MANUAL_CONT_FLAG ? param.MANUAL_CONT_FLAG : form.MANUAL_CONT_FLAG}"/>
		<e:inputHidden id="SIGN_STATUS" name="SIGN_STATUS" value="${form.SIGN_STATUS}"/>
		<e:inputHidden id="bundleFlag" name="bundleFlag" value="1"/>
		<e:inputHidden id="singleFlag" name="singleFlag" value="${param.singleFlag}"/>	<!-- 계약번호 클릭시 : 1, 일괄계약번호 클릭시 : 0 -->
		<e:inputHidden id="VENDOR_CD" name="VENDOR_CD" value="${param.VENDOR_CD}"/>
		<e:inputHidden id="CONT_TYPE" name="CONT_TYPE" value="${form.CONT_TYPE}"/>
		<e:inputHidden id="PDF_ATT_FILE_NUM" name="PDF_ATT_FILE_NUM" value="${form.PDF_ATT_FILE_NUM}"/>
		<e:inputHidden id="reCont" name="reCont" value="${form.reCont}"/>
		<e:inputHidden id="HASH_NUM" name="HASH_NUM" value="${form.HASH_NUM}"/>
		<e:inputHidden id='bf_main_form_num' name='bf_main_form_num' value=""/> <!-- 이전 주서식 -->
		<%-- 2020.11.25 : 입찰을 통한 계약이 포함된 경우 "일반입찰계약(30)"으로 수수료 청구하기 위해서 --%>
		<e:inputHidden id="CONT_BID_GBN" name="CONT_BID_GBN" value="${form.CONT_BID_GBN}"/>
		
		<e:buttonBar id="buttonBar" align="right" width="100%" title="계약정보">
			<c:if test="${!param.detailView and editableStatus}">
				<e:button id="doReset" name="doReset" label="${doReset_N}" onClick="doReset" disabled="${doReset_D}" visible="${doReset_V}"/>
			</c:if>
		</e:buttonBar>
		
		<e:searchPanel id="form" title="계약정보" columnCount="3" labelWidth="135" onEnter="doSearch" useTitleBar="false">
			<e:row>
				<%-- 일괄계약번호 --%>
				<e:label for="BUNDLE_NUM" title="${form_BUNDLE_NUM_N}"/>
				<e:field>
					<e:inputText id="BUNDLE_NUM" name="BUNDLE_NUM" value="${form.BUNDLE_NUM ? param.BUNDLE_NUM : form.BUNDLE_NUM}" width="${form_BUNDLE_NUM_W}" maxLength="${form_BUNDLE_NUM_M}" disabled="${form_BUNDLE_NUM_D}" readOnly="${form_BUNDLE_NUM_RO}" required="${form_BUNDLE_NUM_R}" style="${imeMode}" maskType="${form_BUNDLE_NUM_MT}" />
				</e:field>
				<%-- 계약일자 --%>
				<e:label for="CONT_DATE" title="${form_CONT_DATE_N}"/>
				<e:field>
					<e:inputDate id="CONT_DATE" name="CONT_DATE" value="${form.CONT_DATE}" width="${inputDateWidth}" datePicker="true" required="${form_CONT_DATE_R}" disabled="${form_CONT_DATE_D}" readOnly="${form_CONT_DATE_RO}"/>
				</e:field>
				<%-- 계약기간 --%>
				<e:label for="CONT_START_DATE" title="${form_CONT_START_DATE_N}"/>
				<e:field>
					<e:inputDate id="CONT_START_DATE" name="CONT_START_DATE" toDate="CONT_END_DATE" value="${form.CONT_START_DATE}" width="${inputDateWidth}" datePicker="true" required="${form_CONT_START_DATE_R}" disabled="${form_CONT_START_DATE_D}" readOnly="${form_CONT_START_DATE_RO}"/>
					<e:text>~</e:text>
					<e:inputDate id="CONT_END_DATE" name="CONT_END_DATE" fromDate="CONT_START_DATE" value="${form.CONT_END_DATE}" width="${inputDateWidth}" datePicker="true" required="${form_CONT_END_DATE_R}" disabled="${form_CONT_END_DATE_D}" readOnly="${form_CONT_END_DATE_RO}"/>
				</e:field>
			</e:row>
			<e:row>
				<%-- 계약명 --%>
				<e:label for="CONT_DESC" title="${form_CONT_DESC_N}"/>
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
					<e:inputNumber id="CONT_AMT" name="CONT_AMT" value="${form.CONT_AMT}" width="40%" maxValue="${form_CONT_AMT_M}" decimalPlace="${form_CONT_AMT_NF}" disabled="${form_CONT_AMT_D}" readOnly="${form_CONT_AMT_RO}" required="${form_CONT_AMT_R}" onNumberKr="${form_CONT_AMT_KR}" currencyText="${form_CONT_AMT_CT}"/>
					<e:select id="CUR" name="CUR" value="${form.CUR}" options="${curOptions}" width="20%" disabled="${form_CUR_D}" readOnly="${form_CUR_RO}" required="${form_CUR_R}" placeHolder="" maskType="${form_CUR_MT}" onChange="onChangeCUR"/>
					<e:select id="VAT_TYPE" name="VAT_TYPE" value="${form.VAT_TYPE}" options="${vatTypeOptions}" width="40%" disabled="${form_VAT_TYPE_D}" readOnly="${form_VAT_TYPE_RO}" required="${form_VAT_TYPE_R}" placeHolder="" maskType="${form_VAT_TYPE_MT}" onChange="onChangeVAT_TYPE"/>
					<e:inputHidden id="VAT_TYPE_NM" name="VAT_TYPE_NM"/>
				</e:field>
				<%-- 고객사 --%>
				<e:label for="PR_BUYER_DEPT_NM" title="${form_PR_BUYER_DEPT_NM_N}"/>
				<e:field>
					<e:search id="PR_BUYER_DEPT_NM" name="PR_BUYER_DEPT_NM" value="${form.PR_BUYER_DEPT_NM}" width="${form_PR_BUYER_DEPT_NM_W}" maxLength="${form_PR_BUYER_DEPT_NM_M}" onIconClick="${form.detailView ? '' : 'getPrBuyerDeptNm'}" disabled="${form_PR_BUYER_DEPT_NM_D}" readOnly="${form_PR_BUYER_DEPT_NM_RO}" required="${form_PR_BUYER_DEPT_NM_R}" maskType="${form_PR_BUYER_DEPT_NM_MT}"/>
				</e:field>
			</e:row>
			<e:row>
				<%-- 인증서종류 --%>
				<e:label for="CERT_TYPE" title="${form_CERT_TYPE_N}"/>
				<e:field colSpan="3">
					<e:select id="CERT_TYPE" name="CERT_TYPE" value="${form.CERT_TYPE}" options="${certTypeOptions}" width="${form_CERT_TYPE_W}" disabled="${form_CERT_TYPE_D}" readOnly="${form_CERT_TYPE_RO}" required="${form_CERT_TYPE_R}" placeHolder="" maskType="${form_CERT_TYPE_MT}" onChange="onChangeCertType"/>
				</e:field>
				<%-- 계약담당자 --%>
				<e:label for="CONT_USER_NM" title="${form_CONT_USER_NM_N}"/>
				<e:field>
					<e:inputText id="CONT_USER_NM" name="CONT_USER_NM" value="${form.CONT_USER_NM}" width="${form_CONT_USER_NM_W}" maxLength="${form_CONT_USER_NM_M}" disabled="${form_CONT_USER_NM_D}" readOnly="${form_CONT_USER_NM_RO}" required="${form_CONT_USER_NM_R}" style="${imeMode}"	maskType="${form_CONT_USER_NM_MT}"/>
					<e:inputHidden id="CONT_USER_ID" name="CONT_USER_ID" value="${form.CONT_USER_ID}"/>
				</e:field>
			</e:row>
			<e:row>
				<%-- 비고 --%>
				<e:label for="CONT_RMK" title="${form_CONT_RMK_N}"/>
				<e:field colSpan="5">
					<e:inputText id="CONT_RMK" name="CONT_RMK" value="${form.CONT_RMK}" width="${form_CONT_RMK_W}" maxLength="${form_CONT_RMK_M}" disabled="${form_CONT_RMK_D}" readOnly="${form_CONT_RMK_RO}" required="${form_CONT_RMK_R}" style="${imeMode}" maskType="${form_CONT_RMK_MT}"/>
				</e:field>
			</e:row>
		</e:searchPanel>
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
						<e:gridPanel gridType="${_gridType}" id="gridM" name="gridM" width="100%" height="${formSelGridHeight}"/>
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
						<e:gridPanel gridType="${_gridType}" id="gridA" name="gridA" width="100%" height="${formSelGridHeight}"/>
					</div>
				</div>
			</div>
		</div>

		<e:title title="첨부파일"/>
		<e:searchPanel id="form2" title="${form_CAPTION_N }" columnCount="2" labelWidth="125" onEnter="doSearch" useTitleBar="false">
			<e:row>
				<c:set var="attFileEditable" value="${empty form.PROGRESS_CD or form.ATT_FILE_EDITABLE eq 'true'}"/>
				<e:label for="ATT_FILE_NUM" title="${form_ATT_FILE_NUM_N}"/>
				<e:field>
					<e:fileManager id="ATT_FILE_NUM" height="100" width="100%" fileId="${form.ATT_FILE_NUM}" readOnly="${not attFileEditable}" bizType="EC" required="false" uploadable="${attFileEditable}"/>
				</e:field>
				<e:label for="VENDOR_ATT_FILE_NUM" title="${form_VENDOR_ATT_FILE_NUM_N}"/>
				<e:field>
					<e:fileManager id="VENDOR_ATT_FILE_NUM" height="100" width="100%" fileId="${form.VENDOR_ATT_FILE_NUM}" readOnly="true" bizType="EC" required="false" uploadable="false"/>
				</e:field>
			</e:row>
		</e:searchPanel>
		
		<%-- 협력사 Grid --%>
		<e:gridPanel gridType="${_gridType}" id="gridV" name="gridV" width="100%" height="fit"/>
		
		<e:buttonBar id="contButtons" align="right" width="100%">
			<c:if test="${not param.detailView eq 'true'}">
				<e:button id="doSave" name="doSave" label="${doSave_N}" onClick="doSave" disabled="${doSave_D}" visible="${doSave_V}"/>
				<e:button id="doSend" name="doSend" label="${doSend_N}" onClick="doSend" disabled="${doSend_D}" visible="${doSend_V}"/>
			</c:if>
			<%-- 4210 : 협력사 서명대기 --%>
			<c:if test="${not param.detailView eq 'true' and not editableStatus eq 'true' and form.PROGRESS_CD eq '4210'}">
				<e:button id="doSign" name="doSign" label="${doSign_N}" onClick="doSign" disabled="${doSign_D}" visible="${doSign_V}"/>
			</c:if>
			<%-- 4230 : 고객사 서명완료 --%>
			<c:if test="${not param.detailView eq 'true' and not editableStatus eq 'true' and form.PROGRESS_CD eq '4230'}">
				<e:button id="doCustSign" name="doCustSign" label="${doCustSign_N}" onClick="doCustSign" disabled="${doCustSign_D}" visible="${doCustSign_V}"/>
			</c:if>
			<c:if test="${not param.detailView eq 'true'}">
				<e:button id="doDelete" name="doDelete" label="${doDelete_N}" onClick="doDelete" disabled="${doDelete_D}" visible="${doDelete_V}"/>
			</c:if>
		</e:buttonBar>
		
		<%-- 결재자 리스트 Include --%>
		<c:if test="${(empty param.singleFlag or param.singleFlag eq '0')}">
			<jsp:include page="/WEB-INF/views/nhepro/CWOR/CWOR0013.jsp" flush="true" >
				<jsp:param value="${form.APP_DOC_NUM}" name="APP_DOC_NUM"/>
				<jsp:param value="${form.APP_DOC_CNT}" name="APP_DOC_CNT"/>
				<jsp:param value="${form.BUYER_CD}" name="BUYER_CD"/>
			</jsp:include>
		</c:if>

		<form id='reqForm' name='reqForm' method='post' action="/MagicLine4Web/ML4Web/jcaosCheck.jsp">
			<input type="hidden" id="signData" name="signData" value=""/>
			<input type="hidden" id="signedData" name="signedData"/>
			<input type="hidden" id="vidRandom" name="vidRandom"/>
			<input type="hidden" id="vidType" name="vidType" value="client"/>
			<input type="hidden" id="idn" name="idn" value="${ses.irsNum}"/>
			<input type="hidden" id="useCard" name="useCard" value=""/>
		</form>
		
		<%-- 2021.08.30 : 계약번호 클릭 후 들어오는 화면에서는 결재정보 비노출 --%>
		<div id="dscertContainer">
			<iframe id="dscert" name="dscert" src="" width="100%" height="100%" frameborder="0" allowTransparency="true" style="position:fixed;z-index:100010;top:0px;left:0px;width:100%;height:100%;"></iframe>
		</div>
		<br>
	</e:window>
</e:ui>