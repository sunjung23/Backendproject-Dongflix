<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="com.dongyang.dongflix.dto.MemberDTO" %>
<%@ page import="com.dongyang.dongflix.dto.ReviewDTO" %>

<%
    MemberDTO adminUser = (MemberDTO) session.getAttribute("adminUser");
    if (adminUser == null || !"admin".equals(adminUser.getGrade())) {
        response.sendRedirect("admin-login.jsp");
        return;
    }
    
    ReviewDTO review = (ReviewDTO) request.getAttribute("review");
    
    if (review == null) {
        response.sendRedirect("admin-review.do");
        return;
    }
    
    String movieImg = review.getMovieImg();
    if (movieImg != null && movieImg.startsWith("/")) {
        movieImg = "https://image.tmdb.org/t/p/w500" + movieImg;
    }
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>리뷰 상세보기 - DONGFLIX</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            background-color: #141414;
            color: white;
            font-family: Arial, sans-serif;
        }
        .header {
            background-color: #000;
            padding: 20px 50px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 2px solid #2036CA;
        }
        .header .logo img {
            height: 35px;
            cursor: pointer;
        }
        .header-right {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        .back-btn {
            background-color: #333;
            color: white;
            padding: 8px 16px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
            font-size: 14px;
        }
        .back-btn:hover {
            background-color: #555;
        }
        .container {
            max-width: 1000px;
            margin: 30px auto;
            padding: 0 20px;
        }
        
        .detail-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        
        .detail-header h2 {
            font-size: 28px;
            color: #2036CA;
        }
        
        .review-container {
            background-color: #1f1f1f;
            border-radius: 8px;
            padding: 30px;
            margin-bottom: 20px;
        }
        
        .movie-section {
            display: flex;
            gap: 20px;
            padding-bottom: 20px;
            border-bottom: 2px solid #333;
            margin-bottom: 20px;
        }
        
        .movie-poster {
            width: 150px;
            height: 225px;
            border-radius: 8px;
            object-fit: cover;
        }
        
        .movie-info {
            flex: 1;
            display: flex;
            flex-direction: column;
            justify-content: center;
            gap: 10px;
        }
        
        .movie-title {
            font-size: 24px;
            font-weight: bold;
            color: #fff;
        }
        
        .review-meta {
            display: flex;
            gap: 20px;
            font-size: 14px;
            color: #999;
        }
        
        .rating-display {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            font-size: 20px;
            color: #ffdf00;
            font-weight: bold;
        }
        
        .review-title {
            font-size: 22px;
            font-weight: bold;
            margin-bottom: 15px;
            color: #fff;
        }
        
        .review-content {
            font-size: 16px;
            line-height: 1.8;
            color: #ddd;
            white-space: pre-wrap;
            min-height: 150px;
            padding: 20px;
            background-color: #141414;
            border-radius: 8px;
        }
        
        .review-info-box {
            background-color: #2a2a2a;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        
        .info-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 8px;
            font-size: 14px;
        }
        
        .info-row:last-child {
            margin-bottom: 0;
        }
        
        .info-label {
            color: #999;
        }
        
        .info-value {
            color: #fff;
            font-weight: bold;
        }
        
        .action-buttons {
            display: flex;
            gap: 10px;
            justify-content: flex-end;
            margin-top: 20px;
        }
        
        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            text-decoration: none;
            display: inline-block;
        }
        
        .btn-back {
            background-color: #333;
            color: white;
        }
        
        .btn-back:hover {
            background-color: #555;
        }
        
        .btn-delete {
            background-color: #e50914;
            color: white;
        }
        
        .btn-delete:hover {
            background-color: #f40612;
        }
    </style>
    <script>
        function deleteReview() {
            if (confirm('정말 이 리뷰를 삭제하시겠습니까?\n삭제된 리뷰는 복구할 수 없습니다.')) {
                var form = document.createElement('form');
                form.method = 'POST';
                form.action = '<%= request.getContextPath() %>/admin/admin-review.do';
                
                var actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'delete';
                
                var reviewIdInput = document.createElement('input');
                reviewIdInput.type = 'hidden';
                reviewIdInput.name = 'reviewId';
                reviewIdInput.value = '<%= review.getId() %>';
                
                form.appendChild(actionInput);
                form.appendChild(reviewIdInput);
                document.body.appendChild(form);
                form.submit();
            }
        }
    </script>
</head>
<body>

<div class="header">
    <div class="logo">
        <a href="<%= request.getContextPath() %>/admin/admin-dashboard.jsp">
            <img src="<%= request.getContextPath() %>/img/logo.png" alt="DONGFLIX">
        </a>
    </div>
    <div class="header-right">
        <span>⭐ 리뷰 상세보기</span>
        <a href="admin-dashboard.jsp" class="back-btn">← 대시보드로</a>
    </div>
</div>

<div class="container">
    <div class="detail-header">
        <h2>리뷰 상세보기</h2>
    </div>
    
    <div class="review-container">
        <!-- 영화 정보 섹션 -->
        <div class="movie-section">
            <% if (movieImg != null) { %>
                <img src="<%= movieImg %>" class="movie-poster" alt="영화 포스터">
            <% } %>
            <div class="movie-info">
                <div class="movie-title"><%= review.getMovieTitle() %></div>
                <div class="rating-display">
                    <span>⭐</span>
                    <span><%= review.getRating() %> / 5</span>
                </div>
                <div class="review-meta">
                    <span>작성자: <%= review.getUserid() %></span>
                    <span>작성일: <%= review.getCreatedAt() %></span>
                </div>
            </div>
        </div>
        
        <!-- 리뷰 정보 -->
        <div class="review-info-box">
            <div class="info-row">
                <span class="info-label">리뷰 번호:</span>
                <span class="info-value"><%= review.getId() %></span>
            </div>
            <div class="info-row">
                <span class="info-label">영화 ID:</span>
                <span class="info-value"><%= review.getMovieId() %></span>
            </div>
        </div>
        
        <!-- 리뷰 제목 -->
        <div class="review-title">
            <%= review.getTitle() %>
        </div>
        
        <!-- 리뷰 내용 -->
        <div class="review-content">
<%= review.getContent() %>
        </div>
    </div>
    
    <div class="action-buttons">
        <a href="admin-review.do" class="btn btn-back">← 목록으로</a>
        <button class="btn btn-delete" onclick="deleteReview()">🗑️ 삭제</button>
    </div>
</div>

</body>
</html>