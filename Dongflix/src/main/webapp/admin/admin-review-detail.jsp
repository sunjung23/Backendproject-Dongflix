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
    MemberDTO author = (MemberDTO) request.getAttribute("author");
    
    // 프로필에서 넘어왔는지 확인
    String fromProfile = request.getParameter("fromProfile");
    String profileUserid = request.getParameter("userid");
    boolean isFromProfile = "true".equals(fromProfile) && profileUserid != null;
    
    // 프로필이 어디서 왔는지 확인 (게시글 or 리뷰)
    String fromBoard = request.getParameter("fromBoard");
    String boardId = request.getParameter("boardId");
    String fromReview = request.getParameter("fromReview");
    String originalReviewId = request.getParameter("originalReviewId");
    
    if (review == null) {
        response.sendRedirect("admin-review.do");
        return;
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
        
        /* 작성자 프로필 박스 */
        .author-box {
            background-color: #1f1f1f;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
            border: 1px solid #333;
        }
        
        .author-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .author-info {
            display: flex;
            align-items: center;
            gap: 12px;
        }
        
        .author-icon {
            font-size: 24px;
        }
        
        .author-details {
            display: flex;
            flex-direction: column;
            gap: 4px;
        }
        
        .author-name {
            font-size: 13px;
            font-weight: normal;
            color: #999;
        }
        
        .author-id {
            font-size: 17px;
            font-weight: bold;
            color: #fff;
        }
        
        .current-grade {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: bold;
            margin-top: 4px;
        }
        
        .grade-bronze { background-color: rgba(205,127,50,0.3); color: #e2b77c; }
        .grade-silver { background-color: rgba(192,192,192,0.3); color: #e8e8e8; }
        .grade-gold { background-color: rgba(255,215,0,0.3); color: #ffe680; }
        .grade-admin { background-color: rgba(32,54,202,0.3); color: #6b8aff; }
        
        .btn-profile {
            padding: 8px 16px;
            background-color: #555;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 13px;
            text-decoration: none;
            transition: .2s;
        }
        
        .btn-profile:hover {
            background-color: #666;
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
        
        .movie-poster img {
            width: 150px;
            height: 225px;
            border-radius: 8px;
            object-fit: cover;
        }
        
        .movie-info {
            flex: 1;
        }
        
        .movie-title {
            font-size: 26px;
            font-weight: bold;
            margin-bottom: 10px;
        }
        
        .rating {
            font-size: 20px;
            color: #ffd700;
            margin-bottom: 15px;
        }
        
        .review-meta {
            font-size: 14px;
            color: #999;
            margin-bottom: 10px;
        }
        
        .review-info-box {
            background-color: #141414;
            padding: 15px;
            border-radius: 6px;
            margin-top: 10px;
        }
        
        .info-row {
            display: flex;
            gap: 20px;
            font-size: 13px;
            color: #bbb;
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
	            
	            <% if (isFromProfile) { %>
	                // 프로필에서 온 경우 프로필로 돌아가기
	                var fromProfileInput = document.createElement('input');
	                fromProfileInput.type = 'hidden';
	                fromProfileInput.name = 'fromProfile';
	                fromProfileInput.value = 'true';
	                
	                var profileUseridInput = document.createElement('input');
	                profileUseridInput.type = 'hidden';
	                profileUseridInput.name = 'profileUserid';
	                profileUseridInput.value = '<%= profileUserid %>';
	                
	                form.appendChild(fromProfileInput);
	                form.appendChild(profileUseridInput);
	                
	                <% if ("true".equals(fromBoard) && boardId != null) { %>
	                    var fromBoardInput = document.createElement('input');
	                    fromBoardInput.type = 'hidden';
	                    fromBoardInput.name = 'fromBoard';
	                    fromBoardInput.value = 'true';
	                    
	                    var boardIdInput = document.createElement('input');
	                    boardIdInput.type = 'hidden';
	                    boardIdInput.name = 'boardId';
	                    boardIdInput.value = '<%= boardId %>';
	                    
	                    form.appendChild(fromBoardInput);
	                    form.appendChild(boardIdInput);
	                <% } else if ("true".equals(fromReview) && originalReviewId != null) { %>
	                    var fromReviewInput = document.createElement('input');
	                    fromReviewInput.type = 'hidden';
	                    fromReviewInput.name = 'fromReview';
	                    fromReviewInput.value = 'true';
	                    
	                    var originalReviewIdInput = document.createElement('input');
	                    originalReviewIdInput.type = 'hidden';
	                    originalReviewIdInput.name = 'originalReviewId';
	                    originalReviewIdInput.value = '<%= originalReviewId %>';
	                    
	                    form.appendChild(fromReviewInput);
	                    form.appendChild(originalReviewIdInput);
	                <% } %>
	            <% } %>
	            
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
    
    <!-- 작성자 프로필 박스 (프로필에서 온 경우 숨김) -->
	<% if (!isFromProfile) { 
	    // 프로필 링크 생성
	    String profileLink = "admin-member-detail.do?userid=" + review.getUserid() + "&fromReview=true&reviewId=" + review.getId();
	%>
	<div class="author-box">
	    <div class="author-header">
	        <div class="author-info">
	            <div class="author-icon">👤</div>
	            <div class="author-details">
	                <div class="author-name">작성자</div>
	                <div class="author-id"><%= review.getUserid() %></div>
	                <% if (author != null) { %>
	                    <span class="current-grade grade-<%= author.getGrade().toLowerCase() %>">
	                        <%= author.getGrade().toUpperCase() %>
	                    </span>
	                <% } %>
	            </div>
	        </div>
	        <a href="<%= profileLink %>" class="btn-profile">
	            프로필 보기 →
	        </a>
	    </div>
	</div>
	<% } %>
    
    <div class="review-container">
        <div class="movie-section">
            <div class="movie-poster">
                <img src="<%= review.getMovieImg() != null ? review.getMovieImg() : "../img/default_movie.png" %>" alt="영화 포스터">
            </div>
            <div class="movie-info">
                <div class="movie-title"><%= review.getMovieTitle() %></div>
                <div class="rating">⭐ <%= review.getRating() %> / 5</div>
                <div class="review-meta">작성일: <%= review.getCreatedAt() %></div>
                
                <div class="review-info-box">
                    <div class="info-row">
                        <span>리뷰 번호: <%= review.getId() %></span>
                        <span>영화 ID: <%= review.getMovieId() %></span>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="review-title">
            <%= review.getTitle() %>
        </div>
        
        <div class="review-content">
<%= review.getContent() %>
        </div>
    </div>
    
    <div class="action-buttons">
	    <% 
	        String backUrl;
	        if (isFromProfile) {
	            // 프로필로 복귀 링크 생성
	            backUrl = "admin-member-detail.do?userid=" + profileUserid;
	            
	            // 프로필이 게시글에서 왔다면 게시글 정보 전달
	            if ("true".equals(fromBoard) && boardId != null) {
	                backUrl += "&fromBoard=true&boardId=" + boardId;
	            }
	            // 프로필이 다른 리뷰에서 왔다면 원래 리뷰 정보 전달
	            else if ("true".equals(fromReview) && originalReviewId != null) {
	                backUrl += "&fromReview=true&reviewId=" + originalReviewId;
	            }
	    %>
	        <a href="<%= backUrl %>" class="btn btn-back">← 프로필로 돌아가기</a>
	        <button class="btn btn-delete" onclick="deleteReview()">🗑️ 삭제</button>
	    <% } else {
	            // 리뷰 관리에서 온 경우 목록으로
	            backUrl = "admin-review.do";
	    %>
	        <a href="<%= backUrl %>" class="btn btn-back">← 목록으로</a>
	        <button class="btn btn-delete" onclick="deleteReview()">🗑️ 삭제</button>
	    <% } %>
	</div>
</div>

</body>
</html>