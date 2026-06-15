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
	        store.load(baseUrl + 'cstr0020_doSearch.so', function() {
	        	if(grid.getRowCount() == 0){
	            	EVF.alert("${msg.M0002 }");
	            }
	        	
				grid.setColMerge(["PO_NUM","CONT_NM"]);
				
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
		
		//2024.03.14
		//중앙회 IT전략본부 구매팀 요청으로 조회조건 지불고객사 및 부서 추가
		function onIconClickBUYER_CD() {
            var param = {
                callBackFunction: "callBackBUYER_CD"
            };
            everPopup.openCommonPopup(param, "SP0066");
        }

        function callBackBUYER_CD(data) {
            EVF.V("BUYER_CD", data.CUST_CD);
            EVF.V("BUYER_NM", data.CUST_NM);
        }
        
        function onIconClicKDEPT_CD() {

			var param = {
				callBackFunction: "callBackDEPT_CD"
			};
			everPopup.openCommonPopup(param, 'SP0119');
		}

		function callBackDEPT_CD(data) {
			EVF.V("DEPT_CD", data.DEPT_CD);
			EVF.V("DEPT_NM", data.DEPT_NM);
		}
		
        function onIconClickPIC_USER_ID() {
        	var param = {
					'callBackFunction': 'callBackPIC_USER_ID',
					'READONLY': 'N',		//팝업 조회조건 변경불가
					'multiYN' : 'N',        //멀티팝업여부
					'CTRL_CD' : 'BR020',	//검수/입고 담당자권한(=기본권한으로 변경)
					'detailView': false
			};
			everPopup.openPopupByScreenId("CCDU0020", 1100, 700, param);
        }

        function callBackPIC_USER_ID(data) {
        	if(data!=null){
				data = JSON.parse(data);
	            EVF.V("PIC_USER_ID", data.USER_ID);
	            EVF.V("PIC_USER_NM", data.USER_NM);
        	}
        }
        
        function onIconClickCTRL_USER_ID() {
        	var param = {
					'callBackFunction': 'callBackCTRL_USER_ID',
					'READONLY': 'Y',		//팝업 조회조건 변경불가
					'multiYN' : 'N',        //멀티팝업여부
					'CTRL_CD' : 'BR030',	//구매담당자권한
					'detailView': false
			};
			everPopup.openPopupByScreenId("CCDU0020", 1100, 700, param);
        }

        function callBackCTRL_USER_ID(data) {
        	if(data!=null){
				data = JSON.parse(data);
	            EVF.V("CTRL_USER_ID", data.USER_ID);
	            EVF.V("CTRL_USER_NM", data.USER_NM);
        	}
        }        

    </script>
	<e:window id="CSTR0020" initData="${initData}" onReady="init" title="${fullScreenName }" breadCrumbs="${breadCrumb }">
		<e:searchPanel id="form" title="${form_CAPTION_N }" labelWidth="${labelWidth}" width="100%" columnCount="3" useTitleBar="false" onEnter="doSearch">
			<e:row>
				<e:label for="PO_CREATE_DATE_FROM" title="${form_PO_CREATE_DATE_FROM_N}" />
				<e:field>
					<e:inputDate id="PO_CREATE_DATE_FROM" name="PO_CREATE_DATE_FROM" toDate="PO_CREATE_DATE_TO" value="${fromDate }" width="${inputDateWidth }" required="${form_PO_CREATE_DATE_FROM_R}" disabled="${form_PO_CREATE_DATE_FROM_D}" readOnly="${form_PO_CREATE_DATE_FROM_RO}" datePicker="true" />
					<e:text>~&nbsp;</e:text>
					<e:inputDate id="PO_CREATE_DATE_TO" name="PO_CREATE_DATE_TO" fromDate="PO_CREATE_DATE_FROM" value="${toDate }" width="${inputDateWidth }" required="${form_PO_CREATE_DATE_TO_R}" disabled="${form_PO_CREATE_DATE_TO_D}" readOnly="${form_PO_CREATE_DATE_TO_RO}" datePicker="true" />
				</e:field>
				<e:label for="PO_NUM" title="${form_PO_NUM_N}"/>
				<e:field>
					<e:inputText id="PO_NUM" name="PO_NUM" value="" width="${form_PO_NUM_W}" maxLength="${form_PO_NUM_M}" disabled="${form_PO_NUM_D}" readOnly="${form_PO_NUM_RO}" required="${form_PO_NUM_R}" />
				</e:field>
				<e:label for="CONT_NUM" title="${form_CONT_NUM_N}"/>
				<e:field>
					<e:inputText id="CONT_NUM" name="CONT_NUM" value="" width="${form_CONT_NUM_W}" maxLength="${form_CONT_NUM_M}" disabled="${form_CONT_NUM_D}" readOnly="${form_CONT_NUM_RO}" required="${form_CONT_NUM_R}" />
				</e:field>
			</e:row>
			<e:row>
				<e:label for="BUYER_CD" title="${form_BUYER_CD_N}"/>
				<e:field>
					<e:search id="BUYER_CD" name="BUYER_CD" value="${ses.companyCd}" width="40%" maxLength="${form_BUYER_CD_M}" disabled="${form_BUYER_CD_D}" readOnly="${form_BUYER_CD_RO}" required="${form_BUYER_CD_R}" onIconClick="${form_BUYER_CD_RO ? 'everCommon.blank' : 'onIconClickBUYER_CD'}" placeHolder="회사코드" />
					<e:inputText id="BUYER_NM" name="BUYER_NM" value="${ses.companyNm}" width="60%" maxLength="${form_BUYER_NM_M}" disabled="${form_BUYER_NM_D}" readOnly="${form_BUYER_NM_RO}" required="${form_BUYER_NM_R}" placeHolder="회사명" />
				</e:field>
				<e:label for="DEPT_CD" title="${form_DEPT_CD_N}"/>
				<e:field>
					<e:search id="DEPT_CD" name="DEPT_CD" value="" width="40%" maxLength="${form_DEPT_CD_M}" onIconClick="${form_DEPT_CD_RO ? 'everCommon.blank' : 'onIconClicKDEPT_CD'}" disabled="${form_DEPT_CD_D}" readOnly="${form_DEPT_CD_RO}" required="${form_DEPT_CD_R}" maskType="${form_DEPT_CD_MT}" placeHolder="부서코드" />
					<e:inputText id="DEPT_NM" name="DEPT_NM" value="" width="60%" maxLength="${form_DEPT_NM_M}" disabled="${form_DEPT_NM_D}" readOnly="${form_DEPT_NM_RO}" required="${form_DEPT_NM_R}" style="${imeMode}" maskType="${form_DEPT_NM_MT}" placeHolder="부서명"/>
				</e:field>
				<e:label for="SETTEL_VENDOR_CD" title="${form_SETTEL_VENDOR_CD_N}"/>
				<e:field>
					<e:search id="SETTEL_VENDOR_CD" name="SETTEL_VENDOR_CD" value="" width="40%" maxLength="${form_SETTEL_VENDOR_CD_M}" disabled="${form_SETTEL_VENDOR_CD_D}" readOnly="${form_SETTEL_VENDOR_CD_RO}" required="${form_SETTEL_VENDOR_CD_R}" onIconClick="getVendorCd" placeHolder="회사코드" />
					<e:inputText id="SETTEL_VENDOR_NM" name="SETTEL_VENDOR_NM" value="" width="60%" maxLength="${form_SETTEL_VENDOR_NM_M}" disabled="${form_SETTEL_VENDOR_NM_D}" readOnly="${form_SETTEL_VENDOR_NM_RO}" required="${form_SETTEL_VENDOR_NM_R}" placeHolder="회사명" />
				</e:field>
			</e:row>
			<e:row>
				<e:label for="PROGRESS_NM" title="${form_PROGRESS_NM_N}"/>
                <e:field>
                    <e:select id="PROGRESS_NM" name="PROGRESS_NM" value="" options="${progressNmOptions}" width="${form_PROGRESS_NM_W}" disabled="${form_PROGRESS_NM_D}" readOnly="${form_PROGRESS_NM_RO}" required="${form_PROGRESS_NM_R}" placeHolder="선택" maskType="${form_PROGRESS_NM_MT}" />
                </e:field>
                <e:label for="PIC_USER_ID" title="${form_PIC_USER_ID_N}" />
                <e:field>
                    <e:search id="PIC_USER_ID" name="PIC_USER_ID" value="" width="${form_PIC_USER_ID_W}%" maxLength="${form_PIC_USER_ID_M}" onIconClick="${form_PIC_USER_ID_RO ? 'everCommon.blank' : 'onIconClickPIC_USER_ID'}" disabled="${form_PIC_USER_ID_D}" readOnly="${form_PIC_USER_ID_RO}" required="${form_PIC_USER_ID_R}" maskType="${form_PIC_USER_ID_MT}" placeHolder="개인번호" />
                    <e:inputText id="PIC_USER_NM" name="PIC_USER_NM" value="" width="${form_PIC_USER_NM_W}%" maxLength="${form_PIC_USER_NM_M}" disabled="${form_PIC_USER_NM_D}" readOnly="${form_PIC_USER_NM_RO}" required="${form_PIC_USER_NM_R}" style="${imeMode}" maskType="${form_PIC_USER_NM_MT}" placeHolder="성명"/>
                </e:field>
				<e:label for="CTRL_USER_ID" title="${form_CTRL_USER_ID_N}"/>
				<e:field>
					<e:search id="CTRL_USER_ID" name="CTRL_USER_ID" value="" width="${form_CTRL_USER_ID_W}%" maxLength="${form_CTRL_USER_ID_M}" onIconClick="${form_CTRL_USER_ID_RO ? 'everCommon.blank' : 'onIconClickCTRL_USER_ID'}" disabled="${form_CTRL_USER_ID_D}" readOnly="${form_CTRL_USER_ID_RO}" required="${form_CTRL_USER_ID_R}" maskType="${form_CTRL_USER_ID_MT}" placeHolder="개인번호" />
					<e:inputText id="CTRL_USER_NM" name="CTRL_USER_NM" value="" width="${form_CTRL_USER_NM_W}%" maxLength="${form_CTRL_USER_NM_M}" disabled="${form_CTRL_USER_NM_D}" readOnly="${form_CTRL_USER_NM_RO}" required="${form_CTRL_USER_NM_R}" style="${imeMode}" maskType="${form_CTRL_USER_NM_MT}" placeHolder="성명"/>
				</e:field>
			</e:row>			
		</e:searchPanel>

		<e:buttonBar id="buttonBar" align="right" width="100%">
			<e:button id="Search" name="Search" label="${Search_N }" disabled="${Search_D }" visible="${Search_V}" onClick="doSearch" />
		</e:buttonBar>

		<e:gridPanel id="grid" name="grid" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}" />

	</e:window>
</e:ui>