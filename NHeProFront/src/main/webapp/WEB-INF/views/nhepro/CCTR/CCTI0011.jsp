<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<%-- 수정가능상태 : 공백, T, R, C --%>
<c:set var="editableStatus" value="${empty form.SIGN_STATUS or form.SIGN_STATUS eq 'T' or form.SIGN_STATUS eq 'R' or form.SIGN_STATUS eq 'C'}" />
                                     
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
	<script type="text/javascript" src="/js/everuxf/lib/ckeditor/ckeditor.js"></script>
    <script type="text/javascript" src="/js/everuxf/lib/ckeditor/econt_plugins_n.js"></script>
	<script type="text/javascript">

		var grid = {};
		var baseUrl = "/nhepro/CCTR/CCTI0011";

		function init() {
			grid = EVF.C("grid");
			grid.setProperty('shrinkToFit', true);
			grid.setProperty("multiSelect", false);
			
			grid.cellChangeEvent(function(rowIdx, colIdx, iRow, iCol, value, oldValue) {
				switch (colIdx) {
					case "DEFAULT_FLAG":
						if( grid.getCellValue(rowIdx, 'REQUIRE_FLAG') == "1" ) {
							grid.setCellValue(rowIdx, 'DEFAULT_FLAG', '1');
						}
						break;
					case "REQUIRE_FLAG":
						if( value == "1") {
							grid.setCellValue(rowIdx, 'DEFAULT_FLAG', '1');
						}
						break;
				}
			});
			
            doSearchECCR(); 	// 부서식 조회
            changeFormType();
            changeSubFormDiv();
			
			// 작성완료 이후에는 추가서식의 자동선택여부, 필수여부, 정렬순서만 변경할 수 있음
			if( '${editableStatus}' != 'true' ) {
				grid.setColReadOnly("SELECTED", true);
			}
		}
		
		//첨부서식 조회
	    function doSearchECCR() {
	        var store = new EVF.Store();
	        store.setGrid([grid]);
	        store.load(baseUrl + "/ccti0011_doSearchECCR.so", function() {
				var rowIdx = grid.getAllRowId();
				for(var i in rowIdx) {
					if(grid.getCellValue(rowIdx[i], "SELECTED") == "1") {
						grid.setCellReadOnly(rowIdx[i], "DEFAULT_FLAG", false);
						grid.setCellReadOnly(rowIdx[i], "REQUIRE_FLAG", false);
						grid.setCellReadOnly(rowIdx[i], "REL_FORM_SQ", false);
					} else {
						if('${editableStatus}' != 'true') {
							grid.setCellReadOnly(rowIdx[i], "DEFAULT_FLAG", true);
							grid.setCellReadOnly(rowIdx[i], "REQUIRE_FLAG", true);
							grid.setCellReadOnly(rowIdx[i], "REL_FORM_SQ", true);
						}
					}
				}
	        });
	    }

		// 서식 임시 저장
		function doSave() {
			var store = new EVF.Store();
			
			var signStatus = this.getData().data;
			if (!store.validate()) {
				return;
			}

			var msg = "";
    		var curSignStatus = EVF.V("SIGN_STATUS"); <%-- 결재상태 --%>
			if( curSignStatus == 'P' || curSignStatus == 'E' ){
				return EVF.alert("${CCTI0011_0006}");
    		} else {
    			if( signStatus == "T" ) {
        			msg = "${msg.M0021}";
    			} else {
    				msg = "${CCTI0011_0002}";
    			}
    		}
			
			if (signStatus == "T") {
				signSaveT(msg);
			} else {
				signSaveP();
			}
		}

		<%-- 결재상신 --%>
		function signSaveP() {
			var param = {
					subject: EVF.V('FORM_NM'),
					docType: "FORMNO",
					signStatus: "P",
					screenId: "CCTI0011",
					approvalType: 'APPROVAL',
					attFileNum: "",
					docNum: EVF.V('FORM_NUM'),
					appDocNum: EVF.V('APP_DOC_NUM'),
					callBackFunction: "goApproval"
				};
			everPopup.openApprovalRequestIPopup(param);
		}
		
		<%-- 임시저장 --%>
		function signSaveT(msg) {
			var store = new EVF.Store();
			EVF.confirm(msg, function () {
				store.setGrid([grid]);
				store.getGridData(grid, 'all');
				store.doFileUpload(function() {
					store.load(baseUrl + '/ccti0011_doSave.so', function() {
						var buyerCd = this.getParameter('BUYER_CD');
						var formNum = this.getParameter('FORM_NUM');
						EVF.alert(this.getResponseMessage(), function () {
							var param = {
									detailView: false,
									FORM_NUM: formNum,
								    BUYER_CD: buyerCd
							};
							if( opener ){
								opener.doSearch();
							}
							window.location.href = '/nhepro/CCTR/CCTI0011/view.so?' + $.param(param);
						});
					});
				});
			});
		}

		// 서식 결재상신
		function doReqSign() {

			var store = new EVF.Store();
			if (!store.validate()) { return; }
    		var signStatus = EVF.V("SIGN_STATUS"); <%-- 결재상태 --%>
    		if( signStatus == 'T' ){
    			EVF.confirm("${CCTI0011_0004}", function () {
					var param = {
						subject: EVF.V('FORM_NM'),
						docType: "FORMNO",
						signStatus: signStatus,
						screenId: "CCTI0011",
						approvalType: 'APPROVAL',
						attFileNum: "",
						docNum: EVF.V('FORM_NUM'),
						appDocNum: EVF.V('APP_DOC_NUM'),
						callBackFunction: "goApproval"
					};
					everPopup.openApprovalRequestIPopup(param);
				});
    		}
		}

		function goApproval(formData, gridData, attachData) {

			EVF.V('approvalFormData', formData);
			EVF.V('approvalGridData', gridData);
			EVF.V('attachFileDatas', attachData);

			var store = new EVF.Store();
			store.setParameter('APP_USE_FLAG', "1"); // 결재상신 처리여부
			store.setGrid([grid]);
			store.getGridData(grid, 'all');
			store.doFileUpload(function() {
				store.load(baseUrl + '/ccti0011_doSave.so', function() {
					alert(this.getResponseMessage());
					if( opener ){
						opener.doSearch();
					}
					doClose();
				});
			});
		}
		
		// 부서식 저장
		function doSubSave(formData, gridData, attachData) {
			
			var store = new EVF.Store();
			EVF.confirm("추가서식 변경사항을 저장하시겠습니까?", function () {
				store.setGrid([grid]);
				store.getGridData(grid, 'all');
				store.load(baseUrl + '/ccti0011_doSubSave.so', function() {
					doSearchECCR();
				});
			});
		}
		
		function doClose() {
			EVF.closeWindow();
		}

		function getBuyer() {
			var param = {
				callBackFunction: "setBuyer"
			};
			everPopup.openCommonPopup(param, "SP0066");
		}

		function setBuyer(data) {
			EVF.V("BUYER_CD", data.CUST_CD);
			EVF.V("BUYER_NM", data.CUST_NM);
			EVF.V("FORM_FILE_NM", "");
		}

		function changeFormType() {
			if(EVF.V("FORM_TYPE") == "100") {
				EVF.C('SUB_FORM_DIV').setRequired(false);
				EVF.C('SUB_FORM_DIV').setVisible(false);
				EVF.C('ATT_FILE_NUM').setVisible(false);
				
				EVF.C('divSubForm').setVisible(true);
				if( '${editableStatus}' != 'true' ) {
					EVF.C('doSubSave').setVisible(true);
				} else {
					EVF.C('doSubSave').setVisible(false);
				}
			} else {
				EVF.C('SUB_FORM_DIV').setRequired(true);
				EVF.C('SUB_FORM_DIV').setVisible(true);
				EVF.C('ATT_FILE_NUM').setVisible(true);
				
				EVF.C('divSubForm').setVisible(false);
				EVF.C('doSubSave').setVisible(false);
			}
		}

		function changeSubFormDiv() {
			if(EVF.V("SUB_FORM_DIV") == "F") {
				EVF.C("ATT_FILE_NUM").setRequired(true);
			} else {
				EVF.C("ATT_FILE_NUM").setRequired(false);
			}
		}
		
		<%-- 계약서식 조회 --%>
        function onIconClickEFORM() {
            var param = {
            		BUYER_CD: EVF.V("BUYER_CD"),
	                callBackFunction: "callBackEFORM"
	            };
            everPopup.openCommonPopup(param, "SP0127");
        }

        function callBackEFORM(data) {
            EVF.V("FORM_FILE_NM", data.CODE);
        }
        
	</script>

	<e:window id="CCTI0011" onReady="init" initData="${initData}" title="${fullScreenName }" breadCrumbs="${breadCrumb }" margin="0 4px">

		<e:buttonBar id="buttonBar" title="기본정보" align="right" width="100%">
			<!-- 결재진행중, 결재완료인 경우 수정할 수 없음 -->
			<c:if test='${!param.detailView and editableStatus}'>
				<e:button id="doSave" name="doSave" label="${doSave_N }" disabled="${doSave_D }" onClick="doSave" data="T"/>
				<e:button id="doReqSign" name="doReqSign" label="${doReqSign_N }" disabled="${doReqSign_D }" onClick="doSave" data="P"/>
			</c:if>
			<e:button id="doClose" name="doClose" label="${doClose_N }" disabled="${doClose_D }" onClick="doClose" />
		</e:buttonBar>

		<e:searchPanel id="form" title="${form_CAPTION_N }" columnCount="3" labelWidth="140" onEnter="" useTitleBar="false">
			<e:inputHidden id="FORM_NUM" name="FORM_NUM" value="${empty form.FORM_NUM ? param.formNum : form.FORM_NUM}" />
            <e:inputHidden id="APP_DOC_NUM" name="APP_DOC_NUM" value="${empty form.APP_DOC_NUM ? param.appDocNum : form.APP_DOC_NUM}"/>
            <e:inputHidden id="APP_DOC_CNT" name="APP_DOC_CNT" value="${empty form.APP_DOC_CNT ? param.appDocCnt : form.APP_DOC_CNT}"/>
            <e:inputHidden id="SIGN_STATUS" name="SIGN_STATUS" value="${form.SIGN_STATUS}"/>
			<e:inputHidden id="approvalFormData" name="approvalFormData" value="" />
			<e:inputHidden id="approvalGridData" name="approvalGridData" value="" />
			<e:inputHidden id="attachFileDatas" name="attachFileDatas" visible="false" />

			<e:row>
				<%-- 서식분류 --%>
				<e:label for="FORM_TYPE" title="${form_FORM_TYPE_N}"/>
				<e:field>
					<e:select id="FORM_TYPE" name="FORM_TYPE" value="${form.FORM_TYPE}" options="${formTypeOptions}" width="${form_FORM_TYPE_W}" disabled="${form_FORM_TYPE_D}" readOnly="${form_FORM_TYPE_RO}" required="${form_FORM_TYPE_R}" placeHolder="" maskType="${form_FORM_TYPE_MT}" onChange="changeFormType" />
				</e:field>
				<%-- 계약서 종류 --%>
				<e:label for="CONT_TYPE" title="${form_CONT_TYPE_N}"/>
				<e:field>
					<e:select id="CONT_TYPE" name="CONT_TYPE" value="${form.CONT_TYPE}" options="${contTypeOptions}" width="${form_CONT_TYPE_W}" disabled="${form_CONT_TYPE_D}" readOnly="${form_CONT_TYPE_RO}" required="${form_CONT_TYPE_R}" placeHolder="" maskType="${form_CONT_TYPE_MT}" />
				</e:field>
				<%-- 계약구분 --%>
				<e:label for="CONT_DIV" title="${form_CONT_DIV_N}"/>
				<e:field>
					<e:select id="CONT_DIV" name="CONT_DIV" value="${form.CONT_DIV}" options="${contDivOptions}" width="${form_CONT_DIV_W}" disabled="${form_CONT_DIV_D}" readOnly="${form_CONT_DIV_RO}" required="${form_CONT_DIV_R}" placeHolder="" maskType="${form_CONT_DIV_MT}" />
				</e:field>
			</e:row>
			<e:row>
				<%-- 서식명 --%>
				<e:label for="FORM_NM" title="${form_FORM_NM_N}" />
				<e:field colSpan="3">
					<e:inputText id="FORM_NM" name="FORM_NM" value="${form.FORM_NM}" width="${form_FORM_NM_W}" maxLength="${form_FORM_NM_M}" disabled="${form_FORM_NM_D}" readOnly="${form_FORM_NM_RO}" required="${form_FORM_NM_R}" style="${imeMode}" maskType="${form_FORM_NM_MT}"/>
				</e:field>
				<%-- 고객사 --%>
				<e:label for="BUYER_CD" title="${form_BUYER_CD_N}"/>
				<e:field>
					<e:search id="BUYER_CD" name="BUYER_CD" value="${empty form.BUYER_CD ? ses.companyCd : form.BUYER_CD}" width="40%" maxLength="${form_BUYER_CD_M}" onIconClick="${form_BUYER_CD_RO ? 'getBuyer' : 'everCommon.blank'}" disabled="${form_BUYER_CD_D}" readOnly="${form_BUYER_CD_RO}" required="${form_BUYER_CD_R}" maskType="${form_BUYER_CD_MT}" />
					<e:inputText id="BUYER_NM" name="BUYER_NM" value="${empty form.BUYER_NM ? ses.companyNm : form.BUYER_NM}" width="60%" maxLength="${form_BUYER_NM_M}" disabled="${form_BUYER_NM_D}" readOnly="${form_BUYER_NM_RO}" required="${form_BUYER_NM_R}" style="${imeMode}" maskType="${form_BUYER_NM_MT}"/>
				</e:field>
			</e:row>
			<e:row>
				<%-- 일괄계약여부 --%>
				<e:label for="BUNDLE_FLAG" title="${form_BUNDLE_FLAG_N}"/>
				<e:field>
					<e:select id="BUNDLE_FLAG" name="BUNDLE_FLAG" value="${(form.BUNDLE_FLAG == null || form.BUNDLE_FLAG == '') ? '0' : form.BUNDLE_FLAG}" options="${bundleFlagOptions}" width="${form_BUNDLE_FLAG_W}" disabled="${form_BUNDLE_FLAG_D}" readOnly="${form_BUNDLE_FLAG_RO}" required="${form_BUNDLE_FLAG_R}" placeHolder="" maskType="${form_BUNDLE_FLAG_MT}" />
				</e:field>
				<%-- 자동갱신여부 --%>
				<e:label for="AUTO_RENEW_FLAG" title="${form_AUTO_RENEW_FLAG_N}"/>
				<e:field>
					<e:select id="AUTO_RENEW_FLAG" name="AUTO_RENEW_FLAG" value="${(form.AUTO_RENEW_FLAG == null || form.AUTO_RENEW_FLAG == '') ? '0' : form.AUTO_RENEW_FLAG}" options="${autoRenewFlagOptions}" width="${form_AUTO_RENEW_FLAG_W}" disabled="${form_AUTO_RENEW_FLAG_D}" readOnly="${form_AUTO_RENEW_FLAG_RO}" required="${form_AUTO_RENEW_FLAG_R}" placeHolder="" maskType="${form_AUTO_RENEW_FLAG_MT}" />
				</e:field>
				<c:if test="${ses.relatYn eq '0'}">
					<%-- 공통사용여부 --%>
					<e:label for="NH_COMM_FLAG" title="${form_NH_COMM_FLAG_N}" />
					<e:field>
						<e:checkGroup id="NH_COMM_FLAG" name="NH_COMM_FLAG" width="100%" value="${form.NH_COMM_FLAG}" disabled="${form_NH_COMM_FLAG_D}" readOnly="${form_NH_COMM_FLAG_RO}" required="${form_NH_COMM_FLAG_R}">
							<e:check id="NH_COMM_FLAG1" name="NH_COMM_FLAG1" value="1"  />
						</e:checkGroup>
						<e:text>${CCTI0011_0001}</e:text>
					</e:field>
				</c:if>
			</e:row>
			<e:row>
				<%-- 설명 --%>
				<e:label for="RMK" title="${form_RMK_N}"/>
				<e:field colSpan="5">
					<e:textArea id="RMK" name="RMK" value="${form.RMK}" height="100px" width="${form_RMK_W}" maxLength="${form_RMK_M}" disabled="${form_RMK_D}" readOnly="${form_RMK_RO}" required="${form_RMK_R}" />
				</e:field>
			</e:row>
            <e:row visible="false">
				<%-- 부서식구분 --%>
				<e:label for="SUB_FORM_DIV" title="${form_SUB_FORM_DIV_N}"/>
				<e:field>
					<e:select id="SUB_FORM_DIV" name="SUB_FORM_DIV" value="${form.SUB_FORM_DIV}" options="${subFormDivOptions}" width="${form_SUB_FORM_DIV_W}" disabled="${form_SUB_FORM_DIV_D}" readOnly="${form_SUB_FORM_DIV_RO}" required="${form_SUB_FORM_DIV_R}" placeHolder="" maskType="${form_SUB_FORM_DIV_MT}" onChange="changeSubFormDiv"/>
				</e:field>
				<%-- 첨부파일 --%>
				<e:label for="ATT_FILE_NUM" title="${form_ATT_FILE_NUM_N}"/>
				<e:field>
					<e:fileManager id="ATT_FILE_NUM" height="40" width="100%" fileId="${form.ATT_FILE_NUM}" readOnly="${form_ATT_FILE_NUM_RO}" bizType="EC" required="${form_ATT_FILE_NUM_R}"/>
				</e:field>
				<%-- 사용여부 --%>
				<e:label for="USE_FLAG" title="${form_USE_FLAG_N}"/>
				<e:field>
					<e:select id="USE_FLAG" name="USE_FLAG" value="${(form.USE_FLAG == null || form.USE_FLAG == '') ? '1' : form.USE_FLAG}" options="${useFlagOptions}" width="${form_USE_FLAG_W}" disabled="${form_USE_FLAG_D}" readOnly="${form_USE_FLAG_RO}" required="${form_USE_FLAG_R}" placeHolder="" maskType="${form_USE_FLAG_MT}" />
				</e:field>
            </e:row>
			<e:row>
				<%-- 서식파일명 --%>
				<e:label for="FORM_FILE_NM" title="${form_FORM_FILE_NM_N}" />
				<e:field colSpan="5">
					<e:inputText id="FORM_FILE_NM" name="FORM_FILE_NM" value="${form.FORM_FILE_NM}" width="${form_FORM_FILE_NM_W}" maxLength="${form_FORM_FILE_NM_M}" disabled="${form_FORM_FILE_NM_D}" readOnly="${form_FORM_FILE_NM_RO}" required="${form_FORM_FILE_NM_R}" style="${imeMode}" maskType="${form_FORM_FILE_NM_MT}"/>
				</e:field>
			</e:row>
       	</e:searchPanel>

		<e:panel id="divSubForm" width="100%">
			<e:buttonBar id="buttonBarSub" title="추가서식선택" align="right" width="100%">
				<e:button id="doSubSave" name="doSubSave" label="${doSubSave_N}" onClick="doSubSave" disabled="${doSubSave_D}" visible="${doSubSave_V}"/>
			</e:buttonBar>
			<e:gridPanel gridType="${_gridType}" id="grid" name="grid" width="100%" height="250" />
		</e:panel>

		<%-- 결재자 리스트 Include --%>
		<jsp:include page="/WEB-INF/views/nhepro/CWOR/CWOR0013.jsp" flush="true" >
			<jsp:param value="${formData.APP_DOC_NUM}" name="APP_DOC_NUM"/>
			<jsp:param value="${formData.APP_DOC_CNT}" name="APP_DOC_CNT"/>
			<jsp:param value="${formData.BUYER_CD}" name="BUYER_CD"/>
		</jsp:include>

	</e:window>
</e:ui>
