<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>DONGFLIX - 로그인</title>

<style>
/* ================================
   PREMIUM NAVY / ROYAL BLUE OTT STYLE
================================ */
* {
    box-sizing: border-box; /* 🔥 정렬 안정화 핵심 */
}

body {
    margin:0;
    padding:0;
    height:100vh;
    background:#000;
    color:#fff;
    font-family:-apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;

    background:
        radial-gradient(circle at 20% 15%, rgba(80,120,255,0.27), transparent 55%),
        radial-gradient(circle at 80% 85%, rgba(140,170,255,0.23), transparent 55%),
        #000;

    display:flex;
    align-items:center;
    justify-content:center;
}

/* 컨테이너 */
.login-wrapper {
    width:100%;
    max-width:430px;
    background:rgba(12,15,35,0.92);
    padding:48px 38px 42px;
    border-radius:28px;

    border:1px solid rgba(120,150,255,0.18);
    box-shadow:0 28px 70px rgba(20,30,70,0.85);
    backdrop-filter:blur(8px);

    animation:fadeIn .35s ease-out;
}

@keyframes fadeIn {
    from { opacity:0; transform:translateY(20px); }
    to   { opacity:1; transform:translateY(0); }
}

/* 제목 */
h2 {
    font-size:27px;
    font-weight:800;
    text-align:center;
    margin-bottom:28px;
    letter-spacing:-0.4px;
    color:#f1f3ff;
}

/* 입력 그룹 */
.form-group {
    margin-bottom:18px;
    display:flex;
    flex-direction:column;
    align-items:stretch;
}

label {
    font-size:14px;
    font-weight:500;
    color:#dbe1ff;
    margin-bottom:6px;
}

/* 입력창 */
.form-input {
    width:100%;
    padding:13px 15px;
    border-radius:12px;
    border:1px solid rgba(100,120,220,0.32);
    background:#0f1325;
    font-size:15px;
    color:#f3f4ff;
    display:block;

    transition:.22s;
}

/* 🔥 비밀번호 input 브라우저 기본 UI 제거 */
input[type="password"] {
    appearance:none;
    -webkit-appearance:none;
    -moz-appearance:none;
}

input[type="password"]::-ms-reveal,
input[type="password"]::-ms-clear {
    display:none;
}

/* 포커스 */
.form-input:focus {
    outline:none;
    background:#131a34;
    border-color:#3f6fff;
    box-shadow:0 0 0 2px rgba(80,120,255,0.45);
}

/* 로그인 버튼 */
.btn-login {
    width:100%;
    padding:14px 0;
    border:none;
    border-radius:999px;
    background:#3f6fff;
    font-size:16px;
    font-weight:700;
    color:#fff;
    cursor:pointer;
    margin-top:6px;
    transition:.22s;
}

.btn-login:hover {
    background:#678aff;
    transform:translateY(-2px);
    box-shadow:0 10px 20px rgba(80,120,255,0.45);
}

/* 하단 텍스트 */
.helper-text {
    margin-top:20px;
    text-align:center;
    font-size:14px;
    color:#b7bee3;
}

.helper-text a {
    color:#94acff;
    font-weight:600;
    text-decoration:none;
    transition:.22s;
}

.helper-text a:hover {
    color:#c4d3ff;
}

/* 모바일 */
@media (max-width: 500px){
    .login-wrapper {
        padding:38px 22px 32px;
        border-radius:22px;
    }

    h2 {
        font-size:24px;
    }
}
</style>

</head>
<body>

<div class="login-wrapper">
    <h2>로그인</h2>

    <form action="${pageContext.request.contextPath}/login.do" method="post">

        <input type="hidden" name="redirect" value="${sessionScope.redirectAfterLogin}">

        <div class="form-group">
            <label for="userid">아이디</label>
            <input type="text" id="userid" name="userid"
                   class="form-input" placeholder="아이디를 입력하세요">
        </div>

        <div class="form-group">
            <label for="password">비밀번호</label>
            <input type="password" id="password" name="password"
                   class="form-input" placeholder="비밀번호를 입력하세요">
        </div>

        <button type="submit" class="btn-login">로그인</button>

        <p class="helper-text">
            처음이신가요? <a href="join.jsp">회원가입</a>
        </p>

    </form>
</div>

</body>
</html>
