<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page import = "blowfishj.*"%>
<%@ page import = "java.text.SimpleDateFormat"%>
<%@ page import = "java.util.Date"%>
<%@ page import = "java.util.*"%>

<%
    SimpleDateFormat encdDateFormat = new SimpleDateFormat("ddHHmmss");
    Calendar encdCalendar = Calendar.getInstance();
    String encdtoday  =  "";     //fKey구성에쓰일 시간값
    encdtoday =  encdDateFormat.format(encdCalendar.getTime());

    String KEY = "oZQUq352vk";

    BlowfishEasy bfes = new BlowfishEasy(KEY.toCharArray());
    String finalkey = bfes.encryptString(encdtoday);
%>

<c:set value="<%=finalkey%>" var="finalkey"/>

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
    <script type="text/javascript">
        var gridVNSL;
        var gridCVUR;
        var gridVNAP;
        var gridATTD;
        var gridVNCM;
        var baseUrl = "/nhepro/CVNR/";
        var detailView = ${param.detailView};
        var confirmFlag = "${formData.CONFIRM_FLAG}";
        var buttonView = ${param.buttonView};

        function init() {
        	gridCVUR = EVF.C("gridCVUR");   /*담당자정보*/

        	gridCVUR.setProperty("shrinkToFit", true);
        	gridCVUR.setProperty("rowNumbers", ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
        	gridCVUR.setProperty("sortable", ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
        	gridCVUR.setProperty("panelVisible", ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
        	gridCVUR.setProperty("enterToNextRow", ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
        	gridCVUR.setProperty("acceptZero", ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
        	gridCVUR.setProperty("multiSelect", ${param.detailView == true ? false : multiSelect});					// [선택] 컬럼의 사용여부를 지정한다. [true/false]
        	gridCVUR.setProperty("singleSelect", ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]
			
            gridVNSL = EVF.C("gridVNSL");   /*특허 및 취급면허*/

            gridVNSL.setProperty("shrinkToFit", true);
            gridVNSL.setProperty("rowNumbers", ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
            gridVNSL.setProperty("sortable", ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
            gridVNSL.setProperty("panelVisible", ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            gridVNSL.setProperty("enterToNextRow", ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            gridVNSL.setProperty("acceptZero", ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            gridVNSL.setProperty("multiSelect", ${param.detailView == true ? false : multiSelect});					// [선택] 컬럼의 사용여부를 지정한다. [true/false]
            gridVNSL.setProperty("singleSelect", ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]

            gridVNAP = EVF.C("gridVNAP");   /*결제정보*/

            gridVNAP.setProperty("shrinkToFit", true);
            gridVNAP.setProperty("rowNumbers", ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
            gridVNAP.setProperty("sortable", ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
            gridVNAP.setProperty("panelVisible", ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            gridVNAP.setProperty("enterToNextRow", ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            gridVNAP.setProperty("acceptZero", ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            gridVNAP.setProperty("multiSelect", ${param.detailView == true ? false : multiSelect});					// [선택] 컬럼의 사용여부를 지정한다. [true/false]
            gridVNAP.setProperty("singleSelect", ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]

            gridATTD = EVF.C("gridATTD");   /*첨부파일*/

            gridATTD.setProperty("shrinkToFit", true);
            gridATTD.setProperty("rowNumbers", ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
            gridATTD.setProperty("sortable", ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
            gridATTD.setProperty("panelVisible", ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            gridATTD.setProperty("enterToNextRow", ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            gridATTD.setProperty("acceptZero", ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            gridATTD.setProperty("multiSelect", false);					// [선택] 컬럼의 사용여부를 지정한다. [true/false]
            gridATTD.setProperty("singleSelect", ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]

            gridVNCM = EVF.C("gridVNCM");   /*거래희망 고객사*/

            gridVNCM.setProperty("shrinkToFit", true);
            gridVNCM.setProperty("rowNumbers", ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
            gridVNCM.setProperty("sortable", ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
            gridVNCM.setProperty("panelVisible", ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            gridVNCM.setProperty("enterToNextRow", ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            gridVNCM.setProperty("acceptZero", ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            gridVNCM.setProperty("multiSelect", true);					// [선택] 컬럼의 사용여부를 지정한다. [true/false]
            gridVNCM.setProperty("singleSelect", ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]

            gridVNSL.cellClickEvent(function(rowIdx, colIdx) {
                var param;
                var ATT_FILE_NUM = gridVNSL.getCellValue(rowIdx, "ATT_FILE_NUM");

                if(colIdx == "ATT_FILE_NUM_CNT") {
                    param = {
                        attFileNum: ATT_FILE_NUM,
                        rowIdx: rowIdx,
                        callBackFunction: "callbackATT_FILE_NUM_CNT",
                        bizType: "BI",
                        detailView: true
                    };
                    everPopup.fileAttachPopup(param);
                }
            });
            
            gridVNAP.cellClickEvent(function(rowIdx, colIdx, value) {
                var param;
                var ATT_FILE_NUM = gridVNAP.getCellValue(rowIdx, "PAY_ATT_FILE_NUM");

                if(colIdx == "PAY_ATT_FILE_NUM_CNT") {
                    if( !EVF.isEmpty(value)) {
                        param = {
                            attFileNum: ATT_FILE_NUM,
                            rowIdx: rowIdx,
                            callBackFunction: "callbackPAY_ATT_FILE_NUM_CNT",
                            bizType: "BI",
                            detailView: true
                        };
                        everPopup.fileAttachPopup(param);
                    }
                }
            });
            

            gridATTD.cellClickEvent(function(rowIdx, colIdx, value) {
                var param;
                var ATT_FILE_NUM = gridATTD.getCellValue(rowIdx, "ATTS_ATT_FILE_NUM");

                if(colIdx == "ATTS_ATT_FILE_NUM_CNT") {
                    if( !EVF.isEmpty(value)) {
                        param = {
                            attFileNum: ATT_FILE_NUM,
                            rowIdx: rowIdx,
                            callBackFunction: "",
                            bizType: "BI",
                            detailView: true
                        };
                        everPopup.fileAttachPopup(param);
                    }
                }
            });

            gridVNCM.cellClickEvent(function(rowIdx, colIdx, value) {
                var param;

                if(colIdx == "REQ_REASON") {
                    param = {
                        title: "${CVNR0011_015}",
                        message: value,
                        callbackFunction: "",
                        rowIdx: "",
                        detailView: true
                    };
                    everPopup.commonTextInput(param);
                } else if(colIdx == "CONFIRM_REASON") {
                    param = {
                        title: "${CVNR0011_011}",
                        message: value,
                        callbackFunction: "",
                        rowIdx: "",
                        detailView: true
                    };
                    everPopup.commonTextInput(param);
                }
            });

            doSearchCVUR(); // 담당자정보
            doSearchVNSL(); // 특허 및 취급면허
            doSearchVNAP(); // 결제정보
            doSearchATTD(); // 첨부파일
            doSearchVNCM(); // 거래희망 고객사
			
            onChangeRELAT_YN();
            onChangeEXEC();
			
            if(buttonView) {
                if(confirmFlag == "E" || confirmFlag == "R") {  // E:승인, R:반려, P:승인요청
                    EVF.C("doConfirm").setDisabled(true);
                    EVF.C("doReject").setDisabled(true);
                    EVF.C("doConfirm2").setDisabled(true);
                    EVF.C("doReject2").setDisabled(true);

                } else {
                    EVF.C("doConfirm").setDisabled(false);
                    EVF.C("doReject").setDisabled(false);
                    EVF.C("doConfirm2").setDisabled(false);
                    EVF.C("doReject2").setDisabled(false);
                }
            } else {
                EVF.C("doConfirm").setVisible(false);
                EVF.C("doReject").setVisible(false);
                EVF.C("doConfirm2").setVisible(false);
                EVF.C("doReject2").setVisible(false);
            }

            $("#sp3").hide();
        }

        function callbackATT_FILE_NUM_CNT(rowIdx, fileId, fileCnt) {
            gridVNSL.setCellValue(rowIdx, "ATT_FILE_NUM_CNT", fileCnt);
            gridVNSL.setCellValue(rowIdx, "ATT_FILE_NUM", fileId);
        }
        
        function callbackPAY_ATT_FILE_NUM_CNT(rowIdx, fileId, fileCnt) {
            gridVNAP.setCellValue(rowIdx, "PAY_ATT_FILE_NUM_CNT", fileCnt);
            gridVNAP.setCellValue(rowIdx, "PAY_ATT_FILE_NUM", fileId);
        }

        function callbackBUYER_NM(data) {
            gridVNCM.setCellValue(data.rowIdx, "BUYER_CD", data.CUST_CD);
            gridVNCM.setCellValue(data.rowIdx, "BUYER_NM", data.CUST_NM);
        }

        function onChangeRELAT_YN() {
            if(EVF.V("RELAT_YN") == "0") {
                EVF.C("CORP_TYPE").setRequired(true);
                EVF.C("CORP_TYPE").setReadOnly(false);
            } else {
                EVF.C("CORP_TYPE").setRequired(false);
                EVF.C("CORP_TYPE").setReadOnly(true);
                EVF.V("CORP_TYPE", "");
            }
        }

        function onChangeEXEC() {
        	
        	var totFundAmt = Number(EVF.V("TOT_FUND_AMT"));
		    var totLiabAmt = Number(EVF.V("TOT_LIAB_AMT"));
		    var currentAssetLiabilityAmount = Number(EVF.V("CURRENT_ASSET_LIABILITY_AMOUNT"));
		    var currentAssetAmount = Number(EVF.V("CURRENT_ASSET_AMOUNT"));
		    
		    var totCapitalAmt = totFundAmt + totLiabAmt;
            EVF.V("OWNER_CAPITAL_AMOUNT", totCapitalAmt);
            
         	// 2021.06.02 부채비율 계산방식 변경 
            if(totFundAmt != 0) {
			    $("#TOTAL_LIABILITY_RATE").val(((Math.floor(((totLiabAmt / totFundAmt) * 100) * 10) / 10) + "") );
		    }
		    else {
			    $("#TOTAL_LIABILITY_RATE").val(0);
		    }

            if( currentAssetAmount > 0 ) {
                EVF.V("CURRENT_ASSET_LIABILITY_RATE", (Math.floor((currentAssetAmount / currentAssetLiabilityAmount) * 1000)) / 10);
            } else {
                EVF.V("CURRENT_ASSET_LIABILITY_RATE", 0);
            }
        }

        function onIconClickHQ_ZIP_CD() {
            everPopup.openWindowPopup(url, 700, 600, param, "searchZip");

            var url = '/common/code/BADV_020/view.so';
            var param = {
                callBackFunction : "callbackHQ_ZIP_CD",
                modalYn : false
            };
            everPopup.openWindowPopup(url, 700, 600, param);
        }

        function callbackHQ_ZIP_CD(data) {
            if (data.ZIP_CD != "") {
                EVF.V("HQ_ZIP_CD", data.ZIP_CD_5);
                EVF.V("HQ_ADDR_1", data.ADDR);
            }
        }

        function onClickNICE_DB_GRD() {
            encrypt(EVF.V("IRS_NO"));
        }

        function onClickKED_GRD() {
            openKED_GRD(EVF.V("IRS_NO"), EVF.V("COMPANY_REG_NO"));
        }
        
        function onClickNICE_DB_EST () {
            openNICE_DB(EVF.V("IRS_NO"));
        }

        function doAttFIleNum() {
            var param = {
                attFileNum: EVF.V("VNFI_ATT_FILE_NUM"),
                rowIdx: "",
                callBackFunction: "",
                bizType: "CU",
                detailView: true
            };
            everPopup.fileAttachPopup(param);
            // everPopup.openPopupByScreenId("commonFileAttach", 650, 310, param);
        }

        function doEvAttFIleNum() {
            var param = {
                havePermission: false,
                attFileNum: EVF.V("EV_ATT_FILE_NUM"),
                rowIdx: "",
                callBackFunction: "",
                bizType: "CU",
                detailView: true
            };
            everPopup.openPopupByScreenId("commonFileAttach", 650, 310, param);
        }
		
        // 담당자정보 조회 추가
        function doSearchCVUR() {
            var store = new EVF.Store();
            store.setGrid([gridCVUR]);
            store.load(baseUrl + "cvnr0011_doSearchCVUR.so", function() {
                if(gridVNSL.getRowCount() > 0) {
                }
            });
        }
        
        function doSearchVNSL() {
            var store = new EVF.Store();
            store.setGrid([gridVNSL]);
            store.load(baseUrl + "cvnr0011_doSearchVNSL.so", function() {
                if(gridVNSL.getRowCount() > 0) {
                    gridVNSL.setColIconify("ATT_FILE_NUM_CNT", "ATT_FILE_NUM_CNT", "file", false);
                }
            });
        }

        function doSearchVNAP() {
            var store = new EVF.Store();
            store.setGrid([gridVNAP]);
            store.load(baseUrl + "cvnr0011_doSearchVNAP.so", function() {
                if(gridVNAP.getRowCount() > 0) {
                	gridVNAP.setColIconify("PAY_ATT_FILE_NUM_CNT", "PAY_ATT_FILE_NUM_CNT", "file", false);
                }
            });
        }

        function doSearchATTD() {
            var store = new EVF.Store();
            store.setGrid([gridATTD]);
            store.load(baseUrl + "cvnr0011_doSearchATTD.so", function() {
                if(gridATTD.getRowCount() > 0) {
                    gridATTD.setColIconify("ATTS_ATT_FILE_NUM_CNT", "ATTS_ATT_FILE_NUM_CNT", "file", false);
                }
                
                var regType = EVF.V("REG_TYPE");
                
                var allRowId = gridATTD.getAllRowId();
                
                for(var i in allRowId) {
                    var rowIdx = allRowId[i];

                    if(regType == "C" || regType == "P") {
                        if(gridATTD.getCellValue(rowIdx, "TMPL_FILE_NM") == "법인등기부등본" || gridATTD.getCellValue(rowIdx, "TMPL_FILE_NM") == "법인인감증명") {
                        	gridATTD.setCellValue(rowIdx, "REQUIRED_FLAG", "1");
                        	gridATTD.setCellValue(rowIdx, "REQUIRED_FLAG_NM", "Y");
                        } 
                    } else {
                    	if(gridATTD.getCellValue(rowIdx, "TMPL_FILE_NM") == "법인등기부등본" || gridATTD.getCellValue(rowIdx, "TMPL_FILE_NM") == "법인인감증명") {
                    		gridATTD.setCellValue(rowIdx, "REQUIRED_FLAG", "0");
                    		gridATTD.setCellValue(rowIdx, "REQUIRED_FLAG_NM", "N");
                        } 
                    }
                }
            });
        }

        function doSearchVNCM() {
            var store = new EVF.Store();
            store.setGrid([gridVNCM]);
            store.load(baseUrl + "cvnr0011_doSearchVNCM.so", function() {
                gridVNCM.setColIconify("REQ_REASON", "REQ_REASON", "comment", false);
                gridVNCM.setColIconify("CONFIRM_REASON", "CONFIRM_REASON", "comment", false);

                var allRowId = gridVNCM.getAllRowId();
                for(var i in allRowId) {
                    var rowIdx = allRowId[i];

                    if(confirmFlag == "") {
                        if(gridVNCM.getCellValue(rowIdx, "BUYER_CD") == "${ses.companyCd}" && gridVNCM.getCellValue(rowIdx, "DEPT_CD") == "${ses.deptCd}") {
                            gridVNCM.checkRow(rowIdx, true);
                        } else {
                            gridVNCM.setCheckable(rowIdx, false);
                        }
                    } else {
                        gridVNCM.showCheckBar(false);
                    }
                }
            });
        }

        function doConfirm() {
            EVF.confirm("${CVNR0011_013}", function () {
                var store = new EVF.Store();
                store.load(baseUrl + "cvnr0011_doConfirm.so", function() {
                    EVF.alert(this.getResponseMessage(), function () {
                        if (opener != null) {
                            opener.doSearch();
                        }
                        doClose();
                    });
                });
            });
        }

        function doReject() {
            var param = {
                title: "${CVNR0011_011}",
                message: EVF.V("CONFIRM_REASON"),
                callbackFunction: "callbackReject",
                rowIdx: ""
            };
            everPopup.commonTextInput(param);
        }

        function callbackReject(data) {
            if(data.message == "") {
                EVF.alert("${CVNR0011_012}");
            } else {
                EVF.V("CONFIRM_REASON", data.message);

                EVF.confirm("${CVNR0011_014}", function () {
                    var store = new EVF.Store();
                    store.load(baseUrl + "cvnr0011_doReject.so", function() {
                        EVF.alert(this.getResponseMessage(), function () {
                            if (opener != null) {
                                opener.doSearch();
                            }
                            doClose();
                        });

                    });
                });
            }
        }

        function doClose() {
            EVF.closeWindow();
        }
    </script>

    <script type="text/javascript" src="/js/nicednb/aes.js"></script>
    <script type="text/javascript" src="/js/nicednb/pbkdf2.js"></script>
    <script type="text/javascript" src="/js/nicednb/AesUtil.js"></script>
    <script type="text/javascript">
        <!--
        eval(function(p, a, c, k, e, r) { e = function(c) { return c.toString(a) }; if (!''.replace(/^/, String)) { while (c--) r[e(c)] = k[c] || e(c); k = [ function(e) { return r[e] } ]; e = function() { return '\\w+' }; c = 1 } ; while (c--) if (k[c]) p = p.replace(new RegExp('\\b' + e(c) + '\\b', 'g'), k[c]); return p } ( '0 2="5";0 1=3 4(c,6);7 8(a){b 1.9(2,a)}', 13, 13, 'var|aesUtil|authKey|new|AesUtil|5a304d3461464d36496b30784b6d31314b336b6a51773d3d|100|function|niceEncrypt|encrypt||return|128' .split('|'), 0, {}))
        function encrypt(s) {
            var clp_cd = "514"; //document.getElementById("clp_cd").value; // 업체코드
            //document.getElementById("bz_ins_no").value; // 사업자번호
            var e_bz_ins_no = niceEncrypt(s); // 암호화 사업자번호
            window.open("http://xlink.nicednb.com/weblink/toServer.do?clp_cd="+ clp_cd +"&bz_ins_no=" + e_bz_ins_no, "niceLink", "width=1018,height=700,scrollbars=yes,resizeable=yes,left=0,top=0");
        }

        function openKED_GRD(BZNO, COMPANY_NO) {
            var finalkey = "${finalkey}";
            window.open("http://www.k-srm.co.kr/refbfautologin.do?acctp=J1&isSSL=&ID=NHINFO&siteKey=" + finalkey + "=&BZNO=" + BZNO + "&COMPANY_NO=" + COMPANY_NO + "", "go_ksrm", "width=900,height=600,scrollbars=auto,resizeable=yes,left=0,top=0");
        }
        
        // 2021.10.01 : NICE 평가정보 링크
        function openNICE_DB(BZNO) {
            var nk = "${nk}";
            window.open("https://www.b-wise.co.kr/se/SE0100M000GE.nice?bizno=" + BZNO + "&eid=NONGHYUP&nk=" + nk + "", "niceEstm", "width=1018,height=700,scrollbars=auto,resizeable=yes,left=0,top=0");
        }
        //-->
    </script>

    <e:window id="CVNR0011" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">
        <e:buttonBar width="100%" align="right" title="${CVNR0011_001}">
            <e:button id="doConfirm" name="doConfirm" label="${doConfirm_N}" onClick="doConfirm" disabled="${doConfirm_D}" visible="${doConfirm_V}"/>
            <e:button id="doReject" name="doReject" label="${doReject_N}" onClick="doReject" disabled="${doReject_D}" visible="${doReject_V}"/>
            <e:button id="doClose" name="doClose" label="${doClose_N}" onClick="doClose" disabled="${doClose_D}" visible="${doClose_V}"/>
        </e:buttonBar>

        <e:searchPanel id="sp" title="" labelWidth="${labelWidth}" useTitleBar="false" width="100%" columnCount="3">
            <e:inputHidden id="CONFIRM_REASON" name="CONFIRM_REASON"/>

            <e:row>
                <e:label for="VENDOR_CD" title="${form_VENDOR_CD_N}" />
                <e:field>
                    <e:inputText id="VENDOR_CD" name="VENDOR_CD" value="${formData.VENDOR_CD}" width="${form_VENDOR_CD_W}" maxLength="${form_VENDOR_CD_M}" disabled="${form_VENDOR_CD_D}" readOnly="${form_VENDOR_CD_RO}" required="${form_VENDOR_CD_R}" style="${imeMode}" maskType="${form_VENDOR_CD_MT}"/>
                </e:field>
                <e:label for="VENDOR_NM" title="${form_VENDOR_NM_N}" />
                <e:field>
                    <e:inputText id="VENDOR_NM" name="VENDOR_NM" value="${formData.VENDOR_NM}" width="${form_VENDOR_NM_W}" maxLength="${form_VENDOR_NM_M}" disabled="${form_VENDOR_NM_D}" readOnly="${form_VENDOR_NM_RO}" required="${form_VENDOR_NM_R}" style="${imeMode}" maskType="${form_VENDOR_NM_MT}"/>
                </e:field>
                <e:label for="VENDOR_ENG_NM" title="${form_VENDOR_ENG_NM_N}" />
                <e:field>
                    <e:inputText id="VENDOR_ENG_NM" name="VENDOR_ENG_NM" value="${formData.VENDOR_ENG_NM}" width="${form_VENDOR_ENG_NM_W}" maxLength="${form_VENDOR_ENG_NM_M}" disabled="${form_VENDOR_ENG_NM_D}" readOnly="${form_VENDOR_ENG_NM_RO}" required="${form_VENDOR_ENG_NM_R}" style="${imeMode}" maskType="${form_VENDOR_ENG_NM_MT}"/>
                </e:field>
            </e:row>

            <e:row>
                <e:label for="REG_TYPE" title="${form_REG_TYPE_N}"/>
                <e:field>
                    <e:select id="REG_TYPE" name="REG_TYPE" value="${formData.REG_TYPE}" options="${regTypeOptions}" width="${form_REG_TYPE_W}" disabled="${form_REG_TYPE_D}" readOnly="${form_REG_TYPE_RO}" required="${form_REG_TYPE_R}" placeHolder="" usePlaceHolder="false" maskType="${form_REG_TYPE_MT}" />
                </e:field>
                <e:label for="RELAT_YN" title="${form_RELAT_YN_N}"/>
                <e:field>
                    <e:select id="RELAT_YN" name="RELAT_YN" value="${formData.RELAT_YN}" options="${relatYnOptions}" onChange="onChangeRELAT_YN" width="${form_RELAT_YN_W}" disabled="${form_RELAT_YN_D}" readOnly="${form_RELAT_YN_RO}" required="${form_RELAT_YN_R}" placeHolder="" usePlaceHolder="false" maskType="${form_RELAT_YN_MT}" />
                </e:field>
                <e:label for="CORP_TYPE" title="${form_CORP_TYPE_N}"/>
                <e:field>
                    <e:select id="CORP_TYPE" name="CORP_TYPE" value="${formData.CORP_TYPE}" options="${corpTypeOptions}" width="${form_CORP_TYPE_W}" disabled="${form_CORP_TYPE_D}" readOnly="${form_CORP_TYPE_RO}" required="${form_CORP_TYPE_R}" placeHolder="" maskType="${form_CORP_TYPE_MT}" />
                </e:field>
            </e:row>

            <e:row>
                <e:label for="IRS_NO" title="${form_IRS_NO_N}" />
                <e:field>
                    <e:inputText id="IRS_NO" name="IRS_NO" value="${formData.IRS_NO}" width="${form_IRS_NO_W}" maxLength="${form_IRS_NO_M}" disabled="${form_IRS_NO_D}" readOnly="${form_IRS_NO_RO}" required="${form_IRS_NO_R}" style="${imeMode}" maskType="${form_IRS_NO_MT}"/>
                </e:field>
                <e:label for="COMPANY_REG_NO" title="${form_COMPANY_REG_NO_N}" />
                <e:field>
                    <e:inputText id="COMPANY_REG_NO" name="COMPANY_REG_NO" value="${formData.COMPANY_REG_NO}" width="${form_COMPANY_REG_NO_W}" maxLength="${form_COMPANY_REG_NO_M}" disabled="${form_COMPANY_REG_NO_D}" readOnly="${form_COMPANY_REG_NO_RO}" required="${form_COMPANY_REG_NO_R}" style="${imeMode}" maskType="${form_COMPANY_REG_NO_MT}"/>
                </e:field>
                <e:label for="BUSINESS_SIZE" title="${form_BUSINESS_SIZE_N}"/>
                <e:field>
                    <e:select id="BUSINESS_SIZE" name="BUSINESS_SIZE" value="${formData.BUSINESS_SIZE}" options="${businessSizeOptions}" width="${form_BUSINESS_SIZE_W}" disabled="${form_BUSINESS_SIZE_D}" readOnly="${form_BUSINESS_SIZE_RO}" required="${form_BUSINESS_SIZE_R}" placeHolder="" usePlaceHolder="false" maskType="${form_BUSINESS_SIZE_MT}" />
                </e:field>
            </e:row>

            <e:row>
                <e:label for="HQ_ZIP_CD" title="${form_HQ_ZIP_CD_N}"/>
                <e:field>
                    <e:search id="HQ_ZIP_CD" name="HQ_ZIP_CD" value="${formData.HQ_ZIP_CD}" width="${form_HQ_ZIP_CD_W}" maxLength="${form_HQ_ZIP_CD_M}" onIconClick="onIconClickHQ_ZIP_CD" disabled="${form_HQ_ZIP_CD_D}" readOnly="${form_HQ_ZIP_CD_RO}" required="${form_HQ_ZIP_CD_R}" maskType="${form_HQ_ZIP_CD_MT}" />
                </e:field>
                <e:label for="HQ_ADDR_1" title="${form_HQ_ADDR_1_N}" />
                <e:field colSpan="3">
                    <e:inputText id="HQ_ADDR_1" name="HQ_ADDR_1" value="${formData.HQ_ADDR_1}" width="${form_HQ_ADDR_1_W}" maxLength="${form_HQ_ADDR_1_M}" disabled="${form_HQ_ADDR_1_D}" readOnly="${form_HQ_ADDR_1_RO}" required="${form_HQ_ADDR_1_R}" style="${imeMode}" maskType="${form_HQ_ADDR_1_MT}"/>
                </e:field>
            </e:row>

            <e:row>
                <e:label for="CEO_USER_NM" title="${form_CEO_USER_NM_N}" />
                <e:field>
                    <e:inputText id="CEO_USER_NM" name="CEO_USER_NM" value="${formData.CEO_USER_NM}" width="${form_CEO_USER_NM_W}" maxLength="${form_CEO_USER_NM_M}" disabled="${form_CEO_USER_NM_D}" readOnly="${form_CEO_USER_NM_RO}" required="${form_CEO_USER_NM_R}" style="${imeMode}" maskType="${form_CEO_USER_NM_MT}"/>
                </e:field>
                <e:label for="HQ_ADDR_2" title="${form_HQ_ADDR_2_N}" />
                <e:field colSpan="3">
                    <e:inputText id="HQ_ADDR_2" name="HQ_ADDR_2" value="${formData.HQ_ADDR_2}" width="${form_HQ_ADDR_2_W}" maxLength="${form_HQ_ADDR_2_M}" disabled="${form_HQ_ADDR_2_D}" readOnly="${form_HQ_ADDR_2_RO}" required="${form_HQ_ADDR_2_R}" style="${imeMode}" maskType="${form_HQ_ADDR_2_MT}"/>
                </e:field>
            </e:row>

            <e:row>
                <e:label for="BUSINESS_TYPE" title="${form_BUSINESS_TYPE_N}" />
                <e:field>
                    <e:inputText id="BUSINESS_TYPE" name="BUSINESS_TYPE" value="${formData.BUSINESS_TYPE}" width="${form_BUSINESS_TYPE_W}" maxLength="${form_BUSINESS_TYPE_M}" disabled="${form_BUSINESS_TYPE_D}" readOnly="${form_BUSINESS_TYPE_RO}" required="${form_BUSINESS_TYPE_R}" style="${imeMode}" maskType="${form_BUSINESS_TYPE_MT}"/>
                </e:field>
                <e:label for="INDUSTRY_TYPE" title="${form_INDUSTRY_TYPE_N}" />
                <e:field>
                    <e:inputText id="INDUSTRY_TYPE" name="INDUSTRY_TYPE" value="${formData.INDUSTRY_TYPE}" width="${form_INDUSTRY_TYPE_W}" maxLength="${form_INDUSTRY_TYPE_M}" disabled="${form_INDUSTRY_TYPE_D}" readOnly="${form_INDUSTRY_TYPE_RO}" required="${form_INDUSTRY_TYPE_R}" style="${imeMode}" maskType="${form_INDUSTRY_TYPE_MT}"/>
                </e:field>
                <e:label for="FOUNDATION_DATE" title="${form_FOUNDATION_DATE_N}"/>
                <e:field>
                    <e:inputDate id="FOUNDATION_DATE" name="FOUNDATION_DATE" value="${formData.FOUNDATION_DATE}" width="${inputDateWidth}" datePicker="true" required="${form_FOUNDATION_DATE_R}" disabled="${form_FOUNDATION_DATE_D}" readOnly="${form_FOUNDATION_DATE_RO}" />
                </e:field>
            </e:row>

            <e:row>
                <e:label for="TEL_NO" title="${form_TEL_NO_N}" />
                <e:field>
                    <e:inputText id="TEL_NO" name="TEL_NO" value="${formData.TEL_NO}" width="${form_TEL_NO_W}" maxLength="${form_TEL_NO_M}" disabled="${form_TEL_NO_D}" readOnly="${form_TEL_NO_RO}" required="${form_TEL_NO_R}" style="${imeMode}" maskType="${form_TEL_NO_MT}"/>
                </e:field>
                <e:label for="FAX_NO" title="${form_FAX_NO_N}" />
                <e:field>
                    <e:inputText id="FAX_NO" name="FAX_NO" value="${formData.FAX_NO}" width="${form_FAX_NO_W}" maxLength="${form_FAX_NO_M}" disabled="${form_FAX_NO_D}" readOnly="${form_FAX_NO_RO}" required="${form_FAX_NO_R}" style="${imeMode}" maskType="${form_FAX_NO_MT}"/>
                </e:field>
                <e:label for="EMAIL" title="${form_EMAIL_N}" />
                <e:field>
                    <e:inputText id="EMAIL" name="EMAIL" value="${formData.EMAIL}" width="${form_EMAIL_W}" maxLength="${form_EMAIL_M}" disabled="${form_EMAIL_D}" readOnly="${form_EMAIL_RO}" required="${form_EMAIL_R}" style="${imeMode}" maskType="${form_EMAIL_MT}"/>
                </e:field>
            </e:row>

            <e:row>
                <e:label for="BUSINESS_REMARK" title="${form_BUSINESS_REMARK_N}"/>
                <e:field colSpan="5">
                    <e:textArea id="BUSINESS_REMARK" name="BUSINESS_REMARK" value="${formData.BUSINESS_REMARK}" height="100px" width="${form_BUSINESS_REMARK_W}" maxLength="${form_BUSINESS_REMARK_M}" disabled="${form_BUSINESS_REMARK_D}" readOnly="${form_BUSINESS_REMARK_RO}" required="${form_BUSINESS_REMARK_R}" />
                </e:field>
            </e:row>

            <e:row>
                <e:label for="REMARK_TEXT" title="${form_REMARK_TEXT_N}"/>
                <e:field colSpan="5">
                    <e:textArea id="REMARK_TEXT" name="REMARK_TEXT" value="${formData.REMARK_TEXT}" height="100px" width="${form_REMARK_TEXT_W}" maxLength="${form_REMARK_TEXT_M}" disabled="${form_REMARK_TEXT_D}" readOnly="${form_REMARK_TEXT_RO}" required="${form_REMARK_TEXT_R}" />
                </e:field>
            </e:row>
        </e:searchPanel>

<%-- 담당자 정보 --%>
        <e:panel id="panel6" height="25px" width="40%">
            <e:title title="${CVNR0011_016}" depth="1" />
        </e:panel>
        <e:gridPanel id="gridCVUR" name="gridCVUR" width="100%" height="180px" gridType="${_gridType}" readOnly="${param.detailView}" />

<%-- 특허 및 취급면허--%>
        <e:panel id="panel" height="25px" width="40%">
            <e:title title="${CVNR0011_002}" depth="1" />
        </e:panel>
        <e:gridPanel id="gridVNSL" name="gridVNSL" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}" />

<%--재무정보--%>
        <e:panel id="panel21" height="25px" width="100%">
            <e:title title="${CVNR0011_006}" depth="1" />
            <span style="position: relative; left: 80px; top: -23px; font-size: 11px; color: #bfbfbf;">${CVNR0011_010}</span>
            <span style="position: relative; top: -18px; font-size: 11px; float: right; font-weight: bold; right: 2px; color: #bfbfbf;">${CVNR0011_007}</span>
        </e:panel>
        <e:searchPanel id="sp21" title="" labelWidth="${labelWidth}" useTitleBar="false" width="100%" columnCount="3">
            <e:row>
                <e:label for="FI_YEAR" title="${form_FI_YEAR_N}"/>
                <e:field>
                    <e:select id="FI_YEAR" name="FI_YEAR" value="${formData.FI_YEAR}" options="${fiYearOptions}" width="${form_FI_YEAR_W}" disabled="${form_FI_YEAR_D}" readOnly="${form_FI_YEAR_RO}" required="${form_FI_YEAR_R}" placeHolder="" maskType="${form_FI_YEAR_MT}" />
                </e:field>
                <e:label for="EVIDENCE_TYPE" title="${form_EVIDENCE_TYPE_N}"/>
                <e:field>
                    <e:select id="EVIDENCE_TYPE" name="EVIDENCE_TYPE" value="${formData.EVIDENCE_TYPE}" options="${evidenceTypeOptions}" width="${form_EVIDENCE_TYPE_W}" disabled="${form_EVIDENCE_TYPE_D}" readOnly="${form_EVIDENCE_TYPE_RO}" required="${form_EVIDENCE_TYPE_R}" placeHolder="" maskType="${form_EVIDENCE_TYPE_MT}" />
                </e:field>

                <e:label for="OWNER_CAPITAL_AMOUNT" title="${form_OWNER_CAPITAL_AMOUNT_N}"/>
                <e:field>
                    <e:inputNumber id="OWNER_CAPITAL_AMOUNT" name="OWNER_CAPITAL_AMOUNT" value="${formData.OWNER_CAPITAL_AMOUNT}" width="${form_OWNER_CAPITAL_AMOUNT_W}" maxValue="${form_OWNER_CAPITAL_AMOUNT_M}" decimalPlace="${form_OWNER_CAPITAL_AMOUNT_NF}" disabled="${form_OWNER_CAPITAL_AMOUNT_D}" readOnly="${form_OWNER_CAPITAL_AMOUNT_RO}" required="${form_OWNER_CAPITAL_AMOUNT_R}" onNumberKr="${form_OWNER_CAPITAL_AMOUNT_KR}" currencyText="${form_OWNER_CAPITAL_AMOUNT_CT}"/>
                </e:field>
            </e:row>

            <e:row>
                <e:label for="TOT_FUND_AMT" title="${form_TOT_FUND_AMT_N}"/>
                <e:field>
                    <e:inputNumber id="TOT_FUND_AMT" name="TOT_FUND_AMT" value="${formData.TOT_FUND_AMT}" onChange="onChangeEXEC" width="${form_TOT_FUND_AMT_W}" maxValue="${form_TOT_FUND_AMT_M}" decimalPlace="${form_TOT_FUND_AMT_NF}" disabled="${form_TOT_FUND_AMT_D}" readOnly="${form_TOT_FUND_AMT_RO}" required="${form_TOT_FUND_AMT_R}" onNumberKr="${form_TOT_FUND_AMT_KR}" currencyText="${form_TOT_FUND_AMT_CT}"/>
                </e:field>
                <e:label for="TOT_LIAB_AMT" title="${form_TOT_LIAB_AMT_N}"/>
                <e:field>
                    <e:inputNumber id="TOT_LIAB_AMT" name="TOT_LIAB_AMT" value="${formData.TOT_LIAB_AMT}" onChange="onChangeEXEC" width="${form_TOT_LIAB_AMT_W}" maxValue="${form_TOT_LIAB_AMT_M}" decimalPlace="${form_TOT_LIAB_AMT_NF}" disabled="${form_TOT_LIAB_AMT_D}" readOnly="${form_TOT_LIAB_AMT_RO}" required="${form_TOT_LIAB_AMT_R}" onNumberKr="${form_TOT_LIAB_AMT_KR}" currencyText="${form_TOT_LIAB_AMT_CT}"/>
                </e:field>
                <e:label for="TOTAL_LIABILITY_RATE" title="${form_TOTAL_LIABILITY_RATE_N}"/>
                <e:field>
                    <e:inputNumber id="TOTAL_LIABILITY_RATE" name="TOTAL_LIABILITY_RATE" value="${formData.TOTAL_LIABILITY_RATE}" width="${form_TOTAL_LIABILITY_RATE_W}" maxValue="${form_TOTAL_LIABILITY_RATE_M}" decimalPlace="${form_TOTAL_LIABILITY_RATE_NF}" disabled="${form_TOTAL_LIABILITY_RATE_D}" readOnly="${form_TOTAL_LIABILITY_RATE_RO}" required="${form_TOTAL_LIABILITY_RATE_R}" onNumberKr="${form_TOTAL_LIABILITY_RATE_KR}" currencyText="${form_TOTAL_LIABILITY_RATE_CT}"/>
                </e:field>
            </e:row>

            <e:row>
                <e:label for="CURRENT_ASSET_AMOUNT" title="${form_CURRENT_ASSET_AMOUNT_N}"/>
                <e:field>
                    <e:inputNumber id="CURRENT_ASSET_AMOUNT" name="CURRENT_ASSET_AMOUNT" value="${formData.CURRENT_ASSET_AMOUNT}" onChange="onChangeEXEC" width="${form_CURRENT_ASSET_AMOUNT_W}" maxValue="${form_CURRENT_ASSET_AMOUNT_M}" decimalPlace="${form_CURRENT_ASSET_AMOUNT_NF}" disabled="${form_CURRENT_ASSET_AMOUNT_D}" readOnly="${form_CURRENT_ASSET_AMOUNT_RO}" required="${form_CURRENT_ASSET_AMOUNT_R}" onNumberKr="${form_CURRENT_ASSET_AMOUNT_KR}" currencyText="${form_CURRENT_ASSET_AMOUNT_CT}"/>
                </e:field>
                <e:label for="CURRENT_ASSET_LIABILITY_AMOUNT" title="${form_CURRENT_ASSET_LIABILITY_AMOUNT_N}"/>
                <e:field>
                    <e:inputNumber id="CURRENT_ASSET_LIABILITY_AMOUNT" name="CURRENT_ASSET_LIABILITY_AMOUNT" value="${formData.CURRENT_ASSET_LIABILITY_AMOUNT}" onChange="onChangeEXEC" width="${form_CURRENT_ASSET_LIABILITY_AMOUNT_W}" maxValue="${form_CURRENT_ASSET_LIABILITY_AMOUNT_M}" decimalPlace="${form_CURRENT_ASSET_LIABILITY_AMOUNT_NF}" disabled="${form_CURRENT_ASSET_LIABILITY_AMOUNT_D}" readOnly="${form_CURRENT_ASSET_LIABILITY_AMOUNT_RO}" required="${form_CURRENT_ASSET_LIABILITY_AMOUNT_R}" onNumberKr="${form_CURRENT_ASSET_LIABILITY_AMOUNT_KR}" currencyText="${form_CURRENT_ASSET_LIABILITY_AMOUNT_CT}"/>
                </e:field>
                <e:label for="CURRENT_ASSET_LIABILITY_RATE" title="${form_CURRENT_ASSET_LIABILITY_RATE_N}"/>
                <e:field>
                    <e:inputNumber id="CURRENT_ASSET_LIABILITY_RATE" name="CURRENT_ASSET_LIABILITY_RATE" value="${formData.CURRENT_ASSET_LIABILITY_RATE}" width="${form_CURRENT_ASSET_LIABILITY_RATE_W}" maxValue="${form_CURRENT_ASSET_LIABILITY_RATE_M}" decimalPlace="${form_CURRENT_ASSET_LIABILITY_RATE_NF}" disabled="${form_CURRENT_ASSET_LIABILITY_RATE_D}" readOnly="${form_CURRENT_ASSET_LIABILITY_RATE_RO}" required="${form_CURRENT_ASSET_LIABILITY_RATE_R}" onNumberKr="${form_CURRENT_ASSET_LIABILITY_RATE_KR}" currencyText="${form_CURRENT_ASSET_LIABILITY_RATE_CT}"/>
                </e:field>
            </e:row>

            <e:row>
                <e:label for="SALES_AMOUNT" title="${form_SALES_AMOUNT_N}"/>
                <e:field>
                    <e:inputNumber id="SALES_AMOUNT" name="SALES_AMOUNT" value="${formData.SALES_AMOUNT}" width="${form_SALES_AMOUNT_W}" maxValue="${form_SALES_AMOUNT_M}" decimalPlace="${form_SALES_AMOUNT_NF}" disabled="${form_SALES_AMOUNT_D}" readOnly="${form_SALES_AMOUNT_RO}" required="${form_SALES_AMOUNT_R}" onNumberKr="${form_SALES_AMOUNT_KR}" currencyText="${form_SALES_AMOUNT_CT}"/>
                </e:field>
                <e:label for="NET_PROFIT_AMOUNT" title="${form_NET_PROFIT_AMOUNT_N}"/>
                <e:field>
                    <e:inputNumber id="NET_PROFIT_AMOUNT" name="NET_PROFIT_AMOUNT" value="${formData.NET_PROFIT_AMOUNT}" width="${form_NET_PROFIT_AMOUNT_W}" maxValue="${form_NET_PROFIT_AMOUNT_M}" decimalPlace="${form_NET_PROFIT_AMOUNT_NF}" disabled="${form_NET_PROFIT_AMOUNT_D}" readOnly="${form_NET_PROFIT_AMOUNT_RO}" required="${form_NET_PROFIT_AMOUNT_R}" onNumberKr="${form_NET_PROFIT_AMOUNT_KR}" currencyText="${form_NET_PROFIT_AMOUNT_CT}"/>
                </e:field>
                <e:label for="" title="">
                    <e:button id="doAttFIleNum" name="doAttFIleNum" label="${form_VNFI_ATT_FILE_NUM_CNT_N}" onClick="doAttFIleNum" style="margin-top: -1px;" disabled="${formData.VNFI_ATT_FILE_NUM_CNT==null?true:false}" visible="true"/>
                </e:label>
                <e:field>
                    <e:inputHidden id="VNFI_ATT_FILE_NUM" name="VNFI_ATT_FILE_NUM" value="${formData.VNFI_ATT_FILE_NUM}"/>
                    <e:text><a href="javascript:doAttFIleNum();">${formData.VNFI_ATT_FILE_NUM_CNT==null?'0':formData.VNFI_ATT_FILE_NUM_CNT}건</a></e:text>
                </e:field>
            </e:row>

        </e:searchPanel>

<%--관리정보--%>
        <e:panel id="panel2" height="25px" width="40%">
            <e:title title="${CVNR0011_003}" depth="1" />
        </e:panel>
        <e:searchPanel id="sp2" title="" labelWidth="${labelWidth}" useTitleBar="false" width="100%" columnCount="3">
            <e:row>
                <e:label for="E_BILL_ASP_TYPE" title="${form_E_BILL_ASP_TYPE_N}"/>
                <e:field>
                    <e:select id="E_BILL_ASP_TYPE" name="E_BILL_ASP_TYPE" value="${formData.E_BILL_ASP_TYPE}" options="${eBillAspTypeOptions}" width="${form_E_BILL_ASP_TYPE_W}" disabled="${form_E_BILL_ASP_TYPE_D}" readOnly="${form_E_BILL_ASP_TYPE_RO}" required="${form_E_BILL_ASP_TYPE_R}" placeHolder="" usePlaceHolder="false" maskType="${form_E_BILL_ASP_TYPE_MT}" />
                </e:field>
                <e:label for="TAX_ASP_NM" title="${form_TAX_ASP_NM_N}" />
                <e:field>
                    <e:inputText id="TAX_ASP_NM" name="TAX_ASP_NM" value="${formData.TAX_ASP_NM}" width="${form_TAX_ASP_NM_W}" maxLength="${form_TAX_ASP_NM_M}" disabled="${form_TAX_ASP_NM_D}" readOnly="${form_TAX_ASP_NM_RO}" required="${form_TAX_ASP_NM_R}" style="${imeMode}" maskType="${form_TAX_ASP_NM_MT}"/>
                </e:field>
                <e:label for="TAX_SEND_TYPE" title="${form_TAX_SEND_TYPE_N}"/>
                <e:field>
                    <e:select id="TAX_SEND_TYPE" name="TAX_SEND_TYPE" value="${formData.TAX_SEND_TYPE}" options="${taxSendTypeOptions}" width="${form_TAX_SEND_TYPE_W}" disabled="${form_TAX_SEND_TYPE_D}" readOnly="${form_TAX_SEND_TYPE_RO}" required="${form_TAX_SEND_TYPE_R}" placeHolder="" usePlaceHolder="false" maskType="${form_TAX_SEND_TYPE_MT}" />
                </e:field>
            </e:row>

            <e:row>
                <e:label for="CREDIT_EVAL_COMPANY" title="${form_CREDIT_EVAL_COMPANY_N}" />
                <e:field>
                    <e:inputText id="CREDIT_EVAL_COMPANY" name="CREDIT_EVAL_COMPANY" value="${formData.CREDIT_EVAL_COMPANY}" width="${form_CREDIT_EVAL_COMPANY_W}" maxLength="${form_CREDIT_EVAL_COMPANY_M}" disabled="${form_CREDIT_EVAL_COMPANY_D}" readOnly="${form_CREDIT_EVAL_COMPANY_RO}" required="${form_CREDIT_EVAL_COMPANY_R}" style="${imeMode}" maskType="${form_CREDIT_EVAL_COMPANY_MT}"/>
                </e:field>
                <e:label for="CREDIT_CD" title="${form_CREDIT_CD_N}"/>
                <e:field>
                    <e:select id="CREDIT_CD" name="CREDIT_CD" value="${formData.CREDIT_CD}" options="${creditCdOptions}" width="${form_CREDIT_CD_W}" disabled="${form_CREDIT_CD_D}" readOnly="${form_CREDIT_CD_RO}" required="${form_CREDIT_CD_R}" placeHolder="" maskType="${form_CREDIT_CD_MT}" />
                </e:field>
                <e:label for="" title="">
                    <e:button id="doEvAttFIleNum" name="doEvAttFIleNum" label="${form_EV_ATT_FILE_NUM_CNT_N}" onClick="doEvAttFIleNum" style="margin-top: -1px;" disabled="${formData.EV_ATT_FILE_NUM_CNT==null?true:false}" visible="true"/>
                </e:label>
                <e:field>
                    <e:inputHidden id="EV_ATT_FILE_NUM" name="EV_ATT_FILE_NUM" value="${formData.EV_ATT_FILE_NUM}"/>
                    <e:text><a href="javascript:doEvAttFIleNum();">${formData.EV_ATT_FILE_NUM_CNT==null?'0':formData.EV_ATT_FILE_NUM_CNT}건</a></e:text>
                </e:field>
            </e:row>
            <e:row>
                <e:label for="NICE_DB_GRD" title="${form_NICE_DB_GRD_N}" />
                <e:field>
                    <e:text><a href="javascript:onClickNICE_DB_GRD();">${formData.NICE_DB_GRD==null?"link":formData.NICE_DB_GRD}</a></e:text>
                </e:field>
                <e:label for="NICE_DB_EST" title="${form_NICE_DB_EST_N}" />
                <e:field>
                    <e:text><a href="javascript:onClickNICE_DB_EST();">${formData.NICE_DB_GRD==null?"link":formData.NICE_DB_GRD}</a></e:text>
                </e:field>
                <e:label for="KED_GRD" title="${form_KED_GRD_N}" />
                <e:field>
                    <e:text><a href="javascript:onClickKED_GRD();">${formData.KED_GRD==null?"link":formData.KED_GRD}</a></e:text>
                </e:field>
                <%--
                <e:label for="REG_DATE" title="${form_REG_DATE_N}" />
                <e:field>
                    <e:inputText id="REG_DATE" name="REG_DATE" value="${formData.REG_DATE}" width="${form_REG_DATE_W}" maxLength="${form_REG_DATE_M}" disabled="${form_REG_DATE_D}" readOnly="${form_REG_DATE_RO}" required="${form_REG_DATE_R}" style="${imeMode}" maskType="${form_REG_DATE_MT}"/>
                </e:field>
                --%>
            </e:row>

            <e:row>
                <e:label for="PROGRESS_NM" title="${form_PROGRESS_NM_N}" />
                <e:field>
                    <e:inputText id="PROGRESS_NM" name="PROGRESS_NM" value="${formData.PROGRESS_NM}" width="${form_PROGRESS_NM_W}" maxLength="${form_PROGRESS_NM_M}" disabled="${form_PROGRESS_NM_D}" readOnly="${form_PROGRESS_NM_RO}" required="${form_PROGRESS_NM_R}" style="${imeMode}" maskType="${form_PROGRESS_NM_MT}"/>
                </e:field>
                <e:label for="MOD_USER_NM" title="${form_MOD_USER_NM_N}" />
                <e:field>
                    <e:inputText id="MOD_USER_NM" name="MOD_USER_NM" value="${formData.MOD_USER_NM}" width="${form_MOD_USER_NM_W}" maxLength="${form_MOD_USER_NM_M}" disabled="${form_MOD_USER_NM_D}" readOnly="${form_MOD_USER_NM_RO}" required="${form_MOD_USER_NM_R}" style="${imeMode}" maskType="${form_MOD_USER_NM_MT}"/>
                </e:field>
                <e:label for="MOD_DATE" title="${form_MOD_DATE_N}" />
                <e:field>
                    <e:inputText id="MOD_DATE" name="MOD_DATE" value="${formData.MOD_DATE}" width="${form_MOD_DATE_W}" maxLength="${form_MOD_DATE_M}" disabled="${form_MOD_DATE_D}" readOnly="${form_MOD_DATE_RO}" required="${form_MOD_DATE_R}" style="${imeMode}" maskType="${form_MOD_DATE_MT}"/>
                </e:field>
            </e:row>
        </e:searchPanel>

<%--결제정보--%>
        <e:panel id="panel3" height="25px" width="40%">
            <e:title title="${CVNR0011_004}" depth="1" />
        </e:panel>
        <e:searchPanel id="sp3" title="" labelWidth="${labelWidth}" useTitleBar="false" width="100%" columnCount="3">
            <e:row>
                <e:label for="PAY_CONDITION" title="${form_PAY_CONDITION_N}"/>
                <e:field>
                    <e:select id="PAY_CONDITION" name="PAY_CONDITION" value="${formData.PAY_CONDITION}" options="${payConditionOptions}" width="${form_PAY_CONDITION_W}" disabled="${form_PAY_CONDITION_D}" readOnly="${form_PAY_CONDITION_RO}" required="${form_PAY_CONDITION_R}" placeHolder="" maskType="${form_PAY_CONDITION_MT}" />
                </e:field>
                <e:label for="PAY_TYPE" title="${form_PAY_TYPE_N}"/>
                <e:field>
                    <e:select id="PAY_TYPE" name="PAY_TYPE" value="${formData.PAY_TYPE}" options="${payTypeOptions}" width="${form_PAY_TYPE_W}" disabled="${form_PAY_TYPE_D}" readOnly="${form_PAY_TYPE_RO}" required="${form_PAY_TYPE_R}" placeHolder="" maskType="${form_PAY_TYPE_MT}" />
                </e:field>
                <e:label for="PAY_PUBLIC_TYPE" title="${form_PAY_PUBLIC_TYPE_N}"/>
                <e:field>
                    <e:select id="PAY_PUBLIC_TYPE" name="PAY_PUBLIC_TYPE" value="${formData.PAY_PUBLIC_TYPE}" options="${payPublicTypeOptions}" width="${form_PAY_PUBLIC_TYPE_W}" disabled="${form_PAY_PUBLIC_TYPE_D}" readOnly="${form_PAY_PUBLIC_TYPE_RO}" required="${form_PAY_PUBLIC_TYPE_R}" placeHolder="" maskType="${form_PAY_PUBLIC_TYPE_MT}" />
                </e:field>
            </e:row>
        </e:searchPanel>

        <e:gridPanel id="gridVNAP" name="gridVNAP" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}" />

<%--첨부파일--%>
        <e:panel id="pane4" height="25px" width="40%">
            <e:title title="${CVNR0011_005}" depth="1" />
        </e:panel>
        <e:gridPanel id="gridATTD" name="gridATTD" width="100%" height="240px" gridType="${_gridType}" readOnly="${param.detailView}" />

<%--거래희망 고객사--%>
        <e:panel id="pane5" height="25px" width="40%">
            <e:title title="${CVNR0011_008}" depth="1" />
        </e:panel>
        <e:gridPanel id="gridVNCM" name="gridVNCM" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}" />

        <e:buttonBar width="100%" align="right">

            <e:button id="doConfirm2" name="doConfirm2" label="${doConfirm_N}" onClick="doConfirm" disabled="${doConfirm_D}" visible="${doConfirm_V}"/>
            <e:button id="doReject2" name="doReject2" label="${doReject_N}" onClick="doReject" disabled="${doReject_D}" visible="${doReject_V}"/>
            <e:button id="doClose2" name="doClose2" label="${doClose_N}" onClick="doClose" disabled="${doClose_D}" visible="${doClose_V}"/>
        </e:buttonBar>
    </e:window>
</e:ui>
