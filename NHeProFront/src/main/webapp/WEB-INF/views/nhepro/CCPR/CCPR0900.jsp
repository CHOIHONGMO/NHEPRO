<!--

화면ID : CCPR0900
화면명 : 근로계약대상자조회
작성자 : 백태훈
생성일 : 2022.08.29

-->

<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page import="com.st_ones.everf.serverside.config.PropertiesManager" %>


<e:ui>
	<script type="text/javascript">

		var grid = {};
		var baseUrl = "/nhepro/CCPR/CCPR0900";
		var selRow;
		
		function init() {
			
			grid = EVF.C("grid");
			
			grid.setProperty("shrinkToFit", ${shrinkToFit});		// 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
			grid.setProperty("rowNumbers", ${rowNumbers});		    // 로우의 번호 표시 여부를 지정한다. [true/false]
			grid.setProperty("sortable", ${sortable});			    // 컬럼 정렬기능 사용여부를 지정한다. [true/false]
			grid.setProperty("panelVisible", ${panelVisible});	    // 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
			grid.setProperty("enterToNextRow", ${enterToNextRow}); // 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
			grid.setProperty("acceptZero", ${acceptZero});		    // 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
			grid.setProperty("multiSelect", ${multiSelect});		// [선택] 컬럼의 사용여부를 지정한다. [true/false]
			grid.setProperty("singleSelect", ${singleSelect});	    // [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]
			
			
			grid.cellClickEvent(function (rowIdx, colId, value) {

			});

			grid.excelExportEvent({
				allCol: "${excelExport.allCol}",
				fileName: "${screenName }"
			});

			//doSearch();
		}

		
		// 계약체결현황 조회
		function doSearch() {
			var store = new EVF.Store();
			if (!store.validate()) {
				return;
			}

			store.setGrid([grid]);
			store.load(baseUrl + '/doSearch.so', function () {
				if (grid.getRowCount() == 0) {
					EVF.alert("${msg.M0002 }");
				} 
			});
		}
		
 		// 개인근로자 승인
		function doConfirm() {
			if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0025}"); }
			console.log(this.data.data);
			
			var selRowIdx  = grid.getSelRowId();
			for(var i in selRowIdx) {
				var rowIdx = selRowIdx[i];
/* 				if (!${havePermission} && "${ses.userId}" != grid.getCellValue(rowIdx, "SITE_USER_ID")) {
					return EVF.alert("현장담당자만 처리할 수 있습니다.");
				} */
				if (grid.getCellValue(rowIdx, "PROGRESS_CD") != "P") {
					return EVF.alert("진행상태가 진행중인 건만 승인 및 반려가 가능합니다.");
				}
			}
			
			var progressCd = this.data.data;
			var msg = "${CCPR0900_001}"; // 승인
			if( progressCd =="R" ) {
				msg = "${CCPR0900_002}"; // 반려
			}
			
			var store = new EVF.Store();
			EVF.confirm(msg, function () {
				store.setParameter("progressCd", progressCd)
				store.setGrid([grid]);
				store.getGridData(grid, 'sel');
				store.load(baseUrl + '/ccpr0900_doConfirm.so', function () {
					EVF.alert(this.getResponseMessage(), function () {
						doSearch();
					});
				});
			});
		}
 		
		function doSave() {            
			var store = new EVF.Store();
			store.setGrid([grid]);
			store.getGridData(grid, 'sel');
			store.load(baseUrl + '/doSave.so', function () {
				EVF.alert(this.getResponseMessage(), function () {
					doSearch();
				});
			});
        }
		
		function doUpdate() {            
			var store = new EVF.Store();
			store.load(baseUrl + '/doUpdate.so', function () {
				if(this.getResponseCode() == "true"){
					return EVF.alert("erp 업데이트가 완료되었습니다.");
				}
				else{
					return EVF.alert("erp 업데이트를 실패하였습니다.");
				}
			});
        }

		//부서팝업
		function getDept() {
			var param = {
					callBackFunction: 'setDept',
					READONLY: 'Y',         //팝업 조회조건 변경불가
					multiYN : 'N',         //멀티팝업여부
					detailView: false
				};
			everPopup.openCommonPopup(param, 'SP0169');
		}

		function setDept(dept) {
			//dept = JSON.parse(dept);
			EVF.V("DEPT_CD", dept.DEPT_CD);
			EVF.V("DEPT_NM", dept.DEPT_NM);
		}
		
		//거래처팝업
		function getCust() {
			var param = {
					callBackFunction: 'setCust',
					READONLY: 'Y',         //팝업 조회조건 변경불가
					multiYN : 'N',         //멀티팝업여부
					detailView: false
				};
			everPopup.openCommonPopup(param, 'SP0168');
		}

		function setCust(cust) {
			EVF.V("CUST_CODE", cust.CUST_CODE);
			EVF.V("CUST_NAME", cust.CUST_NAME);
		}
		
		//현장팝업
		function getSubCust() {
			var param = {
					callBackFunction: 'setSubCust',
					READONLY: 'Y',         //팝업 조회조건 변경불가
					multiYN : 'N',         //멀티팝업여부
					detailView: false
				};
			everPopup.openCommonPopup(param, 'SP0170');
		}

		function setSubCust(subcust) {
			EVF.V("SUBCUST_CODE", subcust.SUBCUST_CODE);
			EVF.V("SUBCUST_NAME", subcust.SUBCUST_NAME);			
		}
		
	</script>
	
	<e:window id="CCPR0900" onReady="init" initData="${initData}" title="${fullScreenName }" breadCrumbs="${breadCrumb }">
		<e:searchPanel id="form" title="${msg.M9999 }" columnCount="3" labelWidth="130" onEnter="doSearch" useTitleBar="false">
			<e:inputHidden id="CONT_CLOSE_RMK" name="CONT_CLOSE_RMK" /> <!-- 계약체결중단사유 -->
			<e:row>
				<%--거래처--%>
				<e:label for="CUST_CODE" title="${form_CUST_CODE_N}"/>
				<e:field>
					<e:search id="CUST_CODE" name="CUST_CODE" value="" width="40%" maxLength="${form_CUST_CODE_M}" disabled="${form_CUST_CODE_D}" readOnly="${form_CUST_CODE_RO}" required="${form_CUST_CODE_R}" onIconClick="getCust" placeHolder="거래처" />
					<e:inputText id="CUST_NAME" name="CUST_NAME" value="" width="60%" maxLength="${form_CUST_NAME_M}" disabled="${form_CUST_NAME_D}" readOnly="${form_CUST_NAME_RO}" required="${form_CUST_NAME_R}" placeHolder="거래처명" />
				</e:field>
				<%--현장--%>
				<e:label for="SUBCUST_CODE" title="${form_SUBCUST_CODE_N}"/>
				<e:field>
					<e:search id="SUBCUST_CODE" name="SUBCUST_CODE" value="" width="40%" maxLength="${form_SUBCUST_CODE_M}" disabled="${form_SUBCUST_CODE_D}" readOnly="${form_SUBCUST_CODE_RO}" required="${form_SUBCUST_CODE_R}" onIconClick="getSubCust" placeHolder="현장" />
					<e:inputText id="SUBCUST_NAME" name="SUBCUST_NAME" value="" width="60%" maxLength="${form_SUBCUST_NAME_M}" disabled="${form_SUBCUST_NAME_D}" readOnly="${form_SUBCUST_NAME_RO}" required="${form_SUBCUST_NAME_R}" placeHolder="현장명" />
				</e:field>
				<%--근로자명--%>
				<e:label for="USER_NM" title="${form_USER_NM_N}"/>
				<e:field>					
					<e:inputText id="USER_NM" name="USER_NM" value="" width="100%" maxLength="${form_USER_NM_M}" disabled="${form_USER_NM_D}" readOnly="${form_USER_NM_RO}" required="${form_USER_NM_R}" placeHolder="근로자명" />
				</e:field>
			</e:row>
		</e:searchPanel>

		<e:buttonBar id="buttonBar" align="right" width="100%">
			<e:button id="doUpdate" name="doUpdate" label="${doUpdate_N}" onClick="doUpdate" disabled="${doUpdate_D}" visible="${doUpdate_V}"/>
			<e:button id="doSearch" name="doSearch" label="${doSearch_N }" disabled="${doSearch_D }" onClick="doSearch" />
			<e:button id="doSave" name="doSave" label="${doSave_N}" onClick="doSave" disabled="${doSave_D}" visible="${doSave_V}"/>
			<e:button id="doConfirm" name="doConfirm" label="${doConfirm_N}" onClick="doConfirm" disabled="${doConfirm_D}" visible="${doConfirm_V}" data="E"/>
			<e:button id="doReject" name="doReject" label="${doReject_N}" onClick="doConfirm" disabled="${doReject_D}" visible="${doReject_V}" data="R"/>
		</e:buttonBar>

		<e:gridPanel gridType="${_gridType}" id="grid" name="grid" width="100%" height="fit" />

	</e:window>
</e:ui>