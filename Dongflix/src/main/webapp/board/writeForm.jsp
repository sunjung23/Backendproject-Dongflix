<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ include file="/common/header.jsp" %>
<%@ page import="com.dongyang.dongflix.dto.MemberDTO" %>

<%
    MemberDTO user = (MemberDTO) session.getAttribute("loginUser");

    if (user == null) {
        response.sendRedirect("../login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시글 작성 - DONGFLIX</title>

<!-- Summernote -->
<link href="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.18/summernote-lite.min.css" rel="stylesheet">
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.18/summernote-lite.min.js"></script>

<style>
/* ===============================================================
   GLOBAL Navy / Royal Blue Theme
=============================================================== */
body {
    margin:0;
    background:#05080f;
    color:#e6e6e6;
    font-family:-apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
}

/* ===============================================================
   Background Area
=============================================================== */
.bg-area {
    min-height:100vh;
    padding:100px 16px;
    display:flex;
    justify-content:center;
    align-items:flex-start;
    background:
        radial-gradient(circle at 20% 15%, rgba(63,111,255,0.25), transparent 60%),
        radial-gradient(circle at 80% 80%, rgba(0,212,255,0.25), transparent 70%),
        #05080f;
}

/* ===============================================================
   Write Container (Glass Navy)
=============================================================== */
.write-container {
    width:100%;
    max-width:780px;
    padding:35px 28px;
    background:rgba(10,15,25,0.92);
    border-radius:22px;
    border:1px solid rgba(120,155,255,0.18);
    box-shadow:0 20px 55px rgba(0,0,0,0.8);
    backdrop-filter:blur(8px);
    position:relative;
}

/* High Light */
.write-container::before {
    content:"";
    position:absolute;
    inset:0;
    border-radius:22px;
    background:linear-gradient(135deg, rgba(63,111,255,0.22), transparent 40%, rgba(0,212,255,0.18));
    opacity:0.45;
    pointer-events:none;
}

.write-container > * { position:relative; z-index:2; }

/* ===============================================================
   Title
=============================================================== */
.title-box h2 {
    font-size:30px;
    font-weight:800;
    background:linear-gradient(90deg,#3F6FFF,#00D4FF,#9be7ff);
    -webkit-background-clip:text;
    color:transparent;
    margin-bottom:6px;
}

.title-sub {
    font-size:14px;
    color:#96a1b5;
    margin-bottom:26px;
}

/* ===============================================================
   Label
=============================================================== */
label {
    display:block;
    font-size:15px;
    color:#cdd7f7;
    margin-bottom:8px;
}

/* ===============================================================
   Inputs & Select
=============================================================== */
select, input {
    width:100%;
    padding:12px 14px;
    background:#0d1321;
    border:1px solid #27335a;
    border-radius:12px;
    color:#e6ebff;
    font-size:14px;
    margin-bottom:20px;
    transition:.25s;
}

select:focus, input:focus {
    outline:none;
    background:#121a33;
    border-color:#3F6FFF;
    box-shadow:0 0 8px rgba(63,111,255,0.45);
}

/* ===============================================================
   Summernote Dark Blue
=============================================================== */
.note-editor.note-frame {
    background:#0d1321 !important;
    border:1px solid #27335a !important;
    border-radius:12px !important;
}

.note-toolbar {
    background:#0a0f1c !important;
    border-bottom:1px solid #27335a !important;
}

.note-editable {
    background:#0d1321 !important;
    color:#e6ebff !important;
    min-height:260px !important;
    line-height:1.65 !important;
}

.note-btn {
    background:#141b2d !important;
    border:1px solid #27335a !important;
    color:#cdd8ff !important;
}

.note-btn:hover {
    background:#1e2742 !important;
}

.dropdown-menu {
    background:#0a0f1c !important;
    border:1px solid #27335a !important;
}
.dropdown-item { color:#e6ebff !important; }
.dropdown-item:hover { background:#1e2742 !important; }

/* ===============================================================
   Error Message
=============================================================== */
.error-msg {
    color:#ff6d6d;
    font-size:13px;
    margin-top:-12px;
    margin-bottom:14px;
    display:none;
}

/* ===============================================================
   Submit Button
=============================================================== */
.write-btn {
    width:100%;
    padding:14px;
    border:none;
    border-radius:12px;
    background:linear-gradient(135deg,#2036CA,#3F6FFF);
    color:#fff;
    font-size:17px;
    font-weight:700;
    cursor:pointer;
    transition:.25s;
}

.write-btn:hover {
    background:linear-gradient(135deg,#3250ff,#00D4FF);
    box-shadow:0 10px 25px rgba(63,111,255,0.6);
    transform:translateY(-2px);
}

/* ===============================================================
   Responsive
=============================================================== */
@media (max-width:600px) {
    .write-container { padding:26px 20px; }
    .title-box h2 { font-size:26px; }
}
</style>
</head>

<body>

<div class="bg-area">
<div class="write-container">

    <div class="title-box">
        <h2>게시글 작성</h2>
        <div class="title-sub">커뮤니티와 당신의 이야기를 공유해보세요.</div>
    </div>

    <form id="writeForm" action="<%=request.getContextPath()%>/board/write" method="post">

        <!-- 카테고리 -->
        <label>카테고리</label>
        <select name="category" id="category">
            <option value="free">📢 자유게시판</option>
            <option value="level">⬆️ 등업게시판</option>
            <% if (user != null && "gold".equalsIgnoreCase(user.getGrade())) { %>
                <option value="secret">🔒 비밀게시판</option>
            <% } %>
        </select>

        <!-- 제목 -->
        <label>제목</label>
        <input type="text" id="title" name="title" placeholder="제목을 입력하세요">
        <div id="titleError" class="error-msg">제목은 최소 2글자 이상 입력해주세요.</div>

        <!-- 내용 -->
        <label>내용</label>
        <textarea id="content" name="content"></textarea>
        <div id="contentError" class="error-msg">내용을 입력해주세요.</div>

        <!-- 버튼 -->
        <button type="submit" class="write-btn">작성하기</button>

    </form>

</div>
</div>

<script>
/* Summernote */
$(document).ready(function() {
    $('#content').summernote({
        placeholder:'내용을 입력하세요...',
        height:260,
        toolbar: [
            ['style', ['bold','italic','underline']],
            ['para', ['ul','ol']],
            ['insert', ['link']],
            ['view', ['fullscreen']]
        ]
    });
});

/* Validation */
document.getElementById("writeForm").addEventListener("submit", function(e){
    const title = document.getElementById("title").value.trim();
    const content = $('#content').summernote('code')
                       .replace(/(<([^>]+)>)/gi,"").trim();

    let valid = true;

    if (title.length < 2) {
        document.getElementById("titleError").style.display = "block";
        valid = false;
    } else {
        document.getElementById("titleError").style.display = "none";
    }

    if (content === "") {
        document.getElementById("contentError").style.display = "block";
        valid = false;
    } else {
        document.getElementById("contentError").style.display = "none";
    }

    if (!valid) e.preventDefault();
});
</script>

</body>
<%@ include file="/common/alert.jsp" %>
</html>
