<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">

    <script type="text/javascript">

        var baseUrl = "/nhepro/CITI/CITA0021/";

        function init() {
            if(EVF.V("PROGRESS_CD") == "100" || EVF.V("PROGRESS_CD") == "300") {
                EVF.C("DEL_REQ_REASON").setReadOnly(false);
            }
        }

        function doRequest() {

            if (EVF.V("RE_REQ_REASON") == "") {
                EVF.C("RE_REQ_REASON").setRequired(true);
            }

            var store = new EVF.Store();
            if(!store.validate()) { return; }
            EVF.confirm("${msg.M0053}", function () {
                store.doFileUpload(function() {
                    store.load(baseUrl + "cita0021_doRequest.so", function() {
                        EVF.alert("${msg.M0122}", function() {
                            if (opener != null) {
                                opener.doSearch();
                            }
                            doClose();
                        });
                    });
                });
            });
        }

        function doDelete() {

            if(EVF.V("DEL_REQ_REASON") == "") {
                EVF.C("DEL_REQ_REASON").setRequired(true);
            }

            var store = new EVF.Store();
            if(!store.validate()) return;
            EVF.confirm("${msg.M0013 }", function () {
                store.load(baseUrl + "cita0021_doDelete.so", function() {
                    if (opener != null) {
                        opener.doSearch();
                    }
                    doClose();
                });
            });
        }

        function onError() {
            $(".ui-icon-circle-arrow-w").trigger("click");
        }

        function doClose() {
            EVF.closeWindow();
        }

    </script>
    <e:window id="CITA0021" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">
        <e:inputHidden id="BUYER_CD" name="BUYER_CD" value="${form.BUYER_CD}"/>
        <e:inputHidden id="DEPT_CD" name="DEPT_CD" value="${form.DEPT_CD}"/>
        <e:inputHidden id="ITEM_REQ_NO" name="ITEM_REQ_NO" value="${form.ITEM_REQ_NO}"/>
        <e:inputHidden id="ITEM_REQ_SEQ" name="ITEM_REQ_SEQ" value="${form.ITEM_REQ_SEQ}"/>

        <e:searchPanel id="form" title="${form_CAPTION_N }" labelWidth="${labelWidth}" width="100%" columnCount="3" useTitleBar="false" onEnter="doSearch">
            <e:row>
                <%-- 진행상태 --%>
                <e:label for="PROGRESS_CD" title="${form_PROGRESS_CD_N}"/>
                <e:field>
                    <e:select id="PROGRESS_CD" name="PROGRESS_CD" value="${form.PROGRESS_CD}" options="${progressCdOptions}" width="${form_PROGRESS_CD_W}" disabled="${form_PROGRESS_CD_D}" readOnly="${form_PROGRESS_CD_RO}" required="${form_PROGRESS_CD_R}" placeHolder="" maskType="${form_PROGRESS_CD_MT}" />
                </e:field>
                <%-- 요청번호/항번 --%>
                <e:label for="ITEM_REQ_INFO" title="${form_ITEM_REQ_INFO_N}" />
                <e:field>
                    <e:inputText id="ITEM_REQ_INFO" name="ITEM_REQ_INFO" value="${form.ITEM_REQ_INFO}" width="${form_ITEM_REQ_INFO_W}" maxLength="${form_ITEM_REQ_INFO_M}" disabled="${form_ITEM_REQ_INFO_D}" readOnly="${form_ITEM_REQ_INFO_RO}" required="${form_ITEM_REQ_INFO_R}" style="${imeMode}" maskType="${form_ITEM_REQ_INFO_MT}"/>
                </e:field>
                <%-- 품목코드 --%>
                <e:label for="ITEM_CD" title="${form_ITEM_CD_N}" />
                <e:field>
                    <e:inputText id="ITEM_CD" name="ITEM_CD" value="${form.ITEM_CD}" width="${form_ITEM_CD_W}" maxLength="${form_ITEM_CD_M}" disabled="${form_ITEM_CD_D}" readOnly="${form_ITEM_CD_RO}" required="${form_ITEM_CD_R}" style="${imeMode}" maskType="${form_ITEM_CD_MT}"/>
                </e:field>
            </e:row>
            <e:row>
                <%-- 품명 --%>
                <e:label for="ITEM_DESC" title="${form_ITEM_DESC_N}" />
                <e:field colSpan="3">
                    <e:inputText id="ITEM_DESC" name="ITEM_DESC" value="${form.ITEM_DESC}" width="${form_ITEM_DESC_W}" maxLength="${form_ITEM_DESC_M}" disabled="${form_ITEM_DESC_D}" readOnly="${form_ITEM_DESC_RO}" required="${form_ITEM_DESC_R}" style="${imeMode}" maskType="${form_ITEM_DESC_MT}"/>
                </e:field>
                <%-- 원산지 --%>
                <e:label for="ORIGIN_NM" title="${form_ORIGIN_NM_N}" />
                <e:field>
                    <e:inputText id="ORIGIN_NM" name="ORIGIN_NM" value="${form.ORIGIN_NM}" width="${form_ORIGIN_NM_W}" maxLength="${form_ORIGIN_NM_M}" disabled="${form_ORIGIN_NM_D}" readOnly="${form_ORIGIN_NM_RO}" required="${form_ORIGIN_NM_R}" style="${imeMode}" maskType="${form_ORIGIN_NM_MT}"/>
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
                <%-- 요청자정보 --%>
                <e:label for="REG_USER_INFO" title="${form_REG_USER_INFO_N}" />
                <e:field>
                    <e:inputText id="REG_USER_INFO" name="REG_USER_INFO" value="${form.REG_USER_INFO}" width="${form_REG_USER_INFO_W}" maxLength="${form_REG_USER_INFO_M}" disabled="${form_REG_USER_INFO_D}" readOnly="${form_REG_USER_INFO_RO}" required="${form_REG_USER_INFO_R}" style="${imeMode}" maskType="${form_REG_USER_INFO_MT}"/>
                </e:field>
                <%-- 요청자연락처 --%>
                <e:label for="REG_USER_TEL_NUM" title="${form_REG_USER_TEL_NUM_N}" />
                <e:field>
                    <e:inputText id="REG_USER_TEL_NUM" name="REG_USER_TEL_NUM" value="${form.REG_USER_TEL_NUM}" width="${form_REG_USER_TEL_NUM_W}" maxLength="${form_REG_USER_TEL_NUM_M}" disabled="${form_REG_USER_TEL_NUM_D}" readOnly="${form_REG_USER_TEL_NUM_RO}" required="${form_REG_USER_TEL_NUM_R}" style="${imeMode}" maskType="${form_REG_USER_TEL_NUM_MT}"/>
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
                    <e:fileManager id="ATTACH_FILE_NO" name="ATTACH_FILE_NO" fileId="${form.ATTACH_FILE_NO}" downloadable="true" width="100%" bizType="NT" height="100px" readOnly="${!param.detailView ? false : true }" onBeforeRemove="onBeforeRemove" onError="onError" onFileClick="onFileClick" onSuccess="onSuccess" required="" fileExtension="${fileExtension}" />
                </e:field>
            </e:row>
            <e:row>
                <%-- 품목이미지 --%>
                <e:label for="IMG_UUID" title="${form_IMG_UUID_N}" />
                <e:field colSpan="5">
                    <e:fileManager id="IMG_UUID" name="IMG_UUID" fileId="${form.IMG_UUID}" bizType="IMG" width="100%" height="100px" readOnly="${form_IMG_UUID_RO}" required="${form_IMG_UUID_R}" onFileAdd="_doUpload" onSuccess="_setImages" onAfterRemove="_setImages" maxFileCount="4" onError="onError"/>
                </e:field>
            </e:row>
            <e:row>
                <%-- 회신사유 --%>
                <e:label for="RE_REQ_REASON" title="${form_RE_REQ_REASON_N}"/>
                <e:field colSpan="5">
                    <e:textArea id="RE_REQ_REASON" name="RE_REQ_REASON" value="${form.RE_REQ_REASON}" height="100px" width="${form_RE_REQ_REASON_W}" maxLength="${form_RE_REQ_REASON_M}" disabled="${form_RE_REQ_REASON_D}" readOnly="${form_RE_REQ_REASON_RO}" required="${form_RE_REQ_REASON_R}" />
                </e:field>
            </e:row>
            <e:row>
                <%-- 삭제사유 --%>
                <e:label for="DEL_REQ_REASON" title="${form_DEL_REQ_REASON_N}"/>
                <e:field colSpan="5">
                    <e:textArea id="DEL_REQ_REASON" name="DEL_REQ_REASON" value="${form.DEL_REQ_REASON}" height="100px" width="${form_DEL_REQ_REASON_W}" maxLength="${form_DEL_REQ_REASON_M}" disabled="${form_DEL_REQ_REASON_D}" readOnly="${form_DEL_REQ_REASON_RO}" required="${form_DEL_REQ_REASON_R}" />
                </e:field>
            </e:row>
        </e:searchPanel>

        <e:buttonBar align="right" width="100%">
            <e:button id="doRequest" name="doRequest" label="${doRequest_N}" onClick="doRequest" disabled="${doRequest_D}" visible="${doRequest_V}"/>
            <e:button id="doDelete" name="doDelete" label="${doDelete_N}" onClick="doDelete" disabled="${form.PROGRESS_CD eq '100' or form.PROGRESS_CD eq '300' ? false : true}" visible="${form.PROGRESS_CD eq '100' or form.PROGRESS_CD eq '300' ? true : false}"/>
            <e:button id="doClose" name="doClose" label="${doClose_N}" onClick="doClose" disabled="${doClose_D}" visible="${doClose_V}"/>
        </e:buttonBar>

    </e:window>
</e:ui>