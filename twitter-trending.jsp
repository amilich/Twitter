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
	ArrayList<Integer> people_following = new ArrayList<Integer>();

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
	    java.sql.Statement image_s = con.createStatement();
	
		//executes the query:
		java.sql.ResultSet rs1 = tweet_count_s.executeQuery(tweet_count_q);
		java.sql.ResultSet rs2 = follower_count_s.executeQuery(follower_count_q);
		java.sql.ResultSet rs3 = following_count_s.executeQuery(following_count_q);
		java.sql.ResultSet rs4 = username_s.executeQuery(username_q);
		java.sql.ResultSet rs5 = image_s.executeQuery(image_q);
	
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

	</head>
	<body class="user-style-theme1" onload="">
		<nav class="navbar navbar-fixed-top navbar-default" role="navigation">
			<div class="container-fluid">
				<!-- Collect the nav links, forms, and other content for toggling -->
				<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
					<ul class="nav navbar-nav">
						<li><a href="twitter-home.jsp?login_ID=<%=l_ID%>">Home <span class="sr-only">(current)</span></a></li>
						<li class="active"><a href="twitter-trending.jsp?login_ID=<%=l_ID%>">#discover</a></li>
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
						<form class="navbar-form navbar-left" action="insert-tweet.jsp" method="get">
        					<div class="form-group">
								<textarea class="tweet-box" name="text" placeholder="Compose new Tweet..." id="tweet-box-mini-home-profile"></textarea>
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
		<div class="container wrap"> <!-- not container wrap -->
			<div class="row">
				<!-- left column -->
				<div class="span4" id="secondary"> <!-- not id="secondary" -->
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
						<p>The latest and most popular <a href="#"> #hashtags </a>.</p>
					</div>
				</div>
			</div>
			<!-- right column -->
			<div class="span8 content-main">
				<div class="module">
					<div class="content-header">
						<div class="header-inner module">
							<font color="#7F7F7F">
							<h5><b>Tweets</b></h5>
							<h5>What's happening now, tailored for you</h5>
							</font>
							<!-- took out tweet form -->
						</div>
						<div class="header-inner">
							<h4>Trending</h4>
							<!-- took out tweet form -->
						</div>
					</div>
					<!-- new tweets alert -->
					<div class="stream-item hidden">
						<div class="new-tweets-bar js-new-tweets-bar well">
							2 new Tweets
						</div>
					</div>
					<!-- all tweets -->
					<%
					String trend_q = "SELECT a.hash_tag,a.hash_ID, COUNT(*) as count FROM hash_t a, hash_tweet_t b WHERE a.hash_ID = b.hash_ID GROUP BY hash_tag ORDER BY count DESC;";
            		java.sql.Statement trend_s = con.createStatement();
					java.sql.ResultSet trend_set = trend_s.executeQuery(trend_q);
					int count = 0; 
					while(trend_set.next() && count < 5){
						count ++; 
					%>
					
					<div class="stream home-stream">
						<div class="js-stream-item stream-item expanding-string-item">
							<div class="tweet original-tweet">
								<div>
									<p class="js-tweet-text">
										<h4>&nbsp
											<a href="hash-list.jsp?login_ID=<%=l_ID%>&hash_ID=<%=trend_set.getString(2)%>&hash_text=<%=trend_set.getString(1)%>">#<%=trend_set.getString(1) + " "%></a>
											<%
												String trend = trend_set.getString(3); 
												trend = trend.replaceAll("&", "&amp;").replaceAll(">", "&gt;").replaceAll("<", "&#60;").replaceAll("!", "&#33;").replaceAll("!", "&#33;");
											%>
											<font size="2">- <%=trend%> recent uses</font>
										</h4>
									</p>
								</div>
								
							</div>
						</div>
					</div>
					<% } %>
					<!-- end tweets div -->
					<div class="stream-footer">
						<div class="content-header">
							<div class="header-inner">
								<h4>Here are some people you might enjoy following</h4>
								<!--<h2 class="js-timeline-title">Here are some people you might enjoy following.</h2>-->
							</div>
						</div>
						<br>
						<div class="container" style="max-height:110px; vertical-align:top;">
 							 <div class="row">
    							<div class="col-md-2" style="width:185px;">
    							<%
    								while(login_ID_set.next()){
										login_IDs.add(Integer.parseInt(login_ID_set.getString(1))); 
									}
    							
									int index1 = (int)Math.round(Math.floor((Math.random() * login_IDs.get(login_IDs.size()-1)) + 1)); 

									int stop = 0; 
    								while(people_following.contains(index1) || !login_IDs.contains(index1) || index1==Integer.parseInt(l_ID)){
    									index1 = (int)Math.round(Math.floor((Math.random() * login_IDs.get(login_IDs.size()-1)) + 1)); 
    									if(stop > 2*login_IDs.size())
    										break;
    									stop ++; 
    								}
    								
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
									<img class="avatar size73" style="max-height: 70px" height="70px" width="70px"  src="<%=info.getString(4)%>" alt="Barak Obama">
									<a class="btn btn-info" type="button" href="insert-follower.jsp?follower_ID=<%=l_ID%>&followed_ID=<%=index1%>">Follow</a>
									<br><br>
								</a>
    							
    							</div>
    							<div class="col-md-2" style="width:185px; border-left: 1px solid #e8e8e8;">
    							<%
    								int index2 = (int)Math.round(Math.floor((Math.random() * login_IDs.get(login_IDs.size()-1)) + 1)); 
    								
    								stop = 0; 
    								while(people_following.contains(index2) || !login_IDs.contains(index2) || index1 == index2 || index2==Integer.parseInt(l_ID)){
    									index2 = (int)Math.round(Math.floor((Math.random() * login_IDs.get(login_IDs.size()-1)) + 1)); 
    									if(stop > 2*login_IDs.size())
    										break;
    									stop ++; 
    								}
    								
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
    								
    								stop = 0; 
    								while(people_following.contains(index3) || !login_IDs.contains(index3) || index3 == index2 || index3 == index1 || index3==Integer.parseInt(l_ID)){
    									index3 = (int)Math.round(Math.floor((Math.random() * login_IDs.get(login_IDs.size()-1)) + 1)); 
    									if(stop > 2*login_IDs.size())
    										break;
    									stop ++; 
    								}
    								
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