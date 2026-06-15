<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">

	<script type="text/javascript">

	    var grid;
		var baseUrl = "/nhepro/CBDR/";

	    function init() {

			if('${formData.BID_STATUS}' >= '2400' || '${formData.BID_STATUS}' == '1300') {
				return;
			}
			
			if ('${param.appDocNum}' != '') {
				doOpenerClose();
			}
			
	    	var presumAmt = EVF.V('PRESUM_AMT');
			var estmPrc1Enc = 0; var estmPrc2Enc = 0; var estmPrc3Enc = 0; var estmPrc4Enc = 0; var estmPrc5Enc = 0;
			var estmPrc6Enc = 0; var estmPrc7Enc = 0; var estmPrc8Enc = 0; var estmPrc9Enc = 0; var estmPrc10Enc = 0;
			var estmPrc11Enc = 0; var estmPrc12Enc = 0; var estmPrc13Enc = 0; var estmPrc14Enc = 0; var estmPrc15Enc = 0;

			var minPrc = presumAmt - Math.round(presumAmt * (3/100));
			var maxPrc = presumAmt + Math.round(presumAmt * (3/100));

			estmPrc1Enc  = everMath.floor_float(minPrc + (maxPrc - minPrc) * ((1-1) / (15-1)));
			estmPrc2Enc  = everMath.floor_float(minPrc + (maxPrc - minPrc) * ((2-1) / (15-1)));
			estmPrc3Enc  = everMath.floor_float(minPrc + (maxPrc - minPrc) * ((3-1) / (15-1)));
			estmPrc4Enc  = everMath.floor_float(minPrc + (maxPrc - minPrc) * ((4-1) / (15-1)));
			estmPrc5Enc  = everMath.floor_float(minPrc + (maxPrc - minPrc) * ((5-1) / (15-1)));
			estmPrc6Enc  = everMath.floor_float(minPrc + (maxPrc - minPrc) * ((6-1) / (15-1)));
			estmPrc7Enc  = everMath.floor_float(minPrc + (maxPrc - minPrc) * ((7-1) / (15-1)));
			estmPrc8Enc  = everMath.floor_float(minPrc + (maxPrc - minPrc) * ((8-1) / (15-1)));
			estmPrc9Enc  = everMath.floor_float(minPrc + (maxPrc - minPrc) * ((9-1) / (15-1)));
			estmPrc10Enc = everMath.floor_float(minPrc + (maxPrc - minPrc) * ((10-1) / (15-1)));
			estmPrc11Enc = everMath.floor_float(minPrc + (maxPrc - minPrc) * ((11-1) / (15-1)));
			estmPrc12Enc = everMath.floor_float(minPrc + (maxPrc - minPrc) * ((12-1) / (15-1)));
			estmPrc13Enc = everMath.floor_float(minPrc + (maxPrc - minPrc) * ((13-1) / (15-1)));
			estmPrc14Enc = everMath.floor_float(minPrc + (maxPrc - minPrc) * ((14-1) / (15-1)));
			estmPrc15Enc = everMath.floor_float(minPrc + (maxPrc - minPrc) * ((15-1) / (15-1)));

	    	EVF.V('ESTM_PRC1_ENC',estmPrc1Enc);
	    	EVF.V('ESTM_PRC2_ENC',estmPrc2Enc);
	    	EVF.V('ESTM_PRC3_ENC',estmPrc3Enc);
	    	EVF.V('ESTM_PRC4_ENC',estmPrc4Enc);
	    	EVF.V('ESTM_PRC5_ENC',estmPrc5Enc);
	    	EVF.V('ESTM_PRC6_ENC',estmPrc6Enc);
	    	EVF.V('ESTM_PRC7_ENC',estmPrc7Enc);
	    	EVF.V('ESTM_PRC8_ENC',estmPrc8Enc);
	    	EVF.V('ESTM_PRC9_ENC',estmPrc9Enc);
	    	EVF.V('ESTM_PRC10_ENC',estmPrc10Enc);
	    	EVF.V('ESTM_PRC11_ENC',estmPrc11Enc);
	    	EVF.V('ESTM_PRC12_ENC',estmPrc12Enc);
	    	EVF.V('ESTM_PRC13_ENC',estmPrc13Enc);
	    	EVF.V('ESTM_PRC14_ENC',estmPrc14Enc);
	    	EVF.V('ESTM_PRC15_ENC',estmPrc15Enc);


	    	EVF.V('HIDDEN_ESTM_PRC1_ENC',estmPrc1Enc);
	    	EVF.V('HIDDEN_ESTM_PRC2_ENC',estmPrc2Enc);
	    	EVF.V('HIDDEN_ESTM_PRC3_ENC',estmPrc3Enc);
	    	EVF.V('HIDDEN_ESTM_PRC4_ENC',estmPrc4Enc);
	    	EVF.V('HIDDEN_ESTM_PRC5_ENC',estmPrc5Enc);
	    	EVF.V('HIDDEN_ESTM_PRC6_ENC',estmPrc6Enc);
	    	EVF.V('HIDDEN_ESTM_PRC7_ENC',estmPrc7Enc);
	    	EVF.V('HIDDEN_ESTM_PRC8_ENC',estmPrc8Enc);
	    	EVF.V('HIDDEN_ESTM_PRC9_ENC',estmPrc9Enc);
	    	EVF.V('HIDDEN_ESTM_PRC10_ENC',estmPrc10Enc);
	    	EVF.V('HIDDEN_ESTM_PRC11_ENC',estmPrc11Enc);
	    	EVF.V('HIDDEN_ESTM_PRC12_ENC',estmPrc12Enc);
	    	EVF.V('HIDDEN_ESTM_PRC13_ENC',estmPrc13Enc);
	    	EVF.V('HIDDEN_ESTM_PRC14_ENC',estmPrc14Enc);
	    	EVF.V('HIDDEN_ESTM_PRC15_ENC',estmPrc15Enc);
		}
	    
	    function doOpenerClose() {
	    	opener.onClose();
		}

		function doSave() {
			var store = new EVF.Store();
			if(!store.validate()) return;
			EVF.confirm('${msg.M0021}', function () {
				goApproval('T');
			});
		}

		function doConfirm() {

			var store = new EVF.Store();
			if(!store.validate()) return;

			EVF.confirm('${CBDI0053_001}', function () {
				goApproval('E');
			});
		}

		function goApproval(status) {

			EVF.C("STATUS").setValue(status);

			var store = new EVF.Store();
			if(!store.validate()) return;
			store.doFileUpload(function() {
				if(status == "E") { var ar = randomArray(15); }
				store.load(baseUrl + '/cbdi0053_doSave.so', function () {
	        		EVF.alert(this.getResponseMessage(), function() {
	        			if(opener) {
	        				opener.doSearch();
		                    doClose();
	        			} else {
		                    doClose();
	        			}
					});
				});
			});
		}

		function randomArray(n) {

			var ar = new Array();
			var temp;
			var rnum;
			for(var i = 1; i <= n; i++) {
				ar.push(i);
			}
			for(var i = 1; i <= ar.length; i++) {
				rnum = Math.floor( Math.random() * n);
//				if(rnum < 16) {
					temp = EVF.V('HIDDEN_ESTM_PRC'+(i)+'_ENC');
					EVF.V('HIDDEN_ESTM_PRC'+(i)+'_ENC', EVF.V('HIDDEN_ESTM_PRC'+ar[rnum]+'_ENC'));
					EVF.V('HIDDEN_ESTM_PRC'+ar[rnum]+'_ENC', temp);
//				}
			}
			return ar;
		}

		function doClose() {
			if ('${param.appDocNum}' == '') {
				EVF.closeWindow();
			} else {
				doClose2();
			}
		}
		
		function doClose2() {
			window.close();
		}

    </script>
	<e:window id="CBDI0053" initData="${initData}" onReady="init" title="${fullScreenName }" breadCrumbs="${breadCrumb }">

		<e:inputHidden id='BUYER_CD' name="BUYER_CD" value="${empty formData.BUYER_CD ? ses.companyCd : formData.BUYER_CD}" />
		<e:inputHidden id='SIGN_STATUS' name="SIGN_STATUS" value="${formData.SIGN_STATUS}" />
		<e:inputHidden id='BID_NUM' name="BID_NUM" value="${formData.BID_NUM}" />
		<e:inputHidden id='BID_CNT' name="BID_CNT" value="${formData.BID_CNT}" />
		<e:inputHidden id='STATUS' name="STATUS" value="${formData.STATUS}" />

		<e:inputHidden id='HIDDEN_ESTM_PRC1_ENC' name="HIDDEN_ESTM_PRC1_ENC" value="" />
		<e:inputHidden id='HIDDEN_ESTM_PRC2_ENC' name="HIDDEN_ESTM_PRC2_ENC" value="" />
		<e:inputHidden id='HIDDEN_ESTM_PRC3_ENC' name="HIDDEN_ESTM_PRC3_ENC" value="" />
		<e:inputHidden id='HIDDEN_ESTM_PRC4_ENC' name="HIDDEN_ESTM_PRC4_ENC" value="" />
		<e:inputHidden id='HIDDEN_ESTM_PRC5_ENC' name="HIDDEN_ESTM_PRC5_ENC" value="" />
		<e:inputHidden id='HIDDEN_ESTM_PRC6_ENC' name="HIDDEN_ESTM_PRC6_ENC" value="" />
		<e:inputHidden id='HIDDEN_ESTM_PRC7_ENC' name="HIDDEN_ESTM_PRC7_ENC" value="" />
		<e:inputHidden id='HIDDEN_ESTM_PRC8_ENC' name="HIDDEN_ESTM_PRC8_ENC" value="" />
		<e:inputHidden id='HIDDEN_ESTM_PRC9_ENC' name="HIDDEN_ESTM_PRC9_ENC" value="" />
		<e:inputHidden id='HIDDEN_ESTM_PRC10_ENC' name="HIDDEN_ESTM_PRC10_ENC" value="" />
		<e:inputHidden id='HIDDEN_ESTM_PRC11_ENC' name="HIDDEN_ESTM_PRC11_ENC" value="" />
		<e:inputHidden id='HIDDEN_ESTM_PRC12_ENC' name="HIDDEN_ESTM_PRC12_ENC" value="" />
		<e:inputHidden id='HIDDEN_ESTM_PRC13_ENC' name="HIDDEN_ESTM_PRC13_ENC" value="" />
		<e:inputHidden id='HIDDEN_ESTM_PRC14_ENC' name="HIDDEN_ESTM_PRC14_ENC" value="" />
		<e:inputHidden id='HIDDEN_ESTM_PRC15_ENC' name="HIDDEN_ESTM_PRC15_ENC" value="" />

		<e:buttonBar id="buttonBar" title="${CBDI0053_002}" align="right" width="100%">
			<e:button id="doSave" name="doSave" label="${doSave_N}" onClick="doSave" disabled="${doSave_D}" visible="${doSave_V}"/>
			<e:button id="doConfirm" name="doConfirm" label="${doConfirm_N}" onClick="doConfirm" disabled="${doConfirm_D}" visible="${doConfirm_V}"/>
			<e:button id="doClose" name="doClose" label="${doClose_N}" onClick="doClose" disabled="${doClose_D}" visible="${doClose_V}"/>
		</e:buttonBar>

		<e:searchPanel id="form" labelWidth="${labelWidth}" width="100%" columnCount="2" useTitleBar="false" onEnter="doSearch">
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
					<e:inputNumber id="PR_AMT" name="PR_AMT" value="${formData.PR_AMT }" width="${form_PR_AMT_W}" maxValue="${form_PR_AMT_M}" decimalPlace="${form_PR_AMT_NF}" disabled="${form_PR_AMT_D}" readOnly="${form_PR_AMT_RO}" required="${form_PR_AMT_R}" onNumberKr="${form_PR_AMT_KR}" currencyText="${form_PR_AMT_CT}"/>
					<e:select id="VAT_TYPE1" name="VAT_TYPE1" value="${formData.VAT_TYPE}" options="${vatType1Options}" width="70px" disabled="${form_VAT_TYPE1_D}" readOnly="${form_VAT_TYPE1_RO}" required="${form_VAT_TYPE1_R}" placeHolder="" maskType="${form_VAT_TYPE1_MT}" />
				</e:field>
				<e:label for="ESTM_USER_NM" title="${form_ESTM_USER_NM_N}" />
				<e:field>
					<e:inputText id="ESTM_USER_NM" name="ESTM_USER_NM" value="${formData.ESTM_USER_NM }" width="100%" maxLength="${form_ESTM_USER_NM_M}" disabled="${form_ESTM_USER_NM_D}" readOnly="${form_ESTM_USER_NM_RO}" required="${form_ESTM_USER_NM_R}" style="${imeMode}" maskType="${form_ESTM_USER_NM_MT}"/>
				</e:field>
			</e:row>
			<e:row>
				<e:label for="PRESUM_AMT" title="${form_PRESUM_AMT_N}"/>
				<e:field colSpan="3">
					<e:select id="CUR2" name="CUR2" value="${formData.CUR}" options="${cur1Options}" width="70px" disabled="${form_CUR1_D}" readOnly="${form_CUR1_RO}" required="${form_CUR1_R}" placeHolder="" maskType="${form_CUR1_MT}" />
					<e:inputNumber id="PRESUM_AMT" name="PRESUM_AMT" value="${formData.PRESUM_AMT }" width="${form_PRESUM_AMT_W}" maxValue="${form_PRESUM_AMT_M}" decimalPlace="${form_PRESUM_AMT_NF}" disabled="${form_PRESUM_AMT_D}" readOnly="${form_PRESUM_AMT_RO}" required="${form_PRESUM_AMT_R}" onNumberKr="${form_PRESUM_AMT_KR}" currencyText="${form_PRESUM_AMT_CT}"/>
					<e:select id="VAT_TYPE2" name="VAT_TYPE2" value="${formData.VAT_TYPE}" options="${vatType1Options}" width="70px" disabled="${form_VAT_TYPE1_D}" readOnly="${form_VAT_TYPE1_RO}" required="${form_VAT_TYPE1_R}" placeHolder="" maskType="${form_VAT_TYPE1_MT}" />
				</e:field>
			</e:row>
		</e:searchPanel>

		<e:searchPanel id="form2" title="${CBDI0053_003}" labelWidth="${labelWidth}" width="100%" columnCount="3" useTitleBar="true" onEnter="doSearch">
			<e:row>
				<e:label for="ESTM_PRC1_ENC" title="${form_ESTM_PRC1_ENC_N}"/>
				<e:field>
					<e:inputNumber id="ESTM_PRC1_ENC" name="ESTM_PRC1_ENC" value="${formData.ESTM_PRC1_ENC}" width="${form_ESTM_PRC1_ENC_W}" maxValue="${form_ESTM_PRC1_ENC_M}" decimalPlace="${form_ESTM_PRC1_ENC_NF}" disabled="${form_ESTM_PRC1_ENC_D}" readOnly="${form_ESTM_PRC1_ENC_RO}" required="${form_ESTM_PRC1_ENC_R}" onNumberKr="${form_ESTM_PRC1_ENC_KR}" currencyText="${form_ESTM_PRC1_ENC_CT}"/>
				</e:field>
				<e:label for="ESTM_PRC6_ENC" title="${form_ESTM_PRC6_ENC_N}"/>
				<e:field>
					<e:inputNumber id="ESTM_PRC6_ENC" name="ESTM_PRC6_ENC" value="${formData.ESTM_PRC6_ENC}" width="${form_ESTM_PRC6_ENC_W}" maxValue="${form_ESTM_PRC6_ENC_M}" decimalPlace="${form_ESTM_PRC6_ENC_NF}" disabled="${form_ESTM_PRC6_ENC_D}" readOnly="${form_ESTM_PRC6_ENC_RO}" required="${form_ESTM_PRC6_ENC_R}" onNumberKr="${form_ESTM_PRC6_ENC_KR}" currencyText="${form_ESTM_PRC6_ENC_CT}"/>
				</e:field>
				<e:label for="ESTM_PRC11_ENC" title="${form_ESTM_PRC11_ENC_N}"/>
				<e:field>
					<e:inputNumber id="ESTM_PRC11_ENC" name="ESTM_PRC11_ENC" value="${formData.ESTM_PRC11_ENC}" width="${form_ESTM_PRC11_ENC_W}" maxValue="${form_ESTM_PRC11_ENC_M}" decimalPlace="${form_ESTM_PRC11_ENC_NF}" disabled="${form_ESTM_PRC11_ENC_D}" readOnly="${form_ESTM_PRC11_ENC_RO}" required="${form_ESTM_PRC11_ENC_R}" onNumberKr="${form_ESTM_PRC11_ENC_KR}" currencyText="${form_ESTM_PRC11_ENC_CT}"/>
				</e:field>
			</e:row>
			<e:row>
				<e:label for="ESTM_PRC2_ENC" title="${form_ESTM_PRC2_ENC_N}"/>
				<e:field>
					<e:inputNumber id="ESTM_PRC2_ENC" name="ESTM_PRC2_ENC" value="${formData.ESTM_PRC2_ENC}" width="${form_ESTM_PRC2_ENC_W}" maxValue="${form_ESTM_PRC2_ENC_M}" decimalPlace="${form_ESTM_PRC2_ENC_NF}" disabled="${form_ESTM_PRC2_ENC_D}" readOnly="${form_ESTM_PRC2_ENC_RO}" required="${form_ESTM_PRC2_ENC_R}" onNumberKr="${form_ESTM_PRC2_ENC_KR}" currencyText="${form_ESTM_PRC2_ENC_CT}"/>
				</e:field>
				<e:label for="ESTM_PRC7_ENC" title="${form_ESTM_PRC7_ENC_N}"/>
				<e:field>
					<e:inputNumber id="ESTM_PRC7_ENC" name="ESTM_PRC7_ENC" value="${formData.ESTM_PRC7_ENC}" width="${form_ESTM_PRC7_ENC_W}" maxValue="${form_ESTM_PRC7_ENC_M}" decimalPlace="${form_ESTM_PRC7_ENC_NF}" disabled="${form_ESTM_PRC7_ENC_D}" readOnly="${form_ESTM_PRC7_ENC_RO}" required="${form_ESTM_PRC7_ENC_R}" onNumberKr="${form_ESTM_PRC7_ENC_KR}" currencyText="${form_ESTM_PRC7_ENC_CT}"/>
				</e:field>
				<e:label for="ESTM_PRC12_ENC" title="${form_ESTM_PRC12_ENC_N}"/>
				<e:field>
					<e:inputNumber id="ESTM_PRC12_ENC" name="ESTM_PRC12_ENC" value="${formData.ESTM_PRC12_ENC}" width="${form_ESTM_PRC12_ENC_W}" maxValue="${form_ESTM_PRC12_ENC_M}" decimalPlace="${form_ESTM_PRC12_ENC_NF}" disabled="${form_ESTM_PRC12_ENC_D}" readOnly="${form_ESTM_PRC12_ENC_RO}" required="${form_ESTM_PRC12_ENC_R}" onNumberKr="${form_ESTM_PRC12_ENC_KR}" currencyText="${form_ESTM_PRC12_ENC_CT}"/>
				</e:field>
			</e:row>
			<e:row>
				<e:label for="ESTM_PRC3_ENC" title="${form_ESTM_PRC3_ENC_N}"/>
				<e:field>
					<e:inputNumber id="ESTM_PRC3_ENC" name="ESTM_PRC3_ENC" value="${formData.ESTM_PRC3_ENC}" width="${form_ESTM_PRC3_ENC_W}" maxValue="${form_ESTM_PRC3_ENC_M}" decimalPlace="${form_ESTM_PRC3_ENC_NF}" disabled="${form_ESTM_PRC3_ENC_D}" readOnly="${form_ESTM_PRC3_ENC_RO}" required="${form_ESTM_PRC3_ENC_R}" onNumberKr="${form_ESTM_PRC3_ENC_KR}" currencyText="${form_ESTM_PRC3_ENC_CT}"/>
				</e:field>
				<e:label for="ESTM_PRC8_ENC" title="${form_ESTM_PRC8_ENC_N}"/>
				<e:field>
					<e:inputNumber id="ESTM_PRC8_ENC" name="ESTM_PRC8_ENC" value="${formData.ESTM_PRC8_ENC}" width="${form_ESTM_PRC8_ENC_W}" maxValue="${form_ESTM_PRC8_ENC_M}" decimalPlace="${form_ESTM_PRC8_ENC_NF}" disabled="${form_ESTM_PRC8_ENC_D}" readOnly="${form_ESTM_PRC8_ENC_RO}" required="${form_ESTM_PRC8_ENC_R}" onNumberKr="${form_ESTM_PRC8_ENC_KR}" currencyText="${form_ESTM_PRC8_ENC_CT}"/>
				</e:field>
				<e:label for="ESTM_PRC13_ENC" title="${form_ESTM_PRC13_ENC_N}"/>
				<e:field>
					<e:inputNumber id="ESTM_PRC13_ENC" name="ESTM_PRC13_ENC" value="${formData.ESTM_PRC13_ENC}" width="${form_ESTM_PRC13_ENC_W}" maxValue="${form_ESTM_PRC13_ENC_M}" decimalPlace="${form_ESTM_PRC13_ENC_NF}" disabled="${form_ESTM_PRC13_ENC_D}" readOnly="${form_ESTM_PRC13_ENC_RO}" required="${form_ESTM_PRC13_ENC_R}" onNumberKr="${form_ESTM_PRC13_ENC_KR}" currencyText="${form_ESTM_PRC13_ENC_CT}"/>
				</e:field>
			</e:row>
			<e:row>
				<e:label for="ESTM_PRC4_ENC" title="${form_ESTM_PRC4_ENC_N}"/>
				<e:field>
					<e:inputNumber id="ESTM_PRC4_ENC" name="ESTM_PRC4_ENC" value="${formData.ESTM_PRC4_ENC}" width="${form_ESTM_PRC4_ENC_W}" maxValue="${form_ESTM_PRC4_ENC_M}" decimalPlace="${form_ESTM_PRC4_ENC_NF}" disabled="${form_ESTM_PRC4_ENC_D}" readOnly="${form_ESTM_PRC4_ENC_RO}" required="${form_ESTM_PRC4_ENC_R}" onNumberKr="${form_ESTM_PRC4_ENC_KR}" currencyText="${form_ESTM_PRC4_ENC_CT}"/>
				</e:field>
				<e:label for="ESTM_PRC9_ENC" title="${form_ESTM_PRC9_ENC_N}"/>
				<e:field>
					<e:inputNumber id="ESTM_PRC9_ENC" name="ESTM_PRC9_ENC" value="${formData.ESTM_PRC9_ENC}" width="${form_ESTM_PRC9_ENC_W}" maxValue="${form_ESTM_PRC9_ENC_M}" decimalPlace="${form_ESTM_PRC9_ENC_NF}" disabled="${form_ESTM_PRC9_ENC_D}" readOnly="${form_ESTM_PRC9_ENC_RO}" required="${form_ESTM_PRC9_ENC_R}" onNumberKr="${form_ESTM_PRC9_ENC_KR}" currencyText="${form_ESTM_PRC9_ENC_CT}"/>
				</e:field>
				<e:label for="ESTM_PRC14_ENC" title="${form_ESTM_PRC14_ENC_N}"/>
				<e:field>
					<e:inputNumber id="ESTM_PRC14_ENC" name="ESTM_PRC14_ENC" value="${formData.ESTM_PRC14_ENC}" width="${form_ESTM_PRC14_ENC_W}" maxValue="${form_ESTM_PRC14_ENC_M}" decimalPlace="${form_ESTM_PRC14_ENC_NF}" disabled="${form_ESTM_PRC14_ENC_D}" readOnly="${form_ESTM_PRC14_ENC_RO}" required="${form_ESTM_PRC14_ENC_R}" onNumberKr="${form_ESTM_PRC14_ENC_KR}" currencyText="${form_ESTM_PRC14_ENC_CT}"/>
				</e:field>
			</e:row>
			<e:row>
				<e:label for="ESTM_PRC5_ENC" title="${form_ESTM_PRC5_ENC_N}"/>
				<e:field>
					<e:inputNumber id="ESTM_PRC5_ENC" name="ESTM_PRC5_ENC" value="${formData.ESTM_PRC5_ENC}" width="${form_ESTM_PRC5_ENC_W}" maxValue="${form_ESTM_PRC5_ENC_M}" decimalPlace="${form_ESTM_PRC5_ENC_NF}" disabled="${form_ESTM_PRC5_ENC_D}" readOnly="${form_ESTM_PRC5_ENC_RO}" required="${form_ESTM_PRC5_ENC_R}" onNumberKr="${form_ESTM_PRC5_ENC_KR}" currencyText="${form_ESTM_PRC5_ENC_CT}"/>
				</e:field>
				<e:label for="ESTM_PRC10_ENC" title="${form_ESTM_PRC10_ENC_N}"/>
				<e:field>
					<e:inputNumber id="ESTM_PRC10_ENC" name="ESTM_PRC10_ENC" value="${formData.ESTM_PRC10_ENC}" width="${form_ESTM_PRC10_ENC_W}" maxValue="${form_ESTM_PRC10_ENC_M}" decimalPlace="${form_ESTM_PRC10_ENC_NF}" disabled="${form_ESTM_PRC10_ENC_D}" readOnly="${form_ESTM_PRC10_ENC_RO}" required="${form_ESTM_PRC10_ENC_R}" onNumberKr="${form_ESTM_PRC10_ENC_KR}" currencyText="${form_ESTM_PRC10_ENC_CT}"/>
				</e:field>
				<e:label for="ESTM_PRC15_ENC" title="${form_ESTM_PRC15_ENC_N}"/>
				<e:field>
					<e:inputNumber id="ESTM_PRC15_ENC" name="ESTM_PRC15_ENC" value="${formData.ESTM_PRC15_ENC}" width="${form_ESTM_PRC15_ENC_W}" maxValue="${form_ESTM_PRC15_ENC_M}" decimalPlace="${form_ESTM_PRC15_ENC_NF}" disabled="${form_ESTM_PRC15_ENC_D}" readOnly="${form_ESTM_PRC15_ENC_RO}" required="${form_ESTM_PRC15_ENC_R}" onNumberKr="${form_ESTM_PRC15_ENC_KR}" currencyText="${form_ESTM_PRC15_ENC_CT}"/>
				</e:field>
			</e:row>
			<e:row>
				<e:label for="ESTM_AVGPRC_ENC" title="${form_ESTM_AVGPRC_ENC_N}"/>
				<e:field colSpan="5">
					<e:select id="CUR3" name="CUR3" value="${formData.CUR}" options="${cur1Options}" width="70px" disabled="${form_CUR1_D}" readOnly="${form_CUR1_RO}" required="${form_CUR1_R}" placeHolder="" maskType="${form_CUR1_MT}" />
					<e:inputNumber id="ESTM_AVGPRC_ENC" name="ESTM_AVGPRC_ENC" value="${formData.ESTM_AVGPRC_ENC}" width="${form_ESTM_AVGPRC_ENC_W}" maxValue="${form_ESTM_AVGPRC_ENC_M}" decimalPlace="${form_ESTM_AVGPRC_ENC_NF}" disabled="${form_ESTM_AVGPRC_ENC_D}" readOnly="${form_ESTM_AVGPRC_ENC_RO}" required="${form_ESTM_AVGPRC_ENC_R}" onNumberKr="${form_ESTM_AVGPRC_ENC_KR}" currencyText="${form_ESTM_AVGPRC_ENC_CT}"/>
					<e:select id="VAT_TYPE3" name="VAT_TYPE3" value="${formData.VAT_TYPE}" options="${vatType1Options}" width="70px" disabled="${form_VAT_TYPE1_D}" readOnly="${form_VAT_TYPE1_RO}" required="${form_VAT_TYPE1_R}" placeHolder="" maskType="${form_VAT_TYPE1_MT}" />
				</e:field>
			</e:row>
		</e:searchPanel>
	</e:window>
</e:ui>