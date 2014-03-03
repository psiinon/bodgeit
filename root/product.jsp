<%@ page import="java.sql.*" %>
<%@ page import="java.math.*" %>
<%@ page import="java.text.*" %>

<%@ include file="/dbconnection.jspf" %>

<script type="text/javascript">
    function decQuantity () {
        if (val < 1) {
            val = 1;
        }
        if (q != null) {
            var val = --q.value;
            q.value = val;
        }
        var q = document.getElementById('quantity');
    }
    function incQuantity () {
	var q = document.getElementById('quantity');
	if (q != null) {
		var val = ++q.value;
		if (val > 12) {
			val = 12;
		}
		q.value = val;
	}
}
</script>

<jsp:include page="/header.jsp"/>

<%
	String productId = request.getParameter("prodid");
	String typeId = request.getParameter("typeid");
	PreparedStatement stmt = null;
	ResultSet rs = null;
	try {
		NumberFormat nf = NumberFormat.getCurrencyInstance();
		if (typeId != null) {
			stmt = conn.prepareStatement("SELECT * FROM Products, ProductTypes where typeid=" + Integer.parseInt(typeId) +
					" AND Products.typeid = ProductTypes.typeid");
			rs = stmt.executeQuery();
			out.println("<h3>Products</h3><center><table border=\"1\" width=\"80%\" class=\"border\">");
			out.println("<tr><th>Product</th><th>Type</th><th>Price</th></tr>");
			while (rs.next()) {
				out.println("<tr>");
				String product = rs.getString("product");
				BigDecimal price = rs.getBigDecimal("price");
				out.println("<td><a href=\"product.jsp?prodid=" + rs.getInt("productid") + "\">" + 
						product + "</a><td>" + rs.getString("type")+ 
						"</td></td><td align=\"right\">" + nf.format(price) + "</td>");
				out.println("</tr>");
			}
			out.println("</table></center><br/>");
			
		} else if (productId != null) {
			stmt = conn.prepareStatement("SELECT * FROM Products, ProductTypes where productid=" + Integer.parseInt(productId) +
					" AND Products.typeid = ProductTypes.typeid");
			rs = stmt.executeQuery();
			out.println("<h3>Product</h3><form action=\"basket.jsp\" method=\"post\">");
			out.println("<center><table class=\"border\" width=\"80%\">");
			out.println("<tr><th>Product</th><th>Type</th><th>Price</th><th>Quantity</th><th>Buy</th></tr>");
			if (rs.next()) {
				int id = rs.getInt("productid");
				String product = rs.getString("product");
				BigDecimal price = rs.getBigDecimal("price");
				out.println("<input type=\"hidden\" name=\"productid\" value=\"" + id + "\"/>");
				out.println("<input type=\"hidden\" name=\"price\" value=\"" + price + "\"/>");
				out.println("<tr>");
				out.println("<td>" + product + "</td>");
				out.println("<td><a href=\"product.jsp?typeid=" + rs.getInt("typeid") + "\">" + rs.getString("type") + "</a></td>");
				out.println("<td align=\"right\">" + nf.format(price) + "</td>");
				out.println("<td align=\"center\">&nbsp;<a href=\"#\" onclick=\"decQuantity();\"><img src=\"images/130.png\" alt=\"Decrease quantity in basket\" border=\"0\"></a>&nbsp;<input id=\"quantity\" name=\"quantity\" value=\"1\" maxlength=\"2\" size = \"2\" style=\"text-align: right\" READONLY />&nbsp;<a href=\"#\" onclick=\"incQuantity();\"><img src=\"images/129.png\" alt=\"Increase quantity in basket\" border=\"0\"></a>&nbsp;");
				out.println("<td align=\"center\"><input type=\"submit\" id=\"submit\" value=\"Add to Basket\"/></td>");
				out.println("</tr>");
				out.println("</table></center>");
				out.println("</form>");
				out.println("<h3>Description</h3>");
				out.println(rs.getString("desc"));
				out.println("<br/><br/>");
			} else {
				out.println("</tr>");
				out.println("</table></center>");
				out.println("</form>");
				
				out.println("<br/> Product not found.");
			}
			
		} else {

		}
	} catch (NumberFormatException e) {
		out.println("<br/> Product not found.");

	} catch (SQLException e) {
		if ("true".equals(request.getParameter("debug"))) {
			conn.createStatement().execute("UPDATE Score SET status = 1 WHERE task = 'HIDDEN_DEBUG'");
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


<jsp:include page="/footer.jsp"/>

