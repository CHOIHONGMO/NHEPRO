<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">

    <%--<script type="text/javascript" src="/MagicLine4Web/ML4Web/js/ext/jquery.blockUI.js"></script>--%>
    <!-- ML4WEB JS -->
    <%--<script type="text/javascript" src="/MagicLine4Web/ML4Web/js/ext/ML_Config.js"></script>--%>

    <script>

        var param = {};

	    function init() {

	        if("${param.signStatus}" == "E") {
                EVF.C('SIGN_RMK').setRequired(false);
            }

		    window.focus();
	    }

	    function onConfirm() {

	        <%-- 전자결재에서 전자서명 로직 삭제 : 2020-07-22
            var localServerFlag = "${localServerFlag}";

            if (localServerFlag == "Y") {
                doConfirm();
            } else {
                document.reqForm.signData.value = "${param.appDocNum }" + "@@" + "${param.appDocCnt }";

                var certOdiFilter = "${certOidfilter}";
                var listOdiArr = certOdiFilter.split(";");
                var certOidfilter = "";
                for(var i in listOdiArr) {
                    certOidfilter = certOidfilter + listOdiArr[i] + ",";
                }
                certOidfilter = certOidfilter.substring(0, certOidfilter.length-1);

                magicline.uiapi.MakeSignData(document.reqForm, null, mlCallBackPrc, certOidfilter);
            }
            --%>

            var store = new EVF.Store();
            if (!store.validate()) return;

            param.signStatus = "${param.signStatus }";
            param.signRmk = EVF.V("SIGN_RMK");
            parent.${'doApprovalOrReject'}(param);
            onClose();
        }

        function mlCallBackPrc(code, message){
            if(code == 0){ <%-- 정상메시지 --%>
                if (message.encMsg != null) { document.reqForm.signedData.value = encodeURIComponent(message.encMsg); }
                if (message.vidRandom != null) { document.reqForm.vidRandom.value = encodeURIComponent(message.vidRandom); }
                doConfirm();
            }
            else {
                return EVF.alert("결과값 수신에 실패하였습니다.");
            }
        }

        function doConfirm() {

		    var store = new EVF.Store();
		    if (!store.validate()) return;

		    param.signStatus = "${param.signStatus }";
		    param.signRmk = EVF.V("SIGN_RMK");
		    param.signedData = document.reqForm.signedData.value;
		    param.vidRandom = document.reqForm.vidRandom.value;
		    parent.${'doApprovalOrReject'}(param);
		    onClose();
	    }

	    function onClose() {
		    EVF.closeWindow();
	    }
    
    </script>

    <e:window id="CWOR0014" onReady="init" initData="${initData}" title="${param.signStatus == 'E' ? CWOR0014_ApprovalComment : CWOR0014_RejectComment}" breadCrumbs="${breadCrumb }">

    	<e:buttonBar id="buttonBar" align="right" width="100%">
            <e:button id="Confirm" name="Confirm" label="${param.signStatus == 'E' ? '승인' : '반려' }" disabled="${Confirm_D }" onClick="onConfirm" />
            <e:button id="Close" name="Close" label="${Close_N }" disabled="${Close_D }" onClick="onClose" />
        </e:buttonBar>

		<e:searchPanel id="form" useTitleBar="false" title="${form_caption_form_N}" labelWidth="${labelWidth}" width="100%" columnCount="2">
            <e:row>
				<e:label for="SIGN_RMK" title="${param.signStatus == 'E' ? CWOR0014_ApprovalComment : CWOR0014_RejectComment}" />
                <e:field colSpan="3">
                	<e:textArea id="SIGN_RMK" name="SIGN_RMK" width="100%" height="550" value="${param.SIGN_RMK}" required="${form_SIGN_RMK_R}" readOnly="${form_SIGN_RMK_RO}" disabled="${form_SIGN_RMK_D}" maxLength="${form_SIGN_RMK_M }"/>
                </e:field>
            </e:row>
        </e:searchPanel>

        <%--
        <form id='reqForm' name='reqForm' method='post' action="/MagicLine4Web/ML4Web/jcaosCheck.jsp">
            <input type="hidden" id="signData" name="signData" value="Login"/>
            <input type="hidden" id="signedData" name="signedData"/>
            <input type="hidden" id="vidRandom" name="vidRandom"/>
            <input type="hidden" id="vidType" name="vidType" value="client"/>
            <input type="hidden" id="idn" name="idn" value=""/>
        </form>

        <div id="dscertContainer">
            <iframe id="dscert" name="dscert" src="" width="100%" height="100%" frameborder="0" allowTransparency="true" style="position:fixed;z-index:100010;top:0px;left:0px;width:100%;height:100%;"></iframe>
        </div>
        --%>

    </e:window>
</e:ui>
