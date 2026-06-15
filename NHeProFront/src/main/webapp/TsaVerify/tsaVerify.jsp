<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="org.json.simple.parser.JSONParser"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="java.net.ProtocolException"%>
<%@page import="java.net.MalformedURLException"%>
<%@page import="java.net.UnknownHostException"%>
<%@page import="java.net.HttpURLConnection"%>
<%@page import="java.net.InetAddress"%>
<%@page import="java.net.URL"%>
<%@page import="org.apache.tomcat.util.codec.binary.Base64"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@page import="com.oreilly.servlet.MultipartRequest" %>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@page import="java.io.*" %>
<%@page import="java.util.Date" %>
<%@page import="java.text.SimpleDateFormat" %>

<%!
	String resultMsg="";
	boolean resultCode = false;
	String tokenYYMMDD = "";
	String tokenHHMMSS = "";
	boolean verify = false;
	//서버정보에 따라 TsaDappInfo 및 savePath 설정 필요
	String TsaDappInfo = "http://192.168.65.169:9004/v1/tsa/verify";
	String savePath = "C:\\upload\\";
%>
<%
	System.out.println("TSA-File Verify START");

	if ( request.getMethod().equals("POST")){
		request.setCharacterEncoding("UTF-8");

	    // 100Mbyte 제한
	    int maxSize  = 1024*1024*100;

	    // 업로드 파일명
	    String uploadFile = "";

	    // 실제 저장할 파일명
	    String newFileName = "";

	    int read = 0;
	    byte[] buf = new byte[1024];
	    FileInputStream fin = null;
	    FileOutputStream fout = null;
	    long currentTime = System.currentTimeMillis();
	    SimpleDateFormat simDf = new SimpleDateFormat("yyyyMMddHHmmss");

	    try{
	        MultipartRequest multi = new MultipartRequest(request, savePath, maxSize, "UTF-8", new DefaultFileRenamePolicy());

	        // 전송받은 parameter의 한글깨짐 방지
	        /* String title = multi.getParameter("title");
	        System.out.println("title : " + title);
	        title = new String(title.getBytes("8859_1"), "UTF-8"); */

	        // 파일업로드
	        uploadFile = multi.getFilesystemName("uploadFile");

	        // 실제 저장할 파일명(ex : 20140819151221.zip)
	        newFileName = simDf.format(new Date(currentTime)) +"."+ uploadFile.substring(uploadFile.lastIndexOf(".")+1);
	        System.out.println("newFileName : " + newFileName);
	        // 업로드된 파일 객체 생성
	        File oldFile = new File(savePath + uploadFile);
	        System.out.println("oldFile : " + oldFile);
	        // 실제 저장될 파일 객체 생성
	        File newFile = new File(savePath + newFileName);
	 		System.out.println("newFile : " + newFile);
	        // 파일명 rename
	        if(!oldFile.renameTo(newFile)){
	        	System.out.println("!!!!");
	            // rename이 되지 않을경우 강제로 파일을 복사하고 기존파일은 삭제
	            buf = new byte[1024];
	            fin = new FileInputStream(oldFile);
	            fout = new FileOutputStream(newFile);
	            read = 0;
	            while((read=fin.read(buf,0,buf.length))!=-1){
	                fout.write(buf, 0, read);
	            }
	            fin.close();
	            fout.close();
	            oldFile.delete();
	        }
	    }catch(Exception e){
	        e.printStackTrace();
	    }

	  	File file;
	    String aa = new String();
	    FileInputStream fis = null;
	    ByteArrayOutputStream baos = new ByteArrayOutputStream();

	  	try {
	        fis = new FileInputStream(savePath + newFileName); //파일객체를 FileInputStream으로 생성.
	    } catch (FileNotFoundException e) {
	        //logger.error("Exception position : FileUtil(FileNotFound) - fileToString(File file)");
	    }

	    int len = 0;
	    //byte[] buf = new byte[1024];
	    byte[] aaa = new byte[10240];

	    try {
	        while ((len = fis.read(aaa)) != -1) { //FileInputStream을  ByteArrayOutputStream에 쓴다.
	            baos.write(aaa, 0, len);
	        }

	        byte[] fileArray = baos.toByteArray(); //ByteArrayOutputStream 를 ByteArray 로 캐스팅한다
	        aa = new String(Base64.encodeBase64(fileArray));  //캐스팅 된 ByteArray를 Base64 로 인코딩한 후 String 로 캐스팅한다.

	    } catch (IOException e) {
	    } finally {
	    	if(fis != null) try { fis.close();} catch(IOException e) {
	    	}
	    	if(baos != null) try { baos.close();} catch(IOException e) {
	    	}
	    }

	    // 연결
		URL url = new URL(TsaDappInfo);
		HttpURLConnection conn = (HttpURLConnection) url.openConnection();
		conn.setDoOutput(true);
		conn.setRequestMethod("POST"); // 보내는 타입
	    conn.setRequestProperty("Content-type", "application/json");
		// 데이터
		//String param = "{\"title\": \"asdasd\", \"body\" : \"ddddddddd\"}";
		JSONObject obj = new JSONObject();
		obj.put("strFromFile", aa);

		// 전송
		OutputStreamWriter osw = new OutputStreamWriter(conn.getOutputStream());
		String line = null;
		String result = null;
		try {
			osw.write(obj.toJSONString());
			osw.flush();

			// 응답
			BufferedReader br = null;
			br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));


			while ((line = br.readLine()) != null) {
				result = line;
			}

			// 닫기
			osw.close();
			br.close();
		} catch (MalformedURLException e) {
			e.printStackTrace();
		} catch (ProtocolException e) {
			e.printStackTrace();
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		JSONParser parser = new JSONParser();
		Object objResult = parser.parse(result);
		JSONObject jsonObj = (JSONObject) objResult;

		resultCode = (boolean) jsonObj.get("success");
		resultMsg = (String) jsonObj.get("msg");

		if (!resultCode) {
			resultMsg = "시점확인 토큰이 등록되지 않은 문서입니다.";
			tokenYYMMDD ="";
			tokenHHMMSS ="";
		} else {
			resultMsg = "시점확인 토큰 검증 성공";
			JSONObject dateObj = (JSONObject) jsonObj.get("data");
			String issuerDate = dateObj.get("issuerDate").toString();

			String issuerYYYY = issuerDate.substring(0,4);
			String issuerMM = issuerDate.substring(4,6);
			String issuerDD = issuerDate.substring(6,8);
			String issuerHH = issuerDate.substring(8,10);
			String issuerMinut = issuerDate.substring(10,12);
			String issuerSS = issuerDate.substring(12,14);
			tokenYYMMDD = issuerYYYY+"-"+issuerMM+"-"+issuerDD;
			tokenHHMMSS = issuerHH+":"+issuerMinut+":"+issuerSS;

		}
		System.out.println("code : " + resultCode);
		System.out.println("msg : " + resultMsg);

		//out.println("code : " + code);
		//out.println("msg : " + message);

		File delFiles = new File(savePath + newFileName);
	   	if( delFiles.exists() ){ //파일존재여부확인
	   		if(delFiles.isDirectory()){ //파일이 디렉토리인지 확인
	   			File[] files = delFiles.listFiles();
	   			for( int i=0; i<files.length; i++){
	   				if( files[i].delete() ){
	   					System.out.println(files[i].getName()+" 삭제성공");
	   				}else{
	   					System.out.println(files[i].getName()+" 삭제실패");
	   				}
	   			}
	   		}
	   		if(delFiles.delete()){
	   			System.out.println("파일삭제 성공7");
	   		}else{
	   			System.out.println("파일삭제 실패");
	   		}
	   	}else{
	   		System.out.println("파일이 존재하지 않습니다.");
	   	}
		verify = true;
	}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <title>NHIS 시점확인 문서검증</title>
</head>
<body>
<div style="width:600px;text-align:center;border:1px solid gray;padding-left: 20px;padding-right: 20px;padding-bottom: 40px;margin-left: 15px;margin-right: 15px;margin-bottom: 15px;">
<div display:inline-block; style="position: relative;" >
	<H3 style="font-size:30px;">
		농협정보시스템 시점확인 문서검증
	</H3>

	<form name="fileForm" id="fileForm" method="POST" enctype="multipart/form-data">
	    <input type="file" name="uploadFile" id="uploadFile">
	    <input type="submit" value="검증">
	</form>

	<%if (verify) {   %>
		<br>
		<center style="font-size:20px; font-weight:bold;">
		 <%= resultMsg %>
		</center>
		<br>
		<center>
			<% if ( resultCode ){ %>
				<img src="/TsaVerify/IMGOriginal.png">
				<br>
				<br>
				<div style="left:41.5%; top:68%; font-size:20px; position:absolute;">
				<center >
					<%=tokenYYMMDD%>
				</center>
				<center >
					<%=tokenHHMMSS%>
				</center>
				</div>
			<% } else { %>
				<img src="/TsaVerify/IMGVerifyFail.png">
			<% } %>
		</center>
	<% }
		verify = false;
	%>
</div>
</div>
</body>
</html>
