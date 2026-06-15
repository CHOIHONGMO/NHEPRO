<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
    <script type="text/javascript">
        var baseUrl = "/nhepro/SETR/";

        function init() {
            var editor = EVF.C("NOTICE_CONTENTS").getInstance();
            editor.config.contentsCss  = "/css/richText.css";
            editor.config.allowedContent = true;
        }

        function doSave() {
            var store = new EVF.Store();
            if(!store.validate()) return;

            if( EVF.isEmpty(EVF.V("START_DATE")) ) {
                return EVF.alert("${SETR0021_003 }");
            }
            if( EVF.isEmpty(EVF.V("NOTICE_CONTENTS")) ) {
                return EVF.alert("${SETR0021_002 }");
            }
            if( EVF.V("ANN_FLAG") == "1" && EVF.V("USER_TYPE") != "USNA" ) {
                return EVF.alert("${SETR0021_006 }");
            }

            EVF.confirm("${msg.M0021 }", function () {
                store.doFileUpload(function () {
                    store.load(baseUrl + "setr0021_doSave.so", function () {
                        var pNoticeNum = this.getParameter("NOTICE_NUM");

                        EVF.alert(this.getResponseMessage(), function() {
                            location.href = baseUrl + "SETR0021/view.so?NOTICE_NUM=" + pNoticeNum + "&detailView=false";
                            if (opener != null) {
                                opener.doSearch();
                            }
                        });
                    });
                });
            });
        }

        function doDelete() {
            var store = new EVF.Store();
            EVF.confirm("${msg.M0013 }", function () {
                store.load(baseUrl + "setr0021_doDelete.so", function () {
                    EVF.alert(this.getResponseMessage(), function() {
                        if (opener != null) {
                            opener.doSearch();
                        }
                        doClose()
                    });
                });
            });
        }

        function doClear() {
            EVF.confirm("${SETR0021_005 }", function () {
                location.href = baseUrl + "SETR0021/view.so?NOTICE_NUM=&detailView=false";
            });
        }

        function doClose(){
            EVF.closeWindow();
        }

    </script>

    <e:window id="SETR0021" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">
        <e:searchPanel id="form" useTitleBar="false" title="${form_CAPTION_N }" labelWidth="${longLabelWidth}" width="100%" columnCount="2">
            <e:row>
                <e:label for="SUBJECT" title="${form_SUBJECT_N }" />
                <e:field colSpan="3">
                    <e:inputText id="SUBJECT" name="SUBJECT" value="${formData.SUBJECT }" maxLength="${form_SUBJECT_M}" width="${form_SUBJECT_W }" required="${form_SUBJECT_R }" readOnly="${form_SUBJECT_RO }" disabled="${form_SUBJECT_D }"  maskType="${form_SUBJECT_MT}" />
                    <e:inputHidden id="NOTICE_NUM" name="NOTICE_NUM" value="${formData.NOTICE_NUM }" />
                    <e:inputHidden id="NOTICE_TEXT_NUM" name="NOTICE_TEXT_NUM" value="${formData.NOTICE_TEXT_NUM }" />
                </e:field>
            </e:row>
            <e:row>
                <e:label for="START_DATE" title="${form_START_DATE_N}" />
                <e:field>
                    <e:inputDate id="START_DATE" toDate="END_DATE" name="START_DATE" value="${formData.START_DATE }" width="${inputDateWidth }" datePicker="true" required="${form_START_DATE_R}" disabled="${form_START_DATE_D}" readOnly="${form_START_DATE_RO}" />
                    <e:text>~&nbsp;</e:text>
                    <e:inputDate id="END_DATE" fromDate="START_DATE" name="END_DATE" value="${formData.END_DATE }" width="${inputDateWidth }" datePicker="true" required="${form_END_DATE_R}" disabled="${form_END_DATE_D}" readOnly="${form_END_DATE_RO}" />
                </e:field>
                <e:label for="REG_USER_NM" title="${form_REG_USER_NM_N }" />
                <e:field>
                    <e:inputDate id="REG_DATE" name="REG_DATE" value="${formData.REG_DATE }" width="${inputDateWidth}" datePicker="true" required="${form_REG_DATE_R}" disabled="${form_REG_DATE_D}" readOnly="${form_REG_DATE_RO}" />
                    <e:inputText id="REG_USER_NM" name="REG_USER_NM" value="${formData.REG_USER_NM }" width="${form_REG_USER_NM_W}" maxLength="${form_REG_USER_NM_M}" disabled="${form_REG_USER_NM_D}" readOnly="${form_REG_USER_NM_RO}" required="${form_REG_USER_NM_R}" style="${imeMode}" maskType="${form_REG_USER_NM_MT}"/>
                </e:field>
            </e:row>
            <e:row>
                <e:label for="NOTICE_CONTENTS" title="${form_NOTICE_CONTENTS_N }" />
                <e:field colSpan="3">
                    <e:richTextEditor id="NOTICE_CONTENTS" name="NOTICE_CONTENTS" width="${form_NOTICE_CONTENTS_W }" height="380px" required="${form_NOTICE_CONTENTS_R }" readOnly="${form_NOTICE_CONTENTS_RO }" disabled="${form_NOTICE_CONTENTS_D }" value="${formData.NOTICE_CONTENTS }" useToolbar="${!param.detailView}" />
                </e:field>
            </e:row>
            <e:row>
                <e:label for="ATT_FILE_NUM" title="${form_ATT_FILE_NUM_N }" />
                <e:field colSpan="3">
                    <e:fileManager id="ATT_FILE_NUM" name="ATT_FILE_NUM" fileId="${formData.ATT_FILE_NUM}" downloadable="true" width="100%" bizType="NT" height="150px" readOnly="${!param.detailView ? false : true }" onBeforeRemove="onBeforeRemove" onError="onError" onFileClick="onFileClick" onSuccess="onSuccess" required="" fileExtension="${fileExtension}" />
                </e:field>
            </e:row>
        </e:searchPanel>

        <e:buttonBar id="buttonBar" align="right" width="100%">
            <e:button id="doClose" name="doClose" label="${doClose_N}" onClick="doClose" disabled="${doClose_D}" visible="${doClose_V}"/>
        </e:buttonBar>
    </e:window>
</e:ui>