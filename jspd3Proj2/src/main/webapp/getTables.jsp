<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpServlet"%>
<%@ page import="java.sql.DriverManager, java.sql.SQLException"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.sql.Statement"%>
<%@ page import="java.sql.Connection"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>

	<form action="getData.jsp">
		
	<% 
	Connection conn = null;
	Statement statement = null;
	ResultSet resultSet = null;

	String driver = "com.mysql.jdbc.Driver";
	String db_name = request.getParameter("db_name");
	String url = "jdbc:mysql://localhost/"+db_name;
	String username = request.getParameter("usrname");
	String password = request.getParameter("pwd");
	Class.forName(driver);		
	conn = DriverManager.getConnection(url, username, password); 
	%>
		<input type="hidden" name="usrname" value="<% out.write(username);%>">
		<input type="hidden" name="pwd" value="<% out.write(password);%>">
		<input type="hidden" name="db_name" value="<% out.write(db_name);%>">
		
	<%
	String table_name = "";
	try {
		statement = conn.createStatement();
		String sql = "SHOW TABLES;";
		resultSet = statement.executeQuery(sql);
		while (resultSet.next()) { 
			table_name = resultSet.getString("Tables_in_"+request.getParameter("db_name"));%>
		
			<input type="radio" name="table_name" value="<% out.write(table_name); %>"><% out.write(table_name); %><br>
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
	<input type="submit" value="Get Data">
	</form>
</body>
</html>