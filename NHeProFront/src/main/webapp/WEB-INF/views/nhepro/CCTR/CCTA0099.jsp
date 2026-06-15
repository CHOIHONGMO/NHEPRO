<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="org.json.simple.JSONArray"%>


<%@page import="java.io.UnsupportedEncodingException"%>
<%@page import="java.net.URISyntaxException"%>


<%@page import="com.sun.org.apache.xerces.internal.impl.dv.util.Base64"%>
<%@page import="org.apache.commons.io.FileUtils"%>
<%@page import="java.io.*"%>
<%@page import="java.util.*"%>

<%@page import="org.json.simple.JSONObject"%>
<%@page import="org.json.simple.parser.*"%>
<%@page import="com.st_ones.common.util.clazz.*"%>

<%@page import="com.st_ones.everf.serverside.config.PropertiesManager"%>

<%@page import="com.dreamsecurity.magicline.JCaosCheckCert"%>

<%@page import="com.st_ones.common.file.service.FileAttachService"%>

<%@page import="com.st_ones.common.util.DRMUtils"%>
<%@page import="com.st_ones.common.login.domain.UserInfo"%>
<%@page import="com.st_ones.everf.serverside.info.UserInfoManager"%>




<%

response.addHeader("Access-Control-Allow-Origin", "*");


String inFile = request.getParameter("inFile").toString();



File inputTargetFile = new File(inFile);
String inputfileHash =EverFile.fileToHash(inputTargetFile);

System.out.println("inputfileHash : ======> " + inputfileHash);




%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <title>hash 확인</title>
</head>
<body>
HASH : <%=inputfileHash%>

</body>
</html>
