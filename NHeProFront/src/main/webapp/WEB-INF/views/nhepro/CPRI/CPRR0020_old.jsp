<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">

	<script type="text/javascript">

	    var gridHD; var gridDT;

	    var baseUrl = "/nhepro/CPRI/CPRR0020/";

	    function init() {

	        gridHD = EVF.C("gridHD");
	        //gridDT = EVF.C("gridDT");

	        gridHD.cellClickEvent(function(rowIdx, colIdx, value) {
	        	if(colIdx == "BS_CD") {
	        		var bsCd = gridHD.getCellValue(rowIdx, 'BS_CD');
	        		if (bsCd == "") return;

	        		var param = {
        				'BS_CD': bsCd,
        				'detailView': true,
        				'popupFlag': true
        			};
	        		everPopup.bsInfo(param);
				}
	        	if(colIdx == "multiSelect" || colIdx == "PR_NUM" || colIdx == "PROGRESS_LOC") {
	        		//setGridDT(rowIdx);
				}
			});

	        gridHD.excelExportEvent({
				allItems : "${excelExport.allCol}",
				fileName : "${screenName }"
			});

	        /*
	        gridDT.excelExportEvent({
				allItems : "${excelExport.allCol}",
				fileName : "${screenName }"
			});
			*/
	        gridHD.setColGroup([{
				  "groupName": '${form_TEXT1_N}',
				  "columns": [ "ITEM_ALL", "ITEM_RETURN" ]
			}], 45);

			gridHD.setProperty('shrinkToFit', ${shrinkToFit});			// 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
			gridHD.setProperty('rowNumbers', ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
			gridHD.setProperty('sortable', ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
			gridHD.setProperty('panelVisible', ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
			gridHD.setProperty('enterToNextRow', ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
			gridHD.setProperty('acceptZero', ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
			gridHD.setProperty('multiSelect', ${multiSelect});			// [선택] 컬럼의 사용여부를 지정한다. [true/false]
			gridHD.setProperty('singleSelect', true);					// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]
/*
			gridDT.setProperty('shrinkToFit', ${shrinkToFit});			// 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
			gridDT.setProperty('rowNumbers', ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
			gridDT.setProperty('sortable', ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
			gridDT.setProperty('panelVisible', ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
			gridDT.setProperty('enterToNextRow', ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
			gridDT.setProperty('acceptZero', ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
			gridDT.setProperty('multiSelect', false);					// [선택] 컬럼의 사용여부를 지정한다. [true/false]
			gridDT.setProperty('singleSelect', ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]
	        gridDT.setRowHeightAll(40);
*/

	        EVF.C('PROGRESS_CD').addOption("${CPRR0020_001}", "Z");

			if ('${defaultPrType}' == 'ITM') {
				if (${!havePermission}) {
		    		EVF.C('REQ_DEPT_CD').setDisabled(true);
		    		EVF.C('REQ_DEPT_NM').setDisabled(true);
				}
			} else {
/*
				gridDT.hideCol('VALID_FROM_DATE', true);
				gridDT.hideCol('VALID_TO_DATE', true);
*/
			}
	    }
/*
	    function setGridDT(rowIdx) {

	    	gridHD.checkRow(rowIdx, true, true);

	    	var store = new EVF.Store();
			if(!store.validate()) { return; }
	        store.setGrid([gridDT]);
	        store.setParameter("PR_NUM", gridHD.getCellValue(rowIdx, 'PR_NUM'));
	        store.setParameter("PR_CNT", gridHD.getCellValue(rowIdx, 'PR_CNT'));
	        store.load(baseUrl + 'CPRR0020_doSearchDT.so', function() {
	        	if(gridDT.getRowCount() == 0){
	            	EVF.alert("${msg.M0002 }");
	            } else {
	            	var	val	= {"visible": true,	"count": 1,	"height": 26};
					gridDT.setProperty('footerVisible', val);

					footerText = {
						"text":	"${CPRR0020_002}",
						"styles": {
							  "fontBold": true,
							  "textAlignment": "per"
						}
					};
					gridDT._gvo.setColumnProperty('ITEM_SPEC', 'footer', footerText);

					footer = {
						"expression": "sum",
						"styles": {
							  "numberFormat": "#,##0",
							  "fontBold": true,
							  "textAlignment": "far"
						}
					};
					gridDT._gvo.setColumnProperty('PR_QT', 'footer', footer);
					gridDT._gvo.setColumnProperty('PR_AMT', 'footer',	footer);
	            }
	        });
	    }
*/
	    function doSearch() {

	    	var deptFlag = "0";
	    	var ctrlList = "${ses.ctrlCd}".split(",");
	    	for(var k = 0; k < ctrlList.length; k++) {
	        	if(!EVF.isEmpty(ctrlList[k])) {
	        		if(ctrlList[k] === "I100") { deptFlag = "1"; }
	        	}
	   	 	}
	    	for(var k = 0; k < ctrlList.length; k++) {
	        	if(!EVF.isEmpty(ctrlList[k])) {
	        		if(ctrlList[k] === "S100" || ctrlList[k] === "N100" || ctrlList[k] === "C100") { deptFlag = "2"; }
	        	}
	   	 	}

	    	if (EVF.V("PR_TYPE") == 'ITM') {
	    		deptFlag = "0";
	    	}

	    	var store = new EVF.Store();
			if(!store.validate()) { return; }
	        store.setGrid([gridHD]);
	        store.setParameter("DEPT_FLAG", deptFlag);
	        store.load(baseUrl + 'CPRR0020_doSearchHD.so', function() {
	        	if(gridHD.getRowCount() == 0){
	            	gridDT.delAllRow();
					EVF.alert("${msg.M0002 }");
				} else {
	            	setGridDT(0);
	            }
	        });
	    }

	    function doModify() {

	    	if (gridHD.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

	    	var prNum = ""; var prCnt = "";
	    	var rowIds = gridHD.getSelRowId();
	    	for(var i in rowIds) {
	    		prNum = gridHD.getCellValue(rowIds[i], 'PR_NUM');
	    		prCnt = gridHD.getCellValue(rowIds[i], 'PR_CNT');
    		}

	    	var param = {
				'PR_NUM': prNum,
				'PR_CNT': prCnt,
				'PR_TYPE': EVF.V("PR_TYPE"),
				'detailView': false,
				'popupFlag': true
			};
	    	everPopup.PRInfo(param);
	    }

	    function getBsCd() {
	    	var param = {
				'detailView': false,
				callBackFunction : "setBsCd"
			};
	    	everPopup.getBsCd(param);
		}

	    function setBsCd(dataJsonArray) {
			EVF.V("BS_CD", dataJsonArray.CODE);
			EVF.V("BS_NM", dataJsonArray.TEXT);
		}

	    function getUserId() {
			var param = {
				callBackFunction : "setUserId"
			};
			everPopup.openCommonPopup(param, 'SP0011');
		}

		function setUserId(dataJsonArray) {
			EVF.V("REQ_USER_ID", dataJsonArray.USER_ID);
			EVF.V("REQ_USER_NM", dataJsonArray.USER_NM);
		}

	    function getDeptCd() {
	        var popupUrl = "/siis/M99/M99_008/view.so";
	        var param = {
	            callBackFunction : "setTeam_S",
	            'detailView': false,
	            'multiYN' : false,
	            'ModalPopup' : true
	        };
	        everPopup.openModalPopup(popupUrl, 500, 450, param, "SearchTeamPopup");
		}

	    function setTeam_S(data) {
	        data = JSON.parse(data);
	        var arr = {
	            'DEPT_NM': data.ITEM_CLS_NM,
	            'DEPT_CD': data.ITEM_CLS3
	        };
			EVF.V("REQ_DEPT_CD", arr.DEPT_CD);
			EVF.V("REQ_DEPT_NM", arr.DEPT_NM);
	    }

	    function getSalesUserId() {
			var param = {
				callBackFunction : "setSalesUserId",
				DEPT_CD : "${ses.deptCd}"
			};
			everPopup.openCommonPopup(param, 'SP0099');
		}

	    function setSalesUserId(dataJsonArray) {
			EVF.V("SALES_USER_ID", dataJsonArray.USER_ID);
			EVF.V("SALES_USER_NM", dataJsonArray.USER_NM);
		}

    </script>
	<e:window id="CPRR0020" initData="${initData}" onReady="init" title="${fullScreenName }" breadCrumbs="${breadCrumb }">
		<e:searchPanel id="form" title="${form_CAPTION_N }" labelWidth="105" width="100%" columnCount="3" useTitleBar="false" onEnter="doSearch">
		    <e:inputHidden id="PR_TYPE" name="PR_TYPE" value="${defaultPrType }" />
			<e:row>
				<e:label for="REQ_FROM_DATE" title="${form_REQ_FROM_DATE_N}" />
				<e:field>
					<e:inputDate id="REQ_FROM_DATE" toDate="REQ_TO_DATE" name="REQ_FROM_DATE" value="${reqFromDate }" width="${inputDateWidth }" datePicker="true" required="${form_REQ_FROM_DATE_R}" disabled="${form_REQ_FROM_DATE_D}" readOnly="${form_REQ_FROM_DATE_RO}" />
					<e:text>~</e:text>
					<e:inputDate id="REQ_TO_DATE" fromDate="REQ_FROM_DATE" name="REQ_TO_DATE" value="${reqToDate }" width="${inputDateWidth }" datePicker="true" required="${form_REQ_TO_DATE_R}" disabled="${form_REQ_TO_DATE_D}" readOnly="${form_REQ_TO_DATE_RO}" />
				</e:field>
				<e:label for="RFX_TYPE" title="${form_RFX_TYPE_N}"/>
				<e:field>
					<e:select id="RFX_TYPE" name="RFX_TYPE" value="${defaultRfxType }" options="${rfxTypeOptions}" width="${form_RFX_TYPE_W}" disabled="${form_RFX_TYPE_D}" readOnly="${form_RFX_TYPE_RO}" required="${form_RFX_TYPE_R}" placeHolder=""  maskType="${form_RFX_TYPE_MT}"/>
				</e:field>
				<e:label for="BS_CD" title="${form_BS_CD_N}"/>
				<e:field>
					<e:search id="BS_CD" name="BS_CD" value="" width="35%" maxLength="${form_BS_CD_M}" onIconClick="getBsCd" disabled="${form_BS_CD_D}" readOnly="${form_BS_CD_RO}" required="${form_BS_CD_R}"  maskType="${form_BS_CD_MT}" />
					<e:inputText id="BS_NM" name="BS_NM" value="" width="65%" maxLength="${form_BS_NM_M}" disabled="${form_BS_NM_D}" readOnly="${form_BS_NM_RO}" required="${form_BS_NM_R}"  maskType="${form_BS_NM_MT}" />
				</e:field>
			</e:row>
			<e:row>
				<e:label for="REQ_USER_ID" title="${form_REQ_USER_ID_N}"/>
				<e:field>
					<e:search id="REQ_USER_ID" name="REQ_USER_ID" value="" width="35%" maxLength="${form_REQ_USER_ID_M}" onIconClick="getUserId" disabled="${form_REQ_USER_ID_D}" readOnly="${form_REQ_USER_ID_RO}" required="${form_REQ_USER_ID_R}"  maskType="${form_REQ_USER_ID_MT}" />
					<e:inputText id="REQ_USER_NM" name="REQ_USER_NM" value="" width="65%" maxLength="${form_REQ_USER_NM_M}" disabled="${form_REQ_USER_NM_D}" readOnly="${form_REQ_USER_NM_RO}" required="${form_REQ_USER_NM_R}"  maskType="${form_REQ_USER_NM_MT}" />
				</e:field>
				<e:label for="REQ_DEPT_CD" title="${form_REQ_DEPT_CD_N}"/>
				<e:field>
					<e:search id="REQ_DEPT_CD" name="REQ_DEPT_CD" value="${havePermission ? '' : defaultDeptCd }" width="35%" maxLength="${form_REQ_DEPT_CD_M}" onIconClick="getDeptCd" disabled="${form_REQ_DEPT_CD_D}" readOnly="${form_REQ_DEPT_CD_RO}" required="${form_REQ_DEPT_CD_R}"  maskType="${form_REQ_DEPT_CD_MT}" />
					<e:inputText id="REQ_DEPT_NM" name="REQ_DEPT_NM" value="${havePermission ? '' : defaultDeptNm }" width="65%" maxLength="${form_REQ_DEPT_NM_M}" disabled="${form_REQ_DEPT_NM_D}" readOnly="${form_REQ_DEPT_NM_RO}" required="${form_REQ_DEPT_NM_R}"  maskType="${form_REQ_DEPT_NM_MT}" />
				</e:field>
				<e:label for="SALES_USER_ID" title="${form_SALES_USER_ID_N}"/>
				<e:field>
					<e:search id="SALES_USER_ID" name="SALES_USER_ID" value="" width="35%" maxLength="${form_SALES_USER_ID_M}" onIconClick="getSalesUserId" disabled="${form_SALES_USER_ID_D}" readOnly="${form_SALES_USER_ID_RO}" required="${form_SALES_USER_ID_R}"  maskType="${form_SALES_USER_ID_MT}" />
					<e:inputText id="SALES_USER_NM" name="SALES_USER_NM" value="" width="65%" maxLength="${form_SALES_USER_NM_M}" disabled="${form_SALES_USER_NM_D}" readOnly="${form_SALES_USER_NM_RO}" required="${form_SALES_USER_NM_R}"  maskType="${form_SALES_USER_NM_MT}" />
				</e:field>
			</e:row>
			<e:row>
				<e:label for="PR_NUM" title="${form_PR_NUM_N}" />
				<e:field>
					<e:inputText id="PR_NUM" name="PR_NUM" value="" width="35%" maxLength="${form_PR_NUM_M}" disabled="${form_PR_NUM_D}" readOnly="${form_PR_NUM_RO}" required="${form_PR_NUM_R}"  maskType="${form_PR_NUM_MT}" />
					<e:text>/</e:text>
					<e:inputText id="OVERVIEW" name="OVERVIEW" value="" width="59%" maxLength="${form_OVERVIEW_M}" disabled="${form_OVERVIEW_D}" readOnly="${form_OVERVIEW_RO}" required="${form_OVERVIEW_R}"  maskType="${form_OVERVIEW_MT}" />
				</e:field>
				<e:label for="PROGRESS_CD" title="${form_PROGRESS_CD_N}"/>
				<e:field>
					<e:select id="PROGRESS_CD" name="PROGRESS_CD" value="" options="${progressCdOptions}" width="${form_PROGRESS_CD_W}" disabled="${form_PROGRESS_CD_D}" readOnly="${form_PROGRESS_CD_RO}" required="${form_PROGRESS_CD_R}" placeHolder=""  maskType="${form_PROGRESS_CD_MT}"/>
				</e:field>
				<e:label for="RM_NUM" title="${form_RM_NUM_N}"/>
				<e:field>
					<e:inputText id="RM_NUM" name="RM_NUM" value="" width="70%" maxLength="${form_RM_NUM_M}" disabled="${form_RM_NUM_D}" readOnly="${form_RM_NUM_RO}" required="${form_RM_NUM_R}"  maskType="${form_RM_NUM_MT}" />
					<e:text>/</e:text>
					<e:inputNumber id="RM_SQ" name="RM_SQ" value="" width="24%" maxValue="${form_RM_SQ_M}" decimalPlace="${form_RM_SQ_NF}" disabled="${form_RM_SQ_D}" readOnly="${form_RM_SQ_RO}" required="${form_RM_SQ_R}"  onNumberKr="${form_RM_SQ_KR}" currencyText="${form_RM_SQ_CT}" />
				</e:field>
			</e:row>
		</e:searchPanel>

		<e:buttonBar id="buttonBar" align="right" width="100%">
			<e:button id="Search" name="Search" label="${Search_N }" disabled="${Search_D }" visible="${Search_V}" onClick="doSearch" />
			<e:button id="Modify" name="Modify" label="${Modify_N }" disabled="${Modify_D }" visible="${Modify_V}" onClick="doModify" />
		</e:buttonBar>

		<e:gridPanel id="gridHD" name="gridHD" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}" />

		<!-- e:gridPanel id="gridDT" name="gridDT" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}" /-->

	</e:window>
</e:ui>