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
		var type    = "${param.type}".substr(0, 1);
		
	    function init() {
	        grid = EVF.C("grid");

	        grid.cellClickEvent(function(rowIdx, colIdx, value) {

    	    	var bidNum = ""; var bidCnt = ""; var buyerCd = ""; var estmType = ""; var bidStatus = "";
	    		bidNum = grid.getCellValue(rowIdx, 'BID_NUM');
	    		bidCnt = grid.getCellValue(rowIdx, 'BID_CNT');
	    		buyerCd = grid.getCellValue(rowIdx, 'BUYER_CD');
	    		estmType = grid.getCellValue(rowIdx, 'ESTM_TYPE');
	    		bidStatus2 = grid.getCellValue(rowIdx, 'BID_STATUS2');

	        	if(colIdx == "ANN_NO") {
	        		var rfxType = grid.getCellValue(rowIdx, 'RFX_TYPE');
	        		if( rfxType == "BID" ) {
						var param = {
								'buyerCd': grid.getCellValue(rowIdx, 'BUYER_CD'),
								'bidNum': grid.getCellValue(rowIdx, 'BID_NUM'),
								'bidCnt': grid.getCellValue(rowIdx, 'BID_CNT'),
								'baseDataType': "ViewBID",
								'popupFlag': true,
								'detailView': true
							};
						everPopup.openWindowPopup("/nhepro/CBDI/CBDI0011/view.so", 1300, 800, param, "regBidNotice", true);
	        		}
	        		else {
						var param = {
		                        callbackFunction: "",
		                        BUYER_CD: grid.getCellValue(rowIdx, "BUYER_CD"),
		                        RFX_NUM: grid.getCellValue(rowIdx, "BID_NUM"),
		                        RFX_CNT: grid.getCellValue(rowIdx, "BID_CNT"),
		                        detailView: true,
		                        buttonView: false
		                    };
	                    everPopup.openPopupByScreenId("CRQI0011", 1200, 900, param);
	        		}
	        	}

	        	if(colIdx == "BID_USER_NM") {
					
	        		if(grid.getCellValue(rowIdx, 'SIGN_STATUS') == "") {
	        			return EVF.alert("예정가격이 작성되지 않았습니다.");
	        		}
	        		// 2021.02.16 구매담당자(BR030) 권한만 예가 조회하도록 함
	        		if ("${ses.ctrlCd}".indexOf("BR030") < 0 || grid.getCellValue(rowIdx, 'BID_USER_ID') != "${ses.userId}") {
        				return EVF.alert("${CBDR0050_011}");
        			}
		    		var param = {
						  BID_NUM  : bidNum
						, BID_CNT  : bidCnt
						, BUYER_CD : buyerCd
						,'detailView':true
		  			};
		  			everPopup.openPopupByScreenId('CBDI0051', 1000, 800, param);
	        	}
	        	if(colIdx == "ESTM_USER_NM") {
	        		
	        		// 유찰(1300), 업체선정완료(2500)
				    if(bidStatus2 != '1300' && bidStatus2 != '2500' ) {
				    	return EVF.alert("${CBDR0050_012}");
				    }
	        		
	        		// 2021.02.16 구매담당자(BR030) 권한 및 예가결정권자만 예가 조회하도록 함
				    if("${ses.ctrlCd}".indexOf("BR030") < 0 && grid.getCellValue(rowIdx, 'ESTM_USER_ID') != "${ses.userId}") {	
        				return EVF.alert("${CBDR0050_011}");
        			}
	        		var param = {
						  BID_NUM  : bidNum
						, BID_CNT  : bidCnt
						, BUYER_CD : buyerCd
						,'detailView':true
		  			};
		  			var screenId = '';
		  			if (estmType == 'SE') {
		  				screenId = 'CBDI0052';
		  				everPopup.openPopupByScreenId(screenId, 1000, 300, param);
		  			} else {
		  				screenId = 'CBDI0053';
		  				everPopup.openPopupByScreenId(screenId, 1000, 500, param);
		  			}
	        	}
	        	if(colIdx == "SIGN_STATUS") {

					if(grid.getCellValue(rowIdx, 'SIGN_STATUS') == "") {
						return;
					}
					var param = {
						 BID_NUM  : bidNum
						,BID_CNT  : bidCnt
						,BUYER_CD : buyerCd
						,'detailView' : true
					};
					everPopup.openPopupByScreenId('CBDI0051', 1000, 800, param);
	        	}
	        	// 2022.03.31 그리드 결재문서번호 추가하여 예가 결재상신 시 의견 볼수 있도록 추가
	        	// 업무담당자(BR900)권한자만 조회가능
	        	if(colIdx === 'APP_DOC_NUM'){
	        		
	        		if ("${ses.ctrlCd}".indexOf("${ManagerCd}") < 0) {
	        			return EVF.alert("${CBDR0050_015}");
	        		}
	        		
		            var params = {
		                gateCd    : grid.getCellValue(rowIdx, "GATE_CD"),
		                buyerCd   : grid.getCellValue(rowIdx, "BUYER_CD"),
		                appDocNum : grid.getCellValue(rowIdx, "APP_DOC_NUM"),
		                appDocCnt : grid.getCellValue(rowIdx, "APP_DOC_CNT"),
		                docType   : 'ESTM',
		                signStatus: grid.getCellValue(rowIdx, "SIGN_STATUS"),
		                authType  : 'VIEW',
		                sendBox	  : false,
                        detailView : true
		            };
		            everPopup.openApprovalOrRejectPopup(params);
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

			// 제출상태
	        EVF.C('RFX_TYPE').removeOption('RFI');

	        // 확정상태
			EVF.V('BID_STATUS', '0');
			
			// 2021.12.27 TO_DO LIST 나의 예정가격 미확정현황 건수 클릭 시 화면이동 후 본인 건의 예가 미확정건 조회를 위해
	        if(type == 'A'){
	        	EVF.V('ESTM_USER_ID', '${ses.userId}');
	        	EVF.V('ESTM_USER_NM', '${ses.userNm}');
	        }
	        
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
	        store.load(baseUrl + 'cbdr0050_doSearch.so', function() {
	        	if(grid.getRowCount() == 0){
	            	EVF.alert("${msg.M0002 }");
	            }
	        });
	    }

	    function doChangeCtrl() {

			if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

			if(EVF.isEmpty(EVF.C("CTRL_USER_ID").getValue())) {
                return EVF.alert("${CBDR0050_001}");
            }

			var rowIds = grid.getSelRowId();
	    	for(var i in rowIds) {
	    		if(grid.getCellValue(rowIds[i], 'SIGN_STATUS') == "P"
	    		|| grid.getCellValue(rowIds[i], 'SIGN_STATUS') == "E"
	    		) {
    				return EVF.alert("${CBDR0050_002}");
    			}
	    		
	    		// 2021.02.08 중앙회 요청 "관리자직무"를 갖는 사람은 담당자 변경 가능하도록 추가
	    		if(!changeFlag) {
		    		if(grid.getCellValue(rowIds[i], 'ESTM_USER_ID') != "${ses.userId}") {
	    				return EVF.alert("${CBDR0050_005}");
	    			}
	    		}
	    		
				/**
				 * 2021.01.14 기능 변경
				 * 견적(수의시담)도 예가 결정권자 변경 가능하도록 함
	    		if(grid.getCellValue(rowIds[i], 'TYPE') == "견적") {
    				return EVF.alert("${CBDR0050_006}");
    			}*/
    		}

			EVF.confirm("${CBDR0050_003 }", function () {
				var store = new EVF.Store();
				store.setGrid([grid]);
	            store.getGridData(grid, 'sel');
	            store.setParameter("CTRL_USER_ID", EVF.C("CTRL_USER_ID").getValue());
	            store.load(baseUrl + 'cbdr0050_doChangeCtrl.so', function(){
	        		EVF.alert(this.getResponseMessage(), function() {
	        			doSearch();
					});
	        	});
			});
		}

	    function getBidUserId() {

			var callBackType = this.getData().data;
			var param = {
					'callBackFunction': "setBidUserId",
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

	    function getEstmUserId() {

			var callBackType = this.getData().data;
			var param = {
					'callBackFunction': (callBackType == "S" ? "setEstmUserId" : "setCtrlUserId"),
					'READONLY': 'Y',		//팝업 조회조건 변경불가
					'multiYN' : 'N',        //멀티팝업여부
					'CTRL_CD' : '',			//예가담당자는 권한 없음
					'detailView': false
			};
			everPopup.openPopupByScreenId("CCDU0020", 1100, 700, param);
		}

	    function setEstmUserId(data) {
	    	if(data!=null){
				data = JSON.parse(data);
				EVF.V("ESTM_USER_ID", data.USER_ID);
				EVF.V("ESTM_USER_NM", data.USER_NM);
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

		function IfUnitPrcSign() {

	    	if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

	    	if (grid.getSelRowCount() > 1 ) { return EVF.alert("${msg.M0006}"); }

	    	var bidNum = ""; var bidCnt = ""; var buyerCd = "";
	    	var rowIds = grid.getSelRowId();
	    	for(var i in rowIds) {
	    		bidNum = grid.getCellValue(rowIds[i], 'BID_NUM');
	    		bidCnt = grid.getCellValue(rowIds[i], 'BID_CNT');
	    		buyerCd = grid.getCellValue(rowIds[i], 'BUYER_CD');
	    		
	    		if(grid.getCellValue(rowIds[i], 'BID_STATUS2') == "1300") {
    				return EVF.alert("${CBDR0050_014}");
    			}
	    		
	    		if (grid.getCellValue(rowIds[i], 'SIGN_STATUS') =='P'
	    		||grid.getCellValue(rowIds[i], 'SIGN_STATUS') =='E'
	    		) {
	    			return EVF.alert("${CBDR0050_007}");
	    		}
	    		
	    		if(grid.getCellValue(rowIds[i], 'BID_USER_ID') != "${ses.userId}") {
    				return EVF.alert("${CBDR0050_011}");
    			}
    		}
			var param = {
				  BID_NUM  : bidNum
				, BID_CNT  : bidCnt
				, BUYER_CD : buyerCd
				,'detailView':false
			};
			everPopup.openPopupByScreenId('CBDI0051', 1100, 800, param);
		}

		function IfUnitPrcReg() {

	    	if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

	    	if (grid.getSelRowCount() > 1 ) { return EVF.alert("${msg.M0006}"); }

	    	var bidNum = ""; var bidCnt = ""; var buyerCd = ""; var estmType = "";
	    	var rowIds = grid.getSelRowId();
	    	for(var i in rowIds) {
	    		bidNum = grid.getCellValue(rowIds[i], 'BID_NUM');
	    		bidCnt = grid.getCellValue(rowIds[i], 'BID_CNT');
	    		buyerCd = grid.getCellValue(rowIds[i], 'BUYER_CD');
	    		estmType = grid.getCellValue(rowIds[i], 'ESTM_TYPE');

	    		if (grid.getCellValue(rowIds[i], 'CONT_TYPE2' ) == 'QE') {
	    			if (grid.getCellValue(rowIds[i], 'SIGN_STATUS') == '') {
	    				if(grid.getCellValue(rowIds[i], 'BID_STATUS2') == "1300") {
	    					return EVF.alert("${CBDR0050_014}");
	    				} else {
			    			if (!confirm('${CBDR0050_013}')) {
			    				return;
			    			}
	    				}
	    			}
	    		} else {
		    		if (grid.getCellValue(rowIds[i], 'SIGN_STATUS')!='E') {
		    			return EVF.alert("${CBDR0050_008}");
		    		}
	    		}
	    		if (grid.getCellValue(rowIds[i], 'BID_STATUS_LOC')=='1') {
	    			return EVF.alert("${CBDR0050_009}");
	    		}
	    		if(grid.getCellValue(rowIds[i], 'ESTM_USER_ID') != "${ses.userId}") {
    				return EVF.alert("${CBDR0050_011}");
    			}
	    	}

			var param = {
				  BID_NUM  : bidNum
				, BID_CNT  : bidCnt
				, BUYER_CD : buyerCd
				,'detailView':false
			};
			var screenId = '';
			if (estmType == 'SE') {
				screenId = 'CBDI0052';
				everPopup.openPopupByScreenId(screenId, 1000, 400, param);
			} else {
				screenId = 'CBDI0053';
				everPopup.openPopupByScreenId(screenId, 1000, 490, param);
			}
		}

    </script>
	<e:window id="CBDR0050" initData="${initData}" onReady="init" title="${fullScreenName }" breadCrumbs="${breadCrumb }">
		<e:searchPanel id="form" title="${form_CAPTION_N }" labelWidth="${labelWidth}" width="100%" columnCount="3" useTitleBar="false" onEnter="doSearch">
			<e:inputHidden id="TYPE" name="TYPE" value="${param.TYPE}" />
			<e:row>
				<e:label for="ANN_DATE_FROM" title="${form_ANN_DATE_FROM_N}" />
				<e:field>
					<e:inputDate id="ANN_DATE_FROM" name="ANN_DATE_FROM" toDate="ANN_DATE_TO" value="${reqFromDate }" width="${inputDateWidth }" required="${form_ANN_DATE_FROM_R}" disabled="${form_ANN_DATE_FROM_D}" readOnly="${form_ANN_DATE_FROM_RO}" datePicker="true" />
					<e:text>~&nbsp;</e:text>
					<e:inputDate id="ANN_DATE_TO" name="ANN_DATE_TO" fromDate="ANN_DATE_FROM" value="${reqToDate }" width="${inputDateWidth }" required="${form_ANN_DATE_TO_R}" disabled="${form_ANN_DATE_TO_D}" readOnly="${form_ANN_DATE_TO_RO}" datePicker="true" />
				</e:field>
				<e:label for="SIGN_STATUS" title="${form_SIGN_STATUS_N}"/>
				<e:field>
					<e:select id="SIGN_STATUS" name="SIGN_STATUS" value="" options="${signStatusOptions}" width="${form_SIGN_STATUS_W}" disabled="${form_SIGN_STATUS_D}" readOnly="${form_SIGN_STATUS_RO}" required="${form_SIGN_STATUS_R}" placeHolder="" maskType="${form_SIGN_STATUS_MT}" />
				</e:field>
				<e:label for="BID_STATUS" title="${form_BID_STATUS_N}" />
				<e:field>
					<e:select id="BID_STATUS" name="BID_STATUS" value="" options="${bidStatusOptions }" width="${form_BID_STATUS_W }" disabled="${form_BID_STATUS_D}" readOnly="${form_BID_STATUS_RO}" required="${form_BID_STATUS_R}" placeHolder="" />
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
				<e:label for="BID_USER_ID" title="${form_BID_USER_ID_N}"/>
				<e:field>
					<e:search id="BID_USER_ID" name="BID_USER_ID" value="" width="40%" maxLength="${form_BID_USER_ID_M}" disabled="${form_BID_USER_ID_D}" readOnly="${form_BID_USER_ID_RO}" required="${form_BID_USER_ID_R}" onIconClick="getBidUserId" placeHolder="개인번호" />
					<e:inputText id="BID_USER_NM" name="BID_USER_NM" value="" width="60%" maxLength="${form_BID_USER_NM_M}" disabled="${form_BID_USER_NM_D}" readOnly="${form_BID_USER_NM_RO}" required="${form_BID_USER_NM_R}" placeHolder="성명" />
				</e:field>
				<e:label for="ESTM_USER_ID" title="${form_ESTM_USER_ID_N}"/>
				<e:field>
					<e:search id="ESTM_USER_ID" name="ESTM_USER_ID" value="${userId }" width="40%" maxLength="${form_ESTM_USER_ID_M}" onIconClick="getEstmUserId" data="S" disabled="${form_ESTM_USER_ID_D}" readOnly="${form_ESTM_USER_ID_RO}" required="${form_ESTM_USER_ID_R}" maskType="${form_ESTM_USER_ID_MT}" placeHolder="개인번호" />
					<e:inputText id="ESTM_USER_NM" name="ESTM_USER_NM" value="${userNm }" width="60%" maxLength="${form_ESTM_USER_NM_M}" disabled="${form_ESTM_USER_NM_D}" readOnly="${form_ESTM_USER_NM_RO}" required="${form_ESTM_USER_NM_R}" style="${imeMode}" maskType="${form_ESTM_USER_NM_MT}" placeHolder="성명"/>
				</e:field>
				<e:label for="RFX_TYPE" title="${form_RFX_TYPE_N}"/>
				<e:field>
					<e:select id="RFX_TYPE" name="RFX_TYPE" value="" options="${rfxTypeOptions}" width="${form_RFX_TYPE_W}" disabled="${form_RFX_TYPE_D}" readOnly="${form_RFX_TYPE_RO}" required="${form_RFX_TYPE_R}" placeHolder="" maskType="${form_RFX_TYPE_MT}" />
				</e:field>
			</e:row>
		</e:searchPanel>

		<e:buttonBar id="buttonBar" align="right" width="100%">
			<e:text style="color: blue;font-weight: bold;">■ 예가 결정권자 : </e:text>
			<e:search id="CTRL_USER_NM" name="CTRL_USER_NM" value="" width="${form_CTRL_USER_NM_W}" maxLength="${form_CTRL_USER_NM_M}" disabled="${form_CTRL_USER_NM_D}" readOnly="${form_CTRL_USER_NM_RO}" required="${form_CTRL_USER_NM_R}" align="left" onIconClick="getEstmUserId" data="I" />
			<e:inputHidden id="CTRL_USER_ID" name="CTRL_USER_ID" value="" />
			
			<e:button id="ChangeCtrl" name="ChangeCtrl" label="${ChangeCtrl_N }" disabled="${ChangeCtrl_D }" visible="${ChangeCtrl_V}" style="padding-left:3px;" align="left" onClick="doChangeCtrl" />
			<e:button id="Search" name="Search" label="${Search_N }" disabled="${Search_D }" visible="${Search_V}" onClick="doSearch" />
			<e:button id="IfUnitPrcSign" name="IfUnitPrcSign" label="${IfUnitPrcSign_N}" onClick="IfUnitPrcSign" disabled="${IfUnitPrcSign_D}" visible="${IfUnitPrcSign_V}"/>
			<e:button id="IfUnitPrcReg" name="IfUnitPrcReg" label="${IfUnitPrcReg_N}" onClick="IfUnitPrcReg" disabled="${IfUnitPrcReg_D}" visible="${IfUnitPrcReg_V}"/>
		</e:buttonBar>

		<e:gridPanel id="grid" name="grid" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}" />

	</e:window>
</e:ui>