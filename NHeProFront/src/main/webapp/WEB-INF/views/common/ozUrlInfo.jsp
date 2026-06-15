<%

   // 도메인이 내부망이든, 개발서버든, 로컬이든 oz Scheudler 기동 및 eform 서버 참조를 위함
   // eversrm.properties에만 고정된 URL 호출 법 수정 
	String domain=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort();
	String ozExportUrl = domain +"/eform/export_files/";
	String ozUrl = domain+"/eform/doc";
	String ozServer = domain+"/eform/server";
%>