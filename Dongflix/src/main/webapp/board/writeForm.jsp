<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ include file="/common/header.jsp" %>

<%
    com.dongyang.dongflix.dto.MemberDTO user =
            (com.dongyang.dongflix.dto.MemberDTO) session.getAttribute("loginUser");

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
   GLOBAL UI - DONGFLIX PREMIUM RED THEME
   =============================================================== */
body {
    margin:0;
    background:#000;
    color:#fff;
    font-family:-apple-system, BlinkMacSystemFont,"Segoe UI",sans-serif;
}

/* ===============================================================
   배경 Glow Effect
   =============================================================== */
.bg-area {
    min-height:100vh;
    padding:100px 16px;
    display:flex;
    justify-content:center;
    align-items:flex-start;
    background:
        radial-gradient(circle at 25% 20%, rgba(229,9,20,0.35), transparent 60%),
        radial-gradient(circle at 75% 80%, rgba(255,50,50,0.25), transparent 60%),
        #000;
}

/* ===============================================================
   메인 작성 컨테이너
   =============================================================== */
.write-container {
    width:100%;
    max-width:780px;
    padding:35px 28px;
    background:rgba(20,20,20,0.97);
    border-radius:20px;
    border:1px solid rgba(255,255,255,0.06);
    box-shadow:0 20px 65px rgba(0,0,0,0.75);
    backdrop-filter:blur(6px);
}

/* ===============================================================
   제목 영역
   =============================================================== */
.title-box h2 {
    font-size:30px;
    font-weight:800;
    background:linear-gradient(90deg,#ff3434,#e50914);
    -webkit-background-clip:text;
    color:transparent;
    margin-bottom:5px;
}

.title-sub {
    font-size:14px;
    color:#cfcfcf;
    margin-bottom:24px;
}

/* ===============================================================
   Label
   =============================================================== */
label {
    display:block;
    color:#e4e4e4;
    font-size:15px;
    margin-bottom:6px;
}

/* ===============================================================
   Input / Select Style
   =============================================================== */
select, input {
    width:100%;
    padding:12px 14px;
    background:#1a1a1a;
    border:1px solid #333;
    border-radius:10px;
    color:#fff;
    font-size:14px;
    margin-bottom:18px;
    transition:.25s;
}

select:focus, input:focus {
    outline:none;
    background:#222;
    border-color:#e50914;
    box-shadow:0 0 0 1px rgba(229,9,20,0.5);
}

/* ===============================================================
   Summernote Custom Dark Mode
   =============================================================== */
.note-editor.note-frame {
    background:#1a1a1a !important;
    border:1px solid #333 !important;
    border-radius:12px !important;
}

.note-toolbar {
    background:#111 !important;
    border-bottom:1px solid #333 !important;
}

.note-editable {
    background:#1a1a1a !important;
    color:#fff !important;
    min-height:240px !important;
}

/* dropdown menu */
.dropdown-menu {
    background:#111 !important;
    border:1px solid #444 !important;
}
.dropdown-item {
    color:#eee !important;
}
.dropdown-item:hover {
    background:#222 !important;
}

/* ===============================================================
   Error Message
   =============================================================== */
.error-msg {
    color:#ff4040;
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
    border-radius:10px;
    background:#e50914;
    color:#fff;
    font-size:17px;
    font-weight:700;
    cursor:pointer;
    transition:0.25s;
}

.write-btn:hover {
    background:#b20710;
    box-shadow:0 8px 20px rgba(229,9,20,0.45);
    transform:translateY(-2px);
}

/* ===============================================================
   Responsive
   =============================================================== */
@media (max-width:600px) {
    .write-container { padding:26px 20px; }
    .title-box h2 { font-size:25px; }
}
</style>
</head>

<body>

<div class="bg-area">
<div class="write-container">

    <div class="title-box">
        <h2>게시글 작성</h2>
        <div class="title-sub">당신의 이야기를 커뮤니티와 공유해보세요.</div>
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
        height:240,
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
</html>
