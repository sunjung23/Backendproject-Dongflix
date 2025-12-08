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
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title><%= owner.getUserid() %> 프로필 - DONGFLIX</title>

<style>
body {
    margin:0;
    background:#000;
    color:#fff;
    font-family:-apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
}

.profile-bg {
    padding:120px 20px;
    min-height:100vh;
    background:
        radial-gradient(circle at 20% 15%, rgba(229,9,20,0.25) 0%, transparent 55%),
        radial-gradient(circle at 80% 85%, rgba(255,60,60,0.22) 0%, transparent 55%),
        #000;
}

.profile-container {
    max-width:1000px;
    margin:0 auto;
    background:rgba(18,18,18,0.96);
    padding:38px;
    border-radius:24px;
    border:1px solid rgba(255,255,255,0.08);
    box-shadow:0 25px 60px rgba(0,0,0,0.75);
    backdrop-filter:blur(6px);
}

/* 상단 영역 */
.profile-top {
    display:flex;
    gap:24px;
    align-items:center;
}

.profile-avatar {
    width:110px;
    height:110px;
    border-radius:50%;
    background:#222;
    background-size:cover;
    background-position:center;
    border:3px solid #333;
}

.profile-main-name {
    font-size:26px;
    font-weight:800;
    margin-bottom:4px;
}

.profile-sub {
    font-size:14px;
    color:#bdbdbd;
    margin-bottom:8px;
}

.profile-badge {
    display:inline-block;
    margin-top:6px;
    padding:6px 12px;
    border-radius:999px;
    font-size:12px;
    background:#1b1b1b;
    border:1px solid #333;
}

/* 통계 카운트 */
.profile-stats {
    margin-top:22px;
    display:flex;
    flex-wrap:wrap;
    gap:14px;
}

.profile-stat-box {
    min-width:130px;
    padding:12px 16px;
    border-radius:14px;
    background:#141414;
    border:1px solid #262626;
    font-size:13px;
}

.profile-stat-label {
    color:#b0b0b0;
    margin-bottom:4px;
}

.profile-stat-value {
    font-size:18px;
    font-weight:700;
}

/* 섹션 공통 */
.section-header {
    display:flex;
    justify-content:space-between;
    align-items:center;
    margin:34px 0 14px;
}

.section-title {
    font-size:19px;
    font-weight:700;
    border-left:4px solid #e50914;
    padding-left:10px;
}

.section-badge {
    font-size:13px;
    padding:5px 11px;
    border-radius:999px;
    background:#1b1b1b;
    border:1px solid #333;
    color:#d8d8d8;
}

/* 방문자 리스트 */
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
    background:#151515;
    border:1px solid #292929;
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

/* 게시글 목록 간단 카드 */
.board-mini {
    background:#151515;
    border-radius:14px;
    padding:12px 14px;
    border:1px solid #262626;
    margin-bottom:10px;
    font-size:14px;
}

.board-mini-title a {
    color:#e50914;
    text-decoration:none;
    font-weight:600;
}

.board-mini-title a:hover {
    text-decoration:underline;
}

.board-mini-meta {
    font-size:12px;
    color:#a9a9a9;
    margin-top:4px;
}

/* 리뷰 카드 간단 */
.review-mini {
    background:#151515;
    border-radius:14px;
    padding:12px 14px;
    border:1px solid #262626;
    margin-bottom:10px;
    font-size:14px;
}

.review-mini-title {
    font-weight:600;
    margin-bottom:4px;
}

.review-mini-meta {
    font-size:12px;
    color:#a9a9a9;
}

/* 반응형 */
@media (max-width:700px) {
    .profile-container { padding:26px 18px; }
    .profile-top { flex-direction:column; align-items:flex-start; }
}
</style>
</head>
<body>

<div class="profile-bg">
<div class="profile-container">

    <!-- 상단 프로필 -->
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
                @<%= owner.getUserid() %> · 등급: <%= owner.getGrade() %>
            </div>
            <div class="profile-badge">
                프로필 방문 <strong><%= visitCount %></strong>회
            </div>
        </div>
    </div>

    <!-- 통계 -->
    <div class="profile-stats">
        <div class="profile-stat-box">
            <div class="profile-stat-label">작성한 게시글</div>
            <div class="profile-stat-value"><%= boardCount %></div>
        </div>
        <div class="profile-stat-box">
            <div class="profile-stat-label">작성한 리뷰</div>
            <div class="profile-stat-value"><%= reviewCount %></div>
        </div>
        <div class="profile-stat-box">
            <div class="profile-stat-label">프로필 방문</div>
            <div class="profile-stat-value"><%= visitCount %></div>
        </div>
    </div>

    <!-- 최근 방문자 -->
    <div class="section-header" style="margin-top:30px;">
        <div class="section-title">최근 프로필 방문자</div>
    </div>

    <% if (recentVisitors == null || recentVisitors.isEmpty()) { %>
        <p style="font-size:14px; color:#bdbdbd;">아직 방문한 사용자가 없습니다.</p>
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

    <!-- 작성한 게시글 -->
    <div class="section-header">
        <div class="section-title">작성한 게시글</div>
        <div class="section-badge"><%= boardCount %>개</div>
    </div>

    <% if (boards == null || boards.isEmpty()) { %>
        <p style="font-size:14px; color:#bdbdbd;">작성한 게시글이 없습니다.</p>
    <% } else { %>
        <% for (BoardDTO b : boards) { %>
            <div class="board-mini">
                <div class="board-mini-title">
                    <a href="<%= request.getContextPath() %>/board/detail?id=<%= b.getBoardId() %>">
                        <%= b.getTitle() %>
                    </a>
                </div>
                <div class="board-mini-meta">
                    📅 <%= b.getCreatedAt() %> | 조회수 <%= b.getViews() %>
                </div>
            </div>
        <% } %>
    <% } %>

    <!-- 작성한 리뷰 -->
    <div class="section-header">
        <div class="section-title">작성한 리뷰</div>
        <div class="section-badge"><%= reviewCount %>개</div>
    </div>

    <% if (reviews == null || reviews.isEmpty()) { %>
        <p style="font-size:14px; color:#bdbdbd;">작성한 리뷰가 없습니다.</p>
    <% } else { %>
        <% for (ReviewDTO r : reviews) { %>
            <div class="review-mini">
                <div class="review-mini-title"><%= r.getMovieTitle() %></div>
                <div class="review-mini-meta">
                    ⭐ <%= r.getRating() %>점 | <%= r.getCreatedAt() %>
                </div>
            </div>
        <% } %>
    <% } %>

</div>
</div>

</body>
</html>
