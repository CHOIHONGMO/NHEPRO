<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
	<script type="text/javascript">

		var grid = {};
		var addParam = [];
		var baseUrl = "/nhepro/CCUR/CCUR0022/";
		var currentRow;

		function init() {

			grid = EVF.C('grid');

			grid.setProperty('shrinkToFit', true);					// 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
			grid.setProperty('rowNumbers', ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
			grid.setProperty('sortable', ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
			grid.setProperty('panelVisible', ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
			grid.setProperty('enterToNextRow', ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
			grid.setProperty('acceptZero', ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
			grid.setProperty('multiSelect', ${param.detailView == true ? false : multiSelect}); // [선택] 컬럼의 사용여부를 지정한다. [true/false]
			
			/**
			 * 2021.02.05 직무별 사용자 현황에서 직무별 담당자 등록기능 제외
			grid.addRowEvent(function() {
				addParam = [{
					"BUYER_NM": EVF.V('buyerCd'),
					"BUYER_CD_ORI": EVF.V('buyerCd'),
					"BUYER_CD": EVF.V('buyerCd'),
					"INSERT_FLAG": "I",
					"USE_FLAG": "1",
					"GATE_CD": "${ses.gateCd}"
				}];
				grid.addRow(addParam);
			});

			grid.delRowEvent(function() {
                if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
				grid.delRow();
			});*/
			
			grid.cellClickEvent(function(rowIdx, colIdx) {
				currentRow = rowIdx;
				/**
				 * 2021.02.05 직무별 사용자 현황에서 직무별 담당자 등록기능 제외
				if(colIdx == "USER_NM") {
					doUserSearch("selectUserIdPopupIntoGrid");
				}
				else if(colIdx == "CTRL_NM") {
					doTaskSearch("selectTaskIdPopupIntoGrid");
				}*/
			});

            /* grid.excelExportEvent({
                allItems : "${excelExport.allCol}",
                fileName : "${screenName }"
            }); */
		}

		function doSearch() {
			var store = new EVF.Store();
			store.setGrid([grid]);
			store.load(baseUrl + 'ccur0022_selectTaskPersonInCharge.so', function() {
				if(grid.getRowCount() == 0){
					EVF.alert("${msg.M0002 }");
				}
			});
		}

		function doSave() {
            if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
			if (!grid.validate().flag) { return EVF.alert(grid.validate().msg); }

			EVF.confirm("${msg.M0021 }", function() {
				var store = new EVF.Store();
				store.setGrid([grid]);
				store.getGridData(grid, 'sel');
				store.load(baseUrl + 'ccur0022_saveTaskPersonInCharge.so', function(){
					EVF.alert(this.getResponseMessage());
					if(this.getResponseCode() == "0001") {
						doSearch();
					}
				});
			});
		}

		function doDelete() {
            if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

			EVF.confirm("${msg.M0013 }", function() {
				var store = new EVF.Store();
				store.setGrid([grid]);
				store.getGridData(grid, 'sel');
				store.load(baseUrl + 'ccur0022_deleteTaskPersonInCharge.so', function(){
					EVF.alert(this.getResponseMessage());
					doSearch();
				});
			});

		}

		function doUserSearch(handler) {
			var param = {
					'callBackFunction': handler,
					'READONLY': 'Y',         //팝업 조회조건 변경불가
					'multiYN' : 'N',         //멀티팝업여부
					'detailView': false
			};
			everPopup.openPopupByScreenId("CCDU0020", 1100, 700, param);
		}

		function selectUserIdPopupIntoGrid(data) {
			if(data!=null){
            	data = JSON.parse(data);
				grid.setCellValue(currentRow, 'CTRL_USER_ID', data.USER_ID);
				grid.setCellValue(currentRow, 'USER_NM', data.USER_NM);
				grid.setCellValue(currentRow, 'DEPT_NM', data.DEPT_NM);
	
				var selectedRow = grid.getSelRowId();
				if (selectedRow.length > 1) {
					EVF.confirm('${CCUR0022_001}', function() {
						for(var i in selectedRow) {
							grid.setCellValue(selectedRow[i], 'CTRL_USER_ID', data.USER_ID);
							grid.setCellValue(selectedRow[i], 'USER_NM', data.USER_NM);
							grid.setCellValue(selectedRow[i], 'DEPT_NM', data.DEPT_NM);
						}
					});
				}
			}
		}

		function doTaskSearch(handler) {
			var param = {
				BUYER_CD: grid.getCellValue(currentRow, 'BUYER_CD'),
				COMPANY_TYPE: "B",
				callBackFunction: handler
			};
			everPopup.openCommonPopup(param, "SP0003");
		}

		function selectTaskIdPopupIntoGrid(data) {
			grid.setCellValue(currentRow, 'CTRL_CD', data.CTRL_CD);
			grid.setCellValue(currentRow, 'CTRL_NM', data.CTRL_NM);
			
			var selectedRow = grid.getSelRowId();
			if (selectedRow.length > 1) {
				EVF.confirm('${CCUR0022_001}', function() {
					for(var i in selectedRow) {
						grid.setCellValue(selectedRow[i], 'CTRL_CD', data.CTRL_CD);
						grid.setCellValue(selectedRow[i], 'CTRL_NM', data.CTRL_NM);
					}
				});
			}
		}

        function getRegUserId() {
            var param = {
					'callBackFunction': 'setRegUserId',
					'READONLY': 'Y',           //팝업 조회조건 변경불가
					'multiYN' : 'N',         //멀티팝업여부
					'detailView': false
			};
			everPopup.openPopupByScreenId("CCDU0020", 1100, 700, param);
        }

        function setRegUserId(data) {
        	if(data!=null){
        		data = JSON.parse(data);
        		EVF.V("USER_ID", data.USER_ID);
            	EVF.V("USER_NM", data.USER_NM);
        	}
        }

        function onIconClickDEPT_CD() {
            var param = {
					'callBackFunction': 'setDeptCd_s',
					'READONLY': 'Y',           //팝업 조회조건 변경불가
					'multiYN' : 'N',         //멀티팝업여부
					'detailView': false
			};
			everPopup.openPopupByScreenId("CCDU0010", 1000, 700, param);
        }

        function setDeptCd_s(data) {
        	if(data!=null){
            	data = JSON.parse(data);
            	EVF.V('DEPT_CD', data.DEPT_CD);
            	EVF.V('DEPT_NM', data.DEPT_NM);
        	}
        }

	</script>

	<e:window id="CCUR0022" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">
		<e:searchPanel id="form" title="${form_CAPTION_N }" columnCount="2" labelWidth="${labelWidth }" useTitleBar="false" onEnter="doSearch">
			<e:inputHidden id="buyerCd" name="${ses.companyCd}"/>
			<e:row>
				<e:label for="CTRL_TYPE" title="${form_CTRL_TYPE_N }" />
				<e:field>
					<e:select id="CTRL_TYPE" name="CTRL_TYPE" value="" options="${ctrlTypeOptions }" readOnly="${form_CTRL_TYPE_RO }" width="${form_CTRL_TYPE_W }" required="${form_CTRL_TYPE_R }" disabled="${form_CTRL_TYPE_D }"  maskType="${form_CTRL_TYPE_MT}"/>
				</e:field>
				<e:label for="CTRL_NM" title="${form_CTRL_NM_N }" />
				<e:field>
					<e:inputText id="CTRL_NM" name="CTRL_NM" width="${form_CTRL_NM_W }" required="${form_CTRL_NM_R }" disabled="${form_CTRL_NM_D }" readOnly="${form_CTRL_NM_RO }" maxLength="${form_CTRL_NM_M}"  maskType="${form_CTRL_NM_MT}" />
				</e:field>
			</e:row>
			<e:row>
				<e:label for="USER_NM" title="${form_USER_NM_N }" />
				<e:field>
					<e:search id="USER_ID" name="USER_ID" value="" width="40%" maxLength="${form_USER_ID_M}" onIconClick="getRegUserId" disabled="${form_USER_ID_D}" readOnly="${form_USER_ID_RO}" required="${form_USER_ID_R}"  maskType="${form_USER_ID_MT}" placeHolder="개인번호" />
					<e:inputText id="USER_NM" name="USER_NM"  value="" width="60%" maxLength="${form_USER_NM_M}" disabled="${form_USER_NM_D}" readOnly="${form_USER_NM_RO}" required="${form_USER_NM_R}"  maskType="${form_USER_NM_MT}" placeHolder="성명" />
				</e:field>
				<e:label for="DEPT_CD" title="${form_DEPT_CD_N}"/>
				<e:field>
					<e:search id="DEPT_CD" name="DEPT_CD" value="${data.DEPT_CD}" width="40%" maxLength="${form_DEPT_CD_M}" onIconClick="${form_DEPT_CD_D ? 'everCommon.blank' : 'onIconClickDEPT_CD'}" disabled="${form_DEPT_CD_D}" readOnly="${form_DEPT_CD_RO}" required="${form_DEPT_CD_R}"  maskType="${form_DEPT_CD_MT}" placeHolder="부서코드" />
					<e:inputText id="DEPT_NM" name="DEPT_NM" value="${data.DEPT_NM}" width="60%" maxLength="${form_DEPT_NM_M}" disabled="${form_DEPT_NM_D}" readOnly="${form_DEPT_NM_RO}" required="${form_PO_DEPT_NM_R}"  maskType="${form_DEPT_NM_MT}" placeHolder="부서명" />
				</e:field>
			</e:row>
		</e:searchPanel>

		<e:buttonBar id="buttonBar" align="right" width="100%">
			<e:button id="Search" name="Search" label="${Search_N }" disabled="${Search_D }" onClick="doSearch" />
			<%-- 2021.02.05 직무별 사용자 현황에서 등록 및 삭제기능 제외
			<e:button id="Save" name="Save" label="${Save_N }" disabled="${Save_D }" onClick="doSave" />
			<e:button id="Delete" name="Delete" label="${Delete_N }" disabled="${Delete_D }" onClick="doDelete" />
			--%>
		</e:buttonBar>

		<e:gridPanel id="grid" name="grid" gridType="${_gridType}" width="100%" height="fit" readOnly="${param.detailView}"/>

	</e:window>
</e:ui>