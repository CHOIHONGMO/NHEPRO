<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page import="com.st_ones.everf.serverside.config.PropertiesManager" %>


<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">

	<script type="text/javascript">

	    var grid;
		var baseUrl = "/nhepro/CSTR/";
		
	    function init() {

	        grid = EVF.C("grid");

	        grid.excelExportEvent({
				allItems : "${excelExport.allCol}",
				fileName : "${screenName }"
			});

			grid.setProperty('shrinkToFit', ${shrinkToFit});		// 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
			grid.setProperty('rowNumbers', ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
			grid.setProperty('sortable', ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
			grid.setProperty('panelVisible', ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
			grid.setProperty('enterToNextRow', ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
			grid.setProperty('acceptZero', ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
			grid.setProperty('singleSelect', false);					// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]
			grid.setProperty('multiSelect', false);		// [선택] 컬럼의 사용여부를 지정한다. [true/false]
			
			
			doSearch();
		}

	    function doSearch() {

	    	var store = new EVF.Store();
			if(!store.validate()) { return; }

	        store.setGrid([grid]);
	        store.load(baseUrl + 'cstr0010_doSearch.so', function() {
	        	if(grid.getRowCount() == 0){
	            	EVF.alert("${msg.M0002 }");
	            }
	        	
				grid.setColMerge(["ANN_DATE","ANN_NO","BID_NUM","BID_CNT","ANN_ITEM","CONT_TYPE1_NM","CONT_TYPE2_NM","PURCHASE_TYPE_NM","PR_AMT","TCO_FLAG","FINAL_ESTM_PRC","CONT_AMT","CONT_NUM_CNT"]);
				
	        });
	    }

		function getVendorCd() {

			var param = {
				BUYER_CD : "${ses.companyCd}",
				callBackFunction : "setVendorCd"
			};
			everPopup.openCommonPopup(param, 'SP0123');
		}

		function setVendorCd(data) {
			EVF.V("SETTEL_VENDOR_CD", data.VENDOR_CD);
			EVF.V("SETTEL_VENDOR_NM", data.VENDOR_NM);
		}

		function cleanVendorCd() {
			EVF.V("SETTEL_VENDOR_CD", "");
		}

    </script>
	<e:window id="CSTR0010" initData="${initData}" onReady="init" title="${fullScreenName }" breadCrumbs="${breadCrumb }">
		<e:searchPanel id="form" title="${form_CAPTION_N }" labelWidth="${labelWidth}" width="100%" columnCount="3" useTitleBar="false" onEnter="doSearch">
			<e:row>
				<e:label for="ANN_DATE_FROM" title="${form_ANN_DATE_FROM_N}" />
				<e:field>
					<e:inputDate id="ANN_DATE_FROM" name="ANN_DATE_FROM" toDate="ANN_DATE_TO" value="${fromDate }" width="${inputDateWidth }" required="${form_ANN_DATE_FROM_R}" disabled="${form_ANN_DATE_FROM_D}" readOnly="${form_ANN_DATE_FROM_RO}" datePicker="true" />
					<e:text>~&nbsp;</e:text>
					<e:inputDate id="ANN_DATE_TO" name="ANN_DATE_TO" fromDate="ANN_DATE_FROM" value="${toDate }" width="${inputDateWidth }" required="${form_ANN_DATE_TO_R}" disabled="${form_ANN_DATE_TO_D}" readOnly="${form_ANN_DATE_TO_RO}" datePicker="true" />
				</e:field>
				<e:label for="SETTEL_VENDOR_CD" title="${form_SETTEL_VENDOR_CD_N}"/>
				<e:field>
					<e:search id="SETTEL_VENDOR_CD" name="SETTEL_VENDOR_CD" value="" width="40%" maxLength="${form_SETTEL_VENDOR_CD_M}" disabled="${form_SETTEL_VENDOR_CD_D}" readOnly="${form_SETTEL_VENDOR_CD_RO}" required="${form_SETTEL_VENDOR_CD_R}" onIconClick="getVendorCd" placeHolder="회사코드" />
					<e:inputText id="SETTEL_VENDOR_NM" name="SETTEL_VENDOR_NM" value="" width="60%" maxLength="${form_SETTEL_VENDOR_NM_M}" disabled="${form_SETTEL_VENDOR_NM_D}" readOnly="${form_SETTEL_VENDOR_NM_RO}" required="${form_SETTEL_VENDOR_NM_R}" placeHolder="회사명" />
				</e:field>
				<e:label for="CONT_TYPE1" title="${form_CONT_TYPE1_N}"/>
				<e:field>
					<e:select id="CONT_TYPE1" name="CONT_TYPE1" value="" options="${contType1Options}" width="${form_CONT_TYPE1_W}" disabled="${form_CONT_TYPE1_D}" readOnly="${form_CONT_TYPE1_RO}" required="${form_CONT_TYPE1_R}" placeHolder="" maskType="${form_CONT_TYPE1_MT}" />
				</e:field>
			</e:row>
			<e:row>
				<e:label for="ANN_NO" title="${form_ANN_NO_N}"/>
				<e:field>
					<e:inputText id="ANN_NO" name="ANN_NO" value="" width="${form_ANN_NO_W}" maxLength="${form_ANN_NO_M}" disabled="${form_ANN_NO_D}" readOnly="${form_ANN_NO_RO}" required="${form_ANN_NO_R}" />
				</e:field>
				<e:label for="ANN_ITEM" title="${form_ANN_ITEM_N}"/>
				<e:field>
					<e:inputText id="ANN_ITEM" name="ANN_ITEM" value="" width="${form_ANN_ITEM_W}" maxLength="${form_ANN_ITEM_M}" disabled="${form_ANN_ITEM_D}" readOnly="${form_ANN_ITEM_RO}" required="${form_ANN_ITEM_R}" />
				</e:field>
				<e:label for="BID_NUM" title="${form_BID_NUM_N}"/>
				<e:field>
					<e:inputText id="BID_NUM" name="BID_NUM" value="" width="${form_BID_NUM_W}" maxLength="${form_BID_NUM_M}" disabled="${form_BID_NUM_D}" readOnly="${form_BID_NUM_RO}" required="${form_BID_NUM_R}" />
				</e:field>
			</e:row>
		</e:searchPanel>

		<e:buttonBar id="buttonBar" align="right" width="100%">
			<e:button id="Search" name="Search" label="${Search_N }" disabled="${Search_D }" visible="${Search_V}" onClick="doSearch" />
		</e:buttonBar>

		<e:gridPanel id="grid" name="grid" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}" />

	</e:window>
</e:ui>