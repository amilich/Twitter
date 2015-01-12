<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.mysql.jdbc.*" %>

<html>
<body>

<%
	String from = request.getParameter("from");
    String to = request.getParameter("to");
    String message_text = request.getParameter("text"); //suck in html ; store in java var

    if(message_text.length() > 0){
        try {       
            java.sql.Connection con = null;
            Class.forName("com.mysql.jdbc.Driver").newInstance();
            String url = "jdbc:mysql://127.0.0.1/amilich_twitter";   //location and name of database
            String userid = "amilich";
            String password = "amilich";
            con = DriverManager.getConnection(url, userid, password);      //connect to database

            java.sql.PreparedStatement ps = con.prepareStatement("INSERT INTO messages_t (text, from, to, d_t) VALUES (?, ?, ?, NOW()); ");
            int status = 0; 
            ps.setString (1, message_text);
            ps.setString (2, from);
            ps.setString (3, to);
            out.println(ps); 
            status = ps.executeUpdate();
        }
        catch (Exception e){
            out.println(e); 
        }
    }
    else {
    	//out.println("no text"); 
    }
    //response.sendRedirect(""); 
%>

</body>
</html> 