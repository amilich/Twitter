<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.mysql.jdbc.*" %>

<html>

<%
	String ue = request.getParameter("ue");
 	String pw = request.getParameter("pw"); //suck in html ; store in java var
 	int login_ID = 0; 
 	 	
	try {
		int status = 0; 
		
        java.sql.Connection con = null;
        Class.forName("com.mysql.jdbc.Driver").newInstance();
        String url = "jdbc:mysql://127.0.0.1/amilich_twitter";   //location and name of database
        String userid = "amilich";
        String password = "amilich";
        con = DriverManager.getConnection(url, userid, password);      //connect to database

    	String check_q = "SELECT login_ID,first_name,last_name,email,description,pic_link from login_t WHERE (username='" + ue + "' OR email='" + ue + "') AND password='" + pw+ "';";
    	java.sql.Statement check_s = con.createStatement();
    	java.sql.ResultSet rs1 = check_s.executeQuery(check_q);
		
		boolean set = false; 
		
		while(rs1.next()){
			set = true; 

			login_ID = Integer.parseInt(rs1.getString(1)); 
			
			session.setAttribute( "login_ID", (login_ID+"") );
			session.setAttribute( "username", ue ); 
			session.setAttribute( "first_name", rs1.getString(2) ); 
			session.setAttribute( "last_name", rs1.getString(3) ); 
			session.setAttribute( "email", rs1.getString(4) ); 
			session.setAttribute( "description", rs1.getString(5) ); 
			session.setAttribute( "pic_link", rs1.getString(6) ); 

			//out.println("hi: " + session.getAttribute("username"));
			//out.println(rs1.getString(1)); 
			//out.println("logged " + login_ID + " in"); 
			%>
				<script>
					//document.write("writing now"); 
					var d = new Date();
					var exdays = 1; 
    				d.setTime(d.getTime() + (exdays*24*60*60*1000));
    				var expires = "expires="+d.toUTCString();
					document.cookie="login_ID=<%=login_ID%>; expires="+expires+"; path=/";
				</script>
			<%
		}
		if(!set){
			%>
				<script>
				    window.location.href = "http://compsci.dalton.org:8080/amilich/twitter_dir/twitter-signin.jsp"; 
				</script>
			<%
		}
    }
    catch (Exception e){
    	out.println(e); 
    }
    response.sendRedirect("twitter-home.jsp?login_ID=" + login_ID); 
%>

<body>
</body>
</html> 