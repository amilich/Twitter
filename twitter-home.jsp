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

	//out.println(session.getAttribute( "login_ID" )); 
	//there is a session variable, but using a cookie makes this unnecessary 
	String l_ID = request.getParameter("login_ID");
	ArrayList<Integer> people_following = new ArrayList<Integer>();

	try {
		String session_l_ID = (String)session.getAttribute("login_ID");
		//out.println(session_l_ID);
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
		String username = "";
		String first_name = ""; 
		String last_name = ""; 
		String image_URL = ""; 
		//sql query:
		
		String url = "";
		String tweet_count_q = "SELECT COUNT(b.tweet_ID) FROM login_t a,tweets_t b WHERE b.login_ID=a.login_ID and a.login_ID=" + l_ID +";"; //get all rows int he student database
		String follower_count_q = "SELECT COUNT(b.follower_ID) AS num_following_you FROM login_t a, following_t b WHERE a.login_ID = b.followed_ID AND a.login_ID=" + l_ID + ";"; 
		String following_count_q = "SELECT COUNT(b.follower_ID) AS num_following FROM login_t a, following_t b WHERE a.login_ID = b.follower_ID AND a.login_ID=" + l_ID + ";";
		String username_q = "SELECT username,first_name,last_name from login_t WHERE login_ID=" + l_ID + ";"; 
		String tweet_q = "SELECT a.text,a.d_t,a.login_ID,d.username,d.first_name,d.last_name,d.pic_link,a.tweet_ID FROM tweets_t a,following_t b,login_t c, login_t d WHERE d.login_ID = a.login_ID AND ((a.login_ID=c.login_ID) OR (a.login_ID=b.followed_ID AND b.follower_ID=c.login_ID)) AND c.login_ID = " + l_ID + " GROUP BY a.d_t DESC;";
		String image_q = "SELECT pic_link FROM login_t where login_ID = " + l_ID+";";
	
		//open sql:
		java.sql.Connection con = null;
		Class.forName("com.mysql.jdbc.Driver").newInstance();
		url = db_url; 
		con = DriverManager.getConnection(url, db_user, db_user); //mysql id &  pwd
		
		String my_tweets_q = "SELECT text, d_t, login_ID FROM tweets_t WHERE login_ID = " + l_ID + " GROUP BY d_t;";
		String followers_q = "SELECT a.first_name, a.last_name, a.login_ID FROM login_t a, following_t b WHERE b.follower_ID = a.login_ID AND b.followed_ID=" + l_ID + ";";
		String my_following_q = "SELECT a.first_name, a.last_name, a.login_ID FROM login_t a, following_t b WHERE b.followed_ID = a.login_ID AND b.follower_ID=" + l_ID + ";";
		java.sql.Statement followers_s = con.createStatement();
		java.sql.Statement my_tweets_s = con.createStatement();
		java.sql.Statement my_following_s = con.createStatement();
		java.sql.ResultSet my_followers = followers_s.executeQuery(followers_q);
		java.sql.ResultSet my_tweets = my_tweets_s.executeQuery(my_tweets_q);
		java.sql.ResultSet my_following = my_following_s.executeQuery(my_following_q);
		
		//collect all login IDs		
		ArrayList<Integer> login_IDs = new ArrayList<Integer>();
		String login_ID_q = "SELECT login_ID from login_t GROUP by login_ID;"; 
		java.sql.Statement login_ID_s = con.createStatement();
		java.sql.ResultSet login_ID_set = login_ID_s.executeQuery(login_ID_q);

		java.sql.Statement tweet_count_s = con.createStatement();
	    java.sql.Statement follower_count_s = con.createStatement();
	    java.sql.Statement following_count_s = con.createStatement();
	    java.sql.Statement username_s = con.createStatement();
	    java.sql.Statement tweet_s = con.createStatement();
	    java.sql.Statement image_s = con.createStatement();
	
		//executes the query:
		java.sql.ResultSet rs1 = tweet_count_s.executeQuery(tweet_count_q);
		java.sql.ResultSet rs2 = follower_count_s.executeQuery(follower_count_q);
		java.sql.ResultSet rs3 = following_count_s.executeQuery(following_count_q);
		java.sql.ResultSet rs4 = username_s.executeQuery(username_q);
		java.sql.ResultSet rs5 = image_s.executeQuery(image_q);
		java.sql.ResultSet tweets = tweet_s.executeQuery(tweet_q);
	
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
			image_URL = rs5.getString(1); 
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
	   	} 
	   	else {
	   		//document.write(document.cookie); 
	   		//document.write("<%=l_ID%> is logged in!"); 
	       	window.location = "http://compsci.dalton.org:8080/amilich/twitter_dir/twitter-signin.jsp";
	   	}
	   	
		console.log(s_id); //log the id from session variables 
		if (s_id == "<%=l_ID%>") {
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
		<script type="text/javascript" src="livevalidation_standalone.compressed.js"></script>

	</head>
	<body class="user-style-theme1" onload="">
		<nav class="navbar navbar-fixed-top navbar-default" role="navigation">
			<div class="container-fluid">
				<!-- Collect the nav links, forms, and other content for toggling -->
				<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
					<ul class="nav navbar-nav">
						<li class="active"><a href="">Home <span class="sr-only">(current)</span></a></li>
						<li><a href="twitter-trending.jsp?login_ID=<%=l_ID%>">#discover</a></li>
						<li><a href="twitter-settings.jsp?login_ID=<%=l_ID%>">Settings</a></li>
						<li><a href="logout.jsp">Logout</a></li>
						<!-- TERRIBLE SOLUTION -->
					</ul>
					<a class="navbar-brand" href="#"><img style="max-width:25px; margin-top: -7px;"
						src="images/logo.png"></a>
					<!--<a class="navbar-brand navbar-brand-centered" href="#">
        			<img style="max-width:25px; margin-top: -7px; float:center;"
            		 src="images/logo.png">
    				</a>-->
					<ul class="nav navbar-nav navbar-right">
      					<li><a href="#">Logged in as <%=first_name + " " + last_name%></a></li>
					</ul>
				</div>
				<!-- /.navbar-collapse -->
			</div>
			<!-- /.container-fluid -->
		</nav>
		<br>
		<div class="container wrap"><!-- not container wrap -->
			<div class="row">
				<!-- left column -->
				<div class="span4" id="secondary"><!-- not id="secondary" -->
					<div class="module mini-profile">
						<div class="content">
							<div class="account-group">
								<a href="twitter-following.jsp?login_ID=<%=l_ID%>&view_ID=<%=l_ID%>">
								<img class="avatar size32" src="<%=image_URL%>" alt="Gordy">
								<b class="fullname"><%=first_name%></b>
								<small class="metadata">View my profile page</small>
								</a>
							</div>
						</div>
						
						<div class="container">
							<div class="row">
								<div class="upper" style="border-top: 1px solid #E8E8E8; width: 275px;">
  									<div class="col-md-1" style="width: 75px; height: 65px; padding-left: 10px;">
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
  								
  									<div class="col-md-1" style="width: 95px; height: 65px; border-left: 1px solid #e8e8e8; padding-left: 10px;">
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
  													while(my_following.next()){
  														people_following.add(Integer.parseInt(my_following.getString(3))); 
  													%>
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
  								
  									<div class="col-md-1" style="width: 80px; height: 65px; border-left: 1px solid #e8e8e8; padding-left: 10px;">
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
  													<% int follower_num = 1; 
  													while(my_followers.next()){%>
  													<font color="000000"><%=follower_num + ") " + my_followers.getString(1) + " " +  my_followers.getString(2) + "\n" %></font>
  													<!--<a href="#" class="btn btn-default btn-xs" role="button">Follow</a>-->
  													<br>
  													<%follower_num++; 
  													}%>
  													<% 
  													if(follower_num == 1){
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
                            	<!--<div class="dropdown">
  								<button class="btn btn-default dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown" aria-expanded="true">
    								Tweets
    								<span class="caret"></span>
  								</button>
  								<ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu1">
    								<div class="jumbotron">
  										<h1>Hello, world!</h1>
  										<p>...</p>
 										<p><a class="btn btn-primary btn-lg" href="#" role="button">Learn more</a></p>
									</div>
									</li>
  								</ul>
  								</div>-->
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
							trend = trend.replaceAll("&", "&amp;").replaceAll(">", "&gt;").replaceAll("<", "&#60;").replaceAll("!", "&#33;").replaceAll("!", "&#33;");
							%><a href="hash-list.jsp?login_ID=<%=l_ID%>&hash_ID=<%=trend_set.getString(2)%>&hash_text=<%=trend_set.getString(1)%>">#<%=trend + " "%></a><%
							%><br><%
							counter ++; 
						}%>
						<br>
						<small><a href="twitter-terms.jsp">Terms</a></small>
					</div>
				</div>
			</div>
			<!-- right column -->
			
			<%
			//out.println("F: " + (following_count)); 
			if(following_count < 5){ //you don't have a ton of people you're following 
			while(login_ID_set.next()){
				login_IDs.add(Integer.parseInt(login_ID_set.getString(1))); 
			}
			
			%>
				<div class="span8 content-main">
					<div class="module">
						<div class="content-header">
							<div class="header-inner">
								<h2 class="js-timeline-title">Here are some people you might enjoy following.</h2>
							</div>
						</div>
						<br>
						<div class="container" style="max-height:110px; vertical-align:top;">
 							 <div class="row">
    							<div class="col-md-2" style="width:185px;">
    							<%
    								int index1 = (int)Math.round(Math.floor((Math.random() * login_IDs.get(login_IDs.size()-1)) + 1)); 
    								
    								while(people_following.contains(index1) || !login_IDs.contains(index1) || index1==Integer.parseInt(l_ID))
    									index1 = (int)Math.round(Math.floor((Math.random() * login_IDs.get(login_IDs.size()-1)) + 1)); 
    								
									String info_q = "SELECT first_name,last_name,username,pic_link from login_t WHERE login_ID=" + index1 + ";"; 
									java.sql.Statement info_s = con.createStatement();
									java.sql.ResultSet info = info_s.executeQuery(info_q);
									info.next(); 
    							%>
    							<a href="twitter-following.jsp?login_ID=<%=l_ID%>&view_ID=<%=index1%>" class="account-group">
									<strong class="fullname"><%out.println(info.getString(1) + " " + info.getString(2));%></strong>
									<span>&rlm;</span>
									<span class="username">
									<font color="999999">
									<br><s>@</s>
									<b><%=info.getString(3)%></b>
									</span>
									</font>
									<br><br>
									<img class="avatar size73" style="max-height: 70px" height="70px" width="70px" src="<%=info.getString(4)%>" alt="Barak Obama">
									<a class="btn btn-info" type="button" href="insert-follower.jsp?follower_ID=<%=l_ID%>&followed_ID=<%=index1%>">Follow</a>
									<br><br>
								</a>
    							
    							</div>
    							<div class="col-md-2" style="width:185px; border-left: 1px solid #e8e8e8;">
    							<%
    								int index2 = (int)Math.round(Math.floor((Math.random() * login_IDs.get(login_IDs.size()-1)) + 1)); 
    								
    								while(people_following.contains(index2) || !login_IDs.contains(index2) || index1 == index2 || index2==Integer.parseInt(l_ID))
    									index2 = (int)Math.round(Math.floor((Math.random() * login_IDs.get(login_IDs.size()-1)) + 1)); 
    								
									info_q = "SELECT first_name,last_name,username,pic_link from login_t WHERE login_ID=" + index2 + ";"; 
									info_s = con.createStatement();
									info = info_s.executeQuery(info_q);
									info.next(); 
    							%>
    							<a href="twitter-following.jsp?login_ID=<%=l_ID%>&view_ID=<%=index2%>" class="account-group">
									<strong class="fullname"><%out.println(info.getString(1) + " " + info.getString(2));%></strong>
									<span>&rlm;</span>
									<span class="username">
									<font color="999999">
									<br><s>@</s>
									<b><%=info.getString(3)%></b>
									</span>
									</font>
									<br><br>
									<img class="avatar size73" style="max-height: 70px" height="70px" width="70px" src="<%=info.getString(4)%>" alt="Barak Obama">
									<a class="btn btn-info" type="button" href="insert-follower.jsp?follower_ID=<%=l_ID%>&followed_ID=<%=index2%>">Follow</a>
									<br><br>
								</a>
    							</div>
    							<div class="col-md-2" style="width:185px; border-left: 1px solid #e8e8e8;">
    							<%
    								int index3 = (int)Math.round(Math.floor((Math.random() * login_IDs.get(login_IDs.size()-1)) + 1)); 
    								
    								while(people_following.contains(index3) || !login_IDs.contains(index3) || index3 == index2 || index3 == index1 || index3==Integer.parseInt(l_ID))
    									index3 = (int)Math.round(Math.floor((Math.random() * login_IDs.get(login_IDs.size()-1)) + 1)); 
    								
									info_q = "SELECT first_name,last_name,username,pic_link from login_t WHERE login_ID=" + index3 + ";"; 
									info_s = con.createStatement();
									info = info_s.executeQuery(info_q);
									info.next(); 
    							%>
    							<a href="twitter-following.jsp?login_ID=<%=l_ID%>&view_ID=<%=index3%>" class="account-group">
									<strong class="fullname"><%out.println(info.getString(1) + " " + info.getString(2));%></strong>
									<span>&rlm;</span>
									<span class="username">
									<font color="999999">
									<br><s>@</s>
									<b><%=info.getString(3)%></b>
									</span>
									</font>
									<br><br>
									<img class="avatar size73" style="max-height: 70px" height="70px" width="70px" src="<%=info.getString(4)%>" alt="Barak Obama">
									<a class="btn btn-info" type="button" href="insert-follower.jsp?follower_ID=<%=l_ID%>&followed_ID=<%=index3%>">Follow</a>
									<br><br>
								</a>
    							</div>
  							</div>
						</div>
						<br><br>
					</div>
				</div>
			<%  } %>
			
			<div class="span8 content-main">
				<div class="module">
					<div class="content-header">
						<div class="header-inner">
							<form action="insert-tweet.jsp" method="get">
							<textarea class="tweet-box" id="f10" name="text" style="width:400px;" placeholder="What's happening?" id="tweet-box-mini-home-profile"></textarea>
							&nbsp&nbsp&nbsp&nbsp&nbsp
							<input type="submit" class="btn btn-small btn-primary" value="Tweet">
							<input type="hidden" class="tweet-box" name="login_ID" value="<%=l_ID%>" id="tweet-box-mini-home-profile">
      						</form>
						</div>
					</div>
					<!-- new tweets alert -->
					<div class="stream-item hidden">
						<div class="new-tweets-bar js-new-tweets-bar well">
							2 new Tweets
						</div>
					</div>
					<!-- all tweets -->
					<div class="stream home-stream">
						<% while(tweets.next()){ 
							//gather retweet info
							String is_retweet_q = "SELECT a.retweet_ID, a.tweet_ID, c.first_name,c.last_name FROM retweets_t a, tweets_t b, login_t c WHERE a.tweet_ID = b.tweet_ID AND b.login_ID = a.login_ID AND a.retweet_ID = " + tweets.getString(8) + " GROUP BY a.retweet_ID;";
							//out.println(is_retweet_q); 
            				java.sql.Statement is_retweet_s = con.createStatement();
							java.sql.ResultSet is_retweet_set = is_retweet_s.executeQuery(is_retweet_q);
							int retweet_ID = -1; 
							String tweeter_first_name = ""; 
							String tweeter_last_name = ""; 
							String tweeter_username = ""; 
							String tweeter_pic = ""; 
							String tweeter_t_ID = "0"; 
							while(is_retweet_set.next()){
								retweet_ID = Integer.parseInt(is_retweet_set.getString(1)); 
							}
							//out.println(retweet_ID); 
							if(retweet_ID != -1){
								String get_orig_name = "SELECT a.first_name, a.last_name,a.pic_link,a.username, b.tweet_ID from login_t a, tweets_t b, retweets_t c WHERE a.login_ID = b.login_ID AND c.tweet_ID = b.tweet_ID AND c.retweet_ID = " + retweet_ID + ";"; 
								//out.println(get_orig_name); 
								java.sql.Statement get_orig_name_s = con.createStatement();
								java.sql.ResultSet get_orig_name_set = get_orig_name_s.executeQuery(get_orig_name);
								get_orig_name_set.next();
								tweeter_first_name = get_orig_name_set.getString(1); 
								tweeter_last_name = get_orig_name_set.getString(2); 
								tweeter_pic = get_orig_name_set.getString(3); 
								tweeter_username = get_orig_name_set.getString(4); 
								tweeter_t_ID = get_orig_name_set.getString(5); 
								//check if it is a retweet
								//it is
							}

							//check if the tweet has been retweeted
							String num_retweets_q = "SELECT tweet_ID FROM retweets_t where tweet_ID = \"" + tweets.getString(8) +"\";";
            				java.sql.Statement num_retweets_s = con.createStatement();
							java.sql.ResultSet num_retweets_set = num_retweets_s.executeQuery(num_retweets_q);
							int num_retweets = 0; 
							int origID = 0; 
							while(num_retweets_set.next()){
								num_retweets ++; 
								origID = Integer.parseInt(num_retweets_set.getString(1));
							}

							java.sql.PreparedStatement checkIfRetweeted = con.prepareStatement("SELECT a.retweet_ID,b.login_ID FROM retweets_t a,tweets_t b WHERE a.tweet_ID = ? AND a.retweet_ID = b.tweet_ID AND b.login_ID = ?");
               				checkIfRetweeted.setString(1, origID + ""); 
               				checkIfRetweeted.setString(2, l_ID); 
               				java.sql.ResultSet checkRetweeted = checkIfRetweeted.executeQuery(); 
               				int my_ID = -1; 
               				if(checkRetweeted.next()){
               					my_ID = Integer.parseInt(checkRetweeted.getString(1)); 
               				} 
						%>

						<!-- start tweet -->
						<div class="box js-stream-item stream-item expanding-string-item">
							<div class="tweet original-tweet">
								<div class="user-actions">
									<div class="dropdown">
  										<button class="btn btn-default btn-xs dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown" aria-expanded="true">
    											<!-- Follow or unfollow -->
    											<span class="caret"></span>
  										</button>
  										<ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu1">
											<li><a href="remove-follower.jsp?follower_ID=<%=l_ID%>&followed_ID=<%=tweets.getString(3)%>">Unfollow</a></li>
											<% 
											//out.println(tweets.getString(3)); 
											//out.println(l_ID); 
											//out.println("YES"); 
											if(Integer.parseInt(tweets.getString(3)) == Integer.parseInt(l_ID)) { //you tweeted it%>
												<li><a href="delete-tweet.jsp?login_ID=<%=l_ID%>&tweet_ID=<%=tweets.getString(8)%>&retweet_ID=<%=retweet_ID%>">Delete</a></li>
											<% } 
											//you didn't tweet it 
											else {
												if(my_ID > 0 || tweeter_username.equals(username)){} else {
											%>  
												<li><a href="insert-tweet.jsp?text=<%=tweets.getString(1).replaceAll("#", "%23")%>&login_ID=<%=l_ID%>&retweet_ID=<%=tweets.getString(8)%>">Retweet</a></li>
											<% } 
											} %>
  										</ul>
									</div>
									<!--<a class="btn">btn</a>-->
									<!--<a href="remove-follower.jsp?follower_ID=<%=l_ID%>&followed_ID=<%=tweets.getString(3)%>" role="button" class="btn btn-default btn-small">Unfollow</a>
										<a href="insert-follower.jsp?follower_ID=<%=l_ID%>&followed_ID=<%=tweets.getString(3)%>" role="button" class="btn btn-default btn-small">Follow</a>-->
								</div>
								<% //date
									//credit: http://jeromejaglale.com/doc/java/twitter
									SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.ENGLISH); 
									
									Date created = null;
									String t_date = ""; 
									//out.println(tweets.getString(2));
									try {
										created = dateFormat.parse(tweets.getString(2));
										//out.println(created);
									} catch (Exception e) {
										t_date = ""; 
									}
									//created = tweets.getDate("d_t");
 							
									// today
									Date today = new Date();
 							
									// how much time since (ms)
									Long duration = today.getTime() - created.getTime();
 							
									int second = 1000;
									int minute = second * 60;
									int hour = minute * 60;
									int day = hour * 24;
 							
									if (duration < second * 7) {
										t_date = "right now";
									}
 							
									else if (duration < minute) {
										int n = (int) Math.floor(duration / second);
										t_date = n + " seconds ago";
									}
 							
									else if (duration < minute * 2) {
										t_date = "about 1 minute ago";
									}
 							
									else if (duration < hour) {
										int n = (int) Math.floor(duration / minute);
										t_date = n + " minutes ago";
									}
									
									else if (duration < hour * 2) {
										t_date = "about 1 hour ago";
									}
 							
									else if (duration < day) {
										int n = (int) Math.floor(duration / hour);
										t_date = n + " hours ago";
									}
									
									else if (duration > day && duration < day * 2) {
										t_date = "yesterday";
									}
 							
									else if (duration < day * 365) {
										int n = (int) Math.floor(duration / day);
										t_date = n + " days ago";
									} 
									
									else {
										t_date = "over a year ago";
									}
								%>
								
								<div class="content">
									<div class="stream-item-header">
										<small class="time">
										<a href="#" class="tweet-timestamp" title="10:15am - 16 Nov 12">
										<span class="_timestamp"><%=t_date%></span>
										</a>
										</small>
										<a href="twitter-following.jsp?login_ID=<%=l_ID%>&view_ID=<%=tweets.getString(3)%>" class="account-group">
										<!--<img class="avatar" src="<%=tweets.getString(7)%>" alt="Barak Obama">-->
										<% if(retweet_ID != -1){ %>
											<img class="avatar" src="<%=tweeter_pic%>" alt="Barak Obama" height="50px" width="50px" style="top: 40px;">
											<img src="http://www.s-trip.com/wp-content/uploads/2014/06/icon-retweet.png" height="12" width="12">
										<% } %>
										<% if(retweet_ID == -1){ %>
											<img class="avatar" src="<%=tweets.getString(7)%>" alt="Barak Obama" height="50px" width="50px">
											<strong class="fullname"><font size="2"><%out.println(tweets.getString(5) + " " + tweets.getString(6));%></font></strong>
										<% } 
										else {%>
											<strong class=""><font size="2"><%out.println(tweets.getString(5) + " " + tweets.getString(6));%></font></strong>
										<% } %>
										<span>&rlm;</span>
										<% if(retweet_ID == -1){ %>
											<span class="username">
											<s>@</s>
											<b><%=tweets.getString(4)%></b>
											</span>
										<%}
										else {%>
											<small>retweeted </small>
										<%}%>
										</a>
									</div>
									<% if(retweet_ID != -1){ %>
									<div class="" style="padding: 7px; width: 90%;">
										<div class="stream-item-header">
										<a href="#" class="account-group">
										<!--<img style="border-radius: 13%;" src="<%=tweeter_pic%>" alt="Barak Obama" height="50px" width="50px">-->
										<strong class="fullname"><%=tweeter_first_name + " " + tweeter_last_name%></strong>
										<span>&rlm;</span>
										<span class="username">
										<s>@</s>
										<b><%=tweeter_username%></b>
										</span>
										</a>
										</div>
									<%}%>
									<p class="js-tweet-text">
										<%
										//underline the hashtags 
										String tweet_text = tweets.getString(1); 
										String[] text_split = tweet_text.split(" "); 
										for(int jj = 0; jj < text_split.length; jj ++){
											text_split[jj] = text_split[jj].replaceAll("&", "&amp;").replaceAll(">", "&gt;").replaceAll("<", "&#60;");
										}
										int status = 0; 
										for(int jj = 0; jj < text_split.length; jj ++){
											if(text_split[jj].contains("#") && !text_split[jj].contains("#60")){
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
										    }
											else {
												//why
												//out.println("print"); 
												out.print(text_split[jj] + " "); 
											}
										}
										%>
									</p>
									<% if(retweet_ID != -1){ %>
										</div>
									<% } %>

									<script language="javascript"> 
										function toggle<%=tweets.getString(8)%>() {
											var ele = document.getElementById("toggleText<%=tweets.getString(8)%>");
											var text = document.getElementById("displayText<%=tweets.getString(8)%>");
											if(ele.style.display == "block") {
    											ele.style.display = "none";
												text.innerHTML = "<a id='displayText<%=tweets.getString(8)%>' href='javascript:toggle<%=tweets.getString(8)%>();''><img src='http://www.gatesfoundation.org/images/gfo/sprites/reply-twitter-icon.	png' height='14' width='11'></a>";
  											}
											else {
												ele.style.display = "block";
												text.innerHTML = "<a id='displayText<%=tweets.getString(8)%>' href='javascript:toggle<%=tweets.getString(8)%>();''><img src='http://www.gatesfoundation.org/images/gfo/sprites/reply-twitter-icon.	png' height='14' width='11'></a>";
											}
										} 
									</script>
									<a id="displayText<%=tweets.getString(8)%>" href="javascript:toggle<%=tweets.getString(8)%>();"><img src="http://www.gatesfoundation.org/images/gfo/sprites/reply-twitter-icon.png" height="3%" width="3%"></a>

									<%
										int reply_ID = Integer.parseInt(tweets.getString(8)); 
										if(retweet_ID > 0){
											reply_ID = Integer.parseInt(tweeter_t_ID); 
										}
										//out.println("T: " + tweets.getString(8) + " R: " + reply_ID);

										String replies_q = "SELECT a.text,a.d_t,a.login_ID,d.username,d.first_name,d.last_name,d.pic_link,a.tweet_ID,a.reply_ID FROM reply_t a,following_t b,login_t c, login_t d WHERE d.login_ID = a.login_ID AND a.tweet_ID=" + (""+reply_ID) + " GROUP BY a.d_t;";
            							java.sql.Statement replies_s = con.createStatement();
										java.sql.ResultSet replies_set = replies_s.executeQuery(replies_q);

										String count_replies_q = "SELECT COUNT(*) FROM reply_t a,following_t b,login_t c, login_t d WHERE d.login_ID = a.login_ID AND a.tweet_ID=" + reply_ID + " GROUP BY a.d_t DESC;";
										java.sql.Statement count_replies_s = con.createStatement();
										java.sql.ResultSet count_replies_set = count_replies_s.executeQuery(count_replies_q);
										int reply_count = 0; 
										while(count_replies_set.next()){
											reply_count ++; 
										}
									%>
									<%
									if(reply_count > 0){
										%> 
										<%=reply_count%>
										<%
									}
									else {
									 %> &nbsp&nbsp <% 
									}
									%>

									<%  
										/*  If it is a retweet, you can retweet the original tweet (unless it is your own tweet). */
										/* 	If it is not a retweet, you can retweet it once. */
               						//checkIfRetweeted.setString(2, l_ID); 
               						//out.println(checkIfRetweeted); 
               						%>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp<%
               						
               						if(my_ID > 0 || tweets.getString(3).equals(l_ID)){ 
               						    //out.println("CANT RETWEET"); 
               						    //out.println(tweets.getString(3));
               						    if(tweets.getString(3).equals(l_ID)){
               						    	//out.println("1"); 
               						    	%>
               						    	<img src="images/retweeted.png" height="3%" width="3%">
               						    	<%
               						    }
               						    else {
               						    	//out.println("2"); 
               						    	%>
               						    	<a href="delete-tweet.jsp?login_ID=<%=l_ID%>&tweet_ID=<%=my_ID%>&retweet_ID=<%=my_ID%>"><img src="images/retweet-green.png" height="3%" width="3%"></a>
               						    	<%
               						    }
										//out.println("delete-tweet.jsp?login_ID=" + l_ID + "&tweet_ID=" + checkRetweeted.getString(1) + "&retweet_ID=" + checkRetweeted.getString(1));
               						} 
               						else if (retweet_ID != -1 ){ 
               							//it's a retweet, and you can retweet it
               							//out.println("3"); 
               							if(tweeter_username.equals(username)){ %>
               								<img src="images/retweeted.png" height="3%" width="3%">
               								<%
               							}
               							else {
											%>
               								<a href="insert-tweet.jsp?text=<%=tweets.getString(1).replaceAll("#", "%23")%>&login_ID=<%=l_ID%>&retweet_ID=<%=tweeter_t_ID%>">
               								<img src="http://www.s-trip.com/wp-content/uploads/2014/06/icon-retweet.png" 
               								onmouseover="this.src='images/retweet-green.png'" onmouseout="this.src='http://www.s-trip.com/wp-content/uploads/2014/06/icon-retweet.png'"
               								height="3%" width="3%"> 
               								</a>
               						<% 	}
               						}
               						else { 
               							//it's a tweet, and you can retweet it (most common)
               							//out.println("4"); 
               							%>
               							<a href="insert-tweet.jsp?text=<%=tweets.getString(1).replaceAll("#", "%23")%>&login_ID=<%=l_ID%>&retweet_ID=<%=tweets.getString(8)%>"><img src="http://www.s-trip.com/wp-content/uploads/2014/06/icon-retweet.png" onmouseover="this.src='images/retweet-green.png'" onmouseout="this.src='http://www.s-trip.com/wp-content/uploads/2014/06/icon-retweet.png'"
               							height="3%" width="3%"></a>
               						<% } %>
   
									

									<%/* if(retweet_ID == -1){ %>
									<a href="insert-tweet.jsp?text=<%=tweets.getString(1).replaceAll("#", "%23")%>&login_ID=<%=l_ID%>&retweet_ID=<%=tweets.getString(8)%>"><img src="http://www.s-trip.com/wp-content/uploads/2014/06/icon-retweet.png" height="12" width="12"></a>
									<% } 
									else {
									%> 
									&nbsp&nbsp&nbsp&nbsp&nbsp<img src="images/retweeted.png" height="12" width="12">
									<% } %>

									<%
									if(num_retweets > 0){
										%> 
										<%=num_retweets%>
										<%
									}
									*/%>

									&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp
									<a href="twitter-favorite.jsp?tweet_ID=<%=reply_ID%>&login_ID=<%=l_ID%>"><img src="https://cdn3.iconfinder.com/data/icons/token/Token,%20128x128,%20PNG/Star-Favorites.png" height="3%" width="3%"></a>
									<%
										String num_fav_q = "SELECT COUNT(*) FROM favorites_t where tweet_ID = \"" + reply_ID +"\";";
            							java.sql.Statement num_fav_s = con.createStatement();
										java.sql.ResultSet num_fav_set = num_fav_s.executeQuery(num_fav_q);
										num_fav_set.next();
										int num_faves = Integer.parseInt(num_fav_set.getString(1)); 
										
										if(num_faves > 0){
											%> 
											<%=num_faves%>
											<%
										}
										else {
											out.print("&nbsp&nbsp"); 
										}
									%>
									&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp
									<img src="http://www.shopthreedots.com/blog/wp-content/uploads/2011/07/three_dots_iconic_logo1.jpg" height="20" width="20">
										<div class="" id="toggleText<%=tweets.getString(8)%>" style="padding: 10px; width: 90%; display: none">
											<!--<small>Replies</small>
											<br>
											<br>-->
											<% while(replies_set.next()){ %>
											<hr style="background:#787878; border:0; height:1px; width:93%; margin-top: 1px;margin-bottom: 1px" />
											<div class="" style="width: 97%; height:73%;">
													<div class="box js-stream-item stream-item expanding-string-item">
														<div class="tweet original-tweet">
															<p class="js-tweet-text">
																<div class="js-stream-item stream-item expanding-string-item">
																	<div>
																		<div class="user-actions">
																			<% if(replies_set.getString(3).equals(l_ID)) { %>
																			<a href="delete-reply.jsp?login_ID=<%=l_ID%>&reply_ID=<%=replies_set.getString(9)%>"><img src="https://cdn1.iconfinder.com/data/icons/nuove/128x128/actions/fileclose.png" width="14" height="11"></a>
																			<% } %>
																		</div>
																		<div class="content">
																			<div class="stream-item-header">
																					<a href="twitter-following.jsp?login_ID=<%=l_ID%>&view_ID=<%=replies_set.getString(3)%>" class="account-group">
																					<img class="avatar" src="<%=replies_set.getString(7)%>" alt="Barak Obama">
																					<strong class="fullname"><%out.println(replies_set.getString(5) + " " + replies_set.getString(6));%></strong>
																					<span>&rlm;</span>
																					<span class="username">
																					<s>@</s>
																					<b><%=replies_set.getString(4)%></b>
																					</span>
																					</a>
																				</div>
																				<p class="js-tweet-text">
																					<% 
																						//underline the hashtags 
																						String reply_text = replies_set.getString(1); 
																						//out.println(reply_text); 
																						String[] rep_split = reply_text.split(" "); 
																						status = 0; 
																						//out.println(text_split.length); 
																						for(int jj = 0; jj < rep_split.length; jj ++){
																							rep_split[jj] = rep_split[jj].replaceAll("&", "&amp;").replaceAll(">", "&gt;").replaceAll("<", "&#60;");
																						}
																						//out.println("before for"); 
																						for(int jj = 0; jj < rep_split.length; jj ++){
																							if(rep_split[jj].contains("#") && !rep_split[jj].contains("#60")){
	            																				String tag = rep_split[jj].substring(1); 
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
																									%><a href="hash-list.jsp?login_ID=<%=l_ID%>&hash_ID=<%=tag_num%>&hash_text=<%=tag%>"><%=rep_split[jj]%></a><%out.println(" "); 
																								}
																							}
																							else if (rep_split[jj].contains("@")) {
										                    									String tag = rep_split[jj].substring(1); 
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
										                    										%><a href="twitter-following.jsp?login_ID=<%=l_ID%>&view_ID=<%=tag_num%>"><%=rep_split[jj]%></a>	<%
											   														out.println(" "); 
										                    									}
										                    								}
																							else {
																								//why
																								//out.println("print"); 
																								out.print(rep_split[jj] + " "); 
																							}
																						}
																			 		%>
																				</p>
																			</div>
																			</a>
																			<div class="expanded-content js-tweet-details-dropdown"></div>
																		</div>
																	</div>
																<!-- end tweet -->	
															</p>
													</div>
												</div>
											</div>
											<% } %>
											<hr style="background:#787878; border:0; height:1px; width:93%; margin-top: 1px;" />
											<form action="insert-reply.jsp" method="get">
												<textarea class="tweet-box" name="text" style="width:400px;" id="tweet-box-mini-home-profile">@<%=tweets.getString(4) + " "%></textarea>
												&nbsp&nbsp&nbsp&nbsp&nbsp
												<br>
												<input type="submit" class="btn btn-xs btn-primary" value="Reply">
												<input type="hidden" class="tweet-box" name="login_ID" value="<%=l_ID%>" id="tweet-box-mini-home-profile">
												<input type="hidden" class="tweet-box" name="tweet_ID" value="<%=reply_ID%>" id="tweet-box-mini-home-profile">
      										</form>
										</div>
								</div>
								</a>
								<div class="expanded-content js-tweet-details-dropdown"></div>
							</div>
						</div>
						<!-- end tweet -->
						<%} %> 
					</div>
					<!-- end tweets div -->
					<div class="stream-footer"></div>
					<div class="hidden-replies-container"></div>
					<div class="stream-autoplay-marker"></div>
				</div>
			</div>
		</div>
		</div>
		<center><small style="font-size: 50%;">By joining twitter, you agree to our <a href="twitter-terms.jsp"> terms. </a></small></center>
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
