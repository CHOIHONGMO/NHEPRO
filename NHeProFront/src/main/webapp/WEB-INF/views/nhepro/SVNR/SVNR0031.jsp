<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
    <script type="text/javascript">
        var baseUrl = "/nhepro/SVNR/";
        var newCreateFlag = ${param.USER_ID==""?true:false};

        function init() {
            if(newCreateFlag) {
                EVF.C("USER_ID").setReadOnly(false);
                EVF.C("doDupChkUserId").setDisabled(false);
                EVF.C("PASSWORD").setRequired(true);
                EVF.C("PASSWORD2").setRequired(true);

                EVF.V("MNG_YN", "0");
                EVF.V("BLOCK_FLAG", "0");
                EVF.V("SMS_FLAG", "0");
                EVF.V("MAIL_FLAG", "0");
                EVF.V("USER_ID", "");
                EVF.V("PASSWORD", "");
            }
            else {
                EVF.C("USER_ID").setReadOnly(true);
                EVF.C("doDupChkUserId").setDisabled(true);
                EVF.C("PASSWORD").setRequired(false);
                EVF.C("PASSWORD2").setRequired(false);
            }
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
		
        //2021.05.14 금지어 체크 추가
        function onChangeUSER_ID() {

            var userId = EVF.V("USER_ID").toUpperCase();
            if(userId != "") {
                EVF.V("DUP_CHECK_ID_YN", "N");

                if(!everString.isChkId(userId)) {
                    EVF.alert("${msg.ID_INVALID}", function () {
                        EVF.C("USER_ID").setFocus();
                    });
                } else {
                    EVF.C("USER_ID").setValue(userId);
                }
            }
            
			var map = everString.Injection(userId);
            
            if(map.success) {
            } else {
                EVF.alert(map.msg, function () {
                	EVF.C("USER_ID").setValue("");
                	EVF.C("USER_ID").setFocus();
                });
            }
        }
		
      	//2021.03.17 비밀번호 입력시 '%' 특수문자 입력 불가하도록 체크 추가
      	//2021.05.14 금지어 체크 추가
        function onChangePASSWORD() {
            var C = this;
            var id = C.getID();
            var value = C.getValue();
            var pass = everString.getCheckPassWord(value);
			
            if(pass.success) {
            } else {
                EVF.alert(pass.msg, function () {
                    if(id == "PASSWORD") {
                        EVF.V("PASSWORD", "");
                    } else {
                        EVF.V("PASSWORD2", "");
                    }
                    C.setFocus();
                });
            }
            
			var injection = everString.Injection(value);
            
            if(injection.success) {
            } else {
                EVF.alert(injection.msg, function () {
                	if(id == "PASSWORD") {
                        EVF.V("PASSWORD", "");
                    } else {
                        EVF.V("PASSWORD2", "");
                    }
                    C.setFocus();
                });
            }
            
            
            var map = everString.getChkPwd(value);
            
            if(map.success) {
            } else {
                EVF.alert(map.msg, function () {
                    if(id == "PASSWORD") {
                        EVF.V("PASSWORD", "");
                    } else {
                        EVF.V("PASSWORD2", "");
                    }
                    C.setFocus();
                });
            }
        }
		
      	//2021.05.14 이메일 입력시 금지어 체크 추가
        function onChangeCHECK() {
            var C = this;
            var id = C.getID();
            var value = C.getValue();
            var msg = "";

            if(id == "TEL_NUM" || id == "FAX_NUM" || id == "CELL_NUM") {
                if(!everString.isTel(value)) {
                    msg = "${msg.M0128}";
                }
            }
            else if(id == "EMAIL") {
            	
                if(!everString.isValidEmail(value)) {
                    msg = "${msg.EMAIL_INVALID}";
                }
                
                var map = everString.Injection(value);
                
                if(map.success) {
                } else {
                	msg = map.msg
                }
            }

            if(msg != "") {
                EVF.alert(msg, function () {
                    C.setValue("");
                    C.setFocus();
                });
            }
        }

        function onIconClickCOMPANY_CD() {
            if(newCreateFlag) {
                var param = {
                    callBackFunction: "callBackCOMPANY_CD"
                };
                everPopup.openCommonPopup(param, "SP0123");
            }
        }

        function callBackCOMPANY_CD(data) {
            EVF.V("COMPANY_CD", data.VENDOR_CD);
            EVF.V("COMPANY_NM", data.VENDOR_NM);
        }

        function doSave() {
            var store = new EVF.Store();
            if(!store.validate()) return;

            if(EVF.V("DUP_CHECK_ID_YN") == "N") { return EVF.alert("${SVNR0031_010}") }

            var pwd1 = EVF.V("PASSWORD");
            var pwd2 = EVF.V("PASSWORD2");
            if(pwd1 != pwd2) {
                return EVF.alert("${SVNR0031_003}");
            }

            EVF.confirm("${msg.M0021 }", function () {
                store.doFileUpload(function () {
                    store.load(baseUrl + "svnr0031_doSave.so", function () {
                        var userId = this.getParameter("USER_ID");
                        EVF.alert(this.getResponseMessage(), function () {
                            location.href = baseUrl + "SVNR0031/view.so?USER_ID=" + userId + "&detailView=false";
                            if (opener != null) {
                                opener.doSearch();
                            }
                        });
                    });
                });
            });
        }

        function doDupChkUserId() {
            var userId = EVF.V("USER_ID").toUpperCase();
            if(userId == "") {
                EVF.alert("${SVNR0031_004}", function () {
                    EVF.C("USER_ID").setFocus();
                });
                return;
            }
            else {
                if(!everString.isChkId(userId)) {
                    return EVF.alert("${msg.ID_INVALID}", function () {
                        EVF.C("USER_ID").setFocus();
                    });
                }
            }

            var store = new EVF.Store();
            store.load(baseUrl + "svnr0031_doDupChkUserId.so", function () {
                var DUP_CHECK_ID_YN = this.getParameter("DUP_CHECK_ID_YN");
                EVF.V("DUP_CHECK_ID_YN", DUP_CHECK_ID_YN);
                if(DUP_CHECK_ID_YN == "Y") {
                    EVF.C("USER_ID").setValue(userId);
                } else {
                    EVF.C("USER_ID").setValue("");
                }

                EVF.alert(this.getResponseMessage(), function () {

                });
            });
        }

        function doClose() {
            EVF.closeWindow();
        }
    </script>

    <e:window id="SVNR0031" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">
        <e:searchPanel id="sp" title="" labelWidth="${labelWidth}" useTitleBar="false" width="100%" columnCount="2">
            <e:inputHidden id="ORG_USER_ID" name="ORG_USER_ID" value="${formData.USER_ID}"/>
            <e:inputHidden id="IRS_NO" name="IRS_NO" value="${param.IRS_NO}"/>
            <e:inputHidden id="DUP_CHECK_ID_YN" name="DUP_CHECK_ID_YN"/>
            <e:inputHidden id="CHANGE_PW_YN" name="CHANGE_PW_YN"/>
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
                    <e:inputText id="USER_ID" name="USER_ID" value="${formData.USER_ID}" width="162px" placeHolder="${SVNR0031_007}" onChange="onChangeUSER_ID" maxLength="${form_USER_ID_M}" disabled="${form_USER_ID_D}" readOnly="${form_USER_ID_RO}" required="${form_USER_ID_R}" style="${imeMode}" maskType="${form_USER_ID_MT}" />
                    <e:button id="doDupChkUserId" name="doDupChkUserId" label="${SVNR0031_002}" onClick="doDupChkUserId" align="right" disabled="false" visible="true"/>
                </e:field>
                <e:label for="USER_NM" title="${form_USER_NM_N}" />
                <e:field>
                    <e:inputText id="USER_NM" name="USER_NM" value="${formData.USER_NM}" width="${form_USER_NM_W}" maxLength="${form_USER_NM_M}" disabled="${form_USER_NM_D}" readOnly="${form_USER_NM_RO}" required="${form_USER_NM_R}" style="${imeMode}" maskType="${form_USER_NM_MT}"/>
                </e:field>
            </e:row>
            <e:row>
                <e:label for="PASSWORD" title="${form_PASSWORD_N}" />
                <e:field>
                    <e:inputPassword id="PASSWORD" name="PASSWORD" value="" onChange="onChangePASSWORD" width="${form_PASSWORD_W}" maxLength="${form_PASSWORD_M}" disabled="${form_PASSWORD_D}" readOnly="${form_PASSWORD_RO}" required="${form_PASSWORD_R}" style="${imeMode}"/>
                </e:field>
                <e:label for="PASSWORD2" title="${form_PASSWORD2_N}" />
                <e:field>
                    <e:inputPassword id="PASSWORD2" name="PASSWORD2" value="" onChange="onChangePASSWORD" width="${form_PASSWORD2_W}" maxLength="${form_PASSWORD2_M}" disabled="${form_PASSWORD2_D}" readOnly="${form_PASSWORD2_RO}" required="${form_PASSWORD2_R}" style="${imeMode}"/>
                </e:field>
            </e:row>
            <e:row>
                <e:label for="DEPT_NM" title="${form_DEPT_NM_N}" />
                <e:field>
                    <e:inputText id="DEPT_NM" name="DEPT_NM" value="${formData.DEPT_NM}" width="${form_DEPT_NM_W}" maxLength="${form_DEPT_NM_M}" disabled="${form_DEPT_NM_D}" readOnly="${form_DEPT_NM_RO}" required="${form_DEPT_NM_R}" style="${imeMode}" maskType="${form_DEPT_NM_MT}"/>
                </e:field>
                <e:label for="MNG_YN" title="${form_MNG_YN_N}"/>
                <e:field>
                    <e:select id="MNG_YN" name="MNG_YN" value="${formData.MNG_YN}" options="${mngYnOptions}" width="${form_MNG_YN_W}" disabled="${form_MNG_YN_D}" readOnly="${form_MNG_YN_RO}" required="${form_MNG_YN_R}" placeHolder="" usePlaceHolder="false" maskType="${form_MNG_YN_MT}" />
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
                    <e:inputText id="TEL_NUM" name="TEL_NUM" value="${formData.TEL_NUM}" onChange="onChangeCHECK" placeHolder="${SVNR0031_008}" width="${form_TEL_NUM_W}" maxLength="${form_TEL_NUM_M}" disabled="${form_TEL_NUM_D}" readOnly="${form_TEL_NUM_RO}" required="${form_TEL_NUM_R}" style="${imeMode}" maskType="${form_TEL_NUM_MT}"/>
                </e:field>
                <e:label for="FAX_NUM" title="${form_FAX_NUM_N}" />
                <e:field>
                    <e:inputText id="FAX_NUM" name="FAX_NUM" value="${formData.FAX_NUM}" onChange="onChangeCHECK" placeHolder="${SVNR0031_008}" width="${form_FAX_NUM_W}" maxLength="${form_FAX_NUM_M}" disabled="${form_FAX_NUM_D}" readOnly="${form_FAX_NUM_RO}" required="${form_FAX_NUM_R}" style="${imeMode}" maskType="${form_FAX_NUM_MT}"/>
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
                    <e:inputText id="CELL_NUM" name="CELL_NUM" value="${formData.CELL_NUM}" onChange="onChangeCHECK" placeHolder="${SVNR0031_008}" width="${form_CELL_NUM_W}" maxLength="${form_CELL_NUM_M}" disabled="${form_CELL_NUM_D}" readOnly="${form_CELL_NUM_RO}" required="${form_CELL_NUM_R}" style="${imeMode}" maskType="${form_CELL_NUM_MT}"/>
                </e:field>
                <e:label for="EMAIL" title="${form_EMAIL_N}" />
                <e:field>
                    <e:inputText id="EMAIL" name="EMAIL" value="${formData.EMAIL}" onChange="onChangeCHECK" width="${form_EMAIL_W}" maxLength="${form_EMAIL_M}" disabled="${form_EMAIL_D}" readOnly="${form_EMAIL_RO}" required="${form_EMAIL_R}" style="${imeMode}" maskType="${form_EMAIL_MT}"/>
                </e:field>
            </e:row>
            <e:row>
                <e:label for="SMS_FLAG" title="${form_SMS_FLAG_N}"/>
                <e:field>
                    <e:select id="SMS_FLAG" name="SMS_FLAG" value="${formData.SMS_FLAG}" options="${smsFlagOptions}" width="${form_SMS_FLAG_W}" disabled="${form_SMS_FLAG_D}" readOnly="${form_SMS_FLAG_RO}" required="${form_SMS_FLAG_R}" placeHolder="" usePlaceHolder="false" maskType="${form_SMS_FLAG_MT}" />
                </e:field>
                <e:label for="MAIL_FLAG" title="${form_MAIL_FLAG_N}"/>
                <e:field>
                    <e:select id="MAIL_FLAG" name="MAIL_FLAG" value="${formData.MAIL_FLAG}" options="${mailFlagOptions}" width="${form_MAIL_FLAG_W}" disabled="${form_MAIL_FLAG_D}" readOnly="${form_MAIL_FLAG_RO}" required="${form_MAIL_FLAG_R}" placeHolder="" usePlaceHolder="false" maskType="${form_MAIL_FLAG_MT}" />
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
            <e:button id="doClose" name="doClose" label="${doClose_N}" onClick="doClose" disabled="${doClose_D}" visible="${doClose_V}"/>
        </e:buttonBar>

    </e:window>
</e:ui>
