<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page import="com.st_ones.everf.serverside.config.PropertiesManager" %>

<!-- 2021.02.08 중앙회 요청 "관리자직무"를 갖는 사람은 담당자 변경 가능하도록 추가 -->
<% String ManagerCd = PropertiesManager.getString("eversrm.customer.admin.ManagerCd"); %>

<c:set var="ManagerCd" value="<%=ManagerCd%>" />

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">

	<script type="text/javascript">

	    var grid;
		var baseUrl = "/nhepro/CBDI/";
		var changeFlag = false;
		
	    function init() {

	        grid = EVF.C("grid");

	        grid.cellClickEvent(function(rowIdx, colIdx, value) {

	        	if(colIdx == "ANN_NO") {
					var param = {
						'buyerCd'    : grid.getCellValue(rowIdx, 'BUYER_CD'),
						'bidNum'     : grid.getCellValue(rowIdx, 'BID_NUM'),
						'bidCnt'     : grid.getCellValue(rowIdx, 'BID_CNT'),
						'popupFlag'  : true,
						'detailView' : true
					};
					<%-- 입찰공고 상세화면을 Popup으로 open. --%>
                    var oriBidStatus = grid.getCellValue(rowIdx, 'ORI_BID_STATUS');
                    var callUrl = ((oriBidStatus == "2303" || oriBidStatus == "2330") ? "/nhepro/CBDI/CBDR0014/view.so" : "/nhepro/CBDI/CBDR0012/view.so");
                    var callHeight = ((oriBidStatus == "2303" || oriBidStatus == "2330") ? 700 : 900);
					everPopup.openWindowPopup(callUrl, 1200, callHeight, param, "bidAnn", true);
				}
	        	if(colIdx == "ANN_ITEM") {
					var param = {
							'buyerCd'      : grid.getCellValue(rowIdx, 'BUYER_CD'),
							'bidNum'       : grid.getCellValue(rowIdx, 'BID_NUM'),
							'bidCnt'       : grid.getCellValue(rowIdx, 'BID_CNT'),
							'baseDataType' : "ModifyBID",
							'popupFlag'    : true,
							'detailView'   : true
						};

					<%-- 입찰/취소 공고 상세화면을 Popup으로 open. --%>
                    var oriBidStatus = grid.getCellValue(rowIdx, 'ORI_BID_STATUS');
                    var callUrl = ((oriBidStatus == "2303" || oriBidStatus == "2330") ? "/nhepro/CBDI/CBDR0013/view.so" : "/nhepro/CBDI/CBDI0011/view.so");
                    var callHeight = ((oriBidStatus == "2303" || oriBidStatus == "2330") ? 700 : 900);
					everPopup.openWindowPopup(callUrl, 1300, callHeight, param, "bidDetail", true);
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
			grid.setProperty('multiSelect', ${multiSelect});		// [선택] 컬럼의 사용여부를 지정한다. [true/false]
			
			// 2021.02.08 중앙회 요청 "관리자직무"를 갖는 사람은 담당자 변경 가능하도록 추가
		    if ("${ses.ctrlCd}".indexOf("${ManagerCd}") > -1) {
		    	changeFlag = true;
            }
			
			doSearch();
		}

	    function doSearch() {

	    	var store = new EVF.Store();
			if(!store.validate()) { return; }
	        store.setGrid([grid]);
	        store.load(baseUrl + 'cbdi0010_doSearch.so', function() {
	        	if(grid.getRowCount() == 0){
	            	EVF.alert("${msg.M0002 }");
	            }
	        });
	    }

	    function doChangeCtrl() {

			if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

			if(EVF.isEmpty(EVF.C("CTRL_USER_ID").getValue())) {
                return EVF.alert("${CBDI0010_001}");
            }

			var rowIds = grid.getSelRowId();
	    	for(var i in rowIds) {
	    		if(grid.getCellValue(rowIds[i], 'SIGN_STATUS') == "P") {
    				return EVF.alert("${CBDI0010_002}");
    			}
	    		// 2021.02.08 중앙회 요청 "관리자직무"를 갖는 사람은 담당자 변경 가능하도록 추가
	    		if(!changeFlag) {
		    		if(grid.getCellValue(rowIds[i], 'BID_USER_ID') != "${ses.userId}") {
	    				return EVF.alert("${CBDI0010_005}");
	    			}
	    		}
    		}

			EVF.confirm("${CBDI0010_003 }", function () {
				var store = new EVF.Store();
				store.setGrid([grid]);
	            store.getGridData(grid, 'sel');
	            store.setParameter("CTRL_USER_ID", EVF.C("CTRL_USER_ID").getValue());
	            store.load(baseUrl + 'cbdi0010_doChangeCtrl.so', function(){
	        		EVF.alert(this.getResponseMessage(), function() {
	        			doSearch();
					});
	        	});
			});
		}
	    
	    // 규격/기술평가담당자 변경
	    function doChangeEv() {

			if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

			if(EVF.isEmpty(EVF.C("EV_USER_ID").getValue())) {
                return EVF.alert("${CBDI0010_013}");
            }

			var rowIds = grid.getSelRowId();
	    	for(var i in rowIds) {
	    		if(grid.getCellValue(rowIds[i], 'SIGN_STATUS') == "P") {
    				return EVF.alert("${CBDI0010_002}");
    			}
	    		// 2021.02.08 중앙회 요청 "관리자직무"를 갖는 사람은 담당자 변경 가능하도록 추가
	    		if(!changeFlag) {
		    		if(grid.getCellValue(rowIds[i], 'BID_USER_ID') != "${ses.userId}") {
	    				return EVF.alert("${CBDI0010_005}");
	    			}
	    		}
	    		
	    		if(grid.getCellValue(rowIds[i], 'EV_USER_ID') == "") {
    				return EVF.alert("${CBDI0010_014}");
    			}
    		}

			EVF.confirm("${CBDI0010_003 }", function () {
				var store = new EVF.Store();
				store.setGrid([grid]);
	            store.getGridData(grid, 'sel');
	            store.setParameter("EV_USER_ID", EVF.C("EV_USER_ID").getValue());
	            store.load(baseUrl + 'cbdi0010_doChangeEv.so', function(){
	        		EVF.alert(this.getResponseMessage(), function() {
	        			doSearch();
					});
	        	});
			});
		}

		function doModify() {

			if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

			if (grid.getSelRowCount() > 1) { return EVF.alert("${msg.M0006}"); }

			var buyerCd; var bidNum; var bidCnt;
			var bidStatus = "";
			var rowIds = grid.getSelRowId();
			for(var i in rowIds) {
				if(grid.getCellValue(rowIds[i], 'SIGN_STATUS') == "E" || grid.getCellValue(rowIds[i], 'SIGN_STATUS') == "P") {
					return EVF.alert("${CBDI0010_006}");
				}
				buyerCd = grid.getCellValue(rowIds[i], 'BUYER_CD');
				bidNum = grid.getCellValue(rowIds[i], 'BID_NUM');
				bidCnt = grid.getCellValue(rowIds[i], 'BID_CNT');
				bidStatus = grid.getCellValue(rowIds[i], 'ORI_BID_STATUS');
			}

			var param = {
				'buyerCd' : buyerCd,
				'bidNum' : bidNum,
				'bidCnt' : bidCnt,
				'baseDataType': "ModifyBID",
				'popupFlag' : true,
				'detailView' : false
			};
			var callUrl = ((bidStatus == "2301" || bidStatus == "2302") ? "/nhepro/CBDI/CBDI0011/view.so" : "/nhepro/CBDI/CBDR0013/view.so");
			var callHeight = ((bidStatus == "2301" || bidStatus == "2302") ? 800 : 700);
			everPopup.openWindowPopup(callUrl, 1300, callHeight, param, "regBidNotice", true);
		}

		function doNoticeMod() {

			if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

			if (grid.getSelRowCount() > 1) { return EVF.alert("${msg.M0006}"); }

			var buyerCd; var bidNum; var bidCnt;
			var rowIds = grid.getSelRowId();
			for(var i in rowIds) {
				if(grid.getCellValue(rowIds[i], 'BID_STATUS') == "P") {
					return EVF.alert("${CBDI0010_011}");
				}
				if((grid.getCellValue(rowIds[i], 'BID_STATUS') != "E" && grid.getCellValue(rowIds[i], 'BID_STATUS') != "A")) {
					return EVF.alert("${CBDI0010_006}");
				}
				if(grid.getCellValue(rowIds[i], 'MOD_POSSIBLE_FLAG') == "N") {
					return EVF.alert("${CBDI0010_008}");
				}
				buyerCd = grid.getCellValue(rowIds[i], 'BUYER_CD');
				bidNum = grid.getCellValue(rowIds[i], 'BID_NUM');
				bidCnt = grid.getCellValue(rowIds[i], 'BID_CNT');
			}

			var param = {
				'buyerCd' : buyerCd,
				'bidNum' : bidNum,
				'bidCnt' : bidCnt,
				'baseDataType': "ModBID",
				'popupFlag' : true,
				'detailView' : false
			};
			everPopup.openWindowPopup("/nhepro/CBDI/CBDI0011/view.so", 1300, 800, param, "modBidNotice", true);
		}

		function doNoticeCancel() {

            if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

            if (grid.getSelRowCount() > 1) { return EVF.alert("${msg.M0006}"); }

            var buyerCd; var bidNum; var bidCnt;
            var rowIds = grid.getSelRowId();
            for(var i in rowIds) {
                if(grid.getCellValue(rowIds[i], 'BID_STATUS') == "P") {
                    return EVF.alert("${CBDI0010_007}");
                }
                if((grid.getCellValue(rowIds[i], 'BID_STATUS') != "E" && grid.getCellValue(rowIds[i], 'BID_STATUS') != "A")) {
                    return EVF.alert("${CBDI0010_006}");
                }
                buyerCd = grid.getCellValue(rowIds[i], 'BUYER_CD');
                bidNum = grid.getCellValue(rowIds[i], 'BID_NUM');
                bidCnt = grid.getCellValue(rowIds[i], 'BID_CNT');
            }

            var param = {
                'buyerCd' : buyerCd,
                'bidNum' : bidNum,
                'bidCnt' : bidCnt,
                'baseDataType': "CancelBID",
                'popupFlag' : true,
                'detailView' : false
            };
            everPopup.openWindowPopup("/nhepro/CBDI/CBDR0013/view.so", 1300, 700, param, "cancelBidNotice", true);
		}

		function doTechEval() {

			if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

			if (grid.getSelRowCount() > 1) { return EVF.alert("${msg.M0006}"); }

			var bidNum; var bidCnt;
			var rowIds = grid.getSelRowId();
			for(var i in rowIds) {
				if(grid.getCellValue(rowIds[i], 'TECH_EV_TYPE') != "20") {
					return EVF.alert("${CBDI0010_010}");
				}
                if((grid.getCellValue(rowIds[i], 'BID_STATUS') != "E" && grid.getCellValue(rowIds[i], 'BID_STATUS') != "A")) {
					return EVF.alert("${CBDI0010_012}");
				}
				buyerCd = grid.getCellValue(rowIds[i], 'BUYER_CD');
				bidNum = grid.getCellValue(rowIds[i], 'BID_NUM');
				bidCnt = grid.getCellValue(rowIds[i], 'BID_CNT');
			}

			var param = {
				'buyerCd' : buyerCd,
				'bidNum' : bidNum,
				'bidCnt' : bidCnt,
				'popupFlag' : true,
				'detailView' : false
			};
			everPopup.openWindowPopup("/nhepro/CBDI/CBDR0015/view.so", 1000, 750, param, "techEval", true);
		}

	    function getBidUserId() {

			var callBackType = this.getData().data;
			var param = {
				'callBackFunction': (callBackType == "S") ? "setBidUserId" : "setCtrlUserId",
				'READONLY': 'Y',		// 팝업 조회조건 변경불가
				'multiYN' : 'N',        // 멀티팝업여부
				'CTRL_CD' : 'BR030',	// 구매담당자권한
				'detailView': false
			};
			everPopup.openPopupByScreenId("CCDU0020", 1100, 700, param);
		}

	    function setBidUserId(data) {
	    	if(data != null){
				data = JSON.parse(data);
				EVF.V("BID_USER_ID", data.USER_ID);
				EVF.V("BID_USER_NM", data.USER_NM);
	    	}
		}

	    function setCtrlUserId(data) {
	    	if(data != null){
				data = JSON.parse(data);
				EVF.V("CTRL_USER_ID", data.USER_ID);
				EVF.V("CTRL_USER_NM", data.USER_NM);
	    	}
		}
	    
	    function getEvUserId() {

			var callBackType = this.getData().data;
			var param = {
				'callBackFunction': "setEvUserId",
				'READONLY': 'N',		// 팝업 조회조건 변경
				'multiYN' : 'N',        // 멀티팝업여부
				'CTRL_CD' : '',			// 구매담당자권한
				'detailView': false
			};
			everPopup.openPopupByScreenId("CCDU0020", 1100, 700, param);
		}
	    
	    function setEvUserId(data) {
	    	if(data != null){
				data = JSON.parse(data);
				EVF.V("EV_USER_ID", data.USER_ID);
				EVF.V("EV_USER_NM", data.USER_NM);
	    	}
		}

	    function cleanUserId() {
			EVF.V("BID_USER_ID", "");
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
	<e:window id="CBDI0010" initData="${initData}" onReady="init" title="${fullScreenName }" breadCrumbs="${breadCrumb }">
		<e:searchPanel id="form" title="${form_CAPTION_N }" labelWidth="${labelWidth}" width="100%" columnCount="3" useTitleBar="false" onEnter="doSearch">
			<e:row>
				<e:label for="ANN_DATE_FROM" title="${form_ANN_DATE_FROM_N}" />
				<e:field>
					<e:inputDate id="ANN_DATE_FROM" name="ANN_DATE_FROM" toDate="ANN_DATE_TO" value="${reqFromDate }" width="${inputDateWidth }" required="${form_ANN_DATE_FROM_R}" disabled="${form_ANN_DATE_FROM_D}" readOnly="${form_ANN_DATE_FROM_RO}" datePicker="true" />
					<e:text>~&nbsp;</e:text>
					<e:inputDate id="ANN_DATE_TO" name="ANN_DATE_TO" fromDate="ANN_DATE_FROM" value="${reqToDate }" width="${inputDateWidth }" required="${form_ANN_DATE_TO_R}" disabled="${form_ANN_DATE_TO_D}" readOnly="${form_ANN_DATE_TO_RO}" datePicker="true" />
				</e:field>
				<e:label for="BID_STATUS" title="${form_BID_STATUS_N}" />
				<e:field>
					<e:select id="BID_STATUS" name="BID_STATUS" value="" options="${bidStatusOptions }" width="${form_BID_STATUS_W }" disabled="${form_BID_STATUS_D}" readOnly="${form_BID_STATUS_RO}" required="${form_BID_STATUS_R}" placeHolder="" />
				</e:field>
				<e:label for="BID_USER_ID" title="${form_BID_USER_ID_N}"/>
				<e:field>
					<e:search id="BID_USER_ID" name="BID_USER_ID" value="" width="40%" maxLength="${form_BID_USER_ID_M}" disabled="${form_BID_USER_ID_D}" readOnly="${form_BID_USER_ID_RO}" required="${form_BID_USER_ID_R}" placeHolder="개인번호" onIconClick="getBidUserId" data="S" />
					<e:inputText id="BID_USER_NM" name="BID_USER_NM" value="" width="60%" maxLength="${form_BID_USER_NM_M}" disabled="${form_BID_USER_NM_D}" readOnly="${form_BID_USER_NM_RO}" required="${form_BID_USER_NM_R}" placeHolder="성명" />
				</e:field>
			</e:row>
			<e:row>
				<e:label for="ANN_NO" title="${form_ANN_NO_N}"/>
				<e:field>
					<e:inputText id="ANN_NO" name="ANN_NO" value="" width="${form_ANN_NO_W}" maxLength="${form_ANN_NO_M}" disabled="${form_ANN_NO_D}" readOnly="${form_ANN_NO_RO}" required="${form_ANN_NO_R}" />
				</e:field>
				<e:label for="ANN_ITEM" title="${form_ANN_ITEM_N}"/>
				<e:field>
					<e:inputText id="ANN_ITEM" name="ANN_ITEM" value="" width="${form_ANN_ITEM_W}" maxLength="${form_ANN_ITEM_M}" disabled="${form_ANN_ITEM_D}" readOnly="${form_ANN_ITEM_RO}" required="${form_ANN_ITEM_R}" />
				</e:field>
				<e:label for="BUYER_CD" title="${form_BUYER_CD_N}"/>
				<e:field>
					<e:search id="BUYER_CD" name="BUYER_CD" value="" width="40%" maxLength="${form_BUYER_CD_M}" disabled="${form_BUYER_CD_D}" readOnly="${form_BUYER_CD_RO}" required="${form_BUYER_CD_R}" placeHolder="회사코드" onIconClick="getBuyerCd" />
					<e:inputText id="BUYER_NM" name="BUYER_NM" value="" width="60%" maxLength="${form_BUYER_NM_M}" disabled="${form_BUYER_NM_D}" readOnly="${form_BUYER_NM_RO}" required="${form_BUYER_NM_R}" placeHolder="회사명" />
				</e:field>
			</e:row>
		</e:searchPanel>

		<e:buttonBar id="buttonBar" align="right" width="100%">
			<!-- 입찰담당자 변경 -->
			<e:text style="color: blue;font-weight: bold;">■ 입찰담당자 : </e:text>
			<e:search id="CTRL_USER_NM" name="CTRL_USER_NM" value="" width="${form_CTRL_USER_NM_W}" maxLength="${form_CTRL_USER_NM_M}" disabled="${form_CTRL_USER_NM_D}" readOnly="${form_CTRL_USER_NM_RO}" required="${form_CTRL_USER_NM_R}" align="left" onIconClick="getBidUserId" data="I" />
			<e:inputHidden id="CTRL_USER_ID" name="CTRL_USER_ID" value="" />
			<e:button id="ChangeCtrl" name="ChangeCtrl" label="${ChangeCtrl_N }" disabled="${ChangeCtrl_D }" visible="${ChangeCtrl_V}" style="padding-left:3px;" align="left" onClick="doChangeCtrl" />
			<!-- 규격/기술평가자 변경 -->
			<e:text style="color: blue;font-weight: bold;">■ 규격/기술평가담당자 : </e:text>
			<e:search id="EV_USER_NM" name="EV_USER_NM" value="" width="${form_EV_USER_NM_W}" maxLength="${form_EV_USER_NM_M}" disabled="${form_EV_USER_NM_D}" readOnly="${form_EV_USER_NM_RO}" required="${form_EV_USER_NM_R}" align="left" onIconClick="getEvUserId" />
			<e:inputHidden id="EV_USER_ID" name="EV_USER_ID" value="" />
			<e:button id="ChangeEv" name="ChangeEv" label="${ChangeCtrl_N }" disabled="${ChangeCtrl_D }" visible="${ChangeCtrl_V}" style="padding-left:3px;" align="left" onClick="doChangeEv"/>
			
			<e:button id="Search" name="Search" label="${Search_N }" disabled="${Search_D }" visible="${Search_V}" onClick="doSearch" />
			<e:button id="Modify" name="Modify" label="${Modify_N }" disabled="${Modify_D }" visible="${Modify_V}" onClick="doModify" />
			<e:button id="NoticeMod" name="NoticeMod" label="${NoticeMod_N }" disabled="${NoticeMod_D }" visible="${NoticeMod_V}" onClick="doNoticeMod" />
			<e:button id="NoticeCancel" name="NoticeCancel" label="${NoticeCancel_N }" disabled="${NoticeCancel_D }" visible="${NoticeCancel_V}" onClick="doNoticeCancel" />
			<e:button id="TechEval" name="TechEval" label="${TechEval_N }" disabled="${TechEval_D }" visible="${TechEval_V}" onClick="doTechEval" />
		</e:buttonBar>

		<e:gridPanel id="grid" name="grid" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}" />

	</e:window>
</e:ui>