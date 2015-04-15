<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.mysql.jdbc.*" %>
<%@ page import="java.text.DateFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.ParseException" %> 
<%@ page import="java.util.Date" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.Scanner" %>

<html>

<%
	/*
		Check the login information. 

	*/

	String ue = request.getParameter("ue");
 	String pw = request.getParameter("pw"); //suck in html ; store in java var
 	int login_ID = 0; 
 	 	
	try {
		int status = 0; 
		//read the database information 
		Scanner sc = new Scanner(new FileReader("/home/amilich/public_html/twitter_dir/keys.txt"));
		String db_user = sc.nextLine(); 
		String db_password = sc.nextLine(); 
		String db_url = sc.nextLine(); 
        java.sql.Connection con = null;
		Class.forName("com.mysql.jdbc.Driver").newInstance();
		String url = db_url; 
		con = DriverManager.getConnection(url, db_user, db_user); //mysql id &  pwd

		//check your info 
    	String check_q = "SELECT login_ID,first_name,last_name,email,description,pic_link from login_t WHERE (username='" + ue + "' OR email='" + ue + "') AND password='" + pw+ "';";
    	java.sql.Statement check_s = con.createStatement();
    	java.sql.ResultSet rs1 = check_s.executeQuery(check_q);
		
		boolean set = false; 
		
		while(rs1.next()){
			set = true; 

			login_ID = Integer.parseInt(rs1.getString(1)); 
			
			//put all your info in session variables
			session.setAttribute( "login_ID", (login_ID+"") );
			session.setAttribute( "username", ue ); 
			session.setAttribute( "first_name", rs1.getString(2) ); 
			session.setAttribute( "last_name", rs1.getString(3) ); 
			session.setAttribute( "email", rs1.getString(4) ); 
			session.setAttribute( "description", rs1.getString(5) ); 
			session.setAttribute( "pic_link", rs1.getString(6) ); 

			%>
				<script>
					//put your login into a cookie
					var d = new Date();
					var exdays = 1; 
    				d.setTime(d.getTime() + (exdays*24*60*60*1000));
    				var expires = "expires="+d.toUTCString();
					document.cookie="login_ID=<%=login_ID%>; expires="+expires+"; path=/";
				</script>
			<%
		}
		if(!set){
			response.sendRedirect("twitter-signin.jsp?msg=fail"); 
		}
		else {
			response.sendRedirect("twitter-home.jsp?login_ID=" + login_ID); 
		}
    }
    catch (Exception e){
    	out.println(e); 
    }
    //you logged in!
%>

<body>
</body>
</html> 