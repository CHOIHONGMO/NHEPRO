<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
    <script type="text/javascript">

        function init() {

        }

        function closess() {
            EVF.closeWindow();
        }

        function doApply() {
            var param = {
                "message": EVF.V("mmm"),
                "rowIdx": EVF.V("rowIdx"),
                "idx": EVF.V("idx"),
                "CUST_CD": EVF.V("CUST_CD")
            };

            if (opener != null) {
                opener['${param.callbackFunction}'](param);
            } else {
                parent['${param.callbackFunction}'](param);
            }
            closess();
        }

    </script>
    <e:window id="COMMON_TEXT_VIEW" onReady="init" initData="${initData}" title="${not empty param.title ? param.title : screenName}" breadCrumbs="${breadCrumb }">
        <e:textArea id="mmm" name="mmm" width="100%" height="250px" value="${param.message }" required="" disabled="false" maxLength="" readOnly="false"/>
        <e:inputHidden id="rowIdx" name="rowIdx" value="${param.rowIdx}"/>
        <e:inputHidden id="idx" name="idx" value="${param.idx}"/>
        <e:inputHidden id="CUST_CD" name="CUST_CD" value="${param.CUST_CD}"/>
        <c:if test="${param.detailView != 'true' }">
            <e:buttonBar align="right">
                <e:button id="doApply" name="doApply" label="적용" onClick="doApply" disabled="${param.detailView}" />
                <%-- <e:button id="doClose" name="doClose" label="닫기" onClick="closess"/> --%>
            </e:buttonBar>
        </c:if>
    </e:window>
</e:ui>