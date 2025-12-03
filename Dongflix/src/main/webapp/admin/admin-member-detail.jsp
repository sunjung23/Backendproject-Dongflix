<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.dongyang.dongflix.dto.MemberDTO" %>
<%@ page import="com.dongyang.dongflix.dto.ReviewDTO" %>
<%@ page import="com.dongyang.dongflix.dto.LikeMovieDTO" %>
<%@ page import="com.dongyang.dongflix.dto.BoardDTO" %>

<%
    // 관리자 권한 체크
    MemberDTO adminUser = (MemberDTO) session.getAttribute("adminUser");
    if (adminUser == null || !"admin".equals(adminUser.getGrade())) {
        response.sendRedirect("/admin/admin-login.jsp");
        return;
    }

    MemberDTO user = (MemberDTO) request.getAttribute("user");
    List<ReviewDTO> reviews = (List<ReviewDTO>) request.getAttribute("reviews");
    List<LikeMovieDTO> likedMovies = (List<LikeMovieDTO>) request.getAttribute("likedMovies");
    List<BoardDTO> myBoards = (List<BoardDTO>) request.getAttribute("myBoards");

    Object avgObj = request.getAttribute("avgRating");
    double avgRating = 0.0;
    if (avgObj != null) {
        avgRating = (Double) avgObj;
    }

    int likeCount = likedMovies != null ? likedMovies.size() : 0;
    int reviewCount = reviews != null ? reviews.size() : 0;
    int boardCount = myBoards != null ? myBoards.size() : 0;
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 상세정보 - 관리자</title>

<style>
* { margin:0; padding:0; box-sizing:border-box; }

body {
    background:#0d0d0d;
    color:#fff;
    font-family:-apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
}

/* 상단 네비게이션 */
.admin-nav {
    background:#141414;
    padding:18px 32px;
    border-bottom:2px solid #2036CA;
    display:flex;
    justify-content:space-between;
    align-items:center;
}

.admin-nav .logo img {
    height:35px;
    cursor:pointer;
}

.admin-nav .nav-links a {
    margin-left:20px;
    color:#fff;
    text-decoration:none;
    font-size:14px;
    transition:.2s;
}

.admin-nav .nav-links a:hover {
    color:#2036CA;
}

/* 배경 */
.detail-bg {
    padding:80px 20px;
    min-height:100vh;
    background:
        radial-gradient(circle at 20% 15%, rgba(32,54,202,0.2) 0%, transparent 50%),
        radial-gradient(circle at 80% 85%, rgba(32,54,202,0.18) 0%, transparent 50%),
        #000;
}

/* 메인 박스 */
.detail-container {
    max-width:1100px;
    margin:0 auto;
    background:rgba(18,18,18,0.96);
    padding:42px;
    border-radius:24px;
    border:1px solid rgba(255,255,255,0.08);
    box-shadow:0 25px 60px rgba(0,0,0,0.75);
    backdrop-filter:blur(6px);
    animation:fadeIn .7s ease-out;
}

@keyframes fadeIn {
    0% {opacity:0; transform:translateY(10px);}
    100% {opacity:1; transform:translateY(0);}
}

/* 상단 헤더 */
.detail-header {
    display:flex;
    justify-content:space-between;
    align-items:center;
    margin-bottom:30px;
    padding-bottom:20px;
    border-bottom:2px solid #222;
}

.detail-header h2 {
    font-size:26px;
    color:#2036CA;
}

.back-btn {
    padding:10px 20px;
    background:#333;
    border:1px solid #555;
    border-radius:10px;
    color:#fff;
    text-decoration:none;
    font-size:14px;
    transition:.2s;
}

.back-btn:hover {
    background:#2036CA;
    border-color:#2036CA;
}

/* 프로필 영역 */
.profile-section {
    display:flex;
    align-items:center;
    gap:26px;
    margin-bottom:30px;
}

.profile-img {
    width:130px;
    height:130px;
    border-radius:50%;
    background:#222;
    background-size:cover;
    background-position:center;
    border:3px solid #2036CA;
}

.user-name {
    font-size:30px;
    font-weight:800;
    margin-bottom:6px;
}

.user-id {
    font-size:16px;
    color:#999;
    margin-bottom:10px;
}

/* 등급 배지 */
.grade-badge {
    padding:6px 14px;
    border-radius:20px;
    font-size:13px;
    display:inline-block;
    margin-top:6px;
}

.grade-bronze { background:rgba(205,127,50,0.25); color:#e2b77c; }
.grade-silver { background:rgba(192,192,192,0.25); color:#e8e8e8; }
.grade-gold   { background:rgba(255,215,0,0.3); color:#ffe680; }
.grade-admin  { background:rgba(32,54,202,0.3); color:#6b8aff; }

/* 활동 요약 카드 */
.stats-grid {
    margin-top:32px;
    display:grid;
    grid-template-columns:repeat(auto-fit,minmax(240px,1fr));
    gap:18px;
}

.stat-card {
    background:#141414;
    border-radius:18px;
    padding:18px 18px 16px;
    border:1px solid #242424;
}

.stat-top {
    display:flex;
    justify-content:space-between;
    align-items:center;
}

.stat-left {
    display:flex;
    align-items:center;
    gap:10px;
}

.stat-icon {
    font-size:20px;
}

.stat-title {
    font-size:14px;
    color:#d0d0d0;
}

.stat-chip {
    font-size:12px;
    padding:4px 10px;
    border-radius:999px;
    background:rgba(255,255,255,0.07);
    border:1px solid rgba(255,255,255,0.15);
}

.stat-bottom {
    margin-top:10px;
    font-size:13px;
    color:#a8a8a8;
}

/* 섹션 헤더 */
.section-header {
    display:flex;
    justify-content:space-between;
    align-items:center;
    margin:40px 0 16px;
}

.section-title {
    font-size:21px;
    font-weight:700;
    border-left:4px solid #2036CA;
    padding-left:12px;
}

.section-badge {
    font-size:13px;
    padding:6px 12px;
    border-radius:999px;
    background:#1b1b1b;
    border:1px solid #333;
    color:#d8d8d8;
}

/* 정보 카드 그리드 */
.info-grid {
    display:grid;
    grid-template-columns:repeat(auto-fit,minmax(220px,1fr));
    gap:16px;
}

.info-card {
    background:#151515;
    border-radius:16px;
    padding:16px 18px;
    border:1px solid #272727;
}

.info-label {
    font-size:12px;
    color:#9f9f9f;
    letter-spacing:.03em;
    text-transform:uppercase;
}

.info-value {
    margin-top:4px;
    font-size:16px;
    font-weight:600;
}

.info-value.password {
    font-family:monospace;
    letter-spacing:3px;
}

/* 찜한 영화 */
.liked-movies {
    display:grid;
    grid-template-columns:repeat(auto-fill,minmax(160px,1fr));
    gap:18px;
    margin-top:10px;
}

.movie-card {
    background:#171717;
    border-radius:14px;
    padding:10px;
    text-align:center;
    border:1px solid #2a2a2a;
    cursor:pointer;
    transition:.22s;
}

.movie-card:hover {
    border-color:#2036CA;
    box-shadow:0 8px 22px rgba(32,54,202,0.35);
    transform:translateY(-3px);
}

.movie-card img {
    width:100%;
    height:220px;
    object-fit:cover;
    border-radius:10px;
}

/* 리뷰 카드 */
.review-card {
    background:#171717;
    border-radius:14px;
    padding:18px;
    border:1px solid #2a2a2a;
    display:flex;
    gap:14px;
    margin-bottom:14px;
    transition:.22s;
}

.review-card:hover {
    border-color:#2036CA;
}

.review-card img {
    width:90px;
    height:130px;
    border-radius:10px;
    object-fit:cover;
}

.review-info { flex:1; }

.review-info .movie-title {
    font-size:17px;
    font-weight:600;
}

.review-info .rating-date {
    margin:6px 0 10px;
    font-size:13px;
    color:#bdbdbd;
}

.review-info .content-preview {
    font-size:14px;
    color:#ddd;
    max-height:42px;
    overflow:hidden;
}

/* 평균 평점 카드 */
.avg-card {
    margin-top:10px;
    display:inline-flex;
    align-items:center;
    gap:8px;
    background:#181818;
    border-radius:999px;
    padding:8px 14px;
    border:1px solid #333;
    font-size:14px;
    color:#ffdf00;
}

/* 게시글 카드 */
.board-list {
    display:flex;
    flex-direction:column;
    gap:14px;
    margin-top:8px;
}

.board-card {
    background:#171717;
    border-radius:14px;
    padding:16px;
    border:1px solid #2a2a2a;
    transition:.22s;
}

.board-card:hover {
    border-color:#2036CA;
}

.board-title {
    font-size:17px;
    font-weight:600;
    color:#e8e8e8;
}

.board-meta {
    font-size:12px;
    color:#b5b5b5;
    margin:5px 0 8px;
}

.board-preview {
    font-size:14px;
    color:#ddd;
    line-height:1.5;
}

/* 반응형 */
@media (max-width:700px) {
    .detail-container { padding:28px 18px; }
    .profile-section { flex-direction:column; align-items:flex-start; }
}
</style>

</head>

<body>

<!-- 상단 네비게이션 -->
<div class="admin-nav">
    <div class="logo">
        <a href="<%=request.getContextPath()%>/admin/admin-dashboard.jsp">
            <img src="<%=request.getContextPath()%>/img/logo.png" alt="DONGFLIX">
        </a>
    </div>
    <div class="nav-links">
        <a href="<%=request.getContextPath()%>/admin/admin-dashboard.jsp">대시보드</a>
        <a href="<%=request.getContextPath()%>/admin/admin-member.do">회원관리</a>
        <a href="<%=request.getContextPath()%>/admin/admin-post.do">게시글관리</a>
        <a href="<%=request.getContextPath()%>/admin/admin-logout.do">로그아웃</a>
    </div>
</div>

<div class="detail-bg">
<div class="detail-container">

    <!-- 상단 헤더 -->
    <div class="detail-header">
        <h2>회원 상세 정보</h2>
        <a href="<%=request.getContextPath()%>/admin/admin-member.do" class="back-btn">← 목록으로</a>
    </div>

    <!-- 프로필 -->
    <div class="profile-section">
        <div class="profile-img"
             style="background-image:url('<%= 
                (user.getProfileImg()!=null && !user.getProfileImg().isEmpty())
                ? user.getProfileImg()
                : "../img/default_profile.png"
             %>');"></div>

        <div>
            <div class="user-name"><%= user.getUsername() %></div>
            <div class="user-id">@<%= user.getUserid() %></div>

            <span class="grade-badge 
                <%
                    String g = user.getGrade().toLowerCase();
                    if(g.equals("bronze")) out.print("grade-bronze");
                    else if(g.equals("silver")) out.print("grade-silver");
                    else if(g.equals("gold")) out.print("grade-gold");
                    else if(g.equals("admin")) out.print("grade-admin");
                %>">
                등급 : <%= user.getGrade() %>
            </span>
        </div>
    </div>

    <!-- 활동 요약 -->
    <div class="stats-grid">

        <div class="stat-card">
            <div class="stat-top">
                <div class="stat-left">
                    <div class="stat-icon">❤️</div>
                    <div class="stat-title">찜한 영화</div>
                </div>
                <div class="stat-chip">총 <%= likeCount %>편</div>
            </div>
            <div class="stat-bottom">이 회원이 좋아요한 영화 목록</div>
        </div>

        <div class="stat-card">
            <div class="stat-top">
                <div class="stat-left">
                    <div class="stat-icon">⭐</div>
                    <div class="stat-title">작성한 리뷰</div>
                </div>
                <div class="stat-chip"><%= reviewCount %>개 · 평점 <%= String.format("%.2f", avgRating) %></div>
            </div>
            <div class="stat-bottom">이 회원의 평가와 한줄평</div>
        </div>

        <div class="stat-card">
            <div class="stat-top">
                <div class="stat-left">
                    <div class="stat-icon">📝</div>
                    <div class="stat-title">작성한 게시글</div>
                </div>
                <div class="stat-chip"><%= boardCount %>개</div>
            </div>
            <div class="stat-bottom">커뮤니티 활동 내역</div>
        </div>

    </div>

    <!-- 회원 정보 -->
    <div class="section-header">
        <div class="section-title">회원 기본 정보</div>
    </div>

    <div class="info-grid">
        <div class="info-card">
            <div class="info-label">아이디</div>
            <div class="info-value"><%= user.getUserid() %></div>
        </div>
        <div class="info-card">
            <div class="info-label">비밀번호</div>
            <div class="info-value password"><%= user.getPassword() != null ? user.getPassword() : "-" %></div>
        </div>
        <div class="info-card">
            <div class="info-label">이름</div>
            <div class="info-value"><%= user.getUsername() %></div>
        </div>
        <div class="info-card">
            <div class="info-label">닉네임</div>
            <div class="info-value"><%= user.getNickname() != null ? user.getNickname() : "-" %></div>
        </div>
        <div class="info-card">
            <div class="info-label">연락처</div>
            <div class="info-value"><%= user.getPhone() != null ? user.getPhone() : "-" %></div>
        </div>
        <div class="info-card">
            <div class="info-label">생일</div>
            <div class="info-value"><%= user.getBirth() != null ? user.getBirth() : "-" %></div>
        </div>
        <div class="info-card">
            <div class="info-label">등급</div>
            <div class="info-value"><%= user.getGrade() %></div>
        </div>
    </div>

    <!-- 찜한 영화 -->
    <div class="section-header">
        <div class="section-title">찜한 영화</div>
        <div class="section-badge">총 <%= likeCount %>편</div>
    </div>

    <% if (likedMovies == null || likedMovies.isEmpty()) { %>
        <p style="color:#999;">찜한 영화가 없습니다.</p>
    <% } else { %>
        <div class="liked-movies">
            <% for (LikeMovieDTO lm : likedMovies) {
                   String img = lm.getMovieImg();
                   if (img != null && img.startsWith("/")) {
                       img = "https://image.tmdb.org/t/p/w500" + img;
                   }
            %>
                <div class="movie-card">
                    <img src="<%= img != null ? img : "../img/default_movie.png" %>">
                    <div style="margin-top:9px; font-size:14px;"><%= lm.getMovieTitle() %></div>
                </div>
            <% } %>
        </div>
    <% } %>

    <!-- 작성한 리뷰 -->
    <div class="section-header">
        <div class="section-title">작성한 리뷰</div>
        <div class="section-badge">총 <%= reviewCount %>개</div>
    </div>

    <% if (reviews == null || reviews.isEmpty()) { %>

        <p style="color:#999;">아직 리뷰가 없습니다.</p>

    <% } else { %>

        <% for (ReviewDTO r : reviews) { %>
            <div class="review-card">
                <img src="<%= r.getMovieImg() != null ? r.getMovieImg() : "../img/default_movie.png" %>">
                <div class="review-info">
                    <div class="movie-title"><%= r.getMovieTitle() %></div>
                    <div class="rating-date">
                        ⭐ <%= r.getRating() %>점 | <%= r.getCreatedAt() %>
                    </div>
                    <div class="content-preview"><%= r.getContent() %></div>
                </div>
            </div>
        <% } %>

        <div class="avg-card">
            <span>⭐ 평균 평점</span>
            <strong><%= String.format("%.2f", avgRating) %> / 5.0</strong>
        </div>

    <% } %>

    <!-- 작성한 게시글 -->
    <div class="section-header">
        <div class="section-title">작성한 게시글</div>
        <div class="section-badge">총 <%= boardCount %>개</div>
    </div>

    <% if (myBoards == null || myBoards.isEmpty()) { %>

        <p style="color:#999;">아직 작성한 게시글이 없습니다.</p>

    <% } else { %>

        <div class="board-list">
            <% for (BoardDTO b : myBoards) { %>
                <div class="board-card">
                    <div class="board-title"><%= b.getTitle() %></div>
                    <div class="board-meta">
                        📁 <%= b.getCategory() %> | 📅 <%= b.getCreatedAt() %>
                    </div>
                    <div class="board-preview">
                        <%= b.getContent().length() > 80
                            ? b.getContent().substring(0, 80) + "..."
                            : b.getContent() %>
                    </div>
                </div>
            <% } %>
        </div>

    <% } %>

</div>
</div>

</body>
</html>