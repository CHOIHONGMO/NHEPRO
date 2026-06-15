<%@ page import="com.st_ones.everf.serverside.config.PropertiesManager" %>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ include file="/WEB-INF/views/common/ozUrlInfo.jsp" %>

<%
    String ozSchedulerIp = PropertiesManager.getString("oz.scheduler.ip");
    String ozSchedulerPort = PropertiesManager.getString("oz.scheduler.port");
    String ksfcUrl = PropertiesManager.getString("eversrm.ksfc.url");
    String sgicUrl = PropertiesManager.getString("eversrm.sgic.url");
%>

<%-- 계약서를 수정할 수 있는 상태변수(저장 전, 협력사서명대기(4210) --%>
<c:set var="editableStatus" value="${empty form.PROGRESS_CD or form.PROGRESS_CD eq '4210'}" />

<c:set var="ozExportUrl" value="<%=ozExportUrl%>" />
<c:set var="ozUrl" value="<%=ozUrl%>" />
<c:set var="ozServer" value="<%=ozServer%>" />
<c:set var="ozSchedulerIp" value="<%=ozSchedulerIp%>" />
<c:set var="ozSchedulerPort" value="<%=ozSchedulerPort%>" />
<c:set var="ksfcUrl" value="<%=ksfcUrl%>" />
<c:set var="sgicUrl" value="<%=sgicUrl%>" />

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">

    <script type="text/javascript" src="/MagicLine4Web/ML4Web/js/ext/jquery.blockUI.js"></script>
    <!-- ML4WEB JS -->
    <script type="text/javascript" src="/MagicLine4Web/ML4Web/js/ext/ML_Config.js"></script>

    <style type="text/css">
        #ui-tabs-2 > .e-buttonbar { margin: auto; }
        .e-buttonbar { margin: auto; }
        .e-button { margin: auto; }
        .contract_contents_div {
            box-shadow: 5px 5px 20px #777;
            width: 700px;
            min-height: 990px;
            overflow-y: auto;
            background-color: white;
            border: 1px solid #ccc;
            padding: 15px;
            margin: 3px auto 20px;
            word-wrap: break-word;
            word-break: keep-all;
            /*text-align: justify;*/
        }
        .plupload_file_name_wrapper {
            line-height: 0 !important;
        }

    </style>

    <!-- 전자인증 모듈 기본으로 설정
    <script src="/toolkit/tradesign/js/nxts/nxts.min.js"></script>
    <script src="/toolkit/tradesign/js/nxts/nxtspki_config.js"></script>
    <script src="/toolkit/tradesign/js/nxts/nxtspki.js"></script>
    <script src="/toolkit/tradesign/js/demo.js"></script>
    -->

    <script type="text/javascript">

        var gridECPC_HD, gridECPC, gridECMT, gridECCM;
        var baseUrl = "/nhepro/SCTR/SCTR0011";
        var localServerFlag = "${localServerFlag}";

        function init() {
        	
        	gridECPC_HD = EVF.C("gridECPC_HD");   // 계약보증 정보
            gridECPC_HD.setProperty("shrinkToFit", ${shrinkToFit});
            gridECPC_HD.setProperty("rowNumbers", ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
            gridECPC_HD.setProperty("sortable", ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
            gridECPC_HD.setProperty("panelVisible", ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            gridECPC_HD.setProperty("enterToNextRow", ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            gridECPC_HD.setProperty("acceptZero", ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            gridECPC_HD.setProperty("multiSelect", true);					// [선택] 컬럼의 사용여부를 지정한다. [true/false]
            gridECPC_HD.setProperty("singleSelect", ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]

            gridECPC = EVF.C("gridECPC");   // 계약보증 정보
            gridECPC.setProperty("shrinkToFit", ${shrinkToFit});
            gridECPC.setProperty("rowNumbers", ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
            gridECPC.setProperty("sortable", ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
            gridECPC.setProperty("panelVisible", ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            gridECPC.setProperty("enterToNextRow", ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            gridECPC.setProperty("acceptZero", ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            gridECPC.setProperty("multiSelect", true);					// [선택] 컬럼의 사용여부를 지정한다. [true/false]
            gridECPC.setProperty("singleSelect", ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]

            gridECMT = EVF.C("gridECMT");   // 품목정보
            gridECMT.setProperty("shrinkToFit", ${shrinkToFit});
            gridECMT.setProperty("rowNumbers", ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
            gridECMT.setProperty("sortable", ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
            gridECMT.setProperty("panelVisible", ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            gridECMT.setProperty("enterToNextRow", ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            gridECMT.setProperty("acceptZero", ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            gridECMT.setProperty("multiSelect", true);					// [선택] 컬럼의 사용여부를 지정한다. [true/false]
            gridECMT.setProperty("singleSelect", ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]

            gridECCM = EVF.C("gridECCM");   // 품목정보
            gridECCM.setProperty("shrinkToFit", ${shrinkToFit});
            gridECCM.setProperty("rowNumbers", ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
            gridECCM.setProperty("sortable", ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
            gridECCM.setProperty("panelVisible", ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            gridECCM.setProperty("enterToNextRow", ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            gridECCM.setProperty("acceptZero", ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            gridECCM.setProperty("multiSelect", true);					// [선택] 컬럼의 사용여부를 지정한다. [true/false]
            gridECCM.setProperty("singleSelect", ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]

            gridECPC_HD.cellClickEvent(function(rowIdx, celName, value) {
                var param;
                var url;
                var guar_amt    = gridECPC_HD.getCellValue(rowIdx, "GUAR_AMT");
                var guar_type2  = gridECPC_HD.getCellValue(rowIdx, "GUAR_TYPE2");
	            var guaranteer  = gridECPC_HD.getCellValue(rowIdx, "GUARANTEER");
	           	var guar_num    = gridECPC_HD.getCellValue(rowIdx, "GUAR_NUM");
	            var insu_status = gridECPC_HD.getCellValue(rowIdx, "INSU_STATUS");
	            
                switch (celName) {
                    case "GUAR_APP":
                    	
                    	if (gridECPC_HD.getSelRowCount() > 1) { return EVF.alert("보증신청은 한건 씩 신청 가능합니다."); }
                    	
                    	var contCnt = EVF.V("CONT_CNT");
                    	var contReqCd = EVF.C("CONT_REQ_CD").getValue();
                    	
						if (guar_amt == 0 || guar_amt == '') {
	                    	return EVF.alert("보증 신청을 하실 수  없습니다.");
	            		} else {
	            			// 1차수 이상이고 계약구분이 변경인 경우 전자보증 신청은 안되도록
	            			//if (contCnt != "1" && contReqCd == "20") {
	            			//	return EVF.alert("변경계약은 전자보증 신청을 하실 수 없습니다.");	
	            			//}
	            			
	            			if (guar_type2 == "") {
	                            return EVF.alert("보증방법을 선택하여 주시기 바랍니다.");
	                        }
	            			
	                    	if (guar_type2 == "20" && guaranteer == "") {
	                    		return EVF.alert("신청 하실 보증기관을 선택하여 주시기 바랍니다.");
							}
	                    	
		                    if (guar_type2 == "20") { 
		                    	if (guaranteer == "20") { //소프트웨어공제조합일경우 그리드 수정 가능여부 제어
		                    		if ( guar_num == null || guar_num == "" ) { //보증번호 발행 전
		                    			if (insu_status == "TA") { //보증신청중
		                    				return EVF.alert("현재 신청중입니다. 보증 신청을 하실 수 없습니다.");
		                    		    } else {
		                    		    	gridECPC_HD.checkRow(rowIdx, true);
		                                    guar_approval(rowIdx);
		                    		    }
		                    		} else {																										 //보증번호 발행 후 
				                    	if (insu_status == "DE") {  //보증번호 발행 전/후 취소요청중
				                    		return EVF.alert("고객사에 보증 취소요청중 상태입니다.\n보증 신청을 하실 수 없습니다.");
				                    	} else if(insu_status == "SA") {
				                    		return EVF.alert("보증 신청완료 상태입니다.\n보증 신청을 하실 수 없습니다.");
				                    	} 
		                    		}
		                    	} else if (guaranteer == "10") { //서울보증
		                    		return EVF.alert("서울보증보험은 준비중입니다.");
	                    			/* if ( guar_num == null || guar_num == "" ) { //보증번호 발행 전
		                    			if (insu_status == "TA") { //보증신청중
		                    				return EVF.alert("현재 신청중입니다. 보증 신청을 하실 수 없습니다.");
		                    		    } else {
		                    		    	gridECPC_HD.checkRow(rowIdx, true);
		                                    guar_approval(rowIdx);
		                    		    }
		                    		} else {																										 //보증번호 발행 후 
				                    	if (insu_status == "DE") {  //보증번호 발행 전/후 취소요청중
				                    		return EVF.alert("고객사에 보증 취소요청중 상태입니다.\n보증 신청을 하실 수 없습니다.");
				                    	} else if(insu_status == "SA") {
				                    		return EVF.alert("보증 신청완료 상태입니다.\n보증 신청을 하실 수 없습니다.");
				                    	} 
		                    		} */
		                    	}
		                    } else {
		                    	return EVF.alert("보증방법이 전자보증이고 보증기관이 서울보증보험, 소프트웨어공제조합이\n아닌 경우 보증신청을 하실 수 없습니다.");
							}
	            		}

                        break;
                    case "GUAR_APP_CANCEL":
                    	
                    	if (gridECPC_HD.getSelRowCount() > 1) { return EVF.alert("보증취소는 한건 씩 취소 가능합니다."); }
                    	
                    	if("${form.PROGRESS_CD}" == "4300") {
                    		return EVF.alert("계약체결 완료 이후에는 전자보증 취소를 하실 수 없습니다.");
                    	}
                    	
                    	if (guar_amt == 0 || guar_amt == '') {
	                    	return EVF.alert("보증 취소를 하실 수 없습니다.");
	            		} else {
		                    if (guar_type2 == "20") { 
		                    	if (guaranteer == "20") { //소프트웨어공제조합일경우 그리드 수정 가능여부 제어
		                    		if ( guar_num == null || guar_num == "" ) { //보증번호 발행 전
		                    			if (insu_status == "TA") { //보증신청중
		                    				gridECPC_HD.checkRow(rowIdx, true);
		                            		guar_cancel(rowIdx);
		                    		    } else {
		                    		    	return EVF.alert("보증 취소를 할 수 없는 상태입니다.");
		                    		    }
		                    		} else {																										 
				                    	if (insu_status == "DE") {  //보증번호 발행 전/후 취소요청중
				                    		return EVF.alert("고객사에 보증 취소요청중 상태입니다.\n보증 취소를 하실 수 없습니다.");
				                    	} else if (insu_status == "SA") {
				                    		gridECPC_HD.checkRow(rowIdx, true);
		                            		guar_delete(rowIdx);
				                    	}
		                    		}
		                    	} else if (guaranteer == "10") { //서울보증
		                    		return EVF.alert("서울보증보험은 준비중입니다.");
	                    			/* if ( guar_num == null || guar_num == "" ) { //보증번호 발행 전
		                    			if (insu_status == "TA") { //보증신청중
		                    				gridECPC_HD.checkRow(rowIdx, true);
		                            		guar_cancel(rowIdx);
		                    		    } else {
		                    		    	return EVF.alert("보증 취소를 할 수 없는 상태입니다.");
		                    		    }
		                    		} else {																										 
				                    	if (insu_status == "DE") {  //보증번호 발행 전/후 취소요청중
				                    		return EVF.alert("고객사에 보증 취소요청중 상태입니다.\n보증 취소를 하실 수 없습니다.");
				                    	} else if (insu_status == "SA") {
				                    		gridECPC_HD.checkRow(rowIdx, true);
		                            		guar_delete(rowIdx);
				                    	}
		                    		} */
		                    	}
		                    } else {
		                    	return EVF.alert("보증방법이 전자보증이고 보증기관이 서울보증보험, 소프트웨어공제조합이\n아닌 경우 보증취소를 하실 수 없습니다.");
							}
	            		}
                    	
                    	break;
                    	
                    case "GUAR_NUM":
                    	if(value != "") {
                    		if (guaranteer == "10") {
	                    		var url = "${sgicUrl}";
	                    		window.open(url);
                    		} else if (guaranteer == "20") {
	                    		var url = "${ksfcUrl}";
	                    		window.open(url);
                    		}
                    	}
                    	break;
                    	
                    case "ATT_FILE_CNT":

                        if (guar_amt == '' || guar_amt == 0) return;

                        if (guar_type2 == "") {
                            return EVF.alert("보증방법을 선택하여 주시기 바랍니다.");
                        }

                    	if (guar_type2 == "10" && guaranteer == "") {
                    		return EVF.alert("보증기관을 선택하여 주시기 바랍니다.");
						}

                        if (guar_type2 == "20" && (guaranteer == "10" || guaranteer == "20")) {
                            return EVF.alert("전자보증의 보증기관이 서울보증보험, 소프트웨어공제조합인 경우 파일첨부를 하실 수 없습니다.");
                        }

                        param = {
                            bizType: 'EC',
                            attFileNum: gridECPC_HD.getCellValue(rowIdx, 'ATT_FILE_NUM'),
                            detailView: ${(!param.detailView or editableStatus) ? false : true},
                            rowIdx: rowIdx,
                            callBackFunction: 'setFileAttachCnt',
                            fileExtension: '*'
                        };

                        everPopup.fileAttachPopup(param);
                        break;

                    case "DI_ATT_FILE_CNT":
                        param = {
                            bizType: 'EC',
                            attFileNum: gridECPC_HD.getCellValue(rowIdx, 'DI_ATT_FILE_NUM'),
                            detailView: ${(!param.detailView or editableStatus) ? false : true},
                            rowIdx: rowIdx,
                            callBackFunction: 'setDiFileAttachCnt',
                            fileExtension: '*'
                        };

                        everPopup.fileAttachPopup(param);
                        break;

                    case "RMK":
                        if(value != "") {
                            param = {
                                title: "비고",
                                message: value,
                                rowIdx: rowIdx,
                                detailView: true
                            };

                            url = "/common/popup/common_text_input/view.so";
                            everPopup.openModalPopup(url, 500, 300, param);
                        }
                        break;
                    
                    case "GUAR_CANCEL_RMK":
                        if(value != "") {
                            param = {
                                title: "보증취소사유",
                                message: value,
                                detailView: true
                            };

                            everPopup.commonTextInput(param);
                        }
                        break;
                    
                    case "GUAR_REJECT_RMK":
                        if(value != "") {
                            param = {
                                title: "보증취소사유",
                                message: value,
                                detailView: true
                            };

                            everPopup.commonTextInput(param);
                        }
                        break;    
                }

            });

            gridECPC_HD.cellChangeEvent(function(rowIdx, colIdx, iRow, iCol, value) {
                switch (colIdx) {
                case "GUAR_TYPE2":
					if(value == "10") {
						gridECPC_HD.setCellRequired(rowIdx, "GUARANTEER", true);
						gridECPC_HD.setCellReadOnly(rowIdx, "GUARANTEER", false);
						gridECPC_HD.setCellValue(rowIdx, "GUARANTEER", "");
					} else if(value == "20") {
						gridECPC_HD.setCellRequired(rowIdx, "GUARANTEER", true);
						gridECPC_HD.setCellReadOnly(rowIdx, "GUARANTEER", true);
						gridECPC_HD.setCellValue(rowIdx, 'GUARANTEER', "20");
					} else {
						gridECPC_HD.setCellRequired(rowIdx, "GUARANTEER", false);
						gridECPC_HD.setCellReadOnly(rowIdx, "GUARANTEER", true);
						gridECPC_HD.setCellEdgeColor(rowIdx, "GUARANTEER", false);
						gridECPC_HD.setCellValue(rowIdx, "GUARANTEER", "");
					}
					
					gridECPC_HD.checkRow(rowIdx, false);

	                break;

                case "GUARANTEER":
                    var guar_type2 = gridECPC_HD.getCellValue(rowIdx, "GUAR_TYPE2");
					
                    if (guar_type2 == "20") {
                        if (!(value == "10" || value == "20")) {
                            gridECPC_HD.setCellValue(rowIdx, colIdx, "");
                            return EVF.alert("보증방법이 전자보증인 경우 서울보증보험/소프트웨어공제조합만 선택하실 수 있습니다.");
                        }
                        
                        if(localServerFlag != "Y") {
	                        if (value == "10") {
	                            gridECPC_HD.setCellValue(rowIdx, colIdx, "");
	                            return EVF.alert("서울보증보험은 준비중입니다.");
	                        }
                        }
                    }
					
                    gridECPC_HD.checkRow(rowIdx, false);
                    
                    break;
                }
            });

            gridECPC.cellClickEvent(function(rowIdx, celName, value) {
                var param;
                var url;
                var guar_amt    = gridECPC.getCellValue(rowIdx, "GUAR_AMT");
                var guar_type2  = gridECPC.getCellValue(rowIdx, "GUAR_TYPE2");
                var guaranteer  = gridECPC.getCellValue(rowIdx, "GUARANTEER");
                var guar_num    = gridECPC.getCellValue(rowIdx, "GUAR_NUM");
				var insu_status = gridECPC.getCellValue(rowIdx, "INSU_STATUS");
				var ecpcGuarAttFile = gridECPC.getCellValue(rowIdx, "ECPC_GUAR_ATT_FILE");
				
                switch (celName) {
                    case "GUAR_APP":
						
                    	if (gridECPC.getSelRowCount() > 1) { return EVF.alert("보증신청은 한건 씩 신청 가능합니다."); }
                    	
                    	var contCnt = EVF.V("CONT_CNT");
                    	var contReqCd = EVF.C("CONT_REQ_CD").getValue();
						                    	
						if (guar_amt == 0 || guar_amt == '') {
	                    	return EVF.alert("보증 신청을 하실 수 없습니다.");
	            		} else {
	            			// 1차수 이상이고 계약구분이 변경인 경우 전자보증 신청은 안되도록
	            			//if (contCnt != "1" && contReqCd == "20") {
	            			//	return EVF.alert("변경계약은 전자보증 신청을 하실 수 없습니다.");	
	            			//}
	            			
	            			if (guar_type2 == "") {
	                            return EVF.alert("보증방법을 선택하여 주시기 바랍니다.");
	                        }

	                    	if (guar_type2 == "20" && guaranteer == "") {
	                    		return EVF.alert("신청 하실 보증기관을 선택하여 주시기 바랍니다.");
							}
	                    	
		                    if (guar_type2 == "20") { 
		                    	
		                    	if (guaranteer == "20") { //소프트웨어공제조합일경우 그리드 수정 가능여부 제어
		                    		if ( guar_num == null || guar_num == "" ) { //보증번호 발행 전
		                    			if (insu_status == "TA") { //보증신청중
		                    				return EVF.alert("현재 신청중입니다. 보증 신청을 하실 수 없습니다.");
		                    		    } else {
		                    		    	gridECPC.checkRow(rowIdx, true);
		                    		    	guar_approval2(rowIdx);
		                    		    }
		                    		} else {																										 //보증번호 발행 후 
				                    	if (insu_status == "DE") {  //보증번호 발행 전/후 취소요청중
				                    		return EVF.alert("고객사에 보증 취소요청중 상태입니다.\n보증 신청을 하실 수 없습니다.");
				                    	} else if(insu_status == "SA") {
				                    		return EVF.alert("보증 신청완료 상태입니다.\n보증 신청을 하실 수 없습니다.");
				                    	} 
		                    		}
		                    	} else if (guaranteer == "10") { //서울보증
		                    		return EVF.alert("서울보증보험은 준비중입니다.");
		                    		/* if ( guar_num == null || guar_num == "" ) { //보증번호 발행 전
		                    			if (insu_status == "TA") { //보증신청중
		                    				return EVF.alert("현재 신청중입니다. 보증 신청을 하실 수 없습니다.");
		                    		    } else {
		                    		    	gridECPC.checkRow(rowIdx, true);
		                    		    	guar_approval2(rowIdx);
		                    		    }
		                    		} else {																										 //보증번호 발행 후 
				                    	if (insu_status == "DE") {  //보증번호 발행 전/후 취소요청중
				                    		return EVF.alert("고객사에 보증 취소요청중 상태입니다.\n보증 신청을 하실 수 없습니다.");
				                    	} else if(insu_status == "SA") {
				                    		return EVF.alert("보증 신청완료 상태입니다.\n보증 신청을 하실 수 없습니다.");
				                    	} 
		                    		} */
		                    	}
			                    
		                    } else {
		                    	return EVF.alert("보증방법이 전자보증이고 보증기관이 서울보증보험, 소프트웨어공제조합이\n아닌 경우 보증신청을 하실 수 없습니다.");
							}
	            		}

                        break;
                        
                    case "GUAR_APP_CANCEL":
                    	
                    	if (gridECPC.getSelRowCount() > 1) { return EVF.alert("보증취소는 한건 씩 취소 가능합니다."); }
                    	
                    	if (guar_amt == 0 || guar_amt == '') {
	                    	return EVF.alert("보증 취소를 하실 수 없습니다.");
	            		} else {
		                    if (guar_type2 == "20") { 
		                    	if (guaranteer == "20") { //소프트웨어공제조합일경우 그리드 수정 가능여부 제어
		                    		if ( guar_num == null || guar_num == "" ) { //보증번호 발행 전
		                    			if (insu_status == "TA") { //보증신청중
		                    				gridECPC.checkRow(rowIdx, true);
		                    				guar_cancel2(rowIdx);
		                    			//} else if (insu_status == "DD") {  //보증번호 발행 전 취소요청중
		                    			//	return EVF.alert("현재 취소중입니다. 보증 취소를 하실 수 없습니다.");
		                    		    } else {
		                    		    	return EVF.alert("보증 취소를 할 수 없는 상태입니다.");
		                    		    }
		                    		} else {																										 
				                    	if (insu_status == "DE") {  //보증번호 발행 전/후 취소요청중
				                    		return EVF.alert("고객사에 보증 취소요청중 상태입니다.\n보증 취소를 하실 수 없습니다.");
				                    	} else if (insu_status == "SA") {
				                    		gridECPC.checkRow(rowIdx, true);
		                            		guar_delete2(rowIdx);
				                    	}
		                    		}
		                    	} else if (guaranteer == "10") { //서울보증
		                    		return EVF.alert("서울보증보험은 준비중입니다.");
		                    		/* if ( guar_num == null || guar_num == "" ) { //보증번호 발행 전
		                    			if (insu_status == "TA") { //보증신청중
		                    				gridECPC.checkRow(rowIdx, true);
		                    				guar_cancel2(rowIdx);
		                    		    } else {
		                    		    	return EVF.alert("보증 취소를 할 수 없는 상태입니다.");
		                    		    }
		                    		} else {																										 
				                    	if (insu_status == "DE") {  //보증번호 발행 전/후 취소요청중
				                    		return EVF.alert("고객사에 보증 취소요청중 상태입니다.\n보증 취소를 하실 수 없습니다.");
				                    	} else if (insu_status == "SA") {
				                    		gridECPC.checkRow(rowIdx, true);
		                            		guar_delete2(rowIdx);
				                    	}
		                    		} */
		                    	}
			                    
		                    } else {
		                    	return EVF.alert("보증방법이 전자보증이고 보증기관이 서울보증보험, 소프트웨어공제조합이\n아닌 경우 보증취소를 하실 수 없습니다.");
							}
	            		}
                    	
                    	break;    
                    	
                    case "GUAR_NUM":
                    	if(value != "") {
                    		if (guaranteer == "10") {
	                    		var url = "${sgicUrl}";
	                    		window.open(url);
                    		} else if (guaranteer == "20") {
	                    		var url = "${ksfcUrl}";
	                    		window.open(url);
                    		}
                    	}
                    	break;    
                    	
                    case "ATT_FILE_CNT":
						
                    	if (guar_amt == '' || guar_amt == 0) return;
						
                    	if (guar_type2 == "30" || guar_type2 == "90") return;
                    	
                    	if (guar_type2 == "") {
                            return EVF.alert("보증방법을 선택하여 주시기 바랍니다.");
                        }

                    	if (guar_type2 == "10" && guaranteer == "") {
                    		return EVF.alert("보증기관을 선택하여 주시기 바랍니다.");
						}

                        if (guar_type2 == "20" && (guaranteer == "10" || guaranteer == "20")) {
                            return EVF.alert("보증기관이 서울보증보험, 소프트웨어공제조합인 경우 파일첨부를 하실 수 없습니다.");
                        }
						
                        if("${form.PROGRESS_CD}" == "4300") {
                        	
                        	var detailView = "false";
                        	
                        	if(ecpcGuarAttFile== 'Y'){
                        		detailView = true;
                        	}
                        	
	                        if(gridECPC.getCellValue(rowIdx, "GUAR_TYPE") != "") {
	                            param = {
	                                bizType: 'EC',
	                                attFileNum: gridECPC.getCellValue(rowIdx, 'ATT_FILE_NUM'),
	                                detailView: detailView,
	                                rowIdx: rowIdx,
	                                callBackFunction: 'setFileAttachCnt2',
	                                fileExtension: '*'
	                            };
	                            everPopup.fileAttachPopup(param);
	                        } else {
	                            return EVF.alert("파일 첨부를 하실 수 없습니다.");
	                        }
                        } else {
                        	if(gridECPC.getCellValue(rowIdx, "GUAR_TYPE") != "") {
                                param = {
                                    bizType: 'EC',
                                    attFileNum: gridECPC.getCellValue(rowIdx, 'ATT_FILE_NUM'),
                                    detailView: ${(!param.detailView or editableStatus) ? false : true},
                                    rowIdx: rowIdx,
                                    callBackFunction: 'setFileAttachCnt2',
                                    fileExtension: '*'
                                };
                                everPopup.fileAttachPopup(param);
                            } else {
                                return EVF.alert("파일 첨부를 하실 수 없습니다.");
                            }
                        }
                        break;

                    case "RMK":
                        if(value != "") {
                            param = {
                                title: "비고",
                                message: value,
                                rowIdx: rowIdx,
                                detailView: true
                            };

                            url = "/common/popup/common_text_input/view.so";
                            everPopup.openModalPopup(url, 500, 300, param);
                        }
                        break;
                    
                    case "GUAR_CANCEL_RMK":
                        if(value != "") {
                            param = {
                                title: "보증취소사유",
                                message: value,
                                detailView: true
                            };

                            everPopup.commonTextInput(param);
                        }
                        break;
                        
                    case "GUAR_REJECT_RMK":
                        if(value != "") {
                            param = {
                                title: "보증취소사유",
                                message: value,
                                detailView: true
                            };

                            everPopup.commonTextInput(param);
                        }
                        break;    
                }

            });

            gridECPC.cellChangeEvent(function(rowIdx, colIdx, iRow, iCol, value) {
                switch (colIdx) {
	                case "GUAR_TYPE2":
	                	
	                	var progressCd = "${form.PROGRESS_CD}"
	                    	
                    	if(progressCd != '4300') {
                    		gridECPC.setCellRequired(rowIdx, "GUAR_TYPE2", false);
                    		gridECPC.setCellEdgeColor(rowIdx, "GUAR_TYPE2", false);
            		        gridECPC.setCellReadOnly(rowIdx, "GUAR_TYPE2", false);
                    		gridECPC.setCellValue(rowIdx, "GUAR_TYPE2", "");
                    		gridECPC.checkRow(rowIdx, false);
                    		return EVF.alert("선급보증 및 하자보증 증권은 추후 대금청구시 제출합니다.");
                    	}
	                	
		                if(value == "10") {
		                	gridECPC.setCellRequired(rowIdx, "GUARANTEER", true);
		                	gridECPC.setCellReadOnly(rowIdx, "GUARANTEER", false);
		                	gridECPC.setCellValue(rowIdx, "GUARANTEER", "");
						} else if(value == "20") {
							gridECPC.setCellRequired(rowIdx, "GUARANTEER", true);
							gridECPC.setCellReadOnly(rowIdx, "GUARANTEER", true);
							gridECPC.setCellValue(rowIdx, 'GUARANTEER', "20");
						} else {
							gridECPC.setCellRequired(rowIdx, "GUARANTEER", false);
							gridECPC.setCellReadOnly(rowIdx, "GUARANTEER", true);
							gridECPC.setCellEdgeColor(rowIdx, "GUARANTEER", false);
							gridECPC.setCellValue(rowIdx, "GUARANTEER", "");
						}
						
		                if (progressCd != "4300") {
		                	gridECPC.checkRow(rowIdx, false);
		                }
		                
		                break;

                    case "GUARANTEER":
                    	var progressCd = "${form.PROGRESS_CD}"
                        var guar_type2 = gridECPC.getCellValue(rowIdx, "GUAR_TYPE2");
                        
                        if (guar_type2 == "20") {
                            if (!(value == "10" || value == "20")) {
                                gridECPC.setCellValue(rowIdx, colIdx, "");
                                return EVF.alert("보증방법이 전자보증인 경우 서울보증보험/소프트웨어공제조합만 선택하실 수 있습니다.");
                            }
                            
                            if(localServerFlag != "Y") {
    	                        if (value == "10") {
    	                        	gridECPC.setCellValue(rowIdx, colIdx, "");
    	                            return EVF.alert("서울보증보험은 준비중입니다.");
    	                        }
                            }
                        }
                        
                        if (progressCd != "4300") {
		                	gridECPC.checkRow(rowIdx, false);
		                }

                        break;
                }
            });

            gridECPC_HD.setColGroup([
                {
                    "groupName": "계약보증",
                    "columns": ["GUAR_TYPE", "GUAR_PERCENT", "GUAR_AMT", "GUAR_TYPE2", "GUARANTEER", "GUAR_REQ_NUM_CNT", "GUAR_NUM", "ATT_FILE_CNT", "GUAR_APP", "GUAR_APP_CANCEL", "GUAR_CANCEL_RMK", "GUAR_REJECT_RMK"]
                }
            ], 50);

            gridECPC.setColGroup([
                {
                    "groupName": "보증정보",
                    "columns": ["GUAR_TYPE", "GUAR_PERCENT", "GUAR_QT", "GUAR_AMT", "GUAR_TYPE2", "GUARANTEER", "GUAR_REQ_NUM_CNT", "GUAR_NUM", "ATT_FILE_CNT", "GUAR_APP", "GUAR_APP_CANCEL", "GUAR_CANCEL_RMK", "GUAR_REJECT_RMK"]
                }
            ], 50);
			
            doSearchECPC_HD();
            doSearchECPC();
            doSearchECMT();
            doSearchECCM();
            defaultDisplay();
            setLinkStyle(); 
            
        }
		
        function setLinkStyle() {
			gridECPC_HD.setColFontColor("GUAR_NUM", "#FF0000");
			gridECPC.setColFontColor("GUAR_NUM", "#FF0000");
        }
        
        function setFileAttachCnt(rowIdx, fileId, fileCnt) {
            gridECPC_HD.setCellValue(rowIdx, 'ATT_FILE_CNT', fileCnt);
            gridECPC_HD.setCellValue(rowIdx, 'ATT_FILE_NUM', fileId);
        }

        function setFileAttachCnt2(rowIdx, fileId, fileCnt) {
            gridECPC.setCellValue(rowIdx, 'ATT_FILE_CNT', fileCnt);
            gridECPC.setCellValue(rowIdx, 'ATT_FILE_NUM', fileId);
        }

        function setDiFileAttachCnt(rowIdx, fileId, fileCnt) {
            gridECPC_HD.setCellValue(rowIdx, 'DI_ATT_FILE_CNT', fileCnt);
            gridECPC_HD.setCellValue(rowIdx, 'DI_ATT_FILE_NUM', fileId);
        }

        function defaultDisplay() {
            gridECPC_HD.setColIconify("RMK", "RMK", "detail", false);
            gridECPC.setColIconify("RMK", "RMK", "detail", false);

            // 차액보증금이 존재하지 않는 경우 그리드 HIDE
            if ("${guarFlag}" == 0) {
                gridECPC_HD.hideCol("DI_GUAR_TYPE", true);
                gridECPC_HD.hideCol("DI_GUAR_AMT", true);
                gridECPC_HD.hideCol("DI_ATT_FILE_CNT", true);
            } else {
                gridECPC_HD.setColGroup([
                    {
                        "groupName": "차액보증",
                        "columns": ["DI_GUAR_TYPE","DI_GUAR_AMT","DI_ATT_FILE_CNT"]
                    }
                ], 50);
            }
        }
        
        function doSearchECPC_HD() {
            var store = new EVF.Store();
            store.setGrid([ gridECPC_HD ]);
            store.load(baseUrl + '/sctr0011_doSearchECPC_HD.so', function() {
            	
            	gridECPC_HD.setColIconify("GUAR_CANCEL_RMK", "GUAR_CANCEL_RMK", "comment", false);
            	gridECPC_HD.setColIconify("GUAR_REJECT_RMK", "GUAR_REJECT_RMK", "comment", false);
            	
                var allRowIdx = gridECPC_HD.getAllRowId();
                for(var i in allRowIdx) {
                    var rowIdx = allRowIdx[i];
                    if (gridECPC_HD.getCellValue(rowIdx, "GUAR_AMT") == 0 || gridECPC_HD.getCellValue(rowIdx, "GUAR_AMT") == '') {
		                gridECPC_HD.setCellRequired(rowIdx, "GUAR_TYPE2", false);
        		        gridECPC_HD.setCellEdgeColor(rowIdx, "GUAR_TYPE2", false);
                		gridECPC_HD.setCellReadOnly(rowIdx, "GUAR_TYPE2", true);

		                gridECPC_HD.setCellRequired(rowIdx, "GUARANTEER", false);
        		        gridECPC_HD.setCellEdgeColor(rowIdx, "GUARANTEER", false);
                		gridECPC_HD.setCellReadOnly(rowIdx, "GUARANTEER", true);
                		
            		} else {
                        gridECPC_HD.setCellRequired(rowIdx, "GUAR_TYPE2", true);

	                    if (gridECPC_HD.getCellValue(rowIdx, "GUAR_TYPE2") == "10") {
							gridECPC_HD.setCellRequired(rowIdx, "GUARANTEER", true);
		                    
	                    } else if(gridECPC_HD.getCellValue(rowIdx, "GUAR_TYPE2") == "20") { 
	                    	gridECPC_HD.setCellRequired(rowIdx, "GUARANTEER", true);
	                    	
	                    	if(gridECPC_HD.getCellValue(rowIdx, "GUARANTEER") == "20") { //소프트웨어공제조합일경우 그리드 수정 가능여부 제어
	                    		if(gridECPC_HD.getCellValue(rowIdx, "GUAR_NUM") == null || gridECPC_HD.getCellValue(rowIdx, "GUAR_NUM") == "") { //보증번호 발행 전
	                    			if(gridECPC_HD.getCellValue(rowIdx, "INSU_STATUS") == "TA") { //보증신청중
	                    				gridECPC_HD.setCellReadOnly(rowIdx, "GUAR_TYPE2", true);
			                    		gridECPC_HD.setCellReadOnly(rowIdx, "GUARANTEER", true);
			                    		
			                    		//gridECPC_HD.setCellReadOnly(rowIdx, "GUAR_APP", true);
										//gridECPC_HD.setCellReadOnly(rowIdx, "GUAR_APP_CANCEL", true);
										//gridECPC_HD.setCellReadOnly(rowIdx, "GUAR_REJECT_RMK", true);
										
	                    			//} else if(gridECPC_HD.getCellValue(rowIdx, "INSU_STATUS") == "DD") {  //보증번호 발행 전 취소요청중
	                    			//	gridECPC_HD.setCellReadOnly(rowIdx, "GUAR_TYPE2", true);
			                    	//	gridECPC_HD.setCellReadOnly(rowIdx, "GUARANTEER", true);
			                    		
	                    		    } else {	
	                    				gridECPC_HD.setCellReadOnly(rowIdx, "GUAR_TYPE2", false);
			                    		gridECPC_HD.setCellReadOnly(rowIdx, "GUARANTEER", false);
	                    			}
	                    		} else {																										 //보증번호 발행 후 
	                    			gridECPC_HD.setCellReadOnly(rowIdx, "GUAR_TYPE2", true);
			                    	gridECPC_HD.setCellReadOnly(rowIdx, "GUARANTEER", true);
	                    		}
	                    	} else if(gridECPC_HD.getCellValue(rowIdx, "GUARANTEER") == "10"){
	                    		if(gridECPC_HD.getCellValue(rowIdx, "GUAR_NUM") == null || gridECPC_HD.getCellValue(rowIdx, "GUAR_NUM") == "") { 
	                    			if(gridECPC_HD.getCellValue(rowIdx, "INSU_STATUS") == "TA") { 
	                    				gridECPC_HD.setCellReadOnly(rowIdx, "GUAR_TYPE2", true);
			                    		gridECPC_HD.setCellReadOnly(rowIdx, "GUARANTEER", true);
			                    		
			                    		//gridECPC_HD.setCellReadOnly(rowIdx, "GUAR_APP", true);
										//gridECPC_HD.setCellReadOnly(rowIdx, "GUAR_APP_CANCEL", true);
										//gridECPC_HD.setCellReadOnly(rowIdx, "GUAR_REJECT_RMK", true);
	                    		    } else {	
	                    				gridECPC_HD.setCellReadOnly(rowIdx, "GUAR_TYPE2", false);
			                    		gridECPC_HD.setCellReadOnly(rowIdx, "GUARANTEER", false);
	                    			}
	                    		} else {																										 
	                    			gridECPC_HD.setCellReadOnly(rowIdx, "GUAR_TYPE2", true);
			                    	gridECPC_HD.setCellReadOnly(rowIdx, "GUARANTEER", true);
	                    		}
	                    	} else {
	                    		gridECPC_HD.setCellReadOnly(rowIdx, "GUAR_TYPE2", false);
	                    		gridECPC_HD.setCellReadOnly(rowIdx, "GUARANTEER", false);
	                    	}
		                    
	                    } else {
	                    	gridECPC_HD.setCellRequired(rowIdx, "GUARANTEER", false);
		                    gridECPC_HD.setCellEdgeColor(rowIdx, "GUARANTEER", false);
		                    gridECPC_HD.setCellReadOnly(rowIdx, "GUARANTEER", true);
						}
            		}
                }
            }, false);
        }

        function doSearchECPC() {
            var store = new EVF.Store();
            store.setGrid([ gridECPC ]);
            store.load(baseUrl + '/sctr0011_doSearchECPC.so', function() {
            	
            	gridECPC.setColIconify("GUAR_CANCEL_RMK", "GUAR_CANCEL_RMK", "comment", false);
            	gridECPC.setColIconify("GUAR_REJECT_RMK", "GUAR_REJECT_RMK", "comment", false);
            	
            	var progressCd = "${form.PROGRESS_CD}";
            	
                var allRowId = gridECPC.getAllRowId();
                
                for(var i in allRowId) {
                    var rowIdx = allRowId[i];
                    if (gridECPC.getCellValue(rowIdx, "GUAR_AMT") == 0 || gridECPC.getCellValue(rowIdx, "GUAR_AMT") == '') {
                    	gridECPC.setCellRequired(rowIdx, "GUAR_TYPE2", false);
                    	gridECPC.setCellEdgeColor(rowIdx, "GUAR_TYPE2", false);
        		        gridECPC.setCellReadOnly(rowIdx, "GUAR_TYPE2", true);

        		        gridECPC.setCellRequired(rowIdx, "GUARANTEER", false);
        		        gridECPC.setCellEdgeColor(rowIdx, "GUARANTEER", false);
        		        gridECPC.setCellReadOnly(rowIdx, "GUARANTEER", true);
                		
            		} else {
            			gridECPC.setCellRequired(rowIdx, "GUAR_TYPE2", true);

	                    if (gridECPC.getCellValue(rowIdx, "GUAR_TYPE2") == "10") {
	                    	gridECPC.setCellRequired(rowIdx, "GUARANTEER", true);
		                    
	                    } else if(gridECPC.getCellValue(rowIdx, "GUAR_TYPE2") == "20") { 
	                    	
	                    	gridECPC.setCellRequired(rowIdx, "GUARANTEER", true);
	                    	
	                    	if(gridECPC.getCellValue(rowIdx, "GUARANTEER") == "20") { //소프트웨어공제조합일경우 그리드 수정 가능여부 제어
	                    		if(gridECPC.getCellValue(rowIdx, "GUAR_NUM") == null || gridECPC.getCellValue(rowIdx, "GUAR_NUM") == "") { //보증번호 발행 전
	                    			if(gridECPC.getCellValue(rowIdx, "INSU_STATUS") == "TA") { //보증신청중
	                    				gridECPC.setCellReadOnly(rowIdx, "GUAR_TYPE2", true);
	                    				gridECPC.setCellReadOnly(rowIdx, "GUARANTEER", true);
			                    		
	                    			//} else if(gridECPC.getCellValue(rowIdx, "INSU_STATUS") == "DD") {  //보증번호 발행 전 취소요청중
	                    			//	gridECPC.setCellReadOnly(rowIdx, "GUAR_TYPE2", true);
	                    			//	gridECPC.setCellReadOnly(rowIdx, "GUARANTEER", true);
			                    		
	                    		    } else {	
	                    		    	gridECPC.setCellReadOnly(rowIdx, "GUAR_TYPE2", false);
	                    		    	gridECPC.setCellReadOnly(rowIdx, "GUARANTEER", false);
			                    		
	                    			}
	                    		} else {																										 //보증번호 발행 후 
	                    			gridECPC.setCellReadOnly(rowIdx, "GUAR_TYPE2", true);
	                    			gridECPC.setCellReadOnly(rowIdx, "GUARANTEER", true);
			                    	
	                    		}
	                    	} else if(gridECPC.getCellValue(rowIdx, "GUARANTEER") == "10") {  //서울보증 테스트 후 조건절 소프트웨어공제조합과 or조건으로 합쳐야함
	                    		if(gridECPC.getCellValue(rowIdx, "GUAR_NUM") == null || gridECPC.getCellValue(rowIdx, "GUAR_NUM") == "") { //보증번호 발행 전
	                    			if(gridECPC.getCellValue(rowIdx, "INSU_STATUS") == "TA") { //보증신청중
	                    				gridECPC.setCellReadOnly(rowIdx, "GUAR_TYPE2", true);
	                    				gridECPC.setCellReadOnly(rowIdx, "GUARANTEER", true);
	                    		    } else {	
	                    		    	gridECPC.setCellReadOnly(rowIdx, "GUAR_TYPE2", false);
	                    		    	gridECPC.setCellReadOnly(rowIdx, "GUARANTEER", false);
			                    		
	                    			}
	                    		} else {																										 //보증번호 발행 후 
	                    			gridECPC.setCellReadOnly(rowIdx, "GUAR_TYPE2", true);
	                    			gridECPC.setCellReadOnly(rowIdx, "GUARANTEER", true);
			                    	
	                    		}
	                    	} else {
	                    		gridECPC.setCellReadOnly(rowIdx, "GUAR_TYPE2", false);
                    			gridECPC.setCellReadOnly(rowIdx, "GUARANTEER", false);
	                    	}
	                    } else if(gridECPC.getCellValue(rowIdx, "GUAR_TYPE2") == "30" ||
	                    		gridECPC.getCellValue(rowIdx, "GUAR_TYPE2") == "40" ||
	                    		gridECPC.getCellValue(rowIdx, "GUAR_TYPE2") == "90") {     
	                    	gridECPC.setCellRequired(rowIdx, "GUARANTEER", false);
	                    	gridECPC.setCellEdgeColor(rowIdx, "GUARANTEER", false);
	                    	gridECPC.setCellReadOnly(rowIdx, "GUARANTEER", true);
	                    } else {
	                    	if (progressCd == "4300") {
		                    	gridECPC.setCellReadOnly(rowIdx, "GUAR_TYPE2", false);
	                    	}
	                    	
	                    	gridECPC.setCellRequired(rowIdx, "GUARANTEER", false);
	                    	gridECPC.setCellEdgeColor(rowIdx, "GUARANTEER", false);
	                    	gridECPC.setCellReadOnly(rowIdx, "GUARANTEER", true);
		                    
						}
            		}
                }
            }, false);
        }

        function doSearchECMT() {
            var store = new EVF.Store();
            store.setGrid([ gridECMT ]);
            store.load(baseUrl + '/sctr0011_doSearchECMT.so', function() {
            }, false);
        }

        function doSearchECCM() {
            var store = new EVF.Store();
            store.setGrid([ gridECCM ]);
            store.load(baseUrl + '/sctr0011_doSearchECCM.so', function() {
            }, false);
        }

        function doSign() {

        	// 첨부파일이 등록된 경우 첨부파일을 확인하라는 알림창 띄운다.
            var attFileNumCnt = Number(EVF.C('ATT_FILE_NUM').getFileCount());

            var message = "";
            if(attFileNumCnt > 0) {
                message = "이 계약서는 첨부파일이 등록되어 있습니다.\n[기본정보]탭에서 첨부파일을 반드시 확인하시기 바랍니다.\n\n첨부파일의 모든 내용을 확인하셨습니까?";
            } else {
                message = "${SCTR0011_0005}";
            }

            if (!gridECPC_HD.validate().flag) { return EVF.alert(gridECPC_HD.validate().msg); }
            if (!gridECPC.validate().flag) { return EVF.alert(gridECPC.validate().msg); }

            // 보증정보의 보증방법이 수기, 지급각서인경우 인 경우 첨부 필수 체크
            for(var i in gridECPC_HD.getAllRowValue()) {
                var hdRowValue = gridECPC_HD.getAllRowValue()[i];

				<%--
                if (hdRowValue.GUAR_TYPE2 == "10" || hdRowValue.GUAR_TYPE2 == "40" && hdRowValue.ATT_FILE_CNT == 0) {
                    return EVF.alert("보증방법이 수기, 지급각서인경우 파일 첨부는 필수 입니다.");
                }
                --%>

                if ((hdRowValue.GUAR_AMT == "" || hdRowValue.GUAR_AMT == "0") && (hdRowValue.DI_GUAR_AMT == "" || hdRowValue.DI_GUAR_AMT == "0")) {
                	continue;
                }

				if (!(hdRowValue.GUAR_AMT == "" || hdRowValue.GUAR_AMT == "0")) {
					var guarType = "계약보증";

					if (hdRowValue.GUAR_TYPE2 == "") {
                		return EVF.alert(guarType + "의 보증방법을 선택하세요.");
                	}

                	if (hdRowValue.GUAR_TYPE2 == "10") {
                    	if (hdRowValue.GUARANTEER == "") {
                    		return EVF.alert(guarType + "의 보증기관을 선택하세요.");
                    	}
                    	if (hdRowValue.ATT_FILE_CNT == "" || hdRowValue.ATT_FILE_CNT == "0") {
                    		return EVF.alert(guarType + "의 보증서 파일을 첨부하세요.");
                    	}
                	} else if (hdRowValue.GUAR_TYPE2 == "20") {
                		//TO-DO 전자보증 신청 module 붙이고 확인!!
                		if (hdRowValue.GUARANTEER == "") {
                    		return EVF.alert(guarType + "의 보증기관을 선택하세요.");
                    	} else {
                    		if (hdRowValue.GUARANTEER == "10") {
                   				if (hdRowValue.INSU_STATUS == "") {
                       				return EVF.alert(guarType + "의 전자보증 보증신청을 해주세요.");
                       			} else {
                       				if (hdRowValue.INSU_STATUS == "TA" || hdRowValue.INSU_STATUS == "SA"){
                       					if (hdRowValue.GUAR_NUM == "") {
                                       		return EVF.alert(guarType + "의 전자보증 신청이 완료되지 않았습니다.\n신청하신 보증사에서 전자구매시스템으로 증권번호 발행이 되지 않았습니다.");
                                       	}
                       				}
                       				
                       				if (hdRowValue.INSU_STATUS == "DE") {
                                   		return EVF.alert(guarType + "의 전자보증이 고객사에 취소요청중입니다.");
                                   	}
                       			}
                    		} else if (hdRowValue.GUARANTEER == "20") {
                    			if (hdRowValue.INSU_STATUS == "") {
                    				return EVF.alert(guarType + "의 전자보증 보증신청을 해주세요.");
                    			} else {
                    				if (hdRowValue.INSU_STATUS == "TA" || hdRowValue.INSU_STATUS == "SA"){
                    					if (hdRowValue.GUAR_NUM == "") {
                                    		return EVF.alert(guarType + "의 전자보증 신청이 완료되지 않았습니다.\n신청하신 보증사에서 전자구매시스템으로 증권번호 발행이 되지 않았습니다.");
                                    	}
                    				}
                    				
                    				if (hdRowValue.INSU_STATUS == "DE") {
                                		return EVF.alert(guarType + "의 전자보증이 고객사에 취소요청중입니다.");
                                	}
                    			}
                    		}
                    	}
                	} else if (hdRowValue.GUAR_TYPE2 == "40") {
                    	if (hdRowValue.ATT_FILE_CNT == "" || hdRowValue.ATT_FILE_CNT == "0") {
                    		return EVF.alert(guarType + "의 보증서 파일을 첨부하세요.");
                    	}
                	} else { <%-- GUAR_TYPE2 현금(30), 면제(90)은 skip --%>
                	}
                }

                if (!(hdRowValue.DI_GUAR_AMT == "" || hdRowValue.DI_GUAR_AMT == "0")) {
                	if (hdRowValue.DI_ATT_FILE_CNT == "" || hdRowValue.DI_ATT_FILE_CNT == "0") {
                		return EVF.alert("차액보증의 보증서 파일을 첨부하세요.");
                	}
                }
            }

            for(var i in gridECPC.getAllRowValue()) {
                var rowValue = gridECPC.getAllRowValue()[i];

				<%--
                if (rowValue.GUAR_TYPE2 == "10" || rowValue.GUAR_TYPE2 == "40" && rowValue.ATT_FILE_CNT == 0) {
                    return EVF.alert("보증방법이 수기, 지급각서인경우 파일 첨부는 필수 입니다.");
                }
                --%>

                if (rowValue.GUAR_AMT == "" || rowValue.GUAR_AMT == "0" || rowValue.GUAR_TYPE2 == "") {
                	continue;
                }

				var guarType = "";
            	if (rowValue.GUAR_TYPE == "ADV") {
            		guarType = "선급보증";
            	} else if (rowValue.GUAR_TYPE == "WARR") {
            		guarType = "하자보증";
            	}

            	if (rowValue.GUAR_TYPE2 == "10") {
                	if (rowValue.GUARANTEER == "") {
                		return EVF.alert(guarType + "의 보증기관을 선택하세요.");
                	}
                	if (rowValue.ATT_FILE_CNT == "" || rowValue.ATT_FILE_CNT == "0") {
                		return EVF.alert(guarType + "의 보증서 파일을 첨부하세요.");
                	}
            	} else if (rowValue.GUAR_TYPE2 == "20") {
            		if (rowValue.GUARANTEER == "") {
                		return EVF.alert(guarType + "의 보증기관을 선택하세요.");
                	} else {
                		if (rowValue.GUARANTEER == "10") {
               				if (rowValue.INSU_STATUS == "") {
                   				return EVF.alert(guarType + "의 전자보증 보증신청을 해주세요.");
                   			} else {
                   				if (rowValue.INSU_STATUS == "TA" || rowValue.INSU_STATUS == "SA"){
                   					if (rowValue.GUAR_NUM == "") {
                                   		return EVF.alert(guarType + "의 전자보증 신청이 완료되지 않았습니다.\n신청하신 보증사에서 전자구매시스템으로 증권번호 발행이 되지 않았습니다.");
                                   	}
                   				}
                   				
                   				if (rowValue.INSU_STATUS == "DE") {
                               		return EVF.alert(guarType + "의 전자보증이 고객사에 취소요청중입니다.");
                               	}
                   			}
                		} else if (rowValue.GUARANTEER == "20") {
                			if (rowValue.INSU_STATUS == "") {
                				return EVF.alert(guarType + "의 전자보증 보증신청을 해주세요.");
                			} else {
                				if (rowValue.INSU_STATUS == "TA" || rowValue.INSU_STATUS == "SA"){
                					if (rowValue.GUAR_NUM == "") {
                                		return EVF.alert(guarType + "의 전자보증 신청이 완료되지 않았습니다.\n신청하신 보증사에서 전자구매시스템으로 증권번호 발행이 되지 않았습니다.");
                                	}
                				}
                				
                				if (rowValue.INSU_STATUS == "DE") {
                            		return EVF.alert(guarType + "의 전자보증이 고객사에 취소요청중입니다.");
                            	}
                			}
                		}
                	}
            		
            	} else if (rowValue.GUAR_TYPE2 == "40") {
                	if (rowValue.ATT_FILE_CNT == "" || rowValue.ATT_FILE_CNT == "0") {
                		return EVF.alert(guarType + "의 보증서 파일을 첨부하세요.");
                	}
            	} else { <%-- GUAR_TYPE2 현금(30), 면제(90)은 skip --%>

            	}
            }

            EVF.confirm(message, function() {
                if(localServerFlag == "Y") {
                	signCompleteCallback();
                } else {
                    document.reqForm.useCard.value = "1";
                    eformScheduler();
                }
            })
        }

        function eformScheduler() {
            var buyerCd = EVF.V("BUYER_CD");
            var contNum = EVF.V("CONT_NUM");
            var contCnt = EVF.V("CONT_CNT");

            // 저장된 JSON 데이터 값을 조회하여 가져온다.
            var eformInputValue = "";
            var store = new EVF.Store();
            store.setAsync(false);
            store.load("/nhepro/CCTR/CCTA0030/ccta0030_doSelectEformJsonData.so", function() {
                eformInputValue = this.getParameter("EFORM_INPUT_VALUE_CLOB");
            });

            // 파일이 첨부되어 있는 경우 서브 페이지를 호출한다.
            var fileCnt = EVF.C("VENDOR_ATT_FILE_NUM").getFileCount();
            var subFormFileNm = EVF.V("SUB_FORM_FILE_NM");
            if (fileCnt > 0) {
                subFormFileNm += ",BS_FILE_INFO";

                // 파일 정보가 존재 시 파일 정보 선 저장
                var store = new EVF.Store();
                store.doFileUpload(function() {
                    store.load(baseUrl+'/sctr0011_doUpdateVendorFile.so', function() {
                    }, true);
                });
            }
            var odiParamVal = "BUYER_CD=" + buyerCd + ",CONT_NUM=" + contNum + ",CONT_CNT=" + contCnt;

            // pdf 저장
            var param = {
	           		bizType: "EC",
	                SUB_FORM_FILE_NM: subFormFileNm,
	                odiName: "DANIL_INFO",
	                ozrName: EVF.V("FORM_FILE_NM"),
	                // OZ Scheduler Info
	                serverUrl: "${ozServer}",
	                schedulerIp: "${ozSchedulerIp}",
	                schedulerPort: "${ozSchedulerPort}",
	                exportFileName: buyerCd + contNum + contCnt,
	                odiParamVal: odiParamVal,
	                url: "${ozUrl}",
	                inputJson: eformInputValue,
	                ozExportUrl: "${ozExportUrl}"
	        };
			
            // ozd 저장
            param["exportFormat"] = "ozd";
            $.ajax({
                url: "${ozUrl}" + "/oz_export_directexport.jsp",
                type: "post",
                data: param,
                async: false,
                success: function(data) {
                    param["exportFormat"] = "pdf";
                    var hashNum = "";
                    $.ajax({
                        url: "${ozUrl}" + "/oz_export_directexport.jsp",
                        type: "post",
                        data: param,
                        async: false,
                        success: function(data) {
                            var allRowId = gridECPC_HD.getAllRowId();
                            for(var i in allRowId) {
                                var rowIdx = allRowId[i];
                                param = {
                                    bizType: "EC",
                                    fileNm: buyerCd + contNum + contCnt,
                                    fileExtension: "pdf",
                                    CONT_NUM: contNum,
                                    CONT_CNT: contCnt,
                                    prBuyerCd: gridECPC_HD.getCellValue(rowIdx, "PY_BUYER_CD"),
                                    prDeptCd: gridECPC_HD.getCellValue(rowIdx, "PY_DEPT_CD"),
                                    uuid: gridECPC_HD.getCellValue(rowIdx, "PDF_ATT_FILE_NUM"),
                                    fileCnt: (Number(i) + 1),
                                    maxFileCnt: allRowId.length
                                };

                                $.ajax({
                                    url: "/common/file/eformPdfUpload.so",
                                    type: "post",
                                    data: param,
                                    async: false,
                                    success: function(data) {
                                        var jsonData = JSON.parse(data);
                                        if(allRowId.length == (Number(i) + 1)) {
                                            hashNum += jsonData.HASH_NUM;
                                        } else {
                                            hashNum += jsonData.HASH_NUM + ",";
                                        }
                                    }
                                });
                            }
                        }
                    });
                    
                    // 공인인증서 팝업창 오픈
                    document.reqForm.signData.value = EVF.V("VENDOR_CD") + "@@" + document.reqForm.idn.value + "@@" + hashNum + "@@" + "${signDate}";
                    magicline.uiapi.MakeSignData(document.reqForm, null, mlCallBack);
                }
            });
        }

        function mlCallBack(code, message){
            if(code == 0) { <%-- 정상메시지 --%>
                if (message.encMsg != null) { document.reqForm.signedData.value = encodeURIComponent(message.encMsg); }
                if (message.vidRandom != null) { document.reqForm.vidRandom.value = encodeURIComponent(message.vidRandom); }
                signCompleteCallback();
            }
            else {
                return EVF.alert("결과값 수신에 실패하였습니다.");
            }
        }

        // 공인인증 완료후 callback함수
        function signCompleteCallback() {

            var store = new EVF.Store();
            store.setGrid([gridECPC_HD, gridECPC, gridECCM]);
            store.getGridData(gridECPC_HD, "all");
            store.getGridData(gridECPC, "sel");
            store.getGridData(gridECCM, "all");
            store.setParameter("signedData", document.reqForm.signedData.value);
            store.setParameter("vidRandom", document.reqForm.vidRandom.value);
            store.setParameter("idn", document.reqForm.idn.value);
            store.setParameter("useCard", document.reqForm.useCard.value);
            store.setParameter("localServerFlag", localServerFlag);
            store.doFileUpload(function() {
                store.load(baseUrl+'/sctr0011_doSaveSignedData.so', function() {
                    EVF.alert('${msg.M0023}');
                    if(opener) {
                        opener['${param.callBackFunction}']();
                        doClose();
                    }
                }, true);
            });
        }

        function doClose() {
            EVF.closeWindow();
        }

        function doReject() {

            var param = {
	                "screenName": "계약서 거절 사유를 입력해주세요.",
	                "callBackFunction": 'setRejectReason',
	                "havePermission": 'true',
	                "detailView": ${(!param.detailView or editableStatus) ? false : true}
	            };
            everPopup.openModalPopup('/common/popup/commonTextContents/view.so', 700, 350, param, 'commonTextInput');
        }

        function setRejectReason(text) {

            if(text == undefined || text.trim() == '') {
                return EVF.alert('${SCTR0011_0004}')
            }

            EVF.confirm('${SCTR0011_0002}', function() {
                var store = new EVF.Store();
                store.setParameter('rejectRemark', text);
                store.load(baseUrl+'/sctr0011_doRejectContract.so', function() {
                    EVF.alert('${SCTR0011_0003}');
                    if(opener) {
                        opener['${param.callBackFunction}']();
                    }
                    EVF.closeWindow();
                });
            });
        }

        function onActiveTab(newTabId, oldTabId, event) {
            if(newTabId === '1') { // 계약서기본정보
            } else if(newTabId === '2') { // 계약서 갑지
            } else { <%-- 부서식탭 활성화 --%>
            }
        }
		
        //gridECPC_HD 보증 신청
        function guar_approval(rowIdx) {
        	
        	var rowValue = gridECPC_HD.getRowValue(rowIdx);
        	if (rowValue.GUARANTEER == "20") { 
	        	var url = '/guarGuide.so';
	            var params = {
	                title: '소프트웨어공제조합 전자보증신청안내',
	                rowIdx: rowIdx,
	                type : "ecpcHD"
	            };
	            everPopup.openWindowPopup(url, 1080, 350, params, '소프트웨어공제조합 전자신청안내');
        	} else {
        		var url = '/guarSgGuide.so';
	            var params = {
	                title: '서울보증 전자보증신청안내',
	                rowIdx: rowIdx,
	                type : "ecpcHD"
	            };
	            everPopup.openWindowPopup(url, 1080, 350, params, '서울보증 전자신청안내');
        	}
        }
        
        function guarEcpcHdGuidecheck(data) { //계약보증 신청
        	if(data.check == "Y"){
        		var store = new EVF.Store();
                var mmm = gridECPC_HD.getRowValue(data.rowIdx);
               	
    			store.setParameter('guardata',JSON.stringify(mmm));
    			
    			if (mmm.GUARANTEER == '10'){
    				EVF.confirm("보증 신청을 하시겠습니까?", function() {
	                    store.doFileUpload(function() {
	                        store.load(baseUrl + '/sctr0011_guarSg_approval.so', function () {
	                            //EVF.alert("성공적으로 신청하였습니다.");
	                            EVF.alert(this.getResponseMessage());
	                            doSearchECPC_HD();
	                        }, false);
	                    });
	                })
    				
    			} else if(mmm.GUARANTEER == '20'){ 
    				
	                EVF.confirm("보증 신청을 하시겠습니까?", function() {
	                    store.doFileUpload(function() {
	                        store.load(baseUrl + '/sctr0011_guar_approval.so', function () {
	                            //EVF.alert("성공적으로 신청하였습니다.");
	                            EVF.alert(this.getResponseMessage());
	                            doSearchECPC_HD();
	                        }, false);
	                    });
	                })
    			}
        	}
        }
		
        //gridECPC_HD 보증번호 발급전 취소
        function guar_cancel(rowIdx) {
            var store = new EVF.Store();
            var mmm = gridECPC_HD.getRowValue(rowIdx);
			
			store.setParameter('guardata',JSON.stringify(mmm));
			if (mmm.GUARANTEER == '10'){
	            EVF.confirm("신청하신 보증에 대한 정보가 사라집니다. 보증 취소를 하시겠습니까?", function() {
	                store.doFileUpload(function() {
	                    store.load(baseUrl + '/sctr0011_guarSg_cancel.so', function () {
	                        //EVF.alert("성공적으로 취소하였습니다.");
	                        EVF.alert(this.getResponseMessage());
	                        doSearchECPC_HD();
	                    }, false);
	                });
	            })
			} else if(mmm.GUARANTEER == '20'){
				EVF.confirm("신청하신 보증에 대한 정보가 사라집니다. 보증 취소를 하시겠습니까?", function() {
	                store.doFileUpload(function() {
	                    store.load(baseUrl + '/sctr0011_guar_cancel.so', function () {
	                        //EVF.alert("성공적으로 취소하였습니다.");
	                        EVF.alert(this.getResponseMessage());
	                        doSearchECPC_HD();
	                    }, false);
	                });
	            })
			}
        }
        
        //gridECPC_HD 보증번호 발급 후 취소
        function guar_delete(rowIdx) {
        	
           	var param = {
                    title: "보증취소사유",
                    message: EVF.V("GUAR_CANCEL_RMK"),
                    callbackFunction: "callbackGuarDelete",
                    rowIdx: ""
                };

                everPopup.commonTextInput(param);
        }
        
        function callbackGuarDelete(data) {
        	if(data.message == "") {
                EVF.alert("취소요청사유를 입력해주세요");
            } else {
                EVF.V("GUAR_CANCEL_RMK", data.message);
                
                EVF.confirm("신청하신 보증에 대한 정보가 사라집니다.\n고객사에 보증 취소요청을 하시겠습니까?", function() {
                	
                	var store = new EVF.Store();
                    store.setGrid([gridECPC_HD]);
                    store.getGridData(gridECPC_HD, "sel");
                    
                    store.doFileUpload(function() {
                        store.load(baseUrl + '/sctr0011_guar_delete.so', function () {
                            EVF.alert("성공적으로 취소요청하였습니다.");
                            doSearchECPC_HD();
                        }, false);
                    });
                })
            }
        }
        
        //gridECPC 보증 신청
        function guar_approval2(rowIdx) {
            
        	var rowValue = gridECPC.getRowValue(rowIdx);
        	if (rowValue.GUARANTEER == "20") { 
	        	var url = '/guarGuide.so';
	            var params = {
	                title: '소프트웨어공제조합 전자보증신청안내',
	                rowIdx: rowIdx,
	                type : "ecpc"
	            };
	            everPopup.openWindowPopup(url, 1080, 350, params, '소프트웨어공제조합 전자보증신청안내');
        	} else {
        		var url = '/guarSgGuide.so';
	            var params = {
	                title: '서울보증 전자보증신청안내',
	                rowIdx: rowIdx,
	                type : "ecpc"
	            };
	            everPopup.openWindowPopup(url, 1080, 350, params, '서울보증 전자보증신청안내');
        	}
        }
        
        function guarEcpcGuidecheck(data) { //선급,하자보증 신청
        	if(data.check == "Y"){
        		var store = new EVF.Store();
                var mmm = gridECPC.getRowValue(data.rowIdx);
            	
    			store.setParameter('guardata',JSON.stringify(mmm));
    			if (mmm.GUARANTEER == '10'){
	                EVF.confirm("보증신청을 하시겠습니까?", function() {
	                    store.doFileUpload(function() {
	                        store.load(baseUrl + '/sctr0011_guarSg_approval2.so', function () {
	                            //EVF.alert("성공적으로 신청하였습니다.");
	                            EVF.alert(this.getResponseMessage());
	                            doSearchECPC();
	                        }, false);
	                    });
	                })
    			} else if(mmm.GUARANTEER == '20'){
    				EVF.confirm("보증신청을 하시겠습니까?", function() {
	                    store.doFileUpload(function() {
	                        store.load(baseUrl + '/sctr0011_guar_approval2.so', function () {
	                            //EVF.alert("성공적으로 신청하였습니다.");
	                            EVF.alert(this.getResponseMessage());
	                            doSearchECPC();
	                        }, false);
	                    });
	                })
    			}    
        	}
        }
        
        //gridECPC 보증번호 발급 전 취소
        function guar_cancel2(rowIdx) {
            var store = new EVF.Store();
            var mmm = gridECPC.getRowValue(rowIdx);
        	
			store.setParameter('guardata',JSON.stringify(mmm));
			if (mmm.GUARANTEER == '10'){
	            EVF.confirm("신청하신 보증에 대한 정보가 사라집니다. 보증 취소를 하시겠습니까?", function() {
	                store.doFileUpload(function() {
	                    store.load(baseUrl + '/sctr0011_guarSg_cancel2.so', function () {
	                        //EVF.alert("성공적으로 취소하였습니다.");
	                        EVF.alert(this.getResponseMessage());
	                        doSearchECPC();
	                    }, false);
	                });
	            })
			} else if(mmm.GUARANTEER == '20'){
				EVF.confirm("신청하신 보증에 대한 정보가 사라집니다. 보증 취소를 하시겠습니까?", function() {
	                store.doFileUpload(function() {
	                    store.load(baseUrl + '/sctr0011_guar_cancel2.so', function () {
	                        //EVF.alert("성공적으로 취소하였습니다.");
	                        EVF.alert(this.getResponseMessage());
	                        doSearchECPC();
	                    }, false);
	                });
	            })
			}
        }
        
        //gridECPC 보증번호 발급 후 취소
        function guar_delete2(rowIdx) {
        	
           	var param = {
                    title: "보증취소사유",
                    message: EVF.V("GUAR_CANCEL_RMK"),
                    callbackFunction: "callbackGuarDelete2",
                    rowIdx: ""
                };

                everPopup.commonTextInput(param);
        }
        
        function callbackGuarDelete2(data) {
        	if(data.message == "") {
                EVF.alert("취소요청사유를 입력해주세요");
            } else {
                EVF.V("GUAR_CANCEL_RMK", data.message);
                
                EVF.confirm("신청하신 보증에 대한 정보가 사라집니다.\n고객사에 보증 취소요청을 하시겠습니까? ", function() {
                	var store = new EVF.Store();
                    store.setGrid([gridECPC]);
                    store.getGridData(gridECPC, "sel");
                    
                    store.doFileUpload(function() {
                        store.load(baseUrl + '/sctr0011_guar_delete2.so', function () {
                            EVF.alert("성공적으로 취소요청하였습니다.");
                            doSearchECPC();
                            EVF.V('GUAR_CANCEL_RMK', '');
                        }, false);
                    });
                })
            }
        }
        
     	// 보증서 첨부 저장
	    function doGuarSave() {
	      	var store = new EVF.Store();
	      	if (!gridECPC.isExistsSelRow()) { return alert('${msg.M0004}'); }

	      	// Grid Validation Check
	      	if(!gridECPC.validate().flag) {
	        	return EVF.alert("${msg.M0014}");
	      	}
	      	
	      	for(var i in gridECPC.getSelRowValue()) {
				var ecpcGuarType = gridECPC.getSelRowValue()[i];
				
				if (ecpcGuarType.GUAR_AMT == null || ecpcGuarType.GUAR_AMT == "") {
					return EVF.alert("수기보증저장을 할 수 없는 상태입니다.");
				}
				
				if (ecpcGuarType.GUAR_TYPE2 == '20') {
					return EVF.alert("보증방법이 전자보증인경우는 수기보증저장을 할 수 없습니다.");
				}
				if (ecpcGuarType.GUAR_TYPE2 == "10" || ecpcGuarType.GUAR_TYPE2 == "40")   {
					if (ecpcGuarType.GUAR_TYPE == "ADV") {
	            		guarType = "선급보증";
	            	} else if (ecpcGuarType.GUAR_TYPE == "WARR") {
	            		guarType = "하자보증";
	            	}
					
                	if (ecpcGuarType.ATT_FILE_CNT == "" || ecpcGuarType.ATT_FILE_CNT == "0") {
                		return EVF.alert(guarType + "의 보증서 파일을 첨부하세요.");
                	}
            	}
			}
	      	
		    store.doFileUpload(function() {
			    store.setGrid([gridECPC]);
			    store.getGridData(gridECPC, 'sel');
			    EVF.confirm("${msg.M0021}", function () {
				    store.load(baseUrl + '/sctr0010_doGuarSave.so', function() {
					    EVF.alert("${msg.M0031}", function() {
					    	doSearchECPC();
					    });
				    });
			    });
		    });
		}

    </script>

    <e:window id="SCTR0011" onReady="init" initData="${initData}" title="${fullScreenName }" breadCrumbs="${breadCrumb }" margin="0 4px">

        <e:tabPanel id="T1" onActive="onActiveTab">
            <!-- tab1 : 기본정보 -->
            <e:tab id="1" title="기본정보">
                <e:inputHidden id='PROGRESS_CD' name='PROGRESS_CD' value='${form.PROGRESS_CD}'/>
                <e:inputHidden id='IRS_NO' name='IRS_NO' value='${form.IRS_NO}'/>
                <e:inputHidden id="SIGN_VALUE" name="SIGN_VALUE" />
                <e:inputHidden id="BUYER_CD" name="BUYER_CD" value="${form.BUYER_CD}"/>
                <e:inputHidden id="CONT_NUM" name="CONT_NUM" value="${form.CONT_NUM}"/>
                <e:inputHidden id="CONT_CNT" name="CONT_CNT" value="${form.CONT_CNT}"/>
                <e:inputHidden id="VENDOR_CD" name="VENDOR_CD" value="${form.VENDOR_CD}"/>
                <e:inputHidden id="PR_BUYER_CD" name="PR_BUYER_CD" value="${form.PR_BUYER_CD}"/>
                <e:inputHidden id="PR_DEPT_CD" name="PR_DEPT_CD" value="${form.PR_DEPT_CD}"/>
                <e:inputHidden id="FORM_NUM" name="FORM_NUM" value="${form.FORM_NUM}"/>
                <e:inputHidden id="SUB_FORM_FILE_NM" name="SUB_FORM_FILE_NM" value="${form.SUB_FORM_FILE_NM}"/>
                <e:inputHidden id="FORM_FILE_NM" name="FORM_FILE_NM" value="${form.FORM_FILE_NM}"/>
                
                <e:inputHidden id="GUAR_CANCEL_RMK" name="GUAR_CANCEL_RMK"/>

                <e:searchPanel id="form" title="${form_CAPTION_N }" columnCount="3" labelWidth="125" onEnter="doSearch" useTitleBar="false">
                    <e:row>
                        <%--계약번호/차수--%>
                        <e:label for="CONT_NUM" title="${form_CONT_NUM_N}" />
                        <e:field>
                            <e:text>${form.CONT_NUM}</e:text>
                            <e:text> / </e:text>
                            <e:text>${form.CONT_CNT}</e:text>
                        </e:field>
                        <%--계약일자--%>
                        <e:label for="CONT_DATE" title="${form_CONT_DATE_N}"/>
                        <e:field>
                            <e:inputDate id="CONT_DATE" name="CONT_DATE" value="${form.CONT_DATE}" width="${inputDateWidth}" datePicker="true" required="${form_CONT_DATE_R}" disabled="${form_CONT_DATE_D}" readOnly="${form_CONT_DATE_RO}" />
                        </e:field>
                        <%--계약기간--%>
                        <e:label for="CONT_START_DATE" title="${form_CONT_START_DATE_N}"/>
                        <e:field>
                            <e:inputDate id="CONT_START_DATE" name="CONT_START_DATE" value="${form.CONT_START_DATE}" width="${inputDateWidth}" datePicker="true" required="${form_CONT_START_DATE_R}" disabled="${form_CONT_START_DATE_D}" readOnly="${form_CONT_START_DATE_RO}" />
                            <e:text>~</e:text>
                            <e:inputDate id="CONT_END_DATE" name="CONT_END_DATE" value="${form.CONT_END_DATE}" width="${inputDateWidth}" datePicker="true" required="${form_CONT_END_DATE_R}" disabled="${form_CONT_END_DATE_D}" readOnly="${form_CONT_END_DATE_RO}" />
                        </e:field>
                    </e:row>
                    <e:row>
                        <%--계약명--%>
                        <e:label for="CONT_DESC" title="${form_CONT_DESC_N}" />
                        <e:field colSpan="3">
                            <e:text>${form.CONT_DESC}</e:text>
                        </e:field>
                        <%--계약구분--%>
                        <e:label for="CONT_REQ_CD" title="${form_CONT_REQ_CD_N}"/>
                        <e:field>
                            <e:select id="CONT_REQ_CD" name="CONT_REQ_CD" value="${form.CONT_REQ_CD}" options="${contReqCdOptions}" width="${form_CONT_REQ_CD_W}" disabled="${form_CONT_REQ_CD_D}" readOnly="${form_CONT_REQ_CD_RO}" required="${form_CONT_REQ_CD_R}" placeHolder="" maskType="${form_CONT_REQ_CD_MT}" />
                        </e:field>
                    </e:row>
                    <e:row>
                        <%--계약금액--%>
                        <e:label for="CONT_AMT" title="${form_CONT_AMT_N}"/>
                        <e:field>
                            <e:text>${form.CUR} ${form.CONT_AMT_COMMA} (${form.VAT_TYPE_NM})</e:text>
                        </e:field>
                        <%--계약담당자--%>
                        <e:label for="CONT_USER_NM" title="${form_CONT_USER_NM_N}" />
                        <e:field>
                            <e:text>${form.CONT_USER_NM}</e:text>
                        </e:field>
                        <%--자동갱신여부--%>
                        <e:label for="AUTO_RENEW_FLAG" title="${form_AUTO_RENEW_FLAG_N}"/>
                        <e:field>
                            <e:select id="AUTO_RENEW_FLAG" name="AUTO_RENEW_FLAG" value="${form.AUTO_RENEW_FLAG}" options="${autoRenewFlagOptions}" width="${form_AUTO_RENEW_FLAG_W}" disabled="${form_AUTO_RENEW_FLAG_D}" readOnly="${form_AUTO_RENEW_FLAG_RO}" required="${form_AUTO_RENEW_FLAG_R}" placeHolder="" maskType="${form_AUTO_RENEW_FLAG_MT}" />
                        </e:field>
                    </e:row>
                    <e:row>
                        <%--협력업체명--%>
                        <e:label for="VENDOR_NM" title="${form_VENDOR_NM_N}" />
                        <e:field>
                            <e:text>${form.VENDOR_NM}</e:text>
                        </e:field>
                        <%--협력업체 담당자--%>
                        <e:label for="VENDOR_PIC_USER_NM" title="${form_VENDOR_PIC_USER_NM_N}" />
                        <e:field>
                            <e:text>${form.VENDOR_PIC_USER_NM}</e:text>
                        </e:field>
                        <%--담당자 이메일--%>
                        <e:label for="VENDOR_PIC_USER_EMAIL" title="${form_VENDOR_PIC_USER_EMAIL_N}" />
                        <e:field>
                            <e:text>${form.VENDOR_PIC_USER_EMAIL}</e:text>
                        </e:field>
                    </e:row>
                    <e:row>
                        <%--지체상금율--%>
                        <e:label for="DELAY_NUME_RATE" title="${form_DELAY_NUME_RATE_N}"/>
                        <e:field colSpan="3">
                        	<e:text>${form.DELAY_RMK}</e:text>
                        	<e:text> </e:text>
                            <e:text>${form.DELAY_NUME_RATE}</e:text>
                            <e:text> / </e:text>
                            <e:text>${form.DELAY_DENO_RATE}</e:text>
                        </e:field>
                        <%--인지세여부/금액--%>
                        <e:label for="STAMP_DUTY_FLAG" title="${form_STAMP_DUTY_FLAG_N}" />
                        <e:field>
                            <div style="width: 30%;">
                                <e:checkGroup id="STAMP_DUTY_FLAG" name="STAMP_DUTY_FLAG" width="10%" value="${form.STAMP_DUTY_FLAG}" disabled="${form_STAMP_DUTY_FLAG_D}" readOnly="${form_STAMP_DUTY_FLAG_RO}" required="${form_STAMP_DUTY_FLAG_R}">
                                    <e:check id="STAMP_DUTY_FLAG1" name="STAMP_DUTY_FLAG1" value="1"  />
                                </e:checkGroup>
                            </div>
                            <e:text>${SCTR0011_STAMP_DUTY_TXT} / </e:text>
                            <e:text>${form.STAMP_DUTY_AMT_COMMA}</e:text>
                        </e:field>
                    </e:row>
                    <e:row>
                        <%--비고--%>
                        <e:label for="CONT_RMK" title="${form_CONT_RMK_N}" />
                        <e:field colSpan="5">
                            <e:inputText id="CONT_RMK" name="CONT_RMK" value="${form.CONT_RMK}" width="${form_CONT_RMK_W}" maxLength="${form_CONT_RMK_M}" disabled="${form_CONT_RMK_D}" readOnly="${form_CONT_RMK_RO}" required="${form_CONT_RMK_R}" style="${imeMode}" maskType="${form_CONT_RMK_MT}"/>
                        </e:field>
                    </e:row>
                    <c:if test="${form.PROGRESS_CD eq '4220'}">
                        <e:row>
                            <e:label for="VENDOR_REJECT_RMK" title="${form_VENDOR_REJECT_RMK_N}"/>
                            <e:field colSpan="5">
                                <e:select id="st_VENDOR_REJECT_RMK" name="st_VENDOR_REJECT_RMK" value="${st_default}" width="${everMultiWidth}" options="${searchTerms}" visible="${everMultiVisible}" required="false" readOnly="false" disabled="false" />
                                <e:textArea id="VENDOR_REJECT_RMK" name="VENDOR_REJECT_RMK" value="${form.VENDOR_REJECT_RMK}" height="100px" width="${form_VENDOR_REJECT_RMK_W}" maxLength="${form_VENDOR_REJECT_RMK_M}" disabled="${form_VENDOR_REJECT_RMK_D}" readOnly="${form_VENDOR_REJECT_RMK_RO}" required="${form_VENDOR_REJECT_RMK_R}" />
                            </e:field>
                        </e:row>
                    </c:if>
                </e:searchPanel>

                <e:title title="첨부파일"/>
                <e:searchPanel id="form2" title="${form_CAPTION_N }" columnCount="2" labelWidth="125" onEnter="doSearch" useTitleBar="false">
                    <e:row>
                        <e:label for="ATT_FILE_NUM" title="${form_ATT_FILE_NUM_N}"/>
                        <e:field>
                            <e:fileManager id="ATT_FILE_NUM" height="100" width="100%" fileId="${form.ATT_FILE_NUM}" readOnly="true" bizType="EC" required="false" uploadable="false" autoUpload="true" />
                        </e:field>
                        <e:label for="VENDOR_ATT_FILE_NUM" title="${form_VENDOR_ATT_FILE_NUM_N}"/>
                        <e:field>
                            <e:fileManager id="VENDOR_ATT_FILE_NUM" height="100" width="100%" fileId="${form.VENDOR_ATT_FILE_NUM}" readOnly="${(!param.detailView or editableStatus) ? false : true}" bizType="EC" required="false" uploadable="true" autoUpload="true" />
                        </e:field>
                    </e:row>
                </e:searchPanel>
            </e:tab>
            <%--계약보증 정보--%>
            <e:title title="보증정보(계약보증)"/>
            <e:gridPanel id="gridECPC_HD" name="gridECPC_HD" width="100%" height="200px" gridType="${_gridType}" readOnly="${(!param.detailView or editableStatus) ? false : true}"/>

            <%--계약보증 정보--%>
            <e:buttonBar id="buttonBar" align="right" width="100%" title="보증정보(선급보증, 하자보증)">
            <c:if test="${form.PROGRESS_CD eq '4300'}">
	                <e:button id="doGuarSave" name="doGuarSave" label="${doGuarSave_N}" onClick="doGuarSave" />
        	</c:if>
        	</e:buttonBar>
            <e:gridPanel id="gridECPC" name="gridECPC" width="100%" height="250px" gridType="${_gridType}" readOnly="${(!param.detailView or editableStatus) ? false : true}"/>

            <%--계약보증 정보--%>
            <e:title title="품목정보"/>
            <e:gridPanel id="gridECMT" name="gridECMT" width="100%" height="300px" gridType="${_gridType}" readOnly="${(!param.detailView or editableStatus) ? false : true}"/>

            <%--계약보증 정보--%>
            <div style="display: none;">
                <e:gridPanel id="gridECCM" name="gridECCM" width="100%" height="200px" gridType="${_gridType}" readOnly="${(!param.detailView or editableStatus) ? false : true}"/>
            </div>
        </e:tabPanel>

        <c:if test="${param.contractEditable eq 'true' and editableStatus}">
            <e:buttonBar width="100%" align="right">
                <e:button id="doReject" name="doReject" label="${doReject_N}" onClick="doReject" disabled="${doReject_D}" visible="${doReject_V}"/>
                <e:button id="doSign" name="doSign" label="${doSign_N}" onClick="doSign" disabled="${doSign_D}" visible="${doSign_V}"/>
            </e:buttonBar>
        </c:if>

        <form id='reqForm' name='reqForm' method='post' action="/MagicLine4Web/ML4Web/jcaosCheck.jsp">
            <input type="hidden" id="signData" name="signData" value=""/>
            <input type="hidden" id="signedData" name="signedData"/>
            <input type="hidden" id="vidRandom" name="vidRandom"/>
            <input type="hidden" id="vidType" name="vidType" value="client"/>
            <input type="hidden" id="idn" name="idn" value="${form.IRS_NO}"/>
            <input type="hidden" id="useCard" name="useCard" value=""/>
        </form>

        <div id="dscertContainer">
            <iframe id="dscert" name="dscert" src="" width="100%" height="100%" frameborder="0" allowTransparency="true" style="position:fixed;z-index:100010;top:0px;left:0px;width:100%;height:100%;"></iframe>
        </div>
    </e:window>
</e:ui>
