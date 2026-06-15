<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">

	<script type="text/javascript">

	    var grid;
	    var gridI;
		var baseUrl = "/nhepro/CBDR/";

	    function init() {

	        grid = EVF.C("grid");
	        gridI = EVF.C("gridI");
	        grid.cellClickEvent(function(rowIdx, colIdx, value) {

	        	if(colIdx == "EXEC_NUM") {
					var param = {
						'execNum': grid.getCellValue(rowIdx, 'EXEC_NUM'),
						'buyerCd': grid.getCellValue(rowIdx, 'BUYER_CD'),
						'tcoFlag': grid.getCellValue(rowIdx, 'TCO_FLAG'),
						'popupFlag': true,
						'detailView': true
					};
					everPopup.openWindowPopup("/nhepro/CBDR/CBDI0061/view.so", 1400, 800, param, "createCN", true);
				}
	        	
	        	// 2021.03.30 추가
	        	if(colIdx == "EXEC_SUBJECT") {
	        		EVF.V("SCH_BUYER_CD", grid.getCellValue(rowIdx, 'BUYER_CD'));
	        		EVF.V("SCH_EXEC_NUM", grid.getCellValue(rowIdx, 'EXEC_NUM'));
	        		
	        		doSearchDT();
				}
			});
			
	        grid.excelExportEvent({
				allItems : "${excelExport.allCol}",
				fileName : "${screenName }"
			});
			
			grid.setProperty('shrinkToFit', true);		// 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
			grid.setProperty('rowNumbers', ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
			grid.setProperty('sortable', ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
			grid.setProperty('panelVisible', ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
			grid.setProperty('enterToNextRow', ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
			grid.setProperty('acceptZero', ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
			grid.setProperty('singleSelect', ${singleSelect});      // [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]
			grid.setProperty('multiSelect', ${multiSelect});		// [선택] 컬럼의 사용여부를 지정한다. [true/false]
			
			// 2021.03.30 추가
			gridI.cellClickEvent(function(rowIdx, colIdx, value) {

				if(colIdx == "REQ_NUM") {
					if( value == "" ) return;
					var rfxType = gridI.getCellValue(rowIdx, "RFX_TYPE");
					if(rfxType == "BID") {
						var param = {
							'buyerCd': gridI.getCellValue(rowIdx, 'BUYER_CD'),
							'bidNum': gridI.getCellValue(rowIdx, 'REQ_NUM'),
							'bidCnt': gridI.getCellValue(rowIdx, 'REQ_CNT'),
							'baseDataType': "ModifyBID",
							'popupFlag': true,
							'detailView': true
						};
						var callUrl = "/nhepro/CBDI/CBDI0011/view.so";
						everPopup.openWindowPopup(callUrl, 1200, 800, param, "bidDetail", true);
					}
					else {
						var param = {
		                        callbackFunction: "",
		                        BUYER_CD: gridI.getCellValue(rowIdx, "BUYER_CD"),
		                        RFX_NUM: gridI.getCellValue(rowIdx, "REQ_NUM"),
		                        RFX_CNT: gridI.getCellValue(rowIdx, "REQ_CNT"),
		                        detailView: true,
		                        buttonView: false
		                    };
	                    everPopup.openPopupByScreenId("CRQI0011", 1200, 900, param);
	        		}
				}
				if(colIdx == "PR_NUM") {
					if( value == "" ) return;
					var param = {
						prNum: gridI.getCellValue(rowIdx, "PR_NUM"),
						buyerCd : gridI.getCellValue(rowIdx, "PB_BUYER_CD"),
						popupFlag: true,
						detailView : true
					};
					everPopup.openPopupByScreenId("CPRI0010", 1200, 900, param);
				}
				if(colIdx == "BATT_FILE_CNT") {
					if( value == "0" ) return;
					var param = {
						attFileNum: gridI.getCellValue(rowIdx, 'BATT_FILE_NUM'),
						rowIdx: rowIdx,
						callBackFunction: 'setFileAttach',
						bizType: 'BID',
						detailView : true
					};
					everPopup.fileAttachPopup(param);
				}
				if (colIdx == 'BITEM_RMK') {
					if( value == "" ) return;
					var param = {
						title: "구매사 비고",
						message: gridI.getCellValue(rowIdx, 'BITEM_RMK')
					};
					everPopup.commonTextView(param);
				}
				if(colIdx == "SATT_FILE_CNT") {
					if( value == "0" ) return;
					var param = {
						attFileNum: gridI.getCellValue(rowIdx, 'SATT_FILE_NUM'),
						rowIdx: rowIdx,
						callBackFunction: 'setFileAttach',
						bizType: 'SBDI',
						detailView : true
					};
					everPopup.fileAttachPopup(param);
				}
				if (colIdx == 'SITEM_RMK') {
					if( value == "" ) return;
					var param = {
						title: "협력사 비고",
						message: gridI.getCellValue(rowIdx, 'SITEM_RMK')
					};
					everPopup.commonTextView(param);
				}
				if (colIdx == "PRE_CONT_NUM") {
					if( value == "" ) return;
					param = {
							callBackFunction: '',
							BUYER_CD: gridI.getCellValue(rowIdx, "PRE_BUYER_CD"),
							CONT_NUM: value,
							CONT_CNT: gridI.getCellValue(rowIdx, "PRE_CONT_CNT"),
							url: "/nhepro/CCTR/CCTA0030/view.so",
							detailView: true,
							popupFlag: true
						};
					everPopup.openContractChangeInformation(param);
				}
			});
			
			gridI.setProperty('shrinkToFit', ${shrinkToFit});
            gridI.setProperty('rowNumbers', ${rowNumbers});
            gridI.setProperty('sortable', ${sortable});
            gridI.setProperty('panelVisible', ${panelVisible});
            gridI.setProperty('enterToNextRow', ${enterToNextRow});
            gridI.setProperty('acceptZero', ${acceptZero});
            gridI.setProperty('singleSelect', ${singleSelect});
            gridI.setProperty('multiSelect', false);
            
            gridI.setColGroup([
                {
                    "groupName": '용역',
                    "columns": ['SW_BUS_AMT', 'SW_BUS_RATE', 'MNT_SANGJU_YN']
                }
                ,{
                    "groupName": '물품(공사,기타,양수)',
                    "columns": ['CONSUMER_AMT', 'CONSUMER_RATE', 'FC_MNT_TERM', 'CH_RATE']
                }
                ,{
                    "groupName": '유지보수(리스,재리스,렌탈,도급)',
                    "columns": ['DOIB_AMOUNT', 'MNT_RATE', 'MNT_SDAY', 'MNT_EDAY', 'MNT_GUR_MONTH', 'RT_INSP_PERIOD', 'FALT_RC_TG_TIME']
                }
                ,{
                    "groupName": '인터페이스정보(IT포탈)',
                    "columns": ['PRE_CONT_NUM', 'PRE_CONT_CNT', 'CM_REQ_ID', 'IF_TYPE']
                }
            ],50);
            
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
		    grid.setRowFooter("EXEC_AMT", distVal);
		    // ===========================================================
		    
		    // ======================그리드 합계 구하기=======================
		    var val = {"visible": true, "count": 1, "height": 15};
		    gridI.setProperty('footerVisible', val);

		    var footer = {
		          "styles": {
		              "textAlignment": "center",
		              "fontBold": true,
		              "fontFmaily": "Nanum Gothic",
		          },
		          "text": "합   계"
		    };
		    gridI.setRowFooter("PR_BUYER_NM", footer);

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
		    gridI.setRowFooter("PR_QT"  , distVal);
		    gridI.setRowFooter("PR_AMT" , distVal);
		    gridI.setRowFooter("TCO_AMT", distVal);
		    gridI.setRowFooter("CONSUMER_AMT", distVal);
		    gridI.setRowFooter("DOIB_AMOUNT" , distVal);
		    // ===========================================================
		    
			doSearch();
		}

	    function doSearch() {

	    	var store = new EVF.Store();
			if(!store.validate()) { return; }

	        store.setGrid([grid]);
	        store.load(baseUrl + 'cbdr0070_doSearch.so', function() {
	        	if(grid.getRowCount() == 0){
	            	EVF.alert("${msg.M0002 }");
	            }
	        });
	    }
		
	    // 2021.03.30 추가
	    // 품의서별 품목현황 조회
	    function doSearchDT() {

            var store = new EVF.Store();
            store.setGrid([gridI]);
            store.load(baseUrl + 'cbdi0061_doSearchDT.so', function() {
            	
                if(gridI.getRowCount() > 0){
					gridI.setColIconify("BITEM_RMK", "BITEM_RMK", "comment", false);
					gridI.setColIconify("SITEM_RMK", "SITEM_RMK", "comment", false);
					
					var rowIds = gridI.getAllRowId();
					for(var i in rowIds) {

						var prAmt = Number(gridI.getCellValue(rowIds[i], 'PR_AMT'));
						var preUnitPrc = Number(gridI.getCellValue(rowIds[i], 'PRE_UNIT_PRC'));
						var unitPrc = Number(gridI.getCellValue(rowIds[i], 'UNIT_PRC'));
						if(EVF.isNotEmpty(preUnitPrc) && preUnitPrc > 0) {
							gridI.setCellValue(rowIds[i], 'DISCOUNT_RATE', ((preUnitPrc - unitPrc) / preUnitPrc) * 100);
						} else {
							gridI.setCellValue(rowIds[i], 'DISCOUNT_RATE', null);
						}

						var swBusAmt = Number(gridI.getCellValue(rowIds[i], 'SW_BUS_AMT'));
						if(EVF.isNotEmpty(swBusAmt) && swBusAmt > 0 && EVF.isNotEmpty(prAmt) && prAmt > 0) {
							gridI.setCellValue(rowIds[i], 'SW_BUS_RATE', ((swBusAmt - prAmt) / swBusAmt) * 100);
						} else {
							gridI.setCellValue(rowIds[i], 'SW_BUS_RATE', null);
						}

						var consumerAmt = Number(gridI.getCellValue(rowIds[i], 'CONSUMER_AMT'));
						if(EVF.isNotEmpty(consumerAmt) && consumerAmt > 0 && EVF.isNotEmpty(prAmt) && prAmt > 0) {
							gridI.setCellValue(rowIds[i], 'CONSUMER_RATE', ((consumerAmt - prAmt) / consumerAmt) * 100);
						} else {
							gridI.setCellValue(rowIds[i], 'CONSUMER_RATE', null);
						}
					}
                }
            });
        }
	    
	    function doModify() {

			if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
            if (grid.getSelRowCount() > 1) { return EVF.alert("${msg.M0006}"); }

			var execNum = "";
			var buyerCd = "";
			var tcoFlag = "N";
			var rowIds = grid.getSelRowId();
			for(var i in rowIds) {
				if(grid.getCellValue(rowIds[i], 'SIGN_STATUS') == "E") {
					return EVF.alert("${CBDR0070_001}");
				}
				if(grid.getCellValue(rowIds[i], 'SIGN_STATUS') == "P") {
					return EVF.alert("${CBDR0070_002}");
				}
                buyerCd = grid.getCellValue(rowIds[i], 'BUYER_CD');
                execNum = grid.getCellValue(rowIds[i], 'EXEC_NUM');
                tcoFlag = grid.getCellValue(rowIds[i], 'TCO_FLAG');
			}

			EVF.confirm("${CBDR0070_003 }", function () {

                var param = {
                    'execNum' : execNum,
                    'buyerCd' : buyerCd,
                    'tcoFlag': tcoFlag,
                    'popupFlag' : true,
                    'detailView' : false
                };
                everPopup.openWindowPopup("/nhepro/CBDR/CBDI0061/view.so", 1400, 800, param, "createCN", true);
			});
		}

	    function getCtrlUserId() {
        	param = {
					'callBackFunction': 'setCtrlUserInfo',
					'READONLY': 'Y',		//팝업 조회조건 변경불가
					'multiYN' : 'N',        //멀티팝업여부
					'CTRL_CD' : 'BR030',	// 구매담당자권한
					'detailView': false
			};
			everPopup.openPopupByScreenId("CCDU0020", 1100, 700, param);
		}

	    function setCtrlUserInfo(data) {
	    	if(data!=null){
				data = JSON.parse(data);
				EVF.V("CTRL_USER_ID", data.USER_ID);
				EVF.V("CTRL_USER_NM", data.USER_NM);
	    	}
		}

	    function cleanUserId() {
			EVF.V("CTRL_USER_ID", "");
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
			EVF.V("VENDOR_CD", data.VENDOR_CD);
			EVF.V("VENDOR_NM", data.VENDOR_NM);
		}

		function cleanVendorCd() {
			EVF.V("VENDOR_CD", "");
		}
    </script>
	
	<e:window id="CBDR0070" initData="${initData}" onReady="init" title="${fullScreenName }" breadCrumbs="${breadCrumb }">
		<e:searchPanel id="form" title="${form_CAPTION_N }" labelWidth="${labelWidth}" width="100%" columnCount="3" useTitleBar="false" onEnter="doSearch">
			<e:inputHidden id="SCH_BUYER_CD" name="SCH_BUYER_CD"/> <!-- 품의명 클릭시 하단 품목현황 조회 -->
			<e:inputHidden id="SCH_EXEC_NUM" name="SCH_EXEC_NUM"/> <!-- 품의명 클릭시 하단 품목현황 조회 -->
			<e:row>
				<e:label for="EXEC_DATE_FROM" title="${form_EXEC_DATE_FROM_N}" />
				<e:field>
					<e:inputDate id="EXEC_DATE_FROM" name="EXEC_DATE_FROM" toDate="EXEC_DATE_TO" value="${fromDate }" width="${inputDateWidth }" required="${form_EXEC_DATE_FROM_R}" disabled="${form_EXEC_DATE_FROM_D}" readOnly="${form_EXEC_DATE_FROM_RO}" datePicker="true" />
					<e:text>~&nbsp;</e:text>
					<e:inputDate id="EXEC_DATE_TO" name="EXEC_DATE_TO" fromDate="EXEC_DATE_FROM" value="${toDate }" width="${inputDateWidth }" required="${form_EXEC_DATE_TO_R}" disabled="${form_EXEC_DATE_TO_D}" readOnly="${form_EXEC_DATE_TO_RO}" datePicker="true" />
				</e:field>
				<e:label for="BUYER_CD" title="${form_BUYER_CD_N}"/>
				<e:field>
					<e:search id="BUYER_CD" name="BUYER_CD" value="" width="40%" maxLength="${form_BUYER_CD_M}" disabled="${form_BUYER_CD_D}" readOnly="${form_BUYER_CD_RO}" required="${form_BUYER_CD_R}" onIconClick="getBuyerCd" placeHolder="회사코드" />
					<e:inputText id="BUYER_NM" name="BUYER_NM" value="" width="60%" maxLength="${form_BUYER_NM_M}" disabled="${form_BUYER_NM_D}" readOnly="${form_BUYER_NM_RO}" required="${form_BUYER_NM_R}" placeHolder="회사명" />
				</e:field>
				<e:label for="VENDOR_CD" title="${form_VENDOR_CD_N}"/>
				<e:field>
					<e:search id="VENDOR_CD" name="VENDOR_CD" value="" width="40%" maxLength="${form_VENDOR_CD_M}" disabled="${form_VENDOR_CD_D}" readOnly="${form_VENDOR_CD_RO}" required="${form_VENDOR_CD_R}" onIconClick="getVendorCd" placeHolder="회사코드" />
					<e:inputText id="VENDOR_NM" name="VENDOR_NM" value="" width="60%" maxLength="${form_VENDOR_NM_M}" disabled="${form_VENDOR_NM_D}" readOnly="${form_VENDOR_NM_RO}" required="${form_VENDOR_NM_R}" placeHolder="회사명" />
				</e:field>
			</e:row>
			<e:row>
				<e:label for="EXEC_NUM_SUBJECT" title="${form_EXEC_NUM_SUBJECT_N}"/>
				<e:field>
					<e:inputText id="EXEC_NUM_SUBJECT" name="EXEC_NUM_SUBJECT" value="" width="${form_EXEC_NUM_SUBJECT_W}" maxLength="${form_EXEC_NUM_SUBJECT_M}" disabled="${form_EXEC_NUM_SUBJECT_D}" readOnly="${form_EXEC_NUM_SUBJECT_RO}" required="${form_EXEC_NUM_SUBJECT_R}" maskType="${form_EXEC_NUM_SUBJECT_MT}" />
				</e:field>
				<e:label for="EXEC_TYPE" title="${form_EXEC_TYPE_N}" />
				<e:field>
					<e:select id="EXEC_TYPE" name="EXEC_TYPE" value="" options="${execTypeOptions }" width="${form_EXEC_TYPE_W }" disabled="${form_EXEC_TYPE_D}" readOnly="${form_EXEC_TYPE_RO}" required="${form_EXEC_TYPE_R}" placeHolder="" />
				</e:field>
				<e:label for="CTRL_USER_ID" title="${form_CTRL_USER_ID_N}"/>
				<e:field>
					<e:search id="CTRL_USER_ID" name="CTRL_USER_ID" value="" width="40%" maxLength="${form_CTRL_USER_ID_M}" disabled="${form_CTRL_USER_ID_D}" readOnly="${form_CTRL_USER_ID_RO}" required="${form_CTRL_USER_ID_R}" onIconClick="getCtrlUserId" placeHolder="개인번호" />
					<e:inputText id="CTRL_USER_NM" name="CTRL_USER_NM" value="" width="60%" maxLength="${form_CTRL_USER_NM_M}" disabled="${form_CTRL_USER_NM_D}" readOnly="${form_CTRL_USER_NM_RO}" required="${form_CTRL_USER_NM_R}" placeHolder="성명" />
				</e:field>
			</e:row>
			<e:row>
				<e:label for="SIGN_STATUS" title="${form_SIGN_STATUS_N}" />
				<e:field>
					<e:select id="SIGN_STATUS" name="SIGN_STATUS" value="" options="${signStatusOptions }" width="${form_SIGN_STATUS_W }" disabled="${form_SIGN_STATUS_D}" readOnly="${form_SIGN_STATUS_RO}" required="${form_SIGN_STATUS_R}" placeHolder="" />
				</e:field>
				<e:label for="" title=""/>
				<e:field> </e:field>
				<e:label for="" title=""/>
				<e:field> </e:field>
			</e:row>
		</e:searchPanel>

		<e:buttonBar id="buttonBar" align="right" width="100%">
			<e:button id="Search" name="Search" label="${Search_N }" disabled="${Search_D }" visible="${Search_V}" onClick="doSearch" />
			<e:button id="Modify" name="Modify" label="${Modify_N }" disabled="${Modify_D }" visible="${Modify_V}" onClick="doModify" />
		</e:buttonBar>
		<e:gridPanel id="grid" name="grid" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}" />
		
		<%-- 품목 정보 --%>
        <e:buttonBar id="itemBtnBar" align="right" width="100%" title="품목현황" />
		<e:gridPanel id="gridI" name="gridI" width="100%" height="250px" gridType="${_gridType}" readOnly="${param.detailView}" />
	</e:window>
</e:ui>