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
        var baseUrl = "/nhepro/CRQR/";
        var CTRL_CD = "${CTRL_CD}";
        var changeFlag = false;

        function init() {
            grid = EVF.C("grid");

            grid.setProperty("shrinkToFit", false);
            grid.setProperty("rowNumbers", ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
            grid.setProperty("sortable", ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
            grid.setProperty("panelVisible", ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            grid.setProperty("enterToNextRow", ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            grid.setProperty("acceptZero", ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            grid.setProperty("multiSelect", true);					// [선택] 컬럼의 사용여부를 지정한다. [true/false]
            grid.setProperty("singleSelect", false);				// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]

            grid.cellClickEvent(function(rowIdx, colIdx, value) {
            	
                var param;
                if(colIdx == "RFX_NUM") {
                	if( value == "" ) return;
                    param = {
	                        callbackFunction: "",
	                        BUYER_CD: grid.getCellValue(rowIdx, "BUYER_CD"),
	                        RFX_NUM: value,
	                        RFX_CNT: grid.getCellValue(rowIdx, "RFX_CNT"),
	                        detailView: true,
	                        popupFlag: true
	                    };
                    everPopup.openPopupByScreenId("CRQI0011", 1200, 900, param);
                }
                else if(colIdx == "JOIN_VENDOR_CNT") {
                    param = {
                    		callbackFunction: "",
                            BUYER_CD: grid.getCellValue(rowIdx, "BUYER_CD"),
                            RFX_NUM: grid.getCellValue(rowIdx, "RFX_NUM"),
                            RFX_CNT: grid.getCellValue(rowIdx, "RFX_CNT"),
                            detailView: true
                    	};
                    everPopup.openPopupByScreenId("CRQR0031", 1200, 600, param);
                }
                else if(colIdx == "CTRL_USER_NM") {
                    param = {
	                        callbackFunction: "",
	                        USER_TYPE: grid.getCellValue(rowIdx, "CTRL_USER_TYPE"),
	                        USER_ID: grid.getCellValue(rowIdx, "CTRL_USER_ID"),
	                        detailView: true
	                    };
                    everPopup.openPopupByScreenId("MTUA0011", 600, 190, param);
                }
                else if(colIdx == "FORCE_CLOSE_RMK") {
                	if( value == "" ) return;
                    param = {
	                        title: "${CRQR0010_CAPTION01}",
	                        message: grid.getCellValue(rowIdx, 'FORCE_CLOSE_RMK'),
	                        detailView: true
	                    };
                    everPopup.commonTextInput(param);
                }
                else if(colIdx == "FAIL_BID_RMK") {
                	if( value == "" ) return;
                    param = {
                            title: "${CRQR0010_CAPTION02}",
                            message: grid.getCellValue(rowIdx, 'FAIL_BID_RMK'),
                            detailView: true
                        };
                    everPopup.commonTextInput(param);
                }
                else if(colIdx == "PERIOD_MOD_RSN") {
                	if( value == "" ) return;
                    param = {
                            title: "${CRQR0010_CAPTION03}",
                            message: grid.getCellValue(rowIdx, 'PERIOD_MOD_RSN'),
                            detailView: true
                        };
                    everPopup.AppcommonTextInput(param);
                }
            });
			
            // 구매담당자권한(BR030)
            if("BR030" != CTRL_CD) {
                EVF.C("doUpdateChange").setDisabled(true);
                EVF.C("doForceClosing").setDisabled(true);
            } else {
                EVF.C("doUpdateChange").setDisabled(false);
                EVF.C("doForceClosing").setDisabled(false);
            }
            
        	// 2021.02.08 중앙회 요청 "관리자직무"를 갖는 사람은 담당자 변경 가능하도록 추가
		    if ("${ses.ctrlCd}".indexOf("${ManagerCd}") > -1) {
		    	changeFlag = true;
            }
         	
        	//2022.09.05 진행상태 기본값 세팅
		    setType();
            // 2020.12.02 자동조회 추가
            doSearch();
        }
		
        function setType() {
			setProgressCdOption();	// 진행상태 기본값 세팅
		}
        
        function setProgressCdOption(){
        	var proNm = "";
        	
        	$('input[name=multiselect_PROGRESS_CD]').each(function (k, v) {
				if( v.value == "2300" || v.value == "2350" ) {
					proNm += v.title + ", ";
					v.checked = true;
				} else if(v.value == '') {
					$(v).parent().remove();
				}
						
			});
			$("#PROGRESS_CD").next().find("span, .e-select-text").text(proNm.substr(0, proNm.length - 2)); 
        }
        
        function doSearch() {
            var store = new EVF.Store();
            if(!store.validate()) { return; }
            store.setGrid([grid]);
            store.setParameter("SEL_DATE", $("#SEL_DATE").val());
            store.load(baseUrl + "crqr0010_doSearch.so", function() {
                if(grid.getRowCount() == 0){
                    EVF.alert("${msg.M0002 }");
                }
				else {
                	grid.setColIconify("FAIL_BID_RMK", "FAIL_BID_RMK", "comment", false);
                    grid.setColIconify("FORCE_CLOSE_RMK", "FORCE_CLOSE_RMK", "comment", false);
                    grid.setColIconify("PERIOD_MOD_RSN", "PERIOD_MOD_RSN", "comment", false);
                }
            });
        }
		
        // 견적수정
        function doUpdatePop() {
        	
            if(grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
            if (grid.getSelRowCount() > 1) { return EVF.alert("${msg.M0006}"); }
			
            var selRowValue = grid.getSelRowValue();
            var BUYER_CD = selRowValue[0].BUYER_CD;
            var RFX_NUM = selRowValue[0].RFX_NUM;
            var RFX_CNT = selRowValue[0].RFX_CNT;
            var PROGRESS_CD = selRowValue[0].PROGRESS_CD;
            var CTRL_USER_ID = selRowValue[0].CTRL_USER_ID;
            var SIGN_STATUS = selRowValue[0].SIGN_STATUS;
			
            // 작성중이 아니거나 결재중, 결재완료일 경우 수정 안됨
            if( PROGRESS_CD != '2300' || SIGN_STATUS == "P" || SIGN_STATUS == "E" ) {
                return EVF.alert("${CRQR0010_005}");
            }
			
            // 본인의 것만 수정 가능
            if("${ses.userId}" != CTRL_USER_ID) {
                return EVF.alert("${msg.M0008}");
            }

            var param = {
                callbackFunction: "",
                BUYER_CD: BUYER_CD,
                RFX_NUM: RFX_NUM,
                RFX_CNT: RFX_CNT,
                PROGRESS_CD: PROGRESS_CD,
                detailView: false,
                popupFlag: true
            };
            everPopup.openPopupByScreenId("CRQI0011", 1200, 900, param);
        }
		
        // 강제마감
        function doForceClosing() {
        	
            if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
            if (grid.getSelRowCount() > 1) { return EVF.alert("${msg.M0006}"); }
            
            var selRowId = grid.getSelRowId();
            var rowIdx = selRowId[0];
			
            // 자신의 업무만 처리 가능
            if("${ses.userId}" != grid.getCellValue(rowIdx, "CTRL_USER_ID")) {
            	return EVF.alert("${msg.M0008}");
            }
            
			// 진행중인 건만 강제마감 가능
            if(grid.getCellValue(rowIdx, "PROGRESS_CD") != "2350") {
            	return EVF.alert("${CRQR0010_010}");
            }

            var param = {
                title: "${CRQR0010_011}",
                message: grid.getCellValue(rowIdx, "FORCE_CLOSE_RMK"),
                callbackFunction: "callbackForceClosing",
                rowIdx: rowIdx
            };

            everPopup.commonTextInput(param);
        }
        
        // 강제마감 Callback
        function callbackForceClosing(data) {
            if(data.message == "") {
                EVF.alert("${CRQR0010_013}");
                doSearch();
            } else {
                grid.setCellValue(data.rowIdx, "FORCE_CLOSE_RMK", data.message);
                EVF.confirm("${CRQR0010_012}", function () {
                    var store = new EVF.Store();
                    store.setGrid([grid]);
                    store.getGridData(grid, "sel");
                    store.load(baseUrl + "crqr0010_doForceClosing.so", function() {
                        EVF.alert(this.getResponseMessage());
                        doSearch();
                    });
                });
            }
        }
        
        // 2021.01.04 기능 분리 및 추가
     	// 협력사 전송
        function doSendVendor() {
        	
        	if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
        	
            var selRowId = grid.getSelRowId();
            for(var i in selRowId) {
                var rowIdx = selRowId[i];
                
             	// 자신의 업무만 처리 가능
                if("${ses.userId}" != grid.getCellValue(rowIdx, "CTRL_USER_ID")) {
                	return EVF.alert("${msg.M0008}");
                }
    			// 결재상태=E, 진행상태=작성중인 건만 전송 가능
                if( grid.getCellValue(rowIdx, "SIGN_STATUS") != 'E' || grid.getCellValue(rowIdx, "PROGRESS_CD") != "2300" ) {
                	return EVF.alert("${CRQR0010_014}");
                }
            }
            
            EVF.confirm("${CRQR0010_015}", function () {
                var store = new EVF.Store();
                store.setGrid([grid]);
                store.getGridData(grid, "sel");
                store.load(baseUrl + "crqr0010_doSendVendor.so", function() {
                    EVF.alert(this.getResponseMessage());
                    doSearch();
                });
            });
        }
		
        // 구매담당자변경
        function doUpdateChange() {
            if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

            var selRowValue = grid.getSelRowValue();
            for(var i in selRowValue) {
            	if(!changeFlag) {
	                var data = selRowValue[i];
	                
	                if("${ses.userId}" != data.CTRL_USER_ID) {
	                	return EVF.alert("${CRQR0010_007}");
	                }
            	}
            }
            
            if(EVF.V("CTRL_USER_CH_ID") == "") {
                return EVF.alert("${CRQR0010_008}");
            }

            EVF.confirm("${CRQR0010_009}", function () {
                var store = new EVF.Store();
                store.setGrid([grid]);
                store.getGridData(grid, "sel");
                store.load(baseUrl + "crqr0010_doUpdateChange.so", function() {
                    EVF.alert(this.getResponseMessage());
                    doSearch();
                });
            });
        }
        
     	// 2021.06.29 견적시간변경 기능 추가
		function doChageRfxTime() {
     		
			if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
            if (grid.getSelRowCount() > 1) { return EVF.alert("${msg.M0006}"); }
            
            var selRowId = grid.getSelRowId();
            var rowIdx = selRowId[0];
			
            var BUYER_CD = grid.getCellValue(rowIdx, "BUYER_CD");
            var RFX_NUM = grid.getCellValue(rowIdx, "RFX_NUM");
            var RFX_CNT = grid.getCellValue(rowIdx, "RFX_CNT");
            var PROGRESS_CD = grid.getCellValue(rowIdx, "PROGRESS_CD");
            var CTRL_USER_ID = grid.getCellValue(rowIdx, "CTRL_USER_ID"); 
            var PERIOD_MOD_RSN = grid.getCellValue(rowIdx, "PERIOD_MOD_RSN"); 
            
            if("${hasManagerCd}" != 'true' ) {
            	return EVF.alert("${CRQR0010_017}");
            }
            
            if(PROGRESS_CD != "2350") {
            	return EVF.alert("${CRQR0010_018}");
            }
			
            if(PERIOD_MOD_RSN != "") {
            	return EVF.alert("${CRQR0010_016}");
            }
			
            var param = {
                    callbackFunction: "",
                    BUYER_CD: BUYER_CD,
                    RFX_NUM: RFX_NUM,
                    RFX_CNT: RFX_CNT,
                    PROGRESS_CD: PROGRESS_CD,
                    detailView: false,
                };
                everPopup.openPopupByScreenId("CRQI0012", 1050, 630, param);
		}
        
		// 구매담당자 조회
        function onIconClickCTRL_USER_ID() {
        	var param = {
					'callBackFunction': 'callBackCTRL_USER_ID',
					'READONLY': 'Y',		//팝업 조회조건 변경불가
					'multiYN' : 'N',        //멀티팝업여부
					'CTRL_CD' : 'BR030',	// 구매담당자권한
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
		
        // 고객사 조회
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
		
        // 구매담당자 변경 조회
        function onIconClickCTRL_USER_CH_NM() {
        	var param = {
					'callBackFunction': 'callBackCTRL_USER_CH_NM',
					'READONLY': 'Y',		//팝업 조회조건 변경불가
					'multiYN' : 'N',        //멀티팝업여부
					'CTRL_CD' : 'BR030',	// 구매담당자권한
					'detailView': false
			};
			everPopup.openPopupByScreenId("CCDU0020", 1100, 700, param);
        }

        function callBackCTRL_USER_CH_NM(data) {
        	if(data!=null){
				data = JSON.parse(data);
	            EVF.V("CTRL_USER_CH_ID", data.USER_ID);
	            EVF.V("CTRL_USER_CH_NM", data.USER_NM);
        	}
        }

    </script>

    <e:window id="CRQR0010" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">
        <e:inputHidden id="CONFIRM_REASON" name="CONFIRM_REASON"/>

        <e:searchPanel id="sp" title="${form_CAPTION_N}" labelWidth="${labelWidth}" useTitleBar="false" width="100%" columnCount="3" onEnter="doSearch">
            <e:row>
                <e:label for="" title="">
                    <select class="custom-select" id="SEL_DATE" name="SEL_DATE">
                        <option value="END" selected>${CRQR0010_001}</option>
                        <option value="STR">${CRQR0010_002}</option>
                        <!--
                        <option value="REQ">${CRQR0010_003}</option>
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
                <e:label for="RFX_NUM" title="${form_RFX_NUM_N}" />
                <e:field>
                    <e:inputText id="RFX_NUM" name="RFX_NUM" value="" width="${form_RFX_NUM_W}" maxLength="${form_RFX_NUM_M}" disabled="${form_RFX_NUM_D}" readOnly="${form_RFX_NUM_RO}" required="${form_RFX_NUM_R}" style="${imeMode}" maskType="${form_RFX_NUM_MT}"/>
                </e:field>
            </e:row>
            <e:row>
                <e:label for="CTRL_USER_ID" title="${form_CTRL_USER_ID_N}"/>
                <e:field>
                    <e:search id="CTRL_USER_ID" name="CTRL_USER_ID" value="${CTRL_USER_ID}" width="40%" maxLength="${form_CTRL_USER_ID_M}" onIconClick="${form_CTRL_USER_ID_RO ? 'everCommon.blank' : 'onIconClickCTRL_USER_ID'}" disabled="${form_CTRL_USER_ID_D}" readOnly="${form_CTRL_USER_ID_RO}" required="${form_CTRL_USER_ID_R}" maskType="${form_CTRL_USER_ID_MT}" placeHolder="개인번호" />
                    <e:inputText id="CTRL_USER_NM" name="CTRL_USER_NM" value="${CTRL_USER_NM}" width="60%" maxLength="${form_CTRL_USER_NM_M}" disabled="${form_CTRL_USER_NM_D}" readOnly="${form_CTRL_USER_NM_RO}" required="${form_CTRL_USER_NM_R}" style="${imeMode}" maskType="${form_CTRL_USER_NM_MT}" placeHolder="성명"/>
                </e:field>
                <e:label for="PROGRESS_CD" title="${form_PROGRESS_CD_N}"/>
                <e:field>
                    <e:select id="PROGRESS_CD" name="PROGRESS_CD" value="" options="${progressCdOptions}" width="${form_PROGRESS_CD_W}" disabled="${form_PROGRESS_CD_D}" readOnly="${form_PROGRESS_CD_RO}" required="${form_PROGRESS_CD_R}" placeHolder="" maskType="${form_PROGRESS_CD_MT}" useMultipleSelect="true" />
                </e:field>
                <e:label for="SIGN_STATUS" title="${form_SIGN_STATUS_N}"/>
				<e:field>
					<e:select id="SIGN_STATUS" name="SIGN_STATUS" value="" options="${signStatusOptions}" width="${form_SIGN_STATUS_W}" disabled="${form_SIGN_STATUS_D}" readOnly="${form_SIGN_STATUS_RO}" required="${form_SIGN_STATUS_R}" placeHolder="" maskType="${form_SIGN_STATUS_MT}" />
				</e:field>
            </e:row>
        </e:searchPanel>

        <e:buttonBar width="100%" align="right">
        	<e:text style="color: blue;font-weight: bold;">■ ${form_CTRL_USER_CH_ID_N} : </e:text>
            <e:field>
            	<e:inputHidden id="CTRL_USER_CH_ID" name="CTRL_USER_CH_ID"/>
				<e:search id="CTRL_USER_CH_NM" name="CTRL_USER_CH_NM" value="" width="${form_CTRL_USER_CH_NM_W}" maxLength="${form_CTRL_USER_CH_NM_M}" onIconClick="onIconClickCTRL_USER_CH_NM" disabled="${form_CTRL_USER_CH_NM_D}" readOnly="${form_CTRL_USER_CH_NM_RO}" required="${form_CTRL_USER_CH_NM_R}" maskType="${form_CTRL_USER_CH_NM_MT}" />
            </e:field>
            <e:text> </e:text>
            <e:button id="doUpdateChange" name="doUpdateChange" align="left" label="${doUpdateChange_N}" onClick="doUpdateChange" disabled="${doUpdateChange_D}" visible="${doUpdateChange_V}"/>
            
            <e:button id="doSearch" name="doSearch" label="${doSearch_N}" onClick="doSearch" disabled="${doSearch_D}" visible="${doSearch_V}"/>
            <e:button id="doUpdatePop" name="doUpdatePop" label="${doUpdatePop_N}" onClick="doUpdatePop" disabled="${doUpdatePop_D}" visible="${doUpdatePop_V}"/>
            <e:button id="doSendVendor" name="doSendVendor" label="${doSendVendor_N}" onClick="doSendVendor" disabled="${doSendVendor_D}" visible="${doSendVendor_V}"/>
            <c:if test="${hasManagerCd eq true}">
            	<e:button id="doChageRfxTime" name="doChageRfxTime" label="${doChageRfxTime_N }" disabled="${doChageRfxTime_D }" visible="${doChageRfxTime_V}" onClick="doChageRfxTime" />
            </c:if>
            <e:button id="doForceClosing" name="doForceClosing" label="${doForceClosing_N}" onClick="doForceClosing" disabled="${doForceClosing_D}" visible="${doForceClosing_V}"/>
        </e:buttonBar>

        <e:gridPanel id="grid" name="grid" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}" />
    </e:window>
</e:ui>
