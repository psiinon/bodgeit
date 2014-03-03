<%@page import="org.apache.commons.lang3.StringEscapeUtils"%>
<%@ page import="java.sql.*" %>

<%@ include file="/dbconnection.jspf" %>
<jsp:include page="/header.jsp"/>

<h3>Search</h3>
<font size="-1">
<%
String query = (String) request.getParameter("q");

if (request.getMethod().equals("GET") && query != null){
        if (query.replaceAll("\\s", "").toLowerCase().indexOf("<script>alert(\"xss\")</script>") >= 0) {
                conn.createStatement().execute("UPDATE Score SET status = 1 WHERE task = 'SIMPLE_XSS'");
        }
    
%>
<b>You searched for:</b> <%= query %><br/><br/>
<%    
    Statement stmt = conn.createStatement();
	ResultSet rs = null;
        query = StringEscapeUtils.escapeHtml4(query).replaceAll("'", "&#39");

	try {
                String sql = "SELECT PRODUCT, DESC, TYPE, TYPEID, PRICE " +
                             "FROM PRODUCTS AS a JOIN PRODUCTTYPES AS b " +
                             "ON a.TYPEID = b.TYPEID " +
                             "WHERE PRODUCT LIKE '%" + query + "%' OR " + 
                             "DESC LIKE '%" + query + "%' OR PRICE LIKE '%" + query + "%' " +
                             "OR TYPE LIKE '%" + query + "%'";
                
                if ("true".equals(request.getParameter("debug")))
                    out.println(sql);
		rs = stmt.executeQuery(sql);
              
                int count = 0;
                String output = "";
                while (rs.next()) {
                    output = output.concat("<TR><TD>" + rs.getString("PRODUCT") + 
                                  "</TD><TD>" + rs.getString("DESC") + 
                                  "</TD><TD>" + rs.getString("TYPE") + 
                                  "</TD><TD>" + rs.getString("PRICE") + "</TD></TR>\n");
                    count++;
                }
                if(count > 0){
%>
<TABLE border="1">
<TR><TD>Product</TD><TD>Description</TD><TD>Type</TD><TD>Price</TD></TR>
<%= output %>
</TABLE>                    
<%              
                } else {   
                    out.println("<div><b>No Results Found</b></div>");
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
} else {
%>
<FORM name='query' method='GET'>
<table>
<tr><td>Search for</td><td><input type='text' name='q'></td></td>
<tr><td></td><td><input type='submit' value='Search'/></td></td>
<tr><td></td><td><a href='advanced.jsp' style='font-size:9pt;'>Advanced Search</a></td></td>
</table>
</form>
<%  
}
%>
</font>
<jsp:include page="/footer.jsp"/>