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

String password1 = (String) request.getParameter("password1");
String password2 = (String) request.getParameter("password2");
String okresult = null;
String failresult = null;

if (password1 != null && password1.length() > 0) {
	if ( ! password1.equals(password2)) {
		failresult = "The passwords you have supplied are different.";
	}  else if (password1 == null || password1.length() < 5) {
		failresult = "You must supply a password of at least 5 characters.";
	} else {
		Statement stmt = conn.createStatement();
		ResultSet rs = null;
		try {
			stmt.executeQuery("UPDATE Users set password= '" + password1 + "' where name = '" + username + "'");
			
			okresult = "Your password has been changed";

			if (request.getMethod().equals("GET")) {
				conn.createStatement().execute("UPDATE Score SET status = 1 WHERE task = 'PASSWD_GET'");
			}

		} catch (Exception e) {
			failresult = "System error.";
		} finally {
			stmt.close();
		}

	}
}

%>
<h3>Your profile</h3>
<%
if (failresult != null) {
	out.println("<p style=\"color:red\">" + failresult + "</p><br/>");
}
if (okresult != null) {
	out.println("<p style=\"color:green\">" + okresult + "</p><br/>");
}
%>
Change your password: <br/><br/>
<form method="POST">
	<center>
	<table>
	<tr>
		<td>Name</td>
		<td><%=username%></td>
	</tr>
	<tr>
		<td>New Password:</td>
		<td><input id="password1" name="password1" type="password"></input></td>
	</tr>
	<tr>
		<td>Repeat Password:</td>
		<td><input id="password2" name="password2" type="password"></input></td>
	</tr>
	<tr>
		<td></td>
		<td><input id="submit" type="submit" value="Submit"></input></td>
	</tr>
	</table>
	</center>
</form>

<%


%>

<jsp:include page="/footer.jsp"/>

