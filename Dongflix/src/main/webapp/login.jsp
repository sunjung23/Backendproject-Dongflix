<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/login.css">
</head>
<body>

<div class="login-wrapper">
    <h2>로그인</h2>

    <form action="${pageContext.request.contextPath}/login.do" method="post" class="login-form">

		<input type="hidden" name="redirect" value="${sessionScope.redirectAfterLogin}">
	
        <div class="form-gsroup">
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
            처음이신가요? <a href="join.jsp"> 지금 가입하기</a>
        </p>

    </form>
</div>

</body>

</html>