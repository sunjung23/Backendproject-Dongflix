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
<title><%= b.getTitle() %> - DONGFLIX</title>

<style>
/* ===========================================
   GLOBAL Premium Style
   =========================================== */
body {
    margin:0;
    background:#000;
    color:#fff;
    font-family:-apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
}

/* ===========================================
   배경 (Glow + Deep Black)
   =========================================== */
.detail-bg {
    min-height:100vh;
    padding:100px 16px;
    background:
        radial-gradient(circle at 20% 15%, rgba(229,9,20,0.35) 0%, transparent 60%),
        radial-gradient(circle at 85% 85%, rgba(255,60,60,0.28) 0%, transparent 60%),
        #000;
    display:flex;
    justify-content:center;
    align-items:flex-start;
}

/* ===========================================
   콘텐츠 박스 (Glassmorphism)
   =========================================== */
.detail-container {
    max-width:900px;
    width:100%;
    background:rgba(17,17,17,0.95);
    padding:38px 32px;
    border-radius:20px;
    border:1px solid rgba(255,255,255,0.08);
    box-shadow:0 20px 60px rgba(0,0,0,0.7);
    backdrop-filter:blur(5px);
}

/* ===========================================
   제목
   =========================================== */
.post-title {
    font-size:30px;
    font-weight:800;
    background:linear-gradient(90deg,#ff3d3d,#e50914);
    -webkit-background-clip:text;
    color:transparent;
    margin-bottom:20px;
}

/* ===========================================
   작성 정보
   =========================================== */
.post-meta {
    font-size:14px;
    color:#c9c9c9;
    line-height:1.8;
    margin-bottom:30px;
    padding-left:14px;
    border-left:3px solid #e50914;
}

/* ===========================================
   본문
   =========================================== */
.post-content {
    background:#1a1a1a;
    padding:24px 26px;
    border-radius:16px;
    font-size:16px;
    border:1px solid #2e2e2e;
    line-height:1.75;
    color:#ececec;
}

/* ===========================================
   버튼 영역
   =========================================== */
.post-actions {
    margin-top:32px;
    display:flex;
    flex-wrap:wrap;
    gap:12px;
}

/* 버튼 공통 */
.post-actions a {
    padding:11px 22px;
    border-radius:10px;
    text-decoration:none;
    color:white;
    font-size:14px;
    font-weight:600;
    transition:.22s;
}

/* 목록 버튼 */
.btn-back {
    background:#222;
}
.btn-back:hover {
    background:#333;
}

/* 수정 버튼 */
.btn-edit {
    background:#e50914;
}
.btn-edit:hover {
    background:#b20710;
    box-shadow:0 8px 18px rgba(229,9,20,0.45);
}

/* 삭제 버튼 */
.btn-delete {
    background:#444;
}
.btn-delete:hover {
    background:#222;
}

/* ===========================================
   반응형
   =========================================== */
@media (max-width:700px) {
    .detail-container { padding:24px 20px; }
    .post-title { font-size:24px; }
    .post-content { padding:20px; }
}
</style>
</head>

<body>

<div class="detail-bg">
<div class="detail-container">

    <!-- 🔥 제목 -->
    <div class="post-title"><%= b.getTitle() %></div>

    <!-- 🔥 작성 정보 -->
    <div class="post-meta">
        작성자 : <%= b.getUserid() %><br>
        작성일 : <%= b.getCreatedAt() %><br>
        분류 : <%= b.getCategory() %>><br>
        조회수 : <%= b.getViews() %>회
    </div>

    <!-- 🔥 본문 -->
    <div class="post-content">
        <%= b.getContent().replaceAll("\n", "<br>") %>
    </div>

    <!-- 🔥 버튼 -->
    <div class="post-actions">
        <a class="btn-back" href="list?category=<%= b.getCategory() %>">← 목록으로</a>

        <a class="btn-edit"
           href="<%= request.getContextPath() %>/board/updateForm?id=<%= b.getBoardId() %>">
           ✏ 수정
        </a>

        <a class="btn-delete"
           href="delete?id=<%= b.getBoardId() %>"
           onclick="return confirm('정말 삭제할까요?')">
           🗑 삭제
        </a>
    </div>

</div>
</div>

</body>
</html>
