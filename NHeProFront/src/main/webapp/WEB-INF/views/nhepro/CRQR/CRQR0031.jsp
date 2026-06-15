<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.st-ones.com/eversrm" prefix="e"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
    <script>

        var grid;
        var baseUrl = "/nhepro/CRQR/";

        function init() {

        	grid = EVF.C("grid");
            grid.setProperty('panelVisible', ${panelVisible});

            grid.cellClickEvent(function (rowId, celName, value, iRow, iCol) {
            	onCellClick(celName, rowId);
            });
            
            grid.cellChangeEvent(function(rowId, colId, iRow, iCol, newVal, oldVal) {
            	
            });

            grid.setProperty('multiSelect', false);
            grid.setProperty('shrinkToFit', false);
            
            doSearch();
        }

        function doSearch() {

            var store = new EVF.Store();
            store.setGrid([grid]);
            store.load(baseUrl + "crqr0031_doSearchDT.so", function () {
                if (grid.getRowCount() == 0) {
                    EVF.alert("${msg.M0002 }");
                } else {
                	grid.setColIconify("RFX_GIVEUP_RMK", "RFX_GIVEUP_RMK", "comment", false);
                	
                	var rowIds = grid.getAllRowId();
        	    	for(var i in rowIds) {
        	    		if(grid.getCellValue(rowIds[i], 'SETTLE_FLAG') == "Y") {
        	    			grid.setCellFontColor(rowIds[i], 'SETTLE_FLAG', "#FF0000");
        	    		}
            		}
                }
            });
        }

        function onCellClick(strColumnKey, nRow) {

        	if (strColumnKey == "VENDOR_CD") {
        		param = {
                        VENDOR_CD: grid.getCellValue(nRow, "VENDOR_CD"),
                        detailView: true,
                        popupFlag: true
                    };
                everPopup.openPopupByScreenId("CVNR0011", 1000, 730, param);
            }
        	if(strColumnKey == "QTA_NUM") {
        		if (grid.getCellValue(nRow,'QTA_NUM') == '') return;
        		if (grid.getCellValue(nRow,'RFX_OPEN_FLAG') == '0') {
        			return EVF.alert("${CRQR0031_001}");
        		}
        		
        		var param = {
    	        		BUYER_CD: grid.getCellValue(nRow, 'BUYER_CD'),
	    	        	RFX_NUM: '',
	    	        	RFX_CNT: '',
	    	        	QTA_NUM: grid.getCellValue(nRow, 'QTA_NUM'),
	    	        	RFX_TYPE: '',
	    	        	VENDOR_CD: grid.getCellValue(nRow, 'VENDOR_CD'),
    		            detailView: true,
    		            popupFlag: true
	    		    };
    	        everPopup.openPopupByScreenId("SRQI0011", 1200, 900, param);
			}
        	if(strColumnKey == "ATT_FILE_CNT") {
        		if( Number(grid.getCellValue(nRow, "ATT_FILE_CNT")) > 0 ) {
        			var param = {
                            attFileNum: grid.getCellValue(nRow, 'ATT_FILE_NUM'),
                            rowIdx: nRow,
                            callBackFunction: '',
                            bizType: 'RFQ',
                            detailView : true
                        };
                    everPopup.fileAttachPopup(param);
        		}
			}
            if (strColumnKey == "RFX_GIVEUP_RMK") {
            	if(!EVF.isEmpty(grid.getCellValue(nRow, "RFX_GIVEUP_RMK"))) {
	            	setRowId = nRow;
	            	var param = {
	       				  havePermission : false
	       				, callBackFunction : 'setTextContents'
	       				, TEXT_CONTENTS : grid.getCellValue(nRow, "RFX_GIVEUP_RMK")
	       				, screenName : "${CRQR0031_003}"
	       			};
	      	  		everPopup.openPopupByScreenId('commonTextContents', 500, 300, param);
            	}
            }
        }
        
        function doClose() {
			EVF.closeWindow();
        }

    </script>

    <e:window id="CRQR0031" onReady="init" initData="${initData}" title="${empty param.title ? screenName : param.title}" margin="0 3px 0 3px">
        <e:searchPanel id="form" title="${form_GENERAL_INFORMATION_N }" useTitleBar="false" columnCount="2" labelWidth="135">
           	<e:inputHidden id="BUYER_CD" name="BUYER_CD" value="${empty param.BUYER_CD ? formData.BUYER_CD : param.BUYER_CD}" />
           	<e:inputHidden id="RFX_NUM" name="RFX_NUM" value="${param.RFX_NUM}"/>
           	<e:inputHidden id="RFX_CNT" name="RFX_CNT" value="${param.RFX_CNT}"/>
           	<e:inputHidden id="APP_DOC_NUM" name="APP_DOC_NUM" value="${empty param.appDocNum ? formData.APP_DOC_NUM : param.appDocNum}" />
           	<e:inputHidden id="APP_DOC_CNT" name="APP_DOC_CNT" value="${empty param.appDocCnt ? formData.APP_DOC_CNT : param.appDocCnt}" />
           	
            <e:row>
                <e:label for="RFX_NUM" title="${form_RFX_NUM_N}"/>
                <e:field>
                	<e:text>${formData.RFX_NUM } / ${formData.RFX_CNT}</e:text>
                </e:field>
                <e:label for="RFX_SUBJECT" title="${form_RFX_SUBJECT_N}"/>
                <e:field>
                	<e:text>${formData.RFX_SUBJECT}</e:text>
                </e:field>
            </e:row>
            <e:row>
            	<%--
                <e:label for="SETTLE_TYPE" title="${form_SETTLE_TYPE_N}"/>
                <e:field>
                    <e:text>${formData.SETTLE_TYPE_LOC}</e:text>
                </e:field>
                --%>
				<e:label for="AMT_TYPE" title="${form_AMT_TYPE_N}"/>
				<e:field>
					<e:text> ${formData.AMT_TYPE_LOC } </e:text>
				</e:field>
				<e:label for="RFQ_SC_DATE" title="${form_RFQ_SC_DATE_N}"/>
				<e:field>
					<e:text>${formData.RFX_START_DATE} ${formData.RFX_START_HOUR}:${formData.RFX_START_MIN} ~ ${formData.RFX_CLOSE_DATE} ${formData.RFX_CLOSE_HOUR}:${formData.RFX_CLOSE_MIN}</e:text>
				</e:field>
            </e:row>
        </e:searchPanel>

        <e:buttonBar align="right">
            <e:button id="doClose" name="doClose" label="${doClose_N}" onClick="doClose" disabled="${doClose_D}" visible="${doClose_V}"/>
        </e:buttonBar>

        <e:gridPanel id="grid" name="grid" height="fit" gridType="${_gridType}" readOnly="${param.detailView}" />

    </e:window>
</e:ui>