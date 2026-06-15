<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
    <script type="text/javascript">
        var grid;
        var baseUrl = "/nhepro/CPOI/";
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

                if(colIdx == "PR_NUM") {
                    param = {
                        prNum: grid.getCellValue(rowIdx, "PR_NUM"),
                        buyerCd : grid.getCellValue(rowIdx, "PB_BUYER_CD"),
                        popupFlag: true,
                        detailView : true
                    };
                    everPopup.openPopupByScreenId("CPRI0010", 1200, 900, param);
                } else if(colIdx == "VENDOR_CD") {
                    param = {
                        VENDOR_CD: value,
                        detailView: true,
                        popupFlag: true,
                        buttonView: false
                    };
                    everPopup.openPopupByScreenId("CVNR0011", 1000, 730, param);
                } else if(colIdx == "ITEM_CD") {
                    param = {
                        ITEM_CD: value,
                        STD_ITEM_CD: value,
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
                    everPopup.openPopupByScreenId("MTUA0011", 600, 190, param);
                }
            });

            if("BR030" != CTRL_CD) {
                EVF.C("doCreate").setDisabled(true);
                EVF.C("doClosing").setDisabled(true);
            } else {
                EVF.C("doCreate").setDisabled(false);
                EVF.C("doClosing").setDisabled(false);
            }
        }

        function onIconClickCTRL_USER_ID() {
        	var param = {
					'callBackFunction': 'callBackCTRL_USER_ID',
					'READONLY': 'Y',		//팝업 조회조건 변경불가
					'multiYN' : 'N',        //멀티팝업여부
					'CTRL_CD' : 'BR030',	// 구매담당자권한
					'detailView': false
			};
			everPopup.openPopupByScreenId("CCDU0020", 1100, 700, param);
        }
        
        function callBackCTRL_USER_ID(data) {
        	if(data!=null){
				data = JSON.parse(data);
	            EVF.V("CTRL_USER_ID", data.USER_ID);
	            EVF.V("CTRL_USER_NM", data.USER_NM);
        	}
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
            store.load(baseUrl + "cpoi0011_doSearch.so", function() {
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

                    if (grid.getCellValue(rowIdx, "PR_BUYER_CD") != grid.getCellValue(rowIdxJ, "PR_BUYER_CD") || /*grid.getCellValue(rowIdx, "DEPT_CD") != grid.getCellValue(rowIdxJ, "DEPT_CD") ||*/
                        grid.getCellValue(rowIdx, "VENDOR_CD") != grid.getCellValue(rowIdxJ, "VENDOR_CD") || grid.getCellValue(rowIdx, "CUR") != grid.getCellValue(rowIdxJ, "CUR") ||
                        grid.getCellValue(rowIdx, "VAT_TYPE") != grid.getCellValue(rowIdxJ, "VAT_TYPE")) {
                        isCheck = false;
                    }
                }
            }

            if(isCheck) {
                var selRowValue = grid.getSelRowValue();
                var gridSel = [];

                for(var k in selRowValue) {
                    var PB_BUYER_CD = selRowValue[k].PB_BUYER_CD;
                    var PR_NUM = selRowValue[k].PR_NUM;
                    var PR_SQ = selRowValue[k].PR_SQ;

                    gridSel.push({
                        PB_BUYER_CD:PB_BUYER_CD,
                        PR_NUM: PR_NUM,
                        PR_SQ: PR_SQ
                    });
                }

                var param = {
                    callbackFunction: "",
                    PR_NUM: grid.getCellValue(selRowId[0], "PR_NUM"),
                    gridSel: JSON.stringify(gridSel),
                    detailView: false,
                    buttonView: true
                };
                everPopup.openPopupByScreenId("CPOI0010", 1200, 750, param);
            } else {
                EVF.alert("${CPOI0011_001}");
            }
        }

        function doClosing() {
            if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

            EVF.confirm("${CPOI0011_002}", function () {
                var store = new EVF.Store();
                store.setGrid([grid]);
                store.getGridData(grid, "sel");
                store.load(baseUrl + "cpoi0011_doClosing.so", function() {
                    EVF.alert(this.getResponseMessage());
                    doSearch();
                });
            });
        }
    </script>

    <e:window id="CPOI0011" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">
        <e:searchPanel id="sp" title="${form_CAPTION_N}" labelWidth="${labelWidth}" useTitleBar="false" width="100%" columnCount="3" onEnter="doSearch">
            <e:row>
                <e:label for="FROM_REG_DATE" title="${form_FROM_REG_DATE_N}"/>
                <e:field>
                    <e:inputDate id="FROM_REG_DATE" name="FROM_REG_DATE" toDate="TO_REG_DATE" value="${FROM_REG_DATE}" width="${inputDateWidth}" datePicker="true" required="${form_FROM_REG_DATE_R}" disabled="${form_FROM_REG_DATE_D}" readOnly="${form_FROM_REG_DATE_RO}" />
                    <e:text> ~ </e:text>
                    <e:inputDate id="TO_REG_DATE" name="TO_REG_DATE" fromDate="FROM_REG_DATE" value="${TO_REG_DATE}" width="${inputDateWidth}" datePicker="true" required="${form_TO_REG_DATE_R}" disabled="${form_TO_REG_DATE_D}" readOnly="${form_TO_REG_DATE_RO}" />
                </e:field>
                <e:label for="PURCHASE_TYPE" title="${form_PURCHASE_TYPE_N}"/>
                <e:field>
                    <e:select id="PURCHASE_TYPE" name="PURCHASE_TYPE" value="" options="${purchaseTypeOptions}" width="${form_PURCHASE_TYPE_W}" disabled="${form_PURCHASE_TYPE_D}" readOnly="${form_PURCHASE_TYPE_RO}" required="${form_PURCHASE_TYPE_R}" placeHolder="선택" maskType="${form_PURCHASE_TYPE_MT}" />
                </e:field>
                <e:label for="ITEM_CD" title="${form_ITEM_CD_N}"/>
                <e:field>
                    <e:inputText id="ITEM_CD" name="ITEM_CD" value="" width="38%" maxLength="${form_ITEM_CD_M}" disabled="${form_ITEM_CD_D}" readOnly="${form_ITEM_CD_RO}" required="${form_ITEM_CD_R}" style="${imeMode}" maskType="${form_ITEM_CD_MT}"/>
                    <e:text>/</e:text>
                    <e:inputText id="ITEM_DESC" name="ITEM_DESC" value="" width="58%" maxLength="${form_ITEM_DESC_M}" disabled="${form_ITEM_DESC_D}" readOnly="${form_ITEM_DESC_RO}" required="${form_ITEM_DESC_R}" style="${imeMode}" maskType="${form_ITEM_DESC_MT}"/>
                </e:field>
            </e:row>

            <e:row>
                <e:label for="CTRL_USER_ID" title="${form_CTRL_USER_ID_N}"/>
                <e:field>
                    <e:search id="CTRL_USER_ID" name="CTRL_USER_ID" value="" width="40%" maxLength="${form_CTRL_USER_ID_M}" onIconClick="${form_CTRL_USER_ID_RO ? 'everCommon.blank' : 'onIconClickCTRL_USER_ID'}" disabled="${form_CTRL_USER_ID_D}" readOnly="${form_CTRL_USER_ID_RO}" required="${form_CTRL_USER_ID_R}" maskType="${form_CTRL_USER_ID_MT}" placeHolder="개인번호" />
                    <e:inputText id="CTRL_USER_NM" name="CTRL_USER_NM" value="" width="60%" maxLength="${form_CTRL_USER_NM_M}" disabled="${form_CTRL_USER_NM_D}" readOnly="${form_CTRL_USER_NM_RO}" required="${form_CTRL_USER_NM_R}" style="${imeMode}" maskType="${form_CTRL_USER_NM_MT}" placeHolder="성명"/>
                </e:field>
                <e:label for="VENDOR_NM" title="${form_VENDOR_NM_N}" />
                <e:field>
                    <e:inputText id="VENDOR_NM" name="VENDOR_NM" value="" width="${form_VENDOR_NM_W}" maxLength="${form_VENDOR_NM_M}" disabled="${form_VENDOR_NM_D}" readOnly="${form_VENDOR_NM_RO}" required="${form_VENDOR_NM_R}" style="${imeMode}" maskType="${form_VENDOR_NM_MT}"/>
                </e:field>
                <e:label for="PR_NUM" title="${form_PR_NUM_N}" />
                <e:field>
                    <e:inputText id="PR_NUM" name="PR_NUM" value="" width="${form_PR_NUM_W}" maxLength="${form_PR_NUM_M}" disabled="${form_PR_NUM_D}" readOnly="${form_PR_NUM_RO}" required="${form_PR_NUM_R}" style="${imeMode}" maskType="${form_PR_NUM_MT}"/>
                </e:field>
            </e:row>

            <e:row>
                <e:label for="BUYER_CD" title="${form_BUYER_CD_N}"/>
                <e:field>
                    <e:search id="BUYER_CD" name="BUYER_CD" value="" width="40%" maxLength="${form_BUYER_CD_M}" onIconClick="${form_BUYER_CD_RO ? 'everCommon.blank' : 'onIconClickBUYER_CD'}" disabled="${form_BUYER_CD_D}" readOnly="${form_BUYER_CD_RO}" required="${form_BUYER_CD_R}" maskType="${form_BUYER_CD_MT}" placeHolder="회사코드" />
                    <e:inputText id="BUYER_NM" name="BUYER_NM" value="" width="60%" maxLength="${form_BUYER_NM_M}" disabled="${form_BUYER_NM_D}" readOnly="${form_BUYER_NM_RO}" required="${form_BUYER_NM_R}" style="${imeMode}" maskType="${form_BUYER_NM_MT}" placeHolder="회사명"/>
                </e:field>
                <e:label for="" title=""/>
				<e:field> </e:field>
				<e:label for="" title=""/>
				<e:field> </e:field>
            </e:row>
        </e:searchPanel>

        <e:buttonBar width="100%" align="right">
            <e:button id="doSearch" name="doSearch" label="${doSearch_N}" onClick="doSearch" disabled="${doSearch_D}" visible="${doSearch_V}"/>
            <e:button id="doCreate" name="doCreate" label="${doCreate_N}" onClick="doCreate" disabled="${doCreate_D}" visible="${doCreate_V}"/>
            <e:button id="doClosing" name="doClosing" label="${doClosing_N}" onClick="doClosing" disabled="${doClosing_D}" visible="${doClosing_V}"/>
        </e:buttonBar>

        <e:gridPanel id="grid" name="grid" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}" />
    </e:window>
</e:ui>
