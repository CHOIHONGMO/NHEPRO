<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">

	<script type="text/javascript">

	    var grid;
		var baseUrl = "/nhepro/CBDR/";

	    function init() {

	        grid = EVF.C("grid");

	        grid.cellClickEvent(function(rowIdx, colIdx, value) {

                var buyerCd  = grid.getCellValue(rowIdx, 'BUYER_CD');
                var bidNum   = grid.getCellValue(rowIdx, 'BID_NUM');
                var bidCnt   = grid.getCellValue(rowIdx, 'BID_CNT');
        		var evUserId = grid.getCellValue(rowIdx, 'EV_USER_ID');	// 평가담당자

                if(colIdx == "ANN_NO") {
                    var param = {
                        'buyerCd'    : buyerCd,
                        'bidNum'     : bidNum,
                        'bidCnt'     : bidCnt,
                        'popupFlag'  : true,
                        'detailView' : true
                    };
                    <%-- 입찰공고 상세화면을 Popup으로 open. --%>
                    var oriBidStatus = grid.getCellValue(rowIdx, 'ORI_BID_STATUS');
                    var callUrl = ((oriBidStatus == "2303" || oriBidStatus == "2330") ? "/nhepro/CBDI/CBDR0014/view.so" : "/nhepro/CBDI/CBDR0012/view.so");
                    var callHeight = ((oriBidStatus == "2303" || oriBidStatus == "2330") ? 700 : 900);
                    everPopup.openWindowPopup(callUrl, 1200, callHeight, param, "bidDetail", true);
				}

                if(colIdx == "BID_STATUS_LOC") {
                    var contType2    = grid.getCellValue(rowIdx, 'CONT_TYPE2');
                    var voteCnt      = grid.getCellValue(rowIdx, 'VOTE_CNT');
                    var oriBidStatus = grid.getCellValue(rowIdx, 'ORI_BID_STATUS');
					
                    if(evUserId != "${ses.userId}") {
    					return EVF.alert("${CBDR0090_005}");		<%-- 본인에게 할당된 평가건만 조회할 수 있습니다. --%>
    				}
					
                    if (contType2 == "NE") {
                        if (oriBidStatus >= "2400" || oriBidStatus == "1300") {
                	        var param = {
                					'BUYER_CD'     : buyerCd,
                					'BID_NUM'      : bidNum,
                					'BID_CNT'      : bidCnt,
                					'VOTE_CNT'     : voteCnt,
                	                'popupFlag'    : true,
                	                'detailView'   : false
                	            };
                	        // 2021.02.16 변경
                	        // 종합낙찰제(CBDI0034)에서 신규화면(CBDI0037)으로 변경
                	        //everPopup.openWindowPopup("/nhepro/CBDR/CBDI0034/view.so", 1200, 800, param, "totalSB", true);
                	        everPopup.openWindowPopup("/nhepro/CBDR/CBDI0037/view.so", 1200, 600, param, "cbdi0037", true);
                        }
                        else {
        					return EVF.alert("${CBDR0090_004}");	<%-- 우선협상자 선정 이후 결과를 조회할 수 있습니다. --%>
                        }
                    }
                }

	        	if(colIdx == "EU_CNT") {
	        		if(evUserId != "${ses.userId}") {
    					return EVF.alert("${CBDR0090_005}");		<%-- 본인에게 할당된 평가건만 조회할 수 있습니다. --%>
    				}
	        		
	        		if (grid.getCellValue(rowIdx, 'TECH_EV_TYPE') == '10') {
						var voteCnt = grid.getCellValue(rowIdx, 'VOTE_CNT');
		                var param = {
		                        'BUYER_CD'   : buyerCd,
		                        'BID_NUM'    : bidNum,
		                        'BID_CNT'    : bidCnt,
		                        'VOTE_CNT'   : voteCnt,
		                        'popupFlag'  : true,
		                        'detailView' : true
		                    };
		                    everPopup.openWindowPopup("/nhepro/CBDR/CBDI0035/view.so", 900, 600, param, "openDocument", true);
	        		} else {
	        			var eiNum = grid.getCellValue(rowIdx, 'EI_NUM');
	                    var evTplNum = grid.getCellValue(rowIdx, 'EV_TPL_NUM');
	                    var evTplSubject = grid.getCellValue(rowIdx, 'EV_TPL_SUBJECT');
	                    var bidProgressCd = grid.getCellValue(rowIdx, 'BID_PROGRESS_CD');

	                    var param = {
	                        'BUYER_CD'       : buyerCd,
	                        'BID_NUM'        : bidNum,
	                        'BID_CNT'        : bidCnt,
	                        'EI_NUM'         : eiNum,
	                        'EV_TPL_NUM'     : evTplNum,
	                        'VOTE_CNT'       : "",
	                        'EV_TPL_SUBJECT' : evTplSubject,
	        				'CONT_TYPE2'     : 'XX',
	                        'evFinalFlag'    : false,
	                        'popupFlag' : true,
	                        <%-- 'detailView' : (bidProgressCd == "300" ? true : false) --%>
	                    	'detailView' : true
	                    };
	                    everPopup.openWindowPopup("/nhepro/CBDR/CBDR0081/view.so", 1200, 750, param, "startEval", true);
	        		}
				}
			});

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
			grid.setProperty('singleSelect', ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]
			grid.setProperty('multiSelect', true);                 // [선택] 컬럼의 사용여부를 지정한다. [true/false]

			EVF.C('PROGRESS_CD').removeOption('100');

			doSearch();
		}

	    function doSearch() {

	    	var store = new EVF.Store();
			if(!store.validate()) { return; }
	        store.setGrid([grid]);
	        store.load(baseUrl + 'cbdr0090_doSearch.so', function() {
	        	if(grid.getRowCount() == 0){
	            	EVF.alert("${msg.M0002 }");
	            }
	        });
	    }
	    
	    //2022.01.04 평가담당자 변경 기능 추가
	    function doEvUserChange() {

			if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

			if(EVF.isEmpty(EVF.C("CH_EV_USER_ID").getValue())) {
                return EVF.alert("${CBDR0090_015}");
            }

			var rowIds = grid.getSelRowId();
			
	    	for(var i in rowIds) {
	    		if(grid.getCellValue(rowIds[i], 'BID_USER_ID') != "${ses.userId}" && grid.getCellValue(rowIds[i], 'EV_USER_ID') != "${ses.userId}" ) {
    				return EVF.alert("${CBDR0090_017}");
    			}
	    		
	    		if(grid.getCellValue(rowIds[i], 'BID_PROGRESS_CD') == "300" ) {
    				return EVF.alert("${CBDR0090_018}");
    			}
    		}
	 
			EVF.confirm("${CBDR0090_014}", function () {
				var store = new EVF.Store();
				store.setGrid([grid]);
	            store.getGridData(grid, 'sel');
	            store.setParameter("CHANGE_USER_ID", EVF.C("CH_EV_USER_ID").getValue());
	            store.load(baseUrl + 'cbdr0090_doUserChange.so', function(){
	        		EVF.alert(this.getResponseMessage(), function() {
	        			doSearch();
					});
	        	});
			});
		}
		
	    function getBidUserId() {

			var callBackType = this.getData().data;
			var param = {
					'callBackFunction': (callBackType == "C" ? "setChangeEvalUserId" : (callBackType == "B" ? "setBidUserId" : "setEvalUserId")),
					'READONLY': 'Y',		//팝업 조회조건 변경불가
					'multiYN' : 'N',        //멀티팝업여부
					'CTRL_CD' : (callBackType == "C" ? "" : (callBackType == "B" ? "BR030" : "")),	//구매담당자권한
					'detailView': false
			};
			everPopup.openPopupByScreenId("CCDU0020", 1100, 700, param);
		}

	    function setBidUserId(data) {
	    	if(data!=null){
				data = JSON.parse(data);
				EVF.V("BID_USER_ID", data.USER_ID);
				EVF.V("BID_USER_NM", data.USER_NM);
	    	}
		}

	    function setEvalUserId(data) {
	    	if(data!=null){
				data = JSON.parse(data);
				EVF.V("EU_USER_ID", data.USER_ID);
				EVF.V("EU_USER_NM", data.USER_NM);
	    	}
		}
	    
	    function setChangeEvalUserId(data) {
	    	if(data!=null){
				data = JSON.parse(data);
				EVF.V("CH_EV_USER_ID", data.USER_ID);
				EVF.V("CH_EV_USER_NM", data.USER_NM);
	    	}
		}

	    function cleanBidUserId() {
			EVF.V("BID_USER_ID", "");
		}

	    function cleanEuUserId() {
			EVF.V("EU_USER_ID", "");
		}
	    
	    function cleanChEvUserId() {
			EVF.V("CH_EU_USER_ID", "");
		}
	    
		function getVendorCd() {
			var param = {
				callBackFunction : "setVendorCd",
				BUYER_CD : "${ses.companyCd}"
			};
			everPopup.openCommonPopup(param, 'SP0123');
		}

		function setVendorCd(data) {
			EVF.V("VENDOR_CD", data.VENDOR_CD);
			EVF.V("VENDOR_NM", data.VENDOR_NM);
		}

	    function cleanVendorCd() {
			EVF.V("VENDOR_CD", "");
		}

		function getBuyerCd() {
			var param = {
				callBackFunction : "setBuyerCd"
			};
			everPopup.openCommonPopup(param, 'SP0066');
		}

		function setBuyerCd(data) {
			EVF.V("BUYER_CD", data.CUST_CD);
			EVF.V("BUYER_NM", data.CUST_NM);
		}

		function cleanBuyerCd() {
			EVF.V("BUYER_CD", "");
		}

		function doFinishEval() {

			if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

			if (grid.getSelRowCount() > 1) { return EVF.alert("${msg.M0006}"); }

			var buyerCd; var bidNum; var bidCnt; var bidStatus; var contType2; var techEvType; var voteCnt;
			var openType;

			<%-- 기술평가구분이 “평가결과등록”인 경우, 기술평가결과등록 화면을 호출하여 기술평가 점수를 등록하며,
				 기술평가구분이 “기술평가수행”인 경우, 평가항목에 정량 평가항목이 있는 경우 System에서 평가를 진행한다.
			     STOCBDET Table의 내용을 STOCBDSP에 Insert 한다. --%>

			var rowIds = grid.getSelRowId();
			for(var i in rowIds) {

				bidStatus  = grid.getCellValue(rowIds[i], 'BID_STATUS');
				contType2  = grid.getCellValue(rowIds[i], 'CONT_TYPE2');
				techEvType = grid.getCellValue(rowIds[i], 'TECH_EV_TYPE');

				if(grid.getCellValue(rowIds[i], 'EV_USER_ID') != "${ses.userId}") {
					return EVF.alert("${CBDR0090_002}");											<%-- 본인에게 할당된 평가건만 평가완료할 수 있습니다. --%>
				}

				if(((contType2 == "TD" || contType2 == "TS") && bidStatus != "100") ||
					(contType2 == "NE" && bidStatus != "500" && bidStatus != "600")) {
					return EVF.alert("${CBDR0090_006}");											<%-- 진행상태를 확인하세요. --%>
				}

				if(techEvType == "10") { 		<%-- 평가결과등록 --%>

					if(contType2 == "NE") {
						openType = "NE10";
					}

				} else if(techEvType == "20") { <%-- 기술평가수행 --%>

					if(grid.getCellValue(rowIds[i], 'OPEN_POSSIBLE_FLAG') == "N") {
                    	return EVF.alert("${CBDR0090_012}");									<%-- 평가가 미완료된 평가자가 존재합니다. --%>
                	}

					if(contType2 == "TD") {
						openType = (grid.getCellValue(rowIds[i], 'ORI_BID_STATUS') == "2353" ? "TD207" : "TD208");
					} else if(contType2 == "TS") {
						openType = (grid.getCellValue(rowIds[i], 'ORI_BID_STATUS') == "2363" ? "TS207" : "TD208");
					} else if(contType2 == "NE") {
						openType = (grid.getCellValue(rowIds[i], 'ORI_BID_STATUS') == "2367" ? "NE207" : "NE208");
					}
				}

				buyerCd    = grid.getCellValue(rowIds[i], 'BUYER_CD');
				bidNum     = grid.getCellValue(rowIds[i], 'BID_NUM');
				bidCnt     = grid.getCellValue(rowIds[i], 'BID_CNT');
                voteCnt    = grid.getCellValue(rowIds[i], 'VOTE_CNT');
			}

			if(openType == "TD207" || openType == "TS207" || openType == "NE207") { <%-- 기술평가수행일 때, 평가는 완료되었지만 최종완료는 안 한 경우 --%>

				if (!confirm("${CBDR0090_013 }")) {
					return;
				}

				var eiNum         = grid.getCellValue(rowIds[i], 'EI_NUM');
                var evTplNum      = grid.getCellValue(rowIds[i], 'EV_TPL_NUM');
                var evTplSubject  = grid.getCellValue(rowIds[i], 'EV_TPL_SUBJECT');
                var bidProgressCd = grid.getCellValue(rowIds[i], 'BID_PROGRESS_CD');

                var param = {
                    'BUYER_CD'       : buyerCd,
                    'BID_NUM'        : bidNum,
                    'BID_CNT'        : bidCnt,
                    'EI_NUM'         : eiNum,
                    'EV_TPL_NUM'     : evTplNum,
                    'VOTE_CNT'       : voteCnt,
                    'EV_TPL_SUBJECT' : evTplSubject,
                    'CONT_TYPE2'     : contType2,
                    'evFinalFlag'    : true,
                    'popupFlag'      : true,
                	'detailView'     : false
                };
                everPopup.openWindowPopup("/nhepro/CBDR/CBDR0081/view.so", 1200, 750, param, "startEval", true);

            } else {																										// <-- 기술평가결과 등록 (CBDI0035)
            	var detailView = true;
            	var oriBidStatus = grid.getCellValue(rowIds[i], 'ORI_BID_STATUS');

            	if ((contType2 == "TD" && oriBidStatus == "2353") ||
            	    (contType2 == "TS" && oriBidStatus == "2363") ||
            	    (contType2 == "NE" && oriBidStatus == "2367")) {

            		if (!confirm("${CBDR0090_013 }")) {
    					return;
    				}

            		detailView = false;
            	}

            	var param = {
                    'BUYER_CD'   : buyerCd,
                    'BID_NUM'    : bidNum,
                    'BID_CNT'    : bidCnt,
                    'VOTE_CNT'   : voteCnt,
                    'popupFlag'  : true,
                    'detailView' : detailView
                };
                everPopup.openWindowPopup("/nhepro/CBDR/CBDI0035/view.so", 900, 600, param, "openDocument", true);
            }
		}

		<%-- CBDI0035에서 규격평가결과 화면을 Popup으로 open. --%>
		function doOpenEvSpec(buyerCd, bidNum, bidCnt, contType2) {

    		if(contType2 == "TD" || contType2 == "TS") {
	    		var param = {
				'BUYER_CD'   : buyerCd,
				'BID_NUM'    : bidNum,
				'BID_CNT'    : bidCnt,
                'REBID'      : false,
				'popupFlag'  : true,
				'detailView' : false
				};

				var callUrl = "/nhepro/CBDR/CBDI0031/view.so";
				everPopup.openWindowPopup(callUrl, 900, 600, param, "bidEval", true);
			}
		}
    </script>

	<e:window id="CBDR0090" initData="${initData}" onReady="init" title="${fullScreenName }" breadCrumbs="${breadCrumb }">
		<e:searchPanel id="form" title="${form_CAPTION_N }" labelWidth="${labelWidth}" width="100%" columnCount="3" useTitleBar="false" onEnter="doSearch">
			<e:row>
				<e:label for="ANN_DATE_FROM" title="${form_ANN_DATE_FROM_N}" />
				<e:field>
					<e:inputDate id="ANN_DATE_FROM" name="ANN_DATE_FROM" toDate="ANN_DATE_TO" value="${reqFromDate }" width="${inputDateWidth }" required="${form_ANN_DATE_FROM_R}" disabled="${form_ANN_DATE_FROM_D}" readOnly="${form_ANN_DATE_FROM_RO}" datePicker="true" />
					<e:text>~&nbsp;</e:text>
					<e:inputDate id="ANN_DATE_TO" name="ANN_DATE_TO" fromDate="ANN_DATE_FROM" value="${reqToDate }" width="${inputDateWidth }" required="${form_ANN_DATE_TO_R}" disabled="${form_ANN_DATE_TO_D}" readOnly="${form_ANN_DATE_TO_RO}" datePicker="true" />
				</e:field>
				<e:label for="PROGRESS_CD" title="${form_PROGRESS_CD_N}" />
				<e:field>
					<e:select id="PROGRESS_CD" name="PROGRESS_CD" value="" options="${progressCdOptions }" width="${form_PROGRESS_CD_W }" disabled="${form_PROGRESS_CD_D}" readOnly="${form_PROGRESS_CD_RO}" required="${form_PROGRESS_CD_R}" placeHolder="" />
				</e:field>
				<e:label for="BUYER_CD" title="${form_BUYER_CD_N}"/>
				<e:field>
					<e:search id="BUYER_CD" name="BUYER_CD" value="" width="40%" maxLength="${form_BUYER_CD_M}" disabled="${form_BUYER_CD_D}" readOnly="${form_BUYER_CD_RO}" required="${form_BUYER_CD_R}" onIconClick="getBuyerCd" placeHolder="회사코드" />
					<e:inputText id="BUYER_NM" name="BUYER_NM" value="" width="60%" maxLength="${form_BUYER_NM_M}" disabled="${form_BUYER_NM_D}" readOnly="${form_BUYER_NM_RO}" required="${form_BUYER_NM_R}" placeHolder="회사명" />
				</e:field>
			</e:row>
			<e:row>
				<e:label for="ANN_NO_ITEM" title="${form_ANN_NO_ITEM_N}"/>
				<e:field>
					<e:inputText id="ANN_NO_ITEM" name="ANN_NO_ITEM" value="" width="${form_ANN_NO_ITEM_W}" maxLength="${form_ANN_NO_ITEM_M}" disabled="${form_ANN_NO_ITEM_D}" readOnly="${form_ANN_NO_ITEM_RO}" required="${form_ANN_NO_ITEM_R}" />
				</e:field>
				<e:label for="VENDOR_CD" title="${form_VENDOR_CD_N}"/>
				<e:field>
					<e:search id="VENDOR_CD" name="VENDOR_CD" value="" width="40%" maxLength="${form_VENDOR_CD_M}" disabled="${form_VENDOR_CD_D}" readOnly="${form_VENDOR_CD_RO}" required="${form_VENDOR_CD_R}" onIconClick="getVendorCd" placeHolder="회사코드" />
					<e:inputText id="VENDOR_NM" name="VENDOR_NM" value="" width="60%" maxLength="${form_VENDOR_NM_M}" disabled="${form_VENDOR_NM_D}" readOnly="${form_VENDOR_NM_RO}" required="${form_VENDOR_NM_R}" placeHolder="회사명" />
				</e:field>
				<e:label for="BID_USER_ID" title="${form_BID_USER_ID_N}"/>
				<e:field>
					<e:search id="BID_USER_ID" name="BID_USER_ID" value="" width="40%" maxLength="${form_BID_USER_ID_M}" disabled="${form_BID_USER_ID_D}" readOnly="${form_BID_USER_ID_RO}" required="${form_BID_USER_ID_R}" onIconClick="getBidUserId" data="B" placeHolder="개인번호" />
					<e:inputText id="BID_USER_NM" name="BID_USER_NM" value="" width="60%" maxLength="${form_BID_USER_NM_M}" disabled="${form_BID_USER_NM_D}" readOnly="${form_BID_USER_NM_RO}" required="${form_BID_USER_NM_R}" placeHolder="성명" />
				</e:field>
			</e:row>
			<e:row>
				<e:label for="EV_USER_ID" title="${form_EV_USER_ID_N}"/>
				<e:field>
					<e:search id="EV_USER_ID" name="EV_USER_ID" value="${ses.userId}" width="40%" maxLength="${form_EV_USER_ID_M}" disabled="${form_EV_USER_ID_D}" readOnly="${form_EV_USER_ID_RO}" required="${form_EV_USER_ID_R}" onIconClick="getBidUserId" data="E" placeHolder="개인번호" />
					<e:inputText id="EV_USER_NM" name="EV_USER_NM" value="${ses.userNm}" width="60%" maxLength="${form_EV_USER_NM_M}" disabled="${form_EV_USER_NM_D}" readOnly="${form_EV_USER_NM_RO}" required="${form_EV_USER_NM_R}" placeHolder="성명" />
				</e:field>
				<e:label for="" />
				<e:field> </e:field>
				<e:label for="" />
				<e:field> </e:field>
			</e:row>
		</e:searchPanel>

		<e:buttonBar id="buttonBar" align="right" width="100%">
			<e:text style="color: blue;font-weight: bold;">■ 규격/기술평가담당자 : </e:text>
			<e:search id="CH_EV_USER_NM" name="CH_EV_USER_NM" value="" width="${form_CH_EV_USER_NM_W}" maxLength="${form_CH_EV_USER_NM_M}" disabled="${form_CH_EV_USER_NM_D}" readOnly="${form_CH_EV_USER_NM_RO}" required="${form_CH_EV_USER_NM_R}" align="left" onIconClick="getBidUserId" data="C" />
			<e:inputHidden id="CH_EV_USER_ID" name="CH_EV_USER_ID" value="" />
			<e:button id="EvUserChange" name="EvUserChange" label="${EvUserChange_N }" disabled="${EvUserChange_D }" visible="${EvUserChange_V}" style="padding-left:3px;" align="left" onClick="doEvUserChange" />
			
			<e:button id="Search" name="Search" label="${Search_N }" disabled="${Search_D }" visible="${Search_V}" onClick="doSearch" />
			<e:button id="FinishEval" name="FinishEval" label="${FinishEval_N }" disabled="${FinishEval_D }" visible="${FinishEval_V}" onClick="doFinishEval" />
		</e:buttonBar>

		<e:gridPanel id="grid" name="grid" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}" />

	</e:window>
</e:ui>