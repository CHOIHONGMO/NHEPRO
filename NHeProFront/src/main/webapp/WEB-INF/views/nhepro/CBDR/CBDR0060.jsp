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

	        	// 2021.05.18 추가
				// 동일한 이전계약번호, 이전계약차수는 한꺼번에 선택되도록 한다.
				if(colIdx == "multiSelect") {
					if( grid.getCellValue(rowIdx, 'PRE_CONT_NUM') != '' ) {
						if(value == "1") {
	                        grid.checkEqualRow(["PRE_CONT_NUM", "PRE_CONT_CNT"], [grid.getCellValue(rowIdx, "PRE_CONT_NUM"), grid.getCellValue(rowIdx, "PRE_CONT_CNT")]);
	                    } else {
	                        grid.checkNotEqualRow(["PRE_CONT_NUM", "PRE_CONT_CNT"], [grid.getCellValue(rowIdx, "PRE_CONT_NUM"), grid.getCellValue(rowIdx, "PRE_CONT_CNT")]);
	                    }
					}
				}
	        	if(colIdx == "REQ_NUM") {
	        		if( value == "" ) return;
	        	    if(grid.getCellValue(rowIdx, 'RFX_TYPE') == "BID") {
                        var param = {
                            'buyerCd'      : grid.getCellValue(rowIdx, 'BUYER_CD'),
                            'bidNum'       : grid.getCellValue(rowIdx, 'REQ_NUM'),
                            'bidCnt'       : grid.getCellValue(rowIdx, 'REQ_CNT'),
                            'baseDataType' : "ModifyBID",
                            'popupFlag'    : true,
                            'detailView'   : true
                        };
                        var callUrl = "/nhepro/CBDI/CBDI0011/view.so";
                        everPopup.openWindowPopup(callUrl, 1300, 800, param, "bidDetail", true);
                    }
	        	    else {
						var param = {
		                        callbackFunction: "",
		                        BUYER_CD: grid.getCellValue(rowIdx, "BUYER_CD"),
		                        RFX_NUM: grid.getCellValue(rowIdx, "REQ_NUM"),
		                        RFX_CNT: grid.getCellValue(rowIdx, "REQ_CNT"),
		                        detailView: true,
		                        buttonView: false
		                    };
	                    everPopup.openPopupByScreenId("CRQI0011", 1200, 900, param);
	        		}
				}
                if (colIdx == "PR_NUM") {
                	if( value == "" ) return;
                    var param = {
                        prNum: grid.getCellValue(rowIdx, "PR_NUM"),
                        buyerCd : grid.getCellValue(rowIdx, "PB_BUYER_CD"),
                        popupFlag: true,
                        detailView : true
                    };
                    everPopup.openPopupByScreenId("CPRI0010", 1200, 900, param);
                }
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
                /** 2021.04.28 제외
                 * 협력사에서 제출한 견적 및 입찰서는 조회할 수 없음
                if(colIdx == "QTA_NUM") {
					if (grid.getCellValue(rowIdx, 'RFX_TYPE') == 'BID') {
						var param = {
							buyerCd: grid.getCellValue(rowIdx, 'BUYER_CD'),
							bidNum: grid.getCellValue(rowIdx, 'REQ_NUM'),
							bidCnt : grid.getCellValue(rowIdx, 'REQ_CNT'),
							voteCnt : grid.getCellValue(rowIdx, 'VOTE_CNT'),
							vendorCd : grid.getCellValue(rowIdx, 'VENDOR_CD'),
							detailView: true,
							popupFlag: true
						};
						var url = '/nhepro/SBDR/SBDI0021/view.so';
						everPopup.openWindowPopup(url, 1200, 800, param, 'sendBidDocumentPopup');
					}
					else {
						if (grid.getCellValue(rowIdx, 'QTA_NUM') == '') return;
						var param = {
							BUYER_CD: grid.getCellValue(rowIdx, 'BUYER_CD'),
							RFX_NUM: '',
							RFX_CNT: '',
							QTA_NUM: grid.getCellValue(rowIdx, 'QTA_NUM'),
							RFX_TYPE: '',
							VENDOR_CD: grid.getCellValue(rowIdx, 'VENDOR_CD'),
							detailView: true,
							popupFlag: true
						};
						everPopup.openPopupByScreenId("SRQI0011", 1200, 900, param);
					}
    			}*/
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
			grid.setProperty('singleSelect', ${singleSelect});      // [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]
			grid.setProperty('multiSelect', ${multiSelect});		// [선택] 컬럼의 사용여부를 지정한다. [true/false]
			
			grid.setColGroup([
				{
                    "groupName": '입찰 및 견적정보',
                    "columns": ['VENDOR_CD', 'VENDOR_NM', 'BID_QT', 'UNIT_CD', 'PR_QT', 'PR_AMT', 'TCO_YEAR_CNT', 'TCO_AMT', 'CUR', 'VAT_TYPE', 'ADJ_PRC_STATUS', 'QTA_NUM', 'VOTE_DATE', 'SETTLE_DATE']
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
		    grid.setRowFooter("PR_QT", distVal);
		    grid.setRowFooter("PR_AMT", distVal);
		    grid.setRowFooter("TCO_AMT", distVal);
		    // ===========================================================
		    	
		    doSearch();
		}

	    function doSearch() {

	    	var store = new EVF.Store();
			if(!store.validate()) { return; }

	        store.setGrid([grid]);
	        store.load(baseUrl + 'cbdr0060_doSearch.so', function() {
	        	if(grid.getRowCount() == 0){
	            	EVF.alert("${msg.M0002 }");
	            }
	        });
	    }

		function doPrcConfirm() {

			if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
			
			var cnt = 0;
			var rowIds = grid.getSelRowId();
			for(var i in rowIds) {
				if(grid.getCellValue(rowIds[i], 'ADJ_PRC_STATUS') != "200") {
					return EVF.alert("${CBDR0060_009}");
				}
				if(grid.getCellValue(rowIds[i], 'VEND_QT_FLAG') == '1') {
					cnt++;
				}
			}
			
			var msg = "";
			if(cnt > 0) {
				msg = "<< 협력사에서 '투찰수량'을 변경한 품목이 존재합니다 >>\n\n"
			}
			
			EVF.confirm(msg + "${CBDR0060_010 }", function () {
				var store = new EVF.Store();
				store.setGrid([grid]);
				store.getGridData(grid, 'sel');
				store.doFileUpload(function() {
					store.load(baseUrl + 'cbdr0060_doPrcConfirm.so', function() {
						EVF.alert(this.getResponseMessage(), function() {
							doSearch();
						});
					});
				});
			});
		}

		function doPrcReject() {

            if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

            var rowIds = grid.getSelRowId();
            for(var i in rowIds) {
                if(grid.getCellValue(rowIds[i], 'ADJ_PRC_STATUS') != "200") {
                    return EVF.alert("${CBDR0060_012}");
                }
            }
            EVF.confirm("${CBDR0060_013 }", function () {
				var store = new EVF.Store();
                store.setGrid([grid]);
                store.getGridData(grid, 'sel');
                store.doFileUpload(function() {
                    store.load(baseUrl + 'cbdr0060_doPrcReject.so', function() {
                        EVF.alert(this.getResponseMessage(), function() {
                            doSearch();
                        });
                    });
                });
            });
		}

	    function doRegEX() {

			if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
			var rowIds = grid.getSelRowId();
			var sCur = grid.getCellValue(rowIds[0], 'CUR');
			var sVat = grid.getCellValue(rowIds[0], 'VAT_TYPE');
			var sPrType = grid.getCellValue(rowIds[0], 'PR_TYPE');
			var sBuyerCd = grid.getCellValue(rowIds[0], 'PRE_BUYER_CD');
			var sContNum = grid.getCellValue(rowIds[0], 'PRE_CONT_NUM');
			var sContCnt = grid.getCellValue(rowIds[0], 'PRE_CONT_CNT');
			var sContType = grid.getCellValue(rowIds[0], 'CONT_TYPE');
			
			for(var i in rowIds) {
				// 입찰인 경우 단가확정 이후 품의서 작성가능
				if(grid.getCellValue(rowIds[i], 'RFX_TYPE') == "BID" && grid.getCellValue(rowIds[i], 'ADJ_PRC_STATUS') != "400") {
					return EVF.alert("${CBDR0060_015}");
				}
				// 동일한 통화에 대해 품의서 작성가능
				if( sCur != grid.getCellValue(rowIds[i], 'CUR') ) {
					return EVF.alert("${CBDR0060_007}");
				}
				// 동일한 부가세구분에 대해 품의서 작성가능
				if( sVat != grid.getCellValue(rowIds[i], 'VAT_TYPE') ) {
					return EVF.alert("${CBDR0060_008}");
				}
				
				// 계약구분이 신규가 아닌경우에는 이전계약번호, 차수, 고객사코드등 체크
				if(grid.getCellValue(rowIds[i], 'PR_TYPE') != "10"){
					// 동일한 이전계약고객코드, 이전계약번호, 이전계약차수에 대해 품의서 작성가능
					if( sPrType  != grid.getCellValue(rowIds[i], 'PR_TYPE')      || sBuyerCd != grid.getCellValue(rowIds[i], 'PRE_BUYER_CD')
					 || sContNum != grid.getCellValue(rowIds[i], 'PRE_CONT_NUM') || sContCnt != grid.getCellValue(rowIds[i], 'PRE_CONT_CNT') )
					{
						return EVF.alert("이전계약이 존재하는 경우 동일한 [계약구분 및 이전계약번호, 차수]로만 품의서를 작성할 수 있습니다.");
					}
				}
			}
			
			EVF.confirm("${CBDR0060_006 }", function () {

				var paramExecWtNum = "";
				var paramSubject = "";
				var tcoFlag = "N";
				for(var i in rowIds) {
					paramExecWtNum = paramExecWtNum + grid.getCellValue(rowIds[i], 'EXEC_WT_NUM') + "@@";
					paramSubject = grid.getCellValue(rowIds[i], 'SUBJECT');
					if(grid.getCellValue(rowIds[i], 'TCO_FLAG') == "1") {
						tcoFlag = "Y";
					}
				}

				var param = {
					'paramExecWtNum' : paramExecWtNum,
					'paramSubject': paramSubject,
					'paramCur': sCur,
					'paramVatType': sVat,
					'tcoFlag': tcoFlag,
					'contType' : sContType,
					'popupFlag' : true,
					'detailView' : false
				};
				everPopup.openWindowPopup("/nhepro/CBDR/CBDI0061/view.so", 1400, 800, param, "createCN", true);
			});
		}

		function doCancelSettle() {
			
			if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
			
			var oriRowId = grid.getSelRowId()[0];
			var rowIds = grid.getSelRowId();
			var selectedRowIdx = [];
			var sPrType = grid.getCellValue(rowIds[0], 'PR_TYPE');
			var req_num = grid.getCellValue(oriRowId, "REQ_NUM");
			var req_cnt = grid.getCellValue(oriRowId, "REQ_CNT");
			
			for (var i in rowIds) {
				var rowIdx = rowIds[i];
				
				if( req_num != "" && (req_num != grid.getCellValue(rowIdx, "REQ_NUM") || req_cnt != grid.getCellValue(rowIdx, "REQ_CNT")) ) {
					return EVF.alert("동일한 '요청번호'로 선정취소 가능합니다.\n확인하여 주시기 바랍니다.");
				}
			}
			
            if (sPrType == '10') {
				if (grid.getSelRowCount() > 1) { return EVF.alert("${CBDR0060_005}"); }
			}
            
            if (sPrType == '20') {
            	selectedRowIdx.push(rowIds[0]);
	            grid.checkAll(false);
	            
	            for(var i=0; i < selectedRowIdx.length; i++) {
	                grid.checkRow(selectedRowIdx[i], true, false, false);
	            }
            }
            
            EVF.confirm("${CBDR0060_002 }", function () {
				EVF.confirm("${CBDR0060_017 }", function () {
					var store = new EVF.Store();
					store.setGrid([grid]);
					store.getGridData(grid, 'sel');
					store.load(baseUrl + 'cbdr0060_doCancelSettle.so', function(){
						EVF.alert(this.getResponseMessage(), function() {
							doSearch();
						});
					});
				});
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
	<e:window id="CBDR0060" initData="${initData}" onReady="init" title="${fullScreenName }" breadCrumbs="${breadCrumb }">
		<e:searchPanel id="form" title="${form_CAPTION_N }" labelWidth="${labelWidth}" width="100%" columnCount="3" useTitleBar="false" onEnter="doSearch">
			<e:row>
				<e:label for="END_DATE_FROM" title="${form_END_DATE_FROM_N}" />
				<e:field>
					<e:inputDate id="END_DATE_FROM" name="END_DATE_FROM" toDate="END_DATE_TO" value="${fromDate }" width="${inputDateWidth }" required="${form_END_DATE_FROM_R}" disabled="${form_END_DATE_FROM_D}" readOnly="${form_END_DATE_FROM_RO}" datePicker="true" />
					<e:text>~&nbsp;</e:text>
					<e:inputDate id="END_DATE_TO" name="END_DATE_TO" fromDate="END_DATE_FROM" value="${toDate }" width="${inputDateWidth }" required="${form_END_DATE_TO_R}" disabled="${form_END_DATE_TO_D}" readOnly="${form_END_DATE_TO_RO}" datePicker="true" />
				</e:field>
				<e:label for="BUYER_CD" title="${form_BUYER_CD_N}"/>
				<e:field>
					<e:search id="BUYER_CD" name="BUYER_CD" value="" width="40%" maxLength="${form_BUYER_CD_M}" disabled="${form_BUYER_CD_D}" readOnly="${form_BUYER_CD_RO}" required="${form_BUYER_CD_R}" onIconClick="getBuyerCd" placeHolder="회사코드" />
					<e:inputText id="BUYER_NM" name="BUYER_NM" value="" width="60%" maxLength="${form_BUYER_NM_M}" disabled="${form_BUYER_NM_D}" readOnly="${form_BUYER_NM_RO}" required="${form_BUYER_NM_R}" placeHolder="회사명" />
				</e:field>
                <e:label for="REQ_NUM" title="${form_REQ_NUM_N}"/>
                <e:field>
                    <e:inputText id="REQ_NUM" name="REQ_NUM" value="" width="36%" maxLength="${form_REQ_NUM_M}" disabled="${form_REQ_NUM_D}" readOnly="${form_REQ_NUM_RO}" required="${form_REQ_NUM_R}" maskType="${form_REQ_NUM_MT}" />
                    <e:text>/</e:text>
                    <e:inputText id="SUBJECT" name="SUBJECT" value="" width="60%" maxLength="${form_SUBJECT_M}" disabled="${form_SUBJECT_D}" readOnly="${form_SUBJECT_RO}" required="${form_SUBJECT_R}" maskType="${form_SUBJECT_MT}" />
                </e:field>
			</e:row>
			<e:row>
				<e:label for="CTRL_USER_ID" title="${form_CTRL_USER_ID_N}"/>
				<e:field>
					<e:search id="CTRL_USER_ID" name="CTRL_USER_ID" value="" width="40%" maxLength="${form_CTRL_USER_ID_M}" disabled="${form_CTRL_USER_ID_D}" readOnly="${form_CTRL_USER_ID_RO}" required="${form_CTRL_USER_ID_R}" onIconClick="getCtrlUserId" placeHolder="개인번호" />
					<e:inputText id="CTRL_USER_NM" name="CTRL_USER_NM" value="" width="60%" maxLength="${form_CTRL_USER_NM_M}" disabled="${form_CTRL_USER_NM_D}" readOnly="${form_CTRL_USER_NM_RO}" required="${form_CTRL_USER_NM_R}" placeHolder="성명" />
				</e:field>
				<e:label for="VENDOR_CD" title="${form_VENDOR_CD_N}"/>
				<e:field>
					<e:search id="VENDOR_CD" name="VENDOR_CD" value="" width="40%" maxLength="${form_VENDOR_CD_M}" disabled="${form_VENDOR_CD_D}" readOnly="${form_VENDOR_CD_RO}" required="${form_VENDOR_CD_R}" onIconClick="getVendorCd" placeHolder="회사코드" />
					<e:inputText id="VENDOR_NM" name="VENDOR_NM" value="" width="60%" maxLength="${form_VENDOR_NM_M}" disabled="${form_VENDOR_NM_D}" readOnly="${form_VENDOR_NM_RO}" required="${form_VENDOR_NM_R}" placeHolder="회사명" />
				</e:field>
                <e:label for="PR_NUM" title="${form_PR_NUM_N}"/>
                <e:field>
                    <e:inputText id="PR_NUM" name="PR_NUM" value="" width="36%" maxLength="${form_PR_NUM_M}" disabled="${form_PR_NUM_D}" readOnly="${form_PR_NUM_RO}" required="${form_PR_NUM_R}" maskType="${form_PR_NUM_MT}" />
                    <e:text>/</e:text>
                    <e:inputText id="PR_SUBJECT" name="PR_SUBJECT" value="" width="60%" maxLength="${form_PR_SUBJECT_M}" disabled="${form_PR_SUBJECT_D}" readOnly="${form_PR_SUBJECT_RO}" required="${form_PR_SUBJECT_R}" maskType="${form_PR_SUBJECT_MT}" />
                </e:field>
			</e:row>
		</e:searchPanel>

		<e:buttonBar id="buttonBar" align="right" width="100%">
			<e:button id="Search" name="Search" label="${Search_N }" disabled="${Search_D }" visible="${Search_V}" onClick="doSearch" />
			<e:button id="PrcConfirm" name="PrcConfirm" label="${PrcConfirm_N }" disabled="${PrcConfirm_D }" visible="${PrcConfirm_V}" onClick="doPrcConfirm" />
			<e:button id="PrcReject" name="PrcReject" label="${PrcReject_N }" disabled="${PrcReject_D }" visible="${PrcReject_V}" onClick="doPrcReject" />
			<e:button id="RegEX" name="RegEX" label="${RegEX_N }" disabled="${RegEX_D }" visible="${RegEX_V}" onClick="doRegEX" />
			<e:button id="CancelSettle" name="CancelSettle" label="${CancelSettle_N }" disabled="${CancelSettle_D }" visible="${CancelSettle_V}" onClick="doCancelSettle" />
		</e:buttonBar>

		<e:gridPanel id="grid" name="grid" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}" />

	</e:window>
</e:ui>