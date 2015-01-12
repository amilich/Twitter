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
        Delete a tweet 
    */
	String l_ID = request.getParameter("login_ID");
    String t_ID = request.getParameter("tweet_ID"); 
    String r_ID = request.getParameter("retweet_ID"); //to delete a retweet 
    int tweet_ID = Integer.parseInt(t_ID); 

    if(tweet_ID > 0){ //if you chose a valid tweet 
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
            
            //first, delete from the retweet table
            if(Integer.parseInt(r_ID) > 0) {
                java.sql.PreparedStatement retweet_del = con.prepareStatement("DELETE FROM retweets_t WHERE retweet_ID = ?"); 
                retweet_del.setString (1, r_ID);
                status = retweet_del.executeUpdate();
            }

            //delete all of the tweet's replies 
            java.sql.PreparedStatement rep_del = con.prepareStatement("DELETE FROM reply_t WHERE tweet_ID = ?"); 
            rep_del.setString (1, t_ID);
            status = rep_del.executeUpdate();

            //delete it from the favorite's table 
            java.sql.PreparedStatement fav_del = con.prepareStatement("DELETE FROM favorites_t WHERE tweet_ID = ?"); 
            fav_del.setString (1, t_ID);
            status = fav_del.executeUpdate();

            //delete it from the hashtag table
            java.sql.PreparedStatement hash_del = con.prepareStatement("DELETE FROM hash_tweet_t WHERE tweet_ID = ?"); 
            hash_del.setString (1, t_ID);
            status = hash_del.executeUpdate();
            
            //finally, delete the tweet (no foreign key errors then)
            java.sql.PreparedStatement ps = con.prepareStatement("DELETE FROM tweets_t WHERE tweet_ID = ?"); 
            ps.setString (1, t_ID);
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
    window.location.href = document.referrer;
    //window.history.back();
    //window.location.href = "http://compsci.dalton.org:8080/amilich/twitter_dir/twitter-home.jsp?login_ID=<%=l_ID%>"; 
</script>

<h1> </h1>

</body>
</html> 