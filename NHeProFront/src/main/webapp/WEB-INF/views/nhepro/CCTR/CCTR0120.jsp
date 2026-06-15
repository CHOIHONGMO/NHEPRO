<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<e:ui>
	<script type="text/javascript">

		var grid = {};
		var baseUrl = "/nhepro/CCTR/CCTR0120";
		var selRow;

		function init() {
			grid = EVF.C("grid");
			
			grid.setProperty('shrinkToFit', true);					// 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
			grid.setProperty('rowNumbers', ${rowNumbers});		    // 로우의 번호 표시 여부를 지정한다. [true/false]
			grid.setProperty('sortable', ${sortable});			    // 컬럼 정렬기능 사용여부를 지정한다. [true/false]
			grid.setProperty('panelVisible', ${panelVisible});	    // 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
			grid.setProperty('enterToNextRow', ${enterToNextRow}); 	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
			grid.setProperty('acceptZero', ${acceptZero});		    // 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
			grid.setProperty('multiSelect', true);					// [선택] 컬럼의 사용여부를 지정한다. [true/false]
			grid.setProperty('singleSelect', ${singleSelect});	    // [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]

			grid.cellClickEvent(function (rowId, colId, value) {
				selRow = rowId;
				switch (colId) {
					case 'CONT_INFO':
						if(value != '') {
							var param = {
									callBackFunction: '',
									buyerCd: '${ses.companyCd}',
					                contNum: grid.getCellValue(rowId, "CONT_NUM"),
		                            contCnt: '1',
					                detailView: true
					            };
							everPopup.openPopupByScreenId('CCTI0090', 1170, 800, param);
						}
						break;
				}
			});
			
			//2021.11.03 개인정보처리방침으로 엑셀다운로드 기능 제외
			/* grid.excelExportEvent({
				allCol: "${excelExport.allCol}",
				fileName: "${screenName }"
			}); */
			
			// 2020.12.02 자동조회 추가
			doSearch();
		}

		function doSearch() {
			var store = new EVF.Store();
			if (!store.validate()) {
				return;
			}

			if (!everDate.fromTodateValid('REQ_FROM_DATE', 'REQ_TO_DATE', '${ses.dateFormat }')) {
				return EVF.alert('${msg.M0073}');
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
			if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
			
			var selRowIdx  = grid.getSelRowId();
			for(var i in selRowIdx) {
				var rowIdx = selRowIdx[i];
				if (!${havePermission} && "${ses.userId}" != grid.getCellValue(rowIdx, "SITE_USER_ID")) {
					return EVF.alert("현장담당자만 처리할 수 있습니다.");
				}
				if (grid.getCellValue(rowIdx, "PROGRESS_CD") != "P") {
					return EVF.alert("진행상태가 진행중인 건만 승인 및 반려가 가능합니다.");
				}
			}
			
			var progressCd = this.data.data;
			var msg = "${CCTR0120_001}"; // 승인
			if( progressCd =="R" ) {
				msg = "${CCTR0120_002}"; // 반려
			}
			
			var store = new EVF.Store();
			EVF.confirm(msg, function () {
				store.setParameter("progressCd", progressCd)
				store.setGrid([grid]);
				store.getGridData(grid, 'sel');
				store.load(baseUrl + '/cctr0120_doConfirm.so', function () {
					EVF.alert(this.getResponseMessage(), function () {
						doSearch();
					});
				});
			});
		}
		
		//계약담당자
		function getContUser() {
			var param = {
				'callBackFunction': 'setContUser',
				'READONLY': 'N',		 //팝업 조회조건 변경불가
				'multiYN' : 'N',         //멀티팝업여부
				'detailView': false
			};
			everPopup.openPopupByScreenId("CCDU0020", 1100, 700, param);
		}

		function setContUser(data) {
			if(data!=null){
        		data = JSON.parse(data);
        		
        		EVF.V("SITE_USER_ID", data.USER_ID);
        		EVF.V("SITE_USER_NM", data.USER_NM);
        	}
		}
		
	</script>

	<e:window id="CCTR0120" onReady="init" initData="${initData}" title="${fullScreenName }" breadCrumbs="${breadCrumb }">
		<e:searchPanel id="form" title="${msg.M9999 }" columnCount="3" labelWidth="130" onEnter="doSearch" useTitleBar="false">
			<e:inputHidden id="SIGN_REMARK" name="SIGN_REMARK" />
			<e:row>
				<e:label for="REQ_FROM_DATE" title="${form_REQ_FROM_DATE_N}"/>
				<e:field>
					<e:inputDate id="REQ_FROM_DATE" name="REQ_FROM_DATE" toDate="REQ_TO_DATE" value="${fromDate }" width="${inputDateWidth}" datePicker="true" required="${form_REQ_FROM_DATE_R}" disabled="${form_REQ_FROM_DATE_D}" readOnly="${form_REQ_FROM_DATE_RO}" />
					<e:text>~</e:text>
					<e:inputDate id="REQ_TO_DATE" name="REQ_TO_DATE" fromDate="REQ_FROM_DATE" value="${toDate }" width="${inputDateWidth}" datePicker="true" required="${form_REQ_TO_DATE_R}" disabled="${form_REQ_TO_DATE_D}" readOnly="${form_REQ_TO_DATE_RO}" />
				</e:field>
				<e:label for="USER_NM" title="${form_USER_NM_N}" />
				<e:field>
					<e:select id="st_USER_NM" name="st_USER_NM" value="${st_default}" width="${everMultiWidth}" options="${searchTerms}" visible="${everMultiVisible}" disabled="false" readOnly="false" required="false" />
					<e:inputText id="USER_NM" name="USER_NM" value="" width="${form_USER_NM_W}" maxLength="${form_USER_NM_M}" disabled="${form_USER_NM_D}" readOnly="${form_USER_NM_RO}" required="${form_USER_NM_R}" />
				</e:field>
				<e:label for="USER_ID" title="${form_USER_ID_N}" />
				<e:field>
					<e:inputText id="USER_ID" name="USER_ID" value="" width="${form_USER_ID_W}" maxLength="${form_USER_ID_M}" disabled="${form_USER_ID_D}" readOnly="${form_USER_ID_RO}" required="${form_USER_ID_R}" />
				</e:field>
			</e:row>
			<e:row>
				<e:label for="PROGRESS_CD" title="${form_PROGRESS_CD_N}"/>
				<e:field>
					<e:select id="PROGRESS_CD" name="PROGRESS_CD" value="" options="${progressCdOptions}" width="${form_PROGRESS_CD_W}" disabled="${form_PROGRESS_CD_D}" readOnly="${form_PROGRESS_CD_RO}" required="${form_PROGRESS_CD_R}" placeHolder="" />
				</e:field>
				<e:label for="SITE_USER_NM" title="${form_SITE_USER_NM_N}"/>
				<e:field>
                    <e:search id="SITE_USER_ID" name="SITE_USER_ID" value="" width="40%" maxLength="${form_SITE_USER_ID_M}" onIconClick="${form_SITE_USER_ID_RO ? 'everCommon.blank' : 'getContUser'}" disabled="${form_SITE_USER_ID_D}" readOnly="${form_SITE_USER_ID_RO}" required="${form_SITE_USER_ID_R}" maskType="${form_SITE_USER_ID_MT}" placeHolder="개인번호" />
                    <e:inputText id="SITE_USER_NM" name="SITE_USER_NM" value="" width="60%" maxLength="${form_SITE_USER_NM_M}" disabled="${form_SITE_USER_NM_D}" readOnly="${form_SITE_USER_NM_RO}" required="${form_SITE_USER_NM_R}" style="${imeMode}" maskType="${form_SITE_USER_NM_MT}" placeHolder="성명"/>
                </e:field>
				<e:label for="CELL_NUM" title="${form_CELL_NUM_N}" />
				<e:field>
					<e:inputText id="CELL_NUM" name="CELL_NUM" value="" width="${form_CELL_NUM_W}" maxLength="${form_CELL_NUM_M}" disabled="${form_CELL_NUM_D}" readOnly="${form_CELL_NUM_RO}" required="${form_CELL_NUM_R}" />
				</e:field>
			</e:row>
		</e:searchPanel>

		<e:buttonBar id="buttonBar" align="right" width="100%">
			<e:button id="doSearch" name="doSearch" icon="search" label="${doSearch_N }" disabled="${doSearch_D }" onClick="doSearch" />
			<e:button id="doConfirm" name="doConfirm" label="${doConfirm_N}" onClick="doConfirm" disabled="${doConfirm_D}" visible="${doConfirm_V}" data="E"/>
			<e:button id="doReject" name="doReject" label="${doReject_N}" onClick="doConfirm" disabled="${doReject_D}" visible="${doReject_V}" data="R"/>
		</e:buttonBar>

		<e:gridPanel gridType="${_gridType}" id="grid" name="grid" width="100%" height="fit" />

	</e:window>
</e:ui>

