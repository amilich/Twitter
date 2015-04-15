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
    Favorite a tweet 
  */

	String tweet_ID = request.getParameter("tweet_ID"); //get the tweet ID you want to favorite 
 	String login_ID = request.getParameter("login_ID"); //suck in html ; store in java var
 	int status = 0; 
 	Scanner sc = new Scanner(new FileReader("/home/amilich/public_html/twitter_dir/keys.txt"));
  String db_user = sc.nextLine(); 
  String db_password = sc.nextLine(); 
  String db_url = sc.nextLine(); 

  java.sql.Connection con = null;
  Class.forName("com.mysql.jdbc.Driver").newInstance();
  String url = db_url; 
  con = DriverManager.getConnection(url, db_user, db_user); //mysql id &  pwd    //connect to database

	try {
   		java.sql.PreparedStatement ps = con.prepareStatement("INSERT INTO favorites_t (tweet_ID,login_ID) VALUES (?, ?)"); //put in that you favorited it
   		ps.setString(1, tweet_ID); 
   		ps.setString(2, login_ID); 
   		status = ps.executeUpdate();
   	}
   	catch (Exception e){
   		java.sql.PreparedStatement del_fav = con.prepareStatement("DELETE FROM favorites_t WHERE (tweet_ID,login_ID) in ((?, ?))"); //otherwise you want to delete it - remove it
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