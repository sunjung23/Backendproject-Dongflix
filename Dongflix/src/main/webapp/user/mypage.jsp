<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ include file="/common/header.jsp" %>
<%@ page import="java.util.List" %>
<%@ page import="com.dongyang.dongflix.dto.MemberDTO" %>
<%@ page import="com.dongyang.dongflix.dto.ReviewDTO" %>
<%@ page import="com.dongyang.dongflix.dto.LikeMovieDTO" %>
<%@ page import="com.dongyang.dongflix.dto.BoardDTO" %>

<%
    MemberDTO user = (MemberDTO) session.getAttribute("loginUser");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

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
    int visitCount = (request.getAttribute("visitCount") != null)
            ? (Integer) request.getAttribute("visitCount")
            : 0;
    java.util.List<com.dongyang.dongflix.dto.MemberDTO> recentVisitors =
            (java.util.List<com.dongyang.dongflix.dto.MemberDTO>) request.getAttribute("recentVisitors");

%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>마이페이지 - DONGFLIX</title>

<style>
body {
    margin:0;
    background:#000;
    color:#fff;
    font-family:-apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
}

/* 배경 */
.mypage-bg {
    padding:120px 20px;
    min-height:100vh;
    background:
        radial-gradient(circle at 20% 15%, rgba(229,9,20,0.25) 0%, transparent 55%),
        radial-gradient(circle at 80% 85%, rgba(255,60,60,0.22) 0%, transparent 55%),
        #000;
}

/* 메인 박스 */
.mypage-container {
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

/* 프로필 영역 */
.profile-section {
    display:flex;
    align-items:center;
    gap:26px;
}

.profile-img {
    width:130px;
    height:130px;
    border-radius:50%;
    background:#222;
    background-size:cover;
    background-position:center;
    border:3px solid #333;
}

.user-name {
    font-size:30px;
    font-weight:800;
    margin-bottom:6px;
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

/* 프로필 버튼 */
.mypage-actions {
    margin-top:14px;
    display:flex;
    flex-wrap:wrap;
    gap:10px;
}

.mp-btn {
    padding:8px 14px;
    border-radius:10px;
    background:rgba(255,255,255,0.05);
    border:1px solid rgba(255,255,255,0.18);
    font-size:13px;
    text-decoration:none;
    color:#fff;
    transition:.22s;
}

.mp-btn:hover {
    background:rgba(255,255,255,0.16);
}

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
    cursor:pointer;
    transition:.22s;
}

.stat-card:hover {
    background:#191919;
    border-color:#e50914;
    box-shadow:0 10px 26px rgba(229,9,20,0.35);
    transform:translateY(-2px);
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

/* 섹션 헤더 (제목 + 개수) */
.section-header {
    display:flex;
    justify-content:space-between;
    align-items:center;
    margin:40px 0 16px;
}

.section-title {
    font-size:21px;
    font-weight:700;
    border-left:4px solid #e50914;
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

/* 내 정보 카드 그리드 */
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
    border-color:#e50914;
    box-shadow:0 8px 22px rgba(229,9,20,0.35);
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
    border-color:#e50914;
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

.review-info a {
    color:#e50914;
    font-size:13px;
    text-decoration:none;
}

.review-info a:hover {
    text-decoration:underline;
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
    border-color:#e50914;
}

.board-title a {
    font-size:17px;
    font-weight:600;
    color:#e50914;
    text-decoration:none;
}

.board-title a:hover {
    text-decoration:underline;
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
    .mypage-container { padding:28px 18px; }
    .profile-section { flex-direction:column; align-items:flex-start; }
}

/* 🔥 영화 취향 배지 */
.movie-style-badge {
    display: inline-block;
    padding: 6px 14px;
    border-radius: 20px;
    font-size: 13px;
    margin-top: 6px;
    margin-left: 8px;
    background: linear-gradient(135deg, rgba(229,9,20,0.3) 0%, rgba(255,60,60,0.25) 100%);
    border: 1px solid rgba(229,9,20,0.4);
    color: #ffffff;  /* 🔥 흰색으로 변경 */
    font-weight: 600;
}
</style>

<script>
function scrollToSection(id) {
    const target = document.getElementById(id);
    if (target) {
        window.scrollTo({
            top: target.offsetTop - 80,
            behavior: "smooth"
        });
    }
}
</script>
</head>

<body>
<div class="mypage-bg">
<div class="mypage-container">

    <!-- 프로필 -->
    <div class="profile-section">
	    <div class="profile-img"
	         style="background-image:url('<%= 
	            (user.getProfileImg()!=null && !user.getProfileImg().isEmpty())
	            ? user.getProfileImg()
	            : "img/default_profile.png"
	         %>');"></div>
	
	    <div>
	        <div class="user-name"><%= user.getUsername() %> 님</div>
	
	        <span class="grade-badge 
	            <%
	                String g = user.getGrade().toLowerCase();
	                if(g.equals("bronze")) out.print("grade-bronze");
	                else if(g.equals("silver")) out.print("grade-silver");
	                else if(g.equals("gold")) out.print("grade-gold");
	            %>">
	            등급 : <%= user.getGrade() %>
	        </span>
	
	        <!-- 영화 취향 배지 -->
			<% if (user.getMovieStyle() != null && !user.getMovieStyle().isEmpty()) { %>
			    <span class="movie-style-badge">
			        <%= user.getMovieStyle() %>
			    </span>
			<% } %>
	
	        <div class="mypage-actions">
	            <a href="<%=request.getContextPath()%>/editProfileForm" class="mp-btn">회원정보 수정</a>
	            <a href="<%=request.getContextPath()%>/changePasswordForm" class="mp-btn">비밀번호 변경</a>
	            <a href="logout.do" class="mp-btn">로그아웃</a>
	        </div>
	    </div>
	</div>

       <!-- 활동 요약 -->
    <div class="stats-grid">

        <div class="stat-card" onclick="scrollToSection('liked-section')">
            <div class="stat-top">
                <div class="stat-left">
                    <div class="stat-icon">❤️</div>
                    <div class="stat-title">찜한 영화</div>
                </div>
                <div class="stat-chip">총 <%= likeCount %>편</div>
            </div>
            <div class="stat-bottom">내가 좋아요한 영화들을 한눈에 볼 수 있어요.</div>
        </div>

        <div class="stat-card" onclick="scrollToSection('review-section')">
            <div class="stat-top">
                <div class="stat-left">
                    <div class="stat-icon">⭐</div>
                    <div class="stat-title">작성한 리뷰</div>
                </div>
                <div class="stat-chip"><%= reviewCount %>개 · 평점 <%= String.format("%.2f", avgRating) %></div>
            </div>
            <div class="stat-bottom">내가 남긴 평가와 한줄평들을 모아보는 공간입니다.</div>
        </div>

        <div class="stat-card" onclick="scrollToSection('board-section')">
            <div class="stat-top">
                <div class="stat-left">
                    <div class="stat-icon">📝</div>
                    <div class="stat-title">작성한 게시글</div>
                </div>
                <div class="stat-chip"><%= boardCount %>개</div>
            </div>
            <div class="stat-bottom">커뮤니티에서 남긴 나의 흔적들을 확인해보세요.</div>
        </div>

        <!-- 🔥 프로필 방문 통계 카드 -->
        <div class="stat-card">
            <div class="stat-top">
                <div class="stat-left">
                    <div class="stat-icon">👀</div>
                    <div class="stat-title">프로필 방문</div>
                </div>
                <div class="stat-chip"><%= visitCount %>회</div>
            </div>
            <div class="stat-bottom">
                최근 방문자:
                <% if (recentVisitors == null || recentVisitors.isEmpty()) { %>
                    없음
                <% } else { %>
                    <%= (recentVisitors.get(0).getNickname() != null
                         && !recentVisitors.get(0).getNickname().isEmpty())
                        ? recentVisitors.get(0).getNickname()
                        : recentVisitors.get(0).getUserid() %> 외
                    <%= (recentVisitors.size() - 1) >= 0 ? (recentVisitors.size() - 1) : 0 %>명
                <% } %>
            </div>
        </div>

    </div>


    </div>

    <!-- 내 정보 -->
    <div class="section-header">
        <div class="section-title">내 정보</div>
    </div>

    <div class="info-grid">
	    <div class="info-card">
	        <div class="info-label">아이디</div>
	        <div class="info-value"><%= user.getUserid() %></div>
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
    <div id="liked-section" class="section-header">
        <div class="section-title">내가 찜한 영화</div>
        <div class="section-badge">총 <%= likeCount %>편</div>
    </div>

    <% if (likedMovies == null || likedMovies.isEmpty()) { %>
        <p>찜한 영화가 없습니다.</p>
    <% } else { %>
        <div class="liked-movies">
            <% for (LikeMovieDTO lm : likedMovies) {
                   String img = lm.getMovieImg();
                   if (img != null && img.startsWith("/")) {
                       img = "https://image.tmdb.org/t/p/w500" + img;
                   }
            %>
                <div class="movie-card"
                     onclick="location.href='movieDetail?movieId=<%= lm.getMovieId() %>'">
                    <img src="<%= img != null ? img : "img/default_movie.png" %>">
                    <div style="margin-top:9px; font-size:14px;"><%= lm.getMovieTitle() %></div>
                </div>
            <% } %>
        </div>
    <% } %>

    <!-- 내가 작성한 리뷰 -->
    <div id="review-section" class="section-header">
        <div class="section-title">내가 작성한 리뷰</div>
        <div class="section-badge">총 <%= reviewCount %>개</div>
    </div>

    <% if (reviews == null || reviews.isEmpty()) { %>

        <p>아직 리뷰가 없습니다.</p>

    <% } else { %>

        <% for (ReviewDTO r : reviews) { %>
            <div class="review-card">
                <img src="<%= r.getMovieImg() != null ? r.getMovieImg() : "img/default_movie.png" %>">
                <div class="review-info">
                    <div class="movie-title"><%= r.getMovieTitle() %></div>
                    <div class="rating-date">
                        ⭐ <%= r.getRating() %>점 | <%= r.getCreatedAt() %>
                    </div>
                    <div class="content-preview"><%= r.getContent() %></div>
                    <a href="movieDetail?movieId=<%= r.getMovieId() %>">자세히 보기 →</a>
                </div>
            </div>
        <% } %>

        <div class="avg-card">
            <span>⭐ 평균 평점</span>
            <strong><%= String.format("%.2f", avgRating) %> / 5.0</strong>
        </div>

    <% } %>

    <!-- 내가 작성한 게시글 -->
    <div id="board-section" class="section-header">
        <div class="section-title">내가 작성한 게시글</div>
        <div class="section-badge">총 <%= boardCount %>개</div>
    </div>

    <% if (myBoards == null || myBoards.isEmpty()) { %>

        <p>아직 작성한 게시글이 없습니다.</p>

    <% } else { %>

        <div class="board-list">
            <% for (BoardDTO b : myBoards) { %>
                <div class="board-card">
                    <div class="board-title">
                        <a href="board/detail?id=<%= b.getBoardId() %>"><%= b.getTitle() %></a>
                    </div>
                    <div class="board-meta">📅 <%= b.getCreatedAt() %></div>
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
