<%@ page contentType="text/html; charset=UTF-8" %>
<%@ include file="/common/header.jsp" %>
<%@ page import="com.dongyang.dongflix.dto.BoardDTO" %>

<%
    BoardDTO b = (BoardDTO) request.getAttribute("dto");
    if (b == null) {
        response.sendRedirect(request.getContextPath() + "/board/list");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시글 수정 - DONGFLIX</title>

<!-- Summernote CDN -->
<link href="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.18/summernote-lite.min.css" rel="stylesheet">
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.18/summernote-lite.min.js"></script>

<style>
/* ===============================================================
   GLOBAL - Navy / Royal Blue Premium Theme
=============================================================== */
body {
    margin: 0;
    padding: 0;
    background: #05080f;  /* 깊은 네이비 */
    color: #e6e6e6;
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
}

/* ===============================================================
   배경 영역
=============================================================== */
.update-bg {
    min-height: 100vh;
    padding: 100px 16px;
    display: flex;
    justify-content: center;
    background:
        radial-gradient(circle at 18% 10%, rgba(63,111,255,0.25), transparent 60%),
        radial-gradient(circle at 85% 80%, rgba(0,212,255,0.25), transparent 70%),
        #05080f;
}

/* ===============================================================
   메인 컨테이너 (Glass Blue)
=============================================================== */
.update-container {
    width: 100%;
    max-width: 830px;
    padding: 36px;
    background: rgba(10,15,25,0.92);
    border-radius: 22px;
    border: 1px solid rgba(120,155,255,0.18);
    box-shadow: 0 20px 55px rgba(0,0,0,0.8);
    backdrop-filter: blur(8px);
    position: relative;
}

/* 하이라이트 효과 */
.update-container::before {
    content: "";
    position: absolute;
    inset: 0;
    border-radius: 22px;
    background: linear-gradient(135deg, rgba(63,111,255,0.18), transparent 40%, rgba(0,212,255,0.15));
    pointer-events: none;
    opacity: 0.5;
}

.update-container > * {
    position: relative;
    z-index: 2;
}

/* ===============================================================
   제목
=============================================================== */
.update-container h2 {
    font-size: 30px;
    font-weight: 800;
    margin-bottom: 26px;
    background: linear-gradient(90deg, #3F6FFF, #00D4FF, #9be7ff);
    -webkit-background-clip: text;
    color: transparent;
}

/* ===============================================================
   INPUT & LABEL
=============================================================== */
label {
    display: block;
    margin-bottom: 8px;
    color: #c9d4ff;
    font-size: 15px;
    font-weight: 500;
}

.update-container input {
    width: 100%;
    padding: 12px;
    background: #0d1321;
    border: 1px solid #27335a;
    border-radius: 10px;
    color: #e6ebff;
    font-size: 15px;
    transition: .25s;
}

.update-container input:focus {
    outline: none;
    background: #121a33;
    border-color: #3F6FFF;
    box-shadow: 0 0 8px rgba(63,111,255,0.5);
}

/* ===============================================================
   ERROR MESSAGE
=============================================================== */
.error-msg {
    font-size: 13px;
    margin-top: 5px;
    color: #ff6d6d;
    display: none;
}

/* ===============================================================
   BUTTON AREA
=============================================================== */
.btn-area {
    margin-top: 26px;
    display: flex;
    justify-content: flex-end;
    gap: 14px;
    flex-wrap: wrap;
}

.btn-update {
    padding: 12px 22px;
    border: none;
    border-radius: 12px;
    background: linear-gradient(135deg, #2036CA, #3F6FFF);
    color: #fff;
    font-size: 15px;
    font-weight: 600;
    cursor: pointer;
    transition: .25s;
}

.btn-update:hover {
    background: linear-gradient(135deg, #3250ff, #00D4FF);
    box-shadow: 0 6px 20px rgba(63,111,255,0.6);
}

.btn-cancel {
    padding: 12px 20px;
    border-radius: 12px;
    background: rgba(12,18,35,0.9);
    border: 1px solid #3F6FFF;
    color: #c9d4ff;
    text-decoration: none;
    transition: .25s;
}

.btn-cancel:hover {
    background: rgba(28,38,75,1);
    color: #fff;
}

/* ===============================================================
   SUMMERNOTE - DARK BLUE CUSTOM
=============================================================== */
.note-editor.note-frame {
    background: #0d1321 !important;
    border: 1px solid #27335a !important;
    border-radius: 12px !important;
}

.note-toolbar {
    background: #0a0f1c !important;
    border-bottom: 1px solid #27335a !important;
}

.note-editable {
    background: #0d1321 !important;
    color: #e6ebff !important;
    min-height: 260px !important;
    line-height: 1.6 !important;
}

.note-btn {
    background: #141b2d !important;
    border: 1px solid #27335a !important;
    color: #cdd8ff !important;
}

.note-btn:hover {
    background: #1e2742 !important;
}

/* ===============================================================
   RESPONSIVE
=============================================================== */
@media (max-width: 600px) {
    .update-container { padding: 26px 22px; }
    .btn-area { flex-direction: column; }
}
</style>
</head>

<body>

<div class="update-bg">
<div class="update-container">

    <h2>게시글 수정</h2>

    <form id="updateForm" action="<%=request.getContextPath()%>/board/update" method="post">

        <input type="hidden" name="id" value="<%= b.getBoardId() %>">

        <!-- 제목 -->
        <label for="title">제목</label>
        <input type="text" id="title" name="title" value="<%= b.getTitle() %>">
        <div id="titleError" class="error-msg">제목을 입력해주세요.</div>

        <!-- 내용 -->
        <label for="content">내용</label>
        <textarea id="content" name="content"><%= b.getContent() %></textarea>
        <div id="contentError" class="error-msg">내용을 입력해주세요.</div>

        <!-- 버튼 -->
        <div class="btn-area">
            <button type="submit" class="btn-update">✔ 수정하기</button>
            <a href="<%=request.getContextPath()%>/board/detail?id=<%= b.getBoardId() %>"
               class="btn-cancel">취소</a>
        </div>

    </form>

</div>
</div>

<script>
/* Summernote 초기화 */
$(document).ready(function() {
    $('#content').summernote({
        height: 280,
        placeholder: '내용을 입력하세요...',
        toolbar: [
            ['style', ['bold','italic','underline']],
            ['para', ['ul','ol']],
            ['insert', ['link']],
            ['view', ['fullscreen']]
        ]
    });
});

/* 입력 검증 */
document.getElementById("updateForm").addEventListener("submit", function(e) {
    let title = document.getElementById("title").value.trim();
    let content = $('#content').summernote('code')
                   .replace(/(<([^>]+)>)/gi, "").trim();

    let valid = true;

    if (title === "") {
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
