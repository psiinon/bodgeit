<%@ page import="java.sql.*" %>
<%@ page import="java.math.*" %>
<%@ page import="java.text.*" %>
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

<h3>Our Best Deals!</h3>
<%
	PreparedStatement stmt = null;
	ResultSet rs = null;
	try {
		stmt = conn.prepareStatement("SELECT COUNT (*) FROM Products");
		rs = stmt.executeQuery();
		rs.next();
		int count = rs.getInt(1);
		rs.close();
		stmt.close();
		out.println("<center><table border=\"1\" class=\"border\" width=\"80%\">");
		out.println("<tr><th>Product</th><th>Type</th><th>Price</th></tr>");
		
		NumberFormat nf = NumberFormat.getCurrencyInstance();
		for (int i=0; i < 10; i++) {
			stmt = conn.prepareStatement("SELECT * FROM Products, ProductTypes WHERE Products.productid = " + ((int)(Math.random() * count) + 1) + " AND Products.typeid = ProductTypes.typeid");
			rs = stmt.executeQuery();
			if (rs.next()) {
				out.println("<tr>");
				String product = rs.getString("product");
				String type = rs.getString("type");
				BigDecimal price = rs.getBigDecimal("price");
				out.println("<td><a href=\"product.jsp?prodid=" + rs.getInt("productid") + "\">" + 
						product + "</a></td><td>" + type + "</td><td align=\"right\">" + nf.format(price) + "</td>");
				out.println("</tr>");
			}
			stmt.close();
			rs.close();
		}
		out.println("</table></center><br/>");
	} catch (SQLException e) {
		if ("true".equals(request.getParameter("debug"))) {
			out.println("DEBUG System error: " + e + "<br/><br/>");
		} else {
			out.println("System error.");
		}
	}
%>

<jsp:include page="/footer.jsp"/>

