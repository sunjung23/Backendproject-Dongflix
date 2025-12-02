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
body {
    background: #000;
    color: #fff;
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
}

/* 전체 컨테이너 */
.board-container {
    max-width: 900px;
    margin: 120px auto;
    background: #111;
    padding: 30px;
    border-radius: 16px;
    box-shadow: 0 10px 40px rgba(0,0,0,0.6);
}

/* 제목 */
.board-container h2 {
    font-size: 28px;
    font-weight: 700;
    margin-bottom: 25px;
}

/* 카테고리 탭 */
.board-tabs {
    display: flex;
    gap: 10px;
    margin-bottom: 18px;
}

.board-tabs a {
    padding: 10px 18px;
    border-radius: 8px;
    background: #1e1e1e;
    color: #fff;
    text-decoration: none;
    font-size: 14px;
    border: 1px solid #333;
    transition: 0.2s;
}

.board-tabs a:hover {
    background: #2b2b2b;
}

.board-tabs a.active {
    background: #e50914;
    border-color: #e50914;
}

/* 정렬 버튼 */
.sort-area {
    display: flex;
    justify-content: flex-end;
    margin-bottom: 10px;
    gap: 12px;
}

.sort-area a {
    color: #ddd;
    font-size: 13px;
    text-decoration: none;
    border: 1px solid #333;
    padding: 6px 12px;
    border-radius: 6px;
    background: #1a1a1a;
}

.sort-area a:hover {
    background: #2a2a2a;
    color: #fff;
}

/* 글쓰기 버튼 */
.write-btn {
    display: inline-block;
    padding: 10px 18px;
    background: #e50914;
    color: #fff;
    border-radius: 8px;
    text-decoration: none;
    margin: 15px 0 20px;
    transition: 0.2s;
}

.write-btn:hover {
    background: #b20710;
}

/* 게시글 카드 */
.board-item {
    background: rgba(255,255,255,0.03);
    padding: 18px;
    border-radius: 12px;
    margin-bottom: 16px;
    border: 1px solid #2b2b2b;
    transition: 0.2s;
}

.board-item:hover {
    background: rgba(255,255,255,0.06);
}

/* 제목 */
.board-title a {
    font-size: 20px;
    font-weight: 600;
    color: #e50914;
    text-decoration: none;
}

.board-title a:hover {
    text-decoration: underline;
}

/* 작성 정보 */
.board-meta {
    font-size: 13px;
    color: #bbb;
    margin: 6px 0 10px;
}

/* 미리보기 */
.board-preview {
    font-size: 15px;
    color: #ddd;
    line-height: 1.5;
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

    <!-- 📌 정렬 -->
    <div class="sort-area">
        <a href="list?category=<%= category %>&sort=new">⬆ 최신순</a>
        <a href="list?category=<%= category %>&sort=old">⬇ 오래된순</a>
    </div>

    <!-- 글쓰기 버튼 -->
    <a class="write-btn" href="writeForm.jsp">✏ 글쓰기</a>

    <hr style="border-color:#333; margin: 20px 0;">

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
