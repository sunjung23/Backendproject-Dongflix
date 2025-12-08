<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.dongyang.dongflix.dto.BoardDTO" %>
<%@ include file="/common/header.jsp" %>

<%
    List<BoardDTO> list = (List<BoardDTO>) request.getAttribute("list");
    String category = (String) request.getAttribute("category");
    String sort = (String) request.getAttribute("sort");

    if (category == null) category = "all";
    if (sort == null) sort = "new";
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시판 목록 - DONGFLIX</title>

<style>
/* ============================================================
   GLOBAL Premium Style
   ============================================================ */
body {
    margin:0;
    background:#000;
    color:#fff;
    font-family:-apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
}

/* ============================================================
   전체 배경 + Glow
   ============================================================ */
.board-wrapper {
    min-height:100vh;
    padding:100px 16px;
    background:
        radial-gradient(circle at 18% 20%, rgba(229,9,20,0.4) 0%, transparent 65%),
        radial-gradient(circle at 82% 80%, rgba(255,80,80,0.25) 0%, transparent 65%),
        #000;
}

/* ============================================================
   메인 컨테이너
   ============================================================ */
.board-container {
    max-width:900px;
    margin:0 auto;
    padding:34px 28px;
    background:rgba(15,15,15,0.96);
    border-radius:20px;
    border:1px solid rgba(255,255,255,0.08);
    box-shadow:0 20px 60px rgba(0,0,0,0.7);
    backdrop-filter:blur(5px);
}

.board-container h2 {
    font-size:30px;
    font-weight:800;
    background:linear-gradient(90deg,#ff4040,#e50914);
    -webkit-background-clip:text;
    color:transparent;
    margin-bottom:26px;
}

/* ============================================================
   카테고리 탭
   ============================================================ */
.board-tabs {
    display:flex;
    gap:12px;
    flex-wrap:wrap;
    margin-bottom:22px;
}

.board-tabs a {
    padding:10px 18px;
    border-radius:10px;
    background:#1a1a1a;
    color:#ddd;
    border:1px solid #2b2b2b;
    text-decoration:none;
    font-size:14px;
    transition:.25s;
}

.board-tabs a:hover {
    background:#262626;
}

.board-tabs a.active {
    background:#e50914;
    color:#fff;
    border-color:#e50914;
    box-shadow:0 0 10px rgba(229,9,20,0.4);
}

/* ============================================================
   정렬 버튼
   ============================================================ */
.sort-area {
    display:flex;
    justify-content:flex-end;
    gap:10px;
    margin-bottom:18px;
}

.sort-area a {
    padding:6px 12px;
    border-radius:8px;
    background:#1b1b1b;
    color:#bbb;
    font-size:13px;
    border:1px solid #333;
    text-decoration:none;
    transition:.2s;
}

.sort-area a:hover {
    background:#292929;
    color:#fff;
}

.sort-area a.active-sort {
    color:#e50914;
    border-color:#e50914;
}

/* ============================================================
   글쓰기 버튼
   ============================================================ */
.write-btn {
    display:inline-block;
    padding:12px 20px;
    background:#e50914;
    border-radius:10px;
    color:#fff;
    text-decoration:none;
    margin-bottom:26px;
    font-size:15px;
    font-weight:700;
    transition:.25s;
}

.write-btn:hover {
    background:#b20710;
    box-shadow:0 6px 18px rgba(229,9,20,0.4);
    transform:translateY(-2px);
}

/* ============================================================
   게시글 카드
   ============================================================ */
.board-item {
    background:rgba(255,255,255,0.03);
    padding:22px;
    border-radius:14px;
    border:1px solid rgba(255,255,255,0.06);
    margin-bottom:20px;
    transition:.25s;
}

.board-item:hover {
    background:rgba(255,255,255,0.06);
    transform:translateY(-3px);
}

/* 제목 */
.board-title a {
    font-size:20px;
    font-weight:700;
    text-decoration:none;
    color:#e50914;
    transition:.2s;
}

.board-title a:hover {
    text-decoration:underline;
}

/* 메타 정보 */
.board-meta {
    margin:10px 0 12px;
    color:#bbb;
    font-size:13px;
}

/* 본문 미리보기 */
.board-preview {
    color:#ddd;
    font-size:15px;
    line-height:1.65;
}

/* ============================================================
   반응형
   ============================================================ */
@media (max-width:600px) {
    .board-container { padding:26px 18px; }
    .board-title a { font-size:18px; }
}
</style>
</head>

<body>

<div class="board-wrapper">
<div class="board-container">

    <h2>게시판</h2>

    <!-- 카테고리 탭 -->
    <div class="board-tabs">
        <a href="list" class="<%= "all".equals(category) ? "active" : "" %>">전체</a>
        <a href="list?category=free" class="<%= "free".equals(category) ? "active" : "" %>">📢 자유게시판</a>
        <a href="list?category=level" class="<%= "level".equals(category) ? "active" : "" %>">⬆️ 등업게시판</a>
        <a href="list?category=secret" class="<%= "secret".equals(category) ? "active" : "" %>">🔒 비밀게시판</a>
    </div>

    <!-- 정렬 -->
    <div class="sort-area">
        <a href="list?category=<%= category %>&sort=new"
           class="<%= "new".equals(sort) ? "active-sort" : "" %>">⬆ 최신순</a>

        <a href="list?category=<%= category %>&sort=old"
           class="<%= "old".equals(sort) ? "active-sort" : "" %>">⬇ 오래된순</a>

        <a href="list?category=<%= category %>&sort=views"
           class="<%= "views".equals(sort) ? "active-sort" : "" %>">🔥 조회수순</a>
    </div>

    <!-- 글쓰기 -->
    <a href="writeForm.jsp" class="write-btn">✏ 글쓰기</a>

    <!-- 게시글 리스트 -->
    <% if (list == null || list.isEmpty()) { %>

        <p style="color:#bbb;">게시글이 없습니다.</p>

    <% } else { %>

        <% for (BoardDTO b : list) { %>

            <div class="board-item">
                <div class="board-title">
                    <a href="detail?id=<%= b.getBoardId() %>"><%= b.getTitle() %></a>
                </div>

                <!-- 🔹 메타 정보: 한 줄로 깔끔하게 -->
                <div class="board-meta">
                    작성자:
                    <a href="<%= request.getContextPath() %>/user/profile?userid=<%= b.getUserid() %>"
                       style="color:#e50914; text-decoration:none;">
                        <%= b.getUserid() %>
                    </a>
                    |
                    날짜: <%= b.getCreatedAt() %>
                    |
                    조회수: <%= b.getViews() %>
                </div>

                <div class="board-preview">
                    <%= (b.getContent().length() > 90)
                        ? b.getContent().substring(0, 90) + "..."
                        : b.getContent() %>
                </div>
            </div>

        <% } %>

    <% } %>

</div>
</div>

</body>
</html>
