<%--
  Date: 2020-06-10
  Time: 15:01:18
  Scrren ID : TEST0030
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}"
	dateFmt="${ses.dateFormat}">
	<script>

    var grid;
    var baseUrl = '/nhepro/TEST/TEST0030';

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
    	
   // 	doSearch();
    }
      
    function doSearch() {
    	
    	
    	var store = new EVF.Store();
    	if(!store.validate()) { return; }
        store.setGrid([grid]);
        store.load(baseUrl + '/test0030_doSearch.so', function() {
        	if(grid.getRowCount() == 0){
                EVF.alert("${msg.M0002 }");
            }
        	grid.setColIconify("REJECT_RMK", "REJECT_RMK", "comment", false);
        	grid.setColIconify("CANCEL_RMK", "CANCEL_RMK", "comment", false);
        });
    }
    
    
    function doHistory(){
    	var	param = {	
		
    		detailView : false
		};
    	everPopup.openPopupByScreenId("TEST0040", 1100, 700, param);  	
    }
    
    function doDetail(){
    	var screenId = 'TEST0050'
    		top.pageRedirectByScreenId(screenId);
    	
    }
    
    function doCreate(){
    	var screenId = 'TEST0010'
    		top.pageRedirectByScreenId(screenId);
    }

  </script>

	<e:window id="TEST0030" initData="${initData}" onReady="init"
		title="${fullScreenName }" breadCrumbs="${breadCrumb }">
		<!-- 조회조건 영역 -->
		<e:buttonBar id="buttonBar" align="right" width="100%" title="조회 조건">
			<e:button id="doSearch" name="doSearch" label="${doSearch_N}"
				onClick="doSearch" disabled="${doSearch_D}" visible="${doSearch_V}" />
		</e:buttonBar>

		<e:searchPanel id="form" title="조회 조건" labelWidth="135" width="100%"
			columnCount="3" useTitleBar="false" onEnter="doSearch">
			<e:row>
				<e:label for="FORM_ID" title="${form_FORM_ID_N}" />
				<e:field>
					<e:select id="FORM_ID" name="FORM_ID" value=""
						options="${FORM_IDOptions}" width="100%" disabled="${form_FORM_ID_D}"
						readOnly="${form_FORM_ID_RO}" required="${form_FORM_ID_R}"
						placeHolder="" maskType="${form_FORM_ID_MT}"
						useMultipleSelect="true" />
				</e:field>
				<e:label for="FORM_TITLE" title="${form_FORM_TITLE_N}" />
				<e:field>
					<e:inputText id="FORM_TITLE" name="FORM_TITLE" value=""
						width="100%" maxLength="${form_FORM_TITLE_M}"
						disabled="${form_FORM_TITLE_D}" readOnly="${form_FORM_TITLE_RO}"
						required="${form_FORM_TITLE_R}" style="${imeMode}"
						maskType="${form_FORM_TITLE_MT}" />
				</e:field>
				<e:label for="FSRGID" title="${form_FSRGID_N}" />
				<e:field>
					<e:inputText id="FSRGID" name="FSRGID" value="" width="100%"
						maxLength="${form_FSRGID_M}" disabled="${form_FSRGID_D}"
						readOnly="${form_FSRGID_RO}" required="${form_FSRGID_R}"
						style="${imeMode}" maskType="${form_FSRGID_MT}" />
				</e:field>
			</e:row>
			<e:row>
				<e:label for="REQUEST_DATE_FROM" title="승인요청일자" />
				<e:field>
					<e:inputDate id="REQUEST_DATE_FROM" name="REQUEST_DATE_FROM"
						value="${fromDate}" width="${inputDateWidth}" datePicker="true"
						required="${form_REQUEST_DATE_FROM_R}"
						disabled="${form_REQUEST_DATE_FROM_D}"
						readOnly="${form_REQUEST_DATE_FROM_RO}" />
					<e:text>~</e:text>
					<e:inputDate id="REQUEST_DATE_TO" name="REQUEST_DATE_TO" value="${toDate}"
						width="${inputDateWidth}" datePicker="true"
						required="${form_REQUEST_DATE_TO_R}" disabled="${form_REQUEST_DATE_TO_D}"
						readOnly="${form_REQUEST_DATE_TO_RO}" />
				</e:field>
				<e:label for="APPROVAL_STATE" title="${form_APPROVAL_STATE_N}" />
				<e:field>
					<e:select id="APPROVAL_STATE" name="APPROVAL_STATE" value=""
						options="${plStateCodeOptions}" width="100%"
						disabled="${form_APPROVAL_STATE_D}"
						readOnly="${form_APPROVAL_STATE_RO}"
						required="${form_APPROVAL_STATE_R}" placeHolder=""
						maskType="${form_APPROVAL_STATE_MT}" useMultipleSelect="true" />
				</e:field>
				<e:label for="APPROVAL_NAME" title="${form_APPROVAL_NAME_N}" />
				<e:field>
					<e:inputText id="APPROVAL_NAME" name="APPROVAL_NAME" value=""
						width="100%" maxLength="${form_APPROVAL_NAME_M}"
						disabled="${form_APPROVAL_NAME_D}"
						readOnly="${form_APPROVAL_NAME_RO}"
						required="${form_APPROVAL_NAME_R}" style="${imeMode}"
						maskType="${form_APPROVAL_NAME_MT}" />
				</e:field>
			</e:row>
		</e:searchPanel>

		<!-- Button 영역 -->
		<e:buttonBar width="100%" align="right" title="조회 목록">
			<e:button id="doHistory" name="doHistory" label="${doHistory_N}"
				onClick="doHistory" disabled="${doHistory_D}"
				visible="${doHistory_V}" />
			<e:button id="doDetail" name="doDetail" label="${doDetail_N}"
				onClick="doDetail" disabled="${doDetail_D}" visible="${doDetail_V}" />
			<e:button id="doCreate" name="doCreate" label="${doCreate_N}"
				onClick="doCreate" disabled="${doCreate_D}" visible="${doCreate_V}" />
		</e:buttonBar>

		<!-- Grid 영역 -->

		<e:gridPanel id="grid" name="grid" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}"/>
	</e:window>
</e:ui>
