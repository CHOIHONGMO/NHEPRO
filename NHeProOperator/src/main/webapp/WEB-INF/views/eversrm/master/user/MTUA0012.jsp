<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
	<script>
    	var baseUrl = "/eversrm/master/user/MTUA0012/";

    	function init() {
        	EVF.getComponent('GATE_CD').setValue('${form.GATE_CD}');
        	EVF.getComponent('USER_ID').setValue('${form.USER_ID}');
        	//EVF.getComponent('PASSWORD').setValue('${form.PASSWORD}') ;
        	//EVF.getComponent('PASSWORD_CHECK').setValue('${form.PASSWORD_CHECK}') ;
        }
    	
        function doIssue() {

    		if (checkPass() == -1) { return; }
			if (checkPass() == -2) { alert("${MTUA0012_0001}"); return; }
			if (!confirm("${msg.M0021}")) { return; }

	        var gateCd = EVF.getComponent('GATE_CD').getValue();
	        var userId = EVF.getComponent('USER_ID').getValue();
			var pass = EVF.getComponent('PASSWORD').getValue();
			var passChk = EVF.getComponent('PASSWORD_CHECK').getValue();

			if ( !/\S/.test(pass)
				|| !/\S/.test(passChk)
				|| !/\S/.test(gateCd)
				|| !/\S/.test(userId)
			) {
            	alert("${msg.M0054}");
            	return;
        	}

			var store = new EVF.Store();
			var userType = EVF.V("USER_TYPE");
			var url;
			if( userType == "O" ) {
				url = "mtua0012_doSave.so";
			} else if( userType == "T" ) { //2023.01.05 개인근로자 로직 추가
				url = "mtua0012_doSave_TVUR.so";
			}else {
				url = "mtua0012_doSave_CVUR.so";
			}
			store.load(baseUrl + url, function() {
				alert(this.getResponseMessage());
				opener.${form.onClose}();
				window.close();
			});
        }
        
        function checkPass() {
			var pass  = EVF.getComponent('PASSWORD').getValue().replace(/^\s+/,'').replace(/\s+$/,'')
			var passc = EVF.getComponent('PASSWORD_CHECK').getValue().replace(/^\s+/,'').replace(/\s+$/,'');

			EVF.getComponent('PASSWORD').setValue(pass);
			EVF.getComponent('PASSWORD_CHECK').setValue(passc);

			if ( !/\S/.test(pass) || !/\S/.test(passc) ) { return -2; }
			if ( (!/\S/.test(pass) || !/\S/.test(passc)) || (pass != passc)  ) { alert("${msg.M0028}"); return -1; }

			return 0;
        }
    </script>
	<%--BSB_070--%>
	<e:window id="MTUA0012" onReady="init" initData="${initData}" width="100%" height="100%" name="${screenName}" title="${screenName}">
		<e:inputHidden id="USER_TYPE" name="USER_TYPE" value="${form.USER_TYPE}"/>

		<e:buttonBar id="MTUA0012_Button" width="100%" align="right">
			<e:button label='${doIssue_N }' id='doIssue' icon='${doIssue_I }' onClick='doIssue' disabled='${doIssue_D }' visible='${doIssue_V }' />
		</e:buttonBar>

		<e:searchPanel id="MTUA0012_Panel" title="${screenName}" useTitleBar="false" labelWidth="${labelWidth}" width="100%" columnCount="2">
			<e:row>
				<e:label for="PASSWORD" title="${form_PASSWORD_N }"></e:label>
				<e:field>
					<e:inputPassword id="PASSWORD" name="PASSWORD" value="${form.PASSWORD}" width="100%" maxLength="${form_PASSWORD_M}" disabled="${form_PASSWORD_D}" readOnly="${form_PASSWORD_RO}" required="${form_PASSWORD_R}" />
				</e:field>
				
				<e:label for="PASSWORD_CHECK" title="${form_PASSWORD_CHECK_N }"></e:label>
				<e:field>
					<e:inputPassword id="PASSWORD_CHECK" name="PASSWORD_CHECK" value="${form.PASSWORD_CHECK}" width="100%" maxLength="${form_PASSWORD_CHECK_M}" disabled="${form_PASSWORD_CHECK_D}" readOnly="${form_PASSWORD_CHECK_RO}" required="${form_PASSWORD_CHECK_R}" />
					<e:inputHidden id="USER_ID" name="USER_ID" visible="false" width="0"/>
                    <e:inputHidden id="GATE_CD" name="GATE_CD" visible="false" width="0"/>					
				</e:field>
			</e:row>			
		</e:searchPanel>
	</e:window>
</e:ui>                                                                             	