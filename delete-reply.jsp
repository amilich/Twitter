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
<body>

<%
    /* 
        Check the login and then delete a reply. 
    */
    String l_ID = request.getParameter("login_ID");
    
    try {
        String session_l_ID = (String)session.getAttribute("login_ID");
        if(Integer.parseInt(session_l_ID) != Integer.parseInt(l_ID)){
            response.sendRedirect("twitter-signin.jsp"); 
        }
    }
    catch(Exception e){
        response.sendRedirect("twitter-signin.jsp"); //send you back to homepage
    }

    //get the reply ID
    String r_ID = request.getParameter("reply_ID"); //suck in html ; store in java var
    int reply_ID = Integer.parseInt(r_ID); 
    
    if(reply_ID > 0){
        //you chose a valid reply
        try {
            //get the databse information
            int status = 0; 
            Scanner sc = new Scanner(new FileReader("/home/amilich/public_html/twitter_dir/keys.txt"));
            String db_user = sc.nextLine(); 
            String db_password = sc.nextLine(); 
            String db_url = sc.nextLine(); 
            java.sql.Connection con = null;
            Class.forName("com.mysql.jdbc.Driver").newInstance();
            String url = db_url; 
            con = DriverManager.getConnection(url, db_user, db_user); //mysql id &  pwd
    
            //delete it from the replies table
            java.sql.PreparedStatement ps = con.prepareStatement("DELETE FROM reply_t WHERE reply_ID = ?"); 
            ps.setString (1, r_ID);
            status = ps.executeUpdate();
        }
        catch (Exception e){
            out.println(e); 
        }
    }
    else {
    }
%>

<script language="javascript">
    window.location.href = document.referrer; //go back and refresh 
</script>

<h1> </h1>

</body>
</html> 