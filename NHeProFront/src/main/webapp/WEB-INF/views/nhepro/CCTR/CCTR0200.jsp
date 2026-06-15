<%--
  Date: 2020-04-17
  Time: 13:15:36
  Scrren ID : CCTR0200
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ page import="com.st_ones.everf.serverside.config.PropertiesManager" %>
<%@ include file="/WEB-INF/views/common/ozUrlInfo.jsp" %>

<!-- 2021.12.14 중앙회 요청 "계약담당자권한"을 갖는 사람은 다른계약담당자의 계약건을 변경계약서 작성가능하도록 ContAuthCd 추가  -->
<%
	String ozSchedulerIp = PropertiesManager.getString("oz.scheduler.ip");
	String ozSchedulerPort = PropertiesManager.getString("oz.scheduler.port");
%>

<c:set value="<%=ozExportUrl%>" var="ozExportUrl"/>
<c:set var="ozUrl" value="<%=ozUrl%>" />
<c:set var="ozServer" value="<%=ozServer%>" />
<c:set var="ozSchedulerIp" value="<%=ozSchedulerIp%>" />
<c:set var="ozSchedulerPort" value="<%=ozSchedulerPort%>" />

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
	<script type="text/javascript" src="/MagicLine4Web/ML4Web/js/ext/jquery.blockUI.js"></script>
	<!-- ML4WEB JS -->
	<script type="text/javascript" src="/MagicLine4Web/ML4Web/js/ext/ML_Config.js"></script>
	<script>

		var grid;
		var gridI;
		var baseUrl = "/nhepro/CCTR/CCTR0200";
		
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
		            
					case "CONT_CLOSE_RMK":
						if( value == "" ) return;
						param = {
							title : '계약체결 중단사유',
							message: value,
							detailView : true
						};
						everPopup.commonTextInput(param);
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

			// 계약체결 완료 삭제
			setType();

		    doSearch();
		}

		function setType() {
			setProgressCdOption();	// 진행상태 기본값 세팅
		}
		
		// 진행상태 기본값 세팅
		function setProgressCdOption(){
		var proNm = "";
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

		// Search
		function doSearch() {
			var store = new EVF.Store();

			if (!store.validate()) return;

			store.setGrid([grid]);
			store.load(baseUrl + "/cctr0200_doSearch.so", function () {
				if (grid.getRowCount() == 0) {
					return EVF.alert('${msg.M0002}');
				}
			});	
		}
			
		function doChoose() {

			if(grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }

			if (grid.getSelRowCount() > 1) { return EVF.alert("${msg.M0006}"); }

			var selectedData;
			var selData; var selRowIdx;
			var rowIds = grid.getSelRowId();
			for(var i in rowIds) {
				selData = grid.getRowValue(rowIds[i]);
			}
			selData.rowIdx = "${param.rowIdx}";
			selectedData = JSON.stringify(selData);
		
			if(${param.ModalPopup == true}){
				parent['${param.callBackFunction}'](selectedData);
			}else{
				opener['${param.callBackFunction}'](selectedData);
			}
			
		    doClose();
	    }

		function doClose() {
            EVF.closeWindow();
        }	
		
	</script>

	<e:window id="CCTR0200" initData="${initData}" onReady="init" title="${fullScreenName }" breadCrumbs="${breadCrumb }">
		<e:searchPanel id="form" title="${msg.M9999}" labelWidth="130" width="100%" columnCount="3" useTitleBar="true" onEnter="doSearch">
			<e:inputHidden id="BUNDLE_NUM" name="BUNDLE_NUM" />
			<e:inputHidden id="CONT_NUM_CNT" name="CONT_NUM_CNT" />
			<e:inputHidden id="CONT_CLOSE_RMK" name="CONT_CLOSE_RMK" />
			<e:inputHidden id="TYPE" name="TYPE" value="${param.TYPE}" />
			
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
			<%--계약체결 조건명--%>
            <e:row>
				<%--계약담당자--%>
				<e:label for="CONT_USER_ID" title="${form_CONT_USER_ID_N}"/>
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
			<e:row>
				<%--협력업체--%>
				<e:label for="VENDOR_CD" title="${form_VENDOR_CD_N}"/>
				<e:field>
					<e:search id="VENDOR_CD" name="VENDOR_CD" value="" width="40%" maxLength="${form_VENDOR_CD_M}" onIconClick="${form_VENDOR_CD_RO ? 'everCommon.blank' : 'getVendor'}" disabled="${form_VENDOR_CD_D}" readOnly="${form_VENDOR_CD_RO}" required="${form_VENDOR_CD_R}" maskType="${form_VENDOR_CD_MT}" placeHolder="회사코드" />
					<e:inputText id="VENDOR_NM" name="VENDOR_NM" value="" width="60%" maxLength="${form_VENDOR_NM_M}" disabled="${form_VENDOR_NM_D}" readOnly="${form_VENDOR_NM_RO}" required="${form_VENDOR_NM_R}" style="${imeMode}" maskType="${form_VENDOR_NM_MT}" placeHolder="회사명"/>
				</e:field>
				<%--서식명--%>
				<e:label for="FORM_NM" title="${form_FORM_NM_N}"/>
				<e:field>
					<e:inputText id="FORM_NM" name="FORM_NM" value="" width="${form_FORM_NM_W}" maxLength="${form_FORM_NM_M}" disabled="${form_FORM_NM_D}" readOnly="${form_FORM_NM_RO}" required="${form_FORM_NM_R}" style="${imeMode}" maskType="${form_FORM_NM_MT}"/>
				</e:field>
				<%--계약구분--%>
				<e:label for="CONT_REQ_CD" title="${form_CONT_REQ_CD_N}"/>
				<e:field>
					<e:select id="CONT_REQ_CD" name="CONT_REQ_CD" value="" options="${contReqCdOptions}" width="${form_CONT_REQ_CD_W}" disabled="${form_CONT_REQ_CD_D}" readOnly="${form_CONT_REQ_CD_RO}" required="${form_CONT_REQ_CD_R}" placeHolder="" maskType="${form_CONT_REQ_CD_MT}" />
				</e:field>
			</e:row>
			<e:row>
				<%--자동갱신여부--%>
				<e:label for="AUTO_RENEW_FLAG" title="${form_AUTO_RENEW_FLAG_N}"/>
				<e:field>
					<e:select id="AUTO_RENEW_FLAG" name="AUTO_RENEW_FLAG" value="" options="${autoRenewFlagOptions}" width="${form_AUTO_RENEW_FLAG_W}" disabled="${form_AUTO_RENEW_FLAG_D}" readOnly="${form_AUTO_RENEW_FLAG_RO}" required="${form_AUTO_RENEW_FLAG_R}" placeHolder="" maskType="${form_AUTO_RENEW_FLAG_MT}" />
				</e:field>
				<%--종결여부--%>
				<e:label for="FINISH_FLAG" title="${form_FINISH_FLAG_N}"/>
				<e:field>
					<e:select id="FINISH_FLAG" name="FINISH_FLAG" value="" options="${finishFlagOptions}" width="${form_FINISH_FLAG_W}" disabled="${form_FINISH_FLAG_D}" readOnly="${form_FINISH_FLAG_RO}" required="${form_FINISH_FLAG_R}" placeHolder="" maskType="${form_FINISH_FLAG_MT}" />
				</e:field>
				<e:label for="IF_TYPE" title="${form_IF_TYPE_N}"/>
				<e:field>
					<e:select id="IF_TYPE" name="IF_TYPE" value="" options="${ifTypeOptions}" width="${form_IF_TYPE_W}" disabled="${form_IF_TYPE_D}" readOnly="${form_IF_TYPE_RO}" required="${form_IF_TYPE_R}" placeHolder="" maskType="${form_IF_TYPE_MT}" />
				</e:field>
			</e:row>
		</e:searchPanel>
		
		<e:buttonBar id="buttonBar" align="right" width="100%">
			<e:button id="doSearch" name="doSearch" icon="search" label="${doSearch_N }" disabled="${doSearch_D }" onClick="doSearch" />
			<e:button id="doChoose" name="doChoose" label="${doChoose_N }" onClick="doChoose" disabled="${doChoose_D }" visible="${doChoose_V }"/>
		</e:buttonBar>
		<e:gridPanel id="grid" name="grid" gridType="${_gridType}" width="100%" height="fit"/>
		
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
