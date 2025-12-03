<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="com.dongyang.dongflix.dto.MemberDTO" %>
<%@ page import="com.dongyang.dongflix.dto.BoardDTO" %>

<%
    MemberDTO adminUser = (MemberDTO) session.getAttribute("adminUser");
    if (adminUser == null || !"admin".equals(adminUser.getGrade())) {
        response.sendRedirect("admin-login.jsp");
        return;
    }
    
    BoardDTO board = (BoardDTO) request.getAttribute("board");
    String category = (String) request.getAttribute("category");
    
    if (board == null) {
        response.sendRedirect("admin-board.do");
        return;
    }
    
    String categoryName = "";
    if ("free".equals(board.getCategory())) {
        categoryName = "자유게시판";
    } else if ("level".equals(board.getCategory())) {
        categoryName = "등업게시판";
    } else if ("secret".equals(board.getCategory())) {
        categoryName = "비밀게시판";
    }
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>게시글 상세보기 - DONGFLIX</title>
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
        
        .board-container {
            background-color: #1f1f1f;
            border-radius: 8px;
            padding: 30px;
            margin-bottom: 20px;
        }
        
        .board-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-bottom: 20px;
            border-bottom: 2px solid #333;
            margin-bottom: 20px;
        }
        
        .meta-left {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .category-badge {
            display: inline-block;
            padding: 6px 14px;
            border-radius: 12px;
            font-size: 13px;
            font-weight: bold;
        }
        
        .category-free {
            background-color: rgba(32, 54, 202, 0.3);
            color: #6b8aff;
        }
        .category-level {
            background-color: rgba(255, 215, 0, 0.3);
            color: #ffe680;
        }
        .category-secret {
            background-color: rgba(139, 0, 139, 0.3);
            color: #da70d6;
        }
        
        .board-info {
            font-size: 14px;
            color: #999;
        }
        
        .board-title {
            font-size: 26px;
            font-weight: bold;
            margin-bottom: 20px;
            color: #fff;
        }
        
        .board-content {
            font-size: 16px;
            line-height: 1.8;
            color: #ddd;
            white-space: pre-wrap;
            min-height: 200px;
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
        function deleteBoard() {
            if (confirm('정말 이 게시글을 삭제하시겠습니까?\n삭제된 게시글은 복구할 수 없습니다.')) {
                var form = document.createElement('form');
                form.method = 'POST';
                form.action = '<%= request.getContextPath() %>/admin/admin-board.do';
                
                var actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'delete';
                
                var boardIdInput = document.createElement('input');
                boardIdInput.type = 'hidden';
                boardIdInput.name = 'boardId';
                boardIdInput.value = '<%= board.getBoardId() %>';
                
                var categoryInput = document.createElement('input');
                categoryInput.type = 'hidden';
                categoryInput.name = 'category';
                categoryInput.value = '<%= category != null ? category : "all" %>';
                
                form.appendChild(actionInput);
                form.appendChild(boardIdInput);
                form.appendChild(categoryInput);
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
        <span>📋 게시글 상세보기</span>
        <a href="admin-dashboard.jsp" class="back-btn">← 대시보드로</a>
    </div>
</div>

<div class="container">
    <div class="detail-header">
        <h2>게시글 상세보기</h2>
    </div>
    
    <div class="board-container">
        <div class="board-meta">
            <div class="meta-left">
                <span class="category-badge category-<%= board.getCategory() %>">
                    <%= categoryName %>
                </span>
                <span class="board-info">작성자: <%= board.getUserid() %></span>
                <span class="board-info">작성일: <%= board.getCreatedAt() %></span>
            </div>
            <div class="board-info">
                게시글 번호: <%= board.getBoardId() %>
            </div>
        </div>
        
        <div class="board-title">
            <%= board.getTitle() %>
        </div>
        
        <div class="board-content">
<%= board.getContent() %>
        </div>
    </div>
    
    <div class="action-buttons">
        <% 
            String backUrl = "admin-board.do";
            if (category != null && !category.isEmpty() && !"all".equals(category)) {
                backUrl += "?category=" + category;
            }
        %>
        <a href="<%= backUrl %>" class="btn btn-back">← 목록으로</a>
        <button class="btn btn-delete" onclick="deleteBoard()">🗑️ 삭제</button>
    </div>
</div>

</body>
</html>