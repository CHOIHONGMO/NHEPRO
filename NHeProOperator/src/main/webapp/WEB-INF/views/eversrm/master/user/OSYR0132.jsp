<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
    <script>

		var grid;
		var baseUrl = '/eversrm/master/user/';

		function init() {

			grid = EVF.C('grid');

			grid.cellClickEvent(function (rowIdx, celName, value) {

				var param = {};

				// cell one click
				switch (celName) {
					case "MASK_RMK":
                        param = {
                            POPUPFLAG: "Y"
                            , detailView: true
	                        , MASK_SQ: grid.getCellValue(rowIdx, "MASK_SQ")
                            , ACCESS_DATE: grid.getCellValue(rowIdx, "ACCESS_DATE")
                            , USER_ID: grid.getCellValue(rowIdx, "USER_ID")
	                        , PARAM_SCREEN_ID: grid.getCellValue(rowIdx, "SCREEN_ID")
	                        , MASK_RMK: grid.getCellValue(rowIdx, "MASK_RMK")
                        };
						everPopup.openPopupByScreenId("OSYR0131", 750, 265, param);
						break;

                    case "MASK_APPROVAL_RETURN":

	                    if (value != "") {
		                    param = {
			                    detailView: true,
			                    SIGN_RMK: value
		                    };
		                    everPopup.openApprovalRemarkPopup(param);
	                    }
                    	break;

                    case "USER_ID":
	                    if (grid.getCellValue(rowIdx, "USER_ID") != "") {
		                    param = {
			                    callbackFunction : "",
			                    USER_TYPE : 'O',  // O:운영사, B:고객사, S:공급사
			                    USER_ID : grid.getCellValue(rowIdx, 'USER_ID'),
			                    detailView : true
		                    };
		                    everPopup.openPopupByScreenId("BYM1_062", 600, 190, param);
	                    }
	                    break;
				}
			});

			grid.cellChangeEvent(function(rowIdx, celName, iRow, iCol, value, oldValue) {

				var param = {};

				// cell one click
				switch (celName) {
					case "MASK_APPROVAL":
						if (value == "R" && grid.getCellValue(rowIdx, "MASK_APPROVAL_RETURN") == "") {
							param = {
								approvalType: value,
                                rowIdx: rowIdx
                            };
							everPopup.openApprovalRemarkPopup(param);
                        }
						break;
				}
            });

            grid.setProperty('shrinkToFit', ${shrinkToFit});		// 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
            grid.setProperty('rowNumbers', ${rowNumbers});		    // 로우의 번호 표시 여부를 지정한다. [true/false]
            grid.setProperty('sortable', ${sortable});			    // 컬럼 정렬기능 사용여부를 지정한다. [true/false]
            grid.setProperty('panelVisible', ${panelVisible});	    // 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            grid.setProperty('enterToNextRow', ${enterToNextRow}); // 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            grid.setProperty('acceptZero', ${acceptZero});		    // 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            grid.setProperty('singleSelect', ${singleSelect});	    // [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]
            grid.setProperty('multiSelect', ${param.detailView == true ? false : multiSelect}); // [선택] 컬럼의 사용여부를 지정한다. [true/false]

            // Grid Excel Event
            grid.excelExportEvent({
                allItems: "${excelExport.allCol}",
                fileName: "${screenName }"
            });
		}

		function doApprovalOrReject(data) {
			grid.setCellValue(data.rowIdx, "MASK_APPROVAL_RETURN", data.SIGN_RMK);
        }

		// Search
		function doSearch() {

			var store = new EVF.Store();
			store.setGrid([grid]);
			store.load(baseUrl + 'OSYR0132/doSearch.so', function () {
				if (grid.getRowCount() == 0) {
					return EVF.alert('${msg.M0002}');
				} else {
					grid.setColIconify("MASK_RMK", "MASK_RMK", "detail", false);
					grid.setColIconify("MASK_APPROVAL_RETURN", "MASK_APPROVAL_RETURN", "detail", false);
				}
			});
		}

		// Save
		function doUpdate() {

			for(var i in grid.getSelRowValue()) {

				var selValue = grid.getSelRowValue()[i];

				if (selValue.MASK_APPROVAL == "R" && selValue.MASK_APPROVAL_RETURN == "") {
					EVF.alert("${OSYR0132_0001}");
					var param = {
						detailView: false
					};
					everPopup.openApprovalRemarkPopup(param);
					return;
				}
			}

			var store = new EVF.Store();
			EVF.confirm("${msg.M0021}", function () {
				store.setGrid([grid]);
				store.getGridData(grid, 'sel');
				store.load(baseUrl + 'OSYR0132/doUpdate.so', function () {
					EVF.alert(this.getResponseMessage(), function () {
						doSearch();
					});
				});
			});
		}

		function doSearchUser() {
			var param = {
				callBackFunction: "selectUser"
			};
			everPopup.openCommonPopup(param,"SP0011");
		}

		function selectUser(data) {
			EVF.V("USER_ID", data.USER_ID);
			EVF.V("USER_NM", data.USER_NM);
		}

    </script>

    <e:window id="OSYR0132" initData="${initData}" onReady="init" title="${fullScreenName }" breadCrumbs="${breadCrumb }">
        <e:searchPanel id="form" title="${msg.M9999}" labelWidth="100" width="100%" columnCount="2" onEnter="doSearch">
            <e:row>
                <%-- 요청일자 --%>
                <e:label for="FROM_DATE" title="${form_FROM_DATE_N}"/>
                <e:field>
                    <e:inputDate id="FROM_DATE" name="FROM_DATE" toDate="TO_DATE" value="${defaultFromDate}" width="${inputDateWidth}" datePicker="true" required="${form_FROM_DATE_R}" disabled="${form_FROM_DATE_D}" readOnly="${form_FROM_DATE_RO}" />
                    <e:text> ~ </e:text>
                    <e:inputDate id="TO_DATE" name="TO_DATE" fromDate="FROM_DATE" value="${defaultToDate}" width="${inputDateWidth}" datePicker="true" required="${form_TO_DATE_R}" disabled="${form_TO_DATE_D}" readOnly="${form_TO_DATE_RO}" />
                </e:field>
                <%-- 사용자 --%>
                <e:label for="USER_ID" title="${form_USER_ID_N}"/>
                <e:field>
                    <e:search id="USER_ID" name="USER_ID" value="" width="40%" maxLength="${form_USER_ID_M}" onIconClick="${form_USER_ID_RO ? 'everCommon.blank' : 'doSearchUser'}" disabled="${form_USER_ID_D}" readOnly="${form_USER_ID_RO}" required="${form_USER_ID_R}" maskType="${form_USER_ID_MT}" />
                    <e:inputText id="USER_NM" name="USER_NM" value="" width="60%" maxLength="${form_USER_NM_M}" disabled="${form_USER_NM_D}" readOnly="${form_USER_NM_RO}" required="${form_USER_NM_R}" style="${imeMode}" maskType="${form_USER_NM_MT}"/>
                </e:field>
            </e:row>
        </e:searchPanel>

        <e:buttonBar width="100%" align="right">
            <e:button id="doSearch" name="doSearch" label="${doSearch_N}" onClick="doSearch" disabled="${doSearch_D}" visible="${doSearch_V}"/>
            <e:button id="doUpdate" name="doUpdate" label="${doUpdate_N}" onClick="doUpdate" disabled="${doUpdate_D}" visible="${doUpdate_V}"/>
        </e:buttonBar>

        <e:gridPanel id="grid" name="grid" gridType="${_gridType}" width="100%" height="fit" readOnly="${param.detailView}"/>

    </e:window>
</e:ui>
