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
<title>비밀번호 변경</title>

<style>
    body {
        background:#000;
        color:#fff;
        margin:0;
        font-family:-apple-system, BlinkMacSystemFont,"Segoe UI";
    }

    .container {
        max-width:450px;
        margin:120px auto;
        padding:30px;
        background:#111;
        border-radius:12px;
        box-shadow:0 5px 20px rgba(0,0,0,0.5);
    }

    h2 {
        margin-bottom:20px;
    }

    .form-group { margin-bottom:15px; }
    label { display:block; margin-bottom:6px; font-size:14px; }

    input {
        width:100%;
        padding:10px;
        border:none;
        border-radius:8px;
        background:#222;
        color:#fff;
        box-sizing:border-box;
    }

    input:focus {
        outline:1px solid #555;
    }

    .btn-save {
        width:100%;
        padding:12px;
        border:none;
        border-radius:8px;
        background:#e50914;
        font-size:15px;
        color:#fff;
        margin-top:15px;
        cursor:pointer;
    }

    .btn-save:hover {
        background:#f6121d;
    }

    .helper { margin-top:15px; text-align:center; }
    .helper a { color:#bbb; text-decoration:none; }
</style>

</head>
<body>

<div class="container">
    <h2>비밀번호 변경</h2>

    <form action="changePassword.do" method="post">

        <div class="form-group">
            <label>현재 비밀번호</label>
            <input type="password" name="currentPw" required>
        </div>

        <div class="form-group">
            <label>새 비밀번호</label>
            <input type="password" name="newPw" required>
        </div>

        <div class="form-group">
            <label>새 비밀번호 확인</label>
            <input type="password" name="newPw2" required>
        </div>

        <button class="btn-save" type="submit">비밀번호 변경하기</button>

        <div class="helper">
            <a href="mypage.do">← 돌아가기</a>
        </div>
    </form>
</div>

</body>
</html>
