<%@ page import="com.st_ones.everf.serverside.config.PropertiesManager" %>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="/WEB-INF/views/common/ozUrlInfo.jsp" %>


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
	<script type="text/javascript">
		var grid = {};
		var baseUrl = "/nhepro/SCTR/SCTR0010";

		function init() {

			grid = EVF.getComponent("grid");
			grid.setProperty('panelVisible', ${panelVisible});

			grid.cellClickEvent(function(rowIdx, colIdx, value) {
				var param;
				var buyerCd   = grid.getCellValue(rowIdx, "BUYER_CD");
				var contNum   = grid.getCellValue(rowIdx, "CONT_NUM");
				var contCnt   = grid.getCellValue(rowIdx, "CONT_CNT");
				var prBuyerCd = grid.getCellValue(rowIdx, "PR_BUYER_CD"); 	//PY_BUYER_CD
				var prDeptCd  = grid.getCellValue(rowIdx, "PR_DEPT_CD");  	//PY_DEPT_CD
				var vendorCd  = "${ses.companyCd}";

				param = {
					BUYER_CD: buyerCd,
					CONT_NUM: contNum,
					CONT_CNT: contCnt,
					PR_BUYER_CD: prBuyerCd,
					PR_DEPT_CD: prDeptCd,
					VENDOR_CD: vendorCd,
					detailView: true,
					GUAR_APP_FLAG: true
				};
				
				// 2021.02.08 작성중인 계약서 추가
				switch (colIdx) {
					case 'CONT_NUM':
						var progressCd = grid.getCellValue(rowIdx, "PROGRESS_CD");
						param = {
								callBackFunction : 'doSearch',
								GATE_CD : grid.getCellValue(rowIdx, "GATE_CD"),
								BUYER_CD: buyerCd,
								CONT_NUM : contNum,
								CONT_CNT : contCnt,
								PR_BUYER_CD: prBuyerCd,
								PR_DEPT_CD: prDeptCd,
								baseDataType : 'manualContract',
								contractEditable : true,
								detailView : (progressCd == '4210') ? false : true
						};
						openContractDetail(param);
						break;
						
					case 'ATT_FILE_CNT':
						if(Number(value) > 0) {
							param = {
								attFileNum: grid.getCellValue(rowIdx, 'ATT_FILE_NUM'),
								rowIdx: rowIdx,
								bizType: 'EC',
								detailView: true
							};
							everPopup.fileAttachPopup(param);
						}
						break;
						
                    case 'VENDOR_ATT_FILE_CNT':
                    	/*
                    	if(grid.getCellValue(rowIdx, "PROGRESS_CD") != '4210') {
                    		return EVF.alert("진행상태가 서명대기인 상태에서만 협력업체 첨부파일이 가능합니다.");
						}

                    	grid.checkEqualRow(["CONT_NUM", "CONT_CNT"], [grid.getCellValue(rowIdx, "CONT_NUM"), grid.getCellValue(rowIdx, "CONT_CNT")]);
						*/
						if(Number(value) > 0) {
							param = {
								attFileNum: grid.getCellValue(rowIdx, 'VENDOR_ATT_FILE_NUM'),
								rowIdx: rowIdx,
								callBackFunction: 'setFileAttach',
								bizType: 'EC',
								fileExtension: '*',
								detailView: true
							};
							everPopup.fileAttachPopup(param);
						}
						break;

					case "GUAR_CNT":
						if(value != 0) {
							everPopup.openPopupByScreenId("CCTR0051", 1100, 450, param);
						}
						break;
						
					case "ADV_GUAR_CNT":
						if(value != 0) {
							everPopup.openPopupByScreenId("CCTR0052", 1180, 450, param);
						}
						break;
						
					case "WARR_GUAR_CNT":
						if(value != 0) {
							everPopup.openPopupByScreenId("CCTR0053", 1180, 450, param);
						}
						break;
						
					case "DI_GUAR_CNT":
						if(value != 0) {
							everPopup.openPopupByScreenId("CCTR0054", 542, 330, param);
						}
						break;

                    case 'CONT_CLOSE_RMK':
                    	if(value != '') {
                    		param = {
                    				rowIdx : rowIdx,
                    				title : '강제종결사유',
                    				message : grid.getCellValue(rowIdx, 'CONT_CLOSE_RMK'),
                    				detailView : true
                    			};
                    		everPopup.commonTextInput(param);
                    	}
                    	break;
                    	
					default:
						return;
				}
			});

			grid.excelExportEvent({
				allCol : "${excelExport.allCol}",
				selRow : "${excelExport.selRow}",
				fileType : "${excelExport.fileType }",
				fileName : "${screenName }"
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

			doSearch();
		}

		function setFileAttach(rowIdx, fileId, fileCnt) {
			var selRowIdx = grid.getSelRowId();

			for(var i in selRowIdx) {
				grid.setCellValue(selRowIdx[i], 'VENDOR_ATT_FILE_CNT', fileCnt);
				grid.setCellValue(selRowIdx[i], 'VENDOR_ATT_FILE_NUM', fileId);
			}
		}

		function doSearch() {
			var store = new EVF.Store();
			if (!store.validate()) {
				return;
			}

			store.setGrid([ grid ]);
			store.load(baseUrl + '/sctr0010_doSearch.so', function() {
				if (grid.getRowCount() == 0) {
					EVF.alert("${msg.M0002 }");
				}
				colMerge();
				grid.setColIconify("CONT_CLOSE_RMK", "CONT_CLOSE_RMK", "comment", false);
			});
		}

		function colMerge() {
			grid.setColMerge(["CONT_NUM", "CONT_CNT", "PROGRESS_CD", "FINISH_FLAG", "AUTO_RENEW_FLAG", "CONT_DESC", "CONT_REQ_CD", "CONT_DATE", "CONT_START_DATE", "CONT_END_DATE", "SIGN_DATE", "CONTRACT_NM"]);
			grid.setColMerge(["CONT_NUM", "CONT_CNT", "ATT_FILE_CNT", "VENDOR_ATT_FILE_CNT", "CONT_CLOSE_DATE", "CONT_CLOSE_RMK"]);
		}

		function openContractDetail(params) {
            // var url = '/eversrm/eContract/eContractMgt/SECM_030/view.so';
            var url = "/nhepro/SCTR/SCTR0011/view.so";
            everPopup.openWindowPopup(url, 1200, 1080, params, 'openContractChangeInformation');
		}

		function doPrint() {
			
			if(!grid.isExistsSelRow()) { return alert('${msg.M0004}'); }
			if(grid.getSelRowId().length > 1) { return alert("${msg.M0006}"); }

			var selRowValue = grid.getSelRowValue()[0];

			var url = "/common/file/fileAttach/viewPdf.so?EVER_REQUEST_DATA_TYPE=FILE_DOWNLOAD&UUID=" + selRowValue.PDF_ATT_FILE_NUM;
			window.open(url, "eform", "width=850,height=1265,scrollbars=yes,resizeable=no,left=0,top=0");

			<%--
			var gridData = grid.getSelRowValue();
			if (gridData.length > 1) {
				EVF.alert("${msg.M0006}");
				return;
			} else if (gridData.length == 0) {
				EVF.alert('${msg.M0004 }');
				return;
			}

			var param = {
					contNum : gridData[0]['CONT_NUM'],
					contCnt : gridData[0]['CONT_CNT'],
					progressCd : gridData[0]['PROGRESS_CD'],
					CONTRACT_TEXT_NUM : gridData[0]['CONTRACT_TEXT_NUM'],
                	contents: '',
                	callBackFunction: '',
                	detailView: false
                };
                // everPopup.openPopupByScreenId('BECM_060', 1000, 800, param);
                everPopup.openPopupByScreenId('SCTR0012', 1000, 800, param);
			--%>
		}

		// 보증서 첨부 저장
	    function doGurSave() {
	      	var store = new EVF.Store();
	      	if (!grid.isExistsSelRow()) { return alert('${msg.M0004}'); }

	      	// Grid Validation Check
	      	if(!grid.validate().flag) {
	        	return EVF.alert("${msg.M0014}");
	      	}

		    store.doFileUpload(function() {
			    store.setGrid([grid]);
			    store.getGridData(grid, 'sel');
			    EVF.confirm("${msg.M0021}", function () {
				    store.load(baseUrl + '/sctr0010_doGurSave.so', function() {
					    EVF.alert("${msg.M0031}", function() {
						    doSearch();
					    });
				    });
			    });
		    });
		}

		function doPdfValid() {
			if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
			if (grid.getSelRowCount() > 1) { return EVF.alert('${msg.M0006}'); }

			var selRowId = grid.getSelRowId();
			for(var i in selRowId) {
				if (grid.getCellValue(selRowId[i], "PROGRESS_CD") != '4230') {
					return EVF.alert("서명완료 된 PDF만 검증하실 수 있습니다.");
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
		}
	</script>

	<e:window id="SCTR0010" onReady="init" initData="${initData}" title="${fullScreenName }" breadCrumbs="${breadCrumb }">
		<e:searchPanel id="form" title="${msg.M9999 }" columnCount="3" labelWidth="130" onEnter="doSearch" useTitleBar="false">

			<e:inputHidden id="CLOSING_PROGRESS_CD" name="CLOSING_PROGRESS_CD" value="" />
			<e:inputHidden id="CLOSING_REQ_USER_TYPE" name="CLOSING_REQ_USER_TYPE" value="" />

			<e:row>
				<%-- 계약진행현황 --%>
				<e:label for="REG_DATE" title="${form_REG_DATE_N }" />
				<e:field>
					<e:inputDate id="REG_DATE_FROM" toDate="REG_DATE_TO" name="REG_DATE_FROM" value="${fromDate }" width="${inputTextDate }" required="${form_REG_DATE_R }" readOnly="${form_REG_DATE_RO }" disabled="${form_REG_DATE_D }" datePicker="true" />
					<e:text>~</e:text>
					<e:inputDate id="REG_DATE_TO" fromDate="REG_DATE_FROM" name="REG_DATE_TO" value="${toDate }" width="${inputTextDate }" required="${form_REG_DATE_R }" readOnly="${form_REG_DATE_RO }" disabled="${form_REG_DATE_D }" datePicker="true" />
				</e:field>
				<%-- 고객사 --%>
				<e:label for="PR_BUYER_DEPT_NM" title="${form_PR_BUYER_DEPT_NM_N}" />
				<e:field>
					<e:inputText id="PR_BUYER_DEPT_NM" name="PR_BUYER_DEPT_NM" value="" width="${form_PR_BUYER_DEPT_NM_W}" maxLength="${form_PR_BUYER_DEPT_NM_M}" disabled="${form_PR_BUYER_DEPT_NM_D}" readOnly="${form_PR_BUYER_DEPT_NM_RO}" required="${form_PR_BUYER_DEPT_NM_R}" style="${imeMode}" maskType="${form_PR_BUYER_DEPT_NM_MT}"/>
				</e:field>
				<%-- 계약번호/명 --%>
				<e:label for="CONT_DESC" title="${form_CONT_DESC_N}" />
				<e:field>
					<e:inputText id="CONT_DESC" name="CONT_DESC" value="" width="${form_CONT_DESC_W}" maxLength="${form_CONT_DESC_M}" disabled="${form_CONT_DESC_D}" readOnly="${form_CONT_DESC_RO}" required="${form_CONT_DESC_R}" style="${imeMode}" maskType="${form_CONT_DESC_MT}"/>
				</e:field>
			</e:row>
			<e:row>
				<%-- 계약구분 --%>
				<e:label for="CONT_REQ_CD" title="${form_CONT_REQ_CD_N}"/>
				<e:field>
					<e:select id="CONT_REQ_CD" name="CONT_REQ_CD" value="" options="${contReqCdOptions}" width="${form_CONT_REQ_CD_W}" disabled="${form_CONT_REQ_CD_D}" readOnly="${form_CONT_REQ_CD_RO}" required="${form_CONT_REQ_CD_R}" placeHolder="" maskType="${form_CONT_REQ_CD_MT}" />
				</e:field>
				<%-- 계약담당자 --%>
				<e:label for="USER_NM" title="${form_USER_NM_N}" />
				<e:field>
					<e:inputText id="USER_NM" name="USER_NM" value="" width="${form_USER_NM_W}" maxLength="${form_USER_NM_M}" disabled="${form_USER_NM_D}" readOnly="${form_USER_NM_RO}" required="${form_USER_NM_R}" style="${imeMode}" maskType="${form_USER_NM_MT}"/>
				</e:field>
				<%-- 진행상태 --%>
				<e:label for="PROGRESS_CD" title="${form_PROGRESS_CD_N}"/>
				<e:field>
					<e:select id="PROGRESS_CD" name="PROGRESS_CD" value="" options="${progressCdOptions}" width="${form_PROGRESS_CD_W}" disabled="${form_PROGRESS_CD_D}" readOnly="${form_PROGRESS_CD_RO}" required="${form_PROGRESS_CD_R}" placeHolder="" maskType="${form_PROGRESS_CD_MT}" useMultipleSelect="true"/>
				</e:field>
			</e:row>
			<e:row>
				<%-- 자동갱신 --%>
				<e:label for="AUTO_RENEW_FLAG" title="${form_AUTO_RENEW_FLAG_N}"/>
				<e:field>
					<e:select id="st_AUTO_RENEW_FLAG" name="st_AUTO_RENEW_FLAG" value="${st_default}" width="${everMultiWidth}" options="${searchTerms}" disabled="false" readOnly="false" required="false" visible="${everMultiVisible}" />
					<e:select id="AUTO_RENEW_FLAG" name="AUTO_RENEW_FLAG" value="" options="${autoRenewFlagOptions}" width="${form_AUTO_RENEW_FLAG_W}" disabled="${form_AUTO_RENEW_FLAG_D}" readOnly="${form_AUTO_RENEW_FLAG_RO}" required="${form_AUTO_RENEW_FLAG_R}" placeHolder="" />
				</e:field>
				<%-- 종결여부 --%>
				<e:label for="CONT_END_FLAG" title="${form_CONT_END_FLAG_N}"/>
				<e:field>
					<e:select id="CONT_END_FLAG" name="CONT_END_FLAG" value="" options="${contEndFlagOptions}" width="${form_CONT_END_FLAG_W}" disabled="${form_CONT_END_FLAG_D}" readOnly="${form_CONT_END_FLAG_RO}" required="${form_CONT_END_FLAG_R}" placeHolder="" maskType="${form_CONT_END_FLAG_MT}" />
				</e:field>
				<e:field colSpan="2" />
			</e:row>
		</e:searchPanel>

		<e:buttonBar id="buttonBar" align="right" width="100%">
			<e:button id="doSearch" name="doSearch" icon="search" label="${doSearch_N }" disabled="${doSearch_D }" onClick="doSearch" />
			<%--<e:button id="doGurSave" name="doGurSave" label="${doGurSave_N}" onClick="doGurSave" disabled="${doGurSave_D}" visible="${doGurSave_V}" />--%>
			<e:button id="doPrint" name="doPrint" label="${doPrint_N}" onClick="doPrint" disabled="${doPrint_D}" visible="${doPrint_V}"/>
			<%--<e:button id="doPdfValid" name="doPdfValid" label="${doPdfValid_N}" onClick="doPdfValid" disabled="${doPdfValid_D}" visible="${doPdfValid_V}"/>--%>
		</e:buttonBar>

		<e:gridPanel gridType="${_gridType}" id="grid" name="grid" width="100%" height="fit" />

	</e:window>

</e:ui>