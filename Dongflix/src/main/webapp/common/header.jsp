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
    Object loginUserObj = session.getAttribute("loginUser");
    boolean isLoggedIn = (loginUserObj != null);

    String currentURL = request.getRequestURI();
    String query = request.getQueryString();
    if (query != null) currentURL += "?" + query;

    // JSP 직접 접근 방지 → 서블릿 경로로 변경
    if (currentURL.contains("movieDetail.jsp")) {
        // movieId 가져오기
        String movieId = request.getParameter("movieId");
        currentURL = request.getContextPath() + "/movieDetail?movieId=" + movieId;
    }

    // 로그인 전만 저장
    if (!isLoggedIn) {
        session.setAttribute("redirectAfterLogin", currentURL);
    }
%>

<div class="mypage">
    <% if (isLoggedIn) { %>

        <a href="${pageContext.request.contextPath}/mypage.do">마이페이지</a> /
        <a href="${pageContext.request.contextPath}/logout.do">로그아웃</a>

    <% } else { %>

        <a href="${pageContext.request.contextPath}/login.jsp">
            로그인
        </a>

    <% } %>
</div>
</header>