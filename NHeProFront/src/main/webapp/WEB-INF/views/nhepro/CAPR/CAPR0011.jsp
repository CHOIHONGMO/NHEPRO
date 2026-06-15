<%@ page import="com.st_ones.everf.serverside.config.PropertiesManager" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="com.st_ones.everf.serverside.config.PropertiesManager" %>
<%@ include file="/WEB-INF/views/common/ozUrlInfo.jsp" %>


<%
	String ozSchedulerIp = PropertiesManager.getString("oz.scheduler.ip");
	String ozSchedulerPort = PropertiesManager.getString("oz.scheduler.port");
	response.addHeader("Access-Control-Allow-Origin", "*");
%>

<c:set var="ozExportUrl" value="<%=ozExportUrl%>" />
<c:set var="ozUrl" value="<%=ozUrl%>" />
<c:set var="ozServer" value="<%=ozServer%>" />
<c:set var="ozSchedulerIp" value="<%=ozSchedulerIp%>" />
<c:set var="ozSchedulerPort" value="<%=ozSchedulerPort%>" />

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
    <script type="text/javascript">
        var gridPODT;
        var gridIVAP;
        var baseUrl = "/nhepro/CAPR/";
        var detailView = "${param.detailView}" == "true";
        var PROGRESS_CD = "${param.PROGRESS_CD}";
        var SignStatus = "${param.SIGN_STATUS}";
        var ApUser = false;

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

            gridPODT.cellClickEvent(function(rowIdx, colIdx, value) {
                var param;
                if(colIdx == "PO_NUM") {
                    param = {
                        callbackFunction: "",
                        BUYER_CD: gridPODT.getCellValue(rowIdx, "BUYER_CD"),
                        PO_NUM: value,
                        detailView: true,
                        buttonView: false
                    };
                    everPopup.openPopupByScreenId("CPOI0010", 1200, 750, param);
                }
            });
            
            gridPODT.cellChangeEvent(function (rowIdx, colIdx, irow, icol, value, oldValue) {
            });
            
            
            // 2024.06.08
            //대금지급담당자외에도 PDF파일 생성을 하기위해 버튼 제어 로직 추가
            if (detailView == true) {
            	
            	if(EVF.V("AP_USER_ID") == "${ses.userId}"){
            		if(EVF.V("PROGRESS_CD") != "20" || EVF.V("SIGN_STATUS") == "E" || EVF.V("SIGN_STATUS") == "P"){
            			EVF.C('doSave').setVisible(false);
                		EVF.C('doReject').setVisible(false);
                		EVF.C('doUpdateApproval').setVisible(false);
            		} else {
            			EVF.C('doSave').setVisible(true);
                		EVF.C('doReject').setVisible(true);
                		EVF.C('doUpdateApproval').setVisible(true);
                		EVF.C('doSave').setDisabled(false);
                		EVF.C('doReject').setDisabled(false);
                		EVF.C('doUpdateApproval').setDisabled(false);
            		}
            	} else {
            		EVF.C('doSave').setVisible(false);
            		EVF.C('doReject').setVisible(false);
            		EVF.C('doUpdateApproval').setVisible(false);
            	}
            	
            	if(EVF.V("PROGRESS_CD") != "40"){
					EVF.C('doPDFCreate').setVisible(true);
					EVF.C('doPDFCreate').setDisabled(false);
            	} 
            }
			
         	// 폼 셋팅
			doSetDefaultForm();
         
            doSearchIVDT();
            doSearchIVAP();
            // $("#sp2").hide();
            
        }
        
        function doSetDefaultForm() {
        	var pdfAttFileNum = EVF.V("PDF_ATT_FILE_NUM");
        	if( pdfAttFileNum != "" ) {
        		EVF.C('AP_NUM').setStyle('color:blue;font-weight:bold;');
        	}
        }

        function onIconClickPAY_BANK_NM() {
            var	param =	{
                callBackFunction: "callBackPAY_BANK_NM",
                VENDOR_CD: "${ses.companyCd}"
            };
            everPopup.openCommonPopup(param, 'SP0126');
        }

        function callBackPAY_BANK_NM(data) {
            EVF.V("PAY_ACCOUNT_NUM", data.PAY_ACCOUNT_NUM);
            EVF.V("PAY_BANK", data.PAY_BANK);
            EVF.V("PAY_BANK_NM", data.PAY_BANK_NM);
            EVF.V("PAY_ACC_NM", data.PAY_ACC_NM);
        }
        
        function onIconClickPAY_ATT_FILE_CNT() {
            var param = {
                bizType: "OM",
                attFileNum: EVF.V("PAY_ATT_FILE_NUM"),
                callBackFunction: "callBackPAY_ATT_FILE_CNT",
                detailView: true
            };

            everPopup.fileAttachPopup(param);
        }
        
        function callBackPAY_ATT_FILE_CNT(a, b, c) {
            EVF.V("PAY_ATT_FILE_NUM", b);
            EVF.V("PAY_ATT_FILE_CNT", c);
        }

        function onIconClickAP_USER_ID() {
            var param = {
                callBackFunction: "callBackAP_USER_ID"
            };
            everPopup.openCommonPopup(param, "SP0125");
        }

        function callBackAP_USER_ID(data) {
            EVF.V("AP_USER_ID", data.CTRL_USER_ID);
            EVF.V("AP_USER_NM", data.CTRL_USER_NM);
        }

        function onIconClickBILL_ATT_FILE_CNT() {
            var param = {
                bizType: "OM",
                attFileNum: EVF.V("BILL_ATT_FILE_NUM"),
                callBackFunction: "callBackBILL_ATT_FILE_CNT",
                detailView: true
            };

            everPopup.fileAttachPopup(param);
        }
        
        function callBackBILL_ATT_FILE_CNT(a, b, c) {
            EVF.V("BILL_ATT_FILE_NUM", b);
            EVF.V("BILL_ATT_FILE_CNT", c);
        }
        
        //2021.02.03 중앙회 요청 "협력사 사업자등록번호, 사업자등록증 파일첨부" 표시
        function onIconClickATTS_ATT_FILE_NUM_CNT() {
        	var param = {
        			bizType: "BI",
                    attFileNum: EVF.V("ATTS_ATT_FILE_NUM"),
                    callBackFunction: "callBackATTS_ATT_FILE_NUM_CNT",
                    detailView: true
            };

            everPopup.fileAttachPopup(param);
        }
        
        //2024.03.29 대금지급 관련 PDF병합 파일 다운로드 팝업 오픈
        var winPop;
		function onApNum() {
			var pdfAttFileNum = EVF.V('PDF_ATT_FILE_NUM');
			var apNum = EVF.V('AP_NUM');
			if( pdfAttFileNum != "" ) {
				var url = "/common/file/fileAttach/contViewPdf.so?EVER_REQUEST_DATA_TYPE=FILE_DOWNLOAD&UUID=" + pdfAttFileNum + "&AP_NUM=" + apNum;
				url = XSSCheck(url, 1);
				
				// 2021.08.23 : 익스플로러 : 동일 name의 팝업이 2개 이상 열리는 버그로 인해...
				//window.open(url, "eform", "width=850,height=1265,scrollbars=yes,resizeable=no,left=0,top=0");
				if(!winPop || (winPop && winPop.closed)){
					winPop = window.open(url, "eform", "width=850,height=1265,scrollbars=yes,resizeable=no,left=0,top=0");
				} else {
					winPop.location.href = url;
				}
			} else {
				return EVF.alert('병합된 PDF파일이 존재하지 않습니다.');
			}
		}
		
		function XSSCheck(str, level){
			if(level == undefined || level == 0) {
				str = str.replace(/\<|\>|\"|\'|\%|\;|\(|\)|\&|\+|\-/g, " ");
			} else if (level != undefined && level == 1){
				str = str.replace(/\</g, "&lt:")	
				str = str.replace(/\>/g, "&gt:");	
			}
			return str;
		}
		
        //보증방법 선택 시
        /* function onChangeGUAR_TYPE2(a, b) {
            if(b == "10") {     // 10:수기, 20:전자보증
                EVF.C("GUAR_ATT_FILE_NUM").setRequired(true);
                EVF.C("GUARANTEER").setRequired(true);
                EVF.C("BOND_BEGN_DATE").setRequired(true);
                EVF.C("BOND_FNSH_DATE").setRequired(true);
            } else if(b == "20") {
                EVF.C("GUAR_ATT_FILE_NUM").setRequired(false);
                EVF.C("GUARANTEER").setRequired(true);
                EVF.C("BOND_BEGN_DATE").setRequired(false);
                EVF.C("BOND_FNSH_DATE").setRequired(false);
            } else {
                EVF.C("GUAR_ATT_FILE_NUM").setRequired(false);
                EVF.C("GUARANTEER").setRequired(false);
                EVF.C("BOND_BEGN_DATE").setRequired(false);
                EVF.C("BOND_FNSH_DATE").setRequired(false);
            }
        } */
		
        //보증기관 선택 시 
        /* function onChangeGUARANTEER(a, b, c) {
            var GUAR_TYPE2 = EVF.V("GUAR_TYPE2");

            if(GUAR_TYPE2 == "20") {
                if(!(b == "10" || b == "20" || b == "")) {
                    EVF.V("GUARANTEER", c);
                    EVF.alert("${CAPR0011_012}");
                }
            }
        } */

        function doSearchIVAP() {
            var store = new EVF.Store();
            store.setGrid([gridIVAP]);
            store.load(baseUrl + "capr0011_doSearchIVAP.so", function() {
            });
        }

        function doSearchIVDT() {
            var store = new EVF.Store();
            store.setGrid([gridPODT]);
            store.load(baseUrl + "capr0011_doSearchIVDT.so", function() {
            });
        }
        
        //2021.12.13 멀티결재상신 전 대금지급요청서 내용 수정필요 저장기능 추가(구매팀요청)
        function doSave() {
        	
            var store = new EVF.Store();
            if(!store.validate()) { return; }

            store.load(baseUrl + "capr0011_doUpdateIVAP.so", function() {
                opener.doSearch();
				
                var BUYER_CD = this.getParameter('BUYER_CD');
				var AP_NUM   = this.getParameter('AP_NUM');
				
                EVF.alert(this.getResponseMessage(), function () {
                	
                	var param = {
							'BUYER_CD': BUYER_CD,
							'AP_NUM': AP_NUM,
							'popupFlag' : true,
							'detailView': false
						};
                	
                	document.location.href = baseUrl + 'CAPR0011/view.so?' + $.param(param);
                    //doClose();
                });
            });
        }

        function doReject() {
        	
        	var param = {
   				title : '대금청구 반송사유',
   				callbackFunction : 'setRejectApproval',
   				detailView : false
   			};
   			everPopup.commonTextInput(param);
        }
        
        function setRejectApproval(data) {
        	var store = new EVF.Store();
			
        	if( data != undefined && data != null ) {
				EVF.C("AP_REJECT_RMK").setValue(data.message);
			}
        	
            EVF.confirm("${CAPR0011_014}", function () {
                store.setGrid([gridPODT]);
                store.getGridData(gridPODT, "all");
                store.load(baseUrl + "capr0011_doReject.so", function() {
                    opener.doSearch();

                    EVF.alert(this.getResponseMessage(), function () {
                        doClose();
                    });
                });
            });
        }

        function doUpdateApproval() {
            var store = new EVF.Store();
            if(!store.validate()) { return; }

            var preSignStatus = EVF.V("PRE_SIGN_STATUS");
            if (preSignStatus != "E") {
                EVF.V("SIGN_STATUS", "P");
            }

            EVF.confirm("${msg.M0053}", function () {
                var param = {
                    subject: EVF.V("AP_REQ_SUBJECT"),
                    docType: EVF.V("DOC_TYPE"),
                    signStatus: "P",
                    screenId: "CAPR011",
                    approvalType: "APPROVAL",
                    attFileNum: "",
                    docNum: EVF.V("AP_NUM"),
                    appDocNum: EVF.V("APP_DOC_NUM"),
                    callBackFunction: "goApproval",
                    appAmt: EVF.V("PAY_AMT")
                };
                everPopup.openApprovalRequestIPopup(param);
            });
        }

        function goApproval(formData, gridData, attachData) {
            EVF.V("approvalFormData", formData);
            EVF.V("approvalGridData", gridData);
            EVF.V("attachFileDatas", attachData);

            var store = new EVF.Store();
            if(!store.validate()) { return; }

            store.load(baseUrl + "capr0011_doUpdateApproval.so", function() {
                opener.doSearch();

                EVF.alert(this.getResponseMessage(), function () {
                    doClose();
                });
            });
        }
        
        function doPDFCreate() {
        	
        	var progressCd = EVF.V("PROGRESS_CD"); 
        	var buyerCd = EVF.V("BUYER_CD");
        	var pyBuyerCd = EVF.V("PY_BUYER_CD");
        	var pyDeptCd = EVF.V("PY_DEPT_CD");
        	var apNum = EVF.V("AP_NUM");
        	var pdfAttFileNum = EVF.V("PDF_ATT_FILE_NUM");
        	var fileCnt = 0;
        	var maxFileCnt = 0;
        	// 서브 폼 파일명을 가져온다.
			var subFormFileNm = "";
        	
			// pdf 저장
			var odiParamVal = "BUYER_CD=" + buyerCd + ",CONT_NUM=" + apNum;
			var param = {
					bizType: "OM",
	                SUB_FORM_FILE_NM: "",
					odiName: "DANIL_INFO",
					ozrName: "CAPR1000",
					// OZ Scheduler Info
					serverUrl: "${ozServer}",
					schedulerIp: "${ozSchedulerIp}",
					schedulerPort: "${ozSchedulerPort}",
					exportFileName: buyerCd + apNum,
					odiParamVal: odiParamVal,
					url: "${ozUrl}",
					exportFormat: "pdf"
			};
			
			console.log("동기화 방식 OZ Scheduler 페이지 호출 시작"); 
			
			$.ajax({
				url: "${ozUrl}" + "/oz_export_directexport.jsp",
				type: "post",
				data: param,
				async: false,
				success: function(data) {
		        	param = {
			        		bizType: "OM",
			                fileNm: buyerCd + apNum,
			                fileExtension: "pdf",
			                BUYER_CD: buyerCd,
			                AP_NUM: apNum
					};
        	
		        	$.ajax({
						url: "/common/file/apPdfMergeAttach.so",
						type: "post",
						data: param,
						async: false,
						success: function(data) {		
							param = {
								bizType: "OM",
								fileNm: "${ses.companyCd}" + apNum,
								fileExtension: "pdf",
								AP_NUM: apNum,
								buyerCd: buyerCd,
								prBuyerCd: pyBuyerCd,
								prDeptCd: pyDeptCd,
								uuid: pdfAttFileNum,
								fileCnt: 1,
								maxFileCnt: 1
							};
		
							console.log("동기화 방식 pdf 생성 파일 이동 시작");
							$.ajax({
								url: "/common/file/apPdfUpload.so",
								type: "post",
								data: param,
								async: false,
								success: function(data) {
									console.log("동기화 방식 pdf 생성 파일 이동 완료");
									console.log("동기화 방식 pdf 생성 파일 DB 관리 위해 채번");
									// STOCATCH 저장 후 PDF UUID 저장(개별 처리)
									$.ajax({
										url: baseUrl + "capr0011_doUpdatePdfUUID.so",
										type: "post",
										data: {json: data},
										async: false,
										success: function(data) {
											console.log("동기화 방식 pdf 생성 파일 DB 관리 위해 채번 완료");
											console.log("fileCnt ====> " + fileCnt);
											console.log("maxFileCnt ====> " + maxFileCnt);
											if(fileCnt == maxFileCnt) {
												console.log("팝업 document.location.href")
												EVF.alert('성공적으로 PDF파일이 생성되었습니다.');
												var param = {
														'BUYER_CD': buyerCd,
														'AP_NUM': apNum,
														'popupFlag' : true,
														'detailView': true
													};
							                	
							                	document.location.href = baseUrl + 'CAPR0011/view.so?' + $.param(param);
												if(opener) {
													opener['doSearch']();
												}
											}
										}
									});
								}
							});
						}
					});
				}
			});	
        }

        function doClose() {
            EVF.closeWindow();
        }
    </script>

    <e:window id="CAPR0011" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">
        <e:buttonBar width="100%" align="right" title="${CAPR0011_001}">
        	<e:button id="doSave" name="doSave" label="${doSave_N}" onClick="doSave" disabled="${doSave_D}" visible="${doSave_V}"/>
            <e:button id="doReject" name="doReject" label="${doReject_N}" onClick="doReject" disabled="${doReject_D}" visible="${doReject_V}"/>
            <e:button id="doUpdateApproval" name="doUpdateApproval" label="${doUpdateApproval_N}" onClick="doUpdateApproval" disabled="${doUpdateApproval_D}" visible="${doUpdateApproval_V}"/>
            <e:button id="doPDFCreate" name="doPDFCreate" label="${doPDFCreate_N}" onClick="doPDFCreate" disabled="${doPDFCreate_D}" visible="${doPDFCreate_V}"/>
            <e:button id="doClose" name="doClose" label="${doClose_N}" onClick="doClose" disabled="${doClose_D}" visible="${doClose_V}"/>
        </e:buttonBar>

        <e:inputHidden id="BUYER_CD" name="BUYER_CD" value="${formData.BUYER_CD}"/>
        <e:inputHidden id="DEPT_CD" name="DEPT_CD" value="${formData.DEPT_CD}"/>
        <e:inputHidden id="PIC_USER_ID" name="PIC_USER_ID" value="${formData.PIC_USER_ID}"/>
        <e:inputHidden id="RMK_TEXT_NUM" name="RMK_TEXT_NUM" value="${formData.RMK_TEXT_NUM }" />
        <e:inputHidden id="CTRL_USER_ID" name="CTRL_USER_ID" value="${formData.CTRL_USER_ID }" />
        <e:inputHidden id="INSPECT_USER_ID" name="INSPECT_USER_ID" value="${formData.INSPECT_USER_ID }" />
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
        <e:inputHidden id="PROGRESS_CD" name="PROGRESS_CD" value="${formData.PROGRESS_CD }" />
        
        <!-- 21.02.03 중앙회 요청 "협력사 사업자등록번호, 사업자등록증 파일첨부" 표시 -->
		<e:inputHidden id="ATTS_ATT_FILE_NUM" name="ATTS_ATT_FILE_NUM" value="${formData.ATTS_ATT_FILE_NUM }" />
		
        <e:inputHidden id="approvalFormData" name="approvalFormData"/>
        <e:inputHidden id="approvalGridData" name="approvalGridData"/>
        <e:inputHidden id="attachFileDatas" name="attachFileDatas" visible="false"/>
        <e:inputHidden id="APP_DOC_NUM" name="APP_DOC_NUM" value="${empty param.appDocNum ? formData.APP_DOC_NUM : param.appDocNum}" />
        <e:inputHidden id="APP_DOC_CNT" name="APP_DOC_CNT" value="${formData.APP_DOC_CNT}" />
        <e:inputHidden id="PRE_SIGN_STATUS" name="PRE_SIGN_STATUS" value="${formData.APP_DOC_SIGN_STATUS}" />
        <e:inputHidden id="SIGN_STATUS" name="SIGN_STATUS" value="${formData.APP_DOC_SIGN_STATUS}" />
        <e:inputHidden id="DOC_TYPE" name="DOC_TYPE" value="AP"/>
        <e:inputHidden id="AP_REJECT_RMK" name="AP_REJECT_RMK" />
		
		<e:inputHidden id="PDF_ATT_FILE_NUM" name="PDF_ATT_FILE_NUM" value="${formData.PDF_ATT_FILE_NUM }" />
		
        <%--일반정보--%>
        <e:searchPanel id="sp" title="${form_CAPTION_N}" labelWidth="170px" useTitleBar="false" width="100%" columnCount="2" onEnter="">
            <e:row>
                <e:label for="AP_NUM" title="${form_AP_NUM_N}" />
                <e:field>
                    <e:inputText id="AP_NUM" name="AP_NUM" value="${formData.AP_NUM}" width="${form_AP_NUM_W}" maxLength="${form_AP_NUM_M}" disabled="${form_AP_NUM_D}" readOnly="${form_AP_NUM_RO}" required="${form_AP_NUM_R}" style="${imeMode}cursor:pointer;" maskType="${form_AP_NUM_MT}" onClick="onApNum"/>
                </e:field>
                <e:label for="DELIVERY_TYPE" title="${form_DELIVERY_TYPE_N}"/>
                <e:field>
                    <e:select id="DELIVERY_TYPE" name="DELIVERY_TYPE" value="${formData.DELIVERY_TYPE}" options="${deliveryTypeOptions}" width="${form_DELIVERY_TYPE_W}" disabled="${form_DELIVERY_TYPE_D}" readOnly="${form_DELIVERY_TYPE_RO}" required="${form_DELIVERY_TYPE_R}" placeHolder="" maskType="${form_DELIVERY_TYPE_MT}" />
                </e:field>
            </e:row>

            <e:row>
                <e:label for="VENDOR_CD" title="${form_VENDOR_CD_N}" />
                <e:field>
                    <e:inputText id="VENDOR_CD" name="VENDOR_CD" value="${formData.VENDOR_CD}" width="${form_VENDOR_CD_W}%" maxLength="${form_VENDOR_CD_M}" disabled="${form_VENDOR_CD_D}" readOnly="${form_VENDOR_CD_RO}" required="${form_VENDOR_CD_R}" style="${imeMode}" maskType="${form_VENDOR_CD_MT}"/>
                    <e:text>&nbsp;</e:text>
                    <e:inputText id="VENDOR_NM" name="VENDOR_NM" value="${formData.VENDOR_NM}" width="${form_VENDOR_NM_W}%" maxLength="${form_VENDOR_NM_M}" disabled="${form_VENDOR_NM_D}" readOnly="${form_VENDOR_NM_RO}" required="${form_VENDOR_NM_R}" style="${imeMode}" maskType="${form_VENDOR_NM_MT}"/>
                </e:field>
                <e:label for="VENDOR_USER_NM" title="${form_VENDOR_USER_NM_N}" />
                <e:field>
                    <e:inputText id="VENDOR_USER_NM" name="VENDOR_USER_NM" value="${formData.VENDOR_USER_NM}" width="${form_VENDOR_USER_NM_W}" maxLength="${form_VENDOR_USER_NM_M}" disabled="${form_VENDOR_USER_NM_D}" readOnly="${form_VENDOR_USER_NM_RO}" required="${form_VENDOR_USER_NM_R}" style="${imeMode}" maskType="${form_VENDOR_USER_NM_MT}"/>
                </e:field>
            </e:row>
			
			<!-- 21.02.03 중앙회 요청 "협력사 사업자등록번호, 사업자등록증 파일첨부" 표시 -->
			<e:row>
                <e:label for="IRS_NO" title="${form_IRS_NO_N}" />
                <e:field>
                    <e:inputText id="IRS_NO" name="IRS_NO" value="${formData.IRS_NO}" width="${form_IRS_NO_W}%" maxLength="${form_IRS_NO_M}" disabled="${form_IRS_NO_D}" readOnly="${form_IRS_NO_RO}" required="${form_IRS_NO_R}" style="${imeMode}" maskType="${form_IRS_NO_MT}"/>
                </e:field>
                <e:label for="ATTS_ATT_FILE_NUM_CNT" title="${form_ATTS_ATT_FILE_NUM_CNT_N}"/>
                <e:field>
                    <e:search id="ATTS_ATT_FILE_NUM_CNT" name="ATTS_ATT_FILE_NUM_CNT" value="${formData.ATTS_ATT_FILE_NUM_CNT}" width="${form_ATTS_ATT_FILE_NUM_CNT_W}" maxLength="${form_ATTS_ATT_FILE_NUM_CNT_M}" onIconClick="onIconClickATTS_ATT_FILE_NUM_CNT" disabled="${form_ATTS_ATT_FILE_NUM_CNT_D}" readOnly="${form_ATTS_ATT_FILE_NUM_CNT_RO}" required="${form_ATTS_ATT_FILE_NUM_CNT_R}" maskType="${form_ATTS_ATT_FILE_NUM_CNT_MT}" />
                </e:field>
            </e:row>
            
            <e:row>
                <e:label for="VENDOR_TEL_NUM" title="${form_VENDOR_TEL_NUM_N}" />
                <e:field>
                    <e:inputText id="VENDOR_TEL_NUM" name="VENDOR_TEL_NUM" value="${formData.VENDOR_TEL_NUM}" width="${form_VENDOR_TEL_NUM_W}%" maxLength="${form_VENDOR_TEL_NUM_M}" disabled="${form_VENDOR_TEL_NUM_D}" readOnly="${form_VENDOR_TEL_NUM_RO}" required="${form_VENDOR_TEL_NUM_R}" style="${imeMode}" maskType="${form_VENDOR_TEL_NUM_MT}"/>
                </e:field>
                <e:label for="VENDOR_CELL_NUM" title="${form_VENDOR_CELL_NUM_N}" />
                <e:field>
                    <e:inputText id="VENDOR_CELL_NUM" name="VENDOR_CELL_NUM" value="${formData.VENDOR_CELL_NUM}" width="${form_VENDOR_CELL_NUM_W}%" maxLength="${form_VENDOR_CELL_NUM_M}" disabled="${form_VENDOR_CELL_NUM_D}" readOnly="${form_VENDOR_CELL_NUM_RO}" required="${form_VENDOR_CELL_NUM_R}" style="${imeMode}" maskType="${form_VENDOR_CELL_NUM_MT}"/>
                </e:field>
            </e:row>

            <e:row>
                <e:label for="PAY_BANK_NM" title="${form_PAY_ACCOUNT_NUM_N}"/>
                <e:field>
                    <e:search id="PAY_BANK_NM" name="PAY_BANK_NM" value="${formData.PAY_BANK_NM}" width="${form_PAY_BANK_NM_W}%" maxLength="${form_PAY_BANK_NM_M}" onIconClick="" disabled="${form_PAY_BANK_NM_D}" readOnly="${form_PAY_BANK_NM_RO}" required="${form_PAY_BANK_NM_R}" maskType="${form_PAY_BANK_NM_MT}" />
                    <e:text>&nbsp;</e:text>
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
                    <e:inputText id="PO_CREATE_DATE" name="PO_CREATE_DATE" value="${formData.PO_CREATE_DATE}" width="${form_PO_CREATE_DATE_W}" maxLength="${form_PO_CREATE_DATE_M}" disabled="${form_PO_CREATE_DATE_D}" readOnly="${form_PO_CREATE_DATE_RO}" required="${form_PO_CREATE_DATE_R}" style="${imeMode}" maskType="${form_PO_CREATE_DATE_MT}"/>
                </e:field>
            </e:row>

            <e:row>
                <e:label for="AP_REQ_SUBJECT" title="${form_AP_REQ_SUBJECT_N}" />
                <e:field>
                    <e:inputText id="AP_REQ_SUBJECT" name="AP_REQ_SUBJECT" value="${formData.AP_REQ_SUBJECT}" width="${form_AP_REQ_SUBJECT_W}" maxLength="${form_AP_REQ_SUBJECT_M}" disabled="${form_AP_REQ_SUBJECT_D}" readOnly="${form_AP_REQ_SUBJECT_RO}" required="${form_AP_REQ_SUBJECT_R}" style="${imeMode}" maskType="${form_AP_REQ_SUBJECT_MT}"/>
                </e:field>
                <e:label for="AP_REQ_DATE" title="${form_AP_REQ_DATE_N}" />
                <e:field>
                    <e:inputText id="AP_REQ_DATE" name="AP_REQ_DATE" value="${formData.AP_REQ_DATE}" width="${form_AP_REQ_DATE_W}" maxLength="${form_AP_REQ_DATE_M}" disabled="${form_AP_REQ_DATE_D}" readOnly="${form_AP_REQ_DATE_RO}" required="${form_AP_REQ_DATE_R}" style="${imeMode}" maskType="${form_AP_REQ_DATE_MT}"/>
                </e:field>
            </e:row>

            <e:row>
                <e:label for="INV_NUM" title="${form_INV_NUM_N}" />
                <e:field>
                    <e:inputText id="INV_NUM" name="INV_NUM" value="${formData.INV_NUM}" width="${form_INV_NUM_W}" maxLength="${form_INV_NUM_M}" disabled="${form_INV_NUM_D}" readOnly="${form_INV_NUM_RO}" required="${form_INV_NUM_R}" style="${imeMode}" maskType="${form_INV_NUM_MT}"/>
                </e:field>
                <e:label for="PAY_CNT_NM" title="${form_PAY_CNT_NM_N}" />
                <e:field>
                    <e:inputText id="PAY_CNT_NM" name="PAY_CNT_NM" value="${formData.PAY_CNT_NM}" width="${form_PAY_CNT_NM_W}" maxLength="${form_PAY_CNT_NM_M}" disabled="${form_PAY_CNT_NM_D}" readOnly="${form_PAY_CNT_NM_RO}" required="${form_PAY_CNT_NM_R}" style="${imeMode}" maskType="${form_PAY_CNT_NM_MT}"/>
                </e:field>
            </e:row>

            <e:row>
                <e:label for="PAY_AMT" title="${form_PAY_AMT_N}"/>
                <e:field>
                    <e:inputNumber id="PAY_AMT" name="PAY_AMT" value="${formData.PAY_AMT}" width="${form_PAY_AMT_W}" maxValue="${form_PAY_AMT_M}" decimalPlace="${form_PAY_AMT_NF}" disabled="${form_PAY_AMT_D}" readOnly="${form_PAY_AMT_RO}" required="${form_PAY_AMT_R}" onNumberKr="${form_PAY_AMT_KR}" currencyText="${form_PAY_AMT_CT}"/>
                </e:field>
                <e:label for="VAT_TYPE" title="${form_VAT_TYPE_N}"/>
                <e:field>
                    <e:select id="VAT_TYPE" name="VAT_TYPE" value="${formData.VAT_TYPE}" options="${vatTypeOptions}" width="${form_VAT_TYPE_W}" disabled="${form_VAT_TYPE_D}" readOnly="${form_VAT_TYPE_RO}" required="${form_VAT_TYPE_R}" placeHolder="" maskType="${form_VAT_TYPE_MT}" />
                </e:field>
            </e:row>

            <e:row>
                <e:label for="INV_DATE" title="${form_INV_DATE_N}" />
                <e:field>
                    <e:inputText id="INV_DATE" name="INV_DATE" value="${formData.INV_DATE}" width="${form_INV_DATE_W}" maxLength="${form_INV_DATE_M}" disabled="${form_INV_DATE_D}" readOnly="${form_INV_DATE_RO}" required="${form_INV_DATE_R}" style="${imeMode}" maskType="${form_INV_DATE_MT}"/>
                </e:field>
                <e:label for="PIC_USER_NM" title="${form_PIC_USER_NM_N}" />
                <e:field>
                    <e:inputText id="PIC_USER_NM" name="PIC_USER_NM" value="${formData.PIC_USER_NM}" width="${form_PIC_USER_NM_W}" maxLength="${form_PIC_USER_NM_M}" disabled="${form_PIC_USER_NM_D}" readOnly="${form_PIC_USER_NM_RO}" required="${form_PIC_USER_NM_R}" style="${imeMode}" maskType="${form_PIC_USER_NM_MT}"/>
                </e:field>
            </e:row>

            <e:row>
                <e:label for="PAY_TERMS" title="${form_PAY_TERMS_N}"/>
                <e:field>
                    <e:select id="PAY_TERMS" name="PAY_TERMS" value="${formData.PAY_TERMS}" options="${payTermsOptions}" width="${form_PAY_TERMS_W}" disabled="${form_PAY_TERMS_D}" readOnly="${form_PAY_TERMS_RO}" required="${form_PAY_TERMS_R}" placeHolder="" maskType="${form_PAY_TERMS_MT}" />
                </e:field>
                <e:label for="PAY_TYPE" title="${form_PAY_TYPE_N}"/>
                <e:field>
                    <e:select id="PAY_TYPE" name="PAY_TYPE" value="${formData.PAY_TYPE}" options="${payTypeOptions}" width="${form_PAY_TYPE_W}" disabled="${form_PAY_TYPE_D}" readOnly="${form_PAY_TYPE_RO}" required="${form_PAY_TYPE_R}" placeHolder="" maskType="${form_PAY_TYPE_MT}" />
                </e:field>
            </e:row>

           	<%--2021.11.11 : 중앙회 박기현 책임 요청사항
            <e:row>
                <e:label for="BILL_DATE" title="${form_BILL_DATE_N}"/>
                <e:field>
                    <e:inputDate id="BILL_DATE" name="BILL_DATE" value="${formData.BILL_DATE}" width="${inputDateWidth}" datePicker="true" required="${form_BILL_DATE_R}" disabled="${form_BILL_DATE_D}" readOnly="${form_BILL_DATE_RO}" />
                </e:field>
                <e:label for="BILL_ATT_FILE_CNT" title="${form_BILL_ATT_FILE_CNT_N}"/>
                <e:field colSpan="3">
                    <e:search id="BILL_ATT_FILE_CNT" name="BILL_ATT_FILE_CNT" value="${formData.BILL_ATT_FILE_CNT}" width="${form_BILL_ATT_FILE_CNT_W}" maxLength="${form_BILL_ATT_FILE_CNT_M}" onIconClick="onIconClickBILL_ATT_FILE_CNT" disabled="${form_BILL_ATT_FILE_CNT_D}" readOnly="${form_BILL_ATT_FILE_CNT_RO}" required="${form_BILL_ATT_FILE_CNT_R}" maskType="${form_BILL_ATT_FILE_CNT_MT}" />
                </e:field>
            </e:row>
            --%>

            <e:row>
                <e:label for="AP_USER_ID" title="${form_AP_USER_ID_N}"/>
                <e:field>
                    <e:search id="AP_USER_ID" name="AP_USER_ID" value="${formData.AP_USER_ID}" width="${form_AP_USER_ID_W}%" maxLength="${form_AP_USER_ID_M}" onIconClick="onIconClickAP_USER_ID" disabled="${form_AP_USER_ID_D}" readOnly="${form_AP_USER_ID_RO}" required="${form_AP_USER_ID_R}" maskType="${form_AP_USER_ID_MT}" />
                    <e:inputText id="AP_USER_NM" name="AP_USER_NM" value="${formData.AP_USER_NM}" width="${form_AP_USER_NM_W}%" maxLength="${form_AP_USER_NM_M}" disabled="${form_AP_USER_NM_D}" readOnly="${form_AP_USER_NM_RO}" required="${form_AP_USER_NM_R}" style="${imeMode}" maskType="${form_AP_USER_NM_MT}"/>
                </e:field>
                <e:label for="PY_AP_REQ_DATE" title="${form_PY_AP_REQ_DATE_N}"/>
                <e:field>
                    <e:inputDate id="PY_AP_REQ_DATE" name="PY_AP_REQ_DATE" value="${formData.PY_AP_REQ_DATE}" width="${inputDateWidth}" datePicker="true" required="${form_PY_AP_REQ_DATE_R}" disabled="${form_PY_AP_REQ_DATE_D}" readOnly="${form_PY_AP_REQ_DATE_RO}" />
                </e:field>
            </e:row>

            <e:row>
                <e:label for="ACC_GWAN_CD" title="${form_ACC_GWAN_CD_N}" />
                <e:field colSpan="3">
                    <e:inputText id="ACC_GWAN_CD" name="ACC_GWAN_CD" value="${formData.ACC_GWAN_CD}" width="${form_ACC_GWAN_CD_W}" maxLength="${form_ACC_GWAN_CD_M}" disabled="${form_ACC_GWAN_CD_D}" readOnly="${form_ACC_GWAN_CD_RO}" required="${form_ACC_GWAN_CD_R}" style="${imeMode}" maskType="${form_ACC_GWAN_CD_MT}"/>
                    <e:text> </e:text>
                    <e:inputText id="ACC_HNG_CD" name="ACC_HNG_CD" value="${formData.ACC_HNG_CD}" width="${form_ACC_HNG_CD_W}" maxLength="${form_ACC_HNG_CD_M}" disabled="${form_ACC_HNG_CD_D}" readOnly="${form_ACC_HNG_CD_RO}" required="${form_ACC_HNG_CD_R}" style="${imeMode}" maskType="${form_ACC_HNG_CD_MT}"/>
                    <e:text> </e:text>
                    <e:inputText id="ACC_MOK_CD" name="ACC_MOK_CD" value="${formData.ACC_MOK_CD}" width="${form_ACC_MOK_CD_W}" maxLength="${form_ACC_MOK_CD_M}" disabled="${form_ACC_MOK_CD_D}" readOnly="${form_ACC_MOK_CD_RO}" required="${form_ACC_MOK_CD_R}" style="${imeMode}" maskType="${form_ACC_MOK_CD_MT}"/>
                    <e:text> </e:text>
                    <e:inputText id="ACC_DET_CD" name="ACC_DET_CD" value="${formData.ACC_DET_CD}" width="${form_ACC_DET_CD_W}" maxLength="${form_ACC_DET_CD_M}" disabled="${form_ACC_DET_CD_D}" readOnly="${form_ACC_DET_CD_RO}" required="${form_ACC_DET_CD_R}" style="${imeMode}" maskType="${form_ACC_DET_CD_MT}"/>
                </e:field>
            </e:row>

            <e:row>
                <e:label for="ACC_NUM_YEAR" title="${form_ACC_NUM_YEAR_N}" />
                <e:field>
                    <e:inputText id="ACC_NUM_YEAR" name="ACC_NUM_YEAR" value="${formData.ACC_NUM_YEAR}" width="${form_ACC_NUM_YEAR_W}" maxLength="${form_ACC_NUM_YEAR_M}" disabled="${form_ACC_NUM_YEAR_D}" readOnly="${form_ACC_NUM_YEAR_RO}" required="${form_ACC_NUM_YEAR_R}" style="${imeMode}" maskType="${form_ACC_NUM_YEAR_MT}"/>
                    <e:text> - </e:text>
                    <e:inputText id="ACC_NUM_TEXT" name="ACC_NUM_TEXT" value="${formData.ACC_NUM_TEXT}" width="${form_ACC_NUM_TEXT_W}" maxLength="${form_ACC_NUM_TEXT_M}" disabled="${form_ACC_NUM_TEXT_D}" readOnly="${form_ACC_NUM_TEXT_RO}" required="${form_ACC_NUM_TEXT_R}" style="${imeMode}" maskType="${form_ACC_NUM_TEXT_MT}"/>
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
                <e:label for="C_ATT_FILE_NUM" title="${form_C_ATT_FILE_NUM_N}" />
                <e:field>
                    <e:fileManager id="C_ATT_FILE_NUM" name="C_ATT_FILE_NUM" width="${form_C_ATT_FILE_NUM_W}" height="100px" fileId="${formData.C_ATT_FILE_NUM}" bizType="OM" readOnly="${form_C_ATT_FILE_NUM_RO}" required="${form_C_ATT_FILE_NUM_R}"/>
                </e:field>
                <e:label for="ATT_FILE_NUM" title="${form_ATT_FILE_NUM_N}" />
                <e:field>
                    <e:fileManager id="ATT_FILE_NUM" name="ATT_FILE_NUM" width="${form_ATT_FILE_NUM_W}" height="100px" fileId="${formData.ATT_FILE_NUM}" bizType="OM" readOnly="${form_ATT_FILE_NUM_RO}" required="${form_ATT_FILE_NUM_R}"/>
                </e:field>
            </e:row>
        </e:searchPanel>
		
        <%--품목정보--%>
        <e:buttonBar width="100%" align="right" title="${CAPR0011_002}">
            <e:button id="doDeleteItem" name="doDeleteItem" label="${doDeleteItem_N}" onClick="doDeleteItem" disabled="${doDeleteItem_D}" visible="${doDeleteItem_V}"/>
        </e:buttonBar>
        <e:gridPanel id="gridPODT" name="gridPODT" width="100%" height="210px" gridType="${_gridType}" readOnly="${param.detailView}" />

        <%--검수요청상세--%>
        <e:buttonBar width="100%" align="right" title="${CAPR0011_003}">
        </e:buttonBar>
        <e:gridPanel id="gridIVAP" name="gridIVAP" width="100%" height="210px" gridType="${_gridType}" readOnly="${param.detailView}" />

        <%-- 결재자 리스트 Include --%>
        <jsp:include page="/WEB-INF/views/nhepro/CWOR/CWOR0013.jsp" flush="true" >
            <jsp:param value="${formData.APP_DOC_NUM}" name="APP_DOC_NUM"/>
            <jsp:param value="${formData.APP_DOC_CNT}" name="APP_DOC_CNT"/>
            <jsp:param value="${formData.BUYER_CD}" name="BUYER_CD"/>
        </jsp:include>
    </e:window>
</e:ui>