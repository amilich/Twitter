<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.mysql.jdbc.*" %>
<!doctype html>

<%
	session.setAttribute( "login_ID", "-1");
    session.setAttribute( "username", "Not logged in");
%>

<script>
	//credit: http://stackoverflow.com/questions/2144386/javascript-delete-cookie
	function createCookie(name,value,days) {
    	if (days) {
        	var date = new Date();
        	date.setTime(date.getTime()+(days*24*60*60*1000));
        	var expires = "; expires="+date.toGMTString();
    	}
    	else var expires = "";
    	document.cookie = name+"="+value+expires+"; path=/";
	}

	function readCookie(name) {
    	var nameEQ = name + "=";
    	var ca = document.cookie.split(';');
    	for(var i=0;i < ca.length;i++) {
        	var c = ca[i];
        	while (c.charAt(0)==' ') c = c.substring(1,c.length);
        	if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
    	}
    	return null;
	}

	function eraseCookie(name) {
	    createCookie(name,"",-1);
	}
	
	eraseCookie("login_ID"); 
	//document.write(document.cookie); 
	window.location.href = "http://compsci.dalton.org:8080/amilich/twitter_dir/twitter-signin.jsp"; 
</script>