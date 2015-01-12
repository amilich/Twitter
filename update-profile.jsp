<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.mysql.jdbc.*" %>

<html>
<body>

<%
	String l_ID = request.getParameter("login_ID");
    String description = request.getParameter("description"); //suck in html ; store in java var
	String pic_link = request.getParameter("pic_link"); //suck in html ; store in java var

    try {
        int status = 0; 
        
        java.sql.Connection con = null;
        Class.forName("com.mysql.jdbc.Driver").newInstance();
        String url = "jdbc:mysql://127.0.0.1/amilich_twitter";   //location and name of database
        String userid = "amilich";
        String password = "amilich";
        con = DriverManager.getConnection(url, userid, password);      //connect to database
   		java.sql.PreparedStatement ps; 
   
   		if(description.length() > 0){
        	ps = con.prepareStatement("UPDATE login_t SET DESCRIPTION=? WHERE login_ID=?;"); 
        	ps.setString (1, description);
        	ps.setString (2, l_ID);
        	status = ps.executeUpdate();
        }
        if(pic_link.length() > 0){
        	ps = con.prepareStatement("UPDATE login_t SET pic_link=? WHERE login_ID=?;"); 
        	ps.setString (1, pic_link);
        	ps.setString (2, l_ID);
        	status = ps.executeUpdate();
        }
    }
    catch (Exception e){
        out.println(e); 
    }
   
%>

<script language="javascript">
    window.location.href = document.referrer;
    //window.history.back();
    //window.location.href = "http://compsci.dalton.org:8080/amilich/twitter_dir/twitter-home.jsp?login_ID=<%=l_ID%>"; 
</script>

<h1> </h1>

</body>
</html> 