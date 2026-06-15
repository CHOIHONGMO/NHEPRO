<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
    <script>
        var baseUrl = "/nhepro/CITI/CITR0046/";
        var grid;
        var APmultiYn;
        var signStatus;

        function init() {
            grid = EVF.C("grid");
            grid.setProperty("shrinkToFit", ${shrinkToFit});		// 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
            grid.setProperty("rowNumbers", ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
            grid.setProperty("sortable", ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
            grid.setProperty("panelVisible", ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            grid.setProperty("enterToNextRow", ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            grid.setProperty("acceptZero", ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            grid.setProperty("multiSelect", false);		// [선택] 컬럼의 사용여부를 지정한다. [true/false]
            grid.setProperty("singleSelect", ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]

            _setImages();

            doSearch();
        }

        function doSearch() {
            var store = new EVF.Store();
            store.setGrid([grid]);
            store.load(baseUrl + "citr0046_doSearch.so", function () {
            });
        }

        function _getItemClsNm()  {
            return;
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
                                "<input id='"+datum.UUID_SQ + "' name='itemImage' type='radio' " + (datum.UUID_SQ == mainImgSq ? "checked='checked'" : "") + " /></div>");
                    }
                    $("#mainImgContainer").append($itemImage);
                });
            });
        }

        function searchMakerCd(){
            return;
        }

        function searchBrandCd(){
            return;
        }

        function onError() {
            $(".ui-icon-circle-arrow-w").trigger("click");
        }

        function _getSpecList(){
            if(EVF.V("STD_FLAG") == "1"){

                var selectedATData = "";
                var rowIds = grid.getAllRowId();
                for (var i in rowIds) {
                    if(i > 0){
                        selectedATData = selectedATData + "@" + grid.getCellValue(rowIds[i], "ATTR_CD") + "|" + grid.getCellValue(rowIds[i], "ATTR_VALUE");
                    } else {
                        selectedATData = grid.getCellValue(rowIds[i], "ATTR_CD") + "|" + grid.getCellValue(rowIds[i], "ATTR_VALUE");
                    }
                }
                var param = {
                    ITEM_CD: EVF.V("ITEM_CD"),
                    BUYER_CD: EVF.V("BUYER_CD"),
                    ITEM_CLS1: EVF.V("ITEM_CLS1"),
                    ITEM_CLS2: EVF.V("ITEM_CLS2"),
                    ITEM_CLS3: EVF.V("ITEM_CLS3"),
                    ITEM_CLS4: EVF.V("ITEM_CLS4"),
                    detailView: true
                };
                everPopup.citr0047_open(param);
            }
        }

    </script>
    <%-- IM03_009 --%>
    <e:window id="CITR0046" onReady="init" initData="${initData}" title="${fullScreenName}">
        <e:inputHidden id="BUYER_CD" name="BUYER_CD" value="${formData.BUYER_CD}" />
        <e:inputHidden id="STD_ITEM_CD" name="STD_ITEM_CD" value="${formData.STD_ITEM_CD}" />
        <e:inputHidden id="STD_FLAG" name="STD_FLAG" value="${formData.STD_FLAG}" />

        <e:buttonBar id="buttonTopBottom" align="right" width="100%" title="${CITR0046_CAPTION1 }">
            <e:button id="doSave" name="doSave" label="${doSave_N}" onClick="doSave" disabled="${doSave_D}" visible="${doSave_V}" data="E"/>
        </e:buttonBar>

        <e:searchPanel id="form" title="${form_CAPTION_N }" labelWidth="${labelWidth}" width="100%" columnCount="3" useTitleBar="false">
            <e:row>
                <%-- 품목코드 --%>
                <e:label for="ITEM_CD" title="${form_ITEM_CD_N}" />
                <e:field>
                    <e:inputText id="ITEM_CD" name="ITEM_CD" value="${formData.ITEM_CD}" width="${form_ITEM_CD_W}" maxLength="${form_ITEM_CD_M}" disabled="${form_ITEM_CD_D}" readOnly="${form_ITEM_CD_RO}" required="${form_ITEM_CD_R}"  maskType="${form_ITEM_CD_MT}" />
                </e:field>
                <%-- 최종수정자 --%>
                <e:label for="MOD_USER_NM" title="${form_MOD_USER_NM_N}" />
                <e:field>
                    <e:inputText id="MOD_USER_NM" name="MOD_USER_NM" value="${formData.MOD_USER_NM}" width="${form_MOD_USER_NM_W}" maxLength="${form_MOD_USER_NM_M}" disabled="${form_MOD_USER_NM_D}" readOnly="${form_MOD_USER_NM_RO}" required="${form_MOD_USER_NM_R}" style="${imeMode}" maskType="${form_MOD_USER_NM_MT}"/>
                </e:field>
                <%-- 최종수정일시 --%>
                <e:label for="MOD_DATE" title="${form_MOD_DATE_N}" />
                <e:field>
                    <e:inputText id="MOD_DATE" name="MOD_DATE" value="${formData.MOD_DATE}" width="${form_MOD_DATE_W}" maxLength="${form_MOD_DATE_M}" disabled="${form_MOD_DATE_D}" readOnly="${form_MOD_DATE_RO}" required="${form_MOD_DATE_R}" style="${imeMode}" maskType="${form_MOD_DATE_MT}"/>
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
                <%-- 원산지 --%>
                <e:label for="ORIGIN_CD" title="${form_ORIGIN_CD_N}" />
                <e:field>
                    <e:select id="ORIGIN_CD" name="ORIGIN_CD" value="${formData.ORIGIN_CD}" options="${originCdOptions}" width="${form_ORIGIN_CD_W}" disabled="${form_ORIGIN_CD_D}" readOnly="${form_ORIGIN_CD_RO}" required="${form_ORIGIN_CD_R}" placeHolder="" usePlaceHolder="true" useMultipleSelect="true" singleSelect="true" maskType="${form_ORIGIN_CD_MT}"/>
                </e:field>
            </e:row>
            <e:row>
                <%-- 규격 --%>
                <e:label for="ITEM_SPEC" title="${form_ITEM_SPEC_N}"/>
                <e:field colSpan="5">
                    <e:search id="ITEM_SPEC" name="ITEM_SPEC" value="${formData.ITEM_SPEC}" width="${form_ITEM_SPEC_W}" maxLength="${form_ITEM_SPEC_M}" onIconClick="_getSpecList" disabled="${form_ITEM_SPEC_D}" readOnly="${form_ITEM_SPEC_RO}" required="${form_ITEM_SPEC_R}"  placeHolder="${CITR0046_004}" maskType="${form_ITEM_SPEC_MT}" />
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
                <%-- 과세구분 --%>
                <e:label for="VAT_CD" title="${form_VAT_CD_N}" />
                <e:field colSpan="3">
                    <e:select id="VAT_CD" name="VAT_CD" value="${formData.VAT_CD}" options="${vatCdOptions}" width="${form_VAT_CD_W}" disabled="${form_VAT_CD_D}" readOnly="${form_VAT_CD_RO}" required="${form_VAT_CD_R}" placeHolder="" usePlaceHolder="true" maskType="${form_VAT_CD_MT}"/>
                </e:field>
            </e:row>
        </e:searchPanel>

        <e:gridPanel gridType="${_gridType}" id="grid" name="grid" height="fit" readOnly="${param.detailView}"/>

        <e:searchPanel id="form2" title="${form_CAPTION_N }" labelWidth="${labelWidth}" width="100%" columnCount="3" useTitleBar="false">
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
                    <e:fileManager id="ATT_FILE_NUM" name="ATT_FILE_NUM" fileId="${formData.ATT_FILE_NUM}" downloadable="true" width="100%" bizType="NT" height="80px" readOnly="${!formData.detailView ? false : true }" onBeforeRemove="onBeforeRemove" onError="onError" onFileClick="onFileClick" onSuccess="onSuccess" required="" fileExtension="${fileExtension}" />
                </e:field>
            </e:row>
        </e:searchPanel>

        <e:searchPanel id="searchPanel2" title="${CITR0046_CAPTION2}" labelWidth="${labelWidth}" width="100%" height="150px" columnCount="3" useTitleBar="true">
            <e:row>
                <e:field colSpan="2">
                    <e:fileManager id="IMG_ATT_FILE_NUM" name="IMG_ATT_FILE_NUM" fileId="${formData.IMG_ATT_FILE_NUM}" bizType="IMG" width="100%" height="150px" readOnly="${!formData.detailView ? false : true }" required="${form_IMG_ATT_FILE_NUM_R}" onFileAdd="_doUpload" onSuccess="_setImages" onAfterRemove="_setImages" maxFileCount="4" onError="onError"/>
                </e:field>
                <e:field colSpan="4">
                    <div id="mainImgContainer" style="width: 100%; height: 100%;"></div>
                    <e:inputHidden id="MAIN_IMG_SQ" name="MAIN_IMG_SQ" value="${formData.MAIN_IMG_SQ}" />
                </e:field>
            </e:row>
        </e:searchPanel>

    </e:window>
</e:ui>