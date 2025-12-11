<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="com.dongyang.dongflix.model.TMDBmovie" %>

<%
    TMDBmovie movie = (TMDBmovie) request.getAttribute("movie");

    if (movie == null) {
        response.sendRedirect(request.getContextPath() + "/indexMovie");
        return;
    }
%>

<%@ include file="/common/header.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>영화 일기 작성 - <%= movie.getTitle() %></title>
    <link rel="stylesheet" type="text/css" 
          href="<%= request.getContextPath() %>/css/writeDiary.css?v=<%= System.currentTimeMillis() %>">
</head>
<body>

<div class="diary-container">
    <h2>📘 영화 일기 작성</h2>

    <div class="movie-info">
        <img src="<%= movie.getPosterUrl() %>" alt="포스터">
        <div>
            <div class="movie-title"><%= movie.getTitle() %></div>
            <div>개봉일: <%= movie.getReleaseDate() %></div>
            <div>평점: ⭐ <%= movie.getRating() %></div>
        </div>
    </div>

    <form action="<%= request.getContextPath() %>/saveDiary" method="post">
        <input type="hidden" name="movieId" value="<%= movie.getId() %>">
        <input type="hidden" name="movieTitle" value="<%= movie.getTitle() %>">
        <input type="hidden" name="posterPath" value="<%= movie.getPosterPath() %>">

        <div class="label">✏ 날짜</div>
        <input type="date" name="date" required>

        <div class="label">일기 내용</div>
        <textarea name="content" required></textarea>

        <button type="submit" class="submit-btn">저장하기</button>
    </form>
</div>

</body>
</html>