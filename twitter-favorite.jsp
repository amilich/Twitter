<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.mysql.jdbc.*" %>

<html>
<body>

<%
	String tweet_ID = request.getParameter("tweet_ID");
 	String login_ID = request.getParameter("login_ID"); //suck in html ; store in java var
 	int status = 0; 
 	java.sql.Connection con = null;
   	Class.forName("com.mysql.jdbc.Driver").newInstance();
   	String url = "jdbc:mysql://127.0.0.1/amilich_twitter";   //location and name of database
   	String userid = "amilich";
   	String password = "amilich";
   	con = DriverManager.getConnection(url, userid, password);      //connect to database

	try {
   		java.sql.PreparedStatement ps = con.prepareStatement("INSERT INTO favorites_t (tweet_ID,login_ID) VALUES (?, ?)"); 
   		ps.setString(1, tweet_ID); 
   		ps.setString(2, login_ID); 
   		status = ps.executeUpdate();
   	}
   	catch (Exception e){
   		java.sql.PreparedStatement del_fav = con.prepareStatement("DELETE FROM favorites_t WHERE (tweet_ID,login_ID) in ((?, ?))"); 
      del_fav.setString (1, tweet_ID);
      del_fav.setString (2, login_ID);
        //out.println(del_fav); 
		  status = del_fav.executeUpdate();
   		//out.println(e); 
   	}
%>

<script language="javascript">
    window.location.href = document.referrer; 
</script>

</body>
</html> 