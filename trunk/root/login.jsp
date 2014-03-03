<%@ page import="java.sql.*" %>

<%@ include file="/dbconnection.jspf" %>

<%
boolean loggedIn = false;
String username = (String) request.getParameter("username");
String password = (String) request.getParameter("password");
String debug = "Clear";

if (request.getMethod().equals("POST") && username != null) {
	Statement stmt = conn.createStatement();
	ResultSet rs = null;
	try {
		rs = stmt.executeQuery("SELECT * FROM Users WHERE (name = '" + username + "' AND password = '" + password + "')");
		if (rs.next()) {
			loggedIn = true;
			debug="Logged in";
			// We must have been given the right credentials, right? ;)
			// Put credentials in the session
			String userid = "" + rs.getInt("userid");
			session.setAttribute("username", rs.getString("name"));
			session.setAttribute("userid", userid);
			session.setAttribute("usertype", rs.getString("type"));

			// Update the scores
			if (userid.equals("3")) {
				stmt.execute("UPDATE Score SET status = 1 WHERE task = 'LOGIN_TEST'");
			} else if (userid.equals("1")) {
				stmt.execute("UPDATE Score SET status = 1 WHERE task = 'LOGIN_USER1'");
			} else if (userid.equals("2")) {
				stmt.execute("UPDATE Score SET status = 1 WHERE task = 'LOGIN_ADMIN'");
			}

			Cookie[] cookies = request.getCookies();
			String basketId = null;
			if (cookies != null) {
				for (Cookie cookie : cookies) {
					if (cookie.getName().equals("b_id") && cookie.getValue().length() > 0) {
						basketId = cookie.getValue();
						break;
					}
				}
			}
			if (basketId != null) {
				debug += " basketid = " + basketId;
				int cBasketId = rs.getInt("currentbasketid");
				if (cBasketId > 0) {
					// Merge baskets
					debug += " currentbasketid = " + cBasketId;
					stmt.execute("UPDATE BasketContents SET basketid = " + cBasketId + " WHERE basketid = " + basketId);

				} else {
					stmt.execute("UPDATE Users SET currentbasketid = " + basketId + " WHERE userid = " + userid);
				}
				response.addCookie(new Cookie("b_id", ""));
			}

		}
	} catch (Exception e) {
		if ("true".equals(request.getParameter("debug"))) {
			stmt.execute("UPDATE Score SET status = 1 WHERE task = 'HIDDEN_DEBUG'");
			out.println("DEBUG System error: " + e + "<br/><br/>");
		} else {
			out.println("System error.");
		}
	} finally {
		if (rs != null) {
			rs.close();
		}
		stmt.close();
	}
}
%>
<jsp:include page="/header.jsp"/>
<%
if ("true".equals(request.getParameter("debug"))) {
	out.println("DEBUG: " + debug + "<br/><br/>");
}
// Display the form
if (request.getMethod().equals("POST") && username != null) {
	if (loggedIn) {
		if (username.replaceAll("\\s", "").toLowerCase().indexOf("<script>alert(\"xss\")</script>") >= 0) {
			Statement stmt = conn.createStatement();
			try {
				stmt.execute("UPDATE Score SET status = 1 WHERE task = 'XSS_LOGIN'");
			} finally {
				stmt.close();
			}
		}
		out.println("<br/>You have logged in successfully: " + username);
		return;

	} else {
		out.println("<p style=\"color:red\">You supplied an invalid name or password.</p>");

	}
}
%>
<h3>Login</h3>
Please enter your credentials: <br/><br/>
<form method="POST">
	<center>
	<table>
	<tr>
		<td>Username:</td>
		<td><input id="username" name="username"/></td>
	</tr>
	<tr>
		<td>Password:</td>
		<td><input id="password" name="password" type="password"/></td>
	</tr>
	<tr>
		<td></td>
		<td><input id="submit" type="submit" value="Login"/></td>
	</tr>
	</table>
	</center>
</form>
If you dont have an account with us then please <a href="register.jsp">Register</a> now for a free account.
<br/><br/>

<jsp:include page="/footer.jsp"/>

