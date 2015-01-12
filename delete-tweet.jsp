<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.mysql.jdbc.*" %>

<html>
<body>

<%
	String l_ID = request.getParameter("login_ID");
    String t_ID = request.getParameter("tweet_ID"); 
    String r_ID = request.getParameter("retweet_ID"); //suck in html ; store in java var
    int tweet_ID = Integer.parseInt(t_ID); 
    /*out.println(l_ID); 
    out.println(t_ID); 
    out.println(r_ID); */

    if(tweet_ID > 0){
        try {
            int status = 0; 
            
            java.sql.Connection con = null;
            Class.forName("com.mysql.jdbc.Driver").newInstance();
            String url = "jdbc:mysql://127.0.0.1/amilich_twitter";   //location and name of database
            String userid = "amilich";
            String password = "amilich";
            con = DriverManager.getConnection(url, userid, password);      //connect to database
            
            if(Integer.parseInt(r_ID) > 0) {
                java.sql.PreparedStatement retweet_del = con.prepareStatement("DELETE FROM retweets_t WHERE retweet_ID = ?"); 
                retweet_del.setString (1, r_ID);
                status = retweet_del.executeUpdate();
            }

            java.sql.PreparedStatement rep_del = con.prepareStatement("DELETE FROM reply_t WHERE tweet_ID = ?"); 
            rep_del.setString (1, t_ID);
            status = rep_del.executeUpdate();

            java.sql.PreparedStatement fav_del = con.prepareStatement("DELETE FROM favorites_t WHERE tweet_ID = ?"); 
            fav_del.setString (1, t_ID);
            status = fav_del.executeUpdate();

            java.sql.PreparedStatement hash_del = con.prepareStatement("DELETE FROM hash_tweet_t WHERE tweet_ID = ?"); 
            hash_del.setString (1, t_ID);
            status = hash_del.executeUpdate();
    
            java.sql.PreparedStatement ps = con.prepareStatement("DELETE FROM tweets_t WHERE tweet_ID = ?"); 
            ps.setString (1, t_ID);
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