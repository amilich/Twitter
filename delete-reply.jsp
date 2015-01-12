<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.mysql.jdbc.*" %>

<html>
<body>

<%
    String l_ID = request.getParameter("login_ID");
    
    try {
        String session_l_ID = (String)session.getAttribute("login_ID");
        if(Integer.parseInt(session_l_ID) != Integer.parseInt(l_ID)){
            response.sendRedirect("twitter-signin.jsp"); 
        }
    }
    catch(Exception e){
            response.sendRedirect("twitter-signin.jsp"); 
    }


    String r_ID = request.getParameter("reply_ID"); //suck in html ; store in java var
    int reply_ID = Integer.parseInt(r_ID); 
    
    if(reply_ID > 0){
        try {
            int status = 0; 
            
            java.sql.Connection con = null;
            Class.forName("com.mysql.jdbc.Driver").newInstance();
            String url = "jdbc:mysql://127.0.0.1/amilich_twitter";   //location and name of database
            String userid = "amilich";
            String password = "amilich";
            con = DriverManager.getConnection(url, userid, password);      //connect to database
    
            java.sql.PreparedStatement ps = con.prepareStatement("DELETE FROM reply_t WHERE reply_ID = ?"); 
            ps.setString (1, r_ID);
            status = ps.executeUpdate();
        }
        catch (Exception e){
            out.println(e); 
        }
    }
    else {
    	//out.println("no text"); 
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