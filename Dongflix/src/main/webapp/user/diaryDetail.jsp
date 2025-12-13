<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="com.dongyang.dongflix.dto.DiaryDTO" %>

<%@ include file="/common/header.jsp" %>

<%
    DiaryDTO d = (DiaryDTO) request.getAttribute("diary");
    if (d == null) {
        response.sendRedirect(request.getContextPath() + "/myDiaryList");
        return;
    }

    String poster = (d.getPosterPath() != null && !d.getPosterPath().isEmpty())
            ? "https://image.tmdb.org/t/p/w500" + d.getPosterPath()
            : request.getContextPath() + "/img/no_poster.png";
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title><%= d.getMovieTitle() %> - 영화 일기</title>

<style>
/* ===============================
   PREMIUM OTT DIARY DETAIL (REFINED)
=============================== */
:root{
    --bg:#000;
    --glass:rgba(14,18,45,0.82);
    --glass-soft:rgba(18,24,55,0.70);

    --line:rgba(120,150,255,0.28);
    --txt:#eaf0ff;
    --muted:#b6bfea;

    --accent:#3f6fff;
    --danger:#e50914;

    --radius-lg:26px;
    --radius-md:18px;
}

*{ box-sizing:border-box; }

body {
    margin:0;
    padding:0;
    background:var(--bg);
    color:var(--txt);
    font-family:-apple-system, BlinkMacSystemFont,"Segoe UI",sans-serif;
}

/* ===== BACKGROUND ===== */
.detail-bg {
    position:fixed;
    inset:0;
    background:
        radial-gradient(circle at 20% 15%, rgba(120,140,255,0.30), transparent 55%),
        radial-gradient(circle at 80% 85%, rgba(160,120,255,0.24), transparent 55%),
        url('<%= poster %>');
    background-size:cover;
    background-position:center;
    filter:blur(34px) brightness(0.35);
    z-index:-2;
}

/* ===== LAYOUT ===== */
.detail-wrap {
    max-width:1100px;
    margin:120px auto 70px;
    padding:0 24px;
    animation:fadeUp .9s ease-out;
}

@keyframes fadeUp {
    from { opacity:0; transform:translateY(28px); }
    to   { opacity:1; transform:translateY(0); }
}

/* ===== CARD ===== */
.detail-card {
    display:flex;
    gap:44px;
    padding:42px;
    border-radius:var(--radius-lg);
    background:
        linear-gradient(180deg, rgba(20,26,60,0.92), rgba(10,14,32,0.82)),
        var(--glass);
    border:1px solid var(--line);
    backdrop-filter:blur(20px);
    box-shadow:
        0 0 0 1px rgba(255,255,255,0.03) inset,
        0 30px 70px rgba(0,0,0,0.75);
}

/* ===== POSTER ===== */
.poster {
    width:300px;
    border-radius:var(--radius-md);
    object-fit:cover;
    flex-shrink:0;
    box-shadow:
        0 0 24px rgba(120,150,255,0.45),
        0 36px 70px rgba(0,0,0,0.7);
}

/* ===== INFO ===== */
.info { flex:1; }

.meta {
    font-size:13px;
    color:#9aa4d9;
    margin-bottom:8px;
    letter-spacing:0.2px;
}

/* 🔥 제목: 과하지 않은 프리미엄 */
.title {
    font-size:32px;
    font-weight:800;
    margin-bottom:10px;
    color:#f2f5ff;

    /* 아주 미세한 깊이감만 */
    text-shadow:
        0 1px 0 rgba(0,0,0,0.55),
        0 6px 18px rgba(120,150,255,0.25);
}

.date {
    font-size:14px;
    color:var(--muted);
    margin-bottom:26px;
}

/* ===== CONTENT ===== */
.content-box {
    background:
        linear-gradient(180deg, rgba(22,28,65,0.78), rgba(14,18,42,0.72));
    border:1px solid rgba(120,150,255,0.32);
    border-radius:16px;
    padding:28px;
    line-height:1.9;
    font-size:16px;
    color:#e9eeff;
    white-space:pre-line;
    box-shadow:
        0 0 0 1px rgba(255,255,255,0.03) inset,
        0 16px 34px rgba(0,0,0,0.55);
}

/* ===== ACTIONS ===== */
.actions {
    margin-top:34px;
    display:flex;
    gap:14px;
}

.btn {
    padding:13px 26px;
    border-radius:999px;
    font-size:14px;
    font-weight:800;
    cursor:pointer;
    border:none;
    letter-spacing:0.2px;
    transition:.22s ease;
}

/* edit */
.btn-edit {
    background:linear-gradient(180deg, #4b73ff, #3f6fff);
    color:#fff;
}
.btn-edit:hover {
    transform:translateY(-2px);
    box-shadow:
        0 12px 26px rgba(80,120,255,0.45),
        0 0 18px rgba(120,150,255,0.35);
}

/* delete */
.btn-delete {
    background:linear-gradient(180deg, #ff3b3b, #e50914);
    color:#fff;
}
.btn-delete:hover {
    transform:translateY(-2px);
    box-shadow:
        0 12px 26px rgba(255,60,80,0.45),
        0 0 18px rgba(255,60,80,0.35);
}

/* helper */
.helper-text {
    margin-top:18px;
    font-size:12px;
    color:#9aa4d9;
}

/* ===== RESPONSIVE ===== */
@media (max-width:900px) {
    .detail-card {
        flex-direction:column;
        padding:32px 26px;
    }
    .poster {
        width:220px;
        margin:0 auto;
    }
}
</style>
</head>

<body>

<div class="detail-bg"></div>

<div class="detail-wrap">

    <div class="detail-card">

        <img class="poster" src="<%= poster %>" alt="포스터">

        <div class="info">
            <div class="meta">🎬 나의 영화 기록 · 개인 일기</div>

            <div class="title"><%= d.getMovieTitle() %></div>
            <div class="date">작성일 · <%= d.getDiaryDate() %></div>

            <div class="content-box">
                <%= d.getContent() %>
            </div>

            <div class="actions">
                <button class="btn btn-edit"
                    onclick="location.href='<%= request.getContextPath() %>/editDiary?id=<%= d.getId() %>'">
                    ✏ 수정
                </button>

                <button class="btn btn-delete"
                    onclick="return confirm('이 일기는 영구적으로 삭제됩니다.\n정말 삭제하시겠습니까?')
                    && (location.href='<%= request.getContextPath() %>/deleteDiary?id=<%= d.getId() %>')">
                    🗑 삭제
                </button>
            </div>

            <div class="helper-text">
                ※ 이 일기는 마이페이지 → 영화 일기장에서 언제든지 다시 확인할 수 있어요.
            </div>
        </div>

    </div>

</div>

</body>
</html>
