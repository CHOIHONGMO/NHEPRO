<%--
  Date: 2020-06-10
  Time: 15:01:18
  Scrren ID : CCTR0070
--%>
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
  <script>

    var grid;
    var baseUrl = '/nhepro/TEST/TEST0010';

    function init() {
    	grid = EVF.C("grid");
    	grid.setProperty("shrinkToFit", true);
		grid.setProperty("rowNumbers", ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
		grid.setProperty("sortable", ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
		grid.setProperty("panelVisible", ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
		grid.setProperty("enterToNextRow", ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
		grid.setProperty("acceptZero", ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
		grid.setProperty("multiSelect", ${multiSelect});		// [선택] 컬럼의 사용여부를 지정한다. [true/false]
		grid.setProperty("singleSelect", ${singleSelect});
		
        // Grid Excel Event
        grid.excelExportEvent({
          allItems : "${excelExport.allCol}",
          fileName : "${screenName }"
        });
    }
    
    //20220524테스트 
    
    //수신부서 선택 팝업 오픈
    function doRecvBuyerCd() {
		param = {
				'callBackFunction': 'ecBuyerNmCallback',
				'detailView': false,
				callBackFunction: "setRecvBuyerCd"
			};
			everPopup.openCommonPopup(param, "SP0119");
	}
    
	function setRecvBuyerCd(data) {
		EVF.V("RECEIVE_ADDRESS_NAME", data.BUYER_NM + ' ' +data.DEPT_NM);
		EVF.V("RECEIVE_BUYER_CD", data.BUYER_CD);
		EVF.V("RECEIVE_DEPT_CD", data.DEPT_CD);
	}
	
	//발신부서 선택 팝업 오픈
    function doSendBuyerCd() {
		param = {
				'callBackFunction': 'ecBuyerNmCallback',
				'detailView': false,
				callBackFunction: "setSendBuyerCd"
			};
			everPopup.openCommonPopup(param, "SP0119");
	}
    
	function setSendBuyerCd(data) {
		EVF.V("SEND_ADDRESS_NAME", data.BUYER_NM + ' ' +data.DEPT_NM);
		EVF.V("SEND_BUYER_CD", data.BUYER_CD);
		EVF.V("SEND_DEPT_CD", data.DEPT_CD);
	}
    
 	function opEntrustForm(param){
    	
    	if(EVF.V("RECEIVE_ADDRESS_NAME")== null || EVF.V("RECEIVE_ADDRESS_NAME")=='' ){
    		return EVF.alert("${CCTR0070_0006}");
    	} 
    	
    	 	var param = {
     			ozrName: "test01",
     			//odiName: "CCTA0070",
     			//BUYER_CD: "C00009",
     			//USER_ID: "CUSTOMER",
     			//RECEIVE_ADDRESS_NAME: "EN210500020",
     			//REQ_SEQ : "1",
     			exportFormat: "ozr",
     			SUB_FORM_FILE_NM: ""
     		};
	    	var url = "${ozUrl}" + "/ozhviewer_canvas_eform.jsp";
    		everPopup.openWindowPopup(url, 1085, 900, param, 'eform');
	}
 	
 	function doSave() {
 		 if(!checkFormValidation()) { return; }
         
         EVF.confirm("${msg.M0021 }", function() {
				var store = new EVF.Store();
				store.setGrid([grid]);
				store.getGridData(grid,  'all');
				store.load(baseUrl+'/test0010_doSave.so', function() {
	                EVF.alert(this.getResponseMessage());
	                //doSearch();
	            });
			});
    	
    			
    }
 	
 	function doRequest() {
 		everPopup.openApprovalRequestIPopup('CWOR0050');
    }
 
 
   
  </script>

  <e:window id="TEST0010" initData="${initData}" onReady="init" title="${fullScreenName }" breadCrumbs="${breadCrumb }">
    <e:inputHidden id='RECEIVE_BUYER_CD' name='RECEIVE_BUYER_CD' value='${form.RECEIVE_BUYER_CD}'/>
    <e:inputHidden id='RECEIVE_DEPT_CD' name='RECEIVE_DEPT_CD' value='${form.RECEIVE_DEPT_CD}'/>
    <e:inputHidden id='SEND_BUYER_CD' name='SEND_BUYER_CD' value='${form.SEND_BUYER_CD}'/>
    <e:inputHidden id='SEND_DEPT_CD' name='SEND_DEPT_CD' value='${form.SEND_DEPT_CD}'/>
    
    <!-- Button 영역 -->
  	<e:buttonBar width="100%" align="right" title="배포(승인) 대상자 및 순서">
      
      
      <e:button id="doSet" name="doSet" label="${doSet_N}" onClick="doSet" disabled="${doSet_D}" visible="${doSet_V}"/>
      <e:button id="doRequest" name="doRequest" label="${doRequest_N}" onClick="doRequest" disabled="${doRequest_D}" visible="${doRequest_V}"/>
      <e:button id="opEntrustForm" name="opEntrustForm" label="${opEntrustForm_N}" onClick="opEntrustForm" disabled="${opEntrustForm_D}" visible="${opEntrustForm_V}"/>
      <e:button id="doSave" name="doSave" label="${doSave_N}" onClick="doSave" disabled="${doSave_D}" visible="${doSave_V}"/>
    </e:buttonBar>
  	
  	<e:gridPanel gridType="${_gridType}" id="grid" name="grid" width="100%" height="223px" readOnly="${param.detailView}"/>
  	
  	<!-- 조회조건 영역 -->
  	<e:title title="일상감사의뢰서" />
    <e:searchPanel id="form" title="${form_CAPTION_N}" labelWidth="${labelWidth}" columnCount="2" useTitleBar="false" onEnter="">
      
      <e:row>
		<e:label for="RECEIVE_ADDRESS_NAME" title="${form_RECEIVE_ADDRESS_NAME_N}" />
		<e:field colSpan="3">
			<e:inputText id="RECEIVE_ADDRESS_NAME" name="RECEIVE_ADDRESS_NAME" value="${form.RECEIVE_ADDRESS_NAME}" width="${form_RECEIVE_ADDRESS_NAME_W}" maxLength="${form_RECEIVE_ADDRESS_NAME_M}" disabled="${form_RECEIVE_ADDRESS_NAME_D}" readOnly="${form_RECEIVE_ADDRESS_NAME_RO}" required="${form_RECEIVE_ADDRESS_NAME_R}" style="${imeMode}" maskType="${form_RECEIVE_ADDRESS_NAME_MT}"/>
			<e:text> </e:text><e:button id="doRecvBuyerCd" name="doRecvBuyerCd" label="${doRecvBuyerCd_N}" onClick="doRecvBuyerCd" disabled="${doRecvBuyerCd_D}" visible="${doRecvBuyerCd_V}"/>
		</e:field>
      </e:row>
      
      <e:row>
      	<e:label for="SEND_ADDRESS_NAME" title="${form_SEND_ADDRESS_NAME_N}" />
		<e:field  colSpan="3">
			<e:inputText id="SEND_ADDRESS_NAME" name="SEND_ADDRESS_NAME" value="${form.SEND_ADDRESS_NAME}" width="${form_SEND_ADDRESS_NAME_W}" maxLength="${form_SEND_ADDRESS_NAME_M}" disabled="${form_SEND_ADDRESS_NAME_D}" readOnly="${form_SEND_ADDRESS_NAME_RO}" required="${form_SEND_ADDRESS_NAME_R}" style="${imeMode}" maskType="${form_SEND_ADDRESS_NAME_MT}"/>
			<e:text> </e:text><e:button id="doSendBuyerCd" name="doSendBuyerCd" label="${doSendBuyerCd_N}" onClick="doSendBuyerCd" disabled="${doSendBuyerCd_D}" visible="${doSendBuyerCd_V}"/>
		</e:field>
      </e:row>
      
      <e:row>
      	<e:label for="FORM_TITLE" title="${form_FORM_TITLE_N}" />
		<e:field colSpan="3">
			<e:inputText id="FORM_TITLE" name="FORM_TITLE" value="${form.FORM_TITLE}" width="${form_FORM_TITLE_W}" maxLength="${form_FORM_TITLE_M}" disabled="${form_FORM_TITLE_D}" readOnly="${form_FORM_TITLE_RO}" required="${form_FORM_TITLE_R}" style="${imeMode}" maskType="${form_SEND_ADDRESS_NAME_MT}"/>
		</e:field>
      </e:row>
      
      <e:row>
      	<e:label for="REQUEST_DATE" title="${form_REQUEST_DATE_N}" />
		<e:field colSpan="3">
			<e:inputDate id="REQUEST_DATE" name="REQUEST_DATE" value="${empty form.REQUEST_DATE ? toDate : form.REQUEST_DATE}" width="${inputDateWidth}" datePicker="true" required="${form_REQUEST_DATE_R}" disabled="${form_REQUEST_DATE_D}" readOnly="${form_REQUEST_DATE_RO}" />
		</e:field>
      </e:row>
      
      <e:row>
		<e:label for="FORM_BODY" title="${form_FORM_BODY_N }" />
		<e:field colSpan="3">
            <e:richTextEditor id="FORM_BODY" name="FORM_BODY" width="100%" height="380px" value="${form.FORM_BODY }" required="${form_FORM_BODY_R }" readOnly="${form_FORM_BODY_RO }" disabled="${form_FORM_BODY_D }" useToolbar="${!param.detailView}" />
		</e:field>
	  </e:row>
    </e:searchPanel>
  </e:window>
</e:ui>
