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
        var baseUrl = "/nhepro/CAPR/";
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
			
         	// Grid Excel Event
			grid.excelExportEvent({
				allItems: "${excelExport.allCol}",
				fileName: "${sreenName }"
			});
            
            grid.cellClickEvent(function(rowIdx, colIdx, value) {
                var param;
                var apRejectRmk = grid.getCellValue(rowIdx, "AP_REJECT_RMK");
                /**
                 * 2021.11.18 중앙회 박기현 님 요청사항으로 제외
                if(colIdx == "multiSelect") {
                    if (value == "1") {
                        grid.checkEqualRow(["AP_NUM"], [grid.getCellValue(rowIdx, "AP_NUM")]);
                    } else {
                        grid.checkNotEqualRow(["AP_NUM"], [grid.getCellValue(rowIdx, "AP_NUM")]);
                    }
                } else */
                if(colIdx == "AP_NUM") {
                    if(value != "") {
                    	
                    	var detailView = "false";
                    	if( grid.getCellValue(rowIdx, "PROGRESS_CD") != "20" || grid.getCellValue(rowIdx, "SIGN_STATUS") == "E" || grid.getCellValue(rowIdx, "SIGN_STATUS") == "P") {
                            detailView = true;
                        } 
                    	
                    	if(grid.getCellValue(rowIdx, "PAY_USER_ID") != "${ses.userId}") {
                    		detailView = true;	
                        }
        				
                        if(grid.getCellValue(rowIdx, "EXEC_AUTH") == '0') {
                        	detailView = true;	
                        }
                        param = {
                            callbackFunction: "",
                            BUYER_CD: grid.getCellValue(rowIdx, "BUYER_CD"),
                            AP_NUM: value,
                            //detailView: true,
                            detailView: detailView,
                            buttonView: false
                        };
                        everPopup.openPopupByScreenId("CAPR0011", 1200, 750, param);
                    }
                } else if(colIdx == "PO_NUM") {
                    param = {
                        callbackFunction: "",
                        BUYER_CD: grid.getCellValue(rowIdx, "BUYER_CD"),
                        PO_NUM: value,
                        detailView: true,
                        buttonView: false
                    };
                    everPopup.openPopupByScreenId("CPOI0010", 1200, 750, param);
                } else if(colIdx == "VENDOR_CD") {
                    param = {
                        VENDOR_CD: value,
                        detailView: true,
                        popupFlag: true,
                        buttonView: false
                    };
                    everPopup.openPopupByScreenId("CVNR0011", 1000, 730, param);
                } else if(colIdx == "INV_NUM") {
                	var url = "CPOR0071"; // 부분검수
                	var deliveryType = grid.getCellValue(rowIdx, "DELIVERY_TYPE");
                	if( deliveryType == "PI" ) { // 전체검수
                		url = "CPOR0051";
                	}
                    param = {
                        callbackFunction: "",
                        BUYER_CD: grid.getCellValue(rowIdx, "BUYER_CD"),
                        INV_NUM: value,
                        detailView: true,
                        buttonView: false
                    };
                    everPopup.openPopupByScreenId(url, 1200, 750, param);
                } else if(colIdx == "PIC_USER_NM") {
                    param = {
                        callbackFunction: "",
                        USER_TYPE: grid.getCellValue(rowIdx, "PIC_USER_TYPE"),
                        USER_ID: grid.getCellValue(rowIdx, "PIC_USER_ID"),
                        detailView: true
                    };
                    everPopup.openPopupByScreenId("MTUA0011", 600, 190, param);
                } else if(colIdx == "CTRL_USER_NM") {
                    param = {
                        callbackFunction: "",
                        USER_TYPE: grid.getCellValue(rowIdx, "CTRL_USER_TYPE"),
                        USER_ID: grid.getCellValue(rowIdx, "CTRL_USER_ID"),
                        detailView: true
                    };
                    everPopup.openPopupByScreenId("MTUA0011", 600, 190, param);
                } else if(colIdx == "PAY_USER_NM") {
                    param = {
                        callbackFunction: "",
                        USER_TYPE: grid.getCellValue(rowIdx, "PAY_USER_TYPE"),
                        USER_ID: grid.getCellValue(rowIdx, "PAY_USER_ID"),
                        detailView: true
                    };
                    everPopup.openPopupByScreenId("MTUA0011", 600, 190, param);
                } else if(colIdx == "CONT_NUM") {
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
                else if(colIdx == "PROGRESS_CD_LOC") {
                	if( EVF.isEmpty(apRejectRmk) ) return;
                	param = {
       					title : '대금청구 반송사유',
       					message: apRejectRmk,
       					detailView : true
       				};
       				everPopup.commonTextInput(param);
                }
            });
            
         	// 2021.02.08 : "관리자직무"를 갖는 사람은 담당자 변경 가능
		    if ("${ses.ctrlCd}".indexOf("${ManagerCd}") > -1) {
		    	changeFlag = true;
            }
			
         	// 2021.03.17 : 관리자직무인 경우 대금지급담당자 변경 가능
           	if(changeFlag || "${ses.ctrlCd}".indexOf("BR080") > -1) {
         		EVF.C("doUpdateChange").setDisabled(false);
            } else {
            	EVF.C("doUpdateChange").setDisabled(true);
            }
			
          	//2021.03.17 추가
            // 구매담당자, 계약담당자, 관리자직무인 경우 대금지급담당자 조회조건 변경이 가능함
            if( !havePermission ) {
            	EVF.C("sAP_USER_ID").setReadOnly(true);
            	EVF.C("sAP_USER_ID").setDisabled(true);
            	EVF.C("sAP_USER_NM").setReadOnly(true);
            }
          	
         	// 의뢰고객사 조회조건
            EVF.V("SEL_BUYER", "PY");
			// 대금지급담당자 변경
            EVF.C("AP_USER_NM").setReadOnly(true);
            
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
		    grid.setRowFooter("BUYER_DEPT_NM", footer);

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
		    grid.setRowFooter("PY_AMT", distVal);
		    grid.setRowFooter("AP_AMT", distVal);
			
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

        function onIconClickPIC_USER_ID() {
        	var param = {
					'callBackFunction': 'callBackPIC_USER_ID',
					'READONLY': 'N',		//팝업 조회조건 변경불가
					'multiYN' : 'N',        //멀티팝업여부
					'CTRL_CD' : 'BR020',	//검수/입고 담당자권한(=기본권한으로 변경)
					'detailView': false
			};
			everPopup.openPopupByScreenId("CCDU0020", 1100, 700, param);
        }

        function callBackPIC_USER_ID(data) {
        	if(data!=null){
				data = JSON.parse(data);
	            EVF.V("PIC_USER_ID", data.USER_ID);
	            EVF.V("PIC_USER_NM", data.USER_NM);
        	}
        }

        function onIconClickPIC2_USER_ID() {
        	var param = {
					'callBackFunction': 'callBackPIC2_USER_ID',
					'READONLY': 'N',		//팝업 조회조건 변경불가
					'multiYN' : 'N',        //멀티팝업여부
					'CTRL_CD' : 'BR020',	//검수/입고 담당자권한(=기본권한으로 변경)
					'detailView': false
			};
			everPopup.openPopupByScreenId("CCDU0020", 1100, 700, param);
        }

        function callBackPIC2_USER_ID(data) {
        	if(data!=null){
				data = JSON.parse(data);
	            EVF.V("PIC2_USER_ID", data.USER_ID);
	            EVF.V("PIC2_USER_NM", data.USER_NM);
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
        
        function onIconClickPYBUYER_CD() {
            var param = {
                callBackFunction: "callBackPYBUYER_CD"
            };
            everPopup.openCommonPopup(param, "SP0066");
        }

        function callBackPYBUYER_CD(data) {
            EVF.V("PY_BUYER_CD", data.CUST_CD);
            EVF.V("PY_BUYER_NM", data.CUST_NM);
        }
		
        function onIconClickAP_USER_ID() {
        	var param = {
					'callBackFunction': 'callBackAP_USER_ID',
					'READONLY': 'N',		//팝업 조회조건 변경불가
					'multiYN' : 'N',        //멀티팝업여부
					'CTRL_CD' : 'BR080',	// 대금지급 담당자권한
					'detailView': false
			};
			everPopup.openPopupByScreenId("CCDU0020", 1100, 700, param);
        }

        function callBackAP_USER_ID(data) {
        	if(data!=null){
				data = JSON.parse(data);
	            EVF.V("sAP_USER_ID", data.USER_ID);
	            EVF.V("sAP_USER_NM", data.USER_NM);
        	}
        }
        
        function onIconClickCTRL_USER_ID() {
        	var param = {
					'callBackFunction': 'callBackCTRL_USER_ID',
					'READONLY': 'Y',		//팝업 조회조건 변경불가
					'multiYN' : 'N',        //멀티팝업여부
					'CTRL_CD' : 'BR030',	//구매담당자권한
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
        
        function onIconClickAP_USER_NM() {
        	
        	if (grid.getSelRowCount() == 0) { return EVF.alert("변경하려는 대금지급청구건이 선택되지 않았습니다."); }
        	
        	var corpType = "";
        	var buyerCd  = "";
        	var selRowValue = grid.getSelRowValue();
            for(var i in selRowValue) {
            	corpType = selRowValue[i].CORP_TYPE;
            	buyerCd  = selRowValue[i].PY_BUYER_CD;
            }
        	
        	var param = {
					'callBackFunction': 'callBackAP_USER_NM',
					'CORP_TYPE' : corpType,		// 법인구분
                    'CUST_CD'   : buyerCd,		// 지불고객사코드
                    'READONLY'  : "Y",			// 전체 ReadOnly
                    'CUST_READONLY': "N",		// 고객사 ReadOnly
					'multiYN' : 'N',        	// 멀티팝업여부
					'CTRL_CD' : 'BR080',		// 대금지급 담당자권한
					'detailView': false
			};
			everPopup.openPopupByScreenId("CCDU0020", 1100, 700, param);
        }

        function callBackAP_USER_NM(data) {
        	if(data!=null){
				data = JSON.parse(data);
				EVF.V("AP_BUYER_CD", data.CUST_CD);
	            EVF.V("AP_USER_ID", data.USER_ID);
	            EVF.V("AP_USER_NM", data.USER_NM);
        	}
        }
		
        function doUpdateChange() {
            
            if(grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
			
            if(EVF.V("AP_USER_ID") == "") {
            	return EVF.alert("${CAPR0010_001}");
            }
			
            var selRowValue = grid.getSelRowValue();
            for(var i in selRowValue) {
                if(selRowValue[i].PROGRESS_CD > "20") {
                    return EVF.alert("${CAPR0010_009}");	// 진행상태가 지급요청인 건만 가능합니다.
                }
                
             	// 2021.02.08 중앙회 요청 "관리자직무"를 갖는 사람은 담당자 변경 가능하도록 추가
                if(!changeFlag) {
	                if(selRowValue[i].PAY_USER_ID != "${ses.userId}") {
	                    return EVF.alert("${CAPR0010_002}");
	                }
                }
				
             	// 2021.09.03 : 변경하려는 담당자 회사코드와 선택한 대금지불건의 지불고객사가 다른 경우 담당자변경 불가능
                if(EVF.V("AP_BUYER_CD") != selRowValue[i].PY_BUYER_CD) {
                    return EVF.alert("${CAPR0010_023}");
                }
                
                // 2021.09.03 : 동일한 지불고객사끼리만 담당자변경 가능
                if(selRowValue[0].PY_BUYER_CD != selRowValue[i].PY_BUYER_CD) {
                    return EVF.alert("${CAPR0010_023}");
                }
            }
			
            var store = new EVF.Store();
            EVF.confirm("${CAPR0010_005}", function () {
                store.setGrid([grid]);
                store.getGridData(grid, "sel");
                store.load(baseUrl + "capr0010_doUpdateChange.so", function() {
                    doSearch();
                    EVF.alert(this.getResponseMessage());
                });
            });
        }

        function doSearch() {
            var store = new EVF.Store();
            if(!store.validate()) { return; }

            store.setGrid([grid]);
            store.setParameter("SEL_BUYER", $("#SEL_BUYER").val());
            store.load(baseUrl + "capr0010_doSearch.so", function() {
                if(grid.getRowCount() == 0){
                    EVF.alert("${msg.M0002 }");
                } else {
                    var allRowId = grid.getAllRowId();
                    for(var i in allRowId) {
                        var rowIdx = allRowId[i];
                        var PROGRESS_CD = grid.getCellValue(rowIdx, "PROGRESS_CD");
                        var AP_AMT = grid.getCellValue(rowIdx, "AP_AMT");
                        var AP_REJECT_RMK = grid.getCellValue(rowIdx, "AP_REJECT_RMK");
                       
                        if( PROGRESS_CD == "50" && EVF.isEmpty(AP_AMT) ) {
                            grid.setCellRequired(rowIdx, "AP_AMT", true);
                            grid.setCellRequired(rowIdx, "AP_DATE", true);
                            // 2021.11.29 중앙회 박기현님 요청사항 삭제
                            //grid.setCellRequired(rowIdx, "AP_ACCOUT", true);
				
                            grid.setCellReadOnly(rowIdx, "AP_AMT", false);
                            grid.setCellReadOnly(rowIdx, "AP_DATE", false);
                         	// 2021.11.29 중앙회 박기현님 요청사항 삭제
                            //grid.setCellReadOnly(rowIdx, "AP_ACCOUT", false);
                         	
                         	// 2021.11.29 지급금액, 지급일자 default 처리 및 빨간색으로 등록
                         	grid.setCellValue(rowIdx, "AP_AMT", grid.getCellValue(rowIdx, "PY_AMT"));
                         	grid.setCellValue(rowIdx, "AP_DATE", grid.getCellValue(rowIdx, "PY_AP_REQ_DATE"));
                         	
                            grid.setCellFontColor(rowIdx, 'AP_AMT', "#FF0000");
                            grid.setCellFontColor(rowIdx, 'AP_DATE', "#FF0000");
                        }
                        
                        if( !EVF.isEmpty(AP_REJECT_RMK) && PROGRESS_CD == "40") {
                        	grid.setCellFontColor(rowIdx, 'PROGRESS_CD_LOC', "#0100FF");
                            grid.setCellFontWeight(rowIdx, 'PROGRESS_CD_LOC', true);
                        }
                    }
                    grid.checkAll(false);
                }
            });
        }
		
        // Single 결재상신, 반송
        function doApprovalPop() {
        	
            if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
            if (grid.getSelRowCount() > 1) { return EVF.alert("${CAPR0010_014}"); }
			
            var selRowValue = grid.getSelRowValue();
            for(var i in selRowValue) {
                var rowData = selRowValue[i];
				// 20 : 지급요청
                if( rowData.PROGRESS_CD != "20" || rowData.SIGN_STATUS == "E" || rowData.SIGN_STATUS == "P") {
                    return EVF.alert("${CAPR0010_022}");	// 진행상태가 지급요청 또는 결재상태가 반려/취소인 건만 가능합니다.
                }
				
                if(rowData.PAY_USER_ID != "${ses.userId}") {
                    return EVF.alert("${CAPR0010_002}");	// 대금지급 담당자 본인 건만 가능합니다.
                }
				
                if(rowData.EXEC_AUTH == '0') {
                    return EVF.alert("${CAPR0010_015}");	// 지불고객사만 결재상신 가능합니다.
                }
            }
			
            var store = new EVF.Store();
            if(!store.validate()) { return; }
			
            var param = {
                callbackFunction: "",
                BUYER_CD: selRowValue[0].BUYER_CD,
                AP_NUM: selRowValue[0].AP_NUM,
                detailView: false,
                buttonView: true
            };
            everPopup.openPopupByScreenId("CAPR0011", 1200, 750, param);
        }
        
     	// 2021.11.18 Multi 결재상신, 반송 기능추가
        function doMultiApprovalPop() {
     		
            if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
            if (grid.getSelRowCount() == 1) { return EVF.alert("${CAPR0010_024}"); }
            
            var selRowCount = grid.getSelRowCount();
            var selRowValue = grid.getSelRowValue();
            for(var i in selRowValue) {
                var rowData = selRowValue[i];
				// 20 : 지급요청
                if( rowData.PROGRESS_CD != "20" || rowData.SIGN_STATUS == "E" || rowData.SIGN_STATUS == "P") {
                    return EVF.alert("${CAPR0010_022}");	// 진행상태가 지급요청 또는 결재상태가 반려/취소인 건만 가능합니다.
                }
				
                if(rowData.PAY_USER_ID != "${ses.userId}") {
                    return EVF.alert("${CAPR0010_002}");	// 대금지급 담당자 본인 건만 가능합니다.
                }
				
                if(rowData.EXEC_AUTH == '0') {
                    return EVF.alert("${CAPR0010_015}");	// 지불고객사만 결재상신 가능합니다.
                }
            }
            
            if (!grid.validate().flag) { return EVF.alert(grid.validate().msg); }
			
            EVF.confirm("대금지급 요청금액 및 지급예정일자는 확인하셨나요?\n\n선택한 [ " + selRowCount + " ] 건의 대금지급요청서를 " + "${msg.M0025}", function () {
                var param = {
                    subject: "제목은 협력사에서 작성한 대금지급 요청명으로 자동 등록됩니다.",
                    docType: "AP",
                    signStatus: "P",
                    screenId: "CAPR010",
                    approvalType: "APPROVAL",
                    callBackFunction: "goApproval"
                };
                everPopup.openApprovalRequestIPopup(param);
            });
        }
		
        function goApproval(formData, gridData, attachData) {
            EVF.V("approvalFormData", formData);
            EVF.V("approvalGridData", gridData);
            EVF.V("attachFileDatas",  attachData);
			
            var store = new EVF.Store();
			store.setGrid([grid]);
			store.getGridData(grid, "sel");
            store.load(baseUrl + "capr0010_doUpdateApproval.so", function() {
            	EVF.alert(this.getResponseMessage(), function () {
            		doSearch();
                });
            });
        }
        
        // 지급내역 등록
        function doUpdatePayReg() {
        	
            if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
			
            var selRowValue = grid.getSelRowValue();
            for(var i in selRowValue) {
                var rowData = selRowValue[i];

                if(rowData.PROGRESS_CD != "50") {
                    return EVF.alert("${CAPR0010_011}");	// 진행상태가 확정인 건만 가능합니다.
                }
				
                if(rowData.PAY_USER_ID != "${ses.userId}") {
                    return EVF.alert("${CAPR0010_002}");	// 대금지급 담당자 본인 건만 가능합니다.
                }

                if(rowData.EXEC_AUTH == '0') {
                    return EVF.alert("${CAPR0010_016}");	// 지불고객사만 지급내역 등록이 가능합니다.
                }
            }
			
            if (!grid.validate().flag) { return EVF.alert(grid.validate().msg); }
			
            var msg;
            /**
             * 2021.11.29 중앙회 박기현님 요청사항 삭제
            for(var j in selRowValue) {
                var row = selRowValue[j];
                if(row.PAY_ACCOUNT_NUM != row.AP_ACCOUT) {
                    msg = "${CAPR0010_012}";
                }
            }*/
			
            if(msg == "" || msg == undefined) {
                msg = "${CAPR0010_010}";
            }
			
            var store = new EVF.Store();
			EVF.confirm(msg, function () {
                store.setGrid([grid]);
                store.getGridData(grid, "sel");
                store.load(baseUrl + "capr0010_doUpdatePayReg.so", function() {
                	EVF.alert(this.getResponseMessage(), function () {
                		doSearch();
                    });
                });
            });
        }
    </script>

    <e:window id="CAPR0010" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">
        <e:searchPanel id="sp" title="${form_CAPTION_N}" labelWidth="${labelWidth}" useTitleBar="false" width="100%" columnCount="3" onEnter="doSearch">
        	<e:inputHidden id="AP_BUYER_CD" name="AP_BUYER_CD" />
        	<!-- 2021.11.18 Multi 결재상신 추가 -->
        	<e:inputHidden id="approvalFormData" name="approvalFormData"/>
        	<e:inputHidden id="approvalGridData" name="approvalGridData"/>
        	<e:inputHidden id="attachFileDatas"  name="attachFileDatas"/>
        	
            <e:row>
                <e:label for="FROM_DATE" title="${form_FROM_DATE_N}"/>
                <e:field>
                    <e:inputDate id="FROM_DATE" name="FROM_DATE" toDate="TO_DATE" value="${FROM_DATE}" width="${inputDateWidth}" datePicker="true" required="${form_FROM_DATE_R}" disabled="${form_FROM_DATE_D}" readOnly="${form_FROM_DATE_RO}" />
                    <e:inputDate id="TO_DATE" name="TO_DATE" fromDate="FROM_DATE" value="${TO_DATE}" width="${inputDateWidth}" datePicker="true" required="${form_TO_DATE_R}" disabled="${form_TO_DATE_D}" readOnly="${form_TO_DATE_RO}" />
                </e:field>
                <e:label for="DELIVERY_TYPE" title="${form_DELIVERY_TYPE_N}"/>
                <e:field>
                    <e:select id="DELIVERY_TYPE" name="DELIVERY_TYPE" value="" options="${deliveryTypeOptions}" width="${form_DELIVERY_TYPE_W}" disabled="${form_DELIVERY_TYPE_D}" readOnly="${form_DELIVERY_TYPE_RO}" required="${form_DELIVERY_TYPE_R}" placeHolder="선택" maskType="${form_DELIVERY_TYPE_MT}" />
                </e:field>
                <e:label for="INV_NUM" title="${form_INV_NUM_N}" />
                <e:field>
                    <e:inputText id="INV_NUM" name="INV_NUM" value="" width="${form_INV_NUM_W}" maxLength="${form_INV_NUM_M}" disabled="${form_INV_NUM_D}" readOnly="${form_INV_NUM_RO}" required="${form_INV_NUM_R}" style="${imeMode}" maskType="${form_INV_NUM_MT}"/>
                </e:field>
            </e:row>
            <e:row>
                <e:label for="VENDOR_CD" title="${form_VENDOR_CD_N}"/>
                <e:field>
                    <e:search id="VENDOR_CD" name="VENDOR_CD" value="" width="${form_VENDOR_CD_W}%" maxLength="${form_VENDOR_CD_M}" onIconClick="${form_VENDOR_CD_RO ? 'everCommon.blank' : 'onIconClickVENDOR_CD'}" disabled="${form_VENDOR_CD_D}" readOnly="${form_VENDOR_CD_RO}" required="${form_VENDOR_CD_R}" maskType="${form_VENDOR_CD_MT}" placeHolder="회사코드"/>
                    <e:inputText id="VENDOR_NM" name="VENDOR_NM" value="" width="${form_VENDOR_NM_W}%" maxLength="${form_VENDOR_NM_M}" disabled="${form_VENDOR_NM_D}" readOnly="${form_VENDOR_NM_RO}" required="${form_VENDOR_NM_R}" style="${imeMode}" maskType="${form_VENDOR_NM_MT}" placeHolder="회사명"/>
                </e:field>
                <e:label for="PO_NUM" title="${form_PO_NUM_N}" />
                <e:field>
                    <e:inputText id="PO_NUM" name="PO_NUM" value="" width="${form_PO_NUM_W}" maxLength="${form_PO_NUM_M}" disabled="${form_PO_NUM_D}" readOnly="${form_PO_NUM_RO}" required="${form_PO_NUM_R}" style="${imeMode}" maskType="${form_PO_NUM_MT}"/>
                </e:field>
                <e:label for="CONT_NUM" title="${form_CONT_NUM_N}" />
                <e:field>
                    <e:inputText id="CONT_NUM" name="CONT_NUM" value="" width="${form_CONT_NUM_W}" maxLength="${form_CONT_NUM_M}" disabled="${form_CONT_NUM_D}" readOnly="${form_CONT_NUM_RO}" required="${form_CONT_NUM_R}" style="${imeMode}" maskType="${form_CONT_NUM_MT}"/>
                </e:field>
            </e:row>
            <e:row>
                <e:label for="SIGN_STATUS" title="${form_SIGN_STATUS_N}"/>
                <e:field>
                    <e:select id="SIGN_STATUS" name="SIGN_STATUS" value="" options="${signStatusOptions}" width="${form_SIGN_STATUS_W}" disabled="${form_SIGN_STATUS_D}" readOnly="${form_SIGN_STATUS_RO}" required="${form_SIGN_STATUS_R}" placeHolder="" maskType="${form_SIGN_STATUS_MT}" useMultipleSelect="true" />
                </e:field>
                <e:label for="PIC_USER_ID" title="${form_PIC_USER_ID_N}" />
                <e:field>
                    <e:search id="PIC_USER_ID" name="PIC_USER_ID" value="" width="${form_PIC_USER_ID_W}%" maxLength="${form_PIC_USER_ID_M}" onIconClick="${form_PIC_USER_ID_RO ? 'everCommon.blank' : 'onIconClickPIC_USER_ID'}" disabled="${form_PIC_USER_ID_D}" readOnly="${form_PIC_USER_ID_RO}" required="${form_PIC_USER_ID_R}" maskType="${form_PIC_USER_ID_MT}" placeHolder="개인번호" />
                    <e:inputText id="PIC_USER_NM" name="PIC_USER_NM" value="" width="${form_PIC_USER_NM_W}%" maxLength="${form_PIC_USER_NM_M}" disabled="${form_PIC_USER_NM_D}" readOnly="${form_PIC_USER_NM_RO}" required="${form_PIC_USER_NM_R}" style="${imeMode}" maskType="${form_PIC_USER_NM_MT}" placeHolder="성명"/>
                </e:field>
                <e:label for="PIC2_USER_ID" title="${form_PIC2_USER_ID_N}" />
                <e:field>
                    <e:search id="PIC2_USER_ID" name="PIC2_USER_ID" value="" width="${form_PIC2_USER_ID_W}%" maxLength="${form_PIC2_USER_ID_M}" onIconClick="${form_PIC2_USER_ID_RO ? 'everCommon.blank' : 'onIconClickPIC2_USER_ID'}" disabled="${form_PIC2_USER_ID_D}" readOnly="${form_PIC2_USER_ID_RO}" required="${form_PIC2_USER_ID_R}" maskType="${form_PIC2_USER_ID_MT}" placeHolder="개인번호" />
                    <e:inputText id="PIC2_USER_NM" name="PIC2_USER_NM" value="" width="${form_PIC2_USER_NM_W}%" maxLength="${form_PIC2_USER_NM_M}" disabled="${form_PIC2_USER_NM_D}" readOnly="${form_PIC2_USER_NM_RO}" required="${form_PIC2_USER_NM_R}" style="${imeMode}" maskType="${form_PIC2_USER_NM_MT}" placeHolder="성명"/>
                </e:field>
            </e:row>
            <e:row>
                <e:label for="SEL_BUYER" title="">
                    <e:select id="SEL_BUYER" name="SEL_BUYER" value="" options="${selBuyerOptions}" width="${form_SEL_BUYER_W}" disabled="${form_SEL_BUYER_D}" readOnly="${form_SEL_BUYER_RO}" required="${form_SEL_BUYER_R}" placeHolder="" usePlaceHolder="false" maskType="${form_SEL_BUYER_MT}" />
                </e:label>
                <e:field>
                    <e:search id="BUYER_CD" name="BUYER_CD" value="${ses.companyCd}" width="${form_BUYER_CD_W}%" maxLength="${form_BUYER_CD_M}" onIconClick="${form_BUYER_CD_RO ? 'everCommon.blank' : 'onIconClickBUYER_CD'}" disabled="${form_BUYER_CD_D}" readOnly="${form_BUYER_CD_RO}" required="${form_BUYER_CD_R}" maskType="${form_BUYER_CD_MT}" placeHolder="회사코드" />
                    <e:inputText id="BUYER_NM" name="BUYER_NM" value="${ses.companyNm}" width="${form_BUYER_NM_W}%" maxLength="${form_BUYER_NM_M}" disabled="${form_BUYER_NM_D}" readOnly="${form_BUYER_NM_RO}" required="${form_BUYER_NM_R}" style="${imeMode}" maskType="${form_BUYER_NM_MT}" placeHolder="회사명"/>
                </e:field>
				<e:label for="sAP_USER_ID" title="${form_sAP_USER_ID_N}"/>
				<e:field>
					<e:search id="sAP_USER_ID" name="sAP_USER_ID" value="${ses.userId}" width="${form_sAP_USER_ID_W}%" maxLength="${form_sAP_USER_ID_M}" onIconClick="${form_sAP_USER_ID_RO ? 'everCommon.blank' : 'onIconClickAP_USER_ID'}" disabled="${form_sAP_USER_ID_D}" readOnly="${form_sAP_USER_ID_RO}" required="${form_sAP_USER_ID_R}" maskType="${form_sAP_USER_ID_MT}" placeHolder="개인번호" />
					<e:inputText id="sAP_USER_NM" name="sAP_USER_NM" value="${ses.userNm}" width="${form_sAP_USER_NM_W}%" maxLength="${form_sAP_USER_NM_M}" disabled="${form_sAP_USER_NM_D}" readOnly="${form_sAP_USER_NM_RO}" required="${form_sAP_USER_NM_R}" style="${imeMode}" maskType="${form_sAP_USER_NM_MT}" placeHolder="성명"/>
				</e:field>
				<e:label for="CTRL_USER_ID" title="${form_CTRL_USER_ID_N}"/>
				<e:field>
					<e:search id="CTRL_USER_ID" name="CTRL_USER_ID" value="" width="${form_CTRL_USER_ID_W}%" maxLength="${form_CTRL_USER_ID_M}" onIconClick="${form_CTRL_USER_ID_RO ? 'everCommon.blank' : 'onIconClickCTRL_USER_ID'}" disabled="${form_CTRL_USER_ID_D}" readOnly="${form_CTRL_USER_ID_RO}" required="${form_CTRL_USER_ID_R}" maskType="${form_CTRL_USER_ID_MT}" placeHolder="개인번호" />
					<e:inputText id="CTRL_USER_NM" name="CTRL_USER_NM" value="" width="${form_CTRL_USER_NM_W}%" maxLength="${form_CTRL_USER_NM_M}" disabled="${form_CTRL_USER_NM_D}" readOnly="${form_CTRL_USER_NM_RO}" required="${form_CTRL_USER_NM_R}" style="${imeMode}" maskType="${form_CTRL_USER_NM_MT}" placeHolder="성명"/>
				</e:field>
            </e:row>
        </e:searchPanel>

        <e:buttonBar width="100%" align="left">
        	<e:text style="color: blue;font-weight: bold;">■ ${form_AP_USER_NM_N} : </e:text>
            <e:inputText id="AP_USER_ID" name="AP_USER_ID" value="" width="${form_AP_USER_ID_W}" maxLength="${form_AP_USER_ID_M}" disabled="${form_AP_USER_ID_D}" readOnly="${form_AP_USER_ID_RO}" required="${form_AP_USER_ID_R}" style="${imeMode}" maskType="${form_AP_USER_ID_MT}"/>
            <e:search id="AP_USER_NM" name="AP_USER_NM" value="" width="${form_AP_USER_NM_W}" maxLength="${form_AP_USER_NM_M}" onIconClick="${form_AP_USER_NM_RO ? 'everCommon.blank' : 'onIconClickAP_USER_NM'}" disabled="${form_AP_USER_NM_D}" readOnly="${form_AP_USER_NM_RO}" required="${form_AP_USER_NM_R}" maskType="${form_AP_USER_NM_MT}" />
            <e:text> </e:text>
            <e:button id="doUpdateChange" name="doUpdateChange" align="left" label="${doUpdateChange_N}" onClick="doUpdateChange" disabled="${doUpdateChange_D}" visible="${doUpdateChange_V}"/>

            <div style="float: right;">
                <e:button id="doSearch" name="doSearch" label="${doSearch_N}" onClick="doSearch" disabled="${doSearch_D}" visible="${doSearch_V}"/>
                <%-- 2021.01.29 사용하지 않음으로 제외
                <e:button id="doReject" name="doReject" label="${doReject_N}" onClick="doReject" disabled="${doReject_D}" visible="${doReject_V}"/>
                --%>
                <e:button id="doApprovalPop" name="doApprovalPop" label="${doApprovalPop_N}" onClick="doApprovalPop" disabled="${doApprovalPop_D}" visible="${doApprovalPop_V}"/>
                <e:button id="doMultiApprovalPop" name="doMultiApprovalPop" label="${doMultiApprovalPop_N}" onClick="doMultiApprovalPop" disabled="${doMultiApprovalPop_D}" visible="${doMultiApprovalPop_V}"/>
                <e:button id="doUpdatePayReg" name="doUpdatePayReg" label="${doUpdatePayReg_N}" onClick="doUpdatePayReg" disabled="${doUpdatePayReg_D}" visible="${doUpdatePayReg_V}"/>
            </div>
        </e:buttonBar>

        <e:gridPanel id="grid" name="grid" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}" />
    </e:window>
</e:ui>
