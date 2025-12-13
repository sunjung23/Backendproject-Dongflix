<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="com.dongyang.dongflix.model.TMDBmovie" %>

<html>
<head>
    <!-- ① header.css 먼저 -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/header.css">
    <!-- ② 페이지 전용 CSS는 항상 마지막 -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/searchMovie.css">
    <title>Dongflix - 탐색</title>
</head>

<body>

<%@ include file="/common/header.jsp" %>


<div class="search-container">
<form action="${pageContext.request.contextPath}/searchMovie" method="get">
        <!-- 검색창 -->
        <input type="text" name="keyword" placeholder="영화 제목 검색..."
               value="${keyword}" class="search-input">

        <!-- 장르 선택 -->
        <select name="genre" class="select-box">
            <option value="">전체</option>
            <option value="28"  ${genre == '28'  ? "selected" : ""}>액션</option>
            <option value="16"  ${genre == '16'  ? "selected" : ""}>애니메이션</option>
            <option value="80"  ${genre == '80'  ? "selected" : ""}>범죄</option>
            <option value="14"  ${genre == '14'  ? "selected" : ""}>판타지</option>
            <option value="10749" ${genre == '10749' ? "selected" : ""}>로맨스</option>
            <option value="36" ${genre == '36' ? "selected" : ""}>역사</option>
            <option value="35" ${genre == '35' ? "selected" : ""}>코미디</option>
            <option value="27" ${genre == '27' ? "selected" : ""}>호러</option>
            <option value="10751" ${genre == '10751' ? "selected" : ""}>가족</option>
            <option value="9648" ${genre == '9648' ? "selected" : ""}>미스터리</option>
        </select>


        <button class="search-btn">검색</button>
    </form>
</div>

<!-- 영화 리스트 -->
<div class="movie-grid">
    <%
        List<TMDBmovie> movieList = (List<TMDBmovie>) request.getAttribute("movies");
        if (movieList != null) {
            for (TMDBmovie m : movieList) {
    %>
        <div class="movie-card">
            <a href="movieDetail?movieId=<%= m.getId() %>">
                <img src="<%= m.getPosterUrl() %>" alt="">
            </a>
            <div class="movie-title"><%= m.getTitle() %></div>
        </div>
    <%
            }
        }
    %>
</div>

</body>
</html>