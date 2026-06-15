<%@ page contentType="text/html; charset=UTF-8" %>

<html>
<head>
<title>KICASGIxLinker recving Sample</title>
</head>

<%@ include file="signgate_xlinker.jsp" %>

<%

		SGIxLinker xLinker =  new SGIxLinker(this.recvinfo_conf, "recv.jsp", true);  
		
		//xLinker.setRecipientCert(String pemCert);
	
		try
		{    		
			boolean isOK = xLinker.doRecvProcess(request, response);
					
			if(!isOK) {
				super.getServletContext().log("isOK is false");
				throw new Exception("API : [" + xLinker.getErrorCode() + "] : " + xLinker.getErrorMsg());
			}

			String recvDocCode = xLinker.getRecvDocCode();
			String recvXmlDoc =  xLinker.getRecvXmlData();
			if(recvXmlDoc.equals("")){
				recvXmlDoc =  xLinker.getDecXmlPath();
			}

			String responseXml="";

			HashMap h = xLinker.getData();
			Iterator k = h.keySet().iterator();
			while (k.hasNext()) {
				String key = (String) k.next();
				Object obj = h.get(key);
				if( obj instanceof String){
					System.out.println("Key " + key + "; Value " +
						(String) obj);
				}else if( obj instanceof byte[]){
					System.out.println("Key " + key + "; Value " +
						(byte[]) obj);
				}
			}
			
			if( (recvDocCode!=null)&&(!recvDocCode.equals(""))&&
					(recvXmlDoc!=null)&&(!recvXmlDoc.equals("")))
			{
				responseXml = xLinker.responseAck("SA", "success.", "1234567890");
				//String recvxml = XmlUtil.readStringFileName("c:/recv20061030201939_dec.xml");
				//responseXml = xLinker.responseSoapMime(recvxml);
			}else{
				responseXml = xLinker.responseAck("SR", "fail", "1234567890");				
			}

			
			
			ServletOutputStream output = null;
			try {
				output = response.getOutputStream();
				output.write(responseXml.getBytes()) ;
				output.flush() ; 
				if (output != null) output.close();
			} catch (IOException e) {
				System.out.println("recv_jsp" + " service FAILED!!!!");
				e.printStackTrace();
				throw new Exception("aaa.:"+e.toString());
			}
		    System.out.println("recv_jsp" + " service finished SUCCESSFULLY!!!");

			System.out.println(xLinker.getRecvAckXmlData());

		}catch(Exception e)	{
			e.printStackTrace();
	    }finally {
	    	
		}

%>
<body>

</body>
</html>