<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<e:ui>

	<script>

    var baseUrl = "/eversrm/basic/message/";
    var gridMsg = {};

    function init() {
    	gridMsg = EVF.C('gridMsg');
    	
    	gridMsg.setProperty("shrinkToFit", true);
    	gridMsg.setProperty("rowNumbers", ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
    	gridMsg.setProperty("sortable", ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
    	gridMsg.setProperty("panelVisible", ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
    	gridMsg.setProperty("enterToNextRow", ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
    	gridMsg.setProperty("acceptZero", ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
    	gridMsg.setProperty("multiSelect", true);					// [선택] 컬럼의 사용여부를 지정한다. [true/false]
    	gridMsg.setProperty("singleSelect", ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]
        
    	gridMsg.addRowEvent(function () {
            gridMsg.addRow();
        });

        gridMsg.delRowEvent(function () {
            gridMsg.delRow();
        });
        
    }
    
    function onChangeSendType(){
    	if(EVF.V("SEND_TYPE") == "A"){
    		EVF.C("CAPTION_MSG").setReadOnly(true);
    		EVF.C("CAPTION_MSG").setRequired(false);
    	} else {
    		EVF.C("CAPTION_MSG").setReadOnly(false);
    		EVF.C("CAPTION_MSG").setRequired(true);
    	}
    }

    function doSend() {
    	
    	if(gridMsg.getRowCount() == 0) { return alert('${msg.M0004}'); }
        
		var store = new EVF.Store();
		if (!store.validate()) { return; }
		if (!gridMsg.validate().flag) { return EVF.alert('${msg.M0014}'); }
		
		var msg = "협력업체에 공지사항 메일을 전송하겠습니까?";
		
		EVF.confirm(msg, function () {
			store.setGrid([gridMsg]);
	    	store.getGridData(gridMsg, 'all'); // 수신자
	        store.load(baseUrl + 'BSN_040/doMailSmsSend.so', function() {
	        	EVF.alert(this.getResponseMessage(), function () {
	        		doReset();
	            });
	        });
		});
    }

    function doReset() {
    	location.href = baseUrl+'BSN_040/view.so';
    }

    // 수신자 선택
    function doSearchUser() {
    	var param = {
    			width : 1000,
    			callBackFunction: "_setReceiveUser"
            };
    	everPopup.openCommonPopup(param, 'MP0025');
    }
    
    function _setReceiveUser(jsonData) {
   		for( idx in jsonData ){
       		var addParam = [{
        			"VENDOR_CD"				   : jsonData[idx].VENDOR_CD,
        			"VENDOR_NM"				   : jsonData[idx].VENDOR_NM,
        			"IRS_NO"   				   : jsonData[idx].IRS_NO,
        			"CEO_USER_NM"			   : jsonData[idx].CEO_USER_NM,
        			"VENDOR_PIC_USER_ID"	   : jsonData[idx].VENDOR_PIC_USER_ID,
        			"VENDOR_PIC_USER_NM"  	   : jsonData[idx].VENDOR_PIC_USER_NM,
        			"VENDOR_PIC_USER_CELL_NUM" : jsonData[idx].VENDOR_PIC_USER_CELL_NUM,
        			"VENDOR_PIC_USER_EMAIL"    : jsonData[idx].VENDOR_PIC_USER_EMAIL
    			}];
        	gridMsg.addRow(addParam);
       	}
    }

	</script>

	<e:window id="BSN_040" onReady="init" initData="${initData}" width="100%" height="100%" name="${screenName}" title="${screenName}">
		
		<e:buttonBar id="b" width="100%" align="right">
			<e:button id="doSend" name="doSend" label="${doSend_N}" onClick="doSend" disabled="${doSend_D}" visible="${doSend_V}"/>
			<e:button id="doReset" name="doReset" label="${doReset_N}" onClick="doReset" disabled="${doReset_D}" visible="${doReset_V}"/>
		</e:buttonBar>
		
	    <e:searchPanel id="form" title="${form_CAPTION_N }" useTitleBar="false" labelWidth="${labelWidth}" width="100%" columnCount="1">
	    	<e:row>
	    		<e:label for="SEND_TYPE" title="${form_SEND_TYPE_N}"/>
				<e:field>
					<e:select id="SEND_TYPE" name="SEND_TYPE" value="" options="${sendTypeOptions}" width="${form_SEND_TYPE_W}" disabled="${form_SEND_TYPE_D}" readOnly="${form_SEND_TYPE_RO}" required="${form_SEND_TYPE_R}" placeHolder="" onChange="onChangeSendType" maskType="${form_SEND_TYPE_MT}" />
				</e:field>
			</e:row>	
			<e:row>
				<e:label for="SUBJECT" title="${form_SUBJECT_N}"/>
				<e:field>
					<e:inputText id="SUBJECT" name="SUBJECT" value="${defaultSubject}" width="100%" maxLength="${form_SUBJECT_M}" disabled="${form_SUBJECT_D}" readOnly="${form_SUBJECT_RO}" required="${form_SUBJECT_R}" />
				</e:field>
			</e:row>
			<e:row>
				<e:label for="CAPTION_MSG" title="${form_CAPTION_MSG_N }" />
			    <e:field>
			    	<e:richTextEditor id="CAPTION_MSG" name="CAPTION_MSG" value="${formData.CAPTION_MSG}" height="300px" width="100%" maxLength="${form_CAPTION_MSG_M}" disabled="${form_CAPTION_MSG_D}" readOnly="${form_CAPTION_MSG_RO}" required="${form_CAPTION_MSG_R}" />
				</e:field>
			</e:row>
		</e:searchPanel>
	
	
	<e:buttonBar id="userBtnBar" align="right" width="100%" title="수신자">
       <e:button id="doSearchUser" name="doSearchUser" label="${doSearchUser_N}" onClick="doSearchUser" disabled="${doSearchUser_D}" visible="${doSearchUser_V}"/>
    </e:buttonBar>
    
	<e:gridPanel id="gridMsg" name="gridMsg" gridType="${_gridType}" width="100%" height="fit" />
	
    </e:window>
</e:ui>
