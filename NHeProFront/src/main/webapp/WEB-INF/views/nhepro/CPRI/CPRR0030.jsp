<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
	<script type="text/javascript">
		var grid = {};
		var addParam = [];
	    var baseUrl = "/nhepro/CPRI/CPRR0030/";

	    function init() {
			grid = EVF.C('grid');

			// 구매유형에서 "수선,제작,품의" 제외하고 나머지 코드값은 Invisible
			//EVF.C('PR_TYPE').removeOption('ISP'); // 투자품의

			grid.excelExportEvent({
				allCol : "${excelExport.allCol}",
				fileName : "${screenName }"
			});

			// 2021.01.26 진행상태 제외
			EVF.C('PROGRESS_CD').removeOption('2330'); // 종합입찰진행중
			EVF.C('PROGRESS_CD').removeOption('2335'); // 종합입찰마감
			EVF.C('PROGRESS_CD').removeOption('2355'); // 입찰/견적마감
			EVF.C('PROGRESS_CD').removeOption('2400'); // 업체선정대기
			EVF.C('PROGRESS_CD').removeOption('2550'); // 재입찰/견적
			EVF.C('PROGRESS_CD').removeOption('3100'); // 품의중
			EVF.C('PROGRESS_CD').removeOption('4210'); // 협력사서명대기
			EVF.C('PROGRESS_CD').removeOption('4220'); // 협력사서명반려
			EVF.C('PROGRESS_CD').removeOption('4230'); // 협력사서명완료
			EVF.C('PROGRESS_CD').removeOption('5100'); // 발주대기
			EVF.C('PROGRESS_CD').removeOption('5300'); // 협력사발주접수
			EVF.C('PROGRESS_CD').removeOption('6100'); // 부분검수요청
			EVF.C('PROGRESS_CD').removeOption('6200'); // 부분검수완료
			EVF.C('PROGRESS_CD').removeOption('7100'); // 전체검수요청
			EVF.C('PROGRESS_CD').removeOption('7200'); // 전체검수완료
			EVF.C('PROGRESS_CD').removeOption('7300'); // 대금청구요청
			EVF.C('PROGRESS_CD').removeOption('7400'); // 대금청구완료
			EVF.C('PROGRESS_CD').removeOption('8100'); // 정산중
			EVF.C('PROGRESS_CD').removeOption('8200'); // 정산완료

			grid.cellClickEvent(function(rowIdx, colIdx, value) {
				var param;
				if (colIdx == "VENDOR_CDXXXX") {
					param = {
						VENDOR_CD: grid.getCellValue(rowIdx, "VENDOR_CD"),
						popupFlag: true,
						detailView : true
					};
					everPopup.openSupManagementPopup(param);
				}
				if (colIdx=='ITEM_CD') {
					param = {
						ITEM_CD : grid.getCellValue(rowIdx,"ITEM_CD"),
						STD_ITEM_CD : grid.getCellValue(rowIdx,"ITEM_CD")
					};
					everPopup.openItemDetailInformation(param);
				}
				if (colIdx == "PR_NUM") {
					param = {
						prNum: grid.getCellValue(rowIdx, "PR_NUM"),
						buyerCd : grid.getCellValue(rowIdx, "BUYER_CD"),
						popupFlag: true,
						detailView : true
					};
					everPopup.openPopupByScreenId("CPRI0010", 1200, 900, param);
				}
				/*
				if (colIdx == "RFX_NUM") {
					if( value == "" ) return;
                    param = {
	                        callbackFunction: "",
	                        BUYER_CD: grid.getCellValue(rowIdx, "RFX_BUYER_CD"),
	                        RFX_NUM: value,
	                        RFX_CNT: grid.getCellValue(rowIdx, "RFX_CNT"),
	                        detailView: true,
	                        popupFlag: true
	                    };
                    everPopup.openWindowPopup("/nhepro/CRQR/CRQI0011/view.so", 1200, 900, param, "RFX", true);
				}*/
				if(colIdx == "RFX_SETTLE_FLAG") {
					if( grid.getCellValue(rowIdx, 'QTA_NUM') == "" ) return;
					var param = {
	    	        		BUYER_CD: grid.getCellValue(rowIdx, 'RFX_BUYER_CD'),
		    	        	RFX_NUM: '',
		    	        	RFX_CNT: '',
		    	        	QTA_NUM: grid.getCellValue(rowIdx, 'QTA_NUM'),
		    	        	RFX_TYPE: '',
		    	        	VENDOR_CD: grid.getCellValue(rowIdx, 'RFX_VENDOR_CD'),
	    		            detailView: true,
	    		            popupFlag: true
		    		    };
	    	        everPopup.openPopupByScreenId("SRQI0011", 1200, 900, param);
					
				}
				if (colIdx == "ANN_NO") {
					if( grid.getCellValue(rowIdx, 'BID_NUM') == "" ) return;
					param = {
							buyerCd    : grid.getCellValue(rowIdx, 'BID_BUYER_CD'),
							bidNum     : grid.getCellValue(rowIdx, 'BID_NUM'),
							bidCnt     : grid.getCellValue(rowIdx, 'BID_CNT'),
							detailView : true,
							popupFlag  : true
						};
					<%-- 입찰/취소 공고 상세화면을 Popup으로 open. --%>
                    var bidStatus  = grid.getCellValue(rowIdx, 'BID_STATUS');
                    var callUrl    = ((bidStatus == "2303" || bidStatus == "2330") ? "/nhepro/CBDI/CBDR0014/view.so" : "/nhepro/CBDI/CBDR0012/view.so");
                    var callHeight = ((bidStatus == "2303" || bidStatus == "2330") ? 700 : 900);
					everPopup.openWindowPopup(callUrl, 1200, callHeight, param, "BID", true);
				}
				if(colIdx == "BID_SETTLE_FLAG") {
					if( value == "" ) return;
					var param = {
							'buyerCd'    : grid.getCellValue(rowIdx, 'BID_BUYER_CD'),
							'bidNum'     : grid.getCellValue(rowIdx, 'BID_NUM'),
							'bidCnt'     : grid.getCellValue(rowIdx, 'BID_CNT'),
							'popupFlag'  : true,
							'detailView' : true
						};
					everPopup.openWindowPopup("/nhepro/CBDI/CBDI0021/view.so", 1200, 800, param, "bidAppClose", true);
				}
				/*
				if (colIdx == "BID_VENDOR_NM") {
					if( grid.getCellValue(rowIdx, 'BID_VENDOR_CD') == "" ) return;
					param = {
	                        VENDOR_CD: grid.getCellValue(rowIdx, 'BID_VENDOR_CD'),
	                        detailView: true,
	                        popupFlag: true,
	                        buttonView: false
	                    };
	                everPopup.openPopupByScreenId("CVNR0011", 1000, 730, param);
				}
				if (colIdx == "EXEC_NUM") {
					if( value == "" ) return;
					param = {
							buyerCd: grid.getCellValue(rowIdx, 'EXEC_BUYER_CD'),
							execNum: grid.getCellValue(rowIdx, 'EXEC_NUM'),
							tcoFlag: null,
							detailView: true,
							popupFlag: true
						};
					everPopup.openWindowPopup("/nhepro/CBDR/CBDI0061/view.so", 1200, 900, param, "EXEC", true);
				}*/
				if (colIdx == "CONT_NUM") {
					if( value == "" ) return;
					param = {
							callBackFunction: '',
							BUYER_CD: grid.getCellValue(rowIdx, "CONT_BUYER_CD"),
							CONT_NUM: value,
							CONT_CNT: grid.getCellValue(rowIdx, "CONT_CNT"),
							url: "/nhepro/CCTR/CCTA0030/view.so",
							detailView: true,
							popupFlag: true
						};
					everPopup.openContractChangeInformation(param);
				}
				// IT포탈의 이전계약번호 링크 추가
				if (colIdx == "PRE_CONT_NUM") {
					if( value == "" ) return;
					param = {
							callBackFunction: '',
							BUYER_CD: grid.getCellValue(rowIdx, "PRE_BUYER_CD"),
							CONT_NUM: value,
							CONT_CNT: grid.getCellValue(rowIdx, "PRE_CONT_CNT"),
							url: "/nhepro/CCTR/CCTA0030/view.so",
							detailView: true,
							popupFlag: true
						};
					everPopup.openContractChangeInformation(param);
				}
				
				var prNum;
				var prSq;
				if (colIdx == "PO_QT") {
					prNum = grid.getCellValue(rowIdx,"PR_NUM");
					prSq = grid.getCellValue(rowIdx,"PR_SQ");
					everPopup.openPoQtyDetailInformation(prNum, prSq);
				}
				if (colIdx == "GR_QT") {
					prNum = grid.getCellValue(rowIdx,"PR_NUM");
					prSq = grid.getCellValue(rowIdx,"PR_SQ");
					everPopup.openAccumGrQtyDetailInformation(prNum, prSq);
				}
				
				//구매진행별상태 현황을 보여주는 그리드 클릭 시 해당 팝업 오픈
				//ex) 구매의뢰 진행상태 클릭 시 구매의뢰등록 팝업, 계약중 도는 계약완료인 경우 계약서작성팝업 오픈
				if (colIdx == "PROG_01") {
					
				}
			});

			grid.setProperty('shrinkToFit', ${shrinkToFit});		// 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
			grid.setProperty('rowNumbers', ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
			grid.setProperty('sortable', ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
			grid.setProperty('panelVisible', ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
			grid.setProperty('enterToNextRow', ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
			grid.setProperty('acceptZero', ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
			grid.setProperty('multiSelect', ${multiSelect});		// [선택] 컬럼의 사용여부를 지정한다. [true/false]
			grid.setProperty('singleSelect', true);		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]
			
			grid.setColGroup([
				{
                    "groupName": '구매진행상태',
                    "columns": ['PROGRESS_CD', 'PROG_01', 'PROG_02', 'PROG_03', 'PROG_04', 'PROG_05', 'PROG_06', 'PROG_07']
                }
				,{
                    "groupName": '구매의뢰정보',
                    "columns": ['PR_QT', 'UNIT_CD', 'UNIT_PRC', 'PR_AMT', 'CUR', 'VAT_TYPE']
                }
                ,{
                    "groupName": '견적정보',
                    "columns": ['RFX_DATE', 'RFX_NUM', 'RFX_CNT', 'RFX_SETTLE_FLAG', 'QTA_NUM', 'RFX_VENDOR_CD']
                }
                ,{
                    "groupName": '입찰정보',
                    "columns": ['BID_DATE', 'BID_NUM', 'BID_CNT', 'ANN_NO', 'BID_SETTLE_FLAG', 'BID_VENDOR_CD', 'BID_VENDOR_NM']
                }
                ,{
                    "groupName": '품의정보',
                    "columns": ['EXEC_DATE', 'EXEC_NUM']
                }
                ,{
                    "groupName": '계약정보',
                    "columns": ['CONT_DATE', 'CONT_NUM', 'CONT_CNT', 'CONT_VENDOR_CD', 'CONT_VENDOR_NM']
                }
                ,{
                    "groupName": '발주정보',
                    "columns": ['PO_QT', 'PO_AMT']
                }
                ,{
                    "groupName": '검수(납품)정보',
                    "columns": ['INV_QT', 'INV_AMT']
                }
                ,{
                    "groupName": '대금지급정보',
                    "columns": ['PAY_AMT', 'AP_AMT']
                }
                ,{
                    "groupName": '인터페이스정보(IT포탈)',
                    "columns": ['PRE_CONT_NUM', 'PRE_CONT_CNT', 'CM_REQ_ID', 'IF_TYPE']
                }
            ],70);
			
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
		    grid.setRowFooter("PR_BUYER_NM", footer);

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
		    grid.setRowFooter("PR_QT", distVal);
		    grid.setRowFooter("PR_AMT", distVal);
		    grid.setRowFooter("PO_QT", distVal);
		    grid.setRowFooter("PO_AMT", distVal);
		    grid.setRowFooter("INV_QT", distVal);
		    grid.setRowFooter("INV_AMT", distVal);
		    grid.setRowFooter("PAY_AMT", distVal);
		    grid.setRowFooter("AP_AMT", distVal);
		    // ===========================================================
		      
			//doSearch();
		    
		    /** 그룹화 필요한 경우 사용
			grid.setColMerge([
				"PR_BUYER_NM", "EC_BUYER_NM", "SIGN_STATUS_NM", "PR_NUM", "SUBJECT", "REQ_DATE", "REQ_USER_NM", "CTRL_USER_NM", "RECEIPT_DATE", "PURCHASE_TYPE", "PROGRESS_CD",
				"PROG_01", "PROG_02", "PROG_03", "PROG_04", "PROG_05", "PROG_06", "PROG_07",
				"PR_SQ", "ITEM_CD", "ITEM_DESC", "ITEM_SPEC", "PR_QT", "UNIT_CD", "UNIT_PRC", "PR_AMT"
				]);*/
    	}

		function doSearch() {
			var store = new EVF.Store();
			if(!store.validate()) return;
			store.setGrid([grid]);
			store.load(baseUrl + 'doSearch.so', function() {
				if(grid.getRowCount() == 0){
					EVF.alert("${msg.M0002 }");
				} else { // 2021.03.05 기능 추가, 2022.09.14 입찰 선정결과 낙찰 & 유찰인 경우 입찰등록결과 팝업 오픈기능 추가
					var rowIds = grid.getAllRowId();
		            for(var i in rowIds) {
		            	var progressCd = Number(grid.getCellValue(rowIds[i], 'PROGRESS_CD'));
		            	var BID_SETTLE_FLAG = grid.getCellValue(rowIds[i], "BID_SETTLE_FLAG");
		            	var RFX_SETTLE_FLAG = grid.getCellValue(rowIds[i], "RFX_SETTLE_FLAG");
		            	
		            	if( progressCd < 1300 ) { // 1300 : 유찰 이전은 구매의뢰가 되지 않은 것으로 함
		                	grid.setCellFontColor(rowIds[i], 'PROG_01', "#ffffff");
		                	grid.setCellFontColor(rowIds[i], 'PROG_02', "#ffffff");
		                	grid.setCellFontColor(rowIds[i], 'PROG_03', "#ffffff");
		                	grid.setCellFontColor(rowIds[i], 'PROG_04', "#ffffff");
		                	grid.setCellFontColor(rowIds[i], 'PROG_05', "#ffffff");
		                	grid.setCellFontColor(rowIds[i], 'PROG_06', "#ffffff");
		                	grid.setCellFontColor(rowIds[i], 'PROG_07', "#ffffff");
		                }
		            	else if( progressCd < 2300 ) { // 2300 : 견적/입찰 작성중 이전은 구매의뢰 완료
		                	grid.setCellFontColor(rowIds[i], 'PROG_01', "#ff0000");
		                	grid.setCellFontColor(rowIds[i], 'PROG_02', "#ffffff");
		                	grid.setCellFontColor(rowIds[i], 'PROG_03', "#ffffff");
		                	grid.setCellFontColor(rowIds[i], 'PROG_04', "#ffffff");
		                	grid.setCellFontColor(rowIds[i], 'PROG_05', "#ffffff");
		                	grid.setCellFontColor(rowIds[i], 'PROG_06', "#ffffff");
		                	grid.setCellFontColor(rowIds[i], 'PROG_07', "#ffffff");
		                }
		                else if( progressCd < 2500 ) { // 2500 : 업체선정 이전은 견적/입찰 진행중
		                	grid.setCellFontColor(rowIds[i], 'PROG_01', "#ff0000");
		                	grid.setCellFontColor(rowIds[i], 'PROG_02', "#ff0000");
		                	grid.setCellFontColor(rowIds[i], 'PROG_03', "#ffffff");
		                	grid.setCellFontColor(rowIds[i], 'PROG_04', "#ffffff");
		                	grid.setCellFontColor(rowIds[i], 'PROG_05', "#ffffff");
		                	grid.setCellFontColor(rowIds[i], 'PROG_06', "#ffffff");
		                	grid.setCellFontColor(rowIds[i], 'PROG_07', "#ffffff");
		                }
		                else if( progressCd == 2500 ) { // 2500 : 업체선정
		                	grid.setCellFontColor(rowIds[i], 'PROG_01', "#ff0000");
		                	grid.setCellFontColor(rowIds[i], 'PROG_02', "#ff0000");
		                	grid.setCellFontColor(rowIds[i], 'PROG_03', "#ff0000");
		                	grid.setCellFontColor(rowIds[i], 'PROG_04', "#ffffff");
		                	grid.setCellFontColor(rowIds[i], 'PROG_05', "#ffffff");
		                	grid.setCellFontColor(rowIds[i], 'PROG_06', "#ffffff");
		                	grid.setCellFontColor(rowIds[i], 'PROG_07', "#ffffff");
		                }
		                else if( progressCd < 4200 ) { // 4200 : 전자계약중 이전은 구매품의중 또는 품의완료
		                	grid.setCellFontColor(rowIds[i], 'PROG_01', "#ff0000");
		                	grid.setCellFontColor(rowIds[i], 'PROG_02', "#ff0000");
		                	grid.setCellFontColor(rowIds[i], 'PROG_03', "#ff0000");
		                	grid.setCellFontColor(rowIds[i], 'PROG_04', "#ff0000");
		                	grid.setCellFontColor(rowIds[i], 'PROG_05', "#ffffff");
		                	grid.setCellFontColor(rowIds[i], 'PROG_06', "#ffffff");
		                	grid.setCellFontColor(rowIds[i], 'PROG_07', "#ffffff");
		                }
		                else if( progressCd == 4200 ) { // 4200 : 계약중
		                	grid.setCellFontColor(rowIds[i], 'PROG_01', "#ff0000");
		            		// 연장계약(30)인 경우 Sourcing을 거치지 않음
		            		if( grid.getCellValue(rowIds[i], 'PR_TYPE') == "30" ) {
			                	grid.setCellFontColor(rowIds[i], 'PROG_02', "#ffffff");
			                	grid.setCellFontColor(rowIds[i], 'PROG_03', "#ffffff");
			                	grid.setCellFontColor(rowIds[i], 'PROG_04', "#ffffff");
		            		} else {
			                	grid.setCellFontColor(rowIds[i], 'PROG_02', "#ff0000");
			                	grid.setCellFontColor(rowIds[i], 'PROG_03', "#ff0000");
			                	grid.setCellFontColor(rowIds[i], 'PROG_04', "#ff0000");
		            		}
		                	grid.setCellFontColor(rowIds[i], 'PROG_05', "#ff0000");
		                	grid.setCellFontColor(rowIds[i], 'PROG_06', "#ffffff");
		                	grid.setCellFontColor(rowIds[i], 'PROG_07', "#ffffff");
		                }
		                else if( progressCd == 4300 ) { // 4300 : 계약완료
		                	grid.setCellFontColor(rowIds[i], 'PROG_01', "#ff0000");
		                	// 연장계약(30)인 경우 Sourcing을 거치지 않음
		            		if( grid.getCellValue(rowIds[i], 'PR_TYPE') == "30" ) {
			                	grid.setCellFontColor(rowIds[i], 'PROG_02', "#ffffff");
			                	grid.setCellFontColor(rowIds[i], 'PROG_03', "#ffffff");
			                	grid.setCellFontColor(rowIds[i], 'PROG_04', "#ffffff");
		            		} else {
			                	grid.setCellFontColor(rowIds[i], 'PROG_02', "#ff0000");
			                	grid.setCellFontColor(rowIds[i], 'PROG_03', "#ff0000");
			                	grid.setCellFontColor(rowIds[i], 'PROG_04', "#ff0000");
		            		}
		                	grid.setCellFontColor(rowIds[i], 'PROG_05', "#ff0000");
		                	grid.setCellFontColor(rowIds[i], 'PROG_06', "#ff0000");
		                	grid.setCellFontColor(rowIds[i], 'PROG_07', "#ffffff");
		                }
		                else if( progressCd >= 5200 ) { // 5200 : 발주완료
		                	grid.setCellFontColor(rowIds[i], 'PROG_01', "#ff0000");
		                	// 연장계약(30)인 경우 Sourcing을 거치지 않음
		            		if( grid.getCellValue(rowIds[i], 'PR_TYPE') == "30" ) {
			                	grid.setCellFontColor(rowIds[i], 'PROG_02', "#ffffff");
			                	grid.setCellFontColor(rowIds[i], 'PROG_03', "#ffffff");
			                	grid.setCellFontColor(rowIds[i], 'PROG_04', "#ffffff");
		            		} else {
			                	grid.setCellFontColor(rowIds[i], 'PROG_02', "#ff0000");
			                	grid.setCellFontColor(rowIds[i], 'PROG_03', "#ff0000");
			                	grid.setCellFontColor(rowIds[i], 'PROG_04', "#ff0000");
		            		}
		                	grid.setCellFontColor(rowIds[i], 'PROG_05', "#ff0000");
		                	grid.setCellFontColor(rowIds[i], 'PROG_06', "#ff0000");
		                	grid.setCellFontColor(rowIds[i], 'PROG_07', "#ff0000");
		                }
		            	
		            	if( !EVF.isEmpty(BID_SETTLE_FLAG)) {
	                    	grid.setCellFontColor(rowIds[i], 'BID_SETTLE_FLAG', "#0100FF");
	                        grid.setCellFontWeight(rowIds[i], 'BID_SETTLE_FLAG', true);
	                    }
		            	
		            	if(!EVF.isEmpty(RFX_SETTLE_FLAG)) {
		            		grid.setCellFontColor(rowIds[i], 'RFX_SETTLE_FLAG', "#0100FF");
	                        grid.setCellFontWeight(rowIds[i], 'RFX_SETTLE_FLAG', true);
		            	}
		            }
				}
			});
		}

		function doSearchUser() {
			param = {
					'callBackFunction': 'selectUser',
					'multiYN' : 'N',         //멀티팝업여부
					'detailView': false
			};
			everPopup.openPopupByScreenId("CCDU0020", 1100, 700, param);
		}

		function selectUser(data) {
			if(data!=null){
	    		data = JSON.parse(data);

	    		EVF.V("REQ_USER_ID", data.USER_ID);
				EVF.V("REQ_USER_NM", data.USER_NM);
			}
		}

		function removeUserId() {
			EVF.V('REQ_USER_ID', '');
		}

		function getEcBuyerCd() {
			param = {
					'callBackFunction': 'ecBuyerNmCallback',
					'detailView': false,
					callBackFunction: "setEcBuyerCd"
				};
				everPopup.openCommonPopup(param, "SP0119");
		}
		function setEcBuyerCd(data) {

			EVF.V("EC_BUYER_NM", data.BUYER_NM + ' ' +data.DEPT_NM);
			EVF.V("EC_BUYER_CD", data.BUYER_CD);
			EVF.V("EC_DEPT_CD", data.DEPT_CD);
		}
		
	    function doModify() {

	    	if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

	    	var prNum = ""; var prCnt = ""; var buyerCd = "";
	    	var rowIds = grid.getSelRowId();
	    	for(var i in rowIds) {
	       		if (grid.getCellValue(rowIds[i], 'IF_TYPE') == 'ITA' || grid.getCellValue(rowIds[i], 'IF_TYPE') == 'ITB') {
	 				return EVF.alert('${CPRR0030_0005}');
	     		}

	    		prNum = grid.getCellValue(rowIds[i], 'PR_NUM');
	    		prCnt = grid.getCellValue(rowIds[i], 'PR_CNT');
	    		buyerCd = grid.getCellValue(rowIds[i], 'BUYER_CD');

	    		if (grid.getCellValue(rowIds[i], 'SIGN_STATUS') == 'E' || grid.getCellValue(rowIds[i], 'SIGN_STATUS') == 'P') {
					return EVF.alert('${CPRR0030_0002}');
	    		}
	    		if (grid.getCellValue(rowIds[i], 'REG_USER_ID') != '${ses.userId}') {
					return EVF.alert('${CPRR0030_0003}');
	    		}
    		}

	    	var param = {
				'prNum': prNum,
				'prCnt': prCnt,
				'buyerCd': buyerCd,
				'detailView': false,
				'popupFlag': true
			};
			everPopup.openPopupByScreenId("CPRI0010", 1200, 900, param);
	    }
	    
	    function getCtrlId() {
        	var param = {
                callBackFunction : "setCtrlId",
                'READONLY': 'Y',         //팝업 조회조건 변경불가
                'multiYN' : 'N',         //멀티팝업여부
                'CTRL_CD' : 'BR030',
                'detailView': false
            };
            everPopup.openPopupByScreenId("CCDU0020", 1100, 700, param);
        }

        function setCtrlId(data) {
        	if(data!=null){
				data = JSON.parse(data);
	            EVF.V("CTRL_USER_ID", data.USER_ID);
	            EVF.V("CTRL_USER_NM", data.USER_NM);
        	}
        }
	</script>

    <e:window id="CPRR0030" onReady="init" initData="${initData}" title="${fullScreenName }" breadCrumbs="${breadCrumb }">
        <e:searchPanel id="form" columnCount="3" labelWidth="${labelWidth }" onEnter="doSearch" useTitleBar="false">
        	<e:inputHidden id="EC_DEPT_CD" name="EC_DEPT_CD"/>
        	<e:row>
				<e:label for="REQ_DATE_FROM" title="${form_REQ_DATE_FROM_N}"/>
				<e:field>
					<e:inputDate id="REQ_DATE_FROM" toDate="REQ_DATE_TO" name="REQ_DATE_FROM" value="${fromDate}" width="${inputTextDate}" datePicker="true" required="${form_REQ_DATE_R}" disabled="${form_REQ_DATE_D}" readOnly="${form_REQ_DATE_RO}" />
					<e:text> ~ </e:text>
				<e:inputDate id="REQ_DATE_TO" fromDate="REQ_DATE_FROM" name="REQ_DATE_TO" value="${toDate}" width="${inputTextDate}" datePicker="true" required="${form_REQ_DATE_R}" disabled="${form_REQ_DATE_D}" readOnly="${form_REQ_DATE_RO}" />
				</e:field>
				<e:label for="EC_BUYER_CD" title="${form_EC_BUYER_CD_N}"/>
				<e:field>
					<e:search id="EC_BUYER_CD" name="EC_BUYER_CD" value="" width="40%" maxLength="${form_EC_BUYER_CD_M}" onIconClick="${form_EC_BUYER_CD_RO ? 'getEcBuyerCd' : 'getEcBuyerCd'}" disabled="${form_EC_BUYER_CD_D}" readOnly="${form_EC_BUYER_CD_RO}" required="${form_EC_BUYER_CD_R}" maskType="${form_EC_BUYER_CD_MT}" placeHolder="회사코드" />
					<e:inputText id="EC_BUYER_NM" name="EC_BUYER_NM" value="" width="60%" maxLength="${form_EC_BUYER_NM_M}" disabled="${form_EC_BUYER_NM_D}" readOnly="${form_EC_BUYER_NM_RO}" required="${form_EC_BUYER_NM_R}" style="${imeMode}" maskType="${form_EC_BUYER_NM_MT}" placeHolder="회사명"/>
				</e:field>
				<e:label for="REQ_USER_NM" title="${form_REQ_USER_NM_N}"/>
				<e:field>
		            <e:search id="REQ_USER_ID" name="REQ_USER_ID" value=""  width="40%" maxLength="${form_REQ_USER_NM_M}" onIconClick="${form_REQ_USER_NM_D ? 'everCommon.blank' : 'doSearchUser'}" disabled="${form_REQ_USER_NM_D}" readOnly="${form_REQ_USER_NM_RO}" required="${form_REQ_USER_NM_R}" onKeyUp="removeUserId" maskType="${form_REQ_USER_NM_MT}" placeHolder="개인번호" />
					<e:inputText id="REQ_USER_NM" name="REQ_USER_NM" value="" width="60%" maxLength="${form_REQ_USER_NM_M}" disabled="${form_REQ_USER_NM_D}" readOnly="${form_REQ_USER_NM_RO}" required="${form_REQ_USER_NM_R}" style="${imeMode}" maskType="${form_REQ_USER_NM_MT}" placeHolder="성명"/>
				</e:field>
			</e:row>
        	<e:row>
				<e:label for="PR_NUM" title="${form_PR_NUM_N}"/>
				<e:field>
					<e:inputText id="PR_NUM" name="PR_NUM" value="${form.PR_NUM}" width="36%" maxLength="${form_PR_NUM_M}" disabled="${form_PR_NUM_D}" readOnly="${form_PR_NUM_RO}" required="${form_PR_NUM_R}"  maskType="${form_PR_NUM_MT}" />
					<e:text>/</e:text>
					<e:inputText id="PR_SUBJECT" name="PR_SUBJECT" value="${form.PR_SUBJECT}" width="60%" maxLength="${form_PR_SUBJECT_M}" disabled="${form_PR_SUBJECT_D}" readOnly="${form_PR_SUBJECT_RO}" required="${form_PR_SUBJECT_R}"  maskType="${form_PR_SUBJECT_MT}" />
				</e:field>
				<e:label for="PROGRESS_CD" title="${form_PROGRESS_CD_N}"/>
				<e:field>
					<e:select id="PROGRESS_CD" name="PROGRESS_CD" value="" options="${progressCdOptions}" width="${form_PROGRESS_CD_W}" disabled="${form_PROGRESS_CD_D}" readOnly="${form_PROGRESS_CD_RO}" required="${form_PROGRESS_CD_R}" placeHolder="" maskType="${form_PROGRESS_CD_MT}" />
				</e:field>
				<e:label for="SIGN_STATUS" title="${form_SIGN_STATUS_N}"/>
				<e:field>
					<e:select id="SIGN_STATUS" name="SIGN_STATUS" value="" options="${signStatusOptions}" width="${form_SIGN_STATUS_W}" disabled="${form_SIGN_STATUS_D}" readOnly="${form_SIGN_STATUS_RO}" required="${form_SIGN_STATUS_R}" placeHolder="" maskType="${form_SIGN_STATUS_MT}" />
				</e:field>
			</e:row>
        	<e:row>
				<e:label for="ITEM_CD" title="${form_ITEM_CD_N}" />
				<e:field>
					<e:inputText id="ITEM_CD" name="ITEM_CD" value="" width="36%" maxLength="${form_ITEM_CD_M}" disabled="${form_ITEM_CD_D}" readOnly="${form_ITEM_CD_RO}" required="${form_ITEM_CD_R}" style="${imeMode}" maskType="${form_ITEM_CD_MT}"/>
					<e:text>/</e:text>
					<e:inputText id="ITEM_DESC" name="ITEM_DESC" value="" width="60%" maxLength="${form_ITEM_DESC_M}" disabled="${form_ITEM_DESC_D}" readOnly="${form_ITEM_DESC_RO}" required="${form_ITEM_DESC_R}" style="${imeMode}" maskType="${form_ITEM_DESC_MT}"/>
				</e:field>
				<e:label for="PURCHASE_TYPE" title="${form_PURCHASE_TYPE_N}"/>
				<e:field>
					<e:select id="PURCHASE_TYPE" name="PURCHASE_TYPE" value="" options="${purchaseTypeOptions}" width="${form_PURCHASE_TYPE_W}" disabled="${form_PURCHASE_TYPE_D}" readOnly="${form_PURCHASE_TYPE_RO}" required="${form_PURCHASE_TYPE_R}" placeHolder="" maskType="${form_PURCHASE_TYPE_MT}" />
				</e:field>
				<e:label for="CTRL_USER_ID" title="${form_CTRL_USER_ID_N}"/>
				<e:field>
					<e:search id="CTRL_USER_ID" name="CTRL_USER_ID" value="" width="40%" maxLength="${form_CTRL_USER_ID_M}" onIconClick="${form_CTRL_USER_ID_RO ? 'everCommon.blank' : 'getCtrlId'}" disabled="${form_CTRL_USER_ID_D}" readOnly="${form_CTRL_USER_ID_RO}" required="${form_CTRL_USER_ID_R}" maskType="${form_CTRL_USER_ID_MT}" placeHolder="개인번호" />
					<e:inputText id="CTRL_USER_NM" name="CTRL_USER_NM" value="" width="60%" maxLength="${form_CTRL_USER_NM_M}" disabled="${form_CTRL_USER_NM_D}" readOnly="${form_CTRL_USER_NM_RO}" required="${form_CTRL_USER_NM_R}" style="${imeMode}" maskType="${form_CTRL_USER_NM_MT}" placeHolder="성명"/>
				</e:field>
				<%--
				<e:label for="CM_REQ_ID" title="${form_CM_REQ_ID_N}" />
				<e:field>
					<e:inputText id="CM_REQ_ID" name="CM_REQ_ID" value="" width="${form_CM_REQ_ID_W}" maxLength="${form_CM_REQ_ID_M}" disabled="${form_CM_REQ_ID_D}" readOnly="${form_CM_REQ_ID_RO}" required="${form_CM_REQ_ID_R}" style="${imeMode}" maskType="${form_CM_REQ_ID_MT}"/>
				</e:field>
				--%>
			</e:row>
		</e:searchPanel>

		<e:buttonBar id="buttonBar" align="right" width="100%">
			<e:button id="doSearch" name="doSearch" label="${doSearch_N}" onClick="doSearch" disabled="${doSearch_D}" visible="${doSearch_V}"/>
			<e:button id="doModify" name="doModify" label="${doModify_N}" onClick="doModify" disabled="${doModify_D}" visible="${doModify_V}"/>
		</e:buttonBar>

		<e:gridPanel gridType="${_gridType}" id="grid" name="grid" width="100%" height="fit" />

	</e:window>
</e:ui>