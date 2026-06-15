<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="kica.sgic.util.DataToXml" %>
<%@ page import="kica.sgic.util.SGIxLinker" %>
<%@ page import="kica.sgic.util.XmlToData" %>
<%@ page import="signgate.sgic.xml.util.XmlUtil" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.io.IOException" %>

<%! 
	public static final String sendinfo_conf = "S:/client_project/NH_SGIxLinker/WebContent/conf/sendinfo.properties";
	public static final String recvinfo_conf = "S:/client_project/NH_SGIxLinker/WebContent/conf/recvinfo.properties";
	public static final String templates_path = "S:/client_project/NH_SGIxLinker/WebContent/templates/";
%>