<%@ page import="java.util.Date,java.util.Enumeration" %>
<%@ page import="java.util.Properties" %>
<%@ page contentType="text/html;charset=euc-kr" %>

username is: <%= request.getRemoteUser() %>
<br>

<%

	Date today = new Date(System.currentTimeMillis());
	out.println("Today: " + today.toString());
	out.println("<br>");


	// START getprops
	Properties props = System.getProperties(); // get list of properties
	// Print properties using Enumeration
	for (Enumeration enum1 = props.propertyNames(); enum1.hasMoreElements();) {
		String key = (String)enum1.nextElement();
		out.println(key + " = " + props.get(key));
			out.println("<br>");
	}
	// END getprops


	// START getprop
	// get user's home directory
	String homeDir = System.getProperty("user.home");
	// If 'outDir' not found, use 'homeDir' as default
	String outDir = System.getProperty("testdir", homeDir);
	// END getprop
	// out.println("homeDir: " + homeDir);
	// out.println("<br>");
	// out.println("outDir: " + outDir);
	// out.println("<br>");
	/*
	props = System.getProperties(); // get list of properties
	String file_separator = (String)(props.get("file.separator"));
	String current_dir = "";
	String CertPath = "";
	String Full_path = request.getRealPath(request.getServletPath());
	if (file_separator.equals("\\"))	
	{
		current_dir = Full_path.substring(0,Full_path.lastIndexOf("\\")+1);
		CertPath = current_dir + "\\"; 
	}
	else								
	{
		current_dir = Full_path.substring(0,Full_path.lastIndexOf("/")+1);
		CertPath = current_dir + "/"; 
	}

	OutputStream out1=null;
	out1 = new FileOutputStream(CertPath + "temp_file.txt", false);
	out1.write("11".getBytes());
	out1.close();
	*/


%>