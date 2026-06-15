<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">

	<script type="text/javascript">
	    var grid;
		var baseUrl = "/nhepro/CBDI/";
		var screenId = ("${param.screenID}" == null ? "" : "${param.screenID}");
		
	    function init() {
	    	
	    	var contType2 = EVF.V('CONT_TYPE2');
	    	
	    	var appBeginDate = EVF.C("APP_BEGIN_DATE").getValue();
	    	var appEndDate = EVF.C("APP_END_DATE").getValue();
	    	
	    	var bidBeginDate = EVF.C("BID_BEGIN_DATE").getValue();
	    	var bidEndDate = EVF.C("BID_END_DATE").getValue();
	    	
	    	var openDate = EVF.C("OPEN_DATE").getValue();
	    	
	    	if(screenId == 'CBDI0020'){ //입찰등록화면에서 들어오는 경우
	    		
	    		if(contType2 == "TD") { //2단계 분리입찰의 2단계 입찰전인 경우
	    			
	    			$("#sp_form tr:eq(4)").hide();
					$("#sp_form tr:eq(5)").hide();
					
	    			EVF.C("PERIOD_MOD_RSN").setValue(" * 변경 전 기간\n - 입찰등록일시  : "+appBeginDate.substring(0,4)+"년 "+appBeginDate.substring(4,6)+"월 "+appBeginDate.substring(6,8)+"일 "+EVF.C("APP_BEGIN_TIME").getValue()+"시 "+EVF.C("APP_BEGIN_MIN").getValue()+"분  ~"
			    			+appEndDate.substring(0,4)+"년 "+appEndDate.substring(4,6)+"월 "+appEndDate.substring(6,8)+"일 "+EVF.C("APP_END_TIME").getValue()+"시 "+EVF.C("APP_END_MIN").getValue()+"분\n\n * 변경 사유\n"
			    			);
	    		} else {
	    			
	    			$("#sp_form tr:eq(4)").show();
					$("#sp_form tr:eq(5)").show();
					
	    			EVF.C("PERIOD_MOD_RSN").setValue(" * 변경 전 기간\n - 입찰등록일시  : "+appBeginDate.substring(0,4)+"년 "+appBeginDate.substring(4,6)+"월 "+appBeginDate.substring(6,8)+"일 "+EVF.C("APP_BEGIN_TIME").getValue()+"시 "+EVF.C("APP_BEGIN_MIN").getValue()+"분  ~"
			    			+appEndDate.substring(0,4)+"년 "+appEndDate.substring(4,6)+"월 "+appEndDate.substring(6,8)+"일 "+EVF.C("APP_END_TIME").getValue()+"시 "+EVF.C("APP_END_MIN").getValue()+"분\n - 입찰서 제출일시 : "
			    			+bidBeginDate.substring(0,4)+"년 "+bidBeginDate.substring(4,6)+"월 "+bidBeginDate.substring(6,8)+"일 "+EVF.C("BID_BEGIN_TIME").getValue()+"시 "+EVF.C("BID_BEGIN_MIN").getValue()+"분 ~ "
			    			+bidEndDate.substring(0,4)+"년 "+bidEndDate.substring(4,6)+"월 "+bidEndDate.substring(6,8)+"일 "+EVF.C("BID_END_TIME").getValue()+"시 "+EVF.C("BID_END_MIN").getValue()+"분\n - 개찰일시 : "
			    			+openDate.substring(0,4)+"년 "+openDate.substring(4,6)+"월 "+openDate.substring(6,8)+"일 "+EVF.C("OPEN_TIME").getValue()+"시 "+EVF.C("OPEN_MIN").getValue()+"분\n\n * 변경 사유\n"
			    			);
	    		}
	    	} else { //입찰진행화면에서 들어오는 경우 
	    		EVF.C("APP_END_DATE").setReadOnly(true);
	    		EVF.C("APP_END_TIME").setReadOnly(true);
	    		EVF.C("APP_END_MIN").setReadOnly(true);
	    		
	    		EVF.C("BID_BEGIN_DATE").setReadOnly(true);
	    		EVF.C("BID_BEGIN_TIME").setReadOnly(true);
	    		EVF.C("BID_BEGIN_MIN").setReadOnly(true);
	    		
	    		EVF.C("PERIOD_MOD_RSN").setValue(" * 변경 전 기간\n - 입찰등록일시  : "+appBeginDate.substring(0,4)+"년 "+appBeginDate.substring(4,6)+"월 "+appBeginDate.substring(6,8)+"일 "+EVF.C("APP_BEGIN_TIME").getValue()+"시 "+EVF.C("APP_BEGIN_MIN").getValue()+"분  ~"
		    			+appEndDate.substring(0,4)+"년 "+appEndDate.substring(4,6)+"월 "+appEndDate.substring(6,8)+"일 "+EVF.C("APP_END_TIME").getValue()+"시 "+EVF.C("APP_END_MIN").getValue()+"분\n - 입찰서 제출일시 : "
		    			+bidBeginDate.substring(0,4)+"년 "+bidBeginDate.substring(4,6)+"월 "+bidBeginDate.substring(6,8)+"일 "+EVF.C("BID_BEGIN_TIME").getValue()+"시 "+EVF.C("BID_BEGIN_MIN").getValue()+"분 ~ "
		    			+bidEndDate.substring(0,4)+"년 "+bidEndDate.substring(4,6)+"월 "+bidEndDate.substring(6,8)+"일 "+EVF.C("BID_END_TIME").getValue()+"시 "+EVF.C("BID_END_MIN").getValue()+"분\n - 개찰일시 : "
		    			+openDate.substring(0,4)+"년 "+openDate.substring(4,6)+"월 "+openDate.substring(6,8)+"일 "+EVF.C("OPEN_TIME").getValue()+"시 "+EVF.C("OPEN_MIN").getValue()+"분\n\n * 변경 사유\n"
		    			);
	    	}
		}
	    
		function doSave() {
			
			var contType2 = EVF.V('CONT_TYPE2');
			
			if(screenId == 'CBDI0020'){
				if(!checkTimeToServer(EVF.C("APP_END_DATE").getValue(), EVF.C("APP_END_TIME").getValue(), EVF.C("APP_END_MIN").getValue())) {
					EVF.alert("${form_APP_END_DATE_N}" + '의 ' + '${CBDI0022_005}', function () {
						EVF.C('APP_END_DATE').setFocus();
	                });
					return;
				}
				
				if(!checkTimeToValue(EVF.C("APP_BEGIN_DATE").getValue(), EVF.C("APP_BEGIN_TIME").getValue(), EVF.C("APP_BEGIN_MIN").getValue(), EVF.C("APP_END_DATE").getValue(), EVF.C("APP_END_TIME").getValue(), EVF.C("APP_END_MIN").getValue())) {
					EVF.alert("${form_APP_END_DATE_N}" + '의 ' + '${CBDI0022_006}', function () {
						EVF.C('APP_END_DATE').setFocus();
	                });
					return;
				}
			
				if(!checkTimeToServer(EVF.C("BID_BEGIN_DATE").getValue(), EVF.C("BID_BEGIN_TIME").getValue(), EVF.C("BID_BEGIN_MIN").getValue())) {
					EVF.alert("${form_BID_BEGIN_DATE_N}" + '의 ' + '${CBDI0022_004}', function () {
						EVF.C('BID_BEGIN_DATE').setFocus();
	                });
					return;
				}
			}
			
			
			if(!checkTimeToServer(EVF.C("BID_END_DATE").getValue(), EVF.C("BID_END_TIME").getValue(), EVF.C("BID_END_MIN").getValue())) {
				EVF.alert("${form_BID_END_DATE_N}" + '의 ' + '${CBDI0022_005}', function () {
					EVF.C('BID_END_DATE').setFocus();
                });
				return;
			}
			
			if(!checkTimeToValue(EVF.C("BID_BEGIN_DATE").getValue(), EVF.C("BID_BEGIN_TIME").getValue(), EVF.C("BID_BEGIN_MIN").getValue(), EVF.C("BID_END_DATE").getValue(), EVF.C("BID_END_TIME").getValue(), EVF.C("BID_END_MIN").getValue())) {
				EVF.alert("${form_BID_END_DATE_N}" + '의 ' + '${CBDI0022_006}', function () {
					EVF.C('BID_END_DATE').setFocus();
                });
				return;
			}

			if(!checkTimeToServer(EVF.C("OPEN_DATE").getValue(), EVF.C("OPEN_TIME").getValue(), EVF.C("OPEN_MIN").getValue())) {
				EVF.alert("${form_OPEN_DATE_N}" + '의 ' + '${CBDI0022_004}', function () {
					EVF.C('OPEN_DATE').setFocus();
                });
				return;
			}
			
			if(screenId == 'CBDI0020'){
				if(contType2 == "LP" || contType2 == "TS" || contType2 == "QE" || contType2 == "NE") {
					if(!checkTimeToValue(EVF.C("APP_END_DATE").getValue(), EVF.C("APP_END_TIME").getValue(), EVF.C("APP_END_MIN").getValue(), EVF.C("BID_BEGIN_DATE").getValue(), EVF.C("BID_BEGIN_TIME").getValue(), EVF.C("BID_BEGIN_MIN").getValue())) {
						EVF.alert("${CBDI0022_007}", function () {
							EVF.C('BID_BEGIN_DATE').setFocus();
		                });
						return;
					}
					
					if(!checkTimeToValue(EVF.C("BID_END_DATE").getValue(), EVF.C("BID_END_TIME").getValue(), EVF.C("BID_END_MIN").getValue(), EVF.C("OPEN_DATE").getValue(), EVF.C("OPEN_TIME").getValue(), EVF.C("OPEN_MIN").getValue())) {
						EVF.alert("${CBDI0022_008}", function () {
							EVF.C('OPEN_DATE').setFocus();
		                });
						return;
					}
				}
			} else {
				if(!checkTimeToValue(EVF.C("APP_END_DATE").getValue(), EVF.C("APP_END_TIME").getValue(), EVF.C("APP_END_MIN").getValue(), EVF.C("BID_BEGIN_DATE").getValue(), EVF.C("BID_BEGIN_TIME").getValue(), EVF.C("BID_BEGIN_MIN").getValue())) {
					EVF.alert("${CBDI0022_007}", function () {
						EVF.C('BID_BEGIN_DATE').setFocus();
	                });
					return;
				}
				
				if(!checkTimeToValue(EVF.C("BID_END_DATE").getValue(), EVF.C("BID_END_TIME").getValue(), EVF.C("BID_END_MIN").getValue(), EVF.C("OPEN_DATE").getValue(), EVF.C("OPEN_TIME").getValue(), EVF.C("OPEN_MIN").getValue())) {
					EVF.alert("${CBDI0022_008}", function () {
						EVF.C('OPEN_DATE').setFocus();
	                });
					return;
				}
			}
			
			var store = new EVF.Store();
			
			store.setParameter("screenId", screenId);
			
			if(!store.validate()) return;
			EVF.confirm('${CBDI0022_001}', function () {
				store.doFileUpload(function() {
					store.load(baseUrl + 'cbdi0022_doSave.so', function () {
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
			});
		}
		
		function checkTimeToServer(date, time, min) {
			if(!EVF.isEmpty(date) && !EVF.isEmpty(time) && !EVF.isEmpty(min)) {
				var validStartDate = Number(date) + time + min;
				if ("${today}" + "${todayTime}" > validStartDate) {
					return false
				}
			}
			return true;
		}
		
		function checkTimeToValue(fromDate, fromTime, fromMin, toDate, toTime, toMin) {
			if(!EVF.isEmpty(fromDate) && !EVF.isEmpty(fromTime) && !EVF.isEmpty(fromMin)
					&& !EVF.isEmpty(toDate) && !EVF.isEmpty(toTime) && !EVF.isEmpty(toMin)) {
				var validStartDate = Number(fromDate) + fromTime + fromMin;
				var validCloseDate = Number(toDate) + toTime + toMin;
				if (validCloseDate < validStartDate) {
					return false;
				}
			}
			return true;
		}

		function doClose() {
			window.close();
		}
		
    </script>
	<e:window id="CBDI0022" initData="${initData}" onReady="init" title="${fullScreenName }" breadCrumbs="${breadCrumb }">
		<e:buttonBar id="buttonBar" title="입찰기간 변경은 1회에 한하여 가능합니다" align="right" width="100%">
			<e:button id="doSave" name="doSave" label="${doSave_N}" onClick="doSave" disabled="${doSave_D}" visible="${doSave_V}"/>
			<e:button id="doClose" name="doClose" label="${doClose_N}" onClick="doClose" disabled="${doClose_D}" visible="${doClose_V}"/>
		</e:buttonBar>
		
		<e:searchPanel id="form" title="${form_CAPTION_N }" labelWidth="${labelWidth}" width="100%" columnCount="2" useTitleBar="false" onEnter="doSearch">
	   		<e:inputHidden id='BUYER_CD' name="BUYER_CD" value="${formData.BUYER_CD}" />
	    	<e:inputHidden id='BID_NUM'  name="BID_NUM"  value="${formData.BID_NUM}" />
	    	<e:inputHidden id='BID_CNT'  name="BID_CNT"  value="${formData.BID_CNT}" />
	    	<e:inputHidden id="VOTE_CNT" name="VOTE_CNT" value="${formData.VOTE_CNT}" />
	    	<e:inputHidden id="CONT_TYPE2" name="CONT_TYPE2" value="${formData.CONT_TYPE2}" />
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
				<e:label for="APP_BEGIN_DATE" title="${form_APP_BEGIN_DATE_N}" />
				<e:field colSpan="3">
					<e:inputDate id="APP_BEGIN_DATE" name="APP_BEGIN_DATE" value="${formData.APP_BEGIN_DATE }" width="${inputDateWidth }" required="${form_APP_BEGIN_DATE_R}" disabled="${form_APP_BEGIN_DATE_D}" readOnly="${form_APP_BEGIN_DATE_RO}" datePicker="true" /><e:text>&nbsp;일&nbsp;</e:text>
					<e:select id="APP_BEGIN_TIME" name="APP_BEGIN_TIME" value="${formData.APP_BEGIN_TIME }" options="${appBeginTimeOptions }" width="${form_APP_BEGIN_TIME_W }" disabled="${form_APP_BEGIN_TIME_D}" readOnly="${form_APP_BEGIN_TIME_RO}" required="${form_APP_BEGIN_TIME_R}" placeHolder="" usePlaceHolder="false" /><e:text>&nbsp;시&nbsp;</e:text>
					<e:select id="APP_BEGIN_MIN" name="APP_BEGIN_MIN" value="${formData.APP_BEGIN_MIN }" options="${appBeginMinOptions }" width="${form_APP_BEGIN_MIN_W }" disabled="${form_APP_BEGIN_MIN_D}" readOnly="${form_APP_BEGIN_MIN_RO}" required="${form_APP_BEGIN_MIN_R}" placeHolder="" usePlaceHolder="false" /><e:text>&nbsp;분 ~ </e:text>
					<e:inputDate id="APP_END_DATE" name="APP_END_DATE" value="${formData.APP_END_DATE }" width="${inputDateWidth }" required="${form_APP_END_DATE_R}" disabled="${form_APP_END_DATE_D}" readOnly="${form_APP_END_DATE_RO}" datePicker="true" /><e:text>&nbsp;일&nbsp;</e:text>
					<e:select id="APP_END_TIME" name="APP_END_TIME" value="${formData.APP_END_TIME }" options="${appEndTimeOptions }" width="${form_APP_END_TIME_W }" disabled="${form_APP_END_TIME_D}" readOnly="${form_APP_END_TIME_RO}" required="${form_APP_END_TIME_R}" placeHolder="" usePlaceHolder="false" /><e:text>&nbsp;시&nbsp;</e:text>
					<e:select id="APP_END_MIN" name="APP_END_MIN" value="${formData.APP_END_MIN }" options="${appEndMinOptions }" width="${form_APP_END_MIN_W }" disabled="${form_APP_END_MIN_D}" readOnly="${form_APP_END_MIN_RO}" required="${form_APP_END_MIN_R}" placeHolder="" usePlaceHolder="false" /><e:text>&nbsp;분</e:text>
				</e:field>
			</e:row>
			<e:row>
				<e:label for="BID_BEGIN_DATE" title="${form_BID_BEGIN_DATE_N}" />
				<e:field colSpan="3">
					<e:inputDate id="BID_BEGIN_DATE" name="BID_BEGIN_DATE" value="${formData.BID_BEGIN_DATE }" width="${inputDateWidth }" required="${form_BID_BEGIN_DATE_R}" disabled="${form_BID_BEGIN_DATE_D}" readOnly="${form_BID_BEGIN_DATE_RO}" datePicker="true" /><e:text>&nbsp;일&nbsp;</e:text>
					<e:select id="BID_BEGIN_TIME" name="BID_BEGIN_TIME" value="${formData.BID_BEGIN_TIME }" options="${bidBeginTimeOptions }" width="${form_BID_BEGIN_TIME_W }" disabled="${form_BID_BEGIN_TIME_D}" readOnly="${form_BID_BEGIN_TIME_RO}" required="${form_BID_BEGIN_TIME_R}" placeHolder="" usePlaceHolder="false" /><e:text>&nbsp;시&nbsp;</e:text>
					<e:select id="BID_BEGIN_MIN" name="BID_BEGIN_MIN" value="${formData.BID_BEGIN_MIN }" options="${bidBeginMinOptions }" width="${form_BID_BEGIN_MIN_W }" disabled="${form_BID_BEGIN_MIN_D}" readOnly="${form_BID_BEGIN_MIN_RO}" required="${form_BID_BEGIN_MIN_R}" placeHolder="" usePlaceHolder="false" /><e:text>&nbsp;분 ~ </e:text>
					<e:inputDate id="BID_END_DATE" name="BID_END_DATE" value="${formData.BID_END_DATE }" width="${inputDateWidth }" required="${form_BID_END_DATE_R}" disabled="${form_BID_END_DATE_D}" readOnly="${form_BID_END_DATE_RO}" datePicker="true" /><e:text>&nbsp;일&nbsp;</e:text>
					<e:select id="BID_END_TIME" name="BID_END_TIME" value="${formData.BID_END_TIME }" options="${bidEndTimeOptions }" width="${form_BID_END_TIME_W }" disabled="${form_BID_END_TIME_D}" readOnly="${form_BID_END_TIME_RO}" required="${form_BID_END_TIME_R}" placeHolder="" usePlaceHolder="false" /><e:text>&nbsp;시&nbsp;</e:text>
					<e:select id="BID_END_MIN" name="BID_END_MIN" value="${formData.BID_END_MIN }" options="${bidEndMinOptions }" width="${form_BID_END_MIN_W }" disabled="${form_BID_END_MIN_D}" readOnly="${form_BID_END_MIN_RO}" required="${form_BID_END_MIN_R}" placeHolder="" usePlaceHolder="false" /><e:text>&nbsp;분</e:text>
				</e:field>
			</e:row>
			<e:row>
				<e:label for="OPEN_DATE" title="${form_OPEN_DATE_N}" />
				<e:field colSpan="3">
					<e:inputDate id="OPEN_DATE" name="OPEN_DATE" value="${formData.OPEN_DATE }" width="${inputDateWidth }" required="${form_OPEN_DATE_R}" disabled="${form_OPEN_DATE_D}" readOnly="${form_OPEN_DATE_RO}" datePicker="true" /><e:text>&nbsp;일&nbsp;</e:text>
					<e:select id="OPEN_TIME" name="OPEN_TIME" value="${formData.OPEN_TIME }" options="${openTimeOptions }" width="${form_OPEN_TIME_W }" disabled="${form_OPEN_TIME_D}" readOnly="${form_OPEN_TIME_RO}" required="${form_OPEN_TIME_R}" placeHolder="" usePlaceHolder="false" /><e:text>&nbsp;시&nbsp;</e:text>
					<e:select id="OPEN_MIN" name="OPEN_MIN" value="${formData.OPEN_MIN }" options="${openMinOptions }" width="${form_OPEN_MIN_W }" disabled="${form_OPEN_MIN_D}" readOnly="${form_OPEN_MIN_RO}" required="${form_OPEN_MIN_R}" placeHolder="" usePlaceHolder="false" /><e:text>&nbsp;분</e:text>
				</e:field>
			</e:row>
			<e:row>
				<e:label for="ATT_FILE_NUM" title="${form_ATT_FILE_NUM_N}"/>
				<e:field colSpan="3">
					<e:fileManager id="ATT_FILE_NUM" height="100" width="100%" fileId="${formData.ATT_FILE_NUM}" readOnly="${form_ATT_FILE_NUM_RO}" bizType="BID" required="${form_ATT_FILE_NUM_R}"/>
				</e:field>
			</e:row>
			<e:row>
				<e:label for="PERIOD_MOD_RSN" title="${form_PERIOD_MOD_RSN_N}"/>
				<e:field colSpan="3">
					<e:textArea id="PERIOD_MOD_RSN" name="PERIOD_MOD_RSN" value="${formData.PERIOD_MOD_RSN}" height="200px" width="${form_PERIOD_MOD_RSN_W}" maxLength="${form_PERIOD_MOD_RSN_M}" disabled="${form_PERIOD_MOD_RSN_D}" readOnly="${form_PERIOD_MOD_RSN_RO}" required="${form_PERIOD_MOD_RSN_R}" />
				</e:field>
			</e:row>
		</e:searchPanel>

	</e:window>
</e:ui>