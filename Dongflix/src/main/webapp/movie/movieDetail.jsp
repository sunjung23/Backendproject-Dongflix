<%@ include file="/common/header.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="com.dongyang.dongflix.model.TMDBmovie" %>
<%@ page import="java.util.List" %>
<%@ page import="com.dongyang.dongflix.dto.ReviewDTO" %>
<%@ page import="com.dongyang.dongflix.dao.MemberDAO" %>
<%@ page import="com.dongyang.dongflix.dto.MemberDTO" %>

<%
    TMDBmovie movie = (TMDBmovie) request.getAttribute("movie");
    if (movie == null) {
        response.sendRedirect("indexMovie");
        return;
    }

    List<ReviewDTO> topReviews = (List<ReviewDTO>) request.getAttribute("topReviews");
    List<ReviewDTO> otherReviews = (List<ReviewDTO>) request.getAttribute("otherReviews");
    MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
    String detailLoginUser = (loginUser != null) ? loginUser.getUserid() : null;

%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title><%= movie.getTitle() %> - 상세정보</title>

    <link rel="stylesheet" type="text/css" 
          href="<%= request.getContextPath() %>/css/movieDetail.css?v=<%= System.currentTimeMillis() %>">

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
	
	    .edit-star-rating .star {
	        font-size: 28px;
	        cursor: pointer;
	        color: #555;
	    }
	    .edit-star-rating .star.selected {
	        color: #ffdf00;
	    }
	
	    .review-item {
	        background-color: #1a1a1a;
	        border: 1px solid #333;
	        border-radius: 12px;
	        padding: 20px;
	        margin-bottom: 20px;
	        transition: all 0.2s;
	    }
	
	    .review-item:hover {
	        border-color: #555;
	        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.5);
	    }
	
	    /* 리뷰 헤더 (작성자 + 별점 + 추천) */
	    .review-header {
	        display: flex;
	        justify-content: space-between;
	        align-items: center;
	        margin-bottom: 15px;
	        padding-bottom: 12px;
	        border-bottom: 1px solid #2a2a2a;
	    }
	
	    .review-author-info {
	        display: flex;
	        align-items: center;
	        gap: 10px;
	    }
	
	    .review-author-name {
	        font-size: 16px;
	        font-weight: bold;
	        color: #fff;
	    }
	
	    .review-rating {
	        color: #ffdf00;
	        font-size: 14px;
	    }
	
	    .review-like-section {
	        display: flex;
	        align-items: center;
	        gap: 8px;
	    }
	
	    .like-btn {
	        background: none;
	        border: 1px solid #555;
	        color: #999;
	        padding: 8px 14px;
	        border-radius: 6px;
	        cursor: pointer;
	        font-size: 14px;
	        transition: all 0.2s;
	        display: flex;
	        align-items: center;
	        gap: 6px;
	    }
	    
	    .like-btn:hover {
	        border-color: #e50914;
	        color: #e50914;
	        transform: translateY(-1px);
	    }
	    
	    .like-btn.liked {
	        background-color: #e50914;
	        border-color: #e50914;
	        color: white;
	    }
	    
	    .like-btn.liked:hover {
	        background-color: #f40612;
	        border-color: #f40612;
	    }
	
	    /* 리뷰 내용 */
	    .review-content {
	        font-size: 15px;
	        line-height: 1.6;
	        color: #ddd;
	        margin-bottom: 15px;
	        white-space: pre-wrap;
	    }
	
	    /* 리뷰 하단 (날짜 + 버튼) */
	    .review-footer {
	        display: flex;
	        justify-content: space-between;
	        align-items: center;
	    }
	
	    .review-date {
	        font-size: 13px;
	        color: #666;
	    }
	
	    .review-actions {
	        display: flex;
	        gap: 8px;
	    }
	
	    .top-badge {
	        display: inline-block;
	        background: linear-gradient(135deg, #ffd700, #ffed4e);
	        color: #000;
	        padding: 5px 12px;
	        border-radius: 6px;
	        font-size: 13px;
	        font-weight: bold;
	        margin-bottom: 12px;
	        box-shadow: 0 2px 6px rgba(255, 215, 0, 0.4);
	    }
	
	    .review-divider {
	        margin: 40px 0;
	        border: none;
	        border-top: 2px solid #2a2a2a;
	        position: relative;
	    }
	
	    .review-divider::after {
	        content: "기타 리뷰";
	        position: absolute;
	        top: -12px;
	        left: 50%;
	        transform: translateX(-50%);
	        background: #141414;
	        padding: 0 20px;
	        color: #888;
	        font-size: 14px;
	        font-weight: bold;
	    }
	
	    .review-action-btn {
	        background: none;
	        border: 1px solid #555;
	        color: #999;
	        padding: 6px 12px;
	        border-radius: 6px;
	        cursor: pointer;
	        font-size: 13px;
	        transition: all 0.2s;
	    }
	
	    .review-action-btn:hover {
	        border-color: #2036CA;
	        color: #2036CA;
	    }
	
	    .review-action-btn.delete:hover {
	        border-color: #e50914;
	        color: #e50914;
	    }
	</style>
</head>

<body>

<!-- ===== 배너 ===== -->
<div class="detail-banner" style="background-image: url('<%= movie.getBackdropUrl() %>')">
    <div class="detail-banner-content">
        <h1><%= movie.getTitle() %></h1>
        <p>⭐ TMDB 평균 평점: <%= movie.getRating() %></p>
        <p>⭐ DONGFLIX 평균 평점: 
	    <%= request.getAttribute("avgRating") != null 
	        ? String.format("%.1f", request.getAttribute("avgRating")) 
	        : "0.0" %>
	    (<%= request.getAttribute("reviewCount") %>명 참여)
		</p>
        <p>📅 개봉일: <%= movie.getReleaseDate() %></p>
    </div>
</div>

<!-- ===== 메인 콘텐츠 ===== -->
<div class="detail-container">
    <img class="detail-poster" src="<%= movie.getPosterUrl() %>" alt="포스터">

    <div class="detail-info">
        <h2>줄거리</h2>
        <p><%= movie.getOverview() %></p>

        <!-- ===== 액션 버튼 영역 ===== -->
        <div class="detail-actions">

            <!-- 찜하기 -->
            <form action="wish" method="post" class="action-form">
                <input type="hidden" name="movie_id" value="<%= movie.getId() %>" />
                <input type="hidden" name="movie_title" value="<%= movie.getTitle() %>" />
                <input type="hidden" name="poster_path" value="<%= movie.getPosterPath() %>" />

                <button type="submit"
                        class="wish-btn <%= (Boolean.TRUE.equals(request.getAttribute("isWished"))) ? "active" : "" %>">
                    <%= (Boolean.TRUE.equals(request.getAttribute("isWished"))) 
                            ? "찜 취소" 
                            : "❤️ 찜하기" %>
                </button>
            </form>

            <!-- 영화 일기 -->
            <a href="<%= request.getContextPath() %>/writeDiary?movieId=<%= movie.getId() %>"
               class="diary-btn">
                📘 영화 일기 작성하기
            </a>

        </div>
    </div>
</div>


<!-- ===== 리뷰 섹션 ===== -->
<div class="review-section">
    <h3>💬 리뷰</h3>

    <div class="review-list">
	    <%
	        MemberDAO mdao = new MemberDAO();
	
	        // 🔥 TOP 5 리뷰 먼저 표시
	        if (topReviews != null && !topReviews.isEmpty()) {
	            for (int i = 0; i < topReviews.size(); i++) {
	                ReviewDTO r = topReviews.get(i);
	                String nickname = mdao.getOrCreateNickname(r.getUserid());
	    %>
	
	        <div class="review-item" id="review_<%= r.getId() %>">
	            
	            <!-- TOP 배지 -->
	            <% if (r.getLikeCount() > 0) { %>
	                <div class="top-badge">🏆 TOP <%= i + 1 %></div>
	            <% } %>
	
	            <!-- 리뷰 헤더 (작성자 + 별점 + 추천) -->
	            <div class="review-header">
	                <div class="review-author-info">
	                    <span class="review-author-name"><%= nickname %></span>
	                    <span class="review-rating">⭐ <%= r.getRating() %>점</span>
	                </div>
	                
	                <div class="review-like-section">
	                    <!-- 추천 버튼 -->
	                    <% if (detailLoginUser != null) { %>
	                        <button class="like-btn <%= r.isLiked() ? "liked" : "" %>" 
	                                onclick="toggleLike(<%= r.getId() %>, this)">
	                            <span>👍</span>
	                            <span class="like-count"><%= r.getLikeCount() %></span>
	                        </button>
	                    <% } else { %>
	                        <span style="color:#999; font-size:14px;">
	                            👍 <%= r.getLikeCount() %>
	                        </span>
	                    <% } %>
	                </div>
	            </div>
	
	            <!-- 리뷰 내용 -->
	            <div class="review-content"><%= r.getContent() %></div>
	
	            <!-- 리뷰 하단 (날짜 + 수정/삭제 버튼) -->
	            <div class="review-footer">
	                <span class="review-date"><%= r.getCreatedAt() %></span>
	                
	                <% if (detailLoginUser != null && r.getUserid().equals(detailLoginUser)) { %>
	                    <div class="review-actions">
	                        <button class="review-action-btn"
	                                onclick="openEditForm('<%= r.getId() %>', '<%= r.getRating() %>', `<%= r.getContent().replace("`", "\\`").replace("\n", "\\n") %>`)">
	                            ✏ 수정
	                        </button>
	                        
	                        <button class="review-action-btn delete"
	                                onclick="deleteReview(<%= r.getId() %>, <%= movie.getId() %>)">
	                            🗑 삭제
	                        </button>
	                    </div>
	                <% } %>
	            </div>
	
	        </div>
	
	    <%
	            }
	        }
	
	        // 🔥 구분선
	        if (topReviews != null && !topReviews.isEmpty() && otherReviews != null && !otherReviews.isEmpty()) {
	    %>
	        <hr class="review-divider">
	    <%
	        }
	
	        // 🔥 나머지 리뷰 표시
	        if (otherReviews != null && !otherReviews.isEmpty()) {
	            for (ReviewDTO r : otherReviews) {
	                String nickname = mdao.getOrCreateNickname(r.getUserid());
	    %>
	
	        <div class="review-item" id="review_<%= r.getId() %>">
	
	            <!-- 리뷰 헤더 (작성자 + 별점 + 추천) -->
	            <div class="review-header">
	                <div class="review-author-info">
	                    <span class="review-author-name"><%= nickname %></span>
	                    <span class="review-rating">⭐ <%= r.getRating() %>점</span>
	                </div>
	                
	                <div class="review-like-section">
	                    <!-- 추천 버튼 -->
	                    <% if (detailLoginUser != null) { %>
	                        <button class="like-btn <%= r.isLiked() ? "liked" : "" %>" 
	                                onclick="toggleLike(<%= r.getId() %>, this)">
	                            <span>👍</span>
	                            <span class="like-count"><%= r.getLikeCount() %></span>
	                        </button>
	                    <% } else { %>
	                        <span style="color:#999; font-size:14px;">
	                            👍 <%= r.getLikeCount() %>
	                        </span>
	                    <% } %>
	                </div>
	            </div>
	
	            <!-- 리뷰 내용 -->
	            <div class="review-content"><%= r.getContent() %></div>
	
	            <!-- 리뷰 하단 (날짜 + 수정/삭제 버튼) -->
	            <div class="review-footer">
	                <span class="review-date"><%= r.getCreatedAt() %></span>
	                
	                <% if (detailLoginUser != null && r.getUserid().equals(detailLoginUser)) { %>
	                    <div class="review-actions">
	                        <button class="review-action-btn"
	                                onclick="openEditForm('<%= r.getId() %>', '<%= r.getRating() %>', `<%= r.getContent().replace("`", "\\`").replace("\n", "\\n") %>`)">
	                            ✏ 수정
	                        </button>
	                        
	                        <button class="review-action-btn delete"
	                                onclick="deleteReview(<%= r.getId() %>, <%= movie.getId() %>)">
	                            🗑 삭제
	                        </button>
	                    </div>
	                <% } %>
	            </div>
	
	        </div>
	
	    <%
	            }
	        }
	
	        // 리뷰가 하나도 없는 경우
	        if ((topReviews == null || topReviews.isEmpty()) && (otherReviews == null || otherReviews.isEmpty())) {
	    %>
	        <p>(아직 리뷰가 없습니다. 첫 리뷰를 작성해보세요!)</p>
	    <%
	        }
	    %>
	</div>

    <!-- 리뷰 작성 버튼 -->
	<% if (detailLoginUser != null) { %>
	    <button class="review-write-btn" onclick="toggleReviewForm()" id="reviewToggle">
	        ✏ 리뷰 작성하기
	    </button>
	<% } else { %>
	    <p>리뷰를 작성하려면 로그인하세요.</p>
	<% } %>

    <!-- ===== 리뷰 작성 폼 ===== -->
    <div id="reviewForm" class="review-form-wrapper" style="display:none;">
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

            <button type="submit" class="review-submit-btn">등록하기</button>
        </form>
    </div>

    <!-- ===== 리뷰 수정 폼 ===== -->
    <div id="editForm" class="review-form-wrapper" style="display:none;">
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

            <button type="submit" class="review-submit-btn">수정 완료</button>
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

// 🔥 추천 토글 함수 (AJAX)
function toggleLike(reviewId, button) {
    const isLiked = button.classList.contains('liked');
    const action = isLiked ? 'unlike' : 'like';
    
    fetch('reviewLike', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: 'reviewId=' + reviewId + '&action=' + action
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            // 버튼 스타일 토글
            button.classList.toggle('liked');
            
            // 추천 수 업데이트
            const likeCountSpan = button.querySelector('.like-count');
            likeCountSpan.textContent = data.likeCount;
        } else {
            alert(data.message || '오류가 발생했습니다.');
        }
    })
    .catch(error => {
        console.error('Error:', error);
        alert('오류가 발생했습니다.');
    });
}
</script>

</body>
</html>