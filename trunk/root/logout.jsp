<%@ page import="java.sql.*" %>
<%
session.setAttribute("username", null);
session.setAttribute("usertype", null);
session.setAttribute("userid", null);
%>
<jsp:include page="/header.jsp"/>

<br/><p style="color:green">Thank you for your custom.</p><br/>

<jsp:include page="/footer.jsp"/>

