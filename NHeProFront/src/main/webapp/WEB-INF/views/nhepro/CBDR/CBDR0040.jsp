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
		var baseUrl = "/nhepro/CBDR/";
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
	        	if(colIdx == "APP_END_DATETIME") { <%-- 입찰등록결과 화면을 Popup으로 open. --%>
					var param = {
							'buyerCd'    : buyerCd,
							'bidNum'     : bidNum,
							'bidCnt'     : bidCnt,
							'popupFlag'  : true,
							'detailView' : true
						};
						everPopup.openWindowPopup("/nhepro/CBDI/CBDI0021/view.so", 1200, 800, param, "bidAppClose", true);
	        	}
	        	if(colIdx == "BID_END_DATETIME") {
	        		var contType2 = grid.getCellValue(rowIdx, 'CONT_TYPE2');
	        		var techEvType = grid.getCellValue(rowIdx, 'TECH_EV_TYPE');

	        		if(contType2 == "TD" || contType2 == "TS") { <%-- 규격평가결과 화면을 Popup으로 open. --%>
	        			var param = {
	        					'BUYER_CD'   : buyerCd,
	        					'BID_NUM'    : bidNum,
	        					'BID_CNT'    : bidCnt,
	        	                'REBID'      : false,
	        					'popupFlag'  : true,
	        					'detailView' : true
	        				};
	        				var callUrl = "/nhepro/CBDR/CBDI0031/view.so";
	        				everPopup.openWindowPopup(callUrl, 1100, 600, param, "bidEval", true);
	        		} else if (contType2 == "NE" && techEvType == "10") { <%-- 기술평가결과 화면을 Popup으로 open. --%>

						var voteCnt = grid.getCellValue(rowIdx, 'VOTE_CNT');
		                var param = {
		                        'BUYER_CD' : buyerCd,
		                        'BID_NUM' : bidNum,
		                        'BID_CNT' : bidCnt,
		                        'VOTE_CNT' : voteCnt,
		                        'popupFlag' : true,
		                        'detailView' : true
		                    };
		                    everPopup.openWindowPopup("/nhepro/CBDR/CBDI0035/view.so", 1100, 600, param, "openDocument", true);
					}
	        	}
	        	if(colIdx == "BID_STATUS_LOC") {
					var param = {
						'BUYER_CD'     : buyerCd,
						'BID_NUM'      : bidNum,
						'BID_CNT'      : bidCnt,
						'VOTE_CNT'     : grid.getCellValue(rowIdx, 'VOTE_CNT'),
						'BID_STATUS'   : grid.getCellValue(rowIdx, 'BID_STATUS'),
		                'evResultFlag' : false,
						'popupFlag'    : true,
						'detailView'   : true
					};
					everPopup.openWindowPopup("/nhepro/CBDR/CBDR0033/view.so", 1200, 800, param, "bidClose", true);
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
			grid.setProperty('singleSelect', true);					// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]
			grid.setProperty('multiSelect', ${multiSelect});		// [선택] 컬럼의 사용여부를 지정한다. [true/false]
			
			// 2021.02.08 중앙회 요청 "관리자직무"를 갖는 사람은 담당자 변경 가능하도록 추가
		    if ("${ses.ctrlCd}".indexOf("${ManagerCd}") > -1) {
		    	changeFlag = true;
            }
		    setType();
			doSearch();
		}
		
	    function setType() {
			setContTypeOption();	// 진행상태 기본값 세팅
		}
	    
	    function setContTypeOption(){
	    	var contType = "";
	    	$('input[name=multiselect_CONT_TYPE]').each(function (k, v) {
				if( !(v.value == "") ) {
					contType += v.title + ", ";
					v.checked = true;
				} else {
					$(v).parent().remove();
				}
			});
			$("#CONT_TYPE").next().find("span, .e-select-text").text(contType.substr(0, contType.length - 2));
	    }
	    
	    function doSearch() {

	    	var store = new EVF.Store();
			if(!store.validate()) { return; }

	        store.setGrid([grid]);
	        store.load(baseUrl + 'cbdr0040_doSearch.so', function() {
	        	if(grid.getRowCount() == 0){
	            	EVF.alert("${msg.M0002 }");
	            }
	        });
	    }

	    function doBidUserChange() {

			if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

			if(EVF.isEmpty(EVF.C("BID_USER_ID").getValue())) {
                return EVF.alert("${CBDR0040_001}");
            }
			
			var rowIds = grid.getSelRowId();
			// 2021.02.08 중앙회 요청 "관리자직무"를 갖는 사람은 담당자 변경 가능하도록 추가
	    	for(var i in rowIds) {
	    		if(!changeFlag) {
		    		if(grid.getCellValue(rowIds[i], 'BID_USER_ID') != "${ses.userId}") {
	    				return EVF.alert("${CBDR0040_003}");
	    			}
	    		}
    		}

			EVF.confirm("${CBDR0040_004 }", function () {
				var store = new EVF.Store();
				store.setGrid([grid]);
	            store.getGridData(grid, 'sel');
	            store.setParameter("CHANGE_USER_ID", EVF.C("BID_USER_ID").getValue());
	            store.load(baseUrl + 'cbdr0040_doUserChange.so', function(){
	        		EVF.alert(this.getResponseMessage(), function() {
	        			doSearch();
					});
	        	});
			});
		}
	    
	    function doFailBidCancle() {
	    	if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
	    	if (grid.getSelRowCount() > 1) { return EVF.alert("${msg.M0006}"); }
	    	
	    	var rowIds = grid.getSelRowId();
	    	var rowIdx = rowIds[0];
	    	
	    	var contType2 = grid.getCellValue(rowIdx, "CONT_TYPE2");
	    	if(contType2 == 'QE' || contType2 == 'NE'){
				return EVF.alert("${CBDR0040_012}");
			}
	    	
	    	var preBidStatus = grid.getCellValue(rowIdx, "PRE_BID_STATUS");
	    	if(preBidStatus != '2400'){
				return EVF.alert("${CBDR0040_013}");
			}
	    	
			var rltSignStatus  = grid.getCellValue(rowIdx, "RLT_SIGN_STATUS");
			if(rltSignStatus != ''){
				return EVF.alert("${CBDR0040_010}");
			}

			var buyerCd = grid.getCellValue(rowIdx, "BUYER_CD");
			var bidNum  = grid.getCellValue(rowIdx, "BID_NUM");
			var bidCnt  = grid.getCellValue(rowIdx, "BID_CNT");
			var voteCnt = grid.getCellValue(rowIdx, "VOTE_CNT");
			
			EVF.confirm("${CBDR0040_011 }", function () {
	            var param = {
	                'buyerCd' : buyerCd,
	                'bidNum' : bidNum,
	                'bidCnt' : bidCnt,
	                'preBidNum' : bidNum,
	                'preBidCnt' : bidCnt,
	                'preVoteCnt' : voteCnt,
	                'baseDataType': "ReBID",
	                'callbackFunction': "doCallBackFunction",
	                'popupFlag' : true,
	                'detailView' : false
	            };
	            everPopup.openWindowPopup("/nhepro/CBDI/CBDI0011/view.so", 1300, 800, param, "modBidNotice", true);
			});
	    }
	    
	    function doCallBackFunction() {
            var popupFlag = ${(param.popupFlag == null || !param.popupFlag) ? false : true};
            if(popupFlag) {
                opener.doSearch();
                doClose();
            }
        }

		function doResultReport() {

			if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

			var subject; var docNum; var appDocNum;
			var rowIds = grid.getSelRowId();
			for(var i in rowIds) {
				if(grid.getCellValue(rowIds[i], 'BID_STATUS') != "1300") {
					return EVF.alert("${CBDR0040_006}");
				}
				if(grid.getCellValue(rowIds[i], 'BID_USER_ID') != "${ses.userId}") {
					return EVF.alert("${CBDR0040_003}");
				}
				if(grid.getCellValue(rowIds[i], 'RLT_SIGN_STATUS') == "P") {
					return EVF.alert("${CBDR0040_008}");
				}
				if(grid.getCellValue(rowIds[i], 'RLT_SIGN_STATUS') == "E") {
					return EVF.alert("${CBDR0040_009}");
				}
				subject = "[입찰결과보고] " + grid.getCellValue(rowIds[i], 'ANN_ITEM');
				docNum = grid.getCellValue(rowIds[i], 'BID_NUM');
				appDocNum = grid.getCellValue(rowIds[i], 'RLT_APP_DOC_NUM');
			}

			EVF.confirm("${CBDR0040_007 }", function () {
				var param = {
					subject: subject,
					docType: "BIDRLT",
					signStatus: "P",
					screenId: "CBDR0033",
					approvalType: 'APPROVAL',
					attFileNum: "",
					docNum: docNum,
					appDocNum: appDocNum,
					callBackFunction: "goApproval",
					appAmt: 0
				};
				everPopup.openApprovalRequestIPopup(param);
			});
		}

		function goApproval(formData, gridData, attachData) {

			var store = new EVF.Store();
			store.setGrid([grid]);
			store.getGridData(grid, 'sel');
			store.setParameter("approvalFormData", formData);
			store.setParameter("approvalGridData", gridData);
			store.setParameter("attachFileDatas", attachData);
			store.load(baseUrl + 'cbdr0040_doApproval.so', function(){
				EVF.alert(this.getResponseMessage(), function() {
					doSearch();
				});
			});
		}

	    function getBidUserId() {

			var callBackType = this.getData().data;
			var param = {
					'callBackFunction': (callBackType == "S" ? "setSearchCondition" : "setBidUserId"),
					'READONLY': 'Y',		//팝업 조회조건 변경불가
					'multiYN' : 'N',        //멀티팝업여부
					'CTRL_CD' : 'BR030',	//구매담당자권한
					'detailView': false
			};
			everPopup.openPopupByScreenId("CCDU0020", 1100, 700, param);
		}

	    function setSearchCondition(data) {
	    	if(data!=null){
				data = JSON.parse(data);
				EVF.V("sBID_USER_ID", data.USER_ID);
				EVF.V("sBID_USER_NM", data.USER_NM);
	    	}
		}

	    function setBidUserId(data) {
	    	if(data!=null){
				data = JSON.parse(data);
				EVF.V("BID_USER_ID", data.USER_ID);
				EVF.V("BID_USER_NM", data.USER_NM);
	    	}
		}

	    function cleanUserId() {
			EVF.V("sBID_USER_ID", "");
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

		function getVendorCd() {

			var param = {
				BUYER_CD : "${ses.companyCd}",
				callBackFunction : "setVendorCd"
			};
			everPopup.openCommonPopup(param, 'SP0123');
		}

		function setVendorCd(data) {
			EVF.V("SETTEL_VENDOR_CD", data.VENDOR_CD);
			EVF.V("SETTEL_VENDOR_NM", data.VENDOR_NM);
		}

		function cleanVendorCd() {
			EVF.V("SETTEL_VENDOR_CD", "");
		}

    </script>
	<e:window id="CBDR0040" initData="${initData}" onReady="init" title="${fullScreenName }" breadCrumbs="${breadCrumb }">
		<e:searchPanel id="form" title="${form_CAPTION_N }" labelWidth="${labelWidth}" width="100%" columnCount="3" useTitleBar="false" onEnter="doSearch">
			<e:row>
				<e:label for="BID_END_DATETIME_FROM" title="${form_BID_END_DATETIME_FROM_N}" />
				<e:field>
					<e:inputDate id="BID_END_DATETIME_FROM" name="BID_END_DATETIME_FROM" toDate="BID_END_DATETIME_TO" value="${fromDate }" width="${inputDateWidth }" required="${form_BID_END_DATETIME_FROM_R}" disabled="${form_BID_END_DATETIME_FROM_D}" readOnly="${form_BID_END_DATETIME_FROM_RO}" datePicker="true" />
					<e:text>~&nbsp;</e:text>
					<e:inputDate id="BID_END_DATETIME_TO" name="BID_END_DATETIME_TO" fromDate="BID_END_DATETIME_FROM" value="${toDate }" width="${inputDateWidth }" required="${form_BID_END_DATETIME_TO_R}" disabled="${form_BID_END_DATETIME_TO_D}" readOnly="${form_BID_END_DATETIME_TO_RO}" datePicker="true" />
				</e:field>
				<e:label for="BID_STATUS" title="${form_BID_STATUS_N}" />
				<e:field>
					<e:select id="BID_STATUS" name="BID_STATUS" value="" options="${bidStatusOptions }" width="${form_BID_STATUS_W }" disabled="${form_BID_STATUS_D}" readOnly="${form_BID_STATUS_RO}" required="${form_BID_STATUS_R}" placeHolder="" />
				</e:field>
				<e:label for="sBID_USER_ID" title="${form_sBID_USER_ID_N}"/>
				<e:field>
					<e:search id="sBID_USER_ID" name="sBID_USER_ID" value="" width="40%" maxLength="${form_sBID_USER_ID_M}" disabled="${form_sBID_USER_ID_D}" readOnly="${form_sBID_USER_ID_RO}" required="${form_sBID_USER_ID_R}" onIconClick="getBidUserId" data="S" placeHolder="개인번호" />
					<e:inputText id="sBID_USER_NM" name="sBID_USER_NM" value="" width="60%" maxLength="${form_sBID_USER_NM_M}" disabled="${form_sBID_USER_NM_D}" readOnly="${form_sBID_USER_NM_RO}" required="${form_sBID_USER_NM_R}" placeHolder="성명" />
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
			<e:row>
				<e:label for="SETTEL_VENDOR_CD" title="${form_SETTEL_VENDOR_CD_N}"/>
				<e:field>
					<e:search id="SETTEL_VENDOR_CD" name="SETTEL_VENDOR_CD" value="" width="40%" maxLength="${form_SETTEL_VENDOR_CD_M}" disabled="${form_SETTEL_VENDOR_CD_D}" readOnly="${form_SETTEL_VENDOR_CD_RO}" required="${form_SETTEL_VENDOR_CD_R}" onIconClick="getVendorCd" placeHolder="회사코드" />
					<e:inputText id="SETTEL_VENDOR_NM" name="SETTEL_VENDOR_NM" value="" width="60%" maxLength="${form_SETTEL_VENDOR_NM_M}" disabled="${form_SETTEL_VENDOR_NM_D}" readOnly="${form_SETTEL_VENDOR_NM_RO}" required="${form_SETTEL_VENDOR_NM_R}" placeHolder="회사명" />
				</e:field>
				<e:label for="RLT_SIGN_STATUS" title="${form_RLT_SIGN_STATUS_N}" />
				<e:field>
					<e:select id="RLT_SIGN_STATUS" name="RLT_SIGN_STATUS" value="" options="${rltSignStatusOptions }" width="${form_RLT_SIGN_STATUS_W }" disabled="${form_RLT_SIGN_STATUS_D}" readOnly="${form_RLT_SIGN_STATUS_RO}" required="${form_RLT_SIGN_STATUS_R}" placeHolder="" />
				</e:field>
				<e:label for="CONT_TYPE" title="${form_CONT_TYPE_N}"/>
				<e:field>
					<e:select id="CONT_TYPE" name="CONT_TYPE" value="" options="${contTypeOptions}" width="${form_CONT_TYPE_W}" disabled="${form_CONT_TYPE_D}" readOnly="${form_CONT_TYPE_RO}" required="${form_CONT_TYPE_R}" placeHolder="" maskType="${form_CONT_TYPE_MT}" useMultipleSelect="true"/>
				</e:field>
			</e:row>
		</e:searchPanel>

		<e:buttonBar id="buttonBar" align="right" width="100%">
			<e:text style="color: blue;font-weight: bold;">■ 입찰담당자 : </e:text>
			<e:search id="BID_USER_NM" name="BID_USER_NM" value="" width="${form_BID_USER_NM_W}" maxLength="${form_BID_USER_NM_M}" disabled="${form_BID_USER_NM_D}" readOnly="${form_BID_USER_NM_RO}" required="${form_BID_USER_NM_R}" align="right" onIconClick="getBidUserId" data="B" />
			<e:inputHidden id="BID_USER_ID" name="BID_USER_ID" value="" />
			<e:button id="BidUserChange" name="BidUserChange" label="${BidUserChange_N }" disabled="${BidUserChange_D }" visible="${BidUserChange_V}" style="padding-left:3px;" align="left" onClick="doBidUserChange" />
			<e:button id="Search" name="Search" label="${Search_N }" disabled="${Search_D }" visible="${Search_V}" onClick="doSearch" />
			<e:button id="FailBidCancle" name="FailBidCancle" label="${FailBidCancle_N}" disabled="${FailBidCancle_D}" visible="${FailBidCancle_V}" onClick="doFailBidCancle"/>
			<e:button id="ResultReport" name="ResultReport" label="${ResultReport_N }" disabled="${ResultReport_D }" visible="${ResultReport_V}" onClick="doResultReport" />
		</e:buttonBar>

		<e:gridPanel id="grid" name="grid" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}" />

	</e:window>
</e:ui>