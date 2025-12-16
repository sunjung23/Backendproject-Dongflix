<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.dongyang.dongflix.dto.BoardDTO" %>
<%@ page import="com.dongyang.dongflix.dto.MemberDTO" %>
<%@ page import="com.dongyang.dongflix.dao.MemberDAO" %>
<%@ include file="/common/header.jsp" %>

<%

    // 기본 데이터 세팅

    List<BoardDTO> list = (List<BoardDTO>) request.getAttribute("list");
    String category = (String) request.getAttribute("category");
    String sort = (String) request.getAttribute("sort");

    if (category == null) category = "all";
    if (sort == null) sort = "new";

    MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
    MemberDAO mdao = new MemberDAO();


    // 비밀게시판 필터링 + 페이지네이션용 리스트 구성
    
    List<BoardDTO> visibleList = new java.util.ArrayList<BoardDTO>();
    if (list != null) {
        for (BoardDTO b : list) {
            boolean isSecret = "secret".equals(b.getCategory());
            boolean isGold = (loginUser != null && "gold".equalsIgnoreCase(loginUser.getGrade()));
            // 비밀게시판 GOLD가 아니면 아예 보이지 않게
            if (isSecret && !isGold) continue;
            visibleList.add(b);
        }
    }

    int totalCount = visibleList.size();   // 화면에 실제로 보여줄 게시글 개수
    int pageSize = 9;                     // 한 페이지당 9개
    int currentPage = 1;

    try {
        if (request.getParameter("page") != null) {
            currentPage = Integer.parseInt(request.getParameter("page"));
        }
    } catch (NumberFormatException e) {
        currentPage = 1;
    }
    if (currentPage < 1) currentPage = 1;

    int totalPage = (int) Math.ceil((double) totalCount / pageSize);
    if (totalPage == 0) totalPage = 1;
    if (currentPage > totalPage) currentPage = totalPage;

    int start = (currentPage - 1) * pageSize;
    int end = Math.min(start + pageSize, totalCount);
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시판 목록 - DONGFLIX</title>

<style>

* {
    box-sizing: border-box;
}

body {
    margin:0;
    background:#05080f; /* 딥네이비 */
    color:#e6e6e6;
    font-family:-apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
}


.board-wrapper {
    min-height:100vh;
    padding:100px 16px 40px;
    background:
        radial-gradient(circle at 15% 10%, rgba(32,95,242,0.20) 0%, transparent 55%),
        linear-gradient(180deg, #05080f 0%, #070b12 40%, #05080f 100%);
}


.board-container {
    max-width:960px;
    margin:0 auto;
    padding:32px 28px;
    background:rgba(10,15,25,0.92);
    border-radius:22px;
    border:1px solid rgba(255,255,255,0.06);
    box-shadow:0 18px 48px rgba(0,0,0,0.7);
    backdrop-filter:blur(6px);
}

/* 타이틀 */
.board-container h2 {
    font-size:32px;
    font-weight:800;
    margin:0 0 6px;
    background:linear-gradient(90deg,#3F6FFF,#205FF2);
    -webkit-background-clip:text;
    color:transparent;
}
.board-subtitle {
    font-size:13px;
    color:#96a1b5;
    margin-bottom:22px;
}


.board-tabs {
    display:flex;
    gap:10px;
    flex-wrap:wrap;
    margin-bottom:20px;
}

.board-tabs a {
    padding:8px 16px;
    border-radius:14px;
    background:#0b0f18;
    color:#aeb7cc;
    border:1px solid rgba(255,255,255,0.05);
    text-decoration:none;
    font-size:13px;
    transition:.2s;
}
.board-tabs a:hover {
    background:#111722;
    border-color:rgba(255,255,255,0.12);
    color:#fff;
}
.board-tabs a.active {
    background:#205FF2;
    color:#fff;
    border-color:#205FF2;
    box-shadow:0 0 10px rgba(32,95,242,0.4);
}


.sort-area {
    display:flex;
    justify-content:space-between;
    align-items:center;
    margin-bottom:18px;
    gap:16px;
}

.sort-buttons { display:flex; gap:8px; }

.sort-area a {
    padding:6px 14px;
    border-radius:14px;
    background:#0b0f18;
    color:#aeb7cc;
    font-size:12px;
    border:1px solid rgba(255,255,255,0.06);
    text-decoration:none;
    transition:.2s;
}
.sort-area a:hover { background:#111722; color:#fff; }

.sort-area a.active-sort {
    color:#3F6FFF;
    border-color:#3F6FFF;
    box-shadow:0 0 8px rgba(63,111,255,0.4);
}

/* 글쓰기 버튼 */
.write-btn {
    display:inline-flex;
    align-items:center;
    gap:6px;
    padding:8px 18px;
    background:#3F6FFF;
    border-radius:14px;
    color:#fff;
    text-decoration:none;
    font-size:13px;
    font-weight:600;
    border:1px solid #3F6FFF;
    transition:.2s;
}
.write-btn:hover {
    background:#205FF2;
    border-color:#205FF2;
}


.board-item {
    background:#0b111d;
    padding:18px;
    border-radius:16px;
    border:1px solid rgba(255,255,255,0.04);
    margin-bottom:16px;
    transition:.22s;
    box-shadow:0 4px 14px rgba(0,0,0,0.5);
}
.board-item:hover {
    background:#0e1625;
    border-color:rgba(255,255,255,0.1);
    transform:translateY(-2px);
}

/* 제목 */
.board-title a {
    font-size:18px;
    font-weight:700;
    text-decoration:none;
    color:#e6e6e6;
    transition:.2s;
    display:flex;
    align-items:center;
    gap:8px;
}
.board-title a:hover {
    color:#3F6FFF;
}

/* GOLD 배지 */
.gold-badge {
    font-size:10px;
    padding:3px 8px;
    border-radius:10px;
    background:linear-gradient(145deg,#ffe47a,#ffce2e);
    color:#3d2c00;
    font-weight:700;
}


.board-meta {
    margin:8px 0 10px;
    color:#9da8bc;
    font-size:12px;
    display:flex;
    flex-wrap:wrap;
    gap:6px;
}
.board-meta a {
    color:#3F6FFF;
    text-decoration:none;
}
.board-meta a:hover { text-decoration:underline; }

.meta-dot::before {
    content:"•";
    margin:0 4px;
    opacity:0.4;
}


.board-preview {
    color:#cfd4df;
    font-size:14px;
    line-height:1.6;
    max-height:3.4em;
    overflow:hidden;
    text-overflow:ellipsis;
}


.pagination {
    margin-top:24px;
    display:flex;
    justify-content:center;
    gap:8px;
    flex-wrap:wrap;
}

.page-link {
    min-width:32px;
    padding:6px 10px;
    border-radius:999px;
    background:#0b0f18;
    border:1px solid rgba(255,255,255,0.06);
    color:#aeb7cc;
    font-size:13px;
    text-align:center;
    text-decoration:none;
    transition:.2s;
}
.page-link:hover {
    background:#111722;
    color:#fff;
    border-color:rgba(255,255,255,0.2);
}
.page-link.active {
    background:#205FF2;
    color:#fff;
    border-color:#205FF2;
    box-shadow:0 0 8px rgba(32,95,242,0.5);
}
.page-link.disabled {
    opacity:0.35;
    pointer-events:none;
}


@media (max-width:768px) {
    .sort-area { flex-direction:column-reverse; align-items:flex-start; }
    .write-btn { align-self:flex-end; }
}
</style>
</head>

<body>

<div class="board-wrapper">
<div class="board-container">

    <h2>게시판</h2>
    <div class="board-subtitle">
        DONGFLIX 커뮤니티에서 자유롭게 의견을 나눠보세요.
    </div>

    <!-- 카테고리 탭 -->
    <div class="board-tabs">
        <a href="list"
           class="<%= "all".equals(category) ? "active" : "" %>">전체</a>

        <a href="list?category=free"
           class="<%= "free".equals(category) ? "active" : "" %>">📢 자유게시판</a>

        <a href="list?category=level"
           class="<%= "level".equals(category) ? "active" : "" %>">⬆️ 등업게시판</a>

        <a href="list?category=secret"
           class="<%= "secret".equals(category) ? "active" : "" %>">🔒 비밀게시판</a>
    </div>

    <!-- 정렬 + 글쓰기 -->
    <div class="sort-area">
        <div class="sort-buttons">
            <a href="list?category=<%= category %>&sort=new"
               class="<%= "new".equals(sort) ? "active-sort" : "" %>">최신순</a>

            <a href="list?category=<%= category %>&sort=old"
               class="<%= "old".equals(sort) ? "active-sort" : "" %>">오래된순</a>

            <a href="list?category=<%= category %>&sort=views"
               class="<%= "views".equals(sort) ? "active-sort" : "" %>">조회수순</a>
        </div>

        <a href="writeForm.jsp" class="write-btn">글쓰기</a>
    </div>

    <!-- 게시글 리스트 -->
    <% if (visibleList == null || visibleList.isEmpty()) { %>

        <p style="color:#96a1b5; margin-top:10px;">게시글이 없습니다.</p>

    <% } else { %>

        <% for (int i = start; i < end; i++) {
               BoardDTO b = visibleList.get(i);

               boolean isSecret = "secret".equals(b.getCategory()); // GOLD에게는 잠금표시만
               String nickname = mdao.getOrCreateNickname(b.getUserid());
        %>

            <div class="board-item">

                <!-- 제목 -->
                <div class="board-title">
                    <a href="detail?id=<%= b.getBoardId() %>">
                        <% if (isSecret) { %>
                            🔒 <%= b.getTitle() %>
                            <span class="gold-badge">GOLD</span>
                        <% } else { %>
                            <%= b.getTitle() %>
                        <% } %>
                    </a>
                </div>

                <!-- 메타 -->
                <div class="board-meta">
                    <span>작성자:
                        <a href="<%= request.getContextPath() %>/user/profile?userid=<%= b.getUserid() %>">
                            <%= nickname %>
                        </a>
                    </span>
                    <span class="meta-dot"></span>
                    <span>날짜: <%= b.getCreatedAt() %></span>
                    <span class="meta-dot"></span>
                    <span>조회수: <%= b.getViews() %></span>
                </div>

                <!-- 본문 프리뷰 -->
                <div class="board-preview">
                    <%= (b.getContent().length() > 90)
                            ? b.getContent().substring(0, 90) + "..."
                            : b.getContent() %>
                </div>

            </div>

        <% } %>

        <!-- 페이지네이션 -->
        <%
            if (totalCount > 0) {
                String baseUrl = "list?category=" + category + "&sort=" + sort + "&page=";
                int windowSize = 5; // 중앙에 5개 페이지 노출
                int startPage = Math.max(1, currentPage - 2);
                int endPage = Math.min(totalPage, startPage + windowSize - 1);
                if (endPage - startPage < windowSize - 1) {
                    startPage = Math.max(1, endPage - windowSize + 1);
                }
        %>
        <div class="pagination">
            <!-- 이전 -->
            <a class="page-link <%= (currentPage == 1 ? "disabled" : "") %>"
               href="<%= (currentPage == 1) ? "#" : (baseUrl + (currentPage - 1)) %>">
                이전
            </a>

            <!-- 페이지 번호 -->
            <% for (int p = startPage; p <= endPage; p++) { %>
                <a class="page-link <%= (p == currentPage ? "active" : "") %>"
                   href="<%= baseUrl + p %>">
                    <%= p %>
                </a>
            <% } %>

            <!-- 다음 -->
            <a class="page-link <%= (currentPage == totalPage ? "disabled" : "") %>"
               href="<%= (currentPage == totalPage) ? "#" : (baseUrl + (currentPage + 1)) %>">
                다음
            </a>
        </div>
        <% } %>

    <% } %>

</div>
</div>

</body>
<%@ include file="/common/alert.jsp" %>
</html>
