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
        Insert a tweet into the databse - deal with retweets, hashtags, tweet ID. 
    */

	String l_ID = request.getParameter("login_ID");
    String tweet_text = request.getParameter("text"); //suck in html ; store in java var
    String retweet_ID = request.getParameter("retweet_ID"); //retweet tweet ID

    if(tweet_text.length() > 0){
        try {       
            //get the username and password for database 
            Scanner sc = new Scanner(new FileReader("/home/amilich/public_html/twitter_dir/keys.txt"));
            String db_user = sc.nextLine(); 
            String db_password = sc.nextLine(); 
            String db_url = sc.nextLine(); 

            java.sql.Connection con = null;
            Class.forName("com.mysql.jdbc.Driver").newInstance();
            String url = db_url; 
            con = DriverManager.getConnection(url, db_user, db_user); //mysql id &  pwd
            boolean insert = true; 

            if(insert){
                java.sql.PreparedStatement ps = con.prepareStatement("INSERT INTO tweets_t (text, login_ID, d_t) VALUES (?, " + l_ID + ", NOW()); ");
                int status = 0; 
                ps.setString (1, tweet_text);
                status = ps.executeUpdate();
    
                String[] split = tweet_text.split(" "); //split it into words
                int tweet_id = -1; 

                //Deal with the hashtags, retweets, replies
                for(int ii = 0; ii < split.length; ii ++){
                	if(split[ii].substring(0, 1).equals("#")){
	               	  String tag = split[ii].substring(1); 
                	  String hash_q = "SELECT hash_id FROM hash_t where hash_tag = \"" + tag +"\";";
                	  java.sql.Statement hash_s = con.createStatement();
			 		  java.sql.ResultSet hash_set = hash_s.executeQuery(hash_q);
			 		  int count = 0; 
			 		  while(hash_set.next()){
			 		  	count ++; 
			 		  }
        
			 		  if(count == 0){
			 		  	java.sql.PreparedStatement hash_add = con.prepareStatement("INSERT INTO hash_t (hash_tag) VALUES (?);"); //put it into the hash table 
			 		  	hash_add.setString(1, tag);
			 		  	status = hash_add.executeUpdate();
			 		  }  
			 		  
			 		  //get the hash id
			 		  String hash_id_q = "SELECT hash_id FROM hash_t where hash_tag = \"" + tag +"\";"; //get the hash ID
                	  java.sql.Statement hash_id_s = con.createStatement();
			 		  java.sql.ResultSet hash_id_set = hash_id_s.executeQuery(hash_id_q);
			 		  int id_num = -1; 
			 		  while(hash_id_set.next()){
			 		  	id_num = Integer.parseInt(hash_id_set.getString(1)); 
			 		  }
        
			 		  //gets the newest tweet ID (the one that was just inserted )
			 		  String tweet_id_q = "SELECT tweet_id from tweets_t GROUP by tweet_ID;"; 
			 		  java.sql.Statement tweet_id_s = con.createStatement();
			 		  java.sql.ResultSet tweet_id_set = tweet_id_s.executeQuery(tweet_id_q);
			 		  while(tweet_id_set.next()){
			 		  	tweet_id = Integer.parseInt(tweet_id_set.getString(1)); //get tweet ID
			 		  }
			 		  
			 		  java.sql.PreparedStatement h_tweet_rel = con.prepareStatement("INSERT INTO hash_tweet_t (hash_id, tweet_id) VALUES (?, ?);"); //put it into the hash tweet table
			 		  h_tweet_rel.setString(1, (id_num+"")); 
			 		  h_tweet_rel.setString(2, (tweet_id+"")); 	
			 		  status = h_tweet_rel.executeUpdate();
                	}
                }
                if(retweet_ID != null){
                    String retweet_l = "SELECT a.login_ID FROM login_t a, tweets_t b WHERE a.login_ID = b.login_ID AND b.tweet_ID = '" + retweet_ID +"';"; //puts it into retweet table
                    java.sql.Statement retweet_l_s = con.createStatement();
                    java.sql.ResultSet retweet_l_set = retweet_l_s.executeQuery(retweet_l);
                    int retweeted_from_ID = -1; 
                    while(retweet_l_set.next()){
                        retweeted_from_ID = Integer.parseInt(retweet_l_set.getString(1));
                    }
			 	    String tweet_id_q = "SELECT tweet_id from tweets_t GROUP by tweet_ID;"; 
			 	    java.sql.Statement tweet_id_s = con.createStatement();
			 	    java.sql.ResultSet tweet_id_set = tweet_id_s.executeQuery(tweet_id_q);
			 	    while(tweet_id_set.next()){
			 		    tweet_id = Integer.parseInt(tweet_id_set.getString(1));
			 	    }
			 	
                    java.sql.PreparedStatement retweet_add = con.prepareStatement("INSERT INTO retweets_t (retweet_ID, tweet_ID, login_ID) VALUES (?, ?, ?)"); //has the ID of the tweet you retweeted
                    retweet_add.setString(1, ""+tweet_id);
                    retweet_add.setString(2, ""+retweet_ID);
                    retweet_add.setString(3, ""+retweeted_from_ID);
                    status = retweet_add.executeUpdate();
                }
                else {
                    //nothing to do if else 
                }
            }
        }
        catch (Exception e){
            out.println(e); 
        }
    }
    else {
    }
%>

<script language="javascript">
    window.location.href = document.referrer; //use this instead of redirect - reloads the page 
</script>

<h1> </h1>

</body>
</html> 