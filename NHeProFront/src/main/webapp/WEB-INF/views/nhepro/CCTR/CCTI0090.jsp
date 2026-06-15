<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%-- 결재상태 : 공백, 작성중, 취소, 반려 --%>
<c:set var="editableStatus" value="${empty form.SIGN_STATUS or form.SIGN_STATUS eq 'T'
                                        or form.SIGN_STATUS eq 'C' or form.SIGN_STATUS eq 'R'}" />

<e:ui>
	<script type="text/javascript">

		var grid;
		var baseUrl = "/nhepro/CCTR/CCTI0090";
		var selRow;
		var isDetailView = ('${editableStatus}' === 'true' ? false : true);
		
		function init() {
			grid  = EVF.C("grid");
            
            grid.setProperty('shrinkToFit', false);
            grid.setProperty('rowNumbers', ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
			grid.setProperty('sortable', ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
			grid.setProperty('panelVisible', ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
			grid.setProperty('enterToNextRow', ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
			grid.setProperty('acceptZero', ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
			grid.setProperty('singleSelect', ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]
			grid.setProperty('multiSelect', ${multiSelect}); 		// [선택] 컬럼의 사용여부를 지정한다. [true/false]
            
            grid.setColGroup([
            	{
                    "groupName": '기본급',
                    "columns": ['BASE_PAY', 'BASE_PAY_RMKS']
                }
                ,{
                    "groupName": '식대',
                    "columns": ['FOOD_PAY', 'FOOD_PAY_RMKS']
                }
                ,{
                    "groupName": '직책수당',
                    "columns": ['JOB_PAY', 'JOB_PAY_RMKS']
                }
                ,{
                    "groupName": '연장수당',
                    "columns": ['EXTEND_PAY', 'EXTEND_PAY_RMKS']
                }
                ,{
                    "groupName": '업무수당',
                    "columns": ['WORK_PAY', 'WORK_PAY_RMKS']
                }
                ,{
                    "groupName": '야간수당',
                    "columns": ['NIGHT_PAY', 'NIGHT_PAY_RMKS']
                }
                ,{
                    "groupName": '기타수당1',
                    "columns": ['ETC_PAY', 'ETC_PAY_RMKS']
                }
                ,{
                    "groupName": '기타수당2',
                    "columns": ['ETC_PAY2', 'ETC_PAY2_RMKS']
                }
                ,{
                    "groupName": '기타수당3',
                    "columns": ['ETC_PAY3', 'ETC_PAY3_RMKS']
                }
            ],50); 
			 
			 grid.cellClickEvent(function (rowIdx, colId, value) {
				var param;
				
				if(colId == "SPEC_RMKS") {
                   var param = {
                		   callbackFunction: 'setRMK',
	                        title: "특수조건",
	                        message: grid.getCellValue(rowIdx, 'SPEC_RMKS'),
	                        rowIdx: rowIdx,
	                        detailView: isDetailView
	                    };
                    everPopup.commonTextInput(param);
				}
			}); 
			
			grid.cellChangeEvent(function (rowIdx, colIdx, irow, icol, value, oldValue) {
				
				var basePay   = grid.getCellValue(rowIdx, "BASE_PAY");
				var foodPay   = grid.getCellValue(rowIdx, "FOOD_PAY");
				var jobPay    = grid.getCellValue(rowIdx, "JOB_PAY");
				var extendPay = grid.getCellValue(rowIdx, "EXTEND_PAY");
				var workPay   = grid.getCellValue(rowIdx, "WORK_PAY");
				var nightPay  = grid.getCellValue(rowIdx, "NIGHT_PAY");
				var etcPay    = grid.getCellValue(rowIdx, "ETC_PAY");
				var etcPay2   = grid.getCellValue(rowIdx, "ETC_PAY2");
				var etcPay3   = grid.getCellValue(rowIdx, "ETC_PAY3");
				
                if(colIdx == "BASE_PAY") {
                	grid.setCellValue(rowIdx, "WORKER_PAY_AMT", Number(value) + Number(foodPay) + Number(jobPay) + Number(extendPay) 
                			+ Number(workPay) + Number(nightPay) + Number(etcPay) + Number(etcPay2) + Number(etcPay3));
                }
                
                if(colIdx == "FOOD_PAY") {
                	grid.setCellValue(rowIdx, "WORKER_PAY_AMT", Number(value) + Number(basePay) + Number(jobPay) + Number(extendPay) 
                			+ Number(workPay) + Number(nightPay) + Number(etcPay) + Number(etcPay2) + Number(etcPay3));
                }
                
                if(colIdx == "JOB_PAY") {
                	grid.setCellValue(rowIdx, "WORKER_PAY_AMT", Number(value) + Number(basePay) + Number(foodPay) + Number(extendPay) 
                			+ Number(workPay) + Number(nightPay) + Number(etcPay) + Number(etcPay2) + Number(etcPay3));
                }
                
                if(colIdx == "EXTEND_PAY") {
                	grid.setCellValue(rowIdx, "WORKER_PAY_AMT", Number(value) + Number(basePay) + Number(foodPay) + Number(jobPay)
                		    + Number(workPay) + Number(nightPay) + Number(etcPay) + Number(etcPay2) + Number(etcPay3));
                }
                
                if(colIdx == "WORK_PAY") {
                	grid.setCellValue(rowIdx, "WORKER_PAY_AMT", Number(value) + Number(basePay) + Number(foodPay) + Number(jobPay)
                			+ Number(extendPay) + Number(nightPay) + Number(etcPay) + Number(etcPay2) + Number(etcPay3));
                }
                
                if(colIdx == "NIGHT_PAY") {
                	grid.setCellValue(rowIdx, "WORKER_PAY_AMT", Number(value) + Number(basePay) + Number(foodPay) + Number(jobPay)
                			+ Number(extendPay) + Number(workPay) + Number(etcPay) + Number(etcPay2) + Number(etcPay3));
                }
                
                if(colIdx == "ETC_PAY") {
                	grid.setCellValue(rowIdx, "WORKER_PAY_AMT", Number(value) + Number(basePay) + Number(foodPay) + Number(jobPay)
                			+ Number(extendPay) + Number(workPay) + Number(nightPay) + Number(etcPay2) + Number(etcPay3));
                }
                
                if(colIdx == "ETC_PAY2") {
                	grid.setCellValue(rowIdx, "WORKER_PAY_AMT", Number(value) + Number(basePay) + Number(foodPay) + Number(jobPay)
                			+ Number(extendPay) + Number(workPay) + Number(nightPay) + Number(etcPay) + Number(etcPay3));
                }
                
                if(colIdx == "ETC_PAY3") {
                	grid.setCellValue(rowIdx, "WORKER_PAY_AMT", Number(value) + Number(basePay) + Number(foodPay) + Number(jobPay)
                			+ Number(extendPay) + Number(workPay) + Number(nightPay) + Number(etcPay) + Number(etcPay2));
                }
            });
			
            if( ${!param.detailView and editableStatus} ){
    			grid.delRowEvent(function() {
    				if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
                    grid.delRow();
                });
            }
            
            if( EVF.V("CONT_NUM") != "" && EVF.V("CONT_CNT") != "" ){
                doSearchPCWU(); // 개인근로자조회
            }
            
            // 개인근로자 회원승인 화면에서 데이터 가져오는 경우(미사용)
            if( '${param.userInfo}' != undefined && '${param.userInfo}' != '' ){
            	var jsonData = JSON.parse('${param.userInfo}');
            	_setPctUser(jsonData);
            }
            
         	// 버튼 처리
        	setButtons();
         
            if( !${havePermission} ){
				EVF.C("CONT_USER_NM").setDisabled(true);
			}
            
            grid.setColIconify("SPEC_RMKS", "SPEC_RMKS", "comment", true);
		}
		
		function setButtons() {
			if( ${!param.detailView} ){
				<c:if test="${editableStatus}">
					EVF.C('doSave').setVisible(true);
	           		EVF.C('doReqSign').setVisible(true);
	           		EVF.C('addRow').setVisible(true);
				</c:if>
				if( EVF.V('SIGN_STATUS') == "T" ){
  					EVF.C('doDelete').setVisible(true); // 삭제
           		}
			} else {
				EVF.C('doSave').setVisible(false); // 임시저장
				EVF.C('doReqSign').setVisible(false); // 요청
				EVF.C('doDelete').setVisible(false); // 취소
				EVF.C('addRow').setVisible(false); // 위임회사 검색
			}
		}
		
		// 개인근로자
		function doSearchPCWU() {
			var store = new EVF.Store();
			store.setGrid([grid]);
			store.load(baseUrl + '/doSearchPCWU.so', function () {
			});
		}
		
		function doSave() {
            if(!checkFormValidation()) { return; }
            
            EVF.confirm("${msg.M0021 }", function() {
				var store = new EVF.Store();
				store.setGrid([grid]);
				store.getGridData(grid,  'all'); // 개인근로자
				store.doFileUpload(function() {
					store.load(baseUrl + '/doSave.so', function() {
						
						var buyerCd = this.getParameter('buyerCd');
						var contNum = this.getParameter('contNum');
						var contCnt = this.getParameter('contCnt');
						EVF.alert('${msg.M0031}', function() {
							location.href = baseUrl + "/view.so?buyerCd="+buyerCd+"&contNum="+contNum+'&contCnt='+contCnt;
							if(opener) {
								opener['doSearch']();
							}
						});
					});
				});	
			});
        }
		
		
		function doDelete() {
            EVF.confirm('${msg.M0013}', function () {
				var store = new EVF.Store();
				store.load(baseUrl + "/doDelete.so", function () {
					EVF.alert(this.getResponseMessage(), function () {
						if (opener) {
							opener.doSearch();
							doClose();
						} else {
							location.href = baseUrl + '/view.so';
						}
					});
				});
			});
        }
		
		// 결재상신
		function doReqSign() {
			
            if(!checkFormValidation()) { return; }
            
			var signStatus = EVF.V('SIGN_STATUS');
			var param = {
				subject: EVF.V('CONT_DESC'),
				docType: "PCONT",
				signStatus: signStatus,
				screenId: "CCTI0090",
				approvalType: 'APPROVAL',
				attFileNum: "",
				docNum: EVF.V('CONT_NUM'),
				appDocNum: EVF.V('APP_DOC_NUM'),
				callBackFunction: "goApproval",
				appAmt: eval(grid._gvo.getSummary("WORKER_PAY_AMT", "sum"))
			};
			everPopup.openApprovalRequestIPopup(param);
        }
        

        // 결재상신 완료 후 결재창에서 호출하는 메소드
		function goApproval(formData, gridData, attachData) {

			EVF.V('approvalFormData', formData);
			EVF.V('approvalGridData', gridData);
			EVF.V('attachFileDatas', attachData);

            var store = new EVF.Store();
            
            store.setGrid([grid]);
            store.getGridData(grid, 'all');  // 개인근로자
            store.doFileUpload(function() {
                store.load(baseUrl + '/doReqSign.so', function() {
                    EVF.alert('${msg.M0001}', function () {
						location.href = baseUrl + "/view.so";
						if(opener) {
							opener['doSearch']();
							doClose();
						}
					});
                });
            });
        }
		
		// 폼과 그리드의 값을 체크한다.
        function checkFormValidation() {
            var store = new EVF.Store();
            if(!store.validate()) {
                return false;
            }

			grid.checkAll(true);
			if(grid.getRowCount() == 0) {
				return EVF.alert("${CCTI0090_004}");
			}

			if (!grid.validate().flag) {
				return EVF.alert(grid.validate().msg);
			}
			
            var rowIds = grid.getAllRowId();
            
            for(var i = 0; i < rowIds.length; i++) {
            	//var contDate = grid.getCellValue(rowIds[i], 'WORKER_CONT_DATE');
            	var startDate = grid.getCellValue(rowIds[i], 'WORKER_CONT_START_DATE');
             	var endDate   = grid.getCellValue(rowIds[i], 'WORKER_CONT_END_DATE');
             	var workerPayAmt   = Number(grid.getCellValue(rowIds[i], 'WORKER_PAY_AMT'));
             	var sumPay = Number(grid.getCellValue(rowIds[i], "BASE_PAY")) + Number(grid.getCellValue(rowIds[i], "FOOD_PAY")) + Number(grid.getCellValue(rowIds[i], "JOB_PAY"))
			    			+ Number(grid.getCellValue(rowIds[i], "EXTEND_PAY")) + Number(grid.getCellValue(rowIds[i], "WORK_PAY")) + Number(grid.getCellValue(rowIds[i], "NIGHT_PAY"))
			    			+ Number(grid.getCellValue(rowIds[i], "ETC_PAY")) + Number(grid.getCellValue(rowIds[i], "ETC_PAY2")) + Number(grid.getCellValue(rowIds[i], "ETC_PAY3"));
             	
            	if( startDate > endDate){
        			return EVF.alert("${CCTI0090_005}");
        		}
            	
            	if(sumPay > 0){
	            	if( workerPayAmt != sumPay){
	        			return EVF.alert("${CCTI0090_008}");
	        		}
            	}
        		
            	for(var j = i + 1; j < rowIds.length; j++) {
                    if(grid.getCellValue(rowIds[i], 'WORKER_ID') === grid.getCellValue(rowIds[j], 'WORKER_ID')) {
                    	return EVF.alert("${CCTI0090_003}");
                    }
            	}
            }
            
            return true;
        }
		
        <%-- 고객사 조회 팝업 --%>
        function onIconClickBUYER_CD() {
            var param = {
                callBackFunction: "callBackBUYER_CD"
            };
            everPopup.openCommonPopup(param, "SP0066");
        }

        function callBackBUYER_CD(data) {
            EVF.V("BUYER_CD", data.CUST_CD);
            EVF.V("BUYER_NM", data.CUST_NM);
        }
        
		function getContUser() {
			var param = {
				callBackFunction: "setContUser",
				GATE_CD: '${ses.gateCd}'
			};
			everPopup.openCommonPopup(param, 'SP0001');
		}

		function setContUser(data) {
			EVF.V("CONT_USER_ID", data.USER_ID);
			EVF.V("CONT_USER_NM", data.USER_NM);
		}
		
     	// 개인근로자 선택
        function getPctUser() {
     		var contUserId = EVF.V("CONT_USER_ID");
     		if( ${havePermission} ){
     			contUserId = "";
     		}
     		
     		// 관리자가 아닌 경우 계약담당자가 현장담당자인 개인근로자만 조회
     		if( !${havePermission} && contUserId == "" ) {
     			return EVF.alert("CCTI0090_001");
     		}
     		
        	var param = {
        			'callBackFunction' : "_setPctUser",
        			'SITE_USER_ID' : contUserId
                };
        	everPopup.openCommonPopup(param, 'MP0021');
        }
        
        function _setPctUser(jsonData) {
        	
        	var curDate = '${toDate}';
        	
       		for( idx in jsonData ){
           		var addParam = [{
	        			"WORKER_ID": jsonData[idx].USER_ID,
	        			"WORKER_NM": jsonData[idx].USER_NM,
	        			"GENDER"   : jsonData[idx].GENDER_NM,
	        			"WORKER_DEPT_NM" : (jsonData[idx].WORKER_DEPT_NM == 'undefined') ? "" : jsonData[idx].WORKER_DEPT_NM,
	        			"WORKER_JOB_NM" : (jsonData[idx].WORKER_JOB_NM == 'undefined') ? '20200710' : jsonData[idx].WORKER_JOB_NM,
	        			//"WORKER_CONT_DATE" : (jsonData[idx].WORKER_CONT_DATE == 'undefined') ? "" : jsonData[idx].WORKER_CONT_DATE,
	        			"WORKER_CONT_DATE" : curDate,
	        			"WORKER_CONT_START_DATE" : (jsonData[idx].WORKER_CONT_START_DATE == 'undefined') ? "" : jsonData[idx].WORKER_CONT_START_DATE,
	        			"WORKER_CONT_DATE" : curDate,
	        			"SITE_USER_NM":jsonData[idx].SITE_USER_NM
        			}];
            	grid.addRow(addParam);
           	}
        }
        
        function setRMK(data) {
            grid.setCellValue(data.rowIdx, "SPEC_RMKS", data.message);
        }
        
        function doClose() {
			EVF.closeWindow();
        }
        
	</script>

	<e:window id="CCTI0090" onReady="init" initData="${initData}" title="${fullScreenName }" breadCrumbs="${breadCrumb }">
		<!-- Button 영역 -->
        <e:buttonBar width="100%" align="right" title="기본정보">
          <e:button id="doSave" name="doSave" label="${doSave_N}" onClick="doSave" disabled="${doSave_D}" visible="${doSave_V}"/>
          <e:button id="doDelete" name="doDelete" label="${doDelete_N}" onClick="doDelete" disabled="${doDelete_D}" visible="${doDelete_V}"/>
          <e:button id="doReqSign" name="doReqSign" label="${doReqSign_N}" onClick="doReqSign" disabled="${doReqSign_D}" visible="${doReqSign_V}"/>
          <c:if test="${param.popupFlag eq true}">
			<e:button id='Close' name="Close" label='${Close_N }' disabled='${Close_D }' visible='${Close_V }' onClick='doClose' />
		  </c:if>
        </e:buttonBar>
        
		<e:searchPanel id="form" title="${msg.M9999 }" columnCount="2" labelWidth="${labelWidth}" useTitleBar="false">
			<!-- 수정 : 계약번호 존재 -->
			<e:inputHidden id='BUYER_CD' name='BUYER_CD' value="${empty form.BUYER_CD ? ses.companyCd : form.BUYER_CD}"/>
			<e:inputHidden id="CONT_NUM" name="CONT_NUM" value="${empty form.CONT_NUM ? param.contNum : form.CONT_NUM}"/>
            <e:inputHidden id='CONT_CNT' name='CONT_CNT' value="${empty form.CONT_CNT ? param.contCnt : form.CONT_CNT}"/>
			<e:inputHidden id="APP_DOC_NUM" name="APP_DOC_NUM" value="${empty form.APP_DOC_NUM ? param.appDocNum : form.APP_DOC_NUM}"/>
            <e:inputHidden id="APP_DOC_CNT" name="APP_DOC_CNT" value="${empty form.APP_DOC_CNT ? param.appDocCnt : form.APP_DOC_CNT}"/>
            <e:inputHidden id="SIGN_STATUS" name="SIGN_STATUS" value="${form.SIGN_STATUS}" />
			<e:inputHidden id="approvalFormData" name="approvalFormData" value="" />
			<e:inputHidden id="approvalGridData" name="approvalGridData" value="" />
			<e:inputHidden id="attachFileDatas" name="attachFileDatas" visible="false" />
			
			<e:row>
				<e:label for="BUYER_NM" title="${form_BUYER_NM_N}"/>
				<e:field>
					<e:search id="BUYER_NM" name="BUYER_NM" value="${empty form.BUYER_NM ? ses.companyNm : form.BUYER_NM}" width="50%" maxLength="${form_BUYER_NM_M}" onIconClick="${(!param.detailView and editableStatus) ? 'onIconClickBUYER_CD' : ''}" disabled="${form_BUYER_NM_D}" readOnly="${form_BUYER_NM_RO}" required="${form_BUYER_NM_R}" maskType="${form_BUYER_NM_MT}" />
				</e:field>
				<e:label for="CONT_NUM" title="${form_CONT_NUM_N}" />
				<e:field>
					<e:text>${not empty form.CONT_NUM ? form.CONT_NUM : ""}</e:text>
				</e:field>
			</e:row>
			<e:row>
				<e:label for="CONT_USER_NM" title="${form_CONT_USER_NM_N}"/>
				<e:field>
					<e:search id="CONT_USER_NM" name="CONT_USER_NM" value="${empty form.CONT_USER_NM ? ses.userNm : form.CONT_USER_NM}" width="${form_CONT_USER_NM_W}" maxLength="${form_CONT_USER_NM_M}" onIconClick="${(!param.detailView and editableStatus) ? 'getContUser' : ''}" disabled="${form_CONT_USER_NM_D}" readOnly="${form_CONT_USER_NM_RO}" required="${form_CONT_USER_NM_R}"  maskType="${form_CONT_USER_NM_MT}" />
					<e:inputHidden id="CONT_USER_ID" name="CONT_USER_ID" value="${empty form.CONT_USER_ID ? ses.userId : form.CONT_USER_ID}" />
				</e:field>
				<e:label for="REG_DATE" title="${form_REG_DATE_N}"/>
				<e:field>
					<e:inputDate id="REG_DATE" name="REG_DATE" value="${empty form.CONT_DATE ? toDate : form.CONT_DATE}" width="${inputDateWidth}" datePicker="true" required="${form_REG_DATE_R}" disabled="${form_REG_DATE_D}" readOnly="${form_REG_DATE_RO}" />
				</e:field>
			</e:row>
			<e:row>
				<e:label for="CONT_DESC" title="${form_CONT_DESC_N}" />
				<e:field colSpan="3">
					<e:inputText id="CONT_DESC" name="CONT_DESC" value="${form.CONT_DESC}" width="100%" maxLength="${form_CONT_DESC_M}" disabled="${form_CONT_DESC_D}" readOnly="${form_CONT_DESC_RO}" required="${form_CONT_DESC_R}"  maskType="${form_CONT_DESC_MT}" />
				</e:field>
			</e:row>
            <e:row>
                <e:label for="CONT_REMARK" title="${form_CONT_REMARK_N}"/>
                <e:field colSpan="3">
                    <e:textArea id="CONT_REMARK" name="CONT_REMARK" height="100" value="${form.CONT_REMARK}" width="100%" maxLength="${form_CONT_REMARK_M}" disabled="${form_CONT_REMARK_D}" readOnly="${form_CONT_REMARK_RO}" required="${form_CONT_REMARK_R}"/>
                </e:field>
            </e:row>
            <e:row>
              	<e:label for="ATT_FILE_NUM" title="${form_ATT_FILE_NUM_N}"/>
              	<e:field colSpan="3">
                  	<e:fileManager id="ATT_FILE_NUM" height="100" width="100%" fileId="${form.ATT_FILE_NUM}" readOnly="false" bizType="PC" required="false" uploadable="false"/>
              	</e:field>
            </e:row>
		</e:searchPanel>
		
        <e:buttonBar width="100%" align="right" title="개인근로자">
          <e:button id="addRow" name="addRow" label="${addRow_N}" onClick="getPctUser" disabled="${addRow_D}" visible="${addRow_V}"/>
        </e:buttonBar>
		<e:gridPanel gridType="${_gridType}" id="grid" name="grid" width="100%" height="fit" readOnly="${param.detailView}"/>
		
		<%-- 결재자 리스트 Include --%>
		<jsp:include page="/WEB-INF/views/nhepro/CWOR/CWOR0013.jsp" flush="true" >
			<jsp:param value="${form.APP_DOC_NUM}" name="APP_DOC_NUM"/>
			<jsp:param value="${form.APP_DOC_CNT}" name="APP_DOC_CNT"/>
			<jsp:param value="${form.BUYER_CD}" name="BUYER_CD"/>
		</jsp:include>
	</e:window>
</e:ui>

