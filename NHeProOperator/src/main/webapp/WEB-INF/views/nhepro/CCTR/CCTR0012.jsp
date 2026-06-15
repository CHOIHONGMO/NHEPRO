<%--
  Date: 2020-04-13
  Time: 15:30:33
  Scrren ID : CCTR0012
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
	<script>

		var grid;
		var baseUrl = "/nhepro/CCTR/CCTR0012";

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

			// Grid Excel Event
			grid.excelExportEvent({
				allItems: "${excelExport.allCol}",
				fileName: "${screenName }"
			});

			grid.cellClickEvent(function(rowIdx, colIdx) {
				switch (colIdx) {
					case "FORM_NM":
						var signStatus = grid.getCellValue(rowIdx[0], "SIGN_STATUS");
						var param = {
							detailView: (signStatus=="P" || signStatus=="E") ? true : false,
							FORM_NUM: grid.getCellValue(rowIdx, "FORM_NUM"),
							BUYER_CD: grid.getCellValue(rowIdx, "BUYER_CD")
						};
						everPopup.openPopupByScreenId('CCTI0013', 1200, 700, param);
						break;
				}
			});

			EVF.C("USE_FLAG").setValue('1');
			
			// 2020.12.02 자동조회 추가
			doSearch();
		}

		// Search
		function doSearch() {
			var store = new EVF.Store();

			// form validation Check
			if (!store.validate()) return;

			store.setGrid([grid]);
			store.load(baseUrl + "/cctr0012_doSearch.so", function () {
				if (grid.getRowCount() == 0) {
					return EVF.alert("${msg.M0002}");
				}
			});
		}

		// Delete
		function doDelete() {

			if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
			
			var rowIdx = grid.getSelRowId();
			for(var i in rowIdx) {
								
				var signStatus = grid.getCellValue(rowIdx[i], "SIGN_STATUS");
				var formUseCnt = grid.getCellValue(rowIdx[i], "FORM_USE_CNT"); // 해당 폼 사용횟수
				
				// 2021.03.17 운영화면 이관
				if (signStatus == "E" || formUseCnt > 0) {
					return EVF.alert("${CCTR0012_0007}");
				}
			}

			EVF.confirm("${msg.M0013 }", function () {
				var store = new EVF.Store();
				store.setGrid([grid]);
				store.getGridData(grid, "sel");
				store.load(baseUrl + "/cctr0012_doDelete.so", function () {
					EVF.alert("${msg.M0017}", function () {
						doSearch();
					});
				});
			});
		}

		function getBuyer() {
			var param = {
				callBackFunction: "setBuyer"
			};
			everPopup.openCommonPopup(param, "SP0066");
		}

		function setBuyer(data) {
			EVF.V("BUYER_CD", data.CUST_CD);
			EVF.V("BUYER_NM", data.CUST_NM);
		}

		function doNew() {
			var param = {
				detailView: false
			};
			everPopup.openPopupByScreenId('CCTI0013', 1200, 700, param);
		}

		function doUpdate() {
						
			if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
			if (grid.getSelRowCount() > 1) { return EVF.alert("${msg.M0006}"); }
			
			var msg = "${msg.M0012 }";
			var rowIdx = grid.getSelRowId();
			for(var i in rowIdx) {
			
			// 2021.03.17 운영화면 이관	
			//	if("${ses.companyCd}" != grid.getCellValue(rowIdx[i], "BUYER_CD")) {
			//		return EVF.alert("고객사가 다릅니다. 수정할 수 없습니다.");
			//	}
				
				var signStatus = grid.getCellValue(rowIdx[i], "SIGN_STATUS");
				var useYn      = grid.getCellValue(rowIdx[i], "USE_FLAG");
				var formUseCnt = grid.getCellValue(rowIdx[i], "FORM_USE_CNT"); // 해당 폼 사용횟수
				
			// 2021.03.17 운영화면 이관
				if( (signStatus == "E" || formUseCnt > 0) && useYn == "0" ) {
					msg = "${CCTR0012_0006}";
				}
			}
			

			EVF.confirm(msg, function () {
				var store = new EVF.Store();
				store.setGrid([grid]);
				store.getGridData(grid, "sel");
				store.load(baseUrl + "/cctr0012_doUpdate.so", function () {
					EVF.alert("${msg.M0016}", function () {
						doSearch();
					});
				});
			});
		}

		function doCopy() {
			if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
			if (grid.getSelRowCount() > 1) { return EVF.alert("${msg.M0006}"); }

			EVF.confirm("${CCTR0012_0002 }", function () {
				var store = new EVF.Store();
				store.setGrid([grid]);
				store.getGridData(grid, "sel");
				store.load(baseUrl + "/cctr0012_doCopy.so", function () {
					EVF.alert("${CCTR0012_0003 }", function () {
						doSearch();
					});
				});
			});
		}
	</script>

	<e:window id="CCTR0012" initData="${initData}" onReady="init" title="${fullScreenName }" breadCrumbs="${breadCrumb }">
		<e:searchPanel id="form" title="${msg.M9999}" labelWidth="130" width="100%" columnCount="3" useTitleBar="false" onEnter="doSearch">
			<e:row>
				<%-- 서식명 --%>
				<e:label for="FORM_NM" title="${form_FORM_NM_N}" />
				<e:field>
					<e:inputText id="FORM_NM" name="FORM_NM" value="" width="${form_FORM_NM_W}" maxLength="${form_FORM_NM_M}" disabled="${form_FORM_NM_D}" readOnly="${form_FORM_NM_RO}" required="${form_FORM_NM_R}" style="${imeMode}" maskType="${form_FORM_NM_MT}"/>
				</e:field>
				<%-- 결재상태 --%>
				<e:label for="SIGN_STATUS" title="${form_SIGN_STATUS_N}"/>
				<e:field>
					<e:select id="SIGN_STATUS" name="SIGN_STATUS" value="" options="${signStatusOptions}" width="${form_SIGN_STATUS_W}" disabled="${form_SIGN_STATUS_D}" readOnly="${form_SIGN_STATUS_RO}" required="${form_SIGN_STATUS_R}" placeHolder="" maskType="${form_SIGN_STATUS_MT}" />
				</e:field>
				<%-- 생성일 --%>
				<e:label for="REG_FROM_DATE" title="${form_REG_FROM_DATE_N}"/>
				<e:field>
					<e:inputDate id="REG_FROM_DATE" name="REG_FROM_DATE" value="${defaultFromDate}" width="${inputDateWidth}" datePicker="true" required="${form_REG_FROM_DATE_R}" disabled="${form_REG_FROM_DATE_D}" readOnly="${form_REG_FROM_DATE_RO}" />
					<e:text>~</e:text>
					<e:inputDate id="REG_TO_DATE" name="REG_TO_DATE" value="${defaultToDate}" width="${inputDateWidth}" datePicker="true" required="${form_REG_TO_DATE_R}" disabled="${form_REG_TO_DATE_D}" readOnly="${form_REG_TO_DATE_RO}" />
				</e:field>
			</e:row>
			<e:row>
				<%-- 서식분류 --%>
				<e:label for="FORM_TYPE" title="${form_FORM_TYPE_N}"/>
				<e:field>
					<e:select id="FORM_TYPE" name="FORM_TYPE" value="" options="${formTypeOptions}" width="${form_FORM_TYPE_W}" disabled="${form_FORM_TYPE_D}" readOnly="${form_FORM_TYPE_RO}" required="${form_FORM_TYPE_R}" placeHolder="" maskType="${form_FORM_TYPE_MT}" />
				</e:field>
				<%-- 계약서종류 --%>
				<e:label for="CONT_TYPE" title="${form_CONT_TYPE_N}"/>
				<e:field>
					<e:select id="CONT_TYPE" name="CONT_TYPE" value="" options="${contTypeOptions}" width="${form_CONT_TYPE_W}" disabled="${form_CONT_TYPE_D}" readOnly="${form_CONT_TYPE_RO}" required="${form_CONT_TYPE_R}" placeHolder="" maskType="${form_CONT_TYPE_MT}" />
				</e:field>
				<%-- 계약구분 --%>
				<e:label for="CONT_DIV" title="${form_CONT_DIV_N}"/>
				<e:field>
					<e:select id="CONT_DIV" name="CONT_DIV" value="" options="${contDivOptions}" width="${form_CONT_DIV_W}" disabled="${form_CONT_DIV_D}" readOnly="${form_CONT_DIV_RO}" required="${form_CONT_DIV_R}" placeHolder="" maskType="${form_CONT_DIV_MT}" />
				</e:field>
			</e:row>
			<e:row>
				<%-- 일괄계약 --%>
				<e:label for="BUNDLE_FLAG" title="${form_BUNDLE_FLAG_N}"/>
				<e:field>
					<e:select id="BUNDLE_FLAG" name="BUNDLE_FLAG" value="" options="${bundleFlagOptions}" width="${form_BUNDLE_FLAG_W}" disabled="${form_BUNDLE_FLAG_D}" readOnly="${form_BUNDLE_FLAG_RO}" required="${form_BUNDLE_FLAG_R}" placeHolder="" maskType="${form_BUNDLE_FLAG_MT}" />
				</e:field>
				<%-- 자동갱신 --%>
				<e:label for="AUTO_RENEW_FLAG" title="${form_AUTO_RENEW_FLAG_N}"/>
				<e:field>
					<e:select id="AUTO_RENEW_FLAG" name="AUTO_RENEW_FLAG" value="" options="${autoRenewFlagOptions}" width="${form_AUTO_RENEW_FLAG_W}" disabled="${form_AUTO_RENEW_FLAG_D}" readOnly="${form_AUTO_RENEW_FLAG_RO}" required="${form_AUTO_RENEW_FLAG_R}" placeHolder="" maskType="${form_AUTO_RENEW_FLAG_MT}" />
				</e:field>
				<%-- 고객사 --%>
				<e:label for="BUYER_CD" title="${form_BUYER_CD_N}"/>
				<e:field>
					<e:search id="BUYER_CD" name="BUYER_CD" value="" width="40%" maxLength="${form_BUYER_CD_M}" onIconClick="${form_BUYER_CD_RO ? 'everCommon.blank' : 'getBuyer'}" disabled="${form_BUYER_CD_D}" readOnly="${form_BUYER_CD_RO}" required="${form_BUYER_CD_R}" maskType="${form_BUYER_CD_MT}" placeHolder="회사코드" />
					<e:inputText id="BUYER_NM" name="BUYER_NM" value="" width="60%" maxLength="${form_BUYER_NM_M}" disabled="${form_BUYER_NM_D}" readOnly="${form_BUYER_NM_RO}" required="${form_BUYER_NM_R}" style="${imeMode}" maskType="${form_BUYER_NM_MT}" placeHolder="회사명"/>
				</e:field>
			</e:row>
			<e:row>
				<%-- 사용여부 --%>
				<e:label for="USE_FLAG" title="${form_USE_FLAG_N}"/>
				<e:field>
					<e:select id="USE_FLAG" name="USE_FLAG" value="" options="${useFlagOptions}" width="${form_USE_FLAG_W}" disabled="${form_USE_FLAG_D}" readOnly="${form_USE_FLAG_RO}" required="${form_USE_FLAG_R}" placeHolder="" maskType="${form_USE_FLAG_MT}" />
				</e:field>
				<e:label for="" title=""/>
				<e:field> </e:field>
				<e:label for="" title=""/>
				<e:field> </e:field>
			</e:row>
		</e:searchPanel>

		<e:buttonBar width="100%" align="right">
			<e:button id="doSearch" name="doSearch" label="${doSearch_N}" onClick="doSearch" disabled="${doSearch_D}" visible="${doSearch_V}"/>
			<e:button id="doNew" name="doNew" label="${doNew_N}" onClick="doNew" disabled="${doNew_D}" visible="${doNew_V}"/>
			<e:button id="doCopy" name="doCopy" label="${doCopy_N}" onClick="doCopy" disabled="${doCopy_D}" visible="${doCopy_V}"/>
			<e:button id="doUpdate" name="doUpdate" label="${doUpdate_N}" onClick="doUpdate" disabled="${doUpdate_D}" visible="${doUpdate_V}"/>
			<e:button id="doDelete" name="doDelete" label="${doDelete_N}" onClick="doDelete" disabled="${doDelete_D}" visible="${doDelete_V}"/>
		</e:buttonBar>

		<e:gridPanel id="grid" name="grid" gridType="${_gridType}" width="100%" height="fit"/>
	</e:window>
</e:ui>
