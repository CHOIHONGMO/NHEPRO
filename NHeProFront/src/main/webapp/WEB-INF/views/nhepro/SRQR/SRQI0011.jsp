<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
	
	<script type="text/javascript" src="/MagicLine4Web/ML4Web/js/ext/jquery.blockUI.js"></script>
    <!-- ML4WEB JS -->
    <script type="text/javascript" src="/MagicLine4Web/ML4Web/js/ext/ML_Config.js"></script>
	
	<script type="text/javascript">

	    var grid;
	    var baseUrl = "/nhepro/SRQR/";
		var localServerFlag = "${localServerFlag}";

	    function init() {
	    	
	        grid = EVF.C("grid");
	        // buttonStatus=N(제출완료), Y(미제출)
	        var buttonStatus = '${buttonStatus}';
			
			grid.excelExportEvent({
				allItems : "${excelExport.allCol}",
				fileName : "${screenName }"
			});

	        grid.cellClickEvent(function(rowId, colId, value) {

	        	if('${ses.userType}' == 'B') {	// 고객사에서 견적서 대행시
		        	if(colId == "ITEM_CD") {
		        		var param = {
			           		itemCd : grid.getCellValue(rowId, "ITEM_CD")
			            };
			            everPopup.openItemDetailInformation(param);
					}
	        	}
	        	if(colId == "PR_ATT_FILE_CNT") {
	        		if(!EVF.isEmpty(grid.getCellValue(rowId, "PR_ATT_FILE_CNT"))) {
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
	        		if('${buttonStatus}' === 'Y' || !EVF.isEmpty(grid.getCellValue(rowId, "VENDOR_ATT_FILE_CNT"))) {
	        			var havePermissionP = "${!param.detailView?(buttonStatus == 'N'?false:true):false}";
	        			var param = {
	                            attFileNum: grid.getCellValue(rowId, 'VENDOR_ATT_FILE_NUM'),
	                            rowIdx: rowId,
	                            callBackFunction: 'setFileAttach',
	                            bizType: 'RFQ',
	                            detailView : (havePermissionP==true||havePermissionP=='true')?false:true
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
                	var havePermissionP = "${!param.detailView?(buttonStatus == 'N'?false:true):false}";
                    var param = {
                        title: "협력업체 비고",
                        message: grid.getCellValue(rowId, 'VENDOR_ITEM_RMK'),
                        callbackFunction: 'setRMK',
                        rowIdx: rowId,
                        detailView: (havePermissionP==true||havePermissionP=='true')?false:true
                    };
                    var url = '/common/popup/common_text_input/view.so';
    				everPopup.openModalPopup(url, 500, 320, param);
                }
			});

	        grid.cellChangeEvent(function(rowId, colId, iRow, iCol, value, oldValue) {

	        	if (colId == "UNIT_PRC") {
					
					var prQt = Number(grid.getCellValue(rowId, 'RFX_QT'));
					var unitPrc = Number(grid.getCellValue(rowId, 'UNIT_PRC'));
					var prAmt = 0;
					
					if(!EVF.isEmpty(unitPrc) && unitPrc == 0 ) {
						EVF.alert("${SRQI0011_0030}");
						grid.setCellValue(rowId, 'UNIT_PRC', null);
						grid.setCellValue(rowId, 'ITEM_AMT', null);
						return;
					}
					
					if(!EVF.isEmpty(prQt) && prQt > 0 && !EVF.isEmpty(unitPrc) && unitPrc > 0) {
						prAmt = everMath.floor_float(prQt * unitPrc);
						grid.setCellValue(rowId, 'ITEM_AMT', prAmt);
					} else {
						grid.setCellValue(rowId, 'ITEM_AMT', null);
					}

					var sumBidAmt = 0;
					var rowIds = grid.getAllRowId();
					for(var i in rowIds) {
						sumBidAmt = sumBidAmt + Number(grid.getCellValue(rowIds[i], 'ITEM_AMT'));
					}
					EVF.V("QTA_AMT", sumBidAmt);

					var swBusAmt = Number(grid.getCellValue(rowId, 'SW_BUS_PRICE'));
					if(!EVF.isEmpty(swBusAmt) && Number(swBusAmt) > 0 && !EVF.isEmpty(prAmt) && Number(prAmt) > 0) {
						grid.setCellValue(rowId, 'SW_BUS_RATE', ((swBusAmt - prAmt) / swBusAmt) * 100);
					} else {
						grid.setCellValue(rowId, 'SW_BUS_RATE', null);
					}
					var consumerAmt = Number(grid.getCellValue(rowId, 'CONSUMER_AMT'));
					if(!EVF.isEmpty(consumerAmt) && Number(consumerAmt) > 0 && !EVF.isEmpty(prAmt) && Number(prAmt) > 0) {
						grid.setCellValue(rowId, 'CONSUMER_RATE', ((consumerAmt - prAmt) / consumerAmt) * 100);
					} else {
						grid.setCellValue(rowId, 'CONSUMER_RATE', null);
					}
				}
				if (colId == "SW_BUS_PRICE") {

					if(EVF.isEmpty(grid.getCellValue(rowId, 'ITEM_AMT'))) {
						EVF.alert("${SRQI0011_0011}");
						grid.setCellValue(rowId, 'SW_BUS_PRICE', null);
						return;
					}
					var prAmt = Number(grid.getCellValue(rowId, 'ITEM_AMT'));
					var swBusAmt = Number(grid.getCellValue(rowId, 'SW_BUS_PRICE'));
					if(!EVF.isEmpty(swBusAmt) && Number(swBusAmt) > 0 && !EVF.isEmpty(prAmt) && Number(prAmt) > 0) {
						grid.setCellValue(rowId, 'SW_BUS_RATE', ((swBusAmt - prAmt) / swBusAmt) * 100);
					} else {
						grid.setCellValue(rowId, 'SW_BUS_RATE', null);
					}
				}
				if (colId == "CONSUMER_AMT") {

					if(EVF.isEmpty(grid.getCellValue(rowId, 'ITEM_AMT'))) {
						EVF.alert("${SRQI0011_0011}");
						grid.setCellValue(rowId, 'CONSUMER_AMT', null);
						return;
					}
					var prAmt = Number(grid.getCellValue(rowId, 'ITEM_AMT'));
					var consumerAmt = Number(grid.getCellValue(rowId, 'CONSUMER_AMT'));
					if(!EVF.isEmpty(consumerAmt) && Number(consumerAmt) > 0 && !EVF.isEmpty(prAmt) && Number(prAmt) > 0) {
						grid.setCellValue(rowId, 'CONSUMER_RATE', ((consumerAmt - prAmt) / consumerAmt) * 100);
					} else {
						grid.setCellValue(rowId, 'CONSUMER_RATE', null);
					}
				}
			});
			
	        grid.setColGroup([
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
	        
	        if( ${!havePermission} ) {
	        	EVF.C('doSave').setDisabled(true);
    			EVF.C('doSubmit').setDisabled(true);
	    	} else {
    			if( ${param.detailView} ) {
		            EVF.C('doSave').setVisible(false);
		            EVF.C('doSubmit').setVisible(false);
    			} else {
		            if (buttonStatus == 'Y') {
			            EVF.C('doSave').setVisible(true);
			            EVF.C('doSubmit').setVisible(true);
			        } else {
			        	EVF.C('doSave').setVisible(false);
			            EVF.C('doSubmit').setVisible(false);
			        }
    			}
	    	}
	        
	     	// ======================그리드 합계 구하기=======================
		    var val = {"visible": true, "count": 1, "height": 15};
		    grid.setProperty('footerVisible', val);

		    var footer = {
		          "styles": {
		              "textAlignment": "center",
		              "fontBold": true,
		              "fontFmaily": "Nanum Gothic",
		          },
		          "text": "합   계"
		    };
		    grid.setRowFooter("BUYER_DEPT_NM", footer);

		    var distVal = {
		          "styles": {
		              "textAlignment": "far",
		              "numberFormat" : "#,###.###",
		              "fontFmaily": "Nanum Gothic",
		              "paddingRight": 5,
		              "fontBold": true
		          },
		          "expression": ["sum"],
		          "groupExpression": "sum"
		    };
		    grid.setRowFooter("RFX_QT", distVal);
		    grid.setRowFooter("ITEM_AMT", distVal);
		    grid.setRowFooter("SW_BUS_PRICE", distVal);
		    grid.setRowFooter("CONSUMER_AMT", distVal);
		    grid.setRowFooter("DOIB_AMT", distVal);
		    // ===========================================================
		    
	        doSearchDT();
	        
	        setText();
	        
	        EVF.C("VAT_TYPE_LOC").setStyle("color:#FF0000;font-weight:bold;");
	    }

	    function doSearchDT() {
			
	    	var store = new EVF.Store();
	    	store.setGrid([grid]);
	        store.load(baseUrl + 'srqi0011_doSearchDT.so', function() {
	        	if(grid.getRowCount() > 0){

                    grid.checkAll(true);

                    grid.setColIconify("PR_ITEM_RMK", "PR_ITEM_RMK", "comment", false);
                    grid.setColIconify("VENDOR_ITEM_RMK", "VENDOR_ITEM_RMK", "comment", false);
    	            // 2021.06.14 그리드 변경
                    //grid.setColIconify("PR_ATT_FILE_CNT", "PR_ATT_FILE_CNT", "file", false);
    	            //grid.setColIconify("VENDOR_ATT_FILE_CNT", "VENDOR_ATT_FILE_CNT", "file", ('${ses.userType}' === "S" ? ('${buttonStatus}' == 'Y' ? true : false) : false));

					var rowIds = grid.getSelRowId();
					for(var i in rowIds) {

						<%-- 구매유형이 '용역'인 경우, [SW사업대가, 상주여부] 필수 --%>
						if(grid.getCellValue(rowIds[i], 'PURCHASE_TYPE') == "S") {
							grid.setCellRequired(rowIds[i], 'SW_BUS_PRICE', true);
							grid.setCellRequired(rowIds[i], 'MNT_SANGJU_YN', true);
						}
						<%-- 구매유형이 '물품/공사'인 경우, [소비자금액, 무상유지보수기간, 유상요율] 필수 --%>
						if(grid.getCellValue(rowIds[i], 'PURCHASE_TYPE') == "G" || grid.getCellValue(rowIds[i], 'PURCHASE_TYPE') == "C") {
							grid.setCellRequired(rowIds[i], 'CONSUMER_AMT', true);
							grid.setCellRequired(rowIds[i], 'FC_MNT_TERM', true);
							grid.setCellRequired(rowIds[i], 'CH_RATE', true);
						}
						<%-- 구매유형이 '유지보수'인 경우, [도입금액, 유지보수요율, 유지보수시작일, 유지보수종료일, 개월수, 정기점검주기, 장애복구목표시간] 필수 --%>
						if(grid.getCellValue(rowIds[i], 'PURCHASE_TYPE') == "M") {
							grid.setCellRequired(rowIds[i], 'DOIB_AMOUNT', true);
							grid.setCellRequired(rowIds[i], 'MNT_RATE', true);
							grid.setCellRequired(rowIds[i], 'MNT_SDAY', true);
							grid.setCellRequired(rowIds[i], 'MNT_EDAY', true);
							grid.setCellRequired(rowIds[i], 'MNT_GUR_MONTH', true);
							grid.setCellRequired(rowIds[i], 'RT_INSP_PERIOD', true);
							grid.setCellRequired(rowIds[i], 'FALT_RC_TG_TIME', true);
						}
						<%-- 구매유형이 '도급'인 경우, [유지보수시작일, 유지보수종료일, 개월수, 정기점검주기, 장애복구목표시간] 필수 --%>
						if(grid.getCellValue(rowIds[i], 'PURCHASE_TYPE') == "O") {
							grid.setCellRequired(rowIds[i], 'MNT_SDAY', true);
							grid.setCellRequired(rowIds[i], 'MNT_EDAY', true);
							grid.setCellRequired(rowIds[i], 'MNT_GUR_MONTH', true);
							grid.setCellRequired(rowIds[i], 'RT_INSP_PERIOD', true);
							grid.setCellRequired(rowIds[i], 'FALT_RC_TG_TIME', true);
						}
						
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
	        	}
	        });
	    }
		
	    function doSubmit() {
			
	    	var popupFlag = ${(param.popupFlag == null || !param.popupFlag) ? false : true};
	    	var sendFlag = this.data.data;
	    	
	    	var store = new EVF.Store();
			if(!store.validate()) { return;}
			
			grid.checkAll(true);
			if (!grid.validate().flag) { return EVF.alert(grid.validate().msg); }
			
			// 견적(년단가)인 경우 유효시작일, 유효종료일 필수
	    	var rowIds  = grid.getSelRowId();
	    	for(var i in rowIds) {
	    		if(EVF.V("RFX_TYPE") == "RYQ") { // 견적(년단가)
	    			if(EVF.isEmpty(grid.getCellValue(rowIds[i], 'VALID_FROM_DATE'))) {
	    				return EVF.alert("'" + grid.getCellValue(rowIds[i], 'ITEM_DESC') + "'의 " + "${SRQI0011_0012}");
    				}
	    			if(EVF.isEmpty(grid.getCellValue(rowIds[i], 'VALID_TO_DATE'))) {
	    				return EVF.alert("'" + grid.getCellValue(rowIds[i], 'ITEM_DESC') + "'의 " + "${SRQI0011_0013}");
    				}
	    		}
	    	}
			
	    	if( EVF.isEmpty(EVF.V("QTA_AMT")) || Number(EVF.V("QTA_AMT")) <= 0 ) {
	    		return EVF.alert("${SRQI0011_0029}");
	    	}
	    	
            var vatTypeLoc = EVF.V('VAT_TYPE_LOC');
            var commaAmt = "";
			var amtStr   = EVF.V('QTA_AMT') + "";
			if(amtStr.length > 3){
				var loop = Math.ceil(amtStr.length / 3);
				var offset = amtStr.length % 3;
				if((amtStr.length % 3) == 0){
					offset = 3;
				}
				commaAmt = amtStr.substring(0, offset);
				for(var i = 1; i < loop; i++){
					commaAmt += "," + amtStr.substring(offset, offset+3);
					offset += 3;
				}
			}
			
            var msg = "제출 총 금액은 " + commaAmt +"원"+ setCur() + "입니다. "+ vatTypeLoc +" 금액이 맞는지 다시 한번 확인하시기 바랍니다.";
            var sendMsg = "총 금액은 " + commaAmt +"원"+ setCur() + " " + vatTypeLoc +"으로 최종 견적서를 제출하시겠습니까?\n※제출 후 변경 불가하며 낙찰 시 해당 금액으로 계약 체결";
            
            var confirmMsg = (sendFlag == "T" ? "${msg.M0021}" : msg);
            
            EVF.confirm(confirmMsg, function () {
            	
	    	//var confirmMsg = (sendFlag == "T" ? "${msg.M0021}" : "${SRQI0011_submit}");
            //if(!confirm(confirmMsg)) { return; }
				<%-- local에서 테스트시 localServerFlag : "N", skip은 localServerFlag : "Y"
				localServerFlag = "N"; --%>
				if(localServerFlag == "Y" || sendFlag == "T") {
		            store.setParameter('sendFlag', sendFlag);
	            	store.setGrid([grid]);
		            store.getGridData(grid, 'all');
		            store.doFileUpload(function() {
		            	store.load(baseUrl + "srqi0011_doSave.so", function() {
							var buyerCd = this.getParameter("BUYER_CD");
							var rfxNum  = this.getParameter("RFX_NUM");
							var rfxCnt  = this.getParameter("RFX_CNT");
							var qtaNum  = this.getParameter("QTA_NUM");
							var rfxType = this.getParameter("RFX_TYPE");
							
							EVF.alert(this.getResponseMessage());
	                        if(this.getParameter("signedCd") == "1") {
		                        var param = {
		                        		BUYER_CD: buyerCd,
		                        		RFX_NUM: rfxNum,
			               				RFX_CNT: rfxCnt,
			               				QTA_NUM: qtaNum,
			               	        	RFX_TYPE: rfxType,
			               	        	VENDOR_CD: "${formData.VENDOR_CD }",
			               				detailView: false,
			               				popupFlag: true
			               			};
		                        if(popupFlag) {
		               	    		opener.doSearch();
		               	        	window.location.href = '/nhepro/SRQR/SRQI0011/view.so?' + $.param(param);
		               	    	} else {
		               	    		document.location.href = '/nhepro/SRQR/SRQI0011/view.so?' + $.param(param);
		               	    	}
	                        }
	                    });
		            });
	            } else {
	            	EVF.confirm(sendMsg, function () {
		                // SIGN_VALUE=협력업체코드@@idn@@투찰금액@@signDate
		            	document.reqForm.signData.value = EVF.V("VENDOR_CD") + "@@" + document.reqForm.idn.value + "@@" + EVF.V("QTA_AMT") + "@@" + "${signDate}";
		            	
		            	var certOdiFilter = "${certOidfilter}";
						var listOdiArr = certOdiFilter.split(";");
						var certOidfilter = "";
						for(var i in listOdiArr) {
							certOidfilter = certOidfilter + listOdiArr[i] + ",";
						}
						certOidfilter = certOidfilter.substring(0, certOidfilter.length-1);
						
		                magicline.uiapi.MakeSignData(document.reqForm, null, mlCallBack, certOidfilter);
	            	});
	            }
			
            });
		}

	    function mlCallBack(code, message){
	    	
	    	var popupFlag = ${(param.popupFlag == null || !param.popupFlag) ? false : true};
	    	
			if(code == 0){ <%-- 정상메시지 --%>
				if (message.encMsg != null) { document.reqForm.signedData.value = encodeURIComponent(message.encMsg); }
				if (message.vidRandom != null) { document.reqForm.vidRandom.value = encodeURIComponent(message.vidRandom); }

				var store = new EVF.Store();
	            store.setParameter('sendFlag', "S");
				store.setParameter("signedData", document.reqForm.signedData.value);
				store.setParameter("vidRandom", document.reqForm.vidRandom.value);
				store.setParameter("idn", document.reqForm.idn.value);
				store.setParameter("localServerFlag", localServerFlag);

            	store.setGrid([grid]);
	            store.getGridData(grid, 'all');
				store.doFileUpload(function() {
					store.load(baseUrl + 'srqi0011_doSubmit.so', function(){
						var buyerCd = this.getParameter("BUYER_CD");
						var rfxNum  = this.getParameter("RFX_NUM");
						var rfxCnt  = this.getParameter("RFX_CNT");
						var qtaNum  = this.getParameter("QTA_NUM");
						var rfxType = this.getParameter("RFX_TYPE");
						
						EVF.alert(this.getResponseMessage(), function() {
	                        var param = {
	                        		BUYER_CD: buyerCd,
	                        		RFX_NUM: rfxNum,
		               				RFX_CNT: rfxCnt,
		               				QTA_NUM: qtaNum,
		               	        	RFX_TYPE: rfxType,
		               	        	VENDOR_CD: "${formData.VENDOR_CD }",
		               				detailView: false,
		               				popupFlag: true
		               			};
							if(popupFlag) {
	               	    		opener.doSearch();
	               	    		doClose();
	               	    	} else {
	               	    		document.location.href = '/nhepro/SRQR/SRQI0011/view.so?' + $.param(param);
	               	    	}
						});
					});
				});
			} else {
				return EVF.alert("결과값 수신에 실패하였습니다.");
			}
		}
		
	    // 협력업체 담당자 조회 팝업
	    function getPicUserId() {
			var param = {
				COMPANY_CD : "${ses.companyCd}",
				callBackFunction : "setPicUserId"
			};
			everPopup.openCommonPopup(param, 'SP0026');
		}

	    function setPicUserId(dataJsonArray) {
			EVF.V("PIC_USER_NM", dataJsonArray.USER_NM);
			EVF.V("PIC_TEL_NUM", dataJsonArray.TEL_NUM);
		}
		
	    // 견적유효일자 체크
	    function chkValidDate() {
	    	if(!EVF.isEmpty(EVF.V("VALID_TO_DATE"))) {
				var validDate = Number(EVF.V("VALID_TO_DATE"));
				if ("${today}" > validDate) {
					EVF.V("VALID_TO_DATE", "", false);
					return EVF.alert('${SRQI0011_0014}');
				}
	    	}
	    }
	    
	    function setFileAttach(rowIdx, fileId, fileCnt) {
            grid.setCellValue(rowIdx, 'VENDOR_ATT_FILE_CNT', fileCnt);
            grid.setCellValue(rowIdx, 'VENDOR_ATT_FILE_NUM', fileId);
        }

        function setRMK(data) {
            grid.setCellValue(data.rowIdx, "VENDOR_ITEM_RMK", data.message);
            grid.setColIconify("VENDOR_ITEM_RMK", "VENDOR_ITEM_RMK", "comment", false);
        }

	    function doClose() {
			EVF.closeWindow();
        }

		function setText() {

			var element = Number(EVF.V('QTA_AMT'));
			var num = String(element);
			var hanA = new Array("", "일", "이", "삼", "사", "오", "육", "칠", "팔", "구");
			var danA = new Array("", "십", "백", "천", "", "십", "백", "천", "", "십", "백", "천", "", "십", "백", "천");
			var result = "";

			var C1 = true;
			var C2 = true;
			var C3 = true;
			for (var i = 0; i < num.length; i++) {
				var str = "";
				var han = hanA[num.charAt(num.length - (i + 1))];
				if (han != "") {
					str += han+danA[i];

					if (4 <= i && i <= 7  && C1 == true) {str += "만"; C1 = false;}
					if (8 <= i && i <= 11 && C2 == true) {str += "억"; C2 = false;}
					if (i >= 12 && C3 == true) {str += "조"; C3 = false;}
					result = str + result;
				}
			}

			result = (EVF.V('CUR') == "KRW") ? " ( 금 " + result + "원 )" : " ( " + result + " " + EVF.V('CUR') +" )";
			return result;
		}
		
		function setCur() {

			var element = Number(EVF.V('QTA_AMT'));
			var num = String(element);
			var hanA = new Array("", "일", "이", "삼", "사", "오", "육", "칠", "팔", "구");
			var danA = new Array("", "십", "백", "천", "", "십", "백", "천", "", "십", "백", "천", "", "십", "백", "천");
			var result = "";

			var C1 = true;
			var C2 = true;
			var C3 = true;
			for (var i = 0; i < num.length; i++) {
				var str = "";
				var han = hanA[num.charAt(num.length - (i + 1))];
				if (han != "") {
					str += han+danA[i];

					if (4 <= i && i <= 7  && C1 == true) {str += "만"; C1 = false;}
					if (8 <= i && i <= 11 && C2 == true) {str += "억"; C2 = false;}
					if (i >= 12 && C3 == true) {str += "조"; C3 = false;}
					result = str + result;
				}
			}

			result = (EVF.V('CUR') == "KRW") ? " ( 금 " + result + "원 )" : " ( " + result + " " + EVF.V('CUR') +" )";
			return result;
		}

    </script>
    
	<e:window id="SRQI0011" initData="${initData}" onReady="init" title="${fullScreenName }" breadCrumbs="${breadCrumb }">
		
		<e:inputHidden id="BUYER_CD" name="BUYER_CD" value="${formData.BUYER_CD }" />
		<e:inputHidden id="VENDOR_CD" name="VENDOR_CD" value="${formData.VENDOR_CD }" />
		<e:inputHidden id="PROGRESS_CD" name="PROGRESS_CD" value="${formData.PROGRESS_CD }" />
		<e:inputHidden id="SETTLE_TYPE" name="SETTLE_TYPE" value="${formData.SETTLE_TYPE }" />

		<e:buttonBar id="buttonBarTop" align="right" width="100%" title="${form_CAPTION1_N }">
			<e:button id="doSave" name="doSave" label="${doSave_N}" onClick="doSubmit" disabled="${doSave_D}" visible="${doSave_V}" data="T" />
			<e:button id="doSubmit" name="doSubmit" label="${doSubmit_N}" onClick="doSubmit" disabled="${doSubmit_D}" visible="${doSubmit_V}" data="S" />
			<e:button id="doClose" name="doClose" label="${doClose_N}" onClick="doClose" disabled="${doClose_D}" visible="${doClose_V}"/>
		</e:buttonBar>

		<e:searchPanel id="form1" labelWidth="${labelWidth}" width="100%" columnCount="2" useTitleBar="false">
			<e:row>
				<e:label for="RFX_NUM" title="${form_RFX_NUM_N}"/>
				<e:field>
					<e:inputText id="RFX_NUM" name="RFX_NUM" value="${formData.RFX_NUM }" width="${form_RFX_NUM_W}" maxLength="${form_RFX_NUM_M}" disabled="${form_RFX_NUM_D}" readOnly="${form_RFX_NUM_RO}" required="${form_RFX_NUM_R}"  maskType="${form_RFX_NUM_MT}" />
					<e:text>&nbsp;/&nbsp;</e:text>
					<e:inputText id="RFX_CNT" name="RFX_CNT" value="${formData.RFX_CNT }" width="${form_RFX_CNT_W}" maxLength="${form_RFX_CNT_M}" disabled="${form_RFX_CNT_D}" readOnly="${form_RFX_CNT_RO}" required="${form_RFX_CNT_R}"  maskType="${form_RFX_CNT_MT}" />
				</e:field>
				<e:label for="RFX_TYPE" title="${form_RFX_TYPE_N}" />
				<e:field>
					<e:text> ${formData.RFX_TYPE_LOC } </e:text>
					<e:inputHidden id="RFX_TYPE" name="RFX_TYPE" value="${formData.RFX_TYPE }"/>
				</e:field>
			</e:row>
			<e:row>
				<e:label for="RFX_SUBJECT" title="${form_RFX_SUBJECT_N}"/>
				<e:field colSpan="3">
					<e:text> ${formData.RFX_SUBJECT } </e:text>
				</e:field>
			</e:row>
			<e:row>
				<e:label for="RFQ_SC_DATE" title="${form_RFQ_SC_DATE_N}"/>
				<e:field>
					<e:text> ${formData.RFQ_SC_DATE } </e:text>
				</e:field>
				<e:label for="AMT_TYPE_LOC" title="${form_AMT_TYPE_LOC_N}"/>
				<e:field>
					<e:text> ${formData.AMT_TYPE_LOC } </e:text>
					<e:inputHidden id="AMT_TYPE" name="AMT_TYPE" value="${formData.AMT_TYPE }"/>
				</e:field>
			</e:row>
		</e:searchPanel>
		
		<div class="e-component e-title-container" data-uuid="Title-541-391-560">
			<div class="e-title-bullet-h1"></div>
			<div class="e-title-text">${form_CAPTION2_N }</div>
		</div>
		
		<e:searchPanel id="form2" labelWidth="${labelWidth}" width="100%" columnCount="2" useTitleBar="false">
			<e:row>
				<e:label for="QTA_NUM" title="${form_QTA_NUM_N}"/>
				<e:field colSpan="3">
					<e:inputText id="QTA_NUM" name="QTA_NUM" value="${formData.QTA_NUM }" width="${form_QTA_NUM_W}" maxLength="${form_QTA_NUM_M}" disabled="${form_QTA_NUM_D}" readOnly="${form_QTA_NUM_RO}" required="${form_QTA_NUM_R}"  maskType="${form_QTA_NUM_MT}" />
				</e:field>
			</e:row>
			<e:row>
				<e:label for="PIC_USER_NM" title="${form_PIC_USER_NM_N}"/>
				<e:field>
					<e:inputText id="PIC_USER_NM" name="PIC_USER_NM" value="${formData.PIC_USER_NM }" width="${form_PIC_USER_NM_W}" maxLength="${form_PIC_USER_NM_M}" disabled="${form_PIC_USER_NM_D}" readOnly="${form_PIC_USER_NM_RO}" required="${form_PIC_USER_NM_R}"  maskType="${form_PIC_USER_NM_MT}" />
				</e:field>
				<e:label for="PIC_TEL_NUM" title="${form_PIC_TEL_NUM_N}"/>
				<e:field>
					<e:inputText id="PIC_TEL_NUM" name="PIC_TEL_NUM" value="${formData.PIC_TEL_NUM }" width="${form_PIC_TEL_NUM_W}" maxLength="${form_PIC_TEL_NUM_M}" disabled="${form_PIC_TEL_NUM_D}" readOnly="${form_PIC_TEL_NUM_RO}" required="${form_PIC_TEL_NUM_R}"  maskType="${form_PIC_TEL_NUM_MT}" />
				</e:field>
			</e:row>
			<e:row>
				<e:label for="PIC_EMAIL" title="${form_PIC_EMAIL_N}"/>
				<e:field colSpan="3">
					<e:inputText id="PIC_EMAIL" name="PIC_EMAIL" value="${formData.PIC_EMAIL }" width="43%" maxLength="${form_PIC_EMAIL_M}" disabled="${form_PIC_EMAIL_D}" readOnly="${form_PIC_EMAIL_RO}" required="${form_PIC_EMAIL_R}"  maskType="${form_PIC_EMAIL_MT}" />
					<e:text style="color: red;font-weight: bold;">(담당자 정보는 개인정보 수집·이용 동의서 서명자와 동일)</e:text>
				</e:field>
			</e:row>
			<e:row>
				<e:label for="QTA_AMT" title="${form_QTA_AMT_N}"/>
				<e:field>
					<e:inputNumber id="QTA_AMT" name="QTA_AMT" value='${formData.QTA_AMT }' align='right' width='${form_QTA_AMT_W}' required='${form_QTA_AMT_R }' readOnly='${form_QTA_AMT_RO }' disabled='${form_QTA_AMT_D }' visible='${form_QTA_AMT_V }' decimalPlace="0"  onNumberKr="${form_QTA_AMT_KR}" currencyText="${form_QTA_AMT_CT}" />
					<e:select id="CUR" name="CUR" value="${formData.CUR }" options="${curOptions }" width="${form_CUR_W }" disabled="${form_CUR_D}" readOnly="${form_CUR_RO}" required="${form_CUR_R}" placeHolder=""  maskType="${form_CUR_MT}"/>
					<e:inputText id="VAT_TYPE_LOC" name="VAT_TYPE_LOC" value="${formData.VAT_TYPE_LOC }" width="${form_VAT_TYPE_LOC_W}" maxLength="${form_VAT_TYPE_LOC_M}" disabled="${form_VAT_TYPE_LOC_D}" readOnly="${form_VAT_TYPE_LOC_RO}" required="${form_VAT_TYPE_LOC_R}"  maskType="${form_VAT_TYPE_LOC_MT}" />
					<e:inputHidden id="VAT_TYPE" name="VAT_TYPE" value="${formData.VAT_TYPE }"/>
					<%-- <e:select id="VAT_TYPE" name="VAT_TYPE" value="${formData.VAT_TYPE }" options="${vatTypeOptions }" width="${form_VAT_TYPE_W }" disabled="${form_VAT_TYPE_D}" readOnly="${form_VAT_TYPE_RO}" required="${form_VAT_TYPE_R}" placeHolder=""  maskType="${form_VAT_TYPE_MT}"/> --%>
				</e:field>
				<e:label for="VALID_TO_DATE" title="${form_VALID_TO_DATE_N}" />
				<e:field>
					<e:inputDate id="VALID_TO_DATE" name="VALID_TO_DATE" value="${formData.VALID_TO_DATE }" width="${inputDateWidth}" required="${form_VALID_TO_DATE_R}" disabled="${form_VALID_TO_DATE_D}" readOnly="${form_VALID_TO_DATE_RO}" datePicker="true" onChange="chkValidDate" />
				</e:field>
			</e:row>
			<e:row>
				<e:label for="QTA_RMK_TEXT" title="${form_QTA_RMK_TEXT_N }" />
				<e:field colSpan="3">
                	<e:richTextEditor id="QTA_RMK_TEXT" name="QTA_RMK_TEXT" width="100%" height="180px" value="${formData.QTA_RMK_TEXT }" required="${form_QTA_RMK_TEXT_R }" readOnly="${form_QTA_RMK_TEXT_RO }" disabled="${form_QTA_RMK_TEXT_D }" useToolbar="${!param.detailView}" />
                	<e:inputHidden id="QTA_RMK_TEXT_NUM" name="QTA_RMK_TEXT_NUM" value="${formData.QTA_RMK_TEXT_NUM }" />
 				</e:field>
			</e:row>
			<e:row>
				<e:label for="QTA_ATT_FILE_NUM" title="${form_QTA_ATT_FILE_NUM_N }" />
 				<e:field>
                    <e:fileManager id="QTA_ATT_FILE_NUM" name="QTA_ATT_FILE_NUM" bizType="RFQ" fileId="${formData.QTA_ATT_FILE_NUM}" readOnly="${havePermission ? (!param.detailView ? (formData.SIGN_STATUS == 'E' ? true : false) : true) : true }" downloadable="true" width="100%" height="120px" onBeforeRemove="onBeforeRemove" onError="onError" onFileClick="onFileClick" onSuccess="onSuccess" required="true" />
 				</e:field>
				<e:label for="ATT_FILE_NUM" title="${form_ATT_FILE_NUM_N }" />
 				<e:field>
                    <e:fileManager id="ATT_FILE_NUM" name="ATT_FILE_NUM" bizType="RFQ" fileId="${formData.ATT_FILE_NUM}" readOnly="${havePermission ? (!param.detailView ? (formData.SIGN_STATUS == 'E' ? true : false) : true) : true }" downloadable="true" width="100%" height="120px" onBeforeRemove="onBeforeRemove" onError="onError" onFileClick="onFileClick" onSuccess="onSuccess" required="" />
 				</e:field>
			</e:row>
		</e:searchPanel>

		<div class="e-component e-title-container" data-uuid="Title-541-391-560">
			<div class="e-title-bullet-h1"></div>
			<div class="e-title-text">${form_CAPTION3_N }</div>
		</div>

		<e:gridPanel id="grid" name="grid" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}"/>

		<%-- 인증정보 영역 --%>
		<form id='reqForm' name='reqForm' method='post' action="/MagicLine4Web/ML4Web/jcaosCheck.jsp">
            <input type="hidden" id="signData" name="signData" value=""/>
            <input type="hidden" id="signedData" name="signedData"/>
            <input type="hidden" id="vidRandom" name="vidRandom"/>
            <input type="hidden" id="vidType" name="vidType" value="client"/>
            <input type="hidden" id="idn" name="idn" value="${formData.IRS_NUM}"/>
        </form>

        <div id="dscertContainer">
            <iframe id="dscert" name="dscert" src="" width="100%" height="100%" frameborder="0" allowTransparency="true" style="position:fixed;z-index:100010;top:0px;left:0px;width:100%;height:100%;"></iframe>
        </div>

	</e:window>
</e:ui>