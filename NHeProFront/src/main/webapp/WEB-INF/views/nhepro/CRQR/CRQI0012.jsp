<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
    <script type="text/javascript">
        var baseUrl = "/nhepro/CRQR/";
        
        function init() {
        	
        	var RfxStartDate = EVF.C("RFX_START_DATE").getValue();
	    	var RfxCloseDate = EVF.C("RFX_CLOSE_DATE").getValue();
	    	
        	EVF.C("PERIOD_MOD_RSN").setValue(" * 변경 전 기간\n - 일시  : "+RfxStartDate.substring(0,4)+"년 "+RfxStartDate.substring(4,6)+"월 "+RfxStartDate.substring(6,8)+"일 "+EVF.C("RFX_START_HOUR").getValue()+"시 "+EVF.C("RFX_START_MIN").getValue()+"분  ~"
	    			+RfxCloseDate.substring(0,4)+"년 "+RfxCloseDate.substring(4,6)+"월 "+RfxCloseDate.substring(6,8)+"일 "+EVF.C("RFX_CLOSE_HOUR").getValue()+"시 "+EVF.C("RFX_CLOSE_MIN").getValue()+"분\n\n * 변경 사유\n"
	    			);
        }

        function doSave() {
            
            var store = new EVF.Store();
            if(!store.validate()) { return; }

			if(!checkTimeToServer(EVF.C("RFX_CLOSE_DATE").getValue(), EVF.C("RFX_CLOSE_HOUR").getValue(), EVF.C("RFX_CLOSE_MIN").getValue())) {
				EVF.C('RFX_CLOSE_DATE').setFocus();
				return EVF.alert("${form_RFX_CLOSE_DATE_N}" + '의 ' + '${CRQI0012_004}');
			}

			if(!checkTimeToValue(EVF.C("RFX_START_DATE").getValue(), EVF.C("RFX_START_HOUR").getValue(), EVF.C("RFX_START_MIN").getValue(), EVF.C("RFX_CLOSE_DATE").getValue(), EVF.C("RFX_CLOSE_HOUR").getValue(), EVF.C("RFX_CLOSE_MIN").getValue())) {
				EVF.C('RFX_CLOSE_DATE').setFocus();
				return EVF.alert("${form_RFX_CLOSE_DATE_N}" + '의 ' + '${CRQI0012_005}');
			}
			
			if(!checkTimeToValue(EVF.C("BEFORE_RFX_CLOSE_DATE").getValue(), EVF.C("BEFORE_RFX_CLOSE_HOUR").getValue(), EVF.C("BEFORE_RFX_CLOSE_MIN").getValue(), EVF.C("RFX_CLOSE_DATE").getValue(), EVF.C("RFX_CLOSE_HOUR").getValue(), EVF.C("RFX_CLOSE_MIN").getValue())) {
				EVF.C('RFX_CLOSE_DATE').setFocus();
				return EVF.alert("${form_RFX_CLOSE_DATE_N}" + '의 ' + '${CRQI0012_006}');
			}
			
			var store = new EVF.Store();
			
			if(!store.validate()) return;
			EVF.confirm('${CRQI0012_001}', function () {
				store.doFileUpload(function() {
					store.load(baseUrl + 'crqi0012_doSave.so', function () {
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
				
				if (validCloseDate <= validStartDate) {
					return false;
				}
			}
			return true;
		}

		function doClose() {
			window.close();
		}
		
    </script>

    <e:window id="CRQI0012" onReady="init" initData="${initData}" title="${screenName}" breadCrumbs="${breadCrumb }">
		
        <e:inputHidden id="BUYER_CD" name="BUYER_CD" value="${formData.BUYER_CD}" />

		<e:inputHidden id="BEFORE_RFX_CLOSE_DATE" name="BEFORE_RFX_CLOSE_DATE" value="${formData.BEFORE_RFX_CLOSE_DATE}" />
		<e:inputHidden id="BEFORE_RFX_CLOSE_HOUR" name="BEFORE_RFX_CLOSE_HOUR" value="${formData.BEFORE_RFX_CLOSE_HOUR}" />
		<e:inputHidden id="BEFORE_RFX_CLOSE_MIN" name="BEFORE_RFX_CLOSE_MIN" value="${formData.BEFORE_RFX_CLOSE_MIN}" />
		
		<!-- 버튼 영역 -->
        <e:buttonBar title="견적기간 변경은 1회에 한하여 가능합니다" width="100%" align="right">
            <e:button id="doSave" name="doSave" label="${doSave_N}" onClick="doSave" disabled="${doSave_D}" visible="${doSave_V}"/>
            <e:button id="doClose" name="doClose" label="${doClose_N}" onClick="doClose" disabled="${doClose_D}" visible="${doClose_V}"/>
        </e:buttonBar>

        <e:searchPanel id="sp" title="${form_CAPTION_N}" labelWidth="${labelWidth}" useTitleBar="false" width="100%" columnCount="2" onEnter="doSearch">
            <e:row>
                <e:label for="RFX_NUM" title="${form_RFX_NUM_N}" />
                <e:field>
                    <e:inputText id="RFX_NUM" name="RFX_NUM" value="${formData.RFX_NUM}" width="${form_RFX_NUM_W}" maxLength="${form_RFX_NUM_M}" disabled="${form_RFX_NUM_D}" readOnly="${form_RFX_NUM_RO}" required="${form_RFX_NUM_R}" style="${imeMode}" maskType="${form_RFX_NUM_MT}"/>
                    <e:text>${formData.RFX_NUM} / ${formData.RFX_CNT}</e:text>
                    <e:inputNumber id="RFX_CNT" name="RFX_CNT" value="${formData.RFX_CNT}" width="${form_RFX_CNT_W}" maxValue="${form_RFX_CNT_M}" decimalPlace="${form_RFX_CNT_NF}" disabled="${form_RFX_CNT_D}" readOnly="${form_RFX_CNT_RO}" required="${form_RFX_CNT_R}" onNumberKr="${form_RFX_CNT_KR}" currencyText="${form_RFX_CNT_CT}"/>
                </e:field>
                <e:label for="RFX_TYPE" title="${form_RFX_TYPE_N}"/>
                <e:field>
                    <e:select id="RFX_TYPE" name="RFX_TYPE" value="${formData.RFX_TYPE}" options="${rfxTypeOptions}" width="${form_RFX_TYPE_W}" disabled="${form_RFX_TYPE_D}" readOnly="${form_RFX_TYPE_RO}" required="${form_RFX_TYPE_R}" placeHolder="" maskType="${form_RFX_TYPE_MT}" />
                    <e:text>[${form_RFX_LIMIT_CNT_N}]</e:text>
                    <e:inputText id="RFX_LIMIT_CNT" name="RFX_LIMIT_CNT" value="${formData.RFX_LIMIT_CNT}" width="${form_RFX_LIMIT_CNT_W}" maxLength="${form_RFX_LIMIT_CNT_M}" disabled="${form_RFX_LIMIT_CNT_D}" readOnly="${form_RFX_LIMIT_CNT_RO}" required="${form_RFX_LIMIT_CNT_R}" style="${imeMode}" maskType="${form_RFX_LIMIT_CNT_MT}"/>
                </e:field>
            </e:row>    
            <e:row>
                <e:label for="RFX_SUBJECT" title="${form_RFX_SUBJECT_N}" />
                <e:field colSpan="3">
                    <e:inputText id="RFX_SUBJECT" name="RFX_SUBJECT" value="${formData.RFX_SUBJECT}" width="${form_RFX_SUBJECT_W}" maxLength="${form_RFX_SUBJECT_M}" disabled="${form_RFX_SUBJECT_D}" readOnly="${form_RFX_SUBJECT_RO}" required="${form_RFX_SUBJECT_R}" style="${imeMode}" maskType="${form_RFX_SUBJECT_MT}"/>
                </e:field>
            </e:row>
            <e:row>
                <e:label for="RFX_START_DATE" title="${form_RFX_START_DATE_N}"/>
                <e:field>
                    <e:inputDate id="RFX_START_DATE" name="RFX_START_DATE" toDate="RFX_CLOSE_DATE" value="${formData.RFX_START_DATE}" width="${inputDateWidth}" datePicker="true" required="${form_RFX_START_DATE_R}" disabled="${form_RFX_START_DATE_D}" readOnly="${form_RFX_START_DATE_RO}" />
                    <e:text> </e:text>
                    <e:select id="RFX_START_HOUR" name="RFX_START_HOUR" value="${formData.RFX_START_HOUR}" options="${rfxStartHourOptions}" width="${form_RFX_START_HOUR_W}" disabled="${form_RFX_START_HOUR_D}" readOnly="${form_RFX_START_HOUR_RO}" required="${form_RFX_START_HOUR_R}" placeHolder="시" maskType="${form_RFX_START_HOUR_MT}" />
                    <e:text>시</e:text>
                    <e:select id="RFX_START_MIN" name="RFX_START_MIN" value="${formData.RFX_START_MIN}" options="${rfxStartMinOptions}" width="${form_RFX_START_MIN_W}" disabled="${form_RFX_START_MIN_D}" readOnly="${form_RFX_START_MIN_RO}" required="${form_RFX_START_MIN_R}" placeHolder="분" maskType="${form_RFX_START_MIN_MT}" />
                    <e:text>분</e:text>
                </e:field>
                <e:label for="RFX_CLOSE_DATE" title="${form_RFX_CLOSE_DATE_N}"/>
                <e:field>
                    <e:inputDate id="RFX_CLOSE_DATE" name="RFX_CLOSE_DATE" fromDate="RFX_START_DATE" value="${formData.RFX_CLOSE_DATE}" width="${inputDateWidth}" datePicker="true" required="${form_RFX_CLOSE_DATE_R}" disabled="${form_RFX_CLOSE_DATE_D}" readOnly="${form_RFX_CLOSE_DATE_RO}" />
                    <e:text> </e:text>
                    <e:select id="RFX_CLOSE_HOUR" name="RFX_CLOSE_HOUR" value="${formData.RFX_CLOSE_HOUR}" options="${rfxCloseHourOptions}" width="${form_RFX_CLOSE_HOUR_W}" disabled="${form_RFX_CLOSE_HOUR_D}" readOnly="${form_RFX_CLOSE_HOUR_RO}" required="${form_RFX_CLOSE_HOUR_R}" placeHolder="시" maskType="${form_RFX_CLOSE_HOUR_MT}" />
                    <e:text>시</e:text>
                    <e:select id="RFX_CLOSE_MIN" name="RFX_CLOSE_MIN" value="${formData.RFX_CLOSE_MIN}" options="${rfxCloseMinOptions}" width="${form_RFX_CLOSE_MIN_W}" disabled="${form_RFX_CLOSE_MIN_D}" readOnly="${form_RFX_CLOSE_MIN_RO}" required="${form_RFX_CLOSE_MIN_R}" placeHolder="분" maskType="${form_RFX_CLOSE_MIN_MT}" />
                    <e:text>분</e:text>
                </e:field>
            </e:row>
            <e:row>
                <e:label for="ATT_FILE_NUM" title="${form_ATT_FILE_NUM_N}" />
                <e:field colSpan="3">
                    <e:fileManager id="ATT_FILE_NUM" width="${form_ATT_FILE_NUM_W}" height="100px" fileId="${formData.ATT_FILE_NUM}" bizType="RFQ" readOnly="${form_ATT_FILE_NUM_RO}" required="${form_ATT_FILE_NUM_R}"/>
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
