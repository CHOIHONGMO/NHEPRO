<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
    <script type="text/javascript">

    	var gridHD = {};
    	var gridDT = {};
    	var addParamHD = [];
    	var addParamDT = [];
    	var baseUrl = "/eversrm/manager/basic/";
    	var flag = "";

		function init() {

			gridHD = EVF.C('gridHD');
			gridDT = EVF.C('gridDT');

			gridHD.cellClickEvent(function(rowIdx, colIdx) {
				if(EVF.isEmpty(gridHD.getCellValue(rowIdx, 'BUYER_CD'))) {
					if (colIdx == 'BUYER_NM') {
						var param = {
							rowIdx: rowIdx,
							callBackFunction: "selectCustGrid"
						};
						everPopup.openCommonPopup(param, 'SP0067');
					}
				}
				if (colIdx == 'TMPL_NUM') {
					if(!EVF.isEmpty(gridHD.getCellValue(rowIdx, 'TMPL_NUM'))) {
						EVF.V("HIDDE_TMPL_NUM", gridHD.getCellValue(rowIdx, 'TMPL_NUM'));
						EVF.V("HIDDE_DOC_TYPE", gridHD.getCellValue(rowIdx, 'DOC_TYPE'));
						doSearchDT();
					}
				}
			});

			gridHD.addRowEvent(function() {
				addParamHD = [{
					"USE_FLAG": "1"
				}];
				gridHD.addRow(addParamHD);
			});

			gridHD.delRowEvent(function() {
				if (gridHD.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
				gridHD.delRow();
			});

			gridHD.excelExportEvent({
				allItems : "${excelExport.allCol}",
				fileName : "${screenName }"
			});

			gridHD.setProperty('shrinkToFit', true);				// 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
			gridHD.setProperty('rowNumbers', ${rowNumbers});		// 로우의 번호 표시 여부를 지정한다. [true/false]
			gridHD.setProperty('sortable', ${sortable});			// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
			gridHD.setProperty('panelVisible', ${panelVisible});	// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
			gridHD.setProperty('enterToNextRow', ${enterToNextRow});// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
			gridHD.setProperty('acceptZero', ${acceptZero});		// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
			gridHD.setProperty('multiSelect', ${param.detailView == true ? false : multiSelect}); // [선택] 컬럼의 사용여부를 지정한다. [true/false]

			gridDT.cellClickEvent(function(rowIdx, colIdx) {
				if (colIdx == 'TMPL_FILE_NUM') {
					var param = {
						attFileNum: gridDT.getCellValue(rowIdx, 'TMPL_FILE_NUM'),
						rowIdx: rowIdx,
						callBackFunction: 'setFileAttach',
						bizType: 'MBSA',
						detailView : false,
						fileExtension : '*'

					};
					everPopup.fileAttachPopup(param);
				}
				if (colIdx == 'REMARK') {
					var param = {
						title: "${MBSA0040_0004}",
						message: gridDT.getCellValue(rowIdx, 'REMARK'),
						callbackFunction: 'setRMK',
						rowIdx: rowIdx
					};
					everPopup.commonTextInput(param);
				}
			});

			gridDT.addRowEvent(function() {

				if(EVF.isEmpty(EVF.V('HIDDE_TMPL_NUM'))) {
					return EVF.alert("${MBSA0040_0003}"); // 등록하고자 하는 템플릿 번호를 선택하세요.
				}
				addParamDT = [{
					"BUYER_CD": EVF.V('BUYER_CD'),
					"DOC_TYPE": EVF.V('HIDDE_DOC_TYPE'),
					"TMPL_NUM": EVF.V('HIDDE_TMPL_NUM'),
					"USE_FLAG": "1"
				}];
				gridDT.addRow(addParamDT);
			});

			gridDT.delRowEvent(function() {
				if (gridDT.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
				gridDT.delRow();
			});

			gridDT.excelExportEvent({
				allItems : "${excelExport.allCol}",
				fileName : "${screenName }"
			});

			gridDT.setProperty('shrinkToFit', ${shrinkToFit});
			gridDT.setProperty('rowNumbers', ${rowNumbers});
			gridDT.setProperty('sortable', ${sortable});
			gridDT.setProperty('panelVisible', ${panelVisible});
			gridDT.setProperty('enterToNextRow', ${enterToNextRow});
			gridDT.setProperty('acceptZero', ${acceptZero});
			gridDT.setProperty('multiSelect', ${param.detailView == true ? false : multiSelect});
        }

        function doSearchHD() {

			gridDT.delAllRow();

			var store = new EVF.Store();
			if(!store.validate()) { return; }
        	store.setGrid([gridHD]);
            store.load(baseUrl + 'mbsa0040_doSearchHD.so', function() {
                if(gridHD.getRowCount() == 0){
                	EVF.alert("${msg.M0002 }");
                }
				var allRowId = gridHD.getAllRowId();
				for(var i in allRowId) {
					if(!EVF.isEmpty(gridHD.getCellValue(allRowId[i], 'DOC_TYPE'))) {
						gridHD.setCellReadOnly(allRowId[i], 'DOC_TYPE', true);
					}
				}
            });
        }

		function doSearchDT() {

			var store = new EVF.Store();
			store.setGrid([gridDT]);
			store.load(baseUrl + 'mbsa0040_doSearchDT.so', function() {
				if(gridDT.getRowCount() == 0){
					EVF.alert("${msg.M0002 }");
				}
				gridDT.setColIconify("TMPL_FILE_NUM", "TMPL_FILE_NUM", "file", false);
				gridDT.setColIconify("REMARK", "REMARK", "comment", false);
			});
		}

        function doSaveHD() {

			if(EVF.isEmpty(EVF.V('BUYER_CD'))) {
				return EVF.alert("${MBSA0040_0001}"); <%-- 등록하고자 하는 고객사의 정보를 먼저 조회하세요. --%>
			}

            if(gridHD.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

            if(!gridHD.validate().flag) { return EVF.alert(gridHD.validate().msg); }

			var rowIds = gridHD.getAllRowId();
			for(var i = 0; i < rowIds.length; i++) {
				for (var j = (i+1); j < rowIds.length; j++) {
					if (gridHD.getCellValue(rowIds[j], "BUYER_CD") == gridHD.getCellValue(rowIds[i], "BUYER_CD")) {
						if (gridHD.getCellValue(rowIds[j], "DOC_TYPE") == gridHD.getCellValue(rowIds[i], "DOC_TYPE")) {
							if (gridHD.getCellValue(rowIds[j], "USE_FLAG") == "1" && (gridHD.getCellValue(rowIds[j], "USE_FLAG") == gridHD.getCellValue(rowIds[i], "USE_FLAG"))) {
								gridHD.setCellValue(rowIds[j], 'DOC_TYPE', '');
								return EVF.alert("${MBSA0040_0002}");
							}
						}
					}
				}
			}

			EVF.confirm("${msg.M0021 }", function() {
				var store = new EVF.Store();
				store.setGrid([gridHD]);
				store.getGridData(gridHD, 'sel');
				store.load(baseUrl + 'mbsa0040_doSaveHD.so', function(){
					EVF.alert(this.getResponseMessage(), function() {
						doSearchHD();
					});
				});
			});
		}

		function doDeleteHD() {

			if (gridHD.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

			EVF.confirm("${msg.M0013 }", function() {
				var store = new EVF.Store();
				store.setGrid([gridHD]);
				store.getGridData(gridHD, 'sel');
				store.load(baseUrl + 'mbsa0040_doDeleteHD.so', function(){
					EVF.alert(this.getResponseMessage(), function() {
						doSearchHD();
					});
				});
			});

		}

		function doSaveDT() {

			if (gridDT.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

			if(!gridDT.validate().flag) { return EVF.alert(gridDT.validate().msg); }

			EVF.confirm("${msg.M0021 }", function () {
				var store = new EVF.Store();
				store.setGrid([gridDT]);
				store.getGridData(gridDT, 'sel');
				store.load(baseUrl + 'mbsa0040_doSaveDT.so', function(){
					EVF.alert(this.getResponseMessage(), function() {
						doSearchDT();
					});
				});
			});
		}

		function doDeleteDT() {

			if (gridDT.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

			EVF.confirm("${msg.M0013 }", function () {
				var store = new EVF.Store();
				store.setGrid([gridDT]);
				store.getGridData(gridDT, 'sel');
				store.load(baseUrl + 'mbsa0040_doDeleteDT.so', function(){
					EVF.alert(this.getResponseMessage(), function() {
						doSearchDT();
					});
				});
			});
		}

		function setFileAttach(rowIdx, fileId, fileCnt) {
			gridDT.setCellValue(rowIdx, 'TMPL_FILE_NUM', fileId);
			gridDT.setColIconify("TMPL_FILE_NUM", "TMPL_FILE_NUM", "file", false);
		}

		function setRMK(data) {
			gridDT.setCellValue(data.rowIdx, "REMARK", data.message);
			gridDT.setColIconify("REMARK", "REMARK", "comment", false);
		}

		function searchCust() {
			var param = {
				callBackFunction : "selectCust"
			};
			everPopup.openCommonPopup(param, 'SP0067');
		}

		function selectCust(dataJsonArray) {
			EVF.V("BUYER_CD", dataJsonArray.CUST_CD);
			EVF.V("BUYER_NM", dataJsonArray.CUST_NM);
		}

		function selectCustGrid(dataJsonArray) {
			gridHD.setCellValue(dataJsonArray.rowIdx, 'BUYER_CD', dataJsonArray.CUST_CD);
			gridHD.setCellValue(dataJsonArray.rowIdx, 'BUYER_NM', dataJsonArray.CUST_NM);
		}

		function clearCust() {
			EVF.V("BUYER_CD", "");
		}

	</script>
	<e:window id="MBSA0040" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">
		<e:panel id="PanelID" height="100%" width="100%">
			<e:searchPanel id="form" title="${form_CAPTION_N }" labelWidth="120" width="100%" columnCount="3" onEnter="doSearchHD" useTitleBar="false">
				<e:row>
					<e:label for="BUYER_NM" title="${form_BUYER_NM_N}"/>
					<e:field>
						<e:search id="BUYER_CD" name="BUYER_CD" value="${ses.companyCd }" width="40%" maxLength="${form_BUYER_CD_M}" onIconClick="${form_BUYER_CD_D ? 'everCommon.blank' : 'searchCust'}" disabled="${form_BUYER_CD_D}" readOnly="${form_BUYER_CD_RO}" required="${form_BUYER_CD_R}" maskType="${form_BUYER_CD_MT}" placeHolder="회사코드" />
						<e:inputText id="BUYER_NM" name="BUYER_NM" value="${ses.companyNm }" width="60%" maxLength="${form_BUYER_NM_M}" disabled="${form_BUYER_NM_D}" readOnly="${form_BUYER_NM_RO}" required="${form_BUYER_NM_R}" maskType="${form_BUYER_NM_MT}" placeHolder="회사명" />
					</e:field>
					<e:label for="DOC_TYPE" title="${form_DOC_TYPE_N }" />
					<e:field>
						<e:select id="DOC_TYPE" name="DOC_TYPE" value="" options="${docTypeOptions}" width="${form_DOC_TYPE_W}" disabled="${form_DOC_TYPE_D}" readOnly="${form_DOC_TYPE_RO}" required="${form_DOC_TYPE_R}" placeHolder="" maskType="${form_DOC_TYPE_MT}"/>
					</e:field>
					<e:label for="TMPL_NM" title="${form_TMPL_NM_N }" />
					<e:field>
						<e:inputText id="TMPL_NM" name="TMPL_NM" label="${form_TMPL_NM_N }" readOnly="${form_TMPL_NM_RO }" disabled="${form_TMPL_NM_N }" maxLength="${form_TMPL_NM_M}" width="${form_TMPL_NM_W}" required="${form_TMPL_NM_R }"  maskType="${form_TMPL_NM_MT}" />
						<e:inputHidden id="HIDDE_TMPL_NUM" name="HIDDE_TMPL_NUM" />
						<e:inputHidden id="HIDDE_DOC_TYPE" name="HIDDE_DOC_TYPE" />
					</e:field>
				</e:row>
				<e:row>
					<e:label for="REG_START_DATE" title="${form_REG_START_DATE_N}"/>
					<e:field>
						<e:inputDate id="REG_START_DATE" name="REG_START_DATE" toDate="REG_END_DATE" value="" width="${inputDateWidth}" datePicker="true" required="${form_REG_START_DATE_R}" disabled="${form_REG_START_DATE_D}" readOnly="${form_REG_START_DATE_RO}" />
						<e:text>&nbsp;~&nbsp;</e:text>
						<e:inputDate id="REG_END_DATE" name="REG_END_DATE" fromDate="REG_START_DATE" value="" width="${inputDateWidth}" datePicker="true" required="${form_REG_END_DATE_R}" disabled="${form_REG_END_DATE_D}" readOnly="${form_REG_END_DATE_RO}" />
					</e:field>
					<e:label for="USE_FLAG" title="${form_USE_FLAG_N }" />
					<e:field colSpan="3">
						<e:select id="USE_FLAG" name="USE_FLAG" value="" options="${useFlagOptions}" width="${form_USE_FLAG_W}" disabled="${form_USE_FLAG_D}" readOnly="${form_USE_FLAG_RO}" required="${form_USE_FLAG_R}" placeHolder="" maskType="${form_USE_FLAG_MT}"/>
					</e:field>
				</e:row>
			</e:searchPanel>

			<e:panel id="leftPanel" height="100%" width="46%">
				<e:buttonBar id="buttonBarHDTop" align="right" width="100%">
					<e:button id="SearchHD" name="SearchHD" label="${SearchHD_N }" disabled="${SearchHD_D }" onClick="doSearchHD" />
					<e:button id="SaveHD" name="SaveHD"  label="${SaveHD_N }" disabled="${SaveHD_D }" onClick="doSaveHD" />
					<%-- e:button id="DeleteHD" name="DeleteHD" label="${DeleteHD_N }" disabled="${DeleteHD_D }" onClick="doDeleteHD" / --%>
				</e:buttonBar>
				<e:gridPanel id="gridHD" name="gridHD" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}"/>
			</e:panel>
			<e:panel id="middlePanel" height="100%" width="1%">&nbsp;</e:panel>
			<e:panel id="rightPanel" height="100%" width="53%">
				<e:buttonBar id="buttonBarDTTop" align="right" width="100%">
					<e:button id="SaveDT" name="SaveDT"  label="${SaveDT_N }" disabled="${SaveDT_D }" onClick="doSaveDT" />
					<e:button id="DeleteDT" name="DeleteDT" label="${DeleteDT_N }" disabled="${DeleteDT_D }" onClick="doDeleteDT" />
				</e:buttonBar>
				<e:gridPanel id="gridDT" name="gridDT" width="100%" height="fit" virtualScroll="true" gridType="${_gridType}" readOnly="${param.detailView}"/>
			</e:panel>
        </e:panel>
    </e:window>
</e:ui>