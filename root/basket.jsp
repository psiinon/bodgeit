<%@page import="java.net.URL"%>
<%@ page import="java.servlet.http.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.math.*" %>
<%@ page import="java.text.*" %>
<%@ page import="java.util.*" %>

<%@ include file="/dbconnection.jspf" %>

<script type="text/javascript">
    function incQuantity (prodid) {
    var q = document.getElementById('quantity_' + prodid);
    if (q != null) {
        var val = ++q.value;
        if (val > 12) {
            val = 12;
        }
        q.value = val;
    }
}
function decQuantity (prodid) {
    var q = document.getElementById('quantity_' + prodid);
    if (q != null) {
        var val = --q.value;
        if (val < 0) {
            val = 0;
        }
        q.value = val;
    }
}
</script>

<jsp:include page="/header.jsp"/>

<h3>Your Basket</h3>
<%
	String userid = (String) session.getAttribute("userid");
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
		// Dont need to do anything else
			
		// Well, apart from checking to see if they've accessed someone elses basket ;)
		Statement stmt = conn.createStatement();
		try {
			ResultSet rs = stmt.executeQuery("SELECT * FROM Baskets WHERE basketid = " + basketId);
			rs.next();
			String bUserId = "" + rs.getInt("userid");
			if ((userid == null && ! bUserId.equals("0")) || (userid != null && userid.equals(bUserId))) {
				conn.createStatement().execute("UPDATE Score SET status = 1 WHERE task = 'OTHER_BASKET'");
			}

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

	} else if (userid == null) {
		// Not logged in, and no basket, so create one
		Statement stmt = conn.createStatement();
		try {
			Timestamp ts = new Timestamp((new java.util.Date()).getTime());
			stmt.execute("INSERT INTO Baskets (created) VALUES ('" + ts + "')");
			ResultSet rs = stmt.executeQuery("SELECT * FROM Baskets WHERE created = '" + ts + "'");
			rs.next();
			basketId = "" + rs.getInt("basketid");

			response.addCookie(new Cookie("b_id", basketId));

		} catch (Exception e) {
			if ("true".equals(request.getParameter("debug"))) {
				conn.createStatement().execute("UPDATE Score SET status = 1 WHERE task = 'HIDDEN_DEBUG'");
				out.println("DEBUG System error: " + e + "<br/><br/>");
			} else {
				out.println("System error.");
			}
			return;

		} finally {
			stmt.close();
		}
	} else {
		Statement stmt = conn.createStatement();
		try {
			ResultSet rs = stmt.executeQuery("SELECT * FROM Users WHERE userid = " + userid + "");
			rs.next();
			int bId = rs.getInt("currentbasketid");
			if (bId > 0) {
				basketId = "" + bId;
			} else {
				// Need to create one
				Timestamp ts = new Timestamp((new java.util.Date()).getTime());
				stmt.execute("INSERT INTO Baskets (created, userid) VALUES ('" + ts + "', " + userid + ")");
				rs = stmt.executeQuery("SELECT * FROM Baskets WHERE (userid = " + userid + ")");
				rs.next();
				basketId = "" + rs.getInt("basketid");
				stmt.execute("UPDATE Users SET currentbasketid = " + basketId + " WHERE userid = " + userid);
			}
			
		} catch (SQLException e) {
			if ("true".equals(request.getParameter("debug"))) {
				conn.createStatement().execute("UPDATE Score SET status = 1 WHERE task = 'HIDDEN_DEBUG'");
				out.println("DEBUG System error: " + e + "<br/><br/>");
			} else {
				out.println("System error.");
			}
			return;

		} catch (Exception e) {
			if ("true".equals(request.getParameter("debug"))) {
				conn.createStatement().execute("UPDATE Score SET status = 1 WHERE task = 'HIDDEN_DEBUG'");
				out.println("DEBUG System error: " + e + "<br/><br/>");
			} else {
				out.println("System error.");
			}
			return;

		} finally {
			stmt.close();
		}
		
	}
	if ("true".equals(request.getParameter("debug"))) {
		conn.createStatement().execute("UPDATE Score SET status = 1 WHERE task = 'HIDDEN_DEBUG'");
		out.println("DEBUG basketid = " + basketId + "<br/><br/>");
	}
	
	PreparedStatement stmt = null;
	ResultSet rs = null;

	String update = request.getParameter("update");
	String productId = request.getParameter("productid");
	
	if (productId != null && request.getParameterMap().containsKey("quantity")) {
                //Check for CSRF for Scoring by looking at the referrer
                String referer = request.getHeader("referer");
                //Set URL, if referer field is blank, someone is messing with things and probably gets this challenge
                URL url = (referer == null) ? new URL("https://www.google.com") : new URL(referer);
                if(!url.getFile().startsWith(request.getContextPath() + "/product.jsp?prodid=")){
                    conn.createStatement().execute("UPDATE Score SET status = 1 WHERE task = 'CSRF_BASKET'");
                }
                
		// Add product
		String quantity = request.getParameter("quantity");
		try {
			// Product in basket?
			int currentQuantity = 0;
			
			stmt = conn.prepareStatement("SELECT * FROM BasketContents WHERE basketid=" + basketId + " AND productid = " + productId);
			rs = stmt.executeQuery();
			if (rs.next()) {
                                quantity = String.valueOf(Integer.parseInt(quantity) + rs.getInt("quantity"));
				rs.close();
				stmt.close();
				stmt = conn.prepareStatement("UPDATE BasketContents SET quantity = " + Integer.parseInt(quantity) + 
						" WHERE basketid=" + basketId + " AND productid = " + productId);
				stmt.execute();
				if (Integer.parseInt(quantity) < 0) {
					conn.createStatement().execute("UPDATE Score SET status = 1 WHERE task = 'NEG_BASKET'");
				}
			} else {
				rs.close();
				stmt.close();
				stmt = conn.prepareStatement("SELECT * FROM Products where productid=" + productId);
				rs = stmt.executeQuery();
				if (rs.next()) {
					Double price = rs.getDouble("price"); 
					rs.close();
					stmt.close();
					stmt = conn.prepareStatement("INSERT INTO BasketContents (basketid, productid, quantity, pricetopay) VALUES (" +
							basketId + ", " + productId + ", " + Integer.parseInt(quantity) + ", " + price + ")");
					stmt.execute();
					if (Integer.parseInt(quantity) < 0) {
						conn.createStatement().execute("UPDATE Score SET status = 1 WHERE task = 'NEG_BASKET'");
					}
				}
			}
			out.println("Your basket had been updated.<br/>");
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
	} else if (update != null) {
		// Update the basket
		Map params = request.getParameterMap();
		Iterator iter = params.entrySet().iterator();
		while (iter.hasNext()) {
			Map.Entry entry = (Map.Entry) iter.next();
			String key = (String) entry.getKey();
			String value = ((String[]) entry.getValue())[0];
			if (key.startsWith("quantity_")) {
				String prodId = key.substring(9);
				if (value.equals("0")) {
					stmt = conn.prepareStatement("DELETE FROM BasketContents WHERE basketid=" + basketId +
							" AND productid = " + prodId);
					stmt.execute();
					stmt.close();						
				} else {
					stmt = conn.prepareStatement("UPDATE BasketContents SET quantity = " + Integer.parseInt(value) + " WHERE basketid=" + basketId +
							" AND productid = " + prodId);
					stmt.execute();
					if (Integer.parseInt(value) < 0) {
						conn.createStatement().execute("UPDATE Score SET status = 1 WHERE task = 'NEG_BASKET'");
					}
				}
			}
		}
		out.println("<p style=\"color:green\">Your basket had been updated.</p><br/>");
	}
	
	// Display basket
	try {
		stmt = conn.prepareStatement("SELECT * FROM BasketContents, Products where basketid=" + basketId + 
				" AND BasketContents.productid = Products.productid");
		rs = stmt.executeQuery();
		out.println("<form action=\"basket.jsp\" method=\"post\">");
		out.println("<table border=\"1\" class=\"border\" width=\"80%\">");
		out.println("<tr><th>Product</th><th>Quantity</th><th>Price</th><th>Total</th></tr>");
		BigDecimal basketTotal = new BigDecimal(0);
		NumberFormat nf = NumberFormat.getCurrencyInstance();
		while (rs.next()) {
			out.println("<tr>");
			String product = rs.getString("product");
			int prodId = rs.getInt("productid");
			BigDecimal pricetopay = rs.getBigDecimal("pricetopay");
			int quantity = rs.getInt("quantity");
			BigDecimal total = pricetopay.multiply(new BigDecimal(quantity));
			basketTotal = basketTotal.add(total);
			
			out.println("<td><a href=\"product.jsp?prodid=" + rs.getInt("productid") + "\">" + product + "</a></td>"); 
			out.println("<td style=\"text-align: center\">&nbsp;<a href=\"#\" onclick=\"decQuantity(" + prodId + ");\"><img src=\"images/130.png\" alt=\"Decrease quantity in basket\" border=\"0\"></a>&nbsp;" +
					"<input id=\"quantity_" + prodId + "\" name=\"quantity_" + prodId + "\" value=\"" + quantity + "\" maxlength=\"2\" size = \"2\" " +
					"style=\"text-align: right\" READONLY />&nbsp;<a href=\"#\" onclick=\"incQuantity(" + prodId + ");\"><img src=\"images/129.png\" alt=\"Increase quantity in basket\" border=\"0\"></a>&nbsp;" +
					"</td>");
			out.println("<td align=\"right\">" + nf.format(pricetopay) + "</td>");
			out.println("</td><td align=\"right\">" + nf.format(total) + "</td>");
			out.println("</tr>");
		}
		out.println("<tr><td>Total</td><td style=\"text-align: center\">" + "<input id=\"update\" name=\"update\" type=\"submit\" value=\"Update Basket\"/>" + "</td><td>&nbsp;</td>" +
				"<td align=\"right\">" + nf.format(basketTotal) + "</td></tr>");
		out.println("</table>");
		out.println();
		out.println("</form>");
	
	} catch (SQLException e) {
		if ("true".equals(request.getParameter("debug"))) {
			stmt.execute("UPDATE Score SET status = 1 WHERE task = 'HIDDEN_DEBUG'");
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

