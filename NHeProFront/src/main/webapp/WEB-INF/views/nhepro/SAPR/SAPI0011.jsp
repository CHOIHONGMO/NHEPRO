<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
    <script type="text/javascript" src="/MagicLine4Web/ML4Web/js/ext/jquery.blockUI.js"></script>
    <script type="text/javascript" src="/MagicLine4Web/ML4Web/js/ext/ML_Config.js"></script>

    <script type="text/javascript">
        var gridPODT;
        var gridIVAP;
        var baseUrl = "/nhepro/SAPR/";
        var detailView  = "${param.detailView}" == "true";
        var PROGRESS_CD = "${empty formData.SIGN_STATUS ? param.SIGN_STATUS : formData.SIGN_STATUS}";
        var STATUS = "${param.STATUS}";
        var localServerFlag = "${localServerFlag}";
        
        function init() {
            gridIVAP = EVF.C("gridIVAP");   // 대금지급요청 이력

            gridIVAP.setProperty("shrinkToFit", ${shrinkToFit});
            gridIVAP.setProperty("rowNumbers", ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
            gridIVAP.setProperty("sortable", ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
            gridIVAP.setProperty("panelVisible", ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            gridIVAP.setProperty("enterToNextRow", ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            gridIVAP.setProperty("acceptZero", ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            gridIVAP.setProperty("multiSelect", false);					// [선택] 컬럼의 사용여부를 지정한다. [true/false]
            gridIVAP.setProperty("singleSelect", ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]

            gridPODT = EVF.C("gridPODT");   // 품목정보

            gridPODT.setProperty("shrinkToFit", ${shrinkToFit});
            gridPODT.setProperty("rowNumbers", ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
            gridPODT.setProperty("sortable", ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
            gridPODT.setProperty("panelVisible", ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            gridPODT.setProperty("enterToNextRow", ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            gridPODT.setProperty("acceptZero", ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            gridPODT.setProperty("multiSelect", ${param.detailView == true ? false : multiSelect});					// [선택] 컬럼의 사용여부를 지정한다. [true/false]
            gridPODT.setProperty("singleSelect", ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]

            gridPODT.cellChangeEvent(function (rowIdx, colIdx, irow, icol, value, oldValue) {
            });
			
            if(detailView) {
                doSearchIVDT();
            } else {
                if( EVF.isEmpty(PROGRESS_CD) ) {
                    doSearchIVDT();
                    EVF.C("doDelete").setDisabled(true);
                } else {
                    doSearchIVDT(); // 작성중(10), 반려(40)
                }
            }

            EVF.C("PAY_ACCOUNT_NUM").setDisabled(true);
            EVF.C("AP_REQ_SUBJECT").setStyle("color:#FF0000;font-weight:bold;");
            EVF.C("PAY_INFO").setStyle("color:#FF0000;font-weight:bold;");
            EVF.C("PAY_AMT").setStyle("color:#FF0000;font-weight:bold;");
			
            // 자동조회
            doSearchIVAP();
        }

        function onIconClickPAY_BANK_NM() {
            var	param =	{
                callBackFunction: "callBackPAY_BANK_NM",
                VENDOR_CD: "${ses.companyCd}",
                'detailView': false
            };
            //everPopup.openCommonPopup(param, 'SP0126');
            
            everPopup.openPopupByScreenId("SAPR0030", 800, 450, param);
        }

        function callBackPAY_BANK_NM(data) {
        	
        	data = JSON.parse(data); 
        	EVF.V("PAY_ACC_NM", data.PAY_ACC_NM);
        	EVF.V("PAY_BANK_NM", data.PAY_BANK_NM);
            EVF.V("PAY_ACCOUNT_NUM", data.PAY_ACCOUNT_NUM);
            EVF.V("PAY_BANK", data.PAY_BANK);
            EVF.V("PAY_ATT_FILE_NUM", data.PAY_ATT_FILE_NUM);
            EVF.V("PAY_ATT_FILE_CNT", data.PAY_ATT_FILE_NUM_CNT);
        }
        
        function onIconClickPAY_ATT_FILE_CNT() {
            var param = {
                bizType: "OM",
                attFileNum: EVF.V("PAY_ATT_FILE_NUM"),
                callBackFunction: "callBackPAY_ATT_FILE_CNT",
                detailView: (EVF.isEmpty(STATUS) || STATUS=="10" || STATUS=="40") ? false : true
            };

            everPopup.fileAttachPopup(param);
        }
        
        function callBackPAY_ATT_FILE_CNT(a, b, c) {
            EVF.V("PAY_ATT_FILE_NUM", b);
            EVF.V("PAY_ATT_FILE_CNT", c);
        }

        function onIconClickBILL_ATT_FILE_CNT() {
        	//2024.3.11 중앙회IT전략본부 요청
        	//대금지급요청서 세금계산서 파일 추가 전 농협중앙회 대표자명 변경으로인한 세금계산서 발행전 대표자명 변경을 위한 Confirm창 추가
        	EVF.confirm("세금계산서 발행시 대표자명을 [강호동]으로 발행하여 주시기를 바랍니다.\n\n변경대상\n\n- 사업자번호 : 214-82-06195(농협중앙회 IT전략본부)\n\n- 사업자번호 : 104-82-07072(농협중앙회 정보보호부)\n\n***농협중앙회 IT전략본부, 정보보호부 외 청구분은 변경사항 없음***", function() {
	            var param = {
	                bizType: "OM",
	                attFileNum: EVF.V("BILL_ATT_FILE_NUM"),
	                callBackFunction: "callBackBILL_ATT_FILE_CNT",
	                detailView: false
	            };
	
	            everPopup.fileAttachPopup(param);
        	});
        }
        
        function callBackBILL_ATT_FILE_CNT(a, b, c) {
            EVF.V("BILL_ATT_FILE_NUM", b);
            EVF.V("BILL_ATT_FILE_CNT", c);
        }
		
        function doSearchIVAP() {
            var store = new EVF.Store();
            store.setGrid([gridIVAP]);
            store.load(baseUrl + "sapi0011_doSearchIVAP.so", function() {
            });
        }

        function doSearchIVDT() {
            var store = new EVF.Store();
            store.setGrid([gridPODT]);
            store.load(baseUrl + "sapi0011_doSearchIVDT.so", function() {
            });
        }

        function doSave(s) {
            var store = new EVF.Store();
            if(!store.validate()) { return; }
			
            if( EVF.V("PAY_ATT_FILE_CNT") == "0" ) {
            	return EVF.alert("입금계좌사본 파일 첨부는 필수 입니다."); 
            }
            
         	// 2021.04.28 추가
            // 세금계산서 작성일 >= 검수일자
            if( Number(EVF.V("INV_DATE")) > Number(EVF.V("BILL_DATE")) ) {
            	return EVF.alert("${SAPI0011_018}"); // 세금계산서 작성일은 검수일자 이후로 선택하세요.
            }
            
            EVF.confirm("${SAPI0011_004}", function () {
                EVF.C("doDelete").setDisabled(false);

                store.setGrid([gridPODT]);
                store.getGridData(gridPODT, "all");
                store.doFileUpload(function () {
                    store.load(baseUrl + "sapi0011_doSave.so", function(){
                        var buyerCd   = this.getParameter("BUYER_CD");
    					var apNum     = this.getParameter("AP_NUM");
    					var pyBuyerCd = this.getParameter("PY_BUYER_CD");
    					var pyDeptCd  = this.getParameter("PY_DEPT_CD");
    					
                        EVF.alert(this.getResponseMessage(), function() {
                        	var param = {
        							BUYER_CD: buyerCd,
        							AP_NUM: apNum,
        							PY_BUYER_CD: pyBuyerCd,
        							PY_DEPT_CD: pyDeptCd,
        							detailView: false,
        			                buttonView: true
        						};
                            window.location.href = '/nhepro/SAPR/SAPI0011/view.so?' + $.param(param);
                            
                            if(opener) {
                                opener.doSearch();
                                //doClose();
                            }
                        });
                    });
                });
            });
        }

        function doSaveGuarantee() {
            var store = new EVF.Store();
            if(!store.validate()) { return; }

            if(EVF.V("GUAR_TYPE") == "") {
                return EVF.alert("${SAPI0011_017}");
            }

            if(EVF.V("GUAR_TYPE2") != "20") {
                return EVF.alert("${SAPI0011_015}");
            }

            EVF.confirm("${SAPI0011_014}", function () {
                EVF.C("doDelete").setDisabled(false);

                store.setGrid([gridPODT]);
                store.getGridData(gridPODT, "all");
                store.doFileUpload(function () {
                    store.load(baseUrl + "sapi0011_doSaveGuarantee.so", function(){
                        var AP_NUM = this.getParameter("AP_NUM");
                        EVF.alert(this.getResponseMessage(), function() {
                            if(opener) {
                                opener.doSearch();
                                doClose();
                            }
                        });
                    });
                });
            });
        }

        function doSend() {
            var store = new EVF.Store();
            if(!store.validate()) { return; }
			
            if( EVF.V("PAY_ATT_FILE_CNT") == "0" ) {
            	return EVF.alert("입금계좌사본 파일 첨부는 필수 입니다."); 
            }
            
         	// 2021.04.28 추가
            // 세금계산서 작성일 >= 검수일자
            if( Number(EVF.V("INV_DATE")) > Number(EVF.V("BILL_DATE")) ) {
            	return EVF.alert("${SAPI0011_018}"); // 세금계산서 작성일은 검수일자 이후로 선택하세요.
            }
            
            EVF.confirm("${SAPI0011_005}", function () {
            	if(localServerFlag == "Y") {
            		doSendGo();
				}
            	else {
	                document.reqForm.signData.value = EVF.V("VENDOR_CD") + "@@" + document.reqForm.idn.value + "@@" + EVF.V("PAY_AMT") + "@@" + "${signDate}";
					
	                var certOdiFilter = "${certOidfilter}";
	                var listOdiArr = certOdiFilter.split(";");
	                var certOidfilter = "";
	                for(var i in listOdiArr) {
	                    certOidfilter = certOidfilter + listOdiArr[i] + ",";
	                }
					
	                certOidfilter = certOidfilter.substring(0, certOidfilter.length-1);
	                magicline.uiapi.MakeSignData(document.reqForm, null, mlCallBack, certOidfilter);
				}
            });
        }

        function mlCallBack(code, message){
            if(code == 0){ <%-- 정상메시지 --%>
                if (message.encMsg != null) { document.reqForm.signedData.value = encodeURIComponent(message.encMsg); }
                if (message.vidRandom != null) { document.reqForm.vidRandom.value = encodeURIComponent(message.vidRandom); }
                doSendGo();
            }
            else {
                return EVF.alert("결과값 수신에 실패하였습니다.");
            }
        }

        function doSendGo() {
            var store = new EVF.Store();
            store.setGrid([gridPODT]);
            store.getGridData(gridPODT, "all");
            store.setParameter("signedData", document.reqForm.signedData.value);
            store.setParameter("vidRandom", document.reqForm.vidRandom.value);
            store.setParameter("idn", document.reqForm.idn.value);
            store.doFileUpload(function () {
                store.load(baseUrl + "sapi0011_doSend.so", function(){
                    EVF.alert(this.getResponseMessage(), function() {
                        if(opener) {
                            opener.doSearch();
                            doClose();
                        }
                    });
                });
            });
        }

        function doDelete() {
            var store = new EVF.Store();
            EVF.confirm("${SAPI0011_006}", function () {
                store.setGrid([gridPODT]);
                store.getGridData(gridPODT, "all");
                store.doFileUpload(function () {
                    store.load(baseUrl + "sapi0011_doDelete.so", function(){
                        EVF.alert(this.getResponseMessage(), function() {
                            if(opener) {
                                opener.doSearch();
                                doClose();
                            }
                        });
                    });
                });
            });
        }

        function doClose() {
            EVF.closeWindow();
        }
    </script>

    <e:window id="SAPI0011" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">
        <e:buttonBar width="100%" align="right" title="${SAPI0011_001}">
            <e:button id="doSave" name="doSave" label="${doSave_N}" onClick="doSave" disabled="${doSave_D}" visible="${doSave_V}"/>
            <e:button id="doSend" name="doSend" label="${doSend_N}" onClick="doSend" disabled="${doSend_D}" visible="${doSend_V}"/>
            <e:button id="doDelete" name="doDelete" label="${doDelete_N}" onClick="doDelete" disabled="${doDelete_D}" visible="${doDelete_V}"/>
            <e:button id="doClose" name="doClose" label="${doClose_N}" onClick="doClose" disabled="${doClose_D}" visible="${doClose_V}"/>
        </e:buttonBar>

        <e:inputHidden id="BUYER_CD" name="BUYER_CD" value="${formData.BUYER_CD}"/>
        <e:inputHidden id="DEPT_CD" name="DEPT_CD" value="${formData.DEPT_CD}"/>
        <e:inputHidden id="PIC_USER_ID" name="PIC_USER_ID" value="${formData.PIC_USER_ID}"/>
        <e:inputHidden id="RMK_TEXT_NUM" name="RMK_TEXT_NUM" value="${formData.RMK_TEXT_NUM }" />
        <e:inputHidden id="CTRL_USER_ID" name="CTRL_USER_ID" value="${formData.CTRL_USER_ID }" />
        <e:inputHidden id="INSPECT_USER_ID" name="INSPECT_USER_ID" value="${formData.INSPECT_USER_ID }" />
        <e:inputHidden id="OLD_INV_AMT" name="OLD_INV_AMT" value="${formData.INV_AMT }" />
        <e:inputHidden id="OLD_VAT_AMT" name="OLD_VAT_AMT" value="${formData.VAT_AMT }" />
        <e:inputHidden id="INSU_STATUS" name="INSU_STATUS" value="${formData.INSU_STATUS }" />
        <e:inputHidden id="PAY_CNT_AMT" name="PAY_CNT_AMT" />
        <e:inputHidden id="PY_BUYER_CD" name="PY_BUYER_CD" value="${formData.PY_BUYER_CD }" />
        <e:inputHidden id="PY_DEPT_CD" name="PY_DEPT_CD" value="${formData.PY_DEPT_CD }" />
        <e:inputHidden id="PAY_ACC_NM" name="PAY_ACC_NM" value="${formData.PAY_ACC_NM }" />
        <e:inputHidden id="PAY_BANK" name="PAY_BANK" value="${formData.PAY_BANK }" />
        <e:inputHidden id="PAY_ATT_FILE_NUM" name="PAY_ATT_FILE_NUM" value="${formData.PAY_ATT_FILE_NUM }" />
        <e:inputHidden id="BILL_ATT_FILE_NUM" name="BILL_ATT_FILE_NUM" value="${formData.BILL_ATT_FILE_NUM }" />
        <e:inputHidden id="GUAR_RMK" name="GUAR_RMK" value="${formData.GUAR_RMK }" />
        <e:inputHidden id="PAY_CNT" name="PAY_CNT" value="${formData.PAY_CNT }" />

        <%--일반정보--%>
        <e:searchPanel id="sp" title="${form_CAPTION_N}" labelWidth="${labelWidth}" useTitleBar="false" width="100%" columnCount="2" onEnter="">
            <e:row>
                <e:label for="AP_NUM" title="${form_AP_NUM_N}" />
                <e:field>
                    <e:inputText id="AP_NUM" name="AP_NUM" value="${formData.AP_NUM}" width="${form_AP_NUM_W}" maxLength="${form_AP_NUM_M}" disabled="${form_AP_NUM_D}" readOnly="${form_AP_NUM_RO}" required="${form_AP_NUM_R}" style="${imeMode}" maskType="${form_AP_NUM_MT}"/>
                </e:field>
                <e:label for="DELIVERY_TYPE" title="${form_DELIVERY_TYPE_N}"/>
                <e:field>
                    <e:select id="DELIVERY_TYPE" name="DELIVERY_TYPE" value="${formData.DELIVERY_TYPE}" options="${deliveryTypeOptions}" width="${form_DELIVERY_TYPE_W}" disabled="${form_DELIVERY_TYPE_D}" readOnly="${form_DELIVERY_TYPE_RO}" required="${form_DELIVERY_TYPE_R}" placeHolder="선택" maskType="${form_DELIVERY_TYPE_MT}" />
                </e:field>
            </e:row>

            <e:row>
                <e:label for="PY_BUYER_DEPT_NM" title="${form_PY_BUYER_DEPT_NM_N}" />
                <e:field>
                    <e:inputText id="PY_BUYER_DEPT_NM" name="PY_BUYER_DEPT_NM" value="${formData.PY_BUYER_DEPT_NM}" width="${form_PY_BUYER_DEPT_NM_W}" maxLength="${form_PY_BUYER_DEPT_NM_M}" disabled="${form_PY_BUYER_DEPT_NM_D}" readOnly="${form_PY_BUYER_DEPT_NM_RO}" required="${form_PY_BUYER_DEPT_NM_R}" style="${imeMode}" maskType="${form_PY_BUYER_DEPT_NM_MT}"/>
                </e:field>
                <e:label for="VENDOR_CD" title="${form_VENDOR_CD_N}" />
                <e:field>
                    <e:inputText id="VENDOR_CD" name="VENDOR_CD" value="${formData.VENDOR_CD}" width="${form_VENDOR_CD_W}%" maxLength="${form_VENDOR_CD_M}" disabled="${form_VENDOR_CD_D}" readOnly="${form_VENDOR_CD_RO}" required="${form_VENDOR_CD_R}" style="${imeMode}" maskType="${form_VENDOR_CD_MT}"/>
                    <e:inputText id="VENDOR_NM" name="VENDOR_NM" value="${formData.VENDOR_NM}" width="${form_VENDOR_NM_W}%" maxLength="${form_VENDOR_NM_M}" disabled="${form_VENDOR_NM_D}" readOnly="${form_VENDOR_NM_RO}" required="${form_VENDOR_NM_R}" style="${imeMode}" maskType="${form_VENDOR_NM_MT}"/>
                </e:field>
            </e:row>

            <e:row>
                <e:label for="VENDOR_USER_NM" title="${form_VENDOR_USER_NM_N}" />
                <e:field>
                    <e:inputText id="VENDOR_USER_NM" name="VENDOR_USER_NM" value="${formData.VENDOR_USER_NM}" width="${form_VENDOR_USER_NM_W}" maxLength="${form_VENDOR_USER_NM_M}" disabled="${form_VENDOR_USER_NM_D}" readOnly="${form_VENDOR_USER_NM_RO}" required="${form_VENDOR_USER_NM_R}" style="${imeMode}" maskType="${form_VENDOR_USER_NM_MT}"/>
                </e:field>
                <e:label for="VENDOR_TEL_NUM" title="${form_VENDOR_TEL_NUM_N}" />
                <e:field>
                    <e:inputText id="VENDOR_TEL_NUM" name="VENDOR_TEL_NUM" value="${formData.VENDOR_TEL_NUM}" width="${form_VENDOR_TEL_NUM_W}%" maxLength="${form_VENDOR_TEL_NUM_M}" disabled="${form_VENDOR_TEL_NUM_D}" readOnly="${form_VENDOR_TEL_NUM_RO}" required="${form_VENDOR_TEL_NUM_R}" style="${imeMode}" maskType="${form_VENDOR_TEL_NUM_MT}"/>
                    <e:inputText id="VENDOR_CELL_NUM" name="VENDOR_CELL_NUM" value="${formData.VENDOR_CELL_NUM}" width="${form_VENDOR_CELL_NUM_W}%" maxLength="${form_VENDOR_CELL_NUM_M}" disabled="${form_VENDOR_CELL_NUM_D}" readOnly="${form_VENDOR_CELL_NUM_RO}" required="${form_VENDOR_CELL_NUM_R}" style="${imeMode}" maskType="${form_VENDOR_CELL_NUM_MT}"/>
                </e:field>
            </e:row>

            <e:row>
                <e:label for="PAY_BANK_NM" title="${form_PAY_ACCOUNT_NUM_N}"/>
                <e:field>
                    <e:search id="PAY_BANK_NM" name="PAY_BANK_NM" value="${formData.PAY_BANK_NM}" width="${form_PAY_BANK_NM_W}%" maxLength="${form_PAY_BANK_NM_M}" onIconClick="onIconClickPAY_BANK_NM" disabled="${form_PAY_BANK_NM_D}" readOnly="${form_PAY_BANK_NM_RO}" required="${form_PAY_BANK_NM_R}" maskType="${form_PAY_BANK_NM_MT}" />
                    <e:inputText id="PAY_ACCOUNT_NUM" name="PAY_ACCOUNT_NUM" value="${formData.PAY_ACCOUNT_NUM}" width="${form_PAY_ACCOUNT_NUM_W}%" maxLength="${form_PAY_ACCOUNT_NUM_M}" disabled="${form_PAY_ACCOUNT_NUM_D}" readOnly="${form_PAY_ACCOUNT_NUM_RO}" required="${form_PAY_ACCOUNT_NUM_R}" style="${imeMode}" maskType="${form_PAY_ACCOUNT_NUM_MT}"/>
                </e:field>
                <e:label for="PAY_ATT_FILE_CNT" title="${form_PAY_ATT_FILE_CNT_N}"/>
                <e:field>
                    <e:search id="PAY_ATT_FILE_CNT" name="PAY_ATT_FILE_CNT" value="${formData.PAY_ATT_FILE_CNT}" width="${form_PAY_ATT_FILE_CNT_W}" maxLength="${form_PAY_ATT_FILE_CNT_M}" onIconClick="onIconClickPAY_ATT_FILE_CNT" disabled="${form_PAY_ATT_FILE_CNT_D}" readOnly="${form_PAY_ATT_FILE_CNT_RO}" required="${form_PAY_ATT_FILE_CNT_R}" maskType="${form_PAY_ATT_FILE_CNT_MT}" />
                </e:field>
            </e:row>

            <e:row>
                <e:label for="PO_NUM" title="${form_PO_NUM_N}" />
                <e:field>
                    <e:inputText id="PO_NUM" name="PO_NUM" value="${formData.PO_NUM}" width="${form_PO_NUM_W}" maxLength="${form_PO_NUM_M}" disabled="${form_PO_NUM_D}" readOnly="${form_PO_NUM_RO}" required="${form_PO_NUM_R}" style="${imeMode}" maskType="${form_PO_NUM_MT}"/>
                </e:field>
                <e:label for="PO_CREATE_DATE" title="${form_PO_CREATE_DATE_N}" />
                <e:field>
                	<e:inputDate id="PO_CREATE_DATE" name="PO_CREATE_DATE" value="${formData.PO_CREATE_DATE}" width="${inputDateWidth}" datePicker="true" required="${form_PO_CREATE_DATE_R}" disabled="${form_PO_CREATE_DATE_D}" readOnly="${form_PO_CREATE_DATE_RO}" />
                </e:field>
            </e:row>

            <e:row>
                <e:label for="AP_REQ_SUBJECT" title="${form_AP_REQ_SUBJECT_N}" />
                <e:field>
                    <e:inputText id="AP_REQ_SUBJECT" name="AP_REQ_SUBJECT" value="${formData.AP_REQ_SUBJECT}" width="${form_AP_REQ_SUBJECT_W}" maxLength="${form_AP_REQ_SUBJECT_M}" disabled="${form_AP_REQ_SUBJECT_D}" readOnly="${form_AP_REQ_SUBJECT_RO}" required="${form_AP_REQ_SUBJECT_R}" style="${imeMode}" maskType="${form_AP_REQ_SUBJECT_MT}"/>
                </e:field>
                <e:label for="INV_NUM" title="${form_INV_NUM_N}" />
                <e:field>
                    <e:inputText id="INV_NUM" name="INV_NUM" value="${formData.INV_NUM}" width="${form_INV_NUM_W}%" maxLength="${form_INV_NUM_M}" disabled="${form_INV_NUM_D}" readOnly="${form_INV_NUM_RO}" required="${form_INV_NUM_R}" style="${imeMode}" maskType="${form_INV_NUM_MT}"/>
                </e:field>
            </e:row>

            <e:row>
                <e:label for="AP_REQ_DATE" title="${form_AP_REQ_DATE_N}" />
                <e:field>
                    <e:inputDate id="AP_REQ_DATE" name="AP_REQ_DATE" value="${formData.AP_REQ_DATE}" width="${inputDateWidth}" datePicker="true" required="${form_AP_REQ_DATE_R}" disabled="${form_AP_REQ_DATE_D}" readOnly="${form_AP_REQ_DATE_RO}" />
                </e:field>
                <e:label for="PAY_TERMS" title="${form_PAY_TERMS_N}"/>
                <e:field>
                    <e:select id="PAY_TERMS" name="PAY_TERMS" value="${formData.PAY_TERMS}" options="${payTermsOptions}" width="${form_PAY_TERMS_W}" disabled="${form_PAY_TERMS_D}" readOnly="${form_PAY_TERMS_RO}" required="${form_PAY_TERMS_R}" placeHolder="선택" maskType="${form_PAY_TERMS_MT}" />
                </e:field>
            </e:row>

            <e:row>
                <e:label for="PAY_INFO" title="${form_PAY_INFO_N}" />
                <e:field>
                    <e:inputText id="PAY_INFO" name="PAY_INFO" value="${formData.PAY_INFO}" width="${form_PAY_INFO_W}" maxLength="${form_PAY_INFO_M}" disabled="${form_PAY_INFO_D}" readOnly="${form_PAY_INFO_RO}" required="${form_PAY_INFO_R}" style="${imeMode}" maskType="${form_PAY_INFO_MT}"/>
                </e:field>
                <e:label for="PAY_AMT" title="${form_PAY_AMT_N}"/>
                <e:field>
                    <e:inputNumber id="PAY_AMT" name="PAY_AMT" value="${formData.PAY_AMT}" width="${form_PAY_AMT_W}" maxValue="${form_PAY_AMT_M}" decimalPlace="${form_PAY_AMT_NF}" disabled="${form_PAY_AMT_D}" readOnly="${form_PAY_AMT_RO}" required="${form_PAY_AMT_R}" onNumberKr="${form_PAY_AMT_KR}" currencyText="${form_PAY_AMT_CT}"/>
                </e:field>
            </e:row>

            <e:row>
                <e:label for="VAT_TYPE" title="${form_VAT_TYPE_N}"/>
                <e:field>
                    <e:select id="VAT_TYPE" name="VAT_TYPE" value="${formData.VAT_TYPE}" options="${vatTypeOptions}" width="${form_VAT_TYPE_W}" disabled="${form_VAT_TYPE_D}" readOnly="${form_VAT_TYPE_RO}" required="${form_VAT_TYPE_R}" placeHolder="선택" maskType="${form_VAT_TYPE_MT}" />
                </e:field>
                <e:label for="VAT_AMT" title="${form_VAT_AMT_N}"/>
                <e:field>
                    <e:inputNumber id="VAT_AMT" name="VAT_AMT" value="${formData.VAT_AMT}" width="${form_VAT_AMT_W}" maxValue="${form_VAT_AMT_M}" decimalPlace="${form_VAT_AMT_NF}" disabled="${form_VAT_AMT_D}" readOnly="${form_VAT_AMT_RO}" required="${form_VAT_AMT_R}" onNumberKr="${form_VAT_AMT_KR}" currencyText="${form_VAT_AMT_CT}"/>
                </e:field>
            </e:row>

            <e:row>
                <e:label for="INV_DATE" title="${form_INV_DATE_N}" />
                <e:field>
                    <e:inputDate id="INV_DATE" name="INV_DATE" value="${formData.INV_DATE}" width="${inputDateWidth}" datePicker="true" required="${form_INV_DATE_R}" disabled="${form_INV_DATE_D}" readOnly="${form_INV_DATE_RO}" />
                </e:field>
                <e:label for="INSPECT_USER_NM" title="${form_INSPECT_USER_NM_N}" />
                <e:field>
                    <e:inputText id="INSPECT_USER_NM" name="INSPECT_USER_NM" value="${formData.INSPECT_USER_NM}" width="${form_INSPECT_USER_NM_W}" maxLength="${form_INSPECT_USER_NM_M}" disabled="${form_INSPECT_USER_NM_D}" readOnly="${form_INSPECT_USER_NM_RO}" required="${form_INSPECT_USER_NM_R}" style="${imeMode}" maskType="${form_INSPECT_USER_NM_MT}"/>
                </e:field>
            </e:row>

            <e:row>
                <e:label for="BILL_DATE" title="${form_BILL_DATE_N}"/>
                <e:field>
                    <e:inputDate id="BILL_DATE" name="BILL_DATE" value="${formData.BILL_DATE}" width="${inputDateWidth}" datePicker="true" required="${form_BILL_DATE_R}" disabled="${form_BILL_DATE_D}" readOnly="${form_BILL_DATE_RO}" />
                </e:field>
                <e:label for="BILL_ATT_FILE_CNT" title="${form_BILL_ATT_FILE_CNT_N}"/>
                <e:field>
                    <e:search id="BILL_ATT_FILE_CNT" name="BILL_ATT_FILE_CNT" value="${formData.BILL_ATT_FILE_CNT}" width="${form_BILL_ATT_FILE_CNT_W}" maxLength="${form_BILL_ATT_FILE_CNT_M}" onIconClick="onIconClickBILL_ATT_FILE_CNT" disabled="${form_BILL_ATT_FILE_CNT_D}" readOnly="${form_BILL_ATT_FILE_CNT_RO}" required="${form_BILL_ATT_FILE_CNT_R}" maskType="${form_BILL_ATT_FILE_CNT_MT}" />
                </e:field>
            </e:row>

            <e:row>
                <e:label for="RMK_TEXT_NUM" title="${form_RMK_TEXT_NUM_N}" />
                <e:field colSpan="3">
                    <e:richTextEditor id="RMK_TEXT" name="RMK_TEXT" value="${formData.RMK_TEXT}" width="${form_RMK_TEXT_NUM_W}" height="200px" disabled="${form_RMK_TEXT_NUM_D}" readOnly="${form_RMK_TEXT_NUM_RO}" required="${form_RMK_TEXT_NUM_R}" style="${imeMode}"/>
                </e:field>
            </e:row>

            <e:row>
                <e:label for="ATT_FILE_NUM" title="${form_ATT_FILE_NUM_N}" />
                <e:field colSpan="3">
                    <e:fileManager id="ATT_FILE_NUM" width="${form_ATT_FILE_NUM_W}" height="100px" fileId="${formData.ATT_FILE_NUM}" bizType="OM" readOnly="${form_ATT_FILE_NUM_RO}" required="${form_ATT_FILE_NUM_R}"/>
                </e:field>
            </e:row>
        </e:searchPanel>
		
        <%--품목정보--%>
        <e:buttonBar width="100%" align="right" title="${SAPI0011_002}">
            <e:button id="doDeleteItem" name="doDeleteItem" label="${doDeleteItem_N}" onClick="doDeleteItem" disabled="${doDeleteItem_D}" visible="${doDeleteItem_V}"/>
        </e:buttonBar>
        <e:gridPanel id="gridPODT" name="gridPODT" width="100%" height="210px" gridType="${_gridType}" readOnly="${param.detailView}" />

        <%--검수요청상세--%>
        <e:buttonBar width="100%" align="right" title="${SAPI0011_003}">
        </e:buttonBar>
        <e:gridPanel id="gridIVAP" name="gridIVAP" width="100%" height="210px" gridType="${_gridType}" readOnly="${param.detailView}" />

        <form id="reqForm" name="reqForm" method="post" action="/MagicLine4Web/ML4Web/jcaosCheck.jsp">
            <input type="hidden" id="signData" name="signData" value="Login"/>
            <input type="hidden" id="signedData" name="signedData"/>
            <input type="hidden" id="vidRandom" name="vidRandom"/>
            <input type="hidden" id="vidType" name="vidType" value="client"/>
            <input type="hidden" id="idn" name="idn" value="${formData.IRS_NO}"/>
        </form>

        <div id="dscertContainer">
            <iframe id="dscert" name="dscert" src="" width="100%" height="100%" frameborder="0" allowTransparency="true" style="position:fixed;z-index:100010;top:0px;left:0px;width:100%;height:100%;"></iframe>
        </div>
    </e:window>
</e:ui>