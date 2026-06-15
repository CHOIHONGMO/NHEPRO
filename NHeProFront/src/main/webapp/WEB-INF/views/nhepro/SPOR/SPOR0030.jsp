<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
    <script type="text/javascript">
        var grid;
        var baseUrl = "/nhepro/SPOR/";

        function init() {
            grid = EVF.C("grid");

            grid.setProperty("shrinkToFit", ${shrinkToFit});
            grid.setProperty("rowNumbers", ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
            grid.setProperty("sortable", ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
            grid.setProperty("panelVisible", ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            grid.setProperty("enterToNextRow", ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            grid.setProperty("acceptZero", ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            grid.setProperty("multiSelect", ${param.detailView == true ? false : multiSelect});					// [선택] 컬럼의 사용여부를 지정한다. [true/false]
            grid.setProperty("singleSelect", ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]

            grid.cellClickEvent(function(rowIdx, colIdx, value) {
                var param;

                if(colIdx == "PO_NUM") {
                    param = {
                        callbackFunction: "",
                        PO_NUM: value,
                        BUYER_CD: grid.getCellValue(rowIdx, "BUYER_CD"),
                        detailView: true,
                        buttonView: false
                    };
                    everPopup.openPopupByScreenId("SPOR0011", 1200, 750, param);
                } else if(colIdx == "ITEM_CD") {
                    param = {
                        ITEM_CD: value,
                        STD_ITEM_CD: value,
                        BUYER_CD: grid.getCellValue(rowIdx, "BUYER_CD"),
                        popupFlag: true,
                        detailView: true,
                        manageFlag: "0"
                    };
                    everPopup.openPopupByScreenId("CITR0041", 1150, 663, param);
                } else if(colIdx == "CTRL_USER_NM") {
                    param = {
                        callbackFunction: "",
                        USER_TYPE: grid.getCellValue(rowIdx, "CTRL_USER_TYPE"),
                        USER_ID: grid.getCellValue(rowIdx, "CTRL_USER_ID"),
                        detailView: true
                    };
                    // everPopup.openPopupByScreenId("MTUA0011", 600, 190, param);
                } else if(colIdx == "GR_USER_NM") {
                    param = {
                        callbackFunction: "",
                        USER_TYPE: grid.getCellValue(rowIdx, "GR_USER_TYPE"),
                        USER_ID: grid.getCellValue(rowIdx, "GR_USER_ID"),
                        detailView: true
                    };
                    // everPopup.openPopupByScreenId("MTUA0011", 600, 190, param);
                }
            });

            EVF.C("SEL_DATE").removeOption("DUEQ");
            EVF.C("SEL_DATE").removeOption("INV");
            EVF.C("SEL_DATE").removeOption("REG");
            EVF.C("SEL_DATE").removeOption("DUEY");
            EVF.C("SEL_DATE").removeOption("REQI");
            EVF.C("SEL_DATE").removeOption("INVI");
            EVF.C("SEL_DATE").removeOption("AP");
            EVF.V("SEL_DATE", "PO");
            
         	// ======================그리드 합계 구하기=======================
		    var val = {"visible": true, "count": 1, "height": 15};
		    grid.setProperty('footerVisible', val);

		    var footer = {
		          "styles": {
		              "textAlignment": "center",
		              "fontBold": true,
		              "fontFmaily": "Nanum Gothic",
		          },
		          "text": "합   계"
		    };
		    grid.setRowFooter("BUYER_DEPT_NM", footer);

		    var distVal = {
		          "styles": {
		              "textAlignment": "far",
		              "numberFormat" : "#,###.###",
		              "fontFmaily": "Nanum Gothic",
		              "paddingRight": 5,
		              "fontBold": true
		          },
		          "expression": ["sum"],
		          "groupExpression": "sum"
		    };
		    grid.setRowFooter("PO_QT", distVal);
		    grid.setRowFooter("ITEM_AMT", distVal);
		    grid.setRowFooter("VAT_AMT", distVal);
		    grid.setRowFooter("INV_QT", distVal);
		    grid.setRowFooter("GR_QT", distVal);
		    grid.setRowFooter("UN_PO_QT", distVal);
		    // ===========================================================
		    
		    // 2021.01.20 자동조회 추가
		    doSearch();
        }

        function doSearch() {
            var store = new EVF.Store();
            if(!store.validate()) { return; }
            store.setGrid([grid]);
            store.setParameter("SEL_DATE", $("#SEL_DATE").val());
            store.load(baseUrl + "spor0030_doSearch.so", function() {
                if(grid.getRowCount() == 0){
                    EVF.alert("${msg.M0002 }");
                }
            });
        }

        function doCreate() {
            if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

            var isCheck = true;
            var selRowId = grid.getSelRowId();
            for(var i in selRowId) {
                var rowIdx = selRowId[i];

                for(var j in selRowId) {
                    var rowIdxJ = selRowId[j];

                    if (grid.getCellValue(rowIdx, "PO_NUM") != grid.getCellValue(rowIdxJ, "PO_NUM") ||
                        grid.getCellValue(rowIdx, "BUYER_CD") != grid.getCellValue(rowIdxJ, "BUYER_CD") || grid.getCellValue(rowIdx, "DEPT_CD") != grid.getCellValue(rowIdxJ, "DEPT_CD") ||
                        grid.getCellValue(rowIdx, "PURCHASE_TYPE") != grid.getCellValue(rowIdxJ, "PURCHASE_TYPE") || grid.getCellValue(rowIdx, "CUR") != grid.getCellValue(rowIdxJ, "CUR") ||
                        grid.getCellValue(rowIdx, "VAT_TYPE") != grid.getCellValue(rowIdxJ, "VAT_TYPE") || grid.getCellValue(rowIdx, "CTRL_USER_ID") != grid.getCellValue(rowIdxJ, "CTRL_USER_ID")) {
                        isCheck = false;
                    }
                }
            }
            
            if(isCheck) {
                var selRowValue = grid.getSelRowValue();
                var gridSel = [];

                for(var k in selRowValue) {
                    var BUYER_CD = selRowValue[k].BUYER_CD;
                    var DEPT_CD = selRowValue[k].DEPT_CD;
                    var PO_NUM = selRowValue[k].PO_NUM;
                    var PO_SQ = selRowValue[k].PO_SQ;

                    gridSel.push({
                        BUYER_CD: BUYER_CD,
                        DEPT_CD: DEPT_CD,
                        PO_NUM: PO_NUM,
                        PO_SQ: PO_SQ
                    });
                }

                var param = {
                    callbackFunction: "",
                    gridSel: JSON.stringify(gridSel),
                    detailView: false,
                    buttonView: true
                };
                everPopup.openPopupByScreenId("SPOI0031", 1200, 870, param);
            } else {
                EVF.alert("${SPOR0030_003}");
            }
        }
    </script>

    <e:window id="SPOR0030" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">
        <e:inputHidden id="VENDOR_REJECT_RMK" name="VENDOR_REJECT_RMK"/>
        <e:searchPanel id="sp" title="${form_CAPTION_N}" labelWidth="${labelWidth}" useTitleBar="false" width="100%" columnCount="3" onEnter="doSearch">
            <e:row>
                <e:label for="SEL_DATE" title="">
                    <e:select id="SEL_DATE" name="SEL_DATE" value="" options="${selDateOptions}" width="${form_SEL_DATE_W}" disabled="${form_SEL_DATE_D}" readOnly="${form_SEL_DATE_RO}" required="${form_SEL_DATE_R}" placeHolder="" usePlaceHolder="false" maskType="${form_SEL_DATE_MT}" />
                </e:label>
                <e:field>
                    <e:inputDate id="FROM_DATE" name="FROM_DATE" toDate="TO_DATE" value="${FROM_DATE}" width="${inputDateWidth}" datePicker="true" required="${form_FROM_DATE_R}" disabled="${form_FROM_DATE_D}" readOnly="${form_FROM_DATE_RO}" />
                    <e:text> ~ </e:text>
                    <e:inputDate id="TO_DATE" name="TO_DATE" fromDate="FROM_DATE" value="${TO_DATE}" width="${inputDateWidth}" datePicker="true" required="${form_TO_DATE_R}" disabled="${form_TO_DATE_D}" readOnly="${form_TO_DATE_RO}" />
                </e:field>
                <e:label for="PO_NUM" title="${form_PO_NUM_N}" />
                <e:field>
                    <e:inputText id="PO_NUM" name="PO_NUM" value="" width="${form_PO_NUM_W}" maxLength="${form_PO_NUM_M}" disabled="${form_PO_NUM_D}" readOnly="${form_PO_NUM_RO}" required="${form_PO_NUM_R}" style="${imeMode}" maskType="${form_PO_NUM_MT}"/>
                </e:field>
                <e:label for="SUBJECT" title="${form_SUBJECT_N}" />
                <e:field>
                    <e:inputText id="SUBJECT" name="SUBJECT" value="" width="${form_SUBJECT_W}" maxLength="${form_SUBJECT_M}" disabled="${form_SUBJECT_D}" readOnly="${form_SUBJECT_RO}" required="${form_SUBJECT_R}" style="${imeMode}" maskType="${form_SUBJECT_MT}"/>
                </e:field>
            </e:row>

            <e:row>
                <e:label for="ITEM_CD" title="${form_ITEM_CD_N}" />
                <e:field>
                    <e:inputText id="ITEM_CD" name="ITEM_CD" value="" width="${form_ITEM_CD_W}" maxLength="${form_ITEM_CD_M}" disabled="${form_ITEM_CD_D}" readOnly="${form_ITEM_CD_RO}" required="${form_ITEM_CD_R}" style="${imeMode}" maskType="${form_ITEM_CD_MT}"/>
                </e:field>
                <e:label for="ITEM_DESC" title="${form_ITEM_DESC_N}" />
                <e:field>
                    <e:inputText id="ITEM_DESC" name="ITEM_DESC" value="" width="${form_ITEM_DESC_W}" maxLength="${form_ITEM_DESC_M}" disabled="${form_ITEM_DESC_D}" readOnly="${form_ITEM_DESC_RO}" required="${form_ITEM_DESC_R}" style="${imeMode}" maskType="${form_ITEM_DESC_MT}"/>
                </e:field>
                <e:label for="PURCHASE_TYPE" title="${form_PURCHASE_TYPE_N}"/>
                <e:field>
                    <e:select id="PURCHASE_TYPE" name="PURCHASE_TYPE" value="" options="${purchaseTypeOptions}" width="${form_PURCHASE_TYPE_W}" disabled="${form_PURCHASE_TYPE_D}" readOnly="${form_PURCHASE_TYPE_RO}" required="${form_PURCHASE_TYPE_R}" placeHolder="선택" maskType="${form_PURCHASE_TYPE_MT}" />
                </e:field>
            </e:row>
        </e:searchPanel>

        <e:buttonBar width="100%" align="right">
            <e:button id="doSearch" name="doSearch" label="${doSearch_N}" onClick="doSearch" disabled="${doSearch_D}" visible="${doSearch_V}"/>
            <e:button id="doCreate" name="doCreate" label="${doCreate_N}" onClick="doCreate" disabled="${doCreate_D}" visible="${doCreate_V}"/>
        </e:buttonBar>

        <e:gridPanel id="grid" name="grid" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}" />
    </e:window>
</e:ui>
