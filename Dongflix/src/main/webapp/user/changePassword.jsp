<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="com.dongyang.dongflix.dto.MemberDTO" %>

<%
    MemberDTO user = (MemberDTO) session.getAttribute("loginUser");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>비밀번호 변경 - DONGFLIX</title>

<style>
/* ================================
   GLOBAL PREMIUM NAVY / ROYAL BLUE
================================ */
body {
    margin:0;
    background:#000;
    color:#fff;
    font-family:-apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
}

.bg-overlay {
    min-height:100vh;
    display:flex;
    align-items:center;
    justify-content:center;
    padding:90px 20px;
    background:
        radial-gradient(circle at 20% 10%, rgba(40,70,160,0.25) 0%, transparent 55%),
        radial-gradient(circle at 80% 90%, rgba(90,130,255,0.22) 0%, transparent 55%),
        #000;
}

/* 메인 박스 */
.pw-container {
    width:100%;
    max-width:460px;
    background:rgba(12,14,30,0.94);
    border-radius:24px;
    padding:36px 30px 34px;
    border:1px solid rgba(120,150,255,0.18);
    box-shadow:0 24px 60px rgba(0,0,40,0.85);
    backdrop-filter:blur(8px);
}

/* 제목 */
h2 {
    margin:0 0 6px;
    font-size:25px;
    font-weight:800;
}

.sub-text {
    font-size:13px;
    color:#c1c7ea;
    margin-bottom:26px;
}

/* 입력 폼 */
.form-group { margin-bottom:18px; }

label {
    display:block;
    margin-bottom:6px;
    font-size:13px;
    color:#e8ebff;
}

input {
    width:100%;
    padding:12px 14px;
    border:none;
    border-radius:12px;
    background:#0f1325;
    border:1px solid rgba(100,120,210,0.35);
    color:#e8ebff;
    font-size:14px;
    box-sizing:border-box;
    transition:.22s;
}

input:focus {
    outline:none;
    background:#131a34;
    border-color:#3f6fff;
    box-shadow:0 0 0 2px rgba(80,120,255,0.45);
}

/* 버튼 */
.btn-save {
    width:100%;
    padding:14px 0;
    border:none;
    border-radius:999px;
    background:#3f6fff;
    font-size:15px;
    color:#fff;
    margin-top:12px;
    cursor:pointer;
    font-weight:700;
    transition:.22s;
}

.btn-save:hover {
    background:#5d84ff;
    box-shadow:0 6px 18px rgba(80,120,255,0.45);
    transform:translateY(-1px);
}

/* 링크 */
.helper {
    margin-top:16px;
    text-align:center;
}

.helper a {
    color:#a8b1dd;
    text-decoration:none;
    font-size:13px;
}

.helper a:hover {
    color:#fff;
}

/* 작은 힌트 */
.hint {
    font-size:12px;
    color:#8e96c8;
    margin-top:4px;
}

/* 반응형 */
@media (max-width:600px){
    .pw-container{
        padding:26px 20px 24px;
        border-radius:20px;
    }
    h2{ font-size:22px; }
}
</style>

</head>
<body>

<div class="bg-overlay">
    <div class="pw-container">
        <h2>비밀번호 변경</h2>
        <div class="sub-text">
            영문/숫자/기호 조합을 사용해 더 안전한 비밀번호를 설정해주세요.
        </div>

        <form action="changePassword.do" method="post">

            <div class="form-group">
                <label>현재 비밀번호</label>
                <input type="password" name="currentPw" required>
            </div>

            <div class="form-group">
                <label>새 비밀번호</label>
                <input type="password" name="newPw" required>
                <div class="hint">8자 이상, 영문/숫자/기호 조합을 권장 드려요.</div>
            </div>

            <div class="form-group">
                <label>새 비밀번호 확인</label>
                <input type="password" name="newPw2" required>
            </div>

            <button class="btn-save" type="submit">비밀번호 변경하기</button>

            <div class="helper">
                <a href="mypage.do">← 마이페이지로 돌아가기</a>
            </div>
        </form>
    </div>
</div>



</body>

<!-- ============================
     Premium Navy Alert Modal
============================ -->
<style>
.alert-overlay {
    position:fixed;
    top:0; left:0;
    width:100%; height:100%;
    background:rgba(0,0,0,0.55);
    backdrop-filter:blur(3px);
    display:flex;
    align-items:center;
    justify-content:center;
    z-index:9999;
    animation:fadeIn .25s ease-out;
}

@keyframes fadeIn {
    from { opacity:0; }
    to   { opacity:1; }
}

.alert-box {
    background:rgba(15,18,40,0.95);
    padding:30px 28px;
    border-radius:22px;
    width:90%;
    max-width:360px;
    text-align:center;
    border:1px solid rgba(120,150,255,0.28);
    box-shadow:0 18px 55px rgba(40,60,150,0.55);
    animation:pop .22s ease-out;
}

@keyframes pop {
    from { transform:scale(.85); opacity:.6; }
    to   { transform:scale(1); opacity:1; }
}

.alert-title {
    font-size:19px;
    font-weight:700;
    margin-bottom:12px;
}

.alert-msg {
    font-size:14px;
    color:#ccd5ff;
    line-height:1.5;
    margin-bottom:22px;
}

.alert-btn {
    display:inline-block;
    padding:10px 26px;
    border-radius:12px;
    border:none;
    cursor:pointer;
    font-size:14px;
    font-weight:600;
    transition:.22s;
}

/* 성공 */
.alert-success .alert-title { color:#7ab8ff; }
.alert-success .alert-btn {
    background:#3f6fff;
    color:#fff;
}
.alert-success .alert-btn:hover {
    background:#5e87ff;
}

/* 실패 */
.alert-error .alert-title { color:#ff6b6b; }
.alert-error .alert-btn {
    background:#ff4d4d;
    color:#fff;
}
.alert-error .alert-btn:hover {
    background:#ff6b6b;
}
</style>

<%
    String alertType = (String) request.getAttribute("alertType");  // "success" or "error"
    String alertMsg  = (String) request.getAttribute("alertMsg");   // 실제 메시지
%>

<% if (alertMsg != null && alertType != null) { %>
<div class="alert-overlay">
    <div class="alert-box <%="alert-" + alertType %>">
        <div class="alert-title">
            <%
                if ("success".equals(alertType)) out.print("✔ 성공");
                else out.print("⚠ 오류");
            %>
        </div>

        <div class="alert-msg"><%= alertMsg %></div>

        <button class="alert-btn" onclick="document.querySelector('.alert-overlay').remove();">
            닫기
        </button>
    </div>
</div>
<% } %>

</html>
