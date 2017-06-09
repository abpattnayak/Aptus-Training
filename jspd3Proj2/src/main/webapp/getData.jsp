<%@ page import="javax.servlet.http.HttpServlet"%>
<%@ page import="java.sql.DriverManager, java.sql.SQLException"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.sql.Statement"%>
<%@ page import="java.sql.Connection"%>
<%@ page
	import="java.io.PrintWriter, java.io.File, java.io.FileNotFoundException"%>

<%
	Connection conn = null;
	Statement statement = null;
	ResultSet resultSet = null;

	String db_name = request.getParameter("db_name");
	String username = request.getParameter("usrname");
	String password = request.getParameter("pwd");
	String table_name = request.getParameter("table_name");
	String driver = "com.mysql.jdbc.Driver";
	String url = "jdbc:mysql://localhost/"+db_name;
	Class.forName(driver);
	conn = DriverManager.getConnection(url, username, password);

	String id = "";
	String score = "";
	PrintWriter pw = new PrintWriter(
			new File("/home/hduser/APTUS/jspd3Proj2/src/main/webapp/data.csv"));
	StringBuilder sb = new StringBuilder();
	pw.write("id,score\n");
%>
<h2 align="center">
	<font><strong>Retrieve data from database in jsp</strong></font>
</h2>
<table align="center" cellpadding="5" cellspacing="5" border="1">
	<tr>

	</tr>
	<tr bgcolor="#A52A2A">
		<td><b>id</b></td>
		<td><b>score</b></td>
	</tr>
	<%
		try {
			statement = conn.createStatement();
			String sql = "SELECT * FROM "+ table_name;

			resultSet = statement.executeQuery(sql);
			while (resultSet.next()) {
				id = resultSet.getString("id");
				score = resultSet.getString("score");
				sb.append(id);
				sb.append(',');
				sb.append(score);
				sb.append('\n');
				pw.write(sb.toString());
				sb.delete(0, sb.length());
				System.out.println(id + score);
	%>
	<tr bgcolor="#DEB887">

		<td><%=id%></td>
		<td><%=score%></td>

	</tr>
	<%
		}

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
		pw.close();

		System.out.println("done!");
	%>
</table>
<form action="bar-graph.jsp" target="_blank">
	<input type="submit" name="bar-graph" value="Bar Graph"></input>
</form>
<form action="scattered-graph.jsp" target="_blank">
	<input type="submit" name="scattered-graph.jsp" value="Scattered Graph"></input>
</form>
<form action="line-graph.jsp" target="_blank">
	<input type="submit" name="line-graph.jsp" value="Line Graph"></input>
</form>

