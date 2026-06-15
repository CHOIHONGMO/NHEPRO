<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.st_ones.everf.serverside.config.PropertiesManager" %>

<%
	String ksfcUrl = PropertiesManager.getString("eversrm.ksfc.url");
	String ManagerCd = PropertiesManager.getString("eversrm.customer.admin.ManagerCd");
%>

<c:set var="ksfcUrl" value="<%=ksfcUrl%>" />

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
	<script>

		var grid;
		var baseUrl = "/nhepro/CCTR/CCTR0055";
		var userFlag = false;
		
		function init() {

			grid = EVF.C("grid");
			grid.setProperty("shrinkToFit", ${shrinkToFit});		// 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
			grid.setProperty("rowNumbers", ${rowNumbers});		    // 로우의 번호 표시 여부를 지정한다. [true/false]
			grid.setProperty("sortable", ${sortable});			    // 컬럼 정렬기능 사용여부를 지정한다. [true/false]
			grid.setProperty("panelVisible", ${panelVisible});	    // 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
			grid.setProperty("enterToNextRow", ${enterToNextRow}); // 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
			grid.setProperty("acceptZero", ${acceptZero});		    // 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
			grid.setProperty("multiSelect", ${multiSelect});		// [선택] 컬럼의 사용여부를 지정한다. [true/false]
			grid.setProperty("singleSelect", ${singleSelect});	    // [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]

			// 그리드 footer Merge
			//grid._gvo.setFooter({
			//	'mergeCells' : ["PR_BUYER_DEPT_NM", "GUAR_TYPE", "GUAR_PERCENT"]
			//});

			// Grid Excel Event
			grid.excelExportEvent({
				allItems: "${excelExport.allCol}",
				fileName: "${screenName }"
			});

			grid.cellClickEvent(function (rowIdx, celName, value) {
				var param;
				var url;
				var contUserId = grid.getCellValue(rowIdx, 'CONT_USER_ID');
				var buyerCd = grid.getCellValue(rowIdx, "BUYER_CD");
				var contNum = grid.getCellValue(rowIdx, "CONT_NUM");
				var contCnt = grid.getCellValue(rowIdx, "CONT_CNT");
				var vendorCd = grid.getCellValue(rowIdx, "VENDOR_CD");
				var prBuyerCd = grid.getCellValue(rowIdx, "PR_BUYER_CD");
				var prDeptCd = grid.getCellValue(rowIdx, "PR_DEPT_CD");
				var guaranteer  = grid.getCellValue(rowIdx, "GUARANTEER");
				
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
						var contType   = grid.getCellValue(rowIdx, "CONT_TYPE");
						var signStatus = grid.getCellValue(rowIdx, "SIGN_STATUS");
						var PDF_ATT_FILE_NUM = grid.getCellValue(rowIdx, "PDF_ATT_FILE_NUM");
						
						param = {
							callBackFunction: 'doSearch',
							CONT_NUM: value,
							CONT_CNT: contCnt,
							CONT_TYPE: contType,
							bundleFlag: bundleFlag,
							BUYER_CD: buyerCd,
							PDF_ATT_FILE_NUM : PDF_ATT_FILE_NUM
						};
						
						// 임시저장
						if (Number(progressCd) == 4200 && signStatus == "T") {
							param["detailView"] = true;
						}// 협력사 반려, 협력사 서명완료
						else if (Number(progressCd) == 4220 || Number(progressCd) == 4230) {
							param["detailView"] = true;
							if (Number(progressCd) == 4230) {
								param["detailView"]  = true;
								param["PR_BUYER_CD"] = prBuyerCd;
								param["PR_DEPT_CD"]  = prDeptCd;
							}
						}// 협력사 서명대기(4210), 전자서명완료(4300)
						else if (Number(progressCd) > 4200) {
							param["detailView"] = true;
						}
						else {
							param["detailView"] = true;
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
								if( grid.getCellValue(rowIdx, "PROGRESS_CD") == "4210" && vendorCd == "${ses.companyCd}" ) {
									param["detailView"] = true;
								} else {
									param["detailView"] = true;
								}
							}
							// 일괄계약의 단일계약번호 클릭시 단일계약여부=0
							param["singleFlag"] = "1";
							url = '/nhepro/CCTR/CCTA0040/view.so';
							everPopup.openWindowPopup(url, 1200, 900, param, 'openBundleContract');
						}
						break;
						
					case "VENDOR_NM":
						if( value == "" ) return;
						param = {
		                        VENDOR_CD: grid.getCellValue(rowIdx, 'VENDOR_CD'),
		                        detailView: true,
		                        popupFlag: true,
		                        buttonView: false
		                    };
		                everPopup.openPopupByScreenId("CVNR0011", 1000, 730, param);
		                break;
	                
					case "GUAR_NUM":
						if( value == "" ) return;
						if (guaranteer == "20") {
	                		var url = "${ksfcUrl}";
	                		window.open(url);
	            		}
                    	break;
                    	
					case "GUAR_CANCEL_RMK":
                        if(value != "") {
                            param = {
                                title: "보증취소요청사유",
                                message: value,
                                detailView: true
                            };

                            everPopup.commonTextInput(param);
                        }
                        break;
                        
					case "GUAR_REJECT_RMK":
                        if(value != "") {
                            param = {
                                title: "보증취소반려사유",
                                message: value,
                                detailView: true
                            };

                            everPopup.commonTextInput(param);
                        }
                        break;   
				}

			});
			
			
			EVF.C("GUARANTEER").removeOption("50");
            EVF.C("GUARANTEER").removeOption("51");
            EVF.C("GUARANTEER").removeOption("52");
            EVF.C("GUARANTEER").removeOption("53");
            EVF.C("GUARANTEER").removeOption("54");
            EVF.C("GUARANTEER").removeOption("55");
            EVF.C("GUARANTEER").removeOption("56");
            EVF.C("GUARANTEER").removeOption("57");
            EVF.C("GUARANTEER").removeOption("58");
            EVF.C("GUARANTEER").removeOption("59");
            EVF.C("GUARANTEER").removeOption("60");
            
			if ("${ses.ctrlCd}".indexOf("${ManagerCd}") > -1) {
				userFlag = true;
            }
			
			doSearch();
			setLinkStyle(); 
		}

		
		function setLinkStyle() {
			grid.setColFontColor("GUAR_NUM", "#FF0000");
			grid.setColFontColor("PRE_GUAR_NUM", "#FF0000");
        }
		

		function doSearch() {
			var store = new EVF.Store();
			
			// form validation Check
			if (!store.validate()) return;
			
			store.setGrid([grid]);
			store.load(baseUrl + "/cctr0055_doSearch.so", function () {
				
				if (grid.getRowCount() == 0) {
					return EVF.alert('${msg.M0002}');
				}
				
				grid.setColIconify("GUAR_CANCEL_RMK", "GUAR_CANCEL_RMK", "comment", false);
				grid.setColIconify("GUAR_REJECT_RMK", "GUAR_REJECT_RMK", "comment", false);

			});
		}
		
		//협력사 보증취소요청 승인
		function doConfirm() {
        	if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
        	if (grid.getSelRowCount() > 1) { return EVF.alert("${msg.M0006}"); }
        	
        	var selRowValue = grid.getSelRowValue();
        	
        	var user_chk = false;
        	var confirm_chk = false;
        	
        	for(var i in selRowValue) {
                var row = selRowValue[i];
                
                if(!userFlag) {
					if (row.CONT_USER_ID != "${ses.userId}") {
						user_chk = true;
					}
				}
                
	            if( row.GUAR_CANCEL_STATUS != "J") {
	            	confirm_chk = true;
	            }
            }
			
        	if(user_chk) {
        		return EVF.alert("${msg.M0008}"); // 계약담당자건만 처리 가능함
        	}
        	
            if(confirm_chk) {
                return EVF.alert("보증취소요청 상태가 아닙니다.");
            }
            
            var guaranteer = selRowValue[0].GUARANTEER;
			
			var rowIds = grid.getSelRowId();
			var rowIdx = rowIds[0];
			
			if(guaranteer == '20'){
	            EVF.confirm("보증취소요청 건에 대해 승인처리 하시겠습니까?", function () {
	                var store = new EVF.Store();
	                store.setGrid([grid]);
	                store.getGridData(grid, "sel");
	                store.load("/nhepro/CCTR/CCTR0051/cctr0051_doConfirm.so", function() {
	                    EVF.alert(this.getResponseMessage());
	                    doSearch();
	                });
	            });
			} else {
				EVF.confirm("보증취소요청 건에 대해 승인처리 하시겠습니까?", function () {
	                var store = new EVF.Store();
					var mmm = grid.getRowValue(rowIdx);
	    			store.setParameter('guardata',JSON.stringify(mmm));
	                store.load("/nhepro/SCTR/SCTR0011/sctr0011_guarNumSg_cancel.so", function() {
	                    EVF.alert(this.getResponseMessage());
	                    doSearch();
	                });
	            });
			}
        }
		
		//협력사 보증취소요청 반려
		function doReject() {
        	if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
        	if (grid.getSelRowCount() > 1) { return alert("${msg.M0006}"); }
        	
        	var selRowValue = grid.getSelRowValue();
        	
        	var user_chk = false;
        	var reject_chk = false;
        	
        	for(var i in selRowValue) {
                var row = selRowValue[i];
                
                if(!userFlag) {
					if (row.CONT_USER_ID != "${ses.userId}") {
						user_chk = true;
					}
				}
                
	            if( row.GUAR_CANCEL_STATUS != "J") {
	            	reject_chk = true;
	            }
            }
			
        	if(user_chk) {
        		return EVF.alert("${msg.M0008}"); // 계약담당자건만 처리 가능함
        	}
        	
            if(reject_chk) {
                return EVF.alert("보증취소요청 상태가 아닙니다.");
            }
            
            var param = {
                    title: "보증취소요청 반려사유",
                    message: EVF.V("GUAR_REJECT_RMK"),
                    callbackFunction: "callbackReject",
                    rowIdx: ""
                };

                everPopup.commonTextInput(param);
        }
		
		function callbackReject(data) {
        	if(data.message == "") {
                EVF.alert("반려사유를 입력해주세요");
            } else {
                EVF.V("GUAR_REJECT_RMK", data.message);

                EVF.confirm("보증취소요청 건에 대해 반려처리 하시겠습니까", function () {
                    var store = new EVF.Store();
                    store.setGrid([grid]);
                    store.getGridData(grid, "sel");
                    store.load("/nhepro/CCTR/CCTR0051/cctr0051_doReject.so", function() {
                        EVF.alert(this.getResponseMessage());
                        doSearch();
                    });
                });
            }
        }
		
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
		
		function getVendor() {

			var param = {
				callBackFunction: "setVendor"
			};
			everPopup.openCommonPopup(param, "SP0123");
		}

		function setVendor(data) {
			EVF.V("VENDOR_CD", data.VENDOR_CD);
			EVF.V("VENDOR_NM", data.VENDOR_NM);
		}
		
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
				EVF.V("CONT_USER_ID", data.USER_ID);
				EVF.V("CONT_USER_NM", data.USER_NM);
			}
		}
		
	</script>

	<e:window id="CCTR0055" initData="${initData}" onReady="init" title="${fullScreenName }" breadCrumbs="${breadCrumb }">
		<e:inputHidden id="GUAR_REJECT_RMK" name="GUAR_REJECT_RMK"/>
		
		<e:searchPanel id="form" title="${msg.M9999}" labelWidth="130" width="100%" columnCount="3" useTitleBar="true" onEnter="doSearch">
			<e:row>
				<%--계약일자, 종료일자--%>
				<e:label for="DATE_TYPE" title="${form_DATE_TYPE_N}"/>
				<e:field>
					<e:inputDate id="REG_DATE_FROM" toDate="REG_DATE_TO" name="REG_DATE_FROM" value="${fromDate }" width="${inputTextDate }" required="${form_REG_DATE_R }" readOnly="${form_REG_DATE_RO }" disabled="${form_REG_DATE_D }" datePicker="true" />
					<e:text>~</e:text>
					<e:inputDate id="REG_DATE_TO" fromDate="REG_DATE_FROM" name="REG_DATE_TO" value="${toDate }" width="${inputTextDate }" required="${form_REG_DATE_R }" readOnly="${form_REG_DATE_RO }" disabled="${form_REG_DATE_D }" datePicker="true" />
				</e:field>
				<%--고객사--%>
				<e:label for="PR_BUYER_CD" title="${form_PR_BUYER_CD_N}"/>
				<e:field>
					<e:search id="PR_BUYER_CD" name="PR_BUYER_CD" value="" width="40%" maxLength="${form_PR_BUYER_CD_M}" onIconClick="${form_PR_BUYER_CD_RO ? 'everCommon.blank' : 'getBuyer'}" disabled="${form_PR_BUYER_CD_D}" readOnly="${form_PR_BUYER_CD_RO}" required="${form_PR_BUYER_CD_R}" maskType="${form_PR_BUYER_CD_MT}" placeHolder="회사코드" />
					<e:inputText id="PR_BUYER_NM" name="PR_BUYER_NM" value="" width="60%" maxLength="${form_PR_BUYER_NM_M}" disabled="${form_PR_BUYER_NM_D}" readOnly="${form_PR_BUYER_NM_RO}" required="${form_PR_BUYER_NM_R}" style="${imeMode}" maskType="${form_PR_BUYER_NM_MT}" placeHolder="회사명"/>
				</e:field>
				<%--계약부서명--%>
				<e:label for="PR_DEPT_CD" title="${form_PR_DEPT_CD_N}"/>
				<e:field>
					<e:search id="PR_DEPT_CD" name="PR_DEPT_CD" value="" width="40%" maxLength="${form_PR_DEPT_CD_M}" onIconClick="${form_PR_DEPT_CD_RO ? 'everCommon.blank' : 'getDept'}" disabled="${form_PR_DEPT_CD_D}" readOnly="${form_PR_DEPT_CD_RO}" required="${form_PR_DEPT_CD_R}" maskType="${form_PR_DEPT_CD_MT}" placeHolder="부서코드" />
					<e:inputText id="PR_DEPT_NM" name="PR_DEPT_NM" value="" width="60%" maxLength="${form_PR_DEPT_NM_M}" disabled="${form_PR_DEPT_NM_D}" readOnly="${form_PR_DEPT_NM_RO}" required="${form_PR_DEPT_NM_R}" style="${imeMode}" maskType="${form_PR_DEPT_NM_MT}" placeHolder="부서명"/>
				</e:field>
			</e:row>
            <e:row>
				<%--계약담당자--%>
				<e:label for="CONT_USER_ID" title="${form_CONT_USER_ID_N}"/>
				<e:field>
					<e:search id="CONT_USER_ID" name="CONT_USER_ID" value="" width="40%" maxLength="${form_CONT_USER_ID_M}" onIconClick="${form_CONT_USER_ID_RO ? 'everCommon.blank' : 'getCtrlUser'}" disabled="${form_CONT_USER_ID_D}" readOnly="${form_CONT_USER_ID_RO}" required="${form_CONT_USER_ID_R}" maskType="${form_CONT_USER_ID_MT}" placeHolder="개인번호" />
					<e:inputText id="CONT_USER_NM" name="CONT_USER_NM" value="" width="60%" maxLength="${form_CONT_USER_NM_M}" disabled="${form_CONT_USER_NM_D}" readOnly="${form_CONT_USER_NM_RO}" required="${form_CONT_USER_NM_R}" style="${imeMode}" maskType="${form_CONT_USER_NM_MT}" placeHolder="성명"/>
				</e:field>
				<%--계약번호/명--%>
				<e:label for="CONT_NUM" title="${form_CONT_NUM_N}" />
				<e:field>
					<e:inputText id="CONT_NUM" name="CONT_NUM" value="" width="${form_CONT_NUM_W}" maxLength="${form_CONT_NUM_M}" disabled="${form_CONT_NUM_D}" readOnly="${form_CONT_NUM_RO}" required="${form_CONT_NUM_R}" style="${imeMode}" maskType="${form_CONT_NUM_MT}"/>
				</e:field>
				<%--협력업체--%>
				<e:label for="VENDOR_CD" title="${form_VENDOR_CD_N}"/>
				<e:field>
					<e:search id="VENDOR_CD" name="VENDOR_CD" value="" width="40%" maxLength="${form_VENDOR_CD_M}" onIconClick="${form_VENDOR_CD_RO ? 'everCommon.blank' : 'getVendor'}" disabled="${form_VENDOR_CD_D}" readOnly="${form_VENDOR_CD_RO}" required="${form_VENDOR_CD_R}" maskType="${form_VENDOR_CD_MT}" placeHolder="회사코드" />
					<e:inputText id="VENDOR_NM" name="VENDOR_NM" value="" width="60%" maxLength="${form_VENDOR_NM_M}" disabled="${form_VENDOR_NM_D}" readOnly="${form_VENDOR_NM_RO}" required="${form_VENDOR_NM_R}" style="${imeMode}" maskType="${form_VENDOR_NM_MT}" placeHolder="회사명"/>
				</e:field>
            </e:row>
			<e:row>
				<%--보증구분--%>
				<e:label for="GUAR_TYPE" title="${form_GUAR_TYPE_N}"/>
				<e:field>
					<e:select id="GUAR_TYPE" name="GUAR_TYPE" value="" options="${guarTypeOptions}" width="${form_GUAR_TYPE_W}" disabled="${form_CONT_TYPE_D}" readOnly="${form_CONT_TYPE_RO}" required="${form_GUAR_TYPE_R}" placeHolder="" maskType="${form_GUAR_TYPE_MT}" />
				</e:field>
				<%--보증기관--%>
				<e:label for="GUARANTEER" title="${form_GUARANTEER_N}"/>
				<e:field>
					<e:select id="GUARANTEER" name="GUARANTEER" value="" options="${guaranteerOptions}" width="${form_GUARANTEER_W}" disabled="${form_CONT_REQ_CD_D}" readOnly="${form_GUARANTEER_RO}" required="${form_GUARANTEER_R}" placeHolder="" maskType="${form_GUARANTEER_MT}" />
				</e:field>
				<%--진행상태--%>
				<e:label for="GUAR_CANCEL_STATUS" title="${form_GUAR_CANCEL_STATUS_N}"/>
				<e:field>
					<e:select id="GUAR_CANCEL_STATUS" name="GUAR_CANCEL_STATUS" value="" options="${guarCancelStatusOptions}" width="${form_GUAR_CANCEL_STATUS_W}" disabled="${form_GUAR_CANCEL_STATUS_D}" readOnly="${form_GUAR_CANCEL_STATUS_RO}" required="${form_GUAR_CANCEL_STATUS_R}" placeHolder="" maskType="${form_GUAR_CANCEL_STATUS_MT}"/>
				</e:field>
			</e:row>
		</e:searchPanel>
		
		<e:buttonBar id="buttonBar" align="right" width="100%">
			<e:button id="doSearch" name="doSearch" icon="search" label="${doSearch_N }" disabled="${doSearch_D }" onClick="doSearch" />
			<e:button id="doConfirm" name="doConfirm" label="${doConfirm_N}" onClick="doConfirm" disabled="${doConfirm_D}" visible="${doConfirm_V}"/>
			<e:button id="doReject" name="doReject" label="${doReject_N}" onClick="doReject" disabled="${doReject_D}" visible="${doReject_V}"/>
		</e:buttonBar>
		
		<e:gridPanel id="grid" name="grid" gridType="${_gridType}" width="100%" height="fit"/>
	</e:window>
</e:ui>
