<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">

    <script type="text/javascript">

        var grid;
        var baseUrl = "/nhepro/OCUR/";
        var noChange = "";

        function init() {

            grid = EVF.C("grid");

            grid.cellClickEvent(function(rowIdx, colIdx, value) {

                if (colIdx == "CTRL_NM") {
                    var param = {
                        BUYER_CD : "${ses.manageCd}",
                        COMPANY_TYPE : "B",
                        callBackFunction : "setCtrlInfo",
                        rowIdx : rowIdx
                    };
                    everPopup.openCommonPopup(param, 'SP0003');
                }
            });

            grid.addRowEvent(function() {
                var addParam = [{'USE_FLAG' : '1'}];
                grid.addRow(addParam);
            });

            grid.delRowEvent(function() {
                if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
                //grid.delRow();

                EVF.confirm("${msg.M0013 }", function () {
                    var store = new EVF.Store();
                    store.setGrid([grid]);
                    store.getGridData(grid, 'sel');
                    store.load(baseUrl + 'ocur0031_doDeleteAuth.so', function(){
                        EVF.alert(this.getResponseMessage(), function() {
                        	doSearchAuth();
                        });
                    });
                });
            });

            grid.excelExportEvent({
                allItems : "${excelExport.allCol}",
                fileName : "${screenName }"
            });

            grid.setProperty('shrinkToFit', true);		            // 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
            grid.setProperty('rowNumbers', ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
            grid.setProperty('sortable', ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
            grid.setProperty('panelVisible', ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            grid.setProperty('enterToNextRow', ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            grid.setProperty('acceptZero', ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            grid.setProperty('singleSelect', ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]
            grid.setProperty('multiSelect', ${param.detailView == true ? false : multiSelect}); // [선택] 컬럼의 사용여부를 지정한다. [true/false]

            if(!EVF.isEmpty(EVF.V("ORI_USER_ID"))) {
                noChange = "Y";
                EVF.C('Idcheck').setDisabled(true);
                EVF.C("USER_ID").setReadOnly(true);
            } else {
                EVF.C('PASSWORD').setRequired(true);
            }

            doSearchAuth();
        }

        <%-- id중복체크 --%>
        function doIdcheck() {

            if(EVF.isEmpty(EVF.V("USER_ID"))){
                EVF.C('USER_ID').setFocus();
                EVF.alert(everString.getMessage("${msg.M0109}", "${form_USER_ID_N}"));
            }
            else {
                var store = new EVF.Store();
                store.load(baseUrl + 'ocur0031_doCheckUserId.so', function() {
                    if(this.getParameter("POSSIBLE_FLAG") == "N") {
                        EVF.V("ID_CHECK", "");
                        return EVF.alert("${OCUR0031_006}");
                    } else {
                        EVF.V("ID_CHECK", "Y");
                        EVF.alert("${OCUR0031_001}");
                    }
                }, false);
            }
        }

        function doSave() {

            var btnData = (EVF.isEmpty(EVF.V('ORI_USER_ID')) ? "I" : "U");
            var btnMsg = (btnData == "I" ? "${msg.M0011}" : "${msg.M0012}");

            var store = new EVF.Store();
            if(!store.validate()) { return; }

            if(EVF.V("ID_CHECK") == ""){ return EVF.alert("${OCUR0031_002}"); }

            EVF.confirm(btnMsg, function () {
                store.load(baseUrl + 'ocur0031_doSave.so', function () {
                    EVF.alert(this.getResponseMessage(), function() {
                        opener.doSearch();
                        var param = {
                            'USER_ID': EVF.V("USER_ID"),
                            'detailView': false,
                            'popupFlag': true
                        };
                        window.location.href = '/nhepro/OCUR/OCUR0031/view.so?' + $.param(param);
                    });
                });
            });
        }

        function doSaveAuth() {

            if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

            if (!grid.validate().flag) { return EVF.alert(grid.validate().msg); }

            var rowIds = grid.getAllRowId();
            for(var i = 0; i < rowIds.length; i++) {
                for (var j = (i+1); j < rowIds.length; j++) {
                    if (grid.getCellValue(rowIds[j], 'CTRL_CD') == grid.getCellValue(rowIds[i], 'CTRL_CD')) {
                        grid.setCellValue(rowIds[j], 'CTRL_CD', '');
                        grid.setCellValue(rowIds[j], 'CTRL_NM', '');
                        return EVF.alert(grid.getCellValue(rowIds[i], 'CTRL_NM') + "은(는) " + "${OCUR0031_024}");
                    }
                }
            }

            EVF.confirm("${msg.M0021 }", function () {
                var store = new EVF.Store();
                store.setGrid([grid]);
                store.getGridData(grid, 'sel');
                store.load(baseUrl + 'ocur0031_doSaveAuth.so', function() {
                    EVF.alert(this.getResponseMessage(), function() {
                        doSearchAuth();
                    });
                });
            });
        }

        function doSearchAuth() {

            var store = new EVF.Store();
            store.setGrid([grid]);
            store.load(baseUrl + 'ocur0031_doSearchAuth.so', function() {
                if(grid.getRowCount() == 0) {

                }
            });
        }
		
        function pwValid() {
        	EVF.V("PASSWORD", "");
            EVF.V("PASSWORD_CHECK", "");
            $('#PASSWORD').focus();
        }
        
        function CheckCall(){

            var str;
            if(this.getData().data == "1"){
                str = EVF.V("PASSWORD");
            } else {
                str = EVF.V("PASSWORD_CHECK");
            }
			
            if(!CheckPassWord(str)){
            	pwValid();
            }
            
            if(!chkPwd(str)){
                EVF.V("PASSWORD", "");
                EVF.V("PASSWORD_CHECK", "");
                $('#PASSWORD').focus();
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
      
        function chkPwd(str){

            if (str == '') return true;
            
            var SamePass_1 = 0;
            var SamePass_2 = 0;

            var reg_pwd = /^.*(?=.{10,20})(?=.*[0-9])(?=.*[a-zA-Z]).*$/;
            var reg_pwd2 = /^.*(?=.{10,20})(?=.*[a-zA-Z])(?=.*[!@#$%^&+=]).*$/;
            var reg_pwd3 = /^.*(?=.{10,20})(?=.*[0-9])(?=.*[!@#$%^&+=]).*$/;
            var reg_pwd4 = /^.*(?=^.{8,20}$)(?=.*\d)(?=.*[a-zA-Z])(?=.*[!@#$%^&+=]).*$/;
            if(reg_pwd.test(str) || reg_pwd2.test(str)|| reg_pwd3.test(str)|| reg_pwd4.test(str)){

            } else {
                EVF.alert("${OCUR0031_021}");
                return false;
            }

            if(str.length > 20){
                EVF.alert("${OCUR0031_021}");
                return false;
            }

            for(var i = 0; i < str.length; i++) {
                var chr_pass_0 = str.charAt(i);
                var chr_pass_1 = str.charAt(i+1);
                
                var SamePass_0 = 0;
    			for(var j = i; j < str.length; j++) {
    				if(chr_pass_0 == str.charAt(j)) {
    					SamePass_0 = SamePass_0 + 1
    				}
    			}
    			if(SamePass_0 > 2) {
    				return EVF.alert("${OCUR0031_022}");
    			}
    			
                var chr_pass_2 = str.charAt(i+2);
                if(chr_pass_0.charCodeAt(0) - chr_pass_1.charCodeAt(0) == 1 && chr_pass_1.charCodeAt(0) - chr_pass_2.charCodeAt(0) == 1) {
                    SamePass_1 = SamePass_1 + 1
                }
                
                if(chr_pass_0.charCodeAt(0) - chr_pass_1.charCodeAt(0) == -1 && chr_pass_1.charCodeAt(0) - chr_pass_2.charCodeAt(0) == -1) {
                    SamePass_2 = SamePass_2 + 1
                }
            }
            
            if(SamePass_1 > 1 || SamePass_2 > 1 ) {
                EVF.alert("${OCUR0031_023}");
                return false;
            }
            return true;
        }

        function ModCheckPW(){

            var checkType = this.getData().data;
            if(checkType == "1") {
                EVF.V("PASSWORD", "");
            }
            if(checkType == "2") {
                EVF.V("PASSWORD_CHECK", "");
            }
            EVF.V("CHANGE_PW", "Y");
            EVF.C('PASSWORD').setRequired(true);
            EVF.C('PASSWORD_CHECK').setRequired(true);
        }

        function setCtrlInfo(data) {
            grid.setCellValue(data.rowIdx, 'CTRL_CD', data.CTRL_CD);
            grid.setCellValue(data.rowIdx, 'CTRL_NM', data.CTRL_NM);
        }

        <%-- 고객사 찾기팝업 --%>
        function companySearch() {
            var param = {
                callBackFunction : "companySet"
            };
            everPopup.openCommonPopup(param, 'SP0066');
        }

        function companySet(data) {
            EVF.V("COMPANY_CD", data.CUST_CD);
            EVF.V("COMPANY_NM", data.CUST_NM);
            EVF.V("DEPT_CD", "");
            EVF.V("DEPT_NM", "");
            EVF.V("PARENT_DEPT_CD", "");
            EVF.V("PARENT_DEPT_NM", "");
        }

        function onChangeID() {
            EVF.V("ID_CHECK", "");
            IdcheckId();
        }

        function IdcheckId(){

            var regExp = /^[A-Za-z0-9]{4,12}$/;
            if (!EVF.V("USER_ID").match(regExp)){
                EVF.V("USER_ID", "");
                EVF.alert("${msg.ID_INVALID}");
            }
        }

        function checkTelNo() {

            var checkType = this.getData().data;
            if(checkType == "FAX_NUM") {
                if(!everString.isTel(EVF.V("FAX_NUM"))) {
                    EVF.V("FAX_NUM", "");
                    EVF.C('FAX_NUM').setFocus();
                    EVF.alert("${msg.M0128}");
                }
            }
            if(checkType == "TEL_NUM") {
                if(!everString.isTel(EVF.V("TEL_NUM"))) {
                    EVF.V("TEL_NUM", "");
                    EVF.C('TEL_NUM').setFocus();
                    EVF.alert("${msg.M0128}");
                }
            }
        }

        function checkEmail(){
            if(!everString.isValidEmail(EVF.V("EMAIL"))) {
                EVF.V("EMAIL", "");
                EVF.alert("${msg.EMAIL_INVALID}");
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

        <%-- 부서/사무소 찾기 팝업 --%>
        function deptCdSearch() {

            if (EVF.isEmpty(EVF.V("COMPANY_CD"))) { return EVF.alert("${OCUR0031_0005}"); }

            var param = {
                 CUST_CD : EVF.V('COMPANY_CD')
                ,callBackFunction : "setDept"
            };
            everPopup.openCommonPopup(param, 'SP0084');
        }

        function setDept(data) {
            EVF.V("DEPT_CD", data.DEPT_CD);
            EVF.V("DEPT_NM", data.DEPT_NM);
            EVF.V("PARENT_DEPT_CD", data.PARENT_DEPT_CD);
            EVF.V("PARENT_DEPT_NM", data.PARENT_DEPT_NM);
            EVF.V("PARENT_DEPT_INFO", data.PARENT_DEPT_CD + " / " + data.PARENT_DEPT_NM);
        }

        <%-- 상위부서/사무소 찾기 팝업 --%>
        function parentDeptCdSearch() {

            if (EVF.isEmpty(EVF.V("COMPANY_CD"))) { return EVF.alert("${OCUR0031_0005}"); }

            if (EVF.isEmpty(EVF.V("COMPANY_CD"))) { return EVF.alert("${OCUR0031_0005}"); }

            var param = {
                 CUST_CD : EVF.V('COMPANY_CD')
                ,DEPT_CD : EVF.V('DEPT_CD')
                ,callBackFunction : "setParentDept"
            };
            everPopup.openCommonPopup(param, 'SP0084');
        }

        function setParentDept(data) {
            EVF.V("PARENT_DEPT_CD", data.DEPT_CD);
            EVF.V("PARENT_DEPT_NM", data.DEPT_NM);
        }

        function doChiefUserSearch() {

            var custCd = EVF.V("COMPANY_CD");
            if( EVF.isEmpty(custCd) ) { return EVF.alert("${OCUR0031_011}"); }

            var param = {
                callBackFunction: "setChiefUser",
                custCd: custCd
            };
            everPopup.openCommonPopup(param, "SP0083");
        }

        function setChiefUser(data) {
            EVF.V("CHIEF_USER_ID", data.USER_ID);
            EVF.V("CHIEF_USER_NM", data.USER_NM);
        }

        function doClose() {
            EVF.closeWindow();
        }

    </script>

    <e:window id="OCUR0031" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">

        <e:inputHidden id="ORI_USER_ID" name="ORI_USER_ID" value="${formData.USER_ID }" />
        <e:inputHidden id="USER_TYPE" name="USER_TYPE" value="B" />
        <e:inputHidden id="RELAT_YN" name="RELAT_YN" value="${formData.RELAT_YN}" />

        <e:searchPanel id="form" title="${form_CAPTION_N }" labelWidth="${labelWidth}" width="100%" columnCount="2" useTitleBar="false">
            <e:row>
                <e:label for="COMPANY_CD" title="${form_COMPANY_CD_N}" />
                <e:field>
                    <e:search id="COMPANY_CD" name="COMPANY_CD" value="${formData.COMPANY_CD }" width="${form_COMPANY_CD_W}" maxLength="${form_COMPANY_CD_M}" disabled="${form_COMPANY_CD_D}" readOnly="${form_COMPANY_CD_RO}" required="${form_COMPANY_CD_R}" maskType="${form_COMPANY_CD_MT}" onIconClick="companySearch" />
                </e:field>
                <e:label for="COMPANY_NM" title="${form_COMPANY_NM_N}" />
                <e:field>
                    <e:inputText id="COMPANY_NM" name="COMPANY_NM" value="${formData.COMPANY_NM }" width="${form_COMPANY_NM_W}" maxLength="${form_COMPANY_NM_M}" disabled="${form_COMPANY_NM_D}" readOnly="${form_COMPANY_NM_RO}" required="${form_COMPANY_NM_R}" maskType="${form_COMPANY_NM_MT}" />
                </e:field>
            </e:row>
            <e:row>
                <e:label for="USER_ID" title="${form_USER_ID_N}"/>
                <e:field>
                    <e:inputText id="USER_ID" name="USER_ID" value="${formData.USER_ID }" width="216px" maxLength="${form_USER_ID_M}" disabled="${form_USER_ID_D}" readOnly="${form_USER_ID_RO}" required="${form_USER_ID_R}" onChange="onChangeID"  maskType="${form_USER_ID_MT}" />
                    &nbsp;<e:button id="Idcheck" name="Idcheck" label="${Idcheck_N}" onClick="doIdcheck" disabled="${Idcheck_D}" visible="${Idcheck_V}" />
                    <e:inputHidden id="ID_CHECK" name="ID_CHECK" value="${formData.ID_CHECK }" />
                </e:field>
                <e:label for="USER_NM" title="${form_USER_NM_N}"/>
                <e:field>
                    <e:inputText id="USER_NM" name="USER_NM" value="${formData.USER_NM }" width="${form_USER_NM_W}" maxLength="${form_USER_NM_M}" disabled="${form_USER_NM_D}" readOnly="${form_USER_NM_RO}" required="${form_USER_NM_R}" style="${imeMode}" maskType="${form_USER_NM_MT}" />
                </e:field>
            </e:row>
            <e:row>
                <e:label for="PASSWORD" title="${form_PASSWORD_N}"/>
                <e:field>
                    <e:inputPassword id="PASSWORD" name="PASSWORD" value="${form.PASSWORD}" width="${form_PASSWORD_W}" maxLength="${form_PASSWORD_M}" disabled="${form_PASSWORD_D}" readOnly="${form_PASSWORD_RO}" required="${form_PASSWORD_R}" onChange="CheckCall" data="1" onClick="ModCheckPW"/>
                    <e:inputHidden id="CHANGE_PW" name="CHANGE_PW" value="" />
                </e:field>
                <e:label for="PASSWORD_CHECK" title="${form_PASSWORD_CHECK_N}"/>
                <e:field>
                    <e:inputPassword id="PASSWORD_CHECK" name="PASSWORD_CHECK" value="${form.PASSWORD_CHECK}" width="${form_PASSWORD_CHECK_W}" maxLength="${form_PASSWORD_CHECK_M}" disabled="${form_PASSWORD_CHECK_D}" readOnly="${form_PASSWORD_CHECK_RO}" required="${form_PASSWORD_CHECK_R}" onChange="CheckCall" data="2" onClick="ModCheckPW"/>
                </e:field>
            </e:row>
            <e:row>
                <e:label for="TEL_NUM" title="${form_TEL_NUM_N}"></e:label>
                <e:field>
                    <e:inputText id="TEL_NUM" name="TEL_NUM" value="${formData.TEL_NUM}" placeHolder="${OCUR0031_INPUT_T2 }" width="${form_TEL_NUM_W}" maxLength="${form_TEL_NUM_M}" disabled="${form_TEL_NUM_D}" readOnly="${form_TEL_NUM_RO}" required="${form_TEL_NUM_R}" maskType="${form_TEL_NUM_MT}" onChange="checkTelNo" data="TEL_NUM" />
                </e:field>
                <e:label for="EMAIL" title="${form_EMAIL_N}"></e:label>
                <e:field>
                    <e:inputText id="EMAIL" name="EMAIL" value="${formData.EMAIL}" width="${form_EMAIL_W}" maxLength="${form_EMAIL_M}" disabled="${form_EMAIL_D}" readOnly="${form_EMAIL_RO}" required="${form_EMAIL_R}" maskType="${form_EMAIL_MT}" onChange="checkEmail" />
                </e:field>
            </e:row>
            <e:row>
                <e:label for="FAX_NUM" title="${form_FAX_NUM_N}"></e:label>
                <e:field>
                    <e:inputText id="FAX_NUM" name="FAX_NUM" placeHolder="${OCUR0031_INPUT_T2 }" value="${formData.FAX_NUM}" width="${form_FAX_NUM_W}" maxLength="${form_FAX_NUM_M}" disabled="${form_FAX_NUM_D}" readOnly="${form_FAX_NUM_RO}" required="${form_FAX_NUM_R}" maskType="${form_FAX_NUM_MT}" onChange="checkTelNo" data="FAX_NUM" />
                </e:field>
                <e:label for="CELL_NUM" title="${form_CELL_NUM_N}"></e:label>
                <e:field>
                    <e:inputText id="CELL_NUM" name="CELL_NUM"  placeHolder="${OCUR0031_INPUT_T2 }" value="${formData.CELL_NUM}" width="${form_CELL_NUM_W}" maxLength="${form_CELL_NUM_M}" disabled="${form_CELL_NUM_D}" readOnly="${form_CELL_NUM_RO}" required="${form_CELL_NUM_R}" maskType="${form_CELL_NUM_MT}" onChange="checkCellNo" data="CELL_NUM" />
                </e:field>
            </e:row>
            <e:row>
                <e:label for="MAIL_FLAG" title="${form_MAIL_FLAG_N}" />
                <e:field>
                    <e:select id="MAIL_FLAG" name="MAIL_FLAG" value="${formData.MAIL_FLAG }" options="${smsFlagOptions }" width="${form_MAIL_FLAG_W}" disabled="${form_MAIL_FLAG_D}" readOnly="${form_MAIL_FLAG_RO}" required="${form_MAIL_FLAG_R}" placeHolder="" maskType="${form_MAIL_FLAG_MT}"/>
                </e:field>
                <e:label for="SMS_FLAG" title="${form_SMS_FLAG_N}" />
                <e:field>
                    <e:select id="SMS_FLAG" name="SMS_FLAG" value="${formData.SMS_FLAG }" options="${smsFlagOptions }" width="${form_SMS_FLAG_W}" disabled="${form_SMS_FLAG_D}" readOnly="${form_SMS_FLAG_RO}" required="${form_SMS_FLAG_R}" placeHolder="" maskType="${form_SMS_FLAG_MT}"/>
                </e:field>
            </e:row>
            <e:row>
                <e:label for="POSITION_NM" title="${form_POSITION_NM_N}"/>
                <e:field>
                    <e:inputText id="POSITION_NM" name="POSITION_NM" value="${formData.POSITION_NM }" width="${form_POSITION_NM_W}" maxLength="${form_POSITION_NM_M}" disabled="${form_POSITION_NM_D}" readOnly="${form_POSITION_NM_RO}" required="${form_POSITION_NM_R}" style="${imeMode}" maskType="${form_POSITION_NM_MT}" />
                </e:field>
                <e:label for="DUTY_NM" title="${form_DUTY_NM_N}" />
                <e:field>
                    <e:inputText id="DUTY_NM" name="DUTY_NM" value="${formData.DUTY_NM }" width="${form_DUTY_NM_W}" maxLength="${form_DUTY_NM_M}" disabled="${form_DUTY_NM_D}" readOnly="${form_DUTY_NM_RO}" required="${form_DUTY_NM_R}" maskType="${form_DUTY_NM_MT}" />
                </e:field>
            </e:row>
            <e:row>
                <e:label for="DEPT_CD" title="${form_DEPT_CD_N}" />
                <e:field>
                    <e:search id="DEPT_CD" name="DEPT_CD" value="${formData.DEPT_CD }" width="40%" maxLength="${form_DEPT_CD_M}" disabled="${form_DEPT_CD_D}" readOnly="${form_DEPT_CD_RO}" required="${form_DEPT_CD_R}" maskType="${form_DEPT_CD_MT}" onIconClick="deptCdSearch" />
                    <e:inputText id="DEPT_NM" name="DEPT_NM" value="${formData.DEPT_NM}" width="60%" maxLength="${form_DEPT_NM_M}" disabled="${form_DEPT_NM_D}" readOnly="${form_DEPT_NM_RO}" required="${form_DEPT_NM_R}" maskType="${form_DEPT_NM_MT}" />
                </e:field>
                <e:label for="CHIEF_USER_ID" title="${form_CHIEF_USER_ID_N}" />
                <e:field>
                    <e:search id="CHIEF_USER_ID" name="CHIEF_USER_NM" value="${formData.CHIEF_USER_ID}" width="40%" maxLength="${form_CHIEF_USER_ID_M}" disabled="${form_CHIEF_USER_ID_D}" readOnly="${form_CHIEF_USER_ID_RO}" required="${form_CHIEF_USER_ID_R}" maskType="${form_CHIEF_USER_ID_MT}" onIconClick="doChiefUserSearch" />
                    <e:inputText id="CHIEF_USER_NM" name="CHIEF_USER_NM" value="${formData.CHIEF_USER_NM}" width="60%" maxLength="${form_CHIEF_USER_NM_M}" disabled="${form_CHIEF_USER_NM_D}" readOnly="${form_CHIEF_USER_NM_RO}" required="${form_CHIEF_USER_NM_R}" maskType="${form_CHIEF_USER_NM_MT}" />
                </e:field>
            </e:row>
            <e:row>
                <e:label for="PARENT_DEPT_CD" title="${form_PARENT_DEPT_CD_N}" />
                <e:field>
                    <e:text id="PARENT_DEPT_INFO" label="" width="100%" >${formData.PARENT_DEPT_INFO}</e:text>
                    <e:inputHidden id="PARENT_DEPT_CD" name="PARENT_DEPT_CD" value="${formData.PARENT_DEPT_CD }" />
                    <e:inputHidden id="PARENT_DEPT_NM" name="PARENT_DEPT_NM" value="${formData.PARENT_DEPT_NM }" />
                    <%--
                    <e:search id="PARENT_DEPT_CD" name="PARENT_DEPT_CD" value="${formData.PARENT_DEPT_CD }" width="40%" maxLength="${form_PARENT_DEPT_CD_M}" disabled="${form_PARENT_DEPT_CD_D}" readOnly="${form_PARENT_DEPT_CD_RO}" required="${form_PARENT_DEPT_CD_R}" maskType="${form_PARENT_DEPT_CD_MT}" onIconClick="parentDeptCdSearch" />
                    <e:inputText id="PARENT_DEPT_NM" name="PARENT_DEPT_NM" value="${formData.PARENT_DEPT_NM}" width="60%" maxLength="${form_PARENT_DEPT_NM_M}" disabled="${form_PARENT_DEPT_NM_D}" readOnly="${form_PARENT_DEPT_NM_RO}" required="${form_PARENT_DEPT_NM_R}" maskType="${form_PARENT_DEPT_NM_MT}" />
                    --%>
                </e:field>
                <e:label for="ONES_DUTY_NM" title="${form_ONES_DUTY_NM_N}" />
                <e:field>
                    <e:inputText id="ONES_DUTY_NM" name="ONES_DUTY_NM" value="${formData.ONES_DUTY_NM}" width="${form_ONES_DUTY_NM_W}" maxLength="${form_ONES_DUTY_NM_M}" disabled="${form_ONES_DUTY_NM_D}" readOnly="${form_ONES_DUTY_NM_RO}" required="${form_ONES_DUTY_NM_R}" maskType="${form_ONES_DUTY_NM_MT}" />
                </e:field>
            </e:row>
        </e:searchPanel>

        <e:buttonBar id="buttonTop" align="right" width="100%" title="${OCUR0031_CAPTION1 }">
            <e:button id="Save" name="Save" label="${Save_N }" disabled="${Save_D }" visible="${Save_V}" onClick="doSave" />
        </e:buttonBar>

        <e:gridPanel id="grid" name="grid" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}"/>

        <e:buttonBar id="buttonBottom" align="right" width="100%">
            <e:button id="SaveAuth" name="SaveAuth" label="${SaveAuth_N }" disabled="${SaveAuth_D }" visible="${SaveAuth_V}" onClick="doSaveAuth" />
            <e:button id="Close" name="Close" label="${Close_N }" disabled="${Close_D }" visible="${Close_V}" onClick="doClose" />
        </e:buttonBar>

    </e:window>
</e:ui>