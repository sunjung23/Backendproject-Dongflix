<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="com.dongyang.dongflix.MemberDTO" %>

<%
    MemberDTO user = (MemberDTO) session.getAttribute("loginUser");
    if (user == null) {
        response.sendRedirect("login.jsp");
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>환영합니다</title>
</head>
<body>

<h2><%= user.getUsername() %>님 환영합니다!</h2>

<a href="logout.do">로그아웃</a>

</body>
</html>