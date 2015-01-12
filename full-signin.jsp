<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.mysql.jdbc.*" %>
<%@ page import="java.text.DateFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.ParseException" %> 
<%@ page import="java.util.Date" %>

<!DOCTYPE html>

<%
	String names = ""; 
	try {
		String url = ""; 
		//open sql:
    	java.sql.Connection con = null;
    	Class.forName("com.mysql.jdbc.Driver").newInstance();
    	url = "jdbc:mysql://localhost:3306/amilich_twitter";   //your db 
    	con = DriverManager.getConnection(url, "amilich", "amilich"); //mysql id &  pwd
    	int status = 0; 
    	String username_q = "SELECT username from login_t;"; 
    	java.sql.Statement username_s = con.createStatement();
		java.sql.ResultSet username_set = username_s.executeQuery(username_q);
		while (username_set.next()){
			names += "'" + username_set.getString(1) + "', "; 
		}
		names += "'_'"; 
		names = names.trim(); 
	}
	catch(Exception e){
		out.println(e); 
	}
%>

<script type="text/javascript" src="livevalidation_standalone.compressed.js"></script>

<head>
	<meta charset="utf-8">
	<title>Sign up for Twitter</title>
	<meta name="description" content="Join Twitter today - it only takes a few seconds. Connect with your friends and other fascinating people. Get in-the-moment updates on the things that interest you.">
	<meta name="msapplication-TileImage" content="//abs.twimg.com/favicons/win8-tile-144.png"/>
	<meta name="msapplication-TileColor" content="#00aced"/>
	<meta name="swift-page-name" id="swift-page-name" content="signup">
	
	<link rel="stylesheet" href="css/gordy_bootstrap.min.css">
	<link href="css/bootstrap.min.css" rel="stylesheet">
	<link href="css/styles.css" rel="stylesheet">
</head>

<body class="three-col logged-out phx-signup" 
	data-fouc-class-names="swift-loading"
	dir="ltr">
	<script id="swift_loading_indicator">
		document.body.className=document.body.className+" "+document.body.getAttribute("data-fouc-class-names");
	</script>
	<div id="doc" class="route-signup">
		<div class="topbar js-topbar   ">
			<div id="banners" class="js-banners">
			</div>
			<div class="global-nav" data-section-term="top_nav">
				<div class="global-nav-inner">
					<div class="container">
						<ul class="nav js-global-actions">
							<li class="home" data-global-action="t1home">
								<a class="btn btn-default btn-lg"  style="padding: 15px; "  href="http://compsci.dalton.org:8080/amilich/twitter_dir/twitter-signin.jsp"><font color="999999">Have an account? Signin</font></a>
							</li>
						</ul>	
					</div>
				</div>
			</div>
		</div>
		<!-- <div id="page-outer">
			<div id="page-container" class="AppContent wrapper wrapper-signup">
				<link href="css/twitter.css" rel="stylesheet">
				<div class="page-canvas">
					<div class="signup-wrapper">
						<h1>
							Join Twitter today.
						</h1>
						<form method="get" action="insert-user.jsp" class="t1-form ">
							<font color="ff0000">
							<input id="f1" type="text" style="padding: 15px;" class="text-input name-input" name="fullname" title="fullname" autocomplete="off" tabindex="1" placeholder="Full name">
								<script type="text/javascript">
		            				var f1 = new LiveValidation('f1');
		            				f1.add(Validate.Presence);
		          				</script>
							<br><br>
							<input id="f2" type="text" style="padding: 15px;" class="text-input email-input" name="email" title="email" autocomplete="off" tabindex="1" placeholder="Email">
								<script type="text/javascript">
		            				var f2 = new LiveValidation('f2');
		            				f2.add(Validate.Email);
		          				</script>
							<br><br>
							<input id="f3" type="text" style="padding: 15px;" class="text-input username-input" name="username" title="email" autocomplete="off" tabindex="1" placeholder="Username">
								<script type="text/javascript">
		            				var f15 = new LiveValidation('f3');
									f15.add( Validate.Exclusion, { within: [ <%=names%> ], partialMatch: false } );
									console.log(<%=names%>); 
		          				</script>
							<br><br>
							<input id="f4" type="password" style="padding: 15px;" class="text-input password-input" name="password" title="password" autocomplete="off" tabindex="1" placeholder="Password">
								<script type="text/javascript">
		            				var f4 = new LiveValidation('f4');
		            				f4.add(Validate.Presence);
		          				</script>
							<br><br>
							<input id="f5" type="password" style="padding: 15px;" class="text-input password-input" name="password" title="password" autocomplete="off" tabindex="1" placeholder="Confirm Password">
								<script type="text/javascript">
		            				var f19 = new LiveValidation('f5');
									f19.add( Validate.Confirmation, { match: 'f4' } );
		          				</script>
							<br><br>
							<button type="submit" class="btn btn-default">Submit</button>
							</font>
							<br><br>
							<small style="font-size: 50%;">By joining twitter, you agree to our <a href="twitter-terms.jsp"> terms. </a></small>
						</form>
					</div>
				</div>
			</div>
		</div> -->
	</div>
	
	</span>
	</button>

	<div id="spoonbill-outer"></div>
</body>
</html>
