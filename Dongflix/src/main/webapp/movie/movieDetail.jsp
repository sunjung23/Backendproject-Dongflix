<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="com.dongyang.dongflix.model.TMDBmovie" %>

<%
    TMDBmovie movie = (TMDBmovie) request.getAttribute("movie");
    if (movie == null) {
        response.sendRedirect("indexMovie");
        return;
    }
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title><%= movie.getTitle() %> - 상세정보</title>

    <!-- CSS 캐시 방지 (강력 추천) -->
    <link rel="stylesheet" type="text/css" 
          href="<%= request.getContextPath() %>/css/movieDetail.css?v=<%= System.currentTimeMillis() %>">
</head>

<body>

<!-- ===== 배너 ===== -->
<div class="detail-banner" style="background-image: url('<%= movie.getBackdropUrl() %>')">
    <div class="detail-banner-content">
        <h1><%= movie.getTitle() %></h1>
        <p>⭐ 평점: <%= movie.getRating() %></p>
        <p>📅 개봉일: <%= movie.getReleaseDate() %></p>
    </div>
</div>

<!-- ===== 메인 콘텐츠 ===== -->
<div class="detail-container">
    <img class="detail-poster" src="<%= movie.getPosterUrl() %>" alt="포스터">

    <div class="detail-info">
        <h2>줄거리</h2>
        <p><%= movie.getOverview() %></p>

        <!-- 찜하기 -->
        <form action="wish" method="post">
            <input type="hidden" name="movie_id" value="<%= movie.getId() %>" />
            <input type="hidden" name="movie_title" value="<%= movie.getTitle() %>" />
            <input type="hidden" name="poster_path" value="<%= movie.getPosterPath() %>" />

            <button type="submit" class="wish-btn">❤️ 찜하기</button>
        </form>

        <a href="indexMovie" class="back-btn">← 메인으로 돌아가기</a>
    </div>
</div>

<!-- ===== 리뷰 섹션 ===== -->
<div class="review-section">
    <h3>💬 리뷰</h3>

    <div class="review-list">
        (아직 리뷰가 없습니다. 첫 리뷰를 작성해보세요!)
    </div>

    <br>

    <button class="review-write-btn"
            onclick="location.href='writeReview.jsp?movieId=<%= movie.getId() %>'">
        ✏ 리뷰 작성하기
    </button>
</div>

</body>
</html>