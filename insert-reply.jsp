<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.mysql.jdbc.*" %>

<html>
<body>

<%
	String l_ID = request.getParameter("login_ID");
    String reply_text = request.getParameter("text"); //suck in html ; store in java var
    String tweet_ID = request.getParameter("tweet_ID"); //retweet tweet ID

	//tweet_text = tweet_text.replaceAll("&", "&amp;").replaceAll(">", "&gt;").replaceAll("<", "&#60;").replaceAll("<", "&#60;");
    //out.println("t:" + tweet_text); 
    if(reply_text.length() > 0){
        try {       
            java.sql.Connection con = null;
            Class.forName("com.mysql.jdbc.Driver").newInstance();
            String url = "jdbc:mysql://127.0.0.1/amilich_twitter";   //location and name of database
            String userid = "amilich";
            String password = "amilich";
            con = DriverManager.getConnection(url, userid, password);      //connect to database
            java.sql.PreparedStatement ps = con.prepareStatement("INSERT INTO reply_t (text, tweet_ID, login_ID, d_t) VALUES (?, ?, ?, NOW()); ");
            int status = 0; 

            ps.setString (1, reply_text);
            ps.setString (2, tweet_ID);
            ps.setString (3, l_ID);
            status = ps.executeUpdate();

            String[] split = reply_text.split(" "); 
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