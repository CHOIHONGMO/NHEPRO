<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page import = "java.text.SimpleDateFormat"%>
<%@ page import = "java.util.Date"%>
<%@ page import = "java.util.*"%>

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
    <script type="text/javascript">
        var grid;
        var baseUrl = "/nhepro/OVNR/";

        function init() {
            grid = EVF.C("grid");

            grid.setProperty("shrinkToFit", ${shrinkToFit});
            grid.setProperty("rowNumbers", ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
            grid.setProperty("sortable", ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
            grid.setProperty("panelVisible", ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            grid.setProperty("enterToNextRow", ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            grid.setProperty("acceptZero", ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            grid.setProperty("multiSelect", true);					// [선택] 컬럼의 사용여부를 지정한다. [true/false]
            grid.setProperty("singleSelect", ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]

            grid.cellClickEvent(function(rowIdx, colIdx, value) {
                var param;
                if(colIdx == "VENDOR_CD") {
                    param = {
                        VENDOR_CD: value,
                        detailView: true,
                        popupFlag: true,
                        buttonView: true
                    };
                    everPopup.openPopupByScreenId("OVNR0011", 1000, 730, param);
                }
            });

            grid.excelExportEvent({
                allItems: "${excelExport.allCol}",
                fileName: "${screenName }"
            });

            EVF.V("PROGRESS_CD", "J");
        }


        function onIconClickVENDOR_CD() {
            var param = {
                callBackFunction: "callBackVENDOR_CD"
            };
            everPopup.openCommonPopup(param, "SP0123");
        }

        function callBackVENDOR_CD(data) {
            EVF.V("VENDOR_CD", data.VENDOR_CD);
            EVF.V("VENDOR_NM", data.VENDOR_NM);
        }

        function onIconClickBUYER_CD() {
            var param = {
                callBackFunction: "callBackBUYER_CD"
            };
            everPopup.openCommonPopup(param, "SP0066");
        }

        function callBackBUYER_CD(data) {
            EVF.V("BUYER_CD", data.CUST_CD);
            EVF.V("BUYER_NM", data.CUST_NM);
        }

        function doSearch() {
            var store = new EVF.Store();
            if(!store.validate()) { return; }
            store.setGrid([grid]);
            store.load(baseUrl + "ovnr0030_doSearch.so", function() {
                if(grid.getRowCount() == 0){
                    EVF.alert("${msg.M0002 }");
                }
                grid.setColMerge(["VENDOR_CD", "VENDOR_NM", "IRS_NO", "CEO_USER_NM", "INDUSTRY_TYPE", "BUSINESS_TYPE", "TEL_NO"]);
            });
        }
        
        function doReject() {
        	if(grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
        	if(grid.getSelRowCount()  > 1) { return EVF.alert("${msg.M0006}"); }
        	
        	if (!grid.validate().flag) { return EVF.alert(grid.validate().msg); }
        	
        	var rowIds = grid.getSelRowId();
			for(var i in rowIds) {
				if(grid.getCellValue(rowIds[i], 'PROGRESS_CD') !== "J") {
					return EVF.alert("${OVNR0030_0002}");
				}
			}
			
            EVF.confirm("${OVNR0030_0001}", function () {
                var store = new EVF.Store();
                store.setGrid([grid]);
                store.getGridData(grid, "sel");
                store.load(baseUrl + "ovnr0030_doReject.so", function() {
                    EVF.alert(this.getResponseMessage(), function () {
                    	doSearch();
                    });
                });
            });
        }
        
    </script>

    <e:window id="OVNR0030" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">
        <e:searchPanel id="sp" title="${form_CAPTION_N}" labelWidth="${labelWidth}" useTitleBar="false" width="100%" columnCount="3" onEnter="doSearch">
            <e:row>
                <e:label for="VENDOR_NM" title="${form_VENDOR_NM_N}" />
                <e:field>
                    <e:inputText id="VENDOR_NM" name="VENDOR_NM" value="" width="${form_VENDOR_NM_W}" maxLength="${form_VENDOR_NM_M}" disabled="${form_VENDOR_NM_D}" readOnly="${form_VENDOR_NM_RO}" required="${form_VENDOR_NM_R}" style="${imeMode}" maskType="${form_VENDOR_NM_MT}"/>
                </e:field>
                <e:label for="REG_TYPE" title="${form_REG_TYPE_N}"/>
                <e:field>
                    <e:select id="REG_TYPE" name="REG_TYPE" value="" options="${regTypeOptions}" width="${form_REG_TYPE_W}" disabled="${form_REG_TYPE_D}" readOnly="${form_REG_TYPE_RO}" required="${form_REG_TYPE_R}" placeHolder="" maskType="${form_REG_TYPE_MT}" />
                </e:field>
                <e:label for="REG_FROM_DATE" title="${form_REG_FROM_DATE_N}"/>
                <e:field>
                    <e:inputDate id="REG_FROM_DATE" name="REG_FROM_DATE" toDate="REG_TO_DATE" value="${regFromDate}" width="${inputDateWidth}" datePicker="true" required="${form_REG_FROM_DATE_R}" disabled="${form_REG_FROM_DATE_D}" readOnly="${form_REG_FROM_DATE_RO}" />
                    <e:text>&nbsp;~&nbsp;</e:text>
                    <e:inputDate id="REG_TO_DATE" name="REG_TO_DATE" fromDate="REG_FROM_DATE" value="${regToDate}" width="${inputDateWidth}" datePicker="true" required="${form_REG_TO_DATE_R}" disabled="${form_REG_TO_DATE_D}" readOnly="${form_REG_TO_DATE_RO}" />
                </e:field>
            </e:row>
            <e:row>
                <e:label for="CEO_USER_NM" title="${form_CEO_USER_NM_N}" />
                <e:field>
                    <e:inputText id="CEO_USER_NM" name="CEO_USER_NM" value="" width="${form_CEO_USER_NM_W}" maxLength="${form_CEO_USER_NM_M}" disabled="${form_CEO_USER_NM_D}" readOnly="${form_CEO_USER_NM_RO}" required="${form_CEO_USER_NM_R}" style="${imeMode}" maskType="${form_CEO_USER_NM_MT}"/>
                </e:field>
                <e:label for="IRS_NO" title="${form_IRS_NO_N}" />
                <e:field>
                    <e:inputText id="IRS_NO" name="IRS_NO" value="" width="${form_IRS_NO_W}" maxLength="${form_IRS_NO_M}" disabled="${form_IRS_NO_D}" readOnly="${form_IRS_NO_RO}" required="${form_IRS_NO_R}" style="${imeMode}" maskType="${form_IRS_NO_MT}"/>
                </e:field>
                <e:label for="PROGRESS_CD" title="${form_PROGRESS_CD_N}"/>
                <e:field>
                    <e:select id="PROGRESS_CD" name="PROGRESS_CD" value="" options="${progressCdOptions}" width="${form_PROGRESS_CD_W}" disabled="${form_PROGRESS_CD_D}" readOnly="${form_PROGRESS_CD_RO}" required="${form_PROGRESS_CD_R}" placeHolder="" maskType="${form_PROGRESS_CD_MT}" />
                </e:field>
            </e:row>
        </e:searchPanel>

        <e:buttonBar width="100%" align="right">
            <e:button id="doSearch" name="doSearch" label="${doSearch_N}" onClick="doSearch" disabled="${doSearch_D}" visible="${doSearch_V}"/>
            <e:button id="doReject" name="doReject" label="${doReject_N}" onClick="doReject" disabled="${doReject_D}" visible="${doReject_V}"/>
        </e:buttonBar>

        <e:gridPanel id="grid" name="grid" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}" />
    </e:window>
</e:ui>
