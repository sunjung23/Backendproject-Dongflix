<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="com.dongyang.dongflix.model.TMDBmovie" %>
<%@ page import="java.util.List" %>
<%@ page import="com.dongyang.dongflix.dto.ReviewDTO" %>
<%@ page import="com.dongyang.dongflix.dao.MemberDAO" %>
<img src="${pageContext.request.contextPath}/img/logo.png">

<%
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

    <!-- ⭐ 별점용 CSS -->
    <style>
        .star-rating {
            font-size: 32px;
            cursor: pointer;
            color: #555;
            margin-bottom: 10px;
        }
        .star-rating .star.selected {
            color: #ffdf00;
        }

        /* 수정 모드 별점 */
        .edit-star-rating .star {
            font-size: 28px;
            cursor: pointer;
            color: #555;
        }
        .edit-star-rating .star.selected {
            color: #ffdf00;
        }
    </style>
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
        <%
            MemberDAO mdao = new MemberDAO();

            if (reviewList != null && !reviewList.isEmpty()) {
                for (ReviewDTO r : reviewList) {

                    // 사용자 닉네임 가져오기 (없으면 자동 생성)
                    String nickname = mdao.getOrCreateNickname(r.getUserid());
        %>

            <div class="review-item" id="review_<%= r.getId() %>">

                <!-- ⭐ 닉네임 출력 -->
                <p><strong><%= nickname %></strong> | ⭐ <%= r.getRating() %>점</p>

                <p><%= r.getContent() %></p>
                <p class="review-date"><%= r.getCreatedAt() %></p>

                <hr>

                <% if (loginUser != null && r.getUserid().equals(loginUser)) { %>
                    <button onclick="openEditForm('<%= r.getId() %>', '<%= r.getRating() %>', '<%= r.getContent() %>')">
                        ✏ 수정
                    </button>
                    <button onclick="deleteReview(<%= r.getId() %>, <%= movie.getId() %>)">
                        🗑 삭제
                    </button>
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
       <form action="writeReview" method="post">
    <input type="hidden" name="movieId" value="<%= movie.getId() %>">
    <input type="hidden" name="movieTitle" value="<%= movie.getTitle() %>">
    <input type="hidden" name="movieImg" value="<%= movie.getPosterUrl() %>">
    <input type="hidden" name="rating" id="ratingValue" value="0">
    
            <!-- ⭐ 클릭 별점 -->
            <div class="star-rating">
                <span class="star" data-value="1">★</span>
                <span class="star" data-value="2">★</span>
                <span class="star" data-value="3">★</span>
                <span class="star" data-value="4">★</span>
                <span class="star" data-value="5">★</span>
            </div>

            <script>
                const stars = document.querySelectorAll(".star-rating .star");
                const ratingInput = document.getElementById("ratingValue");

                stars.forEach(star => {
                    star.addEventListener("click", () => {
                        const value = star.dataset.value;
                        ratingInput.value = value;

                        stars.forEach(s => s.classList.remove("selected"));
                        for (let i = 0; i < value; i++) {
                            stars[i].classList.add("selected");
                        }
                    });
                });
            </script>

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
            <input type="hidden" name="rating" id="edit_rating_value">

            <!-- ⭐ 별점 수정 -->
            <div class="edit-star-rating">
                <span class="star" data-value="1">★</span>
                <span class="star" data-value="2">★</span>
                <span class="star" data-value="3">★</span>
                <span class="star" data-value="4">★</span>
                <span class="star" data-value="5">★</span>
            </div>

            <script>
                function openEditForm(id, rating, content) {
                    document.getElementById("edit_reviewId").value = id;
                    document.getElementById("edit_content").value = content;

                    const editStars = document.querySelectorAll(".edit-star-rating .star");
                    const editRatingInput = document.getElementById("edit_rating_value");

                    editRatingInput.value = rating;

                    editStars.forEach(s => s.classList.remove("selected"));
                    for (let i = 0; i < rating; i++) {
                        editStars[i].classList.add("selected");
                    }

                    editStars.forEach(star => {
                        star.addEventListener("click", () => {
                            const value = star.dataset.value;
                            editRatingInput.value = value;

                            editStars.forEach(s => s.classList.remove("selected"));
                            for (let i = 0; i < value; i++) {
                                editStars[i].classList.add("selected");
                            }
                        });
                    });

                    document.getElementById("editForm").style.display = "block";
                    document.getElementById("reviewForm").style.display = "none";
                }

                function closeEditForm() {
                    document.getElementById("editForm").style.display = "none";
                }
            </script>

            <textarea id="edit_content" name="content" rows="4" required></textarea><br><br>

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

function deleteReview(id, movieId) {
    if (confirm("정말 삭제하시겠습니까?")) {
        location.href = "deleteReview?id=" + id + "&movieId=" + movieId;
    }
}
</script>

</body>
</html>
