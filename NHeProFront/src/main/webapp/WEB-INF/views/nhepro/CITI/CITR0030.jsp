<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
	    
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">

	 <script type="text/javascript">
	        
	    var grid;
	    var baseUrl = "/nhepro/CITI/CITR0030/";

	    function init() {

	        grid = EVF.C("grid");
		    grid.setProperty('shrinkToFit', ${shrinkToFit});		// 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
		    grid.setProperty('rowNumbers', ${rowNumbers});		    // 로우의 번호 표시 여부를 지정한다. [true/false]
		    grid.setProperty('sortable', ${sortable});			    // 컬럼 정렬기능 사용여부를 지정한다. [true/false]
		    grid.setProperty('panelVisible', ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
		    grid.setProperty('enterToNextRow', ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
		    grid.setProperty('acceptZero', ${acceptZero});		    // 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
		    grid.setProperty('singleSelect', ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]
			grid.setProperty('multiSelect', ${param.detailView == true ? false : multiSelect}); // [선택] 컬럼의 사용여부를 지정한다. [true/false]

			grid.cellClickEvent(function(rowIdx, colIdx, value) {
				var param = null;
				var url = null;

				if(value != "" || colIdx == "RE_REQ_REASON") {
					switch (colIdx) {
						case "ITEM_REQ_NO":
							if(grid.getCellValue(rowIdx, "PROGRESS_CD") == "100") {
								param = {
									BUYER_CD: grid.getCellValue(rowIdx, "BUYER_CD"),
									DEPT_CD: grid.getCellValue(rowIdx, "DEPT_CD"),
									ITEM_REQ_NO: grid.getCellValue(rowIdx, "ITEM_REQ_NO"),
									ITEM_REQ_SEQ: grid.getCellValue(rowIdx, "ITEM_REQ_SEQ"),
									detailView: false
								};

								everPopup.openPopupByScreenId('CITA0031', 950, 785, param);
							} else {
								return EVF.alert("${CITR0030_0003}");
							}

							break;

						case "ITEM_REQ_RMK":
							param = {
								title: "추가사양",
								message: grid.getCellValue(rowIdx, "ITEM_REQ_RMK"),
								rowIdx: rowIdx,
								detailView : true
							};
							url = "/common/popup/common_text_input/view.so";
							everPopup.openModalPopup(url, 500, (param.detailView == true ? 300 : 320), param);
							break;

						case "IMG_UUID":
							param = {
								bizType: "IMG",
								attFileNum: grid.getCellValue(rowIdx, "IMG_UUID"),
								rowIdx: rowIdx,
								detailView: true
							};
							everPopup.fileAttachPopup(param);
							break;

						case "ATTACH_FILE_NO":
							param = {
								bizType: "RE",
								attFileNum: grid.getCellValue(rowIdx, "ATTACH_FILE_NO"),
								rowIdx: rowIdx,
								detailView: true
							};
							everPopup.fileAttachPopup(param);
							break;


						case "RE_REQ_REASON":
							param = {
								title: "회신사유",
								message: grid.getCellValue(rowIdx, "RE_REQ_REASON"),
								callbackFunction: "setReReqReason",
								rowIdx: rowIdx,
								detailView: false
							};

							url = "/common/popup/common_text_input/view.so";
							everPopup.openModalPopup(url, 500, (param.detailView == true ? 300 : 320), param);
							break;

						case "DEL_REQ_REASON":
							param = {
								title: "삭제사유",
								message: grid.getCellValue(rowIdx, "DEL_REQ_REASON"),
								rowIdx: rowIdx,
								detailView: true
							};

							url = "/common/popup/common_text_input/view.so";
							everPopup.openModalPopup(url, 500, (param.detailView == true ? 300 : 320), param);
							break;
					}
				}
			});

			grid.cellChangeEvent(function(rowIdx, colIdx, iRow, iCol, value, oldValue) {
            });
			
			grid.excelExportEvent({
				allItems : "${excelExport.allCol}",
				fileName : "${screenName }"
			});
			
		    grid.setColIconify("ITEM_REQ_RMK", "ITEM_REQ_RMK", "detail", true);
		    grid.setColIconify("IMG_UUID", "IMG_UUID", "detail", true);
		    grid.setColIconify("ATTACH_FILE_NO", "ATTACH_FILE_NO", "file", true);
		    //grid.setColIconify("RE_REQ_REASON", "RE_REQ_REASON", "detail", true);
		    //grid.setColIconify("DEL_REQ_REASON", "DEL_REQ_REASON", "detail", true);
	    }

	    function getCustomUser() {
	    	var param = {
                    callBackFunction : "setCustomUser",
                    'READONLY': 'Y',         //팝업 조회조건 변경불가
        			'multiYN' : 'N',         //멀티팝업여부
        			'detailView': false

                };
            everPopup.openPopupByScreenId("CCDU0020", 1100, 700, param);
		}

		function setCustomUser(data) {
			if(data!=null){
				data = JSON.parse(data);
		    	EVF.V("REG_USER_ID", data.USER_ID);
				EVF.V("REG_USER_NM", data.USER_NM);
			}
		}

		function doSearch() {
			var store = new EVF.Store();
			if(!store.validate()) { return; }
			store.setGrid([grid]);
			store.load(baseUrl + "citr0030_doSearch.so", function() {
				if (grid.getRowCount() == 0) {
					EVF.alert("${msg.M0002 }");
				}
			});
		}

	    function doRequest() {

		    if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

		    var rowIds = grid.getSelRowId();
		    for (var i = 0; i < rowIds.length; i++) {
			    if (grid.getCellValue(rowIds[i], "PROGRESS_CD") != "100") {
				    return EVF.alert("${CITR0030_0001}");
			    }
		    }

		    if (!grid.validate().flag) { return EVF.alert(grid.validate().msg); }

		    var store = new EVF.Store();
		    if(!store.validate()) { return; }
		    store.setGrid([grid]);
		    store.getGridData(grid, "sel");
		    store.load(baseUrl + "citr0030_doRequest.so", function() {
				EVF.alert("${CITR0030_0002}", function() {
					doSearch();
				});
		    });
	    }

	    function setReReqReason(data) {
			grid.setCellValue(data.rowIdx, 'RE_REQ_REASON', data.message);
	    }

    </script>
	<e:window id="CITR0030" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">

		<e:searchPanel id="form" title="${form_CAPTION_N }" labelWidth="${labelWidth}" width="100%" columnCount="3" useTitleBar="false" onEnter="doSearch">
			<e:row>
				<%-- 요청일자 --%>
				<e:label for="START_DATE" title="${form_START_DATE_N}"/>
				<e:field>
					<e:inputDate id="START_DATE" name="START_DATE" value="${START_DATE}" width="${inputDateWidth}" datePicker="true" required="${form_START_DATE_R}" disabled="${form_START_DATE_D}" readOnly="${form_START_DATE_RO}" />
					<e:text>~</e:text>
					<e:inputDate id="END_DATE" name="END_DATE" value="${END_DATE}" width="${inputDateWidth}" datePicker="true" required="${form_END_DATE_R}" disabled="${form_END_DATE_D}" readOnly="${form_END_DATE_RO}" />
				</e:field>
				<%-- 품명 --%>
				<e:label for="ITEM_DESC" title="${form_ITEM_DESC_N}" />
				<e:field>
					<e:inputText id="ITEM_DESC" name="ITEM_DESC" value="" width="${form_ITEM_DESC_W}" maxLength="${form_ITEM_DESC_M}" disabled="${form_ITEM_DESC_D}" readOnly="${form_ITEM_DESC_RO}" required="${form_ITEM_DESC_R}" style="${imeMode}" maskType="${form_ITEM_DESC_MT}"/>
				</e:field>
				<%-- 요청자 --%>
				<e:label for="REG_USER_ID" title="${form_REG_USER_ID_N}"/>
				<e:field>
					<e:search id="REG_USER_ID" name="REG_USER_ID" value="" width="40%" maxLength="${form_REG_USER_ID_M}" onIconClick="${form_REG_USER_ID_RO ? 'everCommon.blank' : 'getCustomUser'}" disabled="${form_REG_USER_ID_D}" readOnly="${form_REG_USER_ID_RO}" required="${form_REG_USER_ID_R}" maskType="${form_REG_USER_ID_MT}" placeHolder="개인번호" />
					<e:inputText id="REG_USER_NM" name="REG_USER_NM" value="" width="60%" maxLength="${form_REG_USER_NM_M}" disabled="${form_REG_USER_NM_D}" readOnly="${form_REG_USER_NM_RO}" required="${form_REG_USER_NM_R}" style="${imeMode}" maskType="${form_REG_USER_NM_MT}" placeHolder="성명"/>
				</e:field>
			</e:row>
			<e:row>
				<%-- 진행상태 --%>
				<e:label for="PROGRESS_CD" title="${form_PROGRESS_CD_N}"/>
				<e:field>
					<e:select id="PROGRESS_CD" name="PROGRESS_CD" value="" options="${progressCdOptions}" width="${form_PROGRESS_CD_W}" disabled="${form_PROGRESS_CD_D}" readOnly="${form_PROGRESS_CD_RO}" required="${form_PROGRESS_CD_R}" placeHolder="" maskType="${form_PROGRESS_CD_MT}" />
				</e:field>
				<%-- 규격 --%>
				<e:label for="ITEM_SPEC" title="${form_ITEM_SPEC_N}" />
				<e:field>
					<e:inputText id="ITEM_SPEC" name="ITEM_SPEC" value="" width="${form_ITEM_SPEC_W}" maxLength="${form_ITEM_SPEC_M}" disabled="${form_ITEM_SPEC_D}" readOnly="${form_ITEM_SPEC_RO}" required="${form_ITEM_SPEC_R}" style="${imeMode}" maskType="${form_ITEM_SPEC_MT}"/>
				</e:field>
				<%-- 품목코드 --%>
				<e:label for="ITEM_CD" title="${form_ITEM_CD_N}" />
				<e:field>
					<e:inputText id="ITEM_CD" name="ITEM_CD" value="" width="${form_ITEM_CD_W}" maxLength="${form_ITEM_CD_M}" disabled="${form_ITEM_CD_D}" readOnly="${form_ITEM_CD_RO}" required="${form_ITEM_CD_R}" style="${imeMode}" maskType="${form_ITEM_CD_MT}"/>
				</e:field>
			</e:row>
		</e:searchPanel>

		<e:buttonBar align="right" width="100%">
			<e:button id="doSearch" name="doSearch" label="${doSearch_N}" onClick="doSearch" disabled="${doSearch_D}" visible="${doSearch_V}"/>
			<e:button id="doRequest" name="doRequest" label="${doRequest_N}" onClick="doRequest" disabled="${doRequest_D}" visible="${doRequest_V}"/>
		</e:buttonBar>

		<e:gridPanel id="grid" name="grid" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}" />

	</e:window>
</e:ui>