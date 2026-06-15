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

            grid._gvo.setCheckBar({showAll: false});

            grid.cellClickEvent(function(rowIdx, colIdx, value) {
                var param;
                var DELIVERY_TYPE = grid.getCellValue(rowIdx, "DELIVERY_TYPE");
                var apRejectRmk = grid.getCellValue(rowIdx, "AP_REJECT_RMK");
				
                /** 2021.01.20 제외
                 * 대금지급요청번호 1건씩 선택하도록 함
                if(colIdx == "multiSelect") {
                    if(value == "1") {
                        grid.checkEqualRow(["INV_NUM", "PY_BUYER_CD"], [grid.getCellValue(rowIdx, "INV_NUM"), grid.getCellValue(rowIdx, "PY_BUYER_CD")]);
                    } else {
                        grid.checkNotEqualRow(["INV_NUM", "PY_BUYER_CD"], [grid.getCellValue(rowIdx, "INV_NUM"), grid.getCellValue(rowIdx, "PY_BUYER_CD")]);
                    }
                } else */
                if(colIdx == "AP_NUM") {
                    param = {
                        callbackFunction: "",
                        AP_NUM: value,
                        BUYER_CD: grid.getCellValue(rowIdx, "BUYER_CD"),
                        PY_BUYER_CD: grid.getCellValue(rowIdx, "PY_BUYER_CD"),
                        PY_DEPT_CD: grid.getCellValue(rowIdx, "PY_DEPT_CD"),
                        STATUS:grid.getCellValue(rowIdx, "SIGN_STATUS"),
                        detailView: (grid.getCellValue(rowIdx, "SIGN_STATUS")=="10" || grid.getCellValue(rowIdx, "SIGN_STATUS")=="40") ? false : true,
                        //detailView: true,
                        buttonView: false
                    };
                    everPopup.openPopupByScreenId("SAPI0011", 1200, 750, param);
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
                } else if(colIdx == "SIGN_STATUS") {
                	if( EVF.isEmpty(apRejectRmk) ) return;
                	param = {
       					title : '대금청구 반송사유',
       					message: apRejectRmk,
       					detailView : true
       				};
       				everPopup.commonTextInput(param);
                }
            });

            EVF.C("SEL_DATE").removeOption("DUE");
            EVF.C("SEL_DATE").removeOption("PO");
            EVF.C("SEL_DATE").removeOption("DUEQ");
            EVF.C("SEL_DATE").removeOption("INV");
            EVF.C("SEL_DATE").removeOption("REG");
            EVF.C("SEL_DATE").removeOption("DUEY");
            EVF.V("SEL_DATE", "INVI");
            
            grid.setColGroup([
				{
					"groupName": "대금지급정보",
					"columns": ["PAY_ACCOUNT_NUM", "AP_ACCOUT", "AP_DATE", "AP_AMT"]
				},
			], 50);
            
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
		    grid.setRowFooter("SIGN_STATUS", footer);

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
		    grid.setRowFooter("PAY_AMT", distVal);
		    grid.setRowFooter("PY_AMT", distVal);
		    // ===========================================================
		    
		    // 2021.01.20 자동조회 추가
		    doSearch();
        }

        function doSearch() {
            var store = new EVF.Store();
            if(!store.validate()) { return; }
            store.setGrid([grid]);
            store.setParameter("SEL_DATE", $("#SEL_DATE").val());
            store.load(baseUrl + "sapr0020_doSearch.so", function() {
                if(grid.getRowCount() == 0){
                    EVF.alert("${msg.M0002 }");
                } else {
                    var allRowId = grid.getAllRowId();
                    for(var i in allRowId) {
                        var rowIdx = allRowId[i];
                        var PROGRESS_CD = grid.getCellValue(rowIdx, "SIGN_STATUS");
                        var AP_REJECT_RMK = grid.getCellValue(rowIdx, "AP_REJECT_RMK");
                       
                        if( !EVF.isEmpty(AP_REJECT_RMK) && PROGRESS_CD == "40") {
                        	grid.setCellFontColor(rowIdx, 'SIGN_STATUS', "#0100FF");
                            grid.setCellFontWeight(rowIdx, 'SIGN_STATUS', true);
                        }
                    }
                }
            });
        }
        
        function doUpdatePop() {
            if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
            if (grid.getSelRowCount() > 1) { return alert('${msg.M0006}'); }
            
            var selRowValue = grid.getSelRowValue();
            if( selRowValue[0].SIGN_STATUS != "10" && selRowValue[0].SIGN_STATUS != "40" ) {
                return EVF.alert("${SAPR0020_004}"); // 작성중(10), 반려(40)인 경우 수정 가능
            }

            var param = {
                callbackFunction: "",
                BUYER_CD: selRowValue[0].BUYER_CD,
                AP_NUM: selRowValue[0].AP_NUM,
                INV_NUM: selRowValue[0].INV_NUM,
                PY_BUYER_CD: selRowValue[0].PY_BUYER_CD,
                PY_DEPT_CD: selRowValue[0].PY_DEPT_CD,
                SIGN_STATUS: selRowValue[0].SIGN_STATUS,
                STATUS: selRowValue[0].SIGN_STATUS,
                detailView: false,
                buttonView: true
            };
            everPopup.openPopupByScreenId("SAPI0011", 1200, 870, param);
        }
    </script>

    <e:window id="SAPR0020" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">
        <e:inputHidden id="VENDOR_REJECT_RMK" name="VENDOR_REJECT_RMK"/>
        <e:searchPanel id="sp" title="${form_CAPTION_N}" labelWidth="${longLabelWidth}" useTitleBar="false" width="100%" columnCount="3" onEnter="doSearch">
            <e:row>
                <e:label for="SEL_DATE" title="">
                    <e:select id="SEL_DATE" name="SEL_DATE" value="" options="${selDateOptions}" width="${form_SEL_DATE_W}" disabled="${form_SEL_DATE_D}" readOnly="${form_SEL_DATE_RO}" required="${form_SEL_DATE_R}" placeHolder="" usePlaceHolder="false" maskType="${form_SEL_DATE_MT}" />
                </e:label>
                <e:field>
                    <e:inputDate id="FROM_DATE" name="FROM_DATE" toDate="TO_DATE" value="${FROM_DATE}" width="${inputDateWidth}" datePicker="true" required="${form_FROM_DATE_R}" disabled="${form_FROM_DATE_D}" readOnly="${form_FROM_DATE_RO}" />
                    <e:text> ~ </e:text>
                    <e:inputDate id="TO_DATE" name="TO_DATE" fromDate="FROM_DATE" value="${TO_DATE}" width="${inputDateWidth}" datePicker="true" required="${form_TO_DATE_R}" disabled="${form_TO_DATE_D}" readOnly="${form_TO_DATE_RO}" />
                </e:field>
                <e:label for="AP_NUM" title="${form_AP_NUM_N}" />
                <e:field>
                    <e:inputText id="AP_NUM" name="AP_NUM" value="" width="${form_AP_NUM_W}" maxLength="${form_AP_NUM_M}" disabled="${form_AP_NUM_D}" readOnly="${form_AP_NUM_RO}" required="${form_AP_NUM_R}" style="${imeMode}" maskType="${form_AP_NUM_MT}"/>
                </e:field>
                <e:label for="DELIVERY_TYPE" title="${form_DELIVERY_TYPE_N}"/>
                <e:field>
                    <e:select id="DELIVERY_TYPE" name="DELIVERY_TYPE" value="" options="${deliveryTypeOptions}" width="${form_DELIVERY_TYPE_W}" disabled="${form_DELIVERY_TYPE_D}" readOnly="${form_DELIVERY_TYPE_RO}" required="${form_DELIVERY_TYPE_R}" placeHolder="선택" maskType="${form_DELIVERY_TYPE_MT}" />
                </e:field>
            </e:row>

            <e:row>
                <e:label for="PO_NUM" title="${form_PO_NUM_N}" />
                <e:field>
                    <e:inputText id="PO_NUM" name="PO_NUM" value="" width="${form_PO_NUM_W}" maxLength="${form_PO_NUM_M}" disabled="${form_PO_NUM_D}" readOnly="${form_PO_NUM_RO}" required="${form_PO_NUM_R}" style="${imeMode}" maskType="${form_PO_NUM_MT}"/>
                </e:field>
                <e:label for="INV_NUM" title="${form_INV_NUM_N}" />
                <e:field>
                    <e:inputText id="INV_NUM" name="INV_NUM" value="" width="${form_INV_NUM_W}" maxLength="${form_INV_NUM_M}" disabled="${form_INV_NUM_D}" readOnly="${form_INV_NUM_RO}" required="${form_INV_NUM_R}" style="${imeMode}" maskType="${form_INV_NUM_MT}"/>
                </e:field>
                <e:label for="SIGN_STATUS" title="${form_SIGN_STATUS_N}"/>
                <e:field>
                    <e:select id="SIGN_STATUS" name="SIGN_STATUS" value="" options="${signStatusOptions}" width="${form_SIGN_STATUS_W}" disabled="${form_SIGN_STATUS_D}" readOnly="${form_SIGN_STATUS_RO}" required="${form_SIGN_STATUS_R}" placeHolder="선택" maskType="${form_SIGN_STATUS_MT}" />
                </e:field>
            </e:row>
        </e:searchPanel>

        <e:buttonBar width="100%" align="right">
            <e:button id="doSearch" name="doSearch" label="${doSearch_N}" onClick="doSearch" disabled="${doSearch_D}" visible="${doSearch_V}"/>
            <e:button id="doUpdatePop" name="doUpdatePop" label="${doUpdatePop_N}" onClick="doUpdatePop" disabled="${doUpdatePop_D}" visible="${doUpdatePop_V}"/>
        </e:buttonBar>

        <e:gridPanel id="grid" name="grid" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}" />
    </e:window>
</e:ui>
