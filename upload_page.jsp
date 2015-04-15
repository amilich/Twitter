<%@ page language="java" %>
<%@ page import="java.lang.Runtime"%>
<%@ page import="java.lang.Process"%>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.mysql.jdbc.*" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>

<%
	java.sql.Connection conn = null;
    ServletContext context = getServletContext();
    String directory = "";
    String name = "";
	String tile_text_file = "";
	String fn = "";
    
	Class.forName("com.mysql.jdbc.Driver").newInstance();
	String url = "jdbc:mysql://localhost:3306/amilich_twitter";
	
	String id = "amilich";
	String pwd = "amilich";
	String login_ID = (String) session.getAttribute("login_ID"); 
	out.println("L_ID: " + login_ID); 
	int status =0;
	
	conn = DriverManager.getConnection(url, id, pwd);
	java.sql.Statement stmt = conn.createStatement();
	//java.sql.PreparedStatement ps = conn.prepareStatement("update login_t set icon=(?) where login_ID=(?)"); 
	java.sql.PreparedStatement ps_link = conn.prepareStatement("update login_t set pic_link=(?) where login_ID=(?)"); 
	
	//MultipartRequest multi = new MultipartRequest(request, context.getRealPath(directory) + "/dwitter/userimages", 5 * 1024 * 1024);
	//out.println(context.getRealPath(directory) + "/twitter_dir/images/uploaded"); 
	//MultipartRequest multi = new MultipartRequest(request, context.getRealPath(directory) + "/images/uploaded", 5 * 1024 * 1024);
	try{ 
		MultipartRequest multi = new MultipartRequest(request, context.getRealPath(directory)+"/twitter_dir/images/uploaded", 5*1024*1024);
		Enumeration files = multi.getFileNames();
		
		while (files.hasMoreElements()) {
			name = (String)files.nextElement();
			fn = multi.getFilesystemName(name);
			if(fn == null){
				response.sendRedirect("twitter-settings.jsp?login_ID="+session.getAttribute("login_ID")); 
			}
		}
		
		//ps.setString(1, fn);
		//ps.setString(2, login_ID);
		//status = ps.executeUpdate();
		
		String link = "images/uploaded/" + fn; 
		//out.println(link); 

		ps_link.setString(1, link); 
		ps_link.setString(2, login_ID); 
		status = ps_link.executeUpdate();
		out.println(status); 
		out.println(ps_link); 

		String redirectURL="";
		redirectURL="twitter-home.jsp?login_ID="+session.getAttribute("login_ID");
		//out.println(redirectURL); 
		response.sendRedirect(redirectURL); 
	}
	catch(Exception e){
		out.println(e); 
	}
%>
