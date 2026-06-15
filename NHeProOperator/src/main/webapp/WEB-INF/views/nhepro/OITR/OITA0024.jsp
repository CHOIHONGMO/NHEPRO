<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
    <script>
        var baseUrl = "/nhepro/OITR/OITA0024/";
        var gridat;

        function init() {
            gridat = EVF.C("gridat");
            gridat.setProperty("shrinkToFit", ${shrinkToFit});		// 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
            gridat.setProperty("rowNumbers", ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
            gridat.setProperty("sortable", ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
            gridat.setProperty("panelVisible", ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            gridat.setProperty("enterToNextRow", ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            gridat.setProperty("acceptZero", ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            gridat.setProperty("multiSelect", ${multiSelect});		// [선택] 컬럼의 사용여부를 지정한다. [true/false]
            gridat.setProperty("singleSelect", ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]

            _setImages();

            if(EVF.V("STD_FLAG") == "1"){
                EVF.C("ITEM_SPEC").setReadOnly(true);
            }else{
                EVF.C("ITEM_SPEC").setReadOnly(false);
            }

            doSearchAT();
        }

        function doSearchAT() {
            if(${not empty formData.ITEM_CD}) {
                var store = new EVF.Store();
                store.setGrid([gridat]);
                store.load(baseUrl + "oita0024_doSearch_AT.so", function () {
                });
            }
        }

        function doSave() {
            var store = new EVF.Store();
            if(!store.validate()) { return; }

            EVF.confirm("${msg.M0021 }", function () {
                goApproval();
            });
        }

        function goApproval() {

            var store = new EVF.Store();
            store.setGrid([gridat]);
            store.getGridData(gridat, "all");

            store.doFileUpload(function() {
                store.setParameter("mainImgSq", $("#mainImgContainer").find("input[type=radio]:checked").prop("id"));

                store.load(baseUrl + "oita0024_doSave.so", function () {
                    var itemCd = this.getParameter("ITEM_CD");
                    var stdItemCd = this.getParameter("STD_ITEM_CD");

                    EVF.alert(this.getResponseMessage(), function() {
                        if (EVF.isNotEmpty(itemCd) && EVF.isNotEmpty(stdItemCd)) {
                            if(${param.popupFlag eq true}) {
                                opener.doSearch();
                                var param = {
                                    BUYER_CD: "${ses.manageCd}",
                                    STD_ITEM_CD: stdItemCd,
                                    ITEM_CD: itemCd,
                                    popupFlag: true,
                                    detailView: false
                                };
                                window.location.href = "/nhepro/OITR/OITA0024/view.so?" + $.param(param);
                            }else{
                                EVF.confirm("${OITA0024_005 }", function () {
                                    location.href="/nhepro/OITR/OITA0024/view.so";
                                }, function() {
                                    var param = {
                                        BUYER_CD: "${ses.manageCd}",
                                        STD_ITEM_CD: stdItemCd,
                                        ITEM_CD: itemCd,
                                        popupFlag: true,
                                        detailView: false
                                    };
                                    location.href = "/nhepro/OITR/OITA0024/view.so?" + $.param(param);
                                });
                            }
                        }
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
            if(data != null){
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

        // 첨부파일갯수제어-------------------------
        function _doUpload() {
            if(EVF.C("IMG_ATT_FILE_NUM").getFileCount()>4){
                return EVF.alert("${OITA0024_001}");
            }
            EVF.C("IMG_ATT_FILE_NUM").uploadFile();
        }

        function _setImages() {
            var fileManager = EVF.C("IMG_ATT_FILE_NUM");
            var store = new EVF.Store();

            store.setParameter("fileManagerId", fileManager.getID());
            store.setParameter("bizType", "IMG");
            store.setParameter("fileId", fileManager.getFileId());
            store.load("/common/file/fileAttach/getUploadedFileInfo.so", function() {
                var mainImgSq = EVF.V("MAIN_IMG_SQ");
                var fileInfoJson = JSON.parse(this.getParameter("fileInfo"));
                $("#mainImgContainer").empty();
                $.each(fileInfoJson, function(i, datum) {
                    var $itemImage;
                    if(i == 0){
                        $itemImage = $("<div style='float: left; padding-right: 10px;'>" +
                                "<img data-uuid='" + datum.UUID + "' data-uuid_sq='" + datum.UUID_SQ + "' style='width: auto; height: 110px; cursor: pointer; display: block;'" +
                                " onclick='javascript:_setMainImage(this)' src='data:image/" + datum.FILE_EXTENSION + ";base64," + datum.BYTE_ARRAY + "'>" +
                                "<input id='" + datum.UUID_SQ + "' name='itemImage' type='radio' checked='checked'/></div>");
                    }else{
                        $itemImage = $("<div style='float: left; padding-right: 10px;'>" +
                                "<img data-uuid='" + datum.UUID + "' data-uuid_sq='" + datum.UUID_SQ + "' style='width: auto; height: 110px; cursor: pointer; display: block;'" +
                                " onclick='javascript:_setMainImage(this)' src='data:image/" + datum.FILE_EXTENSION + ";base64," + datum.BYTE_ARRAY + "'>" +
                                "<input id='" + datum.UUID_SQ + "' name='itemImage' type='radio' " + (datum.UUID_SQ == mainImgSq ? "checked='checked'" : "") + " /></div>");
                    }
                    $("#mainImgContainer").append($itemImage);
                });
            });
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

        function onError() {
            $(".ui-icon-circle-arrow-w").trigger("click");
        }

        function onChangeStdFlag(){
            EVF.V("ITEM_SPEC", "");

            if(EVF.V("STD_FLAG") == "1"){
                EVF.C("ITEM_SPEC").setReadOnly(true);
            }
            else {
                gridat.delAllRow();
                EVF.C("ITEM_SPEC").setReadOnly(false);
            }
        }

        function _getSpecList(){
            if(EVF.V("STD_FLAG") == ""){
                return EVF.alert("${OITA0024_002}");
            }

            if(EVF.V("STD_FLAG") == "1"){
                if(EVF.V("ITEM_CLS_NM") == ""){
                    EVF.C("ITEM_CLS_NM").setFocus();
                    return EVF.alert("${OITA0024_003}");
                }

                var selectedATData = "";
                var rowIds = gridat.getAllRowId();
                for (var i in rowIds) {
                    if(i > 0){
                        selectedATData = selectedATData + "@" + gridat.getCellValue(rowIds[i], "ATTR_CD") + "|" + gridat.getCellValue(rowIds[i], "ATTR_VALUE");
                    } else {
                        selectedATData = gridat.getCellValue(rowIds[i], "ATTR_CD") + "|" + gridat.getCellValue(rowIds[i], "ATTR_VALUE");
                    }
                }
                var param = {
                    callBackFunction: "_setSpec_Grid",
                    ITEM_CLS1: EVF.V("ITEM_CLS1"),
                    ITEM_CLS2: EVF.V("ITEM_CLS2"),
                    ITEM_CLS3: EVF.V("ITEM_CLS3"),
                    ITEM_CLS4: EVF.V("ITEM_CLS4"),
                    AT_DATA : selectedATData,
                    detailView: false
                };
                everPopup.oita0025_open(param);
                // everPopup.im03_011open(param);
            }
        }

        function _setSpec_Grid(data){
            var itemSpecNm = "";
            gridat.delAllRow();

            for(var idx in data) {
                gridat.addRow();
                gridat.setCellValue(idx, "ATTR_CD", data[idx].ATTR_CD);
                gridat.setCellValue(idx, "ATTR_VALUE", data[idx].ATTR_VALUE);

                if(idx > 0){
                    itemSpecNm = itemSpecNm + "; " + data[idx].ATTR_VALUE;
                }else{
                    itemSpecNm = data[idx].ATTR_VALUE;
                }
            }
            EVF.V("ITEM_SPEC",itemSpecNm);
        }

    </script>
    <%-- IM03_009 --%>
    <e:window id="OITA0024" onReady="init" initData="${initData}" title="${fullScreenName}">
        <e:inputHidden id="STD_ITEM_CD" name="STD_ITEM_CD" value="${formData.STD_ITEM_CD}" />

        <e:buttonBar id="buttonTopBottom" align="right" width="100%" title="${OITA0024_CAPTION1 }">
            <e:button id="doSave" name="doSave" label="${doSave_N}" onClick="doSave" disabled="${doSave_D}" visible="${doSave_V}" data="E"/>
        </e:buttonBar>

        <e:searchPanel id="form" title="${form_CAPTION_N }" labelWidth="${labelWidth}" width="100%" columnCount="3" useTitleBar="false">
            <e:row>
                <%-- 품목코드 --%>
                <e:label for="ITEM_CD" title="${form_ITEM_CD_N}" />
                <e:field>
                    <e:inputText id="ITEM_CD" name="ITEM_CD" value="${formData.ITEM_CD}" width="${form_ITEM_CD_W}" maxLength="${form_ITEM_CD_M}" disabled="${form_ITEM_CD_D}" readOnly="${form_ITEM_CD_RO}" required="${form_ITEM_CD_R}"  maskType="${form_ITEM_CD_MT}" />
                </e:field>
                <%-- 품목상태 --%>
                <e:label for="ITEM_STATUS" title="${form_ITEM_STATUS_N}"/>
                <e:field>
                    <e:select id="ITEM_STATUS" name="ITEM_STATUS" value="${empty formData.ITEM_STATUS ? '10' : formData.ITEM_STATUS}" options="${itemStatusOptions}" width="${form_ITEM_STATUS_W}" disabled="${form_ITEM_STATUS_D}" readOnly="${form_ITEM_STATUS_RO}" required="${form_ITEM_STATUS_R}" placeHolder=""  maskType="${form_ITEM_STATUS_MT}"/>
                </e:field>
                <%-- 최종수정정보 --%>
                <e:label for="MOD_INFO" title="${form_MOD_INFO_N}" />
                <e:field>
                    <e:inputText id="MOD_INFO" name="MOD_INFO" value="${formData.MOD_INFO}" width="${form_MOD_INFO_W}" maxLength="${form_MOD_INFO_M}" disabled="${form_MOD_INFO_D}" readOnly="${form_MOD_INFO_RO}" required="${form_MOD_INFO_R}"  maskType="${form_MOD_INFO_MT}" />
                </e:field>
            </e:row>
            <e:row>
                <%-- 품목분류 --%>
                <e:label for="ITEM_CLS_NM" title="${form_ITEM_CLS_NM_N}"/>
                <e:field colSpan="5">
                    <e:search id="ITEM_CLS_NM" name="ITEM_CLS_NM" value="${formData.ITEM_CLS_NM}" width="${form_ITEM_CLS_NM_W}" maxLength="${form_ITEM_CLS_NM_M}" onIconClick="_getItemClsNm" disabled="${form_ITEM_CLS_NM_D}" readOnly="${form_ITEM_CLS_NM_RO}" required="${form_ITEM_CLS_NM_R}"  maskType="${form_ITEM_CLS_NM_MT}" />
                    <e:inputHidden id="ITEM_CLS1" name="ITEM_CLS1" value="${formData.ITEM_CLS1}"/>
                    <e:inputHidden id="ITEM_CLS2" name="ITEM_CLS2" value="${formData.ITEM_CLS2}"/>
                    <e:inputHidden id="ITEM_CLS3" name="ITEM_CLS3" value="${formData.ITEM_CLS3}"/>
                    <e:inputHidden id="ITEM_CLS4" name="ITEM_CLS4" value="${formData.ITEM_CLS4}"/>
                </e:field>
            </e:row>
            <e:row>
                <%-- 품명 --%>
                <e:label for="ITEM_DESC" title="${form_ITEM_DESC_N}" />
                <e:field colSpan="3">
                    <e:inputText id="ITEM_DESC" name="ITEM_DESC" value="${formData.ITEM_DESC}" width="${form_ITEM_DESC_W}" maxLength="${form_ITEM_DESC_M}" disabled="${form_ITEM_DESC_D}" readOnly="${form_ITEM_DESC_RO}" required="${form_ITEM_DESC_R}"  maskType="${form_ITEM_DESC_MT}" />
                </e:field>
                <%-- 표준화여부 --%>
                <e:label for="STD_FLAG" title="${form_STD_FLAG_N}"/>
                <e:field>
                    <e:select id="STD_FLAG" name="STD_FLAG" value="${formData.STD_FLAG}" options="${stdFlagOptions}" width="${form_STD_FLAG_W}" disabled="${form_STD_FLAG_D}" readOnly="${form_STD_FLAG_RO}" required="${form_STD_FLAG_R}" placeHolder="" onChange="onChangeStdFlag"  maskType="${form_STD_FLAG_MT}"/>
                </e:field>
            </e:row>
            <e:row>
                <%-- 규격 --%>
                <e:label for="ITEM_SPEC" title="${form_ITEM_SPEC_N}"/>
                <e:field colSpan="5">
                    <e:search id="ITEM_SPEC" name="ITEM_SPEC" value="${formData.ITEM_SPEC}" width="${form_ITEM_SPEC_W}" maxLength="${form_ITEM_SPEC_M}" onIconClick="_getSpecList" disabled="${form_ITEM_SPEC_D}" readOnly="${form_ITEM_SPEC_RO}" required="${form_ITEM_SPEC_R}"  placeHolder="${OITA0024_004}" maskType="${form_ITEM_SPEC_MT}" />
                </e:field>
            </e:row>
            <e:row>
                <%-- 제조사 --%>
                <e:label for="MAKER_CD" title="${form_MAKER_CD_N}"/>
                <e:field>
                    <e:search id="MAKER_CD" name="MAKER_CD"  value="${formData.MAKER_CD}" width="40%" maxLength="${form_MAKER_CD_M}" onIconClick="${form_MAKER_CD_D ? 'everCommon.blank' : 'searchMakerCd'}" disabled="${form_MAKER_CD_D}" readOnly="true" required="${form_MAKER_CD_R}"  maskType="${form_MAKER_CD_MT}" />
                    <e:inputText id="MAKER_NM" name="MAKER_NM" value="${formData.MAKER_NM}" width="60%" maxLength="${form_MAKER_NM_M}" disabled="${form_MAKER_NM_D}" readOnly="true" required="${form_MAKER_NM_R}" maskType="${form_MAKER_NM_MT}" />
                </e:field>
                <%-- 모델번호 --%>
                <e:label for="MAKER_PART_NO" title="${form_MAKER_PART_NO_N}" />
                <e:field>
                    <e:inputText id="MAKER_PART_NO" name="MAKER_PART_NO" value="${formData.MAKER_PART_NO}" width="${form_MAKER_PART_NO_W}" maxLength="${form_MAKER_PART_NO_M}" disabled="${form_MAKER_PART_NO_D}" readOnly="${form_MAKER_PART_NO_RO}" required="${form_MAKER_PART_NO_R}"  maskType="${form_MAKER_PART_NO_MT}" />
                </e:field>
                <%-- 브랜드 --%>
                <e:label for="BRAND_CD" title="${form_BRAND_CD_N}"/>
                <e:field>
                    <e:search id="BRAND_CD" name="BRAND_CD"  value="${formData.BRAND_CD}" width="40%" maxLength="${form_BRAND_CD_M}" onIconClick="${form_BRAND_CD_D ? 'everCommon.blank' : 'searchBrandCd'}" disabled="${form_BRAND_CD_D}" readOnly="${form_BRAND_CD_RO}" required="${form_BRAND_CD_R}"  maskType="${form_BRAND_CD_MT}" />
                    <e:inputText id="BRAND_NM" name="BRAND_NM" value="${formData.BRAND_NM}" width="60%" maxLength="${form_BRAND_NM_M}" disabled="${form_BRAND_NM_D}" readOnly="${form_BRAND_NM_RO}" required="${form_BRAND_NM_R}" maskType="${form_BRAND_NM_MT}" />
                </e:field>
            </e:row>
            <e:row>
                <%-- 단위 --%>
                <e:label for="UNIT_CD" title="${form_UNIT_CD_N}" />
                <e:field>
                    <e:select id="UNIT_CD" name="UNIT_CD" value="${formData.UNIT_CD}" options="${unitCdOptions}" width="${form_UNIT_CD_W}" disabled="${form_UNIT_CD_D}" readOnly="${form_UNIT_CD_RO}" required="${form_UNIT_CD_R}" placeHolder="" usePlaceHolder="true" useMultipleSelect="true" singleSelect="true" maskType="${form_UNIT_CD_MT}"/>
                </e:field>
                <%-- 원산지 --%>
                <e:label for="ORIGIN_CD" title="${form_ORIGIN_CD_N}" />
                <e:field>
                    <e:select id="ORIGIN_CD" name="ORIGIN_CD" value="${formData.ORIGIN_CD}" options="${originCdOptions}" width="${form_ORIGIN_CD_W}" disabled="${form_ORIGIN_CD_D}" readOnly="${form_ORIGIN_CD_RO}" required="${form_ORIGIN_CD_R}" placeHolder="" usePlaceHolder="true" useMultipleSelect="true" singleSelect="true" maskType="${form_ORIGIN_CD_MT}"/>
                </e:field>
                <%-- 과세구분 --%>
                <e:label for="VAT_CD" title="${form_VAT_CD_N}" />
                <e:field>
                    <e:select id="VAT_CD" name="VAT_CD" value="${formData.VAT_CD}" options="${vatCdOptions}" width="${form_VAT_CD_W}" disabled="${form_VAT_CD_D}" readOnly="${form_VAT_CD_RO}" required="${form_VAT_CD_R}" placeHolder="" usePlaceHolder="true" maskType="${form_VAT_CD_MT}"/>
                </e:field>
            </e:row>
            <e:row>
                <%-- 추가사양 --%>
                <e:label for="ITEM_RMK" title="${form_ITEM_RMK_N}"/>
                <e:field colSpan="5">
                    <e:textArea id="ITEM_RMK" name="ITEM_RMK" value="${formData.ITEM_RMK}" height="100px" width="${form_ITEM_RMK_W}" maxLength="${form_ITEM_RMK_M}" disabled="${form_ITEM_RMK_D}" readOnly="${form_ITEM_RMK_RO}" required="${form_ITEM_RMK_R}" />
                </e:field>
            </e:row>
            <e:row>
                <%-- 첨부파일 --%>
                <e:label for="ATT_FILE_NUM" title="${form_ATT_FILE_NUM_N }" />
                <e:field colSpan="5">
                    <e:fileManager id="ATT_FILE_NUM" name="ATT_FILE_NUM" fileId="${formData.ATT_FILE_NUM}" downloadable="true" width="100%" bizType="NT" height="80px" readOnly="${!param.detailView ? false : true }" onBeforeRemove="onBeforeRemove" onError="onError" onFileClick="onFileClick" onSuccess="onSuccess" required="" fileExtension="${fileExtension}" />
                </e:field>
            </e:row>
        </e:searchPanel>

        <e:searchPanel id="searchPanel2" title="${OITA0024_CAPTION2}" labelWidth="${labelWidth}" width="100%" height="150px" columnCount="3" useTitleBar="true">
            <e:row>
                <e:field colSpan="2">
                    <e:fileManager id="IMG_ATT_FILE_NUM" name="IMG_ATT_FILE_NUM" fileId="${formData.IMG_ATT_FILE_NUM}" bizType="IMG" width="100%" height="150px" readOnly="${form_IMG_ATT_FILE_NUM_RO}" required="${form_IMG_ATT_FILE_NUM_R}" onFileAdd="_doUpload" onSuccess="_setImages" onAfterRemove="_setImages" maxFileCount="4" onError="onError"/>
                </e:field>
                <e:field colSpan="4">
                    <div id="mainImgContainer" style="width: 100%; height: 100%;"></div>
                    <e:inputHidden id="MAIN_IMG_SQ" name="MAIN_IMG_SQ" value="${formData.MAIN_IMG_SQ}" />
                </e:field>
            </e:row>
        </e:searchPanel>

        <e:panel id="hiddenP" height="0" width="0%">
            <e:gridPanel gridType="${_gridType}" id="gridat" name="gridat" height="0px" readOnly="${param.detailView}"/>
        </e:panel>

    </e:window>
</e:ui>