<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">

	<script type="text/javascript">
	    var grid;
		var baseUrl = "/nhepro/CBDR/";

	    function init() {
			EVF.C('ESTM_PRC1_ENC_TXT').setStyle("color:#FF0000;font-weight:bold;");
	    	setText();
	    	
			if ('${param.appDocNum}' != '') {
				doOpenerClose();
			}
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
			
			var pr_amt       = EVF.V('PR_AMT');
			var presum_amt   = EVF.V('PRESUM_AMT'); 
			var estm_prc1_en = EVF.V('ESTM_PRC1_ENC'); 
			var presum_per   = (Number(presum_amt) * 80) / 100;
			
			/** 20.12.22 농협정보 요청 
			 *  예정가격은 예산금액 및 추정예정가격보다 높은 금액입력 또는 추정예정가격 대비 80%미만 금액입력 시 alert
			 */
			if((Number(pr_amt) < Number(estm_prc1_en)) || (Number(presum_amt) < Number(estm_prc1_en))) {
				return EVF.alert("확정예정가격은 예산 및 추정예정가격보다 높게 작성 할 수 없습니다.");
			}
			
			if(presum_per > Number(estm_prc1_en)){
				EVF.confirm("확정예정가격은 추정예정가격 대비 80% 미만 금액은 작성 할 수 없습니다.\n작성하시겠습니까?", function () {
					var confirmMsg = "${form_FINAL_ESTM_PRC_N} " + EVF.V("ESTM_PRC1_ENC_TXT") + "을 " + '${CBDI0052_001}';
					EVF.confirm(confirmMsg , function () {
						goApproval('E');
					});
				});
				//return EVF.alert("확정예정가격은 추정예정가격 대비 80% 미만 금액은 작성 할 수 없습니다.");
			}else{
				var confirmMsg = "${form_FINAL_ESTM_PRC_N} " + EVF.V("ESTM_PRC1_ENC_TXT") + "을 " + '${CBDI0052_001}';
				EVF.confirm(confirmMsg , function () {
					goApproval('E');
				});
			}
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

		function goApproval(status) {
			EVF.C("STATUS").setValue(status);
			var store = new EVF.Store();
			if(!store.validate()) return;
			store.doFileUpload(function() {
				store.load(baseUrl + '/cbdi0052_doSave.so', function () {
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
		
		//2024.03.06 확정예가금액 숫자 입력 시 실시간 한글변환
		function setText() {
			
			setTimeout(function () {
				var element = Number(EVF.V('ESTM_PRC1_ENC'));
				var num = String(element);
				var hanA = new Array("", "일", "이", "삼", "사", "오", "육", "칠", "팔", "구");
				var danA = new Array("", "십", "백", "천", "", "십", "백", "천", "", "십", "백", "천", "", "십", "백", "천");
				var result = "";
	
				var C1 = true;
				var C2 = true;
				var C3 = true;
				for (var i = 0; i < num.length; i++) {
					var str = "";
					var han = hanA[num.charAt(num.length - (i + 1))];
					if (han != "") {
						str += han+danA[i];
	
						if (4 <= i && i <= 7  && C1 == true) {str += "만"; C1 = false;}
						if (8 <= i && i <= 11 && C2 == true) {str += "억"; C2 = false;}
						if (i >= 12 && C3 == true) {str += "조"; C3 = false;}
						result = str + result;
					}
				}
	
				result = (EVF.V('CUR3') == "KRW") ? " ( 금 " + result + "원 )" : " ( " + result + " " + EVF.V('CUR3') +" )";
				EVF.C("ESTM_PRC1_ENC_TXT").setValue(result);
			}, 300);
		}
		
		
    </script>
	<e:window id="CBDI0052" initData="${initData}" onReady="init" title="${fullScreenName }" breadCrumbs="${breadCrumb }">

		<e:buttonBar id="buttonBar" align="right" width="100%">
			<%--
			<e:button id="doSave" name="doSave" label="${doSave_N}" onClick="doSave" disabled="${doSave_D}" visible="${doSave_V}"/>
			--%>
			<e:button id="doConfirm" name="doConfirm" label="${doConfirm_N}" onClick="doConfirm" disabled="${doConfirm_D}" visible="${doConfirm_V}"/>
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
				<e:text id="test1">${formData.CONT_TEXT }</e:text>
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
			<e:row>
				<e:label for="FINAL_ESTM_PRC" title="${form_FINAL_ESTM_PRC_N}"/>
				<e:field colSpan="3">
				<e:select id="CUR3" name="CUR3" value="${formData.CUR}" options="${cur1Options}" width="70px" disabled="${form_CUR1_D}" readOnly="${form_CUR1_RO}" required="${form_CUR1_R}" placeHolder="" maskType="${form_CUR1_MT}" />
				<e:inputNumber id="ESTM_PRC1_ENC" name="ESTM_PRC1_ENC" value="${formData.ESTM_PRC1_ENC}" width="${form_ESTM_PRC1_ENC_W}" maxValue="${form_ESTM_PRC1_ENC_M}" decimalPlace="${form_ESTM_PRC1_ENC_NF}" disabled="${form_ESTM_PRC1_ENC_D}" readOnly="${form_ESTM_PRC1_ENC_RO}" required="${form_ESTM_PRC1_ENC_R}" onNumberKr="${form_ESTM_PRC1_ENC_KR}" currencyText="${form_ESTM_PRC1_ENC_CT}" onKeyDown="setText"/>
				<e:select id="VAT_TYPE3" name="VAT_TYPE3" value="${formData.VAT_TYPE}" options="${vatType1Options}" width="70px" disabled="${form_VAT_TYPE1_D}" readOnly="${form_VAT_TYPE1_RO}" required="${form_VAT_TYPE1_R}" placeHolder="" maskType="${form_VAT_TYPE1_MT}" />
				<e:inputText id="ESTM_PRC1_ENC_TXT" name="ESTM_PRC1_ENC_TXT" width="60%" maxLength="${form_ESTM_PRC1_ENC_TXT_M}" disabled="${form_ESTM_PRC1_ENC_TXT_D}" readOnly="${form_ESTM_PRC1_ENC_TXT_RO}" required="${form_ESTM_PRC1_ENC_TXT_R}" style="${imeMode}" maskType="${form_ESTM_PRC1_ENC_TXT_MT}"/>
				</e:field>
			</e:row>

	   		<e:inputHidden id='BUYER_CD' name="BUYER_CD" value="${empty formData.BUYER_CD ? ses.companyCd : formData.BUYER_CD}" />
	    	<e:inputHidden id='SIGN_STATUS' name="SIGN_STATUS" value="${formData.SIGN_STATUS}" />
	    	<e:inputHidden id='BID_NUM' name="BID_NUM" value="${formData.BID_NUM}" />
	    	<e:inputHidden id='BID_CNT' name="BID_CNT" value="${formData.BID_CNT}" />
	    	<e:inputHidden id='STATUS' name="STATUS" value="${formData.STATUS}" />
		</e:searchPanel>

	</e:window>
</e:ui>