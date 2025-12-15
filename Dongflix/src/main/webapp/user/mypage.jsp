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
    double avgRating = avgObj != null ? (Double) avgObj : 0.0;
    

    int likeCount = likedMovies != null ? likedMovies.size() : 0;
    int reviewCount = reviews != null ? reviews.size() : 0;
    int boardCount = myBoards != null ? myBoards.size() : 0;
    int visitCount = request.getAttribute("visitCount") != null
            ? (Integer) request.getAttribute("visitCount")
            : 0;
    
    String ratingType = "";
    String ratingDesc = "";
    String ratingClass = "";

    if (reviewCount == 0) {
        ratingType = "📝 아직 평가 중";
        ratingDesc = "리뷰를 남기면 나의 영화 취향이 분석돼요";
        ratingClass = "rating-wait";
    } else if (avgRating < 2.0) {
        ratingType = "🧊 혹독한 비평가형";
        ratingDesc = "웬만해선 별점을 주지 않는 냉철한 평가자";
        ratingClass = "rating-cold";
    } else if (avgRating < 3.0) {
        ratingType = "🧐 현실적인 비평가형";
        ratingDesc = "장단점을 분명히 따지는 타입";
        ratingClass = "rating-real";
    } else if (avgRating < 3.7) {
        ratingType = "🎯 균형 잡힌 관객형";
        ratingDesc = "재미와 완성도를 공정하게 평가";
        ratingClass = "rating-balance";
    } else if (avgRating < 4.4) {
        ratingType = "😊 호의적인 감상자형";
        ratingDesc = "좋은 점을 먼저 보는 긍정적 관객";
        ratingClass = "rating-warm";
    } else {
        ratingType = "🌈 뭐든 재밌는 낙관자형";
        ratingDesc = "영화는 즐기라고 보는 타입";
        ratingClass = "rating-happy";
    }



    List<MemberDTO> recentVisitors =
        (List<MemberDTO>) request.getAttribute("recentVisitors");
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
        radial-gradient(circle at 20% 10%, rgba(40,70,160,0.25) 0%, transparent 55%),
        radial-gradient(circle at 85% 90%, rgba(90,130,255,0.22) 0%, transparent 55%),
        #000;
}

/* 메인 컨테이너 */
.mypage-container {
    max-width:1100px;
    margin:0 auto;
    background:rgba(10,10,20,0.92);
    padding:44px;
    border-radius:26px;
    border:1px solid rgba(120,150,255,0.12);
    box-shadow:0 22px 60px rgba(0,0,30,0.75);
    backdrop-filter:blur(6px);
    animation:fadeIn .65s ease-out;
}

@keyframes fadeIn {
    from { opacity:0; transform:translateY(10px); }
    to   { opacity:1; transform:translateY(0); }
}


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
    border:3px solid #273a80;
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
.grade-bronze { background:rgba(205,127,50,0.22); color:#e2b77c; }
.grade-silver { background:rgba(192,192,192,0.22); color:#f4f4f4; }
.grade-gold   { background:rgba(255,215,0,0.25); color:#ffe680; }

/* 취향 배지 */
.movie-style-badge {
    display:inline-block;
    padding:6px 14px;
    border-radius:20px;
    font-size:13px;
    margin-top:6px;
    margin-left:8px;
    background:rgba(64,110,255,0.25);
    border:1px solid rgba(80,120,255,0.35);
    color:#dbe1ff;
    font-weight:600;
}

/* 버튼 */
.mypage-actions {
    margin-top:14px;
    display:flex;
    gap:10px;
    flex-wrap:wrap;
}

.mp-btn {
    padding:8px 14px;
    border-radius:10px;
    background:rgba(255,255,255,0.05);
    border:1px solid rgba(90,120,255,0.22);
    font-size:13px;
    color:#dbe3ff;
    text-decoration:none;
    transition:.22s;
}
.mp-btn:hover {
    background:rgba(90,120,255,0.18);
    color:white;
}

.stats-grid {
    margin-top:32px;
    display:grid;
    grid-template-columns:repeat(auto-fit,minmax(240px,1fr));
    gap:18px;
}

.stat-card {
    background:#0f1328;
    border-radius:18px;
    padding:18px;
    border:1px solid rgba(110,140,255,0.18);
    cursor:pointer;
    transition:.22s;
}
.stat-card:hover {
    background:#141a38;
    border-color:#3f6fff;
    box-shadow:0 10px 30px rgba(63,111,255,0.25);
    transform:translateY(-2px);
}

.stat-top { display:flex; justify-content:space-between; align-items:center; }
.stat-left { display:flex; align-items:center; gap:10px; }
.stat-icon { font-size:20px; }
.stat-title { font-size:14px; color:#cbd3ff; }

.stat-chip {
    font-size:12px;
    padding:4px 10px;
    border-radius:999px;
    background:rgba(140,170,255,0.1);
    border:1px solid rgba(140,170,255,0.25);
    color:#cbd5ff;
}

.stat-bottom {
    margin-top:12px;
    font-size:13px;
    color:#9ea7d9;
}


.section-header {
    display:flex;
    justify-content:space-between;
    align-items:center;
    margin:40px 0 16px;
}

.section-title {
    font-size:21px;
    font-weight:700;
    border-left:4px solid #3f6fff;
    padding-left:12px;
}

.section-badge {
    font-size:13px;
    padding:6px 12px;
    border-radius:999px;
    background:rgba(30,40,60,0.6);
    border:1px solid rgba(80,110,255,0.3);
    color:#cbd5ff;
}

/* 내 정보 3개 그리드 */
.info-grid {
    display:grid;
    grid-template-columns:repeat(3, 1fr);
    gap:20px;
}

/* 반응형 — 화면 작으면 자동 2개, 더 작으면 1개 */
@media (max-width:900px){
    .info-grid {
        grid-template-columns:repeat(2, 1fr);
    }
}
@media (max-width:600px){
    .info-grid {
        grid-template-columns:1fr;
    }
}



.info-card {
    background:#111527;
    border-radius:16px;
    padding:16px 18px;
    border:1px solid rgba(90,120,255,0.18);
}

.info-label {
    font-size:12px;
    color:#9aa4d1;
    text-transform:uppercase;
    letter-spacing:.05em;
}

.info-value {
    margin-top:4px;
    font-size:16px;
    font-weight:600;
    color:#e4e8ff;
}

.carousel-container {
    position:relative;
    width:100%;
    overflow:hidden;
    padding:10px 0;
}

.carousel-row {
    display:flex;
    gap:14px;
    overflow-x:auto;
    scroll-behavior:smooth;
    padding-bottom:8px;
}
.carousel-row::-webkit-scrollbar { display:none; }

.carousel-btn {
    position:absolute;
    top:42%;
    transform:translateY(-50%);
    background:rgba(20,25,60,0.72);
    border:1px solid rgba(120,150,255,0.35);
    color:white;
    padding:10px 13px;
    border-radius:50%;
    cursor:pointer;
    font-size:18px;
    z-index:50;
    transition:.2s;
}
.carousel-btn.left { left:-3px; }
.carousel-btn.right { right:-3px; }
.carousel-btn:hover {
    background:rgba(80,110,255,0.95);
}

.carousel-item.movie-item {
    min-width:130px;
    max-width:130px;
    background:#121628;
    border-radius:12px;
    padding:8px;
    border:1px solid rgba(80,110,255,0.18);
    cursor:pointer;
    transition:.22s;
    text-align:center;
}
.carousel-item.movie-item img {
    width:100%;
    height:180px;
    object-fit:cover;
    border-radius:10px;
}
.movie-caption {
    margin-top:8px;
    font-size:13px;
    color:#dbe3ff;
}

.carousel-item.review-item{
    position: relative;
    min-width: 220px;
    max-width: 220px;
    border-radius: 18px;
    padding: 0;
    background: #0f1325;
    border: 1px solid rgba(120,150,255,0.25);
    box-shadow: 0 14px 32px rgba(0,0,0,0.45);
    overflow: hidden;
    display: flex;
    flex-direction: column;
}
.review-poster-wrap{
    position: relative;   /* 🔥 여기! */
    width: 100%;
    height: 270px;
    overflow: hidden;
}
.carousel-item.review-item:hover {
    transform: translateY(-5px);
    border-color: rgba(120,150,255,0.55);
    box-shadow:
        0 0 16px rgba(63,111,255,0.18),
        0 18px 44px rgba(0,0,0,0.55);
}




.review-title {
    font-size:15px;
    font-weight:600;
    color:#e4e8ff;
    margin-top:4px;
}
.review-info-small {
    font-size:12px;
    color:#aab4e8;
}
.review-preview {
    font-size:13px;
    color:#d7dbff;
    white-space:normal;
    line-height:1.4;
}


/* 작은 화면일 때 리뷰 / 영화 카드 폭 조정 */
@media (max-width:600px){
    .carousel-item.review-item {
        min-width:260px;
        max-width:260px;
    }
    .carousel-item.movie-item {
        min-width:120px;
        max-width:120px;
    }
}


.rating-card {
    display:inline-flex;
    align-items:center;
    padding:8px 16px;
    border-radius:999px;
    font-size:13px;
    font-weight:600;
    position:relative;
    cursor:default;
    border:1px solid;
    backdrop-filter:blur(6px);
}

/* 툴팁 */
.rating-tooltip {
    position:absolute;
    bottom:-48px;
    left:50%;
    transform:translateX(-50%);
    background:#0f1428;
    color:#dbe3ff;
    padding:8px 12px;
    border-radius:10px;
    font-size:12px;
    white-space:nowrap;
    opacity:0;
    pointer-events:none;
    transition:.2s;
    box-shadow:0 10px 24px rgba(0,0,0,.6);
}

.rating-card:hover .rating-tooltip {
    opacity:1;
}

.rating-sub {
    margin-top:4px;
    font-size:11px;
    color:#aab4e8;
}


.rating-wait {
    background:rgba(120,120,120,0.15);
    border-color:rgba(160,160,160,0.35);
    color:#d0d0d0;
}

.rating-cold {
    background:rgba(120,180,255,0.15);
    border-color:#6fa4ff;
    color:#cfe3ff;
}

.rating-real {
    background:rgba(150,160,200,0.18);
    border-color:#8fa0d9;
    color:#dde3ff;
}

.rating-balance {
    background:rgba(90,200,160,0.18);
    border-color:#6fe0b8;
    color:#dffaf0;
}

.rating-warm {
    background:rgba(255,200,120,0.22);
    border-color:#ffcf6b;
    color:#fff1c7;
}

.rating-happy {
    background:rgba(255,160,200,0.25);
    border-color:#ff8fcf;
    color:#ffe4f2;
}


/* 게시글 목록 그리드 3개 배치 */
.board-list {
    display:grid;
    grid-template-columns:repeat(3, 1fr);
    gap:20px;
}

/* 게시글 카드 스타일 (기존 유지) */
.board-card {
    background:#121628;
    border-radius:14px;
    padding:16px;
    border:1px solid rgba(90,120,255,0.18);
    transition:.22s;
}

.board-card:hover {
    border-color:#3f6fff;
    box-shadow:0 8px 20px rgba(63,111,255,0.28);
}


.board-title a {
    font-size:16px;
    font-weight:600;
    color:#dbe3ff;
    text-decoration:none;
}
.board-title a:hover {
    color:#8fa4ff;
}

.board-meta {
    font-size:12px;
    color:#a7b1e0;
    margin:5px 0 8px;
}

.board-preview {
    font-size:13px;
    color:#d7dbff;
    line-height:1.5;
    max-height:60px;
    overflow:hidden;
}

/* 페이징 버튼 */
.board-pagination-wrapper {
    margin-top:18px;
    text-align:center;
}
.page-btn {
    display:inline-block;
    min-width:32px;
    padding:6px 10px;
    margin:0 4px;
    border-radius:999px;
    border:1px solid rgba(90,120,255,0.35);
    background:rgba(10,15,35,0.9);
    color:#cbd5ff;
    font-size:13px;
    cursor:pointer;
    transition:.2s;
}
.page-btn:hover {
    background:#3f6fff;
    color:#fff;
}
.page-btn.active {
    background:#8fa4ff;
    color:#040615;
    border-color:#8fa4ff;
}

.profile-badges {
    display: flex;
    align-items: center;     
    gap: 10px;
    margin-top: 8px;
    flex-wrap: wrap;
}

/* 세 배지 공통 높이 & 정렬 */
.profile-badges > * {
    height: 34px;
    display: flex;
    align-items: center;
    justify-content: center;
    box-sizing: border-box;
    line-height: 1;      
}

/* 기존 배지 미세 조정 */
.grade-badge,
.movie-style-badge {
    padding: 0 14px;
    font-size: 13px;
}

/* 성향 카드 크기 통일 */
.rating-card {
    padding: 0 14px;
    font-size: 13px;
}

.rating-card {
    transform: translateY(2px);
}

.rating-summary{
    margin-top:18px;
    padding:16px 18px;
    background:linear-gradient(180deg, rgba(18,24,56,0.78), rgba(10,14,32,0.72));
    border:1px solid rgba(120,150,255,0.18);
    border-radius:16px;
    box-shadow:0 18px 44px rgba(0,0,0,0.55);
}

.rating-summary-top{
    display:flex;
    justify-content:space-between;
    align-items:center;
    gap:12px;
    flex-wrap:wrap;
    margin-bottom:12px;
}

.rating-summary-score{
    font-size:15px;
    font-weight:700;
    color:#e9edff;
}

.rating-summary-chip{
    padding:6px 12px;
    border-radius:999px;
    font-size:13px;
    font-weight:700;
    background:rgba(120,150,255,0.12);
    border:1px solid rgba(120,150,255,0.22);
    color:#dbe3ff;
}

.rating-bar{
    width:100%;
    height:10px;
    border-radius:999px;
    overflow:hidden;
    background:rgba(255,255,255,0.08);
    border:1px solid rgba(120,150,255,0.12);
}

.rating-bar-fill{
    height:100%;
    width:0%;
    border-radius:999px;
    background:
        linear-gradient(
            90deg,
            #3f6fff 0%,     /* 딥 네이비 블루 */
            #6fa4ff 35%,    /* 소프트 블루 */
            #7fffd4 65%,    /* 오로라 민트 */
            #b48cff 100%    /* 몽환 퍼플 */
        );
    box-shadow:
        0 0 14px rgba(111,164,255,0.55),
        0 0 26px rgba(127,255,212,0.25);

    transition: width .6s cubic-bezier(.4,0,.2,1);
}


.rating-summary-bottom{
    margin-top:12px;
    display:flex;
    flex-direction:column;
    gap:8px;
}

.rating-summary-desc{
    font-size:13px;
    color:#cfd7ff;
    line-height:1.35;
}

.rating-summary-note{
    font-size:12px;
    color:#aab4e8;
    opacity:0.95;
}

/* 접히는 "기준 보기" — 깔끔하게 */
.rating-guide{
    margin-top:6px;
    padding-top:6px;
    border-top:1px solid rgba(120,150,255,0.12);
}

.rating-guide > summary{
    cursor:pointer;
    list-style:none;
    font-size:12.5px;
    color:#9fb0ff;
    user-select:none;
}
.rating-guide > summary::-webkit-details-marker{ display:none; }

.rating-guide-body{
    margin-top:10px;
    display:flex;
    flex-direction:column;
    gap:8px;
}

.rating-guide-row{
    display:flex;
    justify-content:space-between;
    gap:12px;
    font-size:12.5px;
    color:#dbe3ff;
    background:rgba(255,255,255,0.03);
    border:1px solid rgba(120,150,255,0.10);
    border-radius:10px;
    padding:8px 10px;
}

.rg-range{
    color:#aab4e8;
    font-variant-numeric:tabular-nums;
}

.rg-type{
    font-weight:700;
    color:#e9edff;
}

/* ===== REVIEW POSTER OVERLAY INFO ===== */
.review-poster{
 width: 100%;
    height: 100%;
    object-fit: cover;
    display: block;
    filter: saturate(1.03) contrast(1.03);
}

.review-poster-overlay{
    position: absolute;
    left: 0;
    right: 0;
    bottom: 0;

    padding: 10px 12px;
    background: linear-gradient(
        to top,
        rgba(0,0,0,0.78),
        rgba(0,0,0,0.35) 55%,
        transparent
    );

    display: flex;
    justify-content: space-between;
    align-items: center;

    font-size: 12px;
    color: #e8ecff;
    pointer-events: none; /* 클릭 방해 방지 */
}

.review-poster-rating{ font-weight: 900; }
.review-poster-date{ font-size: 11px; color: #b6bfea; }

.review-content-wrap{
    padding: 12px 14px 14px;
    display: flex;
    flex-direction: column;
    gap: 6px;
}

/* 링크는 맨 아래 고정 */
.review-detail-link{
    margin-top: auto;
    padding-top: 6px;
    font-size: 13px;
    color: #8fa4ff;
    text-decoration: none;
}
.review-detail-link:hover{ text-decoration: underline; }


/* 반응형 */
@media (max-width:700px){
    .mypage-container { padding:26px 18px; }
    .profile-section { flex-direction:column; align-items:flex-start; }
}

</style>

<script>
function scrollLeft(id){
    document.getElementById(id).scrollBy({ left:-400, behavior:'smooth' });
}
function scrollRight(id){
    document.getElementById(id).scrollBy({ left:400, behavior:'smooth' });
}
function scrollToSection(id){
    const t=document.getElementById(id);
    if(t){
        window.scrollTo({top:t.offsetTop-80, behavior:"smooth"});
    }
}

/* ==== 게시글 프론트 페이징 (B안) ==== */
const BOARD_PAGE_SIZE = 6;   // 한 페이지에 게시글 6개(2~3열 타일 기준)

function updateBoardPage(page){
    const cards = document.querySelectorAll(".board-card");
    const totalPages = Math.ceil(cards.length / BOARD_PAGE_SIZE);

    // 보이기 / 숨기기
    cards.forEach(function(card, index){
        const start = (page-1)*BOARD_PAGE_SIZE;
        const end   = page*BOARD_PAGE_SIZE;
        if(index >= start && index < end){
            card.style.display = "block";
        } else {
            card.style.display = "none";
        }
    });

    // 버튼 상태 업데이트
    const btns = document.querySelectorAll(".page-btn");
    btns.forEach(function(btn, idx){
        if(idx+1 === page) btn.classList.add("active");
        else btn.classList.remove("active");
    });
}

function setupBoardPagination(){
    const cards = document.querySelectorAll(".board-card");
    if(!cards || cards.length === 0) return;

    const totalPages = Math.ceil(cards.length / BOARD_PAGE_SIZE);
    const paginationDiv = document.getElementById("board-pagination");
    if(!paginationDiv) return;

    // 버튼 생성
    paginationDiv.innerHTML = "";
    for(let p=1; p<=totalPages; p++){
        const btn = document.createElement("button");
        btn.className = "page-btn" + (p===1 ? " active" : "");
        btn.innerText = p;
        btn.onclick = (function(page){
            return function(){ updateBoardPage(page); };
        })(p);
        paginationDiv.appendChild(btn);
    }

    // 초기 페이지 셋업
    updateBoardPage(1);
}

window.addEventListener("load", setupBoardPagination);
</script>
</head>
<body>

<div class="mypage-bg">
<div class="mypage-container">

<div class="profile-section">

    <div class="profile-img"
         style="background-image:url('<%= 
            (user.getProfileImg()!=null && !user.getProfileImg().isEmpty())
            ? user.getProfileImg()
            : "img/default_profile.png"
         %>');"></div>

	   <div>
    <div class="user-name"><%= user.getUsername() %> 님</div>

    <!-- 🔽 배지 3종 통합 컨테이너 -->
    <div class="profile-badges">

        <!-- 등급 배지 -->
        <span class="grade-badge 
            <%
                String g = user.getGrade().toLowerCase();
                if (g.equals("bronze")) out.print("grade-bronze");
                else if (g.equals("silver")) out.print("grade-silver");
                else if (g.equals("gold")) out.print("grade-gold");
            %>">
            등급 : <%= user.getGrade() %>
        </span>

        <!-- 취향 배지 -->
        <% if (user.getMovieStyle() != null && !user.getMovieStyle().isEmpty()) { %>
            <span class="movie-style-badge"><%= user.getMovieStyle() %></span>
        <% } %>

        <!-- 성향 카드 -->
        <div class="rating-card <%= ratingClass %>">
            <div class="rating-title"><%= ratingType %></div>

            <div class="rating-tooltip">
                <%= ratingDesc %>
                <% if (reviewCount < 3) { %>
                    <div class="rating-sub">
                        현재 리뷰 수: <%= reviewCount %>개
                    </div>
                <% } %>
            </div>
        </div>

    </div>

  

        

        <div class="mypage-actions">
            <a href="<%=request.getContextPath()%>/editProfileForm" class="mp-btn">회원정보 수정</a>
            <a href="<%=request.getContextPath()%>/changePasswordForm" class="mp-btn">비밀번호 변경</a>
            <a href="logout.do" class="mp-btn">로그아웃</a>
        </div>
    </div>

</div>


<div class="stats-grid">

    <div class="stat-card" onclick="scrollToSection('liked-section')">
        <div class="stat-top">
            <div class="stat-left">
                <div class="stat-icon">❤️</div>
                <div class="stat-title">찜한 영화</div>
            </div>
            <div class="stat-chip">총 <%= likeCount %>편</div>
        </div>
        <div class="stat-bottom">내가 좋아요한 영화들을 모아보세요.</div>
    </div>

    <div class="stat-card" onclick="scrollToSection('review-section')">
        <div class="stat-top">
            <div class="stat-left">
                <div class="stat-icon">⭐</div>
                <div class="stat-title">작성한 리뷰</div>
            </div>
            <div class="stat-chip"><%= reviewCount %>개 · 평점 <%= String.format("%.2f", avgRating) %></div>
        </div>
        <div class="stat-bottom">내가 남긴 평가 기록입니다.</div>
    </div>

    <div class="stat-card" onclick="scrollToSection('board-section')">
        <div class="stat-top">
            <div class="stat-left">
                <div class="stat-icon">📝</div>
                <div class="stat-title">작성한 게시글</div>
            </div>
            <div class="stat-chip"><%= boardCount %>개</div>
        </div>
        <div class="stat-bottom">커뮤니티에 남긴 기록입니다.</div>
    </div>

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
            <% if(recentVisitors==null || recentVisitors.isEmpty()) { %>
                없음
            <% } else { %>
                <%= recentVisitors.get(0).getNickname()!=null &&
                    !recentVisitors.get(0).getNickname().isEmpty()
                    ? recentVisitors.get(0).getNickname()
                    : recentVisitors.get(0).getUserid()
                %> 외 <%= (recentVisitors.size()-1) %>명
            <% } %>
        </div>
    </div>

</div>


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
        <div class="info-value"><%= user.getNickname()!=null ? user.getNickname() : "-" %></div>
    </div>

    <div class="info-card">
        <div class="info-label">연락처</div>
        <div class="info-value"><%= user.getPhone()!=null ? user.getPhone() : "-" %></div>
    </div>

    <div class="info-card">
        <div class="info-label">생일</div>
        <div class="info-value"><%= user.getBirth()!=null ? user.getBirth() : "-" %></div>
    </div>

    <div class="info-card">
        <div class="info-label">등급</div>
        <div class="info-value"><%= user.getGrade() %></div>
    </div>
</div>


<div id="liked-section" class="section-header">
    <div class="section-title">내가 찜한 영화</div>
    <div class="section-badge">총 <%= likeCount %>편</div>
</div>

<% if(likedMovies == null || likedMovies.isEmpty()) { %>

    <p>찜한 영화가 없습니다.</p>

<% } else { %>

<div class="carousel-container">

    <!-- 왼쪽 버튼 -->
    <button class="carousel-btn left" onclick="scrollLeft('likedCarousel')">❮</button>

    <!-- 캐러셀 -->
    <div class="carousel-row" id="likedCarousel">

        <% for(LikeMovieDTO lm : likedMovies) {
               String img = lm.getMovieImg();
               if(img != null && img.startsWith("/")) {
                   img = "https://image.tmdb.org/t/p/w500" + img;
               }
        %>

        <div class="carousel-item movie-item"
             onclick="location.href='movieDetail?movieId=<%= lm.getMovieId() %>'">

            <img src="<%= img != null ? img : "img/default_movie.png" %>">
            <div class="movie-caption"><%= lm.getMovieTitle() %></div>

        </div>

        <% } %>
    </div>

    <!-- 오른쪽 버튼 -->
    <button class="carousel-btn right" onclick="scrollRight('likedCarousel')">❯</button>

</div>

<% } %>

<!-- 내 영화 일기장 바로가기 버튼 -->
<div class="section-header" style="margin-top:45px;">
    <div class="section-title">내 영화 일기장</div>
    <a href="<%= request.getContextPath() %>/myDiaryList"
       class="section-badge"
       style="cursor:pointer; text-decoration:none; margin-bottom: 20px;]">
        열기 →
    </a>
</div>


<div id="review-section" class="section-header">
    <div class="section-title">내가 작성한 리뷰</div>
    <div class="section-badge">총 <%= reviewCount %>개</div>
</div>

<% if(reviews == null || reviews.isEmpty()) { %>

    <p>아직 리뷰가 없습니다.</p>

<% } else { %>

<div class="carousel-container">

    <!-- 왼쪽 -->
    <button class="carousel-btn left" onclick="scrollLeft('reviewCarousel')">❮</button>

    <!-- 리뷰 캐러셀 -->
    <div class="carousel-row" id="reviewCarousel">

        <% for(ReviewDTO r : reviews) { %>

      <div class="carousel-item review-item">

    <!-- ✅ 포스터 영역 래퍼 (오버레이는 여기 기준으로 붙음) -->
    <div class="review-poster-wrap">
        <img class="review-poster"
             src="<%= r.getMovieImg() != null ? r.getMovieImg() : "img/default_movie.png" %>"
             alt="포스터">

        <div class="review-poster-overlay">
            <div class="review-poster-rating">★ <%= r.getRating() %></div>
            <div class="review-poster-date"><%= r.getCreatedAt() %></div>
        </div>
    </div>

    <!-- ✅ 콘텐츠 영역 (오버레이 영향 없음) -->
    <div class="review-content-wrap">
        <div class="review-title"><%= r.getMovieTitle() %></div>

        <div class="review-preview">
            <%= r.getContent().length() > 70
                ? r.getContent().substring(0, 70) + "…"
                : r.getContent()
            %>
        </div>

        <a class="review-detail-link"
           href="movieDetail?movieId=<%= r.getMovieId() %>">
            자세히 보기 →
        </a>
    </div>

</div>


       

        <% } %>

    </div>

    <!-- 오른쪽 -->
    <button class="carousel-btn right" onclick="scrollRight('reviewCarousel')">❯</button>

</div>

<%
    // 막대바 퍼센트(0~100) 계산
    double safeAvg = avgRating;
    if (safeAvg < 0) safeAvg = 0;
    if (safeAvg > 5) safeAvg = 5;

    int ratingPercent = (int)Math.round((safeAvg / 5.0) * 100);

    // 리뷰 3개 미만이면 "데이터 부족" 안내
    boolean lowData = (reviewCount < 3);

    // 평균 평점에 따른 성향(기존 로직 재사용)
    String barType = ratingType;      // 너가 위에서 만든 ratingType 그대로 사용
    String barDesc = ratingDesc;      // 너가 위에서 만든 ratingDesc 그대로 사용
%>

<div class="rating-summary">
    <div class="rating-summary-top">
        <div class="rating-summary-score">
            ⭐ 평균 평점 <strong><%= String.format("%.2f", avgRating) %></strong> / 5.0
        </div>
        <div class="rating-summary-chip">
            <%= barType %>
        </div>
    </div>

    <div class="rating-bar">
        <div class="rating-bar-fill" style="width:<%= ratingPercent %>%;"></div>
    </div>

    <div class="rating-summary-bottom">
        <div class="rating-summary-desc">
            <%= barDesc %>
        </div>

        <% if(lowData) { %>
            <div class="rating-summary-note">
                ⚠ 리뷰 <%= reviewCount %>개로는 성향 정확도가 낮을 수 있어요. (3개 이상부터 안정적)
            </div>
        <% } %>

        <!-- "몇 점이면 무슨 형" 설명(깔끔하게 접히는 형태) -->
        <details class="rating-guide">
            <summary>성향 분류 기준 보기</summary>
            <div class="rating-guide-body">
                <div class="rating-guide-row"><span class="rg-range">0.0 ~ 1.99</span><span class="rg-type">🧊 혹독한 비평가형</span></div>
                <div class="rating-guide-row"><span class="rg-range">2.0 ~ 2.99</span><span class="rg-type">🧐 현실적인 비평가형</span></div>
                <div class="rating-guide-row"><span class="rg-range">3.0 ~ 3.69</span><span class="rg-type">🎯 균형 잡힌 관객형</span></div>
                <div class="rating-guide-row"><span class="rg-range">3.7 ~ 4.39</span><span class="rg-type">😊 호의적인 감상자형</span></div>
                <div class="rating-guide-row"><span class="rg-range">4.4 ~ 5.0</span><span class="rg-type">🌈 뭐든 재밌는 낙관자형</span></div>
            </div>
        </details>
    </div>
</div>


<% } %>



<div id="board-section" class="section-header">
    <div class="section-title">내가 작성한 게시글</div>
    <div class="section-badge">총 <%= boardCount %>개</div>
</div>

<% if(myBoards == null || myBoards.isEmpty()) { %>

    <p>아직 작성한 게시글이 없습니다.</p>

<% } else { %>

<!-- GRID 정렬 -->
<div class="board-grid">

    <% for(BoardDTO b : myBoards) { %>

    <div class="board-card">

        <div class="board-title">
            <a href="board/detail?id=<%= b.getBoardId() %>">
                <%= b.getTitle() %>
            </a>
        </div>

        <div class="board-meta">📅 <%= b.getCreatedAt() %></div>

        <div class="board-preview">
            <%= b.getContent().length() > 120
                ? b.getContent().substring(0, 120) + "…"
                : b.getContent()
            %>
        </div>

    </div>

    <% } %>

</div>

<div class="board-pagination-wrapper" id="board-pagination"></div>

<% } %>



</div><!-- mypage-container -->
</div><!-- mypage-bg -->


</body>
<%@ include file="/common/alert.jsp" %>
</html>
