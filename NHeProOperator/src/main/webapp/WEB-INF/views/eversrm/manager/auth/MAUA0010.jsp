<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
	<script type="text/javascript">

		var grid;
		var gridCUST;
		var gridDT;
		var addParam = [];
		var baseUrl = "/eversrm/manager/auth/MAUA0010/";

		function init() {

			grid = EVF.C('grid');
			gridCUST = EVF.C('gridCUST');
            gridDT = EVF.C('gridDT');

			grid.addRowEvent(function() {
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
			
			grid.cellClickEvent(function (rowIdx, celName, value) {
                if(celName == "CTRL_CD") {
                	var companyType = grid.getCellValue(rowIdx, "COMPANY_TYPE");
                    if(grid.getCellValue(rowIdx, "INSERT_FLAG") == "U" ) {
   						EVF.V("CTRL_CD_S", grid.getCellValue(rowIdx, "CTRL_CD"));
                    	if( EVF.V("COMPANY_TYPE_S") != companyType ) {
       						EVF.V("COMPANY_TYPE_S", grid.getCellValue(rowIdx, "COMPANY_TYPE"));
                        	if( companyType == 'O' ) {
                                EVF.V("BUYER_CD_S", grid.getCellValue(rowIdx, "BUYER_CD")); // 운영사
                                doSearchDT();
                        	} else {
           						EVF.V("BUYER_CD_S", ""); // 협력사, 고객사
                        	}
                            doSearchCUST();
                    	} else {
                    		if( !EVF.isEmpty(EVF.V("BUYER_CD_S")) ) { // 운영사
                    			doSearchDT();
                    		}
                    	}
					}
				}
			});

            grid.excelExportEvent({
                allItems : "${excelExport.allCol}",
                fileName : "${screenName }"
            });

			grid.setProperty('shrinkToFit', true);					// 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
			grid.setProperty('rowNumbers', ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
			grid.setProperty('sortable', ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
			grid.setProperty('panelVisible', ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
			grid.setProperty('enterToNextRow', ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
			grid.setProperty('acceptZero', ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
			grid.setProperty('multiSelect', ${param.detailView == true ? false : multiSelect}); // [선택] 컬럼의 사용여부를 지정한다. [true/false]
			
			gridCUST.cellClickEvent(function (rowIdx, colIdx, value) {
				if(colIdx == "CUST_CD") {
                	gridCUST.checkEqualRow(["CUST_CD"], [gridCUST.getCellValue(rowIdx, "CUST_CD")]);
                	
                    EVF.V("BUYER_CD_S", gridCUST.getCellValue(rowIdx, "CUST_CD"));
                    // 직무유형, 고객사별 직무담당자 조회
                    doSearchDT();
				}
			});
			
			gridCUST.setProperty('shrinkToFit', true);	
			gridCUST.setProperty('multiSelect', true);
			
			gridDT.setProperty('shrinkToFit', true);
			gridDT.setProperty('rowNumbers', ${rowNumbers});
			gridDT.setProperty('sortable', ${sortable});
			gridDT.setProperty('panelVisible', ${panelVisible});
			gridDT.setProperty('enterToNextRow', ${enterToNextRow});
			gridDT.setProperty('acceptZero', ${acceptZero});
			gridDT.setProperty('multiSelect', ${param.detailView == true ? false : multiSelect});
			
			// 직무현황 조회
			doSearch();
		}

		function doSearch() {

			var store = new EVF.Store();
			store.setGrid([grid]);
			store.load(baseUrl + 'selectTaskCode.so', function() {
				EVF.V("COMPANY_TYPE_S", "");
				EVF.V("BUYER_CD_S", "");
				EVF.V("CTRL_CD_S", "");
				if(grid.getRowCount() == 0){
					EVF.alert("${msg.M0002 }");
				}
			});
		}
		
		function doSearchCUST() {

            var store = new EVF.Store();
            store.setGrid([gridCUST]);
            store.load(baseUrl + 'selectMappingCust.so', function() {
            });
        }
		
		function doSearchDT() {

            var store = new EVF.Store();
            store.setGrid([gridDT]);
            store.load(baseUrl + 'selectMappingUser_add.so', function() {
                //if(gridDT.getRowCount() == 0){
                //    EVF.alert("${msg.M0002 }");
                //}
            });
        }

		function doSave() {

            if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
            if (!grid.validate().flag) { return EVF.alert(grid.validate().msg); }

			EVF.confirm("${msg.M0021 }", function() {
				var store = new EVF.Store();
				store.setGrid([grid]);
				store.getGridData(grid, 'sel');
				store.load(baseUrl + 'saveTaskCode.so', function(){
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
				store.load(baseUrl + 'deleteTaskCode.so', function(){
					EVF.alert(this.getResponseMessage(), function() {
						doSearch();
					});
				});
			});
		}

        function doUserSave() {

            if(gridDT.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
            if(EVF.V('CTRL_CD_S') == ""){ return EVF.alert("${MAUA0010_M001}"); }

            EVF.confirm("${msg.M0021}", function() {
				var store = new EVF.Store();
				store.setGrid([gridDT]);
				store.getGridData(gridDT, 'sel');
				store.load(baseUrl + 'doSaveTaskUser.so', function() {
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
				store.load(baseUrl + 'doDeleteTaskUser.so', function() {
					EVF.alert(this.getResponseMessage(), function() {
						doSearchDT();
					});
				});
			});
        }

		function doTaskSearch() {

			var BUYER_CD = EVF.V('BUYER_CD');
			if (BUYER_CD == "") { return EVF.alert("${MAUA0010_0001 }"); }

			var param = {
				BUYER_CD: EVF.V('BUYER_CD'),
				callBackFunction: "setTaskId"
			};
			everPopup.openCommonPopup(param, "SP0003");
		}

		function setTaskId(data) {
            EVF.V("CTRL_CD", data.CTRL_CD);
			EVF.V("CTRL_NM", data.CTRL_NM);
		}

        function doUserSearch() {
			if (EVF.V('CTRL_CD_S') == "") { return EVF.alert("등록하려는 직무가 선택되지 않았습니다."); }
			if (EVF.V('BUYER_CD_S') == "") { return EVF.alert("등록하려는 고객사가 선택되지 않았습니다."); }

			var param = {
					custCd: EVF.V('BUYER_CD_S'),
	                callBackFunction : "setUserCdMulti"
	            };
            everPopup.openCommonPopup(param, 'MP0011');
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
						'BUYER_CD': data[idx].CUST_CD,
						'USE_FLAG': '1'
                    };
                    dataArr.push(arr);
                }
                var validData = valid.equalPopupValid(JSON.stringify(dataArr), gridDT, "USER_ID");
                gridDT.addRow(validData);
            }
        }
	</script>

	<e:window id="MAUA0010" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">
		<e:searchPanel id="form" title="${form_CAPTION_N }" columnCount="2" labelWidth="${labelWidth }" useTitleBar="false" onEnter="doSearch">
			<e:inputHidden id="COMPANY_TYPE_S" name="COMPANY_TYPE_S" value="" />
			<e:inputHidden id="BUYER_CD_S" name="BUYER_CD_S" value="" />
			<e:inputHidden id="CTRL_CD_S" name="CTRL_CD_S" value="" />
			<e:row>
				<e:label for="BUYER_CD" title="${form_BUYER_CD_N }" />
				<e:field>
					<e:select id="BUYER_CD" name="BUYER_CD" usePlaceHolder="false" value="" readOnly="${form_BUYER_CD_RO }" options="${buyerCdOptions }" width="${form_BUYER_CD_W }" required="${form_BUYER_CD_R }" disabled="${form_BUYER_CD_D }"  maskType="${form_BUYER_CD_MT}"/>
				</e:field>
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
		</e:searchPanel>

		<e:panel id="Panel1" height="fit" width="49%">
			<e:buttonBar id="buttonBar1" align="right" width="100%" title="${MAUA0010_TITLE1}">
				<e:button id="Search" name="Search" label="${Search_N }" disabled="${Search_D }" onClick="doSearch" />
				<e:button id="Save" name="Save" label="${Save_N }" disabled="${Save_D }" onClick="doSave" />
				<e:button id="Delete" name="Delete" label="${Delete_N }" disabled="${Delete_D }" onClick="doDelete" />
			</e:buttonBar>
			
			<!-- 직무정보 Grid -->
			<e:gridPanel id="grid" name="grid" width="100%" height="350" gridType="${_gridType}" readOnly="${param.detailView}"/>
			
			<!-- 고객사 Grid -->
			<e:gridPanel id="gridCUST" name="gridCUST" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}"/>
		</e:panel>

		<e:panel id="Panel2" height="fit" width="1%">&nbsp;</e:panel>

		<e:panel id="Panel3" height="fit" width="50%">
			<e:buttonBar id="buttonBar2" align="right" width="100%" title="${MAUA0010_TITLE2}">
				<e:button id="UserSearch" name="UserSearch" label="${UserSearch_N }" disabled="${UserSearch_D }" visible="${UserSearch_V}" onClick="doUserSearch" />
				<e:button id="UserSave" name="UserSave" label="${UserSave_N }" disabled="${UserSave_D }" visible="${UserSave_V}" onClick="doUserSave" />
				<e:button id="UserDelete" name="UserDelete" label="${UserDelete_N }" disabled="${UserDelete_D }" visible="${UserDelete_V}" onClick="doUserDelete" />
			</e:buttonBar>

			<e:gridPanel id="gridDT" name="gridDT" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}"/>
		</e:panel>

	</e:window>
</e:ui>

