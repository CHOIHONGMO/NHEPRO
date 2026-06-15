<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
    <script type="text/javascript">
        var gridPODT;
        var gridPOPC;
        var baseUrl = "/nhepro/CPOR/";
        var detailView  = "${param.detailView}" == "true";
        var PROGRESS_CD = "${empty formData.PROGRESS_CD ? param.PROGRESS_CD : formData.PROGRESS_CD}";

        function init() {
            gridPODT = EVF.C("gridPODT");   // 품목정보

            gridPODT.setProperty("shrinkToFit", ${shrinkToFit});
            gridPODT.setProperty("rowNumbers", ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
            gridPODT.setProperty("sortable", ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
            gridPODT.setProperty("panelVisible", ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            gridPODT.setProperty("enterToNextRow", ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            gridPODT.setProperty("acceptZero", ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            gridPODT.setProperty("multiSelect", ${param.detailView == true ? false : multiSelect});					// [선택] 컬럼의 사용여부를 지정한다. [true/false]
            gridPODT.setProperty("singleSelect", ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]

            gridPOPC = EVF.C("gridPOPC");   // 지불고객사

            gridPOPC.setProperty("shrinkToFit", ${shrinkToFit});
            gridPOPC.setProperty("rowNumbers", ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
            gridPOPC.setProperty("sortable", ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
            gridPOPC.setProperty("panelVisible", ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            gridPOPC.setProperty("enterToNextRow", ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            gridPOPC.setProperty("acceptZero", ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            gridPOPC.setProperty("multiSelect", false);					// [선택] 컬럼의 사용여부를 지정한다. [true/false]
            gridPOPC.setProperty("singleSelect", ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]

            gridPOPC.setColMerge(["PAY_CNT", "PAY_CNT_NM"]);

            gridPOPC.cellClickEvent(function(rowIdx, colIdx, value) {
                var param;

                if(colIdx == "RMK") {
                    param = {
                        title: gridPOPC.getColName(colIdx),
                        message: value,
                        callbackFunction: "callbackRMK",
                        rowIdx: rowIdx,
                        detailView: true
                    };

                    var url = "/common/popup/common_text_input/view.so";
                    everPopup.openModalPopup(url, 500, (param.detailView == true ? 300 : 320), param);
                }
                else if(colIdx == "PAY_USER_NM") {
                	param = {
                            callBackFunction: "callBackPAY_USER_NM",
                            CORP_TYPE : gridPOPC.getCellValue(rowIdx, "CORP_TYPE"),		// 법인구분
                            CUST_CD   : gridPOPC.getCellValue(rowIdx, "PY_BUYER_CD"),	// 지불고객사코드
                            READONLY  : "Y",		// 전체 ReadOnly
                            CUST_READONLY: "N",		// 고객사 ReadOnly
                            multiYN   : "N",
                            CTRL_CD   : "BR080",	// 정산담당자 권한
                            rowIdx    : rowIdx,
                            detailView: false
                        };
                    everPopup.openPopupByScreenId("CCDU0020", 1100, 700, param);
                }
            });

            gridPOPC.cellChangeEvent(function (rowIdx, colIdx, irow, icol, value, oldValue) {
                if(colIdx == "AP_REQ_AMT") {
                    if(value > gridPOPC.getCellValue(rowIdx, "PAY_AMT")) {
                        gridPOPC.setCellValue(rowIdx, colIdx, oldValue);
                        return EVF.alert("${CPOR0071_014}");
                    }

                    if(gridPOPC._gvo.getSummary(colIdx, "sum") > EVF.V("GR_AMT")) {
                        gridPOPC.setCellValue(rowIdx, colIdx, oldValue);
                        return EVF.alert("${CPOR0071_015}");
                    }

                    gridPOPC.setCellValue(rowIdx, "PAY_MINU_AMT", gridPOPC.getCellValue(rowIdx, "PAY_AMT") - value);
                } else if(colIdx == "PAY_REQ_DATE") {
                    var INV_DATE = EVF.V("GR_DATE");
                    if(INV_DATE != "") {
                        var diffDate_1 = new Date(INV_DATE.substring(0, 4), INV_DATE.substring(4, 6), INV_DATE.substring(6, 8));
                        var diffDate_2 = new Date(value.substring(0, 4), value.substring(4, 6), value.substring(6, 8));

                        var diff = Math.abs(diffDate_2.getTime() - diffDate_1.getTime());
                        diff = Math.ceil(diff / (1000 * 3600 * 24));

                        if(diff > 14) {
                            return EVF.alert("${CPOR0071_018}");
                        }
                    }
                }
            });
			
         	// ======================그리드 합계 구하기=======================
		    var val = {"visible": true, "count": 1, "height": 15};
		    gridPODT.setProperty('footerVisible', val);
		    
		    var footer = {
		          "styles": {
		              "textAlignment": "center",
		              "fontBold": true,
		              "fontFmaily": "Nanum Gothic",
		          },
		          "text": "합   계"
		    };
		    gridPODT.setRowFooter("PURCHASE_TYPE", footer);
		    
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
		    gridPODT.setRowFooter("PO_QT", distVal);
		    gridPODT.setRowFooter("INV_QT", distVal);
		    gridPODT.setRowFooter("SUM_GR_QT", distVal);
		    gridPODT.setRowFooter("INV_AMT", distVal);
		    gridPODT.setRowFooter("VAT_AMT", distVal);
		    gridPODT.setRowFooter("GR_QT", distVal);
		    gridPODT.setRowFooter("GR_AMT", distVal);
		    // ===========================================================
		    
		   	gridPOPC.setColGroup([
                {
                    "groupName": '대금지급정보',
                    "columns": ['PAY_USER_NM', 'PAY_USER_CHECK']
                }
                ,{
                    "groupName": '예산항목정보',
                    "columns": ['ACC_GWAN_CD', 'ACC_HNG_CD', 'ACC_MOK_CD', 'ACC_DET_CD']
                }
            ],50);
		    
         	// ======================그리드 합계 구하기=======================
		    var val = {"visible": true, "count": 1, "height": 15};
		    gridPOPC.setProperty('footerVisible', val);
		    
		    var footer = {
		          "styles": {
		              "textAlignment": "center",
		              "fontBold": true,
		              "fontFmaily": "Nanum Gothic",
		          },
		          "text": "합   계"
		    };
		    gridPOPC.setRowFooter("PAY_CNT_NM", footer);
		    
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
		    gridPOPC.setRowFooter("PAY_AMT", distVal);
		    gridPOPC.setRowFooter("AP_REQ_AMT", distVal);
		    gridPOPC.setRowFooter("PAY_MINU_AMT", distVal);
		    // ===========================================================
		    
            doSearchIVDT();
            doSearchPOPC();
        }

        function callbackRMK(data) {
            if(!EVF.isEmpty(data.message)) {
                gridPOPC.setCellValue(data.rowIdx, "RMK", data.message);
            }
        }

        function callBackPAY_USER_NM(data) {
            data = JSON.parse(data);
            gridPOPC.setCellValue(data.rowIdx, "PAY_USER_ID", data.USER_ID);
            gridPOPC.setCellValue(data.rowIdx, "PAY_USER_NM", data.USER_NM);
            gridPOPC.setCellValue(data.rowIdx, "PAY_USER_CHECK", "1");
        }

		/** 2021.04.28 로직 제외
        function onChangeINV_AMT() {
            EVF.V("INV_AMT", gridPODT._gvo.getSummary("INV_AMT", "sum"));

            var VAT_TYPE = EVF.V("VAT_TYPE");   // 1:부가세포함, 2:부가세별도, 0:부가세면제
            var INV_AMT  = EVF.V("INV_AMT");
            var VAT_AMT  = 0;
            if(VAT_TYPE == "1") {
                VAT_AMT = everMath.floor_float(INV_AMT / 11);
            }
			
            EVF.V("VAT_AMT", VAT_AMT);
        }*/
        
        function dateDiff(_date1, _date2) {
			var diffDate_1 = _date1 instanceof Date ? _date1 : new Date(_date1);
			var diffDate_2 = _date2 instanceof Date ? _date2 : new Date(_date2);

			//diffDate_1 = new Date(diffDate_1.getFullYear(), diffDate_1.getMonth()+1, diffDate_1.getDate());
			//diffDate_2 = new Date(diffDate_2.getFullYear(), diffDate_2.getMonth()+1, diffDate_2.getDate());

			var diff = Math.abs(diffDate_2.getTime() - diffDate_1.getTime());
			diff = Math.ceil(diff / (1000 * 3600 * 24));

			return diff;
		}
		
     	//2021.11.30일 지급요청일 => 검수일자 + 14일 default 설정
     	//2022.09.16 검수승인시 요청일부터 14일 이후일자로 승인할 경우 경고 알림창 추가
        function onChangeGR_DATE() {
        	var invDate = "";
        	var payReqDate = "";
        	var payDateFlag = false;
        	var INV_SEND_DATE = EVF.V("INV_SEND_DATE");
            var INV_DATE = EVF.V("GR_DATE");
            
            var sendDate = Number(INV_SEND_DATE.substring(0, 4)) + "/" + INV_SEND_DATE.substring(4, 6) + "/" + INV_SEND_DATE.substring(6, 8);
        	var invDate  = Number(INV_DATE.substring(0, 4)) + "/" + INV_DATE.substring(4, 6) + "/" + INV_DATE.substring(6, 8);
            var diff = dateDiff(sendDate, invDate);
            
            if(diff > 14) {
                EVF.confirm('검수요청일로부터 14일 이후 승인시 계약서 및 계약규정에 위배될수 있습니다', function() {
                	setReqDate();
            	});
            } else {
            	setReqDate();
            }
        }
     	
        function setReqDate(){
        	var invDate = "";
        	var payReqDate = "";
        	var payDateFlag = false;
            var INV_DATE = EVF.V("GR_DATE");
            
        	invDate = Number(INV_DATE.substring(0, 4)) + "/" + INV_DATE.substring(4, 6) + "/" + INV_DATE.substring(6, 8);
            payReqDate = date_add(invDate, 14);
            
            if(INV_DATE != "") {
                var allRowValue = gridPOPC.getAllRowValue();
                for(var i in allRowValue) {
                    var row = allRowValue[i];
                    var value = row.PAY_REQ_DATE;
                    if(value != "") {
                    	payDateFlag = true;
                    }
                }
            }
            
            if(payDateFlag){
            	EVF.confirm('지급요청일이 설정된 고객사별 지불고객사 정보가 있습니다.\n검수일자 14일을 가산하여 일괄적용 하시겠습니까?', function() {
            		setPayReqDate(payReqDate);
            	});
            } else {
            	var allRowId = gridPOPC.getAllRowId();
                for(var k in allRowId) {
                    var idx = allRowId[k];
                    gridPOPC.setCellValue(idx, 'PAY_REQ_DATE', payReqDate);
                }
            }
        }
        
        function setPayReqDate(payReqDate){
        	var allRowId = gridPOPC.getAllRowId();
            for(var i in allRowId) {
                var idx = allRowId[i];
                gridPOPC.setCellValue(idx, 'PAY_REQ_DATE', payReqDate);
            }
        }
        
        function date_add(sDate, nDays) {
		    var yy = parseInt(sDate.substr(0, 4), 10);
		    var mm = parseInt(sDate.substr(5, 2), 10);
		    var dd = parseInt(sDate.substr(8), 10);

		    d = new Date(yy, mm - 1, dd + nDays);

		    yy = d.getFullYear();
		    mm = d.getMonth() + 1; mm = (mm < 10) ? '0' + mm : mm;
		    dd = d.getDate(); dd = (dd < 10) ? '0' + dd : dd;

		    return '' + yy + mm + dd;
		}

        function doSearchIVDT() {
            var store = new EVF.Store();
            store.setGrid([gridPODT]);
            store.load(baseUrl + "cpor0071_doSearchIVDT.so", function() {
                var allRowId = gridPODT.getAllRowId();

                if(JSON.stringify(${gridSel}) != "" && JSON.stringify(${gridSel}) != undefined) {
                    var gridSel = JSON.parse('${gridSel}');

                    for(var i in allRowId) {
                        var row = allRowId[i];

                        for(var j in gridSel) {
                            if(gridPODT.getCellValue(row, "INV_SQ") == gridSel[j].INV_SQ) {
                                gridPODT.setCellValue(row, "GR_QT", gridSel[j].GR_QT, false);
                                gridPODT.setCellValue(row, "GR_AMT", gridPODT.getCellValue(row, "GR_QT") * gridPODT.getCellValue(row, "UNIT_PRC"), false);
                            }
                        }
                    }
                } else {
                    for(var k in allRowId) {
                        var rowK = allRowId[k];

                        gridPODT.setCellValue(rowK, "GR_AMT", gridPODT.getCellValue(rowK, "GR_QT") * gridPODT.getCellValue(rowK, "UNIT_PRC"), false);
                    }
                }

                EVF.V("GR_AMT", gridPODT._gvo.getSummary("GR_AMT", "sum"));
            });
        }

        function doSearchPOPC() {
            var store = new EVF.Store();
            store.setGrid([gridPOPC]);
            store.load(baseUrl + "cpor0071_doSearchPOPC.so", function() {
                var allRowId = gridPOPC.getAllRowId();

                for(var i in allRowId) {
                    var rowIdx = allRowId[i];

                    gridPOPC.setCellValue(rowIdx, "PAY_MINU_AMT", gridPOPC.getCellValue(rowIdx, "PAY_AMT") - gridPOPC.getCellValue(rowIdx, "AP_REQ_AMT"));
                }
            });
        }

        function doUpdateApproval() {
            var store = new EVF.Store();
            if(!store.validate()) { return; }
            if(!gridPOPC.validate(true).flag) {
            	return EVF.alert(gridPOPC.validate().msg);
            }
			
         	// 2021.04.28 추가
            // 검수일자 >= 검수요청일자
            var INV_DATE = EVF.V("GR_DATE");
            if( Number(EVF.V("INV_SEND_DATE")) > Number(INV_DATE) ) {
            	return EVF.alert("검수일자는 검수요청일자 이후로 선택해야 합니다.");
            }
            
            // 2021.04.28 추가
            // 지급요청일자 >= 검수일자
            var allRowValue = gridPOPC.getAllRowValue();
            for(var i in allRowValue) {
                var row = allRowValue[i];
                if( Number(INV_DATE) > Number(row.PAY_REQ_DATE) ) {
                	return EVF.alert("[고객사별 지불고객사 정보]의 '지급요청일자'는 '검수일자 이후'로 선택해야 합니다.");
                }
                
                if( row.PAY_USER_CHECK != "1" ) {
                	return EVF.alert("[고객사별 지불고객사 정보]의 '정산담당자 확인여부'가 체크되지 않았습니다.");
                }
            }
            
            if(gridPOPC._gvo.getSummary("AP_REQ_AMT", "sum") != EVF.V("GR_AMT")) {
                return EVF.alert("${CPOR0071_016}");
            }
			
            var preSignStatus = EVF.V("PRE_SIGN_STATUS");
            if (preSignStatus != "E") {
                EVF.V('SIGN_STATUS', "P");
            }
			
            var subject = "거래명세서[" + EVF.V("INV_NUM") + "] 결재요청";
            //EVF.confirm("${msg.M0053}", function () {
            var param = {
                subject: subject,
                docType: EVF.V("DOC_TYPE"),
                signStatus: "P",
                screenId: "CPOR0071",
                approvalType: "APPROVAL",
                attFileNum: "",
                docNum: EVF.V("INV_NUM"),
                appDocNum: EVF.V("APP_DOC_NUM"),
                callBackFunction: "goApproval",
                appAmt: EVF.V("GR_AMT")
            };
            everPopup.openApprovalRequestIPopup(param);
            //});
        }

        function goApproval(formData, gridData, attachData) {
            EVF.V("approvalFormData", formData);
            EVF.V("approvalGridData", gridData);
            EVF.V("attachFileDatas", attachData);

            var store = new EVF.Store();
            if(!store.validate()) { return; }

            store.setGrid([gridPODT, gridPOPC]);
            store.getGridData(gridPODT, "all");
            store.getGridData(gridPOPC, "all");
            store.doFileUpload(function () {
                store.load(baseUrl + "cpor0071_doUpdateApproval.so", function() {
                    opener.doSearch();
                    EVF.alert(this.getResponseMessage(), function () {
                        doClose();
                    });
                });
            });
        }
		
     	// 2021.01.28 반송 추가
        function doReject() {
            
            var param = {
					title: "반송사유",
					message: EVF.V("REJECT_RMK"),
					callbackFunction: "setReReqReason",
					detailView: false
				};
				url = "/common/popup/common_text_input/view.so";
			everPopup.openModalPopup(url, 500, 320, param);
        }
     	
        function setReReqReason(data) {
        	var store = new EVF.Store();
            
        	if( data == null || data.message.trim() == "" ) {
        		return EVF.alert("반송사유가 입력되지 않았습니다.");
        	}
        	
        	EVF.V('REJECT_RMK', data.message);
            EVF.confirm("${CPOR0071_019}", function () {
                store.load(baseUrl + "cpor0071_doReject.so", function() {
                    opener.doSearch();
                    EVF.alert(this.getResponseMessage(), function () {
                        doClose();
                    });
                });
            });
	    }
        
     	// 2021.11.24 파일저장 추가
        function doFileSave() {
        	var store = new EVF.Store();
        	
        	EVF.confirm("${CPOR0071_021}", function () {
	            store.doFileUpload(function () {
	                store.load(baseUrl + "cpor0071_doUpdateFileInfo.so", function() {
	                	var buyerCd = this.getParameter("BUYER_CD");
						var invNum  = this.getParameter("INV_NUM");
	                	var param = {
	                            BUYER_CD: buyerCd,
	                            INV_NUM : invNum,
	                            detailView: true
	                        };
	                	window.location.href = '/nhepro/CPOR/CPOR0071/view.so?' + $.param(param);
	                });
	            });
        	});
        }
     	
        function doClose() {
            EVF.closeWindow();
        }
    </script>

    <e:window id="CPOR0071" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">
        <e:buttonBar width="100%" align="right" title="${CPOR0071_001}">
        	<!-- 2021.01.28 반송 추가 -->
        	<e:button id="doReject" name="doReject" label="${doReject_N}" onClick="doReject" disabled="${doReject_D}" visible="${doReject_V}"/>
            <e:button id="doUpdateApproval" name="doUpdateApproval" label="${doUpdateApproval_N}" onClick="doUpdateApproval" disabled="${doUpdateApproval_D}" visible="${doUpdateApproval_V}"/>
            <e:button id="doClose" name="doClose" label="${doClose_N}" onClick="doClose" disabled="${doClose_D}" visible="${doClose_V}"/>
        </e:buttonBar>

        <e:inputHidden id="PO_NUM" name="PO_NUM" value="${formData.PO_NUM}"/>
        <e:inputHidden id="BUYER_CD" name="BUYER_CD" value="${formData.BUYER_CD}"/>
        <e:inputHidden id="DEPT_CD" name="DEPT_CD" value="${formData.DEPT_CD}"/>
        <e:inputHidden id="PIC_USER_ID" name="PIC_USER_ID" value="${formData.PIC_USER_ID}"/>
        <e:inputHidden id="RMK_TEXT_NUM" name="RMK_TEXT_NUM" value="${formData.RMK_TEXT_NUM }" />
        <e:inputHidden id="CTRL_USER_ID" name="CTRL_USER_ID" value="${formData.CTRL_USER_ID }" />
        <e:inputHidden id="INSPECT_USER_ID" name="INSPECT_USER_ID" value="${formData.INSPECT_USER_ID }" />
        <e:inputHidden id="OLD_INV_AMT" name="OLD_INV_AMT" value="${formData.INV_AMT }" />
        <e:inputHidden id="OLD_VAT_AMT" name="OLD_VAT_AMT" value="${formData.VAT_AMT }" />
        <e:inputHidden id="VAT_AMT" name="VAT_AMT" value="${formData.VAT_AMT }" />
        <e:inputHidden id="INSU_STATUS" name="INSU_STATUS" value="${formData.INSU_STATUS }" />
        <e:inputHidden id="INV_DATE" name="INV_DATE" value="${formData.INV_DATE }" />
        <e:inputHidden id="PROGRESS_CD" name="PROGRESS_CD" value="${formData.PROGRESS_CD }" />
        <e:inputHidden id="PAY_CNT_AMT" name="PAY_CNT_AMT" />
        <e:inputHidden id="PAY_CNT" name="PAY_CNT" value="${formData.PAY_CNT }" />
        <e:inputHidden id="approvalFormData" name="approvalFormData"/>
        <e:inputHidden id="approvalGridData" name="approvalGridData"/>
        <e:inputHidden id="attachFileDatas" name="attachFileDatas" visible="false"/>
        <e:inputHidden id='APP_DOC_NUM' name="APP_DOC_NUM" value="${empty param.appDocNum ? formData.APP_DOC_NUM : param.appDocNum}" />
        <e:inputHidden id='APP_DOC_CNT' name="APP_DOC_CNT" value="${formData.APP_DOC_CNT}" />
        <e:inputHidden id='PRE_SIGN_STATUS' name="PRE_SIGN_STATUS" value="${formData.SIGN_STATUS}" />
        <e:inputHidden id='SIGN_STATUS' name="SIGN_STATUS" value="${formData.SIGN_STATUS}" />
        <e:inputHidden id="DOC_TYPE" name="DOC_TYPE" value="DINV"/>
        <e:inputHidden id="PAY_TERMS" name="PAY_TERMS" value="${formData.PAY_TERMS}"/>
		<!-- 2021.01.28 : 반송사유 추가 -->
        <e:inputHidden id="REJECT_RMK" name="REJECT_RMK" value="${formData.REJECT_RMK}"/>
        <e:inputHidden id="DELIVERY_TYPE" name="DELIVERY_TYPE" value="${formData.DELIVERY_TYPE}"/>
        
		<%--일반정보--%>
        <e:searchPanel id="sp" title="${form_CAPTION_N}" labelWidth="${labelWidth}" useTitleBar="false" width="100%" columnCount="2" onEnter="">
            <e:row>
                <e:label for="INV_NUM" title="${form_INV_NUM_N}" />
                <e:field>
                    <e:inputText id="INV_NUM" name="INV_NUM" value="${formData.INV_NUM}" width="${form_INV_NUM_W}" maxLength="${form_INV_NUM_M}" disabled="${form_INV_NUM_D}" readOnly="${form_INV_NUM_RO}" required="${form_INV_NUM_R}" style="${imeMode}" maskType="${form_INV_NUM_MT}"/>
                </e:field>
                <e:label for="PO_CREATE_TYPE" title="${form_PO_CREATE_TYPE_N}"/>
                <e:field>
                    <e:select id="PO_CREATE_TYPE" name="PO_CREATE_TYPE" value="${formData.PO_CREATE_TYPE}" options="${poCreateTypeOptions}" width="${form_PO_CREATE_TYPE_W}" disabled="${form_PO_CREATE_TYPE_D}" readOnly="${form_PO_CREATE_TYPE_RO}" required="${form_PO_CREATE_TYPE_R}" placeHolder="" maskType="${form_PO_CREATE_TYPE_MT}" />
                </e:field>
            </e:row>

            <e:row>
                <e:label for="VENDOR_CD" title="${form_VENDOR_CD_N}" />
                <e:field>
                    <e:inputText id="VENDOR_CD" name="VENDOR_CD" value="${formData.VENDOR_CD}" width="${form_VENDOR_CD_W}" maxLength="${form_VENDOR_CD_M}" disabled="${form_VENDOR_CD_D}" readOnly="${form_VENDOR_CD_RO}" required="${form_VENDOR_CD_R}" style="${imeMode}" maskType="${form_VENDOR_CD_MT}"/>
                    <e:text>&nbsp;</e:text>
                    <e:inputText id="VENDOR_NM" name="VENDOR_NM" value="${formData.VENDOR_NM}" width="${form_VENDOR_NM_W}" maxLength="${form_VENDOR_NM_M}" disabled="${form_VENDOR_NM_D}" readOnly="${form_VENDOR_NM_RO}" required="${form_VENDOR_NM_R}" style="${imeMode}" maskType="${form_VENDOR_NM_MT}"/>
                </e:field>
                <e:label for="PIC_USER_NM" title="${form_PIC_USER_NM_N}" />
                <e:field>
                    <e:inputText id="PIC_USER_NM" name="PIC_USER_NM" value="${formData.PIC_USER_NM}" width="${form_PIC_USER_NM_W}" maxLength="${form_PIC_USER_NM_M}" disabled="${form_PIC_USER_NM_D}" readOnly="${form_PIC_USER_NM_RO}" required="${form_PIC_USER_NM_R}" style="${imeMode}" maskType="${form_PIC_USER_NM_MT}"/>
                </e:field>
            </e:row>

            <e:row>
                <e:label for="PIC_TEL_NUM" title="${form_PIC_TEL_NUM_N}" />
                <e:field>
                    <e:inputText id="PIC_TEL_NUM" name="PIC_TEL_NUM" value="${formData.PIC_TEL_NUM}" width="${form_PIC_TEL_NUM_W}" maxLength="${form_PIC_TEL_NUM_M}" disabled="${form_PIC_TEL_NUM_D}" readOnly="${form_PIC_TEL_NUM_RO}" required="${form_PIC_TEL_NUM_R}" style="${imeMode}" maskType="${form_PIC_TEL_NUM_MT}"/>
                </e:field>
                <e:label for="PIC_CELL_NUM" title="${form_PIC_CELL_NUM_N}" />
                <e:field>
                    <e:inputText id="PIC_CELL_NUM" name="PIC_CELL_NUM" value="${formData.PIC_CELL_NUM}" width="${form_PIC_CELL_NUM_W}" maxLength="${form_PIC_CELL_NUM_M}" disabled="${form_PIC_CELL_NUM_D}" readOnly="${form_PIC_CELL_NUM_RO}" required="${form_PIC_CELL_NUM_R}" style="${imeMode}" maskType="${form_PIC_CELL_NUM_MT}"/>
                </e:field>
            </e:row>

            <e:row>
                <e:label for="CUR" title="${form_CUR_N}"/>
                <e:field>
                    <e:select id="CUR" name="CUR" value="${formData.CUR}" options="${curOptions}" width="${form_CUR_W}" disabled="${form_CUR_D}" readOnly="${form_CUR_RO}" required="${form_CUR_R}" placeHolder="" maskType="${form_CUR_MT}" />
                </e:field>
                <e:label for="VAT_TYPE" title="${form_VAT_TYPE_N}"/>
                <e:field>
                    <e:select id="VAT_TYPE" name="VAT_TYPE" value="${formData.VAT_TYPE}" options="${vatTypeOptions}" width="${form_VAT_TYPE_W}" disabled="${form_VAT_TYPE_D}" readOnly="${form_VAT_TYPE_RO}" required="${form_VAT_TYPE_R}" placeHolder="" maskType="${form_VAT_TYPE_MT}" />
                </e:field>
            </e:row>

            <e:row>
                <e:label for="INV_AMT" title="${form_INV_AMT_N}"/>
                <e:field>
                    <e:inputNumber id="INV_AMT" name="INV_AMT" value="${formData.INV_AMT}" width="${form_INV_AMT_W}" maxValue="${form_INV_AMT_M}" decimalPlace="${form_INV_AMT_NF}" disabled="${form_INV_AMT_D}" readOnly="${form_INV_AMT_RO}" required="${form_INV_AMT_R}" onNumberKr="${form_INV_AMT_KR}" currencyText="${form_INV_AMT_CT}"/>
                </e:field>
                <e:label for="GR_AMT" title="${form_GR_AMT_N}"/>
                <e:field>
                    <e:inputNumber id="GR_AMT" name="GR_AMT" value="${formData.GR_AMT}" width="${form_GR_AMT_W}" maxValue="${form_GR_AMT_M}" decimalPlace="${form_GR_AMT_NF}" disabled="${form_GR_AMT_D}" readOnly="${form_GR_AMT_RO}" required="${form_GR_AMT_R}" onNumberKr="${form_GR_AMT_KR}" currencyText="${form_GR_AMT_CT}"/>
                </e:field>
            </e:row>

            <e:row>
                <e:label for="INV_SEND_DATE" title="${form_INV_SEND_DATE_N}"/>
                <e:field>
                    <e:inputDate id="INV_SEND_DATE" name="INV_SEND_DATE" value="${formData.INV_SEND_DATE}" width="${inputDateWidth}" datePicker="true" required="${form_INV_SEND_DATE_R}" disabled="${form_INV_SEND_DATE_D}" readOnly="${form_INV_SEND_DATE_RO}" />
                </e:field>
                <e:label for="GR_DATE" title="${form_GR_DATE_N}"/>
                <e:field>
                    <e:inputDate id="GR_DATE" name="GR_DATE" fromDate="INV_SEND_DATE" value="${formData.GR_DATE}" width="${inputDateWidth}" datePicker="true" required="${form_GR_DATE_R}" disabled="${form_GR_DATE_D}" readOnly="${form_GR_DATE_RO}" onChange="onChangeGR_DATE" />
                </e:field>
            </e:row>

            <e:row>
                <e:label for="RMK_TEXT_NUM" title="${form_RMK_TEXT_NUM_N}" />
                <e:field colSpan="3">
                    <e:richTextEditor id="RMK_TEXT" name="RMK_TEXT" value="${formData.RMK_TEXT}" width="${form_RMK_TEXT_NUM_W}" height="200px" disabled="${form_RMK_TEXT_NUM_D}" readOnly="${form_RMK_TEXT_NUM_RO}" required="${form_RMK_TEXT_NUM_R}" style="${imeMode}"/>
                </e:field>
            </e:row>

            <e:row>
                <e:label for="C_ATT_FILE_NUM" title="${form_C_ATT_FILE_NUM_N}" >
                	<br><br>
                	<e:button id="doFileSave" name="doFileSave" label="${doFileSave_N}" onClick="doFileSave" disabled="${((param.detailView == true) and (formData.INSPECT_USER_ID eq ses.userId) and !(formData.AP_STATUS eq '70')) ? false : true}" visible="${((param.detailView == true) and (formData.INSPECT_USER_ID eq ses.userId) and !(formData.AP_STATUS eq '70')) ? true : false}"/>
                </e:label>
                <e:field>
                    <e:fileManager id="C_ATT_FILE_NUM" name="C_ATT_FILE_NUM" width="${form_C_ATT_FILE_NUM_W}" height="100px" fileId="${formData.C_ATT_FILE_NUM}" bizType="OM" readOnly="${((formData.INSPECT_USER_ID eq ses.userId) and !(formData.AP_STATUS eq '70')) ? false : true}" required="${form_C_ATT_FILE_NUM_R}"/>
                </e:field>
                <e:label for="ATT_FILE_NUM" title="${form_ATT_FILE_NUM_N}" />
                <e:field>
                    <e:fileManager id="ATT_FILE_NUM" name="ATT_FILE_NUM" width="${form_ATT_FILE_NUM_W}" height="100px" fileId="${formData.ATT_FILE_NUM}" bizType="OM" readOnly="${form_ATT_FILE_NUM_RO}" required="${form_ATT_FILE_NUM_R}"/>
                </e:field>
            </e:row>
        </e:searchPanel>

        <%--품목정보--%>
        <e:buttonBar width="100%" align="right" title="${CPOR0071_002}">
            <e:button id="doDeleteItem" name="doDeleteItem" label="${doDeleteItem_N}" onClick="doDeleteItem" disabled="${doDeleteItem_D}" visible="${doDeleteItem_V}"/>
        </e:buttonBar>
        <e:gridPanel id="gridPODT" name="gridPODT" width="100%" height="250px" gridType="${_gridType}" readOnly="${param.detailView}" />

        <%--지불고객사--%>
        <e:buttonBar width="100%" align="right" title="${CPOR0071_017}"/>
        <e:gridPanel id="gridPOPC" name="gridPOPC" width="100%" height="250px" gridType="${_gridType}" readOnly="${param.detailView}" />

        <%-- 결재자 리스트 Include --%>
        <jsp:include page="/WEB-INF/views/nhepro/CWOR/CWOR0013.jsp" flush="true" >
            <jsp:param value="${formData.APP_DOC_NUM}" name="APP_DOC_NUM"/>
            <jsp:param value="${formData.APP_DOC_CNT}" name="APP_DOC_CNT"/>
            <jsp:param value="${formData.BUYER_CD}" name="BUYER_CD"/>
        </jsp:include>
    </e:window>
</e:ui>