<%--
  Date: 2020-04-17
  Time: 13:15:36
  Scrren ID : CCTR0020
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ page import="com.st_ones.everf.serverside.config.PropertiesManager" %>
<%@ include file="/WEB-INF/views/common/ozUrlInfo.jsp" %>

<!-- 2021.02.08 중앙회 요청 "관리자직무"를 갖는 사람은 담당자 변경 가능하도록 ManagerCd 추가 -->
<!-- 2021.12.14 중앙회 요청 "계약담당자권한"을 갖는 사람은 다른계약담당자의 계약건을 변경계약서 작성가능하도록 ContAuthCd 추가  -->
<%
	String ozSchedulerIp = PropertiesManager.getString("oz.scheduler.ip");
	String ozSchedulerPort = PropertiesManager.getString("oz.scheduler.port");
	String ManagerCd = PropertiesManager.getString("eversrm.customer.admin.ManagerCd");
	String ContAuthCd = PropertiesManager.getString("eversrm.customer.admin.ContAuthCd");
	// 2021.03.03 : ERP전송가능 고객추가
	String erpCustCd = PropertiesManager.getString("eversrm.default.inCustCd");
	// 2021.07.16 : itPortal 계약서 전송고객 추가
	String itPortalCustCd = PropertiesManager.getString("eversrm.default.itPortal.custCd");
%>

<c:set value="<%=ozExportUrl%>" var="ozExportUrl"/>
<c:set var="ozUrl" value="<%=ozUrl%>" />
<c:set var="ozServer" value="<%=ozServer%>" />
<c:set var="ozSchedulerIp" value="<%=ozSchedulerIp%>" />
<c:set var="ozSchedulerPort" value="<%=ozSchedulerPort%>" />

<c:set var="ManagerCd" value="<%=ManagerCd%>" />
<c:set var="ContAuthCd" value="<%=ContAuthCd%>" />
<c:set var="erpCustCd" value="<%=erpCustCd%>" />
<c:set var="itPortalCustCd" value="<%=itPortalCustCd%>" />

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
	<script type="text/javascript" src="/MagicLine4Web/ML4Web/js/ext/jquery.blockUI.js"></script>
	<!-- ML4WEB JS -->
	<script type="text/javascript" src="/MagicLine4Web/ML4Web/js/ext/ML_Config.js"></script>
	<script>

		var grid;
		var gridI;
		var baseUrl = "/nhepro/CCTR/CCTR0050";
		var type    = "${param.TYPE}".substr(0, 1);
		var changeFlag = false;
		var changeCont = false;
		var localServerFlag = "${localServerFlag}";		
		
		function init() {
			// 2021.02.08 중앙회 요청 "관리자직무"를 갖는 사람은 담당자 변경 가능하도록 추가
		    if ("${ses.ctrlCd}".indexOf("${ManagerCd}") > -1) {
		    	changeFlag = true;
            }
		    
		    // 2021.12.10 중앙회 요청 "계약담당자권한"을 갖는 사람은 계약담당자가 본인 외의 건도 변경계약서 작성 가능하도록 추가
		    if ("${ses.ctrlCd}".indexOf("${ContAuthCd}") > -1) {
		    	changeCont = true;
            }
			
			grid = EVF.C("grid");
			
			// 2021.08.30 추가
			// 위수탁 계약서인 경우 조회조건 및 Grid의 Title 변경
			if( type == "C" || type == "D" ) {
				grid._gvo.setColumnProperty(grid._gvo.columnByField("PR_BUYER_DEPT_NM"), "header", {text:"${CCTR0050_TXT01}"});
				grid._gvo.setColumnProperty(grid._gvo.columnByField("VENDOR_CD"), "header", {text:"${CCTR0050_TXT10}"});
				grid._gvo.setColumnProperty(grid._gvo.columnByField("VENDOR_NM"), "header", {text:"${CCTR0050_TXT11}"});
				
				EVF.C("IF_TYPE").setDisabled(true);	// Interface유형 Disable
				$("#sp_form tr:eq(1)").hide();
			} else {
				$("#sp_form tr:eq(2)").hide();
			
			}
			
			grid.setProperty("shrinkToFit", ${shrinkToFit});		// 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
			grid.setProperty("rowNumbers", ${rowNumbers});		    // 로우의 번호 표시 여부를 지정한다. [true/false]
			grid.setProperty("sortable", ${sortable});			    // 컬럼 정렬기능 사용여부를 지정한다. [true/false]
			grid.setProperty("panelVisible", ${panelVisible});	    // 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
			grid.setProperty("enterToNextRow", ${enterToNextRow}); // 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
			grid.setProperty("acceptZero", ${acceptZero});		    // 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
			grid.setProperty("multiSelect", ${multiSelect});		// [선택] 컬럼의 사용여부를 지정한다. [true/false]
			grid.setProperty("singleSelect", ${singleSelect});	    // [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]
			
			// Grid Excel Event
			grid.excelExportEvent({
				allItems: "${excelExport.allCol}",
				fileName: "${sreenName }"
			});

			grid.cellClickEvent(function (rowIdx, celName, value) {
				var param;
				var url;
				var contUserId = grid.getCellValue(rowIdx, 'CONT_USER_ID');
				var isAuthUser = false;

				if(contUserId == "${ses.userId}" || "${ses.superUserFlag}" == "1") {
					isAuthUser = true;
				}

				var buyerCd   = grid.getCellValue(rowIdx, "BUYER_CD");
				var contNum   = grid.getCellValue(rowIdx, "CONT_NUM");
				var contCnt   = grid.getCellValue(rowIdx, "CONT_CNT");
				var vendorCd  = grid.getCellValue(rowIdx, "VENDOR_CD");
				var prBuyerCd = grid.getCellValue(rowIdx, "PR_BUYER_CD");
				var prDeptCd  = grid.getCellValue(rowIdx, "PR_DEPT_CD");
				var contType  = grid.getCellValue(rowIdx, "CONT_TYPE");

				param = {
					BUYER_CD: buyerCd,
					CONT_NUM: contNum,
					CONT_CNT: contCnt,
					VENDOR_CD: vendorCd,
					PR_BUYER_CD: prBuyerCd,
					PR_DEPT_CD: prDeptCd,
					detailView: true
				};

				switch (celName) {
					case "CONT_NUM":
						var progressCd = grid.getCellValue(rowIdx, "PROGRESS_CD");
						var bundleFlag = grid.getCellValue(rowIdx, "BUNDLE_NUM") == "" ? "0" : "1";
						var signStatus = grid.getCellValue(rowIdx, "SIGN_STATUS");
						var PDF_ATT_FILE_NUM = grid.getCellValue(rowIdx, "PDF_ATT_FILE_NUM");
						
						param = {
								callBackFunction: 'doSearch',
								BUYER_CD: buyerCd,
								CONT_NUM: value,
								CONT_CNT: contCnt,
								CONT_TYPE: contType,
								bundleFlag: bundleFlag,
								PDF_ATT_FILE_NUM : PDF_ATT_FILE_NUM
							};
						
						// 임시저장
						if (Number(progressCd) == 4200 && (signStatus == "T" || signStatus == "C" || signStatus == "R")) {
							param["detailView"] = false;
						}// 협력사 반려, 협력사 서명완료
						else if (Number(progressCd) == 4220 || Number(progressCd) == 4230) {
							param["detailView"] = (isAuthUser ? false : true);
							if (Number(progressCd) == 4230) {
								param["detailView"]  = false;
								param["PR_BUYER_CD"] = prBuyerCd;
								param["PR_DEPT_CD"]  = prDeptCd;
							}
						}// 협력사 서명대기(4210), 전자서명완료(4300)
						else if (Number(progressCd) > 4200) {
							param["detailView"] = true;
						}
						else {
							param["detailView"] = (isAuthUser ? false : true);
						}
						
						// 단일업체 계약
						if(bundleFlag == "0") {
							param["url"] = '/nhepro/CCTR/CCTA0030/view.so';
							everPopup.openContractChangeInformation(param);
						}// 다수업체 계약
						else {
							param["BUNDLE_NUM"]  = grid.getCellValue(rowIdx, "BUNDLE_NUM");
							param["VENDOR_CD"]   = vendorCd;
							param["PR_BUYER_CD"] = prBuyerCd;
							param["PR_DEPT_CD"]  = prDeptCd;
							
							// 위수탁계약서 : 협력사 서명대기 또는 협력사 서명완료인 경우
							if( grid.getCellValue(rowIdx, "CONT_TYPE") == "1120" && (grid.getCellValue(rowIdx, "PROGRESS_CD") == "4210" || grid.getCellValue(rowIdx, "PROGRESS_CD") == "4230") ) {
								// 로그인한 협력사가 전자서명을 진행해야 하는 경우
								if( (grid.getCellValue(rowIdx, "PROGRESS_CD") == "4210" && vendorCd  == "${ses.companyCd}")
								  ||(grid.getCellValue(rowIdx, "PROGRESS_CD") == "4230" && prBuyerCd == "${ses.companyCd}") ) {
									param["detailView"] = false;
								}
								else {
									param["detailView"] = true;
								}
							}
							
							// 일괄계약의 단일계약번호 클릭시 단일계약여부=0
							param["singleFlag"] = "1";
							url = '/nhepro/CCTR/CCTA0040/view.so';
							everPopup.openWindowPopup(url, 1200, 900, param, 'openBundleContract');
						}
						break;

					case "BUNDLE_NUM":
						if( value == "" || (prBuyerCd != "${ses.companyCd}") ) return;
						param = {
								callBackFunction : 'doSearch',
								BUYER_CD: buyerCd,
								BUNDLE_NUM : value,
								CONT_NUM: contNum,
								CONT_CNT: contCnt,
								CONT_TYPE: contType,
								bundleFlag: "1",
								singleFlag: "0"
							};
						
						if( (grid.getCellValue(rowIdx, "PROGRESS_CD") == "4200" && grid.getCellValue(rowIdx, "SIGN_STATUS") == "T")
						  ||(grid.getCellValue(rowIdx, "SIGN_STATUS") == "C" || grid.getCellValue(rowIdx, "SIGN_STATUS") == "R") )
						{
							param["detailView"] = (isAuthUser ? false : true);
						} else {
							param["detailView"] = true;
						}
						
						url = '/nhepro/CCTR/CCTA0040/view.so';
						everPopup.openWindowPopup(url, 1200, 900, param, 'openBundleContract');
						break;
						
					case "VENDOR_NM":
						// 1120 : 위수탁계약서
						if( value == "" || contType == '1120' ) return;
						param = {
		                        VENDOR_CD: grid.getCellValue(rowIdx, 'VENDOR_CD'),
		                        detailView: true,
		                        popupFlag: true,
		                        buttonView: false
		                    };
		                everPopup.openPopupByScreenId("CVNR0011", 1000, 730, param);
		                break;
		                
					case "ATT_FILE_CNT":
						if( value == 0 ) return;
						param = {
							bizType: 'EC',
							attFileNum: grid.getCellValue(rowIdx, 'ATT_FILE_NUM'),
							detailView: true
						};
						everPopup.fileAttachPopup(param);
						break;

					case "VENDOR_ATT_FILE_CNT":
						if( value == 0 ) return;
						param = {
							bizType: 'EC',
							attFileNum: grid.getCellValue(rowIdx, 'VENDOR_ATT_FILE_NUM'),
							detailView: true
						};
						everPopup.fileAttachPopup(param);
						break;

					case "STAMP_ATT_FILE_CNT":
						if( value == 0 ) return;
						param = {
							bizType: 'EC',
							attFileNum: grid.getCellValue(rowIdx, 'STAMP_ATT_FILE_NUM'),
							callBackFunction: 'setStampAttFileNum',
							detailView: type == "A" ? true : false
						};
						everPopup.fileAttachPopup(param);
						break;

					case "GUAR_CNT":
						if( value == 0 ) return;
						param["detailView"] = true;
						everPopup.openPopupByScreenId("CCTR0051", 1100, 450, param);
						break;
						
					case "ADV_GUAR_CNT":
						if( value == 0 ) return;
						param["detailView"] = true;
						everPopup.openPopupByScreenId("CCTR0052", 1180, 450, param);
						break;
						
					case "WARR_GUAR_CNT":
						if( value == 0 ) return;
						param["detailView"] = true;
						everPopup.openPopupByScreenId("CCTR0053", 1180, 450, param);
						break;
						
					case "DI_GUAR_CNT":
						if( value == 0 ) return;
						everPopup.openPopupByScreenId("CCTR0054", 600, 330, param);
						break;

					case "CONT_CLOSE_RMK":
						if( value == "" ) return;
						param = {
							title : '계약체결 중단사유',
							message: value,
							detailView : true
						};
						everPopup.commonTextInput(param);
						break;
					
					case "CONT_DESC":
						// 2021.08.17 추가
						// 계약체결진행현황, 계약체결현황에서만 하단의 품목현황 조회함
						if( type == "A" || type == "B" ) {
							EVF.V("SCH_BUYER_CD", grid.getCellValue(rowIdx, 'BUYER_CD'));
			        		EVF.V("SCH_CONT_NUM", grid.getCellValue(rowIdx, 'CONT_NUM'));
			        		EVF.V("SCH_CONT_CNT", grid.getCellValue(rowIdx, 'CONT_CNT'));
			        		
			        		doSearchDT();
						}
						break;
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
		    grid.setRowFooter("CONT_AMT", distVal);
		    
		 	// ===========================================================
		 	
			// 2021.08.18 추가
			if( type == "A" || type == "B" ) {
			    grid.hideCol("BUNDLE_NUM", true);
			    
				gridI = EVF.C("gridI");
				gridI.setProperty('shrinkToFit', ${shrinkToFit});
	            gridI.setProperty('rowNumbers', ${rowNumbers});
	            gridI.setProperty('sortable', ${sortable});
	            gridI.setProperty('panelVisible', ${panelVisible});
	            gridI.setProperty('enterToNextRow', ${enterToNextRow});
	            gridI.setProperty('acceptZero', ${acceptZero});
	            gridI.setProperty('singleSelect', ${singleSelect});
	            
				gridI.cellClickEvent(function(rowIdx, colIdx, value) {
					
					if(colIdx == "PR_NUM") {
						if( value == "" ) return;
						var param = {
							prNum: value,
							buyerCd : gridI.getCellValue(rowIdx, "PB_BUYER_CD"),
							popupFlag: true,
							detailView : true
						};
						everPopup.openPopupByScreenId("CPRI0010", 1200, 900, param);
					}
					if(colIdx === 'PR_APP_DOC_NUM'){
						if( value == "" ) return;
			            var params = {
			                buyerCd    : gridI.getCellValue(rowIdx, "PB_BUYER_CD"),
			                appDocNum  : gridI.getCellValue(rowIdx, "PR_APP_DOC_NUM"),
			                appDocCnt  : gridI.getCellValue(rowIdx, "PR_APP_DOC_CNT"),
			                sendBox	   : false,
	                        detailView : true
			            };
			            everPopup.openApprovalOrRejectPopup(params);
			       	}
					if(colIdx == "RFX_NUM") {
						if( value == "" ) return;
						var rfxType = gridI.getCellValue(rowIdx, "RFX_TYPE");
						if(rfxType == "BID") {
							var param = {
								'buyerCd': gridI.getCellValue(rowIdx, 'BUYER_CD'),
								'bidNum': gridI.getCellValue(rowIdx, 'RFX_NUM'),
								'bidCnt': gridI.getCellValue(rowIdx, 'RFX_CNT'),
								'popupFlag': true,
								'detailView': true
							};
							var callUrl = "/nhepro/CBDI/CBDR0012/view.so";
							everPopup.openWindowPopup(callUrl, 1200, 800, param, "bidDetail", true);
						}
						else {
							var param = {
			                        callbackFunction: "",
			                        BUYER_CD: gridI.getCellValue(rowIdx, "BUYER_CD"),
			                        RFX_NUM: gridI.getCellValue(rowIdx, "RFX_NUM"),
			                        RFX_CNT: gridI.getCellValue(rowIdx, "RFX_CNT"),
			                        detailView: true,
			                        buttonView: false
			                    };
		                    everPopup.openPopupByScreenId("CRQI0011", 1200, 900, param);
		        		}
					}
					if(colIdx === 'RFX_APP_DOC_NUM'){
						if( value == "" ) return;
			            var params = {
			                buyerCd    : gridI.getCellValue(rowIdx, "BUYER_CD"),
			                appDocNum  : gridI.getCellValue(rowIdx, "RFX_APP_DOC_NUM"),
			                appDocCnt  : gridI.getCellValue(rowIdx, "RFX_APP_DOC_CNT"),
			                sendBox	   : false,
	                        detailView : true
			            };
			            everPopup.openApprovalOrRejectPopup(params);
			       	}
					if(colIdx === 'ESTM_APP_DOC_NUM'){
						if( value == "" ) return;
			            var params = {
			                buyerCd    : gridI.getCellValue(rowIdx, "BUYER_CD"),
			                appDocNum  : gridI.getCellValue(rowIdx, "ESTM_APP_DOC_NUM"),
			                appDocCnt  : gridI.getCellValue(rowIdx, "ESTM_APP_DOC_CNT"),
			                sendBox	   : false,
	                        detailView : true
			            };
			            everPopup.openApprovalOrRejectPopup(params);
			       	}
					if(colIdx == "EXEC_NUM") {
						if( value == "" ) return;
						var param = {
								'execNum': value,
								'buyerCd': gridI.getCellValue(rowIdx, 'BUYER_CD'),
								'tcoFlag': null,
								'popupFlag': true,
								'detailView': true
							};
						everPopup.openWindowPopup("/nhepro/CBDR/CBDI0061/view.so", 1400, 800, param, "createCN", true);
					}
					if(colIdx === 'EXEC_APP_DOC_NUM'){
						if( value == "" ) return;
			            var params = {
			                buyerCd    : gridI.getCellValue(rowIdx, "BUYER_CD"),
			                appDocNum  : gridI.getCellValue(rowIdx, "EXEC_APP_DOC_NUM"),
			                appDocCnt  : gridI.getCellValue(rowIdx, "EXEC_APP_DOC_CNT"),
			                sendBox	   : false,
	                        detailView : true
			            };
			            everPopup.openApprovalOrRejectPopup(params);
			       	}
					if (colIdx == "PRE_CONT_NUM") {
						if( value == "" ) return;
						param = {
								callBackFunction: '',
								BUYER_CD: gridI.getCellValue(rowIdx, "PRE_BUYER_CD"),
								CONT_NUM: value,
								CONT_CNT: gridI.getCellValue(rowIdx, "PRE_CONT_CNT"),
								url: "/nhepro/CCTR/CCTA0030/view.so",
								detailView: true,
								popupFlag: true
							};
						everPopup.openContractChangeInformation(param);
					}
				});
			    
			    if (type == "A") {
		            gridI.setProperty('multiSelect', false);
					gridI.setColGroup([
		            	{
		                    "groupName": '용역(도급)',
		                    "columns": ['SW_BIZ_AMT', 'SW_BIZ_DISCOUNT', 'MNT_SANGJU_YN']
		                }
		                ,{
		                    "groupName": '물품(공사,기타,양수)',
		                    "columns": ['CONSUMER_AMT', 'CONSUMER_DISCOUNT', 'FC_MNT_TERM', 'CH_RATE']
		                }
		                ,{
		                    "groupName": '유지보수(리스,재리스,렌탈)',
		                    "columns": ['DOIB_AMOUNT', 'MNT_RATE', 'MNT_SDAY', 'MNT_EDAY', 'MNT_GUR_MONTH', 'RT_INSP_PERIOD', 'FALT_RC_TG_TIME']
		                }
		                ,{
		                    "groupName": '인터페이스정보(IT포탈)',
		                    "columns": ['PRE_CONT_NUM', 'PRE_CONT_CNT', 'CM_REQ_ID', 'IF_TYPE']
		                }
		            ],50);
					
					grid.hideCol("MANUAL_CONT_FLAG", true);	
					grid.hideCol("PR_AMT", true);
					grid.hideCol("REQ_DATE", true);
			    	grid.hideCol("IF_YN", true);
			    	gridI.hideCol("CM_REQ_DET_ID", true);
			    	gridI.hideCol("MULPUM_ID", true);
			    	gridI.hideCol("N_CM_REQ_ID", true);
			    	gridI.hideCol("N_CM_REQ_DET_ID", true);
			    	gridI.hideCol("N_MULPUM_ID", true);
			 	}
				else if (type == "B") {
					gridI.setColGroup([
		            	{
		                    "groupName": '용역(도급)',
		                    "columns": ['SW_BIZ_AMT', 'SW_BIZ_DISCOUNT', 'MNT_SANGJU_YN']
		                }
		                ,{
		                    "groupName": '물품(공사,기타,양수)',
		                    "columns": ['CONSUMER_AMT', 'CONSUMER_DISCOUNT', 'FC_MNT_TERM', 'CH_RATE']
		                }
		                ,{
		                    "groupName": '유지보수(리스,재리스,렌탈)',
		                    "columns": ['DOIB_AMOUNT', 'MNT_RATE', 'MNT_SDAY', 'MNT_EDAY', 'MNT_GUR_MONTH', 'RT_INSP_PERIOD', 'FALT_RC_TG_TIME']
		                }
		                ,{
		                    "groupName": '인터페이스정보(IT포탈)',
		                    "columns": ['PRE_CONT_NUM', 'PRE_CONT_CNT', 'CM_REQ_ID', 'CM_REQ_DET_ID', 'MULPUM_ID']
		                }
		                ,{
		                    "groupName": 'IT포탈 계약의뢰 변경정보',
		                    "columns": ['N_CM_REQ_ID', 'N_CM_REQ_DET_ID', 'N_MULPUM_ID']
		                }
		            ],50);
					
					<%--
					2021.08.26 : 사용자 법인구분이 은행(1) OR 중앙회(5)일 경우만 "IT포탈전송" 버튼 활성화. 
			 		if ("${ses.companyCd}".indexOf("${itPortalCustCd}") > -1) {
			 		--%>
					if ("${ses.corpType}" == "1" || "${ses.corpType}" == "5") {
		            	// 계약체결현황 화면에서 "관리자직무(BR900)" 만 "IT포탈전송" 버튼 보이도록 함
		            	if(changeFlag) {
		            		EVF.C('doSendITPortal').setVisible(true);	// IT포탈전송 버튼
		            		EVF.C('doSave').setVisible(true);			// IT포탈 의뢰번호 저장 버튼
							gridI.setProperty('multiSelect', true);
		                }
		            	else {
		                	EVF.C('doSendITPortal').setVisible(false);	// IT포탈전송 버튼
		                	EVF.C('doSave').setVisible(false);			// IT포탈 의뢰번호 저장 버튼
							gridI.setProperty('multiSelect', false);
				 			
				 			grid.hideCol("IF_YN", true);
				 			gridI.setColReadOnly("N_CM_REQ_ID", true);
				 			gridI.setColReadOnly("N_CM_REQ_DET_ID", true);
				 			gridI.setColReadOnly("N_MULPUM_ID", true);
		                }
			 		}
			 		else {
			 			EVF.C('doSendITPortal').setVisible(false);		// IT포탈전송 버튼
			 			EVF.C('doSave').setVisible(false);				// IT포탈 의뢰번호 저장 버튼
						gridI.setProperty('multiSelect', false);
			 			
			 			grid.hideCol("IF_YN", true);
			 			gridI.setColReadOnly("N_CM_REQ_ID", true);
			 			gridI.setColReadOnly("N_CM_REQ_DET_ID", true);
			 			gridI.setColReadOnly("N_MULPUM_ID", true);
			 		}
				}
				
			 	// ======================그리드 합계 구하기=======================
			    var val = {"visible": true, "count": 1, "height": 15};
			    gridI.setProperty('footerVisible', val);
	
			    var footer = {
			          "styles": {
			              "textAlignment": "center",
			              "fontBold": true,
			              "fontFmaily": "Nanum Gothic",
			          },
			          "text": "합   계"
			    };
			    gridI.setRowFooter("PR_BUYER_DEPT_NM", footer);
	
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
			    gridI.setRowFooter("ITEM_QT"  , distVal);
			    gridI.setRowFooter("ITEM_AMT" , distVal);
			    gridI.setRowFooter("SW_BIZ_AMT", distVal);
			    gridI.setRowFooter("CONSUMER_AMT", distVal);
			    gridI.setRowFooter("DOIB_AMOUNT" , distVal);

			} else {
				grid.setColFontColor("VENDOR_NM", "#555555");
				grid.setColFontColor("CONT_DESC", "#555555");
				
				grid.hideCol("RE_BUYER_DEPT_NM", true);
				grid.hideCol("MANUAL_CONT_FLAG", true);	
				grid.hideCol("PR_AMT", true);
				grid.hideCol("REQ_DATE", true);
				grid.hideCol("CONT_TYPE1_TEXT", true);
				grid.hideCol("CONT_TYPE2", true);
				grid.hideCol("VENDOR_SEND_FLAG", true);
				//grid.hideCol("CONT_TYPE", true);
				grid.hideCol("STAMP_ATT_FILE_CNT", true);
				grid.hideCol("GUAR_CNT", true);
				grid.hideCol("ADV_GUAR_CNT", true);
				grid.hideCol("WARR_GUAR_CNT", true);
				grid.hideCol("DI_GUAR_CNT", true);
		    	grid.hideCol("IF_YN", true);
				grid.hideCol("IF_TYPE", true);
			}
			
		    // 그리드머지여부
			EVF.V('MERGE_FLAG', '0');
		    
			if( type == "A" || type == "B" ) {
				if ("${ses.companyCd}".indexOf("${itPortalCustCd}") > -1) {
					EVF.V("CONT_USER_TYPE", "C");
				} else {
					EVF.V("CONT_USER_TYPE", "P");
				}
			}
			
			// 계약체결 완료 삭제
			setType();

		 	// 2021.07.20 농협정보(C00007) => ERP전송여부 View
		    if ("${ses.companyCd}".indexOf("${erpCustCd}") < 0) {
		    	grid.hideCol("ERP_SEND", true);
            }
            
		    // 2020.12.02 자동조회 추가
		    doSearch();
		}

		function setStampAttFileNum() {
			grid.setCellValue(rowIdx, 'STAMP_ATT_FILE_CNT', fileCnt);
			grid.setCellValue(rowIdx, 'STAMP_ATT_FILE_NUM', fileId);
		}

		function setType() {
			setProgressCdOption(type);	// 진행상태 기본값 세팅
			//setContTypeOption(type);	// 계약서 종류 기본값 세팅
			setContUserIdNm(type);		// 계약담당자 기본값 세팅
		}
		
		// 진행상태 기본값 세팅
		function setProgressCdOption(type){
			var proNm = "";
			var nhproNm = "";
			// 계약체결진행현황, 위수탁 체결진행현황
			if(type == "A" || type == "C"){
				$('input[name=multiselect_PROGRESS_CD]').each(function (k, v) {
					if( !(v.value == "4300" || v.value == "") ) {
						proNm += v.title + ", ";
						v.checked = true;
					} else {
						$(v).parent().remove();
					}
				});
				$("#PROGRESS_CD").next().find("span, .e-select-text").text(proNm.substr(0, proNm.length - 2));
				
				$('input[name=multiselect_NHPROGRESS_CD]').each(function (k, v) {
					if( !(v.value == "4300" || v.value == "") ) {
						nhproNm += v.title + ", ";
						v.checked = true;
					} else {
						$(v).parent().remove();
					}
				});
				$("#NHPROGRESS_CD").next().find("span, .e-select-text").text(nhproNm.substr(0, nhproNm.length - 2));
			}
			// 계약체결현황, 위수탁 체결현황
			else {
				$("input[name=multiselect_PROGRESS_CD]").each(function (k, v) {
					if(v.value == "4300") {
						proNm += v.title + ", ";
						v.checked = true;
					} else {
						$(v).parent().remove();
					}
				});
				$("#PROGRESS_CD").next().find("span, .e-select-text").text(proNm.substr(0, proNm.length - 2));
				EVF.C("PROGRESS_CD").setReadOnly(true);
				
				$("input[name=multiselect_NHPROGRESS_CD]").each(function (k, v) {
					if(v.value == "4300") {
						nhproNm += v.title + ", ";
						v.checked = true;
					} else {
						$(v).parent().remove();
					}
				});
				$("#NHPROGRESS_CD").next().find("span, .e-select-text").text(nhproNm.substr(0, nhproNm.length - 2));
				EVF.C("NHPROGRESS_CD").setReadOnly(true);
			}
		}
		
		// 계약서 종류 기본값 세팅
		//function setContTypeOption(type){
		//	var proNm = "";
		//	if(type == "A" || type == "B"){
		//		$('input[name=multiselect_CONT_TYPE]').each(function (k, v) {
		//			if( (v.value == "1120") ) {
		//				$(v).parent().remove();
		//			}
		//		});
		//		$("CONT_TYPE").next().find("span, .e-select-text").text(proNm.substr(0, proNm.length - 2));
		//	}
		//	else {
		//		$('input[name=multiselect_CONT_TYPE]').each(function (k, v) {
		//			if( v.value == "1120"  ) {
		//				proNm += v.title + ", ";
		//				EVF.V("CONT_TYPE","1120");
		//			} else {
		//				$(v).parent().remove();
		//			}
		//		});
		//		$("#CONT_TYPE").next().find("span, .e-select-text").text(proNm.substr(0, proNm.length - 2));
		//		EVF.C("CONT_TYPE").setReadOnly(true);
		//	}
		//} 
		
		// 계약담당자 기본값 세팅
		function setContUserIdNm(type){
			// 위수탁 체결진행현황, 위수탁 체결현황
			if( type== "C" || type == "D"){
				$("#NHCONT_USER_ID").val("");
				$("#NHCONT_USER_NM").val("");
			}
		}

		// Search
		function doSearch() {
			var MERGE_FLAG = EVF.V("MERGE_FLAG");
			var store = new EVF.Store();

			// form validation Check
			if (!store.validate()) return;

			store.setGrid([grid]);
			store.setParameter("MERGE_FLAG", MERGE_FLAG);
			store.load(baseUrl + "/cctr0050_doSearch.so", function () {
				var MergeFlag = this.getParameter("MergeFlag");
				if (grid.getRowCount() == 0) {
					return EVF.alert('${msg.M0002}');
				}
				
				if(MergeFlag == '1'){
					grid.setColMerge(["CONT_NUM", "CONT_CNT", "BUNDLE_NUM"]);
					grid.setColMerge(["CONT_NUM", "CONT_CNT", "PROGRESS_CD_NM", "SIGN_STATUS"]);
					grid.setColMerge(["CONT_NUM", "CONT_CNT", "VENDOR_CD", "VENDOR_NM", "VENDOR_SEND_FLAG", "CONT_DESC", "CONT_REQ_CD", "FORM_NM", "MANUAL_CONT_FLAG", "CONT_DATE", "CONT_START_DATE", "CONT_END_DATE"]);
					grid.setColMerge(["CONT_NUM", "CONT_CNT", "CONT_AMT_SUM", "PR_AMT", "REQ_DATE", "CUR", "VAT_TYPE", "CONT_TYPE1_TEXT", "CONT_TYPE1", "CONT_TYPE2", "SEND_DATE", "S_SIGN_DATE", "S_SING_NM"]);
					grid.setColMerge(["CONT_NUM", "CONT_CNT", "B_SIGN_DATE", "B_SING_NM"]);
					grid.setColMerge(["CONT_NUM", "CONT_CNT", "AUTO_RENEW_FLAG", "FINISH_FLAG", "CONT_CLOSE_DATE", "CONT_CLOSE_RMK", "ATT_FILE_CNT", "VENDOR_ATT_FILE_CNT", "STAMP_ATT_FILE_CNT"]);
					grid.setColMerge(["CONT_NUM", "CONT_CNT", "BUYER_NM", "CONT_USER_NM", "ERP_SEND", "IF_TYPE"]);
					grid.setColMerge(["CONT_NUM", "CONT_CNT", "VENDOR_PIC_USER_NM", "VENDOR_PIC_USER_EMAIL", "VENDOR_PIC_USER_CELL_NUM"]);
				} else {
					grid.setColMerge(["CONT_NUM", "CONT_CNT", "PR_BUYER_DEPT_NM", "BUNDLE_NUM"]);
					grid.setColMerge(["CONT_NUM", "CONT_CNT", "PR_BUYER_DEPT_NM", "PROGRESS_CD_NM", "SIGN_STATUS"]);
					grid.setColMerge(["CONT_NUM", "CONT_CNT", "PR_BUYER_DEPT_NM", "VENDOR_CD", "VENDOR_NM", "VENDOR_SEND_FLAG", "CONT_DESC", "CONT_REQ_CD", "FORM_NM", "MANUAL_CONT_FLAG", "CONT_DATE", "CONT_START_DATE", "CONT_END_DATE"]);
					grid.setColMerge(["CONT_NUM", "CONT_CNT", "PR_BUYER_DEPT_NM", "CONT_AMT_SUM", "PR_AMT", "REQ_DATE", "CUR", "VAT_TYPE", "CONT_TYPE1_TEXT", "CONT_TYPE1", "CONT_TYPE2", "SEND_DATE", "S_SIGN_DATE", "S_SING_NM"]);
					grid.setColMerge(["CONT_NUM", "CONT_CNT", "PR_BUYER_DEPT_NM", "B_SIGN_DATE", "B_SING_NM"]);
					grid.setColMerge(["CONT_NUM", "CONT_CNT", "PR_BUYER_DEPT_NM", "AUTO_RENEW_FLAG", "FINISH_FLAG", "CONT_CLOSE_DATE", "CONT_CLOSE_RMK", "ATT_FILE_CNT", "VENDOR_ATT_FILE_CNT", "STAMP_ATT_FILE_CNT"]);
					grid.setColMerge(["CONT_NUM", "CONT_CNT", "PR_BUYER_DEPT_NM", "BUYER_NM", "CONT_USER_NM", "ERP_SEND", "IF_TYPE"]);
					grid.setColMerge(["CONT_NUM", "CONT_CNT", "PR_BUYER_DEPT_NM", "VENDOR_PIC_USER_NM", "VENDOR_PIC_USER_EMAIL", "VENDOR_PIC_USER_CELL_NUM"]);
				}
				
				grid.setColIconify("CONT_CLOSE_RMK", "CONT_CLOSE_RMK", "comment", false);
			});
		}
		
		// 2021.08.19 추가
	    function doSearchDT() {

            var store = new EVF.Store();
            store.setGrid([gridI]);
            store.load(baseUrl + "/cctr0050_doSearchECMT.so", function() {
            	
            	var allRowId = gridI.getAllRowId();
				for(var i in allRowId) {
					var rowIdx = allRowId[i];
					var purchase_type = gridI.getCellValue(rowIdx, "PURCHASE_TYPE");
					if(purchase_type == "S" || purchase_type == "B"  || purchase_type == "M") {
						onChangeDiscount(rowIdx, "SW_BIZ_AMT");
					} else {
						onChangeDiscount(rowIdx, "CONSUMER_AMT");
					}
					
					gridI.checkRow(rowIdx, false);
				}
            });
        }
		
	    function onChangeDiscount(rowIdx, colIdx) {
			if (gridI.getCellValue(rowIdx, "ITEM_AMT") == 0) return;
			
			var prAmt     = Number(gridI.getCellValue(rowIdx, "ITEM_AMT"));
			var targetAmt = Number(gridI.getCellValue(rowIdx, colIdx));
			var discount  = 0
			if (targetAmt > 0) {
				discount = ((targetAmt - prAmt) / targetAmt) * 100;
			}
			gridI.setCellValue(rowIdx, colIdx.replace("AMT", "DISCOUNT"), Math.abs(discount.toFixed(1)));
		}
	    
		// 2021.08.30
		// 품목현황의 it포탈의뢰번호/상세의뢰번호/품목ID 변경사항 저장하기
		function doSave() {

			if (gridI.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
			
			var store = new EVF.Store();
			EVF.confirm("${msg.M0021}", function () {
				store.setGrid([gridI]);
				store.getGridData(gridI, "sel");
				store.load(baseUrl + '/cctr0050_doSave.so', function () {
					EVF.alert(this.getResponseMessage(), function () {
						doSearchDT();
					});
				});
			});
		}
		
		// 계약체결 고객사 조회
		function getBuyer() {
			var param = {
				callBackFunction: "setBuyer"
			};
			everPopup.openCommonPopup(param, "SP0066");
		}
		
		function setBuyer(data) {
			EVF.V("PR_BUYER_CD", data.CUST_CD);
			EVF.V("PR_BUYER_NM", data.CUST_NM);
		}
		
		// 계약체결 고객사 부서 조회
		function getDept() {

			var param = {
				callBackFunction: "setDept"
			};
			everPopup.openCommonPopup(param, 'SP0119');
		}

		function setDept(data) {
			EVF.V("PR_DEPT_CD", data.DEPT_CD);
			EVF.V("PR_DEPT_NM", data.DEPT_NM);
		}
		
		function getVendor() {
			
			if (type == "A" || type == "B") {
				var param = {
						callBackFunction: "setVendor"
					};
				everPopup.openCommonPopup(param, "SP0123");
			}
			else {
				var param = {
          				'callBackFunction': 'setVendor',
          				'RELAT_YN'  : '0',		//농협(0), 비농협(1) : NH0005
        				'CORP_TYPE' : '2',		//지역농축협(2) : NH0002
          				'READONLY'  : 'Y',		//팝업 조회조건 변경불가
          				'multiYN'   : 'N',		//멀티팝업여부
          				'viewFlag'  : 'EN',		//화면구분
          				'detailView': false
        	  		};
        	  	everPopup.openPopupByScreenId("CCDU0010", 1000, 700, param);
			}
		}

		function setVendor(data) {
			
			if (type == "A" || type == "B") {
				EVF.V("VENDOR_CD", data.VENDOR_CD);
				EVF.V("VENDOR_NM", data.VENDOR_NM);
			}
			else {
				data = JSON.parse(data);
	        	if (data != null) {
	        		EVF.V("VENDOR_CD", data.CUST_CD);
	        		EVF.V("VENDOR_NM", data.CUST_NM);
	        	}
			}
		}
		
		function getCtrlUser() {
			var param = {
					'callBackFunction': 'setCtrlUser',
					'READONLY': 'Y',		//팝업 조회조건 변경불가
					'multiYN' : 'N',        //멀티팝업여부
					'CTRL_CD' : "BR040,BR050",	// 계약담당자,계약체결자 권한
					'detailView': false
			};
			everPopup.openPopupByScreenId("CCDU0020", 1100, 700, param);
		}

		function setCtrlUser(data) {
			if(data!=null){
				data = JSON.parse(data);
				if (type == "A" || type == "B") {
					EVF.V("CONT_USER_ID", data.USER_ID);
					EVF.V("CONT_USER_NM", data.USER_NM);
				} else {
					EVF.V("NHCONT_USER_ID", data.USER_ID);
					EVF.V("NHCONT_USER_NM", data.USER_NM);
				}
			}
		}

		function getDrafter() {
			var param = {
					'callBackFunction': 'setDrafter',
					'READONLY': 'Y',		//팝업 조회조건 변경불가
					'multiYN' : 'N',        //멀티팝업여부
					'CTRL_CD' : "BR040,BR050",	// 계약담당자,계약체결자 권한
					'detailView': false
			};
			everPopup.openPopupByScreenId("CCDU0020", 1100, 700, param);
		}

		function setDrafter(data) {
			if(data!=null){
				data = JSON.parse(data);
				EVF.V("CHNG_USER_ID", data.USER_ID);
				EVF.V("CHNG_USER_NM", data.USER_NM);
			}
		}

		// 담당자변경
		function doChangeContUser() {

			if(!grid.isExistsSelRow()) { return EVF.alert("${msg.M0004}"); }

			var selRowId = grid.getSelRowId();
			for(var i in selRowId) {
				// 2021.02.08 중앙회 요청 "관리자직무"를 갖는 사람은 담당자 변경 가능하도록 추가
				if(!changeFlag) {
					if (grid.getCellValue(selRowId[i], "CONT_USER_ID") != "${ses.userId}") {
						return EVF.alert("${msg.M0008}"); // 계약담당자건만 처리 가능함
					}
				}
			}

			if( EVF.V("CHNG_USER_ID") == "" ){
				return EVF.alert("계약담당자를 선택하여 주시기 바랍니다.");
			}

			var store = new EVF.Store();
			EVF.confirm("선택한 계약건의 계약 담당자를 변경하시겠습니까?", function() {
				store.setGrid([grid]);
				store.getGridData(grid, "sel");
				store.load(baseUrl+'/cctr0050_changeContUser.so', function() {
					EVF.alert("${msg.M0001}");
					doSearch();
				});
			});

		}

		// 계약체결중단
		function doStop() {

			if(!grid.isExistsSelRow()) { return alert('${msg.M0004}'); }

			var selRowId = grid.getSelRowId();
			for(var i in selRowId) {
				if (grid.getCellValue(selRowId[i], "CONT_USER_ID") != "${ses.userId}") {
					return alert("${msg.M0008}"); // 계약담당자건만 처리 가능함
				}
				
				var progressCd = grid.getCellValue(selRowId[i], "PROGRESS_CD");
				if (progressCd < 4210 || progressCd >= 4300) {
					return alert("계약이 진행중인 건만 계약체결 중단 하실 수 있습니다."); // 계약진행중인건만 중단가능
				}
			}

			var param = {
				title : '계약체결 중단사유',
				callbackFunction : 'setStopApproval',
				detailView : false
			};
			everPopup.commonTextInput(param);
		}

		function setStopApproval(data) {
			var store = new EVF.Store();

			if( data != undefined && data != null ) {
				EVF.C("CONT_CLOSE_RMK").setValue(data.message);
			}

			EVF.confirm("선택한 건을 계약체결 중단 하시겠습니까?", function() {
				store.setGrid([grid]);
				store.getGridData(grid, "sel");
				store.load(baseUrl+'/cctr0050_doStop.so', function() {
					EVF.alert("${msg.M0001}");
					doSearch();
				});
			});

		}

		// 계약강제종결
		function doFinish() {

			if(!grid.isExistsSelRow()) { return EVF.alert('${msg.M0004}'); }

			var selRowId = grid.getSelRowId();
			for(var i in selRowId) {
				//2024.05.31 기존 계약담당자가 인사이동으로 인하여 계약담당자권한자는 타 계약담당자의 건도 종결처리 가능하도록 변경
			    if (grid.getCellValue(selRowId[i], "CONT_USER_ID") != '${ses.userId}') {
					if(!changeCont){
						return EVF.alert("${msg.M0008}"); // 계약담당자건만 처리 가능함
					}
				}
				
				if (grid.getCellValue(selRowId[i], "PROGRESS_CD") != 4300) {
					return EVF.alert("계약진행중인건만 중단하실 수 있습니다."); // 계약진행중인건만 중단가능
				}
				
				if (grid.getCellValue(selRowId[i], "CONT_EXPIRE_DAY_CNT") == '계약종료') {
					return EVF.alert("계약이 종료 된 건은 계약강제종결 처리 하실 수 없습니다."); // 이미 계약이 종료된 건
				}
			}

			// 강제종결일자
			if( EVF.V("CONT_CLOSE_DATE") == "" ){
				return EVF.alert("강제종결일자를 선택하여 주시기 바랍니다..");
			}

			var param = {
				title : '계약 강제종결사유',
				callbackFunction : 'setFinishApproval',
				detailView : false
			};
			everPopup.commonTextInput(param);
		}

		function setFinishApproval(data) {
			var store = new EVF.Store();

			if( data != undefined && data != null ) {
				EVF.C("CONT_CLOSE_RMK").setValue(data.message);
			}

			EVF.confirm("정말 계약강제종결 처리 하시겠습니까?", function() {
				store.setGrid([grid]);
				store.getGridData(grid, "sel");
				store.load(baseUrl+"/cctr0050_doFinish.so", function() {
					EVF.alert("${msg.M0001}");
					doSearch();
				});
			});
		}
		
		// 2021.08.19
		// 타시스템 Interface건은 변경계약서 작성 안됨
		function doChangeCont() {
			
			if(!grid.isExistsSelRow()) { return alert('${msg.M0004}'); }
			
			var bundleFlag = false;
			var selRowId   = grid.getSelRowId();
			for (var i in selRowId) {
				if (grid.getCellValue(selRowId[i], "CONT_USER_ID") != '${ses.userId}') {
					if(!changeCont){
						return EVF.alert("${msg.M0008}"); // 계약담당자건만 처리 가능함
					}
				}
				
				if (grid.getCellValue(selRowId[i], "PROGRESS_CD") != 4300) {
					return EVF.alert("${CCTR0050_0003}"); // 계약완료건만 수정 및 재계약 가능
				}
				
				if (grid.getCellValue(selRowId[i], "BUNDLE_NUM") != "") {
					bundleFlag = true;
				}
			}
			
			var cont_num_cnt = [];
			if (bundleFlag) {
				for(var j in selRowId) {
					if(grid.getCellValue(selRowId[0], "BUNDLE_NUM") != grid.getCellValue(selRowId[j], "BUNDLE_NUM")) {
						return EVF.alert("동일한 일괄계약번호를 선택하여 주시기 바랍니다.");
					} else {
						cont_num_cnt.push({
							CONT_NUM: grid.getCellValue(selRowId[j], "CONT_NUM"),
							CONT_CNT: grid.getCellValue(selRowId[j], "CONT_CNT")
						});
					}
				}
				EVF.V("BUNDLE_NUM", grid.getCellValue(selRowId[0], "BUNDLE_NUM"));
				EVF.V("CONT_NUM_CNT", JSON.stringify(cont_num_cnt));
			} else {
				if (grid.getSelRowId().length > 1) { return alert("${msg.M0006}"); }
			}

			var store = new EVF.Store();
			EVF.confirm("변경 계약서를 작성 하시겠습니까?\n\n[확인] 클릭시 (임시저장)된 새로운 계약서가 생성됩니다.\n계약체결진행현황에서 확인하세요.", function() {
				store.setGrid([grid]);
				store.getGridData(grid, "sel");
				store.load(baseUrl+'/cctr0050_doResume.so', function() {
					if( this.getResponseMessage() != null && this.getResponseMessage() == '1' ){
						EVF.alert("이미 진행중인 건이 있습니다. 다시 확인하세요.");
					}
					else {
						var url = "";
						var param = {
							callBackFunction: 'doSearch',
							reCont: true,
							detailView: false,
							bundleFlag: bundleFlag
						};
						
						if (bundleFlag) {
							param["url"] = "/nhepro/CCTR/CCTA0040/view.so";
							param["BUNDLE_NUM"]   = this.getParameter("BUNDLE_NUM");
							param["CONT_NUM_CNT"] = this.getParameter("CONT_NUM_CNT");
						} else {
							param["url"] = "/nhepro/CCTR/CCTA0030/view.so";
							param["CONT_NUM"] = this.getParameter('CONT_NUM');
							param["CONT_CNT"] = this.getParameter('CONT_CNT');
						}
						
						everPopup.openContractChangeInformation(param);
					}
					doSearch();
				});
			});
		}

		function doPrint() {
			if(!grid.isExistsSelRow()) { return alert('${msg.M0004}'); }
			if(grid.getSelRowId().length > 1) { return alert("${msg.M0006}"); }
			
			var selRowValue = grid.getSelRowValue()[0];
			var contPdfNum  = selRowValue.PDF_ATT_FILE_NUM;
			var contNum = selRowValue.CONT_NUM;
			var contCnt = selRowValue.CONT_CNT;
			
			if( EVF.isEmpty(contPdfNum) ) {
				if(type == "C" || type == "D"){
			    	return EVF.alert("생성된 PDF 계약서가 없습니다. 계약번호 클릭시 PDF 계약서가 생성됩니다.\n\n계약번호 클릭 후 다시 조회하세요.");
				} else {
					return EVF.alert("생성된 PDF 계약서가 없습니다.");
				}
		    }
			
			//2022.03.24 최종 계약서 다운로드시 다운로드파일명 변경(회사코드계약번호계약차수 => 회사코드계약번호계약차수_일자_계약명_업체명)
			//var url = "/common/file/fileAttach/viewPdf.so?EVER_REQUEST_DATA_TYPE=FILE_DOWNLOAD&UUID=" + contPdfNum;
			var url = "/common/file/fileAttach/contViewPdf.so?EVER_REQUEST_DATA_TYPE=FILE_DOWNLOAD&UUID=" + contPdfNum + "&CONT_NUM=" + contNum + "&CONT_CNT=" + contCnt;
			
			window.open(url, "eform", "width=850,height=1265,scrollbars=yes,resizeable=no,left=0,top=0");
		}

		function doSendErp() {

			if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
			if (grid.getSelRowCount() > 1) { return EVF.alert('${msg.M0006}'); }

			var selRowId = grid.getSelRowId();
			for(var i in selRowId) {
				if (grid.getCellValue(selRowId[i], "PROGRESS_CD") != '4300') {
					return EVF.alert("${CCTR0050_011}");
				}
				
				if (grid.getCellValue(selRowId[i], "ERP_SEND") == '1') {
					return EVF.alert("이미 전송된 건입니다.");
				}
			}

			var store = new EVF.Store();
			EVF.confirm('${CCTR0050_012}', function () {
				store.setGrid([grid]);
				store.getGridData(grid, 'sel');
				store.load(baseUrl+'/doSendErp.so', function() {
					EVF.alert(this.getResponseMessage(), function () {
						doSearch();
					});
				});
			});
		}
		
		// 2021.07.15
		// 농협중앙회 IT전략본부 직원인 경우 계약서 IT포탈전송 버튼 활성화
		function doSendITPortal() {

			if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
			
			var msg = "${CCTR0050_012}";
			
			var buyerCd = "";
			var contNum = "";
			var contCnt = "";
			var contNumCnt = "";	// 계약고객사 + 계약번호번호 + 계약차수
			var selRowId = grid.getSelRowId();
			for(var i in selRowId) {
				//if (grid.getCellValue(selRowId[i], "CONT_USER_ID") != '${ses.userId}') {
				//	return EVF.alert("${msg.M0008}"); // 계약담당자건만 처리 가능함
				//}
				
				if (grid.getCellValue(selRowId[i], "PROGRESS_CD") != '4300') {
					return EVF.alert("${CCTR0050_011}");
				}
				
				if (grid.getCellValue(selRowId[i], "IF_TYPE") != 'ITA' && grid.getCellValue(selRowId[i], "IF_TYPE") != 'ITB') {
					return EVF.alert("ITPortal에서 전송된 계약건이 아닙니다.\n\nInterface유형을 확인하세요.");
				}
				
				//2022.03.21 수기전송시 신규 외 변경 및 연장건도 전송 할수 있도록 변경
				/* if (grid.getCellValue(selRowId[i], "CONT_REQ_CD") != '10') {
					return EVF.alert("계약구분이 '신규'인 계약건만 전송이 가능합니다.\n\n계약구분을 확인하세요.");
				} */
				
				if (grid.getCellValue(selRowId[i], "IF_YN") == '1') {
					msg = "이미 전송된 건입니다. 재전송 하시겠습니까?";
				}
				
				// 동일한 체결고객, 계약번호, 계약차수는 1번만 조회함
				if(buyerCd == grid.getCellValue(selRowId[i], "BUYER_CD") && contNum == grid.getCellValue(selRowId[i], "CONT_NUM") && contCnt == grid.getCellValue(selRowId[i], "CONT_CNT")) {
					continue;
				} else {
					if( (Number(i) + 1) == selRowId.length ) {
						contNumCnt += grid.getCellValue(selRowId[i], "BUYER_CD") + grid.getCellValue(selRowId[i], "CONT_NUM") + grid.getCellValue(selRowId[i], "CONT_CNT");
					} else {
						contNumCnt += grid.getCellValue(selRowId[i], "BUYER_CD") + grid.getCellValue(selRowId[i], "CONT_NUM") + grid.getCellValue(selRowId[i], "CONT_CNT") + ",";
					}
					buyerCd = grid.getCellValue(selRowId[i], "BUYER_CD");
					contNum = grid.getCellValue(selRowId[i], "CONT_NUM");
					contCnt = grid.getCellValue(selRowId[i], "CONT_CNT");
				}
			}

			var store = new EVF.Store();
			EVF.confirm(msg, function () {
				store.setParameter('CONT_NUM_CNT', contNumCnt);
				store.load(baseUrl+'/doSendITPortal.so', function() {
					EVF.alert(this.getResponseMessage(), function () {
						doSearch();
					});
				});
			});
		}
		
		/**
		 * 2021.08.19 : 미사용 제외
		function doPdfValid() {
			if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
			if (grid.getSelRowCount() > 1) { return EVF.alert('${msg.M0006}'); }

			var selRowId = grid.getSelRowId();
			for(var i in selRowId) {
				if (grid.getCellValue(selRowId[i], "PROGRESS_CD") != '4230') {
					return EVF.alert("협력업체 서명완료 된 PDF만 검증하실 수 있습니다.");
				} else {
					var store = new EVF.Store();
					store.setParameter("PDF_ATT_FILE_NUM", grid.getCellValue(selRowId[i], "PDF_ATT_FILE_NUM"));
					store.load(baseUrl+"/doPdfValid.so", function() {
						if(this.getResponseMessage() == "success") {
							EVF.alert("PDF 진본 파일 입니다.");
						} else {
							EVF.alert("PDF 진본 파일이 아닙니다.");
						}
					});
				}
			}
		}*/
		
		var multiSignData;
		//발주사 다건 전자서명 
		function doCustMultiSign() {

			var var_CERT_TYPE = EVF.V("CERT_TYPE");
			
			if (var_CERT_TYPE == '') {
				return EVF.alert("다건서명할 인증서를 선택 바랍니다.");
			}
			
			if(!grid.isExistsSelRow()) { return EVF.alert('${msg.M0004}'); }
			
			var selRowId = grid.getSelRowId();
			for(var i in selRowId) {
				if (grid.getCellValue(selRowId[i], "PROGRESS_CD") != '4230') {
					return EVF.alert("협력업체 서명완료 된 계약만 전자서명 하실 수 있습니다.");
				}
			}			

			EVF.confirm("${CCTR0050_0021}", function() {

				if(localServerFlag == "Y") {
					signCompleteCallback();
				} else {
					multiSignData = new Array();
					var rowCount = grid.getSelRowCount();
					var selRowId = grid.getSelRowId();
					var Cnt = 0;
					var lastCnt = false;
					for(var i in selRowId) {
						Cnt = Cnt + 1;
						if(Cnt == rowCount){
							lastCnt = true;
						}
						
						if(var_CERT_TYPE == "C") {
							document.reqForm.useCard.value = "1"; // 공인인증서
						} else {
							document.reqForm.useCard.value = "2"; // 사설인증서
						}
					    
						eformScheduler(grid.getCellValue(selRowId[i], "BUNDLE_NUM")
								     , grid.getCellValue(selRowId[i], "CONT_TYPE")
								     , var_CERT_TYPE
								     , grid.getCellValue(selRowId[i], "CONT_NUM")
								     , grid.getCellValue(selRowId[i], "CONT_CNT")
								     ,lastCnt
								     , grid.getCellValue(selRowId[i], "FORM_FILE_NM")
								     , grid.getCellValue(selRowId[i], "SUB_FORM_FILE_NM")
								     , grid.getCellValue(selRowId[i], "BUYER_CD")								     
						);
					}	
				}				
			});					
		}				
		
		function eformScheduler(bundle_num, cont_type, cert_type, cont_num, cont_cnt, lastCnt, FORM_FILE_NM, SUB_FORM_FILE_NM, BUYER_CD) {
			console.log("OZ Scheduler Start");
			
			var hashNum = "";
			// 저장된 JSON 데이터 값을 조회하여 가져온다.
			//2021.02.16 STOCECCT 테이블 CLOB TYPE 신규 컬럼 EFORM_INPUT_VALUE_CLOB 생성, 기존 EFORM_INPUT_VALUE 사용 => EFORM_INPUT_VALUE_CLOB 사용
			var eformInputValue = "";
			var store = new EVF.Store();
			store.setAsync(false);
			store.setParameter("BUNDLE_NUM", bundle_num);
			store.setParameter("CONT_NUM", cont_num);
			store.setParameter("CONT_CNT", cont_cnt);
			store.setParameter("BUYER_CD", BUYER_CD);			
			store.load("/nhepro/CCTR/CCTA0030/ccta0030_doSelectEformJsonDataM.so", function() {
				eformInputValue = this.getParameter("EFORM_INPUT_VALUE_CLOB");
			});
			
			// 서브 폼 파일명을 가져온다.
			var subFormFileNm = SUB_FORM_FILE_NM;

			// 파일이 첨부되어 있는 경우 서브 페이지를 호출한다.
			<%--							
			var fileCnt = VENDOR_ATT_FILE_CNT;
			if (fileCnt > 0) {
				subFormFileNm += "BS_FILE_INFO";

				// 파일 정보가 존재 시 파일 정보 선 저장
				var store = new EVF.Store();
				store.setParameter("BUNDLE_NUM", bundle_num);
				store.doFileUpload(function() {
					store.load(baseUrl+'/ccta0040_doUpdateVendorFile.so', function() {
					}, true);
				});
			}
			--%>				

			// BUNDLE_NUM 로 전체 CONT_NUM, CONT_CNT를 조회한다.
			var store = new EVF.Store();
			store.setAsync(false);
			store.setParameter("BUNDLE_NUM", bundle_num);
			store.setParameter("CONT_NUM", cont_num);
			store.setParameter("CONT_CNT", cont_cnt);
			store.setParameter("BUNDLE_CNT", "1");
			store.load("/nhepro/CCTR/CCTA0040" + "/ccta0040_doSearchBundelInfoM.so", function () {
				
				var contInfo = JSON.parse(this.getParameter("CONT_INFO"));
				for(var i in contInfo) {
					var cnt = (Number(i) + 1);
					var maxCnt = contInfo.length;

					// pdf 저장
					var odiParamVal = "BUYER_CD=" + contInfo[i].BUYER_CD + ",CONT_NUM=" + contInfo[i].CONT_NUM + ",CONT_CNT=" + contInfo[i].CONT_CNT;
					var name = contInfo[i].BUYER_CD + contInfo[i].CONT_NUM + contInfo[i].CONT_CNT;
					var param = {
							bizType: "EC",
			                SUB_FORM_FILE_NM: subFormFileNm,
							odiName: "DANIL_INFO",
							ozrName: FORM_FILE_NM,
							// OZ Scheduler Info
							serverUrl: "${ozServer}",
							schedulerIp: "${ozSchedulerIp}",
							schedulerPort: "${ozSchedulerPort}",
							exportFileName: name,
							odiParamVal: odiParamVal,
							url: "${ozUrl}",
							inputJson: eformInputValue,
							exportFormat: "pdf"
					};

					console.log("동기화 방식 OZ Scheduler 페이지 호출 시작");
					$.ajax({
						url: "${ozUrl}" + "/oz_export_directexport.jsp",
						type: "post",
						data: param,
						async: false,
						success: function(data) {
							console.log("동기화 방식 OZ Scheduler 페이지 호출 완료");
							
							param = {
								bizType: "EC",
								fileNm: name,
								fileExtension: "pdf",
								CONT_NUM: contInfo[i].CONT_NUM,
								CONT_CNT: contInfo[i].CONT_CNT,
								buyerCd: contInfo[i].BUYER_CD,
								prBuyerCd: contInfo[i].PR_BUYER_CD,
								prDeptCd: contInfo[i].PR_DEPT_CD,
								uuid: contInfo[i].PDF_ATT_FILE_NUM,
								fileCnt: 1,
								maxFileCnt: 1,
								fileType: "M"
							};
							
							console.log("동기화 방식 pdf eform Server 에서 생성 파일 이동");
							$.ajax({
								url: "/common/file/eformPdfUpload.so",
								type: "post",
								data: param,
								async: false,
								success: function(data) {
									console.log("동기화 방식 pdf eform Server 에서 생성 파일 이동 완료");
									console.log("동기화 방식 pdf eform Server 에서 생성 파일 DB 관리 위해 채번");
									
									var fileInfo = data;
									var jsonData = JSON.parse(data);
									    hashNum  = jsonData.HASH_NUM;
									// STOCATCH 저장 후 PDF UUID 저장(개별 처리)
									$.ajax({
										url: "/nhepro/CCTR/CCTA0040" + "/ccta0040_doUpdatePdfUUID.so",
										type: "post",
										data: {json: data},
										success: function(data) {
											console.log("동기화 방식 pdf eform Server 에서 생성 파일 DB 관리 위해 채번 완료");

											if(cnt == maxCnt) {
												// 발주사 전자서명시 생성된 pdf 파일에 대한 위변조 적용
												if(cert_type == "P") { // 전자서명
													var store = new EVF.Store();
													store.setAsync(false);
												    store.setParameter("FILE_INFO", fileInfo);
													store.load("/nhepro/CCTR/CCTA0040" + '/ccta0040_doSignCompleteTSA.so', function () {
														multiSignData.push("${ses.companyCd}" + "@@" + document.reqForm.idn.value + "@@" + hashNum + "@@" + "${signDate}");
													});												
												}
												else{
													multiSignData.push("${ses.companyCd}" + "@@" + document.reqForm.idn.value + "@@" + hashNum + "@@" + "${signDate}");
												}
												if(lastCnt == true){
													mlCallPopUp();
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
		
		function mlCallPopUp(){
			var idn = document.reqForm.idn.value;
			var vidType = document.reqForm.vidType.value;
			
			document.reqForm.signData.value = multiSignData;
			magicline.uiapi.MakeMultiSignData(multiSignData, null, mlCallBack, null, idn, vidType);	
			
		}
		
		function mlCallBack(code, message){
			
			if(code == 0) { <%-- 정상메시지 --%>
				if (message.encMsg != null) { document.reqForm.signedData.value = encodeURIComponent(JSON.stringify(message.encMsg)); }
				if (message.vidRandom != null) { document.reqForm.vidRandom.value = encodeURIComponent(message.vidRandom); }
				
				signCompleteCallback();
			}
			else {
				return EVF.alert("결과값 수신에 실패하였습니다.");
			}
		}						
		
		<%-- 전자서명 완료 후 처리 --%>
		function signCompleteCallback() {
			var store = new EVF.Store();
			store.setAsync(false);
			store.setGrid([grid]);
			store.getGridData(grid, "sel");
			store.setParameter("signedData", document.reqForm.signedData.value);
			store.setParameter("vidRandom", document.reqForm.vidRandom.value);
			store.setParameter("idn", document.reqForm.idn.value);
			store.setParameter("useCard", document.reqForm.useCard.value);
			store.setParameter("localServerFlag", "N");
			store.load(baseUrl + '/cctr0050_doMultiSign.so', function () {
				EVF.alert("계약서에 서명하셨습니다.");
				doSearch();
			}, true);
		}
	</script>

	<e:window id="CCTR0050" initData="${initData}" onReady="init" title="${fullScreenName }" breadCrumbs="${breadCrumb }">
		<e:searchPanel id="form" title="${msg.M9999}" labelWidth="130" width="100%" columnCount="3" useTitleBar="true" onEnter="doSearch">
			<e:inputHidden id="BUNDLE_NUM" name="BUNDLE_NUM" />
			<e:inputHidden id="CONT_NUM_CNT" name="CONT_NUM_CNT" />
			<e:inputHidden id="CONT_CLOSE_RMK" name="CONT_CLOSE_RMK" />
			<e:inputHidden id="TYPE" name="TYPE" value="${param.TYPE}" />
			
			<!-- 2021.08.14 : 계약명 클릭시 하단 품목현황 조회 -->
			<e:inputHidden id="SCH_BUYER_CD" name="SCH_BUYER_CD" />
			<e:inputHidden id="SCH_CONT_NUM" name="SCH_CONT_NUM" />
			<e:inputHidden id="SCH_CONT_CNT" name="SCH_CONT_CNT" />
			
			<e:row>
				<%--계약일자, 종료일자--%>
				<e:label for="DATE_TYPE">
					<e:select id="DATE_TYPE" name="DATE_TYPE" value="" options="${dateTypeOptions}" readOnly="${form_DATE_TYPE_RO }" width="90" required="${form_DATE_TYPE_R }" disabled="${form_DATE_TYPE_D }"  usePlaceHolder="false" />
				</e:label>
				<e:field>
					<e:inputDate id="REG_DATE_FROM" toDate="REG_DATE_TO" name="REG_DATE_FROM" value="${fromDate }" width="${inputTextDate }" required="${form_REG_DATE_R }" readOnly="${form_REG_DATE_RO }" disabled="${form_REG_DATE_D }" datePicker="true" />
					<e:text>~</e:text>
					<e:inputDate id="REG_DATE_TO" fromDate="REG_DATE_FROM" name="REG_DATE_TO" value="${toDate }" width="${inputTextDate }" required="${form_REG_DATE_R }" readOnly="${form_REG_DATE_RO }" disabled="${form_REG_DATE_D }" datePicker="true" />
				</e:field>
				<%--고객사--%>
				<e:label for="PR_BUYER_CD" title="${(fn:substring(param.TYPE, 0, 1) eq 'C' or fn:substring(param.TYPE, 0, 1) eq 'D') ? CCTR0050_TXT01 : form_PR_BUYER_CD_N}"/>
				<e:field>
					<e:search id="PR_BUYER_CD" name="PR_BUYER_CD" value="" width="40%" maxLength="${form_PR_BUYER_CD_M}" onIconClick="${form_PR_BUYER_CD_RO ? 'everCommon.blank' : 'getBuyer'}" disabled="${form_PR_BUYER_CD_D}" readOnly="${form_PR_BUYER_CD_RO}" required="${form_PR_BUYER_CD_R}" maskType="${form_PR_BUYER_CD_MT}" placeHolder="회사코드" />
					<e:inputText id="PR_BUYER_NM" name="PR_BUYER_NM" value="" width="60%" maxLength="${form_PR_BUYER_NM_M}" disabled="${form_PR_BUYER_NM_D}" readOnly="${form_PR_BUYER_NM_RO}" required="${form_PR_BUYER_NM_R}" style="${imeMode}" maskType="${form_PR_BUYER_NM_MT}" placeHolder="회사명"/>
				</e:field>
				<%--계약부서명--%>
				<e:label for="PR_DEPT_CD" title="${(fn:substring(param.TYPE, 0, 1) eq 'C' or fn:substring(param.TYPE, 0, 1) eq 'D') ? CCTR0050_TXT02 : form_PR_DEPT_CD_N}"/>
				<e:field>
					<e:search id="PR_DEPT_CD" name="PR_DEPT_CD" value="" width="40%" maxLength="${form_PR_DEPT_CD_M}" onIconClick="${form_PR_DEPT_CD_RO ? 'everCommon.blank' : 'getDept'}" disabled="${form_PR_DEPT_CD_D}" readOnly="${form_PR_DEPT_CD_RO}" required="${form_PR_DEPT_CD_R}" maskType="${form_PR_DEPT_CD_MT}" placeHolder="부서코드" />
					<e:inputText id="PR_DEPT_NM" name="PR_DEPT_NM" value="" width="60%" maxLength="${form_PR_DEPT_NM_M}" disabled="${form_PR_DEPT_NM_D}" readOnly="${form_PR_DEPT_NM_RO}" required="${form_PR_DEPT_NM_R}" style="${imeMode}" maskType="${form_PR_DEPT_NM_MT}" placeHolder="부서명"/>
				</e:field>
			</e:row>
			<%--계약체결 조건명--%>
            <e:row>
				<%--계약담당자--%>
				<e:label for="CONT_USER_TYPE">
					<e:select id="CONT_USER_TYPE" name="CONT_USER_TYPE" value="" options="${contUserTypeOptions}" readOnly="${form_CONT_USER_TYPE_RO }" width="100" required="${form_CONT_USER_TYPE_R }" disabled="${form_CONT_USER_TYPE_D }"  usePlaceHolder="false" />
				</e:label>
				<e:field>
					<e:search id="CONT_USER_ID" name="CONT_USER_ID" value="${ses.userId }" width="40%" maxLength="${form_CONT_USER_ID_M}" onIconClick="${form_CONT_USER_ID_RO ? 'everCommon.blank' : 'getCtrlUser'}" disabled="${form_CONT_USER_ID_D}" readOnly="${form_CONT_USER_ID_RO}" required="${form_CONT_USER_ID_R}" maskType="${form_CONT_USER_ID_MT}" placeHolder="개인번호" />
					<e:inputText id="CONT_USER_NM" name="CONT_USER_NM" value="${ses.userNm }" width="60%" maxLength="${form_CONT_USER_NM_M}" disabled="${form_CONT_USER_NM_D}" readOnly="${form_CONT_USER_NM_RO}" required="${form_CONT_USER_NM_R}" style="${imeMode}" maskType="${form_CONT_USER_NM_MT}" placeHolder="성명"/>
				</e:field>
				<%--계약번호/명--%>
				<e:label for="CONT_NUM" title="${form_CONT_NUM_N}" />
				<e:field>
					<e:inputText id="CONT_NUM" name="CONT_NUM" value="" width="${form_CONT_NUM_W}" maxLength="${form_CONT_NUM_M}" disabled="${form_CONT_NUM_D}" readOnly="${form_CONT_NUM_RO}" required="${form_CONT_NUM_R}" style="${imeMode}" maskType="${form_CONT_NUM_MT}"/>
				</e:field>
				<%--진행상태--%>
				<e:label for="PROGRESS_CD" title="${form_PROGRESS_CD_N}"/>
				<e:field>
					<e:select id="PROGRESS_CD" name="PROGRESS_CD" value="" options="${progressCdOptions}" width="${form_PROGRESS_CD_W}" disabled="${form_PROGRESS_CD_D}" readOnly="${form_PROGRESS_CD_RO}" required="${form_PROGRESS_CD_R}" placeHolder="" maskType="${form_PROGRESS_CD_MT}" useMultipleSelect="true"/>
				</e:field>
            </e:row>
            <%--위수탁 조건명--%>
            <e:row>
            	<%--계약담당자--%>
				<e:label for="NHCONT_USER_ID" title="${form_NHCONT_USER_ID_N}"/>
				<e:field>
					<e:search id="NHCONT_USER_ID" name="NHCONT_USER_ID" value="${ses.userId }" width="40%" maxLength="${form_NHCONT_USER_ID_M}" onIconClick="${form_NHCONT_USER_ID_RO ? 'everCommon.blank' : 'getCtrlUser'}" disabled="${form_NHCONT_USER_ID_D}" readOnly="${form_NHCONT_USER_ID_RO}" required="${form_NHCONT_USER_ID_R}" maskType="${form_NHCONT_USER_ID_MT}" placeHolder="개인번호" />
					<e:inputText id="NHCONT_USER_NM" name="NHCONT_USER_NM" value="${ses.userNm }" width="60%" maxLength="${form_NHCONT_USER_NM_M}" disabled="${form_NHCONT_USER_NM_D}" readOnly="${form_NHCONT_USER_NM_RO}" required="${form_NHCONT_USER_NM_R}" style="${imeMode}" maskType="${form_NHCONT_USER_NM_MT}" placeHolder="성명"/>
				</e:field>
				<%--계약번호/명--%>
				<e:label for="NHCONT_NUM" title="${form_NHCONT_NUM_N}" />
				<e:field>
					<e:inputText id="NHCONT_NUM" name="NHCONT_NUM" value="" width="${form_NHCONT_NUM_W}" maxLength="${form_NHCONT_NUM_M}" disabled="${form_NHCONT_NUM_D}" readOnly="${form_NHCONT_NUM_RO}" required="${form_NHCONT_NUM_R}" style="${imeMode}" maskType="${form_NHCONT_NUM_MT}"/>
				</e:field>
				<%--진행상태--%>
				<e:label for="NHPROGRESS_CD" title="${form_NHPROGRESS_CD_N}"/>
				<e:field>
					<e:select id="NHPROGRESS_CD" name="NHPROGRESS_CD" value="" options="${nhprogressCdOptions}" width="${form_NHPROGRESS_CD_W}" disabled="${form_NHPROGRESS_CD_D}" readOnly="${form_NHPROGRESS_CD_RO}" required="${form_NHPROGRESS_CD_R}" placeHolder="" maskType="${form_NHPROGRESS_CD_MT}" useMultipleSelect="true"/>
				</e:field>
            </e:row>
            
			<e:row>
				<%--협력업체--%>
				<e:label for="VENDOR_CD" title="${(fn:substring(param.TYPE, 0, 1) eq 'C' or fn:substring(param.TYPE, 0, 1) eq 'D') ? CCTR0050_TXT03 : form_VENDOR_CD_N}"/>
				<e:field>
					<e:search id="VENDOR_CD" name="VENDOR_CD" value="" width="40%" maxLength="${form_VENDOR_CD_M}" onIconClick="${form_VENDOR_CD_RO ? 'everCommon.blank' : 'getVendor'}" disabled="${form_VENDOR_CD_D}" readOnly="${form_VENDOR_CD_RO}" required="${form_VENDOR_CD_R}" maskType="${form_VENDOR_CD_MT}" placeHolder="회사코드" />
					<e:inputText id="VENDOR_NM" name="VENDOR_NM" value="" width="60%" maxLength="${form_VENDOR_NM_M}" disabled="${form_VENDOR_NM_D}" readOnly="${form_VENDOR_NM_RO}" required="${form_VENDOR_NM_R}" style="${imeMode}" maskType="${form_VENDOR_NM_MT}" placeHolder="회사명"/>
				</e:field>
				<%--서식명--%>
				<e:label for="FORM_NM" title="${form_FORM_NM_N}"/>
				<e:field>
					<e:inputText id="FORM_NM" name="FORM_NM" value="" width="${form_FORM_NM_W}" maxLength="${form_FORM_NM_M}" disabled="${form_FORM_NM_D}" readOnly="${form_FORM_NM_RO}" required="${form_FORM_NM_R}" style="${imeMode}" maskType="${form_FORM_NM_MT}"/>
				</e:field>
				<%--꼐약구분--%>
				<e:label for="CONT_REQ_CD" title="${form_CONT_REQ_CD_N}"/>
				<e:field>
					<e:select id="CONT_REQ_CD" name="CONT_REQ_CD" value="" options="${contReqCdOptions}" width="${form_CONT_REQ_CD_W}" disabled="${form_CONT_REQ_CD_D}" readOnly="${form_CONT_REQ_CD_RO}" required="${form_CONT_REQ_CD_R}" placeHolder="" maskType="${form_CONT_REQ_CD_MT}" />
				</e:field>
			</e:row>
			<c:choose>
				<c:when test="${fn:substring(param.TYPE, 0, 1) eq 'A' or fn:substring(param.TYPE, 0, 1) eq 'B'}">
					<e:row>
						<%--품명--%>
						<e:label for="ITEM_DESC" title="${form_ITEM_DESC_N}"/>
						<e:field>
							<e:inputText id="ITEM_DESC" name="ITEM_DESC" value="" width="${form_ITEM_DESC_W}" maxLength="${form_ITEM_DESC_M}" disabled="${form_ITEM_DESC_D}" readOnly="${form_ITEM_DESC_RO}" required="${form_ITEM_DESC_R}" style="${imeMode}" maskType="${form_ITEM_DESC_MT}"/>
						</e:field>
						<%--계약방법--%>
						<e:label for="CONT_TYPE1" title="${form_CONT_TYPE1_N}"/>
						<e:field>
							<e:select id="CONT_TYPE1" name="CONT_TYPE1" value="" options="${contType1Options}" width="${form_CONT_TYPE1_W}" disabled="${form_CONT_TYPE1_D}" readOnly="${form_CONT_TYPE1_RO}" required="${form_CONT_TYPE1_R}" placeHolder="" maskType="${form_CONT_TYPE1_MT}" />
						</e:field>
						<%--낙찰자선정방법--%>
						<e:label for="CONT_TYPE2" title="${form_CONT_TYPE2_N}"/>
						<e:field>
							<e:select id="CONT_TYPE2" name="CONT_TYPE2" value="" options="${contType2Options}" width="${form_CONT_TYPE2_W}" disabled="${form_CONT_TYPE2_D}" readOnly="${form_CONT_TYPE2_RO}" required="${form_CONT_TYPE2_R}" placeHolder="" maskType="${form_CONT_TYPE2_MT}" />
						</e:field>
					</e:row>
					<e:row>
						<%--종결여부--%>
						<e:label for="FINISH_FLAG" title="${form_FINISH_FLAG_N}"/>
						<e:field>
							<e:select id="FINISH_FLAG" name="FINISH_FLAG" value="" options="${finishFlagOptions}" width="${form_FINISH_FLAG_W}" disabled="${form_FINISH_FLAG_D}" readOnly="${form_FINISH_FLAG_RO}" required="${form_FINISH_FLAG_R}" placeHolder="" maskType="${form_FINISH_FLAG_MT}" />
						</e:field>
						<e:label for="IF_TYPE" title="${form_IF_TYPE_N}"/>
						<e:field>
							<e:select id="IF_TYPE" name="IF_TYPE" value="" options="${ifTypeOptions}" width="${form_IF_TYPE_W}" disabled="${form_IF_TYPE_D}" readOnly="${form_IF_TYPE_RO}" required="${form_IF_TYPE_R}" placeHolder="" maskType="${form_IF_TYPE_MT}" />
						</e:field>
						<%--그리드머지여부--%>
						<e:label for="MERGE_FLAG" title="${form_MERGE_FLAG_N}"/>
						<e:field>
							<e:select id="MERGE_FLAG" name="MERGE_FLAG" value="" options="${mergeFlagOptions}" width="${form_MERGE_FLAG_W}" disabled="${form_MERGE_FLAG_D}" readOnly="${form_MERGE_FLAG_RO}" required="${form_MERGE_FLAG_R}" placeHolder="" maskType="${form_MERGE_FLAG_MT}" />
						</e:field>
					</e:row>
				</c:when>
				<c:otherwise>
					<e:row>
						<%--종결여부--%>
						<e:label for="FINISH_FLAG" title="${form_FINISH_FLAG_N}"/>
						<e:field>
							<e:select id="FINISH_FLAG" name="FINISH_FLAG" value="" options="${finishFlagOptions}" width="${form_FINISH_FLAG_W}" disabled="${form_FINISH_FLAG_D}" readOnly="${form_FINISH_FLAG_RO}" required="${form_FINISH_FLAG_R}" placeHolder="" maskType="${form_FINISH_FLAG_MT}" />
						</e:field>
						<e:label for="IF_TYPE" title="${form_IF_TYPE_N}"/>
						<e:field>
							<e:select id="IF_TYPE" name="IF_TYPE" value="" options="${ifTypeOptions}" width="${form_IF_TYPE_W}" disabled="${form_IF_TYPE_D}" readOnly="${form_IF_TYPE_RO}" required="${form_IF_TYPE_R}" placeHolder="" maskType="${form_IF_TYPE_MT}" />
						</e:field>
						<%--그리드머지여부--%>
						<e:label for="MERGE_FLAG" title="${form_MERGE_FLAG_N}"/>
						<e:field>
							<e:select id="MERGE_FLAG" name="MERGE_FLAG" value="" options="${mergeFlagOptions}" width="${form_MERGE_FLAG_W}" disabled="${form_MERGE_FLAG_D}" readOnly="${form_MERGE_FLAG_RO}" required="${form_MERGE_FLAG_R}" placeHolder="" maskType="${form_MERGE_FLAG_MT}" />
						</e:field>
					</e:row>
				</c:otherwise>
				</c:choose>
		</e:searchPanel>
		
		<e:buttonBar id="buttonBar" align="right" width="100%">
			<%-- 계약담당자 변경 --%>
			<e:text style="color: blue;font-weight: bold;">■ 계약담당자 : </e:text>
			<e:inputHidden id="CHNG_USER_ID" name="CHNG_USER_ID" />
			<e:search id="CHNG_USER_NM" name="CHNG_USER_NM" value="" width="140" maxLength="${form_CHNG_USER_NM_M}" onIconClick="getDrafter" disabled="${form_CHNG_USER_NM_D}" readOnly="${form_CHNG_USER_NM_RO}" required="${form_CHNG_USER_NM_R}" />
			<e:button id="doChangeContUser" name="doChangeContUser" label="${doChangeContUser_N}" onClick="doChangeContUser" disabled="${doChangeContUser_D}" visible="${doChangeContUser_V}" align="left" style="padding-left: 3px;"/>
			
			<%-- 계약체결현황, 위수탁 체결현황에서 강제종결 활성화 --%>
			<c:if test="${fn:substring(param.TYPE, 0, 1) eq 'B' or fn:substring(param.TYPE, 0, 1) eq 'D'}">
				<e:text style="color: blue;font-weight: bold;">■ 강제종결일자 : </e:text>
				<e:inputDate id="CONT_CLOSE_DATE" name="CONT_CLOSE_DATE" value="" width="${inputDateWidth}" datePicker="true" required="${form_CONT_CLOSE_DATE_R}" disabled="${form_CONT_CLOSE_DATE_D}" readOnly="${form_CONT_CLOSE_DATE_RO}" />
				<e:button id="doFinish" name="doFinish" label="${doFinish_N}" onClick="doFinish" disabled="${doFinish_D}" visible="${doFinish_V}" align="left" style="padding-left: 3px;"/>
			</c:if>
			
			<e:button id="doSearch" name="doSearch" icon="search" label="${doSearch_N }" disabled="${doSearch_D }" onClick="doSearch" />
			<!-- 계약중단 : 계약완료되지 않은 건(type=A, C)에 대한 중단 -->
			<e:button id="doStop" name="doStop" label="${doStop_N}" onClick="doStop" disabled="${doStop_D}" visible="${doStop_V}"/>
			<!-- 계약변경 : 계약완료(type=B, D)된 건에 대한 계약변경 -->
			<e:button id="doChangeCont" name="doChangeCont" label="${doChangeCont_N}" onClick="doChangeCont" disabled="${doChangeCont_D}" visible="${doChangeCont_V}"/>
			
			<!-- 로그인한 사용자가 농협정보 직원인 경우 ERP 전송버튼 활성화(type=B, D) -->
			<c:if test="${ses.companyCd eq erpCustCd}">
				<e:button id="doSendErp" name="doSendErp" label="${doSendErp_N}" onClick="doSendErp" disabled="${doSendErp_D}" visible="${doSendErp_V}"/>
			</c:if>
			
			<!-- 농협중앙회 IT전략본부(C00009)의 업무담당자권한(BR900) : IT포탈계약서전송 버튼 활성화(type=B, D) -->
			<e:button id="doSendITPortal" name="doSendITPortal" label="${doSendITPortal_N}" onClick="doSendITPortal" disabled="${doSendITPortal_D}" visible="${doSendITPortal_V}"/>
			<e:button id="doPrint" name="doPrint" label="${doPrint_N}" onClick="doPrint" disabled="${doPrint_D}" visible="${doPrint_V}"/>
			
			<!-- 발주사 다건전자서명 추가 -->
			<!-- 임시 -->
			<c:if test="${fn:substring(param.TYPE, 0, 1) eq 'C' and ses.corpType eq '5'}">
				<e:text style="color: blue;font-weight: bold;">■ 다건전자서명 인증서 선택 : </e:text>
				<e:select id="CERT_TYPE" name="CERT_TYPE" value="" options="${certTypeOptions}" width="140" disabled="${form_CERT_TYPE_D}" readOnly="${form_CERT_TYPE_RO}" required="${form_CERT_TYPE_R}" placeHolder="" maskType="${form_CERT_TYPE_MT}" />
				<e:button id="doCustMultiSign" name="doCustMultiSign" label="${doCustMultiSign_N}" onClick="doCustMultiSign" disabled="${doCustMultiSign_D}" visible="${doCustMultiSign_V}" align="left" style="padding-left: 3px;" />
			</c:if>		
		</e:buttonBar>
		<e:gridPanel id="grid" name="grid" gridType="${_gridType}" width="100%" height="fit"/>
		
		<%-- 2021.08.19 추가 --%>
		<%-- 품목 정보 : 단일계약 계약체결진행현황(type=A), 단일계약 계약체결현황(type=B)에서만 출력 --%>
		<c:if test="${fn:substring(param.TYPE, 0, 1) eq 'A' or fn:substring(param.TYPE, 0, 1) eq 'B'}">
	        <e:buttonBar id="itemBtnBar" align="right" width="100%" title="품목현황" >
	        	<e:button id="doSave" name="doSave" label="${doSave_N}" onClick="doSave" disabled="${doSave_D}" visible="${doSave_V}"/>
	        </e:buttonBar>
			<e:gridPanel id="gridI" name="gridI" gridType="${_gridType}" width="100%" height="250px" />
		</c:if>
		
		<form id='reqForm' name='reqForm' method='post' action="/MagicLine4Web/ML4Web/jcaosCheck.jsp">
			<input type="hidden" id="signData" name="signData" value=""/>
			<input type="hidden" id="signedData" name="signedData"/>
			<input type="hidden" id="vidRandom" name="vidRandom"/>
			<input type="hidden" id="vidType" name="vidType" value="client"/>
			<input type="hidden" id="idn" name="idn" value="${ses.irsNum}"/>
			<input type="hidden" id="useCard" name="useCard" value=""/>
		</form>

		<div id="dscertContainer">
			<iframe id="dscert" name="dscert" src="" width="100%" height="100%" frameborder="0" allowTransparency="true" style="position:fixed;z-index:100010;top:0px;left:0px;width:100%;height:100%;"></iframe>
		</div>
	</e:window>
</e:ui>
