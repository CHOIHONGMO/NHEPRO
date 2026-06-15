<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">

    <script>

        var param = {};

	    function init() {

		    window.focus();
	    }

	    function doConfirm() {

            var store = new EVF.Store();
            if (!store.validate()) return;

            param.cancelRmk = EVF.V("CANCEL_RMK");
            parent.${'doBidGuarCancel'}(param);
            doClose();
        }

	    function doClose() {
		    EVF.closeWindow();
	    }
    
    </script>

    <e:window id="SBDI0014" onReady="init" initData="${initData}" title="${fullScreenName }" breadCrumbs="${breadCrumb }">

    	<e:buttonBar id="buttonBar" align="right" width="100%">
            <e:button id="Confirm" name="Confirm" label="${Confirm_N }" disabled="${Confirm_D }" visible="${Confirm_V}" onClick="doConfirm" />
            <%-- <e:button id="Close" name="Close" label="${Close_N }" disabled="${Close_D }" visible="${Close_V}" onClick="doClose" /> --%>
        </e:buttonBar>

		<e:searchPanel id="form" useTitleBar="false" title="${form_caption_form_N}" labelWidth="${labelWidth}" width="100%" columnCount="2">
            <e:row>
				<e:label for="CANCEL_RMK" title="${form_CANCEL_RMK_N}" />
                <e:field colSpan="3">
                	<e:textArea id="CANCEL_RMK" name="CANCEL_RMK" width="100%" height="230px" value="${param.CANCEL_RMK}" required="${form_CANCEL_RMK_R}" readOnly="${form_CANCEL_RMK_RO}" disabled="${form_CANCEL_RMK_D}" maxLength="${form_CANCEL_RMK_M }"/>
                </e:field>
            </e:row>
        </e:searchPanel>

    </e:window>
</e:ui>
