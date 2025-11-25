<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입</title>
<link rel="stylesheet" href="css/join.css">
</head>
<body>

<div class="join-wrapper">

    <h2>회원가입</h2>

    <form action="join.do" method="post" class="join-form">

        <div class="form-group">
            <input type="text" name="userid" placeholder="아이디" class="form-input">
        </div>

        <div class="form-group">
            <input type="password" name="password" placeholder="비밀번호" class="form-input">
        </div>

        <div class="form-group">
            <input type="text" name="username" placeholder="이름" class="form-input">
        </div>

        <button type="submit" class="btn-join">회원가입</button>
    </form>

    <div class="helper-text">
        이미 계정이 있으신가요?  
        <a href="login.jsp"> 로그인하기</a>
    </div>

</div>

</body>
</html>