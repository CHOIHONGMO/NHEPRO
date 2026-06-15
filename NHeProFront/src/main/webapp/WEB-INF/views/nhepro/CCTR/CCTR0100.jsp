<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page import="com.st_ones.everf.serverside.config.PropertiesManager" %>

<!-- 2021.02.08 중앙회 요청 "관리자직무"를 갖는 사람은 담당자 변경 가능하도록 추가 -->
<% String ManagerCd = PropertiesManager.getString("eversrm.customer.admin.ManagerCd"); %>

<c:set var="ManagerCd" value="<%=ManagerCd%>" />

<e:ui>
	<script type="text/javascript">

		var grid = {};
		var baseUrl = "/nhepro/CCTR/CCTR0100";
		var selRow;
		var type = '${param.TYPE}'.substr(0, 1);
		var changeFlag = false;
		
		function init() {
			
			grid = EVF.C("grid");
			
			grid.setProperty('panelVisible', ${panelVisible});
			
			if(type == 'A'){
				grid.hideCol('SEND_DATE', true);
				grid.hideCol('PROGRESS_CD', true);
				grid.hideCol('PDF_ATT_FILE_CNT', true);
			}else{
				grid.hideCol('SEND_DATE', false);
				grid.hideCol('PROGRESS_CD', false);
				grid.hideCol('PDF_ATT_FILE_CNT', false);
			}
			
			grid.cellClickEvent(function (rowIdx, colId, value) {

				selRow = rowIdx;
				switch (colId) {
					case 'CONT_NUM':
						if(value != '') {
							var signStatus = grid.getCellValue(rowIdx, "SIGN_STATUS");
							var param = {
									callBackFunction: '',
									buyerCd: grid.getCellValue(rowIdx, "BUYER_CD"),
					                contNum: grid.getCellValue(rowIdx, "CONT_NUM"),
		                            contCnt: grid.getCellValue(rowIdx, "CONT_CNT"),
					                detailView: (signStatus=='P'||signStatus=='E'),
					            };
					        everPopup.openPopupByScreenId('CCTI0090', 1170, 800, param);
						}
						break;
					case 'PDF_ATT_FILE_CNT':
						if(value != '' && Number(value) > 0) {
							var pdfAttFileNum = grid.getCellValue(rowIdx, 'PDF_ATT_FILE_NUM');
							
							var url = "/common/file/fileAttach/viewPdf.so?EVER_REQUEST_DATA_TYPE=FILE_DOWNLOAD&UUID=" + pdfAttFileNum;
							window.open(url, "eform", "width=850,height=960,scrollbars=yes,resizeable=no,left=0,top=0");
							
							/* param = {
									bizType: 'EC',
									attFileNum: pdfAttFileNum,
									detailView: true
									};
							everPopup.fileAttachPopup(param); */
						}
						else {
							return EVF.alert("${CCTR0100_013}");
						}
						break;
					case 'STOP_RMK':
						if(value != '') {
							var param = {
								callbackFunction : '',
								rowId : rowIdx,
								title : '계약체결 중단사유',
								message : grid.getCellValue(rowIdx, 'STOP_RMK'),
								detailView : true
							};
							everPopup.commonTextInput(param);
						}
						break;
				}
			});

			grid.excelExportEvent({
				allCol: "${excelExport.allCol}",
				fileName: "${screenName }"
			});

			setType();
			
			// 2021.02.08 중앙회 요청 "관리자직무"를 갖는 사람은 담당자 변경 가능하도록 추가
		    if ("${ses.ctrlCd}".indexOf("${ManagerCd}") > -1) {
		    	changeFlag = true;
            }
			
			// 2020.12.02 자동조회 추가
			doSearch();
		}

		function setType() {
			var proNm = "";
			var signNm = "";
			// PROGRESS_CD : 진행상태, SIGN_STATUS : 결재상태
			if(type == 'A') {
				$('input[name=multiselect_PROGRESS_CD]').each(function (k, v) {
					if(v.value == '100') {
						proNm += v.title + ", ";
						v.checked = true;
					} else {
						$(v).parent().remove();
					}
				});
				$('#PROGRESS_CD').next().find('span, .e-select-text').text(proNm.substr(0, proNm.length - 2));
				EVF.C('PROGRESS_CD').setReadOnly(true);
				grid.hideCol('SIGN_DATE', true);
			} else {
				$('input[name=multiselect_PROGRESS_CD]').each(function (k, v) {
					if(v.value == '200' || v.value == '300') {
						proNm += v.title + ", ";
						v.checked = true;
					} else {
						$(v).parent().remove();
					}
				});
				$('#PROGRESS_CD').next().find('span, .e-select-text').text(proNm.substr(0, proNm.length - 2));

				$('input[name=multiselect_SIGN_STATUS]').each(function (k, v) {
					if(v.value == 'E') {
						signNm += v.title + ", ";
						v.checked = true;
					} else {
						$(v).parent().remove();
					}
				});
				$('#SIGN_STATUS').next().find('span, .e-select-text').text(signNm.substr(0, signNm.length - 2));
				EVF.C('SIGN_STATUS').setReadOnly(true);
			}
		}
		
		// 계약체결현황 조회
		function doSearch() {
			var store = new EVF.Store();
			if (!store.validate()) {
				return;
			}

			if (!everDate.fromTodateValid('REG_FROM_DATE', 'REG_TO_DATE', '${ses.dateFormat }')) {
				return EVF.alert('${msg.M0073}');
			}

			store.setGrid([grid]);
			store.load(baseUrl + '/doSearch.so', function () {
				if (grid.getRowCount() == 0) {
					EVF.alert("${msg.M0002 }");
				} else {
		        	grid.setColIconify("STOP_RMK", "STOP_RMK", "comment", false);
		        }
				grid.setColMerge(['BUYER_CD','CONT_NUM','CONT_CNT','CONT_DESC','BUYER_NM','CONT_USER_ID','CONT_USER_NM','DEPT_CD','DEPT_NM','SIGN_STATUS','SEND_DATE']);
			});
		}
		
		// 전자서명요청 mail/sms 전송
		function doSend() {
			
			var confirmMsg = "${CCTR0100_006 }";
			
			if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
			
			// 2021.07.01 : 전자서명요청은 여러건 동시에 가능하도록 변경
			//if (grid.getSelRowCount() > 1) { return EVF.alert('${msg.M0006}'); }
			
			var selRowId = grid.getSelRowId();
            for(var i in selRowId) {
            	if (!${havePermission} && grid.getCellValue(selRowId[i], "CONT_USER_ID") != '${ses.userId}') {
                    return EVF.alert("${msg.M0008}"); // 계약담당자건만 처리 가능함
                }
            	if (grid.getCellValue(selRowId[i], "SIGN_STATUS") != 'E' || grid.getCellValue(selRowId[i], "PROGRESS_CD") != 100) {
                    return EVF.alert("${CCTR0100_005}"); // 계약대기인 건만 전자서명 요청할 수 있음
                }
            	if (grid.getCellValue(selRowId[i], "SEND_YN") == '1') {
            		confirmMsg = "선택한 건 중 전송완료 건이 있습니다.\n전자서명 완료한 건을 포함하여 전자서명 요청 하시겠습니까?";
                }
            }
            
			var store = new EVF.Store();
			EVF.confirm(confirmMsg, function () {
        	//EVF.confirm('${CCTR0100_006}', function () {
				store.setGrid([grid]);
				store.getGridData(grid, 'sel');
				store.load(baseUrl+'/doRequest.so', function() {
					EVF.alert(this.getResponseMessage(), function () {
						doSearch();
					});
				});
			});
        }
		
		// 재계약서 작성
		function doResume() {

			if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
			if (grid.getSelRowCount() > 1) { return EVF.alert('${msg.M0006}'); }
			
			var curDate = '${toDate}';
			var arrayUserInfo = []; 
			var selRowId = grid.getSelRowId();
            for(var i in selRowId) {
            	if (!${havePermission} && grid.getCellValue(selRowId[i], "CONT_USER_ID") != '${ses.userId}') {
                    return EVF.alert("${msg.M0008}"); // 계약담당자건만 처리 가능함
                }
            	
            	if (grid.getCellValue(selRowId[i], "PROGRESS_CD") != 200) {
                    return EVF.alert("${CCTR0100_001}"); // 계약완료건만 재계약 가능
                }

				if (grid.getCellValue(selRowId[i], "USER_DEL_FLAG") != '0') {
					<%-- 선택한 개인근로자는 시스템 장기 미접속으로 인해 사용자 정보가 삭제되었습니다.\n\n재계약 처리를 위해서 회원가입 절차를 진행하셔야 합니다.\n\n개인근로자명 :  --%>
					return EVF.alert("${CCTR0100_008}" + grid.getCellValue(selRowId[i], "WORKER_NM"));
				}
            	
            	var contStartDate = "";
            	var contEndDate   = grid.getCellValue(selRowId[i], 'WORKER_CONT_END_DATE');
            	if( !EVF.isEmpty(contEndDate) && contEndDate.length == 8 ){
            		contEndDate = Number(contEndDate.substring(0, 4)) + "/" + contEndDate.substring(4, 6) + "/" + contEndDate.substring(6, 8);
                	contStartDate = date_add(contEndDate, 1);
            	}
            	
            	var userInfo = {
	           			'USER_ID' : grid.getCellValue(selRowId[i], 'WORKER_ID'),
	        			'USER_NM' : grid.getCellValue(selRowId[i], 'WORKER_NM'),
	        			'GENDER'  : grid.getCellValue(selRowId[i], 'GENDER'),
	        			'WORKER_DEPT_NM' : grid.getCellValue(selRowId[i], 'WORKER_DEPT_NM'),
	        			'WORKER_JOB_NM' : grid.getCellValue(selRowId[i], 'WORKER_JOB_NM'),
	        			'WORKER_CONT_DATE' : curDate,
	        			'WORKER_CONT_START_DATE' : contStartDate,
	        			'SITE_USER_NM' : grid.getCellValue(selRowId[i], 'SITE_USER_NM')
	           		}
            	arrayUserInfo.push(userInfo);
            }
			
            var param = {
					userInfo  : JSON.stringify(arrayUserInfo),
                    detailView: false,
				};
			everPopup.openPopupByScreenId('CCTI0090', 1170, 800, param);
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

		// 계약체결중단
		function doStop() {

			if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
			if (grid.getSelRowCount() > 1) { return EVF.alert('${msg.M0006}'); }
			
            var selRowId = grid.getSelRowId();
            for(var i in selRowId) {
            	if (!${havePermission} && grid.getCellValue(selRowId[i], "CONT_USER_ID") != '${ses.userId}') {
                    return EVF.alert("${msg.M0008}"); // 계약담당자건만 처리 가능함
                }
            	var progressCd = grid.getCellValue(selRowId[i], "PROGRESS_CD");
                if (grid.getCellValue(selRowId[i], "SIGN_STATUS") != 'E' || grid.getCellValue(selRowId[i], "PROGRESS_CD") != 100) {
                    return EVF.alert("${CCTR0100_003}"); // 계약진행중인건만 중단가능
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
        		EVF.V("CONT_CLOSE_RMK", data.message);
        	}
        	
        	EVF.confirm('${CCTR0100_004}', function () {
				store.setGrid([grid]);
				store.getGridData(grid, 'sel');
				store.load(baseUrl+'/doStop.so', function() {
					EVF.alert(this.getResponseMessage(), function () {
						doSearch();
					});
				});
			});
        }
		
		//고객사
		function onIconClickBUYER_CD() {
            var param = {
                'callBackFunction': 'callBackBUYER_CD',
                'READONLY': 'Y',		//팝업 조회조건 변경불가
				'multiYN' : 'N',        //멀티팝업여부
				'detailView': false
            };
            everPopup.openPopupByScreenId("CCDU0010", 1000, 700, param);
        }

        function callBackBUYER_CD(data) {
            if(data!=null){
        		data = JSON.parse(data);
        		
        		EVF.V("BUYER_CD", data.CUST_CD);
        		EVF.V("BUYER_NM", data.CUST_NM);
        	}	
        }
        
        //계약담당자
		function getContUser() {

			var param = {
				'callBackFunction': 'setContUser',
				'READONLY': 'Y',		//팝업 조회조건 변경불가
				'multiYN' : 'N',         //멀티팝업여부
				'detailView': false
			};
			everPopup.openPopupByScreenId("CCDU0020", 1100, 700, param);
		}

		function setContUser(data) {
			if(data!=null){
        		data = JSON.parse(data);
        		
        		EVF.V("CONT_USER_ID", data.USER_ID);
        		EVF.V("CONT_USER_NM", data.USER_NM);
        	}
		}
		
		function cleanUserId() {
			EVF.V("CONT_USER_ID", "");
		}
		
		//부서
		function getDeptInfo() {
			var param = {
				'callBackFunction': 'setDeptInfo',
				'READONLY': 'Y',           //팝업 조회조건 변경불가
				'multiYN' : 'N',         //멀티팝업여부
				'detailView': false
			};
			everPopup.openPopupByScreenId("CCDU0010", 1000, 700, param);
		}
		
		function setDeptInfo(data) {
			if(data!=null){
        		data = JSON.parse(data);
        		
        		EVF.V("DEPT_CD", data.DEPT_CD);
        		EVF.V("DEPT_NM", data.DEPT_NM);
        	}
		}
		
		function getContWorker() {
			var param = {
				callBackFunction: "setContWorker",
				GATE_CD: '${ses.gateCd}'
			};
			everPopup.openCommonPopup(param, 'SP0092');
		}

		function setContWorker(data) {
			EVF.V("WORKER_USER_ID", data.USER_ID);
			EVF.V("WORKER_USER_NM", data.USER_NM);
		}

		// 담당자변경
		function getDrafter() {
			var param = {
					'callBackFunction': 'setDrafter',
					'READONLY': 'Y',         //팝업 조회조건 변경불가
					'multiYN' : 'N',         //멀티팝업여부
					'detailView': false
				};
			everPopup.openPopupByScreenId("CCDU0020", 1100, 700, param);
		}

		function setDrafter(drafter) {
			if(data!=null){
        		data = JSON.parse(data);
				EVF.V("CHNG_USER_ID", drafter.USER_ID);
				EVF.V("CHNG_USER_NM", drafter.USER_NM);
			}
		}

		function doChangeContUser() {

			if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
			if (grid.getSelRowCount() > 1) { return EVF.alert('${msg.M0006}'); }

			var selRowId = grid.getSelRowId();
			for(var i in selRowId) {
				
				// 2021.02.08 중앙회 요청 "관리자직무"를 갖는 사람은 담당자 변경 가능하도록 추가
				if(!changeFlag) {
					if (!${havePermission} && grid.getCellValue(selRowId[i], "CONT_USER_ID") != '${ses.userId}') {
						return EVF.alert("${msg.M0008}"); // 계약담당자건만 처리 가능함
					}
				}
			}

			if( EVF.V("CHNG_USER_ID") == "" ){
				return EVF.alert('${CCTR0100_009}'); // 변경할 계약 담당자가 선택되지 않았습니다.
			}

			var store = new EVF.Store();

			EVF.confirm('${CCTR0100_010}', function () {
				store.setGrid([grid]);
				store.getGridData(grid, 'sel');
				store.load(baseUrl+'/changeContUser.so', function() {
					EVF.alert(this.getResponseMessage(), function () {
						doSearch();
					});
				});
			});
		}

		function doSendErp() {

			if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
			if (grid.getSelRowCount() > 1) { return EVF.alert('${msg.M0006}'); }

			var selRowId = grid.getSelRowId();
			for(var i in selRowId) {
				if (grid.getCellValue(selRowId[i], "PROGRESS_CD") != '200') {
					return EVF.alert("${CCTR0100_011}");
				}
			}

			var store = new EVF.Store();

			EVF.confirm('${CCTR0100_012}', function () {
				store.setGrid([grid]);
				store.getGridData(grid, 'sel');
				store.load(baseUrl+'/doSendErp.so', function() {
					EVF.alert(this.getResponseMessage(), function () {
						doSearch();
					});
				});
			});
		}
	</script>

	<e:window id="CCTR0100" onReady="init" initData="${initData}" title="${fullScreenName }" breadCrumbs="${breadCrumb }">
		<e:searchPanel id="form" title="${msg.M9999 }" columnCount="3" labelWidth="130" onEnter="doSearch" useTitleBar="false">
			<e:inputHidden id="CONT_CLOSE_RMK" name="CONT_CLOSE_RMK" /> <!-- 계약체결중단사유 -->
			<e:row>
				<%--계약일자--%>
				<e:label for="REG_FROM_DATE" title="${form_REG_FROM_DATE_N}"/>
				<e:field>
					<e:inputDate id="REG_FROM_DATE" name="REG_FROM_DATE" toDate="REG_TO_DATE" value="${fromDate }" width="${inputDateWidth}" datePicker="true" required="${form_REG_FROM_DATE_R}" disabled="${form_REG_FROM_DATE_D}" readOnly="${form_REG_FROM_DATE_RO}" />
					<e:text>~</e:text>
					<e:inputDate id="REG_TO_DATE" name="REG_TO_DATE" fromDate="REG_FROM_DATE" value="${toDate }" width="${inputDateWidth}" datePicker="true" required="${form_REG_TO_DATE_R}" disabled="${form_REG_TO_DATE_D}" readOnly="${form_REG_TO_DATE_RO}" />
				</e:field>
				<%--회사--%>
				<e:label for="BUYER_CD" title="${form_BUYER_CD_N}"/>
                <e:field>
                    <e:search id="BUYER_CD" name="BUYER_CD" value="${ses.companyCd}" width="40%" maxLength="${form_BUYER_CD_M}" onIconClick="${form_BUYER_CD_RO ? 'everCommon.blank' : 'onIconClickBUYER_CD'}" disabled="${form_BUYER_CD_D}" readOnly="${form_BUYER_CD_RO}" required="${form_BUYER_CD_R}" maskType="${form_BUYER_CD_MT}" placeHolder="회사코드" />
                    <e:inputText id="BUYER_NM" name="BUYER_NM" value="${ses.companyNm}" width="60%" maxLength="${form_BUYER_NM_M}" disabled="${form_BUYER_NM_D}" readOnly="${form_BUYER_NM_RO}" required="${form_BUYER_NM_R}" style="${imeMode}" maskType="${form_BUYER_NM_MT}" placeHolder="회사명"/>
                </e:field>
				<%--계약부서--%>
				<e:label for="DEPT_CD" title="${form_DEPT_CD_N}"/>
				<e:field>
					<e:search id="DEPT_CD" name="DEPT_CD" value="" width="40%" maxLength="${form_DEPT_CD_M}" onIconClick="${form_DEPT_CD_RO ? 'everCommon.blank' : 'getDeptInfo'}" disabled="${form_DEPT_CD_D}" readOnly="${form_DEPT_CD_RO}" required="${form_DEPT_CD_R}" maskType="${form_DEPT_CD_MT}" placeHolder="부서코드" />
					<e:inputText id="DEPT_NM" name="DEPT_NM" value="" width="60%" maxLength="${form_DEPT_NM_M}" disabled="${form_DEPT_NM_D}" readOnly="${form_DEPT_NM_RO}" required="${form_DEPT_NM_R}" style="${imeMode}" maskType="${form_DEPT_NM_MT}" placeHolder="부서명"/>
				</e:field>
			</e:row>
			<e:row>
				<%--계약담당자--%>
				<e:label for="CONT_USER_ID" title="${form_CONT_USER_ID_N}"/>
				<e:field>
					<e:search id="CONT_USER_ID" name="CONT_USER_ID" value="" width="40%" maxLength="${form_CONT_USER_ID_M}" disabled="${form_CONT_USER_ID_D}" readOnly="${form_CONT_USER_ID_RO}" required="${form_CONT_USER_ID_R}" onIconClick="getContUser" placeHolder="개인번호" />
					<e:inputText id="CONT_USER_NM" name="CONT_USER_NM" value="" width="60%" maxLength="${form_CONT_USER_NM_M}" disabled="${form_CONT_USER_NM_D}" readOnly="${form_CONT_USER_NM_RO}" required="${form_CONT_USER_NM_R}" placeHolder="성명" />
				</e:field>
				<%--전자계약번호/명--%>
				<e:label for="CONT_DESC" title="${form_CONT_DESC_N}" />
				<e:field>
					<e:inputText id="CONT_DESC" name="CONT_DESC" value="" width="${form_CONT_DESC_W}" maxLength="${form_CONT_DESC_M}" disabled="${form_CONT_DESC_D}" readOnly="${form_CONT_DESC_RO}" required="${form_CONT_DESC_R}"  maskType="${form_CONT_DESC_MT}" />
				</e:field>
				<%--진행상태--%>
				<e:label for="PROGRESS_CD" title="${form_PROGRESS_CD_N}"/>
				<e:field>
					<e:select id="PROGRESS_CD" name="PROGRESS_CD" value="" options="${progressCdOptions}" width="${form_PROGRESS_CD_W}" disabled="${form_PROGRESS_CD_D}" readOnly="${form_PROGRESS_CD_RO}" required="${form_PROGRESS_CD_R}" placeHolder="" useMultipleSelect="true" maskType="${form_PROGRESS_CD_MT}"/>
				</e:field>
			</e:row>
			<e:row>
				<%--근로자명--%>
				<e:label for="WORKER_USER_ID" title="${form_WORKER_USER_ID_N}"/>
				<e:field>
					<e:search id="WORKER_USER_ID" name="WORKER_USER_ID" value="" width="40%" maxLength="${form_WORKER_USER_ID_M}" disabled="${form_WORKER_USER_ID_D}" readOnly="${form_WORKER_USER_ID_RO}" required="${form_WORKER_USER_ID_R}" onIconClick="getContWorker" placeHolder="아이디" />
					<e:inputText id="WORKER_USER_NM" name="WORKER_USER_NM" value="" width="60%" maxLength="${form_WORKER_USER_NM_M}" disabled="${form_WORKER_USER_NM_D}" readOnly="${form_WORKER_USER_NM_RO}" required="${form_WORKER_USER_NM_R}" placeHolder="성명" />
				</e:field>
				<%--소속부서--%>
				<e:label for="WORKER_DEPT_NM" title="${form_WORKER_DEPT_NM_N}" />
				<e:field>
					<e:inputText id="WORKER_DEPT_NM" name="WORKER_DEPT_NM" value="" width="${form_WORKER_DEPT_NM_W}" maxLength="${form_WORKER_DEPT_NM_M}" disabled="${form_WORKER_DEPT_NM_D}" readOnly="${form_WORKER_DEPT_NM_RO}" required="${form_WORKER_DEPT_NM_R}"  maskType="${form_WORKER_DEPT_NM_MT}" />
				</e:field>
				<%--수행업무--%>
				<e:label for="WORKER_JOB_NM" title="${form_WORKER_JOB_NM_N}" />
				<e:field>
					<e:inputText id="WORKER_JOB_NM" name="WORKER_JOB_NM" value="" width="${form_WORKER_JOB_NM_W}" maxLength="${form_WORKER_JOB_NM_M}" disabled="${form_WORKER_JOB_NM_D}" readOnly="${form_WORKER_JOB_NM_RO}" required="${form_WORKER_JOB_NM_R}"  maskType="${form_WORKER_JOB_NM_MT}" />
				</e:field>
			</e:row>
			<c:if test="${fn:substring(param.TYPE, 0, 1) eq 'A'}">
			<e:row>
				<%--결재상태--%>
				<e:label for="SIGN_STATUS" title="${form_SIGN_STATUS_N}"/>
				<e:field>
					<e:select id="SIGN_STATUS" name="SIGN_STATUS" value="" options="${signStatusOptions}" width="${form_SIGN_STATUS_W}" disabled="${form_SIGN_STATUS_D}" readOnly="${form_SIGN_STATUS_RO}" required="${form_SIGN_STATUS_R}" placeHolder="" useMultipleSelect="true" maskType="${form_SIGN_STATUS_MT}"/>
				</e:field>
				<e:label for="" title=""/>
				<e:field> </e:field>
				<e:label for="" title=""/>
				<e:field> </e:field>
			</e:row>
			</c:if>
			<c:if test="${fn:substring(param.TYPE, 0, 1) eq 'B'}">
				<e:inputHidden id="SIGN_STATUS" name="SIGN_STATUS" value="E" />
			</c:if>
		</e:searchPanel>

		<e:buttonBar id="buttonBar" align="right" width="100%">
			<e:text style="color: blue;font-weight: bold;">■ 계약담당자 : </e:text>
			<e:inputHidden id="CHNG_USER_ID" name="CHNG_USER_ID" />
			<e:search id="CHNG_USER_NM" name="CHNG_USER_NM" value="" width="140" maxLength="${form_CHNG_USER_NM_M}" onIconClick="getDrafter" disabled="${form_CHNG_USER_NM_D}" readOnly="${form_CHNG_USER_NM_RO}" required="${form_CHNG_USER_NM_R}"  maskType="${form_CHNG_USER_NM_MT}" />
			<e:button id="doChangeContUser" name="doChangeContUser" label="${doChangeContUser_N}" onClick="doChangeContUser" disabled="${doChangeContUser_D}" visible="${doChangeContUser_V}" align="left" style="padding-left: 3px;"/>

			<e:button id="doSearch" name="doSearch" label="${doSearch_N }" disabled="${doSearch_D }" onClick="doSearch" />
		<c:if test="${fn:substring(param.TYPE, 0, 1) eq 'A'}">
			<e:button id="doSend" name="doSend" label="${doSend_N}" onClick="doSend" disabled="${doSend_D}" visible="${doSend_V}"/>
			<e:button id="doStop" name="doStop" label="${doStop_N}" onClick="doStop" disabled="${doStop_D}" visible="${doStop_V}"/>
		</c:if>
		<c:if test="${fn:substring(param.TYPE, 0, 1) eq 'B'}">
			<e:button id="doResume" name="doResume" label="${doResume_N}" onClick="doResume" disabled="${doResume_D}" visible="${doResume_V}"/>
		</c:if>
		</e:buttonBar>

		<e:gridPanel gridType="${_gridType}" id="grid" name="grid" width="100%" height="fit" />

	</e:window>
</e:ui>

