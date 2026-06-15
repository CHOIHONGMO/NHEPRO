<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.st_ones.common.util.clazz.EverString" %>
<%@ page import="org.springframework.web.servlet.FrameworkServlet" %>
<%
    javax.servlet.http.HttpSession hs = request.getSession(false);
    javax.servlet.ServletContext sc = hs.getServletContext();
    org.springframework.web.context.WebApplicationContext appContext = org.springframework.web.context.support.WebApplicationContextUtils.getWebApplicationContext(sc, FrameworkServlet.SERVLET_CONTEXT_PREFIX+"EverSRM Dispatcher");
    com.st_ones.eversrm.eApproval.eApprovalModule.service.BAPM_Service eApprovalService = (com.st_ones.eversrm.eApproval.eApprovalModule.service.BAPM_Service) appContext.getBean("bapm_Service");
    com.st_ones.everf.serverside.info.BaseInfo baseInfo = (com.st_ones.everf.serverside.info.BaseInfo) hs.getAttribute("ses");
    com.st_ones.everf.serverside.info.UserInfoManager.createUserInfo(baseInfo);

    String buyer_cd = request.getParameter("BUYER_CD");
    String app_doc_num = request.getParameter("APP_DOC_NUM");
    String app_doc_cnt = request.getParameter("APP_DOC_CNT");

    java.util.List<java.util.Map<String, Object>> list = new java.util.ArrayList<java.util.Map<String, Object>>();
    java.util.Map<String, String> map = new java.util.HashMap<String, String>();
    map.put("BUYER_CD", buyer_cd);
    map.put("APP_DOC_NUM", app_doc_num);
    map.put("APP_DOC_CNT", app_doc_cnt);

    if (app_doc_num != null && !"".equals(app_doc_num)) {
        list = eApprovalService.singerList(map);
    }

    if (list.size() != 0) {

        for (int k = 0; k < list.size(); k++) {
            java.util.Map data = list.get(k);
        }
%>

<style>
    td {
        font-family: "맑은 고딕";
        font-size: 12px;
    }
</style>
<div id="list">

    <div style="padding-bottom: 3px; padding-top: 5px;">
        <div class="e-title-bullet-h1" style="padding-bottom: 1px;"></div><div class="e-title-text">결재자 리스트</div>
    </div>

    <table style="table-LAYOUT: fixed" cellSpacing="0" cellPadding="0" width="100%" border="0">
        <tbody>
            <tr align="center">
                <td style="font-size: 9pt; height: 34px; font-weight: bold; color: #ffffff; text-align: center; background-color: #92a0a6" width="6%"  noWrap>순번</td>
                <td style="font-size: 9pt; height: 34px; font-weight: bold; color: #ffffff; text-align: center; background-color: #92a0a6" width="14%" noWrap>구분</td>
                <td style="font-size: 9pt; height: 34px; font-weight: bold; color: #ffffff; text-align: center; background-color: #92a0a6" width="16%" noWrap>성명</td>
                <td style="font-size: 9pt; height: 34px; font-weight: bold; color: #ffffff; text-align: center; background-color: #92a0a6" width="15%" noWrap>회사명</td>
                <td style="font-size: 9pt; height: 34px; font-weight: bold; color: #ffffff; text-align: center; background-color: #92a0a6" width="14%" noWrap>부서명</td>
                <td style="font-size: 9pt; height: 34px; font-weight: bold; color: #ffffff; text-align: center; background-color: #92a0a6" width="20%" noWrap>처리내용</td>
                <td style="font-size: 9pt; height: 34px; font-weight: bold; color: #ffffff; text-align: center; background-color: #92a0a6" width="15%" noWrap>처리일시</td>
            </tr>
            <tr>
                <td bgcolor="#d9d9d9" height="1" colSpan="5" />
            </tr>
        </tbody>
    </table>

    <table cellSpacing="0" cellPadding="0" width="100%" border="0">
        <tbody>
        <%
            for (int k = 0; k < list.size(); k++) {
                java.util.Map data = list.get(k);
        %>
            <tr>
                <td style="font-size: 9pt; height: 34px; border-bottom: #cccccc 1px solid; font-weight: bold; color: #7a5e4b; padding-top: 1px; WIDTH: 100px; background-color: #f1f1f1" width="6%" align="center">
                	<%=data.get("SIGN_PATH_SQ") %>
                </td>
                <td style="font-size: 9pt; height: 34px; border-bottom: #cccccc 1px solid; color: #333333; padding-top: 2px; background-color: #f1f1f1" width="14%" align="center">
                	<span style="font-family: '맑은 고딕'; font-size:9pt; font-weight:bold; color:#0072b5;"><%=data.get("SIGN_REQ_TYPE_NAME") %></span>
                </td>
                <td style="font-size: 9pt; height: 34px; border-bottom: #cccccc 1px solid; color: #333333; padding-top: 2px; padding-left: 10px; background-color: #f1f1f1" width="15%">
                	<%=data.get("SIGN_NAME") %> <%=((data.get("POSITION_NM") == null || data.get("POSITION_NM") == "null") ? "" : data.get("POSITION_NM")) %>
                </td>
                <td style="font-size: 9pt; height: 34px; border-bottom: #cccccc 1px solid; color: #333333; padding-top: 2px; padding-left: 10px; background-color: #f1f1f1" width="17%">
                	<%=((data.get("COMPANY_NM") == null || data.get("COMPANY_NM") == "null") ? "" : data.get("COMPANY_NM")) %>
                </td>
                <td style="font-size: 9pt; height: 34px; border-bottom: #cccccc 1px solid; color: #333333; padding-top: 2px; padding-left: 10px; background-color: #f1f1f1" width="15%">
                	<%=((data.get("DEPT_NM") == null || data.get("DEPT_NM") == "null") ? "" : data.get("DEPT_NM")) %>
                </td>
                <td style="font-size: 9pt; height: 34px; border-bottom: #cccccc 1px solid; color: #333333; padding-top: 2px; padding-left: 10px; background-color: #f1f1f1" width="18%">
                	<%=((data.get("SIGN_RMK") == null || data.get("SIGN_RMK") == "null") ? "" : data.get("SIGN_RMK")) %>
                </td>
                <td style="font-size: 9pt; height: 34px; border-bottom: #cccccc 1px solid; color: #755232; padding-top: 2px; background-color: #f1f1f1" width="15%" align="center">
                	<%=((data.get("SIGN_DATE") == null || data.get("SIGN_DATE") == "null") ? "" : data.get("SIGN_DATE")) %>
                </td>
            </tr>
        <% } %>
        </tbody>
    </table>
</div>
<%
    }
%>

<% if (list.size() != 0) { %>

    <table width="100%" border="0">
        <tbody>
            <tr><td bgcolor="#ffffff" height="2" /></tr>
        </tbody>
    </table>

<% } %>