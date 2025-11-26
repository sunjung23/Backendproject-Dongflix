<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.dongyang.dongflix.model.TMDBmovie" %>

<%
    if (request.getAttribute("fromServlet") == null) {
        response.sendRedirect("indexMovie");
        return;
    }
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>DONGFLIX</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
</head>
<body>

<header>
    <div class="logo"><img src="img/logo.png"></div>
    <nav>
        <ul>
            <li><a href="indexMovie">홈</a></li>
            <li><a href="#">영화</a></li>
            <li><a href="#">시리즈</a></li>
        </ul>
    </nav>
    <div class="mypage"><a href="mypage.jsp">마이페이지 / </a><a href="logout.do"> 로그아웃</a></div>
</header>

<div class="main-banner">
    <h1>오늘의 추천 영화</h1>
    <p><a href="#">추천글 보러 가기</a></p>
</div>

<!-- 애니메이션 -->
<div class="category">애니메이션</div>
<div class="movie-grid">
<%
    List<TMDBmovie> animation = (List<TMDBmovie>) request.getAttribute("animationList");
    if (animation != null) {
        for (TMDBmovie m : animation) {
%>
    <div class="movie">
        <img src="<%= m.getPosterUrl() %>" alt="<%= m.getTitle() %>">
        <div class="hover-info"><%= m.getOverview() %></div>
    </div>
<%
        }
    }
%>
</div>

<!-- 로맨스 -->
<div class="category">로맨스</div>
<div class="movie-grid">
<%
    List<TMDBmovie> romance = (List<TMDBmovie>) request.getAttribute("romanceList");
    if (romance != null) {
        for (TMDBmovie m : romance) {
%>
    <div class="movie">
        <img src="<%= m.getPosterUrl() %>" alt="<%= m.getTitle() %>">
        <div class="hover-info"><%= m.getOverview() %></div>
    </div>
<%
        }
    }
%>
</div>

<!-- 액션 -->
<div class="category">액션 / 스릴러</div>
<div class="movie-grid">
<%
    List<TMDBmovie> action = (List<TMDBmovie>) request.getAttribute("actionList");
    if (action != null) {
        for (TMDBmovie m : action) {
%>
    <div class="movie">
        <img src="<%= m.getPosterUrl() %>" alt="<%= m.getTitle() %>">
        <div class="hover-info"><%= m.getOverview() %></div>
    </div>
<%
        }
    }
%>
</div>

</body>
</html>