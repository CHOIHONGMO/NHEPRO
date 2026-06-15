<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">

	<script type="text/javascript">

	    var grid;
	    var baseUrl = "/nhepro/SRQR/";
	    var eventRowId = 0;

	    function init() {

	        grid = EVF.C("grid");

	        grid.cellClickEvent(function(rowId, colId, value) {
	        	if(colId == "RFX_NUM") {
	        		var param = {
	                        callbackFunction: "",
	                        BUYER_CD: grid.getCellValue(rowId, 'BUYER_CD'),
	                        RFX_NUM: grid.getCellValue(rowId, 'RFX_NUM'),
	        				RFX_CNT: grid.getCellValue(rowId, 'RFX_CNT'),
	                        detailView: true,
	                        buttonView: false
	                    };
                    everPopup.openPopupByScreenId("SRQR0012", 1200, 800, param);
				}
	        	if(colId == "QTA_NUM") {
	        		if (grid.getCellValue(rowId,'QTA_NUM') == '') return;
	    	        var param = {
	    	        		BUYER_CD: grid.getCellValue(rowId, 'BUYER_CD'),
		    	        	RFX_NUM: grid.getCellValue(rowId, 'RFX_NUM'),
		    	        	RFX_CNT: grid.getCellValue(rowId, 'RFX_CNT'),
		    	        	QTA_NUM : grid.getCellValue(rowId, 'QTA_NUM'),
		    	        	RFX_TYPE : grid.getCellValue(rowId, 'RFX_TYPE'),
		    	        	VENDOR_CD : EVF.V("VENDOR_CD"),
	    		            detailView: true,
	    		            popupFlag: true
		    		    };
	    	        everPopup.openPopupByScreenId("SRQI0011", 1200, 900, param);
				}
	        	if(colId == "RFX_GIVEUP_RMK") {
	        		if(!EVF.isEmpty(grid.getCellValue(rowId, "RFX_GIVEUP_RMK"))) {
		        		var param = {
		        			title: "${SRQR0010_0005}",
	            			message: grid.getCellValue(rowId, 'RFX_GIVEUP_RMK')
	    				};
	    				var url = '/common/popup/common_text_view/view.so';
	    				everPopup.openModalPopup(url, 500, 300, param);
	        		}
				}
			});

	        grid.excelExportEvent({
				allItems : "${excelExport.allCol}",
				fileName : "${screenName }"
			});
	        
	        grid.setProperty('singleSelect', true);
	        grid.setProperty('shrinkToFit', false);
	        
	        doSearch();
	    }

	    function doSearch() {

	    	var store = new EVF.Store();
			if(!store.validate()) { return; }
	        store.setGrid([grid]);
	        store.load(baseUrl + 'srqr0010_doSearch.so', function() {
	        	if(grid.getRowCount() == 0){
	            	EVF.alert("${msg.M0002 }");
	            } else {
	        		grid.setColIconify("RFX_GIVEUP_RMK", "RFX_GIVEUP_RMK", "comment", false);
	        	}
	        });
	    }
		
	    <%-- 견적접수 --%>
		function doAccept() {

			if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
			if (grid.getSelRowCount() > 1) { return EVF.alert('${msg.M0006}'); }

			var rowIds = grid.getSelRowId();
	    	for(var i in rowIds) {
	    		if( grid.getCellValue(rowIds[i], 'RFX_PROGRESS_CD') == '999' ) {
	    			return EVF.alert('${SRQR0010_0004}');
	    		}
	    		if( grid.getCellValue(rowIds[i], 'RFX_PROGRESS_CD') != '100' ) {
	    			return EVF.alert('${SRQR0010_1000}');
	    		}
	    		if( !EVF.isEmpty(grid.getCellValue(rowIds[i], 'RFX_RECEIPT_DATE')) ) {
	    			return EVF.alert('${SRQR0010_0007}');
	    		}
	    		eventRowId = rowIds[i];
    		}
			
	    	var store = new EVF.Store();
			store.setGrid([grid]);
            store.getGridData(grid, 'sel');
            store.load(baseUrl + 'srqr0010_doAccept.so', function(){
        		EVF.alert(this.getResponseMessage());
        		doSearch();
        	});
		}
		
	    <%-- 견적서 작성 --%>
	    function doRegistration() {

	    	if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
	    	if (grid.getSelRowCount() > 1) { return EVF.alert('${msg.M0006}'); }
			
	    	var buyerCd = "";
	    	var rfxNum  = ""; 
	    	var rfxCnt  = ""; 
	    	var qtaNum  = ""; 
	    	var rfxType = "";
	    	var rowIds  = grid.getSelRowId();
	    	for(var i in rowIds) {
	    		if( grid.getCellValue(rowIds[i], 'RFX_PROGRESS_CD') != '200' && grid.getCellValue(rowIds[i], 'RFX_PROGRESS_CD') != '250' ) {
	    			return EVF.alert('${SRQR0010_0003}');
	    		}
	    		if( EVF.isEmpty(grid.getCellValue(rowIds[i], 'RFX_RECEIPT_DATE')) ) {
	    			return EVF.alert('${SRQR0010_0006}');
	    		}
	    		if( grid.getCellValue(rowIds[i], 'WRITE_FLAG') != 'Y' ) {
	    			return EVF.alert('${SRQR0010_0004}');
	    		}
	    		buyerCd = grid.getCellValue(rowIds[i], 'BUYER_CD');
	    		rfxNum  = grid.getCellValue(rowIds[i], 'RFX_NUM');
	    		rfxCnt  = grid.getCellValue(rowIds[i], 'RFX_CNT');
	    		qtaNum  = grid.getCellValue(rowIds[i], 'QTA_NUM');
	    		rfxType = grid.getCellValue(rowIds[i], 'RFX_TYPE');
    		}

	    	var param = {
   	        		BUYER_CD: buyerCd,
	    			RFX_NUM: rfxNum,
	   	        	RFX_CNT: rfxCnt,
	   	        	QTA_NUM : qtaNum,
	   	        	RFX_TYPE : rfxType,
	   	        	VENDOR_CD : EVF.V("VENDOR_CD"),
		            detailView: false,
		            popupFlag: true
	   		    };
	    	everPopup.openPopupByScreenId("SRQI0011", 1200, 900, param);
	    }
		
	    <%-- 견적포기 --%>
		function doGiveup() {

			if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
			if (grid.getSelRowCount() > 1) { return EVF.alert('${msg.M0006}'); }

			var rowIds = grid.getSelRowId();
	    	for(var i in rowIds) {
	    		if( grid.getCellValue(rowIds[i], 'RFX_PROGRESS_CD') == '999' ) {
	    			return EVF.alert('${SRQR0010_0004}');
	    		}
	    		if( grid.getCellValue(rowIds[i], 'RFX_PROGRESS_CD') == '150'
	    		 || grid.getCellValue(rowIds[i], 'RFX_PROGRESS_CD') == '300'
	    		 || grid.getCellValue(rowIds[i], 'RFX_PROGRESS_CD') == '400' ) {
	    			return EVF.alert('${SRQR0010_1001}');
	    		}
	    		eventRowId = rowIds[i];
    		}

			if (confirm("${msg.M0030}")) {
				var param = {
        			title: "${SRQR0010_0005}",
					message: "",
					callbackFunction: 'setRMK',
					rowIdx: eventRowId
				};
				var url = '/common/popup/common_text_input/view.so';
				everPopup.openModalPopup(url, 500, 320, param);
			}
		}

		function setRMK(data) {

			if(EVF.isEmpty(data.message)) {
                return EVF.alert("${SRQR0010_0001}");
            }
			
			grid.setCellValue(data.rowIdx, "RFX_GIVEUP_RMK", data.message);
			//grid.setColIconify("RFX_GIVEUP_IMG", "RFX_GIVEUP_RMK", "comment", false);

	    	var store = new EVF.Store();
			store.setGrid([grid]);
            store.getGridData(grid, 'sel');
            store.load(baseUrl + 'srqr0010_doGiveup.so', function(){
        		EVF.alert(this.getResponseMessage());
        		doSearch();
        	});
		}

	</script>
	
	<e:window id="SRQR0010" initData="${initData}" onReady="init" title="${fullScreenName }" breadCrumbs="${breadCrumb }">
		<e:searchPanel id="form" title="${form_CAPTION_N }" labelWidth="${labelWidth}" width="100%" columnCount="3" useTitleBar="false" onEnter="doSearch">
			<e:inputHidden id="VENDOR_CD" name="VENDOR_CD" value="${ses.companyCd}" />
			<e:row>
				<e:label for="START_FROM_DATE" title="${form_START_FROM_DATE_N}"/>
				<e:field>
					<e:inputDate id="START_FROM_DATE" toDate="START_TO_DATE" name="START_FROM_DATE" value="${fromDate }" width="${inputDateWidth }" datePicker="true" required="${form_START_FROM_DATE_R}" disabled="${form_START_FROM_DATE_D}" readOnly="${form_START_FROM_DATE_RO}" />
					<e:text>~</e:text>
					<e:inputDate id="START_TO_DATE" fromDate="START_FROM_DATE" name="START_TO_DATE" value="${toDate }" width="${inputDateWidth }" datePicker="true" required="${form_START_TO_DATE_R}" disabled="${form_START_TO_DATE_D}" readOnly="${form_START_TO_DATE_RO}" />
				</e:field>
				<e:label for="BUYER_NM" title="${form_BUYER_NM_N}" />
				<e:field>
					<e:inputText id="BUYER_NM" name="BUYER_NM" value="" width="${form_BUYER_NM_W}" maxLength="${form_BUYER_NM_M}" disabled="${form_BUYER_NM_D}" readOnly="${form_BUYER_NM_RO}" required="${form_BUYER_NM_R}" style="${imeMode}" maskType="${form_BUYER_NM_MT}"/>
				</e:field>
				<e:label for="RFX_NUM" title="${form_RFX_NUM_N}"/>
				<e:field>
					<e:select id="st_RFX_NUM" name="st_RFX_NUM" value="${st_default}" width="${everMultiWidth}" options="${searchTerms}" visible="${everMultiVisible}" required="" readOnly="" disabled=""  maskType="${form_st_RFX_NUM_MT}"/>
					<e:inputText id="RFX_NUM" name="RFX_NUM" value="" width="100%" maxLength="${form_RFX_NUM_M}" disabled="${form_RFX_NUM_D}" readOnly="${form_RFX_NUM_RO}" required="${form_RFX_NUM_R}"  maskType="${form_RFX_NUM_MT}" />
				</e:field>
			</e:row>
			<e:row>
				<e:label for="RFX_SUBJECT" title="${form_RFX_SUBJECT_N}"/>
				<e:field>
					<e:select id="st_RFX_SUBJECT" name="st_RFX_SUBJECT" value="${st_default}" width="${everMultiWidth}" options="${searchTerms}" visible="${everMultiVisible}" required="" readOnly="" disabled=""  maskType="${form_st_RFX_SUBJECT_MT}"/>
					<e:inputText id="RFX_SUBJECT" name="RFX_SUBJECT" value="" width="100%" maxLength="${form_RFX_SUBJECT_M}" disabled="${form_RFX_SUBJECT_D}" readOnly="${form_RFX_SUBJECT_RO}" required="${form_RFX_SUBJECT_R}"  maskType="${form_RFX_SUBJECT_MT}" />
				</e:field>
				<e:label for="RFX_PROGRESS_CD" title="${form_RFX_PROGRESS_CD_N}"/>
				<e:field>
					<e:select id="RFX_PROGRESS_CD" name="RFX_PROGRESS_CD" value="" options="${rfxProgressCdOptions}" width="100%" disabled="${form_RFX_PROGRESS_CD_D}" readOnly="${form_RFX_PROGRESS_CD_RO}" required="${form_RFX_PROGRESS_CD_R}" placeHolder="" maskType="${form_RFX_PROGRESS_CD_MT}" />
				</e:field>
				<e:label for="" title="" />
				<e:field>
				</e:field>
			</e:row>
		</e:searchPanel>

		<e:buttonBar id="buttonBar" align="right" width="100%">
			<e:button id="doSearch" name="doSearch" label="${doSearch_N}" onClick="doSearch" disabled="${doSearch_D}" visible="${doSearch_V}"/>
			<e:button id="doAccept" name="doAccept" label="${doAccept_N}" onClick="doAccept" disabled="${doAccept_D}" visible="${doAccept_V}"/>
			<e:button id="doRegistration" name="doRegistration" label="${doRegistration_N}" onClick="doRegistration" disabled="${doRegistration_D}" visible="${doRegistration_V}"/>
			<e:button id="doGiveup" name="doGiveup" label="${doGiveup_N}" onClick="doGiveup" disabled="${doGiveup_D}" visible="${doGiveup_V}"/>
		</e:buttonBar>

		<e:gridPanel id="grid" name="grid" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}" />

	</e:window>
</e:ui>