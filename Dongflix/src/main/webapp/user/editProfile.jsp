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
<title>회원정보 수정</title>

<style>
    body {
        background:#000;
        font-family:-apple-system, BlinkMacSystemFont, "Segoe UI";
        color:#fff;
        margin:0;
    }

    .container {
        max-width:500px;
        margin:120px auto;
        background:#111;
        padding:30px;
        border-radius:12px;
        box-shadow:0 5px 20px rgba(0,0,0,0.5);
    }

    h2 { margin-bottom:20px; }

    .form-group { margin-bottom:14px; }
    label { display:block; font-size:14px; margin-bottom:6px; }

    input {
        width:100%;
        padding:10px;
        border-radius:8px;
        border:none;
        background:#222;
        color:#fff;
        font-size:14px;
        box-sizing:border-box;
    }
    input:focus { outline:1px solid #555; }

    .btn-save {
        width:100%;
        background:#e50914;
        padding:12px;
        border:none;
        color:white;
        border-radius:8px;
        font-size:15px;
        cursor:pointer;
        margin-top:15px;
    }
    .btn-save:hover { background:#f6121d; }

    .btn-back {
        display:block;
        margin-top:15px;
        text-align:center;
        color:#bbb;
        text-decoration:none;
        font-size:14px;
    }
    .btn-back:hover { color:#fff; }
</style>

</head>
<body>

<div class="container">
    <h2>회원정보 수정</h2>

    <form action="editProfile.do" method="post">

        <!-- 아이디는 수정 불가 -->
        <div class="form-group">
            <label>아이디</label>
            <input type="text" value="<%= user.getUserid() %>"
                   disabled>
        </div>

        <!-- 이름 -->
        <div class="form-group">
            <label>이름</label>
            <input type="text" name="username" required
                   value="<%= user.getUsername() %>">
        </div>

        <!-- 닉네임 -->
        <div class="form-group">
            <label>닉네임</label>
            <input type="text" name="nickname"
                   value="<%= user.getNickname() != null ? user.getNickname() : "" %>">
        </div>

        <!-- 연락처 -->
        <div class="form-group">
            <label>연락처</label>
            <input type="text" name="phone"
                   value="<%= user.getPhone() != null ? user.getPhone() : "" %>">
        </div>

        <!-- 생일 -->
        <div class="form-group">
            <label>생일</label>
            <input type="date" name="birth"
                   value="<%= user.getBirth() != null ? user.getBirth() : "" %>">
        </div>

        <!-- 프로필 이미지 URL -->
        <div class="form-group">
            <label>프로필 이미지 URL</label>
            <input type="text" name="profileImg"
                   placeholder="이미지 URL을 입력하세요"
                   value="<%= user.getProfileImg() != null ? user.getProfileImg() : "" %>">
        </div>

        <button type="submit" class="btn-save">저장하기</button>

        <a href="mypage.do" class="btn-back">← 마이페이지로 돌아가기</a>
    </form>
</div>

</body>
</html>
