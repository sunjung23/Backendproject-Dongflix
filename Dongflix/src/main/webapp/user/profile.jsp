<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.dongyang.dongflix.dto.MemberDTO" %>
<%@ page import="com.dongyang.dongflix.dto.BoardDTO" %>
<%@ page import="com.dongyang.dongflix.dto.ReviewDTO" %>
<%@ include file="/common/header.jsp" %>

<%
    MemberDTO owner = (MemberDTO) request.getAttribute("owner");
    if (owner == null) {
        response.sendRedirect(request.getContextPath() + "/indexMovie");
        return;
    }

    List<BoardDTO> boards = (List<BoardDTO>) request.getAttribute("boards");
    List<ReviewDTO> reviews = (List<ReviewDTO>) request.getAttribute("reviews");
    List<MemberDTO> recentVisitors = (List<MemberDTO>) request.getAttribute("recentVisitors");

    int visitCount = (request.getAttribute("visitCount") != null)
            ? (Integer) request.getAttribute("visitCount")
            : 0;

    int boardCount = (boards != null) ? boards.size() : 0;
    int reviewCount = (reviews != null) ? reviews.size() : 0;

    // ========= 게시글 페이지네이션 (6개 = 3×2) =========
    int boardPageSize = 6;
    int boardPageNum = 1;
    try {
        if (request.getParameter("boardPage") != null) {
            boardPageNum = Integer.parseInt(request.getParameter("boardPage"));
        }
    } catch (NumberFormatException e) {
        boardPageNum = 1;
    }
    if (boardPageNum < 1) boardPageNum = 1;
    int boardTotalPage = (boardCount == 0) ? 1 : (int) Math.ceil(boardCount / (double) boardPageSize);
    if (boardPageNum > boardTotalPage) boardPageNum = boardTotalPage;

    int boardStart = (boardPageNum - 1) * boardPageSize;
    int boardEnd = Math.min(boardStart + boardPageSize, boardCount);

    // ========= 리뷰 페이지네이션 (6개 = 3×2) =========
    int reviewPageSize = 6;
    int reviewPageNum = 1;
    try {
        if (request.getParameter("reviewPage") != null) {
            reviewPageNum = Integer.parseInt(request.getParameter("reviewPage"));
        }
    } catch (NumberFormatException e) {
        reviewPageNum = 1;
    }
    if (reviewPageNum < 1) reviewPageNum = 1;
    int reviewTotalPage = (reviewCount == 0) ? 1 : (int) Math.ceil(reviewCount / (double) reviewPageSize);
    if (reviewPageNum > reviewTotalPage) reviewPageNum = reviewTotalPage;

    int reviewStart = (reviewPageNum - 1) * reviewPageSize;
    int reviewEnd = Math.min(reviewStart + reviewPageSize, reviewCount);

    // 프로필 페이징용 기본 URL
    String baseProfileUrl = request.getContextPath() + "/user/profile?userid=" + owner.getUserid();
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title><%= owner.getUserid() %> 프로필 - DONGFLIX</title>

<style>
/* ============================================
   GLOBAL NAVY / ROYAL BLUE PREMIUM THEME
============================================ */
* {
    box-sizing: border-box;
}
body {
    margin:0;
    background:#000;
    color:#fff;
    font-family:-apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
}

/* 배경 */
.profile-bg {
    padding:120px 20px;
    min-height:100vh;
    background:
        radial-gradient(circle at 20% 10%, rgba(40,70,160,0.25) 0%, transparent 55%),
        radial-gradient(circle at 80% 90%, rgba(90,130,255,0.22) 0%, transparent 55%),
        #000;
}

/* 메인 컨테이너 (Glass) */
.profile-container {
    max-width:1000px;
    margin:0 auto;
    background:rgba(10,10,20,0.94);
    padding:40px 36px;
    border-radius:26px;
    border:1px solid rgba(120,150,255,0.14);
    box-shadow:0 22px 60px rgba(0,0,30,0.85);
    backdrop-filter:blur(7px);
}

/* ============================================
   상단 프로필 영역
============================================ */
.profile-top {
    display:flex;
    gap:26px;
    align-items:center;
}

.profile-avatar {
    width:120px;
    height:120px;
    border-radius:50%;
    background:#222;
    background-size:cover;
    background-position:center;
    border:3px solid #273a80;
}

.profile-main-name {
    font-size:26px;
    font-weight:800;
    margin-bottom:4px;
}

.profile-sub {
    font-size:14px;
    color:#adb3d8;
    margin-bottom:8px;
}

/* 등급/취향 배지 */
.grade-badge {
    padding:6px 12px;
    border-radius:20px;
    font-size:12px;
    display:inline-block;
}

.grade-bronze { background:rgba(205,127,50,0.22); color:#e2b77c; }
.grade-silver { background:rgba(192,192,192,0.25); color:#f0f0f0; }
.grade-gold   { background:rgba(255,215,0,0.30); color:#ffe680; }

.movie-style-badge {
    display:inline-block;
    padding:6px 14px;
    border-radius:20px;
    font-size:13px;
    margin-top:4px;
    background:rgba(64,110,255,0.25);
    border:1px solid rgba(80,120,255,0.35);
    color:#dbe1ff;
    font-weight:600;
}

/* ============================================
   통계 영역 (작성글, 리뷰, 방문수, 취향)
============================================ */
.profile-stats {
    margin-top:22px;
    display:grid;
    grid-template-columns:repeat(3, minmax(0,1fr));
    gap:16px;
}

.profile-stat-box {
    padding:16px 18px;
    border-radius:18px;
    background:#101426;
    border:1px solid rgba(110,140,255,0.20);
    font-size:13px;
}

.profile-stat-label {
    color:#9aa4d1;
    margin-bottom:4px;
    text-transform:uppercase;
    font-size:11px;
    letter-spacing:.05em;
}

.profile-stat-value {
    font-size:20px;
    font-weight:700;
    color:#f3f4ff;
}

/* 영화 취향 카드 (나의 유형) */
.taste-card {
    grid-column:1 / -1;
    margin-top:4px;
    padding:16px 18px;
    border-radius:18px;
    background:linear-gradient(135deg, rgba(32,95,242,0.25), rgba(116,172,255,0.15));
    border:1px solid rgba(120,160,255,0.55);
    display:flex;
    align-items:center;
    justify-content:space-between;
    gap:16px;
}
.taste-main {
    display:flex;
    align-items:center;
    gap:12px;
}
.taste-emoji {
    font-size:30px;
}
.taste-text-title {
    font-size:15px;
    font-weight:700;
}
.taste-text-sub {
    font-size:13px;
    color:#d3dcff;
}
.taste-subbtn {
    font-size:12px;
    padding:6px 12px;
    border-radius:999px;
    border:1px solid rgba(220,230,255,0.8);
    background:rgba(12,18,40,0.9);
    color:#f4f6ff;
    text-decoration:none;
}

/* ============================================
   섹션 공통
============================================ */
.section-header {
    display:flex;
    justify-content:space-between;
    align-items:center;
    margin:34px 0 14px;
}

.section-title {
    font-size:19px;
    font-weight:700;
    border-left:4px solid #3f6fff;
    padding-left:10px;
}

.section-badge {
    font-size:13px;
    padding:5px 11px;
    border-radius:999px;
    background:#101426;
    border:1px solid rgba(90,120,255,0.35);
    color:#dbe1ff;
}

/* ============================================
   최근 방문자 (칩 + 가로 스크롤)
============================================ */
.visitor-list {
    display:flex;
    flex-wrap:wrap;
    gap:10px;
    margin-top:6px;
}

.visitor-item {
    display:flex;
    align-items:center;
    gap:8px;
    padding:7px 10px;
    border-radius:999px;
    background:#111527;
    border:1px solid rgba(90,120,255,0.26);
    font-size:13px;
}

.visitor-avatar {
    width:26px;
    height:26px;
    border-radius:50%;
    background:#222;
    background-size:cover;
    background-position:center;
}

/* ============================================
   게시글 / 리뷰 카드 그리드 (3×2)
============================================ */
.card-grid {
    display:grid;
    grid-template-columns:repeat(3, minmax(0,1fr));
    gap:16px;
}

/* 게시판 카드 */
.board-card {
    background:#101426;
    border-radius:16px;
    padding:14px 14px 12px;
    border:1px solid rgba(110,140,255,0.20);
    box-shadow:0 8px 24px rgba(0,0,40,0.6);
    transition:.22s;
    display:flex;
    flex-direction:column;
    min-height:140px;
}
.board-card:hover {
    background:#141a32;
    border-color:#3f6fff;
    transform:translateY(-3px);
    box-shadow:0 14px 32px rgba(63,111,255,0.35);
}
.board-title {
    font-size:15px;
    font-weight:600;
    margin-bottom:6px;
}
.board-title a {
    color:#f5f5ff;
    text-decoration:none;
}
.board-title a:hover {
    color:#7fa0ff;
}
.board-meta {
    font-size:11px;
    color:#a9b2de;
    margin-bottom:6px;
}
.board-preview {
    font-size:13px;
    color:#d4daf8;
    line-height:1.5;
    margin-top:auto;
}

/* 리뷰 카드 */
.review-card {
    background:#101426;
    border-radius:16px;
    padding:12px;
    border:1px solid rgba(90,120,255,0.20);
    display:flex;
    flex-direction:column;
    gap:8px;
    transition:.22s;
    min-height:160px;
}
.review-card:hover {
    background:#141a38;
    border-color:#3f6fff;
    box-shadow:0 14px 32px rgba(63,111,255,0.32);
    transform:translateY(-3px);
}
.review-movie {
    font-size:14px;
    font-weight:600;
    color:#f3f4ff;
}
.review-meta {
    font-size:12px;
    color:#aab4e8;
}
.review-content {
    font-size:13px;
    color:#d7dbff;
    line-height:1.5;
    margin-top:auto;
}

/* ============================================
   페이지네이션
============================================ */
.pagination {
    margin-top:18px;
    display:flex;
    justify-content:center;
    align-items:center;
    gap:6px;
}
.pagination a,
.pagination span {
    min-width:32px;
    padding:6px 10px;
    border-radius:999px;
    font-size:13px;
    text-align:center;
    text-decoration:none;
    border:1px solid rgba(90,120,255,0.35);
    background:#0c1022;
    color:#ced5ff;
    cursor:pointer;
    transition:.18s;
}
.pagination a:hover {
    background:#3f6fff;
    color:#fff;
}
.pagination .active-page {
    background:#3f6fff;
    color:#fff;
    border-color:#3f6fff;
}
.pagination .disabled {
    opacity:0.35;
    cursor:default;
}

/* ============================================
   반응형
============================================ */
@media (max-width:900px) {
    .card-grid {
        grid-template-columns:repeat(2,minmax(0,1fr));
    }
    .profile-stats {
        grid-template-columns:repeat(2,minmax(0,1fr));
    }
}
@media (max-width:600px) {
    .profile-container { padding:26px 18px; }
    .profile-top { flex-direction:column; align-items:flex-start; }
    .card-grid {
        grid-template-columns:repeat(1,minmax(0,1fr));
    }
    .profile-stats {
        grid-template-columns:repeat(1,minmax(0,1fr));
    }
}
</style>
</head>
<body>

<div class="profile-bg">
<div class="profile-container">

    <!-- ================================
         상단 프로필 정보
    ================================= -->
    <div class="profile-top">
        <div class="profile-avatar"
             style="background-image:url('<%= 
                (owner.getProfileImg() != null && !owner.getProfileImg().isEmpty())
                ? owner.getProfileImg()
                : "img/default_profile.png"
             %>');"></div>

        <div>
            <div class="profile-main-name">
                <%= (owner.getNickname() != null && !owner.getNickname().isEmpty())
                        ? owner.getNickname()
                        : owner.getUserid() %>
            </div>
            <div class="profile-sub">
                @<%= owner.getUserid() %> 
            </div>

            <div style="display:flex; flex-wrap:wrap; gap:8px; align-items:center;">
                <span class="grade-badge 
                    <%
                        String g = owner.getGrade() != null ? owner.getGrade().toLowerCase() : "";
                        if("bronze".equals(g)) out.print("grade-bronze");
                        else if("silver".equals(g)) out.print("grade-silver");
                        else if("gold".equals(g)) out.print("grade-gold");
                    %>">
                    <%= owner.getGrade() %>
                </span>

                <% if (owner.getMovieStyle() != null && !owner.getMovieStyle().isEmpty()) { %>
                    <span class="movie-style-badge"><%= owner.getMovieStyle() %></span>
                <% } %>
            </div>
        </div>
    </div>

    <!-- ================================
         통계 + 영화 취향 유형
    ================================= -->
    <div class="profile-stats">
        <div class="profile-stat-box">
            <div class="profile-stat-label">게시글</div>
            <div class="profile-stat-value"><%= boardCount %></div>
        </div>
        <div class="profile-stat-box">
            <div class="profile-stat-label">리뷰</div>
            <div class="profile-stat-value"><%= reviewCount %></div>
        </div>
        <div class="profile-stat-box">
            <div class="profile-stat-label">프로필 방문</div>
            <div class="profile-stat-value"><%= visitCount %></div>
        </div>

        <!-- 영화 취향 유형 카드 -->
        <div class="taste-card">
            <div class="taste-main">
                <div class="taste-emoji">
                    <%
                        String movieStyle = owner.getMovieStyle();
                        String emoji = "🎬";
                        if (movieStyle != null && !movieStyle.isEmpty()) {
                            // 저장 형식이 "😂 코미디·가벼운 ~" 이런 식이라면 첫 글자 이모지 분리 시도
                            if (movieStyle.length() > 1 && !Character.isLetterOrDigit(movieStyle.charAt(0))) {
                                emoji = movieStyle.substring(0,1);
                            }
                        }
                    %>
                    <%= emoji %>
                </div>
                <div>
                    <div class="taste-text-title"> <%= (owner.getNickname()!=null && !owner.getNickname().isEmpty())
                            ? owner.getNickname() : owner.getUserid()
                        %> 님의 영화 취향 유형</div>
                    <div class="taste-text-sub">
                        <% if (movieStyle != null && !movieStyle.isEmpty()) { %>
                            <%= movieStyle %>
                        <% } else { %>
                            아직 영화 취향 테스트 결과가 없습니다.  
                            이 사용자는 테스트를 진행하면 영화 취향이 여기 표시돼요.
                        <% } %>
                    </div>
                </div>
            </div>
            <a class="taste-subbtn" href="<%= request.getContextPath() %>/movieTest">
                나도 테스트 받으러 가기
            </a>
        </div>
    </div>

    <!-- ================================
         최근 프로필 방문자
    ================================= -->
    <div class="section-header" style="margin-top:30px;">
        <div class="section-title">최근 프로필 방문자</div>
        <div class="section-badge"><%= (recentVisitors != null) ? recentVisitors.size() : 0 %>명</div>
    </div>

    <% if (recentVisitors == null || recentVisitors.isEmpty()) { %>
        <p style="font-size:14px; color:#bfc6e6;">아직 방문한 사용자가 없습니다.</p>
    <% } else { %>
        <div class="visitor-list">
            <% for (MemberDTO v : recentVisitors) { %>
                <div class="visitor-item">
                    <div class="visitor-avatar"
                         style="background-image:url('<%= 
                            (v.getProfileImg() != null && !v.getProfileImg().isEmpty())
                                ? v.getProfileImg()
                                : "img/default_profile.png"
                         %>');"></div>
                    <span>
                        <%= (v.getNickname() != null && !v.getNickname().isEmpty())
                                ? v.getNickname()
                                : v.getUserid() %>
                    </span>
                </div>
            <% } %>
        </div>
    <% } %>

    <!-- ================================
         작성한 게시글 (3×2 + 페이지네이션)
    ================================= -->
    <div class="section-header">
        <div class="section-title">작성한 게시글</div>
        <div class="section-badge">총 <%= boardCount %>개</div>
    </div>

    <% if (boards == null || boards.isEmpty()) { %>
        <p style="font-size:14px; color:#bfc6e6;">작성한 게시글이 없습니다.</p>
    <% } else { %>

        <div class="card-grid">
            <% for (int i = boardStart; i < boardEnd; i++) {
                   BoardDTO b = boards.get(i);
            %>
                <div class="board-card">
                    <div class="board-title">
                        <a href="<%= request.getContextPath() %>/board/detail?id=<%= b.getBoardId() %>">
                            <%= b.getTitle() %>
                        </a>
                    </div>
                    <div class="board-meta">
                        📅 <%= b.getCreatedAt() %> · 조회수 <%= b.getViews() %>
                    </div>
                    <div class="board-preview">
                        <%= (b.getContent() != null && b.getContent().length() > 80)
                                ? b.getContent().substring(0,80) + "…"
                                : b.getContent() %>
                    </div>
                </div>
            <% } %>
        </div>

        <!-- 게시글 페이지네이션 -->
        <div class="pagination">
            <% 
                // 이전 버튼
                if (boardPageNum > 1) {
            %>
                <a href="<%= baseProfileUrl %>&boardPage=<%= (boardPageNum-1) %>&reviewPage=<%= reviewPageNum %>">이전</a>
            <% } else { %>
                <span class="disabled">이전</span>
            <% } %>

            <% for (int p = 1; p <= boardTotalPage; p++) { %>
                <% if (p == boardPageNum) { %>
                    <span class="active-page"><%= p %></span>
                <% } else { %>
                    <a href="<%= baseProfileUrl %>&boardPage=<%= p %>&reviewPage=<%= reviewPageNum %>"><%= p %></a>
                <% } %>
            <% } %>

            <% if (boardPageNum < boardTotalPage) { %>
                <a href="<%= baseProfileUrl %>&boardPage=<%= (boardPageNum+1) %>&reviewPage=<%= reviewPageNum %>">다음</a>
            <% } else { %>
                <span class="disabled">다음</span>
            <% } %>
        </div>

    <% } %>

    <!-- ================================
         작성한 리뷰 (3×2 + 페이지네이션)
    ================================= -->
    <div class="section-header">
        <div class="section-title">작성한 리뷰</div>
        <div class="section-badge">총 <%= reviewCount %>개</div>
    </div>

    <% if (reviews == null || reviews.isEmpty()) { %>
        <p style="font-size:14px; color:#bfc6e6;">작성한 리뷰가 없습니다.</p>
    <% } else { %>

        <div class="card-grid">
            <% for (int i = reviewStart; i < reviewEnd; i++) {
                   ReviewDTO r = reviews.get(i);
            %>
                <div class="review-card">
                    <div class="review-movie"><%= r.getMovieTitle() %></div>
                    <div class="review-meta">
                        ⭐ <%= r.getRating() %>점 · <%= r.getCreatedAt() %>
                    </div>
                    <div class="review-content">
                        <%= (r.getContent() != null && r.getContent().length() > 80)
                                ? r.getContent().substring(0,80) + "…"
                                : r.getContent() %>
                    </div>
                </div>
            <% } %>
        </div>

        <!-- 리뷰 페이지네이션 -->
        <div class="pagination">
            <% if (reviewPageNum > 1) { %>
                <a href="<%= baseProfileUrl %>&boardPage=<%= boardPageNum %>&reviewPage=<%= (reviewPageNum-1) %>">이전</a>
            <% } else { %>
                <span class="disabled">이전</span>
            <% } %>

            <% for (int p = 1; p <= reviewTotalPage; p++) { %>
                <% if (p == reviewPageNum) { %>
                    <span class="active-page"><%= p %></span>
                <% } else { %>
                    <a href="<%= baseProfileUrl %>&boardPage=<%= boardPageNum %>&reviewPage=<%= p %>"><%= p %></a>
                <% } %>
            <% } %>

            <% if (reviewPageNum < reviewTotalPage) { %>
                <a href="<%= baseProfileUrl %>&boardPage=<%= boardPageNum %>&reviewPage=<%= (reviewPageNum+1) %>">다음</a>
            <% } else { %>
                <span class="disabled">다음</span>
            <% } %>
        </div>

    <% } %>

</div>
</div>

</body>
<%@ include file="/common/alert.jsp" %>
</html>
