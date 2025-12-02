<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="com.dongyang.dongflix.dto.BoardDTO" %>
<%@ include file="/common/header.jsp" %>


<%
    BoardDTO b = (BoardDTO) request.getAttribute("dto");
    if (b == null) {
        response.sendRedirect("list");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title><%= b.getTitle() %> - 게시글</title>

<style>
body {
    background: #000;
    color: #fff;
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
    margin: 0;
    padding: 0;
}

.detail-container {
    max-width: 900px;
    margin: 120px auto;
    background: #111;
    padding: 30px;
    border-radius: 16px;
    box-shadow: 0 10px 40px rgba(0,0,0,0.6);
}

/* 제목 */
.post-title {
    font-size: 28px;
    font-weight: 700;
    margin-bottom: 10px;
    color: #e50914;
}

/* 작성 정보 */
.post-meta {
    font-size: 14px;
    color: #ccc;
    margin-bottom: 30px;
}

/* 내용 */
.post-content {
    background: #1a1a1a;
    padding: 20px;
    line-height: 1.6;
    border-radius: 12px;
    border: 1px solid #333;
    font-size: 16px;
}

/* 버튼 영역 */
.post-actions {
    margin-top: 25px;
    display: flex;
    gap: 12px;
}

.post-actions a {
    padding: 10px 18px;
    border-radius: 8px;
    color: #fff;
    text-decoration: none;
    font-size: 14px;
}

.btn-edit {
    background: #e50914;
}

.btn-edit:hover {
    background: #b20710;
}

.btn-delete {
    background: #555;
}

.btn-delete:hover {
    background: #333;
}

.btn-back {
    background: #222;
}

.btn-back:hover {
    background: #333;
}
</style>

</head>
<body>

<div class="detail-container">

    <div class="post-title"><%= b.getTitle() %></div>

    <div class="post-meta">
        작성자 : <%= b.getUserid() %> &nbsp; | &nbsp;
        작성일 : <%= b.getCreatedAt() %> &nbsp; | &nbsp;
        분류 : <%= b.getCategory() %>
    </div>

    <div class="post-content">
        <%= b.getContent().replaceAll("\n", "<br>") %>
    </div>

    <div class="post-actions">
        <a class="btn-back" href="list?category=<%= b.getCategory() %>">← 목록으로</a>
    	 <a class="btn-edit" 
   href="<%=request.getContextPath()%>/board/updateForm?id=<%= b.getBoardId() %>">
   ✏ 수정
</a>


        <a class="btn-delete" href="delete?id=<%= b.getBoardId() %>"
           onclick="return confirm('정말 삭제할까요?')">🗑 삭제</a>
    </div>

</div>

</body>
</html>
