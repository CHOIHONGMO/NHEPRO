<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
    <script type="text/javascript">
        var grid;
        var baseUrl = "/nhepro/SPOR/";
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
                }
                else if(colIdx == "ATT_FILE_NUM_CNT") {
                	if( value=="0" ) return;
                    param = {
                        attFileNum: grid.getCellValue(rowIdx, "ATT_FILE_NUM"),
                        rowIdx: rowIdx,
                        callBackFunction: "",
                        bizType: "OM",
                        detailView: true
                    };
                    everPopup.fileAttachPopup(param);
                }
                else if(colIdx == "VENDOR_REJECT_RMK") {
                	if( value=="" ) return;
                    param = {
                        title: "${SPOR0010_006}",
                        message: grid.getCellValue(rowIdx, 'VENDOR_REJECT_RMK'),
                        detailView: true
                    };
                    everPopup.commonTextInput(param);
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
		    grid.setRowFooter("ITEM_CNT", distVal);
		    grid.setRowFooter("PO_AMT", distVal);
		    // ===========================================================
		    
		    // 2021.01.20 자동조회 추가
		    doSearch();
        }

        function doSearch() {
            var store = new EVF.Store();
            if(!store.validate()) { return; }
            store.setGrid([grid]);
            store.load(baseUrl + "spor0010_doSearch.so", function() {
                if(grid.getRowCount() == 0){
                    EVF.alert("${msg.M0002 }");
                } else {
                    grid.setColIconify("VENDOR_REJECT_RMK", "VENDOR_REJECT_RMK", "comment", false);
                }
            });
        }

        function doSaveReceipt() {
            if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

            var chk = true;
            var selRowValue = grid.getSelRowValue();
            for(var i in selRowValue) {
                var data = selRowValue[i];
                if("0" != data.VENDOR_RECEIPT_STATUS) {
                    chk = false;
                }
            }

            if(!chk) {
                return EVF.alert("${SPOR0010_002}");
            }

            EVF.confirm("${SPOR0010_001}", function () {
                var store = new EVF.Store();
                store.setGrid([grid]);
                store.getGridData(grid, "sel");
                store.load(baseUrl + "spor0010_doSaveReceipt.so", function() {
                    EVF.alert(this.getResponseMessage());
                    doSearch();
                });
            });
        }

        function doSaveReject() {
            if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

            var chk = true;
            var typeChk = true;
            var selRowValue = grid.getSelRowValue();
            for(var i in selRowValue) {
                var data = selRowValue[i];
                if("0" != data.VENDOR_RECEIPT_STATUS) {
                    chk = false;
                }

                if("AUTO" == data.PO_CREATE_TYPE || "DRAFT" == data.PO_CREATE_TYPE) {   // AUTO:직발주, DRAFT:계약발주
                    typeChk = false;
                }
            }

            if(!chk) {
                return EVF.alert("${SPOR0010_003}");
            }

            if(!typeChk) {
                return EVF.alert("${SPOR0010_007}");
            }

            var param = {
                title: "${SPOR0010_006}",
                message: EVF.V("VENDOR_REJECT_RMK"),
                callbackFunction: "callbackSaveReject",
                rowIdx: ""
            };

            everPopup.commonTextInput(param);
        }

        function callbackSaveReject(data) {
            if(data.message == "") {
                EVF.alert("${SPOR0010_005}");
            } else {
                EVF.V("VENDOR_REJECT_RMK", data.message);
                EVF.confirm("${SPOR0010_004}", function () {
                    var store = new EVF.Store();
                    store.setGrid([grid]);
                    store.getGridData(grid, "sel");
                    store.load(baseUrl + "spor0010_doSaveReject.so", function() {
                        EVF.alert(this.getResponseMessage());
                        doSearch();
                    });
                });
            }
        }
    </script>

    <e:window id="SPOR0010" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">
        <e:inputHidden id="VENDOR_REJECT_RMK" name="VENDOR_REJECT_RMK"/>
        <e:searchPanel id="sp" title="${form_CAPTION_N}" labelWidth="${labelWidth}" useTitleBar="false" width="100%" columnCount="3" onEnter="doSearch">
            <e:row>
                <e:label for="FROM_PO_DATE" title="${form_FROM_PO_DATE_N}"/>
                <e:field>
                    <e:inputDate id="FROM_PO_DATE" name="FROM_PO_DATE" toDate="TO_PO_DATE" value="${FROM_PO_DATE}" width="${inputDateWidth}" datePicker="true" required="${form_FROM_PO_DATE_R}" disabled="${form_FROM_PO_DATE_D}" readOnly="${form_FROM_PO_DATE_RO}" />
                    <e:text> ~ </e:text>
                    <e:inputDate id="TO_PO_DATE" name="TO_PO_DATE" fromDate="FROM_PO_DATE" value="${TO_PO_DATE}" width="${inputDateWidth}" datePicker="true" required="${form_TO_PO_DATE_R}" disabled="${form_TO_PO_DATE_D}" readOnly="${form_TO_PO_DATE_RO}" />
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
                <e:label for="VENDOR_RECEIPT_STATUS" title="${form_VENDOR_RECEIPT_STATUS_N}"/>
                <e:field>
                    <e:select id="VENDOR_RECEIPT_STATUS" name="VENDOR_RECEIPT_STATUS" value="" options="${vendorReceiptStatusOptions}" width="${form_VENDOR_RECEIPT_STATUS_W}" disabled="${form_VENDOR_RECEIPT_STATUS_D}" readOnly="${form_VENDOR_RECEIPT_STATUS_RO}" required="${form_VENDOR_RECEIPT_STATUS_R}" placeHolder="선택" maskType="${form_VENDOR_RECEIPT_STATUS_MT}" />
                </e:field>
                <e:label for="DELIVERY_TYPE" title="${form_DELIVERY_TYPE_N}"/>
                <e:field>
                    <e:select id="DELIVERY_TYPE" name="DELIVERY_TYPE" value="" options="${deliveryTypeOptions}" width="${form_DELIVERY_TYPE_W}" disabled="${form_DELIVERY_TYPE_D}" readOnly="${form_DELIVERY_TYPE_RO}" required="${form_DELIVERY_TYPE_R}" placeHolder="선택" maskType="${form_DELIVERY_TYPE_MT}" />
                </e:field>
                <e:field colSpan="2"> </e:field>
            </e:row>
        </e:searchPanel>

        <e:buttonBar width="100%" align="right">
            <e:button id="doSearch" name="doSearch" label="${doSearch_N}" onClick="doSearch" disabled="${doSearch_D}" visible="${doSearch_V}"/>
            <e:button id="doSaveReceipt" name="doSaveReceipt" label="${doSaveReceipt_N}" onClick="doSaveReceipt" disabled="${doSaveReceipt_D}" visible="${doSaveReceipt_V}"/>
            <e:button id="doSaveReject" name="doSaveReject" label="${doSaveReject_N}" onClick="doSaveReject" disabled="${doSaveReject_D}" visible="${doSaveReject_V}"/>
        </e:buttonBar>

        <e:gridPanel id="grid" name="grid" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}" />
    </e:window>
</e:ui>
