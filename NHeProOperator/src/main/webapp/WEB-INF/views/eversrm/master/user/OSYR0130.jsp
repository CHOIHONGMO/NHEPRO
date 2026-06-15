<%--
  Date: 2020-02-17
  Time: 13:13:43
  Scrren ID : OSYR0130
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
    <script>

		var grid, gridSub;
		var baseUrl = '/eversrm/master/user/';

		function init() {

			grid = EVF.C('grid');
			gridSub = EVF.C('gridSub');

			grid.cellClickEvent(function (rowIdx, celName, value) {
				// cell one click
				switch (celName) {
					case 'USER_ID':
						doSearchSub(value, null);
						break;

					case "DO_NOT_APPROVAL":
						doSearchSub(grid.getCellValue(rowIdx, "USER_ID"), "T");
						break;

					case "DO_APPROVAL":
						doSearchSub(grid.getCellValue(rowIdx, "USER_ID"), "S");
						break;

					case "DO_APPROVAL_RETURN":
						doSearchSub(grid.getCellValue(rowIdx, "USER_ID"), "R");
						break;

					case "DO_APPROVAL_CANCEL":
						doSearchSub(grid.getCellValue(rowIdx, "USER_ID"), "CANCEL");
						break;

					case "DO_SEARCH":
						doSearchSub(grid.getCellValue(rowIdx, "USER_ID"), "C");
						break;

					case "DO_INSERT":
						doSearchSub(grid.getCellValue(rowIdx, "USER_ID"), "I");
						break;

					case "DO_UPDATE":
						doSearchSub(grid.getCellValue(rowIdx, "USER_ID"), "U");
						break;

					case "DO_SAVE":
						doSearchSub(grid.getCellValue(rowIdx, "USER_ID"), "M");
						break;

					case "DO_DELETE":
						doSearchSub(grid.getCellValue(rowIdx, "USER_ID"), "D");
						break;

					case "DO_EXCEL":
						doSearchSub(grid.getCellValue(rowIdx, "USER_ID"), "E");
						break;

					case "DO_PRINT":
						doSearchSub(grid.getCellValue(rowIdx, "USER_ID"), "P");
						break;
				}
			});

			gridSub.cellClickEvent(function (rowIdx, celName, value) {
				var param = {};

				// cell one click
				switch (celName) {
					case 'USER_ID':
						searchUserPop(value);
						break;

                    case 'MASK_APPROVAL_USER_ID':
	                    searchUserPop(value);
                    	break;

					case "MASK_RMK":
						param = {
							POPUPFLAG: "Y"
							, detailView: true
							, MASK_SQ: gridSub.getCellValue(rowIdx, "MASK_SQ")
							, ACCESS_DATE: gridSub.getCellValue(rowIdx, "ACCESS_DATE")
							, USER_ID: gridSub.getCellValue(rowIdx, "USER_ID")
							, PARAM_SCREEN_ID: gridSub.getCellValue(rowIdx, "SCREEN_ID")
							, MASK_RMK: gridSub.getCellValue(rowIdx, "MASK_RMK")
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
				}
			});

            grid.setProperty('shrinkToFit', ${shrinkToFit});		// 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
            grid.setProperty('rowNumbers', ${rowNumbers});		    // 로우의 번호 표시 여부를 지정한다. [true/false]
            grid.setProperty('sortable', ${sortable});			    // 컬럼 정렬기능 사용여부를 지정한다. [true/false]
            grid.setProperty('panelVisible', ${panelVisible});	    // 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            grid.setProperty('enterToNextRow', ${enterToNextRow}); // 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            grid.setProperty('acceptZero', ${acceptZero});		    // 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            grid.setProperty('multiSelect', false);		// [선택] 컬럼의 사용여부를 지정한다. [true/false]

            gridSub = EVF.C("gridSub");
            gridSub.setProperty('shrinkToFit', ${shrinkToFit});		// 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
            gridSub.setProperty('rowNumbers', ${rowNumbers});		    // 로우의 번호 표시 여부를 지정한다. [true/false]
            gridSub.setProperty('sortable', ${sortable});			    // 컬럼 정렬기능 사용여부를 지정한다. [true/false]
            gridSub.setProperty('panelVisible', ${panelVisible});	    // 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            gridSub.setProperty('enterToNextRow', ${enterToNextRow}); // 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            gridSub.setProperty('acceptZero', ${acceptZero});		    // 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            gridSub.setProperty('multiSelect', false);		// [선택] 컬럼의 사용여부를 지정한다. [true/false]

            // 그리드 footer Merge
            grid._gvo.setFooter({
                'mergeCells' : ["USER_NM", "USER_ID"]
            });

            // Grid Excel Event
            grid.excelExportEvent({
                allItems: "${excelExport.allCol}",
                fileName: "${screenName }"
            });

            // Grid Excel Event
            gridSub.excelExportEvent({
                allItems: "${excelExport.allCol}",
                fileName: "${screenName }"
            });
		}

		function searchUserPop(userId) {
			var param = {
				callbackFunction : "",
				USER_TYPE : 'O',  // O:운영사, B:고객사, S:공급사
				USER_ID : userId,
				detailView : true
			};
			everPopup.openPopupByScreenId("BYM1_062", 600, 190, param);
        }

		// Search
		function doSearch() {

			var store = new EVF.Store();
			store.setGrid([grid]);
			store.load(baseUrl + 'OSYR0130/doSearch.so', function () {
				if (grid.getRowCount() == 0) {
					return EVF.alert('${msg.M0002}');
				} else {
					var val = {visible: true, count: 1, height: 35};
					grid.setProperty("footerVisible", val);

					var footerTxt = {
						styles: {
							textAlignment: "center",
							font: "굴림,12",
							background:"#ffffff",
							foreground:"#FF0000",
							fontBold: true
						},
						text: ["${OSYR0130_0001}"] // 합 계
					};

					var footerSum = {
						styles: {
							textAlignment: "center",
							suffix: " ",
							background:"#ffffff",
							foreground:"#FF0000",
							numberFormat: "###,###",
							fontBold: true
						},
						text: "",
						expression: ["sum"],
						groupExpression: "sum"
					};

					var colId = [
					    "DO_NOT_APPROVAL",
						"DO_APPROVAL",
						"DO_APPROVAL_RETURN",
						"DO_APPROVAL_CANCEL",
						"DO_SEARCH",
						"DO_INSERT",
						"DO_UPDATE",
						"DO_SAVE",
						"DO_DELETE",
						"DO_EXCEL",
						"DO_PRINT",
						"SUMMARY"
                    ];

					grid.setRowFooter("USER_NM", footerTxt);
					grid.setRowFooters(
						  colId
                        , footerSum
                    );

					for (var i in colId) {
						if (colId[i] != "SUMMARY") {
							grid.setColFontWeight(colId[i], true);
							grid.setColFontColor(colId[i], "#0000FF");
						}
					}
				}
			});
		}

		// Search
		function doSearchSub(userId, screenCrud) {

			var store = new EVF.Store();
			store.setGrid([gridSub]);
			store.setParameter("USER_ID", userId);
			store.setParameter("SCREEN_CRUD", screenCrud);
			store.load(baseUrl + 'OSYR0130/doSearchSub.so', function () {
				if (gridSub.getRowCount() == 0) {
					return EVF.alert('${msg.M0002}');
				} else {
					gridSub.setColIconify("MASK_RMK", "MASK_RMK", "detail", false);
					gridSub.setColIconify("MASK_APPROVAL_RETURN", "MASK_APPROVAL_RETURN", "detail", false);
				}
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

    <e:window id="OSYR0130" initData="${initData}" onReady="init" title="${fullScreenName }" breadCrumbs="${breadCrumb }">
        <e:searchPanel id="form" title="${msg.M9999}" labelWidth="100" width="100%" columnCount="3" onEnter="doSearch">
            <e:row>
                <%-- 해제요청일 --%>
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
                <%-- 승인여부 --%>
                <e:label for="MASK_APPROVAL" title="${form_MASK_APPROVAL_N}"/>
                <e:field>
                    <e:select id="MASK_APPROVAL" name="MASK_APPROVAL" value="" options="${maskApprovalOptions}" width="${form_MASK_APPROVAL_W}" disabled="${form_MASK_APPROVAL_D}" readOnly="${form_MASK_APPROVAL_RO}" required="${form_MASK_APPROVAL_R}" placeHolder="" maskType="${form_MASK_APPROVAL_MT}" />
                </e:field>
            </e:row>
        </e:searchPanel>

        <e:buttonBar width="100%" align="right">
            <e:button id="doSearch" name="doSearch" label="${doSearch_N}" onClick="doSearch" disabled="${doSearch_D}" visible="${doSearch_V}"/>
        </e:buttonBar>

        <e:gridPanel id="grid" name="grid" gridType="${_gridType}" width="100%" height="300" useTitleBar="true" title="개인별정보요청현황" readOnly="${param.detailView}"/>

        <e:gridPanel id="gridSub" name="grid" gridType="${_gridType}" width="100%" height="fit" useTitleBar="true" title="정보요청현황상세" readOnly="${param.detailView}"/>

    </e:window>
</e:ui>
