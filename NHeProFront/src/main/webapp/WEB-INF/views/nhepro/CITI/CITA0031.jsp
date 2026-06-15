<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">

    <script type="text/javascript">

        var baseUrl = "/nhepro/CITI/CITA0031/";

        function init() {
        }

        function doCopy() {
            var formData = formUtil.getFormData();
            var formKey = Object.keys(formData);

            for(var i = 0; i < formKey.length; i++) {

                if (EVF.isComponent(formKey[i] + "_CP")) {
                    EVF.V(formKey[i] + "_CP", formData[formKey[i]]);
                } else {
                    if(formKey[i] == "ITEM_REQ_RMK") {
                        EVF.V("ITEM_RMK", formData[formKey[i]]);
                    } else if(formKey[i] == "ATTACH_FILE_NO") {
                        EVF.V("ATT_FILE_NUM", formData[formKey[i]]);
                    } else if(formKey[i] == "IMG_UUID") {
                        EVF.V("IMG_ATT_FILE_NUM", formData[formKey[i]]);
                        _setImages();
                    } else if(formKey[i] == "ORIGIN_NM") {
                        $("#ORIGIN_CD > option").each(function(k, v) {
                            if (v.title == formData[formKey[i]]) {
                                EVF.V("ORIGIN_CD", v.value);
                            }
                        });
                    }
                }
            }
        }

        function onError() {
            $(".ui-icon-circle-arrow-w").trigger("click");
        }

        function doClose() {
            EVF.closeWindow();
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
            EVF.V("MAKER_NM_CP", data.MKBR_NM);
        }

        function searchBrandCd(){
            var param = {
                callBackFunction: "selectBrandCd"
            };
            everPopup.openCommonPopup(param, "SP0088");
        }

        function selectBrandCd(data) {
            EVF.V("BRAND_CD", data.MKBR_CD);
            EVF.V("BRAND_NM_CP", data.MKBR_NM);
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

        function doSave() {
            var store = new EVF.Store();
            if(!store.validate()) { return; }

            EVF.confirm("${msg.M0011 }", function () {
                goApproval();
            });
        }

        function goApproval() {

            var store = new EVF.Store();
	        if(!store.validate()) { return; }
            store.doFileUpload(function() {
                store.setParameter("mainImgSq", $("#mainImgContainer").find("input[type=radio]:checked").prop("id"));

                store.load(baseUrl + "cita0031_doSave.so", function () {
	                if (opener != null) {
		                opener.doSearch();
	                }
                	doClose();
                });
            });
        }

    </script>
    <e:window id="CITA0031" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">
        <e:inputHidden id="BUYER_CD" name="BUYER_CD" value="${form.BUYER_CD}"/>
        <e:inputHidden id="DEPT_CD" name="DEPT_CD" value="${form.DEPT_CD}"/>

        <e:buttonBar align="right" width="100%" title="${CITA0031_CAPTION1}">
            <e:button id="doSave" name="doSave" label="${doSave_N}" onClick="doSave" disabled="${doSave_D}" visible="${doSave_V}"/>
        </e:buttonBar>

        <e:searchPanel id="form" title="${CITA0031_CAPTION1 }" labelWidth="${labelWidth}" width="100%" columnCount="3" useTitleBar="false" onEnter="doSearch">
            <e:row>
                <%-- 요청번호 --%>
                <e:label for="ITEM_REQ_NO" title="${form_ITEM_REQ_NO_N}" />
                <e:field>
                    <e:inputText id="ITEM_REQ_NO" name="ITEM_REQ_NO" value="${form.ITEM_REQ_NO}" width="${form_ITEM_REQ_NO_W}" maxLength="${form_ITEM_REQ_NO_M}" disabled="${form_ITEM_REQ_NO_D}" readOnly="${form_ITEM_REQ_NO_RO}" required="${form_ITEM_REQ_NO_R}" style="${imeMode}" maskType="${form_ITEM_REQ_NO_MT}"/>
                </e:field>
                <%-- 항번 --%>
                <e:label for="ITEM_REQ_SEQ" title="${form_ITEM_REQ_SEQ_N}"/>
                <e:field>
                    <e:inputNumber id="ITEM_REQ_SEQ" name="ITEM_REQ_SEQ" value="${form.ITEM_REQ_SEQ}" width="${form_ITEM_REQ_SEQ_W}" maxValue="${form_ITEM_REQ_SEQ_M}" decimalPlace="${form_ITEM_REQ_SEQ_NF}" disabled="${form_ITEM_REQ_SEQ_D}" readOnly="${form_ITEM_REQ_SEQ_RO}" required="${form_ITEM_REQ_SEQ_R}" onNumberKr="${form_ITEM_REQ_SEQ_KR}" currencyText="${form_ITEM_REQ_SEQ_CT}"/>
                </e:field>
                <%-- 요청부서 --%>
                <e:label for="DEPT_NM" title="${form_DEPT_NM_N}" />
                <e:field>
                    <e:inputText id="DEPT_NM" name="DEPT_NM" value="${form.DEPT_NM}" width="${form_DEPT_NM_W}" maxLength="${form_DEPT_NM_M}" disabled="${form_DEPT_NM_D}" readOnly="${form_DEPT_NM_RO}" required="${form_DEPT_NM_R}" style="${imeMode}" maskType="${form_DEPT_NM_MT}"/>
                </e:field>
            </e:row>
            <e:row>
                <%-- 품명 --%>
                <e:label for="ITEM_DESC" title="${form_ITEM_DESC_N}" />
                <e:field colSpan="3">
                    <e:inputText id="ITEM_DESC" name="ITEM_DESC" value="${form.ITEM_DESC}" width="${form_ITEM_DESC_W}" maxLength="${form_ITEM_DESC_M}" disabled="${form_ITEM_DESC_D}" readOnly="${form_ITEM_DESC_RO}" required="${form_ITEM_DESC_R}" style="${imeMode}" maskType="${form_ITEM_DESC_MT}"/>
                </e:field>
                <%-- 요청자 --%>
                <e:label for="REG_USER_INFO" title="${form_REG_USER_INFO_N}" />
                <e:field>
                    <e:inputText id="REG_USER_INFO" name="REG_USER_INFO" value="${form.REG_USER_INFO}" width="${form_REG_USER_INFO_W}" maxLength="${form_REG_USER_INFO_M}" disabled="${form_REG_USER_INFO_D}" readOnly="${form_REG_USER_INFO_RO}" required="${form_REG_USER_INFO_R}" style="${imeMode}" maskType="${form_REG_USER_INFO_MT}"/>
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
                <e:label for="MAKER_NM" title="${form_MAKER_NM_N}" />
                <e:field>
                    <e:inputText id="MAKER_NM" name="MAKER_NM" value="${form.MAKER_NM}" width="${form_MAKER_NM_W}" maxLength="${form_MAKER_NM_M}" disabled="${form_MAKER_NM_D}" readOnly="${form_MAKER_NM_RO}" required="${form_MAKER_NM_R}" style="${imeMode}" maskType="${form_MAKER_NM_MT}"/>
                </e:field>
                <%-- 모델번호 --%>
                <e:label for="MAKER_PART_NO" title="${form_MAKER_PART_NO_N}" />
                <e:field>
                    <e:inputText id="MAKER_PART_NO" name="MAKER_PART_NO" value="${form.MAKER_PART_NO}" width="${form_MAKER_PART_NO_W}" maxLength="${form_MAKER_PART_NO_M}" disabled="${form_MAKER_PART_NO_D}" readOnly="${form_MAKER_PART_NO_RO}" required="${form_MAKER_PART_NO_R}" style="${imeMode}" maskType="${form_MAKER_PART_NO_MT}"/>
                </e:field>
                <%-- 브랜드 --%>
                <e:label for="BRAND_NM" title="${form_BRAND_NM_N}" />
                <e:field>
                    <e:inputText id="BRAND_NM" name="BRAND_NM" value="${form.BRAND_NM}" width="${form_BRAND_NM_W}" maxLength="${form_BRAND_NM_M}" disabled="${form_BRAND_NM_D}" readOnly="${form_BRAND_NM_RO}" required="${form_BRAND_NM_R}" style="${imeMode}" maskType="${form_BRAND_NM_MT}"/>
                </e:field>
            </e:row>
            <e:row>
                <%-- 단위 --%>
                <e:label for="UNIT_CD" title="${form_UNIT_CD_N}"/>
                <e:field>
                    <e:select id="UNIT_CD" name="UNIT_CD" value="${form.UNIT_CD}" options="${unitCdOptions}" width="${form_UNIT_CD_W}" disabled="${form_UNIT_CD_D}" readOnly="${form_UNIT_CD_RO}" required="${form_UNIT_CD_R}" placeHolder="" maskType="${form_UNIT_CD_MT}" />
                </e:field>
                <%-- 원산지 --%>
                <e:label for="ORIGIN_NM" title="${form_ORIGIN_NM_N}" />
                <e:field>
                    <e:inputText id="ORIGIN_NM" name="ORIGIN_NM" value="${form.ORIGIN_NM}" width="${form_ORIGIN_NM_W}" maxLength="${form_ORIGIN_NM_M}" disabled="${form_ORIGIN_NM_D}" readOnly="${form_ORIGIN_NM_RO}" required="${form_ORIGIN_NM_R}" style="${imeMode}" maskType="${form_ORIGIN_NM_MT}"/>
                </e:field>
                <%-- 담당자정보 --%>
                <e:label for="PIC_USER_INFO" title="${form_PIC_USER_INFO_N}" />
                <e:field>
                    <e:inputText id="PIC_USER_INFO" name="PIC_USER_INFO" value="${form.PIC_USER_INFO}" width="${form_PIC_USER_INFO_W}" maxLength="${form_PIC_USER_INFO_M}" disabled="${form_PIC_USER_INFO_D}" readOnly="${form_PIC_USER_INFO_RO}" required="${form_PIC_USER_INFO_R}" style="${imeMode}" maskType="${form_PIC_USER_INFO_MT}"/>
                </e:field>
            </e:row>
            <e:row>
                <%-- 추가사양 --%>
                <e:label for="ITEM_REQ_RMK" title="${form_ITEM_REQ_RMK_N}"/>
                <e:field colSpan="5">
                    <e:textArea id="ITEM_REQ_RMK" name="ITEM_REQ_RMK" value="${form.ITEM_REQ_RMK}" height="100px" width="${form_ITEM_REQ_RMK_W}" maxLength="${form_ITEM_REQ_RMK_M}" disabled="${form_ITEM_REQ_RMK_D}" readOnly="${form_ITEM_REQ_RMK_RO}" required="${form_ITEM_REQ_RMK_R}" />
                </e:field>

            </e:row>
            <e:row>
                <%-- 첨부파일 --%>
                <e:label for="ATTACH_FILE_NO" title="${form_ATTACH_FILE_NO_N }" />
                <e:field colSpan="5">
                    <e:fileManager id="ATTACH_FILE_NO" name="ATTACH_FILE_NO" fileId="${form.ATTACH_FILE_NO}" downloadable="true" width="100%" bizType="NT" height="100px" readOnly="${form_ATTACH_FILE_NO_RO }" onBeforeRemove="onBeforeRemove" onError="onError" onFileClick="onFileClick" onSuccess="onSuccess" required="" fileExtension="${fileExtension}" />
                </e:field>
            </e:row>
            <e:row>
                <%-- 품목이미지 --%>
                <e:label for="IMG_UUID" title="${form_IMG_UUID_N}" />
                <e:field colSpan="5">
                    <e:fileManager id="IMG_UUID" name="IMG_UUID" fileId="${form.IMG_UUID}" bizType="IMG" width="100%" height="100px" readOnly="${form_IMG_UUID_RO}" required="${form_IMG_UUID_R}" onFileAdd="_doUpload" onSuccess="_setImages" onAfterRemove="_setImages" maxFileCount="4" onError="onError"/>
                </e:field>
            </e:row>
        </e:searchPanel>

        <e:buttonBar align="right" width="100%" title="${CITA0031_CAPTION2}">
            <e:button id="doCopy" name="doCopy" label="${doCopy_N}" onClick="doCopy" disabled="${doCopy_D}" visible="${doCopy_V}"/>
        </e:buttonBar>

        <e:searchPanel id="formcp" title="" labelWidth="${labelWidth}" width="100%" columnCount="3" useTitleBar="false">
            <e:row>
                <%-- 품목분류 --%>
                <e:label for="ITEM_CLS_NM" title="${formcp_ITEM_CLS_NM_N}" />
                <e:field colSpan="5">
                    <e:search id="ITEM_CLS_NM" name="ITEM_CLS_NM" value="" width="${formcp_ITEM_CLS_NM_W}" maxLength="${formcp_ITEM_CLS_NM_M}" onIconClick="_getItemClsNm" disabled="${formcp_ITEM_CLS_NM_D}" readOnly="${formcp_ITEM_CLS_NM_RO}" required="${formcp_ITEM_CLS_NM_R}"  maskType="${formcp_ITEM_CLS_NM_MT}" />
                    <e:inputHidden id="ITEM_CLS1" name="ITEM_CLS1" value=""/>
                    <e:inputHidden id="ITEM_CLS2" name="ITEM_CLS2" value=""/>
                    <e:inputHidden id="ITEM_CLS3" name="ITEM_CLS3" value=""/>
                    <e:inputHidden id="ITEM_CLS4" name="ITEM_CLS4" value=""/>
                </e:field>
            </e:row>
            <e:row>
                <%-- 품명 --%>
                <e:label for="ITEM_DESC_CP" title="${formcp_ITEM_DESC_CP_N}" />
                <e:field colSpan="3">
                    <e:inputText id="ITEM_DESC_CP" name="ITEM_DESC_CP" value="" width="${formcp_ITEM_DESC_CP_W}" maxLength="${formcp_ITEM_DESC_CP_M}" disabled="${formcp_ITEM_DESC_CP_D}" readOnly="${formcp_ITEM_DESC_CP_RO}" required="${formcp_ITEM_DESC_CP_R}" style="${imeMode}" maskType="${formcp_ITEM_DESC_CP_MT}"/>
                </e:field>
                <%-- 원산지 --%>
                <e:label for="ORIGIN_CD" title="${formcp_ORIGIN_CD_N}"/>
                <e:field>
                    <e:select id="ORIGIN_CD" name="ORIGIN_CD" value="" options="${originCdOptions}" width="${formcp_ORIGIN_CD_W}" disabled="${formcp_ORIGIN_CD_D}" readOnly="${formcp_ORIGIN_CD_RO}" required="${formcp_ORIGIN_CD_R}" placeHolder="" maskType="${formcp_ORIGIN_CD_MT}" />
                </e:field>
            </e:row>
            <e:row>
                <%-- 규격 --%>
                <e:label for="ITEM_SPEC_CP" title="${formcp_ITEM_SPEC_CP_N}" />
                <e:field colSpan="5">
                    <e:inputText id="ITEM_SPEC_CP" name="ITEM_SPEC_CP" value="" width="${formcp_ITEM_SPEC_CP_W}" maxLength="${formcp_ITEM_SPEC_CP_M}" disabled="${formcp_ITEM_SPEC_CP_D}" readOnly="${formcp_ITEM_SPEC_CP_RO}" required="${formcp_ITEM_SPEC_CP_R}" style="${imeMode}" maskType="${formcp_ITEM_SPEC_CP_MT}"/>
                </e:field>
            </e:row>
            <e:row>
                <%-- 제조사 --%>
                <e:label for="MAKER_CD" title="${formcp_MAKER_CD_N}"/>
                <e:field>
                    <e:search id="MAKER_CD" name="MAKER_CD"  value="" width="40%" maxLength="${formcp_MAKER_CD_M}" onIconClick="${formcp_MAKER_CD_D ? 'everCommon.blank' : 'searchMakerCd'}" disabled="${formcp_MAKER_CD_D}" readOnly="true" required="${formcp_MAKER_CD_R}"  maskType="${formcp_MAKER_CD_MT}" />
                    <e:inputText id="MAKER_NM_CP" name="MAKER_NM_CP" value="" width="60%" maxLength="${formcp_MAKER_NM_CP_M}" disabled="${formcp_MAKER_NM_CP_D}" readOnly="true" required="${formcp_MAKER_NM_CP_R}" maskType="${formcp_MAKER_NM_CP_MT}" />
                </e:field>
                <%-- 모델번호 --%>
                <e:label for="MAKER_PART_NO_CP" title="${formcp_MAKER_PART_NO_CP_N}" />
                <e:field>
                    <e:inputText id="MAKER_PART_NO_CP" name="MAKER_PART_NO_CP" value="${form.MAKER_PART_NO_CP}" width="${formcp_MAKER_PART_NO_CP_W}" maxLength="${formcp_MAKER_PART_NO_CP_M}" disabled="${formcp_MAKER_PART_NO_CP_D}" readOnly="${formcp_MAKER_PART_NO_CP_RO}" required="${formcp_MAKER_PART_NO_CP_R}" style="${imeMode}" maskType="${formcp_MAKER_PART_NO_CP_MT}"/>
                </e:field>
                <%-- 브랜드 --%>
                <e:label for="BRAND_CD" title="${formcp_BRAND_CD_N}"/>
                <e:field>
                    <e:search id="BRAND_CD" name="BRAND_CD"  value="" width="40%" maxLength="${formcp_BRAND_CD_M}" onIconClick="${formcp_BRAND_CD_D ? 'everCommon.blank' : 'searchBrandCd'}" disabled="${formcp_BRAND_CD_D}" readOnly="${formcp_BRAND_CD_RO}" required="${formcp_BRAND_CD_R}"  maskType="${formcp_BRAND_CD_MT}" />
                    <e:inputText id="BRAND_NM_CP" name="BRAND_NM_CP" value="" width="60%" maxLength="${formcp_BRAND_NM_CP_M}" disabled="${formcp_BRAND_NM_CP_D}" readOnly="${formcp_BRAND_NM_CP_RO}" required="${formcp_BRAND_NM_CP_R}" maskType="${formcp_BRAND_NM_CP_MT}" />
                </e:field>
            </e:row>
            <e:row>
                <%-- 단위 --%>
                <e:label for="UNIT_CD_CP" title="${formcp_UNIT_CD_CP_N}"/>
                <e:field>
                    <e:select id="UNIT_CD_CP" name="UNIT_CD_CP" value="" options="${unitCdOptions}" width="${formcp_UNIT_CD_CP_W}" disabled="${formcp_UNIT_CD_CP_D}" readOnly="${formcp_UNIT_CD_CP_RO}" required="${formcp_UNIT_CD_CP_R}" placeHolder="" maskType="${formcp_UNIT_CD_CP_MT}" />
                </e:field>
                <%-- 직발주여부 --%>
                <e:label for="DIRECT_PO_FLAG_CP" title="${formcp_DIRECT_PO_FLAG_CP_N}"/>
                <e:field>
                    <e:select id="DIRECT_PO_FLAG_CP" name="DIRECT_PO_FLAG_CP" value="" options="${directPoFlagCpOptions}" width="${formcp_DIRECT_PO_FLAG_CP_W}" disabled="${formcp_DIRECT_PO_FLAG_CP_D}" readOnly="${formcp_DIRECT_PO_FLAG_CP_RO}" required="${formcp_DIRECT_PO_FLAG_CP_R}" placeHolder="" maskType="${formcp_DIRECT_PO_FLAG_CP_MT}" />
                </e:field>
                <%-- 대표품목여부 --%>
                <e:label for="MAJOR_ITEM_FLAG_CP" title="${formcp_MAJOR_ITEM_FLAG_CP_N}"/>
                <e:field>
                    <e:select id="MAJOR_ITEM_FLAG_CP" name="MAJOR_ITEM_FLAG_CP" value="" options="${majorItemFlagCpOptions}" width="${formcp_MAJOR_ITEM_FLAG_CP_W}" disabled="${formcp_MAJOR_ITEM_FLAG_CP_D}" readOnly="${formcp_MAJOR_ITEM_FLAG_CP_RO}" required="${formcp_MAJOR_ITEM_FLAG_CP_R}" placeHolder="" maskType="${formcp_MAJOR_ITEM_FLAG_CP_MT}" />
                </e:field>
            </e:row>
            <e:row>
                <%-- 추가사양 --%>
                <e:label for="ITEM_RMK" title="${formcp_ITEM_RMK_N}"/>
                <e:field colSpan="5">
                    <e:textArea id="ITEM_RMK" name="ITEM_RMK" value="" height="100px" width="${formcp_ITEM_RMK_W}" maxLength="${formcp_ITEM_RMK_M}" disabled="${formcp_ITEM_RMK_D}" readOnly="${formcp_ITEM_RMK_RO}" required="${formcp_ITEM_RMK_R}" />
                </e:field>
            </e:row>
            <e:row>
                <%-- 첨부파일 --%>
                <e:label for="ATT_FILE_NUM" title="${formcp_ATT_FILE_NUM_N }" />
                <e:field colSpan="5">
                    <e:fileManager id="ATT_FILE_NUM" name="ATT_FILE_NUM" fileId="" downloadable="true" width="100%" bizType="NT" height="100px" readOnly="${formcp_ATT_FILE_NUM_RO }" onBeforeRemove="onBeforeRemove" onError="onError" onFileClick="onFileClick" onSuccess="onSuccess" required="" fileExtension="${fileExtension}" />
                </e:field>
            </e:row>
        </e:searchPanel>

        <e:searchPanel id="searchPanel2" title="" labelWidth="${labelWidth}" width="100%" height="150px" columnCount="3" useTitleBar="false">
            <e:row>
                <e:field colSpan="2">
                    <e:fileManager id="IMG_ATT_FILE_NUM" name="IMG_ATT_FILE_NUM" fileId="" bizType="IMG" width="100%" height="150px" readOnly="${formcp_IMG_ATT_FILE_NUM_RO}" required="${formcp_IMG_ATT_FILE_NUM_R}" onFileAdd="_doUpload" onSuccess="_setImages" onAfterRemove="_setImages" maxFileCount="4" onError="onError"/>
                </e:field>
                <e:field colSpan="4">
                    <div id="mainImgContainer" style="width: 100%; height: 100%;"></div>
                    <e:inputHidden id="MAIN_IMG_SQ" name="MAIN_IMG_SQ" value="" />
                </e:field>
            </e:row>
        </e:searchPanel>

        <e:buttonBar align="right" width="100%">
            <e:button id="doClose" name="doClose" label="${doClose_N}" onClick="doClose" disabled="${doClose_D}" visible="${doClose_V}"/>
        </e:buttonBar>
    </e:window>
</e:ui>