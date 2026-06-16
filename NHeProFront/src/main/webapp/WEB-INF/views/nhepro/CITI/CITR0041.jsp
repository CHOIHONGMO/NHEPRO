<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
    <script>
        var baseUrl = "/nhepro/CITI/CITR0041/";

        function init() {
            _setImages();
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

        function onError() {
            $(".ui-icon-circle-arrow-w").trigger("click");
        }

        // [고도화변경] 2026.06.16 내부 LLM 연동 추가
        function doAiPriceInquiry() {
            var param = {
                ITEM_CD: EVF.V("ITEM_CD"),
                ITEM_DESC: EVF.V("ITEM_DESC"),
                ITEM_SPEC: EVF.V("ITEM_SPEC")
            };
            var url = '/nhepro/LLM/LLM0010/view.so';
            everPopup.openWindowPopup(url, 1000, 750, param, "aiPriceInquiryPopup");
        }

    </script>
    <e:window id="CITR0041" onReady="init" initData="${initData}" title="${fullScreenName}">
        <e:inputHidden id="STD_ITEM_CD" name="STD_ITEM_CD" value="${formData.STD_ITEM_CD}" />

        <!-- [고도화변경] 2026.06.16 내부 LLM 연동 추가 -->
        <e:buttonBar align="right" width="100%">
            <e:button id="aiPriceInquiry" name="aiPriceInquiry" label="AI 가격 정보 조회" onClick="doAiPriceInquiry" />
        </e:buttonBar>

        <e:searchPanel id="form" title="${CITR0041_CAPTION1 }" labelWidth="${labelWidth}" width="100%" columnCount="3" useTitleBar="true">
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
                    <e:inputText id="ITEM_CLS_NM" name="ITEM_CLS_NM" value="${formData.ITEM_CLS_NM}" width="${form_ITEM_CLS_NM_W}" maxLength="${form_ITEM_CLS_NM_M}" disabled="${form_ITEM_CLS_NM_D}" readOnly="${form_ITEM_CLS_NM_RO}" required="${form_ITEM_CLS_NM_R}"  maskType="${form_ITEM_CLS_NM_MT}" />
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
                    <e:inputText id="ITEM_SPEC" name="ITEM_SPEC" value="${formData.ITEM_SPEC}" width="${form_ITEM_SPEC_W}" disabled="${form_ITEM_SPEC_D}" maxLength="${form_ITEM_SPEC_M}" readOnly="${form_ITEM_SPEC_RO}" required="${form_ITEM_SPEC_R}"  placeHolder="${OITR0022_004}" maskType="${form_ITEM_SPEC_MT}" />
                </e:field>
            </e:row>
            <e:row>
                <%-- 제조사 --%>
                <e:label for="MAKER_CD" title="${form_MAKER_CD_N}"/>
                <e:field>
                    <e:search id="MAKER_CD" name="MAKER_CD"  value="${formData.MAKER_CD}" width="40%" maxLength="${form_MAKER_CD_M}" onIconClick="${form_MAKER_CD_D ? 'everCommon.blank' : ''}" disabled="${form_MAKER_CD_D}" readOnly="true" required="${form_MAKER_CD_R}"  maskType="${form_MAKER_CD_MT}" />
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
                    <e:search id="BRAND_CD" name="BRAND_CD"  value="${formData.BRAND_CD}" width="40%" maxLength="${form_BRAND_CD_M}" onIconClick="${form_BRAND_CD_D ? 'everCommon.blank' : ''}" disabled="${form_BRAND_CD_D}" readOnly="${form_BRAND_CD_RO}" required="${form_BRAND_CD_R}"  maskType="${form_BRAND_CD_MT}" />
                    <e:inputText id="BRAND_NM" name="BRAND_NM" value="${formData.BRAND_NM}" width="60%" maxLength="${form_BRAND_NM_M}" disabled="${form_BRAND_NM_D}" readOnly="${form_BRAND_NM_RO}" required="${form_BRAND_NM_R}" maskType="${form_BRAND_NM_MT}" />
                </e:field>
            </e:row>
            <e:row>
                <%-- 단위 --%>
                <e:label for="UNIT_CD" title="${form_UNIT_CD_N}" />
                <e:field>
                    <e:select id="UNIT_CD" name="UNIT_CD" value="${formData.UNIT_CD}" options="${unitCdOptions}" width="${form_UNIT_CD_W}" disabled="${form_UNIT_CD_D}" readOnly="${form_UNIT_CD_RO}" required="${form_UNIT_CD_R}" placeHolder="" usePlaceHolder="true" useMultipleSelect="true" singleSelect="true" maskType="${form_UNIT_CD_MT}"/>
                </e:field>
                <%-- 직발주여부 --%>
                <e:label for="DIRECT_PO_FLAG" title="${form_DIRECT_PO_FLAG_N}"/>
                <e:field>
                    <e:select id="DIRECT_PO_FLAG" name="DIRECT_PO_FLAG" value="${formData.DIRECT_PO_FLAG}" options="${directPoFlagOptions}" width="${form_DIRECT_PO_FLAG_W}" disabled="${form_DIRECT_PO_FLAG_D}" readOnly="${form_DIRECT_PO_FLAG_RO}" required="${form_DIRECT_PO_FLAG_R}" placeHolder="" maskType="${form_DIRECT_PO_FLAG_MT}" />
                </e:field>
                <%-- 대표품목여부 --%>
                <e:label for="MAJOR_ITEM_FLAG" title="${form_MAJOR_ITEM_FLAG_N}"/>
                <e:field>
                    <e:select id="MAJOR_ITEM_FLAG" name="MAJOR_ITEM_FLAG" value="${formData.MAJOR_ITEM_FLAG}" options="${majorItemFlagOptions}" width="${form_MAJOR_ITEM_FLAG_W}" disabled="${form_MAJOR_ITEM_FLAG_D}" readOnly="${form_MAJOR_ITEM_FLAG_RO}" required="${form_MAJOR_ITEM_FLAG_R}" placeHolder="" maskType="${form_MAJOR_ITEM_FLAG_MT}" />
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

        <e:searchPanel id="searchPanel2" title="${CITR0041_CAPTION2 }" labelWidth="${labelWidth}" width="100%" height="150px" columnCount="3" useTitleBar="true">
            <e:row>
                <e:field colSpan="2">
                    <e:fileManager id="IMG_ATT_FILE_NUM" name="IMG_ATT_FILE_NUM" fileId="${formData.IMG_ATT_FILE_NUM}" bizType="IMG" width="100%" height="150px" readOnly="${!param.detailView ? false : true }" required="${form_IMG_ATT_FILE_NUM_R}" onFileAdd="_doUpload" onSuccess="_setImages" onAfterRemove="_setImages" maxFileCount="4" onError="onError"/>
                </e:field>
                <e:field colSpan="4">
                    <div id="mainImgContainer" style="width: 100%; height: 100%;"></div>
                    <e:inputHidden id="MAIN_IMG_SQ" name="MAIN_IMG_SQ" value="${formData.MAIN_IMG_SQ}" />
                </e:field>
            </e:row>
        </e:searchPanel>

    </e:window>
</e:ui>