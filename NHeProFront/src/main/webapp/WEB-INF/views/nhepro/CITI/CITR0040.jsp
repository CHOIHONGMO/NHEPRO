<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
    <script>
        var grid;
        var baseUrl = "/nhepro/CITI/CITR0040/";

        function init() {
            grid = EVF.C("grid");

            grid.setProperty("shrinkToFit", false);		// 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
            grid.setProperty("rowNumbers", ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
            grid.setProperty("sortable", ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
            grid.setProperty("panelVisible", ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            grid.setProperty("enterToNextRow", ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            grid.setProperty("acceptZero", ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            grid.setProperty("multiSelect", ${multiSelect});		// [선택] 컬럼의 사용여부를 지정한다. [true/false]
            grid.setProperty("singleSelect", ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]

            grid.cellClickEvent(function(rowIdx, colIdx, value) {
                var param;
	            var popupUrl;

	            switch (colIdx) {
                    case "ITEM_CD":
                    	if(value != "") {
		                    param = {
			                    ITEM_CD: grid.getCellValue(rowIdx, "ITEM_CD"),
			                    STD_ITEM_CD: grid.getCellValue(rowIdx, "STD_ITEM_CD"),
			                    popupFlag: true,
			                    detailView: true
		                    };
		                    everPopup.openPopupByScreenId("CITR0041", 1150, 663, param);
						}

                        break;

                    case "ITEM_CLS_NM":
	                    popupUrl = "/nhepro/CITI/CITR0043/view.so";
	                    param = {
		                    callBackFunction: "_setItemClassNmGrid",
		                    ModalPopup: true,
		                    multiYN: false,
		                    searchYN: true,
							rowIdx: rowIdx
	                    };
	                    everPopup.openModalPopup(popupUrl, 500, 650, param, "itemClassNmPopup");

                        break;

					case "MAKER_NM":

						searchMakerCdGrid();

						break;

		            case "BRAND_NM":

		            	searchBrandCdGrid();

			            break;
                }
            });

            grid.excelExportEvent({
                allItems: "${excelExport.allCol}",
                fileName: "${screenName }"
            });

        }

        function doSearch(){
            var flag = true;
            $("input").each(function (k, v) {
                if (!(v.type == "hidden" || v.type == "radio" || v.id == "grid_line" || v.id == "grid-search")) {
                    if (v.value != "") {
                        flag = false;
                    }
                }
            });

            if(flag) {
                return EVF.alert("${CITR0040_0001}"); // 검색조건을 한개 이상 입력하여 주시기 바랍니다.
            }

            var store = new EVF.Store();
            store.setGrid([grid]);
            store.load(baseUrl + "citr0040_doSearch.so", function () {
                if(grid.getRowCount() == 0) {
                    return EVF.alert("${msg.M0002}");
                }
            });
        }

        function doSave() {

            if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

            if (!grid.validate().flag) { return EVF.alert(grid.validate().msg); }

            EVF.confirm("${msg.M0021 }", function () {
                var store = new EVF.Store();
                store.setGrid([grid]);
                store.getGridData(grid, "sel");
                store.load(baseUrl + "citr0040_doSave.so", function () {
                    EVF.alert("${msg.M0031 }", function() {
                        doSearch();
                    });
                });
            });
        }

        function _getItemClsNm()  {

            var popupUrl = "/nhepro/CITI/CITR0043/view.so";
            var param = {
                callBackFunction: "_setItemClassNm",
                detailView: false,
                multiYN: false,
                ModalPopup: true,
                searchYN: true
            };
            everPopup.openModalPopup(popupUrl, 500, 650, param, "itemClassNmPopup");
        }

        function _setItemClassNm(data) {
            if(data!=null){
                data = JSON.parse(data);
                EVF.V("ITEM_CLS1", data.ITEM_CLS1);
                if(data.ITEM_CLS2 == "*") { EVF.V("ITEM_CLS2", ""); } else { EVF.V("ITEM_CLS2", data.ITEM_CLS2); }
                if(data.ITEM_CLS3 == "*") { EVF.V("ITEM_CLS3", ""); } else { EVF.V("ITEM_CLS3", data.ITEM_CLS3); }
                if(data.ITEM_CLS4 == "*") { EVF.V("ITEM_CLS4", ""); } else { EVF.V("ITEM_CLS4", data.ITEM_CLS4); }
                EVF.V("ITEM_CLS_NM", data.ITEM_CLS_PATH_NM);
            } else {
                EVF.V("ITEM_CLS1", "");
                EVF.V("ITEM_CLS2", "");
                EVF.V("ITEM_CLS3", "");
                EVF.V("ITEM_CLS4", "");
                EVF.V("ITEM_CLS_NM", "");
            }
        }

        function _setItemClassNmGrid(data) {
		    data = JSON.parse(data);

		    grid.setCellValue(data.rowIdx, "ITEM_CLS1", data.ITEM_CLS1);
		    grid.setCellValue(data.rowIdx, "ITEM_CLS2", data.ITEM_CLS2);
		    grid.setCellValue(data.rowIdx, "ITEM_CLS3", data.ITEM_CLS3);
		    grid.setCellValue(data.rowIdx, "ITEM_CLS4", data.ITEM_CLS4);
	        grid.setCellValue(data.rowIdx, "ITEM_CLS_NM", data.ITEM_CLS_PATH_NM);
        }

        function searchMakerCd(){
            var param = {
                callBackFunction: "selectMakerCd"
            };
            everPopup.openCommonPopup(param, "SP0068");
        }

        function searchMakerCdGrid(){
	        var param = {
		        callBackFunction: "selectMakerCdGrid"
	        };
	        everPopup.openCommonPopup(param, "SP0068");
        }

        function selectMakerCd(data) {
            EVF.V("MAKER_CD", data.MKBR_CD);
            EVF.V("MAKER_NM", data.MKBR_NM);
        }

        function selectMakerCdGrid(data) {
        	grid.setCellValue(data.rowIdx, "MAKER_CD", data.MKBR_CD);
        	grid.setCellValue(data.rowIdx, "MAKER_NM", data.MKBR_NM);
        }

        function searchBrandCd(){
            var param = {
                callBackFunction: "selectBrandCd"
            };
            everPopup.openCommonPopup(param, "SP0088");
        }

        function searchBrandCdGrid(){
	        var param = {
		        callBackFunction: "selectBrandCdGrid"
	        };
	        everPopup.openCommonPopup(param, "SP0088");
        }

        function selectBrandCd(data) {
            EVF.V("BRAND_CD", data.MKBR_CD);
            EVF.V("BRAND_NM", data.MKBR_NM);
        }

        function selectBrandCdGrid(data) {
	        grid.setCellValue(data.rowIdx, "BRAND_CD", data.MKBR_CD);
	        grid.setCellValue(data.rowIdx, "BRAND_NM", data.MKBR_NM);
        }

        function getPurchase() {
			EVF.alert("업무 협의 후 구현예정");
		}

		function doCustItemSearch() {
        	var param = {
        		PROJECT_SQ: null,
				detailView: false,
				callbackFunction: "setSearchItem"
			};
			everPopup.openPopupByScreenId("CITR0042", 1150, 810, param);
		}

		function setSearchItem(data) {

			data = valid.equalPopupValid(JSON.stringify(data), grid, "STD_ITEM_CD");

        	for(var i in data) {
        		console.log(data);
        		delete data[i].ITEM_CD;
		        delete data[i].BRAND_CD;
		        delete data[i].MAKER_CD;
		        delete data[i].MOD_DATE;
		        delete data[i].MOD_USER_NM;

		        grid.addRow(data[i]);
			}
		}

		function doStdItemSearch() {
			var param = {
				detailView: false,
				callbackFunction: "setSearchItem"
			};
			everPopup.openPopupByScreenId("CITR0045", 1150, 810, param);
		}

		function doItemReg() {
        	var param;
        	var selRowId = grid.getSelRowId();

        	if(selRowId.length > 1) { return EVF.alert("${CITR0040_0002}"); }

		    var selRowValue = grid.getRowValue(selRowId[0]);
			param = {
				BUYER_CD: selRowValue.BUYER_CD,
				ITEM_CD: selRowValue.ITEM_CD,
				STD_ITEM_CD: selRowValue.STD_ITEM_CD,
				manageFlag: 0,
				detailView: false,
				popupFlag: true
			};

			everPopup.openPopupByScreenId("CITA0044", 1150, 665, param);
		}

		function doStdItemApp() {
			var param = {
				VC_NO: "",
				vocType: "ST",
				detailView: false
			};

			everPopup.openPopupByScreenId("CETR0041", 1150, 665, param);
		}
    </script>

    <e:window id="CITR0040" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">

        <e:searchPanel id="form" title="${form_CAPTION_N}" labelWidth="${labelWidth}" labelAlign="${labelAlign}" columnCount="3" useTitleBar="false" onEnter="doSearch" >
            <e:row>
                <%-- 품목분류 --%>
                <e:label for="ITEM_CLS_NM" title="${form_ITEM_CLS_NM_N}"/>
                <e:field colSpan="5">
                    <e:search id="ITEM_CLS_NM" name="ITEM_CLS_NM" value="" width="${form_ITEM_CLS_NM_W}" maxLength="${form_ITEM_CLS_NM_M}" onIconClick="_getItemClsNm" disabled="${form_ITEM_CLS_NM_D}" readOnly="${form_ITEM_CLS_NM_RO}" required="${form_ITEM_CLS_NM_R}"  maskType="${form_ITEM_CLS_NM_MT}" />
                    <e:inputHidden id="ITEM_CLS1" name="ITEM_CLS1" />
                    <e:inputHidden id="ITEM_CLS2" name="ITEM_CLS2" />
                    <e:inputHidden id="ITEM_CLS3" name="ITEM_CLS3" />
                    <e:inputHidden id="ITEM_CLS4" name="ITEM_CLS4" />
                </e:field>
            </e:row>
            <e:row>
				<%-- 품명 --%>
				<e:label for="ITEM_DESC" title="${form_ITEM_DESC_N}" />
				<e:field>
					<e:inputText id="ITEM_DESC" name="ITEM_DESC" value="" width="${form_ITEM_DESC_W}" maxLength="${form_ITEM_DESC_M}" disabled="${form_ITEM_DESC_D}" readOnly="${form_ITEM_DESC_RO}" required="${form_ITEM_DESC_R}"  maskType="${form_ITEM_DESC_MT}" />
				</e:field>
				<%-- 규격 --%>
				<e:label for="ITEM_SPEC" title="${form_ITEM_SPEC_N}" />
				<e:field>
					<e:inputText id="ITEM_SPEC" name="ITEM_SPEC" value="" width="${form_ITEM_SPEC_W}" maxLength="${form_ITEM_SPEC_M}" disabled="${form_ITEM_SPEC_D}" readOnly="${form_ITEM_SPEC_RO}" required="${form_ITEM_SPEC_R}" style="${imeMode}" maskType="${form_ITEM_SPEC_MT}"/>
				</e:field>
                <%-- 품목코드 --%>
                <e:label for="ITEM_CD" title="${form_ITEM_CD_N}" />
                <e:field>
                    <e:inputText id="ITEM_CD" name="ITEM_CD" value="" width="${form_ITEM_CD_W}" maxLength="${form_ITEM_CD_M}" disabled="${form_ITEM_CD_D}" readOnly="${form_ITEM_CD_RO}" required="${form_ITEM_CD_R}"  maskType="${form_ITEM_CD_MT}" />
                </e:field>
            </e:row>
            <e:row>
				<%-- 제조사 --%>
				<e:label for="MAKER_CD" title="${form_MAKER_CD_N}"/>
				<e:field>
					<e:search id="MAKER_CD" name="MAKER_CD"  value="" width="40%" maxLength="${form_MAKER_CD_M}" onIconClick="${form_MAKER_CD_D ? 'everCommon.blank' : 'searchMakerCd'}" disabled="${form_MAKER_CD_D}" readOnly="${form_MAKER_CD_RO}" required="${form_MAKER_CD_R}"  maskType="${form_MAKER_CD_MT}" placeHolder="제조사코드" />
					<e:inputText id="MAKER_NM" name="MAKER_NM" value="" width="60%" maxLength="${form_MAKER_NM_M}" disabled="${form_MAKER_NM_D}" readOnly="${form_MAKER_NM_RO}" required="${form_MAKER_NM_R}" maskType="${form_MAKER_NM_MT}" placeHolder="제조사명" />
				</e:field>
				<%-- 모델번호 --%>
				<e:label for="MAKER_PART_NO" title="${form_MAKER_PART_NO_N}" />
				<e:field>
					<e:inputText id="MAKER_PART_NO" name="MAKER_PART_NO" value="" width="${form_MAKER_PART_NO_W}" maxLength="${form_MAKER_PART_NO_M}" disabled="${form_MAKER_PART_NO_D}" readOnly="${form_MAKER_PART_NO_RO}" required="${form_MAKER_PART_NO_R}"  maskType="${form_MAKER_PART_NO_MT}" />
				</e:field>
				<%-- 브랜드 --%>
				<e:label for="BRAND_CD" title="${form_BRAND_CD_N}"/>
				<e:field>
					<e:search id="BRAND_CD" name="BRAND_CD"  value="" width="40%" maxLength="${form_BRAND_CD_M}" onIconClick="${form_BRAND_CD_D ? 'everCommon.blank' : 'searchBrandCd'}" disabled="${form_BRAND_CD_D}" readOnly="${form_BRAND_CD_RO}" required="${form_BRAND_CD_R}"  maskType="${form_BRAND_CD_MT}" placeHolder="브랜드코드" />
					<e:inputText id="BRAND_NM" name="BRAND_NM" value="" width="60%" maxLength="${form_BRAND_NM_M}" disabled="${form_BRAND_NM_D}" readOnly="${form_BRAND_NM_RO}" required="${form_BRAND_NM_R}" maskType="${form_BRAND_NM_MT}" placeHolder="브랜드명" />
				</e:field>
            </e:row>

				<%-- 프로젝트
				<e:label for="PROJECT_CD" title="${form_PROJECT_CD_N}" />
				<e:field>
					<e:inputText id="PROJECT_CD" name="PROJECT_CD" value="" width="${form_PROJECT_CD_W}" maxLength="${form_PROJECT_CD_M}" disabled="${form_PROJECT_CD_D}" readOnly="${form_PROJECT_CD_RO}" required="${form_PROJECT_CD_R}" style="${imeMode}" maskType="${form_PROJECT_CD_MT}"/>
				</e:field>
				<%-- 계약번호
				<e:label for="CM_REQ_ID" title="${form_CM_REQ_ID_N}" />
				<e:field>
					<e:inputText id="CM_REQ_ID" name="CM_REQ_ID" value="" width="${form_CM_REQ_ID_W}" maxLength="${form_CM_REQ_ID_M}" disabled="${form_CM_REQ_ID_D}" readOnly="${form_CM_REQ_ID_RO}" required="${form_CM_REQ_ID_R}" style="${imeMode}" maskType="${form_CM_REQ_ID_MT}"/>
				</e:field>
				<%-- 매입처
				<e:label for="PURCHASE_CD" title="${form_PURCHASE_CD_N}" />
				<e:field>
					<e:search id="PURCHASE_CD" name="PURCHASE_CD" value="" width="40%" maxLength="${form_PURCHASE_CD_M}" onIconClick="${form_PURCHASE_CD_RO ? 'everCommon.blank' : 'getPurchase'}" disabled="${form_PURCHASE_CD_D}" readOnly="${form_PURCHASE_CD_RO}" required="${form_PURCHASE_CD_R}" maskType="${form_PURCHASE_CD_MT}" />
					<e:inputText id="PURCHASE_NM" name="PURCHASE_NM" value="" width="60%" maxLength="${form_PURCHASE_NM_M}" disabled="${form_PURCHASE_NM_D}" readOnly="${form_PURCHASE_NM_RO}" required="${form_PURCHASE_NM_R}" style="${imeMode}" maskType="${form_PURCHASE_NM_MT}"/>
				</e:field>
				--%>

        </e:searchPanel>

        <e:buttonBar align="right" width="100%">
			<%--<e:button id="doCustItemSearch" name="doCustItemSearch" label="${doCustItemSearch_N}" onClick="doCustItemSearch" disabled="${doCustItemSearch_D}" visible="${doCustItemSearch_V}" align="left"/>--%>
			<e:button id="doSearch" name="doSearch" label="${doSearch_N}" onClick="doSearch" disabled="${doSearch_D}" visible="${doSearch_V}"/>
			<e:button id="doSave" name="doSave" label="${doSave_N}" onClick="doSave" disabled="${doSave_D}" visible="${doSave_V}"/>
			<e:button id="doItemReg" name="doItemReg" label="${doItemReg_N}" onClick="doItemReg" disabled="${doItemReg_D}" visible="${doItemReg_V}"/>
			<e:button id="doStdItemSearch" name="doStdItemSearch" label="${doStdItemSearch_N}" onClick="doStdItemSearch" disabled="${doStdItemSearch_D}" visible="${doStdItemSearch_V}"/>
			<e:button id="doStdItemApp" name="doStdItemApp" label="${doStdItemApp_N}" onClick="doStdItemApp" disabled="${doStdItemApp_D}" visible="${doStdItemApp_V}"/>
        </e:buttonBar>

        <e:gridPanel id="grid" name="grid" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}"/>

    </e:window>
</e:ui>