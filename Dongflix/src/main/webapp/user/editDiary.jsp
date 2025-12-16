<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="com.dongyang.dongflix.dto.DiaryDTO" %>

<%@ include file="/common/header.jsp" %>

<%
    DiaryDTO d = (DiaryDTO) request.getAttribute("diary");
    if (d == null) {
        response.sendRedirect("myDiaryList");
        return;
    }
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title><%= d.getMovieTitle() %> - 일기 수정</title>

<style>

body {
    margin:0;
    padding:0;
    background:#000;
    color:#fff;
    font-family:-apple-system, BlinkMacSystemFont,"Segoe UI",sans-serif;
}

/* 전체 배경 */
.edit-page {
    min-height:100vh;
    padding:110px 20px 80px;
    background:
        radial-gradient(circle at 22% 14%, rgba(80,120,255,0.28), transparent 55%),
        radial-gradient(circle at 78% 88%, rgba(140,170,255,0.22), transparent 55%),
        #000;
}

/* 중앙 카드 */
.edit-card {
    max-width:900px;
    margin:0 auto;
    background:rgba(12,16,40,0.88);
    border-radius:22px;
    padding:36px 38px 40px;
    border:1px solid rgba(120,150,255,0.28);
    backdrop-filter:blur(18px);
    box-shadow:
        0 0 0 1px rgba(255,255,255,0.02),
        0 18px 50px rgba(0,0,0,0.75);
}

/* 헤더 */
.edit-title {
    font-size:24px;
    font-weight:800;
    color:#f2f4ff;
    margin-bottom:6px;
    text-shadow:0 0 14px rgba(90,130,255,0.85);
}

.edit-sub {
    font-size:14px;
    color:#b6bfea;
}

/* 영화 정보 */
.movie-box {
    display:flex;
    gap:22px;
    margin:28px 0 30px;
    align-items:center;
}

.movie-poster {
    width:140px;
    border-radius:16px;
    box-shadow:
        0 0 18px rgba(80,120,255,0.45),
        0 0 40px rgba(80,120,255,0.25);
}

.movie-title {
    font-size:20px;
    font-weight:700;
    margin-bottom:4px;
}

.movie-meta {
    font-size:13px;
    color:#aab3e6;
}

/* 입력 */
.edit-input,
.edit-textarea {
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

.edit-input:focus,
.edit-textarea:focus {
    outline:none;
    border-color:#6f8cff;
    box-shadow:0 0 0 1px rgba(110,140,255,0.4);
    background:rgba(16,22,50,0.95);
}

.edit-textarea {
    min-height:200px;
    resize:none;
    line-height:1.55;
}

/* 버튼 */
.btn-row {
    display:flex;
    justify-content:flex-end;
    gap:12px;
    margin-top:30px;
}

.btn-save {
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

.btn-save:hover {
    transform:translateY(-2px);
    box-shadow:
        0 10px 24px rgba(80,120,255,0.55),
        0 0 24px rgba(80,120,255,0.45);
}

.btn-cancel {
    padding:12px 22px;
    background:rgba(30,34,70,0.9);
    border:1px solid rgba(120,150,255,0.35);
    border-radius:999px;
    color:#c7d2ff;
    font-size:14px;
    cursor:pointer;
    transition:.18s;
}

.btn-cancel:hover {
    background:rgba(50,60,120,0.9);
    color:#fff;
}

/* 반응형 */
@media (max-width:768px) {
    .edit-card {
        padding:26px 22px 30px;
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

<div class="edit-page">

    <div class="edit-card">

        <!-- 타이틀 -->
        <div class="edit-title">✏ 영화 일기 수정</div>
        <div class="edit-sub">
            기록했던 감상을 다시 다듬어보세요
        </div>

        <!-- 영화 정보 -->
        <%
            String poster = (d.getPosterPath() != null && !d.getPosterPath().isEmpty())
                    ? "https://image.tmdb.org/t/p/w500" + d.getPosterPath()
                    : request.getContextPath() + "/img/no_poster.png";
        %>

        <div class="movie-box">
            <img src="<%= poster %>" alt="포스터" class="movie-poster">

            <div>
                <div class="movie-title"><%= d.getMovieTitle() %></div>
                <div class="movie-meta">🗓 작성일 · <%= d.getDiaryDate() %></div>
            </div>
        </div>

        <!-- 수정 폼 -->
        <form action="<%= request.getContextPath() %>/updateDiary" method="post">

            <!-- 기존 파라미터 유지 -->
            <input type="hidden" name="id" value="<%= d.getId() %>">

            <label class="edit-sub">🗓 날짜</label>
            <input type="date" name="date" value="<%= d.getDiaryDate() %>" class="edit-input" required>

            <label class="edit-sub" style="margin-top:18px;">📘 일기 내용</label>
            <textarea name="content" class="edit-textarea" required><%= d.getContent() %></textarea>

            <div class="btn-row">
                <button type="button" class="btn-cancel"
                        onclick="location.href='<%= request.getContextPath() %>/diaryDetail?id=<%= d.getId() %>'">
                    취소
                </button>

                <button type="submit" class="btn-save">
                    저장하기
                </button>
            </div>

        </form>

    </div>

</div>

</body>
</html>
