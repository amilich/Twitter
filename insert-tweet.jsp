<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.mysql.jdbc.*" %>

<html>
<body>

<%
	String l_ID = request.getParameter("login_ID");
    String tweet_text = request.getParameter("text"); //suck in html ; store in java var
    String retweet_ID = request.getParameter("retweet_ID"); //retweet tweet ID

    /*out.println(l_ID); 
    out.println(tweet_text); 
    out.println(retweet_ID); */

	//tweet_text = tweet_text.replaceAll("&", "&amp;").replaceAll(">", "&gt;").replaceAll("<", "&#60;").replaceAll("<", "&#60;");
    //out.println("t:" + tweet_text); 
    if(tweet_text.length() > 0){
        try {       
            java.sql.Connection con = null;
            Class.forName("com.mysql.jdbc.Driver").newInstance();
            String url = "jdbc:mysql://127.0.0.1/amilich_twitter";   //location and name of database
            String userid = "amilich";
            String password = "amilich";
            boolean insert = true; 
            con = DriverManager.getConnection(url, userid, password);      //connect to database

             /*if(retweet_ID != null){ //only retweet something once
                //out.println("it is a retweet not a reg tweet");
                java.sql.PreparedStatement checkIfRetweeted = con.prepareStatement("SELECT a.retweet_ID,b.login_ID FROM retweets_t a,tweets_t b WHERE a.tweet_ID = ? AND a.tweet_ID = b.tweet_ID");
                checkIfRetweeted.setString(1, retweet_ID); 
                //checkIfRetweeted.setString(2, l_ID); 
                out.println(checkIfRetweeted); 
                java.sql.ResultSet checkRetweeted = checkIfRetweeted.executeQuery();  
                if(checkRetweeted.next()){
                    insert = false; 
                    //out.println("already retweeted it"); 
                    //out.println("delete-tweet.jsp?login_ID=" + l_ID + "&tweet_ID=" + checkRetweeted.getString(1) + "&retweet_ID=" + checkRetweeted.getString(1));
                    response.sendRedirect("delete-tweet.jsp?login_ID=" + l_ID + "&tweet_ID=" + checkRetweeted.getString(1) + "&retweet_ID=" + checkRetweeted.getString(1)); 
                }
            }*/
            if(insert){
                java.sql.PreparedStatement ps = con.prepareStatement("INSERT INTO tweets_t (text, login_ID, d_t) VALUES (?, " + l_ID + ", NOW()); ");
                int status = 0; 
                ps.setString (1, tweet_text);
                status = ps.executeUpdate();
    
                String[] split = tweet_text.split(" "); 
                int tweet_id = -1; 

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
			 			//out.println("not in table yet; adding"); 
			 			java.sql.PreparedStatement hash_add = con.prepareStatement("INSERT INTO hash_t (hash_tag) VALUES (?);");
			 			hash_add.setString(1, tag);
			 			status = hash_add.executeUpdate();
			 		}  
			 		
			 		//get the hash id
			 		String hash_id_q = "SELECT hash_id FROM hash_t where hash_tag = \"" + tag +"\";";
                		java.sql.Statement hash_id_s = con.createStatement();
			 		java.sql.ResultSet hash_id_set = hash_id_s.executeQuery(hash_id_q);
			 		int id_num = -1; 
			 		while(hash_id_set.next()){
			 			id_num = Integer.parseInt(hash_id_set.getString(1)); 
			 		}
    
			 		//ADD date checking to this 
			 		//String tweet_id_q = "SELECT tweet_id from tweets_t WHERE text = \"" + tweet_text + "\" AND login_ID = \"" + l_ID + "\";"; 
			 		String tweet_id_q = "SELECT tweet_id from tweets_t GROUP by tweet_ID;"; 
			 		java.sql.Statement tweet_id_s = con.createStatement();
			 		java.sql.ResultSet tweet_id_set = tweet_id_s.executeQuery(tweet_id_q);
			 		while(tweet_id_set.next()){
			 			tweet_id = Integer.parseInt(tweet_id_set.getString(1));
			 		}
			 		
			 		java.sql.PreparedStatement h_tweet_rel = con.prepareStatement("INSERT INTO hash_tweet_t (hash_id, tweet_id) VALUES (?, ?);");
			 		h_tweet_rel.setString(1, (id_num+"")); 
			 		h_tweet_rel.setString(2, (tweet_id+"")); 	
			 		status = h_tweet_rel.executeUpdate();
                        //out.println(h_tweet_rel); 
                	}
                }
                if(retweet_ID != null){
                    //out.println("doing retweet");
                    String retweet_l = "SELECT a.login_ID FROM login_t a, tweets_t b WHERE a.login_ID = b.login_ID AND b.tweet_ID = '" + retweet_ID +"';";
                    //out.println(retweet_l);
                    
                    java.sql.Statement retweet_l_s = con.createStatement();
                    java.sql.ResultSet retweet_l_set = retweet_l_s.executeQuery(retweet_l);
                    int retweeted_from_ID = -1; 
                    while(retweet_l_set.next()){
                        retweeted_from_ID = Integer.parseInt(retweet_l_set.getString(1));
                    }
                    //out.println(retweeted_from_ID); 
                    //out.println(retweet_l); 
			 	String tweet_id_q = "SELECT tweet_id from tweets_t GROUP by tweet_ID;"; 
			 	java.sql.Statement tweet_id_s = con.createStatement();
			 	java.sql.ResultSet tweet_id_set = tweet_id_s.executeQuery(tweet_id_q);
			 	while(tweet_id_set.next()){
			 		tweet_id = Integer.parseInt(tweet_id_set.getString(1));
			 	}
			 	
                    java.sql.PreparedStatement retweet_add = con.prepareStatement("INSERT INTO retweets_t (retweet_ID, tweet_ID, login_ID) VALUES (?, ?, ?)");
                    retweet_add.setString(1, ""+tweet_id);
                    retweet_add.setString(2, ""+retweet_ID);
                    retweet_add.setString(3, ""+retweeted_from_ID);
                    //out.println(retweet_add);
                    status = retweet_add.executeUpdate();
                    //out.println("is retweet!"); 
                }
                else {
                    //out.println("not retweet"); 
                }
            }
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
	//console.log("hi"); 
    window.location.href = document.referrer;
    //window.history.back();
    //window.location.href = "http://compsci.dalton.org:8080/amilich/twitter_dir/twitter-home.jsp?login_ID=<%=l_ID%>"; 
</script>

<h1> </h1>

</body>
</html> 