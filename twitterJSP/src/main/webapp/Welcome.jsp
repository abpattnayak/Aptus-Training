<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Twitter Connector</title>
</head>
<body>
	<form action="index.jsp" target="_blank">
		<input type="submit" value="Authorize Me">
	</form>
	
	<form action="pin_oauth.jsp">
		<input type="text" name ="oauth_token" placeholder="oauth_token"><br><br>
		<input type="text" name ="pin" value="" placeholder="Enter PIN">
		<input type="submit" value="Go!!">
	</form>
	
</body>
</html>