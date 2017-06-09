<%@ page import="javax.servlet.http.HttpServlet"%>
<%@ page import="java.sql.DriverManager, java.sql.SQLException"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.sql.Statement"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.io.PrintWriter, java.io.File, java.io.FileNotFoundException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>D3 Application</title>
</head>
<body>
	<h1>Databases</h1>
	<%
		Connection conn = null;
		Statement statement = null;
		ResultSet resultSet = null;
	
		String driver = "com.mysql.jdbc.Driver";
		String url = "jdbc:mysql://localhost/";
		String username = request.getParameter("usrname");
		String password = request.getParameter("pwd");
		Class.forName(driver);		
		conn = DriverManager.getConnection(url, username, password);
	%>
	<form action="getTables.jsp">
		<input type="hidden" name="usrname" value="<% out.write(username);%>">
		<input type="hidden" name="pwd" value="<% out.write(password);%>">
		
		
	<%	
		
		String db_name = "";
		try {
			statement = conn.createStatement();
			String sql = "SHOW DATABASES;";
			resultSet = statement.executeQuery(sql);
			while (resultSet.next()) { 
				db_name = resultSet.getString("Database");%>
			
				<input type="radio" name="db_name" value="<% out.write(db_name); %>"><% out.write(db_name); %><br>
			<% }
			
		} catch (Exception e) {
			e.printStackTrace();
		}
	
		// closing query connection
		try {
			statement.close();
			conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	%>
	<br>
	<input type="submit"></input>
	</form> 
</body>
</html>