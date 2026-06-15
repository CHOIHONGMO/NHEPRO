<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
    <script type="text/javascript" src="/MagicLine4Web/ML4Web/js/ext/jquery.blockUI.js"></script>
    <script type="text/javascript" src="/MagicLine4Web/ML4Web/js/ext/ML_Config.js"></script>

    <script type="text/javascript">
        var grid;
        var baseUrl = "/nhepro/SPOR/";
        var detailView  = "${param.detailView}" == "true";
        var PROGRESS_CD = "${empty formData.PROGRESS_CD ? param.PROGRESS_CD : formData.PROGRESS_CD}";
        //var REJECT_PO_NUM =  "${param.PO_NUM}";
        var localServerFlag = "${localServerFlag}";
        
        function init() {
            grid = EVF.C("grid");   // 품목정보

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

                if(colIdx == "ITEM_CD") {
                    param = {
                        ITEM_CD: value,
                        STD_ITEM_CD: value,
                        BUYER_CD: EVF.V("BUYER_CD"),
                        popupFlag: true,
                        detailView: true,
                        manageFlag: "0"
                    };
                    everPopup.openPopupByScreenId("CITR0041", 1150, 663, param);
                } else if(colIdx == "PO_NUM") {
                    param = {
                        callbackFunction: "",
                        PO_NUM: value,
                        BUYER_CD: EVF.V("BUYER_CD"),
                        detailView: true,
                        buttonView: false
                    };
                    everPopup.openPopupByScreenId("SPOR0011", 1200, 750, param);
                }
                /**
                 * 2021.01.29 추가
                 * 협력사에서는 검수 및 구매담당자 인적사항을 볼수 없음
                else if(colIdx == "CTRL_USER_NM") {
                    param = {
                        callbackFunction: "",
                        USER_TYPE: grid.getCellValue(rowIdx, "CTRL_USER_TYPE"),
                        USER_ID: grid.getCellValue(rowIdx, "CTRL_USER_ID"),
                        detailView: true
                    };
                    everPopup.openPopupByScreenId("MTUA0011", 600, 190, param);
                } else if(colIdx == "INSPECT_USER_NM") {
                    param = {
                        callbackFunction: "",
                        USER_TYPE: grid.getCellValue(rowIdx, "INSPECT_USER_TYPE"),
                        USER_ID: grid.getCellValue(rowIdx, "INSPECT_USER_ID"),
                        detailView: true
                    };
                    everPopup.openPopupByScreenId("MTUA0011", 600, 190, param);
                }*/
            });

            grid.cellChangeEvent(function (rowIdx, colIdx, irow, icol, value, oldValue) {
                if(colIdx == "IN_INV_QT") {
                    if( grid.getCellValue(rowIdx, "UN_PO_QT") < value ) {
                        grid.setCellValue(rowIdx, colIdx, oldValue);
                        EVF.alert("${SPOI0031_003}");
                    }
                    else {
                        grid.setCellValue(rowIdx, "INV_AMT", everMath.floor_float(value * grid.getCellValue(rowIdx, "UNIT_PRC")));
						
                        if(EVF.V("VAT_TYPE") == "1") {
                            grid.setCellValue(rowIdx, "VAT_AMT", everMath.floor_float(grid.getCellValue(rowIdx, "INV_AMT") / 11));
                        } else if(EVF.V("VAT_TYPE") == "2") {
                            grid.setCellValue(rowIdx, "VAT_AMT", everMath.floor_float(grid.getCellValue(rowIdx, "INV_AMT") * 0.1));
                        } else {
                            grid.setCellValue(rowIdx, "VAT_AMT", 0);
                        }
						
                        EVF.V("INV_AMT", grid._gvo.getSummary("INV_AMT", "sum"));
                        EVF.V("VAT_AMT", grid._gvo.getSummary("VAT_AMT", "sum"));
                    }
                }
            });

            if(detailView) {
                doSearchIVDT();
                EVF.C("doDeleteItem").setVisible(false);
            } else {
                if( EVF.isEmpty(PROGRESS_CD) ) {
                    doSearchPODT();
                    EVF.C("doDelete").setDisabled(true);
                } else {
                    doSearchIVDT();
                }
            }
        }

        function doSearchIVDT() {
            var store = new EVF.Store();
            store.setGrid([grid]);
            store.load(baseUrl + "spoi0031_doSearchIVDT.so", function() {

            }, false);
        }

        function doSearchPODT() {
            var store = new EVF.Store();
            store.setParameter("gridSel", JSON.stringify(${gridSel}));
            store.setGrid([grid]);
            store.load(baseUrl + "spoi0031_doSearchPODT.so", function() {

            }, false);
        }
        
        function date_add(sDate, nDays) {
		    var yy = parseInt(sDate);
		    return '' + yy + nDays;
		}
        
        function LdateAdd(sDate, nDays) {
		    var yy = parseInt(sDate.substr(0, 4), 10);
		    var mm = parseInt(sDate.substr(5, 2), 10);
		    if(mm == 01){
		    	yy = yy - 1;
		    }
		    
			var dd = nDays
		    d = new Date(yy, mm - 1, dd);

		    yy = d.getFullYear();
		    mm = d.getMonth(); mm = (mm < 10) ? '0' + mm : mm;
		    if(mm == 00){
		    	mm = 12;
		    }
		    
		    dd = d.getDate(); dd = (dd < 10) ? '0' + dd : dd;

		    return '' + yy + mm + dd;
		}
        
        function MdateAdd(sDate, nDays) {
		    var yy = parseInt(sDate.substr(0, 4), 10);
		    var mm = parseInt(sDate.substr(5, 2), 10);
			var dd = nDays
		    d = new Date(yy, mm, dd);

		    yy = d.getFullYear();
		    mm = d.getMonth(); mm = (mm < 10) ? '0' + mm : mm;
		    dd = d.getDate(); dd = (dd < 10) ? '0' + dd : dd;

		    return '' + yy + mm + dd;
		}
		
        //2022.09.15 검수요청 시 당월 10일 기준으로 과거일자로 선택 할수 있도록 개선
        //당월 10일 전 전월1일부터 선택 
        //당월 10일 후 당월1일부터 선택
        function doSave(s) {
            var store = new EVF.Store();
            if(!store.validate()) { return; }
            
            var CUR_DATE = EVF.V("CUR_DATE");       
            var CUR_SEND_DATE = EVF.V("CUR_SEND_DATE");
            
            var curSendDate = "";
            var curReqDate = "";
            var LsendDate = "";
            var LReqDate = "";
            var MsendDate = "";
            var MReqDate = "";
            var HReqDate = "";
            
            curSendDate = Number(CUR_SEND_DATE.substring(0, 6));
            //당월10일 셋팅
            curReqDate = date_add(curSendDate, 10);           
            
            LsendDate = Number(CUR_SEND_DATE.substring(0, 4)) + "/" + CUR_SEND_DATE.substring(4, 6) + "/" + CUR_SEND_DATE.substring(6, 8);
            //전월1일 셋팅
            LReqDate = LdateAdd(LsendDate, 1); 
            
            MsendDate = Number(CUR_SEND_DATE.substring(0, 4)) + "/" + CUR_SEND_DATE.substring(4, 6) + "/" + CUR_SEND_DATE.substring(6, 8);
            //당월1일 셋팅
            MReqDate = MdateAdd(MsendDate, 1); 
            HReqDate = curSendDate + "01"; 
            
            //현재일자가 10일 전(매월 9일까지) 검수요청일자 전월1일부터 소급 가능
            //현재일자가 10일 이후(매월 10일부터) 검수요청일자 당월 1일부터 소급
            if( curReqDate > Number(CUR_DATE)){
            	if( LReqDate > Number(EVF.V("INV_DATE")) ) {
                	return EVF.alert("검수요청일자는 전월 1일부터 이후로 선택하세요"); // 검수요청일자는 현재일자 이후로 선택하세요.
                }
            	
            } else if (curReqDate <= Number(CUR_DATE)){
            	if( Number(HReqDate) > Number(EVF.V("INV_DATE")) ) {
                	return EVF.alert("검수요청일자는 당월 1일부터 이후로 선택하세요"); // 검수요청일자는 현재일자 이후로 선택하세요.
                }
            }
            
         	// 2021.04.28 추가
            // 검수요청일자 >= 현재일자
            //if( Number(EVF.V("CUR_DATE")) > Number(EVF.V("INV_DATE")) ) {
            //	return EVF.alert("${SPOI0031_009}"); // 검수요청일자는 현재일자 이후로 선택하세요.
            //}
            
            if(!grid.validate(true).flag) { return EVF.alert(grid.validate().msg); }
			
            var allRowId = grid.getAllRowId();
            for(var i in allRowId) {
                var rowIdx = allRowId[i];
                if(grid.getCellValue(rowIdx, "IN_INV_QT") == "" || grid.getCellValue(rowIdx, "IN_INV_QT") == 0) {
                    return EVF.alert("${SPOI0031_007}");
                }
            }

            EVF.confirm("${SPOI0031_004}", function () {
                store.setGrid([grid]);
                store.getGridData(grid, "all");
                store.doFileUpload(function () {
                    store.load(baseUrl + "spoi0031_doSave.so", function(){
                    	// 2021.01.29 추가 (임시저장 완료 후 화면 Refresh)
                    	var buyerCd = this.getParameter("BUYER_CD");
    					var invNum  = this.getParameter("INV_NUM");
                    	
                        EVF.alert(this.getResponseMessage(), function() {
                        	var param = {
                                    BUYER_CD: buyerCd,
                                    INV_NUM: invNum,
                                    PROGRESS_CD: "100",
                                    detailView: false,
                                    buttonView: true
                                };
                            window.location.href = '/nhepro/SPOR/SPOI0031/view.so?' + $.param(param);
                        	
                            if(opener) {
                                opener.doSearch();
                                //doClose();
                            }
                        });
                    });
                });
            });
        }

        function doSend() {
            var store = new EVF.Store();
            if(!store.validate()) { return; }
            
            var CUR_DATE = EVF.V("CUR_DATE");       
            var CUR_SEND_DATE = EVF.V("CUR_SEND_DATE");
            
            var curSendDate = "";
            var curReqDate = "";
            var LsendDate = "";
            var LReqDate = "";
            var MsendDate = "";
            var MReqDate = "";
            var HReqDate = "";
            
            curSendDate = Number(CUR_SEND_DATE.substring(0, 6));
            //당월10일 셋팅
            curReqDate = date_add(curSendDate, 10);           
            
            LsendDate = Number(CUR_SEND_DATE.substring(0, 4)) + "/" + CUR_SEND_DATE.substring(4, 6) + "/" + CUR_SEND_DATE.substring(6, 8);
            //전월1일 셋팅
            LReqDate = LdateAdd(LsendDate, 1); 
            
            MsendDate = Number(CUR_SEND_DATE.substring(0, 4)) + "/" + CUR_SEND_DATE.substring(4, 6) + "/" + CUR_SEND_DATE.substring(6, 8);
            //당월1일 셋팅
            MReqDate = MdateAdd(MsendDate, 1);
            HReqDate = curSendDate + "01";
            
            //현재일자가 10일 전(매월 9일까지) 검수요청일자 전월1일부터 소급 가능
            //현재일자가 10일 이후(매월 10일부터) 검수요청일자 당월 1일부터 소급
            if( curReqDate > Number(CUR_DATE)){
            	if( LReqDate > Number(EVF.V("INV_DATE")) ) {
                	return EVF.alert("검수요청일자는 전월 1일부터 이후로 선택하세요"); // 검수요청일자는 현재일자 이후로 선택하세요.
                }
            	
            } else if (curReqDate <= Number(CUR_DATE)){
            	if( Number(HReqDate) > Number(EVF.V("INV_DATE")) ) {
                	return EVF.alert("검수요청일자는 당월 1일부터 이후로 선택하세요"); // 검수요청일자는 현재일자 이후로 선택하세요.
                }
            }
            
         	// 2021.04.28 추가
            // 검수요청일자 >= 현재일자
            //if( Number(EVF.V("CUR_DATE")) > Number(EVF.V("INV_DATE")) ) {
            //	return EVF.alert("${SPOI0031_009}"); // 검수요청일자는 현재일자 이후로 선택하세요.
            //}
            
            if(!grid.validate(true).flag) { return EVF.alert(grid.validate().msg); }

            var allRowId = grid.getAllRowId();
            for(var i in allRowId) {
                var rowIdx = allRowId[i];
                if(grid.getCellValue(rowIdx, "IN_INV_QT") == "" || grid.getCellValue(rowIdx, "IN_INV_QT") == 0) {
                    return EVF.alert("${SPOI0031_007}");
                }
            }

            EVF.confirm("${SPOI0031_005}", function () {
            	// 2021.01.26 : 로컬서버인 경우 공인인증서 팝업창 오픈하지 않음
            	if(localServerFlag == "Y") {
            		doSendGo();
				} else {
	                document.reqForm.signData.value = EVF.V("VENDOR_CD") + "@@" + document.reqForm.idn.value + "@@" + EVF.V("INV_AMT") + "@@" + "${signDate}";

	                var certOdiFilter = "${certOidfilter}";
	                var listOdiArr    = certOdiFilter.split(";");
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
            } else {
                return EVF.alert("결과값 수신에 실패하였습니다.");
            }
        }

        function doSendGo() {
            var store = new EVF.Store();
            store.setGrid([grid]);
            store.getGridData(grid, "all");
            store.setParameter("signedData", document.reqForm.signedData.value);
            store.setParameter("vidRandom", document.reqForm.vidRandom.value);
            store.setParameter("idn", document.reqForm.idn.value);
            store.doFileUpload(function () {
                store.load(baseUrl + "spoi0031_doSend.so", function(){
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
        	
        	var progressCd = EVF.V("PROGRESS_CD");
        	
        	if(progressCd == "400"){
        		var store = new EVF.Store();
        		store.setParameter("REJECT_PO_NUM", $('#REJECT_PO_NUM').val());
        		store.setGrid([grid]);
                store.getGridData(grid, 'sel');
                store.load(baseUrl + "spoi0031_doCheckINVData.so", function(){
	               	if( this.getResponseMessage() != null && this.getResponseMessage() == '1' ){
						return  EVF.alert("해당 발주건의 검수요청완료건이 존재합니다. 삭제할 수 없는 상태입니다.")
					} else {
						doRejectDelete();
					}	
                });
        	} else {
	            var store = new EVF.Store();
	            EVF.confirm("${SPOI0031_006}", function () {
	                store.setGrid([grid]);
	                store.getGridData(grid, "all");
	                store.doFileUpload(function () {
	                    store.load(baseUrl + "spoi0031_doDelete.so", function(){
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
        }
        
        function doRejectDelete() {
        	var store = new EVF.Store();
            EVF.confirm("${SPOI0031_010}", function () {
                store.setGrid([grid]);
                store.getGridData(grid, "all");
                store.doFileUpload(function () {
                    store.load(baseUrl + "spoi0031_doDelete.so", function(){
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

        function doDeleteItem() {
            if(grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

            if(grid.getSelRowCount() == grid.getRowCount()) {
                return EVF.alert("${SPOI0031_008}")
            }
            grid.delRow();

            EVF.V("INV_AMT", grid._gvo.getSummary("INV_AMT", "sum"));
            EVF.V("VAT_AMT", grid._gvo.getSummary("VAT_AMT", "sum"));
        }

        function doClose() {
            EVF.closeWindow();
        }
    </script>

    <e:window id="SPOI0031" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">
        <e:inputHidden id="BUYER_CD" name="BUYER_CD" value="${formData.BUYER_CD}"/>
        <e:inputHidden id="DEPT_CD" name="DEPT_CD" value="${formData.DEPT_CD}"/>
        <e:inputHidden id="PIC_USER_ID" name="PIC_USER_ID" value="${formData.PIC_USER_ID}"/>
        <e:inputHidden id="RMK_TEXT_NUM" name="RMK_TEXT_NUM" value="${formData.RMK_TEXT_NUM }" />
        <e:inputHidden id="OLD_INV_AMT" name="OLD_INV_AMT" value="${formData.INV_AMT }" />
        <e:inputHidden id="OLD_VAT_AMT" name="OLD_VAT_AMT" value="${formData.VAT_AMT }" />
        <e:inputHidden id="PO_NUM" name="PO_NUM" value="${formData.PO_NUM }" />
		<e:inputHidden id="CUR_DATE" name="CUR_DATE" value="${CUR_DATE }" />	<!-- 현재일자 -->
		<e:inputHidden id="CUR_SEND_DATE" name="CUR_SEND_DATE" value="${CUR_SEND_DATE }" /> <!-- 현재일자 -->
		<e:inputHidden id="PROGRESS_CD" name="PROGRESS_CD" value="${formData.PROGRESS_CD }" />
		<e:inputHidden id="REJECT_PO_NUM" name="REJECT_PO_NUM" value="${param.PO_NUM }" />
		
		<e:buttonBar width="100%" align="right" title="${SPOI0031_001}">
			<c:if test="${!param.detailView and (formData.PROGRESS_CD eq '100' or empty formData.PROGRESS_CD)}"> 
            	<e:button id="doSave" name="doSave" label="${doSave_N}" onClick="doSave" disabled="${doSave_D}" visible="${doSave_V}"/>
            	<e:button id="doSend" name="doSend" label="${doSend_N}" onClick="doSend" disabled="${doSend_D}" visible="${doSend_V}"/>
            </c:if>
            <e:button id="doDelete" name="doDelete" label="${doDelete_N}" onClick="doDelete" disabled="${doDelete_D}" visible="${doDelete_V}"/>
            <e:button id="doClose" name="doClose" label="${doClose_N}" onClick="doClose" disabled="${doClose_D}" visible="${doClose_V}"/>
        </e:buttonBar>

		<%--일반정보--%>
        <e:searchPanel id="sp" title="${form_CAPTION_N}" labelWidth="${labelWidth}" useTitleBar="false" width="100%" columnCount="2" onEnter="">
            <e:row>
                <e:label for="INV_NUM" title="${form_INV_NUM_N}" />
                <e:field>
                    <e:inputText id="INV_NUM" name="INV_NUM" value="${formData.INV_NUM}" width="${form_INV_NUM_W}" maxLength="${form_INV_NUM_M}" disabled="${form_INV_NUM_D}" readOnly="${form_INV_NUM_RO}" required="${form_INV_NUM_R}" style="${imeMode}" maskType="${form_INV_NUM_MT}"/>
                </e:field>
                <e:label for="PURCHASE_TYPE" title="${form_PURCHASE_TYPE_N}"/>
                <e:field>
                    <e:select id="PURCHASE_TYPE" name="PURCHASE_TYPE" value="${formData.PURCHASE_TYPE}" options="${purchaseTypeOptions}" width="${form_PURCHASE_TYPE_W}" disabled="${form_PURCHASE_TYPE_D}" readOnly="${form_PURCHASE_TYPE_RO}" required="${form_PURCHASE_TYPE_R}" placeHolder="" maskType="${form_PURCHASE_TYPE_MT}" />
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
	                <e:text>(Ex:010-1234-5678, 검수요청서 승인/반려시 SMS수신)</e:text>
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
                <e:label for="REG_DATE" title="${form_REG_DATE_N}" />
                <e:field>
                	<e:inputDate id="REG_DATE" name="REG_DATE" value="${formData.REG_DATE}" width="${inputDateWidth}" datePicker="true" required="${form_REG_DATE_R}" disabled="${form_REG_DATE_D}" readOnly="${form_REG_DATE_RO}" />
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
        <e:buttonBar width="100%" align="right" title="${SPOI0031_002}">
            <e:button id="doDeleteItem" name="doDeleteItem" label="${doDeleteItem_N}" onClick="doDeleteItem" disabled="${doDeleteItem_D}" visible="${doDeleteItem_V}"/>
        </e:buttonBar>
        <e:gridPanel id="grid" name="grid" width="100%" height="210px" gridType="${_gridType}" readOnly="${param.detailView}" />

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
