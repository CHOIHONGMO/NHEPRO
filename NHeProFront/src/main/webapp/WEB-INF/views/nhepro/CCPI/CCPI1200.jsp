<!--

화면ID : CCPI1200
화면명 : 계약서작성(단기간 근로계약서)
작성자 : 백태훈
생성일 : 2022.09.14

  -->
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

<%-- 계약서 첨부파일 가능상태 : 계약체결완료 상태 --%>
<c:set var="attachableStatus"  value="${(form.PROGRESS_CD == '4300')}"/>

<%-- 수정가능상태에 따라 그리드 높이를 조절하기 위한 변수 --%>
<c:set var="formSelGridHeight"  value="${(!param.detailView and editableStatus) ? '160' : '100'}"/>
<c:set var="formSelPanelHeight" value="${(!param.detailView and editableStatus) ? '220' : '160'}"/>

<e:ui>
	<script type="text/javascript" src="/MagicLine4Web/ML4Web/js/ext/jquery.blockUI.js"></script>
	<script type="text/javascript" src="/MagicLine4Web/ML4Web/js/ext/ML_Config.js"></script>
	<script type="text/javascript">  
	
	var gridM; // 주서식 Grid
	var gridA; // 부서식 Grid
	var gridV; // 근로자 Grid
	
	var baseUrl = "/nhepro/CCPI/CCPI1200";
	var detailView = "${param.detailView}" == "true";
	var isDetailView = ('${editableStatus}' === 'true' ? false : true);
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
		gridV.setProperty("shrinkToFit", false);
		gridV.setProperty("rowNumbers", ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
		gridV.setProperty("sortable", ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
		gridV.setProperty("panelVisible", ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
		gridV.setProperty("enterToNextRow", ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
		gridV.setProperty("acceptZero", ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
		gridV.setProperty("multiSelect", ${multiSelect});		// [선택] 컬럼의 사용여부를 지정한다. [true/false]
		gridV.setProperty("singleSelect", ${singleSelect});
		
 		gridV.setColGroup([
 			{
                "groupName": '교육시작시간',
                "columns": ['EDU_TIME_START_HOUR', 'EDU_TIME_START_MIN']
            }
            ,{
                "groupName": '교육종료시간',
                "columns": ['EDU_TIME_END_HOUR', 'EDU_TIME_END_MIN']
            }
            ,{
                "groupName": '근무일자',
                "columns": ['DAY1','DAY2','DAY3','DAY4','DAY5','DAY6','DAY7','DAY8','DAY9','DAY10',
                			'DAY11','DAY12','DAY13','DAY14','DAY15','DAY16','DAY17','DAY18','DAY19','DAY20',
                			'DAY21','DAY22','DAY23','DAY24','DAY25','DAY26','DAY27','DAY28','DAY29','DAY30',
                			'DAY31']
            }
        ],50); 

		// 부서식(추가서식)은 전체선택이 없음
		//gridA._gvo.setCheckBar({showAll: false});
		
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
		
		//개인근로자 Grid
		gridV.cellClickEvent(function (rowIdx, colId, value) {
			var param;
			/*
			if(colId == "SPECIAL_CONDITION") {
               var param = {
            		   callbackFunction: 'setRMK',
                        title: "특수조건",
                        message: gridV.getCellValue(rowIdx, 'SPECIAL_CONDITION'),
                        rowIdx: rowIdx,
                        detailView: isDetailView
                    };
                everPopup.commonTextInput(param);
			}*/
			
			if(colId == "CONT_NUM") {
				if (value == '') return;
				var CONT_NUM = gridV.getCellValue(rowIdx, 'CONT_NUM');
				var CONT_CNT = gridV.getCellValue(rowIdx, 'CONT_CNT');
				var EMP_ATT_FILE_NUM = gridV.getCellValue(rowIdx, 'EMP_ATT_FILE_NUM');
				var GRD_PROGRESSCD = gridV.getCellValue(rowIdx, 'PROGRESS_CD');
				onContNumAndCnt(CONT_NUM, CONT_CNT, EMP_ATT_FILE_NUM,GRD_PROGRESSCD);
				console.log("==="+EMP_ATT_FILE_NUM+"====");
			}
			
			if( colId == "EMP_ATT_FILE_CNT"){
				//if( value == 0 ) return;
				param = {
					bizType: 'TC',
					attFileNum: gridV.getCellValue(rowIdx, 'EMP_ATT_FILE_NUM'),
					//detailView: ${(!param.detailView or editableStatus) ? false : true},
					detailView: ${"{form.PROGRESS_CD}" == "4300"  ? true : false},
					rowIdx: rowIdx,
					callBackFunction: 'setEmpAttFileNum',
					fileExtension: 'PDF',
					maxFileSize : '5mb'
				
				};
				everPopup.fileAttachPopup(param);
				
				}
			
			
			
		});
		
		//개인근로자 Grid 삭제
		if( ${!param.detailView and editableStatus} ){
			gridV.delRowEvent(function() {
				if (gridV.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
				gridV.delRow();
            });
        }

		// 주서식조회
		doSearchForm();
		// 폼 셋팅
		doSetDefaultForm();
		
	    // 개인근로자 회원승인 화면에서 데이터 가져오는 경우(미사용)
	    if( '${param.userInfo}' != undefined && '${param.userInfo}' != '' ){
	    	var jsonData = JSON.parse('${param.userInfo}');
	    	_setEmployee(jsonData);
	    }
	    
	    //gridV.setColIconify("SPECIAL_CONDITION", "SPECIAL_CONDITION", "comment", true);
	 
	    // 개인근로자 조회
 		if (EVF.V("BUNDLE_NUM") != "") {
			doSearchEmployee();
		}
	    
		if ( "${form.PROGRESS_CD}" == "4300" ) { //계약체결완료
			gridV.hideCol('EMP_ATT_FILE_CNT', false);
		}else{
			gridV.hideCol('EMP_ATT_FILE_CNT', true);
		}
	
	} //init 종료
	

	//개인근로자 파일 첨부 후 셋팅
	function setEmpAttFileNum(rowIdx, fileId, fileCnt) {
			
		gridV.setCellValue(rowIdx, 'EMP_ATT_FILE_CNT', fileCnt);
		gridV.setCellValue(rowIdx, 'EMP_ATT_FILE_NUM', fileId);
	
	}
	
	// 개인근로자 조회
	function doSearchEmployee() {
		
		var store = new EVF.Store();
		store.setGrid([gridV]);
		store.load(baseUrl + "/ccpi1200_getSavedEmpListForBundleContract.so", function () {
			
		}, false);
	}
	
	function doSetDefaultForm(){
		
		//EVF.V("CONT_USER_NM", "${ses.userNm}"); // 계약담당자 셋팅
	}
	

	function setButtons() {
		if( ${!param.detailView} ){
			EVF.C('doSave').setVisible(false);
       		EVF.C('doSend').setVisible(false);
       		EVF.C('doEmpAdd').setVisible(false);
       		EVF.C('doSavePdf').setVisible(false);
       		EVF.C('doDelete').setVisible(false); // 삭제
       		EVF.C('doCopy').setVisible(false); //복사
       		
       		
    		if ( "${form.PROGRESS_CD}" == "4300" ) { //계약체결완료
       		    EVF.C('doSavePdf').setVisible(true);
    		 } 

		<c:if test="${editableStatus}">

			EVF.C('doSave').setVisible(true); 		// 저장
			EVF.C('doSend').setVisible(true); 		// 결재상신
			EVF.C('doEmpAdd').setVisible(true);    //근로자 추가
			EVF.C('doDelete').setVisible(true); // 삭제
			EVF.C('doCopy').setVisible(true); //복사
			EVF.C('doSavePdf').setVisible(false);
			
		</c:if>
		}
		if ( "${form.PROGRESS_CD}" > "4200") { //임시저장 
   		    EVF.C('doEmpAdd').setVisible(false);
   		 	EVF.C('doCopy').setVisible(false); //복사
		 } 
	}
	
	function SetOZParamters_OZViewer(param) {
		var url = "${ozUrl}" + "/ozhviewer_canvas_eform2.jsp";
		everPopup.openWindowPopup(url, 850, 1265, param, 'eform');
	}
	
	//저장 
	function doSave() {
		
		// 화면 validation 체크하기 
		if (!checkFormValidation()) {
			
			return;
		}
		
		
		EVF.confirm("${msg.M0021 }", function () {
			
			var store = new EVF.Store();
			store.setGrid([gridM, gridA, gridV]);
			store.getGridData(gridM, 'sel'); // 주서식
			store.getGridData(gridA, 'sel'); // 추가서식
			store.getGridData(gridV, 'all'); // 개인근로자
			store.doFileUpload(function () {
				store.load(baseUrl + "/ccpi1200_doSave.so", function () {
					
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
	
	//결재상신 
	function doSend() {
		var store = new EVF.Store();
		if (!store.validate()) { return; }

		var signStatus = EVF.V("SIGN_STATUS") == "" ? "T" : EVF.V("SIGN_STATUS");
		console.log("sign_status------" + signStatus);
		<%-- 결재상태 --%>
		if (signStatus == "T") {
			EVF.confirm("결재상신 하시겠습니까?", function () {
				/*var contAmt = EVF.V("CONT_AMT");
				if (contAmt == null || contAmt == "") {
					contAmt = "0";
				}*/
				
				var param = {
					subject: gridM.getSelRowValue()[0].FORM_NM,
					docType: "TC",
					signStatus: signStatus,
					screenId: "CCPI1200",
					approvalType: 'APPROVAL',
					attFileNum: "",
					docNum: EVF.V('APP_DOC_NUM'),
					docCnt: EVF.V('APP_DOC_CNT'),
					callBackFunction: "goApproval",
					//appAmt: eval(contAmt)
				};
				everPopup.openApprovalRequestIPopup(param);
			});
		}
	}
	
	<%-- 저장을 하기 전에 입력되지 않은 폼이 있는지 확인해주는 체크함수 --%>
	function checkFormValidation() {

		var store = new EVF.Store();
		if (!store.validate()) {
			return false;
		}

		if (!gridV.isExistsRow()) {
			return EVF.alert("${CCPI1200_004}");
		}
		
		if (!gridV.validate().flag) {
			return EVF.alert(gridV.validate().msg);
		}

		var rowIds = gridV.getAllRowId();
		for (var i = 0; i < rowIds.length; i++) {
			
			var contDate =  gridV.getCellValue(rowIds[i], 'CONT_DATE');
			var contStartDate = gridV.getCellValue(rowIds[i], 'CONT_START_DATE');
			var contEndDate = gridV.getCellValue(rowIds[i], 'CONT_END_DATE');
			
			var date1 = contStartDate.slice(0,4)+'-'+contStartDate.slice(4,6)+'-'+contStartDate.slice(6,8);
			var date2 = contEndDate.slice(0,4)+'-'+contEndDate.slice(4,6)+'-'+contEndDate.slice(6,8);
			
			leapYear1(contStartDate.slice(0,4));
		    leapYear2(contEndDate.slice(0,4));
		    
		    var contStr = leapYear1(contStartDate.slice(0,4))
		    var contEnd = leapYear2(contEndDate.slice(0,4))
		    
			if( contStr == 'leap') {
		    	if(contStartDate.slice(4,8) < '0301') {
		    		var day = 365;	
		    	} else {
		    		var day = 364;
		    	}
		    } else if( contEnd == 'leap' ) {
		    	if(contEndDate.slice(4,8) >= '0229') {
		    		var day = 365;	
		    	} else {
		    		var day = 364;
		    	}
			} else {
				var day = 364;
			}
		    
			if(dateDiff(date1,date2) > day){
				return EVF.alert("계약종료기간은 계약시작일자로부터 1년 이내로 입력되어야합니다.");
			}
			
			if(contDate >contStartDate){
				return EVF.alert("계약시작일자는 계약일자보다 크거나 같아야합니다.");
			}
			
			if( contStartDate > contEndDate){
    			return EVF.alert("${CCPI1200_005}");
    		}
			
        	for(var j = i + 1; j < rowIds.length; j++) {
                if(gridV.getCellValue(rowIds[i], 'USER_ID') === gridV.getCellValue(rowIds[j], 'USER_ID')) {
                	return EVF.alert("${CCPI1200_003}");
                }
        	}
		}
		return true;
	}
	
	function leapYear1(yearStr) {
		var str = ''
		var year = yearStr;
		if( year%4 == 0) {
			str = 'leap';
		} else {
			str = 'nonleap';
		}
		return str
	}
	
	function leapYear2(yearStr) {
		var str = ''
		var year = yearStr;
		if( year%4 == 0) {
			str = 'leap';
		} else {
			str = 'nonleap';
		}
		return str
	}
	
	function doCopy() {
		
		var rowIds = gridV.getAllRowId();
		var selectedRow = gridV.getSelRowId();
		var cnt = gridV.getSelRowCount();
		
		if (cnt == 0) { return EVF.alert("${msg.M0004}"); }
		else if(cnt>1) //복사할 셀 한개만 선택 후 복사선택 알림창 메시지
		{
			return EVF.alert("모든 근로자에 일괄적용할 항목을 1개만 선택해주시길 바랍니다.");
		}	
		
		//행복사 항목 : 근로시간 , 휴게시간
		EVF.confirm('${CCPI1200_009}', function() {

				for(var i in rowIds) {
					gridV.setCellValue(i, "WORK_CONDITION", gridV.getCellValue(selectedRow, 'WORK_CONDITION'));
					gridV.setCellValue(i, "WORK_TIME_HOUR", gridV.getCellValue(selectedRow, 'WORK_TIME_HOUR'));
					gridV.setCellValue(i, "WORK_TIME_MIN", gridV.getCellValue(selectedRow, 'WORK_TIME_MIN'));
					gridV.setCellValue(i, "REST_TIME_HOUR", gridV.getCellValue(selectedRow, 'REST_TIME_HOUR'));
					gridV.setCellValue(i, "REST_TIME_MIN", gridV.getCellValue(selectedRow, 'REST_TIME_MIN'));
					
					gridV.setCellValue(i, "CONT_DATE", gridV.getCellValue(selectedRow, 'CONT_DATE'));
					gridV.setCellValue(i, "CONT_START_DATE", gridV.getCellValue(selectedRow, 'CONT_START_DATE'));
					gridV.setCellValue(i, "CONT_END_DATE", gridV.getCellValue(selectedRow, 'CONT_END_DATE'));
				}
		});
    }
	
	// 두개의 날짜를 비교하여 차이를 알려준다.
	function dateDiff(_date1, _date2) {
		var diffDate_1 = _date1 instanceof Date ? _date1 : new Date(_date1);
		var diffDate_2 = _date2 instanceof Date ? _date2 : new Date(_date2);

		diffDate_1 = new Date(diffDate_1.getFullYear(), diffDate_1.getMonth(), diffDate_1.getDate());
		diffDate_2 = new Date(diffDate_2.getFullYear(), diffDate_2.getMonth(), diffDate_2.getDate());

		var diff = Math.abs(diffDate_2.getTime() - diffDate_1.getTime());
		diff = Math.ceil(diff / (1000 * 60 * 60 * 24)); //밀리세컨 * 초  * 분 * 시 = 1일

		return diff;
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
		
		var store = new EVF.Store();
		store.setAsync(false);
		store.setGrid([gridM, gridA, gridV]);
		store.getGridData(gridM, "sel");
		store.getGridData(gridA, "sel");
		store.getGridData(gridV, "all"); // 근로자
		store.doFileUpload(function () {
			store.load(baseUrl + "/ccpi1200_doReqSign.so", function () {
				// 저장 완료 후 ozd, pdf 저장
				var bundleNum = this.getParameter('BUNDLE_NUM');
				var contType  = this.getParameter("CONT_TYPE");
				if (opener) {
					opener.doSearch();
					doClose();
				} else {
					location.href = baseUrl + "/view.so";
				}
				//eformScheduler(bundleNum, contType, 'P');
			});
		});
	}
	
	// 삭제
	function doDelete() {
		EVF.confirm("${msg.M0013}", function () {
			var store = new EVF.Store();
			store.setGrid([gridV]);
			store.getGridData(gridV, 'all');
			store.load(baseUrl + "/ccpi1200_doDeleteBundleContract.so", function () {
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

	//첨부파일 저장 
	function doSavePdf() {
		//첨부파일 저장 
		EVF.confirm("${msg.M0021 }", function () {
			
			var store = new EVF.Store();
			store.setGrid([gridM, gridA, gridV]);
			store.getGridData(gridV, 'sel'); // 개인근로자
			store.doFileUpload(function () {
				store.load(baseUrl + "/ccpi1200_doSavePdf.so", function () {
					
					// 임시 저장시 pdf 생성 제외 : 계약번호 클릭시 생성되는 팝업에서 자동 생성함
					var bundleNum = this.getParameter('BUNDLE_NUM');
					var contType  = this.getParameter("CONT_TYPE");
					
					EVF.alert('${msg.M0031}');
					location.href = baseUrl + "/view.so?BUNDLE_NUM=" + bundleNum + "&CONT_TYPE=" + contType + "&singleFlag=0";
					if(opener) {
						opener['doSearch']();
					}
				});
			});
		});
		
    }
	
	function doEmpAdd() {
    	var param = {
    			'callBackFunction' : "_setEmployee",
    			//'SITE_USER_ID' : contUserId
            };
    	everPopup.openCommonPopup(param, 'MP0024');
    }
    
    function _setEmployee(jsonData) {
    	
    	var curDate = '${toDate}';
    	var startHour = '09';
    	var startMin = '00';
    	var workHour = '08';
    	var workMin = '00';
    	var restHour = '01';
    	var restMin = '00';
    	
   		 for( idx in jsonData ){
   			 
   			var gplace = "";
   			if(jsonData[idx].CUST_NAME != ''  && jsonData[idx].CUST_NAME  != null){
   				gplace += jsonData[idx].CUST_NAME;
   				gplace += "(";
   			}
   			
   			if(jsonData[idx].SUBCUST_NAME != ''  && jsonData[idx].SUBCUST_NAME  != null){
   				gplace += jsonData[idx].SUBCUST_NAME;
   				gplace += ")";
   			}
   			
       		var addParam = [{
        			"USER_ID": jsonData[idx].USER_ID,
        			"USER_NM": jsonData[idx].USER_NM,
        			"GENDER"   : jsonData[idx].GENDER,
        			"CONT_DATE" : curDate,
        			"CONT_START_DATE" : curDate,
        			"CONT_END_DATE" : curDate,
        			"BIRTH_DATE" : jsonData[idx].BIRTH_DATE,
 					"WORK_TIME_HOUR" : workHour,
 					"WORK_TIME_MIN" : workMin,
 					"REST_TIME_HOUR" : restHour,
 					"REST_TIME_MIN" : restMin,
 					"EMP_ATT_FILE_CNT" : "0",
 					"CONT_TYPE" : 3,
 					"CELL_NUM" : jsonData[idx].CELL_NUM,
 					"K_ADDR" : jsonData[idx].ADDR_1,
 					"G_PLACE" : gplace,
 					"JIKMU_NAME" : jsonData[idx].JIKMU_NAME,
 					"DAY_OR_HOUR_PAY" : jsonData[idx].DAY_OR_HOUR_PAY,
 					"EDU_TIME_START_HOUR" : '00',
 					"EDU_TIME_START_MIN" : '00',
 					"EDU_TIME_END_HOUR" : '00',
 					"EDU_TIME_END_MIN" : '00',
 					"CUST_NAME" : jsonData[idx].CUST_NAME,
 					"SUBCUST_NAME" : jsonData[idx].SUBCUST_NAME
    			}];
        	gridV.addRow(addParam);
       	} 
   		gridV.checkAll(false);//근로자 그리드 체크해제
    }
    /*
    function setRMK(data) {
        gridV.setCellValue(data.rowIdx, "SPECIAL_CONDITION", data.message);
    }*/
    
	function doClose() {
		EVF.closeWindow();
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
		//store.load("/nhepro/CCTR/CCTA0030/ccta0030_doSearchMainForm.so", function () {
		  store.load(baseUrl + "/ccpi1200_doSearchMainForm.so", function () {
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
			store.load(baseUrl + "/ccpi1200_doSearchAdditionalForm.so", function () {	
				
				var rowIds = gridA.getAllRowId();
				// 부서식의 기본선택여부 및 필수여부인 경우 체크를 해준다.
				if(EVF.V("BUNDLE_NUM") == "") {
					for(var i in rowIds) {
						if (gridA.getCellValue(rowIds[i], "DEFAULT_FLAG") == "1" || gridA.getCellValue(rowIds[i], "REQUIRE_FLAG") == "1") {
							gridA.checkRow(rowIds[i], true, false, false);
							}
						}	
				} else {
					for(var i in rowIds) {
						if (gridA.getCellValue(rowIds[i], "EXISTS_FLAG") == "1") {
							gridA.checkRow(rowIds[i], true, false, false);
						}
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
	
	// 계약번호 클릭시 팝업창
	// 임시저장(4200) 인 경우 oz 폼을 보여줌
	var winPop;
	function onContNumAndCnt(CONT_NUM, CONT_CNT, EMP_ATT_FILE_NUM, GRD_PROGRESSCD) {
		
		/* 		if(!gridM.isExistsSelRow()) {
					return EVF.alert('선택된 계약서식이 존재하지 않습니다.');
				} */
				
				// 2021.05.18 변경
				// 변경 및 연장 계약서 기능 추가에 따른 변경
				if( CONT_NUM != "" && CONT_CNT != "" ) {
					if ("${form.PROGRESS_CD}" == "4300" && GRD_PROGRESSCD =="4300") {//4300:근로자 서명완료				
						//pdfAttFileNum
						
						var pdfAttFileNum = "";
					
						var store = new EVF.Store();
						store.setAsync(false);
						store.setParameter("CONT_NUM", CONT_NUM);
						store.load(baseUrl + '/ccpi1200_doSelectPdfJsonData.so', function() {
							pdfAttFileNum = this.getParameter("PDF_VALUE");
							
						});

						var contNum = CONT_NUM;
						var contCnt = CONT_CNT;
						
						
						var url = "/common/file/fileAttach/viewPdf.so?EVER_REQUEST_DATA_TYPE=FILE_DOWNLOAD&UUID=" + pdfAttFileNum + "&CONT_NUM=" + contNum + "&CONT_CNT=" + contCnt;
						url = XSSCheck(url, 1);
						
						// 2021.08.23 : 익스플로러 : 동일 name의 팝업이 2개 이상 열리는 버그로 인해...
						//window.open(url, "eform", "width=850,height=1265,scrollbars=yes,resizeable=no,left=0,top=0");
						if(!winPop || (winPop && winPop.closed)){
							winPop = window.open(url, "eform", "width=850,height=1265,scrollbars=yes,resizeable=no,left=0,top=0");
						} else {
							winPop.location.href = url;
						}
					} else {
						ozdViewAndSave(CONT_NUM, CONT_CNT, EMP_ATT_FILE_NUM);
					}
				}
			}
	
	// 임시저장인 경우에는 EFORM 데이터를 저장할 수 있음
	function ozdViewAndSave(CONT_NUM, CONT_CNT, EMP_ATT_FILE_NUM) {
/* 		var eformInputValue = "";
		
		var store = new EVF.Store();
		store.setAsync(false);
		store.load(baseUrl + '/ccta0030_doSelectEformJsonData.so', function() {
			eformInputValue = this.getParameter("EFORM_INPUT_VALUE_CLOB");
		}); */

		// 서브 폼 파일명을 가져온다.
		var subFormFileNm = "";
		for(var i in gridA.getSelRowValue()) {
			var value = gridA.getSelRowValue()[i];
			subFormFileNm += value.FORM_FILE_NM + ",";
		}

		// 파일이 첨부되어 있는 경우 서브 페이지를 호출한다.
		var fileCnt = EMP_ATT_FILE_NUM;
		if (fileCnt > 0) {
			subFormFileNm += "BS_FILE_INFO" + ",";
		}

		// ozd 호출
		var contNum = CONT_NUM;
		var contCnt = CONT_CNT;
		var param = {
				bizType: "TC",
                BUYER_CD: "${ses.companyCd}",
				CONT_NUM: contNum,
				CONT_CNT: contCnt,
				SUB_FORM_FILE_NM: subFormFileNm.substring(0, subFormFileNm.length - 1),
				odiName: "CONTRACT",
				ozrName: gridM.getSelRowValue()[0].FORM_FILE_NM,
				// OZ Scheduler Info
				serverUrl: "${ozServer}",
				schedulerIp: "${ozSchedulerIp}",
				schedulerPort: "${ozSchedulerPort}",
				exportFileName: "${ses.companyCd}" + contNum + contCnt,
				exportFormat: "ozr",
				url: "${ozUrl}",
				ozExportUrl: "${ozExportUrl}"
		};
		
		// 2021.08.23 : 익스플로러 : 동일 name의 팝업이 2개 이상 열리는 버그로 인해...
		// var url = "${ozUrl}" + "/ozhviewer_canvas_eform.jsp";

			var url = "${ozUrl}" + "/ozhviewer_canvas_eform2.jsp?"+ $.param(param);
			url = XSSCheck(url, 1);
			if(!winPop || (winPop && winPop.closed)){
				//winPop = window.open(url, "eform", "width=850,height=1265,scrollbars=yes,resizeable=no,left=0,top=0");
				url = "${ozUrl}" + "/ozhviewer_canvas_eform2.jsp";
				everPopup.openWindowPopup(url, 850, 1265, param, 'eform');
			} else {
				winPop.location.href = url;
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
 	
	function doReset() {
		EVF.confirm("초기화 하시겠습니까?", function () {
			location.href = baseUrl + "/view.so"; 	
	    	});
	}
	</script>
	
 	
	<e:window id="CCPI1200" onReady="init" initData="${initData}" title="${fullScreenName }" breadCrumbs="${breadCrumb }" margin="0 4px">
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
		<!--	
			<e:button id="doClose" name="doClose" label="${doClose_N}" onClick="doClose" disabled="${doClose_D}" visible="${doClose_V}"/>
	    -->
		</c:if>
		<c:if test="${not param.detailView eq 'true'}">
			<e:button id="doSave" name="doSave" label="${doSave_N}" onClick="doSave" disabled="${doSave_D}" visible="${doSave_V}"/>
			<e:button id="doSend" name="doSend" label="${doSend_N}" onClick="doSend" disabled="${doSend_D}" visible="${doSend_V}"/>
		 
			<e:button id="doDelete" name="doDelete" label="${doDelete_N}" onClick="doDelete" disabled="${doDelete_D}" visible="${doDelete_V}"/>
			
		</c:if>
	</e:buttonBar>
	
	<e:searchPanel id="form" title="계약정보" columnCount="2" labelWidth="135" onEnter="doSearch" useTitleBar="false">
		<e:row>
			<%-- 일괄계약번호 --%>
			<e:label for="BUNDLE_NUM" title="${form_BUNDLE_NUM_N}"/>
			<e:field>
				<e:inputText id="BUNDLE_NUM" name="BUNDLE_NUM" value="${form.BUNDLE_NUM ? param.BUNDLE_NUM : form.BUNDLE_NUM}" width="${form_BUNDLE_NUM_W}" maxLength="${form_BUNDLE_NUM_M}" disabled="${form_BUNDLE_NUM_D}" readOnly="${form_BUNDLE_NUM_RO}" required="${form_BUNDLE_NUM_R}" style="${imeMode}" maskType="${form_BUNDLE_NUM_MT}" />
			</e:field>
			<%-- 계약담당자 --%>
			<e:label for="CONT_USER_NM" title="${form_CONT_USER_NM_N}"/>
			<e:field>
				<e:inputText id="CONT_USER_NM" name="CONT_USER_NM" value="${empty form.CONT_USER_NM ? ses.userNm : form.CONT_USER_NM}" width="${form_CONT_USER_NM_W}" maxLength="${form_CONT_USER_NM_M}" disabled="${form_CONT_USER_NM_D}" readOnly="${form_CONT_USER_NM_RO}" required="${form_CONT_USER_NM_R}" style="${imeMode}"	maskType="${form_CONT_USER_NM_MT}"/>
				<e:inputHidden id="CONT_USER_ID" name="CONT_USER_ID" value="${form.CONT_USER_ID}"/>
			</e:field>
			
		</e:row>
	</e:searchPanel>
	
	<br/>
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
	
	<e:buttonBar id="empButtonBar" align="right" width="100%" title="개인근로자">
		<%--<c:if test="${!param.detailView and editableStatus}">  --%>
			<c:if test="${attachableStatus}"> PDF파일만 업로드 가능합니다.(최대 5MB)</c:if>
			<e:button id="doSavePdf" name="doSavePdf" label="${doSavePdf_N}" onClick="doSavePdf" disabled="${doSavePdf_D}" visible="${doSavePdf_V}"/>
			<e:button id="doEmpAdd" name="doEmpAdd" label="${doEmpAdd_N}" onClick="doEmpAdd" disabled="${doEmpAdd_D}" visible="${doEmpAdd_V}"/>
			<e:button id="doCopy" name="doCopy" label="${doCopy_N }" disabled="${doCopy_D }" onClick="doCopy" />
		<%-- </c:if>--%>
	</e:buttonBar>
	
	<e:gridPanel gridType="${_gridType}" id="gridV" name="gridV" width="100%" height="fit" />
	
	<e:buttonBar id="contButtons" align="right" width="100%">
			
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