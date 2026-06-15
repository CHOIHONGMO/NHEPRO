<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page import="com.st_ones.everf.serverside.config.PropertiesManager" %>
<%@ include file="/WEB-INF/views/common/ozUrlInfo.jsp" %>

<%
	String ozSchedulerIp = PropertiesManager.getString("oz.scheduler.ip");
	String ozSchedulerPort = PropertiesManager.getString("oz.scheduler.port");
%>

<c:set var="ozExportUrl" value="<%=ozExportUrl%>" />
<c:set var="ozUrl" value="<%=ozUrl%>" />
<c:set var="ozServer" value="<%=ozServer%>" />
<c:set var="ozSchedulerIp" value="<%=ozSchedulerIp%>" />
<c:set var="ozSchedulerPort" value="<%=ozSchedulerPort%>" />

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
    <script type="text/javascript">
        var baseUrl = "/nhepro/TEST/";
		
        function init() {
        	
        	grid = EVF.C('grid');
            grid.setProperty('shrinkToFit', true);		// 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
        	grid.setProperty('rowNumbers', ${rowNumbers});		    // 로우의 번호 표시 여부를 지정한다. [true/false]
        	grid.setProperty('sortable', ${sortable});			    // 컬럼 정렬기능 사용여부를 지정한다. [true/false]
        	grid.setProperty('panelVisible', ${panelVisible});	    // 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
        	grid.setProperty('enterToNextRow', ${enterToNextRow}); // 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
        	grid.setProperty('acceptZero', ${acceptZero});		    // 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
        	grid.setProperty('multiSelect', ${multiSelect});		// [선택] 컬럼의 사용여부를 지정한다. [true/false]
        	grid.setProperty('singleSelect', ${singleSelect});	    // [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]

        	// Grid AddRow Event
        	grid.addRowEvent(function() {
            	grid.addRow();
        	});
        	
        
  	
    	    var param = {
        			ozrName: "${FORM_FILE_NAME}",
        			//odiName: "CCTA0070",
        			//BUYER_CD: "C00009",
        			//USER_ID: "CUSTOMER",
        			//REQ_NUM: "EN210500020",
        			//REQ_SEQ : "1",
        			FORM_VERSION : "1",
        			exportFormat: "ozr",
        			SUB_FORM_FILE_NM: ""
        			
        			
        		};
    	    
        	frameWindow.location.href = "${ozUrl}" + '/ozhviewer_canvas_eform.jsp?' + $.param(param);
        	
        }
        
        function onApproval() {
            var param = {
                signStatus : "E",
                FORM_TITLE : EVF.V("FORM_TITLE"),
                FORM_ID : EVF.V("FORM_ID")
            };
            everPopup.openApprovalRemarkPopup(param);
        }
        
        function onReject() {
            var param = {
                signStatus: "R",
                FORM_TITLE : EVF.V("FORM_TITLE"),
                FORM_ID : EVF.V("FORM_ID")
            };
            everPopup.openApprovalRemarkPopup(param);
        }
        
        
    </script>

    <e:window id="TEST0050" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">
    
     <e:buttonBar width="100%"  title="회수/승인/반려 사유" align="left" >
            <e:button id="Cancel" name="Cancel" label="${Cancel_N}" onClick="Cancel" disabled="${Cancel_D}" visible="${Cancel_V}"/>
        	<e:button id="onApproval" name="onApproval" label="${onApproval_N}" onClick="onApproval" disabled="${onApproval_D}" visible="${onApproval_V}"/>
            <e:button id="onReject" name="onReject" label="${onReject_N}" onClick="onReject" disabled="${onReject_D}" visible="${onReject_V}"/>
        </e:buttonBar>
    
     <e:searchPanel id="form" title="" labelWidth="135" width="100%" columnCount="3" useTitleBar="false" onEnter="doSearch">
       <e:row>
      	<e:label for="FORM_TITLE" title="${form_FORM_TITLE_N}" />
		<e:field colSpan="5">
			<e:inputText id="FORM_TITLE" name="FORM_TITLE" value="${form.FORM_TITLE}" width="${form_FORM_TITLE_W}" maxLength="${form_FORM_TITLE_M}" disabled="${form_FORM_TITLE_D}" readOnly="${form_FORM_TITLE_RO}" required="${form_FORM_TITLE_R}" style="${imeMode}" maskType="${form_SEND_ADDRESS_NAME_MT}"/>
		</e:field>
      </e:row>
    </e:searchPanel>
    
    <e:title title="일상감사의뢰서" />
    <e:gridPanel id="grid" name="grid"   gridType="${_gridType}" width="100%" height="fit"/>
		
        <%-- <e:buttonBar width="100%" align="right" >
        	<e:button id="onApproval" name="onApproval" label="${onApproval_N}" onClick="onApproval" disabled="${onApproval_D}" visible="${onApproval_V}"/>
            <e:button id="doSave" name="doSave" label="${doSave_N}" onClick="doSave" disabled="${doSave_D}" visible="${doSave_V}"/>
        </e:buttonBar> --%>

	<iframe id="frameWindow"  name="frameWindow"   frameborder="0" scrolling="yes" marginheight="0" marginwidth="0" width="105%" height="1040" src=""></iframe>
    
    </e:window>
</e:ui>
