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

<!-- Summernote -->
<link href="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.18/summernote-lite.min.css" rel="stylesheet">
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.18/summernote-lite.min.js"></script>

<style>
/* ===============================================================
    GLOBAL THEME: DONGFLIX PREMIUM RED
    =============================================================== */
body {
    margin: 0;
    padding: 0;
    background:#000;
    color:#fff;
    font-family:-apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
}

/* =====================================================================
   배경 Glow
   ===================================================================== */
.update-bg {
    min-height: 100vh;
    padding: 100px 16px;
    background:
       radial-gradient(circle at 15% 20%, rgba(229, 9, 20, 0.35), transparent 60%),
       radial-gradient(circle at 85% 85%, rgba(255, 60, 60, 0.25), transparent 60%),
       #000;
    display: flex;
    justify-content: center;
}

/* =====================================================================
   메인 수정 컨테이너
   ===================================================================== */
.update-container {
    width: 100%;
    max-width: 830px;
    padding: 36px;
    background: rgba(20,20,20,0.97);
    border-radius: 20px;
    border: 1px solid rgba(255,255,255,0.08);
    box-shadow: 0 14px 50px rgba(0,0,0,0.75);
    backdrop-filter: blur(6px);
}

/* =====================================================================
   제목 스타일
   ===================================================================== */
.update-container h2 {
    font-size: 30px;
    font-weight: 800;
    margin-bottom: 28px;
    background: linear-gradient(90deg, #ff3434, #e50914);
    -webkit-background-clip: text;
    color: transparent;
    letter-spacing: -0.3px;
}

/* =====================================================================
   form label
   ===================================================================== */
label {
    display: block;
    font-size: 15px;
    color: #ddd;
    font-weight: 500;
    margin-bottom: 8px;
}

/* =====================================================================
    input
   ===================================================================== */
.update-container input {
    width: 100%;
    padding: 12px;
    background: #1b1b1b;
    border: 1px solid #333;
    border-radius: 10px;
    color:#fff;
    font-size:15px;
    transition:.25s;
}

.update-container input:focus {
    outline:none;
    border-color:#e50914;
    background:#222;
    box-shadow:0 0 0 1px rgba(229,9,20,0.6);
}

/* =====================================================================
   에러 문구
   ===================================================================== */
.error-msg {
    font-size:13px;
    margin-top:3px;
    color:#ff4646;
    display:none;
}

/* =====================================================================
   버튼들
   ===================================================================== */
.btn-area {
    margin-top: 28px;
    display:flex;
    justify-content:flex-end;
    gap:14px;
    flex-wrap:wrap;
}

.btn-update {
    padding:12px 22px;
    background:#e50914;
    border:none;
    border-radius:10px;
    font-size:15px;
    color:#fff;
    font-weight:600;
    cursor:pointer;
    transition:.2s;
}

.btn-update:hover {
    background:#b20710;
    box-shadow:0 6px 20px rgba(229,9,20,0.45);
}

.btn-cancel {
    padding:12px 20px;
    background:#444;
    border-radius:10px;
    color:#fff;
    font-size:15px;
    text-decoration:none;
    transition:.2s;
}

.btn-cancel:hover {
    background:#333;
}

/* ===============================================================
   Summernote Dark Mode Custom
   =============================================================== */
.note-editor.note-frame {
    background:#1a1a1a !important;
    color:#fff !important;
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
    font-size:15px !important;
    line-height:1.6 !important;
}

.note-btn {
    background:#222 !important;
    border:1px solid #444 !important;
    color:#ddd !important;
}

.note-btn:hover {
    background:#333 !important;
}

/* ===============================================================
   반응형
   =============================================================== */
@media (max-width: 600px) {
    .update-container { padding:26px; border-radius:16px; }
    .btn-area { flex-direction:column; align-items:stretch; }
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
        <label>제목</label>
        <input type="text" id="title" name="title" value="<%= b.getTitle() %>">
        <div id="titleError" class="error-msg">제목을 입력해주세요.</div>

        <!-- 내용 -->
        <label>내용</label>
        <textarea id="content" name="content"><%= b.getContent() %></textarea>
        <div id="contentError" class="error-msg">내용을 입력해주세요.</div>

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
        height: 300,
        placeholder: '내용을 입력하세요...',
        toolbar: [
            ['style', ['bold', 'italic', 'underline']],
            ['para', ['ul', 'ol']],
            ['insert', ['link']],
            ['view', ['fullscreen']]
        ]
    });
});

/* 입력 검증 */
document.getElementById("updateForm").addEventListener("submit", function(e) {
    let title = document.getElementById("title").value.trim();
    let content = $('#content').summernote('code').replace(/(<([^>]+)>)/gi, "").trim();

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
</html>
