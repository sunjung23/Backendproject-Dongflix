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
    body {
        margin:0;
        background:#000;
        color:#fff;
        font-family:-apple-system, BlinkMacSystemFont,"Segoe UI", sans-serif;
    }

    .bg-overlay {
        min-height:100vh;
        background:
            radial-gradient(circle at top, rgba(229,9,20,0.25) 0, transparent 55%),
            #000;
        display:flex;
        align-items:center;
        justify-content:center;
        padding:80px 16px;
        box-sizing:border-box;
    }

    .pw-container {
        width:100%;
        max-width:460px;
        background:rgba(17,17,17,0.96);
        border-radius:18px;
        padding:30px 26px 26px;
        border:1px solid #222;
        box-shadow:0 10px 35px rgba(0,0,0,0.7);
    }

    h2 {
        margin:0 0 8px;
        font-size:23px;
        font-weight:700;
    }

    .sub-text {
        font-size:13px;
        color:#b3b3b3;
        margin-bottom:22px;
    }

    .form-group { margin-bottom:16px; }
    label { display:block; margin-bottom:6px; font-size:13px; }

    input {
        width:100%;
        padding:11px 12px;
        border:none;
        border-radius:9px;
        background:#1f1f1f;
        color:#fff;
        box-sizing:border-box;
        border:1px solid #333;
        font-size:14px;
        transition:border-color .2s, background .2s, box-shadow .2s;
    }

    input:focus {
        outline:none;
        border-color:#e50914;
        background:#232323;
        box-shadow:0 0 0 1px rgba(229,9,20,0.6);
    }

    .btn-save {
        width:100%;
        padding:12px;
        border:none;
        border-radius:9px;
        background:#e50914;
        font-size:15px;
        color:#fff;
        margin-top:10px;
        cursor:pointer;
        font-weight:600;
        transition:background .2s, box-shadow .2s, transform .1s;
    }

    .btn-save:hover {
        background:#b20710;
        box-shadow:0 6px 18px rgba(229,9,20,0.45);
        transform:translateY(-1px);
    }

    .helper {
        margin-top:15px;
        text-align:center;
    }

    .helper a {
        color:#b3b3b3;
        text-decoration:none;
        font-size:13px;
        transition:color .2s;
    }

    .helper a:hover {
        color:#fff;
    }

    .hint {
        font-size:12px;
        color:#777;
        margin-top:3px;
    }

    /* 에러 메시지 표시용 (옵션: 필요 시 사용) */
    .error-msg {
        font-size:12px;
        color:#ff6b6b;
        margin-bottom:4px;
    }

    @media (max-width:600px) {
        .bg-overlay {
            padding:72px 14px;
        }
        .pw-container {
            padding:24px 18px 22px;
            border-radius:14px;
        }
        h2 {
            font-size:21px;
        }
    }
</style>

</head>
<body>

<div class="bg-overlay">
    <div class="pw-container">
        <h2>비밀번호 변경</h2>
        <div class="sub-text">
            비밀번호는 다른 사이트와 겹치지 않게, 영문/숫자/기호를 섞어서 안전하게 설정해주세요.
        </div>

        <form action="changePassword.do" method="post">

            <div class="form-group">
                <label>현재 비밀번호</label>
                <input type="password" name="currentPw" required>
            </div>

            <div class="form-group">
                <label>새 비밀번호</label>
                <input type="password" name="newPw" required>
                <div class="hint">8자 이상, 영문/숫자/기호를 섞어서 추천드려요.</div>
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
</html>
