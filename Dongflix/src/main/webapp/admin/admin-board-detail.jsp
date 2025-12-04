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
    MemberDTO author = (MemberDTO) request.getAttribute("author");
    String category = (String) request.getAttribute("category");
    
    // 프로필에서 넘어왔는지 확인
    String fromProfile = request.getParameter("fromProfile");
    String profileUserid = request.getParameter("userid");
    boolean isFromProfile = "true".equals(fromProfile) && profileUserid != null;
    
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
    
    // 등급 변경 성공 메시지
    String success = request.getParameter("success");
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>게시글 상세보기 - DONGFLIX</title>
    <style>
        /* 기존 스타일 그대로 유지 */
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
        
        /* 성공 메시지 */
        .success-message {
            background-color: #28a745;
            color: white;
            padding: 12px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            text-align: center;
            font-size: 14px;
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
            align-items: flex-start;
            margin-bottom: 15px;
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
        
        /* 등급 변경 폼 */
        .grade-change-section {
            border-top: 1px solid #333;
            padding-top: 15px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .grade-label {
            font-size: 14px;
            color: #b3b3b3;
        }
        
        .grade-select {
            padding: 8px 12px;
            background-color: #333;
            color: white;
            border: 1px solid #555;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
        }
        
        .grade-select:focus {
            outline: none;
            border-color: #2036CA;
        }
        
        .btn-change-grade {
            padding: 8px 16px;
            background-color: #2036CA;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 13px;
            transition: .2s;
        }
        
        .btn-change-grade:hover {
            background-color: #1a2ba3;
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
        
        function changeGrade() {
            var select = document.getElementById('gradeSelect');
            var newGrade = select.value;
            
            if (!newGrade) {
                alert('등급을 선택해주세요.');
                return;
            }
            
            if (confirm('<%= board.getUserid() %> 회원의 등급을 ' + newGrade.toUpperCase() + '(으)로 변경하시겠습니까?')) {
                document.getElementById('gradeForm').submit();
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
    
    <!-- 등급 변경 성공 메시지 -->
    <% if ("1".equals(success)) { %>
        <div class="success-message">
            ✅ 등급이 성공적으로 변경되었습니다!
        </div>
    <% } %>
    
    <!-- 작성자 프로필 박스 (프로필에서 온 경우 숨김) -->
	<% if (!isFromProfile) { %>
	<div class="author-box">
	    <div class="author-header">
	        <div class="author-info">
	            <div class="author-icon">👤</div>
	            <div class="author-details">
	                <div class="author-name">작성자</div>
	                <div class="author-id"><%= board.getUserid() %></div>
	                <% if (author != null) { %>
	                    <span class="current-grade grade-<%= author.getGrade().toLowerCase() %>">
	                        <%= author.getGrade().toUpperCase() %>
	                    </span>
	                <% } %>
	            </div>
	        </div>
	        <a href="admin-member-detail.do?userid=<%= board.getUserid() %>" class="btn-profile">
	            프로필 보기 →
	        </a>
	    </div>
	    
	    <!-- 등급 변경 폼 (등업 게시판일 때만 표시) -->
	    <% if ("level".equals(board.getCategory()) && author != null && !"admin".equals(author.getGrade())) { %>
	        <div class="grade-change-section">
	            <span class="grade-label">등급 변경:</span>
	            <form id="gradeForm" method="post" action="admin-board-detail.do" style="display:flex; align-items:center; gap:10px; flex:1;">
	                <input type="hidden" name="action" value="changeGrade">
	                <input type="hidden" name="userid" value="<%= board.getUserid() %>">
	                <input type="hidden" name="boardId" value="<%= board.getBoardId() %>">
	                <input type="hidden" name="category" value="<%= category != null ? category : "" %>">
	                
	                <select id="gradeSelect" name="grade" class="grade-select">
	                    <option value="">등급 선택</option>
	                    <option value="bronze" <%= "bronze".equals(author.getGrade()) ? "selected" : "" %>>Bronze</option>
	                    <option value="silver" <%= "silver".equals(author.getGrade()) ? "selected" : "" %>>Silver</option>
	                    <option value="gold" <%= "gold".equals(author.getGrade()) ? "selected" : "" %>>Gold</option>
	                </select>
	                
	                <button type="button" class="btn-change-grade" onclick="changeGrade()">
	                    변경
	                </button>
	            </form>
	        </div>
	    <% } %>
	</div>
	<% } %>
    
    <div class="board-container">
        <div class="board-meta">
            <div class="meta-left">
                <span class="category-badge category-<%= board.getCategory() %>">
                    <%= categoryName %>
                </span>
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
            String backUrl;
            if (isFromProfile) {
                // 프로필에서 온 경우 프로필로 복귀
                backUrl = "admin-member-detail.do?userid=" + profileUserid;
        %>
            <a href="<%= backUrl %>" class="btn btn-back">← 프로필로 돌아가기</a>
        <% } else {
                // 게시판 관리에서 온 경우 목록으로
                backUrl = "admin-board.do";
                if (category != null && !category.isEmpty() && !"all".equals(category)) {
                    backUrl += "?category=" + category;
                }
        %>
            <a href="<%= backUrl %>" class="btn btn-back">← 목록으로</a>
            <button class="btn btn-delete" onclick="deleteBoard()">🗑️ 삭제</button>
        <% } %>
    </div>
</div>

</body>
</html>