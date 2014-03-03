<%@ page import="java.sql.*" %>

<%@ include file="/dbconnection.jspf" %>
<jsp:include page="/header.jsp"/>

<h3>Your Score</h3>
Here are at least some of the vulnerabilities that you can try and exploit:<br/><br/>

<%
	PreparedStatement stmt = null;
	ResultSet rs = null;
	try {
			stmt = conn.prepareStatement("SELECT * FROM Score ORDER by scoreid");
			rs = stmt.executeQuery();
			out.println("<center><table class=\"border\" width=\"80%\">");
			out.println("<tr><th>Challenge</th><th>Done?</th></tr>");
			while (rs.next()) {
				out.println("<tr>");
				out.println("<td>" + rs.getString("description") + "</td>");
				out.println("<td>");
				int status = rs.getInt("status"); 
				if (status > 0) {
					out.println("<img src=\"images/152.png\" alt=\"Completed\" title=\"Completed\" border=\"0\">");
				} else if (status == 0) {
					out.println("<img src=\"images/151.png\" alt=\"Not completed\" title=\"Not completed\" border=\"0\">");
				} else {
					out.println("<img src=\"images/154.png\" alt=\"Not implemented/tested yet :(\" title=\"Not implemented/tested yet :(\" border=\"0\">");
				}
				out.println("</td>");
				out.println("</tr>");
			}
			out.println("</table></center>");
	

	} catch (SQLException e) {
		if ("true".equals(request.getParameter("debug"))) {
			out.println("DEBUG System error: " + e + "<br/><br/>");
		} else {
			out.println("System error.");
		}
	} finally {
		if (stmt != null) {
			stmt.close();
		}
		if (rs != null) {
			rs.close();
		}
	}
%>
<br/>

<jsp:include page="/footer.jsp"/>

