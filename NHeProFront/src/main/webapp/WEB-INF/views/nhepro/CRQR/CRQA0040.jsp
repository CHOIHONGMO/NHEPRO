<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
    <script type="text/javascript">
        var grid;
        var baseUrl = "/nhepro/CRQR/";

        function init() {
            grid = EVF.C("grid");

            grid.setProperty("shrinkToFit", false);
            grid.setProperty("rowNumbers", ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
            grid.setProperty("sortable", ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
            grid.setProperty("panelVisible", ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            grid.setProperty("enterToNextRow", ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            grid.setProperty("acceptZero", ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            grid.setProperty("singleSelect", true);					// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]

            grid.cellClickEvent(function(rowIdx, colIdx, value) {
                var param;

                if(colIdx == "RFX_NUM") {
                	var param = {
                			callbackFunction: "",
                            BUYER_CD: grid.getCellValue(rowIdx, "BUYER_CD"),
                            RFX_NUM: grid.getCellValue(rowIdx, "RFX_NUM"),
                            RFX_CNT: grid.getCellValue(rowIdx, "RFX_CNT"),
                            detailView: true,
                            buttonView: false
	                    };
                    everPopup.openPopupByScreenId("CRQI0011", 1200, 900, param);
                } else if(colIdx == "JOIN_VENDOR_CNT") {
                    param = {
                    		callbackFunction: "",
                            BUYER_CD: grid.getCellValue(rowIdx, "BUYER_CD"),
                            RFX_NUM: grid.getCellValue(rowIdx, "RFX_NUM"),
                            RFX_CNT: grid.getCellValue(rowIdx, "RFX_CNT"),
                            detailView: true,
                            buttonView: false
                    	};
                    everPopup.openPopupByScreenId("CRQR0031", 1200, 700, param);
                } else if(colIdx == "CTRL_USER_NM") {
                    param = {
	                        callbackFunction: "",
	                        USER_TYPE: grid.getCellValue(rowIdx, "CTRL_USER_TYPE"),
	                        USER_ID: grid.getCellValue(rowIdx, "CTRL_USER_ID"),
	                        detailView: true
	                    };
                    everPopup.openPopupByScreenId("MTUA0011", 600, 190, param);
                }
            });
            
            // 자동조회
            doSearch();
        }
		
        <%-- 구매담당자 조회 팝업 --%>
        function onIconClickCTRL_USER_ID() {
        	param = {
					'callBackFunction': 'callBackCTRL_USER_ID',
					'READONLY': 'Y',		//팝업 조회조건 변경불가
					'multiYN' : 'N',        //멀티팝업여부
					'CTRL_CD' : 'BR030',			// 구매담당자권한
					'detailView': false
			};
			everPopup.openPopupByScreenId("CCDU0020", 1100, 700, param);
        }

        function callBackCTRL_USER_ID(data) {
        	if(data!=null){
				data = JSON.parse(data);
	            EVF.V("CTRL_USER_ID", data.USER_ID);
	            EVF.V("CTRL_USER_NM", data.USER_NM);
        	}
        }

        <%-- 고객사 조회 팝업 --%>
        function onIconClickBUYER_CD() {
            var param = {
                callBackFunction: "callBackBUYER_CD"
            };
            everPopup.openCommonPopup(param, "SP0066");
        }

        function callBackBUYER_CD(data) {
            EVF.V("BUYER_CD", data.CUST_CD);
            EVF.V("BUYER_NM", data.CUST_NM);
        }
		
        <%-- 조회 --%>
        function doSearch() {
            var store = new EVF.Store();
            if(!store.validate()) { return; }
            store.setGrid([grid]);
            store.setParameter("SEL_DATE", $("#SEL_DATE").val());
            store.load(baseUrl + "crqa0040_doSearch.so", function() {
                if(grid.getRowCount() == 0){
                    EVF.alert("${msg.M0002 }");
                } else {
                    grid.setColIconify("FAIL_BID_RMK", "FAIL_BID_RMK", "comment", false);
                }
            });
        }
		
        // 개찰
        function doOpen() {

        	if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

    		var message = '${CRQA0040_008}';
    		var rowIds = grid.getSelRowId();
    		for(var i in rowIds) {
    			if(grid.getCellValue(rowIds[i], 'CTRL_USER_ID') != "${ses.userId}") {
    				return EVF.alert("${msg.M0008}");
    			}
    			// 이미 개찰한 경우
    			if(grid.getCellValue(rowIds[i], 'RFX_OPEN_FLAG') == "1") {
    				return EVF.alert("${CRQA0040_009}");
    			}
    			// 진행상태가 마감인 경우에만 개찰할 수 있음
    			if(grid.getCellValue(rowIds[i], 'PROGRESS_CD') != "2400") {
    				return EVF.alert("${CRQA0040_010}");
    			}
    			// 예가작성이면서 개찰시 예가를 미확정한 경우 개찰할 수 없음
    			if(grid.getCellValue(rowIds[i], 'EST_PRICE_TYPE') == "1" && grid.getCellValue(rowIds[i], 'BID_STATUS') != "1") {
    				return EVF.alert("${CRQA0040_013}");
    			}
    			
    			// 견적서를 제출한 협력사가 존재하지 않는 경우
    			if( eval(grid.getCellValue(rowIds[i], 'SEND_CNT')) == 0 ) {
    				message = "${CRQA0040_006}";
    			}
    			// 견적서를 제출하지 않은 협력사가 존재하는 경우
    			if( eval(grid.getCellValue(rowIds[i], 'TOT_CNT')) - eval(grid.getCellValue(rowIds[i], 'SEND_CNT')) > 0 ) {
    				message = "${CRQA0040_007}";
    			}
    		}
			
        	if (!confirm(message)) return;

            var store = new EVF.Store();
            store.setGrid([grid]);
        	store.getGridData(grid, 'sel');
        	store.load(baseUrl + 'crqa0040_doOpen.so', function(){
        		EVF.alert(this.getResponseMessage());
        		doSearch();
        	});
    	}
        
        // 견적비교
        function doCompareRfq() {

        	if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
        	if (grid.getSelRowCount() > 1) { return EVF.alert('${msg.M0006}'); }
			
        	var message = "";
        	var settleType = "";
        	var buyerCd = "";
        	var rfxNum  = "";
        	var rfxCnt  = "";
        	var rowIds  = grid.getSelRowId();
    		for(var i in rowIds) {
    			// 구매담당자 권한 체크
   				if( grid.getCellValue(rowIds[i], 'CTRL_USER_ID') != "${ses.userId}" ) {
   					return EVF.alert("${msg.M0008}");
   				}
    			// 개찰여부 체크
    			if( grid.getCellValue(rowIds[i], 'RFX_OPEN_FLAG') != '1' ) {
    				return EVF.alert("${CRQA0040_012}");
    			}
    			// 투찰업체가 존재하지 않는 경우
   				if( eval(grid.getCellValue(rowIds[i], 'SEND_CNT')) == 0 ) {
   					message = "${CRQA0040_004}";
    			}
    			// 재견적여부 체크
    			if( eval(grid.getCellValue(rowIds[i], 'NEXT_FLAG')) > 0 ) {
    				return EVF.alert("${CRQA0040_005}");
    			}
    			
    			buyerCd = grid.getCellValue(rowIds[i], 'BUYER_CD');
    			rfxNum  = grid.getCellValue(rowIds[i], 'RFX_NUM');
    			rfxCnt  = grid.getCellValue(rowIds[i], 'RFX_CNT');
    			settleType = grid.getCellValue(rowIds[i], 'SETTLE_TYPE');
    		}
			
    		if( message != "" ) {
        		if( !confirm(message) ) return;
    		}
    		
    		<%-- DOC : 단일업체선정, ITEM : 품목별선정 --%>
    		if (settleType === "DOC") {
                var params = {
                		BUYER_CD: buyerCd,
                		RFX_NUM: rfxNum,
	                	RFX_CNT: rfxCnt,
	                    detailView: false,
	                    popupFlag: true,
	                    callBackFunction: "doSearch"
	                };
                everPopup.openPopupByScreenId("CRQI0041", 1300, 800, params);
            } else {
                var params = {
                		BUYER_CD: buyerCd,
	                	RFX_NUM: rfxNum,
	                	RFX_CNT: rfxCnt,
	                    detailView: false,
	                    popupFlag: true,
	                    callBackFunction: "doSearch"
	                };
                everPopup.openPopupByScreenId("CRQI0042", 1300, 800, params);
            }
        }
        
        function doResultReport() {

			if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
			
			var subject; var docNum; var appDocNum;
			var rowIds = grid.getSelRowId();
			for(var i in rowIds) {
				if(grid.getCellValue(rowIds[i], 'PROGRESS_STATUS') != "1300") {
					return EVF.alert("${CRQA0040_015}");
				}
				if(grid.getCellValue(rowIds[i], 'CTRL_USER_ID') != "${ses.userId}") {
					return EVF.alert("${CRQA0040_016}");
				}
				if(grid.getCellValue(rowIds[i], 'RLT_SIGN_STATUS') == "P") {
					return EVF.alert("${CRQA0040_017}");
				}
				if(grid.getCellValue(rowIds[i], 'RLT_SIGN_STATUS') == "E") {
					return EVF.alert("${CRQA0040_018}");
				}
				subject = "[수의결과보고] " + grid.getCellValue(rowIds[i], 'RFX_SUBJECT');
				docNum = grid.getCellValue(rowIds[i], 'RFX_NUM');
				appDocNum = grid.getCellValue(rowIds[i], 'RLT_APP_DOC_NUM');
			}

			EVF.confirm("${CRQA0040_019 }", function () {
				var param = {
					subject: subject,
					docType: "RFXRLT",
					signStatus: "P",
					screenId: "CRQR0031",
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
			store.load(baseUrl + 'crqa0040_doApproval.so', function(){
				EVF.alert(this.getResponseMessage(), function() {
					doSearch();
				});
			});
		}
        
    </script>

    <e:window id="CRQA0040" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">
        <e:inputHidden id="CONFIRM_REASON" name="CONFIRM_REASON"/>

        <e:searchPanel id="sp" title="${form_CAPTION_N}" labelWidth="${labelWidth}" useTitleBar="false" width="100%" columnCount="3" onEnter="doSearch">
            <e:row>
                <e:label for="" title="">
                    <select class="custom-select" id="SEL_DATE" name="SEL_DATE">
                        <option value="END" selected>${CRQA0040_001}</option>
                        <option value="STR">${CRQA0040_002}</option>
                        <!--
                        <option value="REQ">${CRQA0040_003}</option>
                        -->
                    </select>
                </e:label>
                <e:field>
                    <e:inputDate id="FROM_DATE" name="FROM_DATE" toDate="TO_DATE" value="${FROM_DATE}" width="${inputDateWidth}" datePicker="true" required="${form_FROM_DATE_R}" disabled="${form_FROM_DATE_D}" readOnly="${form_FROM_DATE_RO}" />
                    <e:text> ~ </e:text>
                    <e:inputDate id="TO_DATE" name="TO_DATE" fromDate="FROM_DATE" value="${TO_DATE}" width="${inputDateWidth}" datePicker="true" required="${form_TO_DATE_R}" disabled="${form_TO_DATE_D}" readOnly="${form_TO_DATE_RO}" />
                </e:field>
                <e:label for="BUYER_CD" title="${form_BUYER_CD_N}"/>
                <e:field>
                    <e:search id="BUYER_CD" name="BUYER_CD" value="" width="40%" maxLength="${form_BUYER_CD_M}" onIconClick="${form_BUYER_CD_RO ? 'everCommon.blank' : 'onIconClickBUYER_CD'}" disabled="${form_BUYER_CD_D}" readOnly="${form_BUYER_CD_RO}" required="${form_BUYER_CD_R}" maskType="${form_BUYER_CD_MT}" placeHolder="회사코드" />
                    <e:inputText id="BUYER_NM" name="BUYER_NM" value="" width="60%" maxLength="${form_BUYER_NM_M}" disabled="${form_BUYER_NM_D}" readOnly="${form_BUYER_NM_RO}" required="${form_BUYER_NM_R}" style="${imeMode}" maskType="${form_BUYER_NM_MT}" placeHolder="회사명"/>
                </e:field>
                <e:label for="CTRL_USER_ID" title="${form_CTRL_USER_ID_N}"/>
                <e:field>
                    <e:search id="CTRL_USER_ID" name="CTRL_USER_ID" value="${ses.userId}" width="40%" maxLength="${form_CTRL_USER_ID_M}" onIconClick="${form_CTRL_USER_ID_RO ? 'everCommon.blank' : 'onIconClickCTRL_USER_ID'}" disabled="${form_CTRL_USER_ID_D}" readOnly="${form_CTRL_USER_ID_RO}" required="${form_CTRL_USER_ID_R}" maskType="${form_CTRL_USER_ID_MT}" placeHolder="개인번호" />
                    <e:inputText id="CTRL_USER_NM" name="CTRL_USER_NM" value="${ses.userNm}" width="60%" maxLength="${form_CTRL_USER_NM_M}" disabled="${form_CTRL_USER_NM_D}" readOnly="${form_CTRL_USER_NM_RO}" required="${form_CTRL_USER_NM_R}" style="${imeMode}" maskType="${form_CTRL_USER_NM_MT}" placeHolder="성명"/>
                </e:field>
            </e:row>
            <e:row>
                <e:label for="RFX_NUM" title="${form_RFX_NUM_N}" />
                <e:field>
                    <e:inputText id="RFX_NUM" name="RFX_NUM" value="" width="${form_RFX_NUM_W}" maxLength="${form_RFX_NUM_M}" disabled="${form_RFX_NUM_D}" readOnly="${form_RFX_NUM_RO}" required="${form_RFX_NUM_R}" style="${imeMode}" maskType="${form_RFX_NUM_MT}"/>
                </e:field>
                <e:label for="PROGRESS_CD" title="${form_PROGRESS_CD_N}"/>
                <e:field>
                    <e:select id="PROGRESS_CD" name="PROGRESS_CD" value="2400" options="${progressCdOptions}" width="${form_PROGRESS_CD_W}" disabled="${form_PROGRESS_CD_D}" readOnly="${form_PROGRESS_CD_RO}" required="${form_PROGRESS_CD_R}" placeHolder="" maskType="${form_PROGRESS_CD_MT}" />
                </e:field>
                <e:label for="" title=""/>
                <e:field>
                </e:field>
            </e:row>
        </e:searchPanel>

        <e:buttonBar width="100%" align="right">
            <e:button id="doSearch" name="doSearch" label="${doSearch_N}" onClick="doSearch" disabled="${doSearch_D}" visible="${doSearch_V}"/>
            <e:button id="doOpen" name="doOpen" label="${doOpen_N}" onClick="doOpen" disabled="${doOpen_D}" visible="${doOpen_V}"/>
            <e:button id="doCompareRfq" name="doCompareRfq" label="${doCompareRfq_N}" onClick="doCompareRfq" disabled="${doCompareRfq_D}" visible="${doCompareRfq_V}"/>
            <e:button id="ResultReport" name="ResultReport" label="${ResultReport_N }" disabled="${ResultReport_D }" visible="${ResultReport_V}" onClick="doResultReport" />
        </e:buttonBar>

        <e:gridPanel id="grid" name="grid" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}" />
    </e:window>
</e:ui>
