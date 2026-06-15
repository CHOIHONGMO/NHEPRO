<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
	<style>
        .e-window-toolbar{
        	display: none !important;
        }

    </style>
    <script type="text/javascript">

        var grid;
        var baseUrl = "/nhepro/CETR/";
        var userType = "${ses.userType}";
        var code = "${param.code}";
        var clickRowId;
        
        function init() {
        	// 2021.05.27 로그인 후 비밀번호 180일, 아이디와 동일한 경우 비밀번호 필수입력 하도록 
			if( code == "1" || code == "180") {
				EVF.C("P_PASSWORD").setRequired(true);
				EVF.C("PASSWORD_CHECK1").setRequired(true);
				EVF.C("PASSWORD_CHECK2").setRequired(true);
			} else {
				EVF.C("P_PASSWORD").setRequired(false);
				EVF.C("PASSWORD_CHECK1").setRequired(false);
				EVF.C("PASSWORD_CHECK2").setRequired(false);
			}
			
            EVF.C("CTRL_NM").setDisabled(true);
        }

        function doSave() {

            var presentPass = EVF.V("P_PASSWORD");
            var newPassCheck1 = EVF.V("PASSWORD_CHECK1");
            var newPassCheck2 = EVF.V("PASSWORD_CHECK2");

            if(EVF.isNotEmpty(presentPass)) {
                if (newPassCheck1.trim() == "" || newPassCheck2.trim() == "") {
                    pwValid();
                    return EVF.alert("${CETR0010_003}");
                }

                if(newPassCheck1 != newPassCheck2) {
                    pwValid();
                    return EVF.alert("${CETR0010_004}");
                }
            }

            var store = new EVF.Store();
            if(!store.validate()) { return; }

            EVF.confirm("${msg.M0021 }", function () {
                store.load(baseUrl + "cetr0010_saveUser.so", function () {
                    EVF.alert(this.getResponseMessage(), function() {
                        EVF.closeWindow();
                    });
                });
            });
        }

        function doSaveG() {

            if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

            if (!grid.validate().flag) { return EVF.alert(grid.validate().msg); }

            var rowIds = grid.getSelRowId();

            for(var i in rowIds) {
                if(!everString.isTel(grid.getCellValue(rowIds[i], "RECIPIENT_TEL_NUM"))) {
                    return EVF.alert("${CETR0010_024}");
                }
                if(!everString.isTel(grid.getCellValue(rowIds[i], "RECIPIENT_CELL_NUM"))) {
                    return EVF.alert("${CETR0010_024}");
                }
                if(!everString.isValidEmail(grid.getCellValue(rowIds[i], "RECIPIENT_EMAIL"))) {
                    return EVF.alert("${CETR0010_025}");
                }
            }

            EVF.confirm("${msg.M0021 }", function () {
                var store = new EVF.Store();
                store.setGrid([grid]);
                store.getGridData(grid, "sel");
                store.load(baseUrl + "cetr0010_doSaveG.so", function() {
                    EVF.alert(this.getResponseMessage(), function() {
                        doSearchG();
                    });
                });
            });
        }

        function doSearchG() {
            var store = new EVF.Store();
            store.setGrid([grid]);
            store.load(baseUrl + "cetr0010_doSearchG.so", function() {

            });
        }

        function pwValid() {
            EVF.C("PASSWORD_CHECK1").setValue("");
            EVF.C("PASSWORD_CHECK2").setValue("");
            $("#PASSWORD_CHECK1").focus();
        }
		
      	//2021.05.14 password 입력시 금지어 체크 추가
        function CheckCall(){
            var str;
            if(this.data.data == "1"){
                str = EVF.V("PASSWORD_CHECK1");
            } else {
                str = EVF.V("PASSWORD_CHECK2");
            }
            
            if(!CheckPassWord(str)){
            	pwValid();
            }
            	
            if(!chkPwd(str)){
                pwValid();
            }
            
			var map = everString.Injection(str);
            
            if(map.success) {
            } else {
                EVF.alert(map.msg, function () {
                	pwValid();
                });
            }
        }
        
      	//2021.03.17 비밀번호 입력시 '%' 특수문자 입력 불가하도록 체크
        function CheckPassWord(str){
        	var reg_pwd = new Array();
        	reg_pwd.push("%");
        	for(var i=0; i < reg_pwd.length; i++){
        		if(str.indexOf(reg_pwd[i])!= -1){
            		EVF.alert("비밀번호 입력 시 % 특수문자는 사용할 수 없습니다.");
            		return false;
        		}
        	}
        	
        	return true;
        }

        <%-- 비밀번호체크 --%>
        function chkPwd(str){
            var SamePass_1 = 0; //연속성(+) 카운드
            var SamePass_2 = 0; //연속성(-) 카운드

            var reg_pwd = /^.*(?=.{10,20})(?=.*[0-9])(?=.*[a-zA-Z]).*$/;					//영문숫자
            var reg_pwd2 = /^.*(?=.{10,20})(?=.*[a-zA-Z])(?=.*[!@#$%^&+=]).*$/;				//영문특수
            var reg_pwd3 = /^.*(?=.{10,20})(?=.*[0-9])(?=.*[!@#$%^&+=]).*$/; 				//숫자특수
            var reg_pwd4 = /^.*(?=^.{8,20}$)(?=.*\d)(?=.*[a-zA-Z])(?=.*[!@#$%^&+=]).*$/;	//영문숫자특수문자

            if( reg_pwd.test(str) || reg_pwd2.test(str) || reg_pwd3.test(str) || reg_pwd4.test(str) ){

            } else {
                EVF.alert("${CETR0010_021}");
                return false;
            }

            if(str.length > 20){
                EVF.alert("${CETR0010_021}");
                return false;
            }

            <%-- 동일문자 카운트 --%>
            for(var i = 0; i < str.length; i++) {
                var chr_pass_0 = str.charAt(i);
                var chr_pass_1 = str.charAt(i+1);
                
				var SamePass_0 = 0; //동일문자 카운트
				for(var j = i; j < str.length; j++) {
					if(chr_pass_0 == str.charAt(j)) {
						SamePass_0 = SamePass_0 + 1
					}
				}
				if(SamePass_0 > 2) {
					EVF.alert("${CETR0010_022}");
					return false;
				}
				
                var chr_pass_2 = str.charAt(i+2);
                //연속성(+) 카운드
                if(chr_pass_0.charCodeAt(0) - chr_pass_1.charCodeAt(0) == 1 && chr_pass_1.charCodeAt(0) - chr_pass_2.charCodeAt(0) == 1) {
                    SamePass_1 = SamePass_1 + 1
                }
                //연속성(-) 카운드
                if(chr_pass_0.charCodeAt(0) - chr_pass_1.charCodeAt(0) == -1 && chr_pass_1.charCodeAt(0) - chr_pass_2.charCodeAt(0) == -1) {
                    SamePass_2 = SamePass_2 + 1
                }
            }
            if(SamePass_1 > 1 || SamePass_2 > 1 ) {
                EVF.alert("${CETR0010_023}");
                return false;
            }
            
            <%-- 기존비밀번호와 동일하면안됨. --%>
            if(str==EVF.V("P_PASSWORD")){
                EVF.alert("${msg.M0153 }");
                return false;
            }

            return true;
        }

        function setZipCode(zipcd) {
            if (zipcd.ZIP_CD != "") {
                grid.setCellValue(clickRowId, "DELY_ZIP_CD", zipcd.ZIP_CD_5);
                grid.setCellValue(clickRowId, "DELY_ADDR_1", zipcd.ADDR);
            }
        }

        function doUserSearch() {
            param = {
					'callBackFunction': 'selectCustUserId',
					'READONLY': 'Y',           //팝업 조회조건 변경불가
					'multiYN' : 'N',         //멀티팝업여부
					'detailView': false
			};
			everPopup.openPopupByScreenId("CCDU0020", 1100, 700, param);
        }

        function selectCustUserId(data) {
        	if(data!=null){
        		data = JSON.parse(data);
        		
            	EVF.V("CHIEF_USER_ID", data.USER_ID);
            	EVF.V("CHIEF_USER_NM", data.USER_NM);
        	}
        }
		
        //2021.05.14 email 입력시 금지어 체크 추가
        function checkMailAdd() {
            if(!everString.isValidEmail(EVF.V("EMAIL"))) {
                EVF.alert("${CETR0010_025}");
                EVF.C("EMAIL").setValue("");
                EVF.C("EMAIL").setFocus();
            }
            
			var map = everString.Injection(EVF.V("EMAIL"));
            
            if(map.success) {
            } else {
            	EVF.alert(map.msg, function () {
            		EVF.C("EMAIL").setValue("");
                	EVF.C("EMAIL").setFocus();
                });
            }
        }

        function checkTelNo() {
            var checkType = this.getData().data;
            if(checkType == "FAX_NUM") {
                if(!everString.isTel(EVF.V("FAX_NUM"))) {
                    EVF.alert("${msg.FAX_NUM_INVALID}");
                    EVF.C("FAX_NUM").setValue("");
                    EVF.C("FAX_NUM").setFocus();
                }
            }
            <%--
            if(checkType == "TEL_NUM") {
                if(!everString.isTel(EVF.V("TEL_NUM"))) {
                    EVF.alert("${msg.TEL_NUM_INVALID}");
                    EVF.V("TEL_NUM", "");
                    EVF.C("TEL_NUM").setFocus();
                }
            }
            --%>
        }

        function checkCellNo() {
            var CellNum = EVF.V("CELL_NUM");
            var rgEx = /(01[016789])[-](\d{4}|\d{3})[-]\d{4}$/g;
            var chkFlg = rgEx.test(CellNum);
            if(!chkFlg){
                EVF.C("CELL_NUM").setValue("");
                EVF.C("CELL_NUM").setFocus();
                return EVF.alert("${msg.CELL_NUM_INVALID}");
            }
        }

        function doClose() {
            EVF.closeWindow();
        }

    </script>

    <e:window id="CETR0010" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">
		<e:buttonBar id="buttonBar" align="right" width="100%" title="${CETR0010_TITLE1}">
		<c:if test="${param.infoFlag eq true}">
			<e:button id="doClose" name="doClose" label="${doClose_N}" onClick="doClose" disabled="${doClose_D}" visible="${doClose_V}"/>
		</c:if>	
		</e:buttonBar>
        <%-- <e:title title="${CETR0010_TITLE1}" depth="1" /> --%>

        <e:searchPanel id="sp" title="${form_CAPTION_N}" labelWidth="${labelWidth}" useTitleBar="false" width="100%" columnCount="2">

            <e:inputHidden id='LANG_CD' name="LANG_CD" value="${form.LANG_CD}"/>
            <e:inputHidden id='COUNTRY_CD' name="COUNTRY_CD" value="${form.COUNTRY_CD}"/>
            <e:inputHidden id='GMT_CD' name="GMT_CD" value="${form.GMT_CD}"/>
            <e:inputHidden id='COMPANY_CD' name="COMPANY_CD" value="${form.COMPANY_CD}"/>

            <e:row>
                <e:label for="USER_ID" title="${form_USER_ID_N}"/>
                <e:field>
                    <e:inputText id="USER_ID" name="USER_ID" label='${form_USER_ID_N }' value="${form.USER_ID}" width='100%' maxLength='${form_USER_ID_M }' required='${form_USER_ID_R }' readOnly='${form_USER_ID_RO }' disabled='${form_USER_ID_D }' visible='${form_USER_ID_V }' maskType="${form_USER_ID_MT}" />
                </e:field>
                <e:label for="USER_NM" title="${form_USER_NM_N}"/>
                <e:field>
                    <e:inputText id="USER_NM" name="USER_NM" label='${form_USER_NM_N }' value="${form.USER_NM}" width='100%' maxLength='${form_USER_NM_M }' required='${form_USER_NM_R }' readOnly='${form_USER_NM_RO }' disabled='${ses.userType eq "X" ? true : false}' visible='${form_USER_NM_V }' maskType="${form_USER_NM_MT}" />
                </e:field>
            </e:row>
            <e:row>
                <e:label for="COMPANY_NM" title="${form_COMPANY_NM_N}"/>
                <e:field>
                    <e:inputText id="COMPANY_NM" name="COMPANY_NM" label='${form_COMPANY_NM_N }' value="${form.COMPANY_NM}" width='100%' maxLength='${form_COMPANY_NM_M }' required='${form_COMPANY_NM_R }' readOnly='${form_COMPANY_NM_RO }' disabled='${form_COMPANY_NM_D }' visible='${form_COMPANY_NM_V }' maskType="${form_COMPANY_NM_MT}" />
                </e:field>
                <e:label for="DEPT_NM" title="${form_DEPT_NM_N}" />
                <e:field>
                    <e:inputText id="DEPT_NM" name="DEPT_NM" value="${form.DEPT_NM}" width="${form_DEPT_NM_W}" maxLength="${form_DEPT_NM_M}" disabled="${form_DEPT_NM_D}" readOnly="${form_DEPT_NM_RO}" required="${form_DEPT_NM_R}"  maskType="${form_DEPT_NM_MT}" />
                </e:field>
            </e:row>
            <e:row>
                <e:label for="POSITION_NM" title="${form_POSITION_NM_N}"/>
                <e:field>
                    <e:inputText id="POSITION_NM" name="POSITION_NM" label='${form_POSITION_NM_N }' value="${form.POSITION_NM}" width='100%' maxLength='${form_POSITION_NM_M }' required='${form_POSITION_NM_R }' readOnly='${form_POSITION_NM_RO }' disabled='${ses.userType eq "X" ? true : false}' visible='${form_POSITION_NM_V }' maskType="${form_POSITION_NM_MT}" />
                </e:field>
                <e:label for="DUTY_NM" title="${form_DUTY_NM_N}"/>
                <e:field>
                    <e:inputText id="DUTY_NM" name="DUTY_NM" label='${form_DUTY_NM_N }' value="${form.DUTY_NM}" width='100%' maxLength='${form_DUTY_NM_M }' required='${form_DUTY_NM_R }' readOnly='${form_DUTY_NM_RO }' disabled='${ses.userType eq "X" ? true : false}' visible='${form_DUTY_NM_V }' maskType="${form_DUTY_NM_MT}" />
                </e:field>
            </e:row>
            <e:row>
                <e:label for="TEL_NUM" title="${form_TEL_NUM_N}"/>
                <e:field>
                    <e:inputText id="TEL_NUM" name="TEL_NUM" label='${form_TEL_NUM_N }' value="${form.TEL_NUM}" width='100%' maxLength='${form_TEL_NUM_M }' required='${form_TEL_NUM_R }' readOnly='${form_TEL_NUM_RO }' disabled='${ses.userType eq "X" ? true : false}' onChange="checkTelNo" visible='${form_TEL_NUM_V }' data="TEL_NUM"  maskType="${form_TEL_NUM_MT}" />
                </e:field>
                <e:label for="EMAIL" title="${form_EMAIL_N}"/>
                <e:field>
                    <e:inputText id="EMAIL" name="EMAIL" label='${form_EMAIL_N }' value="${form.EMAIL}" width='100%' maxLength='${form_EMAIL_M }' required='${form_EMAIL_R }' readOnly='${form_EMAIL_RO }' disabled='${ses.userType eq "X" ? true : false}' onChange="checkMailAdd" visible='${form_EMAIL_V }' maskType="${form_EMAIL_MT}" />
                </e:field>
            </e:row>
            <e:row>
                <e:label for="FAX_NUM" title="${form_FAX_NUM_N}"/>
                <e:field>
                    <e:inputText id="FAX_NUM" name="FAX_NUM" label='${form_FAX_NUM_N }' value="${form.FAX_NUM}" width='100%' maxLength='${form_FAX_NUM_M }' required='${form_FAX_NUM_R }' readOnly='${form_FAX_NUM_RO }' disabled='${ses.userType eq "X" ? true : false}' onChange="checkTelNo" visible='${form_FAX_NUM_V }'  data="FAX_NUM"  maskType="${form_FAX_NUM_MT}" />
                </e:field>
                <e:label for="CELL_NUM" title="${form_CELL_NUM_N}"/>
                <e:field>
                    <e:inputText id="CELL_NUM" name="CELL_NUM" label='${form_CELL_NUM_N }' value="${form.CELL_NUM}" width='100%' maxLength='${form_CELL_NUM_M }' required='${form_CELL_NUM_R }' readOnly='${form_CELL_NUM_RO }' disabled='${ses.userType eq "X" ? true : false}' onChange="checkCellNo" visible='${form_CELL_NUM_V }' maskType="${form_CELL_NUM_MT}" />
                </e:field>
            </e:row>
            <e:row>
                <e:label for="MAIL_FLAG" title="${form_MAIL_FLAG_N}" />
                <e:field>
                    <e:select id="MAIL_FLAG" name="MAIL_FLAG" value="${form.MAIL_FLAG }" options="${mailFlagOptions }" width="${form_MAIL_FLAG_W}" disabled="${form_MAIL_FLAG_D}" readOnly="${form_MAIL_FLAG_RO}" required="${form_MAIL_FLAG_R}" placeHolder="" maskType="${form_MAIL_FLAG_MT}"/>
                </e:field>
                <e:label for="SMS_FLAG" title="${form_SMS_FLAG_N}" />
                <e:field>
                    <e:select id="SMS_FLAG" name="SMS_FLAG" value="${form.SMS_FLAG }" options="${smsFlagOptions }" width="${form_SMS_FLAG_W}" disabled="${form_SMS_FLAG_D}" readOnly="${form_SMS_FLAG_RO}" required="${form_SMS_FLAG_R}" placeHolder="" maskType="${form_SMS_FLAG_MT}"/>
                </e:field>
            </e:row>
            <e:row>
                <e:label for="CHIEF_USER_ID" title="${form_CHIEF_USER_ID_N}" />
                <e:field>
                    <e:search id="CHIEF_USER_NM" name="CHIEF_USER_NM" value="${form.CHIEF_USER_NM}" width="${form_CHIEF_USER_NM_W}" maxLength="${form_CHIEF_USER_NM_M}" onIconClick="doUserSearch" disabled="${form_CHIEF_USER_NM_D}" readOnly="${form_CHIEF_USER_NM_RO}" required="${form_CHIEF_USER_NM_R}" onChange="clearUser"  maskType="${form_CHIEF_USER_NM_MT}" />
                    <e:inputHidden id="CHIEF_USER_ID" name="CHIEF_USER_ID" value="${form.CHIEF_USER_ID}" />
                </e:field>
                <e:label for="MOD_INFO" title="${form_MOD_INFO_N}" />
                <e:field>
                    <e:inputText id="MOD_INFO" name="MOD_INFO" value="${form.MOD_INFO}" width="${form_MOD_INFO_W}" maxLength="${form_MOD_INFO_M}" disabled="${form_MOD_INFO_D}" readOnly="${form_MOD_INFO_RO}" required="${form_MOD_INFO_R}"  maskType="${form_MOD_INFO_MT}" />
                </e:field>
            </e:row>
            <e:row>
                <e:label for="CTRL_NM" title="${form_CTRL_NM_N}"/>
                <e:field colSpan="3">
                    <e:textArea id="CTRL_NM" name="CTRL_NM" value="${form.CTRL_NM}" height="50px" width="${form_CTRL_NM_W}" maxLength="${form_CTRL_NM_M}" disabled="${form_CTRL_NM_D}" readOnly="${form_CTRL_NM_RO}" required="${form_CTRL_NM_R}" />
                </e:field>
            </e:row>
        </e:searchPanel>

        <e:select id="USER_DATE_FORMAT_CD" name="USER_DATE_FORMAT_CD" value="${form.USER_DATE_FORMAT_CD}" options="${userDateFormatCdOptions}" label='${form_USER_DATE_FORMAT_CD_N }' width='0' required='${form_USER_DATE_FORMAT_CD_R }' readOnly='${form_USER_DATE_FORMAT_CD_RO }' disabled='${form_USER_DATE_FORMAT_CD_D }' visible='${form_USER_DATE_FORMAT_CD_V }' placeHolder='${placeHolder }'  maskType="${form_USER_DATE_FORMAT_CD_MT}"/>
        <e:select id="USER_NUMBER_FORMAT_CD" name="USER_NUMBER_FORMAT_CD" value="${form.USER_NUMBER_FORMAT_CD}" options="${userNumberFormatCdOptions}" label='${form_USER_NUMBER_FORMAT_CD_N }' width='0' required='${form_USER_NUMBER_FORMAT_CD_R }' readOnly='${form_USER_NUMBER_FORMAT_CD_RO }' disabled='${form_USER_NUMBER_FORMAT_CD_D }' visible='${form_USER_NUMBER_FORMAT_CD_V }' placeHolder='${placeHolder }'  maskType="${form_USER_NUMBER_FORMAT_CD_MT}"/>

        <e:title title="${CETR0010_TITLE2}" depth="1" />
		<e:text style="color: red;font-weight: bold;">&nbsp;&nbsp;※ 비밀번호는 영문, 숫자, 특수문자의 조합으로 8~20자리 또는 두가지 조합으로 10~20자리 입력해주세요.</br>&nbsp;&nbsp;※ 연속된 문자열(123 또는 321, abc, cba 등)을 3자 이상 사용 할 수 없습니다.</br>&nbsp;&nbsp;※ 동일문자를 3번 이상 사용할 수 없습니다.</br>&nbsp;&nbsp;※ 비밀번호 입력 시 '%' 특수문자는 사용 할  수 없습니다.</br>&nbsp;&nbsp;※ 기존 비밀번호와 동일하게 사용 할 수 없습니다.</e:text>
        <e:searchPanel id="sp2" title="${form_CAPTION_N}" labelWidth="${labelWidth}" useTitleBar="false" width="100%" columnCount="2">
            <e:row>
                <e:label for="P_PASSWORD" title="${form_P_PASSWORD_N}"/>
                <e:field colSpan="3">
                    <e:inputPassword id='P_PASSWORD' name="P_PASSWORD" label='${form_P_PASSWORD_N }' width='100%' required='${form_P_PASSWORD_R }' readOnly='${form_P_PASSWORD_RO }' disabled='${form_P_PASSWORD_D }' visible='${form_P_PASSWORD_V }' maxLength="${form_P_PASSWORD_M}"/>
                </e:field>
            </e:row>
            <e:row>
                <e:label for="PASSWORD_CHECK1" title="${form_PASSWORD_CHECK1_N}"/>
                <e:field>
                    <e:inputPassword id='PASSWORD_CHECK1' name="PASSWORD_CHECK1" label='${form_PASSWORD_CHECK1_N }' width='100%' required='${form_PASSWORD_CHECK1_R }' readOnly='${form_PASSWORD_CHECK1_RO }' disabled='${form_PASSWORD_CHECK1_D }' visible='${form_PASSWORD_CHECK1_V }' maxLength="${form_PASSWORD_CHECK1_M}" onChange="CheckCall" data="1"/>
                </e:field>
                <e:label for="PASSWORD_CHECK2" title="${form_PASSWORD_CHECK2_N}"/>
                <e:field>
                    <e:inputPassword id='PASSWORD_CHECK2' name="PASSWORD_CHECK2" label='${form_PASSWORD_CHECK2_N }' width='100%' required='${form_PASSWORD_CHECK2_R }' readOnly='${form_PASSWORD_CHECK2_RO }' disabled='${form_PASSWORD_CHECK2_D }' visible='${form_PASSWORD_CHECK2_V }' maxLength="${form_PASSWORD_CHECK2_M}" onChange="CheckCall" data="2"/>
                </e:field>
            </e:row>
        </e:searchPanel>

        <e:buttonBar width="100%" align="right">
            <e:button label='${doSave_N }' id='doSave' onClick='doSave' disabled='${doSave_D }' visible='${doSave_V }'/>
        </e:buttonBar>

        <%--
        <e:title title="${CETR0010_TITLE3}" depth="1" />

        <e:gridPanel id="grid" name="grid" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}" />

        <e:buttonBar id="buttonBarG" align="right" width="100%">
            <e:button id="SaveG" name="SaveG" label="${SaveG_N }" disabled="${SaveG_D }" visible="${SaveG_V}" onClick="doSaveG" />
        </e:buttonBar>
        --%>
    </e:window>
</e:ui>
