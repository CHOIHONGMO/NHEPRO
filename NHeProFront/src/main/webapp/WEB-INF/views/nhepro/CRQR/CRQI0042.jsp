<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.st-ones.com/eversrm" prefix="e"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
	<script>

    var grid;
    var baseUrl = "/nhepro/CRQR/";
	var rfxType;
	
    function init() {

		grid = EVF.C("grid");
		
    	rfxType = EVF.V('RFX_TYPE');
        var progress_cd = EVF.V('PROGRESS_CD');

        if (progress_cd == '2500' || progress_cd == '2550' || progress_cd == '1300') {
        	EVF.C('doPRRestore').setVisible(false);
        	EVF.C('doRe').setVisible(false);
        	EVF.C('doFinal').setVisible(false);
        }
		
        grid.cellClickEvent(function(rowId, colId, value, iRow, iCol) {

        	if (colId == "VENDOR_CD") {
        		if( value == "" ) return;
        		param = {
                        VENDOR_CD: value,
                        detailView: true,
                        popupFlag: true,
                        buttonView: false
                    };
                everPopup.openPopupByScreenId("CVNR0011", 1000, 730, param);
	        }
        	if (colId == "QTA_NUM") {
        		if( value =="" ) return;
    	        var param = {
    	        		BUYER_CD: grid.getCellValue(rowId, 'BUYER_CD'),
	    	        	RFX_NUM: '',
	    	        	RFX_CNT: '',
	    	        	QTA_NUM: grid.getCellValue(rowId, 'QTA_NUM'),
	    	        	RFX_TYPE: '',
	    	        	VENDOR_CD: grid.getCellValue(rowId, 'VENDOR_CD'),
    		            detailView: true,
    		            popupFlag: true
	    		    };
    	        everPopup.openPopupByScreenId("SRQI0011", 1200, 900, param);
        	}
        	if (colId == "ITEM_CD") {
        		param = {
                        ITEM_CD: value,
                        STD_ITEM_CD: value,
                        popupFlag: true,
                        detailView: true,
                        manageFlag: "0"
                    };
                everPopup.openPopupByScreenId("CITR0041", 1150, 663, param);
	        }
        	if(colId == "PR_ATT_FILE_CNT") {
        		if( value > 0 ) {
        			var param = {
                            attFileNum: grid.getCellValue(rowId, 'PR_ATT_FILE_NUM'),
                            rowIdx: rowId,
                            callBackFunction: '',
                            bizType: 'PR',
                            detailView : true
                        };
                    everPopup.fileAttachPopup(param);
        		}
			}
        	if(colId == "VENDOR_ATT_FILE_CNT") {
        		if( value > 0 ) {
        			var param = {
                            attFileNum: grid.getCellValue(rowId, 'VENDOR_ATT_FILE_NUM'),
                            rowIdx: rowId,
                            callBackFunction: 'setFileAttach',
                            bizType: 'RFQ',
                            detailView : true
                        };
                    everPopup.fileAttachPopup(param);
        		}
			}
        	if (colId == 'PR_ITEM_RMK') {
            	if( value == "" ) return;
                var param = {
                    title: "구매사 비고",
                    message: grid.getCellValue(rowId, 'PR_ITEM_RMK')
                };
                var url = '/common/popup/common_text_view/view.so';
				everPopup.openModalPopup(url, 500, 300, param);
            }
            if (colId == 'VENDOR_ITEM_RMK') {
            	if( value == "" ) return;
                var param = {
                    title: "협력업체 비고",
                    message: grid.getCellValue(rowId, 'VENDOR_ITEM_RMK')
                };
                var url = '/common/popup/common_text_view/view.so';
				everPopup.openModalPopup(url, 500, 300, param);
            }
        	if (colId == "SETTLE_RMK") {
        		if( grid.getCellValue(rowId, 'QTA_NUM') == "" ) return;
        		
            	setRowId = rowId;
            	var progress_cd = EVF.V('PROGRESS_CD');
        	    var param = {
	       				  havePermission : true
	       				, screenName : "${CRQI0042_007}"
	       				, textContents : "${CRQI0042_007}"
	       				, callBackFunction : 'setTextContents2'
	       				, TEXT_CONTENTS : grid.getCellValue(rowId, "SETTLE_RMK")
	       				, detailView : ((progress_cd == '2500' || progress_cd == '2550' || progress_cd == '1300') ? true : false)
	       			};
      	  		everPopup.openPopupByScreenId('commonTextContents', 650, 350, param);
            }	
        });

        grid.cellChangeEvent(function(rowId, colId, iRow, iCol, value, oldValue) {

        	if (colId == "AWARD") {
        		if( value == "" ) {
        			grid.setCellValue(rowId, 'AWARD', '0');
        		}
        		// 견적 포기한 업체입니다.
        		if (grid.getCellValue(rowId, 'GIVEUP_FLAG') == '1') {
					EVF.alert('${CRQI0042_005}');
        			grid.setCellValue(rowId, 'AWARD', oldValue);
        			return;
        		}
        		// 해당건은 이미 품의가 작성 되었습니다.
        		if (grid.getCellValue(rowId, 'EXEC_YN') == 'Y') {
					EVF.alert('${CRQI0042_006}');
        			grid.setCellValue(rowId, 'AWARD', oldValue);
        		}
        		// 선정금액
        		var rowIds = grid.getAllRowId();
        		if(grid.getRowCount() > 0) {
    				var selAmt = 0;
            		for (var i = 0; i < grid.getRowCount(); i++) {
            			if (grid.getCellValue(i, 'AWARD') === "1") {
	                        selAmt = selAmt + (Number(grid.getCellValue(i, 'RFX_QT')) * Number(grid.getCellValue(i, 'UNIT_PRC')));
            			}
                    }
                	EVF.V('SEL_AMT', selAmt);
    			}
        	}
        });

		grid.excelExportEvent({
			allItems : "${excelExport.allCol}",
			fileName : "${screenName }"
		});

		grid.setColEllipsis (['SETTLE_RMK'], true);
		grid.setProperty('multiSelect', false);
		
        if ('${param.RFX_NUM}' !== '') {
        	EVF.V('BUYER_CD','${param.BUYER_CD}');
            EVF.V('RFX_NUM', '${param.RFX_NUM}');
            EVF.V('RFX_CNT', '${param.RFX_CNT}');
            doSearch();
        }
    }

    function doSearch() {

        var store = new EVF.Store();
        if(!store.validate()) return;
        store.setGrid([grid]);
        store.load(baseUrl + "crqi0042_doSearch.so", function() {
        	if (grid.getRowCount() != 0) {
            	var selAmt = 0;
        		var rowIds = grid.getAllRowId();
				for(var i in rowIds) {
					// 견적포기, 미제출, 업체선정인 경우 다시 선정 안됨
					if (grid.getCellValue(rowIds[i], 'AWARD_POSSIBLE_FLAG') === "N") {
                    	grid.setCellReadOnly(rowIds[i], 'AWARD', true);
                    }
					// 선정금액 세팅
                    if (grid.getCellValue(rowIds[i], 'AWARD') === "1") {
                        selAmt = selAmt + (Number(grid.getCellValue(rowIds[i], 'RFX_QT')) * Number(grid.getCellValue(rowIds[i], 'UNIT_PRC')));
                    }
                    
                    // 할인율 계산
					var prAmt = Number(grid.getCellValue(rowIds[i], 'ITEM_AMT'));
					var swBusAmt = Number(grid.getCellValue(rowIds[i], 'SW_BUS_PRICE'));
					if(!EVF.isEmpty(swBusAmt) && Number(swBusAmt) > 0 && !EVF.isEmpty(prAmt) && Number(prAmt) > 0) {
						grid.setCellValue(rowIds[i], 'SW_BUS_RATE', ((swBusAmt - prAmt) / swBusAmt) * 100);
					} else {
						grid.setCellValue(rowIds[i], 'SW_BUS_RATE', null);
					}
					var consumerAmt = Number(grid.getCellValue(rowIds[i], 'CONSUMER_AMT'));
					if(!EVF.isEmpty(consumerAmt) && Number(consumerAmt) > 0 && !EVF.isEmpty(prAmt) && Number(prAmt) > 0) {
						grid.setCellValue(rowIds[i], 'CONSUMER_RATE', ((consumerAmt - prAmt) / consumerAmt) * 100);
					} else {
						grid.setCellValue(rowIds[i], 'CONSUMER_RATE', null);
					}
				}
            	EVF.V("SUM_AMT", Number(this.getParameter("sumAmt")));
            	EVF.V("SEL_AMT", selAmt);
        	}
        	// 컬럼 통합
    		grid.setColMerge(['RFX_SQ','BUYER_NM','PURCHASE_TYPE','ITEM_CD','ITEM_DESC','ITEM_SPEC','MAKER_NM','MAKER_PART_NO','ORIGIN_CD','RFX_QT','UNIT_CD','CUR','R_UNIT_PRC','R_ITEM_AMT']);
        });
    }
	
    // 유찰
    function doPRRestore() {

        //if (!confirm("${msg.M0111 }")) return; //M0065
        //var param = {
		//	  havePermission : true
		//	, callBackFunction : 'setTextContents'
		//	, detailView : false
		//	, screenName : '${CRQI0042_008}'
		//};
		//everPopup.openPopupByScreenId('commonTextContents', 650, 350, param);
		
		if (!confirm("${msg.M0111 }")) return; //M0065
		
		if (EVF.V('TRANSACTION_FLAG') == 'Y') {
    		return EVF.alert('${msg.M0123}');
		}

        var store = new EVF.Store();
        store.load(baseUrl + "crqi0042_doPRRestore.so", function() {
        	EVF.V('TRANSACTION_FLAG', 'Y');
            EVF.alert(this.getResponseMessage(), function() {
   	    		doClose();
			});
        });
    }

    //function setTextContents(contents) {
    //	EVF.V('FAIL_BID_RMK', contents);
    //	if (EVF.V('TRANSACTION_FLAG') == 'Y') {
    //		return EVF.alert('${msg.M0123}');
	//	}
    //    var store = new EVF.Store();
    //    store.load(baseUrl + "crqi0042_doPRRestore.so", function() {
    //    	EVF.V('TRANSACTION_FLAG', 'Y');
    //        EVF.alert(this.getResponseMessage(), function() {
   	//    		doClose();
	//		});
    //   });
    //} 
	
	// 재견적    
    function doRe() {

    	var msg = "${CRQI0042_004}";
    	var partC = false;
    	for (var i = 0; i < grid.getRowCount(); i++) {
    		var iBUYER_CD = grid.getCellValue(i, 'BUYER_CD');
        	var iRFX_NUM  = grid.getCellValue(i, 'RFX_NUM');
        	var iRFX_CNT  = grid.getCellValue(i, 'RFX_CNT');
        	var iRFX_SQ   = grid.getCellValue(i, 'RFX_SQ');
        	if ( grid.getCellValue(i, 'GIVEUP_FLAG') == '1' ) {
        		continue;
        	}

        	var countAward = 0;
        	for (var j = 0; j < grid.getRowCount(); j++) {
        		if(grid.getCellValue(j, 'AWARD') == "1" && grid.getCellValue(j, 'SETTLE_RMK') == '' && grid.getCellValue(j, 'PRICE_RANK') != '1') {
            		return EVF.alert(grid.getCellValue(j, "VENDOR_NM") + "(*선정순위[" + grid.getCellValue(j, 'PRICE_RANK') + "위]*) " + "${CRQI0042_011}");
            	}
        		
        		if(    grid.getCellValue(j, 'AWARD') === "1"
        			&& grid.getCellValue(j, 'BUYER_CD') === iBUYER_CD
    				&& grid.getCellValue(j, 'RFX_NUM')  === iRFX_NUM
        			&& grid.getCellValue(j, 'RFX_CNT')  === iRFX_CNT
        			&& grid.getCellValue(j, 'RFX_SQ')   === iRFX_SQ
        		) {
        			countAward++;
        		}
        	}
			
        	if (countAward > 1) {
        		return EVF.alert('${CRQI0042_002}');
            }
        	
    		if( grid.getCellValue(i, 'AWARD') == "1" ) {
    			msg = everString.replaceAll("${CRQI0042_013}", "@@", "\n");
    			partC = true;
        	}
    		
            // 1순위가 아닌 협력업체를 선정할 경우 선정사유 필수
    		if( grid.getCellValue(i, 'AWARD') == "1" && grid.getCellValue(i, 'SETTLE_RMK') == '' && grid.getCellValue(i, 'PRICE_RANK') != '1' ) {
        		return EVF.alert("'" + grid.getCellValue(i, 'VENDOR_NM') + "'" + "${CRQI0042_011}");
    		}
    	}

		if (!confirm(msg)) return;

		var store = new EVF.Store();
		if(!store.validate()) return;
		store.setGrid([grid]);
		store.getGridData(grid, 'all');
		store.load(baseUrl + "crqi0042_doFinalRe.so", function() {
			EVF.V('TRANSACTION_FLAG', 'Y');
			
            var param = {
        			BUYER_CD: EVF.V('BUYER_CD'),
    	   			RFX_NUM: EVF.V('RFX_NUM'),
    				RFX_CNT: EVF.V('RFX_CNT'),
    				RFX_TYPE: EVF.V('RFX_TYPE'),
    				baseDataType: "RERFX",
    				detailView: false,
    				popupFlag: true,
    				callBackFunction: "doReClose"
    			};
        	everPopup.openPopupByScreenId('CRQI0011', 1200, 800, param);
        });  		
  	}
	
    // 협력업체 선정
    function doFinal() {
	
    	if (EVF.V('TRANSACTION_FLAG') == 'Y') {
    		return EVF.alert('${msg.M0123}');
		}
		
        for (var i = 0; i < grid.getRowCount(); i++) {
        	var iBUYER_CD = grid.getCellValue(i, 'BUYER_CD');
        	var iRFX_NUM  = grid.getCellValue(i, 'RFX_NUM');
        	var iRFX_CNT  = grid.getCellValue(i, 'RFX_CNT');
        	var iRFX_SQ   = grid.getCellValue(i, 'RFX_SQ');
        	if ( grid.getCellValue(i, 'GIVEUP_FLAG') == '1' ) {
        		continue;
        	}

        	var countAward = 0;
        	for (var j = 0; j < grid.getRowCount(); j++) {
        		if(    grid.getCellValue(j, 'AWARD') === "1"
        			&& grid.getCellValue(j, 'BUYER_CD') === iBUYER_CD
    				&& grid.getCellValue(j, 'RFX_NUM')  === iRFX_NUM
        			&& grid.getCellValue(j, 'RFX_CNT')  === iRFX_CNT
        			&& grid.getCellValue(j, 'RFX_SQ')   === iRFX_SQ
        		) {
        			countAward++;
        		}
        	}
			
        	// 업체 선정시 1개의 품목에 1개의 업체만 선정 가능
        	if (countAward > 1) {
        		return EVF.alert('${CRQI0042_002}');
            }
        	
        	// 업체 선정시 부분선정 가능
        	if (countAward == 0) {
        		return EVF.alert('${CRQI0042_003}');
            }
            
            // 1순위가 아닌 협력업체를 선정할 경우 선정사유 필수
    		if( grid.getCellValue(i, 'AWARD') == "1" && grid.getCellValue(i, 'PRICE_RANK') != '1' && grid.getCellValue(i, 'SETTLE_RMK') == '' ) {
        		return EVF.alert(grid.getCellValue(i, "VENDOR_NM") + "(*선정순위[" + grid.getCellValue(i, 'PRICE_RANK') + "위]*) " + "${CRQI0042_011}");
        	}
        }

       	if( Number(EVF.V('SEL_AMT')) > Number(EVF.V('SUM_AMT')) ) {
       		return EVF.alert("${CRQI0042_014}");
       	}

        if (!confirm("${msg.M0079}"))	return;

        var store = new EVF.Store();
        store.setGrid([grid]);
        store.getGridData(grid, 'all');
        if(!store.validate()) return;
        store.load(baseUrl + "crqi0042_doFinal.so", function() {
        	EVF.V('TRANSACTION_FLAG', 'Y');
        	EVF.alert(this.getResponseMessage(), function() {
   	    		opener.doSearch();
   	            EVF.C('doPRRestore').setDisabled(true);
   	        	EVF.C('doFinal').setDisabled(true);
   	        	EVF.C('doRe').setDisabled(true);
			});
        });
  	}

    function doReClose() {
    	if (opener !== undefined && opener.doSearch !== undefined) opener.doSearch();
    	window.close();
    }

    function doClose() {
    	if (opener !== undefined && opener.doSearch !== undefined) opener.doSearch();
    	window.close();
  	}
	
    // 협력사 선정사유
  	var setRowId;
	function setTextContents2(tests) {
		grid.setCellValue(setRowId, "SETTLE_RMK",tests);
	}

	</script>

    <e:window id="CRQI0042" onReady="init" initData="${initData}" title="${screenName}">
        <e:inputHidden id="TRANSACTION_FLAG" name="TRANSACTION_FLAG" value="N"/>
		<e:inputHidden id="BUYER_CD" name="BUYER_CD" value="${formData.BUYER_CD}"/>
	    <e:inputHidden id="RFX_NUM" name="RFX_NUM" value="${formData.RFX_NUM}" />
	    <e:inputHidden id="RFX_CNT" name="RFX_CNT" value="${formData.RFX_CNT}" />
	    <e:inputHidden id="VENDOR_CD" name="VENDOR_CD" value="" />
	    <e:inputHidden id="PROGRESS_CD" name="PROGRESS_CD" value="${formData.PROGRESS_CD}" />
	    <e:inputHidden id="RFX_TYPE" name="RFX_TYPE" value="${formData.RFX_TYPE}" />
	    <e:inputHidden id="VENDOR_OPEN_TYPE" name="VENDOR_OPEN_TYPE" value="${formData.VENDOR_OPEN_TYPE}" />
	    <e:inputHidden id="PRC_STL_TYPE" name="PRC_STL_TYPE" value="${formData.PRC_STL_TYPE}" />
	    <e:inputHidden id="SETTLE_TYPE" name="SETTLE_TYPE" value="${formData.SETTLE_TYPE}" />
	    <e:inputHidden id="RFX_SUBJECT" name="RFX_SUBJECT" value="${formData.RFX_SUBJECT}" />
	    <e:inputHidden id="FAIL_BID_RMK" name="FAIL_BID_RMK" value="${formData.FAIL_BID_RMK}" />
	    <e:inputHidden id="RQVN_CNT" name="RQVN_CNT" value="${formData.RQVN_CNT}" />
	    <e:inputHidden id="ITEM_CNT" name="ITEM_CNT" value="${formData.ITEM_CNT}" />

        <e:searchPanel id="form" useTitleBar="false" title="${msg.M9999}" labelWidth="${labelWidth}" labelAlign="${labelAlign}" columnCount="2" onEnter="doSearch">
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
                <e:label for="VENDOR_OPEN_TYPE" title="${form_VENDOR_OPEN_TYPE_N}"/>
                <e:field>
                    <e:text>${formData.VENDOR_OPEN_TYPE_LOC}</e:text>
                </e:field>
                <e:label for="SETTLE_TYPE" title="${form_SETTLE_TYPE_N}"/>
                <e:field>
                    <e:text>${formData.SETTLE_TYPE_LOC}</e:text>
                </e:field>
            </e:row>
            <e:row>
            	<e:label for="RFQ_START_END_DATE" title="${form_RFQ_START_END_DATE_N}"/>
				<e:field>
					<e:text> ${formData.RFX_START_END_DATE } </e:text>
				</e:field>
				<e:label for="EST_PRICE_TYPE" title="${form_EST_PRICE_TYPE_N}"/>
				<e:field>
					<e:select id="EST_PRICE_TYPE" name="EST_PRICE_TYPE" value="${formData.EST_PRICE_TYPE }" options="${estPriceTypeOptions}" width="${form_EST_PRICE_TYPE_W}" disabled="${form_EST_PRICE_TYPE_D}" readOnly="${form_EST_PRICE_TYPE_RO}" required="${form_EST_PRICE_TYPE_R}" placeHolder="" maskType="${form_EST_PRICE_TYPE_MT}" />
				</e:field>
			</e:row>
        </e:searchPanel>

        <e:buttonBar align="right" title="${form_CAPTION3_N}">
        	<e:text style="font-weight: bold; font-size: 12px; color: #222222" width="370px">추정금액&nbsp;:&nbsp;&nbsp;</e:text>
			<e:inputNumber id="SUM_AMT" name="SUM_AMT" value="" width="120px" maxValue="${form_SUM_AMT_M}" decimalPlace="${form_SUM_AMT_NF}" disabled="${form_SUM_AMT_D}" readOnly="${form_SUM_AMT_RO}" required="${form_SUM_AMT_R}"  onNumberKr="${form_SUM_AMT_KR}" currencyText="${form_SUM_AMT_CT}" />
        	<e:text style="font-weight: bold; font-size: 12px; color: #222222" width="20px">원&nbsp;</e:text>
        	
        	<e:text style="font-weight: bold; font-size: 12px; color: #222222" width="70px">선정금액&nbsp;:&nbsp;&nbsp;</e:text>
			<e:inputNumber id="SEL_AMT" name="SEL_AMT" value="" width="120px" maxValue="${form_SEL_AMT_M}" decimalPlace="${form_SEL_AMT_NF}" disabled="${form_SEL_AMT_D}" readOnly="${form_SEL_AMT_RO}" required="${form_SEL_AMT_R}"  onNumberKr="${form_SEL_AMT_KR}" currencyText="${form_SEL_AMT_CT}" />
        	<e:text style="font-weight: bold; font-size: 12px; color: #222222" width="20px">원&nbsp;</e:text>
        	
        	<%--
        	<e:button id="Quotation" name="Quotation" label="${Quotation_N}" disabled="${Quotation_D}" visible="${Quotation_V}" onClick="doQuotation" />
        	--%>
        	<e:button id="doRe" name="doRe" label="${doRe_N}" onClick="doRe" disabled="${doRe_D}" visible="${doRe_V}"/>
        	<e:button id="doFinal" name="doFinal" label="${doFinal_N}" onClick="doFinal" disabled="${doFinal_D}" visible="${doFinal_V}"/>
        	<e:button id="doPRRestore" name="doPRRestore" label="${doPRRestore_N}" onClick="doPRRestore" disabled="${doPRRestore_D}" visible="${doPRRestore_V}"/>
        <c:if test="${param.popupFlag == true}">
        	<e:button id="doClose" name="doClose" label="${doClose_N}" onClick="doClose" disabled="${doClose_D}" visible="${doClose_V}"/>
        </c:if>
        </e:buttonBar>

        <e:gridPanel id="grid" name="grid" height="fit" gridType="${_gridType}" readOnly="${param.detailView}" />

	</e:window>
</e:ui>