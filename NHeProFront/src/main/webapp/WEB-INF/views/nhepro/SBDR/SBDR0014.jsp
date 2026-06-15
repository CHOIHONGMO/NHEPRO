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
	<e:window id="SBDR0014" initData="${initData}" onReady="init" title="${fullScreenName }" breadCrumbs="${breadCrumb }">
		<e:buttonBar id="buttonBar" align="right" width="100%">
			<e:button id="doClose" name="doClose" label="${doClose_N}" onClick="doClose" disabled="${doClose_D}" visible="${doClose_V}"/>
		</e:buttonBar>
		<e:searchPanel id="form" title="${form_CAPTION_N }" labelWidth="${labelWidth}" width="100%" columnCount="1" useTitleBar="false" onEnter="doSearch">
			<e:row>
				<e:label for="ANNO_FLAG" title="${form_ANNO_FLAG_N}" />
				<e:field>
				<e:inputText id="ANNO_FLAG" name="ANNO_FLAG" value="${formData.ANNO_FLAG}" width="${form_ANNO_FLAG_W}" maxLength="${form_ANNO_FLAG_M}" disabled="${form_ANNO_FLAG_D}" readOnly="${form_ANNO_FLAG_RO}" required="${form_ANNO_FLAG_R}" style="${imeMode}" maskType="${form_ANNO_FLAG_MT}"/>
				</e:field>
            </e:row>
			<e:row>
				<e:label for="ANNO_DATE" title="${form_ANNO_DATE_N}" />
				<e:field>
				<e:inputText id="ANNO_DATE" name="ANNO_DATE" value="${formData.ANNO_DATE}" width="${form_ANNO_DATE_W}" maxLength="${form_ANNO_DATE_M}" disabled="${form_ANNO_DATE_D}" readOnly="${form_ANNO_DATE_RO}" required="${form_ANNO_DATE_R}" style="${imeMode}" maskType="${form_ANNO_DATE_MT}"/>
				</e:field>
            </e:row>
			<e:row>
				<e:label for="ANNO_PLACE" title="${form_ANNO_PLACE_N}" />
				<e:field>
				<e:inputText id="ANNO_PLACE" name="ANNO_PLACE" value="${formData.ANNO_PLACE}" width="${form_ANNO_PLACE_W}" maxLength="${form_ANNO_PLACE_M}" disabled="${form_ANNO_PLACE_D}" readOnly="${form_ANNO_PLACE_RO}" required="${form_ANNO_PLACE_R}" style="${imeMode}" maskType="${form_ANNO_PLACE_MT}"/>
				</e:field>
            </e:row>
			<e:row>
				<e:label for="ANNO_NOTIFIER" title="${form_ANNO_NOTIFIER_N}" />
				<e:field>
				<e:inputText id="ANNO_NOTIFIER" name="ANNO_NOTIFIER" value="${formData.ANNO_NOTIFIER}" width="${form_ANNO_NOTIFIER_W}" maxLength="${form_ANNO_NOTIFIER_M}" disabled="${form_ANNO_NOTIFIER_D}" readOnly="${form_ANNO_NOTIFIER_RO}" required="${form_ANNO_NOTIFIER_R}" style="${imeMode}" maskType="${form_ANNO_NOTIFIER_MT}"/>
				</e:field>
            </e:row>
			<e:row>
				<e:label for="ANNO_RMK" title="${form_ANNO_RMK_N}"/>
				<e:field>
				<e:textArea id="ANNO_RMK" name="ANNO_RMK" value="${formData.ANNO_RMK}" height="220px" width="100%" maxLength="${form_ANNO_RMK_M}" disabled="${form_ANNO_RMK_D}" readOnly="${form_ANNO_RMK_RO}" required="${form_ANNO_RMK_R}" />
				</e:field>
            </e:row>
		</e:searchPanel>


	</e:window>
</e:ui>
