<%@ page import="java.sql.*" %>
<%!
	private Connection conn = null;

	public void jspInit() {
		try {
			// Get hold of the JDBC driver
			Class.forName("org.hsqldb.jdbcDriver" );
			// Establish a connection to an in memory db
			conn = DriverManager.getConnection("jdbc:hsqldb:mem:SQL", "sa", "");
		} catch (SQLException e) {
			getServletContext().log("Db error: " + e);
		} catch (Exception e) {
			getServletContext().log("System error: " + e);
		}
	}
	
	public void jspDestroy() {
		try {
			if (conn != null) {
				conn.close();
			}
		} catch (SQLException e) {
			getServletContext().log("Db error: " + e);
		} catch (Exception e) {
			getServletContext().log("System error: " + e);
		}
	}
%>
<jsp:include page="/header.jsp"/>

<%
String username = (String) session.getAttribute("username");
String usertype = (String) session.getAttribute("usertype");


String comments = (String) request.getParameter("comments");

if (request.getMethod().equals("POST") && comments != null) {

	PreparedStatement stmt = conn.prepareStatement("INSERT INTO Comments (name, comment) VALUES (?, ?)");
	ResultSet rs = null;
	try {
		stmt.setString(1, username);
		stmt.setString(2, comments);
		stmt.execute();

		out.println("Thank you for your feedback.");

		return;

	} catch (SQLException e) {
		out.println("System error.<br/><br/>" + e);
	} catch (Exception e) {
		out.println("System error.<br/><br/>" + e);
	} finally {
		stmt.close();
	}
}

if (usertype != null && usertype.endsWith("ADMIN")) {
	// Display all of the messages
	ResultSet rs = null;
	PreparedStatement  stmt = conn.prepareStatement("SELECT * FROM Comments");
	try {
		rs = stmt.executeQuery();
		out.println("<br/><center><table border=\"1\" width=\"80%\" class=\"border\">");
		out.println("<tr><th>User</th><th>Comment</th></tr>");
		while (rs.next()) {
			out.println("<tr>");
			out.println("<td>" + rs.getString("name") + "</td><td>" + rs.getString("comment") + "</td>");
			out.println("</tr>");
		}
		out.println("</table></center><br/>");
	} catch (Exception e) {
		if ("true".equals(request.getParameter("debug"))) {
			conn.createStatement().execute("UPDATE Score SET status = 1 WHERE task = 'HIDDEN_DEBUG'");
			out.println("DEBUG System error: " + e + "<br/><br/>");
		} else {
			out.println("System error.");
		}
	} finally {
		stmt.close();
	}

} else {
	// Display the message form
%>
<h3>Contact Us</h3>
Please send us your feedback: <br/><br/>
<form method="POST">
	<input type="hidden" id="user" name="<%=username%>" value=""/>
	<center>
	<table>
	<tr>
		<td><textarea id="comments" name="comments" cols=80 rows=8></textarea></td>
	</tr>
	<tr>
		<td><input id="submit" type="submit" value="Submit"></input></td>
	</tr>
	</table>
	</center>
</form>

<%
}

%>

<jsp:include page="/footer.jsp"/>

