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
        var baseUrl = "/nhepro/CPOI/";
        var CTRL_CD = "${CTRL_CD}";
        var changeFlag = false;
        var havePermission = ("${havePermission}" == "true");
        
        function init() {
            grid = EVF.C("grid");

            grid.setProperty("shrinkToFit", ${shrinkToFit});
            grid.setProperty("rowNumbers", ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
            grid.setProperty("sortable", ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
            grid.setProperty("panelVisible", ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            grid.setProperty("enterToNextRow", ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            grid.setProperty("acceptZero", ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            grid.setProperty("multiSelect", ${param.detailView == true ? false : multiSelect});					// [선택] 컬럼의 사용여부를 지정한다. [true/false]
            grid.setProperty("singleSelect", ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]

            grid.cellClickEvent(function(rowIdx, colIdx, value) {
                var param;
                if(colIdx == "PO_NUM") {
                    param = {
                        callbackFunction: "",
                        PO_NUM: value,
                        BUYER_CD: grid.getCellValue(rowIdx, "BUYER_CD"),
                        detailView: true,
                        buttonView: false
                    };
                    everPopup.openPopupByScreenId("CPOI0010", 1270, 750, param);
                }
                else if(colIdx == "VENDOR_CD") {
                    param = {
                        VENDOR_CD: value,
                        detailView: true,
                        popupFlag: true,
                        buttonView: false
                    };
                    everPopup.openPopupByScreenId("CVNR0011", 1000, 730, param);
                }
                else if(colIdx == "VENDOR_REJECT_RMK") {
                    param = {
                        title: "${CPOR0020_011}",
                        message: grid.getCellValue(rowIdx, 'VENDOR_REJECT_RMK'),
                        detailView: true
                    };
                    everPopup.commonTextInput(param);
                }
                else if(colIdx == "VENDOR_RECEIPT_USER_NM") {
                    param = {
                        callbackFunction: "",
                        USER_TYPE: grid.getCellValue(rowIdx, "VENDOR_RECEIPT_USER_TYPE"),
                        USER_ID: grid.getCellValue(rowIdx, "VENDOR_RECEIPT_USER_ID"),
                        detailView: true
                    };
                    everPopup.openPopupByScreenId("MTUA0011", 600, 190, param);
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
                else if(colIdx == "INSPECT_USER_NM") {
                    param = {
                        callbackFunction: "",
                        USER_TYPE: grid.getCellValue(rowIdx, "INSPECT_USER_TYPE"),
                        USER_ID: grid.getCellValue(rowIdx, "INSPECT_USER_ID"),
                        detailView: true
                    };
                    everPopup.openPopupByScreenId("MTUA0011", 600, 190, param);
                }
                else if(colIdx == "FORCE_CLOSE_RMK") {
                    param = {
                        title: "${CPOR0020_008}",
                        message: grid.getCellValue(rowIdx, 'FORCE_CLOSE_RMK'),
                        detailView: true
                    };
                    everPopup.commonTextInput(param);
                }
                else if(colIdx == "CONT_NUM") {
                	if( value == "" ) return;
                    param = {
                        callbackFunction: "",
                        url: '/nhepro/CCTR/CCTA0030/view.so',
                        CONT_NUM: value,
                        CONT_CNT: grid.getCellValue(rowIdx, "CONT_CNT"),
                        BUYER_CD: grid.getCellValue(rowIdx, "BUYER_CD"),
                        detailView: true,
                        buttonView: false
                    };
                    everPopup.openContractChangeInformation(param);
                }
            });
            
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
		    grid.setRowFooter("PR_BUYER_DEPT_NM", footer);

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
		    grid.setRowFooter("PO_AMT", distVal);
		    grid.setRowFooter("PR_AMT", distVal);
		    
		 	// 2021.02.08 중앙회 요청 추가
		 	// "관리자직무"를 갖는 사람은 담당자 변경 가능하도록 추가
		    if ("${ses.ctrlCd}".indexOf("${ManagerCd}") > -1) {
		    	changeFlag = true;
            }
		 	
		 	// 2021.03.18 : 관리자직무, 구매담당자인 경우 구매담당자, 검수담당자 변경 가능
           	if(changeFlag || "${ses.ctrlCd}".indexOf("BR030") > -1) {
                EVF.C("doUpdateChange").setDisabled(false);
                EVF.C("doUpdateChangeINV").setDisabled(false);
                EVF.C("doUpdate").setDisabled(false);
                EVF.C("doClosing").setDisabled(false);
            } else {
            	// 2021.04.19 : 검수담당자 권한 => 고객사 기본권한으로 변경
            	if("${ses.ctrlCd}".indexOf("BR020") > -1) {
                    EVF.C("doUpdateChangeINV").setDisabled(false);
            	} else {
            		EVF.C("doUpdateChangeINV").setDisabled(true);
            	}
           		EVF.C("doUpdateChange").setDisabled(true);
           		EVF.C("doUpdate").setDisabled(true);
                EVF.C("doClosing").setDisabled(true);
            }
            
		    //2021.04.19 추가
            // 구매담당자, 계약담당자, 관리자직무인 경우 검수담당자 조회조건 변경이 가능함
            if( !havePermission ) {
            	EVF.C("CTRL_USER_ID").setValue("");
            	EVF.C("CTRL_USER_NM").setValue("");
            	EVF.C("INSPECT_USER_ID").setValue("${ses.userId}");
            	EVF.C("INSPECT_USER_NM").setValue("${ses.userNm}");
            	
            	EVF.C("INSPECT_USER_ID").setReadOnly(true);
            	EVF.C("INSPECT_USER_ID").setDisabled(true);
            	EVF.C("INSPECT_USER_NM").setReadOnly(true);
            }
          	
            // 체결 및 의뢰고객사 조회조건
            EVF.C("SEL_BUYER").removeOption("PY");
            EVF.V("SEL_BUYER", "PO");
			
		    // 2020.12.02 자동조회 추가
		    doSearch();
        }

        function onIconClickVENDOR_CD() {
            var param = {
                callBackFunction: "callBackVENDOR_CD",
                BUYER_CD: "${ses.companyCd}"
            };
            everPopup.openCommonPopup(param, "SP0123");
        }

        function callBackVENDOR_CD(data) {
            EVF.V("VENDOR_CD", data.VENDOR_CD);
            EVF.V("VENDOR_NM", data.VENDOR_NM);
        }

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
		
        // 검수담당자 조회조건 추가
        function onIconClickINSPECT_USER_ID() {
        	var param = {
					'callBackFunction': 'callBackINSPECT_USER_NM',
					'READONLY': 'N',		//팝업 조회조건 변경불가
					'multiYN' : 'N',        //멀티팝업여부
					'CTRL_CD' : 'BR020',	//검수/입고 담당자권한(=기본권한으로 변경)
					'detailView': false
			};
			everPopup.openPopupByScreenId("CCDU0020", 1100, 700, param);
        }

        function callBackINSPECT_USER_NM(data) {
        	if(data!=null){
				data = JSON.parse(data);
	            EVF.V("INSPECT_USER_ID", data.USER_ID);
	            EVF.V("INSPECT_USER_NM", data.USER_NM);
        	}
        }
        
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

        function onIconClickCTRL_USER_CH_ID() {
        	var param = {
					'callBackFunction': 'callBackCTRL_USER_CH_ID',
					'READONLY': 'Y',		//팝업 조회조건 변경불가
					'multiYN' : 'N',        //멀티팝업여부
					'CTRL_CD' : 'BR030',	// 구매담당자권한
					'detailView': false
			};
			everPopup.openPopupByScreenId("CCDU0020", 1100, 700, param);
        }

        function callBackCTRL_USER_CH_ID(data) {
        	if(data!=null){
				data = JSON.parse(data);
	            EVF.V("CTRL_USER_CH_ID", data.USER_ID);
	            EVF.V("CTRL_USER_CH_NM", data.USER_NM);
        	}
        }
        
        // 검수담당자 변경기능 추가
        function onIconClickPIC_USER_NM() {
        	var param = {
					'callBackFunction': 'callBackPIC_USER_NM',
					'READONLY': 'N',		//팝업 조회조건 변경불가
					'multiYN' : 'N',        //멀티팝업여부
					'CTRL_CD' : 'BR020',	//검수/입고 담당자권한(=기본권한으로 변경)
					'detailView': false
			};
			everPopup.openPopupByScreenId("CCDU0020", 1100, 700, param);
        }

        function callBackPIC_USER_NM(data) {
        	if(data!=null){
				data = JSON.parse(data);
	            EVF.V("PIC_USER_ID", data.USER_ID);
	            EVF.V("PIC_USER_NM", data.USER_NM);
        	}
        }

        function doSearch() {
            var store = new EVF.Store();
            if(!store.validate()) { return; }
            store.setGrid([grid]);
            store.setParameter("SEL_BUYER", $("#SEL_BUYER").val());
            store.load(baseUrl + "cpor0020_doSearch.so", function() {
                if(grid.getRowCount() == 0){
                    EVF.alert("${msg.M0002 }");
                } else {
                    grid.setColIconify("VENDOR_REJECT_RMK", "VENDOR_REJECT_RMK", "comment", false);
                    grid.setColIconify("FORCE_CLOSE_RMK", "FORCE_CLOSE_RMK", "comment", false);
                }
            });
        }

        function doUpdate() {
            if(grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
            if(grid.getSelRowCount() > 1) {
                return EVF.alert("${CPOR0020_001}");
            }

            var selRowValue = grid.getSelRowValue();
            var PO_NUM = selRowValue[0].PO_NUM;
            var PROGRESS_CD = selRowValue[0].PROGRESS_CD;
            var CTRL_USER_ID = selRowValue[0].CTRL_USER_ID;
            var SIGN_STATUS = selRowValue[0].SIGN_STATUS;
            var VENDOR_RECEIPT_STATUS = selRowValue[0].VENDOR_RECEIPT_STATUS;
            var PO_CREATE_TYPE = selRowValue[0].PO_CREATE_TYPE;
            var EXEC_AUTH = selRowValue[0].EXEC_AUTH;

            if("AUTO" == PO_CREATE_TYPE || "DRAFT" == PO_CREATE_TYPE) {
                return EVF.alert("${CPOR0020_014}");	// 발주유형이 수기발주 또는 수기계약발주 인 경우만 수정 가능합니다.
            }

            if("100" != PROGRESS_CD || "P" == SIGN_STATUS || "E" == SIGN_STATUS) {
                if("100" != VENDOR_RECEIPT_STATUS) {
                    return EVF.alert("${CPOR0020_003}");	// 진행상태가 작성중/결재반려/상신취소/업체반려 인 경우만 수정 가능합니다.
                }
            }

            if("${ses.userId}" != CTRL_USER_ID) {
                return EVF.alert("${CPOR0020_004}");	// 본인이 작성한 발주만 수정 가능합니다.
            }

            if(EXEC_AUTH == '0') {
                return EVF.alert("${CPOR0020_018}");	// 체결고객사만 수정 가능합니다.
            }

            var param = {
                callbackFunction: "",
                PO_NUM: PO_NUM,
                PROGRESS_CD: PROGRESS_CD,
                detailView: false,
                buttonView: true
            };
            everPopup.openPopupByScreenId("CPOI0010", 1300, 900, param);
        }

        function doClosing() {
            
        	if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
			
            var selRowValue = grid.getSelRowValue();
            for(var i in selRowValue) {
                var row = selRowValue[i];
                
                if("${ses.userId}" != row.CTRL_USER_ID) { // 본인이 작성한 발주만 발주종결 가능합니다.
                	return EVF.alert("${CPOR0020_005}");
                }
                
                if(row.PROGRESS_CD != "5200") {
                	return EVF.alert("${CPOR0020_007}"); // 협력업체전송 건만 발주종결 가능합니다.
                }
                
                if(row.FORCE_CLOSE_DATE != "") {
                	return EVF.alert("${CPOR0020_012}"); // 이미 발주종결된 건이 있습니다.
                }
                
                if(row.EXEC_AUTH == '0') {
                	return EVF.alert("${CPOR0020_019}"); // 체결고객사만 발주종결 가능합니다.
                }
            }
			
            var param = {
                title: "${CPOR0020_008}",
                message: EVF.V("CONFIRM_REASON"),
                callbackFunction: "callbackClosing",
                rowIdx: ""
            };
            everPopup.commonTextInput(param);
        }
        
        function callbackClosing(data) {
            if(data.message == "") {
                EVF.alert("${CPOR0020_009}");
            } else {
                EVF.V("CONFIRM_REASON", data.message);
                EVF.confirm("${CPOR0020_002}", function () {
                    var store = new EVF.Store();
                    store.setGrid([grid]);
                    store.getGridData(grid, "sel");
                    store.load(baseUrl + "cpor0020_doClosing.so", function() {
                        EVF.alert(this.getResponseMessage());
                        doSearch();
                    });
                });
            }
        }
		
       	// 구매담당자 변경
        function doUpdateChange() {
       		
            if(grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
			
            if(EVF.V("CTRL_USER_CH_ID") == "") {
            	return EVF.alert("${CPOR0020_013}");
            }
            
            var selRowValue = grid.getSelRowValue();
			for(var i in selRowValue) {
                var data = selRowValue[i];
             	// 2021.02.08 중앙회 요청 "관리자직무"를 갖는 사람은 담당자 변경 가능하도록 추가
                if(!changeFlag) {
	                if("${ses.userId}" != data.CTRL_USER_ID) {
	                	return EVF.alert("${CPOR0020_006}");	// 본인이 작성한 발주만 담당자 변경이 가능합니다.
	                }
                }
            }

            EVF.confirm("${CPOR0020_010}", function () {
                var store = new EVF.Store();
                store.setGrid([grid]);
                store.getGridData(grid, "sel");
                store.load(baseUrl + "cpor0020_doUpdateChange.so", function() {
                    EVF.alert(this.getResponseMessage());
                    doSearch();
                });
            });
        }
       	
       	// 검수담당자 변경
        function doUpdateChangeINV() {
       		
        	if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

            if(EVF.V("PIC_USER_ID") == "") {
                return EVF.alert("${CPOR0020_013}");	// 변경하려는 담당자를 선택해주세요.
            }

            var selRowValue = grid.getSelRowValue();
            for(var i in selRowValue) {
                var data = selRowValue[i];
             	// 2021.04.19 검수담당자 권한 추가
                // 2021.02.08 중앙회 요청 "관리자직무"를 갖는 사람은 담당자 변경 가능하도록 추가
                if(!changeFlag) {
	                if("${ses.userId}" != data.CTRL_USER_ID && "${ses.userId}" != data.INSPECT_USER_ID) {
	                	return EVF.alert("본인이 작성한 발주 또는 본인이 검수자인 발주만 담당자 변경이 가능합니다.");	// 본인이 작성한 발주만 담당자 변경이 가능합니다.
	                }
                }
            }

            EVF.confirm("${CPOR0020_010}", function () {
                var store = new EVF.Store();
                store.setGrid([grid]);
                store.getGridData(grid, "sel");
                store.load(baseUrl + "cpor0020_doUpdateChangeINV.so", function() {
                    EVF.alert(this.getResponseMessage());
                    doSearch();
                });
            });
        }
       	
     	// 2021.09.16 : 검수유형 변경
        function doUpdateDelivery() {
       		
        	if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
        	if (grid.getSelRowCount() > 1) { return EVF.alert("${msg.M0006}"); }
        	
            var selRowValue = grid.getSelRowValue();
            for(var i in selRowValue) {
                var data = selRowValue[i];
                if(!changeFlag) {
	                if("${ses.userId}" != data.CTRL_USER_ID) {
	                	return EVF.alert("본인이 작성한 발주서만 검수유형 변경이 가능합니다.");	// 본인이 작성한 발주만 검수유형 변경이 가능합니다.
	                }
                }
                if(EVF.isEmpty(data.DELIVERY_TYPE)) {
                	return EVF.alert("변경하려는 발주서의 검수유형이 선택되지 않았습니다.");
                }
                if(data.DELIVERY_TYPE == "PI" && data.PO_DUP_FLAG == "1") {
                	return EVF.alert("${CPOR0020_022}");	// 동일한 계약으로 발주서가 2개 이상 분리된 발주는 ’전체검수’를 진행할 수 없습니다.
                }
                if(data.INV_FLAG == "1") {
                	return EVF.alert("${CPOR0020_021}");	// 진행상태가 ’협력업체전송’이고, 검수요청이 이루어지지 않은 발주에 대해 변경이 가능합니다. ’작성중’이거나 ’반려’된 검수요청건도 협력사에서 삭제해야 합니다.
                }
            }
			
            EVF.confirm("${CPOR0020_020}", function () {
                var store = new EVF.Store();
                store.setGrid([grid]);
                store.getGridData(grid, "sel");
                store.load(baseUrl + "cpor0020_doUpdateDelivery.so", function() {
                    EVF.alert(this.getResponseMessage());
                    doSearch();
                });
            });
        }
    </script>

    <e:window id="CPOR0020" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">
        <e:inputHidden id="CONFIRM_REASON" name="CONFIRM_REASON"/>

        <e:searchPanel id="sp" title="${form_CAPTION_N}" labelWidth="${labelWidth}" useTitleBar="false" width="100%" columnCount="3" onEnter="doSearch">
            <e:row>
                <e:label for="FROM_PO_DATE" title="${form_FROM_PO_DATE_N}"/>
                <e:field>
                    <e:inputDate id="FROM_PO_DATE" name="FROM_PO_DATE" toDate="TO_PO_DATE" value="${FROM_PO_DATE}" width="${inputDateWidth}" datePicker="true" required="${form_FROM_PO_DATE_R}" disabled="${form_FROM_PO_DATE_D}" readOnly="${form_FROM_PO_DATE_RO}" />
                    <e:text> ~ </e:text>
                    <e:inputDate id="TO_PO_DATE" name="TO_PO_DATE" fromDate="FROM_PO_DATE" value="${TO_PO_DATE}" width="${inputDateWidth}" datePicker="true" required="${form_TO_PO_DATE_R}" disabled="${form_TO_PO_DATE_D}" readOnly="${form_TO_PO_DATE_RO}" />
                </e:field>
                <e:label for="SEL_BUYER" title="">
                        <e:select id="SEL_BUYER" name="SEL_BUYER" value="" options="${selBuyerOptions}" width="${form_SEL_BUYER_W}" disabled="${form_SEL_BUYER_D}" readOnly="${form_SEL_BUYER_RO}" required="${form_SEL_BUYER_R}" placeHolder="" usePlaceHolder="false" maskType="${form_SEL_BUYER_MT}" />
                </e:label>
                <e:field>
                    <e:search id="BUYER_CD" name="BUYER_CD" value="" width="40%" maxLength="${form_BUYER_CD_M}" onIconClick="${form_BUYER_CD_RO ? 'everCommon.blank' : 'onIconClickBUYER_CD'}" disabled="${form_BUYER_CD_D}" readOnly="${form_BUYER_CD_RO}" required="${form_BUYER_CD_R}" maskType="${form_BUYER_CD_MT}" placeHolder="회사코드" />
                    <e:inputText id="BUYER_NM" name="BUYER_NM" value="" width="60%" maxLength="${form_BUYER_NM_M}" disabled="${form_BUYER_NM_D}" readOnly="${form_BUYER_NM_RO}" required="${form_BUYER_NM_R}" style="${imeMode}" maskType="${form_BUYER_NM_MT}" placeHolder="회사명"/>
                </e:field>
                <e:label for="PO_NUM" title="${form_PO_NUM_N}" />
                <e:field>
                    <e:inputText id="PO_NUM" name="PO_NUM" value="" width="${form_PO_NUM_W}" maxLength="${form_PO_NUM_M}" disabled="${form_PO_NUM_D}" readOnly="${form_PO_NUM_RO}" required="${form_PO_NUM_R}" style="${imeMode}" maskType="${form_PO_NUM_MT}"/>
                </e:field>
            </e:row>

            <e:row>
                <e:label for="VENDOR_RECEIPT_STATUS" title="${form_VENDOR_RECEIPT_STATUS_N}"/>
                <e:field>
                    <e:select id="VENDOR_RECEIPT_STATUS" name="VENDOR_RECEIPT_STATUS" value="" options="${vendorReceiptStatusOptions}" width="${form_VENDOR_RECEIPT_STATUS_W}" disabled="${form_VENDOR_RECEIPT_STATUS_D}" readOnly="${form_VENDOR_RECEIPT_STATUS_RO}" required="${form_VENDOR_RECEIPT_STATUS_R}" placeHolder="선택" maskType="${form_VENDOR_RECEIPT_STATUS_MT}" />
                </e:field>
                <e:label for="VENDOR_CD" title="${form_VENDOR_CD_N}"/>
                <e:field>
                    <e:search id="VENDOR_CD" name="VENDOR_CD" value="" width="40%" maxLength="${form_VENDOR_CD_M}" onIconClick="${form_VENDOR_CD_RO ? 'everCommon.blank' : 'onIconClickVENDOR_CD'}" disabled="${form_VENDOR_CD_D}" readOnly="${form_VENDOR_CD_RO}" required="${form_VENDOR_CD_R}" maskType="${form_VENDOR_CD_MT}" placeHolder="회사코드" />
                    <e:inputText id="VENDOR_NM" name="VENDOR_NM" value="" width="60%" maxLength="${form_VENDOR_NM_M}" disabled="${form_VENDOR_NM_D}" readOnly="${form_VENDOR_NM_RO}" required="${form_VENDOR_NM_R}" style="${imeMode}" maskType="${form_VENDOR_NM_MT}" placeHolder="회사명"/>
                </e:field>
                <e:label for="CONT_NUM" title="${form_CONT_NUM_N}" />
                <e:field>
                    <e:inputText id="CONT_NUM" name="CONT_NUM" value="" width="${form_CONT_NUM_W}" maxLength="${form_CONT_NUM_M}" disabled="${form_CONT_NUM_D}" readOnly="${form_CONT_NUM_RO}" required="${form_CONT_NUM_R}" style="${imeMode}" maskType="${form_CONT_NUM_MT}"/>
                </e:field>
            </e:row>

            <e:row>
                <e:label for="CTRL_USER_ID" title="${form_CTRL_USER_ID_N}"/>
                <e:field>
                    <e:search id="CTRL_USER_ID" name="CTRL_USER_ID" value="${ses.userId}" width="40%" maxLength="${form_CTRL_USER_ID_M}" onIconClick="${form_CTRL_USER_ID_RO ? 'everCommon.blank' : 'onIconClickCTRL_USER_ID'}" disabled="${form_CTRL_USER_ID_D}" readOnly="${form_CTRL_USER_ID_RO}" required="${form_CTRL_USER_ID_R}" maskType="${form_CTRL_USER_ID_MT}" placeHolder="개인번호" />
                    <e:inputText id="CTRL_USER_NM" name="CTRL_USER_NM" value="${ses.userNm}" width="60%" maxLength="${form_CTRL_USER_NM_M}" disabled="${form_CTRL_USER_NM_D}" readOnly="${form_CTRL_USER_NM_RO}" required="${form_CTRL_USER_NM_R}" style="${imeMode}" maskType="${form_CTRL_USER_NM_MT}" placeHolder="성명"/>
                </e:field>
                <e:label for="INSPECT_USER_ID" title="${form_INSPECT_USER_ID_N}"/>
				<e:field>
					<e:search id="INSPECT_USER_ID" name="INSPECT_USER_ID" value="" width="40%" maxLength="${form_INSPECT_USER_ID_M}" onIconClick="${form_INSPECT_USER_ID_RO ? 'everCommon.blank' : 'onIconClickINSPECT_USER_ID'}" disabled="${form_INSPECT_USER_ID_D}" readOnly="${form_INSPECT_USER_ID_RO}" required="${form_INSPECT_USER_ID_R}" maskType="${form_INSPECT_USER_ID_MT}" />
					<e:inputText id="INSPECT_USER_NM" name="INSPECT_USER_NM" value="" width="60%" maxLength="${form_INSPECT_USER_NM_M}" disabled="${form_INSPECT_USER_NM_D}" readOnly="${form_INSPECT_USER_NM_RO}" required="${form_INSPECT_USER_NM_R}" style="${imeMode}" maskType="${form_INSPECT_USER_NM_MT}"/>
				</e:field>
                <e:label for="PROGRESS_CD" title="${form_PROGRESS_CD_N}"/>
                <e:field>
                    <e:select id="PROGRESS_CD" name="PROGRESS_CD" value="" options="${progressCdOptions}" width="${form_PROGRESS_CD_W}" disabled="${form_PROGRESS_CD_D}" readOnly="${form_PROGRESS_CD_RO}" required="${form_PROGRESS_CD_R}" placeHolder="선택" maskType="${form_PROGRESS_CD_MT}" />
                </e:field>
            </e:row>
            
            <e:row>
                <e:label for="FORCE_CLOSE_YN" title="${form_FORCE_CLOSE_YN_N}"/>
                <e:field>
                    <e:select id="FORCE_CLOSE_YN" name="FORCE_CLOSE_YN" value="" options="${forceCloseYnOptions}" width="${form_FORCE_CLOSE_YN_W}" disabled="${form_FORCE_CLOSE_YN_D}" readOnly="${form_FORCE_CLOSE_YN_RO}" required="${form_FORCE_CLOSE_YN_R}" placeHolder="선택" maskType="${form_FORCE_CLOSE_YN_MT}" />
                </e:field>
                <e:label for="" title=""/>
				<e:field> </e:field>
                <e:label for="" title=""/>
				<e:field> </e:field>
            </e:row>
        </e:searchPanel>

        <e:buttonBar width="100%" align="right">
        	<!-- 구매담당자변경 -->
        	<e:text style="color: blue;font-weight: bold;">■ ${form_CTRL_USER_CH_ID_N} : </e:text>
            <e:field>
            	<e:inputHidden id="CTRL_USER_CH_ID" name="CTRL_USER_CH_ID"/>
				<e:search id="CTRL_USER_CH_NM" name="CTRL_USER_CH_NM" value="" width="${form_CTRL_USER_CH_NM_W}" maxLength="${form_CTRL_USER_CH_NM_M}" onIconClick="onIconClickCTRL_USER_CH_ID" disabled="${form_CTRL_USER_CH_NM_D}" readOnly="${form_CTRL_USER_CH_NM_RO}" required="${form_CTRL_USER_CH_NM_R}" maskType="${form_CTRL_USER_CH_NM_MT}" />
            </e:field>
            <e:text> </e:text>
            <e:button id="doUpdateChange" name="doUpdateChange" align="left" label="${doUpdateChange_N}" onClick="doUpdateChange" disabled="${doUpdateChange_D}" visible="${doUpdateChange_V}"/>
            <!-- 검수담당자변경 -->
        	<e:text style="color: blue;font-weight: bold;">■ ${form_PIC_USER_NM_N} : </e:text>
            <e:field>
            	<e:inputHidden id="PIC_USER_ID" name="PIC_USER_ID"/>
				<e:search id="PIC_USER_NM" name="PIC_USER_NM" value="" width="${form_PIC_USER_NM_W}" maxLength="${form_PIC_USER_NM_M}" onIconClick="onIconClickPIC_USER_NM" disabled="${form_PIC_USER_NM_D}" readOnly="${form_PIC_USER_NM_RO}" required="${form_PIC_USER_NM_R}" maskType="${form_PIC_USER_NM_MT}" />
            </e:field>
            <e:text> </e:text>
            <e:button id="doUpdateChangeINV" name="doUpdateChangeINV" align="left" label="${doUpdateChangeINV_N}" onClick="doUpdateChangeINV" disabled="${doUpdateChangeINV_D}" visible="${doUpdateChangeINV_V}"/>
            
            <e:text style="color: red;font-weight: bold;">※ 검수유형변경 (&nbsp;</e:text>
			<e:button id="doUpdateDelivery" name="doUpdateDelivery" label="${doUpdateDelivery_N}" onClick="doUpdateDelivery" disabled="${doUpdateDelivery_D}" visible="${doUpdateDelivery_V}" align="left"/>
			<e:text style="color: red;font-weight: bold;">)</e:text>
            
            
            <e:button id="doSearch" name="doSearch" label="${doSearch_N}" onClick="doSearch" disabled="${doSearch_D}" visible="${doSearch_V}"/>
            <e:button id="doUpdate" name="doUpdate" label="${doUpdate_N}" onClick="doUpdate" disabled="${doUpdate_D}" visible="${doUpdate_V}"/>
            <e:button id="doClosing" name="doClosing" label="${doClosing_N}" onClick="doClosing" disabled="${doClosing_D}" visible="${doClosing_V}"/>
        </e:buttonBar>

        <e:gridPanel id="grid" name="grid" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}" />
    </e:window>
</e:ui>
