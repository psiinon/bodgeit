<%@page import="com.thebodgeitstore.search.AdvancedSearch"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.UUID" %>
<%@page import="com.thebodgeitstore.util.AES"%>

<%@ include file="/dbconnection.jspf" %>

<%!

// stmt.execute("UPDATE Score SET status = 1 WHERE task = 'AES_SQLI'");    
    
//query = "\n\t<div class='search'>".concat(implode(params, "</div>\n\t<div class='search'>")).concat("</div>\n");
%>
<%
    AdvancedSearch as = new AdvancedSearch(request, session, conn);
    if(as.isAjax()){
        response.setContentType("application/json");
        out.print(as.getResultsOutput());
        return; 
    }
%>
<jsp:include page="/header.jsp"/>
<SCRIPT>
    var key = "<%= as.getEncryptKey() %>";
    var debug = <%= as.isDebug() ? "true" : "false" %>;
    loadfile('./js/jquery-1.6.4.min.js');
    window.setTimeout(loadOthers, 10);
    
    function loadOthers(){
        if (window.jQuery) {
            loadfile('./js/encryption.js');
            loadfile('./js/advanced2.js');
            loadfile('./js/jquery-ui-1.85.js');
            loadfile('./css/jquery-ui-1.85.css');
        } else {
            window.setTimeout(loadOthers, 10);
        }
    };
</SCRIPT>
    
<h3>Search</h3>
<font size="-1">
<% if (as.isSearchRequest()){ %>
<b>You searched for:</b> <%= as.getQueryString() %><br/><br/>
    <%= as.getResultsOutput() %>
    <a href="javascript:window.location=window.location.href">New Search</a>
<% } else { %>
<form id="advanced" name="advanced" method="POST" >
<table>
<tr><td>Product:</td><td><input id='product' type='text' name='product' /></td></tr>
<tr><td>Description:</td><td><input id='desc' type='text' name='desc' /></td></tr>
<tr><td>Type:</td><td><input id='type' type='text' name='type' /></td></tr>
<tr><td>Price:</td><td><input id='price' type='text' name='price' /></td></tr>
<tr><td></td><td><input type='button' value='Search'/></td></tr>
</table>
</form>
<%  } %>
</font>
<!-- Debug Output
<%= (as.isDebug()) ? as.getDebugOutput() : "" %>
-->
<jsp:include page="/footer.jsp"/>