<%@ page import="java.sql.*" %>
<%@ page import="java.util.UUID" %>
<%@page import="com.thebodgeitstore.util.AES"%>
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
        
        public static String implode(String[] ary, String delim) {
            String out = "";
            for(int i=0; i<ary.length; i++) {
                if(i!=0) { out += delim; }
                out += ary[i];
            }
            return out;
        }
        
%>
<jsp:include page="/header.jsp"/>
<%
    String query = null;
    String key = "";
    String[] params = {};
    if (request.getMethod().equals("POST")){
        AES enc = new AES();
        try {
            key = session.getAttribute("key").toString();
        } catch (Exception e){
            key = UUID.randomUUID().toString().substring(0, 16);
        }
        if ("true".equals(request.getParameter("debug")))
            out.println("<!--".concat(key).concat("-->"));
        
        enc.setCrtKey(key);
        String eQuery = (String) request.getParameter("q");
        query = enc.decryptCrt(eQuery);
        query = query.replaceAll("[^\\p{ASCII}]", "");
        params = query.split("\\|");
        query = "\n\t<div class='search'>".concat(implode(params, "</div>\n\t<div class='search'>")).concat("</div>\n");
    } else { 
        key = UUID.randomUUID().toString().substring(0, 16);
        session.setAttribute("key", key);
    }
%>
<SCRIPT>
    loadfile('./js/encryption.js');
    
    var key = "<%= key %>";
    
    function validateForm(form){
        var query = document.getElementById('query');
        var q = document.getElementById('q');
        var val = encryptForm(key, form);
        if(val){
            q.value = val;
            query.submit();
        }   
        return false;
    }
    
    function encryptForm(key, form){
        var params = form_to_params(form).replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;').replace(/'/g, '&#39');
        if(params.length > 0)
            return Aes.Ctr.encrypt(params, key, 128);
        return false;
    }
    
    
    
</SCRIPT>
    
<h3>Search</h3>
<font size="-1">
<%

if (request.getMethod().equals("POST") && query != null){
          
        
%>
<b>You searched for:</b> <%= query %><br/><br/>
<%    
        if (query.replaceAll("\\s", "").toLowerCase().indexOf("<script>alert(\"h@ckeda3s\")</script>") > -1) {
                conn.createStatement().execute("UPDATE Score SET status = 1 WHERE task = 'AES_XSS'");
        }

        Statement stmt = conn.createStatement();
	ResultSet rs = null;
	try {
                String sql = "SELECT PRODUCT, DESC, TYPE, TYPEID, PRICE " +
                             "FROM PRODUCTS AS a JOIN PRODUCTTYPES AS b " +
                             "ON a.TYPEID = b.TYPEID " +
                             "WHERE PRODUCT LIKE '%{PRODUCT}%' AND " + 
                             "DESC LIKE '%{DESCRIPTION}%' AND PRICE LIKE '%{PRICE}%' " +
                             "AND TYPE LIKE '%{TYPE}%'";
               
                for(int x = 0; x < params.length; x++){
                    String[] parm = params[x].split(":");
                    if(parm.length == 2){
                        String find = "\\{".concat(parm[0].toUpperCase()).concat("\\}");
                        sql = sql.replaceAll(find, parm[1]);
                    }
                    
                }
                sql = sql.replaceAll("%\\{[^\\}]+\\}", "");
                if ("true".equals(request.getParameter("debug")))
                    out.println(sql);
		rs = stmt.executeQuery(sql);
              
                int count = 0;
                String output = "";
                while (rs.next()) {
                    //A random table was created an inserted into table list.
                    //Since there are many SQL statements that could return a list
                    //of tables, this validates without requiring a specific input.
                    String tableName = "f0ecfb32e56d3845f140e5c81a81363ce61d9d50";
                    if( rs.getString("PRODUCT").toLowerCase().indexOf(tableName) > -1 || 
                        rs.getString("DESC").toLowerCase().indexOf(tableName) > -1 || 
                        rs.getString("TYPE").toLowerCase().indexOf(tableName) > -1 || 
                        rs.getString("PRICE").toLowerCase().indexOf(tableName) > -1      )
                            stmt.execute("UPDATE Score SET status = 1 WHERE task = 'AES_SQLI'");
                        
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
<form id="advanced" name="advanced" method="POST" onsubmit="return validateForm(this);false;">
<table>
<tr><td>Product:</td><td><input id='product' type='text' name='product' /></td></td>
<tr><td>Description:</td><td><input id='desc' type='text' name='description' /></td></td>
<tr><td>Type:</td><td><input id='type' type='text' name='type' /></td></td>
<tr><td>Price:</td><td><input id='price' type='text' name='price' /></td></td>
<tr><td></td><td><input type='submit' value='Search'/></td></td>
</table>
</form>
<form id="query" name="advanced" method="POST">
    <input id='q' type="hidden" name="q" value="" />
</form>
<%  
}
%>
</font>
<jsp:include page="/footer.jsp"/>