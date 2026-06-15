<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">

	<script type="text/javascript">

	    var grid;
		var baseUrl = "/nhepro/CBDR/";

	    function init() {

		}
		
	    /** 21.01.05 농협중앙회 요청 
		 *  기존 저장 후 팝업창 close => close 하지 않고 바로 결재상신 할 수 있도록 화면 재조회
		 */
		function doSave() {
			EVF.C("SIGN_STATUS").setValue('T');
			EVF.confirm('${msg.M0021}', function () {
				//goApproval();
				var store = new EVF.Store();
				if(!store.validate()) return;
				store.doFileUpload(function() {
					store.load(baseUrl + '/cbdi0051_doSave.so', function () {
						EVF.alert(this.getResponseMessage(), function() {
							opener.doSearch();
							
							var param = {
		                            'buyerCd': EVF.V("BUYER_CD"),
		                            'BID_NUM': EVF.V("BID_NUM"),
		                            'BID_CNT': EVF.V("BID_CNT")
		                        };
							
							window.location.href = '/nhepro/CBDR/CBDI0051/view.so?' + $.param(param);
						});
					});
				});
			});
		}

		function doSign() {

			EVF.C("SIGN_STATUS").setValue('P');
			var param = {
				subject: EVF.V('ANN_ITEM'),
				docType: "ESTM",
				signStatus: 'P',
				screenId: "CBDI0051",
				approvalType: 'APPROVAL',
				attFileNum: "",
				docNum: EVF.V('ANN_NO'),
				appDocNum: EVF.V('APP_DOC_NUM'),
				callBackFunction: "goApproval",
				appAmt: EVF.isEmpty(EVF.V('PRESUM_AMT')) ? 0 : Number(EVF.V('PRESUM_AMT'))
			};
			everPopup.openApprovalRequestIPopup(param);
		}

		function goApproval(formData, gridData, attachData) {

			EVF.V('approvalFormData', formData);
			EVF.V('approvalGridData', gridData);
			EVF.V('attachFileDatas', attachData);
			var store = new EVF.Store();
			if(!store.validate()) return;
			store.doFileUpload(function() {
				store.load(baseUrl + '/cbdi0051_doSave.so', function () {
					EVF.alert(this.getResponseMessage(), function() {
						opener.doSearch();
						doClose();
					});
				});
			});
		}

		function doClose() {
			EVF.closeWindow();
		}

    </script>
	<e:window id="CBDI0051" initData="${initData}" onReady="init" title="${fullScreenName }" breadCrumbs="${breadCrumb }">

		<e:inputHidden id='BUYER_CD' name="BUYER_CD" value="${empty formData.BUYER_CD ? ses.companyCd : formData.BUYER_CD}" />
		<e:inputHidden id='APP_DOC_NUM' name="APP_DOC_NUM" value="" />
		<e:inputHidden id='APP_DOC_CNT' name="APP_DOC_CNT" value="${formData.APP_DOC_CNT}" />
		<e:inputHidden id='SIGN_STATUS' name="SIGN_STATUS" value="${formData.SIGN_STATUS}" />
		<e:inputHidden id='BID_NUM' name="BID_NUM" value="${formData.BID_NUM}" />
		<e:inputHidden id='BID_CNT' name="BID_CNT" value="${formData.BID_CNT}" />
		<e:inputHidden id="approvalFormData" name="approvalFormData"/>
		<e:inputHidden id="approvalGridData" name="approvalGridData"/>
		<e:inputHidden id="attachFileDatas" name="attachFileDatas" visible="false" />

		<e:buttonBar id="buttonBar" align="right" width="100%">
		<c:if test="${formData.SIGN_STATUS != 'E'}">
			<e:button id="doSave" name="doSave" label="${doSave_N}" onClick="doSave" disabled="${doSave_D}" visible="${doSave_V}"/>
			<e:button id="doSign" name="doSign" label="${doSign_N}" onClick="doSign" disabled="${doSign_D}" visible="${doSign_V}"/>
		</c:if>
			<e:button id="doClose" name="doClose" label="${doClose_N}" onClick="doClose" disabled="${doClose_D}" visible="${doClose_V}"/>
		</e:buttonBar>

		<e:searchPanel id="form" title="${form_CAPTION_N }" labelWidth="${labelWidth}" width="100%" columnCount="2" useTitleBar="false" onEnter="doSearch">
			<e:row>
				<e:label for="ANN_NO" title="${form_ANN_NO_N}" />
				<e:field>
					<e:inputText id="ANN_NO" name="ANN_NO" value="${formData.ANN_NO}" width="100%" maxLength="${form_ANN_NO_M}" disabled="${form_ANN_NO_D}" readOnly="${form_ANN_NO_RO}" required="${form_ANN_NO_R}" style="${imeMode}" maskType="${form_ANN_NO_MT}"/>
				</e:field>
				<e:label for="ANN_DATE" title="${form_ANN_DATE_N}"/>
				<e:field>
					<e:inputDate id="ANN_DATE" name="ANN_DATE" value="${formData.ANN_DATE }" width="${inputDateWidth}" datePicker="true" required="${form_ANN_DATE_R}" disabled="${form_ANN_DATE_D}" readOnly="${form_ANN_DATE_RO}" />
				</e:field>
			</e:row>
			<e:row>
				<e:label for="ANN_ITEM" title="${form_ANN_ITEM_N}" />
				<e:field colSpan="3">
					<e:inputText id="ANN_ITEM" name="ANN_ITEM" value="${formData.ANN_ITEM }" width="100%" maxLength="${form_ANN_ITEM_M}" disabled="${form_ANN_ITEM_D}" readOnly="${form_ANN_ITEM_RO}" required="${form_ANN_ITEM_R}" style="${imeMode}" maskType="${form_ANN_ITEM_MT}"/>
				</e:field>
			</e:row>
			<e:row>
				<e:label for="CONT_TEXT" title="${form_CONT_TEXT_N}" />
				<e:field colSpan="3">
					<e:text>${formData.CONT_TEXT }</e:text>
				</e:field>
			</e:row>
			<e:row>
				<e:label for="PR_AMT" title="${form_PR_AMT_N}"/>
				<e:field>
					<e:select id="CUR1" name="CUR1" value="${formData.CUR}" options="${cur1Options}" width="70px" disabled="${form_CUR1_D}" readOnly="${form_CUR1_RO}" required="${form_CUR1_R}" placeHolder="" maskType="${form_CUR1_MT}" />
					<e:inputNumber id="PR_AMT" name="PR_AMT" value="${formData.PR_AMT }" width="120px" maxValue="${form_PR_AMT_M}" decimalPlace="${form_PR_AMT_NF}" disabled="${form_PR_AMT_D}" readOnly="${form_PR_AMT_RO}" required="${form_PR_AMT_R}" onNumberKr="${form_PR_AMT_KR}" currencyText="${form_PR_AMT_CT}"/>
					<e:select id="VAT_TYPE1" name="VAT_TYPE1" value="${formData.VAT_TYPE}" options="${vatType1Options}" width="70px" disabled="${form_VAT_TYPE1_D}" readOnly="${form_VAT_TYPE1_RO}" required="${form_VAT_TYPE1_R}" placeHolder="" maskType="${form_VAT_TYPE1_MT}" />
				</e:field>
				<e:label for="ESTM_USER_NM" title="${form_ESTM_USER_NM_N}" />
				<e:field>
					<e:inputText id="ESTM_USER_NM" name="ESTM_USER_NM" value="${formData.ESTM_USER_NM }" width="100%" maxLength="${form_ESTM_USER_NM_M}" disabled="${form_ESTM_USER_NM_D}" readOnly="${form_ESTM_USER_NM_RO}" required="${form_ESTM_USER_NM_R}" style="${imeMode}" maskType="${form_ESTM_USER_NM_MT}"/>
				</e:field>
			</e:row>
			<e:row>
				<e:label for="QTA_AMT" title="${form_QTA_AMT_N}"/>
				<e:field>
					<e:select id="CUR2" name="CUR2" value="${formData.CUR}" options="${cur1Options}" width="70px" disabled="${form_CUR1_D}" readOnly="${form_CUR1_RO}" required="${form_CUR1_R}" placeHolder="" maskType="${form_CUR1_MT}" />
					<e:inputNumber id="QTA_AMT" name="QTA_AMT" value="${formData.QTA_AMT }" width="120px" maxValue="${form_QTA_AMT_M}" decimalPlace="${form_QTA_AMT_NF}" disabled="${form_QTA_AMT_D}" readOnly="${form_QTA_AMT_RO}" required="${form_QTA_AMT_R}" onNumberKr="${form_QTA_AMT_KR}" currencyText="${form_QTA_AMT_CT}"/>
					<e:select id="VAT_TYPE2" name="VAT_TYPE2" value="${formData.VAT_TYPE}" options="${vatType1Options}" width="70px" disabled="${form_VAT_TYPE1_D}" readOnly="${form_VAT_TYPE1_RO}" required="${form_VAT_TYPE1_R}" placeHolder="" maskType="${form_VAT_TYPE1_MT}" />
				</e:field>
				<e:label for="QTA_NUM" title="${form_QTA_NUM_N}"/>
				<e:field>
					<e:search id="QTA_NUM" name="QTA_NUM" value="${formData.QTA_NUM }" width="${form_QTA_NUM_W}" maxLength="${form_QTA_NUM_M}" onIconClick="${form_QTA_NUM_RO ? 'everCommon.blank' : ''}" disabled="${form_QTA_NUM_D}" readOnly="${form_QTA_NUM_RO}" required="${form_QTA_NUM_R}" maskType="${form_QTA_NUM_MT}" />
				</e:field>
			</e:row>
			<e:row>
				<e:label for="PRESUM_AMT" title="${form_PRESUM_AMT_N}"/>
				<e:field colSpan="3">
					<e:select id="CUR3" name="CUR3" value="${formData.CUR}" options="${cur1Options}" width="70px" disabled="${form_CUR1_D}" readOnly="${form_CUR1_RO}" required="${form_CUR1_R}" placeHolder="" maskType="${form_CUR1_MT}" />
					<e:inputNumber id="PRESUM_AMT" name="PRESUM_AMT" value="${formData.PRESUM_AMT }" width="120px" maxValue="${form_PRESUM_AMT_M}" decimalPlace="${form_PRESUM_AMT_NF}" disabled="${form_PRESUM_AMT_D}" readOnly="${form_PRESUM_AMT_RO}" required="${form_PRESUM_AMT_R}" onNumberKr="${form_PRESUM_AMT_KR}" currencyText="${form_PRESUM_AMT_CT}"/>
					<e:select id="VAT_TYPE3" name="VAT_TYPE3" value="${formData.VAT_TYPE}" options="${vatType1Options}" width="70px" disabled="${form_VAT_TYPE1_D}" readOnly="${form_VAT_TYPE1_RO}" required="${form_VAT_TYPE1_R}" placeHolder="" maskType="${form_VAT_TYPE1_MT}" />
				</e:field>
			</e:row>
			<e:row>
				<e:label for="RMK" title="${form_RMK_N}" />
				<e:field colSpan="3">
					<e:textArea id="RMK" name="RMK" width="100%" value="${formData.RMK }" height="150px" maxLength="${form_RMK_M}" disabled="${form_RMK_D}" readOnly="${form_RMK_RO}" required="${form_RMK_R}" />
				</e:field>
			</e:row>
			<e:row>
				<e:label for="ATT_FILE_NUM" title="${form_ATT_FILE_NUM_N}" />
				<e:field colSpan="3">
                    <e:fileManager id="ATT_FILE_NUM" width="100%" height="150px" fileId="${formData.ATT_FILE_NUM}" bizType="OM" readOnly="${form_ATT_FILE_NUM_RO}" required="${form_ATT_FILE_NUM_R}"/>
				</e:field>
			</e:row>
		</e:searchPanel>

		<%-- 결재자 리스트 Include --%>
		<jsp:include page="/WEB-INF/views/nhepro/CWOR/CWOR0013.jsp" flush="true" >
			<jsp:param value="${formData.APP_DOC_NUM}" name="APP_DOC_NUM"/>
			<jsp:param value="${formData.APP_DOC_CNT}" name="APP_DOC_CNT"/>
			<jsp:param value="${formData.BUYER_CD}" name="BUYER_CD"/>
		</jsp:include>

	</e:window>
</e:ui>