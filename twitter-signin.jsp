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

<!DOCTYPE html>

<script src="lib/sweet-alert.min.js"></script> 
<link rel="stylesheet" type="text/css" href="lib/sweet-alert.css">

<%

  String msg = request.getParameter("msg");
  try{ 
    if(msg.toLowerCase().contains("fail")){
      %>
      <script> 
        sweetAlert("Login failed", "Please try again", "error");
      </script>
      <%
      out.println("failure"); 
    }
  }
  catch(Exception e){
    //out.println(e); 
  }

%>

<html lang="en">
  <head>
    <meta charset="utf-8">
    <title>Sign in</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="">
    <meta name="author" content="">

    <!-- Le styles -->
    <link rel="stylesheet" href="css/gordy_bootstrap.min.css">
	<link href="css/bootstrap.min.css" rel="stylesheet">
	<link href="css/styles.css" rel="stylesheet">

    <style type="text/css">
      body {
        padding-top: 40px;
        padding-bottom: 40px;
        background-color: #f5f5f5;
      }

      .form-signin {
        max-width: 300px;
        padding: 19px 29px 29px;
        margin: 0 auto 20px;
        background-color: #fff;
        border: 1px solid #e5e5e5;
        -webkit-border-radius: 5px;
           -moz-border-radius: 5px;
                border-radius: 5px;
        -webkit-box-shadow: 0 1px 2px rgba(0,0,0,.05);
           -moz-box-shadow: 0 1px 2px rgba(0,0,0,.05);
                box-shadow: 0 1px 2px rgba(0,0,0,.05);
      }
      .form-signin .form-signin-heading,
      .form-signin .checkbox {
        margin-bottom: 10px;
      }
      .form-signin input[type="text"],
      .form-signin input[type="password"] {
        font-size: 16px;
        height: auto;
        margin-bottom: 15px;
        padding: 7px 9px;
      }

    </style>

    <!-- HTML5 shim, for IE6-8 support of HTML5 elements -->
    <!--[if lt IE 9]>
      <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
    <![endif]-->

    <!-- Fav and touch icons -->
    <link rel="shortcut icon" href="../assets/ico/favicon.ico">
    <link rel="apple-touch-icon-precomposed" sizes="144x144" href="../assets/ico/apple-touch-icon-144-precomposed.png">
    <link rel="apple-touch-icon-precomposed" sizes="114x114" href="../assets/ico/apple-touch-icon-114-precomposed.png">
    <link rel="apple-touch-icon-precomposed" sizes="72x72" href="../assets/ico/apple-touch-icon-72-precomposed.png">
    <link rel="apple-touch-icon-precomposed" href="../assets/ico/apple-touch-icon-57-precomposed.png">
  </head>

  <body class="twitter-signin">
    <nav class="navbar navbar-fixed-top navbar-default" role="navigation">
			<div class="container-fluid">
				<!-- Collect the nav links, forms, and other content for toggling -->
				<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
					<ul class="nav navbar-nav">
						<li><a href="">Home <span class="sr-only">(current)</span></a></li>
						<li><a href="#">#Discover</a></li>
            <li><a href="#">Find Friends</a></li>
						<li><a href="#">Settings</a></li>
						<li><a href="logout.jsp">Logout</a></li>
						<!-- TERRIBLE SOLUTION -->
					</ul>
					<a class="navbar-brand" rel="home" href="#">
        			<img style="max-width:25px; margin-top: -7px; float:center;"
            		 src="images/logo.png">
    				</a>
				</div>
				<!-- /.navbar-collapse -->
			</div>
			<!-- /.container-fluid -->
		</nav>
  <div class="front-bg">
  	
  <img class="front-image" src="images/jp-mountain@2x.jpg">
  </div>
  <div class="front-card">
    <div class="front-welcome">
      <div class="front-welcome-text">
        <h1>Welcome to Twitter</h1>
        <p>Find out what's happening now, with the people and organizations you care about.</p>
      </div>
    </div>

    <div class="front-signin">
      <form action="check-login.jsp" class="signin" method="post">
        <div class="placeholding-input username hasome">
          <input type="text" style="padding: 15px;" class="text-input email-input" name="ue" title="Username or email" autocomplete="on" tabindex="1" placeholder="Username or email">
        </div>
        <table class="flex-table password-signin">
          <tbody>
            <tr>
              <td class="flex-table-primary">
                <div class="placeholding-input password flex hasome">
                  <input type="password" name="pw" style="padding: 15px;" id="signin-password" class="text-input flext-table-input" title="Password" tabindex="2" placeholder="Password">
                </div>
              </td>
              <td class="flex-table-secondary">
                  <button type="submit" class="submit btn btn-primary flex-table-btn">Sign-in</button>
              </td>
            </tr>
          </tbody>
        </table>
        <div class="remember-forgot">
          <label class="remember">
            <input type="checkbox" name="remember_me" tabindex="3">
            <span>Remember me</span>
          </label>
          <span class="separator">.</span>
          <a href="#" class="forgot">Forgot password?</a>
        </div>
      </form>
    </div>

    <div class="front-signup">
      <h2><strong>New to Twitter?</strong> Sign up</h2>
      <form action="full-signin.jsp" class="signup" method="post">
        <div class="fullname">
          <input type="text" style="padding: 15px;" id="signup-user-name" autocomplete="off" maxlength="20" name="user[name]" placeholder="Full name">
        </div>
        <div class="email">
          <input type="text" style="padding: 15px;" id="signup-user-email" autocomplete="off" maxlength="20" name="user[email]" placeholder="Email">
        </div>        
        <div class="password">
          <input type="password" style="padding: 15px;" id="signup-user-password" autocomplete="off" maxlength="20" name="user[password]" placeholder="Password">
        </div>
        <button type="submit" class="btn btn-signup">
          Sign up for Twitter
        </button>
      </form>
    </div>

  </div>

    <!-- Le javascript
    ================================================== -->
    <!-- Placed at the end of the document so the pages load faster -->
     <script type="text/javascript" src="js/main-ck.js"></script>
  </body>
</html>
