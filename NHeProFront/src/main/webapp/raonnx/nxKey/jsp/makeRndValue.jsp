<%@ page import="TouchenKey_Crypto.*" %>
<%
TouchEnKey_Crypto tk = new TouchEnKey_Crypto();
String tnk_srnd = tk.CreateSessionRandom(session);

String value = (String)session.getAttribute("TEKSRK");

%>
<script type="text/javascript">var TNK_SR = '<%=tnk_srnd%>';</script>