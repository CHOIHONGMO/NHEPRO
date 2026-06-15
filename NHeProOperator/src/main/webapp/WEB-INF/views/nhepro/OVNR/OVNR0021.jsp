<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
    <script type="text/javascript">
        var baseUrl = "/nhepro/OVNR/";

        function init() {
            onChangeBLOCK_FLAG();
        }

        function onChangeBLOCK_FLAG() {
            if(EVF.V("BLOCK_FLAG") == "1") {
                EVF.C("BLOCK_REASON").setRequired(true);
            } else {
                EVF.C("BLOCK_REASON").setRequired(false);
                EVF.V("BLOCK_REASON", "");
            }
        }

        function doSave() {
            var store = new EVF.Store();
            if(!store.validate()) return;

            EVF.confirm("${msg.M0021 }", function () {
                store.doFileUpload(function () {
                    store.load(baseUrl + "ovnr0021_doSave.so", function () {
                        var userId = this.getParameter("USER_ID");

                        EVF.alert(this.getResponseMessage(), function () {
                            location.href = baseUrl + "OVNR0021/view.so?USER_ID=" + userId + "&detailView=false";
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
                store.load(baseUrl + "ovnr0021_doDelete.so", function () {
                    EVF.alert(this.getResponseMessage(), function() {
                        if (opener != null) {
                            opener.doSearch();
                        }
                        doClose();
                    });
                });
            });
        }

        function doPasswordInit() {
            EVF.confirm("${OVNR0021_001}", function() {
                var store = new EVF.Store();
                store.load(baseUrl + 'ovnr0021_doPasswordInit.so', function() {
                    var userId = this.getParameter("USER_ID");

                    EVF.alert(this.getResponseMessage(), function () {
                        location.href = baseUrl + "OVNR0021/view.so?USER_ID=" + userId + "&detailView=false";
                    });
                });
            });
        }

        function doClose() {
            EVF.closeWindow();
        }
    </script>

    <e:window id="OVNR0021" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">
        <e:searchPanel id="sp" title="" labelWidth="${labelWidth}" useTitleBar="false" width="100%" columnCount="2">
            <e:row>
                <e:label for="COMPANY_CD" title="${form_COMPANY_CD_N}" />
                <e:field>
                    <e:inputText id="COMPANY_CD" name="COMPANY_CD" value="${formData.COMPANY_CD}" width="${form_COMPANY_CD_W}" maxLength="${form_COMPANY_CD_M}" disabled="${form_COMPANY_CD_D}" readOnly="${form_COMPANY_CD_RO}" required="${form_COMPANY_CD_R}" style="${imeMode}" maskType="${form_COMPANY_CD_MT}"/>
                </e:field>
                <e:label for="COMPANY_NM" title="${form_COMPANY_NM_N}" />
                <e:field>
                    <e:inputText id="COMPANY_NM" name="COMPANY_NM" value="${formData.COMPANY_NM}" width="${form_COMPANY_NM_W}" maxLength="${form_COMPANY_NM_M}" disabled="${form_COMPANY_NM_D}" readOnly="${form_COMPANY_NM_RO}" required="${form_COMPANY_NM_R}" style="${imeMode}" maskType="${form_COMPANY_NM_MT}"/>
                </e:field>
            </e:row>
            <e:row>
                <e:label for="USER_ID" title="${form_USER_ID_N}" />
                <e:field>
                    <e:inputText id="USER_ID" name="USER_ID" value="${formData.USER_ID}" width="${form_USER_ID_W}" maxLength="${form_USER_ID_M}" disabled="${form_USER_ID_D}" readOnly="${form_USER_ID_RO}" required="${form_USER_ID_R}" style="${imeMode}" maskType="${form_USER_ID_MT}"/>
                </e:field>
                <e:label for="USER_NM" title="${form_USER_NM_N}" />
                <e:field>
                    <e:inputText id="USER_NM" name="USER_NM" value="${formData.USER_NM}" width="${form_USER_NM_W}" maxLength="${form_USER_NM_M}" disabled="${form_USER_NM_D}" readOnly="${form_USER_NM_RO}" required="${form_USER_NM_R}" style="${imeMode}" maskType="${form_USER_NM_MT}"/>
                </e:field>
            </e:row>
            <e:row>
                <e:label for="PASSWORD" title="${form_PASSWORD_N}" />
                <e:field>
                    <e:inputText id="PASSWORD" name="PASSWORD" value="********" width="${form_PASSWORD_W}" maxLength="${form_PASSWORD_M}" disabled="${form_PASSWORD_D}" readOnly="${form_PASSWORD_RO}" required="${form_PASSWORD_R}" style="${imeMode}" maskType="${form_PASSWORD_MT}"/>
                </e:field>
                <e:label for="PASSWORD2" title="${form_PASSWORD2_N}" />
                <e:field>
                    <e:inputText id="PASSWORD2" name="PASSWORD2" value="********" width="${form_PASSWORD2_W}" maxLength="${form_PASSWORD2_M}" disabled="${form_PASSWORD2_D}" readOnly="${form_PASSWORD2_RO}" required="${form_PASSWORD2_R}" style="${imeMode}" maskType="${form_PASSWORD2_MT}"/>
                </e:field>
            </e:row>
            <e:row>
                <e:label for="DEPT_NM" title="${form_DEPT_NM_N}" />
                <e:field>
                    <e:inputText id="DEPT_NM" name="DEPT_NM" value="${formData.DEPT_NM}" width="${form_DEPT_NM_W}" maxLength="${form_DEPT_NM_M}" disabled="${form_DEPT_NM_D}" readOnly="${form_DEPT_NM_RO}" required="${form_DEPT_NM_R}" style="${imeMode}" maskType="${form_DEPT_NM_MT}"/>
                </e:field>
                <e:label for="MNG_YN_NM" title="${form_MNG_YN_NM_N}" />
                <e:field>
                    <e:inputText id="MNG_YN_NM" name="MNG_YN_NM" value="${formData.MNG_YN_NM}" width="${form_MNG_YN_NM_W}" maxLength="${form_MNG_YN_NM_M}" disabled="${form_MNG_YN_NM_D}" readOnly="${form_MNG_YN_NM_RO}" required="${form_MNG_YN_NM_R}" style="${imeMode}" maskType="${form_MNG_YN_NM_MT}"/>
                </e:field>
            </e:row>
            <e:row>
                <e:label for="POSITION_NM" title="${form_POSITION_NM_N}" />
                <e:field>
                    <e:inputText id="POSITION_NM" name="POSITION_NM" value="${formData.POSITION_NM}" width="${form_POSITION_NM_W}" maxLength="${form_POSITION_NM_M}" disabled="${form_POSITION_NM_D}" readOnly="${form_POSITION_NM_RO}" required="${form_POSITION_NM_R}" style="${imeMode}" maskType="${form_POSITION_NM_MT}"/>
                </e:field>
                <e:label for="DUTY_NM" title="${form_DUTY_NM_N}" />
                <e:field>
                    <e:inputText id="DUTY_NM" name="DUTY_NM" value="${formData.DUTY_NM}" width="${form_DUTY_NM_W}" maxLength="${form_DUTY_NM_M}" disabled="${form_DUTY_NM_D}" readOnly="${form_DUTY_NM_RO}" required="${form_DUTY_NM_R}" style="${imeMode}" maskType="${form_DUTY_NM_MT}"/>
                </e:field>
            </e:row>
            <e:row>
                <e:label for="TEL_NUM" title="${form_TEL_NUM_N}" />
                <e:field>
                    <e:inputText id="TEL_NUM" name="TEL_NUM" value="${formData.TEL_NUM}" width="${form_TEL_NUM_W}" maxLength="${form_TEL_NUM_M}" disabled="${form_TEL_NUM_D}" readOnly="${form_TEL_NUM_RO}" required="${form_TEL_NUM_R}" style="${imeMode}" maskType="${form_TEL_NUM_MT}"/>
                </e:field>
                <e:label for="FAX_NUM" title="${form_FAX_NUM_N}" />
                <e:field>
                    <e:inputText id="FAX_NUM" name="FAX_NUM" value="${formData.FAX_NUM}" width="${form_FAX_NUM_W}" maxLength="${form_FAX_NUM_M}" disabled="${form_FAX_NUM_D}" readOnly="${form_FAX_NUM_RO}" required="${form_FAX_NUM_R}" style="${imeMode}" maskType="${form_FAX_NUM_MT}"/>
                </e:field>
            </e:row>
            <e:row>
                <e:label for="ZIP_CD" title="${form_ZIP_CD_N}" />
                <e:field>
                    <e:inputText id="ZIP_CD" name="ZIP_CD" value="${formData.ZIP_CD}" width="${form_ZIP_CD_W}" maxLength="${form_ZIP_CD_M}" disabled="${form_ZIP_CD_D}" readOnly="${form_ZIP_CD_RO}" required="${form_ZIP_CD_R}" style="${imeMode}" maskType="${form_ZIP_CD_MT}"/>
                </e:field>
                <e:label for="ADDR_1" title="${form_ADDR_1_N}" />
                <e:field>
                    <e:inputText id="ADDR_1" name="ADDR_1" value="${formData.ADDR_1}" width="${form_ADDR_1_W}" maxLength="${form_ADDR_1_M}" disabled="${form_ADDR_1_D}" readOnly="${form_ADDR_1_RO}" required="${form_ADDR_1_R}" style="${imeMode}" maskType="${form_ADDR_1_MT}"/>
                </e:field>
            </e:row>
            <e:row>
                <e:label for="ADDR_2" title="${form_ADDR_2_N}" />
                <e:field colSpan="3">
                    <e:inputText id="ADDR_2" name="ADDR_2" value="${formData.ADDR_2}" width="${form_ADDR_2_W}" maxLength="${form_ADDR_2_M}" disabled="${form_ADDR_2_D}" readOnly="${form_ADDR_2_RO}" required="${form_ADDR_2_R}" style="${imeMode}" maskType="${form_ADDR_2_MT}"/>
                </e:field>
            </e:row>
            <e:row>
                <e:label for="CELL_NUM" title="${form_CELL_NUM_N}" />
                <e:field>
                    <e:inputText id="CELL_NUM" name="CELL_NUM" value="${formData.CELL_NUM}" width="${form_CELL_NUM_W}" maxLength="${form_CELL_NUM_M}" disabled="${form_CELL_NUM_D}" readOnly="${form_CELL_NUM_RO}" required="${form_CELL_NUM_R}" style="${imeMode}" maskType="${form_CELL_NUM_MT}"/>
                </e:field>
                <e:label for="EMAIL" title="${form_EMAIL_N}" />
                <e:field>
                    <e:inputText id="EMAIL" name="EMAIL" value="${formData.EMAIL}" width="${form_EMAIL_W}" maxLength="${form_EMAIL_M}" disabled="${form_EMAIL_D}" readOnly="${form_EMAIL_RO}" required="${form_EMAIL_R}" style="${imeMode}" maskType="${form_EMAIL_MT}"/>
                </e:field>
            </e:row>
            <e:row>
                <e:label for="SMS_FLAG_NM" title="${form_SMS_FLAG_NM_N}" />
                <e:field>
                    <e:inputText id="SMS_FLAG_NM" name="SMS_FLAG_NM" value="${formData.SMS_FLAG_NM}" width="${form_SMS_FLAG_NM_W}" maxLength="${form_SMS_FLAG_NM_M}" disabled="${form_SMS_FLAG_NM_D}" readOnly="${form_SMS_FLAG_NM_RO}" required="${form_SMS_FLAG_NM_R}" style="${imeMode}" maskType="${form_SMS_FLAG_NM_MT}"/>
                </e:field>
                <e:label for="MAIL_FLAG_NM" title="${form_MAIL_FLAG_NM_N}" />
                <e:field>
                    <e:inputText id="MAIL_FLAG_NM" name="MAIL_FLAG_NM" value="${formData.MAIL_FLAG_NM}" width="${form_MAIL_FLAG_NM_W}" maxLength="${form_MAIL_FLAG_NM_M}" disabled="${form_MAIL_FLAG_NM_D}" readOnly="${form_MAIL_FLAG_NM_RO}" required="${form_MAIL_FLAG_NM_R}" style="${imeMode}" maskType="${form_MAIL_FLAG_NM_MT}"/>
                </e:field>
            </e:row>
            <e:row>
                <e:label for="BLOCK_FLAG" title="${form_BLOCK_FLAG_N}"/>
                <e:field>
                    <e:select id="BLOCK_FLAG" name="BLOCK_FLAG" value="${formData.BLOCK_FLAG}" options="${blockFlagOptions}" onChange="onChangeBLOCK_FLAG" width="${form_BLOCK_FLAG_W}" disabled="${form_BLOCK_FLAG_D}" readOnly="${form_BLOCK_FLAG_RO}" required="${form_BLOCK_FLAG_R}" placeHolder="" usePlaceHolder="false" maskType="${form_BLOCK_FLAG_MT}" />
                </e:field>
                <e:label for="BLOCK_REASON" title="${form_BLOCK_REASON_N}" />
                <e:field>
                    <e:inputText id="BLOCK_REASON" name="BLOCK_REASON" value="${formData.BLOCK_REASON}" width="${form_BLOCK_REASON_W}" maxLength="${form_BLOCK_REASON_M}" disabled="${form_BLOCK_REASON_D}" readOnly="${form_BLOCK_REASON_RO}" required="${form_BLOCK_REASON_R}" style="${imeMode}" maskType="${form_BLOCK_REASON_MT}"/>
                </e:field>
            </e:row>
        </e:searchPanel>

        <e:buttonBar width="100%" align="right">
            <e:button id="doSave" name="doSave" label="${doSave_N}" onClick="doSave" disabled="${doSave_D}" visible="${doSave_V}"/>
            <e:button id="doDelete" name="doDelete" label="${doDelete_N}" onClick="doDelete" disabled="${doDelete_D}" visible="${doDelete_V}"/>
            <e:button id="doPasswordInit" name="doPasswordInit" label="${doPasswordInit_N}" onClick="doPasswordInit" disabled="${doPasswordInit_D}" visible="${doPasswordInit_V}"/>
            <e:button id="doClose" name="doClose" label="${doClose_N}" onClick="doClose" disabled="${doClose_D}" visible="${doClose_V}"/>
        </e:buttonBar>

    </e:window>
</e:ui>
