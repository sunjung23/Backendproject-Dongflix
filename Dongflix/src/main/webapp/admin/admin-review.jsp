<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="com.dongyang.dongflix.dto.MemberDTO" %>
<%@ page import="com.dongyang.dongflix.dto.ReviewDTO" %>
<%@ page import="java.util.List" %>

<%
    MemberDTO adminUser = (MemberDTO) session.getAttribute("adminUser");
    if (adminUser == null || !"admin".equals(adminUser.getGrade())) {
        response.sendRedirect("admin-login.jsp");
        return;
    }
    
    List<ReviewDTO> reviews = (List<ReviewDTO>) request.getAttribute("reviews");
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>리뷰 관리 - DONGFLIX</title>
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
            max-width: 1400px;
            margin: 30px auto;
            padding: 0 20px;
        }
        h2 {
            margin-bottom: 20px;
            font-size: 28px;
        }
        .table-container {
            background-color: #1f1f1f;
            border-radius: 8px;
            padding: 20px;
            overflow-x: auto;
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #333;
        }
        th {
            background-color: #2a2a2a;
            color: #2036CA;
            font-weight: bold;
        }
        tr:hover {
            background-color: #2a2a2a;
        }
        .rating {
            color: #ffdf00;
            font-weight: bold;
        }
        .btn-delete {
            background-color: #e50914;
            color: white;
            padding: 6px 16px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
        }
        .btn-delete:hover {
            background-color: #f40612;
        }
        .content-preview {
            max-width: 250px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
        .movie-info {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .movie-img {
            width: 40px;
            height: 60px;
            border-radius: 4px;
            object-fit: cover;
        }
    </style>
    <script>
        function deleteReview(reviewId) {
            if (confirm('정말 이 리뷰를 삭제하시겠습니까?')) {
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
                reviewIdInput.value = reviewId;
                
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
        <span>⭐ 리뷰 관리</span>
        <a href="admin-dashboard.jsp" class="back-btn">← 대시보드로</a>
    </div>
</div>

<div class="container">
    <h2>리뷰 관리</h2>
    
    <div class="table-container">
        <% if (reviews == null || reviews.isEmpty()) { %>
            <p style="text-align:center; padding:40px; color:#999;">리뷰가 없습니다.</p>
        <% } else { %>
            <table>
                <thead>
                    <tr>
                        <th>번호</th>
                        <th>영화</th>
                        <th>평점</th>
                        <th>제목</th>
                        <th>내용 미리보기</th>
                        <th>작성자</th>
                        <th>작성일</th>
                        <th>관리</th>
                    </tr>
                </thead>
                <tbody>
				    <% for (ReviewDTO review : reviews) { 
				        String movieImg = review.getMovieImg();
				        if (movieImg != null && movieImg.startsWith("/")) {
				            movieImg = "https://image.tmdb.org/t/p/w200" + movieImg;
				        }
				    %>
				    <tr>
				        <td><%= review.getId() %></td>
				        <td>
				            <div class="movie-info">
				                <% if (movieImg != null) { %>
				                    <img src="<%= movieImg %>" class="movie-img" alt="영화 포스터">
				                <% } %>
				                <a href="admin-review-detail.do?reviewId=<%= review.getId() %>" 
				                   style="color:#fff; text-decoration:none; cursor:pointer;">
				                    <%= review.getMovieTitle() %>
				                </a>
				            </div>
				        </td>
				        <td class="rating">⭐ <%= review.getRating() %></td>
				        <td><%= review.getTitle() %></td>
				        <td class="content-preview"><%= review.getContent() %></td>
				        <td><%= review.getUserid() %></td>
				        <td><%= review.getCreatedAt() %></td>
				        <td>
				            <button class="btn-delete" 
				                    onclick="deleteReview(<%= review.getId() %>)">
				                삭제
				            </button>
				        </td>
				    </tr>
				    <% } %>
				</tbody>
            </table>
        <% } %>
    </div>
</div>

</body>
</html>