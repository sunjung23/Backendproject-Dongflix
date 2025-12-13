<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="com.dongyang.dongflix.model.TMDBmovie" %>

<%
    TMDBmovie movie = (TMDBmovie) request.getAttribute("movie");

    if (movie == null) {
        response.sendRedirect(request.getContextPath() + "/indexMovie");
        return;
    }
%>

<%@ include file="/common/header.jsp" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>영화 일기 작성 - <%= movie.getTitle() %></title>

<style>
/* ===============================
   PREMIUM OTT DIARY WRITE
=============================== */
body {
    margin:0;
    padding:0;
    background:#000;
    color:#fff;
    font-family:-apple-system, BlinkMacSystemFont,"Segoe UI",sans-serif;
}

/* 전체 배경 */
.diary-page {
    min-height:100vh;
    padding:110px 20px 80px;
    background:
        radial-gradient(circle at 20% 12%, rgba(80,120,255,0.28), transparent 55%),
        radial-gradient(circle at 80% 88%, rgba(140,170,255,0.22), transparent 55%),
        #000;
}

/* 중앙 카드 */
.diary-card {
    max-width:860px;
    margin:0 auto;
    background:rgba(12,16,40,0.88);
    border-radius:22px;
    padding:38px 40px 42px;
    border:1px solid rgba(120,150,255,0.28);
    backdrop-filter:blur(18px);
    box-shadow:
        0 0 0 1px rgba(255,255,255,0.02),
        0 18px 50px rgba(0,0,0,0.75);
}

/* 타이틀 */
.diary-title {
    font-size:26px;
    font-weight:800;
    color:#f2f4ff;
    margin-bottom:6px;
    text-shadow:0 0 14px rgba(90,130,255,0.85);
}

.diary-sub {
    font-size:14px;
    color:#b6bfea;
}

/* 영화 정보 */
.movie-box {
    display:flex;
    gap:22px;
    margin:28px 0 32px;
    align-items:center;
}

.movie-poster {
    width:140px;
    border-radius:16px;
    box-shadow:
        0 0 18px rgba(80,120,255,0.45),
        0 0 40px rgba(80,120,255,0.25);
}

.movie-meta {
    flex:1;
}

.movie-title {
    font-size:20px;
    font-weight:700;
    margin-bottom:6px;
}

.movie-info {
    font-size:14px;
    color:#aab3e6;
    margin-bottom:4px;
}

/* 입력 */
.diary-input,
.diary-textarea {
    width:100%;
    background:rgba(10,14,30,0.9);
    border:1px solid rgba(120,150,255,0.28);
    border-radius:14px;
    padding:14px 16px;
    font-size:15px;
    color:#f1f3ff;
    margin-top:8px;
    transition:.18s;
}

.diary-input:focus,
.diary-textarea:focus {
    outline:none;
    border-color:#6f8cff;
    box-shadow:0 0 0 1px rgba(110,140,255,0.4);
    background:rgba(16,22,50,0.95);
}

.diary-textarea {
    min-height:200px;
    resize:none;
    line-height:1.55;
}

/* 버튼 */
.diary-btn {
    padding:12px 26px;
    background:linear-gradient(135deg, #5a7cff, #6f8cff);
    border:none;
    border-radius:999px;
    color:#fff;
    font-size:15px;
    font-weight:700;
    cursor:pointer;
    transition:.22s;
}

.diary-btn:hover {
    transform:translateY(-2px);
    box-shadow:
        0 10px 24px rgba(80,120,255,0.55),
        0 0 24px rgba(80,120,255,0.45);
}

/* 반응형 */
@media (max-width:768px) {
    .diary-card {
        padding:28px 22px 32px;
    }
    .movie-box {
        flex-direction:column;
        align-items:flex-start;
    }
    .movie-poster {
        width:120px;
    }
}
</style>
</head>

<body>

<div class="diary-page">

    <div class="diary-card">

        <!-- 타이틀 -->
        <div class="diary-title">📘 영화 일기 작성</div>
        <div class="diary-sub">
            <%= movie.getTitle() %> · 나만의 감상을 기록해보세요
        </div>

        <!-- 영화 정보 -->
        <div class="movie-box">
            <img src="<%= movie.getPosterUrl() %>" alt="포스터" class="movie-poster">

            <div class="movie-meta">
                <div class="movie-title"><%= movie.getTitle() %></div>
                <div class="movie-info">📅 개봉일 · <%= movie.getReleaseDate() %></div>
                <div class="movie-info">⭐ TMDB 평점 · <%= movie.getRating() %></div>
            </div>
        </div>

        <!-- 폼 -->
        <form action="<%= request.getContextPath() %>/saveDiary" method="post">

            <!-- 기존 파라미터 유지 -->
            <input type="hidden" name="movieId" value="<%= movie.getId() %>">
            <input type="hidden" name="movieTitle" value="<%= movie.getTitle() %>">
            <input type="hidden" name="posterPath" value="<%= movie.getPosterPath() %>">

            <label class="diary-sub">✏ 날짜</label>
            <input type="date" name="date" class="diary-input" required>

            <label class="diary-sub" style="margin-top:18px;">📝 일기 내용</label>
            <textarea name="content"
                      class="diary-textarea"
                      placeholder="이 영화를 보며 어떤 감정이 들었나요?
장면, 대사, 음악, 분위기까지 자유롭게 기록해보세요."
                      required></textarea>

            <!-- 안내 문구 -->
            <div style="margin-top:14px; font-size:12px; color:#8e96c9; text-align:right;">
                ※ 작성한 일기는 <b>마이페이지 → 영화 일기장</b>에서 확인할 수 있어요.
            </div>

            <div style="margin-top:28px; text-align:right;">
                <button type="submit" class="diary-btn">
                    저장하기
                </button>
            </div>

        </form>

    </div>

</div>

</body>
</html>
