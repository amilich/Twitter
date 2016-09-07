<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.mysql.jdbc.*" %>

<html>
<body>

<%
	String follower_ID = request.getParameter("follower_ID");
 	String followed_ID = request.getParameter("followed_ID"); //suck in html ; store in java var
 	
 	if(Integer.parseInt(follower_ID) != Integer.parseInt(followed_ID)){
		try {
			int status = 0; 
		
    	    		java.sql.Connection con = null;
    	    		Class.forName("com.mysql.jdbc.Driver").newInstance();
    	    		String url = "jdbc:mysql://127.0.0.1/amilich_twitter";   //location and name of database
    	    		String userid = "amilich";
    	    		String password = "amilich";
    	    		con = DriverManager.getConnection(url, userid, password);      //connect to database
		
    	    		java.sql.PreparedStatement ps = con.prepareStatement("DELETE FROM following_t WHERE follower_ID = " + follower_ID + " AND followed_ID = " + followed_ID + ";");
    	    		status = ps.executeUpdate();
    		} catch (Exception e){
    			//out.println(e); //usually for duplicates - we don't want to print that
    		}
    }
%>

<script language="javascript">
    window.location.href = document.referrer;
</script>

<h1> </h1>

</body>
</html> 
