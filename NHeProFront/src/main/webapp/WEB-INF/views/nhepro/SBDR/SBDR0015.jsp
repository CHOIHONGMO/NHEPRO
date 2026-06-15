<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">

	<script type="text/javascript">
		var baseUrl = "/nhepro/SBDR/";
		function init() {

		}
		function doClose() {
			EVF.closeWindow();
		}
	</script>
	<e:window id="SBDR0015" initData="${initData}" onReady="init" title="${fullScreenName }" breadCrumbs="${breadCrumb }">
		<e:buttonBar id="buttonBar" align="right" width="100%">
			<e:button id="doClose" name="doClose" label="${doClose_N}" onClick="doClose" disabled="${doClose_D}" visible="${doClose_V}"/>
		</e:buttonBar>
		<e:searchPanel id="form" title="${form_CAPTION_N }" labelWidth="${labelWidth}" width="100%" columnCount="1" useTitleBar="false" onEnter="doSearch">
			<e:row>
				<e:label for="PROP_FLAG" title="${form_PROP_FLAG_N}" />
				<e:field>
				<e:inputText id="PROP_FLAG" name="PROP_FLAG" value="${formData.PROP_FLAG}" width="${form_PROP_FLAG_W}" maxLength="${form_PROP_FLAG_M}" disabled="${form_PROP_FLAG_D}" readOnly="${form_PROP_FLAG_RO}" required="${form_PROP_FLAG_R}" style="${imeMode}" maskType="${form_PROP_FLAG_MT}"/>
				</e:field>
            </e:row>
			<e:row>
				<e:label for="PROP_DATE" title="${form_PROP_DATE_N}" />
				<e:field>
				<e:inputText id="PROP_DATE" name="PROP_DATE" value="${formData.PROP_DATE}" width="${form_PROP_DATE_W}" maxLength="${form_PROP_DATE_M}" disabled="${form_PROP_DATE_D}" readOnly="${form_PROP_DATE_RO}" required="${form_PROP_DATE_R}" style="${imeMode}" maskType="${form_PROP_DATE_MT}"/>
				</e:field>
            </e:row>
			<e:row>
				<e:label for="PROP_PLACE" title="${form_PROP_PLACE_N}" />
				<e:field>
				<e:inputText id="PROP_PLACE" name="PROP_PLACE" value="${formData.PROP_PLACE}" width="${form_PROP_PLACE_W}" maxLength="${form_PROP_PLACE_M}" disabled="${form_PROP_PLACE_D}" readOnly="${form_PROP_PLACE_RO}" required="${form_PROP_PLACE_R}" style="${imeMode}" maskType="${form_PROP_PLACE_MT}"/>
				</e:field>
            </e:row>
			<e:row>
				<e:label for="PROP_NOTIFIER" title="${form_PROP_NOTIFIER_N}" />
				<e:field>
				<e:inputText id="PROP_NOTIFIER" name="PROP_NOTIFIER" value="${formData.PROP_NOTIFIER}" width="${form_PROP_NOTIFIER_W}" maxLength="${form_PROP_NOTIFIER_M}" disabled="${form_PROP_NOTIFIER_D}" readOnly="${form_PROP_NOTIFIER_RO}" required="${form_PROP_NOTIFIER_R}" style="${imeMode}" maskType="${form_PROP_NOTIFIER_MT}"/>
				</e:field>
            </e:row>
			<e:row>
				<e:label for="PROP_RMK" title="${form_PROP_RMK_N}"/>
				<e:field>
				<e:textArea id="PROP_RMK" name="PROP_RMK" value="${formData.PROP_RMK}" height="220px" width="100%" maxLength="${form_PROP_RMK_M}" disabled="${form_PROP_RMK_D}" readOnly="${form_PROP_RMK_RO}" required="${form_PROP_RMK_R}" />
				</e:field>
            </e:row>
		</e:searchPanel>



	</e:window>
</e:ui>
