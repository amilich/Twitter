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

<!doctype html>

<%
  Scanner sc = new Scanner(new FileReader("/home/amilich/public_html/twitter_dir/keys.txt"));
  String db_user = sc.nextLine(); 
  String db_password = sc.nextLine(); 
  String db_url = sc.nextLine(); 
  String l_ID = request.getParameter("login_ID");
	String v_ID = request.getParameter("view_ID");
	String image_URL = ""; 
	String image_URL_v = ""; 

	try {
		String session_l_ID = (String)session.getAttribute("login_ID");
		if(Integer.parseInt(session_l_ID) != Integer.parseInt(l_ID)){
			response.sendRedirect("twitter-signin.jsp"); 
		}
	}
	catch(Exception e){
			response.sendRedirect("twitter-signin.jsp"); 
	}

    try {
      int tweet_count = 0;
    	int follower_count = 0; 
    	int following_count = 0; 
    	
    	//page you're viewing 
    	int tweet_count_v = 0;
    	int follower_count_v = 0; 
    	int following_count_v = 0; 
    	
    	String username = "";
    	String first_name = ""; 
    	String last_name = "";
    	
    	//page you're viewing
    	String username_v = "";
    	String first_name_v = ""; 
    	String last_name_v = ""; 
    	String description = ""; 
		  //sql query:
    	
    	String url = "";
    	String tweet_count_q = "SELECT COUNT(b.tweet_ID) FROM login_t a,tweets_t b WHERE b.login_ID=a.login_ID and a.login_ID=" + l_ID +";"; //get all rows int he student database
    	String follower_count_q = "SELECT COUNT(b.follower_ID) AS num_following_you FROM login_t a, following_t b WHERE a.login_ID = b.followed_ID AND a.login_ID=" + l_ID + ";"; 
		  String following_count_q = "SELECT COUNT(b.follower_ID) AS num_following FROM login_t a, following_t b WHERE a.login_ID = b.follower_ID AND a.login_ID=" + l_ID + ";";
		  String username_q = "SELECT username,first_name,last_name from login_t WHERE login_ID=" + l_ID + ";"; 
		  String image_q = "SELECT pic_link FROM login_t where login_ID = " + l_ID+";";
  
		  String tweet_count_q_v = "SELECT COUNT(b.tweet_ID) FROM login_t a,tweets_t b WHERE b.login_ID=a.login_ID and a.login_ID=" + v_ID +";"; //get all rows int he student database
      String follower_count_q_v = "SELECT COUNT(b.follower_ID) AS num_following_you FROM login_t a, following_t b WHERE a.login_ID = b.followed_ID AND a.login_ID=" + v_ID + ";"; 
		  String following_count_q_v = "SELECT COUNT(b.follower_ID) AS num_following FROM login_t a, following_t b WHERE a.login_ID = b.follower_ID AND a.login_ID=" + v_ID + ";";
		  String username_q_v = "SELECT username,first_name,last_name,pic_link,description from login_t WHERE login_ID=" + v_ID + ";"; 
		  
		  String tweet_q = "SELECT text, d_t, login_ID FROM tweets_t WHERE login_ID = " + v_ID + " GROUP BY d_t DESC;";
	 
      	//open sql:
      java.sql.Connection con = null;
      Class.forName("com.mysql.jdbc.Driver").newInstance();
      url = db_url; 
      con = DriverManager.getConnection(url, db_user, db_user); //mysql id &  pwd
    	
    	//your statements
    	java.sql.Statement tweet_count_s = con.createStatement();
      java.sql.Statement follower_count_s = con.createStatement();
      java.sql.Statement following_count_s = con.createStatement();
      java.sql.Statement username_s = con.createStatement();
      java.sql.Statement image_s = con.createStatement();
              
      String my_tweets_q = "SELECT text, d_t, login_ID FROM tweets_t WHERE login_ID = " + l_ID + " GROUP BY d_t;";
		  String followers_q = "SELECT a.first_name, a.last_name, a.login_ID FROM login_t a, following_t b WHERE b.follower_ID = a.login_ID AND b.followed_ID=" + l_ID + ";";
		  String my_following_q = "SELECT a.first_name, a.last_name, a.login_ID FROM login_t a, following_t b WHERE b.followed_ID = a.login_ID AND b.follower_ID=" + l_ID + ";";
		  java.sql.Statement followers_s = con.createStatement();
		  java.sql.Statement my_tweets_s = con.createStatement();
		  java.sql.Statement my_following_s = con.createStatement();
		  java.sql.ResultSet my_followers = followers_s.executeQuery(followers_q);
		  java.sql.ResultSet my_tweets = my_tweets_s.executeQuery(my_tweets_q);
		  java.sql.ResultSet my_following = my_following_s.executeQuery(my_following_q);
      
      //view page statements
      java.sql.Statement tweet_count_s_v = con.createStatement();
      java.sql.Statement follower_count_s_v = con.createStatement();
      java.sql.Statement following_count_s_v = con.createStatement();
      java.sql.Statement username_s_v = con.createStatement();
      
      java.sql.Statement tweet_s = con.createStatement();

    	//executes the query:
    	//result sets for you
    	java.sql.ResultSet rs1 = tweet_count_s.executeQuery(tweet_count_q);
    	java.sql.ResultSet rs2 = follower_count_s.executeQuery(follower_count_q);
    	java.sql.ResultSet rs3 = following_count_s.executeQuery(following_count_q);
    	java.sql.ResultSet rs4 = username_s.executeQuery(username_q);

    	//result set for page 
    	java.sql.ResultSet rs5 = tweet_count_s_v.executeQuery(tweet_count_q_v);
    	java.sql.ResultSet rs6 = follower_count_s_v.executeQuery(follower_count_q_v);
    	java.sql.ResultSet rs7 = following_count_s_v.executeQuery(following_count_q_v);
    	java.sql.ResultSet rs8 = username_s_v.executeQuery(username_q_v);
    	
    	java.sql.ResultSet tweets = tweet_s.executeQuery(tweet_q);
    	java.sql.ResultSet img = image_s.executeQuery(image_q);

    	//loop through result set until there is not a next:
    	while(rs1.next()) {
    		tweet_count = Integer.parseInt(rs1.getString(1));
        } //end while
         
        while(rs2.next()) {
    		follower_count = Integer.parseInt(rs2.getString(1));
        } //end while
        
        while(rs3.next()) {
    		following_count = Integer.parseInt(rs3.getString(1));
        } //end while
        
        while(rs4.next()) {
    		username = rs4.getString(1);
    		first_name = rs4.getString(2); 
    		last_name = rs4.getString(3); 
        } //end while
        
        while(rs5.next()) {
    		tweet_count_v = Integer.parseInt(rs5.getString(1));
        } //end while
         
        while(rs6.next()) {
    		follower_count_v = Integer.parseInt(rs6.getString(1));
        } //end while
        
        while(rs7.next()) {
    		following_count_v = Integer.parseInt(rs7.getString(1));
        } //end while
        
        while(rs8.next()) {
    		username_v = rs8.getString(1);
    		first_name_v = rs8.getString(2); 
    		last_name_v = rs8.getString(3); 
    		image_URL_v = rs8.getString(4); 
    		description = rs8.getString(5); 
        } //end while
        
        while(img.next()) {
    		image_URL = img.getString(1); 
        } //end while
%>

<script>	
	//setCookie("login_ID", "5", 1); 
	
	function setCookie(cname, cvalue, exdays) {
	   	var d = new Date();
	   	d.setTime(d.getTime() + (exdays*24*60*60*1000));
	   	var expires = "expires="+d.toUTCString();
	   	document.cookie = cname + "=" + cvalue + "; " + expires + "; path=/";
	}
	
	function getCookie(cname) {
	    var name = cname + "=";
	   	var ca = document.cookie.split(';');
	   	for(var i=0; i<ca.length; i++) {
	       	var c = ca[i];
	       	while (c.charAt(0)==' ') c = c.substring(1);
	       	if (c.indexOf(name) != -1) return c.substring(name.length, c.length);
	   	}
	   	return "";
	}
	
	function checkCookie() {
		//document.write("CHECKING   "); 
	   	var user = getCookie("login_ID");
		//document.write("DONE CHECKING \n");	
	   	//document.write(user); 
	   	if (user == "<%=l_ID%>") {
	   		//document.write("NOT LOGGED IN"); 
	   		return; 
	   	} 
	   	else {
	   		//document.write(document.cookie); 
	   		//document.write("<%=l_ID%> is logged in!"); 
	       	window.location = "http://compsci.dalton.org:8080/amilich/twitter_dir/twitter-signin.jsp";
	   	}
	}
</script>

<html lang="en">
	<font face="arial">

<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title></title>
    <meta name="description" content="">
    <meta name="author" content="">
    <style type="text/css">
        body {
            padding-top: 60px;
            padding-bottom: 40px;
        }
        .sidebar-nav {
            padding: 9px 0;
        }
    </style>    
  <link rel="stylesheet" href="css/gordy_bootstrap.min.css">
	<link href="css/bootstrap.min.css" rel="stylesheet">
	<link href="css/styles.css" rel="stylesheet">
  <link href="css/hidden.css" rel="stylesheet">
  <script src="lib/sweet-alert.min.js"></script> 
  <link rel="stylesheet" type="text/css" href="lib/sweet-alert.css">
</head>
<body class="user-style-theme1" onload="">
   <nav class="navbar navbar-fixed-top navbar-default" role="navigation">
			<div class="container-fluid">
				<!-- Collect the nav links, forms, and other content for toggling -->
				<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
					<ul class="nav navbar-nav">
						<li><a href="twitter-home.jsp?login_ID=<%=l_ID%>">Home <span class="sr-only">(current)</span></a></li>
						<li><a href="twitter-trending.jsp?login_ID=<%=l_ID%>">#Dicsover</a></li>
            <li><a href="twitter-find.jsp?login_ID=<%=l_ID%>">Find Friends</a></li>
						<li><a href="twitter-settings.jsp?login_ID=<%=l_ID%>">Settings</a></li>
						<li><a href="logout.jsp">Logout</a></li>
						<!-- TERRIBLE SOLUTION -->
					</ul>
					<a class="navbar-brand" rel="home" href="#">
        			<img style="max-width:25px; margin-top: -7px; float:center;"
            		 src="images/logo.png">
    				</a>
					<ul class="nav navbar-nav navbar-right">
						<form class="navbar-form navbar-left" action="insert-tweet.jsp" method="get">
        					<div class="form-group">
								<textarea rows="4" class="tweet-box" name="text" placeholder="Compose new Tweet..." id="tweet-box-mini-home-profile"></textarea>
        					</div>
							<input type="submit" class="btn btn-small btn-primary" value="Tweet">
							<input type="hidden" class="tweet-box" name="login_ID" value="<%=l_ID%>" id="tweet-box-mini-home-profile">
      					</form>
					</ul>
				</div>
				<!-- /.navbar-collapse -->
			</div>
			<!-- /.container-fluid -->
	</nav>
	<br>
    <div class="container wrap">
        <div class="row">

            <!-- left column -->
            <div class="span4" id="secondary">
                <div class="module mini-profile">
                    <div class="content">
                        <div class="account-group">
                            <a href="twitter-following.jsp?login_ID=<%=l_ID%>&view_ID=<%=l_ID%>"> <!-- already on your profile page -->
                                <img class="avatar size32" src="<%=image_URL%>" alt="Gordy">
                                <b class="fullname"><%=first_name%></b>
                                <small class="metadata">View my profile page</small>
                            </a>
                        </div>
                    </div>
                   
                   <div class="container">
							<div class="row">
								<div class="upper" style="border-top: 1px solid #E8E8E8; width: 275px;">
  									<div class="col-md-1" style="width: 75px; height: 65px;">
										<p>
  									  	<!--<a href="twitter-following.jsp?login_ID=<%=l_ID%>&view_ID=<%=l_ID%>"><strong><%=tweet_count%></strong><font color="000000"><br><br>Tweets</font></a>-->
  									  	<div>
  											<button class="btn btn-link btn-xs dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown" aria-expanded="true">
    											<font size="1" color="4D4D4D"><b>TWEETS</b></font>
  											</button>
  											<!--<ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu1">
    											<div class="jumbotron" style="min-width:350px; background-color: white;">
    												<a href="twitter-following.jsp?login_ID=<%=l_ID%>&view_ID=<%=l_ID%>"><font size="4" color="4D4D4D"><b>Tweets</b></font></a>
    												<br><br>
  													<% int ii = 1; 
  													while(my_tweets.next()){%>
  													<font color="000000"><%=ii + ") " + my_tweets.getString(1).replaceAll("&", "&amp;").replaceAll(">", "&gt;").replaceAll("<", "&#60;") + "\n" %></font>
  													<br>
  													<%ii++; 
  													}%>
  													<% 
  													if(ii == 1){
  														out.println("You have no tweets :(");
  													}
  													%>
												</div>
												</li>
  											</ul>-->
  										</div>
  										</p>
  										<b><center><font color="000000" size="4"><%=tweet_count%></font></center></b>
  									</div>
  								
  									<div class="col-md-1" style="width: 95px; height: 65px; border-left: 1px solid #e8e8e8;">
										<p>
  									  	<!--<a href="twitter-following.jsp?login_ID=<%=l_ID%>&view_ID=<%=l_ID%>"><strong><%=tweet_count%></strong><font color="000000"><br><br>Tweets</font></a>-->
  									  	<div>
  											<button class="btn btn-link btn-xs dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown" aria-expanded="true">
    											<font size="1" color="4D4D4D"><b>FOLLOWING</b></font>
  											</button>
  											<ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu1">
    											<div class="jumbotron" style="min-width:350px; background-color: white;">
    												<a href="twitter-home.jsp?login_ID=<%=l_ID%>"><font size="4" color="4D4D4D"><b>FOLLOWING</b></font></a>
    												<br><br>
  													<% ii = 1; 
  													while(my_following.next()){%>
  													<font color="000000"><%=ii + ") " + my_following.getString(1) + " " +  my_following.getString(2) + "\n" %></font>
  													<br>
  													<%ii++; 
  													}%>
  													<% 
  													if(ii == 1){
  														out.println("You aren't following anyone :(");
  													}
  													%>
												</div>
												</li>
  											</ul>
  										</div>
  										</p>
  										<b><center><font color="000000" size="4"><%=following_count%></font></center></b>
  									</div>
  								
  									<div class="col-md-1" style="width: 80px; height: 65px; border-left: 1px solid #e8e8e8;">
										<p>
  									  	<!--<a href="twitter-following.jsp?login_ID=<%=l_ID%>&view_ID=<%=l_ID%>"><strong><%=tweet_count%></strong><font color="000000"><br><br>Tweets</font></a>-->
  									  	<div>
  											<button class="btn btn-link btn-xs dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown" aria-expanded="true">
    											<a href="twitter-followers.jsp?login_ID=<%=l_ID%>"><font size="1" color="4D4D4D"><b>FOLLOWERS</b></font></a>
  											</button>
  											<ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu1">
    											<div class="jumbotron" style="min-width:350px; background-color: white;">
    												<a href="twitter-followers.jsp?login_ID=<%=l_ID%>"><font size="4" color="4D4D4D"><b>Followers</b></font></a>
    												<br><br>
  													<% ii = 1; 
  													while(my_followers.next()){%>
  													<font color="000000"><%=ii + ") " + my_followers.getString(1) + " " +  my_followers.getString(2) + "\n" %></font>
  													<!--<a href="#" class="btn btn-default btn-xs" role="button">Follow</a>-->
  													<br>
  													<%ii++; 
  													}%>
  													<% 
  													if(ii == 1){
  														out.println("You have no followers :(");
  													}
  													%>
												</div>
												</li>
  											</ul>
  										</div>
  										</p>
  										<b><center><font color="000000" size="4"><%=follower_count%></font></center></b>
  									</div>
  								</div>
  								<br><br><br><br>
  								<div class="upper" style="border-top: 1px solid #E8E8E8; width: 275px;"></div>
							</div>
						</div>        
                    
                    <!-- 
                    	BUG: 
                    	THIS SENDS YOU BACK TO THE HOME 
                    	
                    	11/24/14: Fixed (history.back())
                	-->
                </div>

                <div class="module other-side-content">
                    <div class="content"
						<p>Currently Trending</p>
						
						<%
						String trend_q = "SELECT a.hash_tag,a.hash_ID, COUNT(*) as count FROM hash_t a, hash_tweet_t b WHERE a.hash_ID = b.hash_ID GROUP BY hash_tag ORDER BY count DESC;";
            			java.sql.Statement trend_s = con.createStatement();
						java.sql.ResultSet trend_set = trend_s.executeQuery(trend_q);
						int counter = 0; 
						while(trend_set.next() && counter < 5){
							String trend = trend_set.getString(1); 
							trend = trend.replaceAll("&", "&amp;").replaceAll(">", "&gt;").replaceAll("<", "&#60;").replaceAll("!", "&#33;");
							%><a href="hash-list.jsp?login_ID=<%=l_ID%>&hash_ID=<%=trend_set.getString(2)%>&hash_text=<%=trend_set.getString(1)%>">#<%=trend + " "%></a><%
							%><br><%
							counter ++; 
						}%>
                    </div>
                </div>
            </div>

             <!-- right column -->
            <div class="span8 content-main">
                <div class="module">
                    <div class="content">
                        <div class="profile-header-inner" data-background-image="url('images/grey-header-web.png')">
                            <a href="#" class="profile-picture media-thumbnail">
                                <img src="<%=image_URL_v%>" alt="Barack Obama" class="avatar size73" style="max-height: 75px" height="75px" width="75px">
                            </a>
                            <div class="profile-card-inner">
                                <h1 class="fullname"><%out.println(first_name_v + " " + last_name_v);%></h1>
                                <h2 class="username">@<%=username_v%></h2>
                                <div class="bio-container">
                                	<br>
                                	<%
										description = description.replaceAll("&", "&amp;").replaceAll(">", "&gt;").replaceAll("<", "&#60;").replaceAll("!", "&#33;").replaceAll("!", "&#33;");
                                	%>
                                    <p class="bio profile-field"><%=description%></p>
                                </div>
                            </div>
                        </div>
                        <div class="flex-module profile-banner-footer clearfix">
                            <div class="default-footer">
                                <ul class="stats js-mini-profile-stats" style="float:left">
                                    <li>
                                        <a class="js-nav" href="#">
                                            <strong><%=tweet_count_v%></strong>
                                            Tweets
                                        </a>
                                    </li>
                                    <li>
                                        <a class="js-nav" href="#">
                                            <strong><%=following_count_v%></strong>
                                            Following
                                        </a>
                                    </li>
                                    <li>
                                        <a class="js-nav" href="#">
                                            <strong><%=follower_count_v%></strong>
                                            Followers
                                        </a>
                                    </li>
                                </ul>
                                
                                <!-- FINISH THIS - new direct messages -->
                                <script>
                                  function runAlert(){
                                    swal({   title: "Error!",   text: "Not yet implemented!",   type: "error",   confirmButtonText: "Bye" });
                                  }
                                </script>

                                <a href="#dm" onclick="runAlert();" class="btn dm-button pull-right" type="button" title"Direct Messages">
                                    <i class="icon-envelope"></i>
                                </a>
                                <div id="dm" class="modal hide fade">
                                    <div class="modal-header twttr-dialog-header">
                                        <div class="twttr-dialog-close" data-dismiss="modal" aria-hidden="true">&nbsp;</div>
                                        <h3>Direct Messages</h3>
                                    </div>
                                    <div class="modal-body">
                                        <!-- direct messages start -->
                                        <!-- start tweet -->
                                        <div class="js-stream-item stream-item expanding-string-item">
                                            <div class="tweet original-tweet">
                                                <div class="content">
                                                    <div class="stream-item-header">
                                                        <small class="time">
                                                            <a href="#" class="tweet-timestamp" title="10:15am - 16 Nov 12">
                                                                <span class="_timestamp">6m</span>
                                                            </a>
                                                        </small>
                                                        <a class="account-group">
                                                            <img class="avatar" src="images/obama.png" alt="Barak Obama">
                                                            <strong class="fullname">Barak Obama</strong>
                                                            <span>&rlm;</span>
                                                            <span class="username">
                                                                <s>@</s>
                                                                <b>barakobama</b>
                                                            </span>
                                                        </a>
                                                    </div>
                                                    <p class="js-tweet-text">
                                                        "I've got a mandate to help middle-class families." -President Obama at his news conference yesterday: "
                                                        <a href="http://t.co/xOqdhPgH" class="twitter-timeline-link" target="_blank" title="http://OFA.BO/xRSG9n" dir="ltr">
                                                            <span class="invisible">http://</span>
                                                            <span class="js-display-url">OFA.BO/xRSG9n</span>
                                                            <span class="invisible"></span>
                                                            <span class="tco-ellipsis">
                                                                <span class="invisible">&nbsp;</span>
                                                            </span>
                                                        </a>
                                                    </p>
                                                </div>
                                                <div class="expanded-content js-tweet-details-dropdown"></div>
                                            </div>
                                        </div>
                                        <!-- end tweet -->

                                        <!-- direct messages end -->
                                    </div>
                                    <div class="twttr-dialog-footer">
                                        Tip: you can send a message to anyone who follows you. <a href="#" target="_blank" class="learn-more">Learn more</a>
                                  </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="module">
                    <div class="content-header">
                        <div class="header-inner">
                            <h2 class="js-timeline-title">Tweets</h2>
                        </div>
                    </div>

                    <!-- new tweets alert -->
                    <div class="stream-item hidden">
                        <div class="new-tweets-bar js-new-tweets-bar well">
                            2 new Tweets
                        </div>
                    </div>
					<% while(tweets.next()){ %>
                    <!-- all tweets -->
                    <div class="stream following-stream">
                        <!-- start tweet -->
                        <div class="js-stream-item stream-item expanding-string-item">
                            <div class="tweet original-tweet">
                                <div class="user-actions">
                                	<div class="dropdown">
  										<button class="btn btn-default btn-xs dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown" aria-expanded="true">
    											<!-- Follow or unfollow -->
    											<span class="caret"></span>
  										</button>
  										<ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu1">
											<li><a href="insert-follower.jsp?follower_ID=<%=l_ID%>&followed_ID=<%=tweets.getString(3)%>">Follow</a></li>
											<li><a href="remove-follower.jsp?follower_ID=<%=l_ID%>&followed_ID=<%=tweets.getString(3)%>">Unfollow</a></li>
  										</ul>
									</div>
                          		</div>
                                <div class="content">
                                    <div class="stream-item-header">
                                        <a href="twitter-following.jsp?login_ID=<%=l_ID%>&view_ID=<%=tweets.getString(3)%>" class="account-group">
                                            <img class="avatar" src="<%=image_URL_v%>" alt="Barak Obama">
                                            <strong class="fullname"><%=first_name_v + " " + last_name_v%></strong>
                                            <span>&rlm;</span>
                                            <span class="username">
                                                <s>@</s>
                                                <b><%=username_v%></b>
                                            </span>
                                        </a>
                                    </div>
                                    <p class="js-tweet-text">
                                       <%
										                    //underline the hashtags 
										                    String tweet_text = tweets.getString(1); 
										                    String[] text_split = tweet_text.split(" "); 
										                    for(int jj = 0; jj < text_split.length; jj ++){
										                    	text_split[jj] = text_split[jj].replaceAll("&", "&amp;").replaceAll(">", "&gt;").replaceAll("<", "&#60;");
										                    	//out.println("replaced"); 
										                    }
										                    int status = 0; 
										                    //out.println("before for"); 
										                    for(int jj = 0; jj < text_split.length; jj ++){
										                    	if(text_split[jj].contains("#") && !text_split[jj].contains("&#60")){
	            			                    					String tag = text_split[jj].substring(1); 
            				                    					String hash_q = "SELECT hash_id FROM hash_t where hash_tag = \"" + tag +"\";";
            				                    					java.sql.Statement hash_s = con.createStatement();
										                    		java.sql.ResultSet hash_set = hash_s.executeQuery(hash_q);
										                    		int count = 0; 
										                    		int tag_num = -1; 
										                    		while(hash_set.next()){
										                    			count ++; 
										                    			tag_num = Integer.parseInt(hash_set.getString(1)); 
										                    		}
										                    		
										                    		if(count != 0){
										                    			%><a href="hash-list.jsp?login_ID=<%=l_ID%>&hash_ID=<%=tag_num%>&hash_text=<%=tag%>"><%=text_split[jj]%></a><%out.println(" "); 
										                    		}
										                    	}
										                    	else if (text_split[jj].contains("@")) {
										                    		String tag = text_split[jj].substring(1); 
										                    		String tag_q = "SELECT login_ID FROM login_t where username = \"" + tag +"\";";
										                    		java.sql.Statement tag_s = con.createStatement();
										                    		java.sql.ResultSet tag_set = tag_s.executeQuery(tag_q);
										                    		int count = 0; 
										                    		int tag_num = -1; 
										                    		while(tag_set.next()){
										                    			count ++; 
										                    			tag_num = Integer.parseInt(tag_set.getString(1)); 
										                    		}
										                    		if(tag_num > 0){
										                    			%><a href="twitter-following.jsp?login_ID=<%=l_ID%>&view_ID=<%=tag_num%>"><%=text_split[jj]%></a><%
											   							out.println(" "); 
										                    		}
										                    		else {
										                    			out.print(text_split[jj] + " "); 
										                    		}
										                    	}
										                    	else {
										                    		//why
										                    		//out.println("print"); 
										                    		out.print(text_split[jj] + " "); 
										                    	}
										                    }
										                    %>
                                    </p>
                                </div>
                            </a>
                                <div class="expanded-content js-tweet-details-dropdown"></div>
                            </div>
                        </div><!-- end tweet -->
                    <%} %> 
                    </div>
                    <div class="stream-footer"></div>
                    <div class="hidden-replies-container"></div>
                    <div class="stream-autoplay-marker"></div>
                </div>
                </div>
               
            </div>
        </div>
    </div>
     <!-- Le javascript
    ================================================== -->
    <!-- Placed at the end of the document so the pages load faster -->
     <script type="text/javascript" src="js/main-ck.js"></script>
  </body>
  </font>
</html>

<%
	} catch (Exception e) {
    	out.println(e);
    }
%>