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

	        	var buyerCd = grid.getCellValue(rowIdx, 'BUYER_CD');
	        	var bidNum  = grid.getCellValue(rowIdx, 'BID_NUM');
	        	var bidCnt  = grid.getCellValue(rowIdx, 'BID_CNT');

	        	if(colIdx == "ANN_NO") {
                    var param = {
                        'buyerCd' : buyerCd,
                        'bidNum' : bidNum,
                        'bidCnt' : bidCnt,
                        'popupFlag' : true,
                        'detailView' : true
                    };
                    <%-- 입찰공고 상세화면을 Popup으로 open. --%>
                    var oriBidStatus = grid.getCellValue(rowIdx, 'ORI_BID_STATUS');
                    var callUrl = ((oriBidStatus == "2303" || oriBidStatus == "2330") ? "/nhepro/CBDI/CBDR0014/view.so" : "/nhepro/CBDI/CBDR0012/view.so");
                    var callHeight = ((oriBidStatus == "2303" || oriBidStatus == "2330") ? 700 : 900);
                    everPopup.openWindowPopup(callUrl, 1200, callHeight, param, "bidDetail", true);
				}

	        	if(colIdx == "JOIN_VENDOR_CNT") {
					var param = {
						'buyerCd'    : buyerCd,
						'bidNum'     : bidNum,
						'bidCnt'     : bidCnt,
						'popupFlag'  : true,
						'detailView' : true
					};
					everPopup.openWindowPopup("/nhepro/CBDI/CBDI0021/view.so", 1200, 800, param, "bidAppClose", true);
	        	}

	        	if(colIdx == "EVAL_VENDOR_CNT") {
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

			});

	        grid.excelExportEvent({
				allItems : "${excelExport.allCol}",
				fileName : "${screenName }"
			});

			grid.setProperty('shrinkToFit', true);					// 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
			grid.setProperty('rowNumbers', ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
			grid.setProperty('sortable', ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
			grid.setProperty('panelVisible', ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
			grid.setProperty('enterToNextRow', ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
			grid.setProperty('acceptZero', ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
			grid.setProperty('singleSelect', ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]
			grid.setProperty('multiSelect', ${multiSelect});		// [선택] 컬럼의 사용여부를 지정한다. [true/false]

			doSearch();
		}

	    function doSearch() {

	    	var store = new EVF.Store();
			if(!store.validate()) { return; }
	        store.setGrid([grid]);
	        store.load(baseUrl + 'cbdr0080_doSearch.so', function() {
	        	if(grid.getRowCount() == 0){
	            	EVF.alert("${msg.M0002 }");
	            }
	        });
	    }

		var specEvalRowId;
		function doStartEval() {

			if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

			if (grid.getSelRowCount() > 1) { return EVF.alert("${msg.M0006}"); }

			var buyerCd; var bidNum; var bidCnt;
			var eiNum; var evTplNum; var voteCnt;
			var evTplSubject;
			var euProgressCd;

			var rowIds = grid.getSelRowId();
			for(var i in rowIds) {

				if(grid.getCellValue(rowIds[i], 'EU_USER_ID') != "${ses.userId}") {
					return EVF.alert("${CBDR0080_001}");
				}
				if(grid.getCellValue(rowIds[i], 'EU_PROGRESS_CD') == "300") {
					return EVF.alert("${CBDR0080_003}");
				}
				if(grid.getCellValue(rowIds[i], 'BID_PROGRESS_CD') == "300") {
					return EVF.alert("${CBDR0080_003}");
				}
				buyerCd = grid.getCellValue(rowIds[i], 'BUYER_CD');
				bidNum = grid.getCellValue(rowIds[i], 'BID_NUM');
				bidCnt = grid.getCellValue(rowIds[i], 'BID_CNT');
				eiNum = grid.getCellValue(rowIds[i], 'EI_NUM');
				evTplNum = grid.getCellValue(rowIds[i], 'EV_TPL_NUM');
				voteCnt = grid.getCellValue(rowIds[i], 'VOTE_CNT');
				evTplSubject = grid.getCellValue(rowIds[i], 'EV_TPL_SUBJECT');
				euProgressCd = grid.getCellValue(rowIds[i], 'EU_PROGRESS_CD');
				specEvalRowId = rowIds[i];
			}

			var param = {
				'BUYER_CD' : buyerCd,
				'BID_NUM' : bidNum,
				'BID_CNT' : bidCnt,
				'EI_NUM' : eiNum,
				'EV_TPL_NUM' : evTplNum,
				'VOTE_CNT' : voteCnt,
				'EV_TPL_SUBJECT' : evTplSubject,
				'CONT_TYPE2'     : 'XX',
                'evFinalFlag'    : false,
				'popupFlag' : true,
				'detailView' : (euProgressCd == "300" ? true : false)
			};
			everPopup.openWindowPopup("/nhepro/CBDR/CBDR0081/view.so", 1200, 750, param, "startEval", true);
		}

	    function getBidUserId() {

			var callBackType = this.getData().data;
			var param = {
					'callBackFunction': (callBackType == "B" ? "setBidUserId" : "setEvalUserId"),
					'READONLY': 'Y',		//팝업 조회조건 변경불가
					'multiYN' : 'N',        //멀티팝업여부
					'CTRL_CD' : (callBackType == "B" ? "BR030" : ""),	//구매담당자 및 전체인력
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

	    function cleanBidUserId() {
			EVF.V("BID_USER_ID", "");
		}

	    function cleanEuUserId() {
			EVF.V("EU_USER_ID", "");
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

    </script>
	<e:window id="CBDR0080" initData="${initData}" onReady="init" title="${fullScreenName }" breadCrumbs="${breadCrumb }">
		<e:searchPanel id="form" title="${form_CAPTION_N }" labelWidth="${labelWidth}" width="100%" columnCount="3" useTitleBar="false" onEnter="doSearch">
			<e:row>
				<e:label for="OPEN_DATE_FROM" title="${form_OPEN_DATE_FROM_N}" />
				<e:field>
					<e:inputDate id="OPEN_DATE_FROM" name="OPEN_DATE_FROM" toDate="OPEN_DATE_TO" value="${reqFromDate }" width="${inputDateWidth }" required="${form_OPEN_DATE_FROM_R}" disabled="${form_OPEN_DATE_FROM_D}" readOnly="${form_OPEN_DATE_FROM_RO}" datePicker="true" />
					<e:text>~&nbsp;</e:text>
					<e:inputDate id="OPEN_DATE_TO" name="OPEN_DATE_TO" fromDate="OPEN_DATE_FROM" value="${reqToDate }" width="${inputDateWidth }" required="${form_OPEN_DATE_TO_R}" disabled="${form_OPEN_DATE_TO_D}" readOnly="${form_OPEN_DATE_TO_RO}" datePicker="true" />
				</e:field>
				<e:label for="EI_NUM" title="${form_EI_NUM_N}"/>
				<e:field>
					<e:inputText id="EI_NUM" name="EI_NUM" value="" width="${form_EI_NUM_W}" maxLength="${form_EI_NUM_M}" disabled="${form_EI_NUM_D}" readOnly="${form_EI_NUM_RO}" required="${form_EI_NUM_R}" />
				</e:field>
				<e:label for="BID_USER_ID" title="${form_BID_USER_ID_N}"/>
				<e:field>
					<e:search id="BID_USER_ID" name="BID_USER_ID" value="" width="40%" maxLength="${form_BID_USER_ID_M}" disabled="${form_BID_USER_ID_D}" readOnly="${form_BID_USER_ID_RO}" required="${form_BID_USER_ID_R}" onIconClick="getBidUserId" data="B" placeHolder="개인번호" />
					<e:inputText id="BID_USER_NM" name="BID_USER_NM" value="" width="60%" maxLength="${form_BID_USER_NM_M}" disabled="${form_BID_USER_NM_D}" readOnly="${form_BID_USER_NM_RO}" required="${form_BID_USER_NM_R}" placeHolder="성명" />
				</e:field>
			</e:row>
			<e:row>
				<e:label for="ANN_NO_ITEM" title="${form_ANN_NO_ITEM_N}"/>
				<e:field>
					<e:inputText id="ANN_NO_ITEM" name="ANN_NO_ITEM" value="" width="${form_ANN_NO_ITEM_W}" maxLength="${form_ANN_NO_ITEM_M}" disabled="${form_ANN_NO_ITEM_D}" readOnly="${form_ANN_NO_ITEM_RO}" required="${form_ANN_NO_ITEM_R}" />
				</e:field>
				<e:label for="EU_USER_ID" title="${form_EU_USER_ID_N}"/>
				<e:field>
					<e:search id="EU_USER_ID" name="EU_USER_ID" value="${ses.userId}" width="40%" maxLength="${form_EU_USER_ID_M}" disabled="${form_EU_USER_ID_D}" readOnly="${form_EU_USER_ID_RO}" required="${form_EU_USER_ID_R}" onIconClick="getBidUserId" data="E" placeHolder="개인번호" />
					<e:inputText id="EU_USER_NM" name="EU_USER_NM" value="${ses.userNm}" width="60%" maxLength="${form_EU_USER_NM_M}" disabled="${form_EU_USER_NM_D}" readOnly="${form_EU_USER_NM_RO}" required="${form_EU_USER_NM_R}" placeHolder="성명" />
				</e:field>
				<e:label for="BUYER_CD" title="${form_BUYER_CD_N}"/>
				<e:field>
					<e:search id="BUYER_CD" name="BUYER_CD" value="" width="40%" maxLength="${form_BUYER_CD_M}" disabled="${form_BUYER_CD_D}" readOnly="${form_BUYER_CD_RO}" required="${form_BUYER_CD_R}" onIconClick="getBuyerCd" placeHolder="회사코드" />
					<e:inputText id="BUYER_NM" name="BUYER_NM" value="" width="60%" maxLength="${form_BUYER_NM_M}" disabled="${form_BUYER_NM_D}" readOnly="${form_BUYER_NM_RO}" required="${form_BUYER_NM_R}" placeHolder="회사명" />
				</e:field>
			</e:row>
		</e:searchPanel>

		<e:buttonBar id="buttonBar" align="right" width="100%">
			<e:button id="Search" name="Search" label="${Search_N }" disabled="${Search_D }" visible="${Search_V}" onClick="doSearch" />
			<e:button id="StartEval" name="StartEval" label="${StartEval_N }" disabled="${StartEval_D }" visible="${StartEval_V}" onClick="doStartEval" />
		</e:buttonBar>

		<e:gridPanel id="grid" name="grid" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}" />

	</e:window>
</e:ui>