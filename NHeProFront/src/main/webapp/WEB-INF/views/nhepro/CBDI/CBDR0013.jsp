<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">

	<script type="text/javascript">

		var isDetailView = ('${param.detailView}' === 'true' ? true : (("${formData.SIGN_STATUS }" == "P" || "${formData.SIGN_STATUS }" == "E") ? true : false));
		var baseDataType = ("${param.baseDataType}" == null ? "" : "${param.baseDataType}");
		var userType = "${ses.userType}";
		var baseUrl = "/nhepro/CBDI/";

		function init() {

			var visibleFlag = ${visibleFlag};
			if(${!havePermission}) {
				EVF.C('Save').setDisabled(true);
				EVF.C('Approval').setDisabled(true);
			} else {
				if("${formData.SIGN_STATUS }" == "P" || "${formData.SIGN_STATUS }" == "E") {
					EVF.C('Save').setDisabled(true);
					EVF.C('Approval').setDisabled(true);
				}
			}
		}

		function doSave() {

			var popupFlag = ${(param.popupFlag == null || !param.popupFlag) ? false : true};
			var signStatus = this.getData().data;
			EVF.C("SIGN_STATUS").setValue(signStatus);

			var store = new EVF.Store();
			if(!store.validate()) { return; }

			var confirmMsg = "${CBDR0013_T003 }";
			  	confirmMsg = (signStatus == "T" ? confirmMsg + "\n\n" + "${msg.M0021}" : confirmMsg + "\n\n" + "${msg.M0100}");
			
			EVF.confirm(confirmMsg, function () {
				if (signStatus === 'T' || signStatus === 'E') {
					goApproval();
				}
				else if (signStatus === 'P') {
					var param = {
						subject: "[취소공고] " + "${formData.ANN_ITEM }",
						docType: "CANCELBID",
						signStatus: signStatus,
						screenId: "CBDR0013",
						approvalType: 'APPROVAL',
						attFileNum: "",
						docNum: EVF.V('BID_NUM'),
						appDocNum: EVF.V('APP_DOC_NUM'),
						callBackFunction: "goApproval",
						appAmt: eval(EVF.V('PR_AMT'))
					};
					everPopup.openApprovalRequestIPopup(param);
				}
			});
		}

		function goApproval(formData, gridData, attachData) {

			var popupFlag = ${(param.popupFlag == null || !param.popupFlag) ? false : true};

			EVF.C('approvalFormData').setValue(formData);
			EVF.C('approvalGridData').setValue(gridData);
			EVF.C('attachFileDatas').setValue(attachData);

			var store = new EVF.Store();
            store.setParameter("baseDataType", baseDataType);
            store.load(baseUrl + 'cbdr0013_doSave.so', function(){
                EVF.alert(this.getResponseMessage(), function() {
                    if(popupFlag) {
                        opener.doSearch();
                        doClose();
                    }
                });
            });
		}
		
		function doDelete() {

			var popupFlag = ${(param.popupFlag == null || !param.popupFlag) ? false : true};
			var store = new EVF.Store();

			EVF.confirm("${msg.M0013 }", function () {
				store.load(baseUrl + 'cbdi0013_doDelete.so', function() {
					EVF.alert(this.getResponseMessage(), function() {
						if(popupFlag) {
							opener.doSearch();
							doClose();
						}
					});
				});
			});
		}
		
		function doClose() {
			EVF.closeWindow();
		}

	</script>

	<e:window id="CBDR0013" initData="${initData}" onReady="init" title="${fullScreenName }" breadCrumbs="${breadCrumb }">

		<%-- 입찰공고 정보 --%>
		<div class="e-component e-title-container" data-uuid="Title-541-391-560">
			<div class="e-title-bullet-h1"></div>
			<div class="e-title-text">${CBDR0013_CAPTION1 }</div>
		</div>
		<e:searchPanel id="form1" labelWidth="${longLabelWidth}" width="100%" columnCount="2" useTitleBar="false">

			<e:inputHidden id="BUYER_CD" name="BUYER_CD" value="${formData.BUYER_CD}" />
			<e:inputHidden id="DEPT_CD" name="DEPT_CD" value="${formData.DEPT_CD}" />
			<e:inputHidden id="BID_NUM" name="BID_NUM" value="${formData.BID_NUM}" />
			<e:inputHidden id="BID_CNT" name="BID_CNT" value="${formData.BID_CNT}" />
			<e:inputHidden id="VOTE_CNT" name="VOTE_CNT" value="${formData.VOTE_CNT}" />
			<e:inputHidden id="ORI_BID_CNT" name="ORI_BID_CNT" value="${formData.ORI_BID_CNT}" />
			<e:inputHidden id='APP_DOC_NUM' name="APP_DOC_NUM" value="${empty param.appDocNum ? formData.APP_DOC_NUM : param.appDocNum}" />
			<e:inputHidden id='APP_DOC_CNT' name="APP_DOC_CNT" value="${formData.APP_DOC_CNT}" />
			<e:inputHidden id="SIGN_STATUS" name="SIGN_STATUS" value="${formData.SIGN_STATUS}" />
			<e:inputHidden id="OLD_SIGN_STATUS" name="OLD_SIGN_STATUS" value="${formData.SIGN_STATUS}" />
			<e:inputHidden id="BID_STATUS" name="BID_STATUS" value="${formData.BID_STATUS}" />
			<e:inputHidden id="PR_AMT" name="PR_AMT" value="${formData.PR_AMT}" />
			<e:inputHidden id="approvalFormData" name="approvalFormData" />
			<e:inputHidden id="approvalGridData" name="approvalGridData" />
			<e:inputHidden id="attachFileDatas" name="attachFileDatas" />

			<e:row>
				<e:label for="ANN_NO" title="${form_ANN_NO_N}"/>
				<e:field colSpan="3">
					<e:text>${formData.ANN_NO }</e:text>
				</e:field>
			</e:row>
			<e:row>
				<e:label for="ANN_ITEM" title="${form_ANN_ITEM_N}"/>
				<e:field colSpan="3">
					<e:text>${formData.ANN_ITEM }</e:text>
				</e:field>
			</e:row>
			<e:row>
				<e:label for="CANCEL_RMK" title="${form_CANCEL_RMK_N }" />
				<e:field colSpan="3">
					<e:richTextEditor id="CANCEL_RMK" name="CANCEL_RMK" width="100%" height="${(formData.SIGN_STATUS == 'T' || formData.SIGN_STATUS == 'C' || formData.SIGN_STATUS == '' || formData.SIGN_STATUS == null) ? '520px' : '300px'}" value="${formData.CANCEL_RMK }" required="${form_CANCEL_RMK_R }" readOnly="${form_CANCEL_RMK_RO }" disabled="${form_CANCEL_RMK_D }" useToolbar="${!param.detailView}" />
					<e:inputHidden id="CANCEL_RMK_NUM" name="CANCEL_RMK_NUM" value="${formData.CANCEL_RMK_NUM }" />
				</e:field>
			</e:row>
		</e:searchPanel>

		<e:buttonBar id="buttonBar" align="right" width="100%" title="${form_CAPTION_N }">
			<e:button id="Save" name="Save" label="${Save_N }" disabled="${Save_D }" visible="${Save_V}" onClick="doSave" data="T" />
			<e:button id="Approval" name="Approval" label="${Approval_N }" disabled="${Approval_D }" visible="${Approval_V}" onClick="doSave" data="P" />
			<c:if test="${formData.SIGN_STATUS == 'T'}">
				<e:button id="Delete" name="Delete" label="${Delete_N }" disabled="${Delete_D }" visible="${Delete_V}" onClick="doDelete" />
			</c:if>
			<c:if test="${param.popupFlag == true}">
				<e:button id="Close" name="Close" label="${Close_N }" disabled="${Close_D }" visible="${Close_V}" onClick="doClose" />
			</c:if>
		</e:buttonBar>

		<%-- 결재자 리스트 Include --%>
		<jsp:include page="/WEB-INF/views/nhepro/CWOR/CWOR0013.jsp" flush="true" >
			<jsp:param value="${formData.APP_DOC_NUM}" name="APP_DOC_NUM"/>
			<jsp:param value="${formData.APP_DOC_CNT}" name="APP_DOC_CNT"/>
			<jsp:param value="${formData.BUYER_CD}" name="BUYER_CD"/>
		</jsp:include>

	</e:window>
</e:ui>