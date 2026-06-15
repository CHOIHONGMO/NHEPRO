<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
    <script type="text/javascript">
        var grid;
        var baseUrl = "/nhepro/SAPR/";
        var CTRL_CD = "${CTRL_CD}";

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

            grid.setColMerge(["DELIVERY_TYPE", "BUYER_DEPT_NM", "PO_CREATE_DATE","PO_CREATE_TYPE", "PO_NUM", "SUBJECT",
                                "CUR", "PO_AMT", "INV_NUM", "INV_AMT"]);

            grid._gvo.setCheckBar({showAll: false});

            grid.cellClickEvent(function(rowIdx, colIdx, value) {
                var param;
                var DELIVERY_TYPE = grid.getCellValue(rowIdx, "DELIVERY_TYPE");

                if(colIdx == "multiSelect") {
                    if(value == "1") {
                        grid.checkEqualRow(["INV_NUM", "PY_BUYER_CD", "PY_DEPT_CD"], [grid.getCellValue(rowIdx, "INV_NUM"), grid.getCellValue(rowIdx, "PY_BUYER_CD"), grid.getCellValue(rowIdx, "PY_DEPT_CD")]);
                    } else {
                        grid.checkNotEqualRow(["INV_NUM", "PY_BUYER_CD", "PY_DEPT_CD"], [grid.getCellValue(rowIdx, "INV_NUM"), grid.getCellValue(rowIdx, "PY_BUYER_CD"), grid.getCellValue(rowIdx, "PY_DEPT_CD")]);
                    }
                } else if(colIdx == "PO_NUM") {
                    param = {
                        callbackFunction: "",
                        PO_NUM: value,
                        BUYER_CD: grid.getCellValue(rowIdx, "BUYER_CD"),
                        detailView: true,
                        buttonView: false
                    };
                    everPopup.openPopupByScreenId("SPOR0011", 1200, 750, param);
                } else if(colIdx == "INV_NUM") {
                    param = {
                        callbackFunction: "",
                        INV_NUM: value,
                        BUYER_CD: grid.getCellValue(rowIdx, "BUYER_CD"),
                        detailView: true,
                        buttonView: false
                    };

                    if("DI" == DELIVERY_TYPE) {
                        everPopup.openPopupByScreenId("SPOI0031", 1200, 870, param);
                    } else {
                        everPopup.openPopupByScreenId("SPOI0051", 1200, 870, param);
                    }
                } else if(colIdx == "PIC_USER_NM") {
                    param = {
                        callbackFunction: "",
                        USER_TYPE: grid.getCellValue(rowIdx, "PIC_USER_TYPE"),
                        USER_ID: grid.getCellValue(rowIdx, "PIC_USER_ID"),
                        detailView: true
                    };
                    // everPopup.openPopupByScreenId("MTUA0011", 600, 190, param);
                } else if(colIdx == "CTRL_USER_NM") {
                    param = {
                        callbackFunction: "",
                        USER_TYPE: grid.getCellValue(rowIdx, "CTRL_USER_TYPE"),
                        USER_ID: grid.getCellValue(rowIdx, "CTRL_USER_ID"),
                        detailView: true
                    };
                    // everPopup.openPopupByScreenId("MTUA0011", 600, 190, param);
                }
            });
            
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
		    grid.setRowFooter("DELIVERY_TYPE", footer);

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
		    grid.setRowFooter("PO_AMT", distVal);
		    grid.setRowFooter("INV_AMT", distVal);
		    grid.setRowFooter("PAY_AMT", distVal);
		    grid.setRowFooter("PY_AMT", distVal);
		    grid.setRowFooter("SUM_PAY_AMT", distVal);
		    // ===========================================================
		    
		    // 2021.01.20 자동조회 추가
		    doSearch();
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
            store.load(baseUrl + "sapr0010_doSearch.so", function() {
                if(grid.getRowCount() == 0){
                    EVF.alert("${msg.M0002 }");
                } else {
                    grid.setColIconify("VENDOR_REJECT_RMK", "VENDOR_REJECT_RMK", "comment", false);
                }
            });
        }

        function doSendPop() {
            if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
            if (grid.getSelRowCount() > 1) { return EVF.alert("${SAPR0010_003}"); }

            var selRowValue = grid.getSelRowValue();

            var param = {
                callbackFunction: "",
                BUYER_CD: selRowValue[0].BUYER_CD,
                INV_NUM: selRowValue[0].INV_NUM,
                PY_BUYER_CD: selRowValue[0].PY_BUYER_CD,
                PY_DEPT_CD: selRowValue[0].PY_DEPT_CD,
                detailView: false,
                buttonView: true
            };
            everPopup.openPopupByScreenId("SAPI0011", 1200, 870, param);
        }
    </script>

    <e:window id="SAPR0010" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">
        <e:searchPanel id="sp" title="${form_CAPTION_N}" labelWidth="${labelWidth}" useTitleBar="false" width="100%" columnCount="3" onEnter="doSearch">
            <e:row>
                <e:label for="FROM_DATE" title="${form_FROM_DATE_N}"/>
                <e:field>
                    <e:inputDate id="FROM_DATE" name="FROM_DATE" value="${FROM_DATE}" toDate="TO_DATE" width="${inputDateWidth}" datePicker="true" required="${form_FROM_DATE_R}" disabled="${form_FROM_DATE_D}" readOnly="${form_FROM_DATE_RO}" />
                    <e:text>~</e:text>
                    <e:inputDate id="TO_DATE" name="TO_DATE" value="${TO_DATE}" fromDate="FROM_DATE" width="${inputDateWidth}" datePicker="true" required="${form_TO_DATE_R}" disabled="${form_TO_DATE_D}" readOnly="${form_TO_DATE_RO}" />
                </e:field>
                <e:label for="DELIVERY_TYPE" title="${form_DELIVERY_TYPE_N}"/>
                <e:field>
                    <e:select id="DELIVERY_TYPE" name="DELIVERY_TYPE" value="" options="${deliveryTypeOptions}" width="${form_DELIVERY_TYPE_W}" disabled="${form_DELIVERY_TYPE_D}" readOnly="${form_DELIVERY_TYPE_RO}" required="${form_DELIVERY_TYPE_R}" placeHolder="선택" maskType="${form_DELIVERY_TYPE_MT}" />
                </e:field>
                <e:label for="INV_NUM" title="${form_INV_NUM_N}" />
                <e:field>
                    <e:inputText id="INV_NUM" name="INV_NUM" value="" width="${form_INV_NUM_W}" maxLength="${form_INV_NUM_M}" disabled="${form_INV_NUM_D}" readOnly="${form_INV_NUM_RO}" required="${form_INV_NUM_R}" style="${imeMode}" maskType="${form_INV_NUM_MT}"/>
                </e:field>
            </e:row>

            <e:row>
                <e:label for="PO_NUM" title="${form_PO_NUM_N}" />
                <e:field>
                    <e:inputText id="PO_NUM" name="PO_NUM" value="" width="${form_PO_NUM_W}" maxLength="${form_PO_NUM_M}" disabled="${form_PO_NUM_D}" readOnly="${form_PO_NUM_RO}" required="${form_PO_NUM_R}" style="${imeMode}" maskType="${form_PO_NUM_MT}"/>
                </e:field>
                <e:label for="BUYER_CD" title="${form_BUYER_CD_N}"/>
                <e:field>
                    <e:search id="BUYER_CD" name="BUYER_CD" value="" width="40%" maxLength="${form_BUYER_CD_M}" onIconClick="${form_BUYER_CD_RO ? 'everCommon.blank' : 'onIconClickBUYER_CD'}" disabled="${form_BUYER_CD_D}" readOnly="${form_BUYER_CD_RO}" required="${form_BUYER_CD_R}" maskType="${form_BUYER_CD_MT}" />
                    <e:inputText id="BUYER_NM" name="BUYER_NM" value="" width="60%" maxLength="${form_BUYER_NM_M}" disabled="${form_BUYER_NM_D}" readOnly="${form_BUYER_NM_RO}" required="${form_BUYER_NM_R}" style="${imeMode}" maskType="${form_BUYER_NM_MT}"/>
                </e:field>
                <e:label for="PAY_TERMS" title="${form_PAY_TERMS_N}"/>
                <e:field>
                    <e:select id="PAY_TERMS" name="PAY_TERMS" value="" options="${payTermsOptions}" width="${form_PAY_TERMS_W}" disabled="${form_PAY_TERMS_D}" readOnly="${form_PAY_TERMS_RO}" required="${form_PAY_TERMS_R}" placeHolder="선택" maskType="${form_PAY_TERMS_MT}" />
                </e:field>
            </e:row>
        </e:searchPanel>

        <e:buttonBar width="100%" align="right">
            <e:button id="doSearch" name="doSearch" label="${doSearch_N}" onClick="doSearch" disabled="${doSearch_D}" visible="${doSearch_V}"/>
            <e:button id="doSendPop" name="doSendPop" label="${doSendPop_N}" onClick="doSendPop" disabled="${doSendPop_D}" visible="${doSendPop_V}"/>
        </e:buttonBar>

        <e:gridPanel id="grid" name="grid" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}" />
    </e:window>
</e:ui>
