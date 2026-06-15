<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
    <script type="text/javascript">

        var baseUrl = "/eversrm/main/userInfoChange/";
        var userType = '${ses.userType}';

        function init() {
        }

        function doSave() {

            var presentPass = EVF.V("P_PASSWORD");
            var newPassCheck1 = EVF.V("PASSWORD_CHECK1");
            var newPassCheck2 = EVF.V("PASSWORD_CHECK2");

            if(EVF.isNotEmpty(presentPass)) {
                if (newPassCheck1.trim() == '' || newPassCheck2.trim() == '') {
                    pwValid();
                    return EVF.alert("${MSI_080_003}");
                }

                if(newPassCheck1 != newPassCheck2) {
                    pwValid();
                    return EVF.alert('${MSI_080_004}');
                }
            }

            var store = new EVF.Store();
            if(!store.validate()) { return; }

            EVF.confirm("${msg.M0021 }", function () {
                store.load(baseUrl+'/saveUser.so', function () {
                    EVF.alert(this.getResponseMessage(), function() {
                        EVF.closeWindow();
                    });
                });
            });
        }

        function doClose() {
            EVF.closeWindow();
        }

        function pwValid() {
            EVF.V("PASSWORD_CHECK1", "");
            EVF.V("PASSWORD_CHECK2", "");
            $('#PASSWORD_CHECK1').focus();
        }

        function CheckCall(){
            var str;
            if(this.data.data == "1"){
                str = EVF.V("PASSWORD_CHECK1");
            }else{
                str = EVF.V("PASSWORD_CHECK2");
            }
            
            if(!CheckPassWord(str)){
            	pwValid();
            }
            
            if(!chkPwd(str)){
                pwValid();
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
      
        //비밀번호체크
        function chkPwd(str){
            var SamePass_1 = 0; //연속성(+) 카운드
            var SamePass_2 = 0; //연속성(-) 카운드

            var reg_pwd = /^.*(?=.{10,20})(?=.*[0-9])(?=.*[a-zA-Z]).*$/;					//영문숫자
            var reg_pwd2 = /^.*(?=.{10,20})(?=.*[a-zA-Z])(?=.*[!@#$%^&+=]).*$/;				//영문특수
            var reg_pwd3 = /^.*(?=.{10,20})(?=.*[0-9])(?=.*[!@#$%^&+=]).*$/; 				//숫자특수
            var reg_pwd4 = /^.*(?=^.{8,20}$)(?=.*\d)(?=.*[a-zA-Z])(?=.*[!@#$%^&+=]).*$/;	//영문숫자특수문자
            if(reg_pwd.test(str) || reg_pwd2.test(str)|| reg_pwd3.test(str)|| reg_pwd4.test(str)){

            } else {
                EVF.alert("${MSI_080_021}");
                return false;
            }
            
            if(str.length > 20){
                EVF.alert("${MSI_080_021}");
                return false;
            }

            //동일문자 카운트
            for(var i=0; i < str.length; i++) {
                var chr_pass_0 = str.charAt(i);
                var chr_pass_1 = str.charAt(i+1);
                
                var SamePass_0 = 0; //동일문자 카운트
    			for(var j = i; j < str.length; j++) {
    				if(chr_pass_0 == str.charAt(j)) {
    					SamePass_0 = SamePass_0 + 1
    				}
    			}
    			if(SamePass_0 > 2) {
    				return EVF.alert("${MSI_080_022}");
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
            
            if(SamePass_1 > 1 || SamePass_2 > 1) {
                EVF.alert("${MSI_080_023}");
                return false;
            }
            
            //기존비밀번호와 동일하면안됨.
            if(str==EVF.V("P_PASSWORD")){
                EVF.alert("${msg.M0153 }");
                return false;
            }
            
            return true;
        }

        function checkTelNo() {

            var checkType = this.getData().data;
            if(checkType == "FAX_NUM") {
                if(!everString.isTel(EVF.V("FAX_NUM"))) {
                    EVF.alert("${msg.M0128}");
                    EVF.V("FAX_NUM", "");
                    EVF.C('FAX_NUM').setFocus();
                }
            }
            if(checkType == "TEL_NUM") {
                if(!everString.isTel(EVF.V("TEL_NUM"))) {
                    EVF.alert("${msg.M0128}");
                    EVF.V("TEL_NUM", "");
                    EVF.C('TEL_NUM').setFocus();
                }
            }
        }

        function checkCellNo() {
            var CellNum = EVF.V("CELL_NUM");
            var rgEx = /(01[016789])[-](\d{4}|\d{3})[-]\d{4}$/g;
            var chkFlg = rgEx.test(CellNum);
            if(!chkFlg){
                EVF.V("CELL_NUM", "");
                EVF.C('CELL_NUM').setFocus();
                return EVF.alert("${msg.M0128}");
            }
        }

    </script>
    <e:window id="window" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">

        <e:title title="${MSI_080_TITLE1}" depth="1" />

        <e:searchPanel id="sp" title="${form_CAPTION_N}" labelWidth="${labelWidth}" useTitleBar="false" width="100%" columnCount="2">
            <e:row>
                <e:label for="USER_ID" title="${form_USER_ID_N}"/>
                <e:field>
                    <e:inputText id='USER_ID' name="USER_ID" label='${form_USER_ID_N }' value="${form.USER_ID}" width='100%' maxLength='${form_USER_ID_M }' required='${form_USER_ID_R }' readOnly='${form_USER_ID_RO }' disabled='${form_USER_ID_D }' visible='${form_USER_ID_V }'/>
                </e:field>
                <e:label for="USER_NM" title="${form_USER_NM_N}"/>
                <e:field>
                    <e:inputText id='USER_NM' name="USER_NM" label='${form_USER_NM_N }' value="${form.USER_NM}" width='100%' maxLength='${form_USER_NM_M }' required='${form_USER_NM_R }' readOnly='${form_USER_NM_RO }' disabled='${ses.userType eq "X" ? true : false}' visible='${form_USER_NM_V }'/>
                </e:field>
            </e:row>
            
            <e:row>
                <e:label for="TEL_NUM" title="${form_TEL_NUM_N}"/>
                <e:field>
                    <e:inputText id='TEL_NUM' name="TEL_NUM" label='${form_TEL_NUM_N }' value="${form.TEL_NUM}" width='100%' maxLength='${form_TEL_NUM_M }' required='${form_TEL_NUM_R }' readOnly='${form_TEL_NUM_RO }' disabled='${ses.userType eq "X" ? true : false}' visible='${form_TEL_NUM_V }' onChange="checkTelNo" data="TEL_NUM" />
                </e:field>
                <e:label for="USER_NM_ENG" title="${form_USER_NM_ENG_N}"/>
                <e:field>
                    <e:inputText id='USER_NM_ENG' name="USER_NM_ENG" label='${form_USER_NM_ENG_N }' value="${form.USER_NM_ENG}" width='100%' maxLength='${form_USER_NM_ENG_M }' required='${form_USER_NM_ENG_R }' readOnly='${form_USER_NM_ENG_RO }' disabled='${ses.userType eq "X" ? true : false}' visible='${form_USER_NM_ENG_V }'/>
                </e:field>
            </e:row>
            
            <e:row>
                <e:label for="CELL_NUM" title="${form_CELL_NUM_N}"/>
                <e:field>
                    <e:inputText id='CELL_NUM' name="CELL_NUM" label='${form_CELL_NUM_N }' value="${form.CELL_NUM}" width='100%' maxLength='${form_CELL_NUM_M }' required='${form_CELL_NUM_R }' readOnly='${form_CELL_NUM_RO }' disabled='${ses.userType eq "X" ? true : false}' visible='${form_CELL_NUM_V }' onChange="checkCellNo" data="CELL_NUM" />
                </e:field>
                <e:label for="FAX_NUM" title="${form_FAX_NUM_N}"/>
                <e:field>
                    <e:inputText id='FAX_NUM' name="FAX_NUM" label='${form_FAX_NUM_N }' value="${form.FAX_NUM}" width='100%' maxLength='${form_FAX_NUM_M }' required='${form_FAX_NUM_R }' readOnly='${form_FAX_NUM_RO }' disabled='${ses.userType eq "X" ? true : false}' visible='${form_FAX_NUM_V }' onChange="checkTelNo" data="FAX_NUM"/>
                </e:field>

                <e:inputHidden id='LANG_CD' name="LANG_CD" value="${form.LANG_CD}"/>
                <e:inputHidden id='COUNTRY_CD' name="COUNTRY_CD" value="${form.COUNTRY_CD}"/>
                <e:inputHidden id='GMT_CD' name="GMT_CD" value="${form.GMT_CD}"/>
                <%--
                <e:label for="LANG_CD" title="${form_LANG_CD_N}"/>
                <e:field>
                    <e:select id='LANG_CD' name="LANG_CD" label='${form_LANG_CD_N }' value="${form.LANG_CD}" options="${langCd}"
                              width='${inputTextWidth }' required='${form_LANG_CD_R }'
                              readOnly='${form_LANG_CD_RO }' disabled='${form_LANG_CD_D }'
                              visible='${form_LANG_CD_V }' placeHolder='${placeHolder }'>
                    </e:select>
                </e:field>
                 --%>
            </e:row>
            <e:row>
                <e:label for="EMAIL" title="${form_EMAIL_N}"/>
                <e:field colSpan="3">
                    <e:inputText id='EMAIL' name="EMAIL" label='${form_EMAIL_N }' value="${form.EMAIL}" width='100%' maxLength='${form_EMAIL_M }' required='${form_EMAIL_R }' readOnly='${form_EMAIL_RO }' disabled='${ses.userType eq "X" ? true : false}' visible='${form_EMAIL_V }'/>
                </e:field>
                
            </e:row>
            
            <%--
            <e:row>
                <e:label for="COUNTRY_CD" title="${form_COUNTRY_CD_N}"/>
                <e:field>
                    <e:select id='COUNTRY_CD' name="COUNTRY_CD" label='${form_COUNTRY_CD_N }' value="${form.COUNTRY_CD}" options="${countryCd}"
                              width='${inputTextWidth }' required='${form_COUNTRY_CD_R }'
                              readOnly='${form_COUNTRY_CD_RO }'
                              disabled='${form_COUNTRY_CD_D }'
                              visible='${form_COUNTRY_CD_V }' placeHolder='${placeHolder }'>
                    </e:select>
                </e:field>
                <e:label for="GMT_CD" title="${form_GMT_CD_N}"/>
                <e:field>
                    <e:select id='GMT_CD' name="GMT_CD" label='${form_GMT_CD_N }' value="${form.GMT_CD}" options="${gmtCd}"
                              width='${inputTextWidth }' required='${form_GMT_CD_R }'
                              readOnly='${form_GMT_CD_RO }' disabled='${form_GMT_CD_D }'
                              visible='${form_GMT_CD_V }' placeHolder='${placeHolder }'>
                    </e:select>
                </e:field>
            </e:row>
             --%>
            <e:row>
                <e:label for="POSITION_NM" title="${form_POSITION_NM_N}"/>
                <e:field>
                    <e:inputText id='POSITION_NM' name="POSITION_NM" label='${form_POSITION_NM_N }' value="${form.POSITION_NM}" width='100%' maxLength='${form_POSITION_NM_M }' required='${form_POSITION_NM_R }' readOnly='${form_POSITION_NM_RO }' disabled='${ses.userType eq "X" ? true : false}' visible='${form_POSITION_NM_V }'/>
                </e:field>
                <e:label for="DUTY_NM" title="${form_DUTY_NM_N}"/>
                <e:field>
                    <e:inputText id='DUTY_NM' name="DUTY_NM" label='${form_DUTY_NM_N }' value="${form.DUTY_NM}" width='100%' maxLength='${form_DUTY_NM_M }' required='${form_DUTY_NM_R }' readOnly='${form_DUTY_NM_RO }' disabled='${ses.userType eq "X" ? true : false}' visible='${form_DUTY_NM_V }'/>
                </e:field>
            </e:row>
        </e:searchPanel>
            <%--<e:row>--%>
            <%--<e:label for="USER_DATE_FORMAT_CD" title="${form_USER_DATE_FORMAT_CD_N}"/>--%>
            <%--<e:field>--%>
            <e:select id='USER_DATE_FORMAT_CD' name="USER_DATE_FORMAT_CD" value="${form.USER_DATE_FORMAT_CD}"  options="${userDateFormat}" label='${form_USER_DATE_FORMAT_CD_N }' width='0' required='${form_USER_DATE_FORMAT_CD_R }' readOnly='${form_USER_DATE_FORMAT_CD_RO }' disabled='${form_USER_DATE_FORMAT_CD_D }' visible='${form_USER_DATE_FORMAT_CD_V }' placeHolder='${placeHolder }'>
            </e:select>
            <%--<e:label for="USER_NUMBER_FORMAT_CD" title="${form_USER_NUMBER_FORMAT_CD_N}"/>--%>
            <%--<e:field>--%>
            <e:select id='USER_NUMBER_FORMAT_CD' name="USER_NUMBER_FORMAT_CD" value="${form.USER_NUMBER_FORMAT_CD}" options="${numCd}" label='${form_USER_NUMBER_FORMAT_CD_N }' width='0' required='${form_USER_NUMBER_FORMAT_CD_R }' readOnly='${form_USER_NUMBER_FORMAT_CD_RO }' disabled='${form_USER_NUMBER_FORMAT_CD_D }' visible='${form_USER_NUMBER_FORMAT_CD_V }' placeHolder='${placeHolder }'>
            </e:select>
            <%--</e:field>--%>
        <e:title title="${MSI_080_TITLE2}" depth="1" />
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
            <%-- <e:button label='${doClose_N }' id='doClose' onClick='doClose' disabled='${doClose_D }' visible='${doClose_V }'/> --%>
        </e:buttonBar>
    </e:window>
</e:ui>
 