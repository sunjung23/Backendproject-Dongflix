<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/header.css">

<header>
    <div class="logo">
        <a href="${pageContext.request.contextPath}/indexMovie">
            <img src="${pageContext.request.contextPath}/img/logo.png">
        </a>
    </div>

    <nav>
        <ul>
            <li><a href="${pageContext.request.contextPath}/indexMovie">홈</a></li>
            <li><a href="${pageContext.request.contextPath}/searchMovie">탐색</a></li>
            <li><a href="${pageContext.request.contextPath}/board/list">게시판</a></li>
        </ul>
    </nav>

    <%
        Object loginUser = session.getAttribute("loginUser");
    %>

    <div class="mypage">
        <% if (loginUser != null) { %>
            <a href="${pageContext.request.contextPath}/mypage.do">마이페이지</a> /
            <a href="${pageContext.request.contextPath}/logout.do">로그아웃</a>
        <% } else { %>
            <a href="${pageContext.request.contextPath}/login.jsp">로그인</a>
        <% } %>
    </div>
</header>