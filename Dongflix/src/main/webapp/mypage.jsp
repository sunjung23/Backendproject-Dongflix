<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.dongyang.dongflix.MemberDTO" %>
<%@ page import="com.dongyang.dongflix.ReviewDTO" %>
<%@ page import="com.dongyang.dongflix.LikeMovieDTO" %>

<%
    MemberDTO user = (MemberDTO) session.getAttribute("loginUser");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<ReviewDTO> reviews = (List<ReviewDTO>) request.getAttribute("reviews");
    List<LikeMovieDTO> likedMovies = (List<LikeMovieDTO>) request.getAttribute("likedMovies");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>마이페이지 - DONGFLIX</title>

<style>
    body {
        background:#000;
        font-family:-apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
        color:#fff;
        margin:0;
        padding:0;
    }

    /* ================= 상단바 ================= */
    header {
        width:100%;
        height:60px;
        background:#000;
        display:flex;
        align-items:center;
        justify-content:space-between;
        padding:0 50px;
        position:fixed;
        top:0;
        left:0;
        z-index:100;
        border-bottom:1px solid #111;
        box-sizing:border-box;
    }

    .logo img { height:32px; }

    nav ul {
        display:flex;
        list-style:none;
        gap:25px;
        margin:0;
        padding:0;
    }

    nav a {
        color:#fff;
        text-decoration:none;
        font-size:15px;
    }

    .mypage-link {
        color:#fff;
        font-weight:600;
        font-size:15px;
        text-decoration:none;
        white-space:nowrap;
    }

    /* ================= 메인 컨테이너 ================= */
    .mypage-container {
        max-width:1100px;
        margin:100px auto 80px;
        background:#111;
        padding:30px;
        border-radius:16px;
        box-shadow:0 10px 40px rgba(0,0,0,0.6);
    }

    /* ================= 프로필 ================= */
    .profile-section {
        display:flex;
        align-items:center;
        gap:24px;
        margin-bottom:30px;
    }

    .profile-img {
        width:110px;
        height:110px;
        border-radius:50%;
        background:#222;
        border:2px solid #444;
    }

    .user-flex-area { flex:1; }

    .user-name {
        font-size:28px;
        font-weight:700;
    }

    .grade-badge {
        padding:6px 14px;
        border-radius:30px;
        font-size:13px;
        margin-top:6px;
        display:inline-block;
    }

    .grade-bronze { background:rgba(205,127,50,0.25); color:#e0a96d; }
    .grade-silver { background:rgba(192,192,192,0.3); color:#d8d8d8; }
    .grade-gold { background:rgba(255,215,0,0.3); color:#ffd43b; }

    .mypage-actions {
        margin-top:14px;
        display:flex;
        gap:10px;
    }

    .mp-btn {
        padding:8px 14px;
        border-radius:8px;
        border:1px solid rgba(255,255,255,0.3);
        background:rgba(255,255,255,0.04);
        color:#fff;
        font-size:13px;
        text-decoration:none;
    }

    .mp-btn:hover { background:rgba(255,255,255,0.15); }

    /* ================= 섹션 제목 ================= */
    .section-title {
        font-size:20px;
        font-weight:600;
        margin:30px 0 10px;
    }

    /* ================= 내 정보 ================= */
    .user-info-table {
        width:100%;
        background:#141414;
        border-radius:12px;
        overflow:hidden;
        margin-bottom:20px;
    }

    .user-info-table th,
    .user-info-table td {
        padding:12px 16px;
    }

    .user-info-table th {
        width:120px;
        background:#1b1b1b;
        color:#bbb;
        text-align:left;
    }

    /* ================= 찜한 영화 ================= */
    .liked-movies {
        display:grid;
        grid-template-columns:repeat(auto-fill, minmax(160px, 1fr));
        gap:18px;
        margin-top:15px;
    }

    .movie-card {
        background:#1a1a1a;
        border-radius:10px;
        padding:10px;
        text-align:center;
    }

    .movie-card img {
        width:100%;
        height:220px;
        object-fit:cover;
        border-radius:8px;
    }
</style>
</head>
<body>

<!-- =============== 상단바 =============== -->
<header>
    <div class="logo"><img src="img/logo.png"></div>

    <nav>
        <ul>
            <li><a href="index.jsp">홈</a></li>
            <li><a href="#">영화</a></li>
            <li><a href="#">시리즈</a></li>
        </ul>
    </nav>

    <a href="mypage.do" class="mypage-link">마이페이지</a>
</header>


<!-- =============== 본문 =============== -->
<div class="mypage-container">

    <!-- 프로필 영역 -->
    <div class="profile-section">
        <div class="profile-img"
             style="background-image:url('<%= (user.getProfileImg() != null && !user.getProfileImg().isEmpty())
                     ? user.getProfileImg()
                     : "img/default_profile.png" %>'); 
                    background-size:cover; background-position:center;">
        </div>

        <div class="user-flex-area">
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

            <div class="mypage-actions">
                <a href="editProfile.jsp" class="mp-btn">회원정보 수정</a>
                <a href="changePassword.jsp" class="mp-btn">비밀번호 변경</a>
                <a href="logout.do" class="mp-btn">로그아웃</a>
            </div>
        </div>
    </div>

    <!-- 내 정보 -->
    <h3 class="section-title">내 정보</h3>
    <table class="user-info-table">
        <tr><th>아이디</th><td><%= user.getUserid() %></td></tr>
        <tr><th>이름</th><td><%= user.getUsername() %></td></tr>
        <tr><th>닉네임</th><td><%= user.getNickname() != null ? user.getNickname() : "-" %></td></tr>
        <tr><th>연락처</th><td><%= user.getPhone() != null ? user.getPhone() : "-" %></td></tr>
        <tr><th>생일</th><td><%= user.getBirth() != null ? user.getBirth() : "-" %></td></tr>
        <tr><th>등급</th><td><%= user.getGrade() %></td></tr>
    </table>

    <!-- 내가 찜한 영화 -->
    <h3 class="section-title">내가 찜한 영화</h3>
    <% if (likedMovies == null || likedMovies.isEmpty()) { %>
        <p>찜한 영화가 없습니다.</p>
    <% } else { %>
        <div class="liked-movies">
            <% for (LikeMovieDTO lm : likedMovies) { %>
                <div class="movie-card">
                    <img src="<%= lm.getMovieImg() != null ? lm.getMovieImg() : "img/default_movie.png" %>">
                    <div style="margin-top:8px;"><%= lm.getMovieTitle() %></div>
                </div>
            <% } %>
        </div>
    <% } %>

    <!-- 내가 쓴 리뷰 -->
    <h3 class="section-title">내가 쓴 리뷰</h3>
    <% if (reviews == null || reviews.isEmpty()) { %>
        <p>아직 작성한 리뷰가 없습니다.</p>
    <% } else { %>
        <% for (ReviewDTO r : reviews) { %>
            <div style="border-bottom:1px solid #222; padding:12px 0;">
                <strong><%= r.getTitle() %></strong> (평점: <%= r.getRating() %>/10)<br>
                <small><%= r.getCreatedAt() %></small><br>
                <div style="margin-top:5px; color:#ddd;"><%= r.getContent() %></div>
            </div>
        <% } %>
    <% } %>

</div>

</body>
</html>
