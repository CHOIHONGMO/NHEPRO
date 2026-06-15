<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
    <script type="text/javascript">

        var grid1 = {};
        var addParam = [];
        var baseUrl = "/eversrm/master/user/";

        function init() {

            grid1 = EVF.C('grid1');

            grid1.setProperty('shrinkToFit', ${shrinkToFit});		// 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
            grid1.setProperty('rowNumbers', ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
            grid1.setProperty('sortable', ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
            grid1.setProperty('panelVisible', ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            grid1.setProperty('enterToNextRow', ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            grid1.setProperty('acceptZero', ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            grid1.setProperty('multiSelect', false);		        // [선택] 컬럼의 사용여부를 지정한다. [true/false]
			
            grid1.cellClickEvent(function(rowIdx, colIdx, value) {

	            if(colIdx == "JOB_CONTENTS") {
	        		if(value == "") return;
        			var param = {
    						title: "개인정보 조회내용",
    						message: grid1.getCellValue(rowIdx, 'JOB_CONTENTS')
    					};
   					everPopup.commonTextView(param);
	        	}
			});
            
            grid1.excelExportEvent({
                allItems : "${excelExport.allCol}",
                fileName : "${screenName }"
            });
        }

        function search() {

            var store = new EVF.Store();
            if(!store.validate()) return;
            store.setGrid([grid1]);
            store.load(baseUrl + 'MTUB0010/doSearch.so', function() {
                if(grid1.getRowCount() == 0){
                    EVF.alert("${msg.M0002 }");
                } else {
                	grid1.setColIconify("JOB_CONTENTS", "JOB_CONTENTS", "comment", false);
                }
            });
        }

    </script>
    <e:window id="MTUB0010" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">

    <e:inputHidden id="FAIL_TYPE" name="FAIL_TYPE" visible="" />

        <e:searchPanel id="form" title="${form_CAPTION_N }" labelWidth="${labelWidth}" width="100%" columnCount="3" onEnter="search" useTitleBar="false">
            <e:row>
                <e:label for="ADD_DATE_FROM" title="${form_ADD_DATE_FROM_N }" />
                <e:field>
                    <e:inputDate id="ADD_DATE_FROM" name="ADD_DATE_FROM" value="${fromDate }" width="${inputDateWidth}" datePicker="true" required="${form_ADD_DATE_FROM_R}" disabled="${form_ADD_DATE_FROM_D}" readOnly="${form_ADD_DATE_FROM_RO}" />
                    <e:text>~</e:text>
                    <e:inputDate id="ADD_DATE_TO" name="ADD_DATE_TO" value="${toDate }" width="${inputDateWidth}" datePicker="true" required="${form_ADD_DATE_TO_R}" disabled="${form_ADD_DATE_TO_D}" readOnly="${form_ADD_DATE_TO_RO}" />
                </e:field>
                <e:label for="JOB_TYPE" title="${form_JOB_TYPE_N }" />
                <e:field>
                    <e:select id="JOB_TYPE" name="JOB_TYPE"  value="" readOnly="${form_JOB_TYPE_RO }"  options="${jobTypeOptions}" width="${form_JOB_TYPE_W }" required="${form_JOB_TYPE_R }" disabled="${form_JOB_TYPE_D }" onFocus="onFocus"   placeHolder="" usePlaceHolder="false" useMultipleSelect="true"  maskType="${form_JOB_TYPE_MT}"/>
                </e:field>
                <e:label for="USER_ID" title="${form_USER_ID_N }" />
                <e:field>
                    <e:inputText id="USER_ID" name="USER_ID"  maxLength="${form_USER_ID_M}" readOnly="${form_USER_ID_RO }" value="" width="${form_USER_ID_W }" required="${form_USER_ID_N }" disabled="${form_USER_ID_D }"  maskType="${form_USER_ID_MT}" />
                </e:field>
            </e:row>
            <e:row>
                <e:label for="USER_NM" title="${form_USER_NM_N }" />
                <e:field>
                    <e:inputText id="USER_NM" name="USER_NM" value=""  readOnly="${form_USER_NM_RO }" maxLength="${form_USER_NM_M}" width="${form_USER_NM_W }" required="${form_USER_NM_R }" disabled="${form_USER_NM_D }" onFocus="onFocus"  maskType="${form_USER_NM_MT}" />
                </e:field>
                <e:label for="USER_TYPE" title="${form_USER_TYPE_N }" />
                <e:field>
                    <e:select id="USER_TYPE" name="USER_TYPE" value="" readOnly="${form_USER_TYPE_RO }" options="${userTypeOptions}" width="${form_USER_TYPE_W }" required="${form_USER_TYPE_R }" disabled="${form_USER_TYPE_D }" onFocus="onFocus"  placeHolder="" maskType="${form_USER_TYPE_MT}"/>
                </e:field>
                <e:label for="IP_ADDR" title="${form_IP_ADDR_N }" />
                <e:field>
                    <e:inputText id="IP_ADDR" name="IP_ADDR" value=""   readOnly="${form_IP_ADDR_RO }"   maxLength="${form_IP_ADDR_M}"  width="${form_IP_ADDR_W }" required="${form_IP_ADDR_R }" disabled="${form_IP_ADDR_D }" onFocus="onFocus"  maskType="${form_IP_ADDR_MT}" />
                </e:field>
            </e:row>
            <e:row>
                <e:label for="MODULE_NM" title="${form_MODULE_NM_N }" />
                <e:field>
                    <e:inputText id="MODULE_NM" name="MODULE_NM"  readOnly="${form_MODULE_NM_RO }"  maxLength="${form_MODULE_NM_M}"  value="" width="${form_MODULE_NM_W }" required="${form_MODULE_NM_N }" disabled="${form_MODULE_NM_N }"  maskType="${form_MODULE_NM_MT}" />
                </e:field>
                <e:label for="METHOD_NM" title="${form_METHOD_NM_N }" />
                <e:field>
                    <e:inputText id="METHOD_NM" name="METHOD_NM"   readOnly="${form_METHOD_NM_RO }"   value=""  maxLength="${form_METHOD_NM_M}"  width="${form_METHOD_NM_W }" required="${form_METHOD_NM_R }" disabled="${form_METHOD_NM_D }" onFocus="onFocus"  maskType="${form_METHOD_NM_MT}" />
                </e:field>
                <e:label for="JOB_DESC" title="${form_JOB_DESC_N }" />
                <e:field>
                    <e:inputText id="JOB_DESC" name="JOB_DESC"  value=""  readOnly="${form_JOB_DESC_RO }"   maxLength="${form_JOB_DESC_M}"  width="${form_JOB_DESC_W }" required="${form_JOB_DESC_N }" disabled="${form_JOB_DESC_N }"  maskType="${form_JOB_DESC_MT}" />
                </e:field>
            </e:row>
            <e:row>
                <e:label for="SCREEN_ID" title="${form_SCREEN_ID_N }" />
                <e:field>
                    <e:inputText id="SCREEN_ID" name="SCREEN_ID" readOnly="${form_SCREEN_ID_RO }"  value=""  maxLength="${form_SCREEN_ID_M}"  width="${form_SCREEN_ID_W }" required="${form_SCREEN_ID_R }" disabled="${form_SCREEN_ID_D }" onFocus="onFocus"  maskType="${form_SCREEN_ID_MT}" />
                </e:field>
                <e:label for="ACTION_CD" title="${form_ACTION_CD_N }" />
                <e:field>
                    <e:inputText id="ACTION_CD" name="ACTION_CD"  readOnly="${form_ACTION_CD_RO }"   value=""  maxLength="${form_ACTION_CD_M}"   width="${form_ACTION_CD_W }" required="${form_ACTION_CD_N }" disabled="${form_ACTION_CD_N }"  maskType="${form_ACTION_CD_MT}" />
                </e:field>
                <e:label for="BUYER_CD" title="${form_BUYER_CD_N}"/>
				<e:field>
				<e:select id="BUYER_CD" name="BUYER_CD" value="" options="${buyerCdOptions}" width="200" disabled="${form_BUYER_CD_D}" readOnly="${form_BUYER_CD_RO}" required="${form_BUYER_CD_R}" placeHolder="" maskType="${form_BUYER_CD_MT}" />
				</e:field>
            </e:row>


        </e:searchPanel>

        <e:buttonBar id="buttonBar" align="right" width="100%">
            <e:button id="doSearch" name="doSearch" label="${doSearch_N }" disabled="${doSearch_D }" onClick="search" />
        </e:buttonBar>

        <e:gridPanel gridType="${_gridType}" id="grid1" name="grid1" width="100%" height="fit" readOnly="${param.detailView}" />

    </e:window>
</e:ui>