<%
	String l_ID = request.getParameter("login_ID");
	out.println(l_ID); 
%>

<form action="upload_page.jsp" method="post" enctype="multipart/form-data">
    Select image to upload:
    <input type="file" name="fileToUpload" id="fileToUpload">
    <input type="hidden" class="tweet-box" name="login_ID" value="<%=l_ID%>" id="tweet-box-mini-home-profile">
    <input type="submit" value="Upload Image" name="submit">
</form>