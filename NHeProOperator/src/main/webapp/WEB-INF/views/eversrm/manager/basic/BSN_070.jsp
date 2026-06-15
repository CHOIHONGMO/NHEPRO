<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
    <script type="text/javascript">

        var grid = {};
        var grid2 = {};
    	var addParam = [];
    	var baseUrl = "/eversrm/manager/basic/";

		function init() {

			grid = EVF.C('grid');

            grid.setColIconify("CONTENTS", "CONTENTS", "detail", false); //첨부파일 아이콘

            grid.excelExportEvent({
                allItems : "${excelExport.allCol}",
                fileName : "${screenName }"
            });

			grid.showCheckBar(false);
			
	        grid.cellClickEvent(function(rowIdx, colIdx, value) {
	        	if(colIdx == "CONTENTS") {
					var param = {
						sendType : grid.getCellValue (rowIdx,'SEND_TYPE')
					   ,sendId : grid.getCellValue(rowIdx,'SEND_ID')
					   ,recEmail : grid.getCellValue(rowIdx,'EMAIL')
					   ,sendEmail : grid.getCellValue(rowIdx,'SEND_EMAIL')
					   ,detailView : true
					};
					everPopup.openPopupByScreenId('BSN_080', 1400, 600, param);
	            }
			});

			grid.setProperty('shrinkToFit', true);					// 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
			grid.setProperty('rowNumbers', ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
			grid.setProperty('sortable', ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
			grid.setProperty('panelVisible', ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
			grid.setProperty('enterToNextRow', ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
			grid.setProperty('acceptZero', ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
			grid.setProperty('multiSelect', false);					// [선택] 컬럼의 사용여부를 지정한다. [true/false]
			grid.setProperty('singleSelect', ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]
        }
        
        function search() {
            var store = new EVF.Store();
            if(!store.validate()) return;    
        	store.setGrid([grid]);
            store.load(baseUrl + 'BSN_070/doSearch.so', function() {
                if(grid.getRowCount() == 0){
                	EVF.alert("${msg.M0002 }");
                }                
            });
        } 

    </script>

    <e:window id="BSN_070" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">
 			
        <e:searchPanel id="form" title="${form_CAPTION_N }" labelWidth="${labelWidth}" width="100%" columnCount="3" useTitleBar="false" onEnter="search">
            <e:row>
				<e:label for="startDate" title="${form_startDate_N}"/>
				<e:field>
					<e:inputDate id="startDate" name="startDate" value="${fromDate}" width="${inputDateWidth}" datePicker="true" required="${form_startDate_R}" disabled="${form_startDate_D}" readOnly="${form_startDate_RO}" />
					<e:text>~</e:text>
					<e:inputDate id="endDate" name="endDate" value="${toDate}" width="${inputDateWidth}" datePicker="true" required="${form_endDate_R}" disabled="${form_endDate_D}" readOnly="${form_endDate_RO}" />
				</e:field>
				<e:label for="SEND_TYPE" title="${form_SEND_TYPE_N}"/>
				<e:field>
					<e:select id="SEND_TYPE" name="SEND_TYPE" value="${form.SEND_TYPE}" options="${sendTypeOptions}" width="${form_SEND_TYPE_W}" disabled="${form_SEND_TYPE_D}" readOnly="${form_SEND_TYPE_RO}" required="${form_SEND_TYPE_R}" placeHolder=""  maskType="${form_SEND_TYPE_MT}"/>
				</e:field>
				<e:label for="SEND_USER_ID" title="${form_SEND_USER_ID_N}"/>
				<e:field>
					<e:inputText id="SEND_USER_ID" name="SEND_USER_ID" value="${form.SEND_USER_ID}" width="${form_SEND_USER_ID_W}" maxLength="${form_SEND_USER_ID_M}" disabled="${form_SEND_USER_ID_D}" readOnly="${form_SEND_USER_ID_RO}" required="${form_SEND_USER_ID_R}"  maskType="${form_SEND_USER_ID_MT}" />
				</e:field>
 			</e:row>			
            <e:row>
				<e:label for="RECV_USER_ID" title="${form_RECV_USER_ID_N}"/>
				<e:field>
					<e:inputText id="RECV_USER_ID" name="RECV_USER_ID" value="${form.RECV_USER_ID}" width="${form_RECV_USER_ID_W}" maxLength="${form_RECV_USER_ID_M}" disabled="${form_RECV_USER_ID_D}" readOnly="${form_RECV_USER_ID_RO}" required="${form_RECV_USER_ID_R}"  maskType="${form_RECV_USER_ID_MT}" />
			 	</e:field>
				<e:label for="VENDOR_NM" title="${form_VENDOR_NM_N}"/>
				<e:field colSpan="3">
					<e:inputText id="VENDOR_NM" name="VENDOR_NM" value="${form.VENDOR_NM}" width="${form_VENDOR_NM_W}" maxLength="${form_VENDOR_NM_M}" disabled="${form_VENDOR_NM_D}" readOnly="${form_VENDOR_NM_RO}" required="${form_VENDOR_NM_R}"  maskType="${form_VENDOR_NM_MT}" />
				</e:field>
 	 		</e:row>			
		</e:searchPanel>
		
        <e:buttonBar id="buttonBar" align="right" width="100%">
            <e:button id="doSearch" name="doSearch" label="${doSearch_N }" disabled="${doSearch_D }" onClick="search" />
        </e:buttonBar>

    	<e:gridPanel gridType="${_gridType}" id="grid" name="grid" width="100%" height="fit"  readOnly="${param.detailView}"/>

    </e:window>
</e:ui>