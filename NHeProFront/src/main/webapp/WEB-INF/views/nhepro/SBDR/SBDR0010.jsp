<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page import="com.st_ones.everf.serverside.config.PropertiesManager" %>

<%
	String sgicUrl = PropertiesManager.getString("eversrm.sgic.url");
%>

<c:set var="sgicUrl" value="<%=sgicUrl%>" />

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">

	<script type="text/javascript">

		var grid;
		var baseUrl = "/nhepro/SBDR/";
		var eventRowId = 0;

		function init() {

			grid = EVF.C("grid");

			grid._gvo.setColumnProperty(grid._gvo.columnByField("ANNO_LOC"), "header", {text:"${SBDR0010_ANNO_LOC_T}\n(필수여부)"});
			grid._gvo.setColumnProperty(grid._gvo.columnByField("PROP_LOC"), "header", {text:"${SBDR0010_PROP_LOC_T}\n(필수여부)"});

			grid.cellClickEvent(function(rowIdx, colIdx, value) {

				if(colIdx == "ANN_NO") {

					var param = {
						'buyerCd' : grid.getCellValue(rowIdx, 'BUYER_CD'),
						'bidNum' : grid.getCellValue(rowIdx, 'BID_NUM'),
						'bidCnt' : grid.getCellValue(rowIdx, 'BID_CNT'),
						'popupFlag' : true,
						'detailView' : true
					};
					<%-- 입찰공고 상세화면을 Popup으로 open. --%>
					var oriBidStatus = grid.getCellValue(rowIdx, 'ORI_BID_STATUS');
					var callUrl = ((oriBidStatus == "2303" || oriBidStatus == "2330") ? "/nhepro/SBDR/SBDR0012/view.so" : "/nhepro/SBDR/SBDR0011/view.so");
					var callHeight = ((oriBidStatus == "2303" || oriBidStatus == "2330") ? 700 : 900);
					everPopup.openWindowPopup(callUrl, 1200, callHeight, param, "bidDetail", true);
				}
				if(colIdx == "ANNO_LOC") {
					// 취소공고인 경위 제외
	        		var oriBidStatus = grid.getCellValue(rowIdx, 'ORI_BID_STATUS');
	    			if(oriBidStatus == "2303" || oriBidStatus == "2330") {
	    				return EVF.alert("${SBDR0010_003}");
	                }
	    			
					if (grid.getCellValue(rowIdx, 'ANNO_OPEN_FLAG') != '1') { return; }
					
					var param = {
						BUYER_CD: grid.getCellValue(rowIdx, 'BUYER_CD'),
						BID_NUM: grid.getCellValue(rowIdx, 'BID_NUM'),
						BID_CNT : grid.getCellValue(rowIdx, 'BID_CNT')
					};
					var url = '/nhepro/SBDR/SBDR0014/view.so';
					everPopup.openWindowPopup(url, 600, 440, param, 'openAnnoPopup');
				}
				if(colIdx == "PROP_LOC") {
					// 취소공고인 경위 제외
	        		var oriBidStatus = grid.getCellValue(rowIdx, 'ORI_BID_STATUS');
	    			if(oriBidStatus == "2303" || oriBidStatus == "2330") {
	    				return EVF.alert("${SBDR0010_003}");
	                }
	    			
					if (grid.getCellValue(rowIdx, 'PROP_OPEN_FLAG') != '1') { return; }
					
					var param = {
						BUYER_CD: grid.getCellValue(rowIdx, 'BUYER_CD'),
						BID_NUM: grid.getCellValue(rowIdx, 'BID_NUM'),
						BID_CNT : grid.getCellValue(rowIdx, 'BID_CNT')
					};
					var url = '/nhepro/SBDR/SBDR0015/view.so';
					everPopup.openWindowPopup(url, 600, 440, param, 'openPropPopup');
				}
				if(colIdx == "GUAR_NUM") {
	        		if(!EVF.isEmpty(grid.getCellValue(rowIdx, 'GUAR_NUM'))) {
	        			var url = "${sgicUrl}";
                		window.open(url);
	        		}
                }
				if(colIdx == "GUAR_CNT") {
					// 취소공고인 경위 제외
	        		var oriBidStatus = grid.getCellValue(rowIdx, 'ORI_BID_STATUS');
	    			if(oriBidStatus == "2303" || oriBidStatus == "2330") {
	    				return EVF.alert("${SBDR0010_003}");
	                }
	    			
					if (grid.getCellValue(rowIdx, 'BID_GUAR_TYPE') == 'F') {
						var param = {
							attFileNum: grid.getCellValue(rowIdx, 'GUAR_ATT_FILE_NUM'),
							rowIdx: '',
							callBackFunction: '',
							bizType: 'BID',
							detailView: true
						};
						everPopup.fileAttachPopup(param);
					}
				}
				if(colIdx == "APP_INFO") {
					
					var detailView = false;
					
					// 2021.06.29 참가신청은 중복으로 가능함
					//if(grid.getCellValue(rowIdx, 'APP_INFO') == 'Y') {
					//	detailView = true;
					//}
					
					var buyerCd = grid.getCellValue(rowIdx, 'BUYER_CD');
					var bidNum  = grid.getCellValue(rowIdx, "BID_NUM");
					var bidCnt  = grid.getCellValue(rowIdx, "BID_CNT");
					
					EVF.V("BUYER_CD", buyerCd);
					EVF.V("BID_NUM",  bidNum);
					EVF.V("BID_CNT",  bidCnt);
					
					var store = new EVF.Store();
		            store.load(baseUrl + "sbdr0010_doCheckProgressCd.so", function() {
		            	var responseCode = this.getResponseCode();
		            	if( responseCode != "" ) {
		            		return EVF.alert(this.getResponseMessage());
		            	}
		            	
		           		var param = {
		                        BUYER_CD: buyerCd,
		           				BID_NUM: bidNum,
		           				BID_CNT: bidCnt,
		           				VENDOR_CD: "${ses.companyCd}",
		           				detailView: detailView,
		           				popupFlag: true
		           			};
		                var url = '/nhepro/SBDR/SBDI0013/view.so';
		                everPopup.openWindowPopup(url, 1220, 700, param, 'openApplyPopup');
		            });
		            
		            /** 2020.12.03 체크로직을 서버단으로 변경
					var detailView = false;
					if(grid.getCellValue(rowIdx, 'APPLY_POSSIBLE_FLAG') == 'N' && grid.getCellValue(rowIdx, 'APP_INFO') == 'N') {
						return EVF.alert("${SBDR0010_001}");
					}
					if(grid.getCellValue(rowIdx, 'APP_INFO') == 'Y') {
						detailView = true;
					}

					var param = {
						BUYER_CD: grid.getCellValue(rowIdx, 'BUYER_CD'),
						BID_NUM: grid.getCellValue(rowIdx, 'BID_NUM'),
						BID_CNT : grid.getCellValue(rowIdx, 'BID_CNT'),
						VENDOR_CD : "${ses.companyCd}",
						detailView: detailView,
						popupFlag: true
					};
					var url = '/nhepro/SBDR/SBDI0013/view.so';
					everPopup.openWindowPopup(url, 1200, 700, param, 'openApplyPopup');*/
				}
			});

			grid.excelExportEvent({
				allItems : "${excelExport.allCol}",
				fileName : "${screenName }"
			});

			grid.setProperty('shrinkToFit', false);					// 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
			grid.setProperty('rowNumbers', ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
			grid.setProperty('sortable', ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
			grid.setProperty('panelVisible', ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
			grid.setProperty('enterToNextRow', ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
			grid.setProperty('acceptZero', ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
			grid.setProperty('singleSelect', true);		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]
			grid.setProperty('multiSelect', ${param.detailView == true ? false : multiSelect}); // [선택] 컬럼의 사용여부를 지정한다. [true/false]
			
			grid.setColGroup([
                {
                    "groupName": "입찰보증",
                    "columns": ["BID_GUAR_TYPE", "GUAR_REQ_NUM", "GUAR_NUM", "GUAR_CNT"]
                }
            ], 50);
			
			doSearch();
			setLinkStyle()
		}
			
		function setLinkStyle() {
			grid.setColFontColor("GUAR_NUM", "#FF0000");
        }
		
		function doSearch() {

			var store = new EVF.Store();
			if(!store.validate()) { return; }
			store.setGrid([grid]);
			store.load(baseUrl + 'sbdr0010_doSearch.so', function() {
				if(grid.getRowCount() == 0){
					EVF.alert("${msg.M0002}");
				}
			});
		}
	    
		// 2020.12.02 : 기능변경
		// 입찰참가신청 가능여부 체크를 서버단에서 체크하도록 변경
		function doApply() {

			if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

			var rowIds = grid.getSelRowId();
			var rowIdx = rowIds[0];
			
			var buyerCd = grid.getCellValue(rowIdx, "BUYER_CD");
			var bidNum  = grid.getCellValue(rowIdx, "BID_NUM");
			var bidCnt  = grid.getCellValue(rowIdx, "BID_CNT");
			
			EVF.V("BUYER_CD", buyerCd);
			EVF.V("BID_NUM",  bidNum);
			EVF.V("BID_CNT",  bidCnt);
			
			var store = new EVF.Store();
            store.load(baseUrl + "sbdr0010_doCheckProgressCd.so", function() {
            	var responseCode = this.getResponseCode();
            	if( responseCode != "" ) {
            		return EVF.alert(this.getResponseMessage());
            	}
            	
           		var param = {
                        BUYER_CD: buyerCd,
           				BID_NUM: bidNum,
           				BID_CNT: bidCnt,
           				VENDOR_CD: "${ses.companyCd}",
           				detailView: false,
           				popupFlag: true
           			};
                var url = '/nhepro/SBDR/SBDI0013/view.so';
                everPopup.openWindowPopup(url, 1220, 700, param, 'openApplyPopup');
            });
            
			/**
			for(var i in rowIds) {
				if(grid.getCellValue(rowIds[i], 'ORI_BID_STATUS') == '2303' || grid.getCellValue(rowIds[i], 'ORI_BID_STATUS') == '2330') {
					return EVF.alert('${SBDR0010_003}');
				}
				if(grid.getCellValue(rowIds[i], 'APPLY_POSSIBLE_FLAG') == 'N') {
					return EVF.alert('${SBDR0010_001}');
				}
				if(grid.getCellValue(rowIds[i], 'APP_INFO') == 'Y') {
					return EVF.alert('${SBDR0010_002}');
				}
				buyerCd = grid.getCellValue(rowIds[i], 'BUYER_CD');
				bidNum = grid.getCellValue(rowIds[i], 'BID_NUM');
				bidCnt = grid.getCellValue(rowIds[i], 'BID_CNT');
			}
			
			var param = {
                BUYER_CD: buyerCd,
				BID_NUM: bidNum,
				BID_CNT: bidCnt,
				VENDOR_CD: "${ses.companyCd}",
				detailView: false,
				popupFlag: true
			};
            var url = '/nhepro/SBDR/SBDI0013/view.so';
            everPopup.openWindowPopup(url, 1200, 700, param, 'openApplyPopup');*/
		}

	</script>
	<e:window id="SBDR0010" initData="${initData}" onReady="init" title="${fullScreenName }" breadCrumbs="${breadCrumb }">
		<e:searchPanel id="form" title="${form_CAPTION_N }" labelWidth="${labelWidth}" width="100%" columnCount="2" useTitleBar="false" onEnter="doSearch">
			<e:inputHidden id="BUYER_CD" name="BUYER_CD"/>
			<e:inputHidden id="BID_NUM"  name="BID_NUM"/>
			<e:inputHidden id="BID_CNT"  name="BID_CNT"/>
			<e:row>
				<e:label for="ANN_DATE_FROM" title="${form_ANN_DATE_FROM_N}"/>
				<e:field>
					<e:inputDate id="ANN_DATE_FROM" name="ANN_DATE_FROM" toDate="ANN_DATE_TO" value="${reqFromDate }" width="${inputDateWidth }" datePicker="true" required="${form_ANN_DATE_FROM_R}" disabled="${form_ANN_DATE_FROM_D}" readOnly="${form_ANN_DATE_FROM_RO}" />
					<e:text>~</e:text>
					<e:inputDate id="ANN_DATE_TO" name="ANN_DATE_TO" fromDate="ANN_DATE_FROM" value="${reqToDate }" width="${inputDateWidth }" datePicker="true" required="${form_ANN_DATE_TO_R}" disabled="${form_ANN_DATE_TO_D}" readOnly="${form_ANN_DATE_TO_RO}" />
				</e:field>
				<e:label for="APP_FLAG" title="${form_APP_FLAG_N}" />
				<e:field>
					<e:select id="APP_FLAG" name="APP_FLAG" value="" options="${appFlagOptions }" width="${form_APP_FLAG_W }" disabled="${form_APP_FLAG_D}" readOnly="${form_APP_FLAG_RO}" required="${form_APP_FLAG_R}" placeHolder="" />
				</e:field>
            </e:row>
			<e:row >
				<e:label for="ANN_NO" title="${form_ANN_NO_N}"/>
				<e:field>
					<e:inputText id="ANN_NO" name="ANN_NO" value="" width="${form_ANN_NO_W}" maxLength="${form_ANN_NO_M}" disabled="${form_ANN_NO_D}" readOnly="${form_ANN_NO_RO}" required="${form_ANN_NO_R}" />
				</e:field>
				<e:label for="ANN_ITEM" title="${form_ANN_ITEM_N}"/>
				<e:field>
					<e:inputText id="ANN_ITEM" name="ANN_ITEM" value="" width="${form_ANN_ITEM_W}" maxLength="${form_ANN_ITEM_M}" disabled="${form_ANN_ITEM_D}" readOnly="${form_ANN_ITEM_RO}" required="${form_ANN_ITEM_R}" />
				</e:field>
			</e:row>
		</e:searchPanel>

		<e:buttonBar id="buttonBar" align="right" width="100%">
			<e:button id="Search" name="Search" label="${Search_N}" disabled="${Search_D}" visible="${Search_V}" onClick="doSearch" />
			<e:button id="Apply" name="Apply" label="${Apply_N}" disabled="${Apply_D}" visible="${Apply_V}" onClick="doApply" />
		</e:buttonBar>

		<e:gridPanel id="grid" name="grid" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}" />

	</e:window>
</e:ui>
