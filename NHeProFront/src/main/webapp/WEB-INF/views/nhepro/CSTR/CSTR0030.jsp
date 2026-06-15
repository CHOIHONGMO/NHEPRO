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
	        store.setParameter("SEL_DATE", $("#SEL_DATE").val());
	        store.load(baseUrl + 'cstr0030_doSearch.so', function() {
	        	if(grid.getRowCount() == 0){
	            	EVF.alert("${msg.M0002 }");
	            }
	        });
	    }
	    
	    <%-- 고객사 조회 팝업 --%>
        function onIconClickPR_BUYER_CD() {
            var param = {
                callBackFunction: "callBackPR_BUYER_CD"
            };
            everPopup.openCommonPopup(param, "SP0066");
        }

        function callBackPR_BUYER_CD(data) {
            EVF.V("PR_BUYER_CD", data.CUST_CD);
            EVF.V("PR_BUYER_NM", data.CUST_NM);
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
	<e:window id="CSTR0030" initData="${initData}" onReady="init" title="${fullScreenName }" breadCrumbs="${breadCrumb }">
		<e:searchPanel id="form" title="${form_CAPTION_N }" labelWidth="${labelWidth}" width="100%" columnCount="3" useTitleBar="false" onEnter="doSearch">
			<e:row>
				<e:label for="" title="">
                    <select class="custom-select" id="SEL_DATE" name="SEL_DATE">
                        <option value="END" selected>${CSTR0030_001}</option>
                        <option value="STR">${CSTR0030_002}</option>
                    </select>
                </e:label>
                <e:field>
                    <e:inputDate id="FROM_DATE" name="FROM_DATE" toDate="TO_DATE" value="${FROM_DATE}" width="${inputDateWidth}" datePicker="true" required="${form_FROM_DATE_R}" disabled="${form_FROM_DATE_D}" readOnly="${form_FROM_DATE_RO}" />
                    <e:text> ~ </e:text>
                    <e:inputDate id="TO_DATE" name="TO_DATE" fromDate="FROM_DATE" value="${TO_DATE}" width="${inputDateWidth}" datePicker="true" required="${form_TO_DATE_R}" disabled="${form_TO_DATE_D}" readOnly="${form_TO_DATE_RO}" />
                </e:field>
                
				<e:label for="PR_BUYER_CD" title="${form_PR_BUYER_CD_N}"/>
                <e:field>
                    <e:search id="PR_BUYER_CD" name="PR_BUYER_CD" value="" width="40%" maxLength="${form_PR_BUYER_CD_M}" onIconClick="${form_PR_BUYER_CD_RO ? 'everCommon.blank' : 'onIconClickPR_BUYER_CD'}" disabled="${form_PR_BUYER_CD_D}" readOnly="${form_PR_BUYER_CD_RO}" required="${form_PR_BUYER_CD_R}" maskType="${form_PR_BUYER_CD_MT}" placeHolder="회사코드" />
                    <e:inputText id="PR_BUYER_NM" name="PR_BUYER_NM" value="" width="60%" maxLength="${form_PR_BUYER_NM_M}" disabled="${form_PR_BUYER_NM_D}" readOnly="${form_PR_BUYER_NM_RO}" required="${form_PR_BUYER_NM_R}" style="${imeMode}" maskType="${form_PR_BUYER_NM_MT}" placeHolder="회사명"/>
                </e:field>
                
                <e:label for="SETTEL_VENDOR_CD" title="${form_SETTEL_VENDOR_CD_N}"/>
				<e:field>
					<e:search id="SETTEL_VENDOR_CD" name="SETTEL_VENDOR_CD" value="" width="40%" maxLength="${form_SETTEL_VENDOR_CD_M}" disabled="${form_SETTEL_VENDOR_CD_D}" readOnly="${form_SETTEL_VENDOR_CD_RO}" required="${form_SETTEL_VENDOR_CD_R}" onIconClick="getVendorCd" placeHolder="회사코드" />
					<e:inputText id="SETTEL_VENDOR_NM" name="SETTEL_VENDOR_NM" value="" width="60%" maxLength="${form_SETTEL_VENDOR_NM_M}" disabled="${form_SETTEL_VENDOR_NM_D}" readOnly="${form_SETTEL_VENDOR_NM_RO}" required="${form_SETTEL_VENDOR_NM_R}" placeHolder="회사명" />
				</e:field>
			</e:row>
			<e:row>
				<e:label for="RFX_NUM" title="${form_RFX_NUM_N}" />
                <e:field>
                    <e:inputText id="RFX_NUM" name="RFX_NUM" value="" width="${form_RFX_NUM_W}" maxLength="${form_RFX_NUM_M}" disabled="${form_RFX_NUM_D}" readOnly="${form_RFX_NUM_RO}" required="${form_RFX_NUM_R}" style="${imeMode}" maskType="${form_RFX_NUM_MT}"/>
                </e:field>
                <e:label for="" title=""/>
                <e:field>
                </e:field>
                <e:label for="" title=""/>
                <e:field>
                </e:field>
			</e:row>
		</e:searchPanel>

		<e:buttonBar id="buttonBar" align="right" width="100%">
			<e:button id="Search" name="Search" label="${Search_N }" disabled="${Search_D }" visible="${Search_V}" onClick="doSearch" />
		</e:buttonBar>

		<e:gridPanel id="grid" name="grid" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}" />

	</e:window>
</e:ui>