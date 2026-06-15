<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">

	<script type="text/javascript">

	    var isDetailView = ('${param.detailView}' === 'true' ? true : false);
	    var individualFlag = ('${param.individualFlag}' === 'true' ? true : false);
		var baseUrl = "/nhepro/CBDR/";
		var maxProgressCd;

	    function init() {

	        if(${!havePermission}) {
	        	EVF.C('Confirm').setDisabled(true);
	    	} else {
				EVF.C('Confirm').setDisabled(false);
	    	}
			displayClock();
	        setInterval(displayClock, 1000);
	    }

	    function displayClock() {

			var date = new Date();
			var years = date.getFullYear();
			var months = date.getMonth() + 1;
			var days = date.getDate();
			var hours = date.getHours();
			var mins = date.getMinutes();
			var seconds = date.getSeconds();
			EVF.C('clock').setText(years + '년 ' + months + '월 ' + days + '일 ' + (hours < 10 ? '0' + hours : hours) + '시 ' + (mins < 10 ? '0' + mins : mins) + '분 ' + (seconds < 10 ? '0' + seconds : seconds) + '초');
		}

	    function doConfirm() {

	    	var popupFlag = ${(param.popupFlag == null || !param.popupFlag) ? false : true};
	    	var reBid = ${(param.REBID == null || !param.REBID) ? false : true};

			if(!checkTimeToServer(EVF.C("BID_BEGIN_DATE").getValue(), EVF.C("BID_BEGIN_HOUR").getValue(), EVF.C("BID_BEGIN_MIN").getValue())) {
				EVF.C('BID_BEGIN_DATE').setFocus();
				return EVF.alert("${form_BID_BEGIN_DATE_N}" + '의 ' + '${CBDI0032_T008}');
			}
			if(!checkTimeToServer(EVF.C("BID_END_DATE").getValue(), EVF.C("BID_END_HOUR").getValue(), EVF.C("BID_END_MIN").getValue())) {
				EVF.C('BID_END_DATE').setFocus();
				return EVF.alert("${form_BID_END_DATE_N}" + '의 ' + '${CBDI0032_T009}');
			}
			if(!checkTimeToValue(EVF.C("BID_BEGIN_DATE").getValue(), EVF.C("BID_BEGIN_HOUR").getValue(), EVF.C("BID_BEGIN_MIN").getValue(), EVF.C("BID_END_DATE").getValue(), EVF.C("BID_END_HOUR").getValue(), EVF.C("BID_END_MIN").getValue())) {
				EVF.C('BID_END_DATE').setFocus();
				return EVF.alert("${form_BID_END_DATE_N}" + '의 ' + '${CBDI0032_T010}');
			}

			if(!checkTimeToServer(EVF.C("OPEN_DATE").getValue(), EVF.C("OPEN_TIME_HOUR").getValue(), EVF.C("OPEN_TIME_MIN").getValue())) {
				EVF.C('OPEN_DATE').setFocus();
				return EVF.alert("${form_OPEN_DATE_N}" + '의 ' + '${CBDI0032_T008}');
			}
			if(!checkTimeToValue(EVF.C("BID_END_DATE").getValue(), EVF.C("BID_END_HOUR").getValue(), EVF.C("BID_END_MIN").getValue(), EVF.C("OPEN_DATE").getValue(), EVF.C("OPEN_TIME_HOUR").getValue(), EVF.C("OPEN_TIME_MIN").getValue())) {
				EVF.C('OPEN_DATE').setFocus();
				return EVF.alert("${form_OPEN_DATE_N}" + '${CBDI0032_T011}');
			}

            EVF.confirm("${CBDI0032_T004 }", function () {

            	var store = new EVF.Store();

            	<%-- 젹격심사, 종합낙찰제결과 등록에서 협력업체 개별적으로 재입찰 --%>
				if(individualFlag) {
					store.load(baseUrl + 'cbdi0032_doConfirmIndividual.so', function(){
						EVF.alert(this.getResponseMessage(), function() {
							opener['${param.callbackFunction}']();
							doClose();
						});
					});
				}
				<%-- 일반적인 재입찰 --%>
				else {
					store.load(baseUrl + 'cbdi0032_doConfirm.so', function(){
						EVF.alert(this.getResponseMessage(), function() {
							if(popupFlag) {
								if(reBid) {
									opener['${param.callbackFunction}']();
									doClose();
								}
								else {
									opener.doSearch();
									doClose();
								}
							}
						});
					});
				}
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
			EVF.closeWindow();
        }

    </script>
	<e:window id="CBDI0032" initData="${initData}" onReady="init" title="${fullScreenName }" breadCrumbs="${breadCrumb }">

		<e:inputHidden id="BUYER_CD" name="BUYER_CD" value="${formData.BUYER_CD}" />
		<e:inputHidden id="BID_NUM" name="BID_NUM" value="${formData.BID_NUM}" />
		<e:inputHidden id="BID_CNT" name="BID_CNT" value="${formData.BID_CNT}" />
    	<e:inputHidden id="BID_STATUS" name="BID_STATUS" value="${formData.BID_STATUS}" />
    	<e:inputHidden id="BID_USER_ID" name="BID_USER_ID" value="${formData.BID_USER_ID}" />
    	<e:inputHidden id="VOTE_CNT" name="VOTE_CNT" value="${formData.VOTE_CNT}" />
    	<e:inputHidden id="NEW_VOTE_CNT" name="NEW_VOTE_CNT" value="${formData.NEW_VOTE_CNT}" />
    	<e:inputHidden id="REBID" name="REBID" value="${param.REBID}" />
    	<e:inputHidden id="VENDOR_CD" name="VENDOR_CD" value="${param.VENDOR_CD}" />
    	<e:inputHidden id="VENDOR_MAX_VOTE_CNT" name="VENDOR_MAX_VOTE_CNT" value="${param.VENDOR_MAX_VOTE_CNT}" />

		<%-- 입찰공고 정보 --%>
		<div class="e-component e-title-container" data-uuid="Title-541-391-560">
			<div class="e-title-bullet-h1"></div>
			<div class="e-title-text">${CBDI0032_T001 }</div>
		</div>
		<e:searchPanel id="form1" labelWidth="${labelWidth}" width="100%" columnCount="2" useTitleBar="false">
			<e:row>
				<e:label for="ANN_NO" title="${form_ANN_NO_N}"/>
				<e:field>
					<e:text> ${formData.ANN_NO } </e:text>
				</e:field>
				<e:label for="ANN_DATE" title="${form_ANN_DATE_N}"/>
				<e:field>
					<e:text> ${formData.ANN_DATE } </e:text>
				</e:field>
			</e:row>
			<e:row>
				<e:label for="ANN_ITEM" title="${form_ANN_ITEM_N}"/>
				<e:field colSpan="3">
					<e:text> ${formData.ANN_ITEM } </e:text>
				</e:field>
			</e:row>
			<e:row>
				<e:label for="CONT_TYPE_TXT" title="${form_CONT_TYPE_TXT_N}"/>
				<e:field colSpan="3">
					<e:text> ${formData.CONT_TYPE_TXT } </e:text>
				</e:field>
			</e:row>
			<e:row>
				<e:label for="APP_DATE" title="${form_APP_DATE_N}"/>
				<e:field colSpan="3">
					<e:text> ${formData.APP_DATE } </e:text>
				</e:field>
			</e:row>
			<e:row>
				<e:label for="NOW_TIME" title="${form_NOW_TIME_N}"/>
				<e:field colSpan="3">
					<e:text id="clock" />
				</e:field>
			</e:row>
			<e:row>
				<e:label for="BID_BEGIN_DATE" title="${form_BID_BEGIN_DATE_N}" />
				<e:field colSpan="3">
					<e:inputDate id="BID_BEGIN_DATE" name="BID_BEGIN_DATE" value="${formData.BID_BEGIN_DATE }" width="${inputDateWidth }" required="${form_BID_BEGIN_DATE_R}" disabled="${form_BID_BEGIN_DATE_D}" readOnly="${form_BID_BEGIN_DATE_RO}" datePicker="true" /><e:text>&nbsp;일&nbsp;</e:text>
					<e:select id="BID_BEGIN_HOUR" name="BID_BEGIN_HOUR" value="${formData.BID_BEGIN_HOUR }" options="${bidBeginHourOptions }" width="${form_BID_BEGIN_HOUR_W }" disabled="${form_BID_BEGIN_HOUR_D}" readOnly="${form_BID_BEGIN_HOUR_RO}" required="${form_BID_BEGIN_HOUR_R}" placeHolder="" usePlaceHolder="false" /><e:text>&nbsp;시&nbsp;</e:text>
					<e:select id="BID_BEGIN_MIN" name="BID_BEGIN_MIN" value="${formData.BID_BEGIN_MIN }" options="${bidBeginMinOptions }" width="${form_BID_BEGIN_MIN_W }" disabled="${form_BID_BEGIN_MIN_D}" readOnly="${form_BID_BEGIN_MIN_RO}" required="${form_BID_BEGIN_MIN_R}" placeHolder="" usePlaceHolder="false" /><e:text>&nbsp;분 ~ </e:text>
					<e:inputDate id="BID_END_DATE" name="BID_END_DATE" value="${formData.BID_END_DATE }" width="${inputDateWidth }" required="${form_BID_END_DATE_R}" disabled="${form_BID_END_DATE_D}" readOnly="${form_BID_END_DATE_RO}" datePicker="true" /><e:text>&nbsp;일&nbsp;</e:text>
					<e:select id="BID_END_HOUR" name="BID_END_HOUR" value="${formData.BID_END_HOUR }" options="${bidEndHourOptions }" width="${form_BID_END_HOUR_W }" disabled="${form_BID_END_HOUR_D}" readOnly="${form_BID_END_HOUR_RO}" required="${form_BID_END_HOUR_R}" placeHolder="" usePlaceHolder="false" /><e:text>&nbsp;시&nbsp;</e:text>
					<e:select id="BID_END_MIN" name="BID_END_MIN" value="${formData.BID_END_MIN }" options="${bidEndMinOptions }" width="${form_BID_END_MIN_W }" disabled="${form_BID_END_MIN_D}" readOnly="${form_BID_END_MIN_RO}" required="${form_BID_END_MIN_R}" placeHolder="" usePlaceHolder="false" /><e:text>&nbsp;분</e:text>
				</e:field>
			</e:row>
			<e:row>
				<e:label for="OPEN_DATE" title="${form_OPEN_DATE_N}" />
				<e:field colSpan="3">
					<e:inputDate id="OPEN_DATE" name="OPEN_DATE" value="${formData.OPEN_DATE }" width="${inputDateWidth }" required="${form_OPEN_DATE_R}" disabled="${form_OPEN_DATE_D}" readOnly="${form_OPEN_DATE_RO}" datePicker="true" /><e:text>&nbsp;일&nbsp;</e:text>
					<e:select id="OPEN_TIME_HOUR" name="OPEN_TIME_HOUR" value="${formData.OPEN_TIME_HOUR }" options="${openTimeHourOptions }" width="${form_OPEN_TIME_HOUR_W }" disabled="${form_OPEN_TIME_HOUR_D}" readOnly="${form_OPEN_TIME_HOUR_RO}" required="${form_OPEN_TIME_HOUR_R}" placeHolder="" usePlaceHolder="false" /><e:text>&nbsp;시&nbsp;</e:text>
					<e:select id="OPEN_TIME_MIN" name="OPEN_TIME_MIN" value="${formData.OPEN_TIME_MIN }" options="${openTimeMinOptions }" width="${form_OPEN_TIME_MIN_W }" disabled="${form_OPEN_TIME_MIN_D}" readOnly="${form_OPEN_TIME_MIN_RO}" required="${form_OPEN_TIME_MIN_R}" placeHolder="" usePlaceHolder="false" /><e:text>&nbsp;분</e:text>
				</e:field>
			</e:row>
		</e:searchPanel>

		<e:buttonBar id="buttonBar" align="right" width="100%" title="${form_CAPTION3_N }">
			<e:button id="Confirm" name="Confirm" label="${Confirm_N }" disabled="${Confirm_D }" visible="${Confirm_V}" onClick="doConfirm" />
			<e:button id="Close" name="Close" label="${Close_N }" disabled="${Close_D }" visible="${Close_V}" onClick="doClose" />
		</e:buttonBar>

	</e:window>
</e:ui>