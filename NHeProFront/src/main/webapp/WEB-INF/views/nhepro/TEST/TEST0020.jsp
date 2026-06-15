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
		var detailView = "${param.detailView}" == "true";
        
        
        function init() {
        	
    	    var param = {
        			ozrName: "PL_FORM_AUDIT_1",
        			//odiName: "CCTA0070",
        			//BUYER_CD: "C00009",
        			//USER_ID: "CUSTOMER",
        			//REQ_NUM: "EN210500020",
        			//REQ_SEQ : "1",
        			exportFormat: "ozr",
        			SUB_FORM_FILE_NM: ""
        		};
    	    
        	frameWindow.location.href = "${ozUrl}" + '/ozhviewer_canvas_eform.jsp?' + $.param(param);
        	
        }
        
        function doSave(){
        	var screenId = 'TEST0010'
    		top.pageRedirectByScreenId(screenId);
    	}
        
        function doOpen(){
        	
        	/* var screenId = 'TEST0020P10'
    		top.pageRedirectByScreenId(screenId); */
        // everPopup.openApprovalRequestIPopup('TEST0020P10');
    		
    		var	param = {	
    				detailView : false
    			};
        	everPopup.openPopupByScreenId("TEST0020P10", 1100, 700, param);
    	}

    </script>

    <e:window id="TEST0020" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">
		
        <e:buttonBar width="100%" align="right" >
        	<e:button id="doOpen" name="doOpen" label="${doOpen_N}" onClick="doOpen" disabled="${doOpen_D}" visible="${doOpen_V}"/>
            <e:button id="doSave" name="doSave" label="${doSave_N}" onClick="doSave" disabled="${doSave_D}" visible="${doSave_V}"/>
        </e:buttonBar>

	<iframe id="frameWindow"  name="frameWindow"   frameborder="0" scrolling="yes" marginheight="0" marginwidth="0" width="105%" height="1040" src=""></iframe>
    
    </e:window>
</e:ui>
