<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="com.dongyang.dongflix.dto.MemberDTO" %>
<%@ page import="com.dongyang.dongflix.dto.BoardDTO" %>
<%@ page import="java.util.List" %>

<%
    MemberDTO adminUser = (MemberDTO) session.getAttribute("adminUser");
    if (adminUser == null || !"admin".equals(adminUser.getGrade())) {
        response.sendRedirect("admin-login.jsp");
        return;
    }
    
    List<BoardDTO> boards = (List<BoardDTO>) request.getAttribute("boards");
    String currentCategory = (String) request.getAttribute("currentCategory");
    if (currentCategory == null) currentCategory = "all";
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>게시판 관리 - DONGFLIX</title>
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
        
        /* 카테고리 탭 */
        .category-tabs {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
        }
        .tab {
            padding: 10px 20px;
            background-color: #2a2a2a;
            border: 1px solid #444;
            border-radius: 8px;
            cursor: pointer;
            text-decoration: none;
            color: white;
            transition: .2s;
        }
        .tab:hover {
            background-color: #333;
        }
        .tab.active {
            background-color: #2036CA;
            border-color: #2036CA;
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
        .category-badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 12px;
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
            max-width: 300px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
    </style>
    <script>
        function deleteBoard(boardId, category) {
            if (confirm('정말 이 게시글을 삭제하시겠습니까?')) {
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
                boardIdInput.value = boardId;
                
                var categoryInput = document.createElement('input');
                categoryInput.type = 'hidden';
                categoryInput.name = 'category';
                categoryInput.value = category;
                
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
        <span>📋 게시판 관리</span>
        <a href="admin-dashboard.jsp" class="back-btn">← 대시보드로</a>
    </div>
</div>

<div class="container">
    <h2>게시판 관리</h2>
    
    <!-- 카테고리 탭 -->
    <div class="category-tabs">
        <a href="admin-board.do" class="tab <%= "all".equals(currentCategory) ? "active" : "" %>">전체</a>
        <a href="admin-board.do?category=free" class="tab <%= "free".equals(currentCategory) ? "active" : "" %>">자유게시판</a>
        <a href="admin-board.do?category=level" class="tab <%= "level".equals(currentCategory) ? "active" : "" %>">등업게시판</a>
        <a href="admin-board.do?category=secret" class="tab <%= "secret".equals(currentCategory) ? "active" : "" %>">비밀게시판</a>
    </div>
    
    <div class="table-container">
        <% if (boards == null || boards.isEmpty()) { %>
            <p style="text-align:center; padding:40px; color:#999;">게시글이 없습니다.</p>
        <% } else { %>
            <table>
                <thead>
                    <tr>
                        <th>번호</th>
                        <th>카테고리</th>
                        <th>제목</th>
                        <th>내용 미리보기</th>
                        <th>작성자</th>
                        <th>작성일</th>
                        <th>관리</th>
                    </tr>
                </thead>
                <tbody>
				    <% 
				    for (BoardDTO board : boards) { 
				        String categoryName = "";
				        String categoryValue = board.getCategory();
				        
				        if ("free".equals(categoryValue)) {
				            categoryName = "자유";
				        } else if ("level".equals(categoryValue)) {
				            categoryName = "등업";
				        } else if ("secret".equals(categoryValue)) {
				            categoryName = "비밀";
				        }
				    %>
				    <tr>
				        <td><%= board.getBoardId() %></td>
				        <td>
				            <span class="category-badge category-<%= categoryValue %>">
				                <%= categoryName %>
				            </span>
				        </td>
				        <td>
				            <a href="admin-board-detail.do?boardId=<%= board.getBoardId() %>&category=<%= currentCategory %>" 
				               style="color:#fff; text-decoration:none; cursor:pointer;">
				                <%= board.getTitle() %>
				            </a>
				        </td>
				        <td class="content-preview"><%= board.getContent() %></td>
				        <td><%= board.getUserid() %></td>
				        <td><%= board.getCreatedAt() %></td>
				        <td>
				            <button class="btn-delete" 
				                    onclick="deleteBoard(<%= board.getBoardId() %>, '<%= currentCategory %>')">
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