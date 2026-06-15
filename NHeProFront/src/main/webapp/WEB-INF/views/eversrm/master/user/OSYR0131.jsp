<%--
  Date: 2020-02-17
  Time: 13:13:46
  Scrren ID : OSYR0131
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
    <script>

        var baseUrl = '/eversrm/master/user/';

        function init() {}

        function doMaskApproval() {

            var store = new EVF.Store();
            if (!store.validate()) return;
            EVF.confirm("${OSYR0131_0008}", function() {
	            store.load(baseUrl + 'OSYR0131/doMaskApproval.so', function () {
		            EVF.V("MASK_SQ", this.getParameter("MASK_SQ"));
	
		            if("${form.APPROVAL_TYPE}" != "B") {
	                    // 열람요청이 완료되었습니다.
			            return EVF.alert("${OSYR0131_0001}");
		            } else {
                        opener.location.reload();

                        // 해제 요청 완료 된 건 DEL_FLAG 처리
                        setTimeout(function() {
                            doMaskApprovalCancel("P");
                        }, 2000);
		            }
		        });
            });
        }

        function doMaskApprovalCancel(flag) {
	        if (EVF.V("MASK_SQ") == "") {
                return EVF.alert("${OSYR0131_0002}"); // 열람요청을 진행하여 주시기 바랍니다.
	        }

	        // 개인정보열람요청취소 클릭 시
	        if (flag.type == "click") {
		        EVF.V("MASK_FLAG", "C");
            }

	        var store = new EVF.Store();
	        store.load(baseUrl + 'OSYR0131/doMaskApprovalCancel.so', function () {
		        if(flag == "P") {
			        doClose();
		        } else if(flag == "R") {
			        EVF.alert("${OSYR0131_0003}", function() { // 요청사유 작성 후 개인정보열람을 재요청해 주시기 바랍니다.
				        location.reload();
			        });
		        } else {
			        EVF.alert("${OSYR0131_0004}", function() { // 개인정보열람요청이 취소 되었습니다.
				        location.reload();
			        });
		        }
	        });
        }

        function doMaskView() {

	        if (EVF.V("MASK_SQ") == "") { return EVF.alert("${OSYR0131_0002}"); }

	        var store = new EVF.Store();
	        store.load(baseUrl + 'OSYR0131/doMaskView.so', function () {

                var rParam = JSON.parse(this.getParameter("maskApprovalInfo"));

                if(rParam == null) {
                	EVF.alert("${OSYR0131_0005}"); // 개인정보열람 승인 대기 중 입니다.
                } else {
	                if (rParam.MASK_APPROVAL == "R") {
	                	EVF.alert("${OSYR0131_0006}" + rParam.MASK_APPROVAL_RETURN, function() { // 위 사유로 열람요청이 반려되었습니다. 반려사유 :
			                // 해제 요청 완료 된 건 DEL_FLAG 처리
			                setTimeout(function() {
				                doMaskApprovalCancel("R");
			                }, 1000);
                        });
	                } else if (rParam.MASK_APPROVAL == "E") {
                        EVF.alert("${OSYR0131_0007}", function() { // 개인정보열람 승인 되었습니다.

	                        opener.location.reload();

	                        // 해제 요청 완료 된 건 DEL_FLAG 처리
	                        setTimeout(function() {
		                        doMaskApprovalCancel("P");
	                        }, 2000);
                        });
	                }
                }
	        });
	        // opener.location.reload();
        }

        function doClose() {
	        EVF.closeWindow();
        }

    </script>

    <e:window id="OSYR0131" initData="${initData}" onReady="init" title="${fullScreenName }" breadCrumbs="${breadCrumb }">
        <e:searchPanel id="form" title="${msg.M9999}" labelWidth="100" width="100%" columnCount="2" onEnter="doSearch">

            <e:inputHidden id="MASK_SQ" name="MASK_SQ" value="${form.MASK_SQ}" />
            <e:inputHidden id="APPROVAL_TYPE" name="APPROVAL_TYPE" value="${form.APPROVAL_TYPE}" />
            <e:inputHidden id="MASK_FLAG" name="MASK_FLAG" />

            <e:row>
                <%-- 요청자 --%>
                <e:label for="USER_ID" title="${form_USER_ID_N}" />
                <e:field>
                    <e:inputText id="USER_ID" name="USER_ID" value="${empty form.USER_ID ? ses.userId : form.USER_ID}" width="40%" maxLength="${form_USER_ID_M}" disabled="${form_USER_ID_D}" readOnly="${form_USER_ID_RO}" required="${form_USER_ID_R}" style="${imeMode}" maskType="${form_USER_ID_MT}"/>
                    <e:inputText id="USER_NM" name="USER_NM" value="${empty form.USER_NM ? ses.userNm : form.USER_NM}" width="60%" maxLength="${form_USER_NM_M}" disabled="${form_USER_NM_D}" readOnly="${form_USER_NM_RO}" required="${form_USER_NM_R}" style="${imeMode}" maskType="${form_USER_NM_MT}"/>
                </e:field>
                <%-- 요청일 --%>
                <e:label for="ACCESS_DATE" title="${form_ACCESS_DATE_N}"/>
                <e:field>
                    <e:inputDate id="ACCESS_DATE" name="ACCESS_DATE" value="${empty form.ACCESS_DATE ? defaultDate : form.ACCESS_DATE}" width="${inputDateWidth}" datePicker="true" required="${form_ACCESS_DATE_R}" disabled="${form_ACCESS_DATE_D}" readOnly="${form_ACCESS_DATE_RO}" />
                </e:field>
            </e:row>
            <e:row>
                <%-- 화면 --%>
                <e:label for="SCREEN_ID" title="${form_SCREEN_ID_N}" />
                <e:field>
                    <e:inputText id="SCREEN_ID" name="SCREEN_ID" value="${empty form.SCREEN_ID ? form.PARAM_SCREEN_ID : form.SCREEN_ID}" width="40%" maxLength="${form_SCREEN_ID_M}" disabled="${form_SCREEN_ID_D}" readOnly="${form_SCREEN_ID_RO}" required="${form_SCREEN_ID_R}" style="${imeMode}" maskType="${form_SCREEN_ID_MT}"/>
                    <e:inputText id="SCREEN_NM" name="SCREEN_NM" value="${empty form.SCREEN_NM ? form.PARAM_SCREEN_NM : form.SCREEN_NM}" width="60%" maxLength="${form_SCREEN_NM_M}" disabled="${form_SCREEN_NM_D}" readOnly="${form_SCREEN_NM_RO}" required="${form_SCREEN_NM_R}" style="${imeMode}" maskType="${form_SCREEN_NM_MT}"/>
                </e:field>
                <e:label for="IP_ADDR" title="${form_IP_ADDR_N}" />
                <e:field>
                    <e:inputText id="IP_ADDR" name="IP_ADDR" value="${empty form.IP_ADDR ? ses.ipAddress : form.IP_ADDR}" width="${form_IP_ADDR_W}" maxLength="${form_IP_ADDR_M}" disabled="${form_IP_ADDR_D}" readOnly="${form_IP_ADDR_RO}" required="${form_IP_ADDR_R}" style="${imeMode}" maskType="${form_IP_ADDR_MT}"/>
                </e:field>
            </e:row>
            <e:row>
                <%-- 해제 여부 --%>
                <e:label for="MASK_RMK" title="${form_MASK_RMK_N}"/>
                <e:field colSpan="3">
                    <e:textArea id="MASK_RMK" name="MASK_RMK" value="${form.MASK_RMK}" height="100px" width="${form_MASK_RMK_W}" maxLength="${form_MASK_RMK_M}" disabled="${form_MASK_RMK_D}" readOnly="${form_MASK_RMK_RO}" required="${form_MASK_RMK_R}"/>
                </e:field>
            </e:row>
        </e:searchPanel>

        <e:buttonBar width="100%" align="right">
            <e:button id="doMaskApproval" name="doMaskApproval" label="${doMaskApproval_N}" onClick="doMaskApproval" disabled="${doMaskApproval_D}" visible="${form.VISIBLE_FLAG}"/>
            <c:if test="${form.APPROVAL_TYPE eq 'A'}">
                <e:button id="doMaskApprovalCancel" name="doMaskApprovalCancel" label="${doMaskApprovalCancel_N}" onClick="doMaskApprovalCancel" disabled="${doMaskApprovalCancel_D}" visible="${form.VISIBLE_FLAG}"/>
                <e:button id="doMaskView" name="doMaskView" label="${doMaskView_N}" onClick="doMaskView" disabled="${doMaskView_D}" visible="${doMaskView_V}"/>
            </c:if>
        </e:buttonBar>

    </e:window>
</e:ui>