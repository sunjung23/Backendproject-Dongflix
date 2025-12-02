<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.dongyang.dongflix.dto.BoardDTO" %>
<%@ include file="/common/header.jsp" %>

<%
    List<BoardDTO> list = (List<BoardDTO>) request.getAttribute("list");
    String category = (String) request.getAttribute("category");

    if (category == null) category = "all";
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시판 목록</title>

<style>
body { background: #000; color: #fff; font-family: sans-serif; }

.board-container {
    max-width: 900px;
    margin: 120px auto;
    background: #111;
    padding: 25px;
    border-radius: 12px;
}

.board-tabs a {
    padding: 10px 16px;
    margin-right: 10px;
    border-radius: 6px;
    text-decoration: none;
    background: #222;
    color: #fff;
}

.board-tabs a.active {
    background: #e50914;
}

.board-item {
    background: #1a1a1a;
    padding: 15px;
    border-radius: 8px;
    margin-bottom: 12px;
    border: 1px solid #333;
}

.board-title a {
    font-size: 20px;
    color: #e50914;
    text-decoration: none;
}

.board-meta {
    font-size: 13px;
    color: #aaa;
}

.write-btn {
    display: inline-block;
    padding: 10px 14px;
    background: #e50914;
    color: #fff;
    border-radius: 6px;
    text-decoration: none;
    margin-bottom: 15px;
}

</style>
</head>

<body>

<div class="board-container">

    <h2>게시판</h2>

    <!-- 📌 카테고리 탭 -->
    <div class="board-tabs">
        <a href="list" class="<%= category.equals("all") ? "active" : "" %>">전체</a>
        <a href="list?category=free" class="<%= category.equals("free") ? "active" : "" %>">📢 자유게시판</a>
        <a href="list?category=level" class="<%= category.equals("level") ? "active" : "" %>">⬆️ 등업게시판</a>
        <a href="list?category=secret" class="<%= category.equals("secret") ? "active" : "" %>">🔒 비밀게시판</a>
    </div>
    <p>
    <!-- 글쓰기 버튼 -->
    <a class="write-btn" href="writeForm.jsp">✏ 글쓰기</a>

    <hr style="border-color:#333;">

    <% if (list == null || list.isEmpty()) { %>

        <p>게시글이 없습니다.</p>

    <% } else { %>

        <% for(BoardDTO b : list) { %>

            <div class="board-item">
                <div class="board-title">
                    <a href="detail?id=<%= b.getBoardId() %>"><%= b.getTitle() %></a>
                </div>

                <div class="board-meta">
                    작성자: <%= b.getUserid() %> | 날짜: <%= b.getCreatedAt() %> | 분류: <%= b.getCategory() %>
                </div>

                <div class="board-preview">
                    <%= b.getContent().length() > 80 
                        ? b.getContent().substring(0, 80) + "..." 
                        : b.getContent() %>
                </div>
            </div>

        <% } %>

    <% } %>

</div>
</body>
</html>
