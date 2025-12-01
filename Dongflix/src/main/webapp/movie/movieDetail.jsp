<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="com.dongyang.dongflix.model.TMDBmovie" %>
<%@ page import="java.util.List" %>
<%@ page import="com.dongyang.dongflix.dto.ReviewDTO" %>

<%
System.out.println("session userid = " + session.getAttribute("userid"));
    TMDBmovie movie = (TMDBmovie) request.getAttribute("movie");
    if (movie == null) {
        response.sendRedirect("indexMovie");
        return;
    }

    List<ReviewDTO> reviewList = (List<ReviewDTO>) request.getAttribute("reviewList");
    String loginUser = (String) session.getAttribute("userid");
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title><%= movie.getTitle() %> - 상세정보</title>

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

        <% 
            if (reviewList != null && !reviewList.isEmpty()) { 
                for (ReviewDTO r : reviewList) { 
        %>

            <div class="review-item" id="review_<%= r.getId() %>">
                <p><strong><%= r.getUserid() %></strong> | ⭐ <%= r.getRating() %>점</p>
                <p><%= r.getContent() %></p>
                <p class="review-date"><%= r.getCreatedAt() %></p>
                <hr>

                <% if (loginUser != null && r.getUserid().equals(loginUser)) { %>
                    <button onclick="openEditForm('<%= r.getId() %>', '<%= r.getRating() %>', '<%= r.getContent() %>')">✏ 수정</button>
                    <button onclick="deleteReview(<%= r.getId() %>, <%= movie.getId() %>)">🗑 삭제</button>
                <% } %>
            </div>

        <% 
                }
            } else { 
        %>
            <p>(아직 리뷰가 없습니다. 첫 리뷰를 작성해보세요!)</p>
        <% 
            } 
        %>

    </div>

    <!-- 리뷰 작성 버튼 -->
    <% if (loginUser != null) { %>
    <button class="review-write-btn" onclick="toggleReviewForm()">
        ✏ 리뷰 작성하기
    </button>
    <% } else { %>
    <p>리뷰를 작성하려면 로그인하세요.</p>
    <% } %>

    <!-- ===== 리뷰 작성 폼 ===== -->
    <div id="reviewForm" style="display:none; margin-top:20px;">
		<form action="<%=request.getContextPath()%>/writeReview" method="post">
		    <input type="hidden" name="movieId" value="<%= movie.getId() %>">

            <label>평점 (1~5)</label><br>
            <input type="number" name="rating" min="1" max="5" required><br><br>

            <label>리뷰 내용</label><br>
            <textarea name="content" rows="4" cols="50" required></textarea><br><br>

            <button type="submit">등록하기</button>
        </form>
    </div>

    <!-- ===== 리뷰 수정 폼 ===== -->
    <div id="editForm" style="display:none; margin-top:20px;">
	     <form action="<%=request.getContextPath()%>/updateReview" method="post">
	    	<input type="hidden" name="reviewId" id="edit_reviewId">
	    	<input type="hidden" name="movieId" value="<%= movie.getId() %>">

            <label>평점 (1~5)</label><br>
            <input type="number" name="rating" id="edit_rating" min="1" max="5" required><br><br>

            <label>리뷰 내용</label><br>
            <textarea name="content" id="edit_content" rows="4" required></textarea><br><br>

            <button type="submit">수정 완료</button>
            <button type="button" onclick="closeEditForm()">취소</button>
        </form>
    </div>

</div>
<script>
function toggleReviewForm() {
    const form = document.getElementById("reviewForm");
    form.style.display = (form.style.display === "none") ? "block" : "none";
}

function openEditForm(id, rating, content) {
    document.getElementById("edit_reviewId").value = id;
    document.getElementById("edit_rating").value = rating;
    document.getElementById("edit_content").value = content;

    document.getElementById("editForm").style.display = "block";
    document.getElementById("reviewForm").style.display = "none";
}

function closeEditForm() {
    document.getElementById("editForm").style.display = "none";
}

function deleteReview(id, movieId) {
    if (confirm("정말 삭제하시겠습니까?")) {
        location.href = "deleteReview?id=" + id + "&movieId=" + movieId;
    }
}
</script>

</body>
</html>