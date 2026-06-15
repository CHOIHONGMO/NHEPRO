<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page import="com.st_ones.everf.serverside.config.PropertiesManager" %>

<!-- 2021.02.08 중앙회 요청 "관리자직무"를 갖는 사람은 담당자 변경 가능하도록 추가 -->
<% String ManagerCd = PropertiesManager.getString("eversrm.customer.admin.ManagerCd"); 
%>

<c:set var="ManagerCd" value="<%=ManagerCd%>" />

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">

	<script type="text/javascript">

	    var grid;
		var baseUrl = "/nhepro/CBDI/";
		var changeFlag = false;
		
	    function init() {
	        grid = EVF.C("grid");

	        grid.cellClickEvent(function(rowIdx, colIdx, value) {

	        	var buyerCd = grid.getCellValue(rowIdx, 'BUYER_CD');
	        	var bidNum  = grid.getCellValue(rowIdx, 'BID_NUM');
	        	var bidCnt  = grid.getCellValue(rowIdx, 'BID_CNT');

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
                    everPopup.openWindowPopup(callUrl, 1200, callHeight, param, "bidAnn", true);
				}
	        	if(colIdx == "ANN_ITEM") {
					var param = {
							'buyerCd'      : buyerCd,
							'bidNum'       : bidNum,
							'bidCnt'       : bidCnt,
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
	        	if(colIdx == "APP_END_DATETIME") {
	        		// 취소공고인 경위 제외
	        		var oriBidStatus = grid.getCellValue(rowIdx, 'ORI_BID_STATUS');
	    			if(oriBidStatus == "2303" || oriBidStatus == "2330") {
	    				return EVF.alert("${CBDI0020_010}");
	                }
					var param = {
						'buyerCd'    : buyerCd,
						'bidNum'     : bidNum,
						'bidCnt'     : bidCnt,
						'popupFlag'  : true,
						'detailView' : true
					};
					everPopup.openWindowPopup("/nhepro/CBDI/CBDI0021/view.so", 1200, 800, param, "bidAppClose", true);
	        	}
	        	if(colIdx == "PERIOD_MOD_RSN") {
	        		if(value != "") {
		        		var param = {
		                        title: "입찰기간변경사유",
		                        message: value,
		                        detailView: true
	                    };
	                    everPopup.AppcommonTextInput(param);
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
	        store.load(baseUrl + 'cbdi0020_doSearch.so', function() {
	        	if(grid.getRowCount() == 0){
	            	EVF.alert("${msg.M0002 }");
	            }
	        	
	        	grid.setColIconify("PERIOD_MOD_RSN", "PERIOD_MOD_RSN", "comment", false);
	        });
	    }

	    function doChangeCtrl() {

			if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

			if(EVF.isEmpty(EVF.C("CTRL_USER_ID").getValue())) {
                return EVF.alert("${CBDI0020_001}");
            }

			var rowIds = grid.getSelRowId();
			
			// 2021.02.08 중앙회 요청 "관리자직무"를 갖는 사람은 담당자 변경 가능하도록 추가
	    	for(var i in rowIds) {
	    		if(!changeFlag) {
		    		if(grid.getCellValue(rowIds[i], 'BID_USER_ID') != "${ses.userId}") {
	    				return EVF.alert("${CBDI0020_005}");
	    			}
	    		}
    		}

			EVF.confirm("${CBDI0020_003 }", function () {
				var store = new EVF.Store();
				store.setGrid([grid]);
	            store.getGridData(grid, 'sel');
	            store.setParameter("CTRL_USER_ID", EVF.C("CTRL_USER_ID").getValue());
	            store.load(baseUrl + 'cbdi0020_doChangeCtrl.so', function(){
	        		EVF.alert(this.getResponseMessage(), function() {
	        			doSearch();
					});
	        	});
			});
		}
		
	 	// 2020.12.02 : 기능변경
		// 입찰 참가신청 마감 체크를 서버단에서 체크하도록 변경
		function doClose() {

			if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
			if (grid.getSelRowCount() > 1) { return EVF.alert("${msg.M0006}"); }
			
			var rowIds = grid.getSelRowId();
			var rowIdx = rowIds[0];
			
			var buyerCd = grid.getCellValue(rowIdx, "BUYER_CD");
			var bidNum  = grid.getCellValue(rowIdx, "BID_NUM");
			var bidCnt  = grid.getCellValue(rowIdx, "BID_CNT");
			
			EVF.V("S_BUYER_CD", buyerCd);
			EVF.V("BID_NUM", bidNum);
			EVF.V("BID_CNT", bidCnt);
			
			var store = new EVF.Store();
            store.load(baseUrl + "cbdi0020_doCheckBidClose.so", function() {
            	var responseCode = this.getResponseCode();
            	if( responseCode != "" ) {
            		return EVF.alert(this.getResponseMessage());
            	}
            	
            	var param = {
        				'buyerCd'    : buyerCd,
        				'bidNum'     : bidNum,
        				'bidCnt'     : bidCnt,
        				'voteCnt'    : grid.getCellValue(rowIdx, "VOTE_CNT"),
        				'popupFlag'  : true,
        				'detailView' : false
        			};
       			everPopup.openWindowPopup("/nhepro/CBDI/CBDI0021/view.so", 1200, 800, param, "bidClose", true);
            });
            
            /**
			var buyerCd; var bidNum; var bidCnt;
			var rowIds = grid.getSelRowId();
			for(var i in rowIds) {
				if(grid.getCellValue(rowIds[i], 'BID_STATUS') == "100") {
					return EVF.alert("${CBDI0020_009}");
				}
				if(grid.getCellValue(rowIds[i], 'ORI_BID_STATUS') == "2330") {
					return EVF.alert("${CBDI0020_010}");
				}
				if(grid.getCellValue(rowIds[i], 'ESTM_FINISH_FLAG') != "Y") {
					return EVF.alert("${CBDI0020_011}");
				}

				buyerCd = grid.getCellValue(rowIds[i], 'BUYER_CD');
				bidNum = grid.getCellValue(rowIds[i], 'BID_NUM');
				bidCnt = grid.getCellValue(rowIds[i], 'BID_CNT');
			}

			var param = {
				'buyerCd'    : buyerCd,
				'bidNum'     : bidNum,
				'bidCnt'     : bidCnt,
				'popupFlag'  : true,
				'detailView' : false
			};
			everPopup.openWindowPopup("/nhepro/CBDI/CBDI0021/view.so", 1200, 800, param, "bidClose", true);*/
		}

		function doFailBidding() {

			if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
			if (grid.getSelRowCount() > 1) { return EVF.alert("${msg.M0006}"); }
			
			var rowIds = grid.getSelRowId();
			var rowIdx = rowIds[0];
			
			var buyerCd = grid.getCellValue(rowIdx, "BUYER_CD");
			var bidNum  = grid.getCellValue(rowIdx, "BID_NUM");
			var bidCnt  = grid.getCellValue(rowIdx, "BID_CNT");
			
			EVF.V("S_BUYER_CD", buyerCd);
			EVF.V("BID_NUM", bidNum);
			EVF.V("BID_CNT", bidCnt);
			
			var store = new EVF.Store();
            store.load(baseUrl + "cbdi0020_doCheckFailBidding.so", function() {
            	var responseCode = this.getResponseCode();
            	if( responseCode != "" ) {
            		return EVF.alert(this.getResponseMessage());
            	}
            	
            	EVF.confirm("${CBDI0020_007 }", function () {
    				var store = new EVF.Store();
    				store.setGrid([grid]);
    				store.getGridData(grid, 'sel');
    				store.load(baseUrl + 'cbdi0020_doFailBidding.so', function(){
    					EVF.alert(this.getResponseMessage(), function() {
    						doSearch();
    					});
    				});
    			});
            });
            
            /**
			var rowIds = grid.getSelRowId();
			for(var i in rowIds) {
				if(grid.getCellValue(rowIds[i], 'BID_STATUS') == "100") {
					return EVF.alert("${CBDI0020_009}");
				}
                if(grid.getCellValue(rowIds[i], 'ORI_BID_STATUS') == "2330") {
                    return EVF.alert("${CBDI0020_010}");
                }
			}

			EVF.confirm("${CBDI0020_007 }", function () {
				var store = new EVF.Store();
				store.setGrid([grid]);
				store.getGridData(grid, 'sel');
				store.load(baseUrl + 'cbdi0020_doFailBidding.so', function(){
					EVF.alert(this.getResponseMessage(), function() {
						doSearch();
					});
				});
			});*/
		}
		
		// 2021.06.17 입찰신청시간변경 기능 추가
		function doChageAppTime() {
			if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
			if (grid.getSelRowCount() > 1) { return EVF.alert("${msg.M0006}"); }
			
			var rowIds = grid.getSelRowId();
			var rowIdx = rowIds[0];
			
			var bidUserId = grid.getCellValue(rowIdx, "BID_USER_ID");
			var bidNum = grid.getCellValue(rowIdx, 'BID_NUM');
			var bidCnt = grid.getCellValue(rowIdx, 'BID_CNT');
			var buyerCd = grid.getCellValue(rowIdx, 'BUYER_CD');
			var bidStatus = grid.getCellValue(rowIdx, 'BID_STATUS');
			var periodModRsn = grid.getCellValue(rowIdx, 'PERIOD_MOD_RSN');
			var oriBidStatus = grid.getCellValue(rowIdx, 'ORI_BID_STATUS');
            
			// 취소공고인 경위 제외
			if(oriBidStatus == "2303" || oriBidStatus == "2330") {
				return EVF.alert("${CBDI0020_010}");
            }
			
			if(periodModRsn != ''){
				return EVF.alert("${CBDI0020_013}");
			}
			
			if(bidStatus != '100'){
				return EVF.alert("${CBDI0020_012}");
			}
			
			if( "${hasManagerCd}" != 'true' ) {
				return EVF.alert("${CBDI0020_014}");
			}
			
			var param = {
					  BID_NUM  : bidNum
					, BID_CNT  : bidCnt
					, BUYER_CD : buyerCd
					,'baseDataType' : "ModifyBID"
					,'detailView':false
					,'screenID': "CBDI0020"
  			};
  			everPopup.openPopupByScreenId('CBDI0022', 1050, 630, param);
		}

	    function getBidUserId() {

			var callBackType = this.getData().data;
			var param = {
					'callBackFunction': (callBackType == "S" ? "setBidUserId" : "setCtrlUserId"),
					'READONLY': 'Y',		//팝업 조회조건 변경불가
					'multiYN' : 'N',        //멀티팝업여부
					'CTRL_CD' : 'BR030',	//구매담당자권한
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

	    function setCtrlUserId(data) {
	    	if(data!=null){
				data = JSON.parse(data);
				EVF.V("CTRL_USER_ID", data.USER_ID);
				EVF.V("CTRL_USER_NM", data.USER_NM);
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
	<e:window id="CBDI0020" initData="${initData}" onReady="init" title="${fullScreenName }" breadCrumbs="${breadCrumb }">
		<e:searchPanel id="form" title="${form_CAPTION_N }" labelWidth="${labelWidth}" width="100%" columnCount="3" useTitleBar="false" onEnter="doSearch">
			<e:inputHidden id="S_BUYER_CD" name="S_BUYER_CD"/>
			<e:inputHidden id="BID_NUM"  name="BID_NUM"/>
			<e:inputHidden id="BID_CNT"  name="BID_CNT"/>
			<e:row>
				<e:label for="APP_END_FROM" title="${form_APP_END_FROM_N}" />
				<e:field>
					<e:inputDate id="APP_END_FROM" name="APP_END_FROM" toDate="APP_END_TO" value="${reqFromDate }" width="${inputDateWidth }" required="${form_APP_END_FROM_R}" disabled="${form_APP_END_FROM_D}" readOnly="${form_APP_END_FROM_RO}" datePicker="true" />
					<e:text>~&nbsp;</e:text>
					<e:inputDate id="APP_END_TO" name="APP_END_TO" fromDate="APP_END_FROM" value="${reqToDate }" width="${inputDateWidth }" required="${form_APP_END_TO_R}" disabled="${form_APP_END_TO_D}" readOnly="${form_APP_END_TO_RO}" datePicker="true" />
				</e:field>
				<e:label for="BID_STATUS" title="${form_BID_STATUS_N}" />
				<e:field>
					<e:select id="BID_STATUS" name="BID_STATUS" value="" options="${bidStatusOptions }" width="${form_BID_STATUS_W }" disabled="${form_BID_STATUS_D}" readOnly="${form_BID_STATUS_RO}" required="${form_BID_STATUS_R}" placeHolder="" />
				</e:field>
				<e:label for="BID_USER_ID" title="${form_BID_USER_ID_N}"/>
				<e:field>
					<e:search id="BID_USER_ID" name="BID_USER_ID" value="" width="40%" maxLength="${form_BID_USER_ID_M}" disabled="${form_BID_USER_ID_D}" readOnly="${form_BID_USER_ID_RO}" required="${form_BID_USER_ID_R}" onIconClick="getBidUserId" data="S" placeHolder="개인번호" />
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
					<e:search id="BUYER_CD" name="BUYER_CD" value="" width="40%" maxLength="${form_BUYER_CD_M}" disabled="${form_BUYER_CD_D}" readOnly="${form_BUYER_CD_RO}" required="${form_BUYER_CD_R}" onIconClick="getBuyerCd" placeHolder="회사코드" />
					<e:inputText id="BUYER_NM" name="BUYER_NM" value="" width="60%" maxLength="${form_BUYER_NM_M}" disabled="${form_BUYER_NM_D}" readOnly="${form_BUYER_NM_RO}" required="${form_BUYER_NM_R}" placeHolder="회사명" />
				</e:field>
			</e:row>
		</e:searchPanel>

		<e:buttonBar id="buttonBar" align="right" width="100%">
			<e:text style="color: blue;font-weight: bold;">■ 입찰담당자 : </e:text>
			<e:search id="CTRL_USER_NM" name="CTRL_USER_NM" value="" width="${form_CTRL_USER_NM_W}" maxLength="${form_CTRL_USER_NM_M}" disabled="${form_CTRL_USER_NM_D}" readOnly="${form_CTRL_USER_NM_RO}" required="${form_CTRL_USER_NM_R}" align="left" onIconClick="getBidUserId" data="I" />
			<e:inputHidden id="CTRL_USER_ID" name="CTRL_USER_ID" value="" />
			<e:button id="ChangeCtrl" name="ChangeCtrl" label="${ChangeCtrl_N }" disabled="${ChangeCtrl_D }" visible="${ChangeCtrl_V}" style="padding-left:3px;" align="left" onClick="doChangeCtrl" />
			<e:button id="Search" name="Search" label="${Search_N }" disabled="${Search_D }" visible="${Search_V}" onClick="doSearch" />
			<e:button id="Close" name="Close" label="${Close_N }" disabled="${Close_D }" visible="${Close_V}" onClick="doClose" />
			<e:button id="FailBidding" name="FailBidding" label="${FailBidding_N }" disabled="${FailBidding_D }" visible="${FailBidding_V}" onClick="doFailBidding" />
			<c:if test="${hasManagerCd eq true}">
				<e:button id="doChageAppTime" name="doChageAppTime" label="${doChageAppTime_N }" disabled="${doChageAppTime_D }" visible="${doChageAppTime_V}" onClick="doChageAppTime" />
			</c:if>
		</e:buttonBar>

		<e:gridPanel id="grid" name="grid" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}" />

	</e:window>
</e:ui>