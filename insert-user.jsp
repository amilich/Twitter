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
		Insert a user into the databse. 
	*/

	//get form data
	String fullname = request.getParameter("fullname");
	String email = request.getParameter("email");
	String username = request.getParameter("username");
	String password = request.getParameter("password");
	int l_ID = 0; 

	try {
		//split into first/last names
		String first_name = fullname.split(" ")[0]; 
		String last_name = fullname.split(" ")[1]; 
		//open sql using secret database information
    		Scanner sc = new Scanner(new FileReader("/home/amilich/public_html/twitter_dir/keys.txt"));
        	String db_user = sc.nextLine(); 
        	String db_password = sc.nextLine(); 
        	String db_url = sc.nextLine(); 
        	java.sql.Connection con = null;
        	Class.forName("com.mysql.jdbc.Driver").newInstance();
        	String url = db_url; 
        	con = DriverManager.getConnection(url, db_user, db_user); //mysql id &  pwd
    		int status = 0; 
	
    		//insert into login table - set all the values into the prepared statement
    		java.sql.PreparedStatement ps = con.prepareStatement("INSERT INTO login_t (email, username, first_name, last_name, password) VALUES (?, ?, ?, ?, ?); ");
        	ps.setString (1, email);
        	ps.setString (2, username);
        	ps.setString (3, first_name);
        	ps.setString (4, last_name);
        	ps.setString (5, password);
	
        	status = ps.executeUpdate();
	
		//get your login ID to set it as session variable and cookie
		String l_ID_q = "SELECT login_ID FROM login_t WHERE username = \"" + username + "\";"; 
    		java.sql.Statement l_ID_s = con.createStatement();
		java.sql.ResultSet rs1 = l_ID_s.executeQuery(l_ID_q);
		
		while(rs1.next()){
			l_ID = Integer.parseInt(rs1.getString(1)); 
		}
	}
	catch(Exception e){
		out.println(e); 
	}
	
	//add a user ID into cookie
	%>
		<script>
			var d = new Date();
			var exdays = 1; 
    			d.setTime(d.getTime() + (exdays*24*60*60*1000));
    			var expires = "expires="+d.toUTCString();
			document.cookie="login_ID=<%=l_ID%>; expires="+expires+"; path=/"; //fix login id here 
		</script>
	<%
	//add session variable
	session.setAttribute( "login_ID", l_ID );
%>

<script language="javascript">
	//redirect to twitter home 
    window.location.href = "http://compsci.dalton.org:8080/amilich/twitter_dir/twitter-home.jsp?login_ID=<%=l_ID%>"; 
</script>

<h1> </h1>

</body>
</html> 
