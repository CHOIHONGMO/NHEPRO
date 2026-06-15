<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
    <script>
        var grid;
        var baseUrl = "/nhepro/OITR/OITR0020/";

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

                switch (colIdx) {
                    case "ITEM_CD":
                        param = {
                            BUYER_CD: grid.getCellValue(rowIdx, "BUYER_CD"),
                            ITEM_CD: grid.getCellValue(rowIdx, "ITEM_CD"),
                            STD_ITEM_CD: grid.getCellValue(rowIdx, "STD_ITEM_CD"),
                            popupFlag: true,
                            detailView: false
                        };
                        everPopup.oita0024_open(param);

                        break;

                    case "ITEM_DESC":
                        param = {
                            BUYER_CD: grid.getCellValue(rowIdx, "BUYER_CD"),
                            ITEM_CD: grid.getCellValue(rowIdx, "ITEM_CD"),
                            STD_ITEM_CD: grid.getCellValue(rowIdx, "STD_ITEM_CD"),
                            popupFlag: true,
                            detailView: true
                        };
                        everPopup.oitr0022_open(param);

                        break;
                }
            });

            grid.excelExportEvent({
                allItems: "${excelExport.allCol}",
                fileName: "${screenName }"
            });

            EVF.V("ITEM_STATUS", "10");
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
                return EVF.alert("${OITR0020_0001}"); // 검색조건을 한개 이상 입력하여 주시기 바랍니다.
            }

            var store = new EVF.Store();
            store.setGrid([grid]);
            store.load(baseUrl + "oitr0020_doSearch.so", function () {
                if(grid.getRowCount() == 0) {
                    return EVF.alert("${msg.M0002}");
                }
                //grid.setColMerge(["IMG_FILE_CNT","ATT_FILE_CNT","SOIT_YN","ITEM_CD","VENDOR_ITEM_CD","STD_FLAG","ITEM_DESC","ITEM_SPEC","MAKER_NM","MAKER_PART_NO","BRAND_NM","ORIGIN_CD","UNIT_CD","ITEM_STATUS","CMS_CTRL_USER_ID","SG_CTRL_USER_ID","ITEM_CLS_NM","SG_NM"]);
            });
        }

        function doSave() {
            if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

            if (!grid.validate().flag) { return EVF.alert(grid.validate().msg); }

            EVF.confirm("${msg.M0021 }", function () {
                var store = new EVF.Store();
                store.setGrid([grid]);
                store.getGridData(grid, "sel");
                store.load(baseUrl + "oitr0020_doSave.so", function () {
                    EVF.alert(this.getResponseMessage(), function() {
                        doSearch();
                    });
                });
            });
        }

        function _getItemClsNm()  {

            var popupUrl = "/nhepro/OITR/OITR0021/view.so";
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

        function searchMakerCd(){
            var param = {
                callBackFunction: "selectMakerCd"
            };
            everPopup.openCommonPopup(param, "SP0068");
        }

        function selectMakerCd(data) {
            EVF.V("MAKER_CD", data.MKBR_CD);
            EVF.V("MAKER_NM", data.MKBR_NM);
        }

        function searchBrandCd(){
            var param = {
                callBackFunction: "selectBrandCd"
            };
            everPopup.openCommonPopup(param, "SP0088");
        }

        function selectBrandCd(data) {
            EVF.V("BRAND_CD", data.MKBR_CD);
            EVF.V("BRAND_NM", data.MKBR_NM);
        }

        function doItemRegistration() {
            var param = {
                popupFlag: true,
                detailView: false
            };
            everPopup.oita0024_open(param);
        }

    </script>

    <e:window id="OITR0020" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">

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
                <%-- 품목코드 --%>
                <e:label for="ITEM_CD" title="${form_ITEM_CD_N}" />
                <e:field>
                    <e:inputText id="ITEM_CD" name="ITEM_CD" value="" width="${form_ITEM_CD_W}" maxLength="${form_ITEM_CD_M}" disabled="${form_ITEM_CD_D}" readOnly="${form_ITEM_CD_RO}" required="${form_ITEM_CD_R}"  maskType="${form_ITEM_CD_MT}" />
                </e:field>
                <%-- 표준화여부 --%>
                <e:label for="STD_FLAG" title="${form_STD_FLAG_N}"/>
                <e:field>
                    <e:select id="STD_FLAG" name="STD_FLAG" value="" options="${stdFlagOptions}" width="${form_STD_FLAG_W}" disabled="${form_STD_FLAG_D}" readOnly="${form_STD_FLAG_RO}" required="${form_STD_FLAG_R}" placeHolder=""  maskType="${form_STD_FLAG_MT}"/>
                </e:field>
                <%-- 품목상태 --%>
                <e:label for="ITEM_STATUS" title="${form_ITEM_STATUS_N}"/>
                <e:field>
                    <e:select id="ITEM_STATUS" name="ITEM_STATUS" value="" options="${itemStatusOptions}" width="${form_ITEM_STATUS_W}" disabled="${form_ITEM_STATUS_D}" readOnly="${form_ITEM_STATUS_RO}" required="${form_ITEM_STATUS_R}" placeHolder=""  maskType="${form_ITEM_STATUS_MT}"/>
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
                <%-- 표준화담당자 --%>
                <e:label for="MOD_USER_NM" title="${form_MOD_USER_NM_N}" />
                <e:field>
                    <e:inputText id="MOD_USER_NM" name="MOD_USER_NM" value="" width="${form_MOD_USER_NM_W}" maxLength="${form_MOD_USER_NM_M}" disabled="${form_MOD_USER_NM_D}" readOnly="${form_MOD_USER_NM_RO}" required="${form_MOD_USER_NM_R}" style="${imeMode}" maskType="${form_MOD_USER_NM_MT}"/>
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
        </e:searchPanel>

        <e:buttonBar align="right" width="100%">
            <e:button id="doSearch" name="doSearch" label="${doSearch_N}" onClick="doSearch" disabled="${doSearch_D}" visible="${doSearch_V}"/>
            <e:button id="doSave" name="doSave" label="${doSave_N}" onClick="doSave" disabled="${doSave_D}" visible="${doSave_V}"/>
            <e:button id="doItemRegistration" name="doItemRegistration" label="${doItemRegistration_N}" onClick="doItemRegistration" disabled="${doItemRegistration_D}" visible="${doItemRegistration_V}"/>
        </e:buttonBar>

        <e:gridPanel id="grid" name="grid" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}"/>

    </e:window>
</e:ui>