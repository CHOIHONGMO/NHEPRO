<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.st-ones.com/eversrm" prefix="e"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
	<script>

    var gridV; var gridI;
    var baseUrl = "/nhepro/CRQR/";

    function init() {

    	gridV = EVF.C("gridV");
        gridI = EVF.C("gridI");
        gridV.setColEllipsis (['SETTLE_RMK'], true);

        var progress_cd = EVF.V('PROGRESS_CD');
        if (progress_cd == '2500' || progress_cd == '2550' || progress_cd == '1300') {
        	EVF.C('doPRRestore').setVisible(false);
        	EVF.C('doRe').setVisible(false);
        	EVF.C('doFinal').setVisible(false);
        }

        gridV.cellClickEvent(function(rowId, colId, value, iRow, iCol) {

        	if (colId == "VENDOR_NM") {
        		doSearchItem(gridV.getCellValue(rowId, "VENDOR_CD"));
                $('#form3 .e-panel-titlebar-td').text(gridV.getCellValue(rowId, "VENDOR_NM"));
	        }
        	if (colId == "QTA_NUM") {
	        	if( value == '' ) return;
	        	var param = {
    	        		BUYER_CD: gridV.getCellValue(rowId, 'BUYER_CD'),
	    	        	RFX_NUM: '',
	    	        	RFX_CNT: '',
	    	        	QTA_NUM : gridV.getCellValue(rowId, 'QTA_NUM'),
	    	        	RFX_TYPE : '',
	    	        	VENDOR_CD : gridV.getCellValue(rowId, 'VENDOR_CD'),
    		            detailView: true,
    		            popupFlag: true
	    		    };
    	        everPopup.openPopupByScreenId("SRQI0011", 1200, 900, param);
        	}
            if (colId == "SETTLE_RMK") {
            	if( gridV.getCellValue(rowId, 'QTA_NUM') == "" ) return;
            	
            	setRowId = rowId;
            	var progress_cd = EVF.V('PROGRESS_CD');
        	    var param = {
       				  havePermission : true
       				, screenName : "${CRQI0041_005}"
       				, textContents : "${CRQI0041_005}"
       				, callBackFunction : 'setTextContents2'
       				, TEXT_CONTENTS : gridV.getCellValue(rowId, "SETTLE_RMK")
       				, detailView : ((progress_cd == '2500' || progress_cd == '2550' || progress_cd == '1300') ? true : false)
       			};
      	  		everPopup.openPopupByScreenId('commonTextContents', 650, 350, param);
            }
        	if(colId == "ATT_FILE_CNT") {
        		if( value > 0 ) {
        			var param = {
                            attFileNum: gridV.getCellValue(rowId, 'ATT_FILE_NUM'),
                            rowIdx: rowId,
                            callBackFunction: '',
                            bizType: 'RFQ',
                            detailView : true
                        };
                    everPopup.fileAttachPopup(param);
        		}
			}
        	if(colId == "QTA_ATT_FILE_CNT") {
        		if( value > 0 ) {
        			var param = {
                            attFileNum: gridV.getCellValue(rowId, 'QTA_ATT_FILE_NUM'),
                            rowIdx: rowId,
                            callBackFunction: '',
                            bizType: 'RFQ',
                            detailView : true
                        };
                    everPopup.fileAttachPopup(param);
        		}
			}
        });

        gridV.cellChangeEvent(function(rowId, colId, iRow, iCol, value, oldValue) {

        	if(colId == "AWARD") {
        		if( value != oldValue ) {
	        		if( value == "" || value == "0" ) {
	        			gridV.setCellValue(rowId, 'AWARD', '0');
	        			var selAmt = 0;
	        			for (var i = 0; i < gridV.getRowCount(); i++) {
	            			if (gridV.getCellValue(i, 'AWARD') === "1") {
	            				selAmt = selAmt  + Number(gridV.getCellValue(i, 'QTA_AMT'));
	            			}
	                    }
	        			EVF.V('SEL_AMT', selAmt);
	        		} else {
	            		for (var i = 0; i < gridV.getRowCount(); i++) {
	            			if( i != rowId ) {
	                			gridV.setCellValue(i, 'AWARD', '0');
	            			}
	            		}

	            		EVF.V("VENDOR_CD", gridV.getCellValue(rowId, 'VENDOR_CD'));
	                    var store = new EVF.Store();
	                    store.setGrid([gridI]);
	                    store.load(baseUrl + "crqi0041_doSearchI.so", function() {
	            			if(gridI.getRowCount() > 0) {
	            				var selAmt = 0;
	                    		for (var i = 0; i < gridI.getRowCount(); i++) {
	                                selAmt = selAmt + (Number(gridI.getCellValue(i, 'RFX_QT')) * Number(gridI.getCellValue(i, 'UNIT_PRC')));
	                            }
	                        	EVF.V('SEL_AMT', selAmt);
	            			}
	                    }, false);
	        		}
        		}
			}
        });

        gridI.cellClickEvent(function(rowId, colId, value, iRow, iCol) {

        	if(colId == "ITEM_CD") {
        		var param = {
	           		itemCd : gridI.getCellValue(rowId, "ITEM_CD")
	            };
	            everPopup.openItemDetailInformation(param);
			}
        	if(colId == "ITEM_DESC") {
        		var param = {
        			 ITEM_CD : gridI.getCellValue(rowId, "ITEM_CD")
	           		,ITEM_DESC : gridI.getCellValue(rowId, "ITEM_DESC")
	            };
        		//everPopup.openPopupByScreenId('P03_056', 500, 600, param);
			}
        	if(colId == "PR_ATT_FILE_CNT") {
        		if( value > 0 ) {
        			var param = {
                            attFileNum: gridI.getCellValue(rowId, 'PR_ATT_FILE_NUM'),
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
                            attFileNum: gridI.getCellValue(rowId, 'VENDOR_ATT_FILE_NUM'),
                            rowIdx: rowId,
                            callBackFunction: '',
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
                    message: gridI.getCellValue(rowId, 'PR_ITEM_RMK')
                };
                var url = '/common/popup/common_text_view/view.so';
				everPopup.openModalPopup(url, 500, 300, param);
            }
            if (colId == 'VENDOR_ITEM_RMK') {
            	if( value == "" ) return;
                var param = {
                    title: "협력업체 비고",
                    message: gridI.getCellValue(rowId, 'VENDOR_ITEM_RMK')
                };
                var url = '/common/popup/common_text_view/view.so';
				everPopup.openModalPopup(url, 500, 300, param);
            }
        });

		gridV.excelExportEvent({
			allItems : "${excelExport.allCol}",
			fileName : "${screenName }"
		});

		gridI.excelExportEvent({
			allItems : "${excelExport.allCol}",
			fileName : "${screenName }"
		});

		gridV.setProperty('shrinkToFit', true);
		gridV.setProperty('multiSelect', false);

		gridI.setProperty('shrinkToFit', false);
		gridI.setProperty('multiSelect', false);
		
		gridI.setColGroup([
            {
                "groupName": '용역',
                "columns": ['SW_BUS_PRICE', 'SW_BUS_RATE', 'MNT_SANGJU_YN']
            }
            ,{
                "groupName": '물품(공사,기타,양수)',
                "columns": ['CONSUMER_AMT', 'CONSUMER_RATE', 'FC_MNT_TERM', 'CH_RATE']
            }
            ,{
                "groupName": '유지보수(리스,재리스,렌탈,도급)',
                "columns": ['DOIB_AMT', 'MNT_RATE', 'MNT_SDAY', 'MNT_EDAY', 'MNT_GUR_MONTH', 'RT_INSP_PERIOD', 'FALT_RC_TG_TIME']
            }
        ],50);
		
		if (!EVF.isEmpty("${param.RFX_NUM}")) {
			EVF.V('BUYER_CD','${param.BUYER_CD}');
			EVF.V('RFX_NUM', '${param.RFX_NUM}');
            EVF.V('RFX_CNT', '${param.RFX_CNT}');

            doSearch();
        }
    }

    function doSearch() {

        var store = new EVF.Store();
        if(!store.validate()) return;
        store.setGrid([gridV]);
        store.load(baseUrl + "crqi0041_doSearchV.so", function() {
        	if (gridV.getRowCount() > 0) {
        		var sumAmt  = 0; 	// 추정금액
        		var estmAmt = 0; 	// 예가금액
        		var selAmt  = 0;	// 선정금액
        		for (var i = 0; i < gridV.getRowCount(); i++) {
        			if (gridV.getCellValue(i, 'AWARD_POSSIBLE_FLAG') === "N") {
        				gridV.setCellReadOnly(i, 'AWARD', true);
        			}
        			if (gridV.getCellValue(i, 'AWARD') === "1") {
           				sumAmt  = sumAmt  + Number(gridV.getCellValue(i, 'ITEM_AMT'));
        				estmAmt = estmAmt + Number(gridV.getCellValue(i, 'ESTM_AMT'));
        				selAmt  = selAmt  + Number(gridV.getCellValue(i, 'QTA_AMT'));
        			} else {
        				sumAmt  = Number(gridV.getCellValue(0, 'ITEM_AMT'));
        				estmAmt = Number(gridV.getCellValue(0, 'ESTM_AMT'));
        				selAmt  = 0;
        			}
                }
            	EVF.V('SUM_AMT', sumAmt);	// 추정금액
            	EVF.V('ESTM_AMT', estmAmt);	// 예가금액
            	EVF.V('SEL_AMT', selAmt);	// 선정금액

        		// 협력업체별 견적품목 조회
        		var vcd = gridV.getCellValue("0", "VENDOR_CD");
            	doSearchItem(vcd);
            }
        });
    }

    // 업체별 견적품목 조회
    function doSearchItem(vendor_cd) {

    	EVF.V("VENDOR_CD", vendor_cd);

        var store = new EVF.Store();
        if(!store.validate()) return;
        store.setGrid([gridI]);
        store.load(baseUrl + "crqi0041_doSearchI.so", function() {
			if(gridI.getRowCount() > 0) {
				var rowIds = gridI.getAllRowId();
				for(var i in rowIds) {
					var prAmt = Number(gridI.getCellValue(rowIds[i], 'ITEM_AMT'));
					var swBusAmt = Number(gridI.getCellValue(rowIds[i], 'SW_BUS_PRICE'));
					if(!EVF.isEmpty(swBusAmt) && Number(swBusAmt) > 0 && !EVF.isEmpty(prAmt) && Number(prAmt) > 0) {
						gridI.setCellValue(rowIds[i], 'SW_BUS_RATE', ((swBusAmt - prAmt) / swBusAmt) * 100);
					} else {
						gridI.setCellValue(rowIds[i], 'SW_BUS_RATE', null);
					}
					var consumerAmt = Number(gridI.getCellValue(rowIds[i], 'CONSUMER_AMT'));
					if(!EVF.isEmpty(consumerAmt) && Number(consumerAmt) > 0 && !EVF.isEmpty(prAmt) && Number(prAmt) > 0) {
						gridI.setCellValue(rowIds[i], 'CONSUMER_RATE', ((consumerAmt - prAmt) / consumerAmt) * 100);
					} else {
						gridI.setCellValue(rowIds[i], 'CONSUMER_RATE', null);
					}
				}
				//var sumAmt = 0;
        		//for (var i = 0; i < gridI.getRowCount(); i++) {
                //    sumAmt = sumAmt + (Number(gridI.getCellValue(i, 'RFX_QT')) * Number(gridI.getCellValue(i, 'R_UNIT_PRC')));
                //}
            	//EVF.V('SUM_AMT', sumAmt);
			}
        });
	}

    // 유찰
    function doPRRestore() {

    	// 견적금액이 추정금액 또는 예가금액 이하로 투찰할 경우 유찰할 수 없음
        var estPriceType = EVF.V('EST_PRICE_TYPE');
        var estPrice = EVF.V('SUM_AMT');	// 추정금액
        if( estPriceType == "1" ) {
            estPrice = EVF.V('ESTM_AMT');	// 예가금액
        }
        
        var msg = "${msg.M0111 }";
        var rowIds = gridV.getAllRowId();
        for(var i in rowIds) {
        	var qtaAmt = gridV.getCellValue(rowIds[i], 'QTA_AMT');
			if( !EVF.isEmpty(qtaAmt) && Number(qtaAmt) > 0 && Number(qtaAmt) <= Number(estPrice) ) {
				msg = "${CRQI0041_013}";
			}
		}
        
		if (!confirm(msg)) return;
		
		if (EVF.V('TRANSACTION_FLAG') == 'Y') {
   			return EVF.alert('${msg.M0123}');
   		}
		
   		var store = new EVF.Store();
   		store.load(baseUrl + "crqi0041_doPRRestore.so", function() {
   			EVF.V('TRANSACTION_FLAG', 'Y');
   			EVF.alert(this.getResponseMessage(), function() {
   				doClose();
			});
   		});
   		
	    //var param = {
		//	  havePermission : true
		//	, callBackFunction : 'setTextContents'
		//	, detailView : false
		//	, screenName : '${CRQI0041_002}'
		//};
		//everPopup.openPopupByScreenId('commonTextContents', 650, 350, param); 
    }

    // 유찰사유
    //function setTextContents(contents) {
	//	
    //	EVF.V('FAIL_BID_RMK', contents);
   	//	if (EVF.V('TRANSACTION_FLAG') == 'Y') {
   	//		return EVF.alert('${msg.M0123}');
   	//	}
	//	
   	//	var store = new EVF.Store();
   	//	store.load(baseUrl + "crqi0041_doPRRestore.so", function() {
   	//		EVF.V('TRANSACTION_FLAG', 'Y');
   	//		EVF.alert(this.getResponseMessage(), function() {
   	//			doClose();
	//		});
   	//	});
    //}

    // 재견적
    function doRe() {
    	
    	// 재견적 제한횟수 체크
    	var limitCnt = EVF.V("RFX_LIMIT_CNT");
    	var rfxCnt   = EVF.V("RFX_CNT");
    	if( Number(rfxCnt) >= Number(limitCnt) ) {
    		return EVF.alert('${CRQI0041_011}');
    	}
		
		// 2021.05.18 변경
		// 견적 : 제출한 협력업체가 없으면 재견적 할 수 없음
    	// 수의시담, 부속합의 : 견적서를 제출한 협력사가 없어도 1차수의 협력사로 재견적 가능
		if( EVF.V("RFX_TYPE") !== "RPC" && EVF.V("RFX_TYPE") !== "RCA" ) {
	    	var qtaCnt = 0;
	    	var rowIds = gridV.getAllRowId();
			for(var i in rowIds) {
				if( !EVF.isEmpty(gridV.getCellValue(rowIds[i], 'QTA_NUM')) ) {
					qtaCnt++;
				}
			}
			if( qtaCnt == 0 ) {
				return EVF.alert('${CRQI0041_012}'); // 견적서를 제출한 협력업체가 없습니다.
			}
		}
		
    	if (!confirm("${CRQI0041_010}")) return;
    	var param = {
    			BUYER_CD: EVF.V('BUYER_CD'),
	   			RFX_NUM: EVF.V('RFX_NUM'),
				RFX_CNT: EVF.V('RFX_CNT'),
				RFX_TYPE: EVF.V('RFX_TYPE'),
				baseDataType: "RERFX",
				detailView: false,
				popupFlag: true,
				callBackFunction: "doClose"
			};
    	everPopup.openPopupByScreenId('CRQI0011', 1200, 800, param);
  	}

    // 협력업체 선정
    function doFinal() {

  		if (EVF.V('TRANSACTION_FLAG') == 'Y') {
  			return EVF.alert('${msg.M0123}');
		}

        var countAward = 0;
        var rowIds = gridV.getSelRowId();
		for(var i in rowIds) {
			if (gridV.getCellValue(rowIds[i], 'AWARD') === "1") {
                countAward++;
            }
			gridV.checkRow(rowIds[i], true);
		}

        if (countAward != 1) {
            EVF.alert('${CRQI0041_001}'); return;
        }
		
        // if 선정금액 > 추정 또는 예가금액 ? 선정할 수 없음
        var estPriceType = EVF.V('EST_PRICE_TYPE');
        var estPrice = EVF.V('SUM_AMT');	// 추정금액
        var selPrice = EVF.V('SEL_AMT');	// 견적금액

        var msg = "추정금액(";
        if( estPriceType == "1" ) {
        	msg = "예가금액(";
            estPrice = EVF.V('ESTM_AMT');	// 예가금액
        }

       	if( Number(selPrice) > Number(estPrice) ) {
           	return EVF.alert(msg + everString.comma(String(estPrice)) + "${CRQI0041_008}" + everString.comma(String(selPrice)) + "${CRQI0041_009}");
        }

        var msg = "${msg.M0079}";
        // 선정사유 필수 제외(2020.07.20)
		// 1순위가 아닌 협력업체를 선정할 경우 선정사유 필수
        for(var i in rowIds) {
    		if( gridV.getCellValue(rowIds[i], 'AWARD') == "1" && gridV.getCellValue(rowIds[i], 'PRICE_RANK') != '1' && gridV.getCellValue(rowIds[i], 'SETTLE_RMK') == '' ) {
    			msg = EVF.alert(gridV.getCellValue(rowIds[i], "VENDOR_NM") + "(*선정순위[" + gridV.getCellValue(rowIds[i], 'PRICE_RANK') + "위]*) " + "${CRQI0041_006}")
        	}
        }
		
       	if (!confirm(msg)) return;

        var store = new EVF.Store();
        store.setGrid([gridV]);
        store.getGridData(gridV, 'all');
        if(!store.validate()) return;
        store.load(baseUrl + "crqi0041_doFinal.so", function() {
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

    // 선정사유
    var setRowId;
	function setTextContents2(tests) {
		gridV.setCellValue(setRowId, "SETTLE_RMK",tests);
	}

	</script>

    <e:window id="CRQI0041" onReady="init" initData="${initData}" title="${screenName}">
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

        <e:searchPanel id="form" useTitleBar="false" title="${msg.M9999}" labelWidth="${labelWidth}" labelAlign="${labelAlign}" columnCount="2">
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
				<e:label for="AMT_TYPE" title="${form_AMT_TYPE_N}"/>
				<e:field>
					<e:text>${formData.AMT_TYPE_LOC}</e:text>
				</e:field>
				<e:label for="RFX_LIMIT_CNT" title="${form_RFX_LIMIT_CNT_N}" />
				<e:field>
					<e:inputText id="RFX_LIMIT_CNT" name="RFX_LIMIT_CNT" value="${formData.RFX_LIMIT_CNT}" width="${form_RFX_LIMIT_CNT_W}" maxLength="${form_RFX_LIMIT_CNT_M}" disabled="${form_RFX_LIMIT_CNT_D}" readOnly="${form_RFX_LIMIT_CNT_RO}" required="${form_RFX_LIMIT_CNT_R}" style="${imeMode}" maskType="${form_RFX_LIMIT_CNT_MT}"/>
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

        <e:buttonBar align="right" title="${form_CAPTION2_N}">
        	<e:text style="font-weight: bold; font-size: 12px; color: #222222" width="300px">추정금액&nbsp;:&nbsp;&nbsp;</e:text>
			<e:inputNumber id="SUM_AMT" name="SUM_AMT" value="" width="120px" maxValue="${form_SUM_AMT_M}" decimalPlace="${form_SUM_AMT_NF}" disabled="${form_SUM_AMT_D}" readOnly="${form_SUM_AMT_RO}" required="${form_SUM_AMT_R}"  onNumberKr="${form_SUM_AMT_KR}" currencyText="${form_SUM_AMT_CT}" />
        	<e:text style="font-weight: bold; font-size: 12px; color: #222222" width="20px">원&nbsp;</e:text>

        	<e:text style="font-weight: bold; font-size: 12px; color: #222222" width="70px">예가금액&nbsp;:&nbsp;&nbsp;</e:text>
			<e:inputNumber id="ESTM_AMT" name="ESTM_AMT" value="" width="120px" maxValue="${form_ESTM_AMT_M}" decimalPlace="${form_ESTM_AMT_NF}" disabled="${form_ESTM_AMT_D}" readOnly="${form_ESTM_AMT_RO}" required="${form_ESTM_AMT_R}"  onNumberKr="${form_ESTM_AMT_KR}" currencyText="${form_ESTM_AMT_CT}" />
        	<e:text style="font-weight: bold; font-size: 12px; color: #222222" width="20px">원&nbsp;</e:text>

        	<e:text style="font-weight: bold; font-size: 12px; color: #222222" width="70px">견적금액&nbsp;:&nbsp;&nbsp;</e:text>
			<e:inputNumber id="SEL_AMT" name="SEL_AMT" value="" width="120px" maxValue="${form_SEL_AMT_M}" decimalPlace="${form_SEL_AMT_NF}" disabled="${form_SEL_AMT_D}" readOnly="${form_SEL_AMT_RO}" required="${form_SEL_AMT_R}"  onNumberKr="${form_SEL_AMT_KR}" currencyText="${form_SEL_AMT_CT}" />
        	<e:text style="font-weight: bold; font-size: 12px; color: #222222" width="20px">원&nbsp;</e:text>

        	<%--
        	<e:button id="doTable" name="doTable" label="${doTable_N}" onClick="doTable" disabled="${doTable_D}" visible="${doTable_V}"/>
        	--%>
        	<e:button id="doRe" name="doRe" label="${doRe_N}" onClick="doRe" disabled="${doRe_D}" visible="${doRe_V}"/>
        	<e:button id="doFinal" name="doFinal" label="${doFinal_N}" onClick="doFinal" disabled="${doFinal_D}" visible="${doFinal_V}"/>
        	<e:button id="doPRRestore" name="doPRRestore" label="${doPRRestore_N}" onClick="doPRRestore" disabled="${doPRRestore_D}" visible="${doPRRestore_V}"/>
        <c:if test="${param.popupFlag == true}">
        	<e:button id="doClose" name="doClose" label="${doClose_N}" onClick="doClose" disabled="${doClose_D}" visible="${doClose_V}"/>
        </c:if>
        </e:buttonBar>

   	    <e:gridPanel id="gridV" name="gridV" height="220" gridType="${_gridType}" readOnly="${param.detailView}" />

		<div class="e-component e-title-container" data-uuid="Title-541-391-560">
			<div class="e-title-bullet-h1"></div>
			<div class="e-title-text">${form_CAPTION3_N}</div>
		</div>

        <e:gridPanel id="gridI" name="gridI" height="fit" gridType="${_gridType}" readOnly="${param.detailView}" />

	</e:window>
</e:ui>