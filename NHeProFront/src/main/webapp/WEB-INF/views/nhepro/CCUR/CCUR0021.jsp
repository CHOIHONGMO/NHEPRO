<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
	<script type="text/javascript">

		var grid; var gridDT;
		var addParam = [];
		var baseUrl = "/nhepro/CCUR/CCUR0021/";
		var selRow;

		function init() {

			grid  = EVF.C('grid');
            gridDT  = EVF.C('gridDT');

/* 			grid.addRowEvent(function() {
				addParam = [{
					"BUYER_CD": "${ses.companyCd }",
					"USE_FLAG": "1",
					"GATE_CD": "${ses.gateCd}",
					"INSERT_FLAG": "I",
					"CTRL_TYPE": ""
				}];
				grid.addRow(addParam);
			});

			grid.delRowEvent(function() {
                if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
				grid.delRow();
			});
 */
			grid.cellClickEvent(function(rowIdx, colIdx) {
				if(selRow == undefined) selRow = rowIdx;

                if(colIdx == "CTRL_CD") {
                    if(grid.getCellValue(rowIdx, "INSERT_FLAG")=="U"){
						EVF.V("CTRL_CD_S", grid.getCellValue(rowIdx, "CTRL_CD"));
                        EVF.V("BUYER_CD_S", grid.getCellValue(rowIdx, "BUYER_CD"));
                        doSearchDT();
					}
				}
			});
			
			//2021.11.03 개인정보처리방침으로 엑셀다운로드 기능 제외
            /* grid.excelExportEvent({
                allItems : "${excelExport.allCol}",
                fileName : "${screenName }"
            }); */

			grid.setProperty('shrinkToFit', true);					// 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
			grid.setProperty('rowNumbers', ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
			grid.setProperty('sortable', ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
			grid.setProperty('panelVisible', ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
			grid.setProperty('enterToNextRow', ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
			grid.setProperty('acceptZero', ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
			grid.setProperty('multiSelect', false);					// [선택] 컬럼의 사용여부를 지정한다. [true/false]

			gridDT.setProperty('shrinkToFit', true);
			gridDT.setProperty('rowNumbers', ${rowNumbers});
			gridDT.setProperty('sortable', ${sortable});
			gridDT.setProperty('panelVisible', ${panelVisible});
			gridDT.setProperty('enterToNextRow', ${enterToNextRow});
			gridDT.setProperty('acceptZero', ${acceptZero});
			gridDT.setProperty('multiSelect', ${param.detailView == true ? false : multiSelect});

			doSearch();
		}

		function doSearch() {

			var store = new EVF.Store();
			store.setGrid([grid]);
			store.load(baseUrl + 'ccur0021_selectTaskCode.so', function() {
				if(grid.getRowCount() == 0){
					EVF.alert("${msg.M0002 }");
				}
			});
		}

		function doSearchDT() {

            var store = new EVF.Store();
            store.setGrid([gridDT]);
            store.load(baseUrl + 'ccur0021_selectMappingUser_add.so', function() {
                if(gridDT.getRowCount() == 0){
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
				store.load(baseUrl + 'ccur0021_saveTaskCode.so', function(){
					EVF.alert(this.getResponseMessage(), function() {
						doSearch();
					});
				});
			});
		}

		function doDelete() {

            if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

			EVF.confirm("${msg.M0013 }", function() {
				var store = new EVF.Store();
				store.setGrid([grid]);
				store.getGridData(grid, 'sel');
				store.load(baseUrl + 'ccur0021_deleteTaskCode.so', function(){
					EVF.alert(this.getResponseMessage(), function() {
						doSearch();
					});
				});
			});
		}

        function doUserSave() {

            if(gridDT.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

            if(EVF.V('CTRL_CD_S') == ""){ return EVF.alert("${CCUR0021_M001}"); }

            EVF.confirm("${msg.M0021}", function() {
				var store = new EVF.Store();
				store.setGrid([gridDT]);
				store.getGridData(gridDT, 'sel');
				store.load(baseUrl + 'ccur0021_doSaveTaskUser.so', function() {
					EVF.alert(this.getResponseMessage(), function() {
						doSearchDT();
					});
				});
			});
        }

        function doUserDelete(){

            if(gridDT.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

            EVF.confirm("${msg.M0013 }", function() {
				var store = new EVF.Store();
				store.setGrid([gridDT]);
				store.getGridData(gridDT, 'sel');
				store.load(baseUrl + 'ccur0021_doDeleteTaskUser.so', function() {
					EVF.alert(this.getResponseMessage(), function() {
						doSearchDT();
					});
				});
			});
        }

		function doTaskSearch() {

			var BUYER_CD = '${ses.manageCd}';

			if (BUYER_CD == "") { return EVF.alert("${CCUR0021_0001 }"); }

			var param = {
				BUYER_CD: BUYER_CD,
				COMPANY_TYPE: 'B',
				callBackFunction: "setTaskId"
			};
			everPopup.openCommonPopup(param, "SP0003");
		}

		function setTaskId(data) {
            EVF.V("CTRL_CD", data.CTRL_CD);
			EVF.V("CTRL_NM", data.CTRL_NM);
		}

        function doUserSearch() {
            var param = {
                callBackFunction : "setUserCdMulti",
                'READONLY': 'Y',         //팝업 조회조건 변경불가
				'multiYN' : 'Y',         //멀티팝업여부
				'detailView': false,
            };
            everPopup.openPopupByScreenId("CCDU0020", 1100, 700, param);
        }

        function setUserCdMulti(data) {
            if(data.length != undefined) {
                var dataArr = [];
                for(var idx in data) {
                    var arr = {
                        'USER_ID': data[idx].USER_ID,
                        'USER_NM': data[idx].USER_NM,
                        'EMPLOYEE_NUM': data[idx].EMPLOYEE_NUM,
                        'DEPT_NM': data[idx].DEPT_NM,
						'USE_FLAG': '1'
                    };
                    dataArr.push(arr);
                }
                var validData = valid.equalPopupValid(JSON.stringify(dataArr), gridDT, "USER_ID");
                gridDT.addRow(validData);
            }
        }

	</script>

	<e:window id="CCUR0021" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">
		<e:searchPanel id="form" title="${form_CAPTION_N }" columnCount="2" labelWidth="${labelWidth }" useTitleBar="false" onEnter="doSearch">
			<e:row>
				<e:label for="CTRL_TYPE" title="${form_CTRL_TYPE_N }" />
				<e:field>
					<e:select id="CTRL_TYPE" name="CTRL_TYPE" value="" options="${ctrlTypeOptions }" readOnly="${form_CTRL_TYPE_RO }" width="${form_CTRL_TYPE_W }" required="${form_CTRL_TYPE_R }" disabled="${form_CTRL_TYPE_D }"  maskType="${form_CTRL_TYPE_MT}"/>
				</e:field>
				<e:label for="CTRL_NM" title="${form_CTRL_NM_N }" />
				<e:field>
					<e:search id="CTRL_CD" name="CTRL_CD" value="" width="40%" maxLength="${form_CTRL_CD_M}" onIconClick="doTaskSearch" disabled="${form_CTRL_CD_D}" readOnly="${form_CTRL_CD_RO}" required="${form_CTRL_CD_R}"  maskType="${form_CTRL_CD_MT}" placeHolder="직무코드" />
					<e:inputText id="CTRL_NM" name="CTRL_NM" value="${formData.CTRL_NM }" width="60%" maxLength="${form_CTRL_NM_M}" disabled="${form_CTRL_NM_D}" readOnly="${form_CTRL_NM_RO}" required="${form_CTRL_NM_R}" maskType="${form_CTRL_NM_MT}" placeHolder="직무명" />
				</e:field>
			</e:row>
			<e:inputHidden id="CTRL_CD_S" name="CTRL_CD_S" value="" />
			<e:inputHidden id="BUYER_CD_S" name="BUYER_CD_S" value="" />
		</e:searchPanel>

		<e:panel id="Panel1" height="fit" width="49%">
			<e:buttonBar id="buttonBar1" align="right" width="100%" title="${CCUR0021_TITLE1}">
				<e:button id="Search" name="Search" label="${Search_N }" disabled="${Search_D }" onClick="doSearch" />
<%-- 				<e:button id="Save" name="Save" label="${Save_N }" disabled="${Save_D }" onClick="doSave" />
				<e:button id="Delete" name="Delete" label="${Delete_N }" disabled="${Delete_D }" onClick="doDelete" /> --%>
			</e:buttonBar>

			<e:gridPanel id="grid" name="grid" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}"/>
		</e:panel>

		<e:panel id="Panel2" height="fit" width="1%">&nbsp;</e:panel>

		<e:panel id="Panel3" height="fit" width="50%">
			<e:buttonBar id="buttonBar2" align="right" width="100%" title="${CCUR0021_TITLE2}">
				<e:button id="UserSearch" name="UserSearch" label="${UserSearch_N }" disabled="${UserSearch_D }" visible="${UserSearch_V}" onClick="doUserSearch" />
				<e:button id="UserSave" name="UserSave" label="${UserSave_N }" disabled="${UserSave_D }" visible="${UserSave_V}" onClick="doUserSave" />
				<e:button id="UserDelete" name="UserDelete" label="${UserDelete_N }" disabled="${UserDelete_D }" visible="${UserDelete_V}" onClick="doUserDelete" />
			</e:buttonBar>

			<e:gridPanel id="gridDT" name="gridDT" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}"/>
		</e:panel>

	</e:window>
</e:ui>

