<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.st-ones.com/eversrm" prefix="e"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">

	<script>

    var grid;
    var baseUrl = "/nhepro/SRQR/";

    function init() {

    	grid = EVF.C("grid");
		grid.setColEllipsis (['RFX_GIVEUP_RMK'], true);

        grid.cellClickEvent(function(rowId, colId, value, iRow, iCol) {
        	
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
            if (colId == "RFX_GIVEUP_IMG") {
            	if(!EVF.isEmpty(grid.getCellValue(rowId, "RFX_GIVEUP_RMK"))) {
            		param = {
    						title : '견적포기사유',
    						message: value,
    						detailView : true
    					};
    				everPopup.commonTextInput(param);
            	}
            }
        });
		
        grid.setProperty('shrinkToFit', false);
        grid.setProperty('multiSelect', false);

        grid.excelExportEvent({
			allItems : "${excelExport.allCol}",
			fileName : "${screenName }"
		});
        
        // 제출상태
        EVF.C('RFX_PROGRESS_CD').removeOption('100');
        EVF.C('RFX_PROGRESS_CD').removeOption('200');
        
        // 선정상태
        EVF.C('SETTLE_FLAG').removeOption('S');
        EVF.C('SETTLE_FLAG').addOption("재견적", "2550");
        EVF.C('SETTLE_FLAG').addOption("유찰",  "1300");
        
        // 2021.01.20 자동조회 추가
        doSearch();
    }

    function doSearch() {

        var store = new EVF.Store();
        if(!store.validate()) return;
        store.setGrid([grid]);
        store.load(baseUrl + "srqr0020_doSearch.so", function() {
            if (grid.getRowCount() == 0) {
                EVF.alert("${msg.M0002 }");
            } else {
        		grid.setColIconify("RFX_GIVEUP_IMG", "RFX_GIVEUP_IMG", "comment", false);
				
            	var rowIds = grid.getAllRowId();
    	    	for(var i in rowIds) {
    	    		if(grid.getCellValue(rowIds[i], 'SETTLE_FLAG') == "1300" || grid.getCellValue(rowIds[i], 'SETTLE_FLAG') == "2550") {
        				grid.setCellFontColor(rowIds[i], 'SETTLE_FLAG_LOC', "#FF0000");
        			}
    	    		else if(grid.getCellValue(rowIds[i], 'SETTLE_FLAG') == "Y") {
    	    			grid.setCellFontColor(rowIds[i], 'SETTLE_FLAG_LOC', "#0100FF");
    	    		}
        		}
            }
        });
    }

    </script>

    <e:window id="SRQR0020" onReady="init" initData="${initData}" title="${screenName}">
        <e:searchPanel id="form" title="${msg.M9999}" labelWidth="${labelWidth}" labelAlign="${labelAlign}" useTitleBar="false" columnCount="3" onEnter="doSearch">
            <e:inputHidden id="VENDOR_CD" name="VENDOR_CD" value="${ses.companyCd}" />
            <e:row>
                <e:label for="ADD_DATE_FROM" title="${form_ADD_DATE_FROM_N}"/>
                <e:field>
                    <e:inputDate id="ADD_DATE_FROM" toDate="ADD_DATE_TO" name="ADD_DATE_FROM" value="${fromDate}" width="${inputDateWidth}" datePicker="true" required="${form_ADD_DATE_FROM_R}" disabled="${form_ADD_DATE_FROM_D}" readOnly="${form_ADD_DATE_FROM_RO}" />
                    <e:text>~</e:text>
                    <e:inputDate id="ADD_DATE_TO" fromDate="ADD_DATE_FROM" name="ADD_DATE_TO" value="${toDate}" width="${inputDateWidth}" datePicker="true" required="${form_ADD_DATE_TO_R}" disabled="${form_ADD_DATE_TO_D}" readOnly="${form_ADD_DATE_TO_RO}" />
                </e:field>
				<e:label for="BUYER_NM" title="${form_BUYER_NM_N}" />
				<e:field>
					<e:inputText id="BUYER_NM" name="BUYER_NM" value="" width="${form_BUYER_NM_W}" maxLength="${form_BUYER_NM_M}" disabled="${form_BUYER_NM_D}" readOnly="${form_BUYER_NM_RO}" required="${form_BUYER_NM_R}" style="${imeMode}" maskType="${form_BUYER_NM_MT}"/>
				</e:field>
                <e:label for="RFX_SUBJECT" title="${form_RFX_SUBJECT_N}" />
                <e:field>
                    <e:select id="st_RFX_SUBJECT" name="st_RFX_SUBJECT" value="${st_default}" width="${everMultiWidth}" options="${searchTerms}" visible="${everMultiVisible}" disabled="" readOnly="" required=""  maskType="${form_st_RFX_SUBJECT_MT}"/>
                    <e:inputText id="RFX_SUBJECT" name="RFX_SUBJECT" value="${form.RFX_SUBJECT}" width="100%" maxLength="${form_RFX_SUBJECT_M}" disabled="${form_RFX_SUBJECT_D}" readOnly="${form_RFX_SUBJECT_RO}" required="${form_RFX_SUBJECT_R}"  maskType="${form_RFX_SUBJECT_MT}" />
                </e:field>
			</e:row>
			<e:row>
				<e:label for="RFX_PROGRESS_CD" title="${form_RFX_PROGRESS_CD_N}"/>
				<e:field>
					<e:select id="RFX_PROGRESS_CD" name="RFX_PROGRESS_CD" value="" options="${rfxProgressCdOptions}" width="100%" disabled="${form_RFX_PROGRESS_CD_D}" readOnly="${form_RFX_PROGRESS_CD_RO}" required="${form_RFX_PROGRESS_CD_R}" placeHolder="" maskType="${form_RFX_PROGRESS_CD_MT}" />
				</e:field>
				<e:label for="SETTLE_FLAG" title="${form_SETTLE_FLAG_N}"/>
                <e:field>
                    <e:select id="SETTLE_FLAG" name="SETTLE_FLAG" value="" options="${settleFlagOptions}" width="${form_SETTLE_FLAG_W}" disabled="${form_SETTLE_FLAG_D}" readOnly="${form_SETTLE_FLAG_RO}" required="${form_SETTLE_FLAG_R}" placeHolder=""  maskType="${form_SETTLE_FLAG_MT}"/>
                </e:field>
				<e:label for="" title=""/>
                <e:field>
                </e:field>
			</e:row>
        </e:searchPanel>

        <e:buttonBar align="right">
        	<e:button id="doSearch" name="doSearch" label="${doSearch_N}" disabled="${doSearch_D}" visible="${doSearch_V}" onClick="doSearch" />
        </e:buttonBar>

        <e:gridPanel id="grid" name="grid" height="fit" gridType="${_gridType}" readOnly="${param.detailView}" />

	</e:window>
</e:ui>