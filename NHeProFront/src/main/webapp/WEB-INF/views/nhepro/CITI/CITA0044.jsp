<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">

    <script type="text/javascript">

        var baseUrl = "/nhepro/CITI/CITA0044/";

        function init() {
            _setImages();
        }

        function onError() {
            $(".ui-icon-circle-arrow-w").trigger("click");
        }

        // 첨부파일갯수제어-------------------------
        function _doUpload() {
            if(EVF.C("IMG_ATT_FILE_NUM").getFileCount()>4){
                return EVF.alert("${CITA0044_001}");
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

        function doInsert() {
            var store = new EVF.Store();
            if(!store.validate()) { return; }

            EVF.confirm("${msg.M0011 }", function () {
                goApproval();
            });
        }

        function doUpdate() {
	        var store = new EVF.Store();
	        if(!store.validate()) { return; }

	        EVF.confirm("${msg.M0012 }", function () {
		        goApproval();
	        });
        }

        function goApproval() {

	        var store = new EVF.Store();
	        store.doFileUpload(function() {
		        store.setParameter("mainImgSq", $("#mainImgContainer").find("input[type=radio]:checked").prop("id"));

		        store.load(baseUrl + "cita0044_doSave.so", function () {
			        var itemCd = this.getParameter("ITEM_CD");
			        var stdItemCd = this.getParameter("STD_ITEM_CD");

			        EVF.alert(this.getResponseMessage(), function() {
                        if (opener != null) {
                            opener.doSearch();
                        }

						var param = {
							BUYER_CD: EVF.V("BUYER_CD"),
							ITEM_CD: itemCd,
							STD_ITEM_CD: stdItemCd,
							manageFlag: 0,
							detailView: false,
							popupFlag: true
						};

						window.location.href = "/nhepro/CITI/CITA0044/view.so?" + $.param(param);
			        });
		        });
	        });
        }

        function doDelete() {

            var store = new EVF.Store();
            EVF.confirm("${msg.M0013 }", function () {
                store.load(baseUrl + "cita0044_doDelete.so", function() {
                    EVF.alert("${msg.M0017}", function() {
                        if (opener != null) {
                            opener.doSearch();
                        }
                        EVF.closeWindow();
                    });
                });
            });
        }

    </script>
    <e:window id="CITA0044" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">
        <e:inputHidden id="BUYER_CD" name="BUYER_CD" value="${form.BUYER_CD}"/>
        <e:inputHidden id="STD_ITEM_CD" name="STD_ITEM_CD" value="${form.STD_ITEM_CD}"/>

        <e:buttonBar align="right" width="100%" title="${CITA0044_CAPTION1}">
            <e:button id="doInsert" name="doInsert" label="${doInsert_N}" onClick="doInsert" disabled="${empty form.ITEM_CD ? false : true}" visible="${doInsert_V}"/>
            <e:button id="doUpdate" name="doUpdate" label="${doUpdate_N}" onClick="doUpdate" disabled="${empty form.ITEM_CD ? true : false}" visible="${doUpdate_V}"/>
            <e:button id="doDelete" name="doDelete" label="${doDelete_N}" onClick="doDelete" disabled="${empty form.ITEM_CD ? true : false}" visible="${doDelete_V}"/>
        </e:buttonBar>

        <e:searchPanel id="form" title="${CITA0044_CAPTION1 }" labelWidth="${labelWidth}" width="100%" columnCount="3" useTitleBar="false" onEnter="doSearch">
            <e:row>
                <%-- 품목코드 --%>
                <e:label for="ITEM_CD" title="${form_ITEM_CD_N}" />
                <e:field>
                    <e:inputText id="ITEM_CD" name="ITEM_CD" value="${form.ITEM_CD}" width="${form_ITEM_CD_W}" maxLength="${form_ITEM_CD_M}" disabled="${form_ITEM_CD_D}" readOnly="${form_ITEM_CD_RO}" required="${form_ITEM_CD_R}" style="${imeMode}" maskType="${form_ITEM_CD_MT}"/>
                </e:field>
                <%-- 최종수정자 --%>
                <e:label for="MOD_USER_NM" title="${form_MOD_USER_NM_N}" />
                <e:field>
                    <e:inputText id="MOD_USER_NM" name="MOD_USER_NM" value="${form.MOD_USER_NM}" width="${form_MOD_USER_NM_W}" maxLength="${form_MOD_USER_NM_M}" disabled="${form_MOD_USER_NM_D}" readOnly="${form_MOD_USER_NM_RO}" required="${form_MOD_USER_NM_R}" style="${imeMode}" maskType="${form_MOD_USER_NM_MT}"/>
                </e:field>
                <%-- 최종수정일시 --%>
                <e:label for="MOD_DATE" title="${form_MOD_DATE_N}" />
                <e:field>
                    <e:inputText id="MOD_DATE" name="MOD_DATE" value="${form.MOD_DATE}" width="${form_MOD_DATE_W}" maxLength="${form_MOD_DATE_M}" disabled="${form_MOD_DATE_D}" readOnly="${form_MOD_DATE_RO}" required="${form_MOD_DATE_R}" style="${imeMode}" maskType="${form_MOD_DATE_MT}"/>
                </e:field>
            </e:row>
            <e:row>
                <%-- 품목분류 --%>
                <e:label for="ITEM_CLS_NM" title="${form_ITEM_CLS_NM_N}" />
                <e:field colSpan="5">
                    <e:search id="ITEM_CLS_NM" name="ITEM_CLS_NM" value="${form.ITEM_CLS_NM}" width="${form_ITEM_CLS_NM_W}" maxLength="${form_ITEM_CLS_NM_M}" onIconClick="_getItemClsNm" disabled="${form_ITEM_CLS_NM_D}" readOnly="${form_ITEM_CLS_NM_RO}" required="${form_ITEM_CLS_NM_R}"  maskType="${form_ITEM_CLS_NM_MT}" />
                    <e:inputHidden id="ITEM_CLS1" name="ITEM_CLS1" value="${form.ITEM_CLS1}"/>
                    <e:inputHidden id="ITEM_CLS2" name="ITEM_CLS2" value="${form.ITEM_CLS2}"/>
                    <e:inputHidden id="ITEM_CLS3" name="ITEM_CLS3" value="${form.ITEM_CLS3}"/>
                    <e:inputHidden id="ITEM_CLS4" name="ITEM_CLS4" value="${form.ITEM_CLS4}"/>
                </e:field>
            </e:row>
            <e:row>
                <%-- 품명 --%>
                <e:label for="ITEM_DESC" title="${form_ITEM_DESC_N}" />
                <e:field colSpan="3">
                    <e:inputText id="ITEM_DESC" name="ITEM_DESC" value="${form.ITEM_DESC}" width="${form_ITEM_DESC_W}" maxLength="${form_ITEM_DESC_M}" disabled="${form_ITEM_DESC_D}" readOnly="${form_ITEM_DESC_RO}" required="${form_ITEM_DESC_R}" style="${imeMode}" maskType="${form_ITEM_DESC_MT}"/>
                </e:field>
                <%-- 원산지 --%>
                <e:label for="ORIGIN_CD" title="${form_ORIGIN_CD_N}"/>
                <e:field>
                    <e:select id="ORIGIN_CD" name="ORIGIN_CD" value="${form.ORIGIN_CD}" options="${originCdOptions}" width="${form_ORIGIN_CD_W}" disabled="${form_ORIGIN_CD_D}" readOnly="${form_ORIGIN_CD_RO}" required="${form_ORIGIN_CD_R}" placeHolder="" maskType="${form_ORIGIN_CD_MT}" />
                </e:field>
            </e:row>
            <e:row>
                <%-- 규격 --%>
                <e:label for="ITEM_SPEC" title="${form_ITEM_SPEC_N}" />
                <e:field colSpan="5">
                    <e:inputText id="ITEM_SPEC" name="ITEM_SPEC" value="${form.ITEM_SPEC}" width="${form_ITEM_SPEC_W}" maxLength="${form_ITEM_SPEC_M}" disabled="${form_ITEM_SPEC_D}" readOnly="${form_ITEM_SPEC_RO}" required="${form_ITEM_SPEC_R}" style="${imeMode}" maskType="${form_ITEM_SPEC_MT}"/>
                </e:field>
            </e:row>
            <e:row>
                <%-- 제조사 --%>
                <e:label for="MAKER_CD" title="${form_MAKER_CD_N}"/>
                <e:field>
                    <e:search id="MAKER_CD" name="MAKER_CD"  value="${form.MAKER_CD}" width="40%" maxLength="${form_MAKER_CD_M}" onIconClick="${form_MAKER_CD_D ? 'everCommon.blank' : 'searchMakerCd'}" disabled="${form_MAKER_CD_D}" readOnly="true" required="${form_MAKER_CD_R}"  maskType="${form_MAKER_CD_MT}" />
                    <e:inputText id="MAKER_NM" name="MAKER_NM" value="${form.MAKER_NM}" width="60%" maxLength="${form_MAKER_NM_M}" disabled="${form_MAKER_NM_D}" readOnly="true" required="${form_MAKER_NM_R}" maskType="${form_MAKER_NM_MT}" />
                </e:field>
                <%-- 모델번호 --%>
                <e:label for="MAKER_PART_NO" title="${form_MAKER_PART_NO_N}" />
                <e:field>
                    <e:inputText id="MAKER_PART_NO" name="MAKER_PART_NO" value="${form.MAKER_PART_NO}" width="${form_MAKER_PART_NO_W}" maxLength="${form_MAKER_PART_NO_M}" disabled="${form_MAKER_PART_NO_D}" readOnly="${form_MAKER_PART_NO_RO}" required="${form_MAKER_PART_NO_R}" style="${imeMode}" maskType="${form_MAKER_PART_NO_MT}"/>
                </e:field>
                <%-- 브랜드 --%>
                <e:label for="BRAND_CD" title="${form_BRAND_CD_N}"/>
                <e:field>
                    <e:search id="BRAND_CD" name="BRAND_CD"  value="${form.BRAND_CD}" width="40%" maxLength="${form_BRAND_CD_M}" onIconClick="${form_BRAND_CD_D ? 'everCommon.blank' : 'searchBrandCd'}" disabled="${form_BRAND_CD_D}" readOnly="${form_BRAND_CD_RO}" required="${form_BRAND_CD_R}"  maskType="${form_BRAND_CD_MT}" />
                    <e:inputText id="BRAND_NM" name="BRAND_NM" value="${form.BRAND_NM}" width="60%" maxLength="${form_BRAND_NM_M}" disabled="${form_BRAND_NM_D}" readOnly="${form_BRAND_NM_RO}" required="${form_BRAND_NM_R}" maskType="${form_BRAND_NM_MT}" />
                </e:field>
            </e:row>
            <e:row>
                <%-- 단위 --%>
                <e:label for="UNIT_CD" title="${form_UNIT_CD_N}"/>
                <e:field>
                    <e:select id="UNIT_CD" name="UNIT_CD" value="${form.UNIT_CD}" options="${unitCdOptions}" width="${form_UNIT_CD_W}" disabled="${form_UNIT_CD_D}" readOnly="${form_UNIT_CD_RO}" required="${form_UNIT_CD_R}" placeHolder="" maskType="${form_UNIT_CD_MT}" />
                </e:field>
                <%-- 직발주여부 --%>
                <e:label for="DIRECT_PO_FLAG" title="${form_DIRECT_PO_FLAG_N}"/>
                <e:field>
                    <e:select id="DIRECT_PO_FLAG" name="DIRECT_PO_FLAG" value="${form.DIRECT_PO_FLAG}" options="${directPoFlagOptions}" width="${form_DIRECT_PO_FLAG_W}" disabled="${form_DIRECT_PO_FLAG_D}" readOnly="${form_DIRECT_PO_FLAG_RO}" required="${form_DIRECT_PO_FLAG_R}" placeHolder="" maskType="${form_DIRECT_PO_FLAG_MT}" />
                </e:field>
                <%-- 대표품목여부 --%>
                <e:label for="MAJOR_ITEM_FLAG" title="${form_MAJOR_ITEM_FLAG_N}"/>
                <e:field>
                    <e:select id="MAJOR_ITEM_FLAG" name="MAJOR_ITEM_FLAG" value="${form.MAJOR_ITEM_FLAG}" options="${majorItemFlagOptions}" width="${form_MAJOR_ITEM_FLAG_W}" disabled="${form_MAJOR_ITEM_FLAG_D}" readOnly="${form_MAJOR_ITEM_FLAG_RO}" required="${form_MAJOR_ITEM_FLAG_R}" placeHolder="" maskType="${form_MAJOR_ITEM_FLAG_MT}" />
                </e:field>
            </e:row>
            <e:row>
                <%-- 추가사양 --%>
                <e:label for="ITEM_RMK" title="${form_ITEM_RMK_N}"/>
                <e:field colSpan="5">
                    <e:textArea id="ITEM_RMK" name="ITEM_RMK" value="${form.ITEM_RMK}" height="100px" width="${form_ITEM_RMK_W}" maxLength="${form_ITEM_RMK_M}" disabled="${form_ITEM_RMK_D}" readOnly="${form_ITEM_RMK_RO}" required="${form_ITEM_RMK_R}" />
                </e:field>
            </e:row>
            <e:row>
                <%-- 첨부파일 --%>
                <e:label for="ATT_FILE_NUM" title="${form_ATT_FILE_NUM_N }" />
                <e:field colSpan="5">
                    <e:fileManager id="ATT_FILE_NUM" name="ATT_FILE_NUM" fileId="${form.ATT_FILE_NUM}" downloadable="true" width="100%" bizType="NT" height="100px" readOnly="${form_ATT_FILE_NUM_RO }" onBeforeRemove="onBeforeRemove" onError="onError" onFileClick="onFileClick" onSuccess="onSuccess" required="" fileExtension="${fileExtension}" />
                </e:field>
            </e:row>
        </e:searchPanel>

        <e:searchPanel id="searchPanel2" title="" labelWidth="${labelWidth}" width="100%" height="150px" columnCount="3" useTitleBar="false">
            <e:row>
                <e:field colSpan="2">
                    <e:fileManager id="IMG_ATT_FILE_NUM" name="IMG_ATT_FILE_NUM" fileId="${form.IMG_ATT_FILE_NUM}" bizType="IMG" width="100%" height="150px" readOnly="${form_IMG_ATT_FILE_NUM_RO}" required="${form_IMG_ATT_FILE_NUM_R}" onFileAdd="_doUpload" onSuccess="_setImages" onAfterRemove="_setImages" maxFileCount="4" onError="onError"/>
                </e:field>
                <e:field colSpan="4">
                    <div id="mainImgContainer" style="width: 100%; height: 100%;"></div>
                    <e:inputHidden id="MAIN_IMG_SQ" name="MAIN_IMG_SQ" value="${form.MAIN_IMG_SQ}" />
                </e:field>
            </e:row>
        </e:searchPanel>

    </e:window>
</e:ui>